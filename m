Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF201C4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbjKGHJE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbjKGHJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:09:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749EFFC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:09:00 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72No0J031402
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=TIIT5iWYXUdP6+gBKlVmMeZLeNQuOUyWfCTqol6iMXw=;
 b=WpcNPS75OCYwksZvhCWJOerISOQ2TNx3wpDRgjgbMmp86N4xJfrfgugNZ5/SMjcEfNgf
 QSBAUtPd2Aa9mr1+ymrHvI/OfH86R9/wHrGOh/5MBEXwQCA2nxz9hNt2kTBSdpAq5E6Z
 crAUED0d1lHJwN8vsMW09tsOd5isE1U61DrQCRoKhvmQ37pAYrV6z9pWeqq5wqBI4Xbd
 fyojAz2Z58G4G+DGxgiNstn7EsK6SDRXosrlOvlXsxxl3Ro4lCyWDyBRAbyspSrP7jE4
 QxbaJacZKhMJWNpzZAUj16yYrMjUBtD1mO5rd0n1bVV2KCUSl48ZfWgDUERwoBb4Z2HC ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5ccdw9wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76PYwB030550
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63fev-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cu/0fd2ZSKUPe4OC7n3Ww22CE80df1XcRRLoUZVZhH4qY6R2aAOhqoXCzN4xGNYRz6N5X8Bf5T2NGQeMYi9mXqdnqlFvRUOjxQCZYQ8TJkx7KjMHOU3BZ3kQZD9i8CfYpkj3K7uXNuR8BIhLrcsG8ycWE0PMBZ1xoWxu9jbj5zRB4LEy42OH40XEfmnRxW687p67KesRpXccBUF02Yiks2wpbOAI4gAHvU2CKQIg6YWsagnitiQij+SLf3Z/xLxj+b3DnuZSVISqsmvax1z6FgFQj/lGtIcb3C0eYam3cibIpS5bHG2UJIiVIzaRFlPG+AqBk17ADw9b2O6mYSeK6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIIT5iWYXUdP6+gBKlVmMeZLeNQuOUyWfCTqol6iMXw=;
 b=ZvUkXIDCwkcAq8RCueYvv/oP0+s57Gqg56/kzQS5KqRxo0JCdixoDRcdLaQwHGbAgwRsDBMyOSbOBu+Rh7uDMZO2Lp/TXOLl/cI2O8oTiup+NdWgO4M7SEk7P+rFJj+Yv1AiVuFxHAM7bwGYDOPn8I/1/qizLGS+VUVfW3oqlhvbKRPmGOzbST2lq3zG2AmwkEsFu6W6EvC+8McP8BWNuHjIJ/4UveYB7cQ9RZ4i7QuZbAyyJk5IfIkmD0ZPVkDI79McYPbnqJQdq27dB+uFEGkHIBwNHbTkxMY9b7MUZdbYReylTnMZRF/gZyQQnrUCr8Elnxwt07XtE64EBX8ZEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIIT5iWYXUdP6+gBKlVmMeZLeNQuOUyWfCTqol6iMXw=;
 b=zY5oBzKdv4Qxz4e5v2NS2st33TMkW0qaiTjCUZ/0TyRT3d+J/GjmxpixCGJkruaz/nae1Rg+jNe8IY65JchUQZXpzaFTaDW+A3lZPciPNZLIuPu5XYetT1uJXHZo9vj83DA3uLUzE5zOgN5rLExfMsbaOq78VqviPRIzbaprrI8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:32 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:32 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 12/21] xfs_db: Add support to read from external log device
