Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6A34A92DB
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 13:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443852; cv=fail; b=eBHoWAR/gCfsGyQdXwMaA6d3uIwNyXl7zLM+3Mp6M/kT0A+fanm1q/b5y7s6QjDTfaIYCQXss/1muSB0lXM2hALa77iTmwqZbZP/puHvAmgorJdoY/vugXIIj4d/xEJqxIIhLEJ1dDYS4Y941ADpWH+8JD1C/oL6kQZIADOctO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443852; c=relaxed/simple;
	bh=SQXmF4/md6IttdoNP7N4o5pomfx7EMItmVJ2uL6I8h0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H9EeAh26V7g00KrjcrHsqhXh6y/nvpXadeQ0acnyJJDTrDaRJJmk70szOrTMEYw8u2FrXmK2MeljCV513hdJVNH3bapmoE0SAtDj6HoJyb2cYUlNiuGmtk5zLE8QexV6AorXHAZYg8688Dgk3MFzQhH6n3cFDKt2pJ+uQbl0Wm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aB8rtidA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oHGCPyTW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aB8rtidA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oHGCPyTW"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683B4FlY738776;
	Thu, 3 Sep 2026 13:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=P5o70j8HuIvEIbfklc2WhnG6e7epAcXW73kY6hj50XI=; b=
	aB8rtidAI9b/wzzJU0LiSYAnLL0rEv5mfIELth9QErnTNDiecL/9t/eg/a5lZrf5
	XOYveIUyNoVCuUCOQutrb4rh2mcoAA1fb+jN+WNgKKqcwDm2K9SSjOQXPzk3AGFh
	kKIcBhQHAWgAvkRjY/IiMczrUPiEFE7K8G+L2ezgqIkv+1Jl4RaZhMKKfuclQcFh
	Kl5ruttBqJC+Erw7VKLwG+4TM66g65EnBN4QqGaMqk3uBhPj9dW1AlvR8hdOZWf7
	5nxoreP6kRtM9elFoNZ6uKN5d1/AaaftyvwFr3vfyTDb3pAzjJmCNXJaP+9dxmyP
	SuhoGeTAp7Wtt/y+LlSzMw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbb143m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Sep 2026 13:57:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 683DtWJG024497;
	Thu, 3 Sep 2026 13:57:10 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011016.outbound.protection.outlook.com [52.101.52.16])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gdymvw8w0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 03 Sep 2026 13:57:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h8/xc7VwFgJzZATQpix7K2yUZE6paiXnI5FmUGC2Vm1u0YsDwKY1Nt/IUcceIzeAnOxmCmWrKGYNPx3MjaVxNQnUJqHb0JjLfHpmC7OjVWCMpH0c+ja/KRh0tq6cKI9PvDjUoC+dn9p5ZnmPsfHZxnXsdvMQ9GyedVuoTnJu9QCFCDRckQEK/2eYZc0C7KRfwy8jAc0vRmQ4nB2lR+GoflNcaTRTfxetOExydTOxccYreEDPSIXGjQ3xTcoFoH4tRXp7ozeZGwLzF4GMim1fNWLmhiBXjoJoptTnthiIN8G+iKUAPd2C80aFWPu0Lh9u40YPjGhxjRXkgKQOGQzf1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5o70j8HuIvEIbfklc2WhnG6e7epAcXW73kY6hj50XI=;
 b=NmWneR3mFc1Or43TuijF2IPbWeo9RFB56i26x/QMmKSF+Zk1hZ3+dSV2cVLCw2bLUxABjHXBPPq2r/x3TTcoPWouIwHODTz38cMDnHHds7s3J09rcayxl8fxgYZNUT7Qw8toT9CIey9uJGKstBHL2zzXBWcrwOFBq0Xcz/oYmjL+gjhHsDTAHJifq21/2XllNudEBnnX4OjIE5SugSvUm6hTpU/R0JxuSqKAAXgt/KK83E81w7fjZ8Tv671yCh6qH99ifmh9jgObvtJMvldsA+mfwGxpM9e47M3dKPhuVdTSl2BKur3tEsrwAu6WtOxUtykn5ewGjfSjBOabBSB2vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5o70j8HuIvEIbfklc2WhnG6e7epAcXW73kY6hj50XI=;
 b=oHGCPyTWsMKpDg+03EnGPy5wJg2mlFDDv4QPE8WlyFIeEx/wGsz8SI75h9nHPhwFqbu/JEHzL5uNE54f0jufhSeAMy3/irkwKX1stcxuxqxzHohXZzRDly/RYHfDGa7/uzSMC1Tffa/K7SZyi9hL74e5PkKVWsFWLb5wF4sMCSw=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by CH3PR10MB6883.namprd10.prod.outlook.com (2603:10b6:610:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 13:57:07 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 13:57:07 +0000
Message-ID: <b68ca884-ae14-45b5-a474-074d131f250e@oracle.com>
Date: Thu, 3 Sep 2026 08:57:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 04/38] xfs: fix block reservation for zoned
 RT extent remapping
