Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D773C0B;
	Wed, 16 Oct 2024 00:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037500; cv=fail; b=C++K6zwxGZOUjJae/sw59zv/k9z1FO3aS9GR+GELaZ7PxllGF5r309mfL+f5Ta3uPKdNuCQCBmGQ65/76x4j0nukzKVPZRXjbMUzSHY0yU/yMSM+LF+xaSDyq/ywetjDg3kbctsJJHhoBGS9uPQJHlNhaT58S4frDN3l+LtiErU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037500; c=relaxed/simple;
	bh=SoqskKKncj9l0P0o5EifVXAAp9nHXsBkjf4Av5FVD+U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cOImy+Hjn5NTt1TTgRwYB2YcawDFznCaH/MdIIxC5IuJ24YLkgw3SA54W7ifzk95mr+uzUbmG9VRk8lM2K6DAPCzwxC5UsfROPRz14JatVRrMYEUofL62TqpgNN311gkYTUqBHL6FsHVZtj7znl3KJjyvXCZYbWAzr2FO+xQdLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HCP9d1ty; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=npqav+0y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HCP9d1ty";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="npqav+0y"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtf2o008287;
	Wed, 16 Oct 2024 00:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=yPrKlroy3mFa9Th+wAuiayds/9dutHvEz7KvBXCbRF8=; b=
	HCP9d1tyOFXE3/RcpPXR4eaaODFuRUnC/+SSyfNvQlqiRrzObDyMo5px2LKoZdY5
	n0YGizgRFXyGxsZHCuSOMELVxa6PTX9/5zmhv2BsI3sGiTkpzgkcP1RKqzh6VijE
	Pkn4OnqX0ANWTIbYhZt0BzisSzcGCbzTqdKFcpwlvbfgTpxwdGoJkSvWdZXFYesa
	wVWzHuwKsjD+hLjW7X6pmJhlsx6i9vitTaBvB87Z5EjMF4IbxJKlPAMOn8eBpUjN
	VtPKINcEeJSRzuViyqw8opuGLL71izcRIh8SYpa3oJb6qcjQ9M9wxuGAJ+Ymkc1Y
	YYHV8g6pztOUfy633XUXdw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hntaj17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLKOWU020102;
	Wed, 16 Oct 2024 00:11:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85maa-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xyLVblmqcLxRMm88+fcn3ZpvQwgQKCc0MuEwzMsNORR7PlfDHMXr2QxLYm94Cj8WrxIyLGWQ7a28xOloZ27IPKQgvio53TWqEPQWNfMNEAx8ZyOGCKte7h5QIG4J3eTUfPJPC6QwfSWJ6koZ1/qJHCjTc4W2cgaG/HMUYA8nnf7AYP9fq2KYEmyjSytEoKd3+GxWjXY5BFyyr6Kj1N2UwuK0PUFUTx4lCYMzUpJIcXYal0TNn3ry7Zl/qchjZTuXMy3AaDgEG8rdVIEaF2PncBzGuBbbnrWXGvT4S3DKrI2yRpVammBcpkAduZKU8dN7pbgwKd6vyXntYqGZ55TVrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPrKlroy3mFa9Th+wAuiayds/9dutHvEz7KvBXCbRF8=;
 b=R4ZcgtzTvuSKDUfSP2FoMoJOdX9pO5SiUlFm0pgZCRIufh3QKjAH/BuhTY7vhRlbIaW3sxjS+9DP9LRcRRFE8Z0ep8BFLINGv3VxZcGJP7RoC3D/2FHeo13DgNX5iLYqjOqfCPOblB+XEWwBbFWA7kWdkSTUBrYYkwQZBD4LGzonqj2T8iNBIrpCjAOpoUhk5L18geYnL1u9dhPur1hFYS0xOOoWct4kmnrDh2rsieXp4BNs+Dt5DE+JpUGX24WiMnkjo3dKmYn6cfYl0hwWamrFsxwJzH7pM/ApZQTiUXxNs7PZMAkPlbIz/U5bgoM1+BdbCzBoDLgKXwnkL2RZiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPrKlroy3mFa9Th+wAuiayds/9dutHvEz7KvBXCbRF8=;
 b=npqav+0yNZbn4vQ4ZpaF2wY/HHCBhHI+HEssaq5rH41xigl1MWMS5R7mX12R8m1priHLoIcCccValwQ0TBq1NQNhclPsJ/Fy5diOb3WRFIBeO8eJfRbQk0wK+75J9wN+hjVZ0hl3udu9jXBdgDjwMpFk40QuamVc3Pw4TZbmDsY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SN7PR10MB6977.namprd10.prod.outlook.com (2603:10b6:806:344::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:11:35 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:35 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 02/21] xfs: fix xfs_bmap_add_extent_delay_real for partial conversions
