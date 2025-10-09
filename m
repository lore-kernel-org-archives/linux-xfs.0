Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E502D1907
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011785; cv=none; b=QSh2TlZub2uPWJkz4+66d4EX7KwW54z6bK/0CCfBAEQ4sDEF7/6f09DYn8g2D2w/8jfJhV3c0Wf3sAC680+Hpw1yD/GVdsoyqtS8MpPuI4eC0KiwiZhdC8LylYSN2ukbGBY+4RImoi9MA9Pob2fSKsQpOLjjvdQ3NpxaP+gwA1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011785; c=relaxed/simple;
	bh=X6pvhkPJ2YQYHixKYeZger8QZxS6Z34hSEsXJuAEVTE=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8J+6xrJlHw0m7+Fd0tlTJ0Cd+LQptlSOa30ZWvdwzgvD17Rk23SXudniHTxDpL1AiDJKyaHUOpUpjJeEGQZw28pS8y+9tS3d+UmuMkiX40dZ28F3fi8poysIpss26Q0umQ841fQdJSoP2OT6OEoMmDAelkdRshI5rTHI/P0qtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PL9afZ9C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PL9afZ9C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ZhIjY3l8N4e2YFZVy8mnM0qXsDz2ky3cyLq2+Ya9mA=;
	b=PL9afZ9CIBHp/VOgPPAUh60diBhC6ku7QSrCfrHxqP7iMBPnCMVxD9t26/Vw+qO8vPJBgU
	j02/TOh4bRLj8n7qH+/PEYxzqjnBLePKyk+CX+XGY7LL/mZwHTxwblvliuMDgD3A55X5/Z
	0Xd8M5AUzboG3OniQLRhtTk2szaJ24g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-YTlaVVZsPY-3dKH69Jk1JA-1; Thu, 09 Oct 2025 08:09:42 -0400
X-MC-Unique: YTlaVVZsPY-3dKH69Jk1JA-1
X-Mimecast-MFC-AGG-ID: YTlaVVZsPY-3dKH69Jk1JA_1760011781
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42421b15185so746532f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:09:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011780; x=1760616580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ZhIjY3l8N4e2YFZVy8mnM0qXsDz2ky3cyLq2+Ya9mA=;
        b=DP0s+dhNQw/ehHfnkPGEXeBJScEQw34etp99aM6qJLcWeqX9DbgmoppoBQoqL0bNqV
         gS1eMgN3BXXowdz1apLsT+sS9WD6YaN/286O1vvFS+ufRblNRr+SuchjR4urCzdfB3e6
         lTELTXVRklr+EgbGD8khkSsIqmdv4xomALn1trYPWqsYIwG/TQ540YTqNLYd/ZdLE3BC
         QwiOEQlUpO30fQHF5dnHWm2aziK/xw1nv+f4ySh1lic8nNDOnCiIgsaCW6Zflr/StyA2
         Y9ofLIyoOUSdI+6V6bgsr10H0lnyl6nTbtn3rycxkJr4nNKjRts0oMXLuZJrYaes7L3d
         fhdg==
X-Gm-Message-State: AOJu0Yzrtz8BDdXdANuEK25aXYr2TVjfGLseaueLt+tinmuEn2KT+pxu
	/NySJONo+oXOt8tDe7/7RklpFBT54MA1xOQucn+4Yq8HgIMjftd/SaQ2EgtK47Y1K+MmrVKPbzK
	tduWUCh1/LIqtUgU7nP8vUm+6HrAGYtKOGbJH0WHGYAE1hO9JRGafHynF9ZkIw33ZcTFrjbDnj6
	8emxXZApkKY92Wy+JGIg50/e8O5DU11lYvOfn/Wlz8Zb1G
X-Gm-Gg: ASbGnct7vaRZVD7gQ/v26HCuyKkZ+8yN8dfQC9S64tzsTrcuVBI0p4mClUj5343fKeU
	vkT300bNkuuYt5SV98QddjvUWe51ywYQznD6SXlYRq00JnsXMj2++pAahwEnfk2nwF0rvpgw1vG
	zRgb3cvzwMqpJdmDPopSk6lNEHnsznvAT/2T5XPawtYMcbGGFDB6Oc8vEb3YNC9EuidI26XiSHs
	izjq6xmqF+sd5Yzw6vhkziuy/Vs9UeLXNCqeTflvzbuHHGlHDTVjGr68ljbd4YbfLIGTn7Xud5z
	uLIppZYf0KSlsRXUNQBBO91LaZKileIbNN4+x7OKLE1+iaK9vTODpZ/1gN+I2/1h
X-Received: by 2002:a05:6000:2891:b0:3d1:61f0:d26c with SMTP id ffacd0b85a97d-4266e8dd72emr4405229f8f.54.1760011780190;
        Thu, 09 Oct 2025 05:09:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsmSkF460LkHD2+25IDlofiVKLKHiiDWm8oIfc4yJ6PWOj36K6p8u6AeALI9nQxbMHGRDFFQ==
X-Received: by 2002:a05:6000:2891:b0:3d1:61f0:d26c with SMTP id ffacd0b85a97d-4266e8dd72emr4405194f8f.54.1760011779580;
        Thu, 09 Oct 2025 05:09:39 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8b0068sm34567677f8f.26.2025.10.09.05.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:09:39 -0700 (PDT)
From: Fedor Pchelkin <aalbersh@redhat.com>
X-Google-Original-From: Fedor Pchelkin <pchelkin@ispras.ru>
Date: Thu, 9 Oct 2025 14:09:38 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 6/11] xfs: refactor xfs_btree_diff_two_ptrs() to take
 advantage of cmp_int()
Message-ID: <w7xkt5wfhug6htx3kqfqbab7kwco25jt3ha4po2x5isnsst364@73rogswep5pv>
References: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760011614.patch-series@thinky>

Source kernel commit: ce6cce46aff79423f47680ee65e8f12191a50605

Use cmp_int() to yield the result of a three-way-comparison instead of
performing subtractions with extra casts. Thus also rename the function
to make its name clearer in purpose.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_btree.c | 8 ++++----
 libxfs/xfs_btree.h | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index facc35401f..8576611994 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -5350,15 +5350,15 @@
 }
 
 /* Compare two btree pointers. */
-int64_t
-xfs_btree_diff_two_ptrs(
+int
+xfs_btree_cmp_two_ptrs(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*a,
 	const union xfs_btree_ptr	*b)
 {
 	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		return (int64_t)be64_to_cpu(a->l) - be64_to_cpu(b->l);
-	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
+		return cmp_int(be64_to_cpu(a->l), be64_to_cpu(b->l));
+	return cmp_int(be32_to_cpu(a->s), be32_to_cpu(b->s));
 }
 
 struct xfs_btree_has_records {
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 1bf20d509a..60e78572e7 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -519,9 +519,9 @@
 		int level, struct xfs_buf **bpp);
 bool xfs_btree_ptr_is_null(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr);
-int64_t xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
-				const union xfs_btree_ptr *a,
-				const union xfs_btree_ptr *b);
+int xfs_btree_cmp_two_ptrs(struct xfs_btree_cur *cur,
+			   const union xfs_btree_ptr *a,
+			   const union xfs_btree_ptr *b);
 void xfs_btree_get_sibling(struct xfs_btree_cur *cur,
 			   struct xfs_btree_block *block,
 			   union xfs_btree_ptr *ptr, int lr);

-- 
- Andrey

