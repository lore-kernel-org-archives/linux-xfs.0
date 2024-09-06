Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628191D79A4
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657129; cv=fail; b=ViAp//aHDLbAoRnolZW7qZkF8f3ORbuZtxzco1tdX+mfBK5tzSIvKOSx0V1G5wTysdVHwhmUBN42aHGbVuL32jijztgSxgFV3Lsycr/4akWeMcYv0oDVAz6+zW0s0xm6SOKIfOBP5o0f4E6MVNzYuHThrtN7SDTAac6vYyY/dIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657129; c=relaxed/simple;
	bh=eRXTCtBtXvCBu7/qEje6FZr53o/zmKldRfeSYgKKdXU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SAw3l663CgKrdHenjVL9LjKru6tn/5sgmjUsSQtdSbGgOaQJYp5sc6dm0/4wocUiSDbGJPnhbGXkKJSUHIV+pHAgL4d4sh2lOMeg/qOwiHsMqzDwzXUgtNH3HidgMmg+OZ478Aar3O/M0EMsllHjGgq95K2LfqbJRcL4AAwFmEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WVY8KK4D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nUGTVh4v; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WVY8KK4D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nUGTVh4v"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXW3e027379
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=VDjT6l2To5Jm1qeP0e93E9Xc28A8PMY+mIabC0PgSBc=; b=
	WVY8KK4D7K9ldpW53Q9YgQrc/G29UV0CNLFsKILttV9oXnutzFt9+hSV8xWgTmm0
	4T229jhMnEYcBoeQ7zIBzYKlCdzrppXuYxECmecFOYrqTg8Q9u5GLtyXZVJ8J9Le
	Ou9O/6eb1daOL8UiCY0S6IS8dZAabb4tdvGq4ziicg8R+FxcM6NwrQnqjmkDKyyc
	mA+QUkKjVTaXJfPXgdnX5tHhi+z7ECZZUPIqZuuSCv3gOXuWN+7r02yWmTvIaZUJ
	nR5GwNR6eRLXMBT6duaVX0ueNXgKDn59FMTN7Qee4BLyWnvcMnmVwyXfYRzdupQ3
	1aFQQF/5vl8a81ZoRBWJNg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwqjhca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486JZTM9006782
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:06 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhydej4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfdyQ/FuDrT0N7/e3zCDcMBk29P0WI+XRemzIzk2ckZ3JCqcCpyNnz9UBC9cgOZ/t+bCekSO0j/jzZRkEwQEZxqTN8rSAr2wpwsil71tyU42o2VRGyEVvqXBHIuMQNclXM5NALAD/AM9l/V0zwQzXs8paoaUUkr4NNIFgBOoG/Xi4VHeYykyh/MK2UCvTyDRB/TwwuwjEU5G/LEQbEMg46EGKqxXqFvWk7Hemt2tjWKBPMJqMJTPpCm/JOVnH7Z8M7VtlRZAKYkrR7pcLidrEaeHhsIc39/8imLXqcBeZqtm1dnBSqi4ZGp4ZBwcXs/tDAM3sr0qX+pNGxhhkj1cTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDjT6l2To5Jm1qeP0e93E9Xc28A8PMY+mIabC0PgSBc=;
 b=dvV3ls7VDJ6ssxbD1CLgxAi7tKiMHQEbkwekUFWqi87h8cPlPDPvUXNBDhrta7Ihc7oZdg40lJM+3hkklKYL5Xs7txwZvpE4lhId48ag0uFGKeQSnUzJ6Ja/2PlVc9ne49aS5Yh+KkYay2E01WlF7UqZrxe4czZIdNXyeHUlr6Cfsm7/KpUu/elWQThP+zCWrv+jsUr8EzGIl2bLFT6rQUbUNkpjMKRXurEPHNSY4OXOS6qqyu4GVFElfOjNxw58ykDioKujqsqAuIKhLzoKy4qPGSYxjp5MwL/oUcBpY+kpF5h9y6d1IBu0zA5tPVaaX2ySMaSV7KWGkwFWx6UYNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDjT6l2To5Jm1qeP0e93E9Xc28A8PMY+mIabC0PgSBc=;
 b=nUGTVh4vDV2INMq8qVDEYth0+AjlqIjia9AZo71I4EbYQsGJkZOuSEc5qfU2ObsZssiuKhru3yB0u9XvRNnHi+0Lc7JM9uDZCF63uFhAx7f1iOt8cf1pzjFn1xaG09BFpWa1G418pV1E/+hsp5A5OSmuWmJuwRQwgXOxzDNA2mU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:03 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:03 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 11/22] xfs: revert commit 44af6c7e59b12
