Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8CF23BD03
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419159; cv=none; b=p7vm20GRot8mSvyaRZSVGAFG2tePp9ZRNjV28PoUbyxHP1HSRIqvDy98pHvC/6EzT6/uPHpNVKeA8OAHX/jpXDBGYHn6Pxqdhm90LR4TlVaLKt04hJSISbvsJusYYIbhskuebnnoIw2UieQ4gRQqDme7xUvhpEGDTVW1IfL24oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419159; c=relaxed/simple;
	bh=oN99NIyTd78L6nihitvNePIuHMyzqA5VLjBsw2lBzlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8wtp9hE3oeATsFM88K5YPsL5goIv/3wGBlCOjhIpG8ojC4PUWfCfCaew4tozcQ9SMwSVlusgANm6Amgt1SQGvMcE4amf1JgaaoQ0TmMlarZr96TWtce+6K2ykAKXMnPfEaVZgPggCOhg11LaGTDK6dsWK8sNiFyz+yva2j9vfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aen2Np61; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=NgPiA9QJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aen2Np61";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="NgPiA9QJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hxNgeI5Sw6GdKSNeR85bhaXroENTmipCbUPvpKYSEB8=;
	b=aen2Np616rcSMcLeBRz2KXHRW7WMonLTYD8U4CJQESyuvh8qM4gdom2nFGCj8rQs25ec+Q
	GjRltzNwXjuf7lwhzgvrAS34pTXoZstHl7Wx7sZC4cDrXpf4+/IKMTmjid+a6KiSYm3ukW
	y89ogUr/tbS78I7vLb+bYbevrnGrMhw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-9Bo19DQrMk-b7-H9eUc8EQ-1; Mon, 14 Sep 2026 16:52:36 -0400
X-MC-Unique: 9Bo19DQrMk-b7-H9eUc8EQ-1
X-Mimecast-MFC-AGG-ID: 9Bo19DQrMk-b7-H9eUc8EQ_1789419155
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a1bffc2eeso440798885a.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419155; x=1790023955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hxNgeI5Sw6GdKSNeR85bhaXroENTmipCbUPvpKYSEB8=;
        b=NgPiA9QJFM/Kp5dtd2x7u8fyKTyMZZgFnEGjZSzUwl60WRKWIb3R9j3Jp4BurlX3A0
         wD2j/bCjMPw077MdavntlvaQQ7jT7czD5Y1c8QkKky2h3fna0ekz4jvaEJWwZx0yllY/
         V1bFc4gDtIJ8DhvIi3BjKrHO1utIC/BJOG1JSGysoCqrxQBewGqqLr0XmMgcI3axC3+f
         6vEY1x2lPil9482vM4I0DLSk+EzmVR7OeFxy2z0ZbXO2rNhtNzEK5tqokeV7S4SWlfbQ
         ggqqFoBi4OdqZIZkMuA3CT2v+hyysaXVMkXRSuTfbKDA86G3I62KcLktGbS90CSw1VC5
         srvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419155; x=1790023955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hxNgeI5Sw6GdKSNeR85bhaXroENTmipCbUPvpKYSEB8=;
        b=r6YI/V8EGoY57rHDN1JHEJHawH8ZFGZsq2Nl47Ov0oSK6hS8OViyKMgI0/1Y6nZw8I
         PMdxyA2oLbmhDGpGFVj2HEq0ws4f/83UTY/TEKB0MvwzmYDXmr2105VA3RVHDPdvsDT0
         g6u2YlLFLqmyMkOfGZ937HGobDGWdsAvWr99DG59q9p8FJSCz37YyP/NKowcXwyhVazc
         NdC4JN7OWXyqfBy4Ng4Oy5yz/LaN5vietlq2jFxcd4T2Rfg9t+LLjwVCdDl/dRhttJK8
         MkF2drBcxPFLx168sfPxDgJVxC0URPMHEZCOEXrtsN4X8yD6MVwBMxx9DQTE0UAhNxXh
         z//g==
