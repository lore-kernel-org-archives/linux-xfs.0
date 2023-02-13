Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9F8C636CC
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBMEFH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBMEFG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:05:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0AEEC57
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:05:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iQwX028487;
        Mon, 13 Feb 2023 04:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=tqUaL5van7XisArww8OBUnuhVm96Y/EuyVkJqXWRANw=;
 b=wlrpMgpk7rtmSsHmB88R9gBwKd+L9hxba8ICEilG+PjN+uHAs4Xe/6SZXxpJ3D7zQglm
 Cj12lkKwCJ4rskxY4N6M9YVfUwO+Y9sbsPnJBJFVvircuakw4kXfa/wp1xdQ5H922L80
 jveGE4RNqjGB5SdrNBqanmJ27MG7LcgxXFGknAvSaHkFRXptrCllNglG0N05j5fbaWf4
 ejwNvuFak4e0M8OxvHcTNZivYgPeDey8OXmkGrCuvmBgqWnx4U9rrJ5It7EoyttWWtd8
 tXfwGzsNrAQQlacC8mYVizhagrI1NHJNGKYz5gGp7gAFBEp5uGER6KLHeGJbzupTqDW9 pA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np3jtsu5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:04:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3kZ1c028875;
        Mon, 13 Feb 2023 04:04:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3jwq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:04:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAWrb6PpdvGP5B2CTC4NCbEjD0q2+oGH/bZx37IXlpLDtakq8rvBubF7Z/jjriWYJ6ZvnsGqCdnLHeaWggQD956SKP6v0bTtYlmUXBOftFup1dFfq+vuYNlHmbxCANpOfS0+whGuEycmmU0lqkaT44FPakkq9wS2yIA99K+aZvWGQ1irihpHR5UcYynQUvVqleiwXHE+C0/Di9ORjiZWZBxsd85JxqSsW2Ez1jzGBEtvIvtRlWa68ftS1HONAU7V3Y9lCFxZ8CR6z5z6lM1rHD/MAIDPC1q7vda9GMUITTF+5ICepQ488Q3ktVB+Tgp+HnhyJK6m5ysnUhKyY1wdpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqUaL5van7XisArww8OBUnuhVm96Y/EuyVkJqXWRANw=;
 b=Dksv+Zf6U0p7R59aON9D6LNOgL7o5OKjC1wdKN57mff4h/MK+00R5F4NCovW05QKGiqm0BsumwI63kzbFgNwQmBEBnzA3DrqOyWkTn7945W1BVnAH9CRBcYjO7LZobXau067mhN2rUFZvjHVUa37vsOJFVPDYgHnUOar74PlNnCbidbhelx3qUy+hxHctdMHkIjHzca8P8pLX2vhJf2gXYa07nQ4ILWjM6vwZXzTSeqzjFgFkY4czKER55tR7oB8xA6Uiv+v8TUdx47nboY7T/bjaKSw3mMVQ8rBnV6kjqiAa/DBS/+YZnA8RUvoFaJGYNyG/VVCw2JwoZWTC0eALg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqUaL5van7XisArww8OBUnuhVm96Y/EuyVkJqXWRANw=;
 b=cdrwdzjRRuAUUNAaIdCab1PDM8E+m6LuWgsvDa1E+tv68/bJbo4XTgOxnu19CuXbNKRQVfNNNxNggvNloSH8oUvlRuZJc90OgED9oTbcpMX4M90XMtu06PKsa/SsEc60LNb8SMdGKMGdP+dmenj1dPP2pn3CXJtyafdKTu3DZzs=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4492.namprd10.prod.outlook.com (2603:10b6:806:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Mon, 13 Feb
 2023 04:04:54 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:04:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 00/25] xfs stable candidate patches for 5.4.y (from v5.10)
