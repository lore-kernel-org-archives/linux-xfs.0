Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F01C44E64F
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785520481; cv=fail; b=pHv/E4dY9aHIRn54ZR2Q8w+4483Keh53OhiJL0+YM9KRGlp3dQzzd9mlw1tD2aTZ2/jZA7fAM7Xrcnz0b6jQ5EbaQgVl7VSTuPHgLnDTOy9/nScgDMuYD8gUxwmualo54xH6+eAyBCPoX9uifMxfjrUNpJMPwYzmj5bVstyy5OA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785520481; c=relaxed/simple;
	bh=lRrNjdaOAwi7olHf+2+GFnAkv4/pWabWmA5baa5J63c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M9rRo0hCuX+SDGyVMkUnTSXp/HnDlyELEu+I6UYg5btq2qu2bmV+jDwnsxvKZsAbYk8c+aNUZG2LChnbL8D5oFiQ9DfEo9CDZjKy6H6fDvPkwePKZRQr+0FxtJVhkVaR0oWqTMywqvAVXhqm/jlX5Hn0iPo37THVr2OHWXPWmtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m9rgAsvR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eDAVvDoo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m9rgAsvR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eDAVvDoo"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VGWocU3792378;
	Fri, 31 Jul 2026 17:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ghO1+G1eTQ8tYwtkCoopby3dTvtahHEHfA86ox+si3M=; b=
	m9rgAsvRuY/Cm1mh9DeRqSIo/djpha9ukZSQn6v9aJCVECQwmIIt8LDecGd0eI6Z
	XMrvkOCC+AxrhcygPltK7koJZ20MsBbNJSG4Vma16RumzocJEVB4NwQMghmk+rSy
	OTd8H7RqXSxnnPAUw0R1zPVoz71mt3NnU9XwR///X7GDUcahgriJPl1VQWApqq24
	IYG0xy4a4njEQ6qXZl91Zl+BPBEWgk7aQNfjqV/l1H/1cD2vzPUdg0jUUeWBgjFL
	2xOxYnQb0BLYplkFl99UqPAZv80Xl95GK0JMPFksnz/f/OPnQgLm5S0DP9Diz0iZ
	sddKTt/CmNvWbbT4sEAo1g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqymbbmg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 17:54:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66VHo9Fd027367;
	Fri, 31 Jul 2026 17:54:34 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011034.outbound.protection.outlook.com [52.101.52.34])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fqjwwrqxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 31 Jul 2026 17:54:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E2A3vaFZwCyKT+IWUT+MeaYw+92zskc5+xNO1wMP4CEoFkODaykrm6nw5jl9KCGHTFBM5w02kA4cyP59jw6TiaQMalrqFv1K4WicPLDNjaFfM50Y5kUqcMU66XeMvKJq/vGAy+85fRKLWlDF9H8zpIQXkB6uTkBHQJtbvyMt26Nf1UMAGkn2pf89T2TyV3mZgUzz7YjqwutvtQ6sP17t2RIDltf1HbpSYX9hTB06KXkakMmtGyMDfjc66Ri2sJCpKQBbgedKF5OD8bU3MJrqIMHk3eRup4lyZFpgqganY5Q2Pq7gVDTVEKkNmvj1IsDD+3M8gSsNGPz9jCZGcx1akA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghO1+G1eTQ8tYwtkCoopby3dTvtahHEHfA86ox+si3M=;
 b=ZEWr2/KFpjDafVqGO5n7q1a9gETcIPDr8YKikS5DDlT8Imf/sYfjqGvEZo9LzeOaCemGDuVwztZZevHdmeF7WpbyjzgsEwoQU/2FOdSW4gm/DXLHNwm/YdwVUbk7bykJCqtajTIfABZOCGY8H6HqyNEm/Nzm2rRi6kJCZVaVWQuWoXz20tG3GN20Yzgax7cRWHsll6JXfiXdc3iSxrfpAhQHIvOW6IoCza3x3UA+V5rMSoPjoZPjSzoTuXnAJbPbIYhrNwfGQyZfMWwA/fr95JcO8/xGjU/JBce9+E4S4zO65FgMWUgPIE2LpY4baAszZtvQHM9EPoJYAcATrRnx0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghO1+G1eTQ8tYwtkCoopby3dTvtahHEHfA86ox+si3M=;
 b=eDAVvDoooUrmIElluOiK+c5Dn7NVlOKXXzsaH6yF1wiG5A7j1R/FtHOku1vSckMCsW7wg3perSGzLm+DPePYfPysiGJU7qUxFZ/X022SttZxpY4S5UOKarfIhmGdSon66y3cCbN/h6r2yD4MgEWl3LICwndCWQxLjTOxbVAVgRA=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by DS4PPFBD26857F8.namprd10.prod.outlook.com (2603:10b6:f:fc00::d44) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 17:54:28 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0270.015; Fri, 31 Jul 2026
 17:54:28 +0000
