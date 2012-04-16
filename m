Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GGFVVN227616 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 11:15:31 -0500
Message-ID: <4F8C45A1.1090200@sgi.com>
Date: Mon, 16 Apr 2012 11:15:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/18] xfs: page type check in writeback only checks last
	buffer
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-5-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/13/12 07:10, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> xfs_is_delayed_page() checks to see if a page has buffers matching
> the given IO type passed in. It does so by walking the buffer heads
> on the page and checking if the state flags match the IO type.
>
> However, the "acceptable" variable that is calculated is overwritten
> every time a new buffer is checked. Hence if the first buffer on the
> page is of the right type, this state is lost if the second buffer
> is not of the correct type. This means that xfs_aops_discard_page()
> may not discard delalloc regions when it is supposed to, and
> xfs_convert_page() may not cluster IO as efficiently as possible.
>
> This problem only occurs on filesystems with a block size smaller
> than page size.
>
> Also, rename xfs_is_delayed_page() to xfs_check_page_type() to
> better describe what it is doing - it is not delalloc specific
> anymore.
>
> The problem was first noticed by Peter Watkins.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_aops.c |   12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 0783def..2fc12db 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -623,7 +623,7 @@ xfs_map_at_offset(
>    * or delayed allocate extent.
>    */
>   STATIC int
> -xfs_is_delayed_page(
> +xfs_check_page_type(
>   	struct page		*page,
>   	unsigned int		type)
>   {
> @@ -637,11 +637,11 @@ xfs_is_delayed_page(
>   		bh = head = page_buffers(page);
>   		do {
>   			if (buffer_unwritten(bh))
> -				acceptable = (type == IO_UNWRITTEN);
> +				acceptable += (type == IO_UNWRITTEN);
>   			else if (buffer_delay(bh))
> -				acceptable = (type == IO_DELALLOC);
> +				acceptable += (type == IO_DELALLOC);
>   			else if (buffer_dirty(bh)&&  buffer_mapped(bh))
> -				acceptable = (type == IO_OVERWRITE);
> +				acceptable += (type == IO_OVERWRITE);
>   			else
>   				break;

Looks good.

Could short-cut and return 1 on the first acceptable buffer rather than 
scanning the entire too.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
