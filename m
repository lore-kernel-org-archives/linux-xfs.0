Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14D7C4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 06:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiKDGMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 02:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiKDGLp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 02:11:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE3B2A731
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 23:10:56 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A44Nw1l023147;
        Fri, 4 Nov 2022 06:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=d0awOaDZwF1TTs7gFEdjUY1n0IcvC6CB13X81p1XdK0=;
 b=Z8hA79XimIWBWx80CU/gKXTzCRiD9kstOYYHmU9hsxzyaXDF5W1aVtsuk043pbedi5DB
 yK7u/a8QwQeZJpWs6nmm/cPI7lJU2OqfcWh699HYoMpCfAXBgV4HGxsUjEJ/lyMxJQ16
 YZiMzECYuvUEKz9/DTcmZ/ouffhxe6wAyuV4lyJI3YsXAARSR8vgPAneScG/L6Nzszp7
 0WA3CCoGVLHZmo9D1IOzESbAm14VNt/0CWl2icgt7oO77VzQZfkYfhwESzhTYimCFP+W
 HS5NGftc2HTj1sdN7l2JYChaLZ/mwQebotB3xHxF3yg4LaHyJqb7c7SASx3qWZIu962J iQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2apr46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 06:10:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A44r9Oi032953;
        Fri, 4 Nov 2022 06:10:53 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmq85px99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 06:10:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NaCOpMW6WxYr10JaTmPMwkIEjEtPJjPlvgvZwW1Rxbrw3NQv2DV4xXpkhwxN924eiHtLkkGVBr2Zl5N7cMR664zxXk2E6JwJN823Dm1Djd1A8hUAS12+y10xKcqdizq/tFH9WB5ykH7zIg8bsyuvN6XId4Pu6nsNlzBzcoJBk/M/a7xvNYYuVKXcv3yq1txbq34T6wTaMOfObj3KHJT30PhNlMt35IuuvZtlqU2k8pFv7/P7/HtPh2TO0mB0/rqzD0o1PNzJcmIVf0CWzUfnRR+7YDhugfKwuOPhVUOl2gcQH21JpQz9gIkola9VKZeDSDJG16MbjcrlTefhFnGo2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0awOaDZwF1TTs7gFEdjUY1n0IcvC6CB13X81p1XdK0=;
 b=Oz7NJv4DwMooRGblGIt9iLVAGS0xQZrLngNUquqPLpZBUD5cSlbAzMvhjJdxkeAOzmSX/wh/VdsQqDERhr2nqfy2cfIaS8FYMhLalQ8S3bZNy5tfHry3IVLaY8Du9rPUyDCpmprmN60ArtyGEf3YNL2f2FXavZcCCTFDU3bO3mVRb/ciNNGjeVnFyhNkJT8KflCOfw5z04hyrS3cHchoPWf0O4UdumM3xUAtMA3MF7pkyEsFkpUY1jx1qHvuUySehiT9rO9Gq8sm2VFJ4CpeGtr0/lQShrqyslTaB+0Mun5ycjNt+jCwMBf1MuC5SKEtojLnEhiPeXk8MxokG4ABNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0awOaDZwF1TTs7gFEdjUY1n0IcvC6CB13X81p1XdK0=;
 b=x6NdV2eEX+Y43+VLLk9aRPu2vpkOVU1+fbSf5sok5neTm78nBblar5an3yyLvsgaq2g2zTgHh+9oPVBF10Q9gcqh66BXKulniWYSQBZRboH6msJnrZkqHGgPR4Yg6bUVfEBd5RttkW0WzxCQo/11a60B28AhT8Pu9qmfFtTFi6A=
Received: from MWHPR10MB1486.namprd10.prod.outlook.com (2603:10b6:300:24::13)
 by SJ0PR10MB5599.namprd10.prod.outlook.com (2603:10b6:a03:3dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 06:10:51 +0000
Received: from MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::bdf1:ff5d:d429:1549]) by MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::bdf1:ff5d:d429:1549%12]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 06:10:51 +0000
From:   Srikanth C S <srikanth.c.s@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     srikanth.c.s@oracle.com, darrick.wong@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com,
        david@fromorbit.com
