Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74B0213246;
	Wed,  5 Feb 2025 03:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724899; cv=fail; b=j6Cg28rT+hnIcd6PgSj4r1fI27EfcoIA9flZ6CugbMsLz12w+KJ8g7crGsQAPRNtVR8bMCNcrPbKx3ShKZd4u3VUEZ7yrmVTUedlPgJfJF/iTNI3yMHuV6y7tYyEPRBhf1qfm/vTHrVNyCbbS7TnjyMncfae3KJqEMB1p7HJoE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724899; c=relaxed/simple;
	bh=B1FwWf7CIITFDCUrOQVMq3AwnJPeG9JNTCwf8Kj11c8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ELX0ZbaBtp5aVlFlHLEsh7cit3a+svldBHUqgOd3WC1ivSSfRpIQRbpX0FEykYz/zW+XH9glrP+LQjwnNgrDrK4DPRiwi7fiNKEVk5Fd5REOWnu4qAndiiS3RMVJOz934S84eMqrCA+ZtrVfjE+eutPnnD2gVeqfaudgszccdG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZjM8RIDr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CB/sbc13; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZjM8RIDr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CB/sbc13"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBwN4003152;
	Wed, 5 Feb 2025 03:08:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=1zpwYpyGWOvxAyOg27wJj8NAguJU3ykDXEeZzrQpmk0=; b=
	ZjM8RIDrFsACkS/c3G5EO59VrT7QekJel/FZMFS5duMApSk/N2l+uwQSHbK6+8Og
	DW8uI8gDku7Q/s3yBkQFZtekyqI0DGfX6UKPZHR2TH9HihPqnH5oMQjLm1zi6Eu6
	YRRC1xk5JQL9w7oXLDMR5pvZIFUu0zNJMdbkyzCaS9SjDo51cYEOH8Bo92h0X2w+
	DD/CDahqXFNQko8lMG6zCrR3t6QZNywqu4/IBauzAEOv18Wg7Hm6iRyoL5btMjXh
	odyXkefleo+BhzcQFFLRn7fLd7Ywe7ZGa8dfJZlQreRcqDgVVrnNkQ03oIGBtveL
	pOz3FuXmD/lFm7afg5Pf3g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy863j5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51518ZsY037739;
	Wed, 5 Feb 2025 03:08:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn1b-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i2LAwx2iuz5NmBIpMwTKIUTd+pZAEb4AJKHJiev1xW7EalY4Au7YfUx6GUtp2zA4HXDffbQ3UV7Q80DmXJ0VKPLPt9gUbS4cXcNcJXssiNr/AuTPGFRMubCCJfTh/A5W565Jdx/HVWNG7H2A/+1tzctNHsulTChWYmgRi0P6SqY3fFMIQbFJJnHjf+Q03DSQKtGDU8IZBpeJblpCOX4Cq8N4zvwMpQc5HiQtk73Z755NKXrK7i0KmRxE+yHj+oyEGoGPCyayL8ksCAw1N0jTyqjGSbeo1m/kyTCWrHSzA5J+nSmOlwP8jAS16kLFyvTe1z78dqhkCwmKD53vxqCY5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zpwYpyGWOvxAyOg27wJj8NAguJU3ykDXEeZzrQpmk0=;
 b=Ch+k9juEQ/530316siZkUhrbMQcHI8U/FtriIpVSYSJ31tiZtpkN6iHdi5STU4nEgFVl/PbrP7bsNFFuXqRYZy0t2Tgp119Xeq6PuMr/nKDf0xji6WdMkkqskwk+jzun5SetPIpM272SbxZ0sX+ErdNppADK8+TQrdpSOr7J1qzY3IHlt5i4p45qrMeLB4DVT7W1KUICA8J87IEKqwz6yp2ZA/tM7TdnzPZuFwfR27XU+mLzcxP9p0AzYVIQqifkYkBGYoPA55NK1pJyxFrMGknEbyz0+bVhvwlOi9+2TcqA2ymVsZhu78jwu9AB4w0w8LwUdUCdN8pw4NGmDkA/0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zpwYpyGWOvxAyOg27wJj8NAguJU3ykDXEeZzrQpmk0=;
 b=CB/sbc1379TXGUR88IiE5Irqs9SbjstOXat9UURU9MfJ5boau8eM78B7hI8pxGStDVm+k7P9R07ReO8FQ2gYDpQ+FS4OEgtSguoiAeJBJlJJxP01UnFNNyJm+ia7gcRWaAqmmoQ9pCW5uEsCpet9dknbh5o9cfkzRRI1E55VHdw=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:53 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:53 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 11/24] xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