Date:   Tue,  7 Nov 2023 12:37:13 +0530
Message-Id: <20231107070722.748636-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0171.jpnprd01.prod.outlook.com
 (2603:1096:400:2b2::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: a71ac75b-ec2c-48be-19ef-08dbdf6059db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJ+rNLUBtuPg8Bs4YWAdT4AE+iSmBGNdMIUoM/CJTFPi1tLh4EPNWzGBS86ixVy1qMQKwIp79k4HeeUPmCJEoFT8Ka8vTDemb6Gf0yFu0r1TvOX1AnIPBzB4YvQ30NU63/V9NciYWDLdM8yL0mhrM4EMFr3QCuNvxfh1JeHzcmEgcNJjzxmnswkTJAOtl20uJcr9o8vxjVVIV6sGkEGNriGXMlM4VvmEXpKgAI17gLH1bx4Licfu9iyv6gNMEAiOCFXVN/g4EB1mXEElqizuJ4VMPgyNFmQa4W3R11YaDckKeRTjdNduXVQhX2gIvTweu0RwXxqIP8cZRJPWRJcht2Irm5zp8cqhdqUsQdks1ynMEbIt0NVnrYo3wnCqSq0iHymiI7euV6SadLFInASVsAcM7MN11NKK4oQafNDFnVeXgLJsfCfNpnvn9r5+ZmA45QEpyfbXTvtN0a6rH1Bge3j6dVFKFxA04Oo63DImM02pMACD8f4qm1GjY5JNa5KSAwvltj+VsHN7UJhj1Ybb6k0/5nstOZ+W7hvZXuV2IRUEvmvXEHyPD7YwTRzMIXRKfYhuHgKmXKLN02Io9PBrs4QoWYTZL5HY9g6M9TPivhfZP3MMa4rm2YOpHbR2RPlz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(230173577357003)(230273577357003)(186009)(1800799009)(64100799003)(451199024)(6486002)(478600001)(6666004)(66946007)(66556008)(66476007)(6916009)(316002)(26005)(1076003)(2616005)(6506007)(6512007)(8676002)(8936002)(5660300002)(2906002)(41300700001)(36756003)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aOPgDnGjdx5ZHn8ClLOmIs/GWHb6siJNcMJ6gnk3+cKOLcx5nnUUcptKTLns?=
 =?us-ascii?Q?QxVeIBu7SF9ol24W/Euwpr6fScpw2iFQv8rMl+/wOocKvcOWYWxcY/nEhL84?=
 =?us-ascii?Q?1gTvAUu8R7ihvWAkjq2Ezd2/MgaiUsuhHZAsbUfsmf9VVGmppONX9rU6zbsi?=
 =?us-ascii?Q?15iQJMH9jHa6qD+DJl3RFlLgumCJk3/rnevdecfKrRNOzqnWZsnadKhMrkou?=
 =?us-ascii?Q?p2piEG3dx9wxPPr44aW8SumLimlXJasGJNyMyFsbSXbqHHuKQ2suRW99zua+?=
 =?us-ascii?Q?oDNJKcVyUOW3U/oll+96PjovBJAoSeAJGLEgGmQfAv/r+DhZVe0ajV4KwfGv?=
 =?us-ascii?Q?4sG7GUNmwF/JZSSvg1Q58Niwlj4t/SJmXI3DitiNXJ9leuU25ShuPEgsfdYA?=
 =?us-ascii?Q?4BrApEIvQ0tnxzd6wyGMJ4t1f9fXj17XA/cOdEZ3idp0cqKUFoXD2i91cST0?=
 =?us-ascii?Q?Ra1jSAUsVFTjHYPLJcH1y8XIJtSumSc5ud+2rtzQ/r5cUCdCEgo/kujm8WwV?=
 =?us-ascii?Q?zBYsJEYj7lKdnsbH8Q0/M6ywtzeLoCANGd/UFoa3isVJv5lZc7keVKpGZCbN?=
 =?us-ascii?Q?VkziebPE77Q/6NUaNcFxQph+SnS4uHw9JKIu2Z8aLY1nVQWaLmZJGh5VbW1W?=
 =?us-ascii?Q?8a076xlZIUULjdNlj1bqBzrL6NknXnivODe8j2IElQNzC9j0eENXqIx/B3N4?=
 =?us-ascii?Q?dvbpQ8SYwJW/3LMMErVzdb15N1xH0iLmvHRk0IxvdJJtmPeizI/KCnOrsTam?=
 =?us-ascii?Q?HjoGO+vU8vE5PluubCKlMWy4QIEv8FWSUo/W5DF1lyP2dQiL186owB9l+8vZ?=
 =?us-ascii?Q?1pP7gtQiwIckgdXjHQ8dkc6COdNH1M5VQONnrr8pttgfXyNtiAlGaFofjTvu?=
 =?us-ascii?Q?T9ZlVAA15Cq4R5bEtMSTSQBhe/bKdWxQfwt5n+UUsZr1gb1KpSXzBgpPniGU?=
 =?us-ascii?Q?LqKeMukcMXJimEw86TYJ1adNmOBJHysIP5M7MupVYXBy618Uw/dmfZH0WDLt?=
 =?us-ascii?Q?xV0Kbma8n9x5kohfqoDH0xrvy7u7e8UFZxx5MhS+2XpakYtGOj/7aJ3lf44c?=
 =?us-ascii?Q?DxIQ3seezR+7hubnkeJOzbWFc31+SVss599uR9HyOqlZbUvzw7X4L4N+hNxo?=
 =?us-ascii?Q?CCgXSiqwPecCFeZnLXKI0kqgD0rWLdLGpaRJCoFOUehUydxgv4djUqxpNmsC?=
 =?us-ascii?Q?G2bxp1I2gB1kFB2G+fmgTMBQapjp26ALQYiKknveomw/dys0lgLsHgvLAkfe?=
 =?us-ascii?Q?7riRx7NoO/kq+LUZ5q7XfoNd3NsB70otSVNWGaYCRKc+ziOiGg1Z+9Z/LatL?=
 =?us-ascii?Q?5f5uXrPtF5Rsy7A1VYPuB7AAu82eB7IobJsSFMeDBT72S4ky/iq/Es/LVtsv?=
 =?us-ascii?Q?CoeX0upayiQPgSZhfCjUZBLBtB7w36/R1Q7ERWOcMP4esCQ/56FlDrFGxwgh?=
 =?us-ascii?Q?AGNXpkAgI7rETf1SShRJXCpLapxQdAKnkn+3dJVMMpfeEO07jOHezTIfT4ve?=
 =?us-ascii?Q?DiRRhZV08E3M+ZjW9qFhSU6w0PtCMG2kpwOFTiy5cwa5dkH4YzW/SCECWdHp?=
 =?us-ascii?Q?kfTAtpDjoY4LRJraDb67FkAa/CKIUjsqZw6Pzmr7o8zCiALubfDK4NqjCr5R?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KZ1J5MRqwI6VtqGfZhuut2gZ5WFKMDXZARbrPgm676ErKxrRyg/rmC9a+iSwEMlqCobvlEXvUDbojzpxpX+rztq1vAc9aRmml7v1NBkCJXLe5r3avW0uQsbmOxjN6OLQBPA5F/OdfLwFDfagwG/NxzSRDcD/eMJvOWBqQRyTCFGfcXgUI11JGDZeDC4iIH/pZ6dOiOka8LmSztsAclr8gXPNfUfdNxpy2ZA+KLiHkWTAgJfRo2vsShJ9b9tT1ewu6IIkIxp5/6hNdZibZB+1JQ0L1g+PzQO72H8Xx7Y6JsH72Jfr1+RmzYYF0Ygg5V5rQMM9GU8ZWKlxzQoBl0ON4DwTqLqtT9gPIh9KsuaAV6Ce9LXYh14Bxtpqtm3NMuYH9CnwmQ8Djd7AhAJFe3azBFOPSEvLH8vgS4elYqWK+sNEeBeyuzcUbV1V/gaFelvTxwjYWYETSkWviUu26w+8h3wIYssJYCtznAQz2lRMzSiReYpw/q7aBlFzeWUL8fBwBpMDEHg+QSe5CumQfqx639InR41wvg8XiDhQsBTAldgJ+/eNQPghm+Ozo1dzKzkLW/JMHyHg4Vjdxhod1o2Cefnj4h6arKfc8MOTbNSIbov7RZx3AF3YIrLiUvT4nhU3c3pl1F3cU0S95rwq5Iuj4PRT+bz2/QQried5CfySOyMtACRgSxcTc+ZoRsMMXTiH9XqSAN/ONTrzG1hWBQmgaSa/8y+Ur2aVSO6zDZCCWyXsoKBb5RGEEt6ArN4ia3v1k09rZwRLNJ5T5DjSU3CJcw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71ac75b-ec2c-48be-19ef-08dbdf6059db
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:32.8645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVlzkkbn6+u0o74i5s240bDydfTKK78ggvSl03tliCti7lBCvx9cKKYKBcIejZ83OzWtyVjxqc3qySljv/I1Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-ORIG-GUID: _76o4rKNBL6tFiBVol6LGyhm8LyojNqV
X-Proofpoint-GUID: _76o4rKNBL6tFiBVol6LGyhm8LyojNqV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces a new function set_log_cur() allowing xfs_db to read
from an external log device. This is required by a future commit which will
add the ability to dump metadata from external log devices.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/io.c                 | 56 +++++++++++++++++++++-------
 db/io.h                 |  2 +
 db/metadump.c           | 81 +++++++++++++++++++++++++++++++++++------
 db/xfs_metadump.sh      |  3 +-
 man/man8/xfs_metadump.8 | 14 +++++++
 5 files changed, 131 insertions(+), 25 deletions(-)

diff --git a/db/io.c b/db/io.c
index 3d257236..5ccfe3b5 100644
--- a/db/io.c
+++ b/db/io.c
@@ -508,18 +508,19 @@ write_cur(void)
 
 }
 
