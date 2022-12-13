Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0163AC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiLMRSf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236190AbiLMRS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:18:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4B920F5A
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:18:23 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGEKsA023540;
        Tue, 13 Dec 2022 17:18:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=0tz748FJn+b4pM0iaL0hASZxGB97RqOOkRKgilKJmoM=;
 b=FUOvYGiDU54SJkxJJD2g5VPWOSnQOZL/OnA/GHoESYfxDGDGrkWJejWlTFdDYxDlAkCT
 G2tQxU6h57X8++laV/7ybhMZK9ae/3x5xlw5T+5YCJdEPNMqGu4YsHFpnDNmF+CTtDI6
 IyfGJqcHhkxz4JnK0L9eMGO+4QS6JZAIqSKVGqM1xzkLZ2By9BfqiNp7VxG6baHdWmKk
 PpQiYfAeJvgussozDkfROgz5pOA6asI2kwb62p4lWMyGLmvyEyVCu/8RkOPF9496dgjG
 JbBU9FA3sF4Gqx5teYSRjySEat//o/5PcK+0n8GwYFTe2y+PlNAuTUy7el+4hsmDmNO9 fA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcj095x0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 17:18:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDGNTiu012099;
        Tue, 13 Dec 2022 17:18:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj63xh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 17:18:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ct6LtBSPG9/LmfWdhnYbtAzW5/iT3mZdLWRGQBEjL+nTgISiYPnVpz+2VZ870iVNVeCbmkB3M+UO+O2FXgzNKnDD2TMABmZriGRgVs0UhZGA2wmn1dExn8cAHkfpb3l7CMrOFsCB79AsWnk3s1PXmsxY8GzatmC2YoqveDIiAHc8nrO8UaZmmk/WLNKRVNynnwuVfPI8sn81/jb1ODE57iv/8SxDhTHQDkkK/CLVzyzAgPdqyjbpenJ9DC48/DMhLMfLxXESuOIvtumdqEN4KWWseRRoaPxb7FhiC5znDW91z+GdN6629cYOZgtWTZ5EMR79/pWqbGfqXOWK/dx/1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0tz748FJn+b4pM0iaL0hASZxGB97RqOOkRKgilKJmoM=;
 b=TXEqe2kX/g3cFc0q+vBp1n2oZs1fE1JxxQDLIzk2z8RyXZT4q4aIgfyk8VlG3XZyFUNj49qpXyUQAwI/CqV53Ie0BRTtNYjA7rDYlYTzwhrkEBHaSjkyXCRGjm8wl1IDhJL7vHrxGktEnRoEol5FY9qfE/+6bJhJY4zxvOAfoLp/lNIw6O6nIJ+vwinKtQtFRMeYGwNeT6A6eVG5pSeVZZ+itLSCqId0Swk4GmRqIqcsySpor6eOgHyDbHgHJz738W8TevmXeHZWxgvJwj57yEMAoBuiPfX1Ni06AfJruwpzb8E79nwlpHGTPK8QlUKfeHvFjUgD+4ciKLIbeJwC2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tz748FJn+b4pM0iaL0hASZxGB97RqOOkRKgilKJmoM=;
 b=ziV/0oWR3JuAN4Tfr4ZJf7VPyeU88KPIclKyEI6mjQ5IxexotYGSVVFr64+6CbdT/+Rz12ZqKpz07mmcrmkgHZhSuyh1uasba07uro8M14Jgfsi1QbZaUN/secCvM//m+iGgMzfPyJsGzRgzkZfJse8GkiYo+t+XOjZbYQqBPlE=
Received: from MWHPR10MB1486.namprd10.prod.outlook.com (2603:10b6:300:24::13)
 by DS7PR10MB4926.namprd10.prod.outlook.com (2603:10b6:5:3ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 17:18:15 +0000
Received: from MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::fe5c:7287:5e2d:4194]) by MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::fe5c:7287:5e2d:4194%10]) with mapi id 15.20.5880.019; Tue, 13 Dec
 2022 17:18:15 +0000
From:   Srikanth C S <srikanth.c.s@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     srikanth.c.s@oracle.com, darrick.wong@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com,
        david@fromorbit.com, cem@kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [RESEND PATCH v3] fsck.xfs: mount/umount xfs fs to replay log before running xfs_repair
