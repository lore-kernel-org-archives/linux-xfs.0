Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3351D36C5B3;
	Tue, 14 Jul 2026 02:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783995374; cv=fail; b=PjXqsg53gP7rb7YCR1mG4wy/Ur4mcpQCB+/pKCajDokjLCw8zUItROgpCDXTz0Yot7ocsLpwiPqXC4m9/xOQibL1PB93MkG4HBberl4Yg5yku7UK8mR6D8XxcMYdl/eD90bm4ZfXjsrWYdTz6mJ0y3JXEy3cw5Esd25+kVpEGCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783995374; c=relaxed/simple;
	bh=UNv+tFc27QrPjhG5/oAop0uDjaiUqr7hEUKbFyiNx/E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YWbRcWxdeVhbogJrOn1LogB2Wwzy+cMVQYOvGsf11w43ew0TBygW2Gl0Or2C7KnnZxDZ+CMXL3i85++KI7+DOWmahx1TnHEnEkW+ZuOT1L5wFsc9pJxeNcR8dedrpZ9ZmFecCM+76i4o7J4MxGy8diPIFUkkCyRiN0YvV4sam4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=lFJrr9Nf; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="lFJrr9Nf"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E0sNNw831529;
	Mon, 13 Jul 2026 19:16:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=zw0aFajwJnJUMuXUMbKDkXq+/7m5+cOshLkNrNvFllc=; b=
	lFJrr9NfG2sxcrPusSmfNw0sN0E9KOQwIpLvJ5sAxtVn0EJcOw1+iTnrVCwRJ9qk
	0j/DEpgofecrlcR3lKNWGECQPjDJQKuSAg5vDQjfMbTHh4xLcbPZeNouWoeZbvfO
	WebSuxp747sTTzwkF8rZq5OQULC8ovtc0z/2SGScnJPEp1GtujJltRmsuKvL8Scz
	rx/5j8laGljDyfzP18xO84MECU3Z776jT+Ro91jYZ113aMB5Xi3EC/FVX8YnJcgq
	NTRJaPDbNNAYdVRXJC+8NsInx2WByhA8hf6GBkfU7czjVqGJaspEFblzkwwsqpvr
	AYoYPhe4Mnw6HShGreeKYg==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011005.outbound.protection.outlook.com [40.93.194.5])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fbh40ubdf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 19:16:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=br45/mgtwsBV8bW9NjdDA2m64G/5ATP/C/jl9DZhPtcucKo5JfMwLpP8zyyWRYoaG9gQtm1yp7xUn1Jvb3ZfBXB0ipR9sm/Vhi3lR/t8EL5mPY7VmkWArfxXO2F8ib8xaIWOLckGC2GDSZGD8xuzGgDr8CRHAnViHT3GKbwK6SnM9S4BKyMdm7YO/I0Om5k7wNeAK6R4HAWCJohBjHiQ6mWf6RfUaju4IEScXg1CWfG1bET3lDuIaj5K+RGPn95eMsn1UOgro6/4YNMkQJDaj3V9+DbNH6ydB0g3dbxS3HcEcwjoXMTtma3uqGWJI4Ca/DOjGd5lbhE3EXo8/r/uWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zw0aFajwJnJUMuXUMbKDkXq+/7m5+cOshLkNrNvFllc=;
 b=GbaXAISn8Ue2/Pt2mkAguPNaouHW9P0MODMAXu+MsC3FOTTTj2QgyxR5HIt5L3primZZ8k8ckmcgj4mQbJk6O2rfT5R/TSQX4pslewmlfbRbUhEJzGAVFzfqh7dAMqp3bJga096fsCwsRHm4l1VhRPiVt9yghEdunAWIupZ558Qmt5+2CLHxQA6MtKf7oueoGrGyuqVL/7kfn6jfvJ3Nq4dybzMvWfGS8chipVZJ4M5yQU6HwfS2sFbtYr4cT7wzsjAeNCRcifaQhE7dYtc5I5WfgCVnUw/TfbKwKnYsDjjTLwA1ttullmVoyvvkbZ2a7ad6cZZlqvHsf9OIcLStXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by DM4PR11MB5972.namprd11.prod.outlook.com (2603:10b6:8:5f::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18; Tue, 14 Jul 2026 02:16:00 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 02:16:00 +0000
Message-ID: <0792c175-6a7c-4108-966d-4afbc8c515a2@windriver.com>
Date: Tue, 14 Jul 2026 10:15:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
To: "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
 <alSrO3aDTuZkX0K9@infradead.org>
 <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
 <alToBmAN_HyeXth9@infradead.org> <20260713230420.GN7195@frogsfrogsfrogs>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260713230420.GN7195@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::6) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|DM4PR11MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cacc2eb-2d82-489a-7103-08dee14dd906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	ChWuxUTizX27fIO5HmQAeKCelHQcDIxo5z2yy4ZDbzq/yrRRMWvREfvE++XoYyNVuFt9ZWzqoGGLNHFNz5kWYvOv6ZoBLzrZg8TwDDqcL5e9Ti6MNzY9efvhtrTnZf6nFlfzsYaxbsRYna28DswrB0KbOPhpUoFkuvLHIl3BncvunSJOcGOJLGwBk3XfPVuF22sVlg4Syb9tNP6qDj04XkqojBqwFRVKaoqHoSaWkZyeoNcrzgjqjsKpL7HXT+qeDmTk198Zi/J8hF91ou/HN5mMMPf+bW5InAMYmDtePY/VfSX+Ct61kuh0lh/2zGkuK+KjVT8aFb4m4eY2LxjG7EPSH2N2FQ2sQhgyfS/yCpiR+mD7/oyIbFUWO1p/iGaFGZMK9OiSDSlrr22/05R5loOHEIhcX320+5dCLdQWPQFynKK9djWJhcff3CzWPA/FfNH/n11ryI0QOxAW8Ri5mdBbbavZNaHes4ie0fEs3GScAkYME73dStbJHzcxk9o41nNft4htLV3V3aW9L/yIFcu/NufplsHAfYO0Oi/F7uO3PBMPGAiv3WznQ81aaQuGMyx7OnFb/UbVync3fOgKeHiA6cF5zX2vjjHqTATWJU7fpN8HopUbIzU+zqlJ4wQGM9eIXSJoAmL46mMjLc3J6/hakYa4CHdsdt15c9BjBdg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkhMbXpBNi9HWjlvU3RLMlJXS2FYN0lIQUoyUzJhSFprZ2ViNFJGTFpuKzVO?=
 =?utf-8?B?UitSN0NSckliUkRHMHdGcTcyb083UStLazNlUUppY3QyVjczbm1zbms5ZCt2?=
 =?utf-8?B?cnVIR2FLT05xQjFMN2d4WCtMNWpZMDBYTzNuV09ieFB2Rmp3aHhzbGgrVm0v?=
 =?utf-8?B?WWxpUnF3QUFhZVQwSDBtWE5jazE2NjhNWWNnZDVvcTZBa2tzeWZuVnVyR05r?=
 =?utf-8?B?NThvcWs3aFRZcTlwZXltby9hYzZSQXp5NTZDRWM4ZmdGSmFyRVhES3hYcVdE?=
 =?utf-8?B?SHUyRnhjLzlsMk1PeHM1MXNDMCtCUExrZUJTeCtSWkh3T2hqTk9QZ3VXSXpS?=
 =?utf-8?B?a1VHVlpPaDZVeVloOW5LVkpTMWZ2Y2VSL0dRTjgwU2tuOC9vQ1BEeUpjRFUw?=
 =?utf-8?B?UGJnMFExWm9hRkNNWXZUN1RtS3hqZjNBWXYvWFdBNTR5S2syK3phOFQySUl6?=
 =?utf-8?B?VUhVcFlCeTY2VmJXMVFFTnVlWUYrV1YrbFo3bXFrZCtGbVlUTDlVc1czVjFX?=
 =?utf-8?B?WnZPRXhhUWZHWnc2anpnTTdwTytML1FkWnpvV25IQUR1NTg4aU9UUmlwNCtT?=
 =?utf-8?B?Ui9yR3JuNWJNVTRwV1Yyb3V3bHIveEUrSE5qbDZEdDhvVVJmQS9taHZGZ3Fy?=
 =?utf-8?B?ajRMSGVrSWVZL0Y0YnU4VFJrZDBka01CVW9JRTR6YnZFVHhmU0ZnQTNwajI4?=
 =?utf-8?B?bmdRMFFZeWYrWi9EZ21HWWMxWnFXcS9TbXBCQSt6dTRyam5IaGdXVVpZWjR1?=
 =?utf-8?B?REVWc0VJYzM5b0xxRTVaQloxMkh0L1VpaTdHY1A0ZXlWUjRhSGdPVjI1MVc3?=
 =?utf-8?B?RzlBcVpHMXlsWXRTa2hNUXh0a0E1aFY0NWhvNGFTVmEvUmpMOVlLRUdNYXNl?=
 =?utf-8?B?L2YwN1FlcmpiREN0MlUvYXFNL0t5RTRnT1FnRTYrUmdESlpRL0Y2YjFtQjdE?=
 =?utf-8?B?d2dPc055bEFvVHkzYVZYN0RKN0s2NjA0MXdoREZlb3J5R3RXZjVpNlkyRTRH?=
 =?utf-8?B?WFdwMllsOVVXQlRBT2dUaHEyL0lWVzh0d2xDTFFBK1pHZWRQVS9nbU9mZEt0?=
 =?utf-8?B?QmMzV28xUWxoakMzdXZrd0lUSUpqZStScGNoNnBjODdZWE0vWjZKdnZsWEN6?=
 =?utf-8?B?OFE5bDJDRGFmKzFROFYwV2JrT2xNSzRTZy9md0lvdFYvUERiZU50engzMlVV?=
 =?utf-8?B?Qjh2WW1oc2lmTjAveWtxOXRKNlZqaDFKaUQ1QnpwcnhIZjIveWhXdk0vc0wr?=
 =?utf-8?B?RngwVHNHYUd1YkZ1TCtKOWRtWnlFcUJ0ajB1NU5VU2JXQ0JRS2YzV2xjSVl3?=
 =?utf-8?B?dXdTd1JkU3ZJNXVBTEdJMy9nTG9wamVOb2FJcUlnWWVCV2tLUjJxUnJxZGdH?=
 =?utf-8?B?S3JzQ2NQV3dsUHdWRysvSU96aFp5TTZncFZQQ2lsSnVLaVArMmFwUEZ0YlR5?=
 =?utf-8?B?aU5zaEdsU1BPbkFNUFJPVWhUOWZqOWRxeTFKR3FQbVFiTWIzMWxYaXRXOFlk?=
 =?utf-8?B?Tit3N0JROEZxemIyNm9RSXJNYW5iNll0NEpNUHU0NmgycEV1OElLUVYzMDN0?=
 =?utf-8?B?Y2NzSmkxR2lGWEdqYkR0M2xiRnJ0elNLTVlnK2I3b3NpU3BDN1R0M3I0YlJT?=
 =?utf-8?B?Qk44Z1FjNmNzQ0Y3c1RjUHFLT1pyRE5wWVg5MWk4dHZCaWJLc0tIQThFTS8r?=
 =?utf-8?B?dGNZQ1RKK1AzcXJpdCtxZ2R6T0ZjZUl5cTZWVFQvUmtidzM2Tm05c1ZuOUIr?=
 =?utf-8?B?K3c3eEY5MGxxc2tGek1BblBlNmN6Yk5xeWFSdis0WXducFQxMXdraXAxTTRo?=
 =?utf-8?B?Y2ZJQVliR0RMRDk3TjRSWlY2QTlCcTE5c1IwemNxUWlWaWRTMk1BUktFeTB5?=
 =?utf-8?B?ZVh6eDdKWDlyM0lqWFd6OXpRbjlnbW1FNHhKaWtsazI3UzRaMUwxbzkvZWxv?=
 =?utf-8?B?Y1hOajZKbGtiYk42T0Framtyd2p1TCtaN2tybXBFc2U5MkY3RmxBQTNOTjc4?=
 =?utf-8?B?cEl6MFF4dDdNbmQ5N3VLcEdGVGd1QlNPRG9kTUQxSkZhWlVhOTc3UVNabnEx?=
 =?utf-8?B?MDREbnpKZUZtL2JHbVdtQ3NQeUE1UFM5K3JWK1M2aVhpeGZCdkYzZlgrVDNy?=
 =?utf-8?B?S1M3Q01OdEEwUnZ5ODBOWms1WEt3QXlHU0NUcC9JSDNmU1d0UEZpMlFnWkEv?=
 =?utf-8?B?ZkFrbnEzWHUzRmttSm4rUXBUMmhhdnFSTDhGT2g3WHdZeFdmTncxek5FZ3A1?=
 =?utf-8?B?dWloT3lWNmV2RGJMRk1vVzhzTkRDUlFZSlU5cmdHUDJLMGcyZmV6Q0NWREdN?=
 =?utf-8?B?RGdkNlM5UU5tN0FPd2dQdkpMQXpRYlpJOCtacENkQW52OTFrdk11QT09?=
