Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C1247F2D9;
	Wed, 22 Jul 2026 09:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784711510; cv=fail; b=WMmdAEKVjplx1sXjQxQeoP8/mxvBDmcj6jxkf5EvL8h2OWDmmYYZX1nORwzbXgrJXNx7VGWeCZy2S7+8DJyOVBkcel1fdy/L4I7zEq9yOZ/wYcZpvDH0iQFluCwTOqXxcJDvZxmbzRvJRfuh56TRxhEsIEDg4E7cJWzdfi8Fxg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784711510; c=relaxed/simple;
	bh=aUKZ8pbrdP914f7M9aPeAUbCKrg8DjV18hKfF44WhpA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kl/CbNH9cXPJrFs0mndvN3WxtBaflSGpRCWYx8N1k0ZDaakVRZhkfmZest2z60AnnvyL7yJu5Pd3kswYY2crvSGN3uNAZURHj/s5bUk476FUusy00TgP+IK5RoU5q8K9RwXCxroO43/gkTcPQPaggd/mZHVqjEhdNnN3UWm1JZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=BliQtoIF; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="BliQtoIF"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M8xFAO451317;
	Wed, 22 Jul 2026 09:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=KTnTL1TLgwA63k1c0PN9MhIPP243WaWWHbPeQpOTvpk=; b=
	BliQtoIFJiZOrTrcXlHMNRmpmq6rwgnu9Na7oKvsXRORLQ9RXJh2O98OBEtzN9qu
	YIZs3QxlWREzohQGecuTup+mauvUhncMPXoiR5V5Fzj31TaVbfAkNCuXfAYoc7A1
	JPF6SLLDJ0DN9D1qKu6AWuZXViZmu1uLYfH8GETA3d0hJBUAIK90b7rn0l309qKd
	zhQiCf3FxmMCSZ8Db8ClbeeDTMjhZzyESi9V0/ZYWKnH2BiT79rNkRHvoTDH2iz7
	uklMPR+T8yFVWEIpxraf4ZVri69rGXAFlaFjQ9MCRHnNWulVGGSS6CLs477/O+V7
	LBx4d8L77Wa+tsqXBphvRg==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012064.outbound.protection.outlook.com [40.107.209.64])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fg0f5fq2x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 09:11:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pnA2sDTeMA1actXUnWQ3OovyDtj3bZig2ZaLNZFGRBCOwBmqY5splVPSYpqdVjlxTA7nujN/qTKSnN3o69FVcfuVvj8b+q0QgT0nznCocASFDintG8lXEmCpYZZPjO3gu7C9w05aD6sMJhSzXz4ocHza2zWY7qICZ7OsD+6sh85dkOCybj6yN6qrDGBrnmV4iJVPAE4JMjA+3xE+QYVVxkvuAEBE5aEWf/TftEu3NPIKvdY2UOuTUGIOApjzzJStOQCpoOvlHWmIThMvjD/50uXlT4qLFB/ayxNihvZCVlWvsWbDUtTeSdKtwPFu+Y/AQp8ynQl3Cc3uTUIq5xtd1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTnTL1TLgwA63k1c0PN9MhIPP243WaWWHbPeQpOTvpk=;
 b=ymZGSTs+Xv7Up9WasRyCvfonyaU4ZZludF9gvedhpafMBXpvgoz1jBxl8lhu3UVEeC2uvH5SIpae05wQvA7Sha+FMcRGK5fCibgVhLf/4ggKaS1rPpaZFaY26uqqecKIYafTYk7sGcO1tBJIYr5rC5rVbzlVPHpT0pXy0WLnuOCdURbXUxK1LxfSvPrj9PNRHh5p1hvoYJu/iI1hY8v4Saat9tW5Xlg1bY0unQYG/i7km39NCfg+TW7HraKPrOPVRWPR2R6VI7/tYc8FOfFh5EzVCjB5kUxTDPzOyLtS/WXlqHHHBnSPCv6h5DWmKRnp7eIMcF4vflo65fxP30BwNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by IA3PR11MB9302.namprd11.prod.outlook.com (2603:10b6:208:579::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 09:11:15 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 09:11:14 +0000
Message-ID: <a160f24e-9bf2-4e38-98a9-fb21ba90136d@windriver.com>
Date: Wed, 22 Jul 2026 17:11:07 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix compilation warnings in xfs_sync_sb_buf when
 CONFIG_XFS_RT=n
To: Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260722042841.220534-1-yun.zhou@windriver.com>
 <amCBowU-Q-QrGYoX@andromeda.toxiclabs.cc>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <amCBowU-Q-QrGYoX@andromeda.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:194::12) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|IA3PR11MB9302:EE_
