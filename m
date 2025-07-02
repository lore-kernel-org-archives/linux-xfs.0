Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFC519D8A7
	for <linux-xfs@vger.kernel.org>; Wed,  2 Jul 2025 09:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751447046; cv=fail; b=cS7uj+QHzDqLj1GdU8MA9jfmtJDb6zfMVymjQdnrusP8IL8ZAzTOiOsIrunhi4Y8Yday2j5ggAqgqV0dACrpeeXlPivec9/8wqxGlSdsh9YGBCaJ5gs+ZzePrQ86QPOQn8Fnt8t3JM5+WVWIYjp2oiJe/if1rIcHm1gUsWjj4Ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751447046; c=relaxed/simple;
	bh=GN3opVx+bnBnI4Nz8OahSzC9UKsZKT0BJV7eMMFoogw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d1uBJ9evcdwWBM6ofBRyVSRUheJEPbT3cznnNL2yaLFKgvDRmgGo3eNJ3badWZJuuvyAD+2ErdrPoVg8/32WCEoq+jI5nsBboaubVSaBFeEFXOy3Grrxk0NpGlkSxkO2p3mYr1CzgPo4uDNMdehfC/TesZagotOOs9MIc50UhFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RoUP6YX5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HFA65yqv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RoUP6YX5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HFA65yqv"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5627MYs8025688;
	Wed, 2 Jul 2025 09:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=C/xRt6LZYoScFZlEumrujFdpi9Ldj4cZBrZqZ3XsX6Q=; b=
	RoUP6YX57Q9E17zWc/38qIuKrkSKTk7z894dpDtFuuCkSkc3L3plHJz0lrqpoBu7
	ABTXXoXGyrhsKBeCORtTdbo4XABYgbg/de9DAlVMqZhnb0yqi5vkcEw9HN23FuRw
	DzTTzu8eOOJmr5GucWcyX6wUSOWBrM8PlGaMuCx6RSQgq7UpcOaAvSbUuz9+nU9D
	AP/RxQT4QdEFux8959pHyvlx/jW+5ceSxGT0O6duYrAae0O6qnfvQ8e+1h8bihPQ
	r57iE/rnVYUazyKP3KIDBC3HrOgN6Sk41q315Bxt8KY/FHEVbbQstTg6ktmXgDKJ
	Oc/mrENogYiFSOVJYKA+8w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j766ehh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 09:04:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5628KURf019538;
	Wed, 2 Jul 2025 09:04:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6uapu63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 09:04:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rksyuEoxXbEg6WmYQd7drbUanM7Q5wb4WQBPnwmD1bmm2ZafaJie1e2/wKhKQ1kcjYz6LjoUNn7ocSpOA6UA5uxgwm6n8c9j6698QACUpeyDm5I1v+0mCU8pspbiK8UQoYsm4wCEJkhjbpF5gF28TxzHOjXXo72val5AqMdGInZrnJK6A6M6H0i21iapLlRONMhUWT2ex4l94wNP2I3s9eYcnPrJbYWJ8tyyyaaZrUO9UeRfpsSNZfwwLAbCyWzKMxVXMm8H7OlNzwW9H2O/H96jpeAJ7UY1oTjReAmWMvowrLofbHJX7gJ1F7ss9clBFslweS4Ws7h8s7kFxYNgRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/xRt6LZYoScFZlEumrujFdpi9Ldj4cZBrZqZ3XsX6Q=;
 b=lLKFYHWPluyNBsQJkKkqFM3PcORE5DkBdza8EbUD/I/yu5nJzpO2jBMz5XrPkgwe4nb4+Ccr2yFnFxVskAKnfYeEiOqNZ5HOXQHoA/lRGslZesU+dmsW6QafH6+MTRwMNM9fIHpRkdcnKQ7yAJ6NRcbat59CUz08pV9FqwM4RbTj2cO9BY/6Bb2N2fkVzmI+9ncsi93GcjvIm3LziFgeyQc/xGSf0f9kIZKdyUoQnMZOuZgpm/tfBdTzi78te9rlPy4mnQF4sTUYY+ksgjx4/0OJmMg+m2IKa4WXGK1PwMcN1RgvHzw2c5xKa6rXpaySd2rUc14n2G21bIus6sVpyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/xRt6LZYoScFZlEumrujFdpi9Ldj4cZBrZqZ3XsX6Q=;
 b=HFA65yqvZYIIfV5MvvGd/7LPhmpUs22GU0Uf8si05z9D7N1P038qEqUaiF99Z+r0d8YjJL3Y5LCy7rISRTvjYpMIMP86CPSkpNq1Ophw8BEwo+fYPN2ekytwVF/dqDmouT0k1eB0uMnKAvItstBgaJKbNnVv6psQ8wDOUTOPm/s=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MW5PR10MB5850.namprd10.prod.outlook.com (2603:10b6:303:190::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.22; Wed, 2 Jul
 2025 09:03:57 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Wed, 2 Jul 2025
 09:03:57 +0000
Message-ID: <3e7f8c3d-d4ce-4c5a-8de1-5c6bcf44c4d9@oracle.com>
Date: Wed, 2 Jul 2025 10:03:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mkfs: try to align AG size based on atomic write
 capabilities
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303947.916168.18334224285549571882.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175139303947.916168.18334224285549571882.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P192CA0045.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::25) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MW5PR10MB5850:EE_
X-MS-Office365-Filtering-Correlation-Id: 38685bc7-e3e3-4f9d-4afc-08ddb9476057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2p3WVBJKzBIVUFNYnpTQ3duOWNLbXc4by8vNm5rL3V2djI3OGNlbEJXaHNV?=
 =?utf-8?B?TTJDTURkbVdOUHVoWGNQbE9LNlRSanJoSlYxWWpoT1I2MzdxeFdLVkp5TkdH?=
 =?utf-8?B?SGd6dGRXNHgzUzZaL1J4eTFkMmN5MTJpWWkwU0tRbUxFR2NWVkprN2JGbVF0?=
 =?utf-8?B?TU1ML0VmOXBvaGNQdU95NGEzNWtMQW1OVjBPOXFCaWxLOFZ4cEIyN1Y0azkr?=
 =?utf-8?B?WnYzdFR5N01vTXhBWm45bGFFRlpPdmZWcTJHb1Q2cm9DMmFlSFVyanFsRzk4?=
 =?utf-8?B?YmVhMlBKQ1pKK2dCVTZ2RjNtSk5DSFozUWxZV25qS1Z5K2NpY2Q0ZXhmcUVj?=
 =?utf-8?B?UmtxaGZMeVJTSDVsR3Ewd0tWNGlBcGNjMHNHVGpTSEhrNnI1NXpsSUdFVGtG?=
 =?utf-8?B?Sm1Ocy8wR3l6ZVJrSUxNakE0M3U4Q2Z2YkRwd1MxQTFxMGpqVjZ2dHl3RGJl?=
 =?utf-8?B?RzdpMG1RYnZFTE42b3k0eVpTUzJJYnVRWmRLU0pOR05iNFlLSEExdUdKQXEv?=
 =?utf-8?B?K2tEdmEzV01vb1h4SVVEQlMvYW5WRi9vUndmYndsbERTR1ZSVlNyRFQxSXNJ?=
 =?utf-8?B?TzgwNXFxWFRRMVpjVDJaWEc0ZTkxUEFJano3Sk9HODRBQ0U4aTZGc1Zrd05j?=
 =?utf-8?B?Tm93KzhJaFFpS05hMUJFenBrcTluemRRZ3BVc1lHMlpNWi9DbEkyN0F2ZlFx?=
 =?utf-8?B?aW1NN3pCT2xaam5qdks3QU1HaHFVTThuQzgzRll2SS9wUjU5dy9DYmtYblQ1?=
 =?utf-8?B?MlVMbVo4Y1lGTWNmKzUzd21wTnQ2MWNmZDdhVlZ2QkhLdFZ0cEdXMit2aWhI?=
 =?utf-8?B?MHJuTXdSaVdzWHladjhYMXRDYUQ2QU9KL2Q4amR6NDFMZ0hWVnF0Ri96cERX?=
 =?utf-8?B?VjlCbGNjZnJUMFVwdjdpMlRtd0FNT2dIOWZaOWYvdWdpdTN4K1k0TUhIeGpk?=
 =?utf-8?B?OXc3OGd4UmVHS0pYbTh5ZHhsN21JY3dnbFpaZ1hIRGgweHV0ZUpQTUFFRDQ3?=
 =?utf-8?B?K2hHK0kzTExueS9tYlNEZ284RWIwc2JFMXJTY1RyWnJBV0FmU3pjYUhRUEg3?=
 =?utf-8?B?MUVYaFRIbEllbGJFQ0NaNjM3YWdVMUhUV0ZHcXZLVUlBL1p4aU93L2dodmVo?=
 =?utf-8?B?N2ZnRDcrY3Foais4SUZUbjFxaVhTa1QzVVZ5V3ZRQlZKMmFITXcvc1F2YTYv?=
 =?utf-8?B?U29iZjdkRUV0UjFPck96dzErYTN2bXpaN2htQUZFSUt0OWMxUGo5U1ROemJ4?=
 =?utf-8?B?S2VnSWVMNWdxRkRvMnArU0Z6azZqbGg0ZlduV0l2SElOajdlMEZmQzJaeW9X?=
 =?utf-8?B?ZCtUUXZvMTkzcnZaaHlMaktvdkZWLzUwSThaTjEvWGorYUpjSnJQZjNob1lx?=
 =?utf-8?B?V0NYWWJmekd0SlA5WU54NXhsem9MZkdIYVk1NythOUN2UFJHK1BjcW9ZWkJx?=
 =?utf-8?B?M2J3K0t6NHBoWkhWaS9MQkNKdWkwKytQMkZsQTRKblVNVkhFMm1PK1Qwem5Y?=
 =?utf-8?B?dU01V3pzS3hGN2gyQWl0ZnNiMFNYaFBkeENPQS9adC9nbzgvZnhKRVR3OHJW?=
 =?utf-8?B?VndLNW5CYndYVEdzbVh1bWdRMW9OeDdJNm01aDBBT1VqcUYrODd3ZC9HUFJJ?=
 =?utf-8?B?QVpmbzJIODduNzJrZ3NHUk5GUFQ2Sk1qUnJRdEFTSlQ4c054ZVUzUm1vdWtS?=
 =?utf-8?B?MGZ5bWRKSHFkZFdUY2NmUDVpNlR4bDJIVUM3Vk5wcm9TUFptR3NXSnMvZ0Iz?=
 =?utf-8?B?MU91eVhZTU9xSlRFNWkwdjBoeWFvOFBxMVhHUVl5cEdDZHMrVk5vbWpKemIw?=
 =?utf-8?B?MGI4cDVrU2lpdkw1cjZ2aVRvclNXUWdSMGptWmg0WkR4V1lyUEY3cllBWjdZ?=
 =?utf-8?B?S25sYW5HUzA2dzlUdHJuWGd0SUU2a1QyWlBaQUhmUUh3YW9GK1Q1QzQwZTFZ?=
 =?utf-8?Q?s5HABUWTnAE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjZpbjFGemR6YmpJemZvZ0plalhTRkhzek9JaXllenZzbkJOMHRqZjloWkpq?=
 =?utf-8?B?QkM2V2NrUE96dUV1cE12clVxUytZTVVQTFNNZEU2ODFjbkMzbDlRSzk5c2ds?=
 =?utf-8?B?VU55NXJ5emE4OTNCcitwMVRuMENRNSt4S3haSmd4Y0poVW5nSWNNWWtya0F0?=
 =?utf-8?B?SXBLVzFtMHR3V2NudDd0TzRtZ2srN1JRY3ZtaVpha3lKSVAwNm5hdktuWGQ4?=
 =?utf-8?B?a2t4cDZTOGJPWXhVdy94WlVkRTlIRVBacDk2UlEyNVJtUXY3QjZQQTAvd05o?=
 =?utf-8?B?aUJVRjBwVm5DRklFejFuYmFtcHk0ZWxPVFRscStqd0VnMkd6RmlkM3h0TmhC?=
 =?utf-8?B?YUVxL0ZQUUZtM0owTFRQTEdHRSs4bWdvSFpGY0hYZ1NsR0VoYmZnZGRETVVE?=
 =?utf-8?B?NXNnMTlJRTZjQi9YUTR6bTh6ZmNkWXZRcnBYQm8vZjVKdGhWeDNiUWZzTkRR?=
 =?utf-8?B?TWJNcXFkRmZQblRmMzhTaEc2ZVdDTVJ3Q2dRam9EV3E4MTZIbXIxL3UySjYx?=
 =?utf-8?B?U0tQOElBc0Z2YmpETWU5K3JHenhuWlJWT3RpemdTR2pzY0RNSm1BQVJnaHBY?=
 =?utf-8?B?bkJER3hHbEJuQS84Z2YrbzVTTmlHZDZWazFnSnhXN3Q5R0VxMVFoTHd6MXRU?=
 =?utf-8?B?bGltcUY1UWNNZkF3UDlEVHRJVWN2NHJIVGFrTVNySTdudUJlTERRbFZrS05N?=
 =?utf-8?B?dWZEZzZvUTNzSlordUlRN3JwVU85TmF2UDlJYW1pY0ZyRXFWMFM4TnhUeGRq?=
 =?utf-8?B?UGh0QnA5eUxST09ieHRJY2ZpdXh4MUgrL3hlOEVIUWZJSTdtdStwbGN3S1hW?=
 =?utf-8?B?NjFwYmNaQlRRR3NUR1MwYkRoanpBRThPa0dLZ1Jlc2ZWYzJUeWVtUi9sMkl3?=
 =?utf-8?B?Vk9aVHJQaDZCS3UwM0w5OTdPdkVZTHpiaUwwa3FLN2xNaUNjT040ZHQ3N2NE?=
 =?utf-8?B?RkFqaE9aRE9leDBUQ2RRUGhzcnFMTE9XZllqV3VvbHZHMWtYR0RaZ0kyVUtO?=
 =?utf-8?B?T1FEVkdvRDNBRjl4dlhhVUhpcTFJZk1FZVpxck1MeHFsQTBLTnUvSzhUaC9o?=
 =?utf-8?B?cXl0c1FDdzdpWlgwMFNaRkJFZlFzZDBLNGxreEtSdmZlVEhjRlRDWnhmT0JU?=
 =?utf-8?B?ZDlTWTJnbGxMd3JrRjhUbERjUUVCRGptQ2U5alRrWE9XeVU0WWcrQUVLYmlI?=
 =?utf-8?B?VzQ5WTljU053VVVlQyt1Zmwvd2dQaElhaGZKUTFYaWxXdjRTOVR2MkZSTmd5?=
 =?utf-8?B?bzl3aXcyZWVMOU02QnkrOEtHRU5xRnhUeWVlbDBBQ0RjdzF0YTBmUW5pZlpp?=
 =?utf-8?B?Y3RydUI2bDBMd2pPSHFqV0s0ZDRUQ281VjRzaStZRVZxVDlrOUF1cklHb1l6?=
 =?utf-8?B?bjdjd3RpajM1bWZQMStiVWZEbXY3N2ZyeStsVkJRYzhla1ZNMkgyS09mRXV2?=
 =?utf-8?B?S1NEYVorditxb0JJMDViRVZQQjQxRE92Y0IwSmJ0NFNRSkdycGQ2WllueWVV?=
 =?utf-8?B?SlNhMTA2SFFOU0lvSmNVQ3lQRWlndEhKZFNnbUM0UHhQRThPU3k3Mk9HdGpm?=
 =?utf-8?B?UzNqbWVnaEZDVDNOK0grSGdrYS9GeUhvenVMK1dNNFAvOTd0aTBEN1d6MlZL?=
 =?utf-8?B?eW0vME43TTBVLzdEb3RWd3BtZDYvMUZyZitRb081NzBPdXVHMWp1aTBYWkNl?=
 =?utf-8?B?Z095Y1pZWDJxcFd5SUhURjkzZkxHWkRRcmRENFdwbjAvbW5Hckx6UEZaalJY?=
 =?utf-8?B?cnBhN0VXZjY1UDZ3MXZYSU5FSmlJQjRzSnZnTi9UYzY5dDlycVpXMTYydmtj?=
 =?utf-8?B?V3VvcEF3cUpvU2N2TTZxQU9LVlN1STFKNEdRaWJCVHBIVlVESFM0dVloTVhC?=
 =?utf-8?B?VUxUMWtRdWEzZHNodVJQbTc1M1FaVXhQa3pidTdmNEVrWTdZejc3eVp0SHR6?=
 =?utf-8?B?QWpnUWtmK1ZqVHNoRUlYOWpKalk0SmY3c2t2NHprbHJnTEZENFJja0lMcjYr?=
 =?utf-8?B?VkwxeXFZZm1RK0VpT1RZUHBXRlhoZU9pTHNmd2RzWlliNlpENFFNd09oSzBR?=
 =?utf-8?B?Qi9LbEtLYWpVWDhXejNBMk5kaU5IbWs2aXEramJJL0N6K0p5d280b1dCL3V5?=
 =?utf-8?B?SXlFOWw3akRwdnhzSWxLN1RVRmdZdFFTSjFNU1FtV2hZRzVoL1dFWnd2cmN5?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a8biOX7RQpvNTMHmbj5a/tclAN9zoMR97FplL+CXNPyF47DShqAs26wb+hDZF4tX/RR7eLktf3BOZKACG8mnSaPoe7cVWuIPzCaGf+kbjVrhzAbuPXwabCEOiwhdtEv/DBL/r7LlIdo+hXhZEQO8wVtx/jxgF3d5v2ieXXjatJXicVm4yzJW7tGonpFhXzzjJnvahYnvrP2W3BJgOw4L20TchWDWJYxAveGlUo8BTvm9VxlB9EUu3uOZaQJrbXELzdoBYlGBvevwPvog838MynoQPldAAPSZ5jieGBYov9zHycxlrV8yEmOX4LdiS5Bl271gFdDgqCezwWua+wO/wcKXb1vbtu7cg7dDvmDFelc5tBAS4MDza0q0PTfP7Rv/CyVrXuZhclWdtOubyiDkBDlQxd24Dj8XZkzh6Sq6gx1F7idldHgMNwQhkpB2Uy1+rzPRLzlEml7p6kyXiKRT57pT/5Vma4ezX7zaP03wjM2S5MCjHxq4vnIsCklTrD1UxAg0mNlU0OGD7QtsTqwhTv+eHr6TJ3kETdGDZYutufYRc38s6ain1K1YtQhmu03sKRrV1K3oIJrpVxyqm4rPpD8zYtwSvz5xhbjI4P272jo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38685bc7-e3e3-4f9d-4afc-08ddb9476057
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 09:03:57.1296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dkz9aY3Csmj+cd6hH91GqRbgqOKgIwymxbfdBQVbELqFabzKjfbFkPSB8ViPCqwv/PHbRl0z2JtCbx6kE/7qIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5850
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-02_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507020073
X-Proofpoint-GUID: PJRFOJ8LZOsxr1LWJt8Y0VbhIn5dvGVI
X-Proofpoint-ORIG-GUID: PJRFOJ8LZOsxr1LWJt8Y0VbhIn5dvGVI
X-Authority-Analysis: v=2.4 cv=b82y4sGx c=1 sm=1 tr=0 ts=6864f601 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=qxBrUa7-4OxskJ2sVHwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDA3MiBTYWx0ZWRfX2572kje0H1cm 1wvFjduiWvFmHx7edMzUnZY+4laNX83DpaUNarIeazQQ5oEcjriK2XuWjdHxyepy0W9eD/PT60Z m9ZaQ9lHlE9SIk4AaPlt0ZwmuJhwzyR3AwvUPyGsEaR+TQcfZ2scliDBdf7lVncJlUpjiBrTF3u
 EOvcXKlLhFqjU2dUg887bLwwiWj6rg0ws8AZciD07QwL1xRr2YqZWh0yYAwdtFzRne0iLSVW9up +i3EIdbm/QtpboffCxb/K2rg14Asy9uukUPWOfRGQ+2Px4g+beNBLlx4ZqPg8Q/pd1EVbj9HhZ0 EVqWuCglyE8HWxl2Wa9J7YNlCS99Dqw5j1iJUw4L2QhzTRVd9LOtYSBS9SOZC2IsTqCmKA6IVQC
 s+0bt7SNHll9RDKC9FrnMu2Ul72P5/6JN0LhZvjDl8sGlqYYcJyA6TxbrT4vgE9kSxdauaxS

