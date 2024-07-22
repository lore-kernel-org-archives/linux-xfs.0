Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5FF16E89B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 16:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721666646; cv=fail; b=YT2OouTZXEFsrvEtOVmlFoW0ZjKk3n4oB5moBHIXZsXOvorM56XChSA+2AyQUKyaeGFwPzAZJzwrCmFsgdD2KK6pZe26hYCw3tsXJPxnzN7tmKnwEpuyFPBgx1HXJVlNzgJn3VZA6UA/OjzEmqOHm7hpS+3GxjthVvI6BvJQHIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721666646; c=relaxed/simple;
	bh=BllcItEjSYleB9Q6ZmxBz4Hop8fUli4lGgHRXiNFxLw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cGtzJz1A5U6+5RRKE2/i7/k2flXE6z9jKGEDsZWQeRPwN4O+h7F+uwXsMUv8hJNuG0sUEBxb0m9dx3ATv17C2Z6aX/WgwCy3rNZaH0inUYjrKds569NEofIoo6ZeYAA4fAbNr2FI2fIDaGdJanf9FeCK4jaPXEbilCZ3pVUCkG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RGsxzGPW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KQvMXE4Q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RGsxzGPW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KQvMXE4Q"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MGfZ69009037;
	Mon, 22 Jul 2024 16:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=LJ5D7voLv+lx81EiNRHnY1O/k8FcHIK2BE26I5uekUk=; b=
	RGsxzGPWdBgtnfk7YyA83Eoa50VCeZkkuxAFN/jTznuv4bTRFhi4vXMiYGe1uUkQ
	BuOHDtzH+qLEplZ9Wy6ArIRecQsiSwEoSEJjOvvyyEluYVzC5k4RKz2rJVLSzKgw
	kprR1mhKlUOlamawN8ny37oOWTQjSGjBBUMdbtv914UmrW4SkLjnanGaZP2R43yI
	cAfF7a/h+5lg+BliKCEl9ilICtxTAh80GSKHe+kr8WSCNeO0aIEqXn3KcOkbvDko
	kacMJKlXhERUboL6cdJM8ZzGbeix+nmODWMSUwc/IWFGhN3rpcHzHCtVDb1t6JUI
	63GungsqkIg0Eo1auKOkFw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hgkt2b6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jul 2024 16:43:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46MFsi10010984;
	Mon, 22 Jul 2024 16:43:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h29py9st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jul 2024 16:43:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K6mm/z5ot5o9QJs/C9ieddvf1fw2ogHHNdftGj6keyBGEf0ewOJfvTMJVS/+1QAguDa1w7l8x0GE9kk5lTWOLuW4K0+9+EO7K5k5NCPA0ZYfmuyjJ5h7bVgQSqKCDICqOaLaLQDSX+l+Pu2qVIUIhtczQ1/w+noJ1RVK2cQOZIXx8M9QGKSBAcqumIrSQ1mw8dnVC2a50URKQ6X+o5G0NbOb5NR33mfPyxl+R65GrLbsBxxRsAc/8bAmHC5NgOuPpeVPDyEW5evyyj4Ad3R2RpBc8JFzPd6eZ95+y9aR0PZs8MK5fBXA8hre4Q7Zto7vJ6tSElNCG85Egs1krmfBFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJ5D7voLv+lx81EiNRHnY1O/k8FcHIK2BE26I5uekUk=;
 b=BMFlt4hPoBuwwjOxshr2bynIZYeL6nYHuuTA9T0AINW4VcFzwVzmkI015IjGv2+dv4NmjzI8hVpLnMQeU9wVaDBh6fY/KwGOrEut7rQAT0m7yMqcAuqrcySq2l+kg5uvHTvpbA9Jdy1KB1RiuJxYnqXxdRctQYtsDsjQ9PgWgB8JGEiXm2cm4H/hgoqwB4iKMtgeMXrjm2mnQsLkG9wVIaXu8KjVsJU6VO2exSDlsNNCBzPxqlTQDurCYF81NsnPb0Je4t0O0DA0k7+zgvkuRZlm6RZ2/YP+lIGPRaZ4HgCXnEmOK16afH7iibS5QoQ509Pgqvfrfzjc8hKpIELNXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJ5D7voLv+lx81EiNRHnY1O/k8FcHIK2BE26I5uekUk=;
 b=KQvMXE4QxomEZ2SpsMAhMGnJNdNsWVb+VsPU3TWgNF19Oson/CgulFua6tOHXQj9XIRf4Gkb3n2dHfbrFyVAtM9QjY+vkFFR7LBjbAU/p8gIXntzm+9lpmSY/SQAE2V0eynF1AVm1Jo8ZRvJ2hqDaoTMSeBP71dt0aBIR2Q5sYY=
