Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483C67317C
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404509; cv=fail; b=dfr/mdt7E5tfA1J4pNenbP4unv1sJKSaHn5NOrHY2Mmn6GiX52vsyMAEUBxiFEY5TjmD/F8sjIzm8smZurr4N4cuM2XObsC0ooNo+fm6ekvXjEGpNGOfzIMihg2Yq6sg6+AG3Y6BElSCUp3JW7ZFYA2sV2V9mG3zS10n1oUTCgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404509; c=relaxed/simple;
	bh=6Xbbpl0CWqri/deCN1IRxkycOUv2kgFLzkS/S/LFC6s=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YVS5DoidsiGTH8wwcd4rRlIK8+9PJTnrbAzqDiKTjV5jvYZ96mT+34p9iGSSA3ke/WtcWhklqbQ9q0MHSNrF4RPEGOlWsFafQ2D5WbdhO50EVZZFAjU9X6drlhq+jenLCzXj/mQRH3r/KvVxbilMEuhFH2V45PVOJbB7Sn9MlAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hgX4JlqB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wv3RvtjK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hgX4JlqB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wv3RvtjK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG1Sk002291
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=WDZUJ9QHMLstBHKV4NMappBPTbxlKjXH4yEpwFRacWg=;
 b=hgX4JlqBaYI9K6AmTMOvBDTHMJLgFj5f9JWrrzx7Jc+yPRuivlrctlnc+p+zEnK9vpr2
 QjwS7H+2JXfgJC+PYV0ATz3DnXjxtC1b4jU9KdUdjaBWDNKgyil3+XyRsWYclRSIlMfo
 oNuByU39DhXeQ6ZOzt8hvmhQ706lNOlRMYtwi77LLNCP8h64kpdwPu1jxrTWz1sO42So
 2O89e2xC0YVstEaWi/WeqdPdeGEprXWK4RWvBtI9/EyVCDVL8oDGbO46xSxy15Ax5y7k
 dVh2kdyixLMosDnIVZ4xuMw+h9o8NsCuz+Ea4dfM25pJ7xhQwJmNhQqYxy73Bhnu9hUl bQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2btj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKPhAL015960
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64raq-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VV2tYB/nq901W+h5bccCooFaX2olWCDnpcvaLgI2bSvVepx6jTVaMlqPbMo+3M8X23f+ahdRaIoBv4rm8xKZq4nSKlR6fs1P4GZoJzbfIfimF6cfsTbxOgvyePU5XrYklCig4f0Yi+7NHXsLM7eS/ntHnsNDf+tHRfbBW7yegoaZ+dRQbf7WIWcJmTqhduXmxDEKsd0QD024bCB2om8XM6mhqvLBSdTm1XtM/biAlnFvNG4WVMSS6oHDAiBiC86jRsynxDLvxgRoHaUDVlYbbwm3ka+MhEyldYdsLBQFTeag4L20xoPhOVKHqItjn5vJMwCpsCOMsxhVC/o0SAIefw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDZUJ9QHMLstBHKV4NMappBPTbxlKjXH4yEpwFRacWg=;
 b=n7KJEpIovV6wmTfyVBrdmEvVuPEUahIPrmuhu7WRxM2mTl6r2+Kuex3vbagpQBWYdLKMydl/9CrB1R1MJGn0zZzr25Q8yGPrbhIW9tPgfZO2fYj5XSKjmJYpi+pCcLO18eZQTODdJOvnmIX3Kuj+OdvSR+yApTZREcI/l7ZZnVqLR+eyR8cuWfnHjrBxy3t2t+gZOn2oEi1Df9xBrQyODrOdeyjsjlN26NKUESZOeb4TGrAY8ug/atJKfgTK5o3XoZJR6tw3AuGSWRi+v7WunpawtmR0Lsfna1dyEv9RVtiO42G907Tf3+IwkFQ2oCBj5xCfKd/LLkO+5E8L7Y3B0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDZUJ9QHMLstBHKV4NMappBPTbxlKjXH4yEpwFRacWg=;
 b=wv3RvtjKCEcAMPmO8laaowhQiQb4rvTLAvc58I0+VlucjAt1b3IfyUkuMjekgzamnk3t2k85liEd8KF5A43pCLVbHnBI2tyfA2IXeGDVuoDvdFrQnGrW4dDMjG75bkrYiJAocib/koSKKxzM4adYJrhAzu9f1FKB00nGyGw4hd4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:15 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:15 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 22/24] xfs: update dir3 leaf block metadata after swap
