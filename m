Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48976 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbeK1Sv4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 13:51:56 -0500
Date: Tue, 27 Nov 2018 23:51:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v1 0/7] Block/XFS: Support alternative mirror device
 retry
Message-ID: <20181128075111.GA29388@infradead.org>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <20181128053303.GL6311@dastard>
 <20181128073722.GB7084@infradead.org>
 <20181128074613.GP6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128074613.GP6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com

On Wed, Nov 28, 2018 at 06:46:13PM +1100, Dave Chinner wrote:
> Maybe we should be chaining bios for discontig buffers rather than
> submitting them individually - that keeps the whole chain around
> until all bios in the chain have completed, right?

No, it doesn't.  It just keeps the head of the chain around.

But we generally submit one buffer per map, only if each map was
bigger than BIO_MAX_PAGE * PAGE_SIZE we'd submit multiple bios.
That should always be bigger than our buffer sizes.

We also have the additional problem that a single bio submitted
by the file system can be split into multiple by the block layer,
which happens for raid 5 at least, but at least that splitting
is driven by the drivers make_request function, so it can do
smarts there.
