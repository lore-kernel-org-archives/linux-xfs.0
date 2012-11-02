Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2MAt4B190551 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 17:10:55 -0500
Date: Fri, 2 Nov 2012 17:12:44 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Update inode alloc comments
Message-ID: <20121102221244.GI9783@sgi.com>
References: <1350742099-8397-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1350742099-8397-1-git-send-email-cmaiolino@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

Hey Carlos,

On Sat, Oct 20, 2012 at 11:08:19AM -0300, Carlos Maiolino wrote:
> I found some out of date comments while studying the inode allocation code, so I
> believe it's worth to have these comments updated.
> 
> It basically rewrites the comment regarding to "call_again" variable, which is
> not used anymore, but instead, callers of xfs_ialloc() decides if it needs to be
> called again relying only if ialloc_context is NULL or not.
> 
> Also did some small changes in another comment that I thought to be pertinent
> to the current behaviour of these functions and some alignment on both comments.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_ialloc.c |  6 +++---
>  fs/xfs/xfs_inode.c  | 18 +++++++++---------
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 445bf1a..f1a6046 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -876,9 +876,9 @@ error0:
>   * This function is designed to be called twice if it has to do an allocation
>   * to make more free inodes.  On the first call, *IO_agbp should be set to NULL.
>   * If an inode is available without having to performn an allocation, an inode
> - * number is returned.  In this case, *IO_agbp would be NULL.  If an allocation
> - * needes to be done, xfs_dialloc would return the current AGI buffer in
> - * *IO_agbp.  The caller should then commit the current transaction, allocate a
> + * number is returned.  In this case, *IO_agbp is set to NULL.  If an allocation
> + * needes to be done, xfs_dialloc returns the current AGI buffer in *IO_agbp.
      needs

Since we're at it.

Looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
