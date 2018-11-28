Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:29178 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727247AbeK1Sq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 13:46:59 -0500
Date: Wed, 28 Nov 2018 18:46:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v1 0/7] Block/XFS: Support alternative mirror device
 retry
Message-ID: <20181128074613.GP6311@dastard>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <20181128053303.GL6311@dastard>
 <20181128073722.GB7084@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128073722.GB7084@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com

On Tue, Nov 27, 2018 at 11:37:22PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 28, 2018 at 04:33:03PM +1100, Dave Chinner wrote:
> > One thing that is going to make this more complex at the XFS layer
> > is discontiguous buffers. They require multiple IOs (and therefore
> > bios) and so we are going to need to ensure that all the bios use
> > the same bi_rw_hint.
> 
> Well, in case of raid 1 the load balancing code might actually
> map different bios to different initial legs.   What we really need
> is to keep the 'index' or each bio.  One good way to archive that
> is to just reuse the bio for the retry instead of allocating a new one.

Not sure that is practical, because by the time we run the verifier
that discovers the error we've already released and freed all the
bios. And we don't know when we complete the individual bios whether
to kep it or not as the failure may occur in a bio that has not yet
completed.

Maybe we should be chaining bios for discontig buffers rather than
submitting them individually - that keeps the whole chain around
until all bios in the chain have completed, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
