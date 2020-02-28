Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D110CC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 18:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A13B32084E
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 18:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FyVikA6F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgB1Sz5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 13:55:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1Sz5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 13:55:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SIs0b0096522;
        Fri, 28 Feb 2020 18:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=llsubKRSIJtW6HGn3TssduF8lmI3HzD7EFL2JVl1On0=;
 b=FyVikA6FNSQ3tqAEeGwZ658VgJyUjxr0M17zMn5FF7tRDnGM+CMo+uf6AfViESqcp5Nc
 pQVynLATyoeMN7BKPaA90TZtDlVX7iLKGx9eUATQYj6mWB8LpFefhPafV2d9PfqEWZej
 QiPUvZhHngDdKNJ0226g6getA0wZbudhYlz+mya8doCFvnCbV5KYX3Pu/08RwszuMFe1
 sSwi7fQzhr0v/ajSrE5ak+3i5Wld2cc20dDaj1juZztG05H5v60TrH+uH0U1lsBg/m7r
 JywwZUKvLipOVW3GeB2385cyxv9806BBwguXepHwuQcKi99QwAmlqEy0+FL8bktoNJFK mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yf0dmb263-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 18:55:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SIiOTt178022;
        Fri, 28 Feb 2020 18:55:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ydj4rgj4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 18:55:53 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SItp9D007798;
        Fri, 28 Feb 2020 18:55:52 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 10:55:12 -0800
Subject: Re: [RFC v5 PATCH 6/9] xfs: automatically relog the quotaoff start
 intent
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-7-bfoster@redhat.com>
 <137e4060-5936-171d-802a-9bf72195663c@oracle.com>
 <20200228140309.GE2751@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <005fecc7-0fa9-e778-2810-c36e18873f68@oracle.com>
