Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 173727F63
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 10:06:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF5BE304032
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 08:06:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6le3WH3fl4eq1Uu4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 08:06:10 -0800 (PST)
Date: Sun, 8 Feb 2015 11:06:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 07/18] xfs: handle sparse inode chunks in icreate log
	recovery
Message-ID: <20150208160607.GC2927@bfoster.bfoster>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-8-git-send-email-bfoster@redhat.com>
	<20150206231946.GR12722@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150206231946.GR12722@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Feb 07, 2015 at 10:19:46AM +1100, Dave Chinner wrote:
> On Fri, Feb 06, 2015 at 02:52:54PM -0500, Brian Foster wrote:
> > Recovery of icreate transactions assumes hardcoded values for the inode
> > count and chunk length.
> > 
> > Sparse inode chunks are allocated in units of m_ialloc_min_blks. Update
> > the icreate validity checks to allow for appropriately sized inode
> > chunks and verify the inode count matches what is expected based on the
> > extent length rather than assuming a hardcoded count.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_log_recover.c | 19 +++++++++++++------
> >  1 file changed, 13 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index ecc73d5..5a5ee20 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -3068,12 +3068,19 @@ xlog_recover_do_icreate_pass2(
> >  		return -EINVAL;
> >  	}
> >  
> > -	/* existing allocation is fixed value */
> > -	ASSERT(count == mp->m_ialloc_inos);
> > -	ASSERT(length == mp->m_ialloc_blks);
> > -	if (count != mp->m_ialloc_inos ||
> > -	     length != mp->m_ialloc_blks) {
> > -		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count 2");
> > +	/* inode chunk is either full or sparse */
> > +	if (length != mp->m_ialloc_blks &&
> > +	    length != mp->m_ialloc_min_blks) {
> > +		xfs_warn(log->l_mp,
> > +			 "%s: unsupported chunk length", __FUNCTION__);
> > +		return -EINVAL;
> > +	}
> 
> Hmmm - this would prevent recovery of sparse inode chunk allocation
> in multiples of mp->m_ialloc_min_blks, right? Surely we can allow
> any sub-chunk extent size to be allocated as long as alignment and
> size restrictions are met?
> 

Indeed it does prevent recovery of allocations in multiples of
m_ialloc_min_blks, but that is not supported at the moment so this alone
shouldn't cause any problems. The reason for the limitation is the same
general issue of dealing with allocations that may not be guaranteed to
convert directly to valid inode records. In other words, this is the
minimum allocation we can guarantee will span only a single record.

Now that I think about it after doing the whole agbno range thing,
perhaps an 'end_align' allocation argument might be a way to deal with
that one? For example, sparse allocs could request a cluster aligned
start bno and a chunk aligned end bno..? That might require multiple
sparse alloc attempts to take full advantage, probably requires more
thought either way...

Also note that for all fs' that this feature supports (i.e., v5), the
next multiple of the m_ialloc_min_blks corresponds to a full chunk (due
to the cluster size scaling). Given all of that, I'd at least prefer to
defer more advanced allocation support from this initial series as an
enhancement (provided there's value).

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
