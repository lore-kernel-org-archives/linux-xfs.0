Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7309C4727E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 14:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7150A207C3
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 14:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EZStrT+6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbgI3O2h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 10:28:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36380 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgI3O2g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 10:28:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UEPrx3065569;
        Wed, 30 Sep 2020 14:28:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3n+7RG5hfYUL+dtANgFGIjjyT6Vxv6o9MW60Sy9OSCw=;
 b=EZStrT+6advay4kEac6oR1iTUDimnmoyYrAiKZeorD7C1C429sp301mMrTS/RAtAMOCC
 0dpVYFB1YSZWSwjt2SITWxej1w/7Kqn3u2B8Cz+MfkNv1NXAt9DntmQBiCMt3qirPTQ4
 Ug5ewdAG8zIU7lZtjeJn8Ju32AzeDRD0R6RlJjk+rsPYFcT+9DAtfGZiKh8v0zcKyF1X
 3ypEJpmgxEa5JukuUPhYhScXmEe+cLcE34vc4h01Hx1U5bDWwmSLFKF37bPfeH+ifyOD
 alsPBqi1Auu5/nhFRGlmxW0xNyCo5szhaaPqIp7sN+D+SB05G6TTXq2gbwr9BvbnSzze 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkm0twp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 14:28:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UEQU7p033840;
        Wed, 30 Sep 2020 14:28:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33tfj06tmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 14:28:31 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08UESTv6000988;
        Wed, 30 Sep 2020 14:28:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 07:28:29 -0700
Date:   Wed, 30 Sep 2020 07:28:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, nathans@redhat.com
Subject: Re: [PATCH 2/2] xfs: fix finobt btree block recovery ordering
Message-ID: <20200930142828.GK49547@magnolia>
References: <20200930063532.142256-1-david@fromorbit.com>
 <20200930063532.142256-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930063532.142256-3-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=5 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=5 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 30, 2020 at 04:35:32PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Nathan popped up on #xfs and pointed out that we fail to handle
> finobt btree blocks in xlog_recover_get_buf_lsn(). This means they
> always fall through the entire magic number matching code to "recover
> immediately". Whilst most of the time this is the correct behaviour,
> occasionally it will be incorrect and could potentially overwrite
> more recent metadata because we don't check the LSN in the on disk
> metadata at all.
> 
> This bug has been present since the finobt was first introduced, and
> is a potential cause of the occasional xfs_iget_check_free_state()
> failures we see that indicate that the inode btree state does not
> match the on disk inode state.
> 
> Fixes: aafc3c246529 ("xfs: support the XFS_BTNUM_FINOBT free inode btree type")
> Reported-by: Nathan Scott <nathans@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Aha, I saw that once...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Hmmm, zooming out a bit, what kinds of buffers get logged that don't
have magics?  Realtime bitmap and summary?  Can anyone else think of
something? ;)

--D

> ---
>  fs/xfs/xfs_buf_item_recover.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 24c7a8d11e1a..d44e8b4a3391 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -719,6 +719,8 @@ xlog_recover_get_buf_lsn(
>  	case XFS_ABTC_MAGIC:
>  	case XFS_RMAP_CRC_MAGIC:
>  	case XFS_REFC_CRC_MAGIC:
> +	case XFS_FIBT_CRC_MAGIC:
> +	case XFS_FIBT_MAGIC:
>  	case XFS_IBT_CRC_MAGIC:
>  	case XFS_IBT_MAGIC: {
>  		struct xfs_btree_block *btb = blk;
> -- 
> 2.28.0
> 
