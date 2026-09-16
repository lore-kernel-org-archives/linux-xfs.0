Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C324E56F3
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 10:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789554236; cv=fail; b=RMYPpQOU46BFnkI6rEnxm+i47ivEmArw8thqRA38cf0vMuEYrXhlQJmIzJVLaqutlfJ6YvHgwSPCd0tsKxlMQMwTnixIIoMYhyZAqSHOb6aRi/P5wYhFNXReUZvoBx/Wo8RQgN7XAGLoHS32jtj20/pOsZfkhJcTCCFLvIUfITU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789554236; c=relaxed/simple;
	bh=Y3vcWj1A9V/7LI8Z5/HMDCUmkJ4IP4SUmxyXPpZ0XNk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fpFr+jc30p0nRr0Kc+NYM3QuvzTVnv/PemuszKqZmQbKaTftBKbaiLPl0ZBm/E5JubKPOVes5AAKpmG4myj6MN9FyOcHwxySkd0HqD52UfQePMO8WRhCWtgIofhxoQ1njOORLO84IRJ27noIFdtliLTdcFQKAj0khdtkqTJeoBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hX4rdFAC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hi5UHrhG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hX4rdFAC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hi5UHrhG"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68G8kXpH008759;
	Wed, 16 Sep 2026 10:23:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uz3+5mweLwv9XkltsPyXt2bKIFIH2sJDefUE67GvYpc=; b=
	hX4rdFACHoeBksqtfMCsGLwlk84esE1Ov2zR/nNskLd6+YpiHcVt5YF7ygTEED+y
	wZ660iVKD+A1jRQMI4i74As+EGyOSkcQdSUwd+EsL5wfBL+BPE2mRYgnBMAN46E0
	qvucbpc0EiOWYhLoF4rLaPMBS1ahX0OS7YS0IcUcsAs0WpDQL++6ym7wxUd4gVhz
	ZznSVYIn/hLmYKXQ32kYsTLEnZFoJVx7uTCxJcbVuspVS1aPbWNfVkga6FHwytBd
	EoVMo/4yG6Sxdb6VCkI/qtkuEq0foBj+H4S4wfml5rw/Upf1PuwaUXamNOJmIyP3
	UdywsXfOvPVvkJWPhMlpQA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gqqvq846c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 10:23:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68GAK2KA033294;
	Wed, 16 Sep 2026 10:23:29 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010061.outbound.protection.outlook.com [52.101.46.61])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6b6ryb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 10:23:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CmHXg38yWCou04XYyAjz+qwm50X6mdHUqw5FG7EBkdiRWfoGOWjuKHXjRN3ZkRYxrXG8ZvzLVAhxFZyEyF3s2FLPvTETdZNrK2dSL9Rad8FEJqGdTguWlgUKM/WkiD1HNakc+bk45XfFYBa7waCw/JhgKukJfaMSmRcRbBXioAC2rBYSxrmj1wYf3D62976DEchiosDSRqn/cqpNF0sSURkKC7uJlRaFx4KTvGeYaxoc89RNK/IG3NK612Mc0j85+TqHw/yRoclixMX7iDcDMakYJzw86Phiabwm6f9Bq034yMwaqf5NG0307a7x9fnWN+2IiGEOiauknKkWNv3N3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uz3+5mweLwv9XkltsPyXt2bKIFIH2sJDefUE67GvYpc=;
 b=Bbfp7dFOdSr5+fxAH9Iia/Ov+8w3nLk4R5a3K7/cgiYv1y6KHhi4DvTPyFLeK00RMiaCdQaH6lBIcWy9Z1oAV58dseAsj4b4ICuANLuiG/rnYDe4UN+QEmO4WGUL1iz6HbFemFZxWJGl/NxdrdL0sKrePem8df8/hkirZS//mTQfc5AN1mWeSIt2OUvNK9YkOfTWVNPsBYOV0QDLCocAFxU8Ch93j6KZSc10dLrf88o4lr53NtI1SaLLGN4Y1X2M3guQF93NemyzkiVMlmKpVfRzjawvZ56WqleSl91wJ6mu/5WTMWAUfDmU/xOPf5/qpBYOs5azeCAo5OVvRaWHFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uz3+5mweLwv9XkltsPyXt2bKIFIH2sJDefUE67GvYpc=;
 b=Hi5UHrhG0ZVEFT3HH2bc6RAfrPTN3Fp1nqSGuZNuI8gT4/NwAXWKrSM0LCntLRfWCG/MmO+grhpovrdGJD8hBC831lXCuojTFBwpphUEBUh7TSAFMEytcO2XAt2vQv37/YIabW1Cgtgy51SOyrwiqkPGheWnC6ig0RPbYNZmza0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS4PR10MB997668.namprd10.prod.outlook.com (2603:10b6:8:31c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 10:23:20 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%3]) with mapi id 15.21.0428.008; Wed, 16 Sep 2026
 10:23:20 +0000
