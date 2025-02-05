Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61372213245;
	Wed,  5 Feb 2025 03:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724904; cv=fail; b=dTFNbcfmijIacO+aApYi3flV5TA6ECZ5UGlNy37GvLieww37M8rKGb0b/+5f5IikDjJAqvTqS1kK04vhajvJYAp8AieT6bHVrX6mJ1cyaManQ5dcSwezjnj44+ItTrS+Wg4GloeaKb9OHmWbPC6Je5WwimWZmrKjkQ0o9+3p4WE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724904; c=relaxed/simple;
	bh=juzJzx6FGgNWimQZ1X+Uojy03Kqy01wun26d2NtPUcg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jJ0ez80GDLg5TVkvY1IqUn2jr/jDoGPKavDBsXJmwMY9FaJGMslTVB7nEFqGTR3XRNvAdQwNWqe/q4TQ4Ctj59xwwEbhu+lrERxIGIFbtOXNYeoa6MWt9CGOWjv3UYMrkA+Ye20ffC23iG6eHjiljOJ50Q/2TFz2k/5K9Dbp7rQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BgICDsly; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PldIv2ba; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BgICDsly";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PldIv2ba"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBpTh002665;
	Wed, 5 Feb 2025 03:08:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=3rdqTxKmyke1i1qfYR3oSUneOBEzVMkaxe2mwGQrZy8=; b=
	BgICDslyIj4TtOZnUEy4kUPOMKAGOGh7N24sHEMR+HD7qT/Apf3urn2Wci+waXZr
	isopMt7+/WrJAVTghzAdN6/SQx6pKHTNXCHLPrQ8upzrEILZ3TaZBP5mDHQlNxw0
	wonH5vIRAbD3tKZ6s1xNoTrnaeGAEdh0RJO1vXx4tgRNKLWWKT+3R7c6TQUv5Xap
	QhZc+MZAwAHUntkn33m7dhjA7PWFTwRveIKUxiEaDto2tBrFXiCj2YP3vQ19qKRw
	Vzed7ZiRaBBdMlQFXDxCdk6OCn+XQmFpvHIConnMvUR9wXl9MoUi5HL9+jVSwoiO
	g841iFmmZD/Rs8pk8HVyQA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy863jb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5150f9uu036378;
	Wed, 5 Feb 2025 03:08:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fn1p6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a1qWm3TXs0+grBwD4NCN5BuK3qxzN9x3MP4Igs+zhmQyMOzCNd0os91Rz0AeVFTizfYYUlKav8OdM6bQ3G4rxN4aGV8IzUTAGPdDtjm4EFRpQzZxL5Ji3ojiBfUUJjbp5ttIBItHMjqvA3EKjdzGEBPv2FYf8vx0XnLKIVvQU6iearubYQ3nyYgKtxdak/+7lJvKt50FZjS8b6Bi/LffQ1+4GTUWwGW/UAc47chDNvukdc8Ii6GgrRy0Bh2/yU7crB7PHNrORCudyZHujBHHwBKc3Tmd37jXSYvbb7QlTzHuo1ZVlOHlHANabwcIm7NP4s6knq5WZrQks6y4P8iHDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rdqTxKmyke1i1qfYR3oSUneOBEzVMkaxe2mwGQrZy8=;
 b=GSZ8v8DRyWoLH1T1AF354BBVZGWxHy/AwiR4keyRh04jiHVrROxp1G4hJyQ1z0ZWbvYarqg4oED6dBjKaUThw+tnVWytYBVj9kabJzejk4GiX5Y2yKYczKGPmSTdiVayUQaRGVrblIlFbOG1emRKZoDPfcj79yWtfV4DbaN4SAtT6UoM81T/5j/JFtDsmtuz727cbmcgIfZLzxIWatkBkvVTG/GTvHzfmLyr39NRL7k1AtJV9k4d0OPBsxS2FG6Wsghna+ozVZIwd5rjZQN2dPpus5E1dYFvE+n9WpXnyE/dNK/+aXkS91GJ4jXkslRsV501wq9cCKTXP3JRZHlp6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rdqTxKmyke1i1qfYR3oSUneOBEzVMkaxe2mwGQrZy8=;
 b=PldIv2baCfMtAyXpFcETkvhgU0MFT64uD3A+adHhdeMxlaxIv0dmiED2bec2885166LfGsaxjqR8RNhdx+wQFLqPt67C5bMMqyLBGwruKcPwQNFnDBs50XiIzfDfJuWgLZfLwpfYQufXvkQ4eajkc8Ju6nZO8i47B1fX3CySRFs=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:45 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:45 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 06/24] xfs: don't free cowblocks from under dirty pagecache on unshare
