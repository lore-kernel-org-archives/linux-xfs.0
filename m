Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 533547F47
	for <xfs@oss.sgi.com>; Wed, 17 Sep 2014 08:57:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F4278F8054
	for <xfs@oss.sgi.com>; Wed, 17 Sep 2014 06:57:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tsvBzMHQra7bnom4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Sep 2014 06:57:18 -0700 (PDT)
Date: Wed, 17 Sep 2014 09:57:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: flush entire last page of old EOF on truncate up
Message-ID: <20140917135711.GB29222@bfoster.bfoster>
References: <1410907547-9253-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410907547-9253-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 17, 2014 at 08:45:47AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On a sub-page sized filesystem, truncating a mapped region down
> leaves us in a world of hurt. We truncate the pagecache, zeroing the
> newly unused tail, then punch blocks out from under the page. If we
> then truncate the file back up immediately, we expose that unmapped
> hole to a dirty page mapped into the user application, and that's
> where it all goes wrong.
> 
> In truncating the page cache, we avoid unmapping the tail page of
> the cache because it still contains valid data. The problem is that
> it also contains a hole after the truncate, but nobody told the mm
> subsystem that. Therefore, if the page is dirty before the truncate,
> we'll never get a .page_mkwrite callout after we extend the file and
> the application writes data into the hole on the page.  Hence when
> we come to writing that region of the page, it has no blocks and no
> delayed allocation reservation and hence we toss the data away.
> 
> This patch adds code to the truncate up case to solve it, by
> ensuring the partial page at the old EOF is always cleaned after we
> do any zeroing and move the EOF upwards. We can't actually serialise
> the page writeback and truncate against page faults (yes, that
> problem AGAIN) so this is really just a best effort and assumes it
> is extremely unlikely that someone is concurrently writing to the
> page at the EOF while extending the file.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iops.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 63aeca8..a726d37 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -853,6 +853,36 @@ xfs_setattr_size(
>  		return error;
>  	truncate_setsize(inode, newsize);
>  
> +	/*
> +	 * The "we can't serialise against page faults" pain gets worse.
> +	 *
> +	 * If the file is mapped then we have to clean the page at the old EOF
> +	 * when extending the file. Extending the file can expose changes the
> +	 * underlying page mapping (e.g. from beyond EOF to a hole or
> +	 * unwritten), and so on the next attempt to write to that page we need
> +	 * to remap it for write. i.e. we need .page_mkwrite() to be called.
> +	 * Hence we need to clean the page to clean the pte and so a new write
> +	 * fault will be triggered appropriately.
> +	 *
> +	 * If we do it before we change the inode size, then we can race with a
> +	 * page fault that maps the page with exactly the same problem. If we do
> +	 * it after we change the file size, then a new page fault can come in
> +	 * and allocate space before we've run the rest of the truncate
> +	 * transaction. That's kinda grotesque, but it's better than have data
> +	 * over a hole, and so that's the lesser evil that has been chosen here.
> +	 *
> +	 * The real solution, however, is to have some mechanism for locking out
> +	 * page faults while a truncate is in progress.
> +	 */
> +	if (newsize > oldsize && mapping_mapped(VFS_I(ip)->i_mapping)) {
> +		error = filemap_write_and_wait_range(
> +				VFS_I(ip)->i_mapping,
> +				round_down(oldsize, PAGE_CACHE_SIZE),
> +				round_up(oldsize, PAGE_CACHE_SIZE) - 1);
> +		if (error)
> +			return error;
> +	}
> +

IIUC, clear_page_dirty_for_io() will clean/writeprotect the page on
writeback. Hence any future mmap write generates a (soft) fault and
allows the mm subsystem to invoke mkwrite(), which in turn allows XFS to
handle the block mapping (e.g., allocating delalloc blocks via
get_block()) for the mapped write.

I was starting to think about whether we could combine this with the
previous writeback in xfs_setattr_size(), but the complex nature of the
problem, the long comment required and the notion that we might want to
fix this "for real" some day suggests the the separate hunk is probably
safer. Anyways, if I'm following the above behavior correctly, this
looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
>  	if (error)
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
