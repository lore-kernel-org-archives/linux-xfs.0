Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4BFBE6C;
	Thu, 10 Jul 2025 15:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752161368; cv=fail; b=bNQwyirUGgtcMQTvZfi36weSeQvTBSjPVRmU0I2810vwtzRg++6C/bpMSwzBJFQtwobUKiGzIaIA8M3Lkgif2JB16vbGQuZGRWOt8lZZomJmW8Gpy9WlTMHH8D52KunjOKxGkVjT6CSQDxqYa1BVxLLNfuw25n+b8XsWBI/8ZdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752161368; c=relaxed/simple;
	bh=rJAW8/6OTg+OvcdPAXG3qjF+vd+53SDYE67CAKSCP/c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qmS30sM7FVFDMz+VTW7yvf+lluskQKgn+3eM2e0zLLuy9IEdCdxUbs9ue1ja0Su/ngyKLq7/vkb3XjgMXu+Hv5gfcayRUhvAkqAM63kOG3NX0DgwFlMbnFf5J0HUbf0Jwx8QCdBUsK4GCgeW4N3CEpL+mj8Y0xR8TFKMcyHxcww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jLnRjKEO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l6ZOkcsk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jLnRjKEO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l6ZOkcsk"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56AF7R29008448;
	Thu, 10 Jul 2025 15:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DJgR9r6QM1wA+Etv5lEaQuIf9zcfyuvskupdBI6CqUo=; b=
	jLnRjKEO9DT8hKt3QmsbLR9zXFh1zjXJnoYMOzf47KybW9LKksh5ZiGB0s9ycER6
	G8g2TN5+eNSuLqTcke+O+OgvJDrq9LC5+THR9F7QxREE1Uwzsxh9ez8p8nLuJJCf
	owyQzDSGGFuOE1M2nWhVsKWF1WUr3eJVtJTomrqarONSPvnEwKXHXaEqCynWVHCa
	DpUxydUdlVLe/n8kJxxHAWTivRmdYtBBVevBC9ZTZubQ42Wdw9jaAM8lSkHQLR98
	4zbE8SB63DACHi7Y3Bt21GMHpuMZ6RG7juSiMd7qkJAc2Ehd6vmk+1L/4uzIXgzv
	T3SFHIzSMdHr7NeZ9bO4Tw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47tfvd01mu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Jul 2025 15:29:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56AEbNiR040469;
	Thu, 10 Jul 2025 15:29:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgcnq9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Jul 2025 15:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkQKtx90B9w2iCYkzJt/DfXawYPoCNOvqQaOqA2CjBwm2zYYXG60VJdylZSmydRqzJpc6Qtb9NekyxkTF74J/rcA35Drfw1gzcEYCZqmksSDHby/jFTDxbSbuBkhwE0Ib65U3Bzm1j3Z/YZbSHS2P9FVoRoEMfGuUiR2XrvapuickscUrHHTMncTcSf5uVLaxBHOWnXOZ7Y393NNLTM5R0sNBhs7F+BHPBhr9lgjqQc7zPgpf/mZwgAFJ4bT1JGY5YWC5X7bOKrVBIZ+t7vhf9KbJ3rVWmjhABcOBr4pm7Gi3FT+6iLA4LrrUuHUT1PKyaF8xF15mFOpLWecpenDyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJgR9r6QM1wA+Etv5lEaQuIf9zcfyuvskupdBI6CqUo=;
 b=Y7GRA53VE84aKPQZZjbdqUPVyPUrWv519rZO0780JeUW/xMgO3E5uQmISR0UAP3O+0PdwFswDgWO8UMXTCmgpnx+cE+VLx5LFvvAJhCGxAiRvhPtjzjSlu8nnzSN1GhXT/VTStHzApddALpvFHBtRgw/PB9VxQvmE29wm0jZJxioxPw2zCAL2CJrsijZ706TW4XBs/+Xgc0e1JGj3WcVXQ8XtKq2Z81enZ319N/ilEc8ga4na0foHdh+EmWPlAvAHWgFbGkwzM3HzA7tuAhbg+1pIb8U6UrgStczJUR6YRw7TPp5QjsgNtF5fSU/QadERchav0ZvqlwGW+2+vMgJ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJgR9r6QM1wA+Etv5lEaQuIf9zcfyuvskupdBI6CqUo=;
 b=l6ZOkcskJBKA9B8ltmDUsb3wAJ3H4BeaUiXgsL8wEtcxtun9IEAYno7vyGfuu8lALDfXrgzz7uIaqFbr0dPRbPZPQs/QqACBINbLS2eDibetIY3xmfcB7FHeqDb8EHZHLyE7t+ndyQUK1eNTUthI88hLkzKKc6tiWVX86QuAmc0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by BLAPR10MB4996.namprd10.prod.outlook.com (2603:10b6:208:30c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.22; Thu, 10 Jul
 2025 15:29:05 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Thu, 10 Jul 2025
 15:29:04 +0000
Message-ID: <54dc7fac-0e79-4ed1-bb7b-54962441b2a1@oracle.com>
Date: Thu, 10 Jul 2025 16:29:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/6] dm-stripe: limit chunk_sectors to the stripe size
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, song@kernel.org, yukuai3@huawei.com,
        hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk, cem@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org
