Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E519C3F2D7
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 05:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01F272064A
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 05:40:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FWA4YGji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgCCFks (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 00:40:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56900 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgCCFkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 00:40:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0235Y6s8031216;
        Tue, 3 Mar 2020 05:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rYuHkcie3x3rmLKseUe38KeFNRmX2jBw1xu5s7y3IUI=;
 b=FWA4YGjiHOicbMwU+6RMbueB3d1w6G/Uasz9qVZpMZPQfAT8krclG2LlEsiSr8SR+tHp
 39xlBqHRlyC0LWQ4Pw5xPPMid5xLPuh9VzOtiznejgsgrwfnMIFeTe/h3EU6ZBvscLnj
 sg+34Lqp4AhULGII/GUBPUMunrvVcOBBxY5PqME0S9oIb62yT6582ZvK1QUW8K9BTKj+
 NXFKoZh9L6nq6AhLIg0a2rhGn+CJxDCCTUUes0Lt5FQuzAFnN+HuxuP5bmHBIDzlmRV/
 CJkeQt9MuPfoThm2vKQUyLId6KBp0I69VayppjPxdnD/0YHKue6i43sVDSa8AksGWP2N ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yffwqmjun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 05:40:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0235X0NI128820;
        Tue, 3 Mar 2020 05:40:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yg1gwmse7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 05:40:45 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0235eh3R012207;
        Tue, 3 Mar 2020 05:40:43 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 21:40:43 -0800
Subject: Re: [PATCH v7 13/19] xfs: Add delay ready attr remove routines
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-14-allison.henderson@oracle.com>
 <5805763.2Ij3A3caSj@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <33caec03-4139-34dc-61e7-dde199146d79@oracle.com>
Date:   Mon, 2 Mar 2020 22:40:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5805763.2Ij3A3caSj@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/2/20 10:03 PM, Chandan Rajendra wrote:
> On Sunday, February 23, 2020 7:36 AM Allison Collins wrote:
>> This patch modifies the attr remove routines to be delay ready. This means they no
>> longer roll or commit transactions, but instead return -EAGAIN to have the calling
>> routine roll and refresh the transaction. In this series, xfs_attr_remove_args has
>> become xfs_attr_remove_iter, which uses a sort of state machine like switch to keep
>> track of where it was when EAGAIN was returned. xfs_attr_node_removename has also
>> been modified to use the switch, and a  new version of xfs_attr_remove_args
>> consists of a simple loop to refresh the transaction until the operation is
>> completed.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use to keep
>> track of the current state of an attribute operation. The new xfs_delattr_state
>> enum is used to track various operations that are in progress so that we know not
>> to repeat them, and resume where we left off before EAGAIN was returned to cycle
>> out the transaction. Other members take the place of local variables that need
>> to retain their values across multiple function recalls.
>>
>> Below is a state machine diagram for attr remove operations. The XFS_DAS_* states
>> indicate places where the function would return -EAGAIN, and then immediately
>> resume from after being recalled by the calling function.  States marked as a
>> "subroutine state" indicate that they belong to a subroutine, and so the calling
>> function needs to pass them back to that subroutine to allow it to finish where
>> it left off. But they otherwise do not have a role in the calling function other
>> than just passing through.
>>
>>   xfs_attr_remove_iter()
>>           XFS_DAS_RM_SHRINK     â”€â”
>>           (subroutine state)     â”‚
>>                                  â”‚
>>           XFS_DAS_RMTVAL_REMOVE â”€â”¤
>>           (subroutine state)     â”‚
>>                                  â””â”€>xfs_attr_node_removename()
>>                                                   â”‚
>>                                                   v
>>                                           need to remove
>>                                     â”Œâ”€nâ”€â”€  rmt blocks?
>>                                     â”‚             â”‚
>>                                     â”‚             y
>>                                     â”‚             â”‚
>>                                     â”‚             v
>>                                     â”‚  â”Œâ”€>XFS_DAS_RMTVAL_REMOVE
>>                                     â”‚  â”‚          â”‚
>>                                     â”‚  â”‚          v
>>                                     â”‚  â””â”€â”€yâ”€â”€ more blks
>>                                     â”‚         to remove?
>>                                     â”‚             â”‚
>>                                     â”‚             n
>>                                     â”‚             â”‚
>>                                     â”‚             v
>>                                     â”‚         need to
>>                                     â””â”€â”€â”€â”€â”€> shrink tree? â”€nâ”€â”
>>                                                   â”‚         â”‚
>>                                                   y         â”‚
>>                                                   â”‚         â”‚
>>                                                   v         â”‚
>>                                           XFS_DAS_RM_SHRINK â”‚
>>                                                   â”‚         â”‚
>>                                                   v         â”‚
>>                                                  done <â”€â”€â”€â”€â”€â”˜
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c     | 114 +++++++++++++++++++++++++++++++++++++------
>>   fs/xfs/libxfs/xfs_attr.h     |   1 +
>>   fs/xfs/libxfs/xfs_da_btree.h |  30 ++++++++++++
>>   fs/xfs/scrub/common.c        |   2 +
>>   fs/xfs/xfs_acl.c             |   2 +
>>   fs/xfs/xfs_attr_list.c       |   1 +
>>   fs/xfs/xfs_ioctl.c           |   2 +
>>   fs/xfs/xfs_ioctl32.c         |   2 +
>>   fs/xfs/xfs_iops.c            |   2 +
>>   fs/xfs/xfs_xattr.c           |   1 +
>>   10 files changed, 141 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5d73bdf..cd3a3f7 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -368,11 +368,60 @@ xfs_has_attr(
>>    */
>>   int
>>   xfs_attr_remove_args(
>> +	struct xfs_da_args	*args)
>> +{
>> +	int			error = 0;
>> +	int			err2 = 0;
>> +
>> +	do {
>> +		error = xfs_attr_remove_iter(args);
>> +		if (error && error != -EAGAIN)
>> +			goto out;
>> +
>> +		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
>> +			args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
>> +
>> +			err2 = xfs_defer_finish(&args->trans);
>> +			if (err2) {
>> +				error = err2;
>> +				goto out;
>> +			}
>> +		}
>> +
>> +		err2 = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (err2) {
>> +			error = err2;
>> +			goto out;
>> +		}
>> +
>> +	} while (error == -EAGAIN);
>> +out:
>> +	return error;
>> +}
>> +
>> +/*
>> + * Remove the attribute specified in @args.
>> + *
>> + * This function may return -EAGAIN to signal that the transaction needs to be
>> + * rolled.  Callers should continue calling this function until they receive a
>> + * return value other than -EAGAIN.
>> + */
>> +int
>> +xfs_attr_remove_iter(
>>   	struct xfs_da_args      *args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	int			error;
>>   
>> +	/* State machine switch */
>> +	switch (args->dac.dela_state) {
>> +	case XFS_DAS_RM_SHRINK:
>> +	case XFS_DAS_RMTVAL_REMOVE:
>> +		goto node;
>> +	default:
>> +		break;
>> +	}
>> +
> 
> On the very first invocation of xfs_attr_remote_iter() from
> xfs_attr_remove_args() (via a call from xfs_attr_remove()),
> args->dac.dela_state is set to a value of 0. This happens because
> xfs_attr_args_init() invokes memset() on args. A value of 0 for
> args->dac.dela_state maps to XFS_DAS_RM_SHRINK.
> 
> If the xattr was stored in say local or leaf format we end up incorrectly
> invoking xfs_attr_node_removename() right?
> 
Hi Chandan,

Yes, this came up in one of the other reviews too.  The indexing for the 
XFS_DAS_* enum should start at 1, not zero.  I had pulled it out of the 
last version thinking it would be ok, but I should have kept the 
indexing starting at 1, allowing the switch to fall through to default.

Allison