X-MS-Office365-Filtering-Correlation-Id: ca2e9af6-4bc4-4df2-2f57-08dee7d12e17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	CEyra5G8nuWG8yqfnl/uSy1yiUHCca5A84EAzrC/kZIPkgvIey+lrQfZJKlsldd74LwMOp+/cgWNq1PruNk5R8OFLFVp7P509hXXFtWecB5SP4C+SziBqmspZGFdHLQBv1JrrNtlIt9Cq1JuErPv+HwhVJRsFgKYZmEugA3tHfqW0lUwoKBJvlAGpKjLGiO7EUM387S4I4rgwI6K8vNvxmPDH4DtIiQ+jxE/XH2qgZ1kwIVOeNGKRBG+dFSuH7H/CeMYdwFA8C4HIwA5x8ZEmQbgJav5c4wKIyfgdCodXtKpoJFqtJke2B3QE9z+nmE+k0Xjz3LhPEU8rHzyd1LHFnKm9121ABB5x/KnGHDlY3bWPbqhFIBlL/4IIZfROFTrY2pQWvOlP637EpNamqLMuquWukPEe1E4fxzZXjB62AdWiDmztm3tMxSs26bqHilzmiOIISmAzyNbxg+kQFkAeFcQN7Qlp0z/+6Jkfs0eDPufYOkquoEWdhI+FOdrZ745jXLG+q8o2mBb7IauCNOfwgdxHQGPYqR/2vvL9eDlCMLPdz3l3FoO/tbeUIjgtN1Q4BiVwd6zdpEAoARYLFEXLv2rnP+H8MOgVdY3t2DNks1/5VUmvzutxmYdtev5eWhoN6XrjcwKZRyMSP4ulOz/DMDe3AzIoA1C68ybKV2dv9g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ek9qT2lqc3BaTTA2djlnc1dwZzJOaVNDUzlPZzU2QjFZNjFHR1pHdUp5S0xC?=
 =?utf-8?B?YlVGZCtlZHg1TWFzYjNYeGVsWmppSHlNVnlualdnM053RFpIS01rQnJTV05a?=
 =?utf-8?B?K2NrUGF0cXZ0QWl3aHhHMUpjNmNnN3Ztak5OVEV0dEE1S3E2NFQ4bXdzVVJQ?=
 =?utf-8?B?anhmWUgzQ3p0KzFrdDQvdTQ2OHNCUlFsZGthVVVYQ2dkei85S1FNNFVOQWdV?=
 =?utf-8?B?NDMvNTZGYlRHTVdpREhTc3NXZHB6S1pvZXcrT0RSbUVYUFpJWEYwWHdTSTFX?=
 =?utf-8?B?SytKSExwbzEwNXRtTHF6OUdvZUhGYTZmYmJQMWVMcitLbmpYRjlGdDJFUFox?=
 =?utf-8?B?akl1ay9OckN3SElVam9RbTBCaGtIb1hBR1BoTXRxaWk3QTFlWjFZcnNzaDBR?=
 =?utf-8?B?NkNwTXdWYk5jS083VU9nV0hlTGNiSmNRb2N4K0hEcnB4MnA5U2l6K0JaWTNj?=
 =?utf-8?B?UlVyRTFPNXhuSm02bEpkY2orWHRMaFRzWENIbHFCVS81ZUtpN243UzFoSlF2?=
 =?utf-8?B?ZkpHSnJzYlg1NWdYWkdlYUlwZjQySTFJQjhSeWI1eFNnSHVMbEdHQWZXeEQx?=
 =?utf-8?B?NGFHTld3emswSE16UFVVOWFiOGd5bTFkeVhWMElqWXFFbGV1RzRHMHhyWDNk?=
 =?utf-8?B?QzZWL0crL1l2Rkc4Q24rT08xV1VCL3dNNHJPWXd1SlRsMDY3QTJIWTY0R3FO?=
 =?utf-8?B?NzBBcnJxVFZiRjQ1MlJYbGNCTkhqbU9JUHJkZUlGdElzZEFZL0h1ZTV3K3pV?=
 =?utf-8?B?cU5tcUh6UzhwZlF0cUF4R0Y0cWxmZGROQitkRWtwQnJQSy9jdlMvRVdkRE1W?=
 =?utf-8?B?N29uTU1xMmFCK0o3RjFnMTdQUVN2K011alZVSmxSQ0x6ZVdNbllNRHYzUlUz?=
 =?utf-8?B?REJjd1FzSG9nWi9FU0UvZnVnM0lTOVNxcmpqVHZ2djlDUWNsMkNrZi90dit2?=
 =?utf-8?B?cnhIY3BQRjZ2ZmJlaEZVQS81UEhSVTB5cXo4RHU5czhKZzlhV3U5bTJSamxO?=
 =?utf-8?B?dTlmOXhxRnk1eWxva1dWSWxyWk9kdWl6dXM0TTF0cm5wWlFCODlXUzVWK0Nn?=
 =?utf-8?B?NmEvWGVLM3lHYVo4ZjdtdWQvNTdQZ1ZWcWRDcytVYUF1RkV1NDZFWEY4ckRW?=
 =?utf-8?B?eCtvZEFxYmwvOWdoT2R0cE8rL3dnZ1o2Y1ArVTlJTEs4QnA1dUhtQlRrb0dj?=
 =?utf-8?B?cW9QOUpJM25CVWZsNWxFUlZBQU5KNU1sa0dQYURaanFWeGJlWlJvUVVLWlpS?=
 =?utf-8?B?UjBzd3JUR1NIdHZWNTV2ZUxGWVRuUkIrdnpmWlRKdnhHRUNlZ0lHWUl1Nk95?=
 =?utf-8?B?SWtST1ZXRzBJWncyMWFqU3M5bVpwdWwwZnp3TDl4OVJMRXZzMjdTTm9nbTc3?=
 =?utf-8?B?Vy9Cb1ZKd1JJR2g3R3JNdXB0NWl6eFVOQ2FXbHZOL0hyU0Vtc09WZWxVdjNM?=
 =?utf-8?B?WVhZMWIwSHl1UHl5ckZNSlgybHZKQ0RyVWhDYkd3ZjdSVHBGdXYxR0RJMlYv?=
 =?utf-8?B?U1o4NE9oMUcycGU2Ly85ZnYxS20vTWtuOUVrK0xpSmgxSEFkSTdQcEMvY2ZW?=
 =?utf-8?B?ai85NXFPZjNQRDE3azhVN2VFRzF3MmpNK3FJdTI3NGFXbjZLZnB5NFYvbHJX?=
 =?utf-8?B?bUZLZW5CN3ZtT1VGRXlQN1cybmhwK2VFSGl6M3dLVFJWbEVqUU5pbmNXUTQy?=
 =?utf-8?B?WUpWMkZ3Y21adldBeVJub3JUTXoxbDVEOUhGZE5KaWhtSjIzSWhmaHYrZ01D?=
 =?utf-8?B?THBOU0tUTGlVT3cyL1VwWFcxdzNnU3VLNlRGdkcwQ2tQa2hCZ28rdUpnOXNH?=
 =?utf-8?B?MWF4Y29kNitvMGcwcFF5NDNFWUJmeEY0ZHZ1OVRYWDNPbVUzR1ZEWnIwanRB?=
 =?utf-8?B?bmM4NVZBWjRpcTZjVWErbEFSZ0tDeGpES1JXQXVUR1FTbnd0bmN6MDA0ZnhQ?=
 =?utf-8?B?MG4rMjFjb3J0YkNXdzJNZE84VHMvOURNRTJ0U1hsMXBocUFuWE0rcnM5ZWps?=
 =?utf-8?B?VXVRdS9ZbzN6Zzc5RGZxN2hXVTJIK0R1M0k3a1hvRzBnMXFSREtwQlJKTEtH?=
 =?utf-8?B?dFRYdE4vUThFMDJvWFozYlovTmpLdFViSGxkM0JTdStGQTF5OXZtejAyVmZq?=
 =?utf-8?B?eVpSVkI2bHZrZ1dhQ2t2T01ld3NySWZEUFVIcVovUXVjeHcvYmVRNEgyZDFQ?=
 =?utf-8?B?KzJWY2RjdzcyZS9halU5ZFJMYmt0cGkzQTNHNi9YOHA4c1lnZ0xEWWdoZklQ?=
 =?utf-8?B?ZXNCTDBTRlR6QmVFRVdlbHA0SGNtand3azFIMCtsUU5QeTBzcW1FZ2I1YlV5?=
 =?utf-8?B?UENJYmg3ZGlSYWVQWEYxNmpGVWdvQ2tnQzVXbWdhYUk3dUlGdFhYQT09?=
