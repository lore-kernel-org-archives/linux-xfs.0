Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5944B1492
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443824; cv=fail; b=Mg6dwip9IavCHQHchl8+WRnsdS6x7/WD6U6pV+sPlAyPx3k6gLMc1bAQKjU0om5IyPvvqbiBPHCMO+ZyraoUsDV20i9f9mfy43AAJan08x5chIzRhLaMykPP+TStgITF7JlWc6xOa3HdKBVU83C4mdMzJhSWm31KqrFd9TCiD8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443824; c=relaxed/simple;
	bh=vpFCR6wTvSYyCT25aeo2Y6rLzfevGkmyT7gMDjs3faQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YxRQRM7F8XRgshEVxFpPZNo94S4poOs0qw0K58CHxF2Zebs5+SC2O6q8ScSrOZwf4rOY6bM0cJGlt56ed8HNVeFuVohmSHvpaDyR99lJhpiAoLH5MdDDHmG0wJmKDuxdnfxaPpRNopKEVfKFw8sN2NqfabpYzliabayfOOf5P+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rlhMj0uq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ITzIsyTU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rlhMj0uq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ITzIsyTU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683DrAWA473471;
	Thu, 3 Sep 2026 13:56:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ptvCILPBlIIoTnBtu/y2zjdvoHaDw3vf+tkMVqmac60=; b=
	rlhMj0uqCyn7LMtQ1vI6Fr2ff0swIuLWf1wegpmAw4kkL7xvbbY6RMZ+kjw6YkoO
	L7tEv+QpLiJ+0P185zkDHiqgCyqFzMRlODHI/V7NLjslebi9JhgAq36AtPINWUL8
	JaXdI5X3N3epslLxKTXkdG5rI0MZwC3zV6JdW4O8VnWHQQ269YixpaIR1kJeCnEP
	RynyN6RwczOcbJoO5oq/PysGF7KC0kDdFCfPtuuHqwduZ6c0O012tl63nToHt3mJ
	7ocgz49PHpa3u9Sw54VUuXvsckaoRLYyeJfMZ36JurY9Q0JfoxfBwweCPM2Ye8m5
	qs4lxySco6GdTG4/+x5r/w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp72h0p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Sep 2026 13:56:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 683DtGkS000618;
	Thu, 3 Sep 2026 13:56:36 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012036.outbound.protection.outlook.com [52.101.53.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvh4xbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 03 Sep 2026 13:56:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lekgR15VSZlh3ZkJHB/k2iOrXFb8HZGtBSr4c14NW+mEDGTSVxpf6aMvLs2+WRCbWRiExqyRKZVHYqoslLUj4wmRM7AELu/EJVLem7omcWjAmBZnu/m1mDTk9yUgrvZxo4fPBqK6xqqpFn72PttocWkXo/mGxHjp/58Y/vrZ86OK+1BSkY6OYmRHCM8OYNDYMdelrCEElX8U425tbPJjARKC69CEpwEvou8rCqhRWFwFDECLuC8gvVyiBXqtnMYQO/MNmPcLCPqg4i/H830C0556h7ydmIVRgJySkTSWqbloWXXxyn6hO3PFJEXGp3sVYOXorLE6lTUndkZbrCXqPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptvCILPBlIIoTnBtu/y2zjdvoHaDw3vf+tkMVqmac60=;
 b=UXJJD63EeLVu82NpJjGtNSn2LIAZeCeV8FG1Iqe3OoX1XgwqTDJi2EaFMgVXI49KSHeokM+QcIb9gpJBHpt84vX1Yqux7QchtWIBXB4HxbDtDpDHCy6ONx8l9gOxO/kHJ48Rl0+Fhz4MAhjjb4EOVjBMV0CXGhpFmIRXf3N/1Iuo49d7q8QfSUPqrR0AmQvW8BrlSG9UM7yVSiHtFKc0/PjtcVbLP2QsQV+7NVjIB3EhKxYaPRlkeEigtyMTmDDpK57ehOsReSYKWNDRspF/Y4rDNBemNob3gkaNIdG0UBmgC69Mli/imv7uDxvkj24yGXEbrBOmuwFN4QA4eSsaIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptvCILPBlIIoTnBtu/y2zjdvoHaDw3vf+tkMVqmac60=;
 b=ITzIsyTUEMdUc9+2osRuo7WF431EWBzOr7XRpkSfx5XtiR2x8veVD8zYciORRJAfQA4+t3xJ129/ufKTIeQkeu5xZ1wx+HBvFrLMIsNpp1OSn36/rhaecLzBgvEOOOF9u+UQk/8Yd4BPkwT3D0Fr6ANEv7cBwwAzGQcEQT8FsHk=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by CH3PR10MB6883.namprd10.prod.outlook.com (2603:10b6:610:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 13:56:32 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 13:56:31 +0000
Message-ID: <ebb5d1a4-5ad9-469d-b1cc-8c8fb736298d@oracle.com>
Date: Thu, 3 Sep 2026 08:56:29 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 03/38] xfs: fix isize update in
 xfs_iomap_write_unwritten to track conversion progress
To: Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org
References: <20260819001442.1451892-1-dgc@kernel.org>
 <20260819001442.1451892-4-dgc@kernel.org>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20260819001442.1451892-4-dgc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::24) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|CH3PR10MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: ba02ea19-174c-4b53-acd7-08df09c3286c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|6133799003|4143699003|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	gWKLf3uEi5847/oIjpgPErFEOup53QZLDiWKiF3DYMrrR0iJg/g6gcJrvx4LJEoAfWHnL1d5QnDEBO9NgRZvXQLg3oPj/faYr7x+vSqP0YRbmVBLI/puoQoEWi0EaqF8rRVJ9nZH42WnIWJDgfN811i0BrDaUuj5J7XwDXI03WpN0+jyuNJB+lABfb9z48QweDoj31B+YbwvWlB5TXiNRpuuSaqYzERrJeC6lnGRvtQ66SwoAY5Gc39dV2zc5DY1Z7OxokXZmpvyQ1Gti5UNP2BfZ7a3vc19o1eYh6WFMXiqd7ZXiowYms90kIhP/LuPyYDSIAddHvUS9ohgb9HrVqIZcmk7bT/J42CsSQrAw5yA0cFxhY4Dl67WZ2Av3T/J1nZ4M0kdhvwX+dPp4lvGaAdSK3uhu1jv2JdRvPfTqruS7XN/uPRDQbU0yvu5hA/uHP1MaamiYEusR0ItZu5XZYuLjax8MFYzAbNqxb04mVEyTGN367bjmwB/1PUo23Wp7bnJMymj7p5fANZ596f1xSydGYDbnoj9StHdNaFp3TayIxsPs4Fm8U3zXCa80h9uCr5mXBA3KMKOudYGQ6G8WWJG1BVPd6R4cNdZVBTJJ01lpARqDDjFcpqsFjUHPes+AdF9kvldvsyaHHv4VnmLsvkbnZk2SreghN9pDn6JRVk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(6133799003)(4143699003)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXNtcVhDeVRqZnZXWTZFK2Z1ZzYxbFBRa1FsSXJXRnd6OC9lelNNRDVjSEpO?=
 =?utf-8?B?bkU0VkpUQTlCY3l6eVErQ1BLc0liYUtMSGxocFBvREpjWTcyQkZ2UnZwcG5p?=
 =?utf-8?B?cnFCemtiNGhRb2s4eklUcDdlaFNqYVk2MGZkV0xRT3NaN1ZxcTlYZC9rQW1p?=
 =?utf-8?B?QktrcmNiRnY3ekJlMk9obnBFdkw2OFVFTUlyQTZ2V3poUDlPckRNNU1ZRlpW?=
 =?utf-8?B?ZGlJQXl4L1BZT0NGd1lENnNQZkdEUUVPc1FRZE5PeTljam1CTDYvZUxwbDEw?=
 =?utf-8?B?T0JkcVdLNG9WaDBZOUpTSHgvVE5VZjYycmxzRFZIaXU4c3FxK0FNcStnN1RK?=
 =?utf-8?B?WmtLVmdDVnI4TDB3RDJNbkw1c3RhamtyNWlCaWs1cVVvV0lhWkd4Y1ZxVGNz?=
 =?utf-8?B?TW8xaDQ1M3g2dmkrdHkvY1YzczBFT2dHN1ZRaEhjY3BFcmtjaWx5eWtIdnla?=
 =?utf-8?B?cytzaW1DNXJDMjg0MkcrVEsxcVdwZEVwNCt6WTljQmdXSzFVZ1hXc0FaY0d6?=
 =?utf-8?B?c21QT3VSQmZyZjFoeUlzWXhVeUdoZU82TXNiMGFCRm83UVI0OEN1WDlQWngx?=
 =?utf-8?B?Q2RCVi9BYVc5YlJJcHc3ZURtUDFNQklsQ2lFcGIxWXdjTnZZUHdPZ3I1Z3g5?=
 =?utf-8?B?Yk5pVHJSbjNGaU5CSnk0UGZZRXVLTVlncHhUWG9JaDBOMTUzdWdJdUpDUVlU?=
 =?utf-8?B?TzJxbHVrNjJnOEViZVg4aG9GVEdGMlBVdnVoUll5VUdIVEZJNy9Xdm1UZ2ZI?=
 =?utf-8?B?dHFVV3ptS0NnOFdwYSsyMjVYOHVTeGRJYi9FR0tXa25zaDZ0K2JnRk9WeHRG?=
 =?utf-8?B?WjAxbnRJODFvT05vTDhBT1VTKzFtZkRMUEl4Nm4zeWhVaksya0pVMmlhRWpI?=
 =?utf-8?B?cnFkWHU5QXEvNHl6R0dMT0N6YXB2cnI4Tm0yUnpXNC9CKzJOQ3oyWngyWmVJ?=
 =?utf-8?B?bWY4SEp0R2xpVThTSm9zVGRxVjNJRmVVOGhQS1VCVlJGb2dONUtVZHJVdmFH?=
 =?utf-8?B?dGpqMDlFZm5NcTZ6K2hHcWZjMmx0Wkl2SStBR1piYWs5dWE4ZHBkN09pWmRr?=
 =?utf-8?B?ZFhGNnhEZjBnMXNTalM4Z0kwa25IYWtreFcyZDFVaWs3MFB2TTlyUnNKd2FV?=
 =?utf-8?B?T1JVSHpaZnFHL0JBWUg5b1FtZittQ3NOdFVuZUVGVWJHSDdiZ0xNNkJEZzNC?=
 =?utf-8?B?UDdCWGpxeXNOckpuZXhUMjk5ZmtZWmpuSXFIazNoRGNrTy9QRUFnMHZpdG1K?=
 =?utf-8?B?QzZ3eG1Vb0szSVE2UGtKdlpoRDR6TVhBS2xESGh4Sy9VaHdxc1JoSVRYdGsv?=
 =?utf-8?B?MEh6enJNWUl3N0JXUkgxSTdhS0xUbkNMekNGeWwybXl4VEpyeEp0WjZTUXNX?=
 =?utf-8?B?dmRFTHU1QmZWYWxtdm5taDFxS0JNNEk3dXI1d01TblpjODVmbkRLUDlKdUJT?=
 =?utf-8?B?UVUrakVwTncvc2piSVBVN0xjdVBtajVPaG5raEJhbWtOZ2U4ZXU3Rlo4bWJx?=
 =?utf-8?B?ZGs4czUrTFc2WCt0VENjOWZIaEsrQWhxM2FIYWNQTEd1aGliT3FpRlRIeE9Q?=
 =?utf-8?B?OE1JbW1idk1mSDlsSnlpeWxPdHVNcm0xUXZ2LzlxOWtCNmNja3lrK2Y3ZXZu?=
 =?utf-8?B?ejNVWGdJanJhZDEzVlZVT3NjM3NYM0dYZmpGLzg5clJ0dnNCS1FlaEZoUlJk?=
 =?utf-8?B?RStWczI5a3FydnNROGpIQitKSDlwbTlLWEs3MjRMYzBMSDBLTk1DMmNkeHhn?=
 =?utf-8?B?MktjY3hVREVjV1VDcmlRajhxeVVtZE9ibE5aUzhjUmFuZEFEK0l4ajVKV0Z1?=
 =?utf-8?B?Tm1YVVBkeHYvaUtCblV3ZkdDR1RMdUJTdlQ4K2tMNm5ralNlM2FidTUrNVd0?=
 =?utf-8?B?Z1ZFTmlHbVpuNHpwWWxRcWVXeWNyV1ZFMlIwMlE0TEZZWkVqOWdSbDBsSFVY?=
 =?utf-8?B?VnNNMGRuR2pocDY2ajcwOXlQNjNGYkNDR0dienpTd3Y1UVZ3eXVBaGlFZ3dh?=
 =?utf-8?B?M1NNbUM2TlJkSU0ranVWNVlvTFZ4NHNlc3dMWVdUa1VuS3pNUUE3Rzd1b3U1?=
 =?utf-8?B?TXFCTTB6eDFidzlsYW9HcEpvcTVmNXJuTTA2bUc5RWhMeUcvVEpHYjdBQmdM?=
 =?utf-8?B?UGJrZS96NEZTUlRYL3pkdi9hak8yRzdhZ0dDWGd1cGkzRjlBT1d1djZ2cVZx?=
 =?utf-8?B?eTF1a0Q1UktVeTUzRUFnb0xUdlhhSmNWMi9EdktlVy9XTEFrOE9VU21qTWwv?=
 =?utf-8?B?RTFNczRkNE4yaHQ5eEJ3TXlFaGN1REs5REhoUzhWaFRlaVNuQ29JYjFzZzZ5?=
 =?utf-8?B?QTJ4MjJXaXBnbmVubExuSU1IcmxHNHlpRTdneStZSWpiRW5WWWNwRnpLbEFW?=
 =?utf-8?Q?XWo/9QOvfgkOhrPk=3D?=
