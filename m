Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E427C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 14:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiKBOaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 10:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiKBOaC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 10:30:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22952A718
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 07:30:00 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2E6BHD004146
        for <linux-xfs@vger.kernel.org>; Wed, 2 Nov 2022 14:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=DE8ZwXwuSGR3l0lijMw8+5Cmh8OSwvjcCPooKtqo3RE=;
 b=1puYESRO5MGkaRoE7W5Zccm+u8T6B5KxZ25ekK3AIBRWYygdlN/CZqeTf+8X8feQohFY
 zAA1qxkZoMXb5bSgiWW3fF7XsoyoVpXm3r+f/nEtF+XXOlIH8eA8LYHnjw0SRctRWoXY
 Zb3NsDnz6Q/GFTH8AARYGGhvtOWdBhN5BGIOkHhU23f/V8qcS/rp9bDZr9ovxRCgfD8N
 Xliq+rqV5cWKTa300ZnCYlslwpIDx4sHFqML6Qn26SpMv03/eJu1Aa/E0HJn3xspzeTm
 VQ+9jr/VAKX7m3Co+b0RSMDtDJdq/euDK814txVB9sCCP6LP4p24t7EZG/7lJJKLLGRB 7w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1a0yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 02 Nov 2022 14:30:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2DwqYE035511
        for <linux-xfs@vger.kernel.org>; Wed, 2 Nov 2022 14:29:58 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtmbnhkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 02 Nov 2022 14:29:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfcMgCe+vPC25/Lsg0gsyTbUdCxcxjjzvwVliDhWcEpXCoW9kMG3AHeGnk2h4+mUtGVenFQhwsdLazBKSpjCfpQwNr5S7oQMafeZM3f5S4OmxTKuE9WzMaLCehDciySdZfCo/zjQ7B2G034LIBBsNzi991t0N/b9BQpwGtzf6MdHTNxFdsI9Bu/zdyjX/siNTe1oS/YoV8GNA252XhnSqCkYzpW2I2lhcNN3ofkGDEV2XTbQ6i+fZTpEXmM5jVecnLuKVpI+dR/E2UDiZtl/76uIvR4dxFAz1LtkB+MmNMU0iVp8vbeFnp/mE+qNeHR5HJOJcPTH6UAU8coKYLBdhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DE8ZwXwuSGR3l0lijMw8+5Cmh8OSwvjcCPooKtqo3RE=;
 b=K5zAl0hBN+7F6dKBlhP6ccnviWBbUhLjSoonOaEClozfRHQAFLguAahzN8WjLvl99TEcHDSpDbFv2c/49VuUQ8ORIJu8EMqiyErLBEh+wJwC1FH+8hJArJBgokII4/xAiDKkX+JbRueXLAW1aSv+i1TD6u13l/TVwAaJpyWIx54yggr8c5c774yq1oMADe+4bQyJZerJVLocBxFX8fzs3dDJ1fHDriAVR21OGMNxd+Sk4lXAROnaTZwZucxt6FVWzSq0PmLfYnwlaRJ7tPlZHkPPZoQvZyVRNHkGsoAPEo4qfBtTpyWBlDDworWmwlx3sOCfBiOLBBrESHsJniNpoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DE8ZwXwuSGR3l0lijMw8+5Cmh8OSwvjcCPooKtqo3RE=;
 b=JPgXYb9uVDZiFEMX6ys0Qk6uvdpe0wqnV6vOapelGCbnWISt+bzknLwZ60qawGi97rc9H8uLBrD3suQTaurAjykz8kfxsVXrxB6+ds5dREkqE5mFRHXuKY8RMNWaasmUC33e4fGG0qF1nvHgu96wGaXIUB1PMkoALo+4zxllO3Y=
Received: from MWHPR10MB1486.namprd10.prod.outlook.com (2603:10b6:300:24::13)
 by SN7PR10MB6618.namprd10.prod.outlook.com (2603:10b6:806:2ad::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Wed, 2 Nov
 2022 14:29:56 +0000
Received: from MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::bdf1:ff5d:d429:1549]) by MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::bdf1:ff5d:d429:1549%12]) with mapi id 15.20.5791.022; Wed, 2 Nov 2022
 14:29:55 +0000
