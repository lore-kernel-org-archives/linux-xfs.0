Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFA4C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 21:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBB712053B
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 21:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UOpYOjOv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgF3VFd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:05:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgF3VFd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 17:05:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UL1P9c097071
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yYppO0i/q7ruwIf0H7OJ0MBhJ0nlToGuhrYJ4Tz7Gfc=;
 b=UOpYOjOvFjvdQcJkr2MeKBDjxA3wPAAsghAlIm8tYlBn+4x7x2bPQDihrRjYxrByEdyL
 7t/BmFGC+4vjg01Lgzd94wMgPVgBGrgo3KgiSyX/zWQeEpDTPJ5QyjVx3Q7q2xY9kdAW
 8MDAzm/XreGTKxFIVCmyrhiKxV3BsaPYd+L8ZTchzZZt6Vksj+NVNRVFwcZnZ3skMu3C
 T2i7fDMfPDezrBWRideppKYbTuOWXKrBeub+q/q/j2WM+xJBX0pT13zUOsBYU3zSkzK+
 aWRdxVRjXmoO8GqCmYlbuGfqRMlvAUifVOfqDjQI70shFBtfX176pRURyNLw/di69Bsz Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31ywrbn4ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:05:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UL3lNx143139
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:05:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg1xbtbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:05:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UL5UXW002079
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:05:31 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 21:05:30 +0000
Subject: Re: [PATCH 2/2] xfs: rtbitmap scrubber should check inode size
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353169466.2864648.10518851810473831328.stgit@magnolia>
 <159353170715.2864648.7793153787081876108.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <264f6f81-9842-bda7-2b00-10c30f96782f@oracle.com>
Date:   Tue, 30 Jun 2020 14:05:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353170715.2864648.7793153787081876108.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:41 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure the rtbitmap is large enough to store the entire bitmap.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/scrub/rtbitmap.c |    7 +++++++
>   1 file changed, 7 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index c777c98c50c3..76e4ffe0315b 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -101,6 +101,13 @@ xchk_rtbitmap(
>   {
>   	int			error;
>   
> +	/* Is the size of the rtbitmap correct? */
> +	if (sc->mp->m_rbmip->i_d.di_size !=
> +	    XFS_FSB_TO_B(sc->mp, sc->mp->m_sb.sb_rbmblocks)) {
> +		xchk_ino_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
> +		return 0;
> +	}
> +
>   	/* Invoke the fork scrubber. */
>   	error = xchk_metadata_inode_forks(sc);
>   	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> 
