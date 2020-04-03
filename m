Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49737C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 15:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C0BF20721
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 15:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BFoqJfpC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgDCPmg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 11:42:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgDCPmg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 11:42:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033Fcxx4051890;
        Fri, 3 Apr 2020 15:42:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qZxSGFpluabmJHrRpEmhfTc9bM91Kq8dN+1NF/zvMRY=;
 b=BFoqJfpCwu5/4vhTapUWizte81osyO4vvVzlOea3yVoBTFjg+NeQHKjBiS/m1jbl/Vef
 oXRJrxp6rKpw4qXY1DNypBXFUZ/Epl+y5ZOMSSpjWBj1EeYy4P96nHVNWJT6AB5YczXe
 6KRrh2R6bQIQsKSnn0UdnXXpPwywoy4YYftdaAGhWZvgFIMaUx9R6smDQP5snPT2bWvq
 ezroGlEZmqpHQqiWgdCnAZxO+EkH6LdTHW9OJNNpBANrpVirWqQwn6tmCt2AO8DbxcIw
 UXT7ml4LsRZBu2RA0xOE/O/SKgTmYItjSvP7TS2snWw8qHLyBPY+DUBwt/sPT2DpVSDs JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 303aqj29ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 15:42:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033FgEvc160685;
        Fri, 3 Apr 2020 15:42:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302ga52a51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 15:42:32 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033FgVCl019927;
        Fri, 3 Apr 2020 15:42:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 08:42:31 -0700
Date:   Fri, 3 Apr 2020 08:42:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reflink should force the log out if mounted
 with wsync
Message-ID: <20200403154230.GN80283@magnolia>
References: <20200403125522.450299-1-hch@lst.de>
 <20200403125522.450299-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403125522.450299-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 02:55:22PM +0200, Christoph Hellwig wrote:
> Reflink should force the log out to disk if the filesystem was mounted
> with wsync, the same as most other operations in xfs.
> 
> Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems like a cleaner implementation than the one I came up with,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_file.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 68e1cbb3cfcc..4b8bdecc3863 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1059,7 +1059,11 @@ xfs_file_remap_range(
>  
>  	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
>  			remap_flags);
> +	if (ret)
> +		goto out_unlock;
>  
> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +		xfs_log_force_inode(dest);
>  out_unlock:
>  	xfs_reflink_remap_unlock(file_in, file_out);
>  	if (ret)
> -- 
> 2.25.1
> 
