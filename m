Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5501F7569
	for <linux-xfs@vger.kernel.org>; Wed,  2 Jul 2025 09:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751447610; cv=fail; b=rIkxEwjnYaFvGxEKGYQWA4CyWFDcAQDmpQz7bk32TsbZZyrB5dF+PBTidDSsUos+usk+DDl4rV3g+QB+BcD41FQ4PWcIDGlzxhVNj2b8RIWb8N5UDkBapaca/naWjMG5KZLlJ954gfXayP2jeXXLo8HgKQ/UpwotpVte7BNmNiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751447610; c=relaxed/simple;
	bh=CkPwBoms4kI+36fOW0wz+0yZNBOG7EIMDpGOwKCSPeY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J0ovKTP8TdVoTmJY0JtpHs6v8YyViXN987CPATEzha/6Hu93fbRuTuO9qVyDBTrPliU0c9TRcCaA/Y/1/T5HpoO6GicFkqN3H48fpmkqlzRzyeglqqlzKUCFFL6h0pKaiVJKeARg5WclCwOSxa24tQn1M1ANvxRiR3ypISdvIfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bLceg73t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EDlLUyff; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bLceg73t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EDlLUyff"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5627MY2Z032598;
	Wed, 2 Jul 2025 09:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jprRdIZPGB2TvL3Wisl9YQErIoRl+OejnpjabsMn7Qo=; b=
	bLceg73tSJ2CM2oFx2Ov9dV5YEPi0yEoK8v15rX/dOfxSJ996jnu1hbqo03OXG6x
	X5omQyHikZtBg6mniCXdq9xNQORW3F1j+K+ItSnhfmAIdFxNmRICVY3nJ/8d9v0u
	zrT87sJRQPMHJteLwBsqgGoePhwfOQjPI0mRjsOLSfOPjY4V0h/sHffWBAWLgl81
	bQTF9RH0oaMpaaf767HPFqBwfLqUemnfpS/ybmx+6Cyw5Cl1+1MznlAd4271lGFS
	QWhlbe/t5u1Y/bW0OOCQ/bdV/jmF3Nps0aMCeyXgFdEshPI01DcyADLhMTfn/kGC
	KQLSf6tJo0TZpS6QhVUV4A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j8ef6j7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 09:13:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5628I2Fe024989;
	Wed, 2 Jul 2025 09:13:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062.outbound.protection.outlook.com [40.107.236.62])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47j6uj77cq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 09:13:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+NWIOoCnXjqEzpK2P+czZ41hxBs9wmU/baTZ8NFasqeCi5WBE8z3N2Tjv93jfnj08aZGNxSG6oRZGU2xSZ3vVObTLBvjX97MaMe7kA/9getW3l94lP4jn7DDCsSt3oNQ69+SHPyLdW6ln5H+DtE0pgUipKCPIBjzS7Gz4eIpq2wJnrNor1HnmmhRID125nfwd5M/YCkutddZ69sHBnFOdDWUl0epQbdk+s88syl1UKVBEO9AZ2HG4OQrat15/l6m1xA6a0rcOpmLyuDpmHXfL/asr0DofHqancXlSB1MdmxuJ7NwB6Q7tDwuRj6d0uRxPZsTYP/6f9W9juptb2s9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jprRdIZPGB2TvL3Wisl9YQErIoRl+OejnpjabsMn7Qo=;
 b=m7pdAO/K0tnZ3xOnwEbY7JKwUAk1jSsyPQnGv6JhSBSckWMspN1h1jsEm3/85QvcVJpknC4t5iBcC/t98pV1GsCnIVZJUfGfGu3hvR4TtbJQXh//7cMLK7U2eUC6i4Tl7rpjofY3GcLWecqLwPLVSAXNZQnjhDXokcAkajoCvOlxEiZZAfzyF3+jzdDNMfpf8aSfTzA7+vJJ5oWAqQdQf/ODz5SmWcaoSQAnKWSgQO6lFHvN0PXoMPl6zK2aD1Qys3hW6jGY6EIAJActFFXeYHgvLanoNLfslNaGDPXyQAGabNyJ6DaGrUO5ZKM6N6+fqzAUP+emAlRtLc5KBlEANQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jprRdIZPGB2TvL3Wisl9YQErIoRl+OejnpjabsMn7Qo=;
 b=EDlLUyffxhtFGiCqhIOcBVBjWPGjhdRDWej5iPhLS8SpsAXR2oGiWu+8eY8v2l5M+wfLA2DzbR7tmYWUwp2Owwp8gNLvri8+4IciG5pPZLM/aSAkhjK4o82aYmwOGqu7Jtr1IzmM3weGVd74MXVMFkt1dipj6ynpezsnz7syVqk=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA0PR10MB6842.namprd10.prod.outlook.com (2603:10b6:208:436::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 09:13:22 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Wed, 2 Jul 2025
 09:13:22 +0000
Message-ID: <8824899f-d89c-4329-924f-004e1a22f5a8@oracle.com>
Date: Wed, 2 Jul 2025 10:13:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] libfrog: move statx.h from io/ to libfrog/
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303856.916168.6082463372853489931.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175139303856.916168.6082463372853489931.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0112.eurprd04.prod.outlook.com
 (2603:10a6:208:55::17) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA0PR10MB6842:EE_
