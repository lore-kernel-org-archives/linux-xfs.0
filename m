Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC19C43217
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiAUFTc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:32 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27236 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229608AbiAUFTc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:32 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04MqK016482;
        Fri, 21 Jan 2022 05:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=od5bogZZqS8lu0grZqmNPPycqA6j4qXCl1cFLp1Fz68=;
 b=CsrAyL1qruvpT2y1QceyjoS5LzXbq2/rMjI2utxNcqr2v8c+LWgThmcYbZ+wJv+9FPEk
 DdKsGrsY6ZAFOTe9eA/O5kVUAz/iVacLSdPEUrInj0resCe4PRyL05fsFd2cBIOLSXFv
 soUIHZaEsXYIJSduEtyKdWlkBJ7EEjPu5feaAZTPJv5iVQwJQQGF1WjgM0/kyYL59q5z
 XpkfvpBtmbQtI22g/HBodXEO1KuCob8+T82hU63QWLCLLV1xIZXZV9FzrWRKVc6XhAsF
 gwOLQrxzInGbknk3VCfCcz5Uc8zw0WD5r4+Nv3U/J/nJn6kX/0YJNhgAg9gP+pewORK+ Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhydrc6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5H0U3018743;
        Fri, 21 Jan 2022 05:19:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3030.oracle.com with ESMTP id 3dqj05h2re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iv24WU2pTp9F9a/mdLeqd+m394eUZk0W5iMsq6qzQ5dva8fxK3vA6Rs9nlcKEfpWqXDxciXsjk4qV2tBNfp0npQz0Ikpqxfe/VuaF0jgXEXNEO+ZkihWAG256Fc/Eqr8tClCtOicUGsHxUZOyb4N01Iq9rUfe+niAGlwAyr13ZIekRIlqGWqklPMQN3KMUq4KHrJPNHnIlWEjUfB+0iHfNANfSS1jtcQ8NvBfpjn9fGWNmb4qKSDdPYaxWQB9djGbtasdQral6FRmeLid4/Eoywza6GeiPl4WGoPWzjL0v71A5q3wkEtK3mWMWCo0QADEonmSA+M3spmjIFrrZJlUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=od5bogZZqS8lu0grZqmNPPycqA6j4qXCl1cFLp1Fz68=;
 b=cDaG5Xmw3qTV8JJ1mqQUgeloB37hefm92nInUw2iShV98EJwhce1/+3VcsyPRKB29RHcgjY2UKo4UeeEyltsuWsdSIqDg5NNUuorPm7awe5LigfAy1+t8lztq9xbADfS2GxCtohcloxYXTPeJvYPDDn1yAauzJYFxt7Xo0qwWeGrfMxIzLX0fVtpINRd8zt5kLno39cjQvh0yFSM401r6K8iwedkeLzoNs151ycOXewxMdr2RIQu2Ba/yo9vx5LsO9tQhXLWiJ5oPYta+rCyun7NLePsuaSz8hVg0ilIg/cgr+QQK/g/WZmrfrKki7vVVCskFULDfUrSLimmlj7RJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=od5bogZZqS8lu0grZqmNPPycqA6j4qXCl1cFLp1Fz68=;
 b=GrXv5BWnsi6E9GGnK1dENA+ZzH0wLK9wqzJ6+06x84p03qNlQrrK34rGwICG/9HVnewkvDfLz4qcBoZxcw+pNB4l9sfuFbYNURzynIKGDQETYe7N0Ygxt9Zw1SdT0e9xhcmcbLSLM4seJw6RlMa0im3T2GKVB7Ow3k582si7I5I=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 21 Jan
 2022 05:19:25 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 00/16] xfs: Extend per-inode extent counters
