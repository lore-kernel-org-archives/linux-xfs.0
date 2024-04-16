Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F3A6BFCF
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 06:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713250304; cv=fail; b=uSP2xL/bfbBnoChzIv7HEId3en6pZykqc+nnluHKtlGvi77WSIoDkDhTdm2JzbsXocqOFyRwck7aX67CMUWp4iG6j3DUWk/XcfCGGJK3lpwO822f+ls7vhfc8CsAPedfXXDYGs/WprbCRmoF5+dbEO/xQlwX/4+xeBml9g/Ctho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713250304; c=relaxed/simple;
	bh=buRYCBz9xKO7eeGo+TlhH0SIqI30l/yDh/QNC3nJhhM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ubv7ify0RhO5Gki+DmRV2z10Rwt/WeF1Zv6Pr3jYOmC6r2hvSl1ysBvwRwIRKsrm1ElFJsoakdLVEP5n3TFa8jlYR9ICa2efQDyCw7s597Ns+D79mLfZwDFc+1ojIuolt8cb66V+0Hf/tJUHoKbGXeP77EaP2YKNvBWoehs6Q5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hYSSiE2G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qTn31XCN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hYSSiE2G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qTn31XCN"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43G5FXQ9015508;
	Tue, 16 Apr 2024 06:51:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=B2+MzH3eftOGdG9F99jePqk8j4p+xLanWL9tXldXdZg=;
 b=hYSSiE2GWFvLHUCu7KrqLixjz8XUviMQJyuf4uK1d1+bh2LlaXZWCaLOVnfydPAXy0I8
 L3xhfJep47MXxXgviZHNn7OrpO+DiiKqpLUpXdGqvRi+NwJLMZSxs/luUa+5J23jGrQ1
 3JYbZsLyljx1Pcm58vr9vG5iHZTrD3Hf5M4fusQ7rNwXzMVZRSHKdkH4DT1fHLF96JC5
 6RNE0eI3UTOaSk/0vDIz/E6FcNuJjZXAl7RG564CJBPjNEoDu6b7g9R8Lq+T3UkNddVp
 tek5yl+4+KZ/2b69TWRRdPHqWgR8XCYoCHAt00Q5M0RQBtCi6GPB4XfxAwp7dKJXQtmw hg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgn2mfvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 06:51:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43G6UaP5021697;
	Tue, 16 Apr 2024 06:51:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xfggd30s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 06:51:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8d8N78+POTGZ34nHA2CkqXVgdv1FvtiqYu+6Q8riDZqLdBfoT0OLi5vh4GlePupqam6yC4WL8U4sJmnOEYlwXf9Wj56bUsQvSHckeSUXXjxD1ZDWdaUnqBYLseCDiD65SaBUg5vuHJpe1y2r+f8y7JkFEJKIU8PKcf9o0jn2VRp0habAwoKN/5r8CF49kq1qVsphL6DIintIX7xOTkd0cYnhSxU2NUsK4iMrAwm6wWIJ2drpAahCoim3ufAEh4kv/x77zaeeQ9zvDGZlOZJVS5ZIvPMmR9ca8II0H6/TBFVj3ltqP40cJGuvfoGFwO8PeMT3culEC5fOBIjLGsMCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2+MzH3eftOGdG9F99jePqk8j4p+xLanWL9tXldXdZg=;
 b=jWAkl2zvXgv5fuyNfg9dFZqThNt74s5hGny2C0qnTDtGSEP3fS0o6ipfcvMm7I7O7gi0QdJZNs9ss0nRJ36B2zHsfi8k5iV9JIBs1J2c3CzTCnk2dpjT2mSbUEbkFepL0Rg/oYiugiHK0Fvz2+WK+qn+C685vLlhiV6Fd8+Ptm4/PaVMt2hIdPCLdmRFAYHfHeTR4sEZPUz6EJMc7JosHuhzaNvVqdeqTmF61ks2VCQQbITopiM4ayGuBw2LHlihhT9T3TeMbwU9/3XjIDxp9AN1Ua8e+DyTjD3mrq0H5+0KwoN5MZLzOZVTMrsvOlRRr6FnCCD1msR3quYgl109hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2+MzH3eftOGdG9F99jePqk8j4p+xLanWL9tXldXdZg=;
 b=qTn31XCNXhfQ5v8f/2WTqg2yDRVJx8wuQT2tRfVOIer5vS5uHecpQRrgvpv6XxPsM6ZMrX+FbTKPbFZMIRqJpp3Q/4PdRbVyTk0MVcMYNBJlN/ehop8fYJyM7mu3wJWsrkNvtstJY9t8gZ1uUhcZVXsL0ZPReQmwrOqyLotFh6c=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6837.namprd10.prod.outlook.com (2603:10b6:8:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 16 Apr
 2024 06:51:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 06:51:32 +0000
Message-ID: <90029ad9-5848-4fc1-ac0c-763ca96a3ab3@oracle.com>
Date: Tue, 16 Apr 2024 07:51:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] xfs: allocation alignment for forced alignment
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
References: <20240402233006.1210262-1-david@fromorbit.com>
 <205661cb-6d7a-46e6-96fc-a4ac9480bebf@oracle.com>
 <Zh3Ih/T7jqOHGQF/@dread.disaster.area>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Zh3Ih/T7jqOHGQF/@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0392.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6837:EE_
