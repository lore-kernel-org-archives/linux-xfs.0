Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C67170A11
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 06:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750228141; cv=fail; b=CCnjBlN90/YtLa+qBTYZfHPoSQ2KIzIp3ZHE1WYW0dqawh7bB6/0Qi618Fi7vwF7Hdg+yk/kD3T5/MFDZQlY3DByU1J5PkCFowje8BbM4E9BsrXLQdUMBLhqgVbdPxqj4PF/q6fAqXlLWQIi4IsU0zmoFZJmlVZVWK9crqDGS8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750228141; c=relaxed/simple;
	bh=EnqfVSIcKtFcX8/xSsawFIHttXJbPGcPq+lWjwzzbiU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h6DyayA/7LQbxAQtGQN5zQEHzSPAmOsy106Fj5u262DAZjLVbArR+BdujkgEwTHKGIQGpEhmXQLZyCo1yEoPoHhlQGIlmrPpwa1kW47JMgkJrGP65ivWh2cZCwUr/gQnEi1QsaYYfPTJ3zRTLgwJAxsNAhshzFYOv3ZQVmsdPUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gLWQoC44; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Vy28Gaa9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gLWQoC44";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Vy28Gaa9"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I1tXNL010568;
	Wed, 18 Jun 2025 06:28:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wJtWUWhgRHrGBS02PNChMMGESFI+maF6L0PcPuMMvOs=; b=
	gLWQoC4486d7Zh2DmX7roCftsz6Y4bnw6h0gpvyeD255+L0YFGbV6YX3Lc6PSyTA
	Mryt7q6a/rBpm+dLGIK6IPuqgo1lJ2gWL0kz5+4o7r8ZOkrnHQMJaVlbSApv9HNE
	UWLcBeH0hHJbe603ikwkDmLs5VKZbM/w+/N8t4tCtiKtffyL4onDWLUVtW9DjX7L
	Av+YSn5Q7xso5xEhODYH7+JcEUFlw5oIjdTkl7o/hAxMpn7DqHV2bXkZqfW0PuIj
	bq4otBab/qdqRuR6si6pbYJ/usn+Xv5HgU+tDS7NR25rGBTmVoenzJ/MOfOQl/L4
	DQQaYcOhOMcYeKYrkBN7bw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47914eq2tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 06:28:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55I5mpbw034393;
	Wed, 18 Jun 2025 06:28:52 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011071.outbound.protection.outlook.com [52.101.62.71])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yha04ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 06:28:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fI1RxqKfjR1H7RUDQl9u20mIoYVz6o8m8FG8vsrlEIbc8KGI1kDgxK4Jx0F0sjOvRJIeC3oaBR3JBbczv/Hn0XoOBKx6xX9vgn38EqgnwGzI74Rkm5iXQJu+TnamrrxSeD6Cwu5lKpwGXCY1KpP1TFZbGMossywkxTIszUkgUXJdk1EdIxpx0SZXdLaNTr8xbqtBNtRxcjplR9p55t2Bpu+RJSXxZVVvXW9Uf4gPq1cs5/mIQ8nRnhqCQJ5Fs91IXRAOxy1agbtQs8RXJRxOPueETzwY1Uqx/ja84J3L0DZABL2rXTwoE0GIYyKt92dR0VlIexA8eyalDmInWfQa1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJtWUWhgRHrGBS02PNChMMGESFI+maF6L0PcPuMMvOs=;
 b=DQPvd11i877iZg3WclXzE3Dgj69b0pTVd3miUz4boZWmKcG7Vxy9p5c2uLSUa9b3t3uz1LLxTtpkN4kCHmITCoZz+ayFt3AEmkVF+a8SpuWWBkoG1YwhdFxW0brftS0kBPAXjQKexy+3P5XwMqjBNlOvnfFkFlq4SY5ZyDZd01ZYFqWrYd6FhSpffwpBBEQcqDzbHVO/s2x4fTvMqdr6HECKVQT6oHmq77ynrOZKfu7ShqxPdgVvuzKtiF7BPhk7CRq7taZZ4vg/sdEIT9YjvVyfKkbe03j2vmrYGYtqwc1w46YMFCIAKsiAj91T0G4kDwbs+4qBE2pIveyNYxvnIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJtWUWhgRHrGBS02PNChMMGESFI+maF6L0PcPuMMvOs=;
 b=Vy28Gaa9w1H4YskfivnZtv60lsq7uxFOaoD+lGVfH+YPIsd2zrc/ZMebT/+txrIx7Tu0DNKUbQW6i+dc5Z1pHxbTfgWKrhFfS+yPQx6MB1vzCfUIRc2C7yF5Qs6KjV+9kX9PB79OvZI7E7RTpK2/1Hmk7Y6ZyZoY+LAiW85p73o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB7390.namprd10.prod.outlook.com (2603:10b6:8:10e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 06:28:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 06:28:25 +0000
Message-ID: <e2a54766-26a0-42c1-b5af-5a7cd5c1c0c1@oracle.com>
Date: Wed, 18 Jun 2025 07:28:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] xfs: refactor xfs_calc_atomic_write_unit_max
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-5-hch@lst.de>
 <e8cf8a81-56c5-4279-8e19-d758543a4517@oracle.com>
 <20250618050821.GC28260@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250618050821.GC28260@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0030.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB7390:EE_
