Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3348C823DD
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 08:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762765117; cv=fail; b=bLFlhpzDspERVXB3gJEVbwFl44lDuVVqP8TotsshQ71yfscJDYqybBlbUzoQfID8XEWeA6eYhYBbBQMYfm2SiSLrIfTVKivjbooFM3mXBJGSW3GFH9L1sSpGk87Uzb+KDebsR3/lHZahzD4lVCxtUzUFqhDR75pRIZfKBvq33aw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762765117; c=relaxed/simple;
	bh=Yi6CBLwsHvMa/V50rDc0vD2pNz0rHKud4B7umzOOjVQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sBu4FV7o7fxfSOvhQzDllWGXxDuL0mU5Mn1VZh/UJs8VY9BltbpTF/F6os5WLQLg6r3tdHMAcqDaa8cA4Sdzey6zkMBbOsnwj2U28MfNKw8DJHALvzSLkVZAlW35B6ea/1yfqq/NkdvTjolkAFIBpKhIqa59S94D23O6eCiPDio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q01jHwi2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KkZS78l4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q01jHwi2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KkZS78l4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA8pRxs005011;
	Mon, 10 Nov 2025 08:58:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eVl2fN28hG8ydy25TlTCy2NNxmX2xCSUZ4baktpSCC8=; b=
	q01jHwi2G771LkGVDyzoUCP13gpD0p52OHpqsHDaJecZ/h6Uavn5Qt3A0dnu0Z95
	xguhWNo2lnUpx4x4TlYUYMBUKpr9eBjgE5CdbzpVeigwfXS8J1l5iDHVgnJIz+Vy
	WfiLubtZU5WUtRFwQ4TsOytVW6Ku6WY2ctUoRXiA9zsoOE/0atY4qiOvoTXCqh/c
	kR11BG5zA/kN/wmF3jiYhyRelKTP1znGf0HHPYzmOd069dM9FQN1ueFwZaA72SLV
	WLC/kz/sQyDd2h07+wAnOtz7wPcCTx9GP+DIAhpeMU+6KcUSuBook1Wau+5YDOCi
	s1hvqBzIOccgCPIq/MWT1Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abcvw80q2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 08:58:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA85Ut7007654;
	Mon, 10 Nov 2025 08:58:31 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va8d0ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 08:58:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tzCixKC9c7i612JRcbMEVieLXnx1/XcTI5/iswSdmMw3wbHfIlzfVC59/utJ/iOw7d9aCRCCzrKlz90IgK7OF8P3svJSs5OPIJZ4wJGiEUyFWIT3Z/3LWdJGIUQJJUalcE23CioZZhFP7GvbWt25LfPTCWn+14Y3zrwI2A/Dy1JEBd8pPPdVdn3h1ne+SJLR652q/q9QcAs1SLwj9ZpBb44eTYbMyxUKTR8pohf2HOToZ7r4/cih+L6gWpzGc9C/70siA3g02Me1NfbKi+B3xNN5iMriddEgImDBzvK6ox4yVlgjeJTUZ9TbvFnmRDdreqJ7T4+batMvcIIQtqW4Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eVl2fN28hG8ydy25TlTCy2NNxmX2xCSUZ4baktpSCC8=;
 b=vilWy/JJhlLB/HCLcQj04IFxJxPsuFicxgsfKlVhwo7rX329N0xju0g0RdVy+aSpN/x5PlViVhrmvxrtMA+S+nccPMMwmX/FjO27CnijzlZ44YJ5ruRveWEGAsKw3ICV57M+UkMm+NYFKeh1Ac6JrvkPT9/loLjvx0PIFgXaCylz9yDqXRElaP4vy+KQLLv1gcbehs2gQs377isTvtMWIEXLAyIUSf7Wrfy2BmbTK7HWpZAY80EXpzL8El8KN5wSlLICcm0lv2BORv7f0RR7dO51UIhHBn7x7vGaGjIXBCw+TZ/zeNKNTX8vAxlDZBMBrMJPyQyn5k9Nd2roXBC+zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVl2fN28hG8ydy25TlTCy2NNxmX2xCSUZ4baktpSCC8=;
 b=KkZS78l4kLygXiAmKGIjWkUaaYEQJjQiROZV4eUQ1O+k0Ux0g03LZqhR/PMcgHz5ZfE2pmOToo6goxlnrL9TnWrlxl9Fyma1hbnqK02dWSXcOqRQjhCSk+kwpPUZZ6xx3VPzlCiw5r/lHBCAHEVuuHJ2hwwo8D7NHix5+Zrt7LA=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ5PPFE1CCE93FE.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 08:58:28 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 08:58:28 +0000
