Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9C528DD0;
	Wed, 14 May 2025 00:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747182574; cv=fail; b=thjRiy68KOTxZsVevfVNhaywqyWudymAUNrkLCliyc88yn5wEsUPTaXr1hQY/b8ooG12B+4eXNnPyw49QM1/IJvl3kCK8b79oqlBzq2PeWQvAq3bEFEHtzIwJMxAXxAfiJuKSQdnJccGmT4scWYr4H9vovCrCk51+CNBhx3bjzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747182574; c=relaxed/simple;
	bh=JiuhrVL5Jlm3Aw/juMboVzIcI7Zm32/erd88vafptTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZSIB6KObyD82+3UFOscrjLLyWIe9iW1QC3lHbktYw8m39AxIykBICSgKE1ZZNPIKTRHUYmQhUwJJwHzj83UzeWmZv6wGz2kSSwOqmi/nnXKgjt63TStXB1BCefwp+QAgSNoGi2Dax+KfxBYEclhDIRpk+/Kn6jDJTNpyE6hJ2B0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VCs/97Zm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tafeFlP/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VCs/97Zm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tafeFlP/"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DL0lpC020849;
	Wed, 14 May 2025 00:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=T9P6r/hXj3bIHGbTKpZTrUeM7UxDd4XHirF7+sAbu+M=; b=
	VCs/97ZmYdQFSirw1H3TETslg9eqmVYZduZNJH0sJqZEg360gVQFsBWR8Hcdr9yr
	4Fz10/rwx32g+WnKboExEI0vEd6PxhrbCAhY/CyQJlV7FEwFDa+H0uukqXoud4c1
	CIjVEtDqxvMEHVTcq+WeT84eo5vudXWJOXrLaJ27H3zaPlljUeqA7+Ew2HzMlVyU
	s9FDEcxYK3bLC6DMZoyJIucNrIyeC8pPmE+EXb/AqW+eBboZT2oDJUhpZCcRZ8Hv
	Q/8AO+AHxXa+kWpQz4ItH/srDjZtfvMfHK07RU8lPH8XwyEpsNlwAaWfm30PQi55
	9uzpry8+f2z/AdiMHhW/pQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcrggbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54DNfhwp016728;
	Wed, 14 May 2025 00:29:28 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011030.outbound.protection.outlook.com [40.93.13.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mc32s80n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YfH0Qbn/TL3xKbPg7XdonhkdZgjf8cnlDDQ+UwUUfOBjwhkIMLM5/5m/qpb+tyjkgJ5r0YZjzLL6Xppw7DyuvZN9bvF8BP/mcOwPO8R28k1+neBnL2fJc3t9BeNq611z+/9PjZtf/c+al9wJyRlK7edXr9ddnUAhyW39Lq6Dlo5ssnvV3gYNUrMMwLuPfEa1hMEPpmZ1szA2Dx+ecVl0YallI5MvdmgPA44c45vpIaQRc6PanK7C+z07q6ExGF33HVMuiTfJN0x4dWiLMlEMLiRxbvGGuMBOY/dzwK0ejeuUTiAxpm4vb7pqDBKT5jC46ycRrMGPedf6fhxk5DMJ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9P6r/hXj3bIHGbTKpZTrUeM7UxDd4XHirF7+sAbu+M=;
 b=FaNeK4YS3yXFkh3Ohn+aazVspZ5+k/ghthFLa2v9JEsrlefUJVKiidNVAuWjH/Wr/hRS3JlVjHFcXg3M3OheysiQ1xQjBVvQlKW07KOY3HrWnH0Vmh4qcVDD9dEBMqf1rer5AftZ0hXNm6k+4NG8FYbF+jHyOKLcxqc7Ze8mqz1cWOCWjVnh7p2y22XeNgaEZvxYCD4AiVuftrZUNO/wC/Ks6ob196HI6nsdp3I4tjRoorDA+4W1ofZSyPBZBjp3x6m0w4N+fOOpSozT5VfXIXpgHjUIyqY6Wnv9BEKQjHdiUsOQnu6ke9xDFXpXTzHlNnoKw3NKiFY23zaf1xpidw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9P6r/hXj3bIHGbTKpZTrUeM7UxDd4XHirF7+sAbu+M=;
 b=tafeFlP/stoTPQzDzD0tbGzzWhWSD6vq7onXdeSxy6IZFWde1RyQJyaLSTbNrwHPCUqcd4MxdNQVJuqn2DNq96r0YTyHtiBUIFtws9ZScZhzLhosn4PTV+LSbKdl19uR/rQAef7muiaoqmwCo4DlqAPrRmGCbre2gkIK8Em4H2s=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 00:29:26 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 00:29:26 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: [PATCH 5/6] common/atomicwrites: fix _require_scratch_write_atomic
Date: Tue, 13 May 2025 17:29:14 -0700
Message-Id: <20250514002915.13794-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250514002915.13794-1-catherine.hoang@oracle.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0376.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::21) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB5204:EE_
X-MS-Office365-Filtering-Correlation-Id: 74bbcc87-f16b-4d35-fd6a-08dd927e61d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aMQ8TSvHBpGRSMzOHtMQeT8BoqjOStmXSBzGBcQTI+84mNRoRRJ0zqvojJeq?=
 =?us-ascii?Q?JXfo6bXEfHpDualIrMH7gbYCrZGMDX/txh329m2v3YmJZUi30ptp94ZXZNX1?=
 =?us-ascii?Q?JTC7iSHHCrXb3UTslabePm4b364gsGCcG6I5OM6fWQqWZoP0iv7OPtM8lCrT?=
 =?us-ascii?Q?zkKra3aPDjifGry4dtEy5H/QwROgaAnBFh3ctAX2WEjPxYXxiL02uzkbzxjO?=
 =?us-ascii?Q?nR767c0WlpffufwH/kC0mdajs/ucH+BkPzFG4eO5VFDcKJF5AG7zkcUipK4M?=
 =?us-ascii?Q?w3gPMW/PtClr8biKA0N+Y7et/Q80vt8uGHp1/LjE3EKwkqdiq+A7DUtazqMn?=
 =?us-ascii?Q?9VpX/lSNW/nA3S0DqkTU/OxuV+eXmLgPAMsDYtlE3DUw8Yny8fqbAYXtC9PO?=
 =?us-ascii?Q?dSGQKeXdioemFVqk3IoK28sHPjRRLZnc0upjCBHmRAmamnDxQROklwjc1XjO?=
 =?us-ascii?Q?2VGHeDbGUTiELYS6vDWo5gUTdyZU2PMRIM1W+EvUun785NoAhAhkjShmnI6T?=
 =?us-ascii?Q?Cub9MOZ4Gayf3GeqnZAR68r9dj/+T436WpeQb0iWU3wdnJs9fY8jt537QalA?=
 =?us-ascii?Q?ZjPSpOiw+ka3aDdhEIo4iYdH/1vre4iiBBUVu4pcVNCW87ghUo92dY4adYAI?=
 =?us-ascii?Q?DBj1Jzk0rvMsfpzh+GQSOQeAjKpuA/Z0zRnPdwvgGyP2c7hkuCKMC8G7oJzn?=
 =?us-ascii?Q?mnO126FRLW9+GhxVPXyBR8eGnJ5so7auniDbsj3CN7naFtH0xFZaAQ/eJoZf?=
 =?us-ascii?Q?WnxMCoq6J7IR/ckrRGIVkXKkGiGzrxBcBtbgonG30mZym0zexr0xW7w1KgM7?=
 =?us-ascii?Q?HNRz4hLHa4gvUElYVRUVYXSpYWdhFkf7g1mIXySbXFvh2M4BUZLCeqiDhnCM?=
 =?us-ascii?Q?5D0EJXeBgCUhwByrp6p66slMhk20lC07OrDL9L7Yt5u3MVGlHPcUQb7q7FNK?=
 =?us-ascii?Q?NPo1HQKX55yY/XbXA/JivIdkPogq6NIPit+sjVD1R6Ilk8PCSew3jQfL0BOM?=
 =?us-ascii?Q?fSEMg9d56Yu4JYam9URVlMOGE3ZAwVO5/OaFq7lMv2y/j50BqcASD4vIkdYq?=
 =?us-ascii?Q?L7ikq7aWCZgU1iybniAOoziqne3R8YF5kIjY3YF0oufugCUGx23CB69OBQeD?=
 =?us-ascii?Q?VZTlHvIPesujOl64/WhEa2AJN1jAmmJjzHpzbwbU4ylUhB76WjCoNm57S8Cm?=
 =?us-ascii?Q?/ql36wdcjCKGAJqdyYqYV8DCg39+yqXQzrzG9uS+2x6bQjxvQzPxebKJm375?=
 =?us-ascii?Q?ym3TkaxFWUFezOuiY3pzxnJFPMiBxl2c5sHDHPrENJVwGUvNc7Ma+goXa7vQ?=
 =?us-ascii?Q?yGNR6v7qAhk4dgNH51S9kC1cVKfjVhLFEgAUfR3QEb4tKbq+RUPi+EFYg8D9?=
 =?us-ascii?Q?CTl8vWOU/3CttkUfc1J8mv0D75mkrQ6K9JylqwaqFHhfhxHp3jUKXU8sX+kc?=
 =?us-ascii?Q?hWTO1RZu+14=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Aeb/7Yov/7U3OgBuSeM3EfoT+CVcJYwIZxw2l+ZYEiPOHfzXiiq71DuLAoQ4?=
 =?us-ascii?Q?hlrfjnDhERcQs4FqltIfhduFKxN95Or9EG8TMZTOfwC8kxchzHpt1ajkh9Ls?=
 =?us-ascii?Q?wJp+V/5tjL1y504ZgM3q0Eu3ggUmNbaxnhZJ1prpq/0s3Au4Ybt12r1KtHPy?=
 =?us-ascii?Q?YwlkPi0FmD+GwJlEjsFGXsXxhBRtBFIhhq3isCRgO5PGvdZ2CjuN3QvLMLGH?=
 =?us-ascii?Q?GvfDe3RMaiOKa2WzaqsXavonmMW+Ga4oRc9i8EQlwAMVF752MQWiqZ6ljaNF?=
 =?us-ascii?Q?0bqlW6Ypti/SpTsrKQfqHxOk4zkXF/juLSQixqaKtVIFCybji7ccbUfQ0XZT?=
 =?us-ascii?Q?3OMZC/ASM36Xm27zypV7o0vJgR2XyXjC00NyzOqXBxIWKFnPwjFdmVEzzkLw?=
 =?us-ascii?Q?5e/TgS843TREomWCwpraLmPEBa0ySLBygkN/u4Yr8MmbCABlLM0fCsB3ccog?=
 =?us-ascii?Q?kPW4UwMz+ZE0y7Woz60m77xfCm9uUSvmdQdKFqMxiN6RJ5rY4WGRNT7So6dy?=
 =?us-ascii?Q?MNC8E1BmJbvnSgkItsz1hQuV6TWp5bPL3edk0pA0rv1g4DZC3/vK2sC3wWPh?=
 =?us-ascii?Q?qTQLEtgl96+GP1CsjDasxJ4LGfYwbxDLpdCQy5Kpr/9ioP4GH9HPmqgNvdB+?=
 =?us-ascii?Q?ioxvFU0oya6CtwUdUrspPIH/yOQRAVf7i+QT9mzV66UNd7YRONirxNF15By/?=
 =?us-ascii?Q?O748P+lX0m/NtGIhNZSqopxYhzx+gCl2hyP5ETqcH3Tsh10keC5gu/8iKij9?=
 =?us-ascii?Q?yXGsoTj4MxLRRXF+fXG54D5W3xalPU7PDCS0OOF1dV3kLeFajUOwmDzrk6z5?=
 =?us-ascii?Q?SkeBJb1AVu5jTOM/lAAocVc7xFzTIyU6188M+DT6uIzGgSyyDd7WwdiXR8vx?=
 =?us-ascii?Q?ei8kzzYCDr2A8ExE+guh8dkPVY1wA500kCx3CxVHnMb4J02H0PRKRt3UqATS?=
 =?us-ascii?Q?fUtk3Pxw1UNQptlxqoNwnVFO+yXk1OGhvEjBjYJZsEYHcPHiOtKtrcYXMC4L?=
 =?us-ascii?Q?A6HIZ8aQZDlZd3lLBALh2Q5rvV6Q6K3zbtUBKYPGbXoTk33T8NYH/Q8ez2T8?=
 =?us-ascii?Q?8/opUFG+/TMKbG1SdSmAaSqUQiMjGcbvVctuljFmZyNX+TeNHZ36DaMjns3g?=
 =?us-ascii?Q?0fJQFEWTD+PH32qoTz5arK6fgidOctTJt84qwr0UTigXV3/nSGCuvt4jUr4e?=
 =?us-ascii?Q?s1sjYMdZtbsHb8jLFaCj4LUhqiOAUy8th4cTzxeLI9REv8EIGWgQp4frannP?=
 =?us-ascii?Q?YeyT0cvqNEi3rr4sCDhX5fPV04P7IqOLRMN7iUO26Tj7Xd11Jcc7FnKDJvPw?=
 =?us-ascii?Q?iJ4r/+E6pZPHa8lK9lyvS2oh7LdhjLqG/QNxtGSJYl/uKY+Fnq6o70mhtMfU?=
 =?us-ascii?Q?AUpUfAFLxfP+1pKznuwSRm8RppyCr4T1UIKA7yYbH7kRkvh8kDJQEr4GbQPZ?=
 =?us-ascii?Q?vPMrG1Cx+zb5Xeo/N4LozcOE1PCt1nUBVY1vC0HSE+s9tcFUbsV1OHcHH8ct?=
 =?us-ascii?Q?TUL5E8MT4F2bjqjQ8sRl3imCgVqhEAp3yG11+HIKREKu3Z3Zv62TD7HLNU0c?=
 =?us-ascii?Q?8CrAiw5m73GHEeveG97qKtUUX3FzIsIJQcbynHGXHkWOhNb//2w6F5zmDtND?=
 =?us-ascii?Q?jNk/Gy7Se7/fu8jiM1jZ9nPOeph0j6qYd2oJa34lZqDesNuajzk4eRuqwADa?=
 =?us-ascii?Q?7rBMkw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z26d8EvGSCnm/yCqbBt9OCe2GnHxIrQpHwzec4+/GfPUpUBHPJlbsBosgacV4d3M1rYOTJlBni+OxtAUj5QQnSnClb3F85LSSQ31Pw/k2ALcI7Meqa2bCsibMhObXggYL72R+6TlinYIfq4DVA0fVltefTEfkL48DgtmojH8sZjsN4rRtgYIBBOLYBknxhsOQySeFjBne8ZsZ1WfjB2vAe4v5pifSiNFPz/gEiAQr1nE++4JK+v3BNNMq3t22Ymn3cC1B2+g7w9u71iM6NbQwU5GtaY3fAsvUEI00khDPAwz2lD3S7Td9PkJY5XDx55vavWnt3lJKhRlvelIyWw+Fv+Z0tSdBAVUOZ/txrt030lgdlkD2qCSrt8pyNa6u6OmTPTSNmEHV2WqbnbDySLMjR8MOVxWRCw0GzcDuCACEREcHmXX4XGsV/ttcw2PE2A20cb8R9JP/OlwzetdJyxyhBQXkJGf36jytk8vrcdTjiTyzah92NkUxIj3c6QtOI7IRufvi9e34A2TU384B6QV3xWRQPqoMerRbAlbUCn1bnFfLGqSxRNxOtfiV+H564Cf9yym37vAIl7u4dpyAH9VjCL/wDor9qjY5qAbPJyqrvg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74bbcc87-f16b-4d35-fd6a-08dd927e61d8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 00:29:26.3328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7zQC3MLPf9Daxoay1EybMI2i3bOxRFsX4Kdi56XcagqviTFbyhe2ZoOwSqtuw6PlzNZhkxx3X41ZSf5oGZedFl1/v79GnCURwdGal6KlJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-13_03,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140002
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDAwMiBTYWx0ZWRfXzap0+uWva0DK LtHKfobgTZhAhtjzSf6K4omhdaJ1P6ZOit0NufqtfRcFrtuPAIVlphecVvsvkARKo3yzhSbPzkN Ei2yE89W4RSPqiJ/KF/pISGqfmN7maXilRGllbrbqAEja31Itpkm0P6AT/GFvdThbXdcKGYM3fj
 wtPPmdj3J3LQMW8q3R/8KbU9Ua09IEXMXNZroqSgh1KMQKG9laCe7RmCcRumS6uNTeSujIpJ80P gbWwfs2fzMZuYRjxa3xX+UrGFl+FgMjIsWOgY4jv1OajmSYoo0YZxc3NtudzWsaDsTmrsBaI2lO ikOSWsxxlDwtrYC0PAzJdHuRsETT+H5B5yOtTpVkOe5yDFKoBUwmYD70TNAPd0yVkWNPwx2xtEk
 Z0baIPOpQHTsqlpeo6UcxXmA4oPknCRDnMwwXNdtOqZQqEYtxw3llUeUqV+wYXay3ETr72LD
