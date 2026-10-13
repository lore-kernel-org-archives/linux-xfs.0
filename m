Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD5F3B19B4;
	Tue, 13 Oct 2026 08:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879289; cv=fail; b=Y1jttZWq5mzTQNwwBDov+vbyd611eROpJdz/ITAKHMRvTDeRReM91FrKjZ/a0QcMyvHtd3g7TIiN6Q9At8Y0Mn3DZcSJGpclc90uM5moAGPTu7Srmk8jDjeMTubyBGo9xPcEDiHtRpIAQZ0NRYn6QuOPrTXsIuyKb0iuul7sdsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879289; c=relaxed/simple;
	bh=neV5s8/EEE57Zfh0A9h+HcClqKGAaL2RN8QL5HjC3Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pYtuf/gs3qtYMxQ+IX0LgMrvp5WMlhkzXvB20iJO+vFZ45cttu7XOQXZ/0D0mafEPqUEqamEtpzSe7EV9VzMnI6nqR7615x3GBESqN4zzAOgbZJRY/StDfzhp60pBlBh+233wjXO+FuwMi/6w+r0LkMHUL0UXLgOIY43mvW5tAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AIIPx2Vb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LeZaCz7a; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AIIPx2Vb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LeZaCz7a"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Br7O3109983;
	Tue, 13 Oct 2026 08:14:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5k2K9VS7zuQ/UTlCAJld5uxak5XJgLgnhv4R/bikwio=; b=
	AIIPx2VbOxI5TBq5hTvM7FlO5T35Zkl03Oqe6CyZtPcAZos78TfkE8euePYtQbDX
	09ORIjlktYcKtoaRelwiqhPi2366aOO/pJnbxN1UvYtZniZa5LtnDOLstdeFvkGu
	PSiy6vhEEff5fdHrzyN/hwy7G6xf9PWVidtxkO8kYW4piX+nO8mYasmmh2A4u4+r
	JHIezE8x3eVRqVyLweji7ZmtVTYxJwSghBlODVFD7qZjLfDkfdHwzrgTCYtlyuyy
	3Dc7zS4IyvSZZRswSKTuuj2M5iO6Gl+oVoDEpZwPGPv+YdIg/SbCObwbak/lyB/M
	QxCCDIxQ5kHouaKvnSVDeQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7ddgkmj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86SAd002134;
	Tue, 13 Oct 2026 08:14:43 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt8yqcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=af0o2OnoTuCJWzMnX9eW3tqxGjfkTcdXng7JmQq77hzDqaLcsA2hJh2tlmfm7XHPMDqyKs5FhpJV5A+rrOea828lPp55o7ZzH3H6WDSg9izYZoy1LBO5LQD2KDzqg5O7AbbzJMBblSyjq+VPHwAJqTfZFVbVHQx69wMR4ypley6Mhk6pupzNvJeo6asDTej6sIYae8gEmKbtph5zlUvIpCKu+X+FtjtpPw4lGcYQWY1E3DcJqvR5b+uQoi57tqUfFU5qv6UhYlKuAzZ+DDKinDXuOTJkxnRE87Cd60SzKiNi0IeantDDR4sQ+1bjCk5B46gE24pw/PBWbQwc2nqbpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5k2K9VS7zuQ/UTlCAJld5uxak5XJgLgnhv4R/bikwio=;
 b=RmpvOzZ52OkGgOwRseLHvdXUKV2Fal76nMwMnt87Zn0vNV89zmizp3wosOgsYKtQaqbeP/yw3M3yFzQ4O+4q/l1Ls6eWIulXejX3OysOHmjMloQ4zVLwJ9Tapxlb4EBuMgTokus9ONVrAK+LiV+VCtEdpZ0pnNth6l/xeILhGJF5KeWRPwOVP8elMsG+juoNAH/osx9qvJ0qlRCgm0mQngurbHecL6KhD1EqsLx6XzB8bjIJztEfqqdKqnaHegvya0ELtHHE6++XDY0lKfoqkwlS8suxgDeT3YDp7w6ASordMwaXuy86lFRJMq3U7+l2M+YsPn++ixFXyT4WiXhM+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5k2K9VS7zuQ/UTlCAJld5uxak5XJgLgnhv4R/bikwio=;
 b=LeZaCz7al4UcL6dKJhCGA485ko7tGmxNLyoGXrQ6RCrjzH8zvHELr9t/wyRITiN7FyCpAQLBgtfVEPBo7pRpk+64n7ItEDHoQv1ULWzcY3XhLqbAj2Zs+bqouCdi19tftctnWEKXOn/EGWeItVPkb941YTOg4pFIH5QUa2d+dHk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:14:40 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:40 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 v2 4/9] xfs: buffer pins need to hold a buffer reference
