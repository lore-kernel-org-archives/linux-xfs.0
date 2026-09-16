Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B42425899
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 19:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586982; cv=none; b=qrfjOvIoPQ1HOxgPOl3SPSkv9VyHrDFxrdIXWkKr6SgPeNrNXVpdOmf8WJ0ZwMD1bd6mVJhO8iH5zy4NZQoc35eGgnfbJM1NZ4tRJiv/yYZTXnwCJT1lfs6gWsX/KqHmqQKd+9tMRz17UIoua4frMyl10Yqtyx0LoOfsU+taVkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586982; c=relaxed/simple;
	bh=saChfygPBPZCwZj+26yeCgdLy1eoyR+hdw8SI1Rs/bE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc:
	 In-Reply-To:References; b=VAH1LSBdr/t5HSiTjvmo4AF2J0K3zyEA7qDj93z2j32O3VjBpzOqfrvNAzQ4HbYVX4lIK7YO3WNzLguuhEaNWpN9zK7c/hkSnIKB50NuBReJEslaIM/4JfxmMYgIJllaLvrDlKGEKfa7xqXeHm2HXpfCb79w8eJNC8EKjtb6lFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=Eo9aPGc0; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="Eo9aPGc0"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c3dd736521so1215b6e.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 12:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1789586961; x=1790191761; darn=vger.kernel.org;
        h=references:in-reply-to:cc:to:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:feedback-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=htHAlqVBMvpBkvqZZm0DecavHNdfRcLr3Ni8/kU+LTM=;
        b=Eo9aPGc0uQ2nKndJwIQt4Dl6joAgd/Q4TqVbA6GrYEW1J+K0C2qOridhu6X5z7WPJN
         O6vIO6xL+0mqp17L20zq5nJxw7AU8r7yrIAguqwt+Xmq0770wWNXaHiNG/wHLlekXXWH
         fSVWkuT3MlB1puauVjQx6cKNVw4d3u2TpCMSHSloYUhBxjQ7VdQzaVJSMpNEDg1t5OmQ
         DrkG4W8FqM4/pXCX6s2r5uTS6MdJsRTOdx7Tp2hR6tTuvrlzYZ84KOS/2cdtSTD1FZGu
         M+YtRGdjtJV5GkXmIJbFxAh1Mnd8ajqyEXrYTo7BolqMqT+wkJPiG4x2zqRzvcGGucUv
         aPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789586961; x=1790191761;
        h=references:in-reply-to:cc:to:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:feedback-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=htHAlqVBMvpBkvqZZm0DecavHNdfRcLr3Ni8/kU+LTM=;
        b=SAdug2/ghgv7PKA4PJYBsGEziP3kk3vXKESmf3TPe6V3S6PX9NQ7Gh/2jV2ITHO8Fj
         q92t/89Y+Akan1LgtnTjfyDjJi44V5wjfUIVD8UxmHM/j4kNy2NOWcsXhQw9gU6Lev62
         0JEUZ63oJvm5HQKSPewoW1yFJaZ7nxJ0tpiRDdMjP2rzHaLly1BAHrbiqoDJ9baCUFL1
         +StIcP7HdXk/vDbi67eMeodNxORd9iBg7JXEGbUM+Q7hzBXCemR8Atqb00JSM33DZlNJ
         bo0U+Tp7y8y9wL3omZ8c73RWuIAykWNW99+SuvUFHKO/Fu4G2YfeIFWlvsaPNSyh+r1s
         Hbwg==
X-Forwarded-Encrypted: i=1; AKwUvBzZUOCRhGn03yYgj8xfTQgJpIiDtKMdq36tBgDE/DpPOsVxEiYrclWpe1KFBYUSpz6icrGqaHDIRYk=@vger.kernel.org
X-Gm-Message-State: AFuF++lQv9F1BEg6Tx/G51KUgS1btkooc1CynN5nLvhPHoOEIooigYDZ
	FIMzAJRM1kDaWUKZIHkSdPxz1PLkNNNPFWm71Hmw/2T2/1hKJ76hSm/79IPi6K/YdScfkLYDF+H
	MMn5JBP8=
