Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755946AbeDQQK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 12:10:58 -0400
Date: Tue, 17 Apr 2018 09:10:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ioctl FIBMAP for dax gone in v4.17-rc1
Message-ID: <20180417161056.GA24257@infradead.org>
References: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiong Zhou <xzhou@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, fstests@vger.kernel.org, sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 10:40:59PM +0800, Xiong Zhou wrote:
> We got these in v4.17-rc1:
> 6e2608d xfs, dax: introduce xfs_dax_aops
> fb094c9 ext2, dax: introduce ext2_dax_aops
> 5f0663b ext4, dax: introduce ext4_dax_aops
> 
> And we don't have ->bmap call in these aops, which may lead
> to the ioctl call failure.
> 
> Do we have any plan of adding/supporting it ?
> 
> xfstests generic/223 covers this issue. If we are not going
> to support this call for dax, we need to fix the testcase.

Not supporting ->bmap is a good thing as it is hightly dangerous.

The t_stripetest tool used by generic/223 should really be
rewritten to suppot FIEMAP.
