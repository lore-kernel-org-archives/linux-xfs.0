Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B560F1C8604
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 06:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750227849; cv=fail; b=uCF0IgzvnL8j5zCn5ZFlz42DirhToJCYDb5RVMzDi0HC0GiST5askJuQ73CBvMI596h7adHv/Ge1rGb7pLR/rxgF/pX1W56rzRehBbG2EIGcOKi6CsfKCseteVdhG6qDGkfj91zuZHwZzIDt36weWRBuKr5YdKmCQMrd4ChSrhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750227849; c=relaxed/simple;
	bh=0+7+SdhQFxBtloXnri+sSUQL9w7ZW/ietI51ZFQlB+8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WvNLA9PaIibj+XB4SdJ9a9hhP4fbczhwBdSPpuZtpDbVuNC28IzhGehl4CHLLbwc91s4oWWNiJ2Irv2UoZVzitjeSYfLQxX2Zcbme7wRQTPJ0xCcZ2aS2lFwoBUrZIODoqF0m9LmgUtVwWoJ6TYSZOFSu+GekQXFdWvhsUf/Z6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CuybbIuI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i0Xl5uqh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CuybbIuI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i0Xl5uqh"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I1tpBl020478;
	Wed, 18 Jun 2025 06:24:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qEbFyuw6N6yID4GIfcGmuRLJ3vtVYl6mhfHHKJZ1JEo=; b=
	CuybbIuIYgJwCCHpAqFB1O4a9NTjwn63l7IgaQIL/3eLsAE6P88nZu4lsP0v4hHe
	ZpFui0PomwnGgDv7iiL54GaOi0bemdQYaHy/8bhUUuUCvTbih2MOdvo5i45SkAx1
	kpjUYo5muWc9gj/6/1cEAs16rnLl35H+BYlwwMx8SlfyfnE6MDXw0Oji8LDDPzW8
	hadDjESx9DHDythYUpZFYvIZ3gn3UGsaqW0WkjJnxcYj9s9uiyCR2GRWK13KB5Ps
	NS2w62ohUgBtSGLMrFX3deoGXIdRsAGI0dHyuYldMOdt2S6fdMjmb9JoqVZ7hzr6
	7LE4kCui26gLwEtCC1ggxw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 479hvn6fk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 06:24:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55I4eIbx025892;
	Wed, 18 Jun 2025 06:24:00 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011030.outbound.protection.outlook.com [52.101.57.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhgg2gq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 06:24:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H6q/kPPMvE+QAeZDmAGoUQmLMr4Nizu3CcFoZb6lVg4OyBnum3wNXy8EEnOQWNC6jdLNI/nBbgWvjnySOlb3t8ZC/jA/ADRP51s8appozfxURw/GQIxUWhyx1089Kpm9PZTdeQ6SSXR8K2mHEcKOwXT1L7iQwN2qRI47hZool39fGzjMs3dn6miST/7720qEL/Y+ZF/bpqnHAcVgpFghzKH4c5C9+jVnUsBDfn96dK02ReSqw+1ukNdOc4ilNE2AoG5ncHLtjIdr/RNdhcTXzPGb9AzdGU9YOm31Oy3BaY5Wz5BLnFWdaU3/ikax4CL/+G5Rjd4euP6rL/59Cl9VZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEbFyuw6N6yID4GIfcGmuRLJ3vtVYl6mhfHHKJZ1JEo=;
 b=mmChDAIzi+WXor+mC0Yxsp649VAyE/Q7kshkk4Ik2iFXS/RlgHfUWJi69/qeSH7wkL2wbK1/14d/l7BasolG6n8wTIehjdw9p8DhSRQgx1iosQnoPOPABN9xhbRNH3I0A+yK4aC0GFPOGCs6mHxIfUFmSfAnVunAvF00P8nMDs8IAOZlj324oXGUya7W4ylHR3A2IVZD4u1bEm6MZzjXdQSwaZjJScofWM3cDg1MK/JpPIV3Ner4XoF409Nxpd85eOLVHYPhK4dUR1uls+04+lIcCbpZx8ThfiwIX+R89EL2Iwwh6T/Tkb2d5a0w0n5DCsOwBOmu8uJlFVmqaC9NxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEbFyuw6N6yID4GIfcGmuRLJ3vtVYl6mhfHHKJZ1JEo=;
 b=i0Xl5uqh/HhG2/rLwpDDn46UzHMVUB/Rcy9I6RwvmROmMJYZ7BTSLHygkonAqKXMfw0qpYkwYH8U9Xtz2Rt1X/TzxkrVk3txScjqGzB2qgRh8jbEXrduBC+orb+tw+M8GRdkPQM2iIHy5Jn0VN8WllWguL3rwyI+KKOZBLVRjU8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB7390.namprd10.prod.outlook.com (2603:10b6:8:10e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 06:23:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 06:23:58 +0000
Message-ID: <5fe77b45-750e-4f97-9dbf-4c48902b190d@oracle.com>
Date: Wed, 18 Jun 2025 07:23:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] xfs: rename the bt_bdev_* buftarg fields
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-6-hch@lst.de>
 <1ef589fb-a8c2-4b2c-a401-a1e2987d21ba@oracle.com>
 <20250618051024.GD28260@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250618051024.GD28260@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0013.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB7390:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e3b5241-2506-48ff-5777-08ddae30b567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZElpd1hjVGVZbXp4NkpYcm1QVFlUeXU0RlVFUVBHMTNXODNFaU03OThuTnlk?=
 =?utf-8?B?cTg5MGljSjk5Q1Zna0kzeWorMGhwSHFRT29IWmpxMWhIdXhzSHU4TFNZS0VU?=
 =?utf-8?B?bS9ucTlScWlSRk5WVU8yYXlSS0g2Nzhpa21HMzJOL2Z4Z1N0d3hqNW1hWklX?=
 =?utf-8?B?ZUUxYnI1QWxlY0o0QWxrOWZyb0l3enczcnNmcGR4ZGFVdTRXQW9jdlMyRSsx?=
 =?utf-8?B?dUdvTk84QW5RbEhYTHorVlVHckFhSGZaOVoxS0dwYVdqdGw4ZjhjbWErejJ6?=
 =?utf-8?B?RjlQeGtRQnRIZE90UUhuUlpybVB4MHFUeXM5R2NINUJncy9nRHJ2eVNBTHYr?=
 =?utf-8?B?Zi9HQmwwaGZrN3g1SDNCSUxLQytsTkhrYmhFKzZSNnVsWW1xMzhIZ3FSVmVZ?=
 =?utf-8?B?alFEVSs4bFBRSmlYaXNBd1NqYnF4Tk0xd3hka3ZZNXIxVytRR3YrRTZvdTdC?=
 =?utf-8?B?VlBjSFBXanBncTExRk0vVTlDNDNJUTZyenNpak5nSVVSaTZVVUpQTXBWSkpy?=
 =?utf-8?B?dHFLaDlXRktINTFOSVlFRnRNQ09HdzYxRi95aGNjWUQ2SDhVTmZNNlUyRzFB?=
 =?utf-8?B?cEo1V3BzYmVUL1h5ZVdmbWl6RG51dWtERXM0VGswN0ZJekF5cVdKeU5COUpU?=
 =?utf-8?B?RzA0U1ByRUhSNlpPVzVYZXZxK3JZSzJPcnN4SWh5K0pHbFBTcEJ4NWpoeWlW?=
 =?utf-8?B?MmtXMENtMWZpMVA3V3lHb0hjdEFyaWhtcnBONm1YT1JtUzMzSXpEeG91MWgv?=
 =?utf-8?B?TGJFZkhQMmkyVnRHSHpQT1RzYkx0anhmQjRSOC8xL2lWbmZBaUhuVllvbkJv?=
 =?utf-8?B?K1JqSDhBU3daR2RBZ242dkhlT2JmZGk1eUlKK2kwODJZN2FuRzN1a1p5S0Vk?=
 =?utf-8?B?MTRCVUM1SmpIbGZleG1wSUl3cmZYRlpQZVY1eVdwTnJwemlYbUpkd2NjTlhV?=
 =?utf-8?B?cUlFeXlxUStZbEVsR25PU3YvUHloYjYyVTRDenovcU9qYWk2RW8yMHV0bk9N?=
 =?utf-8?B?c0lOa09qYmU4SmUyVCszakg0cFVQcm9DbWFOdTgxSDR1MUFFcnJNTzRQM3NE?=
 =?utf-8?B?Z0luNzR2aWZBZ3lySlh3QmhVT25QUUoyQllJSlJISUlKb3BEYzRib2VrOUd1?=
 =?utf-8?B?UStvVFMzMmhWdFBLT0I2elJ2dksvcE9MTFFMTjN3N1p4MUs4UXgyMzJ3Rkpz?=
 =?utf-8?B?c2JIV1BXUXdWRkFQZ2Y2ZFBoc3BFdy90VitXLy9FaUppUmJFRU5iWnBJTUNX?=
 =?utf-8?B?dFlZTnhtb1NFMGJwaEloT2pJNU55K2VZT0JueXQ5Nm5xcXB3RHhPQzd2SVpy?=
 =?utf-8?B?a2xiN0JoYm5KUlE0RFQ1TitDcU1udDlmaTJJY1BKMzdKS1FHRDZJZnM0QThP?=
 =?utf-8?B?bXdtcXYzZngxMUo3anNBQmdhVnlCcThxbUo4cDJsa25idW1sbU9xeTRxVnlS?=
 =?utf-8?B?VnlpYTgzZk1UY1AvenhHaHlDS2d5a0RsTzNrV1puN0dtS1QyZS9Fck5MY2VV?=
 =?utf-8?B?V21tQk9VOVkyM1Q5VmJmclhKZEdxUytkYldwVmhubTNBQytOMkQwNWpIbWZQ?=
 =?utf-8?B?Z2srM29ES3U4dFYzMjFNWXdpWnJZTnNPU2VKa3RjQXlwd3luWlRuUVRjTVI3?=
 =?utf-8?B?eG5GbnRObWVVSThVaHNRZmROV1pQZHljMzBmSHp1aFV1SDVpLzZrWTBQdnow?=
 =?utf-8?B?QUZNSmIxWjgxSGpOKzI1Y2pSRU0vcGlWamdrdVZUT2ZaaG9tVXcxWHdKSURN?=
 =?utf-8?B?Z2J5SDdsWDBDMXh2YS80NjIwd3BWNDhMbU1BK3dQL0c5aHVYN3F1dGt2dkhs?=
 =?utf-8?B?ZmY5bzhZdEQ5SmVzZzFiVEpuVnlxejRxZFRhVk5EL0k3RnlBVGN6RFR0ZEhk?=
 =?utf-8?B?SWwyNis0dmM1aHo5ZU8wMVJ5aCs5VktuSGJ3bVRZeG1DcXpEYzBnS25UWXJB?=
 =?utf-8?Q?+zN+xZQEe9g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YW5LanBtdW9QRGNwbGl1TzBWSjQ4VUs0S3RaTlB2ZVNNY3M5M1d3M2NvbXJn?=
 =?utf-8?B?ZWs4NmhLNUVITUZhMFRMS2pqY3JpTDliTEUxTWx5UFAyNlJyTVVpclV2NDFh?=
 =?utf-8?B?VG4zbjBJcWhRUnJkLzA1aTR6L21zWXRRaC9ZeGxKUjZFMWRneS94cE5mY0JH?=
 =?utf-8?B?VEFaeHZnbHZDV0V3R2RRS0E5b2xWMmhUMzJ1QUYrcXEwZWgyeUlKcEFHY0VZ?=
 =?utf-8?B?WXVUWC9GK0JHK0JHVVJOS3k3cndxUVpBc211VWUzN1FScjVYditjeTgrN2hS?=
 =?utf-8?B?S0YwOUZBSkR2ZmhUemJXUXNBWkNyWHVJd2RKbkU2TmFJTkhQSnY2SS9EVWs5?=
 =?utf-8?B?Vm1xSzlzb3owTk82bk9NcFNqNjFqRVM5VVVqUWZlTlVsNGYwYWd5Ky9CYndQ?=
 =?utf-8?B?TjU1enZZUTlvbWpoWlErc1lObkxKaEdRM0FTNUpDV1B6YmplNWgzejBteW12?=
 =?utf-8?B?QWhTU2hFRjRoZVlsbXhydU10Q1JPVHBkRWNuYmsvSk5leDRFYXNpSHJTNTJH?=
 =?utf-8?B?Yk1NRDFzYzV4bjNvc2RDYjF0eUVETEloaDMwQlN2Sjc0bWl6ankvQkdQTmlO?=
 =?utf-8?B?dW44ZEcrUlRKVUZRR0FGdjB6dkdHQXMzb2lzRmRBV1lZR2FvK3lvL1VSSmEy?=
 =?utf-8?B?S1hWemI5NUVNTm9vMmdyMVFBMUxkbWpGQWJhaFBIT2VHdEdkeWRLOVVDTjJG?=
 =?utf-8?B?akppSlk3WnY0amExZGN4UlBSVEZ5ZkhhVlY4Qm1MVndYaitLSjRuUFZibXBV?=
 =?utf-8?B?WFVtMG4xLzBHWFQwQ1JwTUdQdlozWkdOckdIdDk4N24zbkFBM2RsdmoxQklk?=
 =?utf-8?B?ZjlNNkV6UmtYMkFIaXBjaE9vczFWUVphbXJUQzFEQnVHUmRUVWVCWFFYTUNl?=
 =?utf-8?B?YW5idG9CWGRlNFpLSTRucTF5V1d1YzdKcWhlUXdpL3JwaUZTa1kxV2x4UkhC?=
 =?utf-8?B?MU1jNzMrOWVDaXlZK2FnMHVMVDBudG1tV3hKU3Iva1BuTUZ0MXlpZzRBczll?=
 =?utf-8?B?VHNUWTFQcWpGWGlUeHJxc0IxRTRsU0YxTm5kSkgyV1VYcERmZncyNTRSb0l6?=
 =?utf-8?B?bnBSRkZpRTU5MExVUlRBZmpUcmVXaklPY3UrbmlldTRQdFI1aDJXazhUT3RM?=
 =?utf-8?B?Sk45NmxsaThXSHNRZzNiQlVzd2Nub2xQTFBrVzByeWtNM29KUFdMYnhER3lU?=
 =?utf-8?B?d0Q5ZHp3UWN5YUszVVE4blhOTWZrQjYwMm9xN0dkRGNpT3F4bkpOUE9TSkQr?=
 =?utf-8?B?NjAyK0hCVVl5ekRmVXNjM3NNK3o5aVFvYmI3aTl1bHQ3NjF0L00ybFI0SDZp?=
 =?utf-8?B?ZXBTeG1pL1ZvazJZUHh5N1NxTVB3Y2duOVk3T1Q0WFFTNVBETGhTQTBKMjRQ?=
 =?utf-8?B?Qk43TDVPcDJiNldhQlRDQzZFL0lUUXVaOHhCZnkxWVRpay9uRGtwMTZ1cEtY?=
 =?utf-8?B?c2FpS1VQblp1akVwYytXcmJaUVo2M2tRT0pha2I0VGtoTVhxdUdKZVk1ZWJC?=
 =?utf-8?B?VUZEOGprbHM3a2h2SHJqc1FJbU1wejdiUDd1cGtuRTlyOXZuV20vQWFLbnk4?=
 =?utf-8?B?Y00xQ1pyK2Q4c29oTFQvYlloT0IyVm1oVlkyOTJJdVJJbUFsUUxNcjVwY2Iz?=
 =?utf-8?B?NTZzNSthRjN4ZkJhVlJNSnh4RmFiNnEvaEZGenJNOGErN3IwYXVJUE5xR2dl?=
 =?utf-8?B?dHpLY1cxazZ6UFpmWnc5bjRVbVZoalYrUW5XazBqaVR2K255WGx6bFJBWmFV?=
 =?utf-8?B?TWtvTGhuUElDU0xpbEFaaWV6SUVacE45Wk50emVBRFJuWGNwZENCOUhmemx0?=
 =?utf-8?B?ZldJYXlmQUYyQkk0NEdSSnVuNXp5UDhZT0xGOEpjcDVha2g3cUVGTE0vQ1JB?=
 =?utf-8?B?S1VwbzNKNitTdk51RGVyeUc4U3dWQXl0K2swNWVkRlJqVlRpT2FvTmJmTnpU?=
 =?utf-8?B?VVlNak5wQTZmcC9HdFBEWG5JNmZPWGJrOVg1R29hTnpUZWFhWDhnczVKL0xz?=
 =?utf-8?B?MVJmOUtSOVFTcEdQSkFOZmVIc2VHTzBVWFAzTzNldWtzYjg1cFhtTnAwSEpa?=
 =?utf-8?B?SzlDRFE1ZzVDclpLbi8rM29pUkxJNFFwdE1jSktHcDIyNGtXZ2RLZFYyT0ln?=
 =?utf-8?B?VjVPWFNJWi90M2Y4ajQ5b0V2bGR1T0oyWThzM3A5QXUrQVEwUUFkM243S09U?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iy2MsWiuAGNHXmOPgIvQk5SzUWIqTxmfq6ssFwXU+wMbASac3Ow2q1kTiXRUHbpyknf6FHGDLJaic4/2xMeKL/bWasRMBmY0lPHRXeRkUxnQA7wmFL+/C9F4Gr99mxd98WYtMz0wtwdwZ8NS6a3nzkuxoT8sOS5i9rtF7AtUQAcNnxrZMa62wPsFNjFZqTraMaZkrFqlSNXx13A/GJYIGGOH70FhWqBz13a84CKPef8MH15iJPVp398rLOfRl299/rRjl+MJJfz0+77bJfFTgiYk+aOzLqtqRbHxmMo7GJuJu/z63hG+ZebBMZbErp9sfJsog8/iBmGcqab4ijWX2VXRpvdQr96A2ghCFWOoKbHfH0pEydQGi/v81jwkrUwzg6FJdxBlOFqPhf5JoPxoRq7ww/hodKslK0VgnFUn5aTkK6x2eTNCX2HmxB0TJdolFBbUwpOdjstytXxDVQ78s1ooKrMX1rLSF6zYZv4MmnuxRAuqs455wR4eSFwUIrVVc50lhon8kB64CnbWvdfxz9ZqYeo72acIqOZpUkWSuomiUtsgflFup+9M5WQn6D2hL1fQp9hq/nmXzQtI9sRhOV6wYa2LwB444TCSgrF1qOE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e3b5241-2506-48ff-5777-08ddae30b567
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:23:58.5445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEwMn2YfWgvjuO/e52IC6hXZ32oH3Fn0JAphiUcFdjz14Y0yxkihNbgvm9yOiE2+tM20Pb18yww4l2xm6v4/Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7390
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_02,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=961 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506180053
X-Authority-Analysis: v=2.4 cv=XeSJzJ55 c=1 sm=1 tr=0 ts=68525b81 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=d1ITJ5EaEmlwJYrD11gA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: H8VNJkon8YTVMBTnvFLskIvzFP5xJ16X
X-Proofpoint-GUID: H8VNJkon8YTVMBTnvFLskIvzFP5xJ16X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA1MiBTYWx0ZWRfX3XjkKVocqso5 s44sDiv6qrP2cmROKXq2wJjHIytiEnFQ4NKUaP9zQk3h29tbhQo57ikebB33+FL0CN5qUhl+5UV 3vWHU99UEq15A3QjIohK0ecufJQtyC8ze0A1sqJVFFEMLRj00r9u9AombG/7Y7Zgnepzh6wh/Ez
 hDDTzsA+EjDiBfv/OG1zy4cvtLHeTCdYnV2pKXt6gDLnQwkQ0S3mhBxC0QJtwUJLD5lp3hLAF7x 9ShrwzsGb7DFmHRPXx3KeWGs/fv6/1QfDzdPImLyPgvVzs5u8i29CwApKjA72Z9MRo1AUOJxn8t G0/acNxfTDW8YtAlERzcZYKvl44uAKfs5orSAd2VyzpYCFpnf15SfC1AA07asNJ0tT0SCsphXrs
 tgPgqGlGZS4n3rrin7ai+M+AZAD1zZLjRiX/izdeFm/thk6hw8VR1gdaSKYsJ+Q9Q1p/L5Vg

On 18/06/2025 06:10, Christoph Hellwig wrote:
> On Tue, Jun 17, 2025 at 01:02:16PM +0100, John Garry wrote:
>> On 17/06/2025 11:52, Christoph Hellwig wrote:
>>> The extra bdev_ is weird, so drop it.  The maximum size is based on the
>>> bdev hardware limits, so add a hw_ component instead.
>> but the min is also based on hw limits, no?
> Yes.
> 
>> I also note that we have request queue limits atomic_write_unit_max and
>> atomic_write_hw_unit_max
>>
>> and bt_awu_max_hw is written with request queue limit atomic_write_unit_max
>>
>> But I don't think that this will cause confusion.
> Should we switch to the request_queue names instead of the nvme
> spec names here entirely?
I think what you suggest is fine (with bt_awu_{min,max}_hw). It's 
concise, while the request_queue names are a bit wordy. Maybe even the 
_hw can be dropped (from bt_awu_{min,max}_hw) and a comment added to 
their definition in xfs_buftarg.
