Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB52C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 22:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD532332A
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 22:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbhAFWvZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 17:51:25 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51992 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbhAFWvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 17:51:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106MmqQY100695;
        Wed, 6 Jan 2021 22:50:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HQMxxgUufBYAbSxe3sG9aPAq+0Y7iE0XhQ1JClRQAAs=;
 b=nX+dLh8JIQLbtn6rXGr+o0VWq/pSp973Tfb7p40b4cDvxgkPjwvaim/N7cfi+r6YZ2iV
 X8W8++suKA3VuoDlzB48512bpAkv7l/MP97YV+yttjG69ci9s6khkwEuEMIeFBnpfTr9
 BHz/blEIVm0KlfSCt5cS59fS+RVdjfBR7cR/rTtjA4BRWInnD4D81tReaMappOs0bb3Q
 Bj5rSxgnXQO3LuW2VEG+J1vAMfCV0y7eaY2TIrdVDAtbiUpyMjh9QZwfCUKQ/kXjMQ1O
 qawqJGsuwTcX3tcIkl4IEVWDkK0DeQNwFoNo2ksREE5PNQFl+yc4wVkGZgVo/SWOP6Xt 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35wcuxtk0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 22:50:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106MfUEx051147;
        Wed, 6 Jan 2021 22:50:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35w3g1pg9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 22:50:40 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106ModDB032088;
        Wed, 6 Jan 2021 22:50:39 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 22:50:39 +0000
Subject: Re: [PATCH 2/9] xfs: lift writable fs check up into log worker task
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-3-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c29c51f1-7e9c-457b-6929-8ef9c65e25fe@oracle.com>
Date:   Wed, 6 Jan 2021 15:50:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210106174127.805660-3-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060129
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/6/21 10:41 AM, Brian Foster wrote:
> The log covering helper checks whether the filesystem is writable to
> determine whether to cover the log. The helper is currently only
> called from the background log worker. In preparation to reuse the
> helper from freezing contexts, lift the check into xfs_log_worker().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Looks straight forward
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_log.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b445e63cbc3c..4137ed007111 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1050,13 +1050,11 @@ xfs_log_space_wake(
>    * can't start trying to idle the log until both the CIL and AIL are empty.
>    */
>   static int
> -xfs_log_need_covered(xfs_mount_t *mp)
> +xfs_log_need_covered(
> +	struct xfs_mount	*mp)
>   {
> -	struct xlog	*log = mp->m_log;
> -	int		needed = 0;
> -
> -	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
> -		return 0;
> +	struct xlog		*log = mp->m_log;
> +	int			needed = 0;
>   
>   	if (!xlog_cil_empty(log))
>   		return 0;
> @@ -1271,7 +1269,7 @@ xfs_log_worker(
>   	struct xfs_mount	*mp = log->l_mp;
>   
>   	/* dgc: errors ignored - not fatal and nowhere to report them */
> -	if (xfs_log_need_covered(mp)) {
> +	if (xfs_fs_writable(mp, SB_FREEZE_WRITE) && xfs_log_need_covered(mp)) {
>   		/*
>   		 * Dump a transaction into the log that contains no real change.
>   		 * This is needed to stamp the current tail LSN into the log
> 
