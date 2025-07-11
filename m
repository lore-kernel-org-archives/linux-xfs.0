Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856201FE470;
	Fri, 11 Jul 2025 08:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752221406; cv=fail; b=ldRUZx5cyL9u/mMEi+arrfhk0nE7SObCCzpYYOn8qO9o2D83TjwtBaaNe/S/+yCJIjX9SFhDlXcKM5ROuzuLBjYWbQU4OLEQfI6i6LL50dtVLmmnyY5XP6RBwt5AWxalZp2tld2NAzX4BMn9MJW2OpxiZy5BHuOs8wZCWcia6nU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752221406; c=relaxed/simple;
	bh=u1r/i/dGAxAdEVfeqPhnNQm1USkAHc3kx/GyqmT1/SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NfvME9BF+A7tX8fyuUNkqrzoWQQgNjHw3y4ANtdI9eS0J1Q7pUknQy4VN4EyCO1uu9JcUHZGfKww/eyngY4dSnrZmzOuwnxHXbTtiMzQk5MCB6b3C+60/CmH09J1YBGzBMI5FZQGUgcVcYGwG3x0GybICnYfpwAKvdv0ZYRuMBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n0P5NFJJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C1RwGOcP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n0P5NFJJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C1RwGOcP"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B6uxAV013501;
	Fri, 11 Jul 2025 08:09:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=cnZ25cQYFbweYcRF
	df2LjT+/+FdvVsScXa70QuDXf6s=; b=n0P5NFJJFWPsvq4Fc/1EKotYmeKiKZkQ
	iN27WoEM9NAnwstfqOTPchR6taHTcGSkk0sCoHGKJWhnDy36owL0Ht9pPFLPlqYT
	qRSPKju/+YY+pjTQkBonKe6aYE0uq6WtRaMuP2l81orFrM4Hp6OfX1dVS1UvxxIa
	QI1hXPxl8aETx0nJyLMSntUACvnFbekG7xMUHXA31N9wOntzXvVl8tfqBfsErE/X
	15GBL3i/eNISb/tQd4J6YWRRVc1x+UdO3/s04RxKE1hvsL/Zdyr+qUdgjVV3ZDog
	031xh9TXl2Sa0B+CjPBtkPE3g5tbE1P0YGrRKdV83kdxDNiT2M5U+g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47twsp83bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B7qeRm040655;
	Fri, 11 Jul 2025 08:09:42 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012035.outbound.protection.outlook.com [40.93.200.35])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdh6fd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykFNyeD11U5MGwUhT3UtOfVNdwmy5AMwKlwk/HP/AmsMeu/ydotxwY1VF5q4R+kJBvfKH/+u7xnqTdjRAfhsCZcm2GB/ksxTCFgSKUoa2szxGcaH5R99QIoHSGn26TjlkqlIpDVSAu4ULPE6P4fsAz4fLso7VxO+xnG+mRvgPzjd9X1xTSj4NU4jsz2wdLkKqrb9rfyK1C1fA0RJVryDNncUPvRoP0KgJ+FV1Ph+kdIV9dQSetJohID8qCFIvJjEmQPNzIrYTyDs4XK/YU8H3niLw31whl8tbRE1S9CKL8D8UX4CF7/UiLdfrp0IMwcO5Y4DjB8kaj6ytYzlYYUyEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cnZ25cQYFbweYcRFdf2LjT+/+FdvVsScXa70QuDXf6s=;
 b=O8+Qr/Jc96ma8QnROMepKex0wQvSCi9CXOicuH7fHTaKWU1AcYl6WtcjFlKkADGkxqhpULVBLIxLZO6hjP3BkCvVZCidVJUrn0qCvbzNf4lYjRnSj9OlCRiHhKwomxZTwnmLrsp+0tXj3SSk5uWwf67cZZH0XhNtBRhelNNyhgODKCNN9rRx4tLc0T6aqRvNHmbKJoUXTG5vwuMqCHcnDamYEohFjFo8iIeLIdFszllTXw2SahTFUIlBuPObXkkcXXVRYiPcnz8jcaAYuHC286zIs59DgMG5mwGXdkYCgtvfHvOzgaAkecbsnM1U2wg1rbulkqEqBuD7R6NZAHkY+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnZ25cQYFbweYcRFdf2LjT+/+FdvVsScXa70QuDXf6s=;
 b=C1RwGOcPdaxH+p1AFTxr/Yt1k14wK5XoVtpkcWI/njQ+fd0TaG7p3pzJKRHhaIxJDweMVJte5GgqilE2Bm7lyEox9ATdlJBZTDa2p+aTzkBgmetLvY7CprEqp7ODqLQ+Rb25uun4y/d9XIoZjHPJXTodUkjlVpUG14G6tvjc4j0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ2PR10MB7559.namprd10.prod.outlook.com (2603:10b6:a03:546::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Fri, 11 Jul
 2025 08:09:40 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 08:09:39 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 0/6] block/md/dm: set chunk_sectors from stacked dev stripe size
