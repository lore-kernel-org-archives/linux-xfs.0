Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 945C87F50
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2013 22:46:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8297D304039
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2013 20:46:36 -0800 (PST)
Received: from USMAMAIL.TILERA.COM (usmamail.tilera.com [12.216.194.151]) by
	cuda.sgi.com with ESMTP id GExuHMHkevuuq211 (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Feb 2013 20:46:35 -0800 (PST)
From: Tony Lu <zlu@tilera.com>
Subject: RE: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Date: Sun, 24 Feb 2013 04:46:30 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
	<20130223000802.GB26081@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
	<20130223235546.GA5551@dastard>
In-Reply-To: <20130223235546.GA5551@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <elder@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

>> For example, if xlog_bread_noalign() wants to read blocks from #1
>> to # 9, in which case the passed parameter blk_no is 1, and nbblks
>> is 8, sectBBsize is 8, after the round down and round up
>> operations, we get blk_no as 0, and nbblks as still 8. We
>> definitely lose the last block of the log data.
>
>Yes, I fully understand that. But I also understand how the log
>works and that this behaviour *should not happen*. That's why
>I'm asking questions about what the problem you are trying to fix.

I am not sure about this, since I saw many reads on non-sector-align blocks even when successfully mounting good XFS partitions. 
-sh-4.1# mount /dev/sda3 /home/
XFS (sda3): Mounting Filesystem
xlog_bread_noalign:blk_no=0,nbblks=1,l_sectBBsize=8
xlog_bread_noalign:blk_no=61447,nbblks=1,l_sectBBsize=8
xlog_bread_noalign:blk_no=0,nbblks=1,l_sectBBsize=8
.......
xlog_bread_noalign:blk_no=8695,nbblks=1,l_sectBBsize=8
xlog_bread_noalign:blk_no=4600,nbblks=4096,l_sectBBsize=8
xlog_bread_noalign:blk_no=8184,nbblks=512,l_sectBBsize=8

And also there is code in xlog_write_log_records() which handles non-sector-align reads and writes.

	/* We may need to do a read at the start to fill in part of
	 * the buffer in the starting sector not covered by the first
	 * write below.
	 */
	balign = round_down(start_block, sectbb);
	if (balign != start_block) {
		error = xlog_bread_noalign(log, start_block, 1, bp);
		if (error)
			goto out_put_bp;

		j = start_block - balign;
	}

>Ramdisks don't persist over a reboot, so you must have had some
>other way of reproducing the problem. Can you tell me how you
>reproduced it on a ramdisk? Better yet, send me a script that
>reproduces the problem?

I will try to reproduce it. Basically it is a loop of mount, creating many files and unmount.

Thanks
-Tony

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
