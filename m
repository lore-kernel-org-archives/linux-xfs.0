Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555BD17BAA
	for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2024 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708614237; cv=fail; b=aK8Tmgo4P7gBz3U790wLfrV5r4I3LNuZte2yp0g474+2S0qtCMvAitJ6ZfvKHHPyBkuK/lmVo+g87+dgEJHiuN16MvW703YzgN7SShxRJGJoWRDlt0hT1IMie5lRzr2UWoXdNA96mTaWlAY+Rw2TctY1lC4tE+IuaC9qCi3UPEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708614237; c=relaxed/simple;
	bh=Dn2w0Jlz/SY0YboKFg3/lbmTH7aHlvnEwDWDsOYJhJM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qEtObx1UHQKdMFwyJXj9leyxjdQjhly9QViVE+iyzAhcx5aBIWxUhfgW9G1/j4fx2QkgWvLnk0BXF2mBD1J8JcmEISvZnO7/3x6XfHxDLCwW2EIA9m8VAXPe1NaalS7OV8FAZXLT5E4ZTEF0Bzw0FFBR0EP5QGM4B2fMnd0qV14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hl3ESWOM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lf9WOH15; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hl3ESWOM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lf9WOH15"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41MBRHPC018167;
	Thu, 22 Feb 2024 15:03:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=ia8UYuGxOVGy4banZfBBbgnBDlAoEuWeDEAlYk+2ZUc=;
 b=Hl3ESWOMtfHS1Rv8iD17p40/jlY7So6ehvuPrmps6sd8ykFEsP+jKQGMBVhIE443M0Yi
 G/avyW3Ey4thooke5fpL1zSb48XZqEkxYTa8wvVr0l/TTe1uotSkAEr2OJEZtHUcIjBF
 1PQWXC/o8dveVcRLGfY0Tm0B/ifZbgcM7c6p8pzCduLnDOLrGo1q+a2wrmCW35olSmOz
 7GQjGnoVKFp593VCmyxfQp05ED6h0EEsJeVqOEB6DQ7qVnfHGziqIvsuQMIKNlyNLEra
 CRqoAamLsG6ReqNaOE8ODGO8WA2XsgMv4JZnmhk2yhHt8KAmhQXc53FkJ6air6y7KhKC ow== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wakqccxcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Feb 2024 15:03:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41MEoqhu022190;
	Thu, 22 Feb 2024 15:03:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak8aya82-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Feb 2024 15:03:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTIlQksQuyk7oISzBpFZAXB/DawRPSBMNmVvGKvmLcG3VEQnasxRJbLBnJOmt6lRG208MYNBZZlWSJo4SAMBwAIY/Qa1i4kO0WQCdB+aN4VP3ozubj6W8SuMR/B93ly2SK2uF8w1L5wf91haaPMyMGDaznGrDLDuaZzazaWlct3wSLbrooFrI7RabXEKYx0xAQtonMFZNmhUcQpbo9pVhgUTGPRnfsbf6nXhJ+Dvi/RRGBTT1cQl6dJY4QTCrJeSsd4qJO4AY0rgHhvAC4FVn4QCfMgH+Qr6sg/rmuvXHH+jvGXJXXsrN3+ujQQAcw/P3mSuQW6CdIa4/AWfMf90NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ia8UYuGxOVGy4banZfBBbgnBDlAoEuWeDEAlYk+2ZUc=;
 b=F3Vav1kBkEzh6xaUHmj3+xM0azVilhSYzTeXZEHtYbnsAFxhVPMI1+TRZV4A2xI7PSzBfuzQ7HT8WTI8Aum/gUtz6VhhCUNZeKeeOr6g+oy48/NSCKuZb9Bi4DqvpI8qA9kS5XUx1MzKmhfJBqWVvXngfUTe5PVsT5lWWLj5VrGApsyzh6bllwPmlXXX+B6Bl4zPK1Nj4QgEJVlMiVB+kswMOKTRfs7AMjh3q4qo/y3n88l1E3TRkkF7M3juVtXP+5d4tyIcXEuATn6QOSyOa8OdfUYmcrVM/2qWTROKEIoJgJjVDnEEBtIOdH0+g53YuQnK6wowBIXM83k70zY2cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ia8UYuGxOVGy4banZfBBbgnBDlAoEuWeDEAlYk+2ZUc=;
 b=lf9WOH156jP/1Ih379SMyMAQGNRqsOEsc4g/hQXwhB72CdP0dnoL8+g9u2zDjJhsyayfC5YoGvq4dmgj7DUbvc6L0VW7fsPHv2DjSlesTrx+w2cad9iNn6Bv6b7dZa3Mh1BUjSqNplA579K0w6GPzUsv8Gx8ATXdPov5vOjWRs0=
