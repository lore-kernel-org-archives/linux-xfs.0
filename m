Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4520825A65F;
	Wed,  9 Apr 2025 09:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744192477; cv=fail; b=NP+u5ksyo0uCPB0ZM9GgDDQI27ETwxl5STy/EqDakdLaaQ5ykxycVv8txxpRfpcmm+VPPdg7n7niK2ueGG6OBcADL3hXATaNh24SCxQ0PV3K/qxLpQhRd12fTkR/n2Ft8f5CJPTp5n5xsskOl3wEIReH6d50yuUwVwcPxBsccpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744192477; c=relaxed/simple;
	bh=Q/nG0rK1Rnz4JLu7XKRwewkruSBLI6utZu83zRGzGgc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hKwRMZ/jpp/SUQVeE3QnK//etX0IaVlL8K0i/M9Zq+YYBGZ8+ahnHI1slr3bD1Yr9OHjldBX7j2Gwywe6JpRgjGL1/gerSlzeJaxrYaeH91EqCBH8IORlM+2AeQJ168m1L/0k79F5V7P3q6coTFg4wWEMElT8Ayzzw11I0a4JdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T4BTaej0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ba1JlexM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T4BTaej0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ba1JlexM"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5397u1mK000505;
	Wed, 9 Apr 2025 09:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=GTXtjyz6S1cSn/ZjG0xI4TJjX6QVOKh7Lxf9ggaCh8o=; b=
	T4BTaej0lUMwNhvsJ65X+pAzJ/dzGW1jtswZ9llFKc5Sc6VWVK+fPjn7+fVSozmr
	YPYrpbpVagRQQ/ZfhGkavkTX20IItj6MKPSIkmXYPZ932mcMsxUecEOwkZVKR7c3
	mDcbRZyiTJjCk6oZJwXUCFn+NXLauT2gmmdIY3ZKebyVPbxJrPaL6qVsJ6DoOVbo
	FhSwJleN6NUcGbKJzXAyxKcGT4mos2FTBh59VTOnFg61cVJ7P3eAS0THKHy9o/ru
	wss5go06S8QXV84w9cAnTKZO6dOkF9Gt9DgJBogCzpx+MmEersajXEIdCIWEIlkz
	w0Uz3eGRbuFIwds/fF6P6Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tvd9xpbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Apr 2025 09:54:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5398KBJx021069;
	Wed, 9 Apr 2025 09:54:32 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazlp17012039.outbound.protection.outlook.com [40.93.6.39])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttygwkvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Apr 2025 09:54:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZVeVjlj4IleQhjW1602akjnb005UaqKMq8QKouaLcIivA/x/K8lhSaHVBFHV/LhDtvsAO5FulmmkWyvQWISGuxNuit78+f2zwwS1yDsg/hcZQUxfODxPAu274GMI4V26UrCZlSfUVC1Jt6uFnLh93Mzw37qICmzJ6XGlsE5TXSOAVcKY8wU2N4zU9S4cj+n35ozEuJLX2+I5NEo8zUyxni3ziaR+qaUYF4dAwRSOlGdw7RVBCMC20bxqf1ojpJ3dk1eU6hoflvK+wElXq8HKmup9SmosqovSsc07SIkPoySICxmYGx0fk7cf6ja0jBjZcwoD8ROUvK1WtiQugXhFpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTXtjyz6S1cSn/ZjG0xI4TJjX6QVOKh7Lxf9ggaCh8o=;
 b=HItySx2OXrr0pYITSTC9xTkLK6MJOKaPYasohQpWO6nM4EZ5SBTYtUEOQGSWJWsmpR6oNIgrp3y0zdGaNJAd+3pC0p1xTVSGtt1rUPvBefBMMSRg4uI5mYOVZfAGTNoGFOxDQ/2fK+OLoZoPUyAK3HdGEwx3nRB4okrtQEQ1yEcc9TRrbRWQVZP2QWPzYX73JDTASHn0uoPAVZf0G5gFWjLBS51djHr2SJ7RLpti6D+ihqGkV5Yw3yKSyxyjSPHrNwzS+gnE3GNo2ID2AtPFievxjNvyUBLXyNScomBdr2dlo6PIb80q2D+bQ5Y6aNBr7+wu0xPzf96dVWclF2+TTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTXtjyz6S1cSn/ZjG0xI4TJjX6QVOKh7Lxf9ggaCh8o=;
 b=Ba1JlexMGGrgNz6cKc+zcg8rWjllbHiokmvmo+MDfYfrnZ1Z49A0zDrNur+GXYz/QzVsgVWNhp59sVBS9BubYxAAJU2HHN/ulKK6WHCrVDcCM+mwILB0XSljSmtazSO1I8mWdHJ6xkhgFk/Rh5IF3gj7+xV3NIdb/GsD2JRet7o=
