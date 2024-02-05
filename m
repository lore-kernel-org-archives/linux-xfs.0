Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11364D107
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171637; cv=fail; b=W8CuTJhw/IFgX0xm2M446FaCBrgQEb52TsYmaG4QCgU1PZQmLAl1mVUUMYRZQS+pLWbvLux3/g7SSJjtF1zlj1/R6RIMZnSKv5ZInIGetNQ1yus3BS1+BkXdtRyz8zhOYbQCa3Yx6Pf8kTpyntoJF0H4uWSmlxglvIfYmRlb4J0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171637; c=relaxed/simple;
	bh=/Vf32951WbjLwk0YzCK67Kzyt+8nZouy4yut0yKV2Ko=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nd34b09uWvfHjUFFSaYKo8zXo5HQiKGBWXOlFhGZEi2rLYm3VkNOnFxGcqSzF3kk0x48Mc4cS0oyQE0o7kU29r1M+sIkdpdq7/+eI2a8zO+n2U6ofJDKxRwxBDIxERnFKtThirToz2ze9Jr9+sSWmTFwLtfNI9cPa15mgbBuzog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nla+UeO8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lGBTZM+H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nla+UeO8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lGBTZM+H"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LG4cf020819
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=Zy+scyhp7l+kFH1EaJfPS+TuHkOU/JmszeYszauM/R8=;
 b=nla+UeO8rIgm+qTL8qa763/fM260Ur5PVfnnxBBDA2hupOGvbyxKJkIBe9SZBPBVIJzw
 GmLDxz1tWZXNMp0wvim28jEYultdhehHZV5q5+aMEDxSv8zv2QWRab9JbeZ6TMh3tK8f
 0grLAb51T4Iy4jeGwXs+iIMqV6Zy3mG43xgcQD4ki6R4zujl0xPv4ZOsdeAGRhFxGf7Q
 J72hT0urnShQVbT6x4hdl59ZhOKeknQoVOznxoHwnA4z/xfZP2AvmCFM9gScON3UV++5
 T8EjeDzvEPoSmnTJCr3KrfecHLeqwnXO1qXbg8LOn8B+je9NOaPCZ8OAQpYJtY8WJ5Yr MA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dcbd5au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415LgFwm038677
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:33 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx66vk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2uQvnDrEbj2mvuOxwp3j7kR5ws7uBwhrNGHZG3KFRhb0g4v0CYKBScXNeKLpyd26jEqpsbsUdbXjbggvzYK/1RHLYXOQISsSy9mzBUmgAvMkPq56q/nhundD4wihqJoC9GqObPEOnq6z6bOARBCyay/NVVItI2HmA4+aP5ADbiKCcM83s1BjWXvuraofzd4CbowPkZA1Wo7L6Wnzmjms4yjCc7DhIatqDiJxNMKZSDaJ0+xzGj7asizYTGrThU3WzkvOPJ3ya+K2lZh0WZkkNY/557FPjVzIYY+4Fg90IQ4PZC1tMZR1tegqO0qx7q/m8Vb4rTpHhtr2UQzZI1DZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zy+scyhp7l+kFH1EaJfPS+TuHkOU/JmszeYszauM/R8=;
 b=IEmYMwRtb2p/JZEqJhsdY1yy9f8Os0IN5TGS0dQyXF1v+bnVPb27TTJzwsH0bxKDVI0N92N+jrFOxTgj7fbkxBobqbFmK0rizyl2OinchOGLCspBpz+mlj3BsxhiTDyWJLJtjfLxt48eE2AdyrRcJlYyJ24uQ3bIVl8FNTtHehm58JeF6dy8ivwLfsPKBjpye4qzTeXb7GjlzSXP9IB94j16kzKLJ8n4vGnoJPFr06fM7HrCZFhCbDfGwLH8kK0XcX/87QYyyOAy1uwU9E93XBMmWHGZ25hUjyAU88quzKZZMSt8VrAFRlQAfEVT06znkoQAJcZEgSIZP2vwQWRmnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zy+scyhp7l+kFH1EaJfPS+TuHkOU/JmszeYszauM/R8=;
 b=lGBTZM+HinTUt6L3LsWb9VjGSH7CQPuwP5cr/qh5M+TGLxzYlUy4GMO/p5Bp7bfgX7YUBNxa2/rZ9aYeYik3ZSp3bZtPyerCXG0iv5Tn+GQLnH+o9vbk1slII+9WV6IPrXuAggESS6KBQ7Px8+19BmwmLmzWk7Q53nosEg1fjow=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:31 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:31 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 07/21] xfs: make sure maxlen is still congruent with prod when rounding down
