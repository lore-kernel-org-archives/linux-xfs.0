Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57996 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754986AbeEaO7w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 10:59:52 -0400
Subject: Re: [PATCH] xfs_io: Make copy_range arguments understand *iB values
References: <20180511002223.14386-1-rgoldwyn@suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0aee28ec-7e45-9f53-2923-d0da4004b0b8@sandeen.net>
Date: Thu, 31 May 2018 09:59:50 -0500
MIME-Version: 1.0
In-Reply-To: <20180511002223.14386-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-xfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>

On 5/10/18 7:22 PM, Goldwyn Rodrigues wrote:
> Arguments such as 2MiB or 2M are converted to 2 because copy_range uses
> strtoull(). Convert strtoull() to cvtnum().
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>


Thanks

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index 99fba20a..0cf658e1 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -47,7 +47,7 @@ copy_range_help(void)
>    * glibc buffered copy fallback.
>    */
>   static loff_t
> -copy_file_range_cmd(int fd, loff_t *src, loff_t *dst, size_t len)
> +copy_file_range_cmd(int fd, long long *src, long long *dst, long long len)
>   {
>   	loff_t ret;
>   
> @@ -89,34 +89,36 @@ copy_dst_truncate(void)
>   static int
>   copy_range_f(int argc, char **argv)
>   {
> -	loff_t src = 0;
> -	loff_t dst = 0;
> +	long long src = 0;
> +	long long dst = 0;
>   	size_t len = 0;
> -	char *sp;
>   	int opt;
>   	int ret;
>   	int fd;
> +	size_t fsblocksize, fssectsize;
> +
> +	init_cvtnum(&fsblocksize, &fssectsize);
>   
>   	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
>   		switch (opt) {
>   		case 's':
> -			src = strtoull(optarg, &sp, 10);
> -			if (!sp || sp == optarg) {
> -				printf(_("invalid source offset -- %s\n"), sp);
> +			src = cvtnum(fsblocksize, fssectsize, optarg);
> +			if (src < 0) {
> +				printf(_("invalid source offset -- %s\n"), optarg);
>   				return 0;
>   			}
>   			break;
>   		case 'd':
> -			dst = strtoull(optarg, &sp, 10);
> -			if (!sp || sp == optarg) {
> -				printf(_("invalid destination offset -- %s\n"), sp);
> +			dst = cvtnum(fsblocksize, fssectsize, optarg);
> +			if (dst < 0) {
> +				printf(_("invalid destination offset -- %s\n"), optarg);
>   				return 0;
>   			}
>   			break;
>   		case 'l':
> -			len = strtoull(optarg, &sp, 10);
> -			if (!sp || sp == optarg) {
> -				printf(_("invalid length -- %s\n"), sp);
> +			len = cvtnum(fsblocksize, fssectsize, optarg);
> +			if (len < 0) {
> +				printf(_("invalid length -- %s\n"), optarg);
>   				return 0;
>   			}
>   			break;