Received: from MN2PR10MB4318.namprd10.prod.outlook.com (2603:10b6:208:1d8::20)
 by DS0PR10MB8079.namprd10.prod.outlook.com (2603:10b6:8:1f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.32; Wed, 9 Apr
 2025 09:54:25 +0000
Received: from MN2PR10MB4318.namprd10.prod.outlook.com
 ([fe80::e563:43f1:4b02:5835]) by MN2PR10MB4318.namprd10.prod.outlook.com
 ([fe80::e563:43f1:4b02:5835%4]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 09:54:25 +0000
Message-ID: <b839c41f-6120-4358-b86c-7bde6a6ab4a0@oracle.com>
Date: Wed, 9 Apr 2025 10:54:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] generic: add a test for atomic writes
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
References: <20250408075933.32541-1-catherine.hoang@oracle.com>
 <feaabfc0-1fe3-445a-8816-c72d52132ed2@oracle.com>
 <383FA3E5-B8EF-4636-9F3B-658FBF82A242@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <383FA3E5-B8EF-4636-9F3B-658FBF82A242@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0028.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::20) To MN2PR10MB4318.namprd10.prod.outlook.com
 (2603:10b6:208:1d8::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4318:EE_|DS0PR10MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: a9131c5d-a01c-4f88-2c8d-08dd774c82ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUlyU0JEczlhUFJYR0tRUW5MUFNoQXNPaURRTjcyK2VxcC91bjhWTm1rVENw?=
 =?utf-8?B?SFoxZitnQUxpNWVpS2hyS29MMnR4V2c4d2lXZ1ozTUxtbFNlNWRYVHlXUWVW?=
 =?utf-8?B?bzVoWDhuVDhPaFZuQXZUUWRYQjRWQmpRYWg4Z2g1VXU2T3lYb1lCN2FVSU1k?=
 =?utf-8?B?cGRBZG9GR0RNQldKNUNSZGdRb090VWtNeGY1bndncnlSeG1WOEFFR3FhSU1S?=
 =?utf-8?B?T2RnVGJLcWNtMitSL1JpbytMaFBHRW9MOFN3dmxEQUNWUTNJSTYzRTNUYXNQ?=
 =?utf-8?B?d3JlN0JqcSt3ZVpJbmhwWE01R2dwZ2phYVdVanJlV3BwVWtvbVJ5N01HNnda?=
 =?utf-8?B?VWppbGRoZ1JiYm16dllGbnhpRmxlMDF0M2l3VUFlc1VlNHdlYUdPcUk2YURH?=
 =?utf-8?B?SjhHM2hIV3RMZjY1RXFuYkxkd0dNc2grVnlrc2JMQnRRV3JoU3dSSnZUcUhQ?=
 =?utf-8?B?RTRNdFc3ZEwzaHIrMkFYOGFzVW1IM1g1NmIxdWg3Y0N1dWcyUGZSTTdUQkZW?=
 =?utf-8?B?RFVhb1Z5QTRFMHQzU3dSUDg1YUhDdktuNGxQZUprUE84SGQxTHNnVW8zTmRX?=
 =?utf-8?B?WTJLQW1aY0pPMHFxQ0dac2s4bkR4YlN1M3BjdUtLM2d3ZEFlMUF1bHRWK1Zv?=
 =?utf-8?B?eTJONUJPQUhCTmVJaGhsRDRTK29nS2hqbWRGZ1R3NG9TZyttSVNPTkk4S2ha?=
 =?utf-8?B?M01TYnRja000SWN4cFk4ZmNjY2tvM0J2aUxQRHBhbmlicUlBYWs4REMzaEF6?=
 =?utf-8?B?WTRyei9HYUpJOEhQdllnQ1l2RkplbkFOQ0hFTGJwZ3hSQnBjdUNWQnlTdG94?=
 =?utf-8?B?VDlPTzNRaTkxVGZ4TVRmWDVYVThWODVTOGhtNUNQOE4yU3RMaFN6OFZFL0xo?=
 =?utf-8?B?eExRVnF4U0ZpTjQvM0xRMS9KMytESEo1TjlsRWRwRnBKRFdQWTR4NVUwa0Zm?=
 =?utf-8?B?cE1ZdWc2am1Hb1Y2di9sSXcveEVXdTBEMVlIVEdvYUUxcFBpTzJFT1NZQkM1?=
 =?utf-8?B?S2srOC9ISUVTOTZ1Wnp5QUV0eXZ2dnplbkhFR0g0M3RESkJZQzh6V0tlSElt?=
 =?utf-8?B?UlJFTENxa1lLMUFldy9TcDdiTHRPOHdXeXp6dWFrWjhXWjYrQytZbzh3b3Vt?=
 =?utf-8?B?N3JCSTdjbVFNU2hwdTBBR0hlSUxIaCtqZEtDM2tWaE9oTHRGNHFaR1k0aUNL?=
 =?utf-8?B?THFsaWtNVWVzQXEvdGFWQXJhTDllVk9XVWl6T2VwSHBDbUp1QzRWeU9ZWDAw?=
 =?utf-8?B?OWhnUkhwWXkvdWxkeHVMRzhDMXpMR1FDeHVuT1RBUEhNMmFSN0VweUxGNzZx?=
 =?utf-8?B?dFphYkNTa1NBMFFvOEpzQ3dDWTloQXlOaG1uUkEvN1YrQU1NUXM4b2hsL0Ni?=
 =?utf-8?B?T2FnRnU5UTc3K05rdGh2enUrdktyQkhCdVNzQnVySm5hY1hrS1ZzbDdFWGo2?=
 =?utf-8?B?bC9mODRab1RqMFR6MTF6bW1VbDR2N3hBTDl6WGtzWXN1N2lqcFFQbVZqRWJa?=
 =?utf-8?B?NGF2N1RqV21xV0hvZzU2L003eXJTdG5oVVB0bUZoZVdYL1ZxakRGRzMvKzJt?=
 =?utf-8?B?ajlQN1BzcndYRFIyYkJDMllUS01HOXZWMlRKTHJ6L1JDYUlyYVN2U2tqTEQx?=
 =?utf-8?B?dDFINUEzVEZqaEo1Q1l6enordFBsOGFSa2tKZktEaEowNjhzd013bzRlQmhZ?=
 =?utf-8?B?cVF5YTNqNFBRL01Va3R5amxaU0VzZFpYYlFCUERKeGdFR1IvQ3U1ekhRMkM1?=
 =?utf-8?B?VTZJK3BkSU9qMExQM0x5R2VOSnFKU3diSit0QllaY2dRVjgyeCszaUNNVEZo?=
 =?utf-8?B?UDA1eE9kQXJBTjRCMDdVNVVlM1VBTlFLU3g2dGp4U1VRdmc1NDdIdUJBZS9i?=
 =?utf-8?Q?I25KS2TcXOrGN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4318.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VCt0RGNVelk5VkQvYURtSzRXaW5uSG04ZW94ckE0UjZWVTFTRGd0YWVaMzFR?=
 =?utf-8?B?K3Y0TmZXOEFCRHpWMDhJSjI2V0U5bFhtUXY1cjErWFNUOFNiSzBWNHJXZkJr?=
 =?utf-8?B?Vkd6aHBIYjJVYXdOQWtsZFlnbHlUZnMvL29aazBsb1Q3eUVRa0FZRitnRlNZ?=
 =?utf-8?B?bnZYQzJPTUxxMHZPT1dTeHQ3cG1SVVQ2RjRmbEJCRktFRHUwYkcyajl5YzVm?=
 =?utf-8?B?bkttWFlYdGRnbWtYb2xvYjlpd3Z0cnBsbWtSVmh6QjkyaXpiUERmQ1lzdmFR?=
 =?utf-8?B?Q0h1c2UvM0kxa3RLTmZGMGpzbythVnQxcVMwcXpaWDZrUERrbVl2SWFTYW9G?=
 =?utf-8?B?WWsxVk5ObFhnMDQ4VWFTUUhpUTBiQzkrY0dIU0hKMkMrV1R3N1ViVGUzSHRk?=
 =?utf-8?B?U3E4aU9sTUNVSVdJaXlrRU5RSFdQZ29RKytMNWROL3pYb0ZTTDZIbVl6Qm1l?=
 =?utf-8?B?MjNQOTNOK3E5N1EyZWg2SCtMcGNHeFRzSWYvSzZiU2dEbFJFeUgrZ2l2VkJv?=
 =?utf-8?B?M1M2UHViSVNKb3l4dTVNbG03ZnMwRWRZb3lYREYyakhyTzRJYitqS3BhQ01K?=
 =?utf-8?B?dnVvSUt3U0I1N05nRThxbEF0M0pneVl5OU80aTgzakRxMXYyaG9xcnNJSlgw?=
 =?utf-8?B?WlZIQUdoblJjNGZFL0tiUEgyMUM4Q2NIN2tZOHVPNUpRNHZhMEtPOG5kWWhN?=
 =?utf-8?B?QWtsTnVZUWpTVUxXWldjTDZORStFM0lndklCLzJEUzUrbDhOWGprMXZrT1JG?=
 =?utf-8?B?cDE3YkFoVDMrajRyQ21kTDNpRExCRmtzTUpiVVdQUWZVRmJSU1lkTnYwRnhx?=
 =?utf-8?B?K2pJTWkremZhdW9qVktSdnl1NkJ2RGh0TDRrdU52VmlpQ2lJaGRGM2tCeExP?=
 =?utf-8?B?QXQzOHpKTTE1M0dJUEFXN3BrZzAxbmtjaDlXT29ISHRqZDJQUlhIeWdLNmhJ?=
 =?utf-8?B?ckpHN0wyT2ljRWMvakt0eXdoWmVRVFpNVDhyTWNua201Ky96bUdHYWJwcm0r?=
 =?utf-8?B?ejROb1RuZW0vV01qdEo2WHRSSDZGWk1lZGptbDRFK2s5dVFGajlHUXVXelQ1?=
 =?utf-8?B?dkhXZVROa2lqNGFFUzB4NFNwc3Rjb3lzOTJRd0ZsZ1R4QWdQckZKVlVhYkFN?=
 =?utf-8?B?c29DRVR2Y09xU3BveGcwQUVVWUZHQUNUaDNLQytCTUN6SllpZWs3WGMyY3RY?=
 =?utf-8?B?WTNnQkpNWmljT0RGMy9sanRIcUc4Z1pyRmw3QXhacTdUZnJxcHd3cWxBc0ha?=
 =?utf-8?B?cWp1NDlNS2diVXVtWHU3REk2QzlCQ0ZXZDQwRmRBSmxMRjRUb3hMRzl4WGRy?=
 =?utf-8?B?czMvaUY1SGtha2dkTFcxemR4djNoTFBZcFVXVVN0TnJMTnVtck0vZVNzZFpV?=
 =?utf-8?B?R0NJbzBTZmhqbUJwR1RrVUFxNGpKYVFOekVhTDZsQmNCWG9LKzNobFZWKzFL?=
 =?utf-8?B?bDdzc296OTFzdUc2R3FZQUZURTVIQWVCSEdwMDhDSDErazE0OUdLV1ovTjd4?=
 =?utf-8?B?VWorTjR4anpEN28xNXZNNWFXdW5tdkc4ZWgvUEZwZlY3UWtOSXNiU2hYN2VO?=
 =?utf-8?B?N3FkTkhKY3F2MjdKZFd4OEp4dnhIZk1vOEhkSC85bS8wVDZOKzZBbUpNK2d0?=
 =?utf-8?B?Y3paRVVkaHZaLy9kczJONkhGUjN1ckpRck5YWGFKYUtDNG1yWEU3eWZ0NDUy?=
 =?utf-8?B?cUJBNS81eU00ZnFxWXpod0lybE5UcG1KajhDYjR6SmtFTmZtZ0hZZTE3eWlG?=
 =?utf-8?B?MEFwcVROZ2ljUTBUV3FmSk9PclVqWC9EZm51bHVYK3VTTFRNUmtZN29nYUhJ?=
 =?utf-8?B?bTdDdmFBS2xFQnVLckhIdHRVRFdZL1hwU0xHbVB6M1hlSnQ4QzROcFh2STI1?=
 =?utf-8?B?R0tSekpOWTZhN2dpSThkUFN0dzhYZC9jR3QxazcxY2dPMUR5aWE5dnZ1Ry9K?=
 =?utf-8?B?MmoyK3FHdnJkc1p0UUhVUHpYVzltUU45Y1hmNGJ1amJYVFRIRTVwVE9hbDZR?=
 =?utf-8?B?dDIxVUtwR3Z3dnErWXhtOTlwbWxpVEdmekNZTFFJaWxibE1LYVFkcjVNaWFm?=
 =?utf-8?B?WE9ibWh2d2VqTXZuNFhqS2tPckplY2ZDbVpneWJPSE1CLzRnTVg1VWhVSUhw?=
 =?utf-8?B?akd1U3FaWGRndzdXbEp0TEFiUlJCSHFZZGRUNDJDOGJUTUlHcVJlOENEdUtC?=
 =?utf-8?B?T3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GUKbF59cLic8aKtRgwtDYlL5ZeitbvY+75TJ01zVwtUawUQgpxCVS4Gi286mYr+7yQ70dzGQ6VuEPyu2GakZRH3biFG+ETxB0WlWPSOVT5mTDSrFQYwWsJ7LuSs7M603rw+a8yOha9nkIgx2t/LK1cE4kL+r0fMJfmJXK7eSz9pIp75NFLLpfwfHuzMisIcGe12rq/ANdVaUqQ5aGomrWWOu/KrZy8s/A+nu45ZIX75hAieszDTftZLLprubKRVNmOZwJefhNqjyS8iMb4sS752DGk8+IPbe0Q90qURjcspIXL+WfSgSvzhgpDgJMMvNbnZmBhqn5Z7HWz+isVlc3wVqCwYOSzGnk4NqLd1jHPJBtsa+tV2ZD3dqQKibR6+rnL5qqMvGkaQtChhDz/0GJxc6MQXu0fbs0DfuBweVnYX3fMKkUJtllEtk6fZnCg+dUJez1pWKw4b8ZRxXtRz0WHHum9qTElkjECZykjzpyCPNFdrucHVuUElnt2yl0sRf7x0ZsI9L5TfMLcmk1Ya3LKzfJV0ueBky/vdnM3dUw2nyr1lZ4xIVV4iznT4owxyhCU0fxejWrLNPJp6YEeyNWQ4swZi3p4tdwctpsDG38EQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9131c5d-a01c-4f88-2c8d-08dd774c82ee
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4318.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 09:54:25.7133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 036/7aLVG1YN49nb5Xphs0TqmuxBAME1D07nCDPy0b3PRNCFFbpmp00XOAdbpV0CP6aKZ+2e6OP+x/oETHlucw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8079
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-09_03,2025-04-08_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504090054
X-Proofpoint-ORIG-GUID: kyFYHRCmehJHn8ekZI9lxbDbQBM2xXEw
X-Proofpoint-GUID: kyFYHRCmehJHn8ekZI9lxbDbQBM2xXEw

On 08/04/2025 21:44, Catherine Hoang wrote:
>>> ---
>>>   common/rc             |  51 +++++++++++++
>>>   tests/generic/765     | 172 ++++++++++++++++++++++++++++++++++++++++++
>>>   tests/generic/765.out |   2 +
>>>   3 files changed, 225 insertions(+)
>>>   create mode 100755 tests/generic/765
>>>   create mode 100644 tests/generic/765.out
>>> diff --git a/common/rc b/common/rc
>>> index 16d627e1..25e6a1f7 100644
>>
>>
>>> +}
>>> +
>>> +sys_min_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
>>> +sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
>>> +
>>> +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
>>> +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
>>> +
>>> +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
>>> +    echo "bdev min write != sys min write"
>>> +fi
>>> +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
>>> +    echo "bdev max write != sys max write"
>> Note: for large atomic writes according to [0], these may not be the same. I am not sure how this will affect your test.
>>
>> [0]https://lore.kernel.org/linux-xfs/20250408104209.1852036-1- 
>> john.g.garry@oracle.com/T/#m374933d93697082f9267515f807930d774c8634b
> Ok, I can remove this when large atomic writes gets merged (unless you think
> it should be removed now?)

Actually this check is for ensuring that the statx for the bdev is the 
same as we get from sysfs for the bdev, right? If so, then it is ok to stay.

Thanks,
John
