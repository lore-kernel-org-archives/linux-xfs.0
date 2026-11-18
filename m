Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962943;
	b=qMqyk2Z7xz26Sp4SMkQ7pX+HYYaTMVEvslkt8uZhByDPTSRd80VSjbLLMzKlcB3/Uiuo
	 YHv5cn+9FMcRjITrm69tEALyM/DTz+IukDkz97/RRPTN2nzduHMHoiblEWJ0XnbCEGNPL
	 FrGRwQaWFac4r0J+z0uK3EzbuihzXTmdGhOi16o8bonb/xgrQAmvL7vRg4YuAgbBxU9xC
	 krte5pawN/lPNnfEztQBNDuQENGs5Eam3eVFMDN1Jl4ZoawMdBcM58Ki5hkxGjqfN14HT
	 TLnsly2J+6xvwsbvSJWs67ciPbyG8daj5OqeUkH+JJG9I90KQ+d/o9MQ40GPVDXrLfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962943;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uygP09TWvScyICofwLDljYgom7VYS3wGkavE3BwU9h8=;
	b=Hpboa0Q3AGYwUoCktGp4AFPwOkF4fM4uRielrGONwYCWwFRq29xUo9Yr+WN41MZnWho1
	 kt7S8JBDMQ4FBt07AQTO+fyDOH9Gv0HAOYJES9xlI6KmGsHtsOXesX1GFJrN26oJODGc8
	 xjGmWri4O3Y/dtjvhZNJqrPuZiNZ9THhH8e33TjtuFACXzOBrV37uqeJViiGAEWyHwLcR
	 0j3j0HIbg5tlfWH4AuBbESlLmKheu1rvglqSStor797m9C6smMAIVLCrTgdyooo4jZvSR
	 bkc3/+GgnD3d9H1STkneTdDfnHHN+1VWq6Q//8HiDaB5mwXoqrOV5ZEPj7Yxw5Fz8Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Dqr3ni5J;
	arc=none smtp.remote-ip=74.125.224.52
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC86606A330
	for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 00:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FC86606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Dqr3ni5J
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-67da69e7c31so297454d50.3
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 16:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1794962942; x=1795567742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uygP09TWvScyICofwLDljYgom7VYS3wGkavE3BwU9h8=;
        b=Dqr3ni5JjgMu8kUg65eWevBO8hYO/MldUTZEDJdMF+7N/h4n0s+4fvDmy3RG7QoKRt
         0Uw+ayj0sLeXkK+6jVTY1T3uH8wHy4z9m59RWo/n9SOppMcxcVEOJ4UBJYJx3Q/CRs2q
         LznBcoWnqadFL0Wvz0LE0WlxwiAxcSMw5wa6JA5EOL6pj7kCOuULU/fQ9D8xxBmKBO0h
         GIpCWLBPcP4zmnA7Ym3rICn1gv9IQn8w0/PymPyNWsggmYqzOFFsXEWcGG5vhwmrV80U
         fQ9BHH8nYqRsrAAarBdYYQcHCZa9B40kaP38olItOGkpGfe53Lbvv7sXhQFHVwYewHCQ
         Ambw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794962942; x=1795567742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uygP09TWvScyICofwLDljYgom7VYS3wGkavE3BwU9h8=;
        b=GTjw+mvyi5xs564a2IuPrcHGX/T8almJwP6ItEc+/F7sTE5DbQvhBht02VJwXumFsZ
         lb4eIlUYuamzQ8m2e356DLUiUF6RTcvB+H0By912geVmwUfhw9fqA0lM7AWOYRPf2soZ
         ZPKH/r3tyHfBOjvMhLh3Ja+V7UPRgbZw0DS6xE+4jlXpLcUhZfLgrbZ91AdYegjP9MQ/
         hd21D5CAuX48t6KPW6sXzhdB21/7ecM8bjf9GitvauJXIzi1p0mr7xU6owcqvFGj7jyo
         8h+qfDpPjRSKTbTRnCF6i+67xFIZA7Sw4wBEji+TG3UDg4L6X8mkrpVo3yNx+RcCEcck
         QL8A==
X-Forwarded-Encrypted: i=1; AL+hErEhErnE/AhM08NXvfEY7UQ3T+j0q667XQblsZpgKu2Gr97XrGoHuS7NoJ/EcfV4ZnEqjIVqZmSACUg=@vger.kernel.org
X-Gm-Message-State: APuU4Z9vhkflqWNY51aXAt5vSac4FEogt78PSRx7jN+AYsxvGaE3Fliz
	EFrEPgcvBp6t8zQlShzd7ojyo7uJncg3JeuTJA86Ch1REXDFr5R9hEf3gGkndsapw0w=
