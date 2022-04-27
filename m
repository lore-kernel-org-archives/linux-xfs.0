Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435C1C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 01:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356672AbiD0BOS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 21:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351689AbiD0BOG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 21:14:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D692CCBB
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 18:10:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QMoHm9032133;
        Wed, 27 Apr 2022 01:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=kU65lD5QeEcNzQG5IPF/NXIwHxzcTpfB0gHzdh/GAtw=;
 b=QqzSMiiVFLZv/InoxQpAsd4cEHdT3RyxKztj6Ao7Lv88g/G8oc/9ZWIbGJWeWLwcrT/H
 9e81xu+Jka7fTRM10E2xUvjgtsOgIxbPY36/mbSUZYpZUl1W8ROedkMWyzFfAVYNwRpT
 rtp6THNY1dbNnaZJRna7rpY3dEUw+w5o4Pe+t/akXCC8JB5vNYCALAka1JtH1gx+wK04
 KKs4rkghdTrt89bdbqxnOOD2IUJk2u2qfrcujfTxj8Rfq8BKkPGoTjm7YG/z9zh37M6i
 Gt61YHbXlA2VOIOTrqAoTDpB1+hFV5gLSWwXjeFnKsN8mNYqvn9yuO4oTN5deimHlzZ/ Jg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb0yycby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 01:10:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23R155pZ033955;
        Wed, 27 Apr 2022 01:10:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w3xdny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 01:10:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSRqnjp0qBIoFSxdJlisO5m7krMQuLhQuOsEmo4D0ooEUgqiXp7wOi/a5YTOlDhcR2RCvl7c657bWy9m7DtiWGjEp+qlT6k9haJu/7HwJsXeEbl/ihZyikap3d1gUDKlpRNhICFwECTR2BsjbIbQ4iRkhG4Naegqku5OfiSP7du4HxozATxoOk+NZW4U6W6nrowCxCXh2MGVl5NAKrgu3tOzJdS93KiIchcCmapJcPLBMdQRL2Nz25tyLTndmUdW6d5fmCzszVRHNymCD3f0Mr7SLXqUA1CUwUXHMs6Wm5fUgSLEFdxXVBxOlHa+uKyFj0MkeAit2dbsTeNHt7i23Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kU65lD5QeEcNzQG5IPF/NXIwHxzcTpfB0gHzdh/GAtw=;
 b=atnzu0kUipCm3uRB9ByxMQknIhgS0BjvUMGusfp4CwP/1atu7LUoyo+JM9TZI85K8qJVewenOq4ywO7uh0eX7fUASD6VEldGBto4Nv/bK/b5MgSe48ksShxqmLCies5Tsd+3WDFj9pY2c1addTnq8ewAiEqgQVy9oz5DoomM3kKde94g2N7i+kZMTKWFafYSTlMuJ76mab9t31BguCSW4wWmlid2XLj87XJgvhOAmGexndtk0foLC2rhOcHaSimicdd0xqVOGjzcXSsWrFSMUzHW4U4fXNG7LcqKoeH/NbNaWhJ6eecm+KG1kzFxDRkPtmJ/lfc1wgSSGORzyTrlvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kU65lD5QeEcNzQG5IPF/NXIwHxzcTpfB0gHzdh/GAtw=;
 b=BXgJzFogV82dt9Sm6t2SWLR/BIQm7gLuJs/CwnE+3tfSBM1Il4GMGOCjBy/juaWFe6GgdlI02FyGsD3PYX6XbrnEJq974nz0NYGTkI8VPvz+KxQJhWGas86DX7ykvg2xyQ1qGPjxk2W8Ua8604P3g6QXgOJBuLIiTqx6/TqNhiY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MN2PR10MB4238.namprd10.prod.outlook.com (2603:10b6:208:1d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Wed, 27 Apr
 2022 01:10:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 01:10:48 +0000
Message-ID: <eda4075a78dc1c1a9a4490a564ca38715b3eaa4c.camel@oracle.com>
Subject: Re: [PATCH 15/16] xfs: split attr replace op setup from create op
 setup
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 18:10:46 -0700
In-Reply-To: <20220414094434.2508781-16-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-16-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b594eaef-e600-47ee-aa24-08da27eac35a
X-MS-TrafficTypeDiagnostic: MN2PR10MB4238:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4238EE21AC426B7B95681D8895FA9@MN2PR10MB4238.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Th9R/UavKIFQHZU6u+0Uf3vynpXczbTFY5yjpHEIRNh+Vt4P/v2IVUDzmXRZr8LbnLAzx7OIl8Pbj80ZCevjryB+58wcJEbKjYEq5vasJRGiZX+cR4nQGOsEq816nCLZiSvojAqOyDHxyCQZJJsDg2CEFPWF4CFdNxzlHpeH/7wNmvnCigjkgtcZ+t78J96pDqjLw1UEqNwvkmlFyVKYKu+kNYM0E7WieRAmtoVDHHvxh8wTd6DykezUi8D4XXVkUI7UjBQZNXbQE/e4ewdFXoM0Zjmr5ShMRXFuX8Hz5f6P5cd39SLR2heEgOfDxknu1/rwTj8SgZqJxqnZZwGl60yXlNE4Nj6YmLNoluUFmz7HeZ3A+NpC5MGzdchgRqdPzwaj2k3eplQF4YYTwOLL9YH+AuUcMQZRdsIMrtIE1Xg4Rbm9Z4Ggg2mXSDFgzl8+yBcIPUO/FBC3TEZDBz0flcZmvkhXFuwzGGufwZEe87HOjq88Zztceda7Ana+5ztniVQrMTO4IJeRyQ1Ogh7GbvpmNzR52JBd1V/9M0YDeNhWuhBNcj2eW2r+widmOreZwzKU5W/vnoPjxoJhJQenr9O91eVblhGrv6xb+Qc6SlvLwngeGsp/Q6woDQGwghccH4d8m20Zeivejbpngnn/PgboHF3YoR9DXGBCn/Les6UPtxpQ0B4mcrhgSXPDwZ/IcYAIg3gIVsuoDAu3dP8n4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66946007)(66556008)(316002)(86362001)(52116002)(5660300002)(8936002)(6506007)(6486002)(26005)(186003)(83380400001)(2616005)(36756003)(508600001)(66476007)(6512007)(38100700002)(38350700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVR5djdlaCtTWmx1WGI3UGhqWXZneGdGM05ZN1RvQ2x3Y1o1OGNRcnd5Y0My?=
 =?utf-8?B?V01LckNxTWs3RWYwYTBTdGI5YklGZDJEdUxISFJicGxBVlQwM2NJVFhQWDRo?=
 =?utf-8?B?TC9YZWxRRXZWajRtbGFJYVJ3WjduSk10ZSsvVUhnQ0lqdklKSmtFdVJONExM?=
 =?utf-8?B?Q3dTTkdIL2EyWHp3V2RiRFgxakdRZDVyKzFCaE5WWnRJRXpFRVNqVkxWQSsw?=
 =?utf-8?B?VldMaWJyRHdKcVdMamplYm92dEx4YktpblFmSVh3dzZLQmQxWlY0d2RXQjJ4?=
 =?utf-8?B?ZFFSQjRYdUQrTHEvZEttTVA3TjVMaGQvMHl0Z2xENVVEL3Rva0xKemJUR1l2?=
 =?utf-8?B?UjhscmZsZ0xXNjhqWCtzRml0NmpGdXhoa09ZTU9YTDBuZnlleDcxTmtncUth?=
 =?utf-8?B?K3JaUytUQWhGYXdwRlB4YllGa1Jjdm5JK1lSZXZzc2lQV1c1bTdVMy9RY25m?=
 =?utf-8?B?WUJRUEZsamdMRGpuWTZyMC9hUjZJUjlNbmtwSW1iNDVzUGtwTEJTNE5XZFQ2?=
 =?utf-8?B?NStlRzNIQUhoeHpzSXp1LzkzTEcvcnlaYmdnMTVmREZ2V2lSY3dibmE0a29S?=
 =?utf-8?B?OHdIRHFBK2luZUlJem5taVdZeUxNZFFvWXZ3akk3TDBRLzlFL0g3ck1TNE1Y?=
 =?utf-8?B?Mi96SlFhbE4wamdTYllWUFJGUXNRRXpsK00vWlZXQTE1emYxclhxYnFmM3dw?=
 =?utf-8?B?cVdTck1yQ05UR0Z1VExmZUZwdEsyVW5MRjhLYm1lQjdUWkd0NEJyL2dKOEYv?=
 =?utf-8?B?SGxERm1EUUdQbUF4T2cwS1l2S2UxeklSM3liNTZhWXA0UDlHK0QvajJmTlZk?=
 =?utf-8?B?c1AwcDA3UEM5dHFFYjdJM2o1R3VXdDl1U3hnWWdzV2RQT1hhVmlSUnpoUjUy?=
 =?utf-8?B?VXpzYzQySlhCYnc3aGswdGtCNzQyUlhMWXVVUU5rTlpYTnZkRFYvL2RHaVRQ?=
 =?utf-8?B?bmp6TC95VmRhRXRmTjE1RENFOXNwU0RWY3EyRHlRaFIyWkZlejlhY01KaW1Q?=
 =?utf-8?B?TnV3eFBSOE8zWUwwRGdTVkY3Q3MrZktEWFdrNUdOa3dCTzJTUDgxaTdOekha?=
 =?utf-8?B?REs5TDM2aUMwb1M0STNiamE2Ri9BbU9kSm1qa2VJbGJXanVOYi9GTFZIMDVC?=
 =?utf-8?B?Tk1jRFdlam1QTXdzRE9abkgwZmwydGpsQ0F1TElZaGNOb2FXc3g3aTcySU0y?=
 =?utf-8?B?VlJ3YUFTcksxaDZudHhOSnpxTk5Dd2h2YUVVQzhTeGFsU0ZCbzQvN3NUTHcy?=
 =?utf-8?B?ZXoxRGlJOW0vR3l5SU04aFdRQjByYzA0ZnR2MjM4SzVDaFQ3Q3VZWXlQd2l1?=
 =?utf-8?B?UHZuS0NtSUpua0JJcGZqY1Ewc09aQTJhbFU0UGdqajk0Z2I0dmx2UWU4ME1z?=
 =?utf-8?B?MkovOXVqT1NLbmhzMFlqQ2ZkMnZQLzlQa0kyLzNXTmpJQ2x2c3lkY3hqMDhQ?=
 =?utf-8?B?VHVhSkpxaWdTNWhIRjJ5VThSdHBId1AzVC80UEdPaWt1aXh0dXcrMmhCZ1Iz?=
 =?utf-8?B?VzV3REJKRVRnTzk2SUN1Z2wzOFF4WDlxakh2WHg2SEtBdCt3VmRyK2hPakcz?=
 =?utf-8?B?WFZ5L0xid1hHTFg5NEEvVXZCbmlqY1MvWUZubXlRaWJtWmJNMU9CSHY1OGdQ?=
 =?utf-8?B?MWNEV2U4RVFvbkRIMFJFQmJEQ2xlYThkOElpMFpMdi9ZYk1LVG9rdGwvMGwy?=
 =?utf-8?B?QnY3cFZpVVQrUXY2WUpKanQ1bDZqRGh2S2xQR1dadk1MbFBMcHNOZGN3R3Ja?=
 =?utf-8?B?SDRDNEF3dW5PNFBmM2VMZFRvYnQrQlA1M21TdzlIVk1RejhsQVpJQkNNdXZJ?=
 =?utf-8?B?N1MzeGo4SWZKRHlMaFVXUlU5YmFXTlRwSHM1VG0yNmU3SzhhSU0xTS9jQnRF?=
 =?utf-8?B?RXlSVC9CYnRCSE9zakNNSGtHYXdSQUxCVzdPR09VSlR5aHVkUHBna0o5dXhT?=
 =?utf-8?B?NTZPSk9lUkVVZENuU2p1U3BpVHR1MVNOMkltREhJZXRWVnRsN0wxSXVJMWts?=
 =?utf-8?B?SDhYQ1dmaUs0OTVZWW54Njl4NzR0K1JYSndIQmx1YzlFSThGYzlVemJsdS9o?=
 =?utf-8?B?SW9TbW5rbGEySFl1RGF3Tmw2aUMwdDJIa3E5UXpGVFN2T29MT2RFSFNKMzNI?=
 =?utf-8?B?L2FKOGZSVnFodWNYaEFaTk9yQVFrQndGYXZQSDhoZ043cmdZSStMeXB6N0ZL?=
 =?utf-8?B?enpmeEdyMUV3RDVHUS9FTFovTCtmVnk4a1k2dG5ieTdWeExVdm9OZjFIemVD?=
 =?utf-8?B?bEZIa3lhd0RtZHowUTljcEt4SWFxYjFpbXdTcmdJQ0ZLa053bE51WHd2cDhq?=
 =?utf-8?B?Y2FkdGxsNml2cVA3M2FRWVQrN1VLOWhLTnprTWs2MEY3cFAzTnExdXBVVkJy?=
 =?utf-8?Q?tGH5yab5no2RpDJQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b594eaef-e600-47ee-aa24-08da27eac35a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 01:10:48.3581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QH4quARsKTtU97HdNZ+k+Mb7MYTnji3Qyo9mJUSbWTsu+pHUu4V2ps80qXU7GD+FE9SteAFWb1VWqN0pIKIEwHuKE421R7Y+e0XoUlgARs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4238
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_06:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270005
X-Proofpoint-ORIG-GUID: dcwBc8v7dWsW9o6FbR425SGTV-GrUa7A
X-Proofpoint-GUID: dcwBc8v7dWsW9o6FbR425SGTV-GrUa7A
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In preparation for having a different replace algorithm when LARP
> mode is active.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Looks fine
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c | 194 ++++++++++++++++++++++---------------
> --
>  fs/xfs/libxfs/xfs_attr.h |   2 -
>  2 files changed, 112 insertions(+), 84 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 34c31077b08f..772506d44bfa 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -724,6 +724,96 @@ xfs_attr_lookup(
>  	return xfs_attr_node_hasname(args, NULL);
>  }
>  
> +static int
> +xfs_attr_item_init(
> +	struct xfs_da_args	*args,
> +	unsigned int		op_flags,	/* op flag (set or
> remove) */
> +	struct xfs_attr_item	**attr)		/* new xfs_attr_item
> */
> +{
> +
> +	struct xfs_attr_item	*new;
> +
> +	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
> +	new->xattri_op_flags = op_flags;
> +	new->xattri_da_args = args;
> +
> +	*attr = new;
> +	return 0;
> +}
> +
> +/* Sets an attribute for an inode as a deferred operation */
> +static int
> +xfs_attr_defer_add(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_attr_item	*new;
> +	int			error = 0;
> +
> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> +	if (error)
> +		return error;
> +
> +	if (xfs_attr_is_shortform(args->dp))
> +		new->xattri_dela_state = XFS_DAS_SF_ADD;
> +	else if (xfs_attr_is_leaf(args->dp))
> +		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
> +	else
> +		new->xattri_dela_state = XFS_DAS_NODE_ADD;
> +
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> +
> +	return 0;
> +}
> +
> +/* Sets an attribute for an inode as a deferred operation */
> +static int
> +xfs_attr_defer_replace(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_attr_item	*new;
> +	int			error = 0;
> +
> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> +	if (error)
> +		return error;
> +
> +	if (xfs_attr_is_shortform(args->dp))
> +		new->xattri_dela_state = XFS_DAS_SF_ADD;
> +	else if (xfs_attr_is_leaf(args->dp))
> +		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
> +	else
> +		new->xattri_dela_state = XFS_DAS_NODE_ADD;
> +
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> +
> +	return 0;
> +}
> +
> +/* Removes an attribute for an inode as a deferred operation */
> +static int
> +xfs_attr_defer_remove(
> +	struct xfs_da_args	*args)
> +{
> +
> +	struct xfs_attr_item	*new;
> +	int			error;
> +
> +	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE,
> &new);
> +	if (error)
> +		return error;
> +
> +	if (xfs_attr_is_shortform(args->dp))
> +		new->xattri_dela_state = XFS_DAS_SF_REMOVE;
> +	else if (xfs_attr_is_leaf(args->dp))
> +		new->xattri_dela_state = XFS_DAS_LEAF_REMOVE;
> +	else
> +		new->xattri_dela_state = XFS_DAS_NODE_REMOVE;
> +
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> +
> +	return 0;
> +}
> +
>  /*
>   * Note: If args->value is NULL the attribute will be removed, just
> like the
>   * Linux ->setattr API.
> @@ -812,29 +902,35 @@ xfs_attr_set(
>  	}
>  
>  	error = xfs_attr_lookup(args);
> -	if (args->value) {
> -		if (error == -EEXIST && (args->attr_flags &
> XATTR_CREATE))
> -			goto out_trans_cancel;
> -		if (error == -ENOATTR && (args->attr_flags &
> XATTR_REPLACE))
> -			goto out_trans_cancel;
> -		if (error != -ENOATTR && error != -EEXIST)
> +	switch (error) {
> +	case -EEXIST:
> +		/* if no value, we are performing a remove operation */
> +		if (!args->value) {
> +			error = xfs_attr_defer_remove(args);
> +			break;
> +		}
> +		/* Pure create fails if the attr already exists */
> +		if (args->attr_flags & XATTR_CREATE)
>  			goto out_trans_cancel;
>  
> -		error = xfs_attr_set_deferred(args);
> -		if (error)
> +		error = xfs_attr_defer_replace(args);
> +		break;
> +	case -ENOATTR:
> +		/* Can't remove what isn't there. */
> +		if (!args->value)
>  			goto out_trans_cancel;
>  
> -		/* shortform attribute has already been committed */
> -		if (!args->trans)
> -			goto out_unlock;
> -	} else {
> -		if (error != -EEXIST)
> +		/* Pure replace fails if no existing attr to replace.
> */
> +		if (args->attr_flags & XATTR_REPLACE)
>  			goto out_trans_cancel;
>  
> -		error = xfs_attr_remove_deferred(args);
> -		if (error)
> -			goto out_trans_cancel;
> +		error = xfs_attr_defer_add(args);
> +		break;
> +	default:
> +		goto out_trans_cancel;
>  	}
> +	if (error)
> +		goto out_trans_cancel;
>  
>  	/*
>  	 * If this is a synchronous mount, make sure that the
> @@ -898,72 +994,6 @@ xfs_attrd_destroy_cache(void)
>  	xfs_attrd_cache = NULL;
>  }
>  
> -STATIC int
> -xfs_attr_item_init(
> -	struct xfs_da_args	*args,
> -	unsigned int		op_flags,	/* op flag (set or
> remove) */
> -	struct xfs_attr_item	**attr)		/* new xfs_attr_item
> */
> -{
> -
> -	struct xfs_attr_item	*new;
> -
> -	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
> -	new->xattri_op_flags = op_flags;
> -	new->xattri_da_args = args;
> -
> -	*attr = new;
> -	return 0;
> -}
> -
> -/* Sets an attribute for an inode as a deferred operation */
> -int
> -xfs_attr_set_deferred(
> -	struct xfs_da_args	*args)
> -{
> -	struct xfs_attr_item	*new;
> -	int			error = 0;
> -
> -	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> -	if (error)
> -		return error;
> -
> -	if (xfs_attr_is_shortform(args->dp))
> -		new->xattri_dela_state = XFS_DAS_SF_ADD;
> -	else if (xfs_attr_is_leaf(args->dp))
> -		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
> -	else
> -		new->xattri_dela_state = XFS_DAS_NODE_ADD;
> -
> -	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> -
> -	return 0;
> -}
> -
> -/* Removes an attribute for an inode as a deferred operation */
> -int
> -xfs_attr_remove_deferred(
> -	struct xfs_da_args	*args)
> -{
> -
> -	struct xfs_attr_item	*new;
> -	int			error;
> -
> -	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE,
> &new);
> -	if (error)
> -		return error;
> -
> -	if (xfs_attr_is_shortform(args->dp))
> -		new->xattri_dela_state = XFS_DAS_SF_REMOVE;
> -	else if (xfs_attr_is_leaf(args->dp))
> -		new->xattri_dela_state = XFS_DAS_LEAF_REMOVE;
> -	else
> -		new->xattri_dela_state = XFS_DAS_NODE_REMOVE;
> -
> -	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> -
> -	return 0;
> -}
> -
>  /*==================================================================
> ======
>   * External routines when attribute list is inside the inode
>  
> *====================================================================
> ====*/
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index e4b11ac243d7..cac7dfcf2dbe 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -559,8 +559,6 @@ bool xfs_attr_namecheck(const void *name, size_t
> length);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>  void xfs_init_attr_trans(struct xfs_da_args *args, struct
> xfs_trans_res *tres,
>  			 unsigned int *total);
> -int xfs_attr_set_deferred(struct xfs_da_args *args);
> -int xfs_attr_remove_deferred(struct xfs_da_args *args);
>  
>  extern struct kmem_cache	*xfs_attri_cache;
>  extern struct kmem_cache	*xfs_attrd_cache;