Message-ID: <9bf23063-e6e5-4595-8ff9-27383c99e5a6@oracle.com>
Date: Wed, 16 Sep 2026 11:23:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang again
To: John Garry <john.garry@linux.dev>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <98190f62-ccc3-49df-934d-f168e293c485@linux.dev> <aqkv-2opTlWD6bzU@shinmob>
 <ed224f94-f605-4be0-8a0a-0b3d481e46ae@linux.dev>
 <20260915145046.GC2705364@frogsfrogsfrogs>
 <db4ab609-af16-4c5d-aa98-c0655625a2df@linux.dev>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <db4ab609-af16-4c5d-aa98-c0655625a2df@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS4PR10MB997668:EE_
X-MS-Office365-Filtering-Correlation-Id: e74a6a78-b105-4fcd-918e-08df13dc8788
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|22082099003|18002099003|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	1Pga9PcwH9IYPkIcAHSRL9Vtl2hofGxfgdRl3OhEm8Q4LfHeKXHKLxKpb2uvuFSSty6iSpsN5WIksGfVMfYX8Xii6OyUxi2ef+TyNdSOJGBBZlVTnGBn8DF4lewCjaY4NX2Sg20O+/fLpWw6FUz5FkwOkeVUAUNXYalX5fX6Xj465sj2DMvNBX6EriZJ1NYtoTp16DHN9bslDuVfl6VPoBGlwBxuTMA6Ym8XnzQaHxvOCu/8yHJyWk9d9PNHrmCUg0M4G21uZlJcEuvOGasDrUiXtQU1XHxXNB219DIzpZeL1aU4v9DYZ5C9sU7I1emOU8H4vfPmvgvpt54nV9wNPFM/ssOPAZ3LEgRR/mUG9hEuGPhV34GBJ13ckEiFPhLWTywZ4I4yfgNSy5cygbdl1wWR0D84LYVxjC289XmJP1wRyZlQ45K883vfgiBAacqzbTUfM4Fcmk9cPcd2YyXGADixR83UFZoQ7XRf/peJhze7ADee1JFsEESwvQKFrcm0hckb/n9zvEXe3K5dksD232mOJPkBtcJ0pmJgdAHCQHT7NkPopE4GxAKz/RUZhgQXjZrzVFWZRQrf5O+USIGi43Z8QstcEOEtaIaEQdRkr7AkduRl9TImjrwczfOCXzTQJBUg3c/DYIVv+CdF783Jli64m6rDCx4p+lStAxqF6ic=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(22082099003)(18002099003)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkMrWEIxSXA5QXdiZmN3a1o0WWdkK2JaQzJSNjVZcFh4TEl2NTcxbGZaZjRB?=
 =?utf-8?B?VUVQZ2l2cVBZU2tpTi9xMUg5bnZGejVVWmJvUmhzQ3BGMEl2YjlUMWx4ek9x?=
 =?utf-8?B?eGVDeENNcnhxTFFSNmtvYW9rbVFocDNQTFc5MzZmU0pibVhLb0VoK1gwN3JZ?=
 =?utf-8?B?MGVFZ0NvalpYb01uV21YWlUrVzR4SzFPbVZXUkR1REcxY0tPU0RIWGg1NzlH?=
 =?utf-8?B?S21kaVJmM0EyZC92MXQ3NDl3aHFKOW1lRndIVGdhb29BKzk0NFdkNkpHVThm?=
 =?utf-8?B?QjVld0VZS2d0R1ZJRXJyNk50R2p4QVNMcHIwR05rcnF0Q3NuREsvTGtQT3pa?=
 =?utf-8?B?Z1FSc3hmbmdSdmxKa0s5WkdDMWtPOWEwbGFNOHFkRUtPTnBnUzdTdEF3YUJN?=
 =?utf-8?B?TWRZQ3hFQUYyaEV5NjFTY3R0RDRjZy9HWC9XU1MwLzhwdkxGZFgrcytCQUZ0?=
 =?utf-8?B?dWZLZzZRVjY2VEh4Nmo5ZGJDUFhhUnQ5SlJja3dFc2phQ2VZdy9WSEduSkVZ?=
 =?utf-8?B?a2QvWWltM0NBbzNhNG5hc0RoSmIrVHgxelRWTmFwOW81T2FMdU15QTB4Ynho?=
 =?utf-8?B?TFdTYm04dW9xRkVyblB3Z1MweWhNQk9NamF2UThUeUg0MXdZNmMyV3JrZVBm?=
 =?utf-8?B?TWN1R2o5cHJqa3padllieWlUVmlWbkFxQUxpeVU3VUM3TWNKRmRaMytmWSs1?=
 =?utf-8?B?OG5hY0FMTkkwU0tXOGErVjhIK1lidUtycjRkSzFGMXRQdUcyTnNOK0N5MEp6?=
 =?utf-8?B?MGVwQ3NXVFBlZkFKb0xDMjMzbEw1U2FmSHBxRHZVRmd4YmFkQ0tKWnBiY2dU?=
 =?utf-8?B?WnBrM05jSE1DdkIyU1dDMlg1L2pmM1h4VS9vczBBK0JuYXBHbHdIOU1qNHF2?=
 =?utf-8?B?ZTNKdVFLNlVLZlJiTWdDOUp4cEt3dVJBNDdCa0FqUUc0UTl5T3lYZm40UXlX?=
 =?utf-8?B?RWJsczB6NzIzRzM4aFovNUJLQzBCb2J1Um1nUUJQbW9qci9UOGMrWFN6RGxt?=
 =?utf-8?B?MFFFaXBTb3VjWHNPOXdkMDhZR0hzbmo4MzdjbGRZMWkzK0dGaUlObU5XVXNm?=
 =?utf-8?B?My9IdGRQZmxzcVdYbmdTZDVDbCtENUNZU3BubDhTUW44aTZ3NERWV0RiK2VK?=
 =?utf-8?B?bC9IbTljZFpCM2kybnRjdUQ2bGpRSWFXa3prTkU1N1ByRm9RdUdhTU0rSHZ4?=
 =?utf-8?B?N0htcUVtYTVkd3luLzl6aU11TTZQb0dmVWxrLzRwREQweGNzOGpWckNlTjZa?=
 =?utf-8?B?a002L3dVQkdWT214aEV0RnZ4SHZQMUwvc2FDSnRKd3JZWGh5WGhtY2huS2Vz?=
 =?utf-8?B?NVp2UHd5V1BqVG8zSCtpNWYxMXlZak0wTzN4M3JWbXRXTDRXY1ZueE1jMWlu?=
 =?utf-8?B?Z2NzLzVtU09ZWVdDeVZWTGY2ZGR3b0VsRGVXUnU3cUc2eWxuVkZCMm9wM1Z4?=
 =?utf-8?B?VWhJRGl3Wm9wRUVTczgrT05NYy9LbTRZVGVaQWcweDNiT0w4a1ZNZVV2b3U2?=
 =?utf-8?B?a0FReFBwRURpTkl1ODljVDJWc1NuWXpnbWN3TlRzNENlMEVla2xXZ0lkc3pz?=
 =?utf-8?B?b3RVOWlnZUxxSk5IMUd6OUV2dS9PVHo4YTMzdHJUVUZjS2lGQzdkSVB4dDZB?=
 =?utf-8?B?dFdRL0VhR2ZBcjZwTmFvQ2ZjL20rbDdqTkpRZVdsR0Z5dDU1SVorbmxReWpk?=
 =?utf-8?B?UkVla3BYVVdtcUFHOHp0NXlmYkFjbThNT1k5VFRmU0FhQnRoU2UyQ3M4N09R?=
 =?utf-8?B?R2pvZGN3b1JQUW9McHBJQ21vWlQxVS9hc0poUGpaNk5yckJOdFNVMlA1U0U2?=
 =?utf-8?B?MXorcllGbW5jOXlTTW1FMUJvaHdBSWNXUWpFK1kyQ0x0UURuS3lxWFZyN0gy?=
 =?utf-8?B?ZFBHbTJDY1BwM3VvM1FrTnQzTExVNllJVGRzUkNYRWxkTmkya2pacmxRRVJx?=
 =?utf-8?B?MVpoWDBOMDNwTXU4SEZLKzl3NXpCTmcvNm9yQ3BQbHgrR2llemJZV2o5ckxZ?=
 =?utf-8?B?UmZWL3FjeWMySVNWd3Q2UHBYTFJlSWIxYW8wbjJMTDFPd2JkRGZhaThKMkk1?=
 =?utf-8?B?QVM4TnB6NG93WnBES0JSeTAwU211SmNwRDV0QTg1MkFoYnhQL3U3THVQdDRr?=
 =?utf-8?B?L3Y0bC9jVzQ3MlFYbHhhRlJ4U0xSejBGV2RiZzNvNTR3amp5NnkyQlFXNXBO?=
 =?utf-8?B?Q3hNL0crYlhkV095d20wcUhPVFpZcU81T21nMEdlNVZSSEx1MmR2QVNyd0RQ?=
 =?utf-8?B?RW15c3VuZi9jU3UzcTRXdWFRS21QSjhlQzJ5b2tDS0pJK1g0U3NxdmVnektM?=
 =?utf-8?B?Q0pTNmRHWnRJdStDZjkwWGVYa1dPaTNjV1dIcG1TbkhDRFczYUVJZz09?=
