Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435E5161936;
	Wed,  1 May 2024 18:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588892; cv=none; b=rZhVDzh1QSQywqni/Lz6CoKZ9jKcHoKHJdD6jMLummXashEtxGfNNDXvOYbtDh/z/KfzpLCviHKMh1LoQ1ncIiddsAs5fZaZsC4ZZvoXr/gdOKy3bF/wktihiSrpfue1i5neexLPLu2AAjpGUMt9cUPbjmT8ilL45ml7hvjgHHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588892; c=relaxed/simple;
	bh=nNkBNUv4OlgjwzNP3SCtAL89AtaXtlpGwxFOAkXG4Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BY8coQRRISw93DVunh4jjxWUVyoKbHoJ/StOR/mCxEpB8wbtRA5uTVNzgD8HyjDsOetHK7bbjZnPv0wsShBRUCElLQnwK2OAM5hBhqxHSllkKM1B2Um94iZX35paoTvLJ+Ikf0aj0ejBbf77YRTSo8gEgJejLTPfSnTo+ZjX5bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B1fkxeTZ; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B1fkxeTZ"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-23d4a841361so653799fac.2;
        Wed, 01 May 2024 11:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588890; x=1715193690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1W+XfeoRqm+4d3n8z6yVbbC2ZMY2GdaJw/mHXWkCAc8=;
        b=B1fkxeTZrXlajk2E0s49OLVmJz8datnssQp3BmluX4ZM5OhIVnSkyYD4VK89jqUqs5
         J39kb7oxzqiWDOkGh7IfSw1KYqdyhChD4Uz/MrAawHWFNuPMmytBVPxOBtZd358GA/1i
         H5sJDcENfQOqGDwB4Zo5zzCZMgXJdl1U1+vjvF9gIVrJqHDfOTNw1BKtIu2/cEc0i0/c
         VWth5GQyxK7ZIhmlic9gt1M6YGVMHxT7zTOEIvH4J08DkLplQkovzdg3tg6IdKjJzW+8
         Xn9STEenuWMF8t7BzeoUSTQ9P57Ng9wnaceY/CpXfPM0X8FHxWM8anT0xSwdGwcHHTqH
         uNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588890; x=1715193690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1W+XfeoRqm+4d3n8z6yVbbC2ZMY2GdaJw/mHXWkCAc8=;
        b=WsQCLlh0OSQCa8w5/CZT92IuyKYcXO2zBkPvI61rPPW/8Ja/KrrTEocvXpWLaY3zpq
         QE+gDZ18yWBvIWfgrwGtegylBrk0c9DAw6SdkoBiOOMWlIsJT+wwTHzyF99iZClpXw83
         YCKrVoWYcEjWb5Ykcle7JNHwFExgCBSFuQG4fM/OJ7KHjK3pOLx2NR4DupWZpezMVw5V
         MjFw70VSn25XDxPxK1JwI9+NlsqZwF712KAN4Cu6fSg9KLaWpXZ9Ef7pxpvZD6WGTbRP
         +EWn/IdCWdyjZ5Osc9TRM6pOYGNhTMWo9DLAoDZ9652huCOLvq62TFwqotR65j0QLqKF
         vLug==
X-Gm-Message-State: AOJu0Yx96sARnm6KWlC0zwtI8lb4I1JmCHzeS9fPTLILesewg7O7v7sV
	hn9GpW+Kw4yOXB/9mCxutMBF9KyskJh9rtsVNMmez5LkLRsIRw9CzyTziMZk
X-Google-Smtp-Source: AGHT+IEmY2OoP/AWlPUitZBO33aDgBgAAHmaU9S/FU6EKcEIF0PNyqnLBpmn2HGIYMDW4GevfsHgcA==
X-Received: by 2002:a05:6871:54e:b0:229:e689:7c1b with SMTP id t14-20020a056871054e00b00229e6897c1bmr3710965oal.7.1714588890268;
        Wed, 01 May 2024 11:41:30 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:29 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 14/24] xfs: invalidate block device page cache during unmount
Date: Wed,  1 May 2024 11:41:02 -0700
Message-ID: <20240501184112.3799035-14-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.45.0.rc1.225.g2a3ae87e7f-goog