To: Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org
References: <20260819001442.1451892-1-dgc@kernel.org>
 <20260819001442.1451892-5-dgc@kernel.org>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20260819001442.1451892-5-dgc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0620.namprd03.prod.outlook.com
 (2603:10b6:408:106::25) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|CH3PR10MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 312262ce-d06f-4adf-23b1-08df09c33e2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|4143699003|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	mvTFcSO+WhXPHCTvhmp0zaeCsrnURoXpRRzFwxlP104qeXRS4ih0REOZ6HQ3P+BcdHGWPfLuP2YY65Fx45uhSDJn/5d6B29tVE/wzXhjiqtPsAAj6OIdXjX531mdqLMclUYB//OCEUKUUoS36VpBcde6phQPQlvnjdkLpVCVwGX7S0DzI2o+4c7aAP/JQTRfL6D3Kd9S4EPNVBLbgDpUQr9OAt8fmMwNm9Oc6QuK6f2qvNSM0PZYXYOb5Zsi9h4vJlsfIeIWzJXkl/enA+eaD8thFro1+iMf61IQwM/mZ5Hc3LbQZuEmAE+kjL8QhsDk0AypRGIp+wAHPEYO+EvcmHIeiH1mjI/egzBKqsghNoHq/bzwpG3l4RfZLvrG/YskNynvToPzsnI0eo2v25vN4WZ0fASiwbvwkphgCfRbtbpd+dXeq1ud++b13uirLlg18HLeDKzvdImC97VsLPc736iTpvLaYowM8/tA0ic4PdfLPMi98bM4LaMkNqDF/LbbKXIzdHYsbRGLMM4koNXIPgmBYW4/qyqg2oO4GjFmWS8HKeDkClHpej6APrXLgSwkXeK9T6VGkpymaU2ICnkX6gDQEUAdlYYKeUjTiKGBugMQSKjXmr8IR5xzh4j5/XZO46Sfx8xmEWq6tBP0+V59dkCnO0jy8gkYkrqOIX/XdGk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(4143699003)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkV3SGxDVGsrcVJpeTBFUDcyZXYvQU93WndlczNYajVrc3ljcm5uQlBSbTBX?=
 =?utf-8?B?ZEk2OVZZWHVXMlp3T1JtZTNBQ0NPcVNvdkhBa2RhMnlHbldOZDBXcGR0SnlR?=
 =?utf-8?B?SytmUkh0NEh6eGg5Wm5wb0Z0TlJVQUlJQVVldkpuSzVzZVBLWlFhODg4WmRi?=
 =?utf-8?B?TnpHWWNFRm8ySERiSEJodUZUckUzUG5YN050czJVVXdPZEZwN3JTdFZvdjBn?=
 =?utf-8?B?dkxhaDZwMkxCQzFYQWRDdTNUeExNSW9XNUhGNDhPWVlhTUt1QWJiMjJyc0Ja?=
 =?utf-8?B?d0J0NkpoK0NJL25iYkYvbGtqeFdWRDVkbHRlbDMvSFZmd0ltLzlTb3dVWmJx?=
 =?utf-8?B?OFhXQ3o4ZHNIZ3ViZTMweFd3dDJ2eFJOaU9Rd3U2RzdQSmlzK3VuSkNKQ2I5?=
 =?utf-8?B?cFBibDdETWtnNHBQdnJzWWR4ZmNoZmhIUi9hQVpUbEx5Y1pseXR1cVpBNVhI?=
 =?utf-8?B?bURHOVZXL0M4MHBHc3VESSt0RDJ6YmNMNWczMzR2aEpWRjlCblltaXA3WTVK?=
 =?utf-8?B?bzJWaVYzbVlIUHByMXplVWpicEg4ZzIyY01hQ0FPNVZTQkJsa2ZNMmVrdDF5?=
 =?utf-8?B?ejViam4vTDFnekNJc1IzS21ZR0FuM0oxUUQ1NTBIa0xKdjVxT2xHbzZ4eWE1?=
 =?utf-8?B?SEZINU1laTZaNVJPK0YrU2lxRFRYOU1jNkRKVTNKd2ovb2U0M2tWNWVjbjVa?=
 =?utf-8?B?TFBXaUhUa3prY0hNa29KMktkYitHeGV4dGV0MkY4MHdVajZiRHZyTGVJK2VP?=
 =?utf-8?B?bkc4akF0ZENzK1VqVWdsNjNEUEdtelRTMWxWOU9lajAzdXZSYnVoRkdrNDlB?=
 =?utf-8?B?aWxDS1Z0YmFnekZ0M3Q1dmovOUVqUmdFMU8zQlFqaXVYQ0dCNndvbWl2NWtQ?=
 =?utf-8?B?UnVTcVBvTmc1VjlJcVpFTDlLcGhPd1dHNElCcUM3ZXlsNUFIQ0N2SXg2Q1dY?=
 =?utf-8?B?RUtuUm5ka25EY2JxU2hnSW1SUjNWM2pEY2crSnNrNTlxTFVSQUVzTHV3R1U2?=
 =?utf-8?B?Rzk4WnM2L2FWMXdOMndrdy9JRFd6TUd6M3R4TDVEeFpINWlJMXZ0VXhoYm9z?=
 =?utf-8?B?eldIcEIzVC95NUJqdmo4K3RWOXNHUm5hWGFBbGc1UWtxQld5OUxESmdpa2lM?=
 =?utf-8?B?V1Y4MlkxUmN1V2NnN0VWS0MyYWRXbFNQcFh3clRqZnQ3cm0xeTl6eUE5c3NW?=
 =?utf-8?B?cGMrOHl6cWVoQ211SlE4L1lFWG5GaHVtMFhjM09XNVh6eTZ6RnlXdUJlVUhY?=
 =?utf-8?B?YlRyVEwvOVZ0bncrYjlWNnA1RmVyZXQ4TlpTZmQxZXFiT1FwVXphVmRZazc3?=
 =?utf-8?B?clpvY3VHY2tRMlJlL0xzdUJTNGh0Wmh6YkZDd0dsV1V5S0NTclBlNEpjbHdQ?=
 =?utf-8?B?R3F4V1pMcEhXeFRsOU0yYzFFU1lWY3VQOUR0VnNiM25vOXJPdjE4RU4rajMy?=
 =?utf-8?B?bm00OVFqVm9zLzM2YWpBRlFSZjgzaXh0RjNpcjhtOC9oTzVYL3VJS1FJeFor?=
 =?utf-8?B?VERPTTdzN0UvTTJQYWxMTVF5b2dRMXJCSVROdWkwTFFpWTMyZGZhTThwNnhT?=
 =?utf-8?B?V0Y4OHp4bkhsei9CWjBnVkhLWi9KNUxxUVBpUDRsdmZJTWx3YzJ2dTNtd1BX?=
 =?utf-8?B?dG9XTWQwUGhyMlFqcUpMTldCN3NyQ295aG1HVHBHOXFNV1J5aFA1Mmk4WlZ6?=
 =?utf-8?B?ZXF3a3Jra0h1dUdtTGszOGc5cXExdGt6TGRUeDVsVHhycFd2T3F6SHdDb0dv?=
 =?utf-8?B?eHBaRm9mdUJpT3lQcVNKUW1LcGdoRHRyTStIZ3BKZ2Y3bEJlS0hLRXVFdk41?=
 =?utf-8?B?STY2MHpOdUgwWlR3aGdrWG5XNVVMMDJ4RHRQMXpkUEdmSEZlcGdMNTdQUElU?=
 =?utf-8?B?NXN1aEVrdzhqQUhJRGJxbjM4V016dkRqZmxqQzBsYWRsRFcwajhZWUNPYkFQ?=
 =?utf-8?B?MlZUdFlnYkVQL0dVL0NOejBSVDYxd2c2bjlZQXhuMUU2WFpGT2ozZ2wrNXNH?=
 =?utf-8?B?RDlnVmM4NVB6Y3JMQ01HOThGUlM5SWtpcm5HZHFJYXBQKzdKU2Jja1diT3Fj?=
 =?utf-8?B?OFJoM0RoWXFRdlZoT3U4NVdWWTF6MFFRelcwWHc4QXB5dFZNcnU1U2poazdL?=
 =?utf-8?B?RG9sSHNwRVNFUWhZZURZY09lRi9YeHBDNy9ZWVBLVTJ2c05qTXlRN0RQL284?=
 =?utf-8?B?cXJzZDFwSTYvRDNGb3dDZzI0V3JzTHdSYnFlMk5jWDRjZVFDc0xBNFl3eE80?=
 =?utf-8?B?ejZpQkxMVXpiZnprSCtoNEg4UGVtZ2pkSWZTdVdLWldReUpxcmtVNk01M3RZ?=
 =?utf-8?B?cFJuL0RXWmcxQWw3b25jY3ZVUVI4ejdqcEp1SzJ0V3NVM2hNK1FuT1h2bU0x?=
 =?utf-8?Q?otVPZNW3tO8B8yvs=3D?=
