Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60870 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbfARF3d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jan 2019 00:29:33 -0500
Subject: Re: [PATCH v2 1/5] xfs: eof trim writeback mapping as soon as it is
 cached
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-2-bfoster@redhat.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c7aa7be9-b8db-f315-e70b-d1afbce1b3bf@oracle.com>
Date: Thu, 17 Jan 2019 22:29:22 -0700
MIME-Version: 1.0
In-Reply-To: <20190117192004.49346-2-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On 1/17/19 12:20 PM, Brian Foster wrote:
> The cached writeback mapping is EOF trimmed to try and avoid races
> between post-eof block management and writeback that result in
> sending cached data to a stale location. The cached mapping is
> currently trimmed on the validation check, which leaves a race
> window between the time the mapping is cached and when it is trimmed
> against the current inode size.
> 
> For example, if a new mapping is cached by delalloc conversion on a
> blocksize == page size fs, we could cycle various locks, perform
> memory allocations, etc.  in the writeback codepath before the
> associated mapping is eventually trimmed to i_size. This leaves
> enough time for a post-eof truncate and file append before the
> cached mapping is trimmed. The former event essentially invalidates
> a range of the cached mapping and the latter bumps the inode size
> such the trim on the next writepage event won't trim all of the
> invalid blocks. fstest generic/464 reproduces this scenario
> occasionally and causes a lost writeback and stale delalloc blocks
> warning on inode inactivation.
> 
> To work around this problem, trim the cached writeback mapping as
> soon as it is cached in addition to on subsequent validation checks.
> This is a minor tweak to tighten the race window as much as possible
> until a proper invalidation mechanism is available.
> 
> Fixes: 40214d128e07 ("xfs: trim writepage mapping to within eof")
> Cc: <stable@vger.kernel.org> # v4.14+
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/xfs_aops.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 338b9d9984e0..d9048bcea49c 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -449,6 +449,7 @@ xfs_map_blocks(
>   	}
>   
>   	wpc->imap = imap;
> +	xfs_trim_extent_eof(&wpc->imap, ip);
>   	trace_xfs_map_blocks_found(ip, offset, count, wpc->io_type, &imap);
>   	return 0;
>   allocate_blocks:
> @@ -459,6 +460,7 @@ xfs_map_blocks(
>   	ASSERT(whichfork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
>   	       imap.br_startoff + imap.br_blockcount <= cow_fsb);
>   	wpc->imap = imap;
> +	xfs_trim_extent_eof(&wpc->imap, ip);
>   	trace_xfs_map_blocks_alloc(ip, offset, count, wpc->io_type, &imap);
>   	return 0;
>   }
> 

Looks ok, you can add my review:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