Date: Tue, 15 Oct 2024 17:11:07 -0700
Message-Id: <20241016001126.3256-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SN7PR10MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: 04637e0c-0c5d-4dbf-f215-08dced7718ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gBsDZcHasFSPs9xtRpMFPEQFgKmoWAWjsOCJOYFTrPXGVb6OsrDrlmvUjSIO?=
 =?us-ascii?Q?AMOdFNxt3QhKvYLB1YpE6zKlGe1cLKBCVpipxNALjG1NKoIG5Qvh2aKuqfiS?=
 =?us-ascii?Q?gqmlKj9+PH0H2XVoyVb9cexnGupx+nEHyYfNGkXrJY23zK2A+EXiucha05Nh?=
 =?us-ascii?Q?5D/zopo3paBsP3o8mvdL3DNjJ7X3LohNHL6dx7/8tS8/MFRCQTqiOiX0Pwuu?=
 =?us-ascii?Q?HkPZBz/lXLeqpTn3J/UGaYnqZ5f6v9mihUi/JD+zNEH91AXejV0z3awYWYp2?=
 =?us-ascii?Q?uUIDJUSRxjs+UbgGYZfNn920wpzvQrUHuPpa1/F1clgT63rWdothUCFewHoN?=
 =?us-ascii?Q?YGtKSbOnxJFNhpfd0A0T/nHnoYO0ubBULhH3g1h6VI4dPTIVLXtOCWb9yC5W?=
 =?us-ascii?Q?ZVgWp1O1yj3uOc213gVzcw8Cls/YIqhr1tYmvviRCCxOvF9f+K/VP77WnKii?=
 =?us-ascii?Q?43g/DrdmuQIN93I6fowaEmHCSJbBG7sNogkcYNFlgug71U2M9ztFtjJQgso2?=
 =?us-ascii?Q?qbk2eubNYM7fkGp5FrFAc8B9n4PJq0ToAsOkg9Q0a53/rJgUt9lmcySB6JzI?=
 =?us-ascii?Q?/ihHpTPJkSUONt0/K+Y1dRhk1pqb+MX//d9MV2itHInoq0ag+/d07gPeyObP?=
 =?us-ascii?Q?ttOYkGtD2LaxSmaAJ3clGUif16cRzhrETrMhl0uZApTlC/BLVYrAe884vRuR?=
 =?us-ascii?Q?F+cWofB+sgfh99s4tVJbCiX5mOrrH4Gt51qklkNtq87cVmewGnmbLl3kr7YX?=
 =?us-ascii?Q?qyURGnSAAekr/vwqhZQumVRpJw4uOQBEFjn+/y2DRUP5pt2/MTBQNHRa8PFn?=
 =?us-ascii?Q?GdOs6Cas2bbPR0C7CIO9iAPIYuIpo2WAWn4RJCz20ijvvEkS5JID0KK0AFGJ?=
 =?us-ascii?Q?Wufb95z5Ngw63jcl+5fHE+ZrisgyY0tP4iGgPXOVeZRyCepXpZaLEX1pS6FT?=
 =?us-ascii?Q?0JjQ+NTzfd/LbyJeUBUv0+JRLDLptX8inm4aQtqdQrHf8TYHaxXY8EAf8BvI?=
 =?us-ascii?Q?yStq4LwvqJENqYRsobkkVf52/6RK/KO43Ufrib0Ex3BUqV19J2Hlc5P6Wb+p?=
 =?us-ascii?Q?+UFud/9dRWpGx3vzHk+cy1cszY7X2IC8j2bag/iUvJc2FjDoVHqnAJFaDEg7?=
 =?us-ascii?Q?n104/U2bOPb4p4E3HvVXY9mqqmlYtwV7iRATUKuAfjq70G0MfvCYZSUYEy4l?=
 =?us-ascii?Q?3Gr1VxIjvStD66MkFesI/YZpLXwiAGSAfck2sHDzT3bjSgNxzdUoMi8dmuDG?=
 =?us-ascii?Q?XkWUXY7GzQGYTuR1axQjG77h1rPWHr76+FpCa9nkQQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oeWfPPQz6438ybMos3NrG1lOI92C2MNCffJHKv76zcoTA5gwkdXdcRqsGbM3?=
 =?us-ascii?Q?m7x05DCp2OCt5e3TznOZAX/87yDHX4it+wJCdUqFmTt/2LzfVgLmA1wYaSJU?=
 =?us-ascii?Q?2R2tMb37aKZapa7xDo4dgVlIMiFNFv3GwSZx7QCYMt+VLi5EWkT80dbKyirg?=
 =?us-ascii?Q?jGCGXuvLryl0WB83mfGcA44K8vGgOD5NxdEnqWyXdJypjlPKAFzVYHk0RnZ9?=
 =?us-ascii?Q?dyX1M5eWyhDWCcV67ehrI/xoLs/uJbobhBdbJeJCG8TyTP1ZaHqMKTogR14H?=
 =?us-ascii?Q?jMQFt2Qn3lWgwLYkWBVU2yHTp4KraVGX9dOM2ZWSyY9hLKSW4Vs4H9g5KHeI?=
 =?us-ascii?Q?/UUBMMW9goYtyuWtTOYnMXJjwBpZ9Ge1My2QKNOZq4Ja2Pf28mdff8NPhxn4?=
 =?us-ascii?Q?kaF3zGFkZdhSZ9xt9XJtfrAKX1WWVP0nJmFHEbOLVcnXyaXW4VPLh9GxtFuY?=
 =?us-ascii?Q?kRu8P/0Ca+6bWqmmYllch0/ssDjm3CxQjF+bFvQiEm3ZeeNO4E9eLy9WGYRa?=
 =?us-ascii?Q?Doagw0VTzgSCyfBTvEJQjAQG6Oh6ClMq/O8tGDb9JxqkBOrWVapaKPQWxwaY?=
 =?us-ascii?Q?pynmMWABboXIZEpyh3Dtv0NElR3ojDWengc3DVKuPnGXNZlqJKffQADMCbSW?=
 =?us-ascii?Q?eigA/+3U1lXFkRP6V7Zj5TkgKTPOJadtnHY/ReQ8wmQ0XH9cbiqkazMFcji/?=
 =?us-ascii?Q?RLgDzI2Er0tZUL+r5VEEFia01GuKwujLvZj8CiLfGyRTCqIHJhaUXR+pJ04e?=
 =?us-ascii?Q?TTneKu9ZV1u/CRZabwbBjOJXu7wyqM5p0UlN1gJnCMwi7Hh0erM1CF+2X5Kp?=
 =?us-ascii?Q?OUO9ptq1i39SKsV6qAwDGVMVY2D/vlEkb8iML0JJfE5KbAZ6zVBrNNu8j25E?=
 =?us-ascii?Q?aknMh8i914pnxq1BuhJwbK6rGlIbzxZuqt8MJgdv50q41QxrvUsgI0CCYRjd?=
 =?us-ascii?Q?q1ok4IUp6InxY3B6JMeB2D3EH4ClH0DRyCqTXomBE7omk4rx8mlBBkeR9ckh?=
 =?us-ascii?Q?rhGniQxhxPXsFbyQIuqV7wtSvlvZIJocOcC12ljUF+AUsTx+8YvyRDCcHsoI?=
 =?us-ascii?Q?ztK9qvpEMaqCDc9Fd5/no5JeHduYtH7Zeb7Y7+zUtu3cqqEMaHSHEwukl/+E?=
 =?us-ascii?Q?OnEYgl64v5jOPRrYB57bA287p8mZjSPyoj/SYKM+JFDcnfBHheyGCXgIQWU6?=
 =?us-ascii?Q?oeFt7j546510eNlTfaoW501vd6aiTtRp5xbbl9YIFNeMo/MNZtOASdhbw1yK?=
 =?us-ascii?Q?3I11B/JlBjHJegHz69Tg/2sCq4iN3E/gxyxN+9PYHslAgNJYP0nlX84a+YYY?=
 =?us-ascii?Q?VN9fPu4b0/cbUbDtyT3AYf5SndfEXLcDr5XUh7+qkR/sPwHAU8wWR1CTT/B5?=
 =?us-ascii?Q?i4dJbJDYPUQKUSZD24kGrriLrxxMpBo3NpozadpAC5M2o/AsFwgC/jH2Ow4/?=
 =?us-ascii?Q?EbYlg+KPNzPS9dB5skxrrQxrfe15jLZPbS0jTWFAI00KcE9wmzNkrPN0ttaV?=
 =?us-ascii?Q?6FVPNMVKDntKFqSQOmOVcRAQLSMg7EdSF/G17ZM2j7Xfr7Lm4Wmy0AoKTDJp?=
 =?us-ascii?Q?HGYmj4+BAYqICMaD2A8kOpavsd1W5gRO7kl7fRcE07bm7Uo5MvaJrLMTIZJ7?=
 =?us-ascii?Q?TMn/xOkX+2SDvG0N2TTeQTVXjCa0bNGx4+rTUtVnD7CLMvsc/VyMtZrryROn?=
 =?us-ascii?Q?k7gVsQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O10nQ7S1wOGLiGsLVwiOmDuaqmrAUqVOVWz/UUNqUwOdcC2NeO+4U8cr5UHqug9K7Anu7jy+dwgqjQSXU/lyW7tlqlCYvGm+f/5x4asm+brWdjHim4FspfHaiYz9hMqURNz7bEVs99HLRXpDD84+ABha0MRIFgCCWBTd2bG7AkjFJIJgsbGAHEezvJW+adC+d6YH6zqmZ9E9OFajl5I1i0ybWBc8ErCylwLygUhyysJxkiAEMzU1YatRHd0bYrQwT8NrVO7xdEu3vmxqoAKsBKfMbzSjMvlES4cVrg+6wIQz0oZLKP0FrE669PQG/kuuqrv/OL6clplBEMW+qqM+8L1SR0Mw23IhVhtWftjbMJ24JRogY/OmDi7q0S6E6LRZSlgMFVwEKFe2MmLcND5pWIm+hz7SB/J4V0W7RB3Ufd1NO8rR/pNE7zPCYaEcD8hz/5Sxp1cccqMnl4Mx6FqhXKKuQEcvWoOJMh1z7HZWaHYBFkV/U4g5luzpKBOsuvFayVBc7fqANnJb+X5hRmR0C5eBvRyQjoNcazP/bkvNx1diItAiRo5zV99jKds7kCAAwQjbkJ5DxUcJzyuPkXc6AnZz74HtFy0HioPxumdmAX4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04637e0c-0c5d-4dbf-f215-08dced7718ab
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:35.2038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNyA70Kr5iwLXNvyb+7L8MfTnVXAjp5GM1E3OzPduaQuXoqnpBZjOuRTIZC1JoojKKk4MpEP0WfmZEathpedt3v7DBnxje9QO5nFjMfdp/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-ORIG-GUID: rkfUa_6vhFGehIxXHZ6loTKhp3UvPE3X
X-Proofpoint-GUID: rkfUa_6vhFGehIxXHZ6loTKhp3UvPE3X

