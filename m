Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57655 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbdGaMJD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Jul 2017 08:09:03 -0400
Date: Mon, 31 Jul 2017 14:09:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
Message-ID: <20170731120902.GA22412@lst.de>
References: <20170718172545.18065-1-hch@lst.de> <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com> <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com> <20170720074706.GA22218@lst.de> <0eb47db7-24de-a231-be9f-73d9ae1171fd@gmail.com> <20170720074924.GA22278@lst.de> <16f95f63-1111-9d3c-344c-6b42ddab3b55@gmail.com> <20170726130442.GA24681@lst.de> <dfaa4bb9-1915-c1c6-af7e-38cb2d9ad6b7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfaa4bb9-1915-c1c6-af7e-38cb2d9ad6b7@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

Hi Nikolay,

On Fri, Jul 28, 2017 at 09:05:51AM +0300, Nikolay Borisov wrote:
> Couldn't repro on 4.11 and 4.10 (which supposedly shouldn't have the
> fixes). I tried running generic/299 200 times on each kernel. Which
> exactly are the patches in 4.11 which fix the alloc path?

My suspects in 4.11 would be:

xfs: don't fail xfs_extent_busy allocation
xfs: improve handling of busy extents in the low-level allocator
xfs: fix len comparison in xfs_extent_busy_trim

4.10 also had a couple allocator fixes, but nothing that looks
directly related.