X-Gm-Gg: AZFdTZfQtv0cwaAtZKDxwRX080bGkU2z1oN5uddSURi/I6oIlplJcI8w1sbroN6f3mK
	2O6M0CMeVWoMGxhByl8HXbN3YCBaXRkudRPZYh8KpbV3JpRv2EOJcuOJGQ4hdCoDBK6vdL8y5+i
	Jl8yNLdCaY+PMOZk1HXvtYzwH6rCk3Ksz9MratgTWX2h4ZncLHfGXBeFXWhvx6LlI/3i6GBPDlZ
	fJUk2g0V1ub0xf8McUbgLue4684ublvBJ3Jq6gWw7rZkB6fXUP+78fXKrDo3b7LJPhp6/zsQzb9
	b+7gn+xbQUvG4doAFrkwu2ip5woraolXCSvj3ZHJok8Wr9A/W/4Pw8d/HrpI+i5nxZ/eJ6Ne4hQ
	AU/ZxagzMBQ4k01OOwM69Yxonn/PrcNgALybmbaQs41lEXEf2p7zJcVGEBbcDOu6dzBOfF9EEBv
	ddt0rqmLUyFuniFHbrC9+ztZVBSkMxdZlcwG8vbrv7pto8s+tDU9eZOEFiKx/FEhyIhc/dNE/vA
	7KTs315pC0TAK+imIht4xB0hmTWqGQDUQCjVYwIQk6URMBGrinSAZ/W3o9tjjWm8iFTAYSfdsJV
	qJLLpyk5AqiV0F5yPfL2wmyhibfM4nOJA1g5tlYv3KPcQh6z9IJnwiY6wmcKmZoC1DQPE9ylMVB
	hGRq5QbzYZzSn+elURmTG8eQ0BRQOnSy+NOmTYmq9NKwPuQN2TCU7B7MCcl2TpzjYpNHifog=
X-Received: by 2002:a05:690e:12c6:b0:67d:ac2d:d821 with SMTP id 956f58d0204a3-67dd45342e3mr649464d50.44.1794962942572;
        Tue, 17 Nov 2026 16:49:02 -0800 (PST)
Received: from system76-laptop.attlocal.net ([2600:1700:6476:1430:5fae:4d02:7055:94ad])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67dd56ead87sm729575d50.1.2026.11.17.16.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:49:01 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: glaubitz@physik.fu-berlin.de,
	frank.li@vivo.com,
	hch@lst.de
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	vdubeyko@coreweave.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v5 4/5] hfsplus: return -EIO from hfsplus_map_extent() if no extent covers the block
Date: Tue, 17 Nov 2026 16:48:43 -0800
Message-ID: <20261118004844.3849979-5-slava@dubeyko.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118004844.3849979-1-slava@dubeyko.com>
References: <20261118004844.3849979-1-slava@dubeyko.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hfsplus_ext_find_block() walks one 8-entry extent record and returns
the number of contiguous allocation blocks starting at the requested
offset. If the offset lies beyond all entries of the record, it sets
*dblock to 0 and returns 0. hfsplus_map_extent() ignores this and
returns success, so the caller gets allocation block 0 as the mapping.

This can only happen on a corrupted volume, for example when the
extents overflow b-tree lacks a record for a range that is below
alloc_blocks, or when the found record does not cover the requested
block. THe hfsplus_get_block() then maps the file block to allocation
block 0, which holds the boot blocks and the volume header. A read
returns that metadata as file data, and writeback of a dirty page
of such a file overwrites the volume header.

Return -EIO from hfsplus_map_extent() when hfsplus_ext_find_block()
finds no extent, for both the fork's first extents and the cached
extent record. The iomap conversion later in this series relies on
this too: __hfsplus_iomap_begin() derives the mapping length from
max_blocks, and a zero max_blocks would produce an invalid zero-length
mapping instead of an error.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
---
 fs/hfsplus/extents.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index cdb337ba3924..bb5a1508498d 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -67,7 +67,7 @@ static u32 hfsplus_ext_find_block(struct hfsplus_extent *ext, u32 off,
 		}
 		off -= count;
 	}
-	/* panic? */
+	/* 'off' lies beyond this extent record; callers treat 0 as an error */
 	*dblock = 0;
 	return 0;
 }
@@ -273,6 +273,8 @@ int hfsplus_map_extent(struct inode *inode, u32 ablock, int create,
 		*max_blocks = hfsplus_ext_find_block(hip->first_extents,
 						     ablock,
 						     dblock);
+		if (!*max_blocks)
+			return -EIO;
 		return 0;
 	}
 
@@ -300,6 +302,9 @@ int hfsplus_map_extent(struct inode *inode, u32 ablock, int create,
 	if (was_dirty)
 		mark_inode_dirty(inode);
 
+	if (!*max_blocks)
+		return -EIO;
+
 	return 0;
 }
 
-- 
2.53.0