Date: Tue, 13 Oct 2026 13:44:12 +0530
Message-ID: <85a02418204d3bf4c5f3ed5c96abc8eda1f69d77.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 9757bc1d-093a-4812-21bd-08df2902076a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|5023799004|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	9eozOE+0oA1pAwwzaCNBQI9WZ7uV7K9usU94x0gu3REfOM1vMrnUeD8CCBZGVQe8g4CT4TJAlc4jGmAf6YUpHfdl5ALgr6kYIbb2uxlQ9N7snfFR2SjYzLxOvR/INIAvG04vS0B6MrsJGdJlbfGHRQG63rtUl6NnXgGwSjhNCOvwTmcTQ4KT6ui+10mYOJF4Pa1t/YUmQUbxVbLdmN6xeXPeJm+M6kGjv8hnHjWEphPwPKpVgKajOo3Ja6yedJbfjQF3GoUDQ9li2f1kdmvB5XbAsMHey+shZ19TbQJtMTCpf8RYbUy+0CdWjwa3ZsoOPUsbnCs0JtPG+WlNTgsmDZQjY2ybu/LpDBOMrPQmCIx+omAC6cYhEZXwz1Xwyt5808BEyXkX4Yvdn+bOwTfu288edd8uEJiMUlFcXjBE6VF+NbL8RCCz8ZWSB/EYDB0Gfz3UExmnXEYRGQ4dqXKr6gQIvi9jhf4NLy6vA4gO+Bbdskoay5yWOY4R4IcWWaM/R1/IF2L9N4S09J/Bq/XB79Ks2HohJcx1mzHf6cEElvcICRFVD09pk003xEzmocwd4m/JPlMt2FYc3hEQqW65EivRGnlOaaBEpLSI5AhvV68J3Tai+P6tOVqfZwkQedEYVMYZpW7cKK7jev+yFn+cCwDLCEOBOHfaywGUt+OhVkU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(5023799004)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5vlLhHWp1Vsm5MJlKxYAPk41404ADJn0jstguhNmOzHQg/KZ7sZ+JutOgPX3?=
 =?us-ascii?Q?iJ74XYIMOIddCDOfDjV4cBb2Cyd24696Qo5cycUyQenm/aolXg7XaW6Pk4Bg?=
 =?us-ascii?Q?5HXlbxCm4CnIRTDFrihkeEoBNOpINtebEcQkGznc/aHSW6T3cXpohW5Y75uV?=
 =?us-ascii?Q?XmWwuJnwsLf3OdtoxFDq74qv0qE1GvIOt8UqgSoke/CR/eFhhSQ0EGhvdB2s?=
 =?us-ascii?Q?9NKj5GPOC6xyaCI6Ru6QRCMZDIeMq1kNDi+JWBDwSNxmaimZmuBtib+ozyXe?=
 =?us-ascii?Q?tGQzD2zIAvNZwEBhsmJ0DzUsxV2W1ffq4VHP6oq8DjmsuysOW7mwwtJ1zVEm?=
 =?us-ascii?Q?pVHD0JXgp45CebPeCehST/n71mLBbm2hACMpttJKZpEUmYYIZH5pZ56R85mC?=
 =?us-ascii?Q?QdE3Is7PhFvhEmjHWQBrR+C4zMotkrkgpQPE86L6JHEqRbFhjStUHSFrZfax?=
 =?us-ascii?Q?rt5RAd/fzOIV+daUqQTIYvjn+WozzumcRaBM7oJuySwm2iz4Qh10q5Nm4wBb?=
 =?us-ascii?Q?UV/D6tewBcjijFNf4n5Sr4on6nS8SfWJKGvlRT4XVeyXNut7icjGeTIOQ5ss?=
 =?us-ascii?Q?2DqqmPsNCY18HkT4tDKrj51htazou0AOX9Dhef9o1PHFDkh8IP88DCIO8RI3?=
 =?us-ascii?Q?XhEAQiroVD6qkMrMs3kZMV/ZsHfrLWBdU3LGCQpbiCopYYzAFmaNzV9HK8pB?=
 =?us-ascii?Q?Zr43DDLCtmG9YJodOswq++oGfew8Ka9X+2sEzCCfkUmf+Xfoq4AeB77mPldq?=
 =?us-ascii?Q?mL71nO833hFvdqqqQzjE285HZrk8g2w2jQolReeHdj7djSx18N1rJ0Rz4Z7e?=
 =?us-ascii?Q?W2t1q/f+rH+QbwAnZW/cdiVDjoC/yh5norWLtIteGL9vUB9RuDcmMNJGUGBh?=
 =?us-ascii?Q?5SMSjyEKpVETrx7UQrC6IFR2RRlEXSjnmCn9JJCZmCSMl0bzUjAVrYcIHEnF?=
 =?us-ascii?Q?J5pDO35OpbDvG6VUBArW0lg/wX4aPJ391akHm3gOim7BL1zWoN83qAbmkMaZ?=
 =?us-ascii?Q?y6J/Rt002nNfXrDeEBgURWFmE5RYVl3qIHrLnTYxMcbkIm00K76meIUjKkIY?=
 =?us-ascii?Q?HN67KAyPLl71bglUgug0qZGOkkNusq0rlniC/1dFcdu32iYAyHs86jmvmvZo?=
 =?us-ascii?Q?UAcubDyczP54FgoB+BxN8QzeTzXWI0US7is8PujRhJEMZYctgDwKm2ViYlaK?=
 =?us-ascii?Q?TFbBoZZfFOpHyWFtiS8HoulOSDy7wx2YU/Mmi7luL9GyXj1Cd9Im+f9xSzqD?=
 =?us-ascii?Q?3rJEcGOwbbwweXeZLrv9ZRaMvoA1wCITUqpCghiaoAONzmIuRKagPB8V+twS?=
 =?us-ascii?Q?ZRzalnKRskq4ERBtVIqP/gCloE36f8Zz6wyiIY1hi4QG4r021qBeO1mLcqEg?=
 =?us-ascii?Q?r5I+/ILdA+etgIUTvRuMZ2QY1/apaTAaBxnygDUUHwN5soGlrbcuz1oQazaD?=
 =?us-ascii?Q?YdQF8toc1tl27qA/ATKeXoSOf/opWEUAVDrDhg/mWEWGsOjkUJWEK+28Z90s?=
 =?us-ascii?Q?/9UZ4Rlilw1BMhl9GsCGeJsJNI9oAZgLKsNQD7n7DxnPzmWOyCR9H3uHao0N?=
 =?us-ascii?Q?40tn1eGCzQ5b7Eyr+GtEXp93NA/KuYtarQuKsefmgf1TPSCVsTL9Eohgs+tw?=
 =?us-ascii?Q?kYJQt0UYM4nM1N0oCpLcLzmowEakktg0ciEGIGojar+kXXmUCSKyPN8PUsvn?=
 =?us-ascii?Q?C/h7sKqXZWV79NXcTCKCH7w4bbsA/GC/XfXzlCpcpbS8e2KmRuJTTvWyA9f2?=
 =?us-ascii?Q?JG2UgU7O5TeN2uA/u52W3mvl2+KgG4xkQpWNnr80jp6h8nVJr7I0zmDuUu3p?=
