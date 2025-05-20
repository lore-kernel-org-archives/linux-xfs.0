Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611F9254AE7;
	Tue, 20 May 2025 01:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747704860; cv=fail; b=Xq6KFWGkgp4sxlnjbGMSjn/l+Yqqcvrg6LZSAuMsatKW0L5qmqID8mw+67Cr2MMICDshsLqC0EcmVwR94wCsMSZZqxratANg4kiW4CetcdIVVfeDh97AUI7hPE3xof4DTS74cXSpxsWPDxY1UwlpnjbpSA7nVUcWZ9W9WW1at5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747704860; c=relaxed/simple;
	bh=LFC6XARIHeGrHgrybal+EGCEQ8ebZrMzX8ZY2tNnUow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TVADMOAn/P5qNH53jvYh5kqbXq+ragnzk120Veio0eUls74SdFlVr8vtgYtGYXD8WUki5/6CTg3tGxdEZqFxYXBZDRQQlhAkf8E95Nh8khDVJY2DCukvuQxPthX2vWaPU5mjoQT/BM9n1iuVkE3bHQIMruA4ynorr2eJg9OgPHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SLeIB+RX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fnvYMhen; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SLeIB+RX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fnvYMhen"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K1NVZ9030677;
	Tue, 20 May 2025 01:34:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZQ1U513qcVeAorZoYysXxfnPgUR90eFAmGf70tMW6rU=; b=
	SLeIB+RXkT9mEZSeJkKwY1tdqnzMVqJQX422Z0A7HVkdDgfaufCZdfHLmVToWOa6
	ZWJzMoVNNeWkOKIVHgQUG1/LCwrBDH5YNfnzK9cx7nV1i92kpHP6AyzfZA+vhVBK
	JjzggQYr99Ib4xJVC1uwtsQ2T9uK52FJjVb3PDNC/qBavEu4FIKwV8NlyNWSUA9q
	wRXPWetkzalODjC1SSaNAYXA2jek7Xd9H5ubyfHpRabjh03u/IVBu9nBc6Emh7+A
	WRonTO6oEKEZsZMsQy5n1KjBwUZHExN+D3UKm4SXI3vRdXaRTQaXTasH4oichZ0P
	GugTr9URWS4zhwoaS9qg/g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46pjge4b6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JNloAd037258;
	Tue, 20 May 2025 01:34:11 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17010022.outbound.protection.outlook.com [40.93.12.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw84met-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dv4rcmWfX6SgO1KqozE/QKo5wnDwhx2qcFTLCwgwNUTOe7o8OtXcy/4mn9cXmN7v4x/+2xlqcmFg9vOXmGs93IiT6aZzSwRQfXUVC5mGdiMZRyHiUAQdPJE7NdRic1G4fwBI0tD0F0AuOWdb32FOYzx9tq3fXNh5owsd2EjfAlHt91TMcsvqmGBYMW+wabCadIO7Hyw+7cic0MmOzXBaY1A2BEW+BB9XLOZtAZ1lWvUB458RMoyE6yJ4MEM+rA93EnOJAB5A1SEpFa9L+4/ybEGRIXUa6xYlsBBJp3YXtek9H164QqyJCVvn89/aYq2Fk2YnaN8pipFM2vlMOl4krw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQ1U513qcVeAorZoYysXxfnPgUR90eFAmGf70tMW6rU=;
 b=Dce9S6or4mVNskvlq246jExX7c2YTSdiWgDki58RoDebqhrekArMTraH47XPFD5HolNos8vRVjIWOjqm1kYQnzoJaYeCPpfiKLiYUffV58BynFWi9tof8zxZnubPbCym3qe8YUfJ9VHpwDgLLsPPqj+uBJDZxbQVq0CzmSmTrAArFisj2mWVz7z9hRsYAw+oYUJMLw0ePwnF2EzUcrWYJ11j0KYG/FeH104JUFtuNmvWOBdmMNSk7jcA3HG3DjE9gurokvHlc2kp0GYsS9I7UdER34eQQaoLRmOt0ad8Zc+URx9K+LmrThejzRLhFJdRKqpQeVwGwiODuNQNXlYlUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQ1U513qcVeAorZoYysXxfnPgUR90eFAmGf70tMW6rU=;
 b=fnvYMhenqGxehLaLTlXXELAEI/yqkJ2CFakTWt3KgGcdxw08scD63DY8338+Ue0OSQnXC8G6g/5g8GN6cQDnqolYr8QDtM1vmnGek3MNgBiZboWx8fTedGd4glTje4hOtZF2nancOI8GnrpnbTtBRC2bwpG4EXAeUaPzEVBqxcc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB6639.namprd10.prod.outlook.com (2603:10b6:806:2b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Tue, 20 May
 2025 01:34:10 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 01:34:10 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: [PATCH v2 3/6] generic/765: move common atomic write code to a library file
Date: Mon, 19 May 2025 18:33:57 -0700
Message-Id: <20250520013400.36830-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250520013400.36830-1-catherine.hoang@oracle.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P222CA0014.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:33a::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: 4af21fbd-82c6-4027-d267-08dd973e6a37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pXPlXTrZlSxl6hFWN+N6R0jHq5OCBvYqlZnyqCnIX33FbvWGUdzUr2iC8gxU?=
 =?us-ascii?Q?ZD1+7tfACvOF7+v1TCjQ6jamO+eSlhkxLowxPc+0QayvO7rBsDaFNqHqDz21?=
 =?us-ascii?Q?DlsL7TgkjsfWFufBwba+lZlOULT+JjN8PsTrV5+Iqud0kgy7RM06zmN+lDe5?=
 =?us-ascii?Q?42G7RYeVvlnEAfTF1jrYDZdGo/pp0kMcjk7ZRymRuTjaP8Kf4s+PfohCL88p?=
 =?us-ascii?Q?C1bF3KkZPOjSpfxsxuM9K34AmJ57Nmyu4fjhiXkoo197W3HYDk9N2EdBUwRN?=
 =?us-ascii?Q?1AbeHa5UQOWsGSD369TiBDG2tBPFBpsX6xG5cBN+gIvUtUnwXNrnCHo/Py33?=
 =?us-ascii?Q?LGnDmzpwOD2eQm+W88WZ4Dz9gjALwAOfq0MnzUfEJPIsHSrlN3UL6G84Nl5N?=
 =?us-ascii?Q?kvm4zTyxSE4H5+ehItulWFNo5WF2cyVUP1mZA8aKL3ByRg7kOpI1YCTF2MAE?=
 =?us-ascii?Q?siHy84+5rOHVfej6N40XC3bl1zi0baBujkaw0VNOY2qs5BqXZz8optn0pqxO?=
 =?us-ascii?Q?XyWLephU71c8mefjkcPIXDN1ho2HOtdlKM4hqhknZSN6L8autAbtDvHTR35d?=
 =?us-ascii?Q?1FXvkktZPmsQVZtoZauzHBtSQgjdjiS0YQT2Z1wE10TyMQ0e6v2Nj1QrN9Jr?=
 =?us-ascii?Q?mORVGe5BE+DS7mllTLpe2zPhb/iKjOl1Lolk0lKR55K5va3ZeLahDywk7Rbn?=
 =?us-ascii?Q?EwnF+TilogbsOosoNz/0mz1Thr2FNfNqWVMtAElApX/MJ8STeESRn7lYnUxU?=
 =?us-ascii?Q?lR1hv+0lrs8kza2xd3OHDxQ824yx5awBgqV7+qLyuAisEmX2f9pG9SKa6uvl?=
 =?us-ascii?Q?sxCKwdtuw2BCtDhBiZdBym20+fJIVAgLJuW8rOBGn4r4yj8WD9btfip0Kxnp?=
 =?us-ascii?Q?gH4AFEkwYlAxDf3gpovR75dmiP2V8oYQTg46prCTbPh7dEmxm1jf2bqjtgyn?=
 =?us-ascii?Q?G8e5zJ3eacZmDGc/rZtlQQnzbzqpolPATegYCdhVmmhmWnccho+O2Ac4YcGE?=
 =?us-ascii?Q?kIjaaFHUVrWKnC7BQu2e4iSGwGdKQQ0NMi7CP84wPBz0johXixhG2ofuSUib?=
 =?us-ascii?Q?k5mO/wbE26LKwFTPoUsLyeLYf6VOERv3A6kbbquMNx6VWCdb4acZMq8LZyAI?=
 =?us-ascii?Q?qY1VJ4SaKlZrwfSC+diAuoTGNYfqWjnNk4juerSnPic8ntciIRtTGX9hefbP?=
 =?us-ascii?Q?O4lXjz3v4bti+HxcYgidKZ2afhbMpVpZ+gk0V9x9aS6+v20o6emKR7AiKSLK?=
 =?us-ascii?Q?PoGNtLt5JN0M+UKdFGaK1g+QmXNzuLuwm9bY2JGvk7T0tn7ewvomEg21n+Gy?=
 =?us-ascii?Q?FjaQQsRFpY+GhdIj4NhKs5mzezExnZ6MStDEluidRCMAC+4OPNr1enVE1jqs?=
 =?us-ascii?Q?cToHaA6cYJ0Ij4OP9oqd+eOVTk4m813PdLNk8S1lX7MoZknjrnW2GmXluK9k?=
 =?us-ascii?Q?XLXsv/48bOE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pmCx8Z98pjBIbFLfRRMk/l/oT2GAXuQdjLfN92tT0kIPM1jHW/3SaVgqP9YT?=
 =?us-ascii?Q?Ssml6aNb1hkCr8EfO42nnvcylg8Ulz61wKZDW9Qr7zulUMdBXgZhhwB8pvg5?=
 =?us-ascii?Q?8JetuYoZS8VRl/izrU+37eLDSljR6Rx3Gel1DgaI0LSa/2pXx2PxZA9kLv88?=
 =?us-ascii?Q?XYjFfdeeJsml7KoaKzW8GLNKd3D26h5UWsl5sDpaiT1scq/gQiQXR1pW3eu7?=
 =?us-ascii?Q?SNz4VjDZGUQTo2SjZeVY0rJ/FNv+Q2ZYgLn2xH3V/2loOxwrTUvC5ShVWLEW?=
 =?us-ascii?Q?TL8LQBMvaOq9COKy4V9vn7LD6/hWH1384DHz10FAIkF37XdkBDNp++ycu2n1?=
 =?us-ascii?Q?1EtogbQ3wKn7t+B5SunIBR+8Vd0ys+bn2K2kxEOaPcMnZECkzmydI3urj/+0?=
 =?us-ascii?Q?pP7jWoIxxDWI+ZLwEW35OAQVVgDdKOcIhs394WwLhpR/7ZNFbQewXkBIEzKU?=
 =?us-ascii?Q?l15rnvvXxuRqD6PzBmvjHOc2OEh5tjnrmfmVSCw8ol4T/bJd+uA+vQ34sU+s?=
 =?us-ascii?Q?sK/cq1NECpbTrkJ+zvNJJqbkF6twW4vszG6h80oPNyR2BFnx5GBzQI9Ilijf?=
 =?us-ascii?Q?K898RKg/Q3engFqw/5TnKDXJYtJ/oZ6xxoL6r2IQiRIX8AnXwi6Zv/db6Ody?=
 =?us-ascii?Q?xzonIqy5KuLYmNi+M1SNoHzyVcqFXwordqp7zg8IOHvt9nuMVfZRHcQcgyRV?=
 =?us-ascii?Q?Fs61nQqjzpsB6pTsa7aMBaWqyX1tEZLR6PU521XSXiT0/ku4Keb9oeS3QuFo?=
 =?us-ascii?Q?spA9mNE0OK+//GqzBoK68toeXJWME3X7IxWV9EuXlYGsgkCzWePp27tNnOmE?=
 =?us-ascii?Q?9DmdT6hh6mGedQcDNoSAWnbPEvI/CNii5GnGR5O3it94KIMB2Vf3131xoMNO?=
 =?us-ascii?Q?+vgPA3UPAzqp4QAhzOjNZwF6w9TxTBExt0qOP97NreIn50zA6Ldr0mlzVfbm?=
 =?us-ascii?Q?CdXS3l/Ywg5QOfXDRI8J6Rxsrg+Byqb29zebwuUlS+9vLcUffL7lRpFCzdby?=
 =?us-ascii?Q?mYflw4cQpu0Z52MO/T0D+tjTKGmFNuGw5a/wXgq438zyGrIe/sTedlcuNoPh?=
 =?us-ascii?Q?BpmjDKs3i2iGAoAp2bST9ysRDO06fsUJ+VgpcAPx4EgHu1RSaIDVU/qLmFwL?=
 =?us-ascii?Q?MEBYJag4/TCuHO1DGjLtZaVlGOF4XUfFxZTB637M9JTNYUlCoXSvpp+tS3Wg?=
 =?us-ascii?Q?UdhSDJupGe4JmufjrbnRuaVavH2IB9gq5rIFWOAuhcXbMnlUE9nRTMmcby/T?=
 =?us-ascii?Q?5Ae266Y/V2yW1GXmWnI5Svn3QPW8dmvh9yjLPVvm8zCoLfkkJw7lQPqStWls?=
 =?us-ascii?Q?x8tCwwUwpVSBqT0uOF61H+MEi4me9aCSwEKVCpci3NtApMIeQKzXICPKZCW0?=
 =?us-ascii?Q?wP+Bb0ctX+J8lHKGdfddAxXk6UPG7b3LuSd/3G1t/EZWzoPV9Bs0I9TDGzaC?=
 =?us-ascii?Q?lunlGQ2d6I6YDmXj4uOOTzTH4lq9EWplf9Om4iUcKZJBQ3LtZmsu3QcQo6cm?=
 =?us-ascii?Q?29vVRQrHGSENjNqYjbpbsBY7QpFsZwFDL9XIKu/4zZflQMCDZ8zkIg6Ho9i+?=
 =?us-ascii?Q?HGDZk/tejQIiNEff5tooISzTzmda3sq1IQDxpKVNEKcPkBSeDSvE8odevic1?=
 =?us-ascii?Q?/LPXnHuYNZrYCK+PjCOJtYW3mxjnTMFws2yaIzT6yjWXURb08DTzb0WmqdJ3?=
 =?us-ascii?Q?vQfuUA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ru7cFT3d3dW+anWw3FVHyR9mYah8tF6GvV6C9r+OhxgfHme9jrYovB3B/hGt4UDxWAAphiLzh4alS8gZe0TVImuY8OjUEEeqI+G4/JrjkMu+so5Kca7xAJOy9mB5e/pUauuiKvwxaxYFAjJYZOdBwd3UrpJZLkCsR2yhRIcSppHzHB7aLJvtCiPgHDO4GgmXiu+hzkOIsHagymdXEWuk9/moV1QTve7SPb4BkPbGhV6qvVDz/lmQ86ZJa0j0yv6CsO8leXA8VGVnRIGY2Qq5gVYlsg8emI3HD0L5ydmRaI91mRaWciM5lyRVkuNeu8UzRdd9Wrekb31v81g1mnvMKjnf95b6r/3drCwAJFxMzotKH1QtRX0OyXFtLGY88He6NdavN/FSKNyEp83kKeU6OlMIAfTaYQDf7R26ONroNWfjUAJt3e3wDXirjFX6mTBCiT64hARkFU/sw4g7RkIlezGfxTVnXS0F/DTyryXBkbb83yFTGlowUEcos+RGgb/t/zMhfk21EcrN0Y7g/9fl9EV3TCrT3bZQy+foytZdSxkqEDcKZf0FwVHGYIsT0zpV4LdBcJzj60yh095HTHFxAicZP3s8B/Rc/QrXeGHgnd0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af21fbd-82c6-4027-d267-08dd973e6a37
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 01:34:08.4582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TFfmDGhAImNCxpU0mNA6wzHWeckfGz126fL6lpjbIfAIL7ckdqDnn8nW16TuLwBRw+oqqqmUD6CWC+PGHH/Z2ErppZFSD9CfvhkNiy6fd70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_01,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505200012
X-Authority-Analysis: v=2.4 cv=RamQC0tv c=1 sm=1 tr=0 ts=682bdc14 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=XlWU-9mzee8Wawx2FPYA:9 cc=ntf awl=host:13186
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDAxMSBTYWx0ZWRfX//nxq/c5VDeL 45P3ay3bc2id8+jtV1fB8OeaypeNSk7eLAfp/lG5JH4ujINIyeZc6CUVio+9qdJxXpBIqiR6ZHh POeY/MNmNIkEsZwUwgjKm+6kuutnwKbG8j5Lqje0k3uLOPesGUFaXVr6SbVn/5TjLMPC7GdXw90
 J0rZhx/cD0bvogd+gUTwxMIaow9aadvvsas1z2OgWrI22rO0d975qmC8432eLz+WfKNPORX5v2Q cfW0q2UlDMoRC5H4LuR2mk3I4h+8gXdAY5Roy7VWKAPYnhyJZJMQWTmOtuM8Xsrmyj/DqDf0mUk kgvJyho7DRlUP4uh/hrloVni1Zwbt9rl0VREeqLyUqxeAYLl7cnpV8TmUhdtFdfkV2aM+VuqGWu
 74PlDh9Qpj6wdk+jM9DkzlExiQ4YazA5qEIEfAEHcVB7aLhg1iJDN0wArMXuq21TakSMi6zp
X-Proofpoint-ORIG-GUID: 8yL5elmf-r_UJiUf64BlciIf-pmAkngT
X-Proofpoint-GUID: 8yL5elmf-r_UJiUf64BlciIf-pmAkngT

From: "Darrick J. Wong" <djwong@kernel.org>

Move the common atomic writes code to common/atomic so we can share
them.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 common/atomicwrites | 111 ++++++++++++++++++++++++++++++++++++++++++++
 common/rc           |  47 -------------------
 tests/generic/765   |  53 ++-------------------
 3 files changed, 114 insertions(+), 97 deletions(-)
 create mode 100644 common/atomicwrites

diff --git a/common/atomicwrites b/common/atomicwrites
new file mode 100644
index 00000000..fd3a9b71
--- /dev/null
+++ b/common/atomicwrites
@@ -0,0 +1,111 @@
+##/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# Routines for testing atomic writes.
+
+_get_atomic_write_unit_min()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_unit_min | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_unit_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_segments_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
+}
+
+_require_scratch_write_atomic()
+{
+	_require_scratch
+
+	export STATX_WRITE_ATOMIC=0x10000
+
+	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+
+	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
+		_notrun "write atomic not supported by this block device"
+	fi
+
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+
+	testfile=$SCRATCH_MNT/testfile
+	touch $testfile
+
+	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
+	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+
+	_scratch_unmount
+
+	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
+		_notrun "write atomic not supported by this filesystem"
+	fi
+}
+
+_test_atomic_file_writes()
+{
+    local bsize="$1"
+    local testfile="$2"
+    local bytes_written
+    local testfile_cp="$testfile.copy"
+
+    # Check that we can perform an atomic write of len = FS block size
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
+
+    # Check that we can perform an atomic single-block cow write
+    if [ "$FSTYP" == "xfs" ]; then
+        testfile_cp=$SCRATCH_MNT/testfile_copy
+        if _xfs_has_feature $SCRATCH_MNT reflink; then
+            cp --reflink $testfile $testfile_cp
+        fi
+        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
+            grep wrote | awk -F'[/ ]' '{print $2}')
+        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
+    fi
+
+    # Check that we can perform an atomic write on an unwritten block
+    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
+
+    # Check that we can perform an atomic write on a sparse hole
+    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
+
+    # Check that we can perform an atomic write on a fully mapped block
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
+
+    # Reject atomic write if len is out of bounds
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize - 1)) should fail"
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize + 1)) should fail"
+
+    # Reject atomic write when iovecs > 1
+    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write only supports iovec count of 1"
+
+    # Reject atomic write when not using direct I/O
+    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires direct I/O"
+
+    # Reject atomic write when offset % bsize != 0
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires offset to be aligned to bsize"
+}
diff --git a/common/rc b/common/rc
index 261fa72a..e5e53145 100644
--- a/common/rc
+++ b/common/rc
@@ -5433,53 +5433,6 @@ _require_scratch_btime()
 	_scratch_unmount
 }
 
