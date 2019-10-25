Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C97ECA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E489E20578
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:31:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V7JpdG8Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392940AbfJYFb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:31:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44910 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390225AbfJYFb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 01:31:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5SuEu114542;
        Fri, 25 Oct 2019 05:31:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3tPVsRa9HEn0ViNRrHrriFkmoyUeqy7V1QR4GPgc2Ws=;
 b=V7JpdG8ZDS0mrn6a6vV6G8o6CudQve9STb2HZtfgBqeBESGEVp1WWoxkIJt9mjHtgcVq
 M+5rnKyGTNGPMTBf/tlLopl46/L8MaOgPYnN3KsXCn4uUe/yHfqsk+5DIV3OAsnkRqI2
 ekFL0Rkm3v3F3B8DDesJM4nFTS6GdPRmEk0rWoEwJJuqK7kzomkvz/L14phxMJcz5Yr/
 htr3sZ7l9yaK0no45sbO1r2xGkQE01pE7BYLAeGa8x6HC+o8HxPY3v+G/dqiSQVGBbUp
 +iiH7EIsItIj1OPOLD33XX2JBHLDMN99YN4lyhvEH3rMG8hSdK481QcLnmJfwfJnT0sS rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4r8231-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 05:31:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5RfqQ103425;
        Fri, 25 Oct 2019 05:29:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vu0fqt90m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 05:29:55 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9P5TsbY031741;
        Fri, 25 Oct 2019 05:29:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 22:29:54 -0700
Date:   Thu, 24 Oct 2019 22:29:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: use xfs_inode_buftarg in xfs_file_dio_aio_write
Message-ID: <20191025052953.GC913374@magnolia>
References: <20191025021852.20172-1-hch@lst.de>
 <20191025021852.20172-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025021852.20172-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250053
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 11:18:51AM +0900, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_file.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index ee4ebb7904f6..156238d5af19 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -487,8 +487,7 @@ xfs_file_dio_aio_write(
>  	int			unaligned_io = 0;
>  	int			iolock;
>  	size_t			count = iov_iter_count(from);
> -	struct xfs_buftarg      *target = XFS_IS_REALTIME_INODE(ip) ?
> -					mp->m_rtdev_targp : mp->m_ddev_targp;
> +	struct xfs_buftarg      *target = xfs_inode_buftarg(ip);
>  
>  	/* DIO must be aligned to device logical sector size */
>  	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
> -- 
> 2.20.1
> 
