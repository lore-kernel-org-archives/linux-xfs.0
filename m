Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AD512B151
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 12:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046954; cv=fail; b=gb13vbgol8CUW9T6s3eOdlFgSTOlbzEI0rxhpBprtmhjWq1KYc2dwzQPQvrS7dVRG8tkeJO9LEgG194VIN4wTedoIHYSAmZtZazw2E4v8E+PFaIiYESR+aKGI5l3gcR8EIYb+dxmRRPSNDy9lEv1al4cMqBa2TDQQFItmPqSURg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046954; c=relaxed/simple;
	bh=hdlnhJWpkcdwn+cJBvHWvn5beLViXC3ynVMMBgyXR5Q=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=UXNgP1wpVapqJaDknmxVhDDpueaKUK34t4Z9gLGPsJDPq462JbrkkZFLjZ8O9yxEpyxce3NbdlOoccr3Ju2UcodvKa41ZozFpmtV1bzOek0lly5pFJq2eZIM6NUKmkEfC9m1hxK38q6p1ppyOwkv5UGLltdRXbYvupWC18s8LNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EMMRO1Nc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gw6j1mXH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EMMRO1Nc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gw6j1mXH"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P8wuH1019565;
	Thu, 25 Apr 2024 12:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=cRk4TIxAobsRRKXQxrHVnqcjaRJBujVJ3N15MzVkMaQ=;
 b=EMMRO1Ncjr5NBWXTYWgzY3UeCZm6D2LDCj/XFkRxeU27wOoZZWkNKvdvJVC6m5cS8bXB
 n6gMiIebFu2UGe6BkUzeFDqIGdc3X/I9le1pE+FETcy7YTcOb+qQLtidmSKty9aZLnri
 XcsoKkl1uEDUVlRFxCrF1JCUoEDCMjLLB9cyEcbLqNEQfYRbpWVrA/qPzUZMhtlYbXAW
 r62K1d0Wku/Lx2c67oAr+mtntDRzwdXTNwTrtRiFRqDX734ae3dDwDAxlAReSVGk9jT7
 bMlSP5tKsEwWYpi6c9Hxer0k0g/C4a7F0hzYQyi28ugJm/NWgGLqvuviGpHno8hEf2PS cQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm44f26k7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 12:09:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43PBGSf1006164;
	Thu, 25 Apr 2024 12:09:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45a9v1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 12:09:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdyxJJItuSQfFEKlSB60EuOMcOwZC8X2GSZbp5eFlbqBwWsfG/V9slqdokbZbBZ3v/uV6Kmv0S0TctIbThXjyM9obXGG6POBJnlyeFIa5Um7tOiJlAHY/mGcnGWOPdc098sbNLnL3NMJv7QaDuc14JqloILGrDwFeMZu4KP+OnRQOTEF68Cj+9Wy14QN2OXsMoLGTVVCeS6I/KbpqBaq8rFY/vuf9s0ZlBVJbFZEbCwcgzfUtx62sWRbbOoBMk/92lXsAQfdDZcuZGzkdXY8tyPB/k62GwtG24T7F3t2OfiPiPL4fxIUnAdNq1IMW60MFknJDuIFXLWhG5OLiUH22w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cRk4TIxAobsRRKXQxrHVnqcjaRJBujVJ3N15MzVkMaQ=;
 b=NyhPHD6jusOawO3C7bQ1A37k6IFzweLEZOV9lkcu8KkJH0+WWHuQoRbCwH/1Lkm1lXN9ztOgh85tkE4bSMgyK00M4+ivZlSSTDfSOh26vl9EEbvRAYr8PEgADcjOF0bu1V9+3m0kvmIuDBWptm5gRsH9SySRCdpcqh+CLbNei+f9ZHpxINdmtKwb2Pi3xGPuiT20TV1leFXpNY3FrmKvcOfkCHXw01i5AGObQw1wFZfahFPQ2LMnAzXAXzF5qbz9pBG4IOb+I+x36KRjtKMRlyTLh/ZsrtJwNMstwcTWB67BI/yMHvXNfH6Xgi0fzipQbYoP9BKVFOdV40Epr4dRFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cRk4TIxAobsRRKXQxrHVnqcjaRJBujVJ3N15MzVkMaQ=;
 b=gw6j1mXHqd3VL1w7FFBsERSCYZBDBTy8XEYnlQppzft2FDiMjgLc4Rp/x5GViuMa2R9B6UqG1L1gWWEfNN5ugn9Nf2aA7CTG4UxL5ONPhHRySSwQgyA0Epx2u9hibk17lDdd9MXRnfv4S5ESSsuoowZhlMvfFPKBueQs2NsMyPk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7197.namprd10.prod.outlook.com (2603:10b6:208:3f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 12:08:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 12:08:58 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/2] xfs: Clear a couple of W=1 warnings
