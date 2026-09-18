Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D98835B14E
	for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2026 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755213; cv=none; b=dcHoV/VLNS8MxhdmIjp+5qgIAwXPPKYTO7rvRGIWLCPupL6UM8YWZ4VtAS3mhNlorYGxYbQieVZTbfc3cDhqvRcik6/mhfypPELhrUIn/Dn/cYxncPUs/nrIM3t6gtfWZsDDXYqm3GmOcpAL+D/YBSRQ8zyHrFd1bVt97vGBIng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755213; c=relaxed/simple;
	bh=yK7LF+5SAOYnHl/n7fN161dMnm2m9BRFWpHYhcCnMBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB9LgaC5loSRq93m7r0nSeBGv22+DMoC0eQJ678U7XzJ7nmWJtw4ePdGrmuM0mU1c2QbLzSOce26OMEpKjt3GMa0RpCZZ5hmAMrzXqbBSiH29Wyo0azslLXnKHIaKYthsJGt/cDTpiN7EfMcrBFFsmM5D2Cixda4vimzPpf56xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K3fhnsHs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RbY44brD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K3fhnsHs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RbY44brD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789755209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaCYch2Nj+drXzf/lwaMlyOSK3FTahfvjkayj9zZ9RY=;
	b=K3fhnsHs59K1BD1OMnG6t6450tUM3f9MHDaLkpdXpT/MuYxn7eLMjtDNYQbglsjieBIXT0
	UkCtwETNo8pm7I1TpEplVCyWP4e/a8J0r/ilyDV5vUiQTrD7scjgWns4s8vwg/V+EaKmyn
	EofZhDvdewURy/27KLXSm446zMDWbQA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-eORs1hjWPzaSVgvhI7Qlmg-1; Fri, 18 Sep 2026 14:13:28 -0400
X-MC-Unique: eORs1hjWPzaSVgvhI7Qlmg-1
X-Mimecast-MFC-AGG-ID: eORs1hjWPzaSVgvhI7Qlmg_1789755208
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93a08ff8451so170218985a.2
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2026 11:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789755208; x=1790360008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iaCYch2Nj+drXzf/lwaMlyOSK3FTahfvjkayj9zZ9RY=;
        b=RbY44brD4cNQYy+jA+hbhzh1zrzUinU1PWa1yQFGjbj7QnmTQ1PIjmIs3JpjCSHEqK
         xnWBP06zfqlsCgewRBjlMhyB347xns6k4qQ9D+4MTgGaQ3/CHwvDg++CsWeOVXFJic6W
         vqbPs+LNb3rE1ysxZUGDc4ZUEEWR6iGZO+JZjQKACUKg2a3P0u2mS7m4Jkk+Q6gJNLsI
         ysTpvZu+weugT2rtPKMBfI/SCj7zoTJ1G8/dFp3/kVaVqOnD3517I2TGlPRci0dQYc6g
         +6R7bfGGzC3cDTkS1NmCQkGGqgQUaVmdWERvkC0nbWFlfBGziVExDNqeR5NViuXyoL4I
         hDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789755208; x=1790360008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iaCYch2Nj+drXzf/lwaMlyOSK3FTahfvjkayj9zZ9RY=;
        b=LPzEsLsE/yXlo5ueZyy79Nq1tPLaq1gC16lRjDFfVmoBQN1+KrSQkgfzoNTcwBbIia
         H1NtpL73UsJyzS/9YDC5oLXSDZTUzQWPmFA6gteKe811EkIbd5uBZpzrHvOXLwX3pO7i
         p5SiM/yEX31FTw77c4m790JyxBDUAeLIYE2iXOpyQiC7VfSlCHryUnMOlTYg8K9/M+rs
         ekA783C+dFtz1n8wJw4V49BFxXZsqayTKTdUnOehFpErsqYuP0VGhm+E15e9cL1JnxGN
         xlErwCALBzX2ie/ZqZ2CgCD31EierILHle1ipT+/Nl8/n7er/EYSGebn1DBCzghlaQOI
         08+g==
X-Gm-Message-State: AFuF++nUNlV3Xe+bUFepzis5SVQAGKnQbpMBjo2XhXjhX7J7lhFE39ZM
	xWY3ecb/55z//cPv4A1gYXxk45U0Iwud+KlqR4Tt7LaSawh/yxMkRkO1KXGSHOxe/Y4g2/z+ziv
	JMBwR3RezAayQpEdJNYOTU+EA9KMA+bUJ4hrGYGQ4+q2duQNnd8ul4N/oBzTkvd5R/uaLDMG+7t
	FCyXQrmi+8HJg7uat6yrA7DlB5yeGXbZ312kgw7YYjYi/Ytmk=
X-Gm-Gg: AYBFou0+NprbkzKFpnXOzTPLD1mf61gCH8iYc28hW25pw1axJaLkQH7fESdm58wGlQU
	rRS37Lf9psqUItEcVzvOd5M6dCPbCXiYKuAnH80Jp6dcB4wtLJeJ8XF032Pn1IjfsO4BCKOe1KD
	TCIuBM7EuwL9cObeTtwS+UmTOQkbyD7kCStLUMUbi9D+MnFZJcuYbvwdrBYG5Cv/OQUkKnAmvq5
	DwkYuY3RCwL1KrRlQVUZ3ON8bW/kO8O1xxbpvxfOErjKP7P+jCL8U7N+EPL78gMoEAT8XTc6t8I
	C3Xb8juqavvyjE8NlKMG0oEWvnLd2T36dB1WmtjeiZOlNtOzF0yq1Ns/GZrqHxX21QTNV+qKgn4
	0DK3ui+r7jQzXhi/XB8/1aFNdR2X7FeZ6nx6Jng==
