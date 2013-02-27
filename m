Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E5FD7F67
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 17:20:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E11A38F8049
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 15:20:53 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Ywt8VDNab3SekJcF for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 15:20:52 -0800 (PST)
Date: Thu, 28 Feb 2013 10:20:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/9] xfs: add CRC checks to the AGFL
Message-ID: <20130227232045.GE5551@dastard>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
	<1358774760-21841-5-git-send-email-david@fromorbit.com>
	<20130227223750.GZ22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130227223750.GZ22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 27, 2013 at 04:37:50PM -0600, Ben Myers wrote:
> Hi Dave,
> 
> On Tue, Jan 22, 2013 at 12:25:55AM +1100, Dave Chinner wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Add CRC checks, location information and a magic number to the AGFL.
> > Previously the AGFL was just a block containing nothing but the
> > free block pointers.  The new AGFL has a real header with the usual
> > boilerplate instead, so that we can verify it's not corrupted and
> > written into the right place.
> > 
> > [dchinner@redhat.com] Added LSN field, reworked significantly to fit
> > into new verifier structure and growfs structure, enabled full
> > verifier functionality now there is a header to verify and we can
> > guarantee an initialised AGFL.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> I have a couple comments below.
.....
> >  	for (i = 0; i < XFS_AGFL_SIZE(mp); i++) {
> > -		if (be32_to_cpu(agfl->agfl_bno[i]) == NULLAGBLOCK ||
> > +		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
> >  		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
> 						   <

No, we are checking for the agbno being out of range here, not in
range.

The previous code (which was ifdef'd out) reflected the fact that
NULLAGBLOCK could not appear in a AGFL (initialised to zero, not
NULLAGBLOCK), For CRC enabled filesystems - where this check is run,
we guarantee that unused entries are initialised to NULLAGBLOCK by
mkfs and growfs, and this change reflects that.

> Any non NULLAGBLOCK should be less than m_sb.sb_agblocks, correct?

xfs_agblock_t is an unsigned value, therefore it has a value of
0xffffffff. be32-to_cpu() also returns an unsigned value.
So, no, is it never less than mp->m_sb.sb_agblocks.

But we don't want to rely on an implicit comparison against
mp->m_sb.sb_agblocks to detect this, and hence we *always* check
explicitly for it being a NULLAGBLOCK.

> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 65c35d5..81d3cc5a 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -1961,6 +1961,13 @@ xlog_recover_do_reg_buffer(
> >  		}
> >  		bp->b_ops = &xfs_agf_buf_ops;
> >  		break;
> > +	case XFS_BLF_AGFL_BUF:
> > +		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_AGFL_MAGIC)) {
> > +			xfs_warn(mp, "Bad AGFL block magic!");
> > +			ASSERT(0);
> > +		}
> > +		bp->b_ops = &xfs_agfl_buf_ops;
> > +		break;
> 
> Your changes for v2 in this section look good.

Actually, the above hunk is broken. The magic number should only be
checked for CRC enabled filesystems. My current code has this check,
though I thought I fixed that long before I reposted this series...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
