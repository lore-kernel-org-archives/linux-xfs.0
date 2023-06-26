Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262BDEB64D7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 12:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjFZMIr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jun 2023 08:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjFZMIq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2023 08:08:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0FFE43;
        Mon, 26 Jun 2023 05:08:44 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35QC34p3028964;
        Mon, 26 Jun 2023 12:08:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Da9HzMPfeK6dbX2P7LNsZtJn7Tfp10/ZZY053NRW+Io=;
 b=daxzMtGsmBO8ggqz4FiYdUZoVTjc8ZYL1JKy17Ztex1fkEbqMu7e985OCKm8pO7Kv+VQ
 G1l2Hb8ys6tfaeppysV4eNELZ3C5xrJhGrzSuUngyrdRrQkMLEta03jQbcUoFWJecqPl
 EmEDsEfRIqmX+E7+Ty3SEbe+6KO2Yf1MTjovVK+LHRb43q3GjZWQqpjuZVyYiJx9Y40v
 D1hXXmBtF/KTZ9C0BRH+5KmKb2MHDEMYkqCRLInZ4rQcHB5zLWfIjIyIo5ZF+AlVAMR3
 r5g6e3Zr24yNzIEAQworKtv8WqAq2wAVc1ODuTXwDqvsy0OfZK8QUe8k5OMG5JmMN+2V tQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rdqdtjgkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jun 2023 12:08:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35Q9viHW033853;
        Mon, 26 Jun 2023 12:08:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rdpx8rn4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jun 2023 12:08:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wtmm3QchKBXqGMinTL21r+swwM4VhpOg27Ik/nvYtAzWG8a8mGgNIaSkGs6rm9IFHoGX2qvMBpAVMMrACRbbGypfVDXdEHhQRh7j2mM1SQSO8TJMd9apVhy2jjiNYCgpQWCyA7uYjgsVeYOEQ6xagj+svlU2fbOxrRt7jzKccVw9HAMJMI3IgIOYmWhCjKKYwoTx41Ye3InrTJG9YbI4KqZRkqW+T4blq/pyV+KSWvVZ8pT4rHtbGTIFF6N0XYxicRDVy41ZcrKMeY1EiqZL9s8XBzF4IihsM1gd3mGOWxvWCXKrng2y2SGIW9Xwvids0ZS+0NUhVSjpt8BfJiislQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Da9HzMPfeK6dbX2P7LNsZtJn7Tfp10/ZZY053NRW+Io=;
 b=Tn2wo17JxTg10f/Nd5wknO/zmVmBR9Pr5y8PLk38g28eU8HitdDOdmGjRMMwHoGxDzOdAWYoZqglRhOzSsJMBb7TjNd36cxBLxZpWszWBU1L1vIFFIJgyeJEM9T8KsGLEVnQA2mFx0DykJRr3Q0mTa2LoBlFWKvHA4ZA4V+BZP6nP+oM7WlNZQvN90BH5XY6p6dGtBJtaO7hjoJDzbhOOcUt5+q1/Iq4bg/gsP4cCuvWADg2ftzNxv2+nAKkZm/47nyyWd5kFlf7B5fbayrnMFupPCYq/+emXW3GcbSfrk+gPlS73eXkEn1ZVjSwCf34CRyAJBfsKvkT/w8UoWEElA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Da9HzMPfeK6dbX2P7LNsZtJn7Tfp10/ZZY053NRW+Io=;
 b=vAU4uq+hdf+yHSK1GhutVzq4Q4hNEmQLwDcqnEIeexq3SdKyCrgj2KTQ6HuiyoQ1UU6ztayyaMOzemr3ExabOG8VOIHuPwrb1KZYYU4rMwcG80zZ8O+zNZ/eyT7ZDJDWfh/hAVNL55LVANKXOOkxH8glhhL5LjCl+sVByp4fNig=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BY5PR10MB4289.namprd10.prod.outlook.com (2603:10b6:a03:20c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Mon, 26 Jun
 2023 12:08:33 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17%6]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 12:08:33 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4] xfs: verify buffer contents when we skip log replay
Date:   Mon, 26 Jun 2023 17:38:26 +0530
Message-Id: <20230626120826.1770707-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0213.jpnprd01.prod.outlook.com
 (2603:1096:404:29::33) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4289:EE_
