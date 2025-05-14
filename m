Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D337D2797A6;
	Wed, 14 May 2025 12:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747226852; cv=fail; b=CfpuS/nySMy+O1/L8CcqEx5prfmNm1eLBzRtYDyxy+1WqaX7YWMmZULIfUgdTQPQtnlrv2/+kiribJyvu8bou/mpQAktIqI8Ju9p6F4t2No5isZrvoFUoi1A6TB6aXybgEPDdDeXlfjxyT+2xfFAH0czQuC7VkQ0OUA+MySQ3zI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747226852; c=relaxed/simple;
	bh=kCVXJWt+TRPaT4RSh0cN5xN0AJElsz2ELf2imWCfLhE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jJMYYKkL0ZGoHE+ApXq3BzZGHafSbmB/68Y9GcsoTQnxvQzmuFv9q8C7/678JmeivxOKkmDfByDvVw6dRdzXhPZgpzivSb0czXj2ibkDnXYtQDy0tBNHuy0QIs/DvyQwD3WtKQvkAdQfoHt16GkDqZqtKBqO5PZ6mFcSPb9It/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hQ4HmSuF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VKGN505i; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hQ4HmSuF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VKGN505i"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EACKDw016415;
	Wed, 14 May 2025 12:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WkywQb8PSXvWWamHbNRQQf1ni4wUTwYT/TliqlgAiNE=; b=
	hQ4HmSuFNp8prxpU6q54sesSqSBwqhw2tof+rACNExKazQQlLEvxowgJKqm+8rCe
	ENwiojItt0Totmc2yQc4+j8ku/5QjMppRXWjRQQi9h4pW1GiC7mE1Xc0mdAqAGM9
	rQNFTreIUKnzb9UskKf6l+QqLRxGsYc274k9MMw9Pg83hmSccwPQf0IeYBkxx4Xp
	BF/4tV6epWl/7C6b9/2mXkDeXGBpFuX+k+cMH06KXiVeISbB/eNcZzDazY6Nfavz
	KW+tQVpsLVdBrpdN7McHz287FrUWCpO7M0JfA2/3jiwC/TnEdM8MMPy+rPC7L2bD
	K3driUvyuPTnqCflv1hmwQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ms7braxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 12:47:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EBbJqh004467;
	Wed, 14 May 2025 12:47:25 GMT
