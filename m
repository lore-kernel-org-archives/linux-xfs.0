Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FD3C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 00:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB2F72196E
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 00:33:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Oy1S5dr+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKLAdq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 19:33:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44128 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfKLAdq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 19:33:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAC0TPui167348;
        Tue, 12 Nov 2019 00:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MC2PpMimj2ZGtbIxYBu3WpumrpQuuiUVuXj9qgwuZVI=;
 b=Oy1S5dr+MmLUEPI4apdYPfMHfBVkTxNl1RcJTFH7Jc7oAtVvpKpMdYjthIMdpvRlU+5F
 UQK6Sj0IjvtVSsVdD+l1FuhtfEIZXFOeIFtYtupr78iO8jiwIA9CBSBN3KzIhchD9Xju
 gqrM3w0c96ZuGLOEyn2FCwd6g4Tp3YBpRx1MLGMGDW2lgSa9ijIGc7aF7RwVVz1as7uc
 9E6FDFJT6J3bMSZypCamEPk8IUroH+79SSRaH5q2cioai0htQ4hhwcKrbnGkyqmpq/iG
 Olk4zwQTAin+e2jfK2JqeV6/SLadOGSHlw9C9Z8bfj0iJH0Lafjj3hnt+07N7B+Elo2X 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvthf36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 00:33:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAC0TDMr014172;
        Tue, 12 Nov 2019 00:33:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w7hywjfbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 00:33:41 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAC0XeNl002398;
        Tue, 12 Nov 2019 00:33:40 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 16:33:39 -0800
Subject: Re: [PATCH v4 15/17] xfs: Check for -ENOATTR or -EEXIST
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-16-allison.henderson@oracle.com>
 <20191111182404.GF46312@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7bc33185-eb8f-40e1-15e5-30088e25caa3@oracle.com>
Date:   Mon, 11 Nov 2019 17:33:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111182404.GF46312@bfoster>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/11/19 11:24 AM, Brian Foster wrote:
> On Wed, Nov 06, 2019 at 06:27:59PM -0700, Allison Collins wrote:
>> Delayed operations cannot return error codes.  So we must check for
>> these conditions first before starting set or remove operations
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5dcb19f..626d4a98 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -458,6 +458,27 @@ xfs_attr_set(
>>   		goto out_trans_cancel;
>>   
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>> +
>> +	error = xfs_has_attr(&args);
>> +	if (error == -EEXIST) {
>> +		if (name->type & ATTR_CREATE)
>> +			goto out_trans_cancel;
>> +		else
>> +			name->type |= ATTR_REPLACE;
>> +	}
>> +
>> +	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
>> +		goto out_trans_cancel;
>> +
>> +	if (name->type & ATTR_REPLACE) {
>> +		name->type &= ~ATTR_REPLACE;
>> +		error = xfs_attr_remove_args(&args);
>> +		if (error)
>> +			goto out_trans_cancel;
>> +
>> +		name->type |= ATTR_CREATE;
>> +	}
>> +
> 
> I see Darrick already commented on this.. I think the behavior of the
> existing rename code is to essentially create the new xattr with the
> INCOMPLETE flag set so we can roll transactions, etc. without any
> observable behavior to userspace. Once the new xattr is fully in place,
> the rename is performed atomically from the userspace perspective by
> flipping the INCOMPLETE flag from the newly constructed xattr to the old
> one and we can then remove the old xattr from there.
Yes, I will add this logic in the next revision

> 
>>   	error = xfs_attr_set_args(&args);
>>   	if (error)
>>   		goto out_trans_cancel;
>> @@ -543,6 +564,10 @@ xfs_attr_remove(
>>   	 */
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>>   
>> +	error = xfs_has_attr(&args);
>> +	if (error == -ENOATTR)
>> +		goto out;
>> +
> 
> Wouldn't we want to return any error that might occur here (except
> -EEXIST), not just -ENOATTR if there's actually no xattr?
> 
> Brian

Ok, I will change this to (error != -EEXIST)
Thanks for the reviews!

Allison


> 
>>   	error = xfs_attr_remove_args(&args);
>>   	if (error)
>>   		goto out;
>> -- 
>> 2.7.4
>>
> 
