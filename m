Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01232C4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96BA120882
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T5UMRpyH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgJGWJv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 18:09:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36742 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgJGWJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 18:09:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097LnwV6028390;
        Wed, 7 Oct 2020 22:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3kOXb6HUgv5r+AZYU+U46vrZ+o99I1Mk0mT3qKhSTFA=;
 b=T5UMRpyHIJZN1xHRcxzCPQNmrpcI413sHimZGUTdCu9qzWXgbYGC6jYS042A21oHPgug
 vPBSjQMR4CqnV1eU8hn4o1yXABsvP/3OjFFWT1I3hSxujv0AQV3QKjSTIWzvxqjCV214
 9FixOtwcfb4j7rJJvTYuC/ow5N4O7AnGVGz5l2vk3ssYKkDQgy/LHhzNPwDvn40VHEqk
 ZPJnDJQwlfsvxEOZpuw8WoAuSyd0ZZchhEgRhfLSMAC5fiSHeSIXB52oHDWcKlE3tT36
 idG5A5yZeVQ2cO2fsETTyOfi+abFVDiqZLm9V127sxX3zyZtfGI0owObdDdHuewIT/Bx 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34sr2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 22:09:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097LpKsu146328;
        Wed, 7 Oct 2020 22:09:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vq26gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 22:09:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097M9lT0019993;
        Wed, 7 Oct 2020 22:09:47 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 15:09:47 -0700
Date:   Wed, 7 Oct 2020 15:09:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: skip dquot reservations if quota is inactive
Message-ID: <20201007220945.GE6540@magnolia>
References: <20201001150310.141467-1-bfoster@redhat.com>
 <20201001150310.141467-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001150310.141467-2-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070139
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 11:03:08AM -0400, Brian Foster wrote:
> The dquot reservation helper currently performs the associated
> reservation for any provided dquots. The dquots could have been
> acquired from inode references or explicit dquot allocation
> requests. Some reservation callers may have already checked that the
> associated quota subsystem is active (xfs_qm_dqget() returns an
> error otherwise), while others might not have checked at all
> (xfs_trans_reserve_quota_nblks() passes the inode references).
> Further, subsequent dquot modifications do actually check that the
> associated quota is active before making transactional changes
> (xfs_trans_mod_dquot_byino()).
> 
> Given all of that, the behavior to unconditionally perform
> reservation on any provided dquots is somewhat ad hoc. While it is
> currently harmless, it is not without side effect. If the quota is
> inactive by the time a transaction attempts a quota reservation, the
> dquot will be attached to the transaction and subsequently logged,
> even though no dquot modifications are ultimately made.
> 
> This is a problem for upcoming quotaoff changes that intend to
> implement a strict transactional barrier for logging dquots during a
> quotaoff operation. If a dquot is logged after the subsystem
> deactivated and the barrier released, a subsequent log recovery can
> incorrectly replay dquot changes into the filesystem.
> 
> Therefore, update the dquot reservation path to also check that a
> particular quota mode is active before associating a dquot with a
> transaction. This should have no noticeable impact on the current
> code that already accommodates checking active quota state at points
> before and after quota reservations are made.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Seems reasonable not to bother with the dqresv step if the quota type
isn't enabled.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans_dquot.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 133fc6fc3edd..547ba824542e 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -39,14 +39,12 @@ xfs_trans_dqjoin(
>  }
>  
>  /*
> - * This is called to mark the dquot as needing
> - * to be logged when the transaction is committed.  The dquot must
> - * already be associated with the given transaction.
> - * Note that it marks the entire transaction as dirty. In the ordinary
> - * case, this gets called via xfs_trans_commit, after the transaction
> - * is already dirty. However, there's nothing stop this from getting
> - * called directly, as done by xfs_qm_scall_setqlim. Hence, the TRANS_DIRTY
> - * flag.
> + * This is called to mark the dquot as needing to be logged when the transaction
> + * is committed. The dquot must already be associated with the given
> + * transaction. Note that it marks the entire transaction as dirty. In the
> + * ordinary case, this gets called via xfs_trans_commit, after the transaction
> + * is already dirty. However, there's nothing stop this from getting called
> + * directly, as done by xfs_qm_scall_setqlim. Hence, the TRANS_DIRTY flag.
>   */
>  void
>  xfs_trans_log_dquot(
> @@ -770,19 +768,19 @@ xfs_trans_reserve_quota_bydquots(
>  
>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  
> -	if (udqp) {
> +	if (XFS_IS_UQUOTA_ON(mp) && udqp) {
>  		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos, flags);
>  		if (error)
>  			return error;
>  	}
>  
> -	if (gdqp) {
> +	if (XFS_IS_GQUOTA_ON(mp) && gdqp) {
>  		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
>  		if (error)
>  			goto unwind_usr;
>  	}
>  
> -	if (pdqp) {
> +	if (XFS_IS_PQUOTA_ON(mp) && pdqp) {
>  		error = xfs_trans_dqresv(tp, mp, pdqp, nblks, ninos, flags);
>  		if (error)
>  			goto unwind_grp;
> -- 
> 2.25.4
> 
