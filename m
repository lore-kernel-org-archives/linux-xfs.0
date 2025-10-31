Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6823385AB;
	Fri, 31 Oct 2025 10:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761905907; cv=fail; b=nIA+EIqUNtwYJKqkWPOY6BT994tA9l0Fun9/0bugrL5gw4SpNJ/oOhL4eF0caMjUB48MV5IbiJ/uuvY8EJFbD8iRvFLG8Ge9AybhzBKWLj4gwXrCv7HaZdUcmXV2jmFTdPXu/elM35La58tqbF2sxJkzvUoenH8/BmLVJgUJYpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761905907; c=relaxed/simple;
	bh=2AGprOC5XnizeQGAGZZzom8VOTRSyMJEhQKCDbaMGx0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JCPtOxRdw57VbCtI+nHQf93mP4i4DWGV1GpE7RZgZ8cKTiLlxs0wNuc5HTArW6yR9c3ziXaTBk8KeB1Lpjz4UfrSJq6N18oQ6uI5LXbYDvE1XvUT/XUpT3NniOShZcepk/zGnpj3U2gYMvCCii2BJjYLLhNeKx94T1vfQw/lQbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DV02/M2/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B8Kcx/kx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DV02/M2/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B8Kcx/kx"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59VAEnZr023699;
	Fri, 31 Oct 2025 10:18:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=88s1yyk3YZJBDEe5LxYFRGbUpF+fBEWLo5GII7oQoQ0=; b=
	DV02/M2/9Jr40xOtB8R6a2KFjqWxdeFCF3hiLztUXFD7KZVmXBebV8aisTCr36Zv
	DPwTNMOsPZ9fc3+SpkOTnseSbohMKsv5YgXXrwA48pc4fktzBM5vHxd6hzZ+fAT5
	mGKz+gS/2eOn8bJmA0P9m6lgKYDTSuVW34Yter2GzBnX1apsyobsIXn23cJK1/Ot
	6vBXKJy/9DuQB2jTHyuGZpTTqI4/IF+qjfceKn+nltQjUG3RGGv0Nefhh9Eh7xwA
	owzInZOwP5X6ctHN4nULSV1sZ3z9oCj+GjHKiMvIwXudwo4np8bTy452HAGDoIUs
	ne0H9HUaqUbLmmhvOoyIMA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4u6d00aq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Oct 2025 10:18:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59V9xTcQ000472;
	Fri, 31 Oct 2025 10:18:17 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010040.outbound.protection.outlook.com [40.93.198.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a4k7bp6sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Oct 2025 10:18:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BMwRgH9H6sGqsUVCmv7YJUjk/Lt/zPFLBccKfSiyxcSssoGlKRf4IgAD/0o/+CURXlrplgC4gPTjTVF3c6U37KdHAEyhluhK1oFx3weJRF4Du7ADMo5pgKYVpE4OoaoWZ8soPHWOhIxFK7xZn+sxKRwgwkqufZPkIQ/9wuHihijPLW2esGuFNsAZAqwCJtwPkt/PbzqdMSAIQnQstD3FDmoNnAhlM6Bh9K+2Dm6G1H74PNbLkbyEX6CcT3G4CD5vmiQ5WLNAR4aBeKMAlwQ1rWGa6sPijtBRFfejs4kAIUWq3e70sDzcwq+dn93MtlD6ue9lFa9SUoVY5+BrWK1mag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88s1yyk3YZJBDEe5LxYFRGbUpF+fBEWLo5GII7oQoQ0=;
 b=GbuhV4BX/5Twj0AzPGIByY1bmre/s1+hPhchLk7e8/zMRRt23kzPqpOsQQ8gcMPicDUaWMb8cUYvC94qr8Vm3kup7TngAr4RCAG1VyrNLecrWh/mFL3xVxijKRSZ9DhMq44UT/HBOFgRIVh6wTmGGSMotBSmicEdjCdxB+BWG0oP/CM7D0DvQuiPUZqBmhZ6BgQYEaDoygX+glnO4Q3ObIljauzgUr75t1A64sBj+OQU3WBUfjU9hC1w2wd0nxMVQGHEem425fJlucs6H62UVeW18KMurV/u9pxh2Csh8GDOYSd0ODh7drNVAgnkd1iSJRw5FLJpB+aRAGn+LsuSjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88s1yyk3YZJBDEe5LxYFRGbUpF+fBEWLo5GII7oQoQ0=;
 b=B8Kcx/kxQZNjU3SvGvFkhsTXD6D61iw4ixLtMGpjOzD9xuIqi4XdyBhQ2Cb7miTyrB2gWW5ZRDyV3/04r4myFIT+K5qi/UVQzQV/NaGkjlRHKkeXvc1NMPTHj8LfQxG9XZTDc4pNang30Lzg08x+WSD8JaOIf96fkPXvBvNnCBw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ0PR10MB6351.namprd10.prod.outlook.com (2603:10b6:a03:479::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Fri, 31 Oct
 2025 10:17:58 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 10:17:58 +0000
Message-ID: <d787aed1-19ad-4fb9-ba64-33d754d46e5f@oracle.com>
Date: Fri, 31 Oct 2025 10:17:56 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
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
 <0c25aaf1-e813-475f-ac7e-a05e33af91f1@oracle.com>
 <20251031043024.GP3356773@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251031043024.GP3356773@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0071.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::35) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ0PR10MB6351:EE_
X-MS-Office365-Filtering-Correlation-Id: 05155881-b52d-4c28-748e-08de1866c3e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2dXT3VhWElrZXZXZ3c2eW41WmlzMXB4aERzN1JmakRvMVFtRGRSd0RFZDRT?=
 =?utf-8?B?Tm1OU2k0ME1XZDA2TEd3YmF2Tm9pcmtDOHpKV3JiQkp2RU93eEhEdkRpZmF5?=
 =?utf-8?B?bXFTYlFhdHBiZUhIbkhKbEliYVdyZFVIYUdqVlJDN1JnbmdqTml6YUdqSGRl?=
 =?utf-8?B?Z3diMjVyODZraWZHNmJaVlhudmJIWTBFNUFlUm9oclJnOG5IbGV0MVlNRUFL?=
 =?utf-8?B?MkpuS05RV0JWb1RsaUhaMTU2bG1QejhOamI3NlE5cllrOGRKa3RVUFBxQU5y?=
 =?utf-8?B?ZDhGcC9ONnhKVmNmMytBWWpQcUlRdEZWbDlaY3dSM2hjTTYzYmhlQjllT2tR?=
 =?utf-8?B?Q2orcTVjQjNmTlBRUGhhemkrMlh3ZEp5ZlgreTNpbmwrblBYZHlHTFQrMy9J?=
 =?utf-8?B?TjFrWlRsTHIrS2MxWncza1FvNitRQ0hpUmJRNDhWUGVIaHFVL09oZHQ2Smds?=
 =?utf-8?B?VTdWN2ltTzAvUjRwTldqbW5HTmU2Y2dpem81ZDVkTDlSUEVaQ296c0F2SElu?=
 =?utf-8?B?L0FvUTFhTmE3RXp3bDV3Z1RYN2N6U01rRU1vMlkwWDNTVHdsRXVTcjFFY2JK?=
 =?utf-8?B?YWN6YmNiS1VTT2NocjBjdnlsaGF0bElPYW4yWFFVN2Jmd2dZNmluRzBJQnI5?=
 =?utf-8?B?aE5Fc0F4L2FhdDBWWnhGYWNjYmZmYWpaeXFRZ1Q1ZzRQeUFLQitEdFJQZWxj?=
 =?utf-8?B?MncxRTRqOUFGN2svR0pwVEcycDZqVm0xMTFxdVI4blgzbnFpOHlSS1dQSjNR?=
 =?utf-8?B?aVl6ZGZqL0h4aGpHT0M4U0lJa21rM2JDT2RxWXVSNFBiTlJtN3NwcnBFTVd6?=
 =?utf-8?B?OWtXbEVoU0JpYzlOSzB4YlR6Mkc3TEE5WUU5ZUhJTzlsc2ppWnhFbHRJVHZI?=
 =?utf-8?B?dEV1Yk11Z0hUTjFrY1IzZElsY1ZVNVpFYXVORStYREw3VC9uUEtiQkMySmZk?=
 =?utf-8?B?MkFWV25VSTQrS2cxUHU3QkVRSFo0dHdnWk4vNnpTSkMrdHoxN2N3enJMWC95?=
 =?utf-8?B?R0t1eVA5VXoyTEhxL0tPR2M5MGt2aDA0SlNmVWRKbTk1Sm9pRUxGZWgxV0sz?=
 =?utf-8?B?cDFWd3hJN2NLMG1zSmhIeXpFYmZKaDZYTSt6MzNiNnFjTHhQNE9lTXFJSUlB?=
 =?utf-8?B?a3JQSGZCbzF4NXo1Q0h2aUYxSzUvTFBBOUlDendUY1ZRWmR0WnFxZ2JsMGYv?=
 =?utf-8?B?TmZFMWhyS1RGSnh1eUF6SXUvT0hCYUQ3OE54dzBibXpRdnZma2VXOHA0azhQ?=
 =?utf-8?B?N2xMV3A2S0tKN01kUGNVQ2tWb2hrSjVrdXUzRlBQc2RZMVdrV09XaTBsMVlX?=
 =?utf-8?B?OVlOdEJROVlFdFVpQjFjYXpHdm9uVXB0UExnVzQ4TlBWTkdJYXZ2QitQb3dx?=
 =?utf-8?B?VTUyUXMrVGtDWWVHTm9kWVlnL2o0bnc4M2xZZTZ3OEJpa1hzYXJPN3Rjc1k0?=
 =?utf-8?B?ZmM3TllXYm8zOFhRNHFsYVBkSVd0Zkt5K2FWWGJ2TGFveU9McUpXVEF6Wkgw?=
 =?utf-8?B?MVVGNE4xOUhnVytkWEdqUnNmTXh6Z0dYYmNHMk1mK0d0anJOeHUxVE80dGNF?=
 =?utf-8?B?TlZOK2h1OHU2eUR1NURobFpZTWFONzZ6MnlTOUNUMWpMRnhxWjVBVS95T0RP?=
 =?utf-8?B?cTZPWVVPSS9qSjJ0L1VjZWZXMitDVTB0SHZOWFlpR1gxRjFSTUlSZ21xaGk0?=
 =?utf-8?B?cUE5UW1tenppalBYbWtwTHlVVUo3eXkxM1pxN3dWd3NydmExeHAzYXFvNEtK?=
 =?utf-8?B?eFpRYjU0Rk85QmFRMHBtSkpoOXdtN0hHYlkvMHNybUpJbEc1bmZTUWdQdUdZ?=
 =?utf-8?B?VlA0M2lQWk1TMTRhMHZlQ2Z1anROcnJWVm9uWjNWVG16OW5aVVV2d0ZJMFgy?=
 =?utf-8?B?Z0YxMGtYc0VYVE5NMVg3QURxSEVQbDQxamFGOEdNM1BZSjg2cHlXTTk5MTY3?=
 =?utf-8?Q?BDCmSF6z372pkOYZGaJIBNX74WhemUvO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUplUnR3S09sVWpZQW1hMFY4QmNGeU1JcDlVMFBtZWJZT2JmWENQbXRPb3Zv?=
 =?utf-8?B?SlJTaWZkNU1ncytRTmlRbFAvbUU3aWtrYzFBYnJra256Wm9oanUzY1RoUkNU?=
 =?utf-8?B?ZVBBWHAwdG14MWE0bXMzWDRYYXBTUzlzWUFYdHlseW9NR0tjUnZDRU9GN2ts?=
 =?utf-8?B?WU9VU1pSWkROQzFUTyttWUFGaFNRK3pTZktGc1FUbUp0MEFmeHJPWUlFVExO?=
 =?utf-8?B?Mk5mMCtxSkhLYkFUbnJHc2dBY2dLbVE2Z2lPVU51Sm5sSmc0aWV1UWpEdWkw?=
 =?utf-8?B?K1RZdUxxNGxPQ0REdTZwa3RsTWtsTytjdkg3VWI2T1hXZUVDcFFQcW9pWjNG?=
 =?utf-8?B?ckRVL3REcFNaa1EzUEdsakUwRkJ2aUZDL085TDJJSE84NG9ySnFxSEtucWZj?=
 =?utf-8?B?Y1JkcktaTEZoYWR0WG1LZFBCNjFKNWhZL2pyYm9NelJYemNsR1A1TFQ5b2Va?=
 =?utf-8?B?MXBsdEoxc1Y4YUhZU21Hb21PUk5hRWRGVmtFUmVZTHU4NWhJcjJJWkl3YzNx?=
 =?utf-8?B?SFhpS0pEdndOUVJGWTJHQUF4b3lzYkpENGRPT0lNMXR2TEZUQWsvZ3d0aXBN?=
 =?utf-8?B?VkRBOEVlNmlOdDJUS2Z4R0JCKzBneVlTWXlGTWhoYmltM3Yxb1RrSXdnaGFu?=
 =?utf-8?B?OWJuckVtMSt5VVVyTlRZWGI0VjNQRzRSZHdKVEdreW9iYnZRdDZlMGc4eFlV?=
 =?utf-8?B?cmdpNE5lSmFPblNBSjIzdU02TnZEdFhMMnh5RzJkR1BJOGtIeFBMQSsrYVA2?=
 =?utf-8?B?QzlNMEo3YUlOeXdkM3lBZ1Z6emRUNWZWdlRHTU53VXQra00wNCtvUmhPVXBU?=
 =?utf-8?B?VzBBdno3ZWdpZ1hGbFpPVzNzdENhSVNQMjZ6V2NYWUpjRnNmTHpyMU0rR0Zr?=
 =?utf-8?B?Rk8zaURSU2lEVlFDNXNtOTd6SjUwektpamZ4WnNQSlUxT0lDZkl0NmoyT1k1?=
 =?utf-8?B?NHFYRnRUdlU5Wno0N2R4TnVUb0tVanZxQUZzbjNSQndUdlV6ci9VVXlKWUNS?=
 =?utf-8?B?Q000MDhkb21DdFVRN1B4UTdva2dKVVkrQXlxR05qRDFFYkF0a00yWGw4UTJt?=
 =?utf-8?B?cVgxWTVLYmZuMllMbS9nR050c0JGaFJ4UUcwTFNTa0pMejZGZGlacHpFQU50?=
 =?utf-8?B?dHZFNm8wV3dnUjJQNEJvemRhdXVoQ2Q4VjJKbll0WGo5cXJ6bGJQQndXUU5X?=
 =?utf-8?B?RG1SZG5MaDFuMDh2WElMREltNklhMjgyUGhXdmY1eVByZGNVeXVmaGxFN2RT?=
 =?utf-8?B?dUFsVXR6NTBJNmc2SVBDTENJRERid204L3JPajVzRmw1STF3TnNtQkxnbU1x?=
 =?utf-8?B?N3JUZjJFd1AyeHdQVWhkaDhRV3JMaENWMk5GaWJHZlo4NURGdHlIazYzQUhC?=
 =?utf-8?B?aDFGb0tCY3hXd29SZDZFMkJjQnkzUWgwTlorL1l5TGhmV0pwcXdLclRENERE?=
 =?utf-8?B?TE5TNkNNTTZ2MjFFbnRMSDFveVZSZElUai9Hemw2ODY3alpoWHNFbThTNU1V?=
 =?utf-8?B?ZE9KV0trKytyTmc0MnVSS2lLYW4wZTd4WFZwcTNJM2RrNFB2ak1QUUg2NW1V?=
 =?utf-8?B?cjltZEF0MnViT0pDSjRVUm96dUd5Rmw5TEZOMTJYaEk0bTJvSEVjaCs1ZHJB?=
 =?utf-8?B?bDcxWUFVSGxTZ3FFeUR1dmNDUlhDVWkxeExOMzhvSjJFL0tQY05ZQXJydlkw?=
 =?utf-8?B?Nkt1Y2NVZzNNZmdtU3RmeHhPTzNJTkpoUjY0dXkxMDRSS2FscDRJWFVYS0d3?=
 =?utf-8?B?RXlyMVlseEVvYVRrOEt2TDJvM3lXb3dKNG02NGtTaENiUGh1QWFIL25wakV5?=
 =?utf-8?B?aGRkdGhiOG9EaFgyVTFLdXJBL2FFNHdwcVVXbi9mVFltaSthM0RmbGJteTNT?=
 =?utf-8?B?SnovVU9INnFCMDFXNkE5b2Y1SmhtcXd3K0p1cnBxaWRFSlBQYmlHWnZ0SUFF?=
 =?utf-8?B?dVhvcW5MczdSVlRFWFIyb1pkdlg1ZXpQcWhBc3NGQmM2M0NGblZuOEpIS3B5?=
 =?utf-8?B?TGJjK25pNEtWVnp4TEYrRFQvOTZNVXJXWHZSaVRJRTFsNXh1Unl4eEljUTND?=
 =?utf-8?B?NDhlVldDclVUQWVpQmxJdjl1ODhVZVpxamczR0hJYmNEcVNBWmpyRlFZTHlE?=
 =?utf-8?Q?CQ+alaH6PZkW8960kIIoImY34?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zopRlBZGMPNubLVO2ZW+p3UCNX5gaK1Ge3c2FIZoPoNkmV53PEowRd997LSnQ5HfE544dMfx3lPEqUQVQbVOVoWpFVhRO0wotoI5YVoojLSMKfUO7aWTg6InDqjUg+b2MxXCj4/gI0B1Op3jeTuLnwjf76ng3V9mQPd0yXkO6NZ3hS8L216bng9NyGw0tB/FevTKQROszvQ7fn6o2WhwcEZ/8hATdTRM/+UreE28YCja4zCuBtHUhDJ5LjpFBZGh5ikjjGUeU8/GVHIWPbXD9dW+kCp8UBpEKPKbVaYlYhio8hXQM9IlImd3Y0Oodf/A1Xx/i1v7lZITz6aKkrkqtc6WLGdiOCunflTfv1D5eC70vk9hqvzeqKmYG5ZFnPzw57FdP/h9P8bmU+ohpNVFo5tUBVtqvFQxfKojfZsD6LuFfv3WD/HjLCve1zFn1YsXUCR+ZmBOtgveu4sKq+lfLVTtTWlmil9R7w4VK5bqivohH/z+oL1NVwNzWOQ8eQWJ3M/kMAzwt40YsPOS7woQVn5/7IzWL3XtcPh5j4LtRVeIO3lSBBeyeE/bFuLOCGlW9MKdOUrq8dssxZGWorr4uOQptrQ+eCZnGpI/rKQUBu4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05155881-b52d-4c28-748e-08de1866c3e9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 10:17:58.7401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CL6F5vrw/dM8Dmsf22cY1XmqKs82059EpAXQAmbInc+gLanfzyZS+MrpFW+ND20j5k4JbSqdTq3QuoG++dgIRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6351
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-31_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=814 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510310093
X-Proofpoint-ORIG-GUID: qspiLQx8NN6bmSbC5LBa6O8C3tef78Gv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMxMDA5MSBTYWx0ZWRfX5cZnCmMR1JMp
 ziqXsxEkNqk0TXQWeTLZt9OMa1WMQp5aDRuHbgmPTNFXG91Mf2QuttyEl6QzHUvxjZIi32SNXDq
 YU/enzkxxytdP8AF3s5+vV29NWp8fY5IULMQEL0VxwcU5LgXqZZu+73KBxbzz/evC+AoZ25qtrm
 65dyHUO8/mxFrXf1yJ6lkKBRBPS+f81RZjmwOcMT9NHf973saKt6YWswvV0cvag7pVALmuJ9Jlw
 QWAbtuKZL0mFKIWUn2S3qktLYOe9Hpvw80uUX+ZzEpFRm1bOqqh4RzKJ/2pOBo063ozG+2CGmQX
 XqqSAifCl4pUGhvjSCJYkqq0juTrH8Tg1IuBUiutUIufIuHVK+F11VqJ2o/USTsG6/C89lGNI2s
 BcvFuSdumhxOk8u1IZp5oHBndG0wPQ==
X-Proofpoint-GUID: qspiLQx8NN6bmSbC5LBa6O8C3tef78Gv
X-Authority-Analysis: v=2.4 cv=OJsqHCaB c=1 sm=1 tr=0 ts=69048cea b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pCNJisRlXedQZ4NGwL8A:9 a=QEXdDO2ut3YA:10

On 31/10/2025 04:30, Darrick J. Wong wrote:
>> @@ -1215,6 +1216,7 @@ xfs_atomic_write_cow_iomap_begin(
>>   	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
>>
>> I think that the problem may be that we were converting an inappropriate
>> number of blocks from unwritten to real allocations (but never writing to
>> the excess blocks). Does it look ok?
> That looks like a good correction to me; I'll run that on my test fleet
> overnight and we'll see what happens.  Thanks for putting this together!

Cool, but I am not confident that it is a completely correct. Here's the 
updated code:

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

cmap may be longer than count_fsb_orig (which was the failing scenario). 
In that case, after calling xfs_reflink_convert_cow_locked(), we would 
have partially converted cmap, so it is proper to set cmap.br_state = 
XFS_EXT_NORM? We should trim cmap to count_fsb_orig also, right?

I don't think that it makes much of a difference, but it seems the 
proper thing to do. Maybe the subsequent traces length values would be 
inconsistent with other path to @found label if we don't trim.

Thank,
John