Message-ID: <920dc107-2246-4712-ac44-4f3e646ad4dc@oracle.com>
Date: Fri, 31 Jul 2026 12:54:26 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 2/2] xfs: consistent low ag space behavior
 for sparse inode chunk allocs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Cc: Matt Fleming <matt@readmodwrite.com>
References: <20260731163337.152522-1-bfoster@redhat.com>
 <20260731163337.152522-3-bfoster@redhat.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20260731163337.152522-3-bfoster@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::28) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|DS4PPFBD26857F8:EE_
X-MS-Office365-Filtering-Correlation-Id: 603f7e35-2552-41a4-6b65-08deef2cc468
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|6133799003|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZkZYsoPw6VSAvKM4FuaIYhO7MhmvmSzrajaH7YawTmlh3J1zIqKzZmHRaesrOgEaxUF5uihELjJYXBPsW8taPhDCuRnMRwYdk16i/lq9RsI9+rmGy6k1L/z30Fvd1xMSCHyxLdcCpKL6XP0oj+gYR+9ZL0N7H3aWt12gVBqgZtXjGpXBgjD2WGsjmefRRymZIZrTYldjCikuuXTgJ//qIYAMSCJrGaCb0J1qSDJlkxEr17gLYySgQKJrnAY4jrcq7+e8rV2llWidfPJXsSoYPPaY1PWiNgRvq2rMATIUkhFreMDd4ETYX1dA2ObaBD/uww0OL/EvBc0yhG1yLmm+lYh5QFlGUawVm1LYbLFg3XluLOZ/4xeDmQxeX2rsu3GIDcTkvxkOs3xMUn8RooOAAujH0PWtBgFM0a4I3criq0PtNKD0JVX9yTSfEcz9OfkcCAYuxFdiN+Ur0iUtrZ/NmIpjiP79B5J8gQ7n4mpQxilLLJ7CWwWYEovYkI0Y2jUtzNMBS79fL9ORAgBwLBQc0t3kHUxjHtZpNBWZVZRL73u8NllEZMeyd63LYRDCBCnoRnEyfe7sxyTTmi/Bm94cXC9Ycf2ZcMFRXAOjPigu2WdAoIhxqyA4rAhVWJINCPwm3Bnmx4ynoV/gKnAZHQ331B7KRpNPcWi7HlszC4PPJzo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(6133799003)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnBHOEk3eHpKbXhZUWZKZytiY2h6a2xZZGVIRnorc0gzY2txRll3cDZqaTl5?=
 =?utf-8?B?UlhyeEZQMjF2VHpaVGRMV1pIUzc0a2FzV1VaekZyUTdyclJBYjZ5UHRxOVZw?=
 =?utf-8?B?aSs3dWFvbUpqZFl1Wk9tZFlNZDl6YlU4RHFKdjUrT1dJTXBJSUZxT2pDU3hz?=
 =?utf-8?B?L3ZIMUVXOGk0NlNPSTZYemczUThVTS9KRXVoNHhMcnJRTEtDSjRIbVZFU2ZY?=
 =?utf-8?B?aXgwVVdEK2hkTUsvUXorUFQ5V1FDRld2Qi9ScHBhTlFHYUhiK3MyNEZxOWR4?=
 =?utf-8?B?ZVhUMXNPZHRlMWd6Y3FHazROUHJwaldkckZmaHhJd3ZxT3doRHB4QlBIOWJK?=
 =?utf-8?B?cWJCVXVSMUcrMFNOdTFheFF2SmU3NXJqNHlQTHdwU2YzdXNnOHhGVGg5V3lF?=
 =?utf-8?B?SGw5ZFR5bzlsaWRXdklBUHhIcGNoM0g2K0loN3BJeEhmYW1LcjBjZXdpQ0ho?=
 =?utf-8?B?WjJucHpBZm1sUkZIcWdZeWhOYVdZSUZ0VHVYT2FHS2ZrcjI5NE5WNW5Odi9Z?=
 =?utf-8?B?NWNxUWUzZ0k3cTdISUxLbld6QkU4UkxuWmtIYnBNc1hQNzRzblFwM3RCLzFk?=
 =?utf-8?B?QUNiYmVYNTU3d3gzWmZZK2pGN1BJNnpVMUk0amlzd3FINDZZeWNQR3FhSDdl?=
 =?utf-8?B?dDZpWXQ2YVBRdnBlMnNLOWs5bG41dHA0eS9MQU5hOTJSVFhsVWhmQ1hBNjRy?=
 =?utf-8?B?Q3Q1U3lTWnRZV2dvUDlHc2NvbXN0QnBZdDFxUW5tN2dJdnVFR3RqMnJGMWRh?=
 =?utf-8?B?KzRxcU1lSkFQQTNXRHN6TDlxUFBCa0lFTlRGYmF2eW9IMTYyUG9vZ0p1UlhU?=
 =?utf-8?B?dUN4TStCMk5IUEwrZWdHQitybW56Wk5EaTdueHgralQ3aE41ZFJUNUJHMjJL?=
 =?utf-8?B?ZC9iQWtESE5wbkM4ZjRwNERqUXhMeXUyVkVYVmZBZkVORmUra3NBYWdTV1B3?=
 =?utf-8?B?Y3RkUDFnVEsvaTlvNDA4TmFJeWhJWUlIWjV5SlN0ai9lNUZPZ2RqQkJ2RnZF?=
 =?utf-8?B?OWpLNStxOUZWZWFXdllyVnN3dzJWNjZ4UktYOGpVOWtoQk8yc0crd1dJVmd3?=
 =?utf-8?B?OG1aQk5wWG11M3Bha0J6L3k1THRzbmtkVUt1dzJUdVRQalNRcm1tZ2hUOHRW?=
 =?utf-8?B?RGtVeFBIeUY5b21SaWFRVXZGbE1Xb1FpTzFKMHhpNmRvZXhHNGFXeHdRUXBw?=
 =?utf-8?B?aGJEU01sNldlaW5Cam1SZCt6OTd0NGJRVHhqaUtUc3dlcUNycG80emswVDRI?=
 =?utf-8?B?VlVxckowMkh3ZGEvUFdpYW4wbHJjODFmZGkvRzJLdUxBKzRNalByQWxpM0Ur?=
 =?utf-8?B?ZEFFL3ByY3BrZXZaVjdldHIwY2tBa2llU1puRDRPcHFEb0pTVFVPQ0xnQjVj?=
 =?utf-8?B?QklOSGsxRXUybFdWWVJDbmVSSUJBUlE2b3pqNm1aZzJBS205bmMzaTgrTkE4?=
 =?utf-8?B?RGxmWmU2Sm1wVzJHUmI1c2ZYamoyRC9BT2FIYUdRd2FVNHl0bFA2azVyYUVk?=
 =?utf-8?B?SWVHU2xodzdWK3RHWU1haGk3RkVWTXdEYmJ3dlNUbWxnYkJwRGtvQ3VHUE9h?=
 =?utf-8?B?ai9aQVlyQlBLeWlxRDczVjNyRm91N0Ntck1zODR3Zjc4ZU5xbW1xUHo2ekdN?=
 =?utf-8?B?Yy93UGF0MWNtSjhVOUkyb29ydHl3SXc0dkZZL2xTZ3g0ZGRtTzNFVUFsY2Fq?=
 =?utf-8?B?cmNqcEt3QldySDNwZDNKNFNTeHJ3R0ZjV21vRWtFb2VOMDNOQUZxa1QxSGk4?=
 =?utf-8?B?ZkorUEtoZVZrcnZLSkMzR29LZmEvR1dLQlZqYm1NRGd2TVdRVkRvV3pDRzRL?=
 =?utf-8?B?SEQybHlucDNzd2JKUncwU0tsTS8wYzdBdzcvUTJYVWVhRWdVd1h2WHJiTDY1?=
 =?utf-8?B?bUEvZ1lQc3R3aUU3M3F4WkJCUm4rUng1Zk9SQWhnOWdoeVBGVUdZMUZVWXZr?=
 =?utf-8?B?dk5Pd2NoRFV0OEpENUR4dURWSWhjR0tpOWY3YW0wVTJtRW9aKzdzTnAreUs0?=
 =?utf-8?B?YXEyaGpneUhWaThwWXFBbWM0T2ptMldEaGhtS1RhaUo4Nm92dVBrSDltMzBj?=
 =?utf-8?B?UTVubG00aUpiRHhVQ3podHhmMlI3a25SZ0hJclBQditpNnoyTnd4aGVaV3pX?=
 =?utf-8?B?dy9PcjE3Q2djbUdxZFVUaURvUWVyYkFJeHk1RWJJS2hUcXF6Q0VyUGd1L2Jn?=
 =?utf-8?B?Q1JqTkhURExrLzhRQmtXdHB2aHM5QXdNdFFPMGl1ZjROaDJvMDhuYzN0ZWh4?=
 =?utf-8?B?bWg0d1R3UmdUNXdIQklJN09OY1VZcWUrMHNTY2RjL1U2d3IyM3VZZmk1VldW?=
 =?utf-8?B?cTgvNHlodC9oMmQwcjM3L3BoNHRzZnduWjQ4ZHNmRFBzbGQ1Z3hERkFWdjVR?=
 =?utf-8?Q?mys/8dpaHOR3G8hE=3D?=
