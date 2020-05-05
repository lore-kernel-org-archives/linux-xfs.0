Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8240EC47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 21:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DCB2206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 21:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MHF3lv7Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgEEVJz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 17:09:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50016 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbgEEVJy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 17:09:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045L3SHT117195;
        Tue, 5 May 2020 21:09:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=x1oCuyXBAYVZe4BTdJgwb0shpupG1gsll20tDZTiAcs=;
 b=MHF3lv7QtrnhS2Dr4u/LkL0J/7/SdwfMRYW6oiVkMhDiw6s3kWyEfdltV68nyLb4qO4p
 Er4fXmt+Y/y785se7Ls1B+JC4KYcQ+vbJdglK42no0yAaCZ5kkHNhjdElB/OUsHKGLgm
 rdRASjHeqRdQ0MxwYyJOZalArN5FStOnjNLIAmNtmDNnvk+4hRowaXCH1nfQlE+zZtWN
 iE3li6chFMWgcsn0gZf//nAIdAYW93dWA/ZhX/zfovq+Jlvz+nICqLSkriV75+dSuKft
 hLrZmFkFosULtcxDUgVn4G8OxpEg++v8MvsLbhWhD/AmbQopYSzxxuBNgn29i60tuL59 Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30s0tmf4xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 21:09:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045L5a94052038;
        Tue, 5 May 2020 21:09:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30sjnfsaxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 21:09:52 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045L9oa1029608;
        Tue, 5 May 2020 21:09:50 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 14:09:50 -0700
Subject: Re: [PATCH v4 05/17] xfs: reset buffer write failure state on
 successful completion
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504141154.55887-6-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <29fcc710-1fed-c1d1-c1e1-e7326abec25d@oracle.com>
Date:   Tue, 5 May 2020 14:09:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504141154.55887-6-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 7:11 AM, Brian Foster wrote:
> The buffer write failure flag is intended to control the internal
> write retry that XFS has historically implemented to help mitigate
> the severity of transient I/O errors. The flag is set when a buffer
> is resubmitted from the I/O completion path due to a previous
> failure. It is checked on subsequent I/O completions to skip the
> internal retry and fall through to the higher level configurable
> error handling mechanism. The flag is cleared in the synchronous and
> delwri submission paths and also checked in various places to log
> write failure messages.
> 
> There are a couple minor problems with the current usage of this
> flag. One is that we issue an internal retry after every submission
> from xfsaild due to how delwri submission clears the flag. This
> results in double the expected or configured number of write
> attempts when under sustained failures. Another more subtle issue is
> that the flag is never cleared on successful I/O completion. This
> can cause xfs_wait_buftarg() to suggest that dirty buffers are being
> thrown away due to the existence of the flag, when the reality is
> that the flag might still be set because the write succeeded on the
> retry.
> 
> Clear the write failure flag on successful I/O completion to address
> both of these problems. This means that the internal retry attempt
> occurs once since the last time a buffer write failed and that
> various other contexts only see the flag set when the immediately
> previous write attempt has failed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Looks ok to me:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_buf.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d5d6a68bb1e6..fd76a84cefdd 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1197,8 +1197,10 @@ xfs_buf_ioend(
>   		bp->b_ops->verify_read(bp);
>   	}
>   
> -	if (!bp->b_error)
> +	if (!bp->b_error) {
> +		bp->b_flags &= ~XBF_WRITE_FAIL;
>   		bp->b_flags |= XBF_DONE;
> +	}
>   
>   	if (bp->b_iodone)
>   		(*(bp->b_iodone))(bp);
> @@ -1274,7 +1276,7 @@ xfs_bwrite(
>   
>   	bp->b_flags |= XBF_WRITE;
>   	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
> -			 XBF_WRITE_FAIL | XBF_DONE);
> +			 XBF_DONE);
>   
>   	error = xfs_buf_submit(bp);
>   	if (error)
> @@ -1996,7 +1998,7 @@ xfs_buf_delwri_submit_buffers(
>   		 * synchronously. Otherwise, drop the buffer from the delwri
>   		 * queue and submit async.
>   		 */
> -		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
> +		bp->b_flags &= ~_XBF_DELWRI_Q;
>   		bp->b_flags |= XBF_WRITE;
>   		if (wait_list) {
>   			bp->b_flags &= ~XBF_ASYNC;
> 
