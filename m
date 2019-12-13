Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A2EC43603
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 21:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B29820706
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 21:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OxZ3p2II"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfLMVRp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 16:17:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38110 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfLMVRp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 16:17:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDKshQ7108025;
        Fri, 13 Dec 2019 21:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=oesZI75gmBt4FukJkz56K6kL2TW4TKvjPRgfVUdvuro=;
 b=OxZ3p2II0dJXIUlJsj+pFuBQ0sezUPBzeU/ldtC6JJcS/0ipFL7J43/vn2inv+YYEkn5
 mZr0x6t9EjA23/mDS09C1gipFA88oZlF+1av0qmAjG/954YS5JdSdZzXCc8SDUpmA3ZS
 xw3XJyp8yKRhwLs2jqf1TiIPGF6lR73CqdI0arRLadX+XXvKly/wRr4nIqyyZEG8Ijpo
 1xc1R6gymStP80l0DaXrylXFxaZ7mRb5YtDtu7uTmyR0R11emoF7MsfoEe6c5WENhOs7
 OvochFm3thNA9vr8Xv7DSbEyh4mOw59cj3/byouAXabHQt3PSlYDPmpYmSMyGM/VGuhx 5Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wrw4nr95p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 21:17:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDKsdpm067622;
        Fri, 13 Dec 2019 21:17:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wvdtvdc8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 21:17:32 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBDLHUUJ002598;
        Fri, 13 Dec 2019 21:17:30 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 13:17:30 -0800
Date:   Fri, 13 Dec 2019 13:17:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 21/24] xfs: quota: move to time64_t interfaces
Message-ID: <20191213211728.GL99875@magnolia>
References: <20191213204936.3643476-1-arnd@arndb.de>
 <20191213205417.3871055-12-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213205417.3871055-12-arnd@arndb.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 09:53:49PM +0100, Arnd Bergmann wrote:
> As a preparation for removing the 32-bit time_t type and
> all associated interfaces, change xfs to use time64_t and
> ktime_get_real_seconds() for the quota housekeeping.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks mostly reasonable to me...

The bigtime series refactors the triplicated timer handling and whatnot,
but I don't think it would be difficult to rebase that series assuming
this lands first (which it probably will, I expect a new incompat ondisk
feature to take a /long/ time to get through review.)

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

Hmm, so one thing that I clean up on the way to bigtime is the total
lack of clamping here.  If (for example) it's September 2105 and
rtbtimelimit is set to 1 year, this will cause an integer overflow.  The
quota timer will be set to 1970 and expire immediately, rather than what
I'd consider the best effort of February 2106.

(I'll grant you the current code also behaves like this...)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
