Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCD31361;
	Fri, 16 May 2025 06:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747378793; cv=fail; b=ubve+QZ1tQGWNoqtfBywa2JN80oPB/HXObAq4F5Ii/bQXb/RpmZYWE488YYIfBl3v4vhaG6abub0rXpbHRF/LQJ6sFwdiHWbhSPyp5snfP91kL/ij1zz5AIfulqq1hFNQxRZvr9UAGPurp3vj7j6SV9yxdCUvELgo/MgEa933jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747378793; c=relaxed/simple;
	bh=3VxlpE7N+8XXtTyjNf68TcwHiVNnrDdG+DPYw2KvagE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FVV2xOTg69RdAVb9kLMDlrAQaocfHK2cohRMOlZum8Qsk0f6qMe0EHq/bDL29t2nh7ir0UQx2kECdivxfI8I/DMxCJ4mxG9UGFC/BjKLc7Cdwl+GBQlkGU6a79WkisdGWjJrbqcpZdcKSlbYgEMvq6Igm2vL6KYi2fA/t/kMEDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ICJ7cLfJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lBEUvBbj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ICJ7cLfJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lBEUvBbj"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54G6u5ci009367;
	Fri, 16 May 2025 06:59:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rd0n0l9Njzev+FdKVMR7DfEfU8LL1Atty89EIqFJCz8=; b=
	ICJ7cLfJi3VYGsXR3Gs7NjCJWAm2ptme8sry9BIDNULxnRdWAXyPtUuv87Q1lucS
	woHArDn/X4XekktnAs4PQl+UCIZV+ctbsFuccrOgLR6d4CGDjpwp/o0hRnZ/QlnT
	u3hUsi/0/fzpqAwjdSDb64mqapbpyfz1LAnSJtdp72s68qbB/fvqkKJa1X60cNqT
	oS+LbNKPccrTlexUvbnKBfRiewfNQTZ72PggFPy3AVZa4o6m38mgkc8GaXJ3Vifc
	vv65kOFrEnQx3iaqipC/JTlMreTaEH7oGsnOSK3FXO1K4ptZiFYQ6vt8mQWnhYMR
	dT2Axsiyi9uSjV0Y/HJCCg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46nrbkrs25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 06:59:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54G60KWi004357;
	Fri, 16 May 2025 06:59:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mqmebr3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 06:59:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPH5cZmbjtOS4rrYWUVSSvUhslhH5t699ATkgI498AcqSUty4w1azosbt3/60qVzKM1vINLgicO147OIeLX7rdDixF0UQQ/ineSL13xIFsJJ9IIYpzxNIgX3WowBr4SqjHOi8Jlxz1Zt9/FTP65S/ihD7ZhZGsTv2uNW4/7EzC9+X/0//iBi0xbEOzQNDd2p2rRcZEq3+mXKNRYg1Klc6NQ6zRAbgwUpgNUeJEWwyX3DJB7WOZq5DQC1MltCJ8bUDaBKFTuWHuFCQPmefPhKbbkxJQPAkpU9+dDkV5uMXDglD06TB+KO0mjMAG8RwcULAdVlzK2yJRoqxHIUa7gkEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rd0n0l9Njzev+FdKVMR7DfEfU8LL1Atty89EIqFJCz8=;
 b=V0NmVw6TaAzf2Ly+5PQ0aGxjQUPGxmauySrJ7XNu5nxA3661Aowbvcn84OpVLU9vsKAmRa1MN+KAK4SHELtwJ5U1ajPu+8lHXbhiU8kih63PMS58kf+pXIvOavROT7nUaA45DeF+w0e/a3Bwy9mVHDPohiafTWKdV4VLd+/wEgIxAKbXrAVzAdXFMmQpaYio3Rh7DrAuQTLrIY5NHhsz4izGeeONgw6yhdtc/DlcT0jcDsni6yUozKAXouqyV8FiBD2Nas8qkljkJwdyw7PUVCIVctd7SUDevltWSEwT0omwp3apDUc1ERJUWWFCx8rEv9sr/i9T6o+toOtk46sI+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rd0n0l9Njzev+FdKVMR7DfEfU8LL1Atty89EIqFJCz8=;
 b=lBEUvBbjDNVJxWKfmRcqS3SBfPh6s5qQNvztrQkTG13/5W9lPWFHdYBrd8G1O8IY447axZKn4ixjzWjfwgvkUIOoKB5JCIoVvR7Uc04isnp/oKWkVEeOik85gA4yfB9raQrnJhCSG9ee+oIlFCbudqehwKx31P833iFvZuI31jI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ5PPF6998A7572.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7a3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Fri, 16 May
 2025 06:59:45 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 06:59:45 +0000
