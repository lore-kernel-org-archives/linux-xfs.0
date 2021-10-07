Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43B1C4321E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 00:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83EFB61177
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 00:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbhJGA2r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 20:28:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49098 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239978AbhJGA2q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Oct 2021 20:28:46 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196N6eVJ028065;
        Thu, 7 Oct 2021 00:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=0ZnV9h9vtIiM/oEG7RzZmaO3VEX8w9AX9R2HCPA6nxw=;
 b=qBSzKcZa7ObkguO5sHuyANj07O3wiua+OGjBHnvffsUYwzNT38EDgmJqvqLbnDP10mtP
 +Kzz01ONU6VpBCOgFRL3lcUYUkMChgfIGtdsyO0Fzt4tD+zgStSzkvbUip+LDrSAQxSD
 OA6p3kk3t122jmMMmOZooBUEsCjqHAPTaFWGmzByzbJ+u5Lz5c5zzb2hMTdUII4UG050
 f9l9WTXIr0FvBsPemKGvu0IfrAx5PoBgPdTH5p5v/1+5QAisPE9A8Q/aLE3aTWS5n/u9
 yIyXIjoPtJBmUi59IhK1SFPZIbs0d9BbQUwIPgNaBtKknoYertf38/V1So/6fgFY88zW gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bh10gh2c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 00:26:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1970AkGF192858;
        Thu, 7 Oct 2021 00:26:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 3bf16vya41-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 00:26:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OeSBCrsPl8IXN+4lQsyxdk69j/ZoUK+bF60DlvW04r6X75cNAPn/v6JHvI3GGEfTlyhr7YNLA7ub6LK8yUCqZtK0XUCJrWrH9jhckUDm2AFou80ykPIZOS7v+872+ZifJZQ3ZB+aOKyAzW6Rq8mEiJtdw3uIRhzE0Lqw6v6/+EhJ+NaIrAN1pEg3Xqqzb2xiCJ28IXgY5LOc3tN5xaEayszp0Tr6E4tqKxtGKST1Q2tttySMsxxeDz+gbDQ8K3fxEPVRYcdPyc6bewSxCj9blqegOExxAxGKcOoy0PxfcueyYcvS6MW2shpJKK95mu3nMh2qjS5tX+9OYCF512d1aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZnV9h9vtIiM/oEG7RzZmaO3VEX8w9AX9R2HCPA6nxw=;
 b=SQl3HVcwzYvjFyrex2oO+KIDApLTE7NmZLUpXlLOnyzr83M7E68wk1g0qvE+hO1radoM85m/0pgQUwHRRSxKcroRIezg2dhbWL35I/qSb8+fpBn+hUaOnE7HsRuZaQWJGBjhraIPZKCDVJla8soDDbCEvxQRm0QFMo/9BRKJ7obqqE6t9nHvH33WCKvtUrQs8Uk2hFiP7Q72iWj1RxBNZBXfYNJF53AF+uIzuK36cckmesTHFGk5Cq98UyH5i5BJFB/RuG0M6vtNLoIlfXh1lcW8QvleDdcsFJogPeUcdFRQLcfJmlfXeF9EiBGS8II/8hqmqX0bLThrDl1IdK8sEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZnV9h9vtIiM/oEG7RzZmaO3VEX8w9AX9R2HCPA6nxw=;
 b=jH7kaiF+KdCB60Hv9iuiJHn8gYWCG77Omd5DQ0ZUbQTbXOHxVvEJQLW7k/g+fy3jIkPeGWhW3Ypv70xJm8VZo5u+yYOH4jQUzsuu0gDI1s3kF87i8g3xtmN19dUXNSGxGveKpSbRyYMV25yEKbVcqP5D1DwZ7X+LkbO4YFD6nAs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DS7PR10MB5118.namprd10.prod.outlook.com (2603:10b6:5:3b0::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18; Thu, 7 Oct 2021 00:26:50 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72%6]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 00:26:49 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH v2 4/4] common/log: Fix *_dump_log routines for ext4
