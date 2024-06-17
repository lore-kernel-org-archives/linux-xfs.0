Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BD7176AB9;
	Mon, 17 Jun 2024 23:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718665443; cv=fail; b=Cb/tgpMLDg+MlM1CspWrHc0xntByyTOIVpN9z5+r+oHYnwA1WQrz+3W42rroErrsZug5IFTdC3IeVAThvx4gGEBUaS2l2s3SDVGLL8eJXO/fLmPsxI42bl3bRUBIGsIMD1A3jcIKvsuJF/WXdF/XyRGDELezCNe68ivVcJacIwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718665443; c=relaxed/simple;
	bh=0R7BOmsr/qMyFRnsZK/VXdhrCJnjUxjIQHudJfxzFL0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=I1y0hEk9kiDXNnJqQFjJzLewqtsDYtjli3I36IWLCDlEfIdodg+KDcTGmXKFR043Wd5QaIGA0wv/ewZe3uVfzFr3moXVLihRdRR0/uZF/Zn5kG+sQbwiCCkJZZpXfXDr4N+VT3kyUrX4B+A8jLzj3LQ3qy/Tv6896ZSCIQhcxfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T1Psw16B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SwDdDk/3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T1Psw16B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SwDdDk/3"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMXS7P010504;
	Mon, 17 Jun 2024 23:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=Hr5v6WhKuXJDns
	KerHNBVktZgzDcwQfT4b3RubkdrYc=; b=T1Psw16BRMDqjn4/zg1UGKpU6qXqyQ
	PGIvZK5yoNrx48de/Dv2YiqU1nr2Of74JnvuzbFicjCX1s33awFCeaqziCRIce02
	ortfkw6b6AfKwEHgPeyndBzsAWOSUexLiD30YWUjnrzZaSQKyW2kF2cQtXaLV/HU
	QBN5TrKljJNj2/y1lnH/MKAxE5Ma4dqjpGaHozZ1gR1tVZRHMSi4aNTcFml+EhiL
	bXy2QPLb3+hn0DDYG5NPuZA6xDa7c8JUQrW+aiU5ct+B7loj0C6s8/6+7gS6OVZX
	4bo05qKz+rf6p9WOJNUdwE6Bh4vDKaSGImBtYVxoQA4YM1lG8nE+RhSQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys2u8kpye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45HLjQmB034465;
	Mon, 17 Jun 2024 23:03:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1ddks66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:03:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVnKWnH8NKLPJt3lua7891wq1bFKVYjYJ0+CiAh8LMLzJBno07M3JBVl7yw57DEDC0SvFA7ntpb2hX3DB4aD5s50oUC3czYgwSyiqBEjGBSFalVWvniIY44KXte1aAHhFpwOvuWGPsHElEIbqtW+4XCn7LXpdGD5RRn4QxlKsDvNlk0x5NoFiAekoDSzgsE3JHYOM7FOWMEBRRr3HsxtUtOclwPhXazsCrBAbZJSMKgou8U05GW99hd5BMnJQGJIJV+9hPPYBpldXXqeYHIy1p3N2TWnaxxJJC/QX/DX673siiD9OoiyA4r4v2xqGOKQ6bxaWasmY1aG5S3s1rYmFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hr5v6WhKuXJDnsKerHNBVktZgzDcwQfT4b3RubkdrYc=;
 b=AEm0/krgeBRXQ3rQAO0QDPRHmvTRXzWcJh4IgsE26bGjf8M7nHTVqPCmhdU3ndi14A4FUrBeaBH7nKsiKTUt09iaJc1vkWywBk5DsgdApqEXtOXbnufmXpWv3nHkyyBG4HGLIPa1PnmBe/Sm5FlTG7WObZyjGvAoz9ECuOfWwg8Z34Sv/FuWN6kCJi9J3prUdYR7Y8VI5OZGZ+rhQyDJJGIXSG8ZEX505HotgqwxjomjYsfFOwb+Wj113G6Bot6DM+M9WVtKhFq+W6j0SluoiUUtLFl+v0Su3SDu7ANd1hRFYXBW2uMTFhgAvsCupOOqEsAFt/ZNwtiupcnn1u2OaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hr5v6WhKuXJDnsKerHNBVktZgzDcwQfT4b3RubkdrYc=;
 b=SwDdDk/3unVvNl4mxy+l5inOtaUQWlwlQmCoW2tiLWfnyTa4RTBdHCWczKVXGlA0IxKyIVHhQuoVvuCaZv2pymlo2VsA9uvUdcPpht4U+pKlcUlNfKxqzOMqPOJksv3ZnpdUol6uGdt+CQ9wzU9d/Tp/H6KTHoqJ/zbrLkQ46rs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB7398.namprd10.prod.outlook.com (2603:10b6:8:135::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 23:03:57 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 23:03:57 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 0/8] xfs backports for 6.6.y (from 6.9)
