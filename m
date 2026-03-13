Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263DF2EC0A7
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 00:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773361650; cv=none; b=tUtW6JOyVYoWQbvnkPugDjTNGXRUCfiwAvIHeslrOyi0Q2bBMOtdBIRG+TtuJqYALCwde04K5pBPg5hDYY8EywLL0M7G0224y9iWz2LdkxnWeXAruhweZp43X1+dndthO93CJjF0/xkVzIWI+EJw2GcYFAmoQo007sR31ILAsvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773361650; c=relaxed/simple;
	bh=1jeAbtCc0wb6+75qvfvtnR2x06WaRasamgpK9jBGMds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vpp3ISY9JLXVWIDv/Tl5Q/OPw4qJHmUMwffXwlDdQMY54sbj2IhHxk+lYL/th9/tOBuxuk8fzYmgqcYRDTpa74jqXUNCeNzpxiFAPWe74lGGjB/sCLI4+DyQk+nRi8TqgeIA3kZ/f0353t6oDPvi/b8kIwAC57J7xRXKH9IiKLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nTENg1p1; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nTENg1p1"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-356337f058aso1066291a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 17:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773361647; x=1773966447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YwLC1JR1IsSBPzl0USz0aQLDm11FVI7h8PYnGj4Ak7w=;
        b=nTENg1p1yZ54cpk0W/MdndDSczP61Bdi8VI94yy67mfniFg8EoPoT0khsHNRKlh2Iq
         xoqfadCIbBYNTj3/mN+S980Dov/4d+yJsWssAsujurOcNkeMWUHgxwj4acaA5Yb+1HHD
         shJoc8nvDZx6oH7I8HDRr5dVnwQMcJK/9yi6Ot/yyz0DGV21ZTa2IcjfVIYNbTf0KiLC
         RVYO3Kgns2a6imE7K1l/1UMS945SOphjiLMV2f48vT4KYgQBheD4Gj39o5Z45tcgSi5B
         UYWOhpNdB8N+PFgcwDoh6DThVTVA8jlQtqhLwz+kMyrR8JzW5HCqW2lg+3i7XhweHR/4
         qLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773361647; x=1773966447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YwLC1JR1IsSBPzl0USz0aQLDm11FVI7h8PYnGj4Ak7w=;
        b=nb/8c8+MwIo5bkKurb5FZ1fI+JjRyidCcjgl5bZsCO+IRwEmSKMWnZKVFnz82XSwlR
         jOdbWSZXnNa3NoVLdE2WoxNtSc2F8XlTNspoiFNxwbmyqhtczd9w0F+jzm7QkK0aAEbq
         YDE6BlfD9KRq2j1OTbd/GSEd2h07+3lrbO5UiwGj86J9z6yOvMy4PFPzGvhQQOeotfyQ
         JrUIG4KDCqpk35kM9Oymy9CjdDMkz6xB9eRKB/aRnhFoJ77J9xVhammrDOSr4ZQWCOc8
         7PCfeAU9gNjrLuBnh7EyUnv+WRBAohLn9vUUhZ5a/FmPLVcbogQaK3DfruQNAt/gZHm0
         yrCA==
X-Forwarded-Encrypted: i=1; AJvYcCWYybiJ4GG22D9Ro+KYQv+rjIki2qoDxqyBh1/5oVUNuC0ZuKiguR15rgx9+M5dIFrQ+JDM9iISENQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx2mWQDDCyLOzHKEfZSqpMxiC7gTzUmjnHFG+u/LtxCw0u+9l6
	R3+zdBZ91VhrZ4NVagMmRtyHpay2GXOzAsnS3R2saFaQyqQKi7b6kXMX
X-Gm-Gg: ATEYQzy8AFPKldOZlu/6+KMQkGm1LHJLnPqDE/7bdHPME3BQeK1FcmYN9fObAOltkxD
	nCEwVFXl0DlpRRmcRnfbHuG0ZjbK7lxinoYyNevFNeN+LhuPbwXsvZfrWX5IaRnEB89yfSe/ogc
	JpinOMv9XVMARblLl9fJPagL7M48nfb3omCVswRTssL2QQ89DjQwZGwu731tckpxH83Z15Et2P1
	16WqxvZcEIuMoyerk54WMcU28fAIEaivMj55ePnb474+2PqWWsL0/Id4XGAbQHSlYQ5l0gJfJzX
	t3LtMX5+JXlauxV0Q1Wc7lkXkJzW05aFRCxboRkioJ6M3inHqIG6ZKJUsAQTbumPm45iqiaOpXM
	yEZ7hAPCHu15xLknF3m6pMMgJrVEuR6ozXqzEajynG/OqEYPqjGUSDOZ+shn2bOuTHEwhW998HE
	ouNaPj/D9AW+nhTCi+dZ9DRVcOoKFYjwL3CzPF5+r6aLO3MtUjZd+wrpHmMTUZ
X-Received: by 2002:a17:90b:1b51:b0:35a:329:73c6 with SMTP id 98e67ed59e1d1-35a21efc534mr1302906a91.3.1773361647205;
        Thu, 12 Mar 2026 17:27:27 -0700 (PDT)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a02ba23adsm6528427a91.0.2026.03.12.17.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 17:27:26 -0700 (PDT)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Cc: Alistair Francis <alistair.francis@wdc.com>,
	Damien Le'Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH 2/3] man/xfs_rtgroup_geometry: add rg_writepointer field description
Date: Fri, 13 Mar 2026 10:24:55 +1000
Message-ID: <20260313002456.3823811-2-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
References: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Update the man/man2/ioctl_xfs_rtgroup_geometry.2 to add a description
for the new rg_writepointer field.

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
 man/man2/ioctl_xfs_rtgroup_geometry.2 | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/man/man2/ioctl_xfs_rtgroup_geometry.2 b/man/man2/ioctl_xfs_rtgroup_geometry.2
index 37e229b43..5d264acac 100644
--- a/man/man2/ioctl_xfs_rtgroup_geometry.2
+++ b/man/man2/ioctl_xfs_rtgroup_geometry.2
@@ -23,7 +23,8 @@ struct xfs_rtgroup_geometry {
 	__u32  rg_sick;
 	__u32  rg_checked;
 	__u32  rg_flags;
-	__u32  rg_reserved[27];
+	__u32  rg_writepointer;
+	__u32  rg_reserved[26];
 };
 .fi
 .in
@@ -39,6 +40,11 @@ filesystem blocks.
 The caller can set this field to change the operational behavior of the ioctl.
 Currently no flags are defined, so this field must be zero.
 .TP
+.I rg_writepointer
+For zoned devices, return the writepointer block offset into the respective
+realtime group. This field is valid only if the XFS_RTGROUP_GEOM_WRITEPOINTER
+flag is set in rg_flags.
+.TP
 .IR rg_reserved " and " rg_pad
 All reserved fields will be set to zero on return.
 .PP
-- 
2.53.0

