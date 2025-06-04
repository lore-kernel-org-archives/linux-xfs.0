Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686B2290BA8;
	Wed,  4 Jun 2025 13:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749045546; cv=fail; b=mIjbX01pIdycyoacBfBS3RVmq/CIaJq9gLQxTJjdHHjLijbNU7rHDhcQbXCJgaBY8dBcShr2rmBuWjXGOuSEWRGfG7iKiJO9A0ey4Stuoe8wKwzUGcrj/G7aEzL72x757W90eLYZ5LVg5N7f+8q9AR+ZPRuOwtdFbOr35XSM0ZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749045546; c=relaxed/simple;
	bh=RwSSKPLgmlsVqb1Xfj62zAAkLkhijSUzFRgB4PhxhSQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E+5Fcj0OyE3ZK9GGcmbDigclvsU7Krsfr8brL0ZrMINZs1Wqna4YkKilkHNoNNu5dbWbkwO3DtDOmeUAvAM5KAwf6jUv74vmu6+z7zMHXyr+HmsVRXOyew+1BWT0axLQM2KvIiEWb2kENMePqbZ7ejgOv4eD1Li14fm7NHoy1Qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jk3/NoZv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C/fipJub; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jk3/NoZv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C/fipJub"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5549MdiJ025560;
	Wed, 4 Jun 2025 13:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5ZkAbCPhyVMtR3QsNB5g2i4TPvg5Bs6zzKJqw+t04s4=; b=
	jk3/NoZvn8k3ojGezt+Pjw20tigrXeitHRwdnIV5KPf8+UN45NLSm4q8QLvrU1HH
	G8yjFmtezoqzOV+pXsQfeunz76oo2sdYHMsIYbeK2/b60vcEkXBZQc/Ym+W3dF5/
	JTptqToe+FeoArkyBpdUrBuvqTULRMVta94lpQMSyVFFYmHtUnKUOHsv1blg/xAa
	O4RK9OFNsX0cKG+L52Kxl6shBmQ/m3rI1ZmJ/MVPEbHhIGGZtGtxKEdfkJXSKjxL
	XCN5zVhI9Pigy2A6D5kBSj2Bw/Rr+LKHK6NKcwEZH99QwhbRrSvHHPZJ0nhBiRMs
	OYxO69PMnif1C3X1JQhqTg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gahc4mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 13:58:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 554Ds5wv034815;
	Wed, 4 Jun 2025 13:58:58 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011043.outbound.protection.outlook.com [52.101.57.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7b1q29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 13:58:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+8eee0h4kQW5IOnfOV7uMu6pNcuHx2zBMBvla9Aty4tysG/kF4sLRVo2HHzlH4iNY8UQmRQ6hgrXGKROrlE9RWwagAblFhDwRzv+2+TElAQ3IBNWUJjtz3Z36Qf89QgcoE/rrCfn2SieT2MA16H+AT3llriO9wKTZEVZWhH+/YJt/u60EWUf+5cH0Lummhv6B+hJERSjUj063HBTqPHnwS8ilHZpCGLXpq4jSk3XlcfWjqxJ/hEIgZyLdZbnZC38arS35F9xZ3amd7d7S2f/RZwYhYYhqBFbxXLG34iB5KFMnRssMNiXxtlNbRARBr4GsGlqGyRFmre1+0j7cg6LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZkAbCPhyVMtR3QsNB5g2i4TPvg5Bs6zzKJqw+t04s4=;
 b=H04JBKIlhL9915HkxgpB96tDUM8Hi23X4Z2oXN0khH5RgHOslCV1eMpmX/k+On9JSiJh10BmIyop8jND6ExsNPj0jTdVM+V8mV+MvBHtm5GzM6daIyALEftwFWUqA/rLPkt6wWPGD5umVPvsQ8IToa+bVKLvs2nT4uRnw0xTSx4fzMPmzTY6v3Aqhy9uqcO5ek94tBaOyB/Q+jbGB8jLryyRbV3ltLdwpp9Fa3U/e8gXxaX9IeqcH5z3k64YHEzbAIj9QiXaNVAZL62ISOy3+XDvqsj6iom2P6GF/kBZSt3UhzeZw3LLcmaDkWgJ1U1NjplJxQkxuaLrIDGSSu+vFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZkAbCPhyVMtR3QsNB5g2i4TPvg5Bs6zzKJqw+t04s4=;
 b=C/fipJubqTuxCZq0LEbQBNZRW+7UbSFB6WtiXAeR3jGccOxLinwuS4ez4oC1KmFdV7EvZgs5eC/ao/IUu5BEqo0u8995+FaqklHPKF3R5h3GsWMQ4UCgLhBIp/QBorm3EwKMg4udjXMemaipb2QET1aTU49kJeS0mmmDVUidWiQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6993.namprd10.prod.outlook.com (2603:10b6:8:153::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.40; Wed, 4 Jun
 2025 13:58:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Wed, 4 Jun 2025
 13:58:55 +0000
Message-ID: <cc86c871-7fb6-469a-b4fe-c9de6fdf6ec2@oracle.com>
Date: Wed, 4 Jun 2025 14:58:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] generic/765: fix a few issues
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <20250602192214.60090-1-catherine.hoang@oracle.com>
 <20250602192214.60090-2-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250602192214.60090-2-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::25)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6993:EE_
