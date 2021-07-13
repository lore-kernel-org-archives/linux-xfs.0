Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1052CC11F66
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jul 2021 18:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E11C560FF4
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jul 2021 18:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhGMSzO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 14:55:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16642 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbhGMSzN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 14:55:13 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DIfBMd002111;
        Tue, 13 Jul 2021 18:52:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vDnGx5vNp2oYdtpfXfOl93uTyVNOIEhzlEJNJ3mma2o=;
 b=PNhLc/8G5fqPZA+Q4rknQ62YolkcebkMaDJrASMefb8KpUIrQ1v69LAp64d/ThGkkqDk
 y1HQ90Z6ZoHo/GFamZ2K0FBkemOhMGmhq02ONY9rD3lMnPaP230b3JeSDSMHTd6QWbq0
 xd4Vm1C+TdBHgvtbTPbvcV9bG7RuQUnuXBAABXYei6E6Uad2v0E0KxP0BIJD5p3mgiY6
 JNoyZRyf/PeVbtX5tGPez89htVW0sT7KGJWcj+ReN68ECmahvb3W6k/4h5C9RBKpvxJF
 SPRgZJBIEwvkc1pHe3j5dek/bZnNQJjeQChBC8J3U/eDNmyqfKGpZGx+rB8fwTM6R7UE KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb343v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 18:52:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16DIoV2p012335;
        Tue, 13 Jul 2021 18:52:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 39q0p5d6es-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 18:52:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGi4Zu+pFD52A2K9VhhIwBWYs3s1KZ7pRwriNFxqEPaOtAlhHsNDDEE4pW/CPllwRfmU9AhAqT+D1iEEFLAVQ9w6CwCTRzR6u23LtOSl+j6v20tlVytNDpzrM1WfYelrS0FmlyI3bdKb3RZ7rUrgufgZy36RB86C8Cg0wdM/4WkFa86rGkIjv8wbSTiOCOtaCzfcazS7uQhnBElRIvmQyFqUUWU9XT9xdgD5edr83biVv30LQVSg1PZIPBD+STabnZc23+t/5Ex8WPaPKmDWy5popk4SRC7PUa+1OqbFPBkheySFGgFtMVq1hv/qKSu5vaja/hLyFrWmBbbFA8pxgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDnGx5vNp2oYdtpfXfOl93uTyVNOIEhzlEJNJ3mma2o=;
 b=f5qZP3jtGBfc6cAP47wOr7QodYIWSdKgU7hW8IhQWdmmMQzUQHjZ8sV2MAkeNc7Ar7IbhCPR7vwTb/4uVcowGwLB4f4G6/HDI5sOAymMFOIJYbDPRZlebw0vm8bYKmS1LAzYJNcLyL0VOcp+NsHPp0HYom1CyIrkpawz7vIlsHAPnbOjeufSp9wB99vaCfHw2k5Pwls2taXAS19dC22kTp4CdYt/NlXcS92oIQ4gLPfQMEq1QVV4b1CI/xxZ+ddD8n5G6K0Aj8ZyzfeUujd7JRhrnWVcP5EnKoK7P6Oo2lIf2e20A/8Ete7olWYRqAjcwY9BZBNBXHQ52hv6OrqUvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDnGx5vNp2oYdtpfXfOl93uTyVNOIEhzlEJNJ3mma2o=;
 b=CVesUUnXc6pC05x++2wmHN9pGU8GD4ROtNeOh6KhdkXADY9+Lb8fN8Gu/ZwRDBlCUBJQsqVcpfx+aSb8gqELid9Rpw7mL0YbMN5bhGZ/ytgwaY/Lyh7ftf9vB0RebiwiIcZ+7w/hO/IfeA10q9VZy0IVE81NrFwMaWEK/U9aD7Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 18:52:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 18:52:19 +0000
Subject: Re: [PATCH v21 06/13] xfs: Implement attr logging and replay
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-7-allison.henderson@oracle.com>
 <20210710010849.GF11634@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <100a34dc-a946-14ca-74bc-ce6136319563@oracle.com>