Date: Mon,  5 Feb 2024 14:19:57 -0800
Message-Id: <20240205222011.95476-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0296.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f17b40-0c40-4623-3ae1-08dc2698aa3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0aykj20z/3JPD7RfSF4nFR2kc6pDcz2Ni3rgKGZA1GI2TfG0NZN7lg6D0FU1IFXFnz14VI9nbpPQ51vHBPPrTDTWzoRi8fMTUQZCOZaGu/qeVV8M+SAoQ5/xlcpI8WjVqN0Ei0hE5HGPcY9VoBZpfN0+tAvNlx9zFsQ4KGIHVGPbsQq6vyhu3pQXZvDaMRBq9gtz4J+09gpOq79dFowRV2h2rRZiTXkUoPONunQI5FXH8RZy6Evn+8z+Ra5oX1v/rsovbDlawSEYSbr523JSVSo/kwiXsO74DH+Bjaj51voGgeBx3niJ9vngJlSGTzVWO/CFchlZQ5rXoDlvNHaKDMBzfqwgVexkXDJaKVjk5zAAoMbm4BwIskwWS71rgCJsNOziUtrTUj8Y1tZQJ79uocaPNXG9Me8SZFUIUda9HzB6RdpX7zkYLxfh7hoIYZV+4uF5rorM/UUkrCmn9jlmS9B+IZ2smFd8XSELkSnSxPLxENkXTtNlL3w+m7QOTi6hoxQvzgLPDj+IowC4lDsSdQHg9CAoB15iMJl3c18cRtYQBgEXFakqrK2im0fIvtO2
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(6666004)(316002)(36756003)(8676002)(8936002)(6486002)(66476007)(66946007)(6916009)(66556008)(44832011)(5660300002)(2906002)(38100700002)(6512007)(86362001)(2616005)(478600001)(6506007)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?3SW6mhwwlc8e1Y87Qp1NUBT8H2qLNaihnZOYmbjqPyEZ5xfO+uhzAT3JZrWs?=
 =?us-ascii?Q?Vg6al5t+MRGeV+zyOg5Jz3Un2amjFCo2ie/EQWAQZI3scaQ3mnk0LHDYFo5O?=
 =?us-ascii?Q?pKgG9pPBJ+x11SYtDpdy1sHmuqrdkWH7DVbUnp/M69rCHz5LlwB3NVPhMHdR?=
 =?us-ascii?Q?j+vS1SVM5IjNbYuAlAp1S8Thh8YMFm/W/LPDDxNhe2qCDONZdcytTtZaoEs9?=
 =?us-ascii?Q?/WIWvWY5mDdiKuxf2qsApoDZN3PpCdP5cl7RpjI4s09NX+fhxZC/OTtAydua?=
 =?us-ascii?Q?WqkP5zemsXx7hWTBU5d2w/q16UTj/N32x7w7i7yRcSecqiu8v2ImTRmRfcKz?=
 =?us-ascii?Q?b3isZE7zGEXuP1lhUMHqkxURYPkDAd+8oY6KW0qFjxdodY/aHMCAn7h/BVDd?=
 =?us-ascii?Q?rQoVeA+zSR746OoBKmcJODi+cw1YRK6L4NS7GgS0s2o2W7WduQyKmaqVIydm?=
 =?us-ascii?Q?7FtneNluYfWjA/kFWLlbsDBuJDxkJJ15oqWnd4ELJrnbr2QYSu6TjHuvBSAq?=
 =?us-ascii?Q?nuBFq6/fgRBshw1HAk94VPdFN4l/N+ED7nTXwiBLU7RrOH+3/RuLJlGnW63z?=
 =?us-ascii?Q?s/Zyyz4D1HN8XTGsLdSk3s4Ubpp9nVijuFYQ9k7K/ck5aD7zDYtfSFO41wq6?=
 =?us-ascii?Q?rilv/uMKH+IDQDraB7Pu79vnKXEtCfh5aFO3LfBtdUP5HZI5ec+dPptcuaFg?=
 =?us-ascii?Q?GTvZ3BcAOTsXnuuWDI30kqPsycE4iB2zpmG5tboIeqnPAjSukkbKEj0sDDHS?=
 =?us-ascii?Q?W93bOnmy9ACbQQTVFOtFM8EKe+WlVcAtGpg/T7sF5UY/mrjFKPKfVs/p3DXn?=
 =?us-ascii?Q?uuG/USah6ogwDE0vYipfW9MtawLW1P7VwHSAc6c6Zlh8UW/4EiCcNKi0bv9k?=
 =?us-ascii?Q?7yqH9wg66yHQgeP8Fex/4k+/lUiA/W14qY37lsh4XA1HsUqUZ1OJkxiXQ0CM?=
 =?us-ascii?Q?dr4oMOhB92+Fvlrg8HnR5wl/TLN2hxP+0DmKIg/ynNsm7o8pyPFBJ6ny+8Ov?=
 =?us-ascii?Q?nGsLxU7JAFrxM/W586or+RkfpGosAXyLuRA7jBSJU37wXl0wK1kWyU5jtk33?=
 =?us-ascii?Q?3MzFj/KXSoL/R+mcIssRY6y4jcYykUIiEEZcSM0hcYrT1dLHVCE6Fy6tQ7JA?=
 =?us-ascii?Q?29DNIVjI/F/NGIwO/rJuqD4cxJfBhed0npdCsdSKEmy8+IfymWDciYy2H4k3?=
 =?us-ascii?Q?EF1PRIkWvVIGXazmLuxKR/VY2UDcOSF1ZEmleeZNV9r7N+7HLy7+OoFrH9h0?=
 =?us-ascii?Q?9gHVLF1iq8nYrIoWl9HHV0bjALS+V1Qy9NXTM5b7h0/E8XyZFmMlvA3U2D5Y?=
 =?us-ascii?Q?G4FNjzGZ+TNziVCz7skcBhImOI1uEyqOdN9tG7LF3EpoOrfIRWq1AgcGbrrj?=
 =?us-ascii?Q?lMgaMN8kHd64C2WR8nbZXlYh4qxouMMY+I9D0iwoMH/wKpXD8xFJ6mxT2x4Q?=
 =?us-ascii?Q?cTlgk9YCaZ/fQI2CHtYgclnX8Ou4j3uu9Aw9z+5MXWem1w1KP2afyfCV3UCW?=
 =?us-ascii?Q?votdELd56aGtx39Q7UKBmDqrDiNEdnaW4vFSbPw2riirgJeQm8W19YMBPKaD?=
 =?us-ascii?Q?zk0EyRytDGfvG+c9bY6vbSuEe5tT4sVf36YxKDpUNEHi7j59Y20MdCMmG7Yl?=
 =?us-ascii?Q?cSCvMeiVepShzbeeIKPvXXUU7otINtDzQU6RMp2eGU9U5NKQyAmSE2bggwa9?=
 =?us-ascii?Q?efjnnw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	z4TVixACEcjcIxcyN3p9Fahi2ftSU8/iXSeXk8VbJ9KCSKPAJ/bNEMA7jd4g0rexNJC+wkWS/icsXQDnhK3wQLTG0QUAAofjhdLAwqySmTibCKeChRBvKzzwk6Vv/4qU+tI1ICjsYhWzkygQPOyFAbbRZdWazq+GSZZSTjOsEPxocgVqKOfJMqglmjnBHhfMWiCf0qubR0Bg7n4iVJ3LLiEapK9piDQjE1K7Wb/7Aev4d8SveJpg/Z3sXJ9MwaSUxMZ7Go4GA3XBBxM48echkcn0R3STCWEWJ3RK/GZXcNAJOaB4H3qZatvGGXIygfXNujyjWh4oYVZusVlun51wcHMdJuOUfyr/0zHc4xxaQ7z9vQYTlsTnH5eLuajmRviAAdRhlsZ+7Io3IS7Fv42EevjCmMETjAhoQ3U9/IIw7hxrZi8ytVbzDkoPVckLSNlzrl1JNku2QX0Cbgfoz44bf9LRZyA7xWNud8IdbGUhIeSE+a1uFUzUoOGlX5yF/6TV8UDpuXNyyEnU4WIQaCmq8VZlRQ6EpOSkO6t4qW20kJNx8jYPQBiuVHo5+4rZyozjjoJpF66kNXKrQakxkOrF9XTlXE6MPJ3GBFnbGDlUjys=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f17b40-0c40-4623-3ae1-08dc2698aa3e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:31.4087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HOJ9/moHU1yCKLmABPLZ0iMAxnMdTOXXlEjk9sayLs2lxJroYppz9g3QIU6kaX5QielFOx7XJWx1p1uNoidpXzyKpA6YhDg+nX7z4+DuxlI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-GUID: tSbTowiMSP2r03m2hAWLBznwlTHcgXzp
