Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AF52DF3DF
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 11:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750160715; cv=fail; b=VObLgD8bwHSftwYhzbOo1cg5kNHO+MLYH4cRCDru8BVF5+mU/6xi/gLDb9g+IYOb7SaUBiyvdqHKjx6t6+KN3VN2ZCRtoojIdgGviM/PmyWKRFDhuvy1SvUY/eQrBd6s9zTBIqcq8BrtZBhd2z1a3TNSKjoGUGKCdo9A/qdfVzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750160715; c=relaxed/simple;
	bh=T2USkfZStj3lu5OAJ7iizX8BnHRUC53DtLB1+UnM58I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hQTgfIz+RHmnheyDCcfAvHhowISAEr0S0pIZcMSzdIRxVzLA1O907QH+iqetxocyx7Wu/S9cfELM4GJW3r9cG8uZWQ0NejbV+zYlIKdqGL/dVfGjJH51ZjstASVZ6oDt+j7DrtEi5/xlf++llRotWp3m9ZM6T7nXfO57YVxJbsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WQk51se3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JDBRtpTL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WQk51se3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JDBRtpTL"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H8tgDT027189;
	Tue, 17 Jun 2025 11:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=08+uMKmq/6pEqQsTR7g4rQ3UF8gjkZZx/55dfbra5cE=; b=
	WQk51se3go6FqDU11ZAEjuhxlFiTZjsGDSYLg1uaIu0/u142XMOuUnOhbQzakRG9
	JTNpitkSN4r51sPgYa54EvQlS4mDu0A3odLD28bNnIKlcmEP4XlpDv34Dpds2OaM
	oDBf2iI1DkNl+e05nYZkBDH6BayD87ljr+ywVi4ntLJUigKQt3l9gSqGSPnweimq
	xzdpNZKBdtz89yT/0zMTp8QvJ3ii/7Y+tCOtbucYpfHePVHdfhC9tnYJFC5AUZgD
	VZZAmsg3RWCKkCeDF54Q5iDLLy0pnhQuKT24DpYt8MJzclFPtpMrC8Je52JinCPi
	YcJpaT0pyMLWAqXfTCLfqw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47914en2dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 11:45:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55HAf8jw036274;
	Tue, 17 Jun 2025 11:45:05 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012040.outbound.protection.outlook.com [52.101.43.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhfm7f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 11:45:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eidLVSus8aVOcx43ooGagV1s020uLeUfqZxKl4q/SPrYYGpyFisC6x8AEjbYX6wk4X3PlRuykGCW6YNL+IuF9NnynWUnaVQET0IgA8RECQUoo2orqDRo0cf2bTjV8ecziHQxprCALCmB1V/qAkz1WiXqrXrGz1xCGNQC8LAPvNDQoYtnL0KKzsQK/FBbAv25rE7JaWRtrXjQU9HjL5xxCpbxeLI0ocaNIEwb6Gicek8GC8+5r448XSfgTa0CT13IQ7LmU1vcZx/M3HnoVGEeJz063zyHC0KGzpclyHptF1WCA6P6DMLS2VHs7yO3FSt1Bzq5UqH3u4HkvHyoQPpI+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=08+uMKmq/6pEqQsTR7g4rQ3UF8gjkZZx/55dfbra5cE=;
 b=NKyVGqBFZKv7NZ8VsJLZax/twSrrvmNO+ywphJ1FKLGX+XIMICPY1Npy5HKaYD7frBCrAS/X4CWQUmYwbqmGGFsagwiuWGVmyS38x+lG5FJIakNeARTc3zyTcgZqF/GQyjZFyQ4qhoONr1KICamXPQaFcucUllrLBTPYrcoyhryq5CHdAyjL6yT885R/TjtEObXsnT68JRgNyavdD7t04mR3ACM4fnqpvNPHwj8WpDONcR0Ic8keeiwZ2GZZIZN67yqrWJbUWTckgwu70wxnEmLK8nDy3PNoDmzOukcD8WW7Utw8nVEbh0ke47EYx/60NLRBiPjMMVWb2G06BCyWIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08+uMKmq/6pEqQsTR7g4rQ3UF8gjkZZx/55dfbra5cE=;
 b=JDBRtpTLv0BfnMN4qVpV1uzjrnpaArhgM2jBPC2eq3sqnNSMMUeic/coyA1FYTdSC11DjU3oa362pGzIqfzla+MSHJZ88OznoLOt9BUis3xnaODANg8YsRsjvMR+EkdTJCiHvneyaCBi3cY/f0S6fQqBSRWeQniOOrvf25lhBoA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7569.namprd10.prod.outlook.com (2603:10b6:930:bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Tue, 17 Jun
 2025 11:45:00 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 11:45:00 +0000
Message-ID: <e8cf8a81-56c5-4279-8e19-d758543a4517@oracle.com>
Date: Tue, 17 Jun 2025 12:44:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] xfs: refactor xfs_calc_atomic_write_unit_max
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-5-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250617105238.3393499-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0087.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7569:EE_
X-MS-Office365-Filtering-Correlation-Id: e8748c42-76e0-4863-1ab6-08ddad9463db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0dQVXF0NTNRVVhrd1dzcUtiNjdmZlQvdGZYckxQTWhjV2ovRTU2ZDdWVnVy?=
 =?utf-8?B?NjI3Rnc5WnU1alhJY1VtR0VIYjVuczI3MmNIOVFSOHpRcFk5Qjdqc2VtQzAw?=
 =?utf-8?B?cVZtNFVPTVFCTUhpRzc4UjNxdDNSZ0MxZlliQTg4MWtPdTBmWXZOZ1JlQnRw?=
 =?utf-8?B?NVJPSjVscTM5clZjQlI5em1FTFVkOC96amMvQVFTNGdXQ0RjV3d3MGZNV0Z0?=
 =?utf-8?B?ZlZZYmhjQlJPcG9XM2tybVMwNnMwdHJpaEFySmw5ZXBIcXNwMHlxLzd5aWM0?=
 =?utf-8?B?Tnc2UTBrRzFuY0I0MVRFOGh3ajg2ZXJWZC9yY2twRDlETVFTSFMwWGZHN1BY?=
 =?utf-8?B?c3NFNlhKdEFRMHBnVDBsdkJvZU5TRDFFV2dsSnpQaTN2SmFmSnlYTkJBK2V5?=
 =?utf-8?B?RE9KZG8vR1VVVHI1VlVqazBWUWxwVFNreVdvMWdRSUVuN2xnVUh1RTdWNjR0?=
 =?utf-8?B?R2U1eGJKdGVHR2RSVjI4UitFN2JqRUFETWFRQlk3ZDB5Q0pWdTRucHJ1VExG?=
 =?utf-8?B?QzB4QnlUemsxZ3h5QTVZSTRIdzZBcFB4Y3VFZVpCWlZxOGRVK1k4azl4c3Jj?=
 =?utf-8?B?QkJhUE5WekRnYVRieHlNZDQ0V0Vxampkd09sMUZvdjQ4VkRucVJpNjQzZ0N4?=
 =?utf-8?B?ZnROV1hMR3psNXVPdm9OMUE2dFdyY0VNazlIZCtzd1NkS3F0Z3JORmdOeGtB?=
 =?utf-8?B?bHhSL2Yyb2FtdTlGSjBXNzJTeU1xMnFlM0k3TjdmREFVcEF6bVRaOEI2V01j?=
 =?utf-8?B?eTRCSXhkUWZCV2NUcU5ZcUQ0RHV3OWRtSkp4Mi9NL3lFL1dBbEpHY2dkQ3ZD?=
 =?utf-8?B?UFZHbUpMTnJLUDgwdkhsajZYckU2ZXdZb2h5NzFtWUhVS3Q1cWR5WnhobW44?=
 =?utf-8?B?UWZhY0syTnlLUUxNWkRLN05JYkpPaWFYdkZ0TmhXbkIvaDg1NGd1ZTFxbHZu?=
 =?utf-8?B?QU1UVkE0MDhWNnQwQ0NZMlM2WldkQksxL0hxYkhuNm1DQ0dMajZ0RXpHekJY?=
 =?utf-8?B?VjFYT3hSZUt3Q0tuOFUxSGdPdmxUWmVZbGpSSDRkazNkZnhsOHhTd0RnTVF5?=
 =?utf-8?B?Wnd1N1g5SEd1cDNHZ3BCdWUvWm1Qdk9aenkxeDNzMVlVNzYvUXRWdmxNZ3Zl?=
 =?utf-8?B?VkN4YUFxM0YrdVNVN3dEZzBFbTdKUlhkODFDSkQvNktlTEdlUHJOdTVuMEZB?=
 =?utf-8?B?Y3lWRFFRazVES0FWS3NBSWJmSUFZazg2RUFvYVFiYUNhN3Z0d1ZsdGU1cVNx?=
 =?utf-8?B?Njh1UmtHcVRXTm45SjRRZmZmQjIxTDB6clJjTjNRVDAzU3BGaUpTVXNOT211?=
 =?utf-8?B?VnNZMEVMUlVwQUkxaDR3TVIydTIyNGs1bGtYcDBCVTE4TUlJNExnVkFQMlVK?=
 =?utf-8?B?SUQ3aUdhUC93bThkM0ROWXkwMjhvRnZnVUVqQ0hJdXM0NFAxcUVZa3lXblhX?=
 =?utf-8?B?NW5BK3RPNys0UnpNUS9zMXI2SitLbkhJNUxiTWErQmJtUW5xeXd0NmRNWERu?=
 =?utf-8?B?UGgwOEdQNmF2ZlprdTA1L2g0bXdxaytEcGlobzNkN0hMTy92NjVBUU5zOWIz?=
 =?utf-8?B?ZDdrRktRMjlMdXlUSTVZTUUvTTFiOURRajBhU1F0VlcxT2tleWkzaDNKU2ZM?=
 =?utf-8?B?NTJra0phOGUyRzYzbTZWVEszQVZnRko4RjRYNmllZ0xMdlZ4bDNrM0R1K3Fo?=
 =?utf-8?B?b0xqaHBnVEY5NlgwdjJTTmhiak92OU1iSFBmc1Azb2NDZ3VWWlVzejc3YVRk?=
 =?utf-8?B?d2ZGNEFrOW9GWlZodnpqb0pFVEF5M3JZTktOODJZcXVRMHBKb2VxTEJoekhK?=
 =?utf-8?B?SHUya2V0bXhQQjdLRkwxRlp5dytSWkxtREZtbW5qbElQWjd6UzdTSGtzYnVj?=
 =?utf-8?B?WXlCdjNMQ0lDaTdZVEhlMWJDY1NFWGR3TzhiQkVHYXdqS2FqMnBzZ0RJNllK?=
 =?utf-8?Q?fYAKhlzJaA4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkJBQ3ZsckkxMUFnUVdzZ1BGWFJnREFaVUFMMHZ2VTNza2lpRGVHaWFtclFT?=
 =?utf-8?B?UXFJZjgzU3JLT1oyVGt2S3pOcHRJeXlYSDJkdWxnOW9YcG5YN1VIT1AzWjZM?=
 =?utf-8?B?Z3VvUzRpY3hDOUkxdDA1cVptaHpRbytqUks0clI2YjJ2OTRrTncvUE1ueDZk?=
 =?utf-8?B?R2hjcTBZaXVPNVdXdXlBdUpDTlFYQll2Y0dORytZSzlQRXdqN1ZXMnI2Y1cr?=
 =?utf-8?B?cW5XVGU1Mk1yWTFIQy9KYmNwSUdSWTN1c04ram1IWUswenpmcTU5a3RhZ2hU?=
 =?utf-8?B?VG1wRGpZYkdmR25NYkJFU211N0Zza0YvSis5VW9jOXdaYm5XaDVMY1JSQVZR?=
 =?utf-8?B?SUZSRWx2ajA0QmpQcW5NM2xZVVlsUXBocUVWakJZMTRpME40NUw3SWFNN0JR?=
 =?utf-8?B?VFk3L2ZlWEYycytHclhrVVEzVVl4eUFscEpsWWJmZGZnRzUrVlc1aHpCTFo2?=
 =?utf-8?B?SUpqWXZWMEVMTnNXQTNHR2pNRitVVWdZS2ZmNGRyWUs5bDVWaVlwTmFqd3hX?=
 =?utf-8?B?bk1KbGVzKzNRbW50UlpnUU9ScXBBWWJ2YjkvN1JmRm9xV3J5R2NiTEFFbEty?=
 =?utf-8?B?U1ZSdisrbmViWEFkcTZrSlZ3UnBuRTBmRGc3NWNqVFVhbk04S0ZjUGQ0bmh6?=
 =?utf-8?B?dFQ2NkFiMlBDYVRtTXF6dVhqcEZ0RUJ5bE9RRldKRGdZOGozcnNDeDA1eURl?=
 =?utf-8?B?UkVHN2dLOXFsZjNWTlNVL0w2bVBnOTMzbFRILzMzYmloOUdoT1RoUVY5OFNT?=
 =?utf-8?B?K0VnRUd5emRFWHd4czZSd1FKeWc3MDlZU3YvRnk3bUxMTURSektPeUd4Tis1?=
 =?utf-8?B?cHN4QzJqRy9NL2xLdVBnQUVKOXFFVzF5Tlc0RFR1M0R0aDNYZytNWDZnL24w?=
 =?utf-8?B?N0ZUeHRkQlBtak4yeVFZUnFQbXJTTGpUQTJmZnZTWjVMQUJPZVhaNVRpWkNy?=
 =?utf-8?B?S21TSUxDZVZEN1o3TWN0NHBXUjJPMXVUSU5JNFpNMjRzK3hVM2U0SjJDUEYr?=
 =?utf-8?B?Sy9TeFpqUWxBd2xNRGZ0TWxlVHNiSWZYb3l6VEhmdUUxRGM5VTVob2RzVVAz?=
 =?utf-8?B?cVd2eXJzMFZqT3NCeW5ZaXlpZllHWVI2T1BOcmhwOGNWRmJRMTFtZ3ljS293?=
 =?utf-8?B?VmZUR29jUUgrcWxvZ3dZaXplT3YwL3NxUTRra3lNNmZEcDJraWZzUy9FRGRJ?=
 =?utf-8?B?WDNIQWE5ZTY4KzNlYVdPcHM2TU9ReXF0alZYU1FlbXRxMzRFWWlhTjNub1pu?=
 =?utf-8?B?dytwdzVhbU1FeTBVNnhvVkt2Yk5DRHRZay9veTBVNFJ4WFlNSVFNV0pRbzFC?=
 =?utf-8?B?VTE3dnhJNWJpY254RkJRRXQ3NDdiYzdkK0xqaXZyUHI1RDh1NlpKVkpZWU40?=
 =?utf-8?B?azB0T2xZOVRQVHJielFORTBpSkZsc2c0U2crNTJRZnE5Q2FhU3VpdmtBdVpL?=
 =?utf-8?B?djdnbmw2Q1VXcS9Xc1lMTjJta3paamRHTHBpSnBsbVYybFN1R3VtemkyVzU3?=
 =?utf-8?B?R3paUWZ2Vnd2MDdzeFhrdTNnRGpQT3dqNTBoTVN4RXlqbGFNRWovNGFBTy9Q?=
 =?utf-8?B?Ym5TWVJucUFoY0FqLzFxYnNoNG1aMU56dE52d0RJbGdyWThZaU8yeDNuQkpx?=
 =?utf-8?B?ekptUlJJdnZzem1Na2Mrek16cVh6RmlxcWhJWENRLzdxZ0FWV1UxUFBIb1J6?=
 =?utf-8?B?OE5obEhSMUJXN3dVTUJ5QldFWW82U0hNMlMwVCs5cENOMEVlUW5qZTRjYU9F?=
 =?utf-8?B?YlAxaG9MN2N6by8xV1RvWTYrUWxZN1AxaVZnYWtEL2w5TGxwYzRDU1U2VS9y?=
 =?utf-8?B?bVZhUTFaRXlkWHp4QlREVnprODZRWlB5Y3VoNUdIbVhqdFE1djhaZDMybEx2?=
 =?utf-8?B?MEtRdzQxd1hQcTZNdGtkMnFWRDhkMEZBWVB5WUR3c0VHcS9ZMnI2cDBOcnNp?=
 =?utf-8?B?WUQvYVFvd3NVZ1hONmdTdXo5Z2pYREJpYlBDbUYrc0s4bTJFZzY3T094dXUr?=
 =?utf-8?B?ZVFOa0NXT0VHTW1kWW9veFhjeUNaekt3WXJpYWRlSCs0VnpzeWlCNG9EK2kv?=
 =?utf-8?B?dUJIbTZOODlYbTlZSWNIN2FGSGhsWksrenNQcCtjeVFGbDRMblZHRThlVGFk?=
 =?utf-8?B?WWVDS2dlRitQK2g1MEdiWHN5dWllUkdVczJrZEZpcVd1YlAxcFk2MTA0S0hH?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fjqC3E/GZBZ5uyD7/2OFYlsu5FmIg/4CX8l2Vg7OhBwvYkCP/7JNa7NnkQ+AxR4zFsKm3wK+pEbj4IbqK2uI2yU4rWgzvdVj4E1xEQg60uLq9kTnJru/wfvtT0R8Xohb+/UaXMde8MuipnfJw9j0NXofsukT9u7L+UB7BfhFhR4Wp/Dk74XQfL9NgrFWMM9wFCmIQpgKSDigteiZ4y/EFLn5GhzvbLcQvkxfwVeLzQ4CjoKs6oiUW7L4va9fUIa4pdZXaQSfNWWikX/pWnRWVS2DuNef6ROX2U0fs6nIR4ffsfS1F8rOMwUal6FpW4KmBKMDu0VCIWGw8p1z2WpZxyD8PpujgJ37OLvVTaV8M1XBcZhPqESIBEqVaKNvvs8Gg+5oBiBADYj33WB240mf/QGlfcSYcCgrhyykVpE+r9LwNXbkit+FulnR85zhVTqN8vwMiw6xxf9sODAxvhTqzR5g/oAmdIjW4UePs7mdCdh/84ptsZNsz588Onkk5vG3f9HwfomVPCrjzu6Nmf3z7gCIYQM/LibU9Nm9nSye/vh5OLLJdGPdcz30OS5tUVntUCox2dACJWtIgOt2arifx9gp5NAHcfTWD0eYcu0h+PU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8748c42-76e0-4863-1ab6-08ddad9463db
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 11:45:00.2488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ph5JyXfzJ/Xhhga2FgLCVHWMPe+EHipsr7MUcXwipLeP15V/Hc+nwagw3blvmzy2lVi2KG512KL5pOwOlUENcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7569
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506170093
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDA5MyBTYWx0ZWRfXwVICIKTqBa48 Kydt5i4KGd225vI0GOkUuIphOnP67xiphFfaokkN5eqxFTpDYPqHQEA+uwN687T9S0zN7dCa0Kc qJFS2xWgkkqR6I4JImN7+xRcEMTw9VEcLClBTFMBucOImx5SnQDsbrEOrtP/dyRbnpFtXtffAZF
 KBVr3wXzxI1UPACb9F+6D5h52DCJ3zwzymiAvqpdgpsuKxXpiu33/730pm5dzaaWLNvVH31T+TD nUzsxJYKrbZnQpOE4896HLdBC8ALi+mrc3LtlltAQ/Wz6QpJ8hS7rVlozT47GV9DcR7UOU/B9ZQ obJCKnYVgcivcU4xa4yQoofiQqkIsEtrFL8vDdGdq24dW1OJBsAd5Sj9QgL5KWbMB5OHnnOLKh6
 gHgGM7jruR8uklEnpI5R8nuA8NdVJoPjUn+gvUR9s9ndtOjvIcaapcSN42a7zY0unhiHasdR
X-Authority-Analysis: v=2.4 cv=U4CSDfru c=1 sm=1 tr=0 ts=68515542 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=jB5nS7OlVQstEF5Js_AA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714
X-Proofpoint-GUID: soL794V6k4Fc5fjJNGGNlbHBCRmzpGuc
X-Proofpoint-ORIG-GUID: soL794V6k4Fc5fjJNGGNlbHBCRmzpGuc

On 17/06/2025 11:52, Christoph Hellwig wrote:
> This function and the helpers used by it duplicate the same logic for AGs
> and RTGs.  Use the xfs_group_type enum to unify both variants.
> 

This looks ok, and regardless of minor comments:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/xfs/xfs_mount.c | 77 +++++++++++++++++-----------------------------
>   fs/xfs/xfs_trace.h | 31 +++++++++----------
>   2 files changed, 43 insertions(+), 65 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 047100b080aa..929b1f3349dc 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -679,68 +679,47 @@ static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
>   }
>   
>   /*
> - * If the data device advertises atomic write support, limit the size of data
> - * device atomic writes to the greatest power-of-two factor of the AG size so
> - * that every atomic write unit aligns with the start of every AG.  This is
> - * required so that the per-AG allocations for an atomic write will always be
> + * If the underlying device advertises atomic write support, limit the size of
> + * atomic writes to the greatest power-of-two factor of the group size so
> + * that every atomic write unit aligns with the start of every group.  This is
> + * required so that the allocations for an atomic write will always be
>    * aligned compatibly with the alignment requirements of the storage.
>    *
> - * If the data device doesn't advertise atomic writes, then there are no
> - * alignment restrictions and the largest out-of-place write we can do
> - * ourselves is the number of blocks that user files can allocate from any AG.
> + * If the device doesn't advertise atomic writes, then there are no alignment
> + * restrictions and the largest out-of-place write we can do ourselves is the
> + * number of blocks that user files can allocate from any group.
>    */
> -static inline xfs_extlen_t xfs_calc_perag_awu_max(struct xfs_mount *mp)
> -{
> -	if (mp->m_ddev_targp->bt_bdev_awu_min > 0)
> -		return max_pow_of_two_factor(mp->m_sb.sb_agblocks);
> -	return rounddown_pow_of_two(mp->m_ag_max_usable);
> -}
> -
> -/*
> - * Reflink on the realtime device requires rtgroups, and atomic writes require
> - * reflink.
> - *
> - * If the realtime device advertises atomic write support, limit the size of
> - * data device atomic writes to the greatest power-of-two factor of the rtgroup
> - * size so that every atomic write unit aligns with the start of every rtgroup.
> - * This is required so that the per-rtgroup allocations for an atomic write
> - * will always be aligned compatibly with the alignment requirements of the
> - * storage.
> - *
> - * If the rt device doesn't advertise atomic writes, then there are no
> - * alignment restrictions and the largest out-of-place write we can do
> - * ourselves is the number of blocks that user files can allocate from any
> - * rtgroup.
> - */
> -static inline xfs_extlen_t xfs_calc_rtgroup_awu_max(struct xfs_mount *mp)
> +static xfs_extlen_t
> +xfs_calc_group_awu_max(
> +	struct xfs_mount	*mp,
> +	enum xfs_group_type	type)
>   {
> -	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
> +	struct xfs_groups	*g = &mp->m_groups[type];
> +	struct xfs_buftarg	*btp = type == XG_TYPE_RTG ?
> +			mp->m_rtdev_targp : mp->m_ddev_targp;

Could this be made a bit more readable?

>   
> -	if (rgs->blocks == 0)
> +	if (g->blocks == 0)
>   		return 0;
> -	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_bdev_awu_min > 0)
> -		return max_pow_of_two_factor(rgs->blocks);
> -	return rounddown_pow_of_two(rgs->blocks);
> +	if (btp && btp->bt_bdev_awu_min > 0)

