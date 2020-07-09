Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3485C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 22:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C17C20672
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 22:01:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iO4zS6Sy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGIWBr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 18:01:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53398 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGIWBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 18:01:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069LvgOk190138;
        Thu, 9 Jul 2020 22:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=65FD9llL7DIvOTR7GnvcSso42yZhpb9x9kONEFxdUIw=;
 b=iO4zS6SyzEopwex0WuMQF5INZ/zN1xYfLr2BkGPDvQxtWHxrXVkn3B/GEw0v1g0lxk7s
 ncXN2wgKf1bXe/OXV37iTsyFeIZhA/jCFhivT9vvre8Ycs6P7wN6FEYQ8w8tMGcPlxXy
 GJbPdx484SA7AI1kwUZE38s80EajNlATQgePYWiGTvtylWz2UoiLsyDGa2QXbrgCeiay
 k+LXQkpTVHieK/vwd2r7wEP3bnaquBcOSou1IE4mlB4rf9rSHhCEmMtm4cqjnaEjqsLF
 SXFOF6wL3roVqp8ShJ0cg7vndPGPjC7g9OQqKjfwZ5OMalr7sOIdbk3UPxfttdubvRq0 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 325y0amauk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Jul 2020 22:01:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069LxPca012982;
        Thu, 9 Jul 2020 22:01:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 325k3j1sqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jul 2020 22:01:43 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 069M1g8i030762;
        Thu, 9 Jul 2020 22:01:42 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jul 2020 15:01:42 -0700
Subject: Re: [PATCH v10 14/25] xfs: Remove xfs_trans_roll in
 xfs_attr_node_removename
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200625233018.14585-1-allison.henderson@oracle.com>
 <20200625233018.14585-15-allison.henderson@oracle.com>
 <20200708124208.GB53550@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <920fd603-6497-7aeb-2258-3c30fd2d7081@oracle.com>
Date:   Thu, 9 Jul 2020 15:01:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200708124208.GB53550@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007090145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/8/20 5:42 AM, Brian Foster wrote:
> On Thu, Jun 25, 2020 at 04:30:07PM -0700, Allison Collins wrote:
>> The xfs_trans_roll in _removename is not needed because invalidating
>> blocks is an incore-only change.  This is analogous to the non-remote
>> remove case where an entry is removed and a potential dabtree join
>> occurs under the same transaction.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> Ok, but I think we should be a bit more descriptive in the commit log so
> the reasoning is available for historical reference. For example:
> 
> "A transaction roll is not necessary immediately after setting the
> INCOMPLETE flag when removing a node xattr entry with remote value
> blocks. The remote block invalidation that immediately follows setting
> the flag is an in-core only change. The next step after that is to start
> unmapping the remote blocks from the attr fork, but the xattr remove
> transaction reservation includes reservation for full tree splits of the
> dabtree and bmap tree. The remote block unmap code will roll the
> transaction as extents are unmapped and freed."
Ok, that is a lot more detailed.

> 
> With something like that in place:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Sure, will update.  Thanks!
Allison
> 
>>   fs/xfs/libxfs/xfs_attr.c | 4 ----
>>   1 file changed, 4 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 1a78023..f1becca 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1148,10 +1148,6 @@ xfs_attr_node_removename(
>>   		if (error)
>>   			goto out;
>>   
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			goto out;
>> -
>>   		error = xfs_attr_rmtval_invalidate(args);
>>   		if (error)
>>   			return error;
>> -- 
>> 2.7.4
>>
> 
