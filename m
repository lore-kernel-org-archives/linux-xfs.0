Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71005C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54E3461107
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346672AbhIXOLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 10:11:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7552 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234851AbhIXOLo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Sep 2021 10:11:44 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18ODQEEM017543;
        Fri, 24 Sep 2021 14:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=uPnoxgK5lkNDyYAQjYfTvA+5ElU20GBjC+jINjn8XRM=;
 b=Piqw+Yi+VobU66EBOCLgrpInLvz3xr2XbSDMQwuK679tQpH3Sh6f7LVAUEI/UeUv0Zpq
 pKwF1tJwB0IxwtPRFtE8NAnIOWCdR3WT8iStLssgQTZVon8hlQESiKjq8+MvZIzzEJiN
 LmrUkQBkZuXxavYncg4COOG/f+5wJrLx2Ofi8v0QeISkdLg6f8g/dhFsfwsThaTD54JB
 6CggatALOO+6zM23xsDYfuc1++SFJMEvlrxJUH6ifXdv0JE8MlKL+BqsxSLShU0gCKff
 FKEojh4yFI1hwvejQYhCP8O6pG4TvaoLHuQsyHJe3I6gZQI7dzVGbgqRQvKolqstRAqk Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b93eqkq0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18OE18IR195511;
        Fri, 24 Sep 2021 14:10:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 3b93ft1fbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5rQrhsbukYuFWFjHD9DSD5SNUJDvydeklgl03I0swYGVbS1U2jdeZsChmWdXND94hvAiBN9258v8QEG3HW5mCMVf1KyVbWoiJdY/JrVeqppF304Mb1S+/L+Gpc4BwVjyF+Zh8oIvGBkiJCDewzLLEBqeXzOgb7fONB3x4z6N9LpFana731j4Y4VJc3yd3r5HxPy2+VrusPZ8JR31jgZB7VL1EstZk+lAAWFC1DPfDTN5ay8Bt+166Pf/RM7czkQifznu0Bn4hUqXtW4Yhc++JLllNNfzvlw9y/QppeZap1nvDn8fxn5u2nQm2OiozNe+y7CGkgAILWX3XCm5UHzhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uPnoxgK5lkNDyYAQjYfTvA+5ElU20GBjC+jINjn8XRM=;
 b=lk0aiRskgvtNZs6n5D7bpd2IRHGnWA9IeDo2gf3wRW0LX1JHwryygvnzvAR1znqIRDhLZXqtnHTmb1sesoNp99nMz+t3DUi53kv0fi7QzuzF5W0pm9D7J+Z8FRrxb0tewkATZYgMlptud1jHreHTOfWEe6sU2ytuQQo6JYGTQFzjGAgg5HpKOTLi7J/6XiagzPmf6rPb4RAX6Sez82melMQRRWzF7jio3FFh7XcQuIGHp/GEoBtTtTDLRwg6AsLhd7idZDThAz6RcWxYjkItX0QOJ24H8ucYF+8X6TEQBm/nfssTNomkYSBWx/+fs2DnuN6QNH9xHyJyO+rDBIBvrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPnoxgK5lkNDyYAQjYfTvA+5ElU20GBjC+jINjn8XRM=;
 b=u63azBt/DcYbeNDQLruIcgcBLIeZY1UIlcwbYW+BiLjFFpReI6DbandrSsgtA+Zd68R4YQWkyN15J3BLfBSCb2x7JQAANUqnoo3hM83nR8g/J7BVsnirulLs5L3cm0DxhSl65d232yvZ+ZFWw424qqDSKhW1hAAEudCDZ6ADyKM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2541.namprd10.prod.outlook.com (2603:10b6:805:44::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 24 Sep
 2021 14:10:04 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 14:10:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, david@fromorbit.com,
        sandeen@sandeen.net, djwong@kernel.org
Subject: [PATCH V2 0/5] xfsprogs: generic serialisation primitives
Date:   Fri, 24 Sep 2021 19:39:07 +0530
Message-Id: <20210924140912.201481-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.179.80.2) by MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 14:10:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 480b9b0c-9b11-43f3-9edb-08d97f650145
X-MS-TrafficTypeDiagnostic: SN6PR10MB2541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2541AB955B48056984B82443F6A49@SN6PR10MB2541.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SEZRZaOPpZ1Fs29APFtER18dypll810pXlCqKlCXX/doL41aXK1IoT1s7IaaO1hK9mFN61Uvp6pc1hdfFF99a4N0JG1bhmGtzM/469TbYFcOFYJ78Z/4js4fRjvnAlG0zC2SWValmiRLPfq3pvwf3C0IJp4BDGdn51Fyg1g65TUG2cY/Q7qDWGH/URL97no3kVYdu+irCtEdD58Y7pFdADVNqOHlWFvE6o5hCgMPAZfuXhduMey+81wESEIPN7VeEA+FCkKCIhMPFhBg+G5lTZkRq3s8KiNGiB/O8RDxCzDwJay+ZS0dlXImYIDlU4lsiFnQUZhsxyUw87NwhQR/iGE4wzeqY2VCUTe+Zgxman47mwg4jIGDcHdpdo3glYQ/47m08y3I3RiA5MrIEjxCO09MpHJviHyLHv67Q1e0/qScxfbU46f2uC3J0WJjA4y1zqrwJHvxEbu9tPJ3uUSkoikxe/wC9jJe4AjVI1FhBlPLRidi2Q+GktYl+WZRnNvoJP6C335G5Fhpw+SA1d79m/mPsslg0+7dyBIKvBHNljsf4CfZPiVRAqciUmMClyVr7n6pm8gwRhGOKR+f1J2il+Kbft0oxI02TGzK9bryP6bG37ldbtSQiyZla9SfHFwjtj6TldA3QZxyFNh8FrDGja9brn+2Y0QRHCCubGCxVmpLCsjBioqGVOCwUuyNIiO+NorcGpbw7fBPmAALe5SqTpJYWh9ElI15z62bf7sicQY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(36756003)(86362001)(316002)(956004)(1076003)(8936002)(6916009)(508600001)(2616005)(26005)(83380400001)(66476007)(8676002)(66946007)(66556008)(4326008)(6512007)(6506007)(186003)(52116002)(6486002)(2906002)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jsKtS3yHWcIoI5bTy/4uDYo0AwZXAgAtJ3pr6hejuTjus2dEWM2LgkJUWyEg?=
 =?us-ascii?Q?kT81kc/Dvh89RygkFmzINJmHA1Mowv1M90O7LmFPTqOBkv+0iF62TeoASI3W?=
 =?us-ascii?Q?6S+vOlfByWs1Qxut8DBGyNcM1QwcMg4pCB/rQ4fGrCrpRDgUNr7IxVUJqkVK?=
 =?us-ascii?Q?uJmMVp7GIqAsHQhi63vqqDj64yVHxRgLsIbTOiC2yABfrM7bp7p8X9pyPrvS?=
 =?us-ascii?Q?/ZUiiChg/YE7Dlt7+l//NUP0HZUzSPOl5QU3EgH7K4DkwdqiQtW/2UgdIHFN?=
 =?us-ascii?Q?DJqtD8gs/ZrIhwL2qxhjwgn7ZIfzkBZTD5NB0kpswf0W2P3J7DMp813Gw0iy?=
 =?us-ascii?Q?nY/IDdGhVwTYI6a0RM21vVlHHY4TfoKRczK9b8R0nOs8oAt3XDSveyAz5DRw?=
 =?us-ascii?Q?yJZYSCaV433EwBEgRE11eSYtXzM8n0tH268grCst9vWs8ii/vdXEhJ6DrXlv?=
 =?us-ascii?Q?t6DaFvT6ojnM/dzdynhKSDqOao9W+x0TGvIDVxZ05lhQ+ECxfbg75ahvGlYd?=
 =?us-ascii?Q?Te/42ivbk/QURT6+fbwEF7vAQIS+L9sOmTttnbblfEjexbirP+XxXnLDmAKU?=
 =?us-ascii?Q?KJQQLKmaU3sbMrmT+qtm+8/5GvFtJICJDVQHmzrNmO92dGyQY2VRowLvBvP/?=
 =?us-ascii?Q?ahR/2xTvOvFg66HztHZ5AzJ8cYB1AsHmRcoHEIeC8FU/qRSocQzQ5oFkhrAD?=
 =?us-ascii?Q?AQhFkyIcBDrLXdvT8KD5oHGJWXuWO2lj25tGg82SdFJCYz77V4gTlOY4yqWx?=
 =?us-ascii?Q?cAvca/9f+bjPqotPTwByKugWMVsTwOxwuE4iHe13FRvv6eR0Ek4KlnDjuPDi?=
 =?us-ascii?Q?gzAMwNLFmIrL6ORjD8WJAfMyXXQleX/7ckJ6cDIRn1Y93BvIHJgudwaD0n8u?=
 =?us-ascii?Q?eYXPd+ow+X0q41yabRMIJtXc6A1goKU4YVTeijNquLSsFJe6l63zWpnNco3a?=
 =?us-ascii?Q?6WstlVscKPDQsLLyoO12sju6sRA48nnBV5hp4g+p2Bk6rAc1bh6p8R0QmKNf?=
 =?us-ascii?Q?EdlVerbcM0kQkybj94W8SyuejU6f03/emUuuv42ntFB+zVrCj5QMit4agAz0?=
 =?us-ascii?Q?1nz0xVuLSy0NwIU81r3GPXkXbA6YXhPffhLyYhqtIFC937kysirIR6vi/RD5?=
 =?us-ascii?Q?axcpt2Rl3RATzeYYG/dKAmOg9ufq3JVXAdKyNbb02jiS4FxHe9EaTnTBcvFI?=
 =?us-ascii?Q?Ha4H432oaCKVZ7sLNdX85HgxHyDQZeakwqP7jNYt3PonqKmHXHkORYFRFhae?=
 =?us-ascii?Q?rHVEVotumNIkM94c2msKmf0vnU0rWIZ0nQljDvNEi45wj63rFVuIM3H+2rRg?=
 =?us-ascii?Q?CViLRMQovgQcKN2acDPf6Xfg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 480b9b0c-9b11-43f3-9edb-08d97f650145
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 14:10:04.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BX+aYml9GEUDuYyfsGykCB9JjveRCYiFco1eQv+xNA646iNQ/gMTOkksowjKcLu0EAdHreS7fAOkj2F0K2Po4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2541
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10116 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109240088
X-Proofpoint-ORIG-GUID: 0-h4jTgN4XkZ720D5gwZBFFnaCzm4P3Q
X-Proofpoint-GUID: 0-h4jTgN4XkZ720D5gwZBFFnaCzm4P3Q
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patchset provides userspace equivalents for spinlocks, atomics,
completion and semaphores that the shared libxfs code depends on in
the kernel.