X-MS-Exchange-AntiSpam-MessageData-1: ipGCLonnRUBZBCumiqZhDtuQ4t1rljELyn0=
X-Exchange-RoutingPolicyChecked:
	QV67d6DHbf6V+XFPV/bEyRkxA8fvAB620zHm4fbz9KD/ToTUlkEOvVvKQ3hIoNnQRQF67YcV1Llr4O9gx6gi/uK3gSuddD+ny8hNzLUC8/1Yow6fj9MO7Mo6oPP0R2KV2BNp7c8mmvVgE6BFQk52k5xqV/3E/NX53COJr6bZ2i8++n0OG3XqIHCFJc0LYLtdKdopx8kT1QyAILJo/ZjfSFSymMWnijut7acrRWxsnW+YkyAcFJEw6yaG7nBzsfoYDTtBF4K5jPErggfc/g7ly550u27HygIRIM1DspwVbX358B9eKCool5ZdEXeGf4vdy1r1qcQHr8mqRbFKIex8Nw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ImdyjAg35OzkQG/yNamr/iwB5C8IKYI8VgnjR0Ir6JMQuIIy/GhNrBn9HdwMbVw7r8Jny61Qns9a8L1G9gRuZzerJqJyv3LAYnW5sMJoNNpaC+Z7dxhS0hJvPpPuDllsMrTL1wivwqt5VJySZzBEvblkg2+0ADN8o9ks1gVU8onxgu4P8VSSD+rFr6Dz5UuqhWaojCgIT/NVKboo6UGYjnD13kMkmp9IrRHacvTZWiE1KdObriR7rGp9jfw5QooV4Jnu6rNJ3M2P21z02wxP7MFUP1Y41H3hXH+EmheOKTZ24hexmeXACqV9rjG4ONigTKS69t6Gh7M6iEn4uffhbVWtWQYKJmgYZl8wmyG/GmE5z4GKSy0EqXshmIj5jwqivCG6TnT5dMkdQwHeJAdWmyybP6HBKxKv4L2dSObSMhyTF1GrTSokrAm1Fx9qAfEmy4CfaIOgPIscMoaIlP4zZHfqfgGORtFS8L/e+FEHlZCQYVYQlUKiAKfCxWNCWXWt0FIKcpsLd4KEVx4lzVxkeswBYhendymNnEsQnO1K/vRtBkZ38aHcgw+6GlGAfHyBjHJsPazlJ1FMkwT1FCR7KaARdux2L6ltgaYFRkjPU2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9757bc1d-093a-4812-21bd-08df2902076a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:40.2736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4CfkZypXA2RkRpbRwC7eV3EYY6/G2JlzvSD4XwmZDfdpRA9ZHP12u5yRCfkdUZrGgNEm2p12JJ3Y6wzKw2r8RJ0snvnWKqbD5f/QH7LwAXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6acde874 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=20KFwNOVAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8
 a=7-415B0cAAAA:8 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=yPCof4ZbAAAA:8
 a=t0Y7tUnTQisWX057riYA:9 a=biEYGPWJfzWAr4FL6Ov7:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: 3r4-NeaThgd-G0dAVMJuH4BOFUxFeAm0