X-Exchange-RoutingPolicyChecked:
	F3A5xj2496xte2PoTIiBuI3P/qawuD3IUfpJ6+sSJT5ecJihkl1k54JkLltcLhxIlceV/HaW96sPk4b7viRUAWp2lKKBOaoURPeT3pEQARMnY91kw3ixMlxtpvUDSg1XHJqH5oYMUykAFQqZqzn54VZfqqwtqfDrr08mWMglfjG32nIdNvc5kIsKVUZyqFxPEOUP9BFhhBxjkCIF9DjejCcArNi76WJclN12nBKfq7fNbgPptTcZcqCOYJTO+REiZothyEOOHCU5cDQhKXchZh1RvLgScRNBQhF833BqxzPozZpoNz/C8orNP7/rkNWJYYFyX2d+ExNnOQfx5e4Rbg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cacc2eb-2d82-489a-7103-08dee14dd906
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 02:16:00.6741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jb8JnHQenCPzh8F6h7jwlzkY+Z72MMNqzvfhVYUqT9LRYkCDKo0377e9njozFaw4jO4RlZRejQazmC8zsNzNeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5972
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDAyMCBTYWx0ZWRfX/ZBWQhefeID9
 NdU9mdN2v6qgdPpD7Gmk1rHW9sozpeDOENHPRvsBTbB6B89DBG5hJrwwIcghjxy2OnvThG7ikiB
 lkdEXHcOtn5FbBYoBPwiqa8lx38o/NJi9Osgpa5S5ijYpfhQvBZ44Ltg+A4KYzKl0rJVs9Pzi15
 zHkZe2RY4yAn5XR+4W/OKRjxuakBbCljm4X7QyQXBURVepJW/61puez+0NVvS2z1jyR3niXWexN
 1B8b2G/H8JNNs/ZUsZ0lLjsNnY9I6A+KkYEt5Zn+UODhjcULObVZFfIIYiJjvix9fIlCI2fvF8R
 e1LIzADkUtBfOxRwuFhY2cRcBNHaIbT4VO75FasIS4wna7nUtgWc3MTZo4DRk8QUu70y40Lhu+b
 +7fq6NVktt/lRC/YEk/YFdcA1bSxZdGcZLznsxk1gMQPskS1aj+66K33ePlnn1aDgRVLQy28X4f
 h8dJ8WK9Exh2jKhuEJw==