Message-ID: <64746661-261e-478d-9d98-fb27379f9df8@oracle.com>
Date: Mon, 10 Nov 2025 08:58:27 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <aRCB_TzOAtHaTPOl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aRCB_TzOAtHaTPOl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0696.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ5PPFE1CCE93FE:EE_
X-MS-Office365-Filtering-Correlation-Id: 1296e215-5511-4ab2-fa37-08de203750be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUlpbzJBaDdoeVdnOG5uN1c2a3lkL2RJRmJCcXhtcVhNcmthOWVIWDRDODZO?=
 =?utf-8?B?aXhYbFV4dVZlcm53M215SkRBQXhDRElNU2V6dWhyUmVhV3h2RzNtVTVkUmdJ?=
 =?utf-8?B?dlRmbWtxcHZZUjdEaTlVZXBqckZxQXp0cE9wK1g5a2hzcWphY0kva2RybmVB?=
 =?utf-8?B?RmJvaHJZTks3VFNuZDFnVVlJc1lyYnMrV1NuVWdnbE1FLzYrUVppN2JyMFBI?=
 =?utf-8?B?cnlSSGQ1Z09jNWhTYU4wUGNzbDA4Y1NMYklGTDRVQkd4UWJQeXlCY0t5amNE?=
 =?utf-8?B?eDhjUVdyaXc3WmVTL0dibW1KcDdzY0hzb0xKL2Z6c3Jtdmx3NURJcmhSQ0s4?=
 =?utf-8?B?dWYxSFF5L25ESU5hYVk1MkJMcXVMeUE3MkFTTFNOaSt6OVJybFlDOFBqNEFo?=
 =?utf-8?B?U3ZVUUQ1NjJEdnJScTJ4VlNvSEFJRm5UbldhcXNlUGRjT0l6MHp0RTA3bEtM?=
 =?utf-8?B?dDRSbktsNzZmT2Z5QXZqdk1BV0tTQzRaUGJSNEJOYmd1MzJ1aDh1cmFWWjF4?=
 =?utf-8?B?S2l1R00veHp2UVJGbDdKNCswOTA4Tjg0NVpKT25PZFBUazBTdkpFMDNNTSsr?=
 =?utf-8?B?ODBHcVJnNXVwNzBCWXhBbENLUS91dCtPOUJXQnFKWXhqREZ5S0locytxbGdx?=
 =?utf-8?B?RW1TUFNLZkk1YWxKTUk2QVlUZnVIOEJJbUQzOHJUVkFVSnZtVlN3UytTSnNF?=
 =?utf-8?B?Q001dGJJSkRRMlZHWUtLays5Yi8wUytoOFNLQk54blZuT0grajczT1dlZWc1?=
 =?utf-8?B?My9QSXdnYjNNK25QeXJPdXJCUlo2UXMyblJnR0hDOXNSaERsaWdmdHJGbjE0?=
 =?utf-8?B?bGpmQmF2UFIxQ2hmWVJWSWR3ZlVRcDdsZU9qRU9LZG5TWlNYTUJBdmtKamhl?=
 =?utf-8?B?TEpyMXViTDJPZGtxSlNvb1h3b3liSkhJSjdpTFI2dVhGOGJ6K3BJWjliR09D?=
 =?utf-8?B?a1N6T0tSbVhFR0NEb282MlNVb0lobzgvcG14RG4rNXltWU5PenFocFJPaHZ2?=
 =?utf-8?B?UjhiR2ZrOVVFVklSUm5oM1FkTnEvT3djWExMQ2tqR3cyd2ZpVFJiZTM2U2xL?=
 =?utf-8?B?VkRsZ2ZIb1NOaDEzc0ZNbytZZkF6anZBMHh4Y0VIQ0NYWWtYNlVpeUsyR1R5?=
 =?utf-8?B?OGFZYUdjd3NUc0lBVjVyRll6cjVyUWR2cWw5THY0Z3lRTHNHbVB3VTJkWWJC?=
 =?utf-8?B?MjJ3QWJyWE5vVkFqajIxMk9jZmE0cUxGN2crclVUYmc3elF2NkJpQ1RUYUZ6?=
 =?utf-8?B?U3g0eXQwTGRPd1N2a1dtUHY0a3hFWmIzeDRyWnNCTUxmL2RBVnZ6aEVPcnVH?=
 =?utf-8?B?TjVMaFkrZm5XYzA4NjhJR0pndGs2TlFKTm5xV1gxQWROM3dCYTBTMG9HWjdj?=
 =?utf-8?B?dWF4alFpQTMvQWJkQmt6bnAzLzhLY1RRYi9xVEVRcUtuaWlMMC93QzBxT05q?=
 =?utf-8?B?LzVpdUl0cjl6U0lCRm8wbzlxSWFQR2dEK1ZHdnVZdTRyUUtwTzJ2MTRzWUR1?=
 =?utf-8?B?MXZudGJnUjJ4aWIrQjJRNFBvemxNZ3didFJhcXdWWmJBY0ovbzd3OVNaNVpi?=
 =?utf-8?B?OXc1dGlGckgyWHlVU3QyblloTUUyendpSzFuSS9KUUJ5dWVRYjdEQW5FeUJP?=
 =?utf-8?B?NHpRMjJ1SWJrd255UDhYMkVlMzY0YUYwMlZ1czVheHo5Q20wdlVjMUsyVUNY?=
 =?utf-8?B?SXZlUnMyM0dNRnozVEk4RDZTTUJuR1JlTW9ZUFdkWTFDcFMwZGF3aTJPeUJz?=
 =?utf-8?B?VCtEdlhpTkRZQVIxU1RUeFM1eHdxMWRIQkUxWmI0clc2Y1NZbm1HcVBKT2tB?=
 =?utf-8?B?MEoyVUtlY2tRdEJYckZIemM4c1ViTnpiUng3R0VGWEowWlJ2a1NRVWxvbXp1?=
 =?utf-8?B?eXkvREVIazc1VFhUM2p0dFZYS0JWa2g3Vlg0enpGMTlLbTlMd2FzemFnWTRE?=
 =?utf-8?Q?6VkVHsipULeK4VggwvPxUUrsSViVcta3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEhkeEJ0RlZRa1hlTDRKa2NRVWxUaTd1aER1MWRSRW9MUjRnZTJEYmRNamFW?=
 =?utf-8?B?Rk9yaENxSUdwQm5kbFhsR3A0cENXWW5VRzdzS3l4cEhXSXhuVDM2M25PZmRB?=
 =?utf-8?B?SjlNUmNkc3F4dHJYdm9uVThXUW9KeUk4THpJOXV1Zmd0YmhsL1ZMVFZCRi9y?=
 =?utf-8?B?R0R2OGlSS05UN0Q4TitXV3pLR2xBS044VDNaVTNEbm9ja3d4S0p3ZnJXOGd4?=
 =?utf-8?B?a3pHSjJ1Sk9RTW5OaTBYYmkzWmRUNERibHlMdzdMVUkzVHBLOWt5V3RGZ2pk?=
 =?utf-8?B?VldXMGJsdEtYUlo3aWVnNk4rNDVFelAwbjhhMUx4QS9uZHdwdTdpZFgzN0pa?=
 =?utf-8?B?aitCZUJTNzZDNXZVSUEyVE8yWXdHd0N4Wk5kemtmM0RxWFpONlRyaWxGRlc5?=
 =?utf-8?B?d2ZIdmtxb2FzQ2tVUnQwaEhFdE9NZXFYMzdVcWplbkg4ZmY3ZHp1M09STDhK?=
 =?utf-8?B?Y0dpQWY1Umtrelp1bnVycURUazhidVYwakRTLy9DS1B3eEtqdUdoNEl3VnFO?=
 =?utf-8?B?V1RMQU5ka1o0Z0MyL3ZZWDR1NmZNZkh5aFkrVm9DMDFRT0hhbUsrVkNndzNH?=
 =?utf-8?B?eUR0dHd2SVJSVk5TRS9YN2ozMmxUMkhwMDY0ODJwZXRQZ0xBTW9Lcm9CWGEw?=
 =?utf-8?B?eXRiNkQ3YU5yeENkRU83T0FidnhSZzJ6S04zelM1NlJ6ejc1Y09OZFoyWHA2?=
 =?utf-8?B?d3l2d2NDVzNsUGlXZ0MvSXJ4UjZQcjFZUHNRelBMQnMwRVloejN2QitZS1Na?=
 =?utf-8?B?bmdXUXVsejNTMU5YNUNVVHROc3dLdkEyR1IzSTlIZXlaZHplajczOU12UWhx?=
 =?utf-8?B?LzIwSTc2NlAyN0o1U2hmK3A5VmNlMzFHeTRtbDI1TVQ3SnVrKzcwcUlUVjhS?=
 =?utf-8?B?VXZJZWZVcVpSQWhtaTZsanlGSGsvMXk0OUYxUTNFVm5neU82MXJycVlNdER0?=
 =?utf-8?B?OHpKVUhpOE9HK1BoblVjR2M4ZlhSazJpMlNxT2J2aXc3SjRjYlBDWFBnUER3?=
 =?utf-8?B?dkR4Ym9OQTkwZHZqUThKVkp1S2NaL1RhMElvYWlORXpWL1ZlWlZDQkIxcjVy?=
 =?utf-8?B?OFEzclk1TCt1eVZWT1VVbGdFdEllNTBOaGhnQ2R6VzZlbHJUS3BUVUhBWUxM?=
 =?utf-8?B?Q0VpaFJ0T09aTVdEWUlhY2lxblVEMDEyRXUrczNqR01EejlaV0RxT0xHKzNO?=
 =?utf-8?B?WnFBNm5YUXRKUlk1Yk1rVFdrVTV5b0FHQStiYlBlMjJoS2l5bkZhV0loQlJw?=
 =?utf-8?B?aE1xdGFHdjdNdzRPRXM4ZDYvTXNhaGpKNmdIdE1TdTB5U1hxYWtWMElNcXIx?=
 =?utf-8?B?U3ZCSjNYZmcwWStkbG54bXJPWWh4NEVnRU85RGYrODNLZ013bGIybkVuVUVk?=
 =?utf-8?B?YVhNQmNSblZhcDdreGNXTklZaXRaNWMzMWp1SEQ2dGtLOTJhZVljdXBKK1U4?=
 =?utf-8?B?ejZpbFh6Vm1RNFVxdVFjbVZVQUk1ekxackY5WkRrNnQxV1N1UEhhc3NwY2ZY?=
 =?utf-8?B?cmxlZXFoNGNUVWYyNTA3Zy8zLzF5anRFQ2lhRXp5cmIzRlBjbU9DdWxqWHA5?=
 =?utf-8?B?Q2plRDdMQlN1cXQvdXkrdS9IVHRueHhhV3dmdVRCaGd0YXlSRWRaWVZXa3Z2?=
 =?utf-8?B?MWJzZ0RWSEpvdnRYSnFyTnFpNGd4NlJIaDVwdlc0blZyMGxXbFhYNkMxQjFU?=
 =?utf-8?B?ME5pZWFNUHlOY044MWpMWmtHMWNJeEV3dnhSNThhVVY0eFoxcjBZZDhhWGFk?=
 =?utf-8?B?YllMUlBJMDBrMy8rOFUwakxYQm9Kb0lBSHhMUHBmTHN5aUlDdTBTTUx1RFly?=
 =?utf-8?B?MTJpQU1zTTl3RndUbTY0eXdXNjJLTXZSZlFHSFA0RWtqc21pd1ltZVp2dXR1?=
 =?utf-8?B?emFTUmpZUUJtVVhWelJId05HSzFSUjd0MmZnRWtkbVRtVkMvQlkzbGFjdkx6?=
 =?utf-8?B?QzUxZ29LaTVlQnVRb2N2ZDBjRlM2dDVFSkRwSm4vVVRHTk44Z1RnU0xNZWRS?=
 =?utf-8?B?eDh4SCszOVhlMit4NC8wRC9EbEtBV2ludk1oME03MjgrRzRaVDlHRkRuU2Vt?=
 =?utf-8?B?bk42WFd5dHhSZkw2U3NwVEJLQ3VHSDQ0WjRTSHVJNWQ1VmdHQWxJSzdnWHdT?=
 =?utf-8?Q?c/Mvf/lOkgXS9QRUVZvBFIuLp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OPC6dcMEq5eWvclS3qX6stMIk+aoO+eLNC3J7CyrRdf+HX7HZjNKGuHjjuTOrlaKKPYijGxmpEGitox55mnJ6NK7hs8dgRSUJvTy8Y2a+iIDlF/PpPOceJ7+Vy84zHXuaeDtPysLKljdq/WzwKlwHqnjOt31+WDjkpllvH1Ca3m7O0Zjmei5JDzyDnE8At0vyRrE5rVEXmYIxLZSyXqwYop0HiT98qMOJJbUDjzeFmHUrx/A4crRx0cCSRyVTTt+wEIltLTJaIrPRFHaIsG8GeD61Ox3xlh0UnZx/B4NYYY1PU5Px8kaQeit0qC1q+N4A9bfCdq079sWsliQgVR7ddIFlt/4X7ZbOG5hUKQnvqPkGCwqcIeETSAEdt5PKepN5+SER2yWZq6eXs5nn+b/HTuXVpbvrAZTW7m7Y+mT0hhZBXmPsTEfKn16JBSosZIIcAMTxIALsPTW9XPzLKZuvpMPx11Ya3ERys3kUZaI50ILYXekTJqE4bpYal8Lk/xwMXQeheFFpJb4j1ukdXWiu6b0sPBxhZsd3935ZZgrnhmQT8mId0GBjkFSBznrAQj3mpHVmqvRsnIavl+nAaLlxGmVZpQS7eZJYcHhqRpgoRw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1296e215-5511-4ab2-fa37-08de203750be
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 08:58:28.5206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nAOvU/qi0mzxJK4h6a+zkn8sF+HsEokDsjkIyzaOzrEfcfNpt7nJz5UF44h/1KggLfclfUHrsvhsgtAXQ+1FpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFE1CCE93FE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100078
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDA3NyBTYWx0ZWRfXzRAWtExVzaYu
 ZObckPqDDy/40mWyg3Zdi0pdc2BTNhESabyvUx6moXT4S21DG7aIJX5J2+TD+ySVLLB0/GNV5oS
 i3Dqrre/9EjO5nWyiUNwirbh6lBrzMwlDuYVAqFiX7EYXHYUWlx7GBKAIuvJZOy0XqtqBuYIbHf
 HYjl+gsmuGlF4Y+JJK5IoXjruH588ygFHAuRl9Lc2L0u3l+M9nlktWcvwctJSVGa79grTgZZkO0
 gjFy7G79dJiT6K2M62q+WxeDCPzfNm3lHOcfDwYDXC+pfELJ8bVSBFzWg+uQkGbRj59QlBq3NzK
 jxvstm+i5NpJlF2mDUsF6Wy2AS1uFbPk7fxA3nzwGmWYyCzthymtQirvr+P48T1q30C+4tt/zlv
 ZkXzjaTHj663utsdvEtOCUAKgD5CYg==