X-Received: by 2002:a05:620a:29cb:b0:93b:d79e:1900 with SMTP id af79cd13be357-93bdc9d4b3dmr523069585a.67.1789755207692;
        Fri, 18 Sep 2026 11:13:27 -0700 (PDT)
X-Received: by 2002:a05:620a:29cb:b0:93b:d79e:1900 with SMTP id af79cd13be357-93bdc9d4b3dmr523063585a.67.1789755207025;
        Fri, 18 Sep 2026 11:13:27 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93beda707b7sm4583185a.10.2026.09.18.11.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:13:26 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] xfs: export several rmap btree key/record ops
Date: Fri, 18 Sep 2026 13:01:32 -0500
Message-ID: <20260918181324.2472127-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918181324.2472127-1-sandeen@redhat.com>
References: <20260918181324.2472127-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The AG rmap btree and the realtime rmap btree have several identical
btree key and record ops.

Export the AG variants of these ops so that they can be shared with the
realtime code in the next patch, to eliminate this copied code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_rmap_btree.c | 16 ++++++++--------
 fs/xfs/libxfs/xfs_rmap_btree.h | 26 ++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 10b3272238eb..5b283a5ddd13 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -170,7 +170,7 @@ static inline __be64 ondisk_rec_offset_to_key(const union xfs_btree_rec *rec)
 	return rec->rmap.rm_offset & ~cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
 }
 
-STATIC void
+void
 xfs_rmapbt_init_key_from_rec(
 	union xfs_btree_key		*key,
 	const union xfs_btree_rec	*rec)
@@ -187,7 +187,7 @@ xfs_rmapbt_init_key_from_rec(
  * the startblock for all records, and if the record is for a data/attr
  * fork mapping, we add blockcount-1 to the offset too.
  */
-STATIC void
+void
 xfs_rmapbt_init_high_key_from_rec(
 	union xfs_btree_key		*key,
 	const union xfs_btree_rec	*rec)
@@ -209,7 +209,7 @@ xfs_rmapbt_init_high_key_from_rec(
 	key->rmap.rm_offset = cpu_to_be64(off);
 }
 
-STATIC void
+void
 xfs_rmapbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -243,7 +243,7 @@ static inline uint64_t offset_keymask(uint64_t offset)
 	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
 }
 
-STATIC int
+int
 xfs_rmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -257,7 +257,7 @@ xfs_rmapbt_cmp_key_with_cur(
 		       offset_keymask(xfs_rmap_irec_offset_pack(rec)));
 }
 
-STATIC int
+int
 xfs_rmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -390,7 +390,7 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_struct		= xfs_rmapbt_verify,
 };
 
-STATIC int
+int
 xfs_rmapbt_keys_inorder(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -420,7 +420,7 @@ xfs_rmapbt_keys_inorder(
 	return 0;
 }
 
-STATIC int
+int
 xfs_rmapbt_recs_inorder(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_rec	*r1,
@@ -450,7 +450,7 @@ xfs_rmapbt_recs_inorder(
 	return 0;
 }
 
-STATIC enum xbtree_key_contig
+enum xbtree_key_contig
 xfs_rmapbt_keys_contiguous(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 119b1567cd0e..82b1a7fd8513 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -11,6 +11,8 @@ struct xfs_btree_cur;
 struct xfs_mount;
 struct xbtree_afakeroot;
 struct xfbtree;
+union xfs_btree_key;
+union xfs_btree_rec;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RMAP_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
@@ -69,4 +71,28 @@ struct xfs_btree_cur *xfs_rmapbt_mem_cursor(struct xfs_perag *pag,
 int xfs_rmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
 		struct xfs_buftarg *btp, xfs_agnumber_t agno);
 
+/*
+ * Key and record btree ops.  The rmap on-disk key/record format is identical
+ * for the AG rmap btree and the realtime rmap btree, so these are shared by
+ * both (see xfs_rtrmap_btree.c).
+ */
+void xfs_rmapbt_init_key_from_rec(union xfs_btree_key *key,
+		const union xfs_btree_rec *rec);
+void xfs_rmapbt_init_high_key_from_rec(union xfs_btree_key *key,
+		const union xfs_btree_rec *rec);
+void xfs_rmapbt_init_rec_from_cur(struct xfs_btree_cur *cur,
+		union xfs_btree_rec *rec);
+int xfs_rmapbt_cmp_key_with_cur(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *key);
+int xfs_rmapbt_cmp_two_keys(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *k1, const union xfs_btree_key *k2,
+		const union xfs_btree_key *mask);
+int xfs_rmapbt_keys_inorder(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *k1, const union xfs_btree_key *k2);
+int xfs_rmapbt_recs_inorder(struct xfs_btree_cur *cur,
+		const union xfs_btree_rec *r1, const union xfs_btree_rec *r2);
+enum xbtree_key_contig xfs_rmapbt_keys_contiguous(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *key1, const union xfs_btree_key *key2,
+		const union xfs_btree_key *mask);
+
 #endif /* __XFS_RMAP_BTREE_H__ */
-- 
2.55.0

