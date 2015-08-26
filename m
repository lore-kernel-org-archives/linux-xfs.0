Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B25807F47
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 01:20:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 18C38AC008
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 23:20:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oyufqSld36cA4QCG for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 23:20:51 -0700 (PDT)
Date: Wed, 26 Aug 2015 16:20:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/11] xfs_repair: check v5 filesystem attr block header
	sanity
Message-ID: <20150826062037.GV714@dastard>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
	<20150826003259.23973.34038.stgit@birch.djwong.org>
	<20150826004502.GR714@dastard>
	<20150826005911.GA23656@birch.djwong.org>
	<20150826011520.GU714@dastard>
	<20150826045043.GY10043@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150826045043.GY10043@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 25, 2015 at 09:50:43PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 26, 2015 at 11:15:20AM +1000, Dave Chinner wrote:
> > On Tue, Aug 25, 2015 at 05:59:11PM -0700, Darrick J. Wong wrote:
> > > On Wed, Aug 26, 2015 at 10:45:02AM +1000, Dave Chinner wrote:
> > > > On Tue, Aug 25, 2015 at 05:32:59PM -0700, Darrick J. Wong wrote:
> > > > > Check the v5 fields (uuid, blocknr, owner) of attribute blocks for
> > > > > obvious errors while scanning xattr blocks.  If the ownership info
> > > > > is incorrect, kill the block.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Why hasn't the buffer verifier done this validation?
> > > 
> > > Maybe I'm confused here, so here's what I think is going on:
> > > 
> > > AFAICT most of the verifiers do things like this:
> > > 
> > > if (crcs_enabled && cksum_verification fails) {
> > > 	xfs_buf_ioerror(bp, -EFSBADCRC);
> > > } else if (header_is_insane) {
> > > 	xfs_buf_ioerror(bp, -EFSCORRUPTED);
> > > }
> > > 
> > > The fuzzer corrupts the UUID without updating the CRC.  The verifier first
> > > checks the CRC and it doesn't match, so it sets b_error to -EFSBADCRC and
> > > doesn't get to the header check. 
> > 
> > Ok, that explains it - I didn't consider that case. This would seem
> > like a general problem for repair when CRC errors are detected? i.e.
> > we set the repair flag without doing the remaining verifier validity
> > checks?
> 
> Heh, this seems like a moderately large refactoring project... :)
> 
> AFAICT, repair is at least checking some of that stuff for bmap,
> directory, and symlink blocks, but as you point out it's scattered all
> over the place.
> 
> It looks like the verifiers can easily check the magic, uuid, and
> block fields; but how would we get the owner info to the verifier?

Make it optional. i.e. if the owner passed in is 0, then don't check
it. That way we can pass in the owner if we have it available,
otherwise we don't check it.

> What if we add a "u64 owner" to xfs_buf and change all functions that
> grab a buffer to take a u64 owner argument?  That'd be rather a lot of
> things to change between the kernel and xfsprogs, but otoh we'd gain
> owner checking and centralize verification of the v5 fields. 

Maybe in the long term, but right now that seems like a lot of churn
for not much gain. I think solving the code duplication problem is
the immediate issue that we need to fix.

> I think
> we'd have to change xfs_trans_{get,read}_buf*() in the kernel and
> libxfs_{get,read}buf*() in xfsprogs.
> 
> Then we'd rework the verifiers as such:
> 
> if (header_is_insane)
> 	xfs_buf_ioerror(bp, -EFSCORRUPTED);
> else if (crcs and crc_fails)
> 	xfs_buf_ioerror(bp, -EFSBADCRC);
>
> Since the header being garbage seems like a much more severe error
> than only the checksum being wrong.  Then we'd always know when the
> v5 fields don't match our expectations.

Except for the fact that the CRC failure tells us the data read from
disk is different to what we wrote, and that's a primary protection
against having to parse corrupt structures in the kernel.

The userspace code is a bit different - bad CRCs are just an
indication that there's a problem that needs fixing and a structure
that needs further validation.

Hence I'd much rather the header validation gets factored and then
run explicitly by the repair code if a bad CRC is detected. That way
the repair code can take action specific to the problem detected,
but we don't compromise the protection the CRCs provide the kernel
code...

> Next we'd change repair to do something like this:
> 
> bp = libxfs_readbuf(...);
> if (!bp) {
> 	/* couldn't get a buffer, abort */
> 	return;
> } else if (bp->b_error == -EFSBADCRC) {
> 	/* just a bad crc; see if the rest of the block is ok */
> 	repair++;
> } else if (bp->b_error) {
> 	/* io error or corrupt header; toss out the owner */
> 	toss_owner();
> 	libxfs_putbuf(bp);
> 	return;
> }
> 

Use a helper function specific to repair:

enum {
	OK,
	TOSS,
	REPAIR,
	ABORT,
};

int
repair_readbuf(... struct xfs_buf **bpp)
{
	bp = libxfs_readbuf(...);
	if (!bp) {
		/* couldn't get a buffer, abort */
		return ABORT;
	}
	if (!bp->error) {
		*bpp = bp;
		return OK;
	}

	if (bp->b_error == -EFSBADCRC) {
		if (verify_header(....)) {
			/* just a bad crc; see if the rest of the block is ok */
			bp->b_error = 0;
			return REPAIR;
		}

	}
	/* io error or corrupt header; toss out the owner */
	libxfs_putbuf(bp);
	return TOSS;
}

Which tells repair exactly what to do ;)


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
