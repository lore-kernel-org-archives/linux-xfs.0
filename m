Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A592E9EAD;
	Thu, 30 Oct 2025 19:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853140; cv=fail; b=Ok2r4WfOxc8sl8T5qlF2Tby9VpE+sZXdyuVoqpNmX2/EV0b0T1RPz0Zuf50JLgyrM0hRXunvdR5Vyv5Gxlxhs8oTeI2IFN9+B0d3YUqRFZe+ulBfsb8KL/y9IMKK2bIquZ5pbjbPoYjf5L3Y8vhfaoR0vEUqS6qByZFx+ssclog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853140; c=relaxed/simple;
	bh=8lWtm7u9h1/Uqe8JtZHRTjtVln70U9WMF35fJ/wDeKw=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k6PNUh/SxQYpf7RMwV1aoJtYnVOOPR63xJ4HVNfKT7ExxXhEMspwy/eokHvHd6G/UT1QM+MjK11+QYMZcEWGRWoqjx/MG5F7ShvCkuRC8zdi9ugN33iQRbnqJ2g+VPj2liUrFIeEZ8oWPBloWwKkEnMi9dDPEKtF6x3OpB4eQO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CD/Q7dZE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=se8q6fm6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CD/Q7dZE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="se8q6fm6"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UIJi03024324;
	Thu, 30 Oct 2025 19:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=M4soiLt/EL0ZpiTcz87wa8D/irKmJotvj3C4DPUJemw=; b=
	CD/Q7dZEICSoswh0iGJiy24xSK7kqzlQN5CK8Ww7uICgOXUwF5hoJeMSI63ETQbK
	WBlZQBRG9x8GJgv60LXzZsgL8BpE8F8L78oBXKh7JbPUjinOxHHpd4lsC7AZCo5V
	eUg/Kw+x3aa2Vrb1H49w+P8w+KhXWtwLVyQlAl3P7ZSpcLNEUfuUPAPYnFeEF7rY
	5uXQmcVjn6l3fOEnjRaxCz23j2KvRG2a7UR28FdCZMndUvWeFD3/kKsjnC420H42
	hHlpViU6EL+0ORbBN5lJItS8mn+7eF3XMar6VBXwssNP0oGOnfwfl2lAPSb0PYXU
	8Mr2Krut+u6wm8gvi3dozQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4d6q06gh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 19:38:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59UI6vF5017289;
	Thu, 30 Oct 2025 19:38:50 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013014.outbound.protection.outlook.com [40.93.196.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y13rca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 19:38:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aYDPNdhqY8CPKM4Nn6pdGc5CQ0GVIF/JiH0wv7xu1hacjdVsDyu09MzR/+phdzMs7llIytC4WGexsvcho/3GJxptHD5Lb5H9X1dcNMazCPgB0+SHW20EPgXe5kjnikjGkrMOmppfVqJBMQFRCx52ORKAv1f3ODN841d/56jM36HtXG6kthdbb7wTgvzQXBsOuNzRS0PzxSWCae7gcwRyXnv1wna6aJlQBt5AG33BcTWvhBHOZ01t7IgpGwbNKZ+sTCMXXumQ4P1kqLInO8o9A3jSAU1oIUt8LxILc0z9Ma3dyWwmEkZD28KzJpunk86DAsqAKJurHMQxi4j/rRfJ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4soiLt/EL0ZpiTcz87wa8D/irKmJotvj3C4DPUJemw=;
 b=FghXBLdLhVZsPpv7COrYVDK2psZqeh0hc/aFNxSLJ1UaG6drkhYsPG0vLAW4oYN7WN5KA3h6UxJd2hr7CYSJt0umlcxVBfn70KpgJVuSgXLUIe5OEDZ9gX37z8GPDtf90BDr+LEpjYSZS/CLvoFlM2O+ViNZmDiWWS+cY1oYwpGXRx8tBwMVlFY2gh2zLcMffHRkhVcCrnnWniF7lPu8d2c3tAagmr3q3Uc7Z0PGriyLYyRIm7d19emW7ZSiYl+lgxhlqfFm/lYzWblDhdgwsg1utDgfaU54DXeq3XzFony32UWiudP/8ZZo9MDvsDOYwysp8yjK9i29GpzLVleAzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4soiLt/EL0ZpiTcz87wa8D/irKmJotvj3C4DPUJemw=;
 b=se8q6fm6+k7y653poiF8RONEVZhq3ieoPuWLV7o1Dp2GJF4f0fam2ejrXtSYbc00QkHW8o8xhs6oKptnI2UtHTvxAmi8+byy7PRPUJTpknKLvz86sYBDnxzFHqqRUIJAhShdNh6MqMuJxoKCjTskdpy6s/3RXvlP7Uv00Y9l0AI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ5PPFB6A054FAC.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 19:38:46 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 19:38:46 +0000
Message-ID: <0c25aaf1-e813-475f-ac7e-a05e33af91f1@oracle.com>
Date: Thu, 30 Oct 2025 19:38:43 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
From: John Garry <john.g.garry@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
 <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>
 <20251030150138.GW4015566@frogsfrogsfrogs>
 <c3cdd46f-7169-48c9-ae7a-9c315713e31f@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <c3cdd46f-7169-48c9-ae7a-9c315713e31f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0315.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ5PPFB6A054FAC:EE_
X-MS-Office365-Filtering-Correlation-Id: 503bc2ec-370d-4b39-5a3e-08de17ebf0ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aW94MmlQSGozdUpyVHFzaWdkMXROaVQzWnB1MW8rQmt1UUNjZXNEdUxxN2pm?=
 =?utf-8?B?MlVZME1kcHRlOWRWci9QZmIvUXAwUjBnMVI5N2FtakZEMlcrcXQ1OXRFNVVI?=
 =?utf-8?B?Z3l4RC9ERU94akNRQXExWHRBZ2tnblhZSGxydjE5alowRE44K2RUajdBOHBX?=
 =?utf-8?B?TXRyVVYyUmFiV2VHTU12d1BJQUJHUFpBdXJkM0VlelB6U3FrLzFKRlJYclRR?=
 =?utf-8?B?aHFKQVA4SElZZXg5Z3BRbUJBSUJFdXhhT0lnVFR5ckVvY3R5Nk13Q2taU2Zw?=
 =?utf-8?B?ZjMvSjhONlk5MXdPUEt6SndiOGIzTlp0NXZJWVNhOW42TlgwU0tsQkl3NUpD?=
 =?utf-8?B?bG94YzNPWCtvL2xpdytHYXNMSWw3eGIrYWNwUFliSWhlNHlyc0hndldtZUZD?=
 =?utf-8?B?M2F0dnNrZ3ZwMG9KK3RKaXhVTVlGakpRSENIdkVzN0JHUDBJa0s1M2tGSmRQ?=
 =?utf-8?B?YVZRbnJRRHU1czBMcnluYXZteDhTdVd4Wi9mOWtRYnFOQnNEb1h1bDNZZmlz?=
 =?utf-8?B?SnVtSStyUUNTOXpJOEtiNVIvK2N3T3V5aHZ5d1BESW5adGRPbEJ0Unl3MWlJ?=
 =?utf-8?B?VEZOYm03MDcraVBUdVVwNEwyc3JCTjd2RFFwRnYzYVJ1QVFQeldrYUNVTkVF?=
 =?utf-8?B?WWdPVytyNmdhcVZCYmhHN2dvMllMcXFtUXk2Q25wOWkwOWZtTndjT2I3SkRp?=
 =?utf-8?B?RmRYTHcwOFIrYW5FbFpOcjRWSTRxeDF6ZXIyVTViOFRDTG1QeDEvTHB2eVNi?=
 =?utf-8?B?dk9QbGRsL1p0LzhuK3FnUHViVTEraUpjK1B2MmFhdTVYUzB1WkwxZ1B0cVVo?=
 =?utf-8?B?RkR5Vlg3N1c0QldVMWVJYTFFT0NLanFqQk1YQkhxRldEY05JcWR2aFovdG1C?=
 =?utf-8?B?WGYwSklhcWtrZTNaUThFRFNiZkRIUS85MHFKMHRueU43d2dCMmF0dUVLRWVh?=
 =?utf-8?B?bGRYWGRpQ3NPVlIyWnQ4SDZwTjZ6S2hQdGxYY0JiS29RQVBML0hlSHNrNmQ2?=
 =?utf-8?B?UFZWVldNNzBHS2Z5V0tuTXdnMmtlZHNuTjBCNDI2dXhkYndQRFlvN1poZXhl?=
 =?utf-8?B?Z1gxOEE5c3JLZUVVa2tCY0JXYndPS1ozOEt4dEF0bkdOeHlTbVYrcGJpd0dw?=
 =?utf-8?B?cnB3bDVKMW0wSnJxREl6VEQwWEFtRDZXYVlDc1BFekVSNWcyMk42T1BodmpO?=
 =?utf-8?B?NXVKbDNBVm4vZzZjRVVZbEhuQ01MTkp1WjV3dEtUSEZmcmJRSVJEaGt3U3RV?=
 =?utf-8?B?VnZXUEVWWFVHaWJ1Mjlxam9PQjJsaEtIM2dMTDJ0azMrWS9ZZ0ZlaEppeUpE?=
 =?utf-8?B?NVIxejFHK2lCckhuVUNhZkJZdmZFUFYzcUpNS3RoTUxEYmE5dVliOVNDNTZ3?=
 =?utf-8?B?MHovWlVGOHJBR0ljMjMvc1NMVUFuTEtvNGVvaUMwTEtiajA4MU5EQ0FJaVJp?=
 =?utf-8?B?eWd2MTBvOXYxbWd2a0xWak9zZmg0RHh4QVdkN1hBY0d3NVlSMUFIK21uNUQz?=
 =?utf-8?B?MFdubEZTYnI4Q2VFbmNjWXhsNlVXQXlXWEdORyt1S3cxbnJ3SE5WTFRPRDBp?=
 =?utf-8?B?OWJCRmNoQW1sUGFaYmJkMDdSSVJxaXVXVGl5L0hiVFkzSXJhT3dkRHgyMndC?=
 =?utf-8?B?SFJZSWZscTdldmNWQW1tVzUwZ3d6VjUvWm9CRG81eGlnaldOL3JPalFqa1I4?=
 =?utf-8?B?YTkzSWcwY1BBd1lwajlVQWtQYVdpdEpvRmFNNHQxOVp2MndHNGt1MXdGdGxE?=
 =?utf-8?B?NW1BM2J4cmJCTTJXdm8wOG1wL0MzN0k1WE5FQWErRkEwQXZPUjJYVkZjMTF5?=
 =?utf-8?B?em1YWncxQUQrVFBNNXNVUktPQzN1RVRMeWViRHlkU0dVYktCeHZMRC9wRGJI?=
 =?utf-8?B?LzVIYURkemRRdHFEVkpKUG9TWGdGWnFMV3dkOUpXNWdlQjRSMFVEa1FtQ2Q4?=
 =?utf-8?Q?9HcuOk13Em4yul+zT27CPwJ6H5sen7IH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlI0Tmw3YmRhcnMwM2x4NlZSSHkwbXRmTmptcldLeDVuMWxwZ3ZQWG5uTG5z?=
 =?utf-8?B?L0FtbmpmU3ZoZlg5Mk9ZbnAwMEpkQ3QwbU1TdGEreEl2bE9FcXczY0VjaWh4?=
 =?utf-8?B?cjQydlFJcWJQZXN4ZEVNa01mZEJjQ0ZFWGQ0bzVKRUVKeU9JR3JrSkhzNERV?=
 =?utf-8?B?Y0FEM0RvWGlBYVFha0RiaTZ0YkdVWncyZUVyb2VzMjNOZEFUdEMrMWM3MzJW?=
 =?utf-8?B?Z0Y4d2dmSDdqN0IrdVRzWFZMdDlIdlBxbkROZElndEFRQS84bjN3SDdEN3lF?=
 =?utf-8?B?TXNQc0pwbkM4OWsyOGlKQmNLT1UwWU5ZN1gxczViWk9WMDAweENqSlZrMXVK?=
 =?utf-8?B?RXVzdDZ4aTYvaUkxU0lvQlBQWkN3dExDTDQzTGpFeCtQWkZpQm9tbDFGanBF?=
 =?utf-8?B?VG5aZTFWTytXdHFiTHgzUldCanRoWVIwOVduMkZuNWl2amx1Zk9ORkMzQTNC?=
 =?utf-8?B?eHU5Snl1dGcvV28vbmR6S1FhYzVtNVkySXFxMnZobkxZOTFTQ3JhQnBFWU9J?=
 =?utf-8?B?TVVFUjJYaWxEOHFqUmoybm1GTEtJWWc0S1AvTHpYRXBpUm1ld2I3UWRBcDd0?=
 =?utf-8?B?RW5ZN2RUcjVqWEVrQVNqNkZvUG1sa2tRU3RtdkFyMEtNRUN6VE8wWEJLMG9J?=
 =?utf-8?B?QXFIMXN3andjN0pIMXlCUTRTUytINE9uOGpMVDJ3TGMrVW5Rb2lLS2NYMlhz?=
 =?utf-8?B?NWdtSkQvTFd4ckx0RFBER2ZvaCtvMFJwTndGdEY1ZnVpTDY5SUFOWThjTjRJ?=
 =?utf-8?B?V1FvbXdwZTQ3OUpaQTh2akc3NlJOd3drTVZ3WXl3elA2T1prRnBIYjJETWJp?=
 =?utf-8?B?UWR1U2xsSXdVTHpLZEtIYmlzYldhSXNoUTlneHlDUlFlNXJRbFB4cUtkV2c4?=
 =?utf-8?B?RjNvUEN2QS9oeEx4QjVMbDZIN3BQelNnK1lmaCtFVjV5dThKYmovZFpuRjZL?=
 =?utf-8?B?Q1o0VmJyWldXcHVMM0w5ZkdnZS9Ha29Cc0krOUxxU0hFLzQ1dmNHcmlxbjBG?=
 =?utf-8?B?RGRIODRML0tiaEVDQUo4bFI4d2dXd0NLTVRnK1BhM09ZTHE4akZsVlZGcWdE?=
 =?utf-8?B?YzQwN1RFQVNTK0oxSlN5TXNUYldPUmNYVEhKSUZPRnZXcDdOOGZYRHk0L0FH?=
 =?utf-8?B?WmZ5UjZDL08vOGxmL3Z4MW5uYmZzREVDSTJzTHhQVVRKQmNmbGREV1IrTUtT?=
 =?utf-8?B?d1V4M3N0VzhCY3p3WEtXUkhsYjFYbkQ4YWZZZldwQmtvQlVnUXFiWFdTRDI5?=
 =?utf-8?B?V3RLV1dOMTZOTnBSL1RSaUFDdTZHcmU3bnZNUFZJbFZXcjNwclVpNmdvdkoz?=
 =?utf-8?B?Zlh4Mlc3VGVPZkFMQ0RiLzZKWVhpeDlXNFY1UXFHU2k0bmppWmt0UmZUZngr?=
 =?utf-8?B?QWVlMENoTVRybzFqTkpubVBIZkRHS3hGMnFXcEh3SlFSbG9iWGVzMTNYNnFq?=
 =?utf-8?B?UmZnTjUrQ3RIZVNTaldySDlzRDdjVTJrYjIrUWdxQjJMMlEwMS8ydUFWNzBJ?=
 =?utf-8?B?ZWUwbmNONlV4REt1YnkxV0krT3Y0ei9EcXMxRFZNclJBbXB3Qmg1Vk9qNk1U?=
 =?utf-8?B?Ui8vdHZkZjRPVnpFUll6UHVWSnIvTzJEa2VvN2YzY01LaW9YWnB5Zkg5ZWtj?=
 =?utf-8?B?L2UxbEJhTk1sUjNwaDlqVmo3YkRWMkU3dFZEbnRmdUptUFFudWhZYmFzTEdx?=
 =?utf-8?B?dmlZOEw4MXhDNDFRUkRGa0tkcnhCV1pBeXFBOHpTSitVRlpPL3NFb1RCWGhr?=
 =?utf-8?B?Y0RzT2tYM21lVmMvSjVYZEd0ckxuc3BkWEVTMVR3dGpBcHA0RG5TTHBQaktG?=
 =?utf-8?B?L0M5ZjRta0xwdWVtL0R1MzZvc2hxQmdDdThqVTh4TFlRaCs0RUxpWGtOQ0xm?=
 =?utf-8?B?d3o3WXRTR09KNVhTY0dMZU53SGMzYkwvRjBRU2JRYlVGdkkwWXJITE9BZUJt?=
 =?utf-8?B?TXVrMWxZckpXR0V3SVp6ZXM4dVR3T3l2dTNvM0U1OTNndTNyL05xdk9mVlNv?=
 =?utf-8?B?K1IrU3VtQmUvSWJsMzBjVkxrcjNXVERlQ2wwc1NKVjRjUk9SUHFjanN2U3FH?=
 =?utf-8?B?ZVhYUm93L1Jjd1d6Yk5mamRsSVI0NUFrai9LVmprR0NQQUZsazByZmsxQzJT?=
 =?utf-8?B?Z256VW55NzNNblBhU3orNGlHais3OHI0MkVFK3FEeTlIMXE3QVlKQmxhbnZZ?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TYry1l7YqZk3FbnYS+N1VpGKqM0vnTsGoTDPdAnx9nPFT3EXy4Kep85P33J8IC9k2luaM3BDV9NR6Ler4w9iMJn0XNlyBFyZ1qRWv4OEqr9kA/6bpxujE8OEFdkvE4mLh7HmNtTvFJyd9VOmFadZA+oq325xx8uHIMc3xZ3vMmxAM9JJJFQni/uiDySIAH4siGRl2OS9Oq4NS7iOxxuUF910cmZSrN8jiTUuiXsok6IzEN9Xh7pEsiJofW8nP0HtgEO0wc0pGf7nA/9XDyNtcGmt1GeG9PwqBYLpyRcF9Fo5GkeCQez03an/klNm35S2RWh8ZhMN+ef60L8L4u1O5h658O+YlwJ3Qfo6Uqdl8cpBCw5qhQoWyEkOAasMGiPivb6vpQqyvYWQ2Dz3dtj1O7QbJNqdUXmYxIC7xNOymP1e/D8bMcrTqTxoItjyj2NNiV4pYqTtZxy7ZJWhcdA+I8HH5XTzbyxk4334f8cABUu/fgv5VvkKBrH75XsQucokn0GP8azaP0GscAcGVNGNqNVjLlESv1Qw/NriS5if1YpBJKOiwvagPJ0uYGPtoLaUCOJFOZC/AeQlGmGmVhPYJg4ROqyEfSKJFtZLgCq2ao0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503bc2ec-370d-4b39-5a3e-08de17ebf0ee
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 19:38:46.2042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LRD1EOT3FVgI5qrPiMfq5kH+82VguPQ9AhYcr6ZkjOsJXjGsJOaFheX2zWTpWwg/NTBX6tXkHUd8I7z3lg+7bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFB6A054FAC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_06,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300165
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDE1MiBTYWx0ZWRfX22SGi9dKq0Zn
 Rum/bYP20QXu5xIK5xz6bA3hbO4Sd+4a4AC8k7VlPx2oeMTDHtY1jUFwfvOSSuZs+/leTVy+pXI
 MOqlxRokcAr/kHuI5d7s4qdkalSrrT3P/SeQuSANq0VMBUP4zvDvhnTf9vDbFTPLczmcKNI2W5N
 Y8q9Ic/wUKCWh8EmuDnPkZZDdYQZxAd5yNzQXV/cAG7+0mVd0QW2SoHH5yztq+97aoggkFoNAid
 9nN+Gf2lNSQ8TpxMCrYgDU1GL0iSefq8G1xpohfFOSqXaxqbLfbY3IKTexM6YlTMl1XawApKlxn
 9rxS5N5b7pB9A2hA++vVkMSHwK3e3akhhSwEzPHNWuly+nCbfKrB3KlcEvceasWFkYK9wBOPaCk
 Q/dvxLcChkpwxD1qcA/8OcJrLcmuQA==
X-Proofpoint-GUID: EUC17W4ny4vOKXWyD07njnPI762SS9OR
X-Authority-Analysis: v=2.4 cv=bLob4f+Z c=1 sm=1 tr=0 ts=6903becb cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GJFPsNGR59OoyQkIedwA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: EUC17W4ny4vOKXWyD07njnPI762SS9OR

On 30/10/2025 16:35, John Garry wrote:
>>>
>> That's a good breadcrumb for me to follow;
> 
> I hope that it is ...
> 
>> I will turn on the rmap
>> tracepoints to see if they give me a better idea of what's going on.
>> I mentioned earlier that I think the problem could be that iomap treats
>> srcmap::type == IOMAP_HOLE as if the srcmap isn't there, and so it'll
>> read from the cow fork blocks even though that's not right.
> 
> Something else I notice for my failing test is that we do the regular 
> write, it ends in a sub-fs block write on a hole. But that fs block 
> (which was part of a hole) ends up being filled with all the same data 
> pattern (when I would expect the unwritten region to be 0s when read 
> back) - and this is what the compare fails on.

This makes the problem go away for me:

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e1da06b157cf..e04af830d196 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1113,6 +1113,7 @@ xfs_atomic_write_cow_iomap_begin(
  	unsigned int		dblocks = 0, rblocks = 0;
  	int			error;
  	u64			seq;
+	xfs_filblks_t		count_fsb_orig = count_fsb;

  	ASSERT(flags & IOMAP_WRITE);
  	ASSERT(flags & IOMAP_DIRECT);
@@ -1202,7 +1203,7 @@ xfs_atomic_write_cow_iomap_begin(
  found:
  	if (cmap.br_state != XFS_EXT_NORM) {
  		error = xfs_reflink_convert_cow_locked(ip, offset_fsb,
-				count_fsb);
+				count_fsb_orig);
  		if (error)
  			goto out_unlock;
  		cmap.br_state = XFS_EXT_NORM;
@@ -1215,6 +1216,7 @@ xfs_atomic_write_cow_iomap_begin(
  	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);

I think that the problem may be that we were converting an inappropriate 
number of blocks from unwritten to real allocations (but never writing 
to the excess blocks). Does it look ok?

thanks
