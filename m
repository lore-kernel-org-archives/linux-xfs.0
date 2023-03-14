Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE37C74A44
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 04:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjCNEVf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 00:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjCNEVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 00:21:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5963C7E7A3
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 21:21:30 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32E413ib011377
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=aw6CziJGZ8SA50w/Ai2TL9j4Fl+tOTraLLqHKpdOytg=;
 b=jw2ztrUlN/aiuptzRDnR0+kSJUh93Q2Zi/0GE3eA7wDkCDNBHKYbBT+TrW34dHht1sGj
 gsxo33xc2Jh3sDhpeqfOvIRJzfXFz2+u15n54pe2eJqjMmycQv0FMjweE0Gg/AfhYb5+
 HeMPWQHAM5HE7Gy7Nl1WKSpxVCzt+amf0mQLaECz9qrYTlIDI9p2Qvkl3wIC0lcQCm4b
 rvCaRttvUbkiD3RpgrkmrVBYuxdcgDLFcMbqDxAaH3krmCYdtqfX0tHUvAYhq6AnmGFd
 O1kMtZ4E0/MuDCx2hnWmoEZtm2EKWrhI+B/VZE7I74zJd0u4sHqXhDF9sPSGpZcGAm05 qw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8ge2wcw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32E1lcBj025120
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g35jft7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeb5qeBlgCiNUGmHITYwLe7Ovn4DZm3juqA0qTnC+B3eLzqv4nsJdtyTUb44RLamgoO8XDPaPHJpWSS/cPoJCApTcXGmVP8DvOyB4vko+q13geDTJTRu3pkdCXAuDdYzzokdEktWJTHkrcU0Xbs4X74kBLc0SZEy34JvfEdyxsDOsv0McUsi9MB771hoAYCflkEseEleGd1p4bws9nj4DNl5XRvQimaGjeABXsn5pjChKtBH9vo88JkFqMY5MjCihUx3I4TZmR40sUcifrKPGN/M2NMncVowGuMDX7vCwp1bBKHDUJmL1HABjqbHCyJtQ8nIFuaZ4clBxNwDkwR1KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aw6CziJGZ8SA50w/Ai2TL9j4Fl+tOTraLLqHKpdOytg=;
 b=meyYrCV6OWEZFnwGIrDExgy2hTa6Ox/CgV3c1WAapcsLcwr00zVZDsBSK+OoLjDUk6pixf0ayuXQSfzO0RmxAh0RaEx5I9l4pAIrP6s+u+kFlRmf4/R93usmWk/J5OKsWRx4KKuH1ZWAg2923FwRIQ8hvs0HSrzeBcmjK6Um9mI4zkfQUpZXrbvoKAw1mpFqa3Ot2P3s/Khm0/bIkWaG9fnCJ9+Gt7MvOHxogqVVps9BSEU+4KK4/dGHFORPNQU7Tz8kkMs3Wpo6P1GyQ16kazvelABIUuQ2wiVDh0bGRsB97V3Gohj3rEcjPvlM183kkndRa2IY0MXJHLUmGHvuMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw6CziJGZ8SA50w/Ai2TL9j4Fl+tOTraLLqHKpdOytg=;
 b=nTV/AmHZdrJ7jYHljRbgzDUoJpfz4C3bXmdct93SSTQT2lD6/RBi7xyCxujU4kxmLck4vh/mRdBwdFM1YGmlRCWC3D41ZThLsa+ENaDY+xfDMhOIxJKIbc+klPSwsr1PoMxRfDHvL/XmecL0080jnks8aYzo0TmbF/RySjrIbrI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4371.namprd10.prod.outlook.com (2603:10b6:a03:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 04:21:26 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c%4]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 04:21:26 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 4/4] xfs: export meta uuid via xfs_fsop_geom
Date:   Mon, 13 Mar 2023 21:21:09 -0700
Message-Id: <20230314042109.82161-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20230314042109.82161-1-catherine.hoang@oracle.com>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0155.namprd03.prod.outlook.com
 (2603:10b6:a03:338::10) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4371:EE_