Date: Tue,  4 Feb 2025 19:07:14 -0800
Message-Id: <20250205030732.29546-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:a03:333::7) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c0acd30-b9eb-4ab5-fcc4-08dd45924366
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jVNH5SMuwaUJu1IuEFPjUADmQgg6ZVYeXnh1mYqa1KaN5LXe5hK/SprbH1kR?=
 =?us-ascii?Q?sVTo8Zmn9OYFWxqC1/s1E9hW/hERW6sUtGzsqiaFEjrgR2ahruQZS8duAXgQ?=
 =?us-ascii?Q?YpAzMF8E7VUN+UXn4CHhU0uDhu9WoPsdPpPALdrGPN7aHcsZcNI8g0v7RBud?=
 =?us-ascii?Q?SpqrzXQ+1nb9KmZxlOJYOiRDKqCgTJSS9Jx6OZTyF+ERDrgXfLM/O8RMotav?=
 =?us-ascii?Q?41qZhxo38cIAP3zAMXaLvx0a1w+/BpQ4oVfLrN9SyTfqS6e3lpHLXyI389KD?=
 =?us-ascii?Q?/fnpMuiDoIhFc4MzXXqn8bz2/iG767xmGpCYCO149GYXnPsL9pt5iuRh8e6C?=
 =?us-ascii?Q?UT5JDXXaypVpjVK1zlUUQC4LpEKkVIpHjd2yh8fQ2UXHWxxnrARi2JIK9aM5?=
 =?us-ascii?Q?Lua1Ju71VW4+wtygCUNW1b3v+STWGsQqTarLpzAoODNhPMVDuYsm9gJ4CeeH?=
 =?us-ascii?Q?x+PLqtA90J/HaoKg7Y3qepOf8hI2HEZeBrjhvY33WW5DqYj4FUj7WYBg5TjK?=
 =?us-ascii?Q?94CMXe0+r/QhsosH41s3oAxyfK4HY8W1tI/imsYpMxOD7voOgRzQQ+apmGLz?=
 =?us-ascii?Q?qEdLTudj0mu9gKcExuD9t6C+DqNZzmqiZp9BWTob9DE1BNXFR3+Muu0w718y?=
 =?us-ascii?Q?CtdMysBvZWHSwElwagtKOptdSuk4T+hZpjyKVcMsVvIgN4TxNYX4Sv1CqG77?=
 =?us-ascii?Q?5Z2Jsj6JgN9ViIC4Wp0Fd9uuOPnXb45z+4MSoXzkAv1ZXzDaYV4W4q8vjpjX?=
 =?us-ascii?Q?iUnz8ggJTW6qJKlv/OXoFerwhVM0dDKCVAilmXJIE4yVDM3Mkhg88rLSbJhk?=
 =?us-ascii?Q?AtJ3OzoUP4F+lg5EXSPTpNdGmtnWSfs/OixASdUifOaDkrfoTL+qcqdIKK+Y?=
 =?us-ascii?Q?0QeofqDX5GlTsOWXUykvaqur0t8JfVR+osx4YSa1UUaozTTy9NvAVzFGTBiL?=
 =?us-ascii?Q?CeAFq97INC7Ya8fCIJJYA4NrwQojpzdLRm/TVWF8OQExUcHuE6hHAelZWYkW?=
 =?us-ascii?Q?yc4eOnsH49g6uPgz5gVskdKD+AWT88rJRFOnFKRQ+vPJwMwCgFgB0vdHKPqt?=
 =?us-ascii?Q?xcFVM+Av/1cGHhm1LFXWAKDEYZRQSFT7lOzXehLtg+LIqXyoIW3RGcXj1Jsh?=
 =?us-ascii?Q?SdLMQbZx0MnhgWPTUBEoGnpUZE0ElUV2vazEZgg6vmGHLQXYZEQM6nqzvh/P?=
 =?us-ascii?Q?ICNJwqDrmklXrXNTYroeVpoadNiqb9HK7s9nSX8j+WE0eFk3jCse+iRXBb01?=
 =?us-ascii?Q?u/nwo1UjN6b6MIGkIfRXzGxku0eP0xrzVwMcJldi6irwWXWxhK4lA7pqKHPk?=
 =?us-ascii?Q?N/SX3ObLFDEFILGB8G9qwkJBOmBxxhiXnUwcvtQwMeXtnfSTZjt7rhhyxyFO?=
 =?us-ascii?Q?i0GPl0TqOtq49Mc5j5fi/Q6/KrH+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6TnC+l+M7GC4rriRoAWSruOlw3/oLXXwXi3OdZlgErMZnm0BgEUOxye88Tz6?=
 =?us-ascii?Q?g5BkrSo/fU5QK/ES/dfUDWgaB1qlicH1Fyv79fRF3Jt+RN1g0wwEhlUqTudI?=
 =?us-ascii?Q?8a+3IcK1Wq/1lGpEwF6aEmcBYqm/Uxb3KP3xS936K517ypgIT7Ky3APF2f3F?=
 =?us-ascii?Q?xXuKzOebUIZCY7NnnUkBKT63Cy+HGK+GwGxltW4n+lRFyS+gopCvZkwwWAyv?=
 =?us-ascii?Q?/nACn/VefykN21zi11TFis0QRkHJKQMhgPkfi0C6+6LDIhCEsoANYebQhoZD?=
 =?us-ascii?Q?85ZPC5THTXcjAK8TAZdjyjD6jhbCQaREUgE0KMC+wswQ0+M3Dg/PIJ+MKoti?=
 =?us-ascii?Q?YV8YeULE4OFAVOj1tCYc6/NfdgmWgebaKqe34SQBCP4SBl5Vobxok2JZGjcv?=
 =?us-ascii?Q?D6w1mukJQDD0cRmCkQLnFMXprNHeYNdpUfbVvkoTN/iXOdDHETYVk3b1ZvFp?=
 =?us-ascii?Q?M7YzKLhJn8NwEsrNDllGo/NvDXgO/8ILdQLuqSpFLwMnatNA2awntBWOAWLy?=
 =?us-ascii?Q?8SJOoudKGJUGzxpfGE3Xx4ngNrPZRa+k2yucbBEb08nCTIBxEAbtsFqlF4zx?=
 =?us-ascii?Q?st0idtC/5Ru/djKd2PJm2LK6WWd812T5JU/IC17HjAWfxlIFq+oo7DUnrDw0?=
 =?us-ascii?Q?+0fJW0VOojET5Vc3UJyg42WVa0THBMRgqXQVim93Dh+g+f407B6rb4jEOaHG?=
 =?us-ascii?Q?Ka0NMykwuSLViI2XbtSS8I6yWCtjN2osR838xkRmREqNM2vBH2hq+TXpC96Z?=
 =?us-ascii?Q?JePyjQUI2PIYgu7XLWhPmWy2h9XE59XmlcHP57LQ2iuIF50MOcAL/7HjzgOz?=
 =?us-ascii?Q?mGJ8xXBHNdYZTbdO1q0iwDAifZjY81B+TV336l+1YymST8so57U5spm2moGT?=
 =?us-ascii?Q?XVG3jm0wo66TBVa88+HQgDJGfVKK4bgn8wkzBXh6QbnrY318DeNQRb13ueuI?=
 =?us-ascii?Q?JGZxYvkxvIFnFXfAlijajMDJhTUzuq5MO6QzIVZjelOuP3ptS/dTBluBtCgG?=
 =?us-ascii?Q?vnzSwugOE3ZvpoZ3VzKycyxkjYE598g0OoiJMG3uWY9Tb3fksqsSmKBpNyVS?=
 =?us-ascii?Q?8OM+jG/wbelhGYp6gpso5vJCIhqPQBd+77YGPfpxwopaCd9lykxQgkdLRDSg?=
 =?us-ascii?Q?b6uSqxvj4VWvp5NDRmR0MlR9jjxcWLRHBZzQ/c2UCdv69am01eQFX4EzeAIq?=
 =?us-ascii?Q?oisDcC/cVndOToLhX5GMqGPy7TC5nvP0Vwj5GajZW/x4DIV6HvDv+tvAnItd?=
 =?us-ascii?Q?ow8mV3quIYB+hapz3Q5An6WqSwMR8K6oG1spAqRWdTwWGjCLedMJyLKMpt+a?=
 =?us-ascii?Q?2P/PJFsnA8W/UDxjhh3s4yvxjLC6iON4fOessaPDq7AxqPt/VurVWZSD9RPs?=
 =?us-ascii?Q?x4c8YE0xBnq6tXx0DBL79NMpn6ZD/Q2PbOHeNiwQhB35fCsPeME5RrLkLvL0?=
 =?us-ascii?Q?z09PN+r0+a8xj0a1P3dvs4tSymLXx/kVagBSXciV1xW+wkhA+k4fpHtQRtdR?=
 =?us-ascii?Q?gZs4oMTv4xP9+2CPir8KXdg+4aR5YI32a7Nk4AbvIj0PFzVOqPPoRmCEgNf6?=
 =?us-ascii?Q?x5W3+UwAbcSAIc9WGvtYSY71y+RBUM2xi7ZhIWnQ3y4k9q3Fo8gIPPejaZBv?=
 =?us-ascii?Q?/PXQT3EnX8MFptDIPfARsPfqMPbO+UbPRIYzhzkoPSRuJ91dJWWUoTKuiNv0?=
 =?us-ascii?Q?UEMlCw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HLQFqaPiexj2Q63GVxWILliowy8vAi/cRlb1XFQotcPlbi77x+GlL2QF8GC9Xw5FjlQsPjd83wcIKdHg0/SabbiFWiTcwETZqgni7xQuyJoFwWCBobrhAYp5ESRcCM8786jmzFI2tCLI3jqY5LWf8FlJtA5Yy/1XkGcSdxa0/DN3B7UCbJOkKR9pYzygQLNWZdB8rr3oF+b3uyNd5Z0KN8scEwPfvXotS3FNamaLUJNKCd257Ef4+Nf/q48EzkzxeEnHHcV9w93dCiRWG14SksXVsluG1IkjT9apR/IR2CWsWqvr185p58K6lyYiCNXrqRFg3C2NVn5PxAQ0ey0anxaODBLgE+b5iNaa8mo/ZGqWjnoUKNfk6EbL9mi+1hQopMEalbdzoM46/bNHblKSpvEvjsgp4pBdr+RiejBoPliJrmhATFK/H1/F6TL4tZ0bGar/ZWi8O/cnjl0aQkUJ2M59st5Q2JRS6I6XRRm21npW7WtxRetIjgUbAh1rQdcz5IPrMLrO6QIxGgRgnTbs5PUIIuoncACES2QpTSENfg0WpODbMfXWGyPr0yS+FUauYYWWvc5gyf8cYDGboBeAUDx8Wv4iWNS1KUp2xgY26Rg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c0acd30-b9eb-4ab5-fcc4-08dd45924366
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:45.6039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l7WfpYeG0DSgC2SNtSEpmloFCUg2rdgpeNlgu/QZCgJeRao+wkC1e/72NG5+REFDUnrC0tTklLFFuM0lIVY2Jd7SgpSeTnJVm+vT7GVUaeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: 9zmIqXkF-z7BWoVmjwWxDyQslaBGj23U
X-Proofpoint-ORIG-GUID: 9zmIqXkF-z7BWoVmjwWxDyQslaBGj23U

