Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AD1C7EE2C
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbjFFJbC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237325AbjFFJa6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:30:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95BCE6A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:30:55 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566KoW7009936;
        Tue, 6 Jun 2023 09:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=ZU0dkQwnlZa3pocupZd3MHbBrekBsL4NMR76JxnBYyE=;
 b=LpgxppXEVef5DnfEHD+tbu5uIEfnPecMj30gEFngkeOTcXJkCdQwZT01E01jRTK54gSV
 6UzrkfX/wOsqs405hrGVhFbtfureqQuuOpJFSA6Vp+M40H2asbpuBfMLq2+zY6rV6NAO
 WdBcfGe8SIFXxckj09GNFzsPldWQMZpS/+7szLjcpN40lCWT1vxgw86dszikjs1uFb/u
 AVi+y93B7nCjIW/OpPK9kX7KB4nt8VcuL04c7aArvWu7Uno5H4i3XoX6bLbM+/okhRhG
 KlJdiAXxxFTrygU1uBPoKirNxjFg2m1vAjWqEWjeJTpUsA6h/3maS2GtCgKZqVhTLblM xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx43vvpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3569AeQV024171;
        Tue, 6 Jun 2023 09:30:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tkgvegj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtLebMxEigyu1r4AkVCDxxea+h/QZ6Wagq3w8nz+jZCPFJxGiz3RUk0oZRYrsz86znLf0ZUVU0REJe7Msa4g3mI/QLfBm6DgOhS5T0KwzVf1tdwuNcQ+6JH5W48kXJZkyuMFN+z3Mz1hj7Ae1aN7jpTfLmiRRcaC3JvoBZb1AQiCttRuWRYK9Z7/CeD7VP3eckE0E+cOn5Lc+Mo13WDGC1j91PiwC6HR6s19dpHVCQeWMTW4ZiIxfURZjI9B00rBHiEBfYI4RXCEZwqdS2YnZqqU+gvcbksv+S9rND2wEk8FYsravBZOkQjjY3TTHZZt6aayKrLkES/Zqh7z/6R5hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZU0dkQwnlZa3pocupZd3MHbBrekBsL4NMR76JxnBYyE=;
 b=TXEH+Cvwqx0I4OxNM57GGZMHR14riU7+PmrimuFofr/uYW6vLDTvUDqaUIUYtxSYY1tYJhfaqmz1LCuu7fIIPUDpphlAxgdR/koDg5lSZrQjoegRPTBsjLFbsENxMG/dhc7K9CLa2tdeI+vY/T9LP81h0giNkH1PIK65T15oeXfXMRiOoA/29uhg2YAUUyqbX6SJYuZttDgHprHVjTdgULHMQnMEHTYfBL5l+DSJLCKyxjQa4nR4eRNLeLxDWVLw3U443L0Cd07PJjr/rCZK61zNUfVHs6r2/Mk+Kd6VBdWMohelw71MeauDJzIEwf6A4zkMVty9a7EHsgeb0IhawQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZU0dkQwnlZa3pocupZd3MHbBrekBsL4NMR76JxnBYyE=;
 b=r6StREAw8f55/rttGeXvx+F2Bd/zcOL1xbo1FDZlq5mMyM7xOtE8X1b9N2HTREq3a2RgPSay3f0hvsKO79fn92X7g59rZ6U7diPmyN5MEXEbtcYDB78QGFrt5fRsPv2sBUS+TQV3NvPpxus5r+tCjJs9MGfeRC1Y2eoBiH6oNnw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by LV3PR10MB7747.namprd10.prod.outlook.com (2603:10b6:408:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:30:51 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:30:51 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 21/23] mdrestore: Extract target device size verification into a function