-void
-set_cur(
-	const typ_t	*type,
-	xfs_daddr_t	blknum,
-	int		len,
-	int		ring_flag,
-	bbmap_t		*bbmap)
+static void
+__set_cur(
+	struct xfs_buftarg	*btargp,
+	const typ_t		*type,
+	xfs_daddr_t		 blknum,
+	int			 len,
+	int			 ring_flag,
+	bbmap_t			*bbmap)
 {
-	struct xfs_buf	*bp;
-	xfs_ino_t	dirino;
-	xfs_ino_t	ino;
-	uint16_t	mode;
+	struct xfs_buf		*bp;
+	xfs_ino_t		dirino;
+	xfs_ino_t		ino;
+	uint16_t		mode;
 	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
 	int		error;
 
@@ -548,11 +549,11 @@ set_cur(
 		if (!iocur_top->bbmap)
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
-		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
+		error = -libxfs_buf_read_map(btargp, bbmap->b,
 				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
 				ops);
 	} else {
-		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
+		error = -libxfs_buf_read(btargp, blknum, len,
 				LIBXFS_READBUF_SALVAGE, &bp, ops);
 		iocur_top->bbmap = NULL;
 	}
@@ -589,6 +590,35 @@ set_cur(
 		ring_add();
 }
 
+void
+set_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	__set_cur(mp->m_ddev_targp, type, blknum, len, ring_flag, bbmap);
+}
+
+void
+set_log_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	if (mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
+		fprintf(stderr, "no external log specified\n");
+		exitcode = 1;
+		return;
+	}
+
+	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
+}
+
+
 void
 set_iocur_type(
 	const typ_t	*type)
