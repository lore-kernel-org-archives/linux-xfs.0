Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D6AB7F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 18:48:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E68A8F8035
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 16:48:22 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id UAvNVpYNoxcSVkJu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 16:48:18 -0700 (PDT)
Date: Mon, 17 Aug 2015 16:48:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/10] xfs_repair: force not-so-bad bmbt blocks back
	through the verifier
Message-ID: <20150817234814.GP10043@birch.djwong.org>
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
	<20150815014410.1839.33268.stgit@birch.djwong.org>
	<55D24EB3.2040506@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55D24EB3.2040506@sandeen.net>
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

On Mon, Aug 17, 2015 at 04:14:27PM -0500, Eric Sandeen wrote:
> On 8/14/15 8:44 PM, Darrick J. Wong wrote:
> > If during prefetch we encounter a bmbt block that fails the CRC check
> > due to corruption in the unused part of the block, force the buffer
> > back through the non-prefetch verifiers later so that the CRC is
> > updated.  Otherwise, the bad checksum goes unfixed and the kernel will
> > still flag the bmbt block as invalid.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/prefetch.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > 
> > diff --git a/repair/prefetch.c b/repair/prefetch.c
> > index 8b261ae..fc7097f 100644
> > --- a/repair/prefetch.c
> > +++ b/repair/prefetch.c
> > @@ -276,6 +276,14 @@ pf_scan_lbtree(
> >  
> >  	XFS_BUF_SET_PRIORITY(bp, isadir ? B_DIR_BMAP : B_BMAP);
> >  
> > +	/*
> > +	 * Make this bmbt buffer go back through the verifiers later so that
> > +	 * we correct checksum errors stemming from bitflips in the unused
> > +	 * parts of the bmbt block.
> > +	 */
> > +	if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED)
> > +		bp->b_flags |= LIBXFS_B_UNCHECKED;
> 
> Hm, so why check EFSCORRUPTED?  If you're doing what the comment says, why
> not just EFSBADCRC?  EFSCORRUPTED means that in-use portions are bad, no?

You're right, I only need to hook onto EFSBADCRC.  I probably got too used
to seeing checks for both everywhere. 8)

--D

> 
> -Eric
> 
> > +
> >  	rc = (*func)(XFS_BUF_TO_BLOCK(bp), level - 1, isadir, args);
> >  
> >  	libxfs_putbuf(bp);
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