-_get_atomic_write_unit_min()
-{
-	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep atomic_write_unit_min | grep -o '[0-9]\+'
-}
-
-_get_atomic_write_unit_max()
-{
-	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
-}
-
-_get_atomic_write_segments_max()
-{
-	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
-}
-
-_require_scratch_write_atomic()
-{
-	_require_scratch
-
-	export STATX_WRITE_ATOMIC=0x10000
-
-	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
-	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
-
-	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
-		_notrun "write atomic not supported by this block device"
-	fi
-
-	_scratch_mkfs > /dev/null 2>&1
-	_scratch_mount
-
-	testfile=$SCRATCH_MNT/testfile
-	touch $testfile
-
-	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
-	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
-
-	_scratch_unmount
-
-	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
-		_notrun "write atomic not supported by this filesystem"
-	fi
-}
-
 _require_inode_limits()
 {
 	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
diff --git a/tests/generic/765 b/tests/generic/765
index 84381730..09e9fa38 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -9,6 +9,8 @@
 . ./common/preamble
 _begin_fstest auto quick rw atomicwrites
 
+. ./common/atomicwrites
+
 _require_scratch_write_atomic
 _require_xfs_io_command pwrite -A
 
@@ -87,56 +89,7 @@ test_atomic_writes()
     test $file_max_segments -eq 1 || \
         echo "atomic write max segments $file_max_segments, should be 1"
 
-    # Check that we can perform an atomic write of len = FS block size
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
-
-    # Check that we can perform an atomic single-block cow write
-    if [ "$FSTYP" == "xfs" ]; then
-        testfile_cp=$SCRATCH_MNT/testfile_copy
-        if _xfs_has_feature $SCRATCH_MNT reflink; then
-            cp --reflink $testfile $testfile_cp
-        fi
-        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
-            grep wrote | awk -F'[/ ]' '{print $2}')
-        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
-    fi
-
-    # Check that we can perform an atomic write on an unwritten block
-    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
-
-    # Check that we can perform an atomic write on a sparse hole
-    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
-
-    # Check that we can perform an atomic write on a fully mapped block
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
-
-    # Reject atomic write if len is out of bounds
-    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
-        echo "atomic write len=$((bsize - 1)) should fail"
-    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
-        echo "atomic write len=$((bsize + 1)) should fail"
-
-    # Reject atomic write when iovecs > 1
-    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
-        echo "atomic write only supports iovec count of 1"
-
-    # Reject atomic write when not using direct I/O
-    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
-        echo "atomic write requires direct I/O"
-
-    # Reject atomic write when offset % bsize != 0
-    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
-        echo "atomic write requires offset to be aligned to bsize"
+    _test_atomic_file_writes "$bsize" "$testfile"
 
     _scratch_unmount
 }
-- 
2.34.1

