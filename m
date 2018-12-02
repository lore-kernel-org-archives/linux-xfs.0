Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbeLBQG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 11:06:57 -0500
Date: Sun, 2 Dec 2018 08:06:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix inverted return from xfs_btree_sblock_verify_crc
Message-ID: <20181202160654.GC15501@infradead.org>
References: <28345031-dfa2-1d73-a36c-400e3c2333d1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28345031-dfa2-1d73-a36c-400e3c2333d1@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 29, 2018 at 08:48:25PM -0600, Eric Sandeen wrote:
> xfs_btree_sblock_verify_crc is a bool so should not be returning
> a failaddr_t; worse, if xfs_log_check_lsn fails it returns
> __this_address which looks like a boolean true (i.e. success)
> to the caller.
> 
> (interestingly xfs_btree_lblock_verify_crc doesn't have the issue)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
