Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630E44E50B2
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 19:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586973; cv=none; b=KwL/tIoG27OSvzX516MM0etxXR0/AuwtcbNxSJAQQVRMpA23bfBy4SaCEmx3vn3OR9hYd9m+upLpPpnGoi2mwon7GUqg+TDXmBicscessD7+J+omNHKfjG9UaEvLhQaXsFfuoX4DnN30VE2V0s9ABhfPLYd//71J68g3byMUZ94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586973; c=relaxed/simple;
	bh=saChfygPBPZCwZj+26yeCgdLy1eoyR+hdw8SI1Rs/bE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc:
	 In-Reply-To:References; b=MqdmfYkL8B4g97rtNG1DJy5JhRNs3W02+uDScylkAFdqkhIiPBFHxObh28AfUIE5sNDSjvVO82mxPAXmA7JTRcZqbHduadM6xIykc1A9HZc7ZI8Zr67bac8EbL//iJuqvLt3UMQDKjdC6jmLWm0iosXfiiQ9PqVTZrb19ZiUIUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=w29jERPD; arc=none smtp.client-ip=74.125.231.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="w29jERPD"
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-47c272605bbso102653fac.1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 12:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1789586956; x=1790191756; darn=vger.kernel.org;
        h=references:in-reply-to:cc:to:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:feedback-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=htHAlqVBMvpBkvqZZm0DecavHNdfRcLr3Ni8/kU+LTM=;
        b=w29jERPDZj66GsKXToSZneZY1Dm93BHUebHXW39G+aIUdOS6A3yVWoA59uVApnSt0f
         4ETLoB8XGbTW9k3sB/DTegR25u7bVCvqmIxX5rItk9sFnf5TgKhjjIOSlKG581a/SbgM
         CdIAVPLBR9Hhj4pzR5kfAqSDwItTiKvm4SWsc6R/AQ4h2kR6UKvSqQVZ47PMT9aKUhEH
         BBcyFu28ZQCo/CdwY47dLNOlAfCkl8engtWl/0zvs0ikcQrGMhg5vNtJOO62m4ny8wY9
         n5jcG0mVdxI+9UKmw3VQyVTpRySShnxGYkmxwJo0ySVmFi4mYVRG+A6dO8xURzs8ruDe
         Hlfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789586956; x=1790191756;
        h=references:in-reply-to:cc:to:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:feedback-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=htHAlqVBMvpBkvqZZm0DecavHNdfRcLr3Ni8/kU+LTM=;
        b=wwM4NGLiR8FsfM3wmo/TgNw4IeqsL2oYWUxKyfDL6o99PegBFC4HyNHVjqVkd/fYEb
         tCgWOElI2O+lqHcoaASLu5p4Up57jqvna14Da8Ws9P8rRfCCEGN4SeOEiihGZopw4R3q
         SvX3qKpx1YxdqSsSUVCysCRuJ3V62o7OMuaq29yG7UjlJ6Vo/TN+sGB8+bi/GGh+zAyr
         0plEbbzBsqHZf5cfkY3QCEPTRYClwJdWE091iu5C3LvEASQ5Y/CkOMMkwJKgdVo/6Kf7
         SkRZ43D0gPPd1WBCTndbZuQB9CBD58+YoeCwcQ8a8eOL9AN9uGvSttU/yg1/qFV8XhBs
         MU6w==
X-Forwarded-Encrypted: i=1; AKwUvByJsX2o8RWkme2y+1oItPMrlHlTKSZq3YHLpdH7AQP1CkwqrZ9PdaBDM7PwaURkD7gG209ixx8Lpnk=@vger.kernel.org
X-Gm-Message-State: AFuF++mRiv20CnaMAHtSs2edwpClJy0Eyp4gYZIyH72BLGfr7O39IruY
	8+K0BxrWr04aj+OeS8DVO7K0YVUzKcZhYMmew836f+KCSNorDLYVUMbvzfzrSZUuxm4=
X-Gm-Gg: AYBFou2ExHAK/JDLM1AOAzN5x+KMlaF2Z6onRI2hq/AFlS5lCiX+elp3Z4biZlT0OLD
	N9DG8rpB613GKN0Mufwbx4Hnzi/Ic318xkiHqjepBl/x/yRywuc4YPRrRpQoJTwqDZQzB0pS+xK
	IzPF9VJ7p1QqsMzJO3ZjUejdWvMtg82gGSzhyCTBB0F2N8Xqq400Yyab3Th1Ow4Hxb66Lt7Wtw4
	iiztVuErfgim3UuFGWKeZGa1sxbdvoAgdcP4YjSMi1MXQbV0cgThNEvFLRwjzx+WKSlL20Jw/2G
	viRhDwPlGIA+/OEZMRoPXL62L+0z5H1azUSXsYq/aFhX5+bP7laVA/QdhGrihwNasQDsNeRDZ8B
	qa+Sx6kzQRnKvSECt0XeKizsyAZLdAfti6jTQ9CoefhHTAL5FIJQq1/iwsibq3fPRPHi5Jzr2O3
	bFlZ4gfY4X0G4BV3Dmnwj0cqgA5xGYqWH3wnbuYe2W6MxcfB5OCxDQy0az11bDRwlozwEvmPaay
	0TPyoX47fd+QUp71JtbtAj3HFITn47rG6VVrBVhk+qm+mlDYwnlnVCxGXrm
