Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437611AbfFLKLc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jun 2019 06:11:32 -0400
Date: Wed, 12 Jun 2019 18:11:12 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: alternative take on the same page merging leak fix
Message-ID: <20190612101111.GA16000@ming.t460p>
References: <20190611151007.13625-1-hch@lst.de>
 <20190612010922.GA17522@ming.t460p>
 <20190612074527.GA20491@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612074527.GA20491@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 09:45:27AM +0200, Christoph Hellwig wrote:
> On Wed, Jun 12, 2019 at 09:09:23AM +0800, Ming Lei wrote:
> > We have to backport the fixes to -stable tree, and downstream need to
> > ship the fix too.
> > 
> > The issue is quite serious because the leak is in IO path and the whole
> > system ram can be used up easily on some workloads. So I think the fix
> > should be for 5.2, however, regression risk might be increased by
> > pulling cleanup & re-factor in now.
> > 
> > I really appreciate you may cook a fix-only patch for this issue.
> > Especially the change in add pc page code isn't necessary for fixing
> > the issue.
> 
> Patches 3 and 4 have no dependencies on 1 and 2, and should have
> arguably been ordered first in the series.

OK, that is good to make patch 3 &4 into 5.2, I will give a review
soon.

Thanks,
Ming
