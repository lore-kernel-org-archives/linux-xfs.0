Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF4A7EEFD
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658303; cv=fail; b=ja5cZhTROeW4rqb7eGx4lLWQ2qQJnAea5IgoYTNlkxblamuThPGAOy4SSipmcfDx0hY1VoNeNEgWqPz5Hxfi0XWxOXf+duzNnQSTVYp0e968Yk/QQ19VPTB4Hh9PA6c5/tBWKUNRDhJu1tpzgVxVPAUW4YHfD+7eepo07lbdGjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658303; c=relaxed/simple;
	bh=ykF7NpnQT46Jks4gfz8eLGiyCdlQem/AcbuOhppl/6w=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XMJOjXwG8NyoIFXvn0swSjmFS1cBk7mGCAZdzC9/KcnFl+QPEgsBQBRqZLDDDGO72qhw19S2xtHBBAlGEBqFd8eSOLa0JmjJIN7wjzvUwZeveWm2BBygyDT6ZaAHQ1bM0lHisl+ebPifckKPoE1MvkR2LXIrdbLjNflT4steQug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mmlc6x83; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cd+oICKc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mmlc6x83";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cd+oICKc"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKx9Lh016982
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=LuMDbYYENfwkIa7wnMKemSJhWngTnAyZfWqQeSr9hFo=;
 b=mmlc6x83o8kEkcndn3carY003xGvU0v3bLJhWgWO3l3HjHppyJmuhoTj/K3SMncGZ9QY
 aqbHuEC/bqDFTCa3DwpKcOdEr0HX/g31miZYuf8xE5qVtFSoMtUABL01G9VmVT+3bWIu
 qu/Z0xgAoxpgfG+SyBDigBQceXayIEXSbCTbA0OBzmKWGCqEx6pYRUNl/LH2ycedoJXb
 taJPMixbyKJDoACpIak5FMr+aGIVb2V5LSTrXpPba6b7SeU6W+LrKshGrItraQMw2/wb
 H0JBlZKfuiwmXmvCr6DwBpXAK3YZKurTlNY4x2iPQ1/JDdj7nf/V9ArFjGt1dWGMcuHA mQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvseugcmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UNaKQD014749
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9e97wk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kw90Q5qwcu0x2FRrEg87fwYq2pCQqpQ5qD/Jr4XggYQJIqdmDA7jxosSxgXzWjjWA/2drC6ENu/OOUvglx2XVVYi5pEcNmJ3s5Lbc36L0RCV7gNktDsp81SfnK6DUzVUSpEtBAl2AgQYbC1IDkQNRai5/b0q7F0C1n0NIRlVV1RKQ58m6lWSyS+DIciYH3ojhz6v5bzGaAXD19m1Rn5z/gYQNHINw/RFMHyMhTEDFYCviwV505cxsYy+yR3qkZWDROkgtNsdDy+ghuQ9gOMhm7vxCRsMoa5KdnjsFPvbA+XQsrFFsHvj/rfeLXBMvYXLNtneYQinUWneOmRBEBU1pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LuMDbYYENfwkIa7wnMKemSJhWngTnAyZfWqQeSr9hFo=;
 b=cKxAYtSHYIFaZP6C/x5akvQv8n1IwCHoaZ7fiULnNSODwtZx3/AEvBoHYfmRM7jMzLOroF9WcesWmIF2OtD4C6VjGz2QZZNlenOj4QJhNnCvcgJoA/+VAFNRoXfdd4p3Lc27QQyTDbnDZ95KHps2nCPK32S3vkT3S6i2bEaNTX6tZCTRt+OJZIkkKzvBrGwsENX/ujFXX3Q2d5FcB0oN8Kuly9z31ZVVwm/uZ03JwWDCHFpVLpsilvJDolkPh0R6EdVqO+NXICMi76H3gh3/o+mEDSRYQWLwwL6jiTP0TGgP3AjiWJcqUwzSM7/BjghOfZcNxuFVYPFc/+KGaLDf8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuMDbYYENfwkIa7wnMKemSJhWngTnAyZfWqQeSr9hFo=;
 b=cd+oICKcZxPaEC9nXjwT+BrL2T/geKykKfbUF/bRca6qmqcEWdYubRVeqrnDZaq81BMjpNRC56rHSHhNKCYu7TGA8aDAunmV+jQbtKYf5hMUhLK3RzU8zC97gVYdJG/gkr4B5riglXorQIHL5CKsCtx6FBl0hrLX7A/AD8zP2mM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BL3PR10MB6092.namprd10.prod.outlook.com (2603:10b6:208:3b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 23:44:58 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:58 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 18/21] xfs: dquot recovery does not validate the recovered dquot
