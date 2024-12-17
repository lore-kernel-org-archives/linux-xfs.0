Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBCC2595
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 02:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734401318; cv=fail; b=Qj6ahsEE1BzbaDHkIaNT8PSUPeN+ejOEU64Sl6alCHSxNglBfEBWMU/U+hXeHAYrNZsyccgSid1nfONaNL0z5UkrumN6PN1fnnv6RZaq8nW8Fwgw/R5mT0S4J4LINCZRQoUwYkdtNqa3rM5oOZ6bHtLHW4DBjTt8uV0z8PxetCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734401318; c=relaxed/simple;
	bh=2FbsY36kMQ/mxGWuzPSf5aGxDAziNr4mQE7zKIs19g0=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=SLcopRMKati/xX4b5wxCRYfGo1fBS37zqWpYqnVvIErT0NXk4Q22jdd3Xtezn/8lw/MKZyV2+Tjs6wT3KbXublRXTLzgqNqi2xYVRmXLo/I90O/szBMyA4C7yY/L0bH3UpGOuf+VHvpW4vECNmLCGtIL4sADo07yTeOB8KMeDSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hNqPinAO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ilxL50Mz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hNqPinAO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ilxL50Mz"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BH1uTif002084
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 02:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=fJ/FYGD24xm0sIFz
	5Mo+dUb8/B79aqqYo+iO8R2+NjM=; b=hNqPinAOUGUemCBkej8J2wTglkf5Tpyo
	WyoQy12mmBBKCI8cbIZJwqw9N0EFEJpTvH5AU/KGmnPPavCxpjAKYXzETO25Fko+
	uSTdBp+1yHQGMvXWujA7uDC8xRXmPKwzqv48h1t4keNC7c8jvaSQ37RbkEpQwm9I
	gG0QTO6MVX2T9xew0zW0YGcU87NESuy56nmwOI9WtBQ0Yn4RtCh9HUutbEnkvVD2
	zLgSGNv7+Gd+5bP9mMoSneBoXKNeCY27dCo4PtEuDsKTLhC2N7T9RRRzRvcVW7iF
	bAL0NDHpy58/9q1qVE8zF90PvZY//Cjua/Ie1IbEL39kG7NoWZgluA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h1w9cuyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 02:08:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BGNoVpt035486
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 02:08:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f7ukh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 02:08:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oRjXc2896e5A40P0thOFOQ5aao5geAe8Af0O5e91i+CIzbMioQPcBO8acKjSFmgAanGNHS9GuQxVi+BAMyeXYvMQqnpuFILtC3+DoNHENdOujhjv4NDOV+Wv24AKMY5F9EsLuDRx5/9Dk+B1wVt7HEnQpG3b50oJ08lIVuXjCIt4Wmv+2NOjKKyLded5LJ696dEr7uA0T/Iha4MI+PoSkT8EWVcmMPn7xre1CTx8XdJo0x3mDssPgl/ecIQQqCIZrJ39I+ykcO9ciWoXlXDfF2Pf5Y4KFjC+9eejpChuTbbZjX3AqYcmJBFBLLap4/BdIETQzDbFDxIL2ELPDVTiDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJ/FYGD24xm0sIFz5Mo+dUb8/B79aqqYo+iO8R2+NjM=;
 b=SiVAkHlSHl+Uw4Sxn0+yDNqwNLisezvrpU9fFTRqWAOg5xrEA19SPEMIkIZmoyu9/Ot+fbkJHDm4Ygj8PDPrY+hUL3a5mVypLlHzmedfTYCEq7NXeTl+qV+w5zWnYyzT9xtc1XIMMeglB1Z2evk1oSbOD8SHe7B5Srm5tVP3S5W8tzRDLyDAIKPXDRPixASuZ2PldTjo4zzofUAIyP3JTxj7YjvGvqeZbRjVWI0T8TTXoe0FGBYyJfRy03d04+yHhfFsZk9+Wl7P19a8CxtgKznjOUTh53osOllGU7GJrIikAMpY0GVDtoLutxbY5x9hV+PcyozFuUTPAKdTuBbTuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJ/FYGD24xm0sIFz5Mo+dUb8/B79aqqYo+iO8R2+NjM=;
 b=ilxL50MzGyQwOY+002B1yqKG/hbbqdg+4rWf8IboQYwq+eKdUw4Lf5QyvBXz+vn6556Purhr05OdPhmS2WNaWw+ImWxaBQFxBXQPjRr60JnCMIJfQ+SLT8vCtSN3P/1D7qfcDB7wxIqVVeUiBFqRRFVhlJmb1Rix1/m0XOiv7e0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7231.namprd10.prod.outlook.com (2603:10b6:208:409::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Tue, 17 Dec
 2024 02:08:31 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 02:08:30 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: add a test for atomic writes
Date: Mon, 16 Dec 2024 18:08:28 -0800
Message-Id: <20241217020828.28976-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0060.namprd02.prod.outlook.com
 (2603:10b6:a03:54::37) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7231:EE_
X-MS-Office365-Filtering-Correlation-Id: c20e3aa6-5f5e-4972-74eb-08dd1e3fb3ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BLlzFsxKmxpC1k76wqOG7ANjtZtu6kJTY5dJoAIdz6pjeptOR6haAIO5USXf?=
 =?us-ascii?Q?ODhp2aoJHN5lfOYnmkI99ao+YGRgPSqBxOWNEyfD1nYB5CwfI7tZne3pjNPa?=
 =?us-ascii?Q?PjsEt9c+UjjyHGZ/RDbgOINVArklHIdM/ojCR1b5nLwp9geXvpxRJqNcTFu2?=
 =?us-ascii?Q?fdalmvzzLn8FEc0cp/8dRzrJ+/B6tKIof/TItGFHuK7FPX3CZiFm+VO6kw1Q?=
 =?us-ascii?Q?spAjKtXlM75mbe4RfGr5uF1QHP1UaZAzOWYybp6P2kaEzoaYuJ7Q1nf9Q/DY?=
 =?us-ascii?Q?aryS7057Tp+nGbDX/HCrmUaUnbT7mY+Q3ZJvPiWQ8p5mdNeyVT1a5Yd3dgLD?=
 =?us-ascii?Q?8iWc9cuRyNbgNfoPXrEitf5ThZuWm4hhMC/EIqkqJy6HB3RjiseNsJqgaGNl?=
 =?us-ascii?Q?S9w8I6LqlTntfFgIP/D63e5cmjRoAfxJb/KCOp03klK/zjEIT9XWXRtaMKEH?=
 =?us-ascii?Q?aI4CefDP63XCdXeZNi5G+nmFwji5/vZp/gLkEc5r3rEQmhsBPHE5SuZwV6n2?=
 =?us-ascii?Q?/qR+Np0Q1qOZW+kpV3nKjbLGY6jeDLipTfiUeFe4U7zEo3+qtdaHLDJJ8IEY?=
 =?us-ascii?Q?S7Uj0ZSKv7ByvDPlnpgmzSN8cyqrOdqYhOXwgNHMIlHhV8URWUROR/R7tccG?=
 =?us-ascii?Q?nN9GevY8jTENeQsG1PtezSo+nieHlhWN/Qt+1RhALlig/nfSTSupQ01/x+RV?=
 =?us-ascii?Q?//1VvJFj1PC4FucclRjavaP6S4B7FVC7+e4L6445qrVIKY49k25CxbjuK6Jy?=
 =?us-ascii?Q?yH2RtNEWxPWBFG9+8dwHsaXl1Z2wGnHK4aVcmxAoti3Nh0y3UozSB+nxq4DN?=
 =?us-ascii?Q?ohmvanh9dExKiRxrHyUGQE9nkY7ZEU7PA+btZdhdTiep4quGDFXKvh+nu8u3?=
 =?us-ascii?Q?Ki+RlEdMPQqQ44O18AL/0MVi2qCE4PjXgP6qQIvkgy42kfdTIFC5axn64z+r?=
 =?us-ascii?Q?v5oTip/9/5gb+DlJgLw0QMsVppZDbZ6vmHM1MdghgBDf/mAg8b6M+DgQHxz2?=
 =?us-ascii?Q?2DdaAeyhUr3EEPTxfzCoS14YycCClcZwV5PUrxppcXPUCvr/l1oYJFPUnEnW?=
 =?us-ascii?Q?61nb/lbpSpGv+ARD7f6tfcf6RmtjNzcfHGqJXHebXcqcIXiW/6LFOj4kmxW4?=
 =?us-ascii?Q?Trd3LKPNsvWjm7Jud//yLQOBh0VPn181SM+m8RdU0MNYj6mSOo4eHcVLfCNm?=
 =?us-ascii?Q?B5EiPLe0Vu1JffSOcLJDvdfIV401yRI2/1As0VhrXYZuI6fSi2cndAmeZvnQ?=
 =?us-ascii?Q?P9vN/lIQbwBIouvuNBRiN8ygSroKi5ZpmtBX7wuLuvfDKCtgQ8j2UpdkdPXk?=
 =?us-ascii?Q?tAI0/lFndbr4GlPp1frq0Mz0CFDDDT/gL9/tW8Ef8iHc3z/LMkiIBIm3Dai4?=
 =?us-ascii?Q?NG9pJ4y0SOaSNAMPXrfJjY8kYX6+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iFxUDFWJWTeodoCBlAYVtNN+6iq2o77ejRasgAroo9YEgkPuD0I/i++aU3FE?=
 =?us-ascii?Q?6vJI01lBWUbDgOOzFgWw5zHJ3nvyKUnA1rVZjUpJO8WO+Zc5c+/i7UDy40Ol?=
 =?us-ascii?Q?03bJW8Ure47OffH0BqfC23eqzOVm2Z2Won+pqflrQC2sUrQY+Lp1k8oS6VY9?=
 =?us-ascii?Q?/Zcuv6witTlZCi5SJ8+B5tg+rr10mbrD1Ah4L3h/QAzCubHxUGu9GAUC/Z6u?=
 =?us-ascii?Q?DCOgv8LCou5yhHQQzgz2abYeHhuLbYPYTwkqxTh8muP8FwDkBowrkwy4g8s9?=
 =?us-ascii?Q?piFlPVgfUhGpVEu79z0d2AYxxugApkyuLrXKl6a3ZwpdJHl35BfgxOTazDw4?=
 =?us-ascii?Q?UvhbHeFze0sbsyEPumJaXLL+vv+NDeTcq9Tol9xh4cMuw8687JYPlhObUszh?=
 =?us-ascii?Q?DwSr2QTGN+c7iyjuLKs04K33uhp9QNbsXg9flQDwjuQvwLYfH+hs/3IR/EFQ?=
 =?us-ascii?Q?cHlipUWVr/sJi8bLMwPI0zZJUWSB6WK2haPz/XOHPB46x0gk1z4DO0Wa+TGf?=
 =?us-ascii?Q?gYd7UgpMFgNLQNEJF/cTFJidfxC+EZIbKlz6+/jLkqJP5kf5tfFiUcLG0onl?=
 =?us-ascii?Q?UWmSD14Sr+r1UHCCZS6Caux6c8stlXJhe5mucmruJU7MfDkML+4fQm2tLWZt?=
 =?us-ascii?Q?z6h7PYvUJFWQHxd7sTpzQ+64ZP8aMyMTdJ6qMZNPIZnJ72utZFE5IJReIu1z?=
 =?us-ascii?Q?ERZcmCPnSBqdgMGESb0lAmVTFH2RhyH2xQnnRbtcRtWQagmLUd+cdcV2nLgm?=
 =?us-ascii?Q?Cl5CvWm2x5O2gUkBpm3y9BXwEjBUDVvi8wIB0qHUDyGHgQAJ9xvRsfwloWT/?=
 =?us-ascii?Q?lqXLw6jijPy3IZuQINPE+AV2t30T2/gEwM3uMsUAw+Et3S5Awsw+EMK1TPtW?=
 =?us-ascii?Q?i7CTdWXHGEr27Az/FEEgs0hE3G/JgcnZD4HT0HWbjnhkQN9oDxjYUgyab0F7?=
 =?us-ascii?Q?UtwF97uqDgv5hAGkFQE504o+/rkT7MQQgOJ+s8gdZrGpz05oQFV6Xjp0oc75?=
 =?us-ascii?Q?0dCmzHWYiz1SHZkSsiP8xrE6kdzBJUHCvYHOppA/9oCgQUGZp4WHWVMJJvBN?=
 =?us-ascii?Q?PR1m/REwNzFOCRihl3QZcptr8gLbS+sS2YYzM4rtpcyvzfndi5g3pA2IXE8O?=
 =?us-ascii?Q?MJWScknhPxH51KuSyQgxlFJOPcyFvXEYCPwNaslUh8q1Pmkyzq8/Dyk1VxvK?=
 =?us-ascii?Q?gMCzuvqUhg+gHb257V25+x87NMXiVrqraxyvcto6Na/xJNhYQtk225KYkyTL?=
 =?us-ascii?Q?N60Jk2ojHLG0A+kPrQAe5wLQ+EIQqfR0RMuwZG7s5vY+RktU2p3obU1iBFXu?=
 =?us-ascii?Q?UsgSf1D9x4dCbe3FetQuk22abQ9NG0p9qB39wFNXufGSMGIPBnf4InyF990u?=
 =?us-ascii?Q?GX51kXInnUzYcmpkvTfOvidiUS4JwhHyCyjeDBLLWiFhfDoKOw/bfG7pFlVM?=
 =?us-ascii?Q?g3MOA3y5W1YaDPdvbvqG4+HBM/DDkze7dOZabwuESh91+VMbdIwNLxSQaB75?=
 =?us-ascii?Q?4XZEqFBKxatjRgCoVLjYUSLsMxB3VvFsSX3ntfUUA26HlJSOoGvPmrQlQxjt?=
 =?us-ascii?Q?yFEK9yDF+dTMX1td0FHFdPGOGxtJt+xdFqHruMbH3GOWZIBYiLudLHo7Yw/1?=
 =?us-ascii?Q?QIxkODs4k5TSVZPs5Smpr4/DjiRIl7+pNrPT26EeewEYlLgunCip9cnbkLfY?=
 =?us-ascii?Q?w5G0UQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9vfE4oYvgU9KpDiFtpxlg9Capbc/bowSWoXaDalezCU6rb3SKNSSBM0knRRQNOV/f3EeMEkE5CD39F3XcBr63mftGbQrrPXUN3UG+yrhP9iNjsBohgtv6wbW9I4HxfcyA8PYU7QT23IHaG7YutAp2L1mw8+BMXKqeYN+KuE3AbSqCGSd0lvutO1t7BbLFPFU4nZexfbj+6I1rbVPlMeFZWhCeTxtebf3cHaXXD2dDBK4Sgje+gaNOW0u7Uo3sNyeOP1vnuVHgXwpx0CQSu7o/Yu8wQOdaeqi6YkzP5OJ9BV2iI7+dFG2CjlIPay0zeYiKh3V0btghCL1kj3urgah8F6S3LeHN08rOYyLz7YUPQjVuEJc/MbgM7z1+FWImkKvdSCZTxpITsDSCrT60J1IoDyF+JaYlNGsHDGTnZDs1dSCaM0EUir19DY1oQ2Gif2s8/ha4ZQ9Hd11ahb4XTkB1j8wLn049fmG0h6A15MlMTob7SrV7dT2wX86jiIlrkse0pYOSNAPCnmiynMICSdPuq2seblzwUcA5C9W6GL+Rw49kJd+nHU86lhzPJhcDXt/utoa6fyNqJhqn7300n+BLGz//PSKy+jROQLteSBtSg4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c20e3aa6-5f5e-4972-74eb-08dd1e3fb3ed
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 02:08:30.8696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y+Y96feUqYIAmVr/RVPHjTZXvMesT4bGDewz81R1HZgnStIc0b04JIR7JwzGZ7/8onYL8nuh1D2iiqESkvp4Hm5x7CQjC1Mr3l39pbSUC+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7231
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-16_10,2024-12-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412170016
X-Proofpoint-GUID: wqA7ydgDeRkV0tqaO4anjULp27a-uRWm
X-Proofpoint-ORIG-GUID: wqA7ydgDeRkV0tqaO4anjULp27a-uRWm

Add a test to validate the new atomic writes feature.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/rc         | 14 ++++++++
 tests/xfs/611     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/611.out |  2 ++
 3 files changed, 97 insertions(+)
 create mode 100755 tests/xfs/611
 create mode 100644 tests/xfs/611.out

diff --git a/common/rc b/common/rc
index 2ee46e51..b9da749e 100644
--- a/common/rc
+++ b/common/rc
@@ -5148,6 +5148,20 @@ _require_scratch_btime()
 	_scratch_unmount
 }
 