Date: Fri,  6 Sep 2024 14:11:25 -0700
Message-Id: <20240906211136.70391-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::8) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 64fc27d4-2413-471a-c8b9-08dcceb88e34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q2eyA4cdQFn8J/S4oFEpQTyC71VG2wX3tmoH64Z3hPdnMdiEZdEu6ofSq4fq?=
 =?us-ascii?Q?87ahyarNzr4otE0ObFQU7U/ylD2Ro5jCTGI+N/AcdHS1QjUOV4PpQxFnt94k?=
 =?us-ascii?Q?iNBXXYf471TRkhTjr0rhVtT11kn6Uqxg+6ul0z4fNzZM0oGBTpOvtUVO7vRw?=
 =?us-ascii?Q?mDVeDksFDHCJt2Wpv8sKF1rEWeYWCxQu/vHR7/PjYYQmwTCeO1aUd8C8iJh9?=
 =?us-ascii?Q?N4rB+toqsZW+i+Puo3FuImbuNSx67XS1rQDsty7VrHCjCYyGG4+/g1iGKvS7?=
 =?us-ascii?Q?5hkZsHSiB2mxSpTgfmoG4rVBi3TVRS8CUCF5wZXEiFB1aiOrIezvdt9oCGMP?=
 =?us-ascii?Q?MOsA6mtdDKdUjZeNgoyJ24ZmLTz0NWjv6dUuOLIlxj+Xe1GAS+7A1XqGPVOj?=
 =?us-ascii?Q?8Z0gNcv5SYIJzJ/kcJp67bTCinpBov2O0Kkn1gqr8oBqUgZqLav6jDwB4Hgx?=
 =?us-ascii?Q?EpVRavuX2d2hDdKvpqP3njC0wh0945AAlohSdzcW1eVEos9y5w8cgspsJAqP?=
 =?us-ascii?Q?Ac9cqvYgpLE7t/Ete7I1R38PmjZvyqcWsdIASCtGCl7CKnkyaOiiiQ8ebbLy?=
 =?us-ascii?Q?y4Crkqxg7dUf15LhOZfQaPw2muzsmiRurZZiX4UZTMHWw2V94LkCOcN6RVQM?=
 =?us-ascii?Q?srFo2+/Z2Wk/fA2WMbIi2yzxtl3HYhxpwftZyIdjKdphG709Ws2prrgulYdQ?=
 =?us-ascii?Q?OPLNgk4m64EiN50/Av0XqozxWBdaVc7St8/cUg5c3g8Is7x/354aREEHrZnv?=
 =?us-ascii?Q?ZSxzjL0Xctxescr3lz0Fe/CU2InZ8Qd4kjHD8jBdChV0f7mc59dctvLrhKFD?=
 =?us-ascii?Q?Hb2apm6uj27CE8ruEbGGaY/l35F/JtVIuk+BzgLx0aVsTb5mUFvO9glCsJvV?=
 =?us-ascii?Q?faYBXiT4oCj4am4z3EF4Tg++mvF38OxKTJruO5COIGgPC0fXgNRvIpINzUOe?=
 =?us-ascii?Q?7OcP33LcjTkGCQGmxYMrcva6dmSPTGBKabAFCezNBrBAOWXuWoiOJ2yhSPjj?=
 =?us-ascii?Q?8nqKqop3+vjHxYtOwzID3FXzDquCGDCpqeZe92rkG/fbnPJs7w2NrGCzXKmP?=
 =?us-ascii?Q?siwyZ0fBlJGIngUfGXDB/V5oAkZ7tc3JMo3K/COhllYHkM5T+ZACEPyIn6dj?=
 =?us-ascii?Q?6GtXrqiqvI3yPGoZ/zmwWruBs8cET/ejfXJ0HD6SeRIwNqakL3xhh/uG7p0V?=
 =?us-ascii?Q?fYL8AU+RpU+pGBhfBINIrAdtltEWkH4LsEfxeTZv/yhuuo2RLBY9oMb8PKP/?=
 =?us-ascii?Q?FfAbuA95X+scLlZf+rUgfn22hL3G7SHD+ry0T4Ge5fJykwYs0p6362IRoV5r?=
 =?us-ascii?Q?cYTeyDYzybI0Kr2sBI6c6YtBmGlVAvK9Ys78hL4r2olXrg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ffqXUEnzdWhkeCIXA6j+OV/0yBwChLdw8oQ3Pu8immHaLge5SkIirN+iS71L?=
 =?us-ascii?Q?IZ+KvyPv0AZ9gRIi+Gamjf+UDBWwIIhltbOVy4CzLwZjPhXe/SejXeLIDAxm?=
 =?us-ascii?Q?UpNNqw+ZgfIWG+lRctrkFY7jbqJiwPd9xMprWrojEiMFAh1GLjqnqGy8vnzk?=
 =?us-ascii?Q?dPERUjSVNDdzIlalpLNXcvcbZNP6ow8WKZxA6gFNRyw+auObYFRAu5ZwGbrG?=
 =?us-ascii?Q?j9r8njeoXYSmcmUD96ODBBC+Bjrfo8r3qMtCLj0wJLfZQmWsF5mnG5TsPP0+?=
 =?us-ascii?Q?GG98mBRsi84omMhXJfdlWX4Qs8O3UkfcgCJIpbqKayJQX7FBCkEgke2ERgF1?=
 =?us-ascii?Q?zA3LYLG0bxiOXVvNcfisb3OThc76Rfbq3aT/gOESzJ6PaulKzWL9Nsglw2df?=
 =?us-ascii?Q?ZFiKwd5QBDPWXPW0IG2KZu7+QDtWoEniL+Q76liZOvkl9dkXnZ0K3I0GDalQ?=
 =?us-ascii?Q?t/B5BI9DAKX3DWtC+v+VzWJJXOHeLHJmbNgE/sF/8DoBsAmUlipK9V9oIdZS?=
 =?us-ascii?Q?sKRX5N1ovam73h7ekH5AnebbeflD2mNf7Nn2YGFqpOuUlmRbIIcqWKueBKIW?=
 =?us-ascii?Q?J+TntSt48yhe+zoXKot2yFxgfs4JhM3JdlVkW+u4o6nxnT3jl1DvMTBVfHPF?=
 =?us-ascii?Q?S6ZGprG/sjPV5ZOaQMgLH/GZlpi8JEX+d4u83mdiF84Uxjq5wQb2sWfSxPLw?=
 =?us-ascii?Q?LlDDDxoBUWGiqeLAb2FnJb3fbitwn1N56KK45cC3kwq0ZG+hTq2RMKTJxDzj?=
 =?us-ascii?Q?w8fqdWtuFI1gi5/u3tRNld2GmNalXLp5hkZRMufRwyOST9S2/stJpc2It6xc?=
 =?us-ascii?Q?7d6+v2YfPSeZa3YF/mmKog8VFABHEHIQ9zgODrmTP7HIOicLi/7HLJVXyOQp?=
 =?us-ascii?Q?LlEyD80y6BE4Ii8UpgcOOqNGF2EvLi6GDh18ImdyAJtsosIdzyBXzS1AxZq0?=
 =?us-ascii?Q?pJpQSq6ofP9jGlC6jwDJzaYW3E2u0+fDdMH5mC/VT+BXyqnzdduU4nF1yAo9?=
 =?us-ascii?Q?IlLlgaqz52Z6jDJImdx6jP9t+M5EssQNjJIwJ+Pq2YdOKZqicwz4BznW8PvS?=
 =?us-ascii?Q?FrEFxDfpTQmKG0VorYIYBKy3hDwp9yRfJOIz/tUS3qlURolm2yARZUemSOPQ?=
 =?us-ascii?Q?KADe5vigePzlbdYwqG/NcUcOw2JxMvbLNd3FKr66DkT3PlaerNnv1vRgsvCP?=
 =?us-ascii?Q?C5h9x0dQdhUakfJUN+1H6A60jZcjtomtL1VNzMLdoZYzwvTqzI5/KNZUNhFk?=
 =?us-ascii?Q?HPVjFuhHgJVxmk47ERiMIK63O+KaKdbv0t59atxkbEHVaNSxp2b6iijlLjKE?=
 =?us-ascii?Q?9VeDZNEdune/kXP52APCOrcSZEriJGh4Del8fqSQellkuGLOA7FZ3qVgLcIe?=
 =?us-ascii?Q?fQd559XrwNpVLKiNvY4X7rQROr8Ol3t+w2boV5IHwV9Bl/GN3e0SEbymU3JS?=
 =?us-ascii?Q?nDXQZl/T2SBkphgr6ajRrD9K/9YM0SZNWbN7zjeXozGrS+6NQXZfsOwBkuEp?=
 =?us-ascii?Q?u8jqp4lEpjeN/606acI75PNWhzr6YS7v9DW2rPb8l9oTKDxQKCUsi960ad0c?=
 =?us-ascii?Q?Qkp8H6AxlW1ABEj5ADejCfph/5ed+dFGdMGRM83KQMbdjbGUUb7Itj0qnm+B?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LPP527OociU8IEFc2tpQA1Ez5V5Gi2z8oYuGHrRSev8ELMGpnw5vFrsyXDm3hVgrOH0jNBSvbGYbeN2vyibud+ng0fMJdXbRZCBYo966Aw7kyK8ZQHsjnJuR3v5GVOIoJdwSW0SexYgprY1QjiG3BHWf2AucjU1gyRa3ipHADCMfskUGI9edVzlMgu8/1+dnOxh35SnzzQpYF3t0ew5tqNTK289iIMZd0zcu2f9V6AfQrvO8UX95vAkZl7HfmZ6p06VTdA5DUFBH0jylQn8YlLk0L1eDLCA4Ya3FSMMzQRnLNL1VNcAT/qTd9N9p6PhWcfVTen5E96TM94n21/bBkF93eGGd2bpnBiyTJblOlauIbpbFYAJ16/vauo2IaEhlAul1OU2D1o2eKlZVriJOOQN6lP6fIME5Q6WliBQ0K2jbcd97ki2Qqw/Pf1lgJdUrlMbNBaqdBlTl7JYut2HqVK7fAaPjX+Qxc9RW7jrYnyx2bnEzr5oCFWCeasED9qow/at14kuJfGbcAh0xV1ztt1SNLnh1hkKLyKhJ/8EXvzHleDA2WZuMaUZiK2E1ZE/vyxVuijwv4h3SDkpolJQNvzIS+6Dnf6UVLvl7S410Plc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64fc27d4-2413-471a-c8b9-08dcceb88e34
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:03.6400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7w9H/v5Ap3GXDFdgsQPaiANjBk7yAI47xTUQfJQoRh1V5tuOV1pUBjyq60aZavvu8x09DMuob2MeswGRyIB1xFiDC1P5VOqMUY5INfF3TYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-ORIG-GUID: mGna0PuOkSC4GzFB3Xi_qmvng2mi5Oca
X-Proofpoint-GUID: mGna0PuOkSC4GzFB3Xi_qmvng2mi5Oca

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2a009397eb5ae178670cbd7101e9635cf6412b35 upstream.

