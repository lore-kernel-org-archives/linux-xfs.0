Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19EE63B9;
	Thu,  9 Jan 2025 12:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736426466; cv=fail; b=l+95/7diy+SmrWDntgWTjPVi34BQ+WV2QvUuZY+UsYOM/i/iQcPZIHgrbMsh6v4+P8NMmWsBW4c9lS9s52BSG4LnPfFPSOAN3en50Pv/56tkSnOIfzfTovsGGqAA+C2pUo7lQfqBufLm90FsXB3gJKF9TWLuvufI4x3F/63jSCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736426466; c=relaxed/simple;
	bh=Qy4fg3txNtm7e4T417T9NUrtRwhN9Xr7t9BWgPqHPHk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cUWhGL866aV+V2kFvsWZ6w7ZQAZQjHqE0DJrclzE/72/iTWjYXTitpQiJdJ9+mhTVqlVox2LwttRaX+qUQ+/99NQR3uxXDV9kTTgx5IMx7gfTS/MkW3ygd0XLAe5puVMKd7MBwc8nY9KqVIxgluJjCN2ykooPEMqtjAKbqT2Jic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IabOkKmZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XGcLuyEe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IabOkKmZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XGcLuyEe"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509CdDZC020956;
	Thu, 9 Jan 2025 12:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8X6su+mPRjEUS8zxnBxz9HOnnt18NmKYzOzWizqI86c=; b=
	IabOkKmZrfnICQB1JJKwC34mKAAawPq+b/TRtEdICMBTakxjRBoKS/Fojf9V94qi
	Bmp6m1nhu5Hk+lcStQkWiRxcbBUXucLI0B+wRsZRh6GosR9uC5czWHSsvojuctuv
	R2DPdcjk8px2Um7iZQ6TzIG8oawBP1JeFsP0iYjhq6oOdGOYaEY4gx1eqk0M+tX0
	yPxflTCOgffwAtKq4RQkE3wZbwZ8f4M4oosZRAWKyTfQ1pDU8JeL7QsYmZIqCxxT
	qkqcVu4HNg+FkD/EjJtrxymFhX4nrZ4yTVDcQEIWvnt1YeUMCsbdUBWVlywkN/Ak
	m9MJjGl1Zn4jGfEzptoVsQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xw1c0pgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 12:40:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 509BnkgF022649;
	Thu, 9 Jan 2025 12:40:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xueb1apd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 12:40:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IHgqZFKlG8cU3KMlWyngu5iqooXB2Jv9gfiLSLMlexBmmhkFmrHUazySHUs78yD5nVO1pL8FIS/zQCy/TPdOmw24SRbmObdvsJ3pymtbVKbSCl79VY+cUomObAgpF7rpI2DDLUSNDAqk/G9klGBZQHHoORuLEoKaXchtX8UIYl/eEeZP2DPDjGDCMHXoSdxB6A8KnWuK9KEf0U/A6rZMjNymkyswskaUl9oQxdIauMn/5s3Qn3fW50ee3Mv89GhGeuLMqKGFkS45neqMNdlyOSiKMpnM9hsssXLJAmQpqFnZCLc8PyIMe/dlwCFy4bsYaQe/dXUesJp/4jkroqCN6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8X6su+mPRjEUS8zxnBxz9HOnnt18NmKYzOzWizqI86c=;
 b=vAeHv+PtUNKwJovFpfK3J7w1BnsYeogW/3nGpM+Ej/bZ00RL8/BKAz2O8dVxLMg4VttVM16hV5JvKesPfyQD8mqOxUp2NpeHHt8vOJ9o8JGdfSSFy1+O2BhxELKCsGNneyjVURffriEO9ZVpM9+mupa3xnGWW8OTzNdjOPyxYbIKxbHXse/0rcE/TSdLUUqypuUD5GQOjZOvD0VzQgaq16FEUt9ZDARjZ099/MieptExTEWCN8R0jw5Js85EZqv5O/TPqGhHJwnAKjAdRrflcBfRcq1YPruShTsmM8JPKrZ21jYd4zoh1oXa2jglRXEOjvRcQ82DXE069cB1T8lbSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8X6su+mPRjEUS8zxnBxz9HOnnt18NmKYzOzWizqI86c=;
 b=XGcLuyEe1pRNTZbNftR/RF7RuVZUwzpZx1Rn5JxnVfBqq/t6dYr39GRqOuDYV8qgKEo3sGPQzfCiiM+2toxYlH8pnYFOuLCip8JwRxjF6UXPH3vLYicZnuKCvkrCg4vslWe4LaGGKYVaCYdrBTljygv2rgt8+QUCBV0YTaWp4Nw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7770.namprd10.prod.outlook.com (2603:10b6:408:1bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 12:40:47 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 12:40:47 +0000
Message-ID: <7dd3e6e2-0f85-4db3-a10b-0ef910889e12@oracle.com>
Date: Thu, 9 Jan 2025 12:40:42 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chi Zhiling <chizhiling@163.com>, Dave Chinner <david@fromorbit.com>,
        djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
 <dca3db30-0e8f-4387-9d4d-974def306502@oracle.com>
 <CAOQ4uxiMiLkie03QA9ca_3ARzwg7rm31UFBo6THdVUDvr0u6fw@mail.gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAOQ4uxiMiLkie03QA9ca_3ARzwg7rm31UFBo6THdVUDvr0u6fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0033.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::46) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7770:EE_
