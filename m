Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA793C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357626AbiDFJkl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586526AbiDFJhK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:37:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A131188577
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2366KMjW000752;
        Wed, 6 Apr 2022 06:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8Iq1Uzxrhw8eWik8AVUtpc0zidQu4/cR1JvmwxGlCFY=;
 b=B0RcZBGAvhX5K8QBAcegOCLzs+Kdtcsx5TLU40KcxbtI65zVOPkArsNBDt5SZ02W4TBp
 Rc4JVgqmJorjH1IBISyaI0Pxv0AD5mBNwwUZPz/RPCVaTIMrLh9lKFuSx04+HYfptVDa
 aS99gItNTvw7okfi0YJ6xoBuSxVXccGQNcDV8ui1WXq9kF+ICDBlDffcr1QK9UopHwg/
 CCRX3VmpRIrAa1BtJ7zuzivbCt1A4zj5QvZyQxX9DU5ZuYns3E38jAUeWHBgmyzEofPA
 sjRrf0klomOHFylFZVT30pG+HSZ9a8BQLFjUznKO4v2CLiGt3b5V6BUn5mYRCmohC4XM yA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3squyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366Bk6C025922;
        Wed, 6 Apr 2022 06:20:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx4cv1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cT6Ru1ooF+hQPrliEATfRajGMW5Cl5rHyFhw0s8pjQFgt0ZkDeQCwy0dw4zeLw6xQy9AQKfPn7+733N9JKsq0L88wd5oxyWvDFmoZsz6BYTc5CitWCPrmCTDPeQDby3qhyPxzyLPoFyFJNbZmGYr+YYZun0seAkL+aprh1osAzwxv8gIyRBcZnHIBC/G+TL/5QV/xsOsDIZsRfYP2N1yNZmkepr/lFBYb0g4cxlFL+pK3Fnxf84ZFBLtekh8UfGGc4dbU9E7ODFbOOYYc/G9HxuWwhx0YlkMsptMDzvz0t4RUOCSjFtY4PgoXMR4Ug6rLOV2VvGLJ/GpLp402SMlfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Iq1Uzxrhw8eWik8AVUtpc0zidQu4/cR1JvmwxGlCFY=;
 b=oCSXKaer54ZGbNI+f10FOy9OJqYqxe3Gy2gcU/ZltFXRqpkQn9IkB+gAlKGARRKZXyRkYurri/vw6QBy5EnEwvmJnUy3cEVD/kIBZw+R2m8fTfm1hzJ0WrClyDTmq9tvoTC7N6DCyJAazS3pKMKb2VG+v2VelbqeMTTof9GQsUdyDpygXfeaz87d1zxWb6PaSeZH3MOOhuElx1ZZFHgNHXPq1vtcWw1B/HJUx1n4mPHocjteBRqolQxDbJDK1J6hdUDnRhETX2sOkCHH8Cnqh2eARv5Yxyonf8aaA+hBc5TLUlsGX65a9y0oG8VbP9CgfFzxjFYo+PeGrGIqR50tVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Iq1Uzxrhw8eWik8AVUtpc0zidQu4/cR1JvmwxGlCFY=;
 b=iiLTI/C8elPrQzx3PDGp12USASEwIJ4MMjz9Qe1+gE8d/GvEA0mTjDDPlSPyzkENhfEdIJWvWrEogiVHT9tuv38Fd0d7CCEKu8/BTx+DT995khCud25Q1XnwzbztP0QCQXNMcKEqWZQ7NYEMDCpEoYH3n3mFvkbclIMLt2fNMzY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5660.namprd10.prod.outlook.com (2603:10b6:510:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:45 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:45 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V9 19/19] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
