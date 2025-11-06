Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA68C1DDC1D
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 08:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762419206; cv=fail; b=IJcX+kJXVKb6WhvfsHLYMGk7+IdEIFFEYoPK8A0OXzvuV3p+dxiMry0WhKakQHDsQd+EG+UhzN87dmtxyB/du4CYYb6Xge3A8JyEvifZvmCQcBbrQFXinTIemxwRVEl9Nr1Yd256bTvbkmAwpPwlhPt7bdVNElPC4hPHApVHaDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762419206; c=relaxed/simple;
	bh=9utJ5CxVu2za0fBldEstW8wd89F1C55z2gQCEueHiQI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RmUwUxB/tz302TmEh2klvsdSUtPQFoe+9cRWsCRGfFnjHwEsGbajspNCyj/ecNeUkjHpjsXXozmOMmW2t9RyHsWb1I5lxKSRQaCWrJT94+XzkrVPkLa7L3VWbx8sDsqAOGCozJBQIQMqLC4lj78NriErlg1ADegLNE0oPXgNzkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iwxw4Ole; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WK73jwU/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iwxw4Ole";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WK73jwU/"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A61CTm7030425;
	Thu, 6 Nov 2025 08:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=v+qkBfGftZsU/oD9hCzzoeHXLl2wuBc1/cvSjE51Wk8=; b=
	iwxw4Ole9CEFVPik+XLzjt3WK9n5brYiASdNE7S7cLL9r6pLyBW1JPXI4L2NJRrF
	yp78mn98cShLoWswgJXLnoVs/GatTVfCv/EBuCs2CACEcosCm3vZ4JQgLFTL+GaC
	PBqAmwGzAd/twp1RqpzGx9L4/hUY6RgMpxUK1erb4GBMo6gcmjIycmM4jcn9w304
	IEDvZ1OfhCW/CGzOiN1IAxfUTWq4K4Llr4jfxK+9ctN9e6sLgEbNYiWllQMgjlSx
	e/HhbSiIil/gEd4KqA+tABjqYqx/R92EllPpZgJjEhnvrUOW+ocpLTx+TnOBrRR1
	isucEPNRgpU9/vXVw1bKDg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8anjhguh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 08:53:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A673bcu035859;
	Thu, 6 Nov 2025 08:53:14 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011056.outbound.protection.outlook.com [40.107.208.56])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nnxr3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 08:53:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AxE8LvFBDv2B2xN6uqhkvlg1nR0xDLJMmYOKx3MrZ1kj3sx3Rl5BJtdr3BFX7PiUec5N44py8m7WmYyQJNlIuj2R3MEXz1qdBo+tMYT+n5kGCTx3PshsK7zMAXlcMRCiyB6ALGlrN6Rlv2fCgGFmkU1A2OKRHuIohPrO2lG/NpHLOM8sU837VoyfhF2gQddokU7LbC92esR35E5zj4RvRjJr4qU6itmYEHYf7WtsbnA1SGxKqa239ZkOJShnEQMCxOhmroQYFkWPgXdddRl3FGURaVAzwmnE3b9F2j6gvGKvzJXF+p78AgaDOF90ibOiEqlzzxlh6qWln9C+DjtSDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+qkBfGftZsU/oD9hCzzoeHXLl2wuBc1/cvSjE51Wk8=;
 b=hjSWfWrnxVVbaCOnOtjT915VcgrMuDoxXULu5TuWThDCUqCqaHVMbKF+oA7RW+mrug5VeEaQEUtS6NB4wGlNJGuMTq0Wjz4PGfdGp57pphTNmAjCuAawvzAHmf2DcI8QwnYj0vbi7MzFkfsdlwQMP7xbVAgk4yFGsFnTKYPslIy7BhQ8ODL58R9+1AfH9r9IjgutUkTLVLjUE4OxLFu18oTrZe+0ol9hJN9lNKikMHgJwPruqd87N95O3fCY1FGkbb31iZhWlQoQ4j273n9fxiWtoUzW3XbJGLsSdI01QBgtBZlTbkJN5CghHr+4+xplx3ljTU5IZC1tnDuRWCysoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+qkBfGftZsU/oD9hCzzoeHXLl2wuBc1/cvSjE51Wk8=;
 b=WK73jwU/X6TLp/UKW+7vog1odhm1awS9N7bJjSu5Ybo+Q9LQBAgMiMefSVSLGSqK+fPrWIuf7yoxY/Rc2dpx9eJIpoX40P5cqg9FZeIZ7nn+0nJaAv7mHswvZgi+PfkOJ1OC6a4A/RSY+07OoFBZRG58dTxrQ/zJaWRH9JX0YTs=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ2PR10MB7857.namprd10.prod.outlook.com (2603:10b6:a03:56f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 08:53:11 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 08:53:05 +0000
Message-ID: <c690eebb-ad51-4fc4-b542-58d0a9265115@oracle.com>
Date: Thu, 6 Nov 2025 08:53:03 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
 <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0570.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::14) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ2PR10MB7857:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a825151-db4d-45bb-638d-08de1d11e689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UFEzYXBPdVpQWS8vQTRPWCthNzRZSnh4K2lWQlhDOFZvdDkrZ1EyS3k2endH?=
 =?utf-8?B?WXphT3RyR1R4U2hZQUk2cTBoc05wU25OMUtjOW85a1daajBrQnIzRGl3aktq?=
 =?utf-8?B?NzdYZGxReUxuUTZHQ0I4L09ZcDB4OXdFRytlUGJUNnJIc3Z0RHdLdmVtU2tY?=
 =?utf-8?B?QllpcVVlTTA1VFhPUlNIbUwwOEpsQW1mYUpodHprazhUd0RyU1FPeVRReEY1?=
 =?utf-8?B?TzZoakZ4WkxaS1F0dnIrVHJRVEJKeVhmWHNVd1hrOCs5aTVXUmlEa2p1eDMz?=
 =?utf-8?B?S3JxVyt3dllUWktOZ1pGSzlKUmN1ZXpMNExtNFFENzFxU2tSdkRDK2JDK2Jm?=
 =?utf-8?B?eXcrZ29aMnpQUE01TGZlSnFEaHRsWkhpcHNLZnBhZ2xya216RXdZb1E2dTdu?=
 =?utf-8?B?Lzg5cUJxNnJweVNRRWpQWWpYOFFzSkxJRFBuYzVhY1BianFicUZma2RMSFBE?=
 =?utf-8?B?RkpRdXVOVkRaNHRYN0lJZnF1bkJhNllURS8vaGFQOFl4a1N0UWd1dmg2eldv?=
 =?utf-8?B?RDV4NzFjMGZIcFVQWHlMbHRxRzd3b0NNZjJQK3NJWlgvSXFxNEpDSnU1by9v?=
 =?utf-8?B?cFRES1YweWhLTStQSTVNZG1xa1k4QXBoZjZXN0pBQkRiMkNmanJPTkp2NjV1?=
 =?utf-8?B?YnlrNDM5MWxkMW5iYnh4dWtTbm11aENMWlBReFhVVTZZd3owTWRVQ3J4TC9X?=
 =?utf-8?B?RytRSk1RazVFMkNCckMrVkdUajh3clBZelM1aW9CbmdlTGg0cjQ1Rng4V2Vo?=
 =?utf-8?B?RUZHWjQ4bThXQzRKdlc2c2pSdlZIeGpQN2lWT2p3RHBaOE5QNHJJVHhiSkpK?=
 =?utf-8?B?ZmlIai9iVi8wdWtqTVpub0tkVitlNHlTSzNLckpDZThyR1c0KzNPeVpxZllB?=
 =?utf-8?B?VHJXSEZ0WFQwZXpBL1FqWDJxYjM5N2xnY2VJVmJtL3BNV2pNY2NMZGdJNzg0?=
 =?utf-8?B?UUtCa1Y3bGpQL2FCeWhzb05MbVBHYnprZG1ucEhQUWlZSXl4Ymx3NHllSEpt?=
 =?utf-8?B?d21zVmdyWFZLMEtna3gvMFNaUitPbTZmaXk1NFkxRHlUZjRULzdCeEZLNXpz?=
 =?utf-8?B?MTVpZ0ZtZDNBY3hIcC8wdFdtU2ZralkwV04yVGNLR09GVjYyOXdVQ1hMRWRI?=
 =?utf-8?B?UnNxbm00emZoTHFCZHM2SlV2ZEhvYWxjM0F4UjhSZGp3cTBmRVRnbG9sdmtl?=
 =?utf-8?B?S3pScC9mendod3dyV3UzYjJjZFE4K0toRWp2a1h1V3pMSkg4WkFpUDlUUWtT?=
 =?utf-8?B?UmVWRUVLZ2w3TnBhNVB3d2tmL0pYdFVlNkRsdDk4aGx4a094UEt4cjNZN0VF?=
 =?utf-8?B?VU9JT25lNDlOeHVHSWRuT1B6Q250VkNVVldIZTJVMU16dGpOQ3hQRURocG13?=
 =?utf-8?B?MXYwVVUyY2RQdG9NaWxxR3pkYi9hd3FKZTduT2VYTW5ndHRSZWxBbENZbnpq?=
 =?utf-8?B?L3BmNVBBeVFNR0dNdGlobGZTejh3aG4rS0F3aHVqZlZDT25rTHM2ZzRVN0Vk?=
 =?utf-8?B?T2kwdk9xclY2N2JGRjMyZSt5blVUUzJzMmV1Z0FubGVLY2NONkJTM2ZKcXdj?=
 =?utf-8?B?TElIdS90UFJLY1pHS1pZTmNOenhvT0Rrbk1vbzFHZUQ1OWI3YkFhdWJIQ3hj?=
 =?utf-8?B?K0xzNkVaQWtLQnhDT056dUhYT2JPRFFuNGx1Z3E2ZmVMRHdzYkpSeTJUbkgr?=
 =?utf-8?B?dTB4VGoyN2tyZHJHeUV2dGhzV1hmOHZ5d2hkTlBVeVZDcEgwRWFhMmFDRmJV?=
 =?utf-8?B?WHN0QmswWEhudERuamFoeWhETG03MVBuRUV4eWx1MXZPM3gzZjBPLzU3NGpZ?=
 =?utf-8?B?SGR6VXNEa0ZTbDlBOUY4cjBLalVPR3MwZGFZbkFKb2Y0bDgyRHFranozdXJ4?=
 =?utf-8?B?NW51dG5BVHRtTHB0SFRUdVd1QnB1dVhjekFuT3lKZUZwRXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGZzRzFtSzEzSmNoNlBmWHU2SHAwWnErQzRobGtNL1U4UGRiS0p4dEQzc1pp?=
 =?utf-8?B?OXJQSjhVUUVocnpjK1hoYzh3UnNFU2ExazQwUVhBY0JuWDQzVXVuRm9NNGFW?=
 =?utf-8?B?QTRhTFlJbjhLVENBSEtVV0k5SjdSWkN5QUpNY2hGaHpRNHJ6cTFNY2ErNWlS?=
 =?utf-8?B?YjhtSnZLUlV0NUZHMVdnMm5yYjM1Rm5BcFUxSjI3ZmxGbC90dFVWbXlTc2pD?=
 =?utf-8?B?bmNoYzhFSGRNMzBNWUZtek1pWm1Md0xxZlhVdzBGNGF2MWdOdW9WejBZQ2pC?=
 =?utf-8?B?NGhkZWpDMDFKeTliKzkxZ0MxaEg0UWtBeHRtTThDUVJNVmhNZkxTNm9IU1Ur?=
 =?utf-8?B?R3dsVXF2OVZhU2lIMWVyb1ZGa3AyN1FZbk5mTGo3SGhXRnlGL25EalVzdytX?=
 =?utf-8?B?V0srN0RQU1B3a3UreDYrY3hZQ3pIR1hhOEZGL21UZVlpcEtPc0kwenlEV1JE?=
 =?utf-8?B?NDlKS0ZpZTczUWQ2c09qR244dkh0SHNwaFB4RUFiL0NhZXdyZHFHUnFndHRk?=
 =?utf-8?B?ZWk5RGUzcUJMUWhQb215cFBJZHdsWFVNOTFXY2FBUG1pSDBvdWFqVE9TZ1FQ?=
 =?utf-8?B?NlkvS0t4UWJDcU4xMFdNNXRaMGxmcVlBWmVaYnFPY2pnQktObFEvSW1TMHZm?=
 =?utf-8?B?ckdUNWNhVXJ1UHFEbXBHc3NIcW5xbTY2eFAwYUJ4MytpTldVOU5YaHgvVGhy?=
 =?utf-8?B?SUpmNXVwd3BubitoOXBhQnZuS045YSswOGJvWEhIeTdxOWxsWSt1dEsxenRl?=
 =?utf-8?B?VnRZZ1pmcXlpTmhNREw2SllYN1JEeTc2NnA4Mmp4ZjJwOHI5enB3MmFaZVJ1?=
 =?utf-8?B?Q0lndjdqWnpUNEFsQjU2WHkvQzdzY29OMXB2a1ZHeCtaNnh5R0U5M254OEU0?=
 =?utf-8?B?TXBjSjNpd1UreXk2Unkya0JFWU5URDJ0NnpvVTU0Wis2WVhGTHhLVnhxQlVa?=
 =?utf-8?B?aVdNVE1lWW9HL2toemErdW1HT2ZWSVVzVTJpM1A4b2NUdlFIQjZvRmE5MFMw?=
 =?utf-8?B?cVdMQ1BpZjArZFp2VVdheWVmWEl0OHJBRDBDN2phTm0yRThuVkFIbTRLRkxl?=
 =?utf-8?B?K3d3U2Z3dzBvMGJUREFGc3RVSjJ2c25OL1hBNlpMZjVtQjkxSkltelhnWGlW?=
 =?utf-8?B?TlBRZS9XeERNVm5VbUloT2pRZDh3dUI4Tm5jUVFCWVNSUk9yK0dEOEV6d2ZW?=
 =?utf-8?B?TzBRQlZSR1hEb1h6QXRwbU9MSWJJaUd3WTNsb1dVbERzSjNHdUdVVjZzVGVM?=
 =?utf-8?B?WUphTUJJVThXbEpEc0hrUi9nMmJoWDBqYmd6Y1h6ZVFyd3hJQ0ZMU1BOMkRr?=
 =?utf-8?B?UTdmOXB6U2poeGpTUDRsSm42dDJEY2RESThxUEMyZHFRdkJDbStkN0Y4dWxH?=
 =?utf-8?B?QjU5RVhCaWZGaTk3RkpIR0svT2ZEVmZReHlsZGNLZDVNbG1jaWV3K2xLYU02?=
 =?utf-8?B?R0twNFZXTGw5d2RzenNGQmJZd25ESjY4QUVrY05JSU01T1pWUVlmUUlXNVc0?=
 =?utf-8?B?eE1uc29iYy9iNUIxbVJaRTZwaGt2bWx6eEhBZlk5VFFPazRKMVZWVjJ3SDBj?=
 =?utf-8?B?dGUzTkNaOFI0S3JkNk80SzJaU2t6RUgwMVlINHdtN216MnRMN08zYWtCQnUv?=
 =?utf-8?B?NjJ5NDdocFBkOTVTSUJPRXB3Zy9tKzFiTHAzRmRMMEZoQmZlRDlwK1J3ZCsr?=
 =?utf-8?B?VExjSHFzVzZXc3ZGckRrVms4NWFHbnBFcEFhdU5ZVHcxbVN3T2pqd2VHWS85?=
 =?utf-8?B?c2x2aUZXRlE5MTY2SVlKcUcyb3cxT2NiQlVwbS9ySHBJcENnNHZUSDhLYlhp?=
 =?utf-8?B?WngxenBkSDlIVUJraDRGTkFuU0UyZjI3eFNENzJldUxtMGw3VnJaLytUUUZB?=
 =?utf-8?B?cU5UYkVEQnZ3L0RZYXBGa3REU2hId2ZFYlNBNW5jWStSdTF3Y20wUnBWb21C?=
 =?utf-8?B?dlh2eUtRd0FBOTJwRVFQWUpEbkpoQ1I2dndoRXZEcW42bldicE1PSG5Md3Bm?=
 =?utf-8?B?VzloN1hJYm5UTXI0dWhOTC9XMWZrdjZyQzhiNE5UanpHbnlXV3grOTdMZ3Bx?=
 =?utf-8?B?WS91UkdKK2grNzk2ZDl2Y1VPMFZaNGtnekdEQ0Rta3J1eHhQTHI4bExpL3ll?=
 =?utf-8?Q?NIEnZ9+J1iISgbAXulSsM2nD+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+2McSbNbC+8XK7hm0JporjtDl9dXpyqIXWXkruN2MLOiiSWjwNkJ+RiGWcgqKi2tMyRK37VrMldie7tsEMe/OOAl0wtnuStuf/b1eyWGWhoG42SxYLJuHWWzCti1VkOJT/aBLkpnCap19WK9pRWMCjigM4f5X5VSt5e4y2gjS2SwI9tluTP9cBYWYC1ZXmxW7ifgxxEA7jYB48yliB8T9Q9pqasZ8/c0qzUUiyZFtk/PYHTwxvZl8iv2CRwPIizENG3rXkzh0h/E2JqvYfOB8Skar193srTZHD1oOvOb3VSUcfpNs9tw7havOnMf4lJ8gTv6ZXcThYd64YiIed2gZa4x2XTE9fumnGzwOy7Djv6kDO0SvpAo540qv0oCtw5ZchrIJffgwjUW2ADYDzGudTZBE5bt76FY5CNdM6PQSt+fdN8fd2VV06gLuxg+uw4fVAoREZ5gRiMeD9vSfUbPUzN1FHFQvZFcbXX9zoBEWl8l+PEDs3ARhV/NpxL5PysRNys0+NrTXQ7Sua9OP5I5iKZNtyuzu2jd3mUBkXPJxzQ5Wzsyupw25b1lBVOOLkaSZF17GqTIy2j9JxyvVBTpkg7jN3ZaLQ9EUX04yOw5MQM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a825151-db4d-45bb-638d-08de1d11e689
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 08:53:05.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZNSTlXzWZGK3Ivf6f2T5YKG6zbuRI1v/dTknsRFGcBdyjMHQG3quFlGxqbTKJoOB8PjMWiv+WxcNm6qVi6gKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7857
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_01,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060071
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzMyBTYWx0ZWRfX1Kob3IJeGkm2
 dDuwwHVSRq34mpReO49NApTWhKS9DjBFL+3EtZVUQ+zaICf+Ul9ADrejhjI9O2lWF7QzQl+GviS
 /UmCsOWLfEWxCJpXB8AXT++Att70Atw4U+Ly3h5PnTSZ12kc9PPXStQA9oehQNA7vF9HqkbwzGi
 vjwu2bp4DZpmdDDHaLDzfgQJ3TJD/bW3peA5/rgT2U+Ln8KWYyxCVNwLA/SXN90Mhclahl1/fo1
 XUjtzBQP2Iw/TpBCqQQmKBZYCA5vVyQ+IdVyywIyxAy82Zxk3ffzSKNxZgZSGF5y4ryL/jz8sHb
 rCn7u/IQpfrZIJ6HHT6PqkxxQudl+ZWXZCANwnE8V5pNrgLdlgvenA4PhZ5M6Ha03saVg4/qAxu
 KycxtEeaepJayxvaRydzfn1M1HREsu8ayfFLfiF2axzxr6zxZps=
