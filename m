Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C67BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 10:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BBBE6136A
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 10:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhJTKsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:48:06 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6484 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230187AbhJTKsF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Oct 2021 06:48:05 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K9wxXb005102;
        Wed, 20 Oct 2021 10:45:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mv8U4Mz+2hKr5/ZPpWttFLmGaLCkTDRDcdjlYd+BVtg=;
 b=jROUv290DmiYZm04lXxdL5o9Mo9xgqWKAGexKEuuHPV5KU08BgNGFEA59miJJRTnez7b
 k8N4i4CwJLGKbeAG5HYGlmJpWRgsJlFII2pKiAgfREStnc3OxL0ZTNxpSXFRjZdj+f2a
 eKct1BD3fUevZAAR4PQXpnMcNXWmtsvA5i29Sc6wjJVLF14aiwO5w8947uUfqx+Vss07
 SPmPsRXHunpmvcUnGxTkATwIAFqK7kWThgieRS/db2BY4NZopQYJRKWH7BYDfeUnUYXh
 o+ziI24hSzpvF0oeeN0rU4PeQhL4C9PM6uFPYfMF6MbKzZZG9cPv4QjlHNjeY9SzKQfp Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bsruc8994-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:45:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KAbBnK074197;
        Wed, 20 Oct 2021 10:45:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3020.oracle.com with ESMTP id 3bqpj6vcgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:45:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsYar9rViG4XsmUdMTnzUOqU9hHLRDQUyiU/9SU88AAHWgR4OwmxySagdobJZ0EUhbF6rcbx/2Ic50IgaLo39SwQBPrLLzqBxcfCuQgLmcEk8QXNMbDJ3SNyqKw1aXqYTLe7+DB8jsc6X5LC1GqBH+3YLONjcZJtVR1eMN/FJP/9oEdy9EGUPlRtPR0uAfkwdavlbOuL9uuUxNYI54vn5wH2NnuJnAX2qPGo1ekGIVpZR54Zfw48vpN/qbGGO7dHPcCxlnYOFNFYwbapXeDBZULc0JFc/PsuA6SVdnYPZ0YMl3Xq6sbY3kiC8xqq+oIAFFBWCY43jLSEYoSpYF9nRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mv8U4Mz+2hKr5/ZPpWttFLmGaLCkTDRDcdjlYd+BVtg=;
 b=gYpW2XObnXlVm15P3ias/k88WsiLhZBc62wPG8TIrp63gn2NIioGfOcuI8nVp+ABCXMeCZEnSbfejxGBjQjH8pHrBwTeXIOYELg2+fwHJdifJ/XYQcDRtIqiF6y5RGxbePiT4zjs6BMXNhNTykFRRj/w5lBRwkgk+hFhoVT4ChGRBUh8fcqRF/xBDLDYucaJCLtRbVI/rCoOXoVuFCGtAIHhjmyVCKbz3s6ZWI2WfbZbihZM1y+PvrGGWuJObAV/rIJ6vPJCTBDMBaOejQaF9woAEkZBrCC3bo2tGgP9HZL91ESsKfJiXRFRkCvW1zkrZIJsdFRujHeMNyZxge/UWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mv8U4Mz+2hKr5/ZPpWttFLmGaLCkTDRDcdjlYd+BVtg=;
 b=r8g3JDCUp1VJiCvlfjskaliBu6wlm0Q+p5zfOnefxqsE1FWQj0VQ7TmxP/6p1T4kLf6z9zWLkW+0mz2bLirhKAmlGLGgcbgrjAKYfJ+8B9fHKUdvtpuCwLes+S2F0e09DFAncsGjaIcsljJsf/hk6nmcaRgYEaNQEOURRVx3IAE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4731.namprd10.prod.outlook.com (2603:10b6:806:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 10:45:47 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%7]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:45:47 +0000
References: <163466952709.2235671.6966476326124447013.stgit@magnolia>
 <163466953819.2235671.899746816552861515.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: create slab caches for frequently-used
 deferred items
