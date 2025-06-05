Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289EC1E1DF0;
	Thu,  5 Jun 2025 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137413; cv=fail; b=cRiRg+vRSiLmqewXZIlN7C3FsOOP0ufCvxrRAXH1W0I0c8HkARaW1Y3/15UQJlo7cBz1P9KOoWbU4hhGjxCju5O0983E3AkU3K0UAOnkNQ8JcIrmqPqeKPpMC5houLFx/Nz4ILPenADUMHSoP8yuXVXvb1f1NCXWwWp814kEQzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137413; c=relaxed/simple;
	bh=QNfLC+lLVmOylmqJw2Ulm8Z/x1A+s5cXqc70wdxhccM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hyMe/vIyqwAd3uloN3kv1EM3bHZiT0VFNTyCwRXO4eO0mTxGdWZmwsYGgu6QVeI6cB8n2z7hYGV4pNlYsa0PqglvJx9gi3kFmvK98jFg7Wr4tLHv6EAjETkDENtQoLfNGcNZ3yWQq7uWgs3oBPig3vnT/4t0bYMXTl+yyKbgkx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HZ4DsY24; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pbq29S26; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HZ4DsY24";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pbq29S26"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555Atmk1029869;
	Thu, 5 Jun 2025 15:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BOvHeu8lIreUw5xw8hVwZgbkkvm76T6/rYp47N16opw=; b=
	HZ4DsY24SxFWLnegAJH/ChpOl0YQM0JzfWU6W8h3i9wihSbxqP0Nk2vxEodp4zBu
	Yj+/8ENQPl9TKAbZdf8u2RQy0JM7ya9l94nXThuDF+9KZ8clG3bYFuV4sTGJX1M/
	GZZpNvQ31cJyqDVU+11UHXzABJW93O5BqMcgMvI3YJpm5sJWJfcTH05GDdV6CABJ
	5Cano+d5BTeDznO5AH2GGl6UWdd3w2r1fKk6TnwViJZYiriUjYaQ/zmAXkVnpv9b
	XR2QbMAWGyN5KTF8AM5rvcRQa/0x1ujVhp/mAaAvh0GtVDveBYSVrvejXV+2biK2
	4afGOPFpKD3nRVKPPrC0Tw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8cxcju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:29:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555EUgvM034484;
	Thu, 5 Jun 2025 15:29:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7c7dg4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:29:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=piPd5xUd2wzE8z8YUmr3XbU6di9K8H0r/AeXWd6mOVOCqG64qASNMDEL0ZMPPLyptSN5SiKb+cx35EdByyraGL4su/eb3XSVRPAPcVxw6QkbxKhJ38R+0iCHqYv5jAr7HidPy0vmbWti/7JE98lIjqzqvMeJZT+a5Dhp7c/umaohnbP7o2mrBmS6a1/5BZfI2erWL3guPe+fmaFPlyWSxCs422qcMs/FpWpG6gjjG34mXAe03goZp4bxGxlABcTuT+IrBZHjAbOHeammsXELGeGsGDuxSO1Kh4fKFgn1IX2jii2DpI91WVScsst9Rvyz9q6jc2dsXWk9JAvC18+7Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOvHeu8lIreUw5xw8hVwZgbkkvm76T6/rYp47N16opw=;
 b=IwMy6wVG3pO8xjHQbV+ll16+ktpjbXrRitOsI6xHIkd4Hw3430Xhuu7Q09tnaZLpKpvmhlA4m/nwH+VP9CtsQlI1j+A5aV8FmMN5KVcGGofkURiZbnnigr4PUJWGAduZAmtEMXNyWd6Qm4DNOV8LxDcui1mJaN/9p1apNeP2ETu/AqWI1WmzKxKzglxdCSWlwtj8r72UVpprQcMlBXHzavZ+rmkBZrP6tgcbGgO5jyZ6IfoDuLIY+l/g7RKFuUleb+rAOrU1p47usdttoAyqgvzj9XoJeKmQkreKZ7Wbc6z8q0pR1QSE9z8EuphAqfAzYsUtFRdpMuG0mEmXfABEEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOvHeu8lIreUw5xw8hVwZgbkkvm76T6/rYp47N16opw=;
 b=pbq29S26WkVE0/vDqlCl84qK41L7OO8E7OXLD1KZQRgyTXSrVcN9ysFNqpHeDjMEJKxM1CrtO95lJQhSbsVIw2jxyiSLyuK1YpbBdxyg5z8RlDMwlRMI7XkyOdjnSX36AdUHueNc0WN2jKjyKsZMsjzsPX6hKNOqud6t3jVG4VI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA6PR10MB8158.namprd10.prod.outlook.com (2603:10b6:806:442::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.21; Thu, 5 Jun
 2025 15:29:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Thu, 5 Jun 2025
 15:29:16 +0000
Message-ID: <f89a79f5-af93-43d0-95cc-8b718a7c6743@oracle.com>
Date: Thu, 5 Jun 2025 16:29:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] xfs: more multi-block atomic writes tests
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <20250605040122.63131-1-catherine.hoang@oracle.com>
 <20250605040122.63131-4-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250605040122.63131-4-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:196::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA6PR10MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: c4116168-0d31-44d4-c6e2-08dda445bb52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDZOeCt1Q0FWc0E1b3cxNjJjSGhNQlVyeWxScVlvaC9QaktxVVNzQW1zdit6?=
 =?utf-8?B?VHlaUjc5YkllWXRERjhCaGZ6STRrN1c5aUZJZ1BZMUp1QVNDMVdtVHprRlhE?=
 =?utf-8?B?QUNYTGlwTENFUStDb2U3V2JIdlhxeVRhNG0zTUtGdEFJZFl5K0pYaDBEello?=
 =?utf-8?B?aUV6UzVRaytQaFpEWHlRV1czSGxob0gwbTRxTkswZWpnT1BFQ2o3Qitld3Mw?=
 =?utf-8?B?Yjg2OHRRZUZvSFV2Q2hCVFRPQkR3Qk1PY3RvczZIeWlLRkR1UnhVdk5Nd0Iy?=
 =?utf-8?B?Mk1tSEgrMDZNc2dhYzZ4ZkRnNDJqY2tRZzBPL1cxQ0lhVWNZeENPbVBsMVV3?=
 =?utf-8?B?bzU1VjBuWmpEYVk2NDVuQ2NMYTVsQ29mb0lMdWVkdFh5N2pnelRyanFwRUZW?=
 =?utf-8?B?UEhWNFpzN3kxUWN3QVRRSWltam5scHkrWU1SYnN1cVJ4NDJDR002bVdzZ2J5?=
 =?utf-8?B?TEkxQ0RadGJJOHJ4ODVqeFRjbTZ0VWgxMjk0NHVWRFp5OGI0aUJXVUVpbGIw?=
 =?utf-8?B?TUhUVTFiYzZZRjFZbyt3TW9DWTd6eWRqRVFLYyt2TXpWRGhTSDhaWm5ENWov?=
 =?utf-8?B?NGl6ZWtYaHZCNnMrdk0rUGhnWFlFNXVRNDhBaXpFOUhuK3lRNEhoK0F3Y0FE?=
 =?utf-8?B?R1RTTHpUaU5BV01nSEdHU2VFN3hhV2Nzc0IzaUVIbnQrTUQ1OU5abXdwRFBM?=
 =?utf-8?B?U3dYYVN5MEROVFFvMHk4Y0VpcTlRdWRpQmg3V0MybHp0WTlFcElHWEsxTG1N?=
 =?utf-8?B?dlpSa0JSV2lZL0VkL1RyZFU5aG84QlRxS2ZadVU2RFpMeHBrNmZueG1hQWR4?=
 =?utf-8?B?ZFV6NUY3cVNha1hwKzV3T0Z1YnRRWDNXY3JJVXJCcEYxSmVMa1hiZ1NzaWk3?=
 =?utf-8?B?M0ZjV1c5U3VyNTV0SmU3VG9wUGxMNW5ScHQxdnpaNDZKMExMZ0JobENhTDJS?=
 =?utf-8?B?NkRzcXY0WFJSY21salJKK25BaUNoN2U2R1lsWHEwMnVDbVFtdWNBQ3FTbzkv?=
 =?utf-8?B?dTA1Y2V3OTROZ3lUYXowRXQwVXhjeDJLOUxaZGh6NzlGTmhlekJDU2ZkeStU?=
 =?utf-8?B?VXg1TG5qbWhtanFPMVlvalpLRUo2dkVEOFhwZ2k4SVZVYXRFcHBUdGdhbnVY?=
 =?utf-8?B?T251b1VMZ3hmVTFxQTBKNU1sanQvOG94cjNlWVZxYmVDMEIrWStxZzhxSVlM?=
 =?utf-8?B?MThwQmhRNnJOUkhwMkVML1JqYml5ZmhxMDZCU3ZnRTN2eXV0cVRDRmNKaVU4?=
 =?utf-8?B?bVBUb2Y4UkJXTDJJeXQ1RlVYQ0treVc5Y3ZkUkpHdU1wNDYrSHYxZ1B2MXZF?=
 =?utf-8?B?YnpQTGowVHhicEFqWW9OMmR1ZkdrU1k0dWRCRlhwZ1VFWGhDNGdXNnc5K1V6?=
 =?utf-8?B?aEFRdG5NNHViL1JSYTdkVERPOGFSSjVPNHlNVy85U2FQRk9SY3YvQmg5TGZ0?=
 =?utf-8?B?ZHhJTFA2VTlTRUMvTW4xNUxaWkZvZlNZMGJPWjlBQ2hRTUlBTklNZk9XM3lt?=
 =?utf-8?B?cDZVVy93Zm1iT016RWluV2M3QTBIbGlYM2xsTHFFMGlvUHNLTXozWVdjaHkv?=
 =?utf-8?B?ZTIyRFBrWEhBNSs1U2t0NVRyUElwSExWUnNYZjV5eWpRUmo4QjZQNld0cDMr?=
 =?utf-8?B?RXI5OXFMQmtEUXRnS3hlVU1LcFpoYlVxNEZQS1VySWlFYmN0YWhFb2VoNWNI?=
 =?utf-8?B?VllIMjVSNFBINWxKUUd3TWdoWlQ2ckxTVkhzSGV2R091RXF2KzlLQ0VSUTlx?=
 =?utf-8?B?bHRBMTEzZ3ZNWCtIQWZ3aEo4UkJYMll1bFFKU2F2N3I5aEdSSkduTkcwYzFN?=
 =?utf-8?B?bkNLd05lZXhQRlRSQTI4Q3J3N1BBYU13KytvUklzNkM0NlNSUWZlZU1TbTZ1?=
 =?utf-8?B?U0swZjdTZFFtdk1XOG1kMkR4ZmxzZEpVVGhLRnh1Y3Uyb2sxRjI5VzNQZWdG?=
 =?utf-8?Q?DMuQHIGpvVg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGpuT0NwOEQ2LzhKZ1ZaZzF3SWl4RlQwVG9BMjQ5RDd6c1RuRVdMMGVGcjhC?=
 =?utf-8?B?YnZjU1EyVDd2WGdSK0o3SmIyU0gwOTJydTA1c1J2YWhzVURkUTJBWEZYeUtL?=
 =?utf-8?B?ZUVPWk91dDJYRnFVWktSZVB3RjQrenVyK3FkME1jVzNCODJPKzFjZTcrcUdX?=
 =?utf-8?B?dm53bGt6VnovQnVrOUNOQVh2NWJzTGU4YlVQMXhQb2RMMlBOenBWUDRyMnN4?=
 =?utf-8?B?S1BYdTJld3FsMDhzWDh0dlRSSHBNTGhqWmRodHZsVHpLNDE2aTRuTkhQbHVP?=
 =?utf-8?B?NDduRG1YaWJjQnBWSWNoZ1VxQTN6ZkxWTWc4dm0rWTdBenBRRXcvY09qVzlx?=
 =?utf-8?B?YWo1M3Y5UTJObGJYMWlOVDdCWFpGMTl4V3ZuRlcvU3hsNWxYQlkxL0FWN09L?=
 =?utf-8?B?NWZTSHUrejB6NHUyUzN6MEhac0ZaWW1aenVKZ1lCdUNSeVJBU1JnY3JZRzZU?=
 =?utf-8?B?WVV4TEtROHRUTmtJM0ZDd0ErdUIyK05rZFQ5NUtmWGRiZDk3ODkxYmFEcE80?=
 =?utf-8?B?Ti9CbVFVbjY1VXVEYk1CWEh4OXdDeWxlaVhWdEZwM1JDZmhYaFdKYXZsaVk1?=
 =?utf-8?B?dWZYeERjYTltR1E1OXRzZ05qNWdoSmVOa2I0Tm5rRGh5dWIwbnB4VWtFQjRx?=
 =?utf-8?B?SUhFSnQxMnlkOERzT3A3QWZlakJxdmpJTUh3aFArazFOcjF6dmFROXNURSs3?=
 =?utf-8?B?c1kzTmxTVjVBVFVBK3NNTjlsdUV2QUZ6SXczbXR0aXl1ZWxXNVY5TWNjL3JH?=
 =?utf-8?B?WWZNM1BwZnJpcGp6eGg3YWpWeUdRekFNbTRpSVY4KzJTY29UdGxXL0wxcUxN?=
 =?utf-8?B?Q0ZycnRFUFFreE0vU21WekZUeUlHOEhPdzE5OWQveVdjMVJJYldjWnQyT2Jx?=
 =?utf-8?B?NXVOcElLZk4wSUxvY1UyUGtPWVlHR0NJVTNtYS96WDJFRG9TVGdZM1hEZjA3?=
 =?utf-8?B?RGFsckt2cVBDSUhtdlFYQWN3bnhScHB4WWJPazUxcVJjQlV0VlN6YUNkQVh0?=
 =?utf-8?B?UHZNczlPb25sazA2Y2t0NTNQTmhKK1ROak5xbGZuVCtQT1FVQ1pHL1M1YnlW?=
 =?utf-8?B?QnUzNW0ybm13OFhYSWZ5elY0SmtydktVUGthbDNsSmpBenluUjJGeHhZZVJw?=
 =?utf-8?B?SEJaV1BSZHp1U1hLeGt1Ny9lQm1QaE1sdnU2N3NqbFAwVWdyaUdmN2sxQTBi?=
 =?utf-8?B?YlpWQ2NKRDkybEtoZkh4dVpXZG5QeGsvU0JsS2Q5RlVGbTBuUDRhN0VYdktn?=
 =?utf-8?B?WHdmUW5SQUVoSjNSR08wZCtxd1M5dFpBTmtHZ01KemFIUGFIcDYwSjN0L2RE?=
 =?utf-8?B?NkNERFRZcWlxVlcrWDgvV2E5eXVFTVJPOGZGODFOcmtKTVFjRjFSSHdUalpz?=
 =?utf-8?B?WE42VForUVpYOU93NXVocDR6bjlJUVJBWUloN0xtWmYrVmQ3M1U5MGFyVmVi?=
 =?utf-8?B?ZDkxVGNENkZkV2ZudkZFZEpBQnl4bTJHN05oNEJQSWxJQlBEOEk4UjRrUngv?=
 =?utf-8?B?NjVyOXArTHpuZ2ZGaWZPSHJVWmkxeGFCeVcwMG55TW8yZmo0ejRhL1ZrZXRH?=
 =?utf-8?B?bHB2di90ekF0eFJSeUJ2MGgyK283SVBoWFlnRmVtMWc3UDMwOEFETnZZTU1k?=
 =?utf-8?B?T25MSDNVSW5JU2VuZlhiRzR6NXhwS1JTT2NzR3pnVkM4UVAyL2Q4aVFyUWt4?=
 =?utf-8?B?bXZLUFRnSEZsNnFCcmZSMWtDczhNS0F1eDBGQzBsQkJBMzQyVFIrbk9LK01r?=
 =?utf-8?B?R2FFYWUxdEtkTDVtRFhkNzY5RVdaMS9RelhnajBmVXlJOUJkVUdac1M0SGcr?=
 =?utf-8?B?YWtNUVIwbVhKNWVpQXVMcmx2V2J5Y21jemhIdWZjcjlNMFUvbjBwNU9wMk9u?=
 =?utf-8?B?YWFDcjRVaW01aE5wOS8zOWhZM1dFQUpWL09hY3FtRUtwQzc2S3hzNERiUXFY?=
 =?utf-8?B?YU5hWEl3NVpCMU1TdGNRMjZFVklhT0I4OG9KSEEwdm1zMXBFOEJNelhrT1JO?=
 =?utf-8?B?RUtEbFZ2U2NKcTNGV2xGWExnNnVWanhEYzZqenMwTEtPamR2aFVsVEhHdmY3?=
 =?utf-8?B?MTVDazdPY0lDdUxIcVhDRWR6dzhSZjBySFM2S2xGK3liaGZncnpxYjRIZCsz?=
 =?utf-8?Q?f3qdKi3bQlZfqJOQvhw7vagPh?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zQQrQxegrhDcBelP3ADADkJDAVfRTvdDpNgn041tOqgj2vr+ZvgRHsEtDkpsC3DTpa7Gg7tk27dyibjcyeBEVns9fxHNLKeq2EZNavFkzOwQ1HQV4ikYBo6eYenVZ+O8R3ck3fHiYYbyhcVXqvUYhcHnJt+uvh9hOCyqAa+CCKlbqDKaGjBEryYXN/E9DxSGmIvmeMuCg58+Q0qisUjtt1BlkW6FbQ6+Z/cEa3X69/bv7b+nypG+IHAozmH4LMJkxYRx908qecQph6Sk0KGjGy//smWWirCNmLRjOkU3HmPyFq3Zfit3wnKGTW4S+C65hgu4oPs4EoA6gwcstNWtqHsvHpfGn3HrvHF6nHdYPYEI0ovx3PQVDpj6w7cHE8lsnlIE3xDenLPT1cUtExpyD+Y3aP+PEMq/SRm8p4cBmI3XwydvY/nQEs3GO/NoboAfdSVgkRFk+3pvpciYZS46LbSoKKunvXaIEWb5dV94z6F4BkAShRWRpM7NZBQJt1Nyud0ydinWzBhf3e+VeXpjfNmBVcdSOHqMcPnDPrLRC9pReUfbrvtClb0JuN4LtSRnVfJUYIJWxq3oWTXUlJx0crAymDs6Do1PKEdA6m7IDAo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4116168-0d31-44d4-c6e2-08dda445bb52
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 15:29:16.2642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKqR6Ihe8GiqbI3a52SojqeEu1gpJtiHMatSHzgPIE5Gvdbq4X6SO+kaFQ9v+hVK1+Vcti8g3GOnW7dmFI6i/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050134
X-Proofpoint-GUID: 9Qkfghflnp1Q53rY8N20Q7GBDw5wbQUk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzNCBTYWx0ZWRfXyucunz9RMSO2 HpTEE9Vv59QFGDW3LKdilKKawwMK/kZ6W/mleGjTjoeaYhVQALJt7q+I5DwL2jJ4m5J/SvR7MF+ jaPUBJMWtoZycTR8LiXWgBielOhPZDbHWWhARKaeTe0u9NVQ3+8TjbLrzEBmlvDko8DWsNzA9NH
 zXfO4fgXCHFCRRcSnPM8eBPxU10bjbBrEh9N8ys0nqQYYs14UAMY8J9aJc1gASxzF0gkGNR+1pL gr2hHf1aqXEtzGiWHeMHbTTWe2vmwRot3vAmHpMvLI5bkrInKIs8QFPoc1z47ac+CrqBWZyJlPd qCEDnHv4H8W/D+2GAZY91nSe+AN5KIlyI1xozcdkH96q8fR8Ltx6RD9OAedZf+A3ivZVkJ2FOVV
 aYvbDKQa6jUMkCdp5KRliLDacZiACldpBQ9WxmKPVQXlZTytItftIeK0N+7BbQ+4A53zl83C
X-Authority-Analysis: v=2.4 cv=KaTSsRYD c=1 sm=1 tr=0 ts=6841b7d0 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=Zlakrscs09Ip9O4ntlEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: 9Qkfghflnp1Q53rY8N20Q7GBDw5wbQUk

On 05/06/2025 05:01, Catherine Hoang wrote:
> Add xfs specific tests for realtime volumes and error recovery.

Again, more details would be nice.

> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>
