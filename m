Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE55C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 03:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 932A360F23
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 03:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhIRDiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 23:38:09 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47370 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232880AbhIRDiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Sep 2021 23:38:09 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18I3TQSG018506;
        Sat, 18 Sep 2021 03:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=YSXMoqtVhs+kaU4vHOQ8fD9VQe51J92kvTAogdy6mG8=;
 b=DftnbU4gG44iwBtPm2kLZpKkLtA83nUF3AooSx+QfdKXhFI7Xrmg7LIKjv2DqTl/TaAn
 h6b0GsRRfdMWHA81FsmdlAi3WkVScLD4kVvXMFspeRtnoGkqilAa2arj6QrF96mmICCK
 3PGDtT6Lls5HUkfAqDnpBRcbHd985LjeI08gm7EgT2oRaGHNedJLcM3Or0AAL5vqyFaz
 IxXmoei6mY6s+gal/7m1pnEeVez4gM0HB2qu2kEQh+roKuzzFcXktxoTkvJjkgMehCpV
 y+HfRduLaBkGEoZwpZ/29UEgewFjhfspAs4cIofoOlNWL8bsqNqLjngrFn+vtscbSTgc Dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YSXMoqtVhs+kaU4vHOQ8fD9VQe51J92kvTAogdy6mG8=;
 b=INLbMWDHeLZhfudSE/IfoKem6WnHonknykkscar0L8GWzWS2fJmW8SDEE9wCuDiJRHFK
 W5slQrxX3QPOUfUPkB6Jb77v/6jwMqOWSaWYvGDcTSW/f2iVzezdodL5sAsJ0+AIuQw3
 5RWUnK2elL3T5uHhTEUVXBVE4f11kQE0KUTUy+UozcKznlX6DgQvBFnoC/Mj9MOAd6U4
 3D3DWcDdb1Gw5hj0FmyoddSrFJpK9C2ZUaG+AVgwRl+7Ng4UhdaWH2gc+L7gXt6NdOrU
 5vjbM5d+1lzAR4K2UEkeDXsKj098vEYfg0JvnutTgZXTWa5Lnvy1INYxzBCHvlMLv3pJ Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b5809r0up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Sep 2021 03:36:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18I3Tj55125796;
        Sat, 18 Sep 2021 03:36:44 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by userp3020.oracle.com with ESMTP id 3b57ejscnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Sep 2021 03:36:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnjQDF2afEBqPjQWinBnIDoOUOQG8IkFNOTROxqYKGItmJtQJH1T/pg8XP8OT7cA/RPqDvNGFUzFvvVjHxTKsdykQK7uAHWrEs3OuAAfC62y15MELH2CzCG0IwXYHw1X5oa2Adx5z8Fd5LBUt2N09W5NAaACeCR46naENiytMQsDALG0pMFXSECUi68lrxdqRFA0b5VIehiSM2BFM1yswYVl8PEmQER5625OTpgViTu3bD3lsy6CaC0+VX+lB9OsUL3urioOLD6cq8e0FcjPpyfzBgNjtdmRBq1hBoV8Ai6GwlVWE4oQlBNr2WlCrkT19vayXBM2CqgmddRvq/+CnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YSXMoqtVhs+kaU4vHOQ8fD9VQe51J92kvTAogdy6mG8=;
 b=DTtAqRlIK2crmZ5uE13mf/O2ocOgeqGI3/UZzI7+gNG8+091yq3numOIiRVa3zJI1p2QZLqeXKPjOwltQCTXtggGisZHGVz61i5+r8djANHNjSlzrDYwcer53a9O3vxtqUnfxsWlYWBxbHAwTfgkQQbiE6Fb/JDmDFbMwcVkgVO/vwfmTJWAamzTFcNQqKlkSE5IwjabYyfG4xXtvs2l1s7hOvnFfGAdVQF4brD6uUWAFwnSVAkotP/mrt+d6L8DHtBD5AJnQ7ju+31GdEECZTNdTNAQQz4nm/7HzDE5gejuzeTzH7kThsrV0Pqz8vEPthYQfcUlI0KMYWw4b0NAmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSXMoqtVhs+kaU4vHOQ8fD9VQe51J92kvTAogdy6mG8=;
 b=OKqebrZ+k9ES/VuFgT7L5UKxyvjkJvQ9jPomQ+CXxxJeD8AsL5noTYFBHtwQl2iO+wBsuYtRGyk6hduv3PZ7W5HdqdGF+QEd1dyvMspf7MCfZvOBuS6gIcP6iT4KujFak+AYiAqaiqKcVyvrnI93l7DEYoOCXc1024yrmXOw+hE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN4PR10MB5606.namprd10.prod.outlook.com (2603:10b6:806:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Sat, 18 Sep
 2021 03:36:41 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Sat, 18 Sep 2021
 03:36:41 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210918000333.GD10224@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [External] : Re: [PATCH V3 00/12] xfs: Extend per-inode extent
 counters
In-reply-to: <20210918000333.GD10224@magnolia>
Message-ID: <87k0jeo8qr.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Sat, 18 Sep 2021 09:06:28 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0107.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.179.117.79) by MA1PR01CA0107.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Sat, 18 Sep 2021 03:36:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf0d7857-98c0-4d4b-7d32-08d97a55871f
X-MS-TrafficTypeDiagnostic: SN4PR10MB5606:
X-Microsoft-Antispam-PRVS: <SN4PR10MB56067907768D11381CCD38E4F6DE9@SN4PR10MB5606.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0u6aiAqsYZdkdkfI+EPxZW5ZP5FgA5rmJ0eCfwxWzSF8vjUwDnjhFZ6tsV1IQcib2zDV2TP+TDYPHBHXG0tu/a1K+Uo7F/Rq5v8Ml/UejNdSx4phY1dKsW4xtHrVY8kdIsbcrAPImTafUVxRNXHRoatxFDNt/EIFY/YTKynW3P3oJnEmronMYH5eefUj8rxY7KV2GH0Uz8x7Sv/p8JqUvPSmEZ7YMaJ5fooMcjB01j1VLxGybPJ2xOxJp+NPrxwTEPuMN8ctK4EKOKWqKVdwkRXDdd+4xBR+HRQOn8wtdmIIrW19ORB9ZB/Xl226PWwAJOr/EuzhMIzVi0joxpe3of6xrqPFVOv1VMzgFY9R9OS9B3eDHUvcJiD2vhPKotY+ZjakuEzW2GsV9toJhxPKvuD2wPPNlPxDgP1PFNOQiGzhBS23pAHTDkhlZjZHJOwYsGmFW3aAUTcgrvOK7HjP0e+vdSvtcxjOUbSjNcWXbw6YOVDETr8gyJlCXJOGDTqHFQqwsLC4K/ZovGG1khSwFjty6+A176j+DlFU5sBikGGN/Mf1FZF29fU6UlcAyY7kIzYU6GOmPMk8hSdyat0WmzY3NY6c+JmDb2Q7igLtg8WMt3EF9AQmEuUOOPNuvt5+4k0GcygiflECywUnEMnL0DxVWTqlOkxe1syLTuYmKYxE22693RjbIgf5txCtOiGL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(376002)(136003)(396003)(366004)(39860400002)(346002)(5660300002)(4326008)(33716001)(66556008)(2906002)(8936002)(186003)(9686003)(316002)(83380400001)(6486002)(38350700002)(478600001)(86362001)(6666004)(8676002)(53546011)(52116002)(6496006)(66946007)(66476007)(956004)(6916009)(38100700002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K7FhNlpt478o8AVqttZtSxPmAqXbkLJnNFJ1dGPwI6v88IUCoYD/ewF6UeqV?=
 =?us-ascii?Q?CZKMAxpRNui5GxMHzvRxN8fvD7sDxCg7t+mg+LaecdGPjJPJNyb2QQrAC/9x?=
 =?us-ascii?Q?t3hWH9u02LeaX/tgviGYJFMWr2SQUfsfYdyrqc956VXyVmo70d8Klupxp3Qu?=
 =?us-ascii?Q?8KTZ387L0d1XHFP+tlP2Vf/wcD/oMEUrNGRfV1ROPLIEVJfQp6oZJ4/jp298?=
 =?us-ascii?Q?s3lBMW0GX8vdSTs3a/Cm0/QcMA00q4Pd4PlSTGP/Hh8+wx1w2S5JvUn0pwQU?=
 =?us-ascii?Q?y+AyidBuG8xE5vADm0jzCN2DoVLRxCm0eIYUEg5PkMCZWvtiasMBmr2gIClr?=
 =?us-ascii?Q?7lEIwY+UukN8aVc26QMDpm+Lj3T6GlBSNWi/RmD17a5nif3HVUIPKbBaMtOn?=
 =?us-ascii?Q?3U7R4peh0y93AowTNl5pkOb3uae+4FV2Ute5gGK5XhhCHKlI4PLF8N0sQhLr?=
 =?us-ascii?Q?Awu8eGax1684E2NTnb+mkZXYdvbkAu1hOzhE4S3riNGJiFE9vc5bpev34zJt?=
 =?us-ascii?Q?6DSRZHx1aoy3A8U0xGn0B+ycxixb9bqMuC4lgtIcNa3LVADREaXg6+MmG36h?=
 =?us-ascii?Q?mqKKWscG9DTFf0+Gi5MBOi/OiUdufC/271UYfKnfiaf9ojdIzVMctWDLBWat?=
 =?us-ascii?Q?WJUxu9WkldR3eq/drc89PVK9QKNp/5fCjvexsG70TIwa0hCBOmh6QTg8sThn?=
 =?us-ascii?Q?xakF32r9nHY8Brz1aFzUns/X3X9AylTQDxygHq+bLc9Fc5+hZuF2UoBsuMzV?=
 =?us-ascii?Q?hlMyijuMnJJhaxXgT5whmm4w2qIGxKAWhJreH9GH19Q2WuVq12LtUSVtGD6C?=
 =?us-ascii?Q?nWiJ4oLkBNV/esqwUQix1ycglZP6EjngLvsQu9VwzphzouWvppzUAK/cVZzX?=
 =?us-ascii?Q?HqQBcDmBqa27o753gvLCDOTxP9mTmIBfA9utGB9uPLyaJp02ivLccHpmI6mv?=
 =?us-ascii?Q?zkRYIaJOegJ9HxtnlAOdSF1CfZqXOgZtBODobGwG4vP2Xyqkq22SO6xiQAwm?=
 =?us-ascii?Q?NSLVd8GUBrccrEQRQMvfm8tRGXhASVPci11hYyrkTEGOcHH6X0gUERPE9Wcv?=
 =?us-ascii?Q?RFz/zTSd9ZPDbIy1ETTDE38+H02JuwSGLLr7CbNlRTiUM8Cv9yt1r1DtB6MD?=
 =?us-ascii?Q?Z1L9seLAclQrFQ0vKZdh3K32T/0U91hx8eRVTxZnuCtkQVRHyLlOcG7AkD+B?=
 =?us-ascii?Q?F7DFd3yg2IM7HNYgEWXoLnE77y8F3iZoUad7a2CBG5LsGevl132JOpxb2yjJ?=
 =?us-ascii?Q?VJlq9aABkiMCUSBiKau/LtpArlQrAiXcyE9ppPO/b5IsNFzl0N/deA3wgDHZ?=
 =?us-ascii?Q?9tOqeCe7mmvdA0BzrAE8NPe0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf0d7857-98c0-4d4b-7d32-08d97a55871f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2021 03:36:41.0897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGKni7DLB+Pm+NFHiwfvj0z9VgCLgO+fmbl9uyIO3QKvc5Go4S+85sBOJsTaaI5MX8cmkESFOm3fUjEveZrdXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5606
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10110 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109180021
X-Proofpoint-GUID: 0RrSuVIqCRuyp4ddwAgD2riWSpe4uIJ-
X-Proofpoint-ORIG-GUID: 0RrSuVIqCRuyp4ddwAgD2riWSpe4uIJ-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 05:33, Darrick J. Wong wrote:
> On Thu, Sep 16, 2021 at 03:36:35PM +0530, Chandan Babu R wrote:
>> The commit xfs: fix inode fork extent count overflow
>> (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
>> data fork extents should be possible to create. However the
>> corresponding on-disk field has a signed 32-bit type. Hence this
>> patchset extends the per-inode data extent counter to 64 bits out of
>> which 48 bits are used to store the extent count. 
>> 
>> Also, XFS has an attr fork extent counter which is 16 bits wide. A
>> workload which,
>> 1. Creates 1 million 255-byte sized xattrs,
>> 2. Deletes 50% of these xattrs in an alternating manner,
>> 3. Tries to insert 400,000 new 255-byte sized xattrs
>>    causes the xattr extent counter to overflow.
>> 
>> Dave tells me that there are instances where a single file has more
>> than 100 million hardlinks. With parent pointers being stored in
>> xattrs, we will overflow the signed 16-bits wide xattr extent counter
>> when large number of hardlinks are created. Hence this patchset
>> extends the on-disk field to 32-bits.
>> 
>> The following changes are made to accomplish this,
>> 1. A new incompat superblock flag to prevent older kernels from mounting
>>    the filesystem. This flag has to be set during mkfs time.
>> 2. A new 64-bit inode field is created to hold the data extent
>>    counter.
>> 3. The existing 32-bit inode data extent counter will be used to hold
>>    the attr fork extent counter.
>> 
>> The patchset has been tested by executing xfstests with the following
>> mkfs.xfs options,
>> 1. -m crc=0 -b size=1k
>> 2. -m crc=0 -b size=4k
>> 3. -m crc=0 -b size=512
>> 4. -m rmapbt=1,reflink=1 -b size=1k
>> 5. -m rmapbt=1,reflink=1 -b size=4k
>> 
>> Each of the above test scenarios were executed on the following
>> combinations (For V4 FS test scenario, the last combination
>> i.e. "Patched (enable extcnt64bit)", was omitted).
>> |-------------------------------+-----------|
>> | Xfsprogs                      | Kernel    |
>> |-------------------------------+-----------|
>> | Unpatched                     | Patched   |
>> | Patched (disable extcnt64bit) | Unpatched |
>> | Patched (disable extcnt64bit) | Patched   |
>> | Patched (enable extcnt64bit)  | Patched   |
>> |-------------------------------+-----------|
>> 
>> I have also written a test (yet to be converted into xfstests format)
>> to check if the correct extent counter fields are updated with/without
>> the new incompat flag. I have also fixed some of the existing fstests
>> to work with the new extent counter fields.
>> 
>> Increasing data extent counter width also causes the maximum height of
>> BMBT to increase. This requires that the macro XFS_BTREE_MAXLEVELS be
>> updated with a larger value. However such a change causes the value of
>> mp->m_rmap_maxlevels to increase which in turn causes log reservation
>> sizes to increase and hence a modified XFS driver will fail to mount
>> filesystems created by older versions of mkfs.xfs.
>> 
>> Hence this patchset is built on top of Darrick's btree-dynamic-depth
>> branch which removes the macro XFS_BTREE_MAXLEVELS and computes
>> mp->m_rmap_maxlevels based on the size of an AG.
>
> I forward-ported /just/ that branch to a 5.16 dev branch and will send
> that out, in case you wanted to add it to the head of your dev branch
> and thereby escape relying on the bajillion patches in djwong-dev.
>

Thanks for doing that. I will rebase my patchset on top of "xfs: support
dynamic btree cursor height" series.

-- 
chandan
