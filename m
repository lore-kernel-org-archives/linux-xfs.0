Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08668C33C9E
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 00:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBD9A24658
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 00:44:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FvkWcFhd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgAOAoL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 19:44:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbgAOAoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 19:44:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00F0cB4e094838;
        Wed, 15 Jan 2020 00:44:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=dMM6cB6N2/2q/GMJ9/bh185cN65XzXsqykH1AXgKeoc=;
 b=FvkWcFhdEcbbLDUHTuq4NwqXO7eQaJh8R9WeqK0FZ5u3m22WGn2eE51xIM65a6umo32C
 GXal6DDDTwvazy5oxwo7CbaZLOET6JcJ097f7P7BdimpT8FiNSvSq2NpUi2iYM64yav/
 au7+LnFkFxA3eY2E6aDrp1fO8PyuNpdGQSm4xDDureVSI1aj0OJ4mWLNprtVis9/W0MH
 KX6MZR2doEI5JuCuRaUaexY8xCao7yuMaTpXK1O1KJY/k0C2KAwY30K/eIHuyUX6wpSo
 pmestUO2L8YE3M43jwsIpuBM8V+AP41vF2m6bHI3Lzkk/4K7lF/MwBDnZh+13s3bE7kX 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xf74s9ep3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 00:44:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00F0dQK6147575;
        Wed, 15 Jan 2020 00:44:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xh2sdhmsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 00:44:01 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00F0hshW017576;
        Wed, 15 Jan 2020 00:43:55 GMT
Received: from localhost (/10.159.156.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jan 2020 16:43:54 -0800
Date:   Tue, 14 Jan 2020 16:43:53 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     hch@lst.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Add __packed to xfs_dir2_sf_entry_t definition
Message-ID: <20200115004353.GX8247@magnolia>
References: <20200114120352.53111-1-vincenzo.frascino@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200114120352.53111-1-vincenzo.frascino@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9500 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9500 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 12:03:52PM +0000, Vincenzo Frascino wrote:
> xfs_check_ondisk_structs() verifies that the sizes of the data types
> used by xfs are correct via the XFS_CHECK_STRUCT_SIZE() macro.
> 
> Since the structures padding can vary depending on the ABI (e.g. on
> ARM OABI structures are padded to multiple of 32 bits), it may happen
> that xfs_dir2_sf_entry_t size check breaks the compilation with the
> assertion below:
> 
> In file included from linux/include/linux/string.h:6,
>                  from linux/include/linux/uuid.h:12,
>                  from linux/fs/xfs/xfs_linux.h:10,
>                  from linux/fs/xfs/xfs.h:22,
>                  from linux/fs/xfs/xfs_super.c:7:
> In function ‘xfs_check_ondisk_structs’,
>     inlined from ‘init_xfs_fs’ at linux/fs/xfs/xfs_super.c:2025:2:
> linux/include/linux/compiler.h:350:38:
>     error: call to ‘__compiletime_assert_107’ declared with attribute
>     error: XFS: sizeof(xfs_dir2_sf_entry_t) is wrong, expected 3
>     _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
> 
> Restore the correct behavior adding __packed to the structure definition.
> 
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>

Will give this a spin,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 3dee33043e09..60db25f30430 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -217,7 +217,7 @@ typedef struct xfs_dir2_sf_entry {
>  	 * A 64-bit or 32-bit inode number follows here, at a variable offset
>  	 * after the name.
>  	 */
> -} xfs_dir2_sf_entry_t;
> +} __packed xfs_dir2_sf_entry_t;
>  
>  static inline int xfs_dir2_sf_hdr_size(int i8count)
>  {
> -- 
> 2.24.1
> 