X-Gm-Gg: AYBFou2W3JeNS8tc30pDWxH6psOkzmqhjRv+nmifqWSJPaUWafo8iXc7qKov/T560YQ
	vI+zM3kjddiyf6LLErw6yDLjn8k3+kIgGGpL8Ah4cxWHBR+TA+5sfmX9yi3rQ4yJOuJHrtroZjJ
	vLk5axygkiQoVYNQyM/9hEiouq/wR49dKdLnV3sqj311zBTSjxkYh77QMw1wQGgx0v3/KI/Oifp
	BOywLO6hLAbhTLIYIX7PD6d3BQ07m+7z3mw9Wn7bbHWsVYiSXv1GIBTXQXxpbG5dijbEpJekvg6
	B2336c878JLT/rUHrgr6iGhf19yBbW9ga2n8CSflLBwMkRArp7anf7BecFsPPI3C20dolnbplKN
	Pfd7TF6WTVopzH6rXys320b5J7bBkmnKwkhFPxvDqHDXmh/a/MfPsF2medSJEQc79uoPTrovO32
	BPNufZmJxL9ZsfvxsbyNaFs09gCIJLWMqRryNZsYlVYczdJXOk0S5iJK21jiEkokz14C9kF9m0R
	UUwWKUGufOhcLCIFmdtdf+cbli71zRHIUWG3OHOz2FX8j4VE0Sd59MtAgxG
X-Received: by 2002:a05:6808:c412:b0:497:d23f:e621 with SMTP id 5614622812f47-4ca4a804a43mr3720529b6e.2.1789586960849;
        Wed, 16 Sep 2026 12:29:20 -0700 (PDT)
Received: from fauth-b1-smtp.messagingengine.com (fauth-b1-smtp.messagingengine.com. [202.12.124.200])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cb6d16d9f5sm693078b6e.11.2026.09.16.12.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 12:29:20 -0700 (PDT)
Received: from stl-compute-03.internal (stl-compute-03.internal [10.204.2.63])
	by mailfauth.stl.internal (Postfix) with ESMTP id 30CD0780043;
	Wed, 16 Sep 2026 15:29:19 -0400 (EDT)
Received: from stl-imap-04 ([10.204.2.95])
  by stl-compute-03.internal (MEProxy); Wed, 16 Sep 2026 15:29:19 -0400
X-ME-Sender: <xms:Du6qagBNn4qHUpqwKH-c3zjrnLedjNtUjos1fCByZprUrsq0CJzBxg>
    <xme:Du6qatWckPy_wS6ZFESRu788Ar24tOEWR63rdVbDcnw4tBDG-dv73C5bvPb6F3-HQ
    FWqk-Iph81C41_GzUUr6svlglTmvMWYdfE8IpNBT7c2OHpnVTiw3FGi>
X-ME-Proxy-Cause: dmFkZTGZOrpWno14ldsmdVuj5n1/4PSwjPZ5SbfZThQnGK1J0rCU1WpCWBZ1bzoLhA/f79
    X4kUbqA0tfVB6n6bQYNGCSPCfBhUTmprSL8E03RgOA2sIFK5kSbQIfB6kdSI7ntaTrEcOQ
    2FE1+CN2W3T/hOVhItFDTOqm880m+DSTR+pnE/IEjTnQphBLgiYDz+loMGvkg/NILI/ZYq
    Wz1MF3vpqTVs0mrZPnNmSzLUUaVC2UqPr9NYoxDUhyy9EERDNoTJvsSn8zqvlWl+2Hzxw5
    cyGk5XjRdWIl8ihA0TKhFA+f1aphYpxqCyLZBHBWTHHc2X0xWJvLSDmYy6Mmxb9kuVRWlK
    vgH8w67VAzi1d4vnjAqNmcS588C2zda+88L301ZjrP5NVuJUK1URojqxDjJHuYCJrq4CA9
    RpXd+VFSb1vHEZt6h/Ei3rVdM9kzGFgEiJboSo54iuqyt8jhD1R9jSqCQ8r6lgskPa0pXQ
    7JpA82dvsvnRFlBfuhxU0BsFM9Je9qaAqcS5FLP3EA3kd7KYA+WKQGXjEa2cDFfD7IjEXA
    e18uUJmgWH/BFECDJr0+EmEH2ykIIsJ7hz6krtYvAWyhG+uewdGMUWkq39oEuOtpudBHEy
    THPXpi9shnbT8O+XFy1mbLOxup0o6hcLhhAc7AM3ncHLKCUBzI1L2Nt9nUBw
