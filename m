Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD50C2D0C9
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 21:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E3C720663
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 21:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H4cnMEb7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLMVSw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 16:18:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:32838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfLMVSv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 16:18:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDKsfWh090998;
        Fri, 13 Dec 2019 21:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=X+2tEe+tYzg2Fks7bhpQkOAxHyaWVZAH0k0u6MwuV5E=;
 b=H4cnMEb75s31C6RYwQ5AebrGol7SnOC1Qk5+YeI7AkILJFOJI7bwjTkhzP/lGoR3offr
 6pT2Xb+3QrPEGC/ia4XkeVB7qdZOuf3yho59Ezkf7Gw1DKMt84PnCQQGr9/rhAFcXKJK
 y4rm6gRy9f4RdFO5lR/iYuNTioANmVlZR2Byz5acHHNJQBiKOqo4fFFYqPH+HmMcQdku
 kpeen3aaR2BP/vdGMFaNZvMm24w06eBb8I5RitF7eY2aTWuxGo5R0Y2O2mK2KMc1XJy1
 ZckE6m7TSRyhjvsP/oVX4grX+XJIlUaKnVPkL/XWwsZEUCWQFL/8FAZXza9EKMpdV4n+ 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wr41qud5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 21:18:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDKscae067505;
        Fri, 13 Dec 2019 21:18:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wvdtvdd6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 21:18:43 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBDLIgls012266;
        Fri, 13 Dec 2019 21:18:42 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 13:18:41 -0800
Date:   Fri, 13 Dec 2019 13:18:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Nick Bowler <nbowler@draconx.ca>
Subject: Re: [PATCH v2 19/24] xfs: rename compat_time_t to old_time32_t
Message-ID: <20191213211840.GM99875@magnolia>
References: <20191213204936.3643476-1-arnd@arndb.de>
 <20191213205417.3871055-10-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213205417.3871055-10-arnd@arndb.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=854
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=905 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 09:53:47PM +0100, Arnd Bergmann wrote:
> The compat_time_t type has been removed everywhere else,
> as most users rely on old_time32_t for both native and
> compat mode handling of 32-bit time_t.
> 
> Remove the last one in xfs.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks fine to me, assuming that compat_time_t -> old_time32_t.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl32.c | 2 +-
>  fs/xfs/xfs_ioctl32.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index c4c4f09113d3..a49bd80b2c3b 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -107,7 +107,7 @@ xfs_ioctl32_bstime_copyin(
>  	xfs_bstime_t		*bstime,
>  	compat_xfs_bstime_t	__user *bstime32)
>  {
> -	compat_time_t		sec32;	/* tv_sec differs on 64 vs. 32 */
> +	old_time32_t		sec32;	/* tv_sec differs on 64 vs. 32 */
>  
>  	if (get_user(sec32,		&bstime32->tv_sec)	||
>  	    get_user(bstime->tv_nsec,	&bstime32->tv_nsec))
> diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
> index 8c7743cd490e..053de7d894cd 100644
> --- a/fs/xfs/xfs_ioctl32.h
> +++ b/fs/xfs/xfs_ioctl32.h
> @@ -32,7 +32,7 @@
>  #endif
>  
>  typedef struct compat_xfs_bstime {
> -	compat_time_t	tv_sec;		/* seconds		*/
> +	old_time32_t	tv_sec;		/* seconds		*/
>  	__s32		tv_nsec;	/* and nanoseconds	*/
>  } compat_xfs_bstime_t;
>  
> -- 
> 2.20.0
> 
