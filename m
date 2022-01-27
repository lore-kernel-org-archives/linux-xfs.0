Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1721CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 06:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiA0GqB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 01:46:01 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16590 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234487AbiA0GqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jan 2022 01:46:01 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20R6NkQW012674;
        Thu, 27 Jan 2022 06:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RVmbgQ/HQwzZBHxQFFgMCLXjs4Qfjnx18VoBnhkzdUs=;
 b=vQt6hEgrmmc6wpjGR6qRA2HKys1+3lWikylvYt3PZed9IBEwdIINmSezi7g8blnv4CaZ
 7XkMCIcSDxIVSK+oVIUkVmJLf8BiqE7uuxpfVN3ZFL6mj8stt3n1+Wd3Grgar+wifqJF
 XnAS1bEEVbuDqRa4EqGUBLZp13STOkyImFDJ7n48d8Byrt2oaADSuhO3AFe4k6GuVxyb
 /eMmtms1wnl7QRnel01FyhAYwF4E6HpszZayT4qDoPzd5Y9mEeR+g+Cg3hAhrOaLk4mC
 avAkB3Qm8jBhVbYMkFaBNBXdJWjK7LmHvv60NDbeDP0/ZBt954u8V4elrFkft3FSp4ix hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsvmjgv8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 06:45:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20R6f4X3034999;
        Thu, 27 Jan 2022 06:45:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3dr722qfm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 06:45:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5UDF5+pSMbTaVw8qNGQuqrMfiSLzjgZ/ReO06InA4ElSYSG9b/O9wSVQXOpWEwTKqvIhGpiNiPuw8P00LvQEjn8D6HEoOkpbie/60gD1OQqFGWv3ph2mXHmrr+nP2keDYnqeqnwm4TmecbWWskABqD1b4y/Ec5VhxkMVCI8Pw33JHX8qUV7Jxdg5iVJ1Q4+xxjQsKXk1S7cJg0QVT6WxetIZPtAvIKXtCHlcQqWnX6n1a1hglkpXQSvVDOo7ztFCUt+qGXWNJ96gGC5PP+Jt4NBjwJ8iRStHXppQwNa1I7arMpxW4oZUuMO12WDF6uT+/Hbd2pa+3qxMHzAepU4EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RVmbgQ/HQwzZBHxQFFgMCLXjs4Qfjnx18VoBnhkzdUs=;
 b=AAb8+3Dr5X5gf+9A23NRnZZORf+wW6RqltWOG0Yf05Ne3+fcEZaBeHmupGiplgJNsvxW42l+WpLhIfVN/cAL37uqJ5zXaQFHDwvNjWoPgd7LeMCwRBi/crVn+NGKaVRvoFcxAi542aNQC+kP67Doi3vW7BbrQAnmfaBBaKqEUMP//u1ZbO6qNNlxQPCNhhg62AIPlJ4y6dRJfKr/IFkfW3BV24luzmTrKbWbERrBl18JqbVeKLDM/7YabUMCvn028d/xGXAkeG022mtZOyuNyself0WssL9JLYbB7KKQKwIW+AFzVf9Eh7YHxpkhtS0W3RpW8t/tj6LK03wv/j8qCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVmbgQ/HQwzZBHxQFFgMCLXjs4Qfjnx18VoBnhkzdUs=;
 b=ldgMm9fQBAbUOO4Ou4FbIF6YbQS0W3FUr86ssIB27mCZfy2FlW6i6fb/gWlHkKoRrAIM+sJ8fTDUbgomKRRt+LMka1w1ZecP0w9cM2M3YaN88qi0xTPnJpnnu/FSZe+xuSzbAlSePt4aAVvizVg4TyD3FwZ+TEf8CtCgNKK99UE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR10MB1771.namprd10.prod.outlook.com (2603:10b6:4:8::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.11; Thu, 27 Jan 2022 06:45:54 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%8]) with mapi id 15.20.4930.017; Thu, 27 Jan 2022
 06:45:54 +0000
Message-ID: <e44023b7-12cc-5a21-b8bd-e54841c9ed66@oracle.com>
Date:   Wed, 26 Jan 2022 23:45:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v26 05/12] xfs: Implement attr logging and replay
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220124052708.580016-1-allison.henderson@oracle.com>
 <20220124052708.580016-6-allison.henderson@oracle.com>
 <20220125011916.GL13563@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20220125011916.GL13563@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:510:5::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d6ade9b-841c-4f9e-bba6-08d9e160aa94
