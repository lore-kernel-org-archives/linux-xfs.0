Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A81F47C11B
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 13:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790948320; cv=none; b=tbXfbKGe6Pefncvr/xnPfHZNlaa7+1SKqVxKsnAUPaA6K2CFEovYw+Cr+sTiLX3UGzcLPffJuuD7oKs3Sa2dIq944xNjNW/oh4ZVHhpgTymCz5sr993JgifXNI64lbQoX20OJsL7AMps2Cu79NADjtuFdSHVrPP0DCjjunFMYFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790948320; c=relaxed/simple;
	bh=l/fcNewUbV20w5ksWH3Qn5QyhTizRaHKqov+EJH+udc=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=XYr9j2VAngBQx2UHbE+0d2lJKoewEY89eGtVhPSsxk8jCiOSfFaPDUBJ9oKRGH20utJHA3klTv9vuSmGgKBgrKBPTYXYSf9azR2zf4lzUKyczLXdTPMcEhT3lgAipHd4emuUCmwlJnAyFIFXwc9XzVFAxPLREF7pO6a9ww2/CxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=kwhrsc8w; arc=none smtp.client-ip=74.125.228.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="kwhrsc8w"
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e3453dd0dso7797066b.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2026 06:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1790948315; x=1791553115; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3yINyE0yyeM3CpehMjJu4cbKN829o4zhpqEN0351yGA=;
        b=kwhrsc8w7IxAGqB5CvHmOKoa6njzyrQYqPWhhQkd8/p2Obi+MPsa0i7Rk6Qv9X8stO
         8ZoOZrgKPVn1n6dKrrkSPBIpp+iJWyDhkY6ExBHnXkafrR+mOEmbl+/PUdwdVu6G/fjP
         33+iCsaY1W+cN/Wy31mCXhL5kHvC3jJVYekQx9DwtdiadE8jQSQMnnqjIDfA/nXoD2Vc
         N6sRO+g2XrNDdHHviYyUV7RFRg8b8VKYFdeZSWAMuuUnDPaNE+5/gxCxnSjW5Y02m2mJ
         kToGe+VGLSGAEfA9U/hdx2ingIoQ0cj0Wd2FC+MHB3or7LL9qoAcrtteVIyZiEoKbyV7
         LjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790948315; x=1791553115;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3yINyE0yyeM3CpehMjJu4cbKN829o4zhpqEN0351yGA=;
        b=NfO80g/j2mR4dvIJpjzjrJ8gOQJI4Vak6TEkVbzfEb00ohbYcJVWoJlgA1P7eH+/Sh
         HMqci0XG8cr8UUV9v1MtMxUNCz5qh/AE9ObyvhNK9uAI8PPUnO0VTQeKyyiSj/IxgxBA
         lcmTA0WMlzjsxm1Kc+7/urYixxtQAmd97CgoXmNJcpH1FFIvrVynLHlqhIfWdaf49tC/
         Beb7mvo1UazUHfuEDJgsuzAxnDpf0NciwTuVPq6uxhczjIeTt+zN5QWm9pzoYd+9vfYZ
         zhJVYG0Jew4duEs33LhTHyBOnLA5SO1UcpziZ8EGxO4ru0nXvyh0J3LD1K7Bz4HSdc4x
         qgpg==
X-Gm-Message-State: AFuF++nrKNB35l164Uu6vWXto1VHfRoQ/tck9XO02iaCOiJWpUIDq+cw
	/6HfB1NHh38A/d8fDj9SuUjmxrLweQwL3LRU3kNBjy7T28PCl0dXmmY3+dQ/quCHVMUwGCOhb+W
	JcFE+Oig=
X-Gm-Gg: AYBFou104XfT16kpFpEL1Qc2L08wlbkhX/jE0vKmEJFU8+lxt2PG/f+rl/eZYnX5G2s
	YzzzDa7OUoBEY91IWKj4D6FIpFrUKl2TP2/YiDkFuujKKeJJtf8x5bIm12hCSLMhOJSauyB5y6e
	euVBa5ww6f0paDUkb8bcdKTX4oecLo8tG7c38oqCp7QSKKJxUJ7xqI6/0jNknkppxhrfj2R6uQy
	L6toYCAPYuVMyHNy7aTSQVzzA8JuCdXofMN1+ILsohBKqLzTgOZv5wLapO5hcxjJYQkpGwYMLJr
	7C9NrSU0+jhoxKBjeNYY17UGliNIen0njblL73kd22+kZG2EPBvphsnuenNz7YAzp/3mScTF0CN
	3H6s5P5+ZH81s9NZAqJA7zcq/YFccjepnzAb/5BB946Uv15KXABU+cAqSdmdM/G59h1DSfiOjaW
	0R90n9M18SXUi89QHMEuYTAm8LsIDk42v0ZJtlGv4P9leq4yZfMKcv0MGYmhYF7GAlvf/FlB5Bp
	CZOvRfQRkFtrwmxoKfx99OrAnbEbQuGJyPGDg+fCDeDV9NytyIGGZNUjLL6Mg==
