Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4B9329C74
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946923; cv=none; b=Wg3sOkip/keCTlKRA/q2Pa8RCFq0vCfgQptnNFwBt0JM/Vj0Jhyri2dBA4ZhsSFbnhO6myE/lqX0s+4VzMrhGMeNTGJuGrl2nEKPGELd7Xa/BwINf44K0eIaiD7JyDoQdARnwleys01ya5zPE5k00y7vcmlbTMhgtuPW7J53XQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946923; c=relaxed/simple;
	bh=QSISyS43uiodKW55y0A4zJy12XqGbRyo3nfKgDoTz1w=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sffMN/KbpXMklkVP+cSNUaDZq081Chq+t4+9QYP5qnffH8lLL3Fe0I8b8OrAO9HyzpK3QXG2tAk2FQEccTeab4Viy39lwQlVYHN0JuW2r80TYqgpkF3+cX/LljGHG+7aY8fmY4Kr2Jk/8AqpubGY4Vl4XnGvO2117gc3xxscQ8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MnVnisKV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BlAAYL+U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MnVnisKV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BlAAYL+U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bl5Gj5NXnNr8xcBo4q+mWeMYRu1rgZV6hfh5U0rIP8Y=;
	b=MnVnisKVt9tyYyVXm/Sg02IwRcfJ1/P/8+KNZ+IGtTpNilYVuFnuTg/vl8CJsv0BZi4TI9
	6omg7L845RTkIoArLcLMlH9k9f80sdMcXTtQ3M1zC2ZdgNFILa1wNjINCMaurJGi8nXctQ
	XOO9FfeZ/veiUyEajSdT/XTmip1IK2Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-7P1y6s7GMGCe39O7PLYPQw-1; Fri, 05 Dec 2025 10:01:53 -0500
X-MC-Unique: 7P1y6s7GMGCe39O7PLYPQw-1
X-Mimecast-MFC-AGG-ID: 7P1y6s7GMGCe39O7PLYPQw_1764946913
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42e2e447e86so1236435f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946912; x=1765551712; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bl5Gj5NXnNr8xcBo4q+mWeMYRu1rgZV6hfh5U0rIP8Y=;
        b=BlAAYL+UeqABKJg1aSPPynqS3jJeTS87ccy5/BqGY5+OZUqAkXbk/8pQgszv+hJ8hV
         IOiPWrEXwmL1GZtzQbGSf9TrqG84PYCUI4FsKAsQBQ+7nkbIFcd6yeVayExOYsQVSgNn
         bx5QX/vL3k11CYFdLf46ViuqCbtpv6jtTFqunASOGy69CTw8y7jU/bs5dmlwTKumD1eC
         M/D80ha7AVwMvnq0GELJaZvTRCbb0a4kYhyiSQtOxAPby4YvUCJ5yHDgCGZb0kLbt5wn
         6/392gG8fzgcDJdTkBPImOb39sOSUWaBMTrhD+YdCi65xusyK8bmC33lErI5Lb84chc2
         78PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946912; x=1765551712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bl5Gj5NXnNr8xcBo4q+mWeMYRu1rgZV6hfh5U0rIP8Y=;
        b=lFwAa+CMBaUkFjYDEvvjfDtlELHywXKedj4Xmfuz9einLhynDQewkHweRuPrguzpO2
         fAXmn85aHTiQIztSs079fwnhbWw+aqGnOslXkV0VbJyPlLMYCbZq6BC5QcxK2N9Vz+Pa
         42un2aJQqtgWI+9T3WnnsFIDsCm9M3uvFHeu975LRNwiEI67grvw6hnC6Ghp+JTid3Ms
         1+Bnw2kqcaf5peIjb6RMBRaEY3ICLD8Gzm3T3BC+M2gGYL0KcAARb0Q9gYt2YllKFV6x
         AO2dKZqSUQBiSOEAMq+UODTG4Jwyf+hWpDdD/zILcenz0BrcK/wDpKIzkKm1o0PbR+3k
         hMCQ==