Date:   Mon, 13 Feb 2023 09:34:20 +0530
Message-Id: <20230213040445.192946-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::15)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e4512f6-a3cd-4139-75b7-08db0d777668
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aSBVk90RlgsooLkLbXJV505Zz9JQHshrFJC5usTLTmwKXmHH+PkYoUK3b3llOROX07rkEbnMFZy5MPrY71M/oMlJtggXCBNyX9FtagFDQP+1Jy3jfDXFYeYFdHR0jqlVRThnwOm4fkOUCapzkgD5LQRaEUeRusDcZUeD1yIB9bDaoSbIkXk0E88ZnlJismNuIA6e2aKfSWD0lXjVbby5P3WzWw3jTotUHH7JHgZ63rfsPPgQ3Jjiy2ypKuRy25xWI6f1ew/rQNnKvAOUQed7a3RO4Gi7Tzg6YE4dFe5iy0jAUVl96vJs/wdkJNiJLzSnAuBGrEJ0IbF3XCh8HU7rkooNu0lSUlWYoKVBA9pn3yGzUXlNrR6N59z4NT8y1F+6KI/PcZTZOqxZh75kAqOI8hA5ZFTUmau4xsiL0625HCpGCKGZ8lyAACI5KXp/uupN/5hRjzlKm3hV+zaWvmA4YlO82XW9GlprtC+B+ZXBuVBagLxcpMBVfI4eTFq9P0QNwvCx5OJ5A6yawfFqewKefO8SamjoPFEALkPruELwcVh7l6eMPSrDxATCuiVOhY81rordm77cyxKoaSNfsOeq34GoMuS96/ZXyGhiNJY0961WwgdehIjHkJ59Nw+lZ0UGKT2uw0dWYLJARg6/siO98A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199018)(26005)(1076003)(6512007)(5660300002)(8936002)(6506007)(186003)(83380400001)(36756003)(86362001)(38100700002)(2616005)(2906002)(316002)(478600001)(6486002)(6916009)(8676002)(66556008)(66476007)(41300700001)(6666004)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pbuExA6MwA0kSzX8B7fgDGscyZAFw472+z1EOV+V74rXoSvIKdd5woQKLknr?=
 =?us-ascii?Q?90ezlgmfItEDTtG+sstwwSo9ZllXfzOSfi6EEJ8/50xAo8uphScz0GlOd/ed?=
 =?us-ascii?Q?oExkMW2IjcYDGiAyB+adluaAX8g1VQ8B7MYn4NDKTH56DV44JI1beeFcA9ZQ?=
 =?us-ascii?Q?FRSvYbx0m89Txu5N7PTVAcT0OwobyvstQlwJmTmFMX2ZhKYAWa15zoV4JAeq?=
 =?us-ascii?Q?fV/tfK2oFPlYLN6TYam9pZuFMFEZNGQU7hEgU5fsyeC3SRIka3Yn+SsdmiIa?=
 =?us-ascii?Q?Qo0LnNavGw213g0w+gJhboSBC2ym+ebLX59loWXwly3e+sjMNe9uimnL9jOR?=
 =?us-ascii?Q?Wj/k1gTgQJw0yoERaq4OnZJwURNMccp2uktDy0uYl1zEUrilNPfB2ivNQLLU?=
 =?us-ascii?Q?LX1LGz5p0+UQLMZXM42++X8d7EttNLEU/UL6vvLbEfX0s6zOu7D+FhJvUY/G?=
 =?us-ascii?Q?X1blkjJ4iFxU2t0SMNWVwL/ZPnqSmQcI5/RDXdGrSUBTOH+tgD+M/79naY79?=
 =?us-ascii?Q?ZC+3qQJN0STLktqqha9UGZT2jF3JwE+D9u99n+06hCyNq9TtI9rs+h0LJIAJ?=
 =?us-ascii?Q?9pTl6IraryiVDUkYiOSUGWboKoeBrlMc05U3krZymtwEFoSZNAg62xfzoksS?=
 =?us-ascii?Q?TJxK8Qhn8fslK3VUQS2B3Isb95aq1JXp8vJY9XQGhi9EcmibIHYn/N/cxvRi?=
 =?us-ascii?Q?m5pXBdykhFV4Aq8KsZJDQ7tTF3zCDIWZaIvNc4PwMNdQ8rN/SgcfIJyeEHja?=
 =?us-ascii?Q?kX3ix7t2dKoKwIZ1P6zMeV2uXD/awJydCKFc1S8xln0UJc1OupRUdLUj/8Jc?=
 =?us-ascii?Q?SE/W8XB4xgnUbWdqSxfLqU2cdrtmNRuAVzy2N+nK+E61zLdYlSAMpvXD+Hb5?=
 =?us-ascii?Q?i3a3xVMpC6JoIpbWlIoWpOgcUuADJ6BU138f04CSn/pNqtEpIsTDWofYlFq3?=
 =?us-ascii?Q?Zdn60uzHeTJvhA5S3jYLwLj+Jz+PLvaru7nIMt1Yy2ke87u+fuCA1iWQpWMM?=
 =?us-ascii?Q?dC5Ugi580t6BmOMO/3mfxFVL3Uyp20ATExUhQ/Q5jgghdHuyVGTJXMqsAAn/?=
 =?us-ascii?Q?3egcsp9fXdJ2vJZ0K93xgDPM4DnVewQ+qpjRnvc6u36AO3+AkdA3hMsiuuym?=
 =?us-ascii?Q?owtWTNRk33QIq23gr3+phQTakSEPWFRRrgQy4qwOQCIyd+YuB7WPUlEDTp+K?=
 =?us-ascii?Q?b6VjV5vxVgcfGvqo1nhDbef8e4lN7tCwueC+DwMxMtjxy3defnb1jqmUBIvP?=
 =?us-ascii?Q?+UkFqgWxJCyWkXEvNY/eB+rF4rlVjYkRy+3ZCM5IBwtdC5oqoHN/TNOFd3am?=
 =?us-ascii?Q?fMhMxRyZeAXBm4aSb0iUcQS6L17/ouaO0JKWH0D4dulT4ehrJAUvzd5tqL4w?=
 =?us-ascii?Q?6BCB0IQ0z2HOTq1mMH7oAoeHTsozCRN+bdDYAPsD03dsvbtmbWLv/bBJBOME?=
 =?us-ascii?Q?PFG1CA7BG9t7HgbpTqbtgkhidG3vtGxPUVi8QUwjNqVlSdbn+zf1S+WFCdsx?=
 =?us-ascii?Q?5Hv/pQjoRuutqVzRrm/w0vam1cCk0vJNQGWEAIr+A3FcHPJ8JGnUcKtZIsOV?=
 =?us-ascii?Q?bEvZPLRteknIB3xY4mwpLFfV4kDEdBPjxSRwPL1NHbMzL9WN6cdMKXIFjAGP?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jZDpchKJw4WyCQZ0hLcAloCc9Bi+z0zLW+eB84EaNM0jijAV4xnl4TYz38rAxTbc05iChbnVlzVotlxlwTDHjyRMREDTfvi3ECqraiV0Fps/s9Q1fk65S9Ph3mMMW5OcQYKSdE7w/szRKqziCPsww99r2aOcpIZdlrUDL4Ji/RF3xjbH/Qba9O4caPZugLe0OE+l/0g44nxPhVsgNkBK+fqZiLIRcRzzkryA4Q8dRw476NC2RR6m/2uQMHIMDV5R1z0DBz0HkYtT4KCHBaW17eSUUJdiZ8zfy3rqw2YGBotMS2Tp/9nQ0/a8H89pIRcaY9J1asRC9Z5EkT+nURP1WXurYmIDcaRzYlIEZ4x5vFdISa5LzNlt/yNFPAUd15U2Ha/uwqx1GFxEVr08TTbTzLCP1o8wMFb+xrPHc1pMH7L1xaWmBWeegEusjLDdNfLlmbauWtzvGM7l3v4zmnBa1BblZquu5pDVM7EtZD7BEI83uWhB6+OhNhv8daW7yDL5ufwgA6ib0pPIFlZP1bEykxjH0ydqkWvKz7xMymd1E2XhqvsaXlwca657OJxCqhec+9OoWxI80ldDsOB9wAnIUqqPWZgzCrLRJfAtOm6+GSZ5YoGWsgHSG5BgovhMhB2rf46jZ0hYNt1Sn+UEM7WrguMLz27GNveK392VtMGkQ/buoVhDRe6r5I1srDNe5JKDMw2Xnf2FKuhdcILBasctQXqkyp6RFj/EqHg5IBX2UIY1HmDvy0tqxDBBuhT9YHbMgK8vxghAb5SX6N+xjVyhOl0Y7P/Govf4Qdv/8qUf3jMsgj6JPQn+mCltOlrsyyO0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4512f6-a3cd-4139-75b7-08db0d777668
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:04:54.4851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BZXYL9IEtefeKahu7/12vDez+nkVRNpJT9vZvkug4FZ6JQDPnQqDiLxJy1Fn50X+8MMnvrrev3gSp3r5knn0BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-ORIG-GUID: 12lpDsPXp3Zrn5AjXJttniCb1-Q8BwFx
X-Proofpoint-GUID: 12lpDsPXp3Zrn5AjXJttniCb1-Q8BwFx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This 5.4.y backport series contains fixes from v5.10 release.

