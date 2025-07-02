Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F423816C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Jul 2025 08:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751444637; cv=fail; b=VfDsNxdjGS3Wi8sHOgv0gyjhthW0y2KYAz9m8AhuF/pXY0nhtUcrYrI+6vx8H3bQAh6Vqk/KSnH1Oi0I8aHKxFG9bmrfWkG4R+DhLo4HcJn/tgSdILFcf5Vdknq1Ml2ppchDAMd4eeUlFAc+wWDO6KbDtO9mu5BnHZziDyo4Wuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751444637; c=relaxed/simple;
	bh=LAjzTmCjEyZtRdR5mUgioAuMP751dKML0azQJw6a4Mk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MOq7C91tMFW3wUZGzS9r3sE9I0DXjoTm72+EIxfRTDhTPaD4EGwGxM2RKxpRv3p6MvE1bMOK1prXWgsxdM5weUWaFBkm+vhyMHEk4KJS54GoFmwFhjy4yiNjKBbCDqFsnwC7oHHwcdH656sP/RCdSWIPw/Suv+sopaKvZsN6C3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nXyeUZoC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x11N5jnv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nXyeUZoC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x11N5jnv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5627MbKp026042;
	Wed, 2 Jul 2025 08:23:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Gholw5/HfDywzSzvTyWtPLo1zk9WBl7Y4MprdR8eLDY=; b=
	nXyeUZoCIRDNKIAp0hVksDzdLcb5GoaPttNOhVuf54BH/ZhJf8JyOp6OptOtG6pm
	GuDeXZ+eCgNAKCpGbnhGi5U0ERwsiUQjL/uU5KN879vQF4kWSX4KL+z3lgpVwhEa
	OPcGf2rbKrqs/6pRsGwaPDC3DpgOz1by5JzIa6ZugYSSJo6s/SbWX9vgmRrlfOSD
	+rZUFZvPikd03lliwwXQNjmQmexF8uLKJh5yRi/7nF9pplvNqPX1zEo0T4Mcekun
	nMFUCQSxoOJRK6BsaWyrrw9nn8iW43lnYfaV5Fky4ImAIGsLt0XPjCxCaZ0/ONw9
	CXTKJXDFa90RRVJxZIcJOA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47jum7wnyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 08:23:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5628KOLI030179;
	Wed, 2 Jul 2025 08:23:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47j6uaxk8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 08:23:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fXDTQb1OdDq587OFZD70Z5oFs8vJjWRfZQo5Rh1tUDppyHzD+Cp2gje3ddjVNaODNlWYgtZ6kBybu4q5QmrMIbJkFHa9o0hKIWnOf9RW7XiGw34gkZCppnQTsTqZX8dZl74fZPd6FafUzFxvFs90blN/z8z4mGyczOV6fqH5BiKhX+xFBfdnW8XpXXa4NBMMo/YxIIpbz7sgG1SYCt7AqTY8Hu1i1ti6Vf5xUTKoaPN1x2B79n1Ao3D03eYN2lmZ7QZj6Q5yAl6/8Qq+UYbzPQw6GdWA7lIT1ayht2Liyme5O41qcJ638a5v9XzSitxyg1mrsmaQba4p5QTzi02D8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gholw5/HfDywzSzvTyWtPLo1zk9WBl7Y4MprdR8eLDY=;
 b=T552kAqC1qFEIJ2jlMs6AYl8827O+iaZ9ALtEOZv3ulu3IU+3/usTeV8lqhe4MxpZeun3ap7oyfAiNshgmRTwtoccUhZAg8/Zr+vto9vEtdzo9ZCZZ1yBlCJyKanxCxRl168rEaJ8DGEfYmTDifVR1kfIvA1vIIvquhZP7Mprq7uXfbdcRVj5ag+o99BfnULpvyGjBY/IZNWBv04WJOqj94Em6G+GBpCNnFdrVruxWthz5AydJs5SO201AAMhyV6NLTfsuc8zvktzpdS1oKMOWfDbrka1CzYsbPYDnVfg0KRyw3icfgwyyOoAE0ONW8hQLhHaOWYmW3R2QfAlAD/dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gholw5/HfDywzSzvTyWtPLo1zk9WBl7Y4MprdR8eLDY=;
 b=x11N5jnvt3RTyvMUE/pNqdkS+lJar69tE0zojQmcgcrQlvwN2DGXyiPicNYZFE/Kz6IuPVKn+reLtFOjTXTKEgMHn60al3wVLt5dsBsNlBAuyf2KPS3NsU46BLHSUA8Iq8IGg885yfjw196/VYN9fJLvs8Pvpzryl2YA4SL3kRY=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM4PR10MB7428.namprd10.prod.outlook.com (2603:10b6:8:190::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 08:23:30 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Wed, 2 Jul 2025
 08:23:30 +0000
Message-ID: <9cfbbe25-6679-48b4-92de-0c2893fd7bb7@oracle.com>
Date: Wed, 2 Jul 2025 09:23:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] xfs_io: dump new atomic_write_unit_max_opt statx
 field
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303893.916168.16245124372956701031.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175139303893.916168.16245124372956701031.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0028.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM4PR10MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 497c333e-6e96-4204-3487-08ddb941ba0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFNnclFBY2pkWVhKSzJiREtDMHlKRnY0UmZJbHg1WVpZWTF4RVFhb0htK1Bt?=
 =?utf-8?B?L3dXd0oxNkt3QW4yRFI3WFhuVmdEekUyRUNQZTM2VDdWbFVleFpNOVpITmUz?=
 =?utf-8?B?NjRSQTUybjN4QXkzNWd4N2lPRFVOc21WVlM1OVc2QVplekFVWncvWDdPZ2Rw?=
 =?utf-8?B?U2cvMHlJUEZsYkp0WUdWUWJLdlF3Uy81OG9JdVpyWHozcGNXeXpvbnhEc3pE?=
 =?utf-8?B?c1AwYWdTaUxndjNaenducTdQbklGOUUxUXc3TFBrMHk4ZTh5dFV3QUdvdUto?=
 =?utf-8?B?Q2tUb21xVGJyL21ESS90ei9lZHUxR0pyTTRWb09HOUMyYStjeHhacUNrTi96?=
 =?utf-8?B?YldRS2g1SnhtNUZIK2V4aGRLd283Y3p1engrci9NQmdxS3pWaHV2aURhNjFz?=
 =?utf-8?B?SmdyZGdKWGFyeWZ6RFcwYTBta2U0UEZQL1NvRVAreUVKd2RFK2NuZWZYU3VQ?=
 =?utf-8?B?bFlXOGwyeEQ2emVWT2VCdUJnN25iaHJRVWxvQkhXQVBOa3UwdW9wQjZuYTE4?=
 =?utf-8?B?MlFobk9kREdUcUg4Tis4ZGxTN2JZWFR2dEVWWmJyVWJRakt6dFd3bkhYemxm?=
 =?utf-8?B?OHRhREZRRFhXa0pIa1UwNEFZaElMRXBOQlM0emo4VlB5RnRsQ0wzNGszNG1j?=
 =?utf-8?B?RXdiTXJ1MFZRZE5EdHdrTHBnQURZdnpyUEtSVlBNWUpEVEFYMnQxS0VXcGxS?=
 =?utf-8?B?OE0wa0pNdE1jd1VsK29YamNrazV5eG93MWlUM0FveUJ3cUFXS3FaOGxiRzZY?=
 =?utf-8?B?dm1JZnJDcjFOdkZTZml1L0ZyMGMwVG1PaGx0Tk9aanFuRUc2N0xFWWFxbk4r?=
 =?utf-8?B?WWtFRFk1ZGZhMDBoRFNRenNtY201VXJlRGJXS0Q4enM0dlpwOEE3WnlsRi85?=
 =?utf-8?B?bjBBOGY2eXFYNjdVK2xhV0E0NTlOanRneVE3U2lpcktnM20raktOakZnbGdm?=
 =?utf-8?B?NW9vckpjZVZEZjBLb2dKUHByQWhzN0ViWENCTzJyOXlvcXFaT0JSK1F1RnBj?=
 =?utf-8?B?ZFhKTFhDZUhCRkxJdkdxUXMraVQrSm41ZHBTQzJFcnhoQ0ExQnBabFUrUkF4?=
 =?utf-8?B?cW9UV3p6T245MDd2RFgyK2Q5Vk1mUlZoUWZYVWxiWWZwVllyNzIxYTJKZ2hV?=
 =?utf-8?B?VWt3N2R2WEVtZ3laMGxRZVU0M2hPcGN2TDBITkVZa2V0eUFwNTJaeFZpVGhr?=
 =?utf-8?B?TjFkZ1NpVThXN0M3Z1NjMUk2eUwwdkY3blY1Q2FFSWRYV3RSN0ZOZFJDbElR?=
 =?utf-8?B?UzZqcXFZV0ZFd204a3h0ai9WdngzZFVlQjRRQWgxUlFmZ0lnanNrMUNicHQw?=
 =?utf-8?B?UzRrN3dDcitDenZXS0FlNHYrSUlvYnlualVIdGtCRWVwV0wrV2FRei96RnVr?=
 =?utf-8?B?b2Y2MEdZSldmSDZEUXJDOXNWTVk4U2RpT0pUTXVEMXk5WU1GNmx6Uzd3bDlS?=
 =?utf-8?B?ZUs3NGdXUnQ4SlFhTnlLTnF2QUZiamo1RkUxcElXYk5DK2V3VWxaTEU5WFJG?=
 =?utf-8?B?bjRiT2YrL0hEWk14ZGl2TmphT3hKWUVkQkNra2RCaG5IcHJVVFdlcENVaHNV?=
 =?utf-8?B?TDhzcjBHcXdxYTd3VXpsMHl5ZDZMdXdqNTcxZG0rSitpRWE5WDZMN3lpdDgx?=
 =?utf-8?B?SzZLVVUvM1Z4TlUvMTFRTThZNk5MUGJhcmJZaFFVNGV1ZU1WOUswZkhYMHhn?=
 =?utf-8?B?bTlNQ0NpR1N0dlA5U0JaclFlMWRQVGgxREg5ekZIUW1YRzFGaWRwdGRaaGh5?=
 =?utf-8?B?aFlCM2xIdm1jRUQ5bm5MVVdyQjdVdlFRTmExS2lVelIxUUE0TVF2eWFSSi92?=
 =?utf-8?B?Ly9IVHNNVUhDaGdUQTV6dUFud0w5Um1NU1BWeHpsNWg0WFRkbGpJQS9nd2Vs?=
 =?utf-8?B?U1prbllWdUFBVTZ0SkJ2UnJwMzRLaGF4NzdJYmthZkJNd2hFMEVzQ0JESUNw?=
 =?utf-8?Q?b4Xu7k4JDLY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STcwNWV3VFdtSURYcGNPbXhPd3BxTzd3NXhnbDZwZVhQMDZwOGJ5b1AwTnJD?=
 =?utf-8?B?ejRDbnM5UE9LVkZyNW5RL0NrS0tOOFZpM2Nhd0ZjU3JHTzdZN0FMTjg5MGxl?=
 =?utf-8?B?N3VaN01VMnFOUEVMM3pRSWJ4K3phMzU5Nm8vbkExUjcxczl4aHlDSDFzRWJ1?=
 =?utf-8?B?SWpRaW9TZENLMjEvdFhqYWJhUWFqT05VZGFKMXFIMEdlRWRERHh1bjMxWjM4?=
 =?utf-8?B?QjBCWGRMYmRmS0U3YTVZSzQxc2tna2loV20vMkpHQzg4MHZKeTVva294OWli?=
 =?utf-8?B?ei9GSnEvMWRQc1BSbFhXTzJhbWRpZ3NpVnZ3MDV6emI2MGdZRlZ4ekdWWDJw?=
 =?utf-8?B?d08rOThtK1NXUmNvbStnYVdSWFlaK1ZEcDNsblJ6SmNiOHc2WUIzeDBmcUx0?=
 =?utf-8?B?Z2Z4Q0YzUjlHQk1rQUZlcGtEYUVGTVZ5bDFSWk55d0ExY3U0eEQveUxOVmhM?=
 =?utf-8?B?ZFRSaU5UekRQSFl6YkhqeXg2ZGZ0RU9IQi9GREhpMCtacnRFSDM3eUF0Uzk4?=
 =?utf-8?B?dEx3bkJxcDFWTldVV0ZNQ0h5Y0FuRzFEaUN6b016cXJ4N1pkdmJxQmtsM2xz?=
 =?utf-8?B?YzRGYzh0SWl0Y1ZHNzBFVFNUN3FnalNxenI2ZGlIWEdQT2NGK3phWDRWVngw?=
 =?utf-8?B?N3BDbmlGdHlvVUNkOVdJVXh6YkF3dlZaVjZ0aGVYWXhsZTdtRVBjcmltamZz?=
 =?utf-8?B?K296SzJxOERTYk4yVHVodmx0ZXc1NjNNcnZPM0xGQUY2djNMcUhBUTRiM05i?=
 =?utf-8?B?SFVxbFRwTDNiVVBHVU1Tc1dnQnhlOVA0OVhOTFJTN3J3VE1xYU9VTHVRV215?=
 =?utf-8?B?VU1sMEF4d3h1YXdZR3FMN09YT2NpL25ndVRYMVNSTUYrR01PbjllVG5uTisx?=
 =?utf-8?B?SUhXcEQyZjRTaTEwNjRPQTFOWHVsUkt4cUxWS0NDVW5yazdqWGlCUy9ma0dM?=
 =?utf-8?B?QWxEVEtYN3doRnY0Yko3eXdnU0FxOFZYNW1BU2FtOG1jTFdEUkkyRmIwMnFp?=
 =?utf-8?B?aUowaHRYM3JFT2FjeHU3dHRCK2F5dDhVSEc1dGxYME9SNTEyMDhpZTZ2bGtn?=
 =?utf-8?B?RFRCRjBvVjltVjIyTDhzRTVwdXVQbXFWVUpKcEVLbHlrbnBmNWZDNCt0VmlN?=
 =?utf-8?B?bktsSEY4SEVHRkloQjVJM1BOcWNHS0hnQWprRWZDQi9xSmJFZkhVNUI4SlM1?=
 =?utf-8?B?aUM2cnQrUEFwU3Y3bFBQbngzcllTZXMvZ1k0b1RPeHRDWlhBRkN5eHB0Y1h6?=
 =?utf-8?B?RU1HZzJ0cVg2Ym5YMERmM2NyTkR3QVlFVTduSU41Y2VjQnFtM25tY2h1MWRo?=
 =?utf-8?B?d0ZNU3Zqa1NRaXNoVXU1amRlUkFZOG5Tc1JqZUZuZW1pZFBJbkMrRllUL1Jn?=
 =?utf-8?B?TzhQUXZ1SXBGdVBZc3A5UmdsbFJIN3FEZld1UWpvS1Q3cmdhNDdSajhFanpI?=
 =?utf-8?B?M0M1cmNMVWVVM1lVa2ZNbE5TZFdNUkpBRFpMNVkwMk40aUVUTzRmTWxDcEpJ?=
 =?utf-8?B?TURpQ3dNcWhGWFdtUXBlNXRSekMwdTdJUDAwbElnNERjeEt2VmxWR25kcCtw?=
 =?utf-8?B?dUMrSU0vTzNsRHBranUxelFjVU1VOVNJNDhIRk9xTUVxb2IzblVnbFY3SVZq?=
 =?utf-8?B?T1VKOEd1bDlzMEZWUm16RUhEOE1rZFQxWEpqQk9sVm1JWnpCTGcrT0RVcGpm?=
 =?utf-8?B?aVVPWGNxMjhZSjhmdTlrM1M0NmtnSW9zQ1lNelpqbElWTUFBTE9FVGNCRTlC?=
 =?utf-8?B?NWhnbWdualh4a0Jqdms5cmJ2a0lTVzNQWTY4d2pQNHROMFJpUlJtRmFSUVJh?=
 =?utf-8?B?bTUyeXhoRklIQUZYNUZtYVhJK013aUVIOE16Q3hBQW0xOElnaEViQVNVRFlr?=
 =?utf-8?B?QmkzU0RxYm9QS1BhbllUbmNPSUlqUTdHd1ZLT0c4RGN3eEFqVFNjZUpST09n?=
 =?utf-8?B?Q1FKVjhYTDkrWGJSN3VGMkJoNHVHeXNhY1FqZmdlK1N2a0REbDNrUFl4eDVG?=
 =?utf-8?B?VVNkeUlYdjByUktvK3JiYzlUS2dMc1VaeThJdUwrYVhrNmlMZ05hMHExVDdk?=
 =?utf-8?B?dGVzTnErNk8vNFRjRU03TVl3N3lMRVhpQjRYaTBVUzBha1ozYlZqTXVON2Qz?=
 =?utf-8?B?UTlWYWc0L3QyL1A1VUdENWZhM2tKSXlnajd0azBoNndTVS9yalNaaFYxZkhR?=
 =?utf-8?B?S1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iyqkoii08oDnnYpEv1WBA3oXJR/E2ARD7nlhOcH6uAfRWq2t3xMDcZmNhjeBNC6VdsEgexdA8Ws4eolBkUN/HArXyt9uFTl7yLRDLjfkzlCQNFL4IDynoCzd+VbF/vxH94W6QXrGjq4TzZPtUdLL2FMHSY//L6gurajGFA+e7SxO0fEwaIYKuRBmS4zc6Bb603xhLGcAaO5zAy7JY31Y9XVtEnb9gjbAVr1nJ6+p2OUZRWGwrtqexIg2rhfc/AaAFCFRpZ7aWpQlcCQh26XX3mA6w1caKesN7TdXhct6JLOLDc/I2HCvEz+nru+FgGKUJdSyhhI9Vv7FSB6Pawo8SHpHqwyBLDHP33wTKhrUg7bXwEsGo4CCRMQZHObsYanJfrHHAb5bSI4vDFJc8knzZdYG06bNkfBS1VcAa9bhYos0Yh3cy8oeTQc8BwRXpcbKFVN2A8/XcVjbRW//4uImkOT970CuCNhq5BAsdDY2tlo3n9fZLGnckys+1sB02LybTvuDOiwCJS0Momm40udTXpLRJ748L2ORX0vl1+AtPLUwj01knykqATjObgNf7Zt2kBP5ropfLYQ8dt31RIo7XcK1rJn6ulM4jVyuRsZ0pvk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 497c333e-6e96-4204-3487-08ddb941ba0e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 08:23:30.5117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3z3pXR1boZgJxYxxfILOErEfKkye7AkP6ioHgGm8YzOwyYp6/eoWf9SAwmdKLJShumx61WI4zRPaxTiAF52DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7428
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507020067
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDA2NyBTYWx0ZWRfX9dzKmYajdZRk 12LL3kyPSTbMahwgQMTcK5j+oMFbwLUgPwCCSukzMJ+7dx8RNhTy1QOiMqTtZ/UPZXCmgChd6dA BVdasugjOYeaQWFa04ueXVJbhq1KLD/oYzgoFKS1wEDWE04wD4129JJEaflpzK2HIv2DNCgK/0A
 oqc46dmZuhxPWySDosdi9tnB18ZZNtj7SvhEnnyEZOzzxYG6bTAW+D4uYS9OEQakiW8g1ep+vwe eR893czqC5cewkpq/70YRotOvXgjZYUWwe7q70s8E6es0oB2knbbwRpBl0gS+PiZlV3gHn/Uki2 kAD/N3+8UEF6946g+xbnXP9d1mlrroo7JPRnb5/q/dJg6rAhcKZEHL15m1vyo/RMPMFPf1nVFax
 IQ63+D2GjK3zI0YYg8JUA2p+cXFeX/0B1y/iublqiBcOzn/MtKcVYExre3/C5GZCYpjcCgQ1
X-Authority-Analysis: v=2.4 cv=MvBS63ae c=1 sm=1 tr=0 ts=6864ec98 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=xlZdFHEKrP2Ww30OUt0A:9 a=QEXdDO2ut3YA:10 a=gtUDr8szQMkA:10 cc=ntf awl=host:14723
X-Proofpoint-ORIG-GUID: GiYaSX9OYLu6wPM0niXj59BoHvRv2PGv
X-Proofpoint-GUID: GiYaSX9OYLu6wPM0niXj59BoHvRv2PGv

On 01/07/2025 19:07, Darrick J. Wong wrote:
> From: Darrick J. Wong<djwong@kernel.org>
> 
> Dump the new atomic writes statx field that's being submitted for 6.16.
> 
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>

thanks, FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>
