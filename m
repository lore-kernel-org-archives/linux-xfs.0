Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F9FC433E4
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85F92206D7
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:08:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s1LPF/ZL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgGYAIb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 20:08:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53028 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgGYAIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 20:08:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ONpTrR136893
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Ytr/c0eIc8VjMjSEqy6hfCBYk6S5Ft42M6v4B9MZufA=;
 b=s1LPF/ZLrgYK+tXXGa3Yc/Ms9fEOQZzyz9hte+wKZaGkxNgMQyMCOgM19FysaKaui9gj
 dpC9m3cvGIXCG1UQ0eE68PUcv8B1FogS1ua7AN0GFtEhK/MMml+usZEcKJZZ3vEIeInO
 e0iHT9s1nPJRH5YAVm0+1K5TQ7P8pNF3+dFr7FDJYsc9tP1J6vTwtki+hv7ioOFVtAI4
 49pL7eemQE2hlsaBSGJzLKl0Uu410CJh2okpVj7deAhRX/MxtLalD82WL7lCkqosP6rf
 F8DOoTpN8w1SCObWxgr6K+gg6BDMH2IXJRiSjLvrqBzJTkx8EzmsxIudB+URth3CmTN/ TQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32bs1n1maw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ONsZgC047819
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32g7xv44y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:29 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P08S2h013701
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:28 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 17:08:28 -0700
Subject: Re: [PATCH v11 14/25] xfs: Remove xfs_trans_roll in
 xfs_attr_node_removename
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-15-allison.henderson@oracle.com>
 <20200721233830.GJ3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <4550bbc7-0b0b-1f9c-6f20-1fcf34427c5b@oracle.com>
Date:   Fri, 24 Jul 2020 17:08:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721233830.GJ3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/21/20 4:38 PM, Darrick J. Wong wrote:
> On Mon, Jul 20, 2020 at 05:15:55PM -0700, Allison Collins wrote:
>> A transaction roll is not necessary immediately after setting the
>> INCOMPLETE flag when removing a node xattr entry with remote value
>> blocks. The remote block invalidation that immediately follows setting
>> the flag is an in-core only change. The next step after that is to start
>> unmapping the remote blocks from the attr fork, but the xattr remove
>> transaction reservation includes reservation for full tree splits of the
>> dabtree and bmap tree. The remote block unmap code will roll the
>> transaction as extents are unmapped and freed.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Urrrk.  The analysis is correct here, but whoooee was it hard to find.
I know, its a lot of explaining for what looks like such a small change, 
but better to have it than not I think
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Thank you!

Allison

> 
> --D
> 
>> ---
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
