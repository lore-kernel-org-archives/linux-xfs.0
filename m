Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B511B85F7
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657119; cv=fail; b=ApT1X6qt1LyUAEfMUirZvNAa4NwVQlscmRkza0X0t7ArShgpOnPTpkuwbBAtvc7nkjXyxnOCI/sfEU3AbC6QUIcC+kLCI1lFUgZdYthmO7dsoZm1wCJUY0mEIM19Fp7alwj+krfioIASVMtP2LJer5yvXUzcVwWg1p8zkylnOFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657119; c=relaxed/simple;
	bh=h+A3XjLW5V2in+XRiAX+Z6/TmV0YYYrjgg6tM43WXRY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z3wIP0+yd1hLdXlmSVZ+0QGEnEhHxSGvgJB1b4Y7AzZkOaw3p0CsjyYwv2HOhPTofeVE+hIwW4UFiv1wmhcyWeMs2l7BfSnRUN16N8nMwGVdh6Gt6lXyzyiU0TOae34LIH9FeqMWeMWBG4V1me5PhLjRQnMc5bbbPXkDtc0XZHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lBXA1eIJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jjOqmkgj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lBXA1eIJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jjOqmkgj"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXtQp024757
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=ReTU5xy/PZ2n++XKBRUdtbNySBIwD/r8vX1vpCP53uo=; b=
	lBXA1eIJ3YrMa+2gnZ0pTrsTwatsdlmG06ceIv5bHO8Ur7daTbm/3amS+lBOSQDb
	UJ3/nj/OOBK0hZNFoUGR8aGV7mRsVoHRmunTPEM5ILN6yVIM/442vqquBkFfKr1b
	7LBVW5Ywde6KVWBBT4/xcpBRTTy+nhn3MWgT+ZicWfqoot9Ia6CcwzIGZj49CadB
	M84faJ8v0ipa6scev9/VXAK/G7EmZmWenB1HwMYvWhLpBoelaJlRIcGlq4EurLZd
	8ZNcTFM1a1PZ4XrMkzpV5e4fRgbXPC7Hr43MAvMpsgyohSARbJSJ7Z8HPPseTUtv
	zU7dYpRKJO0z+/eN5BxBMw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkak2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486KQeI7003339
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhybs74k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sx8tftF1M4TudqBZNBdMPgS7qBYbhGjB9j15lVO3ibdGqqCcXzqrQqp9E+PH1CwVwsfj/PCJqQiHIHMnQHKKhhbumptkgJeLULOUe4AFR4dvUYPl44D6qrD/uiYkLjBcDDiUUMF+/PRc5Og5XFLvMLheZkGVNyt14IGQQEiOBVajtsd0/NU3plvyN4FjL7Qz4gWk7Dd1kRfzNqazXgxq2boG+uKz6q68faYhMbtiMVj2JwH9rApmY4oFrPB/OjsboTwLly6Iy/QBd+p7IEqHS3e4u+Rkp7kqtlDxNyKh0X/V6U6umb1V3ceWZ0RXv9ZmKzrri+rxU3hB/oRH2YsnFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ReTU5xy/PZ2n++XKBRUdtbNySBIwD/r8vX1vpCP53uo=;
 b=Te34yFQ/7vS9QSpBzRmVuAp5LhAYTrWMdB4iyDJA5daMGojurbuZ5HPJd9BjQysWyKXi4o2SdaTnL5YrBnH0r14uBCYOatSnzaIlChHPm8qcDIoBIusHaHKJEWn4QUpgFwXdmCgKM8fwgIrpOwZT5gKD1agLEAA2luwS1lnJgH6apQ9IhAvufwCBfVAhFbOIF19GTGHaXdNBvHD6dAVyTUtsVpPqvr25fkJxEnFcXXzvZ5TDboQ9uLkgiyPoWCGfZDhIN/rJt7DhM+IuHC+YN0B3aCyTed3LuWI1yAYOXOoMXyne/Rbn96T0Gk4ufIgJZzSeBPGCiIDs2Xd0wA6uvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReTU5xy/PZ2n++XKBRUdtbNySBIwD/r8vX1vpCP53uo=;
 b=jjOqmkgje4g3L53fWyFU+PIt2b4+gnMZxxZyMMAw3RKWMTaoAxi8IJWcg9vT+GsArkv8lMdvHK4/+iBdqxQWiAPc/i1XeQchtq/A0EWG79w9Ny5C0PiBJHaTJVvu5ow9FcxdeT1Bo1n8X98ViOGLj4A99y7SXxdUPgw90SwjVG4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6765.namprd10.prod.outlook.com (2603:10b6:8:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:11:52 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:11:52 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 05/22] xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item recovery
