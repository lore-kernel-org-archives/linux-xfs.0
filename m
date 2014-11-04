Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 526377FA3
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 15:39:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E7418F8035
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 13:39:07 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tzuUMj63uDg9C3Va for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 13:39:06 -0800 (PST)
Date: Wed, 5 Nov 2014 08:39:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: track bulkstat progress by agino
Message-ID: <20141104213903.GD28565@dastard>
References: <1415105601-6455-1-git-send-email-david@fromorbit.com>
	<1415105601-6455-7-git-send-email-david@fromorbit.com>
	<20141104190006.GH55611@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141104190006.GH55611@bfoster.bfoster>
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

On Tue, Nov 04, 2014 at 02:00:06PM -0500, Brian Foster wrote:
> On Tue, Nov 04, 2014 at 11:53:21PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The bulkstat main loop progress is tracked by the "lastino"
> > variable, which is a full 64 bit inode. However, the loop actually
> > works on agno/agino pairs, and so there's a significant disconnect
> > between the rest of the loop and the main cursor. Convert this to
> > use the agino, and pass the agino into the chunk formatting function
> > and convert it too.
> > 
> > This gets rid of the inconsistency in the loop processing, and
> > finally makes it simple for us to skip inodes at any point in the
> > loop simply by incrementing the agino cursor.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_itable.c | 50 +++++++++++++++++++-------------------------------
> >  1 file changed, 19 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index 6a4ef8e..2a6f2e8 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -282,45 +282,39 @@ xfs_bulkstat_ag_ichunk(
> >  	bulkstat_one_pf			formatter,
> >  	size_t				statstruct_size,
> >  	struct xfs_bulkstat_agichunk	*acp,
> > -	xfs_ino_t			*lastino)
> > +	xfs_agino_t			*last_agino)
> >  {
> >  	char				__user **ubufp = acp->ac_ubuffer;
> >  	int				chunkidx;
> >  	int				error = 0;
> > -	xfs_agino_t			agino;
> >  
> > -	agino = irbp->ir_startino;
> > +	*last_agino = irbp->ir_startino;
> 
> Shouldn't last_agino refer to the last inode written out to the
> userspace buffer? I'm not familiar with the semantics that xfsdump
> expects or works around here as you've discussed in the commit logs and
> whatnot. What happens if we set last_agino here and error out in the
> first iteration of the loop?

lastino is supposed to represent the last inode scanned, not
necessarily the last inode formatted into the buffer. This can be
seen that we update lastino even if the inode if free - it hasn't
been written into the user buffer, but we have processed it.

> 
> >  	for (chunkidx = 0; chunkidx < XFS_INODES_PER_CHUNK;
> > -	     chunkidx++, agino++) {
> > +	     chunkidx++, (*last_agino)++) {
> 
> Similar question here when we handle a full record and increment
> *last_agino beyond the last agino in the record. Unless I'm missing
> something, it looks to me that if the next record is adjacent,
> xfs_bulkstat_grab_ichunk() would skip the first inode in that record.

Hmmm - yes, that could occur. I have another patch that I didn't
post that changes the xfs_bulkstat_grab_ichunk() to not skip the
incoming lastino value, but I reasoned that it was a change of
behaviour and hence could cause xfsdump to break.

I'll rework *last_agino to do post-update rather than pre-update.

> >  	 * Done, we're either out of filesystem or space to put the data.
> > @@ -518,16 +509,13 @@ del_cursor:
> >  	if (ac.ac_ubelem)
> >  		error = 0;
> >  
> > -	if (agno >= mp->m_sb.sb_agcount) {
> > -		/*
> > -		 * If we ran out of filesystem, mark lastino as off
> > -		 * the end of the filesystem, so the next call
> > -		 * will return immediately.
> > -		 */
> > -		*lastinop = (xfs_ino_t)XFS_AGINO_TO_INO(mp, agno, 0);
> > +	/*
> > +	 * If we ran out of filesystem, lastino will point off the end of
> > +	 * the filesystem so the next call will return immediately.
> > +	 */
> > +	*lastinop = XFS_AGINO_TO_INO(mp, agno, agino);
> 
> This means that the main loop should never move agino forward unless the
> inodes up through agino are guaranteed to be copied out to the user
> buffer. There are two places in the main loop where we do this:
> 
> 	agino = r.ir_startino + XFS_INODES_PER_CHUNK;
> 
> ... and both of those lines execute before a potential error path that
> breaks out of the main loop before that current record is formatted out.
> Those lines appear to be spurious at this point, however, so I suspect
> we can just kill them.

*nod*

I was in two minds about that, but then figured agino would be
overwritten by the formatting callout if there was no error. I
didn't consider the error breakout case, so yes, those updates need
to die...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