X-MS-Office365-Filtering-Correlation-Id: 95a1aa82-2b58-4946-7a60-08db763e103b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+YrBJ4IkaWzL2ACsJfPvS1DuvBLl7yBCs+62/CXwVa2XMBqZpRZTFNjGAKDTPhP8/mrvh2Aq8o0RjNCsYED13qkHl9OwGy1Ab/UEDvr/DdGKOoIHYAme7vDe0sXQ7q/omtEY9GeqaLD0PAwQsjlzu3Pen5moGR9VuhscyQav0hxrrF74B1f3kE2tfbjW+eFFSbh9lHyBKUDpuzHZsvTspeYeP4WcrM/Z6gj/jPyqo4cm7oH8oR33Ogzhqkii64aONEGYJltVzAi5N4NJN1I5IchWKC1kulp0FcKb7ejzhuk6r4T2JABFKHJOVK1Yl7fnU2mtQZj9S0skziSHUwr+mjS3TZDLWwHFsZ9on8lImG6Rq0lDc2I2KEzXI+V/C8ASUhSdt4HXmKs4naDPh+5lr9oMi7BpY0tcV+l6jjKzULO4tm/yC306VuWkit1rLO35w+pyXLVcjVKlojVbm2rqEBqSMj1WFfIR9n4qW7gZ0FuOa4AJ50nMh6eGKai3gMqeWm3bhBqXDUPsRS7xGoaR1qD4P7b4ob4GwiPPw0YkRqmYINLIDys69RrZ1175gwZNGk/UQaITxpyDwNoW++KICBtR00H+DqK86suOMhOQNs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199021)(2906002)(6486002)(6666004)(38100700002)(2616005)(83380400001)(6506007)(26005)(186003)(966005)(41300700001)(86362001)(478600001)(66556008)(66476007)(6916009)(66946007)(4326008)(316002)(36756003)(1076003)(6512007)(5660300002)(8936002)(8676002)(15650500001)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hXfscwd/7hzzIDJ/cp+A3/07rFBtEf4a8cCRNQvvgczjDtTQYySpdVHlho3i?=
 =?us-ascii?Q?lUhxR22+ExuYdse+P9JJ7KJGtOutvlTBzIgRNBp+EX+6bpykudvXM3Zn+G4l?=
 =?us-ascii?Q?bClIdnmJNhmxm4Uo+kMK8OjXrsrGNQ1QZ4ANchUIki2+5gno/7xFSm/sdh/+?=
 =?us-ascii?Q?q6jruROwMcyWnd9xIFHPgOTf1faCN3ZNykjOJ4TAmvMx4PTG77ekd4UB/1E9?=
 =?us-ascii?Q?OYJiwtbvWNT5w84D8hLKO+TTO0a6c5N6Vwf9F7VUI5RIobiNy/jdgQSL+QpE?=
 =?us-ascii?Q?eY92DYo0YalcZ2FYtru7a0vrVSCBASq2bJt2ySwxR+L8hrEQXoS4Yx+gvVqZ?=
 =?us-ascii?Q?uDJPQvCjwwoWdwrbXitKKjSqnnuzGx/uhQRlkjrqYYTly6kUmSrADJ0/xyKZ?=
 =?us-ascii?Q?VgdeZ0V02A97Hmskd4ydzDumC4cEueJjxTU3aifeXlxZMy6/t3eQ3IXDP53O?=
 =?us-ascii?Q?0+QLgqbFYYk065570ooth0Jshrf86yBAIqkIkLxvSFut5CQsuWSbJPRJfGEo?=
 =?us-ascii?Q?UWBMWtqilDNu/8srLGeCn9SgKfuQ0X/2lwckOWkXb6qmvE+zGDQEwvtZX7f1?=
 =?us-ascii?Q?JA8Mc13XWOYf5GQt/fVpZ9xKr3EwX54P0nj5IbsAVqXlJgMZyMcMk1tcpyzX?=
 =?us-ascii?Q?08NWN9valKgbfnMliug0Z3NuT52jM+liJmOWIzpfyfLuL3d+oYFTib9cxl0g?=
 =?us-ascii?Q?F28unXcZcRg5TJTjupxqkKPPTTQEpaCERIFrI1VfM9D3iecU2xtvWAZQJfd5?=
 =?us-ascii?Q?7mW8DusXcwv+Lkp0Tvml45v1gqiZXX3KbZVJvrqW9LGw26lB0pgi5U+zIhUp?=
 =?us-ascii?Q?7w/S9nPISrdbnbBGzHu8Z2OxcOV7CzmhMH731TrL9v+00By8t/kn4g3liq6S?=
 =?us-ascii?Q?sMD05MdtGQsR6KyGS9HK68SzMnMnCWyzdo5fgbxJDJgrY2fm9MGR+F6fh9Hv?=
 =?us-ascii?Q?3QXC+1olAKwbhwhaSeiD89X9jmu37HeyfM3erRB8E24QKBeFkNkvdTkIzZbh?=
 =?us-ascii?Q?O3C6Ba8HYv74Xa61pIZ3xoOYLirEXaG2QwHP7IrKp1MlxRbxRYl2WwEnfANr?=
 =?us-ascii?Q?0cnN/FOuIHXrvSI+FNnaHxb+ki6hlIpNK8y792He0k0u6nO8XcRb4hi7EkLr?=
 =?us-ascii?Q?HVvvVlioi/K7/+RMhUiTEA6QWzwBXcancLtgUVb/GlLs4dxx7Z9FtAxCglAe?=
 =?us-ascii?Q?MVlGUH+gFVgzT9e8Wj00JKe3sBroWGyJqGwuyFLOHHB2qclZL5lDaJj4PIMq?=
 =?us-ascii?Q?PHzNdQk5f6MVmHUrl3qmDJc00eCjwqa4/WlywqYVIpLowdaCO3ygv6c+lZcl?=
 =?us-ascii?Q?gbh2eRHvFYUDPCo3nSo+dQ65NK4/ibnOvNE1eEythYT2gfFffLmPnD3t2aTz?=
 =?us-ascii?Q?z6pOZVdvaTLqhokW36aMbcezdqJlUh01szZTEu5grh1L9KXdvVMTUe5LH5Mf?=
 =?us-ascii?Q?NX405ebOBP2ylGYHNRg8tBxG7oX24rX8mafGPJnRqCPxFIKd2DGH3v0yu5Xj?=
 =?us-ascii?Q?D+1l+vuYIinguot5b9NPYaddJdglSF/LakrppfbKGRiqL0RICN6f8GoePqzA?=
 =?us-ascii?Q?24FL59dns5dJ8ugAX4lLqQkqEL9ob9AgW56faZAZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4I4Lb8YsLXXimay1bgCTpdkmPKJv9nbXVJlQodFvOg91dn/odU2aA1yfOyVJSFdhz+bsNjiGd/HcF27svE/ochwMW0LIXRE8HKD1RqT/83ReSpGbwrzoQlF/5I/yVesLPkMj/2kNBAvZ8zE5hB4d7BVezNsQmH/aqF+h6TbvxdU49clTGrdo/eByda02a3hs7NN5oUddVNYJsW63Ocuw+IP6fVYVF1TYEJyEzaiJXsTeHyr4PYnozxAbI2E/nvYFI2krd0EvgH8rWvsAECSKm4bF0AJLYiXzNo2tJHfv4mCdO1qnrDMWBB/ywjaWAR2jnwf/Wlx3LSHJjFRhU6WbpGVms5l2utZVb0s9uO2OuBzhSeup/13nxhORC3XLUXZsc0qeLsj4FYiYkgfyVWZY1IeQdbp9XAVXPCGBETNaw/0eM9RsB344EmTCL9WHiE9Hq889yWp4euYLJQLVfxasaIxofO/VZXZXSgj9+gEhmxynFwE3cEfLZBdXSMBFzfQvMCBWgdKfks5eC5xoUVJLfXaL6PNOXzRoc13ZPEsop8nSugb64gLYHTAIsKsN6f3LQwMCVnx3UkQPCR+81/AEgQINfx6+l7XwyRfF8w+gI3qjwYnwRrth3oYFzNr+tphCu6ehSNHyzXZmj1OKDdLp7mTj0FH1/a9sXslphkKw+MB+aTClasJOrJNFDuhnhuo12dKwpDN7EFxjx2aFjPXG9ex2msC6wfefJ/mAe/7UNQSzWPBEjZU7PUdMHRctw3pqCSVTrDEVxYyysh++vrOwjXpiDKRde2cvqMq11Eb1lfT+BbY2VvY59fEMjn0eml7WnfagurbAXKtEGOIgkKKJYtitoEDorVOkDPLdQcvjgrz9vwdjHLLyko+Cxxg8MztX
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a1aa82-2b58-4946-7a60-08db763e103b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 12:08:33.7077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cf7kIC0ypAhvJphX9spIkJ2g69+gtvVnvAN2qPWxpkyY/z6Ctxz/AhNihkX3puSRV4aZPVhyQoQmJ03XIy4qeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4289
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-26_09,2023-06-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260109
X-Proofpoint-GUID: XK0PSa1nya2YXXjQmivd2Z7KqA-dRYyF
X-Proofpoint-ORIG-GUID: XK0PSa1nya2YXXjQmivd2Z7KqA-dRYyF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 22ed903eee23a5b174e240f1cdfa9acf393a5210 upstream.