Subject: [PATCH v3] fsck.xfs: mount/umount xfs fs to replay log before running xfs_repair
Date:   Fri,  4 Nov 2022 11:40:11 +0530
Message-Id: <20221104061011.4063-1-srikanth.c.s@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR01CA0112.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::30) To MWHPR10MB1486.namprd10.prod.outlook.com
 (2603:10b6:300:24::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR10MB1486:EE_|SJ0PR10MB5599:EE_
X-MS-Office365-Filtering-Correlation-Id: 08a365b5-991f-4ebb-88d1-08dabe2b52ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LqBco31kdc1W9aeKx0ouR450DxfOZWfLJUjcGB8n8sMs/ZhGvAXqA/rtL8ocsyWb4uYa1Dl0gOM2sCb95sGaXGwwMiB3P1sAI97GZQSnc2pnopF79RMFFnuylWpDvCzrahyz7MInwOu8UU0/oj6BN2GHlE6UJ0rxmEp3+QsLPanonzgaW+53Pd0HDidL0SnAlxVK2ymxa2cwZZZx2fds5x82xWG3jT0XxClnUkYrC7ahpzH3nGdu8en8Bo/cGPD+tIetlXyon6+XBh6/rjEDZ1Q9NJlU0xq/cwffXT4ZFQXGxyuP7dPEs5KL+9skCWVC4cuaWjfGvqRkoOyoOF+863/yxO1ERPhbA46mTNeblGEm2KU/k5obci/JreZAR25ZtNbhkkE6O+r4v6+8ZTy3ASAeAx6tLPk47a8/H4ks03JaJGta+OSv+C4+EjbsG6tydekPaX+m3+G7Elzv5/KAgkK/gcvsLKDbV3AZhlvZdYUT17pVGrn+VUQ8z/ge8sO46M7vHln1wIV+yKlBPzM28YVdJIcE2sh/W8lAb3ZfmEJP4bpnNCj432J5AMxdjWmjNpV2rFhOadzNGYCZZybkl37t7xsDSYnsJh3jpgbB+PvJgtZbsukR2bqdN1hXNeNaOa9IhPJKBBCP+pGSvg6tZPOelvC8hzGQDXwAPIIv/MDprQpQ2ylqZwhg9ja0KQtQrQXC0aw5nm1tfJp5UxxOKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1486.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(86362001)(103116003)(36756003)(41300700001)(66476007)(66556008)(4326008)(8676002)(6512007)(66946007)(6506007)(186003)(1076003)(8936002)(5660300002)(478600001)(6486002)(26005)(2616005)(6916009)(6666004)(316002)(38100700002)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gvnQ02nlPEQvfbK1Th61jMUkBv9W/qn9uKihrVQjN/vx9kY75zLWhnyQf4CY?=
 =?us-ascii?Q?j9Cb27CmOrYrlTPBjvLsYuMYZX8QXDiY8IkqVzLbL09AFTK9YzZkmBvD32AN?=
 =?us-ascii?Q?dJE85vwykgtquqMEbMh0f0m5EwE2lLwcn/dKxDlA3e120tfDWxaRI4faNcvK?=
 =?us-ascii?Q?RmCwlevhBX68300bt/gK344+Z0jKJTQAkUmcm8UJDXeHCN3ZVf4tToJtwhJs?=
 =?us-ascii?Q?2swDukFRblhekeV5RHSza7YeiPcZkQoHRARQ9KrmKNr5kq4Hracb8/tVixyu?=
 =?us-ascii?Q?+5R2hf6rtww4AXCkkRTNKOo5v83Hcb+TrQzq5R4gyS3jcsu3mC1HpxR1OgND?=
 =?us-ascii?Q?3Boz1MP93OCruN0mWwlqrcks/vEh61+6xttGJGe2KNMxMR18w6OjAyClG4uv?=
 =?us-ascii?Q?1+wmnC+2gBPl1pRwadwz39CVSop54DeMDgA8rZEtWMSGQMtdgVnW8wRUGFPS?=
 =?us-ascii?Q?GKCkCqHmMVyQrZiuhCX5PWI+poqBN5mTYkEnfLvKwOJ+MigkQ7gQ+UOd6/bg?=
 =?us-ascii?Q?zrbTNA/X6D9vwRuxDzUce4GYThxsOF2E4ANMF95/cM+l/t+y1JkfQ1O75z81?=
 =?us-ascii?Q?LhqM1jCpe7VHw9rDyLev9FJmodib1C8Wro+hElWoTo9fxeBABexFAUHRDyT5?=
 =?us-ascii?Q?fPPMIZFam0h0/EU+nLRzBy1bi14gN5rMA/PDOfxXSuttGiyGU8ErZsc7fQZ1?=
 =?us-ascii?Q?zj1v8d68BBqtffWNxI+z2J43EhvC5ucILUZ7H5sCPxTHhIXR0kx+Vap4olDU?=
 =?us-ascii?Q?FPUCG1LgdgzPpvV7djGxX4BlwHmkhsMnuNuKZJPIUj/NIMfNrka47rlwH/0P?=
 =?us-ascii?Q?mJHWDoVc/eENpN7cHnWKcFbEfjPnlZNgzW2jNIVzgxLebPyCFbiesux5nNiE?=
 =?us-ascii?Q?qXl6rntmmN0W4Mjf5AFYFFA0E4MOypAz9TiHMKru3H5WsGdHyUQ8wypllrcD?=
 =?us-ascii?Q?SbC9WVj9XbxO0DZVqeymZfNLkexGLxKkugQzYTLi/1E2Fst6shEqOst39lxH?=
 =?us-ascii?Q?0ayulfSc9d7nn/aJCDCPVZ4eZsVaZdyauu39RT6EeVX3GPEiRfhlkHd5xu8a?=
 =?us-ascii?Q?3qy6xg6GPJ3WiD9q/TGmtaosUce93sJvRKPiZsdyEERmsGDq1+l1td/o6Feg?=
 =?us-ascii?Q?qR8oacooC555cLrSsrXs0tvVXo/ATu75SlIcbShKO5YU3LvU+y0ahIq5Ryoi?=
 =?us-ascii?Q?2kKA+RGKIV6/Y/Bu3VY21ks3yZEPxvh6TDdntbQWOlYiLSc58sDwEYxEWBMr?=
 =?us-ascii?Q?V6ROPLvhh9p09tjAbNOm+uOq071Hc7jzCG2dLxqSge3PYtHoYqlAWys3tcma?=
 =?us-ascii?Q?BSo4EEqYSMpON1XoeDNpzNOJCBw2qks8Ujm82/z8nvwXxeu1IEgcSUz46DvP?=
 =?us-ascii?Q?sapvyqz0c7z55U4d0QulO0iRz5vniJPa+u/RSkrTf6Y/e1SW5auWLC8LFchn?=
 =?us-ascii?Q?b+4FOKhhTz6BAeYxBEGIHR2dSybNxLcCohiKIAvCDO7yCZLo3kjtPEI7e5wV?=
 =?us-ascii?Q?Fsfn7pB3xpFSdG1SHGixH/+TM/FiVBvZs6k4+ZHHjAD3o5C1ncbAHw+2UaNg?=
 =?us-ascii?Q?Km/5gv9ByXVI+JrCRFEv1switUm2aWyj5d6EtBtI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a365b5-991f-4ebb-88d1-08dabe2b52ea
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1486.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 06:10:51.3600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+hYZPRLa5/GeHHu0ZZujl08RXq5shevxpOxbK3mkHEj6loLpTwOe8tlBL7SBN7GhJrlTcoUtzBzLNudUhfdew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5599
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040042
X-Proofpoint-ORIG-GUID: A-t4d_38ecHnHGmk4Y9LrTE_Bp6F_xEh
X-Proofpoint-GUID: A-t4d_38ecHnHGmk4Y9LrTE_Bp6F_xEh
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
state with the journal log not yet replayed. This can drop the machine
into the rescue shell because xfs_fsck.sh does not know how to clean the
log. Since the administrator told us to force repairs, address the
deficiency by cleaning the log and rerunning xfs_repair.

Run xfs_repair -e when fsck.mode=force and repair=auto or yes.
Replay the logs only if fsck.mode=force and fsck.repair=yes. For
other option -fa and -f drop to the rescue shell if repair detects
any corruptions.

Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
---
 fsck/xfs_fsck.sh | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
index 6af0f22..62a1e0b 100755
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
@@ -64,7 +66,32 @@ fi
 
 if $FORCE; then
        xfs_repair -e $DEV
-       repair2fsck_code $?
+       error=$?
+       if [ $error -eq 2 ] && [ $REPAIR = true ]; then
+               echo "Replaying log for $DEV"
+               mkdir -p /tmp/repair_mnt || exit 1
+               for x in $(cat /proc/cmdline); do
+                       case $x in
+                               root=*)
+                                       ROOT="${x#root=}"
+                               ;;
+                               rootflags=*)
+                                       ROOTFLAGS="-o ${x#rootflags=}"
+                               ;;
+                       esac
+               done
+               test -b "$ROOT" || ROOT=$(blkid -t "$ROOT" -o device)
+               if [ $(basename $DEV) = $(basename $ROOT) ]; then
+                       mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1
+               else
+                       mount $DEV /tmp/repair_mnt || exit 1
+               fi
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