X-Exchange-RoutingPolicyChecked:
	yYgRevQRz9JLTmcbVhqTPzYhLodzqxL/v4ulEQav9otJHQYVzuKgLryb+XpJAf80IRrZUVuSRKExYuJ5J4ghacDA8br9sq1Sq3NXfwT6IwauEzFezwH/9PGkRvcLLeOts/4vDu2VgO1C8Lov2qnUQ4LputYCpo/3pYIVbmq4ANcDldYK6hcpRAFgWI4wnEpzrNhwJhCuMC91AHic6QJEbgzQ2jfQHX2hqXrDMRl2bE0gL6aAyWzGbx28k9N7hHshFmm0ckzmteBvGttfsTbVoclqT2rMqEquq6bhUPWh+DcO2gs9QE54CZVA1G8Vw5H8XOTCKK/ZgbzoXdOWfecndw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tWmoXrDqB+b2Ye7cPag5Zd2NwhXZ4lO6/FXQQLTCi6eVZZm5SC64xnOBzE5uY7Pu0He2ARMq1BhCA+Gvm0fp2xegrcCNzaMQAux7rijrTC8oqJzFd1nQrlsCJ9lgOJiU5RaX9fDouUq1XNzCXzXnQoBbaWh1lgXIXz2qU+ggXZuVNpM3E5ecZAL9mSr2o5/y8h+YxYCTY2cDZ/GyKMlUaTBhRkWaef4nK9ZgvjosxCO/Yo9C5yndinT74Tagzuk9/i84kPn90jMgXadzt/nJ5p5OLxXSIJQxycoOxXQdqrQW4alPrS2PgD7vlivL7LQ9jLGfWBKu3e7fDZFkIlDMSNAMw0+vRqUYO2Sry6n2ISm4jUU0YuhXXRJujgOwYxOO4/T4/1uf+2v0D/KHMpQmCHsqRZNs8UnOaiBvQObw6ALq1OHWw54rFRfew5HiNyQjvIznSRuqzBpsTb+jN9bjmc8vKmcwXnKpk8mRyJ+zuRLKZ8q9kfXpTYPO0uR6fXYrGEZ7acLmzaQf7S40fnFNN0UD4HvwS/2F7Wfv0/dqLylRgoKKGoK9rNBcHuK+B0A0pZa90TMuVU8ButzAdylGctZK/GSfUcqzLQ5jM0Oyf1Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312262ce-d06f-4adf-23b1-08df09c33e2f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 13:57:07.7811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/HmXJ34iFZqeUWLTgMld/LNLv1yLGEpneSDX1FH7vovXQBTkiWd3RdZNit4UCeGUR3sWxbb8f8W4FohUEenmDM9IvnojRd9wmGmPBZ5ylM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_04,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609030121
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDEyMCBTYWx0ZWRfXzxKDavaUb9ui
 DnIsai12czijBeKpxysLZdmtkyVKg9joeuIaVLwp2sifVhkfh20yINW6tHCJC6p1OSqP+yxLQkW
 wiyuyXqEfp0zB79ZpSg6HOb++W0bV8o4PCBHq5mM6zSiipjfjMig
