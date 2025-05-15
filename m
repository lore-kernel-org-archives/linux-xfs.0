Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1252EAE5;
	Thu, 15 May 2025 08:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747297001; cv=fail; b=XCODWH4wwrrOm9XGTmsnCQ0Vk05fv6TCi4yXZazXynjERWwwbhfyuw2TjsKCoW+IAqurDII3sY/aetXRlHDW/rGVehPhbDmY7bXhh42LvmqcD86umFZIU94pvy4b3y++A1QpgrsrM0cn/QZ+AKChhCamtvGjWVrSDIOQdYroAlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747297001; c=relaxed/simple;
	bh=QLdWdJmX6pPnj01hXTjNlCu4mWEPKtTKUhGz/y5B9cA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=feI9FVz/6BONRO3WbF9lRwdxjSUALMP6A3p5Tst4KnNkllHwfmr0MTbsuAt7LC630woKmvrmD8Etj3zgKTDQgNwXvFr4gNFlB4F7IF7fWZovyciE5bxkMvxzwOZ/YOqZu9wdu4Epb50TLn3E+vqukBtgv49I8M4k6wvI67cuKyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aTd8HUYf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NxrRsVXR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aTd8HUYf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NxrRsVXR"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54F7BllM000850;
	Thu, 15 May 2025 08:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DkndmeVYpX4Pe8A3W+1dtmjj0dCbt/GFxsccnh4vh7I=; b=
	aTd8HUYffhknMbinyTPqlGDljmnYIazPYVVN9ar/3+3Hl4GpWqcF28wkCjpYkA+5
	2rmPNvn+aU3nelNSifgNsvFkbJRO76HvOX8RoKzQcW++P94UfgOvW+p8ep0h8At/
	AySglQBur9LrwamxL10p+SPmZk3Qe2LLZTmm9sOBwvgZq5CtPq27mvU97IwGRIiO
	sbtIibl9zNsS5HiMgl+DmssYnqvqkTe4GbFQdT3YyWZMsKGsHCO71dD/AmVBqj2/
	Vw35i8MO6GhXWwcPQ76AAtFlxp3ds06yaNpG1G7p2oHIa22UaXk60CTnhTp/YkN9
	swLdpW8jp5SV9Ag09brWjA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbchudc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 08:16:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54F6AN2I004334;
	Thu, 15 May 2025 08:16:21 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012013.outbound.protection.outlook.com [40.93.14.13])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mrmdspd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 08:16:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GljL7EJ6wNzgKtrwXzQqVZu4QVUXpH5tTqCtncuDmnfeAEO/v9UGpvjTbHo1uwvhshI64zxxbK+3fYjHH2jKeiVF+hbnY6PvLVXB2oqAzuld6h1gWO9Yh53XShpPlSPDPRNrY9oH/EDoF5B7YXNQIoHBW4vqe8DoAEsxhoZLP/+a9VVNNaArkobYItLAAMIeguy/3kjLfcmuakvS2RXH2RTT2809IdzonqDTZDk54gPQWDmsTsD4n9o6o7x1qY98tB3dOJs8hRBj/s344MVIwvt0K2gzeZaTJ8LM02VViFALmidHG+aJr6RJd20Y3stk9fE+Zcml53bD8FI6bR0nHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DkndmeVYpX4Pe8A3W+1dtmjj0dCbt/GFxsccnh4vh7I=;
 b=I21PwHhInp9fER9ZVVKnVBPaCqN0CAgj5Sgb9psJ6I+QLSwgpFUl/UFb4EG+tPKWtQSh4lrq30IX2iFip8G4XML/biFPyZpYAqCzbspxsRpnmh1MPHGReIK8j7TdY4M557N9ZmCTmDDytdfOm4uKZXrCcTRp7Xd7lRSmkIdYahqzfw0rBFHgFDnFRvWTA7cAlmlcxPZZn+U5o+bRp2xxgfL3Pyh7WeyL/IBERY955StnbOV8PhfraTXTAOFbuKu5eYdNUIOqNq2JqUVaCsaLalCSCbaL+rNwc+PJBdsYvWGk+q15a37032FJAXGtDulVXWnFY3jbcXMLA6R24VPxNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkndmeVYpX4Pe8A3W+1dtmjj0dCbt/GFxsccnh4vh7I=;
 b=NxrRsVXRGMHxadtPQpWp9Gi+L+1Z3Ujg8UAkMzaF/arHATy5BUgy4r7suMxd6SLPhqqgsA4FIh4EG2EVUBhibEBO7U6xwmn7aG1LCVDY65awzYTAbi0qk6Bbeqrh0n0E57UMsmjJU4G8IEDOsMbkDwTl72hUNGgdRgHwjss6SAI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7315.namprd10.prod.outlook.com (2603:10b6:930:7e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 15 May
 2025 08:16:19 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Thu, 15 May 2025
 08:16:19 +0000
Message-ID: <4ad2be95-5af8-4041-99d5-1c9dcaa9df7c@oracle.com>
Date: Thu, 15 May 2025 09:16:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] generic/765: fix a few issues
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-2-catherine.hoang@oracle.com>
 <52fc32f8-c518-434f-ae29-2e72238e7296@oracle.com>
 <20250514153811.GU25667@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250514153811.GU25667@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0012.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::24)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7315:EE_
