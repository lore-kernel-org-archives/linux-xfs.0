Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D310EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 21:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA0C22D00
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 21:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbhAEVHk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 16:07:40 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43024 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbhAEVHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 16:07:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105L4ifb119943;
        Tue, 5 Jan 2021 21:06:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RfO2FlqfxyTkR2cZlAUXy9JI/0fiQZ038xzuc+QV4dg=;
 b=HIS4NS50UEmCuxQhNlBTn1e/o7xW1lGS3bp5CZD7vcXKQXWj2ApfenHgSCNPiOIy4d6i
 IAxMbG59MzPgRovMQI2CF6PUNPQwjoKAk82ug4ysI5za05aqo0BQ1BxxdAvSoW052dfR
 cG3OXsjRofY1Y0Xk7TqOX0d4uJifOW83nahvy+BRvLNPm9uPNfa1NzaOum5AuZ1u0G96
 leJ1dU+QVixNGIysbkxx9k2jF3fHnGMcK36FWLXdofUiCNG4umNy4uq3B21gMhuYW8U8
 3C+81Eco7aBQVYupH1FM5deBD8o6kbZZUZrPQSldcZDzX1mkzWW3LRDrf5aitF368HfB 3g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35tebatuy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 21:06:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105L6QKt050995;
        Tue, 5 Jan 2021 21:06:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35uxnt7hpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 21:06:58 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 105L6v9u023663;
        Tue, 5 Jan 2021 21:06:57 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 13:06:57 -0800
Subject: Re: [PATCH v14 06/15] xfs: Add state machine tracepoints
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-7-allison.henderson@oracle.com>
 <4353133.qTs6tMSDRZ@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4bd6f1c6-3e73-6665-3229-d00e88c1ac6a@oracle.com>
Date:   Tue, 5 Jan 2021 14:06:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4353133.qTs6tMSDRZ@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/4/21 9:50 PM, Chandan Babu R wrote:
> On Fri, 18 Dec 2020 00:29:08 -0700, Allison Henderson wrote:
>> This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
>> use this to track when ever a new state is set or -EAGAIN is returned
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, thank you!

