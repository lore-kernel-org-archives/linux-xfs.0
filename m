Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E948C7EE2C
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbjFFJaA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237481AbjFFJ3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:29:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E66126
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:29:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566Ba8N009932;
        Tue, 6 Jun 2023 09:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=gFfz56/iayADeJ/or96nB91bk5qUqbLWaIIosYI2tGU=;
 b=wJcLJmr1STGzCMqQWGHB17UGQWvErkXrcGgZNEAy1hXaNhdUBTpNcNKJfUJ8TAnwmKhi
 f00yzZzZ2R5F+o/zjVh9mA8poqceCvMfaCPl3jdVWlotfbVqDTc+IK5KOm8jhKrLLK+P
 K/uTH8Fh9ppyO3mutEE9dPLqY+iXlXHqJlWrVWlELK5KlAKdOFT4Ta5KReNlO6N0+tiY
 gRoPH7M4p4864IzqxCsv5rsUMfARSkCaenyzOmABuewckVC8DUEfYcS+PFSzyFjvUdGe
 0xNF7XwFWdwYKK5hZTJDcuUVMw/V+9ixI+u0rnZjI05ntyZqEh7FZvoIjBfgsoWTHyp/ RA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx43vvnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 356857rx020075;
        Tue, 6 Jun 2023 09:29:46 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tsxcw7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+LivUMpMRz9qCMWzvlI4nT1goQTctaT7AFARa/EOaaXYlAm22C8AuoTOpuO2kG8A3eLvkf14wyAvcUTc5i4zz+2De2Uscu/QxTwswDuxO5eDyZmp5e/pCHy6vVt8D+ZDz2YAvj8OKF8Xc9ARt9D2UUmNuPCu/wRf/mMZQYPFX409oZXJ3Os8j4wxxS72JTQqx5U2U86hs6LascUNUI5964yx1SabRtZbxVjDOO/inaI8PwMpiLrEAvHcb7tB1qy+X8BGidXzz2zGgbMh79Nt2RpiKrL/aFB7H1o7WiqXv4oTc/7duyGXnEk2esGDMuHGzdASAsho3VVnnmGlDBNHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gFfz56/iayADeJ/or96nB91bk5qUqbLWaIIosYI2tGU=;
 b=kYeWhdS9exqspyKN4Qf4v+iCnJVnwTV4QASvi2aStrPCWOeYGNS7Fu5hAc42ZAKM0bXq+BW47wjIlVU+M0TArIqwjqYr4skmXuVpc75zH7VtgwuDN8CE2SMP+kxiahH0mW6D/5tp8iTly/sm49fSRsgGspWn/XNw2n3Xgt12F8uLQ8TOj5tmpN5kXq6E9y35O1P9qt63NlisqjXds3sgcAiixuc0mD6A4NHjAyt4/9V6n+JnFCE0CdyLe1SIg3K/aXAHV5Jqr0fE7y6+zjh4c0EQFCcNQ1EGv81uQMLVFUm1u5u0mrxITuBT9t2h/QfROupYbum+NCveTabYYdfu6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFfz56/iayADeJ/or96nB91bk5qUqbLWaIIosYI2tGU=;
 b=YQ5MifMe2mh+Gxr/bUSUp16t5m3DAl9FcB6raSr5d8EFjEMRu/N3edm9TQ0Tv+/BCWUhwpcQt4rndyoezHuvhB+1rA6cbRmPMZUf9sOyPs+8tPfokxSP2ZZiT1ujiSSJPXZuoi27EKKFA4Jq8a1UuVrwpRU+XyGhERl/BzV5PLo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:29:44 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:29:44 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 11/23] metadump: Define metadump ops for v2 format
