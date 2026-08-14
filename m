Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDF43BE14D
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786716963; cv=fail; b=gRt90Uxi5iTyTAhyVFp8h34YdOf/9XnaVMiCSxDXGhiQWFBNhMzfMJBkyMYibK/nQLQc7KKI1iPQQe2J1DQVu7zUUlqvbivuvSooc+yf+ijoVB8/FbMurkbFEO3v+SZ7XHEvE2LPS7UJZvnKcP9QFLirctnvHMFUYt9NuSvY2Vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786716963; c=relaxed/simple;
	bh=CyUDaVpf/xKeQQDsrSFD0ZxDFpkIdF6ionj3vrzPr+k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gLA3z7DGW0cL5TlsXeV/Pa81X65arEeERYhsi6V6ku/25PIylFUdoAy5mdaphw/sCtydDwXecxnPZ1WeI4Al+CdU08CtD1oaX6I6uiObEI9Gzhnyi7z7SDJ0VxiJhsxjGKTXlUoUxPnA4PvCbsdXv/9QeNFF81YxXgv3xbZOgts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HLkVlk0C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wRBvA+gL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HLkVlk0C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wRBvA+gL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EDP50Z1667043;
	Fri, 14 Aug 2026 14:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3CilzluorDG6eT5agDEANlkDiZqR5x1VNYSB0BEi4Gc=; b=
	HLkVlk0CcAxZOVrD78oNF2LoBWkvcfXXCM342f5uhZL0MQT8uLKMfUT0dytwxsQB
	3b8AffuWFZ2fGD3TX+CjJb/XBilw+m8f5u+QP59sl+zyMIzEryLFqHUvrnWKOpjz
	YrI9BAPpUyjHfGKxTSBtMY9sA9VNkXgsdMGfic+9Ro1l8zN0SW/zYHsYqnijJmDB
	1meok0l0n0BC4RN0yPr+6etyZx/lvzau3tfUm3PRUsgjelI2KlJDqzfXvVPSYmEY
	UNsd+1fXbuP7JcEC5AD0OjOxFX7/IzsaCCIUT3WpdmO49WC0Q5p8n6+tOdn9X7Df
	0GcXoyZMotCDi7zJVj9S9Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fww0t4dnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 14:15:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67EEFcNh012305;
	Fri, 14 Aug 2026 14:15:38 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011058.outbound.protection.outlook.com [52.101.52.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwuay1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 14:15:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g/8NNsngYDg+gGCFdgVTXoeYedcGl5P7o0oaxU4vSxbUFWFYeyQcvyhl0+Dwu+v8j8jXrymSf7KQ8bDX6MWcPvkq43dSF/urr51sxX+PU4pcV3GltmtNUDxN6VxDg5fqiqNwD627slz56CmxbaB6BO81MYQbhBz5kSG3p5MGcRNFt+iPgUPGykOzAqvlRXOWvCm2xu6LH8J9rm1z103sR6PL/O1P4dsg41AtOOijtuHij8xt+QJM5sJWRsxmtEMIXHVnuXARdaFNWw0rHcieZtX66/CUAhIgEhpvkfQKf6P51Eul0HV0TNOh0tC2uiunU7ZM3kvyaqb62AmfDuoVxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CilzluorDG6eT5agDEANlkDiZqR5x1VNYSB0BEi4Gc=;
 b=lIQmnryRwReEwwyLYk+FM2PC15JqMkidODNOFG4zXrJPh3RUvQxdeuoiJxog1Le3mO863o9+yokZ4+rNiZlDcxHL9RNIDpiHM7Fehwmkb2EVs1cu8VLRdjAHBCVDDJTaj5CcG4i2kpIs1dRzSNWE2Dy088xXi6KIzLs2no6X+WUk0AvY8UG+81OX9/RmVA9UMRNO2l5Rv81j1ao7Qu6HB/Z4ACnmAWFWinPxlE5obysqk0ZNG5rq7IdLBFLWgaKPxhmb/MDXY27sk08bs8eHbQ/m8VnNq5YW+CLA/EIY19m39UHPxIhWPJ3rCBxsBaB/5FLcYUInDNnl5vACWs0EPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CilzluorDG6eT5agDEANlkDiZqR5x1VNYSB0BEi4Gc=;
 b=wRBvA+gLnq0OOno1wfQI9rquUaiFimj6NeGqxr3NK4geASSobP5vCubPaEL+KP6nRAWnUuAFxRzo/LZLVHPO/yae2UX9PAh8ZGO3iMW9rfLpgZn5Ftts7iRbUQETnbhkhx1iwznndKgk0RSfs8ePqQ2GII0LH/L/fKxrTArD+so=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by SAWPR10MB998087.namprd10.prod.outlook.com (2603:10b6:806:55e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Fri, 14 Aug
 2026 14:15:22 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 14:15:22 +0000
Message-ID: <8e58b1e1-c15a-41df-898a-3725d920b486@oracle.com>
Date: Fri, 14 Aug 2026 09:15:15 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [PATCH v2 3/3] xfs: incorporate increased AGFL
 min requirement for minleft allocs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Cc: Matt Fleming <matt@readmodwrite.com>
References: <20260814132239.271492-1-bfoster@redhat.com>
 <20260814132239.271492-4-bfoster@redhat.com> <an8e1YgRDysYtlgM@bfoster>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <an8e1YgRDysYtlgM@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:610:b0::7) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|SAWPR10MB998087:EE_
X-MS-Office365-Filtering-Correlation-Id: ac30cac7-5156-45ce-3e5d-08defa0e7753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|6133799003|56012099006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GX5HeProToWAMN46MyYe6DS/euR9AEzpt+i0hQvoR5qnQmd6Kv02CrpbNJiP6QnmsDwqA6E8HKSxfQRZBfHbNoSZGC1+7+FlNzFdugXaMLb9aQlFSmKwXH/M09/Uiy2otAPnMaamkctTG59BTnd7l0hnHj1VePte2/mEQKPZJtKVLx326pC/Q7S+nTbMc1Yq1Ma64RA7Gco+E6C3/V6tzQ5e57U5JMJaIT7jzNSWWAkwsnCRK9lIOJXwxEIISznRDqST16Ty97qFkJwwsyjxK2ggN5C1bbM/HhCjj77Bi4W23t3xvQqFNyPTMcJG4qSyGrvu1XO2+Ab75bAjxVLPnve8S7ihL4Tid9+0nbNchyU92Tc3oLjBd4eWDgu25tNxRsM2p3kBO7avU0RSKIJ626ohn17lOgNlC9BZx8JhsvYlodwgkNlB0T5iU87wY0vvL4z1GicpvyYrzXBQOf/k+EHR3GDdSNQJNDfMGAh1GznN/vdOJ2Z239aOBWiY+ygO6tlFay7VZndANQE2KjOZhm2Q5egM77IEi1jxXGv11tiIJmWbBVDjf2TgJl8pHwXlB+fcsvJ5m0ZYoiJl0ttqkHtAgYZpnvIQyxmFjlqXpPef6kZNLIYuDzvTl0UaGRCc7zAIHAyfnE5owaT5CHCkkhofJh8Dy6om6XMcOpggVGw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(6133799003)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnlNRVlacTh2bDgyQ2pmbEFlNHdURGpLcDJxdjJ3bDJ0NFNMUXJ2M01WNGVD?=
 =?utf-8?B?N2FnWEZvaUljTUtObkZoZVg1djc1UUFpTHdYWU81ZGRKVnNQQ00yenVHeEUz?=
 =?utf-8?B?NVR5MmRaY01DUWpyMndpNGpSNTExRFlLRUV6L3JSK0FtQlM1REVzdkRwUmNn?=
 =?utf-8?B?Q1R4dmR2Vk9TbmhKb0pMc0tkd21OTEwzOGYvMFkrM1oyZ1hNL2x3YUxBVHQy?=
 =?utf-8?B?Ymx5MkdURDFWZXhjUzBqTVNIUDk1RUlJL0YvemJmWWorMTV2MkJ4NkNjSFE1?=
 =?utf-8?B?NlZPbTVqVDdPem1URlV5RTBtUWFpQ1R5WGFFUWxvVHhkVmRnT3BBbFZQNnpV?=
 =?utf-8?B?UGJXUjNqSXVHcW9Fa1RUZjgyWWFKVWhuYlZIMGQ4RzlaRHF0MzVxVDNxY0tp?=
 =?utf-8?B?cHhTM0ZRaVBtUzlJNm9xYTNESVd2UU9IeW1yV0JENUx1VDJBWmJZb1dVT09q?=
 =?utf-8?B?bTRNMDBQTndCWUpLRjFzSUUvZmdCb0QrMlFZQjh4dlNWa2lZUHh1bkJ0Y1RZ?=
 =?utf-8?B?Z3ZrQitPaDBZQ2YzUEU0M0V0TUp2L2FjT0dIV3BaSUhOaGdMMERoMldsQ3Vj?=
 =?utf-8?B?MUpuZEdrdkVFamRNS0l3dWZrWFp5c3lxM3VRWHZIaEw3MDV3SXV4bmVxYUVC?=
 =?utf-8?B?cXhIMXozbFBkeFRFdWhvUjNMUkdKSWFld0JYQ2tENUtTdFQ4bUFjV0JtRGZR?=
 =?utf-8?B?T245WHZBZkFnaXNrWmZEOTdrZXU0MlRhWWw2K2NGRDBqcEZyTjdMMmhwakxi?=
 =?utf-8?B?TTgzZmduWGhuU1pVb0QxZGhIeHNuTVN6Z3Ftd2lBQ3UzNzRCYmsvajR6ck1S?=
 =?utf-8?B?cTVFYjRnSHpXT3I5TU5UU0RGN2dQazdwNzNmN05LNVNkTFNSU3BpMVd4eE4w?=
 =?utf-8?B?NjlHUnprMDJ6VmFUYTBPaFc0VHh1Rm1NOTV5UEFnR2Y4YmowSXB5Q0srN3Vk?=
 =?utf-8?B?VzJVdFNIRWdScDFreWVHVEVxTkZZSmVka24xakxMTDVySHprVHBOK1lJYjdN?=
 =?utf-8?B?Si9wekVrYTNLTFNHZVp3NVhhY2RzQm5lVTJHT1hQUmtyR1FuS04vMXZLb0hh?=
 =?utf-8?B?VmNySm5kYmJqWHVvNW1JSVZWQjQwWko3Z1pRQ2xiSGRLbUw2bmRtM1EwMUFZ?=
 =?utf-8?B?NXpnalNLMHIySlVsOUl5cEorVG1NZWZFcjF0MGZTM2pGb1RoMFl3VytVRWhl?=
 =?utf-8?B?Qjh0VHMyK3U5ZmVBU3pZdVdsYXpjdnE4MXQvRENsbXZVTnZJc3RSRDZjQjFz?=
 =?utf-8?B?V0F6UXhvdU5pU1ZjWk93Y3ltdTk5V2hzaGljVjA5akE3SXN1Y3EzeXJ4Sjha?=
 =?utf-8?B?aXRoVm9nR0M1T1RZcU5pVHQ3SXVGMjczWWtqbGNQeTB4enMrWGxrY3VVSG9C?=
 =?utf-8?B?d0o3RlhEV0JaR0wrbGJURGdRU1NKZVlvUzlIMWpwMDI2ZEVSVHB0ajdieXpX?=
 =?utf-8?B?TjNXNThwaWkzTytoRkR1eFY1VmJZTlpHKzFnYVNnV0JjeVhYQzF2UnVKVmZJ?=
 =?utf-8?B?amc1WTRSV2tzWlJrSkkrenVudThQeXRna1JBWENkV0d1MHl6WUV5Unp1R0py?=
 =?utf-8?B?OEV0QjVzWUJrUlFOYkdBSnlVcWpySzJFVzFzM2h6NnFmbzVaUng5T1BBRnpi?=
 =?utf-8?B?TE82TUc3Nk5MZ1hQSHMyZXVaa0phaXlSUzJpdFhpaGY5VzYzS3hxZWRuVVBq?=
 =?utf-8?B?Tk0rdWQ1NmNMMVoveE1yV3k3K1BzdVAvblhiRlFBQ1c1VFg5K1pWZFU5NUdY?=
 =?utf-8?B?NXoybndmQk1RZkp4NEZTNDFVeVNFdkVlTkcrVk9LbDF3L0xGZWNkTnJKRUtR?=
 =?utf-8?B?djhYblhYR3NzSk9wZExqR3o1MTNONzl1dTUwSlpWMjFDVHNZeGJUVDJXVk5i?=
 =?utf-8?B?N3pBMXlCVEU4L1VNQU1qcjRENXgvQ0EwVVFZVjQxUVhHaTZsNnN5QXQyR2l3?=
 =?utf-8?B?dDZXck9RazRWclE4cVMxbzBrS2xCU3gzd0hWVGY1RjJuSnByYmlQREI0QmRp?=
 =?utf-8?B?b1VlWThNcVErQW9nOHlGdDBIRUVRUEN0RERHZkVXZ2NoZlpSYzJVK1k1MTAr?=
 =?utf-8?B?SFl6Nk1MYk5mQXlFTTVZdEZSRnJqcVpnZnVlcE1neDB1RUFud0Zzc3Y2MFM3?=
 =?utf-8?B?MGdUSGRneHVUNlNONEF1aXFXT1NOaDROQndJMG1NUVFVNFB3elE2VlYzL0ZJ?=
 =?utf-8?B?dFU4eDFkdk9SKzVweUhpeHNZQmlWRFo0cVZnMElXUUkxTmkram9tdVRzRGdt?=
 =?utf-8?B?OUpTUDRvN0pOR3JvNVJmV3A0VDhqSlhkS0tpbjRSV2VSTC9UWTlOc2lTZTZl?=
 =?utf-8?B?TkpJM0NxUXNiQmF3TXRiWmpHOUNhWEE5ekRWdkZEbVJSMVNBRXJQS3JpaXhE?=
 =?utf-8?Q?s7wG3vO87Tq4qcZ0=3D?=
X-Exchange-RoutingPolicyChecked:
	c8/T7+sYtp50xwtyiYI8H0vVwPcaJGAoooy2yrmeRNaWm1o72yHOZquL1IB8XimLo5nzIpNG7G37pnDZoJOyacJjSo9TEnTIL1jToXnoF14pMgrxGTTnF7EeJtiiZ5TS7sBtbs93p4+oaI9Do27AfhSYZaJH0c/oopu3dCjBqqyyKX3HnuOY/LeWt8FYwVvfb6pfi9YbP5nnATCsx98I237X7reVuqXlSIqgJgxlIWdsbLtq0XRftMAImrWa49fVVuYWWa9Q0ctueFv1BOu4Tc+INHPoj5xETVsjcAUQolF3wR8rUt77/r2W11NH3JL2nn63NG2zBOEcToCnleLspA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9DXuph7ohM8ufGsMh8PZVQHudZwM5E/mG2pNuunS1jo43bYZvACZpEPhodHEr0NUFmo8H8HlFg73DyZDzwVGlBPU7dL/KOckvI9wiiatj3aXDdkpATX99/pUUrfY90QsG4f7AFbQA/Np9acvdb+d4l7YMpaAqEUUIvqLaRX2k0+dgPE+aEa4eCTy+PjK9aYLHMMWf/OHA0hwcJ5XYQjBEzUDW3rIHNcsp5Mg0elEB4zc7W9dA9GR48vjKdCpN+92W/4cFmjzMUPPKvIAWbiCIC0BdZegnr0hhmCqtKars5uk57kcY1ZEnnIuL4dPAWUIwDi+PjB3JuhU780XCKqn0zrXX0ow4ALgvyL/TyEYCpGCCMFsSFronZdvH7vm6U3UMdcgXLRYZMADCj71f3wt08jvB3aA4YJ2PuhJZ6tSJgCXdxY9pAxVYh0omVGOfzWMD3e1e8LZQ2gbsPO8Z90SYJIvVMtX1twAQYWOKk+TkxajUM4Xk8+hVJ/XRsng6c7mANTyHs0aZIoOkcaT0kguX9JDfkmdURQrl6p2gYPVG/B+zlHBXfGW1TFELgYiNCDZN63m/PH6IW78dqxa9/eemoQQjBfeYbw5kquWGvoImA4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac30cac7-5156-45ce-3e5d-08defa0e7753
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 14:15:22.5112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SyCjnFC2D6iipmN751+1LHiQc4FxPaE001ayc+7GoxsXkY1ia5FoFiWJ5vYIl48bez4oyNgFN/hDr2gMB6Zt/NIpToZVjTPMdPPO2AQKEkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR10MB998087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608140109
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEwOCBTYWx0ZWRfX2kpHiMyfv4XM
 IXTYZMxyBd2/1hzoT6uCJBmgr+TRVSn3KfLfAteu8VAvcTCvBAffioKhebuYZeLqsbQPpHu98mD
 /uQ0pfaXsSG6wK2DnzEWoa9k5QK7WfAXAqJmKEnP1qVvefA8CnRG
X-Proofpoint-ORIG-GUID: C1MB-zV1CEOOf9xyDQjfqG0yxr6fI803
X-Proofpoint-GUID: C1MB-zV1CEOOf9xyDQjfqG0yxr6fI803
X-Authority-Analysis: v=2.4 cv=FcAHAp+6 c=1 sm=1 tr=0 ts=6a7f230c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=vjukTtsuAAAA:8
 a=20KFwNOVAAAA:8 a=tcgzGAmXBP2AKBCbsi4A:9 a=QEXdDO2ut3YA:10
 a=pxVR4CkNEMOefyUi7ZpQ:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEwOCBTYWx0ZWRfX3/5Hp/M5p7wm
 JiIlawVLb8eCWhyDj9du0VF71UwPz1y2aCYFXt2k3TzAOa/EI9q5Y8SpgrvtdrmuqJKAEscaxeT
 Q47LfnDeMnkZbAI20zlDcQqyxcqfbf9OBqmN7lSHsCHFDVu1JDw4P26xE+j2aqTWe7L/F4XMjBT
 zRoi8fn2LLTAxWDiLDp23zXLxE6Z87BmBbgqQbCkOAkMsm2ZoH7bfmylQYkRTVdZdkLDcLupnaR
 SD2rGF7Lyl9CT0YI01nCRZYBwAQdPKpaV61z+/tkMAy8MMaWCwqXP81Awg6+UlP641Et2Yl7l92
 nz68H8CmI1LHJ59twYoYlV5xES/OUrKoW27dFORfPGdQeywWFwduiGm5OFT1zn5+b5Xp2CVJ/3H
 KC47Dw65JgCHvXd/iF2KcKus7THs5iWOzSREqdrfZdt+icvgeN+5G3O8HVBTOpy3hd1fNRGOaRJ
 YMqPAtq6muABX6TWnpWjgCYC/4FR1MS7TNVnuZF8=

On 8/14/26 8:57 AM, Brian Foster wrote:
> On Fri, Aug 14, 2026 at 09:22:39AM -0400, Brian Foster wrote:
>> Matt Fleming reports a filesystem shutdown due to inobt block
>> allocation failure during sparse chunk allocation. Inode creation
>> can involve multiple allocations in a transaction: the initial chunk
>> allocation and inode btree blocks via inobt record insertion. This
>> is expected to be safe by using the minleft parameter on the chunk
>> allocation to guarantee the selected AG has blocks available for
>> a followup inobt insertion.
>>
>> The sequence that leads to this failure is that the alloc and inode
>> btrees are all full (require a full split on next insertion) and the
>> AG has just enough free space to satisfy a sparse chunk allocation
>> with minleft set (i.e. 7 blocks in this example). The chunk
>> allocation splits a free extent, triggers full allocbt splits, and
>> consumes 4 free blocks for the chunk and 4 AGFL blocks for the
>> btrees.
>>
>> Next, the inobt record insertion triggers an inobt split. The AG has
>> enough free blocks, but the allocbt splits caused by the chunk
>> allocation have increased the min AGFL requirement for the AG due to
>> btree level increases. The AGFL requirement as calculated by
>> xfs_alloc_fix_freelist() is:
>>
>> 	free + AGFL - res - minfree - minleft = avail
>>
>> This evaluates to the following on initial chunk allocation:
>>
>> 	2514 + 8 - 2505 - 8 - 2 = 7
>>
>> ... and then after the chunk allocation but before the inobt block
>> allocation:
>>
>> 	2510 + 4 - 2505 - 12 - 0 = -3
>>
>> This causes the inobt alloc to fail despite minleft being set in the
>> first allocation. The error path cancels the dirty transaction and
>> shuts down the fs.
>>
>> The problem here is that while minleft ensures free blocks are
>> available for the inobt insert, it is not sufficient to cover the
>> increase of the AGFL min free requirement. To address this, create a
>> variant of the AGFL min free calculation for minleft allocations
>> that incorporates an additional allocbt level increase.
>>
>> We do not add the additional blocks directly to min_free because
>> this would lead to spurious AGFL block allocations and frees in the
>> common case (i.e. no btree splits). Instead, add the surplus block
>> requirement to the minleft value used to select the AG. This ensures
>> the AG has enough blocks for the caller's minleft value plus the
>> worst case increase in the AGFL. In the example above, the initial
>> calculation now evaluates to 3 blocks available instead of 7 and the
>> sparse inode allocation fails gracefully with -ENOSPC.
>>
>> Reported-by: Matt Fleming <matt@readmodwrite.com>
>> Assisted-by: LLM
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>   fs/xfs/libxfs/xfs_alloc.c | 29 ++++++++++++++++++++++++++++-
>>   fs/xfs/libxfs/xfs_alloc.h |  2 ++
>>   fs/xfs/libxfs/xfs_bmap.c  |  2 +-
>>   3 files changed, 31 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index dbb85fb6314b..74c5b587c87b 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -2500,6 +2500,20 @@ xfs_alloc_min_freelist(
>>   	return __xfs_alloc_min_freelist(mp, pag, 0);
>>   }
>>   
>> +/*
>> + * Return the minimum freelist requirement considering a potential allocbt split
>> + * from the current allocation. Use this when computing longest free extent for
>> + * allocations with minleft set to ensure that the available extent length
>> + * accounts for the subsequent allocation's increased AGFL requirement.
>> + */
>> +unsigned int
>> +xfs_alloc_min_freelist_minleft(
>> +	struct xfs_mount	*mp,
>> +	struct xfs_perag	*pag)
>> +{
>> +	return __xfs_alloc_min_freelist(mp, pag, 1);
>> +}
>> +
>>   /*
>>    * Check if the operation we are fixing up the freelist for should go ahead or
>>    * not. If we are freeing blocks, we always allow it, otherwise the allocation
>> @@ -2517,6 +2531,7 @@ xfs_alloc_space_available(
>>   	xfs_extlen_t		reservation; /* blocks that are still reserved */
>>   	int			available;
>>   	xfs_extlen_t		agflcount;
>> +	xfs_extlen_t		minleft;
>>   
>>   	if (flags & XFS_ALLOC_FLAG_FREEING)
>>   		return true;
>> @@ -2533,10 +2548,22 @@ xfs_alloc_space_available(
>>   	 * Do we have enough free space remaining for the allocation? Don't
>>   	 * account extra agfl blocks because we are about to defer free them,
>>   	 * making them unavailable until the current transaction commits.
>> +	 *
>> +	 * If minleft is set, this allocation might cause an allocbt split that
>> +	 * increases the AGFL minimum for the next allocation in the
>> +	 * transaction. Reserve that space from the available block count
>> +	 * (without prematurely growing the AGFL) to prevent the subsequent
>> +	 * allocation from failing due to an increased min_free requirement.
>>   	 */
>> +	minleft = args->minleft;
>> +	if (minleft) {
>> +		minleft += xfs_alloc_min_freelist_minleft(args->mp, pag) -
>> +					min_free;
>> +	}
>> +
>>   	agflcount = min_t(xfs_extlen_t, pag->pagf_flcount, min_free);
>>   	available = (int)(pag->pagf_freeblks + agflcount -
>> -			  reservation - min_free - args->minleft);
>> +			  reservation - min_free - minleft);
>>   	if (available < (int)max(args->total, alloc_len))
>>   		return false;
>>   
>> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
>> index 50ef79a1ed41..026b61a63994 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.h
>> +++ b/fs/xfs/libxfs/xfs_alloc.h
>> @@ -73,6 +73,8 @@ xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
>>   		xfs_extlen_t need, xfs_extlen_t reserved);
>>   unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
>>   		struct xfs_perag *pag);
>> +unsigned int xfs_alloc_min_freelist_minleft(struct xfs_mount *mp,
>> +		struct xfs_perag *pag);
>>   int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
>>   		struct xfs_buf *agfbp, xfs_agblock_t *bnop, int	 btreeblk);
>>   int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index d64defeda645..f396df864cf4 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -3160,7 +3160,7 @@ xfs_bmap_longest_free_extent(
>>   	}
>>   
> 
> I intended to add a comment here but lost track. I.e., something like:
> 
>          /*
>           * Use the minleft freelist helper because minleft can be set for bmbt
>           * allocs. If we don't factor it in here, the alloc can be sized
>           * incorrectly and fail.
>           */
> 
> I'll wait for any further feedback before reposting.
> 
> Brian
> 
>>   	longest = xfs_alloc_longest_free_extent(pag,
>> -				xfs_alloc_min_freelist(pag_mount(pag), pag),
>> +				xfs_alloc_min_freelist_minleft(pag_mount(pag), pag),
>>   				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
>>   	if (*blen < longest)
>>   		*blen = longest;
>> -- 
>> 2.55.0
>>
>>


thank you for the comment clarification.
I was confused by that change.

Could you CC stable. We saw a version of this problem in Linux 5.15

