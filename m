Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1F0SPxM134574 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 18:28:25 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GqEABoOF8OqULsBf for <xfs@oss.sgi.com>;
	Tue, 14 Feb 2012 16:28:23 -0800 (PST)
Date: Wed, 15 Feb 2012 11:28:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr (defragmenting) 'XFS_IOC_SWAPEXT failed: ino=xxxxxx:
	Invalid argument' error
Message-ID: <20120215002811.GM7479@dastard>
References: <4F3AAC04.5090400@rhul.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F3AAC04.5090400@rhul.ac.uk>
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
To: Tom Crane <T.Crane@rhul.ac.uk>
Cc: xfs@oss.sgi.com

On Tue, Feb 14, 2012 at 06:46:28PM +0000, Tom Crane wrote:
> Dear XFS Support,
>   I am attempting to use xfs_fsr to defrag a 60TB FS but am getting
> some of the following errors;
> 'XFS_IOC_SWAPEXT failed: ino=xxxxxx: Invalid argument'.  Most files
> defrag w/o problem.  In an hour long run only 45/(45+6211) failed
> this way.  Here is a example chunk of syslog from a run with fsr -v
> which includes the FS level reports.
.....
> >Feb 14 15:49:15 store3 fsr[10917]: ino=797728
> >Feb 14 15:49:17 store3 kernel: Filesystem dm-0:
> >fs/xfs/xfs_dfrag.c: inode 0xc2c20 format is incompatible for exchanging.
> >Feb 14 15:49:17 store3 fsr[10917]: XFS_IOC_SWAPEXT failed: ino=797728: Invalid argument

Which means the kernel caught a condition where the extent swap
could not be done due to differences in the layout of the two
inodes. If we do the swap we corrupt the filesystem, so we abort
and return an error instead.

http://permalink.gmane.org/gmane.comp.file-systems.xfs.general/40013
http://www.spinics.net/lists/xfs/msg09736.html

> Is this a known problem with xfs in this kernel? Any other
> information/tests that I can supply?

No problems with the kernel. Deficiencies are on the userspace side
with how xfs_fsr is setting up the attribute fork on the donor
inode. The event tracing indicated in the second link above will
tell us what the incomaptibility is and maybe how to improve xfs_fsr
t0 avoid it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
