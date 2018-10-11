Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33772 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbeJKN2C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:28:02 -0400
Date: Wed, 10 Oct 2018 23:02:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/18] xfsprogs: don't shadow global libxfs_init x
 variable
Message-ID: <20181011060219.GL20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-13-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-13-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:16PM -0500, Eric Sandeen wrote:
> We use the variable 'x' for the global libxfs_init structure, but several
> other functions think 'x' is a nice convenient local var too, and sparse
> complains.  Rename these local variables (or in some cases re-use existing
> loop counter vars when x was used for this purpose).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
