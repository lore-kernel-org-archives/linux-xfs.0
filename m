Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2C07484;
	Tue, 18 Jun 2024 00:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671981; cv=none; b=bsBaK9HsK138KDzXSjy3L6itEj1vfS8sy7VrbHM0++H9TAr+8S1VR9jko0BQivZ0dlEIHFURyi2devBrwU+BP8SZXCb7sFI+Os0nQiCIjGE4TUgMIkmlY3/80wHLLuysITmcEFO8TgkQIUM92Cl1+LvCMS7pYedqwfr4jSa6kck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671981; c=relaxed/simple;
	bh=ate/n/7EZqFDqv6C3/eZ3XJivaZoR9DfaM06BI7v3YQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=klZtsTfMlKAcKVUKunpHqCa3x2S8H3CJYEGc7oad7oDXMLSLiBYz1yIQg+C8LaCMDQuXJl91jG5Ej8xIb+ReYk4AXnE2x0lviCA7kpJeyRmjBSRVFZxjObd6IKq9EJff5pQujp/8xFkyO+pdND02Op3a7wbuXan5jHeb1zOLht0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hR3JiBZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hR3JiBZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DECC4AF1D;
	Tue, 18 Jun 2024 00:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671981;
	bh=ate/n/7EZqFDqv6C3/eZ3XJivaZoR9DfaM06BI7v3YQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hR3JiBZjj8hWGXPjpDh5KYvn2UTdW2IQHoHoqJ0ZAnqfq+ClkksN5zi2zTo+3qP4n
	 jUWXtsubvsiTcqY41TfCNPVDCYCjvI457P18OH4pMse8LjBmB1GbTcRgE1BvJavTe+
	 6j2ejgy+Srg+lVs/KUknxXuHWNBzankTJFSBrptU5yEl1vKANc2DiI1AFtxKU2nvQN
	 xwbJBrJjtNsTt/ds2/j1WQJRx11+GZ7pZzxGZCtlAWCN1qtnfta2NRZQckw+3RSutk
	 ADbFnkjc20bUqVyuEGU5G8EkixoAuZi445Ag2q9GKbRGl3p+TUySHlgqHstBpSUWgG
	 iUwBC/8JyEYOQ==
Date: Mon, 17 Jun 2024 17:53:00 -0700
Subject: [PATCH 1/1] xfs/122: update for vectored scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867146699.794493.17172507664394990879.stgit@frogsfrogsfrogs>
In-Reply-To: <171867146683.794493.16529472298540078897.stgit@frogsfrogsfrogs>
References: <171867146683.794493.16529472298540078897.stgit@frogsfrogsfrogs>
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

Add the two new vectored scrub structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 7be14ed993..60d8294551 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -124,6 +124,8 @@ sizeof(struct xfs_rtrmap_root) = 4
 sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64
+sizeof(struct xfs_scrub_vec) = 16
+sizeof(struct xfs_scrub_vec_head) = 40
 sizeof(struct xfs_swap_extent) = 64
 sizeof(struct xfs_unmount_log_format) = 8
 sizeof(struct xfs_xmd_log_format) = 16

