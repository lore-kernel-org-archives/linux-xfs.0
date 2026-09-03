Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE214AFE3A
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 13:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443614; cv=fail; b=Ss0hZjtxB9v3EqvmaBdqDnIp06ImgwQf+ZyvGlxY3zRdizAPg9SdWCJqyebnNke6+edNGhkRv0c3Bov+QZL9eGdUwnVYqZsCPUmTJnKbwrkacAStfIF2G+IDhhkZsPdH9KdoqAbqWhuISADPjBlCCnbptYVgskxOXd96NDHdfAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443614; c=relaxed/simple;
	bh=3CqDVAGM0XTqaXhtwqpQ/0grXVrFZbx6T/cF1jy5pBo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O8SH5fQyi3/p/G+gfRT85dAVy+7vWrfibXmJsoxwadN3xO4b+M1N5ffTgOURJSzjCRGVKD7W8mtFTzrWTYWfHzQEEbDQ9QWKkxg3kl++CywXQOJ2Z3oxWxz0U8q22mN9atf1m2V4e64fctC1sCVFMQfS095mu7XW46mYUjdTERo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FYNyGsfQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=te4ZiVzB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FYNyGsfQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="te4ZiVzB"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683DqtFd487805;
	Thu, 3 Sep 2026 13:53:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7/faP18abaxbLXng27sTYmdEPkeGMVFqWD+n5t3zk7Q=; b=
	FYNyGsfQiF8jvPvvWdpCC8BIT3z9+UivEs4fyAYN3wFNICUvTAs4gSwH9ezTILGN
	JgwcJs2cmYvvyhTJYGnk7zv1/MiBlDRSFwFmvcg6HtBYqmSP3RPGj0Vhs0HniZEV
	bLTDY+n/os2FrSF5UPTJvA/+Xg4141+9mZ/Dmdx/Do+P+2QPiLlH5AiGgX+WGAqU
	f38bs64snoYouLqN/8FVpq5VoJR3LL8biGUnRi4Njq21biH+zD2TaCesapEkyDUB
	BserbIB5z1icr0GIZxio9NugCmOkXjJefDGHUdSsz+xb1b/aeSqhC2uuFMA6fCeV
	BHAw4c21rzT0P+hJ40Odaw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbq1ss0js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Sep 2026 13:52:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 683DoA63020802;
	Thu, 3 Sep 2026 13:52:58 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010028.outbound.protection.outlook.com [52.101.46.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvh4sya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 03 Sep 2026 13:52:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TbWfNgD33v6F5v9v67+389r1AECvNKMYnv/3TYLuZvEdbOeL5ZIUkJhIp0DmQisjqgfQ9YLwks7R1gyOy4n9sU5XXaowBBIgZMtqsa4r5KKm7gZ+ozY7VqRBczbFXKh4Pj7j7KcIj2E61HINsszY550KqDOg01FwP/afUZryVdVm230VHAJpmqVEPsiRE9zrdU/CJh/0Ot/uxT0i2xJYZOyAI0HoMpz3niaQGph/2IYhQpoHtwCU5S2Lr0QBreEr5/kQoPRFp8pZlKanOR7DrLrcd4b21BwYsjAYtLTNkSIxgRCgVY9dk7AvS6UKesAtVrDVb0h96Orc/O2CVdis6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/faP18abaxbLXng27sTYmdEPkeGMVFqWD+n5t3zk7Q=;
 b=df6EElsWoRkiIxdwDjgRV2cIZ7YP2kcO4rVMMBHcRiDDXFVw8q6vYWQbrZ3joeZWOYP7vtAryRTu1PcxNw9A/MvH54zs2veTVliCs/LH7bzUD8DjWjQncx0BhRxgPkeZXL+HfmeTmRG+k5rhZ/eTM5cgI0Pf9Y5zW8A4O/9zGqb0VdhOL+1mGmpVpwEHPsRQ4fCHK5BJLqSzTCwLc2b7PzylyWixAzwrITfSMaDLbiTY3qabc+odi1NpRlSZHuw3ENEyq1G/j4f8DtAqZAdGcEIMxnbXmIH98TzlVArG/bBqIT7jgOTlJmzyb82E/eiTdklNKe09xWrey8HDtrr8FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/faP18abaxbLXng27sTYmdEPkeGMVFqWD+n5t3zk7Q=;
 b=te4ZiVzBQY5SUYc+da9UGG2fiL+HwLbfxoqKGq97M2BBf/hXYoqJhmKjqMOxQsBrgBpp9J+XfyVouLQu1Mf99bpbw/RFeZS1/8HPKQoq2Geh69SaftJtiB6Fql47sg8Yc1hUgM+AWfMZVBx+V8LRRog6YFTDn2ClmW0HHYTu1ic=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by DM3PPF3F503E3E3.namprd10.prod.outlook.com (2603:10b6:f:fc00::c21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 13:52:51 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 13:52:51 +0000
Message-ID: <8fc65356-17a5-4bee-aeb1-62c74cc2144f@oracle.com>
Date: Thu, 3 Sep 2026 08:52:49 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH V2 00/38] XFS: Atomic multi-extent operations
 via rolling transactions
To: Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org
References: <20260819001442.1451892-1-dgc@kernel.org>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
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
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|DM3PPF3F503E3E3:EE_
X-MS-Office365-Filtering-Correlation-Id: e5d057cf-8098-4652-c002-08df09c2a567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|4133799003|6133799003|10067099003|56012099006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ix/0o4cCwCdg2xY65Gfa8qPGC+89vh0GxYh1ncz5LFYGWb5aDoYoak88HwE2BEd+bbDWI+U+GE4Ck08p0oheqZTX28MYIJpg3QAqGd+DsMWZkIpCUWbz/pwPICVK7QLARunmSh/XUji5GVSb5VyM7oSdCX863Pnt/ziyPZdWd8JhbLcqUN6RYDhiwhCHcj3sAowQrZCd0H63kWKMYBsUFeLbgJ9/e9IoNsGLLcmC1tWXqN9J1y8+K9+KhB6tKyGly5E8mJyqwWy7GycC/KFitCju1tuBw0tRv6W8m0Ok3s0VCO99TZUYxHtJFD8iF8rzRKiXmvUbNMNXIX3TpnvjZ4VSQKovxxlHLqfyGgzCtG2ZxibJeBHvg+b2AiWqRPL1DPHKgdxFdP9nTgndMOFuQ+WTmpDNCmqLjxRQQlXmoyjfcmMpUy0BcMTeo7kMbj4cSRlKxd5fsnib1PqsGHaQaZTf+mlSbTEfTY20BZ5vGorHBT0Ff1mzrEQBeG6dbaxrBvZyII24tuCESwHn4VdK8Y6VDmvIRDnrgSDi6oVv6XungiH4NQDm3tE3fXznP0eAxk0KfuUlyDMrBLigO95yCKbw1cXSmFKURl+7paYMnCt8WhGeiCCkAYUkYHR5Y/f4HQOeJ17PB8sld6FwGbiWetDxhisoOWNobYUzd+hDXa8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(4133799003)(6133799003)(10067099003)(56012099006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFp1a0c3N2txOHQ5VzR2Rlp6SzRXY1Y0alVmSWhFUEdja3BUL0JMdUFhTWdK?=
 =?utf-8?B?NzMrdjk5Z2VCclBMUloxZGZ4cjE4TTB1T3BrZmxCcGRqTlVzTnllZzE5WDRt?=
 =?utf-8?B?WkVxb2o1blJ5UWdvQmlFYm1FY1IwKzhiQS9hMFBlSlFUdkJtUlgzNEJkZytE?=
 =?utf-8?B?U2lVZ1NMTHphUUVqcnFreFdiVGFwY2p2dHN6K3JCSzNYNmRIT1c3ai9UNUdN?=
 =?utf-8?B?L1JlMFppRGI1THkvbkw4OUZ5V2lPb0hiQStLc2JBQXBRYmNVVUZzUEtpalhO?=
 =?utf-8?B?TVl2U1o2aERlODVZdUVaWXc1ZlY3VUV6TDFJbm5MdWFRQ3hHMlJYcWUrSGhI?=
 =?utf-8?B?MzdLa0Z5aGxkU2tkTUZzb2hTYXJlY0ZjcVZjK2kzUU44bEgvRzBYVnMxZ1Zo?=
 =?utf-8?B?Tk8ycURGd0VraGdYRkIxRUgzbGpFdFRIZnZ2QUtnOXRFeEpSODFkb0E2ZWtO?=
 =?utf-8?B?RjFHYjFVemFSVDYrbjd3bk5taHhhWVhyMzN0bjd2b1YyVzZ3SHBoMGUxOGNG?=
 =?utf-8?B?TWUwemdpMEI5UUNUanNNUENkNTZab0htT0lKQ1NYV0VyMnVGOGl4bGUvOWVo?=
 =?utf-8?B?eVFZZjRsZjFsUkZPaVcybWdwU0VJVkJKZ1puUDRQZXJMQ0xHeTE1QjFwQVR5?=
 =?utf-8?B?OWlqaFNNV2ZNYk1IcGxLWW1VQVdVQVZONTNuM0FGK0VFNEpidnFaRHF0U2RG?=
 =?utf-8?B?eDNTZ1p4dThzdVErUFlnZnFqc2l4b01JMlNsbVR4Q0REakh6OGxKNEJsVm5C?=
 =?utf-8?B?ZXo0TWdUemtCVW90RE9vOHJReUYrT2hxc2tjWlZKN2RUSHJmVkgzU0ZDWS9N?=
 =?utf-8?B?UjB5bDhUcUV5R1IwT1p0aWdEL2NDc3hWbnowbk5iQTd1RXZ4SmZWWmxyakJ5?=
 =?utf-8?B?a1Q0cE9BZHI0b1pHc08wT1MwdUhTWVpXa0NmQ21vTnFzdU0wOUxDWGlMT3I3?=
 =?utf-8?B?UkFGanpRS0RFM0lZR3ZSU25jM0hnM1Z3T3lmcGlybGpuMVRxa1orME4veGZo?=
 =?utf-8?B?OVlDRzg0b2szOVo5NVZlMUQ4T3U2OVZLRmVQY3FXMG1RcVVMNVBVR3BBTlNG?=
 =?utf-8?B?RkQ5YTdlWWhnWTE1aWJHcXNyUlFvMGxxUnNSWmZvYVpoQm8yMWRhVnlzM1Bi?=
 =?utf-8?B?QzkyNDVpL0ozT0hhNWh6QUNkSmp3Y0FvTHBhNmF2WnJsSGZpUmJwQlBpc2wr?=
 =?utf-8?B?bjBiTm1yUGo0YTEzYnhWN3NVaURjdWdYYVR5Y0xhUjk1c01xWXV4SDl2QmVE?=
 =?utf-8?B?SjVXZmhOcEdhVUllN1pLSUFQZFlxRW9tZ0d6MVZ4cUdyVHliTmtiY1BUK2lZ?=
 =?utf-8?B?YTNtdlRYTGY2WHRpdlhnSWc4eG0rVzdRL005VjhYTlo1U0EvK3Nrdlc1NE42?=
 =?utf-8?B?d2F0TjBkOVBWMEYvM3Rwck9nTkJ0RFhVVFpXN0diM3k4TDdNZUFQbm1pOWZD?=
 =?utf-8?B?bGdaeVhYaEEraTF4RzZjY0xLRzZXMTBoTVFncmtTWThLVWI1Yk50SzBwUEJ1?=
 =?utf-8?B?OG9FY2ZpSFo1RmlteWtyM0huWk4xVXdFais0cjU2N3F3cGowK2F0NUhHNUF0?=
 =?utf-8?B?QjZjRThSVkZ4anBlKzRUSjhwNDJDOGtxeG1wTUpKTXFJTmJiOXZiSGpaa3Zy?=
 =?utf-8?B?MkRHYmNhVURrNUpTZFBFZm5FYW9sSEp2K2ZDZ2VscDFTYTJ0dHdDdkdRUk5x?=
 =?utf-8?B?UlZNaWNCeG8xY0FVMFhPREFlOG5Mbmk0L25Udy9uNVJtT2ovT21oZFBYNXQ4?=
 =?utf-8?B?S3llUXl4SmRsZWRkNXp6ak1NUmJNZjZNZmtGVHlxUDZrQ1BPMi9QekhmMUk4?=
 =?utf-8?B?TUtFMVVwNHlRaWNJSjFIbWZkSW9jalN0YkVmR3J6cHhtMXFlYjNCTkd3UU9p?=
 =?utf-8?B?OFltOENrekVNekYxSElnYng2UDdHalpxMHpxeXN6eWwzeFNnYkFJZ3lsb3Bu?=
 =?utf-8?B?THFSbHpCZHFhUlh3cXdralhuN3ZmaS9MRFpVZHc1YWlxUlBOMW1mYnZMTHF3?=
 =?utf-8?B?bWxSN2psVExpWERUenNlcWRFbGcwdEdWMWIyS210d2VGdFNjNUY2cE1kWjRC?=
 =?utf-8?B?SjNrNERTS2tqWmpXSTZUcjBaVHo1cVRqenBIaXRMbHpXWUtBNVdrT2VhSzNC?=
 =?utf-8?B?MlIxSTN6b2lqNzRFRmJIdWZ5cDduTnA4RExuT3NlNVNWS2xMaSsrUHg0QW9s?=
 =?utf-8?B?L1VKcmR2aEdqY2paRVArTEpHL1Uyby9kVGRBSGdySXphckEwc0lBbGRUR09U?=
 =?utf-8?B?RDNyR2ZaU1VyZEw2ekVpaGE4Z3dvNzI3UVJlMFJpKytLVGN3akxsOG1NOXcz?=
 =?utf-8?B?cVp4czI3YTd5Kys0bXk0UmdHUk0zVEdidXNrYzRpR1NNOCtLYys5OUxQVlpw?=
 =?utf-8?Q?L5iSmkrhrNlMG8Mk=3D?=
X-Exchange-RoutingPolicyChecked:
	j0t2vnz6lYjILF4/zhDEEYXhBBS0t6+XuPVkFnw3QiI5yfvpH9tDNAH9TgQgQEJPfxQ+zAKrYI9UF6SZHPi38htXFUQCk+lNQF/Jb+Gm67z1qMcXN/EbYzI8hZ+gm8tSJrd/LDvJ6X8CIyKOOC72Y4TMJL0j5AC/dFR47IE4mGo2nOfdMZa5IDrJXfglc4RxrnB6eKKTMm/H1dFR9Uf6wySaATRcY6kQYfbhqzBaTNwj5y4riP8uAotCHwu/wk2Jhi8NCVk1smdNAjcnlGB2MeBldHkiTCE4NZthM3i+LEiLpwPZbc/1OJSaaKj1FjLichCy/eRB9+Q2gq5Azppv5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hU9B6TFg7Obl5bSdNlRs+g+JKL8Nfy86I1TyUy/mwL6tgtvo6e2758opsaP5DGdHT1HirBBwiJKlCnCX9d5TH6OC5B1b01mvkW4fG+2E4RQO7lXjMsy7Qo2Ox9kRZjaDzmrQDiuQ9l51q7sbo+YT06/9DwoqlpnNa2asX0LRWbRbrJrMeFdBeJbed1Y+ydfyWcWl3ZKiDcFBp6NgdncrBaJ4zxd0fNpLN9xm5v8EEOCQ0AmaU9fGHojCpik3981GE5c+eP+2J2A06E+It9rdR4Lv7iq3vEoo84Rw/OAaXN3rXvC1G/tKVRpYDbkbHZNYUmS0In4ljq5cgEToY10t/ASphovggOW9t+A3EG5295oQSpJnzWlzxn7zLHUqs49h2syaY4f8uyUlfjINXsQwvBGcbW0LsfRhCr82BnU0pJDCmYSOIH0/1AOzS498DhLc1qqL+Z/cFryoxhj/nDB/v2kkbmT5Ja0vZcqdAduumChzVAn2uCbrtNldvAPbzBF59BXFB+LtYB/d+NGJ9QxeO0kLOEP99BSXz+6/M9fLUm5hQEoBSqlN6TYEMzXS2i0kOuksIxk9VnI/UIPYO9tQzvxVJsa8+X9++OeOSJwV1Bw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d057cf-8098-4652-c002-08df09c2a567
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 13:52:51.6748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQXhSSju0gQQXU5XclOej2FbPV7iGh0Jyef5zqQcjE40JHvUPKreU/mHiHSobh6Psg36V1hx/PGqnOvkykKweKmUp3ciBgYviDHLX/6A9d4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF3F503E3E3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_04,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609030120
X-Authority-Analysis: v=2.4 cv=Vp0Txe2n c=1 sm=1 tr=0 ts=6a997bbc cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=KLpL4CyeHRiMfhPfwVAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDEyMCBTYWx0ZWRfX9pl2ShokzL/x
 DNrI5JjOmX6iSSYpxq2/WQ/PJct+IOgK9ll2/Sz7ZcFgKBnKP2wrPXtpeK2TH5jt3v/XMyLkn8A
 WmEOJgRw0+bzcTBl1LfIwRAi27bEy+MSJmVtnfEOLKlVzmqJdntwHxqN3UeUmpKlhIMnVxXuPpr
 uzOzX2EfZV3C3MzTxCIjYFFqxYwLV1TXaIsAyze+TQNZbWUbBhKWhTktNzhnRCV4QJ7YSb3cDtL
 47aLZndbpWQSJ8fNdw6Ky29G4xXx/vw7hYcPcxYHaTjY+P9wrpZ7MM6dEHdkJQOUfOGjo01avZw
 M2U9NIzEWvlLND1dsbwhGLGM73uDR81uCKd65mh2dLtdjGmeJy8C3p3HGoXBuGqAdTIKkdC0dO7
 NJ3rCk0WwnwIbtaerPuC1H3sAGmDLTM2DaFlbEmb1rKmJKYhCFdt3cR76mpsfxCqBiYfU6p0N4+
 2mndQIFnpSv/3p1h5wg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDEyMCBTYWx0ZWRfX+7/McKPzZJeE
 9o6GyPHdHZIZquBDPCWYxvl+4LPaFEFzPSyRirZW8PW8YSX+gG+ZkVsbwTHMuGOhSPYh6QTLIg0
 VPvjosSfoH2H6HZDZ2T/DQItE6OUXmP1gSRQXjipntBNJwlvTQOi
X-Proofpoint-ORIG-GUID: ZYpDIV6q56LLGQnKkio2tqKJknWHvg_0
X-Proofpoint-GUID: ZYpDIV6q56LLGQnKkio2tqKJknWHvg_0

On 8/18/26 7:12 PM, Dave Chinner wrote:
> Hi folks,
> 
> This is the second version of the patchset intended to address
> long-standing races in extent manipulation operations throughput the
> IO path. This series addresses the underlying cause of the problem
> Darrick recently fixed in commit 2f4acd0fcd86 ("xfs: resample the
> data fork mapping after cycling ILOCK") - that extent manipulations
> are not atomic w.r.t.  each other and so can race in unexpected and
> unpredictable ways.
> 
> This is not a new issue - these code paths have been a source of
> data corruption bugs for a long time. We have several outstanding
> bug reports for intermittent test failures caused by warnings or
> assert failures due to unexpected mismatches in extent state
> (delalloc, data/cow fork inconsistencies, state not matching cached
> imap state, etc) that have resisted attempts to reproduce reliably
> and/or find a root cause.
> 
> Hence I decided that it would probably be a good idea to do the work
> necessary to try to address the underlying problems to try to get
> rid of this entire class of bug from the code.
> 
> The first problematic pattern this patchset addresses is this:
> 
> 	- lock ILOCK
> 	- map extent
> 	- decide what to do
> 	- unlock ILOCK
> 	- allocate transaction
> 	- lock ILOCK
> 	- do what was decided
> 	- commit transaction
> 	- unlock ILOCK
> 
> The issue is that the decision on what to do and actually doing it
> is occurring in separate ILOCK contexts - the decision and action
> are not atomic, leading to incorrect actions being taken.
> 
> This is further exacerbated by the second problematic pattern -
> extent manipulations being executed in piece-wise manner and hence
> not being atomic with respect to the range over which the action is
> being performed. And example of this is unwritten IO completion. It
> performs a loop like:
> 
> 	for the range {offset, len} {
> 		- allocate transaction
> 		- lock ILOCK
> 		- convert next extent in range
> 		- update i_disk_size
> 		- commit transaction
> 		- unlock ILOCK
> 		- move offset forwards for next extent in range
> 	}
> 
> Hence we can have unwritten extent conversion interact with incoming
> writes mapping the same range using the first pattern, and they
> lock-step through the extents in the range and the extent map within
> the range changes with each ILOCK cycle on both sides. The inherent
> raciness of these operations means it is difficult to reason about
> them and the races have caused data corruption issues in the past.
> 
> There are similar (but more complex) interactions with COW
> operations as conversion and fork updates are split across incoming
> writes, IO submission and IO completion.
> 
> What this patch set is doing is making both patterns atomic with
> respect to the ILOCK. Code that uses the first pattern is adjusted
> to return all the way back to the start if a transaction is
> required. We then allocate a transaction and run the entire
> map-decision-modify operation under a single ILOCK context.
> 
> For the second pattern, these are converted to use a rolling
> transaction so the ILOCK is held across the entire set of
> modifications whilst still maintaining the "one extent modification
> per transaction" structure of the operation. Whilst this was always
> possible with some operations, the operations that required a
> physical block reservation for every extent modification (e.g. for
> BMBT block allocation) require renewing the block reservation and
> hence can receive ENOSPC from those reservations.
> 
> Historically speaking, handling errors from within rolling
> transactions has been problematic and usually results in a
> filesystem shutdown as we can't cancel a dirty transaction cleanly.
> 
> Hence to turn these into rolling transactions we require the
> addition of a new transaction block reservation regrant mechanism
> that can safely return ENOSPC from within a rolling transaction
> context. This means we can only regrant block reservations when the
> transaction is clean.
> 
> When we roll a transaction, we have a new transaction that is clean
> after commiting the old transaction, and so this provides a location
> for regranting block reservations whilst being able to handle an
> ENOSPC error safely. However, if we are in the middle of a defer-ops
> chain, we cannot safely unwind even though we have a clean
> transaction. i.e. the "atomic modification" of the extent
> modification has to complete fully before we can regrant block
> reservation space and handle ENOSPC.
> 
> We only want to do this block reservation regrant when committing
> the final transaction that finishes deferops processing - the
> original reservation should already be sufficient for the entire
> deferops chain, and so by avoiding regrants in the middle of an
> intent processing chain we avoid seeing ENOSPC errors that would
> cause a shutdown. Hence we only process regrants at the top level
> commit in xfs_defer_finish().
> 
> With this mechanism, we can convert the individual transactions in a
> loop like unwritten conversion to a rolling transaction that handles
> ENOSPC in exactly the same way that the individual transaction
> method does. This is how the series makes these multi-extent
> modifications atomic with respect to the ILOCK and hence other
> extent manipulations.
> 
> The overall series addresses the most frequently hit instances of
> both patterns.  There are other code paths that have similar
> patterns that could be converted, but it's not immediately clear
> that any of them matter in any material way. If there are such
> instances, they can be addressed in future series.
> 
> The patchset is made up entirely of LLM predicted code. I review it
> all and correct any errors, issues, concerns, etc immediately as
> each new hunk of code is predicted by the LLM to prevent errors from
> compounding and multiplying. Thus the code ends up the way I'd write
> it manually, not the way an unchecked LLM would vibe code it.
> Mistakes in the code are mine, not a result of an LLM being used to
> write the code.
> 
> The series passed many iterations of the fstests auto group without
> regressions using a v6.19 XFS userspace, and it has survived several
> hundred iterations of the recoveryloop group without an unexpected
> failure.
> 
> Feedback, comments and thoughts are welcome.
> 
> -Dave.
> 
> ----
> 
> Version 2:
> 
> - Fixed zoned gc remap reservation - needs two extent add
>    reservations because a remap involves two independent extent map
>    modifications.
> - Factored transaction block reservation code to minimise duplicate
>    accounting code.
> - reworked XFS_TRANS_RENEW_BLKRES implementation on top of this
>    factoring
> - New async blockgc flushing infrastructure to allow blockgc to be
>    triggered in ENOSPC/EDQUOT situations where waiting is not
>    possible (e.g. in transaction context).
> - Fix ILOCK leaks on the internal error paths in various
> transitionary state patches.
> 
> Version 1:
> - https://urldefense.com/v3/__https://lore.kernel.org/linux-xfs/20260729100629.1943710-1-dgc@kernel.org/__;!!ACWV5N9M2RV99hQ!OUDpUFWFrW8kx2pCOnNdOwt3T-cyQBGwaliQx1GOGcZ6ExZnmwCOaHDbMic84e2FGDKgMShoCMe8Qq0$
> 
> ----
> 
> LLM generated summary of the series:
> 
> This series of 38 patches fixes several race conditions and bugs in the XFS
> extent manipulation code, then reworks the transaction handling to make
> multi-extent operations atomic with respect to the ILOCK.
> 
> Bug fixes (patches 1-4):
> 
> Four pre-existing bugs are fixed.
> 
> A dirty transaction cancellation in xfs_bmapi_convert_one_delalloc() where
> xfs_iext_count_extend() could dirty a transaction before discovering there was
> nothing to convert, leading to a filesystem shutdown on the -EAGAIN cancel path.
> 
> The same dirty transaction cancellation pattern in xfs_attr_set() is fixed by
> moving the attr lookup ahead of xfs_iext_count_extend() so the transaction is
> only dirtied once the operation is known to proceed.
> 
> An isize update bug in xfs_iomap_write_unwritten() where i_disk_size was set to
> the end of the entire write range rather than the end of the actually converted
> extent, potentially exposing zeroes after a crash.
> 
> A block reservation bug in xfs_zoned_end_io() where the reservation only covered
> bmbt splits but not the deferred rmap and refcount btree operations, papered
> over by the fragile XFS_TRANS_RES_FDBLKS workaround.
> 
> Transaction reservation and async blockgc infrastructure (patches 5-8):
> 
> The block reservation accounting in xfs_trans_reserve() is factored into
> reusable xfs_trans_reserve_blocks()/xfs_trans_unreserve_blocks() helpers to
> avoid duplicating the accounting code needed by the later regrant mechanism.
> New asynchronous blockgc flushing infrastructure is added so that blockgc can be
> kicked without waiting in contexts where blocking is not possible - in
> particular from within a transaction context holding the ILOCK, where a
> synchronous flush would deadlock against the blockgc workers.
> xfs_trans_reserve_more_inode() gains a retry loop that kicks async block and
> quota blockgc on ENOSPC/EDQUOT and retries after a short io_schedule_timeout()
> rather than failing immediately.
> 
> COW direct write atomicity (patches 9-19):
> 
> The COW extent allocation path in xfs_direct_write_iomap_begin() is restructured
> so that the extent lookup and COW allocation are performed atomically under a
> single ILOCK hold. Previously, the ILOCK was cycled between the extent lookup
> and the allocation, leaving a window where racing DIO writes could modify the
> extent tree and cause stale state bugs. Transaction allocation is lifted to the
> caller with a -EAGAIN retry mechanism, and xfs_reflink_fill_cow_hole() and
> xfs_reflink_fill_delalloc() are converted to use rolling transactions via
> xfs_defer_finish() to keep the ILOCK held across their entire operation.
> 
> Delalloc conversion atomicity (patches 20-22):
> 
> The xfs_bmapi_convert_delalloc() loop, which converts delalloc extents to real
> allocations, is converted from per-iteration transaction allocation to a single
> rolling transaction using xfs_defer_finish(). This makes multi-extent delalloc
> conversion atomic with respect to other concurrent extent operations.
> 
> Block reservation renewal infrastructure (patch 23):
> 
> New XFS_TRANS_RENEW_BLKRES transaction flag and xfs_trans_regrant_blkres()
> mechanism that automatically restores the block reservation to its original
> level after xfs_defer_finish() processes deferred operations. This is needed for
> rolling transaction loops where each iteration requires a block reservation for
> btree splits.
> 
> Unwritten extent conversion atomicity (patches 24-25):
> 
> The xfs_iomap_write_unwritten() loop, used for buffered writeback and DIO
> completion, is converted from per-iteration transaction allocation to a single
> rolling transaction with XFS_TRANS_RENEW_BLKRES for automatic block reservation
> renewal.
> 
> COW IO completion atomicity (patches 26-28):
> 
> The xfs_reflink_end_cow() loop is converted to a rolling transaction, making COW
> extent remapping atomic. The xfs_reflink_end_cow_extent() wrapper is removed and
> the locked variant renamed since there is no longer an unlocked path.
> 
> Zoned IO completion atomicity (patch 29):
> 
> The xfs_zoned_end_io() loop is converted to a rolling transaction with the
> corrected XFS_RTEXTENTADD_SPACE_RES() block reservation.
> 
> Direct write iomap restructure (patches 30-38):
> 
> The xfs_direct_write_iomap_begin() function is restructured with a unified
> do/while retry loop that handles both COW and non-COW allocation paths
> atomically. A new xfs_direct_write_args struct replaces the long parameter lists
> throughout the call chain. The pNFS block allocation path is reworked to perform
> extent allocation and inode update in a single synchronous transaction. Dead
> internal transaction paths are removed from xfs_iomap_write_direct() and
> xfs_direct_write_cow_iomap_begin() now that all callers supply transactions.
> 
> ----
> 
> Diffstat:
> 
>   fs/xfs/libxfs/xfs_attr.c        |  70 ++---
>   fs/xfs/libxfs/xfs_bmap.c        |  80 +++---
>   fs/xfs/libxfs/xfs_defer.c       |  38 ++-
>   fs/xfs/libxfs/xfs_shared.h      |   3 +
>   fs/xfs/libxfs/xfs_trans_space.h |  12 +
>   fs/xfs/scrub/cow_repair.c       |   4 +-
>   fs/xfs/scrub/quota_repair.c     |   2 +-
>   fs/xfs/scrub/rtbitmap_repair.c  |   2 +-
>   fs/xfs/scrub/tempfile.c         |   2 +-
>   fs/xfs/xfs_icache.c             | 172 ++++++++++---
>   fs/xfs/xfs_icache.h             |   2 +
>   fs/xfs/xfs_iomap.c              | 548 +++++++++++++++++++++++-----------------
>   fs/xfs/xfs_iomap.h              |  23 +-
>   fs/xfs/xfs_pnfs.c               | 117 +++++----
>   fs/xfs/xfs_reflink.c            | 313 +++++++++--------------
>   fs/xfs/xfs_reflink.h            |   6 +-
>   fs/xfs/xfs_trans.c              | 227 ++++++++++-------
>   fs/xfs/xfs_trans.h              |   7 +-
>   fs/xfs/xfs_zone_alloc.c         |  47 ++--
>   19 files changed, 957 insertions(+), 718 deletions(-)


There is no easy to review this series. The really important thing is the
end result and the other patches are the systematic steps to arrive and
the end result.

Here are my notes as I did a walk through study of the patches.
I am mentioning things that stood out but nothing besides the comment
in patch 37 is long term important.

A very oversimplification of the series used the pattern of adding a
new NULL xfs_trans pointer arguement to functions that allocated the
xfs_trans internally and the xfs_trans allocation is made conditional
on a NULL input pointer. Then allocate the xfs_trans in the caller.
Then remove the conditional allocation in the original function.
As always, the devil is in the details....

notes:

patch 09-38:

  I believe there is a xfs_inode lock leak in xfs_ilock_for_iomap()
  error path in xfs_direct_write_cow_iomap_begin().

  patch 35-38 fixes this leak.

patch 17-38:

  The other patches that allocate the xfs_trans when it is not passed into
  the function, uses the pattern that local_tp allocates the xfs_trans and
  copies to tp and uses local_tp being non-NULL to lock the inode and
  commit the transaction. This passes in a xfs_trans pointer to a pointer
  and allocates to the local tp variable.

  This is not worth mentioning, it is just a series pattern difference.
  It is not incorrect, it is just not consistent and it does not matter
  because in patch 19-38 the internal allocation is removed. A reviewer
  has to feel like they read the code :)

patch 26-38:

  Another pattern irregularity where the local_tp is not the allocation
  variable but a boolean to note the tp was input xfs_trans or locally
  allocated.
  
  Again this not worth mentioning, it still correct and is removed in patch
  28-38.

patch 32-38:

  xfs_direct_erite_cow_iomap_begin() gets a xfs_trans pointer point and
  it alittle complicated because it is used as a boolean and as a
  xfs_trans pointer. I understand the function already has 11 arguements.
  This overload make the logic harder to understand but...
  In patch 33-38, the arguements are consolidated into a new structure
  and a new boolean is added to remove this overloaded use of tpp value.
  The comment that explains the overloaded value of tpp should be removed
  in 033-38 but doesn't get removed until patch 036-38.

patch 35-38:

  There is a lot going on this patch. It took me a couple stabs to get it all.
  I could be wrong, but is there a case where the dwa.lockmode is not set
  in the 'out_unlock:' path? Not a critical item since it is removed in patch
  036-38.

Finally the only useful comment:

patch 37-38:

  I suspect that you wanted to loop back up 'while (!dwa.tp)' and re-read
  the mapping after allocating the xfs_tran. Doesn't the xfs_trans_alloc_inode()
  set the dwa.tp, so it would not be NULL?

This builds and I found no xfstest problems but I did not beat on the series
beyond that.

I think it is an interesting change.

Thanks for listening to my ramblings.

Mark Tinguely