From:   Srikanth C S <srikanth.c.s@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     srikanth.c.s@oracle.com, darrick.wong@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com
Subject: [PATCH V2] fsck.xfs: mount/umount xfs fs to replay log before running xfs_repair
Date:   Wed,  2 Nov 2022 19:59:46 +0530
Message-Id: <20221102142946.3454-1-srikanth.c.s@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::6) To MWHPR10MB1486.namprd10.prod.outlook.com
 (2603:10b6:300:24::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR10MB1486:EE_|SN7PR10MB6618:EE_
X-MS-Office365-Filtering-Correlation-Id: 92d21da0-aecb-4582-e983-08dabcdeb673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gZAIJKTM877JA8kLtBm6z0bb8VqFTm10PyJJnqm/xUkbEDtY7rkG0VJoo6s9OVklytR8b/VnpO+Efow4v0Daq7hh1vgZLVZ6apT4To4Whw8IgXptfBMWNjbr3VVRpM4E5dtmKrIXqVzsbL/GFylGnSoUTcn6icg6+e8kmJcvbhvDMZXSsPZZY4kRSyl2jbPJnnBB2xVyhSsMUrwTm44V0VejS+ZTJotvUt7P+wMyJl8JxPY7PsyhjyaPXzjkSyvmtLAibTZlDUQpgKyIwP8RGy1aD5URD6zYpvc6GAqFcqxVMfcGpNqZTe1W8axld9zkWq4AuCj5ybQn/XpJkiPkO0JHWZSSnef+dLgzyhj0fiS7OCPb+ZUFd3zRllFSXAb5jjzKc9Ry3N3UnQLVel3TUTGf2TUmH9YIzByfjL+EwB/QcjO1O1YUBA7vQT23FD3SM7LT/m9JbjnGHH3M4noRJeQCJT8qiD9ZAfEofjSqunSFZHeSbI43d5SrfTL5qczuBHuU3zx83psNLcj4Y/tBT+Z91WfiQpFSU4c0W3A53aA2C43mMpWK++9ti0t+NhvShDUHygXlw+g/nMYWR6T8mKr/3XJCkuaS/OEU9FFjP7Tccp2ANnZUZ9LG/VBH2K5s89uLXIkN4P22iO+3S8gyQyIgo6VSYKePiSWxqmGPmQCBCVBMHuAqN3vlHlrs7ANH3s8u8qD3xywocOilYfv3zQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1486.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(2906002)(103116003)(8676002)(66476007)(66556008)(4326008)(66946007)(8936002)(6486002)(5660300002)(6916009)(316002)(41300700001)(36756003)(83380400001)(478600001)(6666004)(86362001)(1076003)(107886003)(2616005)(186003)(38100700002)(26005)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nT3IKW9oNdT3qKEeLc2VeW1vJZCEKznMOnuQgB3Gij6f6LbXcis7rAoJJLXq?=
 =?us-ascii?Q?oxf1l0F5Lod5ROXPobWSIcP+qUfHNoggB8i84NUdBQC0CqeAIbIfFSnea6Hb?=
 =?us-ascii?Q?Fz+0UDJnascEi9wuREanqwMJHjuZttvaG9LSajU4sHYz0k5+FUFQ6kuG2+Uw?=
 =?us-ascii?Q?hlTH8V7m7ZR53Y/8iO61x4SHSJDtQhYcJp2jQscIafiZQ6xYwrQ01dwUJv6K?=
 =?us-ascii?Q?621URINvlnq3FP2Zmvzf1Wc8FtCHcsIRvtrNJ43/rrL7+5y6ZLOPctx/FiR0?=
 =?us-ascii?Q?73JJ4eTwsFiY4NQPfeBKDJXVbzUixbzU/VIeDHs8RPPFAAosJF+7rowDf1SD?=
 =?us-ascii?Q?1u81K7pW9ZSoFyfCxqz0UaGhEyZ20MwyWmTR3MXGBktt0JJ1Z3pB75g2krIg?=
 =?us-ascii?Q?Ne+xpcQCkcOqQExdNTOuNe2xY1fu+fYg0MsLUXLG/ghPKg9ub+aHe9bHF+9g?=
 =?us-ascii?Q?uF3PobirjQZEhDEmWKFGElgkqqKV5kf+ZjyBsFeUuzQHEm9XSuky/pHryz8n?=
 =?us-ascii?Q?xyLEjUtc5TkBsLplokk7Vz5Mt0xp1XIfLGQ08kWqIomIjn+bhjIsp/2L/aGS?=
 =?us-ascii?Q?yaOSzSrKDqhQCDlkm8gBDIrUMekZQJafI8m6bd+5yirjTiGwdzWDmunH+zMM?=
 =?us-ascii?Q?Nt7ARR2g22YYXqKHtyUrg37ro989cuYV1IkiPQb8ycHfySBZw0I+opT22gdJ?=
 =?us-ascii?Q?XDXUp1DhNdu1K7ELnOhestdFfwZPaMh+VS+YeXkwsMBylZ1g95GkV1Qp3jib?=
 =?us-ascii?Q?robY4JYJWpDSpFSTfAFNlDvztwaapHzwkMphVSl7mbLbzrOE4LdoPm0+xwbe?=
 =?us-ascii?Q?kgU0ze67DuHJudglpnLm9oEgqRsRSeOGeJymgojiWrL1nAVaf3o9gvhRJExb?=
 =?us-ascii?Q?1tdEXUwJFoAJ3bQwi2/jOzXJcOOWBpmoLR39pZ4VvYhU6VNu1H5U5PFbiGRZ?=
 =?us-ascii?Q?N01dC12QxIwV17z3il/ckGj3L1SuTb2vJgpG9THT2+VJwVHQxFsjdS3fmlQL?=
 =?us-ascii?Q?kWuXOnQhtvQdqb80r4hp85NtAg1cw3QCdjqsOgSNs+u1QvOC2v9O6C34g7vu?=
 =?us-ascii?Q?lsJ3twJuj6WzUZrjIooP1bPnvlsXaYrd11nTWgmS/45ylvD6lLxzGE0DQFvj?=
 =?us-ascii?Q?ydABouUILCtpnbWs3EiGEpDvCllgJcYy+DgXV6tXNo600KVMd+g6Me3oVcQc?=
 =?us-ascii?Q?kB/SD3xqH7ZTUeWCP3DkyI4NFonbAQN9wcnTXD2pNosfgh0BMrgcjV6b8vwh?=
 =?us-ascii?Q?lKUvqQVsg6dK+MRakvpjlkYu7BvRC+1b+Trfvn2Q00fis8zpYABhe2ONuuYU?=
 =?us-ascii?Q?lsgzF3dapkLlzf8bw61jkLrV5BgMVJuPkyZf6vgWJcwA0+dJlCxKHodbwUNN?=
 =?us-ascii?Q?trzBFgpKOuF6ZoA4NWOrXOuCMzTNqFPLoRIfPw6sPGviURxOCxEzO/iZoCdg?=
 =?us-ascii?Q?cQlsezIdzzAh381IQUTe6ckSawiIwiCc89a7miV0+x3ssgH6ipRcn8hpAX1i?=
 =?us-ascii?Q?xVegY6+fFMYtyHBwVAsSoVkyxy04ax0Ql4z/FLntGJQGiU5TE+1L8S4MXLuL?=
 =?us-ascii?Q?aMP/ziYwKe3nBfPYhUwjc98SMhJKiSShkdQpELO7FWi0BUKpGRmC2ftx2STk?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d21da0-aecb-4582-e983-08dabcdeb673
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1486.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 14:29:55.7563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wl8a/A9fLvBPAIs+3DscLkrsSciqGLnjhA9o3qqSR71kmSTEnprZ4NZsJjZcOxUtKtCYnIXJ+HyJSxc/Y4JOrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_11,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=873 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211020092
X-Proofpoint-GUID: ml82g1_hq-0K3ozD6-Af3a_GBl-JVpkd
X-Proofpoint-ORIG-GUID: ml82g1_hq-0K3ozD6-Af3a_GBl-JVpkd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After a recent data center crash, we had to recover root filesystems
on several thousands of VMs via a boot time fsck. Since these
machines are remotely manageable, support can inject the kernel
command line with 'fsck.mode=force fsck.repair=yes' to kick off
xfs_repair if the machine won't come up or if they suspect there
might be deeper issues with latent errors in the fs metadata, which
is what they did to try to get everyone running ASAP while
anticipating any future problems. But, fsck.xfs does not address the
journal replay in case of a crash.

fsck.xfs does xfs_repair -e if fsck.mode=force is set. It is
possible that when the machine crashes, the fs is in inconsistent
state with the journal log not yet replayed. This can put the
machine into rescue shell. To address this problem, mount and
umount the fs before running xfs_repair.

Run xfs_repair -e when fsck.mode=force and repair=auto or yes.
Replay the logs only if fsck.mode=force and fsck.repair=yes. For
other option -fa and -f drop to the resuce shell if repair detects
any corruptions

Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
---
 fsck/xfs_fsck.sh | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
index 6af0f22..4ef61db 100755
--- a/fsck/xfs_fsck.sh
+++ b/fsck/xfs_fsck.sh
@@ -31,10 +31,12 @@ repair2fsck_code() {

 AUTO=false
 FORCE=false
+REPAIR=false
 while getopts ":aApyf" c
 do
        case $c in
-       a|A|p|y)        AUTO=true;;
+       a|A|p)          AUTO=true;;
+       y)              REPAIR=true;;
        f)              FORCE=true;;
        esac
 done
@@ -64,7 +66,24 @@ fi

 if $FORCE; then
        xfs_repair -e $DEV
-       repair2fsck_code $?
+       error=$?
+       if [ $error -eq 2 ] && [ -n "$REPAIR" ]; then
+               echo "Replaying log for $DEV"
+               mkdir -p /tmp/repair_mnt || exit 1
+               for x in $(cat /proc/cmdline); do
+                       case $x in
+                               rootflags=*)
+                                       ROOTFLAGS="-o ${x#rootflags=}"
+                               ;;
+                       esac
+               done
+               mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1
+               umount /tmp/repair_mnt
+               xfs_repair -e $DEV
+               error=$?
+               rm -d /tmp/repair_mnt
+       fi
+       repair2fsck_code $error
        exit $?
 fi

--
1.8.3.1
