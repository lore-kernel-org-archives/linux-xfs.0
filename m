Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82A720E316;
	Wed,  5 Feb 2025 03:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724921; cv=fail; b=auVHkDlRbanleNrlDU11IPn8jEjwNXIUtmW2nJHQWpuIpq+54Bf++EMywk0NieZFhR9BMlpEtQSFIdyb/zt8OTjmAL3ThTA32VZuVPQWPkI4AdChzjfUA5r5unH443l16bfFmgSssWSRqAUuyskx5eBvQB11fERkwiql8vz9KjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724921; c=relaxed/simple;
	bh=JN47Ytg4k53UFnHAkCz/qI+PLP9baTiVjFoVgJrKEZc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vjv9lIjBfuCeBEmpp0LG5/oYsF4z4UmzWvVk+RI/cfp9VbYuX8fZIVqvcLhw5wB+x4Wug6AzJyuLs7ksHBP6/v/+u6TOvGPQWFjT8HGCS8HmlHhMci9O00F6wR/HsD7yJirxESfFtE4gTra1a+Tv2r2phUCDcol4lKo1naLV2Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=STibDYbN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N4xZ3zgZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="STibDYbN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N4xZ3zgZ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBrk2008115;
	Wed, 5 Feb 2025 03:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=oO5/9V6jsYH05/xtnN0jd1Oh+/t77b4VhEZXIKkf3eY=; b=
	STibDYbNyhRsdkGlNqsaGutqghCDIzjr1v5p4qHbwh7D7SPsAG0zYJxZ8dkXPO0H
	LRI9voL85yCg/0wRP5nyuqX7PpzpwIYyyxwC4CRAG9SLsSpTpV338kxw8urV4E+1
	abKwZBODND8jOmHH0RNemotvSBnQGN2yXgc2q8P+UKzDCEvMDAvgEYPKN68nwYXT
	YKHDQIRD/EZf3szzR/xfwmeFieV03Sm9J2awrq+9UL/zIuezLWb2nbhsuY5f0mEe
	4zMfijeaQHH1EPfVAobQhtYutqTIOP62ycCC0AS6xLCwaP7SkOnYxF3sWsM+Oqnj
	+l1ZD8uISnF/I0jzRvxmQA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hh73nym8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5150akSg036296;
	Wed, 5 Feb 2025 03:08:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fn1pke-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HlrbfLt40aB4I79zwHAUam1poQp+UopdC5+3vTNd1gQws+ksW0kR2mHNkIA9zpbuB4WMyRjCz+kCb9sBHtQcIEUPUgviotAfUjnNEbpwr2YH5A9zkBZY5zlTQZHokoNorMPA5+MvPMcWtAyow1cHrJyWAureWhtuOOVoYVNp8F1bQ+InBfSdfnlH+7s/9v5eT78FDJPdhgSaRMGtlbljjlD7V0Vdl2ModdgM2RuFg/vczReVeez573lH8NmoCX0iSJWx1oY1npQLo5HYiHPqWcM8lOsYTuxhCgwwDwpBPB3b6OvjQWgbxI5ArKPTY/cLYWwwMzMIeRFLeZapnfHKng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oO5/9V6jsYH05/xtnN0jd1Oh+/t77b4VhEZXIKkf3eY=;
 b=cntrQEF1Z0H2V9k4vCwCqsz000p8MjuwxWvz72FYkbfCyiwFXI4J0xPDLfteGrTHIUsfh22FzNS3F9hkgTqe7rVUnmKlb1g+cmY47RELLpfxzDb8qF4+zY6ls5EVcthxCtHgKCOWNGTEqP1XLAe99/dSQmYopNoxB8OQsb2fge/NUFWlIjsmqc6NBgVrJQE4loWEr6Nq4dfrS1dE29saaV06JUdJKD6rUGOtaxs2rJWPxtOGv48mODvzQfRBB8tcAI1fCmw8Qml3jMjqX5MNgFHgWyKcXxRPHqp8dQppka8+FK1jd/Z304bjIDCi1qfxdhkYZGt1aBGDe9JSACEeWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oO5/9V6jsYH05/xtnN0jd1Oh+/t77b4VhEZXIKkf3eY=;
 b=N4xZ3zgZ+iZKUUBzRICZ9TWuEzrK+LMuHSMQWgbAedRFEgiFqmAHSR8XKRr9mCeTx4glaCHupxt33uTuVND377KvOXnWrLN5h4ahVrY6ER9rIgxwXjzCvoUB8LTQAr0uY+XtseCkAoKqv10h4hoVCSy8B2KaRSOjIr3dVr6Vbiw=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:08:35 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:08:35 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 23/24] xfs: streamline xfs_filestream_pick_ag
