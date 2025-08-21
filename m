Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638CE3743EF
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807677; cv=none; b=Rqb18qZVysmnMz1zDfGNVED19eqFbBfnZgaXsw4ihWV69/rFPHbRnQfktHJlviIWhqWUD3xusFMD0jvgYLaQ01TrweD1QO3RidUc/gXcF0iDSEH9H7AloulxLvo0AjE7YBhBAlKaXLejOLgA9EsQIGfFyu6bLg34y+o58c4Nbgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807677; c=relaxed/simple;
	bh=EA31L9PrmSa4mzObQI8v1C5H7seTrIKkp2OpM8ds5og=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6RvdJeLQK6w58v0VUx/DaDp5GuIr7QZu1sC/BIM3LOdk4XMyvHrhyofvsNWxDrocEL5worTpSStzkkrSB4K+4PUqjlgzpyTD0b0mc/zMypWlYQkzDb/viLmZq6tRydZshe2BVNU+TxAnDH6AiuQnO1E1nKaRG5rqR6nAGlwMcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=axh3S8PB; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="axh3S8PB"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-71d603a269cso11777647b3.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807675; x=1756412475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fttr/Czssr2JLi9HILzKnlPA1YaQWhLNKR3od2b6IE4=;
        b=axh3S8PBmyjMa2pbeNgVzJkbFjsSqOPDKGpRbNdMxXclTkWl1pJmXC4ZIXyxfDD+sG
         Ovbgm9SD1UPt5XbKiTgPIRLUY6RHIvzyHY67/gExLrv3G93aHesRJto5m/oQ9G9sNYx4
         RoFU/eiotc25vyarCJqEm5alADklkOq6oSOfYKAiZ3HOE2ingdyBBf56aXAf9tFx3ZmD
         HFRnJwyBVjmr+g60SEeA5QilWn/5JSiiXWC9VpBQF6MNCJ/pXdHC2rESaIMQdyGTJkX2
         pwc9RHLW8N8KOrCLl9SYs8O5O4xs/H8haxUd6aMGDK/cuDTUE/Xy2Mfemw1u/KxVdGEw
         cjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807675; x=1756412475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fttr/Czssr2JLi9HILzKnlPA1YaQWhLNKR3od2b6IE4=;
        b=kJRA5edKFgRnUa5daFRRb1i0M/2Ra7KwKH33SIlNsJpe1Q5O8q8KPL5dtt8xZ70j3G
         /LdbLFclTNX8JAL8nzJlMSZ9wIUrs0ZoanEZNwUjufbl19oqz2gMS22BEI++j8pWz1MU
         iFk21hheI37jYk96FisaKcxQvp6FQ4NNWW+ohJzLLDEhegljIPO+BenAjs7u8s4EjiwI
         t56+8UoXBDN4CCfQjdE+VjWzOrDLQsuTjGHUYwzlJX02i+OBzYmvhwZtszGJh0dFvrxb
         ej1UkvFvKtwPXFArWpWSby+BzJRHCFFkgwG/kUnW4Jw6o3gadqlEsiXGyILL7Km460It
         bYiA==
X-Forwarded-Encrypted: i=1; AJvYcCU33chWZqdAKuW4SE0D0HWYK5PWG28MEPpRXLe/UMewVcgnsqPRBt3ph7b6te0CjzcUgs4O2malUFE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzI70vJ0Dxm504cZHZByzFNiMkbK4S9noNOhCddCD7XHo+Qc6T
	piPkc+yQOD/9EcXZxDmvb+pyqSVOzVNNKhm5V+BH4cIEdQA+1OcljW1P7Kk6N2HFoHA=
X-Gm-Gg: ASbGnct/UK+1TH5Uni5VnhNGc3qYfhva8o4AMFMuch2E5tqSzKvh8utKFvAT6KpLm+3
	2ndzLv5SiGr0fy70zLy6q5sfufvceNVtfu7SH1HXhijsMwRGal2Zu59f9Ywrs16P6m08Uu1S4QT
	xIBVm2JNYpMnA1EIi8EsjPzbWG00x3VFoZDPJ+bHL0lf1qxCZyrPqredt8XgzcmvvMp2tgMP/GE
	eIkGtmsjnB8rju9IbN18ag0/hAU12cRpUyDqouRcvXe7ypIMMljz9U3eBBk5wuY1uZciQGdfQKC
	t1D5Bylnn4ng8ICTDVXKfkTmxJX9g0XTca9bwWUJCqaNQ55dYwnSzUTj6FfH1aW085E5XHOOwij
	m7HZkhoQxcXD19GSN21hTSYHdSzOT43DU5/5/08e+h009gRkbhNZeYGiHTN0=
X-Google-Smtp-Source: AGHT+IGjxSgFZ9mWOECEHAMCC7m5i7vQzRMSl3lQEW4CVdSnSyB58BReHuV0rWkHihu4WR2jiQXucA==
X-Received: by 2002:a05:690c:968f:b0:71f:b944:1027 with SMTP id 00721157ae682-71fdc530cccmr6134537b3.48.1755807675427;
        Thu, 21 Aug 2025 13:21:15 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71fae034dc0sm17871677b3.74.2025.08.21.13.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:14 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 39/50] xfs: remove I_FREEING check
Date: Thu, 21 Aug 2025 16:18:50 -0400
Message-ID: <1cc3d9429aa4aa8b5b54d5cd54f7aa27a1364b78.1755806649.git.josef@toxicpanda.com>
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

We can simply use the reference count to see if this inode is alive.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06ca11731e43..a32b5e9f0183 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -514,7 +514,7 @@ xfs_can_free_eofblocks(
 	 * Caller must either hold the exclusive io lock; or be inactivating
 	 * the inode, which guarantees there are no other users of the inode.
 	 */
-	if (!(VFS_I(ip)->i_state & I_FREEING))
+	if (refcount_read(&VFS_I(ip)->i_count))
 		xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
 
 	/* prealloc/delalloc exists only on regular files */
-- 
2.49.0

