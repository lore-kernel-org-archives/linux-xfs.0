Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5474340E8FE
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 10:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783593638; cv=none; b=nW0JBfCmjev5cs9uBKHREYx+nQv/6JjnNW7pHEmjCvdnQFNpDaR1yarwQ4F1iXXGVig8ma1ii+I49N9TLbMGUXlpBZ/KRIaFRyQClbBji4x230v924Bp3Ppq51Yl97Dv4E9FuG7f93Uv9YVJ5mg5pbnqgGwNNvaaWSpspUKFtq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783593638; c=relaxed/simple;
	bh=KOkyf5hIdccqFsYkbaGvv2UJzJTTaV5EHJfb8FZsdWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zb1ZPIQGOeHveBWhahQyxFRuf3k/1Xv1w2T31fAhR20kGMPLY54wZUdL4H9BneRQlbyQqmrV/o0dkguhYDZ2g/DEtcflLYZ32FZ6K/aOD//aSz6dOu8eDxsf0m02Cl9hcT+8/9i2eyT+PVkzV2oG+FJp4idZpt0QsTv86QBalRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S7k2HCh2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oFv7nhL6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S7k2HCh2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oFv7nhL6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783593636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JDXXOZGXzD1jbm8e256OV8Pcd54w4r38xACw+ZjV2Hc=;
	b=S7k2HCh2SjZbvH58eMX162GY8zgYXM9JmCOlJSMbHqAPaHsRO993UpObJ2GmmAmjztOU+T
	pECUuKCPk8KvduZzGBPhvEfqqiERUo6Cj3PXw6QVSaklf+qH2n/7qohLNct1c8V9hBpRuM
	rEOeSJHZXYB864FZ5mzIfUvsPwZ1JxY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-loDdTOWHMiOnkBAygMZJjg-1; Thu, 09 Jul 2026 06:40:35 -0400
X-MC-Unique: loDdTOWHMiOnkBAygMZJjg-1
X-Mimecast-MFC-AGG-ID: loDdTOWHMiOnkBAygMZJjg_1783593634
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c891ed872ddso2952903a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jul 2026 03:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783593634; x=1784198434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JDXXOZGXzD1jbm8e256OV8Pcd54w4r38xACw+ZjV2Hc=;
        b=oFv7nhL6NaK6ORYdEiI/Ta9VhHcKxOEI/+NgipdXUdkcn3ef07hPwuFvYWiyqZajwd
         HYQTg2oPh/2vmrhYnIl7B8nzX1gvaR334QoQjMbGafRvoSnAMf1p6+g5ol2SwpJSISFn
         FReIFiUTww2ZutRY2A4vlGpvgmBC+B23hYpzjIY8hGyg7eTG4BO6zJBUzoYHP/Mo6/QM
         TYizxRHSWKWQ/sbuQpVDeHGIJIgOK0ukuTKNyVKDvthvzAE6pzdnGfWlPcm6iewneQhM
         JcQ2iJCo+W0lSm1W3CN8FSk57sRh/eQHlwqIJvu5s3846YVmzef8t0wfUk7toB00wEuu
         ELFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783593634; x=1784198434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JDXXOZGXzD1jbm8e256OV8Pcd54w4r38xACw+ZjV2Hc=;
        b=JC2Fojxqo0C2WPsXUUZ2csAbfETUaSyi1j13koT4VeOd7rsCTOQ+SmZll/IRQE9Q6u
         QsxOISI8R0zQfI4slJ3FcZ5CGQrWiYGuy/BjzyAY7N9ToiXRPEzmLWQEtQAowFvhjqP4
         7rfDshc8Vcfe0S/llVV/SEwoaA0BYWLZ0gz/k0rLhrXjanJc2yF8camjLbRNIcCDY+M0
         SOx/efs75lekGhW1bVnwDh8parIx6Dk1QNYqpQhjy1IQ6JrxPqtcF23qFgHYz0sGunwM
         +F3zI8wc9288FhjJNKwlS/NeYOw6zFy+qllxpuh8w3l9ygPxiVY4aiCSfZnnEKhkY1eb
         6sVA==
