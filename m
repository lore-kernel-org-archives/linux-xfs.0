Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeINTAn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Sep 2018 15:00:43 -0400
Date: Fri, 14 Sep 2018 06:46:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180914134607.GA6334@infradead.org>
References: <bf6e7f18-25fa-2b41-9532-78bffe33a241@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf6e7f18-25fa-2b41-9532-78bffe33a241@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Sep 12, 2018 at 08:55:35PM -0500, Eric Sandeen wrote:
> The commit:
> 
>  db1327b1 xfs: report shared extent mappings to userspace correctly
> 
> disabled FIBMAP on reflinked files, with this very clear rationale
> regarding swapfiles:
> 
> "Have xfs_vm_bmap return zero for reflinked files because the
> bmap-based swap code requires static block mappings, which is
> incompatible with copy on write."
> 
> However, this broke the FIBMAP interface for existing userspace
> apps, including bootloaders.

It didn't break any interface because the reflink flag has been
experimental and a mkfs-time opt in.

So NAK for this patch.
