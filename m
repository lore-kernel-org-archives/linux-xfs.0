Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1271C2D0DC
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 21:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74D32217F4
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 21:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Khip842q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgABVR6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 16:17:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgABVR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 16:17:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002LCCDB054410;
        Thu, 2 Jan 2020 21:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=gynHDIkXILoagB1T02HBt+3WzSygRnB3EGLvmFYZvxY=;
 b=Khip842ql87XXQ+4/zltvyUPV1ELcgnoS4nb6fGrrs/Y4eTfFy6bMHurv9XJPtntqt1l
 KEeLl3z+Tb8xZlXOxGSrgobahrkvahkuuakHnu8vCZZRGxGYb3qrLu0angiZqxgeDBbJ
 wwtOKrF8blypKmkt6mulIK2JSU1vb6XR6Ygj3H9saH4NIYkHXmlnntLvMGf21V+boyv7
 5zyOlKdE76xBhVlSQrDbL15UDCtG0mD97rmizLC1OlLpYj7vcmSLziHLM9586YeAe+ak
 HLMhOfqNtjIVL5wC/g9fy0g6/OHpXw5q5SIc081byWAj6jwB3snB12n7fasvrjN89dK3 RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0psh2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 21:17:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002LCNKW034525;
        Thu, 2 Jan 2020 21:15:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x9jm6m07k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 21:15:35 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 002LFPnO026383;
        Thu, 2 Jan 2020 21:15:26 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 13:15:24 -0800
Date:   Thu, 2 Jan 2020 13:15:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Pavel Reichl <preichl@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH v3 2/2] xfs: quota: move to time64_t interfaces
Message-ID: <20200102211523.GC1508633@magnolia>
References: <20200102204058.2005468-1-arnd@arndb.de>
 <20200102204058.2005468-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102204058.2005468-2-arnd@arndb.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001020170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001020170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 02, 2020 at 09:40:46PM +0100, Arnd Bergmann wrote:
> As a preparation for removing the 32-bit time_t type and
> all associated interfaces, change xfs to use time64_t and
> ktime_get_real_seconds() for the quota housekeeping.
> 
> This avoids one difference between 32-bit and 64-bit kernels,
> raising the theoretical limit for the quota grace period
> to year 2106 on 32-bit instead of year 2038.
> 
> Note that common user space tools using the XFS quotactl
> interface instead of the generic one still use the y2038
> dates.
> 
> To fix quotas properly, both the on-disk format and user
> space still need to be changed.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This has a small conflict against the series at
> https://www.spinics.net/lists/linux-xfs/msg35409.html
> ("xfs: widen timestamps to deal with y2038") which needs
> to be rebased on top of this.
> 
> All other changes to remove time_t and get_seconds()
> are now in linux-next, this is one of the last patches
> needed to remove their definitions for v5.6.
> 
> If the widened timestamps make it into v5.6, this patch
> can be dropped.

Not likely. :)

