Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89059C38BF9
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 21:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A12D21927
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 21:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="z/kVujjA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgBXVSp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 16:18:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56842 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXVSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 16:18:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OLIcSn063271;
        Mon, 24 Feb 2020 21:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2LamjqqvoTlVyzHrajrlTbV9BL4trHLo+9n/AepM0s0=;
 b=z/kVujjAD63Gm6SJ99JBn8gEecsJj660ef91Q/ps1MWz+VWQ29IikeddgE3sAEJ5Sdwf
 Onpg2QN0sW+dUPYY3DmxqV290MN9hPGregW9njZIjphqUabZR2JQmNCZPAtaWzb9armt
 BkTieXpoc1dbcKBHMx0sIaJnr/Og/zw4wsHqJtnrzmswLVqNV5bntlYgZSJTGhGw+LCU
 NhZmRJ8n9I/Bdm1+KNXVwA0Txi3Uxy+DKQdEbOm/WmIRqB9y0Z14JZS431nZS9nRM9mo
 Br77qeJv7LtRuw4jvWova/03xvvrDzHYgZXKECE1ixAgOkSenkNPS8laHAgBWL2pQSJd yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yavxrj36a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 21:18:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OLHtFC058123;
        Mon, 24 Feb 2020 21:18:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ybe124s0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 21:18:41 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01OLIeaU009704;
        Mon, 24 Feb 2020 21:18:40 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 13:18:40 -0800
Subject: Re: [PATCH v7 04/19] xfs: Check for -ENOATTR or -EEXIST
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-5-allison.henderson@oracle.com>
 <20200224130811.GC15761@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <47ca2613-42fd-5665-8091-65e4d09927f0@oracle.com>
Date:   Mon, 24 Feb 2020 14:18:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200224130811.GC15761@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=2 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=2 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/20 6:08 AM, Brian Foster wrote:
> On Sat, Feb 22, 2020 at 07:05:56PM -0700, Allison Collins wrote:
>> Delayed operations cannot return error codes.  So we must check for these conditions
>> first before starting set or remove operations
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 2255060..a2f812f 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -437,6 +437,14 @@ xfs_attr_set(
>>   		goto out_trans_cancel;
>>   
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>> +
>> +	error = xfs_has_attr(&args);
>> +	if (error == -EEXIST && (name->type & ATTR_CREATE))
>> +		goto out_trans_cancel;
>> +
>> +	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
>> +		goto out_trans_cancel;
>> +
> 
> So xfs_has_attr() calls the format-specific variant for the attr fork.
> If it's node format, xfs_attr_node_hasname() allocs a state and only
> frees it if the lookup happens to fail. That looks like a potential
> memory leak... Perhaps that helper should free the state in any case the
> caller doesn't ask for a pointer?
> 
> Brian
Ok, I see it.  Will fix.  Thanks!

Allison


> 
>>   	error = xfs_attr_set_args(&args);
>>   	if (error)
>>   		goto out_trans_cancel;
>> @@ -525,6 +533,10 @@ xfs_attr_remove(
>>   	 */
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>>   
>> +	error = xfs_has_attr(&args);
>> +	if (error != -EEXIST)
>> +		goto out;
>> +
>>   	error = xfs_attr_remove_args(&args);
>>   	if (error)
>>   		goto out;
>> -- 
>> 2.7.4
>>
> 
