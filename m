Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26953 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751227AbdH2Q6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 12:58:07 -0400
Date: Tue, 29 Aug 2017 09:57:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC 00/12] xfs: more and better verifiers
Message-ID: <20170829165740.GT4757@magnolia>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
 <20170818070516.GA15291@infradead.org>
 <20170818170607.GK4796@magnolia>
 <20170821081333.GB31761@infradead.org>
 <20170829151159.GA12841@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829151159.GA12841@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 08:11:59AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 21, 2017 at 01:13:33AM -0700, Christoph Hellwig wrote:
> > So what do you think of the version that adds real printks for
> > each condition including more details like the one verifier I
> > did below?  Probably needs some unlikely annotations, though.
> 
> Given that there was another resend of the series I'd be really
> curious about the answer to this?

Oh!  Sorry, I lost the thread and forgot to reply. :(

For debug kernels, I think it's definitely valuable to us to enhance the
corruption reports by printing out the expected value(s) and the
observed value so that we can pinpoint quickly exactly which test failed
and why.

I'm not as strongly convinced that it's worth it to put all those
strings into release builds and have to carry those around in memory.
Then again, on my rc7 dev build the strings only contribute about 120K
to a 1.4MB .ko file so it might not be a big deal.

I also think it would be useful for xfs_verifier_error to print more of
the corrupted buffer.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