X-MS-Office365-Filtering-Correlation-Id: f58be54c-f70a-4cf7-d8cf-08db2443938f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3g4TYlthREfWlLuANGh8eLGfQWqaTpf6i2FxHRKcxj1RLe4WqYh/dfjDmZLQc0/ijU9rX9kF/3ajYhx4Z8MzcPT1P+EytZPyg05DDORJ3baOcy7aXxeDcd5d+SCxglujpPw4UBlWrTSgOAHod2c7hOrZpCC9Tv4lShTr2lsbuY2EdfXZuBdF0XeDO3quXYVVnJo2VeiB2q8n24g/8aOkN2AGGWynOvpWIZ+As7qbXbDGM5EVYwQkJFWKG1L7aBHBJCZCa/LYV1SLCVb0AENl86uFgGP6MO8vnmH+yLUVs9mo+kUHm9V8Y/vLXIS/WbEoMeNUZg0r6aW3xQdJrFIr6vPiuZOVkKhOqYRYOTcbY+WxmBxDRCnD+IaEwMK+en8nwQfDoJc/jvKqUsMSgZeKzXfrJ+m2YzaFVUbpwvETjezduALy7yOjzzPvdduxx93lsen8BNtp2o6X5DcoGfIs/qp04FAMtedfnBo1F6bNCokGZk7fM6Orc5W+3lPVUp/RuVxqk6Yj0uuvfcd6Mj/cGe5PPOm3/+wBoSdWspDlPOAPOX3GqdUMTX1jteNOoT4z6W4lSJxrvCsL94R0E7hx1tbjfFsW0f6kyxp1zowSBrTKBOhJHo44SpJptksAv4U/BtlRUOJj9h3nXAMcfAqScA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(36756003)(86362001)(6916009)(41300700001)(6512007)(6506007)(1076003)(186003)(5660300002)(2616005)(8936002)(316002)(478600001)(6486002)(8676002)(66556008)(66476007)(66946007)(38100700002)(6666004)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TC+9Njy6FpM7wwXNUXl1G/N2LlTK1L2596BfJ+RfxopaSZOLO43Rj9Zuc+ur?=
 =?us-ascii?Q?kS3slflFgH+H0CbqfENvraYZ+LQAvwgqh2RztelbpKFYC9aUvmDn7RBUG3QA?=
 =?us-ascii?Q?YH/kH7+yIC8hCTkQSWvra+03oTrSqF0pJgjqUks38G6P4QsrX+I3LejruQXL?=
 =?us-ascii?Q?/i/X24SZ6tuMu6CYeMr6hWr40EFhiOOeLpLZ57QQvtxpciyo8S/KV8QOobip?=
 =?us-ascii?Q?07cLWZLtzMojkidUL+OGGaPIqrFjvtxG5V2hFQgGKJsL3KmCJpJuYY4ACbze?=
 =?us-ascii?Q?438c/KTRAsSTQUwIoBd8J5dwuWajmh8yvY2Xchmcj0sd1l4hhS67tXFrjxyI?=
 =?us-ascii?Q?d73kkujxzh1zoCbxiRxCu8yZS/2EDof147jBJopE0B67thlmQ2thrpHj3Xml?=
 =?us-ascii?Q?0idvXZRks3WS6nXDKd7g19XTQ+OlIMG0WvXX9edv159Kb4JUqNE6OTTrWO8K?=
 =?us-ascii?Q?GyAR462eLXGRgNrdBt4hjG/LYVhjkz56tXLeetg+4MKkDjqFH5WYfupz4d3s?=
 =?us-ascii?Q?lnKA9zG6qxvquXo5SUAttYZSrbq2q3DgkQNXJ7Gr4UJQZyE2PO+YE+UHe2AO?=
 =?us-ascii?Q?GWbk0iszts8ZE01CtPepu1oCJlfOVCXGXcPIKdqAES6Jpxw2ZiXL0Qtq8VoL?=
 =?us-ascii?Q?dQwSrdVjShcj57oSqWgQejSEZY47jqbSQtw/myygvXF6v3zenEHoV/V4b/uZ?=
 =?us-ascii?Q?hk5tnqZap6xxxfS2gcD4hNGupGJtj0j8DqgD+nU3OxYj6HFto/pXBvMbHiok?=
 =?us-ascii?Q?EhJpxHt/ui5ZeSb3XE8SHoQAEBscdjGr1q+2/cXu727f7r+kvsYsfqSp3heP?=
 =?us-ascii?Q?ClRrPXCbgRveCZDlUvUVrHk7IG3hWg46Qk0o8BCAFXmMYBJRL3YfFPTwYfOz?=
 =?us-ascii?Q?UvcyT2e3O1R09e99Jt1dawNWcK1tp8OlCxb9hjUn4UYpN1EQHWXQgs+4fIJf?=
 =?us-ascii?Q?nIkDDWa+k6ELTx6ZfBlRyIaHojjLNDQByKxeAHiZsgttl8iIQ1Y+EMONGt6h?=
 =?us-ascii?Q?AldbOZMg+NF1gsT/FFl1j6hBp/LNouUefFVzRvbtGHpZjWXk7gDuGma9raFz?=
 =?us-ascii?Q?nUY/GYujwhKkirGC1DKsVJlKcjbc4qaEQ28mG1j4XAD8w6V5FO/gYH9huFtS?=
 =?us-ascii?Q?CYjTVtFnWe2hB+F/rDk3EF0zDj1SF3Sr2fTR5PW6fAP8Cx+DXzsMZnXZiD8g?=
 =?us-ascii?Q?1KJPrfCNcbYYmxYSh6j5gZx0bjmJNcETaX3zpE5INLuHffiAUVFv2tJbMR1C?=
 =?us-ascii?Q?kwLIteoLbICTuJHxIBJmibN5xc608TmqyYK28QiTCd9OO5C62jmDnvFJQLa2?=
 =?us-ascii?Q?/+iNhVCcKHKi/LQDKCBBePyXGxYQrtShF9mZODaBUzSzmCwsvMJEWEXW/vBt?=
 =?us-ascii?Q?kkQ8eYEc7o1papAkY9CZkzbhuyZRdaeBvgLth0UzwkbQXQJfw4kB6trQGDxM?=
 =?us-ascii?Q?bhJXLeop5AEWHZTh5urcgN0Nh+1o3PRBgEmarxXOK8sULrvqtcM4bEnxypKL?=
 =?us-ascii?Q?py93V+s3rTe3n9G69BZzXI1TOxKOuG9LelcJIyY79Avrt+WkkN62wwbrJQMN?=
 =?us-ascii?Q?txzP9WfPQ6AxgJVIUnY+bGxoIG5/cX7IA7bknKipgReHM3JJpXEvY+2qhrGM?=
 =?us-ascii?Q?LGHyx4N7XE3gPvKayS91JO3aH44tTpVHPJ3SOPmgvhtY5lL/V6hGt0AI+YgQ?=
 =?us-ascii?Q?e7uwdQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qfCg0QD5FXeqJF71fSm68frW7q3VWPIA8eNwkmS//LiwYGVj8q4F49pZPHFCBzf/eEgeZo0c5QFjwXy1EcJHqPx7DlleypOYdxOD05Yu+4J35Xf0LaDw9amsRF/aUWEC26oIqZp4dLp3N5XQJoklQwqeBRBxfaWjJrai1XGXmQBEK13zBEE4bA1jH2fyO5Tkf/6LPqET4aiwtxMNOYtbgOsJECkRpZIH1zNGlJntKMHypARK+zTaBX35ZxNeFmuMAudWgPRgktP8W3FLyQnGXKufh3pPyzfVmITfls0ZudXIoQYjJtElbo4x8qNggfRLRBOaedf4KcSwZaMFV9dL2xZBMs6DXS9xEPxrIAK92KdXmXrivllFFJO0e4BX9gVA5iXwF5FywRntAZG5+nw+iHCplOavliqnI6FhCHyqfXxjL4hhK1trd+OdTaJ7QiZvMU+HXZktrkfKArIRBYKNA8rIFr/0xk1JUTufzIK3unvbRSmd9L8oW0vBGWNqL+FrlVJipBSCxlBnZNkh4Z9lgfKt58BnILScuw649t4hB9JIhvBQItC9Ku7fm0sTO06Gh0uXn3HUeQwyTJ2yqDWytFtcdNeUVc7Nwg5t8k3lx0JF2cwjCtkFo0wUgif9eFR56LLR/vBKN7Z7qLJx9sKbhNSGOnINe9tqlxvybNge+hE+xs0535n4iaQ1d4yHmJouUAjUnh8IWOFw/baZuaWfmcMQt0ZmNooIjPislQaiu4NJqcjJz9OhtiLmjr7lnKJUMl164jEqfkEj/44Bf5P3FQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f58be54c-f70a-4cf7-d8cf-08db2443938f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 04:21:26.2018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APZtwD2Bcv5UKWiy+yzw4bv0kRjpA5GdOg+OJa0LaTO2r6FfD14xDNeYJxFUuuQsc4nuEGIVGEoTCrZk/lvToALIxkYZYCYy4gQLOQgyDMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_13,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140037
