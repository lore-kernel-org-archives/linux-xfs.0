Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC9733F8B3
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 08:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713113; cv=none; b=DUey/D4CACKQ5hvmI4QGn4ngISYd6F91kDYUEwi+91pRcpJyWQvKBM2H31ocYPSidM8RS/xa/vfVEFfdBxWe8rDF/j0CPibx6MRDs6RpdMutAE/GG7vP2J70SLotMAecgHQkzRUKqw/wA7YPeySgAEqD67/cqvRNQrXSFZ4MNn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713113; c=relaxed/simple;
	bh=a7LSL2iwilO1NB088738btanTUaCE2U990irg/c2KQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VTEK8MoIsD3Hm2ITOlICIWZ27XMWCfMeadWhRYEykslN9G5y1YIKHxvt9c08+7COOcE2fjAUGwM8SIxkUuQVMD3jH0VExM5uMAcfoloe01V7xb5zBdHK+UW8eUDUnp3xlNStX3KHsLy1KSqaHntpExWvOGcVL9dMoWSWQbD/PvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K6/aMCwh; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K6/aMCwh"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7aad4823079so1537213b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 00:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713111; x=1764317911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqJVIkHeBy2QrJ/910C594A/mOhcsYvy9xKzTt/nypY=;
        b=K6/aMCwhqki8pQbh0ZG/h5mxLbbv5t/ykS0ZBYLq34+/kvwNAKxeDjEevztJ2QvgQ6
         5LJ81Q8Ga51NT11nF/pJ7qXiOzdAhqrWkuuqse9Nx4jmJI6Pz9Y/DqN11FRc1O7k7PXC
         qGybKcugjJT1SM5rIAXw+1xmmyAaMo2/ui3tWph2rZQ4E6sAiimJS6roKUA4w7+sUt74
         W8bTOkT3IlIEPSLuy1+EEooFzEWCFwqPasBAqSl9xlaJ5t5IpG/jTXRWER7m+P6qTU0F
         dKHfnPqhlUBMksbC7heqHJFtBN5CytsFZXiLRK1wAKeehgEexSGv2kMwtjfHwzM7GNrR
         JS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713111; x=1764317911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IqJVIkHeBy2QrJ/910C594A/mOhcsYvy9xKzTt/nypY=;
        b=DF+D9zFHze7d2If/UIfGOQjes9VVQrFTmMm6v27sipdD5hkB/k9mxCPM7Ms44PIquG
         G9fBifyXC/DI5jbVvuIZNA2/S/Ei35GOAeWPg7ii29WOECj0yLahQZODGQR88Tva8xFa
         Yr97KBb4JAzHBo0B5+7mAvEKt9wCpDnAKRFMUZF7dnIQd4jbOI4PI7tzQBf8B6skpLfi
         FBtJT9uNpmZ8Gi0hoduZOM6r+L/XrYmZ63lUw93smfsF9X1XA6zm13Zov8mXUbExHVmz
         Ag+7r+JQVQg1Mm40kdUgRy49wSgVox9F7Ayzw8tcgA37vLMlmxp52CLBnOpS4zOukYjo
         P+vQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjP9zfx4Upemp8LX52DrkHlVRIHQwXhnU1TFadX6P/TN9/ivExkJiq4DGpfW6RLYhJBxPcgTDiNxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSRWcZaJn7+kNeSRNtcDbumlRpew+qDpiLlaZt3L5kyYyKiKdY
	qYC7JblkiV2/7BWS8hK6ekgdVhzKic0NUVABfboiXwbHC/LLZAx68Z89
X-Gm-Gg: ASbGncu7FVdX4HVD4G5IeQ3g7OXOSOzxPnaOp5ts3x2eHr+utWJLW6yndoeZMgWUFM8
	Dw5XH4R3mVB2eH4UmXpv3ZgEiTSjHHBVY+PfcbJvv/atLzBGFa2JtjyVzurSzNnyQMJhxtHgbbQ
	8ev0dv9RTrhA0fTgUrdJ2CWoE+bxpwMTi8L165FDhE56x9WCJAUV3x4sm5n18acgTAyDgjDOyGL
	inBLiA9RmfoWzgHRE9i/e87+vYs1CHxh8qzY4VpgvoV7BLV1A4IFY+Vc2ePHcCg/Bi9oqHdMDyo
	Pv0Sn3DFYasStg9FB2jtOBHqFuGUgxUK7vIZFjfIne7HYO6ctZzWPGOogM4AYdmW4O1SdQj41Bg
	l/kAM/qzni5auI+n2PUr/8sWmVfdVkQYncVtwkxxzJqMzpn8EFm9SUvYyA1ALI/kojrMOQtz3yt
	DR5KNQ4qgWhekiMzoQ9ejhRkkEOg==
X-Google-Smtp-Source: AGHT+IFWgtWuJbeRkMQREJ+GB1+CIl1owO0q1AKLfdba/kSV5Dme/s+uE/AHBWMGMV79yRIBfle0AA==
X-Received: by 2002:a05:7022:628d:b0:11b:9386:8257 with SMTP id a92af1059eb24-11c9d87a334mr448835c88.44.1763713110905;
        Fri, 21 Nov 2025 00:18:30 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:30 -0800 (PST)
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
Subject: [PATCH 8/9] nvmet: fix the potential bug and use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:47 +0800
Message-Id: <20251121081748.1443507-9-zhangshida@kylinos.cn>
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

the prev and new may be in the wrong position...

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/nvme/target/io-cmd-bdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 8d246b8ca60..4af45659bd2 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -312,8 +312,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 					opf, GFP_KERNEL);
 			bio->bi_iter.bi_sector = sector;
 
-			bio_chain(bio, prev);
-			submit_bio(prev);
+			bio_chain_and_submit(prev, bio);
 		}
 
 		sector += sg->length >> 9;
-- 
2.34.1

