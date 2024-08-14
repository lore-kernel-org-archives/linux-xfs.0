Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413BC1BC065;
	Wed, 14 Aug 2024 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723656354; cv=fail; b=TDktiGn9i8ldqadS4Los+6U9LZEYsQXIG8h73crQh2npBEplNX7Cr6WYUrkCSzOLvNqp3m5yMwMTiivgi8/oCLeySdxFbIr9m7MawBJg9nYfRHRP13RGzpuuE/z934YJFLVHdo8HfpbOqwq1pd9EerfV3zBYjiC5j/zQe+j9bxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723656354; c=relaxed/simple;
	bh=oM/X9Nv9BUavrLwa1PfSzR3mmmIvD5DfebSm6/cntk8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h/qdDIAutiS8mBm/VLsVCVMfOzgPEAXGvJ+Da/8c35GAHSlxlIIMaccpbuV1vKaWz7dT+jCcpN1iS0lqVrnPrUiWUrpGoRELxTw2MHXyFRfB4tsorxzfaWmP1JmKXTcHPUmT49/ebyStImRv8fhiEr5S+yn4f0nhszOeM6/6nr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kz96YZhn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NG+7yzwA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kz96YZhn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NG+7yzwA"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47EBtWdp023329;
	Wed, 14 Aug 2024 17:25:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=7O+QFwXz0UoGUf1+5l06duixE3jpBgNWNCsCwXJtwLI=; b=
	kz96YZhn3vuMDA+eK0ih14yq65xdRvZiloiWVBflyseHen38fstvdtc0/9y5oFvZ
	9E9lM7ng9h2SUo10yAmoSdymSth3H8puIvsfIPrnDA6v9Bx6OONLQFmKTDGg3UkA
	CxZP6SCS9bYaou9XcpmiE/1t0NDf9pL68EOjvIrIbvR1zfV42nYQhNbkVRqc4Alh
	97TRAl7bXnBp7dwbNif9ZKxNEHYOWDbOuQy+uASFJUVUJRADBFFN2Ssc5ByOO8ZY
	yQkNOnZWj9p5ueYxI6GuW5MGwgOh0cziasiKJH0kfd2cNPqitqck3NGkh2pg2v74
	rwygoQUGODVh3Yr9OXCT4w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4104gakk5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Aug 2024 17:25:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47EH42C4000672;
	Wed, 14 Aug 2024 17:25:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxna58r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Aug 2024 17:25:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OERl2woy8G0/3/hOaFusLafAiwWseraIdAQXsqrTH8Buqp/KAMI5PY3/Sv2rbE7dCfTNmKP8RBNVSlaGDKtvoXXqCOD/hTWPHo5fNunD+o9p8gj+HKsxNP3Gd2DznA9CFp6G57QazWjep6IHJebjTbTYGryinu2xGmYFf0+lFSkI2rk9iwSTgmgfgM7iU5qzK53I2R8GpxxzyENtBEHXzSEBHMxM7c/uTxjPaEQZaFd14RliP1FwqzxtDwIovPWgt2CKp3DgFI0GmBmE130gAwcnKKa5+uSxCAdjtuUZfF4xKc4QOSFft7M8I+vYZqxtjCc8btb1qKYS/xIBDd4prg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7O+QFwXz0UoGUf1+5l06duixE3jpBgNWNCsCwXJtwLI=;
 b=YgLT+RYgUtXM7wrhgRFj+NNVSbxzTSwQWnMkbOh8ACY4/MXimXr8yew9wDBuU0DgnzWztgEG1MmN7b4tOWJWrdUpbhCWTehB1Jo8lpIJ3WheAXn8RsDTOzOBd32hk2OmPIM8fFGCoM9SPtKrJT1KDLVmNsxrCMoHH5bibE72WoJYGFmyAk1/iLSNGtTNnvWdFeJvTrONCKNh7snWFBdeB3WOaTYxcaGcUFrCudrjXd1/bNc88y/98o/0E5VlO/CfZEXOh7pMWoB/36FDWgvL0MPZdiYWE0QAL7ZqMkhgKkxROTpXIote3xeMJJpeVEDzap+etxpKBZdO5yki9NxN3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7O+QFwXz0UoGUf1+5l06duixE3jpBgNWNCsCwXJtwLI=;
 b=NG+7yzwAdAtqhZxDkZTlxvapvY3BhPnR4FuR5MhKWBRxE/0Z73bdIKR86K/YCt8LmwlQLviiRh82XhygsgMwj3/QWvFrUZBQUHRxqQxXxl1KvupK11MAAdhjRRHaSBNyJCdXmLTKtgNTFBAHJKNXxuhW7TphRBrjX8ofqBUrNp0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4213.namprd10.prod.outlook.com (2603:10b6:610:7f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.16; Wed, 14 Aug
 2024 17:25:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7875.015; Wed, 14 Aug 2024
 17:25:42 +0000
Message-ID: <441fb8d7-422d-440c-9e12-ab58a0401cad@oracle.com>
Date: Wed, 14 Aug 2024 18:25:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] raid0 array mkfs.xfs hang
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch <kbusch@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        axboe@kernel.dk
References: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com>
 <4d31268f-310b-4220-88a2-e191c3932a82@oracle.com>
 <ea82050f-f5a4-457d-8603-2f279237c8be@oracle.com>
 <ZrzDP5c7bRyh7UnE@kbusch-mbp> <yq1wmkjtb1t.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yq1wmkjtb1t.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0429.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4213:EE_
