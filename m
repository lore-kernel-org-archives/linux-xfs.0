Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A19C356778
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419150; cv=none; b=Vwo0NhCC58wQjWOqmydbTtTlj5DNAt3zjtZs9xalhiMgF6jaonEd3wSckdQvEUqwx19PPztxlPzjOka8xcQxterOKJprdy9QWUW7WhqWA8Cwh6T2Td71KydxTNGcT6aBr8oCe7yYvUIFSewZ8O2aC1l1J3aaIBNlJD6+JQ28uMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419150; c=relaxed/simple;
	bh=pRRKdti5RFexqVAOWEdIg0WA2pKfw4rl4Fy0G1lvHRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3Yt013Q8b4YHRhq5ufd2tJh+0EhBjOmFyO28XWPNkqRenRBgIuPN/hrioSbH1WQOcuhlba3pQMx9vT/RMEYPMbo+qM1hjYx93h+4HyHNLtjHkx7WO9yx9cfXoj6xIzKEDqs6m3pMad1t4hZSE6K/lN7EB0DejQaLZemTwtRtIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KKkq+4eP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cYF6dpZq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KKkq+4eP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cYF6dpZq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1R5ZxOfm2hHpjt9nROi353uwAmbI3+SPgtIBMc52yGk=;
	b=KKkq+4ePG9mQXUKo4PnpR5KlgCthG7m+BMqY5N0zXb5JkvePdYKp8n2AnHdThT8GpVbA+j
	DRire/jnJ+MAIztcz3N+kbt4rYkDbATC6oY6DnJU7/1h7j7wLHxZHFl1A3yjuqxADW335L
	aCpjb0hoRowtPZM9/TwcMNgQ/1gu660=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-pBIFTyVcOo2tgu9_0op5vQ-1; Mon, 14 Sep 2026 16:52:27 -0400
X-MC-Unique: pBIFTyVcOo2tgu9_0op5vQ-1
X-Mimecast-MFC-AGG-ID: pBIFTyVcOo2tgu9_0op5vQ_1789419147
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9102f07f2fdso5230236d6.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419146; x=1790023946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1R5ZxOfm2hHpjt9nROi353uwAmbI3+SPgtIBMc52yGk=;
        b=cYF6dpZqv6zg8IkGJox61Uxm6HwPHZVbIneZwyPw1ZGuZkzHXIhr56drIjEJuv1tMe
         WiWaUXGauB8Wtwe8Aatspa9eMM1RibdoT0AtgZP6gG0Rj+HU5PSWbIz6aMgZeTFE2p5y
         ruP55B2kgXI3vnJlCw6sFVlPQapCSmZPI1iJ72GV1dn7t0OXUiz5EmHykZOcwhywxBmf
         LHEaAoU/zMuqG2MGtD7VPtpeSV6LgP4PwCbQnrZIZFu3TXCbgocriu0Zahkv6P7X8WBe
         8RbHGccDJfSCwHFFTVVdec7e7db6yUr3wFAGRXcC32l77JkZejB+ssgtsAt6fBW7GZEI
         bw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419146; x=1790023946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1R5ZxOfm2hHpjt9nROi353uwAmbI3+SPgtIBMc52yGk=;
        b=GjQU5HpTZr7Vvqz5GfPrAx+FJUQ28Mfd4ElPxwwcYrjc3PpbMP+XFrT77BmkS/yU4m
         fmjHM2/mMz6zK7T9umd1alfyG1kJI29I0qLMTb86nglZbau7RqIfgFix+NHae3wj2D35
         7IVDKgMhnmgurDK26LBJM7A8wVRpQXq7kz9BOPdi6EDYcxIEeIS8vDGMpRaHrjrm3BY5
         KC55twMrH9MHgRDq+KBwSG7cY9Aoko+YrHQgeciU6DzZVNVqy28kxX5IDREPqMenIUZv
         y7hDn1YCH1tm1SN6wFEv/wqPoOsDQQF7xhPms2mfu5cBMCzkitvWNlIDNsYpcjLZsxAy
         ov2Q==
