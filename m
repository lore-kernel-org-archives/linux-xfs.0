Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819DB277808;
	Wed, 14 May 2025 13:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747228493; cv=fail; b=mGr9CQ8dcpFIgOsdu622W1a1l8b2ozaMiet40oTDRZIxaiqPXU5ZpauVNOVGzBuIMR7/VpZy4NxmFLOtWlVHek7cDqw+ZrlJ27u8uyDa7ITIpeuHTibc33R/XpGJ6tIW6bw5usw+e87kHTCYzkHfz/AErDwysDoUBQ9xJpQklWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747228493; c=relaxed/simple;
	bh=hEL40VjO4ya5+o26QMkDgA82K8qIDt7fFqsUonU2O84=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GjwZA99hcF5LLlHdUMWP+CkILsSk9NjKgqGrji4LdWZ6FIvjwjL5g6UZLmVjTlJtvwAqeOh6eRmdO9nmrWzLuPXYXfDMyuO30ikGZRFfvxhL7urzQT/xHcfTjhN1bB9VzaSGupETSpVAav0B8EYgMrPfvk7puAr7+++yvTue1z8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ffsZPpsB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sncRR/XS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ffsZPpsB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sncRR/XS"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54ED9MJ0024979;
	Wed, 14 May 2025 13:14:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cwY6npaq3OfVWbJVcrHr/LC2VabQ8PHGUtVm5jiAi7M=; b=
	ffsZPpsBCvGQTgag5m2OaOzBbmthhfWBZIcFn5vMpJ1vjmb+vVhGsaC2bwotCWqM
	pbQaWpVFxPo00z1MByY1KcrHpBbCX31gqTj6OHSAKjuiakznaJ84EW56Dd7FKYLh
	m7wVILiFpNc4w4QaJBEjzLuWb3gp1oFY+l6LBdLVN4T7uOUuoIEtU/LKVUZlhGms
	VeuwYUs57Lt2mdSuGNF0H5omLZw+/iLnLrvX2Zp/xDWnPb2JIY8M4PIuUBtvg58C
	2leL96p+pIfPc7V7zqizqfPbmif+5Ql/8IHy8zH37G4QD+ouqDNT9RXJIiAtk7VV
	T51g514FZuQZXnCO3uAa7w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcm1kcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:14:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EBkng2016906;
	Wed, 14 May 2025 13:14:47 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazlp17012052.outbound.protection.outlook.com [40.93.20.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mc33e168-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:14:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hxwbls6ZhHPzWFcM2H182nrU+rpAhLU2CWiOhtYDHM0sIajvCSqgOKLUoVj09SOd+bW2t9fD2wkkehEyOGEmASc3zJcLwYyiLAP0zGWj/mPTlnVIcY19r67+xspwPbm+ZHO3psbW2gzeUu4iONasCbwWYj54lLGUaKfJEKLH8sWFlCXFLty8wQ8pHo6/9XRUus+uEjTwAt2WJ3v+QOfmAzwZP/lYiio69D3bhu8zuTShAwBZW/mio+pT8ROJtvK771x+QFRUHMA6unwE2r1ohtpBMXdlgFx/mv7TWwJjIW1fDBA4MXdNxtuXJQWDa/eevjVYIBpg5VMs59pjpGxeRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwY6npaq3OfVWbJVcrHr/LC2VabQ8PHGUtVm5jiAi7M=;
 b=ASoBfmRBjQ6YcUJrUvQ3oL5Pxt5CIMvkHdyop27+8KMgbfisYGm+NBrZEJU11G4ZUL/Sdk4chrwBRTvYWXoYpTmfR7MiUuw1QjmKMCQSRWUDOpGDU8czTFcbAt1DZeZcOm/ayg5SGqtP/AS53Gcoe+OOqTPwrRrHxmOQT8XzSx+Y6esXPHZHzS4dRPESKxf2nWRyxuvyDaTx+31E7uVWOIYZLCv6v3g4FDa1JHbDKygbYmUl4ffbNMu+RHvgzTu5fXDfP++bh2c+aO5XYYBZC500nojcd4jTB9605HtiZZNqT2q+tzFG7fvqtde2AcJc5ttQMFwlswmRwDK10F84Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwY6npaq3OfVWbJVcrHr/LC2VabQ8PHGUtVm5jiAi7M=;
 b=sncRR/XSWJPy1UDHJOVWGb1VVSvUZ8/yc9UqPSuRu8xDU/zLcqgMHiEwWnEjhJnVuTQ2fY5GM5rJmpVUFnwAYqCv3aLtmIK6G+ZhLrmzCo8RBTDH+ieRoiEVNl51Tvq5ag0u7dUaRa248wu+BzW7wPXL5eBkYIABhFeJHkOioiY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY5PR10MB6215.namprd10.prod.outlook.com (2603:10b6:930:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.22; Wed, 14 May
 2025 13:14:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 13:14:44 +0000
Message-ID: <11ebe67c-6f5c-44b8-90e7-93ede9810a4e@oracle.com>
Date: Wed, 14 May 2025 14:14:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] common/atomicwrites: fix
 _require_scratch_write_atomic
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-6-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250514002915.13794-6-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0058.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY5PR10MB6215:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d3dd664-cac6-46cc-9173-08dd92e94b47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1Yra1FlcHRuWU10RHVFYVdUR3VzWThodFYxTUgrV1lEOERnNWtiODVsYjVo?=
 =?utf-8?B?UHVYcyt4dzBxWW8xa1Y4VkhFTm5BeW45MUVKYjVWNWpadGNseUNRc0RBK3Iv?=
 =?utf-8?B?ZVY4bGxCRGFDcDJMMXRtYkp2YmtJRkFyZHF6Uktxd1hIaEU2ZW5GMHorRkFl?=
 =?utf-8?B?N0ExVzk4and5aUZ1U2ZuTjBtYmhGTHJmcGZ2R3E0RVNwclpzL3N4ZlY4c1Nw?=
 =?utf-8?B?cTdrTTlyVzlvUmlLcHM4ZGtZdE5JNmJwOXI3a3lOZUxGM2dHWEcwa1pEWkV2?=
 =?utf-8?B?S3VOM0pMT3U5QzF3S3hCZUxZTHZwK2lTV3ordTJGc3B1RjVKREV3bjc4QTNL?=
 =?utf-8?B?WXd1Rmp3cHh0SzNaY3MzZjVnYW1mYmFVWk5pUEJKQXdESGhBR3JUTUZLSVZt?=
 =?utf-8?B?eFV3RU5jMXQrZFZ1TEJFbC85azh4cVdodHlLM2YwM08rL1FXd3ExMVB2OGhI?=
 =?utf-8?B?bkViWFhTWUFubUltWGkybE8wcC9zUno4TkVGcGFTbEVKN3ZLWk5MdTc1ZW9p?=
 =?utf-8?B?QnNaOGxmU0xUeVc1dis1dEEvRmZjUGxmSEEyTHEzNm5WTklaRTYvYXF5SHh2?=
 =?utf-8?B?a3JqWjNITmJ2NXFHbkZWZG1CNVVJUlRvalNBaVBuSWp5M09FOHRDUUxhb2Q0?=
 =?utf-8?B?azVKTmlyQzlEWDc5bkFOaFNwUFlNanI0N3NZRjBxYzF3RGxkdGdPTTZXYnJW?=
 =?utf-8?B?dWtxeDdGcUFGMnpUeDROWHl0c1BaZUkrdHRNaWFHTmlzc2F6b3o4ODJ1Rjc2?=
 =?utf-8?B?bjZYZWZLdldzMVg4WFhUT3ZGSHhlN045Mnh6ejV4VUVaVmJZK2R4ZVJ1eDIw?=
 =?utf-8?B?RjhEdklpZm9Lb1hvSnFUaEhxeWVnaHBIczJ5WDN4bTNwaGlUK1ZoSEo5d0tT?=
 =?utf-8?B?WDdvREZVWU5qTkVJRnRSRG03aFkyZEx6WVFYSEZTaXloc1RNVnp5STNoY1NZ?=
 =?utf-8?B?Rktla1kwR2RXZmhVc1lZZjMwWHRGYVRlZW0rYnBwbWI3U2MxdXphb25Wcml5?=
 =?utf-8?B?NGFsWGZMVzB0MnUxK2JBeDE1WUg2alNjL2lLYjE2OW9uU3F5a1B3T1hwdVF5?=
 =?utf-8?B?R09aNVppUXZ1UnV3WHZtclRyZmpobTFHYWN2THRnM0ZZMkl0aEVnN015M1RN?=
 =?utf-8?B?WkV0dzM0c3cxNkV1djhFTmJUWTZvTmkrVUVpK1ZZUHVkZjdzaU8yc0RIRloy?=
 =?utf-8?B?VGI3T3RTWDZTVll3c2dhbzZ1bWhQZzk0cnZldkk5UTR3VWdMWXVHK0hHYTZQ?=
 =?utf-8?B?eWNhU2ZwZzM0Rkg5OGJlU2Y4eWdiYWI4YzRtYWM1QlJKVHZjT3RmRE9zQVZE?=
 =?utf-8?B?NVNMS2VNR21HcXhWQnlJekkzZ3hVM1pWLzBEYnlMT1h1cFRMc0hHZnBsUTUx?=
 =?utf-8?B?TEFtK0NpR3NBRkprS3ArUDVpQXFpWmVGNzdCVnFMQk9BNkhlNjJ6M0VzMHBZ?=
 =?utf-8?B?SmZtci9IMU80ZjFubDh4MG9QUXV4OFlvdjF6a2lCdGFoTkcwcmpqdDNoZUxB?=
 =?utf-8?B?czRuV2NSN1hQYSsvMS9mRmdkVzRGSDZ1RUhTOXBzOHdZYUxWbjUyai9lV01x?=
 =?utf-8?B?OTZVS1lkNHJhc2cvNWdaSEJ0OWh5Q1NIdUl3WDFwZHFKMzV4Tk1lZWErRGVl?=
 =?utf-8?B?YzRQQlUzZUM4a05OTDFJU1owenF6YjhBS1JOWTRLTUtlQ3BjcGkxa1J1VUFs?=
 =?utf-8?B?Q0Uzc2RQWjRnNDVWYWJBMmVVd3JQMWlEbG5hWkFVT3did3M2dU9Wa3BoMmth?=
 =?utf-8?B?RkROWFFSTkRoa0U1bm5yM1pWd2pLSHRTQkpOSGllKzFOS2VUU3NlYzFJdTJ4?=
 =?utf-8?B?WWhwdHludkJiUEtzekNZQ0JUbTF6d09mWXRLSURIOERzMlZxbzd2NlhBWk0v?=
 =?utf-8?B?aTkxaEI1ZGZ5TjRVNnA4ckFKOXBoUU9qYmZybTRiQlduamxGaS9VeXUyc0lU?=
 =?utf-8?Q?sWXSvDArk5A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnV5bFMwdmJWenJqNU5ZSlAxNGVqajQ1R1NORkE1Mlp2WUZsZWlPcTl6UVFL?=
 =?utf-8?B?N3JDQi85S000MmdJMUo3OUE2RjAyMG53VC9WamJ1WGw0NjQ3aURIdDBzZkE3?=
 =?utf-8?B?UFJwL3pkMVIvWEdaSjJFa3RlQ1pTQzdIRWtXczJmN1JML1B4NmtkdVpYdUhm?=
 =?utf-8?B?eGtBcjR0WmVWWk0zb1pMQnpkcHRkcW1RZkh3UEd2QUc5ZGpObU1UK1pVTDgv?=
 =?utf-8?B?NGcxRXBIWDY3NUw2bW80bnh5aGVxSlhGVnpnOXl1M1VjMkxqcHBhU05KVTBx?=
 =?utf-8?B?TkVFZXRaUGx5bFVXc09ZSlh6bm5vV2JGU3UvS3JuWVlQTkpSa2RvYmU5ejF6?=
 =?utf-8?B?UGpDSnhRZk0yMVp6NGw0ZWJpaU8rdzI4VG9ZRUZNMTc2WGwydHhSVHBVcnUy?=
 =?utf-8?B?MjR1TGZZVkRiUHlmdUJBRVY0Wm1yOEVTSFMzLzZQcDNzVW1yZ0FHWVNxS0VZ?=
 =?utf-8?B?S3FmMm1RcnJBejN5U2VlY0prTDZSUTdLSWdrWi9vMlZVWllRWEtab3VLNGdM?=
 =?utf-8?B?TTBvWEhkcHRrNU9oajFSeDNTOW1uZmVDL0Uzb2dFS21NYng5RFNRb2thcHF6?=
 =?utf-8?B?cTFCaGlCZW1ER05qZHZwbG9weGZvenphZm5tUUZTVmlMWHJsQklWR045RXBQ?=
 =?utf-8?B?SUFjaUxHSVZheW1GdU1KTzUyOGFBMlFDaktsRUNxbzJ2Wi9EWXFYYXNWLzFB?=
 =?utf-8?B?aE1uL1NCRnI0Um83TnZGTmVSN3A0ODFqaStlNldCYzZLSEFpRFFNMzRkc242?=
 =?utf-8?B?U0h4RUNiNlJQT2xwL0p0UUZqaG1CRkFzUmRpVUlJaDYwajJzc2w1U05nZUhR?=
 =?utf-8?B?czNTdlZjc2VxTnJEajBBTU14YTVwV01Pd3Z0cmVBc2lLTTA3dDc1aEZva1h6?=
 =?utf-8?B?THRmVUFBRExBM0RNcjdNcXdxVHJqeGdTMHM4WFdFeTRBSmtkcGtvWWlJd1hJ?=
 =?utf-8?B?QS84ZXVNQm1SSzFqWFgrYUlYcThLREVvZjV2YnhNaDV0aGIzQTVDdUlEK24v?=
 =?utf-8?B?WEo5MFF6bDdkOU9Wbjk3cFFtRzNxc2I4cVBlTVhINXlHOVdWNmlRY0tCaW9Z?=
 =?utf-8?B?SjBJemVJbUx6Q2wvdTBoWVdTZDVmM2h3QXh1dnFIMnBaZ2xrcjBhVWljc3ll?=
 =?utf-8?B?Vi9HZmhhdkRNOHUvd1hUUUNGSGNva0p5cklBSzVtOHI3bTlYbmNSZitpWHAz?=
 =?utf-8?B?TTdmaU9MaG9qT0pvK25DY0ovRndMODVoRlpMcEZLcllGcWYyQmVHQ3E0aFA1?=
 =?utf-8?B?bnc4a1VKSDhxTDd0YmVRUllBMFp6TEFBVWxDdEVIYXJtS2p2dXZwajZ6ZGtu?=
 =?utf-8?B?VnZXZTRXQWhxQ2NXMTgzNU9XT2VvVzBYWmVWNGlWK2RVUWQra2czcWltaWVV?=
 =?utf-8?B?T1V0em16NnhQcStwUkRxM01KRmxPUFdpdkpjTlJKMkduaUg5ZXRKdXVxRlRE?=
 =?utf-8?B?TVlSbEMvYnZ0OTJreG9FN1ltd0pNZGM5dnE1dG5ib205cjFJd0JoN1QzQjZz?=
 =?utf-8?B?UElSSldBWDIwZ29QaHowWGY4UVJqV2VYanBidVlTMEdnWVplOVFadkdRSlht?=
 =?utf-8?B?VFVMQ0o2aStTSjA1NUZZZGpmZHlpQ1BrSjFCWTJTWjVqbm5BTjh3cEV3TllY?=
 =?utf-8?B?SHJiSUFYRXpkQy81UnFrNEdmdzhDbDUzMWFLdXVZOUNzRklTQ2VtWWZjV2Nh?=
 =?utf-8?B?NWo5OVZLbjMraG55dzZ5ME4zbXdGNmgvNll1UHdaZld2eGZ6djlqUmVncklr?=
 =?utf-8?B?MzNhU2M2RlYvTlcxWENQMkYwZ3dWMXBTVytvR092WmdVWnRhMmpmQUx2L24w?=
 =?utf-8?B?N2s4T1lseU5JcnBMSm5RNkxGK3VBQ1VsSVdzV1JKaFlVN1g2SjhRQ21WYzhN?=
 =?utf-8?B?Wm41N21tMDcxamw1NFlQcVltV2p5d1JHY2RxbkNvTDZLNmtQY2tZc1RSTzVD?=
 =?utf-8?B?UTlaYkVmZ0RuclhqcVpIanNVRDcvQ0lzaFA2N2RFSmorWmVWYVVyV21CanNR?=
 =?utf-8?B?WWRBcjJaSXZiQkgwLzZmWjdKWEdVcVoxVHIvajZwS2ozM2NnR2dNK3VLaE5F?=
 =?utf-8?B?YVQ1VStDM2R2bTJ2SzJUQ2pGQzMwcGltYzVmK1hRd2FaQWg5N2ZSZkdnNGkw?=
 =?utf-8?B?YVd2aVFRZEsxaXFFeG0veUE5NGFvL3ptTk12NHoxQzhaUHhINGNLUXJKQUZw?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dfhu3GoGWQC+ohgEr6hS8bD2HrjM1jD70MuPz28yXSeEDS+Vj86wKN7wUBByNwKQerUPmk0/TfOuWLEUuYf7V66ue9GN8YN54PMlW61uf7d84ptFhpFUzGF5sMp9pj7X2+omJHe4fNMYx3Yqb0jtVh9ucEk+ZpXTskgbQPKhSdylaBojhvtlDikWJ+JXqth63OGbIf3v5V57b1nciIAbGwSuEhEhCfW8SeIOGJmqECgaQetLN/aftmuL320JR+BjQHqTEdOhvWMk4VMirWDStfNP9pGs99faYlO5LxQU8Ogt1IErlpwJmQzOy3DBpLkRWIMV1L4UUxSyTNyzCs8Mclnw31gsTrVLCrIsuzG5v42ETa+caBLhJvDXo4cP1SIc3eo1WXVOhqqM3XmX0Z5faUs3FdYoCg//eiu6k/i+nrUu8OSpdGY6okv3rPEuYoSOSbIPMNQGDYIKEhOR1Gxip7wNjF788scEDDkvOn9aEboSHdymewE/x5vLDSlYLJ9SL6WjC2wsDP5vyJBHclj37HUIODWTmIJrDO+UsI+h2h3aPz6Ho1QwIrPlpVFLEtZig698GnXZne9n4RDQg9lKJ5Lti+trCC5OEpzF5GTJlzM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d3dd664-cac6-46cc-9173-08dd92e94b47
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 13:14:44.7899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: byvBK6ypNBXb1o1KQDY1BAqvPr9/JETEEV2ybEE2ywJAEADdrn27OgkKk9y7hAkRLaTb2XJJHXYOKFpA+rkJTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6215
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140116
X-Authority-Analysis: v=2.4 cv=DZAXqutW c=1 sm=1 tr=0 ts=68249749 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=GjJoXmgPIC35NYqHgI8A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13186
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDExNiBTYWx0ZWRfXwLvJKhdBYljR 8SulnSbedY3fRv73i0dSAcmjy6OUpVKjoBsEwaYzysTkLGb2CjWvNoaEQyHfCCoeyq2aHfdC1/N Je7+ryccAtfzCg4TugXSXuw3IMnzUZ9PWchMor1XA8J/s+tKUUK4sv+1OmX1bd+ww2lizIPaMCu
 HM98y7GQNQZTUExcvejmpeaaX3dh0mr302vX0HEaJ34hHOsPMer0Gr6GUXr30muNcBfKCMwbUzO NhVBykrDAHxhDUwfjbgZ6u5KXiCAbRZm8fE1DhZI4ygpAKvE07nabarVW/puSGIJ6oRW6zA8sV5 pYSAV9VON8jEtjPpkCpm2ohNVZEniBvDIzjp1DOxvt4P9rVlUqjUu20lBBuX4DGTuSZtKpRTEOa
 Lrjqw+NWRaOUtdxARrXCX/Ad0STdRXtj4109eyZmxH/D4ZziVhpu89Y0jYFtqCD9BoPusmEf
X-Proofpoint-GUID: o57d5P-60D-QJxxurfk2j1CqCLUUw9gM
X-Proofpoint-ORIG-GUID: o57d5P-60D-QJxxurfk2j1CqCLUUw9gM

On 14/05/2025 01:29, Catherine Hoang wrote:
> From: "Darrick J. Wong"<djwong@kernel.org>
> 
> Fix this function to call _notrun whenever something fails.  If we can't
> figure out the atomic write geometry, then we haven't satisfied the
> preconditions for the test.
> 
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>
> Signed-off-by: Catherine Hoang<catherine.hoang@oracle.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
