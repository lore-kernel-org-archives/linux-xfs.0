Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AD64B5A7
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171630; cv=fail; b=SObD0wutk5wQwLadM5YmEhf4mL09VH3APUxVb8gV9KMo5VNsE3+kPIpdtYWcLcwYJZaOm5Q1FyevnPt9Qu2mRwl9l9AfVEjYcUgdAl3YGmndAmCXAIZJN/4o311qMKo35PEefOKoJJhJX660v65ngbrDU2wzS6Lr92iw4n5sZn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171630; c=relaxed/simple;
	bh=eG8awgkBXJqira4uL1/ZlPFLa/Fs7ncDGlTeGM5stEI=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cyjQVp2SwKi13T87A2SNQ2n+vgPahdA6PjrzT/hwA3FjQnQFOh07TjY0Ra5sMD+M6ATFdwpI5HQzq84NdURqi2SpEXDrqEbOzlJdRTkVqubtiVzSflCd/ru3C02uIuiZdrQa67mBvbHQobXgWrFU6b9U4nl8zRXV/ZFesCb1REs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cl1F2j8/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mgyA0E9H; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cl1F2j8/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mgyA0E9H"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LDt2G017352
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=WtMU5f9cz3oVb9hB8U3CqlFrG1In6pQNeER+/0nkoMM=;
 b=cl1F2j8//FGbWhMm9QcUqMa6NPbchqXcvN71NI0dSSIBJuBfNYushOQrb1PJJTRwWvcB
 dhX6uXaaY67bjc9XevPrkCq3VQI896NPmcTiI7CvE8fNTYkPb3IshpaSGo4iK//jYKi6
 SxRe5i22VkvoCO+g8rk5N0KBEAuifDkzT5iBsq48zvbeGXVm8w3g/tJ+DB2t/fJZR0kH
 yHmQABSchUwxbgi5AOb8hCMBQtACqUF5eR12Tujai1ao9GO2yL4TBUjpbaASKaYFgLoS
 CZn2QGugtZB1ZeWqNxfoUpO+qWmOZC/ufKgTVAC91MHagfUvqi0ct6wCOPzuSe+tMs06 Lg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dhdda6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415LBaFT007074
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6k59j-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IymHI2zAyBaoudiBrLDGROakRC6qdW82Qc8DbWaG/MhTTpWN+RE/ERLX9bIcw1TVPMG8sav0XvDj7ESRTIMhx2cU2sPlJRY6IkawEZCNkkx1FryzwORYxZhTFb2OroOhnxcLqLKgcnCRdQzeX2Vnjy4t4aVjGlf0STUjTs0r3nTaZbmD5pIgtnWLycd3UwG1e8t8C3pb09Y9UXjyFLkgqSjl4xJScY5YQXqs8azz4nQI28cnJSZnKOhYcJcU6uL1TLTs3jzXb6sESKpM2/vWdeg5Ye/+jIuZUl7MqiYH5//tCb/zNdgqEqFlFzye5JYFoRUB9Dq3stvYiuC82Oj1YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtMU5f9cz3oVb9hB8U3CqlFrG1In6pQNeER+/0nkoMM=;
 b=NwFoMh/49SjDmJtd4h0CwAK8G5DrdtwHWXk6QMePJ6a1ii/lIzKqeWw5ToBkX55qwUE+7vY1eh6hGb9Sy0Y5+z2PbKiMC3Q+meEDrCpY8l/f7bcZH0sNn2F6eznylrdXQDsT4Q7CaDufd62/YDK9HexlsKc558QCaZqdS8nPYd0i7VXhfMvZet3aKEZb2cJL/LLHQGTHk9IRN/JdefeQCYrD83H431Ssq9tUN8SVoWWsy5nT18YeoDRmcfSwn02nwLal99BcxY6uvvGydv/2e4AChOo2+kpgGySsNdAY4CD/7R8ASMvnAk+e4MqW7Xinwozo1yX1dqyOy9h8E8vbbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtMU5f9cz3oVb9hB8U3CqlFrG1In6pQNeER+/0nkoMM=;
 b=mgyA0E9HQWdecyvJah54Crv5jrgwBxhPCawyDsFox3Ze9Id/H+NUmY2UABjFEr7ZkONMqudKhEmTtR0fEd3rJdfWdNM7oDYuWMK+bOTirLaPCT8ZT9gChTGQ54lywZL3TErcQtPeBXLnPyrhn6odwKB2A+JDZV4Wz0S/m6TLEzE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:23 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:21 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 03/21] xfs: hoist freeing of rt data fork extent mappings