X-Gm-Message-State: AOJu0Yz78Sy4+nvSEDcP/x6iBPn+3OJ8JwPWjzTVi6dyEHy2wawNaakR
	RkrAIhvAEXHclth+UVjMCn5MIvbF2MK3skSsIxPbDDoUwNsMqGXPnpYzh0eITZ13NKqJo+13VDj
	m99tcUmOw41DQp7f1fOoiBRR0SSpaVXdkNi+S857R9MyaITzoG/RVvpqxyva4ydTUhtfjqXz/LU
	/hodePefIlwMfWx48dOeNPdNpmrPvKrsayMWbueKpYMdBy
X-Gm-Gg: ASbGncvgl9AGsXKCk2KEX/YJsNfVGv7jJkQV10iXJAhEX8LzcrSHPnCcCn9hj7HGE+q
	9bVeUK1kEkbmoGYsS+hTAKZIM5uag6ekIUKkeFIiKXj4gfUuXSJJwkaf52qNJeBMcEVKBl4YrHJ
	9md0TX8iYWVe+8OQM/p4vgJ5svv77iLYavZMSmZDmE56EA1ZTA0XeWzPLsM/7rtfgLpCx3pxic0
	za6EtVrd1v2rR/kmCHtgS170rC4y75chpok9XYQvCMsDwzX1zTAtq69Z91nBTVi/mhrIYsigqZE
	be4B37z9uHh6MDTbG2gsC+lLQqJEoy7Om0S2pFluuX0Ko2QSUazErRP8SNSuutCR1V1r3d3j/Gk
	=
X-Received: by 2002:a5d:5f53:0:b0:42b:4267:83d5 with SMTP id ffacd0b85a97d-42f73171ca4mr10377637f8f.8.1764946912013;
        Fri, 05 Dec 2025 07:01:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEmWk3uNr2hbSzGI9TCnxeODeNXvv2CNMwMAE2tK0b0Omtl+UQHswYGDwAoPG9cdBbEuWxdLw==
X-Received: by 2002:a5d:5f53:0:b0:42b:4267:83d5 with SMTP id ffacd0b85a97d-42f73171ca4mr10377591f8f.8.1764946911455;
        Fri, 05 Dec 2025 07:01:51 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeb38sm9090735f8f.12.2025.12.05.07.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:01:51 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:01:50 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 5/33] xfs: convert xfs_trans_header_t typdef to struct
Message-ID: <ow66l3iycgvp4loeb2jjpfu6iqlxozb3aocbjynos4znimenic@5dlb5haharmr>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/util.c             | 2 +-
 libxlog/xfs_log_recover.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/util.c b/libxfs/util.c
index 13b8297f73..8dba3ef0c6 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -86,7 +86,7 @@
 
 	/* for trans header */
 	unit_bytes += sizeof(struct xlog_op_header);
-	unit_bytes += sizeof(xfs_trans_header_t);
+	unit_bytes += sizeof(struct xfs_trans_header);
 
 	/* for start-rec */
 	unit_bytes += sizeof(struct xlog_op_header);
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index f46cb31977..83d12df656 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1026,7 +1026,7 @@
 		/* finish copying rest of trans header */
 		xlog_recover_add_item(&trans->r_itemq);
 		ptr = (char *) &trans->r_theader +
-				sizeof(xfs_trans_header_t) - len;
+				sizeof(struct xfs_trans_header) - len;
 		memcpy(ptr, dp, len); /* d, s, l */
 		return 0;
 	}
@@ -1079,7 +1079,7 @@
 			ASSERT(0);
 			return XFS_ERROR(EIO);
 		}
-		if (len == sizeof(xfs_trans_header_t))
+		if (len == sizeof(struct xfs_trans_header))
 			xlog_recover_add_item(&trans->r_itemq);
 		memcpy(&trans->r_theader, dp, len); /* d, s, l */
 		return 0;

-- 
- Andrey

