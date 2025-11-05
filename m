Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9CC13D891
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 11:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762342159; cv=fail; b=Rgu1N1uVIzBX2Zn/BJqVtVZR5cxv0TuTEY+EZBtnj21tKZf+ImeBbtDtsG0z30ndCUXVtWv315ul5VONVbiMJNKvtziR8AqMExo3L3DM8dkv9vglue9cdmgmXk/+1fJzM6uO5aalmrZk629/UYL9nUrlsZfk2Uc2cAHVXIplbyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762342159; c=relaxed/simple;
	bh=AKFLtail9QPIvKpPhBn+8gNt6O3G4JcfZiovBsLfoiY=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BL80mokwGlh2mY0EFu8nZFPGa50HKXWVq4gahvJaAjXuaL5/8hV4OlBOQ/tlPMxC75qcPaU2mtr3HECWbPYiNOIuJ2xsDw4M4KIei8nUsMGN7CYnLUcKpvMBC873MOl/kXL5YF7bG8HwSnoc8u2i/k8AL3wGD3o9MTeCEDY4ZLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gG6cnpmb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YChz6Oyv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gG6cnpmb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YChz6Oyv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A58ivsx028901;
	Wed, 5 Nov 2025 11:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gZVt+w5ArrsVL7iaCD+kvQXsMfqTV6yJoI+ddNFsyNo=; b=
	gG6cnpmbqJqVQ4T922p2MgszQxaYxg/bj88JhioaCK3TWC2tc8zW7T/2+1dhuh3I
	VPSwZxl79HnMBVirTcwjwDCgTlEybQMbfJFijKBHcLF5bpY1DKye+6AelXst5i6b
	j3HdD0e1GWj4eG44ipkoVYEt4SaF6pfauC4jWFL/EPpk2+GbsehlJJIr5qMfF+1y
	lMS370kxbzMGJxQaxuc2N5a7EugcJcuq+VTgMXFnmS4aMT6kaXiLlvz2QblcGIuD
	oSWdG4wBZBeD/6eBkKBCUsrbrqLJr41Y3ghupn1BWsHpgml6DsLxQ07BVy4/DouZ
	n7bBYnHUWhXCzEQT6PuZvA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a83b70b96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 11:29:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5B3rsw003652;
	Wed, 5 Nov 2025 11:29:12 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nedv3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 11:29:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tr4JIrEjcaSUTGClatbyTvaL0xWQ7d1227uC1OnhXRxBGvY+00ZWIXdK2PIe8JkjpI2zBeIm3bEnetqhO7zKayyHUopagX+5OpwfFYNZnmONRkPTicypOCKhzjSxasISv+tegzwVY7qUh02nZOqzPdwcjF4zepnqBghzatBa6zP9vf25DWqAyLOiLfq+1xXWi5dtAs8yKv8Y6Ezhybgcs78ijxh+tKwRvWoEvfxYc7Woo14OQd9L21vS4a62Wcp80OGf5YGH1Okq07ct+JQ3tmv+9sU8MMnFQpA1EuZanUktXq6XjQqw4wNYwnT7Xspzb8+UUYosHaLrcGC4qIMUIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZVt+w5ArrsVL7iaCD+kvQXsMfqTV6yJoI+ddNFsyNo=;
 b=vBxDEghVWz5oncBo33TQwvGOP8Fvd8slyroaBs+cjaxtX774dH9M5GGfclDbithzc9nRtiHrQBXzef2M8AkTmb1MbZgfl6hAaJCFqYqHoldaZc1IDeoZ6+XzB3GJ+Er4tWe1/E/J/j7Ze6jJ9BxYQYXoHavBRhlXSGbyqMbT+M2+KmthTDinx7rDSVE8b8AA9gOcGEJ1xoMeJoSW9511TA8sGqHyWzWG2L5/K6lGu8E/8E6szQFKULNPbllGKnjjPgxJ9g52nAwXib5VHsFrfm+2FPlHgTXjCZa6+oDgW+1jmA4TRVfkYWrBl1FDL5eTnKhgvN3c0PFM+rMeCx8Syg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZVt+w5ArrsVL7iaCD+kvQXsMfqTV6yJoI+ddNFsyNo=;
 b=YChz6Oyvzubhg3avco9xVTdP5V1G1g4pDl+J3mJuOOYgWxITbh5OF1ol4Y71kZPBBQY2eKNdqZNEQX1Rs3TC4Rk6RxXk7ynyVjoZfSNLZBh6PBrGZN45BiZ5NzY5O2ltR2goRQGi2moP1ZNJ7QBzZ3IJqNl2GEri0DvgI3QrYgU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA1PR10MB5781.namprd10.prod.outlook.com (2603:10b6:806:23e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 11:29:09 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 11:29:09 +0000
Message-ID: <728dcb65-764f-4b25-92ca-9d55d4dc4ab7@oracle.com>
Date: Wed, 5 Nov 2025 11:29:05 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang
From: John Garry <john.g.garry@oracle.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0289.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA1PR10MB5781:EE_
X-MS-Office365-Filtering-Correlation-Id: 532b4c56-9b7f-4cf3-76d2-08de1c5e8971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3B2dFJPU0VBaXVxc2VDakMvRFZaQlFBYTVNZlIxNkNFOWQ4NHFqRU1HQUFF?=
 =?utf-8?B?RlFDQ0JrazQ4Rk1lczJNYXZnWElLYzBqNi82TkdNVXBteGR2S1ZzT0JSUTlT?=
 =?utf-8?B?TW9HRnJESUs3VWF5VnBSOXZWVVNKYm9kbXVxQitiQmRnaUN4eUhDQ0NJdk9o?=
 =?utf-8?B?d3BwQm9hK1NtYWM4VTBjMjRITlA4cEswZ0hYamNLWXg2cmNyMm9jVVQ2aWVH?=
 =?utf-8?B?VjJtRi9TcytpZDJRNWgveTl1aHZDdEQzY0JSdVluVlhYV3Q0ZDVDTVg4S2wz?=
 =?utf-8?B?bXZXNVgvUXhOczV0eDBrU0t1UmZ3eXFKT3lYSmdKWkd2anM3TnF3VXRHV3kw?=
 =?utf-8?B?QUxaSEZBUm4zcHVYWkZ1UTBUMmJCSWVWMllGL3h3UytscngzT0pxazBvbDQx?=
 =?utf-8?B?dkhRVVdCQTI2Qy92Q29JNW1GU05aV0drR29zVGxsZ2RPd29JU2FMWDBSZjRM?=
 =?utf-8?B?dXhVZHliZnVQaC91TGpCNUJzR2RoSlJrTnpOYWVmdE53dTY4dENMcWxRL2RK?=
 =?utf-8?B?ZjFscFdMR3k0STlOUHZ3WHFhSGFWSExJa0p3NGNFSlVVU1huV1ZJQ0dNNlRR?=
 =?utf-8?B?OFlmbXBKUzdCMkkzTDlEbzZCL1R1aG5DdzRZWFJTNk1xcWhpc3FFZzJCTHc4?=
 =?utf-8?B?dHVNY0gydFVNLy9ub1ltaERnSVBYMlNaL2NLRmFzM05lYTY1RERWMnMxbitU?=
 =?utf-8?B?ZUFMZmFXVzRNQm9YRVNHNnQ1YisyZkdITUJyTHhySE0yY2hFaEdCT1V4cHFp?=
 =?utf-8?B?QVdZUjhZUGNZUVZnNTRmaERaSG8yRUNpZSsvZ2N4Mkhzc1NhaTIxMnJvMFVh?=
 =?utf-8?B?SmxNR2V6aWtRbEJNMUFuMjBmOWFVSXdqL3hTa3NVeXpNU1AyRW5FNnZEekZq?=
 =?utf-8?B?ckowUk00S1hBcGJoalR6azFLVmlML0lCRVVTWlZaVDB0Y0lVOHNNUTdicE5s?=
 =?utf-8?B?b0IvdWl2NmtWOVhmbWY5Qm1ZWWJabGJFYW5OYURtY20zdk1GOVVsemR2ZkZE?=
 =?utf-8?B?Q3dpZzhGRUc1NkRxMVBtTWN4c2V1VGJ2M0dUa3RXTjBjOTFnbVZhNGFuRVZQ?=
 =?utf-8?B?STNSUWl5TGg3NUhoUDYweUpIVFh1TUlFQVhZWGF4dm9QWTk4R1V0V1dEQXlZ?=
 =?utf-8?B?cWRuOTVQaTVzSjBPZkg2QzJ6TkZZdk55cTNqMDI5Um9ZVXo0d08xKy8ySGxo?=
 =?utf-8?B?SHIva2RsTUVDUVBKSVV1elhudmRBUVJoVk5zVlZCaXlGbXh3aFJqNzRZdGtI?=
 =?utf-8?B?YzhjREFibGZaKy9yMGhIUnNOTWxHWFNlclZ6S2szeEZxNkxoYXBaSkYrb1pP?=
 =?utf-8?B?cWt5dlRpRUhVNmNOL2NFcm80NVduMDh3MGo5d2hWdW1TZ0sxRWpSL3pEWnZs?=
 =?utf-8?B?NmUwdGVaQjR0NUZyVkZIdklTUUgwUmhlQ3N1VHhyYkRBaHR6bG1nZ09ka1FL?=
 =?utf-8?B?RTRVR2FZM29tZnArT01LeWk1MVBMcmdrRHVHdkJYOWNCUURpUmp4SWhSVXdW?=
 =?utf-8?B?U0JhUWN2MDdOaEpUa0o3QzdkZVJSMWpNNGFwdmtvMzdkV29GSEhaV3NpbGtS?=
 =?utf-8?B?T3IzOFhrT2tnTW9WYlBJMHE5aWNDMkFiQnZYQ01CNWc3OXdzMVNmcTBZbk9W?=
 =?utf-8?B?NEl5eUI3aExmam52a0psMkdpS3FlWTBNNW5VRDdvaUM2eFRzM3IzdHlGcHd0?=
 =?utf-8?B?YjdWWmxBcTV2Wi9Qby9LMXJpcm9ROVd4YldtQXBnMjF4aldMOC9ZMTdFRWkr?=
 =?utf-8?B?b2pFSm1zQ1MrYnVpWmQxMXpSekNiN1pxZXF1ODZtNDJJYVFmWW1GV0JDTTlE?=
 =?utf-8?B?TWduS0tmSzU0MUgyTjM2b0s0ZjdGVUdYS0dOUklzNERMTUY3cGc4MUswY0J1?=
 =?utf-8?B?TDE5N2lEbE8vQ1p0aWZQdW1tTm9TVm0rSEVMWHpMbS93TER0SExiYUR5NkhL?=
 =?utf-8?Q?/BlPpMbQJEjqFMOKbIgR9E35AeuQIX5O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTF0Y0Z0VnU3R1ZwVkZRaVhSOWJYK1JJMHVXbENOTXJmK0t5R29QV0w5bDJk?=
 =?utf-8?B?K1JoWldZaVlhMk1TdGx6RDlTZVcrNGtsRVUwNkIyb2d3U3JHeDNTUURkTW5F?=
 =?utf-8?B?UG5xQ0QySkNUUWpsRk0vcnpUakNoY1JWZDVUMHc4bUE0UXBQZk56UTVWUFZR?=
 =?utf-8?B?dUQwT2hYYzlsWnJsVzFQaG5LbnVnQTU5cU84dFJRUllNQys0QU5oU0dMaUFx?=
 =?utf-8?B?QlFhbDFUS1NaeVh2S3V4NE5ScTFOdm93bC80eUFLZm1wNDlwdWwyV0E5bEx3?=
 =?utf-8?B?NlZoZzVlQlFkdk9yMGU4R3M1ZitoaW5GeVhkYzBqOGF1eEpkTkxpcVcwS0x0?=
 =?utf-8?B?aDFEMVZWbmd0b2RDMGNXZ1h1NHl6UEpCdVptUUUyeWRzQWRwTHZDd3pCRGpW?=
 =?utf-8?B?MTcvdjg3d2ZURGFIUmE3QmE3am1lVU5xUS8va1BGV25ZTzdzY2xWSW5KUXRu?=
 =?utf-8?B?V0VJSU1YTjRodEw1QklkNytzeE9VUThuRTd0UXlSVFVTSW0vSmprVzNGaW9I?=
 =?utf-8?B?NU1KdWRrcGo2eGI5aU4xZ3kzejI5RGs3N29lQUFzc3VKMEhQUUtBMUpyM3l0?=
 =?utf-8?B?UFBwZEJZZGVYS2dhSlJ6d0J4ZFpFOGFjNUFFV1JKYTdOTFJGRlRqR0cwZmJm?=
 =?utf-8?B?ditQTXR4NkFXNGZwbVkrUWE1bnZ1d1N1MmNJaUtEVTlQUzV5MSt5b1k5Y3Ju?=
 =?utf-8?B?QVliNGIvNTZKdVh5blRyL0l1ZU1hQzF4YWJMOXorR25HbFNyeGJLdVQrMjdW?=
 =?utf-8?B?clQzS1BIa1BSRldJTlJsWXBVSkVCSUFINVB3Wmd5emQ5UW41bVUxMkgwb2Jo?=
 =?utf-8?B?K1AxMU5pTmZWMEhNRnZsK1BhSXdTblBWOTJJQnR1RHdBODZWTitvREw1NXBq?=
 =?utf-8?B?eHRFV1BOR3pSWm51Tm1QZkxpUzFjdmI4M2M1ZjkxeXQwMjlyYnFZWWVvSDd3?=
 =?utf-8?B?ZTRVQTNZTXEwUHUxaWtFRzdsY2xIbEhEVSs5WHhvdDVENTFBUmMwR1RmRjE1?=
 =?utf-8?B?U2kxaEN3M2pTVlZ0TlRSWlZxSzF0czlQKzFyUHppQ2tpbXFsR0NKdks1UHd5?=
 =?utf-8?B?VXE3dXRvemUvdlpYRDYxRk55UUY0MlFaazBoU3czb1dYNFBjdzFpWkFVRGlz?=
 =?utf-8?B?VXREOUVYeENiRGRwYlR1Y1lsVEFxUVVTelFEeUZYdXdTdUFwQUxlWFd1M04r?=
 =?utf-8?B?b0Y0SkRtLzBzQWZrSnhPelJDd0xxdGZ4MW9NeUMvQ3RBNGtaVHh5TkQ3YXpt?=
 =?utf-8?B?SG45bW1OUndnSzFVL3hMMDNDZ2lOb1l5MFA3cHMwQ21ESjhsUkRoSnNYTndH?=
 =?utf-8?B?ZjFkdWJrSnJNRVNydUZaUy8vbmhLa0dJdDVENVZXdjdoM3g5QUtaY3NpaGdN?=
 =?utf-8?B?UGgydXRhTTMxUmUwQStDOGVnYWlSZ2FybjQxZFVZNUJmeVB6LzNMb3M5UGxN?=
 =?utf-8?B?VS9TV3dtelo3aFZpZlZYZ2NRY2J4NEpMcTEvQUJLMVVPU0tudDNqbGJhblA3?=
 =?utf-8?B?UXdYMGZaOFd5U3pvTzJlaFljdkxxZGxqOEE2UUdUK2RuUk5mVThHUUQ4QlpQ?=
 =?utf-8?B?YnR1QXdvc0hCQTFQMU8xaDgrQ2xmM0FGUjFwOUJsbFhrbUNoTXF1TndPSDln?=
 =?utf-8?B?KzBFVEJ6YkxrOEVmRXZyUEZBVXFiTy9pM2U5aWVUSncrQ3FkV2hUVUJuYUN0?=
 =?utf-8?B?c0ExM3BwQnZnbU4rZ1NsdkdyWHFFNUNpNGtNMWFjeXcyUzdscHJpckloSWR2?=
 =?utf-8?B?eUZLdmEvNzBjWllrNXR6YlQrMXo5QWxrVUo1TkdQZWVtcS8rRlVISjQzQ2hl?=
 =?utf-8?B?Vy9nUkR4OGxDTzZDUTZ6Ykk5aTZrM09yQ0hVVGtiUnprbmpVTGh5TmxrYXlp?=
 =?utf-8?B?NUpwQ25PSFBONVN6SXNqWitXWkdNRDhPdGhtbW8rUDA3U01VUEhWZ25YQU9E?=
 =?utf-8?B?ZEo4blg5QVBzUnk1blBOMm5vN05HMG5sSVJvUlBlL0RLWnB0c2xOQzc5Zml4?=
 =?utf-8?B?aDRsdWpLblZvVDVvVHBNZUJwWC9GOE5ZYW9xMUFXbHQ0UzVlb1RDQjFjTnlR?=
 =?utf-8?B?THRidDFkcWJRa2Mwd05sU09nQzZUZ0dlbzhZTThwYUJVNVI4V0JCc3FOa2Va?=
 =?utf-8?B?NGpIVzdYTXZVSW9LbWRSNEhSNHE5QytPRXBwYnN2Mi9LbFQ1YytYdWdMN0sx?=
 =?utf-8?B?a0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u00MU0YVfuw3SPO4zxtCh/XVWjuNomrfxhn8rsov1BQhMF17R/vDRiRaFDD3P2hNIk7ATE4I0k8vdBw3NJcYEYGAltio+Fw+ihqMS2zgxw0QfumoqZs9Go4QgCE4J5BVlxxgBtA8XRQ8ZZ/SHtmZRLaybR7RbIcRkm1mybgE7pwFpJb80JB7qkCwMXF9AnQOz6CIpONbMVEH5Odl2O8uKAlHn4+7O36pf42Az1a1g4nK7O61tRmnjl7ntYfjzD/cTPbmm8LD+hZmLAqNIqfrJXFkhiSQBIMYKaThmFLqfBN/TaYRBb7tleNsOYucyU2rKVk9darB3rldSGE3hEF7x9//qRT3+CJLSvHyBrTKQTh/PvsiG+wGZpVYXnglI0MIN/sZV97u30ug3xJWCGD+PW4OFl5sidAujH+MNKTjWRDFRACfvgZQeDxLBTYLqIsB+5kO46A98oQh9Tchv6Y0/ZcHm0ugzjkcP2vqYbrfIcypxmXtICeZHFyLsKtwh6XlDWvXf2xPg7s6gzt2/FEBPgQ9WYRa6Qvc89BKrrlRh+12a0gq5FCgNqnKsvc4wLhppZA8yKe7TiBB9men2FvtzcjJ/a+KgFqaBoMG0Xj7i6g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 532b4c56-9b7f-4cf3-76d2-08de1c5e8971
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 11:29:09.3519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 983Xz8KpD8Vx65sJ/aABjIp8aJPau6xEr3uVxLQkuShmPgnxamBOCf2Ktm8XL6+BLAi72H4ZCMLol7dzEX0+Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_04,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050086
X-Proofpoint-GUID: 2PFdT4xmP2Dhaf_L_MAzH2AGM0qbv88_
X-Authority-Analysis: v=2.4 cv=Q5LfIo2a c=1 sm=1 tr=0 ts=690b3509 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u9kbVW1HyeK8m07tLXsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13657
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDA2MyBTYWx0ZWRfX5LjXB49VQcCg
 IAbCVyX27RQp4d9y2pa5Y3RWc2/rxgLrOT3MyPkb7kFY+A7fecTiGfAz8xQwdDkW5xrMrqH5j9y
 DQhaxg/nqs0oQ8BA8+YPzBDFd7uUW2MNvhgeoI76kDK2VCNSE5ta+o0FvOSSIlWCbemz62+iV0r
 EWL10AM5ge9vM0y9HY3f1difcjB80n7J9hTesd6xWEPsgHtmyzlCS0l/E5gCMX0eZ5kvGA2uTTn
 QSGNFJxYVRLzNTydcjX1M0Dl2DzeV4CNI5UMvocgI9vKXeBM+4Fjk+vxv8XYaO+16CFHvJkMEXn
 NLdOm7Q0AEICCyKU8r3s6caW5pmNMm6poQYOA0KBdQ4RU2oUGW5topcyK7LqOVnIK7y1lOwni7a
 gu1ERDtf3MCd3dlt781Dml+bH25QYLdUFRtGNEJ0iR8RW9Kirok=
X-Proofpoint-ORIG-GUID: 2PFdT4xmP2Dhaf_L_MAzH2AGM0qbv88_

On 05/11/2025 10:39, John Garry wrote:
> 
> +fio: failed initializing LFSR
>      +fio: failed initializing LFSR
>      +fio: failed initializing LFSR
>      +fio: failed initializing LFSR
>      +verify: bad magic header 0, wanted acca at file /home/ubuntu/mnt/ 
> scratch/test-file offset 0, length 1048576 (requested block: offset=0, 
> length=1048576)
>      +verify: bad magic header e3d6, wanted acca at file /home/ubuntu/ 
> mnt/scratch/test-file offset 8388608, length 1048576 (requested block: 
> offset=8388608, length=1048576)
> 
> I need to check that fio complaint.

This issue goes away when I stop using lfsr, i.e. the test passes.

The problem is that lfsr init in fio does not have enough "blocks", and 
this comes from how the fio bs is same as the increment aw_io_inc, both 
1M in my case. I think that aw_io_inc needs to be much lager than bs.

BTW, I think that the random number gen fio param is only relevant in 
fio write mode. It seems to be even set in 774 for verify read.

Thanks,
John
