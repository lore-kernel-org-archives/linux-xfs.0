Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203E4C25B50
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjAXBgg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjAXBgf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BD11A498
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:30 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04hmD021665
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Z/gy7ED2uc3DAI5xAdPVy6QP4ZkCdVt2xfjOsudSWUw=;
 b=JqsBSkbmfTrvuBPdE9CvXwwpTN30aOXYysl755TMAV+pLqn2iXumnu/IrtHah4jB70U/
 a/sEZSCbvkcrvKSSxHrRVDM4XZK4gkWRq5uoZx8gGmd8OoDdmEXR6ozeZC9icoTjPGTn
 x5bBVS7nGLMviqO6X7Sxl3NdglgnA5ZwMp3dEBlEEOHxoA4pbZFdfvRkyi37tUp4kTyO
 Yv6r/MqnP7cIEFpu2MHbJoDF1oEV+7xnqfFzJ2lgtURw/QwG3vJlX80jcDYzyzWb9Rxm
 aKSWXYyZmZioOrQmYad86cwOjLDmoOqlnNOqdpWKnqNNVfb5GOhj2JqcXlYEgg7cKvhq qA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa4a15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNDwKj001236
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gakvem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4AoWZm2dFoPvUbYlP1rlhK9YKIrf0wQCXsQ4Pm2FhvAMtoH/JMMea5UV/2Tq8g1NusZNu+eTY8rkwsPrHrvkm7THxusnT57tU9ReyKYYtAs8ZWqwpEmWXoJQKB/hJ3/2CfawJeijT8G1zyhI607rehuq4IxiAHTY8CjHewNvIUzwZ+s4AMBolVzt4yCXmPhMxAVVZGTTKjgk0FzIEbPwIiBSljnBS88uyxuBL8D0JfzzBaAmbAx3EJiSv+yCNRE5lrQ3S2Uj2KzrxPml73sbTlCMRd8Q1bLtUwQ2IrSnmd9i2wvMTrAGn/zhOd2BQX3J3kX9FGc0iQhc47eUeK69Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/gy7ED2uc3DAI5xAdPVy6QP4ZkCdVt2xfjOsudSWUw=;
 b=i+GRj5vvlrJLwTO5/AMUfyNppbMfEHsvLBTdW/mTItAgT/umd3TEE9D5Fi01PUwlMUb9+VZOKG9WYwcQy/sLy8LwE4qFNEB8WwZ6QlHb7H4pdYthZMRhS/zPube5PpH06LHiUuWPKsYy00YbInJphD5agE/wjbFWhnSvJN+H0WOrMmEG/yj7kky0S6SFmtK4xPOxpn7wIUlF3YMPqmrAoaGJ3JYBVh8nffaTAyrkM1/8tnuc81Jxs+C/lYOC0itedkDXxur4No8THpuY4/T/x9vfufOyW680OlBi0wFTkxJEsrkVuuuTfe0DBtHlsjhfdXmAObgDqxfbbExNH69VKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/gy7ED2uc3DAI5xAdPVy6QP4ZkCdVt2xfjOsudSWUw=;
 b=noJRZZlMpmBejF9uJqdECucYwN4DQutdVExp8lOGQE3z6AYkTm7hiykTtnnedTzk+O36h+Tq/wsOAfC6Fll6Sk1y7mMbFezG/DoHQIPcxqi+HrdPtj9VeIzrcXyP3Le1vXAyw/roGkxZZecx+9NRiwk7MxA11ziD5sp422+HgRE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH0PR10MB5052.namprd10.prod.outlook.com (2603:10b6:610:de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.16; Tue, 24 Jan
 2023 01:36:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:27 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 03/27] xfs: Increase XFS_QM_TRANS_MAXDQS to 5
