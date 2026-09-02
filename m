Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010051.outbound.protection.outlook.com [52.101.46.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA6F47DF84;
	Wed,  2 Sep 2026 16:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367196; cv=fail; b=HuvtuEPdKTiRJ9RonsdiLpTc2ybI3exg/1LB4i/P9MOlgE0GGlkyPsGoGcKt8Zm6jWTvX+N9ZSG/SMwy8S/D+yByeaGbbuqzEhGN3GWJeIOuuy3I2h6Cl97gLsfLClVXedp5GLd9NXE7Xx9qBla5rAhVMkIaeEiFqHhk0fJXtPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367196; c=relaxed/simple;
	bh=jyYJx5ln3QSfhdoq2t7CGC/VcpO47Xm88/mmDdNml5E=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=MtedaTEgcez1aTwz4+9gqBdFZ4HpC5BplhgFr4h8t5h4gif58usZaBDOC/ZZm0laGP5wff9jOCIbx+pOn7KQhq8KxoebAWm4E3PPFcEeoRaSZM0Whox9mO7vtqGaxRqW/M5OxzoibLW3ckFbivazqHidYhkGTaBYmw1sFFseXMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NgtFQHjQ; arc=fail smtp.client-ip=52.101.46.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NgtFQHjQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wH8IeOf8eJTXes/9mX+b7DGynR5o0GXk79LUAknWNMBDjQtTTZwJiGyyvD0xLSL79yFhZAzjhqhslxCz+Ra1EiaT5vxkEmANSuIN452w15wImrhsbxxX3cI6tDfxMlqIjEqngzR8X8gyFKINm92vRPsJoS/raKOZjlivIG1zy5McxHHGJQ2wcDPeJF41Z608vwL+avL9hZrXEO3M8wba8g0WHYAicwrPp81tOJWHBZI3qBSQkeZDdUJrbbWuD4pfTNSytili8jk6QMPddUr3pFL9A6Y+vJcP3W7hxM13sGnN3QNG+a1jMZG1Sg7QsooxDZ4JSZZ6tFkBvL0PoklYYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2fE2o0IX69Q6ZAkOeTgMGkLEXRceYwgsbHdo2zJXGg=;
 b=WiyehSK88UdlT2kMFTZUqEp05bsJFdBJG7eOj/0FyJONOyiZD7fHwn6IGKaNj7e/vGfEW3bcYeMKJpdwPd6QZRrmAt/7hycd2VdvkXTIs/Z2b0BTapfsCdDmH9C1XIMzJ8/QKFLvqSIOkCUaJ8nexy8BezphmBYveerkao9VlVwMQQr1IvpQKUufoQYNkWqTLg7aQnEg3OjCotVWa0O8t2fUe+sTbeWIDsePS87M1ku0Tqd1TmcN7SpVEkp0LzitV8pU65VDxC6Rsvvm0WYbGyGlrBOY7vPfmeptgZZgaR42pILTN0UVRWFvqxE8wF6Nzn+FPOwJ9bFlYbqqBFQiSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2fE2o0IX69Q6ZAkOeTgMGkLEXRceYwgsbHdo2zJXGg=;
 b=NgtFQHjQhQxe25ypHQKFmQsx99rl4jOIfZQkvZ17eHkS8FPbiXf8Oraqf33y09NatBLi3mxe/KerCkYnAYNGuO21KRbvfkBmBPD96c0gH0pKJb25M5YBZU2MN2aA38KYrELG5PjjJACfbPyWUpWuVT42xkd0zIbs1qjIXUPZvdwG9dqtmcuyImIDpx+QxF4nMmL8gdSlbwtiesW7UwWe0t6gNdiRm+0LtqhKvwCzFRXvoxZvRHE64lJPbi7qXtg0LhDHpcIrh3ou0OEOxvWIDwqIOOP/dFThHTI7PQM5l3r6I0cRHCBU5Al1MXACfn+b7yWBPQuU9MKkaiidcPINjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB7870.namprd12.prod.outlook.com (2603:10b6:510:27b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 16:39:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 16:39:50 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 02 Sep 2026 12:39:48 -0400
Message-Id: <DL4Z9CKIDX3B.199EJSQ3128B0@nvidia.com>
Subject: Re: [PATCH 3/4] mm: replace PF_KSWAPD flag with kthread_func()
 check
Cc: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>
To: "Kefeng Wang" <wangkefeng.wang@huawei.com>, <brauner@kernel.org>,
 <djwong@kernel.org>, <cem@kernel.org>, <akpm@linux-foundation.org>,
 <vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>, <david@kernel.org>,
 <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>, <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
In-Reply-To: <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: YQ1P288CA0004.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e6232f1-60a0-4561-811d-08df0910ced1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|56012099006|4143699003|11063799006|10067099003|921020|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vMwJU0ISVDeutNVpZ8CExb48+U0NV/Ebv3eOFapDUungfWv1j7rd7Yp40Q7NuChWUd12zm9ApMYptlYBDFdkHTCK3tngcyQnBLZhQmm3hP469SWeNGkVkXzzg1/q8F2PaWn45+USncBRWx6AcMvm9JyLe68OMhXCaB8xfaa+9B3cGg6tlfb/iYT775iTCFpuJSnwn3Z2yohIlzbGMPQm55gISYet753BNoWkENGOcKpV7J0yua54tJMtB3mnBlvR3b37HdSn8ZFDA2Z2vOqqCf7AtQ+Y3BqyaGUovn3BwCObtaXiCAOTrfhqOp+HKpneOaMagNaqt5GQ8Son3blObegOzZfyaXf+vduze8FA85A9dGzYc6e7HvoOUYLAPwQi3IwRJkdZT5eninULDw+uUNIAKLmC5d5qZ314Gng/ZA2D1WC/lKAC+kZps/Amm3K6xtRMss1eCKq7w5JcUR2f7xcSZotFHJg5ilA8Lb1EaKZP0zb5NGgbKxwKpPxcigfYTfyjx9gXwCpZuGc4ftJed1nTub90M/Oy5tD4tQmHPmRTEsUpORsjLElazykXNMqxRrBrIc9Q38NdsYwY8UXDRHpm4qvY5Hf0+T7o1rfW99gpnChlJA22M2zRmNCHwV8MnehuBHsmnThxxxXOWXzaOcDdBz6sVtZCY0FxOVQGuu/cOsZNoK5ceHOQyu58+SFzcEahJZNGS8p4FwKOCzvIVg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(56012099006)(4143699003)(11063799006)(10067099003)(921020)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aythVFJSWnJUcnhWSFoxd1JLVDR6eHJOcGVyU0pra2lsRzdtYVg3TVRncUg2?=
 =?utf-8?B?NjhWNE5CbGRvSDhxTHo0R3ZwZDZGaUlFUkFVaEpkRWlERzBNUnQ5ZzFTdTl5?=
 =?utf-8?B?TlRHOVREVmdFWXZ0cVVjd1Q4bGhLUDRKNk9zaS82dVUxQ0dhMnFhY0ptSVpm?=
 =?utf-8?B?VndrcjU2Q0JCb0lGTlB5ZzNPVVBaOWQrVjJuRGcrVE1UdnRDMDZCQnR6VTdv?=
 =?utf-8?B?WEkxY1p6SjlvdGwvckR2VnNTQmRSQkxsZittV3FPNkFxMjNNVTdXSjE3Z3pG?=
 =?utf-8?B?WFlYbGJNWDh2V3FZTXRQczVoWFprTEowc2t5RU5UTWJyK3h6WEY3a05qcnEz?=
 =?utf-8?B?NFVQeXg0TGFySGVUQi9kRTk0UHZOUnh2VVVoL2RmQlV0S3ZheU81aDBHR3VE?=
 =?utf-8?B?WFZ6QmREMzFGRlpCWWM3Ylk4bmtqQ2Y4UWcwb0dHT1VOTEhicDFvN0Y1dHpO?=
 =?utf-8?B?SlNaSnp4aFozcDByeW5GOGlOaG5YWlpwMXpQYW8yZmE2R21iMWNnMEFLYWVt?=
 =?utf-8?B?TVJxYjIrcitzVmphMStMTGppOCtGRlBjb25rUzgybGtRM09qV243UXlINldp?=
 =?utf-8?B?Qi94d2ZRcHl4MkdDWkRMcWkyNmsyTGtwV0FjN0hOMjFSdjdqdWRXM1p2Zm5X?=
 =?utf-8?B?LzBhMDI2VUhwNld1bGpMVGxLcWNOT1hRa0VvSmRlQWwyb0dDSDJ4NUovV1JR?=
 =?utf-8?B?czIzQlZBRlhZVjk5RzVGeUJiNHNDTGFFWEJXMEk0T2ZkZHpJcUxpVFRHbU9X?=
 =?utf-8?B?QlQraG1oS256QWFDUFZ0Rk1mWVZOL2VGV3g0djZLUXNYMnZYMnJvdXQ5RTRW?=
 =?utf-8?B?SWRHbDJuYXpqMTJhTUdsMjJ1SGR5ZGpaTGJQNkdlSVl5emtiQXlodXdHOUd6?=
 =?utf-8?B?RWRnTEVqcURTUDd3clFraHNPVlVweWhEVlFEZmJndzJmbi9YUmI0ME1qVm5l?=
 =?utf-8?B?Q2hZSGxpNi9SQUlyd3hpOE1KMTRsMnFxOHJ2QVVyTENnTDBWemg0aHVmak93?=
 =?utf-8?B?RHFOUGVyNzN5T3F2UzQ1UHhvUUd3dFlxU1BHQ2ptTk5WQTV2Qm5CSVhyQmd4?=
 =?utf-8?B?MXJoUzRManVhczVINEFqZ0xnZENOL1NGSVRpNEdlUUlzVkJZNmlSa0piOVhj?=
 =?utf-8?B?ckxjL0xOOXdHVTZxTDc0cU1abnc2bkc3WUFWSnUvMzhtNzg4b3hiRVFZaFhC?=
 =?utf-8?B?c3J2RXNuNUlXb1lJa0t3MkFuR2NxTzFQSzZJRkplT0Z6anMySEFYSWhpTkFD?=
 =?utf-8?B?cDZ4OHRTZU5PVUpka25ISUxadnYzdXNKK3JmbEhzZ21QTzZyTlo5WTQzbUxF?=
 =?utf-8?B?S2ZyS2FjSXlzNEl3bXBnVENaWEVjNEtRbEkzdnp3QlR4M3Z6KzRJbk9GbTFp?=
 =?utf-8?B?Q2RnV0lxbUE3c2lqcjhRd1dOS0thNm5Bb0Y5am1CQnJ6VGRqTVZuK2pXeUU5?=
 =?utf-8?B?THc3KzV4MGJORlNVSHY2ajFRa3QwNUVTbjB3Q0MwT21XWnN3TExlNmErTjZY?=
 =?utf-8?B?UmxGL2FGYWRURGp2TVVuMUtHNEIxTnpNb2ZmTVRQYXplOFhSTlBQYzRSK1Vv?=
 =?utf-8?B?YWphdXZ0aHhyeVh5ZjA1cXRzbXllUFBiTC93TFFXejZBZnp1MEdKOVJnWjQz?=
 =?utf-8?B?REYvcWNIR1dNbzI1TTFOQVFwQlEwd1JRdCtpN29BYUc4TEtLeHJ6MXgvNkNU?=
 =?utf-8?B?M0V3NG5IYjNXSWdlN1AyOHowN1NWK3J2eFM2OHhTMHVGRDR1ZUcwb04wQWxU?=
 =?utf-8?B?QVVVY3FzMWVaQUNjR2hXVmdoMWExdDBwaHVqSGV2bk9EZDI1MWtYOVBhbklJ?=
 =?utf-8?B?Vk1aa0poTklnbERVOUhzS2taNnNObURaM2xPdGw2R29yYnM5clpuQWk0YkJj?=
 =?utf-8?B?aFMrUENobjM0ZkdSYVBxejFSTDBTSFptclBLVTFqYjVGT2RVcElmcGhYcWFD?=
 =?utf-8?B?QnBxRGtkM09iR28vREVHcXU5K2ZXRVJ0UnAvamNsVHJ3Mng0MWd6YWNkRW9z?=
 =?utf-8?B?d1FkemVsRVpOUDNJbStKK2hKVVBqZE9JZ2tJK09sdW1BaEtQUUp1aWd6dUQr?=
 =?utf-8?B?SkVKQVFSRTMwa2xtMjIrU2JCS3R4TTJyQ1JkbW5sYnFoZUJTSU9HWEY4SFhy?=
 =?utf-8?B?QkJpMHpsUFdGSmp1S0x3WU5VNTZ6eU1uSW5kTjNCb0dFeUZ6dXBIbFhVVUhQ?=
 =?utf-8?B?dWpabmV2M1I2K0tzMm11cC9DNldiK0puQndHejBvS2FCdGN4TVgrSndhNENu?=
 =?utf-8?B?aXVpMkoyaXJ2a0VqOC9uYVNMV3dSV2pmUEV1NVZkelM1VlQzczVnL0hzZnpY?=
 =?utf-8?Q?LvP+GQKUAiJjsM+cY2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6232f1-60a0-4561-811d-08df0910ced1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:39:50.5504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ntl9x2mg1G5EwuEyGRLFcDPLi8aq9cZs5rkkI5/whd2h9MSPM81rM4XCmPtI5F5B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7870

On Wed Sep 2, 2026 at 9:16 AM EDT, Kefeng Wang wrote:
> The preceding commits removed the last consumer that propagated
> PF_KSWAPD beyond kswapd itself (XFS btree split worker inheritance).
> The only remaining setter of PF_KSWAPD is kswapd(), and every
> current_is_kswapd() caller only needs to check whether the current
> task *is* the kswapd thread, not whether it inherited the flag.
>
> Replace the flag-based test with kthread_func(current) =3D=3D kswapd,
> freeing the 0x00020000 PF flag bit.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/sched.h                    |  2 +-
>  include/linux/swap.h                     |  7 +------
>  mm/vmscan.c                              | 10 ++++++++--
>  tools/sched_ext/include/scx/common.bpf.h |  1 -
>  4 files changed, 10 insertions(+), 10 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

