Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87661D173F
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890908; cv=fail; b=cs8bL2WMly1JF+akpcRLNKnVjbSEQ1ibsjVx2Wf/yHEYe4Tk7EfahsfdT0F5/1AH0kicn8WYK9HF1qTrdv6B5WXiM0eAvhTGHvcOThxIFYtwO1v68exztPWSrsbZQxmeS98nE+laIaNx3h4Sgx8N5VciHpGV6652k+kBqDhiYNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890908; c=relaxed/simple;
	bh=M6DL+ZjWoqKVdhXdC1VMwi4eKdfrkr92ytMtejOkJsA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hP4t6ZMHYpxjRzrMs5pufWyev/Iongf7ZEmSFwBFbUcV5Q/+SEkSMpuWR1QUUwaW7UBD62Cv7KqPLYToCbxQJC7wGrwIs8N1mjfrPpR29veEMzqrC452HAP6q/XLk0KtScKnnt/gCNMHfHz0kyq1yXA1oLkE/5mv7LGGUd/FN9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Zg1BzJ5y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C7Uy1B96; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zg1BzJ5y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C7Uy1B96"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfZSN025427
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=Uatsv3U4h//Lyr+45u5swhKlWe9gpm4sjgpRpFqXsrg=; b=
	Zg1BzJ5yGfz/e1XOWyRubhqDb8/YIDD6v4LyFm9WWZgKKKRqf0O6aGzIkR8b5NVL
	o5qsXu9NqHQikBptIAdW0regvCv/QXxbuWG7lDu4YedcafKzt3iA/r2Nfe6IetZ3
	2Q1z0nti4miJbabrDN0jRWGGdseQvN7fRSoniy8+VJ0y+R+ucB73qA7XaxKoXWhb
	Ak28SI9bEQoGjELgscpr/65KFpVam5lRe3YygoevqmtxX85x/LyrODx60S57CkSN
	e/7kgSc4XP+Pm0sG1CsV4IIUeeRFjfbtomV5ZtQGnmq8IHYQqb4W5hcGmUi0gW0i
	Y7QDHlWsnG4psRe0TRA0PA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9dt2cdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492GiOUO039265
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:45 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x88978a3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s2mlto5/SCp2uUb3eByAYXQZ1VcCi1vTM6LgiEtO2jQaPF7eojIFw31MMjPALsprVuZsBrQYik+FmIUSfKFIHPTfYMpSJt5/wjNT0VVEpRLkYyCVGJfaqBS/3NwQs7NFl27EtwpYwxEiO2AzXfABraTJc1yAGrdMEHBUtlvPAeFyRzvhGUJ1ebthoAwnADazN2iaEoav0pocyNwlZGB/ihRVROcZcv7sxqk5Mj5fzLRjBgUZVL/I/cTB/QJGy6HY7KX8CJBJJohb0lBo/tymKphZbeEYSxx86d4+dCV8OzUsrbBvVRkbFuLFP1wS0we521RfYStTE6HsBRfLkdUIkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uatsv3U4h//Lyr+45u5swhKlWe9gpm4sjgpRpFqXsrg=;
 b=Yi+fBervZglCNn2C93AM6EDYPzNiYg6gRC46lvS4kyh3Yv7F5gk+7qiZMeyb1VSa2tH4oWL1LdfBz6YBySIqnjpTibY34d8D+mULWaWaKGgs3iFRXEYuH8b8jObvY3p3NlAGxKf4P3u/BEwBvFL94dUeLVja3pvqJp/pn3pPn5ZwizCGLgO+jW4dfOWUUCe9nQFoV8OpMSQ6KA8GRcCuNuiy/Kq9ErEHyJQFccqX81Fw9/Y2jTH7BYRNzQBmewscJHCeBH7HFaSEgt6BfxGYdpES8UwujiSLuI1EejgJ5LZeEkVx1mDOW6WWfI8m0pA4gH+JbURL1NTG7azKe1Sa8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uatsv3U4h//Lyr+45u5swhKlWe9gpm4sjgpRpFqXsrg=;
 b=C7Uy1B96ffeHlCpkt3JJvFEXO2s+0/8Nl+ZiYFDBAx42y/3E40SI9yp6h2vd10dADP9S4MgQgcygv9c737lT9uZUAm10lYv+PgRRt/Prd+mx/+w79wfhwl41s1Ar6Vn467IcnHzDQqQZYN/ry88BeP+Vnl+Ugc9Hz5YEtR9+CEU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:43 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:43 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 17/21] xfs: make sure sb_fdblocks is non-negative