X-Proofpoint-ORIG-GUID: yYamNj74x_ZGty9RQ6X0UdnkQrc3rj40
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDEyMCBTYWx0ZWRfXwIp5QtXk2cms
 rePAwBw+hp1s7smgAZ7h+euv/11+NZCon0efR8+uzXf0GCkkv+/17Org+uolt/XWiE/6U+kSqFI
 7Ylf3Uimt5BPCVTVfkb0WrqjkORpdWQsDRvXoGTj61hne9RXttnRG9k37n7+7qeHLq7bFnHlPzQ
 QSJPdYjsWfIyrd7vGEV3NcXlIgCqgZ9gZh/m1+XbrLYdIaV8H9Lie+TyHuUpVwwxrED+Rov9D9p
 tu9eR6YSRh39C+i9nK+46Ub/eS2Le/ae5K+9uGiN/StOH4cQpahi64BEqbcikfKtjji9bv60ARS
 gFRuLKEzQJn8feQTw4zAd0NYa1CrDifaHuByprs03mBsmA962SpmFJhWqKSYQVqznEQ+HsTCsNo
 zwj9pYrFo02FREu6V3EXOAZ9NfSlFaQK0XrR3xjENRZMa3KraHbREeONnDdqR2OXPWLHIycBZOj
 RwXkroZVhQoR/q7gzXbs3Y9lgg45gkdv0NSuKZ3w=
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a997cb8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=FgpsUrSrNvnJqfjxGQkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: yYamNj74x_ZGty9RQ6X0UdnkQrc3rj40

