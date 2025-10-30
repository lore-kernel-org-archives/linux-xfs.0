Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C181EF39E;
	Thu, 30 Oct 2025 13:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761832382; cv=fail; b=WJoRxe0XtLeqPuTGCKl/o51fXPqnA2NfBVgJ1x7jFOM4TV0t2fyG3ETzL/p4mtEgDWOEbvA6XbuYdWCAShBqFczBKQwGSK37tjcm+y6ejXvc+ltbk0Ceh4BHBmtBY2YuxHetubRv8Sl7lWqDqhomkxtkyR7TG4L8PuLe9urpUZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761832382; c=relaxed/simple;
	bh=GuqJaeBi5CIOpTRPWRXmMHrxb1yMZIFh704ycjK3UuA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XDHwpXr8h18lo7+fLzoZzDQg+qDGzcTG4otOLrLk7bk2Wr7q1Bcnu54w2MxO6tjy3xRK+aY0zOKTabY1Vgmas86bZmJ8gY2hkJoEHAvsPnP3tHwh0r88LdR7W0OiTB2wXJydgK0I13tbST76/m/u+/okPSngEc2FhX9tLKgUR1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UUJXRQzE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a3yDQeMg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UUJXRQzE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a3yDQeMg"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UDZ0Rh007545;
	Thu, 30 Oct 2025 13:52:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mJ5InIQSaeAZnzXIuGNCOSzprIUFF2LcLkAlws+BX+Q=; b=
	UUJXRQzE2rHutCBCpmQFKqa/dcbZfhR6h3nNUjwvqISAVPlREOTZuXUz/pV183BM
	dieTMrn+samGh3nPZngqWiscxIfIVJ0n5/6p3mAhB9f3leSarVkTmnEQIui2zavs
	Y5/tp6nR4pW3F/qdEJrd2oyHcKOYXlG2AXBEuICrHl3PhWYQZndp842eY/TShgqG
	70dUqI7gVFWgiU4zi9sm/HovKhVi8lpni3Vyr4FsG+ma/PzeL3bi3ktN5XWAJCGG
	vg2lcMYsnlfTnXmTt/0U33rzJf3XioKvojQEjhsvnN5RrsLdm2PSMa6/jSpuUp6/
	wkM8YBY/KwJoOibWQXGJ4Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4915r1ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 13:52:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59UCxqdC017435;
	Thu, 30 Oct 2025 13:52:53 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y0nctt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 13:52:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dndHlhknI9xOWVcTp0wbYT7FFOUc9jQ4ry/fRxkszbD/Y0HtDR7pHpoSyl1Nn2lHrxcZVNxkjPPvAGRIJMSNvCCKJnYz1vKCjsJxVyNuprMG6Pr+rMMOTOUsLNT/H+qawNw5jnTZ/XiIgODus9wKzC78JoTybH/9zOeRq3qsckgIP3vRUMiAW8c6eOJ67nuWwUY1vIP6EVb67kzjpBVc+zznH5VyGUqvO1jegWErh0OL4Wx7s+Ma/LaHy401GOdlVoJvhaAEKcaAyOup0vfIC61mnB1bbLR8PbhSjwHc6iZUfbBMZYgN1EGgtCHR5IeWEgVecz6g95mGnA5AdrpXHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJ5InIQSaeAZnzXIuGNCOSzprIUFF2LcLkAlws+BX+Q=;
 b=c1m3z9OrZHRAa+ZuQ7F147KIApK0ugc2N2oH8chWZiQnubDbFE0AREQDZ6NFMorYuu6BRuNEqDXVPiv0MK9/JbHChc6gy7uwoGuhADDKordzliN4PY9+cKPDV5FB2zrDEQaUhVru+hvIw+ipXGK2Koagj2kLRr20ST9ygTOxZlGYLK5d43QU/BSPAPPvlKZSJdoZnWZn+KBKTOrK8xLXdv+34kUzDEWmvizdxuFYR7zaEDu9YUGAviuDKhTIELdMYfPbMrjeC1AWLPrday4w50H0soDk1ieH01GZ4bHGDSapfQfHiQL12sOm27604De3SOK3nTxX/nqpxE/sEDQF9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJ5InIQSaeAZnzXIuGNCOSzprIUFF2LcLkAlws+BX+Q=;
 b=a3yDQeMgAZ2pnIKoVJ5mm7kVP+5ZdOZF9tizmA6G7CdLYrc1+49E97glXNx6t8r0Z5+pFbAA1QMnKf+7XqgGvile5sVsMTj5CBJGi9wF0leKokftElzSS+LFv4xTJMzf4p8bB66JdD8yhnojn44IsRuai0B0/n2499AiSwjaywc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MW6PR10MB7552.namprd10.prod.outlook.com (2603:10b6:303:23f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 13:52:50 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 13:52:49 +0000
Message-ID: <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>
Date: Thu, 30 Oct 2025 13:52:46 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
To: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zorro Lang <zlang@redhat.com>,
        fstests@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-xfs@vger.kernel.org
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251029181132.GH3356773@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::6) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MW6PR10MB7552:EE_
X-MS-Office365-Filtering-Correlation-Id: 99f64583-e46e-41ad-5673-08de17bb9d07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFdEUHRuanF3aEY0czlINVhNRGMwVGw3alpoNjF2MmIwUUxzUlBldkx0MUJz?=
 =?utf-8?B?QXpXL0ZYcEJhMEYyVEl3SHdjMkhBc2VMV2F1cVpUTVNpSFdheXdYN0FNOGtj?=
 =?utf-8?B?MVJzNDV2dmZxQURCWXJCcEN1YXk1NkM4OVBsRGFCRFc1eVRUbGZaK1NpWkh6?=
 =?utf-8?B?MDFkVFRFaDQyMlp2enlaNjdTS3ZybkNpTVdiQy9iakF1NjNNR0tXZmd5TTJ1?=
 =?utf-8?B?WFN1N3R3YkdvdHlDRHNHUy9rNHBrOVZlc2Rlb2ZBTlM4RU5EL2h6b0piQnBr?=
 =?utf-8?B?bjhCOE9ZRDdOanhXMVZwWUNFRlFtZktQS0Z0UEMxZ1hXeGFWd3h1aWcxOW9m?=
 =?utf-8?B?T0dNR3BMUGZiaUxnV1VEU1NMWDZMZVd4cWQxeXhBS0Y3UTJURkdaMEdRVzlI?=
 =?utf-8?B?YUdDb2J5VmhLZEdzWEZ1TVJ1SzRNNEJVM3YzcVZJSTliNkoxZXZ3dlJ6eno5?=
 =?utf-8?B?aU5XelVza2EzcXUrUW4rWGxrSUJLM0R4UFlmUE52bXFabUdLYWpRTnUyYTJ2?=
 =?utf-8?B?d01oVlJZRUZWTkcxNE1KV1lBYWswRnZyY0RPZnZ2MTJ6WkM1Qzd5bVdXVitU?=
 =?utf-8?B?cHBXWTBlb0JWdXJ5VTRuaW94ZUFOZjJiUzh3ZGVCSmZLNkY3N0QvRndrcVh4?=
 =?utf-8?B?TlpsbmZYNzIxN2svNm9vd1p3dEk4VXA3TDBoNm1HcmFOelRjUm92UlVyZytD?=
 =?utf-8?B?WkRTT1B0NXpCRUFvektKaEs2dlRFSHFNWjB4NTZGMG5zV2g2UVZEYzR1bXdZ?=
 =?utf-8?B?SGR6MG1lc0NsOWZobG4xVkJoR1lobURYVHUyVENZK3ViMU9BSnkxdmVkLzFv?=
 =?utf-8?B?ZGdUd29ubFh4WGJLdGtXTzBGNC9WTVdoQTNVaXRHSEtWcFZIM2trUzRXUFNt?=
 =?utf-8?B?dm5MVHBXVGdJelZINFZlZWZ0ZnY1RElPU2h3R0N1Yk0veXo5aHV0Z1NZaGtU?=
 =?utf-8?B?c3lGT3EvRHJSWGxJbStXYS9wNk5DSzFRdnBnQk13bWduNlg2RjV3SVhEYVFZ?=
 =?utf-8?B?NXB2OUdST2l5bFE2bWdiODZtRWdzN2FGVTNtM3RpRUdnSjFHeTR1TnIrR0F2?=
 =?utf-8?B?UDFwZ0x0dGtJc0ZTNTZudTA0YzFGM2V5aE53T3FMdlNDSnBSd3NsQ1FZcjVN?=
 =?utf-8?B?Y2hVT1JuWHhSb1BDa2JPUDVGWlU4NmhoMk5CNnVnRDB4Q0x0OW1nOFA0aXBt?=
 =?utf-8?B?TEQzeUZhMHcvZlBkTTd4Y0FVT3ViQ1dmbXpqU1JFMWVtaXk0aGdoUExFQnNu?=
 =?utf-8?B?MWxCRTF6YmR0N3E1K3JWc25rOFhYNUZGRUlCaUVLN01DQmx0WmduSk1PcTBS?=
 =?utf-8?B?YUlQcnptbjFCV0pRSmlrbzNEY1NFUTVMNzJCUzhtdWorY1pSMmFUZ0Z1eXlK?=
 =?utf-8?B?cXl3cC8wMmhBQXNoWWNRYVV6SWJUZ1hTMmZNZ2VCdzF4ZldpNDY0SUlESmtt?=
 =?utf-8?B?STNPRE90dUlQQURIZUtIK282WmhXV0F0c09uUjQvdlB1a1h0dHFDZmJycDJl?=
 =?utf-8?B?b2JxQXFxclFyY0Z3SXJ5QTBpcDQyU0ZBUTNpbkNxaWtjaWE5Z2lpOUtsdGVL?=
 =?utf-8?B?UVg0UzdEdXJEdzNNS0F5VlZ4MHZZcS9UWHhYWUFsL1VSYVpPMWNjYVQ3WU9l?=
 =?utf-8?B?eHlCc1Bsdm91blpzRHFhQVFmTnQ5SEVMcnJFZVR4QmJWUkNMMllxY05UNCtL?=
 =?utf-8?B?STh4cVlRdXRnREtkb0xVZUNJczJsNVpUclBrM3ZsSVBlTkQ1ODZkVk5kaXZ0?=
 =?utf-8?B?eFE5YUgyTHZzKzUrVldLazlBaFlxdXFNTEJoQU43UnVzODl2RzdxdHVtQXk3?=
 =?utf-8?B?WGhpL3lYSTZCZG1SM24zVmcvcXpEZ09icW80UExNVkF1MVNBQ3o2bFF3cEJB?=
 =?utf-8?B?eHZqUUtDTHZqTTZqaEpFWjUzWGRkWTFEVmlvN2VNUjNnN2NCbytiZjRZM3kx?=
 =?utf-8?Q?N8YE2jThduTaJ/qXICt2S3tETmV9D0mu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGtzemptTU90eTAvV3JUVWNVWUczQXROZE9DZ20vSWZ6aS9WKzViUHA2WDBE?=
 =?utf-8?B?T0lwNGV1TWxJMGJqMWZtLzlPRGFBNHc5d0oreUd4VC96YmVqdThqR3lFTkJa?=
 =?utf-8?B?QnM5MTY0OXBaSzMvZzdETnNnUk1DR2FSTUpzbTFxeUI5clZoR0dxZVovK2sy?=
 =?utf-8?B?Q084RUVzem54VG1ZWmpPM0dpVk5BWndiWmdjTVEyeXU0NzBNSE9VNkppTDM4?=
 =?utf-8?B?V2hOcDRVRVVmSlJXMnljcEVGaXNYdm1VZ3RJMy9Zb2ZKWVhtN0FGL0oxZndF?=
 =?utf-8?B?SzJwSERXUTAyU0VCelNBRXYreXd2d3oyb1ZSL1ZSUXI2MHRNQUVhQkl6dlBq?=
 =?utf-8?B?VUN5T0w0a3JzL24zTWl4Y2U2QlV0bStLS1BxUjRSb0M1OGpnUFdYeGw3VGVt?=
 =?utf-8?B?emE2alBwWWZwd2s0WkhZekQwR0o0QWNKRFlMNXFEamNsakV0NS9ydXpSdUl5?=
 =?utf-8?B?T1VNUXNDOG1EUTdIRnFWdzJRRDdyV1d4dXA1Ly8xNDdGTndpTDVmekM2aWl4?=
 =?utf-8?B?Z1JCMzlWS0dpbGhBVThORmNuaXl1ek42SWxOVkpkUEZocC9QN2Q2aVV4SUxx?=
 =?utf-8?B?enY0a3dDWW5kNFQ4WXkrc2Qvbm1UNFRRSHVsakRCSG9Gb2k3UWtVODhmNmtZ?=
 =?utf-8?B?OGkveW84Ym1BTHRXdnM4RHRCdWx4SkhaZ3ZRS3hyMTBHVFowUW56Qzg2QXZR?=
 =?utf-8?B?dmtHVmZudXRyWXpDL3M4U0RoQko0aW10UkwxTUtIM0ZURVRDaXMzd0J6TzYw?=
 =?utf-8?B?UUpzYWRnRXdFN3V2ZzdlclA2K3VUVmNFaXhVTGllUUwzNkVkY2ZaUUYrNEJM?=
 =?utf-8?B?L1krQk52V2JLdjVwaGdYell2N05scFZXN2ZEZ1o1Z21XSlRRb282OTIwY0dF?=
 =?utf-8?B?NnRXSTJRYmZRa1IrYWk1UEVrYzJBcC8rcHpPK3BWazNCRWRMS2VrUURHekR1?=
 =?utf-8?B?MVhZbEE2eFE5OTlSSUhEcHhZUFp5TUhqcmZKYVVlQXNubG40RWVpekZ1MGtK?=
 =?utf-8?B?VlQxWCtrR1FPWWJ6UFovSXo4K2U3dUNRQ2NXK01kWGVhMklUdEM0aFdsN0Zk?=
 =?utf-8?B?TWtLLzdHWkJkNXEva2hqcUJSRnBONEJJZGxvYmhIVCs5S0VHV1JITC9WOTBL?=
 =?utf-8?B?Rm1oZWxFVEZPRVp0Tm4yY0hHSE9JTmQxbDNMZzVmUnM2UTFOTmZ4ZDRDOGRR?=
 =?utf-8?B?WDBkVkZYRG5XUzhWSkg0V0Y2blMyNmZMZUlDUUNxdWNmTWlUTEZYaHpLY3JU?=
 =?utf-8?B?Lzl6ejFSeE9mWVAwMU8xODlINWlVUmE4OHVBL2J3VUhUZDVBTEVaM3E3b1cv?=
 =?utf-8?B?T3pzc0h2UjhNZHl4akdNT2lWUTRoTXVyTlBKd1BydEhBQk8xU1RTUGlHQm1v?=
 =?utf-8?B?VDN6N1NoajJuR0hPcjJjQVF1c0RaaHpSaTFENElOOHNpa0ZySDZGdDFmOUlK?=
 =?utf-8?B?SEQ5TVJtRStyb1NLakRDS0kxOFZQRmhiYVlwQWFIYWFkRWpTU2hXK0ZsOVl6?=
 =?utf-8?B?eWVOS2xlSGQ0YTFsK1h0cWdEc1RuRDU3MkRlcXlRYWp3Q05wbitVWHRyRlZS?=
 =?utf-8?B?SmdGRG1sNjFIUmJHaVBlWU9Xd3BYR0N1bFkzc3RqNEw3TU80VVVZbE4rSWxm?=
 =?utf-8?B?TWJxYWs3aXFGOGFXb2ljdWRta0RWRXZxYWJtbVQvbGFhektwazN3NjVIQ2Iv?=
 =?utf-8?B?SlFjNlgvMlMvUUtSbjVaUHlLa09oMTRTUnVNMzFMZDRmSzZLMWxOL3g2WTZP?=
 =?utf-8?B?ZVF1ZlpnT1BSM0h4czBIQWRqT0FuRTJvZUUyelhlSGkvNVA3Tjl2Q2JCbFJZ?=
 =?utf-8?B?RE9NM0c3Nlo4UGJwOElRdE01dEtSNmRpWHpsSHYzTjNkYXIwZVZZN3lEMnR3?=
 =?utf-8?B?TEtpRE1STEJXa21NdzBESTNFaE1NaGNXUElzUDZGRXRFTjlYOFJ0ek43eFlV?=
 =?utf-8?B?SE1TbW9Xd3NncVhaWUFGYWxoWVJWWVV2N3RQR09qMkl1T2xoU0lNSDF0UTF2?=
 =?utf-8?B?TmRtV3M2dzJHWHJsSzN3Y1NVZHBnaGdVYXlQTHk5MTZ2NWRBZ1FxOWhRZlhM?=
 =?utf-8?B?YXo4ZUQvbUE0bnN0cnFad0dkOEhvUmJkcUI2Q3FIZEk4YmxGeUhxOEpiaVJx?=
 =?utf-8?B?UUF3TGZCcHhoNU5MMHVDN3VJNzZ0QU5tbkdKbGMxeUZXd1JtTjZvVGlUekVk?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9EsMn6lJ3ZO1bNQNyCtYMDIoUlbZ4Oz2SvL1ZFpN9KknHfkpehhnCK3bwv2ViSefIkYpSws3evYtr8ZwmdQ6J+8T9vL3YM2GEBV6tMFLZFZyaBDDYbTwXvD8LewRYXxGZjW0KZX/FqNC2QVEvT1ITB9fA4UCBe9QIPPXp7y2luUgPMdkP5AnEpSqFhQ+9KRqpxVIwrv8AwfY70kKJtkcCd3mlyX4t0oXtYwQPfv8a1hxqBhh+sgxlKpdP1HSECegTZldScLOnk+LRH9TPQhXly70vJRgJ32xoE00s45Is9/r9doCw8UCHrWB25BmWKVAWz+65/BrYGcWiF/o/XTaEoki/Pb+zkBfSv1lbo90mxmRQhTfQBsFlvHfQHY0YxnEbAw+qJMXQRyPNFU8O0rnSLOPIhZPEGNgZF7GebR7/3UhMHMuDJ4DeLCCPWM1uCzQz7Cv0kueVHaEoe+sakc5v+aJdVFvcQVyTkZMAr9uxkIYK5eKYBxr3e4kIwkSVUESlge4JaIK1jE3qpOfBvgwOhSR2Hqd4OLA+LL4kHdzdHSP2PdNaRAK56ELbB1PQkfIfhylQ6Ab/EyKCvZvuE9WgLgkmoJYEDRE5QJqLsrqWuY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f64583-e46e-41ad-5673-08de17bb9d07
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 13:52:49.7546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmukyqBM6+VrhOFC9oADXaZ+APdHLIAfnnt+h2bs7+yUf636HgmzHHZkr0fAkC0FHHiSewMwWKqbDv01T4zGZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7552
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_04,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300112
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDExMCBTYWx0ZWRfX2CiAB7oo2sdX
 xi8X+9dUPGbuUz9ZetX9+Lzs/bK+Dvll3zuRQ1d9dX+CcmjzDm0DazUGBa4HgbUwgGaxVw9qy/z
 PzytLRl6oAJYoJSsQ1PpKB1klZNq5ODadXs2F7ySgtWIMmclUlrusE3Fg+oaElqIEQiWrP7FraW
 2f1s+bUNeDA4rXj0qc1YAQw6nErrtDwAKBwSxvVpXPTQ6pKjhAz1TKGqDNmrjQm20UoMRRdI+Jy
 JRRAPK17dHt4ozde4Pz+Vo3ptlAaTdrtD0oIy1Ny+j4iC5pjEw0WWoOjbfF7XuBQ5ZQFGFbWOAE
 pTgVCsXREC1a6k2VBLdgIUy7K6lF71wTWG1N7dPZZY04h1SCYIFT5M087QJn9RijwMj51JKWUes
 +1kvrnXDXhHR+koejvV8aWTWFJJbdw==
