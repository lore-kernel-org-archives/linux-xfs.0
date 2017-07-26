Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35510 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750781AbdGZNEn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jul 2017 09:04:43 -0400
Date: Wed, 26 Jul 2017 15:04:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
Message-ID: <20170726130442.GA24681@lst.de>
References: <20170718172545.18065-1-hch@lst.de> <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com> <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com> <20170720074706.GA22218@lst.de> <0eb47db7-24de-a231-be9f-73d9ae1171fd@gmail.com> <20170720074924.GA22278@lst.de> <16f95f63-1111-9d3c-344c-6b42ddab3b55@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16f95f63-1111-9d3c-344c-6b42ddab3b55@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 05:58:42PM +0300, Nikolay Borisov wrote:
> 
> 
> On 20.07.2017 10:49, Christoph Hellwig wrote:
> > On Thu, Jul 20, 2017 at 10:47:50AM +0300, Nikolay Borisov wrote:
> >>
> >>
> >> On 20.07.2017 10:47, Christoph Hellwig wrote:
> >>> Odd.  And the patch to always just process a single extent from
> >>> xfs_itruncate_extents fixes the issue for you, right?
> >>
> >> As far as I remember yes.
> > 
> > Can you retest it under otherwise identical conditions?
> 
> Okay, I confirm that indeed changing the define from 2 to 1 fixes the
> issue.

But this is just on 4.4 and older, right?  We had issues in the
allocation path there as well, which should be fixed in 4.11 and later,
and in recrnt 4.9-stable releases.  Without those the allocation path
might sometimes lock out of order as well.
