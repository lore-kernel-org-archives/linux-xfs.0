Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F30B7F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 19:11:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 371528F8035
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 17:11:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GzIPl3euVcv9c1SB for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 17:11:24 -0700 (PDT)
Date: Fri, 6 Sep 2013 10:11:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 04/11] xfs: update inode allocation transaction
	reservations for finobt
Message-ID: <20130906001122.GP12779@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-5-git-send-email-bfoster@redhat.com>
	<20130905005946.GR23571@dastard> <5228AE93.2050001@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5228AE93.2050001@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 05, 2013 at 12:17:23PM -0400, Brian Foster wrote:
> On 09/04/2013 08:59 PM, Dave Chinner wrote:
> > On Tue, Sep 03, 2013 at 02:25:01PM -0400, Brian Foster wrote:
> >> Update inode allocation transaction reservations for the finobt. A
> >> create via record modification requires a log reservation for the
> >> additional finobt record. Any such allocation could result in an
> >> finobt removal if the inode chunk has become fully allocated, thus
> >> we include a reservation for a finobt btree merge as well.
> >> Allocation of a new inode chunk must account for splits in the
> >> finobt as well as the existing ialloc tree.
> > 
> > These transaction reservation changes are only necessary for
> > filesystems with free inode btrees, otherwise they just use more log
> > space than is necessary.
> > 
> 
> Yeah, good point.
> 
> > Can you add helper functions for the free inode btree reservations,
> > and have them return 0 when the feature is not enabled? That way the
> > code stays pretty clean, is self documenting and doesn't take
> > unnecessary space when the feature is not enabled....
> > 
> 
> So not new functions that duplicate the entire calculations for the
> finobt enabled cases, but new functions that define the additional
> requirements for the finobt on top of the existing reservation
> calculations for particular operations (i.e., similar to the recent
> patch to fix the inode log size, if I recall). Sounds good.

That's exactly what I'm thinking - just like the
xfs_calc_inode_res() helper. This really helps document the
transaction reservation calculations - the comments help, but they
are no substitute for being able to say "*that line* is what
reserves space for the inodes modified in the transaction"...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
