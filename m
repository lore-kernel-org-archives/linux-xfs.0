Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246433B14C9
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791384222; cv=none; b=BOilPfsxIQO/zxy/fxopWTl8GpwQESqFOwarDrfigU70xQNIQXzGL4ShgnHqh6TgQPzvE9pCWRYmDEfUhqT2wakP0psdZ4m0ccAsKtD601VxbH9eAOM3F4bss7DSN9/79zn23bDy6Pn/P/vvPI+MWbjiuV3NMqamRwBkLI1NaFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791384222; c=relaxed/simple;
	bh=PJs8ZDmwEpZs3Tss3S1Z2z3a0spC0GFK4ElKW7ch+YA=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=LF/v3k0zsxevlgEc/90IRh1Bjt7VIRXRKQ9UL7GacAcM0jttET3ni7ht2w++g/SPKnN1MVF+a//wGd/O8fY8P3RYzCQeA+GBEweFHCjHO9kOaIhVLNf33SOgb2v527krdzhOXQxNQn8rwxnUFPwcRf5Jtu5H+E0Wd75xuqoXqkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=knrHleID; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="knrHleID"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2e26719a0fso178945566b.3
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2026 07:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1791384215; x=1791989015; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=flcfemk5ogru9ptdjX2PBA5sybHLq9RGtyyAxoISU+s=;
        b=knrHleID7lPYxQT2QE/qug8pWvWhveIm9/aW6eqvEWg5IbL7sNvp4ymp7GWsbVUxk4
         5pn3KskCze+83fXntdXAahKEQ91hKv0kVaOpObc8d1I1GgwZM0h/2Pz6/MVFinn/ubes
         qKkJxNkUhdmk/oFFBNNeXEWcbqQQLXtoENBa+DFMK2/hjNaTIVd8wee/Wp9FDkNIgvF3
         cQXDNddd5KeMD5Bmkx60sC0pKvQq4aXZ7vQU3nUmcCg3pvTZO+qVf4tFqprlNVXp8U9L
         pvrqK6d3ml95uF6dAt+Tqj/Jmyaqk/CwpGUB5ZEiYetSWBVRfpljy6y3AiF6mPDX1ivI
         yvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791384215; x=1791989015;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=flcfemk5ogru9ptdjX2PBA5sybHLq9RGtyyAxoISU+s=;
        b=c0pUONWtn74tknoolZXFmbkc/V6RuEPLDRbh4tFUMQgJ2n+8KXBsJyphDnfserTtxh
         l0UUMe9p+wGuIEE7uUObaBAtWZLh+9Zn07auOdBKYQ+I2us3q85W6ss228h/HtKV3GPL
         eJ3ek4JGVw7UiUq9eareas7GCq+upqJC4+TWjFdNDmMLhjPADR1BhKZpojtz5XfCaci7
         dt5WKciKpXApeFQIbb9RzLo4FxYUTOBdemHZwvsOpzYUr+tNFsQppJMD5DKbXgk24b6r
         O4QAX890CuJ5C9C/ALrde0Ru773NX9oD3Ppnstv1J2D049Fr7FaX6+Ur0e/XXZCABiFW
         5GEA==
X-Forwarded-Encrypted: i=1; AKwUvBzmU/damei4/8EdWJtzsxgX2WK9eucWsbsb+x/sCQGLA3QdAFDAkkBRDovyX9NuUQ9WRhmBiM1NINk=@vger.kernel.org
X-Gm-Message-State: AFuF++mqPJ2mdEHdTKf5dWbWtyD/eN+uyLmtPwm7eDUHJ/onE7GeAn2Y
	XA8+EKq3kWtEoOw2ByrMdQwewI90Ep9FouLl8b1h3y4GPQiFJJrmoEeXp4hpZHgEuhA=
X-Gm-Gg: AYBFou0tA9oRwLEIht6KgGvQzFzLYZW4GCkcsGwdi4CAcbLmzkDaNiQq8b1rP1s51UW
	hmFGPLCV17HBUYHTGLGhE7VATTHlm1EnEob4DVUeCIQ6bA1DoG7LRPz3YGMpntmD7dY68/+5lyp
	AST+iCLizRXH1Wbq+iTQfvlTFQ0NXxGjM5V6Q4LJr3f0V4WdpB5PtbePXtZ7lomp1L915eKSGaV
	T9PGD45AmDlEtasslpb9+kO795j1bBrJVSdbpoigl/iETdv9/jqnK7v/xxo2mEfNwLu01HCPW73
	SOZh8ttvHNJqAPsu5KPbcWqEmJoE5Xu8ogYl+ABrOxbG7qn2yoxYms15Hwx/XOY2rM3fkHh+BoI
	JRuRWG+Duiq9A/xbO8kU1LzKxTN3MktCt2MOMRkp68gZden0dwfdJ7yuQxeSjC1bvTUGNlTv7sH
	Y3qs2XlVffYKVpDwtlCT0oaY6RypoHD6qPuWj/U9mRV3PsobkhGC4B+gyw38AGDZS227mQVxqI7
	64/Yyz5zhQEcYvKUsjoU0UH7UYzSjb6isG9oaLv+0p39UZKS0JuWT2KFa7ilLertMEQUp6j
