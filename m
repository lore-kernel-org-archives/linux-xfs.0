Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35456 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbdJ1GF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Oct 2017 02:05:29 -0400
Date: Fri, 27 Oct 2017 23:05:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: flush the range before zero partial block range on
 truncate down
Message-ID: <20171028060529.GA29505@infradead.org>
References: <20171027125328.25001-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027125328.25001-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 27, 2017 at 08:53:28PM +0800, Eryu Guan wrote:
> But it's possible that a buffer write overwrites the unwritten
> extent, which won't be converted to a normal extent until I/O
> completion, and iomap_truncate_page() skips zeroing wrongly because
> of the not-converted unwritten extent. This would cause a subsequent
> mmap read sees non-zeros beyond EOF.

I suspect the right fix is to look at the in-core state im the iomap
truncate helpers instead of doing a duplicate flush.
