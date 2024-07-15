Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB141581E0
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 07:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721028503; cv=fail; b=tYAGR+x1kUKlkFoRpliTAIw7hmJcv/ewUxl4pBIPSO6jdwLEtnEe3xt0w0vN41LXElQao10O53PKD9Ka50T3cf9VT0Rux1OfHNxxao2UWsbLPPGc3kcZae15UhGuyM71/BDfNSevZcyFbcR9JUJVHH1ejRI9yyWAYCndv5GUKAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721028503; c=relaxed/simple;
	bh=M88BR3DXJV9DGIZ4XmT5fkDbUhmSi6/pmcCcDzxZnfI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OiQo8MPHBDfQv44BiQj60971IInr8r4GpJmrzc7ikQC46TH4dm/mMzdTkg42uWFFdfe4VwcRUgBrgOBWptt46Nu/CVqeDRNPCp5vSB5Hr0jvMLbXUItp/rkVMv+76mRSpD9n0r+NwJiy3qZ22teIeisM18C+oD6EyjcXaT6oARc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mC1IbMJX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r0tMTiMN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mC1IbMJX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r0tMTiMN"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46ENasMu005858;
	Mon, 15 Jul 2024 06:56:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=nbjMpH91A67sx+uN/2JPdUTl7/ABxsyUy89VIz98ZCk=; b=
	mC1IbMJXxiV5acNvUwBP9bdmh9jFftmYqKwBL6mhDdWeu+sTUY53sO1AWBBo7vj1
	MKJV54Zc++cKjw/BRrTXhocN42omgNowIB0MKTnbetUW4LmGNmsPXiY9qtKB4IDY
	tGoaer45Iunsr9+YmHcHmtdi8HD4qhZniGk9Y/SvSe66ACQikjE9qY4RNk2aoM0x
	Tmsbq6GNOe1gmHFsvl4UudfUXoOk47/K75L1NERgE5SKtc1nGTEzDmpkhOnl/zxS
	NSODPpusfYvPKKl/FbydsfXhA4C5WynAeT9P7ZFze/x4gWsp+SejNLTbV+4SRpKw
	7tKMitxBn6xw1q1+qVLodw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bg612gap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jul 2024 06:56:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46F6Uo4M013899;
	Mon, 15 Jul 2024 06:56:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40bg166n4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jul 2024 06:56:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lTC9m8NM+BJDgvjAeKx8J3YJ3Svutb8EMy+XM+gAlE3y5NsGrZ/JEV2H16HIEOjtXo0zpl6tF3ber+K2Jic4EfG7xTgfOHvZucpXtBFPECXaoLJr/w4XCwwYMjSyVd/w/qR0ZLrjz3ObidV/hZaen1KuM9o3W1sb2FtcygVwj7J09VMbQdMQYH8AkgpGSmG6BFGvw+yJwb2GTZYlnDTR4v6Hv3rHGJWOlQlvbrYjtv+ZQL+kvGKyXFnT8mve1MB6iuzVt+4Daw1wIhzcB2JLURH9oUQAALOagN9e0hgAK9AkGcynRd5kuAHoDbLThq30fHtygpNVFiUUFBcV08RwEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbjMpH91A67sx+uN/2JPdUTl7/ABxsyUy89VIz98ZCk=;
 b=kzptN6DHMCFAzMK3AR+kmkkt7ZdN5HnRk79Irae8znbZchlY28zP3XR1vIPhRmuv59vsQDQKX68fypQ33Fly7BNGFXOfg5an4jTmjhrDfOZ8MBhDpcS4uD9xtwjPhEZPqY7SVlSViMVS2lg4KKKxoSP/YD5MYa5l0ElQTEvEPQYRJ1e72JgKdFbPKB7DJYv2P+x7N+49Z9msRb/fupaTL2I7+laKHcfHjoDvnS74LNOVY1x+qokg7TdfLRtJBP5EMPyVlQOOlgY97D5eXGvlfRwQjaMR1Sk3a40ZAvv/KT3uppPeiVRQkrX757ySRB1bP9VfsoJPsd+WhyQRt3tnJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbjMpH91A67sx+uN/2JPdUTl7/ABxsyUy89VIz98ZCk=;
 b=r0tMTiMNzT83Crqa+lnFfJxAzpYdFpihCYQgyCe/RNR/OKUutZdNj9ED2j8y9HA4+zplr99skyGnJq3Mc5W1VsdN2TUu8PHnYdX2/WxbjPSPQWpCLsI+Fkh+gnXHTS5lBeenO/Q/bcsPINJn15LWT/yAuHWMbogdmS8gYfLtpA4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5032.namprd10.prod.outlook.com (2603:10b6:408:122::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 06:56:05 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 06:56:04 +0000
Message-ID: <51b70aba-0100-4735-ac91-3284a4a5a9d8@oracle.com>
Date: Mon, 15 Jul 2024 07:56:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Use xfs set and clear mp state helpers
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandan.babu@oracle.com" <chandan.babu@oracle.com>,
        "djwong@kernel.org" <djwong@kernel.org>
References: <20240710103119.854653-1-john.g.garry@oracle.com>
 <d3362032-e334-4e75-baf0-90e992c7314f@nvidia.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d3362032-e334-4e75-baf0-90e992c7314f@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0319.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5032:EE_
X-MS-Office365-Filtering-Correlation-Id: 58354d63-5f63-4c2b-e03e-08dca49b3210
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?M0tOOGdtU2xiTnZoYTRxTFNlTEdSa2xMWmNteWVUS252YU1zZnJUQzB2SVJE?=
 =?utf-8?B?Ti83RzRySzZZSnN5WWdLUkFWSzJjQXkvOHE1QU4va1AzNG9keEhWc2kvTWd0?=
 =?utf-8?B?dGFwY1k2NFVmWW9neGo5eDU2RHhZVU94S091UnBMVzF6aElWWi85bXhvU1Vn?=
 =?utf-8?B?WTQyRGpKRU56MlZPWEZWYlBibS9sV0lkWHhLU3RyeEhmNms4QURuMDFhVnRE?=
 =?utf-8?B?UGx2SHl2WmFpTlJjdmNLUkxtUzcySkRHRjRHaTd6NmY2K2l4WHh4eWZOOEVi?=
 =?utf-8?B?WThOU0ZuUlptN1NuVDM2OGVQUyszTENMb1UvMk9sRnhybXpvbEJNaU16TkFS?=
 =?utf-8?B?VWNNT013TWV0cDlPQng2U21EK1g3aFZnZHlOUDUvTnhJSTNSbHFTbHNkN1Ix?=
 =?utf-8?B?MkhvczY2eEdDdHlzVG14NWRLRXZEa0JHVVB5RG9oNUEyNTNTM25qUVpXcm5N?=
 =?utf-8?B?V0o3NE13OUlqZmhqVFhBdnE2bDZkV2hneFcrQndpVENCZmxFYzdVcXJ5c3Ry?=
 =?utf-8?B?TUFVN1FOUkgxYWJrZzNWanZPRUtjWXcyYnY2c051R2FpeHhrS3Rlc21OOW5y?=
 =?utf-8?B?R1hkUm4vNEVzL3k4alc2aGtOdi9JVHNQRG1nR2o0SEo1V01kdWZEdHh3Vzlk?=
 =?utf-8?B?cTArWmNGbXdBODhDWHRCcU5HUHUwVEwwL1Q0alZlMTNYR3ZENlZ5QkRTQVRK?=
 =?utf-8?B?MXdYeWM0S2x4VDMyRkF4YnRGbHJvdlFvMUpFQmtBN2xwc1M2QlJzMHJ5ai91?=
 =?utf-8?B?TU5lOVZyZCtYYTlPSXZGeU1JRjFDdlEwOTZoNHlyaG9KazMrUWxlcDJsQi9s?=
 =?utf-8?B?aE5SU3hLTVZxVXVoV3N6c2pYSXFiYTVzSHpjTS8rUC93WUczeEtta2I5aHY3?=
 =?utf-8?B?aGlsUnpoUzRBdVRiSjAvd0sxdVNRbVdCRDZydXRGb3V4U2dEbXlmVjR3SzZk?=
 =?utf-8?B?cFJPbzB1VDl3YU9KNzRBNnlkZklWQ0Vta1ltL2xJNzdhalVYRkF3MTV1dWh1?=
 =?utf-8?B?SDc4SmcycHIyR3JkcUJvZ2xyRjJNMk9qTTdCNFZBak5paCtjN2NRY3ZDRHlW?=
 =?utf-8?B?VHkxVlJtN0gxN2drQS9NbThQc2U1OTczMkV5WW91bmNIZW9RRXB4MVhXL2RL?=
 =?utf-8?B?WE80djlQMkRSZWxndHJlZWZRMDVkN2laRXpvbWM2THlSZ2NObTBvNE9EV1hV?=
 =?utf-8?B?alMvbHFpVTJYdk5sYllEa3FFams5aVhEemcxNC9RNlNmd3NHT3BuMXdsVHRX?=
 =?utf-8?B?Tno2NThwWmxBUk5URU03UlRIcE5ZM2FlSjFwMGJwOW00cXNhenB5NC9IZHI5?=
 =?utf-8?B?Y3ZrdjJTZHBsajU0d2taVmRNOENvSzNHenV5R0htWkNHQ0lnUjhJMlBqS1gy?=
 =?utf-8?B?d3puKzAvNjB6NlZFanROVjZnZEhJaUFza1Zndzdqa1V0ZE84UTBuU2s5ZUcy?=
 =?utf-8?B?eUJZMmtDYVF4VFBwbCthQ2JsRXZCSHkwblNjSUl1NWZLeWNvdnhIaEtJMUh3?=
 =?utf-8?B?ZGZ0azE4VHk3Syt0aFZyYkNvSXYxalk2aUVBa2V2R3hTVDZpOURGVnJuL3pP?=
 =?utf-8?B?S0k1L0pvTno4TU5yMFdVUEdBUlJxUXhST1VnVGRNbFVmZ2xzSXVjRXlmaFB6?=
 =?utf-8?B?OEhMNjVtYUNBNzRvWHRVOFFZTncySGpkRmJNUjg1SDFHVHdCdnA4UjdsOGV2?=
 =?utf-8?B?Mkt2cHVXTUZQN2lNMGswbHdxemhDRmNXWkh0VGRQNXNmVndGVFFmUk5Ua3l0?=
 =?utf-8?B?bzZWUzlmUmo1TTRYUXlLSjhkZE1XdGs3ZWVWdFZLRDYrcnp0SEJxN0ZabVU1?=
 =?utf-8?B?SWlWK0ZEOE1VK2hDWFpGdz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dWpIQXVKRmVrS2IyaWNBRTRnSURnWXlPY2VIV1hyaWlyaitZUXVpTkU5OHZa?=
 =?utf-8?B?OUkxcUZpbWpGK09FTjNqQy8vZFJIZHROQXgrZ2t6NUkwZEtVNHdHSnJueWpI?=
 =?utf-8?B?TzhZUDZkaUNQV3NPNjR6dC81SzhVay91eCtrZ0d5dkM0UXJiZkR3ejM2NWMr?=
 =?utf-8?B?cWpNbFdQNGE4MGMwdEl6SVp3Z3VFSzZmRkZjWXlBRGdFcS9YMDdBSXVZVlR0?=
 =?utf-8?B?OUU1Znk1bHlXK2lkVjNjbVRKUkZvTkhmRDFBTnp2OFh0K0RxYUY1MnQ1NjVH?=
 =?utf-8?B?eG5Jcmlhbkh6SXFvUnc2WXZwdlJpVFlzZXNpK2oyWFVDUWdmVlNISnJJWEhl?=
 =?utf-8?B?NGZteWlqWmJzVzFiSm40SWU1aUtMY1d5RkhtdXMyemVVTWNlY242dXp5NnFt?=
 =?utf-8?B?QW14MnVOK2h0TXFtZXRxaUdyN1FFTVdpa0JJWnBQVVhQU0VIb3VXVVJ2QjNz?=
 =?utf-8?B?MCtUdTBTSkYwNE9PWXpsVitaQzBGb1pmd01CTk1oZHhKekVGSTA2YlZQeFFI?=
 =?utf-8?B?NHpoNGUvbkxLWmk4T2dUczJUeUs4OC9nTEt5SDVsdTBQaEp0WlB4SlJnOC9E?=
 =?utf-8?B?a1N5MjRQcmN2akxKTFlmN2UxQmlrRk9QcHBEMld2TGx5T0xrYmRMYlZVRGZG?=
 =?utf-8?B?S21HcUZFMzlabmtzeU5BajFaRDFPM1B2VmZPT2VaanFHcmRjK0Z2SjV5ZXlV?=
 =?utf-8?B?c3luZ1VGRHcwS0dvZTZjamlSU2ExYjZOejF6dkZVSllvZEYzRmwxS00wdStC?=
 =?utf-8?B?MjFZR0t5NHFLa2REbDhJbzI3T1p5OUxvOFlVQWswaDRvN0V4S2Z0akZlWkp6?=
 =?utf-8?B?WlpvZXpOaU5LMXczdE5yMExoekgzdUtwL3N1UHpDNGtBWkQ4SVp6TmdYcnRR?=
 =?utf-8?B?WWhVRlZuOUs5dHJDNFhSaEV4Y2kzaVhhZndmSkpXRFNIRFVQNUF6YzBoNWNQ?=
 =?utf-8?B?VjByS052WEVKQjN1cUtsakZaMHRBeENGOWR0dC9QTHZlTHZpU2YvZ05Ob3Ju?=
 =?utf-8?B?a1hCU1FTWTRDRnJ5eEcvWjNEL3pIMWlUY3M0QW9qQ0wzVlFuMUpYMlcyR2RP?=
 =?utf-8?B?czF3ZllUcjNOTHhYaWxkZHZsMGVXSGdIa3dSMlNiV3BJblNkVXo1eFgwMFhQ?=
 =?utf-8?B?eG02VTNZRmlXVzRIeWlPWjBUYkpTRE9ZVTZabnV5NmN3QVlaQ0EwUVZlSyt1?=
 =?utf-8?B?TUhYNlpoZVZEWGxwSG5nczdnVmhVN1pzamlOYkJMUE01MG1zaTJWWVNZRGhB?=
 =?utf-8?B?bXFmMnN4OEdueFZhK2NsN2tJcGtqMFUyVjRFOTJQWWRBSjV1U3RZQzZIMGNz?=
 =?utf-8?B?aytEL2g0RHZkUE5aam95c1NjOVJtUjk2Zko3M3d0b0xkUUowYndOQ2J4bmZ5?=
 =?utf-8?B?UGVCWm9icnR5SkU1R1RTczBZMG9aZWhDLzhJamdveGQ4UTFYazkvbVhJNkhW?=
 =?utf-8?B?LzJyOUZoWmY0aVVKVEs0cnlWVVBpazlhOENIM1QvdnZ0SHNZbVFVRzR0UE93?=
 =?utf-8?B?aTIxL2hTRnZqeFg3NGVKNm5pSFBwVDZzQlFER1NKMWhQV29rRTh4MEJHUUpI?=
 =?utf-8?B?VXFQalZiYUR3NlZrcGw5WTBqdkZLZGtNZFdlNHoyZDRndS9wY1BqM285OXhu?=
 =?utf-8?B?QXhNZE9MQVExaVcrN0hrb3VsVU5HV01RK1BRWm9LeUJOMHpoUUY2OG1XN0VR?=
 =?utf-8?B?UVdEQWR0cEwweVpBcVBySGtDTG9qTUVQODBJc3ZZdHR4MWZBc0FFb0t5TE1D?=
 =?utf-8?B?ZS8rVGNMV1VHalcwL0p6djgzZnBxYnR3dFIwemd5N0ROMWx1TGlrS2UxbjdC?=
 =?utf-8?B?R0ZIWHI1Rjk3ZHZIeXRHRHZVY1JnbXl3SnRnL0J4bVpGTHN0NGhFWUcvQlYr?=
 =?utf-8?B?cm9sajYxNUZ6U2R0SVZvSmJpMWtjdTlkRG03MFJmY1RXZzhvS3UxekRzSWZa?=
 =?utf-8?B?Mld1KzY3YllFMUh1OWFNRHNLKzQrd0lSSnREaTY5UnBPNTBrRS9pSDR5dWVB?=
 =?utf-8?B?K3FENVdFWUcrMm83ckNldXdYZ1dpcmtjRUcyUVozbE1la250cDh3WWJaQU5y?=
 =?utf-8?B?R3RlRVpjNFZoc3dVdjc5K1JuRlZxUkhhRlZILzZ3d2xIK1YxcFpoSzA5eWZm?=
 =?utf-8?Q?bsKS5QAUl2AGNzdhGNPfHiITS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	yZWvg+/Js7Dq0Txgej/4o6H43FaAvSRlfLN2EhUaQ4Yd7LDu+RCaaweXoC6YucentMZw98Y/p5byr6f+ufvGScK0no1XnkX7CJZX6dn6LjzP4YAtbYVKM0ss+cqAGCAsCLV9Na8pRHhuJK4om/J0HxzF4opYTrR/PGBhu8Jb/EYKpqyJpEvVPQqx7U66keQXvnumjIK7ntXNSxPU2jk7TbdtDcn2a5EVs8hmz1DiDHZcbWaJfzSLRPRKA3PixUk1t9ipVLBkzBYMCJMMKjaYzWbiNmYKg2gZmrJ5aFdOx/emWBjV5sLUzkYzb9X8OpbrU53aqOcvPvggD2mFnZG8Gb3saAVwqO2F3F96KYtO/cCBnshUL3s+WNJueCjcxZ+Lbsl5lkraKVQhCbH8TjQ7a4n2N5q7vFAh5pjHzm5Z7b6jky/MTO4CJs2e0vW1uWhStINlEySAxR15hjO7yRQaix1AbM7gl3a9zZC7/gOIYRx/+dV0nkMDxNIbrUlfyywtL6u9O03LWUmEa1qNkZGxl24ldVC11QITp9+bsGeQMogxuSp8hKfFQRTwMRn44melKZXgTVsx78Lqpdlsi8usiI42c3IG/F8gzaY0yXVVDV4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58354d63-5f63-4c2b-e03e-08dca49b3210
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 06:56:04.8491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mUAGSzMhD2FD7OVfa/4ONvuSvG0LL85BpRYxpMtHDqB5DFa7/oF7WS2J1Mk8dSqZy89/nfDi2VgPXCyHZDaNlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5032
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_03,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407150053
X-Proofpoint-GUID: ut1OQ9YcAZFYZrypiDfanIutAQvEI5L3
X-Proofpoint-ORIG-GUID: ut1OQ9YcAZFYZrypiDfanIutAQvEI5L3

On 12/07/2024 18:39, Chaitanya Kulkarni wrote:
>> Signed-off-by: John Garry<john.g.garry@oracle.com>
> This patch looks good to me, however formatting of the patch seems
> little odd to me, what I meant is section describing the number of flies
> changes and lines per file seems to be missing, e.g. (from different
> patch) :-

yeah, I often use -p (no diffstat) for generating single patches. The 
kernel documentation for submitting patches does not mandate a diffstat 
AFAICS, but maybe it's strongly preferred on the xfs mailing list.

> 
> "
> ---
>    fs/xfs/scrub/trace.h |   10 ++++------
>    fs/xfs/xfs_trace.h   |   10 ++++------
>    2 files changed, 8 insertions(+), 12 deletions(-)
> "
> 
> Reviewed-by: Chaitanya Kulkarni<kch@nvidia.com>

thanks.

