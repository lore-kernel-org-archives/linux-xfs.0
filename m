Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB0BC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Dec 2021 07:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242309AbhLAHhx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 02:37:53 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:65256 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235915AbhLAHhx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Dec 2021 02:37:53 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B172xNu007291;
        Wed, 1 Dec 2021 07:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9jjTrKc2FqanrbL11c/sWFdHr71Vj23c90eKV7jEUYg=;
 b=P0KZGAcaLs20GlgOptYtk075BpyjFUiTZ4NPLn5oBrh8noejEB5BeNzWOjs+R+wvF5FR
 hZfU6i9ASca15mAfq4olkg32dYwLxzhUQm5wEElIpyFaLqb0MXXAF7zEYnvIdT1TIYPN
 s8YJmAv1vEgv77I42h3+cMinvdKkehGvEyd4lTBuNRv6xdkvpw2tzCJ55PZ18aEEuJEI
 N7UlersAeA+6jxARM2gjV58dLo+Pykn017UVpFaft1i3vBvKY7PMxQA6T17bayMosE6+
 qQyxVieuYwXAhuDYbnbfpXEPlBXvV9NoqqHe+/95tAuQRgZbI3ZDw3uslNjNrs7WLcm1 OA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmuc9y2v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 07:34:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B17Fj0b093151;
        Wed, 1 Dec 2021 07:34:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 3cnhve729u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 07:34:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/Tfd0mrktPEV9wRe81PN/GhKBEuSkG667yFuJ8zi8gYHUBaiSkAF9mjGe+nyEiy1VnfdUf8DXAU8rkKZkOv5+ktQ4gTzMP1jwOUkEPJejYweAkWXT2A0sBzvRgyDYhpJqhb/voNlqIj/OHJkhXYUrhy8CApLodGT8R+EmWofelHgOsW8xHberC+hUuR8z3p2nSgSJcNEhLruTPX3sdAYmCbATWrFsMcSGArRe6Y9TwCuq9KhpYKPUfSK659+5MeGsxbLS9ctPM1V7H+MMSWzVpIJ+HLdOuqsnozoPYiFq9S5FzaWeW5tS8TiqQYx6qzkBeBrTlVKV4ufCTgdkOB9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jjTrKc2FqanrbL11c/sWFdHr71Vj23c90eKV7jEUYg=;
 b=mVJcTE4Y1w80QK0NxUXgP0IcqiD1giDhstaQhUBI6K9VmiVLRD1JCWyY9WE9e2AQUDnG/gsawNDdA+a/zJB/z3zebp9SKkWc+r+7OCzHsBiRlBBJBlCe5oJQzQwyszEiBiFxTQv0Pz1+RlM97RtsjGhJgCenWsn0senvB8enqMdKGhoWiDMRh5SUfssz1EM2m72OpmLSiRBeqKtsmRcLd424uUyLr58bFAGNSQe1M1hGShYrPDZ3LTYm9CWQ/YCIj/LqWWQsiFUR0wqDuVOKdIy6Ja4xdJS+iB0vWsbQ7zUxXYxTchDoe3mEkPZImxK6lgPE+6Gvi8gi6RAzNq3bGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jjTrKc2FqanrbL11c/sWFdHr71Vj23c90eKV7jEUYg=;
 b=X5Rqhvjj6lBrtikHk6KjKZQjRBE9JWfQ4crh4QcdLTlSfCMaRqoHYNh9AduzomzMUMc3MVpokBnCMiRs0OwViC9QDv3pS8VDXBTDcbHBf4Un+q3/7NNXbLd2dLFH7uIMRB4jzWg89QFzcTy8VPoiMbvlKgVXGH1/Oz1fH8Y1Y8M=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2759.namprd10.prod.outlook.com (2603:10b6:a02:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Wed, 1 Dec
 2021 07:34:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.029; Wed, 1 Dec 2021
 07:34:24 +0000
Message-ID: <fe0fbf1f-96ab-172d-e017-e4100eea7356@oracle.com>
Date:   Wed, 1 Dec 2021 00:34:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v25 10/12] xfs: Add larp debug option
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
 <20211117041343.3050202-11-allison.henderson@oracle.com>
 <20211123232948.GY266024@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20211123232948.GY266024@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:a03:60::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.6] (67.1.131.99) by BYAPR07CA0046.namprd07.prod.outlook.com (2603:10b6:a03:60::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Wed, 1 Dec 2021 07:34:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0aa66f3-f566-41d7-cd50-08d9b49cff64
X-MS-TrafficTypeDiagnostic: BYAPR10MB2759:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27596A1534714AC5468DEEC395689@BYAPR10MB2759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T2QvFj21eq7TaLB9xLEYsyjOZ0NVPlTu/cryL/JVAVrdj1TjvdR595acnC0GgwqfBkmiOS1i2sKOYoU2hd6sCLy6YX+9BxxQ2zdxdJmzIGvE0zSViTUffKqmQ7YkFR2DOwMV7JUfHIYkLFPteNEi3wJKrhPMuCWOQx/H6ERXn+adVkzUC2p5R+udP3LYJAYtXvnzT4E1vDDa6nJnamPqCNhc/o+93YZV44QJZXP2xsZavJhIRiUfF30XmA2gIoz1Dk/g2rSgJPTpfcUueSAUM1adU087tCuxUaHMHl6JDif2vNMV3nEp+Tg95/ZIZL80TU7MAxGzBkkE0QoSz+OMJjoQZcuXeM/8xcrkFzoDaCDxJFzBIY3dzaE1OJHu1pAHwsxxJvv5ajRSdC1ou+jh0TpHYQlF/kKt8sFsiTm0ZrWcBJ3LFKfUszoQzwrRalCcxFErzNDQ+LZDQt6cUhBj0TWTIXb8yk6KloD1K+XB0TQNzZMD4tCNzRHk+GuTwiKk+l9L9HrqwA0cKcU51zcVLy9owlm7Yvr/ACfAyBjc/UK0cvA93l+7eCPSnbsQYO95SNos12zvHTv8hICqd1sjc91xfrtR2qxGIJVCzN8tvkb4McULGFzDkvUHUbayN+X6WojpRVYqbQOt31V6lMarzEzxigP7kSQOVq4F+tUp1fruTl/ZZaZmS2peybDAhXgk82g4lc7qaftqzt2TG/MjMu8nvYetwxBKmyCaFolBtNQ2XWEl8KjjRRLraDgLixSNGWujOt47MxgJTKGFlkrzjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(52116002)(8936002)(2906002)(26005)(44832011)(86362001)(36756003)(6486002)(66476007)(31686004)(53546011)(83380400001)(5660300002)(16576012)(8676002)(66556008)(316002)(956004)(2616005)(6916009)(31696002)(186003)(4326008)(508600001)(38100700002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1BMSno3cXdGRXhacDRndTFYNytWUVArL05rUkkyYW1tU3p1VTllUHJhWGhj?=
 =?utf-8?B?N0hWelhnUU5iT1VaZW5tTHNPYTkxY04wTEJvRE1HME5yWGQ5dmtQdTZKSitB?=
 =?utf-8?B?dXJxSkxvRlFoeENPU0V5SytsaE1ocllaaElHYTAyRU1kbU5GK3NmNmxmTmhM?=
 =?utf-8?B?Q1VvZ0owWjhmNmJTYTlIOTBDZEVIY2pTbmlTVzNDVVJ5SkRPcjRiM3RpMlVn?=
 =?utf-8?B?NWxScEFuWnNYNHp3YmQzQVp1Y0gyWXBUbXk2OUlYdXpsekl3N2lFZkhjQjhN?=
 =?utf-8?B?bnYrTktCWTh2dDV0Vnh0NnBhS01jVHRzell2Qmg3aS9QdWFReUtnbDhIckhI?=
 =?utf-8?B?STNBNUlnenhlV2MrUWsrbDNlSjJJeW9TNVY0emhwVFNyUTFDUHRYbmtQRGNQ?=
 =?utf-8?B?OGRxcXRlV1NRa1Q3aVU0QXNMOUthakRNYmsza3cxNUhhM1Brbnc2U3ZuMzR1?=
 =?utf-8?B?bTlNQ3FDMlc3RitHdllqYUxlNjlxSVFhRWtkU3Q5dVR5R1Jud2t3dmlVVmxk?=
 =?utf-8?B?TVU3ZXBqdzVNQnpVbzVFODhGeU1rZllJVGQ2S3lKL0JkUEZhYmdXU3Y3Mlht?=
 =?utf-8?B?MVpueDRDLy90Tllka2xLZmZXL0JNZTh4RTdtMG13WUMrSGtiS3FicTBLVkFs?=
 =?utf-8?B?a0RhVzZ3VzU1QnU4SEd3L09mcThUbjFBT0NNSWRWYVBxSnBDMTh2S1FOYkRM?=
 =?utf-8?B?ejVQdUd2TTJud09OblZrQ29vZHBmTVV1M3FlTkkvdllmMm82aFp6Z2J6UGFF?=
 =?utf-8?B?MldBbmJrR3hzbERKYlFzaG9ralRTNFNWdS9qVkJqWWdDMDYxUHdJUlVHbDkx?=
 =?utf-8?B?Wjd5V0gyR2c3ckxBUDN0TGNYZ1oycUtKTFNhNlN2VExWOWsxamRXUjgzWVox?=
 =?utf-8?B?dmc1SlhGZm9SQ3N0RmEzditzNFZDOWNhUnYzOS9RL2RYUUR4dkhVaCsySUtV?=
 =?utf-8?B?VXU0TU10Q2FXTVJpZ2t1OWZPYnpWY0czdkhocXV0eWdNdWllNUxpUm1mZjUr?=
 =?utf-8?B?TU9PMnB0ekdwaHVHYjM4dmRyNEk4WnI2VG9UVHZBWGhTOWtlV3daT3E5a0p5?=
 =?utf-8?B?dDFWYlhRUFdLOE02OVZMQjRXeEZqMmdPWVFrWW4wUXNZMWpQS2RjcmdIRTNw?=
 =?utf-8?B?ZWI5VTFRUHM3K3JQRG1VaTd4eHArK2JSTFJZMTFydGtBMjhyWHVqZ2JXb0xo?=
 =?utf-8?B?QWE3SGdHemVFTm5TaWIrS3prMzlMd3JQRC92TUc4dHNXUE5GbXkvWWxGU0FW?=
 =?utf-8?B?bW1tN1VVNWQzS1Boc3N3ajhoelpJdEQ3U1VmbGt0THE5enBrWDRRdC96cDFH?=
 =?utf-8?B?UGhKVjdGaXhyY09OTjJlUisxaW9lNDRiVFhNNWI4Yk1uR0hEUldpRFU2WFdW?=
 =?utf-8?B?ellmRXJIOEZydGlnVmtkUzV1UFdMaE1ta3hzTlRKWnJpYmNLMkpBM0JXUjhK?=
 =?utf-8?B?QUE5bmNkaWxTek85WnhlMEx5bDVJOXBJZ1k3QkJIMXNvTkdkRmJreExzRVB3?=
 =?utf-8?B?Q3pNWU1PZ0s0c3FXNGVIZ0d2L0V4eWczdzRsbndwQkhDWGlVb2p4a2U3SThG?=
 =?utf-8?B?WDN6djJqaW1nRThSdUFkbkxFNmRZczE3Nks1ZUhXN0JvM0lLdmd0a0EyTmJE?=
 =?utf-8?B?MC9NSXFqblM0RUxNQUFEaGpmcThDZ3owVHpTR1RUS0RlU1FNNjM0RENlaEU1?=
 =?utf-8?B?djFJSjI2QWdaOGlwa1cxcU9idzFFbG4yblFvYXNPUVNveUkwRXJGZUorTUJS?=
 =?utf-8?B?VzhyTmRzbXEyWGhycGE4N3NmT20zVmV6OWsyWkxPYUJkc0RaRnVQVnI2aTFL?=
 =?utf-8?B?TDZzWUR5Y3djVm1EeVpGNCtwc20yb1d2YXYzaWlpSytNUlFPZGROaFNIK3Bl?=
 =?utf-8?B?ajdhUGpLeXFFemJrZm93SmNJdEJYVWRuQlptakNrVUZWSlRWN3FsZ01OaXRC?=
 =?utf-8?B?VjdkR2VlaVFpZVlkYUx1N1RpU3I3OTFPbkIxOGxhZjlEOXlkakUwTUVLYys5?=
 =?utf-8?B?SnA0RDkvRFJsdVFBcFF4Y3JvQzZEcklDc2h2aitCUkVpOTBSRGxWSnBXRGVY?=
 =?utf-8?B?NnRPR1FFc1hIVUVrdU13VWNxMHQ5SERWSHRLcjJZMEtQZGt3N2JHKzJZNjZJ?=
 =?utf-8?B?OGU2dDZjMk5zMlB3TmE2MnI4UlVld0tDdTZqSmw5d0xjaDAzd21ZVW5rZ0w1?=
 =?utf-8?B?akdpeFJ2c2Q1cVNUZVRiVTVLeTlJdkU4Ni9mbXQ2dEp4cm5JQ3JNL1Q3Wnp4?=
 =?utf-8?B?SHB3MDBreG1VU3MwMGl4eEJaRjd3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0aa66f3-f566-41d7-cd50-08d9b49cff64
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 07:34:24.4002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rm05F+K2Q66DFkbNOXIYr+3ICotyy7y4BT0G329u8yXrJ9sPBaJ5FNE6rx0ew00OkdcF3kLjNc8QpeiQJgGyWH5fDi4bBp/JGFPb3JNoAgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2759
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10184 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112010042
X-Proofpoint-GUID: EKfnOhH0iROFKPn_Za91_1mOQ34RcdnD
X-Proofpoint-ORIG-GUID: EKfnOhH0iROFKPn_Za91_1mOQ34RcdnD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/23/21 4:29 PM, Darrick J. Wong wrote:
> On Tue, Nov 16, 2021 at 09:13:41PM -0700, Allison Henderson wrote:
>> This patch adds a debug option to enable log attribute replay. Eventually
>> this can be removed when delayed attrs becomes permanent.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
> LOL LARP
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Great, thank you!
Allison

> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.h |  4 ++++
>>   fs/xfs/xfs_globals.c     |  1 +
>>   fs/xfs/xfs_sysctl.h      |  1 +
>>   fs/xfs/xfs_sysfs.c       | 24 ++++++++++++++++++++++++
>>   4 files changed, 30 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 977434f343a1..6f5a150565c7 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -30,7 +30,11 @@ struct xfs_attr_list_context;
>>   
>>   static inline bool xfs_has_larp(struct xfs_mount *mp)
>>   {
>> +#ifdef DEBUG
>> +	return xfs_globals.larp;
>> +#else
>>   	return false;
>> +#endif
>>   }
>>   
>>   /*
>> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
>> index f62fa652c2fd..4d0a98f920ca 100644
>> --- a/fs/xfs/xfs_globals.c
>> +++ b/fs/xfs/xfs_globals.c
>> @@ -41,5 +41,6 @@ struct xfs_globals xfs_globals = {
>>   #endif
>>   #ifdef DEBUG
>>   	.pwork_threads		=	-1,	/* automatic thread detection */
>> +	.larp			=	false,	/* log attribute replay */
>>   #endif
>>   };
>> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
>> index 7692e76ead33..f78ad6b10ea5 100644
>> --- a/fs/xfs/xfs_sysctl.h
>> +++ b/fs/xfs/xfs_sysctl.h
>> @@ -83,6 +83,7 @@ extern xfs_param_t	xfs_params;
>>   struct xfs_globals {
>>   #ifdef DEBUG
>>   	int	pwork_threads;		/* parallel workqueue threads */
>> +	bool	larp;			/* log attribute replay */
>>   #endif
>>   	int	log_recovery_delay;	/* log recovery delay (secs) */
>>   	int	mount_delay;		/* mount setup delay (secs) */
>> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
>> index 8608f804388f..02a0b55e26b3 100644
>> --- a/fs/xfs/xfs_sysfs.c
>> +++ b/fs/xfs/xfs_sysfs.c
>> @@ -227,6 +227,29 @@ pwork_threads_show(
>>   	return sysfs_emit(buf, "%d\n", xfs_globals.pwork_threads);
>>   }
>>   XFS_SYSFS_ATTR_RW(pwork_threads);
>> +
>> +static ssize_t
>> +larp_store(
>> +	struct kobject	*kobject,
>> +	const char	*buf,
>> +	size_t		count)
>> +{
>> +	ssize_t		ret;
>> +
>> +	ret = kstrtobool(buf, &xfs_globals.larp);
>> +	if (ret < 0)
>> +		return ret;
>> +	return count;
>> +}
>> +
>> +STATIC ssize_t
>> +larp_show(
>> +	struct kobject	*kobject,
>> +	char		*buf)
>> +{
>> +	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);
>> +}
>> +XFS_SYSFS_ATTR_RW(larp);
>>   #endif /* DEBUG */
>>   
>>   static struct attribute *xfs_dbg_attrs[] = {
>> @@ -236,6 +259,7 @@ static struct attribute *xfs_dbg_attrs[] = {
>>   	ATTR_LIST(always_cow),
>>   #ifdef DEBUG
>>   	ATTR_LIST(pwork_threads),
>> +	ATTR_LIST(larp),
>>   #endif
>>   	NULL,
>>   };
>> -- 
>> 2.25.1
>>
