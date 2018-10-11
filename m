Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33778 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbeJKN2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:28:31 -0400
Date: Wed, 10 Oct 2018 23:02:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/18] xfs_io: rename global buffer variable
Message-ID: <20181011060249.GM20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-14-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-14-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:17PM -0500, Eric Sandeen wrote:
> "buffer" is a pretty poor name for a global variable, and leads to
> shadow variable warnings from sparse when other functions (reasonably)
> think it's a nice local variable name.
> 
> Rename it to io_buffer for less namespace pollution, and rename
> buffersize to io_buffersize to go with it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
