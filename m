Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7242921C190;
	Thu, 10 Jul 2025 15:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752160749; cv=fail; b=C650PpIJkBoClWBYh8zikwMZzKFXrMIjaNvhgfXpEpW6QEyqOYsh3vyQitfDDtmjyYRG3eqeyyYtDOsCsbu1CnwiFlWtqFEUgmhzfA0GxzmfQa7HohDl5tGUwggkQzcWwj1aISv1ZgpCnhflFApSkVi7+R+H6Z43FHPjhYDXcCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752160749; c=relaxed/simple;
	bh=M9KdNciNwCJcUWqJ7SJbUsKN/2TNTBORbWHWL/YXuhA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tigu8/xpQgY5V9oNDo0ejzCF6SSI8VsiQvifJLRbqkw+nKSm5SIXmDWkFrMg6JFTfvX5knD/ZwT9nmpnprDHOjHFMeoZpa5O22/wKDnI2UTFq4TOZEXBb93Ev9tOVCAhMsSXYGd7zIrm4B17MiFu3edR8IQOdrJF8caoot+P9tQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=daCmy5MV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eO55wdc5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="daCmy5MV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eO55wdc5"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56AEg029012332;
	Thu, 10 Jul 2025 15:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DSCBpztNcVhK1IORQtujnRzUAhBa8PHWJYiqGT8IyZM=; b=
	daCmy5MVHFHfHgQMHM2xpsxc+uy7trYzID5Y2RTe54Sxfh1PcU/hnhtiTE+pC+QK
	9BNbQU1evUoBH23s0B5eFj3xynjZPpZQxViXhrWAe76Ic1wWkdZEcpdgU0Sch4jN
	2f6iBE5R58Dy0EAjzOLje+xFSz8IKxSP1YiHDkuJ7Wlje5KxaLClLO/l8EZKihYd
	I+ROXU8Jg5gVDwYUWFp7nqY2Xu4HNqSM3lVJ0AbS/aOpz6iSLFbOOr2V6iGZiN+S
	Z/wDkPl0aiHkNW3x/jgZ9eFTdofdme12f9iyj3yjvqF4SaKFev+I2Y8NehVD+tGI
	a2bNaJYDTBW8VWan9Z8IxA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47tfgkg37m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Jul 2025 15:18:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56AEa4Tf040427;
	Thu, 10 Jul 2025 15:18:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgcnbpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Jul 2025 15:18:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVEeL36/IxNR1/URr2K7OlubELBf075cal2uxHe9wUihFcT6xjFdRFiFezvUpUmGb0eKyFfB9k0fAhemwx6pDteBKlRsw4Iivuv0ql5bMcuuKfR0nQjp/fwtNrHFlmtVvhWwjJuO3XDHQ6WoPf/QM5rnaQmpeXr+LYSaj0DvvRr2O0vZPFpVjFSqOB6SC1wl3LqFP/QIp0qQow6qE9ASw22uM9LKCFzlBYQ8gSAPSZd3uV074WqpoPiyYxwVYOBtLrqFyn16yjIqmBalxFYfvCGvqOEsVzbwnMsDv/dA8x7PS4JIsostdGCHRRc5R1GjnL0HeiMqIj4VBPJfGEOywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSCBpztNcVhK1IORQtujnRzUAhBa8PHWJYiqGT8IyZM=;
 b=epLxa0ys0adR0BeJWk/2byL8EaPu1geo9Emf2auZoZy103b+VpicW9GL0lu2qobAB7KtXXH8qbWdBf8kt2Es1A6jCT1np5mYBpU4NJmVOJk0rhmX8uC3wa4xVqK/SGIcswkhDhBuzldrxBkIHCJ7U4E5rDW6CpkGHFRZrpMD2qCl7/92FSObjbLSc/ucpMW85UjhGmW5Vp/sXWMCqkhLfK0rChnEYcyz6jqSLc9fLcyFZRQnZzfjmVEoxqnQShJB4ib2WR18GnlH/M7gGQvSWekHODNkxE3Dw1O1V0DrIPQaswJFNz0uMKsSmI++yzq8m6wg3WCqP7tAONESYbNJDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSCBpztNcVhK1IORQtujnRzUAhBa8PHWJYiqGT8IyZM=;
 b=eO55wdc5wD1wgqWOL0JPuUkj99neCZHqEAqxgDZvUuc5c2lvritVihxTaNHgmr3cJku4bJLD8uJd85zAJkNaNNhg/s+6s1IMuXYIeC1iuKEuSCPu/pWK0mR03GHc6ZBWhqYxCh7bw+dGafGuD16uas+NhbW72Ny2xIPM0lBRYOU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SN7PR10MB6308.namprd10.prod.outlook.com (2603:10b6:806:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Thu, 10 Jul
 2025 15:18:37 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Thu, 10 Jul 2025
 15:18:36 +0000
Message-ID: <54d83775-7497-4fae-a9ea-bec8008557aa@oracle.com>
Date: Thu, 10 Jul 2025 16:18:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] block: sanitize chunk_sectors for atomic write
 limits
