Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EEF957F3F
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 20:15:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DBC458F8049
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 18:15:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	09tXZBopJeG7cEql for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 18:15:44 -0700 (PDT)
Date: Wed, 26 Aug 2015 11:15:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/11] xfs_repair: check v5 filesystem attr block header
	sanity
Message-ID: <20150826011520.GU714@dastard>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
	<20150826003259.23973.34038.stgit@birch.djwong.org>
	<20150826004502.GR714@dastard>
	<20150826005911.GA23656@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150826005911.GA23656@birch.djwong.org>
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

On Tue, Aug 25, 2015 at 05:59:11PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 26, 2015 at 10:45:02AM +1000, Dave Chinner wrote:
> > On Tue, Aug 25, 2015 at 05:32:59PM -0700, Darrick J. Wong wrote:
> > > Check the v5 fields (uuid, blocknr, owner) of attribute blocks for
> > > obvious errors while scanning xattr blocks.  If the ownership info
> > > is incorrect, kill the block.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Why hasn't the buffer verifier done this validation?
> 
> Maybe I'm confused here, so here's what I think is going on:
> 
> AFAICT most of the verifiers do things like this:
> 
> if (crcs_enabled && cksum_verification fails) {
> 	xfs_buf_ioerror(bp, -EFSBADCRC);
> } else if (header_is_insane) {
> 	xfs_buf_ioerror(bp, -EFSCORRUPTED);
> }
> 
> The fuzzer corrupts the UUID without updating the CRC.  The verifier first
> checks the CRC and it doesn't match, so it sets b_error to -EFSBADCRC and
> doesn't get to the header check. 

Ok, that explains it - I didn't consider that case. This would seem
like a general problem for repair when CRC errors are detected? i.e.
we set the repair flag without doing the remaining verifier validity
checks?

As it is, I don't really like duplicating the verifier checks in
repair. ISTR I recently suggested that we need to factor all the
common verifier checks (magic, owner, uuid, blockno) into a single
function that all verifiers called to remove all the code
duplication. If we do this, then repair can also call the function
to verify headers after a CRC failure to determine if repair is
possible....

This is a bit more work, so I'll probably take this specific patch
for 4.2.0, but I'd like to see this all factored out so we aren't
duplicating code unnecessarily.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
