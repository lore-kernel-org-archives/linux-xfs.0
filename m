Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B68A221D9E;
	Mon,  4 Aug 2025 08:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754294848; cv=fail; b=pJ73S1iDmwz1M/uZMrpviwCq7tWHsaVzEdJdNlMMfD7YnGmbVnouEa+7eBom6D5pvq2DNFJOdYWzTUZGnuJxCGr856bmwcEmvsQ4h2hHfMMPehzMJ6cxh1eJVOgmisgu7nl0TF7F7m3Oib6XO62fnOwSjvtL/RPuGAzAgM3NU6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754294848; c=relaxed/simple;
	bh=MsBOoOhEAAoq3hxHGMQuFpx2uGZGQzcUYbYyoiLDipQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qN3UrhbrdWGj54dEz7aYzc8BF+xMpmKWSwSLLLVnilBSmQLntM+ysWzX6DvG0C0tVZr4QKODCvjKIAU80Bfofgbd5BMyNs2NklmhSaXUt6BhoddFyIkRdkNqRGTN4A4ggvNQA8Dvt8oW7fXDNV5N8wMebuc2Lab2deomZIJ/Hmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=apPDDqSc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fSWsPZF9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="apPDDqSc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fSWsPZF9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5747gGNY009116;
	Mon, 4 Aug 2025 08:07:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ga8mfRmrfpOEdi1BJGW8w7QcnhO0M+sSsUUAWowl574=; b=
	apPDDqScMsPkWXZRO34pGCNwQQYckjxNvoH9K8VqIjwjI07vzLlHGdW+O/+CZQyS
	ERs721wkL37ZPH0D7x0VEWV25xJ6nBYXx3ie+ZrRcFrXTcmEJ5Qum4G7NraX2ju9
	8JkjcfirGwf8AvEM+xlwkhRTROeLrdtmuzfXjZQ1MGJmAo7RcMjOqpfre+Q8hPBS
	QPZg2EsJAfOcXHgZLpIbcs0byQlvp6lFVupshIaaGsZX/yHDh0nXl3PzT1CZBBXH
	o1CwD9+INxZ7lskMavHs6d7LyY9dJdU67feg7cLD5YK6vhgYy63FlfIUYXLh7MXT
	aLr5lg08CwcQ7KEB+6DFgw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489b7xj3kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 08:07:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57480W59028712;
	Mon, 4 Aug 2025 08:07:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7qcb2dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 08:07:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s9wO1J1up5YyGxDmjlY/trzMzGs8oB0bmfpuQtXmS12QQtQPYAOMifCxvYYRgStjd4GIUu9XHE7jyOy5gSlo699rT9DGKeqyLWiYSy/TGn9bIK2OpXVdOyX3aM7wPqcckekQELauvFbXtVlV5jptaxwMyGGlk6iHCN8Kf/xBBgBZpieEYZhD2q2BpQRhNGOv8oG175aXAxwEbdVMqUDd8KSDsZtGHTMtL4T19apwsSeDoW1RjnU5ZRzx69WSqTcExQCpUCu4armIsJUDCqDJlREQtOFGc7Nu8XGG1iubez5aVD6x+HuxzshjmrtIc0b4OAJu0DT2VYmFr/Zg/dXzuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ga8mfRmrfpOEdi1BJGW8w7QcnhO0M+sSsUUAWowl574=;
 b=apQgSl0w3DreY3Q94ei7KGidhVWzv8VBi7/eLBbT9i4I9tWFL1zeu6Mb2szehOx4y6S7UCFIomEYtN10L2CcUxM0le7sybWbqY5JMAIXmlTNyA1WysahiKY6tu/1KO3wfvz9KSYVrZCjy1KZ+vx//5YIaYIxIHE8ATkUw1mdZKuibDzQFTAITyCCPKrbFZqp+fTULWPqC7qNQmpkCeSYSx69Ap9xCDdP7zp3gq24Lo93wfj7S7GYLVSuGM5856uj85H08GjtwkcRPEm4R36UVFMv5YshOxJHhDMecYXY6U0xR317Lol61QSKXqCLlvJwI51wHvwz7/AE2avsoKafmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ga8mfRmrfpOEdi1BJGW8w7QcnhO0M+sSsUUAWowl574=;
 b=fSWsPZF93Q0O1laqvJK9sZdDsCcWauC/zqt7XuT89i7muJKqvEIbUyHnER0Fiv9KaKo9w7cy2Ce3D3R1KbzSJAa4lazuwsNocuS0lGEbeX6JjSP4f+meQPepzKK4LtPKuuo10t74hpTGoWUEhFBiD8YWBx/+XbmsNjrLOFvg84Y=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH3PR10MB7393.namprd10.prod.outlook.com (2603:10b6:610:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.19; Mon, 4 Aug
 2025 08:07:19 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 08:07:19 +0000
Message-ID: <cb4e275f-7b77-4e0b-b21c-1bf030750dc7@oracle.com>
Date: Mon, 4 Aug 2025 09:07:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] common: fix _require_xfs_io_command pwrite -A for
 various blocksizes
