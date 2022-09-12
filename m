Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8863ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiILN2z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiILN2y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:28:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3449230547
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:28:54 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEU1K030586;
        Mon, 12 Sep 2022 13:28:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Mk2pIGi2+vcPorKdA2UgyCRscHxZhEAr9ctKrxA0coc=;
 b=VtOKMYyURqfgI568Tt90uSEpS3vz5ThMSQNdL1IAEGPBZXG2bj1bTGQUo05CwopMGxRq
 bbOLHcO0pU7RC0BlEi7YUJcCIdRlz0A9J8JJ60mrG5yC/NOf0++Te69gD640W5ImqaGk
 yOoo+qKphJaOaapy3JOxiF6U1p5EkZkU/zchJ7bVhDMIm4Rbe7HaXMsoUgmBe8XJO3Qp
 2gVwd4WqX97gtRlC8Q0wKphF4vdG0GlHoVxXqGixLYrP9tC5t6K84Nbk64+ZE8pfYOV3
 a776IeS2AMVWIHACElwBJzv0+YCziQ9MqGZCwK1w3gfNMWLN5nbklZQ/MBahj3So4rD5 KA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jghc2kgud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:50 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgsC020404;
        Mon, 12 Sep 2022 13:28:49 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgj5b14ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCDBkDfVWH6yQQHaaYIMYFK/HPQ5IGoPCKbbNO18poaPFjv1yJN/Sg3rAeMIatortNU7IetnBww9O4TUfGQneZFeHovcctGsLbXEwftDd8ny2NFi1vW9vCKuUKcpQQfRLgHEKzrZsPNUVG40cNbTjos7xRnCLsg+GFs7S5oVt6O5kLiSTfLt09VLVwrIr4vdg2ycBmKPHNJadxJbhxV3GtddXf52k0ECnkR4lmJJbLnTncY159+8fWZGivCuhXos++SOPJmiDHDwGGN0RqZdG3b4orWxhkuiXGFlrhYoHEToLIAuk+PdekkPU+5kxmO3Fx6pGpTzvWlXZpn0wJf7kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mk2pIGi2+vcPorKdA2UgyCRscHxZhEAr9ctKrxA0coc=;
 b=jvgdnAnksoO7lvCEWY1Lly36c6VpW+69bz4S4dBDLHNeO9bNL8C3Vf4Eai5UIu+kEo2IiO2SK35JGT9uFWopNDBmcLsSM8hCYYiX+Fm4g+dGjPCthoJVRydR5h1XRQOSREmn9a7Q7aDkCBPWkx8uXf1BxSEVRYErSunm/Bzsu2SjmaEeJX95LJeYUQmsIePUn7ZUo7sXn7cNVqA1I1cimAt4bYgQMXf5SN8KjZo/wpwDFarMiRpWMNlV1H2YXPOBavjwbf4CPsboi2VSM0T57YuibjfaYLqVkwDbRWJCdnkLcfhN/bbXw5liZwL/b4nycphzPnRFULbQmUJYTbitEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mk2pIGi2+vcPorKdA2UgyCRscHxZhEAr9ctKrxA0coc=;
 b=BOhCEGUR9xBEjzBr6RNSUTm5HvTFzwg0YZEdSIAjELyaGSNHfZGdhW7UDvop66bew1IdXn+94zLSSWI4MJXA8DMg80u9j4V0as7YxbGnwTaqhJSiSxh4847BH5SlEyzOfn+zbf0EYYwLwKdUJRlbTimMMUW4fdh9rXBRsKr+DJw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5888.namprd10.prod.outlook.com (2603:10b6:806:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 13:28:48 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:28:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 08/18] xfs: attach dquots and reserve quota blocks during unwritten conversion
