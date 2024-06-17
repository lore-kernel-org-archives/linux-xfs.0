Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1099E196455;
	Mon, 17 Jun 2024 23:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718665453; cv=fail; b=MbNvhVERhiLPuaRkVGh3c0kHVPMUonll9FUhcxh+lNL7pS+CZTFPPPKzKTFIu9BFJtp92RRHjddKg9JSJlmBON98tE2J6ZBu/38Amyhz6EdVvqlcAd37ZcRcAcSTzBUrsGVCQSXXTnOvpKerbvQvFoq5ABler5ECugKZf1jcp68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718665453; c=relaxed/simple;
	bh=6YDLqBx+tKqWfK8VvpXaxyKJjGgmNYvyu+607u/sQs8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Nb+6P8HKmZrx/wD7cZ78cEksOo8APMJ9hhTJ4y1YembypazTKSN6MpF3hVoAKRhO6v1FNDfXWglYhG9Z+sz3lInl5rxpV3urkmOhmYORO0PdXtWghaKMxCCyGEDmjFiwPdyuHz5e8N113D7M56Yaf/i/TP0zz9NI0UL9JpPL1ZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q0NslNs8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=czIw8qZ6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q0NslNs8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="czIw8qZ6"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMXTbq010519;
	Mon, 17 Jun 2024 23:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=TMBZenXHmNrZJ3tRTtEcmvKpcixYc8k0CTDmCY00Ae8=; b=
	Q0NslNs8w0Fd1XojkVdQ58CqsHRshNQLPro+AkwFm+MATHG8ngqbPrrw6bjMc8af
	EF9K+7ZWtLiSRqxX31NK13bq68YNxIOns6cuHPeZub6g+zsT4jOzjf+YspaQZwvr
	R/JvKtvl9FGohSXE71Jci8Kmxbo+LxuXHvNo+WHDXf+EbLKZDhsdhDh65CDxBg5l
	/nE+mxUVwMC8TpLJytyY91VFFSS9lwiFskAm62EjTOeoZ3okjPV+1iey4fzKWfFq
	RapyAtJ1X+Pj9C2PRSylu7Qh7Yc+VjENPQigoKUfxV7rI7bJ+nDM+d88biluo4Rd
	rIGWsveIXELFFSgYVQZBcw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys2u8kpyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45HL4G4I032868;
	Mon, 17 Jun 2024 23:04:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d73k30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5tIG2zrmTfMhidPmgby0Kxr7QnxQA8RgXZkqqfUz2D6h9F5Qqy3H17Etz52td/7HgwMdg3DqSimWjPr5eERmrziR+di7eFQ/O0lTV8G+nj3/5A4FGV26NxafKDzrOB+YEamAxS8wP18Vvd1pHN3j/3Tp2d1M3u1nAm58qjiO/Pt1qhsDTifgB6iaGzLeW8VIuKkF7ZRFHLjDMnL6XdnwyKtOnuy6utWw/Xext1RXzHzsAjWA/w3SsspxLuHn/MIzePQ8nGMcgPgAE1y1I72nV1GxNgn41+QZkLKijURmJxWmr9YgpT1E6g57wFXdT+U82yNi/a6d2uTfTpD1JoFIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMBZenXHmNrZJ3tRTtEcmvKpcixYc8k0CTDmCY00Ae8=;
 b=mIipxdcpo9j238CKOdVPzOyTi1YZj2tUwJ+/qcZrHmmFabialtNzOYfUFcPTNC+O0DAUvkw5vhe3/GTN7f8hsLinCLOZoLOjpJjOI82TRbH3hEdoquOpvmpUuXUZq8VSZQGleqJLE+83mgtTAC0BRsoZ7h4C28PKVzIAVE0Fx+R+MPbjqv7kQM76RlEUnRVzErvRleqFZYzllHkyg5hY9NXVvUii6SekL1iDhtuLOq5zHpfG9vaPtaVqvSx//Qhe1TlH0RWj4xhXjFX+tXXZ7aai5TQ3LnJ7+FteEaB/u6WQJXiR2MiZh4CsU7MuouvmFoWRhSpOT2OXzHXnw9E73A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMBZenXHmNrZJ3tRTtEcmvKpcixYc8k0CTDmCY00Ae8=;
 b=czIw8qZ6UuzySdKIc+9Bl8ppyBwYCegEeeTWUu1OKt5+GhcQRgvM0SKJ4RFLLjQwxRR5zJWR+VWILbLyuLwkntwCDt18/HBctvGpAB7ACzQCoS3cbWwO5kweI9PlInAKBIAkBFAlKpJrgwjHqx6dQetGEt0tvGaZkmYzivZLDuA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB7398.namprd10.prod.outlook.com (2603:10b6:8:135::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 23:04:07 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 23:04:07 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 5/8] xfs: ensure submit buffers on LSN boundaries in error handlers
