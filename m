Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA7878C9C
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488064; cv=fail; b=AwFvNcBLGr0dBKY1UMMy7mC7uY/GGEYZpSi2uvjyYx2/Ytt5FGu4ZPphqxQIN/2WnbTDrpcVn2M7lJa4e4UsvL905uyJR9Hz/j4EJnzoL5xcd1p7h53mv32xaDH8Hakzy77yIK8BK7lKhgrKM5xFYR1tW8BDehRYwLsA7J5J/YI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488064; c=relaxed/simple;
	bh=qIqSzJAq29MWp8dek0sVLznFNLOkI3dzS4kjOND/t6E=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gd60JpDxSOjsXFar8vS8gbUQSjqX2oUxyckoPAaUqxcx5XOhveMdxMHub1vKzdiEblP3CwzPvNsy1KcsM59hQfLAlG1LZlY+k1OgOeHW5JhiuxPyT9cXmOZmahx6n9nWCiaj2RjZ6UxbyOeU/LHpyvocSPHf64Jr3DRwCJcrueo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FavGU8e+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L5/Pz6Du; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FavGU8e+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L5/Pz6Du"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BqXn001112
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Ua3f0smNr5h1BDd1Vg+jHnX4EhR/HH3kV+RAzDzETE4=; b=
	FavGU8e+J3R/sUTcqRoqzpngJm1hHrthJc1QMxtpSsggGlFWGqL3vCRsWCr852DL
	vn30MUjzMAlfZAT4mfBY46JuLCpoyYiBu3ah3FWunuViPBHZdEI0ccgC8C9POuJr
	77w6NVkTitq3wuxwehstkayGO44TwcUb/CXUHeXZ9rnAbQ77EKh7PyP/5Tnkxeqh
	SwGm51M8OvD/9U2a1YOXP0zCq+h46H3sl/8h2Vo2W/sWjs6mIbsHpBtskzt7qtO6
	fw7o0/2MxEC3SK7EAYtYRcILr6Xrs+f6o6oq/uYRAPtzhYqKKouBPSyEN3K4YnJG
	6DfigHvcfgaTLyBTvApTHw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0ec7fma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI0rJ9H018984
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f9fbsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zNSe2j8Xz3d/wcYRvQvPRZoRsN+I0jw4qVvwaXNTmEpzr9RjwFeH3RdLYQ/fLjttFLvtYVGANV60DOBRU6t3+LKnlkkZVQKHGEic1Gbxr3k+pmzVLCywN6s+zbRSugIv9wheTYK1+ecaSCRL37YD+fEk0Sc+cZ6sx+N88vUAMPEZUpVRBhgzUA9RgWnPYJsu4mMHR0J/Met1WWhLjpSRDi0ruZ2C7p76/jEVDv+jFPx7uwCpjRe/UNm/hHZ16ZHg8Ojj7NurBNaLeu0Lyn76OlUp5vqGP79SqyIBSwwCLvgkUUj59lkKA3QVcNKWKx/468DJCwGgx2A3y4zMR1BnjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ua3f0smNr5h1BDd1Vg+jHnX4EhR/HH3kV+RAzDzETE4=;
 b=SIzXp0tHMMsdARjsA10lq1+BR9RABXVwaLqc6fKneyqZwZ7O+EnbIf+Oh5VjZllpt0zpaH+BMYqt+8HS7BrTT9B+ihKrK8xV6bqNt1PKwBkXv2xdxPSNYMBgHP16p6aRXW5aIbXn5gYohzy7TYSWivfIPK/ta54OIzJB683DMulx2XxguJwVNJHPxjZo4WKfiTkRAtayqJc9voD+Nwqij8R5XoF6+XZPIXglkQ0KfFyPNoJ05CvrqvZHrghAe3DNRTYPEzuitWfBuud202LmkHAgbPz+MlHUTO3JGE/wPXI492bxmw+1t4i+HfTy751dM1kkJwjHZCkVrGV0/EFcrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ua3f0smNr5h1BDd1Vg+jHnX4EhR/HH3kV+RAzDzETE4=;
 b=L5/Pz6DuCsqDqsl+J340dL/D6bxHSjpEXr2pKAi5sooWOR2pjccfBV+yyje2Yjw9lwhLm1JfWqwJErfxyTTOUPDjIeXv041WYA1ibAKIg5biXRRYrlw50N//+Uq/lHH7UkUmAX+RYr1tLA8J5BN5b18CWHyJBSISi2hV9BQyZKM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:18 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:18 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 03/18] xfs: use consistent uid/gid when grabbing dquots for inodes