Date: Tue,  4 Feb 2025 19:07:31 -0800
Message-Id: <20250205030732.29546-24-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::28) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 02b145e2-7078-46ad-6fd9-08dd4592613f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uPk5XeTFbXvTl2xLF8oZXyymraDnrT2D3R+qrv1ozsdE7pu/KEWTmvVb9hJi?=
 =?us-ascii?Q?U5GzaXOblJcu7hPeyaeTMI9cG174mFlt7AhpSpi6xIeZc6KddhFZkbtSe+Vp?=
 =?us-ascii?Q?nHoKWLwDSvwFmzYhneaALQVce2uvP0/x00KdJd6sPPucU9en0KqEgM9EvG7q?=
 =?us-ascii?Q?0RZOP0BBAqnsOdo9ntPsSvRAQqmePMogDUR6VBS7sZgMBeNiC4msr8PhIQ6N?=
 =?us-ascii?Q?/sWIfvQqWojGUfoEQOXWBsex1qtfeJiCI6hAFaq7Zi/woZ6VNmjaNQbNRNoo?=
 =?us-ascii?Q?sDC/KL8m3GFt1dDrKtMD6RUc7bzjAZ9UYFN2bOkLNovvKompJ5mNJbCQPXwg?=
 =?us-ascii?Q?Tuw2LxHCpVPouTm1ERoGsFq0PeMHj4qCTDMxpBMlTCH5x8SFfbLXOesRqNpp?=
 =?us-ascii?Q?Qxeyv0QPRNUQqRKUlx8u8MkVhICPJzSFp6BgtxSfLWzEBMp0MhzecFlI8Uvr?=
 =?us-ascii?Q?LpXvSpwsvQwiONNJz/a8U0F0Jzy8KHPoVWBU7EZxnVSMIaODhx0ktpXxwZ19?=
 =?us-ascii?Q?dTh8RBDB4iPp5xNqrC+TUwmiFnFF3yOo7ZAuE8krIIkKLqfKFs2eh+XUhJcl?=
 =?us-ascii?Q?cb9ddm1E/Gfte5zMWLQJMfzVbt+bg/7wiPIayzL7L7+uKxkYA6N3jyMuXBUO?=
 =?us-ascii?Q?YnNZh1+ASjIRm3oqYcJefPfwrRR8ui6Z+I6LUTyRU2hgrj6N5/hw7q2+ah5/?=
 =?us-ascii?Q?mAO0KNHrd+V88diHO4pFZ7GupNWaMQRE1JKyOPcZgMWFiCA2zBjwZcmFb4LD?=
 =?us-ascii?Q?Q7TzSixhJ5fAIE1n9yxFY4E2Rgm71I1zBuwcAeNckZ9WLdEWLC1M7GBFli37?=
 =?us-ascii?Q?BK4EPTVGZHJ5wxdavMMWMLanapN4MFynD4XwYi5lUUXL/L0kbWIjnXneP8/8?=
 =?us-ascii?Q?n3ruHHYo8MzeNiCr7viXv0/cGNTk1eHnOu/0xtv3pC6YswuoomspAhiFHjnr?=
 =?us-ascii?Q?0T/r9DmLngfeEcbYKleSnbJwdD5Q7NYJuB3ZPCiri01FRyu8a3qdJOtt4EjL?=
 =?us-ascii?Q?ywr5kZyU2NGTQWOr/DW4HZ1/LJPAbSH9/h/Km3kGIEeN2Cqy9F6gXthyXLDB?=
 =?us-ascii?Q?1b0N8zs3571XS5M4C6Sp3lmtpe/vusWqQb32fV7mGojI8/kayIO3OzWqOhrK?=
 =?us-ascii?Q?wDc9jjlabdXxrs23Q2chV9bqqKNuUaewideOE1eCUiIjQgTCYGXztf9IWzDo?=
 =?us-ascii?Q?tEGkyaYPxQ/83ZC967ocjvNn12/16keiKDAePfpo7ahe4V+kW5ynyKfXkxo2?=
 =?us-ascii?Q?Oo5gy8e4UU/RJ6Ec5/nNHlRe4Nywkwwoqc9QtSLBrEqXw42cbeBIFKGVNM0K?=
 =?us-ascii?Q?7JvQQ7SrIfyjLPogavAfIzpp+HEzGOly1tlxW0Mlp1VKdIjtezheRbF0YSiJ?=
 =?us-ascii?Q?um2YcxXuNc3toHD6P6SM6/OxjQoB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VNiB/yDqATI44mlYDtJIdRs61h/tDbqDZbQ+cXy/jGCUckCuRoDdh7XwRIAo?=
 =?us-ascii?Q?IIrM4w6JtDiwomh164R1n7XzFeDEvMXd4Ra+G+g86/e0ibNQL5KjTDPsxAGu?=
 =?us-ascii?Q?r2XfAwQ+AAYCHKWQeZ7Ax0ZMypj9BAdX/b/zI5yIhBrD7R6jcjWUjPER1RBM?=
 =?us-ascii?Q?UHY91RRROP/bBS5hg6KJMR4V+x5LRKENJvEYprmCcwdYpbBVsP6/b6KI7JD+?=
 =?us-ascii?Q?6q3zSfz+fn967mlT2OKI4jjShKmMARCvgJf9RJNKIwT8TgvW4AnwURdET5gX?=
 =?us-ascii?Q?ACy/fa2m/gsvkxMJ5WnOh9B+b1ZTN7a9JTrrJStZiS9qPdksW5Q8qRpYFHDf?=
 =?us-ascii?Q?7FhTHgj2Pd16TFnIJUTKwN2vi8qTtAhA6clX6gnubHTkRO1dLhL3+REee3P0?=
 =?us-ascii?Q?pcvZi+hZYKbNFziFZI3shkpGyJepijLKPZ7USC/VUHzR0QnV3M780zr+lv9o?=
 =?us-ascii?Q?I1iBmS6tepDC5mwiED230jzACQ9NX+HSdkarijqMHqWJQaInvyWvlmqq3Qo6?=
 =?us-ascii?Q?ZzlVd6F1xz0OFY3KanwhgRGZbsRoj/dt4vBam+FXtoZC2iljlkIkqXAslii/?=
 =?us-ascii?Q?fz6kExFULYJO+raCamvKkc7RW0wF0EaxEXc3aE7Fon+A0aEtBWldnexif9HY?=
 =?us-ascii?Q?TYqGpWK/hZDOUBX2M5HWi/Q0C8S9Ltc3p4WA6haJnVIRTY2BCArFVaQNqIMq?=
 =?us-ascii?Q?A5pqubIYsFytNeuzc0IueMxtU/ocZWHsLUG694vu8O/lu4lex/rvpU1W8QgF?=
 =?us-ascii?Q?381BLdmAngq4vTSnXFFUVdyg8UFGRWJjO2HJjWykF/w3iBAOxwzLv1nDG6f/?=
 =?us-ascii?Q?AbcGRE8BDecdGqvwgxCvVSqww7k4vcxs9PT1rBFrUlVDQaHqYmSFmVzpzaJw?=
 =?us-ascii?Q?LLBjmb/Ek3NUUuASXfz6sE2lPhwN7irF4udntBdwokHlg/OIcXy8dSg2RnIG?=
 =?us-ascii?Q?Iu1jfrz+22cCa3Lsza0S6fX6oF8JH/2jFPBoAzltMA1XUMBYJKNiTlqXdxVI?=
 =?us-ascii?Q?JwC+f1HsEsFdvTSEF5yH47ttLy26TkjKOenZTepa48GRJYdPE5kjhjRY/Bti?=
 =?us-ascii?Q?pywdQpKWgkrJBYcKxEqijESRgN4MgALEApG4LSAZ4F+KmWNGDLkPUUAsaPHi?=
 =?us-ascii?Q?R7Z6+/CPS8N6Dzu2i6U96numy8XEbCJFqOXm7204nwwPV5y03Td9euy4/+Q6?=
 =?us-ascii?Q?4xQcTwVllUDuOfD5j/92OCVh7j3YqKYLBpU9BiN8I6ucM3ecCTZNm3V7KIKH?=
 =?us-ascii?Q?rK+xXWArvUp17ZDze0dnUe+rhMKsEGILlOXHzWoW5WkLpBci92z/35LPg9UM?=
 =?us-ascii?Q?QMNsoQwwtngyrv/qpVYpu80xy5/69V6OPWqvi/4LOlyH+kR5bTfIiwCzeo2N?=
 =?us-ascii?Q?3BMkdEeedpXcL5hicOiYQ7BWtNINFg4Jugkvkf8KiOhrLVTPJyEtrX88g27N?=
 =?us-ascii?Q?B0iIR6hJ5rV7hNWpgv9nMFimz9uRUlk7w/d4JrKvDBxSSM1uT7IWaVxQEUhm?=
 =?us-ascii?Q?pk1ZBVClyaQE6VioqZwr5gUk5098YSAF9XghEgJ7mkusOPXwTkNM/Y1GtmeB?=
 =?us-ascii?Q?qgBP5r1BXdFkzDDw2JQWGjoD58Eqg0n2j7beN258ExA8q6cvV3x1pGyCMB1u?=
 =?us-ascii?Q?GRcqc+uuZ+wxr265KOI1uIs5iKSTHFJiko85xa20fagZ0UC+SzNBVCoHgjvg?=
 =?us-ascii?Q?iP+Jaw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g/GkxxnIAr/EEbD103H6D7UxkN2VICSHoA3D4FwbtdAW2sRzPDrdgI7r/4q66NvBqlfv7ralQ9VKuuRG90qG5Gpy7JLcRjbe/hu832LtvW1y2yLOyhu5h3JOrN4vH5epU8vu1Y6fj4YrkJFdbYV39frjgIHnixGGmoXrXAmcMktzJwz9SuV88YOi9y8B/CywB8loE4Nci65pU3UbubYenyiK85U3ag+lXVlLX2JQQfZirORNvwDzGhxU2tb+lwlJwGItzXNnX/kQYUb9NWq5zIOuB5r2SlTIMK+Amq5GsXPNtmrQhg1Fn3EYxursGmLb6S8iMns6Fci0d8iF0HIecOP3ffSv6ceDDYbZRFNAkNlrRBLf/+uqoNlYWQQon8jvhwxWIhiLXRlzqXA4iNagqbsf/ZcNgdIm1t4SQTe6R++37IiwuYGlQxsnhrBQE+sHEuNe/cHKXiZsdvNMySe6BDeqEgAnmZpkvRF4cOr7+h/4SNmj4ZsQvmh8rOWGsG2hhpdsUwFXgb2rVR9srTmQT8TfmuSqQvwsqFwZLCZlZZ4zCy9y8pS0ijqQcdtQFgfG1irOhgD8An5/05LJqF6lhDm2PKBg3I270Q06B0Wz6T4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b145e2-7078-46ad-6fd9-08dd4592613f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:08:35.6649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2ICkMwxuTzuEqvxJby3gkCLpcaKCjh67zEOFsUFSkgAMemtW5oCpqi0DI8tyKqZK4hsEVugqs7Aq1v8LACKvGaAVPUJK4eE9hZ87Re0/BU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-ORIG-GUID: whc6JWx3PZ-E0TP7vsdk6YJoI040g0Ss