X-MS-Office365-Filtering-Correlation-Id: b917d495-4240-438f-61d4-08dda36ff1d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eDQwZnBTc2x6Rm5MRlZHeHlLeVEyVEVtZzRQVjg5VUdDVm8ybTN2a3o5QXVM?=
 =?utf-8?B?c0E3YlUrWWl4MitMQVRDdnNtMWtQb1ZKYmx1ZHIxTnF5dDYyRFpMdHZnSmxO?=
 =?utf-8?B?N25rQVdtMFFYRHNkckprMVAzOENoWFZ5eWw4cWtuelNmcGZIbHVna0RvQlIw?=
 =?utf-8?B?TkxWd1ZIdmhqQkdSRHlOVXFxK2FmdDhZY0xPaEFuaE4xR29kZElMbENyeS9H?=
 =?utf-8?B?VS9xekErREQrVi9rakJuOHJYN3hlbVRCcS8xWGpxNVlwNlNJOHFWaTR4c1NV?=
 =?utf-8?B?UUVoVTlFbGRWTmUvek1GaHhKdEhXcDNZZ1I1Sk40ZWVIRFFvY3VGd1A3MkZq?=
 =?utf-8?B?a0xCTVdUT1V4L2pudlg2N0lXR2tYdTVwUEtBc3BSZ29RZzhSRDFjaUdISzVl?=
 =?utf-8?B?TmE0bFJ4UnN3OGRzc2w4VXBGdjZ1dG1rcUlSalI2dzJxaDBsOVJtWWFNeG9D?=
 =?utf-8?B?RzRqQmE2bUt3VHM1NldMaUlWWlIxTXJvK01ReVphTzZSd3oxREZidDBVWTlR?=
 =?utf-8?B?ZmdiczBvdnlkREVpRDRMTkwvRTE2c2ZHRjNyZUJSSjBFQVN5ZVZ1Q2o2R0VS?=
 =?utf-8?B?S3JmNitUcC9CTXBzaHU2QnpoYnpuOCsweHJrcmxYVytQT2IrYm83MTJSZnkr?=
 =?utf-8?B?SXpGcm1zSEx3NlhNb3NMQmRsTkdwb3FhM29iOS9ZcytPM2IxYVhtV0x6b2NU?=
 =?utf-8?B?QndVV0tjSWJjejdFYlR2eFZLK1QwU1gyZGRZRUZnbUdHcXRCNkVxdjBjYjAy?=
 =?utf-8?B?V0VKdVdQOTE0TEZLT1NvbyswcWFuU0ZOemNTUGUzY05qZ09tK2tLNnFaQ3Yw?=
 =?utf-8?B?SEhzUHJIN0p4YzFWcnZ5UXJacTJBS1lIeHNncC9BU3g3K3VmZVR6ajVScFIw?=
 =?utf-8?B?MHB3cW5HSG0zWEJ3L25Pc0MrbzJESm5hWUVtZzA3c0JZSisrc0xOYXp0RzA5?=
 =?utf-8?B?dWl5SVBrcVY0Tkl1b20reVpIVWxqUG4wN09ZSlVlc2FGRzZpcTNUTDQza2Fk?=
 =?utf-8?B?SnRIZHNMaVdTM090QUwzWkJQU2hFWWQ3NjFTOWhqT1diNm1BdzM2ZndCbW9V?=
 =?utf-8?B?Rmt2blpCNnVsc3RaeFJUQm5oRWtzVjZ0Ui9uLzd2VEdLSDlhSGs4dFZnT2tP?=
 =?utf-8?B?TXVQaGxTeWhqV2o0TlpqNTJjdVBrMVhpQzlyR1VMS3BjUkRMY0I1UmxFbG1S?=
 =?utf-8?B?bFVqbmV0MjdSVG55VW9kMGtrT20rY0ZPZEJtUjc4MGFxU1o4TzRHdjN4N2dy?=
 =?utf-8?B?OVFsTHE4K0RSU2N2L3RYVjFDci8rMEtvUTNVbCtnOC9RNm9TREF5VkdwWnhN?=
 =?utf-8?B?aDFCdXRYU1VQdUxESStQb2xkckFnTkJHTmtac0ExdGVTekRsZ01MbG9JR01u?=
 =?utf-8?B?Qi82aW1QZEQ2b1dDamZhZU1KUmZZS3Roci9QRFNSclN2Q0laSXc2OHhCc0lP?=
 =?utf-8?B?MnlKTHdya1c2bEVoK1hxOHhHcXJ1VGs0LzVZOHdPcTFnY3p3Kyt2VUZXemYr?=
 =?utf-8?B?M2xrWlFCcmJVR2J0SmVxYVdLeVRmaXllV3dscGhsVHJaNmxMTjRWSmVCSnB4?=
 =?utf-8?B?Z3A5NDhVd0lTUUx0TE5vNklrUU9VcGhiZFZxTDdQcGlHUFJBYWorV0lmTm4w?=
 =?utf-8?B?aSs5dVA5UXZaK29lTDVLNzZuYmxVQ2xMSW00ZjUybGwzZ21yWldaKzlsQTNp?=
 =?utf-8?B?amVYUnVjWExMR2F0aksvcUFJK2VWOSt1ZzZhU3dDbnI3Njc2dXR1YnJmZ1k4?=
 =?utf-8?B?cWd1aERYYkN0ckRyaWRBYzdkcVFQOXUrOXhRMitlWWdVTm94VzkxUHpTaEVn?=
 =?utf-8?B?cDRvaUxScEJkTFVBMlB0UFlET2FUd3Yvb2l2U2ZXVWFjRWVlYm10UmZvdGts?=
 =?utf-8?B?SnlDb0NCK21BbEVaaUtuUGw5cnpENVpndXF3Ni9rbXMxZ2xqOU9nd2VFc2FE?=
 =?utf-8?Q?H3uvm0cOSW8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUFQSThia0w5V1BFaHdIcUhZd1QrUmo2ekVId0RQSUVoZ25hL3ZjbDJyaXFL?=
 =?utf-8?B?czNldVJNOXVmQklvTjlJbWpSUjE2RHBocklMSTJjWTlVVTVyd2oySm81TzJw?=
 =?utf-8?B?NjkyRjZwNWRDbFAwRWlMUmY1dXFLdERDenJ1bFYxUDdzYUxzT21RdHBOYUJq?=
 =?utf-8?B?cjNzcGdhZFN3NWl6enVmOFd6VGg1UE92SmtzZld2OXlBb09EVjFpd1ZZYlM0?=
 =?utf-8?B?dFlFRDdKVmRRejZXVDcyL0t4OTdTZE1HWGxiVnJIbHMrMkg5OEpoSWY0Skdu?=
 =?utf-8?B?UkFQbFB5TWV6eTFUMnM5NFRsSzlCMVhHSWxhRXNWZG9VL3Nic21DUWVGSENY?=
 =?utf-8?B?eDA5WjR5ZlZtUmtWQzZGVEs0cEUvSk9UL1Nqb2V6NGJJMlJqZEJUMlVOUDdo?=
 =?utf-8?B?UnZwZkVvcWNOMWRQMVZaV3JGYlo2OFNoWWVsR0Q1TDVjbW9PaDJmQ1ZkR0p5?=
 =?utf-8?B?d0crdWx1SFFZRFFOSHViYURRbSs4dk9BbkREY2c5RTJNdUMwNkhtMWJMSm1O?=
 =?utf-8?B?Sm9vT2dHamxLb1FxaHN6WmFxeFFRS2hJVXp4cTRVNGd3QW5JcHgzWGkwaGk0?=
 =?utf-8?B?bHd4YmVCaFRqbG5zc0lhakVRL0lJeU12QW9oaGMwa2phd21JMURSZGdBZ2ts?=
 =?utf-8?B?ZkNjUmhCellvQkNEViswbkJVWHdlK0ZjVkJVM28vNUFOVU0yeUtRTXQwQXRw?=
 =?utf-8?B?TGlQdnR5RnJ6aVdGVHVMVFNpak9EVTZtL1RtV1ZGVnJhSjlKWE9nWFJDVUV6?=
 =?utf-8?B?NTBuSHpLUTUrSnNJNFk5djJLOXhsWm5YM0tvNFk4ZEZsRVdlVHpqMi8zbXRv?=
 =?utf-8?B?dWhUcVllSjhqWGRneW9jdENoSFAvQWsxK0ZRWVZTSURRUHVZQTkzNXBqM0I4?=
 =?utf-8?B?WFNIRDMvZE9CSS91NmV5R2xDTGRjSkxmUzJNWkhYdmhKUTN6V0NDMGxlQkRH?=
 =?utf-8?B?b3E4cnVlNUlabHVkcmh6WDZqVkh4K0xFTDVmTTgxSTUwRVlJUURTRUpQTTNp?=
 =?utf-8?B?WE9CcE9WWllrdm01bU5TVzE2aVN4MlJZdTIzKzk4dzVwMTNFMmRDaFFGOXRI?=
 =?utf-8?B?S2ZWY2pXVmY3d1FqMjhxYTcwdTJ1LzhhUVlKVlMvRlFtMzhKODVOZ2d2Z1ho?=
 =?utf-8?B?aEdlUnh5NHVpVGs5cUVPTnpRSjFQU0VncGtab0ZRcDBwVTlydlN2ejQyUmpu?=
 =?utf-8?B?VE1NQVJkS0NoLzByWjJ1RG9zY0l3MWxWMERlVmpYNGM4TzJQWGlrcGRTZzZ0?=
 =?utf-8?B?ZnpFT2xudWsxV2JUckFOZnJaRFNIWGlXWFRLcFR4K2N5dE9ucS9Nbzg1SUND?=
 =?utf-8?B?aExVZnFFd2hrTE9IQ0M1cEVibm9HOHY5QTRUNjVyNDR0Sml3ejAyNWp6Ty8x?=
 =?utf-8?B?WlZ4V3pLZXBmMDB4eHhFUnMrL291c1JWWG9SMUNqNm5VVHU5OGNyRmZNcEs0?=
 =?utf-8?B?ekdEVGVlVGVDNUhsQm9EUjBHdE1ST2x4NlBUdWRvMmY1Z0ptdUFhcGtGcVVv?=
 =?utf-8?B?QUVsNllmQmhIcDVWQ3NuQW4yaE9RL1ZWeFhxTWV3d25JdDM2NWY1WURLZWFL?=
 =?utf-8?B?NGtIVTY3d3NBQmRBQURwUHdTN2ZLN0tDUURYdjk4UTBBWDltZU9RS1NDVTdo?=
 =?utf-8?B?NEtZRmhNYWs3Z0ZIb1R0cVdtdWtmSmI4eHBYRDhFYjVXcGlRT1k1enFGakZQ?=
 =?utf-8?B?Z2w3OVJEZmE3STZ2RFhGeTEwTTlsWlVLVUZDUkFNOEVnMko2VjdpN21iNUVv?=
 =?utf-8?B?UTVzZXJEYzNOd0hITUpnVlJBNVlsM1VoWkFLYk5ocmxrdWdOSGpUSW9LeW5T?=
 =?utf-8?B?WXQ1VzdNOTRrOE94TlRrUk1sZmpKcDlRakVYeFQwL0Z6RU8vWGdDVFhpSlE4?=
 =?utf-8?B?UFo2dEFyZSsxVjFNN2tKNjY0bmoyV1RhenhxWVNhVkFlM2xEL1JKYmwwb1Vv?=
 =?utf-8?B?dElGaWdRaEk0Y1pwMTdkeWdkQ1ZmVndXRWdrZVd5ekpyZnZBSHhkbTdPSFgw?=
 =?utf-8?B?QlhNWkFvZFlwWlR1WURhZmJ2cytoczNaVmUzQmpSOGpzUWxQbDNEb2wrdXlp?=
 =?utf-8?B?ZjZ6SjVFTHdMMTVnWmdkNTM0eC9IUENNZ2d2bzFXYVpQbjZuYmdwZEdJMGZY?=
 =?utf-8?B?RWkwdWJtK1AwTUhhL2V5U2RkRDFwRmJlbU45RU1IZDRnTTMvZ1BZYlE3MmxU?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T5XPv/cEQBirCeuQypKE8n637szpoibacp5B+k2JsTrV0h+SqYH3a0ZfqJuFBzUVDpbZjxxPIyq8Tg3aPGZfkrh0kTvJ5gR7Nwo8yaZFAJ70NVPdHfyhy4Hx/XFIVMbv2DNrKuuULHty3vDgZ231x33yDuvj3oh2V0VwZXejTy/zthQA7BRVjeKl5+Jeo/ZHZ2KNSxrI57MfHkSPMrgHg2QQHqYOvZn2Hq3nAHWnEQc1ntYjpV/kHPsrCCCqyoWR1FIGq9hBvcMPaJvCAZD+XoStjPynk0cKQnmcNvnfhSRfW7CDcxoEFPmZ554KZM/53MEQ4mql6RjFCf7D0ITAUmD+UclzVYCCVViNUTdussEEMPUeAJQwUr0wcE9zvvQOwLtTULHzOPRT15dmigiVDzG9343aCfZrJ2WEoUH+mG//ArQfPBIi2QlxE//fyyDyhk3lNcU0etnaDoEuQSGteuz0mIuh64WNcvG3YRSnstCMtLgj6wNFWK+3lkIwOY/CjvEcN+VXmCnwTjTxH+fh86eTLIrZiYStZP05qXBF5hajYGM84+Xq8akcPMPXp6exPHrk1DmVrG6the0ASIaPC6VctOjxFDCPku90nCWmX/Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b917d495-4240-438f-61d4-08dda36ff1d7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 13:58:55.7380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jl8cCB8Ax3uoms52n+HjBH4ws48UOy8wrbgVzTVpTX3369eqoHZeIn5Py8EESPB2Xv/Rp0rcm9sbckMfjJ/2xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6993
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506040107
X-Authority-Analysis: v=2.4 cv=aqqyCTZV c=1 sm=1 tr=0 ts=68405123 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=AGzp_J8_mtl1eL1WXPkA:9 a=QEXdDO2ut3YA:10 a=U1FKsahkfWQA:10
X-Proofpoint-GUID: YKdmci5y9hRymPYgBLRCQw36nX5Ph0Xy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDEwNyBTYWx0ZWRfX9eNBX08nYiyE eURchdWXbRRldJwr9EUgppwTWYiswsy9LkODBjA3UGvgt1QXVumWWNIV0pQbMPrlKE/J4gkQODi kAwICt/wFH+eaqKFaCUWTEV5vPVjxHWnHuZIL9CrDPAWBAZGI5hBdSfdlRKQZmOQLUrOtXbJCTq
 GEupx0tVRcNSJsFQ8kcaED7d9NsnCqdVf9IFivkljsQf0NAI7+4TXxK+yeUBaZl7HmM2j2HuUZc lHNAbcNJdUk0/tvC0mEvzW2X9CGvRdFG+/MlAh/9EOTiXrLTxehcx0+FDau2UTyBftJXECD5cuo Fa9xug9SESAc/VWDjoc51V5k/X8YSy/YGeF3ni9eBilZtsV5sM+0qxlXzODW3SsSOUW8SKDgS/F
 md0Fy0R96DpklgevGEhRQcGDx3reqmc6ghldhrbgnkCLWboTbL3DLxqARC35IOs3jZeT0lA6
X-Proofpoint-ORIG-GUID: YKdmci5y9hRymPYgBLRCQw36nX5Ph0Xy

On 02/06/2025 20:22, Catherine Hoang wrote:
> From: "Darrick J. Wong"<djwong@kernel.org>
> 
> Fix a few bugs in the single block atomic writes test, such as not requiring
> directio, using the page size for the ext4 max bsize, and making sure we check
> the max atomic write size.
> 
> Cc:ritesh.list@gmail.com
> Signed-off-by: Catherine Hoang<catherine.hoang@oracle.com>
> Reviewed-by: "Darrick J. Wong"<djwong@kernel.org>
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>
> Reviewed-by: Ritesh Harjani (IBM)<ritesh.list@gmail.com>
> Reviewed-by: Ojaswin Mujoo<ojaswin@linux.ibm.com>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>

BTW, it would have been nice to keep the series versioning as before, as 
this is really the same series, thanks!
