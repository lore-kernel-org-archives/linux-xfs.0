Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6F9C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A16B2343E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbhAGTHz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 14:07:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36486 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbhAGTHz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 14:07:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107J0UaQ065706;
        Thu, 7 Jan 2021 19:07:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iAxcU9ooOj22iz4Lb6pgz5Q3T6nD/Wz1URkV+15X0xg=;
 b=RIw7Q8carLDVAX9V5Bfs0P0zQ0p47V1CEvpMW3VNa2HTtXfSGtaKgKjVRbr/h/rhIZGo
 tCK6fxb/O22q15JHX5K9gVeRSObyXZy8yPUYoMniHvefngpPXZ8EFSNmd2BBjUMXRJUh
 Kw3AWIL3H7O7cKz44OkK8bevR89V1Bl4TtdlxXjZEZJWI5GPQt+gzgi/dx7V4ACk1HGa
 rFY+X4i3/ZKU4hLJRn+U4jJMMLKuJjV+0PIfgNLyF1WgiE12VoNhbSbyNz5tTqEW039w
 VBF+Eu2V63awOPezHkliOeU6qrOw/JPKBCt6oIh3MkSicHFEbWeTTgQ/y+lFm4bG2u+Q rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35wftxdfhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 19:07:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107J0tXQ092989;
        Thu, 7 Jan 2021 19:07:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1fbkwm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 19:07:11 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 107J7A8D023149;
        Thu, 7 Jan 2021 19:07:10 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 19:07:10 +0000
Date:   Thu, 7 Jan 2021 11:07:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: separate log cleaning from log quiesce
Message-ID: <20210107190709.GF6918@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-4-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:21PM -0500, Brian Foster wrote:
> Log quiesce is currently associated with cleaning the log, which is
> accomplished by writing an unmount record as the last step of the
> quiesce sequence. The quiesce codepath is a bit convoluted in this
> regard due to how it is reused from various contexts. In preparation
> to create separate log cleaning and log covering interfaces, lift
> the write of the unmount record into a new cleaning helper and call
> that wherever xfs_log_quiesce() is currently invoked. No functional
> changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Assuming the stuff I rambled about in my reply to patch 2 wasn't a
total braino,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c   | 8 +++++++-
>  fs/xfs/xfs_log.h   | 1 +
>  fs/xfs/xfs_super.c | 2 +-
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4137ed007111..1b3227a033ad 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -957,7 +957,13 @@ xfs_log_quiesce(
>  	xfs_wait_buftarg(mp->m_ddev_targp);
>  	xfs_buf_lock(mp->m_sb_bp);
>  	xfs_buf_unlock(mp->m_sb_bp);
> +}
>  
> +void
> +xfs_log_clean(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_log_quiesce(mp);
>  	xfs_log_unmount_write(mp);
>  }
>  
> @@ -972,7 +978,7 @@ void
>  xfs_log_unmount(
>  	struct xfs_mount	*mp)
>  {
> -	xfs_log_quiesce(mp);
> +	xfs_log_clean(mp);
>  
>  	xfs_trans_ail_destroy(mp);
>  
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 98c913da7587..b0400589f824 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -139,6 +139,7 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>  
>  void	xfs_log_work_queue(struct xfs_mount *mp);
>  void	xfs_log_quiesce(struct xfs_mount *mp);
> +void	xfs_log_clean(struct xfs_mount *mp);
>  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
>  bool	xfs_log_in_recovery(struct xfs_mount *);
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 813be879a5e5..09d956e30fd8 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -897,7 +897,7 @@ xfs_quiesce_attr(
>  	if (error)
>  		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
>  				"Frozen image may not be consistent.");
> -	xfs_log_quiesce(mp);
> +	xfs_log_clean(mp);
>  }
>  
>  /*
> -- 
> 2.26.2
> 
