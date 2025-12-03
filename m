Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B5431D36D
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788736; cv=none; b=NatUHDMxwzS9avf1qQkdNe2AexRO6YV9YhQymfpHbY8DzWEmyvblzwKVWQ87W9r/GMv8HpRFOX2vheH3VwV4Accs9Z3b9unshLhFGG84/PGUhUFPjjOCqdxA+UZOStUzuXihSSO2MvXfyDgzAuhLaRCxEQU4YM263r39aFmmLkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788736; c=relaxed/simple;
	bh=Wh/yqKojbTIhyze/JIq/J+vhOFNdvdGCM4DUpPPgZ8k=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJh5aLHAY74aaoc/dEI+bBj02e7uT2NjgGtKyAIDrdnTsB+LdDlmTv3JfMSStWkZn98Hju/qBtBoky7LBNQIuZOv3wZedZ2Z6S99eQuNqvXTpU0okkkr4FuABFOpfjVeLoPF/0rrDEnvKlICbYoHUyrePCRU6xMZDX+hsFlkQUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hi2hNgUM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PKmFEO8J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hi2hNgUM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKmFEO8J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3nm5qogg+DxEA5dtlF/ZLMvp/7+vTaYVvhqstJPtS1Y=;
	b=Hi2hNgUMGjIwJ5F5RrhltoUEKEkBM1BvC5HUmM1Lt+l5oalOzlwhBL+jFtjExUIpZAyXUz
	A4sVDS5Fa4clqBCOmPHXVCp9yr2lhkOxk5hb9XwXxbX5vqLBasOGAX09rlY6McGU+yzHGn
	ZiSnoQVViBwn4oXwvB467WzLuNisdvg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-71cq0GH_P1KfyIiOtNxJ9A-1; Wed, 03 Dec 2025 14:05:31 -0500
X-MC-Unique: 71cq0GH_P1KfyIiOtNxJ9A-1
X-Mimecast-MFC-AGG-ID: 71cq0GH_P1KfyIiOtNxJ9A_1764788731
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b3155274eso65052f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788730; x=1765393530; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3nm5qogg+DxEA5dtlF/ZLMvp/7+vTaYVvhqstJPtS1Y=;
        b=PKmFEO8JPLreXYQMXaBi/Es/lJc/UoGMy1S6wALGs9Bxpdmmwv1zim0bMvTIEuaG0x
         tXYFS1Dy005avBchw4Xxf+XamydcNwPTUXIUzzwJ+MuEx3S1ChRG0o8cenaDAwYpbEQS
         /gniJQkEg5yaL98ULB6KtTjkfErOGU76wOceCdu4ruCgRV/pILqFJ4iWLL+v6+Ccdnnx
         cT9iohHzjrAnnCElMHdrqKSmZZX1AGG0BU5xS7EQ4rKjRl7dNA4sWYOYT7+vAoFv4gHY
         dy94clgpPsVJ5aiTEoJIbA1z9TBtbwVQFXPIKz5shI9ZGWWQvtYUGZhedcdAzSEhSEwI
         mZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788730; x=1765393530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3nm5qogg+DxEA5dtlF/ZLMvp/7+vTaYVvhqstJPtS1Y=;
        b=DoObIcIseyOndFNncptwHKT1BohzrsfZuI7p38yqxPmRMMO50r0yCEJ8G17EZWaWuM
         CfBosWG+YH2uDoBZAhuXpV4a7fVDwp9gqQBVsbFdQLNDrnV3yGXLXKqSnw9/pt97Ud9x
         iBDZzQxJmWhQVlEMpxAffpOMC2WNzwX8Hgd/yZFTDHv56PsnoSzXxm1gtg2s1k5oz0NH
         49hgiF6V8MVzXaNE7Jj6qmb2Pr5Lk38lkysiKK5UhNCofW9LLmMNOLNS0DGMVec05Mai
         9jj1g9zzqC5G67LRvpAfSR+/8bckzrm5P71ZE/GM3U4V+aOae38xNEh5CHFlSb1lVyT3
         3p1g==