Date: Tue,  4 Feb 2025 19:07:19 -0800
Message-Id: <20250205030732.29546-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0331.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::6) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: dd421f3a-64e9-4e29-7dd1-08dd459247cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i1ycK67wSzcM49VrVp6iI255uhs2u4Vf/VyeNtBHcWbNutU/Vcao5i6oo6oM?=
 =?us-ascii?Q?qRFDK3DAEGzO/0GloPVXTIZtkT4FRweCoARFVWDoD7uDSGsTfJOWKVTjMcdJ?=
 =?us-ascii?Q?rriDMT44XRaznWO43ajuertkeuZfDxhA1cHTv8fqAv4KQEnJzE/mzr+2+uKT?=
 =?us-ascii?Q?i85y2xRjMs/AwTFwXd6d2RqcCoSLKfO+fBkk7m86fEIhhXmT2Wu9qdVPe6Ho?=
 =?us-ascii?Q?d3pSMkcLi80QlraGjnN/Aziz6aH+5UUW9YvtsGtmTJPvit5YimfaBAuUBXTk?=
 =?us-ascii?Q?Z5933AdzP8NYvW7XRbER0EjQ1weeu4nOaz3JdhioeWIyz4/lbh0z1dhdKoNG?=
 =?us-ascii?Q?nwG/rdznzdUnoa0BqtyldbH90eIkG+3/p4z6Aui8nmU8LIprOY5l605vlGRE?=
 =?us-ascii?Q?csVdqPZu0jRwuzGPIlanUhLrSLtRywpMpkKesloau7vV4/+oe7hHj2LTlkaL?=
 =?us-ascii?Q?zLCWwmkCd8oCOwx9qhnrxqm/cQ81zBK2xqEL78q7VmDkd3pruRM1Ii8EFqRf?=
 =?us-ascii?Q?Ht79XUQYEyVl8LcpAw9g7R5ej+LRDbRK5vzycTL5N1lezQDhqaQEyJJAnYvW?=
 =?us-ascii?Q?+LdgRp5/gar8m7pCQjZAUx3MTGszbcBAMlmO7DpDAwDdOCH+fT0XJFajaN0M?=
 =?us-ascii?Q?+I8iGjH8n6wrnaxBajUlhuotXt0t2vamRZ8D+RUuBxQY/bx8w2IRE5aQMfn7?=
 =?us-ascii?Q?/JD81vgULMrIFCr8nQ/HJGVydU3tOBcrvhlSnfCeon+Pkq7/YNhhiZnjcH4C?=
 =?us-ascii?Q?q7p209BVDVDh3KRfU1Rndg3TBc1EzNqgR7uJORL/QHSwm1mr4ueAZAqMpmu3?=
 =?us-ascii?Q?aNb8Sx0t3O0534ssWL2Gte3ltQE4505UZLxkNlilN42z4B+TnEdb7MaLNq6A?=
 =?us-ascii?Q?5eSGNMta6Icw4iNGQ8CRuleGSkaiAu9hY84T2mnB/jyCcz8LGsEIdhQKrVaU?=
 =?us-ascii?Q?cCmMJ9PP/AdI/em+pSBn36n4Kg+TvPAmV0TALlF8LUefpFXYVxSTv3+kFpN4?=
 =?us-ascii?Q?VLopeP4/2XL0vkLYxCPbwLiq4YnpRsFsJJ2genW4FTIJ584sJ+vOedi83+hi?=
 =?us-ascii?Q?CSZNuujGf6XuXc8ChAGMpjpLCTJTU/Uzr5HmvVDM5PlBQ46QXt8b888LOZLW?=
 =?us-ascii?Q?lPTWGy2BQskF71z+SDVVTRDkwd8VFqHVWth+gK4NPzGYhl3yftbxkzvL0/zF?=
 =?us-ascii?Q?qAQ3QtQxH65MTW8HdYBVqma/3y0wjQoyJ4CgWx1lo0s7gXb5p50NvGuAd71X?=
 =?us-ascii?Q?aTOTcLhL3naUKlykcPFbS8bLmE3JlL5VHELohBRGnruTmjaA6TfbyB2WdiYI?=
 =?us-ascii?Q?LHP2joNYxah3wiTFcUk7Np/cfhF1/A8t52JSLGjhH+/K1AKegYPD4s5Jao62?=
 =?us-ascii?Q?GRipXpZj9QQf/DwEMjodzw7qvPA2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RJ17mtZzRDuyxNjumDmMOqtPu5VV5xtOmT7Niwsh0bZ8h1Z1532l9S5l0rYN?=
 =?us-ascii?Q?GHXpBXer2IBZr+Pbt50ljJ2gedsMtWg0M6OiF5IjMUPyNwOR62acCbZV8b8w?=
 =?us-ascii?Q?N2La66X2O6J+94M0F0IC0yLAGWz6+MDehNRqzC5IqFLjnSsgD+hcpDUL+pHR?=
 =?us-ascii?Q?ZkSQoiHx8qTnmM8yi/qHgekgzbq5KGh9HlkD+SkDxNJVgpz3proUUj54gMvE?=
 =?us-ascii?Q?pq1Gp6S+SGtWewOUVS1weVwPpax79NTJ2zQyoa2T6AlHzw4LC/ak5Vxg1ZzO?=
 =?us-ascii?Q?mDCoelGiHimEMSK5FTAJF5tldxM/4wKjCTAIWYo3XAPdaPlSpMvDnTpu9cTn?=
 =?us-ascii?Q?1cvqIv3qWEDl6mDftyjVc9gGV8G2l4Iavp8rHru2WzmsRCBfkE+1jYwwD41n?=
 =?us-ascii?Q?aneg1GNAkWZetUIzIQ7yrUjjjnla3ZLCNv1HAMnAo1rFYmYR+fcnm4MoPGXG?=
 =?us-ascii?Q?4O1uvGb4l71WTxF5N2UpAAazkptQ68m5h4pHbxxhmfba5Y79eBsPWRlGGAfh?=
 =?us-ascii?Q?Pk3hyPPZ6ekxeLSplGlgpNwqbPX3J6yE6SgKbs+a+YSLHTVCS7XW73Yg7wdX?=
 =?us-ascii?Q?qJSavqjsFYKT+qHpafmxI7JSf/82mBOj64pG6CrLqqbjTW4T6Tsc9i3Cmqbz?=
 =?us-ascii?Q?ZADalzmTFJRJFVgLihIkVPOWy0EPoNmrRx0flGKiy1K060uDonMwnHtJIQG9?=
 =?us-ascii?Q?XhBQOrTXLyE+LDB5h109e2csVEVCUv/Z+PDXXe28RpMGZqT7lNCTfOUUVZEs?=
 =?us-ascii?Q?EJmdhZdwDcw9aSCeywXVGZ6wovEX1VsHTfmRXkCb9rx4GjOv+q6kdngp5tdF?=
 =?us-ascii?Q?rWChwZc0vn4DHPCsxwu9gQ/iFEl4ZFnVVfN3zdxzVEkcapi1czyyG3SblB0L?=
 =?us-ascii?Q?Mx4yZqB21WA7NrXQjwk4n1BhkD+/DnFTIOCkr3cEien+IAQMJ3RJdyjVoEwh?=
 =?us-ascii?Q?SGG18qaIW/q87Lp9Lc7lw6cNO2Mb9ObepWJoal4N+0w+UMxq8gWZE/5Xs0bC?=
 =?us-ascii?Q?FYG4UrJGaNC6nbMkSN9wqDO4Ryy4KJcuLsiINKjMOg3mLLzud97W5BtseoYj?=
 =?us-ascii?Q?HEPcmcDJZRZ58eQZx0Vk7PDRudTMBkoiRmqAkRtggMUTjG8FjxlTDbOlX00w?=
 =?us-ascii?Q?RLfw5LHbR5TcjuaB0K7T+N/ZjdmDRhbQLDDghztORusvNaOi2m+rGdWScetJ?=
 =?us-ascii?Q?cI8xTSlb+ZGgCqoWvHs5UQXa5QNBetwb6lqzaQ8/pyO5ePiPLi9/PJmk9kwa?=
 =?us-ascii?Q?o8SVHpr6lsJaHcWl7T8V89r5EFTLOiSrwGDUmZu8YE5E/CN5IZg4Gvgv4zin?=
 =?us-ascii?Q?mDElg+9ey8VMcIgGqsNF9XjGgfXNlaaR3KZ1L+5F0faA9QrAv/xO7dHcxkm2?=
 =?us-ascii?Q?6CtIYNZXSAvLy2ELn/PpXEtpmooZQUgKqKSckaCYiiqZgedWKfSfEYAtLg5B?=
 =?us-ascii?Q?WE3AACPIH+PdEJCGgHVTRm1FnMBCbNTuqEr6B5OemodI1Bwb6g/z6Ah9Dy5k?=
 =?us-ascii?Q?19Dosb6YPug/NYeiM/fucUJSQx28kKyGZy5Lgym15+AyajXu2DxpYl8lXhdJ?=
 =?us-ascii?Q?3jgZxK5ZiohuX/RLZy9BgaIaBHU86HQ2UhYRyk88sv1pWWDvpX+qnXFjcwRk?=
 =?us-ascii?Q?UpVGZf/TtOTxHlWau1athwt1vbDuJob/bycJPzHt8YXJKCpqvrLAutIU5wig?=
 =?us-ascii?Q?27STDQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rsWYENwZLyr//HcUXVPQFIZWaa+AIu0H12skyUGegVUsTvKsfpTj/k/a/zWYmoUCpx8yWfWS3Nbrv06WJUK6dojlynkNJ/SIMxZFHoYfra+1IgH+OzTafiFIrEtMJHPy7076UOB2AY9HYrgibM0gP0aWYZ9CZrFIrfntcSst5F1T4VPc6DHlkaumailGQInIP74Sz8Yv4i8H3yxBE6AzCyh8AIcCXIUuVaVbDJURSgblPWy5pWlmWahqzZCLz8+pudfQL23lbGzh+IslDTz8beRhkfc+WvZVBIqZxIxDXPALaaIjDf8CkHhObydrYdIRewP0ZsewxRkmoGVxzuKUcDKAKdO14OBZ43PKZoMMCVmY5QpMnyhi02UmEWPi2YCUiz/w221PfCxOnQUhpFiC49FxXdGUrbLeobc8j1EkHY0TCVXp3mBx7hI94PrxwDKTdxI8AOMW6IJS/eloT2iuXuAX1uWiMD/LpVt02bLxnWqp7cHbyYI403jOj/qs0Qsz+JnVtcB1shT4vEUQBhbo13RJCtGtU3V6JIl0bvC3xX3z+e/jRMgGi1lIjlXDrIP0uAavjUOtoJCMEdWIY7cKQzgK3lrVq2XSu8Rjkl6J19Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd421f3a-64e9-4e29-7dd1-08dd459247cc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:53.0450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ztwpgeNSldWMoba8ryBkpUJnYR+trI6c+wFNuzEmH2ZZ+PDOhAQBI1j14vY5JZXhRxXJLgs1lJYmYrpYjS6LdyMQbwwngK1OPeFbHwodZ24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: FIT3iiBc9TqXxK3K6Dhxw5YVJERsTlFM
