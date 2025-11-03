Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C09305E04;
	Mon,  3 Nov 2025 12:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762172192; cv=fail; b=D+TTTDto2+iDYyr61emjPFiQoPgsTfNkSLhYGfjxRhoYIiwWeWVvP1jTTe+p007lZm2yqA9Jkh/52kkS59orEV08IT2jb7x91TcoqlFozGq70XjG8psavdYxZSC4uSwdrWPjHwRrSsJxZcncQeKFoNaolL1+TiAxAJXBKjSFwqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762172192; c=relaxed/simple;
	bh=Z3ECokx1FiwkOg4F0pK+W9ruHGEoK2Ro2tjSa//n/ug=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mksmHN2VzRyPWaI4LFgk1qR7r1bjX0EUcmCpw4ChmWk5aMzrv5XWbrk4YG6yu0++q2VAtfkyHPsOGIOlqrLy0oMp5mN03P/3LkRMngtIzrr1SXTWymwTjSMze689HrcEFTNrUvRp+7c1g9/reycuS6YlKFjjSuv32Few99bnP3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X7BFYx6q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hh/8QuQJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X7BFYx6q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hh/8QuQJ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3CEfP8017288;
	Mon, 3 Nov 2025 12:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=b7yZzrarAql9j2F1gicGf5eOlIprHJ3JkCgGHUrqmEY=; b=
	X7BFYx6qTCgdBNVmNXI3u2icf+1+Px4iZauYua7nvTEvRQXjjKoKxCicfhC0qV6l
	DvtX1BdRi0rwqXvI4Lz9K4SdYfXFZIuSz3Y3a5Y/+TnUMBm1z7U/BBKlsDRqwpkW
	+AL34PHnnfEYJWPuYrtpLHPLCyVkLjaheaGjyRrsW98TpKtQJNso5RBSi9pbQZeH
	igOl3HF7ebRysH/E2CrYNd6cLcN22cI+/Ghv51OE66eChTOdp3Ghz/QDEmiIEi9l
	VWlBa/+ppECS8TGPc6ObviYShxuoKZSb667pdL/v1BI0egaflpUNgsUtJRzcS0R+
	jFJFuPOr3iYR5XlvQKYIMg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6v7kg04a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 12:16:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3BRVCG010263;
	Mon, 3 Nov 2025 12:16:23 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011067.outbound.protection.outlook.com [52.101.62.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nbkb56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 12:16:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NUqDv4/p1XGXSMxv9WHpe4sB2b9YKCsVFoZYkOTnEvbpywDqMaFuf2M1Y7+apF/kSu4lj5HCQb820qVEgtXVPnCCJOHTfimDgOI/GXX/iQ8bUlvFI6tK0RxzVPuX7tFpXrAqsQw2NaPYiw+At9hPw6UAim2x5W1c/IcVkDaWjFzxyAOdDe7LD7QEi+reLJK6uJ0RkcovSvko4DdhJjyToQtOkbPbZSlnRLu8KzarUAySJt6oTgl7dn97Vlgm6sv7vgr6j3AViqRzrfMr5dhP0NR2uoyRBT+Qcc8PXdb1Fls9ISJRXnadBlJ7yfHYGShNyT2/HJQLMq//CFqKk/CJ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b7yZzrarAql9j2F1gicGf5eOlIprHJ3JkCgGHUrqmEY=;
 b=d0vD4OsFKu0Pd0b9fqSxUA/q43UWHifxREeSzGgl7zi/2da7HMI9ZawxoJbQfZjrxVY1eTQp/bQp1btZUSUVm53P64VAsoV6yj77VcAi5sJekKUBocif26rpwa+jTTnub+QVoNzuxOFKq2hpw6/lchl1WF6ciTP2ANTWqA+Y/aMIStpYUjPEHrI0Kvdj6O0jc0h/3jUnYptvxjtQ5QDAhg6uoQf5z5PtX6AA0ZJ0vl+bg5QFRuUaUCbHTFga4x+qYhqfIXyHsjidlvxOi9gACR3+LsbiyJDrLsxr9E84mrsqIDDxuwWVEMmNAFqAxCQgdaXj+s3o4bOar468pB0NIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7yZzrarAql9j2F1gicGf5eOlIprHJ3JkCgGHUrqmEY=;
 b=Hh/8QuQJWBUqdlQyvAvQv1mOgrVzHLBpvQuhlwhYH2m7+278z8W++n+WuV4PrO/d5gW4zIEehJdDYxw0oH85rb1FKi5PfJR6tq/TySLkFMKb2/I12cGQ++y5DlKMyJKSXLYSlJ0q8SnPm9lsZwYhMeW57+Ic0x38Z4JfUDkP1ig=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA1PR10MB7756.namprd10.prod.outlook.com (2603:10b6:806:3a3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 12:16:19 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 12:16:19 +0000
Message-ID: <64128e92-44a7-4830-86e7-2c98383a9f28@oracle.com>
Date: Mon, 3 Nov 2025 12:16:14 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
 <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>
 <20251030150138.GW4015566@frogsfrogsfrogs>
 <c3cdd46f-7169-48c9-ae7a-9c315713e31f@oracle.com>
 <0c25aaf1-e813-475f-ac7e-a05e33af91f1@oracle.com>
 <20251031043024.GP3356773@frogsfrogsfrogs>
 <d787aed1-19ad-4fb9-ba64-33d754d46e5f@oracle.com>
 <20251031171330.GC6178@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251031171330.GC6178@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::15) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA1PR10MB7756:EE_
X-MS-Office365-Filtering-Correlation-Id: d3b6ba1f-8c43-4986-b1ad-08de1ad2cadb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1M2SFptbzdMbk83VElOZ2h2RE80d204cTRNZEljUC9oZmY2Z21mU1IyN1Z3?=
 =?utf-8?B?T0VBMzVyejNNZjdXRUt0amlqUTNSV0MwbG0xNjAydElZRHdmdzVmT2M1RTUv?=
 =?utf-8?B?eTZhYnBEWHpyZFBmSUp3cWZmMitMNVp5eldTcVVtYkZzZFJaOCt4SGhTNkZ1?=
 =?utf-8?B?UzY4bW9ic2NWY0NOQm5rMDIxWWp4eStJQmwxWStrRUYwUTJPU0NRS0swcjhp?=
 =?utf-8?B?aXBEQnN1Ykt6Zm5FdnE3eURWWVVPOHA5Rzl4LzExQTlBYngreFhkZCtpVURw?=
 =?utf-8?B?a2FhL1ZDK0crWm1STzExWC8ySG9rVlh0eUJmeGo4dXJQeUJDVVJyRnZpTGhC?=
 =?utf-8?B?L3JPSTFzRTdSYjZVSUhZU29rQXo5VXQ0L1lMUVIvR2ZKWkp4em8rOTZZQmll?=
 =?utf-8?B?amVIVytzbU8wRDBSZE14MDJ1c2xIb0pkUUZ6TGZFZ2dMcSt6TVFwSUlTb25y?=
 =?utf-8?B?NlY4ZmloSU1SNEJISGVaNmdJczZ0dW1IRlpHemZ2VStCM1dZUDhoMVI0UDFT?=
 =?utf-8?B?SDJobW9MMGJKTkJ5dW9GMG1oYWU3aTNRVXFwNlM2ejd3aVZpZG9YeG1LbTZt?=
 =?utf-8?B?M3hWUStwZ3REZ05NbFFSMkppRGlBVHd2Zmd2UDQ4eHF1aW9jYWZBODZWZTFt?=
 =?utf-8?B?eUsxa3Rlc3JaYU9UWDZBZ1BlcjhPWVI3OERyaGVrNHVMYUI4b0ZKR2lEY2RZ?=
 =?utf-8?B?dWEvQVQ2LzBWaXkwUnVYdjlOWjNncFpqZ2NUNHZEbnM1NC9XRmVWV0hmM3Iv?=
 =?utf-8?B?VDJRNDYxRmh0M051eHRBeThLcENIZ05SWGZWcGZOeHltZG1ieDg0UzhEdTZp?=
 =?utf-8?B?V2xUQ2ZzKzJjNWRJRU1DNW4xK0V6ZXlvaTNBeVFValFtYjhlMjk4NE8vMlAv?=
 =?utf-8?B?a3psL1dwVHpFVFltV1Fad0hNc1dVZHVZaVExb2JWY25tWEJ0Vlp1SExZSWY4?=
 =?utf-8?B?UElGNXhabUZ3NUZOUlV0L0ZpVWlMdkJ5U1E4V2V0ZWJYeVRPSVo5bGVlZllt?=
 =?utf-8?B?OFNKdmZoakRqWFlaWDRuS1JDeWpPYmpWR2hUbU9ncmoxVzkzWVlEd2oyN0xX?=
 =?utf-8?B?NDdaL1ZjNmdZVFp1TzRpcGF0OUlIL28rSjJqRkpvM2lqbU1zMmpmNC9hSVNW?=
 =?utf-8?B?ejg2NzNMNURDQi9NaWdScHJHaVNMc1ZXWG82emN0YWF0UXJZWVNQdjBUVGRl?=
 =?utf-8?B?bGRuZXdsWElhUllGMVVZam1GT1dLK2xwS0RCd0EwcWd0Z0VNTTZ0Kzh3NWFp?=
 =?utf-8?B?TDNpT3luenpOZm5Bem5lbGl5VnRrN0VCanJXWnFNVU9kVW9VY2NDWmk0Tk9i?=
 =?utf-8?B?eVNIK0ptNmpBcHFLVlhxR1ZsazRXNFFOTVhNR0tKMitjUzRoNWNjUmFLS3Bh?=
 =?utf-8?B?NXdFTVp6YUtTeFNaSUIrczExUDE4QTkvK3MxK0d6eVJLWDhvMHFlRU9YSWdm?=
 =?utf-8?B?RVFVakVqZW15SldYd0cvQko1TDlZS05RQitPRUNqZjVCc1JlbW9Ld0thTHEr?=
 =?utf-8?B?bHZWR2g0c3pXK01OdWVNU1VzU0RhVHozbzZZNDVKU3d1T3ZmellnWlg5Y290?=
 =?utf-8?B?WkxrRnNvRG41d0JiZVhRWHNTQ0kvMFV4LzU2Y0c1UnBsUVJ6a0RkSXhpemtR?=
 =?utf-8?B?MGpyZWFUSzNFSEVuam9GVDdOR004ZzBsQ2Z4NE81NWpiM0F2ZSs0eld0Mjdo?=
 =?utf-8?B?UjMwTjdqWjNRQUo4VHozek95bU5YR2gyODBINGRKR1B0K2Y2YTIvWElDWGtz?=
 =?utf-8?B?VFJkZGZZanN2MkU5ekRuWFgxaWtNeUV3MElRWjgvMmorOGtFVHBOTU10Z3Bh?=
 =?utf-8?B?K1lIdnUxV0NvbmFZK1U2b21ZQWtPZEVGQWhoM0h5dWUxMWhsMkpWVFJTUGhz?=
 =?utf-8?B?VmtiWkVBVDVjb2ZoRENRa2psbFpiSU1TdFRlVWRoSHp0Y3FRN1dTL3Y0cmpF?=
 =?utf-8?Q?2NWyweF9dkuhQxGBXfWLxtVMFbaIIoPE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0ZSbHUyK1U0YytDRklhK1ZuWFhvTG1SK2xmTnBzSnFzSWkyWEV3eFI2QTZD?=
 =?utf-8?B?T0lrTC9rR2xXaFNvYVE0RCtmVTE4enNrTEpHaEtzK1dQMk9kY3JpdUNqWGI0?=
 =?utf-8?B?Zy9nTXc3aFlYSUh5cjBwd0NuY1pIMFZaQ0JUakZNelNEWllsNjFkRzhRcm94?=
 =?utf-8?B?V2RBODdNc1VkMmRWaU55Q0VzMzhaTHd5RXNuNDVqM0pIUGxmOUNjYW1nNkQv?=
 =?utf-8?B?YnpiOTl6eVB1K09nbEViK1NnNzZ6T0RpSlo2b3VmTDNHcUV6S09ocUJLUVFj?=
 =?utf-8?B?dTRXN3JFeXp5THVOeHAzMU10RE4wY3pWNkNLQW9LRGlua3RCUkV3QVhmR2FZ?=
 =?utf-8?B?SHNFbXFKR1dlVjloOWsvbHRRb0MxR1k1MmRSRzY4MXZyaDdPbE5Gd3VUNFNk?=
 =?utf-8?B?WWNXOUNMRFZYa0kzSjBYV0tQMFpPVUZnZWZxaFMxcG1iUUxtNmlRTURTNlc4?=
 =?utf-8?B?MkVwK2pZajlGU2VOcUlVQTh2cTZOZmpyLzJzN2trVnRjTEFpT1RWczFWMEhz?=
 =?utf-8?B?UmhnQVl6MGpUNmZ0RzRyZjdsZWxmNzQ5bGJLT0RKWElSZWQzNlFOSWdTeXBl?=
 =?utf-8?B?Y3ZxZmd2am1objBKU2t5VitYM3ZEUlpjbTRnWjU2YTcrSmxVRzhtbUM2Y2lN?=
 =?utf-8?B?WjFYcURtekNueUllcVVHS0Q0ayszWFBvRkVsb1hFQ3NXNmYzZFJvazRabS8r?=
 =?utf-8?B?VTg1U096eEt3Qmh0RUU1VnlSTE1OaUJqWmNYVG1GMGhwUWlwT3JWTXhXaWdp?=
 =?utf-8?B?Zm5VRFpyOVJwQ05HUHFvU3VnUVErc1cxWEZEd3RGL09saHoyTndlaEV0OUhl?=
 =?utf-8?B?UTJ1dzVhb0FRZEF1c3AwVEN6a0NXTSt0ODBtOEpVMXYvbWR4OFJQOG9adFVy?=
 =?utf-8?B?bXNoMFdzY2tVMGFKZnNZeHVYcDRHelRQK0RKVEVuNmNtRHdnL1ZuNG5IU0pz?=
 =?utf-8?B?dVRCeFRQYkovYVJmOVhWeU5xN2tHYlQzTTNtampFei9pRUxRNGo5Ykh3Z1RB?=
 =?utf-8?B?KzZCeXhBVkhSN296aUN2MVlQTjgwamZZUGs4RkxMcld2V1F1SDM3d3lHTUpz?=
 =?utf-8?B?Z2gxWmR1dnNKdW5qM3REOStwUWx2VVVJaEtTRittaG9OamZ4aHNPdmo2ZGxZ?=
 =?utf-8?B?d0xnVXZhdjRHUzJibHpnNm0yNy9iTjllZmcyeEE3T0FJS29OOEl0RU1RRjBo?=
 =?utf-8?B?OVhYMDIzNlpUc1NlZWFIeXUvQlgwU3hoZ1NlU0FJakU2MThNdlVmTU9kaVUx?=
 =?utf-8?B?Yk1hbmZCRlNCcG1vU1lyYVVNT1N2dGFndWpGNzRWNFkxeXh1ejNXTjcxTHZ2?=
 =?utf-8?B?bnlQeEtUQkJLMk9QTUpLNjZyQ1BFZVdCd2l3TS9wZWpZRXNqdzdLK1FnYUpm?=
 =?utf-8?B?SGlYMkRkNzEyNW5BbHdyTUJqbXRmcHRyUi9JVTlnaDBBcVBhNnREd0FpL1F2?=
 =?utf-8?B?Q2M1WmZGSnltQVdxVkNFNkI1SGdaTVFjRkw2U2JBRW1JeTlPWXpRRVo0QUVV?=
 =?utf-8?B?ZGx3M0dOa1JXOEliVUxCU0cwWFdSTzFDc21yTFhHdUxTb0M4WlNhWGNKSmF0?=
 =?utf-8?B?UUF5M1RicmZ6RzZaalZON0VTR01jUzdKZFJMTDlKZk9JZG85dVpaRUJDUTY5?=
 =?utf-8?B?cHZoZFBza3JwVnYxZTI2Vml4NDlPOHhyNHQyQUhNb0xUbnR1b1h3NTZOTTNl?=
 =?utf-8?B?a1RSVFd2V0NwcGk3RC9McTBydUVFV29WeHRqQTRwWXY2NWgzV0R5L1JpREU3?=
 =?utf-8?B?ckc4clllUjJNSmpaZ3hVMWtjREZWRHlKeFhCQktVQXdCZFZmS0VaQUs3Zk1q?=
 =?utf-8?B?MkxCeDB1SWoxT2xnSkNQQUVCSnl4b3dHRERRdVlOcFpLZndtSEgvOGluS3dV?=
 =?utf-8?B?QlFrVExpcnZ5MTVVZitCR092RGNYY2puMG52azJ1R2k2OVQ5bm5jV1dER05E?=
 =?utf-8?B?V3NEMmJ4SDdCYzJPM3ZHRE9RaUJQSmFKNHQ4Q2tpcFNOQVpaOEpGcmRWcFdj?=
 =?utf-8?B?UklHWVZka21rSGYxVFZJWTJIVWNqOE5RekxZNFVwT0hZcGlWeXdlTWJOWExj?=
 =?utf-8?B?S245dWNmZklJZk5GU2ZQLzJSa3pHK2hjMWdXMmx6Q29hcGFHNTM5NEJjbTdk?=
 =?utf-8?B?UHdoUTBZTXpzbWcydXNUWU0xSnVaMkJGZjZ0YUxGSjJnMS90a1htS0hESnps?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tV2JIABCRPBFfcsLOX7szh4No4vlfwXy8iv/LZY7QRqSoyti/lX+XCfYRnMaekmPDfTjUzKfVTEpHyXPZy8GLw+mepOE/FtdxqHNxn3WLmhMYJ8DupA53Elo56g3PkrPT5dnTbXsqg4qeTbQ7aJXtoR7HYo89uN8yIZ/ki68PUjxsMQ1f/Xr3m9yhKd4s/y8SUZ2UcApTg/ZcXrcVNM3oXyzIOsJi2qmY4oO96fFLPXaCI33g0gpuVJsLNY4dNVz/1oSXMt2u0TU34POoB7QzQXsbAQuUeX3ryyEQrNWTbEASW5JlsyA7P1N9s3Wn3gO+82V9JI8Jmwlmo6jkvhyb0cfCyfxzVC+Zgyhpzdn9Wzae+g9E3AyD5NQL4+EnZJC51wUXp74ssB8SoU7V4y7YiB0F/TxaaYqNgBJMcsRVG5LdcugIsJCMevkad0MDlJSUNuBNmmJhOIh11gHIgWr9MIpw80o/EzSUvoxzejDyikmeU4DIWv4vXrnf4Y1SYo4NqrLgnFXtRNBxbjZLX5crITeORsm+1YaA4I0OyFikfF4a1Ks1h37o+vwzOInoKXfrk9KcE7sdAp/zcpm0v2EZ5EuB48h3Ka1w9/vIqDLCj0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b6ba1f-8c43-4986-b1ad-08de1ad2cadb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 12:16:19.2239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkcfCic7DWIdnKRDuC++QF/zVpxAj4pWYQ6PuvVz+j5kGprB2TVKyctmpefapsZ1BwWtE6PB6beMnWmH/mjqgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_01,2025-11-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030111
X-Proofpoint-ORIG-GUID: CRuo66VPJrNdjvuXK38aWNah64SA9FmG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDExMSBTYWx0ZWRfX036qL6MngzFo
 PxIQ4uZgmczaI7A5TrslhKwkW5d3KSep6rNOFzKuXLx+5W1ML/6vZWZwCbQ2001pvZ3NFTJxHwI
 7BxNQN/46F8kPdlIVOPgFLN8nOciIWHzniz8hgaAS5ZZT17YkeVtokGnPAF4syiW8Zg1B0IVZrS
 lrOVgE+PZ04skV08dfH6Zcez90PUEe7e7RY3bD3Yqgc5Y8OEK67RZzlpMbR1T7CvKZB3i60Hpvz
 y8JiQHP/G135reOrvHfxWvSWzCBMNOchMoCuu0Mi6UVMQY7v5uXTBq62h8aP3vXf2sx6xZfjTUM
 makd7y9YVsfgD1b5r5HEf8z9Gnp7FIue6nbUmiRgJDTAQndpBEADQhLB4JLP493uCozZn7954Lw
 LInv8x8PwLK/MD17HR6KcJBpnIC7SxWVQC3RcjWgKXtEPJ9lqhs=
X-Authority-Analysis: v=2.4 cv=Fbs6BZ+6 c=1 sm=1 tr=0 ts=69089d18 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=vqBNzhqifG83Ju7sTjkA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13657
X-Proofpoint-GUID: CRuo66VPJrNdjvuXK38aWNah64SA9FmG

On 31/10/2025 17:13, Darrick J. Wong wrote:
> On Fri, Oct 31, 2025 at 10:17:56AM +0000, John Garry wrote:
>> On 31/10/2025 04:30, Darrick J. Wong wrote:
>>>> @@ -1215,6 +1216,7 @@ xfs_atomic_write_cow_iomap_begin(
>>>>    	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
>>>>
>>>> I think that the problem may be that we were converting an inappropriate
>>>> number of blocks from unwritten to real allocations (but never writing to
>>>> the excess blocks). Does it look ok?
>>> That looks like a good correction to me; I'll run that on my test fleet
>>> overnight and we'll see what happens.  Thanks for putting this together!
>>
>> Cool, but I am not confident that it is a completely correct. Here's the
>> updated code:
>>
>>   	int			error;
>>   	u64			seq;
>> +	xfs_filblks_t		count_fsb_orig = count_fsb;
>>
>>   	ASSERT(flags & IOMAP_WRITE);
>>   	ASSERT(flags & IOMAP_DIRECT);
>> @@ -1202,7 +1203,7 @@ xfs_atomic_write_cow_iomap_begin(
>>   found:
>>   	if (cmap.br_state != XFS_EXT_NORM) {
>>   		error = xfs_reflink_convert_cow_locked(ip, offset_fsb,
>> -				count_fsb);
>> +				count_fsb_orig);
>>   		if (error)
>>   			goto out_unlock;
>>   		cmap.br_state = XFS_EXT_NORM;
> 
> Er... this is exactly the same snippet as yesterday. <confused>

Yes, I was just showing it for context.

> 
> (That snippet seems to have survived overnight fsx)
> 
>> cmap may be longer than count_fsb_orig (which was the failing scenario). In
>> that case, after calling xfs_reflink_convert_cow_locked(), we would have
>> partially converted cmap, so it is proper to set cmap.br_state =
>> XFS_EXT_NORM?
> 
> Hrm.  Let me walk through this function again.
> 
> At the start, {offset,count}_fsb express the offset/length parameters,
> but in fsblock units and expanded to align with an fsblock.

I do also note that the usage of xfs_iomap_end_fsb() is a bit dubious, 
as this will truncate the write if it goes over s_maxbytes. However, we 
never want to truncate an atomic write.

> 
> If the cow fork has a mapping (cmap) that starts before the offset, we
> trim the mapping to the desired range and goto found.  cmap cannot end
> before offset_fsb because that's how xfs_iext_lookup_extent works.
> 
> If the cow fork doesn't have a mapping or the one it does have doesn't
> start until after offset_fsb, then we trim count_fsb so that
> (offset_fsb, count_fsb) is the range that isn't mapped to space.
> 
> Then we cycle the ILOCK to get a transaction and do the lookup again
> due to "extent layout could have changed since the unlock".  Same rules
> as the first lookup.  I wonder if that second xfs_trim_extent should be
> using orig_count_fsb, because at this point it's trimming the cmap to
> the shorter range.  

Yes, I think so.

> It's probably not a big deal because iomap will
> just call ->iomap_begin on the rest of the range, but it's more work.
> 
> If the second lookup doesn't produce a mapping, then we call
> xfs_bmapi_write to fill the hole and drop down to @found.
> 
> Now, we're at the found: label, having arrived here in one of three
> ways:
> 
> 1) The first cmap lookup found at least one block that it can use.
>     (offset_fsb, count_fsb) is the original range that iomap asked for.
>     This mapping could be written or unwritten, and it's been trimmed
>     so that it won't extend outside the requested write range.
> 
> 2) The second cmap lookup found at least one block that it can use.
>     (offset_fsb, count_fsb) is a truncated range because the cow fork
>     has a mapping that starts at (offset_fsb + count_fsb).  This mapping
>     could also be written or unwritten, and it also has been trimmed so
>     that it won't extend outside the hole range.
> 
>     Why do we trim cmap to the hole range?  The original write range
>     will suite iomap just fine.

I think that the xfs_iext_lookup_extent() and xfs_trim_extent() pattern 
may have been just copied without considering this.

> 
> 3) We xfs_bmapi_write'd a hole, and now we have an unwritten mapping.
>     (offset_fsb, count_fsb) is the same truncated range from 2).
>     cmap is potentially much larger than (offset_fsb, count_fsb).
> 
>     Why do we not trim this mapping to the original write range?
> 

