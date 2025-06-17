Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CC42DBF47
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750162199; cv=fail; b=K9/9hA6Kzym9rzx2yQRAqnnwTkBANNYBbmc7jgGmob/g//MACLKw8Nw8m8rYGaCMedV5JIG7/mgMn/xPEWKJgmvM1CnUO0cOSkT5i3h0Fil9umCh3DTC1+Z1X32bBUm0FrLOL7E1FPQBEmzOlCqVfR7cBwybJ5dbRnbuW/alfX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750162199; c=relaxed/simple;
	bh=wXs+lwTeU3dSM/L82lPlSIyhwnNGMecvPMWEsZgIYmI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I9/9rQzmRfQXwxpnyTZTxXsEDsVjhCxSGKsrMZeE9jiMmnrbnMZBIAeRJ1RTzQ/We63zRRJZJ5JTDQj2OWQSwoHwQM9HMqmJHxjoVThzi2fSRRO0yFXbpBrmA72ZeQ3T0+sYsSZUJGWswN0TN0rl3Og0/iZQwo2AuI9D2Y/yvFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M080kb+4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CVDmfvC9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M080kb+4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CVDmfvC9"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H8tvLx023668;
	Tue, 17 Jun 2025 12:09:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fuJCjgZLaD2Y/uXBIpTy6KgF5dY1P2hAPn5gNwSYSpI=; b=
	M080kb+40/Rp71XUMUksiNYdJQJTS8ZgOP55YO8hMpsyNO/wrwwffiQ7rKygLJFW
	zOVM4QWvnvG0Daq+jKVnYiasNrFrhsrS+aj2r/f/TEYUh8ZKJRK+Hapj72l7jTwN
	3tNIVZBskGlkZoHP7oMDKMiUaqfcHkv0W5M0URUcPrEPDOZat6EttKTvt8carmh8
	7UBeITFHMRnBKCTnPrwClRwXJ+jj2JJlTs+MVKCQNTnw0bMm5kp/469QH5HDFLDZ
	lVNlJd8GJncQnbXlDnjuz7qoBrNjuNxyaYmrLL+U92Z8go3uTn7sotu9yZAJTJz9
	nI1Eqh8NnEjQVAAXDpNMBA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yp4n6ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 12:09:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55HAZceL036379;
	Tue, 17 Jun 2025 12:09:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhfn0sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 12:09:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=izN2wjdUc5dB6vyzvCAITfVBbHuPQE9KjgBerNqOvzjMQiPaGZ0+Y5iQFHZj/WzLgIZf6mRmnEMuk+7E2cGtFmdZf3pPdlfmyMF4InHtpfjEE2zys9CwcLajUK5T6Sm5OOu5JYyou4WcAXLnMDJKcTH2B2uNPZebKERQRpwH3tgI5clSavUa6OrwnJ3PUK/HrMsjFOKsD0xa0e4bKqznofkuw0ix1yrut58ACIeTRcx4HjdHC/mwtO1eTBQ+OcD4bxLhIa8q6SuVQZ44rLh32tBG0Ywl0rO9wfkTAHHgS6QM4Hw6kM6VYytXa9hMV4gD5/F5FHWuZaQLWvkURUetfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fuJCjgZLaD2Y/uXBIpTy6KgF5dY1P2hAPn5gNwSYSpI=;
 b=YhPw5LZqy54GjNXKDvNM69OBgrvpYegOQnEMHaRss7g8Zhjcb+BZSvug7r2m/gvIDuKQ/2mavjCzf3W3u+1ruDdubFaR6fhSpMh0X5AAl64PXuKHzirCFmQPMyEv55iuYg8QfOgiWF5jLk6Anst0GwepI1s/kEQixOt4X3gMnbFkfL+xXHXgeSG02jKTR/hE7Nt4PBJJ2XCqe4qYvuD44D3nESZgq/TMZpyOIn5x3YlAqOp3qsOaUbYomxSw6peGBSf2HF19dxK40DkRAwuHWT2u/DecKJ2/70liY5NJzs7T97eQmXnVy0ZJGusouA5uYZzFywM+AIoGszewaTYoxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuJCjgZLaD2Y/uXBIpTy6KgF5dY1P2hAPn5gNwSYSpI=;
 b=CVDmfvC9O1J+Pw6tdYKoSnH3S9p46l18H0dGnc611mdftHxywD4XzWt4RyO9+liEGw6ynZMrffNbxQdBXxTo0C1pWtDJCMNha+/wj4kpLj75YUdMtFsaeisEcdGZFULxRHLm+xAxIbmc7msvfGKtWcoMcAhs+FucYl9BdIx+/SQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7871.namprd10.prod.outlook.com (2603:10b6:408:1ed::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Tue, 17 Jun
 2025 12:09:47 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 12:09:47 +0000
Message-ID: <a9a266b8-526d-4aac-aad5-503a05911df7@oracle.com>
Date: Tue, 17 Jun 2025 13:09:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] xfs: remove the call to sync_blockdev in
 xfs_configure_buftarg
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-3-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250617105238.3393499-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0676.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7871:EE_
X-MS-Office365-Filtering-Correlation-Id: 062c524c-f189-4c1b-6740-08ddad97da03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGU3ZU95L1RRVUdNdHlsV0FkaGVlMC9zL0FTb1FacXhJN1RiN1dkaUNsYkht?=
 =?utf-8?B?YWdFSFZ2NUlGZ1d1UWlkUStrTkM5Y2twUlVvNm9hYkNWOHkwbCttbGtHL3Vi?=
 =?utf-8?B?c3ZYSGlWS3pPVXlrYXVVY2dkRWxiN05oeVlQeDluMmpMeCs5TkIyVjNQRzdw?=
 =?utf-8?B?WEtwWnNmLzRtcTh3QklHeEZ5NnNhV2Z5UGwrY0pYRmY2RmRRUkxqUkpPY3BS?=
 =?utf-8?B?bVg3SGVhR21OcGxUMWEvNnRhTWVwMThDYUZKZWRYdWVtajUxcmRJUGJ5Skdo?=
 =?utf-8?B?VFBHZVFwNi9Pc0VOeHh1ZUJFa0E4eDZmUVplV1dhVzBPeFVxTElkRUlyQW1p?=
 =?utf-8?B?U3FCdFVCdXpWVGIwUWdySDAvdVcwdEhxbXcxK1ZtdVVFM1c2VHZ5QTl1ZWJK?=
 =?utf-8?B?K3AvQlp5VG1wMmI2MEQ4dllxUVdDYVp2UGZ4aU4rN2hKTEV6QTNFamN5dUVU?=
 =?utf-8?B?QWJlY2Vaend2YjNucWFFSVBUc2NPR25jb3B1WXMzWHVmODh0NXQ4M0ZndjlY?=
 =?utf-8?B?dkFKZ2F0bEtXS3YzVy81czFjUEorSE5wZDdvWDQrN3YrS3RGS3lwNjBOd0pV?=
 =?utf-8?B?aWpLUU8xTFNnQjllVnozN3Q5bFNIU1VEYmxyYjcyeitzWjZWUjU0SmM3UG9o?=
 =?utf-8?B?dWhNT2dubzkyenlURjhOTzI1d05vcnFWWGlvYXEzQWNzTHlXSzlpWUtCU3Uz?=
 =?utf-8?B?SWhhTkNPSEJESFBabU9jNTV5d01QYjNsSm1yWFVBVzc1QmdSYU5MM21XZEMr?=
 =?utf-8?B?OVRjNWlKcit0NXU3MHhYYXU1ZEtJVVE1VVRUMzdDUjJvUzRLdFdGTkVLajhB?=
 =?utf-8?B?aS8rK005UEJ5SUZ6QWpXQWxleThPMXhxVEhXcHRrMVNhZDE3V2dZMjJUK29Y?=
 =?utf-8?B?THNaSVVZUUJBa3c4YzhuYzhQclYxTU5abnczQ2pSVTQ0U3FyR2t2cWYvMEZL?=
 =?utf-8?B?Z1RDeDVIQWU3aUtLRVoySFVheUpnd1Rvazd0UXdhMDBVVWQvbkNVY0paR2ZD?=
 =?utf-8?B?amlWL0NsQ2dFaTdDbHRJSGtwaXhPeFg1K3Z0NjE0bDJYUmZ0QjdHNXN4SHBW?=
 =?utf-8?B?YTZ2R2ZrUEl1NUQ4eklPUTI2SG9QQjZNZ3hKQVdVbnNVem5XTFVmWFVUK00w?=
 =?utf-8?B?bk1zZTNSS09IMWZoMVgvbndxMGVTU3VEUHN5alhMamNpMUxoMmZVMWptS1Ju?=
 =?utf-8?B?YUlNaWxET09OSFg5WlM2UkhxZ0EzZGVrc1VBYWhON1V4dmt4Y1RvMUVsaHJK?=
 =?utf-8?B?L2pRVUVyUyt1c2N5bG5LVlU3SXBIckxDQ1ZFSldaRFVzUTdQZy9BQ0loTGNh?=
 =?utf-8?B?WlN2WS9PV3h4Ry9vcmtla3FHQ1pRSUtpQndKaHJWSUtnbFYyUGV3Q05pcStn?=
 =?utf-8?B?TjVxblFJSW5EUWlQWmI5MkhNRGdwUTMvRFZYK3hGeVV2WmtxRHI2U2NVN2xR?=
 =?utf-8?B?S1RnUGw1blhWb3VrdmMzeFdyTStLOXdvc3B2REhWRmZjQklsa3lYemE2V3da?=
 =?utf-8?B?WFZhd3JabkZRWTBidXF0eWZZR05pMzdDU0F1Z1p6ekVjbUdqSjQvZStMTlZE?=
 =?utf-8?B?QlZJbWdLcEsvRFR1blpCSWFNQXo3Nm5rTitwb2tML3A3NTdPRlZpanJQcjg0?=
 =?utf-8?B?amc4dXVqNS9ValBUVUhYMGVYSVB0bFdzaWZFWG5ucHdyWmkwOHFsUlNJNERL?=
 =?utf-8?B?OXMranhOVnVoT2dPNFhvTHU2bGVjZ2JNeGxDV1hpaHlCL0ZjenhrZDM0THd3?=
 =?utf-8?B?MVJvSzc2endaSnJWNWpPQWZhbldINm1mVDErdllQalhqc1NxblpOOWFiM1J3?=
 =?utf-8?B?M216RExmWkFndHZ0TjNLQ1RJWThKN2QybU9OYktTQUJDU2x3d29WOFpuMzRM?=
 =?utf-8?B?MkFyR0F4NTJzWHVoWkNCL01neVVnaElVMi94cWQzVDZDUlpLQ0h6NTFxc1hx?=
 =?utf-8?Q?/7K69uGpDno=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGF2Qi9XWVAwTzN2M3Z5SnUzbVZXMHVVbXFkeDJwVFJ6cVYzOG9xUDVrRCtQ?=
 =?utf-8?B?YnpJQ0ppZ3JrbjdLaG1yOThmQ1E5UElOWitEY3lETzhHU0F3L2MxeGUrSHFS?=
 =?utf-8?B?RlMxMUJVME0wb1FZZHd1RWFyWjY0YlJoMFhIdnpoZjNucVJvL0JwMnY3RHRH?=
 =?utf-8?B?d29IUHFmMWNDcnlHS3R2bk4zZzFxVzhhbGg3bHduclRlZ3J5MjM1NXN1aXNB?=
 =?utf-8?B?UXNOUGpvRTBLTHJvWWFoZytmcDF3SjNJeXAxUEhCVUZadkZwV3hscUt2QlQv?=
 =?utf-8?B?RjB1c0NLRm5DNmw1a0J2a1k1SkNWTEFTdHhBaHVqUVVhNHpqWm5EeEdXOXNR?=
 =?utf-8?B?dVZFRWh5cUpwMDd3eEdVU1Vtb3hRUzk3dXBvbldnR21GdlNTVW50dWhOTzRl?=
 =?utf-8?B?S3NOUXJIM05WS3krZXVYMlNGdS9sbENaL1h1T1NxdWFsSnRNWEN3TFNva3U3?=
 =?utf-8?B?STJFb0ZIMGxNbjJHZEl1YmxGOXpZK2FQN3BBZzJHSlNzbkxWU01ZcmY3ME1p?=
 =?utf-8?B?MlNZV3BMVTROOXFUNVFqdnh4U2NpaXNrelhkN0VIcy9ScGJRekJOSUlRcTg2?=
 =?utf-8?B?c1NyV3A2TmFRYTBtK0lmdkRqZjBxcUkvK1VWMzNWdkkvUWpnNXdqZDdFMUtM?=
 =?utf-8?B?ZUZicjV3SDRoL003RDFJSlFjRG1Kc2w2WEtUTWQxTVN2SFNrdGNqc0t3dkM1?=
 =?utf-8?B?WXViMWhPT3JLU0N0WWFUL09YTnhQTDg5WnIwNFNINGhRb0VIaU9BVlBjZHZX?=
 =?utf-8?B?TGMzTnV5K3VRRlp6MXg4MENTN29RN0hJdXlwQ05kVFhlR3I3RytuaDVuRDYy?=
 =?utf-8?B?QUR4dFl3T2dsVWtMdTZSVC9vdGplaWRGV0pHRkdDd3hUb0pwRlVjcVFxRGw2?=
 =?utf-8?B?R2UrVW11ejJMc0dtNGJxWDBvVkx4VXhqSkhTWGgrS0JHZUdyY3JkczJreHZ6?=
 =?utf-8?B?VGVsT3dNcjVvTExsNnVUV3A5SGdjWUhXdUJyb3pLZkhJUjYxOWdDeFk1SmZX?=
 =?utf-8?B?N29hamNqOGIyMi84UkQ2Rzc5alh2bTF0ZFBuZ2ZrSEprQUIwU0t0TVhBczdj?=
 =?utf-8?B?NzRkNjZLTXJicGkxdDNIRHFyRXVrTG9EODlPOFJabEcyVmZaRXI1VVYvcHc4?=
 =?utf-8?B?N21DTTNaWlBUY0E1aEljQ1R2and2T3ZyQmoxdFpHYWxNV1pKaDg5aDJSS3VD?=
 =?utf-8?B?OW1GVy8xZExzM1hBTEJVUnNFWXl6WDcvaWcyNFpMbEhmbTlSekFVZ1pab0hW?=
 =?utf-8?B?cktYZTNKNWYwdlYwYmRFa2IzYTZlYUFwWHZ3dW90MitsWHN5aDgyTTgraTFn?=
 =?utf-8?B?UVZYdlFUL0dSSjBjODZZbFF4bkdYaTdUVmJkRXArWXFBbDY5djZwRmFpSGwr?=
 =?utf-8?B?K002TlI3ZDFSY1F5NHZBS0hqOUkrckR2NU5IRXQ3N0ozV2RBcWZHSVJpM21z?=
 =?utf-8?B?RnV5MlpSZHRqNVd2SDBGMmloSUgxUkpFUkU2a0sxZDJOQ3UrOGEwUEN1UHdH?=
 =?utf-8?B?aHlyU3BuUTlybTJsSzNEWmFiZ1hFaEY5OXJvZm9SMWQ4WTlaWmo3OTlTVncz?=
 =?utf-8?B?MmJUcDhxUmVrU3hyUm5XRHM1UEVzTnY3dEtuTEhOQmRCR0luOHBqUzlENnEy?=
 =?utf-8?B?K0dkT3dKREtYS1JwbkUzSi9Yd1JFZXNYTlV1UlltZmZ2d0l0Z3ZJUC9Ncm5i?=
 =?utf-8?B?QmIzRm5BZ3dTY0VnVlVONmpBbmttd0djSzJDTzdVVHNqZ0JQOHQ1QS8xZ1BL?=
 =?utf-8?B?c1hGbmI4aG13eWpYbjFhdnB3QkliZGlpd0MrYVJwOUxSY29YUWJQSElPNnpQ?=
 =?utf-8?B?dVFNcEFmN2Y0WWZ6c0FGZC9FK0FQZWVpUVN0Q0FGRXR0elgyemtVaDgwVm93?=
 =?utf-8?B?SkNpRTkxODZrZjkrUzE1K0ZMK2loTHVYa0dzbkxXTm9SNlRZYUk0MDZPV0RR?=
 =?utf-8?B?Z3ZETlRzR0hIMmRFMHNYQkN6VU1oTTB2YzVTa2Y2Sm9rRlZ2eGhRRXUzcGxo?=
 =?utf-8?B?UTIrbW1vQXRxdzJaOFRLQTU2UUtkaDBCL0U1a1FPS01uRWs3amtQVGxURDBy?=
 =?utf-8?B?aXlpVy84Q0sxellocEwrTzkrM0ZISXR3aVVEOUg2c2Z5STgwOTJPanUwR2J0?=
 =?utf-8?B?R29FcXJXNkNFa2FkN2Yybi9nVnY0NGZiakNQRllJUDNLUXFRZm4rVXdHSWxR?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JhTaeFGbcb7z2tUAcGGxSH75VRYfKpFbjSpyeZgOwUBREwdCGlL5e1w5jwzZz6UbossyjNFseSdM3Jygf5bSLQGdkWNmh8RSGu+00Yqk0njlSxXVqcyn1w5Ves3wCVJM4EetLYjsInaKp7mDgx038RRdiImuSSBSPtXvgFIpa90bf+orS5YFwdVzLruV7A3Q7bSDyL2VJfHzKUqXTqQ/v/IFy/gVLGCefs7Gvj+V+JHjYn+4S3HCuNZ/3ocNj8zDvH3ny+K/gs6yBau9dOlby25A7skzI4swhC4L4xJWzJw8iNO/PcDRS5ms8NfGv9glEmOvv8gyDJ+RZxONljcQ3HhMP9zEpk7aYYgdZRRDgDJcuSwO41AoJAm/gk2n7BP6G0PMe31m57WFIa6/uXLH+NcypWmk0vJI/t03gZSUzZpN6BYy6RnQMfm5jt/DTdMF1dfpHZmy5jTMtYoih4DC8s1/WFnfz798xBSK5xqv6vt1AUmLtx+qFwIZWbBEADemU9BPgNxQr3HXNo0w1Xgcw+zldKdDvgg2tHTAPuE1KGM5DEgwOGXmPp8VD2rwmMILxVulyVRrQsgeS7tli+YfGSxfW4zzea0/YizrK/8movY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 062c524c-f189-4c1b-6740-08ddad97da03
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 12:09:47.1422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QLLHZDQnxFoO1rKNuqaPKzh0kVkOdoTsSn+MS7wCNW5iqgU+/XstKEez534OeDNlVHoksO/B93QmPbjvrJXeAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7871
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506170096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDA5NiBTYWx0ZWRfX+a+GyaUlY4KN 0m98MNiAxOHCeDFEhOkajB9WYxDlAQjmlnYFtHaEU8MFiWnMW3PnUSZr5xA13hjJlPx77OoojZN zii1PQxjRlEgbysk2/oeIbXeOKwAUN1+w1tTCuiL2jOHLFpI4ktwCHGWplgvUFQkMFEnF5Oy9r+
 W+h4ZoECwN6Epce/aQ4hF67MiFHfFqUcPOIiFpciYSLfw1vY/RJIpakzACVOROtAgQD6enYX8rN 3KNMT9jpM+Q0tMK6geK7ERWxONhr7nHvQn0ESyMLtXn/yO7kaWV0r7zJiYqB5f7224nvyWzzamf oMP8wgtQE52jnBqA0VmuAJjOFAQNhDlKzaMLWZXcefR6oSO+AtZC9FInMB/e1+SNAGqDT+L7+V9
 2r4HWzcz3GA8h7CHLj0P2166RQ1P/vqrDWq9NkR10E61XKQkukOqcQ3qd91VfdgyuTsNYdJ+
X-Authority-Analysis: v=2.4 cv=K5EiHzWI c=1 sm=1 tr=0 ts=68515b0e b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=mcKW2pmY5da0iwsSobMA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714
X-Proofpoint-GUID: ouS-G-Qlt0MswZJVFpiqN2tvSqTwhT-2
X-Proofpoint-ORIG-GUID: ouS-G-Qlt0MswZJVFpiqN2tvSqTwhT-2

On 17/06/2025 11:52, Christoph Hellwig wrote:
> This extra call is no needed as xfs_alloc_buftarg already calls
> sync_blockdev.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/xfs/xfs_buf.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8af83bd161f9..91647a43e1b2 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1744,8 +1744,7 @@ xfs_configure_buftarg(
>   	 */
>   	if (bdev_can_atomic_write(btp->bt_bdev))
>   		xfs_configure_buftarg_atomic_writes(btp);
> -
> -	return sync_blockdev(btp->bt_bdev);
> +	return 0;

we only ever return 0 now, so we can get rid of the return code

>   }
>   
>   int

