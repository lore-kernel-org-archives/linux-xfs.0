Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45226 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfGVUMj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 16:12:39 -0400
Date: Mon, 22 Jul 2019 13:12:34 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 01/12] list.h: add list_pop and list_pop_entry helpers
Message-ID: <20190722201234.GG363@bombadil.infradead.org>
References: <20190722095024.19075-1-hch@lst.de>
 <20190722095024.19075-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722095024.19075-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jul 22, 2019 at 11:50:13AM +0200, Christoph Hellwig wrote:
> We have a very common pattern where we want to delete the first entry
> from a list and return it as the properly typed container structure.
> 
> Add two helpers to implement this behavior.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
