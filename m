Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC31291894
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 15:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750777440; cv=fail; b=WF7ApJLyBGbAzK7Ml1dEBLixF/GTc+tPzIjdqAfEMV993VppOiyL4s3Axk4DGv1Xez18VqB/7jVkaLAsUy+5aE86GKiujdj1Wf194BVJrVaU6/FRseRsh2joO9L7Gf9AJin/z4xzNm1sXhH+Bn707tb4ikhttg5vCo0nwnvrovg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750777440; c=relaxed/simple;
	bh=eIbmPOs/ICbAYgd7Ai1IxR+zSl4TZwvlhTg1Pmebqu4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZPx9UhfDqMkWM2k0fWSYAFuA8YnH3nqy1Yb/jMTkV5dmdzFhVPPi0rmm3e8vDzg4KbnCr5Ks0C9azd4jsD14dLb1HDEQmBJkHtaEHbGJJLsnWXHXM6elKu3vvZ1iPKePG+YWZft3MUVjPACFRBgryTsh9s/pNVB5qVBio/uZ2mE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nF4MvxiM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tDSOGtj8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nF4MvxiM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tDSOGtj8"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OCiGLV006368;
	Tue, 24 Jun 2025 15:03:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=p43RiODQo7p7YOm8hVSbb3a4mRbfeMYPM8IwtbxsVsQ=; b=
	nF4MvxiMN7watxe3e8Bt6sT8WLUcES0ph1AllTIZGLwCGnh/IiSBKhLSi3NVGHLz
	zKlY7gmfGTdvQCt+ZN+JhIFKXFSwUwFfvyy1VyE4A3OOJts87KYTzMFmlY3EsIU0
	H/HyPjxGqawyZBRsMbwBgGJ4hvvyCDcNEkTGUf9YYtNXBX3DEzIybkd+fuyEYYAz
	8TL9NjfvSG2ZWNh4F64n3GGL+0WBBYWIRWZ9lfIfT80R3tUEvO3SRsAVFZWgQA6q
	GD1W1SAs23Gu7nK7OhwZuC1KXgfw61Nyw9oWvgHkbmR7s0iwbWFiM084jUvShjPk
	fAh6ENRWOO7CEtu93aI6EA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8y5bua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 15:03:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55OE3B5D024158;
	Tue, 24 Jun 2025 15:03:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehkqru15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 15:03:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PlYmfSqGS/b1zIiYEUWeZ2hjOllSrnCldNsCR8PVyMI0/2MkIVuZ7HrsTCny4+GqyeyKfhgg1TEPPTtiQkyPSzkm1elJKT74cZnB2qZQVBYRkHfXMcXxUchzIyz4W3N1qOAn0GfVG4+JDakP60iuXEmQEiVLGAaiSh9bzdFiOcXCzhMb519vg7+6+DuUvEn9yZBrguX4R4dO7T2lK7OkvC7nNHit6msgaaswC1OPYA2SKVma3K/BOcl1kqZ5PkK8LkbSYJfCp/x97Kga9+yLKITE0nSgQUL2JDvWJQ+vL0z19NbfHJsNY3Az1VB6VgEif9n2oZ1WWCt0uUTLxTJWsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p43RiODQo7p7YOm8hVSbb3a4mRbfeMYPM8IwtbxsVsQ=;
 b=PL3y7UzxE786OHf0sogHb7vQ+JatklzeCP0ieHMvmRagmovGBvmFahGPHkxgRoJLxq/QaVRKmvNJJPwFw8QECKQjmNEmALnNi5xBhzRxhmGwfHpp6n+F2PNw1mOf1t4OYyy1/nIP02N18VnunXjnRoC1chdirxcCHkJdeRCLyQTse6JfefaHxb0sEmCN4LFNdlWQAHQFon+WtdrNE1WkwLBUszo2rUilonVW/hmQNXIbH2+V6/2umefy+3hJAMgrGFSri5P9dDgoEkCNlItqZjFpfr8Nx/J4k/uue+ld4WQaH2YRUnFj2SGbMzDUoCH0Ho3HzGZt776pXJBo4VNsrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p43RiODQo7p7YOm8hVSbb3a4mRbfeMYPM8IwtbxsVsQ=;
 b=tDSOGtj8L0049r/FdHZDmYqQIxeQB1p3wUc9+wRKapH8Brm0IZDvNJC14NVK+li6kJO0fbMCInQS0tiIXUhOFqnyr9Bn90HWLKGXyCW3BzZb5pFbwfTik13ao9SzCLl+X8mD+wcErXX/rBpmPQJAjpb1op6grAVTwnvgbMc0zHc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB5679.namprd10.prod.outlook.com (2603:10b6:303:18d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Tue, 24 Jun
 2025 15:03:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8857.022; Tue, 24 Jun 2025
 15:03:48 +0000
Message-ID: <5ad5f1e4-a3a5-4006-ae37-90edfe5d67e1@oracle.com>
Date: Tue, 24 Jun 2025 16:03:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] xfs: refactor xfs_calc_atomic_write_unit_max
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-5-hch@lst.de>
 <e8cf8a81-56c5-4279-8e19-d758543a4517@oracle.com>
 <20250618050821.GC28260@lst.de>
 <e2a54766-26a0-42c1-b5af-5a7cd5c1c0c1@oracle.com>
 <20250624140927.GE24420@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250624140927.GE24420@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0191.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB5679:EE_
