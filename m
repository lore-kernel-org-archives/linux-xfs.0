Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0655C43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 12:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237490AbiFFMlf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 08:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237488AbiFFMle (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 08:41:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B61261B02;
        Mon,  6 Jun 2022 05:41:33 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2569PRZn003664;
        Mon, 6 Jun 2022 12:41:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=MrRdM3Jt2+Hg239E5qXcf66D32Om8e9aR8R2bqJfe/M=;
 b=Bhax4LgR/nyymipVm3beVg0NjqR7waltIrpjDf11dtglUeMzjGOnZTfPxv8pH9NzsiaW
 W4vZGIGeAP1ELIDLIQATbJHhWQ+TcBaV7LBX5/IB1x/urnasDf4J58w3S1cT3P+2Z8gO
 TyJmtI6JHR0upB9FsZglWYHlaLF0HD4DQZGeeL/aQoFjQ9qnA4tH2ePPWvJKMn3tD716
 8WTuqW4Uh8ePVuvt13P+IFeL4uvOBgnGA9IbUhhHG+YK7IFlulwpy8ygAzwdXnuFkCNJ
 4pdelyf0FXvVxzjgzd0mW5sV4+3kL8A1bLidS6g2o+CpQcypfEoFsPSI6Ki3Wr6X+R/0 Yg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghexe8c0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:41:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 256CeUCS017801;
        Mon, 6 Jun 2022 12:41:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu1fedj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:41:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HksVnQ1l4/+BkLPo2j9YWixpnpgOhw7t2UoIoTiji77TEymV4u6E7krLMBeayu6w0iEjK1glsWSM5F6gEdWiWhFtkqGe86mlewZX0AszeWb9d8FuWeNF1qeY64Fof8zsWepwevGpm64DOeQbmiSM7Cxuq8GCiZzb9Hg95UZub4vMB2g14RERbM6SO6x0CIuJ+UDn8gQ3UDXVQkqx3I/Le41XP7/PqYWOJWWgLwNdP10kWdf67LIYL49mTwpGTDKpjC3pyPYMTqAgyOurOWZx5KDvmHdpRG0Qg4FxiNiJ8+wnfw2stgtvyPPWOFBwXIc8yzSnW/ZPLzzm4zj4Bny3Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrRdM3Jt2+Hg239E5qXcf66D32Om8e9aR8R2bqJfe/M=;
 b=Xl7VbfSNSar42bDz6dbMJW4Kjbl6uubnvlHnR6TggVhepgwgR7nOfK/EQsuPLgRi3/AcKXiHgQqgKhAea0+wGKXjSC1/66fLGtMacu9cQmMveU5yN2/wN7omF5x4jBnF7C3C9igbMTIugZEV3n2xHpqYgh0VSKzerV3GjJhrgMdyo6SWQvZWY2ppCrZ9Ky2c92paukez2vW7b6JrmGOjazeCuDlZmeNPPIE+NZd8Q0OmLSTdYvdEU1c0ZEdDGdPrb9VqkGeowu0rOhGH244X29qRGrqPgwcJR4+PxDdbhYwBwOjD113Qlsxgqkjq+A8kepcuiPADMnmwfe4QNfnVVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrRdM3Jt2+Hg239E5qXcf66D32Om8e9aR8R2bqJfe/M=;
 b=OQcoqm+Pb4zVdNBlbltIfgb4fNpFl4swgriKRmK6LowolF0+6lRRIkwEUUrhu4VA7WF28Y6J/InIR1BophVj8TcTt8RDATo4AbX1OquHAZExpRrb5pEgccn1USTLLVA54N/FS9fy4dueSAQMQk6y73BUiZjQMkvI6nVZfJgkzgk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO1PR10MB4706.namprd10.prod.outlook.com (2603:10b6:303:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 12:41:26 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 12:41:26 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] common/xfs: Add helper to check if nrext64 option is supported
Date:   Mon,  6 Jun 2022 18:10:59 +0530
Message-Id: <20220606124101.263872-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220606124101.263872-1-chandan.babu@oracle.com>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::18)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd09c1f9-cf5f-4269-5029-08da47b9dec7
X-MS-TrafficTypeDiagnostic: CO1PR10MB4706:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4706D960B5DB99D338A696A9F6A29@CO1PR10MB4706.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yquund3Xt9RZHflWnz0JOmXXiBX0ytPRa3s9jO4LOnqG3Q+abI9X72elM0RgfFoce0o0XqxZefrnuLVYI5PS9CnNUWO48IhN5ISWBYzbHptLvPvNsTCXVn4g3H9mzJ+sFkMtnBrl7A3n5nDcHJMNt76KutmY/RLYOwxaVWxilqs+Hb+kGSxXr8dRfsQhXGLgqZO6ZshMb4wjFz2j0EisDglvtXoPz/nc+tDQkYgLOz5kZVp+EsjCnIoM0WIkAYd/f+EIHJ9eOgRe6bbFwwDAbrF0J28ljuKYKhq/+4SAqGL8d+2BIYeeWns2B5D7gTFtFAHO7JI6GhfpSX3wNEK5M3qw11u0UM6yz0Am3WSrJTJ8H2LDQpMiJnhdBRTHgnwpGhzc0IgWIBPLZ9pBeMNbY6T+EtmEYpGUJiPOotmWU4yl4tYpxV+Y61LyWn7xdIyrobNnOY2bMCdQSF15opWBkiQbVwzGsp3iEBHMGKzc0c81aMsCd3vQUlJN4ytWHvRfOm+fMAucYvCF+wOkVjQ2u5zdOwg2QdOO1C1hapC7aytWaoWDCUJT7SkULC1/AveXWSKpgeAClSY028FAYLmZQyX4cF8MsIVIZn+JQMhBedvXOX5ujZmdQAP2kdJb5PtT0rw/AQ5qtZMV9axf7zSl/BoGQPWb5fhiGodLeXFPDth18vh7edIQ31eSMNEU+WEysx0EmjaMCnW9xRT4Z5/fsRjAjqQVTwRzO95hg1O6adc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(316002)(86362001)(4744005)(36756003)(2906002)(5660300002)(66946007)(66556008)(66476007)(8936002)(2616005)(26005)(1076003)(186003)(508600001)(6486002)(52116002)(6666004)(6506007)(38100700002)(6512007)(38350700002)(6916009)(83380400001)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gXDURMTZtd/Sg+k5egLrW9IHqWk1RsG9AXeQClxyMJf+xGJzUOu+VZvDE4mz?=
 =?us-ascii?Q?EVvGsCbJMAqdpy8f5B3BXR1CHxkpL13qVdO3Q1+IVC4aCPlLkSLTN5jB0eSt?=
 =?us-ascii?Q?W1Me+NxcuLn4MSsOLea0od6R7XXF5EvwfTwF5GdhEzG73Z3LJZYM147Ksx9F?=
 =?us-ascii?Q?Byx9Nc3wJCTFelu838D3WDEmAMhkofgRxIdIyQ9QhnJqXfDzD8WX3i5cBIxi?=
 =?us-ascii?Q?fP0nCTo083NjmbCls9QARmSbv6K2giEmVlhnqxmQNUVupuAlCC0yMw1g3Inr?=
 =?us-ascii?Q?wvqghjp31QeYo5wW6derh4hrywozoBUqryrL2u7Fq7Mr8S4dj+TXMvfPIg9j?=
 =?us-ascii?Q?gOGs6KBBv3WsKur/Ctbbl/cqBVWtyeCkOtlj+/KNxhGsjoTXG9jWhjuMvy2i?=
 =?us-ascii?Q?HEfkLuTYy0TsCQy4rlTYQAaZ+9/G/kD21nxety1m3cobKGhoc9ftjHeHuyia?=
 =?us-ascii?Q?6pMIJtTkW7ZN0Lvqkbg6mFkokkn4RaffJwXzh9fjG/ueMgckPcG9wKGF8ItA?=
 =?us-ascii?Q?cUL6JKGL7lU6gzOrRcpno2ncs40xrofsd6Iy5nukXdK5HrLql2+bdJLfmViM?=
 =?us-ascii?Q?S6dNDUBVKavhvqgAPQMVwXf8I47TnkJFfNdojq+DPDSfInwVQ+TlCM2o5OVa?=
 =?us-ascii?Q?JdcUm494Pxj3gpkcgES+uebWAdof8svA9QEZdwXcJjpRNwM3e3z+bmkrOTzb?=
 =?us-ascii?Q?yKuV/khzopmaS9wm0mB0CwX5/x8PtAxtN69zKt1V06lMjt00V7ZF20OBw71U?=
 =?us-ascii?Q?wpl59buf/GfWNMBaZtdwwnuE7uOfKk3Qh6XHh4Buf/u0WqEJ6WKs7sYSy3ZV?=
 =?us-ascii?Q?JgnZbNgP5ho0KMz6QKKtjepMWiFuZI9gM6+G0hnfHfLsPs5YT+GBPaoAETf3?=
 =?us-ascii?Q?SHWvyXQzAPFt8uQ51nvibn26cynrhcHIbtJpR6703Ar0Totlmob+t76Q7NCN?=
 =?us-ascii?Q?PivP+5ezYETCT7DS12zKAmutSEwuH/HIXiYUd5k0bocfuasXGcEMsYFab6/o?=
 =?us-ascii?Q?gztzoPx5g6rSqOvSJP1Rh5wmrP1N56bccZ//76mBvvA0xi0TruKubLlMd9M5?=
 =?us-ascii?Q?eDRCLFFnq2nEHRsoQYxBBhdScaz4WchSI7JfdsioLoQGZDA0pnD1/tyN6HRl?=
 =?us-ascii?Q?qubiJh+TpW9QUPBcLDHG+kvtOD5UxkyunjQdy1fXOOAtTy/RfqbE2yu+jKbN?=
 =?us-ascii?Q?fwOcMILbgM1pJQHcD/wTh06S5mgNadZ5W+lBj4MWBAVA7PD6qyiD5w2FA1EY?=
 =?us-ascii?Q?Zjvw7WgYlsacrZ0ven837W5tmD0tcP6WOOl6Nh8GO1+wqoLUtxtsQ0FrJu2k?=
 =?us-ascii?Q?P5ICK8YQj302eQgHU1bw1H+dvyzkOWm52UE/oRbkxB4z0Gn0t4ZppkrGDF2T?=
 =?us-ascii?Q?q54FV+GgCaJMdXpb2uB7WeTJMn4piLWiERlf5gQQHFsaXZp6BWBcfvilGYS/?=
 =?us-ascii?Q?fy7b2GOu/cadA6jll9MI48VEsqoVzzO6kV4QdRzQl9F7Z70zQY9gpJIOqBWU?=
 =?us-ascii?Q?Et0XvDxvFSkE8+pm8/5pTU2si5ixLufFtfp/I4JPcTlM4tdT23guKJ+HZHkA?=
 =?us-ascii?Q?wfZGQjRAVa7lgKJ/8zDeguhQiyISpoVSHpFYamW31SuNnyHg1NllD8bMr1kR?=
 =?us-ascii?Q?Sh7qD4ByLJ8uR5M+bpn7kK/8yu57lhRJEmXG1mV0DeVEwVOGKk1jtuydZBfE?=
 =?us-ascii?Q?p5nN6f3IS5NARRx7l5DvP57n4wqOMFzFSSVUJOOCdN0kNwqMn/KPrNWLz6KF?=
 =?us-ascii?Q?Su4Bqu+QsgEuBSlpBGZSxBTE4UeZiVQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd09c1f9-cf5f-4269-5029-08da47b9dec7
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 12:41:26.1596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zq/Rq01kSGr536yOkgCPfPcdus1snni1MLh/tZNCTHf3hFH2f/2WRdd41p4y6PpzGc63D/0NmjqOJyaAkUCwiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4706
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_04:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060058
X-Proofpoint-GUID: gidetA6PQNUmSVWEJ44rYMgOwxGIn5eS
X-Proofpoint-ORIG-GUID: gidetA6PQNUmSVWEJ44rYMgOwxGIn5eS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new helper to allow tests to check if xfsprogs and xfs
kernel module support nrext64 option.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 common/xfs | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/common/xfs b/common/xfs
index 2123a4ab..dca7af57 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1328,3 +1328,16 @@ _xfs_filter_mkfs()
 		print STDOUT "realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX\n";
 	}'
 }
+
+_require_scratch_xfs_nrext64()
+{
+	_require_scratch
+
+	_scratch_mkfs -i nrext64=1 &>/dev/null || \
+		_notrun "mkfs.xfs doesn't support nrext64 feature"
+	_try_scratch_mount || \
+		_notrun "kernel doesn't support xfs nrext64 feature"
+	$XFS_INFO_PROG "$SCRATCH_MNT" | grep -q -w "nrext64=1" || \
+		_notrun "nrext64 feature not advertised on mount?"
+	_scratch_unmount
+}
-- 
2.35.1