X-Proofpoint-GUID: whc6JWx3PZ-E0TP7vsdk6YJoI040g0Ss

From: Christoph Hellwig <hch@lst.de>

commit 81a1e1c32ef474c20ccb9f730afe1ac25b1c62a4 upstream.

Directly return the error from xfs_bmap_longest_free_extent instead
of breaking from the loop and handling it there, and use a done
label to directly jump to the exist when we found a suitable perag
structure to reduce the indentation level and pag/max_pag check
complexity in the tail of the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_filestream.c | 96 ++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index f62b023f274e..4e1e83561218 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -67,22 +67,28 @@ xfs_filestream_pick_ag(
 	xfs_extlen_t		minfree, maxfree = 0;
 	xfs_agnumber_t		agno;
 	bool			first_pass = true;
-	int			err;
 
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
 
 restart:
 	for_each_perag_wrap(mp, start_agno, agno, pag) {
+		int		err;
+
 		trace_xfs_filestream_scan(pag, pino);
+
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
-			if (err != -EAGAIN)
-				break;
-			/* Couldn't lock the AGF, skip this AG. */
-			err = 0;
-			continue;
+			if (err == -EAGAIN) {
+				/* Couldn't lock the AGF, skip this AG. */
+				err = 0;
+				continue;
+			}
+			xfs_perag_rele(pag);
+			if (max_pag)
+				xfs_perag_rele(max_pag);
+			return err;
 		}
 
 		/* Keep track of the AG with the most free blocks. */
@@ -107,7 +113,9 @@ xfs_filestream_pick_ag(
 			     !(flags & XFS_PICK_USERDATA) ||
 			     (flags & XFS_PICK_LOWSPACE))) {
 				/* Break out, retaining the reference on the AG. */
-				break;
+				if (max_pag)
+					xfs_perag_rele(max_pag);
+				goto done;
 			}
 		}
 
