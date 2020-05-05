Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D813C47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 23:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32DFC20721
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 23:37:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ishZY5A2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgEEXhg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 19:37:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43546 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgEEXhg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 19:37:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045NX9l8170948;
        Tue, 5 May 2020 23:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dXknrpv2/mCMfefCscn8OxOHXmhmfel7tKv5rQLfXuA=;
 b=ishZY5A2OO0myW/c3FDUumv2+5akqmIP52uWuL3V86q/yOcdfm/aBKpKfuVt59FAd/bW
 I37jTdrhb5TTbEHhoaLgG3eNoKGWWul8bDOyNmkUepJn4ksONFy4yPUDm8VRwZW0kkpN
 MfvmDOCAmM8yb/qctNz+fzym+lha04A/zd5eVNkNLGq+Eqkhi9F75CxBlvLHt3aPKOYy
 O7/ZzTCXZ9HSy/Timftj4kgKGcDk9zym0ZV4rWPWIiiPYT8R5uy+GSgcwOIu7SlBq8u+
 6TJ3Mw5g+tBihX8TOdTyyTFnMjLdXwvJhh1inqsksB+mdZvI5ecThJwdWcr0mg+29qZo fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30s0tmfjax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 23:37:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045Naiho036042;
        Tue, 5 May 2020 23:37:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30sjk0tmxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 23:37:32 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045NbVJU017629;
        Tue, 5 May 2020 23:37:31 GMT
Received: from [192.168.1.223] (/67.1.142.158) by default (Oracle Beehive
 Gateway v4.0) with ESMTP ; Tue, 05 May 2020 16:37:31 -0700
USER-AGENT: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Content-Language: en-US
MIME-Version: 1.0
Message-ID: <e5c6a311-9fb2-926b-6753-b7ad02cbeddb@oracle.com>
Date:   Tue, 5 May 2020 23:37:30 +0000 (UTC)
From:   Allison Collins <allison.henderson@oracle.com>
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 16/17] xfs: remove unused shutdown types
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504141154.55887-17-bfoster@redhat.com>
In-Reply-To: <20200504141154.55887-17-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 7:11 AM, Brian Foster wrote:
> Both types control shutdown messaging and neither is used in the
> current codebase.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com
Looks ok to me:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_fsops.c | 5 +----
>   fs/xfs/xfs_mount.h | 2 --
>   2 files changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 3e61d0cc23f8..ef1d5bb88b93 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -504,10 +504,7 @@ xfs_do_force_shutdown(
>   	} else if (logerror) {
>   		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
>   			"Log I/O Error Detected. Shutting down filesystem");
> -	} else if (flags & SHUTDOWN_DEVICE_REQ) {
> -		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
> -			"All device paths lost. Shutting down filesystem");
> -	} else if (!(flags & SHUTDOWN_REMOTE_REQ)) {
> +	} else {
>   		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
>   			"I/O Error Detected. Shutting down filesystem");
>   	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index b2e4598fdf7d..07b5ba7e5fbd 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -259,8 +259,6 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>   #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
>   #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
>   #define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
> -#define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
> -#define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
>   
>   /*
>    * Flags for xfs_mountfs
> 
