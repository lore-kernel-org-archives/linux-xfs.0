Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A10C3A59E
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 00:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C71922CF5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 00:15:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OJ8m5vgV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfIEAPS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 20:15:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42434 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfIEAPS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 20:15:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8508vcF087206;
        Thu, 5 Sep 2019 00:14:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pGv8w56JCV6tlk8/rCcaWprm5vi0OfV/i6YxFEiLdi0=;
 b=OJ8m5vgVpaH8ZiZOi8PsWNZsf2HjUK1qBBCzhNbJPncyDXv5tLlIPCVZPopNpqBjshYW
 dAN4ojEjcTnIsthp1UYQk1GrZyYZWO8nTXySuiTPW9bunbYlFiv/y7pCqyatz5w5KTrY
 ekSkU+rCDhGKsmq60Kn80y/vMTWnEEHRTGukCwJHre7IK7zhWr+mhYaUdVitJvQ853vW
 0TfmD+JUiRYEMURTv0MXyQ++3yD9TgEfA9jne2XKAuW9gPNlP1opa5jeptBuHX/FlkvY
 2hh8mMDqG+F7LFrK12lGBpxYgDaTjDgggnirKbb5jQuZacz6omAk4GbDNGEZRGOPTQt0 gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2utqfgg16n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 00:14:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8508uWl122473;
        Thu, 5 Sep 2019 00:14:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2usu52eubv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 00:14:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x850EwcE015138;
        Thu, 5 Sep 2019 00:14:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Sep 2019 17:14:58 -0700
Date:   Wed, 4 Sep 2019 17:14:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Jianhong.Yin" <yin-jianhong@163.com>
Cc:     linux-xfs@vger.kernel.org, jiyin@redhat.com
Subject: Re: [PATCH v2] xfsprogs: copy_range don't truncate dstfile
Message-ID: <20190905001457.GF5354@magnolia>
References: <20190904233634.12261-1-yin-jianhong@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904233634.12261-1-yin-jianhong@163.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 07:36:34AM +0800, Jianhong.Yin wrote:
> now if we do copy_range from srcfile to dstfile without any option
> will truncate the dstfile, and not any document indicate this default
> action. that's unexpected and confuse people.

Needs manpage update.

Also, did you check that xfstests doesn't somehow use this?  There are
several cfr tests now...

generic/430 generic/431 generic/432 generic/433 generic/434 generic/553
generic/554 generic/564 generic/565 generic/716

--D

> '''
> $ ./xfs_io -f -c 'copy_range copy_file_range.c'  testfile
> $ ll testfile
> -rw-rw-r--. 1 yjh yjh 3534 Sep  5 07:15 testfile
> $ ./xfs_io -c 'copy_range testfile'  testfile
> $ ll testfile
> -rw-rw-r--. 1 yjh yjh 3534 Sep  5 07:16 testfile
> $ ./xfs_io -c 'copy_range testfile -l 3534 -d 3534' testfile
> $ ll testfile
> -rw-rw-r--. 1 yjh yjh 7068 Sep  5 07:17 testfile
> $ ./xfs_io -c 'copy_range copy_file_range.c'  testfile
> $ ll testfile
> -rw-rw-r--. 1 yjh yjh 7068 Sep  5 07:18 testfile
> $ cmp -n 3534 copy_file_range.c testfile
> $ cmp -i 0:3534 copy_file_range.c testfile
> '''
> 
> Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
> ---
>  io/copy_file_range.c | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index b7b9fd88..283f5094 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -66,15 +66,6 @@ copy_src_filesize(int fd)
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
> @@ -146,12 +137,6 @@ copy_range_f(int argc, char **argv)
>  			goto out;
>  		}
>  		len = sz;
> -
> -		ret = copy_dst_truncate();
> -		if (ret < 0) {
> -			ret = 1;
> -			goto out;
> -		}
>  	}
>  
>  	ret = copy_file_range_cmd(fd, &src, &dst, len);
> -- 
> 2.21.0
> 
