Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325E2466AE6;
	Tue, 15 Sep 2026 10:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789468543; cv=fail; b=A3tkdKTef8L/H67b2Qxg1sV0hnAyzoh6DWp+2NDWkXKxd4DPdHoalnLJRORWU/qkq5l7Ox59fQH0BuNIHUAqKGlpPOLQEZHvjp1r3+r6ZIO/ZGDq30I7VQIgqtaKP++FB8wsC7MfvWJMOR7VWUW++x9J+qzT6k7OuoIzmZTV9VM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789468543; c=relaxed/simple;
	bh=RYRBwJxPgkCOZER9UfP2XZTIfl50Vs23mP+rKHosyo0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=amwoaypics5vPOoJlN55TqeypkFM2TADi1B7fuChQ8B3jX9AokrMetx6yE49ZJ+Ppi7opJe+g4XN1B4FGt/43NEf/GtCW+OMQMlVpMhzmvy5EBJshsNvN6GwqOcnKbeDYPI3su1D2hlZfVAPcYgpnJhC6lWaCZT7nFXSLPfBOKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=I64HVYTV; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="I64HVYTV"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9hePG3193795;
	Tue, 15 Sep 2026 03:35:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=DqR1nS6yLQf+SdRsh9I/HVqCSPPLUzzPuxybd8n83ZA=; b=
	I64HVYTVHnT0x6iqkZjijJr0cpkI2ugf7SNy+mE+kp6t2P7b8IlGjnxGwU9BrcQj
	Xc+efArCYlue3Xnyr6D02VfLUCohbWIMaMYm/Q539dQaXoaY9ef7DSVrp/HndJ+z
	21VjxZDrlsl00jbVzOw0ZlURYp0YKO++au0sNXBgGGmkTjijhy+rWXAEzOKJn/Yx
	Ik6xfWS5ieuf/Az3JGbP5/H5UwLwJmFGJXwONcicesHEOeZr6jZoQonPMvzHRDRf
	UEslpouMPhA3OK23jUoPKvj5qoehBLsslUJ4q0ROPKjRsWDLGkos1SUMmziHyAZF
	nccdcB96vDtFfC7+IotQEw==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020084.outbound.protection.outlook.com [52.101.193.84])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4gn68g4xeh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 03:35:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TdZeaWe2vzSBdu+lXhQ2qJib8y/ObnbCllmZoNzPhljgZGjgcC3w9PAfz4F/vtd2MgcqGR4J2P43ezZWGOl2uy26mo41PyxFrp3/T1Y7wD9JfLzueQ2Njjk6p/iUZ5S1WYcOLREV6I1QFI9sfmy8rkyOoO+3S7olf59R+MExAIp+BPxpCvb/dIyO9bGybieMMg+wh5oYKyb0ERhIr7dAfkKd48fziTLiSZrsvNvMilqsJP8I2fQU8IaiH05LhwmNfXM7zCUQq6cpMkIHCV5W+dNZeggvSFNhnw6PO1yArKD/0NF56uFmtltNmGmE1xZkX4UU7DfWzYHvrqNJX6dIfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqR1nS6yLQf+SdRsh9I/HVqCSPPLUzzPuxybd8n83ZA=;
 b=ibXdf0iOjTFayOBfAfq2FECNoRjiUhiBN2DgfhrBbJw8fNJffCMF/0LPQ3jFmEZGW6LwLsNmweBGr/owfErftAJ+pfH5mF/FtRFhVEG+uv6FX1mw2yje6OHRCdh1+fzt3LvZZjHGQC9RDySSAirXHKnDeSlEchSGu0HcBKN9waUJM4wdzmLo1VE1n5HefyYz2Ad1/cdSbfztBY34N8NN4fgobX0qENpi3FDafRhPt+/ZRBrbwqdBZ0mVGlN518TQ2IhunDNeOlZhcGCd2Giw3xt2G6rNG6KBRv9ybeT8L4iwUDg3mdmGW+svTXPy50kFTfQq5XiSlTrHvtirgTw2nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by DS7PR11MB6125.namprd11.prod.outlook.com (2603:10b6:8:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 10:35:01 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 10:35:01 +0000
Message-ID: <e6af011f-005c-465e-b441-958543faf5a9@windriver.com>
Date: Tue, 15 Sep 2026 18:34:49 +0800
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>, brauner@kernel.org,
        djwong@kernel.org, akpm@linux-foundation.org, vbabka@kernel.org,
        surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
        hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org,
        qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <aqJEWmUN3Jsajoyl@infradead.org>
 <38377447-ffa2-43ef-bbfa-43d05decda1e@windriver.com>
 <aqkKPU8HNkt_uV-m@nidhogg.toxiclabs.cc>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <aqkKPU8HNkt_uV-m@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI3PR03CA0008.apcprd03.prod.outlook.com
 (2603:1096:4:297::14) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|DS7PR11MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: 214a17b7-bab2-4182-b7dc-08df1314fefe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|18002099003|22082099003|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	ZKQFofSa11oxVP52hdNU7r/UswV0v2+afKHEhYF38ixbs1bPA5xQDucfpwIsB9x62EdbcVJIlTUZ/QaI2wTNJmVpcmajNeIrfpHhBWaUUgPieg8jcjFbtuiTlDVpyHDOrVmyYcRfU5QlPDQI5e8Kbf719kGXKUl5zBGWR3RXl9QBJKahn7UENr8+qVlXtGXNeAAJz+6x+mOG/yHr58wbV47wPE8NoTVXc8Gc9T+CdRCNGs9BkHzYI2c5fmkvCYvhV2ff0jt2s3KHZbBSY4kbjzXKa1uFCzQOK5bOTg/baebnHw8jIsDad/RF4K6sV7RELttAfljw0M3QidbcQ2WUyaJtc4F4wnxY9rqczgiaEGQDtzWFdEn3Qi77R/+ftbNDzVtdeCleWA4mUU8aSlnKnjmSSQ2ojbCZ3iEejuFbhTMXrv9wE1G31MjI6WOoGKG35mMQStcmJ1vQ+weSTlK5W8anrI4yaffMNpU0+bA9+3s6WlUkO6Hcgk3+UHPPhxe4l14JmV/jHG8YuF0wNVlHZ2g/eK+CFTb3/VUDXuYG454uNJlq4Iwl3xp0PTQqNVwJInIVu1LZgJAfdfTCMmK9Z7ZPgh1XIBR5jH1sUeIWqIvO+fj5OZ7wbwPe9o9xeYDz6Hq/NkSRbHKaDHxUE0x/GrifkIatG3t2PK48WDtqv1Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3RMT1B6cXEyV3ExK3hPS2JvU3pKdUhBWVMzUVJ3QkVEazFCSk5VUHVLbWly?=
 =?utf-8?B?eUtKUnhMR3luWVBlb09XUG4rc05ENGRWbHp3bkRKUDJsMHpMVmxvdFpGNkpN?=
 =?utf-8?B?bGhsTTRsTXVrZzJQaUZINzZyUUN6a3h1OVNlRWJkUXFCSXo5NE9jb2dPUTMy?=
 =?utf-8?B?dGxna1lTRUNuMGpDT3c2TWN6eEtZeVEyaEdNNUR1amJXeWUwTmNRbHgybVZz?=
 =?utf-8?B?Sjg2WDg3a1JlcVlUVGIvY2pSVnFLOVl5U2V6L2V5c0xBQk50VFlRMWNIVUUx?=
 =?utf-8?B?N1FTeG4va01SSy9aSG9RaHMzdTRJOXZtOXVZYkdHZkp4dmwwWGVQWEhyb2V6?=
 =?utf-8?B?ZTdKQUdOd1laK05vY2tGcktvVnFSMzNCYXEyelJ3aTdad25vSWxXOFRmZ04z?=
 =?utf-8?B?cUcrVURNVVJqbmZhN1pSUDRUSHF5bnYxVTJuM2FYaUwvN0JMZVJCTFJuOGpN?=
 =?utf-8?B?THF3YnZGSmdpZUlEODNzV09ucmhlb2dhYVJHVHFjUE5Vc29OTDIvUUQzRitz?=
 =?utf-8?B?ZzBheHBoOElJU3A5bUd3TitTOS85ZWw3NU9wV3NTT0RsRmlRZDJSMHZZY2tC?=
 =?utf-8?B?MkJKOVRZRGNqL2RkbDhzWnh3YlVTWXpDekh0akV3TVdJeThMTDdsUFZ2VEJ6?=
 =?utf-8?B?Y0orTXV2Z3hnTW5DL3h3S0tSbHhpblkrYW9nUUZlMmNiVTQ4aHR4aHgzK3Az?=
 =?utf-8?B?bTNYQjNxU25lY3BsQWZmVUU2NjY0OXFVcUIrbmZScWVla3ZENjAxbzVUVmxK?=
 =?utf-8?B?Und6OE9sVE8wNCtLVjQvNkY5UlpsdEpPZnpmZUJXWmhYRksvZDRUemFuR1Jw?=
 =?utf-8?B?a0lTRVdvbXFtTVhiOXZieThZbE85dmRRelhuTEhocEdLcTlmaTBDdmF1Y0tv?=
 =?utf-8?B?ODBITFhjZ2ZGOEZKZVIvc3FVVU5kSTVTTmpHaXJ2Q09kcHM3N2xpcStBd3lI?=
 =?utf-8?B?ZEs1aXNqY05STGxUdW1ZelJJb3hNSWtQcHpVekJ0bFUvR2YwQkkxd0hOamp2?=
 =?utf-8?B?UGVucVNQbVNHbDd6bVVNN2prcmZFNzJIQVZqQlJDUnBYYzd6eVpyMGtGeE84?=
 =?utf-8?B?OUY2ZnlmVUZZVytrUkFBNHVsSElXTy9HYlhIeDA0YU01WERLWk5JeHRaUGtG?=
 =?utf-8?B?T0lvRUxwUWtLODYwOUVFVXZDdkJESWJLV0FUUFhEYjYzMjRtREQ5bnQ5YkVk?=
 =?utf-8?B?Q01MbXdBZmQ3RDBSRy9pS094ajhTaDlCV2VIU1hTdWpqMEs3bkdvV2FXUnUy?=
 =?utf-8?B?cm90ZFFtTWU2SmpFVUJGTWo2MGhTMGRaUVNKRTdwNXRRRnQvTm1UamxNRkZl?=
 =?utf-8?B?UkhmV0hiQ3dPK0F5NnhlUkpjc2I1Z1JjVnFwSitWbWp0U2puc01jQ0JRWkFD?=
 =?utf-8?B?T0x4d1JTeTh0bER1ODBNbVZKSFRaTzA0Skd0Z3RKbUdSM0lJcitkYmJKTDF6?=
 =?utf-8?B?SzhjWXMrTlRVY0NtWE9UZXhaMXZLTy9YeFBRTFBKWWw0aDRtYnFoOVB3VWhy?=
 =?utf-8?B?QjdWWGhLMU1KSC9zL2NCTGFDQ2dvenpuMjh1K2pPaDdxYk1sWExHYkxyUWp5?=
 =?utf-8?B?ZGF4OS8vc2kxRUxkTVE5RGxaaFh2Si9SVjc4aHhkWU4reWxRckEyTEhycTlK?=
 =?utf-8?B?dkZlTFlXSTMxNDZYUEFRZWJaZWFUbnJ4TzhDbEh5Umd4ekFJcStSeFFSak1I?=
 =?utf-8?B?VzdhaHA3bEtDaldpczZydEdlejV6ck9nVW9aN0ZOaDB3TG5oVzdCL1dmaFF5?=
 =?utf-8?B?c1RscHNDcUNKRFI5UGJTM0k4NFlqSERkRE9ybzVlYjJHaVFuMWorUkRsdGNj?=
 =?utf-8?B?Q1JmQTdmRCt3T1k5dUU2NWFLRlRrdkpiZ0NLYmJHbFdXVHdTbVVnRVg4ZEVm?=
 =?utf-8?B?TCs4U3hSR1NhditpTlV6eXR6V3hGU3h2SEJ2Qy9TMEp1a21aNytWNEpaTk5p?=
 =?utf-8?B?WHJDc2tKUTBwMFRENzV2b0N3WTJOUXF5NDBwRDRxTmY1bkRicTFXdlZRY0tL?=
 =?utf-8?B?YWZzdlRqMTNEWWYzbThaRThuRXNIWlNRZU5QZHVNTFI1RnpOWm9FZE1aRlYy?=
 =?utf-8?B?OHBJcGd5MTIxbnBZKzVkSGRQYnlpUHpubmdDWVRrQkprSFlCNGRaMjlUK0tX?=
 =?utf-8?B?SWJCSDN5LzF5WTJjQUptTzhLUmNpQXNDZzc3dXB2TVc2ZC9CaklQc0N6N0dm?=
 =?utf-8?B?cy9HcU11RVVjSEVtOWxpZnVHOHdwY1plZm5uZjhWMXNZM3FQYjdzaThOOXkr?=
 =?utf-8?B?VlBLN0NmQjE3bHhETm1udmI3eHRjZTdVVGtseTNSZmoxcXZwWklRMHNtanpX?=
 =?utf-8?B?ZEdJdlltZ2l6Mk5yMzRaYmlicVhvb25WWmV5ZTl4TFB1Vmt3ZHpFUT09?=
X-Exchange-RoutingPolicyChecked:
	HNF8AHUWZx4trwbV/q97GNYj2EWeTZD1G+U+8AjUgGQPqHwIyK/706bwcX4liF5Sy5tTtyibXUbNdVziRzHNze6mUVBpSafh/QzPRkwgLP15q26tkbI2kPwoQ+2APsx8w1c+4BwJHsXkpNEPvnmqkz2mSrkAInEU2jaKd3ihIMYB2VCCMaag2nnd5um3jEIQTdh9RExfZ7EsFhBV7n6CCUkeE6/7dC7mowqcq07YpdIfev+MWoDUB9bsiDjzHv9OKwRIbDNZstdJEZ438vv/qnms3AfHFRwjDHgeMd4ZMnr0TtvuoSRfvFAhQWJLcQk9bDLGkRnlQSGcyRs1oe1tRg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214a17b7-bab2-4182-b7dc-08df1314fefe
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 10:35:01.6374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrK8ernYvifzmjKtPDMhMyCsqsFrRx7uiOjAarrMVynsABtt/JIYeldl5kH4vz7bsxdn/TMqBFWnCwe90Jc1hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6125
X-Proofpoint-ORIG-GUID: yIjd_SRuyH2Hr0T0lchn7pCUYHSZRTKS
X-Authority-Analysis: v=2.4 cv=cswOAF4i c=1 sm=1 tr=0 ts=6aa91f5b cx=c_pps
 a=n68PQVbWKEFYfOwbXA7NlQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=i0EeH86SAAAA:8 a=eEl2yBsJFiY-Z3bu0ZcA:9
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: yIjd_SRuyH2Hr0T0lchn7pCUYHSZRTKS
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE1MiBTYWx0ZWRfX7B8mgxFiTe7U
 /+L3ljPMVNsEVdLXi/Bw9loIazLqAY3dRLaR75G1p82XpJD2iqIdqBcUkqIztMntdBtXdw3rVib
 GfLzjOnC+iol4eQOV3uorPw+R5QTuaPAEdnHEB3BE7mMNWZ5n2EA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE1MiBTYWx0ZWRfX1WbuK3vkCcSr
 d8pZB6WiD3SgkWAVT6IIbiD+sd3tzB6m89bIxfnEvY16wYKzPbvVXiUU8ukiLJ5B0qBBgqp03Tf
 ewGb1no4nHE6hNCwIx0dvLl2SYkleHwaUBCuZG3iqvJlQE814P4S05TT9+biXpuvo+omxII3fbY
 VA6b674mfr6zjzdQYKXDFPYFWYRh7rjf2Xgu438wRoZFCavqZdmvBGRmeZrkpcNKXbh5yASlhKf
 4TP97U/32utpMBPAuQIGdgubjrMmMJP5DkV5jGAUOOf6gyoyiVgzjWozXN1/WZg+4CYlHa6E3J8
 DSvv6Ph2CKT5mo8l0bcOdCtOm68M8dlm3F/3I9jY1G2pnwcXa00o8m0yGBgBFJVEOpbG2uGJD5C
 6sJwq5ETiOKRIO3bfpCWEGcn3xiDfDSmC7X8zETzRctpEy55X0/tpCAYAnlf+W/lGUUD+uXHNUn
 +6RWaMugGaMUkmBWUmg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150152



On 9/15/26 17:19, Carlos Maiolino wrote:
>> On 9/10/26 13:47, Christoph Hellwig wrote:
>>> Adding Yun Zhou, whoch touched this area recently.
>>>
>>> On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
>>>> xfs_btree_split_worker() calls xfs_trans_set_context() and
>>>> xfs_trans_clear_context() on the caller's transaction, overwriting
>>>> tp->t_pflags with the worker's NOFS state. When the caller already has
>>>> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
>>>> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
>>>> the caller's NOFS protection.
>>>>
>>>> Use memalloc_nofs_save/restore with a local variable instead so
>>>> tp->t_pflags is never touched.
>>>
>>> Looks good:
>>>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>
>>> Btw, if you have some spare time, it would be nice to kill
>>> xfs_trans_set_context/xfs_trans_clear_context as follow up given that
>>> they keep causing confusion.
>>
>> Yes, you finished reviewing this patch [1] in July. However, I'm not sure
>> about its current status. Perhaps I should ping Carlos to check?
>>
>> [1]
>> https://lore.kernel.org/all/20260720050522.3101824-1-yun.zhou@windriver.com/
> 
> Ok, now I see why Kefeng Wang re-sent these patches...
> 
> The first submission in July slipped through the cracks (I was on vacation
> that specific week FWIW). Feel free to give me a heads up if something
> don't get pulled in 1 or 2 weeks.
> 
> This one though is buried in a multi-subsystem series because you sent
> the patch In-Reply-To one of the emails in that thread.
> Please don't send patches as In-Reply-To something else, specially to a
> multi-subsystem series because it's really easy to skip such patches.
> 
> And then I got a "Re-Send" series with zero information why it has
> been re-sent, and one of the patches in that series was already picked
> up by Andrew. So I can't simply merge that here and mess up with what
> Andrew already planned.
> 
> If this patch can be merged before:
> 
> commit 14ec230f93fa928090507cfdc67ca67e928d0c9f         (linux-mm)
> Author: Kefeng Wang <wangkefeng.wang@huawei.com>
> Date:   Wed Sep 2 21:16:50 2026 +0800
> 
>      xfs: remove dead kswapd flag inheritance from btree split worker
> 
> then please re-send it, otherwise wait for the above patch to land in
> Linus's tree, rebase and re-send.
> 
To be honest, I was on vacation in August, and I've been busy catching 
up on backlogged work since I returned. I admit I lost track of some 
patches' status. That is entirely my fault, and I sincerely apologize.

More importantly, my patch modifies the same code in 
xfs_btree_split_worker() as Kefeng's series, which is already under 
review and heading in the same direction. Therefore, there's no point in 
my resending mine. Please just ignore my patch and let Kefeng's series 
cover it.

Thanks,
Yun
