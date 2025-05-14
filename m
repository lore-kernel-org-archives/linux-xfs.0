Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D49426FD9F;
	Wed, 14 May 2025 13:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747227641; cv=fail; b=c53FgV3ti22bqi4BHITZib5btIiBsGIHUbvtCrp6c4QVOp5u5zHaY55Cx1m0CIllPRkdjw5DQ8Bl66QWO2+ghw8wxLUNm1DG4vjuPTKca9pCef6orV2m6iquHs1IEtdvax8Tta5rJWQO5biNBok2y65q3UF8D0yI2ffxzXLOgOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747227641; c=relaxed/simple;
	bh=iSoxVIjyBL6H9m37rYFkKHl04qUzn91je06LM6Kx1M0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X29Q9FKFwklFcp54PvXWDrJi7zWJItisW2tvEQaH/cpoy+1mqBQkwbRNFkTzmhNbSidKKh5CsRuoDY8J+CbJs2OG35pacvHj8eGTQPsrdwHObOXUs60yMJYLtTWq9YN9dxhAzIAEssVEx8mHZxvo/KzJrFcg36dU5HeW2Hu/D9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PxFVpC9l; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JDwI0HxY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PxFVpC9l";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JDwI0HxY"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54ECgqtB027871;
	Wed, 14 May 2025 13:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eKkKDc4afCL4UNWmmKzxolX6tRUZ6kER5/jSubysptA=; b=
	PxFVpC9lSNuZIvOfuz1ZKeM50F2I3WfWSdEWkljS+JOhZC1M04t+dN9aPHqx3KZI
	bXTZcYnOFGh97d5htREML93ccb6vUKKuS2nkxUzQiV9p43bAbgWrAlh0GXN1+XHh
	9k1xnjnNq++G2TvJOLLzW38FlY4xi9ysWoRmykc5HdxmxYcC6fdYA38WuJhxfzn8
	L5hfRdF2hGpPAqaWxG4Sf53CwCbxO0VDOLj9hljybXTS1I0fDwOrxsgOI1WBG/lq
	wc/APqbQ5pTxS3HPHopcA8DKx4qs0jposLp4MFMatoyIHJOExRBkDYawxxYIPC2V
	dMbLxIl5uX9rDDUOlon5Og==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcmhhn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:00:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EBnIph016169;
	Wed, 14 May 2025 13:00:30 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011028.outbound.protection.outlook.com [40.93.13.28])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mc33dca3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:00:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zWj5aBcqsk8FuYvxSA42gFmG6sAxHJaWg2sGNWt35UOIiiKihEnMimL2TdbPx3D9WBWkt+2QaNkwUmeIZMFCLX3mz2GrO7G6uPPYzGJW4RbYZ211SLHKIAemCpW9NNUVTwXgMf5yO/Y15thZZ9Yld4/lUzO+p3RBViX0cM+/sxWtftIYAZKwv5/ptAaKJlGu67szys+z0yMcN97sbiyAXg/ZVbGr1sjnNJSJ4YfWabtC5TBCo+AZldMBJHu1xMHKjUXDTy8ABCcHK+xZb1UqWR/KtTAPV6fnnc8LMRTpuIjQtXNWEXVPxZV/d90lJYDG1j45oqvHsdPc5LV3O7ReYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eKkKDc4afCL4UNWmmKzxolX6tRUZ6kER5/jSubysptA=;
 b=dRFYbPn9dFRIw5gELMbXuzYakrLFgJkb59xDBwiuqBqvLpN10w4c4ZMTTufuOhKdcgM4VcaesqhYWckZgdDmpjaUX7AXLnqMjw8BqhZA5kaT4kYHNW/JR7TnpBoOJn4OHJjlfLOFS5p7+9563uWiwzoMeZdFukgOk6DjHVnAsBlbky4aWvD2w3wDKGYQJvHrM4DtOF5V4Nn53iCC/vYGpWtlk1n+Jodg0Q43m2EGtyK8gqa3TAoK15bRGvl+akmKkpmpx08dkTQ6sv8b99vjD/D6NyUvUXlnDNQGao2zmirOO6WMr0YVOziju9VDF11jSJQZbZCn9OtVNz6WrNq00A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKkKDc4afCL4UNWmmKzxolX6tRUZ6kER5/jSubysptA=;
 b=JDwI0HxYkofjSYASULjuPJCfaK9fd4v0kXzXPDKszLamdcAWm9UIobGy0LCYBs/ceaUMaJn+/cj5eFapSQNJqeMo7LL0IUo3YGnnHNNS6VvcIS13LzA/G6hfALLb9O1JylxOPzJ9ToFM4VORI5iZxF3wtujZkiRAUf4uJUZA4zg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM3PPF0AF60B9AF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c08) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 13:00:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 13:00:27 +0000
