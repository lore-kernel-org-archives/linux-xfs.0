Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5739F7464
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302018; cv=none; b=pqjAl8/WnFAd1ZLB3v1864La2z/4pFC0rn/GnzKE+CMJNyOb0Qyk4AyMXgplxhikqJ5ng3r0ZZ8EQNMxHABke1HPozTJD029XDMr9uAAvuYULAr2dEDSr0n8r+SlmDYJgb0IJgnsmn882bsu3vQ/uAxu8JkubvtaSKjsasmcicQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302018; c=relaxed/simple;
	bh=VTutdpIFCEM0YB8M9Gf36qvLfzxXZOPjIBa186XkCMM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c+4oZNC4MYtvNI1B48e7IEZza18id2meYCCOBh8NREG2cTIsHwfnZ9edTFXpBxjkMIcVvdBBhWG8P9UBx4dv+so2In1hgig3eMVaa47+2tRekRMtftAluYGx3Zk5f6iJ/DiXSo/EMIFhK75TdalmmtEdgUWXmg+ldDDxsnI63Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hk1d/mVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hk1d/mVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C62C32786;
	Tue, 30 Jul 2024 01:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302018;
	bh=VTutdpIFCEM0YB8M9Gf36qvLfzxXZOPjIBa186XkCMM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hk1d/mVusw0NNod9bF73svGPAb2W0ZWoHpI8lS2/Cv5sESoa/7G09aoy1mRZGojVJ
	 iVSggNsWUhxrZGte5ld1nhLfKC3bHRNIXhowvn6qKyYX18Y7wKC6qIYgUOdM+1TmBW
	 0FEOjQvDM65jLAHFOOnqOcUOKBDQITBN+E1YeUV8k6XiH1kpQiO6mc7HJr1SmJWIpL
	 RHmfAunUE28fKpYq62mP6sRaps3M9dXIDdB3NY5UsKWnP7rXMu+ryQAL6ojpxWer6l
	 F8MnEvYwaL8wcQapzo49F/7MDyAzk7JngUV1gb3wiSBIRfaWbIA2Cvhoru6hx1Ob/n
	 29eZ6S+6gxIew==
Date: Mon, 29 Jul 2024 18:13:37 -0700
Subject: [PATCH 3/6] xfs_scrub: use dynamic users when running as a systemd
 service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Helle Vaanzinn <glitsj16@riseup.net>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172229848903.1349910.11661470792666399204.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848851.1349910.300458734867859926.stgit@frogsfrogsfrogs>
References: <172229848851.1349910.300458734867859926.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Five years ago, systemd introduced the DynamicUser directive that
allocates a new unique user/group id, runs a service with those ids, and
deletes them after the service exits.  This is a good replacement for
User=nobody, since it eliminates the threat of nobody-services messing
with each other.

Make this transition ahead of all the other security tightenings that
will land in the next few patches, and add credits for the people who
suggested the change and reviewed it.

Link: https://0pointer.net/blog/dynamic-users-with-systemd.html
Suggested-by: Helle Vaanzinn <glitsj16@riseup.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub@.service.in |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 855fe4de4..52068add8 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -17,7 +17,6 @@ ProtectHome=read-only
 PrivateTmp=no
 AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
 NoNewPrivileges=yes
-User=nobody
 Environment=SERVICE_MODE=1
 ExecStart=@sbindir@/xfs_scrub @scrub_args@ %f
 SyslogIdentifier=%N
@@ -31,3 +30,6 @@ Nice=19
 # Create the service underneath the scrub background service slice so that we
 # can control resource usage.
 Slice=system-xfs_scrub.slice
+
+# Dynamically create a user that isn't root
+DynamicUser=true

