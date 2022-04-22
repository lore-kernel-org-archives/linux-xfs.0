Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4F5C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 00:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442956AbiDVAki (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 20:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiDVAki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 20:40:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A9C443FA
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 17:37:46 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LLnrj7014729;
        Fri, 22 Apr 2022 00:37:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bHJ6p/ddHDVUKlZUN9k6KQ0xPBZayvJJfsnVIdH9CCI=;
 b=BTXJsJQHI4SrgolbCifVwXslSEGYsfFM1CKT/t8QSq1lzuBHnELK3lUNZSD8ZKB0s7bD
 ETekDn9juDD2fdrEnNOCtS5LG45eAtifRdONAZzHQq96aR5BukFoHK8dI/z17hT04E33
 DnfnyXWgA84Tbqb2dnrKxuHkXC7Y9aCbX5kkvq8S7v8cF8iWDueo0gUVtw3YRDYlEW/L
 sNkliXtWPT1EoyHUPxL+YDxTR/WSZAHafA7YfxmRlLBymYyDrFNEcJKU9r/NZ5bF1lyR
 gb2ZkVbwepWJOsqdKMJ/npFzZfvo9T/IUYvPMspo3Nswu/mYdqd8Ytj5N8eSQuAo+uEx Ow== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffndtng4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 00:37:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23M0aqua037249;
        Fri, 22 Apr 2022 00:37:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm89rkts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 00:37:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cr7mzfa81Qbg5+7pFYout/d2rbrlttAbpI/Adm4EcpJypc9qNliRWVa02TiHu0vBj8rXtncVjY6bx3XKcPDCMtCP6C8sCIxzN04kBxXJjvlAa0HfC1YkA378kZkXZiDq401S4q2geERZzGf9t6vydbkI3R3i1brHQtERD4mTp7fMB6L5idP8ViWvB4Or736gLY/0ETpkGjWoD5ubG2uKfPhYOfJTJrBkkTphmhGRqrO+zTx4YkaQTOuj53Ec1D2YPJvFg9n5pu6JdFQdQJmMnYAXh+AB872XgrmHX+/1H94MzR+EUbv2OWDu/AUclH8y7ZB2hbv23Sl8k8M6BJVCIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bHJ6p/ddHDVUKlZUN9k6KQ0xPBZayvJJfsnVIdH9CCI=;
 b=KbQoFRlhnedGftSqoaQrE5g23FjTzj9f0OAat+ty4/EUfNl8wRO1JCj+xUljVn05inwwJxgY0EakS+HNl/FNp5FubIs775YsxazK/0GliuPjgBpxdUuygJFGmLNI3BetbnxvzKzJEM+C/vC4tDfQK9NV7Yr0AYEdNyizkPyxEJor1PeWwuamh1w6xViH2faZ/sDcmBM7FnV0ohvBJq1dX/P99sYKsz/atx6br3iGPMPRamkpORbIW+mmjNxx46g7SpY5tegM62XixBsPYgCaU3WfUbBwywm2oeLNHxc29Gu3zzxgIitnEj7iC5+V2UJaz+4WyVGKchRj55gtcgm4Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bHJ6p/ddHDVUKlZUN9k6KQ0xPBZayvJJfsnVIdH9CCI=;
 b=ZVetRKlEoENjXLnF1a0QolY3+TLmWk8rKzRkPbg0pnSQfakRGBEMMFVnHoaUgzoF6H65zfXD/MJwe3zAZpYogQcpSKkrfoP3HUIj/jap5mVlvIMcodp9Ag6iM+k6qdY/BiG2gY4WyR78O/6XJf6/H6tFBEEE1WTaO5jM+ohAt/I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH2PR10MB3973.namprd10.prod.outlook.com (2603:10b6:610:11::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 00:37:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 00:37:43 +0000
Message-ID: <d6755b847a320ec72038e3e51a231234126c2113.camel@oracle.com>
Subject: Re: [PATCH 02/16] xfs: initialise attrd item to zero
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 21 Apr 2022 17:37:42 -0700
In-Reply-To: <20220414094434.2508781-3-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-3-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16458244-084a-4035-186e-08da23f85067
X-MS-TrafficTypeDiagnostic: CH2PR10MB3973:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3973C92EE09A6D3C095E566A95F79@CH2PR10MB3973.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jIPEVhfiSP8vhBgDUCD96FIBT883BL80FNEqle8SYTeuMBx2cz0eLVHNhz707Sh+ciXh4XcZKY2+zRHhrdqoXAk6znmLGmnvf8UkbyveFQQ1yc38fW+UeE+l0jUzTfVc0XliELr05pkL3IVzQJroucY7br8B2kZCPHaJCceRA0bAFnRgsuicZ4GOXZuJ4vpo+7Gai+VKK6pWEJpI0rBMMExH9GUhc32p3tcgzo48e6il2zI78RTS0azLhOn7pI8Jq6ROZ+ASpKQoIehzVhe3uB3/BnlJSroN8xoNm65a/2GG8AnUYaGDA3qN4Pn2CUQAnwMHHfk//Hk+Y0rZi+QOMxZZnfde0ZZ/tn+2/xJkbLABkMA3ML/dAST/gbxb7edLcG62GSAfXji1AiY8CUwSX0peK317o/+ISMNCJhQe5m9e7dXHkJNW47U3S7ppPKzw4LKIJ3UG25Yj8Fdp69yXFO02oqKMik5XhIbNoovHJ1zLnN+WaDecH+PX+TaFjBY/w/uQsdaxQc3GeIg3K4PJ0RUS7/YjSWYhuYDlCz6btpFdPidXCeJZzXIUVGhsouG1En4B1zaaLMjG2SlDR209MCk3daDHdnMf6InfJG/VDz5H4TGVB2rk12hEKq29QQPX7HCY0IabXIS5FlD3RuqtODI2g19M/FMUqkIXrQJGAAIXAzn8G+TUj1DhVFVA/dQA76NgNx2+33CJqDebR3YIOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(38100700002)(26005)(316002)(86362001)(38350700002)(66556008)(66476007)(66946007)(5660300002)(36756003)(508600001)(6512007)(8936002)(8676002)(6506007)(83380400001)(2616005)(6486002)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qm5DWndmam1VK0RvR3JhZDJYVGFRS0Y5Zy95bXZMQ3hJeWpHTjFwUmxSUm5k?=
 =?utf-8?B?OWtIdjhDK1JONG42SjJMTkt2Sm9hengzWEQrQWo4UlJYamgrL21lbXZYT2Nw?=
 =?utf-8?B?dkpWQm52NGxPWlJnSlRCU1BpNk8vUkRtMTVuNHQrV2ZUZGtiL0VORUU4cG5l?=
 =?utf-8?B?MEVJazhwTCtRSndvMGRQL3dlRFBFSHZMSXRZemkwRnJzZWRUV0tETHpjT1Rj?=
 =?utf-8?B?ZTY5aFp6OUxITVY4ZXIwcWdZYjdiQzVJekhHZXdIOUc4eDJNQ2EyQVhPYTZj?=
 =?utf-8?B?Y0NERlRJTFRBREJwUGNDMVpZb0tuUE5MaHB5eE9oSXcvWWtyTis3RlNiZ3F1?=
 =?utf-8?B?T1RqSUF5aFo2eFc5QW5kSGRTN1BmUUZHVlVXYlZnYmY0ZjVxdWc3QU91VVpD?=
 =?utf-8?B?eC9XQnk0UkZwQnovTjRLcHA4am05Z3ZrdzVIWFpCd1JJeVZiVmVlelg1bUhH?=
 =?utf-8?B?K2pyN1htWk10cndsdGN4ZGtJVFVCOHNxeS8rMm1scjJFSXcrTmhodW55ejJl?=
 =?utf-8?B?YkF4dzlCdW4wcGJtek9TSTVFMyt6VVduZms2NUhPR2ZBWXVJWmE2RGhDS0s2?=
 =?utf-8?B?V0VXVzlSUXRHVmllTko0K3BrQlVkNXFNbmNQS1pOc3piOEszMXdSMTVZQW5w?=
 =?utf-8?B?ZVBydEt3Mm1vbmdNY1YyWjdncHhjOEcvK0ZtRzJrcVg0R21aM3czbDhHM0Z5?=
 =?utf-8?B?dXhqVThER1duTmQ1dVJQakxqTmJteGk3WkNBbkp5TEMyRk1MSTdlZnUzRG5i?=
 =?utf-8?B?WmFUYWtrMytHanlJV2hDMG5QMzhMbCtSZG53YzkzNHA3dDNOd0pPU0NMY1V6?=
 =?utf-8?B?Wm4wS25Ya2FHS2s0bjczVHFMTVM0TmdhTmowWE02blBPZ3M1WlBrV1p5bXA5?=
 =?utf-8?B?RmExY0kvWEQ3bU1yRy9iN0RWeGxPKzBBZ09Na1FYbXhpUXpIWkJrNDMzRml2?=
 =?utf-8?B?dmJsaE5NTVh6b2l0UkhJclRtRXJUQm9SeXpEclFhbmJPcnFsaG00eGpOb29D?=
 =?utf-8?B?cGtEUlNhbWlCdU9QR3pkVzNhbFgzQkNyU2RXRW8rMWowZzNiSkpQTXM0bXha?=
 =?utf-8?B?eVRiUGRoYVY5blZJOXhrRmEwNzRWQlRMYTFuTktLZllYd0dJNFdtRHpNM2F5?=
 =?utf-8?B?dGpmQUw0ZXVLZlJPVU5TUkl1QWlRcDlTTTFzeGUzZjluTy9YM2dRMGZtWE9u?=
 =?utf-8?B?ci8rVlRkM0NUWVpsV1VrVWplM3E0M2UxcUh5dmllL29KTmtxMlpHTmgySFRo?=
 =?utf-8?B?V203cDdFaUZRWll2YXo0L0QvMit4bnJjZUs3NEphKzhFSWpBQjJSTDd5SUU4?=
 =?utf-8?B?TlZBNXI4R1h5VFhlL2JxcHFnU1RMcHVmM0NDazQrek4zc3dBNkFRU2FaemV1?=
 =?utf-8?B?U3lIeEt3TFRsOGl0WmJwVU9zZ0gvNlIyZ3hicUJPQ3c0TUlmM0dvY29ZdDkv?=
 =?utf-8?B?d2hHcGxiWFhOYnR2NWYrcTNhTTVjaFdxMDd1VjJZQ3MvODJoS3puSGZLMWtT?=
 =?utf-8?B?bTFLT1c5dFNFT210Sjl5L3Y2MStUcENEcUsrL0VDMXFGWXR3VkFrNXROR1U5?=
 =?utf-8?B?MVdzRmd0bGZNeTc2ZzdJdE8wZWUyUWFJcFhGWjZ2TDlHRVZxK0oweGdEb3dn?=
 =?utf-8?B?aVAzdVQ5a0wrU1VmSFdURzFKM3F4SVYvRjNVRTNSSTBvYXFtamVOc05DeW9M?=
 =?utf-8?B?djFwVTZSbjVTRzN2RVNWTGxjZDNFejB3Y1FQeGxQY3N4cCtYdVFNSUNSRjJm?=
 =?utf-8?B?aXptUldLWnpQYzg4T1dUYXV0NDJkem5VcGM2VnF0M2hYa0R1eFNnZ09DalFC?=
 =?utf-8?B?MUNoTmFtYUhhOVJKQlRyMERyVDlyM2JWL2xQNWRlbXlQbzQwU0VUVDBDa1hB?=
 =?utf-8?B?OExCazBLRzNHSlZjcysvY0VIdjRqenNOOTV5RUZmRUhlRm1GODU3OWg5R0RU?=
 =?utf-8?B?UWdndmhWanFsdHRmYXZEaXdHSXY4Q0JzT1JBUXdqUWJGSUJlcU1yRVBiQVhX?=
 =?utf-8?B?Tm1NRDZHTHducW9Kd05pYXNuS29IaVQ5c1V3YjRFenNVTEcvOTlUcUxqdFk2?=
 =?utf-8?B?dzE5azExc2NEYnV2cFZoVlpEOE5IaVFJeEV0N3lSMWJpU0VrWEFqclBwc2dp?=
 =?utf-8?B?Z3R5ZDlJY2I0cW5nVDhWOWlvdnY4bjZwUmFNc3hhOGQ1OEltNWJhQTk4c2VG?=
 =?utf-8?B?OENxWENUc0V1M2pmaVhjeTZTaVQ1STlaY0NCMC9EL3h2S3FLNXoxMkJCTnR1?=
 =?utf-8?B?QXNVeWs5L1ZXSmJmVDBYbXoyY1Q2d3g2eExqR2Y3akJreXJYWGdMRHg2NHJh?=
 =?utf-8?B?NXphQTd2UGNQbU5IUUdObElQc3RLanJjcU9qTjJ1MmJMVTUvdGxIUVFwbitK?=
 =?utf-8?Q?EH0jfMFqcEOchN6w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16458244-084a-4035-186e-08da23f85067
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 00:37:43.5391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBhlH3+EB2185D4VGtOhbGEWzojCC+zNu3tgQfxMd1v0M314v4yEDnLrmbAqrO1nQTeyQF9QpVqVEa6MQzWXW2fzoIn3eIZKxZ6E+XOm9lQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3973
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_06:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220000
X-Proofpoint-ORIG-GUID: Y_JBLY4MqUS4jiwiswYfFOytPxgQ1ttw
X-Proofpoint-GUID: Y_JBLY4MqUS4jiwiswYfFOytPxgQ1ttw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On the first allocation of a attrd item, xfs_trans_add_item() fires
> an assert like so:
> 
>  XFS (pmem0): EXPERIMENTAL logged extended attributes feature added.
> Use at your own risk!
>  XFS: Assertion failed: !test_bit(XFS_LI_DIRTY, &lip->li_flags),
> file: fs/xfs/xfs_trans.c, line: 683
>  ------------[ cut here ]------------
>  kernel BUG at fs/xfs/xfs_message.c:102!
>  Call Trace:
>   <TASK>
>   xfs_trans_add_item+0x17e/0x190
>   xfs_trans_get_attrd+0x67/0x90
>   xfs_attr_create_done+0x13/0x20
>   xfs_defer_finish_noroll+0x100/0x690
>   __xfs_trans_commit+0x144/0x330
>   xfs_trans_commit+0x10/0x20
>   xfs_attr_set+0x3e2/0x4c0
>   xfs_initxattrs+0xaa/0xe0
>   security_inode_init_security+0xb0/0x130
>   xfs_init_security+0x18/0x20
>   xfs_generic_create+0x13a/0x340
>   xfs_vn_create+0x17/0x20
>   path_openat+0xff3/0x12f0
>   do_filp_open+0xb2/0x150
> 
> The attrd log item is allocated via kmem_cache_alloc, and
> xfs_log_item_init() does not zero the entire log item structure - it
> assumes that the structure is already all zeros as it only
> initialises non-zero fields. Fix the attr items to be allocated
> via the *zalloc methods.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, looks fine
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> ---
>  fs/xfs/xfs_attr_item.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 0e2ef0dedb28..b6561861ef01 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -725,7 +725,7 @@ xfs_trans_get_attrd(struct xfs_trans		
> *tp,
>  
>  	ASSERT(tp != NULL);
>  
> -	attrdp = kmem_cache_alloc(xfs_attrd_cache, GFP_NOFS |
> __GFP_NOFAIL);
> +	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS |
> __GFP_NOFAIL);
>  
>  	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item,
> XFS_LI_ATTRD,
>  			  &xfs_attrd_item_ops);