References: <20250709100238.2295112-1-john.g.garry@oracle.com>
 <20250709100238.2295112-6-john.g.garry@oracle.com>
 <5e2bbd34-e112-c15a-37ea-f97cbede910c@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <5e2bbd34-e112-c15a-37ea-f97cbede910c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:208:136::28) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|BLAPR10MB4996:EE_
X-MS-Office365-Filtering-Correlation-Id: 54fac97f-1f85-4531-4d73-08ddbfc68119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1FXcC9JcE1ycGg3QnFLRWFKbzdQMkhONWJsdXB1YjdIazd0bXJnRlBZZHg3?=
 =?utf-8?B?STBtNFQrQ2pWRWhlMEZuSFBvT3pTT2F3WnVDRHdDVm9kb2M2bWptb0ZTbXF5?=
 =?utf-8?B?Z0pJcGI2YTlIaTdNSnk2dlc4SDhpMmNkVmEwdm9yOVcvM2swNkxRS2s2eDBk?=
 =?utf-8?B?cHJ0d0pXK0N4Nk5rS2drbStXZUJCU1VuSDk3VW9zRGhSRnJkY2FQTS9xNUIw?=
 =?utf-8?B?ZEkwSnFUMGE0Q3g2TUZYOHRjYjhaU1BoOTBFZldPelpRSUNCYWhhQTlBTVYr?=
 =?utf-8?B?anBVSXBvN3QzM09pc2F4VWFlQWZlZm85SVlRZDZhVUtxaStCbjhJUFNnMjJK?=
 =?utf-8?B?QUlIL3JVbk9TS3l6QmFsSi95RTZmT0lhcGIzWHQ0cUdJRGlRWndoRXhMK1Mw?=
 =?utf-8?B?L1BtWWhiNW44NW5rbk43Y2hZTVpDVE9UVlh3US9IOC9nbkF4Q1ljYU1ha2RD?=
 =?utf-8?B?Z3RKd0NhYUowaWRIeFoyelZ0M0NLcGxOYkMwUW1tZWNaVlJ2TXl1d09sWjRU?=
 =?utf-8?B?RmFaVlNib09Iei8wU3pKbWFPWFFIOFRrWENnNHJreGRnM2NSWkFod0xsT1BX?=
 =?utf-8?B?am93ZjNhR3p2QlZ1SGZFcGt0VHRxczlJSWNZOStjMzdUZjc2RWE4T25YNGsv?=
 =?utf-8?B?QkdBUEc3YWdJaWkvZ1kySndMY1NaR0Z3VzRWaFA2M1lEano0SlRKMWVKV2I2?=
 =?utf-8?B?cVprYjhqUU9mTHFUbmtEZVp5cDR1RzNGM3Npa2VRY3BiZG9Id25CeVRaRXpO?=
 =?utf-8?B?NWNTemJIaE9xTVJVemMzVnZ0MHF2L3FHeWdXMHpOMnR5S3hQTUYxWk5FUnJD?=
 =?utf-8?B?ZFJneXo2YlVwaTMvb1lncldYbVl0eXN4NVFYclpaZHB1TUpEV0dzdGJFMEVK?=
 =?utf-8?B?bEdvSjhmTEM4WnpXYXpzTEdoaDhWYUhlbmN5bUo2RytRNkk4Q1ZtOHBuV1JZ?=
 =?utf-8?B?aFQ5eUxZVkVJa3B4N2xRa2U4MGhNS0UxMjlGVVZ2VGg3NE1iVWJoaFJIUjBT?=
 =?utf-8?B?elF4MS9rZXdDK2pOVW9yRWhyOWdCV1FPNG5nckFOZWtzQVVhdm9zclZiS3JL?=
 =?utf-8?B?cWFHMENLQy9pT3pWYVBJYmF4a01KOVZZQkFzeWx2Q1VQQ1Nla3NiRjVBU3l4?=
 =?utf-8?B?TiswTlJuVzViaDcwN1hkVWg5QS9wRXBxa1ZLT2grUTNHN0tUem5RWDhpOXlr?=
 =?utf-8?B?MXBoNU9jVzlCZjZlWWx5SDFhWHZyNEFnMWxBa1lweFE4ckNYdTIzQkd5aEZ0?=
 =?utf-8?B?VUhlVG1UUlk3RmFRYWUreXYyMFRWeU1BNkZ2UE9ZcE5icENQejNFWi9TemxT?=
 =?utf-8?B?Qnk2amZOZWlVZ1B1MkdJK28vNHFUenE2ZS9XODJsL0ljaWtDUVRxMWlZWk1C?=
 =?utf-8?B?eUx3Nkt1d05UMWVKY1U5V3VZSFlVVmdub0Y2Qkl1NER6b2F5QmFhSkhwVHNV?=
 =?utf-8?B?bGFOQU50SUxpd3g2R05TV2lHV3NCTnZLYUNQdmtoejZaK3paR05EMCt0ZEYz?=
 =?utf-8?B?R2NKUmRuWm9FSVU1RnM5c0pUMStraGdsbW9pMnA5MEdWTnppM2VmQ3dFSHBM?=
 =?utf-8?B?T1A3OHZSQVZBdExFZWJ1VzR3NlNXbUxYWnF2N3JNZzROaCtqMXRhQ1hkeGli?=
 =?utf-8?B?L1BjZE0zbFJVTmJJbzNJSUg0Z1VJcVhObjdkakppcmlWSFpmSkZVeTlGS1BR?=
 =?utf-8?B?MHpTVWpFY2N4Z0JXa2dKZ2xrWSs2alVTSkoyT0hmMW1zcEJiVVNIdW4xL3Ax?=
 =?utf-8?B?NVFNSVowbHlmVFRzVjFaMEc5dGNoNWN2TlZtTkRidlZQcU9kSG56dVp4Kzlz?=
 =?utf-8?B?MkRRcThSQmdVcXVsMFZmai9RZ1oweDEwdW1EQkIxYmZmWGxQMEpSUjBsVHR5?=
 =?utf-8?B?R2ZPVVN6dzhoeDE2NnpQcjVzcERtaitmV0dzNU5zRHZtWDZ3OWxrVkx5enhW?=
 =?utf-8?Q?R+CQD3yEMKY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QXNDUGlKWHJMRXVPTCtSUk9JYjk5ZVZwak5Za09xVytzdUVnYmNVYk9aTEJS?=
 =?utf-8?B?aVhUVlJ2c280cHFQZlZybEtUSm1qZHN1cUNlenYyVkVRNWhhaE12VTBkTjRK?=
 =?utf-8?B?eFR6OGxRWGhIMnRpOWJEVzI0L01wTE9yZENrRmxpMStUUDMrOXFvZmxuRkNQ?=
 =?utf-8?B?K1VqOVJUV215QXR5R0hYMkhtejhNOVJEbGovS1I0OU1mZ1BQOHF2emNQdjFi?=
 =?utf-8?B?SnNDeHBjN3A2SnAvK3YwSVNVV2ZsbGhYVzJGWFF0T2g5ZWRTczFYamdwWmdL?=
 =?utf-8?B?cmxvVytlUUpjQWRVUS9mdkIzVmhMdEFiaDRaNlFkVkNQbGkzOXUrQUpyYkFh?=
 =?utf-8?B?aUJVS3IyakxtemRoUHdSVTFIY0Rkdk5iQm1NSFpHZERsZmgreS8xeHFSck56?=
 =?utf-8?B?MVV0bzQ3c0IwekdxSi9ldFBQdzlEK05hM3NRU2hSaUFCeUdZU3F3bWZacVhX?=
 =?utf-8?B?blpmcjA1T3BkTCthcVB2OU5MOVEzY05ESlVNU3FQaTYwUDQrWGJpdWpNUElo?=
 =?utf-8?B?M3JKaURKREJKc25TcWl6ZHVPS29TOElXM254dUsxNXhxd0FGeWo4d1oxWldY?=
 =?utf-8?B?c29iUVBENUtSTzkyaDZOSFVneCt0bjFvczV5bmw3K0xMN2tXUG9lNTdGZzgw?=
 =?utf-8?B?SVFlSzB5NmhmdHZqTmFQUitqUzVjN3VjdXYwTmJXR0REUUVBTUZCb2orbG5H?=
 =?utf-8?B?ZFRqcmJMVGprUXVJTktqOFVCSEV1dURzVGZVMVZ4UkxCRVg0aG0xTlZDSGts?=
 =?utf-8?B?Z2RZcXBjNk5UdUZaQkpOWnlCVlhuT3NMREtlQTljOS9hY213K3Y1ZDJGN002?=
 =?utf-8?B?R3kzZ1NiRGVqRnR3Z01Ua2xjRm54d2lwT3cvc1c1VTR3U1Q5OE0yTkR3dVo3?=
 =?utf-8?B?VnNUVE9FWkI1ZDNFamdua2hFbFFud1c1SUpVcW5DdnN5dnZpUzlUTWdVcTVn?=
 =?utf-8?B?Tk9XUy9KclRQdGlBUFl2azk3S2xXbHdHdGM1NVJkRUltL0pIU1Bzd3NsQ3Iz?=
 =?utf-8?B?RGlnUzJ4YTE4MEc4amlKUDdYSWJrY0lzUUNmSHVWWlhzSno2Q255WVFVa3Iw?=
 =?utf-8?B?VGJQRFREOE9sL1VRRXpOR29TVTJNblJ3bm11OWI2VWx6UksxUmlXM3luSStx?=
 =?utf-8?B?T014ekpWT2dMYWEzcXVpSGdxbllkaUh6T0VjeVVNSm9QR0VGTldnZWgxRmYy?=
 =?utf-8?B?VnM5NmpBWWllSFdKSW1EQmlJczVuNkVaSWxRcXZEeUZyZlVTWThPbEdjZm9R?=
 =?utf-8?B?eXg2WXhmNEU5azZBQTNaV0Y1Z2t6ZTVDR2J3bHJjS0E0UEZSRUhjaW0zaHY1?=
 =?utf-8?B?c2Z3YndsM2RKTWlRK1Zjek9WNHlyNEVEOWxGRGIrZXV1VkgrZDkrK1pUTXNy?=
 =?utf-8?B?ZGxJK211cjZvMW9oZGdlOTVjT1NFVzB6WGZjbjBpNWUxNWZlbWE0QlRDNXNB?=
 =?utf-8?B?Q2pHd05admZJQk02dHdKbFBiR1dmNVpwWENZUXlLU1l3SDgxWFZIYW5VR0NC?=
 =?utf-8?B?QmxaM21wU2hLb2t2eVZUQ1h3YnM2Qnp2R25QVnJuQUNxMXdyL0plYVIySkJT?=
 =?utf-8?B?a3Bqbm1rNUxudjE1L0pGRWMzNzgzc3N0NGFjOWdLSDJ4UjZ2WkUxZlNoVW05?=
 =?utf-8?B?bHBhRVdYeHFuZ1JOakJDL3c0bW8vM3ltaXEwTFd1NFF6NFBzaHNKUms4dERn?=
 =?utf-8?B?OEVmT1RpUm5YZi82cktCVVAwMDNBMmJ3WVBnWS9pcWM5aXhjNUliWXBhZUxi?=
 =?utf-8?B?eTcxU0w0QnhkSE1jWGt3ZXFaSk82VFdBcGVGM1J3SlNOZDRMM2cyTDBhbzdi?=
 =?utf-8?B?am50VDYxK2lMQXBidlhoME4zd25DRXpLMXFQUU9lRmd1WlRvMFVJNGtvb3Zs?=
 =?utf-8?B?MGtMYnN5cDFnb0N3MnU0dDg0YnlObTVubk9VTWs2UzdSVTgrNVpnM2QrK3dL?=
 =?utf-8?B?MDVCMGtZYWsvMWhRVnB2VkNZU1JCUmN6VktEckFIUkphRmJibmhGVmlFT3A5?=
 =?utf-8?B?Q0JWTHZXYWtHRVp2TkxRYXF5T2puT3h5VFBQWDFYQ3UyQ0x0TmR2cGdhSGF4?=
 =?utf-8?B?YWplWGdENHcrWUJsdjhxZHZUekxGeWwyd1BSSVFQRmYvUjYzM1hEcEU3em1q?=
 =?utf-8?B?MHlkanNPY2xNV2R3cTZJbnNiRUYvVFFkS3F0NCtHcmI4dHlaYlNnS3JONUtt?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EZE/yv4FzjV6Kso2mMiR6PbBoNqcQe/LDrIV8lj4szbp9zdnda/lLLg/dYDJphIN854U4vB5NhojBSRVamsPLnluoj7rq76U/e29TOe3IoBCVpRQQQpvL+Y1pD2IR6qvJfnz7Jp0+/0+LPBmcqXfx/UCHxw03xsN+nm3Yc+PGIfCylRci++uRAUlAliZpC1L0oHLSRoCfpjv0kBALTpQIiHwzBrrrjtZRFporH2+wiIXvN0Arteupk4Q2SsN407nACG+IGKZpJNFFdaops+ksK7jnh3msfEGsdnJvdWzjukQFLtFI1t2dehcl4ngj4zGC3Kmx2C9agqc4+h74a2id8oJ+Bx5BFaQJ47HTv+5JuLoaZI4kFbd8SpJVMFSUSSWCY/62WgWetZIooVysp/PPDRc7lR3CdYpgQ1c++1sBznoZlB92fM2gy50JB+u4gtH/DqV22XFYvNFJSmEWpGtdMfcKe55hj9iJwY8/1ztzoDfevUt6zEB75z6ZbtdRloHjYT2QwR1q/yaVHNNoGCpt8JQbwamHeKwZHk2gz+E7TANAvn1deSEXYC8M4WcCJm29V4UxPG2pFQxAtobzjIhHp3vzKuh4xYMk/wb7v/SYYY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fac97f-1f85-4531-4d73-08ddbfc68119
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 15:29:04.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5vfHz289upCerkKTbJ+3QijOQhBBlTCoqDpwC6M91l8kceSbe7JUg5EcZuQOLLX3d9YvI6WIbeFJXgL/jKZp0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4996
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-10_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507100133
X-Authority-Analysis: v=2.4 cv=Ydi95xRf c=1 sm=1 tr=0 ts=686fdc44 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=IHrAe5saFLOmt9mQtC8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzEwMDEzMyBTYWx0ZWRfX7Mj+bTCs8/I9 bZXAD75gXBicoBDw595cb+A9tyjiUViQG22PaNRBh+osFRc7D+9gtpogRSVUybUSrCJTzi1gP/L i6xjL/ZIHjTBMo/P72+rIWT2taNCgSadxToLHzpA5ZsNTx/XBxoqgiGZ+BhyHFDih1a7mCNAadH
 SjXlbZcCaGsdMEpT9Kje3l/Ag4iIJsPwFdXcY+wVeFBpc+20XTGk2xPM111S6VmzBuW4o7J3Myn pePCHKlrkpxMkxlFvlXN88YS3aN5rKrr+SWhaFX2IXKQGGBfP0t5PGKvgU+bxAjxtpxwlVG0mOl i07RRH9wjXp4ifdFa5qV3Bl5GRp9u3m6tBnpbYtqdSkVjMGf//Bz7M9d5leY12jTIo6zgmL/kjv
 tSnKuzjP0Djc92sFc1CNZUkpOH2+VfKOxaOpWgFo4bhbV41OHAH6+h7iCfu6TFapMbFF5uLg
