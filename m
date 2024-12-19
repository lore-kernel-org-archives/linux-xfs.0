Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6DE2BAEC
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 10:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734605319; cv=fail; b=CC5QarL8Sj0/V6gD3DM2n/VULspgTeROrmYzWTn/opTC6nZD1DvGH7DxdEkK8/H8N3bXPkyPHYenoP7sXm2UIAMfqQbnbUwV80HmbZnYKF9tn1Ob1MGxRjDj0EcXTcW9sG+u+DiOgz1MMnItGBq/deBOS6WupqY9JM3JSz/Czhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734605319; c=relaxed/simple;
	bh=TkXhzKvPEQ5UrBL9+YQRkdu8C79+9kXKv/KbQLUvijM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EaVN7I+JmXivXdPHQczMpADHeA26kl9EGAxwP9DOjnrPHh3PfOT+3l4z0u2mZPb51PziIj3UlAC4u+agxxSrdGfWx2NFIUqn9aCOy8I6U4f+BEDCiJch1Lf7hw2qkhs4J4x7kl+WgbW4RSq2zNN/D1LBvynXstxb9tWoIQMk9oY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lhjAb0ne; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aq8dWI/m; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lhjAb0ne";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aq8dWI/m"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BJ1fsW6012304
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 10:48:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=J/RMpMBBVKInxpa6sCwsapetnFRfdLqNsxCsbLP5Qzg=; b=
	lhjAb0ne2YH/y5TXtYOd5Xdxzf9iDBAPmdZ+cA+RHrujzsXbbfLZCzF2obgFN5Uo
	pdXVZ+jsulvl+Tqs9a3IgJ5sfI/rw3XktI7hW9Ou5x1W5Dip/WBK/1m2pWdqZCbH
	0D6VSxyqZzF/kCa/yRwtxUyTetQ3e7S26Ebj8xwVRifQn2+t2Qua+8hvaPr6Mhiy
	SSVtq+8+yrpWkV2ZBUn9xZteGzwz6BUkucMn+WNh4kLqPr1I/9ZR6B7JqOeiwot8
	Y+gRkKGtr4yLOWO+nzAk4IbZrBbZTreeqowvz+ohKbuwB5zBWt+3I8ffuoWPWDcR
	xcV7zslc2IaPxge+EBgpSA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0m0aw9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 10:48:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BJAGkZh035705
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 10:48:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fb1bj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 10:48:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PsUMoxWNbo7l6a4BxntQhLJhzp03r4xw+14sJmVhM259vE/WzYNYGLYbG7Z0KUS8+A9jT4Ie0IVKTE1EMNOR5U39+csf7dHR/orASNYMSpHsLXsxjI1GOlpnfomD66t/ZrMNDXjjeL4HPPqkH4sRXlxDaghOgYC/dt/iM6/12914IKMonJEiWOx0xKlL4OEyhs33FENbDsncMd42FE2wEBZ7j1U2p1aoGs1YIvkqxsC2fcS7eGw7hXJv7Po4dYZImglK58Jf74NmWiE3oxyTupouC3RV3RPv9C+5wZiupNBrwMIjG17J1L7soilfAOpLanTOGXy/Xxp/wBIuqQirCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/RMpMBBVKInxpa6sCwsapetnFRfdLqNsxCsbLP5Qzg=;
 b=KBiscLI73s74Rg4xZ/jSz7xA23IUkUC7T2N/RJgeyEzFcYX60o7wy8B1X8Wal/6tMdh9qFDB7G9BL77LAArSYnJclMucUIepNd6IG80oP0Rg9W7UTf939jScKRZAs8gSiPaYrpn4ys+w/xmbiQJubbqHBlPjAMjJJN/O7rstTX3OchZx9KAyV6FV0DtVP60rUPuOU0RBkahuJLfpobekedZMNrJyIeDx9dzlog4GVeDDeXrH+XNZaKkDd5Vduv1x/mAqX2Lgf9MyxSto+ALiVIVR7m4V+u6sXQ0oNMkzMXOoSaq/fhzJ6nN4XvS3XwWmqnEemNF7LjHjBujEUoih/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/RMpMBBVKInxpa6sCwsapetnFRfdLqNsxCsbLP5Qzg=;
 b=aq8dWI/m/28vZLEXaa9JcTUQMOD2GDJZNv95DD9vZSv8CtrZooSokNa7oNs5ueMHzBImAjkz58KQUe8YFMfH0SoBITu27Gv2Xcr81RDDtjsGJKHd/C6AYxe5bwHCU3DONxg5uvNRVUruqNi6WAqn8COlvJhXDrbzM78oFzFWm50=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8006.namprd10.prod.outlook.com (2603:10b6:8:1f5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Thu, 19 Dec
 2024 10:48:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8272.005; Thu, 19 Dec 2024
 10:48:28 +0000
Message-ID: <51981220-c246-421b-90b3-0b467a91c5cc@oracle.com>
Date: Thu, 19 Dec 2024 10:48:28 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: add a test for atomic writes
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org
References: <20241217020828.28976-1-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241217020828.28976-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0027.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8006:EE_
X-MS-Office365-Filtering-Correlation-Id: b6cdab91-37ed-4066-f9d3-08dd201aab9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZExENDUycm1MU2RyZXZjdnJYL3U4SDdjc2tBTDR0a21GaDFtdXNXdWtlejlP?=
 =?utf-8?B?bUdoSVA4elU5bnRrVnU1Ymo2TUk1MktoM01vVnF4dy9zeEEzQWdNTVZJWUp0?=
 =?utf-8?B?aGJhcEZSSVBrWWtQaFRHNXdPVGlGTHp2cEhSUHo1ZCt4NXc1REo4c1RWazF4?=
 =?utf-8?B?ZjJ2WnZIZno4VUkrSEdWTnE3RWdzZm4ySjRDN1JZOVdkbkNYOWJZWEt6R1FG?=
 =?utf-8?B?RXAxVERvV1gzSWRFcFN1RUYrTGVpRXNLVjc4QlJZWWNvYU82U3JPVXNLSklm?=
 =?utf-8?B?VWhoVkZGa0JaNVFzdHNhUTZNQXR1aWk4RDZ4dnJTc0NaMy9ORzVBRTNKdUxO?=
 =?utf-8?B?OEo2Vml2bjcrYTdrRCtmQkNHRkRUNTFvYktMR01rMWkrTlFOeVNCU1R2WSth?=
 =?utf-8?B?VUw0eFZETWJGSm9RS3h1ekZDcEhTT04wYzNSZmVadlBiSG9hL3Z5YmxjMExt?=
 =?utf-8?B?VEcrWHpmQzYvQlFmNDJXdmQxNWpWdm40Q0hlbGw2NzhEaTRaRGIzczVQRXph?=
 =?utf-8?B?K2tDczkrOVc4NmxYWnl2NHBObGd4NE5sQ3RXRmt3TVFYV25WenAyMGpYV0pN?=
 =?utf-8?B?V2tXUUhZUWJDVWxydi96MS90VzNDRi93Mm1NY0pRZXdpektYU0szZjRYWUlu?=
 =?utf-8?B?Yk55bHc2b1RFVWF3MkdJd2ZsSG9PeXV4QnVCNWZqajJrUFpRcDJvUkpneXNa?=
 =?utf-8?B?NS9uZ3RGVGVhUStPSmFiRDZCMEJLaUJGWS8wcmFETFNzaTRHcnI2MVlXNmZR?=
 =?utf-8?B?N2laV2VTYko4ektxT3ZpblYrTWtOQjR6RVJ2WWQ5MkNJS1FoVlhUTXFJYlAr?=
 =?utf-8?B?T2p2cDBZK2x1ZlJOOUJjcXF4Q3p4ZUgza0Y1dkV4cGNHVHAvU2JBNTRLWUFv?=
 =?utf-8?B?c05KTEllTlhGNlNJS202YnJYZjFpM3BQZUgzb3Q5S3hXZnZjaTdsY3Ewenhx?=
 =?utf-8?B?cXppeHJ3bmtvNTkrdnlzS1BoYTZiWnRpZmJpQ3VwR2hpRmo1OFh0WDJWcjVZ?=
 =?utf-8?B?ZGlqRFVibzJHZElJdnVDRHMvbXhVaEk4Rzl6MmJqQ1JJdUZteUxQejllU2Q5?=
 =?utf-8?B?eXY0Qk5tSVlnY2UvbENzR1c0SjRGcGZDUk9YUzRCbUNXQkl1aU1rcDVUdmpx?=
 =?utf-8?B?TmY5eHRkVXhCZGlxS0o1QWx4YTAwdWxFWVJwdk9Hb1NUNzRucUVxSkNiMVNY?=
 =?utf-8?B?dndsZVlQeWgwSWRObVlvbExXOThkT0dLeUNwMjhjQTc2bjF2M3VNTHdEczRx?=
 =?utf-8?B?Q2xDblJUaHJVb29OK01Nc2ZKUkk4Y3kraHJRN3JycmZudEJqSnZlT2hIZXZC?=
 =?utf-8?B?bXMzcDRidU1oajBLNXIxSWl6a3hRN25wUGJIUTl5aEVUaENXUHlUWUF5cG54?=
 =?utf-8?B?Ty9zMXo5dFM5amhhNy9YKzJrTUdTL1lPWCs1SERFSG1tK0pIUldnYWxXKzY5?=
 =?utf-8?B?SG9YSTVkWHIwV2FCd2g2ZElJdXhMMWhTYStmZGdwdzA4VTlabkJBY01IeTVW?=
 =?utf-8?B?dDZrQmw5MVFnOGxWZDBublFRUlY1R2RsVkJrejBLVm9qYjdJVFRkR0x0azM2?=
 =?utf-8?B?MGJ3a0tLcFhGUXNySWh4N05jT1dJbTJKWkgvcHlLZUc4UkQ2c1BUZ2FCNjcy?=
 =?utf-8?B?b25vajV0U29DMzlCUktsZ2lkeEFhSGtqOWpjdTl6L0xuOGRvRjBFaWxDZkg2?=
 =?utf-8?B?UklNL0pkQVo5YXlNaFdOZUIyMUdmSlpJNWJKZFp1VWMrNDNKSWhIcTh3WFJi?=
 =?utf-8?B?U3ptWGVwVzE4UkFiT3QwVXhxVWYwQ3ZZOW0xNzd3Y3BDb0wvaFVUTDQ2My9G?=
 =?utf-8?B?WUhRM2d1dUs2Y2QzQ0xmT0xNLzgvL1J4dmNFQzlhT0ZxSXg0bHNiVFFsT0NB?=
 =?utf-8?Q?TeR66U7pNY23p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akRTTHh1dmMwVWhQVkNDc2VaUERQcW1aZUFuWDNRbVZnOW81NWtKR2Uwblo1?=
 =?utf-8?B?a3VRMWFLbUpKVUJuZDh3LzBCYXlLTitsc2hWNVA5S1k3dDBkOHNtVnJYejEx?=
 =?utf-8?B?eXphWC9ESmdmUlBjb2xzMWVOOE1DWVV4QkpxcFZxcWJSc3pVdkFMOU5tSGwv?=
 =?utf-8?B?am1LRzNSaWg4V1VHRSs2VjFWREZkOVdtSmY2S0JqUWhIRG1WVDRwbHl5b21x?=
 =?utf-8?B?SDFvZ1NnQjZVWFpEUXhhOGNYbXh1QXBvazhBZUFlaGVDN3R3SldsS0hoTW9N?=
 =?utf-8?B?NjcwV3hhMlBjYkgwL0loS2hTcmxOZ3BkbFIxQUdETHA4dmV4L29wa0tSN2xq?=
 =?utf-8?B?dU14L1l2eDgxc1dITjlIeEpmVWdZazlCejRQcmVpbXZMMnpOalRvdUoyN2E3?=
 =?utf-8?B?b3FtUlBQZXZJalBIMGxibFNYeFJRTXpKU01EUHQvWGx5TERzeVRDakZWd1pC?=
 =?utf-8?B?WDkyNFNCT09ZQmRKWi95Ym1SREtqWUhlWk9SeHk0VEZuVG5jTEtObVRJZW0w?=
 =?utf-8?B?Y2haaVh2RmYwYTVuTTQ2ZGtXbU5QVXQzVUk4WDROZ3c1cDdJM05mZXZBbHg5?=
 =?utf-8?B?QU5FdSt5VmthWjl1MWVzSHcrclVZejdqMWNvVEcvVmQ4UUtwZ2I5K1VNQ1VV?=
 =?utf-8?B?QTYzVXRrVUlKYm9IakRCNytVYzZONTJGMkZidGdHNUtzWWpkZWtoNkZUTVdV?=
 =?utf-8?B?alVIcCtKbzdlTW1aVkRIemVmVkRIVkZRNUV2NDduVmY0MkphMVNDSVFLbGVO?=
 =?utf-8?B?MklubldqV1JaN1YrRmRhWU9lQWFzNk90b290OERGLy9OdWM5ODFDb1Q5S09y?=
 =?utf-8?B?YUY5ZXJnRk1KVUl0eWprZWIvN0NpYnV1d2NxU0ZrUml6ZktRUVh6bHYzc1hy?=
 =?utf-8?B?NjdHOGUxUzJWaXNBTzVJQ0NJUzl4Q1dNVElTTVpIK1Nja1kvNzRPWEdNMFZU?=
 =?utf-8?B?LzlEc25YNDlsb0xienZjd3Rza1MvZHROa3FFRnF0WlFBQmJQQVhSdWRrKzNz?=
 =?utf-8?B?NnAwZjF0a0p2Nlpvelhrei9ZS3o4b0c2NTlIVEZ1VTNqUUxYRXZkQ1U4WmUr?=
 =?utf-8?B?VXRpd1dnaHNyNlJKRjNJMkRTNE9GcDEzdzRKYm53d2g4SzREdGxqbGs1Yjdh?=
 =?utf-8?B?bnlUYjZZUkNJeFROdnoxVVBLTlp1Y20zYkxxL2dIWXYxUC9wOGg5QjNDSUEr?=
 =?utf-8?B?UGNSZ1RTUmlhQlN6akdGVlRPNG1jbkMvMDNsb2tsc3dUQTkvT241cXZVajVC?=
 =?utf-8?B?L1kwWVBmSFU5T2VleDFLRDByWHF3dTh1N05ZNTlkbzRXNEt2cmMxVng2eDhZ?=
 =?utf-8?B?eWNqZzRKYS9qMitMTEJ3bW5EZWFMOHFUQmRBQUpYQjQ0VDhSblNxWFhObVI4?=
 =?utf-8?B?QmIxdWRmbklCZURqSTVETFBNaG5kOWI1ODBweEJaa2VFb3luTERlTml0TXhv?=
 =?utf-8?B?UHloMHZBNkZiZVJCMnNLWTU5MHRPa0FSMURKNW8xWHZ6dWh4ekcySnprWUdU?=
 =?utf-8?B?RlZwU3ZTbFZyYy9UOU5UQm9Lb0hUNzd4UEozVVh1TW9GRXFhUzVIRE9zWEl2?=
 =?utf-8?B?K1pxUW9uZjgvbVcxRUZrL0lDMjhxQlF0aThMcmFGZ3kvTytwRlVwOUZGdWUr?=
 =?utf-8?B?YXJJODlPdXJkczB3TDhLaUJmQ3hJQW14dXdDZm4wV0h6alAvSytVaDlCcHFj?=
 =?utf-8?B?Z0x5aEN6OWhKUEJFcit1K2VCdExES0R2Q1lFbmYvU2paU2duTXAyNjBQamtN?=
 =?utf-8?B?THdnc0xBMnU4WVJBTzEreGtHYXlFUHYxTnJlbEFHZXF6SVZOYmtXL3RBNG9Q?=
 =?utf-8?B?TG11b0Q1U2JJc1F4TnVkNWVEZjVNYWxwRmZZc2lSWDRDZnZzcWovbWVmUEwx?=
 =?utf-8?B?NFBWYTdVUjZvOFZSTHR1c2dOazRpNEZUOUJNU1hxeGJQQ08yaUNSOHkrZW14?=
 =?utf-8?B?OUlLSEtnUEZ3em5RME9Nb3psTnhXbEFSV1pCQkVOTWFBWWlJM0x2WVBGYWlT?=
 =?utf-8?B?ZUxJdy80ZXpSNERweTVtVjNURnJoSTJDeWQyZ0hQTHczaGJrWUxsbDBKdlZ4?=
 =?utf-8?B?RGhWYjBmR2NCUXV1VzVzUERHakpOcWxRblh2RW1sWHd6T0dWSC9hQTI3Zno3?=
 =?utf-8?B?RmRJeCtJeDlQZEQyUENSSWtQTGpMNGtiSHRJUnZPM0lOVTJ1NTFrMHJkbFNX?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7mVD5a0MUuhAJAOtvudHlLHIqa9SFSimdJxn+pswKaKt3GIcxzh69P6iZia3qRI9mlK6zLU0esa7EHkPuHKTT3qiG1gZ1XDE2q1BEfw+LbU5FVLVg58hhd5sVZJW6QrYO7bHgYJPhWLaFhGOSD2hB3QCzt7Pe5V06EupiTJUMJIuj6XnmpyEc2WpTyeh03jfjTxE7TVGro/UJhmRQ3hdRXT5X32+FNS0o3ZHXpal7Z6uDQ0ZzF+/WLqfTX2rYuRZ7oM1jdVclQgFL08dWZcRNSwdjx1D0O5bx77UcZFAKDvXUyrgwS1A2pKAw3OzwxNyluXG2TGBxmPILEmJ8JzQeiKKKLMdqV0xv63nnn64M9qPwWdB04AZlVt6gm9nxSK3CJG5u3djVcL5jbU55aaJG1GF4VWqmyfFAahQE262iIWlfI9lggrvIqArYHpepEUVzZVkV73DD78CEk8kv8vQWcx9dG4MFNuhefSx/lEIyRsnTpFRk9w/8MNKd/mSPepXFPgpk7A2v0GS3zFOZTz3JyYoR9DxjOARCjIvrl41QLrrbKzOD6KLttniCmwabximhv50X43T8FDg5ecvJ2RdZCOB8xeczEj3oz9GxUYVM0o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6cdab91-37ed-4066-f9d3-08dd201aab9d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2024 10:48:27.9329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +OzWTA5c8dVcz1sE6CywmBAkXBa5hldxdQKhHoGjddhYA5YY7c8TZL81O8ZU15phyDvW1uOBzhzi+S2EZd3ruQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8006
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-19_04,2024-12-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412190087
X-Proofpoint-GUID: GvlZnf-G3mUpo69vBuOc-A0d7v0TKMqn
X-Proofpoint-ORIG-GUID: GvlZnf-G3mUpo69vBuOc-A0d7v0TKMqn

On 17/12/2024 02:08, Catherine Hoang wrote:
> Add a test to validate the new atomic writes feature.

Generally this look ok, just a couple of comments/questions, below.

Thanks,
John

> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>   common/rc         | 14 ++++++++
>   tests/xfs/611     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/611.out |  2 ++
>   3 files changed, 97 insertions(+)
>   create mode 100755 tests/xfs/611
>   create mode 100644 tests/xfs/611.out
> 
> diff --git a/common/rc b/common/rc
> index 2ee46e51..b9da749e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5148,6 +5148,20 @@ _require_scratch_btime()
>   	_scratch_unmount
>   }
>   
> +_require_scratch_write_atomic()
> +{
> +	_require_scratch
> +	_scratch_mkfs > /dev/null 2>&1
> +	_scratch_mount
> +
> +	export STATX_WRITE_ATOMIC=0x10000
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_MNT \
> +		| grep atomic >>$seqres.full 2>&1 || \
> +		_notrun "write atomic not supported by this filesystem"
> +
> +	_scratch_unmount
> +}
> +
>   _require_inode_limits()
>   {
>   	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> diff --git a/tests/xfs/611 b/tests/xfs/611
> new file mode 100755
> index 00000000..a26ec143
> --- /dev/null
> +++ b/tests/xfs/611
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 611
> +#
> +# Validate atomic write support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_write_atomic
> +
> +test_atomic_writes()
> +{
> +    local bsize=$1
> +
> +    _scratch_mkfs_xfs -b size=$bsize >> $seqres.full

bsize (bdev max) can be upto 0.5M - are we really possibly testing FS 
blocksize == 0.5M?

Apart from that, it would be nice if we fixed FS blocksize at 4K or 64K, 
and fed bdev min/max and ensured that we can only support atomic writes 
for bdev min <= fs blocksize <= bdev max. But maybe what you are doing 
is ok.

> +    _scratch_mount
> +    _xfs_force_bdev data $SCRATCH_MNT
> +
> +    testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    file_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_unit_min | cut -d ' ' -f 3)
> +    file_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_unit_max | cut -d ' ' -f 3)
> +    file_max_segments=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_segments_max | cut -d ' ' -f 3)
> +
> +    # Check that atomic min/max = FS block size