syzbot detected a crash during log recovery:

XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop0): Torn write (CRC failure) detected at log block 0x180. Truncating head block from 0x200.
XFS (loop0): Starting recovery (logdev: internal)
==================================================================
BUG: KASAN: slab-out-of-bounds in xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
Read of size 8 at addr ffff88807e89f258 by task syz-executor132/5074

CPU: 0 PID: 5074 Comm: syz-executor132 Not tainted 6.2.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x290 lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:306
 print_report+0x107/0x1f0 mm/kasan/report.c:417
 kasan_report+0xcd/0x100 mm/kasan/report.c:517
 xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
 xfs_btree_lookup+0x346/0x12c0 fs/xfs/libxfs/xfs_btree.c:1913
 xfs_btree_simple_query_range+0xde/0x6a0 fs/xfs/libxfs/xfs_btree.c:4713
 xfs_btree_query_range+0x2db/0x380 fs/xfs/libxfs/xfs_btree.c:4953
 xfs_refcount_recover_cow_leftovers+0x2d1/0xa60 fs/xfs/libxfs/xfs_refcount.c:1946
 xfs_reflink_recover_cow+0xab/0x1b0 fs/xfs/xfs_reflink.c:930
 xlog_recover_finish+0x824/0x920 fs/xfs/xfs_log_recover.c:3493
 xfs_log_mount_finish+0x1ec/0x3d0 fs/xfs/xfs_log.c:829
 xfs_mountfs+0x146a/0x1ef0 fs/xfs/xfs_mount.c:933
 xfs_fs_fill_super+0xf95/0x11f0 fs/xfs/xfs_super.c:1666
 get_tree_bdev+0x400/0x620 fs/super.c:1282
 vfs_get_tree+0x88/0x270 fs/super.c:1489
 do_new_mount+0x289/0xad0 fs/namespace.c:3145
 do_mount fs/namespace.c:3488 [inline]
 __do_sys_mount fs/namespace.c:3697 [inline]
 __se_sys_mount+0x2d3/0x3c0 fs/namespace.c:3674
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f89fa3f4aca
Code: 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffd5fb5ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00646975756f6e2c RCX: 00007f89fa3f4aca
RDX: 0000000020000100 RSI: 0000000020009640 RDI: 00007fffd5fb5f10
RBP: 00007fffd5fb5f10 R08: 00007fffd5fb5f50 R09: 000000000000970d
R10: 0000000000200800 R11: 0000000000000206 R12: 0000000000000004
R13: 0000555556c6b2c0 R14: 0000000000200800 R15: 00007fffd5fb5f50
 </TASK>

