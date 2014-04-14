Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4A56129DF7
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 09:54:26 -0500 (CDT)
Message-ID: <534BF6A0.2070202@sgi.com>
Date: Mon, 14 Apr 2014 09:54:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs_logprint: Fix error handling in
	xlog_print_trans_efi
References: <534BF472.8030908@sandeen.net> <534BF4CD.1080702@sandeen.net>
In-Reply-To: <534BF4CD.1080702@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 04/14/14 09:46, Eric Sandeen wrote:
> A recent change to xlog_print_trans_efi() led to a leaked
> "src_f" on this error return.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 928f60a..d482cf3 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -482,7 +482,7 @@ xlog_print_trans_efi(
>   	uint src_len,
>   	int continued)
>   {
> -    xfs_efi_log_format_t *src_f, *f;
> +    xfs_efi_log_format_t *src_f, *f = NULL;
>       uint		 dst_len;
>       xfs_extent_t	 *ex;
>       int			 i;
> @@ -505,7 +505,8 @@ xlog_print_trans_efi(
>
>       if (continued&&  src_len<  core_size) {
>   	printf(_("EFI: Not enough data to decode further\n"));
> -	return 1;
> +	error = 1;
> +	goto error;
>       }
>
>       if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
>

Looks good. Thank-you Eric and Coverity.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