X-MS-Office365-Filtering-Correlation-Id: f05df966-0b49-4df2-265f-08dd9388c51d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3dZNjlZdVJjb0oyMDdLeXc1N1FtejNHTjhXYVBySldGbHNaRVFiWWcxTEM5?=
 =?utf-8?B?c3UwS3E2TzJQcllmRlRNRTFDODgxM3ErRHN0aFRuTkdqaVNHL1N1L1MzdTNa?=
 =?utf-8?B?WTgzSTFMWnZYUEhIVkM1WmZHaHVxNmVLQWJPZVJMSmdUMGUrU2o4anppS2Fi?=
 =?utf-8?B?U3dQUnRYZGw2bmlMVllNUEl6RWJXamV0RDhVUG5vaXA5UjZoUW5yU3c5S01D?=
 =?utf-8?B?dlBWUy92Vk9jd1lNV1MrUVh4TzBOODhYYTNrOEdMa1dXUm9tUFhiTW9za09h?=
 =?utf-8?B?b1JXaTY5V2dIT0VYanJPM0VkaUZEdTAvUjhJeVBUTDNxWVZRVnJGdUVHRGJt?=
 =?utf-8?B?aEF6ZkcxdlVLb21RY0NBTmFWSkhZdXBRd2NGVFlpN0lRS092NlkxdVBZTEpS?=
 =?utf-8?B?M1dkbU1kb0VJeWJmdmpER0Y5QW0yZnc2c0FzZm9jc3pZYVZENHJkSExua2dT?=
 =?utf-8?B?ZVBMd3VLb3BGMTVpTTR4endUTCtRcGZCQUkwVDdaNlA5SUdINmdWeDhkS3Zr?=
 =?utf-8?B?WlQzYTdKQU9DaWlLOGFiOVYvZlAycms2ZkNER0YvTmpVWmkvWHRkSFZHYjVv?=
 =?utf-8?B?ZVh0QkRFT0ZmU2doSVg4R0dvL3ZYclVpWm9zaUI1R3p5RXZ4VUZ5VzMrdDl3?=
 =?utf-8?B?N3o2cEkwaXcyS0VwNmxQSnFFZ3gxV3lhdGhaaGRtR2E1VXNMcDAwZUI2MFJl?=
 =?utf-8?B?QlN4RDcrUzNleDkvdWVPOUNpM1pOZDV6WkhUMnFoLzZVa1UvOURSTzZYSkow?=
 =?utf-8?B?RUdpc0srM1pTSkhzMWc5WWl5aW40SzBCc2E5em9ZalhVaWIrVjJGa05mS0pT?=
 =?utf-8?B?OHY4czJnV0pBc3p4enRuLy9XeTVkQ1ZzTFl6TDN5eUFSbXBzUUp5MTYzNVpB?=
 =?utf-8?B?SXBJcTNRRUNHZ0lxZitIWGV3dXB2OUdCeXNDc1dnbVV4dDB2Zzd3MlRPN25Y?=
 =?utf-8?B?MHowa282Y2g2VDBZOHJaNmUvd3A0dkdtRXVsaVVDNFdVN2t1YmhBbVVwUkJX?=
 =?utf-8?B?bFpPNFRaa1FsMkJWcVRxUnBqc1ZGZ3FlckgrNkkxc3NsQzREaWRtZ1BUUzJu?=
 =?utf-8?B?RGVOdUtrV0tUdFJ2M1NNMUJqQmQzQ2VIeG9tNXRFaTRjTklnNUVSUmFMNms5?=
 =?utf-8?B?bW56RzRhRHRZbWZzcC8zdi9Ya3JCcG1lRFovVlN1YXlJbVJRZU54MnhZNWNr?=
 =?utf-8?B?NGhPVnlRbnhsZ3FHMFZTS0FiVHU4U3pwVXRQWEcwOGFnSzNiNHloS1k0Y3RX?=
 =?utf-8?B?T3hydTg5QUYyOGYyMjBmOC81dkREcEJ0Kzl4ckx6ck5NUm53emZVNUQzSzZL?=
 =?utf-8?B?TU9UTzlGZHBjblpVTy9PSU95YUQ0MVVISDdFdVlHUzB0dFc5YjBoNUxEWVIr?=
 =?utf-8?B?aFZwcnMwR2RIa1ltcitnajNVNTFLdmtYVmZxYVpMcndSWXMzODVVOGZlTlRE?=
 =?utf-8?B?TDhKSG5nN0pIN0I0akhJeUw1MmpRWmZpWW84ZTQ0cVE2SEJXbVlXNkV1bnpZ?=
 =?utf-8?B?Wm9uVHBycGhDWTJuTEpsQjdGZkpTM2dISThnMTBuSE82K2ppc2c2SUJtZDV0?=
 =?utf-8?B?S3lDcGNhYUFNekg2bm84UnpYR0x4dWhzR2FoWVIyUzdzamNYVUFqZk5ub3E0?=
 =?utf-8?B?TUFFRWE5OUI2UVdUbGRSVUViRzJEM1Awdk8yNTJNNWs4aGpZY3dOMnpZS1JN?=
 =?utf-8?B?a2Q3U3RKTkhFbDJYSDJ0cDRIMzBqQWdEWnV5TlYwemYrajVwc1FxdTdHQ2RB?=
 =?utf-8?B?NnpVMS9VbHp5QWVwS0FMM2pTVjFONFR1TE9NUERHS2g5SHpFSFBLN3YrdklI?=
 =?utf-8?B?SHpUblBWNnFUeU1QWEN1MlB5SjNPTjkrdHRpanFXUWRHT0xJWWQ0ZGFXbFFD?=
 =?utf-8?B?MzRGa1E5aitMMTAxdFFnR1NYRXdra2xCRkxBeGxXRUh3cmVIMU4zT2JZcFRm?=
 =?utf-8?Q?PQdfuxqcJtA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTVqb1VjdzVSZEQ5QlRPMlVQTm1MdVVaWGRFVGhqR3NpKzhzSFV1aWNRYTJV?=
 =?utf-8?B?QmJXN1hFdzczY3hoOHUvbjBjSUpFNUp5UUFKUWplR2xHbjBtVXRDdDJHVi9z?=
 =?utf-8?B?a1c3RVJoTlMrSUhONGRLa3UxQ2x0ZkZMK0xvcWpjbWVOSlpSM2l2ank0aVFS?=
 =?utf-8?B?UmtOVnJiMElXN0JKbFJMWXJkWHZlS0ZrcEhreFF4ZzRqVFdBRjA0eUw3RUM1?=
 =?utf-8?B?bk5kS29YbnNKMUNmaU4wZ2p1dVp4SHhJcy9DYnp2VW1wbHMrYlg4bmhRZkpv?=
 =?utf-8?B?VGdDNXN3SHZKeXB3Mk1aMXoySGRKV2RqbWJ1Q0E4MzFOSFJYOFlGWUpyTDNV?=
 =?utf-8?B?Q0hsWjVpcUh0Vk1XZ2lxc0V6Z3dkdDRxZ2FyblB5NlFZR2JCcE8wYStGSUdK?=
 =?utf-8?B?U3M4aEhQU2NTWWVvNWVabXZ0U0YwWWJic2dXN1AwQ3Fnb3M5Y1lCbjBtRlFk?=
 =?utf-8?B?bllZRUZ5QVAxU1NMeXE4UEc0aXN4NEpxZENMNEI1QW5QQnJ1VStDMG9SdTky?=
 =?utf-8?B?bThWU3lFcGY5eW1GRzl3aXNlOUxGdmtaNUZ2a1pLWTl6Mk5LWitPZmlpUzhq?=
 =?utf-8?B?aEUrQkRxL3gzOFhhL0JROE1mYU1mTmVMZ1crbjNFN21iQ1lwNHFtbXB6YUww?=
 =?utf-8?B?UFdjd212d2dqVHhmbEp2WVJqb2EvaUJ5VXpvQ3JvOUo1ZUwxQ2xZb1JCcUhk?=
 =?utf-8?B?aHNTdnJuMnA1aXgrR1BCODg5T1dFdEFyQktkUkxwMmdoak5kWTU0WGVSZXM3?=
 =?utf-8?B?N2dyTXcrVEkwc090cUV3ZUhvbEdhSlpPZ3JacnY4eko1Wmd1R2hpN3g3R1ha?=
 =?utf-8?B?UkJuY1dPRXNMLzBha0NaYmF0cU9TeW41LzNUaFhSbkFqUVMyVEVjWE1NaHZy?=
 =?utf-8?B?RGQ3Qzc0aUpkNnMwT3kzaTZpNlZRK0pMNFdXZGFzdXBGT2VEMUdmQTIrZ1Zk?=
 =?utf-8?B?MWJpaUNZTitvcS9nSUxhZExlUzZ4eGhKWTFzY1UrMmVWbW1YRnFtN3djeEcz?=
 =?utf-8?B?ZmpnckhLTmEvWHR0ODNmSUFHRzdkUnpLZFJlTGZKYVU1S0hYdmZERWJHaThn?=
 =?utf-8?B?VW9RQWI5dXRrTVBiZzBRalBycUR0M0VYRjUxdVF2TWk5aHl6V0Fsa0ZvSWZa?=
 =?utf-8?B?aHR2WGRNOUpxemhtZTJrY2ZDWS9VaHZGMTB5VSszc3l1VHBzblZQVjl2NW1n?=
 =?utf-8?B?UVJ3MERmb3B6eTdyQlBkVTMwdlFnTVRZcmhoQVJua0JMYlVxMFRjK0VFUURx?=
 =?utf-8?B?eU9QT1BxVXRIY0NSM0xyRThjVFg0UktZMjY1MDhJaEdndWViMzAySWMyMEY2?=
 =?utf-8?B?OTJiaVRtQ0xzS1ZWcDl5R2lNcUlXdVBXd1F0elFhYlpMZDJXeVVGNkxTMTNR?=
 =?utf-8?B?SGdkd3B5NGgwUHdMQXJBb3I1a3VZbmJ0ekJPWWJXNVo1U0toQXJIOHpkYVdI?=
 =?utf-8?B?dFZFK0MxbC9PQTQyajNrYTIxdEo5MHJYZXI3WmtqWFdBVFFkZjZrTU5wUUI2?=
 =?utf-8?B?WWtTMGJ1TTNvQUIvSHJSRnV5QURmV0ZadVZhbzdYenZIQmE5dGZlVmhEb1NW?=
 =?utf-8?B?ek9HdHVNVitOaG95YTRKeFRIcEVtUXpyS3B1czNuVUhsUUZQRldhdEpOdjJs?=
 =?utf-8?B?dVNsVllsRm93cEt5a1pZUnpDQ3pmUDNkcGdxYVpMM291dzlMQUduQ3JlaFNM?=
 =?utf-8?B?Q0tUZnVYU3JVNjFHd2N4dWkyU1dkd254SHdTaWpWTGtROEJWejdWNGkvb29m?=
 =?utf-8?B?R0hqZ3RPL2hrVDY0SUsvUmZaMmJXKzl3T2JxbjJ3S05SODFWekV0Z0Q2NEJo?=
 =?utf-8?B?S0pFdE9lR2M2ek5SUXJDeHUvUjdQSXJSTnlwSllPTGlvRkxnMXFmWlFUZ0VL?=
 =?utf-8?B?SkZncDdYc3hNVmIvRlJOUWxDeFVjMUZ4djFVQXRTOFdEUFNoWmFvT3dOam9Q?=
 =?utf-8?B?cnNRdjYrN1RWSG5kc0VieGdwZzVkNUhwKzR3bm1kTmJxbFJVYW45NGJyWk1n?=
 =?utf-8?B?c2VtVVRNUHg2LzU4NTFMZnFaYy9yWm5UbWVoM1V1ZFU5L0J4dForckFYYkpX?=
 =?utf-8?B?SkxQczlpNWljR3J5MHJxeDRPemhmVVdCUkQxc2ovU1U2eWFHV1dGZ0NBTjVx?=
 =?utf-8?B?QVhoUWxMbi9WTUZLTXcyUDZnOFJSeWRDTHhqL0xtbVYzN2RKS0VzeEFMMzRN?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g0es7eb5318bU2CaAPQTQVgwcE7ZZlG7MLT0NDp1XPe6w+1kfat8Evpz9ZDkIMzRhwMLfgau1C3CAjzadXFMVHAWLRdhVcot7rwiuYZTIO1ELQflRonVR4XqwX2OmKRJOlE9rCRkGd8btCqS+NP+A/ksyq6J6DmionrPdMqvQuQAIqZkjCxwsWOqcFCt9hYHlfHcgB5VegkJwjiwiYLBGjx9r6T5I08jDj4OET7Xtq90pR5N4IW2wvuulfKy7NsLleLXmeIv2RuxI+3WvtsNXxMiUr3JExO9clj8TlnwX31bmT1CFMd21zjnF61ePnV6tpd1gcDoDukhTVZPjS7Uybc+VYKHAS03TLCv0zueEzXkJZ17IRD9Q9VMgD1EAc78f0MzSWF7tVro1cpKRfvmPb3fmgCUewUcW9Lv/XAOb8oJ0Bf4g5evAzRcRmYkEfp7wrQGHkwcnRhUuB77M3s08h7xfNDETctF1mmMqDijpghnhRD8oGhvx1jVqrg6+Afb8jG+JSfh8d1Yn7nqBwySqLzoqUWBVfUhG59CX1iRSkfM6Zjnq0MDBTsJOQ+S1HdCJbRk/3OAsyeVDMFMejZlqeKpyttQ5VXU4+NlxsWClJI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f05df966-0b49-4df2-265f-08dd9388c51d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 08:16:19.1908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhU6Oru35SBidOTh+Zk0mQGH8XG7apwYIHBPbUTvJu2J1Ka+JDoIHgLYDSlP+be1KMWwiV1QmRBVgx8eRZ3ICw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7315
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_03,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505150079
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDA4MCBTYWx0ZWRfX4T+NFKWaVCG9 /yNd2glKJJUw1/Wa5wpO4tDyA0TmZHzB39c5dKf5+lqJb1FVbwIXdsIA7qfMhGSJkDfi77dDwBo 2HpI2jXJD6+wmBvqgTeoOcnbHC1xkHE/qshVxQRR6JNRl+GHQ4hPyqAlUtzZcevI1mnaXtjTZ5p
 fQmtRpTqtR8WcCX24xH0N9iJwu5jQmJoICbyc9V2hhPrZBZ5ChsJfMY1goiqVL7qpzRy2OS9z+Z B3MMqf8WwwwZ63vDqKvkJVwBXx2RRITR0HfUBm1uyE/c36D94AnroajdmsAol68iwSc6meYjRHr wuAPImpnUIwJ08VQAXIFS3SxojOzXj8n1UYqH62gJY7IpC9Jm5drKXdy+oRtZiArFL3qGpS+1sN
 DZAgfb/9pGK/LjPKIvJnvuvUFK0jeaD6dcXOkvi0NwPBK4NdSyyUlIHh68D1jLn6baecL5zn
