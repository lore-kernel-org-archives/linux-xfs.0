Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB8E6ABBF
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Cgu97VbW"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d0bcc0c313so48391035ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 13:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702590038; x=1703194838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1WuvEIHghGHAfT4PJ6Q0K+Zy1IA9TDp0CI/fBBOM9SQ=;
        b=Cgu97VbW6aSJqsMPNh1w/WXuc5xcNITCF9G8m7gbtJHNxG0UzMAf5JNxbnYg68nZuH
         wDrACaZmjA5ghMZYuUYe68wEZjy/wiLMWvHLmQ7/FBQ5+LMHig89/OWwb2yWCNvPernQ
         Q+oMRqHbM+WW9LhVqk7kBM6g6w+2mRPaCUXblpHUI5iICVxL133lqut5Ce7305qWlIp8
         Vz5gSU9u+m9eYjz/jewN0g9wBbcXc2R5vVL8UPNRslr43862+1Pn9h4vMUYvNqU4JXrm
         kzkU7Hc8i4onbVon9GXIwDvX2gQSFtVjqSZFcQC73dDEDbbiFAewA6VcIlYDRH5r/PKx
         q7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702590038; x=1703194838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1WuvEIHghGHAfT4PJ6Q0K+Zy1IA9TDp0CI/fBBOM9SQ=;
        b=B3+K/yLs+SPFg2WSpIMYaqHA8cyYK9CNhnjWO5a0Bqm9syAlyXAhbpJif+NCYKjKDH
         q8vcQDmq8FIeUZ+nSXw8CwGYGtVas8aJ7DCd2DhG54BUkeyRTusY0zT4Aex6vF4xekqn
         XBsSUuowlULc6irxmzLj7EVIuOMg4v6ZC+pRQOXvFQNH8NYXc/+MZG4euy8fb3Qsd/is
         oNdDxhzIQzS3NLHfIr2sKIUjDzIQn76KtBnzK+SdPMG8BFDfL2yaosfaPSIWrFFMpzRH
         DPRC2phcXIlIAQ+q7nMeZ7xFC87BXTkp44fD7i1OVni+H7FiYkbPF7Gs+Gi7fFEXDkB/
         5XDg==
X-Gm-Message-State: AOJu0YzlLHGl2nBPPNvBLluDZIx+op3PBCGWVnsE23vrgt7mhMmvgAer
	u3avVEdFrEIagp3mWZG8AuUrcyhcBQNcsnKUBqY=
X-Google-Smtp-Source: AGHT+IGUzn5fOrm3Wz2huw/RGihetxnaSTf7MwWf6aUCS41y3JlJRZ0F+JltlTfvw4TBWIbRnbPtrQ==
X-Received: by 2002:a17:902:b20c:b0:1d0:60c6:1db8 with SMTP id t12-20020a170902b20c00b001d060c61db8mr4966638plr.32.1702590038301;
        Thu, 14 Dec 2023 13:40:38 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902bd0300b001d346ff1331sm4410827pls.105.2023.12.14.13.40.37
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 13:40:37 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rDtRc-008Mvb-0K
	for linux-xfs@vger.kernel.org;
	Fri, 15 Dec 2023 08:40:35 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rDtRb-0000000FvQc-2fC7
	for linux-xfs@vger.kernel.org;
	Fri, 15 Dec 2023 08:40:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: initialise di_crc in xfs_log_dinode
Date: Fri, 15 Dec 2023 08:40:35 +1100
Message-ID: <20231214214035.3795665-1-david@fromorbit.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Alexander Potapenko report that KMSAN was issuing these warnings:

