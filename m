Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0CD4AE110
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443768; cv=fail; b=b60IySKw8rkGXZ5a/ysPGZe/ksOx4GnPLsRUCQjLwgN3Q9vGsKQJ1MWpFGThi1e0tUDDvFeszECiCxhe3xQsEKpPIwqjxc6JhB+GfUfWHniwbK1O7bkkcHfW2zWuwCeCgSuycvA7bbOHJVzvgU1ayX0pqPmDgfx4adevf4SEYYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443768; c=relaxed/simple;
	bh=R7sALnjA1qydKK8ONy+WKQLHfHKcf1sWrC61mFJG90I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d2+R/sC2Qh83zQ5y3xY9S1ppPVyVqV/964sVABBVqVTx2Wi4hk7MAsRwHxqeHSS+d4+fEoFA3XUK1bp5aEv//8wxhxq5v6FbjXAsw9dWP2mpEZOCpLfJSTPd53JkV2GlzDgG/BaBAZHJMYCwsjls92XaUrPnVAFjVqk+a7hLy/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eytRvoea; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P/bGjxte; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eytRvoea";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P/bGjxte"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683B4SDL738933;
	Thu, 3 Sep 2026 13:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/zM8FZF3xfBZmW3Zoxk9B3ytKlN0xIAsqjMyf33AfCE=; b=
	eytRvoeaFMakIky7YbqKSu+umrMW5PgfegiWRMjHcbhcell1PNZc8zMJq90qu7ZT
	u5Csfhe0NJZUnvKMpjrVta6VKelGd+2XkKFQEopLDEwWolPd9wO0vKXQa1MDq6xy
	h+NUTW2+YKTXTOeFzz68W+zD+tBcjLKGSX7xHBbB9zaYRBXuskypFN0VAcXkeY8Q
	uWdHeQcIwYtFHtrAYUKtRuH56BLySsmEUubUpWesMZfjHf3vKkK/NzQt7YRhgbTi
	3EZ9GOgrxgt0m9QBi/S++ogFPgLPjj6LpjZyY+3aI0AHM6+hoKs/QFqJLxndhR0z
	mwXFmLpIePkaoG7ZBtnooA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbb13fm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Sep 2026 13:55:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 683DtTDg024367;
	Thu, 3 Sep 2026 13:55:42 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011005.outbound.protection.outlook.com [40.107.208.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gdymvw6d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 03 Sep 2026 13:55:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPNsltnL5tKGxRnmE7Py1hGegihjzxsg0+cOHAc1eoBW7MC2Dbvmqf/5tDmbhEy28v7f/n605OYQ8XKJ9y9Opd5H8QTAvrR+1EsKXC2TlybQCqrOmscEvMeEMJ9xITwtAnEmmWKrbP88CjVdbUyZh2WbMlUW3eiEprOFXulNQ3SMS7E4mTvid/2+z2VFzoXa3grPA5TYvTgk0jqF9M6lj8gFppEmx5ojtRVQT6y2T4lNhsUeLu0G3OhYRe4SDo6FJaNqnWSCsSNgTSSJAjKMN5vD5nfaZN4OkFGG8MpR0UQj8tHdmKKjv99CvsrXy5/TrVOtt3t3ydSY05yv87UlKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zM8FZF3xfBZmW3Zoxk9B3ytKlN0xIAsqjMyf33AfCE=;
 b=vc6zEAyLkBIeNGzIljWogkz5GJFfn6JkZ82b96QxECRPOJhwsydvAvxvDs9gHbsz/unDSJlkzewASX8Tb7of780QKVdxKmyE97XAFRBTWnpFa7aYwFwPOP+qtZRzLodUu12JsALRi0rii9K5RHYpyw0jNFfSFyLUXqz3gCP7ijAqBL5mYBrUrvxdnUXAEEvIohuoPoAHdbv1DEBzA7CymfZ5uiVhPvauh9uLwHE0mBSWNrVkbXLoOgKrri89wDQF3zxJHXWxPFaHKQZ07TQaUniDLltr9+Fm3ns9Iks8q8XmtmKO6DqD2nMkn+btGvdIWTG4XTdSY1M1XwzOxD20gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zM8FZF3xfBZmW3Zoxk9B3ytKlN0xIAsqjMyf33AfCE=;
 b=P/bGjxteO0OQlPXf4UUxSHm4zrd7X94rNSAtTrBZIl35dIdRIqWaIrJOZXsIK2j/Wjp7AlaK9iKUgWqQBJl5pgnB4K9RZhT+l3rxwxRMGjJLFIbB5FJn0HPaHdfsUw1Z3oLbaXAV+zR6n80s5GAGsV35+vEPP3qSKEYE+jr9qp0=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by CH3PR10MB6883.namprd10.prod.outlook.com (2603:10b6:610:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 13:55:14 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 13:55:13 +0000
Message-ID: <779c0474-f057-45cd-a81b-1df34ac5dcae@oracle.com>
Date: Thu, 3 Sep 2026 08:55:11 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 01/38] xfs: fix dirty transaction
 cancellation in xfs_bmapi_convert_one_delalloc
To: Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org
References: <20260819001442.1451892-1-dgc@kernel.org>
 <20260819001442.1451892-2-dgc@kernel.org>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20260819001442.1451892-2-dgc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0403.namprd03.prod.outlook.com
 (2603:10b6:610:11b::13) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|CH3PR10MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 72e87eea-a434-4af3-2d3c-08df09c2fa2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|6133799003|4143699003|10067099003|5023799004|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	RMvVgLuoGs2YsDwj8JixURsdSf0Y2SwZ+i3fwkbSFzBJtq2thXQKhh+dBw/QtmGMiIwKSzYg5fUO//0xDqmFEvjXynLXeqpEgOzVuMFjdljAaIfMQlATYr3OZ6lJ+rLDWmci596CoYBizzQqZ1/SaVWYfGOGi4wVEA2DmjBJVV7KEkaerWUlNVy6rLT6Zz56NLaVj34ivcs7df9nHjSZbJBCN5XzDPm3pUCBG3JYYKINHDc1Z/zVIXNhnJVV9PI4Ae5P6nCQKOXy2SNOAA/pCQ8w0k0C6dlhZDOaM8KeUQ825WppVqI5w7S1Lfbl/4o+eVh/xpmgMqs9uCP9/esdRZe0aJnSbeemZzBo1Cr/52/Wgzp9WyiIxcQPss3NLAej7WQfqUmhcfmIhDKyBc/OxoFRgIbP9x1njdmY1AChGjXUJckEtUiW4lrsJ9v5nTTFqke/M5ht54VJOVyXxjNZzndX+HT15rlKk8gGFzL23Y8FzUTWKBKR4coFYxmY3uHroA7J0trrZpBVh/Q8NIWbCGt0txtrXLDbIYwTlgCPqwh5r3ehCmC7FxBKD7SjQ45LcybiKiUChvdSQljdrraGttJFLOZFEaqf224RDWBgxwL+p6bkDH1YnV8zL3Uv1Zpm2eH3CTDBfcWu11J/hEQ2lg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(6133799003)(4143699003)(10067099003)(5023799004)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmhpZ1dXa2VXSEFOcWUyYmJCVllvVlZsQXJ2UU5zMjNlcEFFY1dxNDVsT0Nw?=
 =?utf-8?B?YkU2QVdNODhabjJod0V6bFN3MTV0TXd2Yy9zYVMvN2pkbzNzMnlKdVFUd0ZC?=
 =?utf-8?B?MHp3Ym5YUEk4NU4yR2RvY0xWbVlkRDFCaGxjZnUrSkJ5QzcrZ3dWUXg4ZmNU?=
 =?utf-8?B?emttVStlN3VEdHZBUlVtVWdKbGQrWGVCRHlSOWJlT0d5VDloYzRmNzVsbFM4?=
 =?utf-8?B?UE1sTW5lQ2pWZllsLzF0US9EMHl1NGhtSTVHVXBXVW1xTUhWaVo1WC9vc2My?=
 =?utf-8?B?ZEdXMkdXUlhBMmk0aGJ6NHNwb05pNUZldzdLWFJZL2JNdzN3NUtCaDFzajUw?=
 =?utf-8?B?WnViUXBjRDRoY3pwL2NNYVZYSm9lWEVibDNubldPcDJiY3VlN0M3K1ZlRGpt?=
 =?utf-8?B?WW1OTVIzUTFNNUxvK2E2dnpwYVZaNC9KWkNldmVwZnFDWkdkQVhBU2tWZmx6?=
 =?utf-8?B?VW9jS2c4TjNQUGNwNVhVQ0NyQm1KOW9qTXRHaFRVSUs0bnc5dXA5ZFJGUDFH?=
 =?utf-8?B?T1FWSTQxL1ZKYW4xL2RaekJycnpKdkhuTUx4b1o5YWJIZ1FBdHFObDNxRmJF?=
 =?utf-8?B?bUczUmJMcjY2OEUrbGpmUjh1WjdqT2dFS2F6UTdFQ1FXQkFrNHFyLzM3MWJG?=
 =?utf-8?B?TEVaY01qWnN6ZEg3dFlveG5QVUg4aG1mMHhSZ3RFZlhPandkcDFQVmRJaFhy?=
 =?utf-8?B?eFEwMXFzcmcrZlV2RXVjamJJMnh2OXJQcHZSSFdybkY1WVZybkoyQkpsMytr?=
 =?utf-8?B?R2JWUDVxLzB3dnJ6bzV6RG5Qa2hiSWRyemVoMmtjSUlJRFFaTDM0OTlFUkRD?=
 =?utf-8?B?ckhTalduRWxkV1ZvUmd1YnFXaUFaQ2tMbThab0pYenNmbVpabFFDb0tWQjgz?=
 =?utf-8?B?dDladWRFa1BlUVNCdExTamowUldUaUI1Ti9qTUdHQ0dENDJEbzJUUUJXK1hh?=
 =?utf-8?B?emdKNjR4dW5URENpTzNlUngyRitNU0xZa3lUbDBzK2NzTDZwaDU3eGx3WC81?=
 =?utf-8?B?ZW1tQ2tDenVwNXhIQURZSWlyb2NMTERGM0xiNE95aXh5NVAvbUgzUkE4V0lq?=
 =?utf-8?B?YjZRUmxCM3hWaHptK1Jid1NUUkMrb1BJSXA2U0ZHWmVENmRtWW1WMlVFYUdI?=
 =?utf-8?B?Rk9rSnV1RHhJMHFDaHZrSFlzd0FvT3Z6d3N4WFhXMWVobjFLTHI1dU0vc3Vk?=
 =?utf-8?B?aDlVTGxvWm9XaDQyVDNmbmVkczRjZ1dOajVIRE01dy93Umcyc3VFTFVUcFhQ?=
 =?utf-8?B?RVRSMzBpRjk3ZEdMcmo1d04zNDIvNExwYkhNdlZkVVhiT2hMbUlxVUpJS1E2?=
 =?utf-8?B?RGI5TlNzNFZuMHZRaVoyVHBXelk2TjkzZW1lNHRYNEhGc0U3T3VJU0p1akxP?=
 =?utf-8?B?TUNJcGJOREorblVjcXljWUZ4RHJQamtObE1iQ3YySTFJTURYYW5EZitpODJ6?=
 =?utf-8?B?T2VxRWFyRTJGL0J1TFdhL1pSL1pwZkc4ZjdJMFQ0MlVUbENuSTJvL0JUVnFk?=
 =?utf-8?B?ckRZVHNuaVhYS1ZjdXZJdkczeXl0ekIvWmRZNHVpZ0xKREtWSXgvdFdDWHBZ?=
 =?utf-8?B?S01RYk9ZeVlQRUJEdGVEQ0t0aFp6Z1c4R3VNK0ZTNUdXMlpSMUhya05EM0F2?=
 =?utf-8?B?N0hHQitaWnM1em5BdTFCUGtXVlhrekhPVEtuZmo3aWl6ZzBaSEtZcUxOMjRi?=
 =?utf-8?B?SDB0Yy83aGJFM2RMVFNkNGp5Umh1WVhvQmNOZ2JMSjdEZS93VnBtNlhzT2ww?=
 =?utf-8?B?SHJBaWNyYlBqQVp4Z1ZLandqd1g1RXUzTllQMmQvOWVGcjV2RlBXalV0UnM0?=
 =?utf-8?B?b2ltZEp3bDhhVkdJcXNyT0QwaE0rTzZkOE5SZmJxdm8xM1FDZGFMdkJCb0gv?=
 =?utf-8?B?bjlBUGZ2azZNa0ZjcW9SSkVsVXk5MEpkNmQ3czJJVjNkSWhRTlNPSmdUMC9k?=
 =?utf-8?B?K0tkcitoSmVBTCtlazVFTFRERTVwNXJXd2I5Rml3M1RLSnBuaGRJUkRVc1BO?=
 =?utf-8?B?VGpKVFo2TWZ5RHp1T3k0SitJRkFidVdJOVZINjBrTEpROFJiVmxWM291L2dy?=
 =?utf-8?B?OTZ3TGJVS2hZdVl4YnJqTGhrc0dIYmdqTERMT1pyMGdEQ21ZQURVcHZmY2xY?=
 =?utf-8?B?SDFkSkpIS0ljZmlOY3dkK2lKbWtoWGZPamU1azMyWVpNaDVQY0dlUVdxRjRF?=
 =?utf-8?B?aVk2ck01bFZnQjFIZVI0T25JbGdyakh3N29obHFwWVBQdTNEQm5ZSEZRMDBK?=
 =?utf-8?B?a01xMUdlYXlFRzlDSkZ5MHRGbXUvVWk4akVydEpTVkEwN0JTQ3VObzEwU3lu?=
 =?utf-8?B?Qk0wVVNLcGxCOTBMQ0xMMEFHTW85YitjRlJtV3VPdGtmTGszdUx1bkdUUnRK?=
 =?utf-8?Q?pykz1RHFvyfvZ9gg=3D?=
X-Exchange-RoutingPolicyChecked:
	4PGPr+ZevW7l0ahLK0qUeC+4cspli4t/4sRBYmHMRKsP+qUhnh4IRGVClD7AaNmroHgeOG1AXrqmrmgPI1UjISjne3Ic3Z7G+nRAMdlPKy+giqm7sPpx4IEkkZVpdX7aGbIC8jBY39MPISGIBrhePmntDhPpkMjp/oyIN6xe5ZN6QvpmAHMieHGgjL++MzfkVnmMAbRmtE0Qtp2knwhjU8qi6DBKT4FAsZ2tNxo1uJBDAt6C4WKg9gwbv9EQ6WS34zQcpBTw+Zwt3VGQouofsNrLXkHZT+BtjQ/Ocr+Gf+2Zzrf6O4HEjXRYv+2tRAdbxOQZpW13/pvErmbLpnWUVQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WNJ/RK6WGqzy/FjJltIp6fe/a/+R55miRz6PGOXwmvVFtw868nwf37wqws9olD2jBq+pHYCTh9tTzouIDwfPj/m0pDGrOBPCFYWoK5haqNVBeo4AQtfhhlZbeejyxPCn6k8QwzwqOpcybnMgscAkHee29fRbpfcCuUQKAG4RHUNz2QeAPQuI0hXolUv73l4vu1rjujbgy+5Ch0AKsj3IWHalIsLNEqcoezIL87vJpAd0Nemm5yDn+OUKz0sU6btn/w11A7j0qDJwustB5rL+FHilflTacb55wN7s4Gbvn8JmLpOViBfW3AS8WK+3vGeoFUp4cObEQI2tir1mf5tDddgDneie7TEL52aC0EYYV1olzZcpHTTE2YAIZ0GaI1ljn6PrruRe9GlZNhVDQAD649XOwY4ruvXC4s/l/DOETfF+rDd5ZA1BjKeQcvSBHhCGs86giPuxS3JexcOtfn/xq+ZqawYO/P3azXKMFytTV7aHJCOJB4FchPKxMBiGKMBRg9yRqjrBDmZVRkD2QkFbq67aeW+uqPul+bBNXcJU29PUzyXPjg6rGNXJ6IStHgaIH/eTeVkf7cHMYxTFC2j7XTjmwpFs058hSyJ+swPbQ6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e87eea-a434-4af3-2d3c-08df09c2fa2b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 13:55:13.6561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nIJr/J2kOYv+BQZsCJigdt3bcVZYembHtvcwx8XvwiNS9/H77woUeRS5n1HbCK8mz2SBC79dB68nqAWZa9xRZg1XI6nyxiSghdYekLKCiE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_04,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609030121
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDEyMCBTYWx0ZWRfX0zXgkFcLLmDT
 Gkej8uQ69/ZbxBRV5B5lVXmdZDk0S7jYe/vfxvSSSDMC0kwryIGEQ8fjLBLyWgi42nqtj+5KUx2
 MWVwIDN1QsoztXN3OciKQ0WU7OapBIzHv3awNEAKKBUiw1GaLDPp
X-Proofpoint-ORIG-GUID: 2QaHsQXLSSyFjhSOLWPFz-Cj1N4Sm-5b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDEyMCBTYWx0ZWRfXwNjNWtO56M5K
 V3zIziaYpmbgSAGwAfnY99qy/ZLQWl+wrUfiIdUejeUew+8Y8SZwlyHYDsyrqoKWsTtoVTA4GZH
 0kNezYv6GcoRb17MgnIzAyz2fD5sOiyhiyyA+Ygtpn3Y9NTdixUJjh8EiS7e8pUvKlCq91ovkfw
 GLcI1QRRysm9xqb8DMf7nvTiZcwtVFbEypN6zICZu0wslw81djDTreF+JrIjT0yoxC6tnvrBvDk
 Ihr6K5fxNl3g2QsbQGDkMg3uIkdQIbz4xY01BUKjk5kyVxewMd2bouFubnsO8Bkp5pt8GH77S1M
 1PyIXjjrlNUrMZzUyhypgwrO6N2Y4yEHZkJs850whz4jkJlMtqfpWO4GlNOpHXn94QobKS6zm1a
 ygeUROqmSU9GnxFPWdKqOGYqLPKMInfPqQJrG/QtEP7CgdAkvG02i8sb9IZNJoGNoOl9xktPfgZ
 WTtm7LrJQdNKo9/Z5GkSyceF5pY5VgTH8JFE3uSc=
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a997c5f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=QmMeSVLTuxHYD_6Kc3cA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: 2QaHsQXLSSyFjhSOLWPFz-Cj1N4Sm-5b

On 8/18/26 7:12 PM, Dave Chinner wrote:
> xfs_bmapi_convert_one_delalloc() calls xfs_iext_count_extend() before
> checking whether there is actually a delalloc extent to convert. If
> xfs_iext_count_extend() modifies the inode's extent count fields it
> will dirty the transaction. If the subsequent extent lookup finds
> nothing to convert (e.g. a racing COW completion moved the extent to
> the data fork), the function returns -EAGAIN and the caller cancels
> the transaction. Cancelling a dirty transaction triggers a filesystem
> shutdown.
> 
> Fix this by moving the extent lookup and validation ahead of the
> xfs_iext_count_extend() call. This ensures that if there is no extent
> to convert, or the extent has already been converted by a racing
> thread, the function returns before the transaction is dirtied and
> can be safely cancelled.
> 
> Fixes: 4f86bb4b66c9 ("xfs: Conditionally upgrade existing inodes to use large extent counters")
> Assisted-by: LLM
> Signed-off-by: Dave Chinner <dgc@kernel.org>

Cc: stable@vger.kernel.org # v5.18+ ?

Looks good

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_bmap.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d64defeda645..47c4d5c52b95 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4380,11 +4380,11 @@ xfs_bmapi_convert_one_delalloc(
>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
>   	xfs_trans_ijoin(tp, ip, 0);
>   
> -	error = xfs_iext_count_extend(tp, ip, whichfork,
> -			XFS_IEXT_ADD_NOSPLIT_CNT);
> -	if (error)
> -		goto out_trans_cancel;
> -
> +	/*
> +	 * Look up the extent before extending the extent count so that we
> +	 * don't dirty the transaction if there is nothing to convert. A
> +	 * dirty transaction cancellation on -EAGAIN would shutdown the fs.
> +	 */
>   	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
>   	    bma.got.br_startoff > offset_fsb) {
>   		/*
> @@ -4409,6 +4409,11 @@ xfs_bmapi_convert_one_delalloc(
>   		goto out_trans_cancel;
>   	}
>   
> +	error = xfs_iext_count_extend(tp, ip, whichfork,
> +			XFS_IEXT_ADD_NOSPLIT_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>   	bma.tp = tp;
>   	bma.ip = ip;
>   	bma.wasdel = true;


looks
