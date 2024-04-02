Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3DE3C478
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 07:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712044170; cv=fail; b=dbCWfb7zeXghjT0eGkVNh0usgZvZH369EetpFoqw7lXUC0VUggRkgkdE719P92lZnTHj8i6QbYPg79/KIEISKRfGnMFizxOagsyFI9pNpnFfxt/UCLPy3gWFJLfA3B61DspkmhjxEzn1DntZqCj7OPVxA3rLSMRwDA4+o6PalZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712044170; c=relaxed/simple;
	bh=kvrGWrB9vSnTqgvl9YYDsc6O3Hor6yW9oUmyk6uObZU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DZ2m0dL4EU0h4SzOBcrxWoAp+xDFGtMNMdFy0d3lALKpb43JBXIzyRcKLzHVimdLJJmfvX+6z6TJ8VwjyWAJLsU/SJ/pI2152qUIcTqEYbjWPbZhhaC4YZQhFfe1/pDxy24kgchT8+nMH6WIvhFSaXPtZTlojj9zVMuvl9UgRCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ab1xDDUp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eOLEognj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ab1xDDUp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eOLEognj"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4327hoxp014522;
	Tue, 2 Apr 2024 07:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Ttz1TRKPs/v/OYY4KSf2fmw1MHxB+H1Niv6YrD7O4vk=;
 b=Ab1xDDUpIq5nFOlpIvIQzXbZQBbyZ8FzKoa6OhgjuKls87/ns1VZzfv15ToZZX5WxWu+
 DbM/dFF5719P9AZHqLPWM+ww/uQqaUV7h4vBdF5rRc4EuLRZZJrN0QEtGT1tFjfV9zGE
 VNX34X/kHKTEN8gFDwgQsjDRnaAkRG3mlvMF9qeSaCsvnU15fIyeP1Bn2q4UTLBL9D7y
 dkKVP5wdlYYHpIVhltZXfWRXu7g4i4Bn3a5qR0Enkfp6n3efuS0j+YbUpPW/R1qcntWQ
 UyR9F6wKaBW4hgLNj7FvDgpWYOnnJ9D5fkGD6IQ7O4zTgfutpvLy0OiBX73KhYhgGC6H Ag== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x69h4m0sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Apr 2024 07:49:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4325nTIJ018554;
	Tue, 2 Apr 2024 07:49:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x696cpfar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Apr 2024 07:49:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G06RzGMg32gTYExv90rWoaM9KQ45+BMq7k/GiBUWQjFkpFnG61Ujpifx8NIK/h6vjqi4h0/gzTlnDTSQYqoZfy/4tqc3FZgkzzJ7ANMYgyNh2GS5hUs1yCwaMhlefNW+7qOP9JlO9J44tLuYrG3WLvB8zHR5WKckQW7YM+17YULlyqMrsgCrcEFny7XBmEhnRuX1/nwsVe7HJ/SWIbzXQWQa7zWOHj9/nUmIrAs0q5jbI7NXSSL6eCFekbtevDEqagiB5cGnHe+6fGD6DYDUU/mHg3aco+0ZoB/gBVX7c/ujDfRc7MOVEY4I3gJIEcdgwWyJ4XbPfvbJcDizmc2Gtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ttz1TRKPs/v/OYY4KSf2fmw1MHxB+H1Niv6YrD7O4vk=;
 b=WFntWH6bWLmQAgO53szGUO27j6XfLm2N0qAYdOr1VgdZcozGarB+VTfZdpWCoatIB5/U2xYiFFIaQFKkLgOJIvEPeYfUucD44D5ifyW9ta/NAKHrFzo4p0WEF/xpjY+J7TamVImuEO6IXvMhjFjUPEKr80SISn3eguB/IUD+7LLj5owhSmlzPN0JB5bi6tnhujYHN10iUhXPVVYEtqUCYa1UvkI+DmbigurTVomPTqT8xnypguLaGgSN6thzkrhac356NVcfMhLWSUwpz2a/J0vtLg2FQXuU3KYdM/D9ggBi7HklN6hF4/e7D07AQGGi61GBtmhPT49xDxlIAGcUNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ttz1TRKPs/v/OYY4KSf2fmw1MHxB+H1Niv6YrD7O4vk=;
 b=eOLEognj17N+HtQlKitp83y65ghKwHyzf/AGIboCfjTYRrd5JIlO1pGNdZoKGZmTf740hdGYO6m+j5X+VSyGdkfp/QCgpf0D7C/X+XLtue8HEvkjtOIRiEga3lbvTfNQqqRzladqEaY/XK0g5WwKaJ6Hs1xc4uW1h96x11WF/Ho=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4796.namprd10.prod.outlook.com (2603:10b6:806:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 2 Apr
 2024 07:49:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Tue, 2 Apr 2024
 07:49:13 +0000
Message-ID: <11ba4fca-2c89-406a-83e3-cb8d20f72044@oracle.com>
Date: Tue, 2 Apr 2024 08:49:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfs: simplify extent allocation alignment
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
 <20240306053048.1656747-2-david@fromorbit.com>
 <9f511c42-c269-4a19-b1a5-21fe904bcdfb@oracle.com>
 <ZfpnfXBU9a6RkR50@dread.disaster.area>
 <9cc5d4da-c1cd-41d3-95d9-0373990c2007@oracle.com>
 <ZgueamvcnndUUwYd@dread.disaster.area>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZgueamvcnndUUwYd@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0302CA0027.eurprd03.prod.outlook.com
 (2603:10a6:205:2::40) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4796:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	9/WZgu7wQqWt6Eb8smiTs51Nx1VSmYI92Xy3SCpDhRdSBktNJp/dxhuxs7ikAUoRDh0ZJYFFuztSsE+Bmah1gDPatOZVIY/iO6jd3usbV6UzCPWoDRQa06k+zWjLgg4FEE8SVIPch+pUJ9vGcvgtq7V0xmmjJJyHLy/GWmldDjxcwSKh/o5G66YRY5GQZ5163agf/X4Bqz+HbOEso3SCNnzIATcrDLK0LHr9E4fbao/Hyaat+EKN7Nx1GgaZpTL3BE65SxJwiBQzsOK/r1tFCxQGRe5xObXcKBVXZ6nO+hrlEWUVZ6qPAJmeERJyfLlBsBLGRcQrXh2AWdB+PLpB/i0eariuZoDdytWVvC3b2e/tZRKfof3rhxXTYEJoXvomqcnRcHXU+TO68nDvOitvvcAgxphtCxI46HOPk/gnHnmn1qR11lWbZ8rGznY66XZrXw4xR+fQqbOIDNwTOqY2JMY5BKtzIAbkwLaGRukLQMrklrCflSTk/rux4dwfAQqHGmSgz+DkAdBqA6K9gRwg1nF+9HdJ7r+8fVgCYesx0x/KyBy4jqO3bPe6/ige2zvCE8HqKgPNPYezvYPhGcCcr5F72VF8q+xwyIg8lxr0PoGt+d5GmRyGrGihKnu57I0MheUbfxgTzvod5K53yjU5IiTaTTDiRMb5YSGcxdFSDaM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eVhxYnROY0RyL1NNOTVuUmJ3cnN2eHFmbWdsL0l1QVBUbUZPY2xaV2MxOTAx?=
 =?utf-8?B?Sm9JSEFJZ1ZBNEFWQWc4QlVFaTlUVmVBMFFTb0tqdDFsaytmRSsxMCtOaDla?=
 =?utf-8?B?aU5ZY1dYdHduRy9ySXRXbkxMN2JlbTZpczIwWElJOHpuak1zZkhaUlhmTHN6?=
 =?utf-8?B?bnZ1alJkVVZ0cEVuTEcvbmhEZzNPR0VGVVZobGxybVJya3dDT1B1cmhaeHdX?=
 =?utf-8?B?eXFqaXNGN0FsSjhPZWNJN01MWUtTRm9EeVJJVTZLZWFWMjl4dkRaRjdCZG51?=
 =?utf-8?B?NExkV1d4c1docGVVb2JwdC9BZW0vUjhITFBCV2dQcTZoVkF1UXNKUWVlU1l4?=
 =?utf-8?B?ZS8yOU1DZFJnWThIV3NMdmpXbjhmeVBLV3R5UWpDMU9zQTNZSVJ4RjdacGMr?=
 =?utf-8?B?clY5R3hQMUtTRENMMnNyNTBaYWJXNUs3OWdNdjRMT0hLaE9zYzN6R0NpRmhW?=
 =?utf-8?B?Zk5pd0hxSUpHNWtMOWRuTVY4bGhTbElpUDBTaUMzYXdMNFlVQ2VEVUVEaTZW?=
 =?utf-8?B?Zis1MmlweUdjcVJDUUZMWEdPS0dCekZ3QnRFRlBDNzdndGM5cjVZd3pNWkVU?=
 =?utf-8?B?L3FDVmtXVU91NXZlRHI1U2hFZFJISW51V1VNVU5DYlMwMGtyVWxxcEZ1TURl?=
 =?utf-8?B?OWhIZ3FCZGlaR0lYdHpyVDBUK09HMzNUdnFSb0szMXpxeGR5ODlDeUFtRFdI?=
 =?utf-8?B?aWxzVUI5dWVVcUo2WEZxcEpUSDV6TzU2T1RxeWx6MGM2TVA2dmdUNXpNNi83?=
 =?utf-8?B?eS9KSldENVh0Z1BaK1Z4cG1UTTJWSkZGTE0vMlJTSStkVXRMQ0l0YTczazA2?=
 =?utf-8?B?SUFCcUJRL1o0bDRrVDE0cGxkOXZ5UEZGcFBhZHRrZEFoWDNlT0ZpV0dvSVNH?=
 =?utf-8?B?UlBUeCsxcmNYcWZLNUlYdGg4NG5BK1lWQ1NiaisvMXcvM2JPdkRBelI4b1A1?=
 =?utf-8?B?Z3Yxb3lsVzViMWhOc3ZTUUgzYUhqajFURmpIZXBid0kwc2FqdmE4ZDV5ODJP?=
 =?utf-8?B?cmVBNmt6cEcxMy9tRWZSeWNVemRyZDh3eldTQi9maDJrVEh1RFBWYmV3dXFu?=
 =?utf-8?B?aTJsUXhDb3ByOEdmSWdrZFd1RmFxTGw4QVJkcjE4YzR3d0FyL0tKS2trd3dM?=
 =?utf-8?B?OVdwSEZRS3lUdDA0Yyt0R0VrWjFqUnE4R3pDcGorcmw5K1NnbnhkN1NPcTl3?=
 =?utf-8?B?bGt2Z2E2M1NWTUxYczdPT3JESnB5TjYzRnRpTzVZRkNVSktOc3hPUGExQndy?=
 =?utf-8?B?UzNTWFNIQ2hEMDYybVE3dk9ScGJ5ZGdMZUV0MjdteG85MFg2ZnNJNStYM3dx?=
 =?utf-8?B?dmlRelpmSE04dFhyOTg1YUZ3dE9PbkdVZ3VCR2tUMlQzRHJMRER2YkZwSUdL?=
 =?utf-8?B?VThySWYvZXUzaVlROVVFbVk1NHp4OWZEcStNb2pobDBXSjFvZVVBajl2M3Np?=
 =?utf-8?B?ZXNXYldyVm9lbkhZUEhJOGhUTVJFM1ArQ2pFNjBKTktaaExTMzhOekNEbEdU?=
 =?utf-8?B?Z1huQ1RTM2FQcTJIMkdwOVNBc08rN2QvSS9RSTZCREpOUHpNOXYwWXdQWTk4?=
 =?utf-8?B?Z1pYcXgrRmJEOFVrb1pJVkZTVytDMElaT3FKbFNZWS9sWURFcllGVXBZRFBS?=
 =?utf-8?B?RU9HY1pZWStlZjZhS09uZi9BL0xMc2FvWFhkOFF6L0xxTyt1Ky9vSjJHQlNE?=
 =?utf-8?B?eXprSXJXYzFoSWJqOUhPa2plNkFyalNvdExYRUIwTk5uV2ViV0o0N0hSU1cr?=
 =?utf-8?B?WVR3WGM2WTdvdElnTW1lVkF1MW0yMTdGUHFTTEY3Y3dEUXdyWUphVHZhKzRG?=
 =?utf-8?B?bG9NSXVwc2FtR29YZGc0aW93SCsveitVTmI2VDNrVkhWckVucWxyMm14WE9E?=
 =?utf-8?B?MTQwMERyY3RsR3k4Q2tXeGxBMVh4VnVHa3drbEdaZHFQbTFBQUNZRHU5ZDFB?=
 =?utf-8?B?SGJnd2JEeW9vN3I0VUdvd3BubmVTakI2azhqR3FhSXlhRWQvOTgzbmJrV1du?=
 =?utf-8?B?WE9yYkRiaDN3UlFXOC9rVnh2VE1qTUk3MjFoSkVmaTNkSytRWDJOT1JKcm11?=
 =?utf-8?B?RHZ2TUtsK0ptM25RVE5iRWJIL0V6aFJWeWRoQVpNL1ZoT20yRmVBcHppWWJN?=
 =?utf-8?Q?5w13fnPQGRIvdPRBv4Mkgptdh?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mWSw7KDhEYcZ+Q7WqKpvovGSA2LN9cuQ7bO1x+eGUnJXkVT4CTbc9hq6lWRedueB2nMHerTGwCsQDEWWEW/i0XCKlRD3ttjyY9Es3TgkLZzaZbOLR5ISzDOFec0895pQQ+ym1Yvfq0dWrc1CZem+Z4syxqQxYeBQcCJ0n0/bSOiSUGZhtMR4/QUCo37VQzrFcwztP4KuI5DKvVH14HoX/7kByEb7rbnqCwkyt6FlOInFimMCQcVnmkY99EH9zKo0aQR34K86ClOd8Ah6vnZI7aA0B5Oeueju1Sl0KsY9qMuR/S08gwrMSOZP4ltsY9ov+LlMIC3gyvhTaCBa+4VcZtgDkq84CItGi6YE4apnp0MCwTQ70S77hq4To+zq96PHV2Jl07ULUv7vQm6sc0tjPf0VtIiBCbIUqamZ01W2qmwROQXR0/C5T6GpvQq7woLUoYJkwxaCs0R6wUZ6cHRMbPigopYcCx32/A/gIzYRNrRXgxLerwpCWQLc6mG9WEMnZPoAyfUT3HNFkcn5I2ZI/WD0TtHGUkAZTVX6o3J6lMa5CRDd79uubI+ErQtseifvbfXLY98PmeIMTx/z16QoKRrgpA9M5HrFXuW0ajSB/l4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0400aa0-54b1-40cb-0829-08dc52e963a7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2024 07:49:13.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBWS6ETRV2hyeMFJku2V/wX3mMH11WqhClhdxR3UORz6EZE/+0nBP7fGjDNKaiy3ip0zdg7V49x+Rd+igLrQiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4796
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-02_02,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2404020054
X-Proofpoint-ORIG-GUID: qSq6fZj-gMhLNfvK7UfI7pplGIfaLIES
X-Proofpoint-GUID: qSq6fZj-gMhLNfvK7UfI7pplGIfaLIES


>>> the problem should go away and the
>>> extent gets trimmed to 76 blocks.
>> ..if so, then, yes, it does. We end up with this:
>>
>>     0: [0..14079]:      42432..56511      0 (42432..56511)   14080
>>     1: [14080..14687]:  177344..177951    0 (177344..177951)   608
>>     2: [14688..14719]:  350720..350751    1 (171520..171551)    32
> Good, that's how it should work. 🙂
> 
> I'll update the patchset I have with these fixes.

ok, thanks

Update:
So I have some more patches from trying to support both truncate and 
fallocate + punch/insert/collapse for forcealign.

I seem to have at least 2x problems:
- unexpected -ENOSPC in some case
- sometimes misaligned extents from ordered combo of punch, truncate, write

I don't know if it is a good use of time for me to try to debug, as I 
guess you could spot problems in the changes almost immediately.

Next steps:
I would like to send out a new series for XFS support for atomic writes 
soon, which so far included forcealign support.

Please advise on your preference for what I should do, like wait for 
your forcealign update and then combine into the XFS support for atomic 
write series. Or just post the doubtful patches now, as above, and go 
from there?

Thanks,
John