Received: from SA1PR10MB7586.namprd10.prod.outlook.com (2603:10b6:806:379::6)
 by IA0PR10MB7133.namprd10.prod.outlook.com (2603:10b6:208:400::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Mon, 22 Jul
 2024 16:43:52 +0000
Received: from SA1PR10MB7586.namprd10.prod.outlook.com
 ([fe80::808a:1720:2702:e26d]) by SA1PR10MB7586.namprd10.prod.outlook.com
 ([fe80::808a:1720:2702:e26d%4]) with mapi id 15.20.7784.016; Mon, 22 Jul 2024
 16:43:52 +0000
Message-ID: <7ba14bb7-f01c-4106-8f17-82c013f9552d@oracle.com>
Date: Mon, 22 Jul 2024 11:43:41 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [PATCH] xfs: allow SECURE namespace xattrs to
 use reserved pool
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig
 <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
 <Zp5vq86RtodlF-d1@infradead.org>
 <da41c7f5-8542-4b8e-9e98-2c33a74ca1a9@sandeen.net>
Content-Language: en-US
From: mark.tinguely@oracle.com
In-Reply-To: <da41c7f5-8542-4b8e-9e98-2c33a74ca1a9@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0182.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::26) To SA1PR10MB7586.namprd10.prod.outlook.com
 (2603:10b6:806:379::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB7586:EE_|IA0PR10MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 1589e9d2-8e94-4e29-1507-08dcaa6d780a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHZDMXJFa3ZmNXI4dllMcm5rMDNLeGEyNDNIRHp6K2c4WnN6MHphc2RDblM0?=
 =?utf-8?B?Slh2MlAwZWNkeXF6VDd6ekRPbmM3U3RXZm1CZmJBYm1wNVkwaTRXTkZDelZl?=
 =?utf-8?B?cmgxR0FRUlN2Z2JWSEVUVHpjZUVGcHBpN2xRTlMwaytsUUZ4bXRmUDhldHBw?=
 =?utf-8?B?VXRQb2Q0UTYwcWVWcGw1WDVWU21MaERXU29wbXppeS9zNDdILzBodjQvRXRV?=
 =?utf-8?B?ais0bi9QejhUVGJtTmE5eTJ4eGJjbGwrcFdZcVJRclNoNTI1ZllINlNEY25Q?=
 =?utf-8?B?bXc0b25lekowbGQrcnlwZTM2Sm5YLytkU0Z5VFkydDJHNE5Dc3U3bFdSTzk5?=
 =?utf-8?B?LzJDbGUrK3RBcmhPVnpwbE9JbmlmbS8xRTk1OVgyZHdFOWZrSXVYelRSdU55?=
 =?utf-8?B?ak9kYjhlZml4eUtOS0g3U2ZsTVdXSHVKUDU2UTVJRUVncm9EajFjbjMvMVBJ?=
 =?utf-8?B?Ung0QnhUQzJ0RVVCNWhsWExDM0JBTGF0NGFubXF6eFVhMk1CSkhqWTRsVHJV?=
 =?utf-8?B?ZDRmbDFDZkhLblFJRWdITW9za3ZGT3FJdmYvWXJMUnd5c25RL3RjdjJ2UWdr?=
 =?utf-8?B?QjNQaGJmQ3V0dVdnL2xhaFB4SFNGTU9mbDlPVmwyREFUTllPNllOQUJXbHVM?=
 =?utf-8?B?R01RL0FXbHZZR2JOU2xLdlg1YkIzMnFITU1RNUpXaitXQ05hSHNyZEhqTFNJ?=
 =?utf-8?B?NjhiNm0yL2JVb2k5WUhtOEI1T3VleGhVdm83Zy9DSmFQUThGU2NYNHdqY0tP?=
 =?utf-8?B?WDBMMWRNN3EwWFJGNFRidVBGSlRwY1kxbUM5OGg3dDgxZE93MmkxUlBHaW9V?=
 =?utf-8?B?ZXZoa1I3SjRubmJxQ1IwT01Bc0tHWWwrOGdybE9MYW1NaGgrcHQ5ZzhvNzFn?=
 =?utf-8?B?VE1EVXc0QnliKytOTGpIOFJRYzZFNzRHU0ticm9HZDY3eEFEN0xoNnNQa1lx?=
 =?utf-8?B?Z1dKd0xXbmE0ZG1WWnVIUkU4VkJTZmY1R2I5ZncvbWVFSk1OV3lQb2Z1U0Nz?=
 =?utf-8?B?S3hoQ1NrcmYybVV4c0tVSy9qdjgwRW1TaWFrQ3BuSy93ZW91eWNlM3ZHeTNz?=
 =?utf-8?B?RFByakZlQjUwWjhJWTk5NWl5VkRteEwzVHcrWW4ySjBCOGkzL1NiNlZjZ1l5?=
 =?utf-8?B?MEd6bkVtNjlYNDRISVVzaXVDdWEzeDZqOWtvRkQ5S1grblgzQUYxaVU2QWJn?=
 =?utf-8?B?K0R3cFB6R0dJdGEwc0RzQXlLaW8xN0VZM1dHSnljQzB6WFBPdGNxbElYNkRa?=
 =?utf-8?B?eTgvRFJZOXROZXptMUVvWUFia2VFT05oeHZjSi9LVzBGQUZ1enRlMmpTb3M0?=
 =?utf-8?B?L2xtb0Q2ZHlxTHVBaDlJU1RwWVhFMldvZTdOUjIweGdSQXc1Si81WU4rUE82?=
 =?utf-8?B?eVFEMWN0a01LZ3AyWVUvc2ZGUmVuVGZOcFhYWWNGOUltQmRxY1RnSTJGR3R4?=
 =?utf-8?B?V293MEtvVkI2N3VpbkRNZkpBRWl6ZVFFSXVuS2FIaHNQbStPS0tianNzOHZ0?=
 =?utf-8?B?UVNpUm9tVGd4V0dDVGFBSlhpU1dpeG9MalJ1YnlKSk1uc2J6V2ZrdG0zRXY1?=
 =?utf-8?B?WHRmejFxRndMQTdjVndPVm41eWxRaW5xMjNHOUNzVEkxZkZZcjF5dGpXY1hS?=
 =?utf-8?B?UG1Gb2dDY25zcXJUK24xQnR5SlJ5M205YURhK01RL25PMU5HZmxlUTRveUlH?=
 =?utf-8?B?aVVCbDcrelZpOGUzUnBhTWlDQ0F2cUhQY3JidUVpQStBOEZyWTg5U1hpOWVq?=
 =?utf-8?B?RjlNWUljK3g3RzNSUldNNU5OSzdiNjB0bDFjUW5qOHRiZzFEdzhCNThQa2dw?=
 =?utf-8?B?NWxSSGo5bDFrR0Yxekw2UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB7586.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXNWTThiYjlTMVVGWDF3bEhuRmwxekFacVRianh1K3FrK2labC8rSU9uWi9p?=
 =?utf-8?B?L2c5bWRBbVdvVHZ4UXZoMWl4S0FWSE9NaVNxNWlCQkZzQ2JkeUJodEhCc0tx?=
 =?utf-8?B?TldXM2ZNdUtHTnVIOW9mWHVmZnZVSWhrRnlMLzlkUXEvZzVGanNtdEVxL0RB?=
 =?utf-8?B?dUJ4KzBXT0pscGNvQjlTTGc1WE9kbHNKZWo5TUorcG0xcGhjL0Y2bHJ0Sysz?=
 =?utf-8?B?bnBkTG9wRnJvQ0VHTzhVZWtrYXVtUXNwTHoxUlRFZTlXcXh1eE5NN1hHZmx2?=
 =?utf-8?B?Wm1BeDhIMXRLRmhSbm1oOERJb05KWFdoNzZOS0RRSUxyMitMWXJyRXdwQ252?=
 =?utf-8?B?emVJYW9xUDhxVVljT21tUVZ0a1B3TnYzUGkxUEYydlQvenNRREtpWEUrRzk5?=
 =?utf-8?B?RU1CUEpNckJsUGxFM1FBdU5DT0FmSUwxcHNqT1RNaW9yeXM3aEZEeVAyaXha?=
 =?utf-8?B?eWxQUDRyUjJKazJDY2tBajNEbEw0aHE5K2RYb1lEaTRDdVBhVktuR1ZaVEpk?=
 =?utf-8?B?SnY1bzQvZXpFV0NCQ3BwNExVT05IQUdteFFNNXo1NCtOQkRnTVFJRVd6YkdU?=
 =?utf-8?B?VGRETEFnVlgyVE1aWjlwemsxNWZ5cE9MUEY3eUFSTGdRQk01dDd5Z0Z5Qk9P?=
 =?utf-8?B?VzdOZnVESTlQWnNQeGorUWV3TXFkbVZWbGE0cGtUK1RLM210RGx3OXpvMWxo?=
 =?utf-8?B?ZmxkQjFzRFZNQS9aVW5GeTZwYmE5RjhBcU16a0p4R2lINzNXTTBhMkhVd0po?=
 =?utf-8?B?RU9SQmJZR0FsRnZPOE54aEE0bUl2cFVnLzIwWW5nOXdoMGVhL0MxQzlYdE56?=
 =?utf-8?B?M1ppZSs2VE9DNzhKYWd5RGdXTVZpSmpTeStjTWpTQ3o3c1dPTUUydW42QlJp?=
 =?utf-8?B?YTcza0NtRGpXUkdBenIxaUxyYjFlSkovTHRrRUM5UTV1LzRFUDhDRzRsaTJl?=
 =?utf-8?B?YWdYWkxOdEVTWStYZmE4TEl6L3dKWWZvaDVqcFdndkxoTXlNSFlnVXJ3Nzhv?=
 =?utf-8?B?MzJyb1ZadHB5UkNYYnRvazd1SEJmdGk0cngwWWhKbncvVXl5bHZMdkFYaU9i?=
 =?utf-8?B?NVgyUUVZdEF6VG9RS2prVEhwMHF4Rm1WQlZTK0RpOUxSM1JkdGdhMy9Xakd0?=
 =?utf-8?B?K1VYUzFzTGVzYysySGJvZXR6clpBSXVyV3dDSmFJVnUzZ2hBclQ0d3dKZjJL?=
 =?utf-8?B?MUZmQ1VVSE9lNlZwV2dBZnRMeDErQWlSOHNQeGlpNkdZYlRKVSs1NzRzZVhT?=
 =?utf-8?B?VnFJRnRjejhtZVozNzlaVlA4M0NqTE5QdkZ3VnJlaENVTWgwVkxhWC96V3pr?=
 =?utf-8?B?MS85VWNJUHBvZmh5WXNIeFZjdUlFeGtKZmlsZk4zYWxxTjdTOCtsaTlkVlE5?=
 =?utf-8?B?aE1Jb3JOYzhLZWVmbkdERUtody90ZE13ZFROQ1FVd21vbWdqd3M0aCtBTG5M?=
 =?utf-8?B?anlobHNhZjhtVlc4bnpwcmxjYzVESzd4cmt5Qk5NcWZOblBQSlNqbUMyZ2Zs?=
 =?utf-8?B?Q2pnaTNlLzNOdGd1V2lTKzlYa2xlWWV6OXdxTjBZTG84cTRsK2FJUE14c0Z2?=
 =?utf-8?B?emhFTjJDbERJUjVhS1VuQVlQNUt5OUprc3dBbzhqdGdxaCtJNnduUWFoL1k2?=
 =?utf-8?B?eEhDYmoyc2RmMTNTVDVUZStySGtieUFkcWhNZFBoYW5UY0RQQ3VMZ1RUckhE?=
 =?utf-8?B?RGJZNVZvYmhxY1NBQ2diQ0RIMmlxc1JQam5POFZrSitDQ3RqNjhYUkZ6TkJT?=
 =?utf-8?B?UmlJNEhrbk1panZpUmFycXdpcGd3QzBnSy9yOXlmZzNXUExjUGE0RkQ2SUVk?=
 =?utf-8?B?NVFPbVFxamxHWEVucGtyNjlZOHZZMzdaM3U4VkkybTRRZlorWUdNVmx0dVZt?=
 =?utf-8?B?enRXM0RlbEhuUzczQmp3WGVzd29qOENTMGpaVEtzdk1lakFXS3I2U2FOdExY?=
 =?utf-8?B?T21JVnNYakQ2Yjd6aDR1UnB3N2lkdU5hTEVmdkYyWklWLzh6SzQzNzdaRmJu?=
 =?utf-8?B?alUwUTc3bFVUUmJxemdkZWRCdC9nbW8vbXBpTG42U2c0ekhUTk0zTkkzMUpu?=
 =?utf-8?B?aEc4aXlsYzd1SE1XYVVhMys3YlRwdDlscGhtcUpXdXVEM08yYmNncFZtTEh5?=
 =?utf-8?B?ekpzTHF3bHRKSVlNRFJpdHp1THNJOEx4SzZCQUExcWw4SDlhZFRzL1JoQnZS?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xM+Ed61Tn69vCPnko/8I1MEuXjYza0uWNT8+VZ4rQAHiTY2nllfJD5BmIyEq44jiWcW1GWsbGg4sgCO92qP8Acu14eGhBfsu5xzbWRFOeYcH8GGimgT8jtEPk8iPFLImIVKvtVuLOGZX7C/CPK+BnJlfp8BYeyJaI9KpDcXp79i7jY6989s2Wm7lB05y9SNTvb/PJi8bZzXEE1yMOZq2PFNpWIZBN+0ZUtmWfFuP8tPU60C3XqCEYMEaDqdGVET4gYP1Y9hBVgazRQhDIVYJJOUkdr+7onFjYskQqBkd8p6PXI7UwrGJ3u/E3wOKcokA+LeNKctNgJUJdFTKn9AV/mfE4EUGSe0hJCvGIn8WIb4FtLPBw6/OR9NAFJu+3svvNBfHXgMBhBGs3uk1HT1fqTatvr8MUbDTeAGlDdMrPTwpfwBYSZLfHnvmS6/HRD3yHgqJeqGNiCkLlFoy4cA7nBeyrb7xegMhZq1dakvl/17KP60gjnQqNhRaTtgctJ2IaWuWJzv8W/be3YknkTdHgqRSJVUPBtvh/HbdfLlFXeNcu105Xo6RjmHBh5CJri+MhLOAzxybvzWZ0WhB417rdz0F7v+bFI/7vhnhLOhzRXM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1589e9d2-8e94-4e29-1507-08dcaa6d780a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB7586.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2024 16:43:52.4080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0juQqIEW3bmqDpcuPFArIMOtmXIJ/MKiLqFNQa4vPKKHrIQU/ZZFb43dEOvkwmSHAIKfAWCvooZhTzoZY1m24CK5xLrk9QqjrHMGt6JUZyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7133
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_10,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407220125
X-Proofpoint-GUID: -PKpiFuN9B3xMB-HGuTERAuMgAviO3E8
X-Proofpoint-ORIG-GUID: -PKpiFuN9B3xMB-HGuTERAuMgAviO3E8


On 7/22/24 10:05 AM, Eric Sandeen wrote:
> On 7/22/24 9:41 AM, Christoph Hellwig wrote:
>> On Fri, Jul 19, 2024 at 05:48:53PM -0500, Eric Sandeen wrote:
>>>   	xfs_attr_sethash(args);
>>>   
>>> -	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
>>> +	rsvd = args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_SECURE);
>>> +	return xfs_attr_set(args, op, rsvd);
>> This looks fine, although I'd probably do without the extra local
>> variable.  More importantly though, please write a comment documenting
>> why we are dipping into the reserved pool here.  We should have had that
>> since the beginning, but this is a better time than never.
>>
>>
> Ok, I thought the local var was a little prettier but *shrug* can do it
> either way.
>
> To be honest I'm not sure why it was done for ROOT; dchinnner mentioned
> something about DMAPI requirements, long ago...


The older Data Mover Framework (DMF v6) kept an extended attribute that 
denoted the file status (online/offline/partial online) and some region 
information (which was never used). Yeah DMF uses Data Management API 
(DMAPI) as the hooks to move data in when offline.

>
> It seems reasonable, and it's been there forever but also not obviously
> required, AFAICT.
>
> What would your explanation be? ;)
>
> Thanks,
> -Eric
>
