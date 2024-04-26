Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DC238F82
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168565; cv=none; b=JfgSUTgJ748LLZIDe2KWLtqqdAgiSuzX4ZCG/RPw8aao1K80TrNzTr0l4saAeq/RPyv7tzvams8srwvPGxjqMnvST5UVaT5kiRTn5oozo0tUAVJrHXD+AeXBKdqCsv+JhP5/L/VuUu6vL2kCtsSKGMSadM2qfkKKqyew9sZ6nP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168565; c=relaxed/simple;
	bh=B3gztKCcvuBinrC7FtzDV9IFiRHY08MUU0Q/4bjgyhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiDyTiSKbnU/lg19DeiGyoppe8NZ6J5H5gzl7i+r7RPY9lciRKvmH6wcL8ymoCN6VafKPJOaqiORUVh6mJSg1oscskE5eSe4mXC+qV7mTP5ag4edNbNSO/5JuHhycatsR9Qz8EwQK2ja7qYFGbJKf2CQxsdDGtiUe7+eu64Ydw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h+B7UkRX; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+B7UkRX"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6ed112c64beso2620007b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168563; x=1714773363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1vf5yCfbFIZaQ93LPInJPX/XpHUz5DT96bZkz73Ios=;
        b=h+B7UkRXLoDUZugMkQ9+c2CGczXWR+vjCI6dGfJou+mZcMiUbDNx5XdYBIIdhERqKW
         BFOvhg+twsiPrwizBOvyOuAHmJjQbgCBkUD8GhEiHSIWR7Ww0h9GOTiVDAK5PPMci3v6
         uuPOr5uu14lwCxGlpehbQ4otKGcKUsWqGrqIa5MPVZbvfozMh9d0cCkCg9HNGyP5y+HB
         aTWOD425LFaHD2Y6/iPodxlV00w4h/d+MKFHDrc/begkWEkfMcNT8M4l2GcSSGd+FOf8
         7ekC4Yb+I795HORvF/M4adMpUzp+buNexUaDphhdFx2Pgb7/7Sq+DOU8XbbmL5jJwBsn
         giIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168563; x=1714773363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y1vf5yCfbFIZaQ93LPInJPX/XpHUz5DT96bZkz73Ios=;
        b=KO3R2Pk+DDLKIjOQKUTKrsOhIAc9n4l9RElQXJX8X6WcZ/QjsqGUkx7ROdTnXI+zA9
         dnTz016Ov3TMoIe3oKKEcQ7B9nevM0AlWb/jT1sIfISeUXgLSjJuePe4SdPIILxwnGQi
         uNolBaZsrcSUxnUhkJaav62qVscC30baXHi4ze6AamNAmD7fcWHIW1KUK0GiTArqWced
         GW1m8JRfH/6YvasWNTlxDvJ0ApmoK8rTkfsVHb70efMNPRDVm08ZYSWbClv9pOKUl/pX
         jIIKYoTU97v1SHO7YN8DDEkts9OMy1O7h6c11VSk5s9cMsFHcS+JRL+LfNM5js0vNhsA
         ObYg==
X-Gm-Message-State: AOJu0YyOgYbWntzmsM+WxlISQA1u4WzMUQAE6+NPt2909SUeJ9tGaiX6
	De8c2FVz+SQFWC3tTYfodGYqGzzHOd8CJJkqTXJfEPm4FQZz+p3wfSn/1RVL
X-Google-Smtp-Source: AGHT+IFvXzM80Vx32QNQMhBTP7TKiL/F80WvzU4b8SKqvRBOcjyMtvHx8nLXUJfO/cT+8iSFmeJoyg==
X-Received: by 2002:a17:903:1cd:b0:1e4:cb0e:2988 with SMTP id e13-20020a17090301cd00b001e4cb0e2988mr1342042plh.2.1714168563040;
        Fri, 26 Apr 2024 14:56:03 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:02 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 14/24] xfs: invalidate block device page cache during unmount
Date: Fri, 26 Apr 2024 14:55:01 -0700
Message-ID: <20240426215512.2673806-15-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 032e160305f6872e590c77f11896fb28365c6d6c ]

Every now and then I see fstests failures on aarch64 (64k pages) that
trigger on the following sequence:

mkfs.xfs $dev
mount $dev $mnt
touch $mnt/a
umount $mnt
xfs_db -c 'path /a' -c 'print' $dev

99% of the time this succeeds, but every now and then xfs_db cannot find
/a and fails.  This turns out to be a race involving udev/blkid, the
page cache for the block device, and the xfs_db process.

udev is triggered whenever anyone closes a block device or unmounts it.
The default udev rules invoke blkid to read the fs super and create
symlinks to the bdev under /dev/disk.  For this, it uses buffered reads
through the page cache.

xfs_db also uses buffered reads to examine metadata.  There is no
coordination between xfs_db and udev, which means that they can run
concurrently.  Note there is no coordination between the kernel and
blkid either.

On a system with 64k pages, the page cache can cache the superblock and
the root inode (and hence the root dir) with the same 64k page.  If
udev spawns blkid after the mkfs and the system is busy enough that it
is still running when xfs_db starts up, they'll both read from the same
page in the pagecache.

The unmount writes updated inode metadata to disk directly.  The XFS
buffer cache does not use the bdev pagecache, nor does it invalidate the
pagecache on umount.  If the above scenario occurs, the pagecache no
longer reflects what's on disk, xfs_db reads the stale metadata, and
fails to find /a.  Most of the time this succeeds because closing a bdev
invalidates the page cache, but when processes race, everyone loses.

Fix the problem by invalidating the bdev pagecache after flushing the
bdev, so that xfs_db will see up to date metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_buf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index dde346450952..54c774af6e1c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1945,6 +1945,7 @@ xfs_free_buftarg(
 	list_lru_destroy(&btp->bt_lru);
 
 	blkdev_issue_flush(btp->bt_bdev);
+	invalidate_bdev(btp->bt_bdev);
 	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
 
 	kmem_free(btp);
-- 
2.44.0.769.g3c40516874-goog

