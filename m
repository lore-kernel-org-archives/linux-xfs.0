Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfFNGwy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 02:52:54 -0400
Date: Fri, 14 Jun 2019 14:52:40 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: alternative take on the same page merging leak fix v2
Message-ID: <20190614065239.GA24393@ming.t460p>
References: <20190613095529.25005-1-hch@lst.de>
 <00c908ad-ca33-164d-3741-6c67813c1f0d@kernel.dk>
 <20190614011946.GB14436@ming.t460p>
 <20190614054514.GB6722@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614054514.GB6722@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Jun 14, 2019 at 07:45:14AM +0200, Christoph Hellwig wrote:
> On Fri, Jun 14, 2019 at 09:19:47AM +0800, Ming Lei wrote:
> > On Thu, Jun 13, 2019 at 04:04:03AM -0600, Jens Axboe wrote:
> > > On 6/13/19 3:55 AM, Christoph Hellwig wrote:
> > > > Hi Jens, hi Ming,
> > > > 
> > > > this is the tested and split version of what I think is the better
> > > > fix for the get_user_pages page leak, as it leaves the intelligence
> > > > in the callers instead of in bio_try_to_merge_page.
> > > > 
> > > > Changes since v1:
> > > >   - drop patches not required for 5.2
> > > >   - added Reviewed-by tags
> > > 
> > > Applied for 5.2, thanks.
> > 
> > Hi Jens & Christoph,
> > 
> > Looks the following change is missed in patch 1, otherwise kernel oops
> > is triggered during kernel booting:
> 
> Ok, true, sorry.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> and you probably want to cook it up for Jens with a proper changelog.

This one can be wrapped into the patch 1 given it is just at top of
for-linus, so I guess Jens may do it.

Thanks,
Ming