X-Received: by 2002:a17:907:6d1f:b0:c2e:7ba6:12ed with SMTP id a640c23a62f3a-c317c075525mr248239066b.36.1791384214781;
        Wed, 07 Oct 2026 07:43:34 -0700 (PDT)
Received: from smtpclient.apple (80.49.145.194.ipv4.supernova.orange.pl. [80.49.145.194])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c318c822527sm16728466b.12.2026.10.07.07.43.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2026 07:43:34 -0700 (PDT)
From: Norbert Szetei <norbert@doyensec.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: [PATCH v2] xfs: stop exchanging reflink flags when exchanging
 mappings
Message-Id: <EFFDC5C8-D154-419E-BC3E-050AD53F55F8@doyensec.com>
Date: Wed, 7 Oct 2026 16:43:22 +0200
Cc: Dave Chinner <dgc@kernel.org>,
 Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

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

Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping =
exchanges")
Fixes: f0bc4d134b46 ("xfs: swap inode reflink flags when swapping inode =
extents")
Cc: stable@vger.kernel.org # v6.10
Assisted-by: LLM
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
---
v2: also handle XFS_IOC_SWAPEXT
v1: =
https://lore.kernel.org/linux-xfs/1E196589-DEBE-40AC-AFEA-D420DAAB067F@doy=
ensec.com/
Discussion: =
https://lore.kernel.org/linux-xfs/20261006050914.GU2705364@frogsfrogsfrogs=
/

 fs/xfs/libxfs/xfs_exchmaps.c   | 80 ++--------------------------------
 fs/xfs/libxfs/xfs_log_format.h |  4 +-
 fs/xfs/xfs_bmap_util.c         | 15 +++----
 3 files changed, 10 insertions(+), 89 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 6a66b6075e0a..7af8ee35c89d 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -49,7 +49,7 @@ struct xfs_exchmaps_adjacent {
 	.right2 =3D { .br_startblock =3D HOLESTARTBLOCK }, \
 }
=20
-/* Information to reset reflink flag / CoW fork state after an =
exchange. */
+/* Information to reset CoW fork state after an exchange. */
=20
 /*
  * If the reflink flag is set on either inode, make sure it has an =
incore CoW
@@ -127,9 +127,7 @@ xmi_has_more_exchange_work(const struct =
xfs_exchmaps_intent *xmi)
 static inline bool
 xmi_has_postop_work(const struct xfs_exchmaps_intent *xmi)
 {
-	return xmi->xmi_flags & (XFS_EXCHMAPS_CLEAR_INO1_REFLINK |
-				 XFS_EXCHMAPS_CLEAR_INO2_REFLINK |
-				 __XFS_EXCHMAPS_INO2_SHORTFORM);
+	return xmi->xmi_flags & __XFS_EXCHMAPS_INO2_SHORTFORM;
 }
=20
 /* Check all mappings to make sure we can actually exchange them. */
@@ -525,18 +523,6 @@ xfs_exchmaps_link_to_sf(
 	return error;
 }
=20
-/* Clear the reflink flag after an exchange. */
-static inline void
-xfs_exchmaps_clear_reflink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	trace_xfs_reflink_unset_inode_flag(ip);
-
-	ip->i_diflags2 &=3D ~XFS_DIFLAG2_REFLINK;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-}
-
 /* Finish whatever work might come after an exchange operation. */
 static int
 xfs_exchmaps_do_postop_work(
@@ -557,16 +543,6 @@ xfs_exchmaps_do_postop_work(
 			return error;
 	}
=20
-	if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO1_REFLINK) {
-		xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip1);
-		xmi->xmi_flags &=3D ~XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
-	}
-
-	if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO2_REFLINK) {
-		xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip2);
-		xmi->xmi_flags &=3D ~XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
-	}
-
 	return 0;
 }
=20
@@ -948,46 +924,13 @@ xfs_exchmaps_intent_destroy_cache(void)
 }
=20
 /*
- * Decide if we will exchange the reflink flags between the two files =
after the
- * exchange.  The only time we want to do this is if we're exchanging =
all
- * mappings under EOF and the inode reflink flags have different =
states.
+ * Allocate and initialize a new incore intent item from a request.
  */
