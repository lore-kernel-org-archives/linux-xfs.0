Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB548C54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiITMtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiITMtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:49:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDA06AA3E
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:49:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KA7pEC024487;
        Tue, 20 Sep 2022 12:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ZdfE5jLuCOFEyeEFVAnt1RSUROri6hWGWFNj56rDJ20=;
 b=ud8NeILq60+X7T1nfyTFj9bjFH7CwihO3UGsn/LfEgFEkp/aiJ3ktLNjgDjEC3Lf6dLN
 w2DpwrBaWHQsVve70PP6LOxw9H0sCN/BzK2t7P/EPSviBG0JmQSnQUfBziWldfIa5YSo
 eTkgmHwKWV4z7gSKV1EPFcdjGRtvavf3WudSDpESj/I4tvoKhsTtswcJQ9VDLQ4+VVBK
 gZ4t1pwCsARzEheXQX03XchzPl7WVqCAw3JiPHf7IFndzvYL2KtQGHUymIcFkRDCAy0H
 qN4STeNt6ybsbUwBbroiJBflXjjtXTtoKgOw/xdkfZRFZ+4p/VKJ4p18D3vz2U+TFt4e aQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stexe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:48:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KCkSGw025547;
        Tue, 20 Sep 2022 12:48:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39drhgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:48:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCpllrEb/ph/1YTtrxaWSY7z7tEYtrGs65vWbqbDw1wJQUtRF2mYFoi/pkcNFSAuDOLOSlRhPEgav1zS5Rwabaelo5iwpGZIyFOB9l7hp3lGBjC7dYmgO3/9yN89L456vgzgoAQASaMHIPG45SuCekt7Fbgy2HL/JlFhOUhp7GGTAHZ6l6tJFkk6nKE4mewGByRSdqmoZXFcwg32q+U62Eu854z8WRX1X7DgCXCgOzeToFTZy0+wsaVTLERjQTkJnjW77QbDz7dVp7FFlRRmEwHdWJ1BL6XQ5TTxFMCZ5m2VQE7FFxHFepQXG5WAaHCTDLMpHvwZSW8SJs/fPHIbnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdfE5jLuCOFEyeEFVAnt1RSUROri6hWGWFNj56rDJ20=;
 b=II0x0Raan6iZLjS0jGiPlL9rWaz2bHyUKYQfJ4iFVQLoCofAVmNZp7/i0u1FmODHHYl+S3pAk8VPWklckRG/dvBj20TKMWK6yAnKa0HzQFPnchxMg3kQPBy4UHPFtLhp3sp7SgYHBkl+0a3nz6uiJfktkU2GjodNfJPNe6qdw8iiSF2Xj+V8PS7oHW8zmTVqmTNNKtr0jqXIMV5fV/DvbNuIb2G4xnGA51Iwap0klKUvaRyu5EZAF24TNhShzWGIoqgAsFxIVxEvbZoLWpZtr0kDpegbky5bvQqaaBCvT94ZSA7iKntmZZlZKIDuycC5RmNjG7lz9jEYEKidcPv1GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdfE5jLuCOFEyeEFVAnt1RSUROri6hWGWFNj56rDJ20=;
 b=jBkLuRwwpj+vBfPLhAXPQK0nCGiUEkbvTLJ9k0UYfeICRhSekR4SVwUsGhB0C76LNac248Vo5oA6j2DSMXelkUZB3c6vZRGWFm5Vqhk/B7wh059NQ7NYAp/8QiCCCUlGTKcV5GQ0/5n3NRjwf4YzC95xLhHjqojyZmj5gGbI1+A=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 12:48:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:48:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 02/17] iomap: iomap that extends beyond EOF should be marked dirty