+_require_scratch_write_atomic()
+{
+	_require_scratch
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+
+	export STATX_WRITE_ATOMIC=0x10000
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_MNT \
+		| grep atomic >>$seqres.full 2>&1 || \
+		_notrun "write atomic not supported by this filesystem"
+
+	_scratch_unmount
+}
+
 _require_inode_limits()
 {
 	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
diff --git a/tests/xfs/611 b/tests/xfs/611
new file mode 100755
index 00000000..a26ec143
--- /dev/null
+++ b/tests/xfs/611
@@ -0,0 +1,81 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 611
+#
+# Validate atomic write support
+#
+. ./common/preamble
+_begin_fstest auto quick rw
+
+_supported_fs xfs
+_require_scratch
+_require_scratch_write_atomic
+
+test_atomic_writes()
+{
+    local bsize=$1
+
+    _scratch_mkfs_xfs -b size=$bsize >> $seqres.full
+    _scratch_mount
+    _xfs_force_bdev data $SCRATCH_MNT
+
+    testfile=$SCRATCH_MNT/testfile
+    touch $testfile
+
+    file_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
+        grep atomic_write_unit_min | cut -d ' ' -f 3)
+    file_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
+        grep atomic_write_unit_max | cut -d ' ' -f 3)
+    file_max_segments=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
+        grep atomic_write_segments_max | cut -d ' ' -f 3)
+
+    # Check that atomic min/max = FS block size
+    test $file_min_write -eq $bsize || \
+        echo "atomic write min $file_min_write, should be fs block size $bsize"
+    test $file_min_write -eq $bsize || \
+        echo "atomic write max $file_max_write, should be fs block size $bsize"
+    test $file_max_segments -eq 1 || \
+        echo "atomic write max segments $file_max_segments, should be 1"
+
+    # Check that we can perform an atomic write of len = FS block size
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
+
+    # Check that we can perform an atomic write on an unwritten block
+    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D $bsize $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
+
+    # Check that we can perform an atomic write on a sparse hole
+    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
+
+    # Reject atomic write if len is out of bounds
+    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize - 1)) should fail"
+    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize + 1)) should fail"
+
+    _scratch_unmount
+}
+
+bdev_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV | \
+    grep atomic_write_unit_min | cut -d ' ' -f 3)
+bdev_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV | \
+    grep atomic_write_unit_max | cut -d ' ' -f 3)
+
+for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
+    _scratch_mkfs_xfs_supported -b size=$bsize >> $seqres.full 2>&1 && \
+        test_atomic_writes $bsize
+done;
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/611.out b/tests/xfs/611.out
new file mode 100644
index 00000000..b8a44164
--- /dev/null
+++ b/tests/xfs/611.out
@@ -0,0 +1,2 @@
+QA output created by 611
+Silence is golden
-- 
2.34.1

