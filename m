Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2210A38A607
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807623; cv=none; b=XlDoYj6HhIqxWeybAfFW1T4NtYUtqt0w+9Fta/5ggR9rhs3QHlibklBTiaDucyig2C1CZsQKB//lPa4yhBYQ1awbGf4xot9lOH6jYhxZaa9/tsyPNhExaYuHAFxw/gi/UvtvBLcXPx5Mm2mJp0uJtISkP5mrvRQId45bpWo4lzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807623; c=relaxed/simple;
	bh=aMn/6ao90XzzaC4s0c7CDFRUmP2ZTM6xnRau/8BGgmM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVvuR5OiqUPzKINnEAkj40651c4mA9e0MbMpLVS2fSi/TgRyr39Xyc/QxGbI3DVE5dBCFz9Blz+arSyjHORj69q5sNUDQlsgI2uc/vnGJOXjhQtj88edzAGkmxQVZ14ZqGx5MXr/bq8qXxuc1FCeUleculYG//xOoN/Q1khIg4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=ifMkrRm7; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="ifMkrRm7"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d60150590so12041647b3.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807620; x=1756412420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XLN4UbEHNtGwPYNoqmeGrAHZvRznKShz2RgBNkDqb/A=;
        b=ifMkrRm7ay32qJZgOfIEyjhwpWOScgUbN9sWTuHTBsvcij8ymIcrx+ONEZeZ0IBn22
         TIG4gT552lSvTEOfdc+23VuK1CnpMb7w24kAPoRJAAlzCPO2fvkkTG0gp3xPyRWx4dAc
         re/lAV9JBg2TrweT+tevjQRsJizGAS6anJxRQ1QN4Kl6Jfqr3quDpGPo3r5hodCNZRLR
         plhTPrivgk70/GRWVmX6c8V0Sz5dioG9oGQs29DVt+vVs09UXpovNCxZb3b0juF0iYLG
         BMuJPKxZqi3a77vvxecvjU2YKKzRElCisRqMuoVmvwOMVoTtZDfq6x5ivJwWaiFuQ+yW
         nrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807620; x=1756412420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XLN4UbEHNtGwPYNoqmeGrAHZvRznKShz2RgBNkDqb/A=;
        b=acracpKIGPeaL2d9ArO3h1E/IVlw61MAtXpRIWqDPm5V0/FChE6cN5lYbikeV7BkPd
         E2zOJToyMi2qlPCAq8RNV9fRX0VimsG5QXAIcI2ugj9JgI5vwi7MzDS8NBXDeLj7Lqe4
         pv4uFR3fqtGcAkgmmiz0fjrFqBGZ35jnyNjshgRFDfdpZiAw94Kpt5amjJrFq9TXfhxb
         OCybndURyg/T9/Z6H4NwTPQZR6URFQJYGkyH/umv/HcH/nD6z3aE7K0VUwmAd5/hJgtS
         95NaQRWxeZkvIXqquePsN38BMQsOOlHCt+Q2B/L0MiFlUFDlu4/N5dgn5Qve9jy2ghvL
         k8KA==
X-Forwarded-Encrypted: i=1; AJvYcCXGmRqOcJXZTdBTfwiQkc4ZRhsyHGJKdngoAD30jN2V03zL9INuZVohjhEGCtsXgK/4c1UHJL+7330=@vger.kernel.org
X-Gm-Message-State: AOJu0YxscK1YDUEzYPEwM5YYKIt+ZZyf3bcJxE75WtvRFLjllEMmhUei
	95VOQiScXhIN0mbWhR/Zd/ze1jXRAB1KqMjvp4Uk7fMZECRhx9RfvOb+Og1obyClNuk=
X-Gm-Gg: ASbGncssqzcXnGbCtjtJ4gBP6cXp4lHpomKncbtstSyTFawy/zGevSAmMXRwvQf8ar5
	kBwb0ORV/OikYE5sqErZvz7GVeO2Pn5UP3eJQyx4QiH4EuEUN4xJ3uSwc6CagSWFwetS3xNKGeb
	CKTrCgvcizoM/SaM/tMVPVylnJnNwmwd+8kbhBbTQQK8iI5JLo3jzx35iRTCK6nCFMyedu3DmwN
	oEHRJLGKAPtRZmw4QWlTf4Gzq+temxTnigM+d9GnrRgvuIPkZ5YHZjF41xb7lQvKO3OIScpnM6M
	N/gYQC1QKxApXYeTMO+Lpk55F2yERX1DMBxpj3YrdmepJjfvVCAgR80yrpd1xXIJI/ZdcIA13Og
	qoLrFYWznqwsUnC9aajzglFLI4CtUX5UnCQWo1T8pVGAByj1YfCj17aShQqncTykf/Hg1iw==
X-Google-Smtp-Source: AGHT+IGb0qgYBLWVZIch3EbtVHWOhrkqQCA2jAcmKvem4xmtzmk5uwLi8F7ETWvIrlxUB1p8XxL6IA==
X-Received: by 2002:a05:690c:6711:b0:71c:1673:7bb6 with SMTP id 00721157ae682-71fdc326e68mr7121847b3.23.1755807620154;
        Thu, 21 Aug 2025 13:20:20 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6e0be8b0sm45782287b3.66.2025.08.21.13.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:19 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 03/50] fs: hold an i_obj_count reference in wait_sb_inodes
Date: Thu, 21 Aug 2025 16:18:14 -0400
Message-ID: <e8edf6189d036e2222ed2094cf625d3cf06e0111.1755806649.git.josef@toxicpanda.com>
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

In wait_sb_inodes we need to hold a reference for the inode while we're
waiting on writeback to complete, hold a reference on the inode object
during this operation.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fs-writeback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a6cc3d305b84..001773e6e95c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2704,6 +2704,7 @@ static void wait_sb_inodes(struct super_block *sb)
 			continue;
 		}
 		__iget(inode);
+		iobj_get(inode);
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
 
@@ -2717,6 +2718,7 @@ static void wait_sb_inodes(struct super_block *sb)
 		cond_resched();
 
 		iput(inode);
+		iobj_put(inode);
 
 		rcu_read_lock();
 		spin_lock_irq(&sb->s_inode_wblist_lock);
-- 
2.49.0