Date: Mon, 17 Jun 2024 16:03:52 -0700
Message-Id: <20240617230355.77091-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240617230355.77091-1-catherine.hoang@oracle.com>
References: <20240617230355.77091-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::11) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS0PR10MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: 156f35b7-06f7-43db-6036-08dc8f21cabb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?zLhuL//vxcItJvf1DMtCQRC1NvEmx9HSf1Lp2vCdAUEKN4t32IWxf2kdcTIF?=
 =?us-ascii?Q?VB5LXw3G76pPtRMrfLWA5awkDwVsmy8Nlnv/Zk40R6pAnBrytaJtjQGKv8wM?=
 =?us-ascii?Q?TQmEti0CbVQRfbENVwVdbVnCKkiuZ8AJCoeuH9aigEe3yGxlv3sYkpJcjrRN?=
 =?us-ascii?Q?rODo6dYd+Eh2WDPXWZzXMBT8M4v+yHzEdJ7NYzwAR0r0OhTYOvNu4Xkbtrza?=
 =?us-ascii?Q?JW+n2+G2S8LHmQnVFoSKlnWywAtBQ19sImUWbuhWLO6aPU+q5JS2JdlbtV1h?=
 =?us-ascii?Q?argH48n3FJAeJ3yPk0b69BPvdFIsVch1iUhrn+VWMXI7OGg1aeNzXyT/g5BV?=
 =?us-ascii?Q?bK5AYsfHWCN0pxCEi8ggGs1LoH2oJFN1O13OUj7Vb294Y6mNTs3N2FLi8iG6?=
 =?us-ascii?Q?GXSFmCIrrxNAQwOg+icXPkZn8zSONvaGd8Qh1TU2CpF640+dKLyFyxiU3lnw?=
 =?us-ascii?Q?kwwSFIvOK8eI6CxFCyiW6VrC+NPA9teGmDVeiJfN2/npzu0d8RHEDYYiEs9h?=
 =?us-ascii?Q?cEs6w3mWGkjlXeQtWfUNxHJ8RA2PTccYpVA+bJ1vMslMrDjj6ZYhJH5Hy8c+?=
 =?us-ascii?Q?ZfA4vg7kU0USQyu0FepfJ4fawHfmcIa6AucjN/Q8y5gRMNNZNonQz0u+uc7P?=
 =?us-ascii?Q?iSwUku3DxyrOdrST+96W2axt8vaxdHnfRdUdtyREQHSMxMh7zj/QzxRjGCLR?=
 =?us-ascii?Q?FI4VN6hkeK4QIood8Ed5VY5blKu5m4Qo3puCgAY5SjD9vMc84GJYEWduL3SX?=
 =?us-ascii?Q?INjFGgfdUyUBjAHxONofRxYNN3fGh0tIGyBhrtC56x8S6o0RufmNzcwVEdXU?=
 =?us-ascii?Q?8lc+XOYktPK+M03GeE35ogjHRgAh2e3iShGYrh8cVNMROVWMnb7weNRVEM65?=
 =?us-ascii?Q?ET6ESrPszrnLuEG1tytBDaWdewc9fp8uwStJXsx/GArTUihSdRVXVJjJjJAZ?=
 =?us-ascii?Q?TJYjSuaNwkiuGkayFCvatYnswUvZNHZuH8fMI1gQ9gJFn1bsMy6Ltuq5Efm3?=
 =?us-ascii?Q?W6zVIIAFvGzJsXnhnqDKHJEJXM+fXmfmKI02mocnfuhKzksMUHnyPW4Ygzv5?=
 =?us-ascii?Q?8ZkR2C1bD0xiyYN7qqTGMAXimvMj+8OkR/CGU/PY4ZE3ncgtguqynh9ZckZp?=
 =?us-ascii?Q?qjeKq94YhA/xqEI7siOkJMoHgc5NFRpeU0VJirGGrkMsq/fFM2MOPfwtOXvi?=
 =?us-ascii?Q?NXGI50x2f/37h0Ujj2u1UoRPLp6XBjmtqw2p/2s13fskoDE3ZVVgzuebX7ZJ?=
 =?us-ascii?Q?hll4cigvzvEihKDJxdkAquKcSqotkmLVxiBPxE5wwovn4pPeyw8yknrNqgCR?=
 =?us-ascii?Q?w0g3tWXFc7sF2S68RQQrMB98?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Nm/LSiZEyGY7OKH1yTbcMByOuydSSi522UC/HsiMhgivfUknoXt98NqJpWFX?=
 =?us-ascii?Q?pHiPv67vwNRNC1qiQI/arz1EBPWDWxrSqZkMUaTRm0GxVdZxmRq90CVdNE4g?=
 =?us-ascii?Q?ump/GtlyNrSpTctA/zd69SUT+5Bc2N/q2WS2mYYz3VJvGfF0RdiRfm0Mq0mn?=
 =?us-ascii?Q?RsV6O0j8LshNLjrrsPCRTO6Ad02eDvjHsXxcKT/tyS/t+tMcPXj0xdiF0HMj?=
 =?us-ascii?Q?8eo2PQA+QXn7A8vEC1qw98qkgbaeJMVPU5ud9gUU4NuvLIe2R2Rp7M0B2a61?=
 =?us-ascii?Q?Y0gPRp0Us2MBowJM5LtjhCoTT19+qaxMXfYiOSyVLBKoHu3DQuHu8iwIKdRu?=
 =?us-ascii?Q?pTVuy5FR4dxlS+QENh0+MhYtibVVdEHz06HdMAf4S9mcHketRUdcR7IaNsND?=
 =?us-ascii?Q?i9pwgYVjPqF+6lwK/cNuIZwPxSgnyGjJGiPEpVAhcYdcwx53OQKIrLRAQvaX?=
 =?us-ascii?Q?EAfMfSUD4XeVfJjlSDmvdgAs+rY9sVUJ8K6phtXAPNMHpVYaLzeNs4Pa8dqX?=
 =?us-ascii?Q?UW1iZz0/u5PIq5ULFu9KNTeMpSZFDsImoiOQAnPssDisqfIvw4sZZZk2KLgg?=
 =?us-ascii?Q?2KJm+GanU+hOBXsNX8QI+c1EHTbpk6XIodxZiSD4bjh0/c06N+0vd0+1Opk/?=
 =?us-ascii?Q?EE3R5MiDleILlYFS0RBBd8cnaWxJHd7coDs9PHoRk4KRAFXlGTSvqujUQTp+?=
 =?us-ascii?Q?BQJXJ1x0CGZlp0MtFRash+9vKwMsxyK3icz+bowhI+PIhcq0idKo4YhHgAnN?=
 =?us-ascii?Q?Q382Yq8pNewy960j43HfaAeH5atK3vwmA1yW/hwSpuDqUUrrCzCE2sDgPs9Q?=
 =?us-ascii?Q?nRt+s6iF5DGw9IVTL1V1czEoy91fXBh4QvyCl1EYQ/2LNnf/Be03m+1PcrJh?=
 =?us-ascii?Q?fqxvgJtOCL5R5g66VRuO9OfPNnyfBkklVXjmHNyIU3iPb8j9/zw+F70mkFw2?=
 =?us-ascii?Q?C1M5TALZU1bhcY1s2OV9bWQBO9ALDBWZ2mROfxgbes9q/B6JyyDHGQMPK7ZW?=
 =?us-ascii?Q?N0N8dohAJcgg7/vYYucuRux/xXuZoeUDFG871cTXHLPjmzopwO15mLs5Wkkz?=
 =?us-ascii?Q?c2xSxPn4CCvYoe9AEOjMk3SJ0JngIHgnPbSppbbmJ6QHpPZtv3M6A2uzIoE+?=
 =?us-ascii?Q?d0NlRoqgL39oagi5EbGRTI2rw4Tp4fXL0FNnvNqu7PjDoddgSnNw9gbqeIMG?=
 =?us-ascii?Q?xHVuWnYPUOxk1B0m/SDgvixu+vAnNd0qVs/xbpkg1pOIWDjYxBTSQgy59o7Z?=
 =?us-ascii?Q?NFeEwQ6wW1EUfC7tYj4+Sm3xM6W9dqxL1gwglfcXxQ+bGr0teIRmc7glPokR?=
 =?us-ascii?Q?lTr9F1UzGZCI4q5T1sKuQj1RJzq45wklnoYgKsRZyHo10SUAwMF+Zc6As3SM?=
 =?us-ascii?Q?Eh2Iti84Ri5SO7vmH4jmS5IFxKHFL+ReDGADt/NBMdv0pMasUsfkcHCh+8mg?=
 =?us-ascii?Q?pFBW2UgW8doP4UdEOi3H3Fah6+IONK5FXcitGiBQo2hqq41i69SZng3CAq2v?=
 =?us-ascii?Q?4TYkxbAVXVuk4GKXzJs82ozJczb1WFXgSUKfN6ggKmECbdVzkAqjILCjzH5O?=
 =?us-ascii?Q?VgzxfZLn3gMmfS4rPfiHQ2LGO+jk0/s/2bpv0J60KVMEbXAli+5N4rlrYOia?=
 =?us-ascii?Q?FD1QRk5iJhAB5t4yRrg5eySkJ5k1d3uKJNtAGnvB0GK6dFaErdcwJHu+PtP2?=
 =?us-ascii?Q?bVXshg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	dnsMrXx7SyndtUatoBEna6b+Z4ABNuiJqBcU4XUtaiSOlrNABnuiXKgddmW34R6YmvByVjso0X8dQNeeLrzYEx5FzdHoF0vIi4cDwGAwmSirDVW83/p6ythK/HW4ays5OIGhkBqU7nFlkqTQ8dAlHhuNkNP0U0Gdc5StHdK+k8UlokYGdEheKr3x/uJsuGa8Wr40Ovu0/d6STJTKc19dgf1Jkd0c/m/xrR1Zo/CCtItU8Nzul/W8wEzROh9uAYB4ADal6LCuTCohhVBEUkoc+5go/M+vwXEUrFZM8xOG11YGdggdVjn7X8JrC/O6cULDGOak0TnWLQp7/AH4kr0LkgJdbKEiWzskbRniMAdcbySZLgsxCFYwyS1HYIflxiiL7ZkjD6sWn0IEeb6rc6xJN1M/pj8UoZ1b14ufikGpzRl8bT4nVfKiUQZ04bT0XB2Iv0qkr1Kmua/ZRnFcojNAltqi7r7yItTsWLI/thyACUcxmYggSFsrX9hTmAovJsgz16gkIjNFFB5OSmg1AMAubW3/n/eqS9R+XDx4icl14IKiyEerRqEgkwNqbI2zEM21a594uD/smHJgi3H54QJfZV1EJGvQ1rvbrTwzMjcj0nw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 156f35b7-06f7-43db-6036-08dc8f21cabb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 23:04:07.8988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pna6w+mXiwsD8bpdOHvNOVGvHc68Jrw/ujnkTCvYiG3S6oQcPVuZJf6MZyhiH59T0nI8PXIjF7l81sA0sC1w/H/Sw0crYBWVak4M2bd9YNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406170179