Date: Mon,  5 Feb 2024 14:19:53 -0800
Message-Id: <20240205222011.95476-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0174.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 67ea96ea-1bc2-440a-253d-08dc2698a47d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qWqx2dO1iR0iKL505N2K1+fzyfzlQJs4WbsiI1cPc1r0YqglWPZZQAJRYrqdIRxcfRJ2RPASZozFc/EgRQkFjdp3u8wuS/6yWTcdsb0P176BhrFU8fDtQjMk84FIIdudrCcaQ9zKh80V3ABtTrRPMuIHyJk3laW6UU2E9fkBAWliS3idn3sJM9kY3G6DQ7BSfd14XeUmwUD0VF+51ycvNentPuyYQcMsP4CAEjFA8E6hkgAZA17KnYpyvlIdByFbGg/DYIbvxZWUmdYs+PHOz5XRr8p9tcx9jSHXmFSDwXQX5mNjAW/UkRdqtCaEchR+PMzXJQ7IvOJj8pMlwEd+WrvuzLzdpdT77ozNFoJBjmnztiLoWrnh096IXe43C9VKgpEgvzj+NIt71fF1MJlcoXyfgBJ9R2YwXMqBpp+oeQ/cZyoEITKfI3vwd/jDPk5o0vhET7fqji6ZRNVG0YB2kNW7EEVoItFtR2pegEsmRx4sI3G+KNNZghOjnKvEKhbSyXr6JUHsenUbn15FqUch4W8ATsg25nQWGIEqI0w+TQzm50FMXPy1ggS6pJQJU6PJ
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(6666004)(316002)(36756003)(8676002)(8936002)(6486002)(66476007)(66946007)(6916009)(66556008)(44832011)(5660300002)(2906002)(38100700002)(6512007)(86362001)(2616005)(478600001)(6506007)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?cAdd9sw1K8bJiXekCH4n+ajK43impFu+e0v1xmg2dCjOMgxKIurk6Um1q/Zy?=
 =?us-ascii?Q?ucl5BiFjEA1svMMyXuMXB2b6gLNWaAaXTJSU2OYdkKeHz4Ls9MC9yw2hC400?=
 =?us-ascii?Q?REy7dmu6Cg++GQqmTWw/J+GPbP4CrZ4OShwO9LuAMyDRcuiDnFfo2HKi4cnY?=
 =?us-ascii?Q?EsWjxxoAmUUkE2/P/9HYM1MvrkBYsouIQ1yttNPQ8UN7BDhj+DDqWOi2ID5H?=
 =?us-ascii?Q?pgDNxk/WU0YLtljw/TJA+PdL3fkq8j/qjL3QRjpM9XhUDciIWj5qlxa1hr0x?=
 =?us-ascii?Q?Mkd7HqHmy5b0Oog8RVYWaEzfzAqOIsgxooftN/fEWMdTccdBiy4ZZRRvb7LX?=
 =?us-ascii?Q?U+197CL3cj0sWNGLXPdXl3vymxTSlKe1IzPasLkRtxHBQPMxDWdOb+x2P1KZ?=
 =?us-ascii?Q?mPS5nYsGrWG/ETQA3V09uU6gCgm8o851HIPgdKCsg0LRxHMhlOptBAbQFW1e?=
 =?us-ascii?Q?4v5ihLEXTmMjutr4q7ik+mZePv2tScMd1WPj2ochdGHTOfbYfrrw/nE8/Fra?=
 =?us-ascii?Q?GPAyKIgD/qSMHOiq11LGPoG/2CA2p6IMBuTZfLj7Jemj/csMnMwsAGNwy2KD?=
 =?us-ascii?Q?Cj3RgkFNE7XNS7ZRxMrpgaW6lvpq4mZu2Hw7kvJ5PWT4YnuKjhR7HIfOoRbp?=
 =?us-ascii?Q?/d9tFbysVbBaJ5znoLh5IWJPLz9e9dvyPSJMrFHOX+AKzKwmt/sq5X5d4OZP?=
 =?us-ascii?Q?AlK09W6GQXN2++7+X/XLnAIfjrNxBDfnYrelbf0NhxhF8lZHUFT7PRNZ4S9T?=
 =?us-ascii?Q?I+A+4d/u+NXNjhGyFfnX9NmXJDUrrjvz5vj5V3nXsXxE0fidco9hX7rXhNg2?=
 =?us-ascii?Q?eq5foxZYoXUDBo5zB5xjvXFNBBUr2LwzKzMpry4t7d2TB0yHqaR7fHpv/qPy?=
 =?us-ascii?Q?Kiv4c6TlcxMqr2ci3SSIGNYPJVbyrDfEvE5G0PAd46t458zFQ8LHREGSJtbq?=
 =?us-ascii?Q?zzWbq/RuEfGeSnQA18nQV49hYmNagl4QqCMVQGrBsCqdVdxOpsd7ULWLlIRC?=
 =?us-ascii?Q?RAsfmNxMYl3pU92TKCKzE7k5wzFV1SjSK/PKBFPN7XS4tYVhZYKcLdIKDpZN?=
 =?us-ascii?Q?8e5khhGU0Hgj6YMrPHzfxjSc8oJl1hUsLcMy9fs1JXgQII3q/jEx7vG1XQ5H?=
 =?us-ascii?Q?rTNS98bspQlCWRlYV3luVM9fzXv6GfR2GLCzlRlPvHbkumizRuNOYs+jniL3?=
 =?us-ascii?Q?OfL/HfjzjcaK5APaoQWaGbnk9dG/i1lF7d19FSv+paVdrwLkCSWm/AX/TOG1?=
 =?us-ascii?Q?a7bslFaAXBjmnkP6XZDeHcGXqxYEvp1+f28fl4MuiiTBYkQtMvmLdO9SoMhG?=
 =?us-ascii?Q?g24Wm1dmZdYwCsQY4mn373CevqDPd9BMTxw2rgq9pBTIfrsVPXMKXBhO6Nwv?=
 =?us-ascii?Q?mVKb+BRwUEhq9Hq1KbVkr6JMPijTe8Sm5NsEB1rLuLrW13UgZwvG6YLxlqu1?=
 =?us-ascii?Q?Ev3Z/9DrB8GkvKs6sYBsnfL/DzeCyolVsahszK9XNEzEB3qNttx0q151Su+P?=
 =?us-ascii?Q?/dxwLsNDc2UYEkJEsXq2lvpgQIYyOhMQLSgP2iu6z75pr2c9g4KDgeHlCcZK?=
 =?us-ascii?Q?O9Y7tqIpxz3n5o7VgA0hW5aJ47DSYnlAr1oXWrL87FcbdTo6IQHTH3xQK/2Z?=
 =?us-ascii?Q?b4RNkLOr/eiMinWndSemXiZ1ILXxvh4ZWXU4mJMFs9f5wzkMDoZWSe7fo3lw?=
 =?us-ascii?Q?o4SSVw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CCYKjumWOMW14QwOhthSgTQRNflytGtNzMMKxqZh5iLrnWYO8CSMhul5zWEfSGc35KCc5JORwwtAnQ2v1UoLzlx1HXJmKhQtOiISJEg8nUd9Qo2GGZgAH7zNu1ZECa0LeXvSducRAN52gE7NgdZNkKaaJfp6xAyXvoLSkSxGosX+PMW8D7rQ+/NVKm/uj+Z73Ax2Swdl2ovVnk2PopzYTDX6LjLERoevGxxY20jvJ8g8uBU4GCvjK+gs3yUtVYlsFPh1CA/wf8vVT5cw127tT47I9o2rSG1d+FlE9N87ou/Zh2PF0m1eEGSwTV9kKLjj2AuM35t5R3QBsMtIkl/WpZa2HTT9hzefBzK2qXfnglolYPTbj11ts4xdX9K0xLMfyMazBOd7qU7WsHDLcsD5H0xp/XCcp82IK9XVefF/SdxgtbcMvfRU7raji2cIjQ7bXkfHkHNUrQ7CeY8QizNzTdxj35CPpcJmqL86ZlJ7zPzUmptp1LPrkNsYWsJmS0oWEI9FjNhtZfOksAXP8vsG4/VD0icDyp7YZ6wgZIqjyxjBbxQuQEGGgziypPRP6sbhQosGe+gvDzKs37tL9BypOJ7l45w7QIQbVXvo8sOZo5o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ea96ea-1bc2-440a-253d-08dc2698a47d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:21.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBsctnAMU46+D3uu/Vbu2HE4VvL+Gxf5ib8vJEVXkUXBwNdhOUdFrf3NOCsB4JtBY9nvJUyLHb4mo2rmk/I8f7rHjhG4hOxkm++1339Bjdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-GUID: 9IggEyOyKxBAAMJgNtvbopCI7aSFQlO2