Received: from sj2pr03cu002.outbound.protection.outlook.com (mail-westusazlp17013076.outbound.protection.outlook.com [40.93.1.76])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mrmcpd6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 12:47:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IyVxE6fHVPnYfJtII5HvikYoI24am/ENUMuvJ/m9BHNnOoZozCxqk49QzmY1HwNjve8CSMHChceikvMlB6Zn5qbPL6INOvwE9LlrSjh6XlMeTg9NV19NTuy1UA71s2Of8Q/WVFon4YuGmbxn2+2sv34Pe0sHjwC5cZ+1xr6JItVbkqyce70B+1S61eWN8NmfMqJkm7LL1r5aum9HEo323/0hXsbyoJ2VeU1Bby0/v9wp3QsEW+43NqJ97FxJCKwjsekbbShHEip1ViC2xNRlNnB1dbXJQ0dPD9gyzJq1S1Jq9KeHBr3esuSQTeYNQfO5qNlzSWk98qCb8Rw0zg9N8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkywQb8PSXvWWamHbNRQQf1ni4wUTwYT/TliqlgAiNE=;
 b=mboTTIa8WUwsgVtDDBiLT44zSx67FHjhxnAAokYlkcQB6fcr/Wrb9iFUqgiIrQt9cIwFUvDq0Rn7b8k8YzWj6r7JoTUu1IrWlp8kv/pPyV982bOHYdjZcaYB0fpGYEQGSjq9DWGvuZPFvA2QuEi187St4avs38B3fzp8odSrK/MkBahftG9D1SX1WptmlsVXFH7EhIxvXWYlhzh4Y3caCGlhtcA6nddhCtlZF1WxPr5bKT2BHZudAZI0Pf0SBPqiM7fogTFKGkWYAlRt0m8SInAjkQM7GLJLZmHVNMv91IPjpVppBtb3yjWKSCOoBMURntWPrIolwbW9w6M5Ngo6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkywQb8PSXvWWamHbNRQQf1ni4wUTwYT/TliqlgAiNE=;
 b=VKGN505iB+vRa+MuxIJhYn3M626bGBdzfbVp6mSlQu5ikCESXAl9CcwMbCiC8Ayu7liUmlkJzzR+lnt9AyRvgjLBKoGWDAtAFBikNcLM85/SUXUhTgboyycLIXq94tcI5roHziYUKF34eTKCph5Yal+E5nr6i7RHpMa262wYoAs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ1PR10MB5977.namprd10.prod.outlook.com (2603:10b6:a03:488::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Wed, 14 May
 2025 12:47:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 12:47:23 +0000
Message-ID: <52fc32f8-c518-434f-ae29-2e72238e7296@oracle.com>
Date: Wed, 14 May 2025 13:47:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] generic/765: fix a few issues
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-2-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250514002915.13794-2-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0023.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ1PR10MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: 69fe9bca-2287-40e2-bdcb-08dd92e578d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dElpaFNUVHAvQmtka0FNNFpvWkxZS2xUNldZYkt3YlFRUEJaK3V6Zkk5OGoz?=
 =?utf-8?B?bEY1Y0VISmFmMFIxZmxTMHU5eEhBNE1McmVxTUszTEZXOUZ6UUd3Y1E2NFFw?=
 =?utf-8?B?QjRHMjVzOUdsdGhxMC8yU3RIYjV1Ynh1R0VLOVVoVmhwRHZqdk1wY1R0Q1Qx?=
 =?utf-8?B?WTlYWGZPSHhFaHZmcEp1N1dBd1duOXArRTBCT01OZU9wN0ROK2ZCTkFhbHMv?=
 =?utf-8?B?dFBKSTE0Y3VJQ0dDa0JkRnh1M0o2eVBhK2tNVVo1cHI0SmdETjBGWFhSeHps?=
 =?utf-8?B?QVZBQXFhRFpYeWJvL09QZFMwR2x3WjZjSFZWL05paTFpenE4dGFJdmkvZ29p?=
 =?utf-8?B?bUMydlh5d2ZzdTJzZGo5ZHZQT1QzNUxBYSsxRkg2dXRMSDVJMzd1SmJpQ0lh?=
 =?utf-8?B?dlVHNld0YzRRczc1NVhXejlmZDM2dFRyZHNVVXk2Z1kvMXM4a3YxYWNkeFJH?=
 =?utf-8?B?VnNrbWFSTXpmeXh0cU1CVkg4ckFSRjZqNGFRb2FKeDJlZ1JxeXFRVXBZRUw5?=
 =?utf-8?B?MmE5MktpZ0ZBcnFaQlFOMi94a3lwOElqbFY3NmtrcUoxMVlFNE5GVmpTYlY2?=
 =?utf-8?B?cFhacnJHbnFzKzB6S1IySTNURU5rMDhBd2Y4YnZJTkd2clZ5SUFwMVhqM0Vr?=
 =?utf-8?B?emFzakhqYUMvMWRMb2o0WWY5NDQ0NE1OMGRvYUJ5dDB5SGxEMXhUb3E4WXZz?=
 =?utf-8?B?R2dYc0o2VjNPeFV3c3VRNXJoMGhlem1QaDc4QTBuYU5WQzNZYmx4eE9RR3U5?=
 =?utf-8?B?ZktYaW5wVTlUMVVUTnVRQnNDYkZZR2xYK3Z2VDBtZXdSVjVreC9OZ1BOc09J?=
 =?utf-8?B?RjlxOHB6SUxsanUxaGZMWGE1N0I3Rk9melN6QktKdEljM2tQWGhPZnRkejFa?=
 =?utf-8?B?aktYSGlrUTZzUkYxMXRvN09GbE9hOGxGUThQdHM2eXJmNUhzZjdBZGJmU3Q1?=
 =?utf-8?B?Ry9nNDREM1p4alhMaFBCdHgzeU9KTUlEQXBKQytnanN5MUtZN0o1a0ZOSk10?=
 =?utf-8?B?L25jVzYxZmhQQzR6OHluSjNZRUdaQmNCYTVKV2Q0elhUVkZEME13MWxZbEcy?=
 =?utf-8?B?Q3d4R0FBVWNUOS9WR3BtbmZtd1IvMjJ5U3BnbjhUd29zM3FWUXJKWVBUZUpl?=
 =?utf-8?B?WnlKTmdNbjJPK3c2ZWtYUDRoTVRWb011bGdXMUlWek5JdFdJUVZ6cWRKbU9a?=
 =?utf-8?B?K1pLRmJKdm1ndzllQXQ4dW53R2UyZ0EzbkZ1d1VrWTluSnRtbWVhOXB1T25z?=
 =?utf-8?B?cWptemdzUThRVkhxVFMvT2ZRSldPVThXV09DRE9SaytoYzJhalpXSmp1dXc4?=
 =?utf-8?B?TDRwZEdid1VHeWk5YTZjMHl2UGwrZnBGNU9iS1JESVZCSlJ5V20yNmU5bHlG?=
 =?utf-8?B?bktPMkFXL0JmK05ScTNJVWM0WXFhVi9RY2d0aE1QNmVic29lY2gxdE9FekNk?=
 =?utf-8?B?NUZkdXpUdXBacjc4YmEzZk5DK0pnbFFDWlphTFNVZkFDQ0R0cG1VaFRuQkZJ?=
 =?utf-8?B?dm9VT0JjWStDTkRqZmF1OXBzMTd2Q0VvUkpVNlJ6SU9Ka0ZYcVg1SE5IeUtv?=
 =?utf-8?B?N2RnYkRZWTZ5cDVBTERCZDhwN1JmV2RsNDdRK2ZqYW1Yd1hEbVRvR29GaHUx?=
 =?utf-8?B?Zk5ydkhBMFZEN1MycTJESFlpbzQwUkZzUlYwUjBLb2czZXNkb0pNTU5FMnNE?=
 =?utf-8?B?V05lSDNEUG9HQ1NsYk1Ob2llVjdvclFWWGsrbEJlK0VoaklFbnpqcjUzQy8w?=
 =?utf-8?B?UzdSN0ZtdWRwOFJHaDFZSWJ3YXpBOHhRTFlmUzhocGNmaDJkcERCdkRpZllu?=
 =?utf-8?B?VkcrNWV6b25uVFBXWk5JekJzRzdhWWIyUCtjRFo5OW52aWlCUDBoYVFsUjJu?=
 =?utf-8?B?VXNHL0Y0dEJobXNHcnN3THBsaS9Uam13TFVtL21aY2FGUU1YMXhEWkE5YjRE?=
 =?utf-8?Q?ZMSqywXTkZQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDJISUdNdE5HZUQyS2dyNGVPMk1UbXdiMTZkV2pEVWo1dCtTc0FJTHlGeHNo?=
 =?utf-8?B?RDQwMU01b3h6SnB6MWFINGdjNkxrQ1NVWmI3RWVzNytCajE1c2NtZkRRaGZK?=
 =?utf-8?B?bjI3QVNJbzNZbkM3cXFmeEtYbWI1TTlzTnkrWENRZG9xbXhRSmllQ1JlS2xt?=
 =?utf-8?B?OFh1YlMyb1REaHhyYmYzaVQ2LzNXaDdnMUdLY1Ird1Y5VDlCZzVDazBnR3l3?=
 =?utf-8?B?ZEptSVhGWVVTczZjSXIzOWN3bm5pNGVrbTNmeG1tbkMwbEh1a2RQbmg0dmZL?=
 =?utf-8?B?Zy9kYkE2WmxnN0h6TCtIUHNLVVEydVlsWHF3S3hmQTVBMGtUQ0M0UHAvdWg0?=
 =?utf-8?B?VWxNMDFoY2hkZC93ckNpUGdNSTUxSXp2cE1rQk9PQUVMa1FpbXJ4MmVXUWE0?=
 =?utf-8?B?Q2NQbzhZVXhkeTg3dWhiYTY1eWZySjIvOXkzaHRicjkxQUI5dEkwNHkyLzFv?=
 =?utf-8?B?TWI0VXRyYjlKNktZbzI2RXhPSGp3ZFlqdWVCUUVXdDdVYWNrRkU5TlNkRmxY?=
 =?utf-8?B?cmFnREgwTCtJYkgzdWN4Q3NXSnptOE5SMUo5bzNic1E5SnRlQVpXMzlnZWZ1?=
 =?utf-8?B?QTcrNnYvamJNYVdwM1dsZTNBdTNZQkdxZDNhdWRIb3NkSGY4bVFHZ1BBdWd3?=
 =?utf-8?B?Wm55RWJYK2dWZWpRM0lLRXhYOHUyMG16aEpwUkdmc3JQQzNXY3dtUkFaWGRs?=
 =?utf-8?B?Yk1iNGpzR1pVc2U5ai9MZGQxTU9lc1hBcnBqZVlseUNSdldXNG1xellpVGp4?=
 =?utf-8?B?WC9Nd0tpUlE2OEtOMmtWZXZlVGRiZ2pYcVJVQ2hPN090RHNaZUozZ1J1Q2VB?=
 =?utf-8?B?MEtnUFArUzJOWjhEUFpVVDR3bHQzNFNQZ3lxZVlwVWpseW8vWFRSc1NpbUV3?=
 =?utf-8?B?Z3BmTU0yNTZaeEdOYk5vTDBLNkRoVXpVSXo2Y3Y0aXd5OVU4OXluSUZ6b2U4?=
 =?utf-8?B?NXphRWwxYU1Ya1FkUmhKeVVCaGFRWXFMUXZvRnpRT2xUYU0zUzZnWUhhaXhS?=
 =?utf-8?B?aDJSckFudkdPZVZXTWE3MlBvMG9zWnRIRk9tb0I3WUpnNjVWSHUzVUhmdld0?=
 =?utf-8?B?cUgzQWwzZlA4QXo5ZCs4NlFXb3RhaHQzdWJwNzBOcDYyYUdVV1NRZ0F1RklP?=
 =?utf-8?B?MVY3dEV0TFNyek5yMDZidVkyZGl3NHJId1NZak92b1hWUElCNVByeGpxRDhh?=
 =?utf-8?B?bkR6cVFrblloLzdwQnlCbjJoSnFFTTJCdkdLeThudFBmaFFNcTVyVEw5VXht?=
 =?utf-8?B?Z0VrUHJtbTROWnhJR1Q2aitmb1RESjBrbUhwMVZYQ2ZRdEFhMTJQVlZXTVdZ?=
 =?utf-8?B?Vzk0TlpqSGQyck1FdFJ6aU9seWlUOWJoMU5tMFRGMys3bWRINXJuQ0hSUVAw?=
 =?utf-8?B?eGk1bmJBNDR5MlcwendIbllQZU9XNW82MEJRVWx0WFlPeERodTV4VnZ3N2RP?=
 =?utf-8?B?OXJNUVpuSldSQjBhVExkc0R1SGpQN3V5R215UUNDWXV5SVZZMDZpT3ZnNUth?=
 =?utf-8?B?U1pWck5aZHhiZlVsc0haRjFpWFBRMnRMWWIrV3k2RFJDMk12VWlrTTdSSjZH?=
 =?utf-8?B?c1ZKRFlmUFYwekV3RzYrTmsrVEFWWlV2M0J4cHhHSENLN25ubk43cG1WZUx1?=
 =?utf-8?B?QzBHa3gzOG12OGw5cUZqRHNYbHB5b0R4K3ZYVlc5WURaMUpEVUJ1LzFodW1L?=
 =?utf-8?B?Wm9NeC96MFVzazFoUzhmUVlHUWg0TWpwR1JUR1FOeG1UUEhiMThyZXFzQUQy?=
 =?utf-8?B?MmdhVVlmRUlZcWlFd2RJdGhUUDZYSTlWQjlseFI5YmIyNnFxbUZIWGMxbGVi?=
 =?utf-8?B?clA2bnhheWhBNDhmaG83MjI5eWdrNW96bkNrZDJiWmI0T25zOXFSSXUwYmJm?=
 =?utf-8?B?emJGenZxVXhLd0tZMHN0Sy92MnFiQ21yZnpJTG9lTHJqa0pKSTVid01GZGNl?=
 =?utf-8?B?a2FYWjlnU2NKaW82Z2FQUUZDSW14UUJvbW9waVVVaURvYnVybUF4Vi9zZ1pu?=
 =?utf-8?B?M293ZmM3M0NBRTVsMC9hNkhmdGtwa3U1bFUwYkdSd0JiUHFkMEwvZjBwakVU?=
 =?utf-8?B?bGtxeUIrK1pYbk9udldZVFpYNXlreWJKM3VmZ1phWlBjeE9IRC9WTnM3Qi9Z?=
 =?utf-8?B?TFYxc0grRnBvV2JvaXJaTzJ3REh4d3RCaXg3dGdPSERjRWJsT2ZSZ2EwbHd6?=
 =?utf-8?B?THc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zut2T7djscgabV9KJWO9rFQi47T5t4iLJR/kSgAJJGd25utfiTHwM8KVov1QXqIIZzuVs79OSwISkX9r3zcGQjFqe7LrBU8FB7BvYmwh/QNoAE7oijXTGpboOek0MD/WnoONNip16XE7sz99MaL+09qgmzokrAhDQhmSvoPWrk43WaPDdG44C413yyAVoGPRAuv4kSjxuNPa5OTMIRklp0aMGSMz6M2g+jtvMZrPFUYlDOz3xM9WZ3qM4BwzFE0YwqkJJqKgZFUcfoMbk9eFn8LqqwqjHYvb0O5597tBgtg7CpjjO+1HVVqeFBZX2SVRJ0YxK5CkUSLBSPeUkE9pl3O30+nyvG7CcUxKDIjcCqZ+YP+9HoGaePw8BWBn0/05z5xcAdBXg4saJwpBgkD0jOWLVlntuKvMyxlTURFruV1jQW6wAkyYgid/Ulh/jl726ipyNqP5bjNQR29Hyp2K1ctrkfrrUG9LXmEdR0roN6oOCF5ervpk3TWot4OWTYoy/Uxp/J+MWVlUkyfso5akFoosbP30W4PR+pg3+uwvCizXFNjSF8zfQlFpIv85RLk9TIQKVArtJGUr89MkamcagQd4fhCz+TsbWeC9RtKuNr4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69fe9bca-2287-40e2-bdcb-08dd92e578d3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 12:47:23.1379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZIpHPJF4QbHWX5odvbJpT8D5sTW0dfqnvWCWtzQcfBdO+jOfJXePNk87A3bA8+OVSVUar5RPK3Y4tlsILhDq3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140112
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDExMiBTYWx0ZWRfX2k92ttyPjNAh xqU3YfdojMRFApm1Phl4e/V3mUefTunJzBDUbR1z5rX+kXR7cYO3jKo2OFLr0EoNwWpnsM7tBAY uwpZ34gJMRZONn0sCy3FQXOnBZ/waDawJawomTD1quVgZB6x/b5cG3QswHTN7finNb9FPHF9sCn
 p4Awu20DMSF4VigaYvd2SXBK6piFs4wrbNV3NpvOIuNghYlMW4K1FcGBsYl6SVYK+oqQzYYNNgD tdOBAlSh6ctQIOqKFEf+wn9j7PO0K+1WDDFYjLej2vMmQ7SeO1GTfc5yGxEHqbrqqIiDRGBNove 1Vaw+sJWT/IXn01TcLctHzy0EGauPajW6d4eGQ87Y13EE1vyOrrHJr7YmR5GuUu4Gquf/nqyxa4
 DZuczeKxBaPbT86WVWJxJrbR6oH3G0RG6jPx4VnZXxuoJvSHbFdQqfi+OjG3O0SvowzQGIrT
