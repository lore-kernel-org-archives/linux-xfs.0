Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5FC3717F
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 13:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714052170; cv=fail; b=exMzOTXUeMLz62bZTtEBtIpbCBGDbjEqxjo3E6XOu7RQ4tq3xhOWbKYT82t858/NfFNGsulv/VcQSkXV7/rxgAz4nTrP3LYA0hLtgAeBmSwZIKKjY9s693pOn9sPRRJU9Y25wz8mkcdNe1IpHvOvgVdJTO2fNj+oflFIYjHUEvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714052170; c=relaxed/simple;
	bh=0jMY4ILB40gzy15XbKdsQ9kisFkXOqgH8wvI00bbrfw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RMOp/vlM8SQrrR1T5k7NF79NVcFZsQSlNC8lOJ5+KRK+HStYjIiqtm3gm1tOkkRCjLy4Yc9KbXECWrWvej1M7iwEzbDUyFz/IEDLnm6oLIHAQblbJ10ZOnjbIHdYvjpyUuRgQuvKNvwsK/+jS8NKLsgUin7bLTaf9OcxSwhGpO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e2p/o5aA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nTGRWjrg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e2p/o5aA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nTGRWjrg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P8x3Lx004175;
	Thu, 25 Apr 2024 13:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=t16JaLUwN6sCIHE0HQuDLLG896K3Q0IkoQKZGvgtDKc=;
 b=e2p/o5aA7qjlhPx7Bd9lxw6IxnLKU3wea2m0maR5gab9L8j2kKkwL4178nfzSOkGUzl/
 124lFyXf2oi3haMk9JZZZP1fCC54n4g7horfPRX3iwUCqneS3KrsbNIbgnr/k/pCulfM
 LKMyyTX7Ee8Ph8xUIb1jpBXr1vo0OWKF6r6pQD+qhct9G3tfk5WF2u7ZDV27dGi4OmA/
 VcWzjn1vudaHoxOX0TYCNLVTwDwLPZMzgs4jVzo4Xx7AutkgAWnytBAWvbZjTg4LFmvA
 nILiAnJ1qTs5L5tX/reQvQXz9VUOyXE2bbNeu6PsRm+u4JOQq5aLl0Qq3kVWVLgsKPnF 7A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm5re2j8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 13:36:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43PC5GLC001726;
	Thu, 25 Apr 2024 13:35:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45b0yyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 13:35:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOSnHaRHdaIFDQ+g/HuZzw303A/vzhSQwX0kvoqqz6qkhkfKb1WcQI4At114y0ReH5Ik6Y6XdRcDuz+c5YXV7uuGAmKAyVx5NI6uSI4VyuA0/LpRwdTXMxh0omw6Wk/lZ6u0EfL0vuEc14lERqnO0Z4doG53HrnobE5N87tHaPJS1suNx8pMecQUKo2u3beijZGAa1T8WXZGmNLlzuIGHbuAIrW8Lm0aakxpXStfDVsDNCClqfuo73wdzwQLmco8wB1eOsLXRE4IiwuVwHBRXw8lVgI/8NSl6nYGE3S972G4naxzRdhSh6IEL88S8tPdcz+0tMGqH5GxQS2okC0E5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t16JaLUwN6sCIHE0HQuDLLG896K3Q0IkoQKZGvgtDKc=;
 b=DKzTuHh9M4q+elJpmHAo9bDSNxZgZNH9CapGJHDja+AiH3Gqkh9Y/Vr03RL7YJDmWhCp+uUAYmVvnSnUT1QghkfbXxvyjl+b0tV8LSXk7fWEl2b3KMUiF/texV/S+JX6j0HwEHiNA+EUAm86UA8x2z/z9M2EiJZoNdNoXrIMgXmaViJKcKLvT7Uro9oUM7KooeqgdzNRzHBHTvXJg3a8kOiJlISlXlKnVDj46D/xJqHXcxQYkLhkwrf3wOYQSMb6DigEn4prZpaVGh3cEuxKe6xL3mU0DE5iibXOHECBALnkIxGRx0w11YMRVqiTktXFDz52cEkGq+1ITuo091cw2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t16JaLUwN6sCIHE0HQuDLLG896K3Q0IkoQKZGvgtDKc=;
 b=nTGRWjrgoIfTjONndB+oIR983kaavwo088gWpvTgnJaIrBhxS+y9CTLAa3pOhJWLLXn1IpcABYLrIk3Icb6OfvTrbaM6nlqpmIm6TiUWXZW3AwYqZ1/NHcjbOTXfmiDP/p9wkiZAP3Y9CRcY6aSKqokYlvPrl0i+JkVB9EGuVeE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7359.namprd10.prod.outlook.com (2603:10b6:208:3fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 13:35:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 13:35:57 +0000
Message-ID: <f134a315-e4c8-497d-867b-c800a11745f6@oracle.com>
Date: Thu, 25 Apr 2024 14:35:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs: Clear W=1 warning in
 xfs_trans_unreserve_and_mod_sb():
To: Christoph Hellwig <hch@infradead.org>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-3-john.g.garry@oracle.com>
 <ZipJ-GWpbqQ00Cib@infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZipJ-GWpbqQ00Cib@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0105.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7359:EE_
X-MS-Office365-Filtering-Correlation-Id: b2a37f54-e2eb-43db-93ff-08dc652ca345
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?YUlOL0l1REJMdENpYzFTK3d6YkpJUlIzSGdoWHhZQjBTT01XTXdJUFRueUg5?=
 =?utf-8?B?L1JKVk9Ialp4MHBWcVZYZXBEZ2ZFeFdmT2VyTlRVN0dkaFdFSktPUWNRRksv?=
 =?utf-8?B?aTFLR09IcU9OaThOQk1US0NWSmlodnJlT0hsbnBXblVWOTluSmc4Um8zMnlj?=
 =?utf-8?B?Ni9ieEpQQUZUSnc4azE5VElXZHNtM1B3ZTJ3cUFOcGhHT1IvSmZBVjkzblZE?=
 =?utf-8?B?bnZjZXB6dVFNcXFpSzBscDFPRU1STUlEZDgrQWt5eUdkcDdPS3R4Q0hjdG5I?=
 =?utf-8?B?ajRJRDVoL3lGYXN3dXZ2UjlKOEttWmNjbXErNHAxYkVwZGp3SFdsWXoxVWVD?=
 =?utf-8?B?c1N4S2c3NThNdUpQSEVzNEVpRDZkai9GL1JvbmU1TTIwQVEzaDlxZm5Mb1hp?=
 =?utf-8?B?REgvSVJ4b0RPcEhYd3hHQWFOek91SnNYR2JVd01SVHI5bk9kanZMK2Jlb0Rl?=
 =?utf-8?B?Rm9oYTZuTXB6L0hkOHdNdVNVc2t4RUlRYi9GeHZPZDR1TUVIZThSdnpTT0V5?=
 =?utf-8?B?RSthNGpqMVJEZFRINE9IQjVWTkVLRko5TEl0MjlIVTYwTmY0dm1GdVZPa1Ja?=
 =?utf-8?B?MFQzdEFkdXkzajVsZ3ZVOEhxb3FONS9jd0hlRm5xeVRBMkdQZ0MrZVF5cTY2?=
 =?utf-8?B?UzhlOEhnd09lbDdmOTk0QXNzR2ZNbElZejVKcGV4cXV4V3VWVCtBV1hHOTdh?=
 =?utf-8?B?ZityajhlT3B1Nlk3MXFVeDFaL1RwVTQ5aTR5Q0Z1RStnbkJmdWhWUW1ETStv?=
 =?utf-8?B?cWNoakRDTEhUWXdjamg5eDNZZEFySnpNbzZjQ1NLblB3OGFub3NiU3hMQnlG?=
 =?utf-8?B?OFQwM2J1Z082RnhoNkJZam5raEJ1dmZBZUFyWlE0SkRGd056bzRGek5VeFNk?=
 =?utf-8?B?YzdtVFFxL1FaeElsaHFaUENKSGpJeE9ZSWg4VUdhcHpaM2FmaXhOcmJjOTc4?=
 =?utf-8?B?RUpMQXhlUVFoZDVkdkRLMnlobHRScXBPZEk2dmlVNkJMYS9KekpxUnI1TlBl?=
 =?utf-8?B?bXZNY0lXRmd2UHV6T3lvMHRXaC9XNWJUVUxmcmZZU3lJRUd1cFhiUDVBcmli?=
 =?utf-8?B?cnlJR1hsWTIzL0g1MFA1VXRHNG5xOU5qOFVEOFdGU1BPZjRQYy9NWGp1V2lW?=
 =?utf-8?B?WUpoaEVrWlhXVThoODk5MWQvOE9YOXlKS2VnZTd1Z3hTdEhQemJ4Ykx4eSta?=
 =?utf-8?B?M0QvR1hCNDMvaFJBL0gyeHVnWnczM3ZMUzNiaDZCTzhSNER3Ykw2SVV5cG5Q?=
 =?utf-8?B?YWhTM3RBdzlRb1dsYzZCV0Q1M2daU3VhMmIrZlEvcUN1TFJ3TGJ6bTY0WjBh?=
 =?utf-8?B?dVA2NGN4c2pOc0M2N29wV3daak5MOWtwQi8vcnhmaDdVaFlsbDBwV09MNHBo?=
 =?utf-8?B?SGtFM2ZxcEtWV0psdmlKN3VBazB0Yk8wVEU4VVMzQmZybElQdVZlRHBrNnVn?=
 =?utf-8?B?Z2ZUU3BETVhUcU1EZHphaDVSWlVzRlE1TG5KdkNic3R3N0tacG1ZRDIzTk01?=
 =?utf-8?B?Q2kxeTNocUpMUFZxdVlFZTdLMm5RVm43VElIaXpHVEp5OGFWeEpzcHcvL0FV?=
 =?utf-8?B?ajQyUGdFVk0xSVlXaG1rNXpxcklob3l3N3pudEVmTkJnbFdseGwzWjNieTlG?=
 =?utf-8?B?YkZEbXo1b05vQmF2b1ExU0pnQmx6ZklFSE8venBHODI1UTR0c3NLRmFwS0J2?=
 =?utf-8?B?S1FCSkliWVQyZk5MdVQ3Nmc3UmYvWWZDaFVTNjdvN2Z5elpLRFo0ZU1RPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?V1VQSE9oYnZyODkrMDMyYk5WOUdDeEVBMmJueU5oZ3orUllaZU1sbWI4QUVQ?=
 =?utf-8?B?NUpCejdtbVZXTHkrSktmTFVhQmhhMTlTVTlhRDdzaWw0anNLeE8yY0l3MUdM?=
 =?utf-8?B?SWNGUTNNamRqWTFRQzNtZFMzeTRyU1hVOERSbi9JMHIxM0VuRjdqVFZlZDFz?=
 =?utf-8?B?c0dDQm5QeldTa2k1ZHMwSVVlWGVaa2hQWW96VVJ0eEJHMEg5YlNJR2kvZWtj?=
 =?utf-8?B?NXh2SWJYMWVtenluMU84U2w5T2RCS1NRaU5IeVZqQTNkbnZTRTllN05CeFNt?=
 =?utf-8?B?ZDZxcFMzVjQ1TDNPL1NGS0VsNk5VTFloWExiUHNTS2JnTTdsZHNFdHBPU2dK?=
 =?utf-8?B?QmxWb3BKK1FSTXRCTTMvcGZMV1BwN0drUWZ0YjJReVgvV2J0amFCa0xYbmRS?=
 =?utf-8?B?MzlBMlJ5M0FUbVJjUTJQdGdWQ290ak5GWGpQZjJIYnFmZFRKRVN0VytSZGEw?=
 =?utf-8?B?cmdxWTM0cE9QNHQ4bXFhU0ZxejR6eG5QNGhWcXRLci9VaGVYdE55RitTbEd3?=
 =?utf-8?B?bWJzemFqQ1lqR1BPVGdjbGY0cjVLeHdXdFAzS1VsVzBHd2lGbUtMVHZUY3BS?=
 =?utf-8?B?WG51dDVCNmYxYXZGSmtkeDAvaUdqTlJOc1JtNjJER0d1RTBNdEIyL2tVajJK?=
 =?utf-8?B?OHJFK2VkR3RpSS9WMmlXN0xURDBhTDFlV2VsSG16NDZTTUNyVXR6SS9MbEFN?=
 =?utf-8?B?RGNnTDkvRkl3NDlhamRIRWI5Zm85UG5tREJHUXFIWjFxdGNqQlhoaXZSdlRW?=
 =?utf-8?B?cTVaemp3NWJSMkV2K0tWNFp4ZVhsSFRJcVo5NnYvdUJoa0Q1RHp3eCtxTUsr?=
 =?utf-8?B?ZWNnZWNEUC9Dd1BzT2ozdzhyTlQySVJrZEdYRWR2U2JwZlkyREFzQzVHMHkz?=
 =?utf-8?B?Z3ZOc3cySjdNR0J0bThDd3pjZzVQUm5kUmduV2N6OXdtdTFyZmRkM2tpclBu?=
 =?utf-8?B?T1k2Z3NkL3orbkkySVhoaVE4cURsbTRDOGhuVGo0TTdBTmtmYjZtSmNFZ3lj?=
 =?utf-8?B?WnFuRHUxZml1Ui9qR3o0RGRWRjRiTEJRdFNURGRubC85NzNYemlkZkJoSmRs?=
 =?utf-8?B?SnlEckJzRkVId2pjZFNjSzFIQkpiekVXQlFVcDd0b05RcXlDYlBsMGoxMXp2?=
 =?utf-8?B?WVRmUE5SWENwUEhPWStHNFJJRWZwWENDQTdkdThCeHpSd2lFTUZ2YStPdmlx?=
 =?utf-8?B?ZXRuVjc0aE52VkNkazhtRzQ3TW5hRGh2RHBKZkR6UFBqTkR0ZGM5aUtldjdv?=
 =?utf-8?B?UjRueG9CbmdtR0ZyblhJTDdWMDJQQWF0TC80SEpKQ3Y1YzNZZTRXRCtrSkJi?=
 =?utf-8?B?aEd2Y2pueGpTRXlHaFhXU1ZBekc5NGVPa093Rms5NURxTFlvb3p0d3NkMmc4?=
 =?utf-8?B?WGJVU3Y1R0ErQy8xNm9uOS84RXdZYmdXMEY1ak9CU3RaWmdCdVFPQ3pySG9G?=
 =?utf-8?B?MVZiZFFIZWdqdjBGQWNuSTBlZzcxampHU2VWb3BqWWp3dEdSaUFncSt6N0cx?=
 =?utf-8?B?aS9SY1VWWVo5UTN3Y0xGdjI2VllvN3VQNloyTWE0R3c2N1NqQXRzT1RONWFS?=
 =?utf-8?B?NGFCb25NZmQycysyZnc4Z0x5SnQzT1E3T3N4OGpOK0h4NjNtN1pmL3JiKzh4?=
 =?utf-8?B?ck5neHpBUEpKajI2ODdUQ0dWVDFoY0UzRkMwa0tMakRMV1FpQWxuaXRTZ2Zy?=
 =?utf-8?B?Wm00cTIvaXVueGJMNjVNVHYxS3lPRXNPN1hTdUM3TDdoSFdPeE9qcDM2Wklx?=
 =?utf-8?B?clpvVnNRK1RBcm1ITTJ1SkxzazRlY3hkU0RtckFKNEdxdXhURjhta2ZTcm1h?=
 =?utf-8?B?ZVZYai9YQnJDSjlTMmRRVStHSkVBbnpkaGxSc2ZINjlZYmJrZ3Bwd01rUG5M?=
 =?utf-8?B?dDRRdzkzS3liNXl6aVQza1BCYVozNmNDbGxKV0xHM2Y2U3F1R2k2SXcvcnor?=
 =?utf-8?B?dzA4QVpSNjVoKzJQOUZCeFJ2MFNmZGlQM0JEM1JwdEJwaXJzaFlBNmxDeVFv?=
 =?utf-8?B?aVFUeXlsN3R3VkZ4Vzhic2h3UWVETTNocEU0ZW9vd3dxdW5RN2tXSnZVZmZD?=
 =?utf-8?B?Q24ya09GaDVKNThQOEhSbGVUU295NnpHVCt4OUdjSlRKTjB1RmlBSlM5Z1Fn?=
 =?utf-8?B?VkdiRHA5aFZTOXBBMHR2dk83bGtuRmJXcXprdkVRemlEVDkycFJCRTlSSld2?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Wl0u1u1Bj0d2gioY9ar+npxa3SBWkBjxB+EcoEkAVmG1d0WyRg5NgYrRUdcyjWOC4dvME0rKokNML40m0MUs524JYdUqOwmgEEUorJdRxxyaR9blCU2chi0RgeMCb/rJ5t7+h3C/V3Tjm1+FwHyAqRrJYg/bNW/kPDe28/694YgKPFG3ibq8LzdoHrqnTyLBI7f58yLw4ronalWYFgCBLqNX5Gdn0QLSbkjLbD67PDQkPP5sCCdJ1zu9bmwU+NAm+jqIRYwto39eTWkuBb8HtKK9L1rNeBx/wW2mQBQFlWp8n3h89/iALFKSU3X260jxrCV3s1eXyyvmdQh/jgvJ7Z5m1Fy9QNacDrDTtKp6Emdda6ZiiYzhUCFqSMTkndtbdqy/rJMUFV8ZammXTvKqGjNLsYpINOW9dD5WAPFdpyj72WKTYuZAxN94D9ia3LMgWoubVA5julA5bVK/DSstJDM1/QCV2UjS8mBlazZzAZlN/bPSe0h/h0IP0i6dsRBs7f+iiYpUr5ENHzJCjMcYb2pacFpH8lIYb5pIdfsueNt4k+mT6e9ZKS30zzrJ+gZiim9tYcT/thFoszb9NjqlroSeKc3RmuKGZisANGdFeAs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a37f54-e2eb-43db-93ff-08dc652ca345
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 13:35:57.4311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K970g/Dz9wh6iR8enrG2nW5WJopOQ8632x5dJQ9SW7jE/m/jFVX+YcMjKcHpE7RPcXxQWtmkPLZfc5aDD+EL9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7359
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_13,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=941 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404250099
X-Proofpoint-ORIG-GUID: X72-IkkEBNn3mewQpLOOsA0chguHe7bh
X-Proofpoint-GUID: X72-IkkEBNn3mewQpLOOsA0chguHe7bh

On 25/04/2024 13:18, Christoph Hellwig wrote:
>> +	int __maybe_unused	error;
> 
> error is gone in for-next.
> 

ok, as long as this warning is acceptable for 6.9 - I assume what you 
reference is for 6.10
