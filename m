Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D08D7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:59:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3997B304039
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:59:19 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id u5X0p0HyUtWc6ujl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:59:17 -0700 (PDT)
Date: Tue, 25 Aug 2015 17:59:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/11] xfs_repair: check v5 filesystem attr block header
	sanity
Message-ID: <20150826005911.GA23656@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
	<20150826003259.23973.34038.stgit@birch.djwong.org>
	<20150826004502.GR714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150826004502.GR714@dastard>
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

On Wed, Aug 26, 2015 at 10:45:02AM +1000, Dave Chinner wrote:
> On Tue, Aug 25, 2015 at 05:32:59PM -0700, Darrick J. Wong wrote:
> > Check the v5 fields (uuid, blocknr, owner) of attribute blocks for
> > obvious errors while scanning xattr blocks.  If the ownership info
> > is incorrect, kill the block.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Why hasn't the buffer verifier done this validation?

Maybe I'm confused here, so here's what I think is going on:

AFAICT most of the verifiers do things like this:

if (crcs_enabled && cksum_verification fails) {
	xfs_buf_ioerror(bp, -EFSBADCRC);
} else if (header_is_insane) {
	xfs_buf_ioerror(bp, -EFSCORRUPTED);
}

The fuzzer corrupts the UUID without updating the CRC.  The verifier first
checks the CRC and it doesn't match, so it sets b_error to -EFSBADCRC and
doesn't get to the header check.  Then the verifier returns, so we end up back
in process_longform_attr.  Where do we set -EFSCORRUPTED when the CRC also
doesn't match?

--D

> 
> > @@ -1564,6 +1602,13 @@ process_longform_attr(
> >  	if (bp->b_error == -EFSBADCRC)
> >  		(*repair)++;
> >  
> > +	/* is this block sane? */
> > +	if (__check_attr_header(mp, bp, ino)) {
> > +		*repair = 0;
> > +		libxfs_putbuf(bp);
> > +		return 1;
> > +	}
> 
> As you can see the above hunk has a bad CRC check from the verifier,
> and if the attr header is wrong then the verifier should be setting
> bp->b_error == -EFSCORRUPTED.
> 
> So shouldn't this simply be:
> 
> +	if (bp->b_error == -EFSCORRUPTED) {
> +		*repair = 0;
> +		libxfs_putbuf(bp);
> +		return 1;
> +	}
> +
> 
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
