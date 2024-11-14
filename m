Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976561AF0CA
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731598107; cv=none; b=q3iRX3hG0jEfZfAnbV2wsh8vWXIC0U+UaGHiQJjSELvOLsMFKnzuISpdM0B0X1Y3kXdpos75k9twuolbVLuiJkUZ78ZhCIRvNkB5htNbmM3hEAE3IvkAgc0Ua63gxjbmll8ZHNsbNVZOjfDyNFgmtvoBFbGXX02ncHeZYVBnStA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731598107; c=relaxed/simple;
	bh=EWturTTFhXmkkEY1vgH0sCBOxeoOqbPcFCX1D34ye48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkIeApWHlD8csUWchm5OOZfudAKzjvWLybzY8Nu+j6athPjUEl8iVvdUZB6wl1ekHAvVkW4y/wXCVcjUerVCba3P8Llsfl64xtd6Q4m9aud/PZlDM+qeehJx6sVaaoMANDOlUxoG2f6K0DtlIuFjy6Ij9+KvvY/G6HFlO08opZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Vqv0OtCw; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Vqv0OtCw"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-718078c7f53so318712a34.1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 07:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731598104; x=1732202904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NyBHBKICHAilzWbXxQX4w3ArnCN9Xkn7LoXdkHxZ+NE=;
        b=Vqv0OtCwgRDqsZtuQe08cRI5AEU4os8/ta0n4eX/9ZzESqQr69CLPRaiNzfcALUAMb
         aCHuZLxROp6xGe2OFYherg9GVvtPc4ZPytYRlb7ZAU1YXLo73tMCG8+XXwbnEdRC2apn
         F7FVPaW6JyU6pWRUOovA9Wsor71N2l3XfSmtTGH9Wlaov6WWbD8BrbVgtJutLcEn+kS8
         iffYTdAD3JeLbC6yYgcbX+1+CWmxard7f0dv66gi42wzXTfeawuVkxuMUFVygJRVBlWy
         WrBfOK2BNxRfRDtbZujF1cDTeAzQWfWRinS1A8GeBXJY6qE0+I6Sx52yGTaII0XUT6rW
         n7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731598104; x=1732202904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NyBHBKICHAilzWbXxQX4w3ArnCN9Xkn7LoXdkHxZ+NE=;
        b=v0o9RLGAdbYnfS3cIvehGOqKOfQ8CblKTbzaTp7n+65DvSEhAScdEFgm6ToCIILXxT
         R3vns8gcPEQnTMD3szswQyxYcGV7zzIqS8yKvA0GeF3NOUOqOQ3aN1Oe7SpCK3oQMEzH
         jDmpL6XW2LTQj177n4ESOF8+wBf8CHOsoXVgCmle3JmzoYPaSQ8bkuugnUJqNgJbVaLX
         PNI9NTpimchbzAD1w70oSeH260vCknGuaBOVRZGUMUdN9RXefZE2+NH/elqwBVRWp2dr
         7lHUII+TY1DvFMh75Ycac2oTFJ6STS7ZEn3XSOiL8bcL+kq3z2ADdpjUBk8u+v+0SF0c
         /kIw==
X-Forwarded-Encrypted: i=1; AJvYcCUs371bGZikdhDPkL9GXKEU3SKQbY49jzc20+LWagRe07QV2V71ooOMwqOQ3/N9RTkbWHZoN3xwQTU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkoO+Jl7t5FhV9johWkD6dCsggCwD4Wurq2HxuHJ0tKehYQqjm
	E4PP935+Tw9+m7bZvQNanJyIXAwJh8OcZvs1gd2oeVdW6S38nTovKenQe7l4+cU=
X-Google-Smtp-Source: AGHT+IGTccgjkWiSk1+iFGbOjrOkQSSEn+5BvJmTbBLfatp4glFbzMa7kfcy1vSIijdABdXFBUl4NQ==
X-Received: by 2002:a05:6830:7101:b0:718:8ce4:6912 with SMTP id 46e09a7af769-71a6af419f8mr3092006a34.14.1731598104601;
        Thu, 14 Nov 2024 07:28:24 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5eea026eb41sm368250eaf.39.2024.11.14.07.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 07:28:23 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: hannes@cmpxchg.org,
	clm@meta.com,
	linux-kernel@vger.kernel.org,
	willy@infradead.org,
	kirill@shutemov.name,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	bfoster@redhat.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/17] xfs: flag as supporting FOP_UNCACHED
Date: Thu, 14 Nov 2024 08:25:20 -0700
Message-ID: <20241114152743.2381672-18-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241114152743.2381672-2-axboe@kernel.dk>
References: <20241114152743.2381672-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Read side was already fully supported, and with the write side
appropriately punted to the worker queue, all that's needed now is
setting FOP_UNCACHED in the file_operations structure to enable full
support for read and write uncached IO.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/xfs/xfs_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b19916b11fd5..4fe593896bc5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1595,7 +1595,8 @@ const struct file_operations xfs_file_operations = {
 	.fadvise	= xfs_file_fadvise,
 	.remap_file_range = xfs_file_remap_range,
 	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
-			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE,
+			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE |
+			  FOP_UNCACHED,
 };
 
 const struct file_operations xfs_dir_file_operations = {
-- 
2.45.2

