Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275880;
	b=EnLy6OwaFK7C2jdnJ81tZVp5HbAYkPphdDwMBulpF5W2XsfWCD9HDYa+0gS1KBANmR4i
	 AqeDXRr3l+ltWY6Qy6A7cQmAUxtXN11nvpEZy/7lpeuvU6M8XngTDHVBKri51dzAdOUaj
	 4R5P0jnnH1PiyhyEVo8Fkr9tnsN04XVQqW/psHNkjl+SFHvxFDwU5ZnaEiJ9SqEn1tjxb
	 ZGwihnJSK4+ivpIL8+3RiTQ24xnQ9T3aTSVqYiQ0xeuZy3swVgRXAaJZsoqJH/WjnrN/m
	 h14wnsHWmXHoxCbhjqrVqwFW80jahSPWTtVw2JjQ2LjlghTm2gehsuR4CdJ74X/loKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Vdi4RI57/8HBuq3lEBzh5iOQziSY6e9znEeGqNNMa8o=;
	b=5fcPLylurXcvm0S2HriSdQ60ocVjxpbWs+bkWEEF6EwrxjJlpzrYXOfCOqLQGLrQtrm/
	 PaiGIuQGVNxAkJY5yrWvjydFlKUmPrpiflcmi7ufBltbrexi0uls8tVeb8Ui/2jU8TFEL
	 GrsANhGEk9jT22g0Id1zg4RdmUNKllh3cvv1kYYmI4B+DBL4WsatPvC31EyJrFBh/M9s6
	 y38Hy3sbkXRPp3RZrqcSl5fhvl0Kj8zMWiLAOnzpZD8wedATiVHN1+QbSsgRKgGix/5/+
	 rJ8pOk2F00gReAsDmqSJk34jwGLkGSJcesenfpRbTbHsCcUQdCbSCU41Sch1hi/3kSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="AQ/Nax+8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64455606A329
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQ/Nax+8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770671F031E3;
	Thu, 29 Oct 2026 12:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275880;
	bh=Vdi4RI57/8HBuq3lEBzh5iOQziSY6e9znEeGqNNMa8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQ/Nax+8hEd93eWiunLOTAmCx4lq17RrmX4AOSZjpjXBEUuPJkl2dXgknRe+W0Wie
	 8mpAm8RT1Zmph37QZIDTtqpwAcFIwCMLoKMMVhS8BJDQcZijo3nEsTLrIGAvsn1bQw
	 FWbzWuNYnLRCjU0qZSKjGvjDg7VoCMDnA8QARTi99azzihW9/17ErfK5x8h9TOQD0j
	 wUIjD0WEOUFeeks6M4OQ+2SLBuEZDNv3x0HYhbMwll+bOberUDiMhjl5Nbrhi7MKKo
	 Ka2y3kkaWI+56bC/TAbc1F3ZFkuF4uzjQ2LK5i9+MGay0WSqXTnZhYsPxY0k57oxpD
	 SApCD9ua1UaKg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 27/28] xfs: stop exchanging reflink flags when exchanging mappings
Date: Thu, 29 Oct 2026 13:06:24 +0100
Message-ID: <20261029120631.803074-28-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Norbert Szetei <norbert@doyensec.com>

Source kernel commit: d84d6c1a7f1e2de9e601703a326a4c1b7b421943

When an exchange covers both files from offset 0 to i_disk_size,
xmi_can_exchange_reflink_flags() assumes every mapping moved and hands
the reflink flag over to the other file.

That assumption is wrong.  A file can still own shared blocks past
i_disk_size, e.g. after EXCHANGE_RANGE_TO_EOF sets a smaller size
without unmapping anything.  The flag is cleared anyway, and the next
write to such a block happens in place instead of CoW, corrupting the
other file that shares it.

Commit a23eca88448e ("xfs: fix exchange-range reflink flag clearing
issue with INO1_WRITTEN") fixed one instance of this.  Rather than add
another special case, stop moving the flags.
xfs_exchmaps_ensure_reflink() already sets the flag on both inodes
before the exchange, so both just keep it.

Nothing sets CLEAR_INO{1,2}_REFLINK anymore.  Intents logged by older
kernels may still carry them; recovery already masks them off, so they
stay in the log format mask and are ignored.

XFS_IOC_SWAPEXT has the same problem: it moves the reflink flag from
one inode to the other along with the extents.  Just removing that is
not enough here: the exchange path flags both inodes up front in
xfs_exchmaps_ensure_reflink(), but swapext has no such step, so the
inode receiving the shared extents would be left without the flag.
Set it on both inodes instead, and make sure both have a CoW fork,
since an inode with the reflink flag is expected to have one.

The flag now stays until FALLOC_FL_UNSHARE_RANGE, xfs_scrub, or a
truncate to zero removes it.

Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Fixes: f0bc4d134b46 ("xfs: swap inode reflink flags when swapping inode extents")
Assisted-by: LLM
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_exchmaps.c   | 80 ++---------------------------------------
 libxfs/xfs_log_format.h |  4 +--
 2 files changed, 4 insertions(+), 80 deletions(-)

diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 9562784dd53d..204d06ed091e 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -48,7 +48,7 @@ struct xfs_exchmaps_adjacent {
 	.right2 = { .br_startblock = HOLESTARTBLOCK }, \
 }
 
-/* Information to reset reflink flag / CoW fork state after an exchange. */
+/* Information to reset CoW fork state after an exchange. */
 
 /*
  * If the reflink flag is set on either inode, make sure it has an incore CoW
@@ -126,9 +126,7 @@ xmi_has_more_exchange_work(const struct xfs_exchmaps_intent *xmi)
 static inline bool
 xmi_has_postop_work(const struct xfs_exchmaps_intent *xmi)
 {
-	return xmi->xmi_flags & (XFS_EXCHMAPS_CLEAR_INO1_REFLINK |
-				 XFS_EXCHMAPS_CLEAR_INO2_REFLINK |
-				 __XFS_EXCHMAPS_INO2_SHORTFORM);
+	return xmi->xmi_flags & __XFS_EXCHMAPS_INO2_SHORTFORM;
 }
 
 /* Check all mappings to make sure we can actually exchange them. */
@@ -524,18 +522,6 @@ free:
 	return error;
 }
 