X-MS-Office365-Filtering-Correlation-Id: 657f7044-7907-40b2-09d3-08dd30aad73e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTNXRkUwNDk1dzQzWVNkRjREWEpmZnoxcE1scVp3UEYrMTlxb0dTMTNqd3d4?=
 =?utf-8?B?ZkFpbHlOZmFwdUV1UUNIa0xUZzVpdFV3S2RKZGp4Y0lST0kvaEhpbmNRWWh3?=
 =?utf-8?B?VWlrVXNZa2Q1b3hrZzJzOW1LbHREaEpleElqZ3JLVnQzT3g3RjRxeFprLzVS?=
 =?utf-8?B?VDJpWjZaQi82NmdnempOSVdNb2dPS2U2eGdyb09FV2N4SlBEUFYzenpUbkNX?=
 =?utf-8?B?VVZEWmFDUERuWWczeG9saU5acmR1VGJENmN4K0FhVEpSS3gzVUhaTnFoVW5G?=
 =?utf-8?B?dWp4WVoxdkJydTVLR1UyZ0N5WXlYWVA5eWhrVzVsYmkvdlJNdXFMMHpQOUV2?=
 =?utf-8?B?MXkreDNhRmtMYmRoeTVtNFRtNGcwRHhuWm90STJtZDV4ditoemZoU3lOYkRY?=
 =?utf-8?B?WFlCUFVJc3ZNa1dUbmt3amVoU1dCbytkTG1wYWVLOG9UYzRGZTZtUDRDcXkr?=
 =?utf-8?B?ZHhadTJsQXhyMlR1TUVld2JzUHVYanBPOXZPS25jT29obmMzSzNZVTl5T28v?=
 =?utf-8?B?djhBTVM5azFDbjdZMC9XRjZ3aTNRNmxjZUp2czAwYjZDWkdRUUlzQ2tnalN1?=
 =?utf-8?B?a2VDUWxQY1FxRG8wSHBwUmpRTGNPR2ZTT04xTWY3THZ2eEcyVnNGelFWUXdi?=
 =?utf-8?B?VERWWnlqek16SlhFc0tLdUVHODFKR3E3ZFNjSmVwRHpDcmdiTkxKVjlZUmtH?=
 =?utf-8?B?Q0REYXZWaHRhRS9RbGYrV3RXUmM1c3RTbHdzSkRUc1ZJNXNWOEI2NGNJSjU4?=
 =?utf-8?B?UnpMRGZjSEwyUTI2cXZFY1ZLYkVBRTUrYmFVek03VjVQVWZ0bms4VE9yOEIy?=
 =?utf-8?B?K2ozNG11cDcvOU5JUUh5M0k5N0tLYU5RTCtEZE9CS3IvOGh5anVjWCthN0NW?=
 =?utf-8?B?WGlwSUplaGhsQlhaeG5QUkpqaEZWeXJTdzNhOVJhWkhaTkVOSlBaQmYzZDE5?=
 =?utf-8?B?NndkazZNWkxXbkpkM1dXak5xdzR3VmdJaEQyQ0FacWdVcDhjSkVVNVFLK045?=
 =?utf-8?B?eEtBd01LeFlVN3dmNlI4NDdtZCtWdS8zZlA0TDY0TC9yNENyTkUzQzBCSXpY?=
 =?utf-8?B?U3dUcXdROTN6OEYxZHFrUEhLdjA3WFdsd3VaRGF5QTJsYTVjZnVQanAvcUR0?=
 =?utf-8?B?UXhaRUwvUDFIV0VRMy83dmMvSVhSUGFZMHZDeE9NM0NmWHFsVkFXenFMZnJk?=
 =?utf-8?B?VTdYczdWdHdYbUdqVzlPd0RTU05uSDFvTkx3WkEzdmMvU0thaWphQlJmQTdK?=
 =?utf-8?B?VG13ZWpJN2VaMVN1ckVlMkdOU0ZNUkN3VlVJSzZYRjgxZkxFcWFnNUxWTVph?=
 =?utf-8?B?d2Fqdk95clF5OVdZU0c5VGQ1Qldob3N4QXhpcVo5R2E2TlVYbXBXMkFIa2Jl?=
 =?utf-8?B?Y2RTRGhRUGdRNmZkYU9zYkdhN0NEUTJTY3pBN2pXL0Vad3JMODdsQ2U4Vm12?=
 =?utf-8?B?YlJ1a2lFU3htUlgyQ0lnbkVuUUlTUWhuTlVtczFLNXZsTHR3OTJSTXAxbnQz?=
 =?utf-8?B?YjdzRnR3U0h4NjdING4wbHZSaGxWUmlIOVJyTlFraVczbGpKamYzTFdwVTRH?=
 =?utf-8?B?czdKV2lLb2dtQ0x6dzMzcktuM0pCblIvZUpraGsyRnhMcWRYOUdJUU0wUnNJ?=
 =?utf-8?B?NWwwUEZJVEVYRmNtRWpGMUhYTG9ZaGhZTlNGTmRGWHZFWm05OG5JeWFmTnhJ?=
 =?utf-8?B?dVNEc095L01KMFBOZXpoV2hZVzVYbXUycXZQRDR1T3h6Z0VqL2lBT1hwQ1NO?=
 =?utf-8?B?SjBuU1JmbGtKWWc2SnNHSU0yMjNvMldXeVpJNzZERVltK2tMd2laVjFRdCtP?=
 =?utf-8?B?a1FIRmNTQXFCNVNNTjgyZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWZhdnN0eVdxUVM0RnR6ZHpFNjlXN1FJL24yMkowSThWUlhwWFB4bUlQamhz?=
 =?utf-8?B?S1RxSmJMMnRIVkhWN3M2enlsV0FSTG0xQmlENjNIbjh3U0ZTNk9LbWQzRVZ0?=
 =?utf-8?B?UVNvbzErUDEycmdQS2dKSTNBa2Q3eDB5bUU5ellLOFhlK1hTczJ5aHlCQUhq?=
 =?utf-8?B?UmpSZUxhS1hKZ01QVGZyMTc1eXhxdE93bWdCY0daa2ppVkVrOFBraVZwajla?=
 =?utf-8?B?akx3YXBJYXJEQnllbkJERGlzVFZUTHo3Z1c3cWhKTDhSR0pPNXFWU0M4U3JG?=
 =?utf-8?B?UC9sd3RrSmlDUUlyVnU3NTBMb0FXRnRKQU1yVmN0VUNnVzNwRE1BMjhXQmRM?=
 =?utf-8?B?SnpzM05xL2dpNDJlbjFiSG9VWkZBWlU3aUFYdXhQYW1UVnk4VFhlelJDYWZ6?=
 =?utf-8?B?UWxYbXdjTDNrdUE4N2NiYW9XMUVmSHpFYlhJV243K0RuSkJ3UEdHYk90S0Vp?=
 =?utf-8?B?UVFZQnIvcmoxTnBDNUI2WXNUaHZOUDFGYTRXVjJUaEdsc1U4ck5HdmpKWVlj?=
 =?utf-8?B?VkRNMVpnek5KNk1qcllJZnVHVHVaeURKUWRTRmxrdGpSZy83UUgwQnlvZ0g4?=
 =?utf-8?B?L2pwa2dtSXBBay9DSElnYURoZmpRVzhXc0lTaGZNV3RyYjhkTlgzWlZpZEM3?=
 =?utf-8?B?MUFxZWVjTi9aVzQ2WGQxODFpTy96aTdpWUN4VHZsMnUrTGFKNVZXeGltc05s?=
 =?utf-8?B?bk85dklSNHVpd2xzR0pXa0RwM3VhV0FwMlFjTWJnZk1SQVhHMjNmUTZQeDZo?=
 =?utf-8?B?NGZEdWIyN0VWNC9Sa1JJUjA4eFNsY29ud3F5UmVoelhsNWd4WGVhVG5Ub0xK?=
 =?utf-8?B?Z1pVcVljSWF0eTlFdnBMT0FHZ1VjYlBvbUticmlDekNxVUdYVmJsUUpuWFli?=
 =?utf-8?B?a2VCQVJzN1Y2bVhKZmlHakdETHdITHFTcGVJNU1TSlEybUVNU1pKV3BWR1hk?=
 =?utf-8?B?emxvUzl4THR4OC9CbkFib1R6djE2TFNTQWJ4eW1NVnhJVHVZRnV0bGVMUlFW?=
 =?utf-8?B?elNZRXl5Z2ZaaGU3TElSdjVWNzd3R0RIMGFMNmdQcVIxY3pESWczSG1maHpK?=
 =?utf-8?B?STUyQlZNbVRNNkh0cEl2L3M4Zk9VbG5hUGFMd0t2ZHJXRzJ2UmFvekQwcG8r?=
 =?utf-8?B?R0JOS2JsdVJkbVo4djFHQmxXaUQzb0dzV2ZTZy9nS2JPUzgyWTBnTFQrTVdW?=
 =?utf-8?B?VXpNWHJpYmdCcGFKTHF3RTRVaWl4VGZlYVJ1YS81THMzSW9XUFErejB6N2FV?=
 =?utf-8?B?SkJvWnN1aWxXeFUwUy9XWG1sakhzeUYwM3dYRC85TFROa2U0SCtTTEhzOVQ0?=
 =?utf-8?B?S09vVlpNaVUyNVVrRHJRdWlYZU05RlpPd1VxZVBEOHpCWFZFblgyVVBEa1pF?=
 =?utf-8?B?Y082bTZzRkVjNWwxU0NVRDh4cVJRZ1JlWU9zd1l2bVFpMlBGTUx4ZXZNaWdy?=
 =?utf-8?B?TmY4ZDJvdVIyTjZjd3EzRWxLeksyc3ZnUmZXa2d0YjFldGlVeHlaNG5ZWkIx?=
 =?utf-8?B?RlJjTjdPK29sK0FXQVhKa21GMDZNa1VFYkVzSDg5VnV4NjVRTTVjREhwWDUr?=
 =?utf-8?B?K3daVEtwSGR2Zm43MzdibHB0VXk5S21aK0NsdGQzUVg4ZlRKWXJoMHhxS2xS?=
 =?utf-8?B?MGcxT2VzRnBBb0VsN2ZLbmFGQ1VnSzk1Tlh0YVRwTHZHL3lRSkxMR3RybWlX?=
 =?utf-8?B?ODhReVZJdVpVVGlhRjVOaXg3UGhqZXpUTjBWVDRkV095MnBYdDEzbXNEcU96?=
 =?utf-8?B?eWUvUjBLRklXNGFLemFBeXJyVm9OdENZeVdaVnBNYmhQL1dya3lxeWpwMm5v?=
 =?utf-8?B?OUcvNUs0RkZxNHVEZWNySkt1eHU2dG11bVRvMGhBV1h1UUI5ZC9zQlgyTEZZ?=
 =?utf-8?B?L1E4NTIzZVYwWThRVDlvd2Fna085Vm1wdG5PaHF0SFprUW55Z2VLZjZmNFN6?=
 =?utf-8?B?V1orUlhaWUo2eVl0cldZQS91OUhOMm1FM25FSHhzWUgyOEhibWxSZnh2amhL?=
 =?utf-8?B?bEhMTzhYZlBIOURjSkRwK3QwaXpRZVpZZGVCU1dnUjUzVkZzcDBuVFhVSHlw?=
 =?utf-8?B?R0xMRmpsUHFaSndJTW5yd3ljTnJZa2VVYmNqc2VKQXlwdlVzNlBBb29JRXJT?=
 =?utf-8?B?QVl3NTlKanU4WmpFb3grc3pjRUpBTnc0YnNNclFBUHNQVEpnOEovM2Z2WEt4?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cuISVY93/SaEVT+PKTMvXuQQNhWU4m6ukIuQFns5ZAPuqjqyOsFX8iqlSzKbdxvFi6T3w1l6zua5oh2aWzLY3NcF8clHHNXp02WmmcsNpvoButAZwLUrUjilzHU1CFXcsOxDqJt3jmQveEhvO/D9FMurs/CuQmt2jXCWWg4k7v/5sQqrMkW4tv3MDBxlrlciu0CanuMoKKT/DQuBSpfDkGxh9PMhNPy0qvDTP8VEB7+lmaYTP7XMihaw1LBJm1VlTDBpeQlL4We4Mrj3/svPa2MxerbWUFl0L++D0dNBkYVHGgzAkaQHSfmkGmwIiVBXPDq0gzyxvVhTFU3pJYONfyemX0wF9SZ6Llgk0HMl+CYSdN56hY/gRj6sZhAKz5kKV4DKdECBEwwpHnX7xSmsab+jYglJ/wkMWDvgn9Jtnv3JM4alxYkmga7TvCU2dS+8GonbnUIXthZNmzru8iy4nBSEnWwrTGrcbkJuoYPkF+5ofqK2UaklIdpBW5bN679mMZBsJAwEnlRb/CTC9HfDWxjIQCAytyVVpl6AcAGHQQDKGe2JgSe1zInMBhgvubM4J36O57q/e0nW/qAFcJ+YK3hQIbeZRtJkYV22fClWSHw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 657f7044-7907-40b2-09d3-08dd30aad73e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 12:40:47.2425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rldq08KNMc/IbukgmslGQv7vuu6T7x8WfH1lZF1fQKkb3jrtQL2d/d3IYFKeAO4fDP8Gmt25Qvk1sA/wKla8Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-09_05,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501090100