X-Exchange-RoutingPolicyChecked:
	IXkzmINUH5uBBr+608miOE3JFXykPzp+BYvY9RJrHvZBgZ+oWM84fU/b+dSmPZcnWAf6T1TiHD1yTrIP1wKxuCz4UXcZ+ihHuUSnHV5etP7DyNugFBXvJiCiE884lKcT7AYe54+U3ZpeqnH+gDoBpDrdw1faldXc6EqXlBIXSNPfX9028Hy0feE9qXXBocOc++aE2MjWAkpjBAqIFoTlDZRBaHXMJBUrJsOgvgQw6rUhEyDCJxWfqT8YdkFcsmMW70Q9E9GyqRqYFPMFBdC3+0gIcYB6jXPRmjYKZYAsxenEtTtwhhe5qGRkTuwPbNawWz3JwexD+3tPRLIYcOBHYg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2e9af6-4bc4-4df2-2f57-08dee7d12e17
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 09:11:14.3921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSBmnDMQCqPXczooMCYjeYgYAWBT4WUHlZtcHn7IYdxgUkL8TNcy2bthRjKz79XcRWCoeXk0wn53Z243FQQN5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9302
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA4NiBTYWx0ZWRfX4VV3Tb8TMf+O
 sBvsiY+q9VdsCg8xIaP5vwdsfcqD5BfDU+t0i/ymKlxkZqatJ6QKCyH7CF+XyW8cpiSkuVxfCzr
 RqN3laRPnpTqoWcO55EOt7SxuQRkqXGDFBysVD6wfKzH3XlwGbRdVXy3Ywu3bQGX2FbAaQVjn8u
 kDoXL5oH4edLif0RkONPtNoeuGT8kAD2qILs18hL7J0sRdZ6ZdD877tEHkhsgveq6t15AcNN86t
 Qni3uYxYzQ/WEsHt7C7WBVagXuD1Kx/7NTjOWJvv1Az03XsTiTSPqnueH2MaYxgy2bqxkJSWiDB
 4rh8n8LBBJmbUPicSdzQC6ICCzcWWJMEtQL8Jql7xQAYAGKCgx0QQB2v54WvFEA52jjMj/pIxG0
 KCfhn1QWfACMwM6+iQw2/lQtgXn3QGXfWO+R3bLbpQ1NSk2erL/ls2yy2hFpexSUmMjimiEPUOu
 deUriNBIzMDKu8QU/bg==
