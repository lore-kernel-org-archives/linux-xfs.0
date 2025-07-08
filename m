Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460252DF3DA
	for <linux-xfs@vger.kernel.org>; Tue,  8 Jul 2025 14:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985506; cv=fail; b=WEuw7hmANi1YqmGuk/3sn53C+xZTnJWkZvz1nxbrBfExmkgO70D5NslHGYESz68gNFY3TIwoRxQbfgCAdoxPCG5rmxV7kzmBWLmv06E8afMzB25hRr5yzV01WlUkUBuZxIEH4M3GHVRnhh+oh06as/QdLmAfqxnuSAp+zww5zRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985506; c=relaxed/simple;
	bh=CDFO4cmyoa4i21kuW+KdmXX3tbFZHUJDsiiCJ5j+ND8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A8RaBIRj5vesHcknQVLF6SxtoWRURCsMEk8EU13LdZx2YFBuDPwb4f2UbvTJBBd6fUNvYeKBVcT0NZVI0WKWsEoFR10CVUDbelRELPKkCXQTBVS/pwV5Hq25xL5kVVvNQ+1dB84cNY4u8Z3qr4KH3Oixto9G7YbykbCeIbr4J+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Sh2U+1rh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AMOQb0CO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sh2U+1rh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AMOQb0CO"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 568EbQSk032409;
	Tue, 8 Jul 2025 14:38:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3SLy8+rETTHsX9V9gmougO4FeD6/+jIAtDg2THlQivw=; b=
	Sh2U+1rhPeKTy/1WrASsDuf1LL/hxrtW7Pn3VJ1Q6rdOP4Moxteh22oNre3y2EX/
	eB1BABSvUx2iQUzL5gxsut1X7xbIDoIn1L9oFQ+VDlp39vDupwFgZ4CdbcTSu27a
	PsZe6V4PUZHenELbJM4vKduW9bKa7Eitw45pTzI0/G/qTvTz5nh72hziarCvx9LA
	nEgmGwszRlFAIwPdrYI2SEZOxOOTTbHGpHp2MfLLfT3Ai/jYd+Oq1QH0l16Cjf7W
	+UZw+P6KKCY0LWbRxfX5nHUC6/ASEvxu2M0jl8fhISilEkWDJMQttAlMN499B/LO
	1QteglvU+nMtmTg3gMBUwg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47s58d0036-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Jul 2025 14:38:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 568E3Jrp024391;
	Tue, 8 Jul 2025 14:38:20 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2073.outbound.protection.outlook.com [40.107.96.73])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg9ya8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Jul 2025 14:38:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uty8F+g9qY97xvcKdvIveJzOFgw4cvg9POAd0Q6nT+775pHQYqYTYHHHd4cVc4rstlY7TGF7O2o17KKbDY+4pxcNe3B6qm96PLdWNb+OhHTM8vBFy9zIasV1erPkvU4/hcvEaq5wV8nCXHSSmw9ft+dR9nkV+3i+s9MkRiVc8cWFG4VUbfJP41uAzbMgLsuAJnsmEPh5w7p84sWXtwWR2A3MuEsljpLBLpUUowoKJ1CD/Yn1ckfnkEAp2Q0wHI5dsmXZmRexQ1CvIK23/Zgfq1rGVdzXvMbrt0A6xO9QMPviy/Lqa2uiRlnUS0Dk8jW2sJT2IyWtbOv0at7iGvNGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3SLy8+rETTHsX9V9gmougO4FeD6/+jIAtDg2THlQivw=;
 b=hQLK3i9SFSfL4Zv2tzhaElqSa+sTMbXYmqKNsqFPmbRjQrBUHRp1DmSniKGCr8x8vk4v7C3Bpkrz0kO5Qd63FjJoBPXK7WDZI0cSwiNfLL8R13E0CtbyObZgBV93PUObrUZuWTd1+JAyEoioE3ExPMr5PjHDV1SCvP7Zcdg8Pmj4cthnBUxAp4Px/PAq0iT257+eRmXnxoqFxli2Q72Fb5IQ3F46e7rII9D3bjKw5VhRB33FaNz5vj8WLTcO95qvRKWiHcoEYYwgKy4VaD4pbTo2qcuhdd+IwJN0MCl39J7EFnIzGFRIdGZcVUck6wdsG0uvA62X9PXv2vgFTr4SHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SLy8+rETTHsX9V9gmougO4FeD6/+jIAtDg2THlQivw=;
 b=AMOQb0COA9nDb9e40/Bj3hJWgaSRh2CChZCUfW6Vl/IICkMT+wTo09Xd51hvJ+yu4EycECNK6Z6uqfwC8QIrS2xEsnYerkDnmOMnXjP9l4lp4BuF3SJzIppUfmi2Bk+jXCkNqNC/aE/uiN7zoxBnQPuYyCXS/XJyVP7WZ6x6jGE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA3PR10MB8418.namprd10.prod.outlook.com (2603:10b6:208:57a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Tue, 8 Jul
 2025 14:38:13 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 14:38:12 +0000
Message-ID: <874db4d4-2fd9-4f48-afd5-dcdab88ca7eb@oracle.com>
Date: Tue, 8 Jul 2025 15:38:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mkfs: don't complain about overly large auto-detected
 log stripe units
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, catherine.hoang@oracle.com
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303911.916168.9162067758209360548.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175139303911.916168.9162067758209360548.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0010.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::14) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA3PR10MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: f80481c0-efa7-45e3-1f1e-08ddbe2d1121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkpjY3RJa0NwWDMwZWVJeWRLNHIvTzRnMHEySHE2a3RBSmtpTUFPb3V2Slll?=
 =?utf-8?B?Z3ducEJBQXJOanc1c0tybUxvUkJZVzhlNHo4R2ZsOVhxc0tFYXIzY3Zya3Nr?=
 =?utf-8?B?OThBbUtEOGFRSFNIV0RzbDUzanp0SitIRUx3MHEzZDdCODJPVTUybmFCb0xZ?=
 =?utf-8?B?RmI1bUxBOEw3dUFiOXVDZ1VwTzVlK05YL2o2dlhzQ2RxYTVkY29JRnlJYk5t?=
 =?utf-8?B?OXl1OGdpeHBMRk1vRzRRUG1DdmlDVU1JUnpPR1ZxTVArTXJrTFptWmdlVzdC?=
 =?utf-8?B?T3hmdnUxS2krVldFOVFtNU1kd1U0bzd2SzhhVTM5bjgwZVNTWU94dk4vWE5p?=
 =?utf-8?B?Y2ZTVytQTkd4bUVidXJWZDZJN0VzWWdxLyt5cnM5WmhmSWNjTEd2LzVHTXZz?=
 =?utf-8?B?MDFuQzA2cmsxMzRKSC9LZzNSUk1XbklLRXNUeDJqcklUTVJCaGFPUVZVZFZx?=
 =?utf-8?B?VzBLbWJtYjcrU1RkZ0d1RndPM2crb0I0VnpCbEVQNWtwcXUxU1E2eGdBRkNG?=
 =?utf-8?B?dWozWWNjWVBUZWc5UUgvYUdQczc5d1I1eGtZVkNJWkY3dWtrK1RqUFBzQ2VP?=
 =?utf-8?B?MWtIaVpUWnF1M2lMekpwd0ZTMnlmTjl5cUxuOE8xRFNhZ3g1R3lKSW5mTWVC?=
 =?utf-8?B?dFJFMVNFbVF5MWkyOC9zL1FqVGNPV2VuTm1Jd3VKUWZTRmFPUGdvR01NZnE1?=
 =?utf-8?B?cnZIdVZHOFdIK3RqTXFkem5vZ2gvZVRzTW9HM1NBMHozSlAxandhbDV6S3kr?=
 =?utf-8?B?WmJqQ21NZWhWK3hqbHJSWldZdWxRRXpwbmhzQmlRaDNQN0VBTzRpV3REK0l6?=
 =?utf-8?B?djI0Q0Y3b0JianZza3FIYzJWZ0JlSysxbmFkY1IrRm1jQVltcGVQaHNqUEkz?=
 =?utf-8?B?SWxVUHp0T2h5UFNuR0xPeVRweDkvZmlQM2svbWtuZ2Z6Z0dSOW1CanI5aWpO?=
 =?utf-8?B?ejhnVlJmMXpEVXNPVFNzUkxpZlkwVzhsbjBmOU0wSlA3RkFWNUZJVzlmemJz?=
 =?utf-8?B?RmRGY09qNU1JTllvTDVBeUJuOXUrbkorcmFVS0NvUUcrcGxaWnJFeWcvY0lk?=
 =?utf-8?B?WnNJeVJDdXFwUWJFSi9DU2lqcGZ4VEFQUDZLWTB0UWtQSlVEWElKVWpnOUox?=
 =?utf-8?B?dThVMFNvTzVjc3oyOGxVZlVNSlFzeFNKUFRWUGxic21ZYitjY1M1aVJMQ2w4?=
 =?utf-8?B?V3oyMmgwc2l6NndhMk1qMnB6RFc0b0pFVDlDanJNeDc4K2Rody9HcC9PWnJj?=
 =?utf-8?B?b0VDbmhnZExTaUo4QmhDZmo5THZrNmhWdU9PK25TNjlRaHpyMjgyMFRkYzlL?=
 =?utf-8?B?Y2FWYVZjVGMxZ3EvaTNMY1BCaFYwZVYxVWlDRWhpUGRtWW8yVDlWZTFrZ3py?=
 =?utf-8?B?VXo3QXRVcGVuM0hSVTRlaW9XeXljZFFzc08vQ1NNN2JZQWZTWlBMbGRaWFZN?=
 =?utf-8?B?OHlxNkRFd3l3YkY0ZXpSYlFqTnlXNEkxaUViK05kZ1J0NytjbWdpa1dUWmkr?=
 =?utf-8?B?QjJLRE5paEpib1pzdWNnVFhuUTM2K2pKZC90T2RiY0I0c2ZFSTBua01FVVhr?=
 =?utf-8?B?UnI1c2RhQXNwNXNYaVZVa3FNMHJNZkNHSkRzd0pvYi82TW9DSWQ2OUxSSFFH?=
 =?utf-8?B?THdhdW9SWm5KOHBqTTVuTGNtU3VvZjFJUm9IcUtMK0lNUWw3WklvYWJKWlF2?=
 =?utf-8?B?dU9TeTExbnhxcVgzYnlDcy9HWFc1UnpIRW1UdVNaRm9ISjlhSXlWRmYrT0RM?=
 =?utf-8?B?aGNLSmt1N2xMM29yUGhhSy84WUlmelJjR2d1QWNFL05LS3hOR2x6eldJc0tU?=
 =?utf-8?B?S0NzK2RGdWhrZFdHTXBmNld4aXRJUU9TVGtnenBGOUJYZytNTGFaZFowYUNl?=
 =?utf-8?B?eHlpWVNMeFY3eDVReXVFWnozdjFzY2tVMldFdWNMRVhaelR0Smx5L25INU02?=
 =?utf-8?Q?EozML/gDzPg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXFlUWZhRjcrSEhLUzJmbHlYbkF6alR5YXBPSmFlK2dYdzRmZEpxMmxweU1P?=
 =?utf-8?B?NDhJcVhDZnl3UHFxRGhUTVR4Mk5BdlFVdFd1VitYb1NUaWZ3WFkrOE1xRTd6?=
 =?utf-8?B?dC9kRUJsUktQdEdUWDd0cHNWcmJ2eWNUM2MzVFNEUmhZcDFRZnVpS0FpQmJM?=
 =?utf-8?B?YnNxSW95MCtoN0lzRy82Y2pJNEIzd0Y2bzlleENMWUZ5d0psQjFCbVRuSmxD?=
 =?utf-8?B?Vm1Xemx2OGtScEx1UHZ6MURqV1NCRjhkWDVTb1cxSnBSMlQ1V2pMakhnb0hU?=
 =?utf-8?B?ZVlVdnJ4YkRvb3dvdHVtSEFEeVV4cUFVelM1a1F5TVBXWURuLy9yYkxSREJk?=
 =?utf-8?B?YWF4Q2F0VlZIRFhZdVBWeHNnSzUyMEhHWndmZ2RSbmRKb0hJVjYzWlVaUlpP?=
 =?utf-8?B?Tm8vdm9WY2dJR0pkMkJidVhobWM0TXZEQS9zYlVTdnlxSUdwWHJ0N2p5VG93?=
 =?utf-8?B?eExMd1dPUGV4V0RVRnpJNTJ2UVA2M2FnWE1qQ0JOYklaU0FUYkgyV3ZId3VQ?=
 =?utf-8?B?QXZwak1aVU82NmpINys4dERvWjVycHJrb2ZOWXljYWtIMkw0aUVZbTBFbG1U?=
 =?utf-8?B?VmxXZ2owN2lyV3ZkaEZsRnpEREp5Y1FTcXZVZEJxTGI1bml1RWt4Z2J4UDdD?=
 =?utf-8?B?bFhKOHdVR2JUb3QyNEhuTU11R1VBc0pJSUVkZEdtNVV0clZKRGFZbWJWQXZj?=
 =?utf-8?B?LzZDcWVTTVl5MjEraHBmbjlTdFRIQzR4dUJPS3d5YmdCZjZXVHNlQTR1elRI?=
 =?utf-8?B?alllKzFLSDFiY1BiZ2pScGszYWY0Y0d4VHdSMXFzNWZzOUhrbzNDaUhlWGpq?=
 =?utf-8?B?c3FKditWNGFscE5nWDJmNmEwcTF0UG5wbyt1eG9ZdkpNaDg5TDgxQ0FIcmxs?=
 =?utf-8?B?U3dZSHp0akRaRVdzcUpRdHRlNWo0WDBQam5xMkwyNWRha3JLaS80T3RNWmh6?=
 =?utf-8?B?Q1Rlb0J2RkE0OHhldnVZUDQ1dVY2eHl4UkZERXFkd0R2YW16N1NsajJpczVa?=
 =?utf-8?B?M0JjRjNZZkNaa082SVlUVWc1TkdQU3pIdjRjQ2h2anY1T043bTV1RW1MYmZw?=
 =?utf-8?B?NE5QbmNyeDBUWVcycmllMUNXSE1XNTVBQ2VaZG1OditDVHNjVU5IWTllc01L?=
 =?utf-8?B?cTcwRTF1U1Z1SkI3bFEyTkhJVS9QU2tuRDNpY25uVkVlNkJTNnYvNUpBSzdJ?=
 =?utf-8?B?bDd6ZTdaS2xOZ3ByN3B6ZFBtRk9CZEpseXVOdTdBYXRkMHJCWFNvUm9yMUZm?=
 =?utf-8?B?UlZhYkI5RW5kMERLbGQxcGNQdHNKRzVBVXdlWUM5bFo0U1ZFYnp1TDR1S1B1?=
 =?utf-8?B?QWdZQm4vemlvVGpESlBobUNjWHVPRS9FcFBvL1IvQ05DLzZhU0dEbXNWRG5J?=
 =?utf-8?B?NjUzZTFERkN2K1ZWbzNmbW5MM1hpZncwbHpOQy9vWWhSbDFjUlBpYmNhemVt?=
 =?utf-8?B?NVlsS1NhYkJ4SnM0OTBXTHlRM0VBODB5WVlNUklsbXlGQVB0UkluSStBUktj?=
 =?utf-8?B?Q1hqMmlZSTF2VUpkYTkvam5IL3Fsb21NVXcyYTArVStuelY1MUVXZk44UWJ1?=
 =?utf-8?B?WTJiOGI0RlZYT2JVSU1HUWVkc1QrRng5cnVJYXF0ZGJ5YzFKUU5CZFJoY1dP?=
 =?utf-8?B?UXRmU2NGTlRaVUJHM1poRlA0Yks3K3MyYnY2di9qM2E5eHlBTWJwZ2phRmdu?=
 =?utf-8?B?RzRHUitaMlZCWjQ5L3pwaFAvdHNsbmU3dkxjSzRoekFTRVo5QjJleGFPbnNV?=
 =?utf-8?B?VzJlYUljVllqQmc2SFBUamJ0dk9PcDFiK1J0NXh6eXI0Q2RTL04rYzFHZkRQ?=
 =?utf-8?B?YS9GSEYwOTBUWFIyNDd5VEZkMTBwb0FpS3VvakpNbEQrWlRienNKcDdyTkdj?=
 =?utf-8?B?Uld1UHpCdVRjS1NBSDB2Z3RINTY1QnlHQkxRbXhqWC9ZSm1yQTcxMWNiR3Zl?=
 =?utf-8?B?M1pHY3ZmZkdHTXcyWmlvUlNyUVJ5UzRDNkJWZzhscTBrYVZ6OTl3Z0l1a0lh?=
 =?utf-8?B?MDdwZ1pla3hsNG1jNnRIeCtuZGg5L2c2RXlDSE94QWU4UlJJSkFxaW1ZNmln?=
 =?utf-8?B?K2FEaFRIQ3lRL0VId3k1RWlqVkpNYXBQdXdZeHo4a2x4cUVZQVhJY0cxRGhU?=
 =?utf-8?B?dE5ybU9UMGFrVHZMZEhEdXduYUNJSVVvWGcyVUZnYUNEbXBLMThsejFCUmhs?=
 =?utf-8?B?UHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RTRsQtF8YFW11GvAnSrGN+99bEiJYx9wEdoaBv24QS8ESREoZiMzdrcpzaGaSlQ/ZFJfEjSX8Sx6jZzWQve6/F1YOuiEIyTNsYCfWNGdGby8lhLxh9xA2IHLiWpLvgrRo50O0/z5TVP1PnzBibirPoy8rd0t/vMCC7zfg1XrbQc3ntvoc0O5iqpW3jvg3gEOSvN9/fn7ck8fwgGnfvVw1ihWpZ/7F9w855oCPAaBvMqa+NQoHL1CleZ7Ksg5SAoLGTNmU1K7siMcLaNjtIczLQ1BcNy2DftiOtTPgNc4xo4s8jf8dBbryCy2+ewvLhMaQzPZg/6xbld7dKr9aGMN8BoF0k1W93uLAHlP8Pwn40dhRJyIo41D9tu2KvnXj72sgRJ7uoLAxXeRRk5EJhol0HAcvaaAEleX0ELN8p5PZLjdihMFPvVadywmhcPkGPeoJPq+Ktu+MnaBbj2RENT0/XNv8xPRwuJ6kz5m2iN14iutFFa24X93n3TvvYfyplcq5gP+gMbYRh8RomF4YmMcPQZo+5wkmlWG7/M0Fl85/jp5aH0/OpjsuTeNK4ltoX3lBb2l9efh5tTwag+RABAsUfCZ2e+a3mQecph58bmKhKU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f80481c0-efa7-45e3-1f1e-08ddbe2d1121
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 14:38:12.8837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NqidYL76XAKUp3uIHMHexuqn1jXnhaHGZf0cLW42LgTfddDUo0IUvZSgfSx+nZIjOgAxK3Wmeezs26nkqrYp1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-08_04,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507080122
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA4MDEyMiBTYWx0ZWRfX89FdTDC8JSoO E2OveGutiT8P+z2MyAuscMlg3fcjQvgmNItRAlPW6n65fD7bL7UpqALoy1eAmz0oLYsdVtRiSbY epbyGM3LBfCbV3UzukSbB8TL0LPAgQ2vf60VYe9BEthm4mgzAZJApjsBrcqw6D5zWJt/vaHcNuF
 W/VayoBzAgOlxaKVOUnmzZw/9zNZ2G4NbQaj+S1RDUCc39qNAP5uKi9f6/t/gbnm7g0KCCJEt0S D20qdp8o2ry1aCRpvbfk51m1bbfSG/kO4jnoADAgKBdavZpnrdDJEGCIHS2rxUuCzq2p76BfpeX ow6WtNsnjjSi2q+ErzmqarOtRvpkO8iuahUCiFUPoLMAj8jWbJkSYbYJJYPOPdRYz3MAh2j0rhz
 j5HGhWb2TH31M+AjwotegOodHdFmpy/7g990kZcQICmohRQGhEihf6b4MCblhCME8Jfk0462
X-Proofpoint-GUID: _i3F9XuGApdxDfiiVNNr2cJkA21kaDLb
X-Authority-Analysis: v=2.4 cv=ddaA3WXe c=1 sm=1 tr=0 ts=686d2d5e b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=SMEE0K8vuQzgtpUErcgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _i3F9XuGApdxDfiiVNNr2cJkA21kaDLb

On 01/07/2025 19:07, Darrick J. Wong wrote:
> From: Darrick J. Wong<djwong@kernel.org>
> 
> If mkfs declines to apply what it thinks is an overly large data device
> stripe unit to the log device, it should only log a message about that
> if the lsunit parameter was actually supplied by the caller.  It should
> not do that when the lsunit was autodetected from the block devices.
> 
> The cli parameters are zero-initialized in main and always have been.
> 
> Cc:<linux-xfs@vger.kernel.org> # v4.15.0
> Fixes: 2f44b1b0e5adc4 ("mkfs: rework stripe calculations")
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>

Makes sense, so FWIW:

John Garry <john.g.garry@oracle.com>
