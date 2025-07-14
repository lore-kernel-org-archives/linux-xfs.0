Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9241DE2D8;
	Mon, 14 Jul 2025 07:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752479951; cv=fail; b=INLrsV0zJ9osPG5zvFLxyJDqpLdEFmFAQNlewZ79YmRJBP37q5hT/3vDahBMKA2IN0+E8TruJHTWWerkrNQM310XX+HdcrnshZA2EYm4uKnaMfqjjIMCQKD79fU5+8a5vA+pujGr61fznmoKJJGFB3EJYkgXDRXX3q+JTUuxa04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752479951; c=relaxed/simple;
	bh=gJ0SBcpeuI5rZDQE4YEZs/CxpZ2iufyUlr+wPZUl4Zo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RKxq9tZivSeGTp6qMq+XMhOccKrYDMHnzLHzU1kMwM+NEPdFSSzxOnFA0eictMIhvPM0InOmNf3260/udu9MalEzhVu8CgJvO0bu6oig3ydOw+RZTm1NeLlZ4JxAMMhwQXoTZxU5xKMLmf3y/IB+Fh5K9yqPaqlMt5ne8O8/y3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YGnRoCrm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kfElRTN/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YGnRoCrm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kfElRTN/"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56E5Z7YN005574;
	Mon, 14 Jul 2025 07:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UzsjL/RY9y0tE0BN42X1PUBSY8Niyi/RuHKbif2LYIU=; b=
	YGnRoCrm0oConB+K7GnD6vlc1bnZ871N7wL/+wWSlAS3dHey/vN5hgwKmIZ98qxh
	u2ZE/swrq9MBuiD/Gc9gekLWiOBilisoS67pN73kp3mC2EVqPN8yZa6lAWN0kF2n
	MNtJG5CKkLZmCbNGKCW3JpL95oF1KHPwZmRwpdKe3eEOfAsFW/sXBMje8caZCeJS
	HgIPKtZzUI3pp9hxSWUuhapKogHXf3xylXHbm1ReFoRMm1G+6nmsiTl6eKNjxEzP
	8nGtl82sziT2PQu4eRpjniltC0E2U9EG/3Mbg5HL9NBRUXI7OCZLqSAVCdLmXfbH
	E9DhkkSvMmmJ/SBLtndV2g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ujy4kkwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 07:59:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56E6q6vX024538;
	Mon, 14 Jul 2025 07:59:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue588ka8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 07:59:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XIoyhGy3maDd35/L6cI0E19jAcx2/HoVFY6Pfj6xxHqM9CIr3lQTds7GcmSe20Cqtwyvz6r1B58MqSgRbrot00t9/TeVXTiyUr1rX+dPq4AGc11K8iJc6JS6v35+d08Za119WBfayZCyawruKrIDlC7zMRF6oHnL0R3Lr/svzBM+MFv7bdZqXSTHmfBuBMQd5NZ6nfsT6u1QiXgNVRdsDjPGps7UBWSmhaSjwdHMqKQHHQt8t/EJvPwoFB3uNPdr8BUcamNo5/w8InPzHC8v6au0dUzx8Z/6CGZcRF4SvXGP2X4PhZYcZ81blBr9cQ+eQLhGKZ9GZMAhtTa2aY4+gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzsjL/RY9y0tE0BN42X1PUBSY8Niyi/RuHKbif2LYIU=;
 b=llpP1xTS7TDmwzRNGsZzQPVdAVmQfePgt81W1cC+F8C4JZkaqsh7Q2TUDRwTZvsSyOKdTM29cL/HE6beG6IpAfvQrSo9fvzLHo7TRGmwFDwDGwi3D/JNw+sboK6jJSvJl3i2wMGqVaWjyou7Xvh4p8bN8qtpmD8mdBAc1CMckNJ16KnnABhssUSxJ3Pi2I15ZtUWYJS8ddMEMxa7KfSUPIyIlw/8/lk4DtEKJsuJrdXCSNlU9F9nloQt45Vz03VqkJaB8C/sxLdzx/erd9n3Kb1d38hU1Aq60mX3ZixhBdr1RfGgIPRAyDDO5Jqbj9MU5oFC0cXY2VSmtv7JHkR1YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzsjL/RY9y0tE0BN42X1PUBSY8Niyi/RuHKbif2LYIU=;
 b=kfElRTN/wod6bx5/P88WqkGkA1KKl8QYDg12VhcENiLTXFGesXD4l/UGz7WX7Hiu160sDkwtZnCa+hEYUwKu7pTVD63qRATdwXsvW9Zm/sdyo77NI+FYhMokJw4C5CeF+Qs/Fk9bQthhNdPm9wNlR3hN5yDF6lcMRfvIuVcHx6U=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MN2PR10MB4398.namprd10.prod.outlook.com (2603:10b6:208:1dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Mon, 14 Jul
 2025 07:59:01 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 07:59:01 +0000
Message-ID: <9ba1a836-c4c9-4e1a-903d-42c8b88b03c4@oracle.com>
Date: Mon, 14 Jul 2025 08:58:59 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: replace min & max with clamp() in
 xfs_max_open_zones()
To: George Hu <integral@archlinux.org>, Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250712145741.41433-1-integral@archlinux.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250712145741.41433-1-integral@archlinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0159.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MN2PR10MB4398:EE_
X-MS-Office365-Filtering-Correlation-Id: 080139f9-b214-4432-a105-08ddc2ac4b27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUhQaFhpUmFhb29KRHVDNlA4T3ZZa2t3K3FxNnpaaG1HQWVJNmNKZGtKdkN0?=
 =?utf-8?B?UC9Yd2RrdG5IUUdnVU1qbkpaSUJJNXV4d3lNTHpOcFRMTVY1elIyZC9UMEN5?=
 =?utf-8?B?WnVROURlUVpJK1VOZEZOeXQ3Tld2OW9LNk11QzQvOWU4MTJ1Z0Q0SVZndGRI?=
 =?utf-8?B?UWx5YUd6Q0RUejg5OG1XUWVNN2UyeTdEa3ZMUkE5Uy9ZOXJBbVhOcHNDbCtT?=
 =?utf-8?B?UEMwMjhQcHp3clNXcmxWbzV6SU1PSlo4Tzk4WXAyZFRvb1NFSEFYZ0lXMXdD?=
 =?utf-8?B?dS9nQlJXMDdrdTk5S01uUzRXbDNHUnorK251bEpPTDBJUTRsYk41UUlWZVdl?=
 =?utf-8?B?dmQya2lvT3pHNndRd3dwUGFyekswTnZnMytwa0xVV2lDZTQ5T0R6MXFITUtS?=
 =?utf-8?B?WnZyaDBvQjJRKzBlWWplTVp4c3VXRzJjU3ZyemJxUFhUYk1UTkxMdnliUTRa?=
 =?utf-8?B?REkwYnBXWE8rWXVpTjJnRGRZMmdUQjNSa3ByY0t5Q3NaU0JvNVRYejZLUzdK?=
 =?utf-8?B?NGEvWmRpbWVySEFmQTl2eGxlOW5ILy8wdHk1R0ZmUkV2Nmx5MjM2SFV3cElu?=
 =?utf-8?B?d1BmdmhiYldyMXo5U2pUNkpFSTA0US9Fc0l1MDQvZ2djZ2NxdHhDTXBvRmta?=
 =?utf-8?B?elU2bkx5T01abVV4dUdTakVsbzJpOU1CYXlYSDdVSXlZR2piYUlSS1Z6K0pw?=
 =?utf-8?B?SnQ4YVczM1F4ajRNM0lpcEE4WjRtT25WMTJzVW9jOHMxMStBdFYzcEdHWkN3?=
 =?utf-8?B?Rys1Y3VMNG5MVW9lSWtkS0dFdmVvTlRQd3kxcVFlc0c0SWFnQWNaaFN1anA0?=
 =?utf-8?B?dCt0WjdZMTJ4RUZIazB0eDVQaDViL2lhUjZBVnR3ZiswN0xybmh5Qk5sOFVq?=
 =?utf-8?B?UGEyd1Y4WkRpSzNDZ0Exb0hYYTZrRGFJNldpNlBMK3pCb1Z3QlplOUVqdW9T?=
 =?utf-8?B?RGdUWk41NGZPYWlUcXoxWnhETVhmbEVxRWh5OXZ5VzhnSzZpTnQ2b2hFUG02?=
 =?utf-8?B?c05ZSHpmNWdZVUE0UXNWZFN6c1Q3VjFqcWtEZDZ3Skw5L2k3eTlvbldvcW8r?=
 =?utf-8?B?U0Z2aDBhSm9seVlvZTljN3A5NkVkQWFvdGxheUFkRDBXMGhkNWRSS2hOMnhU?=
 =?utf-8?B?SUNxZHpBQkcyZU0xbGhoN0VwZkh0Q0JabzRRSFFKTitxOGpyemlXNDUxQW83?=
 =?utf-8?B?T2ZONGpFQVgwZHhhY3MzZ2ZlbER4K25rWUxaNmZkZ0hKV3Z1U01UckRtWkF0?=
 =?utf-8?B?aEJDL3QwMXpNSElXUWE1cHZTdmlteGVwRVp5STNRZjNyK1BWeXVjeThLRldH?=
 =?utf-8?B?MGpoK2Y4c1NPNG9jcnFQZlhlQ21KanhWNWFFVUc3MEZ3RnJaVzZudlhRMGUx?=
 =?utf-8?B?NCthQ1NYZXFaQkg0V0YrdVhqZkxDTExuNzFJY3hvUjF3Y2ZCY1NPeURzUTND?=
 =?utf-8?B?ZVRkcEVHZmdMRmJLYWQ2RjkyWVRKdjhKTDQzMVZaWEhoc2ZlUVdHWXV6Wmlr?=
 =?utf-8?B?WWdpVGpuSDJIdXEwRVdMUDV4bUpaNjhpWThPMjZWTEtHUGk1ZHVzTldoUGNC?=
 =?utf-8?B?SHhWQ3ExcG1Sd1VYZUpvcHViMVM4bkN4Wm15VWZjT01YN2V4QktDNDhsVkp0?=
 =?utf-8?B?UXNCYzBidXIrK2tRR2YxLzlUMUM1WmFUYXRZVU9zZlJTWEQzQm9leVBQVmhB?=
 =?utf-8?B?dVhBYW9QY0xLMTdYZXloTjBkaVdPeW9HQk51N3Q3aFFUd0E0czdMVjhrd3dt?=
 =?utf-8?B?WHRXZTFIN0RSYkJXazc2dGJndnlubEgxd1laM3p1ajY5R2xyM2xkYVBnQWE4?=
 =?utf-8?B?MVpKWnZFTWZqQnhrejI1bHFzcE1FeTFTZGtwdG1FUkFxYmFyeG9RbHVwbHdQ?=
 =?utf-8?B?RmY3V2J1bU81VVd5UXV6Y0lFRjVEU1FqT0g2THpNbEVYakYrS3RpWUVwbWJ0?=
 =?utf-8?Q?c302uE6peHE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTJxdHRxNFhRUDVjZkhkS3hLQktoR2tBelYrbEZLaTUyRk5rUFVxMlM4K2Qx?=
 =?utf-8?B?R25JVjFjRW5FRTB3cG9vaXBjZEdWb0JnOG1IRVVxcldFK0JSUENZRnFyajM5?=
 =?utf-8?B?TWxWN3c3b2NEVjFVR0UrcTl4UWZMendlck5ySTFGRTBqK0ZPL2dkRXhUOEpr?=
 =?utf-8?B?REFQbkFpUVpXVnM1MXo5bHU0b3NHeXZucytJbkxNRlllYzBLWm9PTkJGbGFF?=
 =?utf-8?B?cHAxbjFKeXBlajcyVGVrdXUrNk9IcDZmWkhrYW8rMFV4em5YRFBQYmVyZVBz?=
 =?utf-8?B?dWxpS1dDTnM4RFhiNnoyZUcxakRSdzhVRFlqYUNPRkUzL1A1MStHMG80eHhy?=
 =?utf-8?B?NHArZUY3MEFNRGFMMWowWDkza1lLNXI4b0YvTWE2b0IyY2Z4RSt0SEV1QTVS?=
 =?utf-8?B?cXRmM2tFOGdtTnBtWkFIZkwvV05jUFlYZHI0V3cxN21ZK0JDSTk2cTJxdCtM?=
 =?utf-8?B?Nm93bkxpSmNoTHBNL096ei9pSGp1MzREUmRET3VzeG1wN2c2a3FiM2lTUTBo?=
 =?utf-8?B?V1JpUGdraXNsSldZeW50a0ZVYjVXTGZsQm1STGpJNmdSbXI3dm9sMDBReXdQ?=
 =?utf-8?B?Skc3bkFQMExTR2pRTldENkx5RFh2Y2xTUUZ0SWVHS0xrS0c1dUFzOFRDZUNH?=
 =?utf-8?B?ek9EYmRSanVnSDFwRUxHRG5pRWUvUXlTY29ZOEY2SWZoWXNOa2hhc2VHUnlh?=
 =?utf-8?B?cGI0Z0VxUk9iL20zVHJTNXFyWkEzby9ZVTNCamRIcTdjMWhOUUtCK0k5ZW5F?=
 =?utf-8?B?bE9kdnVITlM4amIrMWZROWZ6aW9EQmZyMjVvN2k5QVlDcTVzTGVyZFBXSDk1?=
 =?utf-8?B?eGtQWS9Ob3dYV2ZMZXZsRW5Uc3B2OFBJRms2NCtaSTZWTUlWN0RwcmZKZEZQ?=
 =?utf-8?B?VGFsaUlzSFdmZk15VHlubWhJc1RZbVNkM3F1UVYrMVZXeG9jd0xJV1h5MjhD?=
 =?utf-8?B?YTJpYnFwZ0NwNE5XRzBZak5UMTlzdHl6NXNKV1dEbGh2Sks3QUtBKzhVbmJ4?=
 =?utf-8?B?L2FRcHh3akg2WlZ6cGVJcnY4YzEyaFlNQkZvQWJkZUVVRXh6UHFwcnhUSUFZ?=
 =?utf-8?B?VmE3Z01SMGRYenhHemJpU1FQNVl1SnlOTk9YVnJZT3JwWnpmbjc0aTM4VUl5?=
 =?utf-8?B?NjZlYndPYlN1Y3NPVjIzTDU2RTF2a2FUcEt3ZVpVaWg5NEZTWjF0T3BFNEs3?=
 =?utf-8?B?UlYzcXArMnRVZ2JSUFZsdFJjQlFqT1FhNFZHaDlHSjlrYnowREUyTDRNWklT?=
 =?utf-8?B?QjZGRDBRaGRFUGRlOGlFNDAwSXpnTFlQbGYwYjdlMGJ2cHhuV1JyRDlLWnJM?=
 =?utf-8?B?ZldiZ0FOczZ4NGh6eFl2QWpKVU4zUTJkU2J6eUFwbmpWNFRnQStJc25JZmJT?=
 =?utf-8?B?YVJzK0F6MXJPWG5QTlRGMCtrZytKOWppTzJhSVVBUlpzZC93YTZ0WmRVUXBk?=
 =?utf-8?B?Y3lMc3MxRmFVYXhtVTdmSkI5NDhrMi9nSFJSNWpDRldaYTVCMFF0T2FzUnI5?=
 =?utf-8?B?V05hWHprVDZXNkNPVFZDR05QbGZhYnl0bm05QUg3L0xseEZkSzlIVkdOQTRk?=
 =?utf-8?B?ZXRNSk9VWEJ3azlVSm12RzQvZ0pZQnUwdHEyeStpeFFzVy9hdytpejVZN1dz?=
 =?utf-8?B?emVrOTlEeHdBblBDVUpTay95OGJGTVhSRC9pbTlYbzFqQkxXZDhMOTExRUJO?=
 =?utf-8?B?a0RWcVZGMHRvcjl4OTE4Nlh6VHB5WUJ4TUxyVUd0M3l5cS9mWjEySkRGbE9n?=
 =?utf-8?B?TTV4YS9Eekp0MCtzcjJzYnFrSVJBZFFTK0tkTGVtSWY5dHZWam5VT0tlNUVU?=
 =?utf-8?B?VGJMYTd1NWx5QlhYc3IrYy9HaytBaHZnU1ZlYnhsc2pyaTZzbUVMYUxEYVo1?=
 =?utf-8?B?QkJIVlZIbDZaUk8rUy91RlJZWGJTSkhIZmUzTzhkQnk3YUNhaGVKVU80VEUy?=
 =?utf-8?B?VGRJVkY5K25rS3RLQk5HbU9IS2pZc2ZhMGlHQWtCaGxmSklINW9wWGNWOXRT?=
 =?utf-8?B?bDhkQTNGcFBhUHk1djFSSXZnK1NQdEp4ZjcrcWpTV3BMM0NGckFpVUkwczFv?=
 =?utf-8?B?amtLaXM4SnFkUFBXa0NsVUFZVzFMVmMzMG5VWGFmU2locFI2L1kxNForVE5z?=
 =?utf-8?B?QXJHMzNHbWl0clp3MWVjcVNMQU9Wc3FOd1hMQk1yVHNhdDJuRlh0d3QvVG8w?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5+0wY5J5f06z0a+9fYca+KAgJ4xqskraqyBnWrhDGZWghQPsl802usVTqq2EsN7aaLjbg1J0I9V6uc8KLWSbYCq6Tfa20t4B1ddrXpkyEr8oIqqIJOHdd8d1d6DhSoTEUT7FY1zFP6XL6m/VBxRX94yBYGj3cPq/HRA1HWh+G7u5f0t2NDI/UEay1MEbE2INP2IBLsYunm0E591l+/nDlncS1j9u5MRBRkwoYCSMEGKfl+eXvOUydut6/NNMtiCwqFvaS+nVEEt5oQ0N+tXsEcl3uWZ4qd9piqGXkkpFKjPfXTX3Oefcovrucya8oYgHv5/fP31DYQcRq0t1nhOvxDHClUNaskxeqeHcIRN58RN5BVJYn48HMrmNmgokToQofo3fkCowXc9NlafBGybLU6vQ3GtKEl6MG3pQHYhakhUE/U8IKUe4QBkGEUmIvBP0kSjpes8/Y//0aLlykTAz4SWcrqhE8/WFCNvVvJj7XBSNdrhX/RKomTZbE8wfWCsVXwNBUhCO2SkQ+RCM0yrj4jWVMkWgY+ND7eOUfX/IbrPHCbXH0EPgNGBjnApv4PL1eBD8H9iy7ejJ1IGwnb3tJxzvUd2OEIaXSJ9sUbwoOL8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 080139f9-b214-4432-a105-08ddc2ac4b27
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 07:59:01.5139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdadP8h5eu9qGSdSmf7j3o3j9FDVGVd9MExZntFk9pYtIuKq9J1Z6PCrz5azaJl9fQBejlSjm9CPBQcKnYTJfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140046
X-Proofpoint-ORIG-GUID: HOmFn6jxey0kY1J6IygdXtfPfF7JeS4x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDA0NiBTYWx0ZWRfX94anSPAeBUK4 GOjQcZsQI4EJ7F7x0+ssyrCVQLAf1qd6S+OSypEWC8votak63PQ0zTsaXdH5431UOqF5DZZJe5n R2vbu9vQXn3+Zf+zUH7JdoJjZ0gRWmTHjYZKMO8i+ds+rWGrSIcwfnvcESYehwwOPgYBoEzxmPz
 1KDS8MVGhMS6UEz9PFIcof4vDVhHykCJAfDSGWCjp6JEmB2Xe/uQF4tWqpSe0HUKrR3A3bgeHVF yChRq0n7Qp8UVEDzC4sIFDxKmGm+dFmYKN9xr4Y6dIpqLYWiRXS5siPtsC2VXNFIw3hu7DDiSgm CDd29DP3GcISu30Xq55XJ41DDx4UMrwkOWzJazSUWYYV6SFfriWAPi50pevbVOFNfsG4JIvz1Pu
 Vx4Yds9huYqM2RtiaR6XDns7KWHZzAFc5HUj+QwJ9OPLM+1ey8yPCrCFDDIC+C1iRt2DGL7i
X-Authority-Analysis: v=2.4 cv=Xtr6OUF9 c=1 sm=1 tr=0 ts=6874b8c8 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=Br9LfDWDAAAA:8 a=yPCof4ZbAAAA:8 a=a1YPLmHImYYdKyXPsGIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: HOmFn6jxey0kY1J6IygdXtfPfF7JeS4x

On 12/07/2025 15:57, George Hu wrote:
> Refactor the xfs_max_open_zones() function by replacing the usage
> of min() and max() macro with clamp() to simplify the code and
> improve readability.
> 
> Signed-off-by: George Hu <integral@archlinux.org>

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   fs/xfs/xfs_zone_alloc.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 01315ed75502..58997afb1a14 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1133,9 +1133,7 @@ xfs_max_open_zones(
>   	/*
>   	 * Cap the max open limit to 1/4 of available space
>   	 */

Maybe you can keep this comment, but it was pretty much describing the 
code and not explaining the rationale.

> -	max_open = min(max_open, mp->m_sb.sb_rgcount / 4);
> -
> -	return max(XFS_MIN_OPEN_ZONES, max_open);
> +	return clamp(max_open, XFS_MIN_OPEN_ZONES, mp->m_sb.sb_rgcount / 4);
>   }
>   
>   /*