Date: Mon, 25 Mar 2024 15:07:22 -0700
Message-Id: <20240325220724.42216-23-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB5005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	LWWLH51CaslmMn8PVe5/tuEN927xh78KO5Cl2DQLeinVKpVHWxgUVnwq0NqMbCjb61wECiZqDB3u9RvDt8KvDR0fcixfcvxtD4uKBhgENeugbBpQw2FEB11j8EPUItkKCQLzlp1TM0D59bpERT9Is2npjJntmhK8/oz/HAD6alEshVMY4NymquYuWeoAKfHf06yVnyw6yc9SkJoa4GfXpesWYqKY5M0ajV3jCd+klBh7sUgHGOtg5Zs0HKLbMdavSum2G/Sc0MwPG/bgxkJmGf2bQfKeYHp2MhPHx/Af9T+zj2xcGkO62D/edyTvTD4vBYU2Q8a/xVpylI9yGFTuSpx4DK+IOmub2jBIFCNbc+/8fQ5vexnZPNrfoajydmHj8c0QKASLOUeR+ZphsYIlr7BYgrIUXIzfbJuziMrKdQuZ9PHup6dHeJTMZjKZEJu2WSMK6d1rtvrYQN7INz/RHbTkNbF0QWXQs7Yu1s0rdeBr158W5E3AyogPHPG1OwcKmKl6k51tVndpvX/EnrudRoY9J1+UqjBTNdO3uLiYr4xjSKUtQva4kDHA1R3v50j1DXBflPtzKCns8wRR6pmOZbeIPfOw4mh2EtvkeYdpREnKVZDr5WLoyc6VLNUX/P90RtTN+D8dEfwCxzzUwlQTX11pLg5sp+3ExGsFlsvukmY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?1+WVM0mQkszpjsRp++O6S26+mZ3QF1cedWudVvcE+CtEgipXNbIhRx6K9iiq?=
 =?us-ascii?Q?y/9IsHS6gEvuYI+fiewy91ZCPeltSlEdut2e2icj+uNydxeJJz/qYs3V6blg?=
 =?us-ascii?Q?P5Ew0v8MlTSDSuVcCqneH0lUZTOI1Zh0OGOu6b1D+9Ltuo7GnREqAFqzssZ6?=
 =?us-ascii?Q?reELT46+uh/QDWKPtAUEm44ocknLF96wuvU8Hxp3TrrZSyWNC0K3z6CBUHfe?=
 =?us-ascii?Q?+AOZNCLy8SEhgs/pVWAvBzf+ZokFqZpPI4psOZ0OQJpGDL7gfcuZ2r8vJniD?=
 =?us-ascii?Q?6AA6EqJT9801UEHGdkPEEna2VWWcwcH/QgCBYHH5tEiyPf1LlRrPSdE58+PS?=
 =?us-ascii?Q?AarcXMuPc6RvJCtsdSjdP7j6Atnc2WZ4+CgqNSY89ugarSPnL00uI5Ba98q4?=
 =?us-ascii?Q?EOJbdiKMGRFfWXJUa17XvABXdMhpdQpp7iMLZDMCtG7SzBdCs7b0CWklyb/U?=
 =?us-ascii?Q?P4nweX6ATK5Qok0fcayLViqSg6KDxIKhCqp2g5eeaCLlImyvJ6B3VQFNp79q?=
 =?us-ascii?Q?gYVh7n+w6B/6S9+CqdP+J60E4e+8KcPF5PevDg+MGQ9Hxbi6f8kXVMmgbWW8?=
 =?us-ascii?Q?tqc52HFG/14LXMM4NNs+oMD0ra23YNgaS9cZheGRuN5BMR2V0TnvJUMPVx49?=
 =?us-ascii?Q?b7nYHTf0IhPeFnSNWD9+5Ow7VSTYXW3MOegUJk1KG7Pc7S5x6qhMy4KfqFM6?=
 =?us-ascii?Q?1TJs6n1kvg/Z+NHUam6tJN8YZ7wDsSrGspIFL+rxG/9lTTjhZF4dj7cDTEG4?=
 =?us-ascii?Q?zUrILg5UuPGy094UUy+5iae6GZ+OYOgS22NJ/AKDMzxngK13+ijU84Ah+e1K?=
 =?us-ascii?Q?/mBWvJPX+T8Cah0YNqxwdYNdLz2hGvZju2Dk1mrLAZPUC7j8SpBy1Fj7WhoB?=
 =?us-ascii?Q?oJ30wy7g7ZbvVmj2G6IxRKnjjBNVV7rHZGo7Szhv+PZUgQU1O2UbdOyXhd6H?=
 =?us-ascii?Q?2QSDoF8PjGAi52/don3tnJ7dhYKDXPY0+VaJ/Nu0Jr4F+wOVf+V6lju+fBrZ?=
 =?us-ascii?Q?Wjxhm6b/oWfee5IQmN0tBgV2XHwjifGtCucmHQahzIWnqYPV7M+2cYbQPLrW?=
 =?us-ascii?Q?Y1NXXqeQw+tLMLYL3FIAyayDjLK8kE3uc4AGQgmXNSiV/egmpg8nmbyjfEhg?=
 =?us-ascii?Q?8mb7d+o539ywOOSlS9ffDd2XsKEKOjyoMleLKALlr8jZXqCHox2NSbd0q8X2?=
 =?us-ascii?Q?2L4xJujo2Ds+sPvDSaGZUzxM54XUxEbdXQHWCBysngpf8FCzn160CtNKeREF?=
 =?us-ascii?Q?buvhkXAGjy3+RQg1XISRvvR9oJRj2WRnj8LRyQT49aLmLTneChQ71w2TfenT?=
 =?us-ascii?Q?aQMyMrX1RLm0NLJ2Zwcg5Vs2LKVFqvNMUVs4uHpLfvkdxBjabCj1ENirnmiN?=
 =?us-ascii?Q?OmGYFRct/zijLWiDkmxlp6y/zniqkhjcj2mF/Uw05zWS2yNQoXtxd6pAgmKB?=
 =?us-ascii?Q?GYalztmWRW0z838CKTN7zeAUAzy1LrF2ojGUW9AJ5zDCOKbx4YEEX3/Ki4Qs?=
 =?us-ascii?Q?mDKBhTfDrj8SVYaCMvKLuotxxI/tGHeVv0q1uNyOwQv+qplMRo6yBBX9eaPs?=
 =?us-ascii?Q?zo1mksZ+gZCeTZCV5NAzg8N/8vSZ48O3/hUSrzymkJBceZxGRJkklfVucM25?=
 =?us-ascii?Q?yf8hnDqE0/V04N/z0AY7gcmgwpSj0gkt36xZeElhN1wOaL2bBFLV5XXGqSPN?=
 =?us-ascii?Q?0QZ82g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	1PkWf+rm248BwmrqwBZA2REhVoFqJt9rj+Kqx4u5r9osEiAKMcBpDKrzspSgMsiFj/K55ImqqgiJ30ECKZs1OBnywHFtis4aziZUj6+cJsPlMnaJdPxwYr2c53Y42HgNeKs21CiNURjn31nZ/jt5NFGxlgPkINzeQlxUZL5bFO6s3NWsIsHD8V48VyVuPQzM8UiPpMbSMALjLEENdMndZE7qvagaY2EEkzMyrKmxBumrLp8uDCAdgBiV94m+npUdp0Uh10A+3KzJeTN3uiOoxJx3yAf/8KkjVSUbew1YD6j8AedHr/Yb5QfhfXkMrzmmdQRvXj6izYc53SwTxVvDG2+KRvVQs+2EuWNQM1DS4ILWISgqh2xZT2SkWNV4ifiTYUFXzzm678Lupd5cOpGdct2Isjz5BtqVv79d3Uypyd70rs9hF2HxmWjD4HMineu0R6jqGlDwJrI1YOKE5R4IkcQKbJ1yKRMMuxPVMwZqcxZxN6AXMXPSeZA5+DVoxMyJTcYX45o9/1djfj+9vL+SNj7+vd/A8t9VvrK3OHIk+dZFcnZhuDyTJnuiRBnXIDiq8wXtZHdhJX5C4CQMaXM/1kkyq0WAXQmZ9RGrVA10LKY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c7472b-b040-4269-bd6d-08dc4d1811f5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:15.6833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkU40wD4qz/g28RKjOnK5Sw3jdHLNcMDksGALRtMHUvD3GWjsR7ZyvIaOA3ih9r4W6rpNYSWuw/iC759O4k9yb1Y0KoLhFZ4zCZjWBaqR2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: 3DXcYVlOMtF6dVn1BVmew2sVUJkioBy-
