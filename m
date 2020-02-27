Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A358FC11D3D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E902246A0
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SswdykZm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgB0UtB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:49:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43808 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgB0UtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 15:49:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RKmnrx137408;
        Thu, 27 Feb 2020 20:48:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rdn65gHnRguTrfJYU7jvy/fv9v0zQecseio3laHJIjs=;
 b=SswdykZmeCkruIFo1wy3qEPyGERti3Tt8VG/DG4R1oZdy4ddPGS0mXvf0hyQ+PclvSyn
 t6aWpHjC4Z9HvS9ShQpsbfNsYt7qkrRgrH92c4Ltgl4VdSGUfNDJReczgjPgts2TJ9dC
 uSbnU6IwbKEf6ZiLkZGOtQT2oDmtngaoe4PIz5GLw9zDZW9hAdan4MY+XP5SdJ//Y27d
 +CQcu4TTQZizphqvA3tMAFNQZLl493RVW+nxzehHKIs8o8C4ONGBPiLEabd+RVSEDgBC
 6npoktNOwwsS9yjHLfZT2iJwMsFMTTa0zZNU/Qrk18b1yOt19A3QjHEBT01PwIPied5x uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yehxrs4tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 20:48:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RKmQNZ072094;
        Thu, 27 Feb 2020 20:48:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ydcsapm4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 20:48:57 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01RKmtiv008715;
        Thu, 27 Feb 2020 20:48:55 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 12:48:55 -0800
Subject: Re: [RFC v5 PATCH 1/9] xfs: set t_task at wait time instead of alloc
 time
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-2-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <4f044e44-d2d8-d4fb-a226-b04ab329e9f3@oracle.com>
Date:   Thu, 27 Feb 2020 13:48:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200227134321.7238-2-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/27/20 6:43 AM, Brian Foster wrote:
> The xlog_ticket structure contains a task reference to support
> blocking for available log reservation. This reference is assigned
> at ticket allocation time, which assumes that the transaction
> allocator will acquire reservation in the same context. This is
> normally true, but will not always be the case with automatic
> relogging.
> 
> There is otherwise no fundamental reason log space cannot be
> reserved for a ticket from a context different from the allocating
> context. Move the task assignment to the log reservation blocking
> code where it is used.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Ok, looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f6006d94a581..df60942a9804 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -262,6 +262,7 @@ xlog_grant_head_wait(
>   	int			need_bytes) __releases(&head->lock)
>   					    __acquires(&head->lock)
>   {
> +	tic->t_task = current;
>   	list_add_tail(&tic->t_queue, &head->waiters);
>   
>   	do {
> @@ -3601,7 +3602,6 @@ xlog_ticket_alloc(
>   	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
>   
>   	atomic_set(&tic->t_ref, 1);
> -	tic->t_task		= current;
>   	INIT_LIST_HEAD(&tic->t_queue);
>   	tic->t_unit_res		= unit_res;
>   	tic->t_curr_res		= unit_res;
> 
