Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A45C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 21:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4272021670
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 21:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389814AbfIFVEP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Sep 2019 17:04:15 -0400
Received: from sandeen.net ([63.231.237.45]:39456 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389390AbfIFVEP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Sep 2019 17:04:15 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4A4ED48C6BB;
        Fri,  6 Sep 2019 16:04:14 -0500 (CDT)
Subject: Re: [PATCH v2] xfs_io: copy_range don't truncate dst_file, and add
 smart length
To:     "Jianhong.Yin" <yin-jianhong@163.com>, linux-xfs@vger.kernel.org
Cc:     jiyin@redhat.com, darrick.wong@oracle.com
References: <20190906170243.13230-1-yin-jianhong@163.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <43208913-ff91-25b6-bc29-8fac01683fa6@sandeen.net>
Date:   Fri, 6 Sep 2019 16:04:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906170243.13230-1-yin-jianhong@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/6/19 12:02 PM, Jianhong.Yin wrote:
> 1. copy_range should be a simple wrapper for copy_file_range(2)
> and nothing else. and there's already -t option for truncate.
> so here we remove the truncate action in copy_range.
> see: https://patchwork.kernel.org/comment/22863587/#1
> 
> 2. improve the default length value generation:
> if -l option is omitted use the length that from src_offset to end
> (src_file's size - src_offset) instead.
> if src_offset is greater than file size, length is 0.
> 
> 3. update manpage
> 
> and have confirmed that this change will not affect xfstests.
> 
> Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
> ---
>  io/copy_file_range.c | 22 +++++-----------------
>  man/man8/xfs_io.8    | 12 ++++++------
>  2 files changed, 11 insertions(+), 23 deletions(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index b7b9fd88..2bc8494e 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -66,21 +66,13 @@ copy_src_filesize(int fd)
>  	return st.st_size;
>  }
>  
> -static int
> -copy_dst_truncate(void)
> -{
> -	int ret = ftruncate(file->fd, 0);
> -	if (ret < 0)
> -		perror("ftruncate");
> -	return ret;
> -}
> -
>  static int
>  copy_range_f(int argc, char **argv)
>  {
>  	long long src = 0;
>  	long long dst = 0;

I'd like to change these to src_off & dst_off, just to help keep track
of things.

>  	size_t len = 0;
> +	bool len_specified = false;
>  	int opt;
>  	int ret;
>  	int fd;
> @@ -112,6 +104,7 @@ copy_range_f(int argc, char **argv)
>  				printf(_("invalid length -- %s\n"), optarg);
>  				return 0;
>  			}
> +			len_specified = true;
>  			break;
>  		case 'f':
>  			src_file_nr = atoi(argv[1]);
> @@ -137,7 +130,7 @@ copy_range_f(int argc, char **argv)
>  		fd = filetable[src_file_nr].fd;
>  	}
>  
> -	if (src == 0 && dst == 0 && len == 0) {
> +	if (! len_specified) {

normal xfsprogs style is no space after the !

>  		off64_t	sz;
>  
>  		sz = copy_src_filesize(fd);
> @@ -145,13 +138,8 @@ copy_range_f(int argc, char **argv)
>  			ret = 1;
>  			goto out;
>  		}
> -		len = sz;
> -
> -		ret = copy_dst_truncate();
> -		if (ret < 0) {
> -			ret = 1;
> -			goto out;
> -		}
> +		if (sz > src)
> +			len = sz - src;

Ok, so if source offset is past EOF, we keep len = 0.

Looks like the kernel does that internally too, so no problem there.

I'll make the cosmetic changes I mentioned above when I commit it, unless
you have any concerns about that.

        /* Shorten the copy to EOF */
        size_in = i_size_read(inode_in);
        if (pos_in >= size_in)
                count = 0;

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  	}
>  
>  	ret = copy_file_range_cmd(fd, &src, &dst, len);
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 6e064bdd..61c35c8e 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -669,13 +669,13 @@ The source must be specified either by path
>  or as another open file
>  .RB ( \-f ).
>  If
> -.I src_file
> -.IR src_offset ,
> -.IR dst_offset ,
> -and
>  .I length
> -are omitted the contents of src_file will be copied to the beginning of the
> -open file, overwriting any data already there.
> +is not specified, this command copies data from
> +.I src_offset
> +to the end of
> +.BI src_file
> +into the dst_file at
> +.IR dst_offset .
>  .RS 1.0i
>  .PD 0
>  .TP 0.4i
> 