To: Jens Axboe <axboe@kernel.dk>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        nilay@linux.ibm.com, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org
References: <20250709100238.2295112-1-john.g.garry@oracle.com>
 <20250709100238.2295112-3-john.g.garry@oracle.com>
 <04620cc5-7c3a-4e4f-87ce-b691d9b57917@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <04620cc5-7c3a-4e4f-87ce-b691d9b57917@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0029.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SN7PR10MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: ea1362ef-0d46-4bb6-8a05-08ddbfc50a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnY5cHJrMkpyT3oxWE1Qa0FYVCtOSmpCSWUyVzRBNC9ESHo0d2dUeUFBbnB0?=
 =?utf-8?B?eW5BakRGZVg3OXRoQ2pLeEJiYSs0eE5zWVd1NnNEQVRYOVp4NEdSTGUzcVhZ?=
 =?utf-8?B?bGFNTXdIZWd5bHprYWtXM1A4RDh2cGpQclA3V3Q5UDE1MnRjaSttL1hkdDZS?=
 =?utf-8?B?YTMwOEV0QnlRNHhmZzN4eWMzdmMwWFNrZUwrbVVJOG5WbjJYbFBjdlJhb2Fw?=
 =?utf-8?B?ODJ6elVYcWp2c3BoTm1IZzRuSlBuSG9PRGtIM0UwZmE1ZzM3MkxRdHlpK0RP?=
 =?utf-8?B?UW1pc0h0dUlHK3hZU05CN1lrK0hsUHhKSFp2Qm0raWtka0ljajJCcXk2NzRq?=
 =?utf-8?B?eHpuQUpXaEZvVjEvTTBQRk9SMTMrbHFlaVhnaGprbm9WL3hjNE5kQ2xGMWJz?=
 =?utf-8?B?RmRwcTVyd2hQVWEvU2x1N2gzTTZpbjBWTWRWVlRIWFYrdXRSc1RVMFR2VmZL?=
 =?utf-8?B?b0gxR0ZVV1BwcCtxSy96aE5YMk5acUlTQ2kycDIxMHBiMFFHN0loRHg1b0F2?=
 =?utf-8?B?Zlpuc0hGWVFleXF4Qk9VODUzU2RwaUFKTytRSXViK0lIeE51bFJUSXcwdFVM?=
 =?utf-8?B?UlBQWjgvd3E0ZUVWUk1zSmx5emhEdUtzUml6eUFrdTM3NVlFV1hWdGhHNG85?=
 =?utf-8?B?ZTdFRW9NWFZHM0lTRXNGUXFiZXptRkZXYjNTQUFEVWZMd1VKWm9QQTViaXNF?=
 =?utf-8?B?WWc3NUNTUW5XclQxSWJhTDhhN3lGdjZBZFFrbGVNOGhCcVZaNkVWZm5VN3ox?=
 =?utf-8?B?VU1xZndndTlHMXlwRFpFbVhkUjkvaFdlR1BnWTVFNWZ2TVptb0pNdkRuMGJ6?=
 =?utf-8?B?dXN3dUMyOVZwdVdVazQ1bnVUK0VMVEwzTXlCUFJ5SFZIOXpPWktuejl0OE54?=
 =?utf-8?B?QXFsOXBmbmdvVHh5Zy9iMGhOTTdBcEpnK1Z4ekFoVmg5cTBwUmYxTk5hOWdN?=
 =?utf-8?B?WThkcnZyZ0RRaDlzZFpWbTJkTTNSdThVbWdGc1J4bHB1akhyNlYvNkR2a2N0?=
 =?utf-8?B?bllzWkUwLy9uM1c0MEcrNUtqZDA2U3RSTlcrdjhoeU5HTTVpUWJpUXNmYWlr?=
 =?utf-8?B?UGF2b3ZGUUtuTzY1MDd6VU5laEFkU1A5cXgzYXQxcG9CYnlrNjZqeWVVeTdz?=
 =?utf-8?B?SU41UkxGNnhhWEdJT0xlQlBvU3d0MUJITlEwdEpaWnRCd2RublQ3SUhSWGE4?=
 =?utf-8?B?YmQ2VTl5YVhwSjlDQ3JBMlR2UE9GZ1NuWThER3pFTFlVbFc0ZExibmlHQmZE?=
 =?utf-8?B?ZnpYUFpibVh0VWZsMDhTWE9ZRVVwaGRBV01UYy96dENWQ1gvdXVJTE1NZGtq?=
 =?utf-8?B?YVNwZkVWUzNVRW9IK2xlTjRLcXJXMy9sL3NWMWd5RDJTZURrVG10NGlrVUl6?=
 =?utf-8?B?TFdockp3Q095WkJvSjNDWXlXK2ZqRmZLOVQ0RHdOTzZUbUxKc3E0VlRSblUz?=
 =?utf-8?B?SVRsWk9ORkdOQzM4Nk9oQkVEeDBIUzBLMWdrY2NSMytwMmM3aUJxelplZTV6?=
 =?utf-8?B?NjdyOWdkZUJRb3ZwVzNyb0VlaFpCZC9vdjZOZmxnZTU4bUJsNHNDMjIzaGdx?=
 =?utf-8?B?R0lMSk9NaFhLbk9OMGRPQm03emRWcEZ2T01QLzdGZGI3dTFvUURlTy9MYVZx?=
 =?utf-8?B?ZG1xTC9hVXNwQmdGczUwRW9mZDdDRjVXUDZhZnA5NG81emZpOXUwM2gycEhF?=
 =?utf-8?B?bmdMRFJuRjlPTWhTeUFzL1RjbjFZN3RlMStWTXBySzcrazdpdnhjaVJGZlFq?=
 =?utf-8?B?MUVnRlQzbzRSbzBUbkhwdGVaTSt2aEdXVE81TG92ZXRZbVNtaS82OHMxb0NY?=
 =?utf-8?B?c1VpdDBldlVVRFlKdktVUDllQVJpWVlQR05FOEk5YWIxVnI0bGcvSzlhRTFL?=
 =?utf-8?B?dXlLMHQzZ1U3a0lkSXFlRXc4VW5rdDhJQVNjSjBkYUlpWnlRSlAyYW0xRWdN?=
 =?utf-8?Q?OL2ue/vaJag=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzA4SXo3QXFWZjh3bVl2ZXk5R2c1Tk02alIzY0c5bldGRkVRdVRGZkQwNVlN?=
 =?utf-8?B?MnU1UzhmMzlWeHZPR1VLZnFpa3MxdVBhV0wzZEdGQXpmU1Q2bENRaDRVZnZD?=
 =?utf-8?B?TzU4TFMyeThMNTNrWHQvUHJ1cFhKRlZqRUFxdFhLclcrUjd6cFpHWFpwenVN?=
 =?utf-8?B?Vm9vV0Q4ODN1L3B1ajg0d3FubGdhL2ZyY3JOMGNkQTdRTUd2SmxNdThoOWZk?=
 =?utf-8?B?YVF1bG1yZzhUdE4rTGIrTkhkNW9saUkzV0h5VGZ3b2J4K3BvZVUveUFzYnFs?=
 =?utf-8?B?UGNYc1MxYk5JNUdja3JnTVpqNkV1OVVMUnRiTW1JKyt3ZkJJUmdHMTZVUVdz?=
 =?utf-8?B?MDBXb1I2VWw3eEJKNHVXTDdwZS9YK09YMGtHZHEzRUc3NEhnT0NlWCtWQ2tk?=
 =?utf-8?B?cXpFQUJmSjQ3TUl1WmhQWHJ4ZHprZ2VoYmQ1YkU5NXc2VWdYVHJRVVNDampY?=
 =?utf-8?B?Qytud3UvUFpzVm8za2kzWXhDT2V5RFNtaExYSnlPUU1mSU1FVGp1VVFMSHp1?=
 =?utf-8?B?cTRoWTNueWhXUFMrazBZanZ3OXBpR3FXWkhLUVdEOU16ZWNYTjVWMlI0UmdM?=
 =?utf-8?B?MWpaa3ZKSUxvTC9MVkl1MEgrd25xM2lHOUlYWFcxUGwyTXFEZUlrQjZ3N3NN?=
 =?utf-8?B?SUFDR2tySWVpblB3b1JnL2VuaHFzOHlTc2RRV1F6dDBEMVFKRTVTM0tEVGF4?=
 =?utf-8?B?bzgrdGdmRFh6TmlSVkUvY2NYbEFXd092dTRENXZZeFdsLzF4VU5rVmsvdUJy?=
 =?utf-8?B?Ym9EZlZKdFhYdENqZ3c3K2U5dDZIZE9uY0dWQkdqdzM1eXAweHd3QkErQmFk?=
 =?utf-8?B?blNidm04ZE0wdUNRai85RFFiM1VnSUUwTVNvT0JoaGI3TnRjOGd6Yjd3d05m?=
 =?utf-8?B?R0RWYVhVUko3b3RJZE16YzJpMGdJZEo1VW5qMzBYVzNDYTAvMkxwQXprbmJP?=
 =?utf-8?B?TGdaaUZMZy9CVm50V2xqNmZQdUpsNXVJbVlmR1Ria2JORWI4UTgzN0lDTTFM?=
 =?utf-8?B?VWdSR04rWDJOTDR0NEd4YldqWHdQQUxwendveWd4dFVvMWp2NWFXVHNKNTAr?=
 =?utf-8?B?YkFrTVZYU1k4LzkxWkJZZEptWUVRYmEyMVQ5ZzRKUDJsVkdhSGYwSkphOS92?=
 =?utf-8?B?aFlJamJxdjZTMDJ2Q2NjWnJBQWpYT2NvYkd3V0lhdFczSjkreHpGMVBJdHBK?=
 =?utf-8?B?WUYvYW9NUGx3bS9WSlBSeTJnTjdJNzU5QzE1K3BqbWsxRUp2Tm12UEtMRlpT?=
 =?utf-8?B?VlpkWDFmSFUxczY1UCtzcVE0ZGhmQnBZUk1oaC94UUI3ZVdyV3o2Y254SDJX?=
 =?utf-8?B?VWxQelFSS1E2MTZxOGNEZFUrMVc1cVNuRUJVUjI4bzFzMTRyMFlqaG1PVElv?=
 =?utf-8?B?d21NSGNJdkNoRy9oL0xDS2hLeHI1MFhjZXhRYWFJNjZEOU9HTmNZaW55TGQ2?=
 =?utf-8?B?ZlQwVGFiVUVWQkFJWGl3WWZyakVuMitlV1ZUWWxxUjNZVUZJSjk3UE5TL1o1?=
 =?utf-8?B?RTh4MUtVekpMNk1JdDIzZFVaZVJGamJnakZMMHNHeGhQa1BuMVNxTVlyM2Qx?=
 =?utf-8?B?Yk5FcCt6dmtQYzAzK0dkaEUwcnZZcUZwSWc2Vmw5NTkwWlFQZVFZOTJMVmlL?=
 =?utf-8?B?Zmh2L3kzWkY1aFhKNHlXZ1pxZFRLczJKZVBudW10ZUhETVZqVXg4N25JdDly?=
 =?utf-8?B?dUV1akYxSEdzTkZsMDR1R243NTFETG9UWTJ4Z0pialNSNkRWSGdmQ3I2alNU?=
 =?utf-8?B?dGt1eFcrUWM3VVhCbVNrcDhVMUtyZENWVjltVEpRSWFqa3lHYlVwQnpteWdF?=
 =?utf-8?B?SzlXM293WjBvY3gwbU5NTjBXWExNY1JQTnZ4akhtZTRvNTc2MU9CRlpPRGQr?=
 =?utf-8?B?U2xoQk9SbFFRZVFaa3FQcmh4YTF5Rk9MY2RXZEgzR2pSWGNBcFRqRE8rZ3gz?=
 =?utf-8?B?UTBJSVZlcFlTWk9GeGtKVkRRaU42SWloOW9oZFU0ZCtMRlBXaXVrSkF4elBH?=
 =?utf-8?B?SnZkemFZMEdyNlphR1pHUm4zelpFVGU2Z2s2bzVrV0ZKQ1ZmZDByU3l2VVRJ?=
 =?utf-8?B?Mm1OYzFLaUkvNms0dmorc3QyamFRbTBqcEhCRTNCV3FhNTNtNzZoVVNvYVVm?=
 =?utf-8?Q?zts9Y1pjGU0ChWjm0QH4UmgVK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oPcds4WTp5iKvWSLmes1+XGcKNBU836uavvOug6lnR15geGvS9z3kkgAZ9Cib9hLoXeWTgP8ayiaQqs7yijKG4JDebr2aNV638Rpw9eD9hJv5vnMRZaQvwvR0g++xw6oEPS3Kk+wJIS609PWa3pCtIwt0rrn/pQLq+I+CaqqKb4kGkpgVlOXY1ozoyd1g+0QNrkBYcAnegCBiWK9GgoG4E9PPIJULAafaThV5A8SkH7/7kiO9agpSK/T4SLxvU7NZfO0W3AxoSOGR31OolUydT5+rN0vo4iX9GottKdNz4eKqBPtgojIjkv2gBsUwnE5/x1J/LDJsSpDJ5pFFoK0bJ1KvzxQLzn80WHaDqu0n/8c2tLNsOAZ7A1KlbZnadBwvy3jYs+FPXSHsqExdCgvfIbs/pXaUvNdNZ3RKj3If3Ff7yENLzr9TwWirT++/Gd4pRbFb0+rpDRSLZcV0KFczLdYKFrayj8GMMqH/i14NBnDKO/98OcNDTPETpJew81dT0h3Zm/DSEV6JJl0o9RvxZstq8GCIcnwOwiAf5lfTRl3nJ4r8S+x/SkoYXAuvHvpWbIKVUHNLUo+BghRnN1y2tgVsA9InKgESjeyf//M+rw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea1362ef-0d46-4bb6-8a05-08ddbfc50a5c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 15:18:36.2342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+UxSDnB4mOMtTJwIetvJ99/5Zm+6WzF4opnksK2abvGbAIusCzEPRyODEpwdFJJ0DeaHTDH7z95t/lbuZHQsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-10_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507100132