X-Proofpoint-GUID: mtc4inRGYYEaeaky6qIUquEzij5ctPCH
X-Proofpoint-ORIG-GUID: mtc4inRGYYEaeaky6qIUquEzij5ctPCH

From: Long Li <leo.lilong@huawei.com>

commit e4c3b72a6ea93ed9c1815c74312eee9305638852 upstream.

While performing the IO fault injection test, I caught the following data
corruption report:

 XFS (dm-0): Internal error ltbno + ltlen > bno at line 1957 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x79c/0x1130
 CPU: 3 PID: 33 Comm: kworker/3:0 Not tainted 6.5.0-rc7-next-20230825-00001-g7f8666926889 #214
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
 Workqueue: xfs-inodegc/dm-0 xfs_inodegc_worker
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  xfs_corruption_error+0x134/0x150
  xfs_free_ag_extent+0x7d3/0x1130
  __xfs_free_extent+0x201/0x3c0
  xfs_trans_free_extent+0x29b/0xa10
  xfs_extent_free_finish_item+0x2a/0xb0
  xfs_defer_finish_noroll+0x8d1/0x1b40
  xfs_defer_finish+0x21/0x200
  xfs_itruncate_extents_flags+0x1cb/0x650
  xfs_free_eofblocks+0x18f/0x250
  xfs_inactive+0x485/0x570
  xfs_inodegc_worker+0x207/0x530
  process_scheduled_works+0x24a/0xe10
  worker_thread+0x5ac/0xc60
  kthread+0x2cd/0x3c0
  ret_from_fork+0x4a/0x80
  ret_from_fork_asm+0x11/0x20
  </TASK>
 XFS (dm-0): Corruption detected. Unmount and run xfs_repair

