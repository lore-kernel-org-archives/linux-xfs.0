Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26547EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjGXEh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjGXEhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:37:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15A01A1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:37:24 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NNNCQg001492;
        Mon, 24 Jul 2023 04:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=WxQ3rU/98LcQN8BGtfGwuT/w/tKOVbV7UOfxEVvh8xs=;
 b=gUfcg5yCmL2xga5JbOAFSByZxjjOUZoDTrO+XvjXZvFnkpLAdOY9zn3urH4RA47798K7
 /tYLyKVrIHXrwvPvzJaUGMND2cKa0Zx/JJXKTSwroqBp3bIap0N7MR5HWgdv5idBGnS3
 WRxW4+xG6udkPycn1cSXIEYqLVjcUl+Ljl+MvCCefDA3vr/MXDbmBNIik/FHFvFOfu0M
 xy4Pe7AEOIxxdE7XyISCJXcepy2XEcCWvIpSVG9LnV2VGixUzYKEpedSonIX3gj3SEd4
 6yDZUUK7uQrIiXjXc/mJmwjKuR+OknIwcXYxBtdIwP1jc/TtcVxLrNkRxhgN//KZpU+l kA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d1u1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O1WUcq027608;
        Mon, 24 Jul 2023 04:37:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j96c5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cyxa2Id0+0Fl2khikbWl0WhqTzOJetBcd7I2vAgPcLcaQHker2fuQHLwuG1Jci9fvgs9LNabFSXIPRdCfHzxiz4TcAqmMw4CZGAQ+NkUVb8scyxvsPhyLDz3F+jQltHiAgMjiUhL59Iw/CWCzuZb1Ly+u2I3PWxIez8qO9it3y7JHsJ1ZgJ35BhwWOrYO9T+mkhw66Yiu3i+UeN7lho7RZJJJ9+i0zFrIVNUucoKvDkCJ6kJXl+fhnuhLab431emZGG25NTPwk1MLJ1IbX2bJi7jsdpDWokvvF9eCxEmJqxitOwFw731hbug1771fc223q5gWLsGi/g5Yy8Y1NIGPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxQ3rU/98LcQN8BGtfGwuT/w/tKOVbV7UOfxEVvh8xs=;
 b=k7JR7kDDMU7HmcIHnz31lScEkMtHwj/M+RPbzy2DYWODZCaCxYRUmAQ9b0kFrWnqlp0zFRakd5IoNEpl56ZSPFhQvbZg4zOPHVrm5MeQhpCAtufJQKClR5DqikmbCyXHEqVOLauxTpsmoi7haytvIr8nGi6oHhb2PQcMqeWwIMDUcMMc0jMTd1KufjKDWBErrO5qpW5O4CuJ+1ObuDhgSzPoREUpPmd/pqpXcwAf6mm0V2JaATI4K6AnMdKmTVHmMJLjDq+4cb13wvysK72/OSpKdYpoK3YJk9yikFp6d/Ew2OffkE6OzRY7dnEugjU46eiK564VypieFAf7wgY3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxQ3rU/98LcQN8BGtfGwuT/w/tKOVbV7UOfxEVvh8xs=;
 b=QfIl5ECB3zifsDE1cz0IfUycpX6tHO56Tdtpr8PTtCir/eNU0d1RXylV0n72R2VwDPWlhDUKv9RkeMygAOBt3v0Zu+qWcRsQ71urTcP0SH2Sun2cyUxbW/uS20U8gH5fReXmggYKVkUsB9p+ahgjWbr4KWIsTzJrmFk6QTV3qCo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:37:18 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:37:18 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 09/23] metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
