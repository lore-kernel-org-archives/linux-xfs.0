Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907872FB965;
	Mon, 24 Nov 2025 10:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763981882; cv=fail; b=YnEIs5hw99gFGZtmVGw3vxDAKseeySlB0TUR8OodglqqtCFb7mxSVOesrOCrJ04w98W7qus4vKk/2bA3WKaXWJqTh2GfsZxX4LhWt7eD/oKgTRQagg7jn0CI8EAc6e3E1O+za8h+coeUxL622RZowbpasmP3SpkrIPlkXVKte18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763981882; c=relaxed/simple;
	bh=1vnuKFNkIXzISM7hG65pNWCIAQ/gGDbhI0DvWoxqjlk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aL8b4Wo9zfmVPShkX7vbqKTA93hvLX5sbz0tVpTXWmIm92WZxCSgj4FFRz2DeTHEUJ9i6oyLEh83O9tX9nicl09noZdfl5yJYuhfQIJQAXaSo1KdcP0U3IVi7+V477TkZkIBdZyAQW6Ho/wbdo+ISZQEw1ckX793uyiiVWodlbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ri3d+TTA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lC98THc3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ri3d+TTA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lC98THc3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO8v4m6672382;
	Mon, 24 Nov 2025 10:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9hHiqMOzwsqj8ZqZ1s1sf32WqkfDVp6yU8/OeW30NS8=; b=
	Ri3d+TTAr5Y/5NcNDpirWxbAWSje/IFjA3QS+r350MNocMVkHZh3tjRVuKx23gix
	1CBLxfeIRQ30ZDf5XW6xsHz307q93eXmBP7WlPfn4LUO6mA+GzCAGU+MqeBNZd+M
	lmssPoTs425bVk71di4Z9YEjytbsxWaBi/0uGCL72Sw/Nn36MpBVSVU5evLKPZFL
	0LpGlBvepfWXp1UaORo7wqX+8AaVEosPykqMUu4bU028jV69xiA21XimPAMuyX7v
	UFjzQfLGIr6Axg+v9c8ubJSmGxSZTNOlRxt+gAFzikLzzLJ/T37u1H29bu8Z4YmF
	PyUqNhYoKnI6LhnOuSvdcA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fk1s0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 10:57:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO9oUuj021349;
	Mon, 24 Nov 2025 10:57:31 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m7yf50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 10:57:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JM7kewh9GDsZZmhJcheAzxYvUd439YRGHMrmxpRc50mujsMGKKftIXARkiUPK96t05Ypp667GO19S2cJw54COPMvAjh8mGyY58ZutbHgFkhvAXuYsDFf7vn2fmboytvqLHYUmNPqtkERCqX/FCFB76ml+iBkhhbHUJje/zTrJwoTvoPxyw7KGGhWD/TSztySfEZUVvt73vLThv356z34kN/HnD052hWhpFJf/RDLH5KVD4TMozoSaQTPFp0pLHK4LoA1l2ELWVWLysQdSf87g8vT/KwUh2LYfD03/fI5EpXL+Wdmsn4tSa+jvg4bGTi0zBGhiKI4T+7AyVKD70yybQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hHiqMOzwsqj8ZqZ1s1sf32WqkfDVp6yU8/OeW30NS8=;
 b=WVtAh5A249Wt+3keiECefBF5fLzKnFA+D9arZhL19hta1qGarpBpVhGQ9rkDHiWwzdCa0jw13u2L9A6J+W9rJexneWoOYCRs6WcZ1ZJ+PrdZNmVdvmTrI2rBfKlB7Yy/S1HmMSv1Q/ePtzs7anVD0AKL92DjNU0Nc45DfXeXv9iglSwmYBQ9EcRCztcPixgmWjs2pIGrfEdtZW76k6Xk9Z3KbCBsUOBsNr+OJ4GKeJLwsej1mX2spdfNNKQcktIXH9MKLYSUpfJ5MloEJgx78uO+rf6t1H5J9pYYF3hWYe830rxuPSOjA/vMrwz5ORV6hxTB//ZG4Z94GSDBUd7Kvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hHiqMOzwsqj8ZqZ1s1sf32WqkfDVp6yU8/OeW30NS8=;
 b=lC98THc3xzOLQGZ9ZPvHIcyNbQguQHUnxGZ4f38lQQyQq2mdFVbovDSTbVN/U3j8UOFUUwfyzv5+Kxdo7lJN56GW/9rzr/C3zywlJ3uxc8a88jT3kbgY8GfsZYARv7SRy6NpVhNL58NdUa+PCz0DojJ9ttqKmtaq853Wz/JSMDs=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA2PR10MB4698.namprd10.prod.outlook.com (2603:10b6:806:113::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.16; Mon, 24 Nov
 2025 10:57:27 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 10:57:27 +0000
Message-ID: <93b2420b-0bd8-4591-83eb-8976afec4550@oracle.com>
Date: Mon, 24 Nov 2025 10:57:24 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix confused tracepoints in
 xfs_reflink_end_atomic_cow()
To: Christoph Hellwig <hch@infradead.org>, alexjlzheng@gmail.com
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinliang Zheng <alexjlzheng@tencent.com>
References: <20251121115656.8796-1-alexjlzheng@tencent.com>
 <aSQmomhODBHTip8j@infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aSQmomhODBHTip8j@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0157.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::14) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA2PR10MB4698:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a2ca0dc-16cf-4dcb-0c8a-08de2b484167
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGJJTlBlV1lOMXhnVkdOcHJNQ2RMV2toam5odDRnYjdNOFByTGg4RUxHK2s3?=
 =?utf-8?B?dGxIR1ltNDhOZjgzZzNxK2VmRDNsT3JEdFQwMDlDWjZVZE43bUF6WEhwVlBG?=
 =?utf-8?B?TWFieWUxZmFVVnpzZmFxaTVkOEk1WjhPZFhrZ3dIRHl2Q1IrNnhFVndQUDNv?=
 =?utf-8?B?bnRzLzM4MVZqcDRWaHQyMEVLV1hxSVVZWFBUUngyU1YyQmp2a2xqcUJjRzRQ?=
 =?utf-8?B?enF1cS9jV1FWZkxETDJVWnJOUTlmSXNXaDNyR2o4TXU5MnlVWmsrTFZoMWc2?=
 =?utf-8?B?RnZTQUhkYTh1RTZpVXpYbDZPb2UvOEE0Y0JwRExwUnBxYUNkNWQ2czFYVUNI?=
 =?utf-8?B?Ri8wMmE1TjZmdC9Yc1lkRjhENHFZZDZybkhCZHNzckM3K2lFZkUvbFVqWXpv?=
 =?utf-8?B?bWpOTERXQ3RKOU9wK1BnbkFwdkZtQkczSVNkMWphYTlpZ2dOaW1icGVMMS9L?=
 =?utf-8?B?bGlieXhxNkl0cW9Ea3gzQjBKZzAvSy90VVIyeG9ZR1BrMENmdHorbEJ1MjhH?=
 =?utf-8?B?Zm4xVStjSktQZkJLZFBWN0t4dUVvUUl6ZloycGVwa1RJWDNWNEk3L1dDMVlU?=
 =?utf-8?B?enVTZk8vajZWT1FsNy9HbGpGdkN0ZzlTeGJIdGtBaHhCMGVIWXhvYllMUFNU?=
 =?utf-8?B?Q3RKWkVXQUpYWHc4Ym94OEhkTElUWmJwbjE0blJDaUNrZFpIWUpXZUtBQU40?=
 =?utf-8?B?SllKL3dsR0Q5SmdtTnc5QkwwRjVGL3lEMFEzejNBQVRDTFBnREg4R2RCbzFR?=
 =?utf-8?B?eklJellRbTNiRWNlUC9hVXVGME1NMVNPa0VSYVIwVVFJRDFOYlJGbEMwMkNl?=
 =?utf-8?B?UlJIdTB4MUdkc1VPVG9VTTNTM0s1UW1kanRTYWk1aE5kSDQxRW9aSGZWTFJI?=
 =?utf-8?B?ZWViUStRVjFsMHhpckkrVlJlZjJ0dEFYdFRJUzhQM1QyZDAvNTRiL1NadExu?=
 =?utf-8?B?WmdxbTR2QzlOUDZrU1lTTHpuMFVaMWJabWF1eXZ5VGNGSjF5SjhPTmxaWk1R?=
 =?utf-8?B?MHRkZTlwMHQzRUo1N1d2ZS9oa1lWc1hoTFNVVHlqcTBnREJmWHpScVRBcWFL?=
 =?utf-8?B?NnRWb3NBSTR1L1BTZWtNL0lVZE16RGEvUm16Q21lTE5NcCtFRUQrRi8zTFlx?=
 =?utf-8?B?QVdOblpkKy9OOHFwL3RrUXJYTnlkbFYxZ2t1aWNLeVlOZk8yTG1hL0tlYWlC?=
 =?utf-8?B?SENiY0JuOUR5cEtCRGxZaVlUUS9NOVA2SEI2aHdTS3NGaWlHcFpOV08rQjB6?=
 =?utf-8?B?ZGJvcDhxTng1QjFmWTlDTEZMZGJFdFJXK1RHTFFBbWR0TEdid21BeXY3VFM2?=
 =?utf-8?B?b2VUeEgyZ0lMMHFURGdBSTQxRWdEZzhpeWxGVnZzbkt4RXh4WXRsNmNnc3k0?=
 =?utf-8?B?Vys0MHg5RFJ3TWd2NmRLWjlDZ2MxZzM1Q0lBZ2lhMlNsMmU1SnZCbWZ0a0w1?=
 =?utf-8?B?am9kWGZocW1YNDhVbnh4NU4zYzVtbmFNQ3RDdnJzT1ZWN2Ftd21tTExjQkt4?=
 =?utf-8?B?ZWVycGppeUdkWjR3VmFKU2lESWxTL1V2d0JaU3RZUDQ5VzZSVE9zSjJOWXhM?=
 =?utf-8?B?N3FQUDlvc2IyYXJHblRjcFZpMURPZnpCMDFJRE1vNmFVYmppVlF6bWllUzJk?=
 =?utf-8?B?cWNZSGh4VWJkeHdURSs2enV5Z0htandvQlAwaDV6TWRtYnJqZVp5ZmlwSHZy?=
 =?utf-8?B?aFV5WTZQMENsQ1N1eUZjVFdDaXRXSW50S21pWjZOS0N3SzBLM1d3UnpaRXlq?=
 =?utf-8?B?NWROUHpZK2pvMWMwbDJYa2dyd0s5cTVkc1VXYStlVVZYOGtmTFQ3alhmNThh?=
 =?utf-8?B?Y05BOUtLNmRWUC9YUUI1dTZCVW5Id3MyQlFNdUtPMGFsaDFhNE5EUHIrT1VO?=
 =?utf-8?B?L1hKNUlGVnpOaXFGWWQraTltS3JJOWY1NDVrZW8vYUtPV3pxNkVvYmxTcE43?=
 =?utf-8?Q?yjraUGphgQVSWvbS0njphLgLn2bFvKhn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGJwZmE2YkxOYnRrWGJ2bi9PR3B5UU1HRmRhMHZYYzU4a3JDKytjd1VRUG1E?=
 =?utf-8?B?c2s2M1o1QnVtWjY5RWM0WXNRZ1dQQzkvVWtCVjhGaDJBSndYVzd5cmZwcHdL?=
 =?utf-8?B?bCtldFNYNDFENG5jaUViaVp6ZnVNbGJrUUFNWWNJeitnYlF0U1lDckVsSVBs?=
 =?utf-8?B?Wkh3dmVZK2Y3QzNTczBDRXI1RTZyeituV0RHZUJUY0o5TElWdlpJV2duZ0VE?=
 =?utf-8?B?Z0liRnFPN0cvM1dleXlrKyt1QU4wazVaVHNGYmdRWVVpU3NnRzR1VXlUZ2xU?=
 =?utf-8?B?c21Fb3M3UWUzMllyUmRka3FBaWpRQm1UWTR3eXNXM2QwMGlLZWFYV2hnUUh1?=
 =?utf-8?B?WVpzMXdKQngyeXJ0OStObU9zcFBxMGdiUUZ3czFYaDVZVGVHeHBlMmZ6Y2ZH?=
 =?utf-8?B?Yk9aVjVvNmQrZ3UrRFVkL2xFbldqQVcyYjl3eGtXaTU2Y1NWUUVwNUJHNklS?=
 =?utf-8?B?Rmp0c1VMR2diaWgwREZNbDZJY3NDSXM0cFp6V0swQk0zeVV6SEY5MnAvUzdL?=
 =?utf-8?B?VDMzamJ2K1Q5a3lYSlNCM3VnSWozNG8rZkpNbVEvTCs3SU5LOWtOcTg4VzNt?=
 =?utf-8?B?ZXNJK0VnOERIUjZ6azZHVEw4NW5peHFSSEJIbWdmakpGeDJzUjNMazlyT0Yy?=
 =?utf-8?B?N2g2YjBsN1B3UmpKSUpVeThnTUZ6TzZhb01mTkYxS0lJbTM5VTYraVdtWE12?=
 =?utf-8?B?WGF6a0RGNGNvQTVQNVpOVVlQa0dEUU1VZ3Bsc1Bzc1VQaW9Vd1hIcVhPRlgw?=
 =?utf-8?B?UWhXTHUvc2FIaU9mWmhkYlZ3Q1ZMMEJORU44SnJSRVR6UjlDdWhVSHM3WGVN?=
 =?utf-8?B?RS9FVzYvRzhzcDdPMklCTi9wRXI2eGNrdlMrTmZReGJIN1dqNHdYVnNtVWlq?=
 =?utf-8?B?WTFrdWV5L2tEVERwNHdOVnlPVWk1UzFGNEZTV2NQY3JDVnZnYkxxRWlxSVoz?=
 =?utf-8?B?eVZaTEtQV0JTNlY3b3gwVW9JdG5MUTk2WnB1WWoyd1ViNXpGZkRRVlNNWjdL?=
 =?utf-8?B?dENKVEFCQWZ6VVhqMnNRNGRtcXhLK1JXcUJmSEhxQzZrUGFCcGVVWFUrcC9v?=
 =?utf-8?B?YVppNEJtUDN2aWl3UDRERlJ0eWltbDhRT3RQZmhOWERHRWRJNUdnTExrbkpM?=
 =?utf-8?B?eFEzRk1MN2Z5THdobzJPMHBlMkFqN3laL2NPYjE4SVJHVUt3V2RrTWRwVzha?=
 =?utf-8?B?MEx2bCsrQmJDQy9BdnRwdXlXYzYwTTdDK0VFMS9WNERDY09ic0UzYmVhZi93?=
 =?utf-8?B?bVFOOE9Mbm5LbUM5ZGI1dFhzR0Uza0F0ZC9XSStjMGdVcEVYaVh6LzdWYWNL?=
 =?utf-8?B?SEQwWERLRnBZeVRzSjhvNm1nYzNWUTMzb2ExNWdxS1pIUXBXZEtIU1ZOMVY2?=
 =?utf-8?B?bm1scTdJWUxRZTZ4MFJ6elZ2NnQ2QzUwWGEvQzgyYmowVWU3YUJtTFdBdWo3?=
 =?utf-8?B?dXdKU3lPYVJMb2tkbDhFNlFiaXFtbDdNWU1YWEVhRmdNaTRCZHVjVitHZW1E?=
 =?utf-8?B?WkVCaFBiNFJ6b2dIdklod0Q0QU5BNGllL3RpaHQxT3hhODFqVUo3WGh0QzN2?=
 =?utf-8?B?dWhqckIzckZSbm96c3NzNHBMRFYvaEdUcisvaDJ0aVNtYnBtamRMVXJ2NHlC?=
 =?utf-8?B?WGozbGtKOWEyRDJDcG5LWm1zQ2xuOVQ4bzRPZ2piZWhxZjliUTd5bWtFemZy?=
 =?utf-8?B?OEkrMkxHazd2R1VXVGl2VU90THpucDFPc3J5SmozMG9NRTBSYkE2TmlNY1A3?=
 =?utf-8?B?MUUxRVJrTDI3dUNMb2ltNnN6K1Q2YWZ4cWZZVTNuUzVrQ2xUMll6Z1ZPTVky?=
 =?utf-8?B?TzhhWlBMb1JvQ3YwMFZuVncrS2xSbTVVR1pockRRTHFTb2w1VERNdGI0WW1w?=
 =?utf-8?B?WThDdTRmdnBwa1VWa0dnTWkvNTltYXNITyt3dHY4emFQckZ3OWVONHJBdnYy?=
 =?utf-8?B?cDFXYkRwVDFwTk1vVy9kRzk1MUM2UVpkRUJvOGRJNndNU3dnZ2w3WVpmcW1p?=
 =?utf-8?B?V1JkZE1oVTlmajdrU09jSEEwbUNPNkN5ekRBbEEyRUdZYTFOK1k4WW54bTBk?=
 =?utf-8?B?UGNwd0Q3Zm90RlpvdWY2Q2t1dVh4UGtUL3VvMzJDMmdMSXYrMWVEZ3NVWm01?=
 =?utf-8?B?VDBlb0RiVFRDU1JHMzJSeDVoeUhuQjU0dXgrdmx2M1FQNk1rMWdSc2l0Q2R2?=
 =?utf-8?B?WHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KCwIYordN/rgH32KY+crNM++/RTzH5vhxY86yLTq7G4HJWm5g1czJMicpkzOtRmKRl2yC2g7+8gnUz/pmCnavDwroKIermXdOMX5m9POyPaNXp+IEBT/BlX1hvpT4PbwxjoYZ62vNtS1k1g6DwYFLZzZxIxq09tlWI+mgd0dSeeKlETu6RZxilwKA+foFEIkGrMki8NroAYaCUbXE3q3VsUsjk4vdovRf56gayX9NGSwGk5QSdIK21ajDgyykoOoG6Q2XqNo7hiF2m81Nr9D94jdt7XTEttpAvcqpL8gZxaLaT1W+0HysrKNSFk2JikLp1bmk9amNexaqLtaEw2FYiNCFdMIRTFCTYmeWbp5MdHN6IWjJs5fbmCEaSnWIOZzpAJHK1LEBLZe4nTQeljqIX4xO8hWezI8Dl4Ao5VokRv+F/xnMozoawMU0U2jCcvxDDvy1xEkjiYfXMNf+OHOjuUulMueazYGGEV3ma0YZV6rj9OwqJOQ2VNq4c3C0mAdvppcW8GxbCbXFRVRDdBD4+U5K09yenZ8lIc6btX0jzQGnvLdpFXzpxUFa1/+hDObp9h43XWmFpJJ+WkmDpCx2H+GP2+fLcGzy2b5pcTl+QI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a2ca0dc-16cf-4dcb-0c8a-08de2b484167
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 10:57:27.0042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KIRo/P+B5YdZYgikZ8kvCznz/m83f0HGTneXHMJQRnOL0fTqGOogzf+38pexVoZdChFpoaSmWslqnsx86hAo1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511240096
X-Proofpoint-GUID: 8Qoenw_BCXvgQu0Nr-tGXaqhzRoghF8y
X-Proofpoint-ORIG-GUID: 8Qoenw_BCXvgQu0Nr-tGXaqhzRoghF8y
X-Authority-Analysis: v=2.4 cv=L+8QguT8 c=1 sm=1 tr=0 ts=69243a1b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8 a=yPCof4ZbAAAA:8 a=W5EbbYx5N-b6_BxYzscA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA5NyBTYWx0ZWRfX4rUUkWVp0wqt
 ME5lZdtwETGwrI2ZcPCSc3lE+U4jaWbKMbxubwrAxLaGbwGclR5uGBSAFnV9tTvNRQzcfCIlXeR
 DS55XEKyGW9UiFaOLrsU2KoM1WuCzL9uNxmyNImvCcGRXVObZE9FuE3BFww9SAsH2m9ZQImi95n
 stQEjMoEozfRknsnCJ4y9428olc2OmfDyahhMU3uj192ANvR5ZfyOn8WVCXvAqFq04RMMN3y4TZ
 dfc38+/KkcNcjVpGLbf/a6ESTJUvDISyC6gGpdAdVwjN1e8wwmwBQYIJexsqRkHypJhxxN09Sht
 ssexBI/SwlUEM9nJnf2jkHQ7SlyjdJs1r0vLHF1VDZF9wDPd44xUkVm+MeFQcnPoAHIovWzi33G
 gfPwxo6P6XJIG+xlj3OdWhrYUiw99Q==

On 24/11/2025 09:34, Christoph Hellwig wrote:
> On Fri, Nov 21, 2025 at 07:56:56PM +0800, alexjlzheng@gmail.com wrote:
>> From: Jinliang Zheng <alexjlzheng@tencent.com>
>>
>> The commit b1e09178b73a ("xfs: commit CoW-based atomic writes atomically")
>> introduced xfs_reflink_end_atomic_cow() for atomic CoW-based writes, but
>> it used the same tracepoint as xfs_reflink_end_cow(), making trace logs
>> ambiguous.
>>
>> This patch adds two new tracepoints trace_xfs_reflink_end_atomic_cow() and
>> trace_xfs_reflink_end_atomic_cow_error() to distinguish them.
> 
> Confused sounds a bit strong, 

Yeah, maybe "ambiguous" could be a better word.

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> but otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Semi-related:  back when this code was added I asked why we're not
> using the transaction / defer ops chaining even for normale reflink
> completions, as it should be just as efficient and that way we have
> less code to maintain and less diverging code paths.  Or am I missing
> something?

Commit d6f215f35963 might be able to explain that.
