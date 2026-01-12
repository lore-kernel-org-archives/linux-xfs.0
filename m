Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEE92DFA5A
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229439; cv=none; b=BYCnnVqli8pLJ74xZqVtpaMgkm+Xpt+tzkGqQLzZ75D4XZhJHww8CoOV4kbunvWYIaORe2JTdmKrS4U2Lik69jIRcz6WfFL6tj9mJhUudZfT53L7y6KIDZ545Blop/zgH1EycMIRCXYd1FXq2wAEo1vP1s/Ymk5eg+ThELezC74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229439; c=relaxed/simple;
	bh=XXRH7b/0i4ueWjWQWLdmXozm6ynpX7HcGCIutMaFY1A=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ERZJtNXqR/RQuaBDzqNAFs3WA5pqUpRoDd4DMTe2ij1j9u8Pq0QPn0jxEaoJC9RcF9z3rWavq9XOX8+J8I9xkbQzKrCFCWpha0RSWUemp+N4+2k7+jGufrlfqNwFmtksq2dFvoTZJbHj1kXAX48J5XCMHIO59xFliAreTIqudV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=awRhHrGr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GaCeT2vj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="awRhHrGr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GaCeT2vj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nb5UIQxqvdSkHiFjYiKVV8nmw/xrhaJumJsBcf3A06Q=;
	b=awRhHrGrS0Drx1vGt3cY08i+jsFr1U0xVJSw8gN1wtVjwF7hq+1OfiuKKqSe8HEDAKLh+/
	TpAhjAYmvWoybc8q3RiSlTYDjaQIw/Potv20O0l/SrL1kKgG/jFbp97jKqqc7LPy11dP9d
	lHcb+j6DB57n9Yf+pPbZf16XIr/vgF8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-MmQ7AFsXOSa_h3zJrLY0gg-1; Mon, 12 Jan 2026 09:50:36 -0500
X-MC-Unique: MmQ7AFsXOSa_h3zJrLY0gg-1
X-Mimecast-MFC-AGG-ID: MmQ7AFsXOSa_h3zJrLY0gg_1768229435
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b8709d4ff20so150877866b.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229434; x=1768834234; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nb5UIQxqvdSkHiFjYiKVV8nmw/xrhaJumJsBcf3A06Q=;
        b=GaCeT2vjAvVxt1ckfhbUROC/NtHxbPoxPN23MCYPFqnwyD2QZuNmlzrz/qJhWZfbNm
         rHdfv/56CaEV8ciithZOUjyotTj/Eh8CO2cPncqaiuLxCviCzeZHBDQVuYsWJ1XpWWke
         2jhzZan3Fnfb0ltvQeRzbR6CyouVlBePvFWDCySI1kPjsDq+Sb/B1qAXRO4vKv/GY/W7
         0iZEwTTnKqrukAXcbtYa/xSLzQfabpLfRNdQwLxAgWEtL7uvSrXs9cOjG0gDPP+vUmu9
         YG7FCVYfr+791TaDAAcjVZdjRT0QF0qAz8PHDekbaXx051xFGTcGANRUlWaZzxZpEOPM
         X5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229434; x=1768834234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nb5UIQxqvdSkHiFjYiKVV8nmw/xrhaJumJsBcf3A06Q=;
        b=OvMEkJCp9HGraxwAM0Bacwxfz2D6HENjulLl04me5JS5Aj/IMAmO+CnF+lsN/JaOic
         8kBrq3GRkVE7d5CAeTnV9hEThlZIASG9gwEuksYyXpxnjQifAmsxhkYeqbg9BDzf8u9s
         Jz7KmboSMxYbCZJjFOljIF39sIqT8fq1Hgt5G/WcwiofpvTApssSb5Cheppqq5tZaDEF
         hJkpj03D8Rt7ubj7l+pRgZqmsbJIqBSPU+fXoSK+eqsGXudQSQuTgQUlk1nYzm+U/iK8
         nZlhxX3sLYE8VtHODo/wM4JGiq9xTu8M+vzs8xRiGOX/yYHTrYn0aVPuhgO5gGCpm/O/
         kgHw==