X-Proofpoint-ORIG-GUID: l4fHq0I7kQu3dbJPEWdPa4uTY7VOfg3d
X-Proofpoint-GUID: l4fHq0I7kQu3dbJPEWdPa4uTY7VOfg3d

On 09/01/2025 10:07, Amir Goldstein wrote:
>> Please note that IOCB_ATOMIC is not supported for buffered IO, so we
>> can't do this - we only support direct IO today.
> Oops. I see now.
> 
>> And supporting buffered IO has its challenges; how to handle overlapping
>> atomic writes of differing sizes sitting in the page cache is the main
>> issue which comes to mind.
>>
> How about the combination of RWF_ATOMIC | RWF_UNCACHED [1]
> Would it be easier/possible to support this considering that the write of folio
> is started before the write system call returns?

I am not sure exactly what you are proposing. Is it that RWF_ATOMIC for 
buffered IO auto-sets RWF_UNCACHED? Or that RWF_ATOMIC requires 
RWF_UNCACHED to be set?

But that is not so important, as I just think that future users of 
RWF_ATOMIC may not want the behavior of RWF_UNCACHED always (for 
buffered IO).

And I don't think that RWF_UNCACHED even properly solves the issues of 
RWF_ATOMIC for buffered IO in terms of handling overlapping atomic 
writes in the page cache.

Thanks,
John

> 
> Note that application that desires mutithreaded atomicity of writes vs. reads
> will only need to opt-in for RWF_ATOMIC | RWF_UNCACHED writes, so this
> is not expected to actually break its performance by killing the read caching.
> 
> Thanks,
> Amir.
> 
> [1]https://urldefense.com/v3/__https://lore.kernel.org/linux- 
> fsdevel/20241220154831.1086649-1-axboe@kernel.dk/__;!!ACWV5N9M2RV99hQ! 
> J7_5N_kSixl5iSy8IX37Cup3uKTHAaC5Oy-RlvsJeTE2kr3iJ2IXNww_rApK7TwI_ocCBSE- 
> G2vZSKSRHqY$ 

