Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DB2C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 19:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19B023136
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 19:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbhAUTWm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 14:22:42 -0500
Received: from mail-dm3gcc02on2139.outbound.protection.outlook.com ([40.107.91.139]:39489
        "EHLO GCC02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727302AbhAUTW2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jan 2021 14:22:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzUeAkAtY5v7gAlI+DTgD4RIqt7BkgPxztOpV8EuAT55xsYGf37xVMzJ6DZcOOk/z5DN+YFj2JABHuOOMXxm9jd5xW6af0GygKeptDLwEsnQixJCPozPHCeE1bjt+R1h5IsoAZJITaDG72i4FozWZ7DV141ugYAdmol6S4E8bu6UhcWrU1L2yTkP6JnM9JHTocAH6DZls5TD0ULxfb2xJ9Gs3HbXVeT7KswsnqCvVIHWhabduFHs4G+8P85LiwEJi/tLP1LLaloeco81YZWzDSiMbqLFZ0CYe0Ffa2lLkurxdXLdMFYr2bTxIijWRgrCSN5egUU49KeKNGzkXNiYWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc4i/5yYx/4QNu8x5zpc+jp150xKitrKlxVwMHdzcBI=;
 b=gpLBSthLNKcImf/sMDnIaZHRGlPDiie/eEH3MlXl+TR1Gx4bk2nNuK+w4RA4/m2at7wrwGnf9CqaZmpHjkUB/WP/1AQlyzTTz7UdmD9A/CM+kAYWO83ps5SCAgAjdj2ZZpDDgIiBfwmY8LlGOazE3zt0go5/gNaCaRuAQvNgQQxrbJlsRG5i9wthZzmgvd2wouWaLW3sG6OP5d7+iPr7xrZIkNRlOHE/srzrTxKUND/iqEFzUsoDj3RZ+j4p0hk2bhvp9mXYVjnwVEkQS2PxkrI0wnK5bhuMRDmTjQ658ViYIHJqDqWi8Qwvu8W4PotQth5aOfyTCgJKwFqdT08sEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starlab.io; dmarc=pass action=none header.from=starlab.io;
 dkim=pass header.d=starlab.io; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=starlab.io;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc4i/5yYx/4QNu8x5zpc+jp150xKitrKlxVwMHdzcBI=;
 b=kGZ69Nly93w/yYqRTRncQrwoeYaFzGCS4WYtCLw/Jj3ECoA13i2fNjVMnxxPXNTTMJfo9uGznBdt1E4zup4NZxrV/qERQuXkXyD4vn5DQj8s6P6ZjumJ5loBogwkxaGUnzegew4lYh4v1S+ZLp4tLQG74WkfDaXGPpBo2NbX3cU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=starlab.io;
Received: from DM8PR09MB6997.namprd09.prod.outlook.com (2603:10b6:5:2e0::10)
 by DM6PR09MB5973.namprd09.prod.outlook.com (2603:10b6:5:269::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 21 Jan
 2021 19:21:35 +0000
Received: from DM8PR09MB6997.namprd09.prod.outlook.com
 ([fe80::d16d:8c95:983d:28f9]) by DM8PR09MB6997.namprd09.prod.outlook.com
 ([fe80::d16d:8c95:983d:28f9%5]) with mapi id 15.20.3784.014; Thu, 21 Jan 2021
 19:21:35 +0000
Date:   Thu, 21 Jan 2021 13:21:33 -0600
From:   Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: set inode size after creating symlink
Message-ID: <20210121192133.GA9807@jeffrey-work-20.04>
References: <20210121151912.4429-1-jeffrey.mitchell@starlab.io>
 <20210121184137.GB1282159@magnolia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121184137.GB1282159@magnolia>
X-Originating-IP: [47.218.202.86]
X-ClientProxiedBy: SN7PR04CA0154.namprd04.prod.outlook.com
 (2603:10b6:806:125::9) To DM8PR09MB6997.namprd09.prod.outlook.com
 (2603:10b6:5:2e0::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jeffrey-work-20 (47.218.202.86) by SN7PR04CA0154.namprd04.prod.outlook.com (2603:10b6:806:125::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 19:21:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7575242c-e691-4f3a-e911-08d8be41c483
X-MS-TrafficTypeDiagnostic: DM6PR09MB5973:
X-Microsoft-Antispam-PRVS: <DM6PR09MB5973A3B04D9A79C1A314FF01F8A10@DM6PR09MB5973.namprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f441okwDE0htOSxz9WzMavTIxhFLK+Gh3ecIMgSdsaK0na6oSCjMp0may9F1NX6nOoAZ5zWFyY1qiLy4d6o4bcB/0N8vz8HDHHrDahCPIIXhZEihbodojvPF+mbsriSIRzewKbfdfE+7PTls0XTIA48AseiCeray7+f07VkTD/c4zVoEkADW7d6rFxsl3kIy4zXka2tQ8kikGzYNPByjH1zTI2RSkgvqPs/jZU/94HNCJzG3o5qkX/Ky0sv1kP9jcC2+cuFJrWHWgU2Q1JZ9UBVFflOweCjdpmoNvbc2hKdjpTR9SoVaAYIh5tLPz8UdTaquDKMny0e1uxOQhORL0cmEgP1UmzUByY+x981des3feUvndmcPym9b+uAKCb2vXoVRW0cVtx3rQj+QUc8xhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR09MB6997.namprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(346002)(376002)(136003)(366004)(478600001)(1076003)(26005)(6916009)(316002)(5660300002)(16526019)(14286002)(2906002)(6496006)(66556008)(8676002)(4744005)(66946007)(9686003)(83380400001)(6486002)(4326008)(66476007)(186003)(956004)(44832011)(33656002)(52116002)(86362001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XquzyA3D2RYAemjD7RZsyeKp8io8h9nqt4Z0dal59OX8nY79Byex9IOZIvft?=
 =?us-ascii?Q?rZthngqu9h8u8mWP4H11lzmXuPxvsHMBY9jYXzBRw9ZM3+sYfDFt4THGjuXD?=
 =?us-ascii?Q?vqS96k0TwXzuBi+7VXSTSL9+t7m2FAEV1Q6hVOJAdQ+IqSVSHm2pxx6xXMMK?=
 =?us-ascii?Q?U6jK7GEsOvLZ/fo0b/9aZiECQqazAXwnFkxiDhm9DNW4gcHuD+0xIUPSXzci?=
 =?us-ascii?Q?plTq0xaL61hVbW3Lw9UqGnE0uB04nusza+4jGxZmHRqiCUxW3UP7RdTsfjzQ?=
 =?us-ascii?Q?dDxEVa86//IWYKIRF1q0HvkI3hfT+7z+7iI9QWJmIPSKpb6Z2RhSKZFCorFG?=
 =?us-ascii?Q?u+5FZ1HPVrVYem2r/Am3CzcT2TWAxo5/v+A/dFWTMohqaeZ50+vcGwwoIKKa?=
 =?us-ascii?Q?KeEKy9Ocu9w73N5Wfg3XKwl0HMjoDypFxY9CJd9EQ4EcH04brHLAWmnmHMIi?=
 =?us-ascii?Q?qOnH0fNi/9/eMTZZDRMiEcj4JUM2hzPwL+cLSPXla1wJ3HpcwkmW42IGn//h?=
 =?us-ascii?Q?tAaKdMsW5Vr5v1bMaZKoDzs4Sm+nUdaM4+JGArDanyb8ZdRiAczB+6Hs/O5T?=
 =?us-ascii?Q?m6mtSJlhD43y3D0nzW5hU0xKMKWX9DatvZykg+Hjz3fjkcuvYGZaRfncjtJh?=
 =?us-ascii?Q?lmHnb/mb5C0Z/n4fH513FzCt/tzdnSQp2F2hqWDONvndz5SUiRWBZPo+BFyc?=
 =?us-ascii?Q?FjOiLJlfkoG9mC8+W/6vCcBkxeUdlS1VOas8IKyKSnLcq2CKDE5Z/Js3pjrm?=
 =?us-ascii?Q?yLkWBdWOah3QevJmA3SlXo6xwgVeksYlF6R+avxGLx7ZCQqckEiWfh/oHGJD?=
 =?us-ascii?Q?3hxn8elpJhYcSqhrtvwGP7sEbj9mTAAoXNZNFg6p3ksYJO6FQcn8s/Nf4taO?=
 =?us-ascii?Q?kVk5WMhQx+VaBGFdKjvu8fTi1toEX5hwIGggEbKyYednDAlQnDr349uJ92hh?=
 =?us-ascii?Q?dv9eb7d0fMQasG6EUG9m5AP036WRv2IMTFn/ABPrlXZNNRQFfR3UTmSsCXQE?=
 =?us-ascii?Q?LurZ?=
X-OriginatorOrg: starlab.io
X-MS-Exchange-CrossTenant-Network-Message-Id: 7575242c-e691-4f3a-e911-08d8be41c483
X-MS-Exchange-CrossTenant-AuthSource: DM8PR09MB6997.namprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 19:21:35.2991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5e611933-986f-4838-a403-4acb432ce224
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+mxlKSCWbOc1dWTXBbgBEeks9lwJVXdkeyO1A86xu7qeZHpR13KBcBG8GQwZqMvdWj12S2gw18UDwc8TGswCxVgbPjIE4VY1mODb9xDzF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR09MB5973
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 21, 2021 at 10:41:37AM -0800, Darrick J. Wong wrote:
> Do directories have the same problem?

Yes, I just checked in a VM. While ecryptfs does call vfs_getattr(), it
only uses the "blocks" value to supplement the data from an identical
generic_fillattr() call to what ecryptfs_getattr_link() uses. The reported
size still comes from i_size_read().

V/R,
Jeffrey Mitchell
