Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC02DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356373AbiD0Ahy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242692AbiD0Ahv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:37:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB2E3585A
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:34:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QNo3mL003700;
        Wed, 27 Apr 2022 00:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WFS2XeTvK4Htus26apEdCq7MJXH/pQO8nCcLiATXFm0=;
 b=XXiRHiiA3Y945Er2tqqECugFs35g5zFdq1MKH6sh4NVqpxo4e5F1xpBNoMj+33M2LjvA
 TU1XUydmCI+1+tpL9OwPWvuhFLS8ZKgPWV6d5PvyvFIOXkKbfJuzMxXAbxgW+T9ZVCqx
 HTF8NeX3ppXg/IRT9PxOIqnmGhYSbJmPLMaUQKm8E7fQjnAJGxV9AQgtCFzk7RWCr1G5
 /IL2JGhdeeR/yN+w+FqvkQtmNEPJYOXyqwv/aeO077IQSru4w/e/aEbar+JPnO3FxTGL
 14M2pSQH/DDJSZGPGTEMFjGmqL44Mzpxa6D/DDIvoVpxZOhOl84ESmefmOSxsclFy90P /A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4qc8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 00:34:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23R0Uas0022753;
        Wed, 27 Apr 2022 00:34:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yk2a4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 00:34:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSBG4u/ADXEQpm2Xd/Eaa5+g9b3fNxMjAKttRCDc5soAePymdbQ8dyWSUb6xu1pvmvaUXOnxRRZWgGjMKBIUy3pOkQSBhpeF0JSd2BJIzSZsvaxHdkI1v4i9W6k7UHYDtByZNojHeWvmwK2yKT/S5FacIOtuReXS2OSizV3PWZLE8ua0IsEXgyzx8R97YrkHkQwM26plqn2BMq2+SDmnnxQCXS1HsMj/Uf4qpMpE+GBPb5vcya6BomdyvoFgIOOlA1Cz8dPrARPUwPU/5nQdoQnvHIShST3M+BUwYVSemXKVfqBugvmG5p/FHnID5NBAUVXFWe/KqLVrG+QumvmYxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WFS2XeTvK4Htus26apEdCq7MJXH/pQO8nCcLiATXFm0=;
 b=QqtVstjLBzRo2ROcyiwEervJqZ0+Nu4SvkdUJwBfyPmyDE8L4pRVyurzM5lqRxyfgcj1Y9OBwcUIDXiNdV7tVWTu/yaTxG7sM0e924ae3D5Rr2DhzTJ8Mhi0BwJ6+YGAyTqor3A5zsZQktF/8DSS6N9nxY8d5uRazYiCEAaKTZpZzhrCno0bFEBl8ycQQHV4vPVmF5gjwtiIMCSM8HJV8CmPdZ2zHc+4hd9igQsA0MZSRcrzniZu98kEkKgrW+R3EBF2Hp9170kzvIsPVo48CEfC+jx2kJGW/fFRjV0ZhqW9dONE7MyKe7L4GVeKRfWdWfGjjDuNzykQa6SE2Z3vAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFS2XeTvK4Htus26apEdCq7MJXH/pQO8nCcLiATXFm0=;
 b=LQo+EB7cb5Ck5NrFLV5Pl+Itr1LN6nROPdpVxRpH8sWWCZDZ5ma+kWbeFXErDYZ1louMGeRYd4vC0VTisKSBO7uUJzK8HYozvW1hoCYAANZovPV3y94FS9OJiSPWBullHjnj/y6RF2+lIPWpHh3y1ERF5g7ItaRQqv8j/RSFG8o=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1767.namprd10.prod.outlook.com (2603:10b6:910:a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 27 Apr
 2022 00:34:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 00:34:38 +0000
Message-ID: <982e97f354d087b12e72e4a0c158fac30420fdf3.camel@oracle.com>
Subject: Re: [PATCH 13/16] xfs: switch attr remove to xfs_attri_set_iter
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:34:36 -0700
In-Reply-To: <20220414094434.2508781-14-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-14-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ae26f92-ce01-44b6-1786-08da27e5b628
X-MS-TrafficTypeDiagnostic: CY4PR10MB1767:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1767203CB290816413276FBC95FA9@CY4PR10MB1767.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I3+/RF3MAoM56BQDxjYq3jfjkLinSHGecCvb2JNOot395EavF4OBVotlnyWlSbrpDont/Hu6Om7XrxBYLWpp5uqa2hdvqdtS92NiVJ/VyUMkHTPlfSLenoRLW7rIDC8ZSTSZ/WYHey7OFXnbDv5y1g+OaDof3yIijs0/pz9n99c/XdJFBFYnvwcrrTUdaiKy9r2AR0rqebh/XfjvGV0ufn6qa5NzX5r3f9+fmOnslAzpf43CJPwZ837iMlj8nxh1r9W4DaOMxN2qyBp+MscGz/iYmm9cl0U5acG+lWeipme1X2sKfBNomxQHw+DbzHI4+kzj8N3jhXqC5Q1ebMRK9JGEW2/2ilxu/5eKTguuh56RvvYU3TzphBXCa/xhyJsAXAOTlAOCtP8bOVcN2eFQJ4Gm+2aZaD2snCgYNAIjH4btzA+paMxIHmuyjInmMb/sU1Dw5T3XsKVxgJXDBmbVoQTD60N8Vd1d33Bs5URvGzYs6FPE2G+WyviTPqDbMEzCsRq1yj/dCbgRmpETqemKgOFstV+Sy4RkBs8HzDpOeXYFJOoLMuFt0dwuyAkYyvo68fSUA6ojppFW+qQrENukbvusLsj9vs2u1S49EXGitVwaczdz+0sij4PwYodWIR2pmsKiQYfb2unkxLC2Hj0/bJINS2dlZ3e5Zn9rgRYBwIUsiEo5HYrdUo59N6dreWQHfUilH2us8tWe9wOA84u+og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(186003)(66476007)(8676002)(36756003)(6506007)(66556008)(26005)(8936002)(316002)(66946007)(6512007)(2616005)(5660300002)(508600001)(6486002)(52116002)(2906002)(86362001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXdiaXVLckxGNmU1WjdqWHYxM0F2b2VpUWptYlF2aDhQd1ZnWUpXZGQ5M3ds?=
 =?utf-8?B?OXpwRS84WE5vbDY2WHlNYWlDOUg4UnhsMGo5MnpuaFpMaXcyNEFneUdOMFNW?=
 =?utf-8?B?S0tMWnlmazNGUk1ZVk8xZU9rWGRVdHBVNUpqUFNiekhpMkltMzBkUDhuS2Nj?=
 =?utf-8?B?WUIxTmlLZHBUWVFoU3BCSzVQYWJ2V2lPUHlKd2hpTW9zVnlqQ1ZhenN1SHNp?=
 =?utf-8?B?M0JtaWcvYTlRN2h5WjVnV1ZZZEFSbzZkenJvTUg5RStvK0JHeEd4ZkZPbDdp?=
 =?utf-8?B?eGViZG9EQXZnNy92OGNad1ZEV3pCekVubU8wNUF0bWxpd09jRDNhK3BjM2py?=
 =?utf-8?B?T2FGMHArb1k4bHdoMkZNczhmNkNoZWJYRmh1MmE4TlA4WHNUSnpNWUhWaDI5?=
 =?utf-8?B?NlNYSFhJMDU3YjhyQnNxNVhGY1FqaHZNQ0FsK2d1dUQvL0JYODVJbjVsTE1L?=
 =?utf-8?B?eG5RNjhsVmVKdFA5d0JYRWFYekRsSUxWOVBaVVZBWXE4WWw0TVRnSVQvMFYv?=
 =?utf-8?B?WlVXL3pOamdtbERycW11VjhnQnRULzJ4L0tlZ1VyZEtZeEZIT0I3dXJ1STVU?=
 =?utf-8?B?UUczZjVoNWN2ZTdCeFU4TDNKaFB2OUw0S0tQbk5OUjAveFFweG83a1Z3WHYy?=
 =?utf-8?B?YmJTS0FMOUY4UzlScGFoNDU0WHZHcWo5WUNJT1lveVZFNFlaTHJFUXM0MWo3?=
 =?utf-8?B?bFR1czNteGRBYWdJbkVWZFpwbGJUcEhWTzBUTW80S2VmQkxxbkZRNmRMbkVh?=
 =?utf-8?B?NlpUTkI0d2xkSlRtNlNhR0xENC82WEsyVkM2UW1sUTljeHhzR3RNYjM2SElS?=
 =?utf-8?B?eWtudHdPSjA2R3Q4NEo5NkpyV1JnUGpta3gyQms0OHhLSVZwWmdzNjR2cFF3?=
 =?utf-8?B?NnA2eFhWOUUraXEwN3lTSmh0bEVkV3NmRkUxRTkzelNvVmRUSHdyQzQ1ZmE0?=
 =?utf-8?B?cEpsUGh5dERkQU9mdFovRXBjelkrMlhnVXNGR1A3MzlxTGxsVnF3OWtOcm1y?=
 =?utf-8?B?cTBIM25NLzZrbnVtR1E2cktaTm9LdnM3ZjdocnZJTzBjdlFtRVE0ejBLVFdw?=
 =?utf-8?B?RTJsaW5xSldCcjVHK0JZNmtWRVVac1c3cnYrTDVxKzRVSjgvVWhHcGo0MU1q?=
 =?utf-8?B?UVZwMzdxbmlvZlZQRzNTNnROd1dXUlg5Y2phTjlXL2tXbWJ4M2xrS3VIR1Jp?=
 =?utf-8?B?SGg3cy9adUg3MUlhQjRLS3F3K2Y4SmVDZkhmTXBIKzdjanMvSFlCS0dRTE5Z?=
 =?utf-8?B?bUsyOGcxYVpVVjJZaVpVVEpOK3RqYktBRXkxaTgwZXl6L1A0R3RBV1FUVlFJ?=
 =?utf-8?B?cjNFUE9rdVNBM1Z1TllUWE5zNUxMQnpGQkNrMnRaRDRUZTN5SzllRnpITFhh?=
 =?utf-8?B?a0F4Sk5qdG5aRlozV09ucllSUFFYVnpxOE14RjRmbHJzUjYyaDZGYUtSekJ2?=
 =?utf-8?B?TVpqOG9abG95a0VhWFpFY3RQenRmY0c2N2NqcjhtTlRINVdXcC9HaDAyQzVa?=
 =?utf-8?B?UWsvU2x5N1p2UFRTOXdPcDlYc2pqd2ZuZVg3Y3NiL0lzNHhhN0orbXMrNjlm?=
 =?utf-8?B?K0djK05jR1BiS2dZdnR2aDVUL3RQSzdHM1FVVFhadGFsWjcvSjNOTlZaRDFF?=
 =?utf-8?B?QTJFUXoya2ppSmdEVEdTU0U5TG5aZm9wOGVGOTFTbWlwZGUzSjVYTU1aaEJP?=
 =?utf-8?B?YllMNmRTclZpQXhqSzd5V2lTUFY4SzRVUGx3bjQ5YVB3NTFvUXFqVFNjSUlr?=
 =?utf-8?B?VGNPRVRyZXM1djN5eUhjVVFabStzQ1hYM202d3dkTHVtYko3N2lTeGN5Zjd4?=
 =?utf-8?B?MWRFOHBPVndHRno4N2ZxTSs0dW9iT0lWeXgvU1p4bFRUbEl3M1pad2dBK2FG?=
 =?utf-8?B?M0ZlMWhzeUNZZ3JVRkdpMExBQ09KWEtzQzVMY29SNDRQSWFkYTc0ejZGMWZ6?=
 =?utf-8?B?c2VJVXhMSkhUSERFTWJmYW1Yc3VmczlJcE5SNDFseXcreTNoMkE0c1lxVGcx?=
 =?utf-8?B?WlZWY0hvODFuOFRVTCt5Z0hWaWJwUkV3NGtoVnAyZHFTK3VYN0xEK2psNjFm?=
 =?utf-8?B?Qnk4dW9XQWxRekRCelF5WWFqZFRsYUVDRWVmckUvWlRxcUZVYXBXL0dwaGxi?=
 =?utf-8?B?RFRPeG83Yi8wZ3pxWm1CaGhSMmk1b0k4SGFHSkhjb0c0bURJLy9DcFFLSEtJ?=
 =?utf-8?B?T2toYmN2UUxsNlJTYVVnOXNYek8wQTFVL0MyUFlhaW5RTFNMdFRYdUNvYjhD?=
 =?utf-8?B?VFZwcFZvcFY4ek5GQ3lzMTk1U3V5dTJHTUowM1V0TFV6ZUNqQ28yZ1M3Q1k2?=
 =?utf-8?B?ZXpWbmliY3hZMU1jZFhmbU81c1FWdWk5WkJJcU1kK0VDK1ArcXpmUk5icFI5?=
 =?utf-8?Q?CIZZHp7Pl7cbfl3M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae26f92-ce01-44b6-1786-08da27e5b628
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 00:34:38.4983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5THeN2V09s3CGYugxkKC/f63tmNdVAFMCIB3UZquJ4d5qlcNfT5wj3/VWd/HhEtd/lffllT2E+iWCBu4RmFHlNPO4YbrdGs3VCkRFtqlIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1767
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_06:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270001
X-Proofpoint-ORIG-GUID: 3oCuaDmJC6pZoPY-i3FSBD9DT98VV3wj
X-Proofpoint-GUID: 3oCuaDmJC6pZoPY-i3FSBD9DT98VV3wj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that xfs_attri_set_iter() has initial states for removing
> attributes, switch the pure attribute removal code over to using it.
> This requires attrs being removed to always be marked as INCOMPLETE
> before we start the removal due to the fact we look up the attr to
> remove again in xfs_attr_node_remove_attr().
> 
> Note: this drops the fillstate/refillstate optimisations from
> the remove path that avoid having to look up the path again after
> setting the incomplete flag and removeing remote attrs. Restoring
> that optimisation to this path is future Dave's problem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 26 +++++++++++++++-----------
>  fs/xfs/xfs_attr_item.c   | 27 ++++++---------------------
>  2 files changed, 21 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 8665b74ddfaf..ccc72c0c3cf5 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -507,13 +507,11 @@ int xfs_attr_node_removename_setup(
>  	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
>  		XFS_ATTR_LEAF_MAGIC);
>  
> -	if (args->rmtblkno > 0) {
> -		error = xfs_attr_leaf_mark_incomplete(args, *state);
> -		if (error)
> -			goto out;
> -
> +	error = xfs_attr_leaf_mark_incomplete(args, *state);
> +	if (error)
> +		goto out;
> +	if (args->rmtblkno > 0)
>  		error = xfs_attr_rmtval_invalidate(args);
> -	}
>  out:
>  	if (error)
>  		xfs_da_state_free(*state);
> @@ -954,6 +952,13 @@ xfs_attr_remove_deferred(
>  	if (error)
>  		return error;
>  
> +	if (xfs_attr_is_shortform(args->dp))
> +		new->xattri_dela_state = XFS_DAS_SF_REMOVE;
> +	else if (xfs_attr_is_leaf(args->dp))
> +		new->xattri_dela_state = XFS_DAS_LEAF_REMOVE;
> +	else
> +		new->xattri_dela_state = XFS_DAS_NODE_REMOVE;
> +
Mmmm, same issue here as in patch 4, this initial state configs would
get missed during a replay since these routines are only used in the
delayed attr code path, not the replay code path.


>  	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
>  
>  	return 0;
> @@ -1342,16 +1347,15 @@ xfs_attr_node_remove_attr(
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_da_state		*state = NULL;
> -	struct xfs_mount		*mp = args->dp->i_mount;
>  	int				retval = 0;
>  	int				error = 0;
>  
>  	/*
> -	 * Re-find the "old" attribute entry after any split ops. The
> INCOMPLETE
> -	 * flag means that we will find the "old" attr, not the "new"
> one.
> +	 * The attr we are removing has already been marked incomplete,
> so
> +	 * we need to set the filter appropriately to re-find the "old"
> +	 * attribute entry after any split ops.
>  	 */
> -	if (!xfs_has_larp(mp))
> -		args->attr_filter |= XFS_ATTR_INCOMPLETE;
> +	args->attr_filter |= XFS_ATTR_INCOMPLETE;
>  	state = xfs_da_state_alloc(args);
>  	state->inleaf = 0;
>  	error = xfs_da3_node_lookup_int(state, &retval);
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index f2de86756287..39af681897a2 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -298,12 +298,9 @@ xfs_attrd_item_release(
>  STATIC int
>  xfs_xattri_finish_update(
>  	struct xfs_attr_item		*attr,
> -	struct xfs_attrd_log_item	*attrdp,
> -	uint32_t			op_flags)
> +	struct xfs_attrd_log_item	*attrdp)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> -	unsigned int			op = op_flags &
> -					     XFS_ATTR_OP_FLAGS_TYPE_MAS
> K;
>  	int				error;
>  
>  	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP))
> {
> @@ -311,20 +308,9 @@ xfs_xattri_finish_update(
>  		goto out;
>  	}
>  
> -	switch (op) {
> -	case XFS_ATTR_OP_FLAGS_SET:
> -		error = xfs_attr_set_iter(attr);
> -		if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
> -			error = -EAGAIN;
> -		break;
> -	case XFS_ATTR_OP_FLAGS_REMOVE:
> -		ASSERT(XFS_IFORK_Q(args->dp));
> -		error = xfs_attr_remove_iter(attr);
> -		break;
> -	default:
> -		error = -EFSCORRUPTED;
> -		break;
> -	}
> +	error = xfs_attr_set_iter(attr);
> +	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
> +		error = -EAGAIN;
>  

The concern I have here is that op_flags is recorded and recovered from
the log item (see xfs_attri_item_recover).  Where as xattri_dela_state
is not.  What ever value was set in attr before the shut down would not
be there upon recovery, and with out op_flag we wont know how to
configure it.

I think maybe what you meant to do is log the state?  We need to get
into xfs_attri_log_format and turn alfi_op_flags into
a alfi_dela_state.  I think that would sew together what you are trying
to do here?

Allison

>  out:
>  	/*
> @@ -435,8 +421,7 @@ xfs_attr_finish_item(
>  	 */
>  	attr->xattri_da_args->trans = tp;
>  
> -	error = xfs_xattri_finish_update(attr, done_item,
> -					 attr->xattri_op_flags);
> +	error = xfs_xattri_finish_update(attr, done_item);
>  	if (error != -EAGAIN)
>  		kmem_free(attr);
>  
> @@ -586,7 +571,7 @@ xfs_attri_item_recover(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	ret = xfs_xattri_finish_update(attr, done_item, attrp-
> >alfi_op_flags);
> +	ret = xfs_xattri_finish_update(attr, done_item);
>  	if (ret == -EAGAIN) {
>  		/* There's more work to do, so add it to this
> transaction */
>  		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr-
> >xattri_list);