The fuzzed image contains an AGF with an obviously garbage
agf_refcount_level value of 32, and a dirty log with a buffer log item
for that AGF.  The ondisk AGF has a higher LSN than the recovered log
item.  xlog_recover_buf_commit_pass2 reads the buffer, compares the
LSNs, and decides to skip replay because the ondisk buffer appears to be
newer.

Unfortunately, the ondisk buffer is corrupt, but recovery just read the
buffer with no buffer ops specified:

	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno,
			buf_f->blf_len, buf_flags, &bp, NULL);

Skipping the buffer leaves its contents in memory unverified.  This sets
us up for a kernel crash because xfs_refcount_recover_cow_leftovers
reads the buffer (which is still around in XBF_DONE state, so no read
verification) and creates a refcountbt cursor of height 32.  This is
impossible so we run off the end of the cursor object and crash.

Fix this by invoking the verifier on all skipped buffers and aborting
log recovery if the ondisk buffer is corrupt.  It might be smarter to
force replay the log item atop the buffer and then see if it'll pass the
write verifier (like ext4 does) but for now let's go with the
conservative option where we stop immediately.

Link: https://syzkaller.appspot.com/bug?extid=7e9494b8b399902e994e
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
Hi Greg,

This is a backport of a patch that has already been merged into 6.1.y,
5.15.y and 5.10.y. I have tested this patch and have not found any new
regressions arising because of it. Please commit this patch into 5.4.y
tree.

 fs/xfs/xfs_log_recover.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 84f6c8628db5..d9b906d75dfa 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2783,6 +2783,16 @@ xlog_recover_buffer_pass2(
 	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
 		trace_xfs_log_recover_buf_skip(log, buf_f);
 		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
+
+		/*
+		 * We're skipping replay of this buffer log item due to the log
+		 * item LSN being behind the ondisk buffer.  Verify the buffer
+		 * contents since we aren't going to run the write verifier.
+		 */
+		if (bp->b_ops) {
+			bp->b_ops->verify_read(bp);
+			error = bp->b_error;
+		}
 		goto out_release;
 	}
 
-- 
2.39.1

