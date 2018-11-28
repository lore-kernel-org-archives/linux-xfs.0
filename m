Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47382 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbeK1Sq1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 13:46:27 -0500
Date: Tue, 27 Nov 2018 23:45:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v1 0/7] Block/XFS: Support alternative mirror device
 retry
Message-ID: <20181128074544.GA20702@infradead.org>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <20181128053303.GL6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128053303.GL6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com

On Wed, Nov 28, 2018 at 04:33:03PM +1100, Dave Chinner wrote:
> 	- how does propagation through stacked layers work?

The only way it works is by each layering driving it.  Thus my
recommendation above bilding on your earlier one to use an index
that is filled by the driver at I/O completion time.

E.g.

	bio_init:		bi_leg = -1

	raid1:			submit bio to lower driver
	raid 1 completion:	set bi_leg to 0 or 1

Now if we want to allow stacking we need to save/restore bi_leg
before submitting to the underlying device.  Which is possible,
but quite a bit of work in the drivers.

> 	- is it generic/abstract enough to be able to work with
> 	  RAID5/6 to trigger verification/recovery from the parity
> 	  information in the stripe?

If we get the non -1 bi_leg for paritity raid this is an inidicator
that parity rebuild needs to happen.  For multi-parity setups we could
also use different levels there.
