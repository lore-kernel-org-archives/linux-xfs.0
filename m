Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D37ACCA47A
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 11:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiFKLLY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 07:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiFKLLW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 07:11:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB5925E0;
        Sat, 11 Jun 2022 04:11:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B1hoUU021293;
        Sat, 11 Jun 2022 11:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=/edaxxTxfVmDvup0m7uiLWYG4r6SWz3OjcGSz2WwaLg=;
 b=V+5NxQaJfHWJjxJqbGUojmb7nwxh5Kk7tlqwMQfQNGIP9y/gps8jQjnmVLfxXeUshRN5
 t/fYIaBaEmbDosIzl9nfNIplVkugtb7JX3bNA68wgbNSNMCeyQhF6rcFBvXaygBvOyNq
 cPe0gmyBzKAJMmVmV4qMthfA3FhmhjKVLjko/ZpQp8eDDMnZqNnfMYudaVT9gcEB3cmt
 xC3TqU6c3u998QXiDzvzV+KoTgDQnn25v3Usah3zaiQbkj0Nhlr2xydPzZ4Yeb9JZ2+Y
 ErHHEG4C0skavaHlqQJda7VR+if/xeQQRaeQj4TFGpStwHUgKbJXszOcZq6TYWrFG71E gg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn08e73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jun 2022 11:11:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25BBAinM012617;
        Sat, 11 Jun 2022 11:11:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gmhg0q4n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jun 2022 11:11:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItC/iColtK7nCMLhs3NS83troOGKG9bf9h9W8sTgcg2hzTJoUu7a663cX/kXBws2X3FF+jNt1BNDYulqaJP/izEpZ3bOyJdvLJqcpuDCBYXoqzBHGqOfTANDB5PhBEh7AgBPxk0++yLJkypO56gMARf42JiLBtbxTNfb6jYR4b/LmK9k7NWj9eWa7DVy2BMM5gw7uPmzm5LFV6ntulNlI6nZYzg0doO5yaq1KD6qnWXZeg1LfGoaQvTIee87ZMpI8GTQn0j/JGQVoc0FImbPEWDqteHAqwffDxWMAzY17PbmIeqFhEhUsK7sRKiYFu3+3NYSweuyY8Q/AoskYEcLbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/edaxxTxfVmDvup0m7uiLWYG4r6SWz3OjcGSz2WwaLg=;
 b=Ies7QqnO0fDsUs7Pldz8z+oTg2DQw/UApcudelTVsfsOReGXziL6CmHjzoRHYVdcqV0ZfSvZp3J3J35Eja8RaVwi0bMhbIbTLY1dVTmg1/7CoU6dWqLNoAB+C+x0RAyDjeOcS5t6ehOIRHOBA/hu6epmgCTsr/BvdGBZgmMwTSnv5rfhBi7sJF0svFZreMh1sYZoUt3vQ4mNsYOS+quMNzgPnIlpJ33LZZgdx+H6KxPfjGwLL3pIhAt397iRyndZvI3QUIm9HL30eb+btEfSPJOyHxyu033zxnBR7lTlQ77jAT1DReaZW842CLRLoKNQqDpkjoYms8e5TZM0lE/TxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/edaxxTxfVmDvup0m7uiLWYG4r6SWz3OjcGSz2WwaLg=;
 b=nzo65ut6jA8tvr56sFDn0ABDCBHDqpNh9KUvjjXD1TDbyZO2cOqOFvI9yKRqVUntL4CAisXeO81ReqwkR7MrCYUdvrjf6sjaq4qd1uQgtUDLjnmf2TOgaO7B+jDgj/ZH1tpAzhoR9uCs9xQwCUsKlA0s6VFpwfuSQoj4w/WzJ60=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3313.namprd10.prod.outlook.com (2603:10b6:408:c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Sat, 11 Jun
 2022 11:11:13 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a%7]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 11:11:13 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        david@fromorbit.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH V3 4/4] xfs: Verify correctness of upgrading an fs to support large extent counters