X-Exchange-RoutingPolicyChecked:
	LbW7Ak6S3G6x/SgyEkcvEDmfPm5b9c5XT4seJByqbS0w2zI/T1jCpcYkooyBrUr5V83b5BxXHCRrNHKX9ghQwaatZqdPZZIOVEnln63YkOA2k8tsqyNUhMtUIZgfaaC023hl3SQeORK7NpgjWBBwzsOWkda7S02z/2WuZYS+nE1A9M2G6ohfXP3F8fv5TIOFlDLCettA17wPrN1BvBZUVkWuW8Gnt6tYHGOA3DoYNGhzM+DX7Avr5IQj5RsHncNjkenZMGJZ1LRtf8B7LnvlAPEOOHCehtYpfNsgVBeAvAkB1f1Dk5sv0nO2u3Gnii9g2CRTJ54tvxxeKlEGl9Xw1Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zlVP5gqAfKQbX8jOX+iikdaKsmY61fN5zlyNvxd0bhiBWcRmDixHcumouTBGvUOknGzoEWOxH2Upi41zyYbXD3km9hmsINTy8iMWw4wxtANnNtDCC+f7K52pYTaLdJcRAbiLixLVwgapAnKG+3Rt/9OG8j5+cGt8npclrTwDNvn/huhuUwiN73yI1NMFyvNFPQ9NhpClut/PpsrNum0fOHYYt5weQmrUM7JAXEs9pqO8RZfAW+DfqaJRFKPpyIuYCs5z4gSa0Xm1yOLBtfi6FKRJFro8BhK06weY9oyjMdnfcLrDPltHT06DNAoWHpSpZAf2Tz+8pd32EOrpawLDXNdpxBV1bOnLewxCyU3Qoo5NtmB+V0m8i2AKy0r0FW1ex1cjOSXBm+rLaO00Cjvibiz+8LhJat+6Os4Mwe32hgU4A8u3AcMMusm3s03KXysIBOozxYbUqIUMcgDeTl2TxBlDZ+v81R6+pBAMiro/Tg+FFnAzN1aw1RkvE2Po0mnlZbwrVmeqUUjbowlWajvuL61VLLFezpHWTpZkA1EiRqLQc+YMqw1Ia9Xw+Th53h2Z3bGl96yTVob3r37q29F1wuzKuDreX+FLQqdhYjJ5ohQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba02ea19-174c-4b53-acd7-08df09c3286c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 13:56:31.2088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZk5oWlOemoaReFzxmt1YR96kfmefHg5dHyCY4aUARusJZwdeAtz5aOhQlSZCN7GiowddyByJ1khDB4QUkskqM7EP5LhB9lI4ufb95prOuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_04,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609030121
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDEyMCBTYWx0ZWRfXziR6ksmtcT91
 aN7w6VTG+H7jAraN8AeStAwAdua0MSOnbwPZx+c5krlcGNlthuUAbiQg2emEH/LUnL/f3LkM5m9
 36UVm7AUI7TbQavIom0p8Apqb8QzJm2dLMxe5PTuUvKjVVUfMdmC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDEyMCBTYWx0ZWRfX1SOPmx2h0YDV
 ZsuNf46bGaHfJ2te+OLPlixde/VvD+EhiQPyg/iKNJcPigTNZYOO0pD6by5s8fVr9RCi6EgK+JF
 C4r18534yBYRPuQjamzuTdrdFIvxLdJk53jUJ96vREbwCTTzury39Zr5WvkrWacbK9mr0XljOOO
 tjaBjha0EEbQaGJiXwrFAusHSqsCWIJgvLr8nEdakKoH7842QlC7tI2zWGsmq/xtgy3HTndjUWW
 0B1+5HAqnKIs4o3UTuQ5yGxfwmhY2h6I6pL5hzhLQVfi+oFy+8cqFe586xDg9KrRigH3AMQmT0t
 qSwwptbflT4OFmkUj4PpIxsGNImigb/L872pH6MfPhUM2P39Gup/neuOHK+QbwsjDP82NwCzyUI
 SuNRIsejCLxMl7yqgWFL7U44+0No9nijZv+2Z+xYHP+6BMX0vBL529tJ+JnzqNVR5ujo3EYeEB0
 +s29uqphFMUb6yX8jAw==
