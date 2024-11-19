Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C5EE57D
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732025473; cv=fail; b=Qo7T4b5ttHzwR8YfnIDrE+8DTP0qpxc9VB1aGuixd6kmL0mczdEdtCibhlR+xg4QqlLNONsHsdzhG/Zu4MfMDJabTgPAHRdD3gM64l9xMhLK+iEu6eQK+lW+j6XSVLv2fyoQze294ftMhkwOiMPK1QO1Bf5MG3gxIard7eCKPnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732025473; c=relaxed/simple;
	bh=KQfGq1LoYVvY15H/p2wp5JEh1e/KzZFbXXhoCza0lyg=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RKgE1k3QLmFNvP0W1PV3h5jGtquXsV4m3rhwr0WUSP1n1TUgzw5NKQ3kTQ/ptcAAZDjg+ZUzySiIdw7Hjios70xI7bUi1crOg0l8jJndeg9HtnE0EfVsnoSvEOa/Z3auZDAW2MGtegQfZDo/GrLQPAbdc3K4F6vyqApDnhHkv5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NKhEiXMq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E4CvExAy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NKhEiXMq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E4CvExAy"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJDhLna015229
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 14:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=o4Y5Hh0xeydp57Wf+gWtoRJtE2/GPVlizgNO8EgpbgU=; b=
	NKhEiXMqX5CZafcsb4ybx7XIBgnm8l4ylQ7fSzTjvolbEuMB8+ciHKPqUjp1udZU
	K7K3FPMQvu7ymzMZy4QNEqpxRJT0ZqOJJpGC++ba7pqiyxR8S+UJ3BVXzpDtYURr
	VhSNn/YxPpI82Md2cEel1PT8ylZKvNaXb2j5zAhtmJvKR7z2e87DrilmGEW5uJJe
	yyY8bdb3vN7RchFShulaRKF9OSNuGTh1WiuToN4kmuiCROB/ipoE10OmOxMyK9tg
	R155Uwex3GdVbzGuZm+x26KCXBRhcYvml/lxYgGx2QyqesALxK0bxvc32sVdV9wM
	ALTIjKRZ3LjzeU3nryXvog==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xhyyd1ev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 14:11:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJDiZgV009110
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 14:11:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2045.outbound.protection.outlook.com [104.47.58.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu8sdhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 14:11:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nCy6iA5Ei4RBIKL6zJ8KnCSt72ZnuWV5w7q4xwA0F+fJ0Fms2Xf6x72rXnCd4XmarhllG7/cOHnuBlI1iuj/HuTShrS/4N0QSWD7OS1F7D7OLnesAqkd7sWxT632vyI75zPW2kRZm2o/LD+5QGHjnoSB2ZVIwRZQonGdCLBT9UPlpxysCki46K+4klO2jN76aduV22Ku7+eGewQoStOcnF+U1W2+FDktj/9c+aoCEIQwAV/b0GEvpOFtqsLRNF2v1nxHmjfKSwRNY09ytzJsq1mYbv2eXjljpkh0Nu6bCCzVnyYKjwcdrG8kfS7XmV2TJcMVw0RCkybXpF7sCynzog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4Y5Hh0xeydp57Wf+gWtoRJtE2/GPVlizgNO8EgpbgU=;
 b=lwb/vFDK6B3PxfI0tiR0MnhUYqbOF5XfSobcRVAmRfl8AyYQmOqLYFPJiBP9KRGQ49z4QjG6PMRg9nMduzpvgkAcrfWGt1mx5iLzbz8kXsWonFEqNKqQuinQCh0du1V0ZqAakj0dUllNtJ3Zdug4hJWKuO53Z5HvBMCSjppzLMoIyGcCAQ8bkaHcvyGEsBdLaykM1RkDvWiku69Po6f2C6xwQ0xGi8KiDxaegn8mQu+trkfa3kIs8RiVrehJ/2i9aGGlNDeFW729niFtZBk860FnxZ+id7hpXv+B6Ue0m2PNKRsrPDvGTsqlHAV00LHFdy+DLG2vnYN0TdcpPc5edQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4Y5Hh0xeydp57Wf+gWtoRJtE2/GPVlizgNO8EgpbgU=;
 b=E4CvExAyWQZSrgsemQe1J2SlS9s6nkyEwd6mtnuBbA5FdOfHToMMSOb+Z1sooh2ldTf3clnt54eX0lMr5/HtT075+wdh+qdYLnYM8Hrf+lp0UskDmR6bZlg7v0Lt3cNTa8Gx06Q1zsMfzqfoiClNqahihf2SxcNY8bsd5Z9N6SQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5064.namprd10.prod.outlook.com (2603:10b6:408:114::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Tue, 19 Nov
 2024 14:11:02 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8182.014; Tue, 19 Nov 2024
 14:11:02 +0000
Message-ID: <6657d426-d227-4679-b4ca-db64d39140fb@oracle.com>
Date: Tue, 19 Nov 2024 14:10:59 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs_io: add support for atomic write statx fields
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org
References: <20241118235255.23133-1-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241118235255.23133-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0452.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5064:EE_
X-MS-Office365-Filtering-Correlation-Id: 857b7525-e5ee-4b51-e3ba-08dd08a3ffb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emg5cjZRZ2hFOGhEWWs4UXNySDVxcVFuam5DRURha0I4bXdZQkVDc2pwbytt?=
 =?utf-8?B?YlY4aTREKzl2T0tyQ3lFQW12WlR6QVRjNmVDUXU4UUFXNTNlcVFvcmY4TGtH?=
 =?utf-8?B?LzJWRThqcmFmaUVqYVlqaTB3VU9heTdqMk9JQU5nemNpZnlxR1R5dzBzRmNL?=
 =?utf-8?B?d2hsWnpFVFI0OUprcE1MeHVrUFZOMjRXNzEvZmVOYkhPVCs0Z2NUcDhXREZB?=
 =?utf-8?B?bHUxOGh5SVk1QlJFRDdWZUFlV1JCWG5tdVFMRFpiU1JpTTQwT0NkNXBwNmph?=
 =?utf-8?B?SzA0NVNSdHZndmViNllvVXYrM3RoREIwdFJCZEZRTTk2bVA5clJ2SEMrUkpG?=
 =?utf-8?B?U21ZMTZCcThXeHZlSHdLWUVzcDlwdVBWRERhMGE3Wmp5VVRCWlN2bmYwNjRO?=
 =?utf-8?B?S05Xc2Y4QSsrdjErcWFUaEtqUElZcXJwd2NtWCt1Z0NzZmZYZnAwRzdVQVND?=
 =?utf-8?B?T1ZReVUrRktBb0RkVVljalF0SHhPQ1RVd0tua0p2SEhnazdxQnpVblp3bUFB?=
 =?utf-8?B?V2h0ck1uMSszMC9tUEU0RG04UnN2WUd3eWxDTFdtdkdUUVhRamE5TTcvV1dm?=
 =?utf-8?B?ZWRBK0tvRDhrWG9OclNpYS9ZK2l3aWpjTUZvM05Cd0RpZUtuRk5WT2ZIZGhF?=
 =?utf-8?B?cTVHL3Q4N0dDM1ZiSXBOK1ozQUJEUnUvRm5zckFIYjBWMll6ZVBBWGsyMkV1?=
 =?utf-8?B?R2dnNWg0ZXhaNGxCUFp1ejFSdUtJSFBNTnk3WWNMbHZlcWRCOFNkWVNvWm11?=
 =?utf-8?B?MGszd3dsOVArc3FxTGhNNGZma3k0d3A2M3FCVHBxVTVRazlRUmNwSHppQWRs?=
 =?utf-8?B?bHVkYzNiUjhieGM3QjNZcGZTVFExRTU3ZXlPdzh5NUpXbnhXalpES1Fndnhu?=
 =?utf-8?B?R0xyRTFrZllja3k2bTBGbXJjTUxlNU84aklqanJKL2NGdEt1ZWxOaURQYjhu?=
 =?utf-8?B?cE5uby9URml5ZnBTS2dVSFdQcXdQUzNtQlc2S3FkYjkwbzA4QkNnb3p5aEM4?=
 =?utf-8?B?bXdNblJ2WitEcGtqS2haNlJXb1M4QnJ6bWxkOVZvWCsvYzV0WGNQbnJOekdD?=
 =?utf-8?B?RGxRaTFmb0M4UFJMMnk1Z0U4SlE3UU9ObEhIRFg1QkQ3M1grYklpZjZCRTZC?=
 =?utf-8?B?MG1GVVZGL21FekhRcFJIMmxzU0xjV1J0VTdnRFhGMjFzcnhiMTloWlVqT0Zu?=
 =?utf-8?B?NkJwRzhIK1dhREJQK0MvUjQyUzBKTlprb1VvaEJ2Z3pLSTVsMTN3Y1VWdHZT?=
 =?utf-8?B?NG9CSjJ6ajdEdTNWRG1FVkNCcSsvY254RWFRVE9KZlMwYmlUQThWL3lUNEJl?=
 =?utf-8?B?YVpKSU4xTE84T2FxM1c5REMrWVNySkE5cGIrclhKeVg4V0ZKRUd1azJIaFpY?=
 =?utf-8?B?YVJSZUVLYXRqYWJWZWFOV1ZpRkNwWjFBR2FPN3ZWaFZNcGEyTkVUeXQ3Rm9a?=
 =?utf-8?B?QndQUkN4UGhZY1VPNkJvMllRdDRHQ0lRcnduN2dxZUN0RDBDNC9NTXRFNUhN?=
 =?utf-8?B?bEZ3enBHWU9LdE9vbnFkWnM2SHFud0pySTNzWlQ1dkMrM2hSeVJzZlVOaDZv?=
 =?utf-8?B?ZDRIanJQTVFGdFFyREJua21ES2pyb2hKbERPeTV3S1FKMDRLUytYaktqVDNp?=
 =?utf-8?B?dmVWclp4dS9la3hYYldCd01rYkdoRG9YM053SlpLUlA5OEc4RStrVkFpRHYz?=
 =?utf-8?B?S3dGN29yQitJOGd2OFNzbkIxUllsNEhTbXc1aHVtWGlad2RuQWdvV25jK2Fu?=
 =?utf-8?Q?XVia68wfNCI66Tv3o+W46R5XftXUNLzPKwY1YNO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWZ4d1dQZjJndEx0aWo5bnVJOUg2N0VlcmNadEEwSnhON2RKOHlPVjBWTTJx?=
 =?utf-8?B?eitVOWxDNDkxc01XOUpMZC93RUJTZzNYekRLVmhuR3dsVWhDRFRUcUpSWEdk?=
 =?utf-8?B?YUdhV0VERjdqdmZ6OFdmS3g1bmU2OXc3T1d0SStmWXhzTzcvT25BOURjSHFO?=
 =?utf-8?B?T1pxZGZXZWt0UzRuZDRvYXFPUUVuZE5XUU12MlI2NUFGWEMrYitMSmJiMnlj?=
 =?utf-8?B?TTBoVGg2MTl6RExCVTlCcjhiNCswcVd5OFlsUmJNRnBPZjB5WVpoTjNrbVYy?=
 =?utf-8?B?SkEwekVHT1o5ZXJBYkdiZHpkVjJXa2t4MmxoVnZtVDFSdEMxUUR4eFVzcmNn?=
 =?utf-8?B?NUZVcXY3ZkpJTGxTdE0xaDluWFEzVnZ6L1Vha1FQTk9LMi9uV1gvNndDWXVC?=
 =?utf-8?B?OVlZaU5FWVlQVjlIYmpHSVBkVmtkTXg1c0RkaTdKSEtNclU5UkMyYmx0cFNz?=
 =?utf-8?B?KzdTVWp2SUFGbHhpT2owRFlPSHRMOGxSM0pNajhHMFpjbFkxS0VEbkFiVVBu?=
 =?utf-8?B?TUZpT3h4T3NBM1pBNnFSeFBpQWdUM1EwUENjUW4rZG5ld1VlSmU0UDRYd1kr?=
 =?utf-8?B?SkJZbzdyczRhcVR5L3pPeENZcDNMd0FZZjIxOXBSaTcyZHZFTGw5bGtyVXdD?=
 =?utf-8?B?T041dk5Yc1dIRmdpRnBTbTQ3NmllUjZyWCtMVnpjcW1ZcVdIWDNzd2NBOVZJ?=
 =?utf-8?B?OVBMYTVKdXkzdjZKZFB1eVQwS2FqT0FhaE92ejZ3dWlFZ3RDOUNjd0w0OUlX?=
 =?utf-8?B?dUs0S08ya1Z6SHA2YTZIM2F4YXZXd05NMCtJajdqZGxrOE4rSSsrYkpFa0pH?=
 =?utf-8?B?U2g0UnhFS3lrTUk1ejIzdlpCVklLZW5LRG9mbEFpM0hsekd2MEwxL1FxMklT?=
 =?utf-8?B?Ry80Yithc0MrSkJxb1draURJZktwVVRvNHBQem5peUFZK2I3cFJoVU5LblpT?=
 =?utf-8?B?UjVUaGt2R1JVbFZvbXhQTkU3MDRxTkFKUHFTTWtVakc4SEZZTnFhb1FWSjBj?=
 =?utf-8?B?VHFTUmlJWTkreThzYmRWem9hRU9meUI1VXA3c2l5RGcrOC94OENZM3JxY1hs?=
 =?utf-8?B?cnJEYVhrYmFEWHJJb3VyMDF2ZkF6YVkrUW9SVXpCWXM4MUU3Mi9Neloyc01q?=
 =?utf-8?B?SWNKQ2RDbHMxc1ZWOTQzS0NGUm1DZ1Y3R0dKYWp6WXc5UGV0cTdSQnR2cGNI?=
 =?utf-8?B?dmkrZHVYaXJTbWpMZFJCdHRoc3E5Wk51SVI2VmdzOUpuSkh5Y2grRm5NQVcy?=
 =?utf-8?B?UVZnS0dPeTB2U2QvWDNJSFk5MkVQN2s0cHBnMWQxczhoRUx0Y01kckVDTTVY?=
 =?utf-8?B?N3dibEwrdC9kUUJNTEZCdXczWmY3NndVWGNoQTRDWlY1bjBUUkhEeDlhVmRi?=
 =?utf-8?B?OU1QMXpua3pJdlkwRzVGd0k3S0VPRmZVYkFJc3lMa2FYbTBPNTlwTnM4Q2tE?=
 =?utf-8?B?cVV1QU5qM01HT0IyQW5YSGtReFRhUjUvSXBYS2dORkZaNENxRGRZRHVVOVJV?=
 =?utf-8?B?Y3ZZM1lXWnZFcC85UWxyN2UzeGhseEZyYVRHWU1zSm5HWG13THNoUlBqYmln?=
 =?utf-8?B?MFd0TWZaQVJIS3owaGFqa0ZpdzczU2JCTmxNNDlzVUQ0akR1Ukd4SVNBcFk1?=
 =?utf-8?B?cTAvVGhud3NNbHlNM1E2blFzSlo3dlFFclZubU51ZFN5dlQ1YXZHdDVkSitS?=
 =?utf-8?B?NnFhMXhWTlZvNXNPUy9aZFBWdDhwcisyeEpjMUxOOGxxQW1uQk5XMXF6Wmor?=
 =?utf-8?B?MVNYY0V1N0c2RW92RHllOUFZanNuNjl3a1BnMEFDV2NETGZzT3lpSmVJbTZ6?=
 =?utf-8?B?RytPNkdqQUZraWYxZDhjOHlHTUtFNFRDejJ4aDlWRGxla3N6SVIvMTY0b1Nl?=
 =?utf-8?B?UUJhY0tLcmxmVjhaVDkyRjlXQ1oxcUtvNFNwbFI1M2UvalhFeVBRSHQvQTA0?=
 =?utf-8?B?cko3WityTDF4ZnE0YU5icnhzODUrQm11bG5KSG5aUWhtRGhDK2pERkpSZnAx?=
 =?utf-8?B?VTBURDRmUzAydUp5bUNCaDliZSsrLzloY1ljT1J5RzZrOVpiSTBobWJaMDk5?=
 =?utf-8?B?VVE1N2Vhc2w4alJDTlNRUWtyMzVZdm8zb1BOTW5RT0hoK2YybEFTRk5mci9F?=
 =?utf-8?Q?lWXBDuxEFWEVW+ofVxnK+tedu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WiY6FPH7iQsRkHey1T13H7+kLWZuD62+1oSO//9Y1oTwbldRZNHsWdCmrNP8t7FUo8VmnIn4GpKSHTVS0uzokShJSCG0neSr/8EpNVbYmj1j96szu6OhnSQQqoQz/gP/wyrzZch01Ok7TfjtDZz6C+p+0/KwLvDOn73mu2p1Eo+7Q5XUGP42RLM0a6lAntZoGy5+xdTsz8ulKRW7dX5CHvI5I2rogwktXntVegAKOr8Foo/PMOiGkXRFn2HF+StdJ/xMhB0lL69PGVzJq5HlGEahsaeL7zb5LMuS9RCdf4vyFXFT6ZHMHtbkXuY3UZUNLqzCEUJwWRL/8QDDTvqGlhFxyB/5UecraeQf+dE2PAZWB+yt2VxnG1/K++zRrymktF0S1DkbVWTlX0DFXljDkdIJQr21oKQ0HyJCWfz49lu1dD9M4UsoCkRr372c6JGaTQQHzS/o7QSl3RFT7wjIJlwIul1trpsXEOvbGj8JmZEsrko1357hrZnnN/77mtUHa8p1HCtJHnI5NFZ8jBLpAVBbjtket5dPUkRDiiNr2VRSkhcxMV/8LYJWT+r+L/nxhenMAaOh5/KwWwahqyTQ+QHWlWh+kSw8KH2WWrTy/6s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 857b7525-e5ee-4b51-e3ba-08dd08a3ffb3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 14:11:02.2177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgg36iT+2pcby+EPJXeC1JK6lKC8PP6Tw29FuVuSZ8GsG3ypwA61WH/0qLHWCUg61sGeApuB4pfj0Ytav+Jldw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5064
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-19_06,2024-11-18_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411190103
X-Proofpoint-ORIG-GUID: DuVZxon1cW3P0MxFAerQb0fG-kUe_M_A
X-Proofpoint-GUID: DuVZxon1cW3P0MxFAerQb0fG-kUe_M_A

On 18/11/2024 23:52, Catherine Hoang wrote:
>   #include "init.h"
> @@ -347,6 +351,9 @@ dump_raw_statx(struct statx *stx)
>   	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
>   	printf("stat.dev_major = %u\n", stx->stx_dev_major);
>   	printf("stat.dev_minor = %u\n", stx->stx_dev_minor);
> +	printf("stat.atomic_write_unit_min = %lld\n", (long long)stx->stx_atomic_write_unit_min);
> +	printf("stat.atomic_write_unit_max = %lld\n", (long long)stx->stx_atomic_write_unit_max);
> +	printf("stat.atomic_write_segments_max = %lld\n", (long long)stx->stx_atomic_write_segments_max);

Is there a special reason to do this casting to long long? We only do 
that for u64 values, I think.

Thanks,
John
