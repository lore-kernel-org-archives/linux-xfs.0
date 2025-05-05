Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDB73EBDC5
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 23:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746488166; cv=fail; b=ivjMhvfJc3tv9V4P5DZYpXkakcnYCbML0ThA+k9IrJ9+3M1KuAvGYCu+MZN0VHQtYJMuHyjXsR2AqiwJfIyMo+lpb7o2u4k2B14JdCUHcZYe08mgSaNd3FUGGOzMkebG5Q6NiPGAsq7i8qNHX0O1ayYyzj1h6eizrtVvy3iTZ4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746488166; c=relaxed/simple;
	bh=yVn6GiqkMKhaydGbdoPblzSr5XMFR+/OU9Oa+6QThQU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=hWTJaP0CYO2mKKhIC5yjuGFNqm4iX9oaal0TXRURLs43twP2U0vartnAwKDEygnEr3d0149h8GHQfhWEBFkFkdtl3ZDOWgaMpSWFHitxrKUNARj9n1G8gbsnfMucXTySCB0vssIz392D996wVyMoDbhKe+tGPoYuDpgesF6bxOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oJXGiYc+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mDAzUlVc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oJXGiYc+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mDAzUlVc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 545MiwN9025632
	for <linux-xfs@vger.kernel.org>; Mon, 5 May 2025 23:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=O9J135sV/+cmg3DY
	QPlDDISscbxMZ88R6LVHrrU94uo=; b=oJXGiYc+6vGF6LdF+n2PNtr97n+h46C+
	+tuLNNOI7xaVpeINEEVLiINXrrsOBbAxASjKEx08caognnD4dPvhVHs0UIUEeiPn
	ZaOmEeF5/oQNWuJi4vGWqRl6XS2zNNj2taGl9aB3wo3EV2QykwKgOoY+7gMcDJlv
	oDqea+Er0uXQ3SPplW90zvY2lSgS+4FICEJjVKExDEZDrfAdRkdqqHGDqmZIyU8N
	UDz8DWfGFqf6C5vZi90c8YzyKgUIa2YVDJlgleljRtL87raaireHAj7PSu4yGjZ2
	sjlSUq3NPb1Np/axC1PFSfWzhTMKHqWRrVsgRxwCzWA3cC04QPBG6g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46f69j01sf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 May 2025 23:36:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 545L2ON2035632
	for <linux-xfs@vger.kernel.org>; Mon, 5 May 2025 23:36:00 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012015.outbound.protection.outlook.com [40.93.14.15])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46d9kehv8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 May 2025 23:36:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wGmqsYdZ7e4vPK4AG/EBQxbocIqlssDlb67oxWo24Yr+tgTopkTo9unC/RMOLAfraS9xPjKeEcKsrjLbybYbd6GoCrZQjU483bUOD2obdoI2QQAjxed9O/vVt1Q2HsmmZicvVqaKKMCr/cZG++OniY2imu6fl8e7c9y2WWwwNsuogRaMxxZOc/C26+mdykLMI3TXb0XaZLmxFXuhMxMdAR9ImtaqG16yZNZueV0XWHsQiJPbMOJ16HnuBen+aC9dKW13jqMdE06YR1bSXAHv69l6jlD+xr5G3v/E0jFJ+hdkZ+2QVdc/Fb44XXyxgigQhSr/q4DELJtxASyQzn1Nfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9J135sV/+cmg3DYQPlDDISscbxMZ88R6LVHrrU94uo=;
 b=JhYLZ4v96/YByjH/stwUaoWyzHWd089b91mrikOaSl29dNLBC50xP7EpAZHNVOgqjNksxL2MvLuiIkc0MoFSmZdduQmNOWh7IBGfzd6SJgWtfp48DenjU36TQexXDwrwWNYt8ooC+cBFlM5+NLJRqNYObNne2RZTKf5rSYqr2AKNQDlen2f1DZ3hM8MQoYGpH1m41+edc7BDzmcW3tkkAcVYHYA0BLr5EFxhDDmg9kjOS4XFg+JKT1AVCD/9jh43JXakwUw1bZqswp3yoO938c4brnKbrKsdSKwPLb05GTgVH0AZrb5/pDPsL0JlAA+XAhyFN9A44J8hxsQA4mF2yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9J135sV/+cmg3DYQPlDDISscbxMZ88R6LVHrrU94uo=;
 b=mDAzUlVczh27/10Ts3cv1XwBEjEIul6RENeQKV2g7UCqIcQWQ95z+wQzyiLyXCSC5wiZUZaFOjns7bbCvtfXiTyewyE23ZqZTtEQjYNRkUHzLpHpM7RHVbzztKoRBL5XcyrE8jV2/fKAh5Ta4DUEvcI/3VlWeF0cbQy0Al0RRxQ=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by CO1PR10MB4785.namprd10.prod.outlook.com (2603:10b6:303:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Mon, 5 May
 2025 23:35:54 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.8632.030; Mon, 5 May 2025
 23:35:54 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH] xfs: free up mp->m_free[0].count in error case