Received: from SJ2PR10MB7757.namprd10.prod.outlook.com (2603:10b6:a03:57b::7)
 by SA2PR10MB4780.namprd10.prod.outlook.com (2603:10b6:806:118::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.22; Thu, 22 Feb
 2024 15:03:49 +0000
Received: from SJ2PR10MB7757.namprd10.prod.outlook.com
 ([fe80::5aac:311c:c580:ae6f]) by SJ2PR10MB7757.namprd10.prod.outlook.com
 ([fe80::5aac:311c:c580:ae6f%7]) with mapi id 15.20.7292.036; Thu, 22 Feb 2024
 15:03:48 +0000
Message-ID: <748747cc-0b82-4391-b785-6d24157a619a@oracle.com>
Date: Thu, 22 Feb 2024 09:03:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH] xfs: don't use current->journal_info
Content-Language: en-US
To: Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: Chandan Babu <chandan.babu@oracle.com>
References: <20240221224723.112913-1-david@fromorbit.com>
From: mark.tinguely@oracle.com
In-Reply-To: <20240221224723.112913-1-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0029.prod.exchangelabs.com (2603:10b6:a02:80::42)
 To SJ2PR10MB7757.namprd10.prod.outlook.com (2603:10b6:a03:57b::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR10MB7757:EE_|SA2PR10MB4780:EE_
X-MS-Office365-Filtering-Correlation-Id: 802a3087-fb83-4252-14c0-08dc33b77906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	AzulsazY6/j+WF8w0/5s9rw3rIZzXH08og1YuCp+6Ghm51YDl8nOVTBhA8amlea6Q+YwVtlm7NQJlI1V31u0EEjWzl6T9gQuwG07rjTMsf2ZilmqjCQklYaFyT0hPesXRpXjCq7RIHVx5g5e5JU1B3pSZNPXBVpuHUZUtPQgL6gV5NU3iT7vMJH1mk4599sw4yvAXlt93Ix4XZdtGYQ+WaqLurLvA1ILdNz5lhLuwCdUYtE4UDx3JTCaS9X/AVS2OVXMMv8pOOlfO/9+XbXPpm76PA9jjpWbGsYWHZzmppaO0r/IK+NmflE+9Xi9DVmF+v6J2h0l5OPn7ETFSZRDyQyThgsI8fmrrhyg7yieNlYFbuyOeLffDYhl7EFCeL0j5iMNvAkVW7bviBd7Tnlk5oI8WELNKReisp1svAmg5OIGq4opHy3SRDJfgEsAcYqK0hEbAkd54xWdkP1rcG51P7sqASHkEaoDvEgeyuNh/b+bkvl8Bk/oqn3RTGZ0DaVQOmnyJ1hqqupSfSmUQCZ/hw62Ukp+YyC+k1ckfXA7p2MCj0+84S6jh+aGhZf+2Mm0
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR10MB7757.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?em9sc0lPU1FrcWRYWFVkRXlRWU1rZkhsaXY5aitDUmpDY1BnSnE3a3RoRFN4?=
 =?utf-8?B?c1ZxUFQ3YlhFdk4vakZvL1o2d2NGa3p6UEorN2FteEdTaWZsKzVHa1FRdlZy?=
 =?utf-8?B?U0RjMU5HWThmc0N5SVF4blAyMFlYcW1JWUZYM2IzYVV4aFU1V0ZUSzNPZHVh?=
 =?utf-8?B?b2k5cHFJNVAySU1nSTlNTzUvWGpFYjhXQjBOcWcveHFJUVgrdDcwY1czdXpw?=
 =?utf-8?B?Tm5LWGZFcmhEMGVHNk94bDZHVlQ3cjdCai80WDZXL2xKTEtjbFVvYTc5aytZ?=
 =?utf-8?B?cjJVdkwwNHc1RW0vLysyQnBPT0lpckFTQURtdkUwRFdxSG5lMjVpWVZFbmFv?=
 =?utf-8?B?dWhVeTZqaHlTaDRTdTBoOUkvaXBpSmpUeVpuekczU0lEZld0YzJMeXdoakZy?=
 =?utf-8?B?N1lZdStqb1duZFpvV1lUVEhKUlU1cXZ2eU92eHZoU0J2bkF2TnF5ZEZ6N0o4?=
 =?utf-8?B?WUM0R2J6OWhtNHdoNHZTTzdJM2kzNlFVTW5TYjB1bkxXMkd2NnBhNlJKUDRm?=
 =?utf-8?B?WE8yMGE0M2d0Zkg5RzcyTS9tb2c2ZGN6ejlKMkdkYWhzejhrUHJQVnpTbFhJ?=
 =?utf-8?B?d2h3K21DMC90YXJjYVJDQVdqV3Q4V1JZUzk2cGoyRVV2eE5hL0xPMG1SNyty?=
 =?utf-8?B?YkJqR0V0UlBxRjRTclNHWnV4NGcydFVGaVpDUHMxbUdCZkhvQXBQNWFncmJC?=
 =?utf-8?B?aU1MNWhhcUpsTGRQVkNhK3lEYUdNYWFFdk5pWitTWGdjTFEwVXFuRVliK0lv?=
 =?utf-8?B?YlQwa1dTTEc3SWVUY0JRL3U3ekVKckw0NjR2QVhXZnpDL2xhNC9sQUN1eVRR?=
 =?utf-8?B?dU1DdXBBODdha1ZSRkI2THRISWl5QjdMNG5YdHE1Tkw4ZUswUGYvVVFBaVpP?=
 =?utf-8?B?SktkQ2NMRzVteVV3K2JIQ2FYU2FXYS8xWFRaSDVqWHF0STdiNHp2U2ZFei94?=
 =?utf-8?B?OXRlWHFHaC9RZnZVNmNMRnQwL3hTRS9uei9iejg1Q08zKzF2VkhYdjV6cEln?=
 =?utf-8?B?RlJJV1Z0aEVqYTA2c2JsTHlQVGhyL21xRElXRVBTSy9jUXlqSFVmc3dsTnBD?=
 =?utf-8?B?T0ZKQVZEUmdidmhnM2N2ZDN5UzhFWnlQOW1zbjdQM3Q2Rjc5VHVVVG9nOUhS?=
 =?utf-8?B?ZFE0MVpzNzczQ1JobkZMUkZVUXlyT3dkeTVVZ0hVWGpPU0ZiS2JVSkNzM2pI?=
 =?utf-8?B?Ulk4akVPTHJ2SyswLzFXcXJVU1poUGl0RlkwMzAwbGNWU0Z0a0JXMTRLb2NT?=
 =?utf-8?B?TTJOM09CTWlnQ0IwVzdTQnM3NnFPaXAxODB6KzdCOHBBa0F0cDNTaS90NnRG?=
 =?utf-8?B?aUFMOEZCQnUvZVNMREhGV0FNRk1VbjhzcW5KV3VBTDM0Tjh3S0ZkNlI4VnRU?=
 =?utf-8?B?Q1pPRGE3TlNNem9HWm9EM1diOThTcnAzQ0w4eGtpSng3US8wWUpNSmY0eXlO?=
 =?utf-8?B?NXRFSCttMFBqb2pDcXlVVzl1TXliUG16cCs5NGwxM3BVTC9tWlRuR2NBS0tr?=
 =?utf-8?B?VWhRWXJXcEJmRDlVQmV5NlJUUjdKMjRiWjVZZTJQVEZvcmhQc2d3MVdnZlkx?=
 =?utf-8?B?QzZWYm9ESlFSeXg1TGF6TGtrSllXOFFsZ1Q2QU45SHJiTVkzWW5aRExQM2VM?=
 =?utf-8?B?dCt3MGJLYnVUOEtQWHFpSXRLZmZIUUF2c0l3NlAwOFBldlk0NjdxMm9nTk1R?=
 =?utf-8?B?aFY4UWdhZ1F5cGpHOC9lVmRGbU9wbjc3dkNJRVFnejg4cVZWTzgvazZZbTA3?=
 =?utf-8?B?d29Da0kzUlEwb2FxQ2p2dno1UDFJYS94REw2d3FVbEVoQWdUWVF4Q1JmQ0kw?=
 =?utf-8?B?THl2bm9qVjF6Y1dwME9xRjNvTUpiUjltNDcvT28zTy9JWXBURWZ5OWQ5M3ZM?=
 =?utf-8?B?U3lxZ1llTk5qZ0tsNU5iMkFoSkFobkgvRS8yMExEZThNdWhqUjl4RGFuZlp0?=
 =?utf-8?B?R3E2SWJGYTF6d0JwcmVmRDhybGVXZ3o1U09uY3FrNU1BVnRLWGFXTXVLSlBT?=
 =?utf-8?B?WlBXaXArMWdDTzFWd1k2aDlaaFNLR2Q4eE9vTUx0aVc0Qm9wczJWaXlZbUNG?=
 =?utf-8?B?ZEZKTk9DK1BQS1YwcHJkOFYzQkdCUVA1WXY0a01Jck0ydmFqUU9qak5rTHU2?=
 =?utf-8?Q?vnhWoScJwCW2h7rue6wOh0MQo?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	1fAJCKpIV1FJmtKFaTGrlRtENn3WPf2nVy4kTwPTRnLCtA85ndL2WYYIvkLASpqKi7cGtaiZkH2jR2iwNQiPln62mR5k58SEmrvHS2DzT+wYzRxZJOTAnz+2GTTO8ID9y5EYBL78mD/GrnN6v+KjGaV6lj7z2ULheF9NKIA/047a/BOK9KV5nTkyheKKXQhymzU38fIYBtkylXL625flImrx5DXE2wa3AydutyGdKY33ROT/92vOErOVr6mqxHHDa93sd5ZpTYGEZWEsIhbZnOqhCrwvxhU1lz0FeexPnBQILH9gCJhyW3cDraovYe8SggKKOmXOPFqaMi4l1NZTYtfnwRiDG3Bne2Q0KAJjc20xvA72UgB5gRP4pJ95vUi1IeI3lJ+M5sYbKnH2znR543h4MxD7kdFucXOaVrwi0aGTnNMNYUVQOagBxJRG6wSsuBeY3fixHFUEfqZa7Po8r9PvVSqoM8c5u0vTMiZrl7J1ye2DOZ8gVTlwExA87OHfKI6e0p12Wi1Fknce52qiGAJ40uDbI5M9ifnrhWwc9FSgHB0Gz/GsbWtR5VYTg3q7GzqPUoKsMuHUMLjPM9PhilxfAocblGqMHv+Xqkd4dHA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802a3087-fb83-4252-14c0-08dc33b77906
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR10MB7757.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2024 15:03:48.3570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ROGoVyDVYem8fKB3hVpc//9YcDtItCNLmxDmbY5v52S4fbT1gqDzj6bi3mnybHl30daPubwH5LbgsejFSe7c1uAZrRtI6CB+ad00BSdeqXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_11,2024-02-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402220120
X-Proofpoint-GUID: J17atKcdv9Nwji5ebgrUhrX6G3qfn04o
X-Proofpoint-ORIG-GUID: J17atKcdv9Nwji5ebgrUhrX6G3qfn04o


On 2/21/24 4:47 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> syzbot reported an ext4 panic during a page fault where found a
> journal handle when it didn't expect to find one. The structure
> it tripped over had a value of 'TRAN' in the first entry in the
> structure, and that indicates it tripped over a struct xfs_trans
> instead of a jbd2 handle.
>
> The reason for this is that the page fault was taken during a
> copy-out to a user buffer from an xfs bulkstat operation. XFS uses
> an "empty" transaction context for bulkstat to do automated metadata
> buffer cleanup, and so the transaction context is valid across the
> copyout of the bulkstat info into the user buffer.
>
> We are using empty transaction contexts like this in XFS in more
> places to reduce the risk of failing to release objects we reference
> during the operation, especially during error handling. Hence we
> really need to ensure that we can take page faults from these
> contexts without leaving landmines for the code processing the page
> fault to trip over.
>
> We really only use current->journal_info for a single warning check
> in xfs_vm_writepages() to ensure we aren't doing writeback from a
> transaction context. Writeback might need to do allocation, so it
> can need to run transactions itself. Hence it's a debug check to
> warn us that we've done something silly, and largely it is not all
> that useful.
>
> So let's just remove all the use of current->journal_info in XFS and
> get rid of all the potential issues from nested contexts where
> current->journal_info might get misused by another filesytsem
> context.
>
> Reported-by: syzbot+cdee56dbcdf0096ef605@syzkaller.appspotmail.com
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---


This will also address a problem seen by asyzkaller generated test where 
  a multithreaded test consisting of XFS_IOC_BULKSTAT and buffered write 
can unnecessarily trigger the warning in xfs_vm_writepages(). I was 
thinking of conditionally removing the I_DONTCACHE in 
xfs_bulkstat_one_int()  but cannot recreate the problem without cheating 
(forcing the race to happen abnormally).

Reviewed-by: Mark Tinguely <mark.tinguely@oracle,com>


