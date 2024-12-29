Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEE315B54A
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479602; cv=none; b=jibGfv+CAlcGhkYpCsS6UQKNJysEZ5TYSMKs6EnuT3iPL7kmgkE3c30RqwmXK+IQ9apGGfHMpZU0CdoqnWMK3Uundmbd2uKlGM+n4kM/0LGG0mcUtx6Tw4oMspdNomziBNrGBhQ56/T1Se34NNRMoLalcJHUjp9a/tJ5NoA5VUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479602; c=relaxed/simple;
	bh=h4thaH+k6JXo+/ZgSxveN7DUXvlOmoN53VohtIjiy7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ1xAAaiGr40Kp6tMYE+vruyPP9xF0KDyTwFssVehGN+QkuA5O11oyCJ9V+cWGYc9peDSBIxeFUIUhqEebbN5Ut4EZWcOOIB6CIJUbxnjzRfNiaCiuApXeq4luByR5g4+qN9Lj437mZ7w8nJuOV/e9cwLa5po87ePSV98iEyVdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IxaVj5PH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IxaVj5PH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MWSZyb8SBRy90m1wEqbld08O/xzWXycggg1gdAQ8WZE=;
	b=IxaVj5PHUBCp/bJNOOnPI69BxHtAlguOR+AIUtfkkhBIQ+xzqlt9u0lrEA47TSZPp319b5
	Fix7zwKJM01bHPOvqmYzZPxbqOEulVeMTNagIRZcW56pM7Xx35w1k0v3rbZJg5qPbyF/OD
	BUzD8V4KhOZLYapRQ2d34eKf3hE2ons=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-68nsGADVNKa0COjrKLsYvg-1; Sun, 29 Dec 2024 08:39:59 -0500
X-MC-Unique: 68nsGADVNKa0COjrKLsYvg-1
X-Mimecast-MFC-AGG-ID: 68nsGADVNKa0COjrKLsYvg
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5d3f01eeef8so7495786a12.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479597; x=1736084397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MWSZyb8SBRy90m1wEqbld08O/xzWXycggg1gdAQ8WZE=;
        b=UurCsilH2+SLhJtpBQojBe3h0T22635ptHp7NYaFp06GqTkA0gtMMVbz1Jbop0xdzy
         hdus2xKtoJCJZdtvvsn1xLh1TNtAmP8o7syFnDLsodsKPiGbAsK+Lur2e+mdGBRX0Wrq
         glLqwaLoBj20yk6gf7Kj+J6i3E+xjYXkqOzOgWaYho4Bg6prPE7REKj/CRSiw+qNdB3t
         5n42Hs/GQiz5OfvAAftX/gK4PwVZ4wRYT2vz2UTLbDWILZWxP458dTnmqfq1idHq1czu
         RM+sabbL+SI9xr7DgGgsF+Aiqq+qetQeqhViYjiexkX9Ry4aJloDmsbnIJy58qqGE0oa
         6UKg==
X-Gm-Message-State: AOJu0YwgYlRrgyJFSNWzDzGUIuuZdUhYUrEI7i8fuON8X7bpD+a2aqHS
	3MHOIbyEVl/5Oi3HWMz/ePrJCcLJFZ7phPhQjeQePbcIyVZLuTbzQbafOGCRGlDcweMp3BSMmKZ
	Kjwqhy65/4B8eEtjfN03DaDnsyGzf61dA2wQZohbRENGIYh1EGnT0WB9KtqBdHmQg8Ivp6j+VKk
	F6EnEujctfmbn5Tyliw6Dw8qggs+KXcF4j0L8szVFN
X-Gm-Gg: ASbGncvKPvC5/Y/tEp6p/i4Kk/kn5pg+B48fzQio0+kT87Hy6tx3uL1oAkN8yQ/DEuy
	EyOHvsdf6Kn6KrCZpYr6AD0XTNK+DAv8NiNShhXNGsCNzR153RZLK3g/DhL3bA1jJ5LAm3Vl+Kl
	cCxPAX0bMmlYQW3FqtEKUcNoXoaHjrl5M91fv/5Q9ZtrDvQj7qgxRDSrGug2Td3wjUMBoceZrZH
	IJcFjgordYnZKnwtlH2imUHFMYVJaV6PWmnkeI5naHUxtxvAEEouhDexfwSNklB4oe91dpjmAk3
	5gXiyrGr2NmxDRs=
X-Received: by 2002:a50:cc48:0:b0:5d3:cf89:bd3e with SMTP id 4fb4d7f45d1cf-5d81de1c92cmr61739905a12.30.1735479597389;
        Sun, 29 Dec 2024 05:39:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHWl1XsEsS+k9rOlJgYZQGRexZKirN1Je8S19ny16JWOJGdelwSKeW1CZj2FtIZ80Wa5o29Q==
X-Received: by 2002:a50:cc48:0:b0:5d3:cf89:bd3e with SMTP id 4fb4d7f45d1cf-5d81de1c92cmr61739840a12.30.1735479596981;
        Sun, 29 Dec 2024 05:39:56 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:56 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 07/24] fsverity: flush pagecache before enabling verity
Date: Sun, 29 Dec 2024 14:39:10 +0100
Message-ID: <20241229133927.1194609-8-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

XFS uses iomap interface to write Merkle tree. The writeback
distinguish between data and Merkle tree pages via
XFS_VERITY_CONSTRUCTION flag set on inode. Data pages could get in a
way in writeback path when the file is read-only and Merkle tree
construction already started.

Flush the page cache before enabling fsverity.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/verity/enable.c | 5 +++++
 fs/verity/verify.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 1d4a6de96014..af4fcbb6363d 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -11,6 +11,7 @@
 #include <linux/mount.h>
 #include <linux/sched/signal.h>
 #include <linux/uaccess.h>
+#include <linux/pagemap.h>
 
 struct block_buffer {
 	u32 filled;
@@ -374,6 +375,10 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 
+	err = filemap_write_and_wait(inode->i_mapping);
+	if (err)
+		return err;
+
 	err = mnt_want_write_file(filp);
 	if (err) /* -EROFS */
 		return err;
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 587f3a4eb34e..940f59bf3f53 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -9,6 +9,7 @@
 
 #include <crypto/hash.h>
 #include <linux/bio.h>
+#include <linux/pagemap.h>
 
 static struct workqueue_struct *fsverity_read_workqueue;
 
-- 
2.47.0

