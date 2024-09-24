Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AFE1A725B
	for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 22:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727217099; cv=none; b=ITjO7qtcktMqYpKy67v82yDPWQqMMvsFKOGqTiYNuTigRmW0gkYfj6h4kvdgnE/oqzOL01zmSWKPGtN0RB1zM8Xt6LyA67MedafJm9VWjDoUMoro6ezJsm7umUN3bTU/jSoYJBgOJZFLtnYjCSbLIghN7DilMyog8A7zgdjFag4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727217099; c=relaxed/simple;
	bh=Myyp8NBhaLrbvyMytpCoFFH0i9Qb2P8Vdv0CCqOLW4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tUzebVJf3EhZ7obC8ABi5NxRrLQ4qMJKD3IB/6e3xqz3uE8eldXA+WTo5GO9C5sZyx6FUq9qBujW0WK4hd0cgxZmOqdySth8mhq+1Jxc67yx/x5gJpqKRzLtgC78AotREy/0nNSfx9eigI/jsp/dKxAYKJ/0XEM3BT4i7b5t2qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AxxGDb6X; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AxxGDb6X"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20570b42f24so67468255ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 15:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1727217097; x=1727821897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kMkBt2ndnZsJ25ZrZgkjn9Q08hjBkXqiZSvNSy1oUMg=;
        b=AxxGDb6XX4iJa5eGBSX1utNh9TXttJPGExru3Y+5enSqCePvOLEU92Qdor/hzcwzcp
         /2YQYZmwRlKK7xHT8YJSt+w8RQkKxOpnx+mQR4Bogkhxu+ECuz7C8AeWVUQYekB6PPEf
         S2MQFafOxOxUm+jZsTMLCkaB7idaNJr9Xn8k0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727217097; x=1727821897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kMkBt2ndnZsJ25ZrZgkjn9Q08hjBkXqiZSvNSy1oUMg=;
        b=YA2R6AYpdgE7vSPnDqtyWoeAR+tdz9AO0H/sspi/7FCtn/a44TPTwW7jaLifLAw27h
         QUayc3mzErJRbp2APlh34adIaVEoPqzjpGYuDIGnDwuamxfGFQm9wJAOuFFkwyhmbqi0
         +O+DbICaqZBz1ob2ge3wMSrUFw733QS6pP5AntHmqujGwGzNcLWyQgAY5o+BIkZs+3k1
         ibbyJNzsS2OZC5x3be5Dz4svfZy0nSOrAzYUyzwEXpRO4YbQyR2br7B8rpExNACJzbYc
         Cph5UgsZPutIPBJz+TpCI97LgoktpP5emt6nGWNuY/X7CKERETu3SZ//MhSp99QCoEHO
         XBWw==
X-Forwarded-Encrypted: i=1; AJvYcCVTg1PL+jBHRbQyYJyrdaefEOowD/d+l19MPGeQtELWKJKKUI3puxIlkJ+l3EYCMA/au0ZMxAe/lvQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx45Bno2bb4M64nQ3T76l3kkk+MI7x/zRQ59298MmGtTgkSUHQF
	Y8sDHFH34+9y1TQekW/ncooF+f6Z3YI+TNwV5SzdMQAyYE1ayrwwlN26L0jQZQ==
X-Google-Smtp-Source: AGHT+IHi46IEddoMQtc7eRLZZt1L0tJfA+KiMR58C3PcPe2AAT7LAtBqQBdqS0JwCxhU+13KWoBQnw==
X-Received: by 2002:a17:902:e543:b0:206:9a3f:15e5 with SMTP id d9443c01a7336-20afc486195mr7676845ad.32.1727217096901;
        Tue, 24 Sep 2024 15:31:36 -0700 (PDT)
Received: from ubuntu-vm.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20af185471asm14234215ad.257.2024.09.24.15.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 15:31:35 -0700 (PDT)
From: Kuntal Nayak <kuntal.nayak@broadcom.com>
To: leah.rumancik@gmail.com,
	jwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vasavi.sirnapalli@broadcom.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Kuntal Nayak <kuntal.nayak@broadcom.com>
Subject: [PATCH] xfs: No need for inode number error injection in __xfs_dir3_data_check
Date: Tue, 24 Sep 2024 15:29:54 -0700
Message-Id: <20240924222955.346976-2-kuntal.nayak@broadcom.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240924222955.346976-1-kuntal.nayak@broadcom.com>
References: <20240924222955.346976-1-kuntal.nayak@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 39d3c0b5968b5421922e2fc939b6d6158df8ac1c ]

We call xfs_dir_ino_validate() for every dir entry in a directory
when doing validity checking of the directory. It calls
xfs_verify_dir_ino() then emits a corruption report if bad or does
error injection if good. It is extremely costly:

  43.27%  [kernel]  [k] xfs_dir3_leaf_check_int
  10.28%  [kernel]  [k] __xfs_dir3_data_check
   6.61%  [kernel]  [k] xfs_verify_dir_ino
   4.16%  [kernel]  [k] xfs_errortag_test
   4.00%  [kernel]  [k] memcpy
   3.48%  [kernel]  [k] xfs_dir_ino_validate

7% of the cpu usage in this directory traversal workload is
xfs_dir_ino_validate() doing absolutely nothing.

We don't need error injection to simulate a bad inode numbers in the
directory structure because we can do that by fuzzing the structure
on disk.

And we don't need a corruption report, because the
__xfs_dir3_data_check() will emit one if the inode number is bad.

So just call xfs_verify_dir_ino() directly here, and get rid of all
this unnecessary overhead:

  40.30%  [kernel]  [k] xfs_dir3_leaf_check_int
  10.98%  [kernel]  [k] __xfs_dir3_data_check
   8.10%  [kernel]  [k] xfs_verify_dir_ino
   4.42%  [kernel]  [k] memcpy
   2.22%  [kernel]  [k] xfs_dir2_data_get_ftype
   1.52%  [kernel]  [k] do_raw_spin_lock

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Kuntal Nayak <kuntal.nayak@broadcom.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 375b3edb2..e67fa086f 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -218,7 +218,7 @@ __xfs_dir3_data_check(
 		 */
 		if (dep->namelen == 0)
 			return __this_address;
-		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
+		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
 			return __this_address;
 		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
 			return __this_address;
-- 
2.39.3