X-Gm-Message-State: AOJu0YwCjWow/lp9UygwaYsT2bqSb4ZYWWRg8DA7kjhgFMPmJuZ+4Ky6
	0foQMF3sIGKH9kkxC99C4TxuSP8aGe+aijMy1CxZAgOT384jjqWGeiQzhIIeXJZV8QtenL4Id3z
	Sye5g0XYxBm0g3ri18BRcREaH18wg6clQs4HK90eXny3IuU+xvZ3tqUeuWbcdeGug0QivhmJH7I
	+NhcPXV9SecMs1DR2X/U12rZaUEGDb7Srpve0CYy+DaUR9hg==
X-Gm-Gg: AfdE7ckBfLkMZCW0wxjtVLqkUbN0skVFxaiairKmsn7aBL+EUsl4A1P80eVnmTNjw4Z
	0AAwTxpTGqYGdrkzydu/aGUYwzYLbP39l+OMTX8pnpNgo4HusL9RGy2z3j6D+2YjdCRx7jcAdw4
	+1G78p7IRO7hbTuVhAZPOllqFvEC63letSkZ3KqPCT3eMdPoh9ybk1ol7sVsPhcMuasm9dXYhAU
	vO512Vp2bDr+wPs+C6L1Xo+l23d8E+1+ECGsO8gFY4MwFKg3YEzCExGJEnbIFkV0T81uA/jfpGD
	v3nDcm8udetUYZwUCkH/SSQZUJ93ZhO4Er6PqhDQzUGFhoNUApIwO5KM0tL7Bnfeamrb3VdMtIo
	cMZAn+rVUoCyV7TDM34ki6B9Gln+ehtOWkUyVzJ7jn2ppNOo=
X-Received: by 2002:a05:6a21:329e:b0:3bf:d1f9:b1df with SMTP id adf61e73a8af0-3c0bcc241abmr8292384637.54.1783593633890;
        Thu, 09 Jul 2026 03:40:33 -0700 (PDT)
X-Received: by 2002:a05:6a21:329e:b0:3bf:d1f9:b1df with SMTP id adf61e73a8af0-3c0bcc241abmr8292341637.54.1783593633360;
        Thu, 09 Jul 2026 03:40:33 -0700 (PDT)
Received: from msinguru-thinkpadp1gen4i.bengluru.csb ([115.110.236.142])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659d7c8bsm31533656c88.12.2026.07.09.03.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 03:40:32 -0700 (PDT)
From: Manognya Singuru <msinguru@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@redhat.com,
	Manognya Singuru <msinguru@redhat.com>
Subject: [PATCH] mdrestore: fix extent length overflow in v2 restore path
Date: Thu,  9 Jul 2026 16:09:15 +0530
Message-ID: <20260709103915.275363-1-msinguru@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Aisle Research reported that a crafted metadump v2 extent
length can overflow the signed int used for length,
leading to incorrect size calculations and a
potential heap buffer over-read in restore_meta_extent().

Change the length type to uint64_t and ensure all size
arithmetic in 64-bit before converting to size_t for I/O
calls.

Signed-off-by: Manognya Singuru <msinguru@redhat.com>
---
 mdrestore/xfs_mdrestore.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index f10c4bef..9c7f77e0 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -395,11 +395,9 @@ restore_meta_extent(
 	char		*device,
 	void		*buf,
 	uint64_t	offset,
-	int		len)
+	uint64_t		len)
 {
-	int		io_size;
-
-	io_size = min(len, MDR_IO_BUF_SIZE);
+	size_t io_size = min(len, MDR_IO_BUF_SIZE);
 
 	do {
 		if (fread(buf, io_size, 1, md_fp) != 1)
@@ -428,7 +426,7 @@ restore_v2(
 	int64_t			mb_read = 0;
 	int64_t			bytes_read;
 	uint64_t		offset;
-	int			len;
+	uint64_t			len;
 
 	block_buffer = malloc(MDR_IO_BUF_SIZE);
 	if (block_buffer == NULL)
@@ -442,7 +440,7 @@ restore_v2(
 			XME_ADDR_DATA_DEVICE)
 		fatal("Invalid superblock disk address/length\n");
 
-	len = BBTOB(be32_to_cpu(xme.xme_len));
+	len = BBTOB((uint64_t)be32_to_cpu(xme.xme_len));
 
 	if (fread(block_buffer, len, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
@@ -503,7 +501,7 @@ restore_v2(
 			break;
 		}
 
-		len = BBTOB(be32_to_cpu(xme.xme_len));
+		len = BBTOB((uint64_t)be32_to_cpu(xme.xme_len));
 
 		restore_meta_extent(md_fp, fd, device, block_buffer, offset,
 				len);
-- 
2.54.0