From: Brian Foster <bfoster@redhat.com>

commit 4390f019ad7866c3791c3d768d2ff185d89e8ebe upstream.

fallocate unshare mode explicitly breaks extent sharing. When a
command completes, it checks the data fork for any remaining shared
extents to determine whether the reflink inode flag and COW fork
preallocation can be removed. This logic doesn't consider in-core
pagecache and I/O state, however, which means we can unsafely remove
COW fork blocks that are still needed under certain conditions.

For example, consider the following command sequence:

xfs_io -fc "pwrite 0 1k" -c "reflink <file> 0 256k 1k" \
	-c "pwrite 0 32k" -c "funshare 0 1k" <file>

This allocates a data block at offset 0, shares it, and then
overwrites it with a larger buffered write. The overwrite triggers
COW fork preallocation, 32 blocks by default, which maps the entire
32k write to delalloc in the COW fork. All but the shared block at
offset 0 remains hole mapped in the data fork. The unshare command
redirties and flushes the folio at offset 0, removing the only
shared extent from the inode. Since the inode no longer maps shared
extents, unshare purges the COW fork before the remaining 28k may
have written back.

This leaves dirty pagecache backed by holes, which writeback quietly
skips, thus leaving clean, non-zeroed pagecache over holes in the
file. To verify, fiemap shows holes in the first 32k of the file and
reads return different data across a remount:

