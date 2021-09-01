Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F97C4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 05:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49AD560F90
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 05:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhIAFfK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 01:35:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4806 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233857AbhIAFfK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 01:35:10 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VNawQG032756;
        Wed, 1 Sep 2021 05:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+2O2psQhtKbvX6LIrZ1Aagnv9WmOu3MtxvrmGVvhQEI=;
 b=huqY5ed94ygPCvjlIFa3hAj5MEHT5nvzFNAg6vvuLBkeEXfBsrvMvN+ckZsqYxLgwMce
 z8bUB53cI3wujgAIrwly3fPwDWqV/fM4oQ0HZIkC41+v7vMk8bmsUhx/fIvjjIVHGf3w
 FBjjsOIFjMQXqv7r3tZxVPFrKI30shKEJOs2C+vhYixUe3+JS2qESshcSKn1sjK8G1Bf
 v7sgcASY1V5M4WN9tiiZelcpMyZZZlZd4hO/NlHMkeFrJxalsLGAsbU/d/3HTBDDv/zU
 s28aEkg9+Vrp/GoSaG2kyP40tus2QIm7fkOg48ma+tmeTkQYwStbq4VZ6y/QR/E4yW2z pw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+2O2psQhtKbvX6LIrZ1Aagnv9WmOu3MtxvrmGVvhQEI=;
 b=shuP0Qpsdoe9YfJNaqP063eraFN/sZUFiY/P+B/cLuasfETPZaUiEpxjuv4MeTQv0HaL
 501UK09e1OrbtllKeKtbtXuki/yjTTNIopOfBNTOvsPWV3S+yZGxx8mpp0quswMzjUBQ
 hBPMJLYUl5ujVy1xl1JZI8FMuNXZyRvaJG/CdwgnS2wOVCqR0oZulLVGF4zPD1V3+U9o
 vxFBQRPJRFVCqSWqB2YltB1W730d5jTfjumN6LpGuWFmlU5AE7QQBUPCc7XSyhJMg21g
 uU4twhw2x+lt2P4fRtoIdxyn90C8iLaMoVLOlhxlrjIOELK+3u3QYpobozpbA2NWCOs/ wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aseedkbme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 05:34:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1815PeFH177527;
        Wed, 1 Sep 2021 05:34:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 3aqcy61kma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 05:34:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/gC/jptynbH4pEufuRCSWYz5w5VbOztxNO/qN/w0BBrMvYE0vL2unn/ovHKXMJOqbgDMjIr9uX5Hzu9v2gVmj5uTGAbUWjeHLlgu6r/ffnTGa54bYZAdCapuo5h13qoVlTa6Z7PzgpcpKHkWhB4PuGcv9hyIoPRhn014jmREvO//+jVePHOxqi84LPkoN6iGU2cVAx27D3GMo15ASrOpq5JVlmQDeV01gf1zkeuMLO31Mjm2m/FC+PENqMCMaaNEvFb9wfOvVqGsNkxl5O8k/pphPoDJUayiUGd8Aa3PJQzZryeMXoOk5uNvMx39k/0CNKpsPLWdEMuJvcJrUn4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2O2psQhtKbvX6LIrZ1Aagnv9WmOu3MtxvrmGVvhQEI=;
 b=Ow9DH5R622Kr+Ejt27KjUnDbOZ0yTVhtCbYpntwIk8p258RVJ11woFSyPkcjk5Wzk8Ye+om3L14A5PCoRRQ9AzU/0gF/7TZFs0TiIIkT30ORgdZOhyp+Q/3G7PA/aVnKDOoPNegY4QIB7jPryb2XdIAmVhl/QXhUmrMlEf1tnhz/EtvcPU1HlAU1PjvUX4A6rkh8AyVo57qYJskblfiG0jSI5uniPhWtrpzFxwwnN7j708un/CSwiptGioOiY5S0mll1oLavY38L7THglG/IIsI9EIT2MOXKib4jlomSKHr4GaHy4IndNGQAbtlytTi5EBeBY0nK8xmhGkvzFE6BNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2O2psQhtKbvX6LIrZ1Aagnv9WmOu3MtxvrmGVvhQEI=;
 b=iH/kANKk8Evb+GKYYUIJUckgfumCSgYip+3XPJduGlHNdmQkXAUEazddOvviHF8EifpilIco4ZPQf81myEEVsAVjys3QxOGW2cJKXtSiODPiporKPO3L4DOT2kMSFqvqeDdR3mtTicHL6vduudGaYoAnXJ+qe0s/hHsROV0KCkU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3109.namprd10.prod.outlook.com (2603:10b6:a03:14d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Wed, 1 Sep
 2021 05:34:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Wed, 1 Sep 2021
 05:34:06 +0000
Subject: Re: [PATCH v24 03/11] xfs: Set up infrastructure for log atrribute
 replay
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-4-allison.henderson@oracle.com>
 <20210831215234.GU3657114@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a16d362d-9353-e3dd-b05d-89483faca8b4@oracle.com>
Date:   Tue, 31 Aug 2021 22:34:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210831215234.GU3657114@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0230.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR03CA0230.namprd03.prod.outlook.com (2603:10b6:a03:39f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.21 via Frontend Transport; Wed, 1 Sep 2021 05:34:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a2ab2a3-1a36-49ec-98c6-08d96d0a1d9e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3109:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3109A07417DD7C0817D89E8095CD9@BYAPR10MB3109.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZmO3cMFCwWKZ/Y4vg3Cg6jIDBq1z//qpChD7jwy7U2j/mt+XQLVV/tYeddUYaWAFIc48QVUlg6ai9PRqbdw4RQakrSlgLu8LDgCjGet5sKk17PRjcLNKvQILZkG1dL4qnlH9FBOwQBjwDvHgtwkxn0NtUi56p/EdG+Yz7jkv80V4knGt4BtuQkcGAAQUURCv9LaDs2nm8YjxcIpdEJY1mP0KAToOs2+FSzON3FWPQqb5A3BHqyZVeHxU7V/av71CeEbe2SFU7GGZCz2N94ievA3HfIYkgICLwh5cDPYX6mjYTHIj1lIxeyymPeUpz431bO+kWVBYshhMs9lRD8szF73uMHIUcceBzmRlzumhulKVcvn8Xx2HkUKILEqob7xj4fgHQTlqCQ4dNx/VySfwIn1np2GMClapOhAvJFDIXeER8Ect7cf/IJWWp+kUsW6BT1xfcRYYLXs9f1tX48FHXUCb737CPa73pa4IUFyHWWlotzaZlIG1ZBvqplMlW4Aqzbetl3YVQMWSgIOSlUrpzkUmUUuz6pfIIR3OvN7Q2IGGF4U7Xx9fEmTSeQpWKJSp5RV4r5IIn/nBwQOX3ZLLgm/cyR787ejV0LTMohR+vRWCnOGvsO2moNRIhkkUnm3JjrplczyloElFMsWR+N1/QJWMR3ZfVO+nmaoUoexatXi0rtQp8CX7tN7a8wdHl3jzq5nkbelScnfgxALLU+a+ZhbFSAwznbfZm8ZAoozZbvK787DNzQQjTrR9NTLBi2YozYmoplgSKVfVnAgJr9GKyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(86362001)(36756003)(31696002)(16576012)(316002)(186003)(31686004)(53546011)(6916009)(26005)(38350700002)(4326008)(44832011)(2616005)(2906002)(66476007)(956004)(5660300002)(8676002)(8936002)(38100700002)(66946007)(66556008)(52116002)(6486002)(478600001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnM3U0k5YXhRTVlUQldXMVg2Qy9ZZVV3N3RNN09lTWl5TGw3N2wyNzB2U05P?=
 =?utf-8?B?dUhNL3d3UkkwcjNNczljeVAxbW1QUWdKcmFyazJDRE1YU3duYmtSSVV2QzFZ?=
 =?utf-8?B?eTJZTGNBQnczTEF0VDB4bUtwYVRERnhBOTVpbEY5amVBQy9IekwveURHd0NN?=
 =?utf-8?B?ZVBYZExyQ2F4ZVJrZzFsZGlIMzJHRFlYTmdVNnZtK24yWEdzMlh1Z1YrRlhF?=
 =?utf-8?B?WXZLVENqcmV2alRCbTNrbHdzaEJScjMrZER2UUdJcG51UHNDbnFFNVFnYUVZ?=
 =?utf-8?B?OVFUK2d5OVFXVVprQlRmVGJLYXh0ZnNpcmEzYVV5U0VTcENULytJVzlibS9i?=
 =?utf-8?B?bC9neTRZdk9tZXlub3RjVkg2U1ZHNTZWK2VHRWhQWWpudlE4bzBxbHIvYWFR?=
 =?utf-8?B?aHpBYVNkU1ZvZkxLdHkxbFEwWjU4aHRwdEUvdFBXVitkN1dQYVZQNHdWU2xD?=
 =?utf-8?B?SHdUL3VCUk5jM0Q1N0ZpTTlyckQwNTA0QnRhZ0Fra2NFSWE4ZHpRK0xrZTBZ?=
 =?utf-8?B?QXltYUt1L05HL1B5K3Q3ckNuN29LNUowVHdScjY4QXp3MzZaOXVLRVRUN2VY?=
 =?utf-8?B?WHdxN3B2SDJCQmsxa0Q0THdBZEdsaTRpZmlVTEpFU1lNc2RnVHJCOW5zeENk?=
 =?utf-8?B?TDUrUmVuUUtUelJtWmRkY0VnUUZGRDIyL3hBOXU2V3Y3VmF5a3NRQXhjNkRt?=
 =?utf-8?B?a3hxakhFVlZtdkN6NUYvakt6WWRBNllyWDZpeXViY2NDL056c1NwNWZUL2pt?=
 =?utf-8?B?UlZhSGtrTjJKVy9SZ0E2YkFBYk5uWk15TDFCU1BHYmx6UjJBN3hSVEVzMFpm?=
 =?utf-8?B?MTBhZ08rc1htK2RYV0FUQkpNMXNPeitUeVpTKy8yNUNiclA5TUdXUEszbTdK?=
 =?utf-8?B?djR2MXVUcVV1dXA2a3hFRTllZTlaNUZqL2F4cHVLMTczdHNWVkN6QStVdTdq?=
 =?utf-8?B?R0hzNTcvWFZCOTRHS3F6UW5udkM3Ykc1OFRBY0JlM0p6cTk5VkErT29ndy9F?=
 =?utf-8?B?SjBmWW9LR1lCM0ptQzIvbklScGQ3YkpoTjdFYS82d2tyOUxIQ1ZCa2xoOWcz?=
 =?utf-8?B?T2h0N1BJazN4K0x3aWJtbTlXMEhnQTMveTUzVnBqVlVseEpxMVJqbGw2ZWYz?=
 =?utf-8?B?b3Rrc0Nnc0JrdWJzeUxSdlBSeUg0U1NjYWhnZGM4K3hVSThVeEY1SmJxaU1t?=
 =?utf-8?B?YXo2UFEwR1NpQzVrSzRxQVh4TzZsampFMVRwZGUzVWhQNjRwVzRZQXJjUTNL?=
 =?utf-8?B?eVJveFF3ZFpqMXdiT3lyWVcyWDQ5WkhvZkUydXhMM2VoM0Q1a2RYK3pSWG9N?=
 =?utf-8?B?Y3Ixc0RLMlQwRHBnVkcvczNzYk41Z25TcGViR01rVXRabFBCcGpZWEJzZ05H?=
 =?utf-8?B?K0pQc2hJRGFzd0UwT3RBR2ZLSU5nekhqbFBIdDZyUVJYTjRpa2F1V3JScTZu?=
 =?utf-8?B?WGpTQ1JVT1NtOU0rTzN6SkxuQU0vSHd6NjhpMCtjZlQxU1dWa1VCQ09KT2RP?=
 =?utf-8?B?WU1sa3JCN0NZaExuNUN4dWtLeWxZZnM5V25nTjNYZEN4RE5xRXJwOUpjL0tD?=
 =?utf-8?B?T3BHbm10QVI4dDVIYkUzSzZpdnQvcER1MFlWR2g4czVHa3JqRW5SYmFVa2p3?=
 =?utf-8?B?QzVMbitaTkR5eS80emZ3UE5wVmNhcFhzT1ZMU0gzSDlTbUR2MDJ0cGFCSmlh?=
 =?utf-8?B?UjRqbnJQZ2J0SWlmNXhGRFpHNnptN3RrdlZzNDV1OUFLT1lJbCtsYzVVanFr?=
 =?utf-8?Q?LYaUXIZvlnomCxBm8mOfzNWd2cRcuTEbHMCt7mr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a2ab2a3-1a36-49ec-98c6-08d96d0a1d9e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 05:34:06.5003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ATF+2rQoRwL6l6wGl6FnvVfP5E8A2aRdMZ0cSHY6T/kW1uiDuXWhtXZPD5cKkL1sq98xo3gEQLDNQFmffi9ylMilkjUHck3GfhoA06RnQ30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3109
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010029
X-Proofpoint-ORIG-GUID: 7k-zRxo6zQVLyuiSzCU8FjnUbMhFXvYP
X-Proofpoint-GUID: 7k-zRxo6zQVLyuiSzCU8FjnUbMhFXvYP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/31/21 2:52 PM, Dave Chinner wrote:
> On Tue, Aug 24, 2021 at 03:44:26PM -0700, Allison Henderson wrote:
>> Currently attributes are modified directly across one or more
>> transactions. But they are not logged or replayed in the event of an
>> error. The goal of log attr replay is to enable logging and replaying
>> of attribute operations using the existing delayed operations
>> infrastructure.  This will later enable the attributes to become part of
>> larger multi part operations that also must first be recorded to the
>> log.  This is mostly of interest in the scheme of parent pointers which
>> would need to maintain an attribute containing parent inode information
>> any time an inode is moved, created, or removed.  Parent pointers would
>> then be of interest to any feature that would need to quickly derive an
>> inode path from the mount point. Online scrub, nfs lookups and fs grow
>> or shrink operations are all features that could take advantage of this.
>>
>> This patch adds two new log item types for setting or removing
>> attributes as deferred operations.  The xfs_attri_log_item will log an
>> intent to set or remove an attribute.  The corresponding
>> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
>> freed once the transaction is done.  Both log items use a generic
>> xfs_attr_log_format structure that contains the attribute name, value,
>> flags, inode, and an op_flag that indicates if the operations is a set
>> or remove.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/Makefile                 |   1 +
>>   fs/xfs/libxfs/xfs_attr.c        |   5 +-
>>   fs/xfs/libxfs/xfs_attr.h        |  31 +++
>>   fs/xfs/libxfs/xfs_defer.h       |   2 +
>>   fs/xfs/libxfs/xfs_log_format.h  |  44 +++-
>>   fs/xfs/libxfs/xfs_log_recover.h |   2 +
>>   fs/xfs/scrub/common.c           |   2 +
>>   fs/xfs/xfs_attr_item.c          | 453 ++++++++++++++++++++++++++++++++
> 
> Comment on the overall structure of this file now I've been trying
> to navigate through it for a little while. It is structured like:
> 
> <some attri stuff>
> <some attrd stuff>
> static const struct xfs_item_ops xfs_attrd_item_ops = {...}
> <some more attri stuff>
> static const struct xfs_item_ops xfs_attri_item_ops = {...}
> <some attri log recovery stuff>
> <some attrd log recovery stuff>
> 
> IOWs, the attri and attrd functions are interleaved non-obvious
> ways and that makes it hard to navigate around when trying to find
> related information. It would make more sense to me to structure
> this as:
> 
> <attri stuff>
> <attri log recovery stuff>
> <some attrd stuff>
> <attrd log recovery stuff>
> static const struct xfs_item_ops xfs_attri_item_ops = {...}
> const struct xlog_recover_item_ops xlog_attri_item_ops = {...}
> static const struct xfs_item_ops xfs_attrd_item_ops = {...}
> const struct xlog_recover_item_ops xlog_attrd_item_ops = {...}
> 
> because then all the related functionality is grouped together. It
> also puts all the ops structures together in the one place, so we
> don't have to jump around all over the file when just looking at
> what ops the items run at different times...
> 
Sure, will make a note to re-arrange some of these in the next version

Allison

> Cheers,
> 
> Dave.
> 
