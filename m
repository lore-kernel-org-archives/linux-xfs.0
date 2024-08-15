Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD9753365;
	Thu, 15 Aug 2024 06:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723702810; cv=fail; b=FFFD/4rkOjqwu1iE6nL1EzWPY9RujBPn5nQSlcdqTIDPQMEaKlPeoSVasvynr442oCD4azuea6Y50T/G5MSYgLVtlK+Q61SVNDSD0qGxCSnXuikaNKP/nC42BpoAnDgYbFt+LRmgqVKh/i61vsJVKj6vZ0elfiRd69m3a5nHkwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723702810; c=relaxed/simple;
	bh=Q2vPBW+zZ7rAOG9kI7n05n7LUfACaKss6cw4CJno3T0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WKaj2D7DevXzM9qr5iJaJcsuAzQBPnK1FSd6qMKvVkhzUWOjR7jB5ruv+K2t8wuPXNWfDvj8hk+wcyRCFNsk7aCNOqs3SqcD2atpSqfNuHCgoSEWY98X3ghrHYshzyjfC5Ss5SFLKMjWUtRJheVCL+xrOkE/CQr7BCvrj3If9Fs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XYNjun1r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WVFDeU9u; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XYNjun1r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WVFDeU9u"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47EIK2k2006105;
	Thu, 15 Aug 2024 06:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=xE6rdU8KfIJ86tnkg9xyYyTVHIGro6FwD4+nFbvMCp0=; b=
	XYNjun1rNA2FfntRuR8xVfj34SGWDQV3sH14563A/hZrUy+uia+Pa0AJEtwTiMec
	okyMPL/xCrJxleeJvq3bWwzgCVxXMXjHfXBtF1Bh4C3TzbBcoSaq7ZeQV3wfWMY1
	Ax9L+EYabUoe+2vXqTWtnJd7x0l8vBT7XQ9FzxDw1N7TfZ6HZHV61N5QOQ/LJDu0
	OkBZ0fS93aCh3/uFwbex218M0yPxbAlWWW3nqobuAqzZiuuIYFFG50I7bSOdrYeh
	4fcUTEwukfwF7LcfQ5lXo1e0R1+A10P+1b/qB7NTX1EHxl32EKnjxBpvo6dS8Fed
	xHaKjV5PhJo8jdTkBYbCyg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy4bhysk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Aug 2024 06:20:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47F60WAh021084;
	Thu, 15 Aug 2024 06:19:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnhajwa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Aug 2024 06:19:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tZ3/mf/x6y9o5HmAW5vxLnxMgj6S3mktjoKxhMuiw9CFLyEYWLOy7zhwMohds7d3Fm30w2fJHwrcCLLYQ5CPg80RrnzOJ6EtvFSjWHTEKa5Z24DESqaeNTjgcJHGEmluZyo8Cbo9bQ/Mmzgf05SnLS25fc3rvetavFyseahsVN1DIg1zF0Sg1izo2Mn1ChGWKrm3s0sdtgg6MVb3t1aUmqKHgJbVNEjV89hbfrA/cEVbvJPNc8oMstzU2oB4sTaO0WoF0cwk/uMVFGBoYRmtYhxnc0rBeAwFMAzWx9L3pFT1HnwisYHVkkcblm3wpSDiVPSLaditFvHxRHYazv2kJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xE6rdU8KfIJ86tnkg9xyYyTVHIGro6FwD4+nFbvMCp0=;
 b=XSR4KmSUzi7pWKYbruR9XvZPoAPu/5BaFiRaEKNGXsB1NdRZwoOJZTjqx/ijr5u2SkzvoslU8ocBDR7gU3mWQ3Vig7A5cdquiFhKYzSPj5M1JuLYF04OXLWJ/PHOjDPFXoFlRtwf14+t+dkW3eq58OciIxyfiysd0lc709fAUMUG4RJWie/GXcVfPlu6b5Y77EL6D4ZXw2DNdSAhzc4bI9tor20FzPm3WBcJcllvK7842zbtEUDYPliEaiI/1nF7epOrz3FWRZL3Fsp9MK30hLTW9YnnNkYwHKsj0xBWXuFsxhQ6VusHTsDPUFFfZLadiJv5f4pWbmbGu3Ktu7SSLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xE6rdU8KfIJ86tnkg9xyYyTVHIGro6FwD4+nFbvMCp0=;
 b=WVFDeU9uCA0zuH8tLbc7qmg7HOdyQEZjHLRVZNM1pr+C0NX+Sq5LeMF08dx6IHC9HphG+Jnj2UzlxoWw1BqAAKD4mCOdPGXHDdp6s0LxGUQTqxxJymNbm5EyMbEXnn9JGtBZWM2ltOn1L9UrXjoawAK/cXQgh9Q2m0U8igcQKvQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Thu, 15 Aug
 2024 06:19:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7875.015; Thu, 15 Aug 2024
 06:19:54 +0000
