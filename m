Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283815;
	b=DF2gCCDlYNSYNDLk2JuNh25IenGnc3snnrQnUTeJ5moQVEfuFPlZH9rrXWwyERIFcB1N
	 3pcy5DYUAezhLrsS8H05tnWCMrxRZcklm9bxO5+B8FUN55ZhNHdC6IpvttC0xzB7UgX8W
	 ee5fDgjEJw9v0taADObiW0OzIoJrNjf5LMSL6/1szq0JY1sbNQl1R64N4Vmf8j2tXn1xV
	 zIZ4wSz/W9c99yVyimLdULVs5+6FkeVMnwJm7ipYVfEp5Zct8eH4Yez1wjOrq6NrxKfn3
	 uiL6xYPPwqXNOes2R9UHziYLN0Vv4sOFgt91HtnGauxb/3FqPv2ARszAwUXo54zf6Xg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283815;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Subject:Cc:To:
	 From:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=AutIuZq1mC8kvTeksT6nUMV1DEIdKJgoInLS2v+ff6U=;
	b=FOOM0pSzSejjvhlxoCFNWKfNdnKzulLxyHGVNEGzIUBANr9eUVlDNrFSecj0Li1bQ0jT
	 qMjD1Hj8uTnfQ9avAF5C0hm6HXt+NfGwRCmuZPXqqlsexcZx7wNLSI5rMpI9pg1bn1Rjp
	 Z6Fpn/hvXLuGAUx5EQRjEHFtYvIFkyZ9elMwnhW+o8xKyQy1xnQbcRGCPr3MjF3a7Ps87
	 INcPglREHbx/qMVkbbQKaCKX2dbmCYjBit4x2GUf8riO3+6yRAO0gQGsRsoQL8H5jRPzt
	 ZSnjuC5Ed3MvCDFjtJCYdlXr8E71yRGv+EUqzeISc8HS0UozzzVeQVCwdkV81BkDZiw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LkTLaYhN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.53
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010053.outbound.protection.outlook.com [52.101.193.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43C2606A31C;
	Tue, 10 Nov 2026 04:10:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D43C2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LkTLaYhN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R7N3fzzjvi4dZIeZwkT1dIRoxlfl4Tkn6dkw22/YyHlgfNZn98zBs+jwTW6YIf3lZR0VCOQQTV8uIn1JXi41LMy+GItyWZm1UUulLnvut5wuUL8IBQqq765WtLXrkU3wUtT+SaU8HL8H3hZL5ligj37HEP9ZkG/DBC9/sa9JMegapKxG6TbQ/KmiOUC834dVblqf/inSSVI9fZhuFNmkWn8uOpONf7Z5xTisbXhsO+xx+gGnQso4JvKEKCqSB/uTTD0+2zQRhzRNsJD/gicRXa1fNUJ7YL2POr03vtzVUDBnXwlWe4Vthubia6yH8DW245E5zZLtJvPz3Ux7uwYYLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AutIuZq1mC8kvTeksT6nUMV1DEIdKJgoInLS2v+ff6U=;
 b=ApYMEIwMnCBshyxvozKphbtbum5tURMADtRi7FeaSleV3Mrm3ZcdKo1NViwYwQKEUuD9s0dQjpcIv1/LVOwb1wh/1ci3XIdfPCqnhUQGrk1PPmEaSH9irYGd4NhhRf0iMAOxPN+pFKC0F6OKfCJN18+vi0g4lx/TWioL8wjyr5ZHHluquTxX9dwytQcfuUpolUAmqQWf2OiM5C6+sJC+zTApBf22DD5pfROnRXCnuUrhhz3b9yc5q2mBx1BJ2Bs6sBHbsBrsCaA1icuYiDSkCirrIuWyF+qE2dtthkmTB1vsIKzL1G3RbXgMNdmA4nQ3Xy2CtjvFvzeqTrLbSuV5/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AutIuZq1mC8kvTeksT6nUMV1DEIdKJgoInLS2v+ff6U=;
 b=LkTLaYhNBX0CQX7FbxHV+osEFosRTbHZRHQTSPDrFO2JfA4D3NkI5zM3hnad9cBIY4bAk3NStqpG08ISu9Jn+/6AnyjpLyrJXdGorVzO3rIedNnX2E7QfDJL19ZZuMVVltZId2E/3EGlagfZyqvJGlYIBzyQfj4ToNqYwpsNF8QBMItWvqZcg9H+3uRAULfxguksaK8kCMPdh6mmEjk46wo5T76gcWMdDJpx5+Xd9kBZ7e9LtlYGUDbIddoEndJqYN5kJgygyFSnxsT1KpJk9v06j4dUyx9LUjLSMLTDTeLOvdP2E3TCOZc8+Uf0VBSUsS0L1hfldqkTsNp4ARVHCQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS2PR12MB9800.namprd12.prod.outlook.com (2603:10b6:8:2b5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 04:10:08 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 04:10:08 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Nov 2026 23:10:06 -0500
Message-Id: <DMR8IXC61XST.3GFDCM6FZ5OCM@nvidia.com>
Subject: Re: [RFC PATCH 0/3] mm: enable filesystem page-cache large folios
 without THP
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>,
 "Kairui Song" <kasong@tencent.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>
To: "Fang Xieyan" <fangxy@xiaopeng.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Hugh
 Dickins" <hughd@google.com>, "Carlos Maiolino" <cem@kernel.org>, "Pankaj
 Raghav" <p.raghav@samsung.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261110035205.3036-1-fangxy@xiaopeng.com>
 <DMR8CJLIMPDY.2NOHDSE107FBK@nvidia.com>
In-Reply-To: <DMR8CJLIMPDY.2NOHDSE107FBK@nvidia.com>
X-ClientProxiedBy: YQBPR0101CA0181.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS2PR12MB9800:EE_
X-MS-Office365-Filtering-Correlation-Id: 1156e6a7-c98c-4017-4ac0-08df3ee081f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|18002099003|22082099003|6133799003|10067099003|11063799006|4143699003|5023799004|261102123227099003|261022105027099003|261022115727099003|261026140227099003|261026121527099003|261022075727099003|261021123027099003|261021121427099003|261009223027099003|56012099006|261028144727099003|260925022911599003|260925021311599003|260925021911599003;
X-Microsoft-Antispam-Message-Info:
	mwKDQhAPGsN6RDzUF6RI7QP03r3dmr/GTtRjNSRk4KVk9o02ONFheESZnH839h4gZUH/v7NxEmy+g8bGjfh243nht2kOa3RV6o1aaJFklDVZrUuPpzhHfvuP40Ply7i8qTXZz2FCxz/GWC8dDv0l4vnKhyBkUPg/KHiDHYRezF6x7MGsbudBVpWCkY8da9MhrWXfgmlMMY/zlluI4QjI4bIJnOLLSmhHqCkTIkWV/39zSC/3O2FumuUS2ZyvRMqiM3r0IVuG/fkQTNFdJ22g/k5N3BDA5EkLWVYEyg/wTv/awi3SU1RaBHDWuJGT2dXyYZGiwKtRpa0FZ8XXAZxW4g+7MVGSlPxfwclVeNt7GKsSbEcWwlulV1TIhPD/PrZn6wa0ayoKBpOEvr9E9LwP4RCoaTPGv/VPEakvHlKEFWs3w9Q12JnJHf8xhGQWrvnErGlnpnB/vJnpMNuLM5X6gHmK5eWE77rvx6jDXOIMr79q266TapakKkO2sUWBKE2XTQgUsOBPjxzG1E5iHGcuPALgyH8acUx9D7WiNr2HuqOqx+mWnfpEEZX5tZJVN/YCpiyvpZECNs6/6Xw1h6JDjFkAoLIdLX34DQIqvLVeuaMHLKpspwmNjp12h5P+S9WeUGiKWplh816kOeT/5M+FtH2ZWeBUkZ2gbw/19//SfMQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(6133799003)(10067099003)(11063799006)(4143699003)(5023799004)(261102123227099003)(261022105027099003)(261022115727099003)(261026140227099003)(261026121527099003)(261022075727099003)(261021123027099003)(261021121427099003)(261009223027099003)(56012099006)(261028144727099003)(260925022911599003)(260925021311599003)(260925021911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3Y3aVp0aXhlSmZPeG4zbGFvdHF1UWZ3Vk9KU0NkV2UyZ2ZKZXhla1JWT1oz?=
 =?utf-8?B?NVc5NWEwUXFRN1kzemR4SDJKTGZadTREdlFteWZHeU54S0ZNL1ZjVWRRVVda?=
 =?utf-8?B?d1k5dUxQS2ZNUzZxcm5mZWxWQmhMdFY1bmVuSFE0V2JuRGpFbFRiazM1dWt0?=
 =?utf-8?B?SWtRalY1SkJXRHRETjFudG5tYVZnNmpmMnlIZWw3cjdoY09tazNtOTBjbHYx?=
 =?utf-8?B?czl4MnpVSXh4MEhTaW9mYm1nbmJYUFlDa0RHODZtN0pzaEhiZGhhMzc3SzRY?=
 =?utf-8?B?NjBFZGRCbS9kMEd1WnRvaTNXSHJqMUNoTC96VHRaQnFidWNBa0ErVGhzemxI?=
 =?utf-8?B?dHpiZjZoZitCdlpmU1RkbW5sMkkza2o5aGl0SUhxelBJRnRpZSthcTdsWHUz?=
 =?utf-8?B?cGJYb1IxTGE5b1BOWGJEMkh6M2xNSVk3NzVvOHptbTRGYlhnZmZXT0JPaVA4?=
 =?utf-8?B?aU13eGxrdlZ4YVlkSTZMeHpFai9Rcm51dE5WOVowK3ZCTEVmclE3bFhoamN2?=
 =?utf-8?B?YlFzdE1sejRneDA4dTVmTVJxYUl1L2Q3MzhVVzdiaWJPdXVocE5NOHZOTXBi?=
 =?utf-8?B?ektrSkNYY3ZNT3RXQzRKNmdTazNQclZSc0pLWmRnQW01YzRFVWRSdUdGSUNl?=
 =?utf-8?B?d2Q5NmxWbWdGNEVBeDMwcENyWTNBWjhieE9yWkhyMlBRdmVKK0xNbnNhQUVu?=
 =?utf-8?B?MlB0MmppRHZ2bEgwV3lWOGJ2YThua2RyOWFlbWYzY1ZLbWI4TFZQbDR2NnR2?=
 =?utf-8?B?aDBwUnRtTExWaVpYS1lyS2RXbTJTb29pL0ZCTHlQNDFPODUyT3d0dUJMSk5n?=
 =?utf-8?B?bWFKbFVKNWd1aTdaNmQxMHJPWmxqTTMzRVdrNU1VdnZCbnAzNno2VlVGMWZQ?=
 =?utf-8?B?b2VGa2NMa0w3MFBNZE9HR3hJRjlib3MxM2llOGJqcDB3bE93MHhOWkJ6SEJS?=
 =?utf-8?B?M1ZzZXZORS9UZTBIQnZFdFZwZXpDenlSbE84NGZtb1VHYnIwS0t0UDhyTG1P?=
 =?utf-8?B?MFQ1SGpvMU15RElIaUdEZFZYamVVUUluVnZOMVgrTGNqeEZHcXd2ZXQrZVdv?=
 =?utf-8?B?UDlLTElGSEczU21QVDl2NE1zbDVPckZsVHYybjgrV3JROExMdmdJUXBwRlY1?=
 =?utf-8?B?WCt4emR2RmtWcUVZTkV5S0ZQc2h5UFcxcTJLTThFcUcxZjdaeUpLcCtNU05x?=
 =?utf-8?B?UkxVOTcrb3c0OU9va3lTNWdvWHZGTmkybDcxazdsV1lWZzc1RUVlMXBhRFhX?=
 =?utf-8?B?cFVFbW9xdGh0NnNjK251SjZ0UmZReWdqT0hSRlhXdmpVQXRMbFA2SktEbklD?=
 =?utf-8?B?a1NzbnFWYjF5cUFTTjcwMHZHLzAvbGtPdHRTSG9pZUFlTy82RDJQYm0vTGJI?=
 =?utf-8?B?SUdIQzI1TkpiMkVnS0ZGSEdTWTI2cnZOVER5TzN3Y1pmWU10MjhpSUpNN3c1?=
 =?utf-8?B?SkJwa2thSjJocVdFZ0tZcjR0LytFbEhsRXdDRHVJU05xSWZLTUtwVW10dVFQ?=
 =?utf-8?B?eW5uL0Rzd0x2eU04OWFQUXhvdGhTTm1tUG5IbGlNbFpoU0hRcDJCNTh0ZXJr?=
 =?utf-8?B?bWM0LzJtVWNPeXQ1RHlvSCtVb21oN0FBRm5MVmZMakVFNjVoL1duVnRmNm5C?=
 =?utf-8?B?M2p0cjhaTWwrbUFIVDQrT2hVUFdzbVNMR09MZzRMd0pmR3hHTmpWejcvRnJo?=
 =?utf-8?B?eHNKVnNMTVJYc2lvb2lCRTR4bWEzMUphcUtUdDFuSnBtOWJlbVhUMS9yVXBJ?=
 =?utf-8?B?eDBlNUppRHBmRU5nWmVZZUtqSTNlR292eHlKZWdzdms1U2c1dUxqVHlRSlIy?=
 =?utf-8?B?OEhrWkxPL0tXVXorcHVjOTFnSDBtQ1k1VEFId0NWOGkrKzdhc3J1a0tpMzhO?=
 =?utf-8?B?RlBWVnFoU1V2cERMSTUwNFNlK1ZQMGd0ZmNMVXErcGprSzFnZ2hlMXhONVZV?=
 =?utf-8?B?Zzh1NmVqU2N2c08yaDZUU0RNUjJWN1lLbzV3YzAyelpLeFhOQ0p1MmhzS2Vi?=
 =?utf-8?B?WXZ0SUNuVUdGbnEyUjVCN3QrVm9NUytHd2VrclB1REtFVlNVT29wZEV0Y0RU?=
 =?utf-8?B?dlpZWmd6dm9lRW9ud0tBTzZGa1FTSXVaQWRKZ0ZxeldPWHZ3L3JQSHhqOC9V?=
 =?utf-8?B?eldxd2s5VXBuNkFFQThqdk5QV1p3V1hiMTIzdXpIVUlPS1JJWDBYajNqaHRQ?=
 =?utf-8?B?R2xPWlA4cS8rZHZVSzNoUlZ1ZTQrVjFRSjcrWDF2ZGVEUENWanZZTXlQN1JS?=
 =?utf-8?B?UitXbkVKbExyY0ZNZGlDeUJIWjliaXcvUmt4bFNTakJmaXArZ1pwZzFhVE1Z?=
 =?utf-8?Q?xKwfffNBadxlND9AVi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1156e6a7-c98c-4017-4ac0-08df3ee081f4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 04:10:08.5312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wt5KNXgI2Yau07rmfLbf7aFplmhL6HYkFXO9as8Ru8ygySC8rVjGuhcPl7+vZ6qi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9800

+Luiz, since he is working on "mm: thp: always enable mTHP support"[2].

[2] https://lore.kernel.org/all/cover.1789695931.git.luizcap@redhat.com/

On Mon Nov 9, 2026 at 11:01 PM EST, Zi Yan wrote:
> +Pankaj, since he was working on this[1].
>
> [1] https://lore.kernel.org/all/20251206030858.1418814-1-p.raghav@samsung=
.com/
>
> On Mon Nov 9, 2026 at 10:52 PM EST, Fang Xieyan wrote:
>> This series makes filesystem page-cache large folios work on kernels
>> built with CONFIG_TRANSPARENT_HUGEPAGE=3Dn, and keeps them splittable
>> there.
>>
>> 1. Why this is needed
>>
>> TRANSPARENT_HUGEPAGE depends on !PREEMPT_RT (mm/Kconfig), so a
>> PREEMPT_RT kernel always has THP off.  Today that also removes
>> file-backed large folios entirely: the helpers that split them live in
>> mm/huge_memory.c under CONFIG_TRANSPARENT_HUGEPAGE, and the order
>> accessors in include/linux/pagemap.h short-circuit to "no large
>> folios" when THP is off, so every filesystem that opts in silently
>> ends up with order-0 folios.
>>
>> The consequence is not only throughput.  XFS allows block sizes up to
>> 64K and fs/xfs/xfs_super.c refuses to mount anything larger than
>> mapping_max_folio_size_supported().  With THP=3Dn that helper reports
>> PAGE_SIZE, so a 64K-block filesystem cannot be mounted at all:
>>
>>     XFS (vda): block size (65536 bytes) not supported; Only block size (=
4096) or less is supported
>>
>> There is no degraded mode to fall back to, because a block has to fit
>> in a single page-cache folio - which is why
>> fs/xfs/libxfs/xfs_ialloc.c derives min_folio_order from
>> sb_blocklog - PAGE_SHIFT.  Either page-cache large folios work without
>> THP, or the filesystem is unusable.
>>
>> 2. What the series does
>>
>> The anon and file split helpers were already separated by Kairui
>> Song's "mm/huge_memory: clean up and decouple the anon and file split
>> helpers" (v6 04/17, in mm-unstable); that is the base this series
>> starts from.
>>
>> 1/3 moves the folio-splitting implementation out of mm/huge_memory.c
>> into mm/folio_split.c without changing any behaviour.  The new object
>> is still built by CONFIG_TRANSPARENT_HUGEPAGE, so a THP build keeps
>> exactly the code it had before; a pure move is also the easiest thing
>> to rebase on top of further churn in this area.
>>
>> 2/3 builds that object for CONFIG_LARGE_FOLIO instead, and drops the
>> anon, PMD and khugepaged dependencies a file-only build cannot have.
>> The symbol comes from Matthew Wilcox's "[PATCH v9 12/15]"; if that
>> series is in first, this patch shrinks to its Kconfig default and the
>> accessors it already rewrites.
>>
>> 3/3 enables filesystem page-cache large folios when THP is off.  It
>> lifts the compile-time short circuits in pagemap.h for
>> mapping_max_folio_size_supported(), mapping_set_folio_order_range(),
>> mapping_max_folio_order() and mapping_min_folio_order().
>> PREFERRED_MAX_PAGECACHE_ORDER is left alone: an LF-only build keeps
>> the existing cap of order 8 instead of following HPAGE_PMD_ORDER.
>> Without THP such folios cannot be PMD-mapped, so raising the ceiling
>> would mainly increase the maximum page-cache allocation size.  The
>> changelog has the arm64 64K-page arithmetic, which is a calculation
>> and not a measurement.
>>
>> The split side is not rewritten: truncate, migration and memory-failure
>> already call the helpers outside any THP ifdef, so with 2/3 in place
>> they simply stop resolving to the -EINVAL stubs once 3/3 turns
>> allocation on.  madvise is inside a THP ifdef and does not take part.
>>
>> 3/3 also makes the XFS mount failure above say why it failed: when
>> CONFIG_LARGE_FOLIO is not set, the warning now names the missing
>> option instead of only reporting the block size as unsupported.  With
>> LF=3Dy the added warning is compiled out completely.
>>
>> 3. Testing
>>
>> Six configurations build clean as full kernels, bzImage and the
>> vmlinux link included, with no new warnings: A (THP=3Dy), B (THP=3Dn,
>> LF=3Dy), C (B plus HUGETLBFS), D (THP=3Dn, LF=3Dn), and RT-B and RT-C wi=
th
>> PREEMPT_RT=3Dy.  The PREEMPT_RT configurations were build-tested only.
>> No runtime PREEMPT_RT stress test or livelock validation was
>> performed.
>>
>> THP=3Dy is unchanged: the .text sections of mm/filemap.o,
>> mm/readahead.o and mm/shmem.o are byte-identical before and after the
>> series (md5 equal, 45896, 7139 and 35314 bytes).  With THP=3Dn and LF=3D=
n
>> mm/filemap.o and mm/readahead.o stay identical (44584 and 6259 bytes)
>> and every function in mm/shmem.o keeps its size; the only difference
>> there is one dead argument load that the folded-out
>> mapping_set_large_folios() call leaves behind, so the section keeps
>> its 29778 bytes while its md5 does not match.
>>
>> In the new LF=3Dy, THP=3Dn configuration mm/shmem.o keeps its size as we=
ll,
>> 48 bytes shorter at 29730.  That difference is not from 3/3: 40 of the
>> bytes are shmem_writeout(), which shrinks because 2/3 turns
>> split_folio_to_list() from an inline -EINVAL stub into a real call, and
>> the other 8 are the padding in front of the following function; the
>> same 29730 bytes appear with 2/3 alone, and 3/3's own shmem hunk
>> changes no function size.  The new call is unreachable in this
>> configuration anyway, since shmem_alloc_and_add_folio() still forces
>> order 0 without THP.
>>
>> Where the generated code really changes is the allocation policy:
>> mm/readahead.o grows by 880 bytes of .text (6259 to 7139) and
>> mm/filemap.o by 134 (44584 to 44718).  nm -u mm/folio_split.o lists no
>> anon, pmd or khugepaged symbols.
>>
>> Runtime, x86_64, 4K pages, THP=3Dn, QEMU/KVM, on a 64K-block XFS image
>> (mkfs.xfs -b size=3D64k -s size=3D4k), with kprobes on
>> filemap_alloc_folio, filemap_add_folio and __folio_split:
>>
>>   - writing 64M: 84 allocations - 59 at order-8, 5 at order-7, 5 at
>>     order-6, 5 at order-5, 10 at order-4, i.e. exactly 64M;
>>   - reading the same 64M back after drop_caches: 72 allocations,
>>     62 at order-8, 1 at order-7, 5 at order-6, 4 at order-4;
>>   - truncating 1M to 700K: one __folio_split, landing at order-4,
>>     which is the min_folio_order XFS asked for; order-0 never appears
>>     in any of the three phases;
>>   - tmpfs writing 32M: 8192 shmem_alloc_folio calls, all order-0;
>>   - shmem write vs F_SEAL_GROW, reproducible as: memfd_create(),
>>     ftruncate() to exactly 4096 bytes, F_ADD_SEALS with F_SEAL_GROW,
>>     then a single pwrite() of 8192 bytes at offset 0, comparing the
>>     syscall's return value.  It returns 4096, the same as the
>>     pre-series THP=3Dn kernel.  A THP=3Dy kernel returns -EPERM here, an=
d
>>     so did the LF-only build before shmem's mapping was put back
>>     behind THP; that -EPERM is pre-existing behaviour of THP kernels,
>>     this series neither introduces it nor extends it to other
>>     configurations.
>>
>> Same image on the pre-series kernel, for reference: it fails to mount
>> with -ENOSYS before any of the above can run.  The whole probe was
>> re-run on the final revision of the series with identical numbers.
>>
>> 4. What this turns on for existing filesystems
>>
>> LF=3Dy makes the existing opt-in take effect for every filesystem that
>> already asks for large folios, and that list is not ext4 only: ext4,
>> xfs, btrfs, f2fs, fuse, afs, erofs, nfs, cifs and zonefs all call
>> mapping_set_folio_order_range() or mapping_set_large_folios() from
>> their inode or superblock setup, unconditionally, today.  Those paths
>> run on any THP=3Dy kernel; the new configuration is only THP=3Dn with
>> LF=3Dy.  With THP off the ceiling is PREFERRED_MAX_PAGECACHE_ORDER,
>> which stays at order 8.
>>
>> On the tested 4K-page configuration, 4K-block ext4 gets min order 0
>> and max order 8, while 64K-block XFS gets min order 4.  Btrfs derives
>> both ends from the mkfs sectorsize and nodesize.  A THP=3Dy kernel keeps
>> the order-9 ceiling (HPAGE_PMD_ORDER) it has today on 4K pages.
>>
>> shmem keeps its THP dependency: its mapping is only marked large-folio
>> capable when THP is enabled, because shmem_alloc_and_add_folio() still
>> forces orders to zero without it.  This matters beyond cosmetics.
>> generic_perform_write() sizes its write chunk from
>> mapping_max_folio_size() and passes that length to ->write_begin()
>> before clamping it to folio_size(), and shmem_write_begin() rejects
>> pos + len > i_size for F_SEAL_GROW.  On a 4K memfd sealed with
>> F_SEAL_GROW, an 8K write at offset 0 returns 4096 on the pre-series
>> THP=3Dn kernel and -EPERM on a THP=3Dy kernel; advertising order 8 while
>> allocating order 0 reproduced the -EPERM on an LF-only build.  Tying
>> shmem's policy to LARGE_FOLIO means the allocation, swap and split
>> sides together, which is a separate series.
>>
>> 5. What is not covered
>>
>> Since PREEMPT_RT is the motivation, the RT side needs to be explicit.
>> The freeze-to-xarray-update window in __folio_freeze_split_file() is
>> the fourth freeze site named by Matthew Wilcox in the RT livelock
>> thread started by Dong Hui
>> (<c2ff0c66422c4e2d869499a1186ff0ae@xiaomi.com>):
>>
>>     There's also __folio_freeze_split_file().  I know PREEMPT_RT
>>     disables TRANSPARENT_HUGEPAGE at the moment, but hopefully that
>>     restriction will be lifted.
>>
>> This series does not fix that problem and does not claim to be
>> RT-safe.  It only makes a code path that already exists on THP kernels
>> reachable in a configuration that has no THP, which is the same
>> exposure Kairui described in 06/17 as "should be fixed generically".
>> One detail that may matter if a reader-side fix is chosen: the
>> function already holds the xarray lock until the folio is no longer
>> frozen and visible, since folio_ref_unfreeze() happens before
>> xas_unlock_irq(), so a generic fix of that shape would cover this path
>> without touching it.
>>
>> Also not tested here: the migration, memory-failure and madvise split
>> entries at runtime (only truncate was exercised end to end), arm64
>> with 64K pages, nommu, KASAN and lockdep, xfstests, and the btrfs
>> order range.
>>
>> 6. Questions
>>
>> (a) Non-THP split accounting.  count_mthp_stat() is a no-op without
>> THP, so in an LF-only build a file split updates no counter at all and
>> THP_SPLIT_PAGE does not even appear in /proc/vmstat.  I have a
>> follow-up patch that gives the file path its own counter.  Would you
>> rather see a new vmstat item, an existing one reused, or nothing?
>>
>> (b) Should XFS select LARGE_FOLIO itself?  Three lines of
>> "select LARGE_FOLIO if MMU" in fs/xfs/Kconfig make 64K-block XFS
>> mountable on a THP=3Dn kernel with no manual configuration; I built such
>> a kernel and mounted the 64K image.  The cost is mm/folio_split.o: 3.2K
>> of .text in a THP=3Dn build, code that every THP=3Dy build already carri=
es,
>> paid also by XFS builds that will never use a block size above the page
>> size.  Kconfig cannot express "only when a 64K filesystem is mounted".
>> I left it out because it changes default coverage for a decision XFS
>> maintainers should make, but I can add it as 4/4 if that is preferred.
>>
>> Comments welcome.
>>
>> Fang Xieyan (3):
>>   mm: move folio split code into mm/folio_split.c
>>   mm: build file-backed folio splitting with CONFIG_LARGE_FOLIO
>>   mm: enable filesystem page-cache large folios without THP
>>
>>  MAINTAINERS                |   1 +
>>  fs/xfs/xfs_super.c         |   2 +
>>  include/linux/huge_mm.h    |  60 ++-
>>  include/linux/page-flags.h |   5 +-
>>  include/linux/pagemap.h    |  17 +-
>>  mm/Kconfig                 |  19 +
>>  mm/Makefile                |   1 +
>>  mm/folio_split.c           | 969 +++++++++++++++++++++++++++++++++++++
>>  mm/huge_memory.c           | 920 -----------------------------------
>>  mm/internal.h              |   1 +
>>  mm/shmem.c                 |  11 +-
>>  11 files changed, 1054 insertions(+), 952 deletions(-)
>>  create mode 100644 mm/folio_split.c
>>
>>
>> base-commit: b024a51b0184b1efb6f55b11aaf7b15a490a6307




--=20
Best Regards,
Yan, Zi