I have executed fstests on a 4k block sized filesystem which has
reflink and rmap enabled.

Changelog:
V1 -> V2:
1. Provide m4 macros to detect availability of liburcu on the system
   where xfsprogs is being built.
2. Initialize inode log item's spin lock.
3. Swap order of arguments provided to atomic[64]_[add|sub]().

Dave Chinner (5):
  xfsprogs: introduce liburcu support
  libxfs: add spinlock_t wrapper
  atomic: convert to uatomic
  libxfs: add kernel-compatible completion API
  libxfs: add wrappers for kernel semaphores

 configure.ac               |  3 ++
 copy/Makefile              |  3 +-
 copy/xfs_copy.c            |  3 ++
 db/Makefile                |  3 +-
 debian/control             |  2 +-
 growfs/Makefile            |  3 +-
 include/Makefile           |  3 ++
 include/atomic.h           | 65 +++++++++++++++++++++++++++++++-------
 include/builddefs.in       |  4 ++-
 include/completion.h       | 61 +++++++++++++++++++++++++++++++++++
 include/libxfs.h           |  3 ++
 include/platform_defs.h.in |  1 +
 include/sema.h             | 35 ++++++++++++++++++++
 include/spinlock.h         | 25 +++++++++++++++
 include/xfs_inode.h        |  1 +
 include/xfs_mount.h        |  2 ++
 include/xfs_trans.h        |  1 +
 libfrog/workqueue.c        |  3 ++
 libxfs/init.c              |  7 +++-
 libxfs/libxfs_priv.h       |  9 +++---
 libxfs/logitem.c           |  4 ++-
 libxfs/rdwr.c              |  2 ++
 logprint/Makefile          |  3 +-
 m4/Makefile                |  1 +
 m4/package_urcu.m4         | 24 ++++++++++++++
 mdrestore/Makefile         |  3 +-
 mkfs/Makefile              |  2 +-
 repair/Makefile            |  2 +-
 repair/prefetch.c          |  9 ++++--
 repair/progress.c          |  4 ++-
 scrub/Makefile             |  3 +-
 scrub/progress.c           |  2 ++
 32 files changed, 265 insertions(+), 31 deletions(-)
 create mode 100644 include/completion.h
 create mode 100644 include/sema.h
 create mode 100644 include/spinlock.h
 create mode 100644 m4/package_urcu.m4

-- 
2.30.2

