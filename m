Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A00DC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 06:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2752C60FED
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 06:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhHLGnE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 02:43:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34734 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231253AbhHLGnC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 02:43:02 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17C6b6bE029171;
        Thu, 12 Aug 2021 06:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=6W5wlEfher5+3EbaI9iQcZ3se4axIwAf0qiX2Wvrsto=;
 b=J5q5EXt+yxm65Bi745FIaNni80chC54FjFFRe7LgoxX6BtOg6TxZ2mrdpaY/xtT2FNYj
 uvRw7P0D7BmYsaTrknx2O32SgdbnD5nKR2D+zHHPMgz693lINJfNpOJg+RxRsljOu8No
 hPJvvxVRbT+uibmUnMTJktscSn4fP13839EHBGmAlRbJeRZaqDLgucTUsaDGT2HbCwuu
 pMGK6BiSoN07t8fjD8SuEh20QX1AoZQhKkcvYS2HFFNxbAf+rRArX3Xq8/t7W7XdKHqe
 jJvNV8Eqrxe4v3wrga1CQ9suSdN+S3OQiWT8tHrVhXfN3hZgiLGP65OlPHAhH0Ss41N8 jQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=6W5wlEfher5+3EbaI9iQcZ3se4axIwAf0qiX2Wvrsto=;
 b=eSeOj6m4YNKTp7L54G7uUT1NfslU28uOliGBgOCGIdEf+OG0/7hT4GiJek+CtaKyKsgo
 mp40sUThuAFIDsBcRi3NYFVtN9WTxZZWlltWtc78t935gqfdsw1PkXnqGV9rCa5Zx0Wm
 AJQ3lVoRmCFDG6vPRQF+trS9Qnk+ZmTDBx9UOA5our25d7qCJl05bzFKV6N4cdB5kmsr
 WVx9W9aQD0h/ISgH8pUOnMSte0wZpILvJQSKPdhPw6zd55SAQdCgS5xtPSRWOJTVBHXV
 zBDlJUB8jZBTlfsliQyMI3A1VZZ6md4T0wWNxb0x8LSpFF8c1A0m+fcTQQFHEhy6BfIM WQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acd64a793-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 06:42:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17C6ea81104691;
        Thu, 12 Aug 2021 06:42:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3030.oracle.com with ESMTP id 3abx3x9sh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 06:42:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LghbXmUeUK5Ly0qSzJN0y9XoRRTbf8FkTrf283V+534Ei4EzunulMneVsRwgGYCjUzhDCBBlqllRax4ulJBmOMBVtbdIYhhglqAyFEojXkTY7hZ2vWUVnBlS4UDG8SZlpu4fkw3Ty+HeIzNGbqPMd9m0GOViqkE8y4RVFD4y9BbRSDVKytQtxGpEfs6ctx3PTsrHowuidhqqfHCjn0CYlvqw7SGoQYeZH1xgUC9GH95yo9+IkmsMyAbOv4UjzIRpTgHWzl43Ckg9+44HxuW8mzqeAXmavh7hK9Tgd5aavDDP4zYH7MSczP95r5/H7ZOKgohR6HDW3ds+uBOS3+qDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6W5wlEfher5+3EbaI9iQcZ3se4axIwAf0qiX2Wvrsto=;
 b=hi6oZ2YUhKJ2CROJo+gura9G4apPXbu20rjud/m7H8l6qZLhsbVoMWksNVi49LF/GRENstiMovhpEib+s3vVTZOCw44nrEMo1MdoL+c+d21G/eLNu9CaUlo80dMyP+gUqA+BgnIuOkj6/Rbmkm/Ate+IE3zhfeCMK8Mf3GQk/oTN1TwEVNNw4qqaf7lsfqnV7rZVzxh5VhUR2UQcE9m3CIpw6ZZ9jtikjPDsjQMZidpJIN8TWlim3x5kwyOabbHdAXSR2rSR+Fs8Tf7AlEyT2EQk1K/Z8jhNXs07gB6fYPZGmRDtqrpQ+G5x1HP7Q9AgHyYxB4qt5aPHIaNrycdjQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6W5wlEfher5+3EbaI9iQcZ3se4axIwAf0qiX2Wvrsto=;
 b=SJDZr+RT01m2posXJEPceK4T9M3wnYdE3vGeicDYiT0vZYkXZq/kH9i8EFehXFPXLduEElHxXSsLLrOSAsZSzTji65kAxZPaLcdxiltETNhHWJgbIWFLYf7WJPpjCFp81GSrNc0xUzpgc3muSEc2GZpADyaTAn6dwt+Qy1+UmdI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4500.namprd10.prod.outlook.com
 (2603:10b6:303:98::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 12 Aug
 2021 06:42:34 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.016; Thu, 12 Aug 2021
 06:42:33 +0000
Date:   Thu, 12 Aug 2021 09:42:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [bug report] xfs: pass the goal of the incore inode walk to
 xfs_inode_walk()
Message-ID: <20210812064222.GA20009@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0077.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::10) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (62.8.83.99) by ZR0P278CA0077.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Thu, 12 Aug 2021 06:42:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa6f2cb9-4def-481c-ae3a-08d95d5c5d55
X-MS-TrafficTypeDiagnostic: CO1PR10MB4500:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB45000BC5135DB10E6C2A6E1A8EF99@CO1PR10MB4500.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uw501X1OoY+wrWx9s7Zb7rdbBxD+ltgLV818WVgBpxRE3zjwYlD1czm4tVnqPiXL/ZtOOncsoc+6R5dCrnBUvG3Ap4N0fAAr2w2We6LpMPTke2r4tZIde6e3ut7St2dA214n84u+IxaqYfuH1SGuewi0M3r1SdO/l6JP5P9a59MrCxxlaLkEpb4n5lA5zer3evRpIH1IpfqL2uvnyE04D88Fm8htVOi9/8WTkdZHowGkRGV+i+IzU/ldHCUNzQjmxEYFCjvCHOFiEXDUH8pLcVFvGRmvUPzlcIUwRpOju2PS+Ie/H63nN1UApjuz/Ei8TP1fs2yEFdzX7YSch8qxY9mdcVinewTMfFJ2EEHRAuXkOwYA+COWzPQgTaO3PkvDsnHxm6oXJPx51EisJxSNnNMTzABMlPDnBDCsUjcOimF+8ui3YPcriaJ5n6zN7DwMES1LKTYPpS94eycvzC5BkJ5CSc/dQzxTpep4Mrmr5aPII5t4gQ2bHotNpDvy834bUA0JJ/XIIJIRv+05mm++TBvqCU+Pd/YWU5nhK3axlEmVSa0StGizfxDhFfnV60WInlpIX/miPp5CybqJGU0u4GvbL7C9juseOWlG6YIo1RGUEKMS82zfdPOMNK4d1um/6DiSLsfR01lKE8uNNCnaXqBUfT/KR3P+4z3nmVugIaEGM1+Kc7sa1gxh+QKa7CZxbWRV1A/tGOo5eccRtlRYkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(376002)(396003)(366004)(6666004)(956004)(38100700002)(38350700002)(86362001)(9686003)(5660300002)(8936002)(478600001)(33716001)(2906002)(186003)(83380400001)(55016002)(33656002)(66946007)(4744005)(6916009)(52116002)(66556008)(9576002)(4326008)(8676002)(66476007)(6496006)(44832011)(316002)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n9b5JhXgrtLdPppLPcRdIAlukUfzDp6PAZwSpCkgnj0WfnteCMdVLH/HswfF?=
 =?us-ascii?Q?Nm59Duw2M20U53XjikuC19jnFG9u1WL8iCfSAIEhtbi7vdubcTkHrHTzPbuS?=
 =?us-ascii?Q?vxx9fGkvBXiQhMcmf5FZoid4Vkqpm4szW3+WaFM1w+wluLObiA24LP2+LGPc?=
 =?us-ascii?Q?2n7kA3cGVOX3r8u9QlFZX0GusHogINVWzkRU43z+KsJaD7mw/S/Nif+Sw8KR?=
 =?us-ascii?Q?yLe7IutMfcJYBGRjyF+uWUlrz9pcYti8BNPcdffLgz2fg82Kx1EpMyBeX691?=
 =?us-ascii?Q?ninRHKnAvCMBaF+A2TtXp9T9CiJGXDMN3dfQBLou6+7uMiFIDFzFqYTvEowc?=
 =?us-ascii?Q?D49O6chLjBPmKGFloT+UzXehMEfH/A9oJFe0scV9mo0AjCS7DS31x7utp6XE?=
 =?us-ascii?Q?2oHtWbws/TdPBx6g04pOERDKtIRlwe5rrqvlIqUwYwGAqrnaAuUAaCj/rXsn?=
 =?us-ascii?Q?psPhsKwmFGS5sTEK2d2iELetEvssoIfKboQ8JUenhtITH5NfLbCeFBckt1Mc?=
 =?us-ascii?Q?57adwHKTo3wCjcPWAll9QxoefuRyvWBRKqQHGIzJKOMbsq2P2LAAc+I5jeAO?=
 =?us-ascii?Q?RlXSYIqeX4C06uJjhV2P3KNu98xglX8zY/We4bD8QJOjLb9tE8ddglOogadi?=
 =?us-ascii?Q?R3cc+MFxViTQTO/7Qow+earsVJsTJrVKQQmmSR/Xl+VBvAlOioe5q6o4EOew?=
 =?us-ascii?Q?rP6hWxxgy2XEwHPT2sVCEgWokxg7SaZnskarK/kkQAUP0txPy4iXqwvnl6ny?=
 =?us-ascii?Q?b1AZbuGYimEHr+2i7xM1DxhPBTheOlgH2AjiM9fyMA67hHCDZJNKZVTcfCdc?=
 =?us-ascii?Q?9d65Y2etr0W2HMENvz/xkPW7nsMQmPMnSe7sZISyVrFMzR3zf1WiSxs2CWNX?=
 =?us-ascii?Q?b27x6BpCFU71dMjK3vhJgkOeB2mCM3/kE8nbwLxk4PZNIFXM3AkTr3EsG3lg?=
 =?us-ascii?Q?H06ChD+yZoXySwx621jkNoBrOhzkcWTiWr57S1Uk1fkH21COIsBQvpSDb8GZ?=
 =?us-ascii?Q?G7O0heB9PpcOqxnt+L5Sao6BVCUEo1nah2ZuZ3EBZV4euboVV4LF/wT53Qyy?=
 =?us-ascii?Q?mRFfzN9c7Y5lbDBPOCG/UsOdeafuIYctd3kaC7ucSKSQS1dcycTvtZ12ePd8?=
 =?us-ascii?Q?lbOwAQkaSrN2yiPnIMcEbkKJWEMzeIGLHcU5JGzThxT8KW5T8fXcV3bwB9MB?=
 =?us-ascii?Q?vf2TN0r46zHArtl3Pnm9u/pl9wVbV3ZboHyjDBa2lhlqhIZKCKE2ej8pvEJo?=
 =?us-ascii?Q?Qx+LHfc1fsitKnzdixG10sMLx7K0GE6jXej98uphw5SiA+W3u/h3cNoHLNTd?=
 =?us-ascii?Q?BIT1ZVd8CKpihiM9gpioTW6p?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa6f2cb9-4def-481c-ae3a-08d95d5c5d55
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 06:42:33.7104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8coS8DpBK0S+sI4UaQ71qbxjxMvDx9AaaXZW4Y7MPTQpQL32BK79A+K8X0cwDFUfpuL5HpktWyhhYGeHiugjYDJqT0sQWjjxV5xZY1fbt+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4500
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10073 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 mlxlogscore=713 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108120042
X-Proofpoint-GUID: 3QFi5J2uyXyFci_zBKIcwfD2Z154LuuD
X-Proofpoint-ORIG-GUID: 3QFi5J2uyXyFci_zBKIcwfD2Z154LuuD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Darrick J. Wong,

The patch c809d7e948a1: "xfs: pass the goal of the incore inode walk
to xfs_inode_walk()" from Jun 1, 2021, leads to the following
Smatch static checker warning:

	fs/xfs/xfs_icache.c:52 xfs_icwalk_tag()
	warn: unsigned 'goal' is never less than zero.

fs/xfs/xfs_icache.c
    49 static inline unsigned int
    50 xfs_icwalk_tag(enum xfs_icwalk_goal goal)
    51 {
--> 52 	return goal < 0 ? XFS_ICWALK_NULL_TAG : goal;

This enum will be unsigned in GCC, so "goal" can't be negative.  Plus
we only pass 0-1 for goal (as far as Smatch can tell).

    53 }

regards,
dan carpenter