On 8/18/26 7:12 PM, Dave Chinner wrote:
> xfs_zoned_end_io() uses XFS_EXTENTADD_SPACE_RES() for its block
> reservation, which only covers bmbt splits. However, the remap
> operation in xfs_zoned_map_extent() generates deferred rmap and
> refcount btree updates that also need blocks for btree splits
> when they are processed.
> 
> The code used XFS_TRANS_RES_FDBLKS as a workaround to recycle
> freed data blocks back into the transaction's block reservation.
> This is fragile — it depends on freed blocks being large enough
> to cover the metadata btree needs, and conflates data block
> recycling with metadata reservation.
> 
> Fix this by introducing XFS_RTEXTENTADD_SPACE_RES() which computes
> the correct reservation for any RT data extent modification: the
> bmbt split cost plus the rt rmap btree split cost plus the rt
> refcount btree cost. This covers all the deferred operations that
> are generated when an RT extent is mapped or unmapped.
> 
> Drop XFS_TRANS_RES_FDBLKS from xfs_zoned_end_io() since the
> reservation now correctly covers all btree costs.
> 
> Note: XFS_RTEXTENTADD_SPACE_RES() should eventually be folded
> into XFS_EXTENTADD_SPACE_RES() so that all callers operating on
> RT inodes automatically get the correct reservation. There are
> approximately 11 sites that use XFS_EXTENTADD_SPACE_RES either
> directly or via XFS_DIOSTRAT_SPACE_RES that have the same
> under-reservation issue for RT inodes.
> 
> Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
> Assisted-by: LLM
> Signed-off-by: Dave Chinner <dgc@kernel.org>
> ---


Cc: stable@vger.kernel.org # v6.14+ ?

Looks good

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>


>   fs/xfs/libxfs/xfs_trans_space.h | 12 ++++++++++++
>   fs/xfs/xfs_zone_alloc.c         |  9 ++++++---
>   2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index d89b570aafcc..4cfc29ac764f 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -55,6 +55,18 @@
>   	  XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * \
>   	  XFS_EXTENTADD_SPACE_RES(mp,w))
>   
> +/*
> + * Blocks needed to add or remove a realtime data extent: the bmbt split plus
> + * rt rmap btree and rt refcount btree updates deferred from the bmbt operation.
> + *
> + * TODO: this should be folded into XFS_EXTENTADD_SPACE_RES() so that all
> + * callers that operate on RT inodes automatically get the correct reservation.
> + */
> +#define XFS_RTEXTENTADD_SPACE_RES(mp)	\
> +	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
> +	 (xfs_has_rmapbt(mp) ? XFS_RTRMAPADD_SPACE_RES(mp) : 0) + \
> +	 (xfs_has_reflink(mp) ? 2 * (mp)->m_rtrefc_maxlevels - 1 : 0))
> +
>   /* Blocks we might need to add "b" mappings & rmappings to a file. */
>   #define XFS_SWAP_RMAP_SPACE_RES(mp,b,w)\
>   	(XFS_NEXTENTADD_SPACE_RES((mp), (b), (w)) + \
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 7d13fa7ab30a..61b483d24c88 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -330,8 +330,11 @@ xfs_zoned_end_io(
>   		.br_startblock	= xfs_daddr_to_rtb(mp, daddr),
>   		.br_state	= XFS_EXT_NORM,
>   	};
> -	unsigned int		resblks =
> -		XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> +	/*
> +	 * A remap performs two independent BMBT modifications - an unmap
> +	 * of the old extent followed by a map of the new extent.
> +	 */
> +	unsigned int		resblks = 2 * XFS_RTEXTENTADD_SPACE_RES(mp);
>   	struct xfs_trans	*tp;
>   	int			error;
>   
> @@ -342,7 +345,7 @@ xfs_zoned_end_io(
>   		new.br_blockcount = end_fsb - new.br_startoff;
>   
>   		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
> -				XFS_TRANS_RESERVE | XFS_TRANS_RES_FDBLKS, &tp);
> +				XFS_TRANS_RESERVE, &tp);
>   		if (error)
>   			return error;
>   		xfs_ilock(ip, XFS_ILOCK_EXCL);