Date:   Mon, 24 Jul 2023 10:05:13 +0530
Message-Id: <20230724043527.238600-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0027.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:262::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb0e592-3e2a-4ac7-f726-08db8bffa9d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FMEloGnDGqDHQ2BW/PLtWU+Wl1XEkqkdf7Gb6pxekiKTQZDGw3gFTiU60EJWLv2WDkRaRBJJ5TyViZbZjGdDmbBv3Za4f0hOzX4qZ0HMbYjQ2hnmX0i8dYJC/4Dbb7vfIHqemz7w2OPY9+yZwVbBYVgZz0kY0hTf2vpBp5xER59tzrVJgBCA8FKD5FzgfwJPsVbWqlEEe2Kh7PYqOth1HWIt+eRqV2WpyD3bA/OT6HXKRECidmMPZB/O8uFeaK+8bf2kGWDenQbchd2u8QAe3/EzCmSD8RnnuuSyBIyAXidYXFhVXcv4A8YkR+xQhtYyoPkNrBYh6mNWFusDKtUAtE/IKpnc2gPaAmjf1/yGZvk1NP10m7zAabfQPIGb++ikOtPA54v6qzCRsPVy/9qlTRxt3oNchV9pJARHqY2Biu5my6+C9y/wXc14vhpfNiSZ1O+5GXnFFpij+N2rKtZMfwrT/Bmek2U89E4rUfuRrl+aiT8x8+4mlPhU0L8JQc5qEvcubSXZ4u02SKwNts1svQaBOD17c2nyfu2kwPuaT3SyVzTiaEZk3s087KRHExi9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fXpOdKaP/vaWEwUgatM7xhQ3Jgo7yk93DFpA9DS+8QI9TooHZBBABBlbMx5z?=
 =?us-ascii?Q?xO4qOw0KAsxccl+8uvZr2ouE7ATaiAFoNyIbRAEWoQ6cHBvMQcn/8634NigL?=
 =?us-ascii?Q?++ebXR6nqbUxbRGDBFU9c5Z3L/KPDasg4B4f1K9RTidS3rF53uUINu4NopPm?=
 =?us-ascii?Q?YsNOiPa1WbYeUmTZVJcMwDtOpkFlWMKjn8kSQV67q5qDzMJZAYIzG/d62gZp?=
 =?us-ascii?Q?WSUPxvGTvDjDnLHSB0CHicziS4uQzwPoacAyAJo/GLNW8cd4aox2NxuF3r9N?=
 =?us-ascii?Q?/oz8JF6yVCcgHsKWMPMAGlv7A6j3Nq1agSlfAg+kCHdnV3k7UgrT+ce82NcP?=
 =?us-ascii?Q?kKPT2yr58bTOiyi89lMwzMaxCAGF70mKWr+kqL4wUSW6G9YEj6/tszP61De9?=
 =?us-ascii?Q?tmbFi0yLYD52q3sUCHK4oEWKada0r4UEvNWWOqAcrVq6equV/zLdcr5nXpOi?=
 =?us-ascii?Q?EtOjwXchypzWJYqiuOz5wcimiKM/BEM6ERR7DiXBaBhNpULPe8J3iCYTdnIj?=
 =?us-ascii?Q?7jRWkHTX0iHNZXbwqEhThX+aiiYl4t6UDOdiIErph15sja3HvHP70LMp2qDO?=
 =?us-ascii?Q?Zqny9DxRyH2tjwRnWtTIHdWjMDL2WE9DHoYEhC/XHWCgBGd3wzlTVE6Uzqhq?=
 =?us-ascii?Q?nMHep/0t9TWV5FUM0yLKGP+F8+c+W8lPobxMWSyeK2PcaGZUAEIPzTLpbPKL?=
 =?us-ascii?Q?tctsreNY1W2GIzi3O4wYlMYSsCVqn3Uo8F760MR8ba2b60B55MNKYGB2Mwo2?=
 =?us-ascii?Q?lLRwSY040+nFCctae9/gk4qcQpDlH1zFdCeqhycUSeiaM5t1k84fy/QcHY4X?=
 =?us-ascii?Q?B13s4MK7UqFcAMpLNZ5LgjxZbyBf/7MUWWFY2Ian8E+pgrwwpR5l1EatBuqJ?=
 =?us-ascii?Q?9FDVPGxD30qwtD/FcbEl4i8lc6LGCHmMwKE1LZnp0A3VdY2B3PEsL+Rt84uU?=
 =?us-ascii?Q?x4+cwKeRkFYAw5eVpYfaC5UFSZ7Ge3r/RN0ahG0uH28e1MiwHCi5fL5qsBEd?=
 =?us-ascii?Q?bf8QdeW/Tp5kzIxu/Xunz2qgKND5RDzK+UiVqmhWhbBVYjWLJCOodNebIoGu?=
 =?us-ascii?Q?U+PSph6FWYiQsZGSH+RMFB8BMLabDp7PHPv+Cm9q+na/OmMFFB+eFEpeXNBm?=
 =?us-ascii?Q?Fk+Lo7SJ8JIcBTrblICGlcFMmZadqRBD80qMCU37hNxOySSLp/bH9V3sDgqD?=
 =?us-ascii?Q?Eyr4Zjc8kQWL0akBxkEOHuLy3+hj4YAz2+DrG0qZYyZ6pIKMZgbU6KQ6cE7t?=
 =?us-ascii?Q?DZpTDckxBK3onRK9R3CaAmNnCo2FNojIP2PckxBIdVUgtBoaMnD8sAkCvulf?=
 =?us-ascii?Q?WT9n4cU2fuhm8Kim924HSqD+/R+YyumurWcTovT964p2oR3HuEMYf7FtXVLi?=
 =?us-ascii?Q?6zL0zymYysAJY0jp/5Thf9zrhtQhfEeLHxLHzuxkGOgSDb5tfen2eUJSu7Ym?=
 =?us-ascii?Q?/mK+rnx68GbGHMrjKZJjE+8lI7FYiA3jeP8ikn3UugNNfSNnJQ72Zkq7CPqe?=
 =?us-ascii?Q?7WBLrDJGrtmDEXOuNfEhrjs20Fr0JeDLI+UWQPh+Z3fYHOZXtldDOTEfpUHE?=
 =?us-ascii?Q?28x7OLRWr+06xzd3ZvqNLSGOSKAxdV6GG4I4UpKRw5xDV3SFLPoJo/gM1geg?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wDmFs7DUUJ+sS3u5gLRFTjeoT+B+hyjcan0XeQeaP3lArvXHHt6yJPLJGBtnUAxiqJGlbcMbxWvz3RWYCra3lRUoO7nnFqta46xc1EbF8m3c2rykqeJ1DEq9zydH0dJpWxmWVd7ZLzb6G25TLGIfJfUJUzxZRGLVcbDkkOIxGdEa6MGd2itFHjJxy3+tSrt3z9j84xMecWdOuY6FqWMrv67sQ+QxsjS4tdV62Qec/7BPuBulyMtrmnzz/TpQufx7rL+q5iMrrp51ifAviDRxT6lm0aQqVdb2Cmx1/7JtCEUzsHyN/Q3Hb9uVuhUulsBLP9F34UTjkK3h/j0oujfY2ZX5/9eExn+0n5IFrh++F0rg/0XTiW5GW+1y/d32F06n22C+h4Xq78s0pqN5yqioTSjo+edSBXJCjPURBnumaA2Cmt8yArlyZuIDN0qNMQXIkZYfzDEv9ZbxUkls8tOG2oQQ+v/GI5vkwKYj443qaqkf491ZuhAqgpNLJYFzBw9js15M5ZDHLo73e2USc4yvvRP0X/4TnY9dBhcklppFPomAbAdYeFO7kSaU7w89F5jntAa7yEOhheOsNG29LBZV8X1pmG6LMO+V+gKMUNAys+hLPD1O8d5HUOhwlT4jRmCdNufJCVMj6o31QQRsui4ZLChed4l2VC/hRz1tYrE3XvVCTkKdHRyoq3y1hWlMMWYpcWO08zOL0oGcnDMuqaZaKMcu72J5q7SERk/VDna0YFoqn3EpO2E/uTKMi7GRaToEjPZXGrf/gIYUlLZAyXpbXvmTPuC4otvC4CCKp2RGNa0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb0e592-3e2a-4ac7-f726-08db8bffa9d3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:37:18.7418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mu48TuQSHUPFibv8ZLmbfBgzlQNlXRDqk3fxKHgYS/6Xuf8bNOi0O78rY5EYEOqKnzu8oc7T0kwowY5Bl9IkQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-ORIG-GUID: U7vJUcxUqcOSz5xALMGfWu8AS7rmhAYB
X-Proofpoint-GUID: U7vJUcxUqcOSz5xALMGfWu8AS7rmhAYB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c             | 2 +-
 include/xfs_metadump.h    | 2 +-
 mdrestore/xfs_mdrestore.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index c26a49ad..7f4f0f07 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2968,7 +2968,7 @@ init_metadump_v1(void)
 		return -1;
 	}
 	metadump.metablock->mb_blocklog = BBSHIFT;
-	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
+	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
 
 	/* Set flags about state of metadump */
 	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index fbd99023..a4dca25c 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -7,7 +7,7 @@
 #ifndef _XFS_METADUMP_H_
 #define _XFS_METADUMP_H_
 
-#define	XFS_MD_MAGIC		0x5846534d	/* 'XFSM' */
+#define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
 
 typedef struct xfs_metablock {
 	__be32		mb_magic;
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 333282ed..481dd00c 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -240,7 +240,7 @@ main(
 
 	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
 		fatal("error reading from metadump file\n");
-	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC))
+	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
 		fatal("specified file is not a metadata dump\n");
 
 	if (show_info) {
-- 
2.39.1