X-Proofpoint-ORIG-GUID: FIT3iiBc9TqXxK3K6Dhxw5YVJERsTlFM

From: Christoph Hellwig <hch@lst.de>

commit 865469cd41bce2b04bef9539cbf70676878bc8df upstream.

[backport: dependency of 6aac770]

Userdata and metadata allocations end up in the same allocation helpers.
Remove the separate xfs_bmap_alloc_userdata function to make this more
clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 73 +++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e6ea35098e07..e805034bfbb9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4077,43 +4077,6 @@ xfs_bmapi_reserve_delalloc(
 	return error;
 }
 
-static int
-xfs_bmap_alloc_userdata(
-	struct xfs_bmalloca	*bma)
-{
-	struct xfs_mount	*mp = bma->ip->i_mount;
-	int			whichfork = xfs_bmapi_whichfork(bma->flags);
-	int			error;
-
-	/*
-	 * Set the data type being allocated. For the data fork, the first data
-	 * in the file is treated differently to all other allocations. For the
-	 * attribute fork, we only need to ensure the allocated range is not on
-	 * the busy list.
-	 */
-	bma->datatype = XFS_ALLOC_NOBUSY;
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
-		bma->datatype |= XFS_ALLOC_USERDATA;
-		if (bma->offset == 0)
-			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
-
-		if (mp->m_dalign && bma->length >= mp->m_dalign) {
-			error = xfs_bmap_isaeof(bma, whichfork);
-			if (error)
-				return error;
-		}
-
-		if (XFS_IS_REALTIME_INODE(bma->ip))
-			return xfs_bmap_rtalloc(bma);
-	}
-
-	if (unlikely(XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
-		return xfs_bmap_exact_minlen_extent_alloc(bma);
-
-	return xfs_bmap_btalloc(bma);
-}
-
 static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
@@ -4147,15 +4110,35 @@ xfs_bmapi_allocate(
 	else
 		bma->minlen = 1;
 
-	if (bma->flags & XFS_BMAPI_METADATA) {
-		if (unlikely(XFS_TEST_ERROR(false, mp,
-				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
-			error = xfs_bmap_exact_minlen_extent_alloc(bma);
-		else
-			error = xfs_bmap_btalloc(bma);
-	} else {
-		error = xfs_bmap_alloc_userdata(bma);
+	if (!(bma->flags & XFS_BMAPI_METADATA)) {
+		/*
+		 * For the data and COW fork, the first data in the file is
+		 * treated differently to all other allocations. For the
+		 * attribute fork, we only need to ensure the allocated range
+		 * is not on the busy list.
+		 */
+		bma->datatype = XFS_ALLOC_NOBUSY;
+		if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
+			bma->datatype |= XFS_ALLOC_USERDATA;
+			if (bma->offset == 0)
+				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
+
+			if (mp->m_dalign && bma->length >= mp->m_dalign) {
+				error = xfs_bmap_isaeof(bma, whichfork);
+				if (error)
+					return error;
+			}
+		}
 	}
+
+	if ((bma->datatype & XFS_ALLOC_USERDATA) &&
+	    XFS_IS_REALTIME_INODE(bma->ip))
+		error = xfs_bmap_rtalloc(bma);
+	else if (unlikely(XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+		error = xfs_bmap_exact_minlen_extent_alloc(bma);
+	else
+		error = xfs_bmap_btalloc(bma);
 	if (error)
 		return error;
 	if (bma->blkno == NULLFSBLOCK)
-- 
2.39.3

