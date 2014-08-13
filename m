Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6BA967F3F
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 05:43:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3163B304043
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 03:43:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0U13QX5PIkJaRezC for <xfs@oss.sgi.com>;
	Wed, 13 Aug 2014 03:42:58 -0700 (PDT)
Date: Wed, 13 Aug 2014 20:42:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File System Corruption - Internal error xfs_dir3_data_reada_verify
Message-ID: <20140813104255.GO26465@dastard>
References: <53EB3302.1090000@tbi.univie.ac.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53EB3302.1090000@tbi.univie.ac.at>
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
To: Richard Neuboeck <hawk@tbi.univie.ac.at>
Cc: xfs@oss.sgi.com

On Wed, Aug 13, 2014 at 11:42:26AM +0200, Richard Neuboeck wrote:
> Hi,
> 
> for some time now our storage machine using XFS stops the file
> system due to some reason I don't seem to have found so far. In this
> process the file system gets corrupted and the attached trace log is
> shown.

What's the workload the VM runs?

> After xfs_repair is run it's running again for an always
> changing amount of time. 

What errors does xfs_repair correct? Can you post the output of a
repair run that corrects the issue.

> In general it fails within a few hours or
> days. There are no relevant log messages before the entries shown
> below and no immediate actions that lead to this condition. So far
> my experiments (Ubuntu upgrade from 10.04 to 14.04, different kernel
> versions, changes to the hypervisor) didn't show any lasting effects
> (positive or negative). If any one could shed some light on what XFS
> is trying to tell me it would be highly appreciated.

The directory is trying to read a block of data that does not
contain directory data. i.e. the directory has somehow been
corrupted. The block contains file data, but that's about all
I can tell you right now.

> I've found the mention of 'xfs_dir3_data_reada_verify' in the
> mailing list but didn't find a solution that was applicable.

It's just checking the block read from disk.

However, that's not the only error that is occurring:

> [ 5247.327164] XFS (vdb): metadata I/O error: block 0x160003e488 ("xfs_trans_read_buf_map") error 117 numblks 8
> [ 5252.482540] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0088485

There are corrupted free space btrees. In this case, the by-bno tree
has been found to be inconsistent. So there's something corrupting
more than just the directory.

SO, more information needed. Lets start with:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

and the output of xfs_repair. Also, a metadump image of the
filesystem before you run repair would be helpful. And finally, the
configuration of the block devices the VM is using (i.e. virtio,
cache=?, etc). Describing the physical storage the VM is using might
also be helpful - it could be host based corruption, not guest based
corruption that is occurring...

Cheers,

Dave.

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
