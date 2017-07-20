Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38023 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932661AbdGTHt0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 03:49:26 -0400
Date: Thu, 20 Jul 2017 09:49:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
Message-ID: <20170720074924.GA22278@lst.de>
References: <20170718172545.18065-1-hch@lst.de> <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com> <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com> <20170720074706.GA22218@lst.de> <0eb47db7-24de-a231-be9f-73d9ae1171fd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0eb47db7-24de-a231-be9f-73d9ae1171fd@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 10:47:50AM +0300, Nikolay Borisov wrote:
> 
> 
> On 20.07.2017 10:47, Christoph Hellwig wrote:
> > Odd.  And the patch to always just process a single extent from
> > xfs_itruncate_extents fixes the issue for you, right?
> 
> As far as I remember yes.

Can you retest it under otherwise identical conditions?