This patchset has been tested by executing fstests (via kdevops) using
the following XFS configurations,

1. No CRC (with 512 and 4k block size).
2. Reflink/Rmapbt (1k and 4k block size).
3. Reflink without Rmapbt.
4. External log device.

The following is the list of commits along with corresponding
dependent commits.

1. xfs: log new intent items created as part of finishing recovered intent
   items
   Dependent commits
   1. xfs: remove the xfs_efi_log_item_t typedef
   2. xfs: remove the xfs_efd_log_item_t typedef
   3. xfs: remove the xfs_inode_log_item_t typedef
   4. xfs: factor out a xfs_defer_create_intent helper
   5. xfs: merge the ->log_item defer op into ->create_intent
   6. xfs: merge the ->diff_items defer op into ->create_intent
   7. xfs: turn dfp_intent into a xfs_log_item
   8. xfs: refactor xfs_defer_finish_noroll

2. xfs: fix finobt btree block recovery ordering
3. xfs: proper replay of deferred ops queued during log recovery
4. xfs: xfs_defer_capture should absorb remaining block reservations
5  xfs: xfs_defer_capture should absorb remaining transaction reservation

6. xfs: fix an incore inode UAF in xfs_bui_recover
   Dependent commits
   1. xfs: clean up bmap intent item recovery checking
   2. xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering

