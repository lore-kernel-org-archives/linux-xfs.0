Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AA12E8E16
	for <linux-xfs@vger.kernel.org>; Wed,  9 Jul 2025 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752076708; cv=fail; b=PPT9NLvN0iSTjs/3Al9mOTGmn1VQyk/qWTDVSXOLzc9H5NzPbbeGLeu4heK3xF7CPHt/Y+TDA5g0ZRjEitCq4xMbHqBxgjwDixJnwvSUouIhpVDErSYSOmHhTIMl3joB/Giiidh+W/JaT7K1q/ftjkMvIiwhFKClpKgXz6zwKHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752076708; c=relaxed/simple;
	bh=QfbiN9bpHPbOHbhcjjp3/k7SRXvMPTjh5Ca/bSMNixo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u06QmShfyj+gcup1s7ICiZG7/OTQgoQCPlyHYfqLOmUJkMVZdW9a6ZlOo8e12O+ilrmAOxo53cvpjlZrRTWLMvLe44F2DWYzY0vUBHx9TgC/RwqQ7L5cy0uchaO2HCPKCXvJZGzVn199dVxUB21V8/C9Bh2/RDuIAcXlxdjS//U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lgI6MBQo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yfI3GRLK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lgI6MBQo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yfI3GRLK"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 569Fqbch011226;
	Wed, 9 Jul 2025 15:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MSSIkd0GBYjGRnup62IhNEZs6ONyOOYJWsY4ixlz1Mo=; b=
	lgI6MBQoNAVxX2vgibXgrOlE9glhwPe7nIW2aylJIWFJAj9aUJs/3PgZaYjJiMOZ
	znVTaBIAiMD7AbTtqCXrwintzYXgtgrUYlnAgxWWx1sauHKFS7AEULtE2GjWhBCz
	zQU1EtgVpIQLB+U6DvDf5tzE1yOgMsD8qxJOjoMc2Dp+ycneb8/XNG+eicrJ7B6d
	U8m4+iQYeg1YlxFqD6kIocgbqKs7YLPJjMF3HwB3bFnlt0lV5u/WtIUWBgXTQq5c
	s0CRKxvag5vzgPpeSiH8zg0IlInmOuMxaGv6d4VG7P/NuKl56f0p+dSbcW0zRpx2
	93diFG6qmRCa2u9Ku3tqfA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47suek00gq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 15:58:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 569FAOUk021358;
	Wed, 9 Jul 2025 15:58:17 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgb4nxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 15:58:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=euqcIW4A5Y4hNHTLjInAvhdGJ7Xg2wOKmGrTpT6Bh9nijdMSX7nAkP55ndhjP6ph5E2CBynz8aHXKuOsmts1/PfEupvW83lW42HCO9QCSBSbV5HTKrSspefoIOPu1aA6AV5tCGUwazA/qIxgaJ/IIzMCMO1qut6D6+8wAGKVIsQcdptafj6YKMa1aqLaJAekNx+zvITkT4IdR9gE0dwA5GhCsX0bMtIxfuPo0XD++XvCcJwjmQVtnIUmocx50ISTq0toggFWaK2DA6fGOlrnqiu7zhul5Xe1ySXJqaJHOxdLpCFX4+PIraMAIOYSJyHm3zj1zA332FszUHzgoIdDLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSSIkd0GBYjGRnup62IhNEZs6ONyOOYJWsY4ixlz1Mo=;
 b=UL4+NJi5x1BVrkBIg64pf7kV2FR5RKIlEK0KQGPX4uU6Ym4OEWDtDuP3CgyMuDI7NsYQ96poXZeW8oDK956Utb7i1z3MiqQ/nqw78ysWIDg303vnrnuBXX+0psiTInaGrJTbmExal3mB+GNje5GVqxkIZqgb4TZqU1kQwvNQdxqlk50Hh848/w20qyhS8epkYIYpABJExCDO6Ycak8kh2PNXpswmhzrAc3Rpflcc6Shyd73oYrJruCPTHbKp3ZHnqQ7lBVPrV1SodV3Zt9YCgAeUmMIVg8x+qLUjdzV8Ir+/XlIE+7D5RATzLoElV5GbjknL1SoA2CKNfomgIq2qNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MSSIkd0GBYjGRnup62IhNEZs6ONyOOYJWsY4ixlz1Mo=;
 b=yfI3GRLKe/H481F5leI8G65kTmmv4TI01/U/umB3ziy48FGJmSNMSY45ExF5yNxtGzOeEUonCP1yMekDCPmWM/AHTaOjEWOJJQbTJTrPW3mEuEahsv+qmqfslz40PVWj07vVTu6xT2eFfTHADOCr360tSNqLfl2Bcu2/ujeW6gU=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH3PR10MB7805.namprd10.prod.outlook.com (2603:10b6:610:1bc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 9 Jul
 2025 15:57:54 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8901.028; Wed, 9 Jul 2025
 15:57:54 +0000
Message-ID: <3d30e443-d4fe-45bc-bd92-fb323d00363c@oracle.com>
Date: Wed, 9 Jul 2025 16:57:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] mkfs: autodetect log stripe unit for external log
 devices
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303929.916168.12779038046139976787.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175139303929.916168.12779038046139976787.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0012.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::15) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|CH3PR10MB7805:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c34d31a-e920-412b-e4c6-08ddbf015d79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NFlOVEo4MFFvTTVNc1JNWkNZN25KcTJxRmIvWDR4NmxpaXkxcGlHZUVsUVB3?=
 =?utf-8?B?Y0RqS2hERk4zVXpBbU0rYVMxU1B5T1dlZXBWcjdXcEsrRGQzeVd3RC9PMU5J?=
 =?utf-8?B?eEd5Z1pXOEprcysxVjhYdyswSkpZejdiY0M5OExic2orVHJSbTZQTzRpb3g3?=
 =?utf-8?B?MCtiaGJNNlFHRXlxTlJrdnFRNURwKy9Ya2lxS1oxSm9UcTM1emp2cnRnT1pa?=
 =?utf-8?B?ZFROQkZLVnhvVkZJcHVHZjBJWkg4UTJMVkg0MXVNS0w0WkhYbXNmVGRKS256?=
 =?utf-8?B?cmRiTzV0V2ZQdUc5b1IyeDVhVnFLRDJmOXZtc3NxYmJwS29ZRjJ2UVU1V1I1?=
 =?utf-8?B?WUg3R0RGT1lnODQ5aTZGSmswQ2FxbFQvWVhINDJNL0drUnZQN1g3VldGdlRw?=
 =?utf-8?B?ck1hR3NsaCtvSUpZYjY3TVNjVVFJR3NrTmpmL0FlWlN0L2FjSjhVUmE3dVFt?=
 =?utf-8?B?T05yb05ORFcyOGk0NEIycERqbGg4QzcxcTVqc3FFcGp2akdFbDVkUUJZdW40?=
 =?utf-8?B?dmJhYTRzdkVob1pDUlZJQmRSU0pFQ0pDVXdJMUdlNWVIYXVkMkNPZHdtczIw?=
 =?utf-8?B?VUtJZWlPSFJ5bUkwRjllYVphQmhieXZtL3BBQStndHdaRmcrcjhsV3FJQVI4?=
 =?utf-8?B?emZZdjYwL3lLTEI0eU15WHphVElTZlMyWjZFUnB5ckFRb0lpbHJtaENiM2dp?=
 =?utf-8?B?bTdsbUJsdDJoM0Zna0hXbVp1V1h6ZzJpeHRBQ0lxazErZHpwakJzMHA2ajMx?=
 =?utf-8?B?dDZiSllvRFUwWk5lTHhaOE5tTDhndWRiRGZVRzdaeGVaZmU4bjYvQmVlczR0?=
 =?utf-8?B?WHJmTDh0cEFMZDJPbkI0S1hOVHhrV2FXQy8ycVlvVDA0QnBKQm9OSm9qYTZo?=
 =?utf-8?B?SGZsNU5RWmpzcFJLUHN3dWV6WDM3OTlOQjNtdnU4cnljTjJ2OCtqQU13ZGlE?=
 =?utf-8?B?MGVsKy8xSHI0QWpCRWpWdUJCWnJpS1lOZnllOTRxWWxKdzRjMVdEa2xXUi9h?=
 =?utf-8?B?NjJCZmx2UmlJa0NKK2pOTmlIM0RPbVRoVmJDWUJIcElHQTBSajQzSjVDQ2d4?=
 =?utf-8?B?cEZ6elo1RnpkVlduVWpVeTJrenpsaVNRbjR2eWdSZm5pVlJUUm5nNUEwYTd3?=
 =?utf-8?B?eDV4aVM4ckp3Z01WUDVzZllXSmVvMFNzT1dwUm1pRHF1T3graDkzR2hLUm4y?=
 =?utf-8?B?Q0NhYUVSYnNIeFh3YlpBNlpTaEZNRGxtRUZ3akh6N1ZiVW9GTzVockUxKy9Z?=
 =?utf-8?B?dUxwcWlKTkhja0cxZmNpNFFodG13KzlRZ2ZsWHVUaFQ0a2ZzZnZwVm9qMndD?=
 =?utf-8?B?TFRzUE5oOHRla2VOcmRSUTBoVkFqWE9rU2NrUjlsOE9DU2x5aVA0R25GRXdI?=
 =?utf-8?B?aTAzQ29kUWx1MWM3Y0JScmo5M2U5cmhPYkpQZE5VSzVycVh0VWhjS2JZSWlN?=
 =?utf-8?B?SHlmajh0eE92bVkrdHpKWlk1VzRyTXlrNDZZZWt3ZFhxMXNnTStxeDhpR05P?=
 =?utf-8?B?ZzNEaWZQdlhMNlZJZGx4K0V3dTlZTVI1eDlQYW5taG54cXFaV0EzRUhlR1Fn?=
 =?utf-8?B?aEp0UjU3WXdQODJXN3Q2Sm1NSU04MDlDUllEUTBFRHd6VE9EL3B2NTBHQ0Ro?=
 =?utf-8?B?OWRBRTRDZ0psV0FhU3JaSmlZT3l0b3h4dmNMSHdsVmJsWldmZEs2VHpuTVAw?=
 =?utf-8?B?UUZPVFBXQWthY3Jrcy9zeHh5NnM4Z2s1QkZuZ2ZMY0o1bWFpcWZaU29vM096?=
 =?utf-8?B?cmJlSFJKVUpGNHJYYzhsMGQvd1Q5NDlWR1kvWnQwcG45SktDSllIa0NNQk9I?=
 =?utf-8?B?cHRLYTdUVkhrdjNMNUhiRW85SUpBcGwrSE40elJDWER0azl2cjlQS1RoNm4x?=
 =?utf-8?B?VVN1dlBHeCtJeXBlTzlMbWN1MlZIdXBuWlpkck44aXpGS0xkb3R5NjVJUHJ6?=
 =?utf-8?Q?UvsGVVDwGkc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elRycFI5MUc0QUpEVE5jSTdTM3R5QVlpa2ZncmtiUExpd2d6Vk45d0ZsU0Er?=
 =?utf-8?B?Vkdha29KajlEWkpWY0NQN255Q2xSR2FJOGNkSDZ5ZEtueks5RGF6ZXV2aDhh?=
 =?utf-8?B?eUFzMEUzVFd2TGNmTXlkQzAwTzdmQ0xiWGtQU0dlekp2ekpabVZOeXJsRk5q?=
 =?utf-8?B?a2Q0TVc3SEc1ZVRXZ3MvVG9ZdGR6RGlmV3hyOGdXU0RHKzlpUkp2MlQ3LzFm?=
 =?utf-8?B?M1JWU084N1pZZXFIcDFUaitDM1Z0a0s1SHJxSGdpd1FPMVAzYjF6SDR1c1ZF?=
 =?utf-8?B?bmp6Rk1tWmF0dSsxVCtneUVlQ0ZYZUFaV3pLNG5pQnRVWno1Y0xCNTE3dSty?=
 =?utf-8?B?MllBeGhUZU5TdEtQVjUvdzRSYjVWaGxXUHJqWjZQTktiaWYwOUpoMnVGWkhk?=
 =?utf-8?B?S1RsRzNXbnhDN3lkVTZTdXZMRi9RWGZ3MnowcmY0ZGNZaUVKM1ByWjJDcG54?=
 =?utf-8?B?YlA3RHQrbnBLUGNQOTcxZlRJRTlsUlRQaFZwR05lRHZwYTJNQUJoRUs0czlC?=
 =?utf-8?B?dmpZdzlrL3JvWG5VTlphYmg4cXlyU3pPVmQzZ2Jvajk0d20wWUx4Q2R3RTFG?=
 =?utf-8?B?aU5jc2tEdkU0NExqcUtqYmkyVDV2ak93ZmZMWTZkdVF2d3FZZVlaMURIbkhv?=
 =?utf-8?B?K1lVUGVlWnpQSHRCdXBBQUR0Zk12NUhld0RXdGhmTkNQeERiTWZBc0RGeW5M?=
 =?utf-8?B?Vkh2ZUdJYTZreERpSkZYb1NyNVZoUTlFcHMrbk1JMm1kUVJiTmZpM09JNnc1?=
 =?utf-8?B?a29sbExVNld1OVFZOGtZTEdnZnpmb0lTNmRsd05ZUThuNkJ1ZXNyM1N3ODZR?=
 =?utf-8?B?eXhOODJNMmw0dVZLeHhZMkpKWkJNM2dNRG1xeHVCZ00wQUc3SEZNV3lHRnp3?=
 =?utf-8?B?dEdUKysrbnljU25COURhVFpPK085Zzc2aGxRbzJMckgwMm83NmYwSy84VDIw?=
 =?utf-8?B?NkJpSlR0eFNVQStRYVFlUWtBTWhWL2c2bHdqNjJqWktQaHEzMjArVTRncHFy?=
 =?utf-8?B?eFRlcmkyT3F1dEEvVVFMRlk2QzBndm5wMFZ5VHBNZ0tvc1JMdzVZZnduUFU5?=
 =?utf-8?B?amFmTlZqNGdMMUNRL0krcEZ3SFlRZFJjSlQreVFNTEcvNSs0MHJMTk5LMmRl?=
 =?utf-8?B?dC91OU5GUFg4Z1BHL2FyNEZJT1RHTkdzc3ZsVUdNSlMyWUMrNFpjZ0VxK3pK?=
 =?utf-8?B?U2g1L3NiUmI2T3ZWOFJ3V1dOQlRUbnV5WDRWN0lWelZhaUFNSUZCZXE5MXlt?=
 =?utf-8?B?eHdXVHI5Z2JSTm01TEI5Znl4ZEkwSjc2b3JnaXZ3ckJXR1ZEOHNFOUJXSzJQ?=
 =?utf-8?B?cVhlNDQ4NG5aNnBQc0VTRTU2SWRiWWZqWndwTCtWanpYdlhvV0VFb2licXFv?=
 =?utf-8?B?c2M4WnJGS2xPSkt3clY4T3U0bThUVDBwQTFXU0I4YkszdVdQQVZZdDlXc2JS?=
 =?utf-8?B?SUxndlpuaHZBcUlFZjFBS05LazZNR1o4ODVkVUZxWGxMRTNZbExvZjdGU1h0?=
 =?utf-8?B?Y1dES2Z5V1MxcjhKTGZLaExzam13aXlFSFcyK1U1c043TDBhUis2ODdBeDdT?=
 =?utf-8?B?RG1kV1Nzbk9JS0tCTXJLMDdRY0MxNW1hMGdTV3BUTEc1eW9pRmcrTjJBbUlW?=
 =?utf-8?B?bGFuQ0w1SGJvbVEzcVFVeEx3MWxQMTN5OG15M3BWdFl1V29COEF0MzhnWVQr?=
 =?utf-8?B?YkozczNqWHpyZTBMN052Tk9sd1ZIYThYaXNyTWp5N2M0TTBwQUI2WEpKbWRj?=
 =?utf-8?B?cHV0dlZRWkRZZHV4NmdjQS9kZHF0K3BjRXpkSklKUVZxQ3pLZ2Q2bUh6dXZm?=
 =?utf-8?B?U3pYNFA3c0s1MHFQWmhCR21qWElzOUNnNFlaMTUzTUU5VG9EZnBidWREVFAz?=
 =?utf-8?B?QWc3NENHNStpZHJ2Z2k1NjQyQ096bGV0NFZwVWI5eWdVaDlXU2NvY2M0NUU5?=
 =?utf-8?B?YWdyellQUWdvbTZ5eXNaclNKdnRIN2VtMUVxSGZCaHpzTUU5T2Frd0FGZ29T?=
 =?utf-8?B?TzdVN1lMK0JvVGIxUFAxQzNaYytyWU5Eb3N2VkQ4SUlYb09rSktOYlhsY1FL?=
 =?utf-8?B?cTZzZDdDTVhqOXVyNzFQU05janFwNU9UTXA4UmViUk1NTmdPaFZFREcvZjR3?=
 =?utf-8?B?MDRSSFA2cDlEK253VkJDTmlDeEZnMW84L3VhTEFxTFFzL2kxelJRVytIU1JG?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	80h6dL4GZbZAIe0zIp1Jj/XHQpN1E6QFLfQhyu/tEqvHCjsOOc7WG6+tIWYmJYt2+3N28HuHT0Dv/u5H02S+98y0fAPHPAE5OQHyKE50AR5KYEAOVJq/+hQuPIDREvFEW6pTK5FLUx5hifErWooh4DRywvfiP8F7Kp0okHAX06VYOZR79dOqaJ4aNb7s2ASyEZtqJnN43TsDdVbbDYAYxSBOUqO3kCH3BIUKrh8n8r5NmWUEOOvHypXaFqzvk0i1tX0VoBhcECHHrS9JQBAnJFM/6B9NrK9Ysa8QlHrJP/lwXNHMlWOXJHhG4fMxJgzE31HfWaN5JS8VWIvQjGEuHofW4FWtHiK0yS6hRcfQg2Z9V9GkFLppVWCcrKwKsrWC3ja/EbItRQFAJdKvMzv+QJNUsy7MuYOKSSr54qSRS6HaVVl86HGR1sBFbNX5jCSt/OtksT2TNNWPuC+oJ3cZYGmzcSTvSDTy2QKmql1VQx5vFOWJUbCRVjd5QqOWQAfmb9G35ffZHzhUjs+yG3/3JGgSL6CoyfYwsbFP3wUyX71rprqNFYLr/RVQ8L8Z+EqEz/ok4QwcFjmG2++94I1ybt+N4aQ7MGQAwuOejCQ/Z1w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c34d31a-e920-412b-e4c6-08ddbf015d79
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 15:57:54.2835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rVAvgMdQrLj7D5/zCvLktM2t68vdwIabx7XKZQ/jbfSodFDM+lkv+yAslI7tv/Cmw7wZOqibsf+JTodIjtbakg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7805
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_03,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090144
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDE0NCBTYWx0ZWRfXyoo8r9rimWI+ 0UqQi3LPK/YbeT7DFWFn3Ybr+829zsI5m/2/EAV9IgBsFXOr1adKtPXrbk6Ewz2RCjGY1OVkwWa UFKUYX9wR8+VnL7VMjYBg7xv74xZb+AQTSAJFUzCubr0k1P9Xy0oeuBIutLpqY34lEYbtgUuASm
 ZVuLvf1nRzSv5ivIHy7HO30uczOVjrejig9wt0QBFMq1gzGVtDTKIbVCKncdh203+9JSHU730ib jfnQo+foAz+IQFBqhO2oIcJtGgitRseFTOoaJrfEfPhVH+uFx4P70V1BiBProdBIhhgN7E+alLN CmqRaF61wXUOP4orOS+o0sGiyYL8OTB+iiEO6rzoeMNpDRLx39LQUQoWnd2NCPmy1obaxnzC/cv
 3QRre2dO9N+nk6umt93PEIrwE7ZAxmRiIH9w8T6ehPOEQT7IHlXnMQRh8+BkhXKBLVvB3Fs8