X-Exchange-RoutingPolicyChecked:
	hSpf3mUr6LnH5fxuwVe75FOlI7KVe0JFTpZuROA6kSdMAbBEeK+c+6UCS9bT8axJRaTru3maU8JCQHbsgLX5ZdttmZowsPAhYyJgr8kiJDfVBFLhCMUv/EcS92aTnJ9ECqyGOgkwT8w+JmHlM2QGv7isw+dlw7ZKSRZHM2IxQrjZ/rUljxTe3csON4d4i611zvqhc5H56FweRiZYWcPseBGvjG68HtEgev5pZDoRb5ZNRxpwUEAtosI7T2vMJVZ9s4z+kji8S9odHA2OXDv6jCD2/RdPjLwpXdwWKuXwkEZgneDtJVaPZdp+p2poqeEeNaQOeefCtK+L9pSgRnXPuQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	96rU3GEi6wV9dJd5Amfn/eq8MQvKeNm5wN4Jls4PXB/Pz+FPFfJS7n0BH8L/SD7Dim4sjMhrV3j+XewelZ1QjSTkPexclhkPORQc4UriGZ88w0dDD/zg5iHsSiV0SgOzBtKxCijzReiFXAgoj7aM0Ekz5f6LYaPzA/p3EF5Qf72lH28UDyZSYUAN4mg3su8A181RiruP+E29IUNtXL2AqQQF6gmmkASVCAeHFxsinFewYMpGvgm3eeWxWEke7l3purzWgIO6y6POiQkyMQgK9DRMWdSP40ZUV7Ap44IlWOkToTn28hOvQAVXFFk5D1wAyk8vzIYwSjOuQzRAwLmu/ropMBxboZxKYVtZZAg/6fiaf9S9ftBz65Y7icoTAId2Rt8kVfgeLZKLDs500Idb7NYpYPKh+PZk+rrIkQltfzTQ1qlQX6ujuzlv73xGRfZ4mpdfRVFtQyH2whHRSVSsSrx28kgfroXTBYZTGWuYO3qi8T4g2wAEuFY0/4Y4ln+rtj91kX6rk/+PxUk5YRiYBNvxNUyq/s5B5gZ/J5SA+bWsYDqKojhFtUI3Nx2grTsgkk4GemfTHWGDu6Y/mSXQ0dwAKISxDfdp14OmsfACvE0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e74a6a78-b105-4fcd-918e-08df13dc8788
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 10:23:20.1180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxL86dzc2ce9ze1JhVMBsuP5qjZOBGA33y9noHEQ2ggPFTZ0ABiZUt9vDqFz23pLJEddn6/iHogCPWwvqG7Inw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997668
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609160135
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEzNiBTYWx0ZWRfX9kcqezjtrfBd
 a3Hr6tDKYLx79EVZLbGRHhdq8/R4N0ZXfGciyUQw9MfF2cCBCSSPkCIJZGf0LDRNL7/H4JVbPtW
 yt6YVOqKbMTvBalAIt4+Ep9fGCfR8+GBlqcI6PtdPunryTv5YbYc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEzNiBTYWx0ZWRfX8f272zwa6vyO
 QSmqvEkS2vYYnxe5ZSoqmnZ6ewP3i0ytoRGKAkksIFgbAOxh7n9vEwpnA7xLSHvqtRmxVdPMK1x
 v9WgDq/p0zkXCzz5/FvqnPn45OfxEqKD9oMX5/TUevYN7sgriR4qYbyAuv1l8Dy0fHhD/FbUvYi
 nHtUcRX9dFmfKMLiX3WUaRJDMpQOZpHjI5H4l6boSkh+DiAgS6JaoOJMFPXgwLyA3ghW4srlTMm
 tGplJE7NX9TYw9zNE2PnC502kUfPiNfAheHYZEll3RpnxTfosk+MEgWF1rmbQN0CipjaW3KC7vi
 IA8/SgzXxP43oZVpk7m8cz8ILt6UIy7pzOlUX7LBao0TIng9hOG6+lj0qhLeQsJ6YuqPKR5lfFe
 FHw7m9Hr7HvTbRFJ/9H7SxY8FFWcMRPXz6z/UnDPerO93O2D+nx6OhhojW3oA7jlU0j+Ouv/XNv
 So/Zcg2Zrl9Xa0nvXbA==