X-Proofpoint-ORIG-GUID: 2SKLu1K6Ehc4m_q1NyDyJ0hG9Vy52I3g
X-Proofpoint-GUID: 2SKLu1K6Ehc4m_q1NyDyJ0hG9Vy52I3g

On 10/07/2025 16:03, Mikulas Patocka wrote:
> 
> 
> On Wed, 9 Jul 2025, John Garry wrote:
> 
>> Same as done for raid0, set chunk_sectors limit to appropriately set the
>> atomic write size limit.
>>
>> Setting chunk_sectors limit in this way overrides the stacked limit
>> already calculated based on the bottom device limits. This is ok, as
>> when any bios are sent to the bottom devices, the block layer will still
>> respect the bottom device chunk_sectors.
>>
>> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
>> Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/md/dm-stripe.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
>> index a7dc04bd55e5..5bbbdf8fc1bd 100644
>> --- a/drivers/md/dm-stripe.c
>> +++ b/drivers/md/dm-stripe.c
>> @@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
>>   	struct stripe_c *sc = ti->private;
>>   	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
>>   
>> +	limits->chunk_sectors = sc->chunk_size;
>>   	limits->io_min = chunk_size;
>>   	limits->io_opt = chunk_size * sc->stripes;
>>   }
>> -- 
>> 2.43.5
> 
> Hi
> 
> This will conflict with the current dm code in linux-dm.git. Should I fix
> up the conflict and commit it through the linux-dm git?

I was hoping that Jens would take this series through the block tree, so 
I will let him comment.

But I think that taking this patch separately though linux-dm would 
create an intermediate breakage for atomics functionality for dm-stripe 
on the block tree. Not many are using it yet, so not an utterly terrible 
a way to go.

Thanks,
John