X-MS-Office365-Filtering-Correlation-Id: d637211f-c87b-4d03-b561-08dc5de1a661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gDRe2IVic6VuPGPoQ5wPgjKOWW2ZRomRerIKKRaqNYpUYif6MLqv+KtXHgIl3lCFgOMe7vdKUE8wlRcXNwb1Yy38pTIJ9OG4TtUBgge5uEx9bLBYwWhAp7mZ32TxSC0pggd8FY2MiDzXYdI//zxtnVOpD1nIb2fv+yTbaDelX3N7nGw4k/rxNF/rWepXtnm81bLOsbjqqshGePgOn9DL2AkRtwPtq1IkPTNX+5Bwr7sAWx1VrhZ3t4bq8v7HPSJqUuAK6PdeSlummw+uhSpGcoLWSk9smOsmlhFm7QQyVjncmBweisc8XP1jxPpx1Jzh5m1ufNEpX5e41/D+cuNHeDCxL3G1d3phl1qq0lwxL/+ToKxrS5c2TUWuwkd2vxnf3r9TMkhaaIrJUFkgEWOV23dOYYzwnPyuVtXIjz2WCDBqGmtqNzv9c/pBS3vVPqEgZtNDgWJK9yJxPrcuwpjqFFli2LD7/MNtYzHd4DVLdx1vGpH0lM4TxNRfixAxHqYXJJ7re0sN+uht6fwI99pNyUEpMb31WPmK3ElLRPS0p2jY535mMcX940syaTlcRlAllpu6IdB5rAcpZyti/+fCmSKmnRdo6ppocgxhbLu0z1GWXoxwUtf9Lw2Ub3hmibXghAvlVkEhWziuvwASfgis+myaSDrd2658SKntP8e1zF0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VTljZ3JCeldsbDdaT2hicVJTcFBWYmQzOXJnd0taK1RaNnV2VzRsQU85dGll?=
 =?utf-8?B?ek5RK3hvNHBJODUvVEh3cktLTlFlLytoUVlJSXRLZTc2M2xLc3dscW9UKytF?=
 =?utf-8?B?dWNOb3prQ3VpM0NkeFc1a3BneFNSbmd2dSt4dGU5VFFQTnVzNVFsRmVkNlk3?=
 =?utf-8?B?UHc0SHZnY0F6a1pzRW9ZdjIzOVdpN1FRbFltc1VtQkpIY25NYWs1cDFac2Nu?=
 =?utf-8?B?dHFKa09icFMzbE9yL3pEdGNjdjJNdmJiTUdiWjVMbk9OV1h3M0NwQWtoUER2?=
 =?utf-8?B?WXVQb3BOSWdvZXpYa09mcittZnptVjQrc2o4dU03S1d5bGEyUDlobEVYbHZp?=
 =?utf-8?B?dlRxZElyb1Z0S2xWOU5KSkJEbU5waHdIajZIZFZ3R1hTNERFeGtFU2VIMCt6?=
 =?utf-8?B?ZGVpckllbC9KZnhXd3hQRkthYTB3YUxDNzNPOVVsUnQyQ0EvTmduWmRqM3Bs?=
 =?utf-8?B?ZE01NkF4d3UrNUl1ODcrYkEwN1hEUm9IT1lGdm9rTXI5Z2Rtb081Tnk2eEtR?=
 =?utf-8?B?K3R6RS9tdk01eldOZkpYdlFBWFVtTkJpRHE3TVdxWVNzc3k1S0w0WUlsQndG?=
 =?utf-8?B?OTJtTkR1YjZRSUhUalVvRnNZYW95b2NrL3Urb0JGbWR2QjZsNVo0S3MxbE9L?=
 =?utf-8?B?YytkeTAvazV1TjBsMXdiWTU3KzRZdVRSTWo0cXNCRmU1ekxienoxdHdBNkVk?=
 =?utf-8?B?VGpUQUxKY2djN0R5WnhWYTBhMCtDQjBUT2lGWHhhYUNiUHFJRG0xT0hEQ0Ez?=
 =?utf-8?B?dm9JUkp6WWJhbUtEWi9ZbU5YV2dzREpNTEIya1ZubzRzRGdrR3BHcjErNU05?=
 =?utf-8?B?TWlaeHFVN1Q1RW9NdEROTndBNjJjTlk5cVhTWEhLSkhQZmJEYnYzUkFHOVR4?=
 =?utf-8?B?QWhURmpBcEhwVFZmek9IS1RUTXFuaTk2SWtrUGJJTGcyTFJxMUozYlhlUDFX?=
 =?utf-8?B?R0tHU3dOQVpwdzZ6bGVWQThOTko0NFRPYURpNTdTRjQ4SHJKcW5HejJDTm9v?=
 =?utf-8?B?L1IxVlRGekdwNkFHT3pzVTZscGg3NWgvMmVvMXBtZEo3SXFNd1laWThmT1hU?=
 =?utf-8?B?K0JFamlaUk5VeThkdXVIWEZWT0VKazl5VDZuRnc3UTNaNzhSVExORzlvSGto?=
 =?utf-8?B?cDRWRDFqZ25qSjg1enRzYUM1dGttMWVoTU10SUNEd20rTjdrb0RIekZVcE9r?=
 =?utf-8?B?alduVlBRQWV1bjZKZmEzaXlDQkwwN2swdXBQNFh4ZVhZSlk2YWxzazRCZWF5?=
 =?utf-8?B?TGFIRDVWd2ltTk8xdnhoVW4vMEIwK0F1NXl1cWx5WUE1RjBWMTdQQmlmTHNG?=
 =?utf-8?B?cFQ0cmRlOVNGSE1vL0lBWnpPajVNdW1SRHdSeGZEYVB2Zy9VV0I2V2Rab3hS?=
 =?utf-8?B?NVNBYTEvcFdDY3VnNGRuR3ROMkk1c0FCbHVvSDhCd1ZXOVFvbkVrQ1k0d3dm?=
 =?utf-8?B?SVB0aWV2OU9aUEFOengrbXppekN0NmtVcEVZRTFHUmhmWDhBZkQ5Z2t4Nkd6?=
 =?utf-8?B?dExYYkJlbklRb1plM2FwaDNKTmZRQXdBVGt1R2ptaDdteEw2R3M5SlphemlM?=
 =?utf-8?B?bmpNR0l1M0JWRTN0QnpxRDJVR1gxc3h4V0N2RHBJalU4anpBZHlweGRvbGRE?=
 =?utf-8?B?NWxMV1ZtR0Z6OXNkbG92V0g0akVlN2ZzQW5YNVhrU1ZDaFdzNXljcTRjNEM4?=
 =?utf-8?B?ci9VbVc1UjhiMGFmRGhuOG04VTlXV1ZOZU9MR29ZcktvRElvUE44bVA3SE5x?=
 =?utf-8?B?Mlcveng3c1ptMUUwS1FIRVVKV3ZlaHdGL0pHbGhyU2ljR3NUeHVTZUl2UHZu?=
 =?utf-8?B?K3g1UjE2Q0N2NDkveU5pcjVlRGR6bGJXa1pOQ0ZhbThYY2NPVzJXeU02YXc2?=
 =?utf-8?B?TkU0RUNWZ09aRkxLZGo3OGtCZmVaNmZPWk4zRGhlTXB1UnFTWnJIMENoUUdK?=
 =?utf-8?B?Z1JuU3VKVlpoR2lWVERFV0R0M1o3TTJxSGdEblB1dWJWQUU3ZGN5dm1LMmxT?=
 =?utf-8?B?SHdwT2hTa0RrbjlnMFdlNG5oeE9hNHprRWU4Q0hRTC9SMW5FcU9CWW9GTTBn?=
 =?utf-8?B?QVNGRGJiaFFKeXI3TlUwc1V6VmJad2JYUUNMR2twVUFWTkhQMlI3ZnYvVStn?=
 =?utf-8?Q?mK3UfhD003Sgqs0tpo1Lz02dE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KkLu7WxrPnyws745j1FEGTklxb/2vybrarhnq1Lrsl9p26lbtgwRf7EZJjZzK297J+upKTzjhg8cA12bl6k/u9P04fGjUDfrv1aqPj8WJg1Q7Ec2qeHi6z5RHALi/LUjFDy2kgagfSII6nF9jIoKyEocm6i3/zLI1K2cdEyQDHuZvADI7HQCpDsCqius34BVUjgTGgf70PGOt1YZBrjz3fIo11vzs6HWxlETd5V+NBc4qO2oZekNt2xx28EwhHFtNpiXCql7nkAFN3BnVAg3ZnOoH3Gvi/Hfjk1wSTVbl5R2ZLAVA4FC+y0VWfbWg1WJwTL3+RZDSQNP7ZzNJ+4OCEi8A2CzxxXLQqUrj0NwVh9qAfFgjByl2/Ij40JVdBht3/2wpVeroH9LoTUBe9stGKw0CqnsRxXV9KMrkSoW/0mc5IfNSIFz/FfY2A/wdwazIXD57nGzw2f8GKTR9RhD3zmJHuJYQYGDVTpxLEgk3rjZjq2vnNdZrKQQJUebXIvwGGEJtydyyuERzBHsNHuN5OzLi6jh1mre67/9z56tXU3TsbdtgKXsETx0N5qxXLvc93aFioqRXedW1tl1OAH+f0dOrk+21LStftdFcU+HJxc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d637211f-c87b-4d03-b561-08dc5de1a661
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 06:51:32.2839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T74EnMpgx+tcJda+yG3uk/KTkN8tbieNpoCBSkFh5RgU1dLLo+ATAdXbMlH2/ZAAaq1+gWBtQOdetOzxWwAWAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6837
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_04,2024-04-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404160040
X-Proofpoint-ORIG-GUID: 4yhlxqEy69fGvZjlw_Y1KS-Iq23_18Ai
X-Proofpoint-GUID: 4yhlxqEy69fGvZjlw_Y1KS-Iq23_18Ai

On 16/04/2024 01:38, Dave Chinner wrote:
>> This feature is blocking me sending an updated version of my XFS support for
>> block atomic writes series.
> So just add the patches to the start of your series until they are
> merged...

Fine, I can do that.

There was also a couple of patches which I was of unsure of here:
https://lore.kernel.org/linux-xfs/a7de9521-d101-402d-a59b-f7ce936ba383@oracle.com/

I was hoping that you would have a look at those, but I suppose that I 
can include them in the next series also.

Thanks,
John

