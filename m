Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9823FC3A5A5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 05:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78AB82184B
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 05:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfIEFya (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 01:54:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfIEFya (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Sep 2019 01:54:30 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B7B8BC0578F8;
        Thu,  5 Sep 2019 05:54:30 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED19D60920;
        Thu,  5 Sep 2019 05:54:29 +0000 (UTC)
Date:   Thu, 5 Sep 2019 14:01:32 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Jianhong.Yin" <yin-jianhong@163.com>
Cc:     linux-xfs@vger.kernel.org, jiyin@redhat.com
Subject: Re: [PATCH 2/2] xfsprogs: copy_range: let = (src_size - src_offset)
 if len omitted
Message-ID: <20190905060131.GB7239@dhcp-12-102.nay.redhat.com>
References: <20190905053152.15701-1-yin-jianhong@163.com>
 <20190905053152.15701-2-yin-jianhong@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905053152.15701-2-yin-jianhong@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 05 Sep 2019 05:54:30 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 01:31:52PM +0800, Jianhong.Yin wrote:
> add update man page.
> 
> Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
> ---

I think these can be in one patch, but anyway...

>  io/copy_file_range.c | 7 +++++--
>  man/man8/xfs_io.8    | 9 +++------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index 283f5094..02d50e53 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -72,6 +72,7 @@ copy_range_f(int argc, char **argv)
>  	long long src = 0;
>  	long long dst = 0;
>  	size_t len = 0;
> +	int len_ommited = 1;
>  	int opt;
>  	int ret;
>  	int fd;
> @@ -103,6 +104,7 @@ copy_range_f(int argc, char **argv)
>  				printf(_("invalid length -- %s\n"), optarg);
>  				return 0;
>  			}
> +			len_ommited = 0;
>  			break;
>  		case 'f':
>  			src_file_nr = atoi(argv[1]);
> @@ -128,7 +130,7 @@ copy_range_f(int argc, char **argv)
>  		fd = filetable[src_file_nr].fd;
>  	}
>  
> -	if (src == 0 && dst == 0 && len == 0) {
> +	if (len_ommited) {
>  		off64_t	sz;
>  
>  		sz = copy_src_filesize(fd);
> @@ -136,7 +138,8 @@ copy_range_f(int argc, char **argv)
>  			ret = 1;
>  			goto out;
>  		}
> -		len = sz;
> +		if (sz > src)
> +			len = sz - src;

What about file size < offset?

Maybe we can do like this?:

    sz = copy_src_filesize(fd);
    if (sz < 0 || (unsigned long long)sz > SIZE_MAX || sz < src) {
        ret = 1;
        goto out;
    }
    len = sz - src;

Thanks,
Zorro

>  	}
>  
>  	ret = copy_file_range_cmd(fd, &src, &dst, len);
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 6e064bdd..f5f1c4fc 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -669,13 +669,10 @@ The source must be specified either by path
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
> +is omitted will use
> +.I src_file 
> +(file size - src_offset) instead.
>  .RS 1.0i
>  .PD 0
>  .TP 0.4i
> -- 
> 2.21.0
> 
