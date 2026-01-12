Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1899018A6D4
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229405; cv=none; b=GL/RDf786IJt7QgE9NX1Qcm3lL8X5j+5RWFLGdoNaZbmjd/MUorvuk9giJmfPwijNnbFONl8zClKHewopUOQSex/+4WUGsOdQl+9Hq6K/jAY8SDpbK3UylQ2KgIuh/hKrNvuM6KkoXGU3x78K4rKyFEOisP/zrHAnPlx6uWnOko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229405; c=relaxed/simple;
	bh=QDfZ8MkROd0wJjK7M+RYgL9KXYxxKT+CJ2sFh4GPSIA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtkeLot61uz590FKJsMyKwp5/qpe6H5KGhEqRhIcLvj2OQWqVD4u1Xw7RETSc0x8mjHDM5g8iwhjbZGQouNkYZyjXxmjY2pbA4TI06qtNSj4ATOHCu9uGioBXPyH8+8hYyyHCscJN9Pe7LklkPt5CaiqJxI5dMxhmX2MKrKfWOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HCSpAQRE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fvaA9KOH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HCSpAQRE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fvaA9KOH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4hgQSkKK+wNsFGyx/8yulCRj19FYSipD3tFWb0OgBMQ=;
	b=HCSpAQREQiLx9lwkrXGDu8+O9kGTwNBoPdbHAMnbqhrbgVqcpS/1O995GiJGwZVVZlMCoF
	q0Z/sc6bGCXzB6D105nx4CGRWViDhliAX30XJE6vA6S4kA+/77Hrh2SA9scEYHgFExn6V7
	rLwu37LvatZQB3YVRc5qyJtC9z8so5M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-9OwO98sLPgGxPHHiMyYPxQ-1; Mon, 12 Jan 2026 09:50:00 -0500
X-MC-Unique: 9OwO98sLPgGxPHHiMyYPxQ-1
X-Mimecast-MFC-AGG-ID: 9OwO98sLPgGxPHHiMyYPxQ_1768229399
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b807c651eefso935250166b.3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229399; x=1768834199; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4hgQSkKK+wNsFGyx/8yulCRj19FYSipD3tFWb0OgBMQ=;
        b=fvaA9KOHr4r1gzjKOkgmGDoTtOaq4/zZ9spl/+N/cVUhhO13MsQvOjifxVN0wfwr7D
         hkwt6s2it16Hip+0cwCMUyYnCNT5mZlZUgzpVwJ15SgaDyQRO+Crs6qF4AiWCG+XSzaO
         XV5Pw9cAyhmglJd0y0qnbqdIPI+I8OnXopku7VhiYjEOX9IuobjPVgaas2dsSFi9m+2x
         Yrl6qa3STte5/ZLTgGLUkT7wsLa+6ue8KZiic1LBfkj5lJLEFbRAeb3aYaXC/b67Qmuo
         Rh8Y+FB9uC9JlZiYfodzptoW9gm5FjzgFdqRBe72Q1/MgU9WiHbckURI7+9BqjA0t2qc
         ybkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229399; x=1768834199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4hgQSkKK+wNsFGyx/8yulCRj19FYSipD3tFWb0OgBMQ=;
        b=Z2PENfeGURhX6gcU7HAtELU/OWJCb9iT9GlvWiXGEarZKY74gfH/UZWY0lwq1DQ8r3
         YdSb22/xY6Abg2PD3ycgxm42dyc4XKbmh9K176Vu35S1k2kcRKR2r0nvarfovOMZcy5w
         v1UJ52G1exzicwb6g/AwOTjW39lpDv9KJNZplhU3oplWAlwfsKogp7voUER2OZt91v2b
         4T3tTTXRl5B5r+O5uNOKBfsBfK1yGpGavpWjLgRNg1mJha40r5W3T+axWEYuYEtv6dmC
         5QDoUmM3MFUcjeW9zvPb1aVoTIfAR//bD9CATp4DYHLXSK7kZnuYPAElC1hvRfjHJTWq
         qnUg==
