Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795642565;
	b=S1aunGIN3XMh97d2hIKdwp+lYs70okwKJ1ummHwL780RJZru6VEv1NdwI5621pAjI1wj
	 eohELwAsIdTkM/KkjaGQ0D4NBNJfm0LwxSrIGu8NuM5/vB6OyPuhhvPvkN6AAYSrhXbVO
	 34chj2XEh9akc8Ogz44yrvWS8KZdAae3kDyUN67Qlw0UBDPWF6Qs9nu+2nvTwrBtEeylF
	 RxYiYuweeTh1UYcKAAwHi1mgeciIs98Y5JFYsI9SDCKBU8BS7b8fx64A/paDj98im2i6A
	 7kkkpC1jAa3Jn/wiusMaXtHYJHnMgoPJ/21q7TkXCIaFqtVgRWmGY7d2O9LEbq2MLlw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642565;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=hICcxFwpGqAt1bFPGPlzvicfD6n257Qr6ewQEMpxZlw=;
	b=kj1yYHN0N8J6qsPyHRBLGtzaVDxUgXYLsEB+EJcmL3ZHRr8ln+tx9gA0qsrkKDYbMTwy
	 ASlD37mJzwSZZPY8p2J8rz8QGPIfvEpVWnyJXLwwvHt1YAAx0NE/6q6LBb9ZEqvJa1YS1
	 2j8qP+CtDATipHSMt+4HhyMi4QMKLd9EykFJr2n+2WHqa9qBvMG2wg61aq+1mGdicEVuc
	 FPtZNksQb4F85bCKx5z5PsKxrBwBfofvoLiFXl+R1eHsJjvWD+OvEajB3ZCI9YiexeYoN
	 MskX+cWj9J91hfbFG/I8CdNp+Q63gVLk8uNK+aKhEv6tmDIrbQNiXQf4QWlOK9xY2Zg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h2yQ1bBs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.60
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010060.outbound.protection.outlook.com [52.101.56.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DE3606A31E;
	Wed, 25 Nov 2026 21:36:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10DE3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h2yQ1bBs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Os6eFg9LyRSrgs4GMPaIH2GyBbIJBC+B7p6YfaPbOgHfOAMcV1fUnrrgblZ5lMvksyldcdrNG/iX1mI5B2U51BzjPArkNqWricvY3SrHRBsHFEPVjw4MrKnuVAM6VILbLTpBy6tXgS/gafhXyh/8M2cBtfECKYdIqNmxnpFzxshzQlHuIWwHH67mVEMAiHVejTeAVlG+aHkg1cWDnmZrHK3UjWBkGgvo8vMLxOfKZ04r0LDnFYFcAx252BSNk/vzTMBajaePpWgs3nlNSjlyukCrCV87MQkxbZpeoSHKwe99WuixNOdhzUIAqgmS/7SuMze8QPtBynwTxTpBnJnlEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hICcxFwpGqAt1bFPGPlzvicfD6n257Qr6ewQEMpxZlw=;
 b=nxjWZ43CUJ1S6oy6EIfY6uI9SKoU63IZLJIv/YoVbd2XvVDWzZnePfzNB3cP0RZook5sgloHVsoqKt+UCFBq5tQlkoEUYavWRaGKa+aVupBxxCfz1DyDz7p/CnnYb/jZsDirQ+8j4pkUhIbJ9RHHoQhUbS7Ook9tH4lFyusNMY7DHAbTHEZ/bo2jHigD66w7aLFwOVVRrgkUW+MSlTVG1d1NKz7XvANmZsMZaxIsUtNkR5XPLkUkhqNrn9JUOO2/cKasu27v44ay5BnBU323+X5AZNTOaCJvhss/FtH7hUEtRpv8xMC828jcUxXF6v+6y8PnLeltcDiYFLJg4uYU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hICcxFwpGqAt1bFPGPlzvicfD6n257Qr6ewQEMpxZlw=;
 b=h2yQ1bBsJWSE0lHR/IpZfFG/ZjnBSV2mM3w2RMs2diBWyCU9zMzHe7blBarFZOx3NUM+2kUNTlu4tvqxuh9GI1dUx4rjm1wJY8NvpH+1+vKGqZpjKTc+grpcXyxlCRHZTr4P3h+eG6c7pWUW4zi+r9ndDmsEaB7hPhp7rY/T2nWWs6rLx/VONXN/oWDA3lH+PVwnQBJNPBHzaw957DN48bAWHlEQeRZuz1w3VszuJbg0sM8ztFxG3LrsVbxH8Hy1sMdAHqIuEoqUBCa+WCR8oFvbQSnoOCC5B0hLAaF85FzBcKSINQzE1FYck6k+l9KBkLtdnpbLtq5KYdUmpfLEHg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB5614.namprd12.prod.outlook.com (2603:10b6:806:228::7)
 by PH8PR12MB999295.namprd12.prod.outlook.com (2603:10b6:510:408::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Wed, 25 Nov
 2026 21:36:00 +0000
Received: from SA1PR12MB5614.namprd12.prod.outlook.com
 ([fe80::1a0c:e9e8:f3a5:d9d6]) by SA1PR12MB5614.namprd12.prod.outlook.com
 ([fe80::1a0c:e9e8:f3a5:d9d6%6]) with mapi id 15.21.0639.011; Wed, 25 Nov 2026
 21:36:00 +0000
Message-ID: <8ba27f45-a99d-4ff8-acd6-e4eae302591c@nvidia.com>
Date: Wed, 25 Nov 2026 13:35:58 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: Removing ->dirty_folio
To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, David Howells <dhowells@redhat.com>,
 Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
 <ao3y8TtEGjniZ_4f@casper.infradead.org> <20260826050733.GB15122@lst.de>
 <20261125085814.GA24887@lst.de>
 <woe7ui2vuwznrdt4zxynkbnte7r57juoaicwuk4hmwmlhq7lmp@no52geqttfyk>
 <20261125143206.GA15229@lst.de>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20261125143206.GA15229@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::13) To SA1PR12MB5614.namprd12.prod.outlook.com
 (2603:10b6:806:228::7)
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB5614:EE_|PH8PR12MB999295:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e2387fd-4dcc-4df1-0636-08df4b3c190c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|10067099003|56012099006|11063799006|261022075727099003|261026140227099003|261028144727099003|261026121527099003|261022105027099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DpqKynoHIJbOkFORdRMRzqmEYsQARv6izJGK89nb+ts7pHDnc3vjnp4rXGcQOlCCmWp6/iwnAfAHTFRAq94BH92iMwH7eYVNZopSXQBej0dyYZCzQGh1T+UNioyYgS9Oeg+5LsSz58RSETYNlhQrIS6H/wqOx260/DVPlLJT92hNbAsh+k9GbIg7a0eFJtdICqLxuP+LRpiAygeovJnp19Yaiem4Z134s2wbaRsINb/HEalnuboUr5THa9YrjOJoWiybDgDBvz2j8MLZLXake6Et1qOQSAfMhD73+YVYhZnL8VHOSIoO4zsNu3mrycZxKvGNwfEwX947PUEGuE7T4ypwu4UgpkP5ozzU9/e2NQ3QKeZUA6drjoVt/AA/ymaM3tfU4FuSuQ5LoVig/KKeAwlf1cJUnNbdhPCTTXrgDe1wsLWLzjF4ELtHgg4dFqHfH0YJasDrLht5PKInpPHpMPFZpEOwi0dkXIWBpWcUz4yRUqorGyA6ZBtuQalzjRCFIz8hUmPi8VcomXy1OJ9f6nV0CpzhbJXpXP5w1IKTLxsj3F2xpP/lCPWoKHNuFNvjiLGcmwiM3JsBXS8b2OJWNyUS8xl1joOqCBokuE5WMeExt8hSX/odd7YMOWMx+LbnSBjwcZZYmDbtieWY5DQKhXZx1bfCEHxmoMsOoyrYaaQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB5614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(10067099003)(56012099006)(11063799006)(261022075727099003)(261026140227099003)(261028144727099003)(261026121527099003)(261022105027099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWp3Vi9LTVJBSlJDZFpJa295KzZCalExYkdUTEVRcFRicyt0RGlJSDFDVTNs?=
 =?utf-8?B?alkxTVYzMERKUDZaN0Y3L1RQUkhCUjUvdWFXTFdSbCtzdWYrRGNrNmFhT1Nl?=
 =?utf-8?B?YmhMYXpWd1owZFlDYmpJTlJUdGVqRWhoRWltQVRteUhPVmZVT0FiV2xJZm5B?=
 =?utf-8?B?NXI0MW9RQVd1SXJTQ0RmdElaZVpoaWVLUXhWa09nSmJ2SmFTTUVaclR2R3hC?=
 =?utf-8?B?aHBBNDgrNUtUcDlBZ2ZITWFxODlhd0pOVEUwK3VUcU1Lak5Vd3FxK2dJRVBV?=
 =?utf-8?B?RlkwblVQaEZUNEpuV0kybWRYUlFRZktOR0tKUmszRHQwMlRLV1d6TGRhcHFK?=
 =?utf-8?B?eVJMQUg2a2lOUG5xR1Q1NVNGcHZvQzNlRDZmSFE3QXVDSUgySU16Z0FUc1Yv?=
 =?utf-8?B?bnBEZjZpUGJVZXJJUnROdFFFVm1Bczh1Rk00YW1tSFZPKzFUcHJ0L0tjVjhX?=
 =?utf-8?B?TEhBVm9XWjRldnJ1Tzl1MkszNmRId0xrbjFMVHlLUnc2OVRhNEFOWDZhU0px?=
 =?utf-8?B?UHM1RDF3ZEtzRVd6RUo1bHdJQ2MrWk1YYXkxTVhSdVRLbWEvaHlza01ESjJE?=
 =?utf-8?B?MzV0d0tITmRjZWJzTXZaa3dTZEF0VFdHM25ycTZVQ2N4MkFMdERUL3ZTRkUr?=
 =?utf-8?B?cTJzeWdmQjUxdXZXWGRmVHI3aW1Oa1N0bjM5UE9LOUl6VEpUYXJEak5xcWtJ?=
 =?utf-8?B?RlpxT0FOK21NNzlvbUZwd0VKQmlteDlXQVpNYUZ4S3FsdGRSVjZXZHBHY2Nt?=
 =?utf-8?B?YWZORVQ3bWkrNHQ2ZFozaEhhRmN3Z0lHK2ZGaU1WcXdwT09XK2FoemNVbmFu?=
 =?utf-8?B?M3hQYi9ZYXhubE1jeXFYN1pKTHQwd3dKRHZaOGRmb082ODdNaVU5ZUo3amNk?=
 =?utf-8?B?TVFINU5zbkU2YXdxUEtERUVPaW5MckZvdEJnUkFJQ09QUGdleStDd3JDQXM0?=
 =?utf-8?B?alBYby85bkNla3JwUU9ZeWtpUlBoVkFkbnRhZkVJbXJ4aFk3TnZhZDJOUW84?=
 =?utf-8?B?b1J3VUUzS1cxTkVRMTJBYzZvbVlrZThzVlprS3VOOVFjaDBQdXoxbHNCUGdn?=
 =?utf-8?B?bDU0OW1VRCtuMGoxTm9Dd3NUVHRQYUw3NmJCelVwUkFyZFpyaWcxdEtScXBt?=
 =?utf-8?B?ZG4zVEJmT2RaenVPQUthVW1zZHFDYnVrVVBjVTdkZ0lMSk1XckFTSUM2WjUz?=
 =?utf-8?B?eDlvMnlHRHdISnJKbGpmcjg3cCtGbHZ6c1l4SXljYW9tQ1Y2MVQ5RGwvTGwy?=
 =?utf-8?B?TUVkd21mcDZsMFZXemFzditLWFNPUDVGR2RJWlRmaTdQajMzZnNEckJ3Z3ov?=
 =?utf-8?B?RVlHdE5yMzk2QURwU1lsU3hLWEhWTnBjZGptK3ZPU1crMUc2Z24zUThoM1pP?=
 =?utf-8?B?aTJYS0FETHR4VFM0ZmVRb3RqeFh3cE4vL3BHbUljeERETWFiWTJoL2ZFYklQ?=
 =?utf-8?B?T29vM252RURkTE1OV1JqNGFPK1EzSnZKczhaQTFBZ2lzVlQzWldHaWZVZ1lQ?=
 =?utf-8?B?SHMrNldhRHJDeGVlWENMOE1pTDJoTjNXYkUvZ2czMEVJK3k2Sm5uR0RoRXBa?=
 =?utf-8?B?SzJ0b0JGY2xEUWd6Uk9zWXYvYm9XOFcrNWJPZllpdm92dDViOHJ1SUw5VTlQ?=
 =?utf-8?B?SzdOQURYeEV2N2FvbjdJcFkvNHVVeE5aUWlMeENVQkVURGxyalczUDdGK3NB?=
 =?utf-8?B?MzBHcFBSamJabUlOLzFSREg2MVpKWkx6OGxjMmNtOUlDQk85YUxPaFZSQzd1?=
 =?utf-8?B?d2tHVExqNTVyeWZKY2xldStQUlcyTkdUSWpNTU9uUGhRdGwyTS9YTFNPcVo5?=
 =?utf-8?B?N3pua0tHRzJZRVluanFwcFgzbk5LemVweHF2L2pJVjlKakxjMWlEbWhpUTJU?=
 =?utf-8?B?OTFnbnI0YVBreUxvYk4zT3dSeDZwenkzUEgxVXE3SlAxeUtPSmdCNVJ4NVdK?=
 =?utf-8?B?YXd6MUZyeU5RNFl5M0xydHIzS2I3dFU4eDlBOW4wUUYzSm1sNGJyR0JyTDd6?=
 =?utf-8?B?blV0YlhLdHBGQ0wzMlkzQVQyYlBtY29yRHhRYTVSQytndjNucTN5clgwaE1Y?=
 =?utf-8?B?UWNZSXJPZHV1T1Z5aGhqakM3TU5zQUFiMVZ0ZExzcDVycUZsRzBMajNnSU9R?=
 =?utf-8?B?SDQ5U0VzbTBad1F2TytaVmdmZHNmOGh0M0hwQm5nNXNteW5ycWJTOThReE5p?=
 =?utf-8?B?c2t6b3RzMjM4eXhtWGJNMHpDTnRCR0hmeUx2RDluZFdoVGtvaU54cXJSMnZN?=
 =?utf-8?B?RHNvV2E1VEdmdFRxTndYNTk2WVZGcEoxcVZwellvWHU1b1AzeHY5dmtkcTNz?=
 =?utf-8?B?ZWJyMFB5YjVLWTZtT09nUWM3NmczOWZCL243bzhLR3I2bXdqRkIrUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2387fd-4dcc-4df1-0636-08df4b3c190c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB5614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 21:36:00.1737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G/1a6ac9cJFNJfoLq0vQHG1eR58UoFdoMDlgicvgD7fSEgPr5Zims9I/Oqvd1AuUnvmmIDPLRuNcuVFyYRzQIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB999295

On 11/25/26 6:32 AM, Christoph Hellwig wrote:
> On Wed, Nov 25, 2026 at 11:15:40AM +0100, Jan Kara wrote:
>> I think we agree regarding the direction where this should be going :).
> 
> Well, that's good.
> 
>> Regarding the tracking of longterm pins, I remember when we started working
>> of the GUP / pin_user_pages() fixes, one of the ideas that we floated was
>> to take pinned pages off the LRU (they cannot be freed anyway) and use that
>> space in struct folio for the tracking we need. John? even had patches for
>> that but the performance overhead was too big (primarily due to LRU locks
>> contention) for direct IO. But for longterm pins, the additional overhead
>> of the setup could be acceptable and that would significantly increase our
>> maneuvering space in what we can do (because longterm pins are yet another
>> page refcount in the end).
> 
> Yes, additional significant overhead for plain FOLL_PIN would be bad.
> But for longterm pins it should not be an issue, as they should last
> long enough to amortize additional cost

Let me go dig that up. I seem to recall that one variation added an "if" branch
to put_page(), and there was a thudding sound followed by silence when I
posted it. haha :)


thanks,
-- 
John Hubbard