Date:   Thu,  7 Oct 2021 00:26:41 +0000
Message-Id: <20211007002641.714906-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007002641.714906-1-catherine.hoang@oracle.com>
References: <20211007002641.714906-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:c0::32) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by MN2PR05CA0019.namprd05.prod.outlook.com (2603:10b6:208:c0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Thu, 7 Oct 2021 00:26:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 594ef57b-87a9-4751-0141-08d98929273a
X-MS-TrafficTypeDiagnostic: DS7PR10MB5118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB5118085E626BEBA8BFD1D9C989B19@DS7PR10MB5118.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5YPn8kdcJgiHJQSeYomYbgux+LKRCT/UwZKa2P++hN12tHjPVBInmCFhfcBVq9aV1hUelW2n9FEmnsxwRhaU0ezCloFOQubs+p6kJitoWyPgcOGJS5CLbZODfX7HxCjhbUsajlTXNa9MzDSZphUxV9/cTUPP2assSF3y+t/hbxdJd3euuKhcsb1oXdCMxxbbWukAHu/Y5W2LIYPAVrsBpL4q2rDW01Q8uMCSBBIbJtMxSR0qpRr8QuPFWP3n5iQ8FUnvl97iL1sTwwthAgkfo3EJnEfl3HcMy/zqJasw4c1xqpWSVCOHOk2vkKTFp0vV0H/qKyP5eZGHRZfSaBUfKFntPsVOlXn6+4edfMmMxZ7Rg1ArNMroCMMpXdboZPN6WpyVwNAchh5Fyf9p92QtWruiOWhxikIiQC/rFCnKnHErhK6wTXdXAWWRAdHqbCTCUn2CtUz061uCOmk9Fx+xVc3il6mqRctJM9iRS8t9K5JTEFiMWN8D+1/6fUWtCaKPWdCNjfVPeALJmKV1Ci8uca0A0EAH+f7eRq5qVMmt+t9QHj85DPgik2r/oFhWKvJG2ElPN8LpjfrWbKYQYCzPVjX4jg4JfYapeyrhiFdTZ6nkje8tJjglrs7Voqii6pB9uwqdg3YGU+33lG5ztsGGyooOtOsF1E0GpFEhhk3ObQCg1zxm0sNL7Ky5JsJCOA+8me12CWbAj3mbnzzSYLmqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(508600001)(6666004)(38350700002)(186003)(2906002)(38100700002)(36756003)(107886003)(5660300002)(44832011)(83380400001)(8676002)(450100002)(316002)(4744005)(26005)(6506007)(52116002)(66556008)(66946007)(956004)(1076003)(8936002)(4326008)(6486002)(2616005)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?goYJk62yHcsmsffnmrb/MPsdwzwYZPfOtI8fXiSopHfzCnwb7SW6CgoqnjJY?=
 =?us-ascii?Q?vglYfvogJcvqfKR2J2rcUUamGk03PryIZNiIYlT7vsB7B2p+XsuWFzXND2qk?=
 =?us-ascii?Q?pBL7GXIGXGPzYNnba+8La/aFFZM2+mprENeR6ONeUJXeLJZpTo5TSd0BQ/zI?=
 =?us-ascii?Q?x0ooOMgmywmXPiCdAL+vwfX695ZDWbVtSCmB2Y9utGdLx10XpBA4ZXuDR/yn?=
 =?us-ascii?Q?u8N1dvwx/+iQ/z1T6q7k1aeVdyEnHrkxiu3ae9i4eGVwHM7Y9CV+f1tZCSyU?=
 =?us-ascii?Q?8fgsjwFXRUmpWUHrHjU8j93jN5Mdbd5KSDrwobZkPA9TOl/9hPEZCkvR+ZBx?=
 =?us-ascii?Q?n4RFb+0mVWdOl4pGw8OqsnUvfl4YFJl6Sr7XiZw2q58goZS+S5U+vbguW+B7?=
 =?us-ascii?Q?Ajd/gAwOSQDOohLluw2/M2tQ+OS8FQwWoj/kJNZd8uy+IE6sl4bIGTfSfiHU?=
 =?us-ascii?Q?+ahJ6JGTkSzJUw8NC+6vou/fpbizk7aM+6Hwq5P+/aL3XxI7A/0FxgCL3ug8?=
 =?us-ascii?Q?/bm5VT7AYkVPAFwxtEM9w79MwibXO30x2PZSGio6T+o03umSdBm3s4GTyvSq?=
 =?us-ascii?Q?r3bS/CwrC4kPCNUE5uJ8S0uVpZjYRqxZPt0hqtbmNgDM8yeTyW2J1982P1Ga?=
 =?us-ascii?Q?8LCrz1B/K56wW0J+T5xoMIYdb9RnFy1INeowiIXztufeHdhwb7SIx7zZBRW/?=
 =?us-ascii?Q?1kykv12sfdMPEOZ5TNpfhlA8wu8KLH1eLjl6xAtoHhIwFE0DMozfZvemTBn1?=
 =?us-ascii?Q?hSXGhqKO0gKXoHi1sRKX6V0XGBZc7ViaMs8xU1xcmjjfM85i3/HJ9QXB4Ztz?=
 =?us-ascii?Q?YKjsHZ8Ofy68PxKFyUeAs5ibrRQFfQRPQfS1LfC5SYRhcdpqDLIPVcAyrD2S?=
 =?us-ascii?Q?SwO6hdMQ9NmNAzHuSewp/U8YGgZlOqWi03j+pPveGqQj2ZXBc4jtkCW6s41u?=
 =?us-ascii?Q?mB6tf8PkeKxnl8VhCToLUClXdrzWh3Vro6e9Sz312PoLQ8A3kTOKU2BWlopG?=
 =?us-ascii?Q?VpBrK76e8HaPrp4tZ6838Fu8v1sg2l8ILO6V4wsDuM4eacDkN57X92df21ON?=
 =?us-ascii?Q?GdmNnlnLVT2/5Lhm1XSICzBT4sMLbilo6Rgt7QKllSCmE88kRpwZuci1VYgg?=
 =?us-ascii?Q?fxHWs/QKvgBZRw/nmFFf6ClNkcHxAQH0KhVJSov+kKykXRwdoWKtoyNVQ0/f?=
 =?us-ascii?Q?136Fk+UQJEpI/xrzyZnH347eNGkvqFUP9/Fij9CWVay+4+/GECa/c1vypyEN?=
 =?us-ascii?Q?EMAt2iJjYX4BX2lTwPDtioCSn6Y6rw1gb24DzYcQS6fSScEcrYxMDAs0QU7R?=
 =?us-ascii?Q?g5/G7Md53+WexZs4pEUz7Qf9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 594ef57b-87a9-4751-0141-08d98929273a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 00:26:49.8850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ug7RvKzwsCLIgWZ/ek02MdVYvZwjTXmC47jeMuEDXeOn62G0DQGQwvtbHqOWBMAxteip0+2q1KfaXCEIgNBBqPbm4wFsCA+CtmTmFORfwSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5118
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10129 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070000
X-Proofpoint-GUID: Sqg3P506kVCsqOWxVh_h7uYpT4wBFY_S
X-Proofpoint-ORIG-GUID: Sqg3P506kVCsqOWxVh_h7uYpT4wBFY_S
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

dumpe2fs -h displays the superblock contents, not the journal contents.
Use the logdump utility to dump the contents of the journal.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/log | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/log b/common/log
index 0a9aaa7f..154f3959 100644
--- a/common/log
+++ b/common/log
@@ -229,7 +229,7 @@ _scratch_dump_log()
 		$DUMP_F2FS_PROG $SCRATCH_DEV
 		;;
 	ext4)
-		$DUMPE2FS_PROG -h $SCRATCH_DEV
+		$DEBUGFS_PROG -R "logdump -a" $SCRATCH_DEV
 		;;
 	*)
 		;;
@@ -246,7 +246,7 @@ _test_dump_log()
 		$DUMP_F2FS_PROG $TEST_DEV
 		;;
 	ext4)
-		$DUMPE2FS_PROG -h $TEST_DEV
+		$DEBUGFS_PROG -R "logdump -a" $TEST_DEV
 		;;
 	*)
 		;;
-- 
2.25.1

