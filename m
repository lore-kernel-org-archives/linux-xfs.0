Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7043CC323
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179283; cv=none; b=NbGtvydvsCRE1+3I9PfqoQA5s/x7JNSEz4xaBaOcOcrmCDaAuoWNfoSmgG5gil+OAS7ZtJbT9tVjyZ2dHDNmkzsSZQRpaRNpmSIWFgtZnlb6X/SmnOvgB/vBtTSkPLU1psCyuy9v5M2FBH99DDjz7gNQ62mraAxvhfPKuCH7Zko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179283; c=relaxed/simple;
	bh=a/C85rSTb39XqyVEFw+YZKAgivrYm+l2mf+2SuMslbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nez1BWx9Z1hgHrlcWtqQNz8n61qjFH0gRERNy3YbVNGf8DlgbgseQ3HVm3+NTwvYYmzfHxDfTsNgAd+p46mguOIqzuqgxIjAL1uR9wjy47lCKtQc6QnOvYQWHyPrzOPPuZNsNFtcSM0BtdnbsCx7WYrQ1yhQ7Uy0duHo63s7n1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WkAj8XnV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGtX/koC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WkAj8XnV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGtX/koC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792179274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EtaTGhC3MllNillPV3lNis1CBJhxEso14KO94+VuZ/U=;
	b=WkAj8XnVyv1/3/R9lnBEqVPY0D7yXIjiCUPSnveLeGPX6j9iVpVlIC4pwXnlsDxDclKetu
	i5J/V0z8rkbK08bejCXayopD4qb55QTsC955+NzLLZ0SGMfIWU5rZ/CBjR8rkQJzzSncff
	yjI5HTvX8xesiHOhalxyQBEpU34XNqU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-KlsQH_s-P1mMz3vpM54cKQ-1; Fri, 16 Oct 2026 19:34:33 +0000
X-MC-Unique: KlsQH_s-P1mMz3vpM54cKQ-1
X-Mimecast-MFC-AGG-ID: KlsQH_s-P1mMz3vpM54cKQ_1792179273
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93dea1b6c89so53857185a.2
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 12:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792179272; x=1792784072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EtaTGhC3MllNillPV3lNis1CBJhxEso14KO94+VuZ/U=;
        b=JGtX/koCI7jqClC9reW7iAB+6R8soxLKWwTu+uL9EuJdFAMp9anEV5hlqghZs3Q9nx
         3dmYLkrYo6QnFmv19hpxDtehT+KtNZiVafL0PGBRoY5Y0wvXUR6TSCRRjrby3d6DawxL
         np2G8A1H1gbN9rlANz26VdI3y8SEfPyp/tmhoXjkbhgNitOQ+8Il29ZBZEXEcrrpIJpi
         H+8rzQF07noq0kh1G1kSggCAAroOveDTf6ByGxKH9dcrojNKvRcUqT2RJnsCGVthbaEb
         j8aIHeKCE3+qeF9YGUFvYuHLegnVTwproJ0cnUrg7RvLU8STWjXuD79L52rDssvJmY5n
         buDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792179272; x=1792784072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EtaTGhC3MllNillPV3lNis1CBJhxEso14KO94+VuZ/U=;
        b=wk0L55v9rGXxi/LxednJ22Bg1UVhmtQbMklnRi85qClPlQqgR9UMxwTACcwO5cPvq0
         +FE12EPMZXQoWQYbVi1qRGPrEL8J/hk7xjH1X3dJC5ih1l6DIFfD/HkPhxs9VJ0n3mRI
         NYscCy9G/qXOwAV5dH1gC5I2iPf0QuOaqeNv1ZPKVi/YqUQpBBL8+pdxdbdGczq8jbmI
         KOThSy/y+MlSF1pZ9h654vp08SFQwmRpkuM3aEpVvxkJsNAfrD7wGF85ydzeSrLhxLuq
         ECg3Y8hMb9NU54HQmA7RkDAVz2uqmsXJY/+QFtwOGHH8otyrdK0r2xsJH2dHXAheT2dr
         3Qew==