X-Gm-Message-State: AOJu0YzaMGsrO0TZ04NYflFDszJEFnnLtjQKC5tKGtQ5gT1v3D+mlyt6
	SJQL7JWOTkAL1y4b1SCTNALq4KM9rM4SAOowI2kS/Q2mAnkE797mCMT/q04yjXtTiXDaW+/PHrs
	DnlocgLa/Qjq8pMvp7mKq6xwYCDmO0zsvDdkTIWT3K0mnIPJJovz5CfD+CrkLLGRuWO7eeDuveT
	34gMrkVKvCxWM9u2nLMbVriZLcp+xMeODNj0yyQODFsmYS
X-Gm-Gg: ASbGncuPRV55d6S7GuDyWuU05Nsu0kKdMNnaQphHm+f48SIydYCRzY+BZk6cqvVchNa
	luxfY+OjJoX1wBAW4Wq+SsLFV7NZRXjd2h7uF6V4TvylVJLlnEu8yWqLafxRkMfwcKpCv399Nwp
	fhWjrU5+9y0P5lQdLjwcA+QNFmNuBtlcSakSgAmCQHUqCmQoA7qb75XvJfCm6swTavXTtQC4+QL
	+8gpPWRVFI/imqKlCKlCD/F4g/AzktWSHqjS8WVNlaEPNusOLJX1mJ5J4LmV2WLJkl14hAGslvI
	zQbj83682HZY6UX93+WtfROhlmxjv37yU3Rx5qW1OmrkxZECwfw8UIt1q/WJOv8LZtTrJ3J3TPY
	=
X-Received: by 2002:a5d:588e:0:b0:42b:411b:e476 with SMTP id ffacd0b85a97d-42f73171f8dmr3820130f8f.9.1764788730238;
        Wed, 03 Dec 2025 11:05:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHohzQR0zQchymLokuLSbtvoTa2A6ofQT4sXUWnMiT/KLYD2qvxaQ9bbUDAGpbqPA856r3lag==
X-Received: by 2002:a5d:588e:0:b0:42b:411b:e476 with SMTP id ffacd0b85a97d-42f73171f8dmr3820090f8f.9.1764788729703;
        Wed, 03 Dec 2025 11:05:29 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d618csm40126926f8f.14.2025.12.03.11.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:05:29 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:05:28 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 4/33] xfs: remove the xfs_trans_header_t typedef
Message-ID: <jmyienmseczj7xktof5sae7wkh4eqejsih73iurbuvdr74asig@rseh77q2e3xs>
References: <cover.1764788517.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764788517.patch-series@thinky>

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 05f17dcbfd5dbe309af310508d8830ac4e0c5d4c

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h  | 4 ++--
 libxfs/xfs_log_recover.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 367dfdece9..2c3c5e67f7 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -212,12 +212,12 @@
  * Do not change the below structure without redoing the code in
  * xlog_recover_add_to_trans() and xlog_recover_add_to_cont_trans().
  */
-typedef struct xfs_trans_header {
+struct xfs_trans_header {
 	uint		th_magic;		/* magic number */
 	uint		th_type;		/* transaction type */
 	int32_t		th_tid;			/* transaction id (unused) */
 	uint		th_num_items;		/* num items logged by trans */
-} xfs_trans_header_t;
+};
 
 #define	XFS_TRANS_HEADER_MAGIC	0x5452414e	/* TRAN */
 
diff --git a/libxfs/xfs_log_recover.h b/libxfs/xfs_log_recover.h
index 95de230950..9e712e6236 100644
--- a/libxfs/xfs_log_recover.h
+++ b/libxfs/xfs_log_recover.h
@@ -111,7 +111,7 @@
 struct xlog_recover {
 	struct hlist_node	r_list;
 	xlog_tid_t		r_log_tid;	/* log's transaction id */
-	xfs_trans_header_t	r_theader;	/* trans header for partial */
+	struct xfs_trans_header	r_theader;	/* trans header for partial */
 	int			r_state;	/* not needed */
 	xfs_lsn_t		r_lsn;		/* xact lsn */
 	struct list_head	r_itemq;	/* q for items */

