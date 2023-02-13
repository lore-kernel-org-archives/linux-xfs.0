Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A657C636CC
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBMEIe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBMEIb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:08:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B66E396
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:08:30 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iGnT012031;
        Mon, 13 Feb 2023 04:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=K6ZwHjMAiSpLOg/v12vlTkxXTpInbLNMk4BTI8Pib0A=;
 b=p8fDc5+NX8DiaQ84h/yjrKMu7NZIgBDDcPDHRIqyrWcMRwJb7afId4HbYqMcHyHErV0N
 bJVfpWztt0SEk2U5b+0gBkFTINm7ZrdO41bc0mZy0p0Cbf7tNjDgwnbB0RnQMQwHVmAc
 dYR5+XHHwTdKwgZBxYbGhuW/+xzmAfRjc0IpdVaEJXBrRJnS5kg42LJGlELZTgqEfhSb
 Ag7lE7Gs6osgMlS0lwHDHJhNsYluR1pWMLO7kYj22GiILFlRvLVDKEcz5UQYFtyvnmQK
 XWvOrIhlXjblz7BkACyrZiiWc2Mfq7Sen1sfpwCU5r8OHsL6PLH9EnsZIL4/GlMiCLRS UA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1t39v98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:08:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3k5ha011542;
        Mon, 13 Feb 2023 04:08:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3k21e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:08:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOdGzygn38YAMfftqUXxTQijgnRedjJYlDzt/dFYSRywjjIWkXgTYqCdQEMH6eTSqO7DeP2HXivXaMn37eQCLyxOk0JVwil4ZQZL7YEHKSlL1Mg/cGxhpNDzfuhB6UzK4m8O7udQpsky8LmXALEjrwqqN2Gd10qw2mlxvE9AYPHTC6H5dZSEHMAMOngJDZLCCyXxu6Km+y3eT7NLjiFJ/OxvWKRVI6W3x8IOY0FyRXPJ9X11ys2UexwIbTEQbfLFpHCxjnGQtCGlUSx1JYH59K5t2hgg4+gyU2KG3JPOv0Qq8nuOHDYsSVlMQjomwSXEBwi9ggp41Kqfm4e3pH+Kfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6ZwHjMAiSpLOg/v12vlTkxXTpInbLNMk4BTI8Pib0A=;
 b=G6DpaNtIOoSGFlHG8Mo5wgyTBAzELfLVrqPR0I3uo46nA3t8NIV5knrZ8Et7VHjd8vzgD8q2hfiSyjyJO+cnQflUqdwae8DDnoYDYwNcjiYX4Ci/abU90/RQ0TKfwL0eo4pmB4L/fFQZzv+3uTeuzLoX/fuT3ZWEd+9MdH22omFv6xeAq2wBnnDgfYldNdFvXQWychuLbiBdXP3dbckE6I+JAedpbJoxNpzujS1/Ls7M89ASWp3EPfWIuc+Z6VktZ1N+TLXdRO5B8V7dQXw01Td+CIcTEOMH+QZV7/hWpeOVhV+s6PK7N929pVIZWSktl5/sP6uqFgE/rTs92DJZ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6ZwHjMAiSpLOg/v12vlTkxXTpInbLNMk4BTI8Pib0A=;
 b=kxqOxxSmzEalxP9qyJ/2rssOQWHseichYe08h72hdLJ/s3j3timxMSbovuYAVOjWAtubZXi1zB1Kho/EDmVQsAOziCkTY5jlho7jRn7iqwalmBqbFfkuIAzlNCMFZ5M2Ltiw1skfXsMSlHen6JAYXgCj4BYfHtxpZNBYFDGoXk0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BL3PR10MB6089.namprd10.prod.outlook.com (2603:10b6:208:3b5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Mon, 13 Feb
 2023 04:08:25 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:08:24 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 25/25] xfs: sync lazy sb accounting on quiesce of read-only mounts
