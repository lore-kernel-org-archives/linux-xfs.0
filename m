Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33E677CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 20:29:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1CEC8304053
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 18:29:31 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hEhlpaxL7Cer9BvK for <xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 18:29:29 -0800 (PST)
Date: Wed, 27 Feb 2013 13:29:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re:
	[BUG] Internal error xfs_dir2_data_reada_verify)
Message-ID: <20130227022927.GA5551@dastard>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard> <87y5eah4xz.fsf@fftw.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87y5eah4xz.fsf@fftw.org>
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

On Tue, Feb 26, 2013 at 09:21:44PM -0500, Matteo Frigo wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Wed, Feb 27, 2013 at 01:04:14AM +0000, Alasdair G Kergon wrote:
> >> (Quick pointers that might be relevant)
> >> 
> >> EAGAIN, I'm not aware of dm itself returning that on the i/o path.
> >
> > Neither am I, but it's coming from somewhere in the IO path...
> 
> Well, I don't really know anything about this topic, so I may be
> completely off the mark, but dm-raid1.c:mirror_map() does indeed return
> EWOULDBLOCK, and EWOULDBLOCK is #define'd to be EAGAIN, so it seems to
> me that dm-raid1 does indeed return EAGAIN for "rw == READA" (which I
> assume is read-ahead) if the "region is not in-sync":
> 
> 	/*
> 	 * If region is not in-sync queue the bio.
> 	 */
> 	if (!r || (r == -EWOULDBLOCK)) {
> 		if (rw == READA)
> 			return -EWOULDBLOCK;
> 
> 		queue_bio(ms, bio, rw);
> 		return DM_MAPIO_SUBMITTED;
> 	}

Trees, forest....

Thanks for pointing out the obvious, Matteo. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
