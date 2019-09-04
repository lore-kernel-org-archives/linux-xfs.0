Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887A8C3A5A8
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 17:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E8B82087E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 17:27:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GvYxI2uR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731468AbfIDR1w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 13:27:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50264 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731852AbfIDR1v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 13:27:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x84HOqVa148110;
        Wed, 4 Sep 2019 17:27:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fFV8mvDGfgnrZ7v17OV+oSh+zwFxwoUuH5+tQuhtnS4=;
 b=GvYxI2uRtjguOKcoJzYxyaPNwPaOC7HmaeeSKpxG4lu+UYF/61mFNghPnNgpg+u/j1vd
 74Hkd34GDBP3XEnX6eLdpnUellV+t02QprXom2VkodBM+7279fw1fcOG2QHYorRZ72v3
 tSnPCudI2ZOmjK771e7054faOt1swcDGLrTTY7Jgd2f/quX4vL4cmNVwau7I+HaVMatF
 tRi6Phe/W9PxMsGaddraXYF5t+L8xt7dK8itn5BwZjmJ2VSE2l4sauE7ikvNaiJ4tupO
 XcKg+ZKcX9ToBVRJWPVTrdAq1n7NpTTogFmYhKnNoDciQBZQ8yXFJNlF2+R4ARxNM8HF AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uthkt80v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 17:27:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x84HNjs4042726;
        Wed, 4 Sep 2019 17:27:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ut1hntype-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 17:27:41 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x84HRdZA014283;
        Wed, 4 Sep 2019 17:27:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Sep 2019 10:27:39 -0700
Date:   Wed, 4 Sep 2019 10:27:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Jianhong.Yin" <yin-jianhong@163.com>
Cc:     linux-xfs@vger.kernel.org, jiyin@redhat.com
Subject: Re: [PATCH] xfsprogs: copy_range don't truncate dstfile if same with
 srcfile
Message-ID: <20190904172736.GD5354@magnolia>
References: <20190904063222.21253-1-yin-jianhong@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904063222.21253-1-yin-jianhong@163.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 04, 2019 at 02:32:22PM +0800, Jianhong.Yin wrote:
> now if we do copy_range in same file without any extra option
> will truncate the file, and not any document indicate this default
> action. that's risky to users.
> 
> '''
> $ LANG=C ll testfile
> -rw-rw-r--. 1 yjh yjh 4054 Sep  4 14:22 testfile
> $ ./xfs_io -c 'copy_range testfile' testfile
> $ LANG=C ll testfile
> -rw-rw-r--. 1 yjh yjh 4054 Sep  4 14:23 testfile
> '''
> 
> Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
> ---
>  io/copy_file_range.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index b7b9fd88..487041c0 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -75,6 +75,19 @@ copy_dst_truncate(void)
>  	return ret;
>  }
>  
> +int is_same_file(int fd1, int fd2) {
> +	struct stat stat1, stat2;
> +	if (fstat(fd1, &stat1) < 0) {
> +		perror("fstat");
> +		return -1;
> +	}
> +	if (fstat(fd2, &stat2) < 0) {
> +		perror("fstat");
> +		return -1;
> +	}
> +	return (stat1.st_dev == stat2.st_dev) && (stat1.st_ino == stat2.st_ino);
> +}
> +
>  static int
>  copy_range_f(int argc, char **argv)
>  {
> @@ -147,10 +160,12 @@ copy_range_f(int argc, char **argv)
>  		}
>  		len = sz;
>  
> -		ret = copy_dst_truncate();
> -		if (ret < 0) {
> -			ret = 1;
> -			goto out;
> +		if (!is_same_file(fd, file->fd)) {

Uggggh, why does xfs_io copy_range have this weird behavior?  It should
be a simple wrapper for copy_file_range (the syscall) and nothing else.

The code patch looks fine for solving this edge case, but we really
shouldn't have this "extra" functionality in a debugging tool that
should be athin wrapper around the syscall for xfstests purposes.

--D

> +			ret = copy_dst_truncate();
> +			if (ret < 0) {
> +				ret = 1;
> +				goto out;
> +			}
>  		}
>  	}
>  
> -- 
> 2.17.2
> 
