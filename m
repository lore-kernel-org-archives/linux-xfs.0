Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9456D1F9428;
	Wed,  8 Jan 2025 12:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736338583; cv=fail; b=Pl5M99FEO7C9juCw555ykaZGI+ab2ryHgndlCZaFUs3Ez0zxEq9yLceTUDN37XbUWwtI74ea6PPTsqRJE3Q+fT54PMIjJTcRvXVyhki4gaSvFZLlL9TWG3c5rW3VxuRaGYe6hkVpYoRS9jgTUBmqPS+fv5t2yBkrXYOez9a7YIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736338583; c=relaxed/simple;
	bh=sUxabiNsOd9r/+JwzaVDUaxpVhP5OLPYhI9O36QyIbM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=On1M4z7KlJ6xUawoMChHwrSS4ohDVfIsgymIJLwjoNPlNBFz9domvpjWEeuFPr3MtiO7/JMqnosD5+CRb2/UgF23zqGe162oHfA3xP63lLI7CWHNd3ADNX1Wlijg5t4CL4XboRr2ktQbgX9K3ZDazIkWpo+mVpYbQnylaFENNa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NqP+2cTB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wMUdHxd+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NqP+2cTB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wMUdHxd+"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5083kR3v015482;
	Wed, 8 Jan 2025 12:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=MR7VNbGoNJYyu9BpNsq6QzL+K5BOr9VFaBZEvsVWNaI=; b=
	NqP+2cTBIQOkoMTqi8LHILpqGL6XtVVMGDcfwE9wK1hyMs0qWTXNW/28wT5//nYR
	xhM6BC3dS5PuO4LPBr6jctHYj9QvxV7aKWJkO/2E9wrhG5dOv6H3eWkR7vPeHGkC
	VY971JDHg8fpzOqkzGS16SkF9CN2WN98NFv/d2VLu/cEu6Af/6PPHfVVqX3v9pig
	gsuwZehJD7iBtJcvaPHDlH1gvlr1LQhUpzNEVcPp3OSThY4O23chr4DZe3YQ6DFR
	wGwXJvsc6OQSQdkTeF3WHKB5hVupUyiv+wT5Fxnq3pOVuRAJHltTSB902a8M9f5D
	CUPMd4jxvRvrz24dTs4/rA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudc6veb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jan 2025 12:16:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 508BW5A9025436;
	Wed, 8 Jan 2025 12:16:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue9xkv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jan 2025 12:16:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GIzNZwglN+tFAlYtxDpExS4XtYjv38nQLlaGPLTOyJ94TPgDyLPV6q4qD+WWdB9zNXpVc+FofpKmhcT8dLmN0ISuvLwbIfuqJLFgotbL5Ko/YloByCfFLCTDGiN2z3x1Bi8z6fzhshwKgE2rfzJaeSJCjkJJbCtJGJqsJGdOY3coYP8vlxCHOw2TbBnqKvKf0Zvbz9ymuq4p0WW8oNIZevbMKxEsAf6SbincVUqPxuCPSbcOvWozrJa/INaWyeW8cs5hBT3HsRfUDJd2Oe4zDAqSHGau24eSV8EqA4dzvVNCMJkM3nWSqN9tmXbi57uDvEMpHGZOfjrJmG17xPbunw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MR7VNbGoNJYyu9BpNsq6QzL+K5BOr9VFaBZEvsVWNaI=;
 b=GzZ/FVLyPq7wOfT5gRq2ta8qg+L69z+wk0j+KqCIGARHzgGMqWgqdJmB9/JuLIZFzKDagz/hoTJx+N25NhF3etMAoLnrTNBSebTg/pyZeTcrx7GrFggxRXcXnn7Ydwac9iTsxgeAWAGvYhpBxTGbzhKpthdyB2EPqNV5uLZIs2V91V6JwXcLyfCUUWB+5oIIC4Ds2SPsXAOFpmy4EtbMCVcHf7frRr2NaNbG0Uvrj5JWwmyMJc6MVw3Jl+hXhWFGSJTJ8JoM0B8tTn+VVQ7zJOYKkxXriky2ihkRSbbuanJ0tQoc5GHOO7dcuFqftsLHhlrEO/kJcCpbTaArDfHp0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MR7VNbGoNJYyu9BpNsq6QzL+K5BOr9VFaBZEvsVWNaI=;
 b=wMUdHxd+ZXSU61Y+GX/25TT6kTDNFM6goV4lDNLxy/dEknBzwLtqSBdPN01N3JNTBY4NaJcdgtHmaqauo+nxdfdUylUBoyA1g77QTBamKAJLxvoC7n0gO9/EX5qDdHpI6M+5v6zqCsvq2vyHHokfMlvQ1NF14cu+AsPcv9c7OFE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4124.namprd10.prod.outlook.com (2603:10b6:5:218::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Wed, 8 Jan
 2025 12:16:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Wed, 8 Jan 2025
 12:16:01 +0000
Message-ID: <dca3db30-0e8f-4387-9d4d-974def306502@oracle.com>
Date: Wed, 8 Jan 2025 12:15:52 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Amir Goldstein <amir73il@gmail.com>, Chi Zhiling <chizhiling@163.com>
Cc: Dave Chinner <david@fromorbit.com>, djwong@kernel.org, cem@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chi Zhiling <chizhiling@kylinos.cn>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:196::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4124:EE_
X-MS-Office365-Filtering-Correlation-Id: f1daf861-d743-432f-16a4-08dd2fde3713
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TWY1M3FtQnkxTStLc3o0ckpPbEUzK3YvVmRwSXpXTWRFT1pHNlRSSXppNmJX?=
 =?utf-8?B?VjcrVnlGd1B6YWhVdHZzY1UzQStrazhtYk8wWWdLNExtRGswV0p3VTN6WnBS?=
 =?utf-8?B?cEVrL1NPV09FaWFQMTAzQmtOU1FRMHNyR0VlYlN3d3dmcTRYM290SWZ5aFBk?=
 =?utf-8?B?bmFmM2ZVNDVkSFAxZW4vTUFtYngrYU5KVlNwNGtIdjhtZWJKRkNkNXkzKzBH?=
 =?utf-8?B?YUNYM1V6UjhpVkxsK1Q3bXlqcEo1NUV2dGR4YmdVUFliWXJmVlY2OTJqdGhw?=
 =?utf-8?B?cDZQWXVwTkhib2s5aVNJS0w3aUI4c3MwYkYzWmpSbHlIdVk3OU02dm5GL0N4?=
 =?utf-8?B?bzh0VWp0TE9XbHUyVmxhR0ljb2RvU0hSemhlYXB5cXlTeDRYbllTa1JpS3Ev?=
 =?utf-8?B?RlgrRG5QMThMaHFIMXlqTlpISDd3SVovUlJLMDRyd0VFSExOZlczUDd1aExP?=
 =?utf-8?B?UkpaMTVyZlNJM3lhOCtoS2NMeDYrdWVTdFgrcFpaanh2c3J2dlZ5YTBnVXpB?=
 =?utf-8?B?Vmw0aUtHc2ZNdS9GQ0JjQTI1TEFMdFZjM2MrUGFmSlBGcFBuajdIclJ4NnRR?=
 =?utf-8?B?a1VWZ3RvU0lhWGl5dzZvVVdQbE9IRVo1ZVpLVDJab3FlZlNVTXpYc2hEZ0My?=
 =?utf-8?B?c1ZIajVwQU1FYXJYb3NiTTVYRllkU0pVamJNTUZuWlE5UkR0bXp6bW52c2Y1?=
 =?utf-8?B?cG8wRXpqTHErb0d6NXUyeGI5RzE5cnZsbm5SUUtGVjI0OUlIVU1lcGVYUjFj?=
 =?utf-8?B?YUowUHpDVmFpVE5tSUlyUWxYTSsvMXdQV0NrZXVLampwa1pvWXBEZjBSOTRi?=
 =?utf-8?B?MC9hR0diSjloUWp4eXpNT2M3cnhGVnRiRnNhbUd4bk5od3dQOXZOUDc2eFJ4?=
 =?utf-8?B?dTRjZk94Y1RKcDQwVzBRNk9SS2Q1SjB2VzQySGFkUHRPQzJSVDI4TGlteGRD?=
 =?utf-8?B?NlJWMXdRNklKcHk2ZnlKTWZ3c25scEFLUnVhK1NkdktwUk45QnJyNkJXc2xj?=
 =?utf-8?B?azdsQUxiYjl1VU15eVVkTjc0d1FwdlUzNUVONXhhQzFlbTdReDYvOWFPSTRJ?=
 =?utf-8?B?bFptYVNhNXdHL3phQ2RENTVuVkV3NXptM3hnWlROSEE1OWZ1Q0lnWkMvRFYy?=
 =?utf-8?B?L2p6SlRnVVpoQVZhSG5xK2VrWk43N2JWTGhsRXpqdWFJaUU4cUdsZ1RKZFRm?=
 =?utf-8?B?LzlrUlNSUks5NjJjOEZvVXFJY01xSHJmT3N4cmlvSTJvdnJ0NitNY0hkb1ZN?=
 =?utf-8?B?RG4vL0FxK1hlUGx4bkJ3S1pHUmN2SmdGbTlQTU5jcklodEF5RVRjV0RnQXp0?=
 =?utf-8?B?aEQrYzdTQzNvM1pPZFZ6OVl5MGEzZHhyS056ZzlMeFdWRTlNTHZyOHJMTzYr?=
 =?utf-8?B?Ui9UMGlOMjZjSXNiVFI1RCsyRVZaZVo0ZUxoWllaVlN4eFFTT2FxZ28ycnhi?=
 =?utf-8?B?aTI0dk0vVzdxc3RxaDJaeVU1dXdKU1FHdU8wTlNyZkE5SEFSbWZSTzk5QzBR?=
 =?utf-8?B?NmU1NUF2OHNQYnk3WmVjSkE0L3JUMXFrWUllWC9zQkh0bG81aU1mTzRmN0t4?=
 =?utf-8?B?S0QzWWZSUjNwdmVtNEZ3Vk9LRjBNMXZTK3VYUUdGUXZQWTVaMTVCVUt0Mk5P?=
 =?utf-8?B?VFVXbzcveWoxZ1BvN3ZPNlZQUmlNUGRXZ1c2UVB6dS9SZWg2S1BpM01DUXhG?=
 =?utf-8?B?ekQ4NHRYTWZxblJLakhpTG16aklYYnNjQ085b1Z1KzZlWVpXaHNScWZ6YU1l?=
 =?utf-8?B?ZE45WTRVdFlUSzhycllKaXc0THhSVklkSm1SbG8wTkFwNWxITTJTejhjK2dR?=
 =?utf-8?B?SGxod3BDaVBuT0FwR3czVkhiNktjd0FqcjdIU1hrYzZGTWk1ZU5ndGdsVUZh?=
 =?utf-8?Q?ZYAO43TGWxLic?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UE1rY3J0c2t5WU5xNDJxZ3FoaUtYTkJsZ3NpdG05cnpLQ0hyVjdQWGxYNXha?=
 =?utf-8?B?M1BXUlZ2Nk1ndytGaWFxekh5U2UrcnRjSUJycjZFQjFPRGhkZHkrV1k3QUJ0?=
 =?utf-8?B?QVJXZ0tvSWNaY1JmWDNPK0ZBNFgvb3V5V0dlaDEvMFNtMnd3ZXBDRXlLZXo5?=
 =?utf-8?B?TW1kbURaS2NCUUw4cTlXUlk4NnJHdmVuZ1AxNFcyeVpDOE1pYXU4Um52Ukl2?=
 =?utf-8?B?T0lQMjI1ZHBQSkhmelRkNlFiU054Y3FvWnZDNHQ4OWpKbXR5RDFxTWRSTnlw?=
 =?utf-8?B?bGVIWlhaOURyRmtWY2Rhclc2bmkrRTdISG5pMzVYQTRRUmVtbjNnRmtHUlZj?=
 =?utf-8?B?QzhPVTU2VlQ1MzRscEpkOFhqaStsWlpuMmsyNzRnTmxmYk9GMXhMV3JFZ1FJ?=
 =?utf-8?B?cCtCZ3hid1NMMFV5eGxqY3E3akNpMVhDN1BLaU5QUWNVdGN0cG9jSHBhNS9r?=
 =?utf-8?B?VXI0c1dMRjE4K3A0Z0Q1a2JTY01jYU41UVBKZDZRU1Z5N1JxZ28zc2hZUlRS?=
 =?utf-8?B?ZVRXSFBySDBlQWh6OWJxU2lYTnhhbjh3UmpRTXdFYWUxSFk3a2pEOWdqSi9C?=
 =?utf-8?B?TmErR2pCeDI4RWF1RDA4cVpBeWlrdFU1dlpNdWR4MWdQd3FWYWtkU0NzbDBO?=
 =?utf-8?B?cmRWb3p0VnlHQmtmQWRXYTVDbyt4OHpnU3ZMMkd3YkkxMkdncUVBbkgzamc5?=
 =?utf-8?B?SlRrV0lMTUdJamZXdytiQk45WnRhMzd6MlRSdjhIbEJISVAyOTBxV2lTUzd4?=
 =?utf-8?B?czk5NUpack9STHJFNFBEQmZCUERnVjhCTC81RjFYRWtQdkVFbHhrZXVyZ003?=
 =?utf-8?B?NmpvTlBNdzBmem1GSEt6ZjFXT3N2RkVZdTc4UGVGYWZmanlXKzJIWm50VGcv?=
 =?utf-8?B?M2I0NUpQekV2OWdDcHJnQ3d6eWpBeHhMa0lkM0FQMEVnV2pTQVBxVW1NMWZa?=
 =?utf-8?B?RlpCYktjdHRSYXlYeVJNU0lZdHdZZVRlSWg3c2hESWNpRFZHSmdZVDhNSko0?=
 =?utf-8?B?TTZhNjhHbUM3R1RseE5JVVVNeHBNSVVoVENneU5MZGxWVUpJcUQycnU0M0Qv?=
 =?utf-8?B?QzE4Y0dXeXZyUnhBeHZFOXZNd3Q0OXhJWnFyMWZjQm1wREppVlNnZDhHTGRX?=
 =?utf-8?B?dzQ5TmwvR29wQ2pPeGNYdG9aUWc4UlVndEpjN1A4aGJjY0F4ZFk0YUNwUE1i?=
 =?utf-8?B?dkFISzNGRVZycmdtdFZHSkVHQkg3d1NSbFNkZjhvMEU0WHVERXpwVDRwUGRZ?=
 =?utf-8?B?dEROUTJUdXV6YTlTakY5c25RZ3dZbGYvSmRlT2FsaXVJWkZTYnd6Tk5UZFJL?=
 =?utf-8?B?aHA2dFFMVkZOTFVGWmdlYlZ2U1FxUFM2cVZKSXVQc1pjamZoVlYwMjJlRVBE?=
 =?utf-8?B?eWpYSU9qM3FvcEJPSWVYbzd3NTBWVHVaSkhuMTJDR1dsbSsrVHQzNUVDV1M2?=
 =?utf-8?B?YjZBdWV4V3YyeExkOUlKS0tZSk9yc0hDeE4wNG9nQS9XYk1tNTRWR0tZOG9w?=
 =?utf-8?B?ZkpMSUNsd2VyR3ZoVGlBcFBWUWZtNXZ0dkpRc0JmTDVuZUZFem0ySC92Tjdk?=
 =?utf-8?B?OEhUcXRNTTRKL2l2M3BKZ2wyaW5xYjU4V3pYejd0b3ZvMnJ5clFZZWRUcWtI?=
 =?utf-8?B?NjFMSFZuUFZtQkVTRDl1QXUreEc3SWIxS3YvRUR1ZWNDYmdlZWZDMEhDZEJV?=
 =?utf-8?B?RmMyU2Z6bWdpOWpGcDJsZ0VyVnVGM0pIVWgySytuQ1A4S1c0RWl5Ny9SMzVD?=
 =?utf-8?B?SjJ6a1V6dlJOMDl2TXJtNGtnVjNHRXZ2c1FPbEpFL0JNdlgrMUcwZ1U5OUhF?=
 =?utf-8?B?Y20zcy9IVklQclFxRzBob3hLVkVWV1AxN25HSmZXbkUyMndCdnJid1dseG5T?=
 =?utf-8?B?YmdvYStRVmtVM2xJZytMMTFXVnY3TUh4dXozUU5xWnBDMjJlbWVGN0NFNERZ?=
 =?utf-8?B?ZVNHeWRQTUlJLzFVcTZEK0VFU3paRDdQWjlxQzcwNGEyQXhMSnU0anBRMEl6?=
 =?utf-8?B?a01XeC9QbTMxQzhRWEhhQkpWNVhWVXlnQUUrajdTYXNqeE81ZFdWRkRWL0lV?=
 =?utf-8?B?S0tTelhmY3RrdTN3TVFTYmRGeDF2OTlRV1hhWStSNTRHektONlNNSzQzRDNn?=
 =?utf-8?B?S1QvNk5lM3l4VmtUOWJYRE9xU0diSFZGU0hzRGQ5L1NCcGxaa21sbDJqS2ZF?=
 =?utf-8?B?Tnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nv3Fy6y31LnpdL1AoC5Y4ATAcHnQw01DxKIcPCxKuOEaIMsGI+C5od4au59i88MeMfj6H6gWa8sGIEmx3xo2t0KgR87qZ5m+8kxr/TOJNp8NzLRr9DrijtnW0NG9eWtTrteT5ooqIM+q3AkltP86ILGGsFr5h1uIFDu/eRbmKeVNA0PlrRhKY7/QMBq7tTiz0eF0cyu0tsHsF9POpv5Fk7GEqNRJTbalHGaXxR5fR1RsehU0HOAaumnjFi37A0b7eX0PXElQW/jKkGvTGSKwjWfnWLmrIHbZo1W0QZtYi5bh4uGIXQb1RcJ3F2VmM4qUddYELva2bL8qn0UysXyrKVUBwwfHCORR2kHjnZ8YpkgKssn8R/J9RHHdT3uFvBelbdH/5mMOOTKdeeyz4IquQyvimErIRIp4i58Ze27g3ViruRpvtMJLqIaRsUMkLmvZTSABf2tQJJIAd+5qejYI/8EWoDTm59YnKg6Up3vPA/8RoqMHCpTxsWUfJRHgp+yI3fG3GGH9Ml8PE5cA/IqGMYCgzvo6j+JY9LCwhMyxO+lolpM5a3lVJQHvJ/3Tjsc2f71lZgOrjIpoze8XnGrnNYKCTVawQZrcGsUdCUy+xnU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1daf861-d743-432f-16a4-08dd2fde3713
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 12:16:01.2795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: si8h6C2vJDSJINDqkFaUkamW+AAkcrfPtSOqeJgatwK6qkbaepnEzCgyhrDl05jxFVeVZwV/H+IuJ6H7CaeNZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-08_02,2025-01-08_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501080100
X-Proofpoint-ORIG-GUID: vnxR0t2HZ74JnSQIAT6kq3h8J0vstkDC
X-Proofpoint-GUID: vnxR0t2HZ74JnSQIAT6kq3h8J0vstkDC


> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c488ae26b23d0..2542f15496488 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -777,9 +777,10 @@ xfs_file_buffered_write(
>          ssize_t                 ret;
>          bool                    cleared_space = false;
>          unsigned int            iolock;
> +       bool                    atomic_write = iocb->ki_flags & IOCB_ATOMIC;
> 
>   write_retry:
> -       iolock = XFS_IOLOCK_EXCL;
> +       iolock = atomic_write ? XFS_IOLOCK_SHARED : XFS_IOLOCK_EXCL;
>          ret = xfs_ilock_iocb(iocb, iolock);
> --
> 
> xfs_file_write_checks() afterwards already takes care of promoting
> XFS_IOLOCK_SHARED to XFS_IOLOCK_EXCL for extending writes.
> 
> It is possible that XFS_IOLOCK_EXCL could be immediately demoted
> back to XFS_IOLOCK_SHARED for atomic_writes as done in
> xfs_file_dio_write_aligned().
> 
> TBH, I am not sure which blockdevs support 4K atomic writes that could
> be used to test this.
> 
> John, can you share your test setup instructions for atomic writes?

Please note that IOCB_ATOMIC is not supported for buffered IO, so we 
can't do this - we only support direct IO today.

And supporting buffered IO has its challenges; how to handle overlapping 
atomic writes of differing sizes sitting in the page cache is the main 
issue which comes to mind.

Thanks,
John


