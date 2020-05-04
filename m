Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DDEC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 23:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4569C207DD
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 23:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aC851loD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgEDXRX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 19:17:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46004 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgEDXRW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 19:17:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044NDPd4092636
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:17:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=900oY1pyZWbvBdPdZQwtXEtPXZ9BkVyZzEFG+1IgzHE=;
 b=aC851loD6bnmF/tn6sufREKLsfTbWoGDDG99G6QMen2JdDfWzw419xZ3+uTXT83G0/tz
 Ua0uuFNTZcWCQxpWQD7dwDTZzVqVbUipljmpp4BqiQG9ViUbNN/U4Xp6uKMcDjor1e5R
 YjyvpfJ4vnRtPoR8kRbwblNENx1M8QttnpnRAKVmWlBcJk5u7bjFPd+ieXIPH47Oms1B
 C+HznmFj0VuFe0AwAe36oVkUDHq9nB3n/HDmGWVioA7dpGlI2Rsr61aY7DMTxx8aSfWP
 7cPvIAizmtriwvDYumSimWx7HyPgtzzUv9xZw9ks4Fx1MwXKC0Nx5bieBRPRIzPXdpgp Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30s0tm9sn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:17:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044NHKHO030688
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:17:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjncaxbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:17:21 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044NHFK3000913
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:17:15 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 16:17:15 -0700
Subject: Re: [PATCH v9 21/24] xfs: Lift -ENOSPC handler from
 xfs_attr_leaf_addname
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-22-allison.henderson@oracle.com>
 <20200504191015.GH5703@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <3271054c-6ca5-fdaf-a2c8-b698160322e3@oracle.com>
Date:   Mon, 4 May 2020 16:17:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504191015.GH5703@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 12:10 PM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:13PM -0700, Allison Collins wrote:
>> Lift -ENOSPC handler from xfs_attr_leaf_addname.  This will help to
>> reorganize transitions between the attr forms later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Looks decent,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
Ok, thank you!

Allison
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++--------------
>>   1 file changed, 11 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 9171895..c8cae68 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -299,6 +299,13 @@ xfs_attr_set_args(
>>   			return error;
>>   
>>   		/*
>> +		 * Promote the attribute list to the Btree format.
>> +		 */
>> +		error = xfs_attr3_leaf_to_node(args);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>>   		 * Commit that transaction so that the node_addname()
>>   		 * call can manage its own transactions.
>>   		 */
>> @@ -602,7 +609,7 @@ xfs_attr_leaf_try_add(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_buf		*bp)
>>   {
>> -	int			retval, error;
>> +	int			retval;
>>   
>>   	/*
>>   	 * Look up the given attribute in the leaf block.  Figure out if
>> @@ -634,20 +641,10 @@ xfs_attr_leaf_try_add(
>>   	}
>>   
>>   	/*
>> -	 * Add the attribute to the leaf block, transitioning to a Btree
>> -	 * if required.
>> +	 * Add the attribute to the leaf block
>>   	 */
>> -	retval = xfs_attr3_leaf_add(bp, args);
>> -	if (retval == -ENOSPC) {
>> -		/*
>> -		 * Promote the attribute list to the Btree format. Unless an
>> -		 * error occurs, retain the -ENOSPC retval
>> -		 */
>> -		error = xfs_attr3_leaf_to_node(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -	return retval;
>> +	return xfs_attr3_leaf_add(bp, args);
>> +
>>   out_brelse:
>>   	xfs_trans_brelse(args->trans, bp);
>>   	return retval;
>> -- 
>> 2.7.4
>>