Date:   Sat, 11 Jun 2022 16:40:37 +0530
Message-Id: <20220611111037.433134-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611111037.433134-1-chandan.babu@oracle.com>
References: <20220611111037.433134-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0014.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53e1fb49-f0f7-4609-d2d7-08da4b9b18cd
X-MS-TrafficTypeDiagnostic: BN8PR10MB3313:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3313EF109B11104F973E28EDF6A99@BN8PR10MB3313.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Txos/KHWS5zwJ0IgfGbPD59r6ec8+HLFIVuFuCymsLLqZRFOi6D/iAh1ES7xfre8qIjqEiSe0kSPIufN6vg/ml0ooBKGh04cZziqE5FNdmWLyugfhrM4tLl7uZUkn7o7H65MHUYYC+g587h3UkIfJdepQ5CbR4hGLcZSAoxaQE6rZjv7aLcM2XKLdV7dv58eYzewSZNIlrKVG0qC3nINgZmUheTawfp90uR0zqQqMzn0ioDTyPqrgSeaTQMPMXkzuLMUuUssYnhZn+Q9IRAA6UQLlI2P9zjncifM1HLrJ/m39SmcTBUiO0ICpIACKVhF52WlfoloPLNRvoqUdmYW7VQEWI23qJuhW73jUQdLm3+DisDkGfJ2u7XH3u71Q7LWLwT97/YZjTo2BqYGjTjOCg7KV1xVl1VreNwrzA7EVnAZ1lUwHJ6VstrJVqJ3O2+JTudD6QPnbeqt7GKXrMKJ81pr0Cm7b4kgYPs6oHbifn9co0aSkBrBeKPgiiG2mMcSqzJllx5jazjUsa7XNxhkiZ+mlAB7V/ohu1u4jd1KZWZkcIWjA7hlX9623LBgjop2NtbiK4T09o1LzsNMty2QuBq7xg4k6styverxOJ4v4RddkWDvZWRJ+dI/bYSfqlHCnSjy1XRcYO1uuhnUm26dE3htf7FRz8YpXA7nENGIo7a3/9l+oOvKGMM/woxvud2x8Vlh7oS3Qn1TR8xp7jqiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(316002)(186003)(2906002)(1076003)(83380400001)(6916009)(15650500001)(2616005)(36756003)(26005)(66556008)(8936002)(6666004)(508600001)(8676002)(4326008)(66946007)(66476007)(6512007)(5660300002)(6506007)(52116002)(6486002)(38100700002)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kf8ZUvZ7iND8S6SPizNmjAPonb4xaIomwenp2Y+xxi6ykbXTiCRIjsBJYOhR?=
 =?us-ascii?Q?HygyPbK+0F7Oef4wok0ir10Qfl5v6QliyEd01MjCzFjyKVMEdXByq+VDbrf9?=
 =?us-ascii?Q?IREE1uUwXeVLQYC0LRPTDOFzGtOfpiWdWsI78i3AhgyQgP2Xawc7wpBgMWHx?=
 =?us-ascii?Q?fGxwjMTyMg+0+6oyiR2Bq445wUL6v5gvlzl1iHpo0mTp0/DH5UboKRjQPEF/?=
 =?us-ascii?Q?NxP2IdZzerKWWdveVmCy1L++H5u/h8q3zCVMOOiG4DFUT3qCxYViRIEBxDQu?=
 =?us-ascii?Q?0fo6+1Fgdl8PBpDv70OfSbfBzaVKSPk6Le+mhrhi5IAkqKhqUPZLxvyZzPgp?=
 =?us-ascii?Q?VLK1l63Lwsv0MoIxqX00JFIhv16LIxyCX5FrVE8Hgqilq6nRS93wxO3lFwCF?=
 =?us-ascii?Q?y+NE78+vjiasl/9/ZdtQA+HwpylIpAHvGR6ot8XI9hrHL4c9U2sVlA7JJJSf?=
 =?us-ascii?Q?UlEZKrl0+mJ2eYcikRrLnPMgwnLcuk+Z4BFmIW94VtMmVF8MBou9ipGWc6Ju?=
 =?us-ascii?Q?2HqQT9F7q4nEB5j3SJ3vKI/IntYfK+GSOF0FdOx9e6jJCDrahUinv4IdEr/Z?=
 =?us-ascii?Q?wns3iWqxbbSRROgAH/29sKdkmPjEc5M1JGcPOquoSv/t49a5LynI3U7bf19a?=
 =?us-ascii?Q?slj5rHu9a2NAYgdtWPEY8vat4qSkfLTEFJ1EkS+dTrZ5Mk0H7kBbH8qbp98X?=
 =?us-ascii?Q?8zfTX+g9LWmmWMBTeKeJFAV4KLQYHQ1t02jLSPyEwVqUZXL0ZzZL/ZDtZX+p?=
 =?us-ascii?Q?+4tJ+BLgSD9WHYqeRAwnlSi04PL2JeETbu+ymoVjNhvloFkoOz1PWoQoVQC7?=
 =?us-ascii?Q?kUCzOrpazgzvGo/VwfLXViILrE/bW0S5raFqmvyE5L3aC0mc5S0M1rqyEoWd?=
 =?us-ascii?Q?zd+WkJIuVtmHMgHo5dg4LqjJsuGzr0GzylvGbDK+KmP8B4RfkO2BTqWDFy4Y?=
 =?us-ascii?Q?dSNf9c8AiBcEf/K3sSz4KzkeWhZnc0AJQkJQuLWlqFBRXYImMUH8EtfdJ9DW?=
 =?us-ascii?Q?BxyjL7Y1Xij3lZDXV1+oJ2IdgDaO7eOq6y4+EkAEqoBuEY//kEpBL7vfubLN?=
 =?us-ascii?Q?CJ3+F3jxkilZnc9S/IXzytvRRYJVhdKDnZmltPB/pbOpF8TZulafwDBtCpkR?=
 =?us-ascii?Q?jeCxDvwNqdb9p9JAxIw6X4K8P2IVEZNvFTfe+hLBvt35MANQh2HEtjga+fSx?=
 =?us-ascii?Q?pamw2bRYSHmK44yvuvFMXLtms57OQAOLOR44igTcp4f1zi8pAk4UZBmbVqsC?=
 =?us-ascii?Q?xu3JiETFXtSchWtOmsiS72mwUr0I6uXfUT8qLGHPcVQDfwk74WaEQGZ3mnwR?=
 =?us-ascii?Q?AUN4rFGV5Ck2O1xg+CY+ZPnSf0/EtE7uhI5gicJgtUZ3ZR91/gjmd994Uky5?=
 =?us-ascii?Q?iwVJN/ckPUnnQrggNh20SbOFypDAaAzK2UC8oAGgxxybhoTGTmxn8uLLG2lt?=
 =?us-ascii?Q?coo25HJcC5Hle1zU+eYEKYPYE/WPym+TdOzv7cUrGSNohVqt+rB3m82jvAkG?=
 =?us-ascii?Q?8bI5DISFUwYVosac2D8cH9IUEyR3c31X1O4k9SVaKlEZMPUxFc0y+oOhTVZW?=
 =?us-ascii?Q?Cc87c2SAnw4UCD15UJpX2HrwTmPIoeo7/ECeseJH3VocMjjWkNjbih8c3nad?=
 =?us-ascii?Q?YjaFPwinVcQccmAbiMiYhR2dTNUOkSURULNrAOymvaAqP48GylK5LlBL1Fhz?=
 =?us-ascii?Q?rzW+3k7uRQblSzhOmXekBgTKaZevduVS5AMEJkxGBPlBvHu5J+7EUsvqCFEB?=
 =?us-ascii?Q?v4edA7zHbBUc2utQwwiRLkpKK6a/CCQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e1fb49-f0f7-4609-d2d7-08da4b9b18cd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 11:11:13.6533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ABPAEoGR5fYTx3oH5i0W5YrOHd2OF8E9Nxr64Sd5VY7Re2EbIan+8pZGALWj61/2BBzDXI0XJvvb/l3ssbQgfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3313
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_05:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110046
X-Proofpoint-GUID: 8YOzFalHcchffX8B5UuDCS1TecLsU08g
X-Proofpoint-ORIG-GUID: 8YOzFalHcchffX8B5UuDCS1TecLsU08g
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a test to verify upgrade of an existing V5 filesystem to
support large extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/548     | 112 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/548.out |  12 +++++
 2 files changed, 124 insertions(+)
 create mode 100755 tests/xfs/548
 create mode 100644 tests/xfs/548.out

