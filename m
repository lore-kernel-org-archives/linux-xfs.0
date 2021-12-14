Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF22C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhLNItx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:49:53 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5550 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNItw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:49:52 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7KL6W022072;
        Tue, 14 Dec 2021 08:49:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ge+j5fJUg9dxZDo3WRzqA/utyTpNos5iKtMP8GUhp2E=;
 b=DliNigOyZZTeON2bn/9gf1uPcliaGSS47gnWcC7zAzWtvnwpaEbFaKJ1NgNATxNyibYZ
 L+DtVB3YFEPLk25eOK3uxx+66PrNtx4LtbmQIa6a6703OuVRJjVyFd4xfdMDi7S5aepL
 rDDoGBcihTuByGn4KfsjfYP0jYcSzCd2e2h89rjVYFuLNJm1ucK4sOVWxnai1vpr0MPU
 NKh3CI8VjHzg+PzH8/OYwGLJxsxDLfmcVhk3UIZdcUv5WYzZOM3wuT8sqptiKu0qGPYi
 AJE0A7cjvLIIRq8FxiKy1/rXp2n35Xu+rB8mYW91zouH3rPI0zr1A/5tVOSVdp+V0DCS 2A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfb6jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fXKg156420;
        Tue, 14 Dec 2021 08:49:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3030.oracle.com with ESMTP id 3cvh3wy7kf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fft5nyJssWAWlRcV0NZDYbB7dRJm1y5po8hfAiEVzA6ginffXMEYoiuftEFbfnA14lFYlTitP/w5ynFtYWiTqAQxgsqp1gYkBtwhygiJyOIB0TpekeTV6mXvtYcaI3A/BWAcgs7uesDFlEcSkpotoZenxnGGV6XV0M7x0cAppwMxITcl1co4T5m8b5qh06k56TIFzlgKwCW4JrQzFwpiGXG3DLDWGGOnUJtvOkkW54vCvHT71fApjrW3ZEyGRZG8OehiguCN9Zul2JP4XRG9mLNhi8hyHjFsVMz8mEdf+q8RhiZFP2N/vQpuPN7je6majH+s46Mn6xKOecdSGgtH8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ge+j5fJUg9dxZDo3WRzqA/utyTpNos5iKtMP8GUhp2E=;
 b=m0IOtICyIJzUKBZlgIVt5kpJuqNeILw70iEOAEIrwjoxlK20lRHOBV4kMUszC/o9PEM8UFbkMRZusf7jrgmPiTWHn1KLFFl5dPeG/s2YOrfI7VLpVgPiZuDE4ZVIrGTJS63WrlNir1GIQmZXQCj6atZXwmo+snRlY+fCwR+LWMiJL9FkLmkVeVv5llQhUk6zG/Gz99hbZIYvn2/VcoDV2QXjos4ubCtRsU2PkwBtu/mq6e72plEr3Vfr+wUuGkYhtR3GMfQdF82N3FYDLTX8HeVLXzzvdh1h9o66bSO01LWAmkbdmHnIok/SP9QidLnnsj+GroM//YS6lhISVbHnXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ge+j5fJUg9dxZDo3WRzqA/utyTpNos5iKtMP8GUhp2E=;
 b=G9x7wPGq5rFPIopsv4a+nEM79o+pr2rzdSNpjLXyRVbqITWzzXqL/DdoZ+wPonPbTeT6N1bQ7y6jVMZpnVJG/X/8RNWJIVGADcnpVvmMnFIzAK6WCgY5VNRlZvFXCee2bxoAToQ3sLp5mXvrLqPp+P5AdNLFKee8ctiLWMFPkYg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:48 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 06/20] xfsprogs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
