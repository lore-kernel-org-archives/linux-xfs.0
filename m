Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4111513D886
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 07:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727852798; cv=fail; b=Ddz85CbA5oKmwg2HQC44azAiGwXao5x3y29q9UN6J4H7Is6lkR4jn/6cpSYWEDgoQsD2UsKQYag9AnjhsO4NHeskufc+SeR3QvZGT+HAemwnHLvTZccvp2MzJCDlaTp5z85T7rgXH4l7kWU2qSJm9nLQ1sUMw0nQo6V4fDUF3eU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727852798; c=relaxed/simple;
	bh=HsSKHwYDz/W6eo6gWXWU/Bzn1w2ow1IwBHYdLLuDr68=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r5MEK2fDt+ils9sqGWbz7IgLd/Wc3Rv9/dZvnoOignsptmd0l37X3hM0uy+eGwbvKGHHsvsB9bJOLSoB0SDvail9n4alBBLx5mzYnqi6TmfSrUwf1Vv4HnWYR1IfNgwKnbKGlIQvxZtloavn+E9xpq909mCaV2+V04/F6tVodhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=djoS5L6G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=quGo1iW3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="djoS5L6G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="quGo1iW3"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4926MZOf017841;
	Wed, 2 Oct 2024 07:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=1SFr84mahVh7YI4DuWYbSPFfinU0tDuZIsza+RN/VRo=; b=
	djoS5L6GaiW7j+hc6hwDS0r0jNGWeLM/oV4qPkB8SQAAltumg7hZtk2VwgzUyKal
	DXH+fgLt0eJYJOD1o4knhnPtKu7u18WSoBwI7z/3FTFnTHIgDInJVfJiXx/zV2Yj
	L5qfwz/85HLiVcighlTgLJUvCzzBRCrt5H0DrzmCwoEA7WRmpzf/M89yQrGczUMF
	V/aw4nAwqLh6MzoxjjV3hbhb5oUIo9sUfyGb4vws79ZCSkAQla7eFQJ55au+3qwK
	yD6+dn8CW46ckBAVdH3ewusHDI5vww9Dv38vApyl+fhwuDz3BSsjjrbX8o4TPjEw
	hhELhPmrGRKgb479U9pRdQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41xabtr6bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Oct 2024 07:06:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4926ilWC013411;
	Wed, 2 Oct 2024 07:06:25 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x888a80h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Oct 2024 07:06:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QWqkEzr4y6beSzNg7SyBQUlVizYSttBc7OZD9cpa54h390RLo3FqWj/XuCGAm+wn++zf5vXHp7E/0y7pKopCQAtTJcNPh1/EWoQJoqGZVzr/6+CCLhwim/le3ksUCT2ioVhqIf6a9/8z549566G+HZYjO9HgZGajzwyfPhlmfwrIo7QEgMkWAtZwqoS4NMV29JPFQsFlRZeAV8j9JoaXIe7NFFE2naO9Gj1pOh/8WPLLHmNdoXqNfR6XnnwJWSpHNPj5FJ3lf/qNt8nWzy+tQVzGKWC0BsTrNl3Sdz+FYEqwccjLHM02kV+8/iQFreJCTcLFr3Olo9V7XrndlHBpIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1SFr84mahVh7YI4DuWYbSPFfinU0tDuZIsza+RN/VRo=;
 b=cDeeA/5JWyHSRoZ8H2N8Hf46iX2ML7CXxyTQzO7TQfg8b/Bwgl9Vj7BeBWlO6yBRu4hVu5u3v3QQTHLu8YuWpcftH4enx/rUV74AUTxvzVRB1wWF3YG7BH8x5aA0/jVDfs50ZbYQia2s5ybgM5GbRO0Hp4FIURwwsFIpfEejKTjuS2lNi84IuGnQa4bCw+Zykj5rY49dWKCZ1BvqdjULd2EkzVTH2Bue1Ih2d0ZgEOuFqCHJGtujsV53W8kph6M55W85AvanLq3TiF7AuhED96z9skXjPNIQjjljd2y+X9a2yPpI1rBL+bCFrOr+HAAjqCY3cay0SLzHrusYbaleIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SFr84mahVh7YI4DuWYbSPFfinU0tDuZIsza+RN/VRo=;
 b=quGo1iW3/HThbhSZoYBtrfP8f/1E1IijAWrr3S1jcYkXKCeKv4VDPpMfXaiYEdNrBD6+PPlLgUvPxKPRrxs6Lni1DOZERgHvadXz0BAc8EUysrSpgrHjY2v7p/JhFKQ0hVu4AnPhDqwDWzak9VV/l43O/iPRTv9ZtQXlYHc+2go=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB4889.namprd10.prod.outlook.com (2603:10b6:610:d9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 07:06:22 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 07:06:21 +0000
Message-ID: <26bdab05-a8ec-4af3-a083-c842d13220d7@oracle.com>
Date: Wed, 2 Oct 2024 08:06:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] xfs_io: add RWF_ATOMIC support to pwrite
To: "Darrick J. Wong" <djwong@kernel.org>,
        Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