X-Proofpoint-ORIG-GUID: 3DXcYVlOMtF6dVn1BVmew2sVUJkioBy-

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

commit 5759aa4f956034b289b0ae2c99daddfc775442e1 upstream.

xfs_da3_swap_lastblock() copy the last block content to the dead block,
but do not update the metadata in it. We need update some metadata
for some kinds of type block, such as dir3 leafn block records its
blkno, we shall update it to the dead block blkno. Otherwise,
before write the xfs_buf to disk, the verify_write() will fail in
blk_hdr->blkno != xfs_buf->b_bn, then xfs will be shutdown.

We will get this warning:

  XFS (dm-0): Metadata corruption detected at xfs_dir3_leaf_verify+0xa8/0xe0 [xfs], xfs_dir3_leafn block 0x178
  XFS (dm-0): Unmount and run xfs_repair
  XFS (dm-0): First 128 bytes of corrupted metadata buffer:
  00000000e80f1917: 00 80 00 0b 00 80 00 07 3d ff 00 00 00 00 00 00  ........=.......
  000000009604c005: 00 00 00 00 00 00 01 a0 00 00 00 00 00 00 00 00  ................
  000000006b6fb2bf: e4 44 e3 97 b5 64 44 41 8b 84 60 0e 50 43 d9 bf  .D...dDA..`.PC..
  00000000678978a2: 00 00 00 00 00 00 00 83 01 73 00 93 00 00 00 00  .........s......
  00000000b28b247c: 99 29 1d 38 00 00 00 00 99 29 1d 40 00 00 00 00  .).8.....).@....
  000000002b2a662c: 99 29 1d 48 00 00 00 00 99 49 11 00 00 00 00 00  .).H.....I......
  00000000ea2ffbb8: 99 49 11 08 00 00 45 25 99 49 11 10 00 00 48 fe  .I....E%.I....H.
  0000000069e86440: 99 49 11 18 00 00 4c 6b 99 49 11 20 00 00 4d 97  .I....Lk.I. ..M.
  XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 1423 of file fs/xfs/xfs_buf.c.  Return address = 00000000c0ff63c1
  XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
  XFS (dm-0): Please umount the filesystem and rectify the problem(s)

>From the log above, we know xfs_buf->b_no is 0x178, but the block's hdr record
its blkno is 0x1a0.

Fixes: 24df33b45ecf ("xfs: add CRC checking to dir2 leaf blocks")
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e576560b46e9..282c7cf032f4 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2316,10 +2316,17 @@ xfs_da3_swap_lastblock(
 		return error;
 	/*
 	 * Copy the last block into the dead buffer and log it.
+	 * On CRC-enabled file systems, also update the stamped in blkno.
 	 */
 	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
+	if (xfs_has_crc(mp)) {
+		struct xfs_da3_blkinfo *da3 = dead_buf->b_addr;
+
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
+	}
 	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
+
 	/*
 	 * Get values from the moved block.
 	 */
-- 
2.39.3