X-Proofpoint-GUID: 12dmXway9fSaEmmlcV6OU6nRBL-euCqN
X-Authority-Analysis: v=2.4 cv=AJ0ISKLg c=1 sm=1 tr=0 ts=686fd9d1 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=DSrQnHEvFCCDL4XKmHIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzEwMDEzMSBTYWx0ZWRfX4wCvpxm+iQal 9GYh9e089Ylm4XVCrQgPm+AbPEaoXcNjcSrkn/dLamKkhR+wwT2F/u0nE1KiEkCjoBQUd4dDHZp SvSsDYLQ0/hrQzMPl0P4joHVu5l3yffdS82BiCz//NF1GVCimM8jIY4H53uI9i8RfdCbsXhkYq1
 kOy/G5wKbha/T6oBMS0YzZs4kKPBasIgMfLUSuqjZ2qInGCwGgihZKqCBkjBqkHPxEPHEPW4NLZ EyqTPi0biPALujfS1m2ZLbnSLJp22cLu6d47ldaWZCKIKVzp3xPaYFsAMZDLycJEmomgwYena3F cap39OP8qd4mH5M8Xz5niRYAQOCopJQ2gjyu+N+GxII9omieb3HLRf9UsmvHjZ+etpmpSBUzlYm
 haquZLFdCblp7QxLwSyLic8R5qnPkWlbrOoSgP52V7JS32E5Nm2EOPv3+ubdLKKRx3XAaM1E
X-Proofpoint-ORIG-GUID: 12dmXway9fSaEmmlcV6OU6nRBL-euCqN

On 10/07/2025 16:08, Jens Axboe wrote:
>> +	chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;
>> +	if (chunk_bytes) {
>> +		if (WARN_ON_ONCE(lim->atomic_write_hw_unit_max >
>> +			chunk_bytes))
>> +			goto unsupported;
>> +	}
> Unnecessary indentation here. Why not just:
> 
> 	chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;
> 	if (WARN_ON_ONCE(chunk_bytes &&
> 			 lim->atomic_write_hw_unit_max > chunk_bytes))
> 		goto unsupposed.
> 
> Also avoids splitting a comparison over multiple lines, which is always
> annoying to read.

ok, I can tidy that up.

Thanks,
John