X-MS-Office365-Filtering-Correlation-Id: 86d705e1-9e8e-49d1-7b92-08ddb3305279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnBzWENHL29lQmprT1lUNlFyOEw5b3VLQko4MGdnLzlScGFqQmE0akhBQU1I?=
 =?utf-8?B?VTZQeTNHNksxV2Jrb0FTckJ5UVhER0ZkT3ZiM3ZHcC9UM3VDeEI0RlBrTUVQ?=
 =?utf-8?B?a3dRMHk3UlY0eGcxVEpzZWJ1cWgzNUZQRTIyUmZJenZQSCtOS0VMWmVNeEhx?=
 =?utf-8?B?SkZXekxqVUE0QTRaZHBZUHNVSGoxZkhSRUluREpvY1d2MUZpNCtVRWxPNmZ2?=
 =?utf-8?B?RzhLd2VrZ2RUeVNoL2ZXNnJrQUw0MlZ2aXVhUm1xVnJ4Q2JadGRWVlhvMndj?=
 =?utf-8?B?Mm1QS0pBTlorUUM1YUtFYnF5eTdnd2p6M3ZmeTE0QzhSeDdwb2ZNN1d5bFhN?=
 =?utf-8?B?K3FnNkNKLzRSK2RaSW1GbGRic2NRZlZhSURNMnAyMHJmR1o0Z1pVcmk1Vjdr?=
 =?utf-8?B?RUg3emU1aFpyQ0xiVzg1QllLZlVNOGQ1ZXkxMTFLNW1aVmIwZmQyUHFjV1RB?=
 =?utf-8?B?ck1zYVRqdVZaWVYyTERJQnBlN1pTdlc5eFdBWFJJZEFySmdjeTMvNC81Sk1t?=
 =?utf-8?B?N1VqYndHSXEraHM4cmJUTElUYTlFZGpLTHlPYklnRzBWeHdzU1hWL1JvRUYy?=
 =?utf-8?B?NVB1NWxnem1xcGFwdW5FSVBGczUzWmdwZHZqakgweStnV3NhMlo5MEVSd2xm?=
 =?utf-8?B?bWhQT3NUTEhuTjNYaXRzbTJZbm5BSUVob3VoT0E5TmRYM2tWL1FhY2NCekVY?=
 =?utf-8?B?TUVlMjR5ZGRYNy82OGZmRGVqaW5UaE43cm5jTjEySW9GWFFhVmdJR3VENStV?=
 =?utf-8?B?akpZTmUwbEZJdGY1S0wyTFpmVysvYUtWWnBXd2MxM0ozdlhhWXNIdnFYazRq?=
 =?utf-8?B?NGZxM0szUzJJdnJlTmVJTE1HOGE0WFBRQi9WTW9Kb3Z4ZkpBZmZ0RSttenAw?=
 =?utf-8?B?T1VQUmJwTllrZ3J2Uk1kVlNiMTdQdUVEa3gvYWFWTG0vRjJkUW5iZ0JnMlEx?=
 =?utf-8?B?MTJaaTB0R1RpWURpY0N6djVPc1g4UmNtS1AreHBxS0tlM3h0WUNqeHFGSUU0?=
 =?utf-8?B?MC9IdWVWTEtPSm9vM2JsUzdEcTVtQ3Fwd2xsVUxNNENlZHhzWFMzd2QrSUJM?=
 =?utf-8?B?dzFoTVhmNTZ2OFY0RE5XUEtoMzQrZzQxK2xlYko2MWVyMU5kam5IaTJ5MjFR?=
 =?utf-8?B?TWFXQjl3TXd1cytabFEzbkE0TFZ2bGJPWGhxV2FoOGF4a2FuRmdLaTJmaHpa?=
 =?utf-8?B?MVZDNlFqOUlqNmdqQ2NMbVFEVWVUSGtyVWpxZnY1QXordGxkWmFBVEdSYVlF?=
 =?utf-8?B?OTYvcCs2TDR0WUZkMkRIY2RlN3hveGRPa2ZhYnF6bW5BQ0NzdFdpcWNHUzhh?=
 =?utf-8?B?MWx1VjFiRDVka2dsblQ1aGh0c2JZeFN5RUgrMko4eXVDMUUwa3gyNEhmNWEr?=
 =?utf-8?B?cng3cHRqZkYwcndQNU1qSW1peTBCckpkaWMvRk9iVjl3dFI0UGRDdy96blgx?=
 =?utf-8?B?aEtpRkI3NzA2ZUxjZUdSTFpwUXV0L3B2cGwxL0xLSm1ndVhpSmJ2R2pqVlo2?=
 =?utf-8?B?dnNuSmlJcWdYUERSenE0anVxNXlORlYxME5rVFRmWVRSK0phOW1McUdiODJ4?=
 =?utf-8?B?TVE2ZVdPbDFCcCtPeEcxUHRtV0dNbGN6aDZwN1JVT2k4WG03R3prSW5Qekx5?=
 =?utf-8?B?WWFreUhjN0dFWGVWTXJxSkJOZ2dPb3ZMTFpaaHJqekc4Mi8wWW5pa2lRTnc5?=
 =?utf-8?B?MjBoMGhHeWVQaDdtRGNSbkhhby9Hckxva1U1aUM3WnZJeEE2Y0MxWG5XdTlH?=
 =?utf-8?B?a29iN3dvQ04rZkVNYTlqYmFZUEhuR2ZSRlNxS2NUTStBTEwwWXVJQnR1Q2Ny?=
 =?utf-8?B?M210dnZoSlc2cG5YYndKRzdGQWp5Nm9IVVpGQUJzSmRuWTg4VWRYS0xSdzd1?=
 =?utf-8?B?MXpaNzFOOG9Pek4wcFZLRklWa2ZkTXNtai9KWU1vdFlOOFdRdHMwazlTSW85?=
 =?utf-8?Q?0URCrczrBh8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UW5QMnB3aEdNSTRsVk1DV1ZES0xhM0pyeDgrdWl4alBmWSsvMjNvdFk0NnR1?=
 =?utf-8?B?amUrV2NaNmg3MnhvOVNETFVwdVNmMSsyS25maTh1aklJMkdjN0dVMFFNRHUr?=
 =?utf-8?B?V25yTktreklhT2xkckRnRkFody9vam4xK3U0cEgybHRqUk1KSUJ6Szc5MWhl?=
 =?utf-8?B?TWpueFlSajVZd29kcU8vVHZoZHZveHdnenAwTkhZa2R1RXN6eVQzV2FxUkMw?=
 =?utf-8?B?ZzQybE5rM2FaNmFDVlpyeUNyV3pqK1VlNGd0NEVPYlV4VFFaU0NFM3FVZFM3?=
 =?utf-8?B?T1JXajVKTFo1RFBYRndrSUZTTXB0VmU3VlhUUmo2dnZkUWJrb0ZKVmxPYnVo?=
 =?utf-8?B?ZjQ1RENYMW1sVHU2ZjYrMEFPdmZ2c3dNZUFJWlZYSWtkU2JXVUh6dTFoR0d6?=
 =?utf-8?B?L1NZa0cxZ3RGODZHVXFDY3RncUtvQy9TT096T0YrS1cwNGNjRE0ycG94MENR?=
 =?utf-8?B?SDF3KzRhNldoZGhNdDMrbmpoYk9mNndwc0YyQmZyWldEYTdqRUJZTVNEM1F6?=
 =?utf-8?B?STVOd05Xc3JDTWFMeUNjSlFKYTJrNEF2UWRoRkZZUExja2NjQVZLNWw4YmJm?=
 =?utf-8?B?SkRTNHhjaHFzWmRLNVRLWGpOenV0VUdQSzZmaCtaeWMzcmc3WnR6bmpVV2th?=
 =?utf-8?B?T2tjRENRMVMwdHRnMm5SZXBwblMwV0hNdkVXZ1dqSkt0aUZBQVF6TGpxQWNI?=
 =?utf-8?B?YmtCT1MxNVFNWi9HK1l0MkY5OTM2ME9hUVVwTmhnRm1WUXdwS3A3d0NBdmFE?=
 =?utf-8?B?RXMxdFk4c2hCM1ZTM21uNUZJVEZadDY4dERreDRoRkxEeisvNGprZ0FhNk1x?=
 =?utf-8?B?MzZ5L1ZkeVhYU0hXUSt1VU1McDdjVEU3bHZNUE9uZTYzVC9ZVGZLTjZ5ckFI?=
 =?utf-8?B?MmN1R2hYYjgwaUZtQUZYKzAxdCtMRGlxTSs3R1F2UWVVVURTRjR3MzdxVk91?=
 =?utf-8?B?Uzc5ampQMW9pcnBaU0duejQ1bHpoM3pCanRtcEVIQ1FZNnlkUWszQzA1UlhF?=
 =?utf-8?B?VGRRU3Bnalh6aUhURjY0YlRiYVhoOXNkRzlpczQvZzNidUM3cXJITzJXV1o5?=
 =?utf-8?B?UXhqRi9oY05uQTZxSzhJckpseXlrUTd6RDRqZGYzaUpudm9MNmt5UWJ4MTZo?=
 =?utf-8?B?M2RHYmJubEYvNHR6ZjFEd1hOMkprK0xYaVo4RHQzWExoaXVjMEtBb3NISFNE?=
 =?utf-8?B?dFRWYW83NGlyeVFRMW82RUwxQTljSndtM01VeEpuSVNZQ2hlaWJZVk9md282?=
 =?utf-8?B?Nk4xdFdkQnpiUkhiSENlWHRibjlZdlpNOFcxN1U5clAyOG04QTVhaHZYdnVn?=
 =?utf-8?B?UkJDaEJKREpVdmJ2eWxzQ2RuU2srbS9tZ29hemhkcitDM2lCckFKeWJmK2Iy?=
 =?utf-8?B?STNLWHhVNTJjaXhvRnFZSitJRW4yMzVlZmVYVWtqb3gzTlgwck9nbmk3b2pL?=
 =?utf-8?B?OFJRaStVVVJaUzc2ZFBhUnprRnEzTUUwUms4RVVlYkRCL0Uzd1RwVWZoL1Fs?=
 =?utf-8?B?OWI1M205bFlObWdxRm10YXlyUlFpSFFQR2RIMnk4aitHKzdPZVhoSkJEZjJ6?=
 =?utf-8?B?MW04SnRSOTlzbmFPVlhDRVVNNWx3ZzdmYS9Rd0Y1enZGeTBBMGZ0dlVnYklL?=
 =?utf-8?B?dzFoMFdBTlpvS3J0aWhpc0xPYnNFUUpKQk55NGZjSWVkNWNjdjU4MGUzRWJ6?=
 =?utf-8?B?WXBpMDRtYVBlWmtVc25IcnAraWNuUlZvdjZiYlU5Qlo2TmZ0aEQwQ2QwU3p0?=
 =?utf-8?B?YzVVd0Z4cGZtL1F6K1F3bit6U2pnOGdTTGFTMnFmc3lYTDRpOVZieFIvK3dh?=
 =?utf-8?B?YjI0NjNBT0Z5dkM4M2g5SnVBeXRLT1FUZmozai9kRDFLYnc4N25iT0p1bmFN?=
 =?utf-8?B?RTNHRHhIYkljSkhMcFZjUksrY09iTXNFUHB4WWdUWTJxQUl3TXJRUEJ0NmpG?=
 =?utf-8?B?T0p2L2tDSVhUQ0RXODEzZE1odGEvY1c1dEJzOUJaODMwSURYOGVOWG9pOWFU?=
 =?utf-8?B?NjhJaHVoem14NWM3dm1LcE9VYzVsRTBqZDFGYldxd0hiL0p4YWtWQlA0UXhJ?=
 =?utf-8?B?MUR0TVVpY2lFd2dRbE8xenJjZjBENkovR2xJK0xDOW1BZVkyUTFwUnhJNTlU?=
 =?utf-8?Q?dON6l7rhBLWditufX4G8CPNXe?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pnRLoFwfjxx+oqyB3EMbnpmGsggy/jgv/BLUb9dbm4bCr+HRZnt2u9Rs9GAIuS4ZpogIRi+iDCu1ciyQXo96XWm+/AjEpDII2s6IvGU4MpQReLb9JA3769OPQcRketcVr/foLi4GqhOinbZ+dnVEDFMOhLH7dICqf+6/CFXmZSqG6W/wkk2jwn75AGalWlmq+MU9ziciPv69n2QlXr5fD6jNMS155aJMOFETEdv6aa4K3ijRVh9xZmgtCPSfzmDJIOqhxww+erKmKqNLBsdV2GC4hryrhYzIEF34qw/gUC7msr8py9K3hp3mLfG6cgYmvUO6LmN4+YruCkA/8WTBXh0NJ5U9qjb1+my5D55apPIsgW2psMERnQ5RY1bRWBqKjsJ8TftKqwZEW6DE9GNgqhl4ItJW3oDAMVTTPcCrwuwhxESSPuapIRBAO2PGifdDkTVfeAAGiUHEK9ik0IVZU0UDCt4kaoEwxxiU3eV+DZk7typ7x7m4zhFnLopEMugvWdQPg2d1iLtfPh1I76+EfjgWmV3hLCbg2iyPLhbzc4PxJLO0i83XOXgns01O26oyLpGtbdVsa6lfMnI69oU19eBPBp3Y5vX7152Q1gueAMQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d705e1-9e8e-49d1-7b92-08ddb3305279
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 15:03:48.3500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UYormdpwl2IwCa+AYgA+/0vKPqCwrsN0ZkGTMjbrs68LOFoIsaHVGmBTi1XWZUNZCslv1loWQTkTWSeBhsLxHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506240126
X-Proofpoint-ORIG-GUID: kiJ6T7Od5x6S5wlHpWgX4TavyopB1JfA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDEyNiBTYWx0ZWRfX9KhvlNIVHUFX yE4lqY8sFk7VvpHfGzgBTSca2f1NyyBmYV5WZ1esqdjrOeuOE0PrShRs6AcrXvb6KJwC/ucOKEC z0d0EubgkjbpsDhBsLj5nEvyjtrTMBJ8l8tY9SGvU6QjrdqP+8q+u3MSqFgFWaKezsf1FROwaOF
 q1pdGDsSQeYWDzQLvfbIILDx/47Byrs2YdtQ48yP2EVnH0v7HoOVvCeLHvVZNeo9DtrsW0Rqgt2 udsVdo8GyrVvIfy+q31MsEJUbRpZ+MU4DbZhWdu/cXvCSA9IaqGatP8osjhLH0qe9t1k+Z7daa2 GECktah6OOJiO2ZG2RV4yBlphpPECpV8b0Tbw9UjHkvQR9qRBr5CQPW48CzJytDYUF7045O6PgP
 ddLwoAeT16XKaK0jnwXxl0EZiMqMJgg5xPKCBK3i2VJ50tPIJYCnkfLsjl/pw6RZGRDfo9Nn
X-Proofpoint-GUID: kiJ6T7Od5x6S5wlHpWgX4TavyopB1JfA
X-Authority-Analysis: v=2.4 cv=PqSTbxM3 c=1 sm=1 tr=0 ts=685abe59 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=8tEpQuT0kcnHe7FLh5sA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207

On 24/06/2025 15:09, Christoph Hellwig wrote:
> On Wed, Jun 18, 2025 at 07:28:19AM +0100, John Garry wrote:
>> On 18/06/2025 06:08, Christoph Hellwig wrote:
>>>>> -	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
>>>>> +	struct xfs_groups	*g = &mp->m_groups[type];
>>>>> +	struct xfs_buftarg	*btp = type == XG_TYPE_RTG ?
>>>>> +			mp->m_rtdev_targp : mp->m_ddev_targp;
>>>> Could this be made a bit more readable?
>>> Suggestions welcome.
>>
>> I thought that you did not like the ternary operator :)
>>
>> Using an if-else would bloat the code, so I suppose what you have is ok.
> 
> Initializing variables at declaration time is one of the few sane-ish
> use cases for it.  Although maybe a little helpers might be even better.

As you prob noticed, xfs_dax_notify_dev_failure() and (effectively) 
xfs_group_bdev() has this same pattern.