kmalloc-ed xlog buffer of size 512 : ffff88802fc26200
kmalloc-ed xlog buffer of size 368 : ffff88802fc24a00
kmalloc-ed xlog buffer of size 648 : ffff88802b631000
kmalloc-ed xlog buffer of size 648 : ffff88802b632800
kmalloc-ed xlog buffer of size 648 : ffff88802b631c00
xlog_write_iovec: copying 12 bytes from ffff888017ddbbd8 to ffff88802c300400
xlog_write_iovec: copying 28 bytes from ffff888017ddbbe4 to ffff88802c30040c
xlog_write_iovec: copying 68 bytes from ffff88802fc26274 to ffff88802c300428
xlog_write_iovec: copying 188 bytes from ffff88802fc262bc to ffff88802c30046c
=====================================================
BUG: KMSAN: uninit-value in xlog_write_iovec fs/xfs/xfs_log.c:2227
BUG: KMSAN: uninit-value in xlog_write_full fs/xfs/xfs_log.c:2263
BUG: KMSAN: uninit-value in xlog_write+0x1fac/0x2600 fs/xfs/xfs_log.c:2532
 xlog_write_iovec fs/xfs/xfs_log.c:2227
 xlog_write_full fs/xfs/xfs_log.c:2263
 xlog_write+0x1fac/0x2600 fs/xfs/xfs_log.c:2532
 xlog_cil_write_chain fs/xfs/xfs_log_cil.c:918
 xlog_cil_push_work+0x30f2/0x44e0 fs/xfs/xfs_log_cil.c:1263
 process_one_work kernel/workqueue.c:2630
 process_scheduled_works+0x1188/0x1e30 kernel/workqueue.c:2703
 worker_thread+0xee5/0x14f0 kernel/workqueue.c:2784
 kthread+0x391/0x500 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:242

Uninit was created at:
 slab_post_alloc_hook+0x101/0xac0 mm/slab.h:768
 slab_alloc_node mm/slub.c:3482
 __kmem_cache_alloc_node+0x612/0xae0 mm/slub.c:3521
 __do_kmalloc_node mm/slab_common.c:1006
 __kmalloc+0x11a/0x410 mm/slab_common.c:1020
 kmalloc ./include/linux/slab.h:604
 xlog_kvmalloc fs/xfs/xfs_log_priv.h:704
 xlog_cil_alloc_shadow_bufs fs/xfs/xfs_log_cil.c:343
 xlog_cil_commit+0x487/0x4dc0 fs/xfs/xfs_log_cil.c:1574
 __xfs_trans_commit+0x8df/0x1930 fs/xfs/xfs_trans.c:1017
 xfs_trans_commit+0x30/0x40 fs/xfs/xfs_trans.c:1061
 xfs_create+0x15af/0x2150 fs/xfs/xfs_inode.c:1076
 xfs_generic_create+0x4cd/0x1550 fs/xfs/xfs_iops.c:199
 xfs_vn_create+0x4a/0x60 fs/xfs/xfs_iops.c:275
 lookup_open fs/namei.c:3477
 open_last_lookups fs/namei.c:3546
 path_openat+0x29ac/0x6180 fs/namei.c:3776
 do_filp_open+0x24d/0x680 fs/namei.c:3809
 do_sys_openat2+0x1bc/0x330 fs/open.c:1440
 do_sys_open fs/open.c:1455
 __do_sys_openat fs/open.c:1471
 __se_sys_openat fs/open.c:1466
 __x64_sys_openat+0x253/0x330 fs/open.c:1466
 do_syscall_x64 arch/x86/entry/common.c:51
 do_syscall_64+0x4f/0x140 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b arch/x86/entry/entry_64.S:120

Bytes 112-115 of 188 are uninitialized
Memory access of size 188 starts at ffff88802fc262bc

This is caused by the struct xfs_log_dinode not having the di_crc
field initialised. Log recovery never uses this field (it is only
present these days for on-disk format compatibility reasons) and so
it's value is never checked so nothing in XFS has caught this.

Further, none of the uninitialised memory access warning tools have
caught this (despite catching other uninit memory accesses in the
struct xfs_log_dinode back in 2017!) until recently. Alexander
annotated the XFS code to get the dump of the actual bytes that were
detected as uninitialised, and from that report it took me about 30s
to realise what the issue was.

The issue was introduced back in 2016 and every inode that is logged
fails to initialise this field. This is no actual bad behaviour
caused by this issue - I find it hard to even classify it as a
bug...

Reported-and-tested-by: Alexander Potapenko <glider@google.com>
Fixes: f8d55aa0523a ("xfs: introduce inode log format object")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 157ae90d3d52..0287918c03dc 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -557,6 +557,9 @@ xfs_inode_to_log_dinode(
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_v3_pad = 0;
+
+		/* dummy value for initialisation */
+		to->di_crc = 0;
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = ip->i_flushiter;
-- 
2.42.0