Date:   Tue, 13 Jul 2021 11:52:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210710010849.GF11634@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0029.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by BY5PR20CA0029.namprd20.prod.outlook.com (2603:10b6:a03:1f4::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 18:52:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6a421cc-36ad-4359-c68b-08d9462f57a2
X-MS-TrafficTypeDiagnostic: BY5PR10MB4388:
X-Microsoft-Antispam-PRVS: <BY5PR10MB438860399B5FF774131B245A95149@BY5PR10MB4388.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LyQdHmb13o5TfMPOn/VtHKnBW2Mlm19xZqfaNmNlvYFgRXKu1grCw1/76LrrKQVp+3L3Ao0mnEzE7ntcDrh+DkHK1MiYZ0U4RGHee01kYlNVdKS9yqTM+FIUQ4VjM+8bJR53vpvKFeG7R1mM669zk8Q2YxqaX3hVcmjSY0i+OHIprhsgXsK7JFyIAMIRKDNWhZFNI+OvaFCreo4GRzipbiZM4l6j07jgbLZ/jwcJ5Wm5HThRngC8g1GVpBmVTMVl8GdQ1Gm/yjfmi7K+3kmlcb0MgD6NRs/5oC+RnMjI27+hPulWpE5s2f7avkwZSfCVyH+B5TnZssrO+W3zONPzytoSwdq7gGIVCKj5ygtzguIHrcSmsPQFwVq2VTdKsdDTF125WfTPZOTcn57ZnddOeiY7iHi7RM9eorNsYOFuzMqZXoR08dECWhibR4smjCgHLvyrMiz4ZDJK1ECemQLYuBToFBO7wNM26CUKZwlqeAJqV0OBP7vzhbBnoH93gGB9YKky406UxIO3lG8wpnRvt+iZQeNJofCrngrwSe5m5ll/c6knqcBp33VamAj/i98IkdYAFOpG6XOdN/0qqjJvXXHXeEiX30zvMujVk6tSzXoQGy0ZY3ovIf2xt9cqAe2gPdQABTCTtWNGop7XL2DQ2RrXPHwQGYIFLLVHvB350GV8EZxyZ7s9aWzgzM4/ybkiJkbTl+UdvV9MsSeRbuMxREwYOHjoKf6dyz4XY+Kt5pXMjIdAkIkHoj9ZthAVgOx0E6VmNvqcmUC8LyRorJwIC2Ai4MgLaIiBSEN6XyupMSB56gr9c7I8MB33q3aYJ5X9QMGp2263q2eYAiFlr0ufO77rmx0dTkuBUmWsZVnxtaA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39860400002)(136003)(38350700002)(38100700002)(66946007)(26005)(6486002)(2616005)(66476007)(83380400001)(31686004)(66556008)(36756003)(2906002)(956004)(16576012)(52116002)(53546011)(966005)(8676002)(31696002)(316002)(8936002)(186003)(6916009)(478600001)(5660300002)(4326008)(30864003)(44832011)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVFRcWpzSXRrTzY2cDh5ZVZPVEJZYWFPQWx1SFhGQ2JQNHhhSEhTY09DVG9M?=
 =?utf-8?B?ZnZnUWJTUnBMUDNDWTA0YmlKMTJZQnBBeGFnNGhQZmwwRGJkMTFySTNwWmRk?=
 =?utf-8?B?ZjJTazV1ZXd0bVhNVDl6QUQyNk9NVmhaK3l1YXdFUWFRYURTSXdBUnJycXdM?=
 =?utf-8?B?N0lSVlpEZC9adHFmOStGOXViL3lCbWFiTjg3U2RiUjhJcWVFcjVTTHBIL09B?=
 =?utf-8?B?amJGOG1PY1I5VVVvNXhQN2RlUmhmYlM1VVVwMHNNUFArOXp5K3BjVUZwcGFh?=
 =?utf-8?B?aDcwMjNmUDgzTDh1L096RmNXTzljNVVwVG9LUHJNbUt2Y2JBMEhaaFJCNGJQ?=
 =?utf-8?B?aVd5Ym5hMGE5bDlWRWVCUEtnQWlTSUFJZE92dkgwVXBjR2hWcGpTTHQvcDhW?=
 =?utf-8?B?MG1vSFI1enF3YVNPTGlLYlNabGJGTjBsMlhxWVM5UVZrK0xqYUN0UHQyMC9o?=
 =?utf-8?B?ZlpUbm1yNmdZOEFlcTNSS1RoRm1zZmpDMzJiSDNBWmd4VXNCTjA4eDF4amZn?=
 =?utf-8?B?ODNjU1N2bnZQRGdjeGI4bGQrTG9JV0o5WW5pYlBrem94VDJnUEQrZzg3VjFO?=
 =?utf-8?B?TGRzcXpnUWs1L1VqeEFLZnVBQVRZN1VRd2EwcytBcCt0RGJMcWJuOStuV3B2?=
 =?utf-8?B?cktBT3BNNTEyeUZLSWllMWpZYlRjQnZsNFc2cnljclFaVEk4c3JlREpiYjFR?=
 =?utf-8?B?ZkRhZzNGbVVkOHB3alFRanR5NnZXaWNLY20wQzBtK0xLa2E5UkFPTU9KK0Nm?=
 =?utf-8?B?S2JNbVJ0SGxZZDN1ZndlOFZkOUhaczYybCtsK1M3REtLSEZlU3laMk05c3U1?=
 =?utf-8?B?enVvVU91dHRJNlBrRWxEejE3NHpydlNLVEtHUFJ3bE5tall0R1EzWURzN3d0?=
 =?utf-8?B?K3ZqbW4ydHpDUW8vYzRSTEhkMlBPZ0VUSllTQk5ZRFkzSk5mV0xua3RWU1RD?=
 =?utf-8?B?MXZQYTk4aTRzTm52YklRclRlSWs0VlZoV1BSRi95OEZxY1ZKRGQwWEd4TGV4?=
 =?utf-8?B?WXIwQm1zT3YzM2E0cHZqSVArSGk3dVNoamlPMi96dFo2c0ZMN0hCVU1jNElW?=
 =?utf-8?B?TmJUR2grL2xDaWVzc0xEdDBCVFZBV3lBZ1ZaM3hQQ1JCYWdCWUpFKzRCalVr?=
 =?utf-8?B?bFJubUM4T1pDcFkrelplT2g2VVpHdXVZMUd1MkloTnN0aGlyRC9XNGdJRTc4?=
 =?utf-8?B?YUJlWFhsYUR2bEg5c0VKK3hGeGVMS1hkVVpGYTd1U0tyNFAyZlpjcWFvSFJ0?=
 =?utf-8?B?VnQ3Qi9laDVMdEdJZEpKSWV1Q1BROExhY2ZTdUR3cGl4SEFWN2psVjY1a3M4?=
 =?utf-8?B?ZDU4Mm9wS1JlMXJKRldhN29pMmxkSVI1Rnk4ZXF6T0lHRnNwang2MlZ1Sitr?=
 =?utf-8?B?ZXo3UXNLWGpSL2ZsQkVFYzJoZ0tDVHpCblBCcUNNUUZYMEdkNGwxaTlqUWp1?=
 =?utf-8?B?aDFkQUF5SlRBenNLVUFzVktEa2xKQUk3eUlibE0yb2E0SHRnQzRVUjFxV2Np?=
 =?utf-8?B?ZG1FQytxRDhDRUdiT1JZck5LSW5md0cya2FSUTRhaGxvalhKOTBLVkhQUFpz?=
 =?utf-8?B?S0RpZlQ5QnowQ2RIeXFoWHord2IvZWY3c0NQOHllRGZpcWtKdDFGcDhYMVJH?=
 =?utf-8?B?Y0JBY2NGcHZxSFp4WTRPTnI4Y1lFeHpERDRTMkZxc0kvNm5EaURYeDA5elZH?=
 =?utf-8?B?b0tJaFQxQUVlSnBLa3Y2NjlYZ0lzYk90SC9JL0dhT243TVdMQzVsazgwLzFC?=
 =?utf-8?Q?WFhxcocZSnijXAANIOSMl7efUH0uutOo/aFdd5g?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a421cc-36ad-4359-c68b-08d9462f57a2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 18:52:19.8831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgGM1uDJd5yyxTInw0BIbdGoOXVfeBJi1Jz448EG8Zh2tCaiSDQ7xx8FGDs4/l7Ug4w0M1D42vpYZBpTMS6lTc2mTbT4FVvwLT+uIzwnJdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130119