Date:   Mon, 13 Feb 2023 09:34:45 +0530
Message-Id: <20230213040445.192946-26-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:404:a6::35) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BL3PR10MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: 9062b231-2449-4a04-4695-08db0d77f3f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e0DvC22adkGfqjWsjmEmx+Ey87YMZv5T1T2nMMOCUt25e+VSZjL0MwXxDAwsSvXgxzAPfH3rPNbC163ZBVQUjPu/+dj/8hgTuho6eME94kXaBXd8/vpCw6Z2wHj5zRCbXfAGveJlSDfBQ4FSKLMYVejqyGjf/7XJ2FIbldT2Fis8aY4r8EPR9tDcvbi+rAvgbbkhJ8Foj9FO4+Grg0KksU51b/g0rI0ZLry4+j8VHgOszaF099KK9gFaKWXNs3ZyAA4YMn+04EpEM8dWJQrmtK9QwCzexFRKkav78unBjdiPRKSH5FIjgVA9TcJ6C9RPzTCHkIiuLLyE3ijATqLggkX1DoeJG7xfPhbjNMg/haSRRLALI/xpXd5NkzCGRrKMMN/dj7zgIqHnz7qd5ncfa20dHUcA5BxGmW1tHI3xEq8jJOyMOxx2kUeysF+LW23d4yOTPkeEKaKb04fyjOdzeR1UPuRFpTBuD9k89J5cMggyEc4lorfWXq9d/Dfp9658ca6Ip+xPb8m8NCaKjKEhzGxM0BkffB7DyJH+ggVKU4ymcKrfjUQg9/500F7NsTyW5VbzqU/l7gdAfKXgazXIFQvGYxJrySKxewoNPzXEF+8o8uX5F8Y6P2a7mQzcnREMLAmVlYr6VFAquEVV+wKdYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199018)(86362001)(36756003)(38100700002)(316002)(8676002)(4326008)(8936002)(66476007)(5660300002)(41300700001)(66946007)(6916009)(66556008)(15650500001)(2906002)(2616005)(83380400001)(478600001)(6486002)(186003)(26005)(6666004)(6506007)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bKhBXmBI6nN/F7v2nLTSEzqLnqg1j3thbmQ2msDaxJ+yjSaXvM1XhtUkou+B?=
 =?us-ascii?Q?0GzCw13L6tPFDWLf6rVbgTwqR0bKCpWJfhN3J4MsdKKQXHVbAx24A0gUmdgV?=
 =?us-ascii?Q?jDdfADE5DrCsb7RqTLHlIM61U1duRUW7W6eBzC47qJArfec1hDAASs7bWXIX?=
 =?us-ascii?Q?rpyTepX2vBGDysIImNunu+i0xJw72+XDSEqwaLs0r/twvLq7rVSqfUCL9uh8?=
 =?us-ascii?Q?QV9nvDD4tbBairNKrpwdvRodnsskm2B59CZBMftvDs4v0kvnrWN9YNZWHoJ0?=
 =?us-ascii?Q?oCcmqdwnBSEb1GNW1T/reIOtbogkDZOMOVMb+/Ibl+Bqyw3UTqEH+u15Ci1o?=
 =?us-ascii?Q?xHZyv4Jc+J0YpTLZCX9CsGWm6lMPr//cP5Aw/mPJsk3E/2z3NMAfj1+xeZBc?=
 =?us-ascii?Q?dHiV1DZ14b6PHz9sRxqCVvuzP3Cevlbowy96mQFI/OP18WhPSGQjWjqi6KOX?=
 =?us-ascii?Q?zRh4M11GCHoXlaSU/IGqFvnIwYu/Eh/wZ1dVaUqFQLMVYpEdmtasngFfQNN9?=
 =?us-ascii?Q?hnGRu9nCxmWuRkoOLpmekHUn1RVv+p/x2DNr6rszZPLU64OMbkLlSWzTPi5p?=
 =?us-ascii?Q?j2fgeDIQrLciKxSz4Sn8YBQmZHhYCK0v6K7mktzDyCglJxtbWMeYjiH5jay5?=
 =?us-ascii?Q?QXhxmX+zKqjIFDz8k+AVQfkNtdDxEYuyOLG6WsdLfbay/VbcaF5BAnvt/JxW?=
 =?us-ascii?Q?YoIxjnKRwbTMBXLVd5A2xvATiPd/72UckP7mtQqCu66X/fnPIpddcj9wUJJn?=
 =?us-ascii?Q?2WI6t8Vl4n2o0nHVrPPxeBeuhAvlzZ/UHoapeAYUvacqsnkpRxoTD6OOu10Q?=
 =?us-ascii?Q?1ylNYNKqAww13rIE1+7rwpfWglDM/CwiMQqXqMoPf/rFC5UNlUhNL31TCg09?=
 =?us-ascii?Q?xNj9UYjNeL+KTTheHlYMmw0XaWpEt0sXGNP57yM/Qyd2eamwANFzYbGFUnt4?=
 =?us-ascii?Q?LtfY8uzA+1Z7N7MupS1wrUqpmwI3Jq0Lz0TP63m1PAW1KXfEAHFhioeHsvUW?=
 =?us-ascii?Q?Hunnb05Ov3qK8kGNKi8/NNfkQ4FCgBxytByEHfIqPorqQVJtHRaL0+oGFPCA?=
 =?us-ascii?Q?06vdr+/Ci8TrWzUJ9UZCGVXgaMoQqnNOR2HtEjGZUt0sC20a8tk2RTl2U4Gw?=
 =?us-ascii?Q?RimJPt8ZXmar0YzctZN2enRDQ49iZlbJc+4P4o7YzefrY9BtN/wwBrOBV8Cu?=
 =?us-ascii?Q?BGo1WSE3TVGxpT3z8rprX/40+KVt1iu5s5MTPd3UWN2DmXv2Qy6eFuZXvg8d?=
 =?us-ascii?Q?86zjDoz24h+SuFXW7uNZCG5VV90l6JAMjCjGm5P9nZmJ27ckvHYAt66hDmrK?=
 =?us-ascii?Q?iFm1zzvO5HseAcMbc834dqrXRGY99sJhc71ifUvpnMHpETFh83+hn+Mc7qFQ?=
 =?us-ascii?Q?OFbPoivm3UfhAzTftle4uwWxH1dtzSYn7+v7t6W1mT+63KIdfbqs/V15Jhkc?=
 =?us-ascii?Q?Rs9gmKcx21K3AvW8Rv21LvH2w8rv2u0uyxuiu9S7TPRlLn2TwmC2hHDwFh8G?=
 =?us-ascii?Q?n2SZDjnspOcZHcTiLz89aZGcGRgoshSAXIhC/qp7qB0CydxWL041z0MWPJzN?=
 =?us-ascii?Q?nG5zEdG2gBvy6pdbOUXxCUckj8HsRAMffsPwt+Ye9KhhMhu0I4g6jWt6PRRr?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZlHZbnm4Rq+08gs9fmZq28N0m3AzAL/XMQOSxYeIuTBzzeW2Dd4UgYnF/gWw+KFHhx06RymZBznCI5at0pu4HKJ1Lm3oJHBszyPvBZCSf092U9NH0PreB2KMXHePuNjcefJELaelp4c6FiKGE7qVZTOafMWlHGRKDiNJOe3oPClYBM2bIEWvlgAfP47TDrBQYimAqmN9zQX6dl4sIvy3rQCfYW3UUkUZ+mK9GTONNllmb2xqgc+LigfVGyV/rQ6e09DVweoeO65wrGKRwlBmVHGPjcuwin64AZDmEny/2nHzBKZ75u6lqPoTYz3en4yxpi5+eMiFDSWnvMtTikeGesK5kNaKXY6+PYgIAMM7PAA39WWYDr2utl81EyUVE4M+Cp8ZUL/A2MWd9mSHPo2Vnr0e3dVQB2A/Ab8/7aL8oZOkXkEo3OpKMwsPfCkonFrDIlW/NHTvt0E5d/bF+4kpObnViTiFWC4kFkw/YLMau6XYkKKfhOXM3CTX5iVqLUzQstTr4KuwwK3zQHTh00/p3uadlGFrVh3EvGqVyGEMDW8v84XMhi1SwA/16R56FSD8Zj8qpgKfDoQZnWkzOW7kcpNPGBT1jk2Ede3+lNfe1h9Vhpgek6TAFLpx6pjEnA7j5tw0fuPtt3Hl3FdNGWuCe4Dh0mfyGm58oQ9PDps4E9lxnLay3qmEG9lkQ655PiqWt7CPVNClAjPbdyNjfRaf2qfl2STvmuAEuNdQnroTxm2rXULHSWcfPk5/CFLBv6F1Bt7No57slhy0N2+PnZgAGBc5BGkW88gky0ZP1aixf3EsaBmgXBSKiszDw8dWfwBk
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9062b231-2449-4a04-4695-08db0d77f3f3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:08:24.9070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: simadP4i1vVeGTmMSRfQZ52+NSo2hOuWwsfJPp7H0JSuoZACsbuLJJmSH5vuEjdrnUKafUsUODaFD3tvd2JZSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_01,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130037
X-Proofpoint-GUID: iGymu1Z4LZCKjc5MNmc9vGkynLvRHX4a
X-Proofpoint-ORIG-GUID: iGymu1Z4LZCKjc5MNmc9vGkynLvRHX4a
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 50d25484bebe94320c49dd1347d3330c7063bbdb upstream.

