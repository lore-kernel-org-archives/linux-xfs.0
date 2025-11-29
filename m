Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F112820C6
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406921; cv=none; b=Nj6VKFAqSI1VOslNyKRSQxi/d3Y8XEjvIz2qbZkT6zlOt6uMAIcRUyY3PYXEo+LQNde4/65GgAAHuw3FGrphYsTgtqEhIdOllVl3Gn32takpuJFHkhGWNT7/kZlJM8XJ554bo7iFP4M7ppGApNblobpNwrORgMfY1PhDsIal4t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406921; c=relaxed/simple;
	bh=rZqecGhzp3NmtFjaYLSNOTM+/xsMiNIYX8VY+Bn+fL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DxAwLghx6zIxkDAgHudNKSWJBjci1gCfDOiX7AX8XDp3ohh2GRfI3SM4aT38tRgIvvE8LHLoZ00BBkqs2R2n85jPNaK6n2EmqpWUkiAy3ZuYjBW5rithcB1MQa98TQOXNpf/JkKng4/1IbTpdj81VlWFToVIF2WyKiTpxZaQ+H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OpCq5xV0; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OpCq5xV0"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-bd1ce1b35e7so1833080a12.0
        for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 01:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406919; x=1765011719; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7vHs8yXaPj8mv/GRmviioQ8omsZI2Wqns1LW2Ikl6c=;
        b=OpCq5xV0GpYV4qxg49HqK8ixRDljLimfEEj14WmRfrjYfpR5HNvOpbtgtvfDbb1JQU
         PjIXGyqpJaoYAup3h5BOmV16imgDbeOqmuCZpGNFoAPAjMLKYOAb7GLZAhDTZsLb/7RK
         rK6+7uJKk85G5FJ9a+Fio6BBbWsk/B1Yw6he1A1AXzUU9HN6DZ9RHxFXolWtrnrwHXvk
         MAvKA/2qBAQDCTxl7D3Jjxh6hHRfidgQhmz9cHt+WeBpXaiGOr/2uWMavfMFFEobSNDi
         lZGpixsfz04G5WowFHqgCbQakJ8vW+p69P0G5tqi981sNpbX5x7y2+iKEAheyIRjnlh/
         7pSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406919; x=1765011719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7vHs8yXaPj8mv/GRmviioQ8omsZI2Wqns1LW2Ikl6c=;
        b=QX0niedgX/lInmTu5YQFPEKFjOnsgqLwCuBrlRd3Y2Tg4EMUIZOi3uPKQrjBIJ0/YO
         vGb+FTfsqThqSSqv+uDfWWr+WrDR/M0/4oho59XZPjXpTP0HeUkBsL7OU03bR7H7pjFz
         xMWEcetvkOS4gmuU/MQMCDlWnpqn0YbW4Gz1a7N/csYJs88sofQSPYW1ZKYp7L03CvGT
         ZJVK17uEqF8T026+P260sdDIr5SqDUah8QqZJ4XfG8DCyvkEa7m5VzPH1JycRNgpWfBp
         2w5S2mdWHsWJKUZ0JbzlX9go//jhHGV1YYDCriEh7s0FIHB0bDpLF39D2+T/dOgIIMVK
         dt9A==
X-Forwarded-Encrypted: i=1; AJvYcCV+EzD5JftjcVR+ZppabJWVku/KIA20I9lgKOFve/qpokFIuuunMuls6JTPRaS9fjNpIHaDjuKq5bU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlToSLgt18fT90Z/flgpIDgFh8YS3Tx5UqxQcG1/RJBTwb3l2X
	GcpJlDBKvDIknxgkleQgR4HJVmM0cciTKVYHCh357UIKPCcpM8mjqMJh
X-Gm-Gg: ASbGncuB5w4XezfAooAyjIPw5ssXDu3iPOsIYdQQgxjuJ5XHwmFtxk6lOX89uI58Gar
	qokXJusG6hc1BCBdd69ueYfG0ee7zc1vdBIQTtQAIulZl9ZWMe4at3iMijDLsZRfPOxTY1xCfmI
	ZuATK9trw4QkVppiDSXgAsXOk4sC3iZ2lS41E30mgXOAvVNaH0Dyw0l47rGmlPA6XAeh1BkhkiS
	6QZSnXMcLxzANZBlVHaSSCRS31NheYSTqhHpexJ4muIPrsuw1ZTr4N70N1p4VCC/jkjda7SOtnw
	Wmw0WQUVaEvmtO1Aw1bhAmgEXPWPFF4/dpO8IkwZQAyuXjicLL68jWkyVHk896Cjk7rssAtY+D9
	uohTl9D2x7mv08ed37lJDRojM2CD85/fnGBOCKJLqvJe5b63D2Kzl99vOBd4Bws3EKLA2nwqLet
	TOrsrK8zQe9TsP+qMwyKz5eCVVPjkO08BWbwvH
X-Google-Smtp-Source: AGHT+IFdL+OyABUQodQSrM5NvvO0TZqbCFx6Z3c8afGQwuwppQB6YRBsN5vK+YoTkxr7MD5m+Dfwkw==
X-Received: by 2002:a05:7022:41:b0:11b:b1ce:277a with SMTP id a92af1059eb24-11c9d8482b1mr17983636c88.28.1764406918534;
        Sat, 29 Nov 2025 01:01:58 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:58 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 5/9] xfs: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:18 +0800
Message-Id: <20251129090122.2457896-6-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/xfs_bio_io.c | 3 +--
 fs/xfs/xfs_buf.c    | 3 +--
 fs/xfs/xfs_log.c    | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 2a736d10eaf..4a6577b0789 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -38,8 +38,7 @@ xfs_rw_bdev(
 					bio_max_vecs(count - done),
 					prev->bi_opf, GFP_KERNEL);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
-			bio_chain(prev, bio);
-			submit_bio(prev);
+			bio_chain_and_submit(prev, bio);
 		}
 		done += added;
 	} while (done < count);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 773d959965d..c26bd28edb4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1357,8 +1357,7 @@ xfs_buf_submit_bio(
 		split = bio_split(bio, bp->b_maps[map].bm_len, GFP_NOFS,
 				&fs_bio_set);
 		split->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
-		bio_chain(split, bio);
-		submit_bio(split);
+		bio_chain_and_submit(split, bio);
 	}
 	bio->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
 	submit_bio(bio);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 603e85c1ab4..f4c9ad1d148 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1687,8 +1687,7 @@ xlog_write_iclog(
 
 		split = bio_split(&iclog->ic_bio, log->l_logBBsize - bno,
 				  GFP_NOIO, &fs_bio_set);
-		bio_chain(split, &iclog->ic_bio);
-		submit_bio(split);
+		bio_chain_and_submit(split, &iclog->ic_bio);
 
 		/* restart at logical offset zero for the remainder */
 		iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart;
-- 
2.34.1