Date:   Tue,  6 Jun 2023 14:57:54 +0530
Message-Id: <20230606092806.1604491-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0093.apcprd03.prod.outlook.com
 (2603:1096:4:7c::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: f702885e-5324-4533-bd29-08db6670900d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJ57DmyC0wkfwZRyb8XPK66vk6P1UnEtHUx8aO1u1gS/Qm/al4jbfOXXP681SN9NGYiFyxcOyBWrXa5OnAx94lYiajHkQPSdG6snc1lT8rQrBv/shuF25lZfLzxmEMO7mEtuvleSdgyGVVORDNXlDgkuwZgCt2hLXVMdS0E2KzmY8fyxPuXaMSxW3Jt5aE07twPfCoDBl1WxCxGA0CftzAw/KQNBOCEDiCVWf96/tpAbEdjWG6SrVSpZILjpmhG4IKbpBedF6S4gB7q669wUDCQJDIYymrM3VYuCTu0Igh7iRFZvePvTtkAvAlNO7pMq+wfX/e5mRV76hFfSxPrkA5oC0gov9WWCNoLOebNt3M41xWaNVnZdjCfrKdIHgt5IVQWgApobZOsB8H2VlFSJkJLqu1d1AfsIqBgZ6AeGxzczxuTxYG7S2A9enqHYVgYri6HWjN2F2cPaBL1mmHc02GQAkeMumsGdVnQTvEOzQSkeWoLr/JZWbYkV2FYOBbGgqWXq4j0B0P84qxhlhfu5f+vUcJKqfom/3+38ZAogpGlFVHpb5+yxjgEPU9gUHhZ+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zbdm/fcDWnTCNid/Sqt7i61WzhsIy8BEtRmxJ6MEp5LHD76Jrs9JcXxz0KH1?=
 =?us-ascii?Q?3CKeVWO58mw1TNYeKeXB84SLkVvP7/yRlUfb2FDSHlZBNWhcK8IYvvd7KxDI?=
 =?us-ascii?Q?Kv2+h7sO9RERqWiNb3ltZ5Pn4iSjvIl+l9i4oy+buLoLNgI+vJJgvPbBQPfG?=
 =?us-ascii?Q?KKW8/noYQWJz4ujU5kFfu1MagCoHzmjIZxAlMu63FZGukoA14eYJcKyK+pyY?=
 =?us-ascii?Q?yqrXh2JEoxbreqgANbLrPordLsbFzo1Wa5k1WWpT8F8Oyd94bOYwAArMPWSl?=
 =?us-ascii?Q?UK0fsin0LjOEsYhMGivvIZPa8Y3aqmn2PLjWb5slERvNKlUt0Fcez/APfRd7?=
 =?us-ascii?Q?tsFEGH20Bwiib5IGEsQxbmoh+iuNifVpbnoNpyh+MqMZ1gBbGew5CcaOZmpE?=
 =?us-ascii?Q?9Tgwr87fhEHh8izFkoRsWoojncJScEGOhWJ9/M/HgUGYiTOrjLBLVCf2REmE?=
 =?us-ascii?Q?n1hnzOYVhsBC4Tz6zTDj8p94aa4RM7OfTdackh/phn/9hciTspUpf6zTsjxH?=
 =?us-ascii?Q?iP+pKbRUEjqMf+WweyUzP9vIpSQ7+Lqe2GHgbtSwJuxsHGP0lWweajYFalu7?=
 =?us-ascii?Q?h5K06H8rvainLkqqbFHKUYXh7jdgFhRRj6KOnlP2pHBTW8xobaqQXu/lFx0H?=
 =?us-ascii?Q?cnG77fZJ3CryjhrY4XCl4FyIxOGtxeIrOAw2ygma7CtkHce9i6p/NfY5QMH7?=
 =?us-ascii?Q?4qx1VUAiUT1TTs8CFzovOoeO7su0LPCrLPyYQL/Ru/VHiVs1Nmt2VVHprMxR?=
 =?us-ascii?Q?2eBr9P9ke5ejJ+f1CG0JvnXuIbMIGB+Ry6Zw08ehm0JXRTbYQH8BUa9SWWPm?=
 =?us-ascii?Q?3RqB4b74UsyKjW3+plsnPvsZvIZLoPKL0cCGPmb98/8dP6452yHCcwOvi/iS?=
 =?us-ascii?Q?+l8arXqhCnkkqtpSdS2/8U/Qtf6Om73FHMmgh9YDAbC5YFb9wRIHEFD8zvsK?=
 =?us-ascii?Q?e4lF1KrhUOVRr5F0jh3nNMro1BQbY8fFbX4Kv1Aw1AXeVARHlN9w8GDpf5Os?=
 =?us-ascii?Q?Z+yArWhaN86GfAEN13/RyS84Ag1nF3k+O6/IqZJL+40/f7P9c7Ufe/mSv9XR?=
 =?us-ascii?Q?tnOzi1/kpl2NKBUqt5FgDWTfXxLVb1WyGMbKvT07vKQXnzWvvWNbFt9bfnTG?=
 =?us-ascii?Q?IGjuGxAnQmHXyBhaxN/Lb6zWOsUUN/sAdBxAa2hb9NP1H+aNf7xbib2nIii4?=
 =?us-ascii?Q?3RUuxYrHqNXsrtqdIa1Ubmykwpn/bB7TDOR2fCz8RMUM6lqlGPI3uS25TTYQ?=
 =?us-ascii?Q?gCrPaTwHK+3j/X/TxiOkWeP2fjieK976Ta6kAsZDc5enJIWLLc7hHJuzfD88?=
 =?us-ascii?Q?K+4Htj2/1Ix5tU/W45K6QELj37gH2+byaxCLLDoj8adNZzWxbqHPuTEKVtx+?=
 =?us-ascii?Q?LbYYpHQ0TQr7Dr2b8SoBWKM9fH4PpytZM8JpcPSiJcRcXiCdv+lTSYW7Cg0r?=
 =?us-ascii?Q?vDhb85HeyDDSlit5r/2osCCTBmUq006XYU4jc6JeCvO1NGAM2w0QH4eynUCs?=
 =?us-ascii?Q?6LULEJek3RGMf8wE6cw34rHjxaVI6MCiTDTJMxtVyK1npZFoJMEj3wVXwnMA?=
 =?us-ascii?Q?nYEWBgKXNF/TATBTO4QGPcNrq1W/cyLzv4hvcJ9GiYpyd1A1gxSlePy9CFzj?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iqYT8zt4siyqGzWiyd+ffH8ivRl0WXZXeOgzHEL2mJb8b23IRKUGR+OeRj4IhULy3DFIkAZvMO2OCd1GPjbzzP+TQCUAAD/B3rbmsuHW6tYXgt9W0RRWnvqjb4NxzDy1YGs8xOHCriaeEtBp+B7gR018vW/P+zOlhtIvwDCVSGXl9O1zU04D5SZmj+z2oXasQtpf6t4Xtv6DwYfaopcp0LccDbRCYUAqImW+xzJgbYNiHSZe4G/MgoQmaj157dBXCwfEU1dn+TOQxhfhDafj/gYLcXvY25A/koXkpN3/k8JIuBi+9BTkDLXyqY293EoD/QAy6Tz86HX9ycsOZi9yQ9smRBOpYdMaD1d7Z43p+gSdyd712zNVS7p9ypev4BVvJKdwWHjTyhNURSmjRM74wbFJmX/cLKIhr1oPiwqGXRY06+hd+Ts7u+Xe9vbVXLtOFAoeUhzBfycmW/R/CRGVmgCmwbSUcFWaNKir566hp4cqdSg/wrxY6u81TSfgC2mfC3FDxEsRXFqdYT3v6DHRtInyd8k+5zvKv8uwNMb+ZaGjiwGwMco8aXN6MywLSpH/oeEwg9b/yjdt6w3ZU6VbL0fAk9FMKqKjY18gK5IwqZtVvV8XDn5iskEGcWFAIzfpKS0u4oYp5gNQQAve4FlrqD5cvGat6MXiI2JxKbe7uIOqTzQhjm4nqS8UujOo3RS0NIh0TaNTn+zeXNieAHkB2XZmyrv3lfE/a9+ebjh/GLtdl3VvJxFudbBgoCr2MPTKm/A4Vxd86UJW11yHsatv3SPYksmi5KyAN814pw21VcI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f702885e-5324-4533-bd29-08db6670900d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:29:44.4853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: In8XhZW2bUw+qsY+g2WvoaleLsQmAeOo56xnnyZrNTsXGUpjg9TAAA1WUBbIXby92jNyLwlo1Ci3CLC1Ne7gmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: gsNWY8WRtuOWNX7ngwEPa1iXCo3DNle8
X-Proofpoint-GUID: gsNWY8WRtuOWNX7ngwEPa1iXCo3DNle8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to dump metadata from an XFS filesystem in
newly introduced v2 format.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 3 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index b74993c0..537c37f7 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3054,6 +3054,70 @@ static struct metadump_ops metadump1_ops = {
 	.release	= release_metadump_v1,
 };
 
+static int
+init_metadump_v2(void)
+{
+	struct xfs_metadump_header xmh = {0};
+	uint32_t compat_flags = 0;
+
+	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
+	xmh.xmh_version = 2;
+
+	if (metadump.obfuscate)
+		compat_flags |= XFS_MD2_INCOMPAT_OBFUSCATED;
+	if (!metadump.zero_stale_data)
+		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
+	if (metadump.dirty_log)
+		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
+
+	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
+
+	if (fwrite(&xmh, sizeof(xmh), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int
+write_metadump_v2(
+	enum typnm	type,
+	char		*data,
+	xfs_daddr_t	off,
+	int		len)
+{
+	struct xfs_meta_extent	xme;
+	uint64_t		addr;
+
+	addr = off;
+	if (type == TYP_LOG &&
+		mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		addr |= XME_ADDR_LOG_DEVICE;
+	else
+		addr |= XME_ADDR_DATA_DEVICE;
+
+	xme.xme_addr = cpu_to_be64(addr);
+	xme.xme_len = cpu_to_be32(len);
+
+	if (fwrite(&xme, sizeof(xme), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	if (fwrite(data, len << BBSHIFT, 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static struct metadump_ops metadump2_ops = {
+	.init	= init_metadump_v2,
+	.write	= write_metadump_v2,
+};
+
 static int
 metadump_f(
 	int 		argc,
@@ -3190,7 +3254,10 @@ metadump_f(
 		}
 	}
 
-	metadump.mdops = &metadump1_ops;
+	if (metadump.version == 1)
+		metadump.mdops = &metadump1_ops;
+	else
+		metadump.mdops = &metadump2_ops;
 
 	ret = metadump.mdops->init();
 	if (ret)
@@ -3214,7 +3281,7 @@ metadump_f(
 		exitcode = !copy_log();
 
 	/* write the remaining index */
-	if (!exitcode)
+	if (!exitcode && metadump.mdops->end_write)
 		exitcode = metadump.mdops->end_write() < 0;
 
 	if (metadump.progress_since_warning)
@@ -3234,7 +3301,8 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	metadump.mdops->release();
+	if (metadump.mdops->release)
+		metadump.mdops->release();
 
 out:
 	return 0;
-- 
2.39.1