X-Proofpoint-ORIG-GUID: DfCyfF4vCnvo_4p0QhmmhgiZvDzqgKJr
X-Proofpoint-GUID: DfCyfF4vCnvo_4p0QhmmhgiZvDzqgKJr
X-Authority-Analysis: v=2.4 cv=bf9mkePB c=1 sm=1 tr=0 ts=69036db6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1T8gf0cEKnAM2QzuOSgA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22

On 29/10/2025 18:11, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> With the 5 Oct 2025 release of fstests, generic/521 fails for me on
> regular (aka non-block-atomic-writes) storage:
> 
> QA output created by 521
> dowrite: write: Input/output error
> LOG DUMP (8553 total operations):
> 1(  1 mod 256): SKIPPED (no operation)
> 2(  2 mod 256): WRITE    0x7e000 thru 0x8dfff	(0x10000 bytes) HOLE
> 3(  3 mod 256): READ     0x69000 thru 0x79fff	(0x11000 bytes)
> 4(  4 mod 256): FALLOC   0x53c38 thru 0x5e853	(0xac1b bytes) INTERIOR
> 5(  5 mod 256): COPY 0x55000 thru 0x59fff	(0x5000 bytes) to 0x25000 thru 0x29fff
> 6(  6 mod 256): WRITE    0x74000 thru 0x88fff	(0x15000 bytes)
> 7(  7 mod 256): ZERO     0xedb1 thru 0x11693	(0x28e3 bytes)
> <snip>
> 
> with a warning in dmesg from iomap about XFS trying to give it a
> delalloc mapping for a directio write.  Fix the software atomic write
> iomap_begin code to convert the reservation into a written mapping.
> This doesn't fix the data corruption problems reported by generic/760,
> but it's a start.

