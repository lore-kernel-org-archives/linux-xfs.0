Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169CFC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAE1E21D6C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:02:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oNDift//"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfKHBCR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:02:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55482 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfKHBCR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 20:02:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80wlGa160698;
        Fri, 8 Nov 2019 01:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=bEN3qCNIHkzd4iV5OoQr4bbu0XvBJ6iChtswI0/tuoU=;
 b=oNDift//NGxOTPpZbK+CrNuEWLF8e48yYNr/x9Dey7UdutcaXcawgnkV8hmP9wyFBhIA
 yFsw8SCQiV7kjbla6O7HqLyxysDx/gUAOIsx952jU7Q1hXXha+IbKj29Glo6FFfZrNBS
 cWfATTzwS2eyCMLppfSPQ/HzzduVm/3gmwp7OTzIjYz0KWcZ1FydbaSqaxB8tXp19qBT
 LhPj3LOs2Q4z8Mo59WCnWlRUKFIC6l8hVlIp96O8wmUFA/Q8QnzBV29wYHh5jT0vFApQ
 EBV6I7w2eOOa9MZ3NAvlAI3GGvNHd5sPkiCJKkJcHbTtBNvYWjJgq77NopG6XaKBQuva /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w41w1205f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:02:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80s7bV033616;
        Fri, 8 Nov 2019 01:02:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w4k2xyhen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:02:10 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8129Gb027667;
        Fri, 8 Nov 2019 01:02:09 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 01:02:09 +0000
Date:   Thu, 7 Nov 2019 17:02:00 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/46] xfs: remove the now unused ->data_entry_p method
Message-ID: <20191108010200.GG6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-37-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-37-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:24:00PM +0100, Christoph Hellwig wrote:
> Now that all users use the data_entry_offset field this method is
> unused and can be removed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c | 20 --------------------
>  fs/xfs/libxfs/xfs_dir2.h      |  3 ---
>  2 files changed, 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 347092ec28ab..e70cc54d99e1 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -123,20 +123,6 @@ xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
>  	return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
>  }
>  
> -static struct xfs_dir2_data_entry *
> -xfs_dir2_data_entry_p(struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
> -}
> -
> -static struct xfs_dir2_data_entry *
> -xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
> -}
> -
>  static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_entsize = xfs_dir2_data_entsize,
>  	.data_get_ftype = xfs_dir2_data_get_ftype,
> @@ -148,8 +134,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  				XFS_DIR2_DATA_ENTSIZE(1) +
>  				XFS_DIR2_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
> -
> -	.data_entry_p = xfs_dir2_data_entry_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> @@ -163,8 +147,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  				XFS_DIR3_DATA_ENTSIZE(1) +
>  				XFS_DIR3_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
> -
> -	.data_entry_p = xfs_dir2_data_entry_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_ops = {
> @@ -178,8 +160,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  				XFS_DIR3_DATA_ENTSIZE(1) +
>  				XFS_DIR3_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
> -
> -	.data_entry_p = xfs_dir3_data_entry_p,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 75aec05aae10..a160f2d4ff37 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -42,9 +42,6 @@ struct xfs_dir_ops {
>  
>  	xfs_dir2_data_aoff_t data_first_offset;
>  	size_t	data_entry_offset;
> -
> -	struct xfs_dir2_data_entry *
> -		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
>  };
>  
>  extern const struct xfs_dir_ops *
> -- 
> 2.20.1
> 
