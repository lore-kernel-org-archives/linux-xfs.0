Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Aug 2006 13:04:00 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7SK3eDW021934
	for <linux-xfs@oss.sgi.com>; Mon, 28 Aug 2006 13:03:41 -0700
Received: from e31.co.us.ibm.com ([9.17.249.41])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7SJd40L001230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-xfs@oss.sgi.com>; Mon, 28 Aug 2006 15:39:05 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k7SJcuJ0006472
	for <linux-xfs@oss.sgi.com>; Mon, 28 Aug 2006 15:38:56 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7SJcuRs273120
	for <linux-xfs@oss.sgi.com>; Mon, 28 Aug 2006 13:38:56 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7SJctNq001695
	for <linux-xfs@oss.sgi.com>; Mon, 28 Aug 2006 13:38:55 -0600
Subject: Re: Infinite loop in xfssyncd on full file system
From: Luciano Chavez <lnx1138@us.ibm.com>
In-Reply-To: <20060828072343.GJ807872@melbourne.sgi.com>
References: <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal>
	 <20060823040218.GC807872@melbourne.sgi.com>
	 <20060823044829.GD807872@melbourne.sgi.com>
	 <Pine.LNX.4.64.0608231056370.3139@madrid.max-t.internal>
	 <1156360259.5368.7.camel@localhost>
	 <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal>
	 <20060823040218.GC807872@melbourne.sgi.com>
	 <20060823044829.GD807872@melbourne.sgi.com>
	 <Pine.LNX.4.64.0608231056370.3139@madrid.max-t.internal>
	 <20060823231429.GF807872@melbourne.sgi.com>
	 <20060828072343.GJ807872@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 28 Aug 2006 14:40:30 -0500
Message-Id: <1156794030.5848.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Stephane Doyon <sdoyon@max-t.com>, linux-xfs@oss.sgi.com

On Mon, 2006-08-28 at 17:23 +1000, David Chinner wrote:
> On Thu, Aug 24, 2006 at 09:14:29AM +1000, David Chinner wrote:
> > On Wed, Aug 23, 2006 at 11:00:43AM -0400, Stephane Doyon wrote:
> > > On Wed, 23 Aug 2006, David Chinner wrote:
> > > 
> > > >On Wed, Aug 23, 2006 at 02:02:18PM +1000, David Chinner wrote:
> > > >>On Tue, Aug 22, 2006 at 04:01:10PM -0400, Stephane Doyon wrote:
> > > >>>I'm seeing what appears to be an infinite loop in xfssyncd. It is
> > > >>>triggered when writing to a file system that is full or nearly full. I
> > > >>>have pinpointed the change that introduced this problem: it's
> > > >>>
> > > >>>    "TAKE 947395 - Fixing potential deadlock in space allocation and
> > > >>>    freeing due to ENOSPC"
> > > >>>
> > > >>>git commit d210a28cd851082cec9b282443f8cc0e6fc09830.
> > 
> > .....
> > 
> > > >>Now we know what patch introduces the problem, we know where to look.
> > > >>Stay tuned...
> > > >
> > > >I've had a quick look at the above commit. I'm not yet certain that
> > > >everything is correct in terms of the semantics laid down in the
> > > >change or that enough blocks are reserved for btree splits , but I
> > > 
> > > I actually tried, naively, to bump up SET_ASIDE_BLOCKS from 8 to 32. I 
> > > won't claim to understand half of what's going on but I wondered whether 
> > > that might make the problem noticeably harder to reproduce at least, but 
> > > it had no effect ;-).
> > 
> > That was going to be my next question. ;)
> > 
> > At least that rules out a small error in the block reservation decision,
> > so I'm going to have  analyse all the code paths the mod introduced
> > and work out what is going wrong.
> 
> You know, if you had of buumped it up just a bit higher, the problem might
> have gone away. With a fielsystem that only has 8 AGs in it, if you bumped
> it to 33, then problem would have disappeared....
> 
> What we have here is a small error in the block reservation code. Basically,
> all the logic is correct except for one critical detail - while we need to
> reserve 4 blocks for the AG freelist so a minimum allocation can succeed,
> we need to reserve 4 blocks in _every AG_ so that when every AG is empty
> we will fail with ENOSPC instead of trying to allocate a block when we
> have an AG with less thaan 4 free blocks in it.
> 
> So, it's not 4 blocks filesystem wide we need to reserve, it's 4 blocks per AG
> we need to reserve.
> 
> Stephane and Luciano, can you try the patch attæched below - it fixes the
> 100% repeatable test case (while [ 1 ]; dd to enospc; done) on my test
> machine.
> 