Date:   Mon, 12 Sep 2022 18:57:32 +0530
Message-Id: <20220912132742.1793276-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: 53670e12-98f4-443a-358d-08da94c2b91c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/h5FAJhnp92mnZU1zSkDbAFFnqtEYVx7eu4AmFfYc5UhiauGrQH7tUFItaKgAbUouJ4/11rpy/1MG7JBck79SxFmAXWTjPQy9fvMgoFUPqkH++fS7VzOzrAAM5WKrMSG8xmt/2TSe9vMWvJlEkpEgYdShS8GJVwhTEaFxM+sXWreLE9zLdW3/L26asnLfbT7w4UaGLVbWJBH5mr1Yahp117CoPTnTZ6zJn7UJvrkPyzJW/syssZL5BSz+8KwgzPejzNWeP2J/fm9bMkyjD40tIplM/6qHUvuurS/kd6KIGeAZB+s3TSnuPwwUHBW1/ZxzChb2whhG5FUP7yV2ffu4m9hbyE7LgOc99H2jA7UZrw8IVI86Rox93vcmjtLSYlk40fhC9BMe53i0lZGubawyYdducxmifGlj/d8P3XO8eRyew4yzMtvuZwhrvMJEDkojqn/hGWP30NslNAsZrlC9HjxMcB55Yaq+UyWZGGNbMD+BZ/nzSPlMjCmnvUoKfWZrHkvZDK5u0gpO8xwI1CYlTOr+XiN2q3tv+TF7/LyoAtRc5xGP01MWKVyEAYP2xcnIRZfNXS6WoH1dCSuM/KHQQoxOymB5gZup/OaEQ03kmBwJXaSLF/GUs9ytapCyIUxwHkqPhtCTWSeRZ3tjvjmSvqdmsiWu7+KyIh5WAvTLbfDCYDiXYAzdZRm5xcNB2wuUKpwR5JQv9HaWLN8DNvdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(136003)(39860400002)(6486002)(36756003)(316002)(6666004)(8936002)(6916009)(6506007)(83380400001)(478600001)(15650500001)(41300700001)(186003)(2906002)(1076003)(2616005)(38100700002)(66556008)(26005)(6512007)(66476007)(8676002)(4326008)(66946007)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WPeFAQaCaXDhVKSpSlgjU7n6YiZ9dfdyULIRTWG8sM0DahX0DNfS/BISlGS/?=
 =?us-ascii?Q?HOEafnQHV/70wL8rnPD8dRSIykwFyehAs+qeEs9azwhL+DNsk7eScnj9Y1ed?=
 =?us-ascii?Q?aGrVn6i5fisbbeuA4MsrGJcAk4n0J7SxbWC8uuPsxrHQn5hb9iEIJcVeivTj?=
 =?us-ascii?Q?tUBBiuhStzChsnUCRID8VhMzHkd8p6BIKzcKpNJIZXOBx3e9/gKju6phNNdi?=
 =?us-ascii?Q?OXep/VR6qgBEf8f0V5QUeKlD0K+paBIX6xb34jsEG2xu/bWROSPdAGBEQSle?=
 =?us-ascii?Q?yQZsUiAsKtRw9LxIKJIU5+faje44GuO3fpYqv8voC/CCbWJvEBbYiQzY0IXq?=
 =?us-ascii?Q?jvDHNwEeRTIK8Jk9Y8/gnc45FYHoqU6+qUdZZL5aHkqRMSpV+iZAaioy8SOs?=
 =?us-ascii?Q?PIbszZ5RvzWP95+QpW05KaUifN65WC+WluOMlRkYlTQZECJI1+e9YPFYIA2Z?=
 =?us-ascii?Q?kJ27Jcw/SaQqUutPU3ZGwuDl/bHjFHOjxFka8YizgvVQN9yiecA+FTmALe9i?=
 =?us-ascii?Q?lb4LZ4eDH67Shm1E8fg+Cl0i7edeOdK0gm5jzjGIaJvIN6EkFm+dNJWqr0Tm?=
 =?us-ascii?Q?hbb5KgJXrUrFonUdLalvh1hh8HvRRSIyLgnGGMJWw6D2Rhtf/XohjMfYj3+9?=
 =?us-ascii?Q?8dCTzJKgU8Od4PGjLOdIBOiLlYYObvczNVWNW3XMeMhB0Er6oP6ocSojKX3h?=
 =?us-ascii?Q?cGppE4U9nF5AUEKZpuqdRxAKmtSXsv3VBbQz+vSOme2vHZhAGAUqG4cGsmsY?=
 =?us-ascii?Q?B5Z5NFai+gIBaTdPySo5S7TGYD9bhzKgBtPlv/e2OVPCwjwXy1XCHVrgs/+J?=
 =?us-ascii?Q?TnDQXeHsq7qu44ctkEB1imAlKC6+Bzdo0Xlhyi6YPvjVVCa6Gt0VJLlhjFD2?=
 =?us-ascii?Q?0MFSJW0EV1sVRjwAsMxwPEuwSkWkiO9Kc7qP0P1M3OQEzFG+ASyS04rWHc+6?=
 =?us-ascii?Q?TIDA4uRO6L5wZHjpJJ4/4t8eU6SuPQzlRY8NZAGShRuZfpRLL9p6F96e4xy2?=
 =?us-ascii?Q?u4X7R08ns8SGSRSfVovtco2+qfuxcpmlpiMr64q4HVDbG2rGKOK8lvrhzWDn?=
 =?us-ascii?Q?qqnI/9i2G0lxyqcjw3//zOVrZgw+P7Uw/u9uAyHe6wwTPzFqy/rhc8Jt+iSF?=
 =?us-ascii?Q?IUsR54W8d4CX2k/a38+kEYeAmVE6NXhC9Jw96e6VgJbBKV7+rRXr5AwtBVAO?=
 =?us-ascii?Q?YhIDioZMtFbA8sO3O5FCdtwdb/nIL4tK/E1qIhAZKDgWbBYv99C2hnHXeBnq?=
 =?us-ascii?Q?aBIYwhVy0yfFn3LVsgefC/ZMY+Ztt4wtBJgmhYb0hAbUqfEe21GoQDnC5Qqi?=
 =?us-ascii?Q?Kf+AXjfHhWXBh3PXwXQ0teKgoPBkNlHErPGAkn8f92NwgmK6iqf3cle8L9O4?=
 =?us-ascii?Q?1CdG5q4rggJE09xgdeWruY3o529d7/4wCo0YEk+DWsMtd36zFDd9pU6EW2Gz?=
 =?us-ascii?Q?Cp4wUtJ/mDjo8pw4s5Sxf6KLYE4h9yZAZvj1yrXqLUNBOrg4B4+YKEfSiciW?=
 =?us-ascii?Q?lfV2LliWPVjAiFrv8M9+RD/JS8dBYcyYan6xcGGkFVKcPABnkivGJ3is/RUW?=
 =?us-ascii?Q?YRvaSw2LeE9ABlPZQr/rO1zFhNNDxQ+QFgqwWx9WlkDQ6XVpNz9A1eT0Vyyl?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53670e12-98f4-443a-358d-08da94c2b91c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:28:47.9527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IXlMGpSFmroyUNMuyU11T6gHA2i6oH1twxi3JjxY8meml2SyO6tJTFHgaQpDm/IJz8hPEjDv/gh4OLuz/lhHPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-ORIG-GUID: Zg-mIg4StWgJ3qxHj-2eZp3Np-5SNu96
X-Proofpoint-GUID: Zg-mIg4StWgJ3qxHj-2eZp3Np-5SNu96
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 2815a16d7ff6230a8e37928829d221bb075aa160 upstream.

In xfs_iomap_write_unwritten, we need to ensure that dquots are attached
to the inode and quota blocks reserved so that we capture in the quota
counters any blocks allocated to handle a bmbt split.  This can happen
on the first unwritten extent conversion to a preallocated sparse file
on a fresh mount.

This was found by running generic/311 with quotas enabled.  The bug
seems to have been introduced in "[XFS] rework iocore infrastructure,
remove some code and make it more" from ~2002?

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iomap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 26cf811f3d96..b6f85e488d5c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -765,6 +765,11 @@ xfs_iomap_write_unwritten(
 	 */
 	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 
+	/* Attach dquots so that bmbt splits are accounted correctly. */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
 	do {
 		/*
 		 * Set up a transaction to convert the range of extents
@@ -783,6 +788,11 @@ xfs_iomap_write_unwritten(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, 0);
 
+		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
+				XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto error_on_bmapi_transaction;
+
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-- 
2.35.1