[backport: resolve conflicts due to new xattr walk helper]

In my haste to fix what I thought was a performance problem in the attr
scrub code, I neglected to notice that the xfs_attr_get_ilocked also had
the effect of checking that attributes can actually be looked up through
the attr dabtree.  Fix this.

Fixes: 44af6c7e59b12 ("xfs: don't load local xattr values during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/attr.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 7cb0af5e34b1..147babe738d2 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -199,14 +199,6 @@ xchk_xattr_listent(
 		goto fail_xref;
 	}
 
-	/*
-	 * Local xattr values are stored in the attr leaf block, so we don't
-	 * need to retrieve the value from a remote block to detect corruption
-	 * problems.
-	 */
-	if (flags & XFS_ATTR_LOCAL)
-		goto fail_xref;
-
 	/*
 	 * Try to allocate enough memory to extrat the attr value.  If that
 	 * doesn't work, we overload the seen_enough variable to convey
@@ -222,6 +214,11 @@ xchk_xattr_listent(
 
 	args.value = ab->value;
 
+	/*
+	 * Get the attr value to ensure that lookup can find this attribute
+	 * through the dabtree indexing and that remote value retrieval also
+	 * works correctly.
+	 */
 	error = xfs_attr_get_ilocked(&args);
 	/* ENODATA means the hash lookup failed and the attr is bad */
 	if (error == -ENODATA)
-- 
2.39.3

