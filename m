Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531B3C2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2713B2078C
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:06:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jAw7cyPc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgDFWGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 18:06:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40088 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFWGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 18:06:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M41cM158668;
        Mon, 6 Apr 2020 22:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+IYHbrspoCM78e0s5lULtj97Cp82fT9iitd00rruncQ=;
 b=jAw7cyPc/4urC2lmhY+j7W7QijSQ5ro0tICJLGB5Xpic21QYc5KKv8p8hPSzKO996Y6x
 mgGvXkQ1Ed53O0QCjGLpr7oY26K+dCQP+4whkNJJglBM6xenvoM7nXoYVCeKvdVe/oox
 3uXJYUlx/ETpxz8vnSpmsJaOcWq9VqR1wJjaWqTjvaPkCCi6BMQ1PyGt8LneJKLXOOmi
 /DQUUMJhGIk6g+qQb955NTnhugO38mz/KpT7lUFLAgPSZLcxUOAszhfwSDlx6aAx5aIR
 vYSmS35hMkbBsc3ZgZuc7/doC4HxS93HP4u8etfXYmrsMlwfAVdFkTcg63uOanIm49T5 PQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 306j6m9j4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:06:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M2R2W116548;
        Mon, 6 Apr 2020 22:06:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30839r9n02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:06:33 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036M6W5Z012340;
        Mon, 6 Apr 2020 22:06:32 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 15:06:32 -0700
Subject: Re: [PATCH 2/5] libxfs: check return value of device flush when
 closing device
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
 <158619915636.469742.17283369979015724938.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <da850a90-30cf-be5b-a98c-700e0f900f8c@oracle.com>
Date:   Mon, 6 Apr 2020 15:06:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158619915636.469742.17283369979015724938.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/6/20 11:52 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Although the libxfs_umount function flushes all devices when unmounting
> the incore filesystem, the libxfs io code will flush the device again
> when the application close them.  Check and report any errors that might
> happen, though this is unlikely.
> 
> Coverity-id: 1460464
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, makes sense
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
>   libxfs/init.c |   11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 3e6436c1..cb8967bc 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -166,13 +166,18 @@ libxfs_device_close(dev_t dev)
>   
>   	for (d = 0; d < MAX_DEVS; d++)
>   		if (dev_map[d].dev == dev) {
> -			int	fd;
> +			int	fd, ret;
>   
>   			fd = dev_map[d].fd;
>   			dev_map[d].dev = dev_map[d].fd = 0;
>   
> -			fsync(fd);
> -			platform_flush_device(fd, dev);
> +			ret = platform_flush_device(fd, dev);
> +			if (ret) {
> +				ret = -errno;
> +				fprintf(stderr,
> +	_("%s: flush of device %lld failed, err=%d"),
> +						progname, (long long)dev, ret);
> +			}
>   			close(fd);
>   
>   			return;
> 
