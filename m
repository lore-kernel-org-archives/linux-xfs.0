Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03169C3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 18:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D54E220B1F
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 18:50:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fCxw852l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDTSub (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 14:50:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50340 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgDTSub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 14:50:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KImZlo145131;
        Mon, 20 Apr 2020 18:50:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KVUWhbR9NLKMNOvTeKgJSRE8p1FKtuGdElJHJJBFkvA=;
 b=fCxw852l7/G0cXhCXTI4G472wCZPfskSE4qWK5WYwpT7VHoG+N/kCtVzWAIYZ66XXYjl
 8fhC/0ImYSAOi7IxqVFHp51CGyJNth0BZkLdWeOJb3OPsd3SLb8g3agp0w0FAwTWL9ed
 R4h3TqBUqA2p5Si+9k2JOWrYxJoF5g6kp0UKT9nqyukhMaUdgpKkjF9DHSnH32pxZrNo
 utKtitPSz9tqvoahQDgA04SmF4I8C9Za6HPv5nAVhMUaffby0jAkLGUalq0VfXnTNAPj
 SJS1jBfYn39MghRw1a7Rg4yiy8SzGIOXVCeNZ+5PjDEt7bI0C9we8c9ZepJRxvOiilu9 Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30fsgks3a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 18:50:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KIg9Kn106850;
        Mon, 20 Apr 2020 18:50:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30gb1dw40m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 18:50:26 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03KIoP1a003857;
        Mon, 20 Apr 2020 18:50:25 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 11:50:25 -0700
Subject: Re: [PATCH 05/12] xfs: ratelimit unmount time per-buffer I/O error
 warning
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-6-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a97ffbc2-911d-4bde-3d49-e35b1de77861@oracle.com>
Date:   Mon, 20 Apr 2020 11:50:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200417150859.14734-6-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/17/20 8:08 AM, Brian Foster wrote:
> At unmount time, XFS emits a warning for every in-core buffer that
> might have undergone a write error. In practice this behavior is
> probably reasonable given that the filesystem is likely short lived
> once I/O errors begin to occur consistently. Under certain test or
> otherwise expected error conditions, this can spam the logs and slow
> down the unmount. Ratelimit the warning to prevent this problem
> while still informing the user that errors have occurred.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Ok, other than the line return Dave pointed out, looks ok to me:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_buf.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 93942d8e35dd..5120fed06075 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1685,11 +1685,10 @@ xfs_wait_buftarg(
>   			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
>   			list_del_init(&bp->b_lru);
>   			if (bp->b_flags & XBF_WRITE_FAIL) {
> -				xfs_alert(btp->bt_mount,
> -"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> +				xfs_alert_ratelimited(btp->bt_mount,
> +"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!\n"
> +"Please run xfs_repair to determine the extent of the problem.",
>   					(long long)bp->b_bn);
> -				xfs_alert(btp->bt_mount,
> -"Please run xfs_repair to determine the extent of the problem.");
>   			}
>   			xfs_buf_rele(bp);
>   		}
> 