X-Proofpoint-ORIG-GUID: AXenr4cMsBQ0ei5itlbZHVo-QN4HHJwB
X-Proofpoint-GUID: AXenr4cMsBQ0ei5itlbZHVo-QN4HHJwB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/9/21 6:08 PM, Darrick J. Wong wrote:
> On Wed, Jul 07, 2021 at 03:21:04PM -0700, Allison Henderson wrote:
>> This patch adds the needed routines to create, log and replay attr
>> intents
> 
> I might call that last part "...and recover logged extended attribute
> intents."
Sure, will update the commit message here

> 
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c  |   1 +
>>   fs/xfs/libxfs/xfs_defer.h  |   1 +
>>   fs/xfs/libxfs/xfs_format.h |   4 +-
>>   fs/xfs/xfs_attr_item.c     | 394 +++++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 399 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index eff4a12..e9caff7 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>>   };
>>   
>>   static void
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 0ed9dfa..72a5789 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>>   	XFS_DEFER_OPS_TYPE_RMAP,
>>   	XFS_DEFER_OPS_TYPE_FREE,
>>   	XFS_DEFER_OPS_TYPE_AGFL_FREE,
>> +	XFS_DEFER_OPS_TYPE_ATTR,
>>   	XFS_DEFER_OPS_TYPE_MAX,
>>   };
>>   
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 3a4da111..477e815 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
>>   	return (sbp->sb_features_incompat & feature) != 0;
>>   }
>>   
>> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
>> +	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
>>   #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>>   static inline bool
>>   xfs_sb_has_incompat_log_feature(
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index c9033e2..eda6ae3 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -282,6 +282,183 @@ xfs_attrd_item_release(
>>   	xfs_attrd_item_free(attrdp);
>>   }
>>   
>> +/*
>> + * Performs one step of an attribute update intent and marks the attrd item
>> + * dirty..  An attr operation may be a set or a remove.  Note that the
>> + * transaction is marked dirty regardless of whether the operation succeeds or
>> + * fails to support the ATTRI/ATTRD lifecycle rules.
>> + */
>> +int
>> +xfs_trans_attr_finish_update(
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_attrd_log_item	*attrdp,
>> +	struct xfs_buf			**leaf_bp,
>> +	uint32_t			op_flags)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error;
>> +
>> +	error = xfs_qm_dqattach_locked(args->dp, 0);
> 
> Hmm, this function is called at runtime and recovery time.  It's
> /really/ late to be attaching dquots.
> 
> OH, this is for the recovery case, isn't it?
> 
> Hmm, xfs_attri_item_recover really ought to share the same
> iget/dqattach/set-irecovery thing that bmap and swapext use.  I should
> really post that cleanup as a patch.

Sure, I'll put it on my todo was well, that one I think can happen 
independantly of this set.

> 
>> +	if (error)
>> +		return error;
>> +
>> +	switch (op_flags) {
> 
> op_flags ought to be masked with XFS_ATTR_OP_FLAGS_TYPE_MASK.
Will fix

> 
>> +	case XFS_ATTR_OP_FLAGS_SET:
>> +		args->op_flags |= XFS_DA_OP_ADDNAME;
>> +		error = xfs_attr_set_iter(dac, leaf_bp);
>> +		break;
>> +	case XFS_ATTR_OP_FLAGS_REMOVE:
>> +		ASSERT(XFS_IFORK_Q(args->dp));
>> +		error = xfs_attr_remove_iter(dac);
>> +		break;
>> +	default:
>> +		error = -EFSCORRUPTED;
>> +		break;
>> +	}
>> +
>> +	/*
>> +	 * Mark the transaction dirty, even on error. This ensures the
>> +	 * transaction is aborted, which:
>> +	 *
>> +	 * 1.) releases the ATTRI and frees the ATTRD
>> +	 * 2.) shuts down the filesystem
>> +	 */
>> +	args->trans->t_flags |= XFS_TRANS_DIRTY;
>> +
>> +	/*
>> +	 * attr intent/done items are null when delayed attributes are disabled
>> +	 */
>> +	if (attrdp)
>> +		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>> +
>> +	return error;
>> +}
>> +
>> +/* Log an attr to the intent item. */
>> +STATIC void
>> +xfs_attr_log_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_attri_log_item	*attrip,
>> +	struct xfs_attr_item		*attr)
>> +{
>> +	struct xfs_attri_log_format	*attrp;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
>> +
>> +	/*
>> +	 * At this point the xfs_attr_item has been constructed, and we've
>> +	 * created the log intent. Fill in the attri log item and log format
>> +	 * structure with fields from this xfs_attr_item
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
>> +	attrp->alfi_op_flags = attr->xattri_op_flags;
>> +	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
>> +	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
>> +
>> +	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
>> +	attrip->attri_value = attr->xattri_dac.da_args->value;
>> +	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
>> +}
>> +
>> +/* Get an ATTRI. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_intent(
>> +	struct xfs_trans		*tp,
>> +	struct list_head		*items,
>> +	unsigned int			count,
>> +	bool				sort)
>> +{
>> +	struct xfs_mount		*mp = tp->t_mountp;
>> +	struct xfs_attri_log_item	*attrip;
>> +	struct xfs_attr_item		*attr;
>> +
>> +	ASSERT(count == 1);
>> +
>> +	if (!xfs_hasdelattr(mp))
>> +		return NULL;
>> +
>> +	xfs_sb_add_incompat_log_features(&mp->m_sb,
>> +					 XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
> 
> Um, I think I see a bug here--
> 
> I don't see anything in this series that calls xfs_add_incompat_log_feature.
> 
> Adding a log incompat feature on a filesystem is a tricky dance, because
> one has to write the primary superblock (which means logging the sb
> change, forcing the log, and pushing the AIL) /before/ logging the intent.
> 
> All this is to prevent an old kernel from tripping over a logged item
> that it doesn't understand, because an earlier recovered transaction
> contained the bit it needed to conclude that it shouldn't have tried to
> recover.
> 
> 
> /*
>   * Get permission to use log-assisted atomic exchange of file extents.
>   *
>   * Callers must not be running any transactions or hold any inode locks, and
>   * they must release the permission by calling xlog_drop_incompat_feat
>   * when they're done.
>   */
> int
> xfs_attr_use_log_assist(
> 	struct xfs_mount	*mp)
> {
> 	int			error = 0;
> 
> 	/*
> 	 * Protect ourselves from an idle log clearing the logged xattrs
> 	 * log incompat feature bit.
> 	 */
> 	xlog_use_incompat_feat(mp->m_log);
> 
> 	/*
> 	 * If log-assisted xattrs are already enabled, the caller can use the
> 	 * log assisted swap functions with the log-incompat reference we got.
> 	 */
> 	if (xfs_sb_version_hasdelattr(&mp->m_sb))
> 		return 0;
> 
> 	/* Enable log-assisted xattrs. */
> 	xfs_warn_once(mp,
>   "EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
> 	error = xfs_add_incompat_log_feature(mp,
> 			XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
> 	if (error)
> 		goto drop_incompat;
> 
> 	return 0;
> drop_incompat:
> 	xlog_drop_incompat_feat(mp->m_log);
> 	return error;
> }
> 
> ...and then in xfs_attr_set, you need something like:
> 
> 	/* Signal the log that we want to use logged xattrs. */
> 	use_log_items = xfs_hasdelattr(mp);
> 	if (use_log_items) {
> 		error = xfs_attr_use_log_assist(mp);
> 		if (error)
> 			goto barf;
> 	}
> 
> 	error = xfs_trans_alloc(..., &tp);
> 
> 	if (valuelen > 0)
> 		error = xfs_attr_set_args(...);
> 	else
> 		error = xfs_attr_remove_args(...);
> 
> 	error = xfs_trans_commit(...);
> 
> 	/* Signal the log that we're done with using logged xattrs. */
> 	if (use_log_items)
> 		xlog_drop_incompat_feat(mp->m_log);
> 
> The xfs_add_incompat_log_feature function ensures that the log has been
> pushed out to disk and that the ondisk primary superblock has been
> written (manually!) with the new incompat feature set.  The
> xlog_use_incompat_feat prevents the log from clearing the feature bit
> until we're done using it.
> 
> Once xfs_attr_use_log_assist completes, we know that it is safe to begin
> using deferred xattrs, because there's no possible way that an old
> kernel can screw things up.
> 
Ah, ok.  I'll see if I can find a place to work that in.  Maybe patch 8 
is a good place to do this since that is where the xfs_attr_set 
modifications happen.


>> +
>> +	attrip = xfs_attri_init(mp, 0);
>> +	if (attrip == NULL)
>> +		return NULL;
>> +
>> +	xfs_trans_add_item(tp, &attrip->attri_item);
>> +	list_for_each_entry(attr, items, xattri_list)
>> +		xfs_attr_log_item(tp, attrip, attr);
>> +	return &attrip->attri_item;
>> +}
>> +
>> +/* Process an attr. */
>> +STATIC int
>> +xfs_attr_finish_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*done,
>> +	struct list_head		*item,
>> +	struct xfs_btree_cur		**state)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +	int				error;
>> +	struct xfs_delattr_context	*dac;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	dac = &attr->xattri_dac;
>> +	if (done)
>> +		done_item = ATTRD_ITEM(done);
>> +
>> +	/*
>> +	 * Corner case that can happen during a recovery.  Because the first
>> +	 * iteration of a multi part delay op happens in xfs_attri_item_recover
>> +	 * to maintain the order of the log replay items.  But the new
>> +	 * transactions do not automatically rejoin during a recovery as they do
>> +	 * in a standard delay op, so we need to catch this here and rejoin the
>> +	 * leaf to the new transaction
>> +	 */
>> +	if (attr->xattri_dac.leaf_bp &&
>> +	    attr->xattri_dac.leaf_bp->b_transp != tp) {
>> +		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
>> +		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
>> +	}
>> +
>> +	/*
>> +	 * Always reset trans after EAGAIN cycle
>> +	 * since the transaction is new
>> +	 */
>> +	dac->da_args->trans = tp;
>> +
>> +	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
>> +					     attr->xattri_op_flags);
>> +	if (error != -EAGAIN)
>> +		kmem_free(attr);
>> +
>> +	return error;
>> +}
>> +
>> +/* Abort all pending ATTRs. */
>> +STATIC void
>> +xfs_attr_abort_intent(
>> +	struct xfs_log_item		*intent)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(intent));
>> +}
>> +
>> +/* Cancel an attr */
>> +STATIC void
>> +xfs_attr_cancel_item(
>> +	struct list_head		*item)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	kmem_free(attr);
>> +}
>> +
>>   STATIC xfs_lsn_t
>>   xfs_attri_item_committed(
>>   	struct xfs_log_item		*lip,
>> @@ -313,6 +490,30 @@ xfs_attri_item_match(
>>   	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
>>   }
>>   
>> +/*
>> + * This routine is called to allocate an "attr free done" log item.
>> + */
>> +struct xfs_attrd_log_item *
>> +xfs_trans_get_attrd(struct xfs_trans		*tp,
>> +		  struct xfs_attri_log_item	*attrip)
>> +{
>> +	struct xfs_attrd_log_item		*attrdp;
>> +	uint					size;
>> +
>> +	ASSERT(tp != NULL);
>> +
>> +	size = sizeof(struct xfs_attrd_log_item);
>> +	attrdp = kmem_zalloc(size, 0);
>> +
>> +	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
>> +			  &xfs_attrd_item_ops);
>> +	attrdp->attrd_attrip = attrip;
>> +	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
>> +
>> +	xfs_trans_add_item(tp, &attrdp->attrd_item);
>> +	return attrdp;
>> +}
>> +
>>   static const struct xfs_item_ops xfs_attrd_item_ops = {
>>   	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>>   	.iop_size	= xfs_attrd_item_size,
>> @@ -320,6 +521,29 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
>>   	.iop_release    = xfs_attrd_item_release,
>>   };
>>   
>> +
>> +/* Get an ATTRD so we can process all the attrs. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_done(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*intent,
>> +	unsigned int			count)
>> +{
>> +	if (!intent)
>> +		return NULL;
>> +
>> +	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
>> +}
>> +
>> +const struct xfs_defer_op_type xfs_attr_defer_type = {
>> +	.max_items	= 1,
>> +	.create_intent	= xfs_attr_create_intent,
>> +	.abort_intent	= xfs_attr_abort_intent,
>> +	.create_done	= xfs_attr_create_done,
>> +	.finish_item	= xfs_attr_finish_item,
>> +	.cancel_item	= xfs_attr_cancel_item,
>> +};
>> +
>>   /* Is this recovered ATTRI ok? */
>>   static inline bool
>>   xfs_attri_validate(
>> @@ -346,13 +570,183 @@ xfs_attri_validate(
>>   	return xfs_hasdelattr(mp);
>>   }
>>   
>> +/*
>> + * Process an attr intent item that was recovered from the log.  We need to
>> + * delete the attr that it describes.
>> + */
>> +STATIC int
>> +xfs_attri_item_recover(
>> +	struct xfs_log_item		*lip,
>> +	struct list_head		*capture_list)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +	struct xfs_attr_item		*new_attr;
>> +	struct xfs_mount		*mp = lip->li_mountp;
>> +	struct xfs_inode		*ip;
>> +	struct xfs_da_args		args;
>> +	struct xfs_da_args		*new_args;
>> +	struct xfs_trans_res		tres;
>> +	bool				rsvd;
>> +	struct xfs_attri_log_format	*attrp;
>> +	int				error;
>> +	int				total;
>> +	int				local;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +	struct xfs_attr_item		attr = {
>> +		.xattri_op_flags	= attrip->attri_format.alfi_op_flags,
>> +		.xattri_dac.da_args	= &args,
>> +	};
>> +
>> +	/*
>> +	 * First check the validity of the attr described by the ATTRI.  If any
>> +	 * are bad, then assume that all are bad and just toss the ATTRI.
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	if (!xfs_attri_validate(mp, attrip))
>> +		return -EFSCORRUPTED;
>> +
> 
> Everything from here...
> 
>> +	error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
>> +	if (error)
>> +		return error;
>> +
>> +	if (VFS_I(ip)->i_nlink == 0)
>> +		xfs_iflags_set(ip, XFS_IRECOVERY);
> 
> ...to here should be a call to xlog_recover_iget(), which is in this
> patch:
> 
> https://djwong.org/docs/kernel/171-xfs-log-recovery-refactor-iget.patch
Alrighty, I will pick up that patch as well and add it to the set

> 
>> +
>> +	memset(&args, 0, sizeof(struct xfs_da_args));
>> +	args.dp = ip;
>> +	args.geo = mp->m_attr_geo;
>> +	args.op_flags = attrp->alfi_op_flags;
>> +	args.whichfork = XFS_ATTR_FORK;
>> +	args.name = attrip->attri_name;
>> +	args.namelen = attrp->alfi_name_len;
>> +	args.hashval = xfs_da_hashname(args.name, args.namelen);
>> +	args.attr_filter = attrp->alfi_attr_flags;
>> +
>> +	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
>> +		args.value = attrip->attri_value;
>> +		args.valuelen = attrp->alfi_value_len;
>> +		args.total = xfs_attr_calc_size(&args, &local);
>> +
>> +		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
>> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
>> +					args.total;
>> +		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>> +		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>> +		total = args.total;
>> +	} else {
>> +		tres = M_RES(mp)->tr_attrrm;
>> +		total = XFS_ATTRRM_SPACE_RES(mp);
>> +	}
>> +	error = xfs_trans_alloc(mp, &tres, total, 0,
>> +				rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
>> +	if (error)
>> +		return error;
>> +
>> +	done_item = xfs_trans_get_attrd(args.trans, attrip);
>> +
>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(args.trans, ip, 0);
>> +
>> +	error = xfs_trans_attr_finish_update(&attr.xattri_dac, done_item,
>> +					     &attr.xattri_dac.leaf_bp,
>> +					     attrp->alfi_op_flags);
>> +	if (error == -EAGAIN) {
>> +		/*
>> +		 * There's more work to do, so make a new xfs_attr_item and add
>> +		 * it to this transaction.  We don't use xfs_attr_item_init here
>> +		 * because we need the info stored in the current attr to
>> +		 * continue with this multi-part operation.  So, alloc space
>> +		 * for it and the args and copy everything there.
>> +		 */
>> +		new_attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
>> +				       sizeof(struct xfs_da_args), KM_NOFS);
>> +		new_args = (struct xfs_da_args *)((char *)new_attr +
>> +			   sizeof(struct xfs_attr_item));
>> +
>> +		memcpy(new_args, &args, sizeof(struct xfs_da_args));
>> +		memcpy(new_attr, &attr, sizeof(struct xfs_attr_item));
>> +
>> +		new_attr->xattri_dac.da_args = new_args;
>> +		memset(&new_attr->xattri_list, 0, sizeof(struct list_head));
>> +
>> +		xfs_defer_add(args.trans, XFS_DEFER_OPS_TYPE_ATTR,
>> +			      &new_attr->xattri_list);
> 
> Rather than allocating a huge struct xfs_attr_item (aka the incore state
> tracking mechanism) on the stack, filling it out, and copying it if
> there's more work to do, why not kmem_zalloc it from the start, and
> either attach it to the transaction if there's more work to do, or free
> it if (unlikely) we actually finished the xattr update?
That should work too.  I guess I just assumed people would want to see 
alloc/free minimized if it can be, but most likley there will be some 
back and forth with most attr operations.  will update.