X-Received: by 2002:a17:907:7b8b:b0:c28:fb3f:fe20 with SMTP id a640c23a62f3a-c2e4ad762e5mr203461066b.30.1790948315396;
        Fri, 02 Oct 2026 06:38:35 -0700 (PDT)
Received: from smtpclient.apple (80.49.145.194.ipv4.supernova.orange.pl. [80.49.145.194])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6af9edb859bsm761777a12.2.2026.10.02.06.38.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Oct 2026 06:38:34 -0700 (PDT)
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
Subject: [PATCH] xfs: stop exchanging reflink flags during mapping exchanges
Message-Id: <1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com>
Date: Fri, 2 Oct 2026 15:38:22 +0200
Cc: linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: Carlos Maiolino <cem@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

When an exchange covers the whole of both files,
xmi_can_exchange_reflink_flags() moves the reflink inode flag from the
file that has it to the other one, deciding that from req->blockcount
against XFS_B_TO_FSB(mp, i_disk_size) on each inode.

i_disk_size does not bound an inode's mappings, and
XFS_EXCHMAPS_SET_SIZES creates that state by assigning both i_disk_size
values from the sizes sampled before the operation without unmapping
anything above the new size. An exchange over [0, i_disk_size) can
therefore pass every test in the function while an inode still owns
shared mappings above EOF, and the post-operation cleanup clears its
reflink flag anyway. Later writes to those mappings take the non-reflink
write path and update blocks that should still have been protected by
CoW, which shows up as data corruption between reflink-related files and
as an rmap overlap that xfs_rmap_convert() rejects.

Commit a23eca88448e ("xfs: fix exchange-range reflink flag clearing
issue with INO1_WRITTEN") disabled the flag exchange for
XFS_EXCHMAPS_INO1_WRITTEN requests. Fix this variant by not exchanging
the flags at all, which subsumes that guard. Whether an inode still owns
shared blocks outside the exchanged range is not recorded in the data
fork, so answering it takes a refcount btree lookup, and
xfs_exchmaps_init_intent() has no transaction to do that with, cannot
report an error, and runs with both ILOCKs dropped in recovery. Deciding
it correctly means doing that lookup in xfs_exchrange_mappings(), which
holds both ILOCKs and a transaction and can return an error. The
conservative outcome here is that both inodes keep the reflink flag.

XFS_EXCHMAPS_CLEAR_INO{1,2}_REFLINK were only ever set by the decision
this patch removes, so xfs_exchmaps_clear_reflink() and the code that
consumed them are unreachable and go too. An intent logged by an older
kernel does carry the bits, but xfs_xmi_item_recover_intent() has always
masked them off with XFS_EXCHMAPS_PARAMS, and the clearing only survived
recovery because init_intent re-derived the decision. Recovering such an
intent now completes the exchange and leaves both reflink flags set.

The flag that xfs_exchmaps_ensure_reflink() copies to the peer inode is
now permanent until a FALLOC_FL_UNSHARE_RANGE, an xfs_scrub run or a
truncate to empty clears it. Until then that inode keeps the paths
xfs_is_cow_inode() selects, ILOCK_EXCL for buffered writes and the
-ENOTBLK bounce for unaligned direct writes, and
xchk_inode_check_reflink_iflag() preens it on every scrub.

Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping =
exchanges")
Cc: stable@vger.kernel.org # v6.10
Assisted-by: LLM
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
---
A reproducer is available on request.

 fs/xfs/libxfs/xfs_exchmaps.c | 86 +++++-------------------------------
 1 file changed, 10 insertions(+), 76 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 6a66b6075e0a..07288f4163b3 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
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
@@ -948,46 +924,21 @@ xfs_exchmaps_intent_destroy_cache(void)
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
+ *
+ * Note that this does not decide anything about the two inodes' =
reflink flags.
+ * Clearing XFS_DIFLAG2_REFLINK off an inode needs to know whether it =
still owns
+ * shared blocks outside the exchanged range, which is not recorded in =
the data
+ * fork and takes a refcount btree lookup.  This function has no =
transaction to
+ * do that with and no way to report a failure, so both flags are left =
as they
+ * are.  xfs_exchmaps_ensure_reflink() copies the flag to the peer =
inode when the
+ * exchange runs.
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
@@ -1011,23 +962,6 @@ xfs_exchmaps_init_intent(
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
--=20
2.55.0

