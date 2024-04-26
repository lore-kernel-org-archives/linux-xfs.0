Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F333E38DC3
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168563; cv=none; b=gKo09STHfm1RXgg/t+Y6LCDuTDHsG5EKKJ1aZ8eK3nya4UIRvODdkCuITUflBaJ3usamKhIV74vf9zX6nj1gmDL2LK6GSraCepDvaJTMQlAsw67J8WfqXR5/gDHLPZoROCjDm79fimvq4YwVukmcyjSJx2bOM7IJnRgDo1RxTLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168563; c=relaxed/simple;
	bh=bk3lpnetHLN3B3aWPqzKx8lv0E490khl9xgMBPEhMSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVahcPwR3CQxUBsgy18HAnzD1QxEr5vG7Q9PHObDzK3ydEc/QhPFrLtEbuEx4G7g/RAZec0HpVNzMuFIN4uR+rJOUAeHK/5ziIVvTGN6dc6mjjYyB5JZhdXhot3kaR6D8ky7l/v2M3INzHpULy5kue89lfZRBdKdtCLYu/HD5Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yx4VgtFM; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yx4VgtFM"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e9451d8b71so23623365ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168561; x=1714773361; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUdKEAlR9Lv7qwu40BEj3Ujyv05MVk4KCVWcoRXZqek=;
        b=Yx4VgtFM93jD1AsKkUlEzY5rXuZF+PByxsMDvAFBtn76Sji0yUUCKseGDHWY403bvp
         Bluky2cj3Jnhu6Ti3qJqanH223eli1pQ2NOBOQG2zYg17o9gTbTa9eRldDuJEFHD74BK
         X4cSKRcxvkQIRYLeEZfN1Shgy53GHOopoGtGB2hL51+J8U+xY7SD9UVOHfijSRkVaRTv
         xx9JCE2BfV+avJb3EdXkbQpJCTVxL9qRdswaZm0yxsdJ+4DNFEZm5IcJpGWaSuPYyKcV
         YlMCDKQgPuwSFGALIZu9jGZz6LgVY3wyas8qaB13KHShQ/kmXFLE7PRFX4n+i4EaNXEH
         g0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168561; x=1714773361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eUdKEAlR9Lv7qwu40BEj3Ujyv05MVk4KCVWcoRXZqek=;
        b=WyfmpuphRGpvyQxPpkBBwngWn21xT5zfmvKWUnHxH9FO+ghQzSoga9rTJrHi9ESWvS
         M5DisCp3b9sbKNC4GcWTk7FjQo1SgtgswigyVpFQtsouaxuQrck7bOd5wNFd5spTSc+U
         pI5ccUqjH1S2krAEeg9bjJMBvUFDBRZPg1DAaVQWlz398ok7ru2W1aaZW7rS0ZRDjrb4
         yDVQncVZ+wzGhvndqKR8G40L059k6/KjlG5qG/A/RRfvJS9wjvx+zRY4NDNqo/VFiOOC
         RZm1FiXlaaKEcRfi5OgmQ1UWKcgxDb+Ztfgw5t5uMjBnWPqDqfHzTKB5hyaZScJi2SFo
         BJlQ==
X-Gm-Message-State: AOJu0Yz98Jx0YakJJjZrCLcI7h4EF8pRrJ7VbfOJ446Y5nhjy1Snse+7
	RAj8LJwnBUYv+sCaw1VW/ODrC2eKFje8O9gwWngFXOYDoML9cOabzTMbFlcA
X-Google-Smtp-Source: AGHT+IGhokCYfq5HKcDiOGEHYwLada4ZLMsFqz+YmyvzwTVRnwlmDXjORLg0LwML96qFBZWEHoQf6Q==
X-Received: by 2002:a17:902:d48f:b0:1eb:4c47:3454 with SMTP id c15-20020a170902d48f00b001eb4c473454mr791757plg.0.1714168561020;
        Fri, 26 Apr 2024 14:56:01 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:00 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 12/24] xfs: fix sb write verify for lazysbcount
Date: Fri, 26 Apr 2024 14:54:59 -0700
Message-ID: <20240426215512.2673806-13-leah.rumancik@gmail.com>
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

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 59f6ab40fd8735c9a1a15401610a31cc06a0bbd6 ]

When lazysbcount is enabled, fsstress and loop mount/unmount test report
the following problems:

XFS (loop0): SB summary counter sanity check failed
XFS (loop0): Metadata corruption detected at xfs_sb_write_verify+0x13b/0x460,
	xfs_sb block 0x0
