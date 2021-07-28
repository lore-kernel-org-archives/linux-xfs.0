Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98262C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73F2D60F91
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhG1JBy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 05:01:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42162 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234963AbhG1JBy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 05:01:54 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S8qds2004091;
        Wed, 28 Jul 2021 09:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ToMvpdg4l+YmmubqdGpfSNO1USw2mmNsfrt47s0cob4=;
 b=GKTGGDIgb957TkR1Y57c1ujZAAUdk0XCk3cx7KviPjaDhUhZWKVFCVYE5t7bEJQoyvS1
 /BMJpBv3t6bNMW9fJu0OoCqoNcTzbCbpiNn6atGHmr/nylHvdDIEOKUZKH/+hprTpriR
 w0aG4c39kYPoGzkEXtePYGXFB/ZNSF3ucUr9oSbdOb2fXqBIwr7I7Xn3OO86ww5ZdpRF
 JrrtHOSGTigOn6AG7Z54pKE9riYprn0Y5ObYvxVrwseNYJZsaIYxAD06soHQFPaPH7w9
 3ou+66yPN5O5DgYBNLusHixTqVoQJgAX1x33tC7y5dsLXcwzCP9mggo+4O6wZSYXlApX CA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ToMvpdg4l+YmmubqdGpfSNO1USw2mmNsfrt47s0cob4=;
 b=h7Lae+iK5DzI/uu/N77qAUN2oawuQ9vQQajm6Bk67aWURwY27rtaNWtr1UgEZ0LchetN
 l0x/Ta5Ed9llUmjNyPkH0Atfq7FkORdHdUn9ij4rnSKVN4fHlN/jE35iH1yx6J70ipKG
 IHqSslbB/H76XHuuJ89QkSRFQLKuyXf6QlsBd/7JMtttc3KHTYIALy6Ikk95Hnhqdzel
 8JgT7MTms74Wd2+SN2a5toWjmC8M3tR2N7y9P9HpXjImD9UIdxdKCnB5/RxgpTsVeGL9
 uBLCkfq2bRlxEPVJzX0z/PAm/xyr+8x+rgYwp0n89yGKn6FzBgGoa6rJS2dbEp4ZagrR aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfa6y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:01:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S90vOI167335;
        Wed, 28 Jul 2021 09:01:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 3a2354rjs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSHSknkvsCxHvcg+cfTCkG6xd4sA7d4AT2I/a6RUNCN0qXH9l5hH5iXnC6bwa6lAvbHdmyT+Xy4q2sBfv27D9RqBNgY41EiPDVnWc7Z7/JZVwWLra3+J1QJJ9ARfvn0ja/syFvnDZHRL8psoYyxa1GAj1QvjICnTCfU5HyaMcLQzrLJsN4CGtFRQIrcRofnGV2UIGslZAvCExc8p4RYxlNQtf0qlcG4/BPucl8Nsik+WcCjcgIGC0mXhuubhVExoBkaDztgseKPZODLjFDroCUyYAmuq4Mku2Ye+VcXCGsM/XgEM8BHJbR4zJzL2uJArC1oaww3wFW3efaM6cOIO4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ToMvpdg4l+YmmubqdGpfSNO1USw2mmNsfrt47s0cob4=;
 b=Bcpgro5cHx7dZY58o/pKDR1ftfXM74dRYxQrZmea+h/PvPMe6ismyUXy8kR9te9TnUyyhVzXMqyQ+37iFcXJrKR/T9e30Lxe1DFrnOqVoFaF8WRaopz/mu06jDpvvQoqLcJxZpC8je4k5tBDgg00mMvs2gXECk7G5dam3jh8J8+OOHNeXjbPe4vNhuU221AhWPsK0/9p9S69xyBrnfgsMhcZnJu3SU2Tc+Cc+pb2+5MKfE/2L+eNHnzbaaSIOeW1NMQRqZojGAjL83eYFP27CExzeGZ/YxitsOlkVJECZPFmPg3WoRyySh/gXQWVQA6yJLxqYaRO0xfTh/4+84yNdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ToMvpdg4l+YmmubqdGpfSNO1USw2mmNsfrt47s0cob4=;
 b=MNVVV61o/Fxgbn6Oa1q5y1PVRmoABH+UMtj55FksBtbrSPHPRVfR9NbUjo5nb8gUXw9cgcLbTIwEvSU77ZQgJ3bWfybhYkQODBMPQobZKPeH4upU4FH531DHLfAUdSIRgYmJQoXIUngdnzJi/JmDb6Z9T27gCfOooYqL6VXIF4g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2792.namprd10.prod.outlook.com (2603:10b6:a03:87::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 09:01:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 09:01:47 +0000
Subject: Re: [PATCH v22 01/16] xfs: allow setting and clearing of log incompat
 feature flags
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-2-allison.henderson@oracle.com> <87bl6oeyh4.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c094d50f-d836-8ae5-3dae-0b301789319c@oracle.com>
Date:   Wed, 28 Jul 2021 02:01:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87bl6oeyh4.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by BY5PR17CA0015.namprd17.prod.outlook.com (2603:10b6:a03:1b8::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 09:01:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 959824d6-5b18-4a87-4af2-08d951a654cc
X-MS-TrafficTypeDiagnostic: BYAPR10MB2792:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2792E1334D5C4DB0758E7E9B95EA9@BYAPR10MB2792.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:519;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1E42UZRN3tsyjE2FVZh+WgtsRHa1150CjFcuyE9wqMQ9SN0bGsm2XEj02z1+Z86ynV9yAAU9xbXlySWjFnGSc0l1RQxfVdWg4oO+wXbg9LjnIjW+6nGkDXobh+OgnSvJy8Vt+3dDyA+cXh6AR3767wLoUdNpHahUJI2vUhsa9fNwYuY811TRFCBHz9lNxGp01NWQtDwkXuBUV4RJ1yBVf2t6jOp7cy/9l/U485p3rkMv8488bqRwU4ZzQqnBlQN7+DlXL8wzqxH1O40L0f+U7ygH/Lk4zUAHFzPdUiH91KNhP2SgHz20FDmgldv0l1Chaeek0itKJs8p5RZUr5Z+QwkUSKPJwMnIYtLB7bxMWx7/Ken/3uqP5mseBBLu8BzAdRE2fsLdJlb8VbnYzkrgqJG4/sfINVrxNgV1vp9fPtjg8HfZ8qoCnwDppncV1qovhU6NywdReDdofUqxykoQXxw3syrqM8Vy9bUWrWhx3si4y7N/P9z/6o8tIPducoyJkKihOTIyCjmF5y3NLlVqmgNE13nnraxl2DbFRnf+StRjCGBjVUlAsMFwmblU5fD78Q2IfE8MdCZQfVpNLcFZZgucNwMPC889llgmQBqSTf0GnuwRkMEDRQHkivEO0zBowanQvlVHToiuOzG4MQNb7fqZVyhxot+OADIYd39SgDCzO5q5CpwtCHrDsOuRl289SIQBYDgpgJA5D+Ztrv9n0YZOSry+EuAOqdhBvVFhoJ3/IcrKLboNWg95vqUqnhcgNRs0BFjO933IaQ2suYr+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(366004)(346002)(136003)(66946007)(36756003)(31686004)(66556008)(66476007)(16576012)(6486002)(316002)(44832011)(4326008)(6916009)(2616005)(956004)(8676002)(478600001)(8936002)(2906002)(5660300002)(26005)(83380400001)(31696002)(53546011)(186003)(86362001)(38350700002)(52116002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnlvZm9EMVg4RXYxUEN4ZlU3ZS9ST1BOT1NRbXRIMzVKMEJ3UUltZDA5dmFo?=
 =?utf-8?B?elhyQlR4NXVXTzU5K0xzNzZBeWtqUElvU2xvYThjTXZXODV1LzBQaXpjQklh?=
 =?utf-8?B?RFZLZlhEU2N2UHYwb1haclRQU2ZzalpjN0NMayttL0RBNk1UMzV1NmE0UUtY?=
 =?utf-8?B?TTRIeHRRbWx2SmtqcnNMWFFwdzhiN0F4U0VDaElrdm54aDljRSs4YU9Nb0RS?=
 =?utf-8?B?eFNGSUV1NUpGYkdqNDU1MUVkc2hGVVFKWkVray9OU3gyeGthck12LytQYStR?=
 =?utf-8?B?TzJNTzY2WlgyL1lWS3RvWEJoT3daRmd5cEMwSW53N2xhYTZ6TmZpa0NxY0RY?=
 =?utf-8?B?dW5QZGQrTkRWcVQyVisvbjJ5MWFtK1Y3MDNod0ptRFZRaE1Xa1pjNExCdTZB?=
 =?utf-8?B?Wmhjam1HcTF4TE15b05DeGFOcDR1cU9PZnA2Z04vbUplaGF5N1BBQ3IvdDB3?=
 =?utf-8?B?TjhvVTBjc1FrV1RkTWg4aVR4aFo4Y0MyVE85Q0plY1FBaWxnVnZzOW9peUhS?=
 =?utf-8?B?WGZyUU1ZRVcrcUVjcTFjamFaS25kR1FvRmZOYWxNNnRFQytxRUU5Y2UwYm9w?=
 =?utf-8?B?eHJtajhnS0hIalpkTW1Ma3Q1Q1lFbDlPYlBMZkwrUjhYaG8yUTRUOXBjbC9n?=
 =?utf-8?B?eXRYRDhtTElrTXFvZ1JEaGdwdTY0U0l2SXM2WHd0cU5VVTBCNzhjN1NZNmlM?=
 =?utf-8?B?ZWxRdjVqWnhncFBsTzU5RlZzblU2cjZrNERTRjAvNmFsa25qdU1aWERIMTJO?=
 =?utf-8?B?eS84dFBJV0dtaDNLaEJzOTBDdks1a2QrZ2hKTTVNS2xXa2Z5U0I0V2gzd2pD?=
 =?utf-8?B?S1VuTjgraGtaMGQ5Wm50aFRISzB5K09wMTM0RitHd3JzL2dZRFljbzFFbE9W?=
 =?utf-8?B?a0NhQUxJSkNwNHExWEozMXM1ZG5TUDF0MS9MeXJaWVBpcWFnTlRyNDMrclZO?=
 =?utf-8?B?cG12bzdZSUFCQmdaQXdYeEptTDJ0TU9ZcndmSkkvekVua0lMZEd3b3BMV1R2?=
 =?utf-8?B?K0ROM0h2M2RaRXpEUzRpRkxObGVjdlNybUFESmExTk4xM1ZPdTRhKzFqNTFC?=
 =?utf-8?B?dGpMQnpTb1FJUEVEdzZ6S09vUmhtZzdOMk5kMXV0K0szWWRTbUNNME8vcDRo?=
 =?utf-8?B?VmJyb3RWbkx3ZGViMVB2VU5CckFuSXJkK2tITDVSNWpyQ3dDajRFb2VjTHoy?=
 =?utf-8?B?cmlEd2lMMFF0Qlc2dGFqOXFqS040djFLdnpYbHJMeXV1R2VoRUtSenR6TG5j?=
 =?utf-8?B?bktGYkZaVXVqSmNGeThhSm42dGpKMHB1UmRCcWEzQ1hOY01lOU00YkVLRGNo?=
 =?utf-8?B?TCtyTmZnWncvT2svd0pRbmpicW5lYlBMd2ZvNUJDdWE0Q1Yva0Y4cnE5UU41?=
 =?utf-8?B?djR4Qnozb1RmVDlVTWppRjNselpnVzNzYUlKdmVuTE5GYkVCd1NBRHd6R0hF?=
 =?utf-8?B?bCtzUEVUdWhVY0xyYlptNGJFME9tQ2tCTjdoWjFmcG0yaTF2V3FNVjNnOHNX?=
 =?utf-8?B?UG1RNW8xV0p0MlhoSC9iL3N4Yy80RnhjQnFoZXpUaGVabVhvUWx3MXA1NDB6?=
 =?utf-8?B?MkNXZENEdm1Pd3gwWUhydWQraGprRTFodzZONVNSOHUvSmhmVXRmaStMbFp2?=
 =?utf-8?B?c2dsOGZJTkxxb3ZFY0dHTUt2U0U1SWRrSzQ5MXp0V1RoY2JXUG1wUE5nMVgy?=
 =?utf-8?B?UUZYS1k2SThBeEMzNjhDdWRsUjMvRzV6MFk4UmprbUtwWG9jUDNUY2JCYUVi?=
 =?utf-8?Q?pnpSGSM2I96aPYf3shi6UnMwwKPdbclbNv5WrrM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 959824d6-5b18-4a87-4af2-08d951a654cc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:01:47.9328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYcFCoE9FNgnx39yqud+ciq+3e/Z0U4YEi8Uy6wyuzmijQe9jqblLEKGyi2BTpKP3vXVtrbK7Th8z5Z9U/3eQBMryKXben13mzeL/y9OKz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2792
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280051
X-Proofpoint-GUID: dLAZunDUcdsV2uIbcn-8kxOaIQGPorx0
X-Proofpoint-ORIG-GUID: dLAZunDUcdsV2uIbcn-8kxOaIQGPorx0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/27/21 5:24 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> From: "Darrick J. Wong" <djwong@kernel.org>
>>
>> Log incompat feature flags in the superblock exist for one purpose: to
>> protect the contents of a dirty log from replay on a kernel that isn't
>> prepared to handle those dirty contents.  This means that they can be
>> cleared if (a) we know the log is clean and (b) we know that there
>> aren't any other threads in the system that might be setting or relying
>> upon a log incompat flag.
>>
>> Therefore, clear the log incompat flags when we've finished recovering
>> the log, when we're unmounting cleanly, remounting read-only, or
>> freezing; and provide a function so that subsequent patches can start
>> using this.
> 
> The changes look good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Alrighty, thanks!

Allison

> 
>>
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
>>
>> ---
>>   fs/xfs/libxfs/xfs_format.h |  15 +++++++
>>   fs/xfs/xfs_log.c           |  14 ++++++
>>   fs/xfs/xfs_log_recover.c   |  16 +++++++
>>   fs/xfs/xfs_mount.c         | 110 +++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_mount.h         |   2 +
>>   5 files changed, 157 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 76e2461..3a4da111 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -495,6 +495,21 @@ xfs_sb_has_incompat_log_feature(
>>   	return (sbp->sb_features_log_incompat & feature) != 0;
>>   }
>>   
>> +static inline void
>> +xfs_sb_remove_incompat_log_features(
>> +	struct xfs_sb	*sbp)
>> +{
>> +	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
>> +}
>> +
>> +static inline void
>> +xfs_sb_add_incompat_log_features(
>> +	struct xfs_sb	*sbp,
>> +	unsigned int	features)
>> +{
>> +	sbp->sb_features_log_incompat |= features;
>> +}
>> +
>>   /*
>>    * V5 superblock specific feature checks
>>    */
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 36fa265..9254405 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -947,6 +947,20 @@ int
>>   xfs_log_quiesce(
>>   	struct xfs_mount	*mp)
>>   {
>> +	/*
>> +	 * Clear log incompat features since we're quiescing the log.  Report
>> +	 * failures, though it's not fatal to have a higher log feature
>> +	 * protection level than the log contents actually require.
>> +	 */
>> +	if (xfs_clear_incompat_log_features(mp)) {
>> +		int error;
>> +
>> +		error = xfs_sync_sb(mp, false);
>> +		if (error)
>> +			xfs_warn(mp,
>> +	"Failed to clear log incompat features on quiesce");
>> +	}
>> +
>>   	cancel_delayed_work_sync(&mp->m_log->l_work);
>>   	xfs_log_force(mp, XFS_LOG_SYNC);
>>   
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 1721fce..ec4ccae 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -3464,6 +3464,22 @@ xlog_recover_finish(
>>   		 */
>>   		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
>>   
>> +		/*
>> +		 * Now that we've recovered the log and all the intents, we can
>> +		 * clear the log incompat feature bits in the superblock
>> +		 * because there's no longer anything to protect.  We rely on
>> +		 * the AIL push to write out the updated superblock after
>> +		 * everything else.
>> +		 */
>> +		if (xfs_clear_incompat_log_features(log->l_mp)) {
>> +			error = xfs_sync_sb(log->l_mp, false);
>> +			if (error < 0) {
>> +				xfs_alert(log->l_mp,
>> +	"Failed to clear log incompat features on recovery");
>> +				return error;
>> +			}
>> +		}
>> +
>>   		xlog_recover_process_iunlinks(log);
>>   
>>   		xlog_recover_check_summary(log);
>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>> index d075549..d2c40ae 100644
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -1217,6 +1217,116 @@ xfs_force_summary_recalc(
>>   }
>>   
>>   /*
>> + * Enable a log incompat feature flag in the primary superblock.  The caller
>> + * cannot have any other transactions in progress.
>> + */
>> +int
>> +xfs_add_incompat_log_feature(
>> +	struct xfs_mount	*mp,
>> +	uint32_t		feature)
>> +{
>> +	struct xfs_dsb		*dsb;
>> +	int			error;
>> +
>> +	ASSERT(hweight32(feature) == 1);
>> +	ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
>> +
>> +	/*
>> +	 * Force the log to disk and kick the background AIL thread to reduce
>> +	 * the chances that the bwrite will stall waiting for the AIL to unpin
>> +	 * the primary superblock buffer.  This isn't a data integrity
>> +	 * operation, so we don't need a synchronous push.
>> +	 */
>> +	error = xfs_log_force(mp, XFS_LOG_SYNC);
>> +	if (error)
>> +		return error;
>> +	xfs_ail_push_all(mp->m_ail);
>> +
>> +	/*
>> +	 * Lock the primary superblock buffer to serialize all callers that
>> +	 * are trying to set feature bits.
>> +	 */
>> +	xfs_buf_lock(mp->m_sb_bp);
>> +	xfs_buf_hold(mp->m_sb_bp);
>> +
>> +	if (XFS_FORCED_SHUTDOWN(mp)) {
>> +		error = -EIO;
>> +		goto rele;
>> +	}
>> +
>> +	if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
>> +		goto rele;
>> +
>> +	/*
>> +	 * Write the primary superblock to disk immediately, because we need
>> +	 * the log_incompat bit to be set in the primary super now to protect
>> +	 * the log items that we're going to commit later.
>> +	 */
>> +	dsb = mp->m_sb_bp->b_addr;
>> +	xfs_sb_to_disk(dsb, &mp->m_sb);
>> +	dsb->sb_features_log_incompat |= cpu_to_be32(feature);
>> +	error = xfs_bwrite(mp->m_sb_bp);
>> +	if (error)
>> +		goto shutdown;
>> +
>> +	/*
>> +	 * Add the feature bits to the incore superblock before we unlock the
>> +	 * buffer.
>> +	 */
>> +	xfs_sb_add_incompat_log_features(&mp->m_sb, feature);
>> +	xfs_buf_relse(mp->m_sb_bp);
>> +
>> +	/* Log the superblock to disk. */
>> +	return xfs_sync_sb(mp, false);
>> +shutdown:
>> +	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
>> +rele:
>> +	xfs_buf_relse(mp->m_sb_bp);
>> +	return error;
>> +}
>> +
>> +/*
>> + * Clear all the log incompat flags from the superblock.
>> + *
>> + * The caller cannot be in a transaction, must ensure that the log does not
>> + * contain any log items protected by any log incompat bit, and must ensure
>> + * that there are no other threads that depend on the state of the log incompat
>> + * feature flags in the primary super.
>> + *
>> + * Returns true if the superblock is dirty.
>> + */
>> +bool
>> +xfs_clear_incompat_log_features(
>> +	struct xfs_mount	*mp)
>> +{
>> +	bool			ret = false;
>> +
>> +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
>> +	    !xfs_sb_has_incompat_log_feature(&mp->m_sb,
>> +				XFS_SB_FEAT_INCOMPAT_LOG_ALL) ||
>> +	    XFS_FORCED_SHUTDOWN(mp))
>> +		return false;
>> +
>> +	/*
>> +	 * Update the incore superblock.  We synchronize on the primary super
>> +	 * buffer lock to be consistent with the add function, though at least
>> +	 * in theory this shouldn't be necessary.
>> +	 */
>> +	xfs_buf_lock(mp->m_sb_bp);
>> +	xfs_buf_hold(mp->m_sb_bp);
>> +
>> +	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
>> +				XFS_SB_FEAT_INCOMPAT_LOG_ALL)) {
>> +		xfs_info(mp, "Clearing log incompat feature flags.");
>> +		xfs_sb_remove_incompat_log_features(&mp->m_sb);
>> +		ret = true;
>> +	}
>> +
>> +	xfs_buf_relse(mp->m_sb_bp);
>> +	return ret;
>> +}
>> +
>> +/*
>>    * Update the in-core delayed block counter.
>>    *
>>    * We prefer to update the counter without having to take a spinlock for every
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index c78b63f..66a47f5 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -325,6 +325,8 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
>>   struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
>>   		int error_class, int error);
>>   void xfs_force_summary_recalc(struct xfs_mount *mp);
>> +int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
>> +bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
>>   void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
>>   
>>   #endif	/* __XFS_MOUNT_H__ */
> 
> 
