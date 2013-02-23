Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF5167F50
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2013 01:06:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D7698F8033
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 23:06:19 -0800 (PST)
Received: from USMAMAIL.TILERA.COM (usmamail.tilera.com [12.216.194.151]) by
	cuda.sgi.com with ESMTP id lELFTdDFYYqey8AK (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Feb 2013 23:06:18 -0800 (PST)
From: Tony Lu <zlu@tilera.com>
Subject: RE: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Date: Sat, 23 Feb 2013 07:06:10 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
	<20130223000802.GB26081@dastard>
In-Reply-To: <20130223000802.GB26081@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

>From: Dave Chinner [mailto:david@fromorbit.com]
>On Fri, Feb 22, 2013 at 08:12:52AM +0000, Tony Lu wrote:
>> I encountered the following panic when using xfs partitions as rootfs, which
>> is due to the truncated log data read by xlog_bread_noalign(). We should
>> extend the buffer by one extra log sector to ensure there's enough space to
>> accommodate requested log data, which we indeed did in xlog_get_bp(), but we
>> forgot to do in xlog_bread_noalign().
>
>We've never done that round up in xlog_bread_noalign(). It shouldn't
>be necessary as xlog_get_bp() and xlog_bread_noalign() are doing
>fundamentally different things. That is, xlog_get_bp() is ensuring
>the buffer is large enough for the upcoming IO that will be
>requested, while xlog_bread_noalign() is simply ensuring what it is
>passed is correctly aligned to device sector boundaries.

I set the sector size as 4096 when making the xfs filesystem.
-sh-4.1# mkfs.xfs -s size=4096 -f /dev/sda3

In this case, xlog_bread_noalign() needs to do such round up and round down frequently. And it is used to ensure what it is passed is aligned to the log sector size, but not the device sector boundaries.

Here is the debug info I added when mounting this xfs partition.
-sh-4.1# mount /dev/sda3 /home/
XFS (sda3): Mounting Filesystem
xlog_bread_noalign:blk_no=0,nbblks=1,l_sectBBsize=8
xlog_bread_noalign:blk_no=61447,nbblks=1,l_sectBBsize=8
xlog_bread_noalign:blk_no=0,nbblks=1,l_sectBBsize=8
.......
xlog_bread_noalign:blk_no=8695,nbblks=1,l_sectBBsize=8
xlog_bread_noalign:blk_no=4600,nbblks=4096,l_sectBBsize=8
xlog_bread_noalign:blk_no=8184,nbblks=512,l_sectBBsize=8

>So, if you have to fudge an extra block for xlog_bread_noalign(),
>that implies that what xlog_bread_noalign() was passed was probably
>not correct. It also implies that you are using sector sizes larger
>than 512 bytes, because that's the only time this might matter. Put
>simply, this:

While debugging, I found when it crashed, the blk_no was not align to the log sector size and nnblks was aligned to the log sector size, which makes sense.

For example, if xlog_bread_noalign() wants to read blocks from #1 to # 9, in which case the passed parameter blk_no is 1, and nbblks is 8, sectBBsize is 8, after the round down and round up operations, we get blk_no as 0, and nbblks as still 8. We definitely lose the last block of the log data.

>> XFS mounting filesystem sda2
>> Starting XFS recovery on filesystem: sda2 (logdev: internal)
>> XFS: xlog_recover_process_data: bad clientid
>> XFS: log mount/recovery failed: error 5
>> XFS: log mount failed
>
>Is not sufficient information for me to determine if you've correctly
>analysed the problem you were seeing and that this is the correct
>fix for it. I don't even know what kernel you are seeing this on, or
>how you are reproducing it.

I was using the 2.6.38.6 kernel, and using xfs as a rootfs partition. After untaring the rootfs files on the xfs partition, and tried to reboot from the xfs, then the panic occasionally occurred.

>
>Note that I'm not saying the fix isn't necessary or correct, just
>that I cannot review it based this commit message.  Given that this
>code is essentially unchanged in behaviour since the large sector
>size support was adding in 2003(*), understanding how it is
>deficient is critical part of the reviewi process....
>
>Information you need to provide so I have a chance of reviewing
>whether it is correct or not:
>
>	- what kernel you saw this on,
>	- what the filesystem configuration was
>	- what workload reproduced this problem (a test case would
>	  be nice, and xfstest even better)
>	- the actual contents of the log that lead to the short read
>	  during recovery
>	- whether xfs_logprint was capable of parsing the log
>	  correctly
>	- where in the actual log recovery process the failure
>	  occurred (e.g. was it trying to recover transactions from
>	  a section of a wrapped log?)

I hope I can provide the corrupted log for you, but probably I could not find it, since I fixed this bug a year ago. Recently when I do some clean-up on my code, I find this one, so I think I should return it back to the community.

>IOWs, please show your working so we can determine if this is the
>root cause of the problem you are seeing. :)
>
>(*)
>http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff
>;h=f14e527f411712f89178c31370b5d733ea1d0280
>
>FWIW, I think your change might need work - there's the possibility
>that is can round up the length beyond the end of the log if we ask
>to read up to the last sector of the log (i.e. blkno + blklen ==
>end of log) and then round up blklen by one sector....
>
Good catch, you are right on this. To avoid this possibility, I changed the patch a little bit as following.
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -171,6 +171,7 @@ xlog_bread_noalign(
        struct xfs_buf  *bp)
 {
        int             error;
+       xfs_daddr_t     orig_blk_no = blk_no;
 
        if (!xlog_buf_bbcount_valid(log, nbblks)) {
                xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
@@ -180,6 +181,13 @@ xlog_bread_noalign(
        }
 
        blk_no = round_down(blk_no, log->l_sectBBsize);
+
+       /* 
+        * If the blk_no is rounded down to be sector-aligned, we need to
+        * increase the nbblks accordingly, avoiding truncating the requested
+        * log data.
+        */
+       nbblks += orig_blk_no - blk_no;
        nbblks = round_up(nbblks, log->l_sectBBsize);
 
        ASSERT(nbblks > 0);

Thanks
-Tony

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
