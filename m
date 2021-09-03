Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B08AC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 275E060041
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhICV46 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:56:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12590 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233367AbhICV46 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Sep 2021 17:56:58 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183Iwucp017829;
        Fri, 3 Sep 2021 21:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=l7XPqflaL5wIzczB6Vivfnf+XbnvA/g2kXOP/rvhFgg=;
 b=r/cFljus+K4xsOmbixqVxxz/fzNQMwS4zLpA8cfNttfgp11BehSoIdPFbqJBvpqkYwTR
 suWpldx5lyQBLhKjOmRXf5D7mPFzgu8ITTgZutbuYkCjj5Kgeqlg21IInHaJ/MMXqbpK
 L1pXGfumHs7Ec8h2vFRNfTrW4GMCIoBEnnEC/az3/07le04kviW17Ib2mWwjwGIIIYia
 48Zb71eopWOAEJGAHxhAntoZ2TdRxrBsRp+CUncbsTMlRKpSLcKJJz936GVU+MXPmDCd
 3ydIAxsJuYeGScX96XJikSmlwzlj9PHwqQhgSaSl16D8aHlyvYkpZC2PexGTaZ/NeST9 tg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=l7XPqflaL5wIzczB6Vivfnf+XbnvA/g2kXOP/rvhFgg=;
 b=NOgqwUy8TXXMC77Y77IpHyvEnKeA/B10VjSOTECfWgPxkuoFshMPrZdG9sdQrsovIeGT
 dZWCyTKy+/96sCGVRX2Lt8RSl3B5wthoM8nw3PbGefaWjsbq2VHUutpJcxsNwD16tVuh
 Nv7uvn+lKe5kSTKA7LHXcOcS+rSeGBD8iO+KykzEjd8JKn/8VEaNUdRStSFiHnylzj8s
 pqZf3dw2VViwMKmiqpjHZE87GlDNgh/+j06QnoQQHYQShRQgMAfI01oHHrXE1BHu7pwr
 /0U3M7XfA8DPSQi52sCk/dUspBpRr5E9lgZueX1l7X1s6XxMfA3jT3XRwB3fP0sNr9qa 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aufj7a5x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:55:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183Lno4E146240;
        Fri, 3 Sep 2021 21:55:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by aserp3020.oracle.com with ESMTP id 3aufp3unrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:55:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FascydTXZbiqBX9NeqM9ObVqJ3TEn2VqwwSnVYP5/Iq5JmWJA121akvSjgNJXSYxLnWs9+fT2o5RskcnwEGbipOT6amYIBUXWaiDR95WpzUf5ZeEuGabDANQ6uDCczEz/kC7M2c6wUKu8bYQcgIaO3UMvS69mNBUmNgVCXAopMZbKCB0E7E+d++HxZpr2cAdPkrtt9mOTq4mf30FcIRLw6HpsZhCBHxXU3TVb7l7bjuZtMLGDLjtWadHIlTtQqPUQjduK3ICxEddSJ2msJIRD/OaH4UB2znP+wtZ0EAoZ6BFMQLZQLI5IlDE+/VJ/76WZvRXnwtBGiPXXj1GrpHnaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=l7XPqflaL5wIzczB6Vivfnf+XbnvA/g2kXOP/rvhFgg=;
 b=lKVCDPhFKae3PJZJh8zYtFuLPmU+uRA8RVDa+i7VrHc0EuDlEophX5xZoV35JOt4BMn9FVtKEmPLWtfj0UX6X+ijbuGTOXNycNjyGSV3mKAvpSf7XgebsGtTKHSfRMggUVZkAnNLdITcfRvHr/zYbe0aeFldcaKniEtjYExh94aa6WMt5bg/zkecKzKSqlqT9OmcptujtXDOVX05i5lk2sPIGydS0D31ChlXNY+pCbMHaoaLnuxX5bNI22nZLDIkKv3TlYgbKr6yiOXI2+k/VJ4LhOEmmc382rj7QNA0u/DjotS8nUGXtnYZwUv+xjcYmd0vT0vv0EsSI/oKBxVoGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7XPqflaL5wIzczB6Vivfnf+XbnvA/g2kXOP/rvhFgg=;
 b=GPrV3ss9tpmGa3nnRztaOoQQTEsIjWReX7jk0pxWAsf6Fuq7qptbg6pqHhLhmlIVU9NUC0I/ot+EGfQVyp+hHQ6Sdu50OPU2hVZAmE6rf3yJ+Mf7A18Mu5ZsZpMMF1PgpIx929qdYkxQrQrrvB1FeFgooRDGfFeh8aeAVc+HRDU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4624.namprd10.prod.outlook.com (2603:10b6:a03:2de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Fri, 3 Sep
 2021 21:55:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%8]) with mapi id 15.20.4478.023; Fri, 3 Sep 2021
 21:55:53 +0000