X-Proofpoint-ORIG-GUID: zsZHFIAkYyOSPFlhi5vSqWVEu9SF0vrs
X-Proofpoint-GUID: zsZHFIAkYyOSPFlhi5vSqWVEu9SF0vrs
X-Authority-Analysis: v=2.4 cv=P846hjAu c=1 sm=1 tr=0 ts=682490df cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=NLoW8XvR-R0Ze7vP8kEA:9 a=QEXdDO2ut3YA:10

On 14/05/2025 01:29, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Fix a few bugs in the single block atomic writes test, such as requiring
> directio, using page size for the ext4 max bsize, and making sure we check
> the max atomic write size.
> 
> Cc: ritesh.list@gmail.com
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>   common/rc         | 2 +-
>   tests/generic/765 | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 657772e7..bc8dabc5 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2989,7 +2989,7 @@ _require_xfs_io_command()
>   		fi
>   		if [ "$param" == "-A" ]; then
>   			opts+=" -d"
> -			pwrite_opts+="-D -V 1 -b 4k"
> +			pwrite_opts+="-d -V 1 -b 4k"

according to the documentation for -b, 4096 is the default (so I don't 
think that we need to set it explicitly). But is that flag even relevant 
to pwritev2?

And setting -d in pwrite_opts means DIO for the input file, right? I am 
not sure if that is required.

>   		fi
>   		testio=`$XFS_IO_PROG -f $opts -c \
>   		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
> diff --git a/tests/generic/765 b/tests/generic/765
> index 9bab3b8a..8695a306 100755
> --- a/tests/generic/765
> +++ b/tests/generic/765
> @@ -28,7 +28,7 @@ get_supported_bsize()
>           ;;
>       "ext4")
>           min_bsize=1024
> -        max_bsize=4096
> +        max_bsize=$(_get_page_size)

looks ok

>           ;;
>       *)
>           _notrun "$FSTYP does not support atomic writes"
> @@ -73,7 +73,7 @@ test_atomic_writes()
>       # Check that atomic min/max = FS block size
>       test $file_min_write -eq $bsize || \
>           echo "atomic write min $file_min_write, should be fs block size $bsize"
> -    test $file_min_write -eq $bsize || \
> +    test $file_max_write -eq $bsize || \

looks ok

>           echo "atomic write max $file_max_write, should be fs block size $bsize"
>       test $file_max_segments -eq 1 || \
>           echo "atomic write max segments $file_max_segments, should be 1"


Thanks,
John
