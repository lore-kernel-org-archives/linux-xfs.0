Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F8857F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 15:57:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7811B30404E
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 13:57:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9qI0afpPb7lWbQEe for <xfs@oss.sgi.com>;
	Wed, 28 Aug 2013 13:57:58 -0700 (PDT)
Date: Thu, 29 Aug 2013 06:57:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: btree block LSN escaping to disk uninitialised
Message-ID: <20130828205753.GN12779@dastard>
References: <1377688967-6480-1-git-send-email-david@fromorbit.com>
	<1377688967-6480-2-git-send-email-david@fromorbit.com>
	<521E5E0D.4000606@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <521E5E0D.4000606@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 28, 2013 at 03:31:09PM -0500, Mark Tinguely wrote:
> On 08/28/13 06:22, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >When testing LSN ordering code for v5 superblocks, it was discovered
> >that the the LSN embedded in the generic btree blocks was
> >occasionally uninitialised. These values didn't get written to disk
> >by metadata writeback - they got written by previous transactions in
> >log recovery.
> >
> >The issue is here that the when the block is first allocated and
> >initialised, the LSN field was not initialised - it gets overwritten
> >before IO is issued on the buffer - but the value that is logged by
> >transactions that modify the header before it is written to disk
> >(and initialised) contain garbage. Hence the first recovery of the
> >buffer will stamp garbage into the LSN field, and that can cause
> >subsequent transactions to not replay correctly.
> >
> >The fix is simply to initialise the bb_lsn field to zero when we
> >initialise the block for the first time.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> 
> This is simple enough that it could have been put into the second patch.

It is simple, but it is a bug fix and not part of the feature being
added in the second patch. Best practice is to separate out bug
fixes from features as bug fixes should be standalone commits so
they can be easily backported if necessary.  That's been drilled
into kernel developers for years by people like akpm, hch and other
maintainers, so breaking up patches like this should be second
nature to all kernel developers...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