X-Proofpoint-ORIG-GUID: tSbTowiMSP2r03m2hAWLBznwlTHcgXzp

From: "Darrick J. Wong" <djwong@kernel.org>

commit f6a2dae2a1f52ea23f649c02615d073beba4cc35 upstream.

In commit 2a6ca4baed62, we tried to fix an overflow problem in the
realtime allocator that was caused by an overly large maxlen value
causing xfs_rtcheck_range to run off the end of the realtime bitmap.
Unfortunately, there is a subtle bug here -- maxlen (and minlen) both
have to be aligned with @prod, but @prod can be larger than 1 if the
user has set an extent size hint on the file, and that extent size hint
is larger than the realtime extent size.

If the rt free space extents are not aligned to this file's extszhint
because other files without extent size hints allocated space (or the
number of rt extents is similarly not aligned), then it's possible that
maxlen after clamping to sb_rextents will no longer be aligned to prod.
The allocation will succeed just fine, but we still trip the assertion.

Fix the problem by reducing maxlen by any misalignment with prod.  While
we're at it, split the assertions into two so that we can tell which
value had the bad alignment.

Fixes: 2a6ca4baed62 ("xfs: make sure the rt allocator doesn't run off the end")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_rtalloc.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 31fd65b3aaa9..0e4e2df08aed 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -211,6 +211,23 @@ xfs_rtallocate_range(
 	return error;
 }
 
