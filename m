Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35C0CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 761E820717
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:16:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PvxvrfOg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404082AbfJ1RQQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 13:16:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54572 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730454AbfJ1RQP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 13:16:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHA4d0100870;
        Mon, 28 Oct 2019 17:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Oc37CvxUAqxF2SCwkXOUtPn/FeNq6CbCGxdfbNHjgJ0=;
 b=PvxvrfOgNNML5SQDnbJrXHGS+22elCH+4a+SXnCMamzOMUvz/24fSlAmlnOm4ghYMBLJ
 IoVWtTcMBLrXz9s/w+6dg0JGbhiqd8fIzszDNL4O977Cc2Gh7ph+kG8bXRhDN7yjzYHL
 ORkwX7maFhzUq2Fq+2Cx4UXHIzQeyaYfu3SM6xsUMWsjkcv5DLbS7Q3aVbU9czWfnHYN
 DhNN9kTlxLif8tUxOVSRajwPFiyckafPqewJ90MA821gWIoJFEY5Aopx68m++Is/gTNS
 y4kRscmZPu3DFVM5Es97piJbxL0dRDAjR5+goyp0xTRJ7aiLs/ivR0Z8SKswFf33RfRn UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vvdju3k8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:14:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHBGCc037471;
        Mon, 28 Oct 2019 17:14:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vvyn0320f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:14:07 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SHE6hX005861;
        Mon, 28 Oct 2019 17:14:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 10:14:06 -0700
Date:   Mon, 28 Oct 2019 10:14:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 11/12] xfs: clean up printing inode32/64 in xfs_showargs
Message-ID: <20191028171405.GT15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-12-hch@lst.de>
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

On Sun, Oct 27, 2019 at 03:55:46PM +0100, Christoph Hellwig wrote:
> inode64 is the only value remaining in the unset array.  Special case
> the inode32/64 options with an explicit seq_printf that prints either
> inode32 or inode64, and remove the unset array.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 93ed0871b1cf..0e8942bbf840 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -423,26 +423,19 @@ xfs_showargs(
>  		{ XFS_MOUNT_FILESTREAMS,	",filestreams" },
>  		{ XFS_MOUNT_GRPID,		",grpid" },
>  		{ XFS_MOUNT_DISCARD,		",discard" },
> -		{ XFS_MOUNT_SMALL_INUMS,	",inode32" },
>  		{ XFS_MOUNT_LARGEIO,		",largeio" },
>  		{ XFS_MOUNT_DAX,		",dax" },
>  		{ 0, NULL }
>  	};
> -	static struct proc_xfs_info xfs_info_unset[] = {
> -		/* the few simple ones we can get from the mount struct */
> -		{ XFS_MOUNT_SMALL_INUMS,	",inode64" },
> -		{ 0, NULL }
> -	};
>  	struct proc_xfs_info	*xfs_infop;
>  
>  	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
>  		if (mp->m_flags & xfs_infop->flag)
>  			seq_puts(m, xfs_infop->str);
>  	}
> -	for (xfs_infop = xfs_info_unset; xfs_infop->flag; xfs_infop++) {
> -		if (!(mp->m_flags & xfs_infop->flag))
> -			seq_puts(m, xfs_infop->str);
> -	}
> +
> +	seq_printf(m, ",inode%d",
> +		(mp->m_flags & XFS_MOUNT_SMALL_INUMS) ? 32 : 64);
>  
>  	if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
>  		seq_printf(m, ",allocsize=%dk",
> -- 
> 2.20.1
> 
