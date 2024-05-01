Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002FA1607A4;
	Wed,  1 May 2024 18:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588890; cv=none; b=Yy6UQle/t3qaah+1itdBVgVA45dyFWyllKlPfiGg6kCu2M20DXT2gu4VuF3vTJmJw/CKCP66UdnDi+2epDNtBbXYCvFFVvCwWYKmWXrTKHLpbh0XCyZaTPm4rlDv9cwq6bgW7SwxxckmY7T0WNyq738jWFthmIoiv4AA57quzhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588890; c=relaxed/simple;
	bh=Tpv0ADHgX4II+e0QBHEVyub0dsgC/cRtTWL8vtjFEXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnZbaUlD4+6wkadBZYy+yhCUPsrTDJdcJ8Imo7PxBBti00c4EpmsfZ+y/7WZtR8xuvIplAtNb0O+dnfBOhbpAzBCVYajgLO2Vbsrv0YVsHJKxAkCIGR3Ndd6bBi8bBuOdrs4LK9xnEZlpqKKvbxTFCyPq2pa+aFM7lf8YDGKagQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nIEh22PQ; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nIEh22PQ"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ecee1f325bso6271403b3a.2;
        Wed, 01 May 2024 11:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588888; x=1715193688; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNkt4bZPtlQYE0jAQ8s2SgegqV6m/VJuU2o5S09jiyQ=;
        b=nIEh22PQLv3J1LCAkxhUHpRta6Y9ZGPt8j9VF4HiNyjtOYTnxFfmcXQk4oIhZt75gP
         NilUfjPLQQFXOP4XPCxSxnTBEMvQ/yU13pWvkhtA3+8RIF1sWmU5f0IMUH+KONrx8OPt
         wcNicQ6Nc1xD3QqQBhXse/p1mISJHnC2P4fQJrEisfjTK4i5ZFVOUVSSLrz3tGIokpgS
         QWS+65UG8CnXZdP9UV/jmUqKLgsKpoMJGJ9aFpRujeujy5vB+wMYrg31nGPplf3Czm8V
         Srfp98pXhBdy9aMyKfQYc0a6nq3k1cZxRflM9dzE5/r3byjKOxZdC67FWr3H3t4yO8LY
         N0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588888; x=1715193688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNkt4bZPtlQYE0jAQ8s2SgegqV6m/VJuU2o5S09jiyQ=;
        b=fGgTg5qeQzbJLkrCrpwl+znkxgU8oD8EWhhhHWoTgm0CZMU78ao4YuYbY39IskMR0h
         V2u3ERM2t2cMpc5mx3mYE8aLUX6cAPfEXpNLJ8qBCY4KElrdk8I00thoWdX39cMgPeFG
         f5xkGbJSiKXKh1CeDSMpI/ZTBWJ5lbqeMklP46AqfB8R5gOJ0t+smBaCpXCmmvqSFtXW
         29qebcIkRXonIAKSeFSh+v1hNdDfKdV72LsCYjPeh/DzzCRGS89Asb3iNMN8tWu3/V3v
         J+dLH9qWKI2leIpSMtAlqOM3dbdEnECBVCYNIbwwym7lv1VKcrDOuRIxQ3ZFkegIQAFB
         5koA==
X-Gm-Message-State: AOJu0YwPdZZqtKQc8DKh3RYPxv7gYJP9kR62VBKSSBIHtZD1IxrrFr7D
	xRG4cGU+g6wU0/C6WAcnzdH7Z2Gh1j3/yM9ETkRpzW+DSL06pJdymeJ0aZf9
X-Google-Smtp-Source: AGHT+IHmrxjNwBAzjcEvWNsn61bPsXML1QfQmGAiGci9azPER0GDYXl4fq3dxkId7ggmM4gDIf8PEw==
X-Received: by 2002:a05:6a00:39a5:b0:6ea:b818:f499 with SMTP id fi37-20020a056a0039a500b006eab818f499mr3966744pfb.19.1714588888181;
        Wed, 01 May 2024 11:41:28 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:27 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 12/24] xfs: fix sb write verify for lazysbcount
Date: Wed,  1 May 2024 11:41:00 -0700
Message-ID: <20240501184112.3799035-12-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.45.0.rc1.225.g2a3ae87e7f-goog