Date: Thu, 25 Apr 2024 12:08:44 +0000
Message-Id: <20240425120846.707829-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:208:d4::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7197:EE_
X-MS-Office365-Filtering-Correlation-Id: 924d6abd-4c55-4f9f-53dd-08dc65207c53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?a1gwbmh0WXNBbFNzeHVGWUEycFYyVlBjbGttM0NnRmVoc25BR1F6ejI3Y3JX?=
 =?utf-8?B?N2IvaFpvenJGanN5UUVOVnRVLzhuVEpsblBuSmdoU2krTitwTkEvQ3Y1Q0Ns?=
 =?utf-8?B?VzVIcnRydmhvQU5UYkFXN1NaNFRETlBOQVF0MHRldElDbmhQT3puckRjSUdh?=
 =?utf-8?B?UU9WcUhaeitHOUpCRzFTUWc2c3RJc2xNU09wbzhQNFk5VWNJOFRXOUVlZHp2?=
 =?utf-8?B?cEJrSytjMUxFZ2luVTdHazdhVy9KeUZ1dUNNRzltY1lBVW9wakFiT09GeUxu?=
 =?utf-8?B?YW91QlpCd05CTVFQMi9Ca2JaRklQckhrOURWSHFPb2RIV2pNZDJjSVBLNWla?=
 =?utf-8?B?d1N4OFJPNjBxZ2xQajgrd2FtSXhUNkszemdNdTc0Y3FxVGVqM2docXQ0cUxl?=
 =?utf-8?B?R3QzUkNSb3R1cWdYWVczNXRhakgrUnNHR2NFKzQ1VE5IVUpUdU5RT0JPSXZF?=
 =?utf-8?B?MDZCS2NmdWtKVExkNGtPeVNDK0dFME94MHl1Q3ZDTmRZTkFrSXdLV3AzVlRO?=
 =?utf-8?B?WG1mdGRXUkd3bDRIOU1CQUc5OWU2SnNTM1RabFBzb0FzaHN6NlZnSGliS05I?=
 =?utf-8?B?ZDN2ZXRIU2hncTF5M1UyY2dMaFE5dCtWUDdha3F1bGRuUlRtTjlqbHZIenpW?=
 =?utf-8?B?SHNMSnFYVFBpNWRBTWhuQmRDTnZKUnErdlVuS0lvalhTM1A5enZMeDlxbjlM?=
 =?utf-8?B?Q1NIcEp0Ky8rSGkyTkxXYk1rUUVrKzloaUxaekIrY3FtbE1TMkNtZ3hac3Zs?=
 =?utf-8?B?bGNXN2FUeURHNEZVNlU4Nnp3UzVSQ0tpaUY3S3FVRTVkZHNFeTNPRHgrNmVZ?=
 =?utf-8?B?Wjc0THVtMTgzUEVvaUdrQnRZZktFL2RMSERJWDY1WDVQS094VFZ0TlNuR2xB?=
 =?utf-8?B?NmhxVlpIWVVWK214blFjcUpseXl3RlduMUVBWStmNFF3ZW9RU2NKSDZEUmhy?=
 =?utf-8?B?M29FbjRnL0UzbHNxNGdkMldyM2VYTkVzT1FHV2pHOHhrcHVzOERUNURRbjVw?=
 =?utf-8?B?THBWT0FuN1F3NU04NzZKZzVqdjcxa0Nna0RYeVNOMTZVdjJjWTFwOWlLNXpI?=
 =?utf-8?B?dExxSGpMTXpmdTdML3lSWjFxeDdMSDFRNCt6Q3NtOFhSM3BpZVUxZmx2NnJ6?=
 =?utf-8?B?RHZjVmMwcURkazRhVWxrdWtISTVEL2Z4bGZGbHZCMGVyTDdqSmcxcjdWN25S?=
 =?utf-8?B?N2t1Qy9FajUyN2V4R3Q3T09DRk1EOC9KS3lJSGc2UnZ2OGlMY1BZRE00VlBE?=
 =?utf-8?B?a2pCdTlwQllDaHVyWnp1WXNFTURSaWJMb0tiQzI4dWNPOWdHTkZoZ25yaE1x?=
 =?utf-8?B?aWlZSVVwcUpCMW1QNEoxcXN6Yy9YZFdVa2tnblZFVUtLR1hYZW9ja3ZOODc1?=
 =?utf-8?B?NnVtV2VKWXJzVWRpWUtyTGxneGdLOXN5amUraU5HY1NVZU1Kd3gyU1ZYbGcz?=
 =?utf-8?B?TkN4aXpmd20xVHlXeWRYVnowaldzaGQ3a1ZmSFRaNitJWjNxV1I4SlVNeGRu?=
 =?utf-8?B?WTRETFloaFdnOGRidDZXWE1IV0x5eU5QcFBuWDZZU1ZWcUx3ejVXZkVVcDNK?=
 =?utf-8?B?Y09SS3RrTTlhZzNKUEFVT1lmS0VoSlpXN21scDVBSlZPQzFLOVdBcmdJaUZO?=
 =?utf-8?B?dEFRRFlHVHd4K2ViTEk3KzQwSVZrUTlDN3NTemRWUEtYVmc1V0JCRUtLUURV?=
 =?utf-8?B?ZERyRVlKOGpkNU5rNTVITDk5Q0d0c1Q3K2lHMjJyS0pDd3hrRThaMXVRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?czAxdUVIV1d5cDRXSGdhYjZ5U2ZSdmxBQ3JIaTlITFRHMyt3c1JXSjVETFlU?=
 =?utf-8?B?OEFxYXIvaERFSXJJK2FQNVFQN0tiRE1HUEZ6L25Ba1FVTVlyK01sOHc1SWpG?=
 =?utf-8?B?SXVDNVluYzF3K0ZFbDFBZXI4YnU2RGpOWDNUUGs4QU4xR0RTOWVWTytRa3dT?=
 =?utf-8?B?WXd6U3gxdDVISk5tT1FiTUpjem9MMVdBdlV3QUFoTW1WUnpJRXZUOWRmUlZu?=
 =?utf-8?B?UnVHalBnMEFUQUU4MFloRjdyeUpjMzJpOVlZVU42emRoWi9ZSVAxelpVTjhr?=
 =?utf-8?B?MnlXWXl6Y0IyY3RQN2pPbnhIWUlHLzlSNmNrVWEyaTNrbFRsK1l0czVERTVi?=
 =?utf-8?B?aW5JMUlGaTRTYWpnVGpsSllLRmcrcHNQS3N4UGxOK1Jnak9VY2kwbm16WExj?=
 =?utf-8?B?NmUreFdRbHVWN0JDTVgrWjVDM0RvTzFjRWgxTFM4YmdkREZId0pmSXcyNCtu?=
 =?utf-8?B?T0RpRTBwWENVZHdjVVRUNkZUQ2ErWCtjSHNvb0FXcXptMWJtc3U0bkl1ZW0z?=
 =?utf-8?B?ZENkWGw5em5uZFYwa295QzJQTkZoZ0xnZmJuSFNHTlUwV0NTbEFIMGM4L2lm?=
 =?utf-8?B?WDZHRjNEWTBjcHVyYmJ2WEFCYW1SemhIVE5xWFM5OEkvM1FBSjY5VXp2UUxo?=
 =?utf-8?B?OVA0a1ZwajJsdXJUdEFzazdYeTBZZ1JJRUhoRGVMaGo1NzBvQ3VhMXB5dVEz?=
 =?utf-8?B?clVhcTJzUEE5SlY2ZVFMQlo3Sm1IMk9USXpWRzhzK0o1WUZYeXZrS05KdjJr?=
 =?utf-8?B?Sm9JRmk2bm1sTDdWcEdDbm9Fc3M1ME1yK0hsMGY5aCsvZEcyaFRvTFdGckE0?=
 =?utf-8?B?Z1ZmMXJMQm1FOFBJTHdYcHJiNmpNU2VKa0hMVTNJRnNhNm4wVk5NQ08yZUgw?=
 =?utf-8?B?WkpCTVBKM1dnTTZkYjhDMUV2Y3BDR1Rxckcwc0ZpWE04eEpaUTRabEpnZEZ2?=
 =?utf-8?B?dWM2SFhtVTJPbFhLcG1mS2FnYzlVdlN1WVdFYWtpSUFPNm82RGRXRDFzU0Rl?=
 =?utf-8?B?RlVsL2JxRzZoTHVVL3BBa1lYNjVrUzBFT0R0d2NFdzlKckpZU0EzWlVPRGVy?=
 =?utf-8?B?cjcvdVdNZmc1U3FnMmNWTlZKdnNQcWZxU2g2eG41VGJrdjdPcldWcWNlNlc1?=
 =?utf-8?B?cEhKRnVGU3RRalBOQ1RZWVZOSGJVT1dPbUxtaGI4Y0hoUEVDaytQRmdNcWM2?=
 =?utf-8?B?YTJ1SmVHd2xHODBXT1gvemNMZUdVY3ZBbjl5OStOUUk2dzhmcVJDWkdBVmdS?=
 =?utf-8?B?TXlZM3V3SWlyb2R0b2Y5cHMyU2E4bU1VQ1ExWmoyZDA2VVROaWdxa2VMV0w2?=
 =?utf-8?B?OHNPQUM1eGJVcEwwOUNjLzR3cXc0OGRybTAwcnA0T2ZnYVZIbisvYXhiT0o5?=
 =?utf-8?B?Z0JrS3hSc1lMSStkK1A4YnZGY2g5Qmk2OXFwOUxWRGwyNXptaE5GcDlGaXMv?=
 =?utf-8?B?WnBMSVE0T1F3dVZoVnUvU0VvNGk4Q24xRlMxUC8zcGx5Y3FQSW9qOGVUdDZj?=
 =?utf-8?B?b0lhbkJqMFRDZ0pxUitocUFPcUJMSTZBaEhvMkRta3VwV3RuQ0l5VEluZld2?=
 =?utf-8?B?V2xOOVcrUndLb2x6SnZOL1BRamN5UTM3cHh3MFp0VS8xci9la1NidlVmcy9H?=
 =?utf-8?B?UWVFcTJBaUxvZm1DSGpEbVBTd1lMU1dyK0Zmb0VRRVdsUFkwYVNGRG02czVP?=
 =?utf-8?B?OHB1OE9VSXhtRU1mc2s2azk1N2txak9kVy91eElVL3cza1F6WEhDZXcweGZ4?=
 =?utf-8?B?THV1Q3QrRHRlRkszRzFOZXVMK3pmaFhURDdSVHFiYTduRUFacklwRmh1L0xp?=
 =?utf-8?B?MVdXUDg5d2Nkb3IxTkV4Q0xZeFVyUTQrYnRnYm1seEp6T1lFSm1LM1dtVWFj?=
 =?utf-8?B?Z2Q4dWxXcFVmRUd5ZXZoUWZsWkRrMnZKUHlhSGdQUUNSRGc4Zkd0YjBWbHc5?=
 =?utf-8?B?SkZobWR4WVNIWUFSUWhLZVZiZ3BxRnZVa1V5T2NaUjBRV1NEYUd1dEpvUzlu?=
 =?utf-8?B?VTU4OGM5bUFSVndWS05vdW9wciswUXppNFhGMnNWSWp6ejcwQ0p3UGJXcFhx?=
 =?utf-8?B?VWhqZTRGMXo5NEN0bFJqOUoxZTdCU2J4SVlsSmhrZG5nRXJWbS91Z0ppVU96?=
 =?utf-8?B?SzBuYmNDQ1lKWk1HM0JXdzUxZG9xcnBRTXovWlpZNWYwZ3BiYjB6R011SlRi?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	nBP016cQtDEYbkUKTug1Tt9YaJwMB8PkpOvxdgdGn5scXWdtsdPyVVz8uaS1IEZ53f+YQ2zOFwvHSfQ6OC0lfChMimvEhSRReYvxcsuTq4NJqjgf51TsusAE/UzGasvVLAngf3KAUE3TEXOXX9KFJu9/Cr1Xa9CnwNTp1ZOCcmYOjYdzlx1trlLaQhPdr5F6Sm32hBiAx+IJh/wSssssSunMu661t9ZDebI32/JxBFbmFQ/rPOUrd1BmeX/PATFc86wKj2MYYVC2sPym4mq8c46qsgmXfjHkO4OrQEHZmuCs/daVIUJ7FHJnFYwaQg8H7iL1fdnguKQnIQ9k4wmkvk8tu/pCoiSjDNt0y20OchjcO63XhATV1pT4IhbwIpt0X3XEadazC8nfC53UOG9Rsfd/16n7FQtPSqpcp1Ivc/8yjYxkLC/8JfOIkPOBvbN0k7jBYwJfW9Ryjaq+SK/F7b7OTRlC7lxywNEk3Irm3xsuzbaV0tkpkKwzDVAXSi/44mTv/b2crQhAeP5JSc73OnG09AbQlziSsltIJ04WNDJEeYHKk0lrMGBLbf8DdAZdyfPNZHguPRsu7eAs7fPDcr8rC7AGgfIYYXvSwXBQByk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 924d6abd-4c55-4f9f-53dd-08dc65207c53
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 12:08:58.0020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gu8Sm+HeX1jVxK4TwmTbIOaHRPWJHOudFjqA8KzOb+AzUjJuMtLucpZ+wkbYwbAuq8wOod8xX2vhRIw//gfg3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_12,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404250088
X-Proofpoint-ORIG-GUID: oKWgcqlbfHBRSpkhF5dxsRAizsaZ7LaF
X-Proofpoint-GUID: oKWgcqlbfHBRSpkhF5dxsRAizsaZ7LaF

For configs XFS_DEBUG and XFS_WARN disabled, there are a couple of W=1
warnings for unused variables. I have attempted to clear these here by
simply marking the unused variables as __maybe_unused.

I suppose that another solution would be to change the ASSERT() statement
relevant to this config from:
#define ASSERT(expr) ((void)0)
to:
#define ASSERT(expr) ((void)(expr))

Then the problem is that some local variables need to lose the
#ifdef XFS_DEBUG guards, as those variables are now referenced in
ASSERT(). This means that the objcode grows ever so slightly. I
assume that this has all been considered previously...

Based on v6.9-rc5

John Garry (2):
  xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
  xfs: Clear W=1 warning in xfs_trans_unreserve_and_mod_sb():

 fs/xfs/xfs_iwalk.c | 2 +-
 fs/xfs/xfs_trans.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.31.1

