Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C63651B1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389095; cv=none; b=pkvVr6NhUCTrchFQS+dtIEChCkJ9aqGOkW1gUSv7IxHVXubCRzIZxIRkMvSLaW28umH/KdlHQshj+7UmP9O7t2ZuNTGlEcMxke0Rkdoav4X21uSXdni07vWIDk5pXjcMuWNkIODG6+FVMaZfHG9jz1m1Yz10Dkk5sC4CIJNowHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389095; c=relaxed/simple;
	bh=YU41Q1KMRC+1N1+og1TL0UPC6ENjADYW7+reTTWS6is=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uMZJlKF0LyO0/xF+oCXIv4SUjSIhLmdZdqhsiyOITTBhcu/59z+VPgnKPMfLf1HAGQy/IQWdWloPEGamFj81Yi8/EFB2x3RPP2h6stzjv1xy3z59HyEY2wlXylS4lF8G1eFFXt6bazxEIh0qGcg7OT5n4a1FzPyJEO2z1xSPjPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONi6ouQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ONi6ouQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07EEC072AA;
	Wed, 17 Apr 2024 21:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389094;
	bh=YU41Q1KMRC+1N1+og1TL0UPC6ENjADYW7+reTTWS6is=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ONi6ouQTKXT+PACXv3RbhmZRBtx3Cu9NGM7MKcgnOoxmqQnsOdR/HUAytf4auBgSq
	 /0ixBv1uAQ6mYpI4J2/ce3MpM1G8no2UO5K8VLxcalPbV9OAWcrVI8U54Vhu5Oi1iT
	 B9frh7nctkyOnfs98pKmw4fbC02d7uxDE6sHUOmE9K+A9kX9WNvaA6G2narI3uRmqW
	 QqYEE2Lx1jMUkgqrJdOaqrUMohl9jsijTj2aGDnVWmV7/+Tkk0ie60m2/bmb6s952H
	 xFPi+D9/uGmaBZ3qeIMNyfzY664PGr82c/E3Y8RSfqCHgfQ2bd3YZ4zVrjDPnusBHl
	 2Aea3Ah0u71SA==
Date: Wed, 17 Apr 2024 14:24:54 -0700
Subject: [PATCH 12/67] xfs: fix 32-bit truncation in xfs_compute_rextslog
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842520.1853449.11391750048576321208.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: cf8f0e6c1429be7652869059ea44696b72d5b726

It's quite reasonable that some customer somewhere will want to
configure a realtime volume with more than 2^32 extents.  If they try to
do this, the highbit32() call will truncate the upper bits of the
xfs_rtbxlen_t and produce the wrong value for rextslog.  This in turn
causes the rsumlevels to be wrong, which results in a realtime summary
file that is the wrong length.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_rtbitmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 90fe90288..726543abb 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1130,14 +1130,16 @@ xfs_rtbitmap_blockcount(
 
 /*
  * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
- * prohibits correct use of rt volumes with more than 2^32 extents.
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
  */
 uint8_t
 xfs_compute_rextslog(
 	xfs_rtbxlen_t		rtextents)
 {
-	return rtextents ? xfs_highbit32(rtextents) : 0;
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
 }
 
 /*