Date: Fri, 11 Jul 2025 08:09:23 +0000
Message-ID: <20250711080929.3091196-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132E7.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::27) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ2PR10MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: a25d2bf4-e23d-4665-956d-08ddc05248c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JXbvm4Pc4KDNIfzwn1H8wYlbw42tOxV4NdARHdUSiSNzv1s5yEx2eDYcbnvm?=
 =?us-ascii?Q?/AENAZfwsPtcIzDvzGTqZLZvBIyX3U7nmz92k2h66WPMCRwKrjycbOUyJ5U4?=
 =?us-ascii?Q?pDi2P97G73HV/ACDm+RBpzX0IpK3Mg+cHqmO/fSVB/LOWnbmyi5dX+yUdMvs?=
 =?us-ascii?Q?YfNd2cj3I4GxjIFJiJP4K0/VaNa6/MrDZQF/EIVYDGFlRHC1yRmYVvT1IaSR?=
 =?us-ascii?Q?Hs2asBSkxNLA+rdf6oQIZbNn6Zd0DNY7kP5/wawiR9++TINRG3gkuxLFek+M?=
 =?us-ascii?Q?MpROc2/PAWEJ5LSHV/wyCfctmkkWmkah+q1LzBAXBuyGaFqHYbkNbQAqK5pJ?=
 =?us-ascii?Q?YUSsYIptksH2NJrhfm2R2Bduj7fAlrDyjr/fkcYsHMJNx70/ny8awHQ2u2pD?=
 =?us-ascii?Q?yXPG1viZyxhOHyCBi4JeaFePhJAPpKxJxSJujqm9KlPkTYqqtpPqMaf2PPM6?=
 =?us-ascii?Q?Gd7BJXVf77bf9VRn9rL7KfJl1JWoBYsQ8tk4KBs1oy9QCOwvLbEifx9dy55n?=
 =?us-ascii?Q?6DO3AqpmWh5xkKhXf3D6DsLNRcQK0wJXHIh2bx3mBO7MJyWoovaF/IsUHSZt?=
 =?us-ascii?Q?smBD6nIvzbpIno5cZgesgERdr66oTuUjhGE+bEz8+Jf9vXswyMR3rkXzB/VF?=
 =?us-ascii?Q?rEXygxrBJB/HMQmCIeNFoMd7XgswqJbUmxL5p24+2ZmuoMxzhcNEuZ6Eql7F?=
 =?us-ascii?Q?Q8xyrpip7WF20BoOjKebYSKok+SdKCxwUzZsSoxwMtpiTVN6M1ichZGcfJPS?=
 =?us-ascii?Q?3M3qMvBRofaEiaExsPYTCnvKI55rmqhQwPJJbax1cIQE+vt2nN+yQE8DooWd?=
 =?us-ascii?Q?b+lubz3AM9YSqXm1A8dWRJFUjsI0/5K0xgBEvCe6VbM5slITkHdhVRpBEilW?=
 =?us-ascii?Q?QDyhSW/HzlmhrejWixavuLSmLcbgMWGxZYEgi7nW2iBMkIVMl4EiwkivfuwV?=
 =?us-ascii?Q?jjzDbU2YG+wCf8o6NuXFqLg7Hdqc46aTrfKyn7dUddvNeIreGU3qgVbgIiUx?=
 =?us-ascii?Q?sVllmusDCiLqarcT+F+SfRtiaKnqd7SyF13GuBIjzF8qhgFA4tZpksGKx6FE?=
 =?us-ascii?Q?4jqjAFzmzEVOeO3nX4LBpH3P0LxhgEwjdl4D/Bd6rqDhpyktRFEEZo45yMno?=
 =?us-ascii?Q?yYacEuiyR/dj7aQGxm5QnjRbPY91SYFtVo/3zQpnGLbGxEHtVs5JVFB261u+?=
 =?us-ascii?Q?JI0oOWxkFpgMn1mERK6XYu/pwulMJG5jkMF8EDyahP76CLmYG30neC+/D/F0?=
 =?us-ascii?Q?+K9OmgSficAY7n7ItVBAQtFiuq1R0AezoEZ0HTjlrQirKIVVqx4OwCgRORaK?=
 =?us-ascii?Q?kluWMIXEcFy8GilYGt0OGlp3FtgLV0zAmmzZwbDSWS0ce+/l26tFQl1x/nPu?=
 =?us-ascii?Q?mgXbfBegbe97UTuAe/P0KODLepv0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6+7bV06SrPEVreqQZw1rPs/yoz4I9sqRSALuM26ok0fznpBXvEKMvKZVDSQr?=
 =?us-ascii?Q?6iPcZ2bPbGQwxG+ubTTkkgp9B1TAtLJys8K1xzHV822NI3VEUhyeVaqSUNdM?=
 =?us-ascii?Q?usYRc8vRSggVdoWvUTrvkZYhlZoEx8diDeLZm5euNSrAb4Hx3ceGpIIXpUYZ?=
 =?us-ascii?Q?M1lZtQAC/j9MAbQSdqIHPQQaSXlsk7qlwuTjuwMili1O0Z7CX1KcKSampQMG?=
 =?us-ascii?Q?gcxNtZofz13b7ewIRB87BIO58Xl9aK6o9lAicmim6RG57Vfq1f+dY0yBrQg+?=
 =?us-ascii?Q?x2keUWoqVXSvdQZNGTkVL2avKWUP0PRBBcETT/lMZQqUoUZrOckFhTknuBnl?=
 =?us-ascii?Q?XxjbEgTc2hJ1Ld0+33fnA/wO1aMxPMj+RYAzGFXU7L6pg5ZdTeJb+dTPdtEv?=
 =?us-ascii?Q?auzNzNuiw371KRieFa45s0xhJxeXVX68USd7KEZa3s1JOuaEZkjEszEMmSmz?=
 =?us-ascii?Q?OqdnDvdf1qEQnbfwXKXOfSNh6q0vF11QJT7LEX+vFyP4+IOo4rxsmRzz/O8T?=
 =?us-ascii?Q?YFeyVH97kjd928+Wf0QIRcNXzWRws1M5OJGHkpYXceAAeic7wq8XH4nxsxcx?=
 =?us-ascii?Q?Z7csH/rfEEqFtNxpU2lexqCUI4c7sY1IufbogKBQ9rMogiPkHf4/QHYMAwTP?=
 =?us-ascii?Q?GXjf8mANq8YPUELFISJIyjufzTZW7MNIbHT5K8QFnfZ7YWUsqKzmEj8sxl9k?=
 =?us-ascii?Q?A6fa/UaLNWNrZHHsibVykepemkSxTJkrV6kTaJORkTatMDxRgwzUrkVogl7P?=
 =?us-ascii?Q?P/KaJhX/Jp5fni2jNmKjGMBYMSLewJ/cuef5rKFjhhcS3xdowdHzkCWxGPQu?=
 =?us-ascii?Q?eUJyNSKaEtaHf+1iOfgWO2ntSUENFNpby2SAMALXYsfRYbXwH+tTsl0TsuZ8?=
 =?us-ascii?Q?nGlP2BKehFMBq0HGZJrXlAvna/hkpJu2lJ4FQVPNRgJ6a+NkfWYT/D4UVuug?=
 =?us-ascii?Q?yzq442c5tvftuBdFul4KmTsnCWXlOVarDMrm3lZ2qUbQi37cPSmqoaTmgWmW?=
 =?us-ascii?Q?lkMdd+g0hyby1TXQCrPmpQi4KP7odojrJ4yRNlNE/PAT90ff4GgkqalF3EQu?=
 =?us-ascii?Q?u1bncKRXo+sYsLpVv6ZHiDtQl1WcB9YnRbNZpSaodMuRevB38j15DkbD0lHA?=
 =?us-ascii?Q?fVC1d8lyeK+vGGysKLDRHvv6/3aPJ3zRQ9m31uGAVHYemnqYgpGRVqQrt6EC?=
 =?us-ascii?Q?wC0ss+6xkAkY8Hb8gMImk+wKJ+QxaqLIkhLwRs2om2nJMNEzSPRmJGNsLgqb?=
 =?us-ascii?Q?GyPiF2rgXjRQKni1OXgUFQIRba+yFnAQ1TC2d2R5ACGVC3NHQGQc3Pt/RL39?=
 =?us-ascii?Q?Qo4EE6EwcHZISzpzLOW+iaYtFPkU91a2J8oBS5HFPnUv/HhgJMIRHp9GFVFK?=
 =?us-ascii?Q?aWXhVykRlIiNOF5aM4QhNYKAveBkC4OVxH5MlvypqhqfgnuGARE8ZPuc0GOa?=
 =?us-ascii?Q?t8T69SZqKafr8No583vZl50pKWMu/E+1RXLfIlwsPetXk7KArj0ZZmuxI/sy?=
 =?us-ascii?Q?jRexdvCgP+CcKw3/aUhS9W9keTSKqU02N0LvhNODnGAyT+N+Ynp4wF4FFkME?=
 =?us-ascii?Q?x7JfoTDwNQDXFwHE8oDW2z8H4caAO1PRNw2uibxYwiUhyRhID+FIuH47iAxH?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PcAKJEJrnXD9XX3h6JRwCso7GRdWNk+hx5KsK5/UvFDDoLt8/vjyT926hPEQOaq6rIgnwuQDtyNsCqAgCZOC5I5dn3MzQy71yMYPikQkzS03BESvvrG7NHOhqMvcfiLxzT4CeRpxl6c9wxUvzFZEGLV1xOlz2t4tvlND0yx9P+Qpn22Thg6iD1cHGwipa8vRh18q4WBINhPaqiM0qY7ugY1LXV7RpQeTFRNyOipbbZmN1Un41+MSh2Bff/9SXjxg2eJTnlqtI0sShNugLpJYG6Jlx25TNMb0wmHHS6hLB8mZA3meSuRW7Bp1ffzs4MHHWPP0k6rTXvjTw9xA18+H6rXbCOlwVvyv3td1alhIFzBWqsjmp/MjW+AdPLQDPpMlHnIIIqNFO4mwtVk3itSoQUtiUTDVshDeTfmqFYeWanF+cfC7NIgJBRXnB2NmYudQHrDPcRLrihPdABOo9D2O8nlNCT4exIOquT/kppkcV/n1FYWFfv42vRPbJN9V3QQw/syMWdCBtm2lZFj00RQd3CbXLInAS161x4BZzUXBM6p1CEi5uPitukixTE4byAVzVVFwJ0Sr2CQRE8uPvSqJxZu/1e+gBLKFhev0FbDI6q4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a25d2bf4-e23d-4665-956d-08ddc05248c9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:09:39.9228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVSKzANhkSDHrMAHmN9vql+KN2nL8mqwAGUnONMObNTSXoAuRyeovgW+KdeawiWdqH7mDE7sRa6FL3oX9PDDsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_02,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110056