diff --git a/db/io.h b/db/io.h
index c29a7488..bd86c31f 100644
--- a/db/io.h
+++ b/db/io.h
@@ -49,6 +49,8 @@ extern void	push_cur_and_set_type(void);
 extern void	write_cur(void);
 extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
+extern void	set_log_cur(const struct typ *type, xfs_daddr_t blknum,
+			int len, int ring_add, bbmap_t *bbmap);
 extern void     ring_add(void);
 extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
diff --git a/db/metadump.c b/db/metadump.c
index 81023cf1..f9c82148 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -38,7 +38,7 @@ static void	metadump_help(void);
 
 static const cmdinfo_t	metadump_cmd =
 	{ "metadump", NULL, metadump_f, 0, -1, 0,
-		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
+		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] [-v 1|2] filename"),
 		N_("dump metadata to a file"), metadump_help };
 
 struct metadump_ops {
@@ -75,6 +75,7 @@ static struct metadump {
 	bool			zero_stale_data;
 	bool			progress_since_warning;
 	bool			dirty_log;
+	bool			external_log;
 	bool			stdout_metadump;
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
@@ -108,6 +109,7 @@ metadump_help(void)
 "   -g -- Display dump progress\n"
 "   -m -- Specify max extent size in blocks to copy (default = %d blocks)\n"
 "   -o -- Don't obfuscate names and extended attributes\n"
+"   -v -- Metadump version to be used\n"
 "   -w -- Show warnings of bad metadata information\n"
 "\n"), DEFAULT_MAX_EXT_SIZE);
 }
@@ -2589,8 +2591,20 @@ copy_log(void)
 		print_progress("Copying log");
 
 	push_cur();
