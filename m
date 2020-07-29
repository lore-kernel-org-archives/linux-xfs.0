Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38104C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 20:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 134142065C
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 20:02:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X/RmBu1J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgG2UCF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 16:02:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgG2UCF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 16:02:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06TJvrhL180467
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 20:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pK7l19rhwspG7InRCQXVweJExc7lCxN1EcwCWX5Vtdk=;
 b=X/RmBu1Jk2NOxVm9Pr7jFNq2uY3U0AKMhnOvPKVpadD1yIZS29xCzbA0wqmsl8COUs0t
 R+JPOe/dw0GYsUqVdDoEbtI3qS1Bl5Vg7VHuIyZvcMZoKEij3LHl+lG9V9Rjgb2jGrAO
 1pOjKNBJBOkvujKu7lpwQqeCsPaRVjL17eWouo5LEa/PGuvU1O390tRETaIMXx4kOa3u
 +8aPUsbg6DS2XMrOwOTv/wfQCdm4qTxs9Ja9Uh8O0/j09BkHelaQfCKJLP6Pw6+n1SL5
 wdaMO2vgLGhzlrnOpeJ3O7JjLEB0b6fBqm+XzkTJ76KbNeRIAOS28JsEYTvQkPd2XZaL uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32hu1jqsq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 20:02:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06TJxO4g146834
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 20:02:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32hu5vek81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 20:02:03 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06TK222Q021355
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 20:02:03 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jul 2020 13:02:02 -0700
Subject: Re: [PATCH v2 1/1] xfs: Fix Smatch warning in xfs_attr_node_get
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200729043747.11164-1-allison.henderson@oracle.com>
 <20200729195916.GF3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2681bee9-5f9a-3132-60c8-09a5ab325623@oracle.com>
Date:   Wed, 29 Jul 2020 13:02:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729195916.GF3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/29/20 12:59 PM, Darrick J. Wong wrote:
> On Tue, Jul 28, 2020 at 09:37:47PM -0700, Allison Collins wrote:
>> Fix warning: variable dereferenced before check 'state' in
>> xfs_attr_node_get.  If xfs_attr_node_hasname fails, it may return a null
>> state.  If state is null, do not release paths or derefrence state
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Looks ok, though I folded all these into the for-next rebase (and then
> forgot to push send on this...)
> 
No worries, thank you!
Allison

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index e5ec9ed..38fe0d3 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1422,7 +1422,7 @@ xfs_attr_node_get(
>>   	 * If not in a transaction, we have to release all the buffers.
>>   	 */
>>   out_release:
>> -	for (i = 0; i < state->path.active; i++) {
>> +	for (i = 0; i < state && state->path.active; i++) {
>>   		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
>>   		state->path.blk[i].bp = NULL;
>>   	}
>> -- 
>> 2.7.4
>>