Message-ID: <edc0fa69-0db0-4d18-a713-0d5e46c5594e@oracle.com>
Date: Wed, 14 May 2025 14:00:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] generic/765: move common atomic write code to a
 library file
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-4-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250514002915.13794-4-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0477.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM3PPF0AF60B9AF:EE_
X-MS-Office365-Filtering-Correlation-Id: 129e7843-00eb-43df-522b-08dd92e74c26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VW10QlhBMXVpSitTSEllK0lhbG92aUR1U3RLYkp0NHhmYkNhYmhyTlprUUFD?=
 =?utf-8?B?L2NPVGpqTHhLNWxyVm12OXgzZnBZYmdNWDZMUnc4OFA0ZTNFbzBYVWFudW5t?=
 =?utf-8?B?SlErQ0R0dFVXdkoxeGozcXJlU2lPeVFoeHdtQXpmQUN0c0ZuRDZPZkYwM3ZE?=
 =?utf-8?B?Z3pTL1FibTl3MVRPRzQzd1RtRkpkR28vaVArR29lNncxOG80NkRWbFhjamc3?=
 =?utf-8?B?NWh1eEtVVVUzOXkyMFNCOWptV0VYd1dtbXV1QzIxL2xzMU96azlEaW00aDhC?=
 =?utf-8?B?QVdVci9wMGRIZml6UmZDekx2c0RMcDJWMmNWSTF5Vmx5cnc3VHpCU0VqYk5s?=
 =?utf-8?B?RmxTWDJLYXZ6a2JqNDVkTGozaW1mU2o5eEkxWG9hdThnRFNSbENDQ01PWjBw?=
 =?utf-8?B?UGE3VVgxQVJLbmdySkx2ZVR3cnp1Z1lLRm5QeU1YYjV4YjdNR3N4M25sZGpE?=
 =?utf-8?B?ckFvcnR5dDFOZElKdE5WNk51cjhsK1lsNGxCZ3M4NDhwZjJRV3QzNkJxUHc1?=
 =?utf-8?B?NFg4cUtwRGV5Nm9KRTZPcDhpS2k0d3V2VzBndWxCZFVqVk5LYUJRV2JoRzVk?=
 =?utf-8?B?VU9uK3dycFlEcE9FUEpvV0dMQStxWmRhaXN3eHVWb2I3VzNnT0Z5N0xuMEZo?=
 =?utf-8?B?ckduM2haeFVSeHRFTUh2ZS9TaGpuSDh1bXAwT244bzhCbjJyVlA1T0R4MUVT?=
 =?utf-8?B?RFovTnBQSTJYQnB6S2RhUGtDZkpUbXVCdFN6NGZtbWVTUnVpUlpiYmVobGpD?=
 =?utf-8?B?bWlGRE5wUll3RU9EU0dzZDlwRFR0RXNCWXBzQ1pVQmVIYlJsMkVaM05IbkpM?=
 =?utf-8?B?cUNaWlVuUjR6aGJsRFNDQVg4VzREL1V2Z0Z4blg3akdhbVJhWnE4RitFdHQ5?=
 =?utf-8?B?NFJLRFdnRFJDWGNYd2ZZSmFYanE3K1BMV3FRT29PdFBCYVdCcFEwbVMwakxk?=
 =?utf-8?B?Z0lEdkZoMllHTFFHVENUVmVoZ2VOTU04WUpnS2NXTGxSVmxZemNwb3RJU0hJ?=
 =?utf-8?B?ZE5xQWtPdDU1VDZZMWtWc0RWOUtaYlFyem5DdlN3bDEwN0JJWTRYRU5oSFBz?=
 =?utf-8?B?djhzWjFPYzRxTDY4MHhhYjVNQ3JDMEZLV0hYREZhNXFmcXp6Qi81eHJKT2h6?=
 =?utf-8?B?MkRGWFd4MThGRjdYdnJDVHc3bnE4WHZkeG4wOHpZRElIbXZwb3Eybnl5bkhy?=
 =?utf-8?B?RzZLOUtTMFgweHJkS29lOW5nbVhnK1J2OGpGb1E0ak1WaWxndFd0MjhXZkdP?=
 =?utf-8?B?SXRHbXBjVWlnckdFMXFXc3haS001MklsZUp3aHhjZE95a0lCYjFHWDVGa2hu?=
 =?utf-8?B?cnQ0WUFjdGNUZUJGTFM1aFRMRUNqa296M2pHYXpFbXBXL3dXLzQ0MDFBNXBB?=
 =?utf-8?B?a2VmaTAwcmdFeitST1IrUXVFZ01JRmRyazE0b01MODNFR0ZhaTNGaVd0Q2li?=
 =?utf-8?B?VXNGSllocTdlRStnS1R1dTFYVldjTWc4OEdGN0NKc1FlckRjZ2VyeTUvNTZz?=
 =?utf-8?B?NXBQUFVwRDl0a08vVnJpZHZuTEpUcVk4R0JUMDdzY013MUgvNlhHcjNnQmtO?=
 =?utf-8?B?N0JITEpWOVcyd0YzdDR6Z0FqcWRob2YrR2VUZ1RwSmt5N3BWNzgwVmRyMkFC?=
 =?utf-8?B?Um5EZC90d0djRnBrY0R1VHJqQmZvU1RlY082cGVudXRwaVZCZi9iZU9rOHRP?=
 =?utf-8?B?Qi9IT1BwWDYwUWNlNDNtakxjZXBrNFlHV29nT0ZDL3pRRS9uYkNoTDRhRTB0?=
 =?utf-8?B?TE5hMjJGTEJ1ZStNRlE4SEM3em42NldYWHljcGRBdGo3cUhTSm9kdm51bFlV?=
 =?utf-8?B?VkZmcjhWdWZGQTVvaldLMVpJYmdzRE9oYmtZak5JNjdiTnd6RWhxYVEyVW81?=
 =?utf-8?B?OW5TUzAwWHNJTHVhUElMOU5XTDBFMU02cVIzSHUyOWtHZnlkMEhac3dXRmNv?=
 =?utf-8?Q?NAksN4PSz+o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHJCZFF3Y09xNkp6bFU3Y0RBdmZVWnhNMXZoRlhxTkVlbFhjU21LMnJDbE1q?=
 =?utf-8?B?U1BsREZoUUlzVzBhdUgvRmhRbmtna1ZLY0RvUzlhaTU0UDFqeEI1eFc3STMr?=
 =?utf-8?B?U3g3SGxkenBwS1ZTWHpiMkluaUJmNU5kZkdxd3VXMGl6RHhqRytMVW5ENUxG?=
 =?utf-8?B?dzVGRmx5UWRoZHZacHZ5TURRS05WKytsM1BNckJmMXVIYTh6ZEhBRkYvUFdK?=
 =?utf-8?B?QmVlaVREdW8vSmlQektUamlNbG9tOGdORDhMTWdYL093Tkl1d1poTE1ET1lo?=
 =?utf-8?B?citMZysrVTlRK25jQS94SjZMU1VoNDlzVG1EcmJTQUhiZDNWSlI2NmJwWmVK?=
 =?utf-8?B?ZmdmVHJSOVpiMmhwYVdRT2tveGZIS2k3N05wdVJMRSt0STlmQ0IxMzBWbVJC?=
 =?utf-8?B?UnBOcE41UlFNaGJISjl5TExudXdXbmx0M3c1V1NaZzAyUi9sYUNZNDdtK29t?=
 =?utf-8?B?amV2SEtXYTdFTTdPcC9OeTRtTEdFT1dVM1NkcGllYStUdHoxZldWVU5weUdL?=
 =?utf-8?B?cVI0eWlZb1VJN2lZTXdicmRIcDh4NjN5SjlCUTYvREE3K0I1SzhhNWFKei9m?=
 =?utf-8?B?K3dEeEhQbEFKYjVCTkdCaDgxTnU2ejA3MU9HNkppdjM4MHNST0JiLzFIWHBF?=
 =?utf-8?B?RzlBdzVTVHBmbEkxbmxCdHJMR2lCTk84bzQwTnZ6aVN0VTZZeWZQMGUwQVgx?=
 =?utf-8?B?M2JlNlkzdG9QNnJKOUtqUGpVQ2JGQjMvMFF0OGF1UldkSTByNEU2ajN6N2Fs?=
 =?utf-8?B?Vm1ybEVDem5Uc1dZRmhGTjN4UFc3S3hxR2haeGd6clcvM3dROEhmamtMMERm?=
 =?utf-8?B?blp6Kyt4M1JQWkZyczE3NWgzeWF5WVNNNUhPaVg4RXc0S2QzbkRTRkdJdXBM?=
 =?utf-8?B?emwvdjczWFlqU1JJTjZhTklTRlhqYWdSZ2ltWjVhaWs4bDN4NXB4TFJ5MG43?=
 =?utf-8?B?bnFETmMyOERFVUFPcjlONVQwT0xiRWQwQzRkN1FFRmEzazZoT0lRd281bmtq?=
 =?utf-8?B?L1Jjb21ZaHNCSFN5NDBXb2R6NUFSUFlyTkttSEVva0Q1V1pOeHUrYzZiZWsv?=
 =?utf-8?B?VVcvOFNsZ0VjVnZOMFdSQUtpRzdjdFRITzRvUWNVNXhSdVhSc0RHUVFzU0FD?=
 =?utf-8?B?UWdFY3FCRTlWZzdUNFkzdTgrdkdOQ3djUUZEWmxJOVgyUFVHeElmT2trRTFD?=
 =?utf-8?B?bDgzZWJhYVkyM0h3VVdualVQc3BmclFVbEJ2QWJkR0VyalIrZUVkQy9zeWJ0?=
 =?utf-8?B?TzlFMENlTjcxdVEycDg3M2RTUEJoN0lVTTF1b2l6dVhBdTFQdW05NFljRmtE?=
 =?utf-8?B?bEtvclF1OW95RG44WE1xQ2JFRytwR0VwZTkwSnA0Q2NxVFQ3QWFNWEE2bEh2?=
 =?utf-8?B?dEpjaGFRMTI4RlhjNCt0NFJHaXNmakFNMmkrd2gyMDVRTHhwVEY4OC9iM3hx?=
 =?utf-8?B?VnJjMUVsUmlSTjZNdCtCWUdUNEZqQUJqY2dVVnZCUHZDd01sbWZtUWhaUDNi?=
 =?utf-8?B?RGN0K1VxWms4Wkt3WVJ1OEhTeW1vVk1kNGlld0pZWWV3c3VsVGlzNjZDNDhX?=
 =?utf-8?B?WEx6Q2pNeFNXRExBUnFHTkRhWEtOWEM3QVhGZ3FsejFrMlhZNy9PSGp2NU9P?=
 =?utf-8?B?MFp0aDBRU0t4MVhZeEVnRUJ3ZmdPQ0c4OCs2Qm80dEpWSHNmM3Z6WWdnRnhS?=
 =?utf-8?B?a3ZzVVE1ZStVazlHdFh6RlVoYUh5ZnozSXJWdnpwZkVra1NscFpDNTh0M3l3?=
 =?utf-8?B?cWVrdit1STh3TDl6aEI5RG13R1QreXY3b1VQejJqd0U2Snl3NjJHUGtDdThU?=
 =?utf-8?B?VjlKU08vVWNtUTYyOGM0dVdYY2p4UWJLQlVPMEVwTENuVVh0WHVvazlxa2hh?=
 =?utf-8?B?SHJ2TkxoTjhvSzhMZ05KL01xb3IvcktONE9zT3VpRm1LWWJHdUc1dnBPeWx1?=
 =?utf-8?B?U0FaSndVaFJqcTM2SDVUSTFaT0dXcno1aGZVdlJPZkxTZDFXcjRoVVZQdTVn?=
 =?utf-8?B?UkZaaXlLNkxweU52cnEzaXRLUWcvTUtTVEJNck5iWTJQekZ4WVZMU3dqczVk?=
 =?utf-8?B?eS93SWNQeDdTbnlKVVgxRVJRUWpMK25VNlFLZ0I1Q2RlNmZHRGVDdm56WHhM?=
 =?utf-8?B?bTJ4a1pjMXBRa2o4c0dZdFg0akl1TVRsNkFOa3BFTWFjdlprVWpTeFhFd3dR?=
 =?utf-8?B?aUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ukKWLi8zTlOn77YarCR6zDdJYAYZ7nbNVo+4A2waiQrlTUL4x3HBDCgld1SY3wKVXjtsMp/ndCxV8IefAdWzgaiLB9xgTNFY8NYzJUxeu1nHeL8JxB9wK7XGZXpH/9URp7obMbUvZl975Hs+kjLrySpkRAkHpjC7kQ49Vk0AFzinirDuEMF4lvmBm2z3HpldcGHFMCtUvuUmKI5boqi5C/LXpw/UDchD6KeAlfq8x3yOO/+kR9RLMFgNgcgn5Qprh2Gj96C6wy2E0lE/T6NhYpaZ8tpMr3xSO4SQUsgdakUNTZ09/1CFuNTwGPERgYlALcU78oMtNux7o+K6+/Z9U46iy8ppisYKmtPr+4vBSlleK+t1cnRNF81eHuelKOJvCuzimJ+OmZkzBZoQe+B5802Kau9zBSJcDJ3667blMTQLxqvCGFnkf1Sipyha+fCwnLN2yhzXi1aZnVsyGaeSWA9cmqq66E8X8hRt6ot0XXrSO3+w5SaNX3QO6sF/QC0HEqciTIykRAmCgAx1NqA3Q8V+IcUg/kOS4LTW+ZklFeLI1Ab+11fn/mSy6Qd3ECvAW5B+pp+Hu1FZtgjGPQ2VUuVX37q4tGcc/yVAG2meV8U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 129e7843-00eb-43df-522b-08dd92e74c26
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 13:00:27.7391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JEOVIcfrVMFtnEeaaw19Ct9UTx6UW7QnUsrt/bai1nkKMZHEV1K+2zFLNadfq+YplDAUgH0hzsNtIx4x+Qq0Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF0AF60B9AF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140114
X-Proofpoint-ORIG-GUID: u7xwovSRSd-8Gcm_gbVjrWt5CsuKqdGA
X-Authority-Analysis: v=2.4 cv=f+RIBPyM c=1 sm=1 tr=0 ts=682493f0 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=GjJoXmgPIC35NYqHgI8A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13186
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDExNCBTYWx0ZWRfX6/fDKGrf8nZ9 cpYjscpzLh1K4PyEoR9ENfrer7+VFgRZYDqrBZqPJCQ+EdkxpKGQO2r4x1aAMDcnKc5l+hAJz98 BqyXcB5i4enu91/AWgyv9cPgUM2bBFZy4ifsK8YnnGqK0MmvsH5Pv43U5yzc6pGbprmfLpiB1Df
 k/JT66q/yfDiidZvMpJXdTG22HjObWEDdzRA5RGe5cdh3JzYVb32gElNbwf+ddNHFj7uxIGm0sp azswtumMzVlaj3+jDqfV2gDJtJis8GJEwa+8oC/nChDF9GTnalNOaMpeFwo2gsbyL8iRNny8Zwq AHdOYiaLq/2NIdrvRq3U23GdqyG6Z+aefeaUKA5a1PevKNnRD2VT+7tAcKf7maakc9WaoMx9UOd
 +a/vRkB1L9FmK1y7Je8Y5s3RBePJ12egXxyvcd/nJFYRYk4h7KupUy2VbBS2AsGEN2nVUvQp
X-Proofpoint-GUID: u7xwovSRSd-8Gcm_gbVjrWt5CsuKqdGA

On 14/05/2025 01:29, Catherine Hoang wrote:
> From: "Darrick J. Wong"<djwong@kernel.org>
> 
> Move the common atomic writes code to common/atomic so we can share
> them.
> 
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>
> Signed-off-by: Catherine Hoang<catherine.hoang@oracle.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
