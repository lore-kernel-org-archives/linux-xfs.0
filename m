Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54667 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbdFTMfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 08:35:07 -0400
Date: Tue, 20 Jun 2017 05:34:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 11/22] fs: new infrastructure for writeback error
 handling and reporting
Message-ID: <20170620123433.GB19781@infradead.org>
References: <20170616193427.13955-1-jlayton@redhat.com>
 <20170616193427.13955-12-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616193427.13955-12-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

> @@ -393,6 +394,7 @@ struct address_space {
>  	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
>  	struct list_head	private_list;	/* ditto */
>  	void			*private_data;	/* ditto */
> +	errseq_t		wb_err;
>  } __attribute__((aligned(sizeof(long))));
>  	/*
>  	 * On most architectures that alignment is already the case; but
> @@ -847,6 +849,7 @@ struct file {
>  	 * Must not be taken from IRQ context.
>  	 */
>  	spinlock_t		f_lock;
> +	errseq_t		f_wb_err;
>  	atomic_long_t		f_count;
>  	unsigned int 		f_flags;
>  	fmode_t			f_mode;

Did you check the sizes of the structure before and after?
These places don't look like holes in the packing, but there probably
are some available.

> +static inline int filemap_check_wb_err(struct address_space *mapping, errseq_t since)

Overly long line here (the patch has a few more)

