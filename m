Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF469C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 20:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244752AbiESUeA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 16:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbiESUd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 16:33:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05BF7A81D
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 13:33:57 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JJxE4S029203;
        Thu, 19 May 2022 20:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3zAJjDdm50PGntfnqGyI+awLxoTB41EcHanzTC20GIo=;
 b=nTOLLaDIS/PQ7DS4/Mx/03NByXKTmPkh4uu9gdHQpC+9nPZnvRgeEdNzIeLhFSKEkhVM
 cWEzLVJU0FAWzzDjxeIReduW/agqLsnMH93C8eztbecjAdpKYhH6OyUf0VFgfgIIb7ql
 Ux5fSW+r1yTyXTpmL3bwLb+AGD3GyBiI6gB9fRvWXZE6s3rDi9joacto/4x/7865648c
 5AR/PSji9jseRZGW7AZwSC4KxWUsZi8SuTD+Zn91rbhcFm7KvlC6M5YDjhmo3meAsECv
 VrdsPWofRxRnlwjWQTxNRbrKwyP2fNrcDbiA/kIEwSRihzn4yzM+bEBW8vj0HbhudCFu uA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aan2mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 20:33:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24JKFcpb009733;
        Thu, 19 May 2022 20:33:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v5cv02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 20:33:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G42BtrMafDPFKGGVRT6S4WmIza4fGwOSSTI2gCYTxzGcTYhZe2h+IFEKEOxyATowrtYUFA8+siu8vs1xLUSjqrJeYbJuBAmTGfucmbT/wSgRRfI6XnLjoxp7qvxdquZVIoAPBZ6SeaZvIc8gMtdU2OXt2ih5MBbUzNkfbodRrez/yxg9ob18QrAAx7tp8UvT3/7/8R9EPM6tLpLxi6ulbRkcneD3xXPiBVBwyKUBTDE1S/a7PD7uLr0mfT7sdJaCI70kumNeAGuPxundSTAtwJpugF8dD2QJcoNHvNyD2eX4LMqaBrFDqwNFP9Uq/gtmRc7mqzMRFMtdOitkYczUHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zAJjDdm50PGntfnqGyI+awLxoTB41EcHanzTC20GIo=;
 b=hAy116QuJJse3uc/oomDW9TQLJP1yUkV47ncSInZGw9aw1EXjNXOlDlI+u/cYdztSvhAIBK/93D+9tMm2b900dlWB7jRGICY01ZBPle0PnT3T7Mb0uQx4ZMLIzvuon80wmM65cvrRSG38j6lCN7G0aXru28bh5d2oUFpxQ246pb5bxGT8PSIfBW3nrZEzwtvrUbkzPYS32GNU+2uS5thE7QYy4+4Fd3Sf/TtEupIetq3CU6J7fvbCROcNI7rFshMx3gwNXW9WhvFTMV3uFMqBhVaz6TmuEBHWyClTxAqN4tx1Qi4Y9Wsnw5mnnqhnR7wVQzCs9TXQn6GdGwq9Dv+Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zAJjDdm50PGntfnqGyI+awLxoTB41EcHanzTC20GIo=;
 b=a7Rnpkt0X0vGI9+KYAnKpXKwfT7Zz5GpFQUz/qJwX5OUIJdEXH0jLKrJ582DwMusr2fb+/ykEev55Qhw6AJ0mgWrWkKXgsle0GLjXgvgaAbub+5G0DUkySKkFfvPAxVDi5aAv/pN/nS8v/+sgVx+QD9XQgpA+pasCFCogiRgcEc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR1001MB2186.namprd10.prod.outlook.com (2603:10b6:4:35::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 20:33:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 20:33:51 +0000
Message-ID: <68d8edbca688485b2816cb784b2c50e5da6da9d9.camel@oracle.com>
Subject: Re: [PATCH 3/3] xfs: free xfs_attrd_log_items correctly
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 19 May 2022 13:33:50 -0700
In-Reply-To: <165290011952.1646163.16695840263373472236.stgit@magnolia>
References: <165290010248.1646163.12346986876716116665.stgit@magnolia>
         <165290011952.1646163.16695840263373472236.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69547712-11cd-450c-dfa3-08da39d6e288
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2186:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB218642D0DD5A3903388924C595D09@DM5PR1001MB2186.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mEAv86x0kW3b4dkVKSP7lzHbK3G4MSNop3yVYdCYQwUge77SXn/2/0I41xFk3L7rSqPjano6IhVVYCYRmDgNbIta4sLI8PRH4Hm5PLGK3VIDikLWVDBxD5wmBYuGx2fWpnFGdk5Kel0hajDYOfPBCl1e4dCZb1aY2jG/zwcrF5hnIBvQK1gGCS3HGhwYja0XY5sNYRLFkrn9baDlpyfhYwHhwCZB5N+rQbv/78axmbToIJ3xXg1isfbh6LZRRGxb8eOAJNi8EOGHfzhSTxg6ufSEsIpirCrWm+5VfOPW11NO1OE42/qnehrQ/q8Rwh18wwTJZ0bIRPkKrkmtxqCCrk3PKL7KsZ0ysGFrzzAslmg+JGG8Cjxvxp7to9JelVyNmm64iLdR+0q8zau6wpuXN6DIjdlYU4mSYU5lGbktqJniuepcM4Ww8GtpZX4nRN+1HZJTVnjiSm9FpjpzWRs4jcpgF6Iq5MiPA06qGnGYpR5bxGCar64Hjcx7PBZ1fH9r9fCQ85TFJjpRH4F7Sw5+APs9Or/51ZzBAaiEEgFu4w9T+09IQRt6N1bGxzxgTE6V7dBhr185UXtMOHklOqAgGRC4eYLB/PXcqLrDFh0IS9NRyj4ybsIYswlUBd7wH9Vrmmu7DEXmPw7Vj9tOAFjj+49rp7sZ651vVtGHxuPQCyx+I/Llj96pdFWpRvmDifJaPTZ+HgxmzKo+/4/y0eIa4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(52116002)(66556008)(6486002)(86362001)(6506007)(6512007)(186003)(26005)(4326008)(83380400001)(316002)(8936002)(5660300002)(38350700002)(38100700002)(4744005)(36756003)(6916009)(8676002)(2906002)(66946007)(2616005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzVyZmFhTlBzSnpjMkdhSlE2Ym1ZRW5mV1NXRzlCMmZhd1RzaExIUGVUQ3pE?=
 =?utf-8?B?YWxKYzdBY2ozV05sRWxsUWxaTk9PSnpnY3RtNmkwZjhMZXI5ZjM1ZGtud0U2?=
 =?utf-8?B?Yjl4MTFQamFLZFlBQWt0aWNpWllVekdudGtZazhkZDA3WkhnYkNCYTcvZTlB?=
 =?utf-8?B?bjZhUjNuOU9kR3hGQ3FEZVFSMUxoQUkwZ1poQVh1UGRJUVJ3Y1l5YjNZVXhj?=
 =?utf-8?B?QmZ5eFYrTjBIT09mLzFCM0M4dDFkeTB6STN4cktxbHVHRHFZd1N0cXRtemxI?=
 =?utf-8?B?d3hFank1dGRPNlFFTmpXYnpHZTBLcXE5WkpDY0NDc0E3SnAva05hRVFXL2Vn?=
 =?utf-8?B?MjJJOVIvN1NPY3RPUkpXYW9iNHcxTWJLd1RvZHdQUHkzdmp1eDBhMzlKejZH?=
 =?utf-8?B?a1BYR21JWFRsN2I4dThMTmp0VDMxd0V4M00wUUk3L2s0aDQ2Uzd3ZG03QWV3?=
 =?utf-8?B?ZWxsWTlPdEFjMmU1d2xjbXBocktzbU1MUkhtbHF2eWozUFhHckRRcjFITCtw?=
 =?utf-8?B?dHlQRWg2VTlxZ0dHdEJhYWJSVWZsQStpc29jRVRTOHJEK0tBYTJWZ3FJZ0dj?=
 =?utf-8?B?cG40RXZrWDJKcUhuRk5Gcy9vbE5kYkxjN3BQTTZ1bktPMFo3TTBmM2RWNjZL?=
 =?utf-8?B?c2hpc3JEZ2tJSHNkVGY3Y2lhUWtnN1lETDNsSkl5ZU40MzY1L3UySHlLd3ky?=
 =?utf-8?B?MSs3SUQwcHg5MWFSTGdadDVSckNjVjZlYTVZYXJnN0R2N2VjY2tvcHc0ak8w?=
 =?utf-8?B?Y05mQitlOWk4bmhRT1dHdUJYbWg3eS9ZMmo0dzB2QmVDSDNza05kQVYzTW94?=
 =?utf-8?B?K1RjKzlhUWxodXFJSjhRMEc5cldRZXJ5dGsyQmMxSHdmNnVaeGcyc3NkZzVC?=
 =?utf-8?B?a2p1bzNLTkM3UldvZGt2bFkvRnRsSm1yTjVwbHJiYitpdm5CdG8rRWQwbTRZ?=
 =?utf-8?B?ZGlSM3F4NEx5dFhmVmlWZXRURmdQZmVQZUtWMzNyKytMdnFRZnA3OVBpYTYw?=
 =?utf-8?B?WUljbnBqQVhaSHBiZVNhYk9OQkhzTUd0aTRZQlJxNm1lTFEveFVzOU9CR2Vk?=
 =?utf-8?B?UWJ6eVFtNXl6TlBPU05CVE5ya0xMREJtcytRQ1JGUnZSY0poUnA5ZERYMU9S?=
 =?utf-8?B?VXFrQS9SSkg3UmJxQTREOWJnVnZOWWtFT1VoemwrSEtnWVFYSllUOEY0UjVm?=
 =?utf-8?B?b0N3enZ4ZUdsT0NiaHB0azZvN0lxNk0xNzQ0U2dtVUxGSjY2MFJTUkJ4Qy9O?=
 =?utf-8?B?WmI2UTJMVWR1eUZxS1cyMVpuWmkveGJudFN6QW04eHRVOCtVOTNhbkZrcElW?=
 =?utf-8?B?VXkrS0NoNXA4ZnFzUktzWXMxRTB0cklHUjE2RnBUcFZzSk9VajNTb01Nc25O?=
 =?utf-8?B?Q0RTbUdMMlVvcWllckpLL0xKZlNNS2tIcG9CRXhXZ3NoMGRsQytFY0NZVWVD?=
 =?utf-8?B?UlpSbWxnRlk5ZFR2TlVDb0Q4TTV4c0s5cDlEWWVmdFNLckFxcTh0Zyt4aXc5?=
 =?utf-8?B?ZzNVYmxwWTF1YlJndFFQU2FHUTd4VWtTa2ZseTdOTlgwZ3pZc3duQUg5bXZF?=
 =?utf-8?B?UGF0V1hoWTVPTjRCR0VHYlRhNjhuWUdPeU9NVnBqbk9EN0xqei9KdVhrYSt2?=
 =?utf-8?B?Z3JFTVZZR3lrSlJPVWJCQzhHWndZRytOOW1zWTJMOVE4TDlhQXRiQmJMUGNt?=
 =?utf-8?B?eWRrcFQrSzZBaWJML3lUdWZxeGQvL3lNSGtQcmVoS0hCWnhTaGMzMUFDdHlU?=
 =?utf-8?B?NkVhUEQ4Mnl6TElmUk9qK1YvU2UvVHlxb2xQTWtwMWtueGhMKzMyMzJKUHps?=
 =?utf-8?B?Wk5kemVtazJDT3ArSTZ2QlZXVDlWMUFjckk3a0Z3dVppZmlEaHRtNU1YL3pv?=
 =?utf-8?B?OHZ6WjM3U0F0WndCL2p1LzUxRjVwS1NZNDZyYXZGUCs0SlI4MkpOMytrTjZO?=
 =?utf-8?B?aTgwTDNSTFFUN0xzaFRNRUZadzB3bHJOMTk2cXJQbEt0WlJFYTVYZjh5c3pq?=
 =?utf-8?B?eGxGeG95amR3NGdSTjQ5SjlDbEVTbEJvMG1wanpEdFJabnV2dmtuR1RZVXpQ?=
 =?utf-8?B?S3E4aG0xQytRZEU1UUJ3Um9CQnJCamQwSUx1aEFTbFNVbnZFd0xWd0tiTTJR?=
 =?utf-8?B?RS85OVBVZE4wdTBGeVdreTUzVWdSa1lGWnlWQ0F4RnArdTI5NUIxSjdtOFB4?=
 =?utf-8?B?Z1ZJNXJQWXovWlhmbU42NHVzUGh3RW9WdjZVZ0R6VTA5clQzRm1HQkwwY25S?=
 =?utf-8?B?bHJ5RTJmVDZERzVCTHUyRTlJZHlodittRTFOejZSYTFFc1BxSU02bFczTGdl?=
 =?utf-8?B?MXdlWXdrbWZjK21Qc3BBajd5dlpUczNweU5JbHNBZTVDY1hCMVNwNlRSZ2Zi?=
 =?utf-8?Q?y1N28WRcAFXUD90M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69547712-11cd-450c-dfa3-08da39d6e288
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 20:33:51.4782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsWrZPJJ+yATAaGYuD+o3pa0YWjZO0VTr0jMoH01HQ/vWK/C3Ex3eI2O/5xDHTmQlymkgWcs0v7cRELxsHJ3HRPpcFE3AJ69KX4la0icU20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2186
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_06:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190112
X-Proofpoint-ORIG-GUID: s5hixz9gLqoj4KjvXEV_2TZgpDDc4FLf
X-Proofpoint-GUID: s5hixz9gLqoj4KjvXEV_2TZgpDDc4FLf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-18 at 11:55 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Technically speaking, objects allocated out of a specific slab cache
> are
> supposed to be freed to that slab cache.  The popular slab backends
> will
> take care of this for us, but SLOB famously doesn't.  Fix this, even
> if
> slob + xfs are not that common of a combination.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks fine:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_attr_item.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 7d4469e8a4fc..9ef2c2455921 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -290,7 +290,7 @@ STATIC void
>  xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
>  {
>  	kmem_free(attrdp->attrd_item.li_lv_shadow);
> -	kmem_free(attrdp);
> +	kmem_cache_free(xfs_attrd_cache, attrdp);
>  }
>  
>  STATIC void
> 

