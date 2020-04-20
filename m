Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2B5C3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 18:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33DEE2084D
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 18:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TSSc2Ylw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgDTSue (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 14:50:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43584 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgDTSue (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 14:50:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KImvsA153951;
        Mon, 20 Apr 2020 18:50:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pysMO4PNTX31e+1RKc05JKGGt/1vt+Xh3J90QQC22NQ=;
 b=TSSc2YlwYq53UVQ8FymUmGOoSTGEeNxfLNQcp7uo3/TrCGFxS1wX4SQTUWDWxY1gP9yB
 k8/xbs9a9S2sWLS/neW6Q13+8UeeixCIPwqcTMqlS1r6XeKYz7OvoR/wfykmzI406RBJ
 l96YvhGpTRSXvmRjKMBzqCic21xlSbYc/ol1+8Cv8EUYMGqpAONaMCg9do8lb8cuneZe
 dx9kVY3FJ5sSb8Ah4Pjj7Ih6Vpep2yWSuZXWAJh9Gm36QBivYc82xRZBy/9Os13Cq/rp
 CWP9RmnJykQNLWcm4XWNvjdocJsfHaQRO9kT2lJDaTUG9C36TyrgDAlLqXrxFXAFidF2 pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30grpgdg88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 18:50:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KIg9k5106845;
        Mon, 20 Apr 2020 18:50:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30gb1dw45k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 18:50:30 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03KIoUh2003249;
        Mon, 20 Apr 2020 18:50:30 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 11:50:29 -0700
Subject: Re: [PATCH 07/12] xfs: abort consistently on dquot flush failure
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-8-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <4a0e1947-f696-93e1-94e6-643fb6cb13c6@oracle.com>
Date:   Mon, 20 Apr 2020 11:50:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200417150859.14734-8-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/17/20 8:08 AM, Brian Foster wrote:
> The dquot flush handler effectively aborts the dquot flush if the
> filesystem is already shut down, but doesn't actually shut down if
> the flush fails. Update xfs_qm_dqflush() to consistently abort the
> dquot flush and shutdown the fs if the flush fails with an
> unexpected error.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Ok, makes sense:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_dquot.c | 27 ++++++++-------------------
>   1 file changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 73032c18a94a..41750f797861 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1068,6 +1068,7 @@ xfs_qm_dqflush(
>   	struct xfs_buf		**bpp)
>   {
>   	struct xfs_mount	*mp = dqp->q_mount;
> +	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
>   	struct xfs_buf		*bp;
>   	struct xfs_dqblk	*dqb;
>   	struct xfs_disk_dquot	*ddqp;
> @@ -1082,32 +1083,16 @@ xfs_qm_dqflush(
>   
>   	xfs_qm_dqunpin_wait(dqp);
>   
> -	/*
> -	 * This may have been unpinned because the filesystem is shutting
> -	 * down forcibly. If that's the case we must not write this dquot
> -	 * to disk, because the log record didn't make it to disk.
> -	 *
> -	 * We also have to remove the log item from the AIL in this case,
> -	 * as we wait for an emptry AIL as part of the unmount process.
> -	 */
> -	if (XFS_FORCED_SHUTDOWN(mp)) {
> -		struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
> -		dqp->dq_flags &= ~XFS_DQ_DIRTY;
> -
> -		xfs_trans_ail_remove(lip, SHUTDOWN_CORRUPT_INCORE);
> -
> -		error = -EIO;
> -		goto out_unlock;
> -	}
> -
>   	/*
>   	 * Get the buffer containing the on-disk dquot
>   	 */
>   	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
>   				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
>   				   &bp, &xfs_dquot_buf_ops);
> -	if (error)
> +	if (error == -EAGAIN)
>   		goto out_unlock;
> +	if (error)
> +		goto out_abort;
>   
>   	/*
>   	 * Calculate the location of the dquot inside the buffer.
> @@ -1161,6 +1146,10 @@ xfs_qm_dqflush(
>   	*bpp = bp;
>   	return 0;
>   
> +out_abort:
> +	dqp->dq_flags &= ~XFS_DQ_DIRTY;
> +	xfs_trans_ail_remove(lip, SHUTDOWN_CORRUPT_INCORE);
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>   out_unlock:
>   	xfs_dqfunlock(dqp);
>   	return error;
> 