X-Proofpoint-GUID: kfgRQMVt8FLZDZF32f3X6hGhx6ZzC8JN
X-Proofpoint-ORIG-GUID: kfgRQMVt8FLZDZF32f3X6hGhx6ZzC8JN
X-Authority-Analysis: v=2.4 cv=IM0yzAvG c=1 sm=1 tr=0 ts=6a608936 cx=c_pps
 a=QLNV3L4FYR5wOtQiEb8zVA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=t7CeM3EgAAAA:8 a=uyTSoK_NTFgHtWmBG4UA:9
 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10 a=ZXulRonScM0A:10
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA4NiBTYWx0ZWRfX3HHH33B5LWYd
 l+cyRMK010hr1izsk+CbSDrTpPFlNQMBPv59CY7zS9fTC8dNNSiSXFvF1H0iKkTM7IiDs2S0ok0
 wZlcAGZqKBI87FNJKENMvwm8e92HpFKrnQpnVN/7udER60add6Ri
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220086



On 7/22/26 16:49, Carlos Maiolino wrote:
> On Wed, Jul 22, 2026 at 12:28:41PM +0800, Yun Zhou wrote:
>> When CONFIG_XFS_RT is disabled, xfs_log_rtsb() is a macro expanding to
>> (NULL), causing 'statement with no effect' and 'variable set but not
>> used' warnings.
>>
>> Fix by removing the bp variable and passing xfs_trans_getsb(tp) directly
>> to xfs_log_rtsb().  This is safe because xfs_log_sb() already joins the
>> sb buffer to the transaction internally.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202607212237.Pzw1sr5k-lkp@intel.com/
>> Fixes: b9ad0b9891dd ("xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf")
>> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> 
> We don't need a fix for a patch that is still in linux-next... Merge it
> against your original patch and re-send it. I'll just replace the old
> patch
> 

Okay, I will resend v2 as requested. Sorry for the inconvenience.

BR,
Yun