Subject: Re: [PATCH 7/7] xfs: reduce kvmalloc overhead for CIL shadow buffers
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210902095927.911100-1-david@fromorbit.com>
 <20210902095927.911100-8-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <60b698a6-6ed6-e733-a201-0d630900cccd@oracle.com>
Date:   Fri, 3 Sep 2021 14:55:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210902095927.911100-8-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0109.namprd07.prod.outlook.com
 (2603:10b6:510:4::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by PH0PR07CA0109.namprd07.prod.outlook.com (2603:10b6:510:4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Fri, 3 Sep 2021 21:55:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d98a0bb-de48-43c8-4813-08d96f2599e2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4624:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46246404C46C242A7F92557095CF9@SJ0PR10MB4624.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:451;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gvApqEVhK1p2CYW0EagXuHJNUFMDNjsYYLetZfRX0JTmQkLFG0qZUl3CVSHqPZWjVH9phJEYtIyNgFXBBp+nxaF3D51hi+Z9l/vNm1S8mHzRzImbYyqOjpa8XZ9MXBPtNW7rcuNHFM2odScJd2IYSveO5mWFDamOFIz4SP0PTt4vqtfoLPuTJ/JtWBlT/Cm5333TERruGPsNccI7ST6TBy0iEXT/UQGig74BksLNGF8G7Bxz1XT3m3ev/GXQfZ9rsgOdiW0bbHNxptikXfhdafUvKYMJmKbZym36Ee7rf3pGyGGkpj3UV04XHvSsd5o0SeFTyQDrOssBJNWId0hPrtwS1JbYB0zZIWu+yUhHyAN66poL+R8lHslEwsiHP7xrPTeF1Imi15nXInKvvBK9OzQo/KfeRDusNs0u+V0bW2whue96Frfk4TMNamJwB6kp660+qf5qYjHZdI5ienUWw1Zne8M13zt0Vc1uOYgHNVDuOZdYdbhaTOMUSe/mBmJE6RCKfL/UjJKAD9sMQwskx3xqRHHes4tPU3n7xniFuxSLz3F3h7mhje/eZzjl4xW7hwfPI7H7DB7KL7z18PM6KIKXP8bW+bDdbvSw+c+D0/UInO5WTqvUxkO+dBu23UqZOmGMHqgO3ctPivFeWu99Vy5f6BSdRZ6l0RrHPgEBM/3qvq5N8G9ThmYiUsFVaDIqpzHCVJ5JucAvOeMVO9EnRSgtIbwhM2zqkoEIxTwTv4M2hR+1jKQqbfgAZ1ctoKor4E4Sid8+JOd5gheyfwtuIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(38100700002)(316002)(26005)(36756003)(83380400001)(5660300002)(956004)(16576012)(38350700002)(2616005)(31696002)(508600001)(186003)(31686004)(53546011)(8676002)(44832011)(66476007)(66946007)(66556008)(52116002)(6486002)(8936002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1NaakFLNTJWeS8zNjh5ZXZrcTgxRi9GQ0tQM0tXREVEN1ZjYUI4a3Yyb1NP?=
 =?utf-8?B?TElONVpta3RuYTFtRE51Z01lYTErKzJoL0xOelFDQmhBQ0oyZVIwSmlRWUF5?=
 =?utf-8?B?RGxOOTR3UDIxeHVpQXQvZElhZGV6RnJXeUhzK1RCbFEzekt4cExiK0pVUWQ5?=
 =?utf-8?B?YmxZWmdJb0xRczhJeGtFaHlxbGFWN0FMWldZeGxaOUFxY1ZSZTNjRkIwQUwv?=
 =?utf-8?B?blgrL2ttdDd0bUM4MFpFRWtKK091aE1yYXVUcjJXQzJkSDdBd1Z0b2VWeUdM?=
 =?utf-8?B?LytGUFI0ZHBEU3J2MStmT0NYR3VlZ3BrK1ZtbjFpWHdvU2d2dkYzSnhyQTlM?=
 =?utf-8?B?dWlVTVBlSE55RFpvNmZhYXpBTjM2V0NiTzU4cmErY2dpWVRIeWVTNkZsbW16?=
 =?utf-8?B?ZTR6eGhpcHdjY0tzaE1rZ3RkWkkxRUVDZWozME9OQVRnQlBJbzY4MEk4a3M5?=
 =?utf-8?B?UDFXU2xGcnhxWEhFbzFMUVVINDVaN3k5ZG0vQ3Y3L2hLdjN5T2tONmhNTFIx?=
 =?utf-8?B?OVI2Zkh3V1o4UTlNVVhBODlaNWpSNTJSWm9PRHJQUUdjeUcwbHA5dmJjSDBG?=
 =?utf-8?B?c040RXAwUU1EdEJnZXpib2xJd1UwOWJpbkI5UzRQMzJnd3hmTmlvRlp0d0p3?=
 =?utf-8?B?Q3RsVzMxR0lmZHJJQlBUTkhMelQwMjY1TWdSMnlEUzQ5Z1NWMW1Vc0ZwSWVy?=
 =?utf-8?B?TGdmU0x3MkxNcXg2VkpZS0syeTJUVnZmWmxvNmtCbnZRRUkwYlRKU2NpOE52?=
 =?utf-8?B?ci9CUFlGeG5jM3BQUGdiVVBwdHFDOExqVWMyQWZBRU40RDllQmlaYitGdkEr?=
 =?utf-8?B?S0ZJaDJCRXNZSS9qYW94eXF2VmNKVTZtZVZLZ3J4dEdid1JBL2NYbVowa2dY?=
 =?utf-8?B?QW5FQzF4QXZreTJrTmlzclp6Q2taNHB3elNUT1ZWY0R6enV6Z2RlTmFiVko4?=
 =?utf-8?B?cHlBWExmKzA3WVZsUXRiVFVsVVh5V2Qrb1ZydHNaVnh1VGorY3dydkZTZFhU?=
 =?utf-8?B?S29aTmIwcVdwNnY1ZmhwSDRnMVkxdnhteUVPTGF6cEY4dGtJaDBkbGZSQUhU?=
 =?utf-8?B?amRBdXN3RGJySng5bEpFclNUSzJyenRCTXdSRTlNQkN6blZoNFQwMDI2aHJp?=
 =?utf-8?B?V2Y3dDBnNUJFdFhlS1Yzb1lscU1rdmhrTStUM0FvaU16UDZOUVJkRS9vdTNi?=
 =?utf-8?B?ZFNFUUd1aUZTSzNXbERpazlxSG1RN2hIRE5zN2wxNU1kWWhOQVFTajN4SGQy?=
 =?utf-8?B?WFpuUFhHOWZUQ0hDVUtYa0c1WGh5bFN6OGE0ZWhpU3JvVUo3bkdzdXQ1ZjlG?=
 =?utf-8?B?dUUrYlozL2RjN1NDWERDZ3Ard1lEOHFTcE1HMnhlS0lDSDBaVmp5NTF3TnJh?=
 =?utf-8?B?MG4xSXVMYmc2TUZiZ2JYM1dpQTY2ckhNaEhSUWMrS3ZlMUp1bUQvdVEwQUJy?=
 =?utf-8?B?bk5yUDRNMmloUHFiWnM4V0tNUU5PUEo3UDYrRXRHbTFwbnhtU3EvOFRWMGpm?=
 =?utf-8?B?djh6aDVaN3ZlMjUxazJWRkxYWVQxaWRpV0U3dXUyMkxUOEVCMmcyUVMxR0VZ?=
 =?utf-8?B?R0tFbndHWnpQRVRkQy9YdWpYaTNwQXhrc2Exd0RiS1ZXczVJS003ZytEUGQ3?=
 =?utf-8?B?TjhZb0lWNHdyL3ppb1ZLREhlb05ZL0RJYy9BaTM5dW1NMlhiZnBrUUZ6aUI5?=
 =?utf-8?B?elFmLzhMcXNwSjY0RGJXZktxbTVhUldkWHF0YVZKUzB2eUx5MnpUQU5KUGQz?=
 =?utf-8?Q?lpELqBsqnrZ5EflJFKDoUJ4LjhR/Q2eZBRO4C8B?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d98a0bb-de48-43c8-4813-08d96f2599e2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 21:55:53.6738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kif912DMm5dEHrDODKqQljfYyiJbm0NhfyVfsqvHepfgsRaAJezIgEevtdvZp6XCPs9d63QVYKSaAKR/u8alZqr8rxET3iTTm+pYYaBh6qM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4624
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109030128
X-Proofpoint-ORIG-GUID: K_FU6eX_55sgWFYz3RSkDz0rJAGNiOkM
X-Proofpoint-GUID: K_FU6eX_55sgWFYz3RSkDz0rJAGNiOkM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/2/21 2:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Oh, let me count the ways that the kvmalloc API sucks dog eggs.
> 
> The problem is when we are logging lots of large objects, we hit
> kvmalloc really damn hard with costly order allocations, and
> behaviour utterly sucks:
> 
>       - 49.73% xlog_cil_commit
> 	 - 31.62% kvmalloc_node
> 	    - 29.96% __kmalloc_node
> 	       - 29.38% kmalloc_large_node
> 		  - 29.33% __alloc_pages
> 		     - 24.33% __alloc_pages_slowpath.constprop.0
> 			- 18.35% __alloc_pages_direct_compact
> 			   - 17.39% try_to_compact_pages
> 			      - compact_zone_order
> 				 - 15.26% compact_zone
> 				      5.29% __pageblock_pfn_to_page
> 				      3.71% PageHuge
> 				    - 1.44% isolate_migratepages_block
> 					 0.71% set_pfnblock_flags_mask
> 				   1.11% get_pfnblock_flags_mask
> 			   - 0.81% get_page_from_freelist
> 			      - 0.59% _raw_spin_lock_irqsave
> 				 - do_raw_spin_lock
> 				      __pv_queued_spin_lock_slowpath
> 			- 3.24% try_to_free_pages
> 			   - 3.14% shrink_node
> 			      - 2.94% shrink_slab.constprop.0
> 				 - 0.89% super_cache_count
> 				    - 0.66% xfs_fs_nr_cached_objects
> 				       - 0.65% xfs_reclaim_inodes_count
> 					    0.55% xfs_perag_get_tag
> 				   0.58% kfree_rcu_shrink_count
> 			- 2.09% get_page_from_freelist
> 			   - 1.03% _raw_spin_lock_irqsave
> 			      - do_raw_spin_lock
> 				   __pv_queued_spin_lock_slowpath
> 		     - 4.88% get_page_from_freelist
> 			- 3.66% _raw_spin_lock_irqsave
> 			   - do_raw_spin_lock
> 				__pv_queued_spin_lock_slowpath
> 	    - 1.63% __vmalloc_node
> 	       - __vmalloc_node_range
> 		  - 1.10% __alloc_pages_bulk
> 		     - 0.93% __alloc_pages
> 			- 0.92% get_page_from_freelist
> 			   - 0.89% rmqueue_bulk
> 			      - 0.69% _raw_spin_lock
> 				 - do_raw_spin_lock
> 				      __pv_queued_spin_lock_slowpath
> 	   13.73% memcpy_erms
> 	 - 2.22% kvfree
> 
> On this workload, that's almost a dozen CPUs all trying to compact
> and reclaim memory inside kvmalloc_node at the same time. Yet it is
> regularly falling back to vmalloc despite all that compaction, page
> and shrinker reclaim that direct reclaim is doing. Copying all the
> metadata is taking far less CPU time than allocating the storage!
> 
> Direct reclaim should be considered extremely harmful.
> 
> This is a high frequency, high throughput, CPU usage and latency
> sensitive allocation. We've got memory there, and we're using
> kvmalloc to allow memory allocation to avoid doing lots of work to
> try to do contiguous allocations.
> 
> Except it still does *lots of costly work* that is unnecessary.
> 
> Worse: the only way to avoid the slowpath page allocation trying to
> do compaction on costly allocations is to turn off direct reclaim
> (i.e. remove __GFP_RECLAIM_DIRECT from the gfp flags).
> 
> Unfortunately, the stupid kvmalloc API then says "oh, this isn't a
> GFP_KERNEL allocation context, so you only get kmalloc!". This
> cuts off the vmalloc fallback, and this leads to almost instant OOM
> problems which ends up in filesystems deadlocks, shutdowns and/or
> kernel crashes.
> 
> I want some basic kvmalloc behaviour:
> 
> - kmalloc for a contiguous range with fail fast semantics - no
>    compaction direct reclaim if the allocation enters the slow path.
> - run normal vmalloc (i.e. GFP_KERNEL) if kmalloc fails
> 
> The really, really stupid part about this is these kvmalloc() calls
> are run under memalloc_nofs task context, so all the allocations are
> always reduced to GFP_NOFS regardless of the fact that kvmalloc
> requires GFP_KERNEL to be passed in. IOWs, we're already telling
> kvmalloc to behave differently to the gfp flags we pass in, but it
> still won't allow vmalloc to be run with anything other than
> GFP_KERNEL.
> 
> So, this patch open codes the kvmalloc() in the commit path to have
> the above described behaviour. The result is we more than halve the
> CPU time spend doing kvmalloc() in this path and transaction commits
> with 64kB objects in them more than doubles. i.e. we get ~5x
> reduction in CPU usage per costly-sized kvmalloc() invocation and
> the profile looks like this:
> 
>    - 37.60% xlog_cil_commit
> 	16.01% memcpy_erms
>        - 8.45% __kmalloc
> 	 - 8.04% kmalloc_order_trace
> 	    - 8.03% kmalloc_order
> 	       - 7.93% alloc_pages
> 		  - 7.90% __alloc_pages
> 		     - 4.05% __alloc_pages_slowpath.constprop.0
> 			- 2.18% get_page_from_freelist
> 			- 1.77% wake_all_kswapds
> ....
> 				    - __wake_up_common_lock
> 				       - 0.94% _raw_spin_lock_irqsave
> 		     - 3.72% get_page_from_freelist
> 			- 2.43% _raw_spin_lock_irqsave
>        - 5.72% vmalloc
> 	 - 5.72% __vmalloc_node_range
> 	    - 4.81% __get_vm_area_node.constprop.0
> 	       - 3.26% alloc_vmap_area
> 		  - 2.52% _raw_spin_lock
> 	       - 1.46% _raw_spin_lock
> 	      0.56% __alloc_pages_bulk
>        - 4.66% kvfree
> 	 - 3.25% vfree
> 	    - __vfree
> 	       - 3.23% __vunmap
> 		  - 1.95% remove_vm_area
> 		     - 1.06% free_vmap_area_noflush
> 			- 0.82% _raw_spin_lock
> 		     - 0.68% _raw_spin_lock
> 		  - 0.92% _raw_spin_lock
> 	 - 1.40% kfree
> 	    - 1.36% __free_pages
> 	       - 1.35% __free_pages_ok
> 		  - 1.02% _raw_spin_lock_irqsave
> 
> It's worth noting that over 50% of the CPU time spent allocating
> these shadow buffers is now spent on spinlocks. So the shadow buffer
> allocation overhead is greatly reduced by getting rid of direct
> reclaim from kmalloc, and could probably be made even less costly if
> vmalloc() didn't use global spinlocks to protect it's structures.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, thanks for all the explaining.  I will try out your set with mine, 
and do a few perfs myself.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_log_cil.c | 46 +++++++++++++++++++++++++++++++++-----------
>   1 file changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index fff68aad254e..81ebf03bfa5c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -185,6 +185,39 @@ xlog_cil_iovec_space(
>   			sizeof(uint64_t));
>   }
>   
> +/*
> + * shadow buffers can be large, so we need to use kvmalloc() here to ensure
> + * success. Unfortunately, kvmalloc() only allows GFP_KERNEL contexts to fall
> + * back to vmalloc, so we can't actually do anything useful with gfp flags to
> + * control the kmalloc() behaviour within kvmalloc(). Hence kmalloc() will do
> + * direct reclaim and compaction in the slow path, both of which are
> + * horrendously expensive. We just want kmalloc to fail fast and fall back to
> + * vmalloc if it can't get somethign straight away from the free lists or buddy
> + * allocator. Hence we have to open code kvmalloc outselves here.
> + *
> + * Also, we are in memalloc_nofs_save task context here, so despite the use of
> + * GFP_KERNEL here, we are actually going to be doing GFP_NOFS allocations. This
> + * is actually the only way to make vmalloc() do GFP_NOFS allocations, so lets
> + * just all pretend this is a GFP_KERNEL context operation....
> + */
> +static inline void *
> +xlog_cil_kvmalloc(
> +	size_t		size)
> +{
> +	gfp_t		flags = GFP_KERNEL;
> +	void		*p;
> +
> +	flags &= ~__GFP_DIRECT_RECLAIM;
> +	flags |= __GFP_NOWARN | __GFP_NORETRY;
> +	do {
> +		p = kmalloc(buf_size, flags);
> +		if (!p)
> +			p = vmalloc(buf_size);
> +	} while (!p);
> +
> +	return p;
> +}
> +
>   /*
>    * Allocate or pin log vector buffers for CIL insertion.
>    *
> @@ -293,25 +326,16 @@ xlog_cil_alloc_shadow_bufs(
>   		 */
>   		if (!lip->li_lv_shadow ||
>   		    buf_size > lip->li_lv_shadow->lv_size) {
> -
>   			/*
>   			 * We free and allocate here as a realloc would copy
> -			 * unnecessary data. We don't use kmem_zalloc() for the
> +			 * unnecessary data. We don't use kvzalloc() for the
>   			 * same reason - we don't need to zero the data area in
>   			 * the buffer, only the log vector header and the iovec
>   			 * storage.
>   			 */
>   			kmem_free(lip->li_lv_shadow);
> +			lv = xlog_cil_kvmalloc(buf_size);
>   
> -			/*
> -			 * We are in transaction context, which means this
> -			 * allocation will pick up GFP_NOFS from the
> -			 * memalloc_nofs_save/restore context the transaction
> -			 * holds. This means we can use GFP_KERNEL here so the
> -			 * generic kvmalloc() code will run vmalloc on
> -			 * contiguous page allocation failure as we require.
> -			 */
> -			lv = kvmalloc(buf_size, GFP_KERNEL);
>   			memset(lv, 0, xlog_cil_iovec_space(niovecs));
>   
>   			INIT_LIST_HEAD(&lv->lv_list);
> 
