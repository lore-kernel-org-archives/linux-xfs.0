Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17250 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbdHaAKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 20:10:37 -0400
Date: Wed, 30 Aug 2017 17:10:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC 00/12] xfs: more and better verifiers
Message-ID: <20170831001009.GD3775@magnolia>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
 <20170818070516.GA15291@infradead.org>
 <20170818170607.GK4796@magnolia>
 <20170821081333.GB31761@infradead.org>
 <20170829151159.GA12841@infradead.org>
 <20170829222247.GF10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829222247.GF10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 08:22:47AM +1000, Dave Chinner wrote:
> On Tue, Aug 29, 2017 at 08:11:59AM -0700, Christoph Hellwig wrote:
> > On Mon, Aug 21, 2017 at 01:13:33AM -0700, Christoph Hellwig wrote:
> > > So what do you think of the version that adds real printks for
> > > each condition including more details like the one verifier I
> > > did below?  Probably needs some unlikely annotations, though.
> > 
> > Given that there was another resend of the series I'd be really
> > curious about the answer to this?
> 
> If we increase the size of the hexdump on error, then most of the
> specific numbers in the print statements can be pulled from the
> hexdump. And if the verifier tells us exactly what check failed,
> we don't have to decode the entire hexdump to know what field was
> out of band.

How much do we increase the size of the hexdump?  64 -> 128?  Or
whatever the structure header size is?  How about if xfs_error_level >=
XFS_ERRORLEVEL_HIGH then we dump the entire buffer?

> Perhaps what we should think about here is adding a mode to xfs_db
> to decode the hexdump into structured output so we don't have to
> manually decode the hex dumps ever again....

Seems useful, yes.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