X-Authority-Analysis: v=2.4 cv=G7os1dk5 c=1 sm=1 tr=0 ts=6a997c96 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=6EFM2V6OKWI9FX0h:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=lsLWt1XoyrVnd_SBvHoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3gzFnWTLXo1axfhsCrwgWu6O2m4E8LTl
X-Proofpoint-ORIG-GUID: 3gzFnWTLXo1axfhsCrwgWu6O2m4E8LTl

On 8/18/26 7:12 PM, Dave Chinner wrote:
> xfs_iomap_write_unwritten() updates i_disk_size using the end of
> the entire unwritten range (offset_fsb + count_fsb) rather than the
> end of the extent that was actually converted in each iteration
> (imap.br_startoff + imap.br_blockcount).
> 
> If the conversion requires multiple iterations and a crash occurs
> partway through, recovery would replay the first transaction which
> set i_disk_size to the end of the full range. This exposes
> unwritten extents to userspace reads as zeroes rather than the
> data that was written, because those extents have not yet been
> converted from unwritten to written state.
> 
> Fix this by computing i_size from the extent that was actually
> converted (imap), so i_disk_size advances incrementally as each
> extent is converted. On crash, recovery only exposes data in
> extents that have been both written and converted.
> 
> Fixes: 84803fb78237 ("xfs: log file size updates as part of unwritten extent conversion")
> Assisted-by: LLM
> Signed-off-by: Dave Chinner <dgc@kernel.org>
> ---

Cc: stable@vger.kernel.org # v3.3+ ?

Looks good

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>


>   fs/xfs/xfs_iomap.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 225c3de88d03..1437ea93563c 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -682,11 +682,15 @@ xfs_iomap_write_unwritten(
>   			goto error_on_bmapi_transaction;
>   
>   		/*
> -		 * Log the updated inode size as we go.  We have to be careful
> -		 * to only log it up to the actual write offset if it is
> -		 * halfway into a block.
> +		 * Update the inode size to reflect the extent that was
> +		 * converted in this iteration. We must not advance isize
> +		 * beyond the extent we just converted, otherwise a crash
> +		 * before the next conversion exposes unwritten extents
> +		 * (zeroes) to userspace instead of the written data.
> +		 * Clamp to the byte-level write end in case the converted
> +		 * extent extends past the write boundary.
>   		 */
> -		i_size = XFS_FSB_TO_B(mp, offset_fsb + count_fsb);
> +		i_size = XFS_FSB_TO_B(mp, imap.br_startoff + imap.br_blockcount);
>   		if (i_size > offset + count)
>   			i_size = offset + count;
>   		if (update_isize && i_size > i_size_read(inode))