X-Proofpoint-ORIG-GUID: 9IggEyOyKxBAAMJgNtvbopCI7aSFQlO2

From: "Darrick J. Wong" <djwong@kernel.org>

commit 6c664484337b37fa0cf6e958f4019623e30d40f7 upstream.

Currently, xfs_bmap_del_extent_real contains a bunch of code to convert
the physical extent of a data fork mapping for a realtime file into rt
extents and pass that to the rt extent freeing function.  Since the
details of this aren't needed when CONFIG_XFS_REALTIME=n, move it to
xfs_rtbitmap.c to reduce code size when realtime isn't enabled.

This will (one day) enable realtime EFIs to reuse the same
unit-converting call with less code duplication.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c     | 19 +++----------------
 fs/xfs/libxfs/xfs_rtbitmap.c | 33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h         |  5 +++++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 30c931b38853..26bfa34b4bbf 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5057,33 +5057,20 @@ xfs_bmap_del_extent_real(
 
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-		xfs_filblks_t	len;
-		xfs_extlen_t	mod;
-
-		len = div_u64_rem(del->br_blockcount, mp->m_sb.sb_rextsize,
-				  &mod);
-		ASSERT(mod == 0);
-
 		if (!(bflags & XFS_BMAPI_REMAP)) {
-			xfs_fsblock_t	bno;
-
-			bno = div_u64_rem(del->br_startblock,
-					mp->m_sb.sb_rextsize, &mod);
-			ASSERT(mod == 0);
-
-			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			error = xfs_rtfree_blocks(tp, del->br_startblock,
+					del->br_blockcount);
 			if (error)
 				goto done;
 		}
 
 		do_fx = 0;
-		nblks = len * mp->m_sb.sb_rextsize;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
 	} else {
 		do_fx = 1;
-		nblks = del->br_blockcount;
 		qfield = XFS_TRANS_DQ_BCOUNT;
 	}