X-Exchange-RoutingPolicyChecked:
	l8qZOTRjUXccRpHLBzaseORdxLWH6dKXy0yVkg1yMhX1GcKnesKZGa4LX5O8uVgdvFMwkJTHsWPpBwCrB8BPZdr1MbuQaywlxNtllJK5N9x7b3CeadEThSm7B98x7OuC1m+jogT5d7VdxyVMf4H20ahFTyd2QtSVFaHeXJMncMv/R7fMgaP/P+3EVPQme8EBQmyXK3gBaIJxuHPUOjmgv1teemS55H5twBz1hQHPSOAjFyTN8Takwxx4ZRtrKNX1l+g+9KGKRPNasoxq8VANBstsB+LDOJHDr6kPdV/OU05JaTK2LQ/gr5Rvt08VKzuYPbxnp5/Cpt+dZlWtYLiCiQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qd/yuS77UOskCxLj0rIzClIR1jg31ZT4ZYj0G4RNPEJUHL82A14nPrcwr96ONfOj8xL15zyQbNsgoMlqolKPgdvMwbPvs7jzZbPZAu+rfAl/djZ1TS8UEgEsd6EnvgdjEga4PvpmG2Wh7WYcDkv54bWBXYr78T/qB28SgYFMivlLPJAZwgMbJ04dI2igTn7jf8JwOI3raGq6wndHoZtKn8PHFhxcE4CJLBx+dwWOb+bOKKkJh3XDK+UBm5BSb/rH95O/LQJLWliQ6AATVSdQXSngnXQJebq9MUrrTpKUJrpaEM7w1vMJaBdfPc4Yd3ZPoDoZWD07KlegsxF9+a2N9db7uKc9Zi2+YHN4I0B1ANqjasWFpe0yzs1L7yXnxrRT+Phw8gV1vPguFXVBfRr0rnXSD1ZdslsFM4NA8++w4xfJHtDtAsHTIM1FkfBjzO1L2RUjKcxojVRCv/mS9M15IlgcgiEcpdLCOPklLEM2E/0tr/8cja6gtSlyUaOJ/JP3g0ckN6+nZm9Xz/9pL58bOkLnXCzF+ZIIHYgmMZ0fJ6ltoKz2hMgVKG68cdqYejWh5DIefpEmSDlW5K9btZaO+zSw6LIOZOu//iiUo6NYQqY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 603f7e35-2552-41a4-6b65-08deef2cc468
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 17:54:28.7812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXb1sNaFfWEM7DD6+3x3qw/cEYsMg0BjDFWeKGqZEEsFCrRWGGJnqwgbqsJ+1nN4wZO5UTCFjBfroQXXj/WdUBmI1N7TolkmWSaYroYw+hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFBD26857F8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607310137
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEzNyBTYWx0ZWRfXyEkT+9RP8XXL
 ABHMAJMnVPVXTu8tf0TohC8A0vyNXdDevycMQolBcTRwZTNyxNW3vATe/0OZyfDamWU04ym8orm
 KLEWRyYon+eM2C9at0VH8vHj9+EaInypzkS7j75Bcp610v4Xi9QR