X-Proofpoint-ORIG-GUID: wJHqtLUPxfpqql16Np5vma1rBgniVz2d
X-Proofpoint-GUID: wJHqtLUPxfpqql16Np5vma1rBgniVz2d
X-Authority-Analysis: v=2.4 cv=LM9rgZW9 c=1 sm=1 tr=0 ts=6911a938 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=5oggcT7bRuVlgGp9o0wA:9 a=QEXdDO2ut3YA:10

On 09/11/2025 11:58, Ojaswin Mujoo wrote:
>> aw_bsize for  me is 1M, and threads is 32
>>
>> aw_bsize is large as XFS supports software-based atomics, which is generally
>> going to be huge compared to anything which HW can support.
>>
>> When I tried to run this test, it was not completing in a sane amount of
>> time - it was taking many minutes before I gave up.
> Hi John, Shinichiro, Darrick.
> 
> Thanks for looking into this. Sorry, I'm on vacation so a bit slow in
> responding.
> 
> Anyways, the logic behind the filesize calculation is that we want each
> thread to do 100 atomic writes in their own isolated ranges in the file.
> But seems like it is being especially slow when we have high CPUs.

It's not just the number of CPUs which is the problem. The test does the 
awu max size writes - for XFS, this size can be many MBs, and not like 
typically < 100 KBs for any FS which relies only on HW-based atomic 
writes, i.e. ext4. Please also consider limiting the awu max size.

> 
> I think in that sense, it'll be better to limit the threads itself
> rather than filesize. Since its a stress test we dont want it to be too
> less. Maybe:
> 
> diff --git a/tests/generic/774 b/tests/generic/774
> index 7a4d7016..c68fb4b7 100755
> --- a/tests/generic/774
> +++ b/tests/generic/774
> @@ -28,7 +28,7 @@ awu_max_write=$(_get_atomic_write_unit_max "$SCRATCH_MNT/f1")
>   aw_bsize=$(_max "$awu_min_write" "$((awu_max_write/4))")
>   fsbsize=$(_get_block_size $SCRATCH_MNT)
> 
> -threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
> +threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "16")
>   filesize=$((aw_bsize * threads * 100))
>   depth=$threads
>   aw_io_size=$((filesize / threads))
> 
> Can you check if this helps?