From: Christoph Hellwig <hch@lst.de>

commit d69bee6a35d3c5e4873b9e164dd1a9711351a97c upstream.

[backport: resolve conflict due to xfs_mod_freecounter refactor]

xfs_bmap_add_extent_delay_real takes parts or all of a delalloc extent
and converts them to a real extent.  It is written to deal with any
potential overlap of the to be converted range with the delalloc extent,
but it turns out that currently only converting the entire extents, or a
part starting at the beginning is actually exercised, as the only caller
always tries to convert the entire delalloc extent, and either succeeds
or at least progresses partially from the start.

If it only converts a tiny part of a delalloc extent, the indirect block
calculation for the new delalloc extent (da_new) might be equivalent to that
of the existing delalloc extent (da_old).  If this extent conversion now
requires allocating an indirect block that gets accounted into da_new,
leading to the assert that da_new must be smaller or equal to da_new
unless we split the extent to trigger.

Except for the assert that case is actually handled by just trying to
allocate more space, as that already handled for the split case (which
currently can't be reached at all), so just reusing it should be fine.
Except that without dipping into the reserved block pool that would make
it a bit too easy to trigger a fs shutdown due to ENOSPC.  So in addition
to adjusting the assert, also dip into the reserved block pool.

Note that I could only reproduce the assert with a change to only convert
the actually asked range instead of the full delalloc extent from
xfs_bmapi_write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 97f575e21f86..18429b7f7811 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1549,6 +1549,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -1578,6 +1579,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1611,6 +1613,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -1643,6 +1646,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			}
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -1680,6 +1684,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -1767,6 +1772,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
 		xfs_iext_next(ifp, &bma->icur);
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -1814,6 +1820,7 @@ xfs_bmap_add_extent_delay_real(
 		PREV.br_blockcount = temp;
 		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
 		xfs_iext_next(ifp, &bma->icur);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case 0:
@@ -1934,11 +1941,9 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
-	if (da_new != da_old) {
-		ASSERT(state == 0 || da_new < da_old);
+	if (da_new != da_old)
 		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
-				false);
-	}
+				true);
 
 	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:
-- 
2.39.3