$ xfs_io -c "fiemap -v" <file>
<file>:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   ...
   1: [8..511]:        hole               504
   ...
$ xfs_io -c "pread -v 4k 8" <file>
00001000:  cd cd cd cd cd cd cd cd  ........
$ umount <mnt>; mount <dev> <mnt>
$ xfs_io -c "pread -v 4k 8" <file>
00001000:  00 00 00 00 00 00 00 00  ........

To avoid this problem, make unshare follow the same rules used for
background cowblock scanning and never purge the COW fork for inodes
with dirty pagecache or in-flight I/O.

Fixes: 46afb0628b86347 ("xfs: only flush the unshared range in xfs_reflink_unshare")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_icache.c  |  8 +-------
 fs/xfs/xfs_reflink.c |  3 +++
 fs/xfs/xfs_reflink.h | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 63304154006d..c54a7c60e063 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1271,13 +1271,7 @@ xfs_prep_free_cowblocks(
 	 */
 	if (!sync && inode_is_open_for_write(VFS_I(ip)))
 		return false;
-	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
-	    atomic_read(&VFS_I(ip)->i_dio_count))
-		return false;
-
-	return true;
+	return xfs_can_free_cowblocks(ip);
 }
 
 /*
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3431d0d8b6f3..4058cf361d21 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1600,6 +1600,9 @@ xfs_reflink_clear_inode_flag(
 
 	ASSERT(xfs_is_reflink_inode(ip));
 
+	if (!xfs_can_free_cowblocks(ip))
+		return 0;
+
 	error = xfs_reflink_inode_has_shared_extents(*tpp, ip, &needs_flag);
 	if (error || needs_flag)
 		return error;
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 65c5dfe17ecf..67a335b247b1 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -16,6 +16,25 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
 	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
 }
 
+/*
+ * Check whether it is safe to free COW fork blocks from an inode. It is unsafe
+ * to do so when an inode has dirty cache or I/O in-flight, even if no shared
+ * extents exist in the data fork, because outstanding I/O may target blocks
+ * that were speculatively allocated to the COW fork.
+ */
+static inline bool
+xfs_can_free_cowblocks(struct xfs_inode *ip)
+{
+	struct inode *inode = VFS_I(ip);
+
+	if ((inode->i_state & I_DIRTY_PAGES) ||
+	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
+	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
+	    atomic_read(&inode->i_dio_count))
+		return false;
+	return true;
+}
+
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
-- 
2.39.3

