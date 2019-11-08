Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7BDC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98C7E2084D
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:52:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dqU4SgGG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfKHAw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:52:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36498 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfKHAw3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:52:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80cwCL172943;
        Fri, 8 Nov 2019 00:52:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RZhO1BikmX3Av9PXC5s8GAwnBEsB4DF2G7eZ9WZ67ds=;
 b=dqU4SgGGfnxgqVCvquZaNP0jWB447lw1Vn1TuK83S9HZ3IQrwtDsg6bJgwKH80tAHw+F
 +AqEG1ih6DWotZG2GeM68TMNuRv1bjS9mXH0WFjiH050nraRke27iK/a5HvZTcvtzr1i
 cEsoCm4rR1uo+yoHZM54ji2EZlr4/LCnAsphhKm+hBphwpl33a3oN2sfb5P33S5qIQxp
 uebEElkR3JmnDRfJ2BPSmxYrGjdMBpdi4yh8ITi6FQxVy1qibc3qew1v3IFbJ2nbYnBC
 RIM0eO/WazU9LeLC1umTtd3x3Uqk64oKyPIyF2fxskvTMluQRpSEnFJ1fG49YHejCxaT 7w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w19y33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:52:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80dDoD135044;
        Fri, 8 Nov 2019 00:50:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w41wga0t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:50:23 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA80oNLG016346;
        Fri, 8 Nov 2019 00:50:23 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:50:23 -0800
Date:   Thu, 7 Nov 2019 16:50:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/46] xfs: remove the data_dotdot_offset field in struct
 xfs_dir_ops
Message-ID: <20191108005023.GY6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-27-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-27-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:50PM +0100, Christoph Hellwig wrote:
> The data_dotdot_offset value is always equal to data_entry_offset plus
> the fixed size of the "." entry.  Right now calculating that fixed size
> requires an indirect call, but by the end of this series it will be
> an inline function that can be constant folded.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c | 6 ------
>  fs/xfs/libxfs/xfs_dir2.h      | 1 -
>  fs/xfs/xfs_dir2_readdir.c     | 3 ++-
>  3 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 54754eef2437..7b783b11790d 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -204,8 +204,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
>  	.data_bestfree_p = xfs_dir2_data_bestfree_p,
>  
> -	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
> -				XFS_DIR2_DATA_ENTSIZE(1),
>  	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
>  				XFS_DIR2_DATA_ENTSIZE(1) +
>  				XFS_DIR2_DATA_ENTSIZE(2),
> @@ -224,8 +222,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
>  	.data_bestfree_p = xfs_dir2_data_bestfree_p,
>  
> -	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
> -				XFS_DIR3_DATA_ENTSIZE(1),
>  	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
>  				XFS_DIR3_DATA_ENTSIZE(1) +
>  				XFS_DIR3_DATA_ENTSIZE(2),
> @@ -244,8 +240,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
>  	.data_bestfree_p = xfs_dir3_data_bestfree_p,
>  
> -	.data_dotdot_offset = sizeof(struct xfs_dir3_data_hdr) +
> -				XFS_DIR3_DATA_ENTSIZE(1),
>  	.data_first_offset =  sizeof(struct xfs_dir3_data_hdr) +
>  				XFS_DIR3_DATA_ENTSIZE(1) +
>  				XFS_DIR3_DATA_ENTSIZE(2),
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 94e8c40a7d19..8b937993263d 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -40,7 +40,6 @@ struct xfs_dir_ops {
>  	struct xfs_dir2_data_free *
>  		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
>  
> -	xfs_dir2_data_aoff_t data_dotdot_offset;
>  	xfs_dir2_data_aoff_t data_first_offset;
>  	size_t	data_entry_offset;
>  
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 39985ca6ae2d..187bb51875c2 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -77,7 +77,8 @@ xfs_dir2_sf_getdents(
>  	dot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
>  			dp->d_ops->data_entry_offset);
>  	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
> -						dp->d_ops->data_dotdot_offset);
> +			dp->d_ops->data_entry_offset +
> +			dp->d_ops->data_entsize(sizeof(".") - 1));
>  
>  	/*
>  	 * Put . entry unless we're starting past it.
> -- 
> 2.20.1
> 