X-Proofpoint-ORIG-GUID: L4GXPNVxdPdyo9CH_BJC8GomobYeuIa-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDAyMCBTYWx0ZWRfX2XvPqyEkk52s
 hYj/vTyaJ0KZWkVR3zQeVQ0SK5+1SCnRPhsAdRyGOUA/csujR7ItzOkYmpFwksuyXADWEm+u0mf
 Wde1SUSQhpzw23VizkANX1W/LTTcTIiX4NT8iOSWzqvlXh03c+gl
X-Authority-Analysis: v=2.4 cv=JbGMa0KV c=1 sm=1 tr=0 ts=6a559be4 cx=c_pps
 a=C68BMzITeltispUgf6+s6g==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22
 a=yh85VzBO6v1jptUgHDYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: L4GXPNVxdPdyo9CH_BJC8GomobYeuIa-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607140020



On 7/14/26 07:04, Darrick J. Wong wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
> 
> On Mon, Jul 13, 2026 at 06:28:38AM -0700, Christoph Hellwig wrote:
>> On Mon, Jul 13, 2026 at 06:06:38PM +0800, Zhou, Yun wrote:
>>>
>>>
>>> On 7/13/26 17:09, Christoph Hellwig wrote:
>>>>
>>>> On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
>>>>>
>>>>> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
>>>>> index 7bfbd9f6f0df..1b36cf12d4e3 100644
>>>>> --- a/fs/xfs/xfs_trans.c
>>>>> +++ b/fs/xfs/xfs_trans.c
>>>>> @@ -1029,6 +1029,15 @@ xfs_trans_roll(
>>>>>          * duplicate transaction that gets returned.
>>>>>          */
>>>>>         error = __xfs_trans_commit(tp, true);
>>>>> +
>>>>> +     tp = *tpp;
>>>>> +     /*
>>>>> +      * __xfs_trans_commit cleared the NOFS flag by calling into
>>>>> +      * xfs_trans_free.  Set it again here before doing memory
>>>>> +      * allocations.
>>>>> +      */
>>>>> +     xfs_trans_set_context(tp);
>>>>
>>>> The tp assignment above now returns the incorrect transaction when
>>>> __xfs_trans_commit fails, so you can't do this.
>>>>
>>>> Otherwise yes, this call should move up.  I don't really see how
>>>> it fixes the syzbot report, though.
>>>>
>>>
>>> Thank you very much for your reply. The tp here is a local variable only
>>> used for convenience within the function. The caller always gets the new
>>> transaction through *tpp, which was set by xfs_trans_dup() before the commit
>>> call. Moving tp = *tpp before the error check doesn't change what the caller
>>> sees - *tpp still points to the new (dup'd) transaction regardless.
>>
>> Ah, right.  Tis should be fine:
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Why not move tp_pflags to the new transaction in xfs_trans_dup like we
> do for the deferred item list:
> 
>          /* move deferred ops over to the new tp */
>          xfs_defer_move(ntp, tp);
> 
>          ntp->t_pflags = tp->t_pflags;
>          tp->t_pflags = 0;
> 

That's what the old xfs_trans_switch_context() did before a1ca658d649a 
removed it. The problem is that setting tp->t_pflags = 0 means 
xfs_trans_free() calls memalloc_nofs_restore(0), which relies on that 
being a  no-op — an mm implementation detail. A fresh 
memalloc_nofs_save() on the new tp keeps the save/restore pairing 
correct unconditionally.

BR,
Yun
