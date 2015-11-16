Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B8F4F7F54
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 16:42:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C6AA8F8035
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 14:42:28 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	d9u7n17X2IQ07gV4 for <xfs@oss.sgi.com>;
	Mon, 16 Nov 2015 14:42:25 -0800 (PST)
Date: Tue, 17 Nov 2015 09:42:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 07/11] mm: add find_get_entries_tag()
Message-ID: <20151116224222.GW19199@dastard>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<1447459610-14259-8-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447459610-14259-8-git-send-email-ross.zwisler@linux.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, Nov 13, 2015 at 05:06:46PM -0700, Ross Zwisler wrote:
> Add find_get_entries_tag() to the family of functions that include
> find_get_entries(), find_get_pages() and find_get_pages_tag().  This is
> needed for DAX dirty page handling because we need a list of both page
> offsets and radix tree entries ('indices' and 'entries' in this function)
> that are marked with the PAGECACHE_TAG_TOWRITE tag.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  include/linux/pagemap.h |  3 +++
>  mm/filemap.c            | 61 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index a6c78e0..6fea3be 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -354,6 +354,9 @@ unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
>  			       unsigned int nr_pages, struct page **pages);
>  unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
>  			int tag, unsigned int nr_pages, struct page **pages);
> +unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
> +			int tag, unsigned int nr_entries,
> +			struct page **entries, pgoff_t *indices);
>  
>  struct page *grab_cache_page_write_begin(struct address_space *mapping,
>  			pgoff_t index, unsigned flags);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index d5e94fd..89ab448 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1454,6 +1454,67 @@ repeat:
>  }
>  EXPORT_SYMBOL(find_get_pages_tag);
>  
> +/**
> + * find_get_entries_tag - find and return entries that match @tag
> + * @mapping:	the address_space to search
> + * @start:	the starting page cache index
> + * @tag:	the tag index
> + * @nr_entries:	the maximum number of entries
> + * @entries:	where the resulting entries are placed
> + * @indices:	the cache indices corresponding to the entries in @entries
> + *
> + * Like find_get_entries, except we only return entries which are tagged with
> + * @tag.
> + */
> +unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
> +			int tag, unsigned int nr_entries,
> +			struct page **entries, pgoff_t *indices)
> +{
> +	void **slot;
> +	unsigned int ret = 0;
> +	struct radix_tree_iter iter;
> +
> +	if (!nr_entries)
> +		return 0;
> +
> +	rcu_read_lock();
> +restart:
> +	radix_tree_for_each_tagged(slot, &mapping->page_tree,
> +				   &iter, start, tag) {
> +		struct page *page;
> +repeat:
> +		page = radix_tree_deref_slot(slot);
> +		if (unlikely(!page))
> +			continue;
> +		if (radix_tree_exception(page)) {
> +			if (radix_tree_deref_retry(page))
> +				goto restart;

That restart condition looks wrong. ret can be non-zero, but we
start looking from the original start index again, resulting in
duplicates being added to the return arrays...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
