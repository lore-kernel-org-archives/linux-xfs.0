Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6252613D8A7
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 23:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720740997; cv=fail; b=EJ/7LCXucVTp9K9H5avlq/yTqzDPBI83Sjm/LQ2AB8DVSiET6he+Xr4/m0qOGDkfxsn0/+E8b3cbZna6nXi1MVHU/lgnqVZ8ZZPeUsZaPYeDe8ksvDhQehQQNFoj1gocCU1ESxiodke2HWTd56UooKk0cffkRlFmOA/2nYKzPGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720740997; c=relaxed/simple;
	bh=P0LYzXb5hjFTBTNbIWtUstNMF8pPY6ICNuMkeRyGEv8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KT4rT/jr+m6ipK68aDtCptEqYX0WzA0oENdcLTuGwrTnXU/6zA+tvZpaHm0e0zX/21Yl8Piiuqb4LL+njitzDaWsAFDk0zF5rQ/eYriuthKUl49xsNUZWGyMC0fuHhqsyKFz9Yl+pCJ0SD608SESFb1lJ6qJ75p3zxN6q8uL2gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=itF9TIWz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CC+gFm45; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="itF9TIWz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CC+gFm45"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BKXUGE028221;
	Thu, 11 Jul 2024 23:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=P0LYzXb5hjFTBTNbIWtUstNMF8pPY6ICNuMkeRyGE
	v8=; b=itF9TIWzVk0LQ/SoJF2h/8xfpQSIh0D+0CrXvBnO7Sseucq/zkNruvDeQ
	7u0UPwZFXKOXqv1tDs9c386V94Se4wbul/efSbVlLutnGdPSu1+V+/JDQVgNlb1r
	BHg4jqlRmwnnw/RQ3yXUGBC5c09ZmCsZYKPzyQhKdQ8WxWu0tYnLmFouRBraqAdJ
	jdHVa62ZBi3jTW4Y575VNECDgpeiDPk+uk5tvxvmHzc0aitUObOTYrsnsub0bkL3
	nLLJCcBCxjA1rUeedBM9ym4SQqP0Z2bHdTEqkWusc8HD2Pl3/lBwqACahymjsQ7Y
	zUzczHYG1dfXtpQDF1e99djv5PplQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wkntq6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:36:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46BLdCiH030087;
	Thu, 11 Jul 2024 23:36:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vvbx319-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:36:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B/Ikqum+LP1pZo7X3PtLGqsiFaDXCV9YPap5qpDr7QygCK1kKQwG2BfxXg0X0MI9T/nZHzUrH1/CowvI2V+L/dhIRr1Ahyiwoz28AvIBJv4sky1z9q0XLTwMvvxjKtdZEa+E5/KC2eKkpLbTPh8OqzovwoZc/GXDWOhgRdB7wPAIXkWy3SxSV4+qF0gBd08vhI+aMlTSw6JbY4EjKKt3h9UPRTe1WdiO+rtVzNJP80CU2r4yuLVd+SxYl/TMimN9A/cTj97O9wn5Vwaf8SbuAQwzFOH4H9cNXWqRz7Q1oBl+qPZxSx2gezmEAsphQ8+1d40M/KmNKrXr3DO+aeSehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0LYzXb5hjFTBTNbIWtUstNMF8pPY6ICNuMkeRyGEv8=;
 b=bdHagXqf5MlhgAKb48jxymS7e0Lp+/cUMJDbtjv2eHm2rhRNp+w41bWuE6bhxKioR613QRlfis6ei4Z+CjwVJYwjHml4P5HYoJh1Xt9P27VWmIy5MsbZUbtI3qNdWGtT5nCWsRdCgrm7Ku/heyA82tnPHxIgU50b1Lr8KcN6itLdAtzdDaOqBiW9cb04TiuQlDYbwWiTvQ4NIZgQQlRg/PxKVF5up7ZcZEl9hy/5yA8DkYR+0xZWG7syY2lfZUyUtoanjFgnxkk0NTHpE7os3tu9OmmOogcY3S7Xz0gJgKuhpeNrNtiNVCXj6wTPn5hEYpavIJ3cjs+pp67WwCHDFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0LYzXb5hjFTBTNbIWtUstNMF8pPY6ICNuMkeRyGEv8=;
 b=CC+gFm45T/wrUe0mW4W4CNL93AAeOwk6zj8AryKPxxRyzh+7/yXOvWvdvyEEy8fPxpihYw2NdP+zbuJU9LescXF+rrE9LewTsFu3uMeafngZnKwfP/A6DEuMx6CYFem2sTD3Oj7SJA8dY2JOXnaxKf98dwPbf/gkmStbeeHk9jM=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by BN0PR10MB5029.namprd10.prod.outlook.com (2603:10b6:408:115::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.21; Thu, 11 Jul
 2024 23:36:28 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%6]) with mapi id 15.20.7762.016; Thu, 11 Jul 2024
 23:36:28 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 9/9] spaceman/defrag: warn on extsize
