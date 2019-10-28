Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E32BCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 729AB21783
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ezN72YQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404085AbfJ1RNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 13:13:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51542 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404084AbfJ1RNi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 13:13:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHA464100864;
        Mon, 28 Oct 2019 17:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=kYxCq5zxx38YcKkc9swewdVFo/L1cVnT9DnvU+0X7L4=;
 b=ezN72YQXBwxIZEJlDSv/gnnAOeN0EX1X7ChimI0L9KeRobFDvtZ0dNeucjPakd2XUrKj
 d0/zt3ItpgJxElOuKDxcLybVoEYsxx/QbCVEuirkkZ93BMbO6CSyOW8MoeJtdt/Finc9
 2hVQf43q/U1kbnlSLeTsI5hxnghR94cfCiOfyzh0D7p69s7l7gXjIqi0dQhc/3MTdLD5
 q3heGEdOK3c8yYd5bwjiYX0giLLBxfTJMDlvUQ0Pz91myW+BTOYtEHYx1nLS/9d43Kpo
 sR+Oyrq/xBxB4maqeK8BcfiQLlME+S5hGDCQg5Lc/iP5KZRmrrAlnud+qUm+WsvEiUu/ Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vvdju3k4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:13:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHBoIr164501;
        Mon, 28 Oct 2019 17:13:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vvyks8ksb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:13:32 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9SHDVpU027644;
        Mon, 28 Oct 2019 17:13:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 10:13:31 -0700
Date:   Mon, 28 Oct 2019 10:13:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 10/12] xfs: clean up printing the allocsize option in
 xfs_showargs
Message-ID: <20191028171330.GS15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-11-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 27, 2019 at 03:55:45PM +0100, Christoph Hellwig wrote:
> Remove superflous cast.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f21c59822a38..93ed0871b1cf 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -446,7 +446,7 @@ xfs_showargs(
>  
>  	if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
>  		seq_printf(m, ",allocsize=%dk",
> -				(int)(1 << mp->m_allocsize_log) >> 10);
> +			   (1 << mp->m_allocsize_log) >> 10);
>  
>  	if (mp->m_logbufs > 0)
>  		seq_printf(m, ",logbufs=%d", mp->m_logbufs);
> -- 
> 2.20.1
> 