After analyzing the disk image, it was found that the corruption was
triggered by the fact that extent was recorded in both inode datafork
and AGF btree blocks. After a long time of reproduction and analysis,
we found that the reason of free sapce btree corruption was that the
AGF btree was not recovered correctly.

Consider the following situation, Checkpoint A and Checkpoint B are in
the same record and share the same start LSN1, buf items of same object
(AGF btree block) is included in both Checkpoint A and Checkpoint B. If
the buf item in Checkpoint A has been recovered and updates metadata LSN
permanently, then the buf item in Checkpoint B cannot be recovered,
because log recovery skips items with a metadata LSN >= the current LSN
of the recovery item. If there is still an inode item in Checkpoint B
that records the Extent X, the Extent X will be recorded in both inode
datafork and AGF btree block after Checkpoint B is recovered. Such
transaction can be seen when allocing enxtent for inode bmap, it record
both the addition of extent to the inode extent list and the removing
extent from the AGF.

  |------------Record (LSN1)------------------|---Record (LSN2)---|
  |-------Checkpoint A----------|----------Checkpoint B-----------|
  |     Buf Item(Extent X)      | Buf Item / Inode item(Extent X) |
  |     Extent X is freed       |     Extent X is allocated       |

After commit 12818d24db8a ("xfs: rework log recovery to submit buffers
on LSN boundaries") was introduced, we submit buffers on lsn boundaries
during log recovery. The above problem can be avoided under normal paths,
but it's not guaranteed under abnormal paths. Consider the following
process, if an error was encountered after recover buf item in Checkpoint
A and before recover buf item in Checkpoint B, buffers that have been
added to the buffer_list will still be submitted, this violates the
submits rule on lsn boundaries. So buf item in Checkpoint B cannot be
recovered on the next mount due to current lsn of transaction equal to
metadata lsn on disk. The detailed process of the problem is as follows.

First Mount:

  xlog_do_recovery_pass
    error = xlog_recover_process
      xlog_recover_process_data
        xlog_recover_process_ophdr
          xlog_recovery_process_trans
            ...
              /* recover buf item in Checkpoint A */
              xlog_recover_buf_commit_pass2
                xlog_recover_do_reg_buffer
                /* add buffer of agf btree block to buffer_list */
                xfs_buf_delwri_queue(bp, buffer_list)
            ...
            ==> Encounter read IO error and return
    /* submit buffers regardless of error */
    if (!list_empty(&buffer_list))
      xfs_buf_delwri_submit(&buffer_list);

    <buf items of agf btree block in Checkpoint A recovery success>

Second Mount:

  xlog_do_recovery_pass
    error = xlog_recover_process
      xlog_recover_process_data
        xlog_recover_process_ophdr
          xlog_recovery_process_trans
            ...
              /* recover buf item in Checkpoint B */
              xlog_recover_buf_commit_pass2
                /* buffer of agf btree block wouldn't added to
                   buffer_list due to lsn equal to current_lsn */
                if (XFS_LSN_CMP(lsn, current_lsn) >= 0)
                  goto out_release

    <buf items of agf btree block in Checkpoint B wouldn't recovery>

In order to make sure that submits buffers on lsn boundaries in the
abnormal paths, we need to check error status before submit buffers that
have been added from the last record processed. If error status exist,
buffers in the bufffer_list should not be writen to disk.

Canceling the buffers in the buffer_list directly isn't correct, unlike
any other place where write list was canceled, these buffers has been
initialized by xfs_buf_item_init() during recovery and held by buf item,
buf items will not be released in xfs_buf_delwri_cancel(), it's not easy
to solve.

If the filesystem has been shut down, then delwri list submission will
error out all buffers on the list via IO submission/completion and do
all the correct cleanup automatically. So shutting down the filesystem
could prevents buffers in the bufffer_list from being written to disk.

Fixes: 50d5c8d8e938 ("xfs: check LSN ordering for v5 superblocks during recovery")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cc14cd1c2282..57f366c3d355 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3203,11 +3203,28 @@ xlog_do_recovery_pass(
 	kmem_free(hbp);
 
 	/*
-	 * Submit buffers that have been added from the last record processed,
-	 * regardless of error status.
+	 * Submit buffers that have been dirtied by the last record recovered.
 	 */
-	if (!list_empty(&buffer_list))
+	if (!list_empty(&buffer_list)) {
+		if (error) {
+			/*
+			 * If there has been an item recovery error then we
+			 * cannot allow partial checkpoint writeback to
+			 * occur.  We might have multiple checkpoints with the
+			 * same start LSN in this buffer list, and partial
+			 * writeback of a checkpoint in this situation can
+			 * prevent future recovery of all the changes in the
+			 * checkpoints at this start LSN.
+			 *
+			 * Note: Shutting down the filesystem will result in the
+			 * delwri submission marking all the buffers stale,
+			 * completing them and cleaning up _XBF_LOGRECOVERY
+			 * state without doing any IO.
+			 */
+			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+		}
 		error2 = xfs_buf_delwri_submit(&buffer_list);
+	}
 
 	if (error && first_bad)
 		*first_bad = rhead_blk;
-- 
2.39.3