Message-ID: <b7f5db41-5995-4221-b2c4-4faa48fd1fd8@oracle.com>
Date: Thu, 15 Aug 2024 07:19:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] raid0 array mkfs.xfs hang
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        axboe@kernel.dk, martin.petersen@oracle.com
References: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com>
 <4d31268f-310b-4220-88a2-e191c3932a82@oracle.com>
 <ea82050f-f5a4-457d-8603-2f279237c8be@oracle.com>
 <20240815055221.GA13120@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240815055221.GA13120@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0405.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4752:EE_
X-MS-Office365-Filtering-Correlation-Id: 74f5af4e-9984-4ded-9303-08dcbcf246df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2p5RVB2TWMrbXNZejZpNk5BR0ZxQzZUakNzcUl5Y3I1N1llMU9mRmV3ZEh1?=
 =?utf-8?B?T2NMYXV1QWVQaHRjcFVjNUpsWkFadmpHQ1dWQVYyOUtKUTVpTnVsb2ViRWR6?=
 =?utf-8?B?NFVaYk85UVA4enh6UktjZWtxbW9SclNpYjdWeE1ENnRkNktKNWlHeFIzZzVh?=
 =?utf-8?B?UVdENDB3YkF6VTA3azc5ZjMxSFo3RDNlZ0pNYjFIaE1kWU5NUHBmYW52V0dx?=
 =?utf-8?B?Y0dDaXpHNGRXZldKdzZxTnViSzBzNHFkODlaYnlHMHlZcE9QWHNNK2FLdms3?=
 =?utf-8?B?LzNLaTl3ZVk2eTRrRzQ4YUlBQSthUUxtQ25QTXdWQ0piWkdzMkpqZ1Z0SWpF?=
 =?utf-8?B?SzFTVkVwU040aWZqV3hkcGtPRHllRnhTZDdIcE1sMHBhVVhlckgxMnZhTVor?=
 =?utf-8?B?Zk9KMGtiSzE3NmlJNndKaGEvMEFnNHU3MXVoN2JqUXFGc3BZUnZhRzdmdkpo?=
 =?utf-8?B?WDh5S2dWMFNzRVVvRmJrS3hTZldoR041b01QQmhjT3JCK0p5OU81WFF4Q2dz?=
 =?utf-8?B?bzZubXZybWIvMkNJVWVWYmRsVGwraVlQa3g0RGJ5UlpVcWkwRFU0T3FKQkZD?=
 =?utf-8?B?RWRRQ2RmQnJSSWJuZnl6ZWhGK05pNFV1YUFJc0dobEkvKytsQm9nNVYvM3k5?=
 =?utf-8?B?dkdWSVZDR2VoUUQrR21SMXI2aUl4VUdPS2NrSlpRamo3ZElNRDlQTmtWblVO?=
 =?utf-8?B?aWhVREVnMG81OG1CNzFaTHhBMm9VS1JzZXlYcWdlcHBvQTNhSnF0K3dDVUdU?=
 =?utf-8?B?Z1NUQUZVRzdIcUZvczd2R0pzLzErYldsSmdqVFRYMXljVGpERHhtcXUwa2Fa?=
 =?utf-8?B?YVpOWHpZdnF0dnVDdGZ2RTd2T3RIRFR6WUxVS0pac1RPeE4vSXhWc0pPRGtH?=
 =?utf-8?B?WFBOVUh4T212SXpjSVlvM2c4ZnlUMnRWM1AyV1B1QzNsU1A3cTFvSXc0aHdh?=
 =?utf-8?B?SlZEYyt6K01iWjNOUTduR04rbTg5cm94cWsva3ExT296akVydzVEZWZsL2pm?=
 =?utf-8?B?UjQvdnEyZEZweGpRUnNiRmM2L1hETVcrMXc5L0VlZzdpeVVLbHM0OUluYlpH?=
 =?utf-8?B?UGE5SkZnZHV6ZUoweHp2QlRnczRzSjZDN1FpN1BWdVFmTk1zMDJGYm5OYXJ1?=
 =?utf-8?B?MWlnWnNRbENpL2gxTFdCazYrNlJRQ1RoVk5pTE9yZW9rTVVvU0RuOW1lcjB1?=
 =?utf-8?B?eWlGRWlWMmNOd3A2RnVGUHpxYU5zRDZVOTBhancxUlVwSXpKbVlBaC9ZaGxj?=
 =?utf-8?B?Kzh4ZHE5bE5WbC8rRXAwelRzTkNwWkNrOXdJNEFpdzluRnhXdWJhVmJHajEz?=
 =?utf-8?B?RitRSkRWaE03Um5MY0FqQWdlNDNPenJqOTd0RmNObzE3czIxRFlLR0NtdWc0?=
 =?utf-8?B?VVQ5Rnk2N1c5YjFRUGZzZXlWVjhJQzBVM2FuS3haNVR1S1hFWFZrY05PcEFJ?=
 =?utf-8?B?SnRYVlcyOUpWTFhhM2dDbkRXcEZubGMzWUdqY3hOZ3h1SURJVnRSWWRmc0xH?=
 =?utf-8?B?Q0poT1J2Y2FUNVFzVEg3aGZ3SUptZkljT2NObXZ6dWo4a2lOUEZ2T1lVeFE3?=
 =?utf-8?B?SEpLRGZlcGxVbFhrUGZTK09EWmRJVjFGRWNTVllVNFIxbTF1ZFdDUjFEUXlL?=
 =?utf-8?B?K1dnRTdZendaVS9MZWtGY1BqN3FlMTdBSW9iMnhBbVQ3c3grVmoyWDhLdkRX?=
 =?utf-8?B?Wjk4UjB1S05LRzNWWjI5VlZLYUZpVGRna05hM0JxeW5EODVZMGI4SEU5eTkw?=
 =?utf-8?B?Z3F0d3VRWDBNaThtVzVkRDJmay9GR1VGcmU1cVJiRXBKeSt4RTNob3NjL0hi?=
 =?utf-8?B?VlZJZ1JsdVdVU1JGNXgxdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEVVRGRvMEJBZjhGaGw3STZaUXZSNkxneHIvYmllOTE1MFhaNHRPZXhYcVBN?=
 =?utf-8?B?N3FGSHpXZk5HUU5BR2hxU3MzS1ovU045d2hwZkk4cW0ramIybFIrQTRjMmR4?=
 =?utf-8?B?MUc2VTliaE9oNXhlQ2ZmNEJoSG96c1ExNnZSNFk2Y3puRnJ1TVNlbkNLbDNX?=
 =?utf-8?B?RVhtNzN4YmlNR0VVakJwakl1UGVocTBIUVVhbi82cFdqSkMxV0dTcWlXenRJ?=
 =?utf-8?B?d0dhdHk2TFljQlBZbVlDOWVvUlJsZHpDbEFRR3g4QWcvdmhTV0p5djBZMVZr?=
 =?utf-8?B?dXVnWkFTVWdEdWNlNGs3bkJ0TVA1Q3JWMGp6RUdiczFicThyNmN6ckkyWjgw?=
 =?utf-8?B?RVREL2FtRjMzTGNhZEorbVVITEVNcTVzUjREUVNSbCtNNEdBeFA3cysvYXYz?=
 =?utf-8?B?V1VNVi9oZ3ZRTXluNTFwU2xwOC9qdDAvUVJRcFV0WHpDWlZJaFE3d1BiTUhi?=
 =?utf-8?B?SEp5NWI5QUpaZkxFZmR2Q20xYUZ4NTlUdnpxaUJoS0tsNWcwTjcyVDJuanB0?=
 =?utf-8?B?R3pnZ1ZCdTVVNTg3RXJ2aTlmVy9ydjZ4UnRGdlhhZnpLWUdjWm0yTW1odm82?=
 =?utf-8?B?a0F5dXpRWVNPYXROQ2RIUGdEdVhTUVl6TWJmTWp2SjRYakRabkRzRzhqMXUr?=
 =?utf-8?B?M0VNK1d6SUlaeUxmUEJJKzZUOXVhemRvUkpEa1FFaDN5cTVsVmhhRHZReHpx?=
 =?utf-8?B?TGhJZWsybmJaLzNuZ3pjUHVDV2t0ZjFVMGttOVAybVZUdjVIWEF5OWNRNEVI?=
 =?utf-8?B?NVhJOXBOOVRrN0Exb04xcVQ4dmZ1L0Rwd1ZoWXdaS1JWdkFiNEJtZndrSzF5?=
 =?utf-8?B?Y3ZLUTl0c3R6eUtHQlFVeEFocTNwV1V4QVRIRWdwVTNoRU5MaWZsZmwvY0Vs?=
 =?utf-8?B?YS91cXBWcWlhZEZBRFgvWVh6WjV6bS8xUTdUdFlIaXFqRnBib2RiZzN4aC8x?=
 =?utf-8?B?RTU3R2o2SjBMQVBOWVNIdnJVK25wTFlYM20wVkJQaE42akswbCtNV01KL0c0?=
 =?utf-8?B?VjZnMmtkdnRGRkp4VjFqdXdzNGd3bEdKR3pYRVNzZi95ZGRKbHNtVS92TDRr?=
 =?utf-8?B?bUxEbWk0N0YwbEN0azdyNlIzeGdtcm1ydDh5Yk5hZzQ4YjhwYUlkZ0I0U0dR?=
 =?utf-8?B?S1FzcWtrclV6aG5sclA2MkVncXNVLy9VM0RERmtZV2U1UlNWcW95b1FkbzVS?=
 =?utf-8?B?MDU4dDZDTklSVjQvK0tlN2hhSDNNcVE5R2VrR1J0Qkp3d1luM3hxTDFWdTBK?=
 =?utf-8?B?bDNrZW8zWmhQVGIvT2lsQmFOV1ZRWnc4L21iSGxRT0Nuc2t2ZWxkelRGejRk?=
 =?utf-8?B?bFU1Wm9XdlM5V3ZzZjUxbFYzZ1VHaTZvTkRoSHkxTzlTMHVwdlFheVFQNVl5?=
 =?utf-8?B?dVpYU0o5d2F0TFpCck1jQnJWZFh4ZzV5Ty91eHF6YkNrL1c4QVBpNDFlNFB3?=
 =?utf-8?B?Vm5zZ1UvWGc2NzNKU0hVMDdhZ1B3My9VNjFaU1FkRjdsL1VFeEVJcjRoaVBZ?=
 =?utf-8?B?VHFFUS9UNEIwc2JoK3R3QlYybk4vYUJVRWZEMzUxM3ZIcXVzU3BGclFJRmtQ?=
 =?utf-8?B?LzVlWk9XN2g4Um9hYlRmL281MGNBajVLdnlseHdVZ1JaY0tkUkJqWGkvOUlj?=
 =?utf-8?B?L0FYZ2Z1SVZMV3FXd01yaXM5ZVNQeEloeWlpYzJNRFJWeWF3b1ROYVNqbjR0?=
 =?utf-8?B?bVE1TGpDVTlCVnBlbk0weUxBeVpMdExBdlg2aGpxOUNiY0h0MkU5blUwUjBr?=
 =?utf-8?B?TEZsc1UzdEtkY3JsNUVtSEt3Ym9ZM0RaLzZqUlZTamVxcGEybU1GdVZzbmRC?=
 =?utf-8?B?cHVkampGb1JxMUJpYTI4MVZEanBWV0g3TDZyTjB5Q0llV08xTlVGRGd1SmZm?=
 =?utf-8?B?bk1GdVUzUGZ2d1NuRXlJYjQ4VHBYb1BoeWtLTlZJQ21nVlgrWmhrTGV1anp0?=
 =?utf-8?B?TlRFTGJORUtXV012WWs0aDdHdHV4alNEK2ZHQ3hHNzc4YlFLVEtWVjEvYlFj?=
 =?utf-8?B?TGFBVTRaSC8vYTZ4Q2JBS1Q5eXd6dDhHWDRWWkZpTHlyMUI4OTJkT2l4Um9P?=
 =?utf-8?B?VUw5OXFQZ0d3RzJIbDlvSGcvNU1nM1p0YWdMTEFrTGM4bFhVYk5NekhaeEIz?=
 =?utf-8?Q?OQWB+Ew/8j/Jc95eJ3lg1kax0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0lOee7PHNRMCeFHdpL1hm6S8UR6I3HIRrePsy2tkafd8ZgCs5eUfhHXsA7+6EIbzxmKROK+46QdDqQXT9do5MqzmY7HzTrlCNftYnBfFSKrXF5tle+5n6sYslx4kw7sTeAL7xPIhg7z4ipvZK5qzfSNHjZvUPYa/rui/541XhCODsgB1OjvAel9C0Y2gKuLMQRYynzmkPRs5x3pryv2qthdQqpRbrIGceegGLZaRW8+UXJDc6AnfvYEwv4+VU32aKHuOYv03THkkDNm4Oxs4DYfS5d8BKr2sIjx4mP49I0L8GmaNJrxXVbfOmc9+b85qb8cO382UNboBhGrBqBmaDvXd3SzqtuPeYqFT7db9rpKFvvT3ViZxxhUqENDKsGHtSqQAZB7lWJXG1OGw6N9iFmeAJxLpFjJoeyDYVD6+6jf7cJoN4XLaghF6G5AzgKsfUlzYvPjkDpTT5po/4qYu8Hg1hJkGnmuKRAxbUlQYwRbrJttrjSyXTGPVa7zxO/rnPYwua316RNkX5DfEj9ikJ+7WxxQMp0ZrGlmbgfFOYWee6Dw6ypbBa8HC3yertDJC+hSYk++iZARj3tRVCRVMxeddKL8pc87VscdRgQgPzpc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f5af4e-9984-4ded-9303-08dcbcf246df
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 06:19:53.9154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6UA6d3e3l5VEYv7w6D5hYITU0TMN1RosonhCK94Qf3zg6IZWEiRY9nJJp9GFWqhwDeVXZRN+OJ08eG4EB5ataQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4752
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-14_22,2024-08-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=855
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408150044
X-Proofpoint-GUID: saj23rY3ace96MQL3xJyQa3zUxS8a0TF
X-Proofpoint-ORIG-GUID: saj23rY3ace96MQL3xJyQa3zUxS8a0TF

On 15/08/2024 06:52, Christoph Hellwig wrote:
> On Wed, Aug 14, 2024 at 03:00:06PM +0100, John Garry wrote:
>> -       __blkdev_issue_write_zeroes(bdev, sector, nr_sects, gfp, &bio,
>> flags);
>> +       __blkdev_issue_write_zeroes(bdev, sector, nr_sects, gfp, &bio,
>> flags, limit);
> 
> Please fix the overly long line while touching this.
> 
>>   {
>> +
>> +       sector_t limit = bio_write_zeroes_limit(bdev);
>>          if (bdev_read_only(bdev))
>>                  return -EPERM;
> 
> Can you add a comment explaining why the limit is read once for future
> readers? 
> 

Yes, I was going to do that.

 > Also please keep an empty line after the variable declaration
 > instead of before it.

ok

BTW, on a slightly related topic, why is bdev_write_zeroes_sectors() 
seemingly the only bdev helper which checks bdev_get_queue() return value:

static inline unsigned int bdev_write_zeroes_sectors(struct block_device 
*bdev)
{
	struct request_queue *q = bdev_get_queue(bdev);

	if (q)
		return q->limits.max_write_zeroes_sectors;

	return 0;
}

According to the comment in bdev_get_queue(), it never is never NULL.
