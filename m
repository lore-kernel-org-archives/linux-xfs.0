Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1E1C3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiJXEy2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiJXEy0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:54:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC1BFD2D
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:54:25 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2dpeM027181;
        Mon, 24 Oct 2022 04:54:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ums/eVk+52RVJF7hROVHww0l40QGIjcSm0R27e761PM=;
 b=xW2320Aq5aBq1vCDeHSLwMdlPpdcHcV8QkgpgsQocP+E0LNEaPlE3f2fr2n38vaq4eoK
 HhS96TKONNOFBqILWpbwP7CPFS/0FvBVKJUZYZtIBxcCwcGL4HQI5YDR8zKucE5EBkUC
 DdYAEyqeaQavtJVOkAx3eTxE3sfO3NKH2j2IqvJWff2gmMvYLqeEW0KUZwjVNBh+z3hp
 gtxvHwEWDZT5Pvg+idB0GvRE/a/iD41nFlbUPm+89ftKIWIlrqWA7cg75EAfvGVu/n1g
 y6r9by6EuuBjPI3y3d3Vzhr//QRyQpJCwWqCjyUHi3Irq54xg4GI3XzCI2Eb+hA3lcQn gg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741jw5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O4ANUk030622;
        Mon, 24 Oct 2022 04:54:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3bmuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVx4Qf4VRTRm1DWfqVejOaQVMR3Yp+MXyxbZNbhE4HXIEOz/CHy/BS7e0fwFkSON32L4BIbuOwBP+DJ4llSy6+rJO03tNys0wFCzwOWl4N1ibs08yS4j0QW3foKubkhXRDBaQ0of5nQKRYIfYxdT6QG19jQ1mYCG8+WaF/XBiULXKeOVSmgoE39hv08fcJqhkrn6bDqBxNhkYgDHsewHBMFQs73wqlzgy4CE+1SPOekOWIfMaHFvJufOeuhLtffV27d+GnVrDq+li79pfnWltCo6poYPxOJOnIDv3/5BbZ7Soq15iDSoy6vPWsevOZ7mYC3OSBcwNrfCU/V4zS9XoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ums/eVk+52RVJF7hROVHww0l40QGIjcSm0R27e761PM=;
 b=oe+YaJDx0OP3UVf2HXUh5DLAqGcuhRs4+rGQNiPyS9flaJSl7oPJrOyjqbHoSki43JPEeacoKz8VVTz0i3uWG49KlePkhEOJ3b+H3DqHUQND9aEyUogwFhucxsCwKqUtdp43Xmo/uwaf70azFOZNUK9s3rn+lAOMrvDYzfqzW0B27zpi8DlynanD0tVnwt28x27sbLGWwD8OBIp5Ki8YxZ1NxkgHeaqXpY+c8N4BirQi2tWFFSB0PsDGXJ8keM+CmH6nCaOEHalL3yYxkB9YmDS2zxLy0wKvpJh9xGAIdzfwEAz+wmO5RkoHKoNGXaK97rF5BsAnEu705zMPmVonGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ums/eVk+52RVJF7hROVHww0l40QGIjcSm0R27e761PM=;
 b=TJKpOCcgMopf0qyLCILGGM1lm1QK07Ae6c/X4S545jmHo9VmIb4Q0BBfrvF3Jof+T+AUzl0c3FlQerlFb1YMzJ/kTU28AvNoyD0sIYpvdaZ7YoPI1nTL0IQ+cOAL+sqHflOo37DqcelaZQxLydNtb/uYOUJe6jHDvHPtvHMDVzo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:54:19 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:54:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 08/26] xfs: check owner of dir3 blocks
