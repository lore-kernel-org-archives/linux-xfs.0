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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B56DC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 21:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFFF222DD3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 21:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbhAEVHs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 16:07:48 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43104 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbhAEVHr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 16:07:47 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105L4iP2119921
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 21:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tYTlTyjnn9BvslEdgvcUqhfp6BiPWrXnVjwIXuaY7Rg=;
 b=AiCZKgJDJ+UXoWuqtEMP0zIH1KT/+yGfeeoplmrHgDT2uqyQ+eD6J/EFNp9sngeMysD+
 4t1ETPEv7nWqvFVzL7oIacYVYap9fC/B8JPLZNUuSnW5h7xpA9zE+/iE+DnPcZMc4xHU
 AogMKiUA/1fyKaGQnEIhQnaQHjAKHt/WtnZr/SbNe6WboEK0vPccPse7KefRcjJkt9BU
 7L7wdQINfIz5D7+SDWptu7PsbRBum8q/GBCc/TFzu7iMt/6QUbSuH4qcysLZEvqgs9X3
 IKAtLn99oNDOSL2878JJJw4MgbDk9r3bTpJj6dHKaFxN9XQ8EFnzi9DVJ8d99qzl27Jo 8w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35tebatuyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 21:07:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105L6Pvx015609
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 21:07:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35v4rbuyqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 21:07:05 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 105L75b5023867
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 21:07:05 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 13:07:05 -0800
Subject: Re: [PATCH v14 06/15] xfs: Add state machine tracepoints
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-7-allison.henderson@oracle.com>
 <20210105052807.GT6918@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <bf205dda-e92d-277a-66c6-4cfcbaf1c366@oracle.com>
Date:   Tue, 5 Jan 2021 14:07:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210105052807.GT6918@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
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



On 1/4/21 10:28 PM, Darrick J. Wong wrote:
> On Fri, Dec 18, 2020 at 12:29:08AM -0700, Allison Henderson wrote:
>> This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
>> use this to track when ever a new state is set or -EAGAIN is returned
>>
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
> 
> It would help to record the inode number in the trace data.  When
> someone encounters an xattr problem involving things like fsstress,
> it'll be /much/ easier to disentangle who's doing what.
Sure, I can add that in

> 
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
> 
> Also, please consider capturing more info about /which/ of these
> xfs_das_state_return tracepoints fired, either by introducing more
> variants (e.g. xfs_attr_leaf_addname_das_return) or by feeding
> __this_address into the trace "call" and printing it in the TP_printk
> output (formatting string '%pS').
> 
> Each declared tracepoint /does/ have a permanent memory cost, so I would
> think hard about trying #2...
Ok, how about a variant for each function then?  I think that would work 
out to 7 variants.

Allison
> 
> --D
> 
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
>> -- 
>> 2.7.4
>>