+	nblks = del->br_blockcount;
 
 	del_endblock = del->br_startblock + del->br_blockcount;
 	if (cur) {
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index fa180ab66b73..655108a4cd05 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1005,6 +1005,39 @@ xfs_rtfree_extent(
 	return 0;
 }
 
+/*
+ * Free some blocks in the realtime subvolume.  rtbno and rtlen are in units of
+ * rt blocks, not rt extents; must be aligned to the rt extent size; and rtlen
+ * cannot exceed XFS_MAX_BMBT_EXTLEN.
+ */
+int
+xfs_rtfree_blocks(
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		rtbno,
+	xfs_filblks_t		rtlen)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rtblock_t		bno;
+	xfs_filblks_t		len;
+	xfs_extlen_t		mod;
+
+	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
+
+	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	bno = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	return xfs_rtfree_extent(tp, bno, len);
+}
+
 /* Find all the free records within a given range. */
 int
 xfs_rtalloc_query_range(
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 62c7ad79cbb6..3b2f1b499a11 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -58,6 +58,10 @@ xfs_rtfree_extent(
 	xfs_rtblock_t		bno,	/* starting block number to free */
 	xfs_extlen_t		len);	/* length of extent freed */
 
+/* Same as above, but in units of rt blocks. */
+int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
+		xfs_filblks_t rtlen);
+
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -139,6 +143,7 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
 # define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
-- 
2.39.3

