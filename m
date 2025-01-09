Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92677217656;
	Thu,  9 Jan 2025 12:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736425555; cv=fail; b=i+KncT4tjAI3ydA2TQ5IV6N0ZZFnu5MJmuAL7yfO/R3evN0rfAQ32hgBXUNVMHdBxrAuCdynibAEjyD9qMidUlU9+jcXmO3fyLHlUibl4xYxOShcbuCWIcDeMoVIxSnnRvFVUTAfVOwAREQBEkiiTieNE3OlkIa27CvQZrlChAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736425555; c=relaxed/simple;
	bh=ejVUdxb4CWoWt1qDVscQtmB3fv+Ku+WPcMpNWXPe02o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h0egOXlZ+y9Enr1pBkxxdrVeczEOh6VtZzYnbEPi1YjmJnEjJS4SmSkHhPnAJ/PIca6E81nV88godPbpC6ofhZ2AjZp17uMF6i/Sv92CLfEfnb3vbmWxM089816tFHaVfGkv++giu204KoL0QwerFgER3VNbZQ42XG3z2MiUrsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lGcc9NPd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PwkzPzNj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lGcc9NPd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PwkzPzNj"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509CBkXn023819;
	Thu, 9 Jan 2025 12:25:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=IJdJphrnhMjzh8hxAFOEnDhESKpwOCpSUsORFeK/4eg=; b=
	lGcc9NPdo532+0s//6zmIqYKWElAdRba2PwanPhNQUKhsrSvwpa8q/aooIxVC001
	JZPSVtIkhYrnokcc7uhHNm7GxFjdP41q4GG5/QcBR2iqgQqy8lXuC85tZScrK8n8
	U0ybqHx+MeHeJfsDOPgpTQbOQHXIqRPgziLHE+OsZQ9AM2+dRXBGvHmrSibUZ59n
	SiH8x1atdakxZEChH07o8WQH8b4TnxPFejJMf50N+SaOjOp2x+bqZd43c1UI4ekQ
	2pwDXC+nJnlUx1YIIfJjgNxbE6WH+i+9opy6OBYyeXMvoa1QP14qKdoGsF1VbS9W
	/Lrjr6N8kUYRObgHSXxzQw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk0934k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 12:25:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 509BBYvV004801;
	Thu, 9 Jan 2025 12:25:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xueb1ae9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 12:25:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ozg0C398RyhaANOz6OqoQwkIenyvbwtVlHFZTPmKSGGNwQ3MLkcn4oKILc9ooY81BrGw/wZDXVk1pyMkwJMx3QihZAhvDBSZ404pndqHBNdxitdrAbbPhwLWwlORSEZf/WXC8jW7FzkA9w8S73ofYyG2IeFFT8caT0ZrXVWXKWe6wBPLoXEV9dIC0+72t/sZ1sd0aXI1pEzwDeDPIczDdWjJtAJ0SO+xdfdN62blEE39EprG5pZ76rJad8t8UAkL4MCcGu+ASnY/K2cWhfG2Q/cVc5SDh1UvpgkhjyGGm9Dm8AByYVCa4B1IlplxmYMugQyCWx+wya9FvO1Tc/2GMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJdJphrnhMjzh8hxAFOEnDhESKpwOCpSUsORFeK/4eg=;
 b=SXV02YWzKvz3taFsBxbbZWysCH3uhFcD74+O72TqchWJap8ScxmUnH1NQBsGqT7lrtDSA8VXMT457T+QqQ4ZoGgzQzbNkI2EVZxg9vmRS/RcyxJLkeRZtecYsQQenKsIsdsQThllMar+6uv1uHhfNJCrRBGAGztutR/IhaSbPh7mGp6KpydQKBFwTzgaDrMUrSvnvZlyua9IObuvT76sGBfBMkWDkJqiH/Lt6VjRO+NvAXwXFqL1jMwvitNjZhYWyVvXeizm9EoLSfiBQwGwEQ1vnCqkYd/La+eGmsoNffMLR3uhsNVL69kd6jEa6U60Yn01Ww6242Y6ORutK89IgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJdJphrnhMjzh8hxAFOEnDhESKpwOCpSUsORFeK/4eg=;
 b=PwkzPzNjvZXPIiRP93mVZBZF439zDdiXrKqesDIiT/LJ2pO2Dw90T/fvwg9sPYsn+G8TVEDy1qn3Af/ZanT6Swk5xeWl0du3y8PK0+KtIwZQkRd+jyOdFbnLOs9rTCiscqRveUjMBsxuA8QGubxkanAvVh1IUlTPl68HEiqo/Qk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4669.namprd10.prod.outlook.com (2603:10b6:a03:2ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Thu, 9 Jan
 2025 12:25:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 12:25:39 +0000
Message-ID: <58d1f280-e0ac-49c7-8f42-df22fd5c5d9f@oracle.com>
Date: Thu, 9 Jan 2025 12:25:36 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Chi Zhiling <chizhiling@163.com>, Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, djwong@kernel.org, cem@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chi Zhiling <chizhiling@kylinos.cn>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
 <b8a7a2f7-1abe-492a-97f8-a04985ccc9ba@163.com>
 <CAOQ4uxje241QhUeNe=V8KKY+5a27eYd2dc3s+OiCXMPW5WZyPQ@mail.gmail.com>
 <90e5f9b4-eb1d-4d63-ba22-4a1f564b2ccf@163.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <90e5f9b4-eb1d-4d63-ba22-4a1f564b2ccf@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0049.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4669:EE_
X-MS-Office365-Filtering-Correlation-Id: 4de7431f-e618-4755-6adf-08dd30a8ba63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1V5c1FMZ1ZJei9iQTQ4RXdyQUFBZmhvOW5Ka0svTHRsSGhJTWtId1QzU1V6?=
 =?utf-8?B?c0tJcmlUQU1QSXk2M3J6WXdtMk9MT3VkWjVhWkxTT2Jnc3lKdzFzWXE4U3ph?=
 =?utf-8?B?Z0ErRFJHTlpWQkFGVDNFeFR0OVdWSlNsRlhMVWFsU1h5c0c4V0p5SEZmSlN1?=
 =?utf-8?B?bGd5ZTBMTVZsd0gxT09aVERlMUtqSFJQSUxjcm9PWTBZcGlQL0RZK1l6TjFr?=
 =?utf-8?B?eUt0QW96RnUzKy91dWEvc3BxUVFhNU9Peml1Q1hmQlZlTzRQZWZNV2FDSjNw?=
 =?utf-8?B?RlcwS1ZLOWhMRWt1Z3FlcjkwUmRIMnNSblpvdmxuRk4xdW5CRUd3MkVFQ2Rx?=
 =?utf-8?B?Q3VaTnM4QStvdEdocFIwSDMvVUlVb2lwcFBBL2ZvaTJoMStpSU1CY2s2NWFN?=
 =?utf-8?B?eW5tQVRFZTgySkJqY1gybzRMZUVibEFTRGZyRExRcEw2OU9oK2pUdmwvdWxp?=
 =?utf-8?B?ZEl4eFplMkh5NHMzeGFqazQ4bW9GRGh6dEhVeVd5ZnRwNjZlUFJrZzFuVmRL?=
 =?utf-8?B?Z1l1b09hSFVrbGNXRlJWQ3J1OEg3YWg1MTUwZ1ZVYmJHZEhlN0FPZVFHQ09p?=
 =?utf-8?B?Uzg3aEk3clZkSVV5YmtwS0VEZ1NTZDNhSHNsUHFVK0o2RGNqMk1zMmM5Sis5?=
 =?utf-8?B?QTNtWnJWMkhqdi9vL0g0NllkeS9RQ3dwVFNrNzZXemFoTUZrcUlXSVl3MnUw?=
 =?utf-8?B?UTdhZUZkekpTcnM0L0NBVjVLNVc5K091RllHVU5FSkJ5ZHBTTXprVVhVN2dY?=
 =?utf-8?B?YjVpLzQ4bDdmWUtiK1dhNkl1UU9tdHVTMXdqVXhKZkFHbkhoc1R1OUpPbUxl?=
 =?utf-8?B?MllmWHdqZmZySlF3UHhmNlUyRGo3ZmhCT21IU0JiMHR0ZTVicUpKY1RqeG01?=
 =?utf-8?B?YjZLVTJOVG1WRk5FUksvMDJtdmRiQmhoa3J6Ulo4OCtQUU5HTkpOZGoyZytU?=
 =?utf-8?B?RFVjV0pBRGxYdlVUTEwyTDZMRkxXKzFwVzJhSGtZUXFmVnNTQUxkMjhpakFN?=
 =?utf-8?B?bUNVVzhUd0hva1lmZUdGK0N0R0xYNW9STnBUNkNjWjdRdlpmdzNocnVabkt0?=
 =?utf-8?B?SkMxZFQxUERoTlQ1SlNPaWYzZ2I4S0UxVllIK1VlTjl4bzk0dVZ6cDJ3b0dR?=
 =?utf-8?B?bFdtenI2aXNTZW9vYzhKZjB0bkd4cVRsOW5mVWY5NWdtUzR1MkN2ZXpyaEpx?=
 =?utf-8?B?U1dibDJJanBnZ1JPUjRNVENXQ0txUjl3ZmRBTkE0S2JKN0pkSm9aMUhsMnBy?=
 =?utf-8?B?UTFpVFlkMlFOWjBDRW5OZGw3bkwrS0N3M3V0MXpQMndhYWtleWxsWTB6TFZX?=
 =?utf-8?B?M3dLeElHRUtFRGNCSGVnQW4xUGRTejZxQjFUMHdudFJ0OGJVaUR4c0llU2J4?=
 =?utf-8?B?a3FrK1A0cUN6cFZLMjZJVnhxUWs3eEJ6UldDS2pCaUhSM3NHNUk3ZzNmeFVt?=
 =?utf-8?B?dGg2OEdZUHRTU1Y5OHp1cTJCZksrNjA4MmY2QTNITlBMMmFpbmlXZmZ2K1I1?=
 =?utf-8?B?Nk0zUmtLbE0xSy93bzdDY2hHSmpXbVJKbjZsMEtnVUxmdW1TeWM3QkRIRlVO?=
 =?utf-8?B?UHl4cmtsSjJTZzN1NFdPdXB5YUJraW9ROEtmb3FZdHZxT0gxa1M3bmRGeWts?=
 =?utf-8?B?VWJZNzNjQjN1QjQvVG95dlhqZFlTSTJEbzU1ZHZCMVQvanFycWFRSFlRcFV4?=
 =?utf-8?B?a0F5dlhpbUFGMHZwRGpGLzlBekFDUXozRGJROEdLdmd2aUs3SWUvWm11ZFV1?=
 =?utf-8?B?RXljMHJ6c0NFbTRuY3NZR1MrRHMzVWF0VWFtb055OWJPVW9ZdkJZNkdRRmJT?=
 =?utf-8?B?NVhRcXVMWGJIZDBkVDdSS3FrOGdkSVlKc2tEbnZJckhIKzFvMi9hVW9JUmVG?=
 =?utf-8?Q?U+0eZ/F9HPlkH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUxUWTFrWWlyUjV2dHYwalhkbno1Mms0Y0sxdlkwZEY4K0tkejlUTGpDdFNO?=
 =?utf-8?B?YWlBUzJSWkgrODN1MUd1ZUREREd0Q0ZrOS93NXlHam9UdmpZdWE1TVYzbmJ6?=
 =?utf-8?B?dGxheHJvdlBrbDZSWmp0OXRIYS8zYVRXVE03aXlnSUpiWE9lZWVBTGQrMVYz?=
 =?utf-8?B?aGNUQmVMbmxMMzl6cXdrUDJYQ2hvZUpwUS9ydVRMVWNMRnlPbEJTZzRGSkpG?=
 =?utf-8?B?Ull5d3UyUlo3NUlIdDd1UzFPQldBMG1MMC9HSExidXlaSEZBSjBUVlJrT0Z6?=
 =?utf-8?B?K09uUmEvbzhGSGtVVGpwdnhjSWdMcFh3dXEwalZlY0Z3aW94dHF5TEdqazEy?=
 =?utf-8?B?d21nNXlBb0hxRzl4bG5WMHV2Z1lUMk1pZVNwVEpqYlNadzg4R0ZrZWVUVmZk?=
 =?utf-8?B?c0E3ZkJQVk9UbVU0QjN2M3ZqVXEvd2JUSnFjMVR0MytQTWU1aUFXVHNmQ3lD?=
 =?utf-8?B?SWdROEtvaDU0Q0xmd0JEY0dYWnhWU0EycWF2MmI1bWp6cFBGWVBHVXhLU3c1?=
 =?utf-8?B?b2lrQzhqQVNjUTFVY3B2aExOTGJyN29HN28ramJhc0Fxa290VElWcVdBY0tx?=
 =?utf-8?B?M3BWdFN5d2J6YW5uRSt1N3NGTHJMMSt6UnNucW5yYUsyazA2eEJWTjR4VWJz?=
 =?utf-8?B?cnJpZUplcTFtbWlrckhoUlJnd1N3a3drRDV6Z1dXTDNZWmNacWxxeTJCc1lI?=
 =?utf-8?B?UEFTVEUwYlllaVRaSTNMQm5LY2xiQ3UyU0NtbW10L1Y2VWlTVFdpZisrbDNu?=
 =?utf-8?B?dW0wT3NMWXNnNnpxbGRzb2dlVDBNeWg4eU5vMThnLzFtM0gxcUx5ZWxBU1pM?=
 =?utf-8?B?UG5HNi81aXNSN0dhNmpFaFV2T1NCTDQ3dWdtOXJhYTFxNkU2NkdDQkZaZUR3?=
 =?utf-8?B?bTBaYmxwUEVUS0ZVcVltL1FrS2pDNGJtbnRleHVJam1hai9uMlJScjdzU01D?=
 =?utf-8?B?NE9FWFdObE1UdzFrcnRDcnJHY01FalNWK3piM08xU0w0eXE3R1BJNmNpWUEv?=
 =?utf-8?B?L0FBVmpxeUx1OGo3VkpUeFZIL0s4V3FLd2tIMWdMQ3FVTmgySDBUUWUyWmZC?=
 =?utf-8?B?OVh4Zm9raFZwT0ZlN05ndkoxYys3eHRjSTl2aGVEK2lwYTRUdnZZM0hUUEQy?=
 =?utf-8?B?Z05rUVEwM1FrRnVxQ05WMmZzUFplcXBtajhIZCsrSE9zQmxnM3lXa0lMb3ds?=
 =?utf-8?B?MGNuRGU5WnBvZThkdGdlVXRDbzM0NWdZVzM3ZGFhK3lqWXlzWWw0ZmNoRW1L?=
 =?utf-8?B?VFoyV09mVGdaTjlJbTBxTWdpU2VYZ1FUSTZFSmczaUk2S29xeFRpbVYzZUl5?=
 =?utf-8?B?YjhOQWFBQkt2eGozTXRZTXBnYlV0NE5HY3lkTjc3V0FtaDE1MUNQQ24xclJK?=
 =?utf-8?B?NmZBcmZpV3AybkpraGdMbHNSV1NUSnRUeWZHOXcyQ3h0L2FYU3lBTklEdTVp?=
 =?utf-8?B?Vjc3Z2d2czVTNDJPWUZoMEFjNmtWdUJjZk1HaDFuZk5MVFlMcy9IeGYxRWhJ?=
 =?utf-8?B?ZlZUUm1wL2FYaGVQajZVUGFTYmpteDJBMUNGSUNHWFptQndPYnJ3WmU4bEVq?=
 =?utf-8?B?QTR6RzBvTFQ0YmdTOEdyUkwzNXZuNzRORWZVbXhobXlWalpiWDZmNVRpUGtr?=
 =?utf-8?B?V2xjUWVoR21GSW55OFB4Q2FhSStITlZGUWpFNVpnZ3pzTC85bG5USW9rUEhZ?=
 =?utf-8?B?dFB1WElWTGpzUmgvc3hCc1NZT0lEb0FvMVBsRm42d3hMMnBmUDViWFRzVlBW?=
 =?utf-8?B?U3l5Z3V3WVpnanR0am4wVzhBNHNkYXkxUzZWMks4eGlaV1I3Z28ySXJQZEln?=
 =?utf-8?B?a3p1Z1NNWDNJTGpsc1QvUmdjaHpUdmVFU25SNTR5VXRveVVvZDBNNmd6Rk5V?=
 =?utf-8?B?Z0tWdHdYdVFwMDEzalJRYTBiZWVCQjBqb3pUVE5waWRIckVHU2JUL0QvMjY3?=
 =?utf-8?B?M1M4Ykd0YURzVjBMM3E1czAyMHJMeURLODNwWjlIZkJvSXlHem1YbHkvVHVt?=
 =?utf-8?B?VU4rRjBtMGoxNzFmZ3NYMiszeVdnYjNFa1FPNjFEZTlBMmoyYWdRVFEwN0xz?=
 =?utf-8?B?TnYyV08yM3ZYejZLYUJXTUFsc2lTaEIwQkFyT2x0N0wzdTlmRGlBTW82MmpS?=
 =?utf-8?B?TG9JNkRKZEM1OXp4L0txU1lqdVZCZ1VwaTNkRE1RZll6azFUSFd3Z3VVQk52?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4TYjjpPBHdT7cU8w3ovFIAUK56PLhZUZ9tHfQ4P69/i7JHfYzvQisCJ8Lv6ii4jFkb1UeJWZZ1n8rDbcFFi5b8Q9hIgZB/vHmhGDPNhOQD3VLAiH8quutLo55fnRfRzpzDMy5WvMLQCFtWpgMizK6iKAK/YI7DpcgBtIrdcUKj0ZCbhXTFYQCk+2V7wA/ri2USB2yF01FmCxheGcS5ILvDkxQMir8S4DHMKawe9FNcda7S6p6AYAbjoEjZp+1ANheFA5AlKKnrbxoRqZqy2UQ4LNrA9f1AX+vnvrOt18lbROgjjLEqf/+DScr5pkBkY0A7v4Jt3z5NiQic5W4HF+CNmK+Vn+xwTl8Tsw6HDwfMzU94zu+WupTduSaJOJGDzv5eAGyYKu3LIbIp2b/d8wdhAtg41QiLxaDH9oo7fNp82TvngA2WzN/IL5TOLN8ZOoZ34BiTo7bY7dEUkRNJReNXZzvN6WxiJ4xjwFmK3lErMbLS1U7joGbZ4IQpDUMYFufZwVilZkQsQVpIDoukHhrZ36BkZSPalW3uL0BLwKeRaoZ7jTXx4mRDXgy/voscNfg58JGF3mGQNUZ2hg7pQ6lSxPHQ/9GT5ksiPckllJrBU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de7431f-e618-4755-6adf-08dd30a8ba63
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 12:25:39.8334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSfIPOsARANKNBfCk/0HHx3O0BPpiix2DAG0Yr1N4wYyqd7p8koFo8odvjbg277FkwQzyIlUvJOzUGAWr5OK5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-09_05,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=893 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501090098
X-Proofpoint-ORIG-GUID: Zc6TLoYx8M3A89ARGuOB_7gBNUnzmZhG
X-Proofpoint-GUID: Zc6TLoYx8M3A89ARGuOB_7gBNUnzmZhG

On 09/01/2025 12:10, Chi Zhiling wrote:
> On 2025/1/9 18:25, Amir Goldstein wrote:
>>>> One more thing I should mention.
>>>> You do not need to wait for atomic large writes patches to land.
>>>> There is nothing stopping you from implementing the suggested
>>>> solution based on the xfs code already in master (v6.13-rc1),
>>>> which has support for the RWF_ATOMIC flag for writes.
>>
>> Only I missed the fact that there is not yet a plan to support
>> atomic buffered writes :-/
> 
> I think it's necessary to support atomic buffered writes.

Please check this thread then:
https://lore.kernel.org/linux-fsdevel/20240228061257.GA106651@mit.edu/



