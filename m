Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2E4C4BA09
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D271824680
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fyc++Z1X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgBYX3e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 18:29:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43140 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729906AbgBYX0K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:26:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PNNTXf056414;
        Tue, 25 Feb 2020 23:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gc0Boi/QFC0+w/Ku0r6VxNCG5OqN98AkGQx3eYhss3w=;
 b=Fyc++Z1XjHCl7ZhhTCkJVXyePmwgB0kCC4JyM9nvkwsfjf4kHNt9BQO/+9q+96rv42VY
 y4U3hguDMPAHAIrq8I3i11phoVjYBzmpLfYlQCbRgDfA8Op/AYP+v5iMTzULkgIxJKPo
 xRtzrZRVa3bfGQD4requDNWl48lKVmmdU0jCigU1kTA+GXJETfnLe5uQJSKwkXcz3thP
 s9dp3iwcZ5f+OfrzSUbebdmiOfYlVemCN2oSuEemF3zusjv0oTFir/yfKwiZTXhPj8iU
 5WPEpczeECwJCs9bOb+x6rNQTF/8I7GSMRzk5Me9K+GGeD7ftyQgrjm5edWm9r82GK6I dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsn839g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 23:26:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PNIHCj036598;
        Tue, 25 Feb 2020 23:26:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ydcs23ggr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 23:26:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01PNQ6sR017149;
        Tue, 25 Feb 2020 23:26:06 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 15:26:06 -0800
Subject: Re: [PATCH v7 07/19] xfs: Factor out xfs_attr_leaf_addname helper
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-8-allison.henderson@oracle.com>
 <20200225064207.GG10776@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <ccd6525f-6054-c25a-52a9-d8e77eafe40a@oracle.com>
Date:   Tue, 25 Feb 2020 16:26:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200225064207.GG10776@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/20 11:42 PM, Dave Chinner wrote:
> On Sat, Feb 22, 2020 at 07:05:59PM -0700, Allison Collins wrote:
>> Factor out new helper function xfs_attr_leaf_try_add. Because new delayed attribute
>> routines cannot roll transactions, we carve off the parts of xfs_attr_leaf_addname
>> that we can use, and move the commit into the calling function.
> 
> 68-72 columns :P
Yes, I had adjusted the configs on the editor and thought I had it 
fixed.  Will fix
> 
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 88 +++++++++++++++++++++++++++++++-----------------
>>   1 file changed, 57 insertions(+), 31 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index cf0cba7..b2f0780 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -305,10 +305,30 @@ xfs_attr_set_args(
>>   		}
>>   	}
>>   
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>   		error = xfs_attr_leaf_addname(args);
>> -	else
>> -		error = xfs_attr_node_addname(args);
>> +		if (error != -ENOSPC)
>> +			return error;
>> +
>> +		/*
>> +		 * Commit that transaction so that the node_addname()
>> +		 * call can manage its own transactions.
>> +		 */
>> +		error = xfs_defer_finish(&args->trans);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * Commit the current trans (including the inode) and
>> +		 * start a new one.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, dp);
>> +		if (error)
>> +			return error;
>> +
>> +	}
>> +
>> +	error = xfs_attr_node_addname(args);
>>   	return error;
> 
> 	return xfs_attr_node_addname(args);
> 
> better yet:
> 
> 	if (!xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> 		return xfs_attr_node_addname(args);
> 
> 	error = xfs_attr_leaf_addname(args);
> 	if (error != -ENOSPC)
> 		return error;
> 	.....
Sure, let me dig around first though, because that's going to move 
around where the states appear in patch 14.  The set is admittedly a bit 
of a balancing act :-)

> 
> BTW, I think I see the pattern now - isolate all the metadata
> changes from the mechanism of rolling the transactions, which means
> it can be converted to a set of operations connected by a generic
> transaction rolling mechanism. It's all starting to make more sense
> now :P
Alrighty, I'm glad it's coming together. :-)

> 
>> @@ -679,31 +700,36 @@ xfs_attr_leaf_addname(
>>   	retval = xfs_attr3_leaf_add(bp, args);
>>   	if (retval == -ENOSPC) {
>>   		/*
>> -		 * Promote the attribute list to the Btree format, then
>> -		 * Commit that transaction so that the node_addname() call
>> -		 * can manage its own transactions.
>> +		 * Promote the attribute list to the Btree format.
>> +		 * Unless an error occurs, retain the -ENOSPC retval
>>   		 */
> 
> Comments should use all 80 columns...
Will fix

Thanks for the reviews!
Allison
> 
> Cheers,
> 
> Dave.
> 