Date:   Tue,  6 Jun 2023 14:58:04 +0530
Message-Id: <20230606092806.1604491-22-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0190.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:382::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|LV3PR10MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: 35b5b157-223a-4991-aa29-08db6670b7de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f08I2OMUNjeWgjDlMOwA3P9WJyPoF0kRb5aFqUReG5B27y86MgnBJNZwQB32ZMmjyC51ttU064xIzBuCTrLiDJRNatZ0pggV8FndHVmegG1jP+V5Rq6DmDPD9kI2mQ8yxRD+dPiVQslohlxNzuWRTpSvVOA40RvEkCu+meeF6YTm4mdCl/0VAILnh+Tl/cvNaD+39XZ1e6+EDuaHS/EGcms5GajLQKFStqQCz1aQ/MK2tBrmJbUIdoLHTmDOoKzgXOYR230JKV/BHcretYV7p2eAvMZlIHfdEq4BUJPl3QBu7AKj2iIkY/FDdnKXoq0m5HapOaHfI3tU9DFVNkBtYdF3rI8em3AVN5ChFZQwWb8Ty+1gQaQAjbS5ev3muhW7btA8O7er1F463b6qV4ogXsEpAKsAXolBAPkbVyL9SRcUA+A1I4c1AkeDAzFxn7ReiboZC5VtplXsCz7/IAQCqXb/odSwkKZsSmhFOAb0tO3sbTK8m570l/l7zFZ2D0pyffjCw9Pvnj5Jjq9IHqU+qzT79Moxe9LWQ9kRwjIR4YhM6n1LnHISLGsQbKdxSYL9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199021)(186003)(478600001)(6916009)(8676002)(8936002)(4326008)(41300700001)(66946007)(38100700002)(316002)(66556008)(66476007)(2616005)(83380400001)(6486002)(6666004)(1076003)(26005)(6512007)(6506007)(15650500001)(86362001)(5660300002)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GlSEnitvMTdmzSRIHqWl5iHMa4gJsoj12Dqbw1/z7YpQkIF+0vbIVg3AluU2?=
 =?us-ascii?Q?pVBr67VHOhvgVAfwo6jyUm3pbJgVxp8ViWWnQZI7MvC90oIpv85VlQ9p+RhZ?=
 =?us-ascii?Q?EnnKeGvnInSc2luJ21G4cvAADJ/IxXxLEMXl697lqu6xeyXYCauBaMnTQvOo?=
 =?us-ascii?Q?APhXRediAXJP5ZZOEiMvNJxDu4Y4z0GqwQTKawIw7NBfp3t0uaCB4kU4xDWS?=
 =?us-ascii?Q?oZCW/pFwJAED0iH3NfXDM+NZtHs3zxj6P3ASzdo9sV85jUK5fwPMU3lZX8zG?=
 =?us-ascii?Q?EXiPpB8APQ4ZMTC4Zv51L142tl2HTsAnL+pxIh/8NVpE6LN0HhfnSGcwaP00?=
 =?us-ascii?Q?m5KH3GLhgzhkNqHj3wHwo42wtSJqir9LDMvpXI/0IlIHs2Wll/Sq4KypffW/?=
 =?us-ascii?Q?zYzVtxmYcyxH9VEL36S3jUgL1r1v2Lo72t3VQjTVcE02Lvtj9YGbPs20rhTl?=
 =?us-ascii?Q?gHir2J+sfFcYIwK0CkDrHxU8IiIcJf6cvQ5bc4RWkQF7h1I3KWfDAS2EwEeB?=
 =?us-ascii?Q?kuW+Bfc11IPPNuXys72dOlDmG07A51jCU24J69ZKr0i9Uf8NZpjup8LTKuXr?=
 =?us-ascii?Q?nZ5bN1fAjeAGsTrYO1DaIaIDyKbxlFOZsOPba5RfDM6XHmpiNMb6E6Zi+Ser?=
 =?us-ascii?Q?EDwf6VsMT02uMfXR0arxvKJzXqal1059MWLAyeGJTUL5MeJuLGOcO/J6u45n?=
 =?us-ascii?Q?D1gV3p1rjBAwpFWEeAUx8UAUt1KarZwsTGJ0pL9JiIMsicHFLeleM7AfqhBX?=
 =?us-ascii?Q?UwnyVkKhOAp/XqOI5wfU4wFiez2tp7m0EbDx8a+YS6ZlY4MsYmmkq2c3h/IE?=
 =?us-ascii?Q?bC2nxSzaR8uQhyOLAsyM3bw+zMvzOKtK7VlzwZ5gAVJKtkXsV49K1TiR70WX?=
 =?us-ascii?Q?SaIkJDLc8AOncOAqu2BPjMq2P9IT+2lNlovZHXrYtY6ZAS4dJLr1rDB212Fa?=
 =?us-ascii?Q?twanPD7eQ2ID82soyO6UnBgpD0JCbBQyExN0YvBREIvJ6FJQ/GLvgrOn0DzW?=
 =?us-ascii?Q?CCNtVdWzs9bs7L2JpMpd/7hoRFVraBtsbkCfvIIaCaZw0NLtWvofa/SpewEG?=
 =?us-ascii?Q?OTXhDk7QaTWlAkx4me9GWTSjfHqYiRRshYUv8KahMlrVHEZkxpgawNl7fAuX?=
 =?us-ascii?Q?5jEvw9Q31WOiDigr1op0MYo4lE6y3sWTz+L/iFNNPkzIVoF4kQlb+jyxZO0q?=
 =?us-ascii?Q?LYrjJyah1iVs9M9da/c7Jc+JMQEHQK3p5sDxdqVkHHH9IMjLgvZ/QspywbVr?=
 =?us-ascii?Q?Iw0iP7lmYuXDttYL79KmzsdfrdxtKjca/T6EVKVbcpf9E6SV9Tlze3t5bJBp?=
 =?us-ascii?Q?u8pRnZOIRp4Gh19v63CmP/mv5PRV2UxvCHIbx3wSZrGVnAxRz99B1KouCDGq?=
 =?us-ascii?Q?f6O6/fo2Wmta4juCtqafKetX79l7OE1Jf4viyhfQ2JGlN7QXKZYebp5k4795?=
 =?us-ascii?Q?XW/Xd3fB4UD9mNCG+Z3J/lDWK9AtT+vyzVIfoIIQrg9hSS9f+etwKiFFmG1L?=
 =?us-ascii?Q?YSRvZrsvxoCt/p28nS7K6TJG6iTMKlw/9e7DfadRB3H24iQeC/AxUhlxlpVS?=
 =?us-ascii?Q?rGxt4loPcAsdzWGfti/8rv3Ry42QdTZKYLYaYbKOIJ9oTyxsk0Wu3IeM/MUv?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: B6Cfe3Oj1q9IH5p/KUo1sq7huI5UxGgZfBUHVntCshwPSrueWexcC+vLF1SjGJnuUN3s7NIjeP0gN02Ge3Wb28WT8anvsRj61YkMw1gxblA+V9+yo2FLo7Cr+K+YkU2ZxD8mZocX6TMksdXcSMywu6zgLx5j3cbPRgtx2UmpKG538ek1/+wXJXkJlB8fj9ZB2+054NAavk3F2XVKQlDAh/iXwak1n0d55uiulBgxwcBdqJ/R7z/FasLFKIW1MIbsS45pcK2RepGwkFMY+oPnFfPrjIBkt7NwjALCG4WvugUnM4n2brDtB3Xkcp9RvsuTVakxUssSZNBGsCRalol42sZAPUSdBm22xDO3Dh1ih5MAhQn4cNhFlVZ0XrljRKLSSZQ2FOiF1htJL9v9bZljsg8sZsKihxQPGUXnrDsjc4aKg8B4KguVh7ZfAgY4W/ELYN9eRUyjjpGIF5pMCtQQ51pdXoyPd37vxqSBo/ChoGL3bHHUfsXUyuFmColTwKGlgdqn3UG+vJ2tpq0tRIwpy/4XwaJvPHuu9mQsGj42sXY8gW5v1TWSKozMWr/esOcSj6jPO617yWWcTSxnKKyaJXDvfEaAuIcu/eRVwXuYX+YxSHeDEfWAEeaeJfkrCmMsR6BbXgLmtuuNO4eN2xKThp7AE9TVhBZtj3vXU3dvTCh5xm60Db2NF1N28mzhgb4YfCHScQYc78e5eblh6UVw6+SXAMuNLkWQPPvAd+IsI6DY7oTOcxNteWb8y/jDoIVLJ7l03fSGd/3KXTRzpyAtInukYL55FGOg0sWkdowd29Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b5b157-223a-4991-aa29-08db6670b7de
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:30:51.2289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Pz2iZeKGcwUwDjmcvUq7qJfBfchk+HxKYUG0umtzFFYVBCjzgdsAg84yGg+mjY1/q354wYPWXJGlj3MBJwkPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: WLL23C267RbPt17tT04rTJtAczK3hU5r
X-Proofpoint-GUID: WLL23C267RbPt17tT04rTJtAczK3hU5r
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will need to perform the device size verification on an
external log device. In preparation for this, this commit extracts the
relevant portions into a new function. No functional changes have been
introduced.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 43 +++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index b34eda2c..c395ae90 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -85,6 +85,30 @@ open_device(
 	return fd;
 }
 
