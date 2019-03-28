Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfC1PDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Mar 2019 11:03:24 -0400
Date: Thu, 28 Mar 2019 08:03:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: clarify that bio_add_page() and related helpers
 can add multi pages
Message-ID: <20190328150320.GB9265@infradead.org>
References: <20190328035001.26276-1-ming.lei@redhat.com>
 <5258cad3-b324-660f-589f-73eb7fb8fa04@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5258cad3-b324-660f-589f-73eb7fb8fa04@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Thu, Mar 28, 2019 at 08:21:55AM -0600, Jens Axboe wrote:
> This is going to create a needless conflict between 5.1 and the 5.2
> block tree. I haven't pushed the 5.2 tree out yet, plan to do so
> this week after I've pushed the current 5.1 patches. Can you respin
> this one on top of for-5.2/block when it comes out?

Can we also drop the parameter name rename and just add the comments?