X-Proofpoint-ORIG-GUID: eZvcwvsLAnWw1JtEuiyPxy7RaxO5_ja-
X-Proofpoint-GUID: eZvcwvsLAnWw1JtEuiyPxy7RaxO5_ja-
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a6ce15c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=vjukTtsuAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=DUzt5rLphGcXOUafCTIA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22 a=pxVR4CkNEMOefyUi7ZpQ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEzNyBTYWx0ZWRfX9ziYXiYJ5SO3
 Gt3yZFZYeLIn7iZMAlKCRQ6vJnFRzb5FtOlus/BummlqdwjZ829TKUhsNWu1jUPWpquyVu+ae+k
 2wokCVwhAmI4RM7rcfoGR+jm4WxhA1AchsBhcmPBo3bpCWiDfRwdk3NJmOjMtdYA9ffkUs7umws
 7hF0+mYELMfZGDXf8pyVORF6vQCB+3HSgV9C7OLlwy6ghLmwjnkpDlAsVqmxBEW3S2Q8K0iqUJ3
 gvlTxRaRlsanGM+Bdm+ySJwpcs7t3x3rOIe3W1+L3H/Yh8el038Nf2Von1DeglEGew4RG0meQaF
 8KTb+fk91bfVIS0I2zosLydXipu3TcwOL0k9MFhuMleijwYYodz+WVmkGW6wCJlUHjlW0iw72xM
 9kaTUsfwKbtHb4dzex3vrUqmYMHbLniVbzpYpcQybKhWsUG/IU9a58Lf17zD757PtZHhJuGHcuU
 DfEczguCj71WgwKshMg==