X-Gm-Message-State: AFq9FYKp3IT7CC12eEHy3CJwhyQep4Y7C7RTAMQyUCknctYFFTXZGWuo
	x6Zji9vnTwMEyNzfOOxgJa+rKU6USwjLlHgxsnEoKIbQrcV/6OGyGQzwS4fMkBuSb66WSdV18VZ
	0XTJAD1G+bD2YDlfwNKIXWqSMXTg5XVhYVDtFRkpBkeegbtQofmO8lg2gFl40RtjxbOqTwLbdCY
	8+8zlB2Y3SnegxAmaCoMcLnYdQnlaapgGK72HcqaUorc+D
X-Gm-Gg: AYBFou1rLWofKhjf4JM7qSuIWDos1OWtaMwRRVa3Pup5Bd6bBSO0E+e1lVL/TmfdVfq
	SXUY2xRTLf9rf433N3fxHUp3EHwZO5KKqRG/lOtJ3FrNZeAbwAbUkIzKCPt/PBki2IHT9BWUbaZ
	bhALMS1d4HF/1UsW4Z5xiI6ZpmsGjY2lubuT0LNQp2t6IjZeN8qpzADtQRbmFp0LvWA+iUosRE4
	dhsQhdmg8aanzmbVW1rckK+qK3YzJqP3Q5/CLyyIcOe4s2cm0WwoStqOQ1VwdJjCls1kB/lJ/PX
	2CFZZsRyjev43+oHfyIOJQqfrSLEL86nEfSBC7YkYkXmZT9gOeMwikwqisS7zJmEon+AhPpijJA
	YvJKEyBVGonWQueLcUVvN6YIZorMQK7bu+LE4Qg==
X-Received: by 2002:a05:620a:258d:b0:93a:f9:614a with SMTP id af79cd13be357-93f29d3838cmr157604185a.34.1792179272467;
        Fri, 16 Oct 2026 12:34:32 -0700 (PDT)
X-Received: by 2002:a05:620a:258d:b0:93a:f9:614a with SMTP id af79cd13be357-93f29d3838cmr157597185a.34.1792179271878;
        Fri, 16 Oct 2026 12:34:31 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a990fsm284359185a.35.2026.10.16.12.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 12:34:31 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	dgc@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/8] xfs: remove redundant stat checks after xfs_inobt_insert_rec()
Date: Fri, 16 Oct 2026 14:29:03 -0500
Message-ID: <20261016193422.1630907-4-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261016193422.1630907-1-sandeen@redhat.com>
References: <20261016193422.1630907-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_inobt_insert_rec() simply returns the error and status from
xfs_btree_insert, which has already validated the insert or returned
an error.

This makes every instance of the 2nd test in this idiom:

        if ((error = xfs_inobt_insert_rec(cnt_cur, &i)))
                return error;
        if (XFS_IS_CORRUPT(mp, i != 1)) {
                xfs_btree_mark_sick(cnt_cur);
                return -EFSCORRUPTED;
        }

unnecessary/unreachable code. Remove them.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index bb6e684f5467..fd916a2a005b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -236,7 +236,6 @@ xfs_inobt_insert(
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 			return error;
 		}
-		ASSERT(i == 1);
 	}
 
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
@@ -572,12 +571,6 @@ xfs_inobt_insert_sprec(
 					     nrec->ir_free, &i);
 		if (error)
 			goto error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto error;
-		}
-
 		goto out;
 	}
 
@@ -647,7 +640,6 @@ xfs_finobt_insert_sprec(
 	struct xfs_buf			*agbp,
 	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new rec. */
 {
-	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_btree_cur		*cur;
 	int				error;
 	int				i;
@@ -665,11 +657,6 @@ xfs_finobt_insert_sprec(
 					     nrec->ir_free, &i);
 		if (error)
 			goto error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto error;
-		}
 	} else {
 		error = xfs_inobt_update(cur, nrec);
 		if (error)
@@ -2254,8 +2241,6 @@ xfs_difree_finobt(
 					     ibtrec->ir_free, &i);
 		if (error)
 			goto error;
-		ASSERT(i == 1);
-
 		goto out;
 	}
 
-- 
2.55.0

