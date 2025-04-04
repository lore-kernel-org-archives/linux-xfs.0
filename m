Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CECC19DF66
	for <linux-xfs@vger.kernel.org>; Fri,  4 Apr 2025 09:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743758210; cv=fail; b=inDjY6Vm4H21O3WV+sRea+9I9FQ2QBP0Im7SLxOPi7Dtjr8cbRFb4eG5CdhF7EronXfLyTP0LbFelwYaxsfpIU1kL1a6nQVI05MI/CfbvgWTWU86IcC9JHzzlmVmyULwggmEoVIZ4GJGx+pwuLuzwnV2qoicPlEblx9lHU0L3Ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743758210; c=relaxed/simple;
	bh=jmYZIS6CMAGHiCoLXxbKrEV2kE3d5++VMUqKvFVSy3I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=emhiWv2c8HMqsMo8n9cy/7erkk/BAoVJCcm/eKF9QR8lnc4grMjb7ezCtuwBxMvCVN2bxWplxVQoe6HjEja9vlJb18ppBIcLaOwB5wjBeStpuBE+cydt2iOzZAEnFzak9dd4V953kZU0FCdDLSzQ6HMrcOZBKRNtsMkDxDK46bc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BRsJEFTC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XrwmsgqH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BRsJEFTC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XrwmsgqH"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5348N8m6001353;
	Fri, 4 Apr 2025 09:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=4cyVqLjz5u4rdr6CmK6sOgm7dNfIavDehGFqK/pgmuw=; b=
	BRsJEFTCaC25Hn77vJPfr+SQqlC5MrbT9DozuQK5o2s9xiMkEW5OkIJj+Vqs2c5y
	a3cIcvcbgA57uJQ15iEi2TF7jYogC+2jdeZZ5LbWM/tKF7FR+fFyxLtWZvI1oGF+
	JzY1Ul0NOSgUCqr3nGH9m3XTE8fy5fTZnNTQmI7hn0QB1RgEQU17o+2vedUHqRhB
	606qg4Y67XsnXKLjs48Ohsi9K26HNVDckt5ZIYhnvVk+3GlY9sfOI70Zy573UTV8
	9yQVEzAkAuAOThX+ytf3uozccKRdE473oMZ1XLH4M6abHiOditexnM78iSX0OPBe
	OQniiumJuubQkZJH/coTOA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p8r9pbxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 09:16:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5348pAHE013639;
	Fri, 4 Apr 2025 09:16:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2045.outbound.protection.outlook.com [104.47.58.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45t31f1858-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 09:16:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkmM8LcaHK5yQZuMjURx9b/nZwe2Y8YUiNV7Y4Tx7hGQRLjGVf9AJer368SOn4exxjXibLOKxy+bbXbcrlC04PAZWwuhBIxSOChYDHwK7CZjObK5ybPtMeu06IjtPyHknGv8Zw9tUggX1nx1lsexYreyhVzgInYn3w8qDB1wgVXqr+JVBu6GGn5xYcU1j8jxH17lsPLNCbTXf3hchPlAbeL6B5vKtIxhr1A0gSMDpJyWhsqHo2v6ntWGrePuwsDF0iBGqrmYa81f8SLtQZgUGiH5clSMmlQTWdC3NZ4sut8gWJS47CpMDriBD8TOxfBfPVfptAiK+RTJ+e7F+JJ4Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4cyVqLjz5u4rdr6CmK6sOgm7dNfIavDehGFqK/pgmuw=;
 b=NyCvUcPmvB9PFLSRxN2fLt+Dkocbnb0luf4nKLsf7BVlTTe+w77GZ1dyUeRaIFboIE1+qIJ5i4Bbjj34L7S28ODFvuj3vW6xJ4s/ouz/1NJ4ZFuLRKMMV0BVznxio6UzgeyZWqwHOEp3NuQzbGuxyoWoIvdvDaDliM5Tmp5djJvtp/Hng43RqkoHJ2jpNb2AUi3AQ9BT9PG36s4fH0F+orUJus0g2q0J87Bnhj21zRRi0iSuzWk9Bn3abrKlU74uhZhIOk4EcIdgwPR42n+EYWT9emUC3yJzSGvJzwqsk+LBuHGnJhbaie0kR0XRDQaijcPF9qEyf5xv7ql4HpoMNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cyVqLjz5u4rdr6CmK6sOgm7dNfIavDehGFqK/pgmuw=;
 b=XrwmsgqHPOU0rULU4Tb9yzAp+Ad/zVzRPuVzxAOT6xtUyPLu2Gz+Uz/RmxJb8OiUhiNyKoup+wbwIpCEGTQ5SAOHc9AfaA0rFes0CXqpS2AmH3AfjxxmHZ+995w9gDSfu8PoBI+RipV0WZ9rFOb6cKOU7d4r0+g41XlZz+otJl8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7629.namprd10.prod.outlook.com (2603:10b6:610:167::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.42; Fri, 4 Apr
 2025 09:16:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8583.038; Fri, 4 Apr 2025
 09:16:41 +0000
Message-ID: <ce1887ca-3b05-4a90-bb20-456f9fb3c4f5@oracle.com>
Date: Fri, 4 Apr 2025 10:16:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: compute the maximum repair reaping defer intent
 chain length
To: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
References: <20250403191244.GB6283@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250403191244.GB6283@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0031.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7629:EE_
X-MS-Office365-Filtering-Correlation-Id: c59c34e2-eb45-43b4-316c-08dd73596996
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mmo3UWNxRlNlNlRxYTRyRy93NkFNZTd0MVladlNVVU1FNUcyNUpET25IWWI0?=
 =?utf-8?B?QytETGtJYjVzV3VLMm00WWhWUFBRczZadldBVG5nbGRScXdua0lCcTNYZVNI?=
 =?utf-8?B?RGJNWWxMRVF1aTc3SUM5cTFJSUdBWGZuSm51cWprRkxTTjZuK09TZDJvY1Zk?=
 =?utf-8?B?WWhoQlhXKzBodWVkZ2taOXp2THo2TWZLNUwxVHdUZVQybmlKem45R2VrR3E0?=
 =?utf-8?B?QlkrQnNOekpWNWIrY3dGMTFOQzBTMEMyUHJUR2ZPTGFhbUN6ekZnbWVVZThN?=
 =?utf-8?B?Ly9jSGI5N1VXUThheFNJMUcyTkhxOXdVK1BuYk5DSWpCZFYyNHNUQnRkQStJ?=
 =?utf-8?B?Q3c1SDJDOWRpRGN4cUhhRDU1TElRcGU5M3d1cUJaMlREamNDS2lWeUFscDBB?=
 =?utf-8?B?aWVrRXE3Q1l0ZGQwWjlIZHFmcng5V2xwUTl6cTdvSE1xclJCV0JZZ3lyZWFT?=
 =?utf-8?B?K1luclYyQlhoNEExaDhPcElJOVI0R2F5emw1MEZ2bnFSUGI1ajVSNGFVeHYw?=
 =?utf-8?B?QTdSbnh1U2k4d3YvSDQrRk8xTHRFMW9xRDhsNnVib1dJeTExd3ZzWlZWT2N2?=
 =?utf-8?B?UmNHTUREM0RLdkJDMjJpY2F5VWRCMFNqcldlM2J4NGdGSHZWUDA5QTY1OEJ3?=
 =?utf-8?B?bE8wVmJ0WFNWMzNHL2hlTVJpQ3ZkRzRZSy9GVXFWQkVFRCtFN1dpY052UmZo?=
 =?utf-8?B?WmtOY0Q5VGRrQWdNNTBzZkVYaW11YjUrNTl1TDZPN28rK3FrWTRhRHNXeFVG?=
 =?utf-8?B?RkJ3bU1HSXJqR1RaSDVOd09TWXh1TlphVFBjZmNzeHpwckJQNGF5UVd6QWVQ?=
 =?utf-8?B?RUcwSS9JRG1Qcmd0K2NKMXdHWFNSSUlUY3dMY215SGhZL01XSFF0UW9OaG1z?=
 =?utf-8?B?bVl1T0NVOWZqV1UxZnVLUUNEVjh3ODkrY05wVDM3UVdUdVNtZVovMFFQckp5?=
 =?utf-8?B?UWxoblpGUU0zVWNNdlhTTExaTnRpZVdaNTc4UWNZeHB4Rk5LbkZIbUM3SzNG?=
 =?utf-8?B?b0Y4dmNvS2d4OXN1MWlKSWpFSHpaeUUydVdhS3hlY1FQdDRBMWUxb1R3ZlVB?=
 =?utf-8?B?RURDUjNHSnhFazBLa2w0YjIxQzFBTndXZ2Qrb1hyZkVKK1R4OFdIM1JGemEy?=
 =?utf-8?B?MnJXQW1LeiswckttcFBhcVlScTErenIwWGEwTTNIU0hOSlJNWkhvcWsvV2ZB?=
 =?utf-8?B?WEFqRFlGYWEvR3pQYzg2L0doWWsxckZSZUxpNk5tQTlySHBDM00zTzU3Wk1x?=
 =?utf-8?B?T2VqdTBCZ1NVUU5GbFRIMUxyL0dmS2R6eCsrZ3hFb2FYRHRualNVSDgxVlhQ?=
 =?utf-8?B?U0oyMHBEcDhQZHlJMmVka1pnakJDQXdXWEhLcjU2L01YQjVQdW1qSWhhSWVl?=
 =?utf-8?B?QmxvRjZwcytmL2paYXpDQUcrMDl4QStFSS90V201VGt5NkVMby8wRUJxZHFj?=
 =?utf-8?B?VytrYUhiRjlvdFZMUXpsZWZleXZWeWNpZStLSHlEdElOYXF6T2hmWlhKMjFt?=
 =?utf-8?B?S0c5SmNnWGpVYkVJT3NCZzNPQnJnRkxDcjNJNVhaOFRycHF3VGw5SjkwLzlY?=
 =?utf-8?B?ZkpmRjJzZ1hpbmtiVkl6cjNaUUhkVmNBZzd4bWtCamZpUXAzYzN3MFRuVExL?=
 =?utf-8?B?bWlaU1Z5NFVLRzhrZjJXTHhMWU0xeTNQT2lVMlNIcU1hb3JlTE5pUUVyMkQ3?=
 =?utf-8?B?bHlDcEtKNU1mTEtKYXpkMXBnaFlPWVlMK3hyMnFEWEFpYUczTTlaYVZwWjNW?=
 =?utf-8?B?ZWxaWm9LMXJnRWRFNTU4TmtJSXhFWjhVVmU5UXF5WXlXZlQ3N3hDRmtuUVFF?=
 =?utf-8?B?cGJqNXpnL2p3eWhJQi82SzE3c1BJTytzOWYvZmVGVWRmTEJ2MGEzY2NlY0xz?=
 =?utf-8?Q?tKIAzkPQqKPmB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVMzcFpqTkU4VzB3NmEvWDdnUHcyRVFJWmh1K0xYQ3h1akgzNUVaUHlyMGw2?=
 =?utf-8?B?aWdPN0NKdnMrdkMvbitYOGNSVkdsSGhaZk5JOWc1dzBtL1RyZ04vdWlaZ3Y1?=
 =?utf-8?B?WWs3ZVNSR2VlajZJT0lURDlLT1EwODNucmFvK21DOEU5SElOTXNnTGlPdUNZ?=
 =?utf-8?B?WXl4dEFucUY4UVBUcGlrM2pqbFIzZGxuR0EvNkY0NHpZYnZJOGc3S1Z0czFS?=
 =?utf-8?B?c2F2OUE2ZTBER2gwaGtJSVhFL1BzdDVaNUFXSEJ0aWxEc2ZSMXNVOFZmVFhn?=
 =?utf-8?B?TjJjZmNVeldLeGJ6UjNjaUs4SFpyUDMybmtvazZKenNlS2s4SmRnZDlIWDlq?=
 =?utf-8?B?T0UrZ05LUC8xZFFQR1I1UHBhZE9majRMSFExN05rdzYzTUhnZmNTZ1hDekVL?=
 =?utf-8?B?NldUQk4xMjcxNE1VSVVwRlB6YjJaL1dDajlsTi92L3l2Tnpoa2lvdHB4UnJn?=
 =?utf-8?B?T1FhRDJlSlRZK1NvS1k4RlRVWHZyMExoZzM4Sk5LN0YyTjl3WElMWFg0QUlZ?=
 =?utf-8?B?RUdhYzlGNTB0ZnZSQmZCeENoa0s4WFJDWEFxNWlucCszNURvYS9CMVQwNTh2?=
 =?utf-8?B?RU90eHJqV1ZlNTVsVEFjRWpkU1VRR2lhbWdGeU9GNHh6NHVDN2tFcnBPaVdv?=
 =?utf-8?B?dVNCRVNKNWVsTW9LNThWQWVKNXZjL05jM1dRUFRraDF3TGdSRVlYZDN0OFdV?=
 =?utf-8?B?UjlPeFM0L2U1L0lPcUp6bDJnQ050QVFBcTA3RTdlOVVzSTZmZkU0b2ZkcUNx?=
 =?utf-8?B?dVZCSnhwc0l6ZHlYcnBpVlN1RnVyUHI5RFpiR0VGUmFySVdXK0NVNzA0L2VB?=
 =?utf-8?B?MzJoY0lPdGp5NTZlRUUzK2JkWjgzS05PbUw4STRTQ0F6MU0zOXhXRDN2UGZv?=
 =?utf-8?B?K0l1cmRpTmp2Q29lNUZWdGhjSGRLRkU0L2F3Q3lTTld2aUJkOTRJemJ5YTZy?=
 =?utf-8?B?QnRqTkNTMk9SUE5PREdxWHlQRmFxN3BTbXk1SHRlY3JNaHJYZ1hiaE9ZaTRk?=
 =?utf-8?B?VktxckluaVVIZjhLS1hhZ3A2aHZHMFZsQk8wcTFMSENzOXNrTStZTDJZT1J1?=
 =?utf-8?B?aWF4UWcrK2FuWllXbFRCRE4yclBhNW1zaUR5akhIUi9oWVB0d3N6d2pkK05m?=
 =?utf-8?B?a0dLajVOdnRGTmNHc0FtdkV3SWl5bkxyVXdzaXI2R0hKdW5UR09aaFZLR080?=
 =?utf-8?B?TjdPWlVXQnVZQ2pLSFpicFp3MEVKQTBoNmdZaVVNOGY1YUFnR2hHRTVxU0xn?=
 =?utf-8?B?TEp5aWFvNFFTWmZVcERlVlB6R2dzNkdEbU5Xa05ZbDU5clZGbE5ORkpOL0Iy?=
 =?utf-8?B?cENqaFNTNE5ZK05HWGk1N2RkbEdveEsxbUswQlYwamxQeWRMNlNHVFd4bTVM?=
 =?utf-8?B?WVh3d2M5eXVxUXB5alc4Qk5yaDNaSHNwVXBRQWJWT2I3WEJodmNTYzBqYWYv?=
 =?utf-8?B?S2JPT28xR3VZWkdCZ0dPK042NFdRN2NTaHNoYmFVODBaTUlHZ2JUVXRiVnVp?=
 =?utf-8?B?NVNiZXZ3V3hkQW85K0RvSmNXaWRaRk51WkQwMVp2U2xVeW44ODZWd1Z2VSt6?=
 =?utf-8?B?Z2F3VWV3bzBzYmplb21ySFlRWWsrWWp5NUREVEhNSEg5aVRpWGJCdS9vbmpZ?=
 =?utf-8?B?NG90L2RyNi96MTVxcWNnN01lWFN1SEhPYmZFb1gwbGNHQmVQbHZRalRrcVJh?=
 =?utf-8?B?MStMbEZEMUZ4TTdkODVadDUzeVZBOW9BT29XZnNSNWJHQURjdm5FZnBxTWNJ?=
 =?utf-8?B?NTR4ZVloWlgyeHlmZUVLOVU4RHRVa3lNOVFYWXUweUh5TUxNN0FJQmZsaGRr?=
 =?utf-8?B?TFhXdVZzL0V0b0xRL2NpNTU4Mm1ZZ2hnYytpMy9IUTZ5dko4dWdlVWFWNVVa?=
 =?utf-8?B?aGh1a01KV2JDekxtbnhOb2MvbGFkb3JnbzZhL0Z0cGluZEVaZHNiQ2ZyaDYz?=
 =?utf-8?B?NlFTKzE4dXJwdktmSmdvTHJ6b0JTMFJOcGNPVkdqYjZJbURDZDBqRmV6QUh5?=
 =?utf-8?B?aTRaVnZ5TGNkRkFEWG5MdzBoS0luUHdEQjRPa3NPY1ZPcEx2UnQyMzlyOHZv?=
 =?utf-8?B?d2Rxc2dpdXJUR2ZFd2NCZk5BcVc2ZHZ4bEsvMjkvaVBDS1FHNFpvQ1Q0WDg4?=
 =?utf-8?Q?v8uipOWDfJ3qCDp4poswQEGrK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DZM7mmjEzxL1eQ/CguSipgEqH1xmrKBvOD+RK2pNtrj+dIvrzZodKGEbZJzLYftzvuy+R6s2chArATSBAqxwCzOz/s4Oyv48+GRXuAeHpqv3NuGbffQlCb3REAhicW4FoJwtChKLlt+3YNic8rXSYxf4xDdkMnACFiaknwRwoA7vsWq5lhvaz0PjIcUGPQYcITXBOnWByXDWAS0SLl+KzLledetYnJY5ZI/l3Res9qHaEGhtjddtYFujwiDWaRZ886EpJBCIkMhaSmuFK7lbcFpTu9fh68shko16lf81icx0c93lWEka9XEQk+jFT9Kd/WGqYOq0XlSehOP9SOPXEzKTRuPE3dwCl8zHTQpsdb2YbRJS7RH2FxrUGurX2J0flvSoMYH+naHztCI6RX+sdlPzAWw3R0p5R8JKCDZ+JY7m1gFjMXwZ0jz9aYsplFC94d75Igf7I4K9LmUNwe8BJKlwCEVpZik+aC8yNXhJ1B4TOoD6GnfHa6zmKnkDlHK99sZPqr9YxmZAmHCK67xob/bKL6EOVS3Wa01y+YS14MaINwvCy865nUO1Xbu514ANFEahEBO+bb3TPE9hmVluLzQo4QnDFQ7zxormcrDtUpE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c59c34e2-eb45-43b4-316c-08dd73596996
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 09:16:41.9278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuKIDvz3tafE9sCP9yj2jrqHaLKRxsktmFNMii92dW7PfOsHeGtGvF4gVD+KB9ChfED4lnha0Ulp6PWa24WDzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_03,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504040062
X-Proofpoint-GUID: -rcHbhZRRkXJNaXehEtUCrrEBAiyFoqX
X-Proofpoint-ORIG-GUID: -rcHbhZRRkXJNaXehEtUCrrEBAiyFoqX

On 03/04/2025 20:12, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Actually compute the log overhead of log intent items used in reap
> operations and use that to compute the thresholds in reap.c instead of
> assuming 2048 works.  Note that there have been no complaints because
> tr_itruncate has a very large logres.
> 

Thanks for this, but I have comments at the bottom

> Cc: <stable@vger.kernel.org> # v6.6
> Fixes: 1c7ce115e52106 ("xfs: reap large AG metadata extents when possible")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>   fs/xfs/scrub/trace.h       |   29 ++++++++++++++++++++++++++
>   fs/xfs/xfs_bmap_item.h     |    3 +++
>   fs/xfs/xfs_extfree_item.h  |    3 +++
>   fs/xfs/xfs_log_priv.h      |   13 +++++++++++
>   fs/xfs/xfs_refcount_item.h |    3 +++
>   fs/xfs/xfs_rmap_item.h     |    3 +++
>   fs/xfs/scrub/reap.c        |   50 +++++++++++++++++++++++++++++++++++++++-----
>   fs/xfs/scrub/trace.c       |    1 +
>   fs/xfs/xfs_bmap_item.c     |   10 +++++++++
>   fs/xfs/xfs_extfree_item.c  |   10 +++++++++
>   fs/xfs/xfs_log_cil.c       |    4 +---
>   fs/xfs/xfs_refcount_item.c |   10 +++++++++
>   fs/xfs/xfs_rmap_item.c     |   10 +++++++++
>   13 files changed, 140 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index d7c4ced47c1567..172765967aaab4 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -2000,6 +2000,35 @@ DEFINE_REPAIR_EXTENT_EVENT(xreap_agextent_binval);
>   DEFINE_REPAIR_EXTENT_EVENT(xreap_bmapi_binval);
>   DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
>   
> +DECLARE_EVENT_CLASS(xrep_reap_max_deferred_reaps_class,
> +	TP_PROTO(const struct xfs_trans *tp, unsigned int per_intent_size,
> +		 unsigned int max_deferred_reaps),
> +	TP_ARGS(tp, per_intent_size, max_deferred_reaps),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(unsigned int, log_res)
> +		__field(unsigned int, per_intent_size)
> +		__field(unsigned int, max_deferred_reaps)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = tp->t_mountp->m_super->s_dev;
> +		__entry->log_res = tp->t_log_res;
> +		__entry->per_intent_size = per_intent_size;
> +		__entry->max_deferred_reaps = max_deferred_reaps;
> +	),
> +	TP_printk("dev %d:%d logres %u per_intent_size %u max_deferred_reaps %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->log_res,
> +		  __entry->per_intent_size,
> +		  __entry->max_deferred_reaps)
> +);
> +#define DEFINE_REPAIR_REAP_MAX_DEFER_CHAIN_EVENT(name) \
> +DEFINE_EVENT(xrep_reap_max_deferred_reaps_class, name, \
> +	TP_PROTO(const struct xfs_trans *tp, unsigned int per_intent_size, \
> +		 unsigned int max_deferred_reaps), \
> +	TP_ARGS(tp, per_intent_size, max_deferred_reaps))
> +DEFINE_REPAIR_REAP_MAX_DEFER_CHAIN_EVENT(xreap_agextent_max_deferred_reaps);
> +
>   DECLARE_EVENT_CLASS(xrep_reap_find_class,
>   	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
>   		 xfs_extlen_t len, bool crosslinked),
> diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
> index 6fee6a5083436b..72512fc700e21a 100644
> --- a/fs/xfs/xfs_bmap_item.h
> +++ b/fs/xfs/xfs_bmap_item.h
> @@ -72,4 +72,7 @@ struct xfs_bmap_intent;
>   
>   void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
>   
> +unsigned int xfs_bui_item_overhead(unsigned int nr);
> +unsigned int xfs_bud_item_overhead(unsigned int nr);
> +
>   #endif	/* __XFS_BMAP_ITEM_H__ */
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index 41b7c43060799b..ebb237a4ae87b4 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -94,4 +94,7 @@ void xfs_extent_free_defer_add(struct xfs_trans *tp,
>   		struct xfs_extent_free_item *xefi,
>   		struct xfs_defer_pending **dfpp);
>   
> +unsigned int xfs_efi_item_overhead(unsigned int nr);
> +unsigned int xfs_efd_item_overhead(unsigned int nr);
> +
>   #endif	/* __XFS_EXTFREE_ITEM_H__ */
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index f3d78869e5e5a3..39a102cc1b43e6 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -698,4 +698,17 @@ xlog_kvmalloc(
>   	return p;
>   }
>   
> +/*
> + * Given a count of iovecs and space for a log item, compute the space we need
> + * in the log to store that data plus the log headers.
> + */
> +static inline unsigned int
> +xlog_item_space(
> +	unsigned int	niovecs,
> +	unsigned int	nbytes)
> +{
> +	nbytes += niovecs * (sizeof(uint64_t) + sizeof(struct xlog_op_header));
> +	return round_up(nbytes, sizeof(uint64_t));
> +}
> +
>   #endif	/* __XFS_LOG_PRIV_H__ */
> diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> index bfee8f30c63ce9..e23e768e031e20 100644
> --- a/fs/xfs/xfs_refcount_item.h
> +++ b/fs/xfs/xfs_refcount_item.h
> @@ -76,4 +76,7 @@ struct xfs_refcount_intent;
>   void xfs_refcount_defer_add(struct xfs_trans *tp,
>   		struct xfs_refcount_intent *ri);
>   
> +unsigned int xfs_cui_item_overhead(unsigned int nr);
> +unsigned int xfs_cud_item_overhead(unsigned int nr);
> +
>   #endif	/* __XFS_REFCOUNT_ITEM_H__ */
> diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
> index 40d331555675ba..5fed8864bc32cc 100644
> --- a/fs/xfs/xfs_rmap_item.h
> +++ b/fs/xfs/xfs_rmap_item.h
> @@ -75,4 +75,7 @@ struct xfs_rmap_intent;
>   
>   void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
>   
> +unsigned int xfs_rui_item_overhead(unsigned int nr);
> +unsigned int xfs_rud_item_overhead(unsigned int nr);
> +
>   #endif	/* __XFS_RMAP_ITEM_H__ */
> diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> index b32fb233cf8476..2fd9b7465b5ed2 100644
> --- a/fs/xfs/scrub/reap.c
> +++ b/fs/xfs/scrub/reap.c
> @@ -36,6 +36,9 @@
>   #include "xfs_metafile.h"
>   #include "xfs_rtgroup.h"
>   #include "xfs_rtrmap_btree.h"
> +#include "xfs_extfree_item.h"
> +#include "xfs_rmap_item.h"
> +#include "xfs_refcount_item.h"
>   #include "scrub/scrub.h"
>   #include "scrub/common.h"
>   #include "scrub/trace.h"
> @@ -106,6 +109,9 @@ struct xreap_state {
>   
>   	/* Number of deferred reaps queued during the whole reap sequence. */
>   	unsigned long long		total_deferred;
> +
> +	/* Maximum number of intents we can reap in a single transaction. */
> +	unsigned int			max_deferred_reaps;
>   };
>   
>   /* Put a block back on the AGFL. */
> @@ -165,8 +171,8 @@ static inline bool xreap_dirty(const struct xreap_state *rs)
>   
>   /*
>    * Decide if we want to roll the transaction after reaping an extent.  We don't
> - * want to overrun the transaction reservation, so we prohibit more than
> - * 128 EFIs per transaction.  For the same reason, we limit the number
> + * want to overrun the transaction reservation, so we restrict the number of
> + * log intent reaps per transaction.  For the same reason, we limit the number
>    * of buffer invalidations to 2048.
>    */
>   static inline bool xreap_want_roll(const struct xreap_state *rs)
> @@ -188,13 +194,11 @@ static inline void xreap_reset(struct xreap_state *rs)
>   	rs->force_roll = false;
>   }
>   
> -#define XREAP_MAX_DEFER_CHAIN		(2048)
> -
>   /*
>    * Decide if we want to finish the deferred ops that are attached to the scrub
>    * transaction.  We don't want to queue huge chains of deferred ops because
>    * that can consume a lot of log space and kernel memory.  Hence we trigger a
> - * xfs_defer_finish if there are more than 2048 deferred reap operations or the
> + * xfs_defer_finish if there are too many deferred reap operations or the
>    * caller did some real work.
>    */
>   static inline bool
> @@ -202,7 +206,7 @@ xreap_want_defer_finish(const struct xreap_state *rs)
>   {
>   	if (rs->force_roll)
>   		return true;
> -	if (rs->total_deferred > XREAP_MAX_DEFER_CHAIN)
> +	if (rs->total_deferred > rs->max_deferred_reaps)
>   		return true;
>   	return false;
>   }
> @@ -495,6 +499,37 @@ xreap_agextent_iter(
>   	return 0;
>   }
>   
> +/*
> + * Compute the worst case log overhead of the intent items needed to reap a
> + * single per-AG space extent.
> + */
> +STATIC unsigned int
> +xreap_agextent_max_deferred_reaps(
> +	struct xfs_scrub	*sc)
> +{
> +	const unsigned int	efi = xfs_efi_item_overhead(1);
> +	const unsigned int	rui = xfs_rui_item_overhead(1);
> +
> +	/* unmapping crosslinked metadata blocks */
> +	const unsigned int	t1 = rui;
> +
> +	/* freeing metadata blocks */
> +	const unsigned int	t2 = rui + efi;
> +
> +	/* worst case of all four possible scenarios */
> +	const unsigned int	per_intent = max(t1, t2);
> +
> +	/*
> +	 * tr_itruncate has enough logres to unmap two file extents; use only
> +	 * half the log reservation for intent items so there's space to do
> +	 * actual work and requeue intent items.
> +	 */
> +	const unsigned int	ret = sc->tp->t_log_res / (2 * per_intent);
> +
> +	trace_xreap_agextent_max_deferred_reaps(sc->tp, per_intent, ret);
> +	return max(1, ret);
> +}
> +
>   /*
>    * Break an AG metadata extent into sub-extents by fate (crosslinked, not
>    * crosslinked), and dispose of each sub-extent separately.
> @@ -556,6 +591,7 @@ xrep_reap_agblocks(
>   		.sc			= sc,
>   		.oinfo			= oinfo,
>   		.resv			= type,
> +		.max_deferred_reaps	= xreap_agextent_max_deferred_reaps(sc),
>   	};
>   	int				error;
>   
> @@ -668,6 +704,7 @@ xrep_reap_fsblocks(
>   		.sc			= sc,
>   		.oinfo			= oinfo,
>   		.resv			= XFS_AG_RESV_NONE,
> +		.max_deferred_reaps	= xreap_agextent_max_deferred_reaps(sc),
>   	};
>   	int				error;
>   
> @@ -922,6 +959,7 @@ xrep_reap_metadir_fsblocks(
>   		.sc			= sc,
>   		.oinfo			= &oinfo,
>   		.resv			= XFS_AG_RESV_NONE,
> +		.max_deferred_reaps	= xreap_agextent_max_deferred_reaps(sc),
>   	};
>   	int				error;
>   
> diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> index 2450e214103fed..987313a52e6401 100644
> --- a/fs/xfs/scrub/trace.c
> +++ b/fs/xfs/scrub/trace.c
> @@ -22,6 +22,7 @@
>   #include "xfs_parent.h"
>   #include "xfs_metafile.h"
>   #include "xfs_rtgroup.h"
> +#include "xfs_trans.h"
>   #include "scrub/scrub.h"
>   #include "scrub/xfile.h"
>   #include "scrub/xfarray.h"
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 3d52e9d7ad571a..586031332994ff 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -77,6 +77,11 @@ xfs_bui_item_size(
>   	*nbytes += xfs_bui_log_format_sizeof(buip->bui_format.bui_nextents);
>   }
>   
> +unsigned int xfs_bui_item_overhead(unsigned int nr)
> +{
> +	return xlog_item_space(1, xfs_bui_log_format_sizeof(nr));
> +}
> +
>   /*
>    * This is called to fill in the vector of log iovecs for the
>    * given bui log item. We use only 1 iovec, and we point that
> @@ -168,6 +173,11 @@ xfs_bud_item_size(
>   	*nbytes += sizeof(struct xfs_bud_log_format);
>   }
>   
> +unsigned int xfs_bud_item_overhead(unsigned int nr)
> +{
> +	return xlog_item_space(1, sizeof(struct xfs_bud_log_format));
> +}
> +
>   /*
>    * This is called to fill in the vector of log iovecs for the
>    * given bud log item. We use only 1 iovec, and we point that
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index a25c713ff888c7..1dd7f45359e090 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -82,6 +82,11 @@ xfs_efi_item_size(
>   	*nbytes += xfs_efi_log_format_sizeof(efip->efi_format.efi_nextents);
>   }
>   
> +unsigned int xfs_efi_item_overhead(unsigned int nr)
> +{
> +	return xlog_item_space(1, xfs_efi_log_format_sizeof(nr));
> +}
> +
>   /*
>    * This is called to fill in the vector of log iovecs for the
>    * given efi log item. We use only 1 iovec, and we point that
> @@ -253,6 +258,11 @@ xfs_efd_item_size(
>   	*nbytes += xfs_efd_log_format_sizeof(efdp->efd_format.efd_nextents);
>   }
>   
> +unsigned int xfs_efd_item_overhead(unsigned int nr)
> +{
> +	return xlog_item_space(1, xfs_efd_log_format_sizeof(nr));
> +}
> +
>   /*
>    * This is called to fill in the vector of log iovecs for the
>    * given efd log item. We use only 1 iovec, and we point that
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 1ca406ec1b40b3..f66d2d430e4f37 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -309,9 +309,7 @@ xlog_cil_alloc_shadow_bufs(
>   		 * Then round nbytes up to 64-bit alignment so that the initial
>   		 * buffer alignment is easy to calculate and verify.
>   		 */
> -		nbytes += niovecs *
> -			(sizeof(uint64_t) + sizeof(struct xlog_op_header));
> -		nbytes = round_up(nbytes, sizeof(uint64_t));
> +		nbytes = xlog_item_space(niovecs, nbytes);
>   
>   		/*
>   		 * The data buffer needs to start 64-bit aligned, so round up
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index fe2d7aab8554fc..7ea43d35b1380d 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -78,6 +78,11 @@ xfs_cui_item_size(
>   	*nbytes += xfs_cui_log_format_sizeof(cuip->cui_format.cui_nextents);
>   }
>   
> +unsigned int xfs_cui_item_overhead(unsigned int nr)
> +{
> +	return xlog_item_space(1, xfs_cui_log_format_sizeof(nr));
> +}
> +
>   /*
>    * This is called to fill in the vector of log iovecs for the
>    * given cui log item. We use only 1 iovec, and we point that
> @@ -179,6 +184,11 @@ xfs_cud_item_size(
>   	*nbytes += sizeof(struct xfs_cud_log_format);
>   }
>   
> +unsigned int xfs_cud_item_overhead(unsigned int nr)
> +{
> +	return xlog_item_space(1, sizeof(struct xfs_cud_log_format));
> +}
> +
>   /*
>    * This is called to fill in the vector of log iovecs for the
>    * given cud log item. We use only 1 iovec, and we point that
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 89decffe76c8b5..3e214ce2339f54 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -77,6 +77,11 @@ xfs_rui_item_size(
>   	*nbytes += xfs_rui_log_format_sizeof(ruip->rui_format.rui_nextents);
>   }
>   
> +unsigned int xfs_rui_item_overhead(unsigned int nr)
> +{
> +	return xlog_item_space(1, xfs_rui_log_format_sizeof(nr));
> +}
> +
>   /*
>    * This is called to fill in the vector of log iovecs for the
>    * given rui log item. We use only 1 iovec, and we point that
> @@ -180,6 +185,11 @@ xfs_rud_item_size(
>   	*nbytes += sizeof(struct xfs_rud_log_format);
>   }
>   
> +unsigned int xfs_rud_item_overhead(unsigned int nr)

I guess that it is intentional, but nr is not used

> +{
> +	return xlog_item_space(1, sizeof(struct xfs_rud_log_format));
> +}

I just noticed that this function - in addition to 
xfs_cud_item_overhead() and xfs_cui_item_overhead() - are not referenced 
in this patch, but only in the rest of the internal series which this is 
taken from.

> +
>   /*
>    * This is called to fill in the vector of log iovecs for the
>    * given rud log item. We use only 1 iovec, and we point that

