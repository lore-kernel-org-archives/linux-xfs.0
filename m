Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171D23D667D;
	Tue, 13 Oct 2026 09:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884274; cv=fail; b=ujmVpkwfWVZocew0NlNyCop1jCMJihPcN2RvXk2jKTvp6vVKqffH3OizU3r6NoVg+mOwKw9IMV8ZrtlOh34RLmt8dKIInSJYTbhUQCSZzcnKv8H0DfGEUGCdvoIFxnngEmLalYJNCFVrL1XjFGSVWsp3lLs9wLPaxsq+BFzaFCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884274; c=relaxed/simple;
	bh=hTtpfE2QnYmScK7ZYfaGMNdjT4Un8xqLYA12Q8A9jwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oiIx5CTvA5vdXJi1mvgjFacI8S2mMVEDXVrQfiNQ3qnI23bxMwGXnclGnIfVNjvXiHxVdwJLBPwKfysM/oZ4tVjBFmfWFH+DBKYjc6CQEQASJnn0zQuoLewoDIFgSY8Aqx/xf+VBQg5hrGVOhL7EVnluUXGzcH65veqj6S9+YCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hpwPPprN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Fnuq5u/h; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hpwPPprN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Fnuq5u/h"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BrED3109983;
	Tue, 13 Oct 2026 09:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4a+bvJelLIOkxFLMe48NbI/pslV6ThdcbAIPLpwi8kY=; b=
	hpwPPprNRB2gow+p1BRXyHAt6kZAZBmvOHUcbocl+wmLUWHMfZUDWyejzE1EIRac
	iqHRV7tEC2lhD3fPti+MeDV6x/YcjyqkVb27Lx2/JTncmrPPJ1etfsl0TdZ5fK7A
	nbRaurInXh0Rji17gFLtNw0oSf4exfQryDh5O+Jlx+HyGKr5VzyyUOEq6++6OmH3
	AMeLI7vyrK9RzZh+wrqS/V8xkhmlDihWyQPDYEva4cnstGBpb6q8JdO7zXyUrVDu
	48ByTQnM5clWESft13QrVrj+HcAQ5fOUuFpjaitKOwh+ymwhtc6VB/A2JCIgY0/8
	rDojaunodoKLoxhjD2fJdA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7ddgkra8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:37:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aRQ5010788;
	Tue, 13 Oct 2026 09:37:44 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010031.outbound.protection.outlook.com [52.101.61.31])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d393-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:37:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CZAYvWhkU6Dvx70GyC66ExAAGBx1EkLMLNgaU+c0TolqmBvClUZx5jDJRxOv9RVKptovLW5rTsw3K9PHuGrJWOMXo2H4yJas3OEAhI2thfUNNWtv2MAVzUx2Dg0mSV8WkYdXPAurvyrhLn2+knqErVnoSYmzvo+tirUyyiH+yIuJdS1SegeTIPu0ZeEVquRyjA5XdMLSFy65FN8K+ow3olxGwsRZpabkBiRmb0L7VxP3QIHh9OjVWrWkJ3wd1FcfQRR0d8JniaWbzDtMS8nxyqCFvsXho/FITBOsZD9K9ygtPzLRJHaxUC8Ibx58UiAaLYcy8mezzFpdzL/eKmg1QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4a+bvJelLIOkxFLMe48NbI/pslV6ThdcbAIPLpwi8kY=;
 b=q5YeiCRhmz1Pe+fB0i7bJPZvtS0IbCmN7AkRHIjMwHrmIwEgFQdq9v9R6EDxWeWPjL2mhBZIvzINhB04NRvqi29JwxMjq1tDTT4BS+pbfCczBShqsD9arrcVkLYOiUdRT0IgV3IJd1OzT4ab9qKtrS2U/iQ6HSkAvGgmj/orzy0TWBtubzxY83rjuBw408MicSf9PXGk+63JDUaL/JurFKtkbT8TtfrIJiHWQdewN5SAEYxP1K3o1RDe3ibtZgfcf7HhKlFBMXwPMYUmDXElQks5M3ChdAE1UXlzHgcTNTFKGq4+GBEnD1jhAD7Gyfo2n/8fa9wI8jWxoJgVHq5UCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4a+bvJelLIOkxFLMe48NbI/pslV6ThdcbAIPLpwi8kY=;
 b=Fnuq5u/h6Z7Kr8/SMgAM3oSrbS0V07b4XU60BIeOplGdo8CwF+raHIUadmlpDmm9M8YO6xSTkgGcgciqSasxAwkbDMUsAV8EUoBmhZSDsxn9M8pfu5Vn1Ts6gPodCj9FC+MKLivWomLPKAQxgNw8U9q2Wl1jqCpBqj94QK55pyw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:37:40 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:37:40 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.12 v2 1/6] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Tue, 13 Oct 2026 15:07:24 +0530