-static inline bool
-xmi_can_exchange_reflink_flags(
-	const struct xfs_exchmaps_req	*req,
-	unsigned int			reflink_state)
-{
-	struct xfs_mount		*mp =3D req->ip1->i_mount;
-
-	/*
-	 * The INO1_WRITTEN optimization can skip exchanging hole and
-	 * unwritten mappings, which means we cannot guarantee that all
-	 * shared extents actually moved to the other file.  Clearing =
the
-	 * reflink flag of an inode that still holds shared extents =
breaks
-	 * the CoW write path, so refuse to exchange the flags in that =
case.
-	 */
-	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
-		return false;
-
-	if (hweight32(reflink_state) !=3D 1)
-		return false;
-	if (req->startoff1 !=3D 0 || req->startoff2 !=3D 0)
-		return false;
-	if (req->blockcount !=3D XFS_B_TO_FSB(mp, =
req->ip1->i_disk_size))
-		return false;
-	if (req->blockcount !=3D XFS_B_TO_FSB(mp, =
req->ip2->i_disk_size))
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
-	unsigned int			rs =3D 0;
=20
 	xmi =3D kmem_cache_zalloc(xfs_exchmaps_intent_cache,
 			GFP_NOFS | __GFP_NOFAIL);
@@ -1011,23 +954,6 @@ xfs_exchmaps_init_intent(
 		xmi->xmi_isize2 =3D req->ip1->i_disk_size;
 	}
=20
-	/* Record the state of each inode's reflink flag before the op. =
*/
-	if (xfs_is_reflink_inode(req->ip1))
-		rs |=3D 1;
-	if (xfs_is_reflink_inode(req->ip2))
-		rs |=3D 2;
-
-	/*
-	 * Figure out if we're clearing the reflink flags (which =
effectively
-	 * exchanges them) after the operation.
-	 */
-	if (xmi_can_exchange_reflink_flags(req, rs)) {
-		if (rs & 1)
-			xmi->xmi_flags |=3D =
XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
-		if (rs & 2)
-			xmi->xmi_flags |=3D =
XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
-	}
-
 	if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode) ||
 	    S_ISLNK(VFS_I(xmi->xmi_ip2)->i_mode))
 		xmi->xmi_flags |=3D __XFS_EXCHMAPS_INO2_SHORTFORM;
diff --git a/fs/xfs/libxfs/xfs_log_format.h =
b/fs/xfs/libxfs/xfs_log_format.h
index a4e1b3eb425c..6e620380d5dc 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -927,10 +927,8 @@ struct xfs_xmi_log_format {
  */
 #define XFS_EXCHMAPS_INO1_WRITTEN	(1ULL << 2)
=20
-/* Clear the reflink flag from inode1 after the operation. */
+/* No longer set, but older intents may carry them; keep them valid. */
 #define XFS_EXCHMAPS_CLEAR_INO1_REFLINK	(1ULL << 3)
-
-/* Clear the reflink flag from inode2 after the operation. */
 #define XFS_EXCHMAPS_CLEAR_INO2_REFLINK	(1ULL << 4)
=20
 #define XFS_EXCHMAPS_LOGGED_FLAGS	(XFS_EXCHMAPS_ATTR_FORK | \
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 268d159339d0..865aec3ae5ab 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1544,7 +1544,6 @@ xfs_swap_extents(
 	struct xfs_bstat	*sbp =3D &sxp->sx_stat;
 	int			src_log_flags, target_log_flags;
 	int			error =3D 0;
-	uint64_t		f;
 	int			resblks =3D 0;
 	unsigned int		flags =3D 0;
 	struct timespec64	ctime, mtime;
@@ -1700,14 +1699,12 @@ xfs_swap_extents(
 	if (error)
 		goto out_trans_cancel;
=20
-	/* Do we have to swap reflink flags? */
-	if ((ip->i_diflags2 & XFS_DIFLAG2_REFLINK) ^
-	    (tip->i_diflags2 & XFS_DIFLAG2_REFLINK)) {
-		f =3D ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
-		ip->i_diflags2 &=3D ~XFS_DIFLAG2_REFLINK;
-		ip->i_diflags2 |=3D tip->i_diflags2 & =
XFS_DIFLAG2_REFLINK;
-		tip->i_diflags2 &=3D ~XFS_DIFLAG2_REFLINK;
-		tip->i_diflags2 |=3D f & XFS_DIFLAG2_REFLINK;
+	/* Either inode may now own shared blocks; flag both, with CoW =
forks. */
+	if ((ip->i_diflags2 | tip->i_diflags2) & XFS_DIFLAG2_REFLINK) {
+		ip->i_diflags2 |=3D XFS_DIFLAG2_REFLINK;
+		tip->i_diflags2 |=3D XFS_DIFLAG2_REFLINK;
+		xfs_ifork_init_cow(ip);
+		xfs_ifork_init_cow(tip);
 	}
=20
 	/* Swap the cow forks. */
--=20
2.55.0

