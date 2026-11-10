Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283887;
	b=umIDejMxCUS3yucbxCxSzE7ZA1mnFnhiiOv03mAJee4WuimJl6Fsm0N0jixcv2QrHKc9
	 G8XOJNLIJKCP1G/uknEE8QXktqXo9MMMIz14TkY3R25hC4geGXzUFQg5Wv0VkFfdXTs1b
	 ZWw4Cti/q84BHpepIMUM+NHQ6l6tYa2+zMI2PM67mBCnvUyfOHiAri1RLkhH6fC6s4Mcm
	 19jzEoHW7pNqtEo6JJHSLNXO+msWxn9xgiAQfoDk37dn+g5gvHVbpwtXYO78vMQkDTRcB
	 I2dIS2N2q1Gj+7blrcoIdra5r6PWbZ/LqO3tPbOpcbQhSXY3VKl7696lf/fQZGOqVcQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283887;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:X-Mailer:Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-MS-Reactions:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=34BtucXwpnOmuiVglCMZ1DyBUj42ze1oXVNlbgB+R1A=;
	b=FYsb4om74A89XqyM0TFXjGUUOZ+86RXL7hE+YUWoKIomUBiYpgeX9v6o3ooUd+NbJbIE
	 hTqGBBolCfEDYS3MdRfN7ttU4HUaDLiBrC1sBBWp5gpTvwZ8jC9hHuDqGKI+HdThJFcYr
	 jTgff22hDTdD7wuM2l91IxVLzyBRN1olk8xk6+TiSatWWO3c60kpQXDvLigbFA8WTLgoz
	 FaTnG0bORqDhqyMkSj8ZrkWORyEW6vqlMoedSpJEpJtbe5e7vnIqC9JdrhOloZpTtzFgO
	 GNAFGgU+3nr3gOkeFsuhj8TBkSQaUwc223Y+OyoW9r7EgHvPDXnyjo2ZZEkIODWNb3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tPVseIha;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.58
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013058.outbound.protection.outlook.com [40.93.201.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9D7606AA00;
	Tue, 10 Nov 2026 04:11:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC9D7606AA00
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tPVseIha
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+rhYKFaNxAxSyam0c0mfAOpA+l34/iu39yt4XsFlGP5mXFQhjQGfdJrSHLR041R84FHO61+dHV9g6w/9wcwJMk7P3y7tbqs3+FslvoE7roEldDvUm/GitKQXNueGFdTRtqf/MUBYcKGR1Al44rYSfEa1o2O4TTUCt3AAtwinF5o06778uTbwGXIuMwAzyiMh4KiC8nZ11yY8EVWLXEQ7p6Lmc+xUaA2D2Kz748IEwG9aCng59km40GGfSdXHRQir/Dg4pnsWnReCdkCkDos19mcqrT/rRIUP51QAiGaPmq4XLZwNY5ZGiUazG0uguastR4panqOTg+kkoNNF3JCHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34BtucXwpnOmuiVglCMZ1DyBUj42ze1oXVNlbgB+R1A=;
 b=HLFvaTygQpKDhtLoa3Aa8u1xUwG3zOk//kjvGwf7/IOv7LAMzdyXua//J2dfyfLGp7BMygbVzTlhHP8Ub1wrSgWHd0fwH8+lGAl0JXD05q8CTYsJ3mgh3/DmK6H+zvaxS+TgBFoyuTOQBrmWBnJshSFBcP99ULW8ErlTLtGQIxQ3SkMIcvd+MNqvzLHDHwc6svDGq84Nx3Pi0OeweVyLLWz5yRbOcvzRm6eIzF+JEn8LGTQzThp9zozWnHg/ozUatDywaKtiZhENWvskPfR/MEVf7UXjf9qS7Nj2o6SJXH20H69I50kdxOdvn8szexUmWA6+TO8DiA3oJgVgzdLDtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34BtucXwpnOmuiVglCMZ1DyBUj42ze1oXVNlbgB+R1A=;
 b=tPVseIhabvMODKh3UL0VNUSWj0GXkwFVs9b+m/fvjMKPPIPUlOGeTI/9y7BK/eOn1byJGtQNSRkJXjWAUDgz5NreGU8EploMB5mnak94idiTVYxgr5srRvgCaa4yRE3SskGpME5If0e6z//YTiZwmj1pjrOyyodGc/AxnUYVJymfDJSYml1P2fiOXTeYsIGuDeqU4zQKnCV3Ja6SVnqrH2h0gDVHdf4fmbutg8jcnlj0QKOy06+AFbG0QksobmdnXdjMiI2+Cp6P63kjo8LqFoFUIgCKlXB9/oxUyqtwDubfK1xJWkpZyoqYcuwp6IjtUj15Bd0g88LQtmASMRz/lg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB7979.namprd12.prod.outlook.com (2603:10b6:806:32a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 10 Nov
 2026 04:11:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 04:11:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Fang Xieyan <fangxy@xiaopeng.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>,
 Carlos Maiolino <cem@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>,
 Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Kairui Song <kasong@tencent.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] mm: enable filesystem page-cache large folios
 without THP
