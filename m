Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 518948032
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 02:33:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1AE1D304051
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 00:33:00 -0800 (PST)
Received: from USMAMAIL.TILERA.COM (usmamail.tilera.com [12.216.194.151]) by
	cuda.sgi.com with ESMTP id JaNn6LU08jdDc1Nv (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 00:32:59 -0800 (PST)
From: Tony Lu <zlu@tilera.com>
Subject: RE: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Date: Mon, 4 Mar 2013 08:32:45 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C47C4C19C@USMAExch1.tad.internal.tilera.com>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
	<20130223000802.GB26081@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
	<20130223235546.GA5551@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
	<20130224141017.GC5551@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C49005@USMAExch1.tad.internal.tilera.com>
	<5130CE9E.9080501@sgi.com> <51310E7A.1000905@sgi.com>
In-Reply-To: <51310E7A.1000905@sgi.com>
Content-Language: zh-CN
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: Alex Elder <elder@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

Thanks for you following up.

My apologize that I just found that it is one change I made before that causes this problem. This change forces mkfs.xfs to format xfs partitions whose sectorsize were not smaller than 4096 bytes, which was due to a bug that earlier versions of xfs used (struct *page)->private(long) as a bitmap to represent each block's state within a page (the size of a page could be 64K or larger, then it needs 128 bit or more to represent each block's state within a page).

This is reproducible on 2.6.38.6 kernel on X86. But I do not get why this change makes the xfs log inconsistent during mount/cp/umount operations.

diff -dur xfsprogs-3.1.4.ori/include/xfs_alloc_btree.h xfsprogs-3.1.4/include/xfs_alloc_btree.h
--- xfsprogs-3.1.4.ori/include/xfs_alloc_btree.h        2010-01-30 03:46:13.000000000 +0800
+++ xfsprogs-3.1.4/include/xfs_alloc_btree.h    2013-03-04 16:11:41.000000000 +0800
@@ -59,7 +59,7 @@
 #define XFS_MAX_BLOCKSIZE_LOG  16      /* i.e. 65536 bytes */
 #define XFS_MIN_BLOCKSIZE      (1 << XFS_MIN_BLOCKSIZE_LOG)
 #define XFS_MAX_BLOCKSIZE      (1 << XFS_MAX_BLOCKSIZE_LOG)
-#define XFS_MIN_SECTORSIZE_LOG 9       /* i.e. 512 bytes */
+#define XFS_MIN_SECTORSIZE_LOG 12      /* i.e. 512 bytes */
 #define XFS_MAX_SECTORSIZE_LOG 15      /* i.e. 32768 bytes */
 #define XFS_MIN_SECTORSIZE     (1 << XFS_MIN_SECTORSIZE_LOG)
 #define XFS_MAX_SECTORSIZE     (1 << XFS_MAX_SECTORSIZE_LOG)

Thanks
-Tony

>-----Original Message-----
>From: Mark Tinguely [mailto:tinguely@sgi.com]
>Sent: Saturday, March 02, 2013 4:24 AM
>To: Tony Lu
>Cc: Alex Elder; linux-kernel@vger.kernel.org; Chris Metcalf; xfs@oss.sgi.com;
>Ben Myers; Dave Chinner; linux-fsdevel@vger.kernel.org
>Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
>xlog_bread_noalign()
>
>On 03/01/13 09:51, Mark Tinguely wrote:
>> On 02/26/13 01:28, Tony Lu wrote:
>>> I get a reliable way to reproduce this bug. The logprint and metadump
>>> are attached.
>>>
>>> Kernel version: 2.6.38.8
>>> Mkfs.xfs version: xfsprogs-3.1.1
>>> mkfs.xfs -s size=4096 /dev/sda1
>>>
>>> Run the following mount-cp-umount script to reproduce:
>>> #!/bin/sh
>>> device=/dev/sda1
>>> mount_point=/mnt
>>> times=10
>>>
>>> for ((num=1;num<=$times;num++))
>>> do
>>> echo "$num mount $device $mount_point"
>>> mount $device $mount_point
>>>
>>> echo "cp -rf /bin $mount_point/$num"
>>> cp -rf /bin $mount_point/$num
>>>
>>> echo "$num umount $device $mount_point"
>>> umount $mount_point
>>>
>>> #num=$(($num + 1))
>>> done
>>>
>>> After several times of mount/cp/umount, this xfs crashes, and the xfs
>>> partition can not be mounted any more. Here is the output of console.
>>> -sh-4.1# ./umount-test
>>> 1 mount /dev/sda1 /mnt
>>> XFS mounting filesystem sda1
>>> cp -rf /bin /mnt/1
>>> 1 umount /dev/sda1 /mnt
>>> 2 mount /dev/sda1 /mnt
>>> XFS mounting filesystem sda1
>>> cp -rf /bin /mnt/2
>>> 2 umount /dev/sda1 /mnt
>>> 3 mount /dev/sda1 /mnt
>>> XFS mounting filesystem sda1
>>> cp -rf /bin /mnt/3
>>> 3 umount /dev/sda1 /mnt
>>> 4 mount /dev/sda1 /mnt
>>> XFS mounting filesystem sda1
>>> cp -rf /bin /mnt/4
>>> 4 umount /dev/sda1 /mnt
>>> 5 mount /dev/sda1 /mnt
>>> XFS mounting filesystem sda1
>>> Starting XFS recovery on filesystem: sda1 (logdev: internal)
>>> Ending XFS recovery on filesystem: sda1 (logdev: internal)cp -rf /bin
>>> /mnt/5
>>> 5 umount /dev/sda1 /mnt
>>> 6 mount /dev/sda1 /mnt
>>>
>>> XFS mounting filesystem sda1
>>> Starting XFS recovery on filesystem: sda1 (logdev: internal)
>>> Ending XFS recovery on filesystem: sda1 (logdev: internal)Interrupt
>>> cp -rf /bin /mnt/6
>>> 6 umount /dev/sda1 /mnt
>>> 7 mount /dev/sda1 /mnt
>>>
>>> XFS mounting filesystem sda1
>>> cp -rf /bin /mnt/7
>>> 7 umount /dev/sda1 /mnt
>>> Interrupt
>>> 8 mount /dev/sda1 /mnt
>>> XFS mounting filesystem sda1
>>> Starting XFS recovery on filesystem: sda1 (logdev: internal)
>>> XFS: xlog_recover_process_data: bad clientid
>>> XFS: log mount/recovery failed: error 5
>>> XFS: log mount failed
>>>
>>> Thanks
>>> -Tony
>>
>> It works fine on a 2.6.32 machine I had sitting around - and I never
>> required log recovery.
>>
>> I think you need to answer Dave's question as to why is your unmounts
>> are requiring recovery?
>>
>> Are there errors in the /var/log/messages?
>>
>> I downloaded the Linux 2.6.38.8 source and take a look if I can recreate
>> the problem.
>>
>> --Mark.
>
>I could not reproduce the problem on a vanilla install. XFS shutdown and
>remounted cleanly running your script (several iterations looping set to
>100).
>
>I started fsstress on another XFS partition on the same disk to see if I
>could force a shutdown race. With CONFIG_XFS_DEBUG=y, I could trigger
>other ASSERTs on the fsstress partition so I never stayed up long enough
>to cause a shutdown race.
>
>Not wanting to patch that version of Linux/XFS, I am bailing here. If
>you want to turn on the XFS debug it may point out why your filesystem
>is not shutting down cleanly.
>
>--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
