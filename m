Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12907C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 18:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF91F233FD
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 18:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbhAGSfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 13:35:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49458 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbhAGSfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 13:35:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107IT3N5019662;
        Thu, 7 Jan 2021 18:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DeK9Qd5stY1eODcH1qbidxZIRWCaXklJeruGVMMLyeI=;
 b=B6mQjf/MjFpbs1Hzi+kvYYKrnDy/W7JVqzjJHg1r5K41k+AIyEeenP0UQRuf2RxNxnFf
 mv8g0LHB0l1U0w6+ADEY5s8GzyYnsr7HY7np9oNPXS4BrVx1zugTKcc0z1PCzY93i4sT
 SmfEKvM+p03l1YLyzz2JNmUMu2lyuDj2bqbFeLA8tIjRqurQps1k7FF841ihKpbyGG04
 Sz2BjmOoSbVwp/rV4wShN47Uqg5Ef8ANfojtrPjhGhbkVWQPPM1Nr052ndBClZruNFny
 JiufUY4bi6DPvpWc+Awxi3eY+2uf6+QyW1dkYGNvT3lKWGuEWOLpAH+kpM1XqXJU4hwe Ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35wepmdrhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 18:34:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107IUgL1162055;
        Thu, 7 Jan 2021 18:34:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35w3qu34sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 18:34:24 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 107IYNjW004323;
        Thu, 7 Jan 2021 18:34:23 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 10:34:23 -0800
Date:   Thu, 7 Jan 2021 10:34:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: lift writable fs check up into log worker task
Message-ID: <20210107183422.GN38809@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-3-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070108
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:20PM -0500, Brian Foster wrote:
> The log covering helper checks whether the filesystem is writable to
> determine whether to cover the log. The helper is currently only
> called from the background log worker. In preparation to reuse the
> helper from freezing contexts, lift the check into xfs_log_worker().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b445e63cbc3c..4137ed007111 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1050,13 +1050,11 @@ xfs_log_space_wake(
>   * can't start trying to idle the log until both the CIL and AIL are empty.
>   */
>  static int

I think this is a predicate, right?  Should this function return a bool
instead of an int?

This function always confuses me slightly since it pushes us through the
covering state machine, and (I think) assumes that someone will force
the CIL and push the AIL if it returns zero. :)

To check my thinking further-- back in that thread I started about
setting and clearing log incompat flags, I think Dave was pushing me to
clear the log incompat flags just before we call xfs_sync_sb when the
log is in NEED2 state, right?

AFAICT the net effect of this series is to reorder the log code so that
xfs_log_quiesce covers the log (force cil, push ail, log two
transactions containing only the superblock), and adds an xfs_log_clean
that quiesces the log and then writes an unmount record after that.

Two callers whose behavior does not change with this series are: 1) The
log worker quiesces the log when it's idle; and 2) unmount quiesces the
log and then writes an unmount record so that the next mount knows it
can skip replay entirely.

The big difference is 3) freeze now only covers the log, whereas before
it would cover, write an unmount record, and immediately redirty the log
to force replay of the snapshot, right?

Assuming I understood all that, my next question is: Eric Sandeen was
working on a patchset to process unlinked inodes unconditionally on
mount so that frozen fs images can be written out with the unmount
record (because I guess people make ro snapshots of live fs images and
then balk when they have to make the snapshot rw to run log recovery.
Any thoughts about /that/? :)

--D

> -xfs_log_need_covered(xfs_mount_t *mp)
> +xfs_log_need_covered(
> +	struct xfs_mount	*mp)
>  {
> -	struct xlog	*log = mp->m_log;
> -	int		needed = 0;
> -
> -	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
> -		return 0;
> +	struct xlog		*log = mp->m_log;
> +	int			needed = 0;
>  
>  	if (!xlog_cil_empty(log))
>  		return 0;
> @@ -1271,7 +1269,7 @@ xfs_log_worker(
>  	struct xfs_mount	*mp = log->l_mp;
>  
>  	/* dgc: errors ignored - not fatal and nowhere to report them */
> -	if (xfs_log_need_covered(mp)) {
> +	if (xfs_fs_writable(mp, SB_FREEZE_WRITE) && xfs_log_need_covered(mp)) {
>  		/*
>  		 * Dump a transaction into the log that contains no real change.
>  		 * This is needed to stamp the current tail LSN into the log
> -- 
> 2.26.2
> 
