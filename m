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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D568C433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 16:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0657020719
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 16:51:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dLQoBQ8V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgG0Qv6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 12:51:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42046 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbgG0Qv6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jul 2020 12:51:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RGg7Nq123106
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 16:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WM9GYCeB5OceEr31l1P60d2visXsLCjD/G895UXFntU=;
 b=dLQoBQ8VlTcNdhvbMHLub8KC8c8HdVG4otzyv7qIwtrUzmam/duRIIWpN8w9GNGd/fKU
 rkW3DZn3Siq6dr5YJTn1JbOVAir/4v3QUyYZBCtagfnT/idbOpEZ1ivNzy/McyUyXvr0
 TNDNsuITrfX3/YXFn0OB8cFlWGC2QKKDZDoxXIO+Ts9GhB9wkOgmXRRrugken+lIdY6h
 kLgaLecCbcJA6ozie8sW0snpHKz2AJ61q8b2ZrMXKtc0XYqm9sXZwDLs7s+VlO5HIZKi
 ANzt2C31oSf5tw44QNp+Zozn4y4CsVIJ8Z8+XBgUra0ap8bfhWP1/5kuKqkO2R4/iUif WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32hu1jaq14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 16:51:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RGiOJp192714
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 16:51:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32hu5r62ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 16:51:56 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06RGptRG026621
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 16:51:55 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 09:51:55 -0700
Subject: Re: [PATCH v2 1/2] xfs: Fix compiler warning in
 xfs_attr_node_removename_setup
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200727022608.18535-1-allison.henderson@oracle.com>
 <20200727022608.18535-2-allison.henderson@oracle.com>
 <20200727154611.GA3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a641cbc8-6cda-25b2-f6e6-63e52fde572a@oracle.com>
Date:   Mon, 27 Jul 2020 09:51:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200727154611.GA3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
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
Are you sure you'd rather have it that way, then once up in the 
declaration?  Like this:

#ifdef DEBUG
	struct xfs_da_state_blk	*blk = 
&(*state)->path.blk[(*state)->path.active - 1];
#endif

> 
> --D
> 
>>   
>>   	error = xfs_attr_node_hasname(args, state);
>>   	if (error != -EEXIST)
>> -- 
>> 2.7.4
>>