On 7/31/26 11:33 AM, Brian Foster wrote:
> Matt Fleming reports a filesystem shutdown due to inobt block
> allocation failure during sparse chunk allocation. Inode creation
> can involve multiple allocations in a transaction via the initial
> chunk allocation and inode btree growth via the subsequent inobt
> record insertion. Technically this should be safe as the chunk
> allocation sets the allocation minleft parameter to the max depth of
> the inode btree, which means the allocation selects an AG only if
> there is enough free space for record insertion after the
> allocation. The record insertion naturally occurs in the same AG as
> the allocation and the associated AGF is locked and held by the
> current transaction.
> 
> The situation that reproduces this failure is a bit of a corner
> case. The allocation and inode btrees are all completely full and
> require a split on the next insertion. The AG has just enough
> available space to satisfy inode creation through sparse allocation
> (i.e. 7 blocks in this example). The block allocation occurs within
> an existing free space record, splitting the free space record into
> two and triggering the aforementioned allocbt splits.
> 
> The sparse chunk allocation consumes 4 blocks for the chunk, and 4
> blocks from the AGFL for the two allocbt splits. This leaves the
> AGFL with 4 remaining blocks and 3 available blocks in the AG. The
> record insertion attempts block allocation for the inobt split, but
> even though space is available, the geometry change has changed the
> minimum allocation requirements enforced by
> xfs_alloc_fix_freelist(). The min freelist value jumps from 8 to 12
> due to the alloc btree level increases, so the available space
> calculation goes from something like this before the allocation:
> 
> 	free + agfl - res - minfree - minleft = avail
> 	2514 + 8 - 2505 - 8 - 2 = 7
> 
> ... to this after it:
> 
> 	2510 + 4 - 2505 - 12 - 0 = -3
> 
> Essentially the minleft value of 2 for the chunk alloc is not
> sufficient to overcome the additional requirements imposed on the
> subsequent inobt alloc due to the allocbt geometry changes caused by
> the first.
> 
> Technically this shouldn't be a concern because a full split of any
> of the allocation btrees in one transaction means that we're not
> going to see another full split in the lifetime of that transaction,
> but the allocation path does not behave that way.
> 
> Absent of a clear way to lock in the agfl state for the particular
> case of multiple allocations into a single AG, this patch works
> around the problem by increasing the minleft requirement for sparse
> chunk allocations. Specifically, we increase minleft by the number
> of blocks that the alloc length was reduced by. The reasoning behind
> this is to generally preserve the AG level no space behavior between
> full and sparse inode chunk allocations.
> 
> The purpose of sparse inode chunks is to facilitate allocation in
> AGs under severe free space fragmentation and thus prevent premature
> -ENOSPC conditions across the broader fs, not necessarily squeeze
> every last block out of any single AG. Therefore, this helps ensure
> the low AG space boundary conditions for sparse inode chunks are
> relatively well tested compared to full inode chunks.
> 
> Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
> Reported-by: Matt Fleming <matt@readmodwrite.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/libxfs/xfs_ialloc.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 633b2d6e42c5..7e71c33fbefa 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -840,6 +840,14 @@ xfs_ialloc_ag_alloc(
>   		args.minlen = igeo->ialloc_min_blks;
>   		args.maxlen = args.minlen;
>   
> +		/*
> +		 * Bump minleft by the alloc size delta to maintain consistent
> +		 * out of space behavior with normal sized chunks. This isn't a
> +		 * requirement, but helps avoid sparse chunk and inobt block
> +		 * allocation quirks at or close to AG depletion.
> +		 */
> +		args.minleft += igeo->ialloc_blks - igeo->ialloc_min_blks;
> +
>   		/*
>   		 * The inode record will be aligned to full chunk size. We must
>   		 * prevent sparse allocation from AG boundaries that result in


Good catch.

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