-/* Clear the reflink flag after an exchange. */
-static inline void
-xfs_exchmaps_clear_reflink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	trace_xfs_reflink_unset_inode_flag(ip);
-
-	ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-}
-
 /* Finish whatever work might come after an exchange operation. */
 static int
 xfs_exchmaps_do_postop_work(
@@ -556,16 +542,6 @@ xfs_exchmaps_do_postop_work(
 			return error;
 	}
 
-	if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO1_REFLINK) {
-		xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip1);
-		xmi->xmi_flags &= ~XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
-	}
-
-	if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO2_REFLINK) {
-		xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip2);
-		xmi->xmi_flags &= ~XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
-	}
-
 	return 0;
 }
 
@@ -947,46 +923,13 @@ xfs_exchmaps_intent_destroy_cache(void)
 }
 
 /*
- * Decide if we will exchange the reflink flags between the two files after the
- * exchange.  The only time we want to do this is if we're exchanging all
- * mappings under EOF and the inode reflink flags have different states.
+ * Allocate and initialize a new incore intent item from a request.
  */
-static inline bool
-xmi_can_exchange_reflink_flags(
-	const struct xfs_exchmaps_req	*req,
-	unsigned int			reflink_state)
-{
-	struct xfs_mount		*mp = req->ip1->i_mount;
-
-	/*
-	 * The INO1_WRITTEN optimization can skip exchanging hole and
-	 * unwritten mappings, which means we cannot guarantee that all
-	 * shared extents actually moved to the other file.  Clearing the
-	 * reflink flag of an inode that still holds shared extents breaks
-	 * the CoW write path, so refuse to exchange the flags in that case.
-	 */
-	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
-		return false;
-
-	if (hweight32(reflink_state) != 1)
-		return false;
-	if (req->startoff1 != 0 || req->startoff2 != 0)
-		return false;
-	if (req->blockcount != XFS_B_TO_FSB(mp, req->ip1->i_disk_size))
-		return false;
-	if (req->blockcount != XFS_B_TO_FSB(mp, req->ip2->i_disk_size))
-		return false;
-	return true;
-}
-
-
-/* Allocate and initialize a new incore intent item from a request. */
 struct xfs_exchmaps_intent *
 xfs_exchmaps_init_intent(
 	const struct xfs_exchmaps_req	*req)
 {
 	struct xfs_exchmaps_intent	*xmi;
-	unsigned int			rs = 0;
 
 	xmi = kmem_cache_zalloc(xfs_exchmaps_intent_cache,
 			GFP_NOFS | __GFP_NOFAIL);
@@ -1010,23 +953,6 @@ xfs_exchmaps_init_intent(
 		xmi->xmi_isize2 = req->ip1->i_disk_size;
 	}
 
-	/* Record the state of each inode's reflink flag before the op. */
-	if (xfs_is_reflink_inode(req->ip1))
-		rs |= 1;
-	if (xfs_is_reflink_inode(req->ip2))
-		rs |= 2;
-
-	/*
-	 * Figure out if we're clearing the reflink flags (which effectively
-	 * exchanges them) after the operation.
-	 */
-	if (xmi_can_exchange_reflink_flags(req, rs)) {
-		if (rs & 1)
-			xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
-		if (rs & 2)
-			xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
-	}
-
 	if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode) ||
 	    S_ISLNK(VFS_I(xmi->xmi_ip2)->i_mode))
 		xmi->xmi_flags |= __XFS_EXCHMAPS_INO2_SHORTFORM;
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index a4e1b3eb425c..6e620380d5dc 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -927,10 +927,8 @@ struct xfs_xmi_log_format {
  */
 #define XFS_EXCHMAPS_INO1_WRITTEN	(1ULL << 2)
 
-/* Clear the reflink flag from inode1 after the operation. */
+/* No longer set, but older intents may carry them; keep them valid. */
 #define XFS_EXCHMAPS_CLEAR_INO1_REFLINK	(1ULL << 3)
-
-/* Clear the reflink flag from inode2 after the operation. */
 #define XFS_EXCHMAPS_CLEAR_INO2_REFLINK	(1ULL << 4)
 
 #define XFS_EXCHMAPS_LOGGED_FLAGS	(XFS_EXCHMAPS_ATTR_FORK | \
-- 
2.54.0