Thread-Topic: [PATCH 9/9] spaceman/defrag: warn on extsize
Thread-Index: AQHa0jOwaQZbabfy90qdsexMqm2q3bHu1uCAgANa+IA=
Date: Thu, 11 Jul 2024 23:36:28 +0000
Message-ID: <3DC06E8A-486F-44D3-8CEA-22554F7A5C7E@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-10-wen.gang.wang@oracle.com>
 <20240709202155.GS612460@frogsfrogsfrogs>
In-Reply-To: <20240709202155.GS612460@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|BN0PR10MB5029:EE_
x-ms-office365-filtering-correlation-id: c882df97-6400-42e1-76c5-08dca20249a5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?Z2t1Wk9tbHJUWm02S1J2ZzlhR0RLTzMvSnNMelNnUHd1N0lZTHVlbXZOT3hP?=
 =?utf-8?B?QzJsQWRiWnJRT09YVWFZV2JKUFZKcTVrVHl4VVlOUmNSQjJkc3dxVUN1UitO?=
 =?utf-8?B?MkZ5QTVUMDE0cFBNZGZCUUFVU1lTRDZXd2hIVUU2RnlSd0dDRzhkaUZOSEtH?=
 =?utf-8?B?NzJONSsvOFNmS24vUzBBdUF1VkNVa1dGVGlaZ01TSUo5aEJSQlR3OEg4Ym1w?=
 =?utf-8?B?VUQydmd3Q1FFTW05VTRkWUNEeUlnYld6ZitqQU5tNnZuSzRBNmhRZkh4TFM2?=
 =?utf-8?B?RzlUSzB6alBOSERxa0VpS1hyOVpvVUVmK1R2NEF2QkZZT1BqSm5YYjlSS0pW?=
 =?utf-8?B?L09UQk1qWW5vQTcvYmxrNzhOcmZYZ2d6QWx6MDA1T3QvRjdNemI3aWJaWmpp?=
 =?utf-8?B?TjA5bzhPSlhnSkk4RHVqVmtVU3I2Q0k3Tmc3cFVvWko4enlEVTVWRnc1S3Va?=
 =?utf-8?B?M05HYjhqS2hNSE5FUDdrN3JERjhPdXpFSmdVUHRiTks1R0krTlQzaitDK3JF?=
 =?utf-8?B?MWI5bGVwcTNxQXVrcWdQMnM3VXY4V3VLSURNNFczaWRucDhwWnlNaUJQWTVv?=
 =?utf-8?B?bWI2WXFjTU1hUFJRQ29KbVpZQnk1MmNrQlVSaTNxU0MrQjIxT0o4bnhFNDVN?=
 =?utf-8?B?dDRuOGdLNExFZzJzbEo5cVAzWlh6bzBKaTlnckFjNW0rc09od2lTVDlaTmxj?=
 =?utf-8?B?Y3hpQXVYb3ZsYzhHS2FNR0ZjYnl2NlBCNS95d24xUmUyZmFLS3pKR2VranR5?=
 =?utf-8?B?U0tNa2pleXA5QkZMa2FEbkVsY0lESDh4UDZDWlFlSHRWdHFlSDhyNW9kcUdu?=
 =?utf-8?B?TlpGNFJXZUFac05xTHRHTDF2aCtFYUFSa2tRV1poVDRUQzlNMkZjWmxTNU55?=
 =?utf-8?B?QVp5VklrK3R2UE1BVU5vMFQ2L1JOQVVIL0NWT0JjV1Vvd1BLMXRqUmhmTWpI?=
 =?utf-8?B?dGxucjhUMWJnOXdZa1lRdndOSEUyek0vZ2lrd05ZSWN5OUt0MFNnMXFJQzU0?=
 =?utf-8?B?WFZnMkRTZ0hzZnViZHJIeEwvMEtkeENXYld1b1kvQmExNndmZm9FN0tsYnds?=
 =?utf-8?B?RFhtOUxsYklrUDZId1JRRUo1ZXBDNnA2VlcvN0ZCU1MzdW9xTys5N3ZTbS9K?=
 =?utf-8?B?eFZVSzM2NUxzZmZZKzdHS3pZRDFkRjVIOHVEZjNJODliaCtpeVZWRmYvTlRy?=
 =?utf-8?B?YWtlQzFXNkxHaTNiQXJIOWNKajZvdmExTEFSaFJOQkIvcDRlZmtlV1RjQ1FT?=
 =?utf-8?B?Y1p0aXJZYmw1U0hwYlRxUzgvSzQ0QWJaWnlmVDBKa0h3VzgzY1A0UktWVmlF?=
 =?utf-8?B?bFRDbGhDWng0ZGY4RzROVG5mWlZnaFdhSzhQY1hpNW5WUjRFbG13MWN2MTlO?=
 =?utf-8?B?VFZZVmVZT0Q3ZlRJZVV5OWtoS1c5OS90SHN4QWFDaGxHUnpUa2dRMUxIZng1?=
 =?utf-8?B?eUkxeTNRQ2Y0b05pSndmNHZRQVdpR1RXSUR4VVJSTlc5OGlpMVFMK1YzK1g0?=
 =?utf-8?B?RTNESXRBb1hyTkJRNmVMdGZxWUtvZGhaSzFyOWFXVFlmaWlZTjh5TkJjSHdV?=
 =?utf-8?B?UCtzUkFORUJ1YkJXS1hxMlYxejNNVUdsdkpLRUVMQ3hMWjdJU3BHeGFac0pB?=
 =?utf-8?B?SEZkZk1TRVBoKzBOVG5md29pZzV0QmZOZVNYdzhibDBnUy9GeHU1eDZxKzNS?=
 =?utf-8?B?R2cyejBrclQzNnNRNzNPSkJSalphUnBRTXZzR1hFeWViNVdTRmZuOStOalBY?=
 =?utf-8?B?a25MY2QrbVAya2xpZms4SGNGQ3lLQ2VYU3JyMm5oVjV4aWRsN0sxaXFLckpx?=
 =?utf-8?B?VWJybjNsckhJZzBjZzlpMmVRWUlHQ0RDRkJ2cmtXRlBEcnBlT05oNGtnTEIx?=
 =?utf-8?B?bVFkWE80MlhPallKeVN6c01YOUMxNG9IOWJJRE1qbWI0dlE9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?cmFIOG9xaEdiSytzWW9mS1hMVDl0ZDMwUnBNZTJRMk9lL2J6cVZXSlYxcjlP?=
 =?utf-8?B?TFZpdkhoTkkyMFBqUDY2RDFWbGg0cnpaZ2ovbWdaYzc4YU5HbVZmRkVqS0JY?=
 =?utf-8?B?b0hNNjJudUxKa1JmeFVzbkwwV1NkRXdjNzIvYTdzM1Mxd2ZTd3hWdFNPM3pH?=
 =?utf-8?B?bGZGTjRJckZBMnZKS3o2eDF3SFhPdDJRNXZ6VCtyNG5VQVJzeU1EY0dZSEk1?=
 =?utf-8?B?cFMyRVRkYzMxclNPdWhEQXN3VEpRRnluaXVXZ09WRlBmbjhicERMQnczMXQ3?=
 =?utf-8?B?dEhqem1XaUxuQWhma0dUaG1xUmlNSk9tNzV4MWRpREhlcko4UjFDMGUrMXRl?=
 =?utf-8?B?RVVXRk45NXdpWm15UlpHRFdRTm1HSDQ4T2hKaDFzeUFlMGI3YXhnRjJUaXBC?=
 =?utf-8?B?Z3FaZ3JlY1hlUDkzSVdkdnptRVd5ZEF5STNFWDZXWDVoMHh2c0NiOVBFQllh?=
 =?utf-8?B?akJhYzlKbHhWdW9VK1VxOUdLYVBNckgzWk56Q3RVWkJiODNTUmcxM0FxejYr?=
 =?utf-8?B?VVZnbWxVV2hrTjRNWmIwc3p2NkwyYU9tN2M4YWxGdTBQQ3p4Mm1KOHpXVGRk?=
 =?utf-8?B?WjdrYi8zZ0pWTHlCWWZLUG4vZHJqMjNnbFN6U3d6Q1J5Z2hsQlMrNm1NWnYw?=
 =?utf-8?B?TTlLVVFnckV3Sjd3N0JqcDV5UW1HQS9Ib2VEMjJkbUhtSlBoRzVjMnhiZ0Iy?=
 =?utf-8?B?a0liZEN4YUdNSmZJTHkwMnl5V2RROE9FT3FOOHQvL3haOUJpODMrZXNyMEZw?=
 =?utf-8?B?UkFoQWdrK0o0K3FLcEViWEJhSDJVM2ordHdkVWp5cCs0YURneGdtOGZudHBw?=
 =?utf-8?B?elZDZmo1ZzVOWmhiLzRXQTZmQS94RXNRcmtoSlBSZDJQV1p5WU5pa2Z2U01h?=
 =?utf-8?B?YTV3S0VwQ0kycktBOUplV3FrekV4cUJGcnhjbWtrL2RkS0ZucWg4dG8xakFq?=
 =?utf-8?B?SmhtVUlOaWFYTFZ0WGp6WU9RWmxmL291MG5QdTBBVFVyNEpGeVFGclhsM3A5?=
 =?utf-8?B?UjMzUlJBU1o1My9HMzFNZW1QUUNsRjRGU0hyVWhwaDB6dFhUU0RTeEJWcmx3?=
 =?utf-8?B?a2ovOW9qYUZsMVhLYjViRkZZWEtHVnVoNHFPTHBCSEx6aWlkbmxGalRkaktY?=
 =?utf-8?B?Rk9aUDRXTlRjVmpweFpDRmo0RjlnNmdBVDZuVjNaOGtLOE90SGFQaWdpMURK?=
 =?utf-8?B?QVh5OW4yekQ0U0hSakRxREtGN3hrNHZ4VHNrUTFPckZZUUJnMnIySS94MFZs?=
 =?utf-8?B?aHZWMnoyR3pzT3NQUG9Od0xma2kvb0pIckdjUC9aeGV4K3FsUUwyQW1IMVRa?=
 =?utf-8?B?Y05pbmJGeE1najBOckNCL1o3MExTdk00Q3pycFBGYm4xQnF3YVd4NmprV2ZM?=
 =?utf-8?B?MUhaTGNINnZLM0JjU3BzdFZSaHZLSjVOLzBoUWN5eUI0NmZVOW1aMGNvQjNP?=
 =?utf-8?B?S0lYZUE0am5DNnZZVmptcStMVzJuK2lnRFE4bU1XZW9XR05RYTl1dEFhZTBU?=
 =?utf-8?B?dEpLTXdSdWJwK0FTU045REFuZXRXWVlLUjJxZytkWEpRYW1TMzBvdTZPSGFM?=
 =?utf-8?B?aDFYejdUL2JOU2kxUlQ2TjRlbnRPUlUvWjhxQnFIdVhJQVhCdHpYRWJxT285?=
 =?utf-8?B?T1ZpbXVsZ2M2eFF6OEcxa1FaU0VOZXN6dHBxaHZlSW9sTEZNK3laeW9YMUdF?=
 =?utf-8?B?a09VNGJ2Q1lUZnJJUUtDTVRQenZub0RYTkloMXNxTzk5TDlqQTFqNVg5cDVj?=
 =?utf-8?B?ak12NG1OYjJjYm8wbHkzWWN4TmxIeEJWdTdtRCsvODUrKzh4MUFHSXlLcjJM?=
 =?utf-8?B?TU0zOHk2V0xjWEVTZ3FCc0p6aW1CK2pHVmZQdWtFZTRicmI0aUJaTGFxSjJn?=
 =?utf-8?B?Z2k5VzZjUXlEdnllYnFIckxYUmUvaHFlWXBFTElJZGZzK1NoNXArM1NSSzJv?=
 =?utf-8?B?NHdZQWJ5ZjR4L3hiMU1md3pHck4yTnY1Ym5qN1JNQmFoZ05DQTNhVDI4VFNW?=
 =?utf-8?B?YUE2T3ZsRlM1U3VQdHJFS2VCQk5FcE1XYkZZc3hSTGNUcnJMUGVBcXZ5aEtm?=
 =?utf-8?B?RU85OXhBeDFhclpLRWxDS2pGUE1ZVzV0WG5WOTZsY2U4Q2RucHZ4Wnl1U0kw?=
 =?utf-8?B?THdxMnJIeU5NcERBZ2F3YkFaZUNuenY2U3JYejlzc2NXalIrN2hXOTFKY0sx?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E09ACF99C6C5374ABE941FE8E2FF9336@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	n/K4Y9v3cPhdn6nnkFLmnmJdHdeM59qVHRN+PJmHo00JFbv3a9OExoYuHJhzNpL2KRZ9PrkAHW/RDnw1eYGKiQ2RzhYToQfZPCufupmr308xd1c+qrSUn5HDDzbH9tm6PNyPwcOdq7mdQcUN/1/XyF7hpt+6yIlviOWGw96fGRFu2oQd7PL0uF4HWFhHLhpPscECnvboWTtnBEVlNucLTFJNchYLlEq6vj7FCwrbAuS0ZlpnWc42Fdo7DT2mIsc/jj69h7ZoSiQxVrbWH0qS8x4jDGkFz9nATUQQFpfTAgV1HsKfJ7LHyPBu11mjPjTSTOujQpNNrCwm+5qGaOpU1qaaJB62oghq3PbAX+LtzIgZeJGqeVfM7sjg+tog5HhHhoXQW3tbom7LnhkmqIrtrqhL3FTCrUG9sw1qLEON2PxK79u8Sj4k5XvjH9gYwNBHwRfx5M6dQXDTTkGm2DEphaAT3Rc0lw5WV0oa2dbukASu0NcTuUTguejdXwVWlWG51WsWNyHT0OqpB/exEvJIpCr8Z6bWPNQ0ExZ31mR8jtPZHs9N6O3HJfmyATZ8+H+2RU/oMov/3ZZdoBfLsh6O1ssqAupL9ARXFG1Uz9gASRQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c882df97-6400-42e1-76c5-08dca20249a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 23:36:28.8892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dOJ4v3DauteHH0LGmpKrCfIZ+OJq3VVEl1yKG1f92GK+OlvN7XG303fKU6BFFGdsM1rsdmuwqThnTGEH20mX6h/VTto4Er5vfcEl6gk+LqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5029
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_18,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110167
X-Proofpoint-GUID: JdaEQ5379C6eHCmnOsMgJo5fUnakF0Vd
X-Proofpoint-ORIG-GUID: JdaEQ5379C6eHCmnOsMgJo5fUnakF0Vd

