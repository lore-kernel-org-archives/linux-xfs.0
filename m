Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UMvuYS037383 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 17:57:56 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1G19aXfoBDqQ69aJ for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 15:58:48 -0700 (PDT)
Date: Fri, 31 Aug 2012 08:58:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Mount Recovery Failed on Root File System After Power Outage
Message-ID: <20120830225826.GG15292@dastard>
References: <0e85aee5ff82e567e872230ef416766a.squirrel@emailmg.netfirms.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0e85aee5ff82e567e872230ef416766a.squirrel@emailmg.netfirms.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chin Gim Leong <CHIN_Gim_Leong@performance-computing.net>
Cc: xfs@oss.sgi.com

On Thu, Aug 30, 2012 at 10:08:38PM +0800, Chin Gim Leong wrote:
> Hi
> 
> 
> I apologize first if this message appears a number of times, but my two
> yahoo email accounts do not seem to be able to deliver to the mailing list
> from afternoon till now and I have to use this account.
> 
> I just had a power outage and my Acer notebook computer running openSUSE
> 11.4 x86_64 with kernel 2.6.37 stopped as a result.

What mount options? What is the output of /proc/mounts? What are the
messages in dmesg when you mount a partition?

> I then tried again to mount the root file system to /mnt.
> 
> Aug 30 14:21:59 Rescue kernel: [  811.166914] XFS mounting filesystem sdb2
> Aug 30 14:21:59 Rescue kernel: [  811.212169] Starting XFS recovery on
> filesystem: sdb2 (logdev: internal)
> Aug 30 14:21:59 Rescue kernel: [  811.334157] XFS: Invalid block length
> (0xfffffffc) given for buffer

The log is definitely corrupted if it is asking for a length that
large.

> Aug 30 14:21:59 Rescue kernel: [  811.334175] XFS: log mount/recovery
> failed: error 117

EUCLEAN: structure needs cleaning.

Yup, the log is considered corrupt.

> Aug 30 14:21:59 Rescue kernel: [  811.334230] XFS: log mount failed
> 
> XFS Check will not run since log recovery mount has not been done.
> 
> What is the cause of the recovery failure and what is the recommended
> course of action?
> 
> I have tried the metadump and restore, then do a xfs_repair -L on the
> metadump image, with xfs_repair version 3.1.8.  The repair is successful
> and there are also some files copied to lost+found.

That's your only option for recovery.

> I would like to know the cause of this log recovery failure and if there

You've got an old, unsupported kernel that was going through
significant changes to the log code at the time, so it may not be
possible to work out what the problem was. It seems likely that the
power loss caused the disk not to write everything it should have to
the log - laptops are not supposed to just lose power because
they have a built in UPS (i.e. battery)....

> is another alternative to xfs_repair -L, since I do not really know what
> files I would lose with the inodes being changed, and also I do not know
> what the files in lost+found are.

The files in lost+found are numbered by their inode number. You need
to look at the contents of them to determine where they came from.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