Date: Wed,  2 Oct 2024 10:41:04 -0700
Message-Id: <20241002174108.64615-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 79cdebc5-21cf-468f-c537-08dce3097a9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7ugEKrqTLWyTFsHJCMofuiDYc+cZBHgqMja9O3n/reDQUqGD+xzIn3R2frUf?=
 =?us-ascii?Q?95LUHTuIjpItWGqXejp2kiHCuuvqh08ZiGC7aV4shyXPheZVbVT6FvOSH7j/?=
 =?us-ascii?Q?hxteMs4/FquTjc+cWuq3HdXeiFNhc8QaMeMI/BY1Mku2FiKI4fs3vPGAqysG?=
 =?us-ascii?Q?sklKVi0mtSda1A5HlahyEgLh2NQc/ybJiAIR2i1jIfGdJ6BSiUopZ0rrsIz+?=
 =?us-ascii?Q?NG9WJNeC49IfWtTByo0Mna8jSmC6o/bXXLyGN78/PF4iiVbP2aQd2e5uOVJU?=
 =?us-ascii?Q?5YUuzMkl/Ztga6CFwrHfySAnunodclDaURatA1GMkrZgMNBijuAUUVuP3MoK?=
 =?us-ascii?Q?NpvRh6vDvK3CGdfeFkxVAZzZPPH8pnSyrTC2g33GVen8aHCFEPUOtv+E70nd?=
 =?us-ascii?Q?QDtlrK2M1xhz19GzD80OSky6l8zini6Gbncomk/YnZ7Fx/e6asiwgbLaVNYI?=
 =?us-ascii?Q?g1j5EFiG1TgpEJiz6ULLZcEuP9cCSJB/i9PQ9QnIncLL44YmfdiydMNi1AqS?=
 =?us-ascii?Q?APOGQq6a74wZ5UIScNuWg2Tw3cgo6vlswzBkFqO+xddO2zPoLpwoO9wcQg1O?=
 =?us-ascii?Q?UdS7VcJJfMshIoe1xZmn2hu1SlYQbNC/RwJjcqT7XZzMumjomdPnwX2/faiE?=
 =?us-ascii?Q?5HTaNbNw0qGOw6oSB+8i0Llvmvt61ezI/TJahgCLWxgrOKO0ICn6SvC6jp6r?=
 =?us-ascii?Q?3qD6b0Av7zsvtOApYGAlwZY4OKm3C3Q9JXpUYiWF9iK5YuhjEJMHaanDYaLY?=
 =?us-ascii?Q?yDY9OYAwUV7NLTYEKsACa/GS+pq6EcaPAe2eXwA1wTNF0qPhioUSvfJ7WUJg?=
 =?us-ascii?Q?hEJsata1qupj86cedVYL9QgwgH9uz9SdQCjU9qd9EKLLqO7TH6AOnTPycMeV?=
 =?us-ascii?Q?c6jrxTIu0S0oDiYvl0ny/8NMvbKumGmpJFlBse6FH6fiBm0Tk/n3irW05cx4?=
 =?us-ascii?Q?SIiTPM9MwTB7DgQSEbv56ddt0m8IcWv+PWeCaHf52OMZ+x+Fk+9YBNpw4wkW?=
 =?us-ascii?Q?NRUep0vG/DUpbOJgEzM4Guxf3mzZaNS74dxwZ9oQeLAnfpohVQv/bgDWCcs0?=
 =?us-ascii?Q?iqsHP1bFc+gH3eXRFyCU6UgWkcQFPFOURtCUQEADu1JnGfIT6EWNtINiufOv?=
 =?us-ascii?Q?AnSqj2TFC8Z6qxnTqPwi5EKYbGwLU32MizA0r1f6NiPK9qWX1pLCFgPH5TYk?=
 =?us-ascii?Q?e8TNpt9YWmkoHsBn0gFdKSg6aXdbJ2SzGtoNf5AkmWDiRd2nm8hHEudxFpoH?=
 =?us-ascii?Q?vqTRqv/tGqbLpjdkBCOpcQfsAjXl+KEx4UJm/Kjw0Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y3yRxT1i1CMmmFaw4jxOKuMg53UNWgmFVJzuzp4UoKhZ9wgBdAXv5uI+0skh?=
 =?us-ascii?Q?NC8vdHmTIRwESXNyMcLoJ4fYa9K9AtstwH2f8sIJnMN+cbRoA+s7MHyvEk6r?=
 =?us-ascii?Q?Q5NPNgUQsWxK2EF2IRGcH9mywCSkLpXv9gTWU4P+p6/IGljdzz1q3stv5Six?=
 =?us-ascii?Q?38LhgNW7Vqrr2NMin9AGnlDPr6sFtQ1DMbvZ9tRZj6OKsqxx2WBapEWOTSUq?=
 =?us-ascii?Q?lsGhSgyP91MzZN5OO4VNaFZzHT7bat/bDn/r+pFzfmtg3UBCp7h+v7ZANUQf?=
 =?us-ascii?Q?jIY7rEEuW4ruhlsKBYnMc29uTiWYKnPLj8kO2t7kyzHvZzWZIlK/Mnk2dL61?=
 =?us-ascii?Q?BlDhHYEmo4zZNu+Nq1ULamJp5V9Bx/7BHLecuK7RyG+Ybo8rQPWSBVynTp66?=
 =?us-ascii?Q?kuCVprhOh0BJezouFPPqHH2Bo94nAVfT5sbBh34LKM35Sv5RUmVKoJ3AqcpS?=
 =?us-ascii?Q?5JhWU7Vkkz/vy+oSqLeChmOJpxOYH9q+PGq5etA3QXI6fV4oCdUsgiEo/7XR?=
 =?us-ascii?Q?F+5Kg1q7ohrksbP4OphszMUGykUYfwLqunDuU4c9Hb+YvWYoLZBfSLBFJg01?=
 =?us-ascii?Q?C9zxYfAhUlwx91bubxRRNDrX2dNyhG4o1y0jkjqfmBG4ZhmFMqFXo0kf7/iM?=
 =?us-ascii?Q?hnB20l1Hr6DEBZqoqJdyaS0cemnjQFpfedMGO0KZZFvBExrXhe4FwrQaArmK?=
 =?us-ascii?Q?D+rD786swXbEQY6S+jNjZKFxQ47q+R1Qi9xCzim6W4jcFbuA9brx5EkxqkFJ?=
 =?us-ascii?Q?DRcCX42iRC+rUHLWf3eaIegpnq6gnS3pkVtNmAldamUjLpp875bdFst1npnD?=
 =?us-ascii?Q?HNqyNdEbQgXBscWX9Kpa+ow96UIGGgV5M1jekf2ln66Zh37lflQ03/Hf9CwM?=
 =?us-ascii?Q?b/cl7ygIejkO1NHipLBiRtKlp6RYWR7FmV8UhJu3jGF4oOkReZc5Sv+A8Off?=
 =?us-ascii?Q?FCALLOYv1KdaJ1WjyJUOUH8yTp0dw7wC34VCpKDRSOIQxNDMQrK9NQCuZHho?=
 =?us-ascii?Q?oU+R2eOhjH5LI8txkMHGo3xugjB4u3OASJLPNcOtWEtlECUwgHWeC9JdMVel?=
 =?us-ascii?Q?IgWAwhlSqmY7s/nR0p96P+PtX4KPsUPWmsgcdkIKiVvya/kqFza4zrnIsL8z?=
 =?us-ascii?Q?zozj5i8rFod7wqrWl1jLrFv+vTYpJTmFsX8gIJubDVH8ShgEahqsUIKRyl4h?=
 =?us-ascii?Q?w8W0YX66Hy1VeDePQAh7nvJ6/DuWqjE+Th2lhMRcZgChjmsbbVbBV2mVdQHN?=
 =?us-ascii?Q?xzsGrDT4NY3eTQRFryRsZI9smkrPeYaRRCDIQJrz9N9J+0dTlOUca+qO/cXo?=
 =?us-ascii?Q?XXBN7Pu/gyECjcJ6IM+Xij1yH5SXHl8F+5aLRprxzmg1ww1WfXSNZWRIsF5A?=
 =?us-ascii?Q?RvTZY2b6ya8LgPzSw3/OxJuaaxhRVD6/ZZ7w6CVGc9LUJC/IXMOf0nq0L0Al?=
 =?us-ascii?Q?RqguoxP8lxktutBaFkMM08K76T5bxxIFts/sbi/QwGfdcZC2jbs3W/eR5Ihn?=
 =?us-ascii?Q?LLpfeObLiUsMBLXftE6dIO5wvGssb0ymokx9U/nYCRX47WvMQECDh7P25+gf?=
 =?us-ascii?Q?VPDoCt0XghgSWIQ7j3XYg13uw62F0rd9MBEHA96C0axE4LpQled5DdiLr8w/?=
 =?us-ascii?Q?QwIG21SdnJTKO5AP+ufEdFIeEuz3ySbtJimiXmpQob0rJgi51RHSqexsyj2L?=
 =?us-ascii?Q?MfhjEw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L3uOaCtvIlpPYuYdZV+UAiH8JgSMN1nAFPlmVE6dJn7hNo5PJlC1RTyPTy0uDbdKrF1vrUhVHNQ0qyEusxXa7Sd5mEaQYv8S2WYfnYISpR0SQVYVBjH9nlKjZvsjThkNyf9IbUX1RIXODK2b7OKwvyuORGQE/5QlscTN//fnqPinhOJLA/ER9zBDql1ZcATpB5fi5N2J3PtgjdDnuCe1+vID2egFpXKWqVRjDMvtTRn0D5zDLuStb6siNI3c12s2hrtmxf6uR+NeeqMXwRwPrfA2EL+OX2iMnjk9GIR43woGpaXGBNPaYvQMdRKDJf1b/zrs3OyP6GcQkWU2CamnMykBrgNfG8xJu7ykICpf+zk1qMtnv3yDzgvgnRnpRlEiM44J/AJ/IarHEpZLuq8MJ1OF55FVp/zS5gquBxRBo3w1ywouHvkM/rzInooW6/nvjSrR0+MwAoXohRnc4Ub4MS4AcRhHJgD1WdT2aHOsOQyzF7K17f8usOlXLg6FpsOUVKtjgYzuEQYx4gceRj/5t58G8VcTjnhOg7TFb5zihrJdAmXSNB5+Xzqyo9Y7TNe4hHWNH8CGi1XpyJr0d4tu5Dh20hTkCOCVndwhJn95zAI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79cdebc5-21cf-468f-c537-08dce3097a9a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:43.1554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N97QEGuwFElpfhuieGY3UyX1igajKg+pCOU8hB33QSBQBfnNpeMnXK5mb84c4+Q/E9ZfpCDT0agVnYeVaheTsF0aOZoTwR8FmAvYMfv7Jj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_18,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: pIqsECmZr3QxTXiaXq4DOv_yukSx6cUj
