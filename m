Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2BFC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 16:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0505218AE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 16:17:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pnv6fpfm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbfIFQRo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Sep 2019 12:17:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38824 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbfIFQRo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Sep 2019 12:17:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86GESWc124588;
        Fri, 6 Sep 2019 16:17:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=l/040P4QW7+JM3PW8YadH03j1RBWt/KrwbSqTwdxSBI=;
 b=pnv6fpfmMe5nS70CSEL060llVcC5BIJSFjlC9FIR2Tdu/pvBni8RCOB6Y6QN8e4CBBAz
 ADvO1D1KT0Z+cJpeRls5fkXkax6ll+U+6os6oTBhx+kpDInFOffx80IzbujRTIWM6K16
 K/yCGXRAtuoPDcHsrgi6WlRp23QKH0WBCF00+XTQF78laJPk1WwCc4+slEV11H4IUbVx
 VHeOkLwJjCxgvdpx4644DM8deosDGJJlYO74zIIa+xy9eL+Iu0FdyYiou7kUC6SERLCc
 kowYWhcRmtipcjBZ8Ji/AzGnCU+GHsQmJ5CVy3C7/QpxJ7+rwmkrHtncMIxeMpsxj9MG AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uutdcr5g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 16:17:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86GDKNP182711;
        Fri, 6 Sep 2019 16:17:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2uum4h9k57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 16:17:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x86GHNnh008246;
        Fri, 6 Sep 2019 16:17:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 09:17:23 -0700
Date:   Fri, 6 Sep 2019 09:17:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Jianhong.Yin" <yin-jianhong@163.com>
Cc:     linux-xfs@vger.kernel.org, jiyin@redhat.com
Subject: Re: [PATCH] xfs_io: copy_range don't truncate dst_file, and add
 smart length.
Message-ID: <20190906161722.GT2229799@magnolia>
References: <20190906053927.8394-1-yin-jianhong@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906053927.8394-1-yin-jianhong@163.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 06, 2019 at 01:39:27PM +0800, Jianhong.Yin wrote:
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
>  man/man8/xfs_io.8    |  9 +++------
>  2 files changed, 8 insertions(+), 23 deletions(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index b7b9fd88..02d50e53 100644
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
>  	size_t len = 0;
> +	int len_ommited = 1;

Nit: The correct spelling is "omitted", not "ommited".  As in,

bool len_omitted = true;

(You could also call it "len_specified" since it's a little odd to
declare that it's ommitted before we even parse the arguments but now
we're just splitting hairs...)

>  	int opt;
>  	int ret;
>  	int fd;
> @@ -112,6 +104,7 @@ copy_range_f(int argc, char **argv)
>  				printf(_("invalid length -- %s\n"), optarg);
>  				return 0;
>  			}
> +			len_ommited = 0;
>  			break;
>  		case 'f':
>  			src_file_nr = atoi(argv[1]);
> @@ -137,7 +130,7 @@ copy_range_f(int argc, char **argv)
>  		fd = filetable[src_file_nr].fd;
>  	}
>  
> -	if (src == 0 && dst == 0 && len == 0) {
> +	if (len_ommited) {
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
>  	}
>  
>  	ret = copy_file_range_cmd(fd, &src, &dst, len);
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 6e064bdd..8bfaeeba 100644
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
> +is omitted will use ( src_size - 
> +.I src_offset
> +) instead.

"If length is not specified, this command copies data from src_offset to
the end of the src_file into the dst_file at dst_offset." ?

--D

>  .RS 1.0i
>  .PD 0
>  .TP 0.4i
> -- 
> 2.21.0
> 