[ Modify xfs_log_unmount_write() to return zero when the log is in a read-only
state ]

xfs_log_sbcount() syncs the superblock specifically to accumulate
the in-core percpu superblock counters and commit them to disk. This
is required to maintain filesystem consistency across quiesce
(freeze, read-only mount/remount) or unmount when lazy superblock
accounting is enabled because individual transactions do not update
the superblock directly.

This mechanism works as expected for writable mounts, but
xfs_log_sbcount() skips the update for read-only mounts. Read-only
mounts otherwise still allow log recovery and write out an unmount
record during log quiesce. If a read-only mount performs log
recovery, it can modify the in-core superblock counters and write an
unmount record when the filesystem unmounts without ever syncing the
in-core counters. This leaves the filesystem with a clean log but in
an inconsistent state with regard to lazy sb counters.

Update xfs_log_sbcount() to use the same logic
xfs_log_unmount_write() uses to determine when to write an unmount
record. This ensures that lazy accounting is always synced before
the log is cleaned. Refactor this logic into a new helper to
distinguish between a writable filesystem and a writable log.
Specifically, the log is writable unless the filesystem is mounted
with the norecovery mount option, the underlying log device is
read-only, or the filesystem is shutdown. Drop the freeze state
check because the update is already allowed during the freezing
process and no context calls this function on an already frozen fs.
Also, retain the shutdown check in xfs_log_unmount_write() to catch
the case where the preceding log force might have triggered a
shutdown.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log.c   | 28 ++++++++++++++++++++--------
 fs/xfs/xfs_log.h   |  1 +
 fs/xfs/xfs_mount.c |  3 +--
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ebbf9b9c8504..03a52b3919b8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -369,6 +369,25 @@ xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
 	tic->t_res_num++;
 }
 
