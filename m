Return-Path: <SRS0=NLen=BG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1620C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 16:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAA5420729
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 16:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tXuLHqR5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgG0QmS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 12:42:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51072 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0QmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jul 2020 12:42:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RGfhk7070437
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 16:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KkgZKWO21X54yOwzTeTC+mK421C3X5UxTs3Eq6Bv3eY=;
 b=tXuLHqR5bQV8umRPsmRSIqQU2NrxJ80tdvPzAYz8gL4WL7M0esiRYU7LrH4bT4EsihOv
 VrPC7YjF7G70kmMIh5uqGnbL8a65+uR6UvJyGQzI1AIEoVYCnEqXZh3dI4bHIqA7UTXG
 1oYOnXsyNDwTz1zrH8KbnS1CmGZ/7NgMnGBANl7dBCqVJ8wmq/sl8+MrMQxXNMmTSnL2
 48IuL0bUQxUHDTqsjrarKI1jgkZ2OOOnWmhRa/JJJFRji13e2m1fN3G/R78w91+vmY9e
 DT3rwl01LoJ3H5vUk3pS1wZ8UI62WMreYHug5AkdT8nWV1Zkf+j2pYI02ABls48Xq9Sy 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32hu1j2ms0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 16:42:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RGXJTk166078
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 16:42:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32hu5r1e66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 16:42:16 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06RGgFuF021619
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 16:42:15 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 09:42:15 -0700
Subject: Re: [PATCH v2 1/2] xfs: Fix compiler warning in
 xfs_attr_node_removename_setup
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200727022608.18535-1-allison.henderson@oracle.com>
 <20200727022608.18535-2-allison.henderson@oracle.com>
 <20200727154611.GA3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c5fec3a1-f253-cde1-acd1-dbda8ed9eb62@oracle.com>
Date:   Mon, 27 Jul 2020 09:42:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200727154611.GA3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/27/20 8:46 AM, Darrick J. Wong wrote:
> On Sun, Jul 26, 2020 at 07:26:07PM -0700, Allison Collins wrote:
>> Fix compiler warning for variable 'blk' set but not used in
>> xfs_attr_node_removename_setup.  blk is used only in an ASSERT so only
>> declare blk when DEBUG is set.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index d4583a0..5168d32 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1174,7 +1174,9 @@ int xfs_attr_node_removename_setup(
>>   	struct xfs_da_state	**state)
>>   {
>>   	int			error;
>> +#ifdef DEBUG
>>   	struct xfs_da_state_blk	*blk;
>> +#endif
> 
> But now a non-DEBUG compilation will trip over the assignment to blk:
> 
> 	blk = &(*state)->path.blk[(*state)->path.active - 1];
> 
> that comes just before the asserts, right?
> 
> 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
> 	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
> 		XFS_ATTR_LEAF_MAGIC);
> 
> In the end you probably just want to encode the accessor logic in the
> assert body so the whole thing just disappears entirely.
Alrighty, will fix

Allison
> 
> --D
> 
>>   
>>   	error = xfs_attr_node_hasname(args, state);
>>   	if (error != -EEXIST)
>> -- 
>> 2.7.4
>>
