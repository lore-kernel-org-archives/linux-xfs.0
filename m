Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6BF136A
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 09:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732093794; cv=fail; b=GKzudtuxeqjvoU2RbOs1Xib4qeg6Y6a+QPB2ukG5PIDO5G8XmYTymghHJmHRzSd4hbIWSSn4/pmrGUB8/UVjRN0HeiZgPKki+p6gDi+aokgk9BDUgX15SIy+Cfb2HQvACw2mgxvBpXsGELNI7YGUzutmU7iMz8vdbvpmOsFBFus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732093794; c=relaxed/simple;
	bh=9HTzV1UXmduWZq2sWLlCwNwnewAfb9q28Om3vtkVEY8=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SAfBKNd/2VX5hJhrjUYckM9Gt/agJqBetzuFVre/yZq3y6QvHEJM6YVeIUv4kS5Z+T4IhWuHGI4T2e/d7ZOaiUxvuTyIy5c0EbmWbYfuEl1v8BcXKqpsFC4ZNrSH7+y8TjEXT4M5PVn1zuZO8jkVcYakSMxr3Xg20hw2ufoder0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fZjPS9Zo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WizQtxk/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fZjPS9Zo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WizQtxk/"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AK90cq3008853
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 09:09:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Id93p7AdBV98YHz2xMG3tS0HP86xy4zomiPEqa/p2FM=; b=
	fZjPS9ZobNxIbGkJkrrXZe3WazDtYE6keCsC8KRP5Oytk90RUfL6zWl9WE5fpbT7
	6XnbWR7ehMpWnW7wUIZUUe64kZtPEf3Zc+K8aizQPxWJDdLXCsMPrUZ3+yy5BKlG
	ybgBT4uwE6RTBOOO1Hv6Fx/QL0a8c0RmjHjkKt7hbpkjrpBm+geqbOdfxc7B2z2R
	8GxxBsnUohR54+UF8yqxcz+azbdiM4UozrA2FTYAAMDNoKQTRrGkA2/XKCLfmVcT
	PfoUYshauLYSaNEhf3UH78BGbqymjBru6Lrw9HIXBdlBRJnSsXTUJsV9+9FnXwGb
	+yWsZKwUs50UmJrxxtcvWw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xhtc6xbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 09:09:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AK7ibfM037093
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 09:09:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu9vjaw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 09:09:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yeNODTNTgWiUPAiQ7AW5HrjqROyVaZroCEey85Hc0TgohtoA1aZ7xm8rfU5efn9vpM+0gIXVP4w7CV6UgfUaBoqYf90McO5D51hWjeqGJhS2DNkwL2OkTbbss7y40cR/+Ehjgf2tUy29CQhSsLrdvGNXRGXJI70Vq3owW5hQVCiS4KzlJsdCE/q9wxZhMVPoCn9W3goRxm0akL+LeGyGUv5bVgHY1Lx/beFgNY6n8EU0qryl0VkaynZ0kgClJeRC3xF9Rv1Zh7Gjizc0Vhsfwe1TklCc3V3uNs9/NchdKZmo6hFQBrYKNtNPO++8pyckICh6W05XWPH8C+c192P/iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Id93p7AdBV98YHz2xMG3tS0HP86xy4zomiPEqa/p2FM=;
 b=jiAf3cRWY7/DQPRKngNLBrbbMKSIbDTTaxj5XhGbSY/NzEp6xQFVfpY1zWCQRcy3PQ5BctEzlcM0rnelRRrYULSkvgETWFKKzu1NxQAKb0MsrK3GSYnkQjpotDTtUoWwc5oOfqTNu6vyqssKnsZvrgzLZD2H80jzvqLdTW+Vmm5QuuYkSk1UBL+ts/ETDdXunhm8ilICyWl3OjaR7p9nI8s+6VcNXER26Ug/ANeJf2Fu5ralJwyYrolFEA/1NUpTSzEQJFP4VfH4wyefBekgs5mLbSzRQFzEFFpLwdEhsmpgj+oq0xb4n6m6Rne6vlSdRLaKgXIsz+oNyhAWQbWf/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Id93p7AdBV98YHz2xMG3tS0HP86xy4zomiPEqa/p2FM=;
 b=WizQtxk/ieo4QY+BUmYA0pxrgaZ72E+BcPoMCuJd56wfDQJoDURWttFiZl48fxwBM+V4lwIJeb4tbPP9S/3EX0C/pRYl1CrvgmaTA7kfhS/YTneTjd7kfHiSNMSVWaxbupH5wRpB6GVl1qZXZmUDfBKuo/2UFSIVyC9Fmz7xedA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4919.namprd10.prod.outlook.com (2603:10b6:408:129::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Wed, 20 Nov
 2024 09:09:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8182.014; Wed, 20 Nov 2024
 09:09:47 +0000
Message-ID: <b1bb4d50-d0d0-4592-8fbd-00beaf0706db@oracle.com>
Date: Wed, 20 Nov 2024 09:09:46 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs_io: add support for atomic write statx fields
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org
References: <20241120023544.85992-1-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241120023544.85992-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0098.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4919:EE_
X-MS-Office365-Filtering-Correlation-Id: 98d0de23-2b6e-4bde-53a7-08dd094314d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c0craHhFNGNqQ3Z2TUVWdnI2YkxrY1ZWZ1lIMVU4SjlNakR4Y3NBaVJFZXRY?=
 =?utf-8?B?ckJFc0ZKY2l3Z1ZML0JvOXRUdFZqa1IxS1duY01wSUlVUGFIZWYvejFoNVlQ?=
 =?utf-8?B?TUVjL3h6YVFmWGdsZjRKQjRCbUV1YldkL0ZCVDN2OHk3WWU5eHNVODhwNlNs?=
 =?utf-8?B?MDZMR0hmTTdZMTErQ0tCaDlUb09QNVg1aHg4RHQxdk9Yek14RHJ4dmNaVjlI?=
 =?utf-8?B?WDBkdTBhN0liRXB2M0VXQXozTDlRS3hZS0h5cVAvNDYxUjVvRjhYb20zblVp?=
 =?utf-8?B?OXFyRWYxbGxwUlhnM3E2eEorT0h3OHVkTzNvMUViTWJ0bXNxVW5xUW13WVFF?=
 =?utf-8?B?OXhhUVROOVkvTEJZQnRUS04wMUh5SDhwWFFXQjU4RHJ0WENJbm5GYW5aa1JC?=
 =?utf-8?B?NEErKzFCYlo4SndzVmV2dFRvYUlsbmwxQVRaVEtqKzJtZHBpdVZHWWhnWjJN?=
 =?utf-8?B?N2VHVHdFN3V4My80a2xYbW1wVi9KbWFLZ0JBT2ZEcDdINkZFamRjYmVyTjNB?=
 =?utf-8?B?dStmS3J4cU5kU0hBOXoxeEJCOFFodkNKK0VzcmNqVHlPQjVHQWFEdGFwT0lW?=
 =?utf-8?B?VEZVVHp2a2ZxNGJkUE5rZ010WUxyd1UxRmsrSnFGZCtnaHY3dnptQnQxd1U5?=
 =?utf-8?B?V0lSZ2x6ZWh2aFNaRi9IMSs0NDN4Wk43SHYra2w5dS95Sld1NDQ4M1U3QkhB?=
 =?utf-8?B?bXJwS0wvcHd2M2tGaUM2Q1loQkpmcFNBMFNob2ZUZTd5RnlUWkNNb0ZDbjIy?=
 =?utf-8?B?MndMOW81OUFNSG5kMitPYmkvUURhUUJCOCtuZ3FXNEtuc0FxOVZ2djFGK1Zm?=
 =?utf-8?B?cnpScUxkR25KemxNc0hHbkhlU2Vjd3NDNlk2Uld6ZndJaFI5MXNXL2VXcnpM?=
 =?utf-8?B?UXVoRWJJdzUvVEsxdmIyQ08xY21wU1FiL0NEdk9ER0RIdkFXOUkvc0NGc1d5?=
 =?utf-8?B?bGxCOTY0bXZ0QkFPa3l0QlYxVnhsdElmVzhRRklZN3F1cVdTVVNkOS9sTnZs?=
 =?utf-8?B?UHJubGtKSjJxb2hzTGZDNXk4bkV1SXBScWpKalZ3eVIvczZqVUdhT05vMmNM?=
 =?utf-8?B?K2R0dlhRRThKZEpNQU1vMHI3N3dXYlppbGdzTTN2NkZnTXNucXVrdmgxMVJp?=
 =?utf-8?B?UC9aQXhmNE5XNk0vb3M0dm80aFQ3K1NoYmdyQVZLMXp1cEVVWXRJUEp2V2My?=
 =?utf-8?B?KzViRjVnYkt5ZStTZGVxSCtrWGZPOGZuZFViMllQVXBoeFBvN0VORy9TWE9y?=
 =?utf-8?B?aHB3UVlXZnNlbWRWNmVjM1kvM0NzQ0wwRlBQdVV4VEkzRDlMc1ZHaTR1OFk4?=
 =?utf-8?B?NWtETG8xbTRwM0FsbzYrUzA1T1laRHJFajlEQlcxUy9Fcy9FaGpRRzJYcE1o?=
 =?utf-8?B?Y0ZNY2RhNlEyVElRZXd2a0tWVmJQaHZhWUZnMzhwU2d2N1liM09EcnM3YkEr?=
 =?utf-8?B?c04yQ09uWmd5Lys4TDVjWnN3ZDBlUXM1NmlUaS9FTXIwK0UzdDdxRklIdG00?=
 =?utf-8?B?emJvMFhhc1NoVmpkVmlGamozL2d4RmNDaTk0S2x3U1Q0MEJuNWdtV0JHODk1?=
 =?utf-8?B?a3VCYklNVk9ycmRpVnB5WHh2MGMvY3JPY2c3USsrWFM0WGRUK1V6U01Pd0hR?=
 =?utf-8?B?Z1YrNmQ4WUo0TlNyWkhKc3JqSUlFMXhmdWlqSkZjMEZ5dDI5MkREaU5wMVdm?=
 =?utf-8?B?MzM4R3NTOUNJSTBjNkJGWFIrUzhqckFIMTI4RmVUL2s2V2lZdXNYcEV5VEtz?=
 =?utf-8?Q?k5Niw/XZ+zGA0QBAx7fAyNuuSIQ1GDTHNzuYuX2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUZwM1lNQVQ0NUEySUJGelRPUDV0MTdLWlA1bnRFMXd6aVUzckVCc3R1UFIy?=
 =?utf-8?B?VjQ2d3VVaUdGc2FwK1dpOWZYU0ZGdS9BVHRCYnlIcTBuc3N3a045bmtHdzBI?=
 =?utf-8?B?VWtYME9SdGx4YzU5MVVrM3NqeTRvbzY4YkVpdFZVOWRVb2pPc3A0QVVkSmdk?=
 =?utf-8?B?eXA4TGlYbGNsdzNGZkRNV1NzUHdxYmt5Zk5sNnpNck94TmVyMUdrdjlBL29l?=
 =?utf-8?B?RWJhUjBNMGsrdzBUMzU5ZGRoaEdTbC9Jbi9RSnBPQUZ2bExvS1pOejl6ZXRD?=
 =?utf-8?B?Q1lDVzJZajJVYzFnc0xSbW1BK0xHdlptUFJtRTlnSWg0ZkVxb1JhWTYzSHJ6?=
 =?utf-8?B?d2FZb2wyVU10Z3dWVUpXQ3pwZFN5SVVqRlpiZHpLU2pOdHl3Q1JWT1BFQWFV?=
 =?utf-8?B?Tm5ETUtFTFZGT2tiNCtHYTV5Q3FDV2ZlRWZ5cktsY000eUI1MVh1QzFaZ2VU?=
 =?utf-8?B?aXNRVzd2aGsvN1RsSzFJMXdWQVlLVFNKTW1lbFFLWlplZWIxenp3eUlacWlm?=
 =?utf-8?B?VHJmUW5Qb0NOOUNrVzVMNDlOR0dLYkVpZkR5TzAvWW5Gd2RsQWxNcXI4V3FR?=
 =?utf-8?B?cGZoaWZ1WGJKa0k5VzZNWXowL2x4clFCZjdxWldSRU1tZTNEQVFjMTJQMnpY?=
 =?utf-8?B?MjRPamUveE5VT0I2SFZNSWk1UGdGWGEwdndMWTl6c0ZLUkxUdnkzVWNwbzBV?=
 =?utf-8?B?Wm4zTUdZcGpQU3pnK3ZVZ2RmZExqOTZKRVdEd1cvOHpxVDhIWFpPRXlvY3ZP?=
 =?utf-8?B?V0FBTzYyNHZRdmdRR0wwMWx3NVUyUm4zTXhBc3Y1VW5MVDdjbGxtV3RZdHZX?=
 =?utf-8?B?SHBpZGN0dngzUFJlRFVJcUliUWRNRVc4bzhNT281TVhVaitWdCtham9COGJv?=
 =?utf-8?B?OTNhTXJTRWhkU1Z3QVMvU2ppSEc2REkzQ0UwMDEvd3l5R1RyRk5FS0RNV0xj?=
 =?utf-8?B?ZjlpWS8za0FubWIyN2Ywemo3UjQ1c0djeWJWVmZjV0EvTnd4eFlLampWbm9L?=
 =?utf-8?B?akIzc1RQMTQ5aHJTRjBKQUZuWGFscSs5SzhBanRpd0NyMWQ4cTR6eGVRWjVs?=
 =?utf-8?B?ZDNHTGREVC91TjhJakFYOHYyRzdzMGFsMjFKSEZkbHZPdVVHdGlQY3ZCYzg0?=
 =?utf-8?B?bXN3dDRvc0RMd1o4c21WRHVZNTlPQXhEWUZ1K2dsWm5wdU5WVXBVWEcxbmpa?=
 =?utf-8?B?RGdISXp6RG1NTEJYSGR4elV2NjN4WmZOcXFpQkJ6NzZkYThxWDBTYWkzQlVK?=
 =?utf-8?B?T2d2Nll5c3AxWHdpRTdLcVZUZ1ZCdndiSndsTE9CZnZmT204dXJnTkU4QTFm?=
 =?utf-8?B?QTdnUG9NL2gzTzJiTGZ6bXhEZ25xS29pZjBLd29ienJKbkdNYmVheU5KS2JT?=
 =?utf-8?B?R2ROcE9YLy95ZnU2bnlJbVNJQ3BnUytUTkZWM0RWbmNMM0J0RXYvY0psVkFY?=
 =?utf-8?B?em96VVMrZ1I5SWJUMnRVbWhweWdseE5jVEVmdm16YmNSOVhQdFQ3RFBmS1lD?=
 =?utf-8?B?cTg4VW5iTk9uakZFOEFIWVVwOHRTNmtTOUIwT3hGYmE5N0RGMmZtaUlQZW1V?=
 =?utf-8?B?UXNOUG1HOFVrY2t1UGg5emF1Qis2TTZ4MGhiRlBza09EakhtZm5VdGxQUEs1?=
 =?utf-8?B?QU15WGpUOUJWRGR0Tlh2R0U0a21OZ2Z5YjYrRE1zdHViUUVSbWRzN1BMbVlI?=
 =?utf-8?B?Q0xmYmdXUnFaalJIZWtxWmFjZkFvTlRUOHRoQmlOenBDdjJTQ2t3RWhzSjE1?=
 =?utf-8?B?TGV4QTg1RE13cU5lNXY3WktTZ3lIRmtqTUh0OVhjdFo0aldxZWV4OTVkK2lj?=
 =?utf-8?B?SFVkOTJSbnRoUFJnbHRHVVdxeGtLOCtTYnppTGtwb245eHlWdXY5ejdLcitm?=
 =?utf-8?B?NXM4YW9QWXRlL2J1cmFuRHdJcTdmVkxlYXorOGl2Z0tNY0ZvdmRVZURzMHJr?=
 =?utf-8?B?TnozMHVoNFhLSmxHNjc3K1JVTWpYMkt5WTNWdWRqeVBhRXRmbmNyNndId3Ny?=
 =?utf-8?B?WkZhbm13dC9uc3E2Y3JWc3VXRmFWYVJyMjQxek1ZcGRTUUplNDYrbENGdXZx?=
 =?utf-8?B?K3UzQ2F3Slc0Q2dieHVSZ05KT1RhclFhb3Fpakg0RUtlYmtHSDllMXA4QTQ4?=
 =?utf-8?B?ZWJWWGEyVldEQXhqUWRMcXFuNEwzb0NINURrcXVUbU83UzIrZ0FLWXBMaDRr?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WPChERjH6ojElt0awwtcf/TrRH7GU6Ko/tSIDfIdOL51JaL1eAecNFiE+fTXeaeqWBi3OraHBT5LrCeBEFKrj3OJZ1YtGMpn69qKoQW4KV3qO6ymcqIzJdRNiLeRinHjnviHNUCOInYbNC8Gw9nvercJ74hZ/W/hr2CPBNGH9nsxTq6jlN77sqn0ZuXF7SGtgGo+e7Oa6V5FxTsX4XqrW+rpPdri1rjrImLwa1iYdxh7D/GadzC329BqW49n7S3WXpMQMxhdixfjpllKl1t696g9zTbdYrRnLXeFHccORwuU6NmHvdrV2lO9xeQRF/Jbp+tu0/0J0YNrJdDfdJsf8gXwrpqY4wHO8eOjEq7cjAPx01Cccdt6+uQ+vZQgeN2EgpDUuXlhkdHSD+A25kW6oLW6tEghrJ8YZ+BFyl3U8Fs8UzSf0MtnXbTu5CspBXvoErXNJwnuY1oDFeRCUtL6zVo0khIfFKMOuZV8vrHpjeHsoW2qHWHGy7qOG0QWKJqPcGohjcDuLrpnQAp6Vc1cLC17j7Awh0M5FR46X4QmiMLSueuqCFw0rR2LOaxMDX3OLH8oyQx+XU/qFAqWRSoHE1olzt2wgEvmGleFHYrUTrg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d0de23-2b6e-4bde-53a7-08dd094314d8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 09:09:47.6921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGPsKL+0fttn4Af2mSkScE3L5F1eJ6b4+Dr6z5Jp8Q5q45YYBoz1sGbt1DEgmWSZCJ90Fpiuwubu11HejUN35w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4919
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-20_06,2024-11-20_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411200063
X-Proofpoint-GUID: CRggLlZOy8izNZDfoCljnt6V6q6Y-Lp5
X-Proofpoint-ORIG-GUID: CRggLlZOy8izNZDfoCljnt6V6q6Y-Lp5

On 20/11/2024 02:35, Catherine Hoang wrote:
> Add support for the new atomic_write_unit_min, atomic_write_unit_max, and
> atomic_write_segments_max fields in statx for xfs_io. In order to support builds
> against old kernel headers, define our own internal statx structs. If the
> system's struct statx does not have the required atomic write fields, override
> the struct definitions with the internal definitions in statx.h.
> 
> Signed-off-by: Catherine Hoang<catherine.hoang@oracle.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
