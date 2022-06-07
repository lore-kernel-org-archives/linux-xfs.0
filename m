Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00802C43334
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jun 2022 09:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240313AbiFGJwb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 05:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240255AbiFGJwX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 05:52:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16CCEACD9;
        Tue,  7 Jun 2022 02:50:54 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2577Cx8B025900;
        Tue, 7 Jun 2022 09:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ow2xbkJe88O2w9T03jixTLQGn8SNe0rziHJWyYxCYnA=;
 b=ri/D1zL1rzW6j6A1NjIyWCx3r6yN09S/eRai727fdf82opD9TTF9sASwSE8zvAhbABjc
 Fk7qpsCnafo2WIYxSPQVh4kQ5Ps6HMOokEPaDhd19fyLv4e2kSA/PuWKTmcAHd4IrPeN
 8FuoSdpphmkLm0ySLX91XJBtPpQnDDGl64yDop1Bf0zVwBi/ZikGkla1wsbjYYxI1MwN
 7wZezzPurk11TZzf2HHVEkUF5YpBj3FZsS81xApYxDAK1YZ4A2lIc9QwWmS7gbr1S0M1
 fxnjQg7yH7IYpyOcNVCExd6ok8lHWmg7mI9SJtbrDQZjFT/22RyJfauFqMISIONDL7uj hQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghvs38ukm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 09:50:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2579oQdT034077;
        Tue, 7 Jun 2022 09:50:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu2c2df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 09:50:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luzFOIBiKgPKFr5JIYDfUxWfD0Il6Nd5seiflm0LLXIcRqLxUzkr6cSHwGMj/FKI2Wj1zQxEiRrDi50UCIbgTit8NrllWO0Gij4QYaBZNto07EO+SCfgC+xyScXCmAsnjco0HD4d+keZ/krJOao9Z3XRBaL0P2JBl1XCCKRLSqYxHyEv0f9p+pJv6v/gRkT6pujFLWag+HAghOZmRQChHK+g840sPbtkqlwfYJBMozUzsUWMugfemxNz7i7V5K7OnbKPSW93qRZ5bdZxJgg6cBWC8eA+0WhItrxSy2AfO5hUDy+DSs/rSK5QgIA5kBGooVIh0ZbG9w/Yeq/BUAMEDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ow2xbkJe88O2w9T03jixTLQGn8SNe0rziHJWyYxCYnA=;
 b=PUg4mf7tDb7dS4MwlN5XXs+KwjzzKhSJly2fjUOQU//0WGOKEwvdOmM2ERUcPCUFr15orhhgL9YAeflmKi3sJ0CROXuguWCKS8eJaZnsSW7MJ+Ss2PTuB5zeCvMlmoUeBmw8zCgk6icPu5KaMuToJ83cwmR1eoYzPAR4111GpKFQhJhjyDSSOMcJzZw/hQ/00M2aJ4twIQ35jP/unVIjXS34pg1DaK9mVy5ldjdByVODub4jLP/VXYqePQknVi8TANFrsxusNOG3nj1AMcvBxUoBBcajzp8jhb4sMaF0/cqXMlkSkJXZWHrUh9B0izRHF8u/aS/Uk3nJJ51qB28MoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ow2xbkJe88O2w9T03jixTLQGn8SNe0rziHJWyYxCYnA=;
 b=bZISnSwcNWnr9ndjXegLCwr9TaUgGqbMYDbaYxChsehRlIVdmCc+ZkoA7KxiYgsX4q6QzjayNjqJzU1iR+238gKcqeViZjPqH56zZEs8W1PWjeo2z4bS/Blz+DqEAiw4tY7VWbFbU3wrP2XSXbaOzNQdNCOBNPxyyWvKLpOQBLE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CH0PR10MB5180.namprd10.prod.outlook.com (2603:10b6:610:db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 7 Jun
 2022 09:50:47 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 09:50:47 +0000
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-5-chandan.babu@oracle.com>
 <Yp4etwsUF/B6aSbe@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs/548: Verify correctness of upgrading an fs to
 support large extent counters
Date:   Tue, 07 Jun 2022 15:17:01 +0530
In-reply-to: <Yp4etwsUF/B6aSbe@magnolia>
Message-ID: <874k0wol8x.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0001.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de47ae85-ac46-47df-5a82-08da486b3296
X-MS-TrafficTypeDiagnostic: CH0PR10MB5180:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5180A26EC56FBD1D5065D182F6A59@CH0PR10MB5180.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dgu+0aGYijVWfDO1CiKvConAamtwjWQimDKU0iLH2MTeyjlSz7lQCv86PLWgz8RhXEKXPxXJRQDEpEJpFDdBuuvkeI17VaEPr+mMrBZmFWOR/iZ5POQ8r6gZaeAp8kN9xwJk16z/V45p2o5QeY6DV8rz07RX3uzIb2m/XH9tN3DpLU5Czm1va7qfN9QyxzbvDLdGbfZj51KYgIXsQX7c8dqQ0Q1Ej8E+NjOJEbpiS3jWwPfwD9YatLJrn4J+//xhvQRgmluQuf+AM/6MD1Qc4r60WnFjloEQL5QA1F7TIoWHidtZTpd52b21nTQPbhVAM67/0Au9YAjNWs5xyGdVrvx0EM7o2Nk+6/Tqcz0SAYCVDL/TZ1AGCmGRlN7IuXGmzNF2cKe8117lHIOGUFdukELgQeBU1RrsLgat1GTrI2fyQ4h4TOjdOTrbgC9lMxG/iik6hP4C8Zpsbsf9lxIQo7Vr1pZKMEWTV6SsYK3nbJMKRfY8eew0zdcAS5G/vODrQZdNEBU4PDntoEWJN4Mbx6mp3AovOI0jntJBDrI16Ug8AeR+QtRk2QEDauA/ooosBTqlTePoj0uXWIiHDZrACdD0SYNgXHIlMSmw23Jntos1B9+AAlV7vPONmc86d1IMjjFJ9IBosm1lGfrtxwTshk5Ab5V/7Zix1x9J7vxSICjwnHOJVavpt9Vng9Ghio/gi7XTQQux+SeQuSMHoOjLnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(66946007)(66556008)(4326008)(8676002)(15650500001)(52116002)(2906002)(66476007)(6916009)(86362001)(33716001)(53546011)(9686003)(6486002)(8936002)(6506007)(83380400001)(6512007)(26005)(5660300002)(38350700002)(186003)(38100700002)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fcJCCmZGSic5ot4u1hJf6NJFw8tv2pe0PFRV/2S4C/z2lItRaltwB7DCkyEC?=
 =?us-ascii?Q?gc60I9lYiEvGJfrdYsSG1PMElt73ZHiqIohonFcXEXqIse2O4IdM/ih0Jw3z?=
 =?us-ascii?Q?wuGO4hPdxQJJC0vZFYBBddbQME9hF/b1o8PvcAVt2F0zNppjdePgkQa8DxS1?=
 =?us-ascii?Q?d5E2Mbsn9hEIsaCWgSl8bz+JBj8MKXQFkui2qGDWJC9W8Bk2OirSDXAFo0SO?=
 =?us-ascii?Q?QsrM6zt6rxz9s1H/76VTJTjpXORSp5akQOPcTb2MWs1HkgdN2FjKTnC3/3Bs?=
 =?us-ascii?Q?iiaOtdBvjUBQOe5xuMS23xhvOnDNin/QRJ344d+wr4wgJxzQSKhJv3MjD7Xp?=
 =?us-ascii?Q?uoTDzeD/p2tzaIwDtW6WsTFddXJ184SOfLjCLLCubwilKxTou73tvCZVQwQy?=
 =?us-ascii?Q?MFKCCWnRMnrypJlPFdrLUHYTLMvjlQiLYwVoUDhesvOpKVAyUevuObo3Cda4?=
 =?us-ascii?Q?VYjMvGa4DJuwzTBwcoZVIrxOwcbhWPM95210kQQAwlY8ryR/8oMKlS4ELFol?=
 =?us-ascii?Q?3tTdrOrMCZXJ30s6p8Swdi7we8toEMBXFshgFk+tASPNagkHlMLk0M9Ggivj?=
 =?us-ascii?Q?D+3Z2izbe+/aAfd1LJnfLq27CJuojP8AKTQci1GB3s74VLG73hSmmRWddHWu?=
 =?us-ascii?Q?Dxl9dLYC4/+taQVf4dhhS9dWcm0RKmxwDlwywlbxjBOSXTkLtdLpd5c8u5jN?=
 =?us-ascii?Q?sucSQJKevGE4hl2v+mf1oPnuLikzTlCQCkLOq8U8IGqPezInhHmWSqjqWXUY?=
 =?us-ascii?Q?CCOOHRpYCH605FPcg9PUG9hZ1HnO88d8O1TNQRmhUheXXeQxCx+6JWLYE13N?=
 =?us-ascii?Q?YblICwPPdqEW35GY93PnHw0Vsv6JmSBGx7B/3aGVr9v0lp/AUfCgxCTzqGzN?=
 =?us-ascii?Q?aakg/VGIsQrO/cj4yr/bbidkGXCGMt+wKFntkcUEyqkVmuNDWfq1MfsLbzY8?=
 =?us-ascii?Q?l4NPQiYnMPWSbq0JXXXQ3wTJMIwg0LRFifn0HHIcXaYp4/VKR0YtBGQR5/aC?=
 =?us-ascii?Q?9h4d4U9t6W/bCgKT2kqTdDQoIaGoqMmRtp0fd7TZddZMNzCGBaUJuc5sQm9P?=
 =?us-ascii?Q?9WGhM/mxYJFoquTudKgBgYITRi7gjjHglofKAcCjo1vruMYc/Tjztq7dTVpS?=
 =?us-ascii?Q?Fx2LUN/gdQQH8TN0nD563+neZVOAb0nB/2+3Ra1ie2hivKNc22cJ0b5bWpdp?=
 =?us-ascii?Q?mXP7nIoC1l8bOm5i/HLbKRuwR0043jAEcfmdFoK42NFQ2JzIqMJPN41kTCdC?=
 =?us-ascii?Q?TdQ4JfMFr+37HgXNmLCjF8YUCQhj3K1AVgCk2bzQAvTXzzSuaO5lOZNm97Ku?=
 =?us-ascii?Q?qh66LHfDd7qeSAms1E7oaJgTdVFOwQb4r59aQ8ILB7kLypffFdCgZOJ5TdMj?=
 =?us-ascii?Q?QqiNUvEm4YoVfW/6O4GgrbXoFlYzIIxGFy5hrHknH8U55n/NmXEQ6RWYu83d?=
 =?us-ascii?Q?VPkElv7FR8HvBuifWyxtBn4yhh3PdoolP8uSupDCC8alinGAapeaJEEYoWZj?=
 =?us-ascii?Q?zCtPwheYfCegbK3Od+xEPperSnZ2vWmflepLYGsrJKeBxoDdHS3XRijOXF8T?=
 =?us-ascii?Q?tFQzx9MXUptNMyojeE2sIAayUSNjcy1qzfPs3uYTIktr32bia7bLV4sMHYqv?=
 =?us-ascii?Q?Z5G6S49gqQ2sgbo72Gp/aEfoZKWMdbfG+3a0eoisffaI7afvtTdjL/WY9liQ?=
 =?us-ascii?Q?KSnq23imG+cS3bYX57W9pfeDidn7VnSbZLDKZBWHNbdAOajiFXiYmzmj0WeL?=
 =?us-ascii?Q?Vp9ndA+w/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de47ae85-ac46-47df-5a82-08da486b3296
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 09:50:47.7978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yQjjX74wU4+SgQB3jVOaD30JPLGz6135QFYDzmfRmydHerleIQ2Bw9CF24pCXHAnOiIwx+INltDJyI0h4q94+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5180
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-07_03:2022-06-02,2022-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206070041
X-Proofpoint-ORIG-GUID: mdFoeEYLWRaQQmD8vKGQfm_fMHtEpxGW
X-Proofpoint-GUID: mdFoeEYLWRaQQmD8vKGQfm_fMHtEpxGW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 08:35:19 AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 06, 2022 at 06:11:01PM +0530, Chandan Babu R wrote:
>> This commit adds a test to verify upgrade of an existing V5 filesystem to
>> support large extent counters.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  tests/xfs/548     | 109 ++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/548.out |  12 +++++
>>  2 files changed, 121 insertions(+)
>>  create mode 100755 tests/xfs/548
>>  create mode 100644 tests/xfs/548.out
>> 
>> diff --git a/tests/xfs/548 b/tests/xfs/548
>> new file mode 100755
>> index 00000000..6c577584
>> --- /dev/null
>> +++ b/tests/xfs/548
>> @@ -0,0 +1,109 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
>> +#
>> +# FS QA Test 548
>> +#
>> +# Test to verify upgrade of an existing V5 filesystem to support large extent
>> +# counters.
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick metadata
>> +
>> +# Import common functions.
>> +. ./common/filter
>> +. ./common/attr
>> +. ./common/inject
>> +. ./common/populate
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_require_scratch
>> +_require_scratch_xfs_nrext64
>> +_require_attrs
>> +_require_xfs_debug
>> +_require_test_program "punch-alternating"
>> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
>> +
>> +_scratch_mkfs -d size=$((512 * 1024 * 1024)) >> $seqres.full
>> +_scratch_mount >> $seqres.full
>> +
>> +bsize=$(_get_file_block_size $SCRATCH_MNT)
>> +
>> +testfile=$SCRATCH_MNT/testfile
>> +
>> +nr_blks=20
>> +
>> +echo "Add blocks to file's data fork"
>> +$XFS_IO_PROG -f -c "pwrite 0 $((nr_blks * bsize))" $testfile \
>> +	     >> $seqres.full
>> +$here/src/punch-alternating $testfile
>> +
>> +echo "Consume free space"
>> +fillerdir=$SCRATCH_MNT/fillerdir
>> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
>> +nr_free_blks=$((nr_free_blks * 90 / 100))
>> +
>> +_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 \
>> +	 >> $seqres.full 2>&1
>> +
>> +echo "Create fragmented filesystem"
>> +for dentry in $(ls -1 $fillerdir/); do
>> +	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
>> +done
>> +
>> +echo "Inject bmap_alloc_minlen_extent error tag"
>> +_scratch_inject_error bmap_alloc_minlen_extent 1
>> +
>> +echo "Add blocks to file's attr fork"
>> +nr_blks=10
>> +attr_len=255
>> +nr_attrs=$((nr_blks * bsize / attr_len))
>> +for i in $(seq 1 $nr_attrs); do
>> +	attr="$(printf "trusted.%0247d" $i)"
>> +	$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
>> +	[[ $? != 0 ]] && break
>> +done
>> +
>> +testino=$(stat -c '%i' $testfile)
>> +
>> +echo "Unmount filesystem"
>> +_scratch_unmount >> $seqres.full
>> +
>> +orig_dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
>> +orig_acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
>> +
>> +echo "Upgrade filesystem to support large extent counters"
>> +_scratch_xfs_admin -O nrext64=1 >> $seqres.full 2>&1
>> +if [[ $? != 0 ]]; then
>> +	_notrun "Filesystem geometry is not suitable for upgrading"
>> +fi
>> +
>> +
>> +echo "Mount filesystem"
>> +_scratch_mount >> $seqres.full
>> +
>> +echo "Modify inode core"
>> +touch $testfile
>> +
>> +echo "Unmount filesystem"
>> +_scratch_unmount >> $seqres.full
>> +
>> +dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
>> +acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
>> +
>> +echo "Verify inode extent counter values after fs upgrade"
>
> Is there a scenario where the inode counters would become corrupt after
> enabling the superblock feature bit?  IIRC repair doesn't rewrite the
> inodes during the upgrade... so is this test merely being cautious?  Or
> is this covering a failure you found somewhere while writing the feature?
>

I was just being cautious w.r.t "Large extent counters" functionality working
correctly. I used this test during my development to make sure that I was able
to capture failures before I ran the entire xfstests suite.

-- 
chandan