X-Authority-Analysis: v=2.4 cv=ZLvXmW7b c=1 sm=1 tr=0 ts=686e919a cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=gc_KWgHxXvWhvbfiaTYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: o4Q6JARy42gwaOJ6wH1EHI426Bc7QhnQ
X-Proofpoint-GUID: o4Q6JARy42gwaOJ6wH1EHI426Bc7QhnQ

On 01/07/2025 19:08, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we're using an external log device and the caller doesn't give us a
> lsunit, use the block device geometry (if present) to set it.

this seems fine, but I am not imitatively familiar with the code. So, FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>

There is a small question below, though.

> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>   mkfs/xfs_mkfs.c |    4 ++++
>   1 file changed, 4 insertions(+)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 8b946f3ef817da..6c8cc715d3476b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c

nit: maybe the comment on method of calculation (not shown, but begins 
"check the log sunit is modulo ...") could be updated

> @@ -3624,6 +3624,10 @@ _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
>   		   cfg->loginternal && cfg->dsunit) {
>   		/* lsunit and dsunit now in fs blocks */
>   		cfg->lsunit = cfg->dsunit;
> +	} else if (cfg->sb_feat.log_version == 2 &&
> +		   !cfg->loginternal) {
> +		/* use the external log device properties */
> +		cfg->lsunit = DTOBT(ft->log.sunit, cfg->blocklog);
>   	}
>   
>   	if (cfg->sb_feat.log_version == 2 &&
> 