X-Authority-Analysis: v=2.4 cv=MpXHeGae c=1 sm=1 tr=0 ts=6aaa6e21 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=OjLK0GR4bVAbPWXkH6gA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3FZL_SGb7jwee9EduDyByF24a5Excan7
X-Proofpoint-ORIG-GUID: 3FZL_SGb7jwee9EduDyByF24a5Excan7

On 15/09/2026 16:41, John Garry wrote:
> On 9/15/26 15:50, Darrick J. Wong wrote:
>>> thanks
>>>
>>> About the kernel code, I am wondering if using IOMAP_DIO_FORCE_WAIT for
>>> CoW-based atomics could help avoid this issue as we seem to be bogged 
>>> down
>>> in lock contention.
>> Which lock is being contended, anyway?  It looks like the ILOCK?
> 
> Yeah, I think so Re. ilock. I had some perf data illustrating this from 
> last year, which I can't seem to find, so I will re-generate it.

Here is perf call graph snippet when running fio with 72x threads 
issuing 4KB atomic writes on 1MB file:

--50.46%--xfs_file_dio_write_atomic
|
|--37.19%--iomap_dio_rw
|          |
|      --37.14%--__iomap_dio_rw
|           |
|       --36.50%--iomap_iter
|            |
|             --36.49%--xfs_atomic_write_cow_iomap_next
|                  |
|                  |--27.34%--xfs_ilock
|                  |          |
|                  |      --27.34%--down_write
|                  |           |
|                  |       --27.28%--rwsem_down_write_slowpath
|                  |            |
|                  |            |--24.65%--osq_lock
|                  |            |
|                  |             --2.35%--rwsem_spin_on_owner
|                  |
|                  |--7.62%--xfs_trans_alloc_inode
|                  |          |
|                  |      --7.59%--xfs_ilock


