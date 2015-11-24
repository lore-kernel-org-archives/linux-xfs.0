Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 26CCF7F37
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2015 07:24:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9DBC6AC004
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2015 05:24:27 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id SklfwTMroLHjb1Y7 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2015 05:24:25 -0800 (PST)
Date: Tue, 24 Nov 2015 14:24:21 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix race aio-dio vs freeze_fs
Message-ID: <20151124132421.GG25232@quack.suse.cz>
References: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 23-11-15 20:02:48, Dmitry Monakhov wrote:
> After freeze_fs was revoked (from Jan Kara) pages's write-back completion
> is deffered before unwritten conversion, so explicit flush_unwritten_io()
> was removed here: c724585b62411
> But we still may face deferred conversion for aio-dio case
> # Trivial testcase
> for ((i=0;i<60;i++));do fsfreeze -f /mnt ;sleep 1;fsfreeze -u /mnt;done &
> fio --bs=4k --ioengine=libaio --iodepth=128 --size=1g --direct=1 \
>     --runtime=60 --filename=/mnt/file --name=rand-write --rw=randwrite
> NOTE: Sane testcase should be integrated to xfstests, but it requires
> changes in common/* code, so let's use this this test at the moment.
> 
> In order to fix this race we have to guard journal transaction with explicit
> sb_{start,end}_intwrite()  as we do with ext4_evict_inode here:8e8ad8a5

Well, this problem seems to suggest that we have the freeze protection for
AIO writes wrong. We should call file_end_write() from aio_complete() and
not from aio_run_iocb()... I believe XFS and other filesystems may have
problems with this as well (CCed). Attached patch (so far only compile
tested since my test machine is pondering on something else) should fix
this.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--qDbXVdCdHGoSgWSk
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-aio-Fix-freeze-protection-of-aio-writes.patch"

>From a7332719d80dc94c11d1c1cb32c88b7f25e1ae61 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 24 Nov 2015 14:19:22 +0100
Subject: [PATCH] aio: Fix freeze protection of aio writes

Currently we dropped freeze protection of aio writes just after IO was
submitted. Thus aio write could be in flight while the filesystem was
frozen and that could result in unexpected situation like aio completion
wanting to convert extent type on frozen filesystem. Testcase from
Dmitry triggering this is like:

for ((i=0;i<60;i++));do fsfreeze -f /mnt ;sleep 1;fsfreeze -u /mnt;done &
fio --bs=4k --ioengine=libaio --iodepth=128 --size=1g --direct=1 \
    --runtime=60 --filename=/mnt/file --name=rand-write --rw=randwrite

Fix the problem by dropping freeze protection only once IO is completed
in aio_complete().

Reported-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/aio.c           | 10 +++++++---
 include/linux/fs.h |  1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 155f84253f33..3775030053f7 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1065,6 +1065,9 @@ static void aio_complete(struct kiocb *kiocb, long res, long res2)
 	unsigned tail, pos, head;
 	unsigned long	flags;
 
+	if (kiocb->ki_flags & IOCB_WRITE)
+		file_end_write(kiocb->ki_filp);
+
 	/*
 	 * Special case handling for sync iocbs:
 	 *  - events go directly into the iocb for fast handling
@@ -1449,13 +1452,14 @@ rw_common:
 
 		len = ret;
 
-		if (rw == WRITE)
+		/* We drop freeze protection in aio_complete() */
+		if (rw == WRITE) {
 			file_start_write(file);
+			req->ki_flags |= IOCB_WRITE;
+		}
 
 		ret = iter_op(req, &iter);
 
-		if (rw == WRITE)
-			file_end_write(file);
 		kfree(iovec);
 		break;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3aa514254161..54af40ed6a26 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -319,6 +319,7 @@ struct writeback_control;
 #define IOCB_EVENTFD		(1 << 0)
 #define IOCB_APPEND		(1 << 1)
 #define IOCB_DIRECT		(1 << 2)
+#define IOCB_WRITE		(1 << 3)
 
 struct kiocb {
 	struct file		*ki_filp;
-- 
2.1.4


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--qDbXVdCdHGoSgWSk--