Date:   Fri, 21 Jan 2022 10:48:41 +0530
Message-Id: <20220121051857.221105-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dfdd355-06b4-457d-0ddd-08d9dc9d96f2
X-MS-TrafficTypeDiagnostic: BN6PR10MB1236:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12365E918396E970C178DAFFF65B9@BN6PR10MB1236.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1LCKgSHn9/0C/QrLAK7ggSxdnUZAF0REqh+diIrHG3LNf1Z3utiRZvdoAARqp3OP9oe02Xo84UIIhNeQmYu67+tYMN2+jc9fxuEu7XScL6a7mzjz1HKZfMNfi4B2LYh/UCX/B/5PljMIAzKX3N8NzzQBeCAI6YSJooDvV8OQ2MCWe3YfwTKqW/Y3n35KWUVuyCKv01KA3imsu6qSKw3Fqb2wPEPEXEwZYtyBUy7IXkKK5mfMDDekHMywaZ0Ufli4XvJEPgzYXp/SbGevRH7bbXIqZn+UoPzANrYZxv6LyZXCiAIX7Fwbj3KrOARLn2g65oK6JNinJbvppKnCxpy+/MxGCsaOJo1N3R1OVQZ0N92EG9Pfyd0hnrM5GnqTKqh/xsoeX9JOFk8/5F1wym/8xE5KD149GnelRigZnZOfvVkcu7du5KQMgJ+VshM4mCRqMk7ne83VhNvh4aGvGRd5M52vuWh8R/rxCPGbqlUP2TTXqHSrbRHCjus2FI9+jmQdrQq0X7PuNM+NVXPe5a2Di3IcuLaW4jUmWaq95VaPZ0wxNXbmd+w4+0jaNJeUn7oApqMLqFD4mOapvErzXEkBHUkgiaTH+8YjFCyjuExqRqwshLaVcgyy1VoggQgAHu254h36GKt7cr+dWQVfEfTeslYtSIS8LykLPXuttF8ogCIPNlvPOpkLJQG/kuknAXBtvhYWZx96YIEAUg1H9RogV7MO8Qo//8Hr0dd4lwi7tAjyZivpwzjl3/IsfTrMwOqxakvQrMk0KwHtIdip9U60rerDO4MOoeSU3WXSqjz8OTo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(2616005)(6506007)(186003)(508600001)(36756003)(26005)(83380400001)(966005)(6486002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(2906002)(66946007)(66556008)(66476007)(8936002)(316002)(6512007)(1076003)(4326008)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AQvRDqcXimp8zAIbrlxdAaviFgpqV6UNcHs0Y4g9shna2bzW1a5NyP6vecFz?=
 =?us-ascii?Q?xWTH6oARGWegjTJzgf2z8in62TQsDw/RR1UCc7bRs9MYuTcQ7bprRkh2Irbt?=
 =?us-ascii?Q?dANO93cqPLCS1Qum7xWDmk48muFCCzg4mxJoyZA8/Ys4S4JwErVfDFiCB+EV?=
 =?us-ascii?Q?ZFaOeTBDAvAlvYD9UK2YznKODXLqqm+00x4iuv91gUnOLY31DODFx6f1K0cl?=
 =?us-ascii?Q?zaVcB0mzEPfSz+eqE54g6BshE1/kpsNRmUE+dAPmhVFoelfgfyiGivUmQlzm?=
 =?us-ascii?Q?/e/+TFezFBDnHdhsk86EexHAtY5qiyB4O8gLzSJp31r0azrbt+xNEYvngYlk?=
 =?us-ascii?Q?i0JNavvixAvNFrGM0Pbg6kS9C3xDRa+fjTwQ1duyaSr81rXr/Izn+pWpya6N?=
 =?us-ascii?Q?q1dMrLWqSj+gFXK89Kqt+Mej7wo0emyzCwoVVoy1abe9SIq36CYrxE6zP6+o?=
 =?us-ascii?Q?J2iGhVXD9IdMfHpWzqNVD4KZmVkQx4GgOU3cl9/nGzNI2Ckc+ldyRstOhlkB?=
 =?us-ascii?Q?ZrjCA+sZyNiAgtg5qgCfadBVdeaHLoP9tWbMWpkGjLNWsasoWEIzDQyXGUuF?=
 =?us-ascii?Q?tsZbDvMW5dag8xgdRhNTmTueDwdr7vEKFrIMZVBZXtDtKgDgUDKLEaQqi+Bu?=
 =?us-ascii?Q?y6oAPFh69hcEO0gYkKsJzn1PlhcqxxW1qnVOn/gXRM5KaHgsV0TnP7Lxnbs4?=
 =?us-ascii?Q?dNwfSOvZSWdXZ5GRxqp02jyBeIaA2hcKOPTan7AEM1sa+hUzoq9qxZFGvntt?=
 =?us-ascii?Q?31x27hGYCS1s7FX39jUkGBvfgzvGeS0/jdV6DMkPnMFV0zZtTrthCmH/nMKi?=
 =?us-ascii?Q?d+YGAQgACDtrEYsoHZ/0t/WnO9cxUjzoXlb2yTfbU5GnC47oFTl0nAGHo5Ub?=
 =?us-ascii?Q?h5+54BzmPxWJYFPtKCbrcLLChamzb5tuItxxRIw4NkKKdz/KlnRN6wLLL6dr?=
 =?us-ascii?Q?NyQj8mo4eQN76cUyjlj9FZcxnSgcufcKJfIZEXwRbHzNvE8EZnCMVEwX+hnK?=
 =?us-ascii?Q?n3IBK2SKaLASols5cvgWj6IwAgcr+ycZFyASdXrt4+ahBikVXounU/rn1QZi?=
 =?us-ascii?Q?Q1Ler5doF10h0ea5BysAQ/Dy+aJjYJ3PUPxt2Q60yjaGJNl3obknyLFF1eKp?=
 =?us-ascii?Q?y9VhKGfo2G5/MzRoQ0IXdG0MKRA22fhaEE1wgkaKldyXGr6BMkMEIPX+3oxn?=
 =?us-ascii?Q?mCFB+pNFj21ftjDHTp8Zyh3NfLNQQS4lNKr/503br+KOIKfI++2Ss3Pk7MBw?=
 =?us-ascii?Q?bvZCS12C0Z6rK2JBjea05+EtCTDuVgvINVdVOCny1tOrF/80DiG3PoMawhmt?=
 =?us-ascii?Q?92HV04xRxzg68YelMcOmdzoMzBnKTpa+oRtBAfv10lf+YhZLsdmSEzZClQ8c?=
 =?us-ascii?Q?H45WZ2j1UClgzVqPUcnvr0iVGkJq+tmvsH7vqxQCCNtkxJMk9ra2beKsaOgm?=
 =?us-ascii?Q?zp/DTKkzO7t46GPiBt3gbCMrgo1iArDahA8fPHDaD59CEtjIT2uhqMsizX6N?=
 =?us-ascii?Q?JqdrVYqHWkYIRs9SgoaSn3iR+jf4FOabw/IUSu66JERgXltSVn9Fu+eaV0QF?=
 =?us-ascii?Q?SyOmo7wY5GDZkH8JKWmR54hr81k8Jj8USnB/Uzoz+nbDVh2hUWRzJ4ssN/3d?=
 =?us-ascii?Q?qW/2LGxb3ENvM2HeRJq31q8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dfdd355-06b4-457d-0ddd-08d9dc9d96f2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:25.5850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVeC7YAPECCppysBXdMNnHpmZxNWg2xPRjo02FsTwkJ/C7B6efRgwG3beOqgM+9K1w27wyD6OhZUTnIhSpXt/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1236
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-GUID: rzdviG1fYFFILRAG0Ep_KC1LymPJ5UGY
X-Proofpoint-ORIG-GUID: rzdviG1fYFFILRAG0Ep_KC1LymPJ5UGY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The commit xfs: fix inode fork extent count overflow
(3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
data fork extents should be possible to create. However the
corresponding on-disk field has a signed 32-bit type. Hence this
patchset extends the per-inode data fork extent counter to 64 bits
(out of which 48 bits are used to store the extent count).

Also, XFS has an attribute fork extent counter which is 16 bits
wide. A workload that,
1. Creates 1 million 255-byte sized xattrs,
2. Deletes 50% of these xattrs in an alternating manner,
3. Tries to insert 400,000 new 255-byte sized xattrs
   causes the xattr extent counter to overflow.

Dave tells me that there are instances where a single file has more
than 100 million hardlinks. With parent pointers being stored in
xattrs, we will overflow the signed 16-bits wide attribute extent
counter when large number of hardlinks are created. Hence this
patchset extends the on-disk field to 32-bits.

The following changes are made to accomplish this,
1. A 64-bit inode field is carved out of existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
2. The existing 32-bit inode data fork extent counter will be used to
   hold the attribute fork extent counter.
3. A new incompat superblock flag to prevent older kernels from mounting
   the filesystem.

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

Each of the above test scenarios were executed on the following
combinations (For V4 FS test scenario, the last combination was
omitted).
|-------------------------------+-----------|
| Xfsprogs                      | Kernel    |
|-------------------------------+-----------|
| Unpatched                     | Patched   |
| Patched (disable nrext64)     | Unpatched |
| Patched (disable nrext64)     | Patched   |
| Patched (enable nrext64)      | Patched   |
|-------------------------------+-----------|

I have also written tests to check if the correct extent counter
fields are updated with/without the new incompat flag and to verify
upgrading older fs instances to support large extent counters. I have
also fixed xfs/270 test to work with the new code base.

These patches can also be obtained from
https://github.com/chandanr/linux.git at branch
xfs-incompat-extend-extcnt-v5.

I will be posting the changes associated with xfsprogs separately.

Changelog:
V4 -> V5:
1. Rebase on xfs-linux/for-next.
2. Use howmany_64() to compute height of maximum bmbt tree.
3. Rename disk and log inode's di_big_dextcnt to di_big_nextents.
4. Rename disk and log inode's di_big_aextcnt to di_big_anextents.
5. Since XFS_IBULK_NREXT64 is not associated with inode walking
   functionality, define it as the 32nd bit and mask it when passing
   xfs_ibulk->flags to xfs_iwalk() function. 

V3 -> V4:
1. Rebase patchset on xfs-linux/for-next branch.
2. Carve out a 64-bit inode field out of the existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
3. Use the existing 32-bit inode data fork extent counter to hold the
   attr fork extent counter.
4. Verify the contents of newly introduced inode fields immediately
   after the inode has been read from the disk.
5. Upgrade inodes to be able to hold large extent counters when
   reading them from disk.
6. Use XFS_BULK_IREQ_NREXT64 as the flag that userspace can use to
   indicate that it can read 64-bit data fork extent counter.
7. Bulkstat ioctl returns -EOVERFLOW when userspace is not capable of
   working with large extent counters and inode's data fork extent
   count is larger than INT32_MAX.

V2 -> V3:
1. Define maximum extent length as a function of
   BMBT_BLOCKCOUNT_BITLEN.
2. Introduce xfs_iext_max_nextents() function in the patch series
   before renaming MAXEXTNUM/MAXAEXTNUM. This is done to reduce
   proliferation of macros indicating maximum extent count for data
   and attribute forks.
3. Define xfs_dfork_nextents() as an inline function.
4. Use xfs_rfsblock_t as the data type for variables that hold block
   count.
5. xfs_dfork_nextents() now returns -EFSCORRUPTED when an invalid fork
   is passed as an argument.
6. The following changes are done to enable bulkstat ioctl to report
   64-bit extent counters,
   - Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
     xfs_bulkstat->bs_pad[].
   - Carve out a new 64-bit field xfs_bulk_ireq->bulkstat_flags from
     xfs_bulk_ireq->reserved[] to hold bulkstat specific operational
     flags. Introduce XFS_IBULK_NREXT64 flag to indicate that
     userspace has the necessary infrastructure to receive 64-bit
     extent counters.
   - Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to
     indicate that xfs_bulk_ireq->bulkstat_flags has valid flags set.
7. Rename the incompat flag from XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT
   to XFS_SB_FEAT_INCOMPAT_NREXT64.
8. Add a new helper function xfs_inode_to_disk_iext_counters() to
   convert from incore inode extent counters to ondisk inode extent
   counters.
9. Reuse XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag to skip reporting
   inodes with more than 10 extents when bulkstat ioctl is invoked by
   userspace.
10. Introduce the new per-inode XFS_DIFLAG2_NREXT64 flag to indicate
    that the inode uses 64-bit extent counter. This is used to allow
    administrators to upgrade existing filesystems.
11. Export presence of XFS_SB_FEAT_INCOMPAT_NREXT64 feature to
    userspace via XFS_IOC_FSGEOMETRY ioctl.

V1 -> V2:
1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
2. Add new bulkstat ioctl version to support 64-bit data fork extent
   counter field.
3. Introduce new error tag to verify if the old bulkstat ioctls skip
   reporting inodes with large data fork extent counters.

Chandan Babu R (16):
  xfs: Move extent count limits to xfs_format.h
  xfs: Introduce xfs_iext_max_nextents() helper
  xfs: Use xfs_extnum_t instead of basic data types
  xfs: Introduce xfs_dfork_nextents() helper
  xfs: Use basic types to define xfs_log_dinode's di_nextents and
    di_anextents
  xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
    respectively
  xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs
    feature bit
  xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
  xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
  xfs: Use xfs_rfsblock_t to count maximum blocks that can be used by
    BMBT
  xfs: Introduce macros to represent new maximum extent counts for
    data/attr forks
  xfs: Introduce per-inode 64-bit extent counters
  xfs: Conditionally upgrade existing inodes to use 64-bit extent
    counters
  xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
  xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
  xfs: Define max extent length based on on-disk format definition

 fs/xfs/libxfs/xfs_alloc.c       |  2 +-
 fs/xfs/libxfs/xfs_bmap.c        | 82 ++++++++++++++++---------------
 fs/xfs/libxfs/xfs_bmap_btree.c  |  2 +-
 fs/xfs/libxfs/xfs_format.h      | 60 +++++++++++++++++++----
 fs/xfs/libxfs/xfs_fs.h          | 13 +++--
 fs/xfs/libxfs/xfs_ialloc.c      |  2 +
 fs/xfs/libxfs/xfs_inode_buf.c   | 84 +++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_inode_fork.c  | 14 +++---
 fs/xfs/libxfs/xfs_inode_fork.h  | 59 ++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_log_format.h  | 22 +++++++--
 fs/xfs/libxfs/xfs_sb.c          |  5 ++
 fs/xfs/libxfs/xfs_trans_resv.c  | 11 +++--
 fs/xfs/libxfs/xfs_types.h       | 11 +----
 fs/xfs/scrub/bmap.c             |  2 +-
 fs/xfs/scrub/inode.c            | 20 ++++----
 fs/xfs/xfs_bmap_util.c          | 14 +++---
 fs/xfs/xfs_inode.c              |  4 +-
 fs/xfs/xfs_inode.h              |  5 ++
 fs/xfs/xfs_inode_item.c         | 23 +++++++--
 fs/xfs/xfs_inode_item_recover.c | 85 ++++++++++++++++++++++++++++-----
 fs/xfs/xfs_ioctl.c              |  3 ++
 fs/xfs/xfs_iomap.c              | 28 +++++------
 fs/xfs/xfs_itable.c             | 27 ++++++++++-
 fs/xfs/xfs_itable.h             |  7 ++-
 fs/xfs/xfs_iwalk.h              |  7 ++-
 fs/xfs/xfs_mount.h              |  2 +
 fs/xfs/xfs_trace.h              |  4 +-
 27 files changed, 445 insertions(+), 153 deletions(-)

-- 
2.30.2

