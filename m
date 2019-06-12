Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406555AbfFLBJf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Jun 2019 21:09:35 -0400
Date: Wed, 12 Jun 2019 09:09:23 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: alternative take on the same page merging leak fix
Message-ID: <20190612010922.GA17522@ming.t460p>
References: <20190611151007.13625-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611151007.13625-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

Hi Christoph,

On Tue, Jun 11, 2019 at 05:10:02PM +0200, Christoph Hellwig wrote:
> Hi Jens, hi Ming,
> 
> this is the tested and split version of what I think is the better
> fix for the get_user_pages page leak, as it leaves the intelligence
> in the callers instead of in bio_try_to_merge_page.

I am fine with either one from upstream developer view, so let Jens
decide.

However:

We have to backport the fixes to -stable tree, and downstream need to
ship the fix too.

The issue is quite serious because the leak is in IO path and the whole
system ram can be used up easily on some workloads. So I think the fix
should be for 5.2, however, regression risk might be increased by
pulling cleanup & re-factor in now.

I really appreciate you may cook a fix-only patch for this issue.
Especially the change in add pc page code isn't necessary for fixing
the issue.



Thanks,
Ming
