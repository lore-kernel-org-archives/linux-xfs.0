Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284B23705B1
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807631; cv=none; b=CIEy3jo7E9uvRixgiQyU5+5O0Y+7eyF7I/w1CLyz11p2T0GYBoNG4JM9iNlHCrRvSzk0WsbKYhDGjizwtb4AD1PN9Pg6aVlLlaQPwE77m9UmJ+kmjYuOyP3+H0m+UGpHFGVXiGoZwgm4e986yCjsv4aH03SIY3id2YZLXw5unVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807631; c=relaxed/simple;
	bh=mSQpopMs8dImzlrX65dFzEQHkhmtgotammgYg2xJShw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZprldVLMXAHLCL5OJ01Kp5B1BgUkny+SfcvJLu1w+Fos0bzS4qJbUwLaSpDb0efyCeDXlRxQfflVggXmAkwhjsDj3jcwdoGF40bKEAjCUPT6plAdCCEnpct1v16bC8pvy1OgZPD+jLYYi5VZiBnixJaMaDmdtuQouq2Cmrqna8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=PFgN+rvT; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="PFgN+rvT"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71d5fe46572so15101067b3.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807629; x=1756412429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2mDquPBH/1dSQpXa532hRheL3YkOl1FWy6w71RzklVE=;
        b=PFgN+rvTFe6Jh697lf1YTLQHfjBouKpYVk5go+U5yPIR+7t8W/QQirX8BnnzjA/2Zt
         pGbo48pXs8xgFv+9nqMMvAgc7fagC0nm5kpfiFDxh2iyzjorNfO03gJ0MymoxwNo6QYZ
         wuO0kcqeePoAJWFDfn/WoFTCsgBliTkAI3l/7wSjB8/hFzEejaCxEFu92HtcP8aSsCkt
         fFTuULHPPIsgGlOA5KpRaaCi3ree7O+Az5uX1aToadK6O/gKSoZPu7U9gNJjpvqDRx4j
         wrshbWQFUNwI3CI80xtd/UF4eJXWKNPtBRCxg0N58mdztawSIzjMvKAt90cc8IGmBrfn
         lMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807629; x=1756412429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2mDquPBH/1dSQpXa532hRheL3YkOl1FWy6w71RzklVE=;
        b=XGJfp+j8VsgDX6f9ypgTwswGy39jEOMc4BGFxYQlwGdjZ7uH1kUi1ygcBUbEf5poIn
         qUG5XAtA55ogrV9AYnx0r6TUDhUtUrRxIM/rgR99tCROBzNawW+rYkw2NXFcTHE21pEr
         1re3rRjrUiGxrVdZtdXprosdWGqkXVH9qMMxY+LtbD1X3KkFVxp4H46zNFo+HAZDnb78
         jdNevi8DFXyfPCxMo5FhkU9h6os93JIcaBitmj1vTwz6OkZwl+DT+Qy0n9hbOh9MlOe7
         5aihcfwcKgkxBW3yXZFY75CTGxRT8oTVp36g3ymn/nSEjGqYdAQIfrhiDVi9R2zJeW3w
         o5Vw==
X-Forwarded-Encrypted: i=1; AJvYcCWrYZ02gjWxW9BPk70WQrd7cgcFPagUO+nBvZIZmOcubEu5F6aXvoFg9FwibEa51WDgjecPVVs3XLs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi496ZkBG2/LF6zRl8pCm0+0m92fIQpUGUflU35QhrutySLu6x
	nyC0x10IEbceMFdWhuD8LpkIyBR2ruo/aXAxpP45+qfJLGlchDA8Ja29rccyHnla7vs=
X-Gm-Gg: ASbGncvcK87qJA/1VcIigLwqX7QNcpams92RAX1uJnwx4d5wMKc+yOR/ybvr8sfE0x2
	pbqMWC29Ch8NcobOij0r1BjVvhVuZ1Eyx85J4ChSYK1S5ZTM67N2cQfr3dOL54napvEjG12+dNp
	z6woZs29/evle6qcm+2PqZFsULi8X6IQjPr4lCMIu00GsIS5pH6r4WlJnKNd2bUUHcvesAyqJ6/
	zAfiV7WHo+MUvOo2wEiit0OxRkRihyezyFzFl4alnsswu1iiZijHL52ayl12kDRU47LRQqEYB1s
	980Qvk7vV8Fnv/wPelsGO6urmKFEB9px5xIH317kGThxhm/ctECElcAKVlhUehxzEvw+CcUybXb
	5YB5495ag9XUfnehZrpJhYJgtvXSjQKGxmmiudgbaIX8zVXf3oyhROT1wzHed4pcTBPVhxA==
X-Google-Smtp-Source: AGHT+IFlxiZ33ZFGeY0+eRtjwiN/2t7a7T8FkZf43ZiG6zuU4o9brNEc8ITMkGpER2WpFIGqL1aG9Q==
X-Received: by 2002:a05:690c:370a:b0:71f:9a36:d336 with SMTP id 00721157ae682-71fc9fb83c0mr40822927b3.25.1755807628850;
        Thu, 21 Aug 2025 13:20:28 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71fa24e97bbsm19766127b3.68.2025.08.21.13.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:28 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 09/50] fs: hold an i_obj_count reference while on the sb inode list
Date: Thu, 21 Aug 2025 16:18:20 -0400
Message-ID: <000670325134458514c4600218ddce0243060378.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We are holding this inode on a sb list, make sure we're holding an
i_obj_count reference while it exists on the list.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 7e506050a0bc..12e2e01aae0c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -630,6 +630,7 @@ void inode_sb_list_add(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
+	iobj_get(inode);
 	spin_lock(&sb->s_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb->s_inode_list_lock);
@@ -644,6 +645,7 @@ static inline void inode_sb_list_del(struct inode *inode)
 		spin_lock(&sb->s_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb->s_inode_list_lock);
+		iobj_put(inode);
 	}
 }
 
-- 
2.49.0