Date:   Tue, 13 Dec 2022 22:45:43 +0530
Message-Id: <20221213171542.369-1-srikanth.c.s@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0103.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::17) To MWHPR10MB1486.namprd10.prod.outlook.com
 (2603:10b6:300:24::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR10MB1486:EE_|DS7PR10MB4926:EE_
X-MS-Office365-Filtering-Correlation-Id: 68c1e203-26b5-472b-bd40-08dadd2e0560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hrkUO1W1p0dkHBybfT+S9DkO4NFjPb4nctUTvSrAGQyhxFkxrl7i/tvZfhEH4ecqn1WLbVNNYcHBqMT46nPZnOUGg/P1ZcucHt3+dZzAuVhN8x1lMDAc/3edtE7hBBvE60eLxQ+IleG01I9LBpvfjjsNG7NTptPOyia6PNy//4VJ3Fagu+Em5RpZgHx8wuCz1MeFDG7JMAT5j7khNO4owimKD7nk0p14fFBxHNtbRUcct9StmLoqL7sfT00xYtk5PDvAcHqU4AzUVsE1kNAxIhqRjJ0Vt9I68KLaI7TXmyu7izulwfoI816x5waQ7nmB4kFVHlvwKUy+aymQvX2E1v/zvCFcvjq26WVg9Ml2uQgz9iRwtKWJ5KjnyePc5Kll80+xhzgnjwytK5ajaA1sqgXALWMcnCJi3Uxa5W8wJkQH20myH4ScQKD5nO3xL8fYAfsNBbHUH58FtpGRkpG5WaBZK/FhZJdtu2YG9LIVIwP0XBQUUNu5r9haj5HPdpEJf3QpFjXcpU9MVSWbejYzKmM/wxAeh4GVoFSO9mhUaOoLM/sTmfaiL54imOeNF02g3szlkx3JHiXJZSbz+VVx/mIc6KCfpujNBo4+rDzVY1G5pO3Gl7aIO0MzLB5B25XfyHVxS4SwbZRj9ZSzTjNwJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1486.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199015)(6486002)(478600001)(186003)(1076003)(6666004)(6506007)(2616005)(38100700002)(26005)(83380400001)(103116003)(41300700001)(36756003)(6916009)(4326008)(66556008)(316002)(8676002)(86362001)(66946007)(66476007)(8936002)(6512007)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fZTmbmcxTiAsNIT0NNOadJiNAWSIR1tIE9gPJAXdnT4Bogjrc3DdSQhhQwAB?=
 =?us-ascii?Q?6lzDXu2qidPq3/7dI2GZvFtDcteSLpjsBvmA+0ZXcSR+BlFKGmNhFvjhED5Z?=
 =?us-ascii?Q?xxJswuMmDMrJZVjUps1JBuNIlTjMTDzU/c1csexOlNKCofE2AslEj++ADbff?=
 =?us-ascii?Q?42CKl/wouUsQVQgAgWvsBcFikIkX6Dka0CoqeYzqNzynjwoDFc/fiIkgjAuN?=
 =?us-ascii?Q?ZYuFPUawmyLldDlS9WrGb/y7VmdkxYIUuOD0eAUcMC51hKsj0wiz5DtrkkBB?=
 =?us-ascii?Q?x6So+/R9qcakVVK+N4hL4HySiya+oDA7Fj4xRUOIFpZFm6Fn8OomSgd1mjht?=
 =?us-ascii?Q?dFhQhzYEzVCafOQ9uvnT9qFeji0JoHEomwSTr4cvLXP1FcRjEZO3vMg19ta8?=
 =?us-ascii?Q?HvivyS9jl2R6kQmpM7C5a+B7wTJaj8dtg34L1moxgCyK+bebhQM3DWRdgDWP?=
 =?us-ascii?Q?h22CJ9svnZhicJbP3hRqer6izc9e14os7CoEEUm2D7nvbZXswpyZnKJ2MhjC?=
 =?us-ascii?Q?pLqe2r85IHjhIPtf8a5br64nsAOKlI4SsdFPAvhaVXIOPog9pNFvcuWC1m6j?=
 =?us-ascii?Q?EaUJTY0XVMgyDn4cxmUwqBD3FCZ5ww4lEqLGffa+M45Su1Y4DiYK1EVkVDiE?=
 =?us-ascii?Q?zkxXPn3eKO7KcX/G0L8fCEPo8wctW8+Mthxqk01TfUvb6Pc06chf94+V+J3g?=
 =?us-ascii?Q?c7gxmTJ0C1tn5YEHyFS4gX2gFn62KJX/BmvXLs+89kgpju5YvJWGNKmMNFjx?=
 =?us-ascii?Q?HUviMHzRJ8u5YRlqIiksO0bOziTXJm8C/xHdGKkdr2AYyMoZZOT7DQGWAArp?=
 =?us-ascii?Q?D8gX6aFagMBSzaDBlu6ZEfWUjQdxOA0xJAekPVadvOsIOz6nbzE0IYVbvjI5?=
 =?us-ascii?Q?2RCbTjuw5iaDDYfDBK9Jbgzo2Ts2De6LATz/BzBwj3YBOHmBG7c2F4QolTYe?=
 =?us-ascii?Q?9VEzwo1iGd3dZNWSizvEo2Qv8/qsUAJBeuc9Xvwuz0z5CoEeir/SGB6flfxK?=
 =?us-ascii?Q?Nh7b4T1IVZ8pUzJ56q/dU/JklLyWQEXj/I9l9jgQPVeu4wahj1h/3nW6t36O?=
 =?us-ascii?Q?3Q3NS4PejoR9h4bHQGQzZeZss3WgPMPEIDFWh0q4csUVqB7I4Yf1YoZdf1D8?=
 =?us-ascii?Q?3HEJH/M+1uWoaxJTVxa6aOU8zbtDmjgiCOKDBYy1YTXsZrbonjiTK/nB/MyA?=
 =?us-ascii?Q?J/KJDB+Rm8XrG+jnjXB/t5Ou/AjzGW7HqjbN8fgh5LZYxZIM7OEbQor6RjSJ?=
 =?us-ascii?Q?FBO850+6PvfySUHFMs/gX/QulFU6DTWwpIL/iaFncNHNqqfcfsbP6NtLLWUe?=
 =?us-ascii?Q?7pw6IUCTeVzrfmAQcsW0It4EsaF6Qj8FAdp7X3uKhzCiii/p7SUk+Ep9E10B?=
 =?us-ascii?Q?AuB9kbunMCROV0XewJU8pSPQqtb1I/k0Y1X+cfTIFpjCj7jQbtz5eC2geZX5?=
 =?us-ascii?Q?VWk2lyXCBTns9hnJK3Lh7HDY6rHvSV/Av7y/zw2+Q+/vpFvmZJUYR94HwPjo?=
 =?us-ascii?Q?4MetyvGYJ49dB/ZHyGjU7KBkbTuZE+q32IuIOQoK/oJ/LYWeoxxtBwKLfJOv?=
 =?us-ascii?Q?WSGljc2Z4p+tleKGtByqdpPQC1XMjBuh0X4Hmfj6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c1e203-26b5-472b-bd40-08dadd2e0560
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1486.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 17:18:15.6368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZvxJCLn3VDXsy/dg7Z3DJUDTaxLFP72CZ+kNl/37f06FO0BYkVIkFwmhevjafB5FQabUFmQWBlvg7+uvcJIIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4926
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130153
X-Proofpoint-ORIG-GUID: jHk6dqHs8HuLLtwsZ__qhYwVy0UNFrpX
X-Proofpoint-GUID: jHk6dqHs8HuLLtwsZ__qhYwVy0UNFrpX
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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
-	a|A|p|y)	AUTO=true;;
+	a|A|p)		AUTO=true;;
+	y)		REPAIR=true;;
 	f)      	FORCE=true;;
 	esac
 done
@@ -64,7 +66,32 @@ fi
 
 if $FORCE; then
 	xfs_repair -e $DEV
-	repair2fsck_code $?
+	error=$?
+	if [ $error -eq 2 ] && [ $REPAIR = true ]; then
+		echo "Replaying log for $DEV"
+		mkdir -p /tmp/repair_mnt || exit 1
+		for x in $(cat /proc/cmdline); do
+			case $x in
+				root=*)
+					ROOT="${x#root=}"
+				;;
+				rootflags=*)
+					ROOTFLAGS="-o ${x#rootflags=}"
+				;;
+			esac
+		done
+		test -b "$ROOT" || ROOT=$(blkid -t "$ROOT" -o device)
+		if [ $(basename $DEV) = $(basename $ROOT) ]; then
+			mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1
+		else
+			mount $DEV /tmp/repair_mnt || exit 1
+		fi
+		umount /tmp/repair_mnt
+		xfs_repair -e $DEV
+		error=$?
+		rm -d /tmp/repair_mnt
+	fi
+	repair2fsck_code $error
 	exit $?
 fi
 
-- 
1.8.3.1