X-Proofpoint-GUID: 3r4-NeaThgd-G0dAVMJuH4BOFUxFeAm0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXzMDsnZHsnQAb
 I9mGaXdSmm9YxCZt5df+drVr36JmTe8+8sYxkzrWL2OGPHAg/QwUNzIIxvV/BMb+w/QGj0kO1ml
 g5Ugf6vcUJSa0N2LrrZIhqNCrEtLqdYtdNIqgEAdnfJ2OlCekS5m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXwZW0YF8MwD6U
 kJGoxoDRwoJqEQSkr74o93FOCJ+b4iQ67Bt055nte+C+K0nWTcE1OKpyAofrFC9L2z+aAgWKWnN
 vSzSY8t1pQdG06pVcJGPdMk7dOb7vUmOkxtR7BaP8qQ5UuDkixH1OUOTafBYFcloKrTIKqg8D2w
 Kn3DqCfRTUtirZ0SYRWjbBHfu6a6Op89gPSGJuFcBL8rq7Vx2r5vR10dlkWUgS9q4d/WFBArQzy
 trvU4zO2413cAERSCYRHfXYGVU8thJvMuCGxj7n/sA8ZzMfHCm6FU9VGdj4KLsUvFYZacoHYROu
 VY8ajmlESG408Tmfxx576naMVdLB58Of5x+gHlQBNHdr8REQ5Bful6VNF4LE202peS6g08HeLqx
 xGOZf8JtfcucC02wLFHpw9sGkVu9UHfJUCw6V8EaJUoa1a4zTZ7DjN0v3fY5XgeM8UGWSNEHEYd
 sh4+lX3TWxaCnQj9WzA==

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 89a4bf0dc3857569a77061d3d5ea2ac85f7e13c6 ]

When a buffer is unpinned by xfs_buf_item_unpin(), we need to access
the buffer after we've dropped the buffer log item reference count.
This opens a window where we can have two racing unpins for the
buffer item (e.g. shutdown checkpoint context callback processing
racing with journal IO iclog completion processing) and both attempt
to access the buffer after dropping the BLI reference count.  If we
are unlucky, the "BLI freed" context wins the race and frees the
buffer before the "BLI still active" case checks the buffer pin
count.

This results in a use after free that can only be triggered
in active filesystem shutdown situations.

