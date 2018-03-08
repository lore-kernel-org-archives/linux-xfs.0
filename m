Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58324 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934581AbeCHIRF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Mar 2018 03:17:05 -0500
Date: Thu, 8 Mar 2018 00:17:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: fix double ijoin in xfs_reflink_cancel_cow_range
Message-ID: <20180308081704.GL15163@infradead.org>
References: <20180307091020.6186-1-david@fromorbit.com>
 <20180307091020.6186-3-david@fromorbit.com>
 <20180307131725.GA32572@infradead.org>
 <20180307210706.GO18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180307210706.GO18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Mar 08, 2018 at 08:07:07AM +1100, Dave Chinner wrote:
> It's in the first patch. I've got to revise it, anyway, because I
> missed the xfs_trans_brelease() case that removes the log item from
> the transaction and that throws a false positive in the rmap
> finishing code.

Please split the infrastructure into a new patch.