X-MS-Office365-Filtering-Correlation-Id: 6edbd935-324b-4f88-4e3f-08ddb948b16a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmxtcDA3Vi94WFRKRjNqSzlNYSsvTzB6eE1XemxXdGd0OHNtYTM4LzArOFdX?=
 =?utf-8?B?a3pGQ25KNjZrNmttZUZiMXVCbFFQbHpSODgxRm9hbGcwQ3pFQ3NqUmpUaUlO?=
 =?utf-8?B?Sm0xWUpWa05lK0NsRDFkOXd4R01BWDVwbEgyQ05UV2YxOG82alA5U3lSaWZX?=
 =?utf-8?B?NkJ4OVE5UmJtQm5TYzdnZnh5MjRVck8ydmloSkZVYnBDdTd4NmpONXNLR0xJ?=
 =?utf-8?B?SVcrMk50WUFISlVOa3krR2ltQlh1S2ZxclFkbm8xNm5vL3hHakVJNi82TkY4?=
 =?utf-8?B?QVhINjRZSGFwN2ZDMnEySWhzblZ0UUt4bmsxQjNLQnlNazNsbStkczRwU0pI?=
 =?utf-8?B?L0hTd2d0OXFnSmN5TDVlSVVpR1ZoUHFtODhEVXpoVHovVmhEZGVSazBCYmVQ?=
 =?utf-8?B?QjBGcE51cVN1QUJiVnNBa0FIQ3F5TGVwc3M5MDl6WXFMNVFBWjArbjk4Y3Qx?=
 =?utf-8?B?cDIwOGZTbURpMkdqU2IzTzV5MCtZdnAyUVNwRlJHTno0Zjk0Z3B6RDNISngw?=
 =?utf-8?B?dndOVGJpeUdsYmxKVllGN2VYbXp2alkyR3VZbzBWbDhzT2FjWWhvTy9RV085?=
 =?utf-8?B?TFJEcGlkWjBabjhTNUQ5WFhDUVBqcjVmSW1JdzlvMCthS1BzSUxDU01WSjNs?=
 =?utf-8?B?WlpPdkRjNlIveG1IdU9MUDE5SDlQUE9GVDBYQVAwSE11WFo3ZFJHOERReUV5?=
 =?utf-8?B?Vk5Va01vK0ZPeTBXdkdvdjhpeUJ2WmVINWViZVY1NWUzek5HbG1VNzFXbm9w?=
 =?utf-8?B?dnVKTHVMakdIQkIwcTczbUQ3dng0cFd3M2duWC9tcUx5bmNtellkaGZxQjFX?=
 =?utf-8?B?U3A2ZHVobUw1LzN2M0NTV29TSzFhaGtOL1ptalNsc1RCdWcxdlJvUThhY090?=
 =?utf-8?B?c0NyWC81NmF5L1dHQXZHMzk5YlpTYzNUOVlSZFB1ME5FaitPN3RZL200TDFv?=
 =?utf-8?B?U3F1ZjN6STlxMC8zcDRwTzNTWjFIdndaQXpiUUVYK0U4RlNQUXQ0eitXeDlQ?=
 =?utf-8?B?QUpzRFJSSnBXUXFMcU9Pa0hIeGdsVEJlWkFFR3EvbzNUMkdwaE1IRDN6RWxp?=
 =?utf-8?B?b1NoWjhMZWRYTXJUVDA2OEQreDZIUHJScGpDSkU1blM5ZTFtUEsvYVpQdmJp?=
 =?utf-8?B?RG8vTWROQW04OUd5YkJCMDRWWWlTYmdQeFJ2Ukhyb1Y0Z1g3TVkyelRKS3oy?=
 =?utf-8?B?WGVoQTJpY0V6TjIrNk5tVmxodEpHMi81WUowL2xPTzJUWG5NYW5nT1pYNkNl?=
 =?utf-8?B?VUE3M29NbW9uL0MxQmgvc09lVUR4YlVzdnpxZERHMFlxTHhNbmNnTlM5RFdm?=
 =?utf-8?B?dHY2b3ZwSzZ3a3VQSXJHa25ianhwYXArQWozUEZ1L1JudVk1ZUNBdGxaUzAy?=
 =?utf-8?B?MUg1Zmt0WUxuSEFPMy9XR29PclczSnBuM2RFMlVyZHcyNEZ3YzZhV0E3cElQ?=
 =?utf-8?B?aU9rWDlXKzR5ZDFucnZqZjhZblBvNHljTXJ5NW5Ta3VSUkxwM01vVm5vNTRG?=
 =?utf-8?B?NXBuSHJjRWNmdnBMbHpOcXBZckZyR3VPaXF6dzdscDM2WFdyaWswNnM1ODVF?=
 =?utf-8?B?Z0piemtIMDFYbTNKc21ZUUZaTnJuOSs5Rnl0UUM2WEFpOHJpY1ZQL0Jjanls?=
 =?utf-8?B?YkxOUXNoWHhyUVNTd0s0TVlhVkdGYXFEMGF0SVMvbHQxRjVZTWl4eGpFNGZv?=
 =?utf-8?B?S0VVWkNTcVVzakhST0VQZ0lobFluU0c3eTdsbHFwNStnbEdKVUZkU2M0VlN3?=
 =?utf-8?B?ZXowK3M1UHI1WkwxSnNMaGZEdFpaRFlvWlRyMVpxVnhrTTFmd2ZGTGVKZGxB?=
 =?utf-8?B?T085cHI4bzQ0c0xEZ05NSkdZR0xaclU4RkphQkhRT05HVktMdWpJeUVjYWhy?=
 =?utf-8?B?Nld2Q1huUW1xU3N5c2xFTE1tUHlJNndoTUpKTk5BTmtjMkxJckcyTC9zZ3o4?=
 =?utf-8?Q?uC2Z6plZAqg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVJxQjR1eFJUQW1CZmltMzRsQjc4SXdESEs0NVhoZ3M5c0VhbXo2dGZTdmxT?=
 =?utf-8?B?REtXbmNsZjl5cjZrQjlsaU5LSHZCeTlCL01haXNhSGFveWkvem9wa0ZLOWJj?=
 =?utf-8?B?YlA1YUI1WkJOTU4ybzVvWlBrLzdWK1NCZzNKdzRYeUJyNUJpUktmM3NSSFov?=
 =?utf-8?B?dzcrYWEyZnpYckhFU09UVlUwOFZkSmNDOHNQSms2bmEyTTN3ZGR2dUVlYVlj?=
 =?utf-8?B?Wnltb1F2eERKelpHYWd3UG1sVjVuTWx6OGJnaUljTllRRzB1Vlp5TEZNejYv?=
 =?utf-8?B?R25aMGd3TnZScERDbGF4Q09kekJMcUk0Q00renlyM09wRUtCUnFHRUxSTytz?=
 =?utf-8?B?N3hiNEtaV2Z0MjlxWm10aVg4N2FIa2lQTXVkWmtJWkw5KzFRYlJEN2hENnZQ?=
 =?utf-8?B?VmtXNGdZUXdBY0gvSzJsUFZUNVFKd0FhYXF0Ny95R3dDNjFyS1FIazVEM1Bi?=
 =?utf-8?B?SWZPS3ZsaEhXcTc0amUzTExwRlBTM1RxbkFCSkk1WnBhVlVyZVlNRkhtWGV4?=
 =?utf-8?B?RkxxVm5oOXBjV29EMitTclN4Vm5VdGJQU1U3QVFqcXZNc1M1VktGQnZMYUVN?=
 =?utf-8?B?ZzhLMkIveWQzKzBFWlB6UmhNVkZINUhoN3M3dndEK29yVi80bm4yNVBOeWR5?=
 =?utf-8?B?cUI1R3FKSjFuMTJhbURabEZrbVRDMHBqTmxlSExRbVFnTzRrSmdZVGhRY3Fk?=
 =?utf-8?B?WGUyRlFnM3ErV0xENzZOZFZKeW1iOXFsVW9EU0Q0RFRPcnZoeVV3VGtZcS9R?=
 =?utf-8?B?Nk01eVg1T1EzdmRzUFB3aE5GWW1XZFNxcVdBRGU3RXJzNkJITnBtV29KaW5E?=
 =?utf-8?B?QkxkdW51c0xTMEZsd0orQ0wwYnlhK1htc0dZTExjM2hERHZHVjBqdlJvZS9U?=
 =?utf-8?B?MzhreXFQT2o5UFVhWEpQR25CZit2QitTeHJzcnNCcG56Qnh5MHRSb2s1Z084?=
 =?utf-8?B?V0VXWXM2d1FKY3F2VU5oQ1ROTDU2bU1UWTVNaUh6a1NKODFINHFHekQ5VC9Z?=
 =?utf-8?B?SENralNUTXIxb3hFUGRGQi9SNGZzMmFHbW1RTDBtREovWkFOVWRNc1JqVGJw?=
 =?utf-8?B?enB2T0dCbml6THBmQm4yeG9uRWlkclZDRzdRcjN6THU5L0Z5QWk5ZUQvQjNs?=
 =?utf-8?B?MS9tMFRlUUdwTHl0dFhiNFFKQWVFRjFadlZnd1dVcEM3amJ4UmhaU3FEY3Q0?=
 =?utf-8?B?Y0hHNms0UzlTazYyS3Z1RmhWYktiTDlKUVlRRkYxS1ZUb3MzN1JYUTFsWmxw?=
 =?utf-8?B?RlpCV1RIV09mVDNjUmNVOWZwV291S01WeUVUeTNKemNNNEZPMWZQY0p6S2ZN?=
 =?utf-8?B?RGpKQTNId1ZvZ2dGZklQeDYvb3pRY044WXJHM0FDeW9NTlJEZFpjbzlUNVhh?=
 =?utf-8?B?V2N2dC9ScmxOMlE5REhidzdsc2J2cnpSa1RydEpwaEtCd1padEFNa3QvOVVr?=
 =?utf-8?B?ZTVnQmxEbCtNaDNYN29KVTZINGE4U2Vra2tibllybU1lZzhSZ0VhekZUbU5H?=
 =?utf-8?B?QkJZY3BhZHlTb0R2RTJYUU9TZFlZWm90bUVHbzNCUGVDK085eEhMUkt1b1My?=
 =?utf-8?B?NElWZSt0UmJDRnFxWFZjcHhBWUF5RXU3dDR6UGxpZldDTVRiTWJNQmxXM3NQ?=
 =?utf-8?B?aFJaNmJkdStpaDJ3TG0zMWJRZWpNeHNUUzNPUlBYS1NwdDZreFIyQ1Z2QmFj?=
 =?utf-8?B?RzNyM3NHK0luam5sZldXSk9TUHdRTWxaUGRBbHJaOVdhTUtjMUZrT29Gc0cw?=
 =?utf-8?B?Nkh2VUFmNDlEdVVZRUdBMHFPeExhMGNMb2VWdkx6MnRYaDBreWZrZ3AzLzk4?=
 =?utf-8?B?UkdyWUplZXFpSDBwSytFYmlsWERmckQvaUcrQ2pSQnVnd3paUFVzcVVCanlk?=
 =?utf-8?B?cDVOU2pFZWlOSlNhT3J1ejg5ZFZMeTUraHZQeXpQTmpjb0g2Q09pcTlDWjk3?=
 =?utf-8?B?bk5OdExnY3hoNzE0TnlkaWJvWDl1bkhsZUVyMlVPSUVhcW5Fb3owUW5nT0JT?=
 =?utf-8?B?eWNYQkZJWnRHQUtLUVpwbitGaTRQdWowOTY4NUpUN2ZjazlhczFhM21PTldC?=
 =?utf-8?B?UCt5M0pYZ0MzRWtvd081RVZIMFc1ZjdFNVlkcThWeDBZdUl4Sm1OTkhNY0VL?=
 =?utf-8?B?ZlZnRnR1NjVpWUE1eUpOWEtpVmtkVWs4blFrdXFPRjczTmE1RU5vdnQvTE91?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nDZLVVg3aH1bseOds+4WqDGsnB+wKIYaEUGLxNHfnnFjDhplf4yDeYEYBEOS1R0MGwCekX2hqLjXIMbu3GIdT/uAyLVO1EoXVCnXyhZ/AnGGu2GQGH83t1ZkrzI0kqvaq2nqTi62YLHcmDZw/ZOSFsboaRJ2uy3E0kGP1Q9C2T8/adX5P4bwG7ccNDEwc/cleywMUPFOhX1ublrJdpGpHzRiL8cHbVh5JwkF5gx/BaNkMPO5kfdveYbH+C2mSqV8D/qgJv07Ih816PcKmyd9iMvPieLDqKTFsQJhpIsRNFXDt+7dTRPoz1wdmOyprN8aERroIdGPi0RD+f7ar6XgoxooHV249ykYtM0c8g9c19wziHODwpVmeFrFy4E/H9gMPwjKaoIw0r6JqxMEsMb5tMS1xfZX4BkPGv+0DxBCiVvxEqn99+hk+fHf0M/hYKNSW+ur4bfzQyo2UwMCEtej5MUYGGAWBneaV+mOs6Q2OxwixWBTz1VOFXkoLok/Hb6+iD39AhhPz5TlohU6X7dDoOkbqoPqw+DPTEqaRgRrDAgv+82I94uVzihHNv+7cWP707CpbdRQKMlOdP6mwvPATQZ6wNpgf1trkLvKmDNTHq8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edbd935-324b-4f88-4e3f-08ddb948b16a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 09:13:22.7220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9ZsnrQXBUGMPiEpCNuIJTMbZA5ZlPElYy4+uuEq0AXioIRRDxfuyZKfITNwD3dBuOBfpGc66imtHkzUBVFq3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6842
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-02_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507020074
X-Proofpoint-GUID: B3ZOwgisJDDnQ3-y40iIzjrh369DNUJr
X-Proofpoint-ORIG-GUID: B3ZOwgisJDDnQ3-y40iIzjrh369DNUJr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDA3NCBTYWx0ZWRfXwA2ZX34CtGfA BusMwcIdiFi9PJM34ZUfOj2iaaaC0prWzpOACz81LXfk5VF1Ng0hWQW5gR2DfoafSVflEGM4Rci NhZOy1uUqpQJhML89gmxaZQfmr4e0OSYIdXEMKx78Blj45HPYyxC459qS5IPh2xJrrPQgK97b6d
 Y8uNyNIi1RFonH9RFoLJ9VYjmKt8pvvGXVj6aph4ItRVQonNpwUiaYcYqhJZk8gOuA1akUoVCnL W6EPG/m94rG6/a3JORVHdfurT1geHxhHkPL9UbrOEn2Q2427h2GxcsKFIRjXWWGfhYgbhPopQJ1 8k4Y/IAacl9igOPmcsJRtThFWBYBrXfAO+ByL4u+w7usZ3/jh6D0fKmksYUlyYHI+0JpKVPWDvi
 R4q1yquwO5h+LHUh6TujQaiBvdwOO5GT1uMM6ca97gSl0jrYQty4X+mqNYVTmndsX1OzmpuX
X-Authority-Analysis: v=2.4 cv=ONgn3TaB c=1 sm=1 tr=0 ts=6864f835 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=S9vy3hayh_c4Stu9GNMA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13215

On 01/07/2025 19:07, Darrick J. Wong wrote:

nit: statx() is being moved as well (as statx.h), if we want to be more 
specific

> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move this header file so we can use it elsewhere.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Regardless of my nitpick, FWIW:
Reviewed-by: John Garry <john.g.garry@oracle.com>