To: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381958029.3020742.354788781592227856.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175381958029.3020742.354788781592227856.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7P194CA0003.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:10:553::24) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH3PR10MB7393:EE_
X-MS-Office365-Filtering-Correlation-Id: fb2a3c91-009f-42e8-bbdc-08ddd32deef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzBqRUdUUElRWHlVN2RIdGRYdGNaUDRTVE5nTWMzUmpvV00waWhVR1VUQ1p4?=
 =?utf-8?B?SnJJSkpOd2s0NVRNWElRQldKOU9XYjFtenR4NzJpN2ZlL3lGc09XeHBBQnZU?=
 =?utf-8?B?eFljQXBOQzJhWUNPVDY2ZUI1UTJDUmZ5ZUR2NnlyUVRXeXJmNGMwelZKN0d0?=
 =?utf-8?B?cTI1MnZBZUo3blpGMmN3RXBZdUdzYU9rRTlRS0dsaWw5b2lMbVl4SzllbTgz?=
 =?utf-8?B?N00ra1RHMW1oZHlQeDB5UndiWThYcVNIMHgrdTlDSXRDY1pVcEtUQ040UHpT?=
 =?utf-8?B?azZQZlJpaUFVMURUMU1OQXNuSXJKZGR6S3lBM2RtMDdORWQveFNWZ1BKNXFW?=
 =?utf-8?B?QVVUOGRPakRKYTNLZElEK2QxS2pVUEoxbG8wUG1EQ3lsQVM5WW1xQ2FWYTJC?=
 =?utf-8?B?Und5d1lrbjRoTUpWbkF5MzhlRjhoako2TVRZWkdvdVcrbEl6Vm9HQlZFL1hZ?=
 =?utf-8?B?Tnl1dWdRWjNjakVIY2Q5bnRXb09TR1VqYStLbDg0MFNxbDVtOExpYTVIWE1t?=
 =?utf-8?B?QnZqM3lxTENaSUpueW1aUXpvZ3dWbmVacWVqUk5IUmh0WmlTVkNGanhzQk5u?=
 =?utf-8?B?WFpwN0xIVUQ4Q1JkTmFxenRCREpNUjZRdUZnUFZhZXhoc3NNMUJlUlgyZ3hW?=
 =?utf-8?B?d0ViT0d5MjhiQks0TVZmeGtBTFNGYitYUDFmSHlxbnBTWXNnUkhwOFRRb0hs?=
 =?utf-8?B?TSs4S0hadStZWGpXQldNK21neHZ2bmVRL1k4aUpMMUpxTC9FYklGNjRJWWlB?=
 =?utf-8?B?RExMK2Q2cVQ3VFEyTkxOdXUwOHZaVEtHc2xVZEEzN2k2SUhhV1luL2lQNUsr?=
 =?utf-8?B?VU5lMGRNLzdlUnlDL21MZTljM0p1Yk5MTUpsbVZUN3pOWTN2aVpFbnVSUzRV?=
 =?utf-8?B?RklaM2xuUHJGcDB1elc2SlpqSjEwZWpMQmNWSVZoN043dXEva1Jsc1lObmtm?=
 =?utf-8?B?WTlhbjVkZnJjdmtSaFlxR3NkSkVLNzY0SitVQVdyNU9UNkRlMlQrY2toN3RT?=
 =?utf-8?B?NjVjbjRkVGs4RFI1ZE9wT0crdkRHdWNUUTNuRFpGYTZOOW9tMGpVcDN5NzhC?=
 =?utf-8?B?OVptTGFsU01jYm9pN2dhMTZVb1RHNTFkcXFrYnBwblRVR0FmOGY0WUNpVm5P?=
 =?utf-8?B?bmh0UXdYK1kzSCtEZXVrcTBYQTVOcyt1N3dQSlBrZTR5NkdPd3ZuN2VNb3dY?=
 =?utf-8?B?a3ZXNXpVTldQOWZ0RU9vdklQQjdqSDFzUlVydVhWbXJyVUljMDdaOFlJSURy?=
 =?utf-8?B?T0s0U2NDZUV4YnM1NGxqWnQ3cGpSVHp2SGZocURvOTBIbElUOUZ3b0xWMVB0?=
 =?utf-8?B?d0d5U2ZOK3FjYWhiUDNJSmRMNmRKeSsxVm1qQnNLK3gwanFPZWFCUFZMODU1?=
 =?utf-8?B?dkRUdTdyTitLNVQxdVFVL3RtK2VQdmU4RGZjTWViSSt4OElNY3JJcmtHRHho?=
 =?utf-8?B?V0tTQmJTRHNkL2RCQjdzTVc2ZVJiT0dJaHhiUldTOC9oSmJLTjg2a0JoY2VH?=
 =?utf-8?B?UU5PZkttMUQyaWNFS3k1UlFXRS9XWGpGUGc2bWcySG0xZUU4bEFKS2dETFB6?=
 =?utf-8?B?MlQ5UU12eW5UbnplRWY5cFY2cjhqY1NDbHdZbmoxOEY4Z2l1QmxqWTRLV3dH?=
 =?utf-8?B?NkdkbFRYZWVxb1QxWnZCNlhvdU1hNURWbXJGVnh6dFlIL2NVdTdhTVZkZmM1?=
 =?utf-8?B?VW5XQXBqYk1FRVJFazJmVDVRMXh3dVJocGQ1andwVlBhVU5rNGloTEFwRnFl?=
 =?utf-8?B?dzRjdGQwNWU4Qmx6ZldtYnovdXcxUkVhSzJPM2U3NUpGcU9IR1J3ZSthR0w3?=
 =?utf-8?B?T0N3dEtNL29HeGVyZWw4ckZub3F4akZtY2xWWmp6Rk1EK1hTdVdSVDVpeith?=
 =?utf-8?B?WkJZeVFXRGZJUUR4TE1tZjduYTN3cVVJbjhXODJPeUcyNkZ2blBZZzFRcjhu?=
 =?utf-8?Q?dZC8XT2yUYc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkNxMGJCeWRjeUxJcWhiQjlHdWVoN082SWdhSEZmVm9ISGRTQ2U4bDJoMDJG?=
 =?utf-8?B?dEE0MXEwYlA1aElhZFJDbUc2Zkx4T1Q0YndxL0FVa1A2OTJoajZwRnRTMmht?=
 =?utf-8?B?MWIzQVdlRC9MZVFydzdqMEQwajdMMlUrM1dtWlhtZEhPb2M0S0pZa3NHY1lR?=
 =?utf-8?B?MEFWT3paR3ZkTkZhTnZmQW9KUGxXdDJPL3JkZFo4YWpRQ3kxM0Q4U2tlbXJI?=
 =?utf-8?B?WDZFOHhVbGUxd1lmZEkzWU5hbndUVW5zcmdTb3lzVGE5cWRqSjVGMitIMjFn?=
 =?utf-8?B?QTZSYk1ja3paZmVlTFRQczRPUUY2QkZkNS9CL3RrNXYyRkNHZlhVeHFqWE82?=
 =?utf-8?B?UkNXLzRqQzIxOEQ3YW1zNHByVFVjQzBhdzQyaDlHVGw1ZHJYMjdJRmU0WmdS?=
 =?utf-8?B?VW5FenEwZUFRemx3U2YwUHQwa1ZHbytkMHV2L05zWEtzOXdZVGlwS1IxbDVW?=
 =?utf-8?B?RHpWL21vVCtHWXAzRDlka1QxY3U0MHZ1NVFCQWcxTHJ4aDdaeTI0aUFRVXpw?=
 =?utf-8?B?N1dNSU1idnRybnV3WlE2TjFGWXErT3JnVXNGU0RyRXZoME0wLy9haGp1VSt1?=
 =?utf-8?B?N29TSDRrY2c5MzJqSkpXT2g1MHhKNjE2bkxYeTdYbitaK2FuWTg5QlZ2MUZv?=
 =?utf-8?B?Zkg4bWF0NU1iRVlYUFRGRVJ0QllGWDhUcUY1ZkpKRnpqbXZhN3kwbXorNVdK?=
 =?utf-8?B?dDc0ZjlGYklQWmFoU0I1SXpFems2NENLU1hiZHJHaksrc3NkR25RYUl5SFpx?=
 =?utf-8?B?WkhlVFhpTllZdG82QUlRbmo5UGx4am9QNWREZXptU1pQd2lMNzdKS2ZubWJn?=
 =?utf-8?B?NVp1VXc0SjNXUnJialZxSGd4WFBjU2Y5bUFFQThSdk9BSkZmNDFZbVRoRTVn?=
 =?utf-8?B?UEEzblJIaFpaMmZZK1NmaHUySURxbWpuK29GY2Y1Q3NKQ3lqeHUxSTArMnF2?=
 =?utf-8?B?Skp4bjJOMWozZUdocDlqRnY4d0t6MXhVbExjZlJMcUw2N3hiQ2xOaU1DaVZF?=
 =?utf-8?B?NEduR01FMkdZdkd3b0p1N2J2SXA1VG5DcmpOQi8wdll1YnozVzRLVzZoWTBr?=
 =?utf-8?B?Y3JKZE5kcXpvejd1d2ZmcVJuR3JhbUZnMUFDTkxaaG9HcWZkQ1Rabm5pdkdv?=
 =?utf-8?B?dk5lamhCSUZPRWRLbGVrZyswVDVPSUJCVkZTVEJIMDBxUDJoWVV6ZmJkVGpW?=
 =?utf-8?B?QWlJRUlLR0xkQXlCVU15UmxsNXdjb0YrTlo3T21GNVk3M0FrcnUySVB3OVFn?=
 =?utf-8?B?ajJBZ01tbVlNZ25WNlFuQzhic0NlQ2llRTZrMUt5MWUzaEZDT0RhQjhzSFU1?=
 =?utf-8?B?NjAxVVBuMjM5T3FwdER4NDQ5YzNabDF4eXZMWm9vRm1JWndaMUgyTjNxMmxq?=
 =?utf-8?B?V0ZYZlVaYnU4VGFBS2ZEL1J0Ulc1dUFhWjIvZkt5NGJ5QWlaekJ1dVJsNkpH?=
 =?utf-8?B?V2ZYaTdVWlE0S3dxTndlS0R0QUl2dnRaYWxJbk8yaVhZRlFuZ3p6RjgyZi8x?=
 =?utf-8?B?VTJST09aNlA3ZGh0VzcvSFkvQWEyV0hnODZiQVRsSTdmUU53eTFnbnM5RzVp?=
 =?utf-8?B?RTRPQTJZZWlNVjk2SFM3dEU2S2xzK1NzbkJvaHRjNk9FV3BwRWJCd2hpM1hW?=
 =?utf-8?B?SCsxMHNvWU5KNGo3bEVXbWpWMVprVjZjY0o1eWF4bllZWDdjc2NhNDVWQTRR?=
 =?utf-8?B?SHg2QlVMTGZqb2RCWGhEWFZkbUpwR0hmb0dtQjhvYzFRZXJlcjhibzhabnUw?=
 =?utf-8?B?bUtLdWVqOFBvaGNqTW43enhjNzg2NkxmcnFoL25sQW54bVVWOWk2SVZmMHJC?=
 =?utf-8?B?QzVpRGorZ2wzYTducVZ4QmN1MGhTdXllNzhVVUFPb2NNZmlIa0FrcmNmYUdF?=
 =?utf-8?B?Sm5qT05hR2Z4amJCRS8zU1hVTDVlVDUzNWFGVDBybTZmd0VPRjhOVFl0NWdz?=
 =?utf-8?B?amtuYjlwN0YrMjRyY0ZaMHpoeHY2OXZkang5c1pOTStHa3creEJZZTVLcldu?=
 =?utf-8?B?NTQ1M3pHaEg0b3VCZGpxeEpIaGcraG9aN1BnRHBjRTNRWS9Id0taWGlkMjlF?=
 =?utf-8?B?dFF5R1ovSDlWYkdLMURDWFhBcElwZGFtbEhlOXl3eEI3cnl0YTJXNmJ0Z0tE?=
 =?utf-8?B?cTgwODZDaWl4MDVITDFxdmZrT0h0T1ljNCsvQXpWNmU3cWZsNThJbkhKUWdv?=
 =?utf-8?B?R1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Il2UowWd9ticdGyMIFYjKAwfWZGt4EI2+p5bz//yYs7r9d5imM1/T2DbM8QapXcRvrg6UyrN9LI68ZZlSCHeGdL+3bh4lna2JVgSb6YAot4LlBcbhdYDWc0QvNQN+GxVHHzblUxmTDzPdVCxh0h2Pj56Rysuqzq2aC6K9LtuczNOu34a9Y6Db37RRWuQSlz6zFqRGqJaZWxswC3cHB64XcTgZLeaBKQh3osefKdFnxD8EA8BXDF9a5mFLc+Un+kFnqU9vsknHAW/mMxkhDw4y8gkHW5bp6dA3Dij4HWepfX41LWmczGoggIvctp41dnRQWPC2CYT0G01lo2Mzq/3cuuI24HKd2Y6FZP5jr4QfwmaViZnqtDm55oA9HjYKvuH5OKv1i0txxWyQeOeVe9Zlxe4VshcaMqS8p7VzD2/0/Y/mTQulAU84Ur4eK42AWMA3FvH4lGoTR4Z5/u2lUz++j+8UANpbp+kqdZGlsiraMdbo2C3RZ3w75gyhqBR/QPO6QEall0g8WGbSRa//mTo/MbZ4mu+EMWiajlnoYOSl+nEG85+EfcBSQ007KKJ+FMd2IYrzw38Lg2aQoYCIRHZQ/AA9DjlikL081yQHv4tC9c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2a3c91-009f-42e8-bbdc-08ddd32deef0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 08:07:19.4601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gn0HJAz4abdBLP9cxlwXb3PUypb9lBdtxB3GLXLUtGLZW2uw8IewdU6jIZH9GCBEIuyLhmoSznDZTazpTRzjGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7393
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040042
X-Authority-Analysis: v=2.4 cv=MdNsu4/f c=1 sm=1 tr=0 ts=68906a3b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=nfT0BKnib7v5VvHa-SwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ub-8igVx2DeavmDFffr0GDq7U0YOnVKA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA0MyBTYWx0ZWRfX7ixN9KOjoL+3
 aQQgTGqp9SN9LlJsBRzulsDBTzT1WnWN+xUM5cbFGX7mCpyXQbBzrnrtu2MhhzEAmvYmVT9cXGX
 eJY6GfeK7ISmhprS4k1pjVgu3lKWlzjfXnFSkwfgL8cITI7TadW05XQdiDGbs0h8zyYa8x4uxvU
 Asri+dt7xaze22Oly9dBaAFC2Niv1nubUftis8gsnmWQAU5pCWeHgmP/CwEcvnU572h38cVR2+y
 TAlPRlRtl7lc2IaXB0WtTKSq16vf0tpfvdSC5rflZzLaZ0AmKzQKk3pOL2N8BcRHAF5ygLoa6YX
 i5HKN/Id0DUbOOyIEctm9IypgHrAeETPCVU1qjWy9KjTg3DYnb5Fd1R33+mLUigMJExTBo2u01b
 bdgdtQ/tgFBXkN7n7OxC/YZNb8tJr5mVhz2tN94rZRWGsRQvnaCpmtEt14UGX4IhjyQnpLmn
X-Proofpoint-GUID: ub-8igVx2DeavmDFffr0GDq7U0YOnVKA

On 29/07/2025 21:10, Darrick J. Wong wrote:
> From: Darrick J. Wong<djwong@kernel.org>
> 
> In this predicate, we should test an atomic write of the minimum
> supported size, not just 4k.  This fixes a problem where none of the
> atomic write tests actually run on a 32k-fsblock xfs because you can't
> do a sub-fsblock atomic write.
> 
> Cc:<fstests@vger.kernel.org> # v2025.04.13
> Fixes: d90ee3b6496346 ("generic: add a test for atomic writes")
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