X-Received: by 2002:a05:6830:6f88:b0:7e3:f809:7984 with SMTP id 46e09a7af769-80b2d1f4ecamr4142774a34.1.1789586955944;
        Wed, 16 Sep 2026 12:29:15 -0700 (PDT)
Received: from fauth-b1-smtp.messagingengine.com (fauth-b1-smtp.messagingengine.com. [202.12.124.200])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c46dbe483sm680916a34.20.2026.09.16.12.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 12:29:15 -0700 (PDT)
Received: from stl-compute-03.internal (stl-compute-03.internal [10.204.2.63])
	by mailfauth.stl.internal (Postfix) with ESMTP id D26CE780043;
	Wed, 16 Sep 2026 15:29:14 -0400 (EDT)
Received: from stl-imap-04 ([10.204.2.95])
  by stl-compute-03.internal (MEProxy); Wed, 16 Sep 2026 15:29:14 -0400
X-ME-Sender: <xms:Cu6qat3rOG_BNWf1VrzKxGV4WPsTHR4NEF2pyHoHanTDseVsZChyuQ>
    <xme:Cu6qau7Ob3CWHOcUJ7h_mFCY6JffTZo-K7_Om_PO62M7PORNUxCfgQniEmwACnYzM
    iDaFAw4LcNdmmIrJk_qZ3DVXjNgtClwWP1pr5-3laqnk_uid-pyNjmc>
X-ME-Proxy-Cause: dmFkZTEPf7Nmr3yicaUi7emDSJMCAx8SxcwOOIZ5UDx/ag8bL1M0YzxSK8C9JxIxjFizzI
    wqtsdSAJQFMfNyjXmV/blmZMqIygQvrsY6T2OvOe+8rtce9BIAHglxOZ2MznDlfwd6s1nL
    cSl0qfnaxj2tBLli/uqPrMMqz7tA5aPSl5oIr8Pzts1w6x58VsO0lRS9kMqsuWJmVoqssz
    7tGUqSFs0bEknaYdmMveHPN8pg7hDcy/rf1AHevrnfWNyZcAj92/hiP7uCHxbwL6W/sNto
    gbSlf3/AtdRJXKtyX51ogEFEdNfyZMjoUycj+xoflmQ+h4GetPW+mFYoElgJoYNiFMn9UE
    3/QjB+UXmOOhuO+5Jjotz5Dxw/bAlDM9hDkwiuR/s+3Ny4KpJksLRbi/qMuzI4Hdzb1/Rf
    9YnQwRxZNU5qx1MmmR4CmrU25yv6Ap7h9kdCAg28jgBZTDDr4OZu+si3DVeN5E0ChviMv6
    7m6lZNGGaQSvHAtx3LItJYTcrOIp3893zPJAP3N2J58oIqEehhhp2I49IN3V82i8s2Zuoe
    JfdCL+7ydyO5QuTM4YCGzjGjoVDMjCKxbSI5l5SpxKI6DyTv8BI+qs5c0ObI2gZOtJsqPL
    DJCpwUXf4guPR9PAMCPh/ckvsIixXXH01tJcqYg0NC1j2RuJqSj1mSQ9tLWQ
X-ME-Proxy: <xmx:Cu6qaqDov9YyvLl-2lCFkTSOad0EF8cWg-5uKEk2o3IU9rCx9mmaEQ>
    <xmx:Cu6qatclMhLhOsIxv6CZhlKZSPLsbXPALzDlxWFultCDJSRAXwzkFA>
    <xmx:Cu6qapKOxnckEKycy9YwYQ5kSa8aCF30vGDB5hGOxIx4CWQQcCoRSA>
    <xmx:Cu6qao0hq2Um7V4qIL5PheTmGE1Z6ZA5xNc0beWLontyaQI6xr9Y9Q>
    <xmx:Cu6qarhRwYa-BxjxexWdqi3EsZCnOlrzXkVpiPU-cRt9nc9B8F5QIg1G>
Feedback-ID: if7264b73:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id 7A96580066; Wed, 16 Sep 2026 15:29:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
From: Javier Tia <javier@peridio.com>
Date: Wed, 16 Sep 2026 13:23:07 -0600
Subject: [PATCH 6.12.y] xfs: initialise args->total for parent pointer
 updates
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-backport-pptr-total-612-v1-1-c495a7c6e945@peridio.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ7CIBAAv9Ls2W3KHpboV4wHwEVRUwhsjabp3
 0U9ziQzKzSpSRochhWqPFNLee5gdgOEq5svguncGWginvaG0btwL7kqlqIVNat7IBtCT9ZyoBi
 9NdDrUiWm1+98BB4NjW84/X1b/E2CfrewbR88NtksgwAAAA==
