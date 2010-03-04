Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24MOl32201523 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 16:24:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 760F91D15CC2
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 14:26:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	0RCSPVmrZzfFrF31 for <xfs@oss.sgi.com>;
	Thu, 04 Mar 2010 14:26:14 -0800 (PST)
Date: Fri, 5 Mar 2010 09:26:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100304222611.GK14317@discord.disaster>
References: <4B8F871C.60802@dermichi.com>
	<20100304112018.GG14317@discord.disaster>
	<4B8FA2CD.6010904@dermichi.com>
	<20100304131511.GH14317@discord.disaster>
	<20100304134641.GA26871@infradead.org>
	<4B8FC1B7.3070505@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B8FC1B7.3070505@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Mar 04, 2010 at 03:20:39PM +0100, Michael Weissenbacher wrote:
> Hi Christoph/Dave!
>> Also when you next rebuilt the kernel please make sure to include
>> CONFIG_KALLSYMS in the configuration, possibly CONFIG_KALLSYMS_ALL too.
>> This will help greatly with decoding any kind of warning / oops.
> Thanks for this information. Unfortunately my current kernel was built  
> without CONFIG_KALLSYMS. I'm now recompiling with CONFIG_KALLSYMS and  
> CONFIG_KALLSYMS_ALL set. I reckon that my old traces can't be  
> ksymoops'ed even if i enable that kernel option now? I will see if i can  
> get a fresh trace then (even though i hope it won't happen again).

Yeah, that seems to be the case.

>> Was there anything else in the logs prior to the oops messages
>> that might indicate errors were occurring?
> Unfortunately everything in the logs is dandy until the error happens.  
> It seems that xfs_fsr randomly stops at some files and then locks up the  
> whole /var partition. I searched for the inode numbers where xfs_fsr  
> stopped and one time it was "/var/log/xfs_fsr.log" and the other time it  
> was "/var/spool/imap/x/user/xxxx/cyrus.cache" (username obfuscated).  

If you've got the inode numbers, then your running with the verbose
flag set? Do you still have the logs for those inodes that it hung
on?

> Whats's interesting is that i have the no-defrag flag set on the whole  
> /var/log directory and still it seemed to hang on that log file.

xfs_fsr doesn't do directory traversals to find files for defrag -
it uses more efficient bulkstat+open-by-handle method to visit every
inode in the filesystem once. As a result, it will still open inodes
that have the nodefrag flag set on them, but will then ignore them once
it finds the flag is set.

If xfs_fsr hung before it checked the nodefrag flag, then there's
only a few things it could get stuck on:

	1. fsync() of the file
	2. file lock checks
	3. statvfs64()
	4. ioctl(XFS_IOC_FSGETXATTR)

A trace would tell us which one it was....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
