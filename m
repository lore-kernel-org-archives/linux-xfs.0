Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C4CF77F51
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 19:11:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ACBBF8F804C
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 17:11:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bd7bEwCCZTtO5R3H for <xfs@oss.sgi.com>;
	Mon, 28 Jul 2014 17:11:22 -0700 (PDT)
Date: Tue, 29 Jul 2014 10:07:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/18] xfs: create helper to manage record overlap for
	sparse inode chunks
Message-ID: <20140729000733.GG26465@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-9-git-send-email-bfoster@redhat.com>
	<20140724224112.GR20518@dastard>
	<20140728161925.GD59542@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140728161925.GD59542@bfoster.bfoster>
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

On Mon, Jul 28, 2014 at 12:19:25PM -0400, Brian Foster wrote:
> On Fri, Jul 25, 2014 at 08:41:12AM +1000, Dave Chinner wrote:
> > On Thu, Jul 24, 2014 at 10:22:58AM -0400, Brian Foster wrote:
> > > +	struct xfs_btree_cur		*cur;
> > > +	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
> > > +	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
> > > +	xfs_agino_t			previno;
> > > +	int				error;
> > > +	int				i;
> > > +	struct xfs_inobt_rec_incore	rec;
> > > +
> > > +	orec->ir_startino = NULLAGINO;
> > > +
> > > +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
> > > +
> > > +	previno = newino + count - XFS_INODES_PER_CHUNK;
> > > +	error = xfs_inobt_lookup(cur, previno, XFS_LOOKUP_GE, &i);
> > 
> > You want XFS_LOOKUP_EQ, yes? i.e. XFS_LOOKUP_GE won't fail if the
> > exact record for the inode chunk does not exist - it will return the
> > next one in the btree.
> > 
> 
> Assuming variable sparse chunk granularity,

Isn't the granularity fixed for the specific filesystem
configuration as part of the on-disk format?

> I don't really know the
> start ino of the record that potentially covers the new inode chunk.
> Given that, we use the smallest possible start ino that could include
> this chunk and search forward from there. As you've noted below, I
> wasn't relying on failure here to detect the scenario where there is no
> existing record.

Ok, that's not how I thought the code was attempting to implement
the "has record" check. My mistake - a comment explaining how the
match is supposed to work would be helpful, I think.

However, with that in mind, why do you even bother calculating at
"previno"?  If you want the chunk that the "newino" lies in, then
by definition it's going to be the first record at an equal or
lower start inode number than newino.  i.e.:

	xfs_inobt_lookup(cur, newino, XFS_LOOKUP_LE, &i);

Will return either:

	- a match with startino <= newino < startino + XFS_INODES_PER_CHUNK
	- a match with startino + XFS_INODES_PER_CHUNK <= newino
	- a failure due to no record.

i.e. the first case is the chunk record we want, the others are
"does not exist" failures. We don't need to calculate the "previno"
at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