Date: Mon,  5 May 2025 16:35:49 -0700
Message-Id: <20250505233549.93974-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0047.namprd02.prod.outlook.com
 (2603:10b6:408:e5::22) To PH0PR10MB5795.namprd10.prod.outlook.com
 (2603:10b6:510:ff::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5795:EE_|CO1PR10MB4785:EE_
X-MS-Office365-Filtering-Correlation-Id: e99ce6cd-d36f-460a-67e7-08dd8c2d93b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?htL02FGAvILoSzV4MFUc6Z3rb4dYeSi519HXjUtTyB+3XbgLmgTBu+WKZdj6?=
 =?us-ascii?Q?VUSwEKDqeQabJjgEriOEbvcYCG4JlKADd7h6iyyTPteMPLbBKYKX09s0sXq3?=
 =?us-ascii?Q?I2gk6WbUCfhv28Y/XMsYMouePuHNg27RHPxdpBj3MBLcvAW5QHRO83HrNSsg?=
 =?us-ascii?Q?Sva8Z0npZBYlEa+0yl1R+8yWBwwxB5FntcCANRmQtBhPYjmnVvgzsGNEfjPZ?=
 =?us-ascii?Q?JF3NlqbdwdpdQy4cHK1x9wVXSVw291D661cQn0didKP0wLK2T+MuiFeqis9x?=
 =?us-ascii?Q?zuuSgwu4k31Rbz8xS99crKzwkm3vpkAUXumerSJF8jDCWcNA1uRIGuYGeGSD?=
 =?us-ascii?Q?vhwxde6EloUK1DCBe8+tOoUAZTMmKHC+8SIlBWKcMwxawCI5jvN4+COqxBBL?=
 =?us-ascii?Q?SlpAmd1hXgf6QFjs+UT6Z845j+vCA/1gP5Vy8nBOlVrqTu95puhYjEzBcO5x?=
 =?us-ascii?Q?fwcebs9xNo3Knb4Kaa2dgaZV7nMHM8DFEMtnlewWIpEp0SUMRJCAwCjczVRD?=
 =?us-ascii?Q?Q67aJ6GEBeuWVC0eU410MVyWDexEIgB4+/xJicS7AMV23CQH8MYf26zMf1kV?=
 =?us-ascii?Q?yBDSJr4P+M/i3cM8TYJYtzRT0qV20JMwYelq5SNfshVdEcZByPbKvz391cBl?=
 =?us-ascii?Q?KyC+Fu7QCC3VlTW3qxF8K7XSKkGGe1d0LmAa+H9l05s4yCH5LuU7kt439d1o?=
 =?us-ascii?Q?A4d4ko72McwnJiqFAHrSViVLPp7L+f4eJ3rUFWnHAsOHiNDJr8kEedB5VuI3?=
 =?us-ascii?Q?WbbOS6BJbo3ODNS6JHVs0wVJZbrqyfFxcg7AFyUKHH/cBeuVdoAlJNy/H5bT?=
 =?us-ascii?Q?UOSCAAAAke1FVXdPd6sP2YSZGMTzlUTSbBJ/fjf7l0hOO5g6ncirsosYYbny?=
 =?us-ascii?Q?5kMyqy3p6JqftMEjsrG+NOkU8Oxjhg77+xuz4M1C558QIcD/F2o7JXp+vTeE?=
 =?us-ascii?Q?xB8zeR4ca1XQ0O2rqfqzy3TBAWyJR28UVgPSsQxsUlY8v6PREyr0rSsTRfrw?=
 =?us-ascii?Q?Xdct1v2lzJSrq+EeThmKloXoOPrUmBJ50AWNf2RolS29lX+DG3FwirJdU4s0?=
 =?us-ascii?Q?USlplp/aKCQCqefFEsZ4L1wTXzqY5iBiBv4PsZjU/exKPRX2/GdARW6OMznh?=
 =?us-ascii?Q?eu160sb5kjHOv2zuJnqsRERrLVraSD5xU0hNL2X3nZooAXKJ/ypUM682tC76?=
 =?us-ascii?Q?0OU+B981E24iP19QjqrxPF9AOefob7u5wNDpZIV0/k9kvZHpKa0p5nge2Pri?=
 =?us-ascii?Q?fyTa60YSlotJ99EimubkW1nHc/1pHVA/FXnK1LVBwjNfiTJJ6TGnwg7Ff0i8?=
 =?us-ascii?Q?CohBzM5FkK66FDuxhqYmhy7jB2estMK4WzT9TDlaZzpvmuY9+ehyp1kBCZbP?=
 =?us-ascii?Q?y8K8uOLKEPugmwgFS5eAsqVbZvT1ZqS9B3vrCPvpLMuetBPIITJ2oUFpZ3gD?=
 =?us-ascii?Q?PJux/WudyuA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NQI3/YejtYvD2mxn3MMm9wBBP45VGVXuua1XIipo7Jt2pEyLT3yF9yh7OoLm?=
 =?us-ascii?Q?1CoAcHgvMhOF1u3pI/x9NbdIEDL5qY+V1jAB+c775H6qlh5gunAbi6DXRxoj?=
 =?us-ascii?Q?aYv6rQnHST21uYphnf7Ww+TDUarxVT7GmpCDcEJfyvXjB8YZlWqCGmQjCYa0?=
 =?us-ascii?Q?+4grfCAScfvc71WGf2Rc/L0BvQOU1Fw//CZGytJ5JfX/chRlEyFt2Lya9bz9?=
 =?us-ascii?Q?h1oBpqZee+/wPfz7nqCmgzP1ADFWsxyMh92WwtbTZhY1rvBNGaQ/8t1QZFZ+?=
 =?us-ascii?Q?eH6LQwZp6CqPQWOZVkhr0NK9tGAYK/hiHVe+Hn5Y2Axeimij7PLnvwcSlRvy?=
 =?us-ascii?Q?+n19sTJtcDObqPNs+L6Lm+8qU5Vf5lsxVtDPoQmbRFl13e32n+7gfL3+jMvK?=
 =?us-ascii?Q?0RDsOAgknEPQERO+pmGAd9ujd5f39Tj8Nr25tDmlLoyLdL5nH6+NNkxqWE7f?=
 =?us-ascii?Q?DCkTYClXJg9qwGt/RVgih0SzQwZJkKC0rw5zVj6WYOCNJ3RIBpB/2tkaHNPc?=
 =?us-ascii?Q?xk8yn+V1eQtaVH5NPYTGR9z1ncUo3tI1JkAgxBXrA/5DXeP3yxzM/3kIVke1?=
 =?us-ascii?Q?UYW5pluyHJsXmzab6AnVvlLkwsGKmw/rxTxZOC4mUBb+T7d3vc4V4JK/Txwa?=
 =?us-ascii?Q?s7zqEgIU4fDO7ow+ht6l4uv3ihmACzGWvK9eiX+I9wt206s/t3cTN5tDmR2V?=
 =?us-ascii?Q?1lwVr8ZH6K5lVPgSDxMArcGdbel0RHZFDdMd0ayIDlWixm0w+zCnNSBZqAux?=
 =?us-ascii?Q?W8UPD6Gqk3oJE/7L7NUMxqLSk+nGp29i5mf75uDRU9ns3cMvEZDc32aRW/Mv?=
 =?us-ascii?Q?lxL2AnqwMzYh6wQe0MK5swQKUgsRcaHgQyYEXFT1V9NbqDGazKS+Y34igJ6e?=
 =?us-ascii?Q?KFGk2s6lMNZfG08epnJ+m7fBSrSn+n3yKZD+uC1jtE51VzXpL9lZ44v8oC1K?=
 =?us-ascii?Q?CqLsJiT21i6DZk8caS8MaDnwU8qRMDGkFBgTn09ccfSyVHSosGqw6VbTCOD6?=
 =?us-ascii?Q?QwlBYoVaboGdy/kmzhhIEw94qFVT5E4nLRKEA73m+Zoi+d1yiv9DqAmg3vyy?=
 =?us-ascii?Q?0TXmwG+JvAWlqe2Z+mHGG7FWCqoFwAGn4gVYCkdMZm3TwBURUAxoJTFdOZ5t?=
 =?us-ascii?Q?BvREj+XIjmAmqif2+v7PA6LRo4x14sas6n4Wo72E49wW6yPmGZW25+ZsLjCs?=
 =?us-ascii?Q?8JbdfJy0D/YdJgIrNnkvCWw6c8p81RHi0VoQnEk9w+5GFUavEhrugse3CoQh?=
 =?us-ascii?Q?2UHA9ac+Wp9WRBfITilUNupiYJHd/KgANp33LHQcnMep/Xeb3VqZZUWC1DwJ?=
 =?us-ascii?Q?vGqwOHAR4kinvWGcAAt/NOGrXRAfnUhl8VtFPqY14Co19c+BSQGnvSUlyhjf?=
 =?us-ascii?Q?gUpY8TV74pT+Q8f9SsYZzMDOS4pwfw0FcJKiALlvbecZbrn5pM1T1HK8Ascb?=
 =?us-ascii?Q?hKVaBvHeUNOLIvQZ/n7x+9/LXxVmvtSSBM5AQ7gH4eRIMS0vLPcCE3I4edJ3?=
 =?us-ascii?Q?wvgZb5qgka06snBYyaabaQyy5aJ0E5/zcb4KoUiZLkorXghhSBSkKRzPTitr?=
 =?us-ascii?Q?yc19kXhWYz6bNCT5clW5sIbQINAusgL3yjE9Bjk16RDvpgWOpjyVrW+LzgGZ?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/lW/T4aaPZdhRX25s6kgRLpraqrLfAv1VZurKPHGL1RIsIU2krYETfXwbIO+KtKa8SUxC7dxNujkfPdO0foF6UCIUlRPpwN5U6+PEDYIRfLiBiKtOEi8wg2BsmG070TZFvQ2kfh6PZkK0HaUoIqE3lxgINTXbUBRTQsZ9Qrqsyq8tfSLXh4RZ413o7MG+lvt+BDXyior2ZvEDQ2tkE9PVddCpfwJF6x8VSUaUU25s/G/i7I30GF3lqtl4HQwF2eM7OMMmTMtNjJdkAVtNKOSv9EvCmKLTzFIyJLYb4KCrL81mqNjZYrHHEZpnqsIc1hD7ggOISsGWvZ4oLfgSULlIYQfSjIgqvazdXNTbKLGVzDA6j0mIi/ykiQ2+Wjl12LXKRy2sEh1huZvA7lCyx/vvN7YaBP86lF6ihl+0Osx9naOWmqXZHdBn5IKGrVUzaZ50uME5I1IZGWhVzTo6XRQlxZDn1OjTeowznVVfKrg6gOpsfEcSuXVlNgokhGVrHc+m/sK7rU0bI5BoE1ZEYIF0iak+8UxpBM+awlTgvJSvaLSB+yEFKjqXOaWMHByGMiS7T3VPHRlimyxGxKPVqST4vbzyDrrY8Oooa7fmjb5y88=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e99ce6cd-d36f-460a-67e7-08dd8c2d93b5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 23:35:53.9656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1qpbhNCHh5RajexYu2Wl+gzPutNcdAtAmC2ZCMoa5V32/kvw5joijOgbAsVaP6neqoNb4Isfo2zklaGIXxvMlWWkyA80AXGNmV0GyDgaOJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4785
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-05_10,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505050222
X-Proofpoint-ORIG-GUID: g8HY3-7ZrbSGvlo7ZRbPrDiwi3LnDW-I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA1MDIyMiBTYWx0ZWRfX180nGLDa2wYL 5tc4U6AwgkkIsR9YxI4ef1oXC1oFxaZZ8f7AuoON7lMCxSrhuFUaARDJRVnIc0C5dOLPO3i0LcW WPhr6GpUHfZdKf07OMik6ct7/dcPwl9GjaFtfdwYFROTvoo8nnwBY8CBjhXQaPdOqNATPzsKwvz
 z+Pd8jUfgC3J1tFmziP8wdgvHEgrFSpjFs11a6lr5Cv1cZl+BNnympLdheF/Q0M1JzrMzaYiM5B kYOncyZfxUdhh2LnWjUbnSuIYsRdqpMJBm9cFgVll3dOIwIajDTISZpuBgr37aa0R5yHaChoN5M py+2vdf0qnYUdJM83ZkPq5um4s7uR9T9Xi4zzGx04BmgtAS+eFMCL44bfXta55SPMMExgYJQev1
 1dREoauu7dQCrx0kWcFfbR+DDReu24uCFXENLSu/rVO8zaTpW3XauBxzw73nPDe8rvLnvyfy
X-Authority-Analysis: v=2.4 cv=YMmfyQGx c=1 sm=1 tr=0 ts=68194b62 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=UnlGdW3HSgoy7JPTIMMA:9 cc=ntf awl=host:13130
X-Proofpoint-GUID: g8HY3-7ZrbSGvlo7ZRbPrDiwi3LnDW-I

In xfs_init_percpu_counters(), memory for mp->m_free[0].count wasn't freed
in error case. Free it up in this patch.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b2dd0c0bf509..3be041647ec1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1149,7 +1149,7 @@ xfs_init_percpu_counters(
 	return 0;
 
 free_freecounters:
-	while (--i > 0)
+	while (--i >= 0)
 		percpu_counter_destroy(&mp->m_free[i].count);
 	percpu_counter_destroy(&mp->m_delalloc_rtextents);
 free_delalloc:
-- 
2.39.5 (Apple Git-154)