X-MS-TrafficTypeDiagnostic: DM5PR10MB1771:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB17712443E5544FA87321C83595219@DM5PR10MB1771.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vis5idkEHZMhC/sVIs8lIBKfZqVhraDmY6tIECIjkDr4uHHgIPJqelCS5232DjwyN2AhXWpvd/2L+xvNBv0gajXiu/tvanRdexe+53u8PIo5ODPRc0uqjDpucX6bdJvHFkuYsqbnHQxBwIp4AD+OqwldtgM0QZXf3jX6lNAPIKIbifcxNK80h2dUQlaifbFtX9n5yfEdDrDLhPadb4DSHaIZlb6SNqF8dCnM5VomOw2cS9/kglHwxPdx7a0WJWviuvt//CC0ay9iFTPaAC8jiomdn4PUaaOQOqf546LV2Lkm/G2pIexzedQGmcKMVFZSvHUaGWa8hnd0JTXM3vyn9OFSRp2Utzn8HCng4FVqR5RYkHSIwMuoLvnUcXAONJHg6x82JiRrMGWzezXC196vMGRxUBS6eY2iqti1Rq9JLT1R5cQe/tiH5iuf5jNx26qHPcnIXwymFWFL3AKHRCVuTUyfWiawy6Jo/WfiMofGVP9Ppsh0Z40TpqJ4lGHKG62nnrrqsr0FcI44G2NwBMr0VInufrj/VWnCF8+0y6Q5b6sqKEjALLTiyOmZz55Yh2fQBoBpZAdPXDMB6bwgqIBx0zoA3TGE/cQ9wJU+JTbvYvSzDen6RAhtD/ScH3JjjmqchAapFAdGbHi9N+sFyV/3En0uhVFf3485/R/osYKFaa9PhWE6WGcYOYiT4KGG9VVTg7YoQXiKWiug6YgnUQQLdEh9/gi+7chn81OzGlWSlEMemEygyIJlQijpPqGfr1SbPCv2BJEH2aSJZZJkQlHwiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(31686004)(36756003)(26005)(316002)(508600001)(186003)(5660300002)(38350700002)(6512007)(44832011)(66946007)(2906002)(6666004)(6506007)(2616005)(83380400001)(8936002)(52116002)(66556008)(4326008)(6916009)(66476007)(53546011)(30864003)(38100700002)(8676002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHhvWkFZZ2J6U01HN01qNzc5Z2cxekdnbWRMZWc5dDQ1bEJmS1RNNW1yKy9B?=
 =?utf-8?B?MHlxUmlMUnZzUldpUTBXMGlVQi9BN3pueXpwcXorZUVpZ2tlUFFhRUJ6emJ4?=
 =?utf-8?B?THBXRzcyeENReWM5MjdqMmU5a3puaU9abzN2dzV3SkV3WEF6VkN5VG8rVzZh?=
 =?utf-8?B?ekRxd1VXa0MvSHJjbHdHSi9RWVV4NmpuQnRZejlXWCtlVG0zZEFIZm5xVmo1?=
 =?utf-8?B?YjFwb25CeFR0dUhpNEdQQVkwYUxaTG5QVzdkT3hreis1RzVYRldNU05scmdl?=
 =?utf-8?B?RHEyU3NsaEk3RDJzS2hLSjJLNkh5enRneFdrdndiMnJRL3pOcS9pZkRmRlRF?=
 =?utf-8?B?anI1Q1FpRmo4bTNhN05aZFhqZXU5WFJpU2RtRE1OZ05ua2VFUEtBN1FBeGR4?=
 =?utf-8?B?S2hXSkVTc05TZVVFTkJmMU9HVVBwcCs5dVVRME5Qc2lGV2F3VlNRdmpWZjdG?=
 =?utf-8?B?WE83SUNYb29RSEcySWdMSjBKZ2J5N0REYWJXb1dtREhhZFVzM0dSbDNQT3N0?=
 =?utf-8?B?OERMMUtLejNhUCtnTTNWK0F4aEJPMjNwb3AweU40dGo5eC9IMmFjTFMxN0hL?=
 =?utf-8?B?Wm50R2Y0N2taQWtHT1BoRUtad2NvR01hSFVSdjlyMVVSc21nb1p5RG4vN0Ns?=
 =?utf-8?B?a2lNWGM4Y1NvdjNDNmtnMkJTY25vQU4yZ0FtSTEra2hWU24wZENaekYzMTd2?=
 =?utf-8?B?amYxNkt1N2JCekNiZ01WSmNjOGxYaFh5eTlIRU94Y0V6NndqbEVlYUcvOFAv?=
 =?utf-8?B?MVgrNzU5QWRiakxySmQvY1p5cTBEOWd0VUJrcXBFWk11QTRPRllRbVBaYnNh?=
 =?utf-8?B?d0VXb3VYeE8vT2phWTN3QkU4V3MvT1JaZU1aSFVtWTZEcXpSdTRheU9FVSt3?=
 =?utf-8?B?QW5WYnJTQTkxZE9KV0hvWkk0UmZLTlBFeGc4aElra1FoT1ZGbEYzTkdibDZt?=
 =?utf-8?B?b1lnZU5KRVJ3Y01HNFlPeWloTk5CaE9ERldnVXlnZEduWFhIVUpiSEZFUXYx?=
 =?utf-8?B?ODdYdWdXQVYvQzV5L09ubXRvMGRxZHZPajRVY05CNzF3aFFDVXZXbXAvL3ZI?=
 =?utf-8?B?OGdDdzRwSlE1STdDbnlUcXIzZlVSZFY1YitNZWM1YXBKa2hkNXlXdElPSXV4?=
 =?utf-8?B?d1FxYWFsMUpnOEVjdWxsVnVMSWE1eHl6S1hkelBieTdHcTdwU0FkREdXRThh?=
 =?utf-8?B?aWdwVU9Gcll6WHJ0Vmpka2RBdHFjTzZxb2NFSVRQeEswMWNncFNHZzhHZVU0?=
 =?utf-8?B?MVJ6b2Npenpva2lUdmUyQkpqZjVNOVVWcEd3aTh6eHcyNG5WY2RSS1FWaDd0?=
 =?utf-8?B?QmE0cmZWSkNpYjJlMjZSTHlIVVg4RUZLeWVwMEsvdHVCekhVR241RkZUMHQx?=
 =?utf-8?B?ODlITjZ6U2picU10S05DNWh0a2NGWEcvYlRFUC8rUGdJUTFjTWxYczBPT2Vn?=
 =?utf-8?B?dEdHY2wraHdUOTBDaVFiVC9WUUhGb056UUExRzNvMklaOXdPV1l3RHQybEJZ?=
 =?utf-8?B?QmtIbFcyRzI5S3BmV20rUUpoK2NOaEo5bkJNVjdieWxNT0ZVSHh2VllXUEN1?=
 =?utf-8?B?UkJmRnFoUHM1TGcwMy94WnFkb1o0ckcxZE5JSHBWYkVBeEIyZlZOYnN0Q09E?=
 =?utf-8?B?Qk4xSFQxT0dXc2dDM3NWSFZ2VEdOaFllUWlxQjZEZ2dRVnNTeWpQVGZWb21S?=
 =?utf-8?B?UEVjRldUV084S0c5b3IzVWc4eWZCK3VVRndic3E3SFFkdzlObTJOaGdqZy8r?=
 =?utf-8?B?Nk9MRmNmYkRYRnpjS2JteGZUUHEwa3pwdHd3Vk5HcXp3cXhXY3VjZlNGLzhU?=
 =?utf-8?B?WE1mbThxN3ZjREpmMjhjK25XWGxQWEsxK01mVEdCbUtxL2lyK29laUhubzRy?=
 =?utf-8?B?M2k0OWVEdzQ2Tzhob2V0QVZnQmhMUnlVR3NkQkN6SE5yb0Rpd3BkMHorQnJO?=
 =?utf-8?B?ZWFGSVZ2Z3A3aGxCVWdOV0hZR3d0dGl4STVaTFZTZ1Q0aWpYNFlzVlp0aTZK?=
 =?utf-8?B?UWlnb0tZTGJyQ2tCM2NIbjk0Y294VTFvY0ZwSXNPWFpySzRLLzU5Nmhld09Z?=
 =?utf-8?B?WmFyYTFPVE9jL0c4MC96TW5FQlJzTndVOWRRUktyQjBCRXpvUEJ3dnR4bnF2?=
 =?utf-8?B?S3RxaW5qM0JQWDV3K21ycW1QVDNtTmR5eTZvUnBKZmxaaVRaanBPTXpLd0hm?=
 =?utf-8?B?aUQweFBLV2dQSXp4NGp0L0lwZmk5UGNNTWJwbkpUT0JINFhJaVg0ZzNlV1Ex?=
 =?utf-8?B?U3hLY0V1R1dRWlJwbUhyTFNLMEpRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d6ade9b-841c-4f9e-bba6-08d9e160aa94
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 06:45:54.5869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdJIlsDcpbOmQccXrmLFBg8CZ/yk9BDeixB4EqC2iVqdnwVtiDxJPOeZj7+oPsJwOEkEVwixUHPoZ1fVPbAPDovVeGuKRArXf5kwxPQ96MA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1771
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270037
X-Proofpoint-GUID: 6EzKN3yCszd5njMxsgLUipcBY8W-Uag6
X-Proofpoint-ORIG-GUID: 6EzKN3yCszd5njMxsgLUipcBY8W-Uag6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/24/22 6:19 PM, Darrick J. Wong wrote:
> On Sun, Jan 23, 2022 at 10:27:01PM -0700, Allison Henderson wrote:
>> This patch adds the needed routines to create, log and recover logged
>> extended attribute intents.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c  |   1 +
>>   fs/xfs/libxfs/xfs_defer.h  |   1 +
>>   fs/xfs/libxfs/xfs_format.h |   9 +-
>>   fs/xfs/xfs_attr_item.c     | 361 +++++++++++++++++++++++++++++++++++++
>>   4 files changed, 371 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index 214cad940a22..c618e6a98456 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -186,6 +186,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>>   };
>>   
>>   static bool
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index fcd23e5cf1ee..114a3a4930a3 100644
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
>> index d665c04e69dd..302b50bc5830 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
>>   	return (sbp->sb_features_incompat & feature) != 0;
>>   }
>>   
>> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
>> +	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
>>   #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>>   static inline bool
>>   xfs_sb_has_incompat_log_feature(
>> @@ -413,6 +415,11 @@ xfs_sb_add_incompat_log_features(
>>   	sbp->sb_features_log_incompat |= features;
>>   }
>>   
>> +static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
>> +{
>> +	return xfs_sb_is_v5(sbp) && (sbp->sb_features_log_incompat &
>> +		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
>> +}
>>   
>>   static inline bool
>>   xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index bc22bfdd8a67..3f08be0f107c 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -13,6 +13,7 @@
>>   #include "xfs_defer.h"
>>   #include "xfs_log_format.h"
>>   #include "xfs_trans.h"
>> +#include "xfs_bmap_btree.h"
>>   #include "xfs_trans_priv.h"
>>   #include "xfs_log.h"
>>   #include "xfs_inode.h"
>> @@ -29,6 +30,8 @@
>>   
>>   static const struct xfs_item_ops xfs_attri_item_ops;
>>   static const struct xfs_item_ops xfs_attrd_item_ops;
>> +static struct xfs_attrd_log_item *xfs_trans_get_attrd(struct xfs_trans *tp,
>> +					struct xfs_attri_log_item *attrip);
>>   
>>   static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
>>   {
>> @@ -257,6 +260,163 @@ xfs_attrd_item_release(
>>   	xfs_attrd_item_free(attrdp);
>>   }
>>   
>> +/*
>> + * Performs one step of an attribute update intent and marks the attrd item
>> + * dirty..  An attr operation may be a set or a remove.  Note that the
>> + * transaction is marked dirty regardless of whether the operation succeeds or
>> + * fails to support the ATTRI/ATTRD lifecycle rules.
>> + */
>> +STATIC int
>> +xfs_xattri_finish_update(
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_attrd_log_item	*attrdp,
>> +	struct xfs_buf			**leaf_bp,
>> +	uint32_t			op_flags)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	unsigned int			op = op_flags &
>> +					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>> +	int				error;
>> +
>> +	switch (op) {
>> +	case XFS_ATTR_OP_FLAGS_SET:
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
>> +	 * attr intent/done items are null when logged attributes are disabled
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
>> +	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
>> +		return NULL;
>> +
>> +	attrip = xfs_attri_init(mp, 0);
>> +	if (attrip == NULL)
>> +		return NULL;
> 
> No need to check attrip here, you've already guaranteed that it can't be
> NULL via GFP_NOFAIL.
Right, will pull that back out.

> 
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
>> +	 * Always reset trans after EAGAIN cycle
>> +	 * since the transaction is new
>> +	 */
>> +	dac->da_args->trans = tp;
>> +
>> +	error = xfs_xattri_finish_update(dac, done_item, &dac->leaf_bp,
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
>> @@ -314,6 +474,161 @@ xfs_attri_validate(
>>   	return xfs_verify_ino(mp, attrp->alfi_ino);
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
>> +	struct xfs_attr_item		*attr;
>> +	struct xfs_mount		*mp = lip->li_mountp;
>> +	struct xfs_inode		*ip;
>> +	struct xfs_da_args		*args;
>> +	struct xfs_trans		*tp;
>> +	struct xfs_trans_res		tres;
>> +	struct xfs_attri_log_format	*attrp;
>> +	int				error, ret = 0;
>> +	int				total;
>> +	int				local;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +
>> +	/*
>> +	 * First check the validity of the attr described by the ATTRI.  If any
>> +	 * are bad, then assume that all are bad and just toss the ATTRI.
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	if (!xfs_attri_validate(mp, attrp) ||
>> +	    !xfs_attr_namecheck(attrip->attri_name, attrip->attri_name_len))
>> +		return -EFSCORRUPTED;
>> +
>> +	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
>> +	if (error)
>> +		return error;
>> +
>> +	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
>> +			   sizeof(struct xfs_da_args), KM_NOFS);
>> +	args = (struct xfs_da_args *)(attr + 1);
>> +
>> +	attr->xattri_dac.da_args = args;
>> +	attr->xattri_op_flags = attrp->alfi_op_flags;
>> +
>> +	args->dp = ip;
>> +	args->geo = mp->m_attr_geo;
>> +	args->op_flags = attrp->alfi_op_flags;
>> +	args->whichfork = XFS_ATTR_FORK;
>> +	args->name = attrip->attri_name;
>> +	args->namelen = attrp->alfi_name_len;
>> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
>> +	args->attr_filter = attrp->alfi_attr_flags;
>> +
>> +	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
>> +		args->value = attrip->attri_value;
>> +		args->valuelen = attrp->alfi_value_len;
>> +		args->total = xfs_attr_calc_size(args, &local);
>> +
>> +		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
>> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
>> +					args->total;
>> +		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>> +		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>> +		total = args->total;
>> +	} else {
>> +		tres = M_RES(mp)->tr_attrrm;
>> +		total = XFS_ATTRRM_SPACE_RES(mp);
>> +	}
> 
> I kinda wonder if this bit where we make up a xfs_trans reservation and
> allocate the transaction should be a common helper somewhere...?
> 
> (ok to make that a cleanup at the end of the series.)
Sure, will add that as a clean up patch

> 
> With that one attrip null check thing fixed, I think this is ready for
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Great!  Thanks!
Allison

> 
> --D
> 
>> +	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
>> +	if (error)
>> +		goto out;
>> +
>> +	args->trans = tp;
>> +	done_item = xfs_trans_get_attrd(tp, attrip);
>> +
>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, ip, 0);
>> +
>> +	ret = xfs_xattri_finish_update(&attr->xattri_dac, done_item,
>> +					   &attr->xattri_dac.leaf_bp,
>> +					   attrp->alfi_op_flags);
>> +	if (ret == -EAGAIN) {
>> +		/* There's more work to do, so add it to this transaction */
>> +		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
>> +	} else
>> +		error = ret;
>> +
>> +	if (error) {
>> +		xfs_trans_cancel(tp);
>> +		goto out_unlock;
>> +	}
>> +
>> +	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
>> +
>> +out_unlock:
>> +	if (attr->xattri_dac.leaf_bp)
>> +		xfs_buf_relse(attr->xattri_dac.leaf_bp);
>> +
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	xfs_irele(ip);
>> +out:
>> +	if (ret != -EAGAIN)
>> +		kmem_free(attr);
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
>>   STATIC int
>>   xlog_recover_attri_commit_pass2(
>>   	struct xlog                     *log,
>> @@ -386,6 +701,50 @@ xlog_recover_attri_commit_pass2(
>>   	return error;
>>   }
>>   
>> +/*
>> + * This routine is called to allocate an "attr free done" log item.
>> + */
>> +static struct xfs_attrd_log_item *
>> +xfs_trans_get_attrd(struct xfs_trans		*tp,
>> +		  struct xfs_attri_log_item	*attrip)
>> +{
>> +	struct xfs_attrd_log_item		*attrdp;
>> +
>> +	ASSERT(tp != NULL);
>> +
>> +	attrdp = kmem_cache_alloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
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
>>   /*
>>    * This routine is called when an ATTRD format structure is found in a committed
>>    * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
>> @@ -419,7 +778,9 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
>>   	.iop_unpin	= xfs_attri_item_unpin,
>>   	.iop_committed	= xfs_attri_item_committed,
>>   	.iop_release    = xfs_attri_item_release,
>> +	.iop_recover	= xfs_attri_item_recover,
>>   	.iop_match	= xfs_attri_item_match,
>> +	.iop_relog	= xfs_attri_item_relog,
>>   };
>>   
>>   const struct xlog_recover_item_ops xlog_attri_item_ops = {
>> -- 
>> 2.25.1
>>
