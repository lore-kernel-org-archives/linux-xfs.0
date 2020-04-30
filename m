Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C514C4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 19:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D5D42073E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 19:01:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0Djc5jDh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgD3TBr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 15:01:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgD3TBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 15:01:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UInSEu063991;
        Thu, 30 Apr 2020 19:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3gHWkVZodubye0eFoxCdfSv5toGUH4OGGfXi85Wi8og=;
 b=0Djc5jDh1XNS1TPKP9A7MKgm6DBz8YoCKKHxyHX/HCGzUlQnicJtwqQDWwQRjUE4TvgR
 hlUrvaNgXsF1HDqH75s9fLIFt5SYZQ4dw2aHtNF5VwvJc2KIq1sdaNv5JEgyYHJ2taJK
 /eQvc7tqJDF6Z9PQZ9iHdgxuJj1hkzvGUhNANMPGQKNlucBGc6nmHePsGwyzoQ928Ea3
 Rb/SR+josvGQICIC8OwPi+HpWilGYDvtCjKpx666wGV/18n+RThIwC+mOgcbsn/YubQb
 IqFgjrVp/aBWa4xO7AHLVW9aTgc2TM44LcRzw4iQCTMNPtVami9emPadmlqx/kQmOC/B gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30p2p0jrv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 19:01:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIkTg0052610;
        Thu, 30 Apr 2020 18:59:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30qtkx12pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:59:43 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UIxgpp009753;
        Thu, 30 Apr 2020 18:59:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:59:42 -0700
Date:   Thu, 30 Apr 2020 11:59:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 16/17] xfs: remove unused shutdown types
Message-ID: <20200430185941.GQ6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-17-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-17-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:52PM -0400, Brian Foster wrote:
> Both types control shutdown messaging and neither is used in the
> current codebase.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_fsops.c | 5 +----
>  fs/xfs/xfs_mount.h | 2 --
>  2 files changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 3e61d0cc23f8..ef1d5bb88b93 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -504,10 +504,7 @@ xfs_do_force_shutdown(
>  	} else if (logerror) {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
>  			"Log I/O Error Detected. Shutting down filesystem");
> -	} else if (flags & SHUTDOWN_DEVICE_REQ) {
> -		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
> -			"All device paths lost. Shutting down filesystem");
> -	} else if (!(flags & SHUTDOWN_REMOTE_REQ)) {
> +	} else {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
>  			"I/O Error Detected. Shutting down filesystem");
>  	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index b2e4598fdf7d..07b5ba7e5fbd 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -259,8 +259,6 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>  #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
>  #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
>  #define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
> -#define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
> -#define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
>  
>  /*
>   * Flags for xfs_mountfs
> -- 
> 2.21.1
> 