Is it actually logically possible that g->blocks != 0 and btp == NULL? 
That's really a comment on the current rt handling.

> +		return max_pow_of_two_factor(g->blocks);
> +	return rounddown_pow_of_two(g->blocks);

note: We may be able to improve this calc in future, as I think that 
awu_max_opt only should be limited by max_pow_of_two_factor(g->blocks) 
and awu_max should be limited by rounddown_pow_of_two(g->blocks). I need 
to check the code more... it would not increase awu_max_opt, which 
people like me care about.

>   }
>   
>   /* Compute the maximum atomic write unit size for each section. */
>   static inline void
>   xfs_calc_atomic_write_unit_max(
> -	struct xfs_mount	*mp)
> +	struct xfs_mount	*mp,
> +	enum xfs_group_type	type)
>   {
> -	struct xfs_groups	*ags = &mp->m_groups[XG_TYPE_AG];
> -	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
> +	struct xfs_groups	*g = &mp->m_groups[type];
>   
>   	const xfs_extlen_t	max_write = xfs_calc_atomic_write_max(mp);
>   	const xfs_extlen_t	max_ioend = xfs_reflink_max_atomic_cow(mp);
> -	const xfs_extlen_t	max_agsize = xfs_calc_perag_awu_max(mp);
> -	const xfs_extlen_t	max_rgsize = xfs_calc_rtgroup_awu_max(mp);
> -
> -	ags->awu_max = min3(max_write, max_ioend, max_agsize);
> -	rgs->awu_max = min3(max_write, max_ioend, max_rgsize);
> +	const xfs_extlen_t	max_gsize = xfs_calc_group_awu_max(mp, type);
>   
> -	trace_xfs_calc_atomic_write_unit_max(mp, max_write, max_ioend,
> -			max_agsize, max_rgsize);
> +	g->awu_max = min3(max_write, max_ioend, max_gsize);
> +	trace_xfs_calc_atomic_write_unit_max(mp, type, max_write, max_ioend,
> +			max_gsize, g->awu_max);
>   }
>   
>   /*
> @@ -758,7 +737,8 @@ xfs_set_max_atomic_write_opt(
>   		max(mp->m_groups[XG_TYPE_AG].blocks,
>   		    mp->m_groups[XG_TYPE_RTG].blocks);
>   	const xfs_extlen_t	max_group_write =
> -		max(xfs_calc_perag_awu_max(mp), xfs_calc_rtgroup_awu_max(mp));
> +		max(xfs_calc_group_awu_max(mp, XG_TYPE_AG),
> +		    xfs_calc_group_awu_max(mp, XG_TYPE_RTG));
>   	int			error;
>   
>   	if (new_max_bytes == 0)
> @@ -814,7 +794,8 @@ xfs_set_max_atomic_write_opt(
>   		return error;
>   	}
>   
> -	xfs_calc_atomic_write_unit_max(mp);
> +	xfs_calc_atomic_write_unit_max(mp, XG_TYPE_AG);
> +	xfs_calc_atomic_write_unit_max(mp, XG_TYPE_RTG);
>   	mp->m_awu_max_bytes = new_max_bytes;
>   	return 0;
>   }
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 01d284a1c759..a45de5d89933 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -171,36 +171,33 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
>   DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
>   
>   TRACE_EVENT(xfs_calc_atomic_write_unit_max,
> -	TP_PROTO(struct xfs_mount *mp, unsigned int max_write,
> -		 unsigned int max_ioend, unsigned int max_agsize,
> -		 unsigned int max_rgsize),
> -	TP_ARGS(mp, max_write, max_ioend, max_agsize, max_rgsize),
> +	TP_PROTO(struct xfs_mount *mp, enum xfs_group_type type,
> +		 unsigned int max_write, unsigned int max_ioend,
> +		 unsigned int max_gsize, unsigned int awu_max),
> +	TP_ARGS(mp, type, max_write, max_ioend, max_gsize, awu_max),
>   	TP_STRUCT__entry(
>   		__field(dev_t, dev)
> +		__field(enum xfs_group_type, type)
>   		__field(unsigned int, max_write)
>   		__field(unsigned int, max_ioend)
> -		__field(unsigned int, max_agsize)
> -		__field(unsigned int, max_rgsize)
> -		__field(unsigned int, data_awu_max)
> -		__field(unsigned int, rt_awu_max)
> +		__field(unsigned int, max_gsize)
> +		__field(unsigned int, awu_max)
>   	),
>   	TP_fast_assign(
>   		__entry->dev = mp->m_super->s_dev;
> +		__entry->type = type;
>   		__entry->max_write = max_write;
>   		__entry->max_ioend = max_ioend;
> -		__entry->max_agsize = max_agsize;
> -		__entry->max_rgsize = max_rgsize;
> -		__entry->data_awu_max = mp->m_groups[XG_TYPE_AG].awu_max;
> -		__entry->rt_awu_max = mp->m_groups[XG_TYPE_RTG].awu_max;
> +		__entry->max_gsize = max_gsize;
> +		__entry->awu_max = awu_max;
>   	),
> -	TP_printk("dev %d:%d max_write %u max_ioend %u max_agsize %u max_rgsize %u data_awu_max %u rt_awu_max %u",
> +	TP_printk("dev %d:%d %s max_write %u max_ioend %u max_gsize %u awu_max %u",
>   		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),

nice

>   		  __entry->max_write,
>   		  __entry->max_ioend,
> -		  __entry->max_agsize,
> -		  __entry->max_rgsize,
> -		  __entry->data_awu_max,
> -		  __entry->rt_awu_max)
> +		  __entry->max_gsize,
> +		  __entry->awu_max)
>   );
>   
>   TRACE_EVENT(xfs_calc_max_atomic_write_fsblocks,

