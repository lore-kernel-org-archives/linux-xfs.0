Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D172C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 13:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiAENn4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 08:43:56 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23522 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbiAENnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 08:43:55 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205D4Un5016995;
        Wed, 5 Jan 2022 13:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bSp2TT0LkdXF3iYuvqfToFDydYPyTh8CZjT1jUT7kNs=;
 b=hpZ7r48i7uXM0bT6pJxbJdJXOFhGX4ETfX9Q895emoTZtBdt6GaFG2/ZGX2cSN5WHtm5
 iEtoVdPe/CKxG9SY7SLBxNAqz+utw5Lg8Bvd6VaFZknBj1J4yM0TglB/f6aYGh+eDAKV
 LDl8s/J5sBI56GjjtFXpMEvksMMFErpZj74I4qI0A/hnskhk1vskXBMfQ2OKBRWb92G5
 tKAdEL0qACS6ZBvDjOVS1h/xfajG2wc6Fj1aovMctYdHnkffN6DiZG3CX+GFdRewkXe5
 ibEuYkFt/AK3HmiOiPBn0J37yZgfpK5AKGvf0OpycLnxBLru48ZsnWOHsufjKgV6Fsc6 wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc8q7v6bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:43:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 205Dg8XG112871;
        Wed, 5 Jan 2022 13:43:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3030.oracle.com with ESMTP id 3dad0f1af3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:43:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRAvnKXrPjcBPE7OOsZ/uH/nJ1IYxd9nVKKuoLMKl2EOGMToj+ayx/z5Km1HfNvSkFhfZlLBg5nssSL9ipYdQdA5XYG16Ps557LxgROITPV/BTpIwYOzvOazuCP7WpS0kjwwOuW6MUbIDCtb2mz2O3YS4YmnfEoo04p1VOa9DRbLtzG5TaHACFZV6rU25fNeKBJddKRe2pYIZajST4tIUeuLiFT6+GrThig2EkJ97+d5cMGcCGCFCCpyUVDjWA9GK4ckRhDyYqGGLeIcDoS3AwCh1Z5iRTdcrKtpHtSI44SBWPaJPbPLTnuU1oaX6jpd6nziPUujfCV1JAvHScs8Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bSp2TT0LkdXF3iYuvqfToFDydYPyTh8CZjT1jUT7kNs=;
 b=ddOlgKQYmq8jiH9fIFBrHpniuibpdXUyFHmRdHZk8LEVvyVKzIe4ITUqXCA0TmbigmycyqfCHKVAGOfA8bPJ8SwIm4+rWUc16VrDSdaFdRAdfFZP6F5+k7ZFAhF3SKkqmzaiaLsqDSaVrV71HEybaebGuAmDozo8KbujSMaMnfDTfY6FV5djx/3jKog10hLqwkab0T2cIK9ID/eNXDUtq0L0RU4iORla8XXeBUI3ftq0qvzJr/a/MQEcPepY7bDEHi/5mwSTcvz7PkCIDbZ1PJ16z0WDi/xtdfPjbSwOZENjN2//cPq/sCq+A0wxeSAzIOzfsA8pZo2Mh1oBVsWdrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSp2TT0LkdXF3iYuvqfToFDydYPyTh8CZjT1jUT7kNs=;
 b=bvTzYJUjzCvO+A/ysmQz2jHM0HJMEczExbKvnUHVX7Y9sIggIq2ETIl0x356aoDBMUI7bw8qh9TaLhYv9Feh3YN25Gy/niCalS5JUWQe1ds9ZHYspKnBh4sFjiq2TqvZ4TIxKgyh6VK58HHGS14hoA2PhNMmFIB2f3QFaPRETHs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN4PR10MB5654.namprd10.prod.outlook.com (2603:10b6:806:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 13:43:46 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 13:43:46 +0000
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-6-chandan.babu@oracle.com>
 <20220104235014.GL31583@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 05/16] xfs: Use basic types to define
 xfs_log_dinode's di_nextents and di_anextents