Date: Mon, 17 Jun 2024 16:03:47 -0700
Message-Id: <20240617230355.77091-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0343.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::18) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS0PR10MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: 44422826-e41e-4ed7-6212-08dc8f21c483
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?Kd+bTndyq2E1w5TTdwqLTVOfiGoiNpM0G1TKjABKEWJdSuB54vmZQC7t+BG3?=
 =?us-ascii?Q?la73OkxoCCY+zlhCBnff0/3AwIF9y5XpBl+91W2svoOZ7ys5pkn5IKnf798z?=
 =?us-ascii?Q?MdFXPOMzDnBQPAwxBMPUKTw6IxGPAVa3yD/vEFCzTgBPr+Qyd5ekweNSOM58?=
 =?us-ascii?Q?D+KAR3Aq2euabg5Q1FrtPhk73wBnFWyPSU7f2UzwIRXZYxEGM8gOX6LI4et4?=
 =?us-ascii?Q?LAiCsFBCm//rQm55TtM+oE93Y9cZYuF+Z77QxRCFvSe9byaRGMhrG62uVLWr?=
 =?us-ascii?Q?A4RuiTBwzflNCCkvzl/8f4oDyLUvJ0ZPI+mQcps60efKLELdZIqAupx35NVD?=
 =?us-ascii?Q?kzwLXwoSL28T8lrNynCJACtP7AjcPP2x1pLISp5BLrbfehp9sfEEbZAuVaIn?=
 =?us-ascii?Q?5BBhYbgUNdv5TuUKZ5EFwfstC+vKFlbfYnoSHyYnEv5GuHPNU3hydfRUaZ1w?=
 =?us-ascii?Q?Wt3Y2xmPCkLWHUXBQ/oIVUqhtWjBAN71QwVVSm3eav7nz5P/j/x59fyiVnUV?=
 =?us-ascii?Q?ny0zXBfQ4sGfYtOfy/fWwYQqF+cBon4EiRQe+QBbV/AYwOWY6uQOVnFBqucw?=
 =?us-ascii?Q?eGgtDNBS/+ZeWWXkfEWgNSXh1u0mJgw4V5Y1Ppvuh4exIWX4WiOp5cxi/ShA?=
 =?us-ascii?Q?vviBPr0/9UIFV4F1owZ6V2xDQN5BgEqqDBm6Dm5416w//DZsdhR4uikBSG0T?=
 =?us-ascii?Q?4B5u8WlvdA5PmcKJbgVmV4NA/pIdwtZmTtSG4mJRxymBhZjtuCm5az96+qb/?=
 =?us-ascii?Q?bKXdamS6d8/7PQ/4O0KiH8mufDmtQga+lgGRnLiN8/F/T3Zu8jU/Jcdg/NOh?=
 =?us-ascii?Q?wQ9GhjseyKna2+c8plw/Y4tJYIjqLCRrm+oaRcRu6DnJTBaKXtTbUyX+rvw6?=
 =?us-ascii?Q?LFN3YUATlUxNCZ2cJVk/fjSH/4qmrjdqv218b/Dh0PpY3WE3+dqU3ThvWH4N?=
 =?us-ascii?Q?MkptKXXAdo5bOJ+7yKhTsd5vwuhAYykJd/KLtgvB4m/WIh0z3g7GFjt4jRGt?=
 =?us-ascii?Q?0falKNt4vo6mgY+6O+UzhfJTh4oGA3ma68GAzTEEhnksIyLinnTVFT2IN7W+?=
 =?us-ascii?Q?lFLCc2PtaoKUjA5t6jEYMXbzABetZOh26+DPfQvZGva3XY4E1UuBNiqjVXq/?=
 =?us-ascii?Q?D4bvgmmSXxccGpap84AeCHpIeFYoShK2kGLFazyZ0YSX1Ko4nbJY/y2vL3ox?=
 =?us-ascii?Q?LmEQAdIasFt6UTG1AO+OXFcKw6b+89lR5Dr/8iP2oYQznWcJVZxTB5GOaSnS?=
 =?us-ascii?Q?U9taZ+dpiJtWzj5Zmaiz46zCTSX50WSEw96WbQ4aMfpbe6AmVzD5HsNcE7nq?=
 =?us-ascii?Q?9qCRBNDx4l5JVv/sGJLJP3GE?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?o4tlTWtCP5mbc1f+Q47r2XGsDIDJZ/ey3UaUSVEOFOs1hIH8EFoRX+CyAQpq?=
 =?us-ascii?Q?jKikiyApCRTRuj0/SVmt+hdbRkpBR1SkUjQ+a502ROox9qoztSmWf14G2C8e?=
 =?us-ascii?Q?pPTs1rrAZ/AhxL/1Kj94tE85uqTxDQDDmHJEY+/tvvYSfl74yjKjpDzacR2i?=
 =?us-ascii?Q?4NVDIS+Yi5l7P/01xMSO8GqCX9QcQXHlRjGgf3og9f4+jYpKUfDi5+h5ER6a?=
 =?us-ascii?Q?WviakYjeoMhlTkhIiMdkptvM7koV/yfvyypfMPFDOE+5UrlL+VXe6Dw+r+IP?=
 =?us-ascii?Q?9pw1RDeLAHVcnfwwLsNB3V1d+il+Ccv9fW069eY3WflEbXCnCHr25sVmZogN?=
 =?us-ascii?Q?ZEDt0wy1xPUGlv52iMRBHSJzOW0d9x0fgG5g9dnmcZAN5n516JQPzzOIbS2X?=
 =?us-ascii?Q?JIuDifw0LF0RYSvGtxNZHyBs4q/xdizxn2YcgwbbebGJUBjdRhMbaJdw4umv?=
 =?us-ascii?Q?6oOaN5ukSatDN27LecNHMJPthGQP1dXSKtV5XqSeZnq7MPrnC4/gJZtbdXnr?=
 =?us-ascii?Q?Cb0Ph6F3w8Ig+WhEDwtE6x/D7XSUEJ/GrecIBDGqf9IAC0tWVRSSqsjF4TTi?=
 =?us-ascii?Q?IZkTNMLkJSL0Cv4EfnhbeYo0ktEx8I1JXhq7PiNNW65bS3teMzFIi4WhzyhP?=
 =?us-ascii?Q?RpJ/nWRbtDvnVZ/8igDMuQ3of95IGrzy5dqXhpYqENRhHmdpYpV/kYsvGfTa?=
 =?us-ascii?Q?4JSB93xSLN6pFT3jguC+HGDg+pIaeGHxYTmFiqjkcX8A1D50/JWghDqTC/MF?=
 =?us-ascii?Q?58ee5gPLrsVMqEr8Y9Hh4+mpJ52ZhWT0TwPRecYsRMCRqQJ6HKnucpy8RPaJ?=
 =?us-ascii?Q?zg1/xiD3Jz3dw1JBjUoGCo78jEW+T8HNo8FWrtv2P+lg4wr5l33zKqu2UiPd?=
 =?us-ascii?Q?MF6y22xIb+mkYgh8kWA5ZsxahWVJabpioH1d4g/QZv6jGHPQCrtRCrGzh7S+?=
 =?us-ascii?Q?C0LDkyaYsAMpRMWwLXhThnxef99iZ6DqzT6B5m9y7cFDudz0jBTPfOLz4+Mr?=
 =?us-ascii?Q?ge/4z1Y2Znr2uPuljF/E/F0iRTeJEAXdAlG3Qo2InjrkbhCzyC6Fq4JeErFf?=
 =?us-ascii?Q?TJECfaYNjgMkvJtXWRy8GA65VPAiymirPj/zKnratEpo+R0WBGX0fXABP6g3?=
 =?us-ascii?Q?JlUy4BsJXken6A0BOy+lBp5qnao5QEmvPYOprCBokwdbdXCN2nk4CF1/lImx?=
 =?us-ascii?Q?h5jvTgp+xNGs02H00cRtDas6l+SK5KBLeCc97jI2e6SNDM36S8QRHY646lGe?=
 =?us-ascii?Q?Z+bbSfCvesta3iiew99yC9x7LzpRgywsCiUPVchCP8Q10BtUinCsqROosBR4?=
 =?us-ascii?Q?t+K5DcRf50r5HxHzHM3qjPcJKGdlUVKYJqcAmUzQ4nanzofXUVY/+eO/m067?=
 =?us-ascii?Q?OHf5bh3R1m9cKOSvkFG5urFrQpWxf6aZYRQfXxjpgZhDyw3ir58S4lIe8yLz?=
 =?us-ascii?Q?qOjL/l8jqiK6l2HLXHH8RJEj3T1JeTG258eFTEBoeY98dqxQExb2ax+kkq3r?=
 =?us-ascii?Q?HWmGY+jlG2aIgnfvHRFouJo4uIgc5wDWw/t8eqX1OnUVTxcNmqUlvlLhUVDj?=
 =?us-ascii?Q?CcIKga/4dXUOPxyBXdteQG9Lfk1meUBSljpd75P0gry0BV+N/U0HgXDUCoyi?=
 =?us-ascii?Q?2sskOnPK96Gf/b2Mvz+Z0SQNp+Hsrabrivkx3M9TmhqiTB0j9+Ros6aQWeVm?=
 =?us-ascii?Q?K+y88g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lceUngLAuJfq8mb8q3kCYPzdQXi+kkvoMCBtGzK+jshHb/ZEpjR+GaOImP0yrQDxeGCpkjJq6575SM7nEfB7Mv79hWFTjZLmzAypdZXdXQWJfNEBBQ4tn29zZjzaI3kuWKq+mzzZ3yJytnbWIvNqNExjpMQBp8i3OxpmeZJQ+iqPuh26INR8+XKqOG7Pza6PYSNDCuT3O2Kr0HaVMC7FR8yLZ5Hb8FFnfbB5oCMQFLU2GOKYTgvg1at4hbFSHMvpUU3dqzfiSOGrtpAljBWf/dsmA/PDdp+p4RJzvH88u0XVBgPh2Xq0XW0GY7tHsOZH4b2xHbH/kN7nXMhYGpTk1NV9haaYi2/9ZZDVqn2yfchCd5DAxTqtxgG3XobWhrECkQJxz+sveqP001lQaJHLlIc2cdXHSj70aemsoY87dPkPDGpRmUW12U17iUBmgTOWBTam+m40paEA0WcI087zZSoanectTlTvq34EPYdYsibvWZlCILEM0EyY5iW0rIjNh8kPOPuqqok5OpDn8FBt0Qf+yOabhpikYxlU1Kr/vPiv4zKMWtdxBZGtLA+AVdX3SAGS97Slq9lC8oY9K82mQAICEejBWTuBa6Jts30KSH4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44422826-e41e-4ed7-6212-08dc8f21c483
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 23:03:57.4042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qrt+j5FRsVihu1/W+CFHe35NFVoTB7X6y1Ugj9vYQUHFU5H/ivJ+g1LsfIM76R0WmCJ1V4pAK1eLjWJp71yqAkxr+t530a7gmzp0jJngvX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406170179
X-Proofpoint-GUID: J_Z2YJp6fjPsec9VRTBOF6UhSu8Ibu15
X-Proofpoint-ORIG-GUID: J_Z2YJp6fjPsec9VRTBOF6UhSu8Ibu15

