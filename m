Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E7247DD4F
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786720707; cv=fail; b=IjINJwO255KfBERG1+ZI9fjWEm8OIRVKxzqftyxAxmFdju+0ohQoxzUVaKpGLprh7qkMruFwUsX4hspb1VZ5gVwoWCourAd9WKzPlNBBTTD0XaTlJRmiMaXKSNjTF72BSqmMHsPiQ7A3zxJW5sRd5UwbfRpsfqpS0fdpNtQtpJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786720707; c=relaxed/simple;
	bh=UGIIxRF27L01edf1+iOLug/5rDUhGm8D7Dhw3KwSrqE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YrqMVA+5hDK1V/PkZBenZil6ggH6kEnhcDCXanSeg8M8HR7kJqOPhl9UFnbK6veqzpxFSx6m123U875a3OuvfCl1ZtTux3w75sY0dPEc4ujrA5Rt5+orzWLYbA5Nf53aRwezk+2QNF3BtpFOnOa4SDHLKLPS11KJuKq3LIUkCog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ye8sfsSf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ddIELhCw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ye8sfsSf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ddIELhCw"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EDOxvG1745786;
	Fri, 14 Aug 2026 15:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IWG56FbibdrHoIm2FeYLrm+8Rk+DP2F34R1KITz8o/Q=; b=
	Ye8sfsSfgZUbEZTt696QX57CGMj80nFZoQLkLsggNRWg0mm1weQLTZ6OHTlU/hfe
	EDxsaojsTvGYqrhh/9ImoN0Z8bR1IiVWGgJNxtksqlWwvc5J8/piwu4DRevRWxR3
	YB8d8B/KzN4Xk7+mRP+s4qihMV/jVHxonmcTWP4YODBjyglv12QHkJzYv67CLzkD
	l6vXToeqrzeDDevjz5qlG3aIspw4jwWunXbTWNB+hiQ5/fEprrLfJVK6L0M72In3
	4DNg8n+d+s0VhO13Nsk65DB+eOHIuIcY4dJ4BmGYUpJLe911ghWOra18k4fb4/KY
	QNkU1ERdlHtrIpqaHst4oQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvfy4gyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 15:18:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67EF9xiY034823;
	Fri, 14 Aug 2026 15:18:21 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013059.outbound.protection.outlook.com [40.93.196.59])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwh6xyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 15:18:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gpUIdc+YLHd3bkNq7ycOY4S7nSFa4uYA9YmrD/y0ej+6DDtaQW3QANfZsww+fiSW+EfLU45vZseU7iA0Fl7Mxt5hg5RRmq1d8HJIf6QfF9qL3meUIRFooK035T1Ik6bUuFo39HWvferdwW/FkWIuBZ7YyIQRYn9oginlqRAi2N8UokMvNMhks5Jn0WS+Um3YOPJ8Kzg9NZfW6E0YskpcEpusNj35TS92Z1eFyQBvx50OtznW9fsFefHClMgRQVjIaNw8A1xPcvWSSemNlIgFI4N5iLUqwzgUCk2I6ES8pPWuE0X6hQIKh2OjrAGWbbZ13Ny+pXtLSE8nlTqQAAEIfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWG56FbibdrHoIm2FeYLrm+8Rk+DP2F34R1KITz8o/Q=;
 b=BrOaSp8d1+ZffexAFsnS5ZTB0v6svsgt4q0vib/1TcVB9kUO9IZKVIfQchhwWUA71v8IrvoqkLY9popr8fyg3XoMpGFn0QSEJBkWs+Su9pzWpsgjQ9wxW5j9fVHId9lwQ1jDFlTtZZYup9xdsICojotAcsAdJljml4w2qlLrJjF+Ge4NiIQohlni4jRDs94T9Vf1ERB/ETqpJBSjmhkaprnLdxX0a2JUyhThAECmw2P+0kxdndvUQCI1nx2vByIKZ/FyPiuEm/Z3GaZ3/pT3oZAmA988eJkUolBu5P0n/HS1YuoXnzT9m4kyJ9uB/YULK8wmsIcZA1V3xIpCVAWz1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWG56FbibdrHoIm2FeYLrm+8Rk+DP2F34R1KITz8o/Q=;
 b=ddIELhCwyaf0SqzfOd8Nl7zr+NROXR8duwObsdJCsmQOi/apGgNPdDzSGyRTvdEQy6ZPP/B9qKNINy1G7u74kOzvf1mJXC4O2VNPGfBfYq+1rNAsDafCNo4qVVnsPpb4lwvlYMEnkv8BR6WdKZiSaxq7c6UcLL6z4IHTXWv2bPM=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by IA4PR10MB8566.namprd10.prod.outlook.com (2603:10b6:208:568::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Fri, 14 Aug
 2026 15:18:18 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 15:18:17 +0000
Message-ID: <c493b668-9b13-4802-ad05-f54cc62db168@oracle.com>
Date: Fri, 14 Aug 2026 10:18:15 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [PATCH v2 3/3] xfs: incorporate increased AGFL
 min requirement for minleft allocs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
References: <20260814132239.271492-1-bfoster@redhat.com>
 <20260814132239.271492-4-bfoster@redhat.com> <an8e1YgRDysYtlgM@bfoster>
 <8e58b1e1-c15a-41df-898a-3725d920b486@oracle.com> <an8qkZXtwQwYDycO@bfoster>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <an8qkZXtwQwYDycO@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR07CA0027.namprd07.prod.outlook.com
 (2603:10b6:610:32::32) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|IA4PR10MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b679e0e-5ab2-4809-f95b-08defa17449a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|10067099003|56012099006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dE8PXfTf3ICbeWQ55j66mPCtSCUmqRKBSfJi87KI3J9sIxy7KRxaNS0hQtcyVm8qUTtjtq6fDmEaRknykKa0IiXPLPLGymDG5+opDJ/i62ZAzP910b5GjDZrAEc50y7xOVwlSOJ+pTX9jJsnxi1c74Rp01dJaN9vWseZhjNkyp6PMMPT5nOmkGO55wJo1jD4uoszAuoW2Jw9cqtmQRK4p+Z7aICkXbYM5P88Gs4ttexrbQojxlYWQ8mu6Zx0sE2xiKwuQAFlpCp41Up7mN/woslMMFfIdluvpKLeD/S/DnsbWVsn2q7Bwv78OG5uN4Daa5hwEzDfE5ErhCrsooFtfE6OTonucENZa51SYo74jVZ2JIG2ZqfVGyxjm1faHOXSIvAy2kMq3/rqK4eFhK1imTf9sZeh3padQcn/niIO5BVo01BIitav2Nw0i47VVqR0L0+HDM/PXNz5G8BjYCyBP/tMNa8KqAOebOdkqEUlcv973XA+9fGi47YEimQP57g7UnGyH+j1h0edZdiwoj9wYiXwiIYVrlw3hkFDJ8v8+K0jtg6itnXqoW6E7/XnqGBEvS6LrJt7r79N14EDjZScCHLcXdioPJ2elNcwNBWXGublMmPCSjc/P9nGviars+5BaNTIQYP0kaUpRySruYtiwSnbsBrLUqhi5XtiKCVwg8c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(10067099003)(56012099006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTZoeXFrZ09WdDcwaEZ6RitUYzVpWVNzamhiY1JEbnE5RUNpSkt6dlRXREhS?=
 =?utf-8?B?VG56OW5kd2NGZDNLTDdCdk1nalBnOGxGeWIyVFdXSjAxZWJDRWFpSU0vOEJp?=
 =?utf-8?B?TVB5bTV6RDRqL1Myc053d3JpYkExU085L0VCYmkyQlQ5K0t3WjJBNHdXTFNn?=
 =?utf-8?B?bStJK3luU25WeDNKVEhINmN1eVZOM05sWHJjcWZlQmptUysxOVRvTDNhck9Y?=
 =?utf-8?B?YzNXdXArdG1zdm9kb3VkUzFxTjJhQ2N1L01RNWxXcit2b0s5cmNQd1BCbDFH?=
 =?utf-8?B?VHVBZU1DcGFlVlYyUzJwZkFQbzZqblhjR3VlS3I0S05RYUUxUFhQYThvM1M3?=
 =?utf-8?B?anVjaUV5Y0NlMEpzMUVCYjBqT2VNMHdVYUc5enBUMmNHbmF4V05uRzltRGJq?=
 =?utf-8?B?MEZqamttUHN2Nytjdzh0Tm9GZ2NFdzFTSzIrb1NuZnhJZXVNRVVkajYwMS9J?=
 =?utf-8?B?cjljbUYyWk0yR1dad2sxeSsvRlE2UXNCQ1l3NU5NM05LMXBNTzMzcmtxaE9p?=
 =?utf-8?B?SHRFREt3TW1mb0Fua2U4eTJHWGJwVTVRKzhYTEFsREUvVGxHZm1FQjZtY0Fy?=
 =?utf-8?B?cUZNWEVpWWg0RVEyZ0V2dWVPVEZkREVwa0o4S252WHFOc05lTFcxZFBlVmRF?=
 =?utf-8?B?d093SXBzNUEyMTB6Q242MDkxaVczdElLU1B1SlVFM2tsK2FWWTF4YTNxd0R5?=
 =?utf-8?B?YUlhL0VyKzBIeVBlVGlRRXh4K050Z3F3N3JnM3pZRm8vVHp4KzhFb3RVdExp?=
 =?utf-8?B?RUkyTTBWY1dlN0RlZ01NNVZGaThBdUh5QnFHYUpmZWExSzY2QmJnakQvZGhJ?=
 =?utf-8?B?cGhIakVrUXRMV05EcS8rc2J5Q1krY1E3WWowcEFiK1VIZGtoNTVOMUhyTmxW?=
 =?utf-8?B?MmFTTmlIR2F3cVNsUFBGUldFSDlqcVdNQW94RjJENHhCcDQyMUczRmdMUEJN?=
 =?utf-8?B?U0pIS1VpenZnSGZwajNFZC82Njc4OGdTQ2w1cGlyQ2o0VFVEUmQvWVdNeUh6?=
 =?utf-8?B?UXd5d05CYitGNzdRSG5Ccmhaa3FJRzQ0RkNjN2h1NHF4YktBRWFkWlBWYkhn?=
 =?utf-8?B?czE1dzFhYjQvM2FUSWFOdXpxdExXVzAwbENmUnR6ODZPTVp0QkZ3RXlVbXJF?=
 =?utf-8?B?UFpHQ3hUb0JNMlJiUXl3Y2ZKZEF1eGFZb3p1QXJybEx1djlLSU9qeUpiNGNl?=
 =?utf-8?B?RHZmZkJxclpQYkp2bnQzV0ZZY1RuajZWVlZFMCtGK1pDY3NhNlNic0ZCWVhs?=
 =?utf-8?B?dzRoaWNxS0NWblJ6UHNpNllCaWtLcFhET2Zta2dNdGRDcDQ0RHhLcXk5ZWtt?=
 =?utf-8?B?Mjg1TStZdE1ueEtFRDdmYU4vNElmNWZCYjZudFl0YTZvaXpTNnNWRXAxb1Zm?=
 =?utf-8?B?UDFQSFRDVmNBOElVd3VvWDg5eWg5UHE3S2I0Z0RPWHVOZ2VDa0hhbFByMWpp?=
 =?utf-8?B?dm9vTG1SRzZpVjJxVjlLUmpKYlgrUUVjYnhwV3JkK1djYVZwVW5VVkREaHYy?=
 =?utf-8?B?SlpmYkNaK21zK3FFOUE4UmxzcUpkcDBuYytnTFkxWDJsa2JFR3RTZnpia2hv?=
 =?utf-8?B?b090cWh2ZXZpQTVFMm5QaWxVaUcveGk1cG85NEN2dFNIWGdZd0Y5MC9heFhw?=
 =?utf-8?B?T0dXamh3bENKaTZPMU9VTkR3Wms1OXYzZW9MNFBoRFZ0cnVldlRUVG1mOWx0?=
 =?utf-8?B?bFErcjFGeGxnVXJXYmxrZkdWdlBFVndPSks5S0l6K1BaQUZ6UDBFRG1HaG1Y?=
 =?utf-8?B?RmZXQ0NPc01HZlJCL25QM0pKT0IvK2lXNUg1RGYxMkwvVnJGWmJ3cy9XaVZG?=
 =?utf-8?B?N0pBVTNyZDNiWHBCQW10V3h1ZFJMVGNPdnFreUIzd3hYcWVQNnhEUEdncTkr?=
 =?utf-8?B?TXBDaEZwYjk5WUJ3ampoZE5YeG5zcTB2WVcvVGd2Y3B3TnE0WExpbTdmdTh0?=
 =?utf-8?B?UWJLZkY0T1NjQlVtVElaVXVBZGorTTJra0RlZEY5RHNYbUVQU1hRUUIxaFFM?=
 =?utf-8?B?d0EzNjhiWmxLMWZGbTQrVVRPOG5PbzZ3bktWSWlJTkdnelAyVndrWlQxZVJI?=
 =?utf-8?B?ZTVQQ01pdDhhTngwMjg5RkRwMGtnUDhtN0tCbWx4Z2t5WE04Vys3T2FqVzZY?=
 =?utf-8?B?ZVZHUFEvWmNDYkFXOVUvZ2w1dEdRYWZNSXdFcFFldmExRUJSY1MyeUYvK1hm?=
 =?utf-8?B?N1F2UCtCb0xRSUZvOThBRTRIaFlvUEIyREEwQ1RiMHR2V1NvN0JiZzhqYmxq?=
 =?utf-8?B?MldOT1ZXaUIrOWFSWG5zUEJrZTB4b1NFSkw1UHpuWDhNTWJ2M05TOWwxWm1C?=
 =?utf-8?B?azNlc1Fsc3VBSVNzYUd0VjBlS3NlTEdSaktKQ3RSend4NWdrcnN6d2RCY0JZ?=
 =?utf-8?Q?d17vamSitJ98+Iz0=3D?=
X-Exchange-RoutingPolicyChecked:
	AybYA4moDozlg9f6/jFuS2PUSwCBO9nCGyxgr7T3mmkE7IGHsTwlzxt0UpKnk5Ck0r+seuM2Ubo0pkmwjWkWThgbLvCsYRDcxg2fOimlTV8GporB8tmQyGORds0VTkXJ0X41/gC+pfp4lqRiWhQrIJvGz9pM3XlesS6n2Wm8SVPVjeNng1Zv2VEqOVR0D837K6DSmvs9PhewyBJXO/+zkn9cdJOcAUGZ8enpLym+WpChKDeraEOZ29wYqyKTbbz9qw6nP1v82UUt2plxcm+eiZ2rKQPcdN56ksBVjnTVqXmsn7dv4HRR0J5iFWfzFZM0HH3kFbIVm6cdeUTt4MwWLg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9Jga6ARdfg6HF3SqODcAyIXsOXbyE78XRhq68iqEt8z4Rd6ikYNlCKuWeUqbzc/EPKu4rTBY1goSwXZtLwlTjYfp8CJhM/YRXOl+RUD1vboAMxEpEcajK7trHjW1hkcKmGo4+ASSMfc1HYjyIrPnJESqmvrIG1fKH9NHfKsGJ8h6ZH/NjXPOJG1pEqO8jJPCMFIGZ5JGsN0brHVrONbfBp3Cm1Vgk/R174NVc9vS1klx1sMip9wh/IfO4YLp9d7L5gC+mgHZvt369rP2AiigETi8KrdAqIq4zDWE4bsJws6TWCHxA26a1wd3BYY8u4TA1i293lmhFlNhvZSEG5vrAfWZ0uHhe0rOOaoJ1y8sougfIfogZcua5rD1WypHgoeEzkFVgfZ2tEfaUpNmODuaWFwuQJxQwpqFAPU3CFCV3VjnZDBWFwxYeKmSF7Ai/xd6ZEuzx5Jc+gmuySiynSWOiPv6IOM5vPNdGwxldgKNkTMnhEAItGaJ/ndAvsdIT6Zot5NMKfxsULumKNhP/14HdxTdGqM2bx8CsI3TXzNwArJDtdrgYduuGIBFKeZGm+MXsEerY+fX50ihLOnX0v1QPPGYJrK2PbiqJCiwjnnor6E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b679e0e-5ab2-4809-f95b-08defa17449a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 15:18:17.6765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l6PtmsL1scoJcuSRid9DJFXjrm+K7iYLDQT3FAAI7Os4BjeDL4343r+OuUSN2BTunHDl7zpTTZwx+k1B9tK24wln4Kk5Rc1kgjKFrXC668s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8566
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608140116
X-Proofpoint-GUID: pkTSYntmrc6nDZGXHw3aUUIO_34omcLr
X-Authority-Analysis: v=2.4 cv=K/sS2SWI c=1 sm=1 tr=0 ts=6a7f31be b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=rO3Z0jxKlqOR0NPqmxUA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: pkTSYntmrc6nDZGXHw3aUUIO_34omcLr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDExNyBTYWx0ZWRfX6V0u9/e/eeo+
 AveVnjWFNLYol6hYzL1qADKx7CZjwj3ZThCIZJr7I8IseYhmZQVpfHpLCbkZXjSO7JeBVPGyeX6
 PLQ3pSY3CkzyIw9+gF8Uru+aUyxv2A6Bzw5S4CVe3e1RJpr5JJFRj7p0yxGG58/r+lEJzvtbKyk
 uU3VQw83312ZWMn4no275BRgvPqo103Z8K623hKxoRtldmbnVvg+tl7KKgb0XGGgeMxWasLKsTW
 HCRZ+2OFNlQSQ9YNRiJXFLrLFfLz7og3wCpb29ojA3o1sp+cvj4Enj2PgR8vr00vaoimzqETG4F
 aiiCAaU6utMETueThV+EuDLz/DUubjTtdv600CUFUnZeLg+tof7wU862IYgW0yulf1KSS8bxZdS
 6v6CBfzBKSYccArQo6S3dBm4D0S6+Tyn0i669lIikcF/rS0atD6er1iwOr2OKF3qj7PL3iu06j8
 6UhaEN/M/gr5CCxg9Xw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDExNyBTYWx0ZWRfX525JwayIkBb5
 D2TdbwD2vuA1Y9Jsg6uGPVQpqzriwtPu84PpZHyLcxMb/6gpCV4whFjz/nWVrUjXdtwYz0yXc6B
 pqtPJcpX5jKnKouIPqA6s/1qfGA8Qt/EXOlrbWKp0JqDP0HbNclY

On 8/14/26 9:47 AM, Brian Foster wrote:
> On Fri, Aug 14, 2026 at 09: 15: 15AM -0500, Mark Tinguely wrote: > On 8/14/26 8: 57 AM, Brian Foster wrote: > > On Fri, Aug 14, 2026 at 09: 22: 39AM -0400, Brian Foster wrote: > > > Matt Fleming reports a filesystem shutdown due
>
> 
> On Fri, Aug 14, 2026 at 09:15:15AM -0500, Mark Tinguely wrote:
>> On 8/14/26 8:57 AM, Brian Foster wrote:
>> > On Fri, Aug 14, 2026 at 09:22:39AM -0400, Brian Foster wrote:
>> > > Matt Fleming reports a filesystem shutdown due to inobt block
>> > > allocation failure during sparse chunk allocation. Inode creation


(deleted text)

>> 
>> 
>> thank you for the comment clarification.
>> I was confused by that change.
>> 
>> Could you CC stable. We saw a version of this problem in Linux 5.15
>> 
> 
> Sure, though I'm not sure how far back this will apply cleanly.
> 
> Curious.. was the instance you saw also an inobt alloc failure leading
> to dirty trans cancel and shutdown, or something different but similar?
> 
> Brian
> 

yes the v5.15 problem was a similar sparse inode chunk / inode btree insert failure.
I admit that I did not have the numbers to realize why the inode btree insert failed.

although this is a fundamental allocation flaw, the sparse inode chunk allocation
seems to be the just right/wrong conditions to trigger it.

Fixes: 5419040fc0f3a xfs: introduce inode record hole mask for sparse inode chunks ??

thanks for the fix

Mark Tinguely