Date: Tue, 17 Dec 2024 18:13:56 -0800
Message-Id: <20241218021411.42144-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0072.namprd11.prod.outlook.com
 (2603:10b6:a03:80::49) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 15b4c74d-c2ad-4ab1-ebe3-08dd1f09ad7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JocM3+PW00PzR0KuVMsZ4EhGWnpNhk7dwrclNHWkFK9AwfX0LISlx7+JN/Vk?=
 =?us-ascii?Q?tt4YoInEYyLr9LLonWgv8xZ9wrj7yhjvyZ8S9qTO5/meGV99l8sK2ORzyTtp?=
 =?us-ascii?Q?jjfHN6+d075PXoa4GtQ01Lrq/OyrpX1RCFu7rBEWZQBI0IOoPs352SgMjnLX?=
 =?us-ascii?Q?Bm/IUC/0nxPEkKMupT/PP1j2X4TctUBDRxuKKjHjbSfI+JV0FsyPMLz/4jfQ?=
 =?us-ascii?Q?3g+jNGgE2X+zRw6bPMoNH9s+25D3hX2ja8ulTEI7+eOxUaMdYL3dol0mA+s0?=
 =?us-ascii?Q?F3Udd7IkiG1UGIu4nY/+0FC7VDGLWk1geczmx5tO1mJyhP7acrvEUvAe5yDB?=
 =?us-ascii?Q?P8VHT+TJkaMcouYvfGUN53LmFms8fP45q/Y/HzGAZS34710WSXe/WQs848qu?=
 =?us-ascii?Q?suF8B2T6+jbJvzjdl7QNv9cX9I7bHKPTGiPT6RqYd3lTX/uD8XGVFzbSSPK4?=
 =?us-ascii?Q?oTszdUNwqfyn5YrLoINDEeoTrBqqO46DsZQbGkKod+byhyLwREestedCTBG9?=
 =?us-ascii?Q?2ygBsFHPHXWzZs6Bd68RQVRTZPKFuw9kvuSy8gENgaTg+2aBGvKyWRhk7zLq?=
 =?us-ascii?Q?QI95jsvmF76g6Kk6xUT1FxPLMoLP/5zFbrfHUrrD+ACb8opGhJPPpddT3ygn?=
 =?us-ascii?Q?RhiIu0QpJkZzXl2M0muyxop+2iEORSA4m5eSddkZ+5IguIcmqUGQ4OLDtkBA?=
 =?us-ascii?Q?7Zr7ZRvyvreH9iN2M1LUnMsqrLFlAhUa6EJEj6PRk8v3krK1Ft8scRjvTJRV?=
 =?us-ascii?Q?kZMgKcMObttSVdOGgEOUXwTS9VBlzSsPfQVOKFtam3qAOCicejQoERSFaKp3?=
 =?us-ascii?Q?oh8I35srOO6pBJ0DyX/KPCRfNbFD+hE1BZdYH8NkMJntbMbcyzhlTNugtUN6?=
 =?us-ascii?Q?rltloE7t9PJYGHvXgmw7ZH1VyAnnPmUC4rW20lktiSKAgWQPuzonmKfklojQ?=
 =?us-ascii?Q?TjJvXQazmNMJNkj2WnTxmT7fgS2WCo8nZZCxgzU4kBzNrB86lO2Bm159dSR0?=
 =?us-ascii?Q?uDA9GNsGTva0hb+ch1JMBsu9aV+HiCWdL5AJSEbevFf0b2xPsv8h/gccEuu6?=
 =?us-ascii?Q?ZtfxYFEXtUZS4F6V58h+pshH0SN6fdMrLMBOFY5jxZdFxsk+1cGeIf+5SaWJ?=
 =?us-ascii?Q?nH83AQny78u7FjPXGA9Ls6felFezqhju9RJA4FEBqOrFNMZ2cniv2hwNNTV8?=
 =?us-ascii?Q?nx9jjp9ztnawfArz5aI5TFzbays4Ihp4XMM642uvFoz769ru7awWejGx+cvm?=
 =?us-ascii?Q?7ZqYuKXTLM5vNh/Yzu1ftB3n6gJnWZ4b3YFVa9In3aFKG5SVPsAwd+JXNZAd?=
 =?us-ascii?Q?A1JmnUpPvQR4NpH/g2/1Ur2Bt2Ls29PWBMYFiaSSN0h/fquuT0/qWaZoJ1l+?=
 =?us-ascii?Q?gn+syZrrSN7dISXwxDw78eiMDxtR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6guMGoz2+OPRgj+fJtd46l4jHXnRhzRpOjRZQSbhIjbTG1pk3WBwu/GZYO5f?=
 =?us-ascii?Q?YhAPQs6EGjQemxC+qll7y1X/dlEXgDRGEp7Rx9ZRvFayMz5i879G0jXDmQ1V?=
 =?us-ascii?Q?GY9C29IDxjBBQrxzE81EwzM8nBRj7Bd+BU5KsF6C710vmUUI0gS59PULQGDL?=
 =?us-ascii?Q?fipS8YvvimH8JqC1hx8qNlhYc/Hw60kFgTVN7fPYJuLtNqJWOohz6pCPE9lF?=
 =?us-ascii?Q?ZIRg2vmJKY+7BXonEGfWggV5zG02rZgOPOQFVYrQWtjaSzy1OfxWo69hzVOi?=
 =?us-ascii?Q?29JPiqSNusHqbwXSlsLrs4Q4b5m0DoswxZaXpyO8jZKXvahlanbXj4P1c4k8?=
 =?us-ascii?Q?P+Krh9c6mD+NYIlrpMxvOtmb2vji9FvK6MgeLdQ67tZYpl9pTCuN4Z0+o0Sl?=
 =?us-ascii?Q?VymNp3B5wXjzCq//cRe1Q3BOemP7OVqAOg8vl3lMH80WwujSi4OE+p6njDOm?=
 =?us-ascii?Q?jKk2S5qZrTjCY3I3U6G3VvnCWLwlRqRiJz5yLTmszFi04JCttQxwzn5Wh5D0?=
 =?us-ascii?Q?328ByJy87QP2brxdzyeR0VgBddRsDArKow0Ez/hwTjfPvfsDZGUJEcbFJ0ad?=
 =?us-ascii?Q?5V3Dhh7KtAmtXCYu9x95s9w+AjfkqiBafFUds5n1zpRa+XMr7GxzZOfQjtls?=
 =?us-ascii?Q?KQUhg/XFpIEnSluBnBzSZyHakvzDZ337df3FptyoA9T6ARaF0+/X8ruRijFA?=
 =?us-ascii?Q?GliyIvfO07VOdlsrQvY4zSTXXkIYBn+4UI79Oo3dyEkVrg/txeqVfsWBlSxn?=
 =?us-ascii?Q?H5+vSx0hxiSM3aiRSeCKdgp/vJX05ZUSzWk7/IffDTuJpLtKwQqOT2EDN1Qz?=
 =?us-ascii?Q?KyGPt/Vs84DiQpDSvt1bY+8XUqY6fxl4BsnSwlt6W4j8rnPfXgAVwvEMr/9E?=
 =?us-ascii?Q?jIMkI9942ekcXHcve9hiAchTPFRSfeJf9Yv7O5At8TtmwAKv56n7SNJkFsPB?=
 =?us-ascii?Q?yZ9okzxCakn5bLGNNj9V9VGnMLapxGbiCbiaaVHoCUCAGuZBxrfkew/gbLG/?=
 =?us-ascii?Q?KsKAt235bN4JkpFueDSJBfXHeaM0NSKXOe/qyevkEy8O969MzgRavuw0iFrB?=
 =?us-ascii?Q?tY76bXuq4jlILIz8AXaQ7/2Um7juDaYdsKlKp0ncq1wEFNGFnUukFNpw+mVE?=
 =?us-ascii?Q?sjY9qGx/rddsXHUE8KL/dkfSvVAidhRn1JvuZWm76c/2Nj2Xy01UA9WLRiG8?=
 =?us-ascii?Q?BkKR7ydKUteCSTSzvtICS4Uog4wj4zPVVPdS+2hwrAPRycU00siZyLmpKrFj?=
 =?us-ascii?Q?mhDmybeECURXflSt+Gl33pJuVxMTd4kWMJLFWasthRN3a1DA0GT02wlM/0tT?=
 =?us-ascii?Q?7629mgkre466Ma5WMaaGkx9TEmLCOj8YAvfL/kEtxvsGw98egqiSoTa7oYru?=
 =?us-ascii?Q?yUPACDrMkvoYrI7B6jah7PEzHJPMaGKQPr4yMyBnUCSca1TAEV/pBsg4sdW0?=
 =?us-ascii?Q?gvyBC5ffmQ2URgOD7yUn2pdXKhuc8BH/Y9+Xf0k4sWZJrEuCQmfvPXUMnxOH?=
 =?us-ascii?Q?tfvC0d3gC59dAI4OBFirF2RCHNqImhfDgxiie7qVGKYSSAx6IDuJWnqpD2Cc?=
 =?us-ascii?Q?oyeIfVtmyTMrOeBKYiJU4PAezS2wy25KLNOL8waDLiluXKdECUCT/lFXXaP9?=
 =?us-ascii?Q?524tt5LIqjue/qmrWjj6MNwO0uzCkccNp1PYHGSApRFtzGSEV+BX/Z+JvsVW?=
 =?us-ascii?Q?MKO+pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K/GZF+/cdh5fiHK5w2qFX/jmk+/wgcPYcjbhNpBitg4qAcAokMAwaQzVm6anvdAHFlHyESpYCkGMqGSLyFVv+FJ+In749P1EzcZDou2nFBVKJRtX79X9MkNT5wgjLhwhS6mfKJRQ+izbzZ3rioqGIckxxLJ0cvzCvbDTP6Kfj3u+lhKDm3svU7R8uPywz87vDAzz3JYMOTPAw55bjijUrxWp8TBU2nfj6k9Flqjv47FiXSuKj/xNF5vjTizcj94rqrn0EwDW+KmhYrIHV0W1LDSSWwxUVKSbxcCZpKAdqPPKg98PTBEW0rdeis3kqx0jj9HZpmfgpMcnMnbf6VU1u2dMbLW/pOkdDcns+25cMa+2uO8BkxLvaB3O32SQU0UGdRT0SkTJlH1/9WJBrFBcqe7VBseSkPebdzP0mQ2VHDULHTUSCCJ6hfuMGtazhF+HecQubbuCFs8OfcZ35AtTVHvR7NL2MpWN2U4MhpgzjHfDLO849txpEewK0JCKYR8coIaA1LDLBymkAyx9Cr4u6hvIgbA3KRk80J/ckZ2Oc6TJVejgYYtNee68QCpMJbR3DbS8XCs0GctDDvYjUBGAlDpugehoBkt3+i+AWaAu8bw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b4c74d-c2ad-4ab1-ebe3-08dd1f09ad7e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:18.3897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQm4gPXfscw/ICMDWcx0gmyHH/o+VX71HuQV5GFTcpa9GmKlw8B8sNJRG5Yy4jMEISFJp3BFy2hOeZX5UIYjx444zb+HQ5C3onsWZNUY4wA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180015
