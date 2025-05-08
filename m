Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9833218EB7
	for <linux-xfs@vger.kernel.org>; Thu,  8 May 2025 06:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686547; cv=fail; b=ZKbTQf1onXCoQR0GB0k3nDx6/O70ed9RklmJsMbRh7r6y3LNPEZSUeERMxeACaEeOammvpCgt7jSkg7UtC6V8xvH/svp5C97VqCs4oTLsCoWoTrafYlsvlgz3d4099MERE77Jlf5lTjXkL0erSt+ozZARlIhTbVXVaK45PKx6+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686547; c=relaxed/simple;
	bh=UPvj0oAOwO7VFz0+Y7ocqMzSBBeLDgAcHMDvA1cqpU8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sfbU+gmRy2snrHrdJ1J99XiVjYqOJ8KgrfmzDfZDxdNDoDqqlTLB4BRNYSG6xcTMc9G2rc3O5ShkwJsUZqnLXubrXr3zPwU2wYPzs+KHkgdDfUpuWQmMN6cUViMBRX2EghbDGj7ws0a3hkR8BdYjJR0rBm0KGhLljNseTFUaLsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hwXpnfKs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U52zcai5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hwXpnfKs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U52zcai5"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5486HHBf025628;
	Thu, 8 May 2025 06:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4eSSoJfRHSMYFZYDrhQKBbWRxnGekV55mhcCMVsfSWg=; b=
	hwXpnfKserXDBnGzpwhJhciQlD42wvkasWJ2Aji6OiG7J/QerBVflviiIgLV5VHI
	0fZzi6je2+1JrZnuTPZplpFIQvUziBWTd4/0cnsBh3y3OjAr8OQrgG2o2tpBnPCV
	nHa6XnTV1bS3ZxwAKWZ1YM/tVp/PtfT1RCjPUYWOXlGZ/2IupuHTSD+dKdmGTq+2
	RsmP0DwFttyPus+mwx34tGruPmuOpWhWX5SK1BuGORGUItQHf19LAEzPo7CBoBdc
	N0f9hlBA1dUGAbdR1J2GJMrSmVv8+WS3KCTozytOpe4DxMzLCFpAhyTuPXsxJTxE
	XDqVG6sGukYsrfLEH2TM4A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46gq75g1a0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 May 2025 06:42:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5485x29a002011;
	Thu, 8 May 2025 06:42:16 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azlp17011030.outbound.protection.outlook.com [40.93.12.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46gmcbd360-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 May 2025 06:42:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZzLsNjZqkyWJmZ4Z9od/TULPiAh1AxSKsRC79u+AAS3Go+65NwkhuRDf8CgCmI1z02JfDKkypYVMrxgPlPxdyi8aC8biUGXsOVjXCi3N/igE3dpLmX2Dgj53rbw4UZTHAu3TzwphrpjW7q/kyIOPijFzAt1OwrRWjIA+VHxOmi7v250VZW3PSMoPXvKfFSINyZnC8WlVZjpt3njmwY1Mrjl5b3kaC/sdjnq1hfLB+hH5yMOET3H3Zp+cqw0pEDguqGgtY9zZYo7Tlxtm+EFJKQoc0bhOS6wRbXZWuvxloe2rVUUtdM9y8N3bVIymHENcLw46p0DexQ2cRMR4uDOdcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4eSSoJfRHSMYFZYDrhQKBbWRxnGekV55mhcCMVsfSWg=;
 b=vmiPo78bM5Dt1Q3iKzu6ATQtd/d02zcHG974iJfS4eNTudwrhzFsFwAmOSEWvGKHXR/K2w/jMcjrD/OiT2zQkrn+6V/yrE8x8ApFAHjRY3OkDyRS77Rt8+rkjoVGnAX7rebSv3NbKfjufhMJs5mx8bMzDwVULnuPf4c70B5XZQRZxtmRWMeMl5txKJw2ojRcvzLpVYiuitMpll2hY0NsjsX7Mnwjb6vTR38W53Ws9G7Y4BBLJkDNFoRny9ZxuZFWlXwprGAZUfBj4DeDaEpkTJiOPma2WWEAVeDCjJUmw44XUOWq+/6y2hwZTbPN/dN8Pr/EOvsw46FHk6fVVv1xYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eSSoJfRHSMYFZYDrhQKBbWRxnGekV55mhcCMVsfSWg=;
 b=U52zcai59TzkPK8SoSewpK2O1sIxJUd0H58j32PXgNszdfghDeKKbJQSrY4YsMDBWDgVSkbN9pON/Q+T6o2h6PtISlhESd4D6hmpcwYX/TgYH4N8ixlh4I/vKD0PA/jJvxFxCkfiq/SXcALFdyifLtP2RC/bMsVtjldMLLbovxE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB6851.namprd10.prod.outlook.com (2603:10b6:930:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.35; Thu, 8 May
 2025 06:42:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 06:42:09 +0000
Message-ID: <468bb133-500e-4411-b6fd-08ede66aee72@oracle.com>
Date: Thu, 8 May 2025 07:42:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] man: adjust description of the statx manpage
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
References: <174665514924.2713379.3228083459035002170.stgit@frogsfrogsfrogs>
 <174665514991.2713379.10219378506495036051.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <174665514991.2713379.10219378506495036051.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0229.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB6851:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b18567-7e26-4fa7-b615-08dd8dfb74ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bTN0dTM2bjNrQU9QYjNRbHF4dGlVWHBNQlhaWXF5bUMvWTlveEZDd0tKTHJS?=
 =?utf-8?B?NUZZdnkzRzVtNXpjb3l3T0RpaXRhcWlydjcxZ2gzYWJlQUdKZHBUWVNSZlF1?=
 =?utf-8?B?eW96ZkJEUVpxcy9ncVJPa0R0aEtvQkZCR0ptdjhSTUU3UVc3R2tMeG0rbW9V?=
 =?utf-8?B?WmtHTGVWcEdlc1dCNW53TlFOT1RQcGZYSWhENndKS3VXc2JibnFxWThHMEFP?=
 =?utf-8?B?VE5paTE1bUxlK3MrbC91N2dZY2c0L01QUThLWUpHYUpwZXViTHl3S2laazFw?=
 =?utf-8?B?andHYk16Um9RbVdocHY0R2UxKzNWMWR2dDZ1RGdiTFJxdU9yVFYrclVQYkUy?=
 =?utf-8?B?MGY4VHJ0b0c4Z1dHQ3gwK2FTbENXTml0Q282ZWdiWEpxMDdzenp5cFl6TzdI?=
 =?utf-8?B?c25VSkNWdW16UG9EWUpBTjJXWno1bUppbzd5bWVmMXRSamJFN1ZRNFBHL0JO?=
 =?utf-8?B?VmgxeTl4YUJpekNCaHl4RG1rZFVvZWlNSER4d1dkVVh4b0lFTVZzb2FLMXY3?=
 =?utf-8?B?WGNTZFZKY2VCMXBIbkNqdk9TT0pCbzRoV2NKTmxOaUprQ1NBZ0NhcndtRXRC?=
 =?utf-8?B?cTZIRTZpdm5GcDZvS1hMc3JrT09mQU9TejVHNjRJR0huMy9KditlZkFvc08v?=
 =?utf-8?B?YnJEN0VKaEJ0cVBvekVDQmszbnJjaEpPRjRscUc1d2tTMWNucjJCRXdPTmlD?=
 =?utf-8?B?QWl4MFlobHk3Q0dlWW9pcWVOMUxtZVlSeGRlYUI0Z0Y5Q2VFWGtIVVRZWjd3?=
 =?utf-8?B?YklrUjNTQkhJeHM5Vjg0ZHg2NFFTQ1lFMW05eEEvOW5OOURxekppTW1CQm15?=
 =?utf-8?B?cDRFVitWTk1lL2lYOExYNjFta1czU2tHM3hIZnZjbnhMMEo3OUpXS2U4b1Zh?=
 =?utf-8?B?eXFiRmtraTg0c2h3bHdGcnpXRksrWjhBZkFoMzA2dExFRTlzbHpoS0xHWUJs?=
 =?utf-8?B?eW5TcE5vNFEwNTlLUGRzV0gvZlUzaWxOUXpydXIvenBIN0VsVVpaeEg3akxX?=
 =?utf-8?B?eFlKZWtwWmxidVA2bXVRYm5iOEZzMlJ1NXNzWG1kRXQ2Smh6Z3c5dE05eTc1?=
 =?utf-8?B?Wm50RGlLSWVWOWJTWEFmRm4wbEVqQlV6WHJQTVNzNDN4SDJVaFRTSThzMEVr?=
 =?utf-8?B?MmRSWXNVNHg1bmNzckN5YkcxNnpvbmpYbU9yZkVZam8yTzBKZzBDd3R5LzZp?=
 =?utf-8?B?RlVpWk14bGRWNkdXOVNEU3NtNzdsV0NYNE9STktZZkpycSt2alFQK2JWYkdZ?=
 =?utf-8?B?WENGZVBMb0R3cTRaVHJUeDhueWxJWmVlUWkzTHJ6cmhNQTJaS2dIQ3RuWk10?=
 =?utf-8?B?clpPYXpUNHFMM1FmaGM2SUtnLzdiM29jbTl1VUNXZXhDQkhCZkdtM0hsTEhw?=
 =?utf-8?B?OXJwWFBnbEg0WkMvdjhXTUNYRlc1ZTNWMUoyYkRnVkR6TDIxRHRkNCtzM2Q4?=
 =?utf-8?B?dGtsK0g4U2lwZkEvTE42RWZHWWdHZkFSU1YwOU9UYjJiMzhmeUVaQWJmTENj?=
 =?utf-8?B?SmNHTlgzamcyOTZsem4rUFZuMXp3SzVwNW4xdmEwaEsrS08zc05RR2x3VFdE?=
 =?utf-8?B?cXIzZFpoUlhIT1gvaTBxM2lrSlhDY1AwQ3pMTmxVZWhIdFhBRkx1bWNuUDhO?=
 =?utf-8?B?bGIvMmFpOVBaUmN2UUpPam5LNUMvSE01SGxDQjJxblcyTXZ1dWxRV3VWenFp?=
 =?utf-8?B?ZkgzZWk1bCtXNC96YkxLS1RtSy9jRmpSTHpDWnY0OFFTRllmQW0ydjExMnNO?=
 =?utf-8?B?YWVtTXY2OXIrSUx6Yk9XVmowTWgybzhjUEw4WTNXVU4vbEcvcHpoajZXMEh3?=
 =?utf-8?B?MGhOZUFCVktuTFhzN0UwUFI0NjlsblF5d2FXbHpHNVY5RHg0U0RMY1FWN0Q0?=
 =?utf-8?B?cW90cnoxUVI2SHJPSDI1VDdUTnVhaVZTd2FuSk0vUmMrc3N3ZExyS1JYYTVQ?=
 =?utf-8?Q?i4XKtVoSenk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjluLzMwT0JZOHRheUNoTDlvVk1wSzQzNHpYV3NMZW9lZkV5UFp6d2tEb0M1?=
 =?utf-8?B?UTNmWm9nZ21Oa05WTkxNOHl0S29rc2JpYSswT0FCRGtLSFpRUU5RY285SkRE?=
 =?utf-8?B?bHR6RUYrNVlsUHRUSmEvdytNSkRmeWVsdWlQT3o5OFo5SmY4TmhESmptYlp1?=
 =?utf-8?B?ZXMrUFpVeHZaUGs4KzRUbFNkRy9kZzhXU3p6eFAyK0ZMNXlQcWlZTTF6ZHZR?=
 =?utf-8?B?WVk1K294SXpLU21LTVJMVkZnSmtwc29sVDV2T1FRdi9yQVRqRHF2MjRTOW5l?=
 =?utf-8?B?eDE1U2pSV0dmczBHUXZ2R3ZmNjJhZWNpSjlWb0lzSkhiV2ZFK3FwZi8wd2My?=
 =?utf-8?B?M3VLRkU4TTNwQzlwcHhScFVBUGFwcHFZTEJ0b2JvV0xHcVBUd2gxL3E5c1ZK?=
 =?utf-8?B?c2hNejg5WkRDY2tERlp3aDg2Tyt3VzVFMHFZZUJCVkN5b1pGMnFHbENIbGFQ?=
 =?utf-8?B?UUsya3J4VEtyZ2xhQlRmTThDQlRwNytKeHB3bE5jakExT0FKakp5cHBBSFVa?=
 =?utf-8?B?NzZCbHVXMzVEUHpQYkV0UzNDZXdHUStaY3FiNm1YVGZLaFgyc08rVzV0U0lQ?=
 =?utf-8?B?TFFZekV2dUxSOVJ0ZXZhTk9KUUN4WDdad1JkZE1XaDB2V0xuWFFFWlJRb3Ey?=
 =?utf-8?B?elpOZ01sRXdXV1BSazhaYWdkMnJkVmxZclErcE16bDU5Sk9TaG1hY1YyNW5t?=
 =?utf-8?B?NmErd0xTUVAzUmZoQTNhbm5ibW1OVkg5QTNaNTJoeTNzam13enZkU3A4UDlG?=
 =?utf-8?B?RVhCd3B4aDNIWVUzelo0TkZleXBFRkhOVmM3T1QvSWRVKzk1SThmeDhmMUJF?=
 =?utf-8?B?aFJrOHdSZVp5Q2N5ek1ZS2Vnd1U0TlI4eUJCTG1DK0RqMGkxOUVMekV5Tmpz?=
 =?utf-8?B?a1VZcVIyOVFJb2t4S09MU0ZNYVhpNUxHeEZCMkRGQ2RIRW5SRmVNOHRkcjhr?=
 =?utf-8?B?OXFuUW1WYTdNKzF2NDdkR2UwUXdYejJDdTBUY2lSVkNpOXZNV0lRcmFVdENO?=
 =?utf-8?B?TkpQK09XQzBDcjJSaUh0YWtuTXcwZ1JzN1VwdGRSWUtjMlpxakE0OUdTaFVN?=
 =?utf-8?B?Qkw1bGNJTXRSSWZOSDJjZ0pwamZBS3J1aDJ0cCtOL2M0Skk5YXVtVzhvYVBy?=
 =?utf-8?B?OUloWmhKZ29XY2tFM0xiMm5KVDdmY1pSazNmU29jaFVIUEx5aDNqSjRQeUZi?=
 =?utf-8?B?WEIwcVFUTUpEMTJPVVFLNjNSejJqOHFmUXZNd21GYWhnUEFRZ1BPVTVrWmxN?=
 =?utf-8?B?aFV2bkJuNm1XdmhkZ0F6emNYSGxRenBjVVdNb2thUTA5TnN1MG5VaENGalJG?=
 =?utf-8?B?Yk5PdEVXWWZjU1YrQkRzdWtpdEFabklvWSt0YXdUbjBjQVFEM2dQV29pVTJT?=
 =?utf-8?B?UUdEWE8xMDhpOFUzQkk1T1JQQmJ2dXBmc1o2d0xhNEpYbEFkQllCVlJYcWtj?=
 =?utf-8?B?UFZKalQ0MHVtU2U2dlRwY29QcDVNWmJuSTRwZW9qMkdUMzFxcjhwakY0b2JK?=
 =?utf-8?B?alpoNi9CdmJtdjN0b3JyeGhSc1VNU25uT3M0ZW5rejlFeWttSm9TRWRHc2hx?=
 =?utf-8?B?aENiNzQwcjBuTnRTUHQwR1lJT2h4SVF2alZrbWxGV0xTOHVrYUNWa1pnZ3BU?=
 =?utf-8?B?RTAxYlR6MzlVVXVaRHhoOVlRQ1V6LzJQbjUvcFZ1THkyYlNRZldzeTJnNU11?=
 =?utf-8?B?TTVSbUsvSTFEUmM3Wkl2alYwVEJqUFNSUWlvNUxBall1MWhaYjJ4aDBWWWl2?=
 =?utf-8?B?WnhDR0c0SEttdnh1NzlLdGZxQVRiWnEvbUtvZkhzZGVsalVDWElrb3dyTUxu?=
 =?utf-8?B?elp4aVVmMmpHTzhnbVc5RVMxZndQR1ZBRlVZWUwzVEMrU0QzRDN4aksrTmcz?=
 =?utf-8?B?bXRZUTVqOGRxZllvNFdkTXpWeEg3MmhWSFV3b0Y5OTg4MWsweFJZYXdEdTUv?=
 =?utf-8?B?dzd2NjlabmNkTzFWVENBdmJyY3FyR1NOV0VFQWllOFlJQ0lzejZLS09PSWt0?=
 =?utf-8?B?RDlRR0V3UFM3cFd0cVdYSHVCeDMzUVBaalhiMEJoWVN3Y3I2ckpKWmpMcmRw?=
 =?utf-8?B?ZndGT2QvNHBkZXQxd1dtSGJpb3Z2RTVhc2JDeFRQSmh6TlRrb0hMdWN6Zmpq?=
 =?utf-8?B?SFRmUEN3MVhSMXByVllPUG5VUmlxa09rVnJKY3BSRk1DVXNxZmRpTTlQMWFL?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eTgt+IGpLpfZLnVxV3h6v8Ewr8jC4GYbfTS4yPTQV4ibDK8cqlfuSqjg9L9IehHyn1Bv4gRHQhr4daeGVPVtyx8ZZDE55nMY2pQFhM0yN0wjR+OPHf+lDuTApJBqJJn7U18+L0HCpwXSyGNDqhxay7cWZsLW+UzjSjEAmhAnY3fJgOjnhotkBa0JQiQCdNNK4fxZxhthIpR2nucYJHhKQ41w25Z5KhApw00VbDbRSCNYLGN2EMeGQMOd574E8PpAKz2bN86hXUGUgWrJ2Dv4FwjCaAjSepdjGMs1RAvI2ROiH55EYK2DFcl0FW0XNwruqLaZpmu2YIYE9IJrscSwbujw2v2OZaCQLRXFT88OvwLktETjrkcfkavk1koRG8pu/7MojyyzohM6LNaOmqWM03z2GlDxC67/tmQwYKfvjJ3jg3nmEWYne+ssBXxlS9IUoztx5T7H7+Oi5QZsk8AkoplWzGYtbnFW6xxZiZCNFGyYyPLUwVjfx+T2UO62LjDYIVJX5+odsXnnGeePigIzjKLKgfGWODEuiWkOjKAka98fF4TQqJLgyByBXWUnP7ABWu8vMfRGLEcijJgE3WcZB8enUeiaQN+O6NQbXpZ2GFU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b18567-7e26-4fa7-b615-08dd8dfb74ae
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 06:42:09.2989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qy6WwMuTlXC/tSYNUXuqZtgDC5E+xjpR5PyY4hD3H1kW60hnkkE3AZ4kZH1UAPVWIXslC5fG1iOuNjp+viMEtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6851
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-08_02,2025-05-07_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505080056
X-Authority-Analysis: v=2.4 cv=MbFsu4/f c=1 sm=1 tr=0 ts=681c5249 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=Py2qIpJwDBLtrPVInrIA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13186
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDA1NyBTYWx0ZWRfXwKCFWJ9/7Fof THnTBNpI6JEmmhryZj5EyUZe6y8NI9DyAIxTsG1zzl1uQqGfKZYGhhdgRiGTgcF6THbzZb7YLo3 kLEVsUCVKE7Jh/7bss9mTZ+y9A7cogi0IqCc2k42+aWlOe+Mh/gFASxBy1/wf3lgTa294cyEqzv
 +y9dVdsBObflNX+wEbOIoUZsbWxqSkClELtbAy8rKL1Z6RSLxVl92nNylYnlnw0un9RaRWeHPDd GXUPMErrvxjKKaYGyVPnMRCFMFz+5ysOdDcrnm12UorAYb9mGA8jgsShganUAocv5ph1UyIQI8W CvL6+7ErkuDk2PBMu3erBv6hDwb9iq3j4+2pNtRGfAh8qOxN6SMlgMGqA0nbJT94TK9kjdaOuZj
 hSzzsZczJjC7qtlCs7f5D2tU9c581seyCGIfnG1CsRvRnJzXcSJ4MqBT9yn4LNu5RrUFuFKf
X-Proofpoint-ORIG-GUID: X1d7L7xkhWWvVxj6PdFeJjmK0jwlK_UE
X-Proofpoint-GUID: X1d7L7xkhWWvVxj6PdFeJjmK0jwlK_UE

On 07/05/2025 23:00, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Amend the manpage description of how the lack of statx -m options work.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   man/man8/xfs_io.8 |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 64b3e907553f48..b0dcfdb72c3ebc 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -995,7 +995,9 @@ .SH FILE I/O COMMANDS
>   .TP
>   .B \-m all
>   Set all bits in the field mask for the statx call except for STATX__RESERVED.
> -The default is to set STATX_BASIC_STATS and STATX_BTIME.
> +If no
> +.B -m
> +arguments are specified, the default is STATX_BASIC_STATS and STATX_BTIME.
>   .TP
>   .B \-m <mask>
>   Specify a numeric field mask for the statx call.
> 
> 