To fix this, we need to ensure that buffer existence extends beyond
the BLI reference count checks and until the unpin processing is
complete. This implies that a buffer pin operation must also take a
buffer reference to ensure that the buffer cannot be freed until the
buffer unpin processing is complete.

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 81274891036602355e72eabbb5184490f354b506)
Stable-dep-of: 816c330b605c ("xfs: factor out stale buffer item completion")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 88 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 065bbf03c7b0..e0c75aa3cca8 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -452,10 +452,18 @@ xfs_buf_item_format(
  * This is called to pin the buffer associated with the buf log item in memory
  * so it cannot be written out.
  *
- * We also always take a reference to the buffer log item here so that the bli
- * is held while the item is pinned in memory. This means that we can
- * unconditionally drop the reference count a transaction holds when the
- * transaction is completed.
+ * We take a reference to the buffer log item here so that the BLI life cycle
+ * extends at least until the buffer is unpinned via xfs_buf_item_unpin() and
+ * inserted into the AIL.
+ *
+ * We also need to take a reference to the buffer itself as the BLI unpin
+ * processing requires accessing the buffer after the BLI has dropped the final
+ * BLI reference. See xfs_buf_item_unpin() for an explanation.
+ * If unpins race to drop the final BLI reference and only the
+ * BLI owns a reference to the buffer, then the loser of the race can have the
+ * buffer fgreed from under it (e.g. on shutdown). Taking a buffer reference per
+ * pin count ensures the life cycle of the buffer extends for as
+ * long as we hold the buffer pin reference in xfs_buf_item_unpin().
  */
 STATIC void
 xfs_buf_item_pin(
@@ -470,13 +478,30 @@ xfs_buf_item_pin(
 
 	trace_xfs_buf_item_pin(bip);
 
+	xfs_buf_hold(bip->bli_buf);
 	atomic_inc(&bip->bli_refcount);
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
 /*
- * This is called to unpin the buffer associated with the buf log item which
- * was previously pinned with a call to xfs_buf_item_pin().
+ * This is called to unpin the buffer associated with the buf log item which was
+ * previously pinned with a call to xfs_buf_item_pin().  We enter this function
+ * with a buffer pin count, a buffer reference and a BLI reference.
+ *
+ * We must drop the BLI reference before we unpin the buffer because the AIL
+ * doesn't acquire a BLI reference whenever it accesses it. Therefore if the
+ * refcount drops to zero, the bli could still be AIL resident and the buffer
+ * submitted for I/O at any point before we return. This can result in IO
+ * completion freeing the buffer while we are still trying to access it here.
+ * This race condition can also occur in shutdown situations where we abort and
+ * unpin buffers from contexts other that journal IO completion.
+ *
+ * Hence we have to hold a buffer reference per pin count to ensure that the
+ * buffer cannot be freed until we have finished processing the unpin operation.
+ * The reference is taken in xfs_buf_item_pin(), and we must hold it until we
+ * are done processing the buffer state. In the case of an abort (remove =
+ * true) then we re-use the current pin reference as the IO reference we hand
+ * off to IO failure handling.
  */
 STATIC void
 xfs_buf_item_unpin(
@@ -493,24 +518,18 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
-	/*
-	 * Drop the bli ref associated with the pin and grab the hold required
-	 * for the I/O simulation failure in the abort case. We have to do this
-	 * before the pin count drops because the AIL doesn't acquire a bli
-	 * reference. Therefore if the refcount drops to zero, the bli could
-	 * still be AIL resident and the buffer submitted for I/O (and freed on
-	 * completion) at any point before we return. This can be removed once
-	 * the AIL properly holds a reference on the bli.
-	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	if (freed && !stale && remove)
-		xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	 /* nothing to do but drop the pin count if the bli is active */
-	if (!freed)
+	/*
+	 * Nothing to do but drop the buffer pin reference if the BLI is
+	 * still active.
+	 */
+	if (!freed) {
+		xfs_buf_rele(bp);
 		return;
+	}
 
 	if (stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
@@ -522,6 +541,15 @@ xfs_buf_item_unpin(
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
+		/*
+		 * The buffer has been locked and referenced since it was marked
+		 * stale so we own both lock and reference exclusively here. We
+		 * do not need the pin reference any more, so drop it now so
+		 * that we only have one reference to drop once item completion
+		 * processing is complete.
+		 */
+		xfs_buf_rele(bp);
+
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
@@ -538,16 +566,30 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
-	} else if (remove) {
+		return;
+	}
+
+	if (remove) {
 		/*
-		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure. We acquired the hold for this case
-		 * before the buffer was unpinned.
+		 * We need to simulate an async IO failures here to ensure that
+		 * the correct error completion is run on this buffer. This
+		 * requires a reference to the buffer and for the buffer to be
+		 * locked. We can safely pass ownership of the pin reference to
+		 * the IO to ensure that nothing can free the buffer while we
+		 * wait for the lock and then run the IO failure completion.
 		 */
 		xfs_buf_lock(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
+		return;
 	}
+
+	/*
+	 * BLI has no more active references - it will be moved to the AIL to
+	 * manage the remaining BLI/buffer life cycle. There is nothing left for
+	 * us to do here so drop the pin reference to the buffer.
+	 */
+	xfs_buf_rele(bp);
 }
 
 STATIC uint
-- 
2.53.0