Date:   Mon, 23 Jan 2023 18:35:56 -0700
Message-Id: <20230124013620.1089319-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0103.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CH0PR10MB5052:EE_
X-MS-Office365-Filtering-Correlation-Id: a0fe42f9-7890-4d51-bff5-08dafdab68d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F1+/PpRzRoEaOaq1oJ0XYWVWXZiMfjucqpeJaCq8nAaQeeq1xAlTFVPXL14H15QlGAGe2EySMD+GGL5g7FxIbJ9O36FS4cC6hfqUDb+7HtIKkM4zI1131jO466SXRKb55deZOrG20PC5iKrKBLwMXRzvA4s8GDxuYF8Ph+WuSwr8i29SrmRpoDawvF9f8p9eS8UVIxS9Fi9wdMoy5Erd55NUuLxP6TQ4fCBmkWIN4qsUziS5tIrDSxy6OwK1PPJaL7VUO6uQ3L2nBaZvozyDnP9WM5xy20BVnu+MK4ImClbkGOg5GggAb2yN68lPUMHMjPCriP4k30OfOh1ouuojR7fZGB6SJ+0dfCQ65xDnE7wxCSPg6gD33VsbuUf82yFb+lzHbLbJBiFwfm37PTmgqBDDUEbE4Ds7MBNXWEzcgUdT+EfOWaI0JAIoxP2Eaw37wTvmCI6aUBgDtTRERJofJFQsVln87vcqzFxuPtBlxlq9yxjCcEmcHiGiSlIoKzkWwHUEcIyU6oh298OL8YLh5TSn9CkbtApDUc98PIUJ3kVwPJ1Y0baNZPs8HSX8RURdWu6xTY/QLHlxoRa264zflHrgRbSsno4/McVYh4cbXeE8ycNFzXA8jm6ItJ4Y0ioJvf5hEKWC667HkPF9nK1eQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199015)(1076003)(83380400001)(2616005)(86362001)(38100700002)(36756003)(6916009)(8676002)(66476007)(66946007)(66556008)(9686003)(5660300002)(2906002)(41300700001)(8936002)(6666004)(6486002)(478600001)(186003)(6512007)(26005)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AEIqu6GSi2pDuh7Kn6LYO4Ho0ym/vZ26OQT01Chl8Zpei3QLEjKrkWy8KcFb?=
 =?us-ascii?Q?90eGnO8ck8vp9X3PDueC/sjy/ZSfKz/pAB7hORLegeKcp9wsTUyCLp1k2CLj?=
 =?us-ascii?Q?hJI3YUHkdjKeOOxpwHYrhy1RSOl0YP2B6jpep3IpPEXrcNdk8znfU7LltDHC?=
 =?us-ascii?Q?b8tAnvYWL78b3/GSszxgo+slv+lxY5MkWrQNq7s3LgVGlvo3vhBiZFq/ebXq?=
 =?us-ascii?Q?1vrXQV7IXOtxrIPzOLcwTFUpx2M9BA8Dhy7ost9TD7B9cgd7Ez+dyptSJDPt?=
 =?us-ascii?Q?rkwsTglYNqH91HleWa+y0bPCcwAmUo6xqm4M8Ylk1MvUmWJceabJfNb3mfrs?=
 =?us-ascii?Q?5mNORbIfUHTP/iiCf4iYbDxsl6f+jLdL+GlgX9wbtSOEFydDy3kkV39V+4qe?=
 =?us-ascii?Q?7EP2gBkPoQpKawtCjOZ4mza+Y5ie3Gi/5W5aeLs8lo6NbAiWDuEM98k1ATWq?=
 =?us-ascii?Q?O/oLosoPIKgJ6qiDzO1IjKG1xj5T214G3SndlwI/tqyIke9oRhsHBXgA0Kf2?=
 =?us-ascii?Q?ka6htrg/k7m0c2Ldy2aOf9Rjo0zHcczhBmzkWzk2650TJbySvgmlZzgj7Mgy?=
 =?us-ascii?Q?URxkJC7vw25SOlXShL1nCNf9CSQ/Klbg2VmFA9OozFLWCuEymG/pYH6oVdbr?=
 =?us-ascii?Q?kEbGLuH/Pp079Pg7ghRVz44CkrlbwyVIDDz44c7/3G97vzI8yNI68Fy0n/QK?=
 =?us-ascii?Q?TTDun+Z7fy6vuV2GJhjsXx1j244nLqvCkdxCUxAa3jVy4FpFr65i03NlQtnV?=
 =?us-ascii?Q?Zzvw9Bb8Rn9YpTych8QWA3h7k7KNnq5o33Fh7a0+UIstJZ0Qc7f8Ol65h5V7?=
 =?us-ascii?Q?/L795PoQgT8Mpu7T1ZGxOOo1ft0ZJhmhJT7VT552xET3HZ/7I+3JqnbDaspw?=
 =?us-ascii?Q?oE9EcVR1UwKZBcf0bfQKRkOnKazE7ifJmMwu2+SjI7XtX2O+o3Slur2Lv9op?=
 =?us-ascii?Q?DNzbWZUwRmvSrofmKRbo9wzcIckm1cSDQtPugZ3f2GTgokTu40lvL7p4phnx?=
 =?us-ascii?Q?kFOvvQwCRTCT3nTDAOE7XTRmouwe7x5uD0QqlB5BtZN7cLuswCOXx7gPIY9f?=
 =?us-ascii?Q?CWhE8TQdxTtzRzcUVi24LO3lgfLTb6FKKeXHB673WOuFgxGgcS5lozNExSYX?=
 =?us-ascii?Q?5BaLcIpaYQwqVIlQQizdGDOmfxGYMzZN9kag5e4+WGyccCRqz9Ml0T1qoNHg?=
 =?us-ascii?Q?ijlA0qLuVPaSDKBcjyreDQY4TL77nys4agX5s3d9KloU8lTWFgKac+EmUXdN?=
 =?us-ascii?Q?OrQPEJTy0cC9qOeXh2PgCgCRmf/tpCP5JeVxFaaRaOfyTdZD8IzxxM37k89A?=
 =?us-ascii?Q?trzKO+LMwho6orgOzYwqQU9dUb6hkXEPdpSWSw42lolkwRWgYRQZvVuOBnRn?=
 =?us-ascii?Q?EwivhUFkZdKVlLLfafsWOsWo/8sJuKrNKtWl0AzXQqWPF9gOpnSwxV3BEdxa?=
 =?us-ascii?Q?OwFUOIMvAcf15N4wUHM0kfpUYYVA0be4/l+ukkqFItRpDI4orEgN+/swHC5H?=
 =?us-ascii?Q?k6tX1NyYRaLU7k4+9ygIFmQ19+2lnjooKsjf6btbF8X1bf6WzOAP/ZdTyhSS?=
 =?us-ascii?Q?VlK6KUUSpl0wu5/U3H1/CKjiH6dt/uckGlakDKVumpTbn4qSCah0ACFOx7qq?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kzl8R4t44LRnjKCUd9l6TnXRcYz0OWXn3NKjd16tGdoGd7C0ymCdpeaAawcPXJ8yzhCT62FtqK80DYxjATcalEc0Cyyuyh69rkVkPzkyd0fMP4j7+tJzcx6LDbZwF53JTT9hPFi5W3pok296lGYsKyp+INt5EaOoZhlemlMImm1jBbPH88FweHPwug1I+Y+vXb51OkNZSgYQBYTGNWZ4j6e+CEmEU8ses4FnSer4kNi7p1M7wDMZcZN/ThaYUdknkKCaTQVl2+y5fw2E5H3nG47/+jqHjh8GvT4FZgC+cse92dlRuu/ry1QR3XjWuB1GYMrINkvkWNIdHLTNXkiSZwkrSbqEvZHEQBMeA5jQDZC10XyOH7BA215rGnSn3A2lcgSUsPnxwFL2F00OgEannlFOXFM06mqkYHhIHQdvuJhrrYVj3ROqHMrGFlwIgn9MrnvbuHymSzCEcYR3bpEazLhOLu+yLe6XubpBcyz5CBNJGpKY6SfJunK67H9kBmUEPaUeEarPXGD+knrfbyY5BtaKRiLz+fFrI5bZPrBtKmGzoBsQ6DEVs6yIVIjK7YsxyHKwlEPt0CVkewa/uUiQ96d1f1aJrITO2T/XLGuUPLl7buhq2haX2NmLcPRcVJT4bvxxwZIqytwTKH7oV2KkjIlbP+8/ZSk4pyLwRBrzoPyvGlOjFCVagA8EI2mmPIMj/hh+iB+kuN7gQfEVB4g6OwlwOtslh1VxTxg2ufUFy2DSeFcb1Alf/7u1L5eeTMsdrT670Bj1sxqxA39gL19dIA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0fe42f9-7890-4d51-bff5-08dafdab68d7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:27.1081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VfbfWAmAVSoiAWIpbNsxVJ/LEBpU92ukRz5FNHkX4/hlFcUa+8S7cAEG9CnS0QZqng4MvR+fIqI6Kn/zZyV53QOcfo3AV2UaWP7UyWNDywY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: OPZRuawUVJ3Uwa8x3qnQQkpypJ0D3B0V
