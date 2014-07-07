Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45D2B7F3F
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 14:38:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 18DAB8F8065
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 12:38:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CnGnZcs1lmxaYmAW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 Jul 2014 12:38:32 -0700 (PDT)
Date: Mon, 7 Jul 2014 15:38:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: allow inode allocations in post-growfs disk space
Message-ID: <20140707193827.GF4123@laptop.bfoster>
References: <53B4E1EE.40702@redhat.com> <20140707182108.GD4123@laptop.bfoster>
	<53BAEE75.9010901@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53BAEE75.9010901@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 07, 2014 at 02:01:09PM -0500, Eric Sandeen wrote:
> On 7/7/14, 1:21 PM, Brian Foster wrote:
> > On Wed, Jul 02, 2014 at 11:54:06PM -0500, Eric Sandeen wrote:
> 
> 
> <context added>:
> 
>         /* Calculate how much should be reserved for inodes to meet
>          * the max inode percentage.
>          */
>         if (mp->m_maxicount) {
>                 __uint64_t      icount;
> 
>                 icount = sbp->sb_dblocks * sbp->sb_imax_pct;
>                 do_div(icount, 100);
>                 icount += sbp->sb_agblocks - 1;
> >> @@ -620,10 +625,10 @@ xfs_set_inode32(struct xfs_mount *mp)
> >>  		do_div(icount, sbp->sb_agblocks);
> >>  		max_metadata = icount;
> >>  	} else {
> >> -		max_metadata = sbp->sb_agcount;
> >> +		max_metadata = agcount;
> > 
> > The fix looks pretty good to me, but what about the 'if' branch of this
> > logic here? We calculate max_metadata based on sb_dblocks, which also
> > isn't updated until the growfs tp commit. That appears to be a similar
> > bug in that we wouldn't set pagf_metadata on the new AGs where
> > appropriate, which I think means data allocation could steal the new
> > inode space sooner than anticipated.
> 
> Yeah, good catch...
> 
> Hm, well - not that this is an answer, but this code has been this way
> since 2005.  So I'd like to fix the *regression* w/ my patch as-is,
> and then worry about this.
> 

That's fine by me... for this patch:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> So, on to worrying about this ... ;)
> 
> "max_metadata" seems a little misnamed; inodes can be allocated in higher
> AGs, but "max_metadata" and lower are the 'preferred' AGs for inode
> allocation.
> 

My impression is that it's named after its very specific/local use: the
max ag to set the metadata flag. I don't really like the name either. ;)

> We only carve out enough via pag->pagf_metadata to reserve m_maxicount,
> which (here) is based on the (old) sb_dblocks & sb_imax_pct.
> 
> So yeah, it seems that in the growfs case, we don't mark any *new* AGs as
> "preferred" for inodes, even though with a fixed sb_imax_pct and a larger
> sb_dblocks, we'd need more space to accommodate the imaxpct.
> 
> But reserving higher AGs would be a half-measure at best; they weren't
> preferred before the growfs, so are very likely not wholly available
> after the growfs.
> 
> To really nail this down we'd probably need to see how many inode clusters
> could be created in each AG above the old threshold, and keep advancing AGs
> until we've "preferred" enough.  Bleah.  I hate inode32...
> 

That's true, but then you have to worry about if that space is freed up
and all that...

I was just looking at it from the perspective of using old metadata to
update some of our heuristics while thinking it might be easier to move
this hunk of code and fix both problems at once. I doubt this is
something that reproduces a tangible problem out in the wild much, if
ever, given the circumstances.

My sense is that this heuristic is not really a guarantee. E.g., setting
imaxpct doesn't guarantee one that much space. Somebody could tune that
after the fact even after all "preferred" space has been consumed just
the same, so it's probably not worth doing any kind of fancy inode
allocation tracking to try and make this retroactive or dynamic unless
it proves to be a problem. I suspect this primarily exists for the case
of larger inode32 fs' where we don't want data allocations to eat up
limited inode space right off the bat.

Brian

> -Eric
> 
> 
> 
> > I wonder if this is better moved after the superblock is updated?
> > 
> > Brian
> > 
> >>  	}
> >>  
> >> -	for (index = 0; index < sbp->sb_agcount; index++) {
> >> +	for (index = 0; index < agcount; index++) {
> >>  		ino = XFS_AGINO_TO_INO(mp, index, agino);
> >>  
> >>  		if (ino > XFS_MAXINUMBER_32) {
> >> @@ -648,11 +653,11 @@ xfs_set_inode32(struct xfs_mount *mp)
> >>  }
> >>  
> >>  xfs_agnumber_t
> >> -xfs_set_inode64(struct xfs_mount *mp)
> >> +xfs_set_inode64(struct xfs_mount *mp, xfs_agnumber_t agcount)
> >>  {
> >>  	xfs_agnumber_t index = 0;
> >>  
> >> -	for (index = 0; index < mp->m_sb.sb_agcount; index++) {
> >> +	for (index = 0; index < agcount; index++) {
> >>  		struct xfs_perag	*pag;
> >>  
> >>  		pag = xfs_perag_get(mp, index);
> >> @@ -1193,6 +1198,7 @@ xfs_fs_remount(
> >>  	char			*options)
> >>  {
> >>  	struct xfs_mount	*mp = XFS_M(sb);
> >> +	xfs_sb_t		*sbp = &mp->m_sb;
> >>  	substring_t		args[MAX_OPT_ARGS];
> >>  	char			*p;
> >>  	int			error;
> >> @@ -1212,10 +1218,10 @@ xfs_fs_remount(
> >>  			mp->m_flags &= ~XFS_MOUNT_BARRIER;
> >>  			break;
> >>  		case Opt_inode64:
> >> -			mp->m_maxagi = xfs_set_inode64(mp);
> >> +			mp->m_maxagi = xfs_set_inode64(mp, sbp->sb_agcount);
> >>  			break;
> >>  		case Opt_inode32:
> >> -			mp->m_maxagi = xfs_set_inode32(mp);
> >> +			mp->m_maxagi = xfs_set_inode32(mp, sbp->sb_agcount);
> >>  			break;
> >>  		default:
> >>  			/*
> >> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> >> index bbe3d15..b4cfe21 100644
> >> --- a/fs/xfs/xfs_super.h
> >> +++ b/fs/xfs/xfs_super.h
> >> @@ -76,8 +76,8 @@ extern __uint64_t xfs_max_file_offset(unsigned int);
> >>  
> >>  extern void xfs_flush_inodes(struct xfs_mount *mp);
> >>  extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
> >> -extern xfs_agnumber_t xfs_set_inode32(struct xfs_mount *);
> >> -extern xfs_agnumber_t xfs_set_inode64(struct xfs_mount *);
> >> +extern xfs_agnumber_t xfs_set_inode32(struct xfs_mount *, xfs_agnumber_t agcount);
> >> +extern xfs_agnumber_t xfs_set_inode64(struct xfs_mount *, xfs_agnumber_t agcount);
> >>  
> >>  extern const struct export_operations xfs_export_operations;
> >>  extern const struct xattr_handler *xfs_xattr_handlers[];
> >>
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