Date: Mon, 09 Nov 2026 23:11:16 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <FB183619-34C4-4B9E-9BFD-D5F9233E9C13@nvidia.com>
In-Reply-To: <DMR8IXC61XST.3GFDCM6FZ5OCM@nvidia.com>
References: <20261110035205.3036-1-fangxy@xiaopeng.com>
 <DMR8CJLIMPDY.2NOHDSE107FBK@nvidia.com>
 <DMR8IXC61XST.3GFDCM6FZ5OCM@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:208:23b::19) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB7979:EE_
X-MS-Office365-Filtering-Correlation-Id: a0a40570-bb9d-4e4b-688b-08df3ee0abb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|22082099003|18002099003|6133799003|10067099003|4143699003|261028144727099003|11063799006|5023799004|261102123227099003|261021121427099003|261022075727099003|261022115727099003|261026140227099003|261021123027099003|261026121527099003|261022105027099003|261009223027099003|56012099006|260925021311599003|260925021911599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	cJ3dKuWfAzGZcQfTyq00ebDIo93PtbsODBXT5uuDFHHcrP7WeGeJjMFzie66LE+gvyxgbCGmHIn64vqrb8eJeoqxRabVZtDx2pHu4xFT14ObqNdIN0KWD/KnXADfxBcXYawdo7JFxEYbjv39DFN03GTb7OYw1A10tuajna5ZrJg5uD0qNGcOmxe5ByJXbqnskYp0hxmUsxjha9MiaebJkGDt5kNszCA3L5KSRIEMQIZkNwtFtCaV9Mk0jd6/ZAszKQcvapKlSP18h6SBA/fQklRuQ4DTrIUtJTn0v6/Fw5mKzELqW08+uauyfs/hjWnFIaCXVoGXeidhQPXRzl40o8J/waOQOvrNX6sEBHIOnkSMTek4/stQlTem+WZ1QEVNsYsjFkUxjpNe8o5iCQWObt3sr+s8mBZOFyiQ4GqDpIQESzMzdFMV4H7jres0r97cqJfCny1bnX1vo8HIL75UxNUXicBMj5kSNWnXwbtg7FLvbeiuQBaOWp7f3l38BlvBwZbxzUopRtaBInMH3AbguweOR0wR/bDTG/YoXvUCK4kfEsEd0b0uL68Bz5g31PUzS38DnYUDv++f5LOgt+G6Chrg0aqTy6OUvC/Lnyefwkwvi7pZ53HwjRKvlu5P4Rgb/+OJYa2rWnRECtKy3x9gSZk8hrJ+v74EQ0oPLPKf7oU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(6133799003)(10067099003)(4143699003)(261028144727099003)(11063799006)(5023799004)(261102123227099003)(261021121427099003)(261022075727099003)(261022115727099003)(261026140227099003)(261021123027099003)(261026121527099003)(261022105027099003)(261009223027099003)(56012099006)(260925021311599003)(260925021911599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lj7hY/IK4YPH2oamC2oPWts1SVn8ylwy36gRoRT73U5WlWA9l9CxdgRXFGst?=
 =?us-ascii?Q?IBM9/p6JdBz3SlC8WLW6JwyQoqg+8Z9F2xGx2LgseUca1gtqdzUUBkR1iFrA?=
 =?us-ascii?Q?22OLy40UvGo6mNx+4IQV16Kt4lCcaQjoWagDuchPlU6jFw+XfeYhA+EmInmi?=
 =?us-ascii?Q?yEsAu5ZhNOrvAkQo9ZSkHDjGLE27kE+o1bE9aggzOT25wzIs5bmIeBP+dr+w?=
 =?us-ascii?Q?bZrfeF2be/gddWv+N3TOTBd3NPX6IeXS7yYV+KpcIbqS2KsfchL0G++EIxb0?=
 =?us-ascii?Q?iHMrDkJ95rdXXlYMF3BvO8Cjnxk0uERC+2GoTZz5d4NBNaeer2gIsdIfGFMr?=
 =?us-ascii?Q?S5Z0vYUHDv65BgHZUNqflq0CW9agsvH62eSOAMUZLOpDHhemLIri0KmFofKk?=
 =?us-ascii?Q?2Ln72/HeYiLDJM20WzsYw9V79I/bYmrEoUdlmCFpW+CpfYVQ8oeTg276ODyQ?=
 =?us-ascii?Q?RjKTdro02tmGVOgagyrqL9k6nMzukKRZ+pz2xnDraYclss3OSSrMrpoZMnar?=
 =?us-ascii?Q?QViSPUpI65E8Ln8wSZjDtPaRlHFm2+3MB/kH5aoodMeGl0xJUoc+lGXzccHG?=
 =?us-ascii?Q?aTwJMhCS34DEqltarZc8rip5zh5GRmk4BtgWEjrft8i2yTyxCdixO+RfYowD?=
 =?us-ascii?Q?hH3JcdF/fTNLuNtf23YNMRkW+9RRtFxqG4NzbElbvFtx8OUbW+4pbcMY8NtF?=
 =?us-ascii?Q?dCZ0NF0MVGqEhPcE6StgyssII/e4n/2iTt5aD6ZkWxyp1OnN0agf2JLUQw+L?=
 =?us-ascii?Q?sl9q2g71Oc3Cr1UlfMcKyxNl6aT9dYadvZr42ZPwK2Mas+4Tb0SIvQRZuarh?=
 =?us-ascii?Q?RhLYq/WAjXm++WHFc5yvsdcr4bg+NHNI624XfYFVNbqBCb5SEoRWkWnQMrjv?=
 =?us-ascii?Q?eW0sNUg64ho6T04YZURe36BSM0YgbPGnQCHmqI/HrJcuDi7l7Cfg1kIq6lrH?=
 =?us-ascii?Q?FXAoO6mktL5jCZLqzreVdcQwvy/Tl+zZeXm8IsNgj2JjC2OXtsLQgJBMksyk?=
 =?us-ascii?Q?Ew/isytp7UyezmM5JrETW3BU8qAvuVh7aWVtKmj6nha3fYzkcrp8r8dcxZuy?=
 =?us-ascii?Q?Mik+9DO0eOwaOjKwkE5x6EckfmMAZNAv4lmc7WatzBNJjd2zdhGWMcTZCC8N?=
 =?us-ascii?Q?2cTFIirql8EI18y0uLAxJX1+c5aSYb5NxeE7EdIlWKtn1jDS7GIYhcyVFc/E?=
 =?us-ascii?Q?W/z4Zxe0esNICnP0hCKY21wD4RHpGsPqeIxJMipsAsXKKw/+rX2C4zwP+N5b?=
 =?us-ascii?Q?AXYGHawxdj2U/zNIaMG5iuXZ7//ChSlSwszFCwQGhI4ivT8P0g20gIb/mhFt?=
 =?us-ascii?Q?9rA077SEkxiFOZUrqnCo3YZLEPTVL6iKL1TAvaGUiBeuQnjdWUlW9ZV5zjEt?=
 =?us-ascii?Q?aLm+N2dWXxCQKKHAmZnIgklUc0Do/xofOzTwccuJXQ4yviCICvg0OgYSrCMW?=
 =?us-ascii?Q?mGaOcV4FW+B+lkInZ4+uEtAJNYmDmvbGc4Lbi2pHzN9vle8RCdHXx2lRdbCz?=
 =?us-ascii?Q?l5Z5wnz6gla9q4JCyIX+Rieaqo9VPKf3rTuZF8nGpkvTYwY+eWg1ecWEPWr2?=
 =?us-ascii?Q?Lq96/IH4aX+uABwPZ2f7Tuap1Sc7cBzYKOL9KXE1Rb58pCuE+8HO5nKzplAX?=
 =?us-ascii?Q?uAyoCvw7XCRAL1WJxVFhQt4Oft+ybz9PfR52ux6+Ph9Y/RvXNAc+bUOuxnlt?=
 =?us-ascii?Q?LiCLZkAQlNMuEI5VeLlpKgZ2u1b5xstvX6ZAIm/73j+iQkew?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a40570-bb9d-4e4b-688b-08df3ee0abb1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 04:11:18.4978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGYMKyhLrtnfGkm7dkSJRLvkpPoi7YIv83pEJjPV1MEta2BEucDtqqjk4YEH8fJH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7979

+Luiz for real, sorry for the fat fingers.

On 9 Nov 2026, at 23:10, Zi Yan wrote:

> +Luiz, since he is working on "mm: thp: always enable mTHP support"[2].=

>
> [2] https://lore.kernel.org/all/cover.1789695931.git.luizcap@redhat.com=
/
>
> On Mon Nov 9, 2026 at 11:01 PM EST, Zi Yan wrote:
>> +Pankaj, since he was working on this[1].
>>
>> [1] https://lore.kernel.org/all/20251206030858.1418814-1-p.raghav@sams=
ung.com/
>>
>> On Mon Nov 9, 2026 at 10:52 PM EST, Fang Xieyan wrote:
>>> This series makes filesystem page-cache large folios work on kernels
>>> built with CONFIG_TRANSPARENT_HUGEPAGE=3Dn, and keeps them splittable=

>>> there.
>>>
>>> 1. Why this is needed
>>>
>>> TRANSPARENT_HUGEPAGE depends on !PREEMPT_RT (mm/Kconfig), so a
>>> PREEMPT_RT kernel always has THP off.  Today that also removes
>>> file-backed large folios entirely: the helpers that split them live i=
n
>>> mm/huge_memory.c under CONFIG_TRANSPARENT_HUGEPAGE, and the order
>>> accessors in include/linux/pagemap.h short-circuit to "no large
>>> folios" when THP is off, so every filesystem that opts in silently
>>> ends up with order-0 folios.
>>>
>>> The consequence is not only throughput.  XFS allows block sizes up to=

>>> 64K and fs/xfs/xfs_super.c refuses to mount anything larger than
>>> mapping_max_folio_size_supported().  With THP=3Dn that helper reports=

>>> PAGE_SIZE, so a 64K-block filesystem cannot be mounted at all:
>>>
>>>     XFS (vda): block size (65536 bytes) not supported; Only block siz=
e (4096) or less is supported
>>>
>>> There is no degraded mode to fall back to, because a block has to fit=

>>> in a single page-cache folio - which is why
>>> fs/xfs/libxfs/xfs_ialloc.c derives min_folio_order from
>>> sb_blocklog - PAGE_SHIFT.  Either page-cache large folios work withou=
t
>>> THP, or the filesystem is unusable.
>>>
>>> 2. What the series does
>>>
>>> The anon and file split helpers were already separated by Kairui
>>> Song's "mm/huge_memory: clean up and decouple the anon and file split=

>>> helpers" (v6 04/17, in mm-unstable); that is the base this series
>>> starts from.
>>>
>>> 1/3 moves the folio-splitting implementation out of mm/huge_memory.c
>>> into mm/folio_split.c without changing any behaviour.  The new object=

>>> is still built by CONFIG_TRANSPARENT_HUGEPAGE, so a THP build keeps
>>> exactly the code it had before; a pure move is also the easiest thing=

>>> to rebase on top of further churn in this area.
>>>
>>> 2/3 builds that object for CONFIG_LARGE_FOLIO instead, and drops the
>>> anon, PMD and khugepaged dependencies a file-only build cannot have.
>>> The symbol comes from Matthew Wilcox's "[PATCH v9 12/15]"; if that
>>> series is in first, this patch shrinks to its Kconfig default and the=

>>> accessors it already rewrites.
>>>
>>> 3/3 enables filesystem page-cache large folios when THP is off.  It
>>> lifts the compile-time short circuits in pagemap.h for
>>> mapping_max_folio_size_supported(), mapping_set_folio_order_range(),
>>> mapping_max_folio_order() and mapping_min_folio_order().
>>> PREFERRED_MAX_PAGECACHE_ORDER is left alone: an LF-only build keeps
>>> the existing cap of order 8 instead of following HPAGE_PMD_ORDER.
>>> Without THP such folios cannot be PMD-mapped, so raising the ceiling
>>> would mainly increase the maximum page-cache allocation size.  The
>>> changelog has the arm64 64K-page arithmetic, which is a calculation
>>> and not a measurement.
>>>
>>> The split side is not rewritten: truncate, migration and memory-failu=
re
>>> already call the helpers outside any THP ifdef, so with 2/3 in place
>>> they simply stop resolving to the -EINVAL stubs once 3/3 turns
>>> allocation on.  madvise is inside a THP ifdef and does not take part.=

>>>
>>> 3/3 also makes the XFS mount failure above say why it failed: when
>>> CONFIG_LARGE_FOLIO is not set, the warning now names the missing
>>> option instead of only reporting the block size as unsupported.  With=

>>> LF=3Dy the added warning is compiled out completely.
>>>
>>> 3. Testing
>>>
>>> Six configurations build clean as full kernels, bzImage and the
>>> vmlinux link included, with no new warnings: A (THP=3Dy), B (THP=3Dn,=

>>> LF=3Dy), C (B plus HUGETLBFS), D (THP=3Dn, LF=3Dn), and RT-B and RT-C=
 with
>>> PREEMPT_RT=3Dy.  The PREEMPT_RT configurations were build-tested only=
=2E
>>> No runtime PREEMPT_RT stress test or livelock validation was
>>> performed.
>>>
>>> THP=3Dy is unchanged: the .text sections of mm/filemap.o,
>>> mm/readahead.o and mm/shmem.o are byte-identical before and after the=

>>> series (md5 equal, 45896, 7139 and 35314 bytes).  With THP=3Dn and LF=
=3Dn
>>> mm/filemap.o and mm/readahead.o stay identical (44584 and 6259 bytes)=

>>> and every function in mm/shmem.o keeps its size; the only difference
>>> there is one dead argument load that the folded-out
>>> mapping_set_large_folios() call leaves behind, so the section keeps
>>> its 29778 bytes while its md5 does not match.
>>>
>>> In the new LF=3Dy, THP=3Dn configuration mm/shmem.o keeps its size as=
 well,
>>> 48 bytes shorter at 29730.  That difference is not from 3/3: 40 of th=
e
>>> bytes are shmem_writeout(), which shrinks because 2/3 turns
>>> split_folio_to_list() from an inline -EINVAL stub into a real call, a=
nd
>>> the other 8 are the padding in front of the following function; the
>>> same 29730 bytes appear with 2/3 alone, and 3/3's own shmem hunk
>>> changes no function size.  The new call is unreachable in this
>>> configuration anyway, since shmem_alloc_and_add_folio() still forces
>>> order 0 without THP.
>>>
>>> Where the generated code really changes is the allocation policy:
>>> mm/readahead.o grows by 880 bytes of .text (6259 to 7139) and
>>> mm/filemap.o by 134 (44584 to 44718).  nm -u mm/folio_split.o lists n=
o
>>> anon, pmd or khugepaged symbols.
>>>
>>> Runtime, x86_64, 4K pages, THP=3Dn, QEMU/KVM, on a 64K-block XFS imag=
e
>>> (mkfs.xfs -b size=3D64k -s size=3D4k), with kprobes on
>>> filemap_alloc_folio, filemap_add_folio and __folio_split:
>>>
>>>   - writing 64M: 84 allocations - 59 at order-8, 5 at order-7, 5 at
>>>     order-6, 5 at order-5, 10 at order-4, i.e. exactly 64M;
>>>   - reading the same 64M back after drop_caches: 72 allocations,
>>>     62 at order-8, 1 at order-7, 5 at order-6, 4 at order-4;
>>>   - truncating 1M to 700K: one __folio_split, landing at order-4,
>>>     which is the min_folio_order XFS asked for; order-0 never appears=

>>>     in any of the three phases;
>>>   - tmpfs writing 32M: 8192 shmem_alloc_folio calls, all order-0;
>>>   - shmem write vs F_SEAL_GROW, reproducible as: memfd_create(),
>>>     ftruncate() to exactly 4096 bytes, F_ADD_SEALS with F_SEAL_GROW,
>>>     then a single pwrite() of 8192 bytes at offset 0, comparing the
>>>     syscall's return value.  It returns 4096, the same as the
>>>     pre-series THP=3Dn kernel.  A THP=3Dy kernel returns -EPERM here,=
 and
>>>     so did the LF-only build before shmem's mapping was put back
>>>     behind THP; that -EPERM is pre-existing behaviour of THP kernels,=

>>>     this series neither introduces it nor extends it to other
>>>     configurations.
>>>
>>> Same image on the pre-series kernel, for reference: it fails to mount=

>>> with -ENOSYS before any of the above can run.  The whole probe was
>>> re-run on the final revision of the series with identical numbers.
>>>
>>> 4. What this turns on for existing filesystems
>>>
>>> LF=3Dy makes the existing opt-in take effect for every filesystem tha=
t
>>> already asks for large folios, and that list is not ext4 only: ext4,
>>> xfs, btrfs, f2fs, fuse, afs, erofs, nfs, cifs and zonefs all call
>>> mapping_set_folio_order_range() or mapping_set_large_folios() from
>>> their inode or superblock setup, unconditionally, today.  Those paths=

>>> run on any THP=3Dy kernel; the new configuration is only THP=3Dn with=

>>> LF=3Dy.  With THP off the ceiling is PREFERRED_MAX_PAGECACHE_ORDER,
>>> which stays at order 8.
>>>
>>> On the tested 4K-page configuration, 4K-block ext4 gets min order 0
>>> and max order 8, while 64K-block XFS gets min order 4.  Btrfs derives=

>>> both ends from the mkfs sectorsize and nodesize.  A THP=3Dy kernel ke=
eps
>>> the order-9 ceiling (HPAGE_PMD_ORDER) it has today on 4K pages.
>>>
>>> shmem keeps its THP dependency: its mapping is only marked large-foli=
o
>>> capable when THP is enabled, because shmem_alloc_and_add_folio() stil=
l
>>> forces orders to zero without it.  This matters beyond cosmetics.
>>> generic_perform_write() sizes its write chunk from
>>> mapping_max_folio_size() and passes that length to ->write_begin()
>>> before clamping it to folio_size(), and shmem_write_begin() rejects
>>> pos + len > i_size for F_SEAL_GROW.  On a 4K memfd sealed with
>>> F_SEAL_GROW, an 8K write at offset 0 returns 4096 on the pre-series
>>> THP=3Dn kernel and -EPERM on a THP=3Dy kernel; advertising order 8 wh=
ile
>>> allocating order 0 reproduced the -EPERM on an LF-only build.  Tying
>>> shmem's policy to LARGE_FOLIO means the allocation, swap and split
>>> sides together, which is a separate series.
>>>
>>> 5. What is not covered
>>>
>>> Since PREEMPT_RT is the motivation, the RT side needs to be explicit.=

>>> The freeze-to-xarray-update window in __folio_freeze_split_file() is
>>> the fourth freeze site named by Matthew Wilcox in the RT livelock
>>> thread started by Dong Hui
>>> (<c2ff0c66422c4e2d869499a1186ff0ae@xiaomi.com>):
>>>
>>>     There's also __folio_freeze_split_file().  I know PREEMPT_RT
>>>     disables TRANSPARENT_HUGEPAGE at the moment, but hopefully that
>>>     restriction will be lifted.
>>>
>>> This series does not fix that problem and does not claim to be
>>> RT-safe.  It only makes a code path that already exists on THP kernel=
s
>>> reachable in a configuration that has no THP, which is the same
>>> exposure Kairui described in 06/17 as "should be fixed generically".
>>> One detail that may matter if a reader-side fix is chosen: the
>>> function already holds the xarray lock until the folio is no longer
>>> frozen and visible, since folio_ref_unfreeze() happens before
>>> xas_unlock_irq(), so a generic fix of that shape would cover this pat=
h
>>> without touching it.
>>>
>>> Also not tested here: the migration, memory-failure and madvise split=

>>> entries at runtime (only truncate was exercised end to end), arm64
>>> with 64K pages, nommu, KASAN and lockdep, xfstests, and the btrfs
>>> order range.
>>>
>>> 6. Questions
>>>
>>> (a) Non-THP split accounting.  count_mthp_stat() is a no-op without
>>> THP, so in an LF-only build a file split updates no counter at all an=
d
>>> THP_SPLIT_PAGE does not even appear in /proc/vmstat.  I have a
>>> follow-up patch that gives the file path its own counter.  Would you
>>> rather see a new vmstat item, an existing one reused, or nothing?
>>>
>>> (b) Should XFS select LARGE_FOLIO itself?  Three lines of
>>> "select LARGE_FOLIO if MMU" in fs/xfs/Kconfig make 64K-block XFS
>>> mountable on a THP=3Dn kernel with no manual configuration; I built s=
uch
>>> a kernel and mounted the 64K image.  The cost is mm/folio_split.o: 3.=
2K
>>> of .text in a THP=3Dn build, code that every THP=3Dy build already ca=
rries,
>>> paid also by XFS builds that will never use a block size above the pa=
ge
>>> size.  Kconfig cannot express "only when a 64K filesystem is mounted"=
=2E
>>> I left it out because it changes default coverage for a decision XFS
>>> maintainers should make, but I can add it as 4/4 if that is preferred=
=2E
>>>
>>> Comments welcome.
>>>
>>> Fang Xieyan (3):
>>>   mm: move folio split code into mm/folio_split.c
>>>   mm: build file-backed folio splitting with CONFIG_LARGE_FOLIO
>>>   mm: enable filesystem page-cache large folios without THP
>>>
>>>  MAINTAINERS                |   1 +
>>>  fs/xfs/xfs_super.c         |   2 +
>>>  include/linux/huge_mm.h    |  60 ++-
>>>  include/linux/page-flags.h |   5 +-
>>>  include/linux/pagemap.h    |  17 +-
>>>  mm/Kconfig                 |  19 +
>>>  mm/Makefile                |   1 +
>>>  mm/folio_split.c           | 969 +++++++++++++++++++++++++++++++++++=
++
>>>  mm/huge_memory.c           | 920 -----------------------------------=

>>>  mm/internal.h              |   1 +
>>>  mm/shmem.c                 |  11 +-
>>>  11 files changed, 1054 insertions(+), 952 deletions(-)
>>>  create mode 100644 mm/folio_split.c
>>>
>>>
>>> base-commit: b024a51b0184b1efb6f55b11aaf7b15a490a6307
>
>
>
>
> -- =

> Best Regards,
> Yan, Zi


Best Regards,
Yan, Zi