X-Gm-Message-State: AFuF++k6ZHasFghQjzQvT31olp1O8Sr4lC7AnZ1/cQKt92DTO+yAGl8F
	MgYU+SvkXQOzxvuOAG+BiROTWNphtebkvrzA9NNfxyvKA4/5hTRx13Bsc9cuVXSxl1Oe8HD9xce
	a7PARKYEF/2m66jMPVG8FhobiDqj6tCnHIHpdU5bhZ9++RXb08nJ7fRnxPK7fjt32At0ll1G8NV
	Kb1KMVxT27XkiyTv7IZeuAnN2VtfJjSkw2IkVQQ/ELbROEq14=
X-Gm-Gg: AYBFou0aUnceAt1B5LlLbpixVAaIfZW3u7chF8JYTtZBnouwzcoMPEpCRe//oTQhFvz
	MKzJW9dKcm60j+wQC658K/CEEmTVyipFbOpMRCrXyMbk/5YRH8Zr2mh3jAqFbnUXYe3cO3ztdFl
	4091vmcE+3oD9iH7spehxNnGV5CtGPkczEDVwQCgY1NOPl3ZI4nH/6T61Q+5t5ZIdfPbLCceOSt
	uL4jq/lRsD4a71YwnSAE4Qm+3TiyxWoX066YZlp012RbRQlz+hW2qn/sQtpDu0ToBOr9LJjHWo7
	Bok/exa48zK+yKHWrO98oAT48PE3qW+BeHlMdR8K8UOVqT0Tn11esFB+/31iiwPwpdkLr9dFSDy
	qi0MsYWKTrF5Z9iMQWKWYeHLkiF/AG7Wwik8CUQ==
X-Received: by 2002:a05:620a:2699:b0:939:a095:e458 with SMTP id af79cd13be357-93a345d70dfmr153421785a.3.1789419146558;
        Mon, 14 Sep 2026 13:52:26 -0700 (PDT)
X-Received: by 2002:a05:620a:2699:b0:939:a095:e458 with SMTP id af79cd13be357-93a345d70dfmr153417285a.3.1789419145893;
        Mon, 14 Sep 2026 13:52:25 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:25 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 02/14] xfs: remove unused rsvd argument from xfs_bmap_add_attrfork()
Date: Mon, 14 Sep 2026 15:46:07 -0500
Message-ID: <20260914205221.1516254-3-sandeen@redhat.com>
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
 fs/xfs/libxfs/xfs_attr.c    | 2 +-
 fs/xfs/libxfs/xfs_bmap.c    | 3 +--
 fs/xfs/libxfs/xfs_bmap.h    | 2 +-
 fs/xfs/scrub/inode_repair.c | 2 +-
 fs/xfs/scrub/orphanage.c    | 2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8fb3adc3dd2d..c4bb59633ce8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1013,7 +1013,7 @@ xfs_attr_add_fork(
 	if (xfs_inode_has_attr_fork(ip))
 		goto trans_cancel;
 
-	error = xfs_bmap_add_attrfork(tp, ip, size, rsvd);
+	error = xfs_bmap_add_attrfork(tp, ip, size);
 	if (error)
 		goto trans_cancel;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d64defeda645..ca147dfaed05 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1026,8 +1026,7 @@ int						/* error code */
 xfs_bmap_add_attrfork(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,		/* incore inode pointer */
-	int			size,		/* space new attribute needs */
-	int			rsvd)		/* xact may use reserved blks */
+	int			size)		/* space new attribute needs */
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	int			logflags;	/* logging flags */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index d5f2729305fa..60f6df4ce057 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -181,7 +181,7 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_trans *tp, struct xfs_inode *ip,
-		int size, int rsvd);
+		int size);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
 int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 8bc508336aa5..42e0d7a6c7fd 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1949,7 +1949,7 @@ xrep_inode_pptr(
 		return 0;
 
 	return xfs_bmap_add_attrfork(sc->tp, ip,
-			sizeof(struct xfs_attr_sf_hdr), true);
+			sizeof(struct xfs_attr_sf_hdr));
 }
 
 /* Fix COW extent size hint problems. */
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 3aca66869b80..8c9f323201b4 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -546,7 +546,7 @@ xrep_adoption_move(
 	if (!xfs_inode_has_attr_fork(sc->ip) && xfs_has_parent(sc->mp)) {
 		int sf_size = xrep_adoption_attr_sizeof(adopt);
 
-		error = xfs_bmap_add_attrfork(sc->tp, sc->ip, sf_size, true);
+		error = xfs_bmap_add_attrfork(sc->tp, sc->ip, sf_size);
 		if (error)
 			return error;
 	}
-- 
2.55.0