In-reply-to: <20220104235014.GL31583@magnolia>
Message-ID: <871r1m9u2v.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 05 Jan 2022 19:13:20 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0116.apcprd06.prod.outlook.com
 (2603:1096:1:1d::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 696ae8ac-1d0e-4e08-da04-08d9d0516590
X-MS-TrafficTypeDiagnostic: SN4PR10MB5654:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB565434E22F311CA3CBDDDB02F64B9@SN4PR10MB5654.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hveUjHQuRPicpt1Suwtx0kQugIl1AG+tN/EWHPyLzjrfYQLz5M1C11LI6cdYttSX9LmSwI3RDdmBJ2AU0ea0nIjnnoMQC47ox3rFirKwupZ1aMJp3x3KIgu2kXJgj+dWwpbMXmrxf8cV/bjsL8HL5xK3NuWWajLaDcS5n94Ue/hs7nPIt3XX22P5JQfCeU9Yw55eHG3A1hU4qXyhRyatyZaDmkKeGIwB+06z16H6Nye8w7f5jQB2jUjVKt9bxvZeNGc5p/fq/f/tjlVgpLKa0wtNePEVqAhmbzNiIFDcmziV7zOfWm1deN/k+GUr3GbNHFaONr7f6h96C9cXuA4GxPlJsOHgRMK1Lb4PmEDqBzpiHUd1Ui9XWB3DTbuFsrYD8TnwF5hXL3DF2bcp7Z7lBsFZy6T4SDGxs5agjr52LbA+WzHAM695LSh9RkGio97Er6gAQxY65EoPXjcyukN9qbwG0PSkCXrtr745MbetqkqQFnH5fWjxkANrS3tD/y4Q7HNNKidMk6yt9MJ+BAr3AdN1Q+z4RW8XpF+3DYFmZTS4nEdgC+Db3Ra/FdHB1s675OgmNJLs0yd13zV1I7lQx/beUUdtuGli2bw/EofmjQNYbWONMI9S7jiOYBgQlyS3ioI/ihrvMEagzuj08ihE6S43Cd6PwBnw+/vvIJwi9V/zES9MQJo7+uqSVB+PMTskz7N66I1oQnHr/8G94kFdTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(6916009)(33716001)(66946007)(186003)(2906002)(8676002)(66476007)(66556008)(316002)(52116002)(4326008)(26005)(6486002)(6666004)(83380400001)(9686003)(6506007)(53546011)(38350700002)(6512007)(5660300002)(38100700002)(508600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fnC7deVutN8eKX6YhVnccqx0M+EKzilt9CEvjqQmym0FJveCsU5Ck/bSUJSY?=
 =?us-ascii?Q?jgQw1bMzHS6xyAWRVfapRMzxr+ylMPig9PQml8bqr2wCzOe2LPktvfNvX3IM?=
 =?us-ascii?Q?4TaAIN/6bPVR8NX+n/THSUunbns5AG5BgVLosE8LUDSaUILUJEot950UvseK?=
 =?us-ascii?Q?TMsdHGnysCSDlntXk26oQvzvkFgboNnxPaugznubn1kqVW/f5iRBCS50Kad3?=
 =?us-ascii?Q?wlx5vXT/R8tlRuJgQomUeFpT6tZQDeIuBbELsq9lHCU09cL8wjukvmABqij6?=
 =?us-ascii?Q?bMwBjxjUS6hHo3Yy5LWgltfU3lBtxdsCpiaaHR54A47aNMISvoIkT7MzdLRz?=
 =?us-ascii?Q?KrqhVDQz+CPmmCuwKHu97c8wBegmRmu4raWiILf2hMKu9r6bOvapr4xjXjV7?=
 =?us-ascii?Q?9RvMs/OcIIxW7k/kwy+q/mPKJYKUMp2E3ZoDJjnHBGDox1/SnYVcc+tMG0jM?=
 =?us-ascii?Q?KppR0REwAjThSbJfWSqq6JZNUrAweyiJdeDfnqbeVXUTJF5gdnbXrMAsG2o4?=
 =?us-ascii?Q?zY/Zz+vRmjZ4P+PQFOtb0XNPiBMiCnM6Nmg4jJpnajysXvAPnwkFEKb6/cad?=
 =?us-ascii?Q?3b3Va7/KATiNlnkNb9AWUvoMpDDwNfguerPVfVFnIO784T0I38dL+f6vqOq4?=
 =?us-ascii?Q?k0cRX3wUj7ES3GafDCTtvHVz2jbtm9yTFvurJwHC9bztBb6OsQdwtAOmdmbr?=
 =?us-ascii?Q?nRHjLcXnRG6bANz02C8JLRTiT5dJbMQgSfJDlZh8VylQrgSxELbCTL83/GbO?=
 =?us-ascii?Q?yuZkYQMULTtKUFU1DhNjX74lUuU3MVhzEQHMISZYeJz4lbmGfQzxkZc+VbPq?=
 =?us-ascii?Q?WRaTuY37EOyn5OSxKm1r/d4sgXgtCHhFomFGQA4NGDXNA1LDFtOHJ1cQ/N4O?=
 =?us-ascii?Q?a2XrOHIEdrB1hO9Gb8/vC1Ce1zCtykEBd5X4nvEtDJgMsJiK+bF3G1Wu3Yg2?=
 =?us-ascii?Q?80m8Gq6Fqy1tMQ6xlrw0tShGRXolOCHs9HqPU+sSpIiB24pY20bvKwkmajPM?=
 =?us-ascii?Q?voLqs3DwqthvcOH/oJa7X5UKnNEYRZDbYJB8NJ3TGcNTskN7Y/HigCXqPdKY?=
 =?us-ascii?Q?38XKtMDPMFCcUROV8YmAPosItWSW3hG9vIxu0jYLzabZPBHTaZbDDu9vqI16?=
 =?us-ascii?Q?qM2ES8T7qmGDIxNzaOBSmZD+Oc0d0I31BTdIY2vtzA4tFgJP7xoI1a9N/6qS?=
 =?us-ascii?Q?g/22q5ZR4eAjLZA3sJuFX6eqyuMsnJgyEj0u2n0/Xvyf+gBKZ6YGmozbuKsW?=
 =?us-ascii?Q?kvCTG22RPGjwzBt+sakC3pDyMaj6hVj66VW7IzjjITOTKzlsi/CsPNV2hiYY?=
 =?us-ascii?Q?rSo0t/i7zbjaH5x6Snj2ZjrlqkuTdz1mwtgYn+tAh3YIyq5y96Z+agNAVv0X?=
 =?us-ascii?Q?UcUes+K7mWyr5GoyQS3q4AUdJkaIbQpPhtuI492vVdAjPJ+74M2QlwlCEln2?=
 =?us-ascii?Q?igfyeZ3ScyhRPqvhT2WuDu0L1ioB7Vply4En/U2kV6SQkCwW4v5IPTuX2XDv?=
 =?us-ascii?Q?UeCd3ZVg1nt4Z/zWSnqEp+0oHcWfCyt6atYsg+p23EpCuAimOOzZ9hP9FMtQ?=
 =?us-ascii?Q?K9cHUdmft5VpJpCh5pzQBvjjnEami5txCCoW0H1MwQrWYFewsKzgZ2d+FfH/?=
 =?us-ascii?Q?r54SslN94QYhehVkQa3A76U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 696ae8ac-1d0e-4e08-da04-08d9d0516590
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:43:46.7552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TUZPHmolDy0DKSdRWWBhrMCLq9YYI5sPYtXTq8NQ61dcJlubJtLyP6K01ykg67FSo/ABf971ZQ/1gj6j3LiikA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5654
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050091
X-Proofpoint-GUID: Ny6anyBlBWspUv7eJ_045Ge_FMC5M6zg
X-Proofpoint-ORIG-GUID: Ny6anyBlBWspUv7eJ_045Ge_FMC5M6zg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 05:20, Darrick J. Wong wrote:
> On Tue, Dec 14, 2021 at 02:15:08PM +0530, Chandan Babu R wrote:
>> A future commit will increase the width of xfs_extnum_t in order to facilitate
>> larger per-inode extent counters. Hence this patch now uses basic types to
>> define xfs_log_dinode->[di_nextents|dianextents].
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>
> I wonder how this didn't trip the xfs_ondisk.h checks in the last
> revision of the patches, but ... who cares, let's see what I think of
> how /this/ version handles the field enlargements.
>

This change was part of "xfs: Rename inode's extent counter fields based on
their width" patch in v3 patchset. As Dave had correctly complained, this
change had to be done in a separate patch.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>
> --D
>
>> ---
>>  fs/xfs/libxfs/xfs_log_format.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
>> index b322db523d65..fd66e70248f7 100644
>> --- a/fs/xfs/libxfs/xfs_log_format.h
>> +++ b/fs/xfs/libxfs/xfs_log_format.h
>> @@ -396,8 +396,8 @@ struct xfs_log_dinode {
>>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
>> -	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
>> -	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
>> +	uint32_t	di_nextents;	/* number of extents in data fork */
>> +	uint16_t	di_anextents;	/* number of extents in attribute fork*/
>>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>>  	int8_t		di_aformat;	/* format of attr fork's data */
>>  	uint32_t	di_dmevmask;	/* DMIG event mask */
>> -- 
>> 2.30.2
>> 


-- 
chandan
