Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CE7C38142
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Jan 2023 22:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjAQW7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 17:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjAQW6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 17:58:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6961E3EFF3
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 14:37:49 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HLww2d032138
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 22:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=j2A8yQyW+KPXyK+Cjb4PLMeH7UqFZb2c9i/+ug7WJ/8=;
 b=IluucpupdUURAuSAHdSqEA30e11v/sByz6ggJxpf667+IW2dWz3VlPgQ+3/Rq3raLm7W
 Z7/0Ms+2fQ7fIkzc/FSWUObT3/s12zeTxZEVVhhqt4Ho+RGFD/sPSuvnIWI8+3qDllk2
 hft0e6Gzz4jZyADD/yJebiTbnFNQoX5PnwxqNlwPE/dSUwtsLCnncyGD7WIQWQOVkL8H
 vCdFLxGxUxDLQN2ZNfdateTD0Ldo2x1mXUuMM5dBFe853igb6gNIGEy2hoThLuHG6l2L
 QWQ0q4Kdf7fSQAtoGrBylmwAvcY763O8vhY47uyqqAwmTuZXSYbR9OLvQQJxCbUvExze iA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3k6c65mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 22:37:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30HMSnMi022979
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 22:37:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n64gp0ar8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 22:37:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htZq51nMSa+qp6USmE68vFi2FeGo3AVoDGkmz5+aqH/nsj6fPrtUnEpIOrObWKUUWLirkq3RMBHmoDRlxesDv/eWq92w1eA/kLWpN1sTop6E6eUB4+T50w0CVp7cOMeqo/NSZmYLa4MFCYSFDTSrKUMaMe13zwj+CRiZpAGrqH6xoW1M0xNVwZ+tuz5b2xTbStvlqAnq56rwpSELjTyXu2zN3FSez1OCN6OMwkalU5L+QXYfmRJRsvH8H2EfTCpHCpETMLotKCuf/zXpigodvPelZEWIR7iDKxbFnCRV7G3J2aeY1y96oFO3XEKcdnYrOoauiszNHnFeMyKPl51vCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j2A8yQyW+KPXyK+Cjb4PLMeH7UqFZb2c9i/+ug7WJ/8=;
 b=i+kfAQt4ak0l5cW842yFxn6cnc3cxqy7+zdYqnBnBOLfl9NIbbs2yI55ediAYjsLbv4hrhqsxQVCcR6Wd+jJM6OB/fBird4RLkp+jAjuH4F6CyxGGBxC3UemtyK7k6skEcnJFVE6j7x3RANomvgzJVKUsIxiOagmqE8UHxudg2w2+vaTojgfpzlOILLPppHc1dIdQKcafcvr9YZRjctUs2KDdVi0CMXCGhqK2PwoMFrDjn2fswbtuE8iIox/VOAfpspVRUDfxBo/sh0x76dlCydmUloPQ7BaoLeZLinsTQyw1/OdPYFNeQn+/Li8D3ajRPBhdiluYRd6kQzBf+9tZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2A8yQyW+KPXyK+Cjb4PLMeH7UqFZb2c9i/+ug7WJ/8=;
 b=g+6EweOTFD6IXylwORgVpq0PMrft7i3J7zy3DEbnTI2KkNz9JiqlBtddWJW7QOSv2yPmuXTvxtg3rlG7wWLYq+qWa0T8UgNKY+N/8pChNTlNGpI4FF8rC5f28GH7PywAbAI9sA5lvuJp/Lh5QG9sOQpkAUltKfTPPE5rKStrafw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB5186.namprd10.prod.outlook.com (2603:10b6:208:321::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Tue, 17 Jan
 2023 22:37:46 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5%4]) with mapi id 15.20.6002.012; Tue, 17 Jan 2023
 22:37:46 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1] xfs_admin: get/set label of mounted filesystem