I was seeing the corruption and, as expected, unfortunately this does 
not fix the issue. Indeed, I don't even touch the new codepath when 
testing (for that corruption).

As for that corruption, I am seeing the same behaviour as Ojaswin 
described. The failure is in a read operation.

It seems to be a special combo of atomic write, write, and then read 
which reliably shows the issue. The regular write seems to write to the 
cow fork, so I am guessing that the atomic write does not leave it in 
proper state.

I do notice for the atomic write that we are writing (calling 
xfs_atomic_write_cow_iomap_begin() -> xfs_bmapi_write()) for more blocks 
that are required for the atomic write. The regular write overwrites 
these blocks, and the read is corrupted in the blocks just after the 
atomic write. It's as if the blocks just after atomic write are not left 
in the proper state.

> 
> Cc: <stable@vger.kernel.org> # v6.16
> Fixes: bd1d2c21d5d249 ("xfs: add xfs_atomic_write_cow_iomap_begin()")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>   fs/xfs/xfs_iomap.c |   21 +++++++++++++++++++--
>   1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index d3f6e3e42a1191..e1da06b157cf94 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1130,7 +1130,7 @@ xfs_atomic_write_cow_iomap_begin(
>   		return -EAGAIN;
>   
>   	trace_xfs_iomap_atomic_write_cow(ip, offset, length);
> -
> +retry:
>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
>   
>   	if (!ip->i_cowfp) {
> @@ -1141,6 +1141,8 @@ xfs_atomic_write_cow_iomap_begin(
>   	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
>   		cmap.br_startoff = end_fsb;
>   	if (cmap.br_startoff <= offset_fsb) {
> +		if (isnullstartblock(cmap.br_startblock))
> +			goto convert;
>   		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
>   		goto found;
>   	}
> @@ -1169,8 +1171,10 @@ xfs_atomic_write_cow_iomap_begin(
>   	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
>   		cmap.br_startoff = end_fsb;
>   	if (cmap.br_startoff <= offset_fsb) {
> -		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
>   		xfs_trans_cancel(tp);
> +		if (isnullstartblock(cmap.br_startblock))
> +			goto convert;
> +		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
>   		goto found;
>   	}
>   
> @@ -1210,6 +1214,19 @@ xfs_atomic_write_cow_iomap_begin(
>   	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>   	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
>   
> +convert:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	error = xfs_bmapi_convert_delalloc(ip, XFS_COW_FORK, offset, iomap,
> +			NULL);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Try the lookup again, because the delalloc conversion might have
> +	 * turned the COW mapping into unwritten, but we need it to be in
> +	 * written state.
> +	 */
> +	goto retry;
>   out_unlock:
>   	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>   	return error;