-	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
-			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+	if (metadump.external_log) {
+		ASSERT(mp->m_sb.sb_logstart == 0);
+		set_log_cur(&typtab[TYP_LOG],
+				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
+				NULL);
+	} else {
+		ASSERT(mp->m_sb.sb_logstart != 0);
+		set_cur(&typtab[TYP_LOG],
+				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
+				NULL);
+	}
+
 	if (iocur_top->data == NULL) {
 		pop_cur();
 		print_warning("cannot read log");
@@ -2751,6 +2765,8 @@ init_metadump_v2(void)
 		compat_flags |= XFS_MD2_COMPAT_FULLBLOCKS;
 	if (metadump.dirty_log)
 		compat_flags |= XFS_MD2_COMPAT_DIRTYLOG;
+	if (metadump.external_log)
+		compat_flags |= XFS_MD2_COMPAT_EXTERNALLOG;
 
 	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
 
@@ -2811,6 +2827,7 @@ metadump_f(
 	int		outfd = -1;
 	int		ret;
 	char		*p;
+	bool		version_opt_set = false;
 
 	exitcode = 1;
 
@@ -2822,6 +2839,7 @@ metadump_f(
 	metadump.obfuscate = true;
 	metadump.zero_stale_data = true;
 	metadump.dirty_log = false;
+	metadump.external_log = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -2839,7 +2857,7 @@ metadump_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
+	while ((c = getopt(argc, argv, "aegm:ov:w")) != EOF) {
 		switch (c) {
 			case 'a':
 				metadump.zero_stale_data = false;
@@ -2863,6 +2881,17 @@ metadump_f(
 			case 'o':
 				metadump.obfuscate = false;
 				break;
+			case 'v':
+				metadump.version = (int)strtol(optarg, &p, 0);
+				if (*p != '\0' ||
+				    (metadump.version != 1 &&
+						metadump.version != 2)) {
+					print_warning("bad metadump version: %s",
+						optarg);
+					return 0;
+				}
+				version_opt_set = true;
+				break;
 			case 'w':
 				metadump.show_warnings = true;
 				break;
@@ -2877,12 +2906,42 @@ metadump_f(
 		return 0;
 	}
 
-	/* If we'll copy the log, see if the log is dirty */
-	if (mp->m_sb.sb_logstart) {
+	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		metadump.external_log = true;
+
+	if (metadump.external_log && !version_opt_set)
+		metadump.version = 2;
+
+	if (metadump.version == 2 && mp->m_sb.sb_logstart == 0 &&
+	    !metadump.external_log) {
+		print_warning("external log device not loaded, use -l");
+		return 1;
+	}
+
+	/*
+	 * If we'll copy the log, see if the log is dirty.
+	 *
+	 * Metadump v1 does not support dumping the contents of an external
+	 * log. Hence we skip the dirty log check.
+	 */
+	if (!(metadump.version == 1 && metadump.external_log)) {
 		push_cur();
-		set_cur(&typtab[TYP_LOG],
-			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
-			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+		if (metadump.external_log) {
+			ASSERT(mp->m_sb.sb_logstart == 0);
+			set_log_cur(&typtab[TYP_LOG],
+					XFS_FSB_TO_DADDR(mp,
+							mp->m_sb.sb_logstart),
+					mp->m_sb.sb_logblocks * blkbb,
+					DB_RING_IGN, NULL);
+		} else {
+			ASSERT(mp->m_sb.sb_logstart != 0);
+			set_cur(&typtab[TYP_LOG],
+					XFS_FSB_TO_DADDR(mp,
+							mp->m_sb.sb_logstart),
+					mp->m_sb.sb_logblocks * blkbb,
+					DB_RING_IGN, NULL);
+		}
+
 		if (iocur_top->data) {	/* best effort */
 			struct xlog	log;
 
@@ -2958,8 +3017,8 @@ metadump_f(
 	if (!exitcode)
 		exitcode = !copy_sb_inodes();
 
-	/* copy log if it's internal */
-	if ((mp->m_sb.sb_logstart != 0) && !exitcode)
+	/* copy log */
+	if (!exitcode && !(metadump.version == 1 && metadump.external_log))
 		exitcode = !copy_log();
 
 	/* write the remaining index */
diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 9852a5bc..9e8f86e5 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -8,7 +8,7 @@ OPTS=" "
 DBOPTS=" "
 USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
 
-while getopts "aefgl:m:owFV" c
+while getopts "aefgl:m:owFv:V" c
 do
 	case $c in
 	a)	OPTS=$OPTS"-a ";;
@@ -20,6 +20,7 @@ do
 	f)	DBOPTS=$DBOPTS" -f";;
 	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
 	F)	DBOPTS=$DBOPTS" -F";;
+	v)	OPTS=$OPTS"-v "$OPTARG" ";;
 	V)	xfs_db -p xfs_metadump -V
 		status=$?
 		exit $status
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index c0e79d77..1732012c 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 ] [
 .B \-l
 .I logdev
+] [
+.B \-v
+.I version
 ]
 .I source
 .I target
@@ -74,6 +77,12 @@ metadata such as filenames is not considered sensitive.  If obfuscation
 is required on a metadump with a dirty log, please inform the recipient
 of the metadump image about this situation.
 .PP
+The contents of an external log device can be dumped only when using the v2
+format.
+Metadump in v2 format can be generated by passing the "-v 2" option.
+Metadump in v2 format is generated by default if the filesystem has an
+external log and the metadump version to use is not explicitly mentioned.
+.PP
 .B xfs_metadump
 should not be used for any purposes other than for debugging and reporting
 filesystem problems. The most common usage scenario for this tool is when
@@ -134,6 +143,11 @@ this value.  The default size is 2097151 blocks.
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
+.B \-v
+The format of the metadump file to be produced.
+Valid values are 1 and 2.
+The default metadump format is 1.
+.TP
 .B \-w
 Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
 is still copied.
-- 
2.39.1

