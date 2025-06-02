Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398142C324E;
	Mon,  2 Jun 2025 19:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892148; cv=fail; b=WcRGqc0+cjSQQHdYX1ky6mtZ2fZvTsZzCtOSnkvpxZJMiQrpHwfRjl+PQIIBWvNfuOTdobayC9MT0jnLWmD57ZMYNFx0hyhJLQevhRahyTNoSqPP98z33M2gS8dTK6sVm6FL4ewL4UM/qexGy+T0VwnH6W5XlrzZq4/XK5dnZow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892148; c=relaxed/simple;
	bh=IpXUR56xLsquuBnnrjo5hNZG7SL4TZZ7WPLiEo2SsJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=NUT1S9pCzgvnC6jRb6JOfNV3Ny7HHMqoepPFUSFyGLMorauOkJKh1OTR5U3yDVAwYiQpn2ugKOBipV34GFA6b1kn2HwyefhW2sMgxTAZrTITTtfcb0BDXnf093pP6dmr/olFYGX9CYKxz2i8njHtZXiPy9qAzkmE3aw5UgKakwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nKULF+66; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qd/Ij4Lr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nKULF+66";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qd/Ij4Lr"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552HJP5R018790;
	Mon, 2 Jun 2025 19:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=F2KQGYtCDZ+9WN54
	p4/kIMeWfziRfXYKM8INsSh7rhg=; b=nKULF+66Gufl3Uu48f7CIAkM75P3hPWa
	0h/Tc/Yb3Yem5eLPSSvflAeAj3HG0d/ItRJTg9tCdx9tHdqaY+XdL0DST+Bgbl4Q
	rekbJO1j13W9fyY3Hc6zj2AaryXeVuZ0Y49jr25ykNjTlGACEPlcOk2R8rcKBZix
	ClBJ+rBiJyq+X0oRFq8Hn5NDFt24Gbjoz0LUZcWbIPbcsy6ms4rTW6sQ4F+ddKB0
	7A6wqc1Ek4V5ODILA8lckKyXe0IvdxpQxvQd+6gFmBQT+7NpvKu+4lch6p7drAlE
	DPFSHQtcHk3kntlnuPbmIcGiF9v2rsaKik2r9CEcroatXn8i0ZGrIw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8j07tp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 552Hb5oR034987;
	Mon, 2 Jun 2025 19:22:21 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012011.outbound.protection.outlook.com [40.107.200.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78mn0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4lAlVrAMU1t4/hykgEfFKmWIT+ttzbPb2H7s/CjpioWpcgnQBF0dtjAQOhL3wWEaNJQdg4AEl5MHCx246o4wWKBEMnXfW9ucTCkNjdEKUVpwa2JOXBNbITeiTgHFABsK1U++5N8Vv0pqoxJbfAs/kwTxgHrHbwConwYixLNLR7LTzickqZ9dFFdzjmQqbEmb7rnJru3l6gCurPU/Dc4icD6qQAjW0U0UKmGyxQDYbXimvNz/4g84vgETtqBByyCUliVIq+JXG2lR9UXYJ0l9sVvQXK1npMcKs7E5vGK6dwMZRKaUbtIpegc5O7zPaCPoQirTj4qBjgyIGrVBDljzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2KQGYtCDZ+9WN54p4/kIMeWfziRfXYKM8INsSh7rhg=;
 b=pSjGVwP8x058keymLdCPJPoSmKw5BCtpqJJ7hR7KzG+Bu+2753Xvo73rrxMyRXK+PxEdQStj/OrO5SZ7NGsjbR5v7lpCJOERCCgyEQEve7YfQyrZrPBS5ZbdAvvDR79fJJGNuYMaAbfNCApqOQ/I3snlahMWy2hRrdTn4ED9RmCJjDOV/yvVUvXDj1R/fLpdFyYgFBCHsHiiHrlAsBhhCSWZ+pbepmYqWkXYbXfs9mff0x4IMLIhKp7l2qRLbI9i8RwzRGV/NYiqb2acCFVEFPMN2npGTAt0DC5b5lcwTRz9KA6WQSbL6ftPXRBhH1HeIIjcomUb5SbRkn3d54zqmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2KQGYtCDZ+9WN54p4/kIMeWfziRfXYKM8INsSh7rhg=;
 b=Qd/Ij4LrKEi7BsLps0/ZbAUiLgBO9Vb/i3jIoyg5DyDvZlE6jb76vk+Agnur4iWrV3baXHgwwJHmG9tqlJyCVU7lqmL4JssPg7CqqZR2mBugR1dWcw0o53mKlAN+i5pD3jBJH9SNrQw4/R7YhLisXpUBKajZATIruaVXcd/nA+E=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7158.namprd10.prod.outlook.com (2603:10b6:208:403::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Mon, 2 Jun
 2025 19:22:16 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8792.034; Mon, 2 Jun 2025
 19:22:16 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH 0/5] atomic writes tests (part 1)
Date: Mon,  2 Jun 2025 12:22:09 -0700
Message-Id: <20250602192214.60090-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0025.namprd21.prod.outlook.com
 (2603:10b6:a03:114::35) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7158:EE_
X-MS-Office365-Filtering-Correlation-Id: b2366cb7-9360-44e6-72ed-08dda20ac8dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KuDBYV/S1rZ8YnHINz29/6PiiGl/NOlu2pb9+TaG4iyTlqtGCWxnyI8oXaT6?=
 =?us-ascii?Q?mzgePIMmUHyLR+fBTtXdEEk7C02SZshw6p6lFZO46HkZI4GAsakw6yZFhzJw?=
 =?us-ascii?Q?+oi2jVJwQxOZiK42PRDPu0sEioto+f82VolPw68yPuFvzX5KmbT4CEitwdIh?=
 =?us-ascii?Q?odeTFfZJXeELnhX0fJquk94CSlHcIUC9P0R7l1KpDkDzJ3ihoFrEpEI+HNBQ?=
 =?us-ascii?Q?kcA7RGq89Q801w5k+oI+fJYMo37N3wfcPLcW+jdKS9OBnbiLrvba068DwRRz?=
 =?us-ascii?Q?8OXZ5qrvYLGhf28R0yvR0/7Rmkr4S52Q1FrcRYG1KJ3OVVoTn65p8/Kq6ZqY?=
 =?us-ascii?Q?8ZwDM9uE70BLrZvhjLmtcLrimFTFf/XqIlAdm8Y+5DbApASQ2ylVI7gqVp/i?=
 =?us-ascii?Q?2hBFVEM6hufBu9DNrK2XhQkYjPuuWy9JOST0fvuItlkpfQIebuT5C/wjrUlT?=
 =?us-ascii?Q?B5tb4X/SvyjnUDKD5tC2ak1++ekHu6z3ga0FM2GiT9GIoSJrFclVehLMfbc+?=
 =?us-ascii?Q?EwsMnDHkf5LLnhaqToBrKGaTCDVFD3t8A9vk378m4s3M1elz3E2jGHnqErDx?=
 =?us-ascii?Q?40PaRFDtaB+d5tE8B8/lH+/L1KxYFjmTHx7Lnh9GBcUb/UJWPUvJ8CuA5WOF?=
 =?us-ascii?Q?y69xdtkuW5HlA8lgEnZWFes49xKzOuc0KUEZxadwKYb5wXzyH4/x6ZEY08YX?=
 =?us-ascii?Q?bZAsi2I9AqNrTKckxfidO/oOLvjRtyulXGc86PmOzUwJycynsO5QZocA5NRM?=
 =?us-ascii?Q?A2XY4uA0iHltbYP3efVY0n6wIFneyF5AZH3phgsNyYQ4iMHT4d5R45ChzBGQ?=
 =?us-ascii?Q?8iq9ThTOu5UTxcSoqaUdEb/u/iGHoW1cHxLPX+u4Bccind2m/PStG2L/Xy9t?=
 =?us-ascii?Q?+wwlUy9hEy0RncDvxl7nsO3EHkVrgChYVzgip1H/GyUv7GwoK0lhwjSoUt9F?=
 =?us-ascii?Q?afKqs8xqPdrm/73qWdctnvtyjcO8YsedAip8cpJcJSrhV41iE93B0M4h17Bf?=
 =?us-ascii?Q?lmKdgwwU8DZU9lefOigAcoTaP/AkCaHnk4KAp9fwHlWsNU8PiKpWVN3kD9qW?=
 =?us-ascii?Q?IC+bqbfYFiFWk0gZleqZW6rNAEiYKywjCdRRg3LE+rsP1ORPn9sgSD7xexVM?=
 =?us-ascii?Q?IuUas7PnujR7TNFrxivfLcmYtUDf+NZYCPgqoXe3zyQDFZTolRB26Kztclof?=
 =?us-ascii?Q?408HxCdjVBUf/qTqHwNfYKoGKLBD27W6PsmHBekhPj7o7rw8gwKCL8iqtAH2?=
 =?us-ascii?Q?4n2ZtfS244lzffD49+HgnvEQMnl2va7oh/2jwlZ/MHs+r2UgzLoesmklGb6p?=
 =?us-ascii?Q?Vj1FbFV2EHFMXk2A7QFzoiVG+9EsczbH1COo26XxvAnPInnDX/yupLGMp7iZ?=
 =?us-ascii?Q?ZOYz18VasvlOEPiEt30j1OEefMjUxMc9Al0jxAXbVM3qtogaKfLa0i1Mq5x3?=
 =?us-ascii?Q?ycQfmsiWxHg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3WUond8BT67UAzPFeyUu2BVCYYCp8C8m8aMH0+034aO03s+h4hpi2towGOl9?=
 =?us-ascii?Q?aBQjxZhqvF5Gl8DTlkDAfYD4lXp+Ny5wqLmmmx1MlcjFGeV41dDATa5tF+Qn?=
 =?us-ascii?Q?tCtgVHZ2zsETsfTwwcpSZy/wsy4sprFrsJutOCacFC9w5c0nkGbVHyHAClmr?=
 =?us-ascii?Q?74UalFD+1r0g2wAb5Uq7NpvtWTak7Aj8v+oai0PSIbehEXjgq7w+SNJeFi5d?=
 =?us-ascii?Q?mjqtRZZK7azFz9F4vyAjiqUFbz0YMO7ctRAcV53CgCN6L+H2+xxL3k6UqCnv?=
 =?us-ascii?Q?hrs/Jj+H8gCEV1dF08G13D8o7DRxRNC9B1ZZfgHpQLkvi/tWYvxkqdrJV9zS?=
 =?us-ascii?Q?PeEF5QmuPuHkk0cXT45RRDIQiMtWF0VfqywvKE70wGy9uPNXROqojYRqpzGp?=
 =?us-ascii?Q?o8maoT+bXTBWb2BUc8Hq2gbkQoVFifSDp5omAiZCQg/5IvHZBccT/QSFMcF0?=
 =?us-ascii?Q?5rGTDBgjzbBLCxjCQd+D0zrTESWGS5w4KxlqxWkNjtIq93tsBipV0HBjzsga?=
 =?us-ascii?Q?2uAAVI8o9+zkmXDD8ED873bNoBv0p6JY32Y6t5Q5d62FGPf/VMgBTa2PronD?=
 =?us-ascii?Q?XYeuJmRSmQOBEPG4eOj2T7WBnD9g8m4dxT/who4K1CjvfQqTTWUjFTsIDSlY?=
 =?us-ascii?Q?FlPFDwjCOZr1uXl2PCXTa2fo4E6FjRsguNDpmM65nBv0/9Nhq7ng8rZ5lEw5?=
 =?us-ascii?Q?nKSFU8hLRH3aV7maj7NmTzkh+yGpzjWjhs+1jYMLlJHuzcRxYF451Y125u1M?=
 =?us-ascii?Q?AC8l7Yh6d/EuNNn02FeT5/7UzFQuHLDafnbo1/iT6ittIyVjS0XNnLlfMZHe?=
 =?us-ascii?Q?tdsCFaC1v7eVuYSp9UQripQHoDDW38gRskY3scZip2SIdq0IoJbsf/8MVVb0?=
 =?us-ascii?Q?D3Gw74wGGi6PQ0tgHDD//1/pmzcomh0HlgkcCWoVe3csMM/9DHNKzNsPCw8w?=
 =?us-ascii?Q?yTK/r3dR/8WVcvvyP47RGGASpdR8dUoucCDtPIXCkkr9ZX9W/aVHseV9wcXm?=
 =?us-ascii?Q?hGbNxolC2NP+DFsYXEtNy5RRh0zFkWGB44wjMjTNnraXm/W+BiXh7slwkwS3?=
 =?us-ascii?Q?pKvC185sZI74cu5ZTpp40qlfoVU4Yt/KSsIHDPCOZoIRq+3g+VLGhodcFQja?=
 =?us-ascii?Q?dT2YwkQe8ezBxqhtGKqgxVxE35yILGFTPty7XPHlcNIRtbl27EG3tZoZ/8T9?=
 =?us-ascii?Q?s5eJdby6N7PNHkI5hDFHL0LC9sbeWptCvfxqGHT3l6T5wKFrtB8NF3TxlMur?=
 =?us-ascii?Q?xqC3P17m0PzQeLwqwzqNPVOQgZDQhhHVcsegY7+NDJmZ8BCwy5X+sszqtp94?=
 =?us-ascii?Q?W0kgC8IitvqYH422eL3EWlFwVQQL3fwBg6UQV3P/XoSLdgYQolDnKK8eU5XW?=
 =?us-ascii?Q?sffzmyfn/2rcbHyjqoA76VWzce5L2hLQFdSZn1JgA4JP7Du2npXF1mk72vrz?=
 =?us-ascii?Q?b2Awp/HOjOZeyEqfE91TqwLO+q32p8lGQbaXUpIFcWpqq80geRfEERa3bYtV?=
 =?us-ascii?Q?528q595Bo+5q0EyOJodxb9tYebuEXtmUY8NuMLWqFncNKzRGImDhzeQtbUbD?=
 =?us-ascii?Q?mvxfFRhd5q1rNe62l74ZXtBZd5FirsA4j+vaYVvslPTx/Qodq2FZpDSYnl5B?=
 =?us-ascii?Q?lP0O+FwMQROdPGjk2H0nvPm8/iOvA7uXYea9nwGJfPl3pnFzzitkyYJV8s8d?=
 =?us-ascii?Q?1PnN4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dX6TtlRAsudLXeNYcdHYKzT4RbggO5o/jqRqUcW+BsTR9Kivb3waFwGGORfd4qGdwcaC50I/60V1iAGa7Z6VO6oPuXRFa9nFtk/BlM80ke3orj/r5oWPH4cOuLq9/qOOjN1h3DUgLXZbr1Z2EDCY7StA6c3YRW5mF624+r1W5pcHHYzNV/MpPouV6OtukP6P8Pb/p2kOUEwQEotpjfGyf9M9CVEGHoWhYYa72tBKDfjL0q+QK6dqpL3w+AhNGcdxVmRHMCDIyzfktR2tOPlMlv5Q59rjnswtiyi0fG41Nxda0j33vHR01tVoAvKw1MRs3PQ+Pe2Yy+iJs7niNfrFshV8PTeK6pFsQVokUjm76eOQgU9RcWtD9cxTVWnK5KjV9AgJ1O8eBXT2i7JxJZ7eyg6vXuTxpniXmA1F/Nj+AYbMj0cfisbhrCkTC8Y4hFgtY7tTqeYgwCUY0iXW72rCBB3jMAphBETmACoi6cANOdVmz3eLM10WnMRUGeU0fkuKCkM/xWGYgKV5UUKpGdj0VunS0tOov701uk0D8LzCpqXO0tZEgN1lVFB/nmrCNf3CHD3Btjht3k0KE9P1Zhgt/s/v4o/gB6nmr1y8pavhSzs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2366cb7-9360-44e6-72ed-08dda20ac8dc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 19:22:16.1519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49Kftem3fUaPkhFtrBIWDGtPxO7Rw6Ymjzc83bEJtsQA/NWpfPwl+NScXUTSdkcAP+xarBxfwH6LRMz4NYy1NmidN95/5ln9VSkIJl5J15g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_07,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506020159
X-Proofpoint-GUID: L_ru0IL05Mh4YfO17X_wRnPNO1kDEPEz
X-Proofpoint-ORIG-GUID: L_ru0IL05Mh4YfO17X_wRnPNO1kDEPEz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDE1OSBTYWx0ZWRfX+KMR0ApV+6pU SrMT3eVz+sy4SdYc2z+J/SuJhUqgjZbzVmTEroA86Ok1HoHWyc/BYq0w+BbKgQMFV2mI9BsyYE7 Fjyvrgx7lqKWyrwAz97udiTl6HfzlQX7nNfhS2IsbZU6x0bfVaxhjZ+91O0X3lAD1wodiha8n9J
 51nmHF3UbDzFXKo5vwZsiZ1D55xp1IrgwK3yxGmG+ymdmc4cR95u3xEgjPumvURcs6X3vtJ6c2F 6dANk8aoshkQeU6CX7GDGFa4MJVKPwXub2RoMJkoe+4Hv7ejrFqTno2srmDp5Ztq3T/LlK9LwPb sB1h7TDYD8y+x3oDy9bD+O+6yS10oV+yCxEv0+Kp1V8fSHViIQmhuTVfins9emK/aCuOjTMUYX6
 /G53hCY/L2LUUzd/3aLM3R3iYq7IIMhBEvridniVeCJAivt/P9DMBLd1KKnNFv/ES19dgcoT
X-Authority-Analysis: v=2.4 cv=QI1oRhLL c=1 sm=1 tr=0 ts=683df9ee b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=vjK1j99u1xPvqLNupnUA:9 a=0lgtpPvCYYIA:10

Hi all,

These are the first 5 patches from the previous atomic writes test series.
https://lore.kernel.org/linux-xfs/20250520013400.36830-1-catherine.hoang@oracle.com/
I plan on addressing comments from patch 6 in a separate series since there
were requests to split that up into multiple patches.

No changes were made except for picking up a couple rvb tags.
This series is based on for-next at the time of sending.

Darrick J. Wong (5):
  generic/765: fix a few issues
  generic/765: adjust various things
  generic/765: move common atomic write code to a library file
  common/atomicwrites: adjust a few more things
  common/atomicwrites: fix _require_scratch_write_atomic

 common/atomicwrites | 117 ++++++++++++++++++++++++++++++++++++++++++++
 common/rc           |  49 +------------------
 doc/group-names.txt |   1 +
 tests/generic/765   |  84 ++++++++++++-------------------
 4 files changed, 149 insertions(+), 102 deletions(-)
 create mode 100644 common/atomicwrites

-- 
2.34.1