Notice how much time we spend getting that ilock.

We could try something like this:

----8<------

[PATCH] xfs: serialize CoW-based atomic writes

We have had reports of system hangs when testing Cow-based atomic writes
for large block sizes.

Analysis has shown large contention on the the per-inode ilock,
superficially in creating the mapping in
xfs_atomic_write_cow_iomap_begin().

Serialize atomic writes to reduce this contention. In some cases this 
may reduce performance, but high performance has not been a requirement 
so far for CoW-based atomic writes.

Signed-off-by: John Garry <john.garry@linux.dev>

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d8202da15aca..ff48757cf0f0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -819,10 +819,12 @@ xfs_file_dio_write_atomic(
  	 * HW offload should be faster, so try that first if it is already
  	 * known that the write length is not too large.
  	 */
-	if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
+	if (ocount > xfs_inode_buftarg(ip)->bt_awu_max) {
  		dops = &xfs_atomic_write_cow_iomap_ops;
-	else
+		dio_flags |= IOMAP_DIO_FORCE_WAIT;
+	} else {
  		dops = &xfs_direct_write_iomap_ops;
+	}

  retry:
  	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
@@ -840,6 +842,8 @@ xfs_file_dio_write_atomic(
  	}

  	trace_xfs_file_direct_write(iocb, from);
+	if (dio_flags & IOMAP_DIO_FORCE_WAIT)
+		inode_dio_wait(VFS_I(ip));
  	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
  		dio_flags |= IOMAP_DIO_BOUNCE;
  	ret = iomap_dio_rw(iocb, from, dops, &xfs_dio_write_ops, dio_flags,
@@ -853,6 +857,7 @@ xfs_file_dio_write_atomic(
  	 */
  	if (ret == -ENOPROTOOPT && dops == &xfs_direct_write_iomap_ops) {
  		xfs_iunlock(ip, iolock);
+		dio_flags |= IOMAP_DIO_FORCE_WAIT;
  		dops = &xfs_atomic_write_cow_iomap_ops;
  		goto retry;
  	}

---->8------

This is far from ideal, but I think that it should stops the hangs - 
having the kernel hang is intolerable.

I also notice that in xfs_atomic_write_cow_iomap_next() we drop the 
ilock for calling xfs_trans_alloc_inode() (which immediately grabs the 
same lock). It would seem that could be improved.