Date:   Tue, 20 Sep 2022 18:18:21 +0530
Message-Id: <20220920124836.1914918-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: c864b81b-afea-4936-a8c7-08da9b067ab2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JnOhDXUauZ1KjPXjjBqydVsfayQhgadeHSOQZePivRtMjW7o5swFcvi7RoDsTXCzLxjLOYPPexmZ8cXi+pLip1SdEJTO7zZYisHKSzosm+oQprPVk+qfuDhPEVq/dLB0E7Fm8Tp2LAj/ql1BmBoG5FKxmm04Y2ogcZDALpFpTPEYW5CfccXvySSIG8970FTy9xmsEEISmCuRyiD3vgpUA2alCB4vihuRYqTykfxnzEZeVFh0cMfKBVj2CvukLnyT2l2UDBVzOJOtof0UbCcXEXKgy30tRTGw+K1/hrQHECTOZa3yKxwBjNMdW6NSOeXyjGza8P8IbbmJgpl2NPrOAHeF5MEk4OEaJtF2Spdv3JkkhzWxAl0Vw/Jvb6Qe110DoDVp25ywpJg/5mzRdLuyH3ueZd91AncXxG07YCpR4cJB5c91P3OcUxgTxEQLiQxG8N9dMtkZmj79ltodkVpSq32T41FfM/e/cOp/EUrfaxMGKEWs6wyr1GPVjrYjE60hX11Hy4pS9deEiDZ84x+vCGQqdDUIgl6MS3uNWY3mSmKqyfkHAzRuux3Yrn6+ORY4BWVPdp/OIHseWqzUYB+7cXfZGpWPjtEkOMtiudmDXv4N4GqLXDmi6795nmelTdbmdlCMTGA+eTi3Ag+lOxjz1xPpRgeNp38arNO6U8U0ODu6+DuxFrk2sZqBKsfHhhxe15Ak3/ecg0ucmNSb18kKh0HqEs2w6DAQCwkmB8yTmQm3Oc1l50hnObMNfpU8RrLT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(66476007)(66556008)(66946007)(5660300002)(4326008)(86362001)(8936002)(6916009)(316002)(38100700002)(8676002)(83380400001)(41300700001)(6666004)(6506007)(6486002)(2616005)(478600001)(186003)(1076003)(6512007)(26005)(36756003)(2906002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1RSdncBzuUBebC6eNxqoPsYVeQpOKaTWLSh01Dglxp0f4kHFMp3ZF4xRkuHx?=
 =?us-ascii?Q?H3bCRZ6Xk8tV5wFD2Btz3Ld2LGtelhEYuRceX+qvaaUouDwin8Z7BpwxRNKP?=
 =?us-ascii?Q?MSJ+kq2b3zMPMnIg/DM1sDZJAYC+8sRdW6f6e3uQUcV9BThOdqGW9TCS6sma?=
 =?us-ascii?Q?0+rsQANzwFIIDJrzm8i23ObVdOMCBc8awoCt330eL7q3usgfmXnBAlt6/MY9?=
 =?us-ascii?Q?Qt/vx3XI5+dRr4Z7L2zgijvtM831CcZtEsEZwTHYWThIuU1oKNsHhyZT+UUr?=
 =?us-ascii?Q?X79KyrVBAKqE57db3cqRlqJwL5/oLrDDJZGD/rZStzlENWcvxxxU1DjZovIW?=
 =?us-ascii?Q?s9I+SoighIc3XDPS3ZK9ILtwDk6yK3vMYxOpEQhxddFMJbUQxGz8vH3caRzz?=
 =?us-ascii?Q?3LuEPm4p29/OND6kspewW+VMnm1KjzwGBeTdrI3zvBn+hz1VHEtmM5pt81Jz?=
 =?us-ascii?Q?k42hSLyxku11hemXr3R+bCDUUKRk09Mqh3xtg73wI/fboJOLGpzio8GpyJeE?=
 =?us-ascii?Q?iPMmSxC3Khz3eqL7o6Gj/QuSuLnNYTA+NpwFkJJy+lRFd0JVO5SSc15/e5wM?=
 =?us-ascii?Q?2YSjeM37/4CtrW3oyR4oQeA6HqQm6C8abAAkTa1h6toh+XOzJbdQqqyRT81e?=
 =?us-ascii?Q?aGLMw6bcaBTZRegh1TIbeIprL3RhyevcJvPI4TJX1z+D+/g/1wDJmX0XLe2n?=
 =?us-ascii?Q?sdSF4/VmJkSaEK1KLJXQQB/CiCNEtwB54+/a/B4fDo3q81tDB5ow8ylA9mWS?=
 =?us-ascii?Q?C4ChEaX3sKssmw4U00kvhToq+049A4uR+0R7DrfM0Surreica1tWNN6uhp8G?=
 =?us-ascii?Q?gooUrqfZuDy54c1vc4X2n/P5RwyuaWSfsFurnU6Gdso0sg5mwmtF/NwGXRoT?=
 =?us-ascii?Q?yHxh1EwmyNB4DYrsIj+2QSgzFoVlPc0zY5xL8VvQcNbc5/nhf9JtecSnmjq7?=
 =?us-ascii?Q?0ormqF7jKEADsoaxh47MosTfM2XkweRdXdYj3Mg9uNGf/eCvgpDVcIrvFfo4?=
 =?us-ascii?Q?tF8SaG9hBpa8I1wWEfz7thvfMgLs5aGnofqq24MWXS2HysTonGMAtbDtomGc?=
 =?us-ascii?Q?+udHjMIpz2Z+rQzxCTI1QXVJtk3mnFpswI3Y8cv1yngHuRgWWYRoP5cy0pVL?=
 =?us-ascii?Q?4kh3sdP+hpLKLQ4ssu6wyXTqs14wMaxxS0F3pao5To9GDIge2+3+e+urQW+C?=
 =?us-ascii?Q?KVdLLWiyfvNkVHbfP+V/fIcuzBRBYNWf3Krf+NoNGP84P/ZShkui6rZLYtts?=
 =?us-ascii?Q?mXSadNz5bB5Ka9iZMZXkkthOJ17sXptWdLOssnvkb4cp0BGF0ZH77KGSo5Th?=
 =?us-ascii?Q?ob0HxnX9e1Vv+mz8hrmA47GDIJQI8Mz2W/c+gPfUWCnuqDrzyfwPbUr+JNTC?=
 =?us-ascii?Q?f7WQBhBbWlJiF2g6lqk0BRr51wrWYiYP4zP4FNxzCcFfFjOgEsJw9N67EpJa?=
 =?us-ascii?Q?hrfSvUOubYCzOS+AVZ+waN6NC1y+UMrDDOYBxKptEcrV2vNIA92F2G5QHhZf?=
 =?us-ascii?Q?Vuw6a0LmsfwP1oKanhChCmmWeqRbGV3rafW2VkUhvt65L+026e4VhSDuULwc?=
 =?us-ascii?Q?Bwe3hb+iYVrYETwjlxnu42BQ4OzOzPRa5e7kDST5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c864b81b-afea-4936-a8c7-08da9b067ab2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:48:55.9796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0N8FgH3rhcoRSqTYLiK4y698JODVbWdy6OGpUpo5s/3xKwxV4cgTv+l8hB/v53T1UXF9dRSGIty8Dm6QzHZeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-GUID: WHomd4SZpTI9HpvO8RLslfVVLb5HbMXv
X-Proofpoint-ORIG-GUID: WHomd4SZpTI9HpvO8RLslfVVLb5HbMXv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 7684e2c4384d5d1f884b01ab8bff2369e4db0bff upstream.

When doing a direct IO that spans the current EOF, and there are
written blocks beyond EOF that extend beyond the current write, the
only metadata update that needs to be done is a file size extension.

However, we don't mark such iomaps as IOMAP_F_DIRTY to indicate that
there is IO completion metadata updates required, and hence we may
fail to correctly sync file size extensions made in IO completion
when O_DSYNC writes are being used and the hardware supports FUA.

Hence when setting IOMAP_F_DIRTY, we need to also take into account
whether the iomap spans the current EOF. If it does, then we need to
mark it dirty so that IO completion will call generic_write_sync()
to flush the inode size update to stable storage correctly.

Fixes: 3460cac1ca76 ("iomap: Use FUA for pure data O_DSYNC DIO writes")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: removed the ext4 part; they'll handle it separately]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iomap.c    | 7 +++++++
 include/linux/iomap.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 239c9548b156..26cf811f3d96 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1055,6 +1055,13 @@ xfs_file_iomap_begin(
 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
 
 out_finish:
+	/*
+	 * Writes that span EOF might trigger an IO size update on completion,
+	 * so consider them to be dirty for the purposes of O_DSYNC even if
+	 * there is no other metadata changes pending or have been made here.
+	 */
+	if ((flags & IOMAP_WRITE) && offset + length > i_size_read(inode))
+		iomap->flags |= IOMAP_F_DIRTY;
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
 
 out_found:
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 53b16f104081..74e05e7b67f5 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -32,6 +32,8 @@ struct vm_fault;
  *
  * IOMAP_F_DIRTY indicates the inode has uncommitted metadata needed to access
  * written data and requires fdatasync to commit them to persistent storage.
+ * This needs to take into account metadata changes that *may* be made at IO
+ * completion, such as file size updates from direct IO.
  */
 #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
 #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
-- 
2.35.1

