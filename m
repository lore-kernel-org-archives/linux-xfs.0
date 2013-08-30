Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E04117F59
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 13:41:25 -0500 (CDT)
Date: Fri, 30 Aug 2013 13:41:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/2] xfs: btree block LSN escaping to disk uninitialised
Message-ID: <20130830184125.GG1935@sgi.com>
References: <1377688967-6480-1-git-send-email-david@fromorbit.com>
	<1377688967-6480-2-git-send-email-david@fromorbit.com>
	<521E5E0D.4000606@sgi.com> <20130828205753.GN12779@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130828205753.GN12779@dastard>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Aug 29, 2013 at 06:57:53AM +1000, Dave Chinner wrote:
> On Wed, Aug 28, 2013 at 03:31:09PM -0500, Mark Tinguely wrote:
> > On 08/28/13 06:22, Dave Chinner wrote:
> > >From: Dave Chinner<dchinner@redhat.com>
> > >
> > >When testing LSN ordering code for v5 superblocks, it was discovered
> > >that the the LSN embedded in the generic btree blocks was
> > >occasionally uninitialised. These values didn't get written to disk
> > >by metadata writeback - they got written by previous transactions in
> > >log recovery.
> > >
> > >The issue is here that the when the block is first allocated and
> > >initialised, the LSN field was not initialised - it gets overwritten
> > >before IO is issued on the buffer - but the value that is logged by
> > >transactions that modify the header before it is written to disk
> > >(and initialised) contain garbage. Hence the first recovery of the
> > >buffer will stamp garbage into the LSN field, and that can cause
> > >subsequent transactions to not replay correctly.
> > >
> > >The fix is simply to initialise the bb_lsn field to zero when we
> > >initialise the block for the first time.
> > >
> > >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> > >---
> > 
> > 
> > This is simple enough that it could have been put into the second patch.
> 
> It is simple, but it is a bug fix and not part of the feature being
> added in the second patch. Best practice is to separate out bug
> fixes from features as bug fixes should be standalone commits so
> they can be easily backported if necessary.  That's been drilled
> into kernel developers for years by people like akpm, hch and other
> maintainers, so breaking up patches like this should be second
> nature to all kernel developers...

Amen.

Applied these two.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
