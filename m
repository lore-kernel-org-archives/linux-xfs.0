Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF2627FD0
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 16:50:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 86289AC004
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 14:50:04 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZuaN1JFygOZJPmCW for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 14:50:02 -0800 (PST)
Date: Fri, 8 Mar 2013 09:50:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re:
	[BUG] Internal error xfs_dir2_data_reada_verify)
Message-ID: <20130307225001.GW23616@dastard>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard> <87y5eah4xz.fsf@fftw.org>
	<87k3pjs908.fsf@fftw.org> <20130307223140.GU23616@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130307223140.GU23616@dastard>
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
To: Matteo Frigo <athena@fftw.org>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com

On Fri, Mar 08, 2013 at 09:31:40AM +1100, Dave Chinner wrote:
> On Thu, Mar 07, 2013 at 07:13:27AM -0500, Matteo Frigo wrote:
> > Matteo Frigo <athena@fftw.org> writes:
> > 
> > > Well, I don't really know anything about this topic, so I may be
> > > completely off the mark, but dm-raid1.c:mirror_map() does indeed return
> > > EWOULDBLOCK, and EWOULDBLOCK is #define'd to be EAGAIN, so it seems to
> > > me that dm-raid1 does indeed return EAGAIN for "rw == READA" (which I
> > > assume is read-ahead) if the "region is not in-sync":
> > >
> > > 	/*
> > > 	 * If region is not in-sync queue the bio.
> > > 	 */
> > > 	if (!r || (r == -EWOULDBLOCK)) {
> > > 		if (rw == READA)
> > > 			return -EWOULDBLOCK;
> > >
> > > 		queue_bio(ms, bio, rw);
> > > 		return DM_MAPIO_SUBMITTED;
> > > 	}
> > 
> > Dave (and others),
> > 
> > do you have any suggestion on what should be done to fix this bug?
> > 
> > I have tried returning -EIO instead of -EWOULDBLOCK, but xfs does not
> > like that.  dm-zero.c:zero_map() appears to return -EIO too, so this is
> > another potential issue.
> 
> You need the XFS patch I posted so that readahead buffer
> verification is avoided in the case of an error being returned from
> the readahead.

I don't recall if that patch was sent to this thread, so here it is:

http://oss.sgi.com/archives/xfs/2013-02/msg00516.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
