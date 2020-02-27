Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8CEC3F2C6
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 23:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51ACD246A5
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 23:28:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ayshpnp3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgB0X26 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 18:28:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48794 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729586AbgB0X26 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 18:28:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNRo1B042320;
        Thu, 27 Feb 2020 23:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AqW7lKIZS9Fz2dxToCtKm4H8qm+/i8OcvTuaSRxypQQ=;
 b=Ayshpnp3jHC8cy9QRnwKO/khPuRmVzDzWdw+6ZihfDYrUv363vNsJqSZhp9GLtomRUsM
 NjUddtHgPQGLHKOmzsbVEMeEEveBDuPj5pUhRW02vsG/0HgrdzLXtgCeaRsoZWdbPnM3
 byLd2gHEpGK83dMamKuzCVm/sFG2VERganPJJKDtevhznOvyBO/jOb/CWQYQI+IJXx82
 VLne6evelWNf6Ht0EwUj/3agAWQucnrTEddsScfOXAYgYbVqxb2txM1VWJIhLdomlamE
 vWc9zErC7X76RPMGKm9GcRHDKW+Dbc3qUbTl3aRQ7FgKQIHvDhh3lBfWKdyMv5lYF9px qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsnp89m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 23:28:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNQKmW006204;
        Thu, 27 Feb 2020 23:28:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ydcsb92cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 23:28:54 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01RNSrD8019373;
        Thu, 27 Feb 2020 23:28:53 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 15:28:53 -0800
Date:   Thu, 27 Feb 2020 15:28:53 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 1/9] xfs: set t_task at wait time instead of alloc
 time
Message-ID: <20200227232853.GP8045@magnolia>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227134321.7238-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 08:43:13AM -0500, Brian Foster wrote:
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
> ---
>  fs/xfs/xfs_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f6006d94a581..df60942a9804 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -262,6 +262,7 @@ xlog_grant_head_wait(
>  	int			need_bytes) __releases(&head->lock)
>  					    __acquires(&head->lock)
>  {
> +	tic->t_task = current;
>  	list_add_tail(&tic->t_queue, &head->waiters);
>  
>  	do {
> @@ -3601,7 +3602,6 @@ xlog_ticket_alloc(
>  	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
>  
>  	atomic_set(&tic->t_ref, 1);
> -	tic->t_task		= current;

Hm.  So this leaves t_task set to NULL in the ticket constructor in
favor of setting it in xlog_grant_head_wait.  I guess this implies that
some future piece will be able to transfer a ticket to another process
as part of a regrant or something?

I've been wondering lately if you could transfer a dirty permanent
transaction to a different task so that the front end could return to
userspace as soon as the first transaction (with the intent items)
commits, and then you could reduce the latency of front-end system
calls.  That's probably a huge fantasy since you'd also have to transfer
a whole ton of state to that worker and whatever you locked to do the
operation remains locked...

--D

>  	INIT_LIST_HEAD(&tic->t_queue);
>  	tic->t_unit_res		= unit_res;
>  	tic->t_curr_res		= unit_res;
> -- 
> 2.21.1
> 
