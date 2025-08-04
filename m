Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B8D17A2FA;
	Mon,  4 Aug 2025 07:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754293828; cv=fail; b=lMAlngrmXKE9JM1Ad8IxDq3PVRVbCrta3KHCZNOC0PR3L/+ltEpG5O+rwfiPdNMt2jByxCslCGDaqbOj9+5DLbFEQSQxowmo6JGB4kGtE74DY/kQeXl8gOuIR9t7rKWJXdCXA13kDPcKLgiK5hGDrL6ExQno1gtgftNHz5ytFU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754293828; c=relaxed/simple;
	bh=yq86fv4SlJBCtVCTZvsdXAzse3oZlDyuwrWwl10oZDI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DBmmW46hWF4hDTIa4PIv/hQ7a0m2LqAxCIChKJvnicSghurvS4fEN//FYn6qhh+TXeROe1rM1EIdo1lGoztO0QYmIowtdsl9uS4doChrV8zYE0qundhf9+5jJhituZCOU6LYdStNhItf0jCeOdsm1LYP76fwzzKAOkH9nZJqgi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ll7ChYGb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nb01FEg4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ll7ChYGb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nb01FEg4"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5747g7sR012312;
	Mon, 4 Aug 2025 07:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rMaKUX0Ei04vTFsmc8JpSc4AEwcgcfktMgAgElaEruU=; b=
	ll7ChYGbykUa83u5GKT6Bolnr3zp/+Nix5nEdCtDmLgcLsgsdikvdNT27WXKX1Mg
	kr74d7Zi5hlwGFhAbUjE2YvkQCpt4OvFCwHRLB0+ClingjEx2tr+UGKdCru9+Xr0
	4FpB+Y/Oje3pXAu92uj8SGBvAMszOcRudpmG837q6+d91x2KvowDmDcEJdBaS48J
	DIttk/Z1jGhDq2RKinoq9uDG/1mGrdhvEP0yj7xlMP6KMc8MTIhUztq9WQQmvlUC
	GZfhoCIvaDCDlSZqDEgJ1MSY7EIaqOUI2LHGV8aixSeg2k1aTUuYLbpwcKD4hRgy
	RMj9U+WozTLaTlJ+PT4IHw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489aqfj22a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 07:50:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5745rm6i028688;
	Mon, 4 Aug 2025 07:50:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7qcakme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 07:50:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hjHLbP0BpR9U87yIvxpjKkvS8sYLJSHeDvDoUDf/NrlFfwXFmuXEZz3tSYLFcDTwedvVxWWDUZzI1uGfhAVB8ePxTEjLihfmrI3ds9L9rzoskKQ8c1wMkpiO9ZXKw1YOSEZ5rxomTzs67be3lutX3cltxxxy4nPUOZGxL/1/mh+caeCZhJZKrHVPbTqIHzsoXHJtDv70gzG5KtAI0mXBraWXm/Qr9FhoHmDJXY4/EooJ9X5mRJddfvN/M44F8d7H+smpcnnxowhTWPazUdi+Tz+GPFkYXPsgUGl6yeVk/dzJhV6l9EapLnBNIPxjtIRAxOX2Uy3+HasAjObz4J3VzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMaKUX0Ei04vTFsmc8JpSc4AEwcgcfktMgAgElaEruU=;
 b=EjdoeU7QY/DKGYtod6pucShxycmOVbHJ1vNXccfSfY8sr52izHOBpq2guWbvdjb0RqWr6x7hIj2s8AzuBkfaWWschBpdahQSAKin/hF4nexC5lfYSDVcvNP3Jj8D1nSWT4KLZohjaO9zPup/+uGYTcFBg1epWZH0gT057mJEjJd4LwuDVcSA8BvXKE31n2EIsECHwUSaDf5Ccn5PJwbLogn7R39oo1E4VKLGAThTk8XQoYuuh1vyxcQHPwVAoIF6KbbTwtQJ3zK2F3qRRjnC6BQlX6jBQ7zfS1N+dFhjv+JcLPkWA8VTu22e5tWy2/jsUEFjZT9OzsbjbGoMyDFdnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMaKUX0Ei04vTFsmc8JpSc4AEwcgcfktMgAgElaEruU=;
 b=nb01FEg4EgQ3u3TdTUQgQVJB3NTHYNtx7iP+jo9DeMXEo8a/4YasgWGkegYVzIxYnTZT9jGYF2iybYCbFB2RvDDS91phDflb7lYQtHL8p5K9Og+eTH30nov4vxFhn7/K3FhqSjwktXEfcjGyXLImsmOA3poZqeAXKxHaX7x00uc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA3PR10MB7093.namprd10.prod.outlook.com (2603:10b6:806:304::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 07:50:19 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 07:50:19 +0000
Message-ID: <de5385b7-fc5f-43cf-9351-16024e3efd51@oracle.com>
Date: Mon, 4 Aug 2025 08:50:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] generic/767: allow on any atomic writes filesystem
To: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957992.3020742.8103178252494146518.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175381957992.3020742.8103178252494146518.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0227.eurprd04.prod.outlook.com
 (2603:10a6:10:2b1::22) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA3PR10MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: 1400c13c-b64e-429f-a08d-08ddd32b8eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anZGbkdNVUJlVUVjYlNadG0wSXRENjNiUkFia2xXYTBMdHNtOU9OaENtaTZ6?=
 =?utf-8?B?M1NMenEwY3VTR00yeWhRS0dkajFRdFJnL1lIOWdUOVBlMFFBMDZLTHdCZUt0?=
 =?utf-8?B?V0plKzBUbVRVZkJlNFh3K3JjdFk1SUZRUnpMNWIzdGw5ZUsrOHFDQnNxSFda?=
 =?utf-8?B?ZWdZZlFmM3IxT0RBQlFrUnJWTEVjSGs5V0ltWUMzVjJrYS9XZ2YvNDBQb25F?=
 =?utf-8?B?YUkvTjZQcUNTZHlvM09TSWowak1qMTlacEhxdHJpNXVyd25yTFpGZ3FBNVZQ?=
 =?utf-8?B?ZEx1aXVlKzNkbk9mdlBKRVBSdENvSEFnNlJqUWVmUndJZEhaWlhIUFFwTk1Y?=
 =?utf-8?B?U2Uza3k5TUNId2pqa2g2TFJ4K1hnVG12M1B0bjJGMmtHRlJHWVpQY1RvaEwr?=
 =?utf-8?B?bkxnSjJYbGFPZlRkWXFrM054K3FPV0R2VGV4RnZ5dVAzWDJWVnpQZFV2bFFk?=
 =?utf-8?B?djM0bzA3cklLY1hMU3R4YmV6MmlVUWZGUUxjQ2piNkJrQ2RmL3N0Vnd2ZGUv?=
 =?utf-8?B?RjdyZ0VsUGNKOXZmNCtKRXlZcE82cjRnZ1dabzVDMmRGSVdJWUwwbnVQRFFm?=
 =?utf-8?B?QUNvZGY0OGZJNGRqYkoza2J6TDRsdnMxNlZmaU0vMXlZWjhXNDgrNG00Y0Zz?=
 =?utf-8?B?eGs4NFlsUEZObys5aWptYjVkNFlpQVE0OVJ1S2pVWm5Ed0NYeTlMWnU3cjR0?=
 =?utf-8?B?NHdUOUxPZHlqZDRHb0l6T2FITUYzeDU2eDRVRWtndHZMNk1KYjBBZW9KeFJa?=
 =?utf-8?B?dDBuMUZqSGJhcmtkVjRyeWxHT1F2cUZjZGVpTGhBRnFvcVNVdGowU0VaN25Q?=
 =?utf-8?B?WFl2dENGVUgvMEEycTE0YnFtVlhKSE9YcndpVmlBOVJWSm05bVZ5RDlPNXVo?=
 =?utf-8?B?TGR4YWNUNDFtcHl1MnJCdEZ6Z0oyaFFzdTB3L0JtTHpyQWhXNzg2b2dkTHc1?=
 =?utf-8?B?V0d5VzkrNzdOWUNqMEdhcWFXaG1selphWU1IdUY5cUIyTUk4UW9Gd2wzNnBJ?=
 =?utf-8?B?OVJZb25SUHRicERSSGUyTnI2T2NEaEhnV1NYWHlncXdwamJ5ckczNk1VYjEy?=
 =?utf-8?B?eGJ4b1crTDlZNU5XTzY2R0YrU2JEd2JxS3JVVkxSQzdDNGJndzFDcWRwR0I2?=
 =?utf-8?B?ZDBjdzV3REluZkdlMVZBbEhmVjNUZGRZMyt1VUVIa1JiTlF4Uks3YkpqWlM0?=
 =?utf-8?B?YmVnVytSaTlJd1Vvc1crT0JYYWR0VGdzYzUyTU82R3VNbUI4QXNlMkwxam45?=
 =?utf-8?B?aExGY0JGdjVhMHJBMW5uNGdLRnBnVFRTdWN5ZTVWcDZBWHZRbk1lRk9ncU83?=
 =?utf-8?B?Y2dnelYvSUtkSU1LZUI4QmdLa1pDWTNUUFVDUjJiZFEzWDdKVHEzajZ0Q2NY?=
 =?utf-8?B?SXJQZ0YxR3ZXd0NKMnlqYzZUL3V6K25VSW9za2taNXFZQUVLRmFTM3lmS1B5?=
 =?utf-8?B?Y2VBYlZKZDRJQzNGSS80azdoeGdjd24rTW15cjY3UTRqRVE0VWF5R3VTY0FX?=
 =?utf-8?B?c1dHT2wrb0djbGlYdmVWbDZ2Zys4MWNvM1FUWXhCQlBPSndOcEFkaTNtZEpj?=
 =?utf-8?B?c1pTNUpiTmxWSmlYeDhNdkFZb3J0S2laa1lxaDNxUFZTanJqTk1idGVRS0lR?=
 =?utf-8?B?bkd1OVVVTHJCdWExd3lkMEFrRitKR0hxWjRqYXZpU3pxVlJQQnhETlN6MU9I?=
 =?utf-8?B?RUpEcWJaOUNDOVVnSmpFcXFLR3NDK2hRVTUrUHU1WVk1ZTVLYWR4ZHpUUTJa?=
 =?utf-8?B?MEROUE0yOXJsYnliaThOOGppenY4SlpaNkI1K2dpU2g3VlRDQXRxK0VZN2ow?=
 =?utf-8?B?L1pWSFJXV1IyOVlLby9saE5yaHUyYUdackdRRUVZRXBZSm1WTURPeFJFdXdo?=
 =?utf-8?B?dUNZQm5OZzVmTVlxVm83OVN0VjhkOFVEbTRER0VpMTZlQlZYY0dhSlhlMENP?=
 =?utf-8?Q?i6pOYxBkRCo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnlpZm5iMktoUElhSkJBbGhHcFFINFBxazI4NDhxbUY2N0xnRHFOZ1JCYWl5?=
 =?utf-8?B?VEl6djhrN2cvb2dRT0xJVzdWeStxSGZvclJnNlBtS3pwVy9oalpPTGdtcnVU?=
 =?utf-8?B?ZGRxS3FOcHhPclBrTjJhYzgrR2FudFp2dnZBRlJRYjluMWU4SnBjbm4yTTYx?=
 =?utf-8?B?WkNUN2Z1d1lwWHpva0VvUTlOZzB3ZXZVZENYMG9qUUVqc04yU3JUQnVPN2V3?=
 =?utf-8?B?K0pKMFE1a3krVEtwUENHTkYzeDFYVTV5QXA1T3dnNFFDZXQ1ZmxHd0lhajJY?=
 =?utf-8?B?bVJVOXN6Q0FoNFA1Q25BaGY1clZjYVMxSkhGbTFoQlp0QXE1bkdDT0pSM1Mx?=
 =?utf-8?B?M3FvdFd0MjZGUFNJT0ZsYjRTV0NTSXZqM05KbVFSVGVEQ0I0N21Vd0NiTVFN?=
 =?utf-8?B?dWhJbUNNQlVTSFJFSlIvdGx5VTNQRFBmRytMamtZN0gycGszMHl5dVFnb0Nk?=
 =?utf-8?B?Q3htUThUOGNPd214TzRTeUJNdnh5MkZEazh3VVUrK3RLdG9Ta0tldUFua2g5?=
 =?utf-8?B?ZStxeWYyQTUvREx4OEdPUjhHaThlTDdLeHlMSUwvbDY1b0N2WVlyUjlscHJX?=
 =?utf-8?B?OGNtNFFvQzNaTi9SbEY5d1lSbldNenh2aFV3YW9kN0Z4SG9pT0Exelo0S3RN?=
 =?utf-8?B?VWZ2NCsyTFdET3BqNURGQ1dBOEQxTTJmSWFEOHdpbVN5QmdpOTIzOGsxOHhz?=
 =?utf-8?B?WnZUZzJxR2ZZK0tuUVlTT0xnWHI2Q0dISHg1eEtTTFIvKzdhMG9HM2dlbDFn?=
 =?utf-8?B?cG5PRzdkUk0rZG5LNENnR3ZIc2hwY2M3TmY0OXNSazBzamVnSDFpc0R4Z1JX?=
 =?utf-8?B?anQ5ejNvczhpTWpld3pXYnRUQnA4VXFkd1BsbUNmU3FYWEhGYitEWXZrR2Vz?=
 =?utf-8?B?NTd3c0ZYUDQyTmpZQjlJc0hieldDK3YrSW5kdFZOSkNKcno2M1FmSjdWUlZm?=
 =?utf-8?B?czlJRlBVem1xUWRJb3pZektaWjV4S2daQUJHVU1VMlRRK21CTDV2RzdYalhN?=
 =?utf-8?B?ektkYnovbEdrV0M1QkN6VDhPanNVdHFjSEVVVWY5ZHJTcTNZOC9QTitWc29n?=
 =?utf-8?B?dnczY3pjWlRRbEpBK05EMGxjWWVHTWg0KytreEpqOVhxT3ByLzh4Zm5vWHhj?=
 =?utf-8?B?ZnJYVFBRWVA0T2lkUHpsWWZwaTkzZEoxK2J5d0Izb2hnbHB3bSs0SkYvMUZO?=
 =?utf-8?B?ak4xNDFRNkJBTlA0cWpDblZsQ0xyUFcyNGZiYVJGbS9CSHAzbndIZys5ZGZI?=
 =?utf-8?B?TnAwcFRwRFpJOU95TW9WeDRUaGsrSk5vK3F4aTU5M1lWcE5vbjJhUTlMTXJX?=
 =?utf-8?B?RlNEUTZzQ1drdjNxYzhsV01vSjl2bE1wSDZnZjJUSExvSGRYK0RPZXBmUnNQ?=
 =?utf-8?B?Vmp0NjhVb2VBZzVjVTJ4MkdZZ2JLOU9LRzcyeVVQaGxrZkFUakg5dERZSGFN?=
 =?utf-8?B?cjN0bVVjazdKalRsWDlSMzNpV2lwSTRvRTlBbmdPUEhUNWdPSzg5QXAwdHcr?=
 =?utf-8?B?dlpBRDVEcUo5Vnp2UlVkbGZrMXpNOFZROFpUam51UEZBVnY4Y1ZCbFRVbkZp?=
 =?utf-8?B?WHJzWXhuUnpsaTdvMlozWS9lcFJlODJrYnowbUkzOVRWMi9teUJGTUlZY0Jv?=
 =?utf-8?B?RkxDOEVCOU9jYWdaQSt5S2pRekdDWnQrbVdPYlVYR3lEeExRQWkxd3VXbzRO?=
 =?utf-8?B?dTRhL0kzRURibUI5WFJObHRaZU84MjJDOEFOdUVSUGVyb1FtSHoxc0hwdUhX?=
 =?utf-8?B?S2lWaWRzSjhnUm1qSGdmS2FtWHJVempJWUhYTHNwMENkU0NTWnZhdGgvb3kz?=
 =?utf-8?B?NXA3S0JwZWxCSkdQY2hnblJJaktFVndsOVVteFpROVRhMGRwMjBaOVBKQlFy?=
 =?utf-8?B?OThFOXpWRUZKTmVwWjJFWHJMd0JjNm15QUo1SXNjbTJkeVlIMXh1OG82TG82?=
 =?utf-8?B?M2hGU3BkNVlyZU1MaWllaERBM1k0MG0xdmdlUkhhZy96V0lmTHM0OFRXbVdl?=
 =?utf-8?B?aElZSExoemN6bHZiRTNEOEwxa3gvTlpTcW9Rd1VqRmgxZkdZNkdLNjNpMzB0?=
 =?utf-8?B?VHIyOTgwREorVkowSGpzUGRKTWRGSFViR09ndlROMUlWQWxHOHBoWHl5YWFO?=
 =?utf-8?B?NXJYZVVjQ00wSTV3S0IydTlYTFdFWUpadm9Yem5lZzVqSkE1M2J5Q3cwR01G?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	piurallYJasXjqqZx/p+jvT4j/ACYGHSQweto5HR2xL3H3IwcDTY99zBjY+LIzJFuiuQUDXqjJBqLCY1deGykqCY2or8J6sA/AUXUGso6mGg8uG8wzUdQCLHcD7Z02ea76CbdYBVX1im0g7xSJRSnAzlF9z637hx2sji0OfRp9yqDgSyNGoO8fKoiXl0gObu8pq42Gimybp0upzqoCOtDdzwAwtHh6wVWennhVnEVDkucOgxBlLUP6DhpOjZ7Gkjwkoin2eO++mucf2o68aq4JF0s3P4IpGHf/jMRUXgUKl7o6Ir0O8/uLihpaJEXgf+Qxtt7AZ2Q2DcTdoxrP7JMVsvKNuYUrW+IWF8Oo0VWgvC4oDU5IIxhHt/lYteyP6805Bm/emkjTshEYdpSL+mO7b1ENp/YFX9MgxowGL376LorJHe3GmqJjDj/Qa6P2UDbsoJuapXipKQuPHPs6pfm6UzM7MJHGUTG2LflacC/Lzw4GcjL2mWJruuWa7YhXzgfTDvvJlDzvlS4tEBX9CqRJIqTtxzDgl1mlP2phtxSXhGTkOhhIj9Lp/UPntcvTVI+gjMuyvvYf5hy1u9bzkdJjRBbnpNis1PSnENde4wYgY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1400c13c-b64e-429f-a08d-08ddd32b8eff
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 07:50:19.4558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WreylaKdnHlZ3VwbMYwJcSXHYRe+7dU/PlbxO9w4IDLUhcJd0+XxTvTeSbJoAHP6npWkfsjW/4B61eVtWXjDCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7093
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040041
X-Authority-Analysis: v=2.4 cv=TrvmhCXh c=1 sm=1 tr=0 ts=6890663e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=F13XImDt6ZJvjjSxybgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 6oVBzm8xvNbrfJEKB6aHI6XPeJLW0Ulr
X-Proofpoint-ORIG-GUID: 6oVBzm8xvNbrfJEKB6aHI6XPeJLW0Ulr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA0MSBTYWx0ZWRfX02UTrwQE96Oe
 XNRYcC8CVKgoo8/ECSPc6kpeOPrRiTpD5O5o5Q2HuYMlRG/xWR1mb2PMJR7sjCH2SqkMY0ZThbV
 EpetpRq1CMZL0HIW0Hp76a5cveLzbfpnxa9z3kXVWr8rjmPoyN8uMsA0bk70ZaS6dtI42KcNAJE
 If41R8FoUlru1XNUX5IojyRJU6CXxZUSxkyxoBNsmKqtz6wB3cS4Kz/PW979rQuKtXk4lEz9Uv3
 xfQhuSwERM83bybZ4VoLPdgOMQH1JIBZK+oLfEjfFVp9tnDGAX/qiknjsUNYZUTb2C4+En27WrJ
 ehNgNzklvM9l/FjcRkLIH3LTPDxld2F7+cO0FwUOcleXapYhRHCgEyT1nrRMvH4wZ07HaX3CRPz
 ljBkkOUapuREaA3ahcZ5yFgo33iMYYhaf7IgATfj/20JGCLW04bbXC/86NW+Ayn2pO95SM/1

On 29/07/2025 21:09, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test now works correctly for any atomic writes geometry since we
> control all the parameters.  Remove this restriction so that we can get
> minimal testing on ext4 and fuse2fs.

The test comment reads "Validate multi-fsblock atomic write support with 
simulated hardware support". Is that still true?

On another point, in checking generic/765, there still does seem to be 
enough exclusive tests in 765 to make that test still have value.

> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
 > ---

Reviewed-by: John Garry <john.g.garry@oracle.com>

>   tests/generic/767 |    1 -
>   1 file changed, 1 deletion(-)
> 
> 
> diff --git a/tests/generic/767 b/tests/generic/767
> index 161fef03825db4..558aab1e6acf34 100755
> --- a/tests/generic/767
> +++ b/tests/generic/767
> @@ -36,7 +36,6 @@ export SCRATCH_DEV=$dev
>   unset USE_EXTERNAL
>   
>   _require_scratch_write_atomic
> -_require_scratch_write_atomic_multi_fsblock
>   
>   # Check that xfs_io supports the commands needed to run this test
>   # Note: _require_xfs_io_command is not used here because we want to
> 
> 