Message-ID: <b374793f0f441fdf96bccd294c32c3d7351a9c16.1791883280.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883280.git.siddh.raman.pant@oracle.com>
References: <cover.1791883280.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0126.apcprd02.prod.outlook.com
 (2603:1096:4:188::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 8079dacf-d578-452e-d6fa-08df290d9fa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|3023799007|261009223027099003|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	D1mzs+jUQUE31ZvmFDbqJzqRyrF2RuTLHYrBalro8v6t+ig/tZB1jC+rcjyExgs1RjhjgY4JobaJJT4DLn+SCCw+JH+crTi0+KzbfhiINlSaN61AfFe4NxYUv6F+OoD4TXztEdKi/aIn76Gp/WUWFnV5356PrDcnNeG9MOIJkn2mGqhpjPOFWqvzzxV6Fgu+vWJFrJdYibD7O2j5MBCTUWL0z620YXhcb7XJcW2mxCIXC/5fMH24x+GWEUg+hdKE9hGaLbKtyMaBjLsYVvVx+2wXBsjCbXPLeeCWHdKLEygYckQmd/BNbmNiaOEdT71Q64Ug7V3HML2DiZam0+ZBOYrbuj3kvytT3rPC4Nf6nfk6H3YKEbTT7IYOOXtcHzbyk3f4LrZB9X+K11WXC4tpy11svTBqiz52qAyEokn6N1fntVK8SkPH91/cGbB2ld+9WPgFvumJOYyfy3XZh2kMZpkuKKjOCyrHqHHm/2Iq32mAL1cpiwC1cRuFGjzNykxcXOfEhjEu0TIxmbMjrDFu7k7c8TQz34pRERF86clhdVmvKUkzqWFGcxrmcDazJeW4kvLlA7c0IfqrVSu1iZ8P7qutvVi5fj8hvWsM3ZWWZuRQhWTI+TvS4cf0BbCA4+vcoTSketwlTHAEmm1rOPQSFDCVPPzg4h15mZ9RWsG4E1E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(3023799007)(261009223027099003)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yTzucRZnrPxbcGHInxooupd1q7/YGQ3Svi8OL68esWEndpaCyREj+8NCpcKO?=
 =?us-ascii?Q?QvC7VHrw5A587QburCaNJX/4KKCOQQ6sl1ubNf/xvOZvkvNXXaoxfrJlyhM0?=
 =?us-ascii?Q?Rlo0NgP8wirKx8FRXI2CoQtz/Vh+kZ3ICGN0QHRINI2R6oagJBM3HfUGM/x9?=
 =?us-ascii?Q?zLo2mI6DFEk4e3bvwgbpxEhzbYhWle/5C29hSTd4EwQv0xZa2oNJtn+RW0cj?=
 =?us-ascii?Q?tasrsgJIkYXS/XMw3u2OlL97j6V2L+brxGA4y6Ze8t88ChSY6GjZomm5NTju?=
 =?us-ascii?Q?5GMlR6MjXbNCHvjEA9X2e2IQg3lVwh4YyWdITlCAMNc1Xoqa0hRVljcHxnYG?=
 =?us-ascii?Q?XKaoNvbE24RnqexwQz87cuX0lfDCPgAmtE0b42ACLwD4ESXoTZrOZY9+DUVi?=
 =?us-ascii?Q?womYXy+nnFkHpHFDAOMQCUeKPLaEfMZRoAZ5SAuqAWZSfL7kvOPAB+nLVqTk?=
 =?us-ascii?Q?ys4juoA6QVei7J4yDNMdTL0aihPoK8o0Z5+Wt3lemhZ5+N084EJqe8wmug9H?=
 =?us-ascii?Q?w7GLS7wTfuWkjeSLg6Lj5E3L6A4bUYzGBg2v7ExmbOtQGF7w2QVQRSYp2Iqt?=
 =?us-ascii?Q?J86TABS6PMwxnYRBbRe9vOLqgamVU8i25u+fOm0l6yLqwJN/+OS1frujAvvu?=
 =?us-ascii?Q?9oC2sn1zoWRQ16Dry9SRyEh5d0ZOQQgB+Tlj6nJ5hnyJDGjCfg72B8T0Kp8b?=
 =?us-ascii?Q?zn3Tdt7Yk7puCDrmzATz05nP6vAqcN6ysNEu3b+f6vvqfApr/TgHsMyPc/U5?=
 =?us-ascii?Q?2PqV113UG1ueGGLzhWjBNe9hBHdw6ephyvD29THUZG+Sw/5fXgB6309HpDqN?=
 =?us-ascii?Q?xMy3Qs9m+W/+nqtecNq3FrZmMOKTMsZgri96FE2Kt/9V3cmSEz12YEupiavN?=
 =?us-ascii?Q?I7VDJz+ld6wtXordvVZEO/ZjzOhCbRukTjuxnbBbtva0NcVERPii3nnQsnkR?=
 =?us-ascii?Q?ZeKwbI+VSkdSmG/SJXwPPmKtR0UQR3qnsWVS7wNl4222nINuiQasIEha9gWK?=
 =?us-ascii?Q?lYvA1rbFZQ8l6wINX13PITpwvBEpOsvrhI+PiPjRssgzOpTpBmro47TVJUuu?=
 =?us-ascii?Q?aRAHS2LxzPOnw6T5TVg1ijhuDdnLFhA1Ah+SfLxyjCu8bOjIKwR1Ma1x62Jx?=
 =?us-ascii?Q?oYejzKBZ8T+FB23aT7nNoceNghwQ8pZrA0xqxOCkxC8FpdxHDU3A0C3fkw5J?=
 =?us-ascii?Q?sHvsLq52rYBwlTp70nysxA7MeJ5y+e40AlX0sQYiQ0UqJKiZt/4bg3v+rrWa?=
 =?us-ascii?Q?Znnshp46LdOkmyvIKXu5sU6imNQeRNj9veQE8IByA0eROa9udSjSUHtqB8nR?=
 =?us-ascii?Q?Y44VL3+ciCsAyMe6PTIaKchRurtdVSbsg91a5A7TsWdhg5K26Mlk06YCgNz2?=
 =?us-ascii?Q?zN9SIaQqiVBum3jiGE9nyVGe/XVpcN+rxi5YH97ZxGWgJPN0I+wYiZpL8Wzl?=
 =?us-ascii?Q?KIP1qlcoYkNqLCMNmPsj9xsb4/QHXemZ3QG4d+48A6d0VurhYcAoG8ws0DIV?=
 =?us-ascii?Q?ArNm9VN3O/N3O/h5Q/BeVMhp19sYHXcuaRcHHC0nDe3u+TkoDGlsSWKzDvxD?=
 =?us-ascii?Q?C7VGedNgCZUM3dJzxFXbPqcOckYeYauOmbSifKetFA3D9rpYWJCYvnUt7qdo?=
 =?us-ascii?Q?18vBM1NnQH9EVaj/1nXdf5CrfPvVEyVHWtoHJpD+TCeTtssWS1TpeR8JZFYZ?=
 =?us-ascii?Q?7XE39GHxa0UUPYeoDugWgv/6YS2NSOdq8GgZG6FDZ/VNzV5IB8Xz92WcJk4f?=
 =?us-ascii?Q?3bsknUE6DbkCIZtMcLN4tnCxo13vC3rg68ZG86RfaynnSX0i0bgCYZgO9d0E?=
X-MS-Exchange-AntiSpam-MessageData-1: g1ZY2BBk70zTWz7GbRId2JkZKDaFP2WlZxg=
X-Exchange-RoutingPolicyChecked:
	kWS/u4j1MVKWXydoZEHzhFJeJWbRZ9ofOh120N2eSQHt7gvqzSxZN4+fzSR/U2kTjOu7zsNdERPkAqjM6/OuBYtsbi6E59W13U4u9ebANNFOc7vGT/13mnNNQCm6UdDuP6Q9h7YSDVKYDTavDFtI0cv58HewJ1V4rbsz7k96NAxSdWg+2pJpwmNx0NHq9tHIxicSJFuZQTOII5Y2YGPPEcK/SGVIyAEHPHsmomMK8Udyvn0AZQWQVQaDXAYuoxzlAy5502Jz2+K5CYzxBVXWJiR2inrd9gmMCv1Pel8slWypw+pR3UleKNQFU+I6nO5d0htQOb1OUP/kexPzgulI/w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gac96F7MTizaGenu/kaZ3DSMv7UydNk+CXxmQyauIkipNhV2mjWIYaAazjX2HgaXalsqm4LETJDLfPIAPpN40jPxPy87h8O8gPF+w+O0huwtfeoI6Uc7tlI5fjxz/nkqdYB9eZWJmlpVGUgjTntwGZl68nzINhrWLhUqtKN7+T21HQ0MM75SE97wTX3TAkB3WZR3v+Lh8wv9+iM9T7VB+oQ5QFNQy+qnZjyK90shypTkljRnh4jfiSXce+D6d4COhsSSXKqHIOb/J2szNUfH/r1yv1JYjKzeLdTHXB5unJR0Jars8zbktunl/8O89pP7d3t0HxPmZ/DsMgl1fDEyfq0LHFDSrrpgmmn7UggRfRZKbiL9DuYKJAEygPHUzOmdXfHEGHebAQS9s2/T5XbFZWS0sS1oMeqJVdg7PUGJfU5SdBoy0Tk/bZVB+Gsz1+mmCBVsVwl/qSPKsad4sxncdahda4Yov8PYSveqJI898gHv2LQFCBeUIirHKW2nfGkDB7q3OJfA4QQ5x3OZYSCECSgXlGbkd3cwyXObVHO8bsVjhj6civThQw5YVyDGFi2VmbntH7fu83lCeiEJ2Dee+bo0V1YhhCKDNfdNHP9fyIc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8079dacf-d578-452e-d6fa-08df290d9fa8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:37:40.3098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gl2VIzAn/YfSGj+Uapqtofq7i21mQ1mA6z8KYhKjr4BOQTtCLx7cvlznG78Y60FZllzD7qS7bo2/6m3KuALurHIDg74czNYdprn1JfqCjgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6acdfbe9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: JpDyeHilUZPRAi17YIZy4nb7A0NnhGsf
X-Proofpoint-GUID: JpDyeHilUZPRAi17YIZy4nb7A0NnhGsf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX+2tozVlESy/V
 GRglRpDR/kErjhmKKD0C0CLv0zxSjMthyZoIQC/2gEEtJyhbIwaydTPGniuHJuWrg7FoA92tKEo
 NVIuYEN3FX2v4K2xL3hkQxzun1ZwD1fXN0DAFZTsDCGU/31YFmGG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX/AT71mxd5Vin
 d9aWZCz3EZUZqmfDwwCPe69DGIWwYstA8LLuJWA8Ka8ER7h39HQu0Wk5x58eCUUOvncNV5xSnOV
 Id4VFjicFW90zuIOhNVYvBrQ8P74fhD7RpyAokBNcvoFlUp4dNWq7A7sggyhqZMXd4Cii56sOND
 7Rc9YdpGNAKNeP5rGXDfHvk0OYIebX0FFn/6w/R3kKJD9X13s0UgcCuOjHOKa2K5sUOp2ahb7mH
 IZ/lQicUP9QKaOWs5+eOxe9hjyXsgAVqVE+7VMkC0jtmPawTAE0rDDIjo4S/+H6ZhTM+J96OLF1
 sdRZ3jlZE9ciliq/sdgj7jH814tzt/JxuLvfXq2Y6KkbEGK+tod0emPouU8C61cgwnIlhoKKgXv
 OCEAIp7jhyMfGMQoPDEQewDmtyWHnpy4tqybjUKf4n3u/JWtyKHOCwarcaWjIOU/JA+SL7R8cRT
 l+7grnnnhNI1Es0D8Xw==

From: Dave Chinner <dchinner@redhat.com>

Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
-> IFLUSHING, except for the last inode in the cluster that is
triggering the free. In that case, the lock order is ILOCK ->
cluster buffer -> IFLUSHING.

xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
so this can safely run concurrently with xfs_ifree_cluster().

xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
cannot race with xfs_ifree_cluster() so being in a different order
will not trigger a deadlock.

xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
this deadlocks against xfs_ifree_cluster() like so:

 sysrq: Show Blocked State
 task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
 Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x8b/0x180
  schedule_timeout_uninterruptible+0x1e/0x30
  xfs_ifree+0x326/0x730
  xfs_inactive_ifree+0xcb/0x230
  xfs_inactive+0x2c8/0x380
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x31/0x180
  __down_common+0xbe/0x1f0
  __down+0x1d/0x30
  down+0x48/0x50
  xfs_buf_lock+0x3d/0xe0
  xfs_iflush_shutdown_abort+0x51/0x1e0
  xfs_icwalk_ag+0x386/0x690
  xfs_reclaim_inodes_nr+0x114/0x160
  xfs_fs_free_cached_objects+0x19/0x20
  super_cache_scan+0x17b/0x1a0
  do_shrink_slab+0x180/0x350
  shrink_slab+0xf8/0x430
  drop_slab+0x97/0xf0
  drop_caches_sysctl_handler+0x59/0xc0
  proc_sys_call_handler+0x189/0x280
  proc_sys_write+0x13/0x20
  vfs_write+0x33d/0x3f0
  ksys_write+0x7c/0xf0
  __x64_sys_write+0x1b/0x30
  x64_sys_call+0x271d/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
and XFS_IFLUSHING are serialised through to journal IO completion
by the cluster buffer lock being held.

There's quite a few asserts in the code that check that XFS_ISTALE
does not occur out of sync with buffer locking (e.g. in
xfs_iflush_cluster). There's also a dependency on the inode log item
being removed from the buffer before XFS_IFLUSHING is cleared, also
with asserts that trigger on this.

Further, we don't have a requirement for the inode to be locked when
completing or aborting inode flushing because all the inode state
updates are serialised by holding the cluster buffer lock across the
IO to completion.

We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
skip the inode, because there is no guarantee that the inode will be
reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
whether reclaim is preparing to free that inode. Similarly, we can't
check for IFLUSHING before locking the inode because that would
result in dirty inodes not being marked with ISTALE in the event of
racing with XFS_IRECLAIM.

Hence we have to address this issue from the xfs_reclaim_inode()
side. It is clear that we cannot hold the inode locked here when
calling xfs_iflush_shutdown_abort() because it is the inode->buffer
lock order that causes the deadlock against xfs_ifree_cluster().

Hence we need to drop the ILOCK before aborting the inode in the
shutdown case. Once we've aborted the inode, we can grab the ILOCK
again and then immediately reclaim it as it is now guaranteed to be
clean.

Note that dropping the ILOCK in xfs_reclaim_inode() means that it
can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
this state. This is safe because we have left the XFS_IFLUSHING flag
on the inode and so xfs_ifree_mark_inode_stale() will simply set
XFS_ISTALE and move to the next inode. An ASSERT check in this path
needs to be tweaked to take into account this new shutdown
interaction.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 09234a632be42573d9743ac5ff6773622d233ad0)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c | 8 ++++++++
 fs/xfs/xfs_inode.c  | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 08689839dd77..e22d103f5f82 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -923,7 +923,15 @@ xfs_reclaim_inode(
 	 */
 	if (xlog_is_shutdown(ip->i_mount->m_log)) {
 		xfs_iunpin_wait(ip);
+		/*
+		 * Avoid a ABBA deadlock on the inode cluster buffer vs
+		 * concurrent xfs_ifree_cluster() trying to mark the inode
+		 * stale. We don't need the inode locked to run the flush abort
+		 * code, but the flush abort needs to lock the cluster buffer.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_iflush_shutdown_abort(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 266fcc789098..3b487341348a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1624,7 +1624,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.53.0