X-MS-Office365-Filtering-Correlation-Id: fefc96bb-8a26-4221-813e-08ddae31528f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0RCcGxYYThKZWhWZVU3SThjM2l6Z0tQeGVNQ2t4WDd0SmYzOEJBV1JxOS9D?=
 =?utf-8?B?amhMLzRsWHpMemJlb0ZBaHNwcGlKTy9ISExDTFk5ZGZicENRbVNHck5NUkxy?=
 =?utf-8?B?UzVieW92dUlyWG1QcWZmQUV5cmNybHQ5bk1RaW9kdUFRREFZSGRWWi9GMC9C?=
 =?utf-8?B?TWkxVVlKR0NmNG5WVGhBRnNjZGFSbXZHbkVCN3hibC8rVjJYcUFJQ1R2VDdD?=
 =?utf-8?B?RnJwNVVBN1ptTGxFcnozSlN4b3RFd3BXMk5LZ21yWGs1Ty9YNWNrVG1UMDZV?=
 =?utf-8?B?R1JYSTFJRG9lWHR6eDBLS2RkVWxjRVhYSEFoK1hIeVVzb0lJaS90UWd1NjBF?=
 =?utf-8?B?ZWFydkswd2s1QzRUd3hLc0IwdEpkMGY1R0FBUjBvUHYxckNaaStOU04xT3g1?=
 =?utf-8?B?L3dDVk1aQ1dYVUFPWXdla0pXSkJFc1JjQk53dFYwQzkwQ2E0SVZ0V2xhNzhD?=
 =?utf-8?B?Z3Z3R1pBeDFuclJnY0pVVTI4WE1OT3hVVzRUdTlPVUEwVGJ6Z1B2RHZJMEc4?=
 =?utf-8?B?cFVtOXNQSTFLZzJNZkJoLzVqaWUrOUtiRThUVi9YL01vRTlVVnJMU2wzSGYx?=
 =?utf-8?B?d3k0S2doTXR4bk5OQm5PcTRndTBqZ1pPRkVDdk5Xc2ppNlA5NVI1T3JsckV1?=
 =?utf-8?B?TEE5dEYvNlh4eGZIQ2d6U25tKzdnc3pnVjFycjFERVMvbjVoUUFXYzRxL1BK?=
 =?utf-8?B?Zy9KT1g2UmlzUXM0WVpCaEdqMjNVViswdkwyd1hLZXRSQVhIMTNFVnJ6cXhI?=
 =?utf-8?B?Y1lGZzJFcGlVMExkMjhJdnltUTJTV0NPMzdSU1MyTXRnaUI4enF4WFBHcEd5?=
 =?utf-8?B?RWE4M1pQQWhoT0IyeVhuWlFCR0lnZFZyMXIvVXh5MFZWVnlFUGEvQmRKUm52?=
 =?utf-8?B?cnhjMFhPVlJveWVKSGlEN3UzYmtOYW9oZ3poU3MxWG01UlZwQnBzQk1TVFNu?=
 =?utf-8?B?L2VmNUQvSHhCUnRYUVFzYUF5WFZVTmpWZmNPS3JneXlBU1dvVzB5YmZZN1Z5?=
 =?utf-8?B?NEpyeXpRZWVmUVB2RWN0WFkzNFd4TC9TNEs0Lytjb2xUUG00alFDME81TnRn?=
 =?utf-8?B?TkZxQXN1d1c5OTZOZVJ3aUZ6SDh5dCt2WFBPSVRQRmFyOTdlSUpGUldQUUY5?=
 =?utf-8?B?L25DZitURW5VY2FEZlRjM3BCVEk2RkJtK1Nhd3NBd0dwRWZ3MHFOdVREZFV1?=
 =?utf-8?B?ekF5aWhDVDYwNndmQXl5MkNUdnpkUHlSTkR0aXU2U29NUG5KaWxtcXJ2OTVz?=
 =?utf-8?B?Y3VQL1N1ckliKzdwV2VMMFBvMGFVT0FGRXo0emt6MzRWKzFLZ3ZIeE5NaTMv?=
 =?utf-8?B?WTFnRWtuWDJjUWJEckRHYW1kSmtBNWcvK0NLOE5qQllNWnVyVTVSQ2EzKzdJ?=
 =?utf-8?B?eTZsb1RlTXJ6MVNiS1hWRXBWcXYvYSszOFBCekxPNkdJclRYOVFOODVrUmo4?=
 =?utf-8?B?OGZzWlloWm5nMHFZRjVFZkhsZUNKYXJQNjMycGM1STFWYzlCTjNpbC9IZld4?=
 =?utf-8?B?YkVoSmx2bnFoSmhSalk3eVNHK3NtTmRxTlIzaEM0NXN6Ync2ZWVzL1dOQmZ2?=
 =?utf-8?B?cnVxMXR6aFQrT2UrcHRkSVQwY0tMcmxmTnBpUGdsVkdvSnFMalcvci8zRnlX?=
 =?utf-8?B?THdZcG1hc2VTdmpOazVnVlRNSFNyY3BWTHNWb21OTUo2VHU3VkFkTVE0Qk1C?=
 =?utf-8?B?NWtzWlp0MHdSUjlQdnJ6alhlc1ZscVFaMEQyVVNxdVhZdnRQQTFadVNuamc2?=
 =?utf-8?B?bTA4dXdOSmdtazdCMVYzNUc0MVFFYVZmNHltY2wxRnZMOXgrYmVsb2hMWjEz?=
 =?utf-8?B?M041cjUvMU54MUFJNmY4QjlwZFNySzA1ZjdQcnFLM2l2Vk5iaFU2RkxQU2RQ?=
 =?utf-8?B?TXhlaXJISEpWb1hXMUo3cFJRN3pOWTNhdzVPa3ljMldJSmQ4OHh2d2JNRVpi?=
 =?utf-8?Q?PDk0NV25388=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVc1UG1oS3JiTkJMREdmVjJXSHlERHdnUnNqd1JsSVNPOHpXL3lBSzJveDhv?=
 =?utf-8?B?YmRkbmF1MmtGYlovR1V0RWR4Q2JGQUhxU2Nlc0R6cEMxTm9WNXlEYnZVOGdl?=
 =?utf-8?B?N21ZUXN5WmxRTjlUYmhuUW5jN3BiUk52QXpPR1p0WWJrTFRKYmYyNzlDeUla?=
 =?utf-8?B?NGgrMmdod0w4TURYbG1Ccmk5UE8yWXNlNmY4NldGa3hNbWtDUXlodVZOQkli?=
 =?utf-8?B?MmFuMWNHeHRGUXA0TGUvaEdTaDZvZ082K21POWpQMHBGdkg4d1BKRjJwS0Q5?=
 =?utf-8?B?Mkh0MGoyR1F6dkFUSmJIV1FWWW1QSVlFZjVOcGJlQzRWS2ZsMmlBRVZJeU5m?=
 =?utf-8?B?Nk9UcXB6Q3hkQ0E2M1huL21VMTk2K21TOUlyU1c3TWRodjU4RnZhanRuZTNP?=
 =?utf-8?B?Zy9ydm5UYTZuQ1BMakVOckgvL2ROWlRWUG9ZTEx2M1lrandONjZLMmVvZ1h6?=
 =?utf-8?B?eE50eUNnbTN1cThxb2xPbVM4N1FBdEw1d2JvYVB5WGFTZUFrRnBXek1oZTJa?=
 =?utf-8?B?RW5vWVVpaWorT0tLdnkyQ2NESkZkc0ZQWUp3ajJMTzRPU2pMM3VLVlNqLzVW?=
 =?utf-8?B?VHFvRGtqbUVackYrUXVrd2w0WXVKWDF0SkZwMDBDQlhYWHU5aXhuaTBjaHh5?=
 =?utf-8?B?U2M2aXE3UXZaU3diOGk0ZCtrdGVzZWt1d1JsWGdqOFJSekVrME5DZ3pGbFdN?=
 =?utf-8?B?M1V6STZCVU9Ebkl3QVVOQ0I4WXVDbFVwT0lmVDMvM0M2MUhnNnI4aHE5enNE?=
 =?utf-8?B?WkF6VVhOMTYzZ1ozNzZZL0FCdisxdEVEaVhFRitSczM5dUdXcFVTcXdLMmps?=
 =?utf-8?B?ckxEN3J3TFdkWmlWUFhHU2JrekcyVzg3R1k0cVk2Z2FRTkNGY253RC9ZczBr?=
 =?utf-8?B?TXhQeWxMckxmWXUvMEk4Qm5wNTY2K1VkVFZVcmVUTitGK2lndWNqTUFOb29L?=
 =?utf-8?B?b1lvLzJsdDVGL1NLOU5pQ0VobmtpWmNxZVBSZHBmbmR6YzVBcy9VRG5IM0Vr?=
 =?utf-8?B?YnpQc2JRVXhaS0t2eGY2VWsrY0ExcUtwL0RUTUZ5Uk1XckFqaVRPUnBUbCsv?=
 =?utf-8?B?b04wWXdpQUQ3eXdiV2NrZ1Y0RHFOb3Z2TVoyS0pHWVNuUkI3ZkxPeUs5eWVF?=
 =?utf-8?B?dVp6RWs0NUdnV3Z5NTdiZjRDdzdjMW9YOGo3K05UK29uRG9zN21LL0doS081?=
 =?utf-8?B?c2ZmWEhyMGMrRUlRV0orZ2VCbUtDODhaNFArSjRSZmxtK24wcjdEL1JOOXc5?=
 =?utf-8?B?RVhEUWRwN094RUhXS1dxR21aTTBtdmMxenFnekxaa3lySlI2MlBFT1dmNXAr?=
 =?utf-8?B?bGNtaklnYnllK1dVcFc4YXBHTndmTnlEUFpsbk45OGZMNWwra1U2bGhQZzRa?=
 =?utf-8?B?ZjJaQkJrb21YSHVQZlVqT1ZVS1ZWbDhMbDZBWXRaUGZrSFV2U05DYkVjSkQz?=
 =?utf-8?B?MHBSV08zMWRqdzJSYlZhK1R3YndjUk1CYXR4TnVlcHR4S1djVHVZVEtXZXhw?=
 =?utf-8?B?aW9BM2dQM1lUWHEvVnYyd1k5WFZGdTlscDVGWjh4MkdRUHFVd0VrNXA5ZTk2?=
 =?utf-8?B?TkR1aE1BaDV0c0YvQUs5M0NaME43b2htdjhsN09DZFFPUW0vaHNrTk5FWE1T?=
 =?utf-8?B?dWlMZ0h1dlBKU2lIOFJCU3RGcWI0QUthSlQ3bDZkUDhNZEtIQ2JrSklvWTFk?=
 =?utf-8?B?RjBKY1VNSHlvTnB4Q0xiVjlrZU9VMmNoNld6ZDZiODZFaUk4VFB6cUdlREEz?=
 =?utf-8?B?MUJ1S09tUml2aExDQW5TalBmOFZoaFlFbUVIVlFaei9YOThML2FLbC8vRVNP?=
 =?utf-8?B?M2NjZGFBQUNPYWU1bk9NV0FseCtBdkw2Ym1XY21aMFVMaS9qZ2hWWnVMY3Jr?=
 =?utf-8?B?WTVGcmFqS2FuOGttOXp4TTl3NS9PYUM2QUN0UTBtK1UwVjZOVm9Mak5zMXdo?=
 =?utf-8?B?Q2FHVkkyRjcxOFlwWXpjMGdPNVRiaVRBd3AzK0U3ZU1Bc3Q4R3dEUERmUFZa?=
 =?utf-8?B?RlNPUTVHa3QrckNwV2dMZHJ2dzRHRUpKbzQ0aFVZeXE0cmYzL3gvdldOK1Zu?=
 =?utf-8?B?d2VuVGVFZlRyYUUwZ2I4SExacXFjL2kyOWpKdkJxR0tRYldxR2dXbXJzQTFv?=
 =?utf-8?B?M1QyRGJMMjhGMTA4Qml5ODZKSVhUa05pbmdYR1UxcDRqQ3RUWUdTLytzWW1S?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RKLMB15WDvCAcu23m3w0LuePHyQdR3Q2hxIeACLQiqE2vzOW3o63EOxTFvB/0Pkv8CBy8jb0755fnpccBFjnNH1nfKcf1wJr13twmR01tzdn3r3+pm9awB8o/anFHcqZDNSmwmN+SmZ4ly6AsbJSABMDsFupjjP8AHe0VP0NgvaQtHoKTrwr9442Z3CJcOP08Ucno127gusNsSGZ6aO6MaY3y+yERXtM3oDN2JCEbP0LYkIQrG+408tjO4vSYfcMLVGVD6qUL8YLtFoE9x5DlazyCj1otgM2Ulwu2Mk6WDO02ZEeBn0oNpL+4cnOp/7ElzwPf9FU4+QAY6a5ZEDbPCsMDzh7lRBybTzWZs0sywg6mLpn9782VG4uNLMV/nxPPuXuNMhnFP0B3vz/U+1tIce0jg6HLttN9t3uz/tunbSYYcl8v++guxxuJAeIpuOO3PkAtmvgJHzPyjODPmr90UYybwVVt/U/KAPMX90dVcWL/+sgv2I6ZrWPaG2WxqJtMQRsDcxT42tpAG7iapjFQXu2g9GdTB1u+T+yM0tMCXC4vFZ6wEszx5IiB2YrrLw+pspae+J0LX7bUQw0d2r/o7JZWiU3FJe794/d68LIUEc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fefc96bb-8a26-4221-813e-08ddae31528f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:28:25.6363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xij9suMt5nRpQRDxCZ7F4eG8TVBBlZF66bcLWhDZTRG7/8APniJ3yMvlzEEG0PNnCdYIfmo3r+1ICs0UadiUXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7390
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_02,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506180054
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA1MyBTYWx0ZWRfX1iAiwhzKBLVe kEEtBbf3zqIlNuq/E5hHlyMkN3dTJGWs9QlpWMFKOCN8FUjYNGYwPD2KoNIOVAeS1SN7Wsb+5mw I+m8sKdwZKhRuGRICQ6YCZZ5tAtf4pXCzhcl8IAA3hW4rg4Mn6YMeIuxkdoXkW7clkkMMYOhrHs
 82JvXYpXg/W1SopiqhwQ6h+PsY+6BAoB4fpRCO5po3PePY7m4GNBXugoIFm3dHNYgsgF9wf9dMD rEFRZ6gZiDe/W0HXcnH+dkU0/BgknSreQrOmp4BaUg+xXrmTSCrcVvdTwJMgqMC3AtuR3irxWfz odhU1hlHc45UgLLN6RJUeUjV7caoSxPRWVkeCdUjqDso5sxsc/yuYR/w30aAvLZrB0/FRSFxWrw
 /4+evpfoD0ScX7pjI2LHUN1580wFlxUjqKtA4SFsAu7okusw65P/Vkpszwe9Il9025pinfwW
X-Authority-Analysis: v=2.4 cv=U4CSDfru c=1 sm=1 tr=0 ts=68525ca5 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=nfX_oMWPBSHz1rP21j0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: IL3345zryqG0gTl9NyAgpUFk5pZf_CvG
X-Proofpoint-ORIG-GUID: IL3345zryqG0gTl9NyAgpUFk5pZf_CvG

On 18/06/2025 06:08, Christoph Hellwig wrote:
>>> -	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
>>> +	struct xfs_groups	*g = &mp->m_groups[type];
>>> +	struct xfs_buftarg	*btp = type == XG_TYPE_RTG ?
>>> +			mp->m_rtdev_targp : mp->m_ddev_targp;
>> Could this be made a bit more readable?
> Suggestions welcome.

I thought that you did not like the ternary operator :)

Using an if-else would bloat the code, so I suppose what you have is ok.