Dave,

The latest patch seems to work for me running bonnie++ on a small 2GB
XFS filesystem. bonnie++ gets an ENOSPC on a write() and ends plus I
don't see the softwatchdog timer dump the kernel stack or xfssyncd
looping. Thanks!

Can you keep me posted when your patch is included in your CVS please? 

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> 
> ---
>  fs/xfs/xfs_mount.c |   18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2006-08-18 15:29:28.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2006-08-28 17:11:18.496258662 +1000
> @@ -1257,10 +1257,11 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fi
>   * all delayed extents need to be actually allocated. To get around
>   * this, we explicitly set aside a few blocks which will not be
>   * reserved in delayed allocation. Considering the minimum number of
> - * needed freelist blocks is 4 fsbs, a potential split of file's bmap
> - * btree requires 1 fsb, so we set the number of set-aside blocks to 8.
> -*/
> -#define SET_ASIDE_BLOCKS 8
> + * needed freelist blocks is 4 fsbs _per AG_, a potential split of file's bmap
> + * btree requires 1 fsb, so we set the number of set-aside blocks
> + * to 4 + 4*agcount.
> + */
> +#define XFS_SET_ASIDE_BLOCKS(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
>  
>  /*
>   * xfs_mod_incore_sb_unlocked() is a utility routine common used to apply
> @@ -1306,7 +1307,8 @@ xfs_mod_incore_sb_unlocked(xfs_mount_t *
>  		return 0;
>  	case XFS_SBS_FDBLOCKS:
>  
> -		lcounter = (long long)mp->m_sb.sb_fdblocks - SET_ASIDE_BLOCKS;
> +		lcounter = (long long)
> +			mp->m_sb.sb_fdblocks - XFS_SET_ASIDE_BLOCKS(mp);
>  		res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
>  
>  		if (delta > 0) {		/* Putting blocks back */
> @@ -1340,7 +1342,7 @@ xfs_mod_incore_sb_unlocked(xfs_mount_t *
>  			}
>  		}
>  
> -		mp->m_sb.sb_fdblocks = lcounter + SET_ASIDE_BLOCKS;
> +		mp->m_sb.sb_fdblocks = lcounter + XFS_SET_ASIDE_BLOCKS(mp);
>  		return 0;
>  	case XFS_SBS_FREXTENTS:
>  		lcounter = (long long)mp->m_sb.sb_frextents;
> @@ -2108,11 +2110,11 @@ again:
>  	case XFS_SBS_FDBLOCKS:
>  		BUG_ON((mp->m_resblks - mp->m_resblks_avail) != 0);
>  
> -		lcounter = icsbp->icsb_fdblocks;
> +		lcounter = icsbp->icsb_fdblocks - XFS_SET_ASIDE_BLOCKS(mp);
>  		lcounter += delta;
>  		if (unlikely(lcounter < 0))
>  			goto slow_path;
> -		icsbp->icsb_fdblocks = lcounter;
> +		icsbp->icsb_fdblocks = lcounter + XFS_SET_ASIDE_BLOCKS(mp);
>  		break;
>  	default:
>  		BUG();
-- 
Luciano Chavez <lnx1138@us.ibm.com>
IBM
