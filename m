Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44005C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 15:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F007123A01
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 15:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732856AbhAUPWN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:22:13 -0500
Received: from mail-dm3gcc02on2124.outbound.protection.outlook.com ([40.107.91.124]:9473
        "EHLO GCC02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732816AbhAUPWL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jan 2021 10:22:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpMoeXeB+EEuy3IOkWMEMAKSJZkyKVcf4eCO9XJgXOm0lMogyjLQSPO/lxgo7CSEF36yYSxLWRgvd/TjqEz71iEkQqOjmlJ4rl3FOhOiI20CNowUmc2EX9t+R9fzj73gd/hyRI+KGtNXVm+Nqj2hdRR/FLudSKZiy6xSXUJ2jhjeKEkaeYtQ+YPY+bVklr9tTRrAmLhx6ZIER2acB0oloqZLMqzJfctoVMK0G5Dc/dWB4h9/Jb1guLX99RRM+Q2paWV/zjas5CMZA4eMbfOfmTDFFg+TfJLI2N5ffiqErZWxoX/mOOV6MsZBlrTK7wgSv0NvWhG0JFHJmy6MZFMAYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9S8iJSn8UNaWvTGmsPAdSoE2CeJdUZXi/9w6ogznaHY=;
 b=MnuoL9ljW4lPJqb/d2hczlpGaFtuTADVG9jg/6EpGIyl22LxWM3t67R+DVaouzR0SOsP+lBgC+CcEUt6Tjuc1lL/uwC/IgmvVWMLf58AkGyrex0gqt3YvtrXOazfveEjcTeFvm+Ugx9RUqfOoMOtXhUy+3lpuICEX51aADZxtk6fV7OjACUR3Jv4iGlP0hqdiy/zW6jBbHRNRoeet6Gaf3/4yWHKe1528FU8N3yqHEByt1qJMOvZtDUyBwHIes1aM4UBQxkaMrKRiGGA0FP7ShBgjJOcNknMP2kNNNBAnEXfJ6XHXjR0t/xr7cLWbbI9e58xE5DBGSiBUZaulnQtew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starlab.io; dmarc=pass action=none header.from=starlab.io;
 dkim=pass header.d=starlab.io; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=starlab.io;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9S8iJSn8UNaWvTGmsPAdSoE2CeJdUZXi/9w6ogznaHY=;
 b=HCfqxQbKMXqyyqJgjkyfa/UsYvcZGHCLopsKDN+TjL4aGayZ93MdC7TXZg67e5KzwuLKrxdVCxyvKxwVSiBn8m0baCq9dg8wMD53MXJzJABK3tusLZcK8VlQhEA6jL6BAgODM5FR/bgVR2qV13fddT1e28w31h4rHAMpPStZqJ8=
Authentication-Results: starlab.io; dkim=none (message not signed)
 header.d=none;starlab.io; dmarc=none action=none header.from=starlab.io;
Received: from DM8PR09MB6997.namprd09.prod.outlook.com (2603:10b6:5:2e0::10)
 by DM6PR09MB4383.namprd09.prod.outlook.com (2603:10b6:5:1ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 21 Jan
 2021 15:21:17 +0000
Received: from DM8PR09MB6997.namprd09.prod.outlook.com
 ([fe80::d16d:8c95:983d:28f9]) by DM8PR09MB6997.namprd09.prod.outlook.com
 ([fe80::d16d:8c95:983d:28f9%5]) with mapi id 15.20.3784.014; Thu, 21 Jan 2021
 15:21:17 +0000
From:   Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Subject: [PATCH] xfs: set inode size after creating symlink
Date:   Thu, 21 Jan 2021 09:19:12 -0600
Message-Id: <20210121151912.4429-1-jeffrey.mitchell@starlab.io>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.218.202.86]
X-ClientProxiedBy: SN2PR01CA0037.prod.exchangelabs.com (2603:10b6:804:2::47)
 To DM8PR09MB6997.namprd09.prod.outlook.com (2603:10b6:5:2e0::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jeffrey-work-20 (47.218.202.86) by SN2PR01CA0037.prod.exchangelabs.com (2603:10b6:804:2::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 15:21:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 844c8eef-5fa4-4ece-af88-08d8be2032d7
X-MS-TrafficTypeDiagnostic: DM6PR09MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR09MB43830ED8A8DF5001D723C02AF8A19@DM6PR09MB4383.namprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FU0OfbPpKTe6aAGYgl63ZqM2ObCAiblXCFffiO1vkVBL7YrCxUYPTmcCV0e5ZtKTOD5lGHSEQugGv5GE9lNc78liAsJ2l3x03pC034GREXlFLPxoUWAJ/vOFkDHR/Y+UmGl2dgNHTDrznyMIPhT6tsd8Wp2yc7PTnQj68KxUV4xzqt/BHtulztTEmsNDSJ50QIJcNMg7pqkFhNQ82IFz3BQQqMif41eG8QfTlI4GCVCV6b3r5YOpJtdUjkGObWYTYujOKYzaRmgnam0sLAwXciCY4wU+Vpvg0vK4zH8l7h+dcWogYuce2rSOQ3+30uq1pYXvtKpF6dc6s/163wQ4ENRI4E7V1lA+ABtZM3EZ7fHili1yyoLMOF7UwL5MEst5hFU7P4xd8fdnABsitpz3X2eh2Ust16KC1oK67LFsTS0KSLJnbv7bMfpy9wCdIyHcIze4lhPpiYs+lJFoS7MxQskm22qmxE1M4+LGuVJMgyv4DMlaO1bv10JqR83ZmHxZuKScEQeuhuVe9kPXXCUoZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR09MB6997.namprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39830400003)(396003)(376002)(8676002)(4326008)(52116002)(6496006)(107886003)(6666004)(86362001)(44832011)(956004)(2906002)(4744005)(2616005)(5660300002)(26005)(186003)(16526019)(8936002)(6486002)(1076003)(6916009)(478600001)(316002)(66946007)(36756003)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4H7M4mB83xYN4Xlgnj2j29VJ7Mp/IP1fjlcki+iYBEXaiuu0pMjsWtgR1MaC?=
 =?us-ascii?Q?Lrg3qYGhKPAqvgo+6flS8g196PIh7h+xMWY9eSzFByLVN5CZyKFiRJUYYyXP?=
 =?us-ascii?Q?Kj2bdzUrKhiF4Jm1unWi9dQdh0TfN3dX6Y6BhRrMyAMEs+gycnNqZXyadwNo?=
 =?us-ascii?Q?kgq6xdIFykdWTMHcngUOV/85E2KINvAyXSs8XU89th/2mz9dM3m+4V+Bp7YD?=
 =?us-ascii?Q?5kCQc0KNQF5NL/eTno+vBGJmTMsN6wbH55ynXAo6RlVQI902xlfx5/q6/lLV?=
 =?us-ascii?Q?MvA8BZLVe5YRDJNmSO6o961AKF5PUSYjZLl18SAagDrS9RkhZzRj5YfeQ7Ph?=
 =?us-ascii?Q?GZKbWzxHl4zcnEXNNTgRR80vQSOQNe+iUZ4fS3VQuevvWJnJtPmfRFE8zPui?=
 =?us-ascii?Q?vhpFiDG/kaN88pKW2pDzK4Obd24/n72VPkptGNMbnSWauQ9U6LVBTwAwssUj?=
 =?us-ascii?Q?H9VHU5wDxnzZzN+j7/sBElXCBztNmFepKnrFFE9s9wJksgQkCBqtzDEAEg/0?=
 =?us-ascii?Q?zlPciq56fPAsio78RrGfFu2gVw+47B4gm8kw0VhTEscZ1eUgidIya+64owK+?=
 =?us-ascii?Q?wfEPs65b8JguiBcVQWQdotObSNdB9GN6m2p4tGdrLq4UdC8B//9FP/QTVjCe?=
 =?us-ascii?Q?AI8+WgZrAQJ/+bn84AOzIaD6fdFC4qzCUoevtEWBFeOtzUWfYm8rq47zzniI?=
 =?us-ascii?Q?IMVDswvo73iHo+VZFkPvU21u8iwkDUVaeSmhXeU2MHuODAEufPtinLBRfl7H?=
 =?us-ascii?Q?GH6MKotC+PQ5M33emjPdpSYrNsxNO1OmYCEi9hKoxsMjWyDkigh6EwMWcNRn?=
 =?us-ascii?Q?qn34vMNB7iCxUPyf2m4BDEMhPNk4P7sdhfVy7C3mM15wqnWlFv1//hT4eO0n?=
 =?us-ascii?Q?mURGIAVvKX2Qw5ZD/fGJFQ3Y5uulqf17j5NLyIAl9X/eDZ/KYqOYPYhvHyQ3?=
 =?us-ascii?Q?z6wjR1Jf5aEwZgP0YuFzZQg9WwoIuOniD0Man1xN4gdvdsDDjuoZsAmNjRqI?=
 =?us-ascii?Q?kqxY?=
X-OriginatorOrg: starlab.io
X-MS-Exchange-CrossTenant-Network-Message-Id: 844c8eef-5fa4-4ece-af88-08d8be2032d7
X-MS-Exchange-CrossTenant-AuthSource: DM8PR09MB6997.namprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 15:21:17.5157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5e611933-986f-4838-a403-4acb432ce224
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RCswuIndXV9RnCF5A0zW+RmaayyWSMhCkNEYSKcWQHAm5G1zy3PkWA2ZqyTz1MRFf5O+Mn+k/Dl1GUTmFRcmOVNvFMZXR2s8RhN7lqiT04s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR09MB4383
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When XFS creates a new symlink, it writes its size to disk but not to the
VFS inode. This causes i_size_read() to return 0 for that symlink until
it is re-read from disk, for example when the system is rebooted.

I found this inconsistency while protecting directories with eCryptFS.
The command "stat path/to/symlink/in/ecryptfs" will report "Size: 0" if
the symlink was created after the last reboot on an XFS root.

Call i_size_write() in xfs_symlink()

Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
---
 fs/xfs/xfs_symlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 1f43fd7f3209..c835827ae389 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -300,6 +300,7 @@ xfs_symlink(
 		}
 		ASSERT(pathlen == 0);
 	}
+	i_size_write(VFS_I(ip), ip->i_d.di_size);
 
 	/*
 	 * Create the directory entry for the symlink.
-- 
2.25.1

