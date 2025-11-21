Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F23A33ADBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 08:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713094; cv=none; b=fh9ltIChjBtSWrl/HC3Z5MrAw/d41BfwDGR52Q4B0npjh6NzcXUcBBzHfaGppx7vgx++kbZt494XRlOUZ6t8tsVzIcT+yKwzeNsijFRXRkNSYROkaTfqeJ2W+guPwO6Pgi/jR06a9tTmYmEyhlXehTQpvck7dqRjjtQ+ev+cm1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713094; c=relaxed/simple;
	bh=+7tflVaH8x7L3VJvig23+lCVNVSwvcR4NvQ6QZjXrp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m4HU4DQOOipBg4Gt9wyX4Wl7TEoJ+czUegfifJ1Vu1x99rxsKhGsPtm4LlquR4yWXfEKdNNDAr8X1fbVeXn3H1zcU6jl4GuK4hUnOPtb+s3XyhbrS3ju+kr38QEDHdWH5gdM4SApArawcHXO1GF8wQyh6hIaxqdXe9S1CTv6NgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3lbr++E; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3lbr++E"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-295548467c7so20457495ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 00:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713089; x=1764317889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HsO4Hd5ROz+D0bqFKvcezOn2Jkcskeai3TxWpcHV0vk=;
        b=b3lbr++EhNcLm+hUHPpMjU4R1FvAu94LDT+I6Y/CmvTMR2lIc+Y/vo6ykQnBdgQwVj
         Id+2LJX6BJT3buIFuo/mAMzXoLpe0jDHK3IpDkbnJ+FybRVHLKI676zPflxm21yHfOJ6
         H8mCuVdsaxpZNqh1pgUDize0Tf5c5HT/cD+phB04tg3r1NqpGtAQupo5DEu9grQd53Yw
         4pihNR9g729te5WNl+dLaHVJUN9QsJLP7ERu/DwNOkyPmeEQhA5uaAScA6xjSdh87Fih
         Lznd1tWleRW7Qj6RrI/FFE/Yp6xtmZadpMqA07SfUXkeWVtAMQKVhNfXFOSM+Y3Vkq9M
         7MwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713089; x=1764317889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HsO4Hd5ROz+D0bqFKvcezOn2Jkcskeai3TxWpcHV0vk=;
        b=ceMElOMAWsiEoM/fMUrProV86kDy3oLedM/yJbczbrPu/l73KQtkf8PVxPT1f5kaEg
         1GySEG3AVmEominT6b6Juq5nb65yt/d8WyofMpFm8yJlR0egZ7zYNKyUvJIbrDmxdom7
         pqNeXmhnNfDHn2Z50UqVQ8UqIR4ZgAE+QfGNniknriN1f2uoh5OIYgqwL29LLv/iyUPU
         xkp+b3YSSAoJf37hjiR4eK/QmZNvykLPdjWaTtrYtpfWQ7HFfQ4vptsAaGuOhKpekBe9
         LjbZRJ4nYgGdIhT9pyjd5IWmXRv6HEbIT68nD15QeKgjJtWAJdJJotALbgRRxaPKcKmw
         VLJg==
X-Forwarded-Encrypted: i=1; AJvYcCU0NbyBXWM6XEX6rk/fDdexWqB7xYevrIdMYJC6zbrSZbuiaZQJAUoX3ap4KDn0L7mwxEKvna8qJ7A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyOpd2JVaqLM2B+RFD1E72qEYvIqNFq/vo3aeeXqZBMc7mmz6+
	BcGqnY9n9jLNqPhud3uMdaCncxe/YojG/ueM51CPbta1EWx11PJKBnF0
X-Gm-Gg: ASbGnculGCiY0R3KxpOnM03JMzz67kRlbYTTp8x1yQBZFkfFe415Z7oAPcD4sBHRpmN
	4OqdNCuJ34I7fVpwq8f3CvaZG2O4485/ZxbhJJns2qQAM6E4qf94TxwIU3wCd+8CyPT85Bz5EtP
	NOs0iBKz6HGnfdqFzmsGzoD1WNufqmJ7eZqsaBPvEyRvqdbF0TcjRR/22B1IdZjzo7+hPOzXWU8
	QktoF2IyKOuF7pbCKpRMaVc03TmeaaI3BerZO0JNAI37BVir8sVTI4uLF51APH6gR1Xm6fzG1Qj
	90QX1lrcjZTEFFz1THHrvWxU3i6ENiB0Z1xjr2XldRwoZgAybQ5h3IuLkWQ9AOUCZdgoxQZUOvA
	jC0Wk9mufWWHmgXRtqeKepwZQKynL5uBJbf1ZxegThTMzPyanE2DXfhvELKTFCXak/0+hkzor7t
	jIG1+HLWEP1+3TCZcfbS1GI9GRPA==
X-Google-Smtp-Source: AGHT+IFqeRBYEjCaG+tIpPdWA+qVKSXVzOiqtjGknDBSdNDUFTnY7ogPNjlccPCj95LHEh6lRlusYg==
X-Received: by 2002:a05:7022:6b97:b0:119:e569:fb9b with SMTP id a92af1059eb24-11c9d708d34mr570234c88.10.1763713089300;
        Fri, 21 Nov 2025 00:18:09 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:09 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 1/9] block: fix data loss and stale date exposure problems during append write
Date: Fri, 21 Nov 2025 16:17:40 +0800
Message-Id: <20251121081748.1443507-2-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251121081748.1443507-1-zhangshida@kylinos.cn>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b3a79285c27..55c2c1a0020 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 
 static void bio_chain_endio(struct bio *bio)
 {
-	bio_endio(__bio_chain_endio(bio));
+	bio_endio(bio);
 }
 
 /**
-- 
2.34.1