X-Proofpoint-ORIG-GUID: OPZRuawUVJ3Uwa8x3qnQQkpypJ0D3B0V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

With parent pointers enabled, a rename operation can update up to 5
inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
their dquots to a be attached to the transaction chain, so we need
to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
function xfs_dqlockn to lock an arbitrary number of dquots.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_dquot.c       | 38 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h       |  1 +
 fs/xfs/xfs_qm.h          |  2 +-
 fs/xfs/xfs_trans_dquot.c | 15 ++++++++++-----
 4 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8fb90da89787..9f311729c4c8 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1333,6 +1333,44 @@ xfs_dqlock2(
 	}
 }
 
+static int
+xfs_dqtrx_cmp(
+	const void		*a,
+	const void		*b)
+{
+	const struct xfs_dqtrx	*qa = a;
+	const struct xfs_dqtrx	*qb = b;
+
+	if (qa->qt_dquot->q_id > qb->qt_dquot->q_id)
+		return 1;
+	if (qa->qt_dquot->q_id < qb->qt_dquot->q_id)
+		return -1;
+	return 0;
+}
+
+void
+xfs_dqlockn(
+	struct xfs_dqtrx	*q)
+{
+	unsigned int		i;
+
+	/* Sort in order of dquot id, do not allow duplicates */
+	for (i = 0; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++) {
+		unsigned int	j;
+
+		for (j = 0; j < i; j++)
+			ASSERT(q[i].qt_dquot != q[j].qt_dquot);
+	}
+	if (i == 0)
+		return;
+
+	sort(q, i, sizeof(struct xfs_dqtrx), xfs_dqtrx_cmp, NULL);
+
+	mutex_lock(&q[0].qt_dquot->q_qlock);
+	for (i = 1; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++)
+		mutex_lock_nested(&q[i].qt_dquot->q_qlock, XFS_QLOCK_NESTED);
+}
+
 int __init
 xfs_qm_init(void)
 {
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 80c8f851a2f3..dc7d0226242b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -223,6 +223,7 @@ int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
 void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
 void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+void		xfs_dqlockn(struct xfs_dqtrx *q);
 
 void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 9683f0457d19..c6ec88779356 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -120,7 +120,7 @@ enum {
 	XFS_QM_TRANS_PRJ,
 	XFS_QM_TRANS_DQTYPES
 };
-#define XFS_QM_TRANS_MAXDQS		2
+#define XFS_QM_TRANS_MAXDQS		5
 struct xfs_dquot_acct {
 	struct xfs_dqtrx	dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
 };
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index aa00cf67ad72..8a48175ea3a7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -268,24 +268,29 @@ xfs_trans_mod_dquot(
 
 /*
  * Given an array of dqtrx structures, lock all the dquots associated and join
- * them to the transaction, provided they have been modified.  We know that the
- * highest number of dquots of one type - usr, grp and prj - involved in a
- * transaction is 3 so we don't need to make this very generic.
+ * them to the transaction, provided they have been modified.
  */
 STATIC void
 xfs_trans_dqlockedjoin(
 	struct xfs_trans	*tp,
 	struct xfs_dqtrx	*q)
 {
+	unsigned int		i;
 	ASSERT(q[0].qt_dquot != NULL);
 	if (q[1].qt_dquot == NULL) {
 		xfs_dqlock(q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
-	} else {
-		ASSERT(XFS_QM_TRANS_MAXDQS == 2);
+	} else if (q[2].qt_dquot == NULL) {
 		xfs_dqlock2(q[0].qt_dquot, q[1].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[1].qt_dquot);
+	} else {
+		xfs_dqlockn(q);
+		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
+			if (q[i].qt_dquot == NULL)
+				break;
+			xfs_trans_dqjoin(tp, q[i].qt_dquot);
+		}
 	}
 }
 
-- 
2.25.1