X-ME-Proxy: <xmx:D-6qanP-cb9Q2uHT0-lkwYEa4eRhSr9uzppQfvP9YGjOlY5FvwMIFQ>
    <xmx:D-6qaq4CJT7udng32uu76AXSFZLWSBs7maxvGkDZNamuq9vqsfRmLg>
    <xmx:D-6qah3Ay2iTXnSb6UGYJMCO7pVb41_cVRhsfSBRA9YZ743XrRXs7w>
    <xmx:D-6qarwbiOWiZPYkc-DmoZJ-55XEUJKTX7rZidBo4E92jAXu0RC-Iw>
    <xmx:D-6qarsR8uXqTzLcncszRUMW0KgPFPzB5-0By5XqSvQyj6WU67mmWHvv>
Feedback-ID: if7264b73:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id D2DEC80066; Wed, 16 Sep 2026 15:29:18 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
From: Javier Tia <javier@peridio.com>
Date: Wed, 16 Sep 2026 13:24:05 -0600
Subject: [PATCH 6.18.y] xfs: initialise args->total for parent pointer
 updates
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-backport-pptr-total-612-v1-1-dfcc0698a166@peridio.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ7CIBAAv9Ls2W26HBb1K8YD4KKoKQRWo2n6d
 1GPM8nMAk1qkgb7YYEqz9RSnjvQZoBwcfNZMJ06g5kMTzti9C7cSq6KpWhFzeruyGTQG2s5mBi
 9Jeh1qRLT63c+AI+0Hd9w/Pv28FcJ+t3Cun4A1oO0kIMAAAA=
X-Change-ID: 20260916-backport-pptr-total-612-b2776c2ffb71
To: stable@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
 Javier Tia <javier@peridio.com>,
 linux-xfs@vger.kernel.org
In-Reply-To: <2026091609-donator-dumpling-82dd@gregkh>
References: <2026091609-donator-dumpling-82dd@gregkh>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3714; i=javier@peridio.com;
 h=from:subject:message-id; bh=saChfygPBPZCwZj+26yeCgdLy1eoyR+hdw8SI1Rs/bE=;
 b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqquzUxjrJ1jS7GO0kiStoqJ/iBh1VKQSJtQ0gQ
 zy7yxUlAcOJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCaqrs1AAKCRC17sMLqGd3
 H8XEC/wKIvRWaxWxyTKL4z94bt0kp5cAwjMMXPMETesTijPfqGSGTgPxQmIKU37SuipjyL0m5dO
 tor/n5BLFfY7m0Toc8vp9E7xouirF0gY2Svhgcgg1NA3K+rTJWtqBi4yJtYVZksEWDkjc47BVij
 QtJACUB//zT+fr9HO48hg4gAhEr24fefAePp4wsZts8zaf5PzEoZ5BFtxyf8KDgdUyGBN+lH40D
 vQs98cPZgkO+NzC3ZdAWKwrmp7b+9/OCgezVAfY5EU7AD8W/Xnzd0Afvcv9ZDrak9yJqIlmla09
 5+MUjaGkJYY2wxdFOy8mLn0D/MJuXLaEAyRkGa7u8ABkArZGxo9fp5NyXMcSQHw9ZMlLQeX3ZIP
 dkerZEmdfVmUZ6RCzoZReW8ALcTpUX2/0damWr6ZQ+vna5RANBnPtUfzi1Vd03xwf3STtGVjtEm
 nBYx6KhW05QcgvfFOyHLSylUeyXZxQQQ85dAkzEmXt56yC0I/7fti6nkwzgGRotxV7FLs=
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

