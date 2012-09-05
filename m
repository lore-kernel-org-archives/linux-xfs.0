Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q856xFrZ259846 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 01:59:15 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rCWWjbQwMd1tGeaD for <xfs@oss.sgi.com>;
	Wed, 05 Sep 2012 00:00:13 -0700 (PDT)
Date: Wed, 5 Sep 2012 17:00:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 4/4] xfs: add background scanning to clear EOFBLOCKS
	inodes
Message-ID: <20120905070011.GI15292@dastard>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-5-git-send-email-bfoster@redhat.com>
	<20120903052842.GT15292@dastard> <50460BF1.3070100@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50460BF1.3070100@redhat.com>
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

On Tue, Sep 04, 2012 at 10:10:57AM -0400, Brian Foster wrote:
> On 09/03/2012 01:28 AM, Dave Chinner wrote:
> > On Mon, Aug 27, 2012 at 03:51:51PM -0400, Brian Foster wrote:
> >> Create a delayed_work to enable background scanning and freeing
> >> of EOFBLOCKS inodes. The scanner kicks in once speculative
> >> preallocation occurs and stops requeueing itself when no EOFBLOCKS
> >> inodes exist.
> >>
> >> Scans are queued on the existing syncd workqueue and the interval
> >> is tied to the syncd interval, which is a default of 30s. The
> >> minimum file size for a background scan is hardcoded to 100MB.
> > 
> > I'd set it to be much longer than the xfs_syncd_centisecs period.
> > The data may not be written back for a long while, and a file that
> > is open, written and closed repeatedly (NFS write patterns for large
> > and/or slowly written files) should not have it's preallocation
> > truncated every 30s.
> > 
> > I'd suggest that a 5 minute sweep is probably sufficiently frequent
> > to avoid most fragmentation issues and long term buildup of speculative
> > preallocation whilst not perturbing large/slow writers too much....
> > 
> 
> Any thoughts on having tunables for both values (time and min size?) on
> the background scanning?

Well, my suggestion for timing is as per above (xfs_syncd_centisecs
* 100), but I don't really have any good rule of thumb for the
minimum size. What threshold do people start to notice this?

I'd SWAG that something like 32MB is a good size to start at because
most IO subsystems will still be able to reach full bandwidth with
extents of this size when reading files.

Alternatively, if you can determine if the inode is still in use at
the time of the scan (e.g. elevated reference count due to an open
fd) and skip the truncation for those inodes, then a minimum size is
not really needed, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