X-Proofpoint-GUID: _pWTKrCxjcEtrI-6ccrSmIWmQQhSOfZv
X-Proofpoint-ORIG-GUID: _pWTKrCxjcEtrI-6ccrSmIWmQQhSOfZv

From: "Darrick J. Wong" <djwong@kernel.org>

commit 24a4e1cb322e2bf0f3a1afd1978b610a23aa8f36 upstream.

I noticed that callers of xfs_qm_vop_dqalloc use the following code to
compute the anticipated uid of the new file:

	mapped_fsuid(idmap, &init_user_ns);

whereas the VFS uses a slightly different computation for actually
assigning i_uid:

	mapped_fsuid(idmap, i_user_ns(inode));

Technically, these are not the same things.  According to Christian
Brauner, the only time that inode->i_sb->s_user_ns != &init_user_ns is
when the filesystem was mounted in a new mount namespace by an
unpriviledged user.  XFS does not allow this, which is why we've never
seen bug reports about quotas being incorrect or the uid checks in
xfs_qm_vop_create_dqattach tripping debug assertions.

However, this /is/ a logic bomb, so let's make the code consistent.

Link: https://lore.kernel.org/linux-fsdevel/20240617-weitblick-gefertigt-4a41f37119fa@brauner/
Fixes: c14329d39f2d ("fs: port fs{g,u}id helpers to mnt_idmap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c   | 16 ++++++++++------
 fs/xfs/xfs_symlink.c |  8 +++++---
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7aa73855fab6..1e50cc9a29db 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -982,10 +982,12 @@ xfs_create(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1131,10 +1133,12 @@ xfs_create_tmpfile(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 85e433df6a3f..b08be64dd10b 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -191,10 +191,12 @@ xfs_symlink(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
-- 
2.39.3