X-Proofpoint-GUID: 3kUKCapmIxRWOygq7VJC9JTGFcc7KQNu
X-Proofpoint-ORIG-GUID: 3kUKCapmIxRWOygq7VJC9JTGFcc7KQNu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA1NiBTYWx0ZWRfX1KpXAuwW81/h 0/419TE1b3tl1CRJ6I4AkLEP1oiCfKuS6Tj7PCoZnGkQyiXzCsOOay/7Cu4m0uzfs6iLDPXFwka Hj//nakUl8g89kdEKohjTlTWXUozKAc7BxuGR/8tWncuOVdPHM+6J+x8Zg/VTjjQflzcIrWuO4p
 0nOScPGXmo82d9qPThOytgTEBc26qJN/3nb/UrCotVylw/2Mm4iX4UvIyDqJLqyGpD/lOMzNFQv 5ZuTFwxrZXppO3u275wWNQg3L/4hckZs8qaQksf//cKEHXiFNBFJzbTBGMpAEG2QLidh42QnnU1 CnoMsrEx/6KQC0Z+959JhDPcv7a/gJ6Hg7Q4nZHxfofzd8Plp2/8GDp0ct/xYp7N6VXk4snDkGj
 WF+EtKc/tH2TKvudP72W80NFwxarJaH29GO3B30qX/ucexBfjA/2domwOOh8INRewomw7gfx
