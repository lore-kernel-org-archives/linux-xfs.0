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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4115FC07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 19:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F441613CC
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 19:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhGIT73 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 15:59:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55958 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhGIT72 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 15:59:28 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169JqtRT010224;
        Fri, 9 Jul 2021 19:56:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=99iPs0TCc9AS07tGlETdkbZNkyKvMcxnWTn7RVVh0Ww=;
 b=PVs+yU08Y5qUwQfR0yF+EnJrtO2cpNiAbpMP+tgBxobj53GVh/ideTU7Q/BYyJYfLK8Z
 hGsemZj35A7PKNohOlpfzy9YVDvsqr8gVb5OSP8R/oFwOYT9TCJJs9eYfgwfZHWKIaHr
 QteGSgmKPV6OqPor39Wf0mC6Qfkujlj0uL0BS851ZFHNb8bsQZYswwQ4bSe2KuDqu/h3
 ADKuhrr2WsJK4s+KNjTwICxoo3zLrz3tzU8GAdK1JPJ1kXcKkiMrVjdpcPsgOge3Tu7m
 c0YnMEecZxHrl37J8CA2DC8pNgv0ugtZP/XUlvk/rzesEsUfr/dCLf4OQV8qqh/5Pt03 nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39pjkasd72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 19:56:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 169JugqO113321;
        Fri, 9 Jul 2021 19:56:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by aserp3030.oracle.com with ESMTP id 39nbg9y02k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 19:56:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeIQvcV5G2LdD9xUPNZCfvDflG1gmDl4RRz5wYTpa+Bzl5hYM0T7YN7q0cAr8Dcbd7XY6ffk8Ip8N6A/ho+K3TCUIkHeH/sv4QAvMMyVkFHDlwluyQDAX2rxI71CeAKCCgRuWydU901hKBkpZWpGe6OpqdfU28lfky3MYfMxfXoyhEshCvzvBOYGXKQ0wz1Ubv0oppV1MRY2xJKe4k8MRm6eKogqPeABLrzYST34SD9mo0M51m2cRnU5Xg5zFK6dQNxA7WtUjM/6rscVBskDaHlLSHSwInAiUBv6DSDcP1WHCS5HNO0t6T92RPFls/hTZt3S0Dm+eHubE/U793KYKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99iPs0TCc9AS07tGlETdkbZNkyKvMcxnWTn7RVVh0Ww=;
 b=mjMkCEelg2CUTiYCR4jJXN5m3cq4ECch8otzZapyXs7KvqU0ve2XLZMoVkM+Z/ds+IDGEGfku9KjMyqZv/2en2fWnumKyOB3Ymu2jkVgOeziMwQH56k7ROVRmOg5IWvRZhAIktyReYJ4fvc10Ue7ET76Sl6gRYMRZp6us8LSW9QNZFqGpG9h+MhUC3qzvO2EtSAL2+yN33Ev5qKZ0jQRADbTokKCSZzMYVt4MFpFBC137Ft64gDr9ckXPwJrgY5DMlRWrAU9yuWG/Vw8JdkWwMtlQdr/xf9R5Uo0nJI1MjznUn1MYM6qSheRFSPdyMK2Gx0Jeu0khIm9rbZA8RWt7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99iPs0TCc9AS07tGlETdkbZNkyKvMcxnWTn7RVVh0Ww=;
 b=k5gNzXJB1ccK2dt8BjHKfd7oxmakCihinwXU+fNblx5QvDLux4DRgOI/lZVxlOlxmAXH5+/JGOAP5mEt5G3rvb59Hu8mmeDKTZRuw2Jl9L7aKC2emGN5bfrKXS8FYGqyjIBWS+prGT2s/gwGCms97w8NyPBIksdP6zbe6+Ei0F8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5471.namprd10.prod.outlook.com (2603:10b6:a03:302::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 19:56:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 19:56:24 +0000
Subject: Re: [PATCH v21 01/13] xfs: Return from xfs_attr_set_iter if there are
 no more rmtblks to process
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-2-allison.henderson@oracle.com>
 <20210709040553.GL11588@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <0addac84-36cc-975b-8c42-167632f45c7d@oracle.com>
Date:   Fri, 9 Jul 2021 12:56:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210709040553.GL11588@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0194.namprd13.prod.outlook.com (2603:10b6:a03:2c3::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.10 via Frontend Transport; Fri, 9 Jul 2021 19:56:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b62a29c-5836-47da-8a3f-08d94313a148
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5471:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB54717FF133333A634A49299595189@SJ0PR10MB5471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSnENsCv5rS/NamcPOdqWlBmGG9EyBj5ZggJHqnNVuT7jNCkuumAEiUqb2wCCwtBMoHn87uPEFrx4HEPozYrz5zpk0uAUXQYhhnQ/Shxm9PjQmHCcPZG1rpwmk098QeSiZbFzR9AysMqdOAfcyFXv80JuZ+pOs4LtrRWMyO5VXjiBpr635cq5DOeDX5gtV6LszCAZZIr4fdFFn3pARJX2qEaahpqrtbrw0AWfKR8Vk915/plUOUIHeraqc0aEnQ5sqP2pz/s2k6ZM/KAvXCix0rAt3JJPM/NAjMd/TWHssEgzMhYMIwdVjPP8LDcOeCyT0D2H4Tuot1ax24vvOMIjg4KDiowCqWyoFTdknnQrzLA8VjXkA0gVp4H5+CPmW2BlQpk7j2+UiiafP2eyDVEtws3CuVx/1Fgzo5OEZzXeJLvYEM7xkdbcFu2vhlnbMdQSgbdyZqz9KyIzMEwhK/jKehbHQDmCTgBo6vE/tid7UDH5a0/fQevfmCwJsgvF2SoL7ocx3oFsTeyDEfGvie4ED3IfNUoYNFL0Eo6CHdKBksxEWy0VFw1M0QaWGppBTW4c3SayEkvVwPlpS60i5cNFsNd42VoczywGPhoTtSFOHZVvTnVfdYMfi6wPKJDO6yjY9HpEQiKnApJ06scF72F3bIDKsUqJPC1tiOVFnvLLrYZiscuzr1YePmfA6YALt5OkefgwgRS9K8wuvSstyAnbaz+T9PWMxB9rekwvJnzbFC9TTto+9nvXoGKr0CDCw4hx1Duw8x+ded2joG5nr3yncJ+g6DoaGJS02wsSxeCFYGiZvZoavQf5cA9nwKWalSNhNAgUpV2riJp+4cO9dfs7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(346002)(39850400004)(366004)(66946007)(66476007)(66556008)(31686004)(2906002)(86362001)(16576012)(186003)(6916009)(316002)(36756003)(52116002)(956004)(83380400001)(2616005)(53546011)(26005)(31696002)(38350700002)(8936002)(4326008)(478600001)(5660300002)(8676002)(6486002)(38100700002)(44832011)(29513003)(40753002)(133343001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emd4NkRxMWNUQlhScWlYKzVubEVKOTF5WnFXU2M2MEcxMEthWm1wNGdhamFq?=
 =?utf-8?B?QVBUYjdnMUM4ZHVkQU9qaDZkREl1ZHdtUFBKNnRPcTFLZFZ5Z3h6L1JaVVJX?=
 =?utf-8?B?NlhDNnZLY2hBSDgxVGNVUmc0a0c3UlRQaUFqb2JmUnJ0SjFEZGwvY3M2RStK?=
 =?utf-8?B?RHcxcld1bXRmdVh3YlJEQnJQdGJTNEptYWhBamZmbFI4N3N0VW1iamdLUWFG?=
 =?utf-8?B?aWZmOS91QW11WUNzR1plS1dtdFpaUmxDS0p6TDV6aVVmdnZTbU01dlZjY0Nz?=
 =?utf-8?B?SjJzcUpMdDRUd0YrZW5ocHI0NXNQMm5QdmdrcWsrUXlTYmVrRElreUJ4Tndn?=
 =?utf-8?B?YzBWaFYrbHhqY1Q1bCsxSGVRQnlYMGl0bTh1ZXlUU082L0ZFT1h6N3F3dGt6?=
 =?utf-8?B?MklNS21FWTZlSHhuQnFuRDRDR3pJZ1NlRC9JdHZOSWZsc2trRTJmV0JIYjNK?=
 =?utf-8?B?ZTdBNDJyQmEyWFNrVXQrM1JlOEJtZWloN0F0ekdwUGxCdndEK1NzSTJWWTJk?=
 =?utf-8?B?bk9kMDJjVE9Ga2FDM1lETFprTzRZd05HbDlHZlJMTDRrRGZTMXhVcWkrM3ds?=
 =?utf-8?B?S0lBNGNNT2JpazhPOFQvamhXa25PYllOc0Fwa245b3FPejZ0Q3dRdnU1THFQ?=
 =?utf-8?B?RlR1QzI2UzZMeVIrL0JlY284K2YyVlEwa0RXZTlsV2Vrd3NNb0FjdEZlV1Fq?=
 =?utf-8?B?NHh0MTZGSEVBdStQZ2d3K2tpaFdEZUc0WUR4TEk0NUNqRkpSOUs0RFplajJK?=
 =?utf-8?B?VTVISHo1Y1hUVHVXSlU1aXh1VmhDdHkzWFJIVG1nQmFObkxncnJ1OVl0Y1Nu?=
 =?utf-8?B?dWVLVlNtenRTTEVsVnNMRW9PdUMzeEFqQkxMTk02UUs4NUQ1bWRPbU1rVE1a?=
 =?utf-8?B?QlpNV3dNYUhyV0FGd1dtK0JPdFlhcW9kWkhwbk9IQ3JiWjZpTHk2Q09JUUxL?=
 =?utf-8?B?TC96bzhXMGJBNEt4NUNkQ1lxbU9PNEhCVXVHZTdrK3BTSzJyOG9vTVBWM3Ft?=
 =?utf-8?B?VHlxcGEvamtnTlVHYlZyUTMrN2JkUHpOWnFxSHpjb2oyR2R0bjYwMXg0SGtt?=
 =?utf-8?B?YTF0Mit4TDliVmpoZDNvYjZORW45bXdwcHMrUElRekgrZ3c0MVBmaFAvckkx?=
 =?utf-8?B?MVBiMDJrRGRLelZqbVFGNUl1aDJQRm1Vb2JDaHA4djAyOTF0QThjZE44VkRJ?=
 =?utf-8?B?cmZBV1VKMFJ0L0k4MlE0OFdhZWRRU3VrOWgxa3dFU05BNEljNzJ1eXBsT3FE?=
 =?utf-8?B?ODl2aU9VN0MrV1U5bmNpakQ2TGpJYjJ1WmpENWtEV09zcUxKcGRFTDVOWlJy?=
 =?utf-8?B?VWhBUXRSUzVMOXh3RnlkVXZDQzhRYmdDTkxBbFhiRFllTVFnWWdYZkl5cEwx?=
 =?utf-8?B?TGt3ckRSOUV2MmFoYlRvaHV5bUxuZjRsUFBFaGppVVhPU2ZJWVNKM1ZWMTFB?=
 =?utf-8?B?T1U5blNjd0xrbnB6bmhmOHlZWlRuSEhib2FLd0swQi9maDBhallPa3RmTU1i?=
 =?utf-8?B?UlRaejFiRmdOdmdndGFXRDc4blZZdnNFczBYc2hnSHVoVVBISVNmUy9TU3JS?=
 =?utf-8?B?TW9CSWtvN1ZURDlldi9nc2lRYU04YUdHdTYyYm15K0VXeWZVM3lVdlFmOTNZ?=
 =?utf-8?B?Ulk0YTdjOGpvZWtCdFYxR2FEeGxVRlJKbi93OFRiTVJvUDZpRzI1d1dQdi9q?=
 =?utf-8?B?YUV1eWp4a3o3ZmllR09iQjI3NWYwQ1o0Yms4S3ZXMnF1UVFrMDljaEtkbUtD?=
 =?utf-8?Q?gp4NYZQqsOqs2AjAnNxcN2EfNQk8/K4IHgW8MP6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b62a29c-5836-47da-8a3f-08d94313a148
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 19:56:24.0155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4AQCwTYyMX5jQdW2IFzFivNppvOdrJF3IlxEMGcfYM1eRzETfnDlriI45h9OQ+0pr5xMqcHzyqbfIJHdRa/fW/viDtSy1k9EsMW1M+jsb6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5471
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107090098
X-Proofpoint-GUID: s5h6ylcewCvPL1XxWmfCRJXEHJWULKh-
X-Proofpoint-ORIG-GUID: s5h6ylcewCvPL1XxWmfCRJXEHJWULKh-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/8/21 9:05 PM, Darrick J. Wong wrote:
> On Wed, Jul 07, 2021 at 03:20:59PM -0700, Allison Henderson wrote:
>> During an attr rename operation, blocks are saved for later removal
>> as rmtblkno2. The rmtblkno is used in the case of needing to alloc
>> more blocks if not enough were available.  However, in the case
>> that neither rmtblkno or rmtblkno2 are set, we can return as soon
>> as xfs_attr_node_addname completes, rather than rolling the transaction
>> with an -EAGAIN return.  This extra loop does not hurt anything right
>> now, but it will be a problem later when we get into log items because
>> we end up with an empty log transaction.  So, add a simple check to
>> cut out the unneeded iteration.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 611dc67..5e81389 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -409,6 +409,13 @@ xfs_attr_set_iter(
>>   			if (error)
>>   				return error;
>>   
>> +			/*
>> +			 * If addname was successful, and we dont need to alloc
>> +			 * or remove anymore blks, we're done.
>> +			 */
>> +			if (!args->rmtblkno && !args->rmtblkno2)
>> +				return error;
> 
> Is there actually an error to return here, or could this be a 'return 0;' ?
> 
> --D
Error is zero here, I just try to make the code consistent looking.  It 
can be a hard zero if folk prefer.

Allison

> 
>> +
>>   			dac->dela_state = XFS_DAS_FOUND_NBLK;
>>   		}
>>   		return -EAGAIN;
>> -- 
>> 2.7.4
>>