Date:   Fri, 28 Feb 2020 11:55:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200228140309.GE2751@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/28/20 7:03 AM, Brian Foster wrote:
> On Thu, Feb 27, 2020 at 04:19:42PM -0700, Allison Collins wrote:
>>
>>
>> On 2/27/20 6:43 AM, Brian Foster wrote:
>>> The quotaoff operation has a rare but longstanding deadlock vector
>>> in terms of how the operation is logged. A quotaoff start intent is
>>> logged (synchronously) at the onset to ensure recovery can handle
>>> the operation if interrupted before in-core changes are made. This
>>> quotaoff intent pins the log tail while the quotaoff sequence scans
>>> and purges dquots from all in-core inodes. While this operation
>>> generally doesn't generate much log traffic on its own, it can be
>>> time consuming. If unrelated, concurrent filesystem activity
>>> consumes remaining log space before quotaoff is able to acquire log
>>> reservation for the quotaoff end intent, the filesystem locks up
>>> indefinitely.
>>>
>>> quotaoff cannot allocate the end intent before the scan because the
>>> latter can result in transaction allocation itself in certain
>>> indirect cases (releasing an inode, for example). Further, rolling
>>> the original transaction is difficult because the scanning work
>>> occurs multiple layers down where caller context is lost and not
>>> much information is available to determine how often to roll the
>>> transaction.
>>>
>>> To address this problem, enable automatic relogging of the quotaoff
>>> start intent. This automatically relogs the intent whenever AIL
>>> pushing finds the item at the tail of the log. When quotaoff
>>> completes, wait for relogging to complete as the end intent expects
>>> to be able to permanently remove the start intent from the log
>>> subsystem. This ensures that the log tail is kept moving during a
>>> particularly long quotaoff operation and avoids the log reservation
>>> deadlock.
>>>
>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>>> ---
>>>    fs/xfs/libxfs/xfs_trans_resv.c |  3 ++-
>>>    fs/xfs/xfs_dquot_item.c        |  7 +++++++
>>>    fs/xfs/xfs_qm_syscalls.c       | 12 +++++++++++-
>>>    3 files changed, 20 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
>>> index 1f5c9e6e1afc..f49b20c9ca33 100644
>>> --- a/fs/xfs/libxfs/xfs_trans_resv.c
>>> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
>>> @@ -935,7 +935,8 @@ xfs_trans_resv_calc(
>>>    	resp->tr_qm_setqlim.tr_logcount = XFS_DEFAULT_LOG_COUNT;
>>>    	resp->tr_qm_quotaoff.tr_logres = xfs_calc_qm_quotaoff_reservation(mp);
>>> -	resp->tr_qm_quotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
>>> +	resp->tr_qm_quotaoff.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
>>> +	resp->tr_qm_quotaoff.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>> What's the reason for the log count change here?  Otherwise looks ok.
>>
> 
> Permanent transactions have a separate default log count (2 instead of
> 1) because they are intended to be rolled (at least once). This
> basically means the initial allocation will acquire enough log
> reservation for the initial transaction and a subsequent roll, similar
> to how all other permanant transactions are initialized in this file.
> This is required for quotaoff because the transaction now uses
> XFS_TRANS_RELOG, which requires a roll up front.
> 
> Brian

Ok, I see.  Thank you for the explanation!
Allison

> 
>> Allison
>>>    	resp->tr_qm_equotaoff.tr_logres =
>>>    		xfs_calc_qm_quotaoff_end_reservation();
>>> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
>>> index d60647d7197b..ea5123678466 100644
>>> --- a/fs/xfs/xfs_dquot_item.c
>>> +++ b/fs/xfs/xfs_dquot_item.c
>>> @@ -297,6 +297,13 @@ xfs_qm_qoff_logitem_push(
>>>    	struct xfs_log_item	*lip,
>>>    	struct list_head	*buffer_list)
>>>    {
>>> +	struct xfs_log_item	*mlip = xfs_ail_min(lip->li_ailp);
>>> +
>>> +	if (test_bit(XFS_LI_RELOG, &lip->li_flags) &&
>>> +	    !test_bit(XFS_LI_RELOGGED, &lip->li_flags) &&
>>> +	    !XFS_LSN_CMP(lip->li_lsn, mlip->li_lsn))
>>> +		return XFS_ITEM_RELOG;
>>> +
>>>    	return XFS_ITEM_LOCKED;
>>>    }
>>> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
>>> index 1ea82764bf89..7b48d34da0f4 100644
>>> --- a/fs/xfs/xfs_qm_syscalls.c
>>> +++ b/fs/xfs/xfs_qm_syscalls.c
>>> @@ -18,6 +18,7 @@
>>>    #include "xfs_quota.h"
>>>    #include "xfs_qm.h"
>>>    #include "xfs_icache.h"
>>> +#include "xfs_trans_priv.h"
>>>    STATIC int
>>>    xfs_qm_log_quotaoff(
>>> @@ -31,12 +32,14 @@ xfs_qm_log_quotaoff(
>>>    	*qoffstartp = NULL;
>>> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
>>> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0,
>>> +				XFS_TRANS_RELOG, &tp);
>>>    	if (error)
>>>    		goto out;
>>>    	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
>>>    	xfs_trans_log_quotaoff_item(tp, qoffi);
>>> +	xfs_trans_relog_item(&qoffi->qql_item);
>>>    	spin_lock(&mp->m_sb_lock);
>>>    	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
>>> @@ -69,6 +72,13 @@ xfs_qm_log_quotaoff_end(
>>>    	int			error;
>>>    	struct xfs_qoff_logitem	*qoffi;
>>> +	/*
>>> +	 * startqoff must be in the AIL and not the CIL when the end intent
>>> +	 * commits to ensure it is not readded to the AIL out of order. Wait on
>>> +	 * relog activity to drain to isolate startqoff to the AIL.
>>> +	 */
>>> +	xfs_trans_relog_item_cancel(&startqoff->qql_item, true);
>>> +
>>>    	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
>>>    	if (error)
>>>    		return error;
>>>
>>
> 