X-Authority-Analysis: v=2.4 cv=dfqNHHXe c=1 sm=1 tr=0 ts=690c61fb b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=PWmy3DgGaj5dsp9REYkA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12124
X-Proofpoint-GUID: jVA3_IQMu5ZY_MhlBe3D4tWIboYSX8ap
X-Proofpoint-ORIG-GUID: jVA3_IQMu5ZY_MhlBe3D4tWIboYSX8ap

>>>>
>>>> Shinichiro, do the other atomic writes tests run ok, like 775, 767? You
>>>> can check group "atomicwrites" to know which tests they are.
>>>>
>>>> 774 is the fio test.
> 
> I tried the other "atomicwrites" test. I found g778 took very long time.
> I think it implies that g778 may have similar problem as g774.
> 
>    g765: [not run] write atomic not supported by this block device
>    g767: 11s
>    g768: 13s
>    g769: 13s
>    g770: 35s
>    g773: [not run] write atomic not supported by this block device
>    g774: did not completed after 3 hours run (and kernel reported the INFO messages)
>    g775: 48s
>    g776: [not run] write atomic not supported by this block device
>    g778: did not completed after 50 minutes run
>    x838: [not run] External volumes not in use, skipped this test
>    x839: [not run] XFS error injection requires CONFIG_XFS_DEBUG
>    x840: [not run] write atomic not supported by this block device