X-Forwarded-Encrypted: i=1; AJvYcCVrHO4tI2b0IWcDAmlnQL/sBzuF5eqV8q0YsVAThIt40JzY1crYqdLZ0IYQnPG6LoOJXIV73UrBeik=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLeamR/0xHXH9veJO6cR9peisz8MIoEAr3hTECzUXXu0G6bRu5
	5ow1Q3CZhiXMEDsEK2v4Fe18a/xKMGYV/+u8f2PdUVnuEx1y5vIZ1a+6kjtCjvS/I5ptlAoVziU
	kl1mjXZa5wTrnPHnpWWH0hT5mveoedI9YN/0jjysM0yvAf4JUJyNRZjTKawQ2
X-Gm-Gg: AY/fxX5sb8XAWCuKpb72QxTsxtWppSa8cBRzpXUzahMip5sxddrwPUj36jln6e/oMcW
	MP8LmXX2ekp9249eT/XTYOmrbOzL1IDQQ970oFNP21YlYx5jf6cqN5L5vzPUXcriHWAVKzy+vIG
	EuvLAvMvuacFC0C66RHqfCY3YgqcyyCA7t0ljI/5Xvpf6QIZLKCo5uayN2SLhxSAnHvHcjDVBEn
	0+SU4a/vFExRf+MA91NxFMDP+facHPSFmx8depQJ4rtlzTnCJlLVePDG10zLUfKd5tgfLRcaEXg
	ttWJ8RfOQma5IzMmhx50x+7MidvX4op5l7nJ1zClcWX9DOTrAdmCNTdP6tQG/kZsuuvBuUU3P4M
	=
X-Received: by 2002:a17:906:ef0c:b0:b73:8b79:a31a with SMTP id a640c23a62f3a-b8444c6c0bdmr1718264166b.16.1768229399188;
        Mon, 12 Jan 2026 06:49:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKY6lRBB+8CcKc1C5F87kN75SYxXHWrYKMTeyuCLT+7rcJtaMRuQ85TjaYABVcbwCN2IaTLw==
X-Received: by 2002:a17:906:ef0c:b0:b73:8b79:a31a with SMTP id a640c23a62f3a-b8444c6c0bdmr1718262466b.16.1768229398665;
        Mon, 12 Jan 2026 06:49:58 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507b8c3f89sm17933541a12.5.2026.01.12.06.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:49:58 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:49:57 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 2/22] fsverity: expose ensure_fsverity_info()
Message-ID: <unedx6vzej4wyd2ieani54tvvubox2epnl4eghv4caykbzinef@g72j7l2hcufp>
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

This function will be used by XFS's scrub to force fsverity activation,
therefore, to read fsverity context.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/open.c         | 4 ++--
 include/linux/fsverity.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index 77b1c977af..956ddaffbf 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -350,7 +350,7 @@
 	return 0;
 }
 
-static int ensure_verity_info(struct inode *inode)
+int fsverity_ensure_verity_info(struct inode *inode)
 {
 	struct fsverity_info *vi = fsverity_get_info(inode);
 	struct fsverity_descriptor *desc;
@@ -380,7 +380,7 @@
 {
 	if (filp->f_mode & FMODE_WRITE)
 		return -EPERM;
-	return ensure_verity_info(inode);
+	return fsverity_ensure_verity_info(inode);
 }
 EXPORT_SYMBOL_GPL(__fsverity_file_open);
 
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index b75e232890..16a6e51705 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -196,6 +196,8 @@
 int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 void __fsverity_cleanup_inode(struct inode *inode);
 
+int fsverity_ensure_verity_info(struct inode *inode);
+
 /**
  * fsverity_cleanup_inode() - free the inode's verity info, if present
  * @inode: an inode being evicted

-- 
- Andrey