I'll give this series a spin,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dquot.c       | 6 +++---
>  fs/xfs/xfs_qm.h          | 6 +++---
>  fs/xfs/xfs_quotaops.c    | 6 +++---
>  fs/xfs/xfs_trans_dquot.c | 8 +++++---
>  4 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 2bff21ca9d78..9cfd3209f52b 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -137,7 +137,7 @@ xfs_qm_adjust_dqtimers(
>  		    (d->d_blk_hardlimit &&
>  		     (be64_to_cpu(d->d_bcount) >
>  		      be64_to_cpu(d->d_blk_hardlimit)))) {
> -			d->d_btimer = cpu_to_be32(get_seconds() +
> +			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
>  					mp->m_quotainfo->qi_btimelimit);
>  		} else {
>  			d->d_bwarns = 0;
> @@ -160,7 +160,7 @@ xfs_qm_adjust_dqtimers(
>  		    (d->d_ino_hardlimit &&
>  		     (be64_to_cpu(d->d_icount) >
>  		      be64_to_cpu(d->d_ino_hardlimit)))) {
> -			d->d_itimer = cpu_to_be32(get_seconds() +
> +			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
>  					mp->m_quotainfo->qi_itimelimit);
>  		} else {
>  			d->d_iwarns = 0;
> @@ -183,7 +183,7 @@ xfs_qm_adjust_dqtimers(
>  		    (d->d_rtb_hardlimit &&
>  		     (be64_to_cpu(d->d_rtbcount) >
>  		      be64_to_cpu(d->d_rtb_hardlimit)))) {
> -			d->d_rtbtimer = cpu_to_be32(get_seconds() +
> +			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
>  					mp->m_quotainfo->qi_rtbtimelimit);
>  		} else {
>  			d->d_rtbwarns = 0;
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 7823af39008b..4e57edca8bce 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -64,9 +64,9 @@ struct xfs_quotainfo {
>  	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
>  	struct list_lru	 qi_lru;
>  	int		 qi_dquots;
> -	time_t		 qi_btimelimit;	 /* limit for blks timer */
> -	time_t		 qi_itimelimit;	 /* limit for inodes timer */
> -	time_t		 qi_rtbtimelimit;/* limit for rt blks timer */
> +	time64_t	 qi_btimelimit;	 /* limit for blks timer */
> +	time64_t	 qi_itimelimit;	 /* limit for inodes timer */
> +	time64_t	 qi_rtbtimelimit;/* limit for rt blks timer */
>  	xfs_qwarncnt_t	 qi_bwarnlimit;	 /* limit for blks warnings */
>  	xfs_qwarncnt_t	 qi_iwarnlimit;	 /* limit for inodes warnings */
>  	xfs_qwarncnt_t	 qi_rtbwarnlimit;/* limit for rt blks warnings */
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index c7de17deeae6..38669e827206 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -37,9 +37,9 @@ xfs_qm_fill_state(
>  	tstate->flags |= QCI_SYSFILE;
>  	tstate->blocks = ip->i_d.di_nblocks;
>  	tstate->nextents = ip->i_d.di_nextents;
> -	tstate->spc_timelimit = q->qi_btimelimit;
> -	tstate->ino_timelimit = q->qi_itimelimit;
> -	tstate->rt_spc_timelimit = q->qi_rtbtimelimit;
> +	tstate->spc_timelimit = (u32)q->qi_btimelimit;
> +	tstate->ino_timelimit = (u32)q->qi_itimelimit;
> +	tstate->rt_spc_timelimit = (u32)q->qi_rtbtimelimit;
>  	tstate->spc_warnlimit = q->qi_bwarnlimit;
>  	tstate->ino_warnlimit = q->qi_iwarnlimit;
>  	tstate->rt_spc_warnlimit = q->qi_rtbwarnlimit;
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index a6fe2d8dc40f..d1b9869bc5fa 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -580,7 +580,7 @@ xfs_trans_dqresv(
>  {
>  	xfs_qcnt_t		hardlimit;
>  	xfs_qcnt_t		softlimit;
> -	time_t			timer;
> +	time64_t		timer;
>  	xfs_qwarncnt_t		warns;
>  	xfs_qwarncnt_t		warnlimit;
>  	xfs_qcnt_t		total_count;
> @@ -635,7 +635,8 @@ xfs_trans_dqresv(
>  				goto error_return;
>  			}
>  			if (softlimit && total_count > softlimit) {
> -				if ((timer != 0 && get_seconds() > timer) ||
> +				if ((timer != 0 &&
> +				     ktime_get_real_seconds() > timer) ||
>  				    (warns != 0 && warns >= warnlimit)) {
>  					xfs_quota_warn(mp, dqp,
>  						       QUOTA_NL_BSOFTLONGWARN);
> @@ -662,7 +663,8 @@ xfs_trans_dqresv(
>  				goto error_return;
>  			}
>  			if (softlimit && total_count > softlimit) {
> -				if  ((timer != 0 && get_seconds() > timer) ||
> +				if  ((timer != 0 &&
> +				      ktime_get_real_seconds() > timer) ||
>  				     (warns != 0 && warns >= warnlimit)) {
>  					xfs_quota_warn(mp, dqp,
>  						       QUOTA_NL_ISOFTLONGWARN);
> -- 
> 2.20.0
> 
