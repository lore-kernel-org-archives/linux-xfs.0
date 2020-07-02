Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8733C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 02:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C236A206DD
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 02:06:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AmW3RZi7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgGBCGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:06:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgGBCGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 22:06:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621wwm5180380
        for <linux-xfs@vger.kernel.org>; Thu, 2 Jul 2020 02:06:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wWnjZPHafSDB8//OpaZTyVeJxnVDPlEJcb2odF1N4zs=;
 b=AmW3RZi7ecuNlaMYo6IHWAknzQ2Z9D7VnGXGOxP7eER9xZ3NfthrNoF9JwYi1ZLVzMjO
 MlYNiwY7QP50ca1sHmhgp9gUm4PEBITfIoeVM3ETaASDrRLMQ1Ras2JP/O6N/K1AFjOg
 X3SyiwT5CCDAyaiUE57sGQ0dSBtxH+fRH/+UZt6btBHLaQgVq6Mk5ZyTEotei5p9ZJ9W
 a9DZ12biAjMLMhbD24Lyie4apUAy6kV7grk3rPEB4VjLo/hGmAScUgfic6rQpqsSwrdf
 hsDQKxpZD5/Hu5Tom6pkssKegWs9G+K7OaiWb+L0YDOjhz/oyrcxv5iCdfJOIKofYBPU zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrndq40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2020 02:06:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621wdS3039502
        for <linux-xfs@vger.kernel.org>; Thu, 2 Jul 2020 02:06:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31xfvusyqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2020 02:06:34 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06226YSM006755
        for <linux-xfs@vger.kernel.org>; Thu, 2 Jul 2020 02:06:34 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 02:06:33 +0000
Subject: Re: [PATCH 11/18] xfs: remove qcore from incore dquots
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353178119.2864738.14352743945962585449.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <ad8941db-25de-a2a0-f0e8-4e8827b6ad8b@oracle.com>
Date:   Wed, 1 Jul 2020 19:06:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353178119.2864738.14352743945962585449.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:43 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've stopped using qcore entirely, drop it from the incore
> dquot.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/scrub/quota.c |    4 ----
>   fs/xfs/xfs_dquot.c   |   29 +++++++++--------------------
>   fs/xfs/xfs_dquot.h   |    1 -
>   3 files changed, 9 insertions(+), 25 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 2fc2625feca0..f4aad5b00188 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -79,7 +79,6 @@ xchk_quota_item(
>   	struct xchk_quota_info	*sqi = priv;
>   	struct xfs_scrub	*sc = sqi->sc;
>   	struct xfs_mount	*mp = sc->mp;
> -	struct xfs_disk_dquot	*d = &dq->q_core;
>   	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>   	xfs_fileoff_t		offset;
>   	xfs_ino_t		fs_icount;
> @@ -98,9 +97,6 @@ xchk_quota_item(
>   
>   	sqi->last_id = dq->q_id;
>   
> -	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
> -		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
> -
>   	/*
>   	 * Warn if the hard limits are larger than the fs.
>   	 * Administrators can do this, though in production this seems
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 7434ee57ec43..2d6b50760962 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -529,7 +529,6 @@ xfs_dquot_from_disk(
>   	}
>   
>   	/* copy everything from disk dquot to the incore dquot */
> -	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
>   	dqp->q_blk.hardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
>   	dqp->q_blk.softlimit = be64_to_cpu(ddqp->d_blk_softlimit);
>   	dqp->q_ino.hardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
> @@ -568,8 +567,13 @@ xfs_dquot_to_disk(
>   	struct xfs_disk_dquot	*ddqp,
>   	struct xfs_dquot	*dqp)
>   {
> -	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
> +	ddqp->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
> +	ddqp->d_version = XFS_DQUOT_VERSION;
>   	ddqp->d_flags = dqp->dq_flags & XFS_DQ_ONDISK;
> +	ddqp->d_id = cpu_to_be32(dqp->q_id);
> +	ddqp->d_pad0 = 0;
> +	ddqp->d_pad = 0;
> +
>   	ddqp->d_blk_hardlimit = cpu_to_be64(dqp->q_blk.hardlimit);
>   	ddqp->d_blk_softlimit = cpu_to_be64(dqp->q_blk.softlimit);
>   	ddqp->d_ino_hardlimit = cpu_to_be64(dqp->q_ino.hardlimit);
> @@ -1180,7 +1184,6 @@ xfs_qm_dqflush(
>   	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
>   	struct xfs_buf		*bp;
>   	struct xfs_dqblk	*dqb;
> -	struct xfs_disk_dquot	*ddqp;
>   	xfs_failaddr_t		fa;
>   	int			error;
>   
> @@ -1204,22 +1207,6 @@ xfs_qm_dqflush(
>   	if (error)
>   		goto out_abort;
>   
> -	/*
> -	 * Calculate the location of the dquot inside the buffer.
> -	 */
> -	dqb = bp->b_addr + dqp->q_bufoffset;
> -	ddqp = &dqb->dd_diskdq;
> -
> -	/* sanity check the in-core structure before we flush */
> -	fa = xfs_dquot_verify(mp, &dqp->q_core, dqp->q_id, 0);
> -	if (fa) {
> -		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> -				dqp->q_id, fa);
> -		xfs_buf_relse(bp);
> -		error = -EFSCORRUPTED;
> -		goto out_abort;
> -	}
> -
>   	fa = xfs_qm_dqflush_check(dqp);
>   	if (fa) {
>   		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> @@ -1229,7 +1216,9 @@ xfs_qm_dqflush(
>   		goto out_abort;
>   	}
>   
> -	xfs_dquot_to_disk(ddqp, dqp);
> +	/* Flush the incore dquot to the ondisk buffer. */
> +	dqb = bp->b_addr + dqp->q_bufoffset;
> +	xfs_dquot_to_disk(&dqb->dd_diskdq, dqp);
>   
>   	/*
>   	 * Clear the dirty field and remember the flush lsn for later use.
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 414bae537b1d..62b0fc6e0133 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -71,7 +71,6 @@ struct xfs_dquot {
>   	struct xfs_dquot_res	q_ino;	/* inodes */
>   	struct xfs_dquot_res	q_rtb;	/* realtime blocks */
>   
> -	struct xfs_disk_dquot	q_core;
>   	struct xfs_dq_logitem	q_logitem;
>   
>   	xfs_qcnt_t		q_prealloc_lo_wmark;
> 