Date:   Wed,  6 Apr 2022 11:49:03 +0530
Message-Id: <20220406061904.595597-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d84face7-b859-4fe9-9b30-08da179595ba
X-MS-TrafficTypeDiagnostic: PH0PR10MB5660:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB56605C3360F6F1F21B8EEDC3F6E79@PH0PR10MB5660.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Puh5vOaq6NV+2X23SpV0upmS84VWUYi4j74bqqSZdubRE8Q7DEDqoNcGG1RG4XnAvmVT0Y7rKZzEwPB//Fi8jxwUGL8d0hWma7LlkebZe8Rv4GoNmUOCk7MAsgCQtF2z6lEtq0KpcvBI70Nd4HTnzlHLBHzTMLffHCbZnPTvvX/E/xxW/tMAGEDj2q8GYssqMS0YqTFyjDz2k8mZ4TSNWlkCKUTpyG+lYBgX2C6Z/8/Bheeoo3KqIQlhSAyejUfUAqV7fv4i6oWNv5jX6z/jD9AyEtLBUZa6e+Nvh0yJ3k2Z3Wzzyc1zD5p+y+YXdwf3dDZwcfAzOwNQCkQBCmwEmCOVG2wdfFNNd8b8+6j6BI0tt0tNar3YxFY00RQWeUuATzOmKZtkGTaXywkYrnmeRP8rxETB074GVwxRdTE/qQFhB++mPkImMyMCdufPE4mA9TRM0o4jlhKrjeG7r126Egdb1mJac4kUuzZ0bTUuz6MHJbEw8IR/ti+6QBe3+pGBKMQMU+Ix1vmVCcnl2sue8fOpCn+suVTiJDs6Na8HYyrAX0VksRRPOzV1PINTX/i4S522rHaVZp6aArWfv0Xolt2WCHKDMu9iPWlSAUVw77NZ7TmMgsxbJT80m8ZoWdL8vnS6hohysl81IxI+e1y/rgKYvC7tDySqgm6/o5s7VvtTZ+bclQf0i1N4Tuug48fTVmuMPtQ2EcEfMuOYy5R66g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(8936002)(86362001)(508600001)(1076003)(36756003)(2616005)(6506007)(5660300002)(66556008)(2906002)(186003)(26005)(83380400001)(8676002)(38350700002)(6512007)(6666004)(316002)(66946007)(66476007)(4326008)(6916009)(52116002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6nLQmEHm30RFPZQUr7u/J+AVJAQWs/VBSTg79EKdG6ZOiP9FWyTDIRsZW8ox?=
 =?us-ascii?Q?QE+03Dp9WQfA078Bn8KVnF051vSdxqkPkUypzj9e51RM/+G+MPPaVRwgEAsI?=
 =?us-ascii?Q?5t24/gm8L+D8Cl5+8T/0EHTfg7Hn9Enw1JWIJcORXWKycqMuuC7UulxtDVuE?=
 =?us-ascii?Q?fnKLUEW8Yq78IKioHKw8YyOTXyFzaXyPF6mavp/fFckhVBPS0ufwPAiQpJYz?=
 =?us-ascii?Q?3psnSb8RajQjjnF2/27cKkYSU8gHC/K+ZkIpVADrrIVxYb1jesEFZylFeHsE?=
 =?us-ascii?Q?ebAAafanClq3pQILV5oGeVK9kNItYEea7SCFFKajlmIWbOLFjnLmY+BJ5/7W?=
 =?us-ascii?Q?SqjK7z+b8q4nneG/OPQNSXwrkdac+dHiXyzm2005DZXm4QRNIKlSePiiNw+K?=
 =?us-ascii?Q?kAuay+jNajM+Zp42yarp/G6JNSkSb/57MSkd+UeCbX2AM/HULPV8+WuMqii6?=
 =?us-ascii?Q?33TaG7kgsiEqyElDAkrml/XpnLnv8GII4E9lG/uwFDnnl6CwJ2Ka17l6eL5x?=
 =?us-ascii?Q?Vr369q/w8dS1h4ZVmOlTprTemRKBO2+dkMOvkPI4cLS4SRrVFBizGDTu10xb?=
 =?us-ascii?Q?Mb5br5Mloi6QCFe3S/OCNw5Foqd5n6nU+K3sI3z/Ls0OKoWC5z913GmjM23e?=
 =?us-ascii?Q?stkM3XPa20VZmKhbVAWhJnkx3vWN5B8Rnt4Eh1db/zWbcdAVUHUbNr+PfVa+?=
 =?us-ascii?Q?TkFBWpYpypzlk12eLHlKwSYsqlvahS2lU1ad+0HCszmsCm5otq/hkHSy+5o+?=
 =?us-ascii?Q?3KbPlD9Y11NmRjNeFBl5PtTCv/M255462feMU44VVjxMyGMQmNRSEbXsq4Gn?=
 =?us-ascii?Q?uJRQBI5VUKzxJToTncwSQy0xFSO6vrQoaTdhKRkOCPWZM24xDWFDFs2ue4FX?=
 =?us-ascii?Q?Yx9lmRjLAXjyVLDlBSUj74uhoDDM53GDBGyBQ0KzhcLfMO6Hxdkio7B+AKt6?=
 =?us-ascii?Q?CEWm8leJzLkBRWkwH5w6nLOiTx2rLsrib4nQBz2th1zqyNSXtbKz0FrVh7JV?=
 =?us-ascii?Q?6xtk5WbgVszeFObuqiUYfGq0/35v1wG8AeY8CG6FM9xCOlNuaKxK4Kg35AuN?=
 =?us-ascii?Q?NrzFHD/KNdF53vghqbkl3axUIh0XkSr8H2vQe6+OT6ppornqkk3CNTCRiHwZ?=
 =?us-ascii?Q?F0Tix8R2HrUwpQjCqDn+wPS9oqA17vUjr6vEDD/VvYIqh8ZVBv3OtdyT5nyD?=
 =?us-ascii?Q?W3ujVhvICJFTuNNOFKnd0i6986HI6lgX/iX6tQ9gXXKCsTdhl6vCMRh9F0cz?=
 =?us-ascii?Q?8hZbQapsk22KyrvVFzPrT/numHW8F0e8wZK1Unw5BfeuuOuUn9vRb1OigJ+K?=
 =?us-ascii?Q?1WE1aPhEh84LPlz9uU/1VFTKrPrJ2KAv+QeoicvsllxTV0Fx3SyMPYsPYIGN?=
 =?us-ascii?Q?1hQNcDojjsVop6GgKjI7m8uoqEAZ8Yavkv4+pD5UbNwM3sipBR6d9VMIoexX?=
 =?us-ascii?Q?/UmtKq1DkAAJAmp9H1dke3B4FGhR++RPQtg0LI/E/h+GnuMBNzXR+fxToPM6?=
 =?us-ascii?Q?BAG9YX8Jjbd//88uJ57Jo1E6f4IbHwElRnT5b6AaQCbH24WTdaESPujJUQCN?=
 =?us-ascii?Q?JtAf6QjOte4IkxdR1ZAbmLoWPmYNXKtNPiJgOeoFPEynwlaNWJDqUeR1mQF9?=
 =?us-ascii?Q?8C7O+EgD/8ZFrBt9zj+QsHWocSZUaxuVDEipkLNWfKRrro5JRM+d8W76Eu7p?=
 =?us-ascii?Q?Fr46s9kYxg0KkhEL9eDpyPLI3xv9SggCz19ZhkPrJFKk0tBIyRufpSIXfBN8?=
 =?us-ascii?Q?+rVZfFpsKrtUMimNLTVk2C5yIvFQmhY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d84face7-b859-4fe9-9b30-08da179595ba
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:45.7665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQuUb7KIHyv6nk3ZhI2/U7ZmbEye4QWc1CP7oUyERa09XN1fCgwSa/kKIjImfjwU5xurlYSed283NpYG16QkeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5660
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060027
X-Proofpoint-ORIG-GUID: gjWV8P8lEZ4NoYIiWE5J6GL9R2Q5JafQ
X-Proofpoint-GUID: gjWV8P8lEZ4NoYIiWE5J6GL9R2Q5JafQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables XFS module to work with fs instances having 64-bit
per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
list of supported incompat feature flags.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 fs/xfs/xfs_super.c         | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index bb327ea43ca1..b3f4a33b986c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -378,7 +378,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
-		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
+		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
+		 XFS_SB_FEAT_INCOMPAT_NREXT64)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 54be9d64093e..14591492c384 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1639,6 +1639,11 @@ xfs_fs_fill_super(
 		goto out_filestream_unmount;
 	}
 
+	if (xfs_has_large_extent_counts(mp)) {
+		xfs_warn(mp,
+	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
+	}
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.30.2