X-Proofpoint-ORIG-GUID: pIqsECmZr3QxTXiaXq4DOv_yukSx6cUj

From: Wengang Wang <wen.gang.wang@oracle.com>

commit 58f880711f2ba53fd5e959875aff5b3bf6d5c32e upstream.

A user with a completely full filesystem experienced an unexpected
shutdown when the filesystem tried to write the superblock during
runtime.
kernel shows the following dmesg:

[    8.176281] XFS (dm-4): Metadata corruption detected at xfs_sb_write_verify+0x60/0x120 [xfs], xfs_sb block 0x0
[    8.177417] XFS (dm-4): Unmount and run xfs_repair
[    8.178016] XFS (dm-4): First 128 bytes of corrupted metadata buffer:
[    8.178703] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 01 90 00 00  XFSB............
[    8.179487] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    8.180312] 00000020: cf 12 dc 89 ca 26 45 29 92 e6 e3 8d 3b b8 a2 c3  .....&E)....;...
[    8.181150] 00000030: 00 00 00 00 01 00 00 06 00 00 00 00 00 00 00 80  ................
[    8.182003] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[    8.182004] 00000050: 00 00 00 01 00 64 00 00 00 00 00 04 00 00 00 00  .....d..........
[    8.182004] 00000060: 00 00 64 00 b4 a5 02 00 02 00 00 08 00 00 00 00  ..d.............
[    8.182005] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 17 00 00 19  ................
[    8.182008] XFS (dm-4): Corruption of in-memory data detected.  Shutting down filesystem
[    8.182010] XFS (dm-4): Please unmount the filesystem and rectify the problem(s)

