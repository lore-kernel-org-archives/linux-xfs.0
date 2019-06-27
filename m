Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0UtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 16:49:16 -0400
Date: Thu, 27 Jun 2019 13:48:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/13] list.h: add list_pop and list_pop_entry helpers
Message-ID: <20190627204842.GR5171@magnolia>
References: <20190627104836.25446-1-hch@lst.de>
 <20190627104836.25446-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627104836.25446-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jun 27, 2019 at 12:48:24PM +0200, Christoph Hellwig wrote:
> We have a very common pattern where we want to delete the first entry
> from a list and return it as the properly typed container structure.
> 
> Add two helpers to implement this behavior.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  include/linux/list.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index e951228db4b2..ba6e27d2235a 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -500,6 +500,39 @@ static inline void list_splice_tail_init(struct list_head *list,
>  	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
>  })
>  
> +/**
> + * list_pop - delete the first entry from a list and return it
> + * @list:	the list to take the element from.
> + *
> + * Return the list entry after @list.  If @list is empty return NULL.
> + */
> +static inline struct list_head *list_pop(struct list_head *list)
> +{
> +	struct list_head *pos = READ_ONCE(list->next);
> +
> +	if (pos == list)
> +		return NULL;
> +	list_del(pos);
> +	return pos;
> +}
> +
> +/**
> + * list_pop_entry - delete the first entry from a list and return the
> + *			containing structure
> + * @list:	the list to take the element from.
> + * @type:	the type of the struct this is embedded in.
> + * @member:	the name of the list_head within the struct.
> + *
> + * Return the containing structure for the list entry after @list.  If @list
> + * is empty return NULL.
> + */
> +#define list_pop_entry(list, type, member)			\
> +({								\
> +	struct list_head *pos__ = list_pop(list);		\
> +								\
> +	pos__ ? list_entry(pos__, type, member) : NULL;		\
> +})
> +
>  /**
>   * list_next_entry - get the next element in list
>   * @pos:	the type * to cursor
> -- 
> 2.20.1
> 
