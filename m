Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792B3C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 23:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 421F92071C
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 23:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QrAoMWW0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgCLXwQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 19:52:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgCLXwQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 19:52:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNi3EE012533;
        Thu, 12 Mar 2020 23:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VtE1MUp8j1UFYKZSWyFJ2WUCxBPKHXBdeLSIHby1WFM=;
 b=QrAoMWW08FS47xhvG6L1KfvGfV3dx+rcRDQBPY8rYyykjI8H7cOzklDDvxgu2Gfb2Yiq
 RD3VSOFaJLiQ7q/uPaE03F09mqnP/udA6i8vEvG2byAQ6IVaI7XBLT+jpgzNf5/DhCvg
 0pdQmh7n0sP4a8vunDrGX2f0fXI4dLJjKWOJhRmEgVJpBnrTp4a8ewi+uD+MnpOcktsL
 SDj6lapcqApYuxQtnof0RjcIJEZoHbBC2KP+X0nnvJo2qkP+UWZFJ5hVHZFIwbVKKwtH
 VPFDsnvs4uNeMPsxn65OBl4rj+KxCVRx9w2xNP3lDq833SaLrQSz9Ngi5iOtYsUyFLBj 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yqtag95ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:52:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNq9mb158652;
        Thu, 12 Mar 2020 23:52:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yqtabaqyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:52:09 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02CNq2TA014253;
        Thu, 12 Mar 2020 23:52:02 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 16:52:02 -0700
Date:   Thu, 12 Mar 2020 16:52:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: cleanup xfs_log_unmount_write
Message-ID: <20200312235201.GW8045@magnolia>
References: <20200312143959.583781-1-hch@lst.de>
 <20200312143959.583781-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312143959.583781-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:39:59PM +0100, Christoph Hellwig wrote:
> Move the code for verifying the iclog state on a clean unmount into a
> helper, and instead of checking the iclog state just rely on the shutdown
> check as they are equivalent.  Also remove the ifdef DEBUG as the
> compiler is smart enough to eliminate the dead code for non-debug builds.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks fine , will test
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b56432d4a9b8..0986983ef6b5 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -946,6 +946,18 @@ xfs_log_write_unmount_record(
>  	}
>  }
>  
> +static void
> +xfs_log_unmount_verify_iclog(
> +	struct xlog		*log)
> +{
> +	struct xlog_in_core	*iclog = log->l_iclog;
> +
> +	do {
> +		ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
> +		ASSERT(iclog->ic_offset == 0);
> +	} while ((iclog = iclog->ic_next) != log->l_iclog);
> +}
> +
>  /*
>   * Unmount record used to have a string "Unmount filesystem--" in the
>   * data section where the "Un" was really a magic number (XLOG_UNMOUNT_TYPE).
> @@ -954,13 +966,10 @@ xfs_log_write_unmount_record(
>   * As far as I know, there weren't any dependencies on the old behaviour.
>   */
>  static void
> -xfs_log_unmount_write(xfs_mount_t *mp)
> +xfs_log_unmount_write(
> +	struct xfs_mount	*mp)
>  {
> -	struct xlog	 *log = mp->m_log;
> -	xlog_in_core_t	 *iclog;
> -#ifdef DEBUG
> -	xlog_in_core_t	 *first_iclog;
> -#endif
> +	struct xlog		*log = mp->m_log;
>  
>  	/*
>  	 * Don't write out unmount record on norecovery mounts or ro devices.
> @@ -974,18 +983,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> -#ifdef DEBUG
> -	first_iclog = iclog = log->l_iclog;
> -	do {
> -		if (iclog->ic_state != XLOG_STATE_IOERROR) {
> -			ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
> -			ASSERT(iclog->ic_offset == 0);
> -		}
> -		iclog = iclog->ic_next;
> -	} while (iclog != first_iclog);
> -#endif
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return;
> +	xfs_log_unmount_verify_iclog(log);
>  	xfs_log_write_unmount_record(mp);
>  }
>  
> -- 
> 2.24.1
> 