X-Authority-Analysis: v=2.4 cv=EtTSrTcA c=1 sm=1 tr=0 ts=6825a2e5 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=HysIp09DDU8Ab0q3LM4A:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
X-Proofpoint-ORIG-GUID: 5So3fz51dnj6hoUtz_Y0PcNvKNg9aHWq
X-Proofpoint-GUID: 5So3fz51dnj6hoUtz_Y0PcNvKNg9aHWq

On 14/05/2025 16:38, Darrick J. Wong wrote:
>>> --- a/common/rc
>>> +++ b/common/rc
>>> @@ -2989,7 +2989,7 @@ _require_xfs_io_command()
>>>    		fi
>>>    		if [ "$param" == "-A" ]; then
>>>    			opts+=" -d"
>>> -			pwrite_opts+="-D -V 1 -b 4k"
>>> +			pwrite_opts+="-d -V 1 -b 4k"
>> according to the documentation for -b, 4096 is the default (so I don't think
>> that we need to set it explicitly). But is that flag even relevant to
>> pwritev2?
> The documentation is wrong -- on XFS the default is the fs blocksize.
> Everywhere else is 4k.

Right, I see that in init_cvtnum()

However, from checking write_buffer(), we seem to split writes on this 
blocksize - that does not seem proper in this instance.

Should we really be doing something like:

xfs_io -d -C "pwrite -b $SIZE -V 1 -A -D 0 $SIZE" file

Thanks,
John
