Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751204AbdEOLxY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 May 2017 07:53:24 -0400
Date: Mon, 15 May 2017 13:53:19 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 19/27] buffer: set errors in mapping at the time that
 the error occurs
Message-ID: <20170515115319.GD16182@quack2.suse.cz>
References: <20170509154930.29524-1-jlayton@redhat.com>
 <20170509154930.29524-20-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170509154930.29524-20-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

On Tue 09-05-17 11:49:22, Jeff Layton wrote:
> I noticed on xfs that I could still sometimes get back an error on fsync
> on a fd that was opened after the error condition had been cleared.
> 
> The problem is that the buffer code sets the write_io_error flag and
> then later checks that flag to set the error in the mapping. That flag
> perisists for quite a while however. If the file is later opened with
> O_TRUNC, the buffers will then be invalidated and the mapping's error
> set such that a subsequent fsync will return error. I think this is
> incorrect, as there was no writeback between the open and fsync.
> 
> Add a new mark_buffer_write_io_error operation that sets the flag and
> the error in the mapping at the same time. Replace all calls to
> set_buffer_write_io_error with mark_buffer_write_io_error, and remove
> the places that check this flag in order to set the error in the
> mapping.
> 
> This sets the error in the mapping earlier, at the time that it's first
> detected.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Small nits below.

> @@ -354,7 +354,7 @@ void end_buffer_async_write(struct buffer_head *bh, int uptodate)
>  	} else {
>  		buffer_io_error(bh, ", lost async page write");
>  		mapping_set_error(page->mapping, -EIO);
> -		set_buffer_write_io_error(bh);
> +		mark_buffer_write_io_error(bh);

No need to call mapping_set_error() here when it gets called in
mark_buffer_write_io_error() again?

> @@ -1182,6 +1180,17 @@ void mark_buffer_dirty(struct buffer_head *bh)
>  }
>  EXPORT_SYMBOL(mark_buffer_dirty);
>  
> +void mark_buffer_write_io_error(struct buffer_head *bh)
> +{
> +	set_buffer_write_io_error(bh);
> +	/* FIXME: do we need to set this in both places? */
> +	if (bh->b_page && bh->b_page->mapping)
> +		mapping_set_error(bh->b_page->mapping, -EIO);
> +	if (bh->b_assoc_map)
> +		mapping_set_error(bh->b_assoc_map, -EIO);
> +}
> +EXPORT_SYMBOL(mark_buffer_write_io_error);

So buffers that are shared by several inodes cannot have bh->b_assoc_map
set. So for filesystems that have metadata like this setting in
bh->b_assoc_map doesn't really help and they have to check blockdevice's
mapping anyway. OTOH if filesystem doesn't have such type of metadata
relevant for fsync, this could help it. So maybe it is worth it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
