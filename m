Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q85NgRtu161940 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 18:42:27 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	j6pFH2Rtbx0DpX5v for <xfs@oss.sgi.com>;
	Wed, 05 Sep 2012 16:43:25 -0700 (PDT)
Date: Thu, 6 Sep 2012 09:43:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 4/4] xfs: add background scanning to clear EOFBLOCKS
	inodes
Message-ID: <20120905234323.GL15292@dastard>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-5-git-send-email-bfoster@redhat.com>
	<20120903052842.GT15292@dastard> <50460BF1.3070100@redhat.com>
	<20120905070011.GI15292@dastard> <504743F6.8040606@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <504743F6.8040606@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 05, 2012 at 08:22:14AM -0400, Brian Foster wrote:
> On 09/05/2012 03:00 AM, Dave Chinner wrote:
> > On Tue, Sep 04, 2012 at 10:10:57AM -0400, Brian Foster wrote:
> >> On 09/03/2012 01:28 AM, Dave Chinner wrote:
> >>> On Mon, Aug 27, 2012 at 03:51:51PM -0400, Brian Foster wrote:
> ...
> >>
> >> Any thoughts on having tunables for both values (time and min size?) on
> >> the background scanning?
> > 
> > Well, my suggestion for timing is as per above (xfs_syncd_centisecs
> > * 100), but I don't really have any good rule of thumb for the
> > minimum size. What threshold do people start to notice this?
> > 
> 
> For the testing I've done so far, I'm hitting EDQUOT with 20-30GB of
> space left while sequentially writing to many large files.

Sure, background scanning won't prevent that, though. The background
scan is to catch preallocation that is no longer needed. i.e. the
files are no longer being written and have no dirty date but due
to the access nature, xfs_release() didn't free the unused
preallocation. The background scan will clean that up faster than
waiting for the inodes to cycle through the cache....

> I'm really
> just trying to get used space before failure more in the ball park of
> the limit,

That's what prealloc size throttling is for. ;)

> so I'm not going to complain too much over leaving a few
> hundred MB or so around on an otherwise full quota. ;) From where I sit,
> the problem is more when we extend a file by 2, 4, 8GB and consume a
> large amount of limited available space.
> 
> I suppose for the background scanning, it's more about just using a
> value that doesn't get in the way of general behavior/performance. I'll
> do some more testing in this area.

Right.

> > I'd SWAG that something like 32MB is a good size to start at because
> > most IO subsystems will still be able to reach full bandwidth with
> > extents of this size when reading files.
> > 
> > Alternatively, if you can determine if the inode is still in use at
> > the time of the scan (e.g. elevated reference count due to an open
> > fd) and skip the truncation for those inodes, then a minimum size is
> > not really needed, right?
> > 
> 
> Hmm, good idea. Though perhaps I can use the min_size as a force
> parameter (i.e., trim anything over this size),

If it's a background scan, we don't want to trim active
preallocations.

> and the inode in use
> check allows a more conservative default.

I just thought of a better check than an in-use check - if the inode
has a dirty page cache, don't trim it as the speculative prealloc is
still useful. If the inode is clean, it has not recently been written
to so we can remove the speculative prealloc and we are unlikely to
suffer any penalty from doing so....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
