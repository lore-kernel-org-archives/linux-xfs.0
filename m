Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5C0DF59;
	Fri, 11 Oct 2024 01:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611031; cv=none; b=GnBqGIbpcCNOQqhnJgNO76i/Ugd+U2JhSyNvwsf5cEHiJYnlsKjLOWQ6eHEgkojY0ypJYil4FekKGXXJ3OnZuWuBXFoCsZoAuaKUMa39VDZfNxEBT6TGPzk6IT1hcbjVYReR2A4xB89y5kSMfA7T2IX/T/X4hNCYJY0MS2HgVaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611031; c=relaxed/simple;
	bh=4/HqLGPkmsKeavT9WCdU5Pgplk8RAq8VCvFJfY+lmVs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cWr8hzs43e4ohG+F1UIdpPX1QGW9uaz2atgU38J0De3x3SImoVMT5kyBHjdh+S7vxqV4uTiiurC7PV//PHG/iJ2+Ym6+43skzwUi484q0DIcue4joAu87KF5ordI5Q/Kytg59LxFy9EeXDLC5j9tQs2WmH/oGFRgBpKfoOqWGI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tpHxW5W+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tpHxW5W+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEABC4CEC5;
	Fri, 11 Oct 2024 01:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611031;
	bh=4/HqLGPkmsKeavT9WCdU5Pgplk8RAq8VCvFJfY+lmVs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tpHxW5W+T/uJgZ8/4aSCKncrWvYswo2hKuRykKEHB6yt+dFBUoNrblrSgfk4rv0yI
	 3QC339hhRsz3VHFADsrOGsXSKH6LIz5hgwC24dMVt/BX2P5O0y86viUAJZBi5Ejxqw
	 9GW1J5Xs/T4MawGTclfq7SUG9dw6tCj4GKW5Ao47z/bw5RgN5owGrchY7juSgTQvMT
	 uDCm9r5q9/LkOgxgCkAp0S0Fx9+haaWvlllAa5W6tjoPAFQX20ROGLK6VZA+vmzvbS
	 1kBtru26JT/JJOV69r7u8ysiZmIouG20XvH4qh3xvIdgucC5LSF/JXJ5mfqWps/omG
	 5Ahl+26pHwc0A==
Date: Thu, 10 Oct 2024 18:43:50 -0700
Subject: [PATCH 11/16] xfs/449: update test to know about xfs_db -R
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658688.4188964.17314891473424728796.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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

The realtime groups feature added a -R flag to xfs_db so that users can
pass in the realtime device.  Since we've now modified the
_scratch_xfs_db to use this facility, we can update the test to do exact
comparisons of the xfs_db info command against the mkfs output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/449 |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/449 b/tests/xfs/449
index 3d528e03a483fb..a739df50e319c5 100755
--- a/tests/xfs/449
+++ b/tests/xfs/449
@@ -30,7 +30,11 @@ echo DB >> $seqres.full
 cat $tmp.dbinfo >> $seqres.full
 # xfs_db doesn't take a rtdev argument, so it reports "realtime=external".
 # mkfs does, so make a quick substitution
-diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
+if $XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev'; then
+	diff -u $tmp.mkfs $tmp.dbinfo
+else
+	diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
+fi
 
 _scratch_mount
 