On 01/07/2025 19:08, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Try to align the AG size to the maximum hardware atomic write unit so
> that we can give users maximum flexibility in choosing an RWF_ATOMIC
> write size.


Regardless of comments below, FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>


> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>   libxfs/topology.h |    6 ++++--
>   libxfs/topology.c |   36 ++++++++++++++++++++++++++++++++++++
>   mkfs/xfs_mkfs.c   |   48 +++++++++++++++++++++++++++++++++++++++++++-----
>   3 files changed, 83 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/libxfs/topology.h b/libxfs/topology.h
> index 207a8a7f150556..f0ca65f3576e92 100644
> --- a/libxfs/topology.h
> +++ b/libxfs/topology.h
> @@ -13,8 +13,10 @@
>   struct device_topology {
>   	int	logical_sector_size;	/* logical sector size */
>   	int	physical_sector_size;	/* physical sector size */
> -	int	sunit;		/* stripe unit */
> -	int	swidth;		/* stripe width  */
> +	int	sunit;			/* stripe unit */
> +	int	swidth;			/* stripe width  */
> +	int	awu_min;		/* min atomic write unit in bbcounts */

awu_min is not really used, but, like the kernel code does, I suppose 
useful to store it

> +	int	awu_max;		/* max atomic write unit in bbcounts */
>   };
>   
>   struct fs_topology {
> diff --git a/libxfs/topology.c b/libxfs/topology.c
> index 96ee74b61b30f5..7764687beac000 100644
> --- a/libxfs/topology.c
> +++ b/libxfs/topology.c
> @@ -4,11 +4,18 @@
>    * All Rights Reserved.
>    */
>   
> +#ifdef OVERRIDE_SYSTEM_STATX
> +#define statx sys_statx
> +#endif
> +#include <fcntl.h>
> +#include <sys/stat.h>
> +
>   #include "libxfs_priv.h"
>   #include "libxcmd.h"
>   #include <blkid/blkid.h>
>   #include "xfs_multidisk.h"
>   #include "libfrog/platform.h"
> +#include "libfrog/statx.h"
>   
>   #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
>   #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
> @@ -278,6 +285,34 @@ blkid_get_topology(
>   		device);
>   }
>   
> +static void
> +get_hw_atomic_writes_topology(
> +	struct libxfs_dev	*dev,
> +	struct device_topology	*dt)
> +{
> +	struct statx		sx;
> +	int			fd;
> +	int			ret;
> +
> +	fd = open(dev->name, O_RDONLY);
> +	if (fd < 0)
> +		return;
> +
> +	ret = statx(fd, "", AT_EMPTY_PATH, STATX_WRITE_ATOMIC, &sx);
> +	if (ret)
> +		goto out_close;
> +
> +	if (!(sx.stx_mask & STATX_WRITE_ATOMIC))
> +		goto out_close;
> +
> +	dt->awu_min = sx.stx_atomic_write_unit_min >> 9;
> +	dt->awu_max = max(sx.stx_atomic_write_unit_max_opt,
> +			  sx.stx_atomic_write_unit_max) >> 9;

for a bdev, stx_atomic_write_unit_max_opt should be zero

However, I suppose some bdev could have hybrid atomic write support, 
just like xfs, so what you are doing looks good