References: <20241001182849.7272-1-catherine.hoang@oracle.com>
 <20241002010106.GX21853@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241002010106.GX21853@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB4889:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf70785-cd27-423e-8c20-08dce2b0b80a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b0hCcWFEUWlaMGZ4SmNYZHF5WEJVMlVZV2g3R0kxT2FGTEVVaHlNZTVLbEc4?=
 =?utf-8?B?elVrdDFIR0JjSHEvSGIzMkJyK0VBbXYrK0R1VHBsZjhyaHZ0dGJMTmc0ejZj?=
 =?utf-8?B?cVZmVFl2djRMQzRGN3l6alE3aFhER3NnOERRSkF2Y0FnWjdsMEg0c21XVnpr?=
 =?utf-8?B?QmV3UDAyMmxKa2xnOXZFejZXc0lqQ1BqSlpjblV6elk0WU4xZ1ZWWWg4dVRY?=
 =?utf-8?B?Z3BIMUtwRTFTL1VzSnUxUTdPTG4yWUk2endxaWltR1JBVmw1UllmRC9ETXJI?=
 =?utf-8?B?VUgzWXpPU001b0NIM2dBZVNjaEtSeFI5NVBQSm90R1Vqa1h1S21BWDZoVjhD?=
 =?utf-8?B?VXhhOEwxb2c4akw2TWR6YWtNM3NXSVlRRytuL2dSMVpsV01IaWRaMDlGQ0Rv?=
 =?utf-8?B?QTJRTml1eDBiSXREQXFqbzcwVUlpQ3NzYjNjc3VvRkVSbmhMRS9pbkNGZDEv?=
 =?utf-8?B?S01WTWdscVc1cXZSTVFqZklWSTN1Q0pzbDRxQnU3Ky9SY01venluOWI3WC9L?=
 =?utf-8?B?bGpzTkh3SXhUK1k3Qmp5Z3Arc0crUzhEQTJkdUY1TWQ0eVFCL3RSSUNYdmRI?=
 =?utf-8?B?U1BBWENsYk1WTHFhS1U0UFRJVmU4akNUTXh1Y0Y1eWh3TzVyNkFMaDJ0VlJE?=
 =?utf-8?B?dnJYME45NmdaM2EwdENOdS90UWNJemFWYkd5L0JxR2xwaUxwYmlHWHZoOVZO?=
 =?utf-8?B?LzFGaE1NMWdzQmt5eU56VTZCenBvM3JWNGhWYWh0MWlZUis5M01BTVltL2lH?=
 =?utf-8?B?V1ZaNFdGUmFRR0ZpMHY5S1grSy82WklzRWg3akhwd1hwYWk2QWZJZDZ0ZmRh?=
 =?utf-8?B?bTFWdVRXMmRsNG81dVltRm1qWm9oazYyUit3VS9vT0FxcXlZZEtobm9tbUxz?=
 =?utf-8?B?MjVkbml5dlRUUTZ0UVdNUXVydEhaTzRSYjBiTHRuQnBsQkFVV2tuWjEzVzR5?=
 =?utf-8?B?TUp1S2xCRFlFL2FCRG05K0FXS0QrZnc4dW9HZWdKUEF6QkE1UkxDUTRyTlp6?=
 =?utf-8?B?ZlZiaXFHNUE4UjZKTUNUTTFWOUQyeVIrZzd0NHZZUUlsQ2NCWXRnM2NLeTN1?=
 =?utf-8?B?S01wRnBLdnRSTTBmUU1rUHAwa1dlb3dJN0Q1SUsrcnowcTRIZ05Fbk5ENU5z?=
 =?utf-8?B?SHR3dXNuYlVURTQrN0RjTFk4ZE5BRCtsKyt3ay9YTWZIRjg3ZHJFaGI2RHUx?=
 =?utf-8?B?YkJhWVlSaUk5WG1XbXc2OHh3amlFVllyZHJtM2h6aHV4VjR4KzFHSVFoU2tk?=
 =?utf-8?B?VzVzU3AvK0t3TjFZcmpndGhLOHdRZGdkdmdPVm9hMmxUKzJROFczdm83TzNh?=
 =?utf-8?B?ekNVRjc0ZnZ2RzB6QWNwVXQ1U2xLdk9ua0FMMUdMdERQdE5hY0VKNUVtUXRM?=
 =?utf-8?B?Q3pCaFF1T3VTeTBmbFhXemRsU24yL2pMSVozbUtGYVQ4VDhEOFpvcW5YRHY0?=
 =?utf-8?B?S1ZIYi80dlhnOGQreVBrcTJEa2RiUjFacjNlTGVKVDdqdkVKbFJJa3JhaThM?=
 =?utf-8?B?UGFKZkpuS3o3THVnaGluWlhISmh3YlgvclMzVXNsbWJxc1Jhc1pjN0xOQ01F?=
 =?utf-8?B?ZDdMdUpSVVNBaVNGc0xPK1FEdmpYVTNad05nK0pFNGcrWm9TZEVSR3N5TG9I?=
 =?utf-8?B?ZitPSEg5MG5pajZmbTQ0T0h5ZFF6T1k5VVAxMnFhWlRBR2dydzVxWWw0YjJM?=
 =?utf-8?B?VEdvSUxuRUtESlNKdUR0UlUwWnNaU0pTdngvOVk4WWtkb0I3RW9ja1pBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHZSMmY5clBWZVMvRThiM09SV2dsVFVtREhuQTdDamhFUFdBUGVVRWl6ZEw0?=
 =?utf-8?B?TUFnRkhWMW1hOHhHU2M0RDZSbUN4eW8zaWNzYzBMQVlLSkVmc2daYU5IN2pw?=
 =?utf-8?B?Q1dTYUx3MU9PS3NPdnR5WkQvM0NOYWtzZ2dDRlB0MEpScE1Ld2doQlBablVi?=
 =?utf-8?B?SldSK3ltZGpObCtEQmtyZlJEdzdtRFI4c09PRWdBZXltajc1KzN3a29la1ZY?=
 =?utf-8?B?SHdhVmZoQkZZTG5BVVh5K3ZsMFEvMkhaKzlmbTBhRVFqTURCVkJIcGtwRkJC?=
 =?utf-8?B?cWxVakZyczVURFZDWFJUTU1XVExLOGF5MXl6djF2Q2V3SVJ3TzJtcjBpYThR?=
 =?utf-8?B?QmZUOWQzSDVJNW82ZTdSTFY3RmNKd0xXYUNwT09RRVBkVnpzQVIwT3dsMmVP?=
 =?utf-8?B?b0VDblVwTlRPcXdlcHBTK3cvWTl6TFdJcWphYWVrVGpMek5aYlo3eS9PbER6?=
 =?utf-8?B?TXdJVGt3RHNGdGhRV0ZMNU5DS3VHZmI1aTdzQUFpTUVtUjBOczVNKzdjaDN2?=
 =?utf-8?B?dFlsVllkYUVnamNTejlnbnRpSTNxVFZyNncyMWZ3Sjc1LzZZelFyZ3lqRzlB?=
 =?utf-8?B?KzVkK0JJSHdROU1xelBPa1VoTFhFdmNqVHVPaUhkL1FKTG1EVzhUNmY5U2No?=
 =?utf-8?B?OUFCNU82QlRLVFQra0lLS1ZneVdkNzNidUYvL1N6UzNoS3l1Q3l1SlIzNTlS?=
 =?utf-8?B?SHREQndjTllnZ0d3Y0dqMkw1ZUNma29odmhITjJJbTYrTmcyTlJ3K1pGTm9Y?=
 =?utf-8?B?TTVnWXJQLzF4bC85U1lxZ2xxRzIyZFIxQzY2L2FHTlJwdVRsWVM5ek1oMk1l?=
 =?utf-8?B?aGhFdzRrNEZRdXNrWU5vSUFMSWM5Nnl4L0ZBTU1qbEJCSWgvTUMybC8reVpI?=
 =?utf-8?B?TitSaCt3Y0pUS0Z3eWZsZmFLS0NVR2ZvZDVsY1ZYam5NVC9NL2ZvemJiazFz?=
 =?utf-8?B?Vk5nVm5RY0tZd084bU5YRTJFTThxWU1pYzJ3TEJ1ajdlYkpWUTN4TVRyNDFw?=
 =?utf-8?B?R1JFbWNvQXprc2JpMm16ck9iVDN3NGtTMjh3UFFiWkQxbTVjSVRFaWk3cFRH?=
 =?utf-8?B?bGovdFR5S24vTzl0dytOb1FDak5LMTgwY0xoTUVvckdiZ1YrTEhXeHVMRVVS?=
 =?utf-8?B?S3Qzd0F3SU1UdXFoQnZETWE3cHFkMTF5c0d2THUvVS9rcFpzSlZMcE9rN2pW?=
 =?utf-8?B?UXJUaVdPSTlpY2luampkR016UHM0RHJsZVZ3cEpvSGk0ek5vTjJFM3dBcHVQ?=
 =?utf-8?B?WWZYQmlLdDNLMVVzR3pLQy9CbHRtMXF2dzdCNldkYUFTdzA5dXR5REpXUjJG?=
 =?utf-8?B?N0VRa1VHZXUyM0FBa0c0cVJJc2JBN0UxTVpTTFpnTDYxZXZNaDAyUGwxeEdn?=
 =?utf-8?B?MVZPTXV5Yld4cjQwODFaVG9hWDJrTmJMaGkwYlZTZSthWnIxZG53ekhubDdN?=
 =?utf-8?B?WHg5NmRRWkh5b3NaemhOb1pISTdTbHlxQmcwdjdWQU1KVHR4TGdJTU10bzdX?=
 =?utf-8?B?VXdRdlI4MVdkYUk2L0NyVERSN2NGOUEyaXhyUit1NkhSeFhHVzVEOG5NL3gv?=
 =?utf-8?B?RkxtaE5FemVPa1dabG9HM2VDaWt0S1FsQW14a2RzZUUyZmhPQytrQzljcFpp?=
 =?utf-8?B?QTR0RlY0RDlrbm02UTM0QlNvZHBsSlZtT1R0V3BNWGN1ZVVZY1J0bEJQbUxi?=
 =?utf-8?B?YzQzZEtGbWpaVTFWZjNyQzFuSm9MU2d2VHBYV1hWbzdQaDhKQnc1Zlp6aFpF?=
 =?utf-8?B?dkxZNWt0eDZPVGFoc3Y3NUd3Q2RTVU5KSTVSWnF5dVFySHFXN0F3dnJoYUdv?=
 =?utf-8?B?eE01b1JCSk42QnhzTFpBZzhTZGZNVklOQVRQSVJpTWFCVURLaGRNR09TYXVF?=
 =?utf-8?B?QytxVFlON0FIRGsycEg2aDdaamIzWnN5cXlUUVFDOExRaTc4Sy9OckZjTWxp?=
 =?utf-8?B?aDFDY2lSTGhEVXFXK0xmcmI4TWlQcWt0QVNEN1BReVJUN2RobTZGN3p5dU9V?=
 =?utf-8?B?NnpkL0NjbXJ0aXduWVlWNjNXRENxdkdCNlEwcDV6TnpmNkdsWGpMNER1anc2?=
 =?utf-8?B?OTQrNU9wS2hUN3lFY1dnT1NVMmJvelp1R2lvVzB0S2lER0l6MnhMU3FLcjZM?=
 =?utf-8?Q?8fByqixZTiPTcqnsy7wTasE68?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x2QEYGhjfCcSeuzVjrRi4KhmuRDKhmxlUMtA7AhFuccWNxwGBtntintkUFluO8IME8UE98+/JR3Jf6upwmtw7MXj9nkGzH0xo2fpMqow9vpCNcZvWMEXbmLLTJErsJBz1Fb4PpERy5EFHINxCOzq05tOoc/j756oYNyJVZR/FVYBfoR/JuyNTtUYfR5WwM0XH0MELDdn89rzTkaDW1vm3M1Bx2eIyTmv4nKvYUzU198MORyfDJmuBiRjZbDFUw2X+8cAbo+UjlwiWur2f3Wb9Fmz1/BcTmoo6Yam6dtMb3U4uy2tmhtvAl9ao9KvQRMw15/2i5Xe6aKgA9xIgnLHRqZJ4DAtV8uHlzTx8jTqkmvUrd/KNcOV/dff9sH5A7RmevRyLjQrHqstxvKnLz4097I25CkI8+PKlhGTfE/Ts1vGdoLW5rOOmIb8kWajx2DbIMYQLwb15FNXGLmvXWAa3+nQ9KBF77Aec3HmgtWKdETKKfhLT3tqpxHXTppL7pt33n2hIeN/+h5AXZEhFF01m8FpuD+U6ZIx++34nLhQdNN902lj1T77hMwUrsR+ju+lphtIzIdHHNbPzUtLlvBUcFAu/55BCn58LxeBcug0hg4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf70785-cd27-423e-8c20-08dce2b0b80a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 07:06:21.3922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KE9lGyyYlqAk8a1un8f6KpQNlOUU6YtBU1RoeXDDk0iq+Lx3Ah2XtdKbPNTGRCKcr/EEny0L783vJKnu0gF9Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4889
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_06,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2410020050
X-Proofpoint-ORIG-GUID: TJKCMTeInEpQUyvJmgiOd7P8vOuaCZ_Q
X-Proofpoint-GUID: TJKCMTeInEpQUyvJmgiOd7P8vOuaCZ_Q