X-Authority-Analysis: v=2.4 cv=JdS8rVKV c=1 sm=1 tr=0 ts=6870c6c7 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=loq-tJhv0IFIE_0Y8b4A:9

This value in io_min is used to configure any atomic write limit for the
stacked device. The idea is that the atomic write unit max is a
power-of-2 factor of the stripe size, and the stripe size is available
in io_min.

Using io_min causes issues, as:
a. it may be mutated
b. the check for io_min being set for determining if we are dealing with
a striped device is hard to get right, as reported in [0].

This series now sets chunk_sectors limit to share stripe size.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Based on 8b428f42f3edf nbd: fix lockdep deadlock warning

This series fixes issues for v6.16, but it's prob better to have this in
v6.17 .

Differences to v5:
- Neaten code in blk_validate_atomic_write_limits() (Jens)

Differences to v4:
- Use check_shl_overflow() (Nilay)
- Use long long in for chunk bytes in 2/6
- Add tags from Nilay (thanks!)

Differences to v3:
- relocate max_pow_of_two_factor() to common header and rework (Mikulas)
- cater for overflow from chunk sectors (Mikulas)

John Garry (6):
  ilog2: add max_pow_of_two_factor()
  block: sanitize chunk_sectors for atomic write limits
  md/raid0: set chunk_sectors limit
  md/raid10: set chunk_sectors limit
  dm-stripe: limit chunk_sectors to the stripe size
  block: use chunk_sectors when evaluating stacked atomic write limits

 block/blk-settings.c   | 61 ++++++++++++++++++++++++++----------------
 drivers/md/dm-stripe.c |  1 +
 drivers/md/raid0.c     |  1 +
 drivers/md/raid10.c    |  1 +
 fs/xfs/xfs_mount.c     |  5 ----
 include/linux/log2.h   | 14 ++++++++++
 6 files changed, 55 insertions(+), 28 deletions(-)

-- 
2.43.5