Date: Tue, 30 Jan 2024 15:44:16 -0800
Message-Id: <20240130234419.45896-19-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BL3PR10MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: efc9ce3e-3958-404d-2e19-08dc21ed77c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	DMiRHgGMxsZtiUZBYEkhK5w2EaO+Nkj1xCUL2uoBBDdESINAu6fCTa+bo53u63opnRT/v9TwZsMC79RCZrlyjTYzeXFjuL5ZS4XTzhicfgYRAOQIcXla7hvulnMw8NsWNgGG9nnaCRFB+zUDrvdEHFh+rrwnmKWGqDw4jhguybJlOjGKuUrLiIuLUtTL2wazXJ/vyeDJWUJOOQEMKk/P38UfxOszkM15TydF31L5CYibqey3CfwqNAue2kcRIkwhto7XDp8fYyZn1lDDp2bl6zN7sJ0fZnpvAGSfyuO/sduq9KGguzzD1R+wKu49U+4TGKA1GXXS3A9tq/HKMfT2pz9jX8+UIFbIb1XqU+yCZxy1Me7KUzpxlODZJqCAEmQHbPpXhekJtC8vQtSAKY6OmbgoLGNtDYjDZyDNMTwl6+4/CzxA7SwfcyjI0beqkKicgtIqSvm+07PanVhMgvqV6f/7lmFVMK5knKrnoNShuQlpcRhH52B5frVr+flNKLG5DxUeAbm+FUJrCtUm1N0bTm4oixLaTJn4NUyZLiwWARdksyKNoljIxBudaQFtS5ve
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(8936002)(36756003)(86362001)(66476007)(38100700002)(478600001)(2616005)(83380400001)(1076003)(6512007)(66556008)(66946007)(6486002)(15650500001)(316002)(6916009)(6666004)(6506007)(8676002)(5660300002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?zsWLiniyL3gHc2Gt2xRqWM1F64bMR+9YkZsRor7UYonIQYSxVuehp3aJUrht?=
 =?us-ascii?Q?G6/LiPLwmI8lzbuE18mO+rSGKxUHH49fGceXib51ExrIyui/unWPsvLYZPgX?=
 =?us-ascii?Q?ARR2Wd6noUN8sbkyGe2ksN5NLK8nwXsgy4el0/n6cw9WgoIc7Qog4ESqyDL6?=
 =?us-ascii?Q?l4YizBwJtGyGklGkK7BO9LOsUjydbTGCs261yQ+bpF3UZjtGVBYQNM3q9ysw?=
 =?us-ascii?Q?ZIlBIyhktV4RDPBY6r5eSICO9lwr3HXcJbgDu7eP00VVqtD31LTyxsRyMioZ?=
 =?us-ascii?Q?uQXdn3RuTlB9TJxAIreE8/5gfL7pnLPzamsIEX8rO4sw37EmnT6gCAIZ6KAZ?=
 =?us-ascii?Q?j7/rYG2mQ+jljkpGaTmo/esUbOezKPVpOQyTlkaKx/sMZSjge3zwOxHgxX9Z?=
 =?us-ascii?Q?ABl2l3AlmYOXDX1MaCNcmDOvxNp7zYpgQb5Eqb+eqK0xfqURePZ6BM9IQcCv?=
 =?us-ascii?Q?xx38Y+u5KfSUocBCSnG/5MgzXtVYWdjt7SkOGvkpqdD4aKtMfle+en0pdpe8?=
 =?us-ascii?Q?7EcYS5naLYMqtqgE+3M/feuqwfAsbstorUneiXZsceVwna7tRiJStALt4I8b?=
 =?us-ascii?Q?Bo+yr1u8hjLBuisfVSTlUf4kqNqJ6tHWb//e+AvQPpSW/AE0qSGbqrMj/GUI?=
 =?us-ascii?Q?3w1JfzdmR1+ovZ23PyS7Lsp+s5vLZQkJy4EsbZ2hlMMKF+voMBHsTSnMtjX5?=
 =?us-ascii?Q?/O9W98Tn3KGix0fbUexEgsphrqzn8diO0OGcAEHdyZFCWi6T/aaTQ++XjT5I?=
 =?us-ascii?Q?VEzwGUH1hW5FM6N9CawCUF9iJ4sNjw462iqDxI1A6mKRWOiuufscloaFLaxp?=
 =?us-ascii?Q?bBgJkf6FmxBv99paj5Dga7k1ZJn8CSAhDipeJRXrbaVldWW38uxZ1k8lUtEt?=
 =?us-ascii?Q?J4mHXDEy2e/10Eg+FYw1Mf4BPYwOsSYbML60paAFLjJS5PnIfonJEb/QzuRd?=
 =?us-ascii?Q?BEwo98PastAfNJ3sC/b+Eee+6hYmTROYrBnrBPAEVWgGz+KMQ8wnjd+/zLxQ?=
 =?us-ascii?Q?9QN3msbf6qddbaNw+F93b3J8wh6QIQpZcgls1+jI5c4KuF4eQMHQ9HYt13+m?=
 =?us-ascii?Q?r/SPfuIXst5gjWf37Xz5kafWgdmm6KDz5Mx/a3tlmckYp5RGk1UIEZ/xcBA7?=
 =?us-ascii?Q?xhXXJK5Bewh2pZPEl7+QmBVEbYJUJKpqKPgneFRNXNs4rkoaZWeEvb9E9YFA?=
 =?us-ascii?Q?7kxK38q4F3DgBdeMqQMTOpopxErkaxmi7oiOZsaQw3db6Zv/zBBq0AtS6hUa?=
 =?us-ascii?Q?NhzTf2uwteWCOS+Bfneq8qohrn9Bcvu++X00wmH3oteNIocUC0gerSmujRG3?=
 =?us-ascii?Q?7rS8RGtrSlN84ki3xFt8qyj+HLJx5ObrbGvr9G8Sr2fX4katx8l2lBbXlw8b?=
 =?us-ascii?Q?HGHsSr+KMc+neBpUdzJ+0qhzY/rTn0adKzO2p/CJ18/YZb2lShnd68NfhMKJ?=
 =?us-ascii?Q?0LqbVUH1dj17fHeCOwADDF2t2Sb3rW4UdzZvmgjXSIgw/fxxsTxFIf/YjB/1?=
 =?us-ascii?Q?npfbhGnsPDYU220SN3nl3I+ozxa7/JsLJKMxsD+sI2+WbvbLSUb8rXIlAF+y?=
 =?us-ascii?Q?Vwt5nxbWPdLrg1omKL3ax1s+vcKdQBdYYeDnr6NuFrfnF2Cwe7I9zg/Zthd4?=
 =?us-ascii?Q?VVBYzhuA81qJlGckQ5Yxl4fy9CYGeA0dS7DapfJfhKhMFlryuNWRGlgzzRwC?=
 =?us-ascii?Q?kP6AAA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rWJqmUe+0MXYVIpWbIbbrKrDMBMkMejtyIeOzyNZXxZQf3b/T5B0FBnfRKdUWoRJtSBUsyzYfKEoFTZROzUtKxVNxFFPnu+yAjrGsZ8ylBVgauGSR8m/qSBWx/AxYhPeqHQyA2ZuRs0c6HU6liQ2i08fRnZ+5XwWzfMPnZ9SPEXCOT4OuALXRQIOmztitDE2g4Qo0Z8jLvuTl4FMOKP+R/bqwUZbr4QktniXLr8xIcxm3/ZnKKIy/fxKw5UvO3KlOSTMLnD7G071TWkN4V9XaRZqxjPx/SAP7DD5CYDzV3TLbsY51SENN+VvS8vOo8WX0F1W2KA9XByAcDuceQSiXdE1tVqecpIc3885jl3milyUM2qKsbFQkV0JFhSvhfnONoQ/YJwPkCdYnc6PyixdtENHcyTqa7C9zWPFdUliJbiQFCoUMHJMDgHs3MiB1xGFXwXx6pAULy2g28L0ZePyisDsPYZs3Oaws9Wh9P+HPkLHveZ18RjI78a9a4pPikeDSyXa8v8TdgAIkQ7t6byYSOAfbAPH55ZNq6w8x3cyN4w5XvxbodRwplKeIJkBBx2Ne/vlO4zavTvhNBwbWj0g5v50e1XsKfZ9qH1gCO7z7sQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc9ce3e-3958-404d-2e19-08dc21ed77c0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:58.1128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6d8VOtOAGeWgYo2sFn4XyfKFHHh36HQ1wymB9r64DE+W1LGZP+YTtEYN4fgzUR96IwCabNWo4y2tgD+IdO0NDOyu2wpm38qESWv1SUuR6LM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: WOcwAP6pfN7m6bN6vkqvDPZqr7KYloYc
X-Proofpoint-GUID: WOcwAP6pfN7m6bN6vkqvDPZqr7KYloYc

From: "Darrick J. Wong" <djwong@kernel.org>

commit 9c235dfc3d3f901fe22acb20f2ab37ff39f2ce02 upstream.

When we're recovering ondisk quota records from the log, we need to
validate the recovered buffer contents before writing them to disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_dquot_item_recover.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index db2cb5e4197b..2c2720ce6923 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -19,6 +19,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_error.h"
 
 STATIC void
 xlog_recover_dquot_ra_pass2(
@@ -152,6 +153,19 @@ xlog_recover_dquot_commit_pass2(
 				 XFS_DQUOT_CRC_OFF);
 	}
 
+	/* Validate the recovered dquot. */
+	fa = xfs_dqblk_verify(log->l_mp, dqb, dq_f->qlf_id);
+	if (fa) {
+		XFS_CORRUPTION_ERROR("Bad dquot after recovery",
+				XFS_ERRLEVEL_LOW, mp, dqb,
+				sizeof(struct xfs_dqblk));
+		xfs_alert(mp,
+ "Metadata corruption detected at %pS, dquot 0x%x",
+				fa, dq_f->qlf_id);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;
-- 
2.39.3