Hopefully we can have max > FS block size soon, but I am not sure how 
.... so it's hard to consider now how the test could be expanded to 
cover that.

> +    test $file_min_write -eq $bsize || \
> +        echo "atomic write min $file_min_write, should be fs block size $bsize"
> +    test $file_min_write -eq $bsize || \
> +        echo "atomic write max $file_max_write, should be fs block size $bsize"
> +    test $file_max_segments -eq 1 || \
> +        echo "atomic write max segments $file_max_segments, should be 1"
> +
> +    # Check that we can perform an atomic write of len = FS block size
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
> +
> +    # Check that we can perform an atomic write on an unwritten block
> +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D $bsize $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
> +
> +    # Check that we can perform an atomic write on a sparse hole
> +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
> +
> +    # Reject atomic write if len is out of bounds
> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
> +        echo "atomic write len=$((bsize - 1)) should fail"
> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
> +        echo "atomic write len=$((bsize + 1)) should fail"
> +
> +    _scratch_unmount
> +}
> +
> +bdev_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV | \
> +    grep atomic_write_unit_min | cut -d ' ' -f 3)
> +bdev_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV | \
> +    grep atomic_write_unit_max | cut -d ' ' -f 3)
> +
> +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> +    _scratch_mkfs_xfs_supported -b size=$bsize >> $seqres.full 2>&1 && \
> +        test_atomic_writes $bsize
> +done;
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/611.out b/tests/xfs/611.out
> new file mode 100644
> index 00000000..b8a44164
> --- /dev/null
> +++ b/tests/xfs/611.out
> @@ -0,0 +1,2 @@
> +QA output created by 611
> +Silence is golden

