Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 656E07F58
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 09:57:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 025A2AC002
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 07:57:46 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id v7XIHs2Se6bGuVrd for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 07:57:44 -0700 (PDT)
Date: Wed, 4 Sep 2013 16:57:40 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 3/7] mm: Allow filesystems to defer cmtime updates
Message-ID: <20130904145740.GE3996@quack.suse.cz>
References: <cover.1377193658.git.luto@amacapital.net>
	<e1620c8e4909a65e270c8e9590e307c22fd96a44.1377193658.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e1620c8e4909a65e270c8e9590e307c22fd96a44.1377193658.git.luto@amacapital.net>
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
To: Andy Lutomirski <luto@amacapital.net>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>

On Thu 22-08-13 17:03:19, Andy Lutomirski wrote:
> Filesystems that defer cmtime updates should update cmtime when any
> of these events happen after a write via a mapping:
> 
>  - The mapping is written back to disk.  This happens from all kinds
>    of places, most of which eventually call ->writepages.  (The
>    exceptions are vmscan and migration.)
> 
>  - munmap is called or the mapping is removed when the process exits
> 
>  - msync(MS_ASYNC) is called.  Linux currently does nothing for
>    msync(MS_ASYNC), but POSIX says that cmtime should be updated some
>    time between an mmaped write and the subsequent msync call.
>    MS_SYNC calls ->writepages, but MS_ASYNC needs special handling.
> 
> Filesystems are responsible for checking for pending deferred cmtime
> updates in .writepages (a helper is provided for this purpose) and
> for doing the actual update in .update_cmtime_deferred.
> 
> These changes have no effect by themselves; filesystems must opt in
> by implementing .update_cmtime_deferred and removing any
> file_update_time call in .page_mkwrite.
> 
> This patch does not implement the MS_ASYNC case; that's in the next
> patch.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
...
> +/**
> + * generic_update_cmtime_deferred - update cmtime after an mmapped write
> + * @mapping: The mapping
> + *
> + * This library function implements .update_cmtime_deferred.  It is unlikely
> + * that any filesystem will want to do anything here except update the time
> + * (using this helper) or nothing at all (by leaving .update_cmtime_deferred
> + * NULL).
> + */
> +void generic_update_cmtime_deferred(struct address_space *mapping)
> +{
> +	struct blk_plug plug;
> +	blk_start_plug(&plug);
> +	inode_update_time_writable(mapping->host);
> +	blk_finish_plug(&plug);
> +}
> +EXPORT_SYMBOL(generic_update_cmtime_deferred);
> +
  You can remove the pluggin here. Inode update will likely result in a
single write so there's no point.

> @@ -1970,6 +1988,39 @@ int write_one_page(struct page *page, int wait)
>  }
>  EXPORT_SYMBOL(write_one_page);
>  
> +void mapping_flush_cmtime(struct address_space *mapping)
> +{
> +	if (mapping_test_clear_cmtime(mapping) &&
> +	    mapping->a_ops->update_cmtime_deferred)
> +		mapping->a_ops->update_cmtime_deferred(mapping);
> +}
> +EXPORT_SYMBOL(mapping_flush_cmtime);
  Hum, is there a reason for update_cmtime_deferred() operation? I can
hardly imagine anyone will want to do anything else than what
inode_update_time_writable() does so why bother? You mention tmpfs & co.
don't fit into your scheme well with which I agree so let's just keep
file_update_time() in their page_mkwrite() operation. But I don't see a
real need for avoiding the deferred cmtime logic...

> +
> +void mapping_flush_cmtime_nowb(struct address_space *mapping)
> +{
> +	/*
> +	 * We get called from munmap and msync.  Both calls can race
> +	 * with fs freezing.  If the fs is frozen after
> +	 * mapping_test_clear_cmtime but before the time update, then
> +	 * sync_filesystem will miss the cmtime update (because we
> +	 * just cleared it) and we don't be able to write (because the
> +	 * fs is frozen).  On the other hand, we can't just return if
> +	 * we're in the SB_FREEZE_PAGEFAULT state because our caller
> +	 * expects the timestamp to be synchronously updated.  So we
> +	 * get write access without blocking, at the SB_FREEZE_FS
> +	 * level.  If the fs is already fully frozen, then we already
> +	 * know we have nothing to do.
> +	 */
> +
> +	if (!mapping_test_cmtime(mapping))
> +		return;  /* Optimization: nothing to do. */
> +
> +	if (__sb_start_write(mapping->host->i_sb, SB_FREEZE_FS, false)) {
> +		mapping_flush_cmtime(mapping);
> +		__sb_end_write(mapping->host->i_sb, SB_FREEZE_FS);
> +	}
> +}
  This is wrong because SB_FREEZE_FS level is targetted for filesystem
internal use. Also it is racy. mapping_flush_cmtime() ends up calling
mark_inode_dirty() and filesystems such as ext4 or xfs will start a
transaction to store inode in the journal. This gets freeze protection at
SB_FREEZE_FS level again. If freeze_super() sets s_writers.frozen to
SB_FREEZE_FS before this second protection, things will deadlock.

Since the callers of this function hold mmap_sem, using SB_FREEZE_PAGEFAULT
protection would be appropriate. Also since there are just two places that
need the freeze protection I'd be inclined to open code the protection in
the two places rather than hiding it in a special function.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
