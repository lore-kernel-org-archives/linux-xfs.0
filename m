Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q85CMijU044486 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 07:22:44 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GT6iYikn4raURAe6 for
	<xfs@oss.sgi.com>; Wed, 05 Sep 2012 05:23:43 -0700 (PDT)
Message-ID: <504743F6.8040606@redhat.com>
Date: Wed, 05 Sep 2012 08:22:14 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 4/4] xfs: add background scanning to clear EOFBLOCKS
	inodes
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-5-git-send-email-bfoster@redhat.com>
	<20120903052842.GT15292@dastard> <50460BF1.3070100@redhat.com>
	<20120905070011.GI15292@dastard>
In-Reply-To: <20120905070011.GI15292@dastard>
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
Cc: xfs@oss.sgi.com

On 09/05/2012 03:00 AM, Dave Chinner wrote:
> On Tue, Sep 04, 2012 at 10:10:57AM -0400, Brian Foster wrote:
>> On 09/03/2012 01:28 AM, Dave Chinner wrote:
>>> On Mon, Aug 27, 2012 at 03:51:51PM -0400, Brian Foster wrote:
...
>>
>> Any thoughts on having tunables for both values (time and min size?) on
>> the background scanning?
> 
> Well, my suggestion for timing is as per above (xfs_syncd_centisecs
> * 100), but I don't really have any good rule of thumb for the
> minimum size. What threshold do people start to notice this?
> 

For the testing I've done so far, I'm hitting EDQUOT with 20-30GB of
space left while sequentially writing to many large files. I'm really
just trying to get used space before failure more in the ball park of
the limit, so I'm not going to complain too much over leaving a few
hundred MB or so around on an otherwise full quota. ;) From where I sit,
the problem is more when we extend a file by 2, 4, 8GB and consume a
large amount of limited available space.

I suppose for the background scanning, it's more about just using a
value that doesn't get in the way of general behavior/performance. I'll
do some more testing in this area.

> I'd SWAG that something like 32MB is a good size to start at because
> most IO subsystems will still be able to reach full bandwidth with
> extents of this size when reading files.
> 
> Alternatively, if you can determine if the inode is still in use at
> the time of the scan (e.g. elevated reference count due to an open
> fd) and skip the truncation for those inodes, then a minimum size is
> not really needed, right?
> 

Hmm, good idea. Though perhaps I can use the min_size as a force
parameter (i.e., trim anything over this size), and the inode in use
check allows a more conservative default. I'll have to play around with
the right time/size values some more to get a better feel for it. I'll
probably include tunables at least for testing purposes, and they can
always be removed later. Thanks.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
