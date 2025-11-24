Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9772A1C7;
	Mon, 24 Nov 2025 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763994367; cv=fail; b=KN2oPketEwtHiyAZSBhoosqdyAxWzR5aVV8FhQ42BfEfNPwqeuARQrdlz5MEEZzI+kjprp1NNk7RwQ7TqOwdqgZBy2xY+B7Js9I/yvN9EhuquSVNzg+Bn6TSLdWHd4+ckaYzJX6gaa7c8fg6JnI9gmfNOX8NWYH0Df1QeazywCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763994367; c=relaxed/simple;
	bh=RfqIr3kDHfJwPqSHk88Tu+3l22mQwoQj6Da0CfxLhs0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OdFxkLqQDd35xbgNLUgdnmOkW7D72TUt/Dw05RibQaJUqHUwxkGp3Ie6EoUODITxJao9ZLdMXOYrDntnOsqZ2mFNc94Ou7Txd+BtYTtBZMexB7mayQc1QluA3PpCAh8FBNB8MfbkN6ZIOnARFqTR6WygMdbypxmHISQB4MBo+Bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jPlL+pxL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GBeXyEnj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jPlL+pxL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GBeXyEnj"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AOCVGIv1085645;
	Mon, 24 Nov 2025 14:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HCGh2BYJr2SMwwY3rhdff/MLNmjOGNfZXpf8NAySRms=; b=
	jPlL+pxLJ8VGsipc2F2KEWD6gOM15w/JSuKl+IIfqlKFNGhinyJ4GMjdwJk+8CsM
	PXWH54dP0VYQqZLQwkVi3mSGJsDgD52GU2pnvMl/TFc3Qig4A98jj3cUL5kppNP7
	/fG/uyyS+K1NyDSrqNSghfyYuCCM79koLdQLU40+FdLW7T8hV9nkkk2UfWRkPK+Y
	VuZL8Mozfrpm4O8BgMOZpuioTXhL2Ekc3kxgqBS+yadHchfUZBi3YZz4+oXJ+PZO
	CC8LOBlAv01/oIweQL64JHqnJucQaz09phXrLVy9kwg0fUpFVYKWS/oh54QNdeiD
	4OPwNRBP7Hxebvwf4SWSxg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7xd23xa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 14:25:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOEFZTb022658;
	Mon, 24 Nov 2025 14:25:36 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011049.outbound.protection.outlook.com [40.93.194.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mj6g57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 14:25:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K+zwAxVilEr6hf4h1LUkfaShNbqk5rkdGsRP3tz+ks9gTRBnZK31MsskGAJSaGdwQBI9ZUm+QIVT994kp6JNBVq1JITPC341FtrgDxlWEBDczcwBdwMBOqLcGDDImoyjqlvugSgiC3HDEJKXxP3NuNEL4v0MI9kbMCtgYSkJ8zOVycY2gkqzjvfDmoY4Taxj55IVQKDKRthkMbqVR9S9kSzpAEPVsM7oo3c3LGQtGbetLph+jipn/6LEleW0CEE7hmrwMIAEHCXtzm57vrRfmByhlrehEzDNd4XqYhihduVULqKPPOLJxguwJZ1/r4J0OTGZ7MXKDxBO4FpsPWuwuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HCGh2BYJr2SMwwY3rhdff/MLNmjOGNfZXpf8NAySRms=;
 b=KvilhjkuApmecGWb36E+Wu4BgmJ1YDS57jSuF/gy/BSsITXZsvW8cc8gJZwNnFhdzcXAUmC3XXDJYqiRyv9zUayS5WTXoCXMMzyA/Y7GXJLmK9zwqZfZYTvKAHgIIeU5muRHel6ro/pIPQWP0vb05jn+cAE1DhBMv5UDEg0OIyT9yifTysaOFAaNj6IFtfXwSYy8Leq4zw1F3ADSJUIPfFGEQtB5XToBu7vUqq7PWOXP4RbbxLwUUIM0CUM11qxu5wfsUOhocs0MNEN381xk7rXnmekhX0yASPQaQk70hZC1cWCwcC2IudT85NUZzKATAkuiZ5oJp7pVB4I4E9a4cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCGh2BYJr2SMwwY3rhdff/MLNmjOGNfZXpf8NAySRms=;
 b=GBeXyEnjg0ERuzDVmNQfSCP8BsNkKnZ2FIvbpcVwY1ItDXc9IKuPfdqmfPUJYKgBzLEA0zwMBLdlF37/5g3xiGLwznVSRuO6X9YHnrsn5TrNkEph8EYkbLu6B0ghAisxnVq0M5NhiDxst2/j7aK4PRUpbnKNkgtpPluvljx4KII=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB7693.namprd10.prod.outlook.com (2603:10b6:510:2e5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 14:25:32 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 14:25:32 +0000
Message-ID: <2ef7123a-cfc7-40b5-beb3-e23db1a0d75f@oracle.com>
Date: Mon, 24 Nov 2025 14:25:29 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix confused tracepoints in
 xfs_reflink_end_atomic_cow()
To: Christoph Hellwig <hch@infradead.org>
Cc: alexjlzheng@gmail.com, cem@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jinliang Zheng <alexjlzheng@tencent.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
References: <20251121115656.8796-1-alexjlzheng@tencent.com>
 <aSQmomhODBHTip8j@infradead.org>
 <93b2420b-0bd8-4591-83eb-8976afec4550@oracle.com>
 <aSRmCPKBOpSaAYYN@infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aSRmCPKBOpSaAYYN@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0285.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB7693:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ac61d8d-b67d-4563-f69a-08de2b65530f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVUyeUJ2WVRNbnFOMU5XbGNrT09weXFoWUd0ZEt6aDU5SnNBVFpvamhnVmJt?=
 =?utf-8?B?blVZdE55ODBXR3VmSnJ4dVZ3ZzFXMWVxVVFBOHVMbmpxVjdIMlBrL25UQzNE?=
 =?utf-8?B?dnBCcTFITnExQ2J3dVJ3bjhDZmoxaDhYWi9zOWxWRFFFdmcyUjE4K29VN2JN?=
 =?utf-8?B?NkNCM3I0a241aDlDSjF6RS90NFdoRjhJVTg0bXBvNndqMi9FRGpXdTMzUWY1?=
 =?utf-8?B?a0pzZTM1dEhiTzRCUGtkZEhFNm9uWnBudVJuWVJndEIvOHhkNkRaVDFITE9P?=
 =?utf-8?B?NnNDMVIvR3VvKzU1dXRSQklKVkJRUnovUzdNcVRzdjBuQXp3dXRqdFR3YTR4?=
 =?utf-8?B?T2ZuTGM1djA4YnQwZHNRVUhWUk9TSnFtU0RzekJ1K3hGMDhKb05HdU5BYkJv?=
 =?utf-8?B?M2pmcUtpSXZKbU5OTUwwQUl1S1p1OURZYUpkeGE4U3RNVExQMFZnUUJiamti?=
 =?utf-8?B?YmNCMlBuaHNiL2tPZTdsTzZma3pyZHFHeW40dmJiWGhaQzhoUG1sL2ZwUWpU?=
 =?utf-8?B?QnVmSzNkbjNMYW9weVFZYlVFeGJxRWFpQUM0Zk5LWEx5SEFhTUZTVE9iaHRX?=
 =?utf-8?B?KzZXM0dwcHoyY3V1VWhScnhQMGIxYXNoK0ZndzJzVkU5MGlwNzJZOUU3OEU3?=
 =?utf-8?B?NWN5Q243eGJDOC9ZbGY2alBtU0JVSWd2ZVRDNmcrdDJKOXZCY2crU3doQ3pG?=
 =?utf-8?B?UDRYNlE2UXU5UTdKYTg2Yy9xQlBIRkFQUGpZcTVlbE16UXhkWWlEVDF6OEsy?=
 =?utf-8?B?OE43YlNPR2x2L1p3eDdJVENRd0hDYXRmMGt2aU8vcGhHZE4vZkZkSVhiS0wr?=
 =?utf-8?B?bWpNbFgrNzFFTmhEQnUvVzJUSDFyQncybVNFM29sYlRrNFBlL2hpMTJNNmRX?=
 =?utf-8?B?OHNPNGhpdjZXY3hSdHR5bkszRTFOTTV3MUpmblcwME85RUNVYkRtWXZKUnha?=
 =?utf-8?B?MnNxbHA3RGdMUTNjOG5pZkNDM29HSVExeFp6cGhkZktOYVpPalJnUUV1cTF3?=
 =?utf-8?B?dU5xcHhMRmpEazQzd0JmL2VwbzYva1QyMVpjd2xtMDNCMVhuOVpIQmt4S2pB?=
 =?utf-8?B?emQ3QnNjR3I0SmlpUEpYOE55L3Qva2FoY0tHSENEU1dqdVBKS2QwVmo4SWo0?=
 =?utf-8?B?Z0pxOEJJNmVYZGVHN0cySllOWTlwcGVaQVJmcXU4UGVyQWNoMkFvYlZyTHNs?=
 =?utf-8?B?RlV2bHdvN3I0aDdyUG5qZ2plUGR2VUZkV001dzJrZ2xaa205YXFZbFRTdTU2?=
 =?utf-8?B?RXFGeGljUmEyVkEwS2kzVU9XNFg5SllQL3JFVTA0MmxMaCtsWWVGcnlhb2xD?=
 =?utf-8?B?TDBTZXEvejNtRHVpUEdpSC80SVhQTDBSR3FZNHczOG9iV0IyZU1jUUtzenl0?=
 =?utf-8?B?SDBGcStMYWlqK0JrVXhxTEcwT0laMloxNy9hVEpnR0hHSGJYd1hjRW9oQ3Ft?=
 =?utf-8?B?d0RWOEJJakFTa01UN204VUo5Qk1hc3RZWlFMdk82MzhWckxsNGdabGIvTFh0?=
 =?utf-8?B?bFZLcHVrOVNCbWliajZMYkhaOWZ0aVVLSkdYcmFZclZDU3QzK245YXNtQUd5?=
 =?utf-8?B?c2ZxWm95R09aQ2FJaUpwMlJnYnNiWlRCNzZTWkFSam1MejRBZmxsSm8rbkVx?=
 =?utf-8?B?SWtCRXpFcUFFeVltK05FbUIrQ3J2NXNBcU41SU93amNZaXhRdTh2NC8rbU05?=
 =?utf-8?B?TmxnVWVaM0ZVcUdTdEpDZ1ppMTBaeWd4dkJDTWphVC9yekNVUE16WWFRb0dF?=
 =?utf-8?B?U3JtSWVuVHljQWhzOWtDanprbXJOeXZLUGV2bkFFbU9RSVJKeWs0UlYrSUNL?=
 =?utf-8?B?dXAxRnMrSWJrRzBGTElEVmpvOXRieFNZemVySm90Z1hiUVRKSTk4OHE3bDNi?=
 =?utf-8?B?NVpjSStYZTRiblNTKzh6cWtFQUxOclZMUnlZbDZuMGdxeXJ5WXhicjkvQUJ3?=
 =?utf-8?Q?0GusjkWLxeXBj6AZMvd57/QcPuYscn4q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmFMTm9obVNPU3Z6L0UyQmtHTnFEYXN5OGZlYzgxNjlVV1p3cUtveXYyNm1V?=
 =?utf-8?B?QnBjQVlKcmF3VVVBVU05ZUdjYmlxdWFlWSs4YUZEdkhlMEtmdUhqNSs1cndp?=
 =?utf-8?B?dXh6WFhsR2Nmd2d2OWhLOWc4eTJIeW5NQnY0SkhmbGNMbXVnR21BaHdENG82?=
 =?utf-8?B?YStOaklKdmhkSEtOaTBTT015WUs3TFRlK05EckNZeGdpcjlQVzR4bE8vbi9h?=
 =?utf-8?B?YUcxaTZiZnVBRjBHU0JjaS9TbGVMMFFhamlaeVNhK3BGZG9zWEt1c1VFTlFo?=
 =?utf-8?B?Z0l1VjkrSURvVDB3ZU9oZTVjTHVXZ2UzdzRKS3UvekEvMTRqUWVYaHBrVlE1?=
 =?utf-8?B?Z3RmMmVmeXNjWlMyQld3YlVKTVo4QXpJMzNpZWFKVGl2M1FBRmVkMnRZNkc2?=
 =?utf-8?B?RFUwSm0xc1FqS0hhK0o5TFBad2R6WFp4L2JSUHBhVXdTWXArTzYzSEdNRlRS?=
 =?utf-8?B?WkorS3F6cjZzNlJXbG9WZGl5V3c0L1J3ZDA2RWl5amN6MytzaEl0RkowWDJC?=
 =?utf-8?B?MkdOeU1IbGwzRm1MeUxMSFZBbiswbzVJVzhWcnZSVnBpa0xuNUhyQkM2eUxl?=
 =?utf-8?B?aWtERlJ5VDVvdlhTQ2NPalNVcVprL2VqaE16MjdaWS85VE55R0RBMFF5ME1r?=
 =?utf-8?B?U2RDamRWbmRRWjllN0RWczcwMGQrV1NkaWZsMFI2YTBVcXNGLzFUS3JQS0Iv?=
 =?utf-8?B?QlE4QVJ4Z015WFZqcjFPdDNpdXVFQlFoTmp1cDhjeitPa0hKTlJIZHlHSE1H?=
 =?utf-8?B?dG4vU3VwVmhJYzdRandJZmVWSmpJeWM0WnhMUEtaWGVWb0xHRy9rU2NYdEhD?=
 =?utf-8?B?aDhjb0NaVGdjYWQ0SGhNamtuNG9Hd01VYmViSlN6dWE3bzhhakFEQ1piUFY0?=
 =?utf-8?B?N0JZZVJ6eXJtS2U4QmF6L3pOWnN3UHMyTWhZMHZ3UVUzRkk2K2hJN01DN0lC?=
 =?utf-8?B?UFpraUJWVGFLSm9qS0ZXQTU4WUpZdUovRDB5SU9OMnR1bVZnOE9NNG5wV3pE?=
 =?utf-8?B?Z0o3Tm0rajNjZWhqa1JFSUg1eEY2OHpiUzd4b0JFNENZRzVrZXhvYitGYkJr?=
 =?utf-8?B?VUVJbkdwYWlobUpDMzd6eFlwQ0VFOHFvUHNYTTVUS0xYcmVIWml2TGVZNHl6?=
 =?utf-8?B?cDE0S1V0QzNmNzg3WVEwYTJiV25ZQkpZYlM1UnZCZDc1MkllY3YyMTFPRzZD?=
 =?utf-8?B?ME4wd285NStGRXljUU01K0diVlBnV0phN1BpSE5NcktWT0F0c1hhVXROTmcw?=
 =?utf-8?B?eS9VTDlXc0hJRllaM1Uxb01Hb0ZsNjRiYnNWQXNSOEx4NVpQb1BDNDZCcFV2?=
 =?utf-8?B?dVZIUnlGenlEbEZ1bWlpTHN5SDhPb1pmaWdOR0R5MzYwaktkakQ5cVo5MmVx?=
 =?utf-8?B?eTN1WWVCdTFPbUZqZ1V6Qm91bVhPR2FYZDNnMnBnU2xoM091WE5jQlFFOWp1?=
 =?utf-8?B?ZFFsN3ZOZTZFVExpb0JYVmp3V0NuUFMzRk8yUnc4dFJFSEdndkYvUU16Q3FG?=
 =?utf-8?B?dDRZSi94UkNrdVZHTXBvODJ3QjA2NXU3NHVrTjhRNHpRN09JMmF4QzBZZXhL?=
 =?utf-8?B?WE1Pb3UvTTBZSDgvc1BYalFGWHAvUm9CYzZidnNqbnFxOUV3OE9ZU21ZK3da?=
 =?utf-8?B?cWxIUW5INDdaR3J5d0RqWXhzT1VVaGVZdjc2bG9mYmw3RVZOTkEzR1pQUnho?=
 =?utf-8?B?QzVEUjRsQ1RVazZXTWZucC9YN25LcDhsRldCM3E0S2RKMERmdmxBaU5XWkM0?=
 =?utf-8?B?VTBRaG0zS1M0aDAvTFBiRC8yN2tpekVKaGJPcVZWcDJFWEZvSkc5L211NFFU?=
 =?utf-8?B?TmpJTk5icUc2K2dsTGlabEZhcGtLNXBtYnNzWHFvbmdDU2lFdzM3ZWxNZ1Iv?=
 =?utf-8?B?QVVycFFOamNYOUlEWDV2NVRYMmp5ZTdsOHcxemY0TkEybHk0aTkvcWpoUXly?=
 =?utf-8?B?eGZaSFFEMEJpck1WV1JxL1h4SWFhRkZiYkdtRURoRWZ1WkU4UnlpTWJzei9h?=
 =?utf-8?B?QkoxQWxuZ2dleS9lZmpwdGswOWt1RkJ4MnBQUTJSS1VxU0ZDK3NYY09aQXI3?=
 =?utf-8?B?SHlXL2YrZHBmS2YvU3I3Y3ZJU0kvbDZybFhlSm1ObUxha1NSRDJhbjdWclhQ?=
 =?utf-8?B?NnpxWmg2MFVMdExPanc5QXo2T0NLVUVUYmJkWUxmZm4xQmhuS3o2Vy9qTlFU?=
 =?utf-8?B?ekE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qyxMtd1KeEdnM1lCgV7W+AUiJaAZsF2Mog37j9eYB75g+qb9Ihxfs2MA7LGQcxo/kBfqF4ijzLqxjRJxdhEdkuF7qz3kitSrayYKWRJujJq9L4QxkW+Cg3EnxS1DjCSq3MsSThYcg2heNqlAAjuZGWEkR82jBI3glcYQGCSeGz2QRcCEw0mIiXCb8RmNTZ8tS9wP0IbIfFCu3STrjJ/HJP8ET+AQivFtbhiY9cGRzI+oBIALjuXmfX/yzsVtZSevo86n1SkZ1VOQAZ03KK8dcx+tyRaWTpBABh0lGoqYgpHu64c+a/qpXyr8zFJPjN+QouReqLltY/xrpdiJ7X2y94zD+U01YaUp/ya7WXz47bPUcwngoS3eY8ab8TlZRM92huCPoFAXCldzP97mT20XiKChC0stFa9OJRUHVedvl///X20qS8BgsR1qvWVz++cRmZZOh7xB3XaIc3KydoxB/xOSjlEHZ7cO0LZXWagG6MZHHRbKlgYx+YL7YQ2loJqIzTr/3lFT57YBLMlVB7bacD5cA5Ug5EertwqrLoGhaEnUM0J2Ca04nXQbCUP9Cp9b3WJOvejaYf+ACLgl4/7KKtWM43dH/cTbydTeKHXwK+M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac61d8d-b67d-4563-f69a-08de2b65530f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 14:25:32.1439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDNaZkIarg5+9z/puDSvVUKbVkvryCeAS11uJxc8dDfL46fPEqBtQmO9KQTVl3wuo+gRGcaNNCJBRQGZ9FaEAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7693
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_05,2025-11-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=872 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240126
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDEyNiBTYWx0ZWRfX06j0AIHHpVLA
 uAnmxMn1EhSx+zGUnVk4zCV1SirIzophmu6aSnNuRpstT5s9gENcNjNLtm5wdSApFT8957Wz11X
 +wNT+/RNgwd2e9LpqiNwEQdi6t+C2xR2QTk1FXJI2NaqPcw8u/Xa8TKFmOXBSRvc863ykDH6K5+
 +iUTTMeO/IpPKBjp/BZaBkMbw4KrZX+hj2MFVNS0FLaMdqx8F32cFHP+zEdvgevRVS3B3xHPAjJ
 gEjBvkdgkHt13ZIHxqRLyarIrH5bZu7aWeDGPTF0/Y3EDkuKww4eDidKi1OCPF2+WCX/tm0S5Py
 vTHWG+uXxiCDnRABRHUgY147jLn6pevqttzph5Txc0h0pegLcc2HB3+5pOAs6O8AbOvo7Cxm6m6
 u/Zyagcmy64WuddvjnWBVH5DQljQDkiZo+uE6bkDnz22pMORVrA=
X-Proofpoint-ORIG-GUID: VZAwqiJ_xoqyhynDu8gM5gzPNzeeJFda
X-Proofpoint-GUID: VZAwqiJ_xoqyhynDu8gM5gzPNzeeJFda
X-Authority-Analysis: v=2.4 cv=K88v3iWI c=1 sm=1 tr=0 ts=69246ae0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=5HrXvWP0L_ocyw6E0sAA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:13642

On 24/11/2025 14:04, Christoph Hellwig wrote:
> On Mon, Nov 24, 2025 at 10:57:24AM +0000, John Garry wrote:
>> Commit d6f215f35963 might be able to explain that.
> 
> I don't think so. 

I am just pointing out why it was changed to use a separate transaction 
per extent [and why the cow end handler for atomic writes is different].

> That commit splits up the operation so to avoid
> doing the entire operation in a single transaction, and the rationale
> for this is sound.  But the atomic work showed that it went to far,
> because we can still batch up a fair amount of conversions.  I think
> the argument of allowing to batch up as many transactions as we allow
> in an atomic write still makes perfect sense.
> 

Sure, Darrick knows more about this than me (so I'll let him comment).

