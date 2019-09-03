Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957EBC3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 15:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66D2A23431
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 15:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K0s++cTn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbfICPVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 11:21:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55202 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729537AbfICPVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 11:21:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83FG3Fs160811;
        Tue, 3 Sep 2019 15:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=869p3klhxOWoSRwfDTA+aY5yiVHTTslfctwPq9J8bY0=;
 b=K0s++cTnj9jxu3jAzrwUgqXfOmT0ugXi6w8uBKxiwlxdeItgQP1jXsxOu6sf+R5ZjphZ
 C3AaK7QCUdEhKXuRVgTrQLiZw6m0VDajlfDg1tKuWWCcDuHV+RIN9skXdwNU8e/BSGyn
 nrX25gB1sxHk5RtfPAL1htKXbj7Xt2a3CSUW6wf2eje93Nib3nJ9sksOUeEyX0/zCIob
 +Rd0l9nIkIXRseZ0kVnRqIMvJoYgCZUUCOn8EKfMLSti4Jvjqbv1iJX1nhtED1Bc2X62
 DD7UtjgAhXqkWR7xD09Zig9Bjc6WaDugQLyjKpgAyNQFx9oROToRymhErUzSYSRYWiub DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ustnn81u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 15:20:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83F9goh095168;
        Tue, 3 Sep 2019 15:20:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2uryv6vse1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 15:20:53 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83FKn7B016932;
        Tue, 3 Sep 2019 15:20:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 08:20:49 -0700
Date:   Tue, 3 Sep 2019 08:20:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     yu kuai <yukuai3@huawei.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengbin13@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH v2] xfs: revise function comment for xfs_trans_ail_delete
Message-ID: <20190903152048.GZ5354@magnolia>
References: <1567243423-59571-1-git-send-email-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567243423-59571-1-git-send-email-yukuai3@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 31, 2019 at 05:23:43PM +0800, yu kuai wrote:
> Since xfs_trans_ail_delete_bulk no longer exists, revising the comment
> for new function xfs_trans_ail_delete.
> 
> Fix following warning:
> make W=1 fs/xfs/xfs_trans_ail.o
> fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member 
> 'ailp' not described in 'xfs_trans_ail_delete'
> fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member
> 'lip' not described in 'xfs_trans_ail_delete'
> fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member
> 'shutdown_type' not described in 'xfs_trans_ail_delete'
> 
> Fixes:27af1bbf5244("xfs: remove xfs_trans_ail_delete_bulk")
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> ---
>  fs/xfs/xfs_trans_ail.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 6ccfd75..6c43b66e 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -765,25 +765,20 @@ xfs_ail_delete_one(
>  }
>  
> -/**
> - * Remove a log items from the AIL
> +/*
> + * xfs_trans_ail_delet - remove a log item from the AIL

Function name misspelled.

> - * @xfs_trans_ail_delete_bulk takes an array of log items that all need to
> - * removed from the AIL. The caller is already holding the AIL lock, and done
> - * all the checks necessary to ensure the items passed in via @log_items are
> - * ready for deletion. This includes checking that the items are in the AIL.
> + * @xfs_trans_ail_delete takes a log item that needs to be removed from the
> + * AIL. The caller is already holding the AIL lock, and done all the checks
> + * necessary to ensure the item passed in via @lip are ready for deletion.
> + * This includes checking that the items are in the AIL.
>   *
> - * For each log item to be removed, unlink it  from the AIL, clear the IN_AIL
> - * flag from the item and reset the item's lsn to 0. If we remove the first
> - * item in the AIL, update the log tail to match the new minimum LSN in the
> - * AIL.
> + * For the log item to be removed, call xfs_ail_delete_one to unlink it
> + * from the AIL, clear the IN_AIL flag from the item and reset the item's
> + * lsn to 0. If we remove the first item in the AIL, update the log tail
> + * to match the new minimum LSN in the AIL.

FWIW, now that this is a 30-line function I don't think it helps at all
to describe what the function does.  We mostly care about things that
might not be immediately obvious from reading the function, such as
preconditions and whatever side effects the function has.

/*
 * Remove a log item from the AIL.
 *
 * The caller must already hold the AIL lock and is responsible for
 * ensuring that the item is in the AIL and ready for deletion.  The log
 * item's LSN will be reset to 0, and if it was the first item in the
 * AIL, the log tail will be updated to match the new minimum LSN in the
 * AIL.  The AIL lock will be dropped before returning.
 */
void
xfs_trans_ail_delete(

--D

>   *
> - * This function will not drop the AIL lock until all items are removed from
> - * the AIL to minimise the amount of lock traffic on the AIL. This does not
> - * greatly increase the AIL hold time, but does significantly reduce the amount
> - * of traffic on the lock, especially during IO completion.
> - *
> - * This function must be called with the AIL lock held.  The lock is dropped
> - * before returning.
> + * This function must be called with the AIL lock held. The lock will be
> + * dropped before returning.
>   */
>  void
>  xfs_trans_ail_delete(
> -- 
> 2.7.4
> 
