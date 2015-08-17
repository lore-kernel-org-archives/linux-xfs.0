Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 530847F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 15:45:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4315B8F8040
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 13:45:52 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id cuKSmI9Op1Zip6rH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 13:45:50 -0700 (PDT)
Date: Mon, 17 Aug 2015 13:45:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/10] xfs_db: don't crash on a corrupt inode
Message-ID: <20150817204546.GN10043@birch.djwong.org>
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
	<20150815014351.1839.81382.stgit@birch.djwong.org>
	<55D22D62.9060806@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55D22D62.9060806@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <djwong@alder.djwong.org>, xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 01:52:18PM -0500, Eric Sandeen wrote:
> On 8/14/15 8:43 PM, Darrick J. Wong wrote:
> > If the user selects a corrupt inode via the 'inode XXX' command, the
> > read verifier will fail and the io cursor at the top of the ring will
> > not have any data attached.  When this is the case, we cannot
> > dereference the NULL pointer or xfs_db will crash.  Therefore, check
> > the buffer pointer before using it.
> > 
> > It's arguable that we ought to retry the read without the verifiers
> > if the inode is corrupt or fails CRC, since this /is/ a debugging
> > tool, and maybe you wanted the contents anyway.
> 
> I agree.  It seems like we should do that, though it probably needs to
> be done across the board for all metadata types if it's going to be done.
> Maybe something to add to the TODO?

Hmm.  Looks like set_cur() wants to return buffer contents in the verifier
error case, except that the broken xfs_buf->b_error sign handling prevents
it from doing that... and the sign handling error is fixed later on in the
patch set.

So... that leaves hard IO errors, for which we still need this patch.

--D

> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/inode.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > 
> > diff --git a/db/inode.c b/db/inode.c
> > index e86dabd..64b263b 100644
> > --- a/db/inode.c
> > +++ b/db/inode.c
> > @@ -682,6 +682,8 @@ set_cur_inode(
> >  	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, cluster_agbno),
> >  		numblks, DB_RING_IGN, NULL);
> >  	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
> 
> off_cur checks for iocur_top == NULL, and warns if it is, so that's good.
> The user should have a clue about what's gone wrong, at least.
> 
> But, callers of set_cur_inode() are still going to crash often as not:
> 
> ablock_f:
>         set_cur_inode(iocur_top->ino);
>         haveattr = XFS_DFORK_Q((xfs_dinode_t *)iocur_top->data);
> 
> bmap:
> 
>         set_cur_inode(iocur_top->ino);
>         nex = *nexp;
>         *nexp = 0;
>         ASSERT(nex > 0);
>         dip = iocur_top->data;
> 
> bmap_f:
> 
>                 set_cur_inode(iocur_top->ino);
>                 dip = iocur_top->data;
> 
> and a few more :(
> 
> Perhaps set_cur_inode() should return failure, so the caller knows to bail,
> pop_cur if it needs to, etc?
> 
> -Eric
> 
> > +	if (!iocur_top->data)
> > +		return;
> >  	dip = iocur_top->data;
> >  	iocur_top->ino_buf = 1;
> >  	iocur_top->ino = ino;
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