+/*
+ * Make sure we don't run off the end of the rt volume.  Be careful that
+ * adjusting maxlen downwards doesn't cause us to fail the alignment checks.
+ */
+static inline xfs_extlen_t
+xfs_rtallocate_clamp_len(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		startrtx,
+	xfs_extlen_t		rtxlen,
+	xfs_extlen_t		prod)
+{
+	xfs_extlen_t		ret;
+
+	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
+	return rounddown(ret, prod);
+}
+
 /*
  * Attempt to allocate an extent minlen<=len<=maxlen starting from
  * bitmap block bbno.  If we don't get maxlen then use prod to trim
@@ -248,7 +265,7 @@ xfs_rtallocate_extent_block(
 	     i <= end;
 	     i++) {
 		/* Make sure we don't scan off the end of the rt volume. */
-		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
+		maxlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
 
 		/*
 		 * See if there's a free extent of maxlen starting at i.
@@ -355,7 +372,8 @@ xfs_rtallocate_extent_exact(
 	int		isfree;		/* extent is free */
 	xfs_rtblock_t	next;		/* next block to try (dummy) */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	/*
 	 * Check if the range in question (for maxlen) is free.
 	 */
@@ -438,7 +456,9 @@ xfs_rtallocate_extent_near(
 	xfs_rtblock_t	n;		/* next block to try */
 	xfs_rtblock_t	r;		/* result block */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
+
 	/*
 	 * If the block number given is off the end, silently set it to
 	 * the last block.
@@ -447,7 +467,7 @@ xfs_rtallocate_extent_near(
 		bno = mp->m_sb.sb_rextents - 1;
 
 	/* Make sure we don't run off the end of the rt volume. */
-	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
+	maxlen = xfs_rtallocate_clamp_len(mp, bno, maxlen, prod);
 	if (maxlen < minlen) {
 		*rtblock = NULLRTBLOCK;
 		return 0;
@@ -638,7 +658,8 @@ xfs_rtallocate_extent_size(
 	xfs_rtblock_t	r;		/* result block number */
 	xfs_suminfo_t	sum;		/* summary information for extents */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	ASSERT(maxlen != 0);
 
 	/*
-- 
2.39.3

