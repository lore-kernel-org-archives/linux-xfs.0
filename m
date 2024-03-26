Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5E857314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423220; cv=none; b=NLzjhu5wr+68Jlw00/NCV4xen7di63X7z6oFU2Utq7Ww7edrXOf3HX20cmL/GfFhLA+NeG29B3Nmy6yIVRGYjzhDJLS2OL889jx8kRGuEPgNpUWlKj74ZhJ+XXKeCNTRGHbsYIliI6dZqOhUGYwdichsOYSijLIiEwvWbiy4xGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423220; c=relaxed/simple;
	bh=BT5yQ6qQ+dzD1V1RI8/ScIS3BjbjVmi/27rmYgltvSI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LL2fXC7Q5bO/Xh4KYM0nWeBSWnIcyHlizNGJ3EjaY+UFki+mcR7il9snSeHRXPYg9jxKOKM6EjqlnUCcObe5obcaGC9AbYKfDTYRUrKqKjfNDo6QN2JErKIEVv8L6dat/4xzOfZxDiKNKKW5StZsaV3HHAJU+7i9wx73hU2VzEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hpLuZU4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hpLuZU4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15ADC433C7;
	Tue, 26 Mar 2024 03:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423219;
	bh=BT5yQ6qQ+dzD1V1RI8/ScIS3BjbjVmi/27rmYgltvSI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hpLuZU4wzhkhhg5QC8SOk5bVCUm8mxuJLkSGasfU0jd9OFZBI/WnAI2Wq80PPvS1G
	 QwENMyvagINXa/STX5R5HT/GocF+s93Qj//FOENXrxGuopaoBCyRpBlHWVRaQzseKJ
	 Ae7Yhyhhv9naaDuLjVfKwAk2uePpLvgqQqM8n8wzf9WKxYsjLDwjeH/l618wIsCR5E
	 BxgvDrn7UXOKu4zP+8iqXz00zvCVs43Vk16QH/hsJvh1ovgAtCMXWCQMy1kKV8JGJq
	 BcRfEsrZPd+5vZIJNvl5jPFrPJqUA6BpblSKP3DokVxqpzw+VAe3IHyaUrVTCBwLVU
	 YA2ix2p9EO5sA==
Date: Mon, 25 Mar 2024 20:20:19 -0700
Subject: [PATCH 67/67] xfs: remove conditional building of rt geometry
 validator functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127923.2212320.10753596274502631913.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: 881f78f472556ed05588172d5b5676b48dc48240

I mistakenly turned off CONFIG_XFS_RT in the Kconfig file for arm64
variant of the djwong-wtf git branch.  Unfortunately, it took me a good
hour to figure out that RT wasn't built because this is what got printed
to dmesg:

XFS (sda2): realtime geometry sanity check failed
XFS (sda2): Metadata corruption detected at xfs_sb_read_verify+0x170/0x190 [xfs], xfs_sb block 0x0

Whereas I would have expected:

XFS (sda2): Not built with CONFIG_XFS_RT
XFS (sda2): RT mount failed

The root cause of these problems is the conditional compilation of the
new functions xfs_validate_rtextents and xfs_compute_rextslog that I
introduced in the two commits listed below.  The !RT versions of these
functions return false and 0, respectively, which causes primary
superblock validation to fail, which explains the first message.

Move the two functions to other parts of libxfs that are not
conditionally defined by CONFIG_XFS_RT and remove the broken stubs so
that validation works again.

Fixes: e14293803f4e ("xfs: don't allow overly small or large realtime volumes")
Fixes: a6a38f309afc ("xfs: make rextslog computation consistent with mkfs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_rtbitmap.c |   14 --------------
 libxfs/xfs_rtbitmap.h |   16 ----------------
 libxfs/xfs_sb.c       |   14 ++++++++++++++
 libxfs/xfs_sb.h       |    2 ++
 libxfs/xfs_types.h    |   12 ++++++++++++
 5 files changed, 28 insertions(+), 30 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 79af7cda3441..08a4128fc524 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1116,20 +1116,6 @@ xfs_rtbitmap_blockcount(
 	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
 }
 
-/*
- * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
- * use of rt volumes with more than 2^32 extents.
- */
-uint8_t
-xfs_compute_rextslog(
-	xfs_rtbxlen_t		rtextents)
-{
-	if (!rtextents)
-		return 0;
-	return xfs_highbit64(rtextents);
-}
-
 /*
  * Compute the number of rtbitmap words needed to populate every block of a
  * bitmap that is large enough to track the given number of rt extents.
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 274dc7dae1fa..152a66750af5 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -351,20 +351,6 @@ xfs_rtfree_extent(
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 		xfs_filblks_t rtlen);
 
-uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
-
-/* Do we support an rt volume having this number of rtextents? */
-static inline bool
-xfs_validate_rtextents(
-	xfs_rtbxlen_t		rtextents)
-{
-	/* No runt rt volumes */
-	if (rtextents == 0)
-		return false;
-
-	return true;
-}
-
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
@@ -383,8 +369,6 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 # define xfs_rtsummary_read_buf(a,b)			(-ENOSYS)
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
-# define xfs_compute_rextslog(rtx)			(0)
-# define xfs_validate_rtextents(rtx)			(false)
 static inline xfs_filblks_t
 xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 {
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 7a72d5a17910..402f03a557e0 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1375,3 +1375,17 @@ xfs_validate_stripe_geometry(
 	}
 	return true;
 }
+
+/*
+ * Compute the maximum level number of the realtime summary file, as defined by
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
+ */
+uint8_t
+xfs_compute_rextslog(
+	xfs_rtbxlen_t		rtextents)
+{
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
+}
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 19134b23c10b..2e8e8d63d4eb 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -38,4 +38,6 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
 		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
 
+uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
+
 #endif	/* __XFS_SB_H__ */
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 20b5375f2d9c..62e02d5380ad 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -251,4 +251,16 @@ bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
 bool xfs_verify_fileext(struct xfs_mount *mp, xfs_fileoff_t off,
 		xfs_fileoff_t len);
 
+/* Do we support an rt volume having this number of rtextents? */
+static inline bool
+xfs_validate_rtextents(
+	xfs_rtbxlen_t		rtextents)
+{
+	/* No runt rt volumes */
+	if (rtextents == 0)
+		return false;
+
+	return true;
+}
+
 #endif	/* __XFS_TYPES_H__ */