X-Change-ID: 20260916-backport-pptr-total-612-b2776c2ffb71
To: stable@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
 Javier Tia <javier@peridio.com>,
 linux-xfs@vger.kernel.org
In-Reply-To: <2026091609-these-relocate-53bf@gregkh>
References: <2026091609-these-relocate-53bf@gregkh>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3714; i=javier@peridio.com;
 h=from:subject:message-id; bh=saChfygPBPZCwZj+26yeCgdLy1eoyR+hdw8SI1Rs/bE=;
 b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqquyaairuKeeN/IvLc818rMJ0s3fQFKWyAzZ+Z
 1t7MLDcazOJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCaqrsmgAKCRC17sMLqGd3
 H8g/C/92fBnKSyM5tKsED0Antrnc/FDMFuLmusEJi4IkKpO6otiG712kl2WkLL7sx1ejg8SjWjo
 E6mx4VOzaZ2T8U7qi/UcGuY5MjUJwNUHRVM2QAneDpzk8ahL+kssRFJUhk3roentF+vYzWV7dg4
 NTWLWCxU3l5iU1bwDcHM2iyDAEH5DzrzanaQ/bqyicK1dBrANYOdCpGRgAAtILBrpFgn9zBR7J2
 USWaYzwPK9R88CPjWYPC8me+F3ZM3MWEMRVX7LdOe+bjAmZ6D9vzYeJmwLoY7rPbU0nEoVov3iZ
 PdydqXgy28A6j9dLYezPyVpZTBQ+FOIcFHZr5OGyxpCwzKMjv/0Hv3zHjVT5umFFw4dlf34Lcfa
 n9LYQO1/Eb7RlEzy5uGD8UEzFstwdXBWRaoXs1u7mF2dOwbzNXpL+cTfhXs3lUmprgcccPjw84R
 fknA5Vj6AIoDC2xf1qu3YMGCN4T+hrUjmOHs5NIfwosCMsowuTs6GSwmB+LwNMQmLqyOo=
X-Developer-Key: i=javier@peridio.com; a=openpgp;
 fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F

commit 8e4ebb6afaa34bd2e8ce52da231003d24111c2d6 upstream.

xfs_parent_da_args_init() builds an xfs_da_args from a zeroed
xfs_parent_args (kmem_cache_zalloc), leaving args->total == 0.
xfs_da_grow_inode_int() treats that field as a running block reservation
and subtracts from it; because it is an xfs_extlen_t (uint32_t), the
first attr-fork growth wraps it to ~0U.  That defeats the free-space
check in xfs_alloc_space_available(), and when it coincides with an AG
that has exactly zero available blocks the allocation is clamped to
maxlen 0 and returns -ENOSPC, which xfs_defer_finish_noroll() escalates
to a filesystem shutdown.

Set args->total the way the log recovery path does
(xfs_attri_recover_work(), xfs_attr_item.c:706), in the add and replace
paths that can grow the fork.  Removals and lookups never grow it, so
they leave the field alone, matching that switch.

[ Backported to 6.12.y and 6.18.y, whose fs/xfs/libxfs/xfs_parent.c are
  byte-identical.  These trees queue the operation with
  xfs_attr_defer_add() instead of calling xfs_attr_setname() and
  xfs_attr_replacename() directly, and spell the inode number
  child->i_ino rather than I_INO(child), so the upstream hunks do not
  apply as-is.  The defect is unchanged: xfs_attr_defer_add() stores a
  pointer to this same xfs_da_args, and xfs_attr_finish_item() resets
  only args->trans, so the zeroed total still reaches
  xfs_da_grow_inode_int().  The assignment therefore goes in the same
  place, before the operation is queued.  xfs_attr_calc_size() needs no
  new include: it is declared in xfs_attr.h, which xfs_parent.c already
  includes. ]

Fixes: b7c62d90c12c ("xfs: parent pointer attribute creation")
Cc: stable@vger.kernel.org # v6.10
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Javier Tia <javier@peridio.com>
---
 fs/xfs/libxfs/xfs_parent.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 69366c44a701..f47dda640c0e 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -193,7 +193,7 @@ xfs_parent_addname(
 	const struct xfs_name	*parent_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -202,6 +202,11 @@ xfs_parent_addname(
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, parent_name);
+
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
 	return 0;
 }
@@ -239,7 +244,7 @@ xfs_parent_replacename(
 	const struct xfs_name	*new_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -249,6 +254,10 @@ xfs_parent_replacename(
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, old_name);
 
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
 	ppargs->args.new_name = new_name->name;
 	ppargs->args.new_namelen = new_name->len;

---
base-commit: 833291ee77846538926c990bcb468f6f54e9af50
change-id: 20260916-backport-pptr-total-612-b2776c2ffb71

Best regards,
--  
Javier Tia <javier@peridio.com>

