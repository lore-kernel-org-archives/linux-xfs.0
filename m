Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19920C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 May 2022 22:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiEQWTe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 18:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiEQWTd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 18:19:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926AE3C719
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 15:19:31 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKb0kP008004;
        Tue, 17 May 2022 22:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=86BvB/l76EGXlm3PcH5bsaNkFKYs6aEsFyFqpMEEW0g=;
 b=oWyOgfhZJkibNHSLHrhGbOTy9p6HMc7RrKQi8OxvFiEJq1ncgpNvhZubnHLuiqR2JTLB
 EI+0gfWTPLk977eV2RmB0xzoiwKgvkpg+QnGDiN3edpQW4L0RLBrQYyuIgOWbEb/L3cG
 1ihlJd1Npx6R3YFePRiq8nUYPLw4Lq/2kL8KlyM50Y/m09kMthn/jCNBfXXA31CiDnzZ
 hmgT4Z8ADiwj29IHqUvsIWsIhtcvgkRXiy1a6YYKWoKVtxdYADo8rZEmzMbFjwgjqnBq
 Iozc0ESENTlsMx8wviJA7Kdd0Y9snRl/q7rbOy6c8fz+GPCy8Hilop5fkn0C5RTnwLvO Bg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc7fgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:19:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMBWbi032150;
        Tue, 17 May 2022 22:19:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3bvr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:19:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnHz2VDwQsry2rWIlwC8V7Br/GJRnaNk8l1/0ZIR4vUQC2wlqtanKESA/kzFzhIl03RnI9IfFRe+w+bveOn52YD3lMwye40uILA3c9UrqKHGDhRrbHM6hxaYBaFY+LNwYqUK7kSnTT5ur2qc6iUXGnFSswAxkto8ZmtqBxhcJw09V8sPI/VjWeOvnzYe0eiRWpL63EZ7yWrIShaPuQxiVLE/xiboxPVTm2hJfHmHXftweOrM92sYKal5BgTgsBI2m3oxevCVJsFPdXZxdwEUF0GH0iUF2XtWzXpY1CyR+sWlkllHg8xxQVii0OKNdkTxaNoctgp3uKo/qKotjUA+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86BvB/l76EGXlm3PcH5bsaNkFKYs6aEsFyFqpMEEW0g=;
 b=Y+rzS90B0lmASe4Zw5YyQN5fDQKxPs+TZ7G0Q3FnEr+KjxVIacri1c+937UZTHVvehFu5zMg8ZcW5IG3awf+3l1GbhBappXjz9QxtKpObT1BDUNVoMjxMG+mG7t+rthrNNxR2EOSuVnKOTrPmTadpkCTJtGmwgU8Zqvn+yo1WMFTdHIDZHY+fKt8BJtAcl1AJLWlVJFIh8TJoUdCRY0ptacGa3ce/Lfr9C9TTZ7Kz5YdwkBmmVJruw3pmGEH4qXekdwCj+gFrFv4/TWI0bLiKU5U8w/gjnXTkDpHJiSs1fgWfDcYYZCiT6hN/zwsAx1hW715/qYW/8aJtb03di7/oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86BvB/l76EGXlm3PcH5bsaNkFKYs6aEsFyFqpMEEW0g=;
 b=SwhYkXSWwuHoaAA/4AHwCtgwLqAcpQYzsmWArf8YL9aew32dBOWOOAazHnh4yJdZF6APcbWU2DRNYqpZnhXYhcfvLyWptNdvjYl2E4FyO/kHMLFZN/78Cm5ri53sDKaR4OM4O8wMtqr4IvhINJwQ5Wx7T4YU7iGfzUw86pCIby8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MN2PR10MB4096.namprd10.prod.outlook.com (2603:10b6:208:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 22:19:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Tue, 17 May 2022
 22:19:17 +0000
Message-ID: <7d2cebff2cbdfad84817b175ea7ba9e4e515110e.camel@oracle.com>
Subject: Re: [PATCH 6/6] xfs: rename struct xfs_attr_item to xfs_attr_intent
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 17 May 2022 15:19:15 -0700
In-Reply-To: <165267197212.626272.17091983335534894941.stgit@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
         <165267197212.626272.17091983335534894941.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:510:f::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73fa89d0-ac2b-40a8-4b13-08da38534835
X-MS-TrafficTypeDiagnostic: MN2PR10MB4096:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB409652930C7332793A71D68895CE9@MN2PR10MB4096.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d8pM43V/vbMxPkUNeh1OcUEFbtO4m8gZy3D3RDHeU7XLQhwyhlSGPJvk61T0nW/xmyR67gUOacFKeKHqi1Y6AM0bQ/FxS/41yHJ599cjLS4OIpcLsQJQy6NZBHkr5sEDvMohS9fk78ClYoDiXdMhY6rk3BJxYo7mbkiLQaLKfGG2i0RPo8jd5KifKi9ioJzPoZYmO+6pyY1gNOmNk3dOY9wpStPXrIiom15BkzSrUbRUO35fIOcq/96MTR7MKJnRaAJLw1m7/0XaxGsVwRL0fPzGtPkq5mrIyIyFVBQsTDFRSTPvp8h7fcBgKDVY2rPB79qQtf3qipE0wTUVo+KtOhSisSjFgrIM5qvjOyuK7ZhFhhNEeRRWsXdsedt/ilWJMEVihRf/Gz77MLwtNm7xt15D37ox/BwPwhSpbLRvno/E6vt2nS2yGsX8vEXzq6/wpkW1YYGeUDwjTjVala4eFVicWcrlsNd0fn6ZDOrg6d+fsg2tP3VhHG/q7MfPiozIIP4UY2gqBSm5om0GWTC79xefKYxDmXcM3CTY5v01NHV73wUntCbaZegnCgUzzGhJHjI5554Bb9IEQRFAy79KHdv1sRzLjPT8joakICmUm7jLPsTDMgdCR1PGAXceDxkmZR3GYCjIMOAJ/LTKCFa6SV/d4lrJSX0Z7JD0FvLtKq8K0jPtSaSEQhGsB+3xj72LnAun0gegJXpumpfBnEz/5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6512007)(6486002)(83380400001)(30864003)(6506007)(52116002)(38100700002)(26005)(8936002)(316002)(86362001)(38350700002)(36756003)(4326008)(2906002)(8676002)(2616005)(66476007)(66946007)(66556008)(5660300002)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFYvMXU4RzRaK2xoVHp5b3BCZENMaEdwK0d0ZHRKUjIzT2dLZzRBR2dXbHFy?=
 =?utf-8?B?UGExRGRPemd3bUJvanBXTm1tRUQvUlcrVFVkL2JoaGRNdDF5QXQ3aDU0RGll?=
 =?utf-8?B?bldpdi9pT1R4VUFnaUw2eHRZaE9NbERlRFJnT1ZUeXhXdWJ1N1h5ZUIyVkFx?=
 =?utf-8?B?YkhOeU1pOGl5Q0VMRUgzelFXQSs0VHV5bzNZNFVUR0VReG5DU3pXV1VRdmVM?=
 =?utf-8?B?Zk9EMWFCUktJUEN1cU1OcnE3ZUtyeEJoZ254MHM2cW5aRElDbkhDOEZEOGhs?=
 =?utf-8?B?L2d0QjE0bDhwZDV6dDZZUFFGWW1INUdOaG41bTE1dExhVFJObG5ha2FGTkNm?=
 =?utf-8?B?dms0am0vbEZnUG5va0Fybk9jVlFuLzZXMHAyWlJwVkp6ZEZRRkVWSk1VMTVp?=
 =?utf-8?B?RGtsYkdKRTFIVzRtVEhQeGJXb0ljR3NlTDQvNzN6aTN0SWZLL1BPN21wSjR6?=
 =?utf-8?B?eU9XeUN1RGViSDlQV0RzN0hJSXgxK0QxYnFYOCtTY29qSyt3T0FaQ2hNNHI1?=
 =?utf-8?B?WWxUeEx4bEFqbnhGZUpkVm9MdXdZendEU2xsc3dQYVVndnF3M010TUlDOVhD?=
 =?utf-8?B?MjZjOFhhb09INEdjTXVrVnlEcjRHTFZ1bHpkOCtOTVdPaFdLQmx4YkRlQzFs?=
 =?utf-8?B?d01lV2pGdnoySDR6dEJTRDZYYVJWTzltZmZML3ByVmNDbmdoQUhuRHVxNWFB?=
 =?utf-8?B?UFpUMmtoaXhSZjZaSTA2bnk0Y2xGOHFzVUVrUEhQUEg0V0lYbUg2MzBpYWlj?=
 =?utf-8?B?ZnEzVzlrbStlRlIzR1FMWnNWT1VsYlJka2FpRURCUlhOakNtOHVKVkZ0S0NU?=
 =?utf-8?B?TmJxaU1WN1RtTEgwWm1WbUVyYXFyQjMzK3UzVjFMekdocmpkdUtUZmd5MEVF?=
 =?utf-8?B?SlFBMFp0REVjUjhVMU1CbzQwV1hpc3YxWlJIeGc5L1pnTEtneTU0Vm8weWFS?=
 =?utf-8?B?K3lzR2J4UGttaFkycXlhTVRCWVJzRGE4SWY1enZiVkFPNmNjZE45ZlJjWGJL?=
 =?utf-8?B?QWV5YThDVG9Ed3hsbWhxWmpBNExKTzVCQUdCcVo0L3B2N3RMR0F3bUNEejAy?=
 =?utf-8?B?azJGcHBtV2FBYjhITXFkd3hCZVIrdGVMbU9QWCtPRGJ5d3F6U1ROenpuZ3Vl?=
 =?utf-8?B?WjhpckJ0aEdsdFR1Y3VXVU5iWGt5dS9PdUgxTHdVN3JuZ3BkY1RRV0lXOTNV?=
 =?utf-8?B?MnRITE5sM3VES3QrK0F3NWNOYWlPbjl2ejU5NWRESVhUakpoeFVuVzJuOW1B?=
 =?utf-8?B?RElyc29tai80WDM0S3VYVHNuWjVzNmE3U3ZvWk9MTkprSGJ5dkkreWF3bEta?=
 =?utf-8?B?N3pXeWdTY2NDdXd5ZGRPZjNhakYxcXIzK1RHOXljb05mcmJtUnF6bXpiZm5p?=
 =?utf-8?B?K0RRaWY5dkgyeElTejNER2V2ZTBWd0pDYzA1WnRiT3JoMmVTQm9TckE2S1lM?=
 =?utf-8?B?REdzZ3ZRcGJPalY5YjdiOGpPTDJnQ3Vyem5BL0E1aXNidWxwN2tyb1ROemIw?=
 =?utf-8?B?RGNjRS9KRXloTXY2cHhTZlBseUs3TnBxTUZNWENhQUxzS0gvYkxhWklNYlQw?=
 =?utf-8?B?T0taZlRoWUh6TWprdWFiVFdCV2JzZm9TWVpwZitnN3lMY01sUEI3b2x1ZFNX?=
 =?utf-8?B?aS92VEVZSDRRUHYvaG5zNkdXZ0UwOHArSDBlelljeDY0UEFoVzQ2RlUxNytX?=
 =?utf-8?B?S1F3OTA0ckxUNFN4NWZDLzFFNUtKUjV3NDB2L0cvMUhsT3docXVEUU55bTAx?=
 =?utf-8?B?Yi9IdXo0MUQ3STRVN3R1TGJqcEUxNDIxRlhDRDYwb2xpTzJtenJDV0hOOFVx?=
 =?utf-8?B?Q0s5bnNESm9tMk8wSXdtZEdPZWYwbUxmZ0N4VllBSVdIeGdISVF2eGtWV0xG?=
 =?utf-8?B?VGVraE5SU2xRYkwzdkpNb0pUQ2p2RUR6NDl2Ky9acExReEprVlRPc3hrSnpP?=
 =?utf-8?B?c0xrWVlMalJ2ekdsQ0w2eC9mMHpzL2hlRVFKZVF3aERVanR1c3hhNG53eHov?=
 =?utf-8?B?eisrRFArUDdKQkhzOVYzenhsRjRpYktQYUZHMm9wUEx5Vi9Ob09uUDZVMW51?=
 =?utf-8?B?SDVnKzBnL2ZwQ2dRUDlvbklxNXVUZExFSXhjYzJKUHRrYVc3dkVkWEhxV2RK?=
 =?utf-8?B?N3lTbTBHNnRXMk1PN2JrV3pObmRray82aTRZZHkzeENScXpkR3MyWWNFR01P?=
 =?utf-8?B?a0trNkxPYnViL1BmOFdSdHpLRUJaSWZUMDFyYTZyMGlTMWlJUWVZdUxjQWUr?=
 =?utf-8?B?VDF2MXpGejg3c21ENUYrQXJOaFRZRHZqOWw5aGVKdG1hOUlYOHg4NFgxUmFl?=
 =?utf-8?B?UW12MDBpSE9hU1c3MkNialV3TjlnVGI0S2crdExhV0RTYlF1bktjWjBlM241?=
 =?utf-8?Q?cLBuF6W2g2D6TS74=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73fa89d0-ac2b-40a8-4b13-08da38534835
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:19:17.2645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glBq7bgnjjSwY7NIvXLDdafS5QOVnGgZUaB9hSwJnQ1Q+4cRXU0FYot93EFX+w4g77obBF+Ysyn+9SwXOJoh4LsNebUn2vmsHVbD4dPQKXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4096
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170128
X-Proofpoint-GUID: 56sUqN8macVCmzNFqrKRjgD42v-yd1kg
X-Proofpoint-ORIG-GUID: 56sUqN8macVCmzNFqrKRjgD42v-yd1kg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Everywhere else in XFS, structures that capture the state of an
> ongoing
> deferred work item all have names that end with "_intent".  The new
> extended attribute deferred work items are not named as such, so fix
> it
> to follow the naming convention used elsewhere.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, looks fine
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c        |   52 ++++++++++++++++++++---------
> ----------
>  fs/xfs/libxfs/xfs_attr.h        |    8 +++---
>  fs/xfs/libxfs/xfs_attr_remote.c |    6 ++---
>  fs/xfs/libxfs/xfs_attr_remote.h |    6 ++---
>  fs/xfs/xfs_attr_item.c          |   28 +++++++++++----------
>  fs/xfs/xfs_attr_item.h          |    6 ++---
>  6 files changed, 53 insertions(+), 53 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4056edf9f06e..427cc07d412e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -57,9 +57,9 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args
> *args, struct xfs_buf *bp);
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
> -static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
> -STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item
> *attr);
> -STATIC int xfs_attr_node_remove_attr(struct xfs_attr_item *attr);
> +static int xfs_attr_node_try_addname(struct xfs_attr_intent *attr);
> +STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_intent
> *attr);
> +STATIC int xfs_attr_node_remove_attr(struct xfs_attr_intent *attr);
>  STATIC int xfs_attr_node_lookup(struct xfs_da_args *args,
>  		struct xfs_da_state *state);
>  
> @@ -376,7 +376,7 @@ xfs_attr_try_sf_addname(
>  
>  static int
>  xfs_attr_sf_addname(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_inode		*dp = args->dp;
> @@ -422,7 +422,7 @@ xfs_attr_sf_addname(
>   */
>  static enum xfs_delattr_state
>  xfs_attr_complete_op(
> -	struct xfs_attr_item	*attr,
> +	struct xfs_attr_intent	*attr,
>  	enum xfs_delattr_state	replace_state)
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
> @@ -438,7 +438,7 @@ xfs_attr_complete_op(
>  
>  static int
>  xfs_attr_leaf_addname(
> -	struct xfs_attr_item	*attr)
> +	struct xfs_attr_intent	*attr)
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
>  	int			error;
> @@ -492,7 +492,7 @@ xfs_attr_leaf_addname(
>   */
>  static int
>  xfs_attr_node_addname(
> -	struct xfs_attr_item	*attr)
> +	struct xfs_attr_intent	*attr)
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
>  	int			error;
> @@ -529,7 +529,7 @@ xfs_attr_node_addname(
>  
>  static int
>  xfs_attr_rmtval_alloc(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_da_args              *args = attr->xattri_da_args;
>  	int				error = 0;
> @@ -596,7 +596,7 @@ xfs_attr_leaf_mark_incomplete(
>  /* Ensure the da state of an xattr deferred work item is ready to
> go. */
>  static inline void
>  xfs_attr_item_ensure_da_state(
> -	struct xfs_attr_item	*attr)
> +	struct xfs_attr_intent	*attr)
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
>  
> @@ -613,7 +613,7 @@ xfs_attr_item_ensure_da_state(
>   */
>  static
>  int xfs_attr_node_removename_setup(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_da_state		*state;
> @@ -651,7 +651,7 @@ int xfs_attr_node_removename_setup(
>   */
>  static int
>  xfs_attr_leaf_remove_attr(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_da_args              *args = attr->xattri_da_args;
>  	struct xfs_inode		*dp = args->dp;
> @@ -716,7 +716,7 @@ xfs_attr_leaf_shrink(
>   */
>  int
>  xfs_attr_set_iter(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_da_args              *args = attr->xattri_da_args;
>  	int				error = 0;
> @@ -893,13 +893,13 @@ xfs_attr_lookup(
>  }
>  
>  static int
> -xfs_attr_item_init(
> +xfs_attr_intent_init(
>  	struct xfs_da_args	*args,
>  	unsigned int		op_flags,	/* op flag (set or
> remove) */
> -	struct xfs_attr_item	**attr)		/* new xfs_attr_item
> */
> +	struct xfs_attr_intent	**attr)		/* new
> xfs_attr_intent */
>  {
>  
> -	struct xfs_attr_item	*new;
> +	struct xfs_attr_intent	*new;
>  
>  	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS |
> __GFP_NOFAIL);
>  	new->xattri_op_flags = op_flags;
> @@ -914,10 +914,10 @@ static int
>  xfs_attr_defer_add(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_attr_item	*new;
> +	struct xfs_attr_intent	*new;
>  	int			error = 0;
>  
> -	error = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
> +	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET,
> &new);
>  	if (error)
>  		return error;
>  
> @@ -933,10 +933,10 @@ static int
>  xfs_attr_defer_replace(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_attr_item	*new;
> +	struct xfs_attr_intent	*new;
>  	int			error = 0;
>  
> -	error = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_REPLACE,
> &new);
> +	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE,
> &new);
>  	if (error)
>  		return error;
>  
> @@ -953,10 +953,10 @@ xfs_attr_defer_remove(
>  	struct xfs_da_args	*args)
>  {
>  
> -	struct xfs_attr_item	*new;
> +	struct xfs_attr_intent	*new;
>  	int			error;
>  
> -	error  = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_REMOVE,
> &new);
> +	error  = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REMOVE,
> &new);
>  	if (error)
>  		return error;
>  
> @@ -1394,7 +1394,7 @@ xfs_attr_node_lookup(
>  
>  STATIC int
>  xfs_attr_node_addname_find_attr(
> -	 struct xfs_attr_item	*attr)
> +	 struct xfs_attr_intent	*attr)
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
>  	int			error;
> @@ -1447,7 +1447,7 @@ xfs_attr_node_addname_find_attr(
>   */
>  static int
>  xfs_attr_node_try_addname(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_da_state		*state = attr-
> >xattri_da_state;
> @@ -1513,7 +1513,7 @@ xfs_attr_node_removename(
>  
>  static int
>  xfs_attr_node_remove_attr(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_da_state		*state = NULL;
> @@ -1619,8 +1619,8 @@ xfs_attr_namecheck(
>  int __init
>  xfs_attr_intent_init_cache(void)
>  {
> -	xfs_attr_intent_cache = kmem_cache_create("xfs_attr_item",
> -			sizeof(struct xfs_attr_item),
> +	xfs_attr_intent_cache = kmem_cache_create("xfs_attr_intent",
> +			sizeof(struct xfs_attr_intent),
>  			0, 0, NULL);
>  
>  	return xfs_attr_intent_cache != NULL ? 0 : -ENOMEM;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 22a2f288c1c0..b88b6d74e4fc 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -434,7 +434,7 @@ struct xfs_attr_list_context {
>   */
>  
>  /*
> - * Enum values for xfs_attr_item.xattri_da_state
> + * Enum values for xfs_attr_intent.xattri_da_state
>   *
>   * These values are used by delayed attribute operations to keep
> track  of where
>   * they were before they returned -EAGAIN.  A return code of -EAGAIN
> signals the
> @@ -504,7 +504,7 @@ enum xfs_delattr_state {
>  /*
>   * Context used for keeping track of delayed attribute operations
>   */
> -struct xfs_attr_item {
> +struct xfs_attr_intent {
>  	/*
>  	 * used to log this item to an intent containing a list of
> attrs to
>  	 * commit later
> @@ -551,8 +551,8 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
> -int xfs_attr_set_iter(struct xfs_attr_item *attr);
> -int xfs_attr_remove_iter(struct xfs_attr_item *attr);
> +int xfs_attr_set_iter(struct xfs_attr_intent *attr);
> +int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
>  bool xfs_attr_namecheck(const void *name, size_t length);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>  void xfs_init_attr_trans(struct xfs_da_args *args, struct
> xfs_trans_res *tres,
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c
> b/fs/xfs/libxfs/xfs_attr_remote.c
> index 4250159ecced..7298c148f848 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -568,7 +568,7 @@ xfs_attr_rmtval_stale(
>   */
>  int
>  xfs_attr_rmtval_find_space(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_bmbt_irec		*map = &attr->xattri_map;
> @@ -598,7 +598,7 @@ xfs_attr_rmtval_find_space(
>   */
>  int
>  xfs_attr_rmtval_set_blk(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_inode		*dp = args->dp;
> @@ -674,7 +674,7 @@ xfs_attr_rmtval_invalidate(
>   */
>  int
>  xfs_attr_rmtval_remove(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
>  	int				error, done;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h
> b/fs/xfs/libxfs/xfs_attr_remote.h
> index 62b398edec3f..d097ec6c4dc3 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -12,9 +12,9 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec
> *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> -int xfs_attr_rmtval_remove(struct xfs_attr_item *attr);
> +int xfs_attr_rmtval_remove(struct xfs_attr_intent *attr);
>  int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
> -int xfs_attr_rmtval_set_blk(struct xfs_attr_item *attr);
> -int xfs_attr_rmtval_find_space(struct xfs_attr_item *attr);
> +int xfs_attr_rmtval_set_blk(struct xfs_attr_intent *attr);
> +int xfs_attr_rmtval_find_space(struct xfs_attr_intent *attr);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 1747127434b8..fb84f71388c4 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -300,7 +300,7 @@ xfs_attrd_item_intent(
>   */
>  STATIC int
>  xfs_xattri_finish_update(
> -	struct xfs_attr_item		*attr,
> +	struct xfs_attr_intent		*attr,
>  	struct xfs_attrd_log_item	*attrdp)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> @@ -338,7 +338,7 @@ STATIC void
>  xfs_attr_log_item(
>  	struct xfs_trans		*tp,
>  	struct xfs_attri_log_item	*attrip,
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	struct xfs_attri_log_format	*attrp;
>  
> @@ -346,9 +346,9 @@ xfs_attr_log_item(
>  	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
>  
>  	/*
> -	 * At this point the xfs_attr_item has been constructed, and
> we've
> +	 * At this point the xfs_attr_intent has been constructed, and
> we've
>  	 * created the log intent. Fill in the attri log item and log
> format
> -	 * structure with fields from this xfs_attr_item
> +	 * structure with fields from this xfs_attr_intent
>  	 */
>  	attrp = &attrip->attri_format;
>  	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
> @@ -377,7 +377,7 @@ xfs_attr_create_intent(
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_attri_log_item	*attrip;
> -	struct xfs_attr_item		*attr;
> +	struct xfs_attr_intent		*attr;
>  
>  	ASSERT(count == 1);
>  
> @@ -403,7 +403,7 @@ xfs_attr_create_intent(
>  
>  static inline void
>  xfs_attr_free_item(
> -	struct xfs_attr_item		*attr)
> +	struct xfs_attr_intent		*attr)
>  {
>  	if (attr->xattri_da_state)
>  		xfs_da_state_free(attr->xattri_da_state);
> @@ -421,11 +421,11 @@ xfs_attr_finish_item(
>  	struct list_head		*item,
>  	struct xfs_btree_cur		**state)
>  {
> -	struct xfs_attr_item		*attr;
> +	struct xfs_attr_intent		*attr;
>  	struct xfs_attrd_log_item	*done_item = NULL;
>  	int				error;
>  
> -	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	attr = container_of(item, struct xfs_attr_intent, xattri_list);
>  	if (done)
>  		done_item = ATTRD_ITEM(done);
>  
> @@ -455,9 +455,9 @@ STATIC void
>  xfs_attr_cancel_item(
>  	struct list_head		*item)
>  {
> -	struct xfs_attr_item		*attr;
> +	struct xfs_attr_intent		*attr;
>  
> -	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	attr = container_of(item, struct xfs_attr_intent, xattri_list);
>  	xfs_attr_free_item(attr);
>  }
>  
> @@ -469,10 +469,10 @@ xfs_attri_item_committed(
>  	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>  
>  	/*
> -	 * The attrip refers to xfs_attr_item memory to log the name
> and value
> +	 * The attrip refers to xfs_attr_intent memory to log the name
> and value
>  	 * with the intent item. This already occurred when the intent
> was
>  	 * committed so these fields are no longer accessed. Clear them
> out of
> -	 * caution since we're about to free the xfs_attr_item.
> +	 * caution since we're about to free the xfs_attr_intent.
>  	 */
>  	attrip->attri_name = NULL;
>  	attrip->attri_value = NULL;
> @@ -540,7 +540,7 @@ xfs_attri_item_recover(
>  	struct list_head		*capture_list)
>  {
>  	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> -	struct xfs_attr_item		*attr;
> +	struct xfs_attr_intent		*attr;
>  	struct xfs_mount		*mp = lip->li_log->l_mp;
>  	struct xfs_inode		*ip;
>  	struct xfs_da_args		*args;
> @@ -565,7 +565,7 @@ xfs_attri_item_recover(
>  	if (error)
>  		return error;
>  
> -	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
> +	attr = kmem_zalloc(sizeof(struct xfs_attr_intent) +
>  			   sizeof(struct xfs_da_args), KM_NOFS);
>  	args = (struct xfs_da_args *)(attr + 1);
>  
> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> index cc2fbc9d58a7..a40e702e0215 100644
> --- a/fs/xfs/xfs_attr_item.h
> +++ b/fs/xfs/xfs_attr_item.h
> @@ -15,13 +15,13 @@ struct kmem_zone;
>   * This is the "attr intention" log item.  It is used to log the
> fact that some
>   * extended attribute operations need to be processed.  An operation
> is
>   * currently either a set or remove.  Set or remove operations are
> described by
> - * the xfs_attr_item which may be logged to this intent.
> + * the xfs_attr_intent which may be logged to this intent.
>   *
>   * During a normal attr operation, name and value point to the name
> and value
>   * fields of the caller's xfs_da_args structure.  During a recovery,
> the name
>   * and value buffers are copied from the log, and stored in a
> trailing buffer
> - * attached to the xfs_attr_item until they are committed.  They are
> freed when
> - * the xfs_attr_item itself is freed when the work is done.
> + * attached to the xfs_attr_intent until they are committed.  They
> are freed
> + * when the xfs_attr_intent itself is freed when the work is done.
>   */
>  struct xfs_attri_log_item {
>  	struct xfs_log_item		attri_item;
> 