XFS (loop0): Unmount and run xfs_repair
XFS (loop0): First 128 bytes of corrupted metadata buffer:
00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 28 00 00  XFSB.........(..
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 69 fb 7c cd 5f dc 44 af 85 74 e0 cc d4 e3 34 5a  i.|._.D..t....4Z
00000030: 00 00 00 00 00 20 00 06 00 00 00 00 00 00 00 80  ..... ..........
00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
00000050: 00 00 00 01 00 0a 00 00 00 00 00 04 00 00 00 00  ................
00000060: 00 00 0a 00 b4 b5 02 00 02 00 00 08 00 00 00 00  ................
00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 14 00 00 19  ................
XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply
	+0xe1e/0x10e0 (fs/xfs/xfs_buf.c:1580).  Shutting down filesystem.
XFS (loop0): Please unmount the filesystem and rectify the problem(s)
XFS (loop0): log mount/recovery failed: error -117
XFS (loop0): log mount failed

This corruption will shutdown the file system and the file system will
no longer be mountable. The following script can reproduce the problem,
but it may take a long time.

 #!/bin/bash

 device=/dev/sda
 testdir=/mnt/test
 round=0

 function fail()
 {
	 echo "$*"
	 exit 1
 }

 mkdir -p $testdir
 while [ $round -lt 10000 ]
 do
	 echo "******* round $round ********"
	 mkfs.xfs -f $device
	 mount $device $testdir || fail "mount failed!"
	 fsstress -d $testdir -l 0 -n 10000 -p 4 >/dev/null &
	 sleep 4
	 killall -w fsstress
	 umount $testdir
	 xfs_repair -e $device > /dev/null
	 if [ $? -eq 2 ];then
		 echo "ERR CODE 2: Dirty log exception during repair."
		 exit 1
	 fi
	 round=$(($round+1))
 done

With lazysbcount is enabled, There is no additional lock protection for
reading m_ifree and m_icount in xfs_log_sb(), if other cpu modifies the
m_ifree, this will make the m_ifree greater than m_icount. For example,
consider the following sequence and ifreedelta is postive:

 CPU0				 CPU1
 xfs_log_sb			 xfs_trans_unreserve_and_mod_sb
 ----------			 ------------------------------
 percpu_counter_sum(&mp->m_icount)
				 percpu_counter_add_batch(&mp->m_icount,
						idelta, XFS_ICOUNT_BATCH)
				 percpu_counter_add(&mp->m_ifree, ifreedelta);
 percpu_counter_sum(&mp->m_ifree)

After this, incorrect inode count (sb_ifree > sb_icount) will be writen to
the log. In the subsequent writing of sb, incorrect inode count (sb_ifree >
sb_icount) will fail to pass the boundary check in xfs_validate_sb_write()
that cause the file system shutdown.

When lazysbcount is enabled, we don't need to guarantee that Lazy sb
counters are completely correct, but we do need to guarantee that sb_ifree
<= sb_icount. On the other hand, the constraint that m_ifree <= m_icount
must be satisfied any time that there /cannot/ be other threads allocating
or freeing inode chunks. If the constraint is violated under these
circumstances, sb_i{count,free} (the ondisk superblock inode counters)
maybe incorrect and need to be marked sick at unmount, the count will
be rebuilt on the next mount.

Fixes: 8756a5af1819 ("libxfs: add more bounds checking to sb sanity checks")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c |  4 +++-
 fs/xfs/xfs_mount.c     | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b6a584e044be..28c464307817 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -973,7 +973,9 @@ xfs_log_sb(
 	 */
 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
-		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
+		mp->m_sb.sb_ifree = min_t(uint64_t,
+				percpu_counter_sum(&mp->m_ifree),
+				mp->m_sb.sb_icount);
 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 	}
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e8bb3c2e847e..fb87ffb48f7f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -538,6 +538,20 @@ xfs_check_summary_counts(
 	return 0;
 }
 
+static void
+xfs_unmount_check(
+	struct xfs_mount	*mp)
+{
+	if (xfs_is_shutdown(mp))
+		return;
+
+	if (percpu_counter_sum(&mp->m_ifree) >
+			percpu_counter_sum(&mp->m_icount)) {
+		xfs_alert(mp, "ifree/icount mismatch at unmount");
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
+	}
+}
+
 /*
  * Flush and reclaim dirty inodes in preparation for unmount. Inodes and
  * internal inode structures can be sitting in the CIL and AIL at this point,
@@ -1077,6 +1091,7 @@ xfs_unmountfs(
 	if (error)
 		xfs_warn(mp, "Unable to free reserved block pool. "
 				"Freespace may not be correct on next mount.");
+	xfs_unmount_check(mp);
 
 	xfs_log_unmount(mp);
 	xfs_da_unmount(mp);
-- 
2.44.0.769.g3c40516874-goog