X-Forwarded-Encrypted: i=1; AJvYcCXHUQuf4H+B0i2gGRe4GSjglUkc2TVnAvXL0q4yZ70lpQpKgoerrEBY70LBerGTCrdk6YIUwJh+jjs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGrZWZJZcXJmqIrgRFMu5FuIAZ3+LQNErW4Jo3dWjCmKBqU1mP
	xbk4KpFGZKHKkQAWYeNJvH2TeG/JLgDpGnhgLqowc/o/2LaxADMxnJ2w+UY2MLyVN/f9FUVwakl
	nziEK7Zk+Q8qHB+XP2M0EOa6tKN0tKrf7rFjg7T1meGeOBMKoahhJpTIFIxAodXQRaN04
X-Gm-Gg: AY/fxX4V54kaAQJ7xJPBo/8Gg3DpFuqcydcBAM0D5lJxM7uG03Dbmh6alUpdxN0q6+r
	6hV3xPFApZy8V06HoRyvUQt4ziI5Co7WTvjXzQooBodS0GA4V6uPAl2Ac7XHW3S9mWp4n3B2vOk
	X4UUDhhhHFc/SootnfBtTuTU1a01WDapiuqpEVZXf1i1bgsH/m3zLTNg35hQ1ptTcfQD7M794a1
	D1Li5T4IeqPEWEvQJak/h/xW74tgVpOexfF9Py5+/skyjzlxuGVlPK+aRcaZRdlU2y4FenJQiNI
	uaaiiC6Phs4FRmUko4OV818D0aEi5QVGdCaoCKqb5Xop0T0zGxGxrhHyvU8BWa+nEZQvOyUln8k
	=
X-Received: by 2002:a17:906:7954:b0:b87:2579:b6cf with SMTP id a640c23a62f3a-b872579ba1bmr222390966b.41.1768229434418;
        Mon, 12 Jan 2026 06:50:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF8SWwB/AxOY3cZ8kcTpvTO2S7OPJFMdg+l1YvrGvLC8boRfcE7EDzI5F+ztUGlqqU65b2z6g==
X-Received: by 2002:a17:906:7954:b0:b87:2579:b6cf with SMTP id a640c23a62f3a-b872579ba1bmr222386566b.41.1768229433922;
        Mon, 12 Jan 2026 06:50:33 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b86ebfd08b2sm774184166b.25.2026.01.12.06.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:50:33 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:50:32 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 6/22] xfs: add fs-verity ro-compat flag
Message-ID: <ra57w2n33ipx73jt5ah6avoa3piadlrhu6spwr6cf3ke7mbwit@a2b3rnvxtu3h>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

To mark inodes with fs-verity enabled the new XFS_DIFLAG2_VERITY flag
will be added in further patch. This requires ro-compat flag to let
older kernels know that fs with fs-verity can not be modified.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 2 ++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 779dac59b1..64c2acd1cf 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -374,6 +374,7 @@
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+#define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 94c272a2ae..744bd8480b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -165,6 +165,8 @@
 		features |= XFS_FEAT_REFLINK;
 	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
 		features |= XFS_FEAT_INOBTCNT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_VERITY)
+		features |= XFS_FEAT_VERITY;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
 		features |= XFS_FEAT_FTYPE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b871dfde37..8ef7fea8b3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -381,6 +381,7 @@
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
 #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
 #define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
+#define XFS_FEAT_VERITY		(1ULL << 30)	/* fs-verity */
 
 /* Mount features */
 #define XFS_FEAT_NOLIFETIME	(1ULL << 47)	/* disable lifetime hints */
@@ -438,6 +439,7 @@
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(zoned, ZONED)
 __XFS_HAS_FEAT(nolifetime, NOLIFETIME)
+__XFS_HAS_FEAT(verity, VERITY)
 
 static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 {

-- 
- Andrey