+static void
+verify_device_size(
+	int		dev_fd,
+	bool		is_file,
+	xfs_rfsblock_t	nr_blocks,
+	uint32_t	blocksize)
+{
+	if (is_file) {
+		/* ensure regular files are correctly sized */
+		if (ftruncate(dev_fd, nr_blocks * blocksize))
+			fatal("cannot set filesystem image size: %s\n",
+				strerror(errno));
+	} else {
+		/* ensure device is sufficiently large enough */
+		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
+		off64_t		off;
+
+		off = nr_blocks * blocksize - sizeof(lb);
+		if (pwrite(dev_fd, lb, sizeof(lb), off) < 0)
+			fatal("failed to write last block, is target too "
+				"small? (error: %s)\n", strerror(errno));
+	}
+}
+
 static void
 read_header_v1(
 	void			*header,
@@ -179,23 +203,8 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	if (is_target_file)  {
-		/* ensure regular files are correctly sized */
-
-		if (ftruncate(ddev_fd, sb.sb_dblocks * sb.sb_blocksize))
-			fatal("cannot set filesystem image size: %s\n",
-				strerror(errno));
-	} else  {
-		/* ensure device is sufficiently large enough */
-
-		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
-		off64_t		off;
-
-		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-		if (pwrite(ddev_fd, lb, sizeof(lb), off) < 0)
-			fatal("failed to write last block, is target too "
-				"small? (error: %s)\n", strerror(errno));
-	}
+	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
+			sb.sb_blocksize);
 
 	bytes_read = 0;
 
-- 
2.39.1

