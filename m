Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B95527F60
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 10:49:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5FDA08F8064
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 08:49:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pnx3J2RWzH5g3guc for
	<xfs@oss.sgi.com>; Wed, 28 May 2014 08:49:52 -0700 (PDT)
Date: Wed, 28 May 2014 11:49:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH xfs: tone down writepage/releasepage WARN_ONs
Message-ID: <20140528154927.GD5567@bfoster.bfoster>
References: <20140527103119.GA26420@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140527103119.GA26420@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, May 27, 2014 at 03:31:19AM -0700, Christoph Hellwig wrote:
> I recently ran into the issue fixed by
> 
>   "xfs: kill buffers over failed write ranges properly"
> 
> which spams the log with lots of backtraces.  Make debugging any issues
> like that easier by using WARN_ON_ONCE in the writeback code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

The change generally seems fine to me. IIRC, we had a point in time
where these issues were prevalent and noisy. We also had a few lingering
ones that were hard to reproduce. I do wonder whether this would make
that situation difficult to reproduce. For example, running through an
xfstests run where one test might reproduce randomly and suppress output
from a subsequent, perhaps more frequent reproducer. Am I correct to
assume that once fired, the warning wouldn't fire again before a reboot
or module reload?

Hmm, did we have asserts that covered these scenarios as well?

Brian

>  fs/xfs/xfs_aops.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index d1b99b6..e32640e 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -975,7 +975,7 @@ xfs_vm_writepage(
>  	 * Given that we do not allow direct reclaim to call us, we should
>  	 * never be called while in a filesystem transaction.
>  	 */
> -	if (WARN_ON(current->flags & PF_FSTRANS))
> +	if (WARN_ON_ONCE(current->flags & PF_FSTRANS))
>  		goto redirty;
>  
>  	/* Is this page beyond the end of the file? */
> @@ -1225,9 +1225,9 @@ xfs_vm_releasepage(
>  
>  	xfs_count_page_state(page, &delalloc, &unwritten);
>  
> -	if (WARN_ON(delalloc))
> +	if (WARN_ON_ONCE(delalloc))
>  		return 0;
> -	if (WARN_ON(unwritten))
> +	if (WARN_ON_ONCE(unwritten))
>  		return 0;
>  
>  	return try_to_free_buffers(page);
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
