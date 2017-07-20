Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38008 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933883AbdGTHrH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 03:47:07 -0400
Date: Thu, 20 Jul 2017 09:47:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
Message-ID: <20170720074706.GA22218@lst.de>
References: <20170718172545.18065-1-hch@lst.de> <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com> <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jul 19, 2017 at 06:09:29PM +0300, Nikolay Borisov wrote:
> I can confirm that on 4.4 I also hit the same deadlock. So this patch is
> not sufficient.

Odd.  And the patch to always just process a single extent from
xfs_itruncate_extents fixes the issue for you, right?
