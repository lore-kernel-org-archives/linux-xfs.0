Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5739F38E76F
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807661; cv=none; b=WjUuHr5cBRNDuKSVsccsFQ118P1w7Y4C6ntaZty8b0ZGQj0FbNzHBZuv4fkx0My2nmaF7zTyMU+15bK9CVBYiLzzqsNVjl/s7paYrj2sQDFWbqFGezYzv/5/MuRJOCjiFomArQBLejulgvyrcZoiyQFnbwNftPoIziAdM8AJwK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807661; c=relaxed/simple;
	bh=Ek+K7HnIxIEopRMdqMnNty91y2VWEE+x+hrrKpFJIDU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmGM+censci11sE1XgxsoJMxawgdNEQvAf2k+wbiPCp2RBe5srE5GxvNiCOY1kzXNng8YGAO+R0S7JjWHyE0bdPjAOd3DS3VG+69yzpjSkLORc7OMWbsJzcmlWHfluoI+HGIBfEmmBCJO8MmVE0kWIlbZoarDV6XoMJJmUdyLjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=h7StaB7s; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="h7StaB7s"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e94d678e116so1443040276.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807659; x=1756412459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y3TpSvoC8LjQ68sRQOMNnuf57RQxDl2e4bAAk/7JVig=;
        b=h7StaB7sFaFR3MU6RpylsNnl22azzxV5oSw08GZHVkgu9uKpQh0EIWf4LakiASWhc2
         Hu7r3GBivna5hNDvTHut+WH27OE47U4mWXOcPqnAPKnL20fzCz6iO+YJjqCsk75gcpXa
         Pi7L2b997iBKTv7FOOE42A1AoPHp5yYEPG8QyzzhzTaTPKl2FBBkH0GMAqu29AqVdedk
         P9Coxx/gi2d9vd23T7qyY0MC79V1fsb1qulU3oJ8hxPpCQJFQeVjjG3emy8hvTa9qdjZ
         ZKanmr9ngpInB40VSv3IaA/ylzofoEy/eAPSvLumk58yiLGwKGzBLUuwFiPk4tRlwivp
         shDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807659; x=1756412459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3TpSvoC8LjQ68sRQOMNnuf57RQxDl2e4bAAk/7JVig=;
        b=gDZ7uJyCfC318pEgB6lyT5zcGu+xizrC02dHWAtLrjL1Swie3rQwJDSn033E7YOiDh
         ZmDXaR8dgZKZzqwBF2hTilph1ZW+b40QqinQKKyiUKbKqSMrrQCMiiJBnq+0lddlHkHs
         4AYZ6wJbIW5IUY1iPgClJRwlOkIk46bhheaBcg9ct0x2AwGZCICRv9WKySTH1ryLyZbP
         uDwxQgUnkICdCgx0HQE1RcOXDvesLc1VD3/XZ6287YsuPN/D4Rjd9Gf+yGsvr3WscBqW
         rEX9eVz9qrHBdMKvg+rVH4URt+wCM7triEKijKaPkaKC5Cv7sz31fVyxVJtpgj9+Wjxe
         xRkw==
X-Forwarded-Encrypted: i=1; AJvYcCXaYxxGvcD6FerFWBS3rqK1ATyqe65oHGpB54Mk6UN0gIDQqHsdnrz7JYOhKaeCNut2/3czwF8O+D4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxnh/Fc1vZnL26pLmYQCdTa8T+LslW1iPFtFJbRLP8U0dlQDD7
	Kvu6/RDpG5l9QuPo/ocWOh6JT2Ibo1u5CG0JM+qz2kqhqWWdfEuTNX6malYvdAM5YdY=
X-Gm-Gg: ASbGncvLkWGst0lON2OcolvMtfI5/O5+lNxn3MPahnp4KS8nZveRZyPya+61TiHdIxl
	hjEIpObq+J4eosg2BtJXXrwLYQzC4v3ZwU6wINKnU53E7kZ5k0odV341TeBrPTcAF2hSIg5bzyQ
	vhgePaBgUwgepdSJWwhMeBxUrkpDvN11n/tiwu4qlPZNVPB++bPcC8u1kcsuXvOK5xuudLR+pbO
	D9r9A4MMa5azoUmfx5ngLQ4+nzHgr87NNUupgI3MJCxAENQEfRqucvc+onD6i9GuFohLvjtGblg
	gvtIB4IJEp2qrxHhGV0TWEzzKSVZBmmeMMdC1bxz4UlmafZ+pAuVF9x8rrZDrkjbYe1j2O2YswH
	caXjJj4YsyA9d30t8RLWrohcBuSSbFUesaFeSZ8Ian2TXzAsmNkfZZqYCR/7tVEnMpmeHCA==
X-Google-Smtp-Source: AGHT+IFzSbbZbVyVfwrrT3zpLyFIJoYYtpY7LXxY8rNCJVnHbwi9tGRQ7nXi3Rf3m3iA+CZ22nlXrQ==
X-Received: by 2002:a05:690c:6b0e:b0:71c:bf3:afc1 with SMTP id 00721157ae682-71fdc2ee8e9mr7159417b3.17.1755807659175;
        Thu, 21 Aug 2025 13:20:59 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6e058dbasm46453967b3.47.2025.08.21.13.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:58 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 29/50] block: use igrab in sync_bdevs
Date: Thu, 21 Aug 2025 16:18:40 -0400
Message-ID: <6dee286aa8a57a874a66d1e9c7fc835a60393197.1755806649.git.josef@toxicpanda.com>
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

Instead of checking I_WILL_FREE or I_FREEING simply grab a reference to
the inode, as it will only succeed if the inode is live.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 block/bdev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index b77ddd12dc06..94ffc0b5a68c 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1265,13 +1265,15 @@ void sync_bdevs(bool wait)
 		struct block_device *bdev;
 
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
-		    mapping->nrpages == 0) {
+		if (inode->i_state & I_NEW || mapping->nrpages == 0) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		__iget(inode);
 		spin_unlock(&inode->i_lock);
+
+		if (!igrab(inode))
+			continue;
+
 		spin_unlock(&blockdev_superblock->s_inode_list_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have been
-- 
2.49.0