In-reply-to: <163466953819.2235671.899746816552861515.stgit@magnolia>
Message-ID: <874k9cht4h.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 20 Oct 2021 16:15:34 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.50) by SI2PR02CA0014.apcprd02.prod.outlook.com (2603:1096:4:194::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 20 Oct 2021 10:45:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0a0b689-582d-4cb4-6547-08d993b6c64a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4731:
X-Microsoft-Antispam-PRVS: <SA2PR10MB47312454E59D74D51845A7C8F6BE9@SA2PR10MB4731.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJdnZGHFN1EdZAZhRD2ILeDdLAm9aSPa6fXCl5kRpQBsXtx5Y4Dczq5+9q5mwj9sbpcAzHeH0qFrLOf8/I9n90LrfEsIouoQw2sD2jZ/h7le4PfHefB3cYRp/VsnzwbtLxlh1r3E5mxVLcWdYZ6Q4Dfy3nnwUMm2uUk7Lg2DdVAi6fi3n0ODJNbWMmghEWosepFltCJFrQhD9ZSeIWrYoUCHIz3NDPzIIe+aSNGrttwucjxm0M21UINDvjoqIk2SJIZuZGc36NYqH+PjU0YGOFdFjHr0pofqNlaZkL1v6wgtknMyRGwzkzw9TYO5sqbjqdSpt81mC/SwMVDtKtGtyesVFL/caMM9ZHERhMypeWSRa18JCe68tJNxZtutpTdPQgDsNX63F+hxlKzXiuYt7Q75vY2EQ1dR0msMBo7GjA3jWW4afuW8dWW/7Ij/lom+a+ESQhm6EfvRk42fci1X0AIW2iLs0OeMBx0xZUOlJAldJjolt4H68BJCbn9lLnqUdL2+Wf1IKQmyhjZAm1/PFxnjHDNEsraqSEJymzgXwl26abTpQFHCm7meP8EYXH/+hIMaJ26ZhP1KgUOIOYdJTbXRgNcTI0i5I6B3WYLInF3l+H4zNugqcq8y7yCURlL8U8rWFsADrFNVpCFWhdMauhG8o9oz/+ZXkKCIsMKRchJUae21sOha+AE0hBXHWBjENkanQRS3X/4hCcDpIC50pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(2906002)(30864003)(8676002)(6496006)(66476007)(66556008)(4326008)(83380400001)(5660300002)(52116002)(6666004)(66946007)(6916009)(38350700002)(38100700002)(26005)(33716001)(6486002)(186003)(53546011)(956004)(86362001)(9686003)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hXT/NdCJy/hD/ihNj2D7tQ//DNdv7SrPJ9xDyDVR1IHh8HkqjGTvhRofMuqx?=
 =?us-ascii?Q?kc1I0ZnUsxqLrEEpOqv1TJjNANoQl/Pvw5SLo8KgR+ELBGBLUpYztPL0V2O0?=
 =?us-ascii?Q?dLbZtCdzE4guxDj5nakwyPK8rTaRTpHWt6nb8CvPvjeHfKLXHqJHvCu7vdTa?=
 =?us-ascii?Q?NbHUy15VVadBu29G6utdMpAbkpmSAgCrLX3mBVHDIE07ALh9PP3ihkx2hgs8?=
 =?us-ascii?Q?7EZQ0OyUqoZIobaCpOYc+xI9qYsG87O+E6bJ2a3WJJhpv5m7ZLGoBZ5TzfUS?=
 =?us-ascii?Q?hBlUR85NWHKLNUOA4TRklIwDJAqaaThrHFExtqMvZ8dfdMkhs8pd6xfRtjfC?=
 =?us-ascii?Q?T3dqnKbolQftk+tmgvQ31dYRcx391l/feIbYTLkT6pB6AVekQYCsDM6lT8NE?=
 =?us-ascii?Q?dPvfLo7Dq+8hPS7sCfUtU5wNDGbc7e/12P8859RvHNlLKdaNZECqjMIkD+Ge?=
 =?us-ascii?Q?rlNDmLcTGFKHZGPQhoUCwaLQHkWdTs+cfjvkI897YrX9T73w2k4OIY3CKACr?=
 =?us-ascii?Q?CmPyKR851Nh+AJQFhMV/d+VqaxfLmLGOZMQ0xWayKRKc70LYsN6gAt/32UM3?=
 =?us-ascii?Q?wWlF3IstSo5QQoG9eV5sT8gRK0R1iil3mcBY3+SINbY2ZxJ4EU6rMUTF5DKm?=
 =?us-ascii?Q?lj+ERW0YS8SJJkkkv/u89DFylJpu3jrwDM6FcRN4W3N+TSCPiegRZSF6EhEt?=
 =?us-ascii?Q?xT5VVQGYUn8iACmM0Ac7Z2XuXVJEV9I+3b9Y+R912b9BeS92l4sjphzHdx4o?=
 =?us-ascii?Q?5UjX1vnYtsFeAk2DPUvk5RwHtosbtDT0G8P+thRiuA3tdIPDcS4ORhgiX5Un?=
 =?us-ascii?Q?fQ30S6ymwx7Maz5w7de+d3yKPFV2ojGNQV6cqVQzk2iRve+3jpajyfcEHqn2?=
 =?us-ascii?Q?QxrA9PtqCBInNSnUeJWuizCvhs2SVQrmd1iPv9A3sjV8ZSpJTK/hM0DvQTR/?=
 =?us-ascii?Q?eJxBjwKVrMd9Y8Hz/LODk9aDXd0wLepgtc+tmShSk0kq/T9WmBA1K29RN6JO?=
 =?us-ascii?Q?WNooYcwT6N9HCWyfK/m7sctAktaIGZaREMuS8piIiCuquQr3KTGkd6k541UF?=
 =?us-ascii?Q?CrEwk2zqvDsiL2mcgF691C7dafyWAQWO83Nio0INdwMtUHpBO/mfoJABU67S?=
 =?us-ascii?Q?9IDLvI9sCYrdP1LzYkREkRQjE4FloUIXDJ7/3h2UrHNt6xdKTuDKoW8Pje6s?=
 =?us-ascii?Q?Ekr70xPJKyx6LxNyLvP2KXWYWltbyMRfBPC+EhNx2wrnNGApKMMxKGfp+NQg?=
 =?us-ascii?Q?jv5dDdLPjmFkQVWJnvIPmEl9mI+fToR49+Ssyo1YjL70S5iYHbBcRdMOPp2a?=
 =?us-ascii?Q?/OksCqVxP8TLOE321Q88Fk3flSN7WeIgFAyLhSKmlJP0RrlWCjDU+7V0UBqV?=
 =?us-ascii?Q?keCFTFWIGeYGe/29AQWfNeJrJxS+E5C5/yMs6kA+pbi/lsAEkAIEIjXr1bdA?=
 =?us-ascii?Q?xvSPaZU8g7bXWZi/tXnbMz+tq9xVMP6eyT4GyEubXFmufs3u24N1MUCSZowS?=
 =?us-ascii?Q?k8PmlWJYsY6tSPIjwCViah9AdCTsPW7Om4R1y4pHMF5XHAyil9r92PRdFYML?=
 =?us-ascii?Q?ojCB3LsQKz3uUmiyGDCAI8WXi9wI3zXbI9PQ8WzxTJdYzSIu74sIieXedVOF?=
 =?us-ascii?Q?CM8NFsP4W8LGYBuItkoJ4fo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a0b689-582d-4cb4-6547-08d993b6c64a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:45:47.4948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DCgdqGxS3rHqst8p2nmQkO6bRNbVyUoby4XzBFZ8YF1BDNqUJWzKkObBYYsuXNKIE4V5AD9KSfc8EKIDxfYVvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4731
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200060
X-Proofpoint-ORIG-GUID: 3IUclrOGBS-W7qU_RrqSKXCCg4cUpAqG
X-Proofpoint-GUID: 3IUclrOGBS-W7qU_RrqSKXCCg4cUpAqG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 20 Oct 2021 at 00:22, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Create slab caches for the high-level structures that coordinate
> deferred intent items, since they're used fairly heavily.
>

Apart from the nits pointed later in this mail, the remaining changes looks
good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.c     |   21 +++++++++++++-
>  fs/xfs/libxfs/xfs_bmap.h     |    5 +++
>  fs/xfs/libxfs/xfs_defer.c    |   62 +++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_defer.h    |    3 ++
>  fs/xfs/libxfs/xfs_refcount.c |   23 ++++++++++++++--
>  fs/xfs/libxfs/xfs_refcount.h |    5 +++
>  fs/xfs/libxfs/xfs_rmap.c     |   21 ++++++++++++++
>  fs/xfs/libxfs/xfs_rmap.h     |    5 +++
>  fs/xfs/xfs_bmap_item.c       |    4 +--
>  fs/xfs/xfs_refcount_item.c   |    4 +--
>  fs/xfs/xfs_rmap_item.c       |    4 +--
>  fs/xfs/xfs_super.c           |   10 ++++++-
>  12 files changed, 151 insertions(+), 16 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 8a993ef6b7f4..ef2ac0ecaed9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -37,7 +37,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_iomap.h"
>  
> -
> +struct kmem_cache		*xfs_bmap_intent_cache;
>  struct kmem_cache		*xfs_bmap_free_item_cache;
>  
>  /*
> @@ -6190,7 +6190,7 @@ __xfs_bmap_add(
>  			bmap->br_blockcount,
>  			bmap->br_state);
>  
> -	bi = kmem_alloc(sizeof(struct xfs_bmap_intent), KM_NOFS);
> +	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&bi->bi_list);
>  	bi->bi_type = type;
>  	bi->bi_owner = ip;
> @@ -6301,3 +6301,20 @@ xfs_bmap_validate_extent(
>  		return __this_address;
>  	return NULL;
>  }
> +
> +int __init
> +xfs_bmap_intent_init_cache(void)
> +{
> +	xfs_bmap_intent_cache = kmem_cache_create("xfs_bmap_intent",
> +			sizeof(struct xfs_bmap_intent),
> +			0, 0, NULL);
> +
> +	return xfs_bmap_intent_cache != NULL ? 0 : -ENOMEM;
> +}
> +
> +void
> +xfs_bmap_intent_destroy_cache(void)
> +{
> +	kmem_cache_destroy(xfs_bmap_intent_cache);
> +	xfs_bmap_intent_cache = NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index db01fe83bb8a..fa73a56827b1 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -290,4 +290,9 @@ int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
>  		int flags);
>  
> +extern struct kmem_cache	*xfs_bmap_intent_cache;
> +
> +int __init xfs_bmap_intent_init_cache(void);
> +void xfs_bmap_intent_destroy_cache(void);
> +
>  #endif	/* __XFS_BMAP_H__ */
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 136a367d7b16..641a5dee4ffc 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -18,6 +18,11 @@
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_log.h"
> +#include "xfs_rmap.h"
> +#include "xfs_refcount.h"
> +#include "xfs_bmap.h"
> +
> +static struct kmem_cache	*xfs_defer_pending_cache;
>  
>  /*
>   * Deferred Operations in XFS
> @@ -365,7 +370,7 @@ xfs_defer_cancel_list(
>  			ops->cancel_item(pwi);
>  		}
>  		ASSERT(dfp->dfp_count == 0);
> -		kmem_free(dfp);
> +		kmem_cache_free(xfs_defer_pending_cache, dfp);
>  	}
>  }
>  
> @@ -462,7 +467,7 @@ xfs_defer_finish_one(
>  
>  	/* Done with the dfp, free it. */
>  	list_del(&dfp->dfp_list);
> -	kmem_free(dfp);
> +	kmem_cache_free(xfs_defer_pending_cache, dfp);
>  out:
>  	if (ops->finish_cleanup)
>  		ops->finish_cleanup(tp, state, error);
> @@ -596,8 +601,8 @@ xfs_defer_add(
>  			dfp = NULL;
>  	}
>  	if (!dfp) {
> -		dfp = kmem_alloc(sizeof(struct xfs_defer_pending),
> -				KM_NOFS);
> +		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> +				GFP_NOFS | __GFP_NOFAIL);
>  		dfp->dfp_type = type;
>  		dfp->dfp_intent = NULL;
>  		dfp->dfp_done = NULL;
> @@ -809,3 +814,52 @@ xfs_defer_resources_rele(
>  	dres->dr_bufs = 0;
>  	dres->dr_ordered = 0;
>  }
> +
> +static inline int __init
> +xfs_defer_init_cache(void)
> +{
> +	xfs_defer_pending_cache = kmem_cache_create("xfs_defer_pending",
> +			sizeof(struct xfs_defer_pending),
> +			0, 0, NULL);
> +
> +	return xfs_defer_pending_cache != NULL ? 0 : -ENOMEM;
> +}
> +
> +static inline void
> +xfs_defer_destroy_cache(void)
> +{
> +	kmem_cache_destroy(xfs_defer_pending_cache);
> +	xfs_defer_pending_cache = NULL;
> +}
> +
> +/* Set up caches for deferred work items. */
> +int __init
> +xfs_defer_init_item_caches(void)
> +{
> +	int				error;
> +
> +	error = xfs_defer_init_cache();
> +	if (error)
> +		return error;
> +	error = xfs_rmap_intent_init_cache();
> +	if (error)
> +		return error;
> +	error = xfs_refcount_intent_init_cache();
> +	if (error)
> +		return error;
> +	error = xfs_bmap_intent_init_cache();
> +	if (error)
> +		return error;
> +

If the call to xfs_rmap_intent_init_cache() fails, then we don't free up
xfs_defer_pending_cache. Same logic applies to the rest of initialization
functions called above.

> +	return 0;
> +}
> +
> +/* Destroy all the deferred work item caches, if they've been allocated. */
> +void
> +xfs_defer_destroy_item_caches(void)
> +{
> +	xfs_bmap_intent_destroy_cache();
> +	xfs_refcount_intent_destroy_cache();
> +	xfs_rmap_intent_destroy_cache();
> +	xfs_defer_destroy_cache();
> +}
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 7952695c7c41..7bb8a31ad65b 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -122,4 +122,7 @@ void xfs_defer_ops_capture_free(struct xfs_mount *mp,
>  		struct xfs_defer_capture *d);
>  void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
>  
> +int __init xfs_defer_init_item_caches(void);
> +void xfs_defer_destroy_item_caches(void);
> +
>  #endif /* __XFS_DEFER_H__ */
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index e5d767a7fc5d..2c03df715d4f 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -24,6 +24,8 @@
>  #include "xfs_rmap.h"
>  #include "xfs_ag.h"
>  
> +struct kmem_cache	*xfs_refcount_intent_cache;
> +
>  /* Allowable refcount adjustment amounts. */
>  enum xfs_refc_adjust_op {
>  	XFS_REFCOUNT_ADJUST_INCREASE	= 1,
> @@ -1235,8 +1237,8 @@ __xfs_refcount_add(
>  			type, XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
>  			blockcount);
>  
> -	ri = kmem_alloc(sizeof(struct xfs_refcount_intent),
> -			KM_NOFS);
> +	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
> +			GFP_NOFS | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&ri->ri_list);
>  	ri->ri_type = type;
>  	ri->ri_startblock = startblock;
> @@ -1782,3 +1784,20 @@ xfs_refcount_has_record(
>  
>  	return xfs_btree_has_record(cur, &low, &high, exists);
>  }
> +
> +int __init
> +xfs_refcount_intent_init_cache(void)
> +{
> +	xfs_refcount_intent_cache = kmem_cache_create("xfs_refc_intent",
> +			sizeof(struct xfs_refcount_intent),
> +			0, 0, NULL);
> +
> +	return xfs_refcount_intent_cache != NULL ? 0 : -ENOMEM;
> +}
> +
> +void
> +xfs_refcount_intent_destroy_cache(void)
> +{
> +	kmem_cache_destroy(xfs_refcount_intent_cache);
> +	xfs_refcount_intent_cache = NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> index 894045968bc6..9eb01edbd89d 100644
> --- a/fs/xfs/libxfs/xfs_refcount.h
> +++ b/fs/xfs/libxfs/xfs_refcount.h
> @@ -83,4 +83,9 @@ extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
>  extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
>  		struct xfs_refcount_irec *irec, int *stat);
>  
> +extern struct kmem_cache	*xfs_refcount_intent_cache;
> +
> +int __init xfs_refcount_intent_init_cache(void);
> +void xfs_refcount_intent_destroy_cache(void);
> +
>  #endif	/* __XFS_REFCOUNT_H__ */
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index f45929b1b94a..cd322174dbff 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -24,6 +24,8 @@
>  #include "xfs_inode.h"
>  #include "xfs_ag.h"
>  
> +struct kmem_cache	*xfs_rmap_intent_cache;
> +
>  /*
>   * Lookup the first record less than or equal to [bno, len, owner, offset]
>   * in the btree given by cur.
> @@ -2485,7 +2487,7 @@ __xfs_rmap_add(
>  			bmap->br_blockcount,
>  			bmap->br_state);
>  
> -	ri = kmem_alloc(sizeof(struct xfs_rmap_intent), KM_NOFS);
> +	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&ri->ri_list);
>  	ri->ri_type = type;
>  	ri->ri_owner = owner;
> @@ -2779,3 +2781,20 @@ const struct xfs_owner_info XFS_RMAP_OINFO_REFC = {
>  const struct xfs_owner_info XFS_RMAP_OINFO_COW = {
>  	.oi_owner = XFS_RMAP_OWN_COW,
>  };
> +
> +int __init
> +xfs_rmap_intent_init_cache(void)
> +{
> +	xfs_rmap_intent_cache = kmem_cache_create("xfs_rmap_intent",
> +			sizeof(struct xfs_rmap_intent),
> +			0, 0, NULL);
> +
> +	return xfs_rmap_intent_cache != NULL ? 0 : -ENOMEM;
> +}
> +
> +void
> +xfs_rmap_intent_destroy_cache(void)
> +{
> +	kmem_cache_destroy(xfs_rmap_intent_cache);
> +	xfs_rmap_intent_cache = NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> index 85dd98ac3f12..b718ebeda372 100644
> --- a/fs/xfs/libxfs/xfs_rmap.h
> +++ b/fs/xfs/libxfs/xfs_rmap.h
> @@ -215,4 +215,9 @@ extern const struct xfs_owner_info XFS_RMAP_OINFO_INODES;
>  extern const struct xfs_owner_info XFS_RMAP_OINFO_REFC;
>  extern const struct xfs_owner_info XFS_RMAP_OINFO_COW;
>  
> +extern struct kmem_cache	*xfs_rmap_intent_cache;
> +
> +int __init xfs_rmap_intent_init_cache(void);
> +void xfs_rmap_intent_destroy_cache(void);
> +
>  #endif	/* __XFS_RMAP_H__ */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 6049f0722181..e1f4d7d5a011 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -384,7 +384,7 @@ xfs_bmap_update_finish_item(
>  		bmap->bi_bmap.br_blockcount = count;
>  		return -EAGAIN;
>  	}
> -	kmem_free(bmap);
> +	kmem_cache_free(xfs_bmap_intent_cache, bmap);
>  	return error;
>  }
>  
> @@ -404,7 +404,7 @@ xfs_bmap_update_cancel_item(
>  	struct xfs_bmap_intent		*bmap;
>  
>  	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
> -	kmem_free(bmap);
> +	kmem_cache_free(xfs_bmap_intent_cache, bmap);
>  }
>  
>  const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index f23e86e06bfb..d3da67772d57 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -384,7 +384,7 @@ xfs_refcount_update_finish_item(
>  		refc->ri_blockcount = new_aglen;
>  		return -EAGAIN;
>  	}
> -	kmem_free(refc);
> +	kmem_cache_free(xfs_refcount_intent_cache, refc);
>  	return error;
>  }
>  
> @@ -404,7 +404,7 @@ xfs_refcount_update_cancel_item(
>  	struct xfs_refcount_intent	*refc;
>  
>  	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> -	kmem_free(refc);
> +	kmem_cache_free(xfs_refcount_intent_cache, refc);
>  }
>  
>  const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index b5cdeb10927e..c3966b4c58ef 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -427,7 +427,7 @@ xfs_rmap_update_finish_item(
>  			rmap->ri_bmap.br_startoff, rmap->ri_bmap.br_startblock,
>  			rmap->ri_bmap.br_blockcount, rmap->ri_bmap.br_state,
>  			state);
> -	kmem_free(rmap);
> +	kmem_cache_free(xfs_rmap_intent_cache, rmap);
>  	return error;
>  }
>  
> @@ -447,7 +447,7 @@ xfs_rmap_update_cancel_item(
>  	struct xfs_rmap_intent		*rmap;
>  
>  	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
> -	kmem_free(rmap);
> +	kmem_cache_free(xfs_rmap_intent_cache, rmap);
>  }
>  
>  const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 0afa47378211..8909e08cbf77 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -38,6 +38,7 @@
>  #include "xfs_pwork.h"
>  #include "xfs_ag.h"
>  #include "xfs_btree.h"
> +#include "xfs_defer.h"
>  
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
> @@ -1972,11 +1973,15 @@ xfs_init_caches(void)
>  	if (error)
>  		goto out_destroy_bmap_free_item_cache;
>  
> +	error = xfs_defer_init_item_caches();
> +	if (error)
> +		goto out_destroy_btree_cur_cache;
> +
>  	xfs_da_state_cache = kmem_cache_create("xfs_da_state",
>  					      sizeof(struct xfs_da_state),
>  					      0, 0, NULL);
>  	if (!xfs_da_state_cache)
> -		goto out_destroy_btree_cur_cache;
> +		goto out_destroy_defer_item_cache;
>  
>  	xfs_ifork_cache = kmem_cache_create("xfs_ifork",
>  					   sizeof(struct xfs_ifork),
> @@ -2106,6 +2111,8 @@ xfs_init_caches(void)
>  	kmem_cache_destroy(xfs_ifork_cache);
>   out_destroy_da_state_cache:
>  	kmem_cache_destroy(xfs_da_state_cache);
> + out_destroy_defer_item_cache:
> +	xfs_defer_destroy_item_caches();
>   out_destroy_btree_cur_cache:
>  	xfs_btree_destroy_cur_caches();
>   out_destroy_bmap_free_item_cache:
> @@ -2140,6 +2147,7 @@ xfs_destroy_caches(void)
>  	kmem_cache_destroy(xfs_ifork_cache);
>  	kmem_cache_destroy(xfs_da_state_cache);
>  	xfs_btree_destroy_cur_caches();
> +	xfs_defer_destroy_item_caches();

Since caches are being freed in the reverse order of their creation,
xfs_defer_destroy_item_caches() should be invoked before
xfs_btree_destroy_cur_caches().

>  	kmem_cache_destroy(xfs_bmap_free_item_cache);
>  	kmem_cache_destroy(xfs_log_ticket_cache);
>  }


-- 
chandan