Date: Fri,  6 Sep 2024 14:11:19 -0700
Message-Id: <20240906211136.70391-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0125.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::10) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: db5ee8bf-5165-40a1-fa15-08dcceb887ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qC958ltBL9Z3WiFm88mmxN5U7LXEm57M3/cYE4J3pQbH9uadh1FWdxeCWAdP?=
 =?us-ascii?Q?dDWSVQAywjFcAeJHVfMb5Q25wFe3a+bH+MgnX0ZxtF5K/2W6WR0kXsZgiByM?=
 =?us-ascii?Q?bH3iMOR+8n4kcwCQfGaH/nVycO1JHPVxy0Tc38P2G/4ihcFCGxjM5sahsiyf?=
 =?us-ascii?Q?iXdliQlv4CrDbmo1VKzAMJ89PZR2xUxgZ+pAy01i3mZdWRVEq9XmboWi5Maw?=
 =?us-ascii?Q?CyqVT+pTKx4/fSjjw8w1H59ndBSlxmYFQZWxDmU9aZw4xlJOVr8lrwPcOJwo?=
 =?us-ascii?Q?fcmcOp+2gLY+Y5U9/2dobbvWSimfCDRGAMHOgGPAsqIDP/9IY9UcjGHNWm3O?=
 =?us-ascii?Q?JL/DMLxMkcZh7hzEGd0X6dYqgzbmNm1RmOHDJcQqQ0KMvOjHyy+ircOKvapl?=
 =?us-ascii?Q?O3XZ5Gjf7YgXv9riJClQFG5uLuHWx1cf9G80RkABlvjEFMAsXXapwk+lc2DK?=
 =?us-ascii?Q?MV7sujgBRyWaPxihTjdNKntYx7/d5/8ETDpxSlH9kqX8oDQNov+gPmVtZsZf?=
 =?us-ascii?Q?Vdy+k5G6eh7Vo2TMBprx4jOG3jYwbu7jTis7t2egXu6EtFphXt+XoZvJPibX?=
 =?us-ascii?Q?6jyeCjg3vPCxMBmOOYLGDZ+KayumEzQYPvJHKIi8J91SdzUGZLQk+OsReOj0?=
 =?us-ascii?Q?DikG0mkG2sJAP9snoKiuD/+Ea5Fh8HKzDg59AFNJ5tEjSvIOSSug0mLwjCC8?=
 =?us-ascii?Q?Xhsoq9Mpk7wYAwTYICBFGAfpHbXIs/FO1wsFRIHfeujNiJDRvl1uGUiOcBeZ?=
 =?us-ascii?Q?na47FE0tQCJiGQsoGsLUZrwzvOl0782ZHx1Ts0HHYs01TSbnvtOQAgTv+T/I?=
 =?us-ascii?Q?U6UJdlDKO3twqCyOkgIBBW5vaGWDtyCr6NHdxegbn1+I74tj/8fo0nBFGBKz?=
 =?us-ascii?Q?s9ShVq0Dwywa5EfWNJO0Whx4p5Rufo0X8NXEwl5IHezTixM5FxeHtJTAutY1?=
 =?us-ascii?Q?6S85swLe6CERLZwZkxzKmXRTjbsDTli8PeVWrUXDS1Lhw9ujx/tkAeEiH/+/?=
 =?us-ascii?Q?0L9S2qiFdCN24t2oHD0OxGd+xuFXY/w+WtZ3F5dBVMiPvfZJWZ4BbAo6S07t?=
 =?us-ascii?Q?B1rdjWNtFW/MLy3UgSRVrs3KrU/fQNmPTGysd5UDVOo+YkUUKd+x5NeFnYth?=
 =?us-ascii?Q?mrDWoTsYOcgCe1X+7RZDDTpCcb5iXvBT+xUtDd2uUDgFQbLi83+dJf6XgeZw?=
 =?us-ascii?Q?MP3YHb7+V5J7rpWGrYylHYY4jI1oBY5UkaAUKB5CVOGR4qvdbH+iqIoJbJVQ?=
 =?us-ascii?Q?QHpB4MRYR90swUkOyhzmDv1uDd4/P4ZBgAA5CAoaLGmbfCNfM78eQLu55e5i?=
 =?us-ascii?Q?IOgxO1MDRfuqBVaj4a1ChR/rhd0cn6naIhsKBSCuvl9wCA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bbnW1nNwJVMXJ9nIAEPTnAutjgrEZvlbTm2BI8u/GW4U58vUHz6VJ8icN8b+?=
 =?us-ascii?Q?15kS8C9klvOok10BshROTG7mMQSFaSKcyXu+lDQHvq6UXmISWf8EyALu9iJN?=
 =?us-ascii?Q?TF/Wl1YFFqdLLDYgMhwHoorBuc80OoFErfFUxfHTjfyArNX3438erlyN+jnV?=
 =?us-ascii?Q?KKY8iu/gs36MNqR1g5TRfhUNjPwbCCye01foTuSdhFRjvdqJM0iexjmj5D82?=
 =?us-ascii?Q?vs+c7GrXGyBwpYIEcPLI53TCzzpVhCM2a8MCrDtdYSpPS639eGnmGDhyf/yw?=
 =?us-ascii?Q?314NkwPw4kVcMBGolvYwKABItJpRUWNvZckzl7OWoBkGm2+AuBNBj32OEm1w?=
 =?us-ascii?Q?p3eJmoLzRGtx4tkFX0dWPXySqOj0CoDrgVXlCXAgxoSSpe4usRPQpd0OsnjT?=
 =?us-ascii?Q?+5HvNQ7tYlb2WBh1jxoJl3v46l62wIcuQUyRSq2Y/MlondP6MyfHz2fyK24V?=
 =?us-ascii?Q?+SWCDRU1LPRH4OgGBLDHGeYJ0ba/qRa2bIuuMRrLUbRVH2XGiihefZzpyNqN?=
 =?us-ascii?Q?ZYKesfOe5wF8D95L0v2g4RK4mufA291zuD1pISlAH6/zFS9eNxoXfHjZ8doa?=
 =?us-ascii?Q?cdX5VfSOpP3JYcvaIcdanNA5FacqkOF12h/o0Fzj0TEiR/LIaDDj+gpiCUF0?=
 =?us-ascii?Q?8729RXcZXeWmqkx3bJapD3FmzIkgspgp+aVE9TLrJEO6oYcTbxsRCVfDByRw?=
 =?us-ascii?Q?s7YX+Q7nNmn5nlOPxRLjMfgHijyIZT/UFKMuXlwVcAmo5JWpJeQHdoAPZZCi?=
 =?us-ascii?Q?ehhrCX+C69Le+/n2BvytBrBz5N/XqOlPFtZUgUGBKXArwPZ3ahi6qetYi82L?=
 =?us-ascii?Q?6/JxYF1k3RsJ/cR9FGl0l8b+B45SMD+gnmB0kmB6FjEc8+uTnLRyWce/6lJw?=
 =?us-ascii?Q?DA2y++0c37niSo0N/gwxpH878/SqVX/QYUtBhdJGvbl7VF95p5t+0j8pQOTt?=
 =?us-ascii?Q?fLYTVNTDONNxs2d6e6NbCfEgcZSZzhSDJUmk3UXv1adp3XZdDMaDCh0/WrVe?=
 =?us-ascii?Q?gjc4zKANIzySUb/0KJe4N3e+URz+xqGlqJF1cTZhJ2q6V0KpdEWg/kFEbFXg?=
 =?us-ascii?Q?MCPVVh2MOysg2anKE5n3tdQQ4JRb16y7O+CkSF9kg9851iRR+SM0fI84hPC5?=
 =?us-ascii?Q?Ui6BJpQvoz0c8yH2eonQhwXPVeHy7Its6Niel8Ns99tovDwxVdMSgjLA4sWa?=
 =?us-ascii?Q?RFnhDSnFxDiQSGfvaqNHxqvo+dXQ+Ke7eIUQP1INf7kpaBl+DECqrlnw+XEU?=
 =?us-ascii?Q?sjLwuoJrHEvkPSxDZocLLQc1sa1jngMBUP2hTvtMd+MxNqWKsZnAj3ApiOtm?=
 =?us-ascii?Q?86e7OjAV+grI8FeMpWZSrHTlXJ0Zqh/jgV+mlLs3192E5aUUC72WyRz3gRtt?=
 =?us-ascii?Q?m8Ij+V+ayARaVky5v8fbpplHISeOXKykWoAv4FzL3tpwHW3TLCKEoaBnEKwj?=
 =?us-ascii?Q?LHfbnN8jBP+cRg1UD3kAOlYQqFTW+tnIi0Kcm2oblsmS71S0/EnjCSrkMXrx?=
 =?us-ascii?Q?vMMaIYsVQ0FfBqN0CnEZNuWdp7vs5AyDnbU7BF5Ab+xiUoIih6YEISV7CYpv?=
 =?us-ascii?Q?bTNLFRaWw9TDgIX4A5heFi4Zh4EySY5n4yWOL48T+WriLz5C+GPexn/4eQ5t?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BD/zVDYTzk0KCNSZ3jzXgiZQYAw3xCqEaCKlkHo+U25yBrrQCkDTtlccNSagDrMl8Wp5+M6i4TTuFnXO4+4SAUaDZCq59Au3aggOXYklBq/OF2QBAQwAClqieR5WLCZW23WZ11HEa9kxPvTc7jUByd1I6ng6hp0EvYh2XZB5n6ehdU4K9gSPA8vdUEbElCbEu5j4lyPHJ3VP3d7HNoAJoxCheDXne/eN1s+IVNAmaVPFGmEGo6scQlL47IlyZUGT8vqV8E/StRaBKHdLJzmCPoTbETrvUk/CvwElqOuopU89Ap/Y7dnzmMaeB1VcV44cBYrl0PRIzLg2GWfnadFKNMaezorFkxgWZop2bgff9b2zojpw0QPTqY7DH1tSVyq+Um4XCT5O6yQp1Jt0Xt0eYYYMTAsCeKTPJKQaED3OnuG8JMxG7eobtx5pQgLGtJzvi+SQMrxrxgc4qyhKw/Lv/GXr0toUTv83OopffRrSiVua4U288ZEkiS14Ke8aopp4vi4OUzZOczp2LBD38Q5Ch3eNDm2XOt0KGZLnbNnn8v6btkkJYR/dnmgYV8mjGCgDbAxkcKl3QnprVmY61hvtFArmXtpEKkhkE7SPOd1r07Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db5ee8bf-5165-40a1-fa15-08dcceb887ca
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:11:52.8557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WTjkFTeopzlOkD7DwIuHTbLnKBkxNdEfTu25/GfLaW9tqNLxkJHQkIWizdQLWJuUCvnrcoSSy2k1VaXZQZVtq0vjO/bBSrfxmrs90zY6V9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-GUID: 9hM4qyxsRF_d3XN5L_iOt9Degs6naPtl
X-Proofpoint-ORIG-GUID: 9hM4qyxsRF_d3XN5L_iOt9Degs6naPtl

From: "Darrick J. Wong" <djwong@kernel.org>

commit 8ef1d96a985e4dc07ffbd71bd7fc5604a80cc644 upstream.

The XFS_SB_FEAT_INCOMPAT_LOG_XATTRS feature bit protects a filesystem
from old kernels that do not know how to recover extended attribute log
intent items.  Make this check mandatory instead of a debugging assert.

Fixes: fd920008784ea ("xfs: Set up infrastructure for log attribute replay")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_attr_item.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 82775e9537df..ebf656aaf301 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -510,6 +510,9 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
+	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return false;
+
 	if (attrp->__pad != 0)
 		return false;
 
@@ -602,8 +605,6 @@ xfs_attri_item_recover(
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
 
-	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
-
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-- 
2.39.3

