Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DADFC54FCC
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 23:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C756206F4
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 23:26:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pfuSjF5Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDTX0b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 19:26:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49556 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDTX0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 19:26:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KNIMA7196201;
        Mon, 20 Apr 2020 23:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eATbSPQzYTdiI2wjiXQpEqvXrOvc1sYj83fJ1HRGehM=;
 b=pfuSjF5Zuv7dw2BviQhM/RFEHPKZCA/biK7drko7hxEcSGhsLokmpwUcWZG1anvUWXNC
 OaktlybYf4AyafD87FCyBDTFARdC92Dt+dDbe+SceqHMUwm5ghZT/u89r222DeBLJyI6
 mVKB9vSoT7IqgKE0Z+pj1RZIRKWbd2F5gPUbdOye6dthSVUo7dtjV58G89o0a0wGIZyG
 ulEtdO4XtQsmJlDgcVJiZCoVlQAbkSstuAvNd+gMA5qEhhloBR2QHqWndrzFaWH0SEoO
 KGZAyiKlla65BkUNXPCQndT7kUm6ICIPUoajDqzjSpxqMeZU7g2Tr3hEzJrQhpbTxOxF Sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30grpgegn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 23:26:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KNDOOD059161;
        Mon, 20 Apr 2020 23:26:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30gb8xjfdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 23:26:26 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03KNQPBd002506;
        Mon, 20 Apr 2020 23:26:25 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 16:26:25 -0700
Subject: Re: [PATCH v8 19/20] xfs: Add delay ready attr set routines
To:     Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-20-allison.henderson@oracle.com>
 <3903108.UdAzE1QFjl@localhost.localdomain> <20200420162018.GB27216@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <cfadfb2d-ab35-3055-ac38-7ddcb19d8c9e@oracle.com>
Date:   Mon, 20 Apr 2020 16:26:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200420162018.GB27216@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/20 9:20 AM, Brian Foster wrote:
> On Mon, Apr 20, 2020 at 05:15:08PM +0530, Chandan Rajendra wrote:
>> On Saturday, April 4, 2020 3:42 AM Allison Collins wrote:
> ...
>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.c        | 384 +++++++++++++++++++++++++++-------------
>>>   fs/xfs/libxfs/xfs_attr.h        |  16 ++
>>>   fs/xfs/libxfs/xfs_attr_leaf.c   |   1 +
>>>   fs/xfs/libxfs/xfs_attr_remote.c | 111 +++++++-----
>>>   fs/xfs/libxfs/xfs_attr_remote.h |   4 +
>>>   fs/xfs/xfs_attr_inactive.c      |   1 +
>>>   fs/xfs/xfs_trace.h              |   1 -
>>>   7 files changed, 351 insertions(+), 167 deletions(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index f700976..c160b7a 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>>> @@ -765,22 +873,25 @@ xfs_attr_leaf_addname(
>>>   		error = xfs_attr3_leaf_flipflags(args);
>>>   		if (error)
>>>   			return error;
>>> -		/*
>>> -		 * Commit the flag value change and start the next trans in
>>> -		 * series.
>>> -		 */
>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>> -		if (error)
>>> -			return error;
>>> -
>>> +		dac->dela_state = XFS_DAS_FLIP_LFLAG;
>>> +		return -EAGAIN;
>>> +das_flip_flag:
>>>   		/*
>>>   		 * Dismantle the "old" attribute/value pair by removing
>>>   		 * a "remote" value (if it exists).
>>>   		 */
>>>   		xfs_attr_restore_rmt_blk(args);
>>>   
>>> +		xfs_attr_rmtval_invalidate(args);
>>> +das_rm_lblk:
>>>   		if (args->rmtblkno) {
>>> -			error = xfs_attr_rmtval_remove(args);
>>> +			error = __xfs_attr_rmtval_remove(args);
>>> +
>>> +			if (error == -EAGAIN) {
>>> +				dac->dela_state = XFS_DAS_RM_LBLK;
>>
>> Similar to what I had observed in the patch "Add delay ready attr remove
>> routines",
>>
>> Shouldn't XFS_DAC_DEFER_FINISH be set in dac->flags?
>> __xfs_attr_rmtval_remove() calls __xfs_bunmapi() which would
>> have added items to the deferred list.
>>
> 
> Just note that transaction rolls don't currently finish deferred ops. So
> from the perspective of preserving current behavior it might make sense
> to set the flag here if there was an explicit xfs_defer_finish() that's
> been factored out, but not so if it was just a transaction roll.
> 
> Brian
Yep, I think Chandan is right, xfs_attr_rmtval_remove used to have a 
xfs_defer_finish and __xfs_attr_rmtval_remove does not.  I think 
probably I'll keep the xfs_defer_finish in the __xfs_attr_rmtval_remove 
helper, and then when we get to this patch, turn it into the flag set. 
I believe that should be correct.

Allison
> 
>> -- 
>> chandan
>>
>>
>>
> 