Date:   Mon, 24 Oct 2022 10:22:56 +0530
Message-Id: <20221024045314.110453-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:404:56::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: 181a2b3a-8981-474f-49ac-08dab57bcfac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWhytZZt+yNKiUeoRnMcjrW+rnTYW5YWj6J/HdROA7IufOHtLS016Uh7XYKvk83mQKCHNc0Z1brzIQ+fxRkF1ihDQfq6o06uiH6kK6DNdTmHEAxwB8+VTTWYOknbusYiypYa5pH5JJrQAYueImUa4eKqikxso571Et8SBtxoSIl+5SMqppOzXzbpJjgcCQaFlrYhl4YOh0eo5bQqMWs8UHhpv0bNw0sEMHVgFzALDI9FBwmb4NxNnCN08k2BD+hUKI6SWPO5rxXJFr/F40AkZ0wtIlu+6WIiYye9hACQDNRp0oaALe/EH7z1vfpxt3uYIIFTUNMoAZld+w0l1dLku2+Ny+qx0kli93sGAb6IrMPuN6sJgQ0wiNiiTKoafibmJQOMWxs2WDHpzT5nKFYdiVV1M1uzssEpajBIE+LTBtuodGyywqH5qSg9zWz+kZp0D5LONBEouYpiiSrKumw55th7WcnXCMCfALt4KF0ceIkt0Ie/Z6Pr2a5/uz0bqXMdEjY3m0mAJhpDHtFDIlveoaU2KQ4tihDntQchFdNmxYDhGH5xx9eqooBqMoZIuM1134kro1rNwOiec3KrOQFL/t7DwqRwhUOXU4rBZO3GF7p7oJultxUy4JN6eGWWp73Jofclz+PllKNUnJAlD6LlPV4cEBZsXBxidJLv4LYMTdBenzkrooJJH/k8r6U4GbYkRWDvRSQa+LGIhFxrqGf8Sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GtIm1GkwXy8lNcNkmKS8VcfJFn56v9JNig7eN6tNKlvO/DY0zAL7ctzmUylV?=
 =?us-ascii?Q?svLVzy9n8QhZOxckrn71ddtPrkXu98OiXOC0+unnu8iD+PLn7V/8EGWlB4M6?=
 =?us-ascii?Q?s3jHjbjWFIbr+u9pfQxj6jts1a3Ma86vi67UQjehnS/+rWCNYJHZT+yBeF0V?=
 =?us-ascii?Q?JWV+iS+ySml4DUsXl4FAEhBFuUkbBm7CVyGj7O1Q+Nri1twUBT6NA5w6uHnS?=
 =?us-ascii?Q?AjX2UUAD2R1luPFGX1VA6ICplLin75vmxT3snxXDBL1XGNB4wZ4ddYT1om29?=
 =?us-ascii?Q?OzCKOjKASa1M2jILnY9Pg1/moNkIldQOJmcho7pBb5ZCU7RemHCRl9ujTbYX?=
 =?us-ascii?Q?pa4pwhv0gtR7wdJV6EChuTrnpTm5n/hLfeFjJDW3alIAQwmN7SNFZlmVtziH?=
 =?us-ascii?Q?oGrlZFtBod05SA3oLffU/4lmje9zjbp0n72Ev2AM+ri8qu8kvPQbapmnIc/A?=
 =?us-ascii?Q?OrBNjFRyZWkIgGf3cRevoNnxxPkm9ULpGzDVnMwin2wIr5CuZS66bN+9aA2A?=
 =?us-ascii?Q?/6tTdnx5BRiqZpTMfrkhYAcb5dMf5Sow/qYW2PW9n4uVPdOsvnjCeF/XgO0Z?=
 =?us-ascii?Q?Bnjovov/ouv2gMpvpKTkdngGN5DKchTWblLFo3nLeinuQqHZoemurY0ss/ps?=
 =?us-ascii?Q?G5sk50h4PO5dRWP8WmPbF92HPpeqNwZZ/7lwYWS9iuLCJw36UkdmFryjuL/h?=
 =?us-ascii?Q?xmilWSttKXUf6Gi5fp3Td84V5rHudC/VQoYAhbkKkJl1ehOJWngNXMgIMise?=
 =?us-ascii?Q?UANbs48fEHaqj2bsvrFC1AZhrbW9ZExv2Xf6bAqj0z4OPr2L/IUrlFVB7vWc?=
 =?us-ascii?Q?lrbezehNbtRNHZqrwS2CznfJLDiC8E7ovAs0IlaFO1xRJ240psU5nloQ5SoE?=
 =?us-ascii?Q?PHgOj43NeiNR1RncAYeQs55HiQ+GpMLtirS13CQ7QDS2Dy+2kBreDntag/O0?=
 =?us-ascii?Q?LDGb+K+oWH552PnC/67vxXo2JjvBuEbEPP+wRXLuX4Fric1ojs4qV729aY1M?=
 =?us-ascii?Q?65emY2j3hW3W/cJvCpnmvd4EcvYzrGlYOZCa3vtuGWm+vbxoRWwQonWosbRx?=
 =?us-ascii?Q?nIkbideHpORmud4jxy4AaT5eHNyGb9O8sxZdmgRSq8vPx5+UkC//ZiFYwOdQ?=
 =?us-ascii?Q?w7UZTGBE9p/9xr65Mbbbnb82J4F1jBLlLwdspOrQw4xmzJ3VSlf4otmjjp/D?=
 =?us-ascii?Q?mmhtyLPGnCBMRoCgKdoLif9scilrXZD5QMQc/WtKtWYfZvclSW19Gs9JEWiK?=
 =?us-ascii?Q?7k99agODtJkCWw0qqOeAvQoCf+mAkiy3n8Q/UrRMUkJnf/YFzC93sTXv8Puf?=
 =?us-ascii?Q?L8qYXESYMNhzvXQR5VuINBFUb6PfS9naEmN/MkQRRK9Pi5/E78pPmmXuXp2q?=
 =?us-ascii?Q?sI0xAa/a0w7BJXJcLQPuPI/iJJMDZ3uBqG6ZXAmJXx6CvxGFYXEPdYwTVYQ6?=
 =?us-ascii?Q?MAyTOvbKSUTulA7+R8Kn1h3UWMowizSRVR1K4ZGCXGI9zXcd5GuLWZxLGIc1?=
 =?us-ascii?Q?mrYpIAlBslv/iGLXHu7W/h4gh4zogwo6TcSwZcsAidHfasXUuZj5GJbslILk?=
 =?us-ascii?Q?V/XkpladknhkvLjFN72PaLbklrCj10+6h3kpbQjvSv6KpkLXh3AkJyCbe/Jt?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181a2b3a-8981-474f-49ac-08dab57bcfac
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:54:19.8313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Srvv5GbjdekpR77xsSPFmKN/DXhiQbaYel3SfEvSKi/S08juLV4nKMKSJv1dvhwe2/u/iKulcBF5fmKr+IE8Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: kH6o9v0pAmYg6Tvg0-R9NiD97rpHEDlk
X-Proofpoint-ORIG-GUID: kH6o9v0pAmYg6Tvg0-R9NiD97rpHEDlk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1b2c1a63b678d63e9c98314d44413f5af79c9c80 upstream.

Check the owner field of dir3 block headers.  If it's corrupt, release
the buffer and return EFSCORRUPTED.  All callers handle this properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_block.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 49e4bc39e7bb..d034d661957c 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -114,6 +114,23 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
 	.verify_struct = xfs_dir3_block_verify,
 };
 
+static xfs_failaddr_t
+xfs_dir3_block_header_check(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
+
+		if (be64_to_cpu(hdr3->owner) != dp->i_ino)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 int
 xfs_dir3_block_read(
 	struct xfs_trans	*tp,
@@ -121,12 +138,24 @@ xfs_dir3_block_read(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
 				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
-	if (!err && tp && *bpp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
+	if (err || !*bpp)
+		return err;
+
+	/* Check things that we can't do in the verifier. */
+	fa = xfs_dir3_block_header_check(dp, *bpp);
+	if (fa) {
+		__xfs_buf_mark_corrupt(*bpp, fa);
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		return -EFSCORRUPTED;
+	}
+
+	xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
 	return err;
 }
 
-- 
2.35.1

