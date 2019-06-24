Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54434 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfFXPvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 11:51:40 -0400
Date: Mon, 24 Jun 2019 08:51:37 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 01/12] list.h: add a list_pop helper
Message-ID: <20190624155137.GO32656@bombadil.infradead.org>
References: <20190624055253.31183-1-hch@lst.de>
 <20190624055253.31183-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624055253.31183-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 24, 2019 at 07:52:42AM +0200, Christoph Hellwig wrote:
> +/**
> + * list_pop - delete the first entry from a list and return it
> + * @list:	the list to take the element from.
> + * @type:	the type of the struct this is embedded in.
> + * @member:	the name of the list_head within the struct.
> + *
> + * Note that if the list is empty, it returns NULL.
> + */
> +#define list_pop(list, type, member) 				\

The usual convention in list.h is that list_foo uses the list head and
list_foo_entry uses the container type.  So I think this should be
renamed to list_pop_entry() at least.  Do we also want:

static inline struct list_head *list_pop(struct list_head *head)
{
	struct list_head *first = READ_ONCE(head->next);

	if (first == head)
		return NULL;
	__list_del(head, first->next);
	return first;
}

we also seem to prefer using inline functions over #defines in this
header file.
