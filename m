Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Oct 2006 22:27:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9B5QraG015227
	for <xfs@oss.sgi.com>; Tue, 10 Oct 2006 22:26:55 -0700
Date: Wed, 11 Oct 2006 15:25:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Data type overflow in xfs_trans_unreserve_and_mod_sb
Message-ID: <20061011052557.GM19345@melbourne.sgi.com>
References: <55EF1E5D5804A542A6CA37E446DDC206655888@mapibe17.exchange.xchg> <45179573.3020007@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45179573.3020007@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: sandeen@sandeen.net, xfs@oss.sgi.com, Timothy Shimmin <tes@sgi.com>

On Mon, Sep 25, 2006 at 02:08:11PM +0530, Shailendra Tripathi wrote:
> Hi David,
>           As part of fixing xfs_reserve_blocks issue, you might want to 
> fix an issue in xfs_trans_unreserve_and_mod_sb as well. Since, I am on 
> much older version, my patch is not applicable on newer trees. However, 
> the patch is attached for your reference.
> 
> The problem is as below:
> 
> Superblock modifications required during transaction are stored in delta 
> fields in transaction. These fields are applied to the superblock when 
> transaction commits.
> 
> The in-core superblock changes are done in 
> xfs_trans_unreserve_and_mod_sb. It calls xfs_mod_incore_sb_batch 
> function to apply the changes. This function tries to apply the deltas 
> and if it fails for any reason, it backs out all the changes. One 
> typical modification done is like that:
> 
>         case XFS_SBS_DBLOCKS:
>                 lcounter = (long long)mp->m_sb.sb_dblocks;
>                 lcounter += delta;
>                 if (lcounter < 0) {
>                         ASSERT(0);
>                         return (XFS_ERROR(EINVAL));
>                 }
>                 mp->m_sb.sb_dblocks = lcounter;
>                 return (0);
> 
> So, when it returns EINVAL, the second part of the code backs out the 
> changes made to superblock. However, the worst part is that 
> xfs_trans_unreserve_and_mod_sb does not return any error value.

That's because the error checking is supposed to occur before you
commit the transaction e.g. during xfs_trans_mod_sb() that
calculates the deltas. In which case:

        case XFS_TRANS_SB_DBLOCKS:
                ASSERT(delta > 0);
                tp->t_dblocks_delta += delta;
                break;

You should assert fail there is the delta is less than zero.  To me, it is
obvious these ASSERTS were placed long ago to be a landmine for someone to trip
over when thea deltas start to overflow.  Far-sighted, self documenting code -
just the way it should be ;)

So, looking a little deeper:

void
xfs_trans_mod_sb(
        xfs_trans_t     *tp,
        uint            field,
        long            delta)

This function can't take more than 31 bits of delta on a 32 bit machine
so your patch only fixed the problem on 64 bit platforms. Given that we can
support 16TB filesystems on 32 bit platforms, they need to be fixed in
some way here as well.

Also, the transaction delta fields are all longs - they overflow in the same
manner.

Eric, you suggested specific 64 bit types - I think that's really the
way to fix this, but it's a much bigger change...

Cheers,

Dave. 
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
