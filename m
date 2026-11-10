Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283316;
	b=n+jJXixZ1LcegVvep/Uvg61SX42a5cim+ADIyrDHlJmREs16aLZfXWZM1gwA91JSycS0
	 oj6oHLgLxePRR3+pWpSDDs/Uv9UzCCdW8T9qzy5rYPAq/0hWEbbV+ss3vAXB5Psy2Gz4O
	 gvxEtmIt1zEq6W7muafo6pf0pz3zTYp5TI1BhKt8tcnIqX4YJLqz6txpkBDNDF/jkQ4Yu
	 XUcZVu3xWsbxxZppWCkovgnlgHOLPXsGcResbwpk+jEBvwM7Zhw04/T5d6Op3sRBfGccs
	 /dpPXZgJB64TiO/Uzn5/ZCYe2MiJD9q7yy7pGoh1l5tvqKsTEaDIVojA/INQiIJzzOQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283316;
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
	bh=DpwBuqBpG1+x7XRqVciGJZMO1KPuf8rSU+1dc5AqpBU=;
	b=exLuU+nwK/yO6w/1XJFmfAl2iag+zMw9QkXonGfYoHx7b6wYSQClJfJJS+3XzChonOvx
	 PCNsRcdL2LScNSo/qmdSiFyMpcgSL8cTlDAzyrVqDAp59q85E+HyvXWgul8F2OizuORWi
	 O5oJSJEiBZ0gSManagCpa0ZkDNjbxHVdH6f61gfg3hN4aoFqwfi2TBKS0yDafAERD+n92
	 qCFO976dR1hLWvucfJ6ADQUH3tTngNHvmTJ5pmoVMJ1agBwN1h4XAt2H/+uRpshpXuxfZ
	 +/8b6AtWYzOedVwbwg/0bkK692qZdLj6VyxW14MVdg+o86EdxxFWdn4CpQP8QWIgysw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XqWzWVCP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.51
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013051.outbound.protection.outlook.com [40.107.201.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBBC606A31C;
	Tue, 10 Nov 2026 04:01:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEBBC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XqWzWVCP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=svo1NI24Frx6USJ3MRCOB5+QttXzcrHzRUrp/rbKKW3DBC7dLTSQocyB36IXqmtPkbfVhLavkGtC0EumqxWX1QwwbS/5MbsUpMwFOKGRSpRxFYr1NHlR1rvnQn0GF5kupsYRhfnlAnuzFmvRYbA3t4xeesqwnq/CbgtA5JazZLRgz8KNls+sC17tFQb9rX+MKmJBNipCfZg0utgEdcS6BQfSkvGurV2wPqdvrrCUExIwfF0DquYJd6341waSqMUBSL1mTlkR1C9m4xrltgD8TYVBSiABkaKUbeXviY9IA7yfbgRdg9VyHoE5Gg43Y+vUrQ7fZVl4Vlrttk1Oi/u7gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpwBuqBpG1+x7XRqVciGJZMO1KPuf8rSU+1dc5AqpBU=;
 b=MRK41V7Rq+RCOvD5DjEtiLdVS3lJXH7WMNQVMsodbe+LD68XXwNhunq0a+X4vTnly5cmnIFZNgMlfzJHDS8AbHRkt6biOmJ5xPZoTzZ1071nWH8ZcMLjqG7VbrniEskPuQvu/PECsC2wYsebc9pkP0n94idn+/PaWTzHchMnrKsUm4vp8HPlqs/7VvRPqlhgFAF03WscwZCTA4eX1h7qANK8Cds3kG9etcZ8VH48SM3eiA6ZlUANqTEFT3NPNdZ/RiNH6/gpJGfOxkqLr6q8wPWxvrX8vOrkupxpSFHP5uhwc3buvP9eB9QE7GQCDy3VjrHXcQsGQ+tDtHELkXCFXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpwBuqBpG1+x7XRqVciGJZMO1KPuf8rSU+1dc5AqpBU=;
 b=XqWzWVCPVrrZy3wVeJttVVtNJWMDWcvWivun/wb7KD1PEUZgneJ/Fz5uphmCn+nFeeKr8zwtYEzMggEZNX4hZciFH/XC0WJWZ4khFXqADpnwZ46ssCmEqIRD7057UMqFWQrjQldVE0vllMZe4qvDpSJBe4ZeAsL6J1ha+t8o53zbfQyJZo8otI7u5z1Au5/3RhCg/DYr7u22gB6MNdzuTSP/YnvgmKQjAzakTDTbzjYuNaUeYOiCFUUQjeOk3ujfAZqNVYJr5i8auUGjyw4cRJoJcGPZNRt/feQn4n6GWMNzaUji529XicDnoiXZaPlXbfnJRRn2Fqvh793IIduGYg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB512574.namprd12.prod.outlook.com (2603:10b6:610:34d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 04:01:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 04:01:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Nov 2026 23:01:46 -0500
Message-Id: <DMR8CJLIMPDY.2NOHDSE107FBK@nvidia.com>
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
In-Reply-To: <20261110035205.3036-1-fangxy@xiaopeng.com>
X-ClientProxiedBy: YQBPR0101CA0259.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::20) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB512574:EE_
X-MS-Office365-Filtering-Correlation-Id: 78ca1ea0-e661-426f-d161-08df3edf57fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|18002099003|22082099003|6133799003|10067099003|11063799006|56012099006|5023799004|261028144727099003|261026140227099003|261102123227099003|261009223027099003|261026121527099003|261022115727099003|261022105027099003|261022075727099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	mXkyf8JlLutb0xUcfAhPWwiUu/lJZvqIoWXGMiI79QWQB5HJt+dtYzlxAaGd5DsEMw/m+xfOkZ6ip8KtVIs+gwdumtccmBuov/j/Q5VyhxxlO+g2bHqxHLFMunZdzx1pMwdQS7pVfO27K/KaDX4gLHhqb+wbdUcV80MPu21qDr0o+vAwvmFaCzbRXGz75czQl+GxVNPGe71keRvEFW4rJx4Ob9tSU1EGzNMkdoO12waKiKe1YnF7qVY0O9QnVKvAt8tK4r+1qE8F5gPFlnnVPdUbQdhebqOHa/IxMmp7Q0R/KEuaJkWE/Z6JM2vONxM7Pf1tE43K1oYsrNMOVwfgoSufo+yfSurbEURIOo9gF1BrraUjK6Ax4pVjdM5Zq8h+PZAF+fOjyZzPDSPQJDqEeygYXisAJjOUvL5jMyBPiW26++wg6baDldfGGXSwmEPgtjJ8OhkVEEz0zFiPrqVyai+BEKISB7u6E/T3dRlog2IjwKzdcaH2TQ1ACJW/ebzItE7GUSiGJKqtdAfr7uNpC+oaDtPLznXeSu3sQyRdSMzJRAS15YV5wF3Qh0+jVWGA2AYLCm3ixfT5aS4qT8bxHs+aspzByqQbs0c1x6Q+J48AuiTMvv8XRhXMuJdjPGEmUhl689Ir3LmbTHSlLqmg86EoC8rv4hlkX0OuTdN/FOU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(18002099003)(22082099003)(6133799003)(10067099003)(11063799006)(56012099006)(5023799004)(261028144727099003)(261026140227099003)(261102123227099003)(261009223027099003)(261026121527099003)(261022115727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWQ1NUxjc3E3OW0wemN4SnA4ZmhBc0JJcmZYMUkzL2lSZEwrOTBjdUNWUUVB?=
 =?utf-8?B?MU1BaysrdmRtcG55WlNmOG5DMFg3UzJodStwNzNERTdoZWpyY2VkN0ozOG9L?=
 =?utf-8?B?ZnhpT2tmUXJjUzREQWdXOFJ6T2tZL0NjcXZCNklZMzBBUmFUVDZIbngwbi8y?=
 =?utf-8?B?VjcrRFBXWlJlVHFtZEtkZy9CRTQ4M3dXOEY1VVRRWTBZandvQXlvZk5yUlV6?=
 =?utf-8?B?Q25MblpXa0RKSGZwdlVHOEtCR2laS3RCK2NMT3dPSDFFcEdHc2ZkcnBIRXFG?=
 =?utf-8?B?MXpXWGFsNWtSWGxqelhRaGZNRkt6Nm1odWtSQXcwOXhMZWkxMUNtbUU2NDdH?=
 =?utf-8?B?NGF4aDRrKzdVdHBUNUNRaERWTWlTQ2xZRHh0eFA5WnJtd3BkRHY3c0V4Umsr?=
 =?utf-8?B?NGRpY3E1VnNDTU9GOUdyaU1zYS9zSEQwVEgrWWtWTXc1YmQ0M0ZpdDNERTZM?=
 =?utf-8?B?Y3l5NEVnK2xQcWxzc0JVZWM4OHZCR05lSVplcGdLRURpUHIzdERKRHBScGlC?=
 =?utf-8?B?Ukc3NHpnclpURXdZZHROeE1iSE5JTU0wa2RIa2tJTjNka1JxaXdNMXd3Sk9R?=
 =?utf-8?B?R2xKVlhzQzF3czJDVTI3SFNkSDdyT3RBTEZxOElTTW40bmdTVzR2Z2duTG5J?=
 =?utf-8?B?YTNaZkRmbXNZQUJrUVBBNDdiUllaUzFhck1uMGt4NURjd1ltSGNWalFvVVZ0?=
 =?utf-8?B?ekc1VGIvM0orNGNEOUg4UStKOXp0NHhpYkIxRkg0UDI3dXdHbWV6NndqdWZE?=
 =?utf-8?B?WEo4RjVBTGhvYmcyaURpdCtUdmhjYXVRZDlWc2NNTXNVcTM0RjYvVWhCbzIv?=
 =?utf-8?B?NWtLajRUb0M2ZGxoNmx4dFRHWlpQLzIxbnpMK00xNmVrbUxiVW9GL1ZWN2Fk?=
 =?utf-8?B?c3ZGNmx6NVhsUXU1cDRNNENQUFRLbGo3d2RTY0Ryenh2SVQvWDBEWjNvcTlu?=
 =?utf-8?B?UTl4bEszeTlnUWpkRFZuVlA4VHowTWxXRERSVmdtclB6TlcwNjZOSXkvK1Ny?=
 =?utf-8?B?WXpqbU4zbG5lRlJXTHVEV1YrTk9URnkvajdpYXByUnQxSkg4RnlsOXcvZGZ4?=
 =?utf-8?B?dEl4T2NhMW5nckZYS2tzSzlpZHNNZ3dBYi9UVGVqOEM3R05yWXEycndqNzNy?=
 =?utf-8?B?WDE0NkRqa0RLQjVHNTc1RUpya3NEOHBJMWx1RGxwQWZrNFpvbnBGMU5VbFdq?=
 =?utf-8?B?VVNUaUJyNFRhVzdMTUt3M3B0dEJHYnlVTDB0YjBzbzRVc0tISTkwaEJ4VnZp?=
 =?utf-8?B?VVlLV3VTNStsNncvMmFIOGo5MC92THN1eFMvRDZlYlgxOGRUODZaVzJkVG5D?=
 =?utf-8?B?ckxsd1RDMHgzZmdxeDBOeStLV3lpem9JcjVSZlZYU0o3U0I0WWZ1Y1JBV3lw?=
 =?utf-8?B?V1dCY3J0M0hJcVF3ZmtaTmFjR3Rka2JzSVFDMmJXMGhKb1c0elVuL2ltSmtQ?=
 =?utf-8?B?cGhjYU5vUlVPZ1YzTW5iNWtIYXAydlRBOUtvb3gyUGgzdG5tTmlSeG1BMEtj?=
 =?utf-8?B?QWt1Q0lHRjdaQVlLNWh1VUxQVWVsWTZvMEE5QlNrK2pmeHJ3aThSTVU2b1dO?=
 =?utf-8?B?bFAzQXEvUCtzSXhTL2dXcmVCRE1tM1RZbGttakJBY3ZRWm5pRkp3YzlqVDVz?=
 =?utf-8?B?aEVqTy83L3ViVm04TmtWZ2NISWF1bTJ0dlVjTnhORkQ2c3BNeUdFNFBJYWJB?=
 =?utf-8?B?bEEzVU9WYjY2UmFwTmVOOG5MTEZyczNJNGs2K0hZaFMybmhBdEIzSDFWUVNt?=
 =?utf-8?B?OFZEMHpOSHhMQXp6SGpXWVpJeEJxT2p5cXBEQ09mTXdXekJhT0dUdU1CZklF?=
 =?utf-8?B?WWt1MkFCWmlIR1dZMWtTSDNIK3FXajVueDdpYVhkRGFPcTAzb0Z4NGo2MmEv?=
 =?utf-8?B?K0tnMDMxZ0xlNUZMTEhqSWhqWU5wUzBWQ1NGT3FzbVVCSU9YZGszaXhJWG1K?=
 =?utf-8?B?L1dDMk9jUGdUaWsyOWsrUTJMVENITnBQOFFub2M3UDNXZlVOMituVkdSb05H?=
 =?utf-8?B?bVlZOWREcGVaOEdlaGp5TzhNVHp0bGRHMU9GTjlrYXFaVEppdmhuMlByMHQ5?=
 =?utf-8?B?Z2VNc2R1ZGtVVGtlUm1sRWI5b20xVEVjR01ncXRuYnA2aTU0bUFjMTRKTjNu?=
 =?utf-8?B?L1JvL2NUbmorcVRTUXM4TVdhVzhnUWdkSS9xbzRiZ0RwNUI4bStJVXAxT2dB?=
 =?utf-8?B?L081K0Iwa2l0ZHovL2U2V2hUWTg2Ynl3T0diQU9HK0xnN3hFZ2ZGaC96dE9X?=
 =?utf-8?B?cmNQam10cTlnSFgxaW5qSUNxS2Q4OEYwa1lOcWZ4V21nWXFsYmJZZ3J2dE05?=
 =?utf-8?Q?qRLh6goOEOco3mS57Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ca1ea0-e661-426f-d161-08df3edf57fb
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 04:01:48.6322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8nqe2S/sBb17EzOzs2ii1TPCO4Bm6XvLWzf0NgJS1Fnp5jm+F/prUrLzVxJkB1zv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB512574

+Pankaj, since he was working on this[1].

[1] https://lore.kernel.org/all/20251206030858.1418814-1-p.raghav@samsung.c=
om/

On Mon Nov 9, 2026 at 10:52 PM EST, Fang Xieyan wrote:
> This series makes filesystem page-cache large folios work on kernels
> built with CONFIG_TRANSPARENT_HUGEPAGE=3Dn, and keeps them splittable
> there.
>
> 1. Why this is needed
>
> TRANSPARENT_HUGEPAGE depends on !PREEMPT_RT (mm/Kconfig), so a
> PREEMPT_RT kernel always has THP off.  Today that also removes
> file-backed large folios entirely: the helpers that split them live in
> mm/huge_memory.c under CONFIG_TRANSPARENT_HUGEPAGE, and the order
> accessors in include/linux/pagemap.h short-circuit to "no large
> folios" when THP is off, so every filesystem that opts in silently
> ends up with order-0 folios.
>
> The consequence is not only throughput.  XFS allows block sizes up to
> 64K and fs/xfs/xfs_super.c refuses to mount anything larger than
> mapping_max_folio_size_supported().  With THP=3Dn that helper reports
> PAGE_SIZE, so a 64K-block filesystem cannot be mounted at all:
>
>     XFS (vda): block size (65536 bytes) not supported; Only block size (4=
096) or less is supported
>
> There is no degraded mode to fall back to, because a block has to fit
> in a single page-cache folio - which is why
> fs/xfs/libxfs/xfs_ialloc.c derives min_folio_order from
> sb_blocklog - PAGE_SHIFT.  Either page-cache large folios work without
> THP, or the filesystem is unusable.
>
> 2. What the series does
>
> The anon and file split helpers were already separated by Kairui
> Song's "mm/huge_memory: clean up and decouple the anon and file split
> helpers" (v6 04/17, in mm-unstable); that is the base this series
> starts from.
>
> 1/3 moves the folio-splitting implementation out of mm/huge_memory.c
> into mm/folio_split.c without changing any behaviour.  The new object
> is still built by CONFIG_TRANSPARENT_HUGEPAGE, so a THP build keeps
> exactly the code it had before; a pure move is also the easiest thing
> to rebase on top of further churn in this area.
>
> 2/3 builds that object for CONFIG_LARGE_FOLIO instead, and drops the
> anon, PMD and khugepaged dependencies a file-only build cannot have.
> The symbol comes from Matthew Wilcox's "[PATCH v9 12/15]"; if that
> series is in first, this patch shrinks to its Kconfig default and the
> accessors it already rewrites.
>
> 3/3 enables filesystem page-cache large folios when THP is off.  It
> lifts the compile-time short circuits in pagemap.h for
> mapping_max_folio_size_supported(), mapping_set_folio_order_range(),
> mapping_max_folio_order() and mapping_min_folio_order().
> PREFERRED_MAX_PAGECACHE_ORDER is left alone: an LF-only build keeps
> the existing cap of order 8 instead of following HPAGE_PMD_ORDER.
> Without THP such folios cannot be PMD-mapped, so raising the ceiling
> would mainly increase the maximum page-cache allocation size.  The
> changelog has the arm64 64K-page arithmetic, which is a calculation
> and not a measurement.
>
> The split side is not rewritten: truncate, migration and memory-failure
> already call the helpers outside any THP ifdef, so with 2/3 in place
> they simply stop resolving to the -EINVAL stubs once 3/3 turns
> allocation on.  madvise is inside a THP ifdef and does not take part.
>
> 3/3 also makes the XFS mount failure above say why it failed: when
> CONFIG_LARGE_FOLIO is not set, the warning now names the missing
> option instead of only reporting the block size as unsupported.  With
> LF=3Dy the added warning is compiled out completely.
>
> 3. Testing
>
> Six configurations build clean as full kernels, bzImage and the
> vmlinux link included, with no new warnings: A (THP=3Dy), B (THP=3Dn,
> LF=3Dy), C (B plus HUGETLBFS), D (THP=3Dn, LF=3Dn), and RT-B and RT-C wit=
h
> PREEMPT_RT=3Dy.  The PREEMPT_RT configurations were build-tested only.
> No runtime PREEMPT_RT stress test or livelock validation was
> performed.
>
> THP=3Dy is unchanged: the .text sections of mm/filemap.o,
> mm/readahead.o and mm/shmem.o are byte-identical before and after the
> series (md5 equal, 45896, 7139 and 35314 bytes).  With THP=3Dn and LF=3Dn
> mm/filemap.o and mm/readahead.o stay identical (44584 and 6259 bytes)
> and every function in mm/shmem.o keeps its size; the only difference
> there is one dead argument load that the folded-out
> mapping_set_large_folios() call leaves behind, so the section keeps
> its 29778 bytes while its md5 does not match.
>
> In the new LF=3Dy, THP=3Dn configuration mm/shmem.o keeps its size as wel=
l,
> 48 bytes shorter at 29730.  That difference is not from 3/3: 40 of the
> bytes are shmem_writeout(), which shrinks because 2/3 turns
> split_folio_to_list() from an inline -EINVAL stub into a real call, and
> the other 8 are the padding in front of the following function; the
> same 29730 bytes appear with 2/3 alone, and 3/3's own shmem hunk
> changes no function size.  The new call is unreachable in this
> configuration anyway, since shmem_alloc_and_add_folio() still forces
> order 0 without THP.
>
> Where the generated code really changes is the allocation policy:
> mm/readahead.o grows by 880 bytes of .text (6259 to 7139) and
> mm/filemap.o by 134 (44584 to 44718).  nm -u mm/folio_split.o lists no
> anon, pmd or khugepaged symbols.
>
> Runtime, x86_64, 4K pages, THP=3Dn, QEMU/KVM, on a 64K-block XFS image
> (mkfs.xfs -b size=3D64k -s size=3D4k), with kprobes on
> filemap_alloc_folio, filemap_add_folio and __folio_split:
>
>   - writing 64M: 84 allocations - 59 at order-8, 5 at order-7, 5 at
>     order-6, 5 at order-5, 10 at order-4, i.e. exactly 64M;
>   - reading the same 64M back after drop_caches: 72 allocations,
>     62 at order-8, 1 at order-7, 5 at order-6, 4 at order-4;
>   - truncating 1M to 700K: one __folio_split, landing at order-4,
>     which is the min_folio_order XFS asked for; order-0 never appears
>     in any of the three phases;
>   - tmpfs writing 32M: 8192 shmem_alloc_folio calls, all order-0;
>   - shmem write vs F_SEAL_GROW, reproducible as: memfd_create(),
>     ftruncate() to exactly 4096 bytes, F_ADD_SEALS with F_SEAL_GROW,
>     then a single pwrite() of 8192 bytes at offset 0, comparing the
>     syscall's return value.  It returns 4096, the same as the
>     pre-series THP=3Dn kernel.  A THP=3Dy kernel returns -EPERM here, and
>     so did the LF-only build before shmem's mapping was put back
>     behind THP; that -EPERM is pre-existing behaviour of THP kernels,
>     this series neither introduces it nor extends it to other
>     configurations.
>
> Same image on the pre-series kernel, for reference: it fails to mount
> with -ENOSYS before any of the above can run.  The whole probe was
> re-run on the final revision of the series with identical numbers.
>
> 4. What this turns on for existing filesystems
>
> LF=3Dy makes the existing opt-in take effect for every filesystem that
> already asks for large folios, and that list is not ext4 only: ext4,
> xfs, btrfs, f2fs, fuse, afs, erofs, nfs, cifs and zonefs all call
> mapping_set_folio_order_range() or mapping_set_large_folios() from
> their inode or superblock setup, unconditionally, today.  Those paths
> run on any THP=3Dy kernel; the new configuration is only THP=3Dn with
> LF=3Dy.  With THP off the ceiling is PREFERRED_MAX_PAGECACHE_ORDER,
> which stays at order 8.
>
> On the tested 4K-page configuration, 4K-block ext4 gets min order 0
> and max order 8, while 64K-block XFS gets min order 4.  Btrfs derives
> both ends from the mkfs sectorsize and nodesize.  A THP=3Dy kernel keeps
> the order-9 ceiling (HPAGE_PMD_ORDER) it has today on 4K pages.
>
> shmem keeps its THP dependency: its mapping is only marked large-folio
> capable when THP is enabled, because shmem_alloc_and_add_folio() still
> forces orders to zero without it.  This matters beyond cosmetics.
> generic_perform_write() sizes its write chunk from
> mapping_max_folio_size() and passes that length to ->write_begin()
> before clamping it to folio_size(), and shmem_write_begin() rejects
> pos + len > i_size for F_SEAL_GROW.  On a 4K memfd sealed with
> F_SEAL_GROW, an 8K write at offset 0 returns 4096 on the pre-series
> THP=3Dn kernel and -EPERM on a THP=3Dy kernel; advertising order 8 while
> allocating order 0 reproduced the -EPERM on an LF-only build.  Tying
> shmem's policy to LARGE_FOLIO means the allocation, swap and split
> sides together, which is a separate series.
>
> 5. What is not covered
>
> Since PREEMPT_RT is the motivation, the RT side needs to be explicit.
> The freeze-to-xarray-update window in __folio_freeze_split_file() is
> the fourth freeze site named by Matthew Wilcox in the RT livelock
> thread started by Dong Hui
> (<c2ff0c66422c4e2d869499a1186ff0ae@xiaomi.com>):
>
>     There's also __folio_freeze_split_file().  I know PREEMPT_RT
>     disables TRANSPARENT_HUGEPAGE at the moment, but hopefully that
>     restriction will be lifted.
>
> This series does not fix that problem and does not claim to be
> RT-safe.  It only makes a code path that already exists on THP kernels
> reachable in a configuration that has no THP, which is the same
> exposure Kairui described in 06/17 as "should be fixed generically".
> One detail that may matter if a reader-side fix is chosen: the
> function already holds the xarray lock until the folio is no longer
> frozen and visible, since folio_ref_unfreeze() happens before
> xas_unlock_irq(), so a generic fix of that shape would cover this path
> without touching it.
>
> Also not tested here: the migration, memory-failure and madvise split
> entries at runtime (only truncate was exercised end to end), arm64
> with 64K pages, nommu, KASAN and lockdep, xfstests, and the btrfs
> order range.
>
> 6. Questions
>
> (a) Non-THP split accounting.  count_mthp_stat() is a no-op without
> THP, so in an LF-only build a file split updates no counter at all and
> THP_SPLIT_PAGE does not even appear in /proc/vmstat.  I have a
> follow-up patch that gives the file path its own counter.  Would you
> rather see a new vmstat item, an existing one reused, or nothing?
>
> (b) Should XFS select LARGE_FOLIO itself?  Three lines of
> "select LARGE_FOLIO if MMU" in fs/xfs/Kconfig make 64K-block XFS
> mountable on a THP=3Dn kernel with no manual configuration; I built such
> a kernel and mounted the 64K image.  The cost is mm/folio_split.o: 3.2K
> of .text in a THP=3Dn build, code that every THP=3Dy build already carrie=
s,
> paid also by XFS builds that will never use a block size above the page
> size.  Kconfig cannot express "only when a 64K filesystem is mounted".
> I left it out because it changes default coverage for a decision XFS
> maintainers should make, but I can add it as 4/4 if that is preferred.
>
> Comments welcome.
>
> Fang Xieyan (3):
>   mm: move folio split code into mm/folio_split.c
>   mm: build file-backed folio splitting with CONFIG_LARGE_FOLIO
>   mm: enable filesystem page-cache large folios without THP
>
>  MAINTAINERS                |   1 +
>  fs/xfs/xfs_super.c         |   2 +
>  include/linux/huge_mm.h    |  60 ++-
>  include/linux/page-flags.h |   5 +-
>  include/linux/pagemap.h    |  17 +-
>  mm/Kconfig                 |  19 +
>  mm/Makefile                |   1 +
>  mm/folio_split.c           | 969 +++++++++++++++++++++++++++++++++++++
>  mm/huge_memory.c           | 920 -----------------------------------
>  mm/internal.h              |   1 +
>  mm/shmem.c                 |  11 +-
>  11 files changed, 1054 insertions(+), 952 deletions(-)
>  create mode 100644 mm/folio_split.c
>
>
> base-commit: b024a51b0184b1efb6f55b11aaf7b15a490a6307




--=20
Best Regards,
Yan, Zi