This is testing software-based atomic writes, and they are just slow. 
Very slow, relative to HW-based atomic writes. And having bs=1M will 
make things worse, as we are locking out other threads for longer (when 
doing the write). So I think that we should limit the file size which we 
try to write.

> 
>>>>
>>>> Some things to try:
>>>> - use a physical disk for the TEST_DEV
> 
> I tried using a real HDD for TEST_DEV, but still observed the hang and INFO
> messages at g774.
> 
>>>> - Don't set LOAD_FACTOR (if you were setting it). If not, bodge 774 to
>>>> reduce $threads to a low value, say, 2
> 
> I do not set LOAD_FACTOR. I changed g775 script to set threads=2, then the
> test case completed quickly, within a few minutes. I'm suspecting that this
> short test time might hide the hang/INFO problem.
> 
>>>> - trying turning on XFS_DEBUG config
> 
> I turned on XFS_DEBUG, and still observed the hang and the INFO messages.
> 

I don't think that this will help.

>>>>
>>>> BTW, Darrick has posted some xfs atomics fixes @ https://urldefense.com/
>>>> v3/__https://urldefense.com/v3/__https://lore.kernel.org/linux-__;!!ACWV5N9M2RV99hQ!J3HKTWLF8Qx-j42OOJ4o1YAttSSoqOCm9ymJtisUYoOtGgOyNNGqHnjjl1Zd9DQXJvCz8zqPMG-kgeVdo9MQuupMlcAo$
>>>> xfs/20251105001200.GV196370@frogsfrogsfrogs/T/*t__;Iw!!ACWV5N9M2RV99hQ! IuEPY6yJ1ZEQu7dpfjUplkPJucOHMQ9cpPvIC4fiJhTi_X_7ImN0t6wGqxg9_GM6gWe4B1OBiBjEI8Gz_At0595tIQ$
>>>> . I doubt that they will help this, but worth trying.
> 
> I have not yet tried this. Will try it tomorrow.

Nor this.

Having a hang - even for the conditions set - should not produce a hang. 
I can check on whether we can improve the software-based atomic writes 
in xfs to avoid this.

Thanks,
John

