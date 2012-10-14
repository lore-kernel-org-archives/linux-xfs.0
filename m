Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9E04ZLm029432 for <xfs@oss.sgi.com>; Sat, 13 Oct 2012 19:04:35 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UACojdKOqppLKh5E for
	<xfs@oss.sgi.com>; Sat, 13 Oct 2012 17:06:09 -0700 (PDT)
Message-ID: <507A01DF.1070105@redhat.com>
Date: Sat, 13 Oct 2012 19:05:51 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_quota: XFS_XFLAG_PROJINHERIT is only for dirs
References: <5078432B.6050501@redhat.com>
	<20121013155205.GA11037@infradead.org>
	<20121013233431.GQ2739@dastard>
In-Reply-To: <20121013233431.GQ2739@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, nscott@redhat.com, xfs-oss <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>

On 10/13/12 6:34 PM, Dave Chinner wrote:
> On Sat, Oct 13, 2012 at 11:52:05AM -0400, Christoph Hellwig wrote:
>> On Fri, Oct 12, 2012 at 11:19:55AM -0500, Eric Sandeen wrote:
>>> xfs_quota has long set XFS_XFLAG_PROJINHERIT on all files,
>>> and tested for presence on all files.  However, Dave's semi-recent
>>> xfs_repair update is now flagging this as an error:
>>
>> I think we should rever that part of the repair patch.  While there
>> really is not point to have XFS_XFLAG_PROJINHERIT set on non-directory
>> files we have been setting it for year, so repair should cope with that.
> 
> Repair does cope with it - it issues a warning and clears the flag.
> It doesn't stop, it simply fixes an inconsistency in the inode flags.
> 
> The main problem, by the sounds of it, is that repair issues a
> warning that it is clearing the flags that should not be set. This
> is what makes check_scratch_fs fail because of the extra output.
> That's easy to fix - filter the line from the repair output and be
> done with it. In future (with Eric's patch) this situation won't
> occur.
> 
> So, really, I think the only thing that needs modifying to handle
> this situation is a filter update to xfstests...

I must be missing something; quota will continue to set it and repair
will continue to clear it.  One should probably match the other right?
So one or the other should change.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