Hello,

This series contains backports for 6.6 from the 6.9 release. This patchset
has gone through xfs testing and review.

Andrey Albershteyn (1):
  xfs: allow cross-linking special files without project quota

Darrick J. Wong (2):
  xfs: fix imprecise logic in xchk_btree_check_block_owner
  xfs: fix scrub stats file permissions

Dave Chinner (4):
  xfs: fix SEEK_HOLE/DATA for regions with active COW extents
  xfs: shrink failure needs to hold AGI buffer
  xfs: allow sunit mount option to repair bad primary sb stripe values
  xfs: don't use current->journal_info

Long Li (1):
  xfs: ensure submit buffers on LSN boundaries in error handlers

 fs/xfs/libxfs/xfs_ag.c   | 11 ++++++++++-
 fs/xfs/libxfs/xfs_sb.c   | 40 +++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_sb.h   |  5 +++--
 fs/xfs/scrub/btree.c     |  7 ++++++-
 fs/xfs/scrub/common.c    |  4 +---
 fs/xfs/scrub/stats.c     |  4 ++--
 fs/xfs/xfs_aops.c        |  7 -------
 fs/xfs/xfs_icache.c      |  8 +++++---
 fs/xfs/xfs_inode.c       | 15 +++++++++++++--
 fs/xfs/xfs_iomap.c       |  4 ++--
 fs/xfs/xfs_log_recover.c | 23 ++++++++++++++++++++---
 fs/xfs/xfs_trans.h       |  9 +--------
 12 files changed, 94 insertions(+), 43 deletions(-)

-- 
2.39.3