X-Gm-Message-State: AFuF++n0yDDJoC8vjvJ++QmvVPofmakzl10zd6LwE61WMhmGEN5SQ0fg
	GP+Lj6qdxvllqineDCWLjc22Y13T9aetCCpr27rlTAUzuoWv+XrjwMegpXAMe+CqVp13WrSrOZx
	TiBl6GZ9mLbjvKBh1+SzZxw+qZSw4ztQE6IMOrkHGG2QitUZZfRw1VClICdxrNU2MElTqPOESOa
	lWtolJdfkhCJDCDWyKvoa/L5KvgEd/QIRd6u9md42aq1qh+1k=
X-Gm-Gg: AYBFou37P9V91C5DNfBRhl14aQ70lFDBJskSMkElrufPJx+WulgiZiInbZ39QDb6wAy
	CnUEPNgGr5E/kH2Hft56PNLFC5/uVgk6rczjqDi882S3jCV7lnByvRI5J6OEBVMdxMKcImQCt99
	FmXb7qLfM2ojNYszWkZqDqCVXD8akzzhH9jlZbiSyKGK4AAiZztdMcD5N2K0G7knUaBZ1AJJkBK
	CRSgiYVNPJ/hlA4qImjwOsMXYTy6qTP1ol1TE3S04Mqpu7kDPMQlZKktHOi69rHykki97csY+e2
	uOGyp7xwnhgnWxFqdUJXMpAPYTCtTmxDORoH0nUIst6xFEz+kpkBXjbOYhXN3kaZCXEphpLYlUe
	HXl30R58eoFvP4KghD/QIly+Bm0b5Z6f+a5voTw==
X-Received: by 2002:a05:620a:370e:b0:939:7d8b:93e0 with SMTP id af79cd13be357-93a297cc40amr617367285a.18.1789419155476;
        Mon, 14 Sep 2026 13:52:35 -0700 (PDT)
X-Received: by 2002:a05:620a:370e:b0:939:7d8b:93e0 with SMTP id af79cd13be357-93a297cc40amr617362985a.18.1789419154986;
        Mon, 14 Sep 2026 13:52:34 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:34 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 12/14] xfs: remove unused mp argument from xfs_verify_dablk()
Date: Mon, 14 Sep 2026 15:46:17 -0500
Message-ID: <20260914205221.1516254-13-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914205221.1516254-1-sandeen@redhat.com>
References: <20260914205221.1516254-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_types.c | 1 -
 fs/xfs/libxfs/xfs_types.h | 2 +-
 fs/xfs/scrub/bmap.c       | 5 ++---
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 67c947a47f14..b5b0b6334d11 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -222,7 +222,6 @@ xfs_verify_icount(
 /* Sanity-checking of dir/attr block offsets. */
 bool
 xfs_verify_dablk(
-	struct xfs_mount	*mp,
 	xfs_fileoff_t		dabno)
 {
 	xfs_dablk_t		max_dablk = -1U;
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index f6f4f2d4b5db..d217220d2054 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -277,7 +277,7 @@ bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 bool xfs_verify_rtbext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
 		xfs_filblks_t len);
 bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
-bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
+bool xfs_verify_dablk(xfs_fileoff_t off);
 void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
 		unsigned long long *max);
 bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 401c278725d2..dff2329649a4 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -453,18 +453,17 @@ xchk_bmap_dirattr_extent(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		off;
 
 	if (!S_ISDIR(VFS_I(ip)->i_mode) && info->whichfork != XFS_ATTR_FORK)
 		return;
 
-	if (!xfs_verify_dablk(mp, irec->br_startoff))
+	if (!xfs_verify_dablk(irec->br_startoff))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	off = irec->br_startoff + irec->br_blockcount - 1;
-	if (!xfs_verify_dablk(mp, off))
+	if (!xfs_verify_dablk(off))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork, off);
 }
 
-- 
2.55.0

