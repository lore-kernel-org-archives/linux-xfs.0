Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8ABAC7F87
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2015 11:52:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24D65AC003
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2015 09:52:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wvP1UMVEukmtw8lW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 05 Jun 2015 09:52:12 -0700 (PDT)
Date: Fri, 5 Jun 2015 12:52:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 19/28] repair: scan sparse finobt records correctly
Message-ID: <20150605165209.GA49025@bfoster.bfoster>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
	<1433270521-62026-20-git-send-email-bfoster@redhat.com>
	<20150605010302.GN9143@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150605010302.GN9143@dastard>
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

On Fri, Jun 05, 2015 at 11:03:02AM +1000, Dave Chinner wrote:
> On Tue, Jun 02, 2015 at 02:41:52PM -0400, Brian Foster wrote:
> > The finobt scan performs similar checks as to the inobt scan, including
> > internal record consistency checks, consistency with inobt records,
> > inode block state, etc. Various parts of this mechanism also assume
> > fully allocated inode records and thus lead to false errors with sparse
> > records.
> > 
> > Update the finobt scan to detect and handle sparse inode records
> > correctly. As for the inobt, do not assume that blocks associated with
> > sparse regions are allocated for inodes and do not account sparse inodes
> > against the freecount. Additionally, verify that sparse state is
> > consistent with the in-core record and set up any new in-core records
> > that might have been missing from the inobt correctly.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> ....
> >  
> > +	/*
> > +	 * Mark sparse inodes as such in the in-core tree. Verify that sparse
> > +	 * inodes are free and that freecount is consistent with the free mask.
> > +	 */
> > +	nfree = 0;
> > +	for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
> > +		if (ino_issparse(rp, j)) {
> > +			if (!suspect && !XFS_INOBT_IS_FREE_DISK(rp, j)) {
> > +				do_warn(
> > +_("finobt ir_holemask/ir_free mismatch, inode chunk %d/%u, holemask 0x%x free 0x%llx\n"),
> > +					agno, ino,
> > +					be16_to_cpu(rp->ir_u.sp.ir_holemask),
> > +					be64_to_cpu(rp->ir_free));
> > +				suspect++;
> > +			}
> > +			if (!suspect && ino_rec)
> > +				set_inode_sparse(ino_rec, j);
> > +		} else if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
> > +			/* freecount only tracks non-sparse inos */
> > +			nfree++;
> > +		}
> > +	}
> > +
> 
> This is the same checking code as used for the inobt. Can you factor
> these into a helper? I'll apply as is, so delta patch again. ;)
> 

There's actually quite a bit of duplication throughout the inobt and
finobt record scan functions. I noticed this when doing the finobt stuff
but there were enough differences that it didn't seem worth the effort
at the time.

Looking back at it now with the sparse stuff added and whatnot, it's
probably worth refactoring. The only difference between much of the
logic is the error messages that distinguish between the trees (inobt
vs. finobt). I've made a pass through this code to create a couple
helpers for these functions and allow the caller to identify the tree
based on a simple enum parameter.

I'll get the patches for this and the other cleanups posted once they
get through some testing...

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