DQoNCj4gT24gSnVsIDksIDIwMjQsIGF0IDE6MjHigK9QTSwgRGFycmljayBKLiBXb25nIDxkandv
bmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
MDoyOFBNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBBY2NvcmRpbmcgdG8gY3VycmVu
dCBrZXJuZWwgaW1wbGVtZW5hdGlvbiwgbm9uLXplcm8gZXh0c2l6ZSBtaWdodCBhZmZlY3QNCj4+
IHRoZSByZXN1bHQgb2YgZGVmcmFnbWVudGF0aW9uLg0KPj4gSnVzdCBwcmludCBhIHdhcm5pbmcg
b24gdGhhdCBpZiBub24temVybyBleHRzaXplIGlzIHNldCBvbiBmaWxlLg0KPiANCj4gSSdtIG5v
dCBzdXJlIHdoYXQncyB0aGUgcG9pbnQgb2Ygd2FybmluZyB2YWd1ZWx5IGFib3V0IGV4dGVudCBz
aXplDQo+IGhpbnRzPyAgSSdkIGhhdmUgdGhvdWdodCB0aGF0IHdvdWxkIGhlbHAgcmVkdWNlIHRo
ZSBudW1iZXIgb2YgZXh0ZW50czsNCj4gaXMgdGhhdCBub3QgdGhlIGNhc2U/DQoNCk5vdCBleGFj
dGx5Lg0KDQpTYW1lIDFHIGZpbGUgd2l0aCBhYm91dCA1NEsgZXh0ZW50cywNCg0KVGhlIG9uZSB3
aXRoIDE2SyBleHRzaXplLCBhZnRlciBkZWZyYWcsIGl04oCZcyBleHRlbnRzIGRyb3BzIHRvIDEz
Sy4NCkFuZCB0aGUgb25lIHdpdGggMCBleHRzaXplLCBhZnRlciBkZWZyYWcsIGl04oCZcyBleHRl
bnRzIGRyb3BwZWQgdG8gMjIuDQoNCkFib3ZlIGlzIHRlc3RlZCB3aXRoIFVFSzYgKDUuNCBrZXJu
ZWwpLiBJIGNhbiBnZXQgdGhlIG51bWJlcnMgb24gbWFpbmxpbmUgaWYgeW91IHdhbnQuDQoNCg0K
PiANCj4+IFNpZ25lZC1vZmYtYnk6IFdlbmdhbmcgV2FuZyA8d2VuLmdhbmcud2FuZ0BvcmFjbGUu
Y29tPg0KPj4gLS0tDQo+PiBzcGFjZW1hbi9kZWZyYWcuYyB8IDEyICsrKysrKysrKysrKw0KPj4g
MSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL3Nw
YWNlbWFuL2RlZnJhZy5jIGIvc3BhY2VtYW4vZGVmcmFnLmMNCj4+IGluZGV4IGFiODUwOGJiLi5i
NmI4OWRkOSAxMDA2NDQNCj4+IC0tLSBhL3NwYWNlbWFuL2RlZnJhZy5jDQo+PiArKysgYi9zcGFj
ZW1hbi9kZWZyYWcuYw0KPj4gQEAgLTUyNiw2ICs1MjYsMTggQEAgZGVmcmFnX3hmc19kZWZyYWco
Y2hhciAqZmlsZV9wYXRoKSB7DQo+PiBnb3RvIG91dDsNCj4+IH0NCj4+IA0KPj4gKyAgICAgICBp
ZiAoaW9jdGwoZGVmcmFnX2ZkLCBGU19JT0NfRlNHRVRYQVRUUiwgJmZzeCkgPCAwKSB7DQo+PiAr
ICAgICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJGU0dFVFhBVFRSIGZhaWxlZCAlc1xuIiwN
Cj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHN0cmVycm9yKGVycm5vKSk7DQo+IA0KPiBBbHNv
IHdlIHVzdWFsbHkgaW5kZW50IGNvbnRpbnVhdGlvbnMgYnkgdHdvIHRhYnMgKG5vdCBvbmUpIHNv
IHRoYXQgdGhlDQo+IGNvbnRpbnVhdGlvbiBpcyBtb3JlIG9idmlvdXM6DQo+IA0KPiBmcHJpbnRm
KHN0ZGVyciwgIkZTR0VUWEFUVFIgZmFpbGVkICVzXG4iLA0KPiBzdHJlcnJvcihlcnJubykpOw0K
DQpPSy4NCg0KPiANCj4+ICsgICAgICAgICAgICAgICByZXQgPSAxOw0KPj4gKyAgICAgICAgICAg
ICAgIGdvdG8gb3V0Ow0KPj4gKyAgICAgICB9DQo+PiArDQo+PiArICAgICAgIGlmIChmc3guZnN4
X2V4dHNpemUgIT0gMCkNCj4+ICsgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIiVzIGhh
cyBleHRzaXplIHNldCAlZC4gVGhhdCBtaWdodCBhZmZlY3QgZGVmcmFnICINCj4+ICsgICAgICAg
ICAgICAgICAgICAgICAgICJhY2NvcmRpbmcgdG8ga2VybmVsIGltcGxlbWVudGF0aW9uXG4iLA0K
PiANCj4gRm9ybWF0IHN0cmluZ3MgaW4gdXNlcnNwYWNlIHByaW50ZiBjYWxscyBzaG91bGQgYmUg
d3JhcHBlZCBzbyB0aGF0DQo+IGdldHRleHQgY2FuIHByb3ZpZGUgdHJhbnNsYXRlZCB2ZXJzaW9u
czoNCj4gDQo+IGZwcmludGYoc3RkZXJyLCBfKCIlcyBoYXMgZXh0c2l6ZS4uLlxuIiksIGZpbGVf
cGF0aC4uLik7DQo+IA0KPiAoSSBrbm93LCB4ZnNwcm9ncyBpc24ndCBhcyBjb25zaXN0ZW50IGFz
IGl0IHByb2JhYmx5IG91Z2h0IHRvIGJlLi4uKQ0KPiANCg0KT0suDQoNClRoYW5rcywNCldlbmdh
bmcNCj4gLS1EDQo+IA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgZmlsZV9wYXRoLCBmc3gu
ZnN4X2V4dHNpemUpOw0KPj4gKw0KPj4gY2xvbmUuc3JjX2ZkID0gZGVmcmFnX2ZkOw0KPj4gDQo+
PiBkZWZyYWdfZGlyID0gZGlybmFtZShmaWxlX3BhdGgpOw0KPj4gLS0gDQo+PiAyLjM5LjMgKEFw
cGxlIEdpdC0xNDYpDQoNCg0K
