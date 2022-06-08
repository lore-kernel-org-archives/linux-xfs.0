Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A590C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 09:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiFHJug (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiFHJuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 05:50:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E265F39A645;
        Wed,  8 Jun 2022 02:19:01 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2586BaBc006530;
        Wed, 8 Jun 2022 09:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=QYf//zO3WgjEh7Q4oBIXfy/P5pYC8RgDc1SOhLtUfac=;
 b=zvW5lVkBBWoG7SLuUTKz+2YvlJ792IQtiJIaYBQylgBY3LQDWeqpUbaD2puGjR5l2wyz
 hr/IUf+0Ws9ZpAaCnwEZi482h6BuFeqnr+s9axJkPsOrHUcqs9r4+dlGPfWqKgsHPsDk
 +Da6x7hvUNE8JpLKaJG6JBPpoJB7EI09/EzYSUi7zvR+DovSkOu/gBIuFtWYhaO+QuL7
 NwGN6lkwp8ml18fHeKAzUT3FHR8RB1Vm5x0k3x+z00ZMzYKw4stJs31WtGxBFZIZGhSA
 gXSYSjTbB+eLqget8xHNSUHQqvfvXUBJTeOXmOlNCxysken/R4UT4gISGO/XTlnWvsD5 SQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghexedbx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 09:18:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2589CCcd019702;
        Wed, 8 Jun 2022 09:18:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu3fgcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 09:18:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxRTKEZDvPYn4Atp0oh890fkglGLvKdwr+GkCEL40dc0d/053hUNfG7mRW+10rUEhpOqXPtFfAKm30HeSmdd1lMdKhArnrz5gv1/TAbYfNhCAHlIZsLk7e2bxECTd8v/SbAxCFWpcZCCwQrSN2itp0egCNJ13B2LexTtv986iU6tPBg6JP531vGyeKi00iFDi1M5H7Ir/zq/a4mVOhoglQEF4GlbisrxaoZJe0hF1purIcHC9LN1/RtFV0olUIlUsJonXMlTHXT8NlL7LJkd+plQ1rf7LG5qT/LJHaeEO1MzHE4pHAIq0ousQz9gWN8xY4CFOFX2xM/LAIt/KMVy1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYf//zO3WgjEh7Q4oBIXfy/P5pYC8RgDc1SOhLtUfac=;
 b=bDzBufWGN4w0Ct5kPGoR63afirAK3IkRYaRqihBy1frGojOWHyoRIvX9rj3ON9g4+AmdckoayCb2buoPuBa9Oy4Sn3gtay2gcLN43J5HrJfh37+jUiS226kPMANohzkuxgxiSicujwoAh3VuGWgJi/8N0o874/ZyGvBBsFvMi6fmQ+mAep/4O1btf416fvM3puAx4X4CIXBsm1oK2My3AANPdyH2c2XM9i9+GWJZS4flpay4sGAjBRb/xFBcpB/dN4p/wRYzNuM/RMnNtNE7A/EisT1VEyWhtHKyfcpPvVZMQvuTFKSq8tz4CdW0eivuS/I9viBVYOWw5/qpABEhBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYf//zO3WgjEh7Q4oBIXfy/P5pYC8RgDc1SOhLtUfac=;
 b=eqoU4BkqouOuV6Uwa0NFbtPeKVPqpUY06/ZwaGxutdeQ/5d7smSsiQRVtivDD6YV85HFqLHx9htySO97GqewXQwwTCKdqIRM3WO4sRhfusHayul7fG4ESs9oS50jd2vIE4+p996+Ce9/8ta7s4Gdy3goNPoy1pjUOakcx3hKPpI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN6PR10MB1700.namprd10.prod.outlook.com (2603:10b6:405:8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Wed, 8 Jun
 2022 09:18:54 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 09:18:53 +0000
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-4-chandan.babu@oracle.com>
 <Yp4f/yalwFunfEgz@magnolia>
 <87zgion6nx.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220608035933.rcaevihjijarst5v@zlang-mailbox>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/547: Verify that the correct inode extent
 counters are updated with/without nrext64
Date:   Wed, 08 Jun 2022 14:41:44 +0530
In-reply-to: <20220608035933.rcaevihjijarst5v@zlang-mailbox>
Message-ID: <87pmjjfr7t.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0035.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::21) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b2d1b3c-4fd5-41d9-5378-08da492fe82b
X-MS-TrafficTypeDiagnostic: BN6PR10MB1700:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1700E7CFA7E852D15282DA0BF6A49@BN6PR10MB1700.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pSp+IdTZcjxmhi21v4eaZNHA0JVhZ+pnjvumjW0IvTreoePpco+ZKFD0MEJJagp2md89a8UVKjG/mfp6Hyh7m+QgjsmDa8hd03t3ALf73r40z2n2P3Cl+9Wi7pW0/yiIUD38d6AsYKL0V4xEtXbOqJ9owlWyFZD0gdaNOTAbfLdjd2S2YjqznQK1qeCrgdE/NitMlxGMu530/x+KVgZ5SoSCWO9hJGfllrLzHCKsjmhhT/GqnwpFFyV0g9VkpGYojN/CVQhln+lmGFv8W9HGd03Ax2w7FsxRy/rM9EE37slasFqrWQFAV6DKE6hwXoB0cTEhKSzyZe2Vk1SsXWQvb4FyohAo3RmEBU/qfArHktqLhJFf+Y7z75Et5i9GFVbsp6z14zOmTbNsV2sMSEdWhzA5btlLGYoB5aNYhQRFJVfnxNeEP39fNuQsFdeFI91h2kkYysrHxHiv5V4wz6KrPOxwdXf0Yq2Ro1BxY9nIAVyVaROvB6ZXIuy1LcnhDBbRNKasB3xBgRwmBfNAvK9PrRLcAF0+NZtLvd8LJ/s7J+Pzg/Co6KQcEJ34LxtT/yUlD7StA5TRjfCcx9ikSyLWdw+r3m0wceXwmXvJkmZ1gyBe3s1ht+9UySj+xhJR2KyW+zewRGCetwS2WeFbVa0DdGTty1a9jGvp8Gz33sEJJEUSzcT+JTmfaiqsbKzDISOdxDpzrjDioh+rLiySD/iS3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(52116002)(316002)(8676002)(6506007)(15650500001)(4326008)(5660300002)(66476007)(66946007)(8936002)(66556008)(6512007)(26005)(9686003)(33716001)(6486002)(186003)(508600001)(2906002)(38100700002)(6666004)(53546011)(86362001)(38350700002)(6916009)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dfIGWS0bzAWmTTiXw8ICFTKuAojIAap70SvCN6HIVubJXvtw8qvlKnNkdRvL?=
 =?us-ascii?Q?bPFuPA0uYVzdF8gRhorjr6hrHlVMo+epsKTLZEOtdbXvMcjZT74ERhdtcBGG?=
 =?us-ascii?Q?aPONAQ1JZHVg/fMt4O1p5GNlYsHedAn8B1sF+L4GwZqehQzY0M1PGgSBLAJv?=
 =?us-ascii?Q?20uPYuf66yMJIoXlEOoYOjjvlD5L9XMoKckUFMfL5MeezzYBUbn+FBLSB6/+?=
 =?us-ascii?Q?t6JVLGrpCuIdtVn+jy2cOZ27gCrF8AGbGXe8M0T61Vqn288Ml1W/GfwTV0QF?=
 =?us-ascii?Q?r0ZreoY6v2xj1W9i9FzAWnRUYxyQAEVbFpCCF6vb2Fz0vKM3Ba6BlJQ0e4Ru?=
 =?us-ascii?Q?DmWmOUeXHHUdOjO6tU3yqpBPYIX31sCOQdIGpz1ijDtqpaX+TRzKLNtxuSZ7?=
 =?us-ascii?Q?xS0dmtybV0IJBEjrCIrGtMhhoWhXI4KwEBGbcnw2FFOyTmPK4h3GFDo8buRO?=
 =?us-ascii?Q?GHUufMnwkk2DvpH0YlvXW+BC0klXPip3vXlCgrSpuaNRRNrCujNaFaZd/M07?=
 =?us-ascii?Q?YZ6zN54pyxWJNc9SGHRk0V6KKKd8TTBHIq9Z1iqMVzdwZVnFPC4HnbPYah2/?=
 =?us-ascii?Q?hWoQ05fEHKnugRfSTFblza6MUY/epQjpj4qQDlfTy3vXCWV7oaW57POGzQYZ?=
 =?us-ascii?Q?TCO8RnkgyVD8XaM7zn/TTrBHO1t51cW4I+rKqovy6plvvnQ7RDirNMR+9qL8?=
 =?us-ascii?Q?3OGQJ+ttovfd2SyH3cjjtCgqWcz7XWW/4/qH2N74s6dNu8RnZqWBsvaZGBCC?=
 =?us-ascii?Q?1l1lh8OXSLs/z1QL7/ZFrh0Q0CkgIm/NFqR4Ph/3LxAbTJgo7yMIbKzwKdMJ?=
 =?us-ascii?Q?zoIKeESVNgq4u7DqeFaPKRh1eisltRbM/prXXxpNy1a2E20nNbY87iN4Dek8?=
 =?us-ascii?Q?+7tL4rHIFfcAVfut/qNmWY1VLXHV9vbI3KH0uTqT7/98gtxXL+oKcHPj+OG+?=
 =?us-ascii?Q?fgtqkun5qC8yIDr6ftz+plZw6ya406XWMALOUZi3wr0L54QsRdkt2owL4zl0?=
 =?us-ascii?Q?O3AZgWXbZWBrT0E3U4gekWPdrByeeT7RKcd3ahNBTEh9rafLgEuF8+aA3LOX?=
 =?us-ascii?Q?3AII1hIEdJ0HeOsZsejibSo2PwyfgMVsfldmGTDw8mxJhicUBByHNuRpwVp9?=
 =?us-ascii?Q?9K5aNoYnotc6XBLYuI56g6qZh2bEwn6W0awIG2tGeiCvovOIrLk2k98VF67p?=
 =?us-ascii?Q?v0KznJoWt6cUap5GKBqOw8wuIecLHFyBzY5JTHVA/LsO9WCBEYrLKDyGEfAv?=
 =?us-ascii?Q?91WbQsS++bp252Ywwovki/5rFBWyfBFX8dpsmipVbarSE/n+B1SYvIU2IQjp?=
 =?us-ascii?Q?/wxsDr3i3EqO12mq1rC9nCpNIrE6+p7aa/CkD7tO1rTtRXuRv4UOSOUmOska?=
 =?us-ascii?Q?gOQXQjiTrZaxrCQqaNaRXIdV8udC7pixOcPT0Iy1MtnWqkeIU/cYw8JTSbkE?=
 =?us-ascii?Q?AYP2TDPno94IAcG9ed3ZeBRv5A6acdfL1iQI7m9FIk4GSu5S9nmay7QOo208?=
 =?us-ascii?Q?+JaX+arlGi23+AwjbhJMqItmuQO6cmntMVb4G+RdpaJx6RvU9RPITY9EOn+l?=
 =?us-ascii?Q?E7UDzJtmPIHBdJOunmsIm6v+3qlKeScCa6yyZ+ntP+xJRWmL2Y6l1hiZhPbR?=
 =?us-ascii?Q?g7iGcxoZXI99Lepzm4lJXT+JNdVPezRRcYtVPoJgS5t/dhb493e5baeisLNg?=
 =?us-ascii?Q?lrLJFp1evpS8g/Agh8HyjxcSRKOeJj+IyCcQ5GJhKi+0MQQZz4ml0gmYdT/F?=
 =?us-ascii?Q?qQxHXqHqeA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2d1b3c-4fd5-41d9-5378-08da492fe82b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 09:18:53.7540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0sWSRTHwn4FmcgFxEqHby7OjQICYRy803R2PAO754tfhhyPFS+556/QCDF0T1soP6Utg5qUd4qOgpbmS2J6i9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1700
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-08_03:2022-06-07,2022-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080041
X-Proofpoint-GUID: vaVWnhjfmrXihLhPDPDfhTzjLin_hqwZ
X-Proofpoint-ORIG-GUID: vaVWnhjfmrXihLhPDPDfhTzjLin_hqwZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 11:59:33 AM +0800, Zorro Lang wrote:
> On Tue, Jun 07, 2022 at 03:06:58PM +0530, Chandan Babu R wrote:
>> On Mon, Jun 06, 2022 at 08:40:47 AM -0700, Darrick J. Wong wrote:
>> > On Mon, Jun 06, 2022 at 06:11:00PM +0530, Chandan Babu R wrote:
>> >> This commit adds a new test to verify if the correct inode extent counter
>> >> fields are updated with/without nrext64 mkfs option.
>> >> 
>> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> >> ---
>> >>  tests/xfs/547     | 91 +++++++++++++++++++++++++++++++++++++++++++++++
>> >>  tests/xfs/547.out | 13 +++++++
>> >>  2 files changed, 104 insertions(+)
>> >>  create mode 100755 tests/xfs/547
>> >>  create mode 100644 tests/xfs/547.out
>> >> 
>> >> diff --git a/tests/xfs/547 b/tests/xfs/547
>> >> new file mode 100755
>> >> index 00000000..d5137ca7
>> >> --- /dev/null
>> >> +++ b/tests/xfs/547
>> >> @@ -0,0 +1,91 @@
>> >> +#! /bin/bash
>> >> +# SPDX-License-Identifier: GPL-2.0
>> >> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
>> >> +#
>> >> +# FS QA Test 547
>> >> +#
>> >> +# Verify that correct inode extent count fields are populated with and without
>> >> +# nrext64 feature.
>> >> +#
>> >> +. ./common/preamble
>> >> +_begin_fstest auto quick metadata
>> >> +
>> >> +# Import common functions.
>> >> +. ./common/filter
>> >> +. ./common/attr
>> >> +. ./common/inject
>> >> +. ./common/populate
>> >> +
>> >> +# real QA test starts here
>> >> +_supported_fs xfs
>> >> +_require_scratch
>> >> +_require_scratch_xfs_nrext64
>> >> +_require_attrs
>> >> +_require_xfs_debug
>> >> +_require_test_program "punch-alternating"
>> >> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
>> >> +
>> >> +for nrext64 in 0 1; do
>> >> +	echo "* Verify extent counter fields with nrext64=${nrext64} option"
>> >> +
>> >> +	_scratch_mkfs -i nrext64=${nrext64} -d size=$((512 * 1024 * 1024)) \
>> >> +		      >> $seqres.full
>> >> +	_scratch_mount >> $seqres.full
>> >> +
>> >> +	bsize=$(_get_file_block_size $SCRATCH_MNT)
>> >> +
>> >> +	testfile=$SCRATCH_MNT/testfile
>> >> +
>> >> +	nr_blks=20
>> >> +
>> >> +	echo "Add blocks to test file's data fork"
>> >> +	$XFS_IO_PROG -f -c "pwrite 0 $((nr_blks * bsize))" $testfile \
>> >> +		     >> $seqres.full
>> >> +	$here/src/punch-alternating $testfile
>> >> +
>> >> +	echo "Consume free space"
>> >> +	fillerdir=$SCRATCH_MNT/fillerdir
>> >> +	nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
>> >> +	nr_free_blks=$((nr_free_blks * 90 / 100))
>> >> +
>> >> +	_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 \
>> >> +		 >> $seqres.full 2>&1
>> >> +
>> >> +	echo "Create fragmented filesystem"
>> >> +	for dentry in $(ls -1 $fillerdir/); do
>> >> +		$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
>> >> +	done
>> >> +
>> >> +	echo "Inject bmap_alloc_minlen_extent error tag"
>> >> +	_scratch_inject_error bmap_alloc_minlen_extent 1
>> >> +
>> >> +	echo "Add blocks to test file's attr fork"
>> >> +	attr_len=255
>> >> +	nr_attrs=$((nr_blks * bsize / attr_len))
>> >> +	for i in $(seq 1 $nr_attrs); do
>> >> +		attr="$(printf "trusted.%0247d" $i)"
>> >> +		$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
>> >> +		[[ $? != 0 ]] && break
>> >> +	done
>> >> +
>> >> +	testino=$(stat -c '%i' $testfile)
>> >> +
>> >> +	_scratch_unmount >> $seqres.full
>> >> +
>> >> +	dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
>> >> +	acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
>> >
>> > Note: For any test requiring functionality added after 5.10, you can use
>> > the xfs_db path command to avoid this sort of inode number saving:
>> >
>> > dcnt=$(_scratch_xfs_get_metadata_field core.nextents "path /testfile")
>> >
>> 
>> Ok. I will post a v2 of the patchset to include the above suggestion.
>
> _require_xfs_db_command path ?
>

I think I should include the above line in the script to make explicit to the
reader the requirements to run the test.

> Looks like the 'path' command is a new command will be in linux and xfsprogs
> 5.10.
>
> It's not always recommended to use latest features/tools, that depends what does
> this case test for. If this case is only for a bug/feature in 5.10, then the
> 'path' command is fine. If it's a common test case for old and new kernels, then
> this new command isn't recommended, that will cause this test can't be run on
> old system.

Large extent counters will be introduced in Linux v5.19. Hence I think it is
safe to assume that xfs_db's 'path' command will be available in xfsprogs
which supports Large extent counters.

>
> BTW, you'd better to not use a fixed case number in the patch subject, if the
> patch is a new case. Due to the number might be changed when we merge it. And
> a fixed case number in subject, might cause others feel this's a known case
> update, not a new case.

Sorry about that. I will add only the summary of the test in the subject line.

Thanks for the review comments!

-- 
chandan