On 02/10/2024 02:01, Darrick J. Wong wrote:
> On Tue, Oct 01, 2024 at 11:28:49AM -0700, Catherine Hoang wrote:
>> Enable testing write behavior with the per-io RWF_ATOMIC flag.
>>
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> 
> Looks ok, though are there testcases for us to look at as well?

Since we are now decoupling forcealign from atomic writes, those test 
cases will require some rewriting.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> 
> --D
> 
>> ---
>>   include/linux.h   | 5 +++++
>>   io/pwrite.c       | 8 ++++++--
>>   man/man8/xfs_io.8 | 8 +++++++-
>>   3 files changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux.h b/include/linux.h
>> index a13072d2..e9eb7bfb 100644
>> --- a/include/linux.h
>> +++ b/include/linux.h
>> @@ -231,6 +231,11 @@ struct fsxattr {
>>   #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
>>   #endif
>>   
>> +/* Atomic Write */
>> +#ifndef RWF_ATOMIC
>> +#define RWF_ATOMIC	((__kernel_rwf_t)0x00000040)
>> +#endif
>> +
>>   /*
>>    * Reminder: anything added to this file will be compiled into downstream
>>    * userspace projects!
>> diff --git a/io/pwrite.c b/io/pwrite.c
>> index a88cecc7..fab59be4 100644
>> --- a/io/pwrite.c
>> +++ b/io/pwrite.c
>> @@ -44,6 +44,7 @@ pwrite_help(void)
>>   #ifdef HAVE_PWRITEV2
>>   " -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
>>   " -D   -- Perform the pwritev2() with RWF_DSYNC\n"
>> +" -A   -- Perform the pwritev2() with RWF_ATOMIC\n"
>>   #endif
>>   "\n"));
>>   }
>> @@ -284,7 +285,7 @@ pwrite_f(
>>   	init_cvtnum(&fsblocksize, &fssectsize);
>>   	bsize = fsblocksize;
>>   
>> -	while ((c = getopt(argc, argv, "b:BCdDf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
>> +	while ((c = getopt(argc, argv, "Ab:BCdDf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
>>   		switch (c) {
>>   		case 'b':
>>   			tmp = cvtnum(fsblocksize, fssectsize, optarg);
>> @@ -324,6 +325,9 @@ pwrite_f(
>>   		case 'D':
>>   			pwritev2_flags |= RWF_DSYNC;
>>   			break;
>> +		case 'A':
>> +			pwritev2_flags |= RWF_ATOMIC;
>> +			break;
>>   #endif
>>   		case 's':
>>   			skip = cvtnum(fsblocksize, fssectsize, optarg);
>> @@ -476,7 +480,7 @@ pwrite_init(void)
>>   	pwrite_cmd.argmax = -1;
>>   	pwrite_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>>   	pwrite_cmd.args =
>> -_("[-i infile [-qdDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
>> +_("[-i infile [-qAdDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
>>   	pwrite_cmd.oneline =
>>   		_("writes a number of bytes at a specified offset");
>>   	pwrite_cmd.help = pwrite_help;
>> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
>> index 303c6447..1e790139 100644
>> --- a/man/man8/xfs_io.8
>> +++ b/man/man8/xfs_io.8
>> @@ -244,7 +244,7 @@ See the
>>   .B pread
>>   command.
>>   .TP
>> -.BI "pwrite [ \-i " file " ] [ \-qdDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
>> +.BI "pwrite [ \-i " file " ] [ \-qAdDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
>>   Writes a range of bytes in a specified blocksize from the given
>>   .IR offset .
>>   The bytes written can be either a set pattern or read in from another
>> @@ -281,6 +281,12 @@ Perform the
>>   call with
>>   .IR RWF_DSYNC .
>>   .TP
>> +.B \-A
>> +Perform the
>> +.BR pwritev2 (2)
>> +call with
>> +.IR RWF_ATOMIC .
>> +.TP
>>   .B \-O
>>   perform pwrite once and return the (maybe partial) bytes written.
>>   .TP
>> -- 
>> 2.34.1
>>
>>