Date:   Tue, 14 Dec 2021 14:17:57 +0530
Message-Id: <20211214084811.764481-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad6a232f-4ff4-4514-9db2-08d9bedeaf03
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB26564589D1A72B0FE753093EF6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 25IJGTiKobMazcOHfiBvw7huEWgUFVRzPjXcC4O8bXzzT/9U6yTfKEfLSa0xYgSGN3E6PFzp93ryQBtnzbVr3sJItnZs4wWyIUcDDOJuB8NGmcUDJHTSPXXS4x8XoCqRBve9d7pEHnaUf+fklmP/LCLCQp8apzVB36aIHSeEQ+xr30Ub1xrh0MbJFNqUKwAnBLkXtYOO82LE7GCHTFetB4MQT4RXEj3JFTRr8aiTC6yCe7Wn7dL3A5VzVwpYWyX6GwtBBvxBzTV+HvcEU5z3q+NJr6jMrop4GEAzExS02SZlOfFQ02PmgG2ixhkCY459S7FYDmkjBS9lg0lF/WOqFlLHCI0dKZyYOs2tWuRbkMHR4Vr2baoSEUbTHcq6OSrGSa0SyFLdpg0H8jAOrqmicIT+u/FWzTEvSh4ozQKJWnyIt6G2vHpNHDoUghot7kdNF9TiZX81rtmN2SmjQXAjRb472BIb7uaVR/brLClX8OxOXHjgxdBqE3S2daP7S02ZTZgrA211NZnqFVRIkGLKemMz2bsr+NmSVGwh3Oaytcz5ZtIR5T5xh8n/yatuPCNx9POillQZQK8RtDTr+b4WDXrWgkxiBLwQACBNkWi6XzSrZXh+i1QdjpyZzpA+quyngHP1i/Z1kmrgp9qGo65Fg7/FZ2DjcWGUnuB6njRCWD14iHtlecmHuUiYGcuWfT65PToDTWc7McgCVa3dB45V5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8YF+NKm1heJ0wIsS7nltrOGa8k19qNKTtmhR8jfCDc7oPnTovrB13PLpTXEc?=
 =?us-ascii?Q?gkE6SqyMHEZ4Nqr9xaXGJZMHpeluuYsRY/7XuK5G73xV703ARz4TCiSisJlv?=
 =?us-ascii?Q?oy+XTdzA0nnfKZj+ORd1W34g0+Dd/UIm9IpgOfK0GEke738KAYK89oqzR0yI?=
 =?us-ascii?Q?Haxt3N24RuZWO/Cm8uUWSXgOYz1SYenrDuQdySn0+UtHWBUMyKIaGhplEPUD?=
 =?us-ascii?Q?8zetk0ea7R3DwWFWPGEfp6Kjd56tocUFZ05qv5IaQso0psK+LCC2+mxSWHFG?=
 =?us-ascii?Q?CQM27IdcOWoxsr47zKCHpXVACqMgnPCbIhX1h340tEsAS7rscfkz0KexedlJ?=
 =?us-ascii?Q?LqShMAqtas2fcKZp1ipL1XossFKNYe2KL1xxL+4NWXbXY34yUa2e4dSfSCqZ?=
 =?us-ascii?Q?5yxEKQfL5VzAZtIsG/KIfG40TTyXfDWC+4zQGZqYovi+4GSwSIo8sV+FpvcT?=
 =?us-ascii?Q?WyZXK/URuTqWmTPIBoRDyiEYAHQpfo76GT2zOmFmxKybugADoXrtfQUi1GOc?=
 =?us-ascii?Q?f8fn/D4K8bq1ExeGCLBnvpuB1QAUtFxSaZ9BC6L8HcIZftbCeXSB95mJY4ij?=
 =?us-ascii?Q?EYu3PjiKETEaP6huSnnOtRI6jDgo/aPuu0HK7vlzmgwA3W6Kkbb61aYUbeQJ?=
 =?us-ascii?Q?tXHS67F0HQrOMrFnaTswjuQcDwt89W8szsqSyEls2zycEPjcN+NNx3J8yA7a?=
 =?us-ascii?Q?zRMzAbsCbRQzMBAweTyH+fzcQ1B/JoqDkymiq8HJGbRB15zYYC9myaWKN67G?=
 =?us-ascii?Q?2eWEgxXqWy6sm1FjDutNMZTvbzFYgDreCsC7VYXYgbFh4eLepvn7Wc5rJaXX?=
 =?us-ascii?Q?8RB/IgKaNBkvZR0xOzwq55VPtiBAe6RTYiHTiJUM2/Qyfnypd+n/w5ZGULY2?=
 =?us-ascii?Q?9d3uvzUK+Hc6/VL80/0bRUoblUeh4uRjYKqjseNPjvDTFE/QTIQD5NneOIUk?=
 =?us-ascii?Q?UH6pbauqugj4Tx+VvE8pdvJKRXcjjub/uY+NH0vFWo7sigEnf+yWO/WYMWcv?=
 =?us-ascii?Q?BVDrtxySawTu5GxxFAqg+sSju9VodV8vmWG2MDpvsHNRcgX9/DOuPIJ0cLVB?=
 =?us-ascii?Q?8Dn1h/+2ikOhwmhymG5/jNXGPBHNng6Ft/+UIyuK3lBrWj47A3t3+iPUMwgi?=
 =?us-ascii?Q?f/Ai8hRq9N+Wp5rakef+NzSZlcar5oWPDYmUvrGLdAu+NpJkfgxFZ85/VUHj?=
 =?us-ascii?Q?0kLtHH+3kigTPDxQgDl7Jo4TSHm9GNMSPazHHoQ19fzGoMIyCTrdoFyXW/jy?=
 =?us-ascii?Q?klp4jWi4PG0tAvX86BHMR5FkkfRdmUX0GDPAfdeZcj1BhnlEMadN+tLtbFJ6?=
 =?us-ascii?Q?0UiEweQEUhOnFaT9Aw/Ama5jaLchlF/jMZhAMJJqtcXhuBU42v8xN9/E0tMg?=
 =?us-ascii?Q?MYx+uozPZVrMoOFeSVnGLB4aKfr2B3VlvsK4/s9ZLMf2BbEBO/qgPypy0bI8?=
 =?us-ascii?Q?gJfHE7m6hMfT4zg8xhOsEJaZdJyHzKtkHemovqXfxp2nyYBGfmo2r0dQxnYa?=
 =?us-ascii?Q?wVKd06mm0NRM3+jIVTqrAnnQ1Zk8okecV7zZZ9t5B+umNyE58otAv3HfJNHQ?=
 =?us-ascii?Q?cuiywHpPkiF3xNPO9Fx1/AmLErewiHRyXl9pBXLIK6SSV9QHuSchjzirDWNX?=
 =?us-ascii?Q?b2JX16WQrqQz24BghW4lwAI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6a232f-4ff4-4514-9db2-08d9bedeaf03
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:48.1417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dhULnSw2MAKecV9te7deEZIzzzbdhq5TDpUtgwLxhjlcWMC4h0J+Qk74b8H4spKB5Qp+I7nXH07DtrKkdQGCHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: WhvmcL2G9O05G93wm_SP79WihI5FprMM
X-Proofpoint-GUID: WhvmcL2G9O05G93wm_SP79WihI5FprMM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will increase the width of xfs_extnum_t in order to facilitate
larger per-inode extent counters. Hence this patch now uses basic types to
define xfs_log_dinode->[di_nextents|dianextents].

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 2c5bcbc1..c13608aa 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -396,8 +396,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents;	/* number of extents in data fork */
+	uint16_t	di_anextents;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
-- 
2.30.2