I don't know, but this is what I was suggesting should happen.

> If at this point the mapping is unwritten, we convert it to written
> mapping with xfs_reflink_convert_cow_locked.  offset_fsb retains its
> original value, but what is count_fsb?  It's either the original value
> (1) or the smaller one from filling the hole (2) or (3)?  Why don't we
> pass the cmap startoff/blockcount to this function?

I think that we should

> 
> As an aside: Changing count_fsb makes it harder for me to understand
> what's going on in this function.
> 
> Now, having converted either the range we arrived at via (1-3) (or with
> your patch, the original range) to written state, we set br_state and
> pass that back to iomap.  I think in case (3) it's possible that xfs
> incorrectly reports to iomap an overly large mapping that might not
> actually reflect the cow fork contents, because we only converted so
> much of the mapping state.
> 
>> We should trim cmap to count_fsb_orig also, right?
> 
> iomap doesn't care if the mapping it receives spans more space than just
> the range it asked for, but XFS shouldn't be exposing mappings that
> don't reflect the actual state of the cow fork.
> 
> I think there are several things wrong with this function:
> 
> A) xfs_bmapi_write can return a much larger unwritten mapping than what
>     the caller asked for.  We convert part of that range to written, but
>     return the entire written mapping to iomap even though that's
>     inaccurate.
> 
> B) The arguments to xfs_reflink_convert_cow_locked are wrong -- an
>     unwritten mapping could be *smaller* than the write range (or even
>     the hole range).  In this case, we convert too much file range to
>     written state because we then return a smaller mapping to iomap.
> 
> C) It doesn't handle delalloc mappings.  This I covered in the patch
>     that I already sent to the list.
> 
> D) Reassigning count_fsb to handle the hole means that if the second
>     cmap lookup attempt succeeds (due to racing with someone else) we
>     trim the mapping more than is strictly necessary.  The changing
>     meaning of count_fsb makes this harder to notice.
> 
> E) The tracepoint is kinda wrong because @length is mutated.  That makes
>     it harder to chase the data flows through this function because you
>     can't just grep on the pos/bytecount strings.

Yes, I was noticing this also.

> 
> F) We don't actually check that the br_state = XFS_EXT_NORM assignment
>     is accurate, i.e. that the cow fork contains a written mapping for
>     the range that we're interested in.
> 
> G) Somewhat inadequate documentation of why we need to xfs_trim_extent
>     so aggressively in this function.
> 
> H) Not sure why xfs_iomap_end_fsb is used here, the vfs already clamped
>     the write range to s_maxbytes.

Please note that I mentioned about this above.

> 
>> I don't think that it makes much of a difference, but it seems the proper
>> thing to do. Maybe the subsequent traces length values would be inconsistent
>> with other path to @found label if we don't trim.
> 
> With A-H fixed, all the atomic writes issues I was seeing went away.
> I'll run this through the atomic writes QA tests and send a fix series
> to the list.

ok, thanks!