X-MS-Office365-Filtering-Correlation-Id: 87c559d2-0b89-492e-afa3-08dcbc861f91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGxxdlBxcjZHRmY5K0pmUEtYNjhFYVZxOTBQd2syYVAzeDdwNzNNUU9qZ3Nu?=
 =?utf-8?B?d1ZYTGt1amN5bCsrcVF6MllKK3dYUi8vbEd3L3lFZDluYVJ0a2VKSnNicHUy?=
 =?utf-8?B?M1YrQUV1TVloTEMrTXlmQTUrcDZWaGcyeEFvdERVTjRKL09idVhCY0llOW1p?=
 =?utf-8?B?b3RoVk5RVVdHd254cHY3TElObmtybENIVWxFWmVyS2Q1ZUI2a2NnaTFXcTBD?=
 =?utf-8?B?NzF1ditUSnpZK1pxNGpLaEhzcW5QM3A4UHluNmJKU2xyeGlabG1yVk9WTTlw?=
 =?utf-8?B?am9DMGx5Q1B0bDUzU2RwUTl1QStrd2xkdzVJUk5JeDg1bDh0Q2ZZamltUzFu?=
 =?utf-8?B?UUhJSmgrS2ZMNTdPYzRYb0VtMWY4QkI5cWdPM0w2Y3M0SWw5enN3b1ViUDdE?=
 =?utf-8?B?Ui9vUTlVVTJNUTZucnQrLzEweTdEZ3MrVGp4TkxQT2Fxa2Z3b25XU2lSdDEz?=
 =?utf-8?B?dFkrMUdsSW1vUXl2TWU3Qko3ZU1NREhCQldnckNYQU03Z3Z5UXlQa1M4VHBP?=
 =?utf-8?B?OWVQNFphUzhXcCtGak9VZjBPUVAxZ2h4bXlwb0tPMGtDR0wvQWNqUmJDcXNJ?=
 =?utf-8?B?d3FCZXFmeUM2dkx2STJHRUo2ZVdsTVpNV1VQT1BpbVd1TjBwTnVHUDZ5aWJr?=
 =?utf-8?B?Um9BUlBLMVBoYWdzdXp4YWxzenQ3NWxhdlg2U1RJL1pBL0FMZ09sQUlTZmx5?=
 =?utf-8?B?Nk11RE9JWDUxcStYNWFWMEtsWFp5UUJkbGc5OTlBblFtcDlZVC95OS9lZ3ZQ?=
 =?utf-8?B?cGY2M1VPc1pqT0E1YTJHU1BLaG9JL245MCszZFdOb0ZscHlMc2k4Y2VobDVT?=
 =?utf-8?B?NlpzWmtqanVKRmRIazEvSHhvTXZzOUptQlVSakh3RUVEdlI2Z0FGMHhBZUxy?=
 =?utf-8?B?N21FL1hDcnJ5MmlRUnJtTkhOQzQ5bEovWWZaRTd1ZGZ3My8rTFpGbHRTQzZx?=
 =?utf-8?B?SEQvNTFnQmVWb0pIOTZNKy9vRmdQZUVNeUg3Z0NhaTlLM1hyeDJ3WXBuejdQ?=
 =?utf-8?B?cGtQMk9KNlNDMjQyMGtHa3FhT1FwR1l1eXRDb2RhbXVkYXk0bC9ydmowK0N5?=
 =?utf-8?B?WXRWYk9tVEg2N0tzU3g0UWZWd2poK3ZHNTRMVWJubkJwMjM4VWtuOW9DYy9l?=
 =?utf-8?B?TUgzMGk2elY0Y05rOXZ4ZE5seW8zdW5WeWpJajFsejVlMmdsRHZjM2hBU0d6?=
 =?utf-8?B?K2daMjJrYWZhQm13NEVYc3BNWHI0ajBkUjB4cGZ3a2lid1FLdHF4a0lHZzR0?=
 =?utf-8?B?RWo1MHJUZDBWRjEvS2NzY25WZ1hXWUZPM1lieFdwc1k2QVhlM0JRcE9GL1l6?=
 =?utf-8?B?dG1LK3JkSm0xeDU2bUFJaUdmNGlyY3NGS0pqdW9oeWJaNjdwcC96azE1SWpx?=
 =?utf-8?B?OUNnanFGZytpME9jK3dpdkc3Tk84UUdyYjhOMXRPSTdEQ1Q2dENJZ0c5cFEx?=
 =?utf-8?B?a1RZa3hTNFpLWnhmV3JFWG1BcGplVTN4MXFpaWNkS0hEMWZ3VVlDVUtnZUJU?=
 =?utf-8?B?VEdoeHJLWjZ2TTRPUnRMSW1iREczQWtlWWlWUkJMNzRKMm5iSEljOEt5ZVp6?=
 =?utf-8?B?Y0pOR3JJd0lqOG5vRWo4NVRzcTFqTkFqbWYrNjVUaEZuMDhBaDdiMW9NbG5q?=
 =?utf-8?B?SlViMzBWaFZuRW10SUxPQVFwb2tLUTludjlobUsvN2hPNy9DSkU1RTgrTEJu?=
 =?utf-8?B?YWY5SnU1TVV4eEoyRXp4QVhjR3VVcHZDanpsdW9xTFg1ZnhKK1FVS1JQaXVh?=
 =?utf-8?B?VWxvUWRHRmZSd21SWnlTKzhjd2VldUpDeTNEWUNNTlYzN0Z4RjRIZW4vTllI?=
 =?utf-8?B?dnlySDlvWlVldUxTYmtndz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGpwSzR4VU5QbmxnMy84d2VqL0VOZWQrR1lHOWxiYkZSeXA4bFViaHdDYklt?=
 =?utf-8?B?ZUcwRTllV1dBL0JIeVp5TmFzeSsxUTh5ZmhQNHZnbWlOL0tlYkF4L3ZPbTdM?=
 =?utf-8?B?ZDdHNGtKdlEzR3ZKaHByd083WVh3emVJa2RaVmxRS09NWmY4WUphYmJWMTVE?=
 =?utf-8?B?cHhpb3E5U2dYV3haZ1NFRjVoQ0hYU08xNUMrTnBubllrTXg3SnBjbUZUZzVH?=
 =?utf-8?B?ekowMDltZnl4Vlp3OHdGTWxyTE9pTjhYSWNMWmc0ZGtGSTg3ZlQ1bis4VUtv?=
 =?utf-8?B?K1ROaE9jbGxJUThSRmcwejZiWXoydmE2ZE85TnVNOUp2MmhMaFZGU1RKL0Z0?=
 =?utf-8?B?MS81cCtNdytzVlZBR1liNFNyNGpMUmFRT3RrT2JUWWtIMXZRNEEwKzNwanhT?=
 =?utf-8?B?VTBMLzcvZ1ZlYnNrd3AxdWxFNDFHL0k0Z21Cd1BQTHQ1NnZtKytpMG1GNFVJ?=
 =?utf-8?B?MG15aHpBTEhPdmM1SjAzNC9aRXdzSnNCTjEzdG1QUzVBc2cvMnNLRzF4UXRP?=
 =?utf-8?B?WTZVRUtHeUZYRFA4TUpyWFVHeHp2WUFuVHpNaWxXbjRFT21sVG93MjYrYTNp?=
 =?utf-8?B?SU5iNXg2bXNnNUo3K1VQN1B4dFhZb2dOSVp0MmU3RDdDOFRlbTE3eldZWTNz?=
 =?utf-8?B?akxiT2syWkhFbUszTVJmVzRQSzA0cy9MNUVHU1pnM2w5RUZtSzBnelpSNDQ1?=
 =?utf-8?B?cURwRm5LNW9ta1BhWk80RWUvNGxLQjE4ejlqak95aW1MdHFDaDUwTDlIOXV3?=
 =?utf-8?B?dTg3N3EwTmxIbDNYN3F0L2hDaTVHTFFQWVZFcEs1dmRyUUpRYjAwVUhtd2ZX?=
 =?utf-8?B?dzlOQkQvQUx4ZnNROFh2S3dxNUxldExtSk1WNjNPVkUyS2JhLzM0ZWhMNnpI?=
 =?utf-8?B?ekNGbHBMaHU1OU9CaTBJVjVtdVVQZzNQZHFVOXVmcGMzODZScEQ3WVdLK1FV?=
 =?utf-8?B?R0kyN05hYWJhUllHblVMR3FBRlhyalpNOFFCa09UcWRBM3JoR1l3aGptZE5N?=
 =?utf-8?B?LytnR1YrTm8ycmpEOTEwOVVjVFZoVzNNQ2x5VFJyeitVYVdSbytTcWZXTEVI?=
 =?utf-8?B?TlhZRDRyL1UvS3lnQVRsVG9FMGNSSGRqVjNRWHIxNkF2QStKeENjWDVYWDN0?=
 =?utf-8?B?RkZkeVphb1RJM0N2NWdTUkRJc29vanhobHppcStLaG5uVzJMZ2F1SzEwUGhL?=
 =?utf-8?B?aXB2NnB3SkpYV3dISE40bVd0czFvOXRtVjJsc3lmVXJKYTZLM2Q3YURyM0RH?=
 =?utf-8?B?bks4WDQySHQzMEw2MXh4ajd4LzVTTjJUQWFTamVjb280ZnRUVzF5dEZpMUtZ?=
 =?utf-8?B?c3IrbWUzL0NPWnpCSm9nQkRhVm1EM0tNRll1Yk1wSFQ0STZmN2MzRmY2Uk5m?=
 =?utf-8?B?R1p2bTRGaTVCTDFQU0FsNks3L3hGZmR2SFIyWUlUM1h4b3hsY2g3ZEVrckdu?=
 =?utf-8?B?WW9LZ0dpcElKZTJROEdDUDVqY1pmNXp3TWlCQ3Z6WGNFam1XL3BORkU2TTJ0?=
 =?utf-8?B?c2VrV0pHN00zT05id2FRa2FlbmZ3alRrWFk4YWpjaDNabnFnc3lQWEZjWmhQ?=
 =?utf-8?B?eXk4MDFLS2NwSksxMnM2WjVxMGtnQ0k0TExmY0NmUDFJY1BWZUlxTVhhblEy?=
 =?utf-8?B?em9nWmdHaHloREw1R2tFQkl5Z0lTa3lOY1l2V0s5OU4xV0ZtUFoxTlArblor?=
 =?utf-8?B?bEdDbTJ0bW9YWmQyS3huR1hxNGFPaXQ1b0RoeU9FYnBmQzNiNXdjSkJXMC90?=
 =?utf-8?B?c3l0VndtdEVHSFZWVHEwcnRpSlRmeDcvZUNUL1VtTk1kWGFOcmJXMm4vMVNX?=
 =?utf-8?B?SjlpdGdGdlU3TXJnR3dWN1lYT3c2dmlRU1pyVEplK2haMVJ3NGIwbVVBN000?=
 =?utf-8?B?bWpBZ1lsRTFkdFRzNVBDS0RuY2QrV0tlZmhHRDM2UlJIQUdLcXRlQ25JdWgr?=
 =?utf-8?B?UHpkVk9sNW9Ga3pGbExwYU9tS3BzNlZ0MVJuZW9TQnlNTVcyVU5hcStyOXRo?=
 =?utf-8?B?YUs4SkFZTjRzTzRtVk8vRzF0anROM3dKeUh0M3hiR0ROSWNDRHF5L1dhRzJQ?=
 =?utf-8?B?Z285WkhYcGVKTmM5Y2lyejJQa01iUExVRG5IeEdwWFpPSElhR29hbTZ2bmVx?=
 =?utf-8?Q?2JK9OVX5jCY1k/w5z+d+baHLZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SX16RoD5QdUifOSEj1ISPtRr9Dk2ytDPLUqMfcqxlUrffBdQqtS+onaiDGBtMbOH/8VFfBwCVXG7ztUUKZyUpa0cjmGR7sZZFFoCOsIix0ukb7o9mkFiKXn8J6ymLS3sV8tTzMIaFn6dvfFWtTda5sLkEIG74wLO5UuzpEFMyF/C33sGQlHxykhjSJ38RrFUX+AehUNynSqLUCKzIe7pNMxYhXnq3jISG07iO0jrUviTJWbAXkQB7nEAr1KhOSNSyBQj9SMBQvwbTeeOdf4OaChZDCp7OIPacsfP38tXnn41g9S9FxGbHKcLEuNzVR7Vgm91dT6Zexdw+CAimbtzZg6CWIulczkm8o2+FuIRXQENi256HA1DOUleNsc+XM5LjFa/bX37Tkv4E8b5S9Gc0b9511zNjlnJxO2YTF33JamIEDeu5VmlN+L9Wxi5WjA5L4uKoPBgLGUKBh1K/c9jQTbB22LNmTAM21GzEed8bVnKbLMPBPl1UsnaVAxJGs9v1Vux3ow20iyezA+UterbB4mAeVv3Ks9i7IsOm3sMX9V8wwKy0eXjsZ3J2O4mBUT3HkDDgtRsYq7NzPpYS80TV+AEbrb+iB0OuZgasTEY78M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c559d2-0b89-492e-afa3-08dcbc861f91
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 17:25:42.3087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Unu2+7bmYyEqA1E02ZCPy2TYbJqLNiM+cCJPwmGsI8spNUQ2rf3q8WL9hPv/i5ovyhkZqscemDT41BkXMo/xHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-14_13,2024-08-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=920 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408140119
X-Proofpoint-GUID: a27-sKbTtwvygzMz5tgXwTH_0xBmjX6L
X-Proofpoint-ORIG-GUID: a27-sKbTtwvygzMz5tgXwTH_0xBmjX6L

On 14/08/2024 15:52, Martin K. Petersen wrote:
> 
> Keith,
> 
>> Your change looks fine, though it sounds odd that md raid is changing
>> queue_limit values outside the limits_lock. The stacking limits should
>> have set the md device to 0 if one of the member drives doesn't
>> support write_zeroes, right?
> 

And even if we had used the limits lock to synchronize the update, that 
only synchronizes writers but not readers (of the limits).

> SCSI can't reliably detect ahead of time whether a device supports WRITE
> SAME. So we'll issue a WRITE SAME command and if that fails we'll set
> the queue limit to 0. So it is "normal" that the limit changes at
> runtime.
> 
> I'm debugging a couple of other regressions from the queue limits
> shuffle so I haven't looked into this one yet. But I assume that's
> what's happening.
> 