Allison
> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 22 +++++++++++++++++++++-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  1 +
>>   fs/xfs/xfs_trace.h              | 20 ++++++++++++++++++++
>>   3 files changed, 42 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index cd72512..8ed00bc 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -263,6 +263,7 @@ xfs_attr_set_shortform(
>>   	 * We're still in XFS_DAS_UNINIT state here.  We've converted the attr
>>   	 * fork to leaf format and will restart with the leaf add.
>>   	 */
>> +	trace_xfs_das_state_return(XFS_DAS_UNINIT);
>>   	return -EAGAIN;
>>   }
>>   
>> @@ -409,9 +410,11 @@ xfs_attr_set_iter(
>>   		 * down into the node handling code below
>>   		 */
>>   		dac->flags |= XFS_DAC_DEFER_FINISH;
>> +		trace_xfs_das_state_return(dac->dela_state);
>>   		return -EAGAIN;
>>   	case 0:
>>   		dac->dela_state = XFS_DAS_FOUND_LBLK;
>> +		trace_xfs_das_state_return(dac->dela_state);
>>   		return -EAGAIN;
>>   	}
>>   	return error;
>> @@ -841,6 +844,7 @@ xfs_attr_leaf_addname(
>>   			return error;
>>   
>>   		dac->flags |= XFS_DAC_DEFER_FINISH;
>> +		trace_xfs_das_state_return(dac->dela_state);
>>   		return -EAGAIN;
>>   	}
>>   
>> @@ -874,6 +878,7 @@ xfs_attr_leaf_addname(
>>   	 * Commit the flag value change and start the next trans in series.
>>   	 */
>>   	dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> +	trace_xfs_das_state_return(dac->dela_state);
>>   	return -EAGAIN;
>>   das_flip_flag:
>>   	/*
>> @@ -891,6 +896,8 @@ xfs_attr_leaf_addname(
>>   das_rm_lblk:
>>   	if (args->rmtblkno) {
>>   		error = __xfs_attr_rmtval_remove(dac);
>> +		if (error == -EAGAIN)
>> +			trace_xfs_das_state_return(dac->dela_state);
>>   		if (error)
>>   			return error;
>>   	}
>> @@ -1142,6 +1149,7 @@ xfs_attr_node_addname(
>>   			 * this point.
>>   			 */
>>   			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			trace_xfs_das_state_return(dac->dela_state);
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -1175,6 +1183,7 @@ xfs_attr_node_addname(
>>   	state = NULL;
>>   
>>   	dac->dela_state = XFS_DAS_FOUND_NBLK;
>> +	trace_xfs_das_state_return(dac->dela_state);
>>   	return -EAGAIN;
>>   das_found_nblk:
>>   
>> @@ -1202,6 +1211,7 @@ xfs_attr_node_addname(
>>   				return error;
>>   
>>   			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			trace_xfs_das_state_return(dac->dela_state);
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -1236,6 +1246,7 @@ xfs_attr_node_addname(
>>   	 * Commit the flag value change and start the next trans in series
>>   	 */
>>   	dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> +	trace_xfs_das_state_return(dac->dela_state);
>>   	return -EAGAIN;
>>   das_flip_flag:
>>   	/*
>> @@ -1253,6 +1264,10 @@ xfs_attr_node_addname(
>>   das_rm_nblk:
>>   	if (args->rmtblkno) {
>>   		error = __xfs_attr_rmtval_remove(dac);
>> +
>> +		if (error == -EAGAIN)
>> +			trace_xfs_das_state_return(dac->dela_state);
>> +
>>   		if (error)
>>   			return error;
>>   	}
>> @@ -1396,6 +1411,8 @@ xfs_attr_node_remove_rmt (
>>   	 * May return -EAGAIN to request that the caller recall this function
>>   	 */
>>   	error = __xfs_attr_rmtval_remove(dac);
>> +	if (error == -EAGAIN)
>> +		trace_xfs_das_state_return(dac->dela_state);
>>   	if (error)
>>   		return error;
>>   
>> @@ -1514,6 +1531,7 @@ xfs_attr_node_removename_iter(
>>   
>>   			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			dac->dela_state = XFS_DAS_RM_SHRINK;
>> +			trace_xfs_das_state_return(dac->dela_state);
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -1532,8 +1550,10 @@ xfs_attr_node_removename_iter(
>>   		goto out;
>>   	}
>>   
>> -	if (error == -EAGAIN)
>> +	if (error == -EAGAIN) {
>> +		trace_xfs_das_state_return(dac->dela_state);
>>   		return error;
>> +	}
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 6af86bf..4840de9 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -763,6 +763,7 @@ __xfs_attr_rmtval_remove(
>>   	 */
>>   	if (!done) {
>>   		dac->flags |= XFS_DAC_DEFER_FINISH;
>> +		trace_xfs_das_state_return(dac->dela_state);
>>   		return -EAGAIN;
>>   	}
>>   
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index 9074b8b..4f6939b4 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -3887,6 +3887,26 @@ DEFINE_EVENT(xfs_timestamp_range_class, name, \
>>   DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
>>   DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
>>   
>> +
>> +DECLARE_EVENT_CLASS(xfs_das_state_class,
>> +	TP_PROTO(int das),
>> +	TP_ARGS(das),
>> +	TP_STRUCT__entry(
>> +		__field(int, das)
>> +	),
>> +	TP_fast_assign(
>> +		__entry->das = das;
>> +	),
>> +	TP_printk("state change %d",
>> +		  __entry->das)
>> +)
>> +
>> +#define DEFINE_DAS_STATE_EVENT(name) \
>> +DEFINE_EVENT(xfs_das_state_class, name, \
>> +	TP_PROTO(int das), \
>> +	TP_ARGS(das))
>> +DEFINE_DAS_STATE_EVENT(xfs_das_state_return);
>> +
>>   #endif /* _TRACE_XFS_H */
>>   
>>   #undef TRACE_INCLUDE_PATH
>>
> 
> 