Message-ID: <cc996a1e-013e-48dd-8c3a-8b1f6993aeb2@oracle.com>
Date: Fri, 16 May 2025 07:59:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] generic/765: fix a few issues
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-2-catherine.hoang@oracle.com>
 <52fc32f8-c518-434f-ae29-2e72238e7296@oracle.com>
 <20250514153811.GU25667@frogsfrogsfrogs>
 <4ad2be95-5af8-4041-99d5-1c9dcaa9df7c@oracle.com>
 <20250515145441.GY25667@frogsfrogsfrogs>
 <cb1bce71-854e-478b-82eb-8a65ccfaf979@oracle.com>
 <57B7ACE6-4B7C-418A-B102-47BB3913D695@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <57B7ACE6-4B7C-418A-B102-47BB3913D695@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0207.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ5PPF6998A7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b91dacb-d163-42e2-200d-08dd94473d6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bDcyL0x1QUUyR1ZmYUY5ZVVaZ1ZML2dsaDNFSnhjTVYzbnBxb0xXUk5yQ1o2?=
 =?utf-8?B?alAzNVJHaFRVRVZGcTR5K2xlMW81bEwycEpmR0RqMUZ1ZkJETWEwMHJVUVFH?=
 =?utf-8?B?NHJ6RXJqWWRsYSs3QzVvZ1lLZWNqUmphRlNtODZDbDF0Sk5ZRWtRR0ZCU01O?=
 =?utf-8?B?VGs3NDZvY3pSODJseGt2M0VXWjV1WG5KdVRnUm1UZXJVOUxWaHZ6VnpUc0VU?=
 =?utf-8?B?dmRQamVreXdlUWhRUGcxMkhqQ2xIUnBmekxzT1dSYVpQeG9EeXZJV2xubDBS?=
 =?utf-8?B?bGo1bkhvOXRYRHhnTDcyMVJaYm1jNWZTUzhuc1hxcDNyREl2RXgwc0JKODMy?=
 =?utf-8?B?M1ZkaThFMFdvdHV5U1RTbnYxdXhnMFdKSzdXa1lpRlFzMkk4dEFtUWxEU1Ji?=
 =?utf-8?B?ZldxWWgzS2RkKytNcENXYUh2OWgwT1d3WDBLSWNScEwramVWck92cGtJTzlK?=
 =?utf-8?B?eTlCVEk3bWFFNjVNOG0yZ0M4bUpWc0RUUW5OMnNOSDM3cGJEMnZXbEk0ME1z?=
 =?utf-8?B?K3ZCWWdRc2MrZFNNWXBkMWJ4U1JjTXBxTDd5dE9ycUM3cFZFY3Z6L1dwUFM5?=
 =?utf-8?B?YnZoOFRzWkFVTGwrbHo5OSt0K0hETjg5RFJHSmRBdXhtSFRua2I5MjQ2SjIw?=
 =?utf-8?B?Tm82MGJ2N2U0MVRjeDJNM3U5ZXFxdlNRL0xLNXdZNUwvY2d4QzVRUmgxNnRK?=
 =?utf-8?B?MERxazJLby9oZEwvOTc3RE5DVGlnakxjS0NaRWprbXlmQVY2OTM1TEVmRWRr?=
 =?utf-8?B?WnQzam1pRHVPN2hZdFRyUXpLRy9XdFptdzlRNTFoRHNJdE5XM0xCYWxDV1Uv?=
 =?utf-8?B?OTZxRG0vQmk1UHg3anZiaUNsc0JnbEIya3N1WitsdU1iT1RGYzBXOUZuc1or?=
 =?utf-8?B?aEtnQjZtTC9KcWp4RUZIWmhXbjM2c1p2K1pCZXF1VXF6ZksxSHp4V2tNd3or?=
 =?utf-8?B?NzhFd3d6eTNNUHNadmV6Z2lMck5NcjFhQXJLVGhRcC81QS9CeC9pU2c2S2tX?=
 =?utf-8?B?MXpXbHdVYWczT2UwNEYzazZHckcrRjV5VkE0QWU5VE41N2FENXdzbS85bTUy?=
 =?utf-8?B?dzhSNFpoamdSb29XcEFJRW1FcEp1SGUvdWpmMDZkcUJycWxGTE9XZDlmQkJQ?=
 =?utf-8?B?MFcrTjFUbXA0Mk1WTlU5STRDaTRlcE9obTNBbVlQYTZSZEFqbnNpN2NRaHNx?=
 =?utf-8?B?cmNMZE5obUMyQk9VQnVNVGZLV0pnQ3h1QWZGSEFxbndPQ3pKWWczdU5tbmIw?=
 =?utf-8?B?RklPZ0JsMTV4VDNLN1NXeDJPY2tnY1cyeHJIWlljaVNRSUI1bnlFay92VnBr?=
 =?utf-8?B?cDVjbGJOSGdaWjhJMUUzb2R2dXZONHo4dmtYRHUyTk9oVG5WcVh3N0xENldl?=
 =?utf-8?B?M1FVeUJJMXVDMEtDQ0tpTlF6ZkFlbWxsblhub2N0cVh1b1Nhc1VCTVBvZ0tm?=
 =?utf-8?B?YitQY09ydlVTWUY0dlVTbVBLZTgrVnlMbkxtU1RGYmxDR2JwS3JJd1lpNlAw?=
 =?utf-8?B?Y1E2SWttcW5IK2RXVXdrK1A3dElJNWkxMXAyZXBJVTY4aHdKMnU4N0VGNDds?=
 =?utf-8?B?Q0IzOXRBZ1ZpTzh2MTVhSi95WUZmRzVpMjlTL21qVkRpa253cnd1cjJYeVpt?=
 =?utf-8?B?Rm5vVFZTMUE4NEluNzhBcXd2eUsrcitLVUJYakp5ZWxuMEJXUVlRMUxyVkhU?=
 =?utf-8?B?a2VnSSs1c3J1MUpWZHVjU28rZCt1bk91eUhFOHBNRDA0b204dUhKclVSY3hv?=
 =?utf-8?B?MFlSK1FZTkROZ1hNUGZ1L1VpMTUrQmQvNHdlWEtYMUtsVnZZQndGaExVd1No?=
 =?utf-8?B?TElNWmhHNmttaWppODg5bnFtcFVML1hmOExpSGh3M0ZHUEtLTHk0clA1ZmxE?=
 =?utf-8?B?Qk5ISFdDNnFuMjhIYkVRZ3JTcUxBMmN4ZW43WG4yOW5aSFp6bXlld24rTjlY?=
 =?utf-8?Q?xL0ASmK+9Yc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDJzMjhiN2cwZ2lhMm0ySjZuTElSTDdiWjY4ZklENnY5L2ZpdVVIT2FQT3Er?=
 =?utf-8?B?MzA3TVRndllYYms3VFk3cHY2R2NYYnIvYWpTVlczYTBGNmdybGExVzJLLzda?=
 =?utf-8?B?YXB4SVQ5WjV1K0xWSG5tbmxXUFVJUmplYWVwVTNOMjZkdlBhZFJ0Tk5tQ2NF?=
 =?utf-8?B?Z0l0VmZpVG1aYlBIV3JSSTFVU0RVL2M3RHVjZlp0VC8veUFsNHZ5ZysxK3hh?=
 =?utf-8?B?cWo4ZmdFb0tVOUJQNTUySExtaHBrOGtFWTBKVGlRNEYvbVFPMHRCOEtONmV5?=
 =?utf-8?B?L2JIb2RNZENFNGVBako3bmVyZnA1U2FGeklwcGFLY3I1cml4dnpidTQvMzZY?=
 =?utf-8?B?UVlBYTFScFNEQ0RQaWRxSVdnQ1BiblFiV2FLZjliQXhQY2wxbmZyQmNaV0w4?=
 =?utf-8?B?UE85enR6VFYzenhQU0w1OVduSmluTTdXdm82L0MvY0YwajM0eFdFKzBsbWt2?=
 =?utf-8?B?L1ZBUStBTlRQUy84alRET0p1cmVpUlpBN2R2MTRVTElCczVIYjVJM21FcDN0?=
 =?utf-8?B?b0NNTFJEdC94dExpa3dYVHBnalFvYkVXY3A0cllCL0ZPakdXaldzbm1MakY0?=
 =?utf-8?B?U2FYUFVOcGFFNGhuSjc1L09ONy83Q2VmRzd1OG9tMW0rblBuUXovRC9BTTAv?=
 =?utf-8?B?R0hhWTJaZExJSGxVNElSZ0liNWlUWlRucnJ4RXFzVmx2b05HekJTblR6QUtK?=
 =?utf-8?B?VUZGMUpoSjI5Tm1oTzVFdXM4anVtWTg2U2RTUmNMT0F0bHl6Z3d1NHF6SzI5?=
 =?utf-8?B?d01EM3V4Rk0yT0N4UnJTRVp2dGlOd1Y4Mmt1K0xMay95MzRnZ2ErWHUyL1hY?=
 =?utf-8?B?SlFFNjhtYXhxYXlqaGQxYWdtMGppV0d2b1NaVmxKYXVoeXJNNlZVdG5oaHhP?=
 =?utf-8?B?YTJBdWhCZmd4MkhJWFNkL000bUtGNzNUNW5HbHhCQThacEk1RXpsMWZsZVl2?=
 =?utf-8?B?ak0zc0lubEFiakJMc04zV2Izbm02N2hKcm1VeUNiRUdVNjFmbkQ0QzZxeG5Z?=
 =?utf-8?B?eTAwWWppeEJEdVE5TXVqdm1YWW5TVHlaYXZ0TkxXd2RIWUNlVFBSOUp1WitY?=
 =?utf-8?B?a1oxWDRPMnkyOTZEamFlVWltL1B3aDF1WW5MYzVIeHF1MkZuVkRldS9CUENX?=
 =?utf-8?B?a1FBR2tVYkMvZmZnMUdTR3hiV01xS2RFQzVnS2hHTnpSeldDYzVKSXdKdnJm?=
 =?utf-8?B?WHprVkdrYWpvVTNQejVaNEJIbWdQam5VMzFJNW5XZERzYWVUOUU2YUtBQTRJ?=
 =?utf-8?B?SjFFZkZxZ2VFbDEzalhvREZHaW9BNnl6TVpINGZWSEh2OHJ1dEltd3dCdHVu?=
 =?utf-8?B?Vi94cCtkVm9yblYyTm1OMzlHRUFmUG1lV0c1eG5KSk84R1MxSWdLK0NiNDF0?=
 =?utf-8?B?KzVCVjBIYThHaFRuM2dUN3hkelR3N0lBKzd1SGtPaHdHdzBUUmdGYlIxZE9F?=
 =?utf-8?B?R2N6S2ZMYVJaRlllQnlROEpsckRPN0hYanZ2YlBMc3ZyRXlDbTdUUEovTGVZ?=
 =?utf-8?B?VFBEUXloa2k1ak16QkRCRHVEK2lxM2NvUy84cTAzNkRpZTdzS3hLTU9KUmoy?=
 =?utf-8?B?NG1iSHVadDVXdHM0VjR1ZUhxQnp1b3BaMWJYVlZnUFc0MktjazAzR3NxK2pi?=
 =?utf-8?B?aXNtUDVqN1FuR3hlcFdxVy8zTXdTWndCWEt6ZGcwYTZCRVgwSmUzc3BPOXlk?=
 =?utf-8?B?U0hROTQxV3liQmJFdWpvSVB4amxjQnJidkJsQ3AyQUVtRy91T3JkcmxUTHYr?=
 =?utf-8?B?R1J2SXk4bnVHcjR5Wm1UZWNUeHZEZTdQMWluZXpaVWhSdjN5a2FVMW9UYUxQ?=
 =?utf-8?B?MVl4V1RjbmhYc1ZSMzFtclZSbTM4T0l4Z3E5c1hKZERjYzBYVGpIdWltU1JQ?=
 =?utf-8?B?Z3hWaGdVV1RBOXo1RUdBNTdoRmUwRXBEMEl6YW5OSldhVjZPWUMzcmdWR0dF?=
 =?utf-8?B?cHg1K3krTFZOM1ZVQ1E5TlJGNkRlVWQzRzdMYXRTb0NBZXcvVEx6REtaZEJB?=
 =?utf-8?B?Y2Y3bzNhMitxWGN0OVdnOTdheWJFSHhhV25EVGpUZmFEVXdkZ1RZeUZFRVZX?=
 =?utf-8?B?R3JXRDk4UWxkNm43RzlKem82T0d3anFOQ3RtNGZONTgyaGlpRXZOanNSRk8r?=
 =?utf-8?Q?55DpHm5zZJJba6/8vrvV1HyN6?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3b5C0d4rvgdAxFc5hP6EOMk9QEhPIeY0gAu1gP5xM3hDOWlbcSREIhjTlcOKrL0BZwIKQj8fKnAYj91SVTtcIiXrwRWLjoV7M0XtoI9z5EP43oqPyhl9ylBtahUiFUsZhT3gNsMbtkqLS/DKORNZ6VCcNfPtDboJW9WzuVLWHk9sy+hqvGGvMAU6AQKPciin7mCY5RXThBk3u2k8llJRd2CRaR2n3CDT1/OaAQtTYdIFW0b/9uJR+VpIKASqAr3Ca0j8ziBgboK88nXEvxF+YCONkma7G+ReiUvnbq4+sYVL77mADIIuE81Jy9xjFDEhaGWLlbLARXteaKoiTSb1gVAZqX3D7thJWqp5kYRKHySTRNmMt4BzTrEpS64XplevP6m952aMnoMArRjsbKBE67gsn9zpJqM8kdxYYaeF+GE+os8eolaPkdQ6KKlmTh+bW5jIU61+7nyuwEyNroI0ETY0hdk1JZvnOVX7UO9VI5NPXNJiLxV7kbAohwNMU4lldJ6WqnuT0GWKd1Q0NXXSUp1qotrVofDhgIjDCGXvXEngDDUlJHn7XvvcLuL6IgMa6PxGO35ieUBL4xJQx4/hyGXi8a1kN3g/UB4m3/YGPPw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b91dacb-d163-42e2-200d-08dd94473d6c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 06:59:45.3256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8HiVgm7pfiWt94qPvJSso5snK6xtgLxtWma9JrfFcg8WFIV8601/pWeoCVm3gbUbeyKpVzewQtvzx1Nw3/OQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6998A7572
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_03,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505160064
X-Proofpoint-ORIG-GUID: 2CmJjXdTefXtUKAQCoW7iO2YlmVMvb5j
X-Authority-Analysis: v=2.4 cv=OK8n3TaB c=1 sm=1 tr=0 ts=6826e264 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=2Crv1cbGhsuC6-4c61sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 2CmJjXdTefXtUKAQCoW7iO2YlmVMvb5j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDA2NCBTYWx0ZWRfX5jljNodJ5dDP cwWO0gTZquus4sQaMM/Q3RpcwK8h3aTUO0gJ1sH2/Xsgx87mFcP91u9ta/6PLV4fUhkFxyiC23I DB9YZc+zk1oPb/KqihcIxwJmUmifoThj+ap9d/v9W7fbZkmURltRQgm/o86qTq98ERw0Ge+ZJd+
 SqzjS49FYNtdqrqSOJyBNeU4mazhLerN6UFI33c5rWfneeIvgZYApp42eo3F6vAW3LCOCoFHGSn YhSh11xHAxEfRle26JU4wYQNTlvR8vKGh00UoBY2bjsDgEzOQgL5LZg9Rqew0zqei6NWxAUcSRt id3etUpxl2MnitSj6tXCCUsFvZjhTph5WhAEl7xb4Cvk0DHjPjXDGWeZ07Eshrsuz2L7Amx0lAX
 EeNqCBkQi5d6H2dSwYWGZGJIBLX3h1xoGIUsxiTb6ASYqWlOlDIIZS85VMKV6dvb1bfejYe+

On 15/05/2025 22:50, Catherine Hoang wrote:
>>> Are you asking if _require_xfs_io_command should seek out the filesystem
>>> block size, and use that for the buffer and write size arguments instead
>>> of hardcoding 4k?  For atomic writes, maybe it should be doing this,
>>> since the fs blocksize could be 64k.
>> I was just a bit thrown by how we need to specify -b $size with -A to actually write $size atomically.
> There was a discussion about this a while back about why -b $bsize
> was needed when using pwrite, although I’m not sure if it still applies
> or if the way atomic writes works has been changed since then.
> 
> https://lore.kernel.org/linux-xfs/ 
> a6a2dc60f34ac353e5ea628a9ea1feba4800be7a.camel@linux.ibm.com/

Yes, and the xfs_io behaviour for -A is my focus here. I don't like how 
it splits by default (for $size > default blocksize).

We could have had behaviour that default blocksize for -A is $size. 
Maybe that just complicates things. Anyway, I think that ship has sailed.

Thanks,
John