When xfs_log_sb writes super block to disk, b_fdblocks is fetched from
m_fdblocks without any lock. As m_fdblocks can experience a positive ->
negative -> positive changing when the FS reaches fullness (see
xfs_mod_fdblocks). So there is a chance that sb_fdblocks is negative, and
because sb_fdblocks is type of unsigned long long, it reads super big.
And sb_fdblocks being bigger than sb_dblocks is a problem during log
recovery, xfs_validate_sb_write() complains.

Fix:
As sb_fdblocks will be re-calculated during mount when lazysbcount is
enabled, We just need to make xfs_validate_sb_write() happy -- make sure
sb_fdblocks is not nenative. This patch also takes care of other percpu
counters in xfs_log_sb.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 59c4804e4d79..424acdd4b0fc 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1031,11 +1031,12 @@ xfs_log_sb(
 	 * and hence we don't need have to update it here.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
-		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		mp->m_sb.sb_icount = percpu_counter_sum_positive(&mp->m_icount);
 		mp->m_sb.sb_ifree = min_t(uint64_t,
-				percpu_counter_sum(&mp->m_ifree),
+				percpu_counter_sum_positive(&mp->m_ifree),
 				mp->m_sb.sb_icount);
-		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+		mp->m_sb.sb_fdblocks =
+				percpu_counter_sum_positive(&mp->m_fdblocks);
 	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
-- 
2.39.3