+bool
+xfs_log_writable(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * Never write to the log on norecovery mounts, if the block device is
+	 * read-only, or if the filesystem is shutdown. Read-only mounts still
+	 * allow internal writes for log recovery and unmount purposes, so don't
+	 * restrict that case here.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return false;
+	if (xfs_readonly_buftarg(mp->m_log->l_targ))
+		return false;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return false;
+	return true;
+}
+
 /*
  * Replenish the byte reservation required by moving the grant write head.
  */
@@ -895,15 +914,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 #endif
 	int		 error;
 
-	/*
-	 * Don't write out unmount record on norecovery mounts or ro devices.
-	 * Or, if we are doing a forced umount (typically because of IO errors).
-	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
-	    xfs_readonly_buftarg(log->l_targ)) {
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+	if (!xfs_log_writable(mp))
 		return 0;
-	}
 
 	error = xfs_log_force(mp, XFS_LOG_SYNC);
 	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 4ede2163beb2..dc9229e7ddaa 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -132,6 +132,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
 int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
 void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
+bool	xfs_log_writable(struct xfs_mount *mp);
 
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bbcf48a625b2..2860966af6c2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1218,8 +1218,7 @@ xfs_fs_writable(
 int
 xfs_log_sbcount(xfs_mount_t *mp)
 {
-	/* allow this to proceed during the freeze sequence... */
-	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
+	if (!xfs_log_writable(mp))
 		return 0;
 
 	/*
-- 
2.35.1