Date:   Tue, 17 Jan 2023 14:37:43 -0800
Message-Id: <20230117223743.71899-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::26) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: b908c319-4be2-4530-f93f-08daf8db73f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SX7z026qFjiOz9xCB2ttwrtlUgdR8qgGPQ+9RpbZ4OEAxXvY9q2sxc4tJHlw6g9wYbAaA0fT7TUNa5xoiYGN5lKbUT2BXLXEtG7asEYadcgV6dyqnPPkYUkE0LsOBGgIRHTxKr9JLtc3vRvqNBqu/zjJeXulM0BRX++mEwb1nY5xM9/6P3mVvN3bcAiIahZBvVGptxRQsn0N6kmLmTzF1aoIxdGHxzTe511YSTDQV6gBKp3gGgbr81iP68utmCQ8LpCXGr6LAN4Wos8BTyEF8G8y3uaES5Ce1v2sAGsoxskF1OVa6lvz/UbCQEYl+XxKDzK0zhb4tIcqwTHdFy5KK1FxuUM4x22z/CHYwc5yQcuBkZ4bIXqG+xmpxU0dcwPRNXs1Yf8Ucyx04Rbfn1uvvrmK4EkPQ9IYJgsVimYKHONXYDjtSPxqtdgGEgOQRd9wPL7tBohVRk2sATxN65JH3/Lh7Ruw2dr51a/QK5IQ+Gf7xZIESsT1caIrBnnOrsbPZ3Tgk4KPv+IqSu6fKusngr0B7rHEN0ncAG/CIAuOD1Op9N50MgFd+bawq+wHjdYzoOTj/HnGJT7DB39RCNMUCorAxl/fqAEdkE4u8u4Ro5MZvcwUlNskjnbfGTCgx65BqPEkqPorLaECgRKpfPxAkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199015)(36756003)(86362001)(66946007)(8936002)(66476007)(6916009)(8676002)(2906002)(4744005)(5660300002)(44832011)(66556008)(83380400001)(38100700002)(6486002)(478600001)(316002)(6666004)(41300700001)(186003)(6506007)(2616005)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hJlbxLmqyztL4pR6MgUOFA1ek3ERLUaLvxrgj3z9TuJ5p+FOis6dorUnKZWu?=
 =?us-ascii?Q?FHwik9e8oXahlJCGDWZr3KN2EOnqPG1FZ2nl26bHd5VoO46eM0XoIGpKvI8v?=
 =?us-ascii?Q?cRUssrmKkBogtVAsKMn5u3h/1M2VQ6HvZrVdbB1SnqtKDV253KZZ40Of6ARO?=
 =?us-ascii?Q?lbJB3yeQg9jmn+UcWcDvGMpkrR0WGtqqlIVoWpLCzmqEsF4ZW7+TVmghSNGN?=
 =?us-ascii?Q?VIlnHtaxXVSD779mZ/xhTzOHmWiHOESgQPYo/Slikeuqy1iy0i4A+Yp/0fwm?=
 =?us-ascii?Q?2ysIEFQA6hX/Jr9zFl5SgjWF2zdc+zssvo0kYUp0o/+EHS37kuTO8U8/M1/6?=
 =?us-ascii?Q?9EhgwGtHJlmWOHrY2QCazQ0f5MWmjsQdf7k3DIyN3Tk8DFeT64IXLZS7xl91?=
 =?us-ascii?Q?8a+XKXAvdO3HjPIX9tJt8r2QzSTbCt0SMIdnGMeYmwXJIUIPcKnV1nUlep8h?=
 =?us-ascii?Q?EXgCdq5ia/1xK9rN+TLVpUOUze3sz4bh7D5skjNpsumDvWk3CEmR53T/fPnu?=
 =?us-ascii?Q?MZIKY88ec1xqnI8pmcmxIdk/Bvi3IudZb6U1AsAi3Ebcv5c0qfca2yYdnrRR?=
 =?us-ascii?Q?kuu4CAwyWZ0GyutQnLMbUUsUpMd4/kADqXTbeilCgoVXj47A14c7gYkHumht?=
 =?us-ascii?Q?Pu+H0hp56AHCD7n8J8Ev6EGCH/vU8UJjTRL9gW8Pq6+9MIHcU+R6el5EN8yb?=
 =?us-ascii?Q?5/aoKq6kHW67l6lR86arxTA8t63jCs/T8FUlyiGaTHxw7xK8Vb4bWlc4cr0V?=
 =?us-ascii?Q?EzxjDywpW15ArvT7qPeieB0oKo8UmnFbR36qRmV8BsByDgdmroSnBQBoBMbe?=
 =?us-ascii?Q?PuYF/dQwxWRkwQC2RbP7r3qwrcyh2AiGO76Wbhnv35rLnHxnVMeNlDOaDmmt?=
 =?us-ascii?Q?6BzlzwA9PoCKrHZpQgnHjU6ty5ooNum2kwLyeX8VjeWsBUyYZfbb2SjEQ6kq?=
 =?us-ascii?Q?Yu7v4Dxuz6ZeY5SqbtNJqBXMQaMU2Uir98dcV5RIWuTZmrQGijzue+3Uvwx1?=
 =?us-ascii?Q?4n1XAh3boGQAigdYy5Aw+hq93z4TUNqoua3gvt7/fez7sei87M197mZwt0Eb?=
 =?us-ascii?Q?oKutha3oTsDDGaxWUMjDS6H36MIWvEYGnLQ8vniEgf8sdcJfZ0bkbONyf2LQ?=
 =?us-ascii?Q?3YVVAA5wM9REQMCR/rkbQZNK2EQsLRKrhVfdabl5nF9hl7yhGPjpMlVQRioP?=
 =?us-ascii?Q?fIAYzropUwq3IKzBYyCElc8X+wSB6TfK6tpGZJjj3SaSnYuoDacyYWj0Onan?=
 =?us-ascii?Q?CFGeiX5+t1Hna5/1UOyVha8iqoXzEnNwnK/+4yYyNXoC2faNWGja0Xz6s4X8?=
 =?us-ascii?Q?vndJPzwX8d6GOpJeiMcDJg8+rbpLkB9+lXAfOJAGDOidJrbaF6mmtaklj2rM?=
 =?us-ascii?Q?NpnXUQHKYqnSsx/l/HBY1/tbP67hlC7D0p7j77HSjZqE+TCaNLCtTA30hGY+?=
 =?us-ascii?Q?XnbEUCKLDJ/3jP2qOi/9ulQ1ykQFaeHi2LKAND6H6IKo2TH8StDpquNa+LYS?=
 =?us-ascii?Q?kVYudaOyvp3/KSJ/NalWj3hSuROIw6iCKvbiTtHVR/m57lGQ5j2hcQrhVPn+?=
 =?us-ascii?Q?FaXd+5iWLje128LyQ/yU+NFz5qp8BQvidJnk1bh9uiKPnGxoBLcMzJdRWu72?=
 =?us-ascii?Q?s9sj10UOy0FXfBfKSa6u1DbykTpjGXoWzroN45P9Da2TDQzOg9zr0ZIZSQfB?=
 =?us-ascii?Q?F6Y+lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Npv0csc+zWKQO9IlTTF0LzFcJZTs0hc0wFyoOBgEqkx6Ht/2qHl3xjUsIeoachrsJ+4lkZENeFyOXPZfeplTZUFDQ6PXqAAKnCG0NxnL40rTG6KNLY3iasqRc64Ov2dmkwsKBiSbDaKI00sVJBi7JIPHsmhDVBtL/D846N8OQ+06hvHCGy62wULf+sMaznx3mECFdU2QDumqzWiZxUSAi3O3/Dk6EOfrOXaGgMXU0VDlS2flKQqMnDvrF07A6BYj/kUwSJ6rQ9LkWSF5co6ZRmBvDWQO0HjFa/RCibiIC31RKAJMObQeVfIV2dUHwMHIfk/XfRCRlDqhDtQt/JzKuQl7mFelkQS7waDG1BE9gYNmNnSY+PjjSLA3h8xF8Cem0tbRITGaHe+lPxbLqehSJJDI8inSNE+iNd0OmcVDa/No2Z81k1tEFfjJy+pa+tP37dPWL0G1wK9ht30Jodv3fYKqHitL+LYNa3YR7fRpsksHZC6ywoNceIRFtqSEtS2GDxZ0raUGpVz4G+k1XDWnFViIT1KREQ7CHpgaR123EGhSm6VCaXe6SVXRI93jmTqoNUjE0bNGOXNAsyLz/wWFfzbqt9YDtYecMfsMMDj67wnzOmL9z8hNJEzrKdFXuM5bT9ONPBcZMXwjonRxSnSvWZ189KJ+3t4ethx4TR6ktWPqR6hBkMvBhagiHlw279Gq6vKJ6ggbCg+kGVERsXwAKwicM64JJxpgejQ1JPSZVdMXb3NkGA4oLe+JgO71MoE307uemfw2EYt+lT4Teegm2Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b908c319-4be2-4530-f93f-08daf8db73f4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 22:37:45.8163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpfpV231++5lEtbCwABMtj65Cu4XD8ARPR31D1c5wKSW4yEeJps4Ew5bmsNTVJnJ2t0kHA13SoWBOwYQOwXkuM/PE9ozioBzXcsZ0Xs1i3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5186
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_10,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170180
X-Proofpoint-GUID: FzHD51DJEJr5aeCUicgBoTTOT8DJjE4-
X-Proofpoint-ORIG-GUID: FzHD51DJEJr5aeCUicgBoTTOT8DJjE4-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adapt this tool to call xfs_io to get/set the label of a mounted filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 db/xfs_admin.sh | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index b73fb3ad..cc650c42 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -29,9 +29,11 @@ do
 	j)	DB_OPTS=$DB_OPTS" -c 'version log2'"
 		require_offline=1
 		;;
-	l)	DB_OPTS=$DB_OPTS" -r -c label";;
+	l)	DB_OPTS=$DB_OPTS" -r -c label"
+		IO_OPTS=$IO_OPTS" -r -c label"
+		;;
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'"
-		require_offline=1
+		IO_OPTS=$IO_OPTS" -c 'label -s "$OPTARG"'"
 		;;
 	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG"
 		require_offline=1
@@ -69,7 +71,8 @@ case $# in
 			fi
 
 			if [ -n "$IO_OPTS" ]; then
-				exec xfs_io -p xfs_admin $IO_OPTS "$mntpt"
+				eval xfs_io -p xfs_admin $IO_OPTS "$mntpt"
+				exit $?
 			fi
 		fi
 
-- 
2.25.1

