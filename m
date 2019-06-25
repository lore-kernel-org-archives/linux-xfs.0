Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33380 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfFYKGi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 06:06:38 -0400
Date: Tue, 25 Jun 2019 12:06:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/12] list.h: add a list_pop helper
Message-ID: <20190625100606.GF1462@lst.de>
References: <20190624055253.31183-1-hch@lst.de> <20190624055253.31183-2-hch@lst.de> <20190624155137.GO32656@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624155137.GO32656@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 24, 2019 at 08:51:37AM -0700, Matthew Wilcox wrote:
> The usual convention in list.h is that list_foo uses the list head and
> list_foo_entry uses the container type.  So I think this should be
> renamed to list_pop_entry() at least.  Do we also want:
> 
> static inline struct list_head *list_pop(struct list_head *head)
> {
> 	struct list_head *first = READ_ONCE(head->next);
> 
> 	if (first == head)
> 		return NULL;
> 	__list_del(head, first->next);
> 	return first;
> }
> 
> we also seem to prefer using inline functions over #defines in this
> header file.

Sure, I can rename it and split the implementation.