X-Proofpoint-GUID: i0ZJMW3VdCrxdhjdeQb5nueHb9tzhUu-
X-Proofpoint-ORIG-GUID: i0ZJMW3VdCrxdhjdeQb5nueHb9tzhUu-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Export the meta uuid to userspace so that we can restore the original uuid after
it has been changed.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 3 ++-
 fs/xfs/libxfs/xfs_sb.c | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a350966cce99..d88adaf9369f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -186,7 +186,8 @@ struct xfs_fsop_geom {
 	__u32		logsunit;	/* log stripe unit, bytes	*/
 	uint32_t	sick;		/* o: unhealthy fs & rt metadata */
 	uint32_t	checked;	/* o: checked fs & rt metadata	*/
-	__u64		reserved[17];	/* reserved space		*/
+	unsigned char	metauuid[16];	/* metadata id of the filesystem*/
+	__u64		reserved[15];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 99cc03a298e2..4c24f3314122 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1213,6 +1213,11 @@ xfs_fs_geometry(
 		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
+
+	if (xfs_has_metauuid(mp)) {
+		BUILD_BUG_ON(sizeof(geo->metauuid) != sizeof(sbp->sb_meta_uuid));
+		memcpy(geo->metauuid, &sbp->sb_meta_uuid, sizeof(sbp->sb_meta_uuid));
+	}
 }
 
 /* Read a secondary superblock. */
-- 
2.34.1

