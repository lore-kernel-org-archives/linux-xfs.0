Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007FE26F44D
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 11:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751367933; cv=fail; b=GpmqvTgl6GbBPB3lu/F6xQ38plNK6sF2rtqvSIhJxL3iiPX6h3tHRobTYtOmATVg+jHXVh++APGvLOTMeLjcH1VvQrYr2vq4f/6V0xZ/y+GwfiuMaHUvJvrnYl0CGyDYeYv5IqzrySRnIdUvoWzljcopiYLJVDwaUIVGheUmEsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751367933; c=relaxed/simple;
	bh=R1S/lEtaBihltob+83xMPW0YjVAuR741zysTfT6SyfQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s6yHXwn+rJxGrhyBrK1BcEp8gpjzDdxEsFAJpFQpocoXhRod/SVSDh6/g+kH4PhmyHrHzZjs3Qqab6hcig0iwNAILyWwo9/9VWESb5KaOyERA9j2kyeQSRxyGxrok0Ks1ZM0lGaVvgYB3y9eOUZaIoD0SRLo4K+QnoZUSgknCvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W8oz4IlN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cJXXSKZY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W8oz4IlN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cJXXSKZY"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5611MgJ9003037;
	Tue, 1 Jul 2025 11:05:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ofV39N92G4ZNkG231bcTx6WFyKY6V3Kl+eqTjRmVu2U=; b=
	W8oz4IlNiqW8SwRbqwiwqUeuteIpz5YFy8LwXijcl2DLOjPpD1tP9zgxV8Jx3/0h
	0Aj9OZXYYSSXb2/08qaIoj4OLHe9Ndr2RjJGB56TVqch3qbgJ/dRB6FBCLZxMaKG
	aamd/qFuvTRH8YpPpO6n+QPLibtV1wu620PTGb+zCG4WH1JdEPCILfMs5OFFhNwY
	tJ/CwwmSFD2PZeJmsnGtCPXDQ04ITSOQnI6TwscT6ZzIjIWrF0+piiCI4h+/1kRw
	XyjURXrza56daTf6uZsGifyn5JsIxJKj2vgnHXAF4cBdR3G82dMzncvQH5ruDd1R
	tPuTZUkEDJ/P9/XQ+S2kWw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j80w4gaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 11:05:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 561AoAxi025781;
	Tue, 1 Jul 2025 11:05:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6u9ks1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 11:05:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oaA/x5eP5PH94/kMTscgNu43bwfDoM4lMqvU30lBif+yokLVnYKImj1LtQkEwGXyX0DyYpvxd0oJ7Elr8EH9SITSMV8mS5rTzOTe87VmiXLqY6URwJYJuiNf+Jx+0HmKKTEJ33ZBd3iUSs69ca8ysLI09aamNj3L/6rZIJsZPmcQ5em530ZeknAflnC7HIXlNwVBnZhdCJIBQ6/HYLbPtzwnEFUqtrTnnmKyEtxuN5fp3ckOHEoajhicy1KTqZlNofc/zPVPP/ajRtaTgjGuT9UEKFgcp/hOolk47a0EqnVzaQ8jTRgMvyilTvoAJA+LRfYWVJZ9DMYlu20vqiJ7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofV39N92G4ZNkG231bcTx6WFyKY6V3Kl+eqTjRmVu2U=;
 b=TB5ZaetGc8VX2Zx4Bkg5aBpIRd7otUSGqghq/z6etnxBAfGishUTSBg+EMoPMAb9aIrVrUPgxZ9r1LoxeJzX8JVepA3yH0N/U5pwM8c208xKC2dpWkK9rRVrA1F5W3KhRCnExeLvtdPttEZcDSL4gJXpBb/X3FVPumC7CEb0DRPUpniRk+cI1HxIeNEgrAWEP1wfNT15VNePOF52b9LBH95IZsLkUXYxKVbuuostwr65IIAlmE80b4CZ5iP/PPWrbWIG3lgb+F/KL3L+9XIXu3P7jxabZZjEUhn7GZaFzTK2KRnJgcpcxjPVyIDJEAbXw/aXdBLzPztnC6+BgsFPrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofV39N92G4ZNkG231bcTx6WFyKY6V3Kl+eqTjRmVu2U=;
 b=cJXXSKZYkY3YUfWKxIogpY3Wz7GZWMHi1ZCKtCM46W4TqaGI4e9xC4U5ptzniOyDOFRCHg9VTLMaFuOyuKIBkJJMNctU34p9JhejSef1KpBMDEixtMtY/YKJGGGi3lTRLnKlEejHxhtLykFXIkl5QqidOnsnXm2elmZTxPKyajE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS7PR10MB4990.namprd10.prod.outlook.com (2603:10b6:5:3a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.32; Tue, 1 Jul
 2025 11:05:24 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 11:05:23 +0000
Message-ID: <ac8aa888-60d8-4aa8-b6c9-a70cd3297205@oracle.com>
Date: Tue, 1 Jul 2025 12:05:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] xfs: add a xfs_group_type_buftarg helper
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-4-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250701104125.1681798-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0114.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS7PR10MB4990:EE_
X-MS-Office365-Filtering-Correlation-Id: 04a11179-7c02-40bb-c620-08ddb88f2d3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OVhzVFdleTRIdldZUms3Y1BIckhhNGxUOTJCbHU0Wjl2WHVIcm5mQ0Q4YTZn?=
 =?utf-8?B?S3lpUCs5SGswNFRVKzZvZFVZaCtLWUFUeHltVU9NaWFCR3l4NkZvdjI4ZmRC?=
 =?utf-8?B?b1B3M3VLQVZKZmFOek1iQ25Yc3Z0YnVnVkZiY016RWdGdVdNNEhFeklwdW9J?=
 =?utf-8?B?SitTRlh4WGVIeGJHeHBtM3YzNnl5VkVuSXgrY0xzcWFYNXozRWxsSTI2U0ZR?=
 =?utf-8?B?RStSQW44aHNhSDI5QkhydzVNaWZweWhKVkp1T2JJV29BWGhVYnB4bmpQdkNp?=
 =?utf-8?B?RjNlbHhrSXZYS2ZaS3JLQ3ZPdzk4RUVWdmM5NDZGTlNRYlRMSmdaVGtlYXE0?=
 =?utf-8?B?LzhkVGNYSHYwTU9rd0g3bGpFKzFQTDRUMzg2N2N2VWxVSFQ0cC9vV0c5dEo2?=
 =?utf-8?B?QVNOQTVYOUxKUlgycnlESFhMQ3ArU0o0ai9weGZsaS8yTmp0NXp1L056VFhU?=
 =?utf-8?B?aGw2ekFVcXFKTlhBcFFKTkJGejhiT0V5ZloybW9VY0F0MkRvQTRyam5nTHlj?=
 =?utf-8?B?M21GRnM2UWREVlJqUmdqSWJzeTIxTld0cWJrSDVrNitUS2VIQjNKMFYwNDVx?=
 =?utf-8?B?c1dyYU9LOWVvMUFveHVNbmNWc1JwM293OUdPZ204VllTajhMaWx4ZWhCd1JU?=
 =?utf-8?B?T0tRdkp0RG9GYVBPVG5nM2N4VGRuMTJaN2VDdFZJT2VrRXBpMjhEeU1SL1E2?=
 =?utf-8?B?dHRCczRCNDFSaXBqYlhoV1FhWWE1SGR4VFZnQ2QrN2dDTkZJczAycFM5YVd5?=
 =?utf-8?B?T1ltNUFZckRDaWFBcTFvTnFlQTZ2VWtvU0M2RHdKQ2NFcFFaSVBLYWtEa1Rs?=
 =?utf-8?B?ejN4aW8wNkpVdE9oSEVVQ0lWRFhmMzhyQlo3WGh2Q1NDQ21IVkMzejZWdWxG?=
 =?utf-8?B?OXR3Ym93ajBWSWttYnJxYlRYZTBwbVBqMWNyYWVIYlZHQTlNU3JWMEVGWU9B?=
 =?utf-8?B?N3pUekVibzZoQ3ROb2pQcjV3dCt4Mmx2SkxFUS9SRUFPTDFhL0x6K3hhUEla?=
 =?utf-8?B?OWNGdWtBNGYwdSt3MVNMaE1tTC9qdnhxa1pJbVRKU2hTeTBuS3VqMDd0a0Nr?=
 =?utf-8?B?bjdPZjlCZm9jbHQwQ0I4ZjEyU1hTeExMMlF5NGx3T2trOXJGZm83a25aMVp1?=
 =?utf-8?B?ZjJCTXJvYWI2Z1JaTzViVUdEc2Flck1NTlMvWXBuWXQyLzRIRkphQUhSSHhu?=
 =?utf-8?B?SmRtMTZoOVVIcUU2cHNTUkpicElXK3BoQnNLM3kxazZtdVlPWXhxa1JyRGxI?=
 =?utf-8?B?bzFmMnVGMDJmZVI0RDRlUWpTWDJhd2VweGhCeS9lMmllVFJIQnJIWHJib2Iv?=
 =?utf-8?B?cFljK1ZFN293SGhjRSt1MVd4QVZ3R251VzV2UTE5ZW9KYmtNRCtzVHR5eGl1?=
 =?utf-8?B?QkpvR2NTT3ZvMTYxbGUzaWNUR1Ryc2gwd1k3aFVOREVUdUhDOU15eG1PZnVN?=
 =?utf-8?B?UXlWNklVemRuL1poanFxaENhcWpLRmNvYUZWU2laNldQRkRMeG1tRlQ5aVV0?=
 =?utf-8?B?NmpJYjFJMFJwK2ZPZEUxeXYzaWdvejNTZjQzTFdVc1l1NGtmUjgwdjJRLzFp?=
 =?utf-8?B?RlZlcjhBTGJLTXdnNk5hd2tEZ0YwUmY3bndDVUpuMGJFeUk4Z3JZTndRSDYr?=
 =?utf-8?B?cUptakYwaXZOaXBYRXJXMnk4R1ZORld1SGE2YWs3M3A3SUN0bUFLWEJ1Mlll?=
 =?utf-8?B?VzRVM3FMOTg3Y0toRU1yTVpiNnVSemtNb2U5UFpwcTVwRVZNV015Qnl3NFFO?=
 =?utf-8?B?MFY0ZmZBU0pjZDVVaWRGeGljTVRWQXg3ZW02NEhsbzdwdVJUT25WbEZaZVhz?=
 =?utf-8?B?N3lMSmVqOVVsbGN1L0E5MkNGVm9INWs3NXZsU1Y0bnFKczFqanN3aUZSZjZs?=
 =?utf-8?B?NjIyNHNPWFcvN2EzSDlrZHZjZWxSUXM5WUxJNytrOXd4WEQyZkJMRS92bGhY?=
 =?utf-8?Q?LnQ7U9lj5X4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dy8wVEJGa1ByOGdFRklSeS9SbW5QdDVDWmxVMHJiRUxLSTdSSmluWTdrenRP?=
 =?utf-8?B?YnRsWFBCbWVBRWlscGZJWDhKQU8vakNBNkhZMGUrUFUyMlU5c29NUFJJQ080?=
 =?utf-8?B?eDI5MFNGRXZKbjF6MWsvaDhRM2gxTTNSVWhaZmc4Y2cydXZvazkyVFdsd0tj?=
 =?utf-8?B?VGF5M284UEJ3Vm5FcE1FeXRNM1lQVkNmUi81WFdZMi93Z2F4aDNuc0lQd004?=
 =?utf-8?B?bWRPdFd6YVhxR2dBS1ZTZlhxWm93Vk9aNk0rVFBnS1YrWFV5OVdvOTdQOXR2?=
 =?utf-8?B?M01Ic1BJUVNzUCtpeFM4NmhhZERRZzJzV2tXU1N5WnNjTi9KbmVjMy9FTGJ3?=
 =?utf-8?B?VWdyS2RYbStycDFOSmw5K2p5Vyt5RUZjOEJVc2gzWHJqSksyQzFLeWNNZ1lM?=
 =?utf-8?B?aFFRS1cwZHk0MUpSSnhkcTBlRzNWUjZnMXl0WGFySFk0RythREFnS3hqaXJ2?=
 =?utf-8?B?dFJ3VTZFUS8wZ3Y3TWtISEMvSzR6eThpSENyeENvbG9JNlFuRW9LdC9DZ0Jm?=
 =?utf-8?B?YldSUCtmTTNXVjVXR0lHQjB4OHNJcS9YZytKbFRUT1ZqQUFJV2VENVlSVXR1?=
 =?utf-8?B?VzFPVEhGRG9rdTY0WVdIbGhIbWt2SXU5UHVjaVFqcThsS2JxcEljVmNNS3Zs?=
 =?utf-8?B?VjJVRXFpTThGcm03T0VFVkkrTTZubzhmTkFncGFFYngrc0tkOWxjL2gwSGdE?=
 =?utf-8?B?MkQvTktNeFdRTCtYd0IwVlBvdWdKREQ4TkQ0RWlYQVNPdTdSNHBGczhaeVY1?=
 =?utf-8?B?cVhjRDVzN0Z5TUgrOUpNeE03enJlZzRoc1hwc1lmaFZzUDE4MHpGTUJ2T0Zz?=
 =?utf-8?B?VnVsaEcvMHFmU2tQOHBvcXVTNG9jREtCdXRndThvUGh4NlFpUDFVTXprbG5I?=
 =?utf-8?B?UHFGTjNoeE5rY1hXbC9RdUJsVVBib0IrS0w4NE94OWIyMENXelEraFdIVnhP?=
 =?utf-8?B?Q1FmQi82UzBSU2RFVjk1Wmd0S2N0VDdVMmVtTWZFM294bkxhMDlVSmhHcHhN?=
 =?utf-8?B?Um9CY1hBQU54bUM4TEJjNTU0N2dJN2o5aGtQUXJ5SnZYYzdaRzdKcU1lOVFy?=
 =?utf-8?B?RlBtdFVLTCs1M293OHlQS29Wam1FUlRMc25PM1NXUWdyck1yTmtTbU9rK0NW?=
 =?utf-8?B?MGlONXo5WFVFSHI5cXgyTTBGRWF0TzVHdnhvdnN4L2dQa3Y5eS9ZTWI1UDlt?=
 =?utf-8?B?Wk91YmlnOFFFemxqR2huOFp5M1hqTHB0Y3F1RUU1OVVydHNWQm5TU2RhUEJk?=
 =?utf-8?B?M3ZSejZPMkNhYlVhY3hON3doTDF6VEZiU0xmY1lKVHBoNEhKWTgvYUpVdGtr?=
 =?utf-8?B?WjhSZFBCRlRoK2lNNTROU1AwQnJiRDRZbFB4bDZndjUzcldQWUdMR0N3Tmx4?=
 =?utf-8?B?MGkzeFlJTzZjb292WmZSZ2haRzg3RjQ4eHBFQ2k4cDNucGpZTndPWmtYQU9X?=
 =?utf-8?B?THFyU0NmVXlZOTJ2TS83dHlBdkcwQzI1Y1FRenlsUXNuS0dENVJMaUNrclNa?=
 =?utf-8?B?Z2ZYYmxjU0t1Uko5Q3c2WEFxcjNUN0loa2JTalVjRHIrbVRERHMxanN3aGJV?=
 =?utf-8?B?R1pqdEJpTXpaRHVYcjlvVEVxbEsvUWxaTHV1ZGRjdkgrY2tIRWZjMWFCb29N?=
 =?utf-8?B?V3FFMVBXQzJOcGFSZDkxOTEzQXdqelN3MTVLWFdFSGhiZWhrSndkVTBwUlFn?=
 =?utf-8?B?MFE2WCt6eVRPbzVVT2IzaU85cGFWWG5KRVV1cjUyRERvRko2Y2hpMFp0MFVI?=
 =?utf-8?B?Mm1HWkl0dnI4ajBBdzROVlBqUEVERGFZSjcyNTY5Q2lPenZPdTNXVzErY0ZT?=
 =?utf-8?B?dzZlOWFmY05YcHA1cW9ORVdNa2NESjh6eDlCQlIyZEltUTNET29oRUIxcGNV?=
 =?utf-8?B?c2wzOHhRSmZxS2Zxb3g0MVY4UDZ3YXVFM0xvWGpidWRGZUhYVHo4cEJLRExX?=
 =?utf-8?B?a3Y1dmQ2dllvVkM2Q0dVLzhrbTFld3NXU0Nuc3JidnArcUlnZkltU0d4R0VG?=
 =?utf-8?B?SE9Uc0Qxd2hKU0VPVzF5aVBXRys4YWoraTdkMnFEWlIwU05wOEszb09NaXll?=
 =?utf-8?B?NFFtV244emUzMlZUTCtsc1EwbHA5bGlCcFczazNOMktGWWx4MUxFNkJxelUw?=
 =?utf-8?B?S2x1dU9vc1VoTExHTFlmVVdnV2ZtLytkZm9ncjFXTjhBOS9nWG1zU1ZBdUZk?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yI0IfIsGI9B/+OrmurzdtTWAYZDlJtJ3ZQnvRe3dvWQiT9b/zarD6KWB/Qd9s12GdhcDegNUA2LUotWSIoPtwrqcO+gKS/noeDOKKu6Mk0Scw2uazXnWtSy0mjpNJTk3jmIBNfWkKQqVdZN3ipZOID9BvWBASytPHH/ddBWvUNy70EZXUY1QwnzctLVOD2NCxx6XwWt7Ku/KSULHsbVIjRm5ckndPtz5rIODLKOdgQYsaJzPTtRquXie0G4D3A2/Vy/M9tFUYX3jHSwSWTLvc6y5zi/YKrTb/OZ2RQGglKXBaQzlsemFoGIXGmOGcs7nV/5f6wVmhO+9Fa1p+7FFOXPJY1jh0hJUBiuKu0CHpH7ezSnrzhYDQ7SoX4vf+kVJBe6ruOJVGOSH3gg30EeYMi1tmVvAZIiMWKA8hg3a/ffxvq+UfTe7dCiAhtx7cI7ifcIQKoZ0EzDJyCOxxmxyfpKuhTx+IDN4EooqmvVroevCBKmPWxYNdlngP6iwt8VU6Z8V8RF1AnBkUVh5Tn5b5EmzfJXGGY38GNZP4d1iGz1cH66npEZhvhCIULjFqUFNhmM1HnY2VDvwN7iyLppQdXDFYTzfuMo1UsBe9RohX34=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a11179-7c02-40bb-c620-08ddb88f2d3c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 11:05:23.7479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSsCGfUbKpSdT/PHUy8eq6nIoGhDx5dtP6nNtRoHgVI1Nra/tPGDR0hhwvwEaEirbWlmvKvU73V+1AbB71llaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4990
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507010067
X-Proofpoint-GUID: FTyuspWd_slKph_wXNs-uBYH5ugTdLea
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDA2NiBTYWx0ZWRfX2AaovRelNKC/ YJAAx+4q+Rig7WMNohPMhBP8T0bEqCM/QxqiXpyo6tBn7XJs84j1xgT4hfzZtMzRIMgJ8wGXLt7 iS5LRIILmR+VKfCafEIo3wPgBNGzW9K0t+ho+o/2CrtH01obFFkxheFGDfvu8vCKD3+IdSGNhiG
 rEBwsrMhxxrDYc8hp1hVkG1fO7nMP2C8Ujyy+huExCqC/plNIN8DPz43xPbPJujRGXzHit5HHX8 HM/FXeahuitUSR7WtnkwZ4wJW9l+4kTZN1WLDDyhjjaKheT9TtezKX/kFEY+Cl+2387Nmn9fR1+ 7FC8rCB3G+ga4rXSGd4Mji2604AzcQZ/xJPCTkibMYRyi3Eij1H0aC+kakarF7pb464Xq0myoIA
 DcGra8njQ6pBA0H0xg6Kigo/myR17b619U0Fql1+U51KBV2vGvGCjSrY2ZozLGD/3dZKB6Di
X-Authority-Analysis: v=2.4 cv=D6hHKuRj c=1 sm=1 tr=0 ts=6863c0f7 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=6H1I0cCZWb1Sxo2nzCUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: FTyuspWd_slKph_wXNs-uBYH5ugTdLea

On 01/07/2025 11:40, Christoph Hellwig wrote:
> Generalize the xfs_group_type helper in the discard code to return a buftarg
> and move it to xfs_mount.h, and use the result in xfs_dax_notify_dev_failure.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

looks ok, so FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>