diff --git a/tests/xfs/548 b/tests/xfs/548
new file mode 100755
index 00000000..560c90fd
--- /dev/null
+++ b/tests/xfs/548
@@ -0,0 +1,112 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 548
+#
+# Test to verify upgrade of an existing V5 filesystem to support large extent
+# counters.
+#
+. ./common/preamble
+_begin_fstest auto quick metadata
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+. ./common/inject
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_nrext64
+_require_attrs
+_require_xfs_debug
+_require_xfs_db_command path
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+_scratch_mkfs -d size=$((512 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+testfile=$SCRATCH_MNT/testfile
+
+nr_blks=20
+
+echo "Add blocks to file's data fork"
+$XFS_IO_PROG -f -c "pwrite 0 $((nr_blks * bsize))" $testfile \
+	     >> $seqres.full
+$here/src/punch-alternating $testfile
+
+echo "Consume free space"
+fillerdir=$SCRATCH_MNT/fillerdir
+nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
+nr_free_blks=$((nr_free_blks * 90 / 100))
+
+_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 \
+	 >> $seqres.full 2>&1
+
+echo "Create fragmented filesystem"
+for dentry in $(ls -1 $fillerdir/); do
+	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
+done
+
+echo "Inject bmap_alloc_minlen_extent error tag"
+_scratch_inject_error bmap_alloc_minlen_extent 1
+
+echo "Add blocks to file's attr fork"
+nr_blks=10
+attr_len=255
+nr_attrs=$((nr_blks * bsize / attr_len))
+for i in $(seq 1 $nr_attrs); do
+	attr="$(printf "trusted.%0247d" $i)"
+	$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Unmount filesystem"
+_scratch_unmount >> $seqres.full
+
+orig_dcnt=$(_scratch_xfs_get_metadata_field core.nextents \
+					    "path /$(basename $testfile)")
+orig_acnt=$(_scratch_xfs_get_metadata_field core.naextents \
+					    "path /$(basename $testfile)")
+
+echo "Upgrade filesystem to support large extent counters"
+_scratch_xfs_admin -O nrext64=1 >> $seqres.full 2>&1
+if [[ $? != 0 ]]; then
+	_notrun "Filesystem geometry is not suitable for upgrading"
+fi
+
+
+echo "Mount filesystem"
+_scratch_mount >> $seqres.full
+
+echo "Modify inode core"
+touch $testfile
+
+echo "Unmount filesystem"
+_scratch_unmount >> $seqres.full
+
+dcnt=$(_scratch_xfs_get_metadata_field core.nextents \
+				       "path /$(basename $testfile)")
+acnt=$(_scratch_xfs_get_metadata_field core.naextents \
+				       "path /$(basename $testfile)")
+
+echo "Verify inode extent counter values after fs upgrade"
+
+if [[ $orig_dcnt != $dcnt ]]; then
+	echo "Corrupt data extent counter"
+	exit 1
+fi
+
+if [[ $orig_acnt != $acnt ]]; then
+	echo "Corrupt attr extent counter"
+	exit 1
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/548.out b/tests/xfs/548.out
new file mode 100644
index 00000000..19a7f907
--- /dev/null
+++ b/tests/xfs/548.out
@@ -0,0 +1,12 @@
+QA output created by 548
+Add blocks to file's data fork
+Consume free space
+Create fragmented filesystem
+Inject bmap_alloc_minlen_extent error tag
+Add blocks to file's attr fork
+Unmount filesystem
+Upgrade filesystem to support large extent counters
+Mount filesystem
+Modify inode core
+Unmount filesystem
+Verify inode extent counter values after fs upgrade
-- 
2.35.1