X-Proofpoint-GUID: fdMpizNMcQWvcChjTF664-S4RskmjtQM
X-Proofpoint-ORIG-GUID: fdMpizNMcQWvcChjTF664-S4RskmjtQM
X-Authority-Analysis: v=2.4 cv=cuWbk04i c=1 sm=1 tr=0 ts=6823e3e9 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=OygJN1ASYlhPINJ5Z90A:9 cc=ntf awl=host:13186

From: "Darrick J. Wong" <djwong@kernel.org>

Fix this function to call _notrun whenever something fails.  If we can't
figure out the atomic write geometry, then we haven't satisfied the
preconditions for the test.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/atomicwrites | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/common/atomicwrites b/common/atomicwrites
index 9ec1ca68..391bb6f6 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -28,21 +28,23 @@ _require_scratch_write_atomic()
 {
 	_require_scratch
 
-	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
-	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+	local awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+	local awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
 
 	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
 		_notrun "write atomic not supported by this block device"
 	fi
 
-	_scratch_mkfs > /dev/null 2>&1
-	_scratch_mount
+	_scratch_mkfs > /dev/null 2>&1 || \
+		_notrun "cannot format scratch device for atomic write checks"
+	_try_scratch_mount || \
+		_notrun "cannot mount scratch device for atomic write checks"
 
-	testfile=$SCRATCH_MNT/testfile
+	local testfile=$SCRATCH_MNT/testfile
 	touch $testfile
 
-	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
-	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+	local awu_min_fs=$(_get_atomic_write_unit_min $testfile)
+	local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
 
 	_scratch_unmount
 
-- 
2.34.1