> 
>> +
>> +		/* Do not send -EAGAIN back to caller */
>> +		error = 0;
>> +	} else if (error) {
>> +		xfs_trans_cancel(args.trans);
>> +		goto out;
>> +	}
>> +
>> +	xfs_defer_ops_capture_and_commit(args.trans, ip, capture_list);
> 
> No error checking here?
will fix.

Thanks for the reviews!
Allison

> 
> --D
> 
>> +
>> +out:
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	xfs_irele(ip);
>> +	return error;
>> +}
>> +
>> +/* Re-log an intent item to push the log tail forward. */
>> +static struct xfs_log_item *
>> +xfs_attri_item_relog(
>> +	struct xfs_log_item		*intent,
>> +	struct xfs_trans		*tp)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp;
>> +	struct xfs_attri_log_item	*old_attrip;
>> +	struct xfs_attri_log_item	*new_attrip;
>> +	struct xfs_attri_log_format	*new_attrp;
>> +	struct xfs_attri_log_format	*old_attrp;
>> +	int				buffer_size;
>> +
>> +	old_attrip = ATTRI_ITEM(intent);
>> +	old_attrp = &old_attrip->attri_format;
>> +	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	attrdp = xfs_trans_get_attrd(tp, old_attrip);
>> +	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>> +
>> +	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
>> +	new_attrp = &new_attrip->attri_format;
>> +
>> +	new_attrp->alfi_ino = old_attrp->alfi_ino;
>> +	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
>> +	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
>> +	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
>> +	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
>> +
>> +	new_attrip->attri_name_len = old_attrip->attri_name_len;
>> +	new_attrip->attri_name = ((char *)new_attrip) +
>> +				 sizeof(struct xfs_attri_log_item);
>> +	memcpy(new_attrip->attri_name, old_attrip->attri_name,
>> +		new_attrip->attri_name_len);
>> +
>> +	new_attrip->attri_value_len = old_attrip->attri_value_len;
>> +	if (new_attrip->attri_value_len > 0) {
>> +		new_attrip->attri_value = new_attrip->attri_name +
>> +					  new_attrip->attri_name_len;
>> +
>> +		memcpy(new_attrip->attri_value, old_attrip->attri_value,
>> +		       new_attrip->attri_value_len);
>> +	}
>> +
>> +	xfs_trans_add_item(tp, &new_attrip->attri_item);
>> +	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
>> +
>> +	return &new_attrip->attri_item;
>> +}
>> +
>>   static const struct xfs_item_ops xfs_attri_item_ops = {
>>   	.iop_size	= xfs_attri_item_size,
>>   	.iop_format	= xfs_attri_item_format,
>>   	.iop_unpin	= xfs_attri_item_unpin,
>>   	.iop_committed	= xfs_attri_item_committed,
>>   	.iop_release    = xfs_attri_item_release,
>> +	.iop_recover	= xfs_attri_item_recover,
>>   	.iop_match	= xfs_attri_item_match,
>> +	.iop_relog	= xfs_attri_item_relog,
>>   };
>>   
>>   
>> -- 
>> 2.7.4
>>
