Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2684C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81A816112E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhDBJt5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:49:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60524 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBJt4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:49:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329SYxW176738;
        Fri, 2 Apr 2021 09:49:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZPCzlMQAjaDAJegfM4HZtLh2EVLAbzU+YX4aUOwI0J8=;
 b=R1lwCJC9+AbmJ/MtSjl5IKBRpDdS+MwH8DZoH5iqFO3SBvUwsHZ78SgtXDBOKb8S1yT0
 HVi1N0C4tr5P7cba+FmkxefCKEtE1AN2BtLTvVNgijNGX+TYiQ6ioo9lZ+KlVmYXtnGX
 xAAYaWlqN3V6vODxy4jwQQ7K1BGl+SCMGQogJTMD64D6tBFppcP+q1LOv/IznHE5tD16
 +tup2GOnjubT0FWupx92sKKCn58xZR55GlN6dgA3xNVzse+9FX9Uvi/xN9qGbY6DFRzB
 GKtnxQ6bMvE5f0BmD5iXOsYryHBrbs+cPCixXmwjNUIIxNQPKVBZ/Xyv1KWFu4oJ44AN Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37n2a04a7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:49:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329jeKG173734;
        Fri, 2 Apr 2021 09:49:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 37n2atw4gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:49:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4qA+oaImPxtsdt1ZGN1xDc01Iov4pJyi3FbHJZd5bPcorEgI0P6R8vQiiCg/mHfiYkG86Pg4Xds6qPQcGpbeZI7jSxcL3oK1flDEJu9WeJqE1PEyIWSRksutt1pqDCi+tfhlyDD43C8R+n2fmaC3t9vp8ZzqNeewRxFAtzBLZb69FS8BALg9jM4wUh9+XjuOTiQNcDg1NNwc0TLZH4+/zis8L6XM42QtdFDj6zM+hfWZN6uHZMDYXR1doP4BU71TIxUwnuRzn1oekM+tAN/Y0iYbWj6PATZAbMVOjRuhGA24Av7yEGzVoBNtxvpHVRsnslZj+MM5vYHmqm9Guowzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPCzlMQAjaDAJegfM4HZtLh2EVLAbzU+YX4aUOwI0J8=;
 b=BiE/zQhrkRvxPCGD5w+IJ/kEHgZ7jnMDQEWAmR1HOk5bRqKUYfhIJ39cmEHR1n9tr7TOSJn+AAr7FL8SoLXlwnZWXWlGxYiVU3S2WIomTTaa0uE0Ci6ivv5AElw2dlUl0eOlJo/MR0vVo+PuF7EoEu91O+Y5UfKzz7kTfxdm2qwP4KYB50LW8V+AJXV+KPONCtpUqoSxK4zp5VIT3+OvRID0TxDtfdHuuZXBOWzhIG/9m/v8HA9lG7h9VWrYt/n+hKTJawhdemXtNr9AqeyCXQo+BvJO+20I4kgbBBPyRdh4MoGOJRCntPvxILWLEGnvkCl/5wPFciyOafirOGzfLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPCzlMQAjaDAJegfM4HZtLh2EVLAbzU+YX4aUOwI0J8=;
 b=Zr1KusXmBWEQ/F93Yb6atoogumwg1LqS2ndvWOi/bZ7/8yRHmNT2gqTW1NKlsytGA6c8yMG1YgcSgd5pd9CF/WSoWuwwuhaL5Jg95XvgczPXYkg79VA1VrrbFkraM1qDRlGSmBwgiXHwxYbbCmffqVJi2xJ3izslV1X+/WmhK9c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3510.namprd10.prod.outlook.com (2603:10b6:a03:120::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 09:49:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:49:50 +0000
Subject: Re: [PATCH v16 01/11] xfs: Reverse apply 72b97ea40d
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-2-allison.henderson@oracle.com>
 <YGXqEdJfzhES/xDz@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a197c349-3dac-797a-491b-474fe86e848c@oracle.com>
Date:   Fri, 2 Apr 2021 02:49:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YGXqEdJfzhES/xDz@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:a03:74::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR05CA0060.namprd05.prod.outlook.com (2603:10b6:a03:74::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Fri, 2 Apr 2021 09:49:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1a0082d-b183-4386-10e5-08d8f5bca8cf
X-MS-TrafficTypeDiagnostic: BYAPR10MB3510:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3510FA8C5CDC929560C63746957A9@BYAPR10MB3510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:494;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7sqR/F4mLZyNQaJapXEWj9X/5HE7CN2bEgp1BhghEhwBnOqtXDNVf0kZsmhjLvl+YKm98u5N1OwbbFXawgPxY+S4wr3I7OXrl6OBbhJgvp2ZW4NCgyFFc2W6CDfH41Rzs+FvzyB6xRXnVFfQVj6JfVESjze/mfaQ/TTM5NJRkfG72SDSFAfkH934fX4ZDwt+Rz0M71K+t8PapmBIPTzlzM94JDO5HE9Hej5hEyrcuuyoeIkU9G84kV8MaQ6RRRTNK0pra7NUHhXp7MNgft+M5hKJl+KvpjZO9tPbnZx1EHfaM0hDA/emNxsBoCZpjqnCuxxmOqw2DUgomPLPdTrgTNFlDdHcaLU4OetaECpym6lWJhvsa1tm5QVL6Cp2xcqe457Pa7a7Rmqik/6TARuiFypUoDzE2OH4+NF/Kg2EGAE+tfZp7sdFyvUQgtKP0HgC/5CPjYYKD/jRNbHHnjvHBiDEBXAL3CB8u3m0dSqv4nM4v40cwKaW/pNEtxulIky0uByKsjEAA2ln7hImJG1ao9VYIfPziMuNTlzxk38hinT8FVbz3vjcYBb8MCdO+08zmjOyLw86JfascVTXEExiIhDaEZ6yZI0t5iOJ7/XXslEz1GeVglwWuXam9kgA9w5T2MRFo5WDdnhYUm8DQDatZ6qorQax0e9nPK2KLYTmg4Y3/vC9metBVUizoLGDJ+7uJVMT3WU8+5BY1WbElJFdYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(136003)(39860400002)(4326008)(26005)(8936002)(83380400001)(86362001)(8676002)(186003)(16576012)(316002)(16526019)(52116002)(38100700001)(31696002)(2616005)(66556008)(66476007)(6486002)(53546011)(956004)(478600001)(6916009)(44832011)(66946007)(2906002)(5660300002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eTBjTkdlRHNQSjA5VzFnMTQ5QWM5TzVRVy85OG05M1dTcDh0ZU1mc29SVzAx?=
 =?utf-8?B?a2JCRzZKUm5PZ1FrUmxvb29PNXVGOHEzS21MUFdHamlRdWpPR2h3dFRvNm5p?=
 =?utf-8?B?TUlIb3l5MjA2M1hvSWVZTndmZjB3L3l4UU9qU3NwbTFjZCtMa0RqamU4b2pF?=
 =?utf-8?B?WHBaaHNBWUdvMDBwUUYxWjlrTzBPRkJYK3I1RWczWWdyNHgwdXQxWTlSdDhu?=
 =?utf-8?B?TDNObml3Y3p2KzFuci9oRVc4anNnamJoSGJJalhjTTFBWEhabUwrVzhXMDd6?=
 =?utf-8?B?UzArODRsdVgzck4rVmJxVWkrMHdYZEl3L3R5YVRsOERtZWhiUTgvUVkvWUZZ?=
 =?utf-8?B?a3JHekh2cWRmSDRIME1zSnNDdlNNakQ2OTZWZGlMRlMwWUdjbTJwOFJ6dTRN?=
 =?utf-8?B?bEJiQjRaVVpWSjNydndQVTJVUGwwbmJteWpmdndxQU9Td08vSnREaXlsQ1g1?=
 =?utf-8?B?VmJRL20vVnJSMWhaazZTUWZJV1N3UzRROFBENEVrR3ByTG45a3lJRkE1YlhO?=
 =?utf-8?B?Z08rU0doV29LaWsvUGJySFFpZWtYeTkwaXJPUmlkRHJFcEpEdEZsYVdrMldC?=
 =?utf-8?B?Q1h1YWlYNkxXeENXYXNZeHR6TDJhOWVQY2JuS3djM2pNSVMvcTF1bStUTTZH?=
 =?utf-8?B?SXBSemhyRHFST0pqdzlFUjFTRE9xano3RDNtOUxpczNqV01CSzhKb3NReGFK?=
 =?utf-8?B?aHNkOVNkTVBHVUhOczc2Y0VRY1ZWbVl1TWdCUk10YjczZ1QzVms1QkdqdCtZ?=
 =?utf-8?B?MnJqWVlUMGNyY3NvQnBCTzB5OVNFZWk5SU1aWUEyWTl6bDhjYlZGR3hia3VX?=
 =?utf-8?B?TGtMM29SN3l4WjhSUkdNUVhIUGxlZ0dBQk1mSjF6amlBcGxWVkFKcmMzbG1P?=
 =?utf-8?B?YzJabng3OVpYYUpldHRZN0pzb01HdFVGZmdicmdkc01MMmtWSDVub1lHMzM5?=
 =?utf-8?B?dG84OXFnRWJOc2FZeHYvN014Rm5vU2ZzNjVETU9aSnRINVJXdncrY3RRUG55?=
 =?utf-8?B?OUNneHZ3WUxMNW5UN09oL3JxZjBQV2FsK3dOQi9xRTAyZ2lLcXN0KzF3OU5q?=
 =?utf-8?B?LytIcndrMGEyb20wd2l1ekR4QUZiL1hTWjhqSzREdG5WdURsZTQzRDZJQk9F?=
 =?utf-8?B?LzVHdnlyMFg2TERUZ1Z0blNQWlQ3eHUxdnNqK0liLzUzdG40VkVEU3d3SDY0?=
 =?utf-8?B?Mzd2anNQNzFTeGc4RS9wUXNFeDJqdjlvWjl4bFViSGhtbmZzNTk0WkpJZ2Nl?=
 =?utf-8?B?c2dza2dUUTZZU1p5bUdPRG5YVldkaDNRU1lKdTBGVGRHaU9MK21aRGhZYXd1?=
 =?utf-8?B?TXdjdUFRdWU2OXBER09aWTJKeVk2azhXSDhZSWpoTUdxMHIwTHZWMDViMmNR?=
 =?utf-8?B?K2FocjdQaXlZU3lnMWVZRFNBVUM1UklvcU1GdmsyWUdiMHYvNXBXKzNBTUsz?=
 =?utf-8?B?M0RHdVdQWGRwcEN2dzNWbm1ZYlNEM203TjNSdEYzblM0Z0hyVEFlR2lqUGpZ?=
 =?utf-8?B?M2p4Y3Fkc0dkVlQ5c2JkWFF3LytON1pva3NDb3QxOTBtWWlZZlphOGQ2SkdB?=
 =?utf-8?B?U3d2Q2p1SnRIUUY1MGRrN3VDcmtDMVVvenFhU05TWHFKOE9sMmF5bG1WR1V4?=
 =?utf-8?B?UUU0bWo1M1JrYVR5Yy9QeDhlb1NpOXQ0NjJHa2NUMWRKZmExU2FnZ1F1a3NT?=
 =?utf-8?B?TGZ5ZCsyMitqZ3hsRkJGTDZYNEVoQW9OeWM1c1QvWkg2WGNFZHNiNXV1dU4y?=
 =?utf-8?Q?zR2lwWbnd2QPU3XD4Dv+7akdXhdcagDqZhny5uh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a0082d-b183-4386-10e5-08d8f5bca8cf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:49:50.8819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBSme/klxX+wku9EsdRAHPrW3+ZrKUaIBI3r9CBBR2U+aLpezmATLAn1O0ZZ6ksYAiMl7RYYsf5iy+aeUhGb53DwHziZxeMj+EX9YvYz+JU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020068
X-Proofpoint-GUID: zWsOVA7KMcGRymdpH5YmMJaaz0afxUQj
X-Proofpoint-ORIG-GUID: zWsOVA7KMcGRymdpH5YmMJaaz0afxUQj
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020067
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/1/21 8:43 AM, Brian Foster wrote:
> On Thu, Mar 25, 2021 at 05:32:58PM -0700, Allison Henderson wrote:
>> Originally we added this patch to help modularize the attr code in
>> preparation for delayed attributes and the state machine it requires.
>> However, later reviews found that this slightly alters the transaction
>> handling as the helper function is ambiguous as to whether the
>> transaction is diry or clean.  This may cause a dirty transaction to be
>> included in the next roll, where previously it had not.  To preserve the
>> existing code flow, we reverse apply this commit.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Thank you!
Allison

> 
>>   fs/xfs/libxfs/xfs_attr.c | 28 +++++++++-------------------
>>   1 file changed, 9 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 472b303..b42144e 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1202,24 +1202,6 @@ int xfs_attr_node_removename_setup(
>>   	return 0;
>>   }
>>   
>> -STATIC int
>> -xfs_attr_node_remove_rmt(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_da_state	*state)
>> -{
>> -	int			error = 0;
>> -
>> -	error = xfs_attr_rmtval_remove(args);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Refill the state structure with buffers, the prior calls released our
>> -	 * buffers.
>> -	 */
>> -	return xfs_attr_refillstate(state);
>> -}
>> -
>>   /*
>>    * Remove a name from a B-tree attribute list.
>>    *
>> @@ -1248,7 +1230,15 @@ xfs_attr_node_removename(
>>   	 * overflow the maximum size of a transaction and/or hit a deadlock.
>>   	 */
>>   	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_node_remove_rmt(args, state);
>> +		error = xfs_attr_rmtval_remove(args);
>> +		if (error)
>> +			goto out;
>> +
>> +		/*
>> +		 * Refill the state structure with buffers, the prior calls
>> +		 * released our buffers.
>> +		 */
>> +		error = xfs_attr_refillstate(state);
>>   		if (error)
>>   			goto out;
>>   	}
>> -- 
>> 2.7.4
>>
> 
