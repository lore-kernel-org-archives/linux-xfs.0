Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54320 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965129AbeEIPqx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 11:46:53 -0400
Date: Wed, 9 May 2018 08:46:52 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 07/33] mm: split ->readpages calls to avoid
 non-contiguous pages lists
Message-ID: <20180509154652.GE1313@bombadil.infradead.org>
References: <20180509074830.16196-1-hch@lst.de>
 <20180509074830.16196-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509074830.16196-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Wed, May 09, 2018 at 09:48:04AM +0200, Christoph Hellwig wrote:
> That way file systems don't have to go spotting for non-contiguous pages
> and work around them.  It also kicks off I/O earlier, allowing it to
> finish earlier and reduce latency.

Makes sense.

> +			/*
> +			 * Page already present?  Kick off the current batch of
> +			 * contiguous pages before continueing with the next

"continuing" (no 'e')