7. xfs: change the order in which child and parent defer ops are finished

8. xfs: periodically relog deferred intent items
   Dependent commits
   1. xfs: prevent UAF in xfs_log_item_in_current_chkpt

9. xfs: only relog deferred intent items if free space in the log gets low
   Dependent commits
   1. xfs: expose the log push threshold

10. xfs: fix missing CoW blocks writeback conversion retry

11. xfs: ensure inobt record walks always make forward progress
    Dependent commits
    1. xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks

12. xfs: sync lazy sb accounting on quiesce of read-only mounts

The last commit was picked from v5.12 since failure rate of recovery loop
tests would increase drastically for some xfs configurations without applying
it.

Brian Foster (1):
  xfs: sync lazy sb accounting on quiesce of read-only mounts

Christoph Hellwig (8):
  xfs: remove the xfs_efi_log_item_t typedef
  xfs: remove the xfs_efd_log_item_t typedef
  xfs: remove the xfs_inode_log_item_t typedef
  xfs: factor out a xfs_defer_create_intent helper
  xfs: merge the ->log_item defer op into ->create_intent
  xfs: merge the ->diff_items defer op into ->create_intent
  xfs: turn dfp_intent into a xfs_log_item
  xfs: refactor xfs_defer_finish_noroll

Darrick J. Wong (15):
  xfs: log new intent items created as part of finishing recovered
    intent items
  xfs: proper replay of deferred ops queued during log recovery
  xfs: xfs_defer_capture should absorb remaining block reservations
  xfs: xfs_defer_capture should absorb remaining transaction reservation
  xfs: clean up bmap intent item recovery checking
  xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering
  xfs: fix an incore inode UAF in xfs_bui_recover
  xfs: change the order in which child and parent defer ops are finished
  xfs: periodically relog deferred intent items
  xfs: expose the log push threshold
  xfs: only relog deferred intent items if free space in the log gets
    low
  xfs: fix missing CoW blocks writeback conversion retry
  xfs: ensure inobt record walks always make forward progress
  xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
  xfs: prevent UAF in xfs_log_item_in_current_chkpt

Dave Chinner (1):
  xfs: fix finobt btree block recovery ordering

 fs/xfs/libxfs/xfs_defer.c       | 358 ++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_defer.h       |  49 ++++-
 fs/xfs/libxfs/xfs_inode_fork.c  |   2 +-
 fs/xfs/libxfs/xfs_trans_inode.c |   2 +-
 fs/xfs/xfs_aops.c               |   4 +-
 fs/xfs/xfs_bmap_item.c          | 238 +++++++++++----------
 fs/xfs/xfs_bmap_item.h          |   3 +-
 fs/xfs/xfs_extfree_item.c       | 175 +++++++++-------
 fs/xfs/xfs_extfree_item.h       |  18 +-
 fs/xfs/xfs_icreate_item.c       |   1 +
 fs/xfs/xfs_inode.c              |   4 +-
 fs/xfs/xfs_inode_item.c         |   2 +-
 fs/xfs/xfs_inode_item.h         |   4 +-
 fs/xfs/xfs_iwalk.c              |  27 ++-
 fs/xfs/xfs_log.c                |  68 ++++--
 fs/xfs/xfs_log.h                |   3 +
 fs/xfs/xfs_log_cil.c            |   8 +-
 fs/xfs/xfs_log_recover.c        | 160 ++++++++------
 fs/xfs/xfs_mount.c              |   3 +-
 fs/xfs/xfs_refcount_item.c      | 173 ++++++++-------
 fs/xfs/xfs_refcount_item.h      |   3 +-
 fs/xfs/xfs_rmap_item.c          | 161 +++++++-------
 fs/xfs/xfs_rmap_item.h          |   3 +-
 fs/xfs/xfs_stats.c              |   4 +
 fs/xfs/xfs_stats.h              |   1 +
 fs/xfs/xfs_super.c              |   8 +-
 fs/xfs/xfs_trace.h              |   1 +
 fs/xfs/xfs_trans.h              |  10 +
 28 files changed, 946 insertions(+), 547 deletions(-)

-- 
2.35.1

