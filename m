Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 49E407F8B
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 13:27:30 -0500 (CDT)
Message-ID: <52126391.8050800@sgi.com>
Date: Mon, 19 Aug 2013 13:27:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/12] xfs: fix the comment of
	xfs_extent_busy_update_extent()
References: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
	<1376277303-29455-7-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1376277303-29455-7-git-send-email-zwu.kernel@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: zwu.kernel@gmail.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On 08/11/13 22:14, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>
> Signed-off-by: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
> ---
>   fs/xfs/xfs_extent_busy.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 85e9f87..4ad8fee 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -147,7 +147,7 @@ xfs_extent_busy_search(
>    * extent.  If the overlap covers the beginning, the end, or all of the busy
>    * extent, the overlapping portion can be made unbusy and used for the
>    * allocation.  We can't split a busy extent because we can't modify a
> - * transaction/CIL context busy list, but we can update an entries block
> + * transaction/CIL context busy list, but we can update an entrie's block

                                                               ^^^^^^
						 changed that to entry's
>    * number or length.
>    *
>    * Returns true if the extent can safely be reused, or false if the search

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