@@ -115,56 +123,44 @@ xfs_filestream_pick_ag(
 		atomic_dec(&pag->pagf_fstrms);
 	}
 
-	if (err) {
-		xfs_perag_rele(pag);
-		if (max_pag)
-			xfs_perag_rele(max_pag);
-		return err;
+	/*
+	 * Allow a second pass to give xfs_bmap_longest_free_extent() another
+	 * attempt at locking AGFs that it might have skipped over before we
+	 * fail.
+	 */
+	if (first_pass) {
+		first_pass = false;
+		goto restart;
 	}
 
-	if (!pag) {
-		/*
-		 * Allow a second pass to give xfs_bmap_longest_free_extent()
-		 * another attempt at locking AGFs that it might have skipped
-		 * over before we fail.
-		 */
-		if (first_pass) {
-			first_pass = false;
-			goto restart;
-		}
-
-		/*
-		 * We must be low on data space, so run a final lowspace
-		 * optimised selection pass if we haven't already.
-		 */
-		if (!(flags & XFS_PICK_LOWSPACE)) {
-			flags |= XFS_PICK_LOWSPACE;
-			goto restart;
-		}
-
-		/*
-		 * No unassociated AGs are available, so select the AG with the
-		 * most free space, regardless of whether it's already in use by
-		 * another filestream. It none suit, just use whatever AG we can
-		 * grab.
-		 */
-		if (!max_pag) {
-			for_each_perag_wrap(args->mp, 0, start_agno, pag) {
-				max_pag = pag;
-				break;
-			}
+	/*
+	 * We must be low on data space, so run a final lowspace optimised
+	 * selection pass if we haven't already.
+	 */
+	if (!(flags & XFS_PICK_LOWSPACE)) {
+		flags |= XFS_PICK_LOWSPACE;
+		goto restart;
+	}
 
-			/* Bail if there are no AGs at all to select from. */
-			if (!max_pag)
-				return -ENOSPC;
+	/*
+	 * No unassociated AGs are available, so select the AG with the most
+	 * free space, regardless of whether it's already in use by another
+	 * filestream. It none suit, just use whatever AG we can grab.
+	 */
+	if (!max_pag) {
+		for_each_perag_wrap(args->mp, 0, start_agno, pag) {
+			max_pag = pag;
+			break;
 		}
 
-		pag = max_pag;
-		atomic_inc(&pag->pagf_fstrms);
-	} else if (max_pag) {
-		xfs_perag_rele(max_pag);
+		/* Bail if there are no AGs at all to select from. */
+		if (!max_pag)
+			return -ENOSPC;
 	}
 
+	pag = max_pag;
+	atomic_inc(&pag->pagf_fstrms);
+done:
 	trace_xfs_filestream_pick(pag, pino);
 	args->pag = pag;
 	return 0;
-- 
2.39.3

