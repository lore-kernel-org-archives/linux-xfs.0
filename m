Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039914B08C
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 15:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714059463; cv=fail; b=k2Xb9HqrWhM+JsM3fkmg0/dpf6gSHmF27xjx5V6OM5c3cJfNYkB/ISnSdg3KdAJGXatiGAjfnXsOXP3fijO5YIvwzXVspyXX2Jofi2t3rU4abPTgYg2+Dj5pdqh07ou2DpN+3q2rWPR3J1E1vDeGsRPZ72jZLXqBQSgIHAg3pfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714059463; c=relaxed/simple;
	bh=uPaYEOCjuy0rYcktzuZJyreCiWQG0CGhrhm/2/+7uAI=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RuktGI5KrXfIxr21mTwz5FNgBz4doaFCaDmOACgflvNYjnFyU8PnV2OhaV2zwHdkwhlg0fwgDwNSr3zvohEvKLZpUdRXrPX7R5vZhTYgrE2P6GZbMnh0Sv2v32X5y+xZV/k+nTQT8htjjngCBiIrZ/+1OxtOdGA/EoBE313/sIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dn+h1T38; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lWso7dzt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dn+h1T38";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lWso7dzt"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43PFBbvE003309;
	Thu, 25 Apr 2024 15:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=hObSno420uY4RZ2Ya7kTrb2pKN20yG5EFkiufE8LQRI=;
 b=Dn+h1T38f9ZaMF9tSxXtQATd2PY6i4R+Un0slkYVMgf82ZwHOqs48a0yxNlPNIQVMz0A
 1PW0EGLk7ZfEaiG0sDroGWeqbEPoHa2VuK49ctRFtgsA2piNhxl5jeONgzyW/U/Pee+f
 x9JV/4/UDbSouUln2SeP3ZnyN3jdFopa6XuU83y8a5anozAFreRw7bM17b98ZGQ1lukT
 lTnEL7LSzVOvk8dsZ8Xyt7CqhJS+KV0YprfBTuVh0ybMgB9xtKqfSl0+vdirVX0L4EJD
 jPBM7gwk+oAP3eV++G2dC6n/deHRGEiHD1nxiD+rqbzS+JwxK1WcwDiDhEcvlB+qXVep ZA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm4mdc85q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 15:37:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43PEa7er006161;
	Thu, 25 Apr 2024 15:37:32 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45akqg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 15:37:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCXiiIaqqHVHv7A7NS+UwUTC6dB+8QyhGc3x5eVddHeelYNncvwGaEUc/uOol7tAUntiRS3YYx8PZVGwaoAsy7loFJrssi9GRgR4cNchgOkbgiKSSs9UM6QXGualfDXudSG0TXwuLoFcirhEemUa51sn6l3xxgOAmH9gnyjfTQJ0OYgXWWtgkf18P6JGe++IBhGH6uc/gKbxQdZugi5WYUmHpEZaFl0n3mj7JKawYvdKCEh+rLOCMMrIGCHx4HBaMtieqvr8kDvOqNIu+qkIYwNveQeH+TOc6CmaISmbz+O6lPLagqzG0uEyDhPI0ct/FZEJJ0IdBvMH9hNwvTHobA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hObSno420uY4RZ2Ya7kTrb2pKN20yG5EFkiufE8LQRI=;
 b=myYQIB/mJkVwQvkfPRSehFbiTiS9o//Mto34IDyuCCpAerC0tDgWnUDRayeejceiuwSobKr5qvUeT6QrauJPtvj0sSPTb8eEoY/ClodqYaed9sHVZCztAzBjUNtwjAio8MduvP4jpBOQqexjefeFFL7fgrfFyV9xlxxD64Dq4gWoP9ZZcC0sP1L12x5udOOsYI7UBJ5Rj6XlKR0l5fjxS27BjSrdsKNdrTVskZtOKncFoQa3Q4A1/mmpPJJDDGKR7/P0uTTtlQ4sRilPrd98dIgWoGQDLJkyTM+70VeSpuHsje1+gGSm/CxFcSqsR68VuyNPZM/LGgS55USkMs71Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hObSno420uY4RZ2Ya7kTrb2pKN20yG5EFkiufE8LQRI=;
 b=lWso7dztDm30eO7139p15NeUqtJqT9U7UV9FcsSXWuGQ6t0wtymXdjm3KyPVIBwMnFdgcS8MAsCu4x/QSinMDUuNl+EPVqJKtFvjk49O0TxnllYFbPK2tqO8FbxbFXt00g0oT1z9ZWdxIl+VUPb0haoJmdyQBFnwFdKF6h5Wa40=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4511.namprd10.prod.outlook.com (2603:10b6:a03:2de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 15:37:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 15:37:28 +0000
Message-ID: <a99a9fa0-e5ab-4bbf-b639-f4364e6b7efe@oracle.com>
Date: Thu, 25 Apr 2024 16:37:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
From: John Garry <john.g.garry@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-2-john.g.garry@oracle.com>
 <ZipJ4P7QDK9dZlyn@infradead.org>
 <01b8050a-b564-4843-8fec-dfa40489aaf4@oracle.com>
 <Zipa2CadmKMlERYW@infradead.org>
 <9a0a308d-ecd3-43eb-9ac0-aea111d04e9e@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <9a0a308d-ecd3-43eb-9ac0-aea111d04e9e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0043.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4511:EE_
X-MS-Office365-Filtering-Correlation-Id: 45422e88-c63b-4199-5fd3-08dc653d9d08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?ZnVsTjkvUVFERlM0MTZSTk1OU2ZncWFqd3ZaTkxrTXFpd0VjSzN5cEhXdTh3?=
 =?utf-8?B?RlhOdEFoMGM2WnJGTjk4TnhSVUVZQUxpVVcvNkxLWkYyZGdrWEZNODBVS045?=
 =?utf-8?B?eVZvWlFCUHkzRTI5RTFYMFBmVk9BUDNNNzBwdUVmZ1RMckV3ZmViVGl4MU85?=
 =?utf-8?B?YUxFMzBpTjg1bzZuejd4b0ozZVp6aTdEVHZ1SU1Ib3Vydm5EV3lpNlNLcTBT?=
 =?utf-8?B?eE5COFUvRCs3UHNrTFExNC9OYkQvNlZjdGpqb1JtakoxbzNEYnBDQjg1MVJm?=
 =?utf-8?B?akp3b3ZIeWlEczZLQnM5dkJVMzh1Z2xCemFwOUU2MUpIbnJ6cXlsZ053Z3hP?=
 =?utf-8?B?bnE0UHpVS3JScmp4TEVzTld3MFFDVkxzb3B4QWQ3U2VTRmdGd1IxU29HOXd1?=
 =?utf-8?B?dG1CT0lCd1lSYzJHOSt3Zm5lbzVNdkJDallLYlZZZzNHUmcrSjJSV255OU9L?=
 =?utf-8?B?NkJBNkZpMmdNT2VOQkVCdTI0Q2k0NVlYbGorZXFDTWtRRW03b1U4Z1BOSWRq?=
 =?utf-8?B?bXVsT01IZjFuekVZV01jUVFMSDFndjhGZEs1ZXEzdUN2Mng2bS92a1NYMmJq?=
 =?utf-8?B?Y211ZEhYRmVWNXk5cnU3ZXdMdDlJRERXNGt3MU9IL0Y1V3JmTWMrSzE0YXNC?=
 =?utf-8?B?WFlHOUhydlpOSGltVVRrY2RiMlZtcTN0b2prRTVaV1NhOXZWNU15TEVnZ0hu?=
 =?utf-8?B?V20rNUJIU1dtOThKZC9PSTkxOEhvL3cweEc5WEpMeDdKWlhyWGpMYXhidHow?=
 =?utf-8?B?NmVnYm5Ka3JQTWxUWFg5MnU1cDlFQXh5M0YxTUtSY2hERVgyNkp1ek5aV2Uy?=
 =?utf-8?B?WmVLMWw3eWl6OUtBVURKWkRLNEhoZVlIdkJ5b3FIT0pDRDBVY1piNC8wUk5z?=
 =?utf-8?B?YndNZHBLOTJhanRqQWxnbnV3ZEovZVowRFAxbnA5Q3FzamNsNGVBZHNidVNG?=
 =?utf-8?B?akVOK0FHd3ZvZk1hWGV4ZWIrVEVBcUxGeVNRRXY0ZlBVaFNUbkpFOEkvbmUy?=
 =?utf-8?B?NFcrYUhYUExsZ0lab21iSFlJbHpzSnUrN05qWjhIRHlBMURZNm1FODhYQlF4?=
 =?utf-8?B?dzdYTDgyMlZsdit4MTlOYlZwb2RoeElJUEduOE1CcUdVQWRZWTZNMXlYdmZu?=
 =?utf-8?B?czJzSnVGRzJyRnVrZk9GWWwvOHNwc3Q5VXBGMnNWZVdxWjl5Z2xHMndWMHJv?=
 =?utf-8?B?cE9VVlNxbU5Sa2FjUTZCT05KRklGTGlUTCtUdyszYjloYVJKOEZoZUp3Q1py?=
 =?utf-8?B?b1FudGttV3Uzdk85aDAwWlp4bGozaFhCTzFiSkthVWYvZEs2WVpiaER1eVdo?=
 =?utf-8?B?enF4SzkyN2YrcE5qUGRidC9sSzluMXhjOUowanNSLzdmb3RVMjNFWEtyVGl3?=
 =?utf-8?B?TjJIZnJjZjU0K2NpRndzRms4blBPakF3aFAzWEw1UGZaRDhiVGFEb04xM1VH?=
 =?utf-8?B?Vkc2RmsyNlhITk9qWGU1aGxLNVN2eHA0SmZhZnBWSk11T0ROTHRrMXJ6MmJ0?=
 =?utf-8?B?YmlKcW55Uno2QmdvVWk2dHJEd1pEeXNwYllBV1JkN3dzR1RudUFUa3JhczNB?=
 =?utf-8?B?cGw2Q1pTbHZ1cmJNeldsTUJSRUNnN09LbWhGMmQxdzNmY0JSQlRYVU9lWlND?=
 =?utf-8?B?RXJEYVovSE1FNU5FaE5hUlJSRjZCQlJ6SkhTK2xBaUF2Ym5aU1ZvQTNLdlVo?=
 =?utf-8?B?Y2ZtajhQaWVhbk5JUFY3R0pWcVE1d2JrUlBJaGk3RnBBc2MvMG1VTlZRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZDdTbG5wWFBmdG4zUUNKWlErMlYzRkhrWEJOZldOSVJ3QUtWaTBaOGVyQml3?=
 =?utf-8?B?UUJlVE5CVllPNzJ0M0dsQXZpRnBLRTFDRkNsd2hMWFZhMWFpU2ZCbjR0UFd4?=
 =?utf-8?B?cDQrUmFnalJFQ21kcjFGYlJoVk9LTVlVMkl1UkJWODhkT25GemhrTmlJc1di?=
 =?utf-8?B?eER2UlBzZnE4TWd2TUNDWU0xbU4vdTZETzZERjBmQUZvRlVtYkdUeHlDYnVJ?=
 =?utf-8?B?Y0d5ZG1RMlE5WW45M2REb2xoY0VUWWxwRG05UDdxaXpTREhkMWFJN0owSW5D?=
 =?utf-8?B?SWxublc5MEQ4emE1Mml1SXZaMTlSS1ZhRmx1Zllnc3hEWVNCVHRqdW55OUN4?=
 =?utf-8?B?dWQweWhBMjRXdGxBd2Vlc3BtYy9id25KeHYvTjRKbTZQTjBmbkRrWENyQWhG?=
 =?utf-8?B?TUtQOUZzUEhJdUwrRUs3bmpFWWFpMTQzYml0T1BqdVZkMENPUFNzcXpGamUv?=
 =?utf-8?B?TFV3QXdzRGVoUFVvZVR2RnZZa3RLRDE1dm56alZsV1JrdXFiY29JMzkzS3J0?=
 =?utf-8?B?L01HSlVXT21mQ01ZOFlqdGJhby9MWHl0WEdNN3NVTzJRVVlCZHhXUXZ5SE1s?=
 =?utf-8?B?UTk1OTJickQ1RHFLbWFzaFQ1dUNJVEhYRVJmQjhLcWUvYlc5cjZGeW5xSDZh?=
 =?utf-8?B?eW13dVcxQXJIQll3N3pzTGtVQUs0dGtWVElwcWF1OVBKelIrQTZQanpSRmxK?=
 =?utf-8?B?MWh6eHd1N2IyNTJDR2pNZ3BFaWt3VzhtRC84eUp5SjhYTmVRZTRWeTVUSjN5?=
 =?utf-8?B?K2YrR1IrdCtWcVRlWWI2UnI0cEZTNE9XRWhzd0hhcDU0YkhsUVNBUjZ2dE50?=
 =?utf-8?B?Rit3N3F3Nm1lQ3B3ZG5RWW5CZWlrbUlRSXI2KzNCaHVjay94bHNSamU2aFRs?=
 =?utf-8?B?UVZhN285bGtQa2xDcU5WL05iWGJ5aTIrNWsrYkxTbit0djk4MDBiTkl4ZjNr?=
 =?utf-8?B?YjdJTXpkRVZvZzhTQ0RScU45aEtkc0VNVmdFYUVrWFlQVWdWLzh2bTZva2xn?=
 =?utf-8?B?TkxBbVQ3OVB3eGZjM0NzdVcvenJsSyt4blNhQUwrNE9VOXdpVHFsd0M5ZlEv?=
 =?utf-8?B?RnI4VFFheHdmOFpKKzNCMmVQOEI1RlhkYmFEakx3U0JKRzBkdzdRWWt0cVFK?=
 =?utf-8?B?NGZmUXhGT2piYVdpMm84WUVoNmtDMVFkVlNVZHN1UkF2c0VTQjliYzRSem1a?=
 =?utf-8?B?bWNmTGNSOGVJRDJyVGJJWVdhalpjS1pIanlxRnJhZ084V2lodlM2M0RRZ05Y?=
 =?utf-8?B?OGZLRWxJOXFWeFdjMjg2SDh5bnlsc0tZdjJ5UDdmRmdLT0xTQmZ2WXpXRUQ3?=
 =?utf-8?B?M0VIaFlIdDkrbzdJbm1mOThhL0RWQ0QxVmdLeUNmeG1sN1N2QnFXWWlmaHFK?=
 =?utf-8?B?SWlEUHFYRS81Y3RheDNxZU16Z0VFSW1EMVVUSWlMUGdpNUhBa3VkUmU5b2hn?=
 =?utf-8?B?SnlLS3dFZ3BCRmE5b2Z1aTZnY1ArRFNhaExlZDVHMW8wR2cxWkVkNlYyU1Bo?=
 =?utf-8?B?YVh2T0lFaGxTNVdtOGRjR1dCOEgrZjVxb0JkUWJZNGRNWm12TDZhTmFxYkNN?=
 =?utf-8?B?T3lxczhxclExeWRPU0wyWVVUK1kwQTljNExDbVIzRDVyU21PUlJEVTBOSVJk?=
 =?utf-8?B?MTdOYXdvbnEyQkdmUEdYWTVIMFFBN3FxMWRxZzJXdnk3eWIvNm9tNVhWRjFG?=
 =?utf-8?B?NWtzbzNlNVIwaitXT0xHdlBjRlMwM3pDRmZMM3dJaUhkNmdZTkhzNDllRlhs?=
 =?utf-8?B?NlZzbFEwQkxtOHREaCtvUTVZT29zeEk0b0J6Zld3dExlYkI1ZmZ1dzFKY1Zw?=
 =?utf-8?B?UDJ5MmhNTTFmbGhpVmpid3VJbVZ1MW9ETXFac2trMjlQbFNZcEpwdS9KYk5S?=
 =?utf-8?B?MFRDYW5pSVBzMUJZZHFhekRsZEdJZ2JJd0FsVFZ3UWNvQTgvVkJsK3d2UzF1?=
 =?utf-8?B?eStrYlpPUzlVTlE3WU9EbzhweXBTUC9vSnhrQ0xMSGM5VHVKNkJOektGMGh5?=
 =?utf-8?B?cEhvazhCNXo2Z3g3M0U4L2hUVzlKOVRqOUc4TmFhSjk5VlhTeEZjNkJibHRs?=
 =?utf-8?B?VWRWVHczUEhMelNkL255Tm1UQ2U2NWhwemcxU3BkWnh3a2ZTakljNEtpcDFB?=
 =?utf-8?B?dXJHeVNibnIxTmk3T3R4YXd6UDVNL3hYQVlPTWJIdWRHN3BRd1lTZFZpUjRu?=
 =?utf-8?B?Umc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	XFyhGImD2iBAkLc7prHbalor26guiCXqoOWUQp0jlRy2KhuAH7VRCkq5VgCMQVlVNC3V4Ex9rB6OMaP4m14Ov0Mg5RyRQ8DOJmlUpH+vHzWaYZILnQcfuqJdSoqX0hNXpksOp4eLYB6W3a8qxrdLeLFncyNi7vEyp534+YW6WnYy8fmWdHeTUvflqTwTLYuJ3y3MHnJtzgfIMSv61V3bvOFX/2H9OAmqgiFarUDVCKahoEqNU8oINKc/9X7uatIx5FFrHt8sPLVU5bPdVqI41mv5gU0SGwdvMYucVqIt9bMnPd2HMwhOpPV+vwYdoQYN+RSbNiICPjN5Bi71UvDX1zqrgo4EzcbBooaGd7VCMbhvYzW7RPWKp/za3WwxqU3lhX3d6bbTYynxQZJ7l/MibQQt7YPHTdU0usqga+83COo0knybPoy6qCcm0D8A/8WROAz5kjdkkT5vfW2i0YA39uvwpGJ7pu543ADNmbJumuce5yrdpa4NzwB3kx2DLdKur2vq6fgEdLD/s8r+VSBYr/vWmPIXWj/csR1W4HlR33aw+xxRG33r0Ac0OMcTdGVUxPXCG84fHpD1zXpipKQiupUNYRhqqk8uL97sXkbi4yE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45422e88-c63b-4199-5fd3-08dc653d9d08
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 15:37:28.4298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QES6WdOiXYtbmB9/5YUZtJaXVtz6H0sT7z5z2NdW1aa4tW0ZRMRzkV1vq5b+hROP97LtdJDbmsGkKa+xfWbAtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_15,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404250113
X-Proofpoint-ORIG-GUID: qPatxcunwW_L5kbHhyAB6mBnDR7tRUjq
X-Proofpoint-GUID: qPatxcunwW_L5kbHhyAB6mBnDR7tRUjq

On 25/04/2024 14:33, John Garry wrote:
>>
>> (it also wasn't in the original patch and only got added working around
>> some debug warnings)
> 
> Fine, I'll look to remove those ones as well, which I think is possible 
> with the same method you suggest.

It's a bit messy, as xfs_buf.b_addr is a void *:

 From 1181afdac3d61b79813381d308b9ab2ebe30abca Mon Sep 17 00:00:00 2001
From: John Garry <john.g.garry@oracle.com>
Date: Thu, 25 Apr 2024 16:23:49 +0100
Subject: [PATCH] xfs: Stop using __maybe_unused in xfs_alloc.c


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9da52e92172a..5d84a97b4971 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1008,13 +1008,13 @@ xfs_alloc_cur_finish(
  	struct xfs_alloc_arg	*args,
  	struct xfs_alloc_cur	*acur)
  {
-	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
  	int			error;

  	ASSERT(acur->cnt && acur->bnolt);
  	ASSERT(acur->bno >= acur->rec_bno);
  	ASSERT(acur->bno + acur->len <= acur->rec_bno + acur->rec_len);
-	ASSERT(acur->rec_bno + acur->rec_len <= be32_to_cpu(agf->agf_length));
+	ASSERT(acur->rec_bno + acur->rec_len <=
+		be32_to_cpu(((struct xfs_agf *)args->agbp->b_addr)->agf_length));

  	error = xfs_alloc_fixup_trees(acur->cnt, acur->bnolt, acur->rec_bno,
  				      acur->rec_len, acur->bno, acur->len, 0);
@@ -1217,7 +1217,7 @@ STATIC int			/* error */
  xfs_alloc_ag_vextent_exact(
  	xfs_alloc_arg_t	*args)	/* allocation argument structure */
  {
-	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
+	struct xfs_buf	*agbp = args->agbp;
  	struct xfs_btree_cur *bno_cur;/* by block-number btree cursor */
  	struct xfs_btree_cur *cnt_cur;/* by count btree cursor */
  	int		error;
@@ -1234,8 +1234,7 @@ xfs_alloc_ag_vextent_exact(
  	/*
  	 * Allocate/initialize a cursor for the by-number freespace btree.
  	 */
-	bno_cur = xfs_bnobt_init_cursor(args->mp, args->tp, args->agbp,
-					  args->pag);
+	bno_cur = xfs_bnobt_init_cursor(args->mp, args->tp, agbp, args->pag);

  	/*
  	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
@@ -1295,9 +1294,9 @@ xfs_alloc_ag_vextent_exact(
  	 * We are allocating agbno for args->len
  	 * Allocate/initialize a cursor for the by-size btree.
  	 */
-	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, args->agbp,
-					args->pag);
-	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
+	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, agbp, args->pag);
+	ASSERT(args->agbno + args->len <=
+		be32_to_cpu(((struct xfs_agf *)agbp->b_addr)->agf_length));
  	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
  				      args->len, XFSA_FIXUP_BNO_OK);
  	if (error) {
-- 
2.35.3


---

There's a few ways to improve this, like make xfs_buf.b_addr a union, 
but I am not sure if it is worth it.

