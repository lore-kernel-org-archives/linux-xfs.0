Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 906B57F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 23:50:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2CB5AC005
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 21:50:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id KROM6OcTd0ESHBSz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 21:50:47 -0700 (PDT)
Date: Tue, 25 Aug 2015 21:50:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/11] xfs_repair: check v5 filesystem attr block header
	sanity
Message-ID: <20150826045043.GY10043@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
	<20150826003259.23973.34038.stgit@birch.djwong.org>
	<20150826004502.GR714@dastard>
	<20150826005911.GA23656@birch.djwong.org>
	<20150826011520.GU714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150826011520.GU714@dastard>
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

On Wed, Aug 26, 2015 at 11:15:20AM +1000, Dave Chinner wrote:
> On Tue, Aug 25, 2015 at 05:59:11PM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 26, 2015 at 10:45:02AM +1000, Dave Chinner wrote:
> > > On Tue, Aug 25, 2015 at 05:32:59PM -0700, Darrick J. Wong wrote:
> > > > Check the v5 fields (uuid, blocknr, owner) of attribute blocks for
> > > > obvious errors while scanning xattr blocks.  If the ownership info
> > > > is incorrect, kill the block.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Why hasn't the buffer verifier done this validation?
> > 
> > Maybe I'm confused here, so here's what I think is going on:
> > 
> > AFAICT most of the verifiers do things like this:
> > 
> > if (crcs_enabled && cksum_verification fails) {
> > 	xfs_buf_ioerror(bp, -EFSBADCRC);
> > } else if (header_is_insane) {
> > 	xfs_buf_ioerror(bp, -EFSCORRUPTED);
> > }
> > 
> > The fuzzer corrupts the UUID without updating the CRC.  The verifier first
> > checks the CRC and it doesn't match, so it sets b_error to -EFSBADCRC and
> > doesn't get to the header check. 
> 
> Ok, that explains it - I didn't consider that case. This would seem
> like a general problem for repair when CRC errors are detected? i.e.
> we set the repair flag without doing the remaining verifier validity
> checks?

Heh, this seems like a moderately large refactoring project... :)

AFAICT, repair is at least checking some of that stuff for bmap,
directory, and symlink blocks, but as you point out it's scattered all
over the place.

It looks like the verifiers can easily check the magic, uuid, and
block fields; but how would we get the owner info to the verifier?

What if we add a "u64 owner" to xfs_buf and change all functions that
grab a buffer to take a u64 owner argument?  That'd be rather a lot of
things to change between the kernel and xfsprogs, but otoh we'd gain
owner checking and centralize verification of the v5 fields.  I think
we'd have to change xfs_trans_{get,read}_buf*() in the kernel and
libxfs_{get,read}buf*() in xfsprogs.

Then we'd rework the verifiers as such:

if (header_is_insane)
	xfs_buf_ioerror(bp, -EFSCORRUPTED);
else if (crcs and crc_fails)
	xfs_buf_ioerror(bp, -EFSBADCRC);

Since the header being garbage seems like a much more severe error
than only the checksum being wrong.  Then we'd always know when the
v5 fields don't match our expectations.

Next we'd change repair to do something like this:

bp = libxfs_readbuf(...);
if (!bp) {
	/* couldn't get a buffer, abort */
	return;
} else if (bp->b_error == -EFSBADCRC) {
	/* just a bad crc; see if the rest of the block is ok */
	repair++;
} else if (bp->b_error) {
	/* io error or corrupt header; toss out the owner */
	toss_owner();
	libxfs_putbuf(bp);
	return;
}

/* more checks... */

if (repair)
	libxfs_writebuf(bp);

How's that sound?

--D

> 
> As it is, I don't really like duplicating the verifier checks in
> repair. ISTR I recently suggested that we need to factor all the
> common verifier checks (magic, owner, uuid, blockno) into a single
> function that all verifiers called to remove all the code
> duplication. If we do this, then repair can also call the function
> to verify headers after a CRC failure to determine if repair is
> possible....
> 
> This is a bit more work, so I'll probably take this specific patch
> for 4.2.0, but I'd like to see this all factored out so we aren't
> duplicating code unnecessarily.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
