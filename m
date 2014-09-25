Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7DE7E7F8B
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 03:13:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4FCEF8F8087
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 01:13:10 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	N5mxBqR6WoBN4liM for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 01:13:08 -0700 (PDT)
Date: Thu, 25 Sep 2014 18:12:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS issue xfs goes offline with various messages drive not
	recoverable without reboot
Message-ID: <20140925081254.GH4758@dastard>
References: <dd6d1d6e9fa7469584e72574347bb088@BN1PR0301MB0625.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <dd6d1d6e9fa7469584e72574347bb088@BN1PR0301MB0625.namprd03.prod.outlook.com>
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
To: Simon Dray <sdray@Espial.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Sep 25, 2014 at 07:30:23AM +0000, Simon Dray wrote:
> Dear Sirs
> 
> I wonder if you can help with an issue we see re-occuring on a regular basis with one of our HP systems which uses a HP 420 Raid controller

tl;dr: more information is needed about your system to make sense of
the problem. See here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> Action taken
> 
> We first saw the following:
> [root@ content]# ls
> ls: cannot open directory .: Input/output error

The filesystem has shut down due to a fatal error.

> We try to run:
> [root@ /]# xfs_check /dev/md0
> xfs_check: /dev/md0 contains a mounted and writable filesystem
> fatal error -- couldn't initialize XFS library

FYI, xfs_check was deprecated a quite a while ago. It no longer
exists in current releases....

> We also tried to umount the /dev/md0 before runniing xfs_check but no luck. We received the error: device is in use

That can happen if the storage has gone bad and IOs have been lost.

> We use xfs for one of our large raid file systems and we are seeing the xfs filesystem go offline with the following messages in dmesg
> 
> messages-20140921:Sep 18 23:01: kernel: XFS (md0): Device md0: metadata write error block 0x5e28623d8

What messages occurred before this? Something reported an IO error
back to XFS, and so that something should have logged an error
message...

> messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): I/O error occurred: meta-data dev md0 block 0x445cccc40 ("xlog_iodone") error 5 buf count 32768
> messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_do_force_shutdown(0x2) called from line 891 of file fs/xfs/xfs_log.c. Return address = 0xffffffffa2c428dc
> messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): Log I/O Error Detected. Shutting down filesystem
> messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): Please umount the filesystem and rectify the problem(s)
> messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
> messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_iunlink_remove: xfs_itobp() returned error 5.

Yup, kernel code is at least 2 years old, because we removed
xfs_itobp in mid 2012... ;)

> In all occurrences the only way to recover from this is to reboot
> the system and allow xfs_repair to run during boot this clears the
> issue until next time
> 
> We have checked the RAID health and nothing seems to be amiss, if
> you could help with this it would be much appreciated

That's par for the course when hardware raid goes AWOL - they almost
never report that they had a problem when they hang (e.g. firmware
crashes so can't log an event to say it crashed).

But really, more information about your system and more complete
logs are needed to be able to make any progress triaging the
problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
