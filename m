Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F91213665A
	for <linux-xfs@vger.kernel.org>; Sun,  9 Mar 2025 09:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741511533; cv=fail; b=faNpA98nD6xwI0ST4Dub51WrKN0koirovrTQ6M2L08Pc3pB66O7NDgdApEeo7rQNdEu3QXq+LEuhJB40V9+tovYTmA2C/1VTOAhbXx7xKd1hvbYAum+TzrIIAMK9cSWgSS5/pordJZhtgtsuZH2D8Bc7YxYL+V3VLyvyj/+c1tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741511533; c=relaxed/simple;
	bh=NLSprSmNIIoBkneI7EHFAbTNKl6MuwVBzQ6bO/ztT9E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Izr0qy4cuzcllUAppzWct1SVXAAjdQwfucnjWy8kX6ZpS7nu2mOaOwW4Zrl5YK+qtY8AhrXDDZFRM8lf2j7rck53wB99D5LUrSlq2U/++tMDOFT7Q51+qAzF1jef0VzIBCNDPEce8qyxW1Fw+q2zV4Z8Y6bXMveVKYcDI1jz284=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VGpgbXaO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rTQPttv8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VGpgbXaO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rTQPttv8"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5298010X020613;
	Sun, 9 Mar 2025 09:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=A8+ylutzY+pMb/6ZrNgyVXgzAayTf7WATcWt168uo8k=; b=
	VGpgbXaOgCpK5mYEW2eKw3aFB5LGTwR26ekP4X5BdQISZw6fdp7y4w5oynFB01Ng
	lijyLN3xg8hweyX+3XHsmL/0KTiCq5bfEpDH+7eu7pDQkPa144BcAZifRcFb6xgK
	HZc8KMvqwjpMbhCkelTWuBRCWX1FNE6fcgGa6nnmgRY8ALUNJU72wiTuDaB2Yp1/
	0DTmxx0FFqA1w7KyparSvFZk8Wyz0U8yDbVMtFiMm/97zaz3OebmqndnvuuEguj8
	xSS3yzyaqVJT5N28EgKWr1xH9GE+AHLGbh/ZguNZWzTCPjj/2bS399XBDfgoYEAd
	reoqNUDoIbr2XFiSuZp3TA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458dxch1de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 Mar 2025 09:11:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5297KMdu015990;
	Sun, 9 Mar 2025 09:11:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbcu2k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 Mar 2025 09:11:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rm+qPtDIzsM0Vti3f6FTBkHKTCUl8YT0uPoBqUPrH6bTmwrpFRP/JLvc1U+u7/jXcL/+Aa1ODTDefzFvOeeMBb/NGeaWjpntwc74CnKUyY8XEQjOKPC2va3JoowLQTrAvNfFB4QnbbYe3eHUIFgp/R1hN7G9lemmVs09gLjxlPSyjF9BqNMfJcNmFYJJQUOxSQYFE1dMTI1oN8gKlp19P8SwWrVaoDiVEohEiNBIw8Jwq/8uoAnBsiW7mu75e23dxlrtnCG5/Rlb0gWNv+4q9wJmRu6aUEMdvI5j9B0QJsujXxRFcyLotAdJkE9N1evhqiQCXiQykteMZSg2+P+W0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8+ylutzY+pMb/6ZrNgyVXgzAayTf7WATcWt168uo8k=;
 b=Pd5t8p+f8OO+YKGEJ5oMhxswxu6+VAriVN+dPZFHS67Fbmltk1XNBXa6neSXpekLozbfTGHEd3P2ulBSZDO6c9kMF3eQ2jQgqyYtPpqZ6oE01yZr7FNXToLtDjSFkzf7I0vMtGmoNikKesFnG1OBOPXnDjMwl8+5Momi4Z4vGIzHRSAZUS/kU4fh1bkCCg0A5iN45dazIj4NpTZD0htbPMtfyCIyoYwsxrF1nDk331vseq9UTwH9izTHpGBlKidAj7aE95fl44bfb7ip+bAzCfy7HfCiksxQNLakOxRTIdMc8jWvjFf9u97aJCWNyhHFfdpPeqN+m/+TP0/T9Q3hOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8+ylutzY+pMb/6ZrNgyVXgzAayTf7WATcWt168uo8k=;
 b=rTQPttv83n4Qp57zfrD/yXCP8bYE3mKsHG1ffn/CfM4fCAPdeowb15LPCyVRGGFob/7ROmL4xiWhrb6sxu2FzwIZjECnDTAIwofmp7IspPGP3zzsEsLkJHCBpkS/Ce/jfdv/rIoU+iovdaEmlQEJhhT3kVok9gij3DlUJFITXGk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA3PR10MB6969.namprd10.prod.outlook.com (2603:10b6:806:316::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Sun, 9 Mar
 2025 09:11:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8511.025; Sun, 9 Mar 2025
 09:11:52 +0000
Message-ID: <7ade7fb1-b48d-4ee1-b9b5-2aff9c1c9622@oracle.com>
Date: Sun, 9 Mar 2025 09:11:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [xfs-linux:test-merge 13/13] fs/xfs/xfs_file.c:746:15: error: too
 few arguments to function 'xfs_file_write_checks'
To: kernel test robot <lkp@intel.com>, Carlos Maiolino <cem@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-xfs@vger.kernel.org, hch@lst.de
References: <202503090042.CWpAx3iG-lkp@intel.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <202503090042.CWpAx3iG-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0096.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::36) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA3PR10MB6969:EE_
X-MS-Office365-Filtering-Correlation-Id: e3b32ca9-10c6-43e4-1885-08dd5eea6e63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1Jzdlc2ZEJRcXpLekxkVTV4TG9RN0FiUHYvcXQwWWZwdEU4VUgwbkp5UTJw?=
 =?utf-8?B?STZTclR2VjkzR0hSN2NLa3hxeTUvcmpYU0gvNUZ0WGErS3c5Q2J1eWhDNXBO?=
 =?utf-8?B?dW01RUlwNFJCeE1vNlE1bmYzQk5DbTh1UzlpSnhDUWoxMHg0cnpiTXZ1eHRX?=
 =?utf-8?B?cVVmSUQ2MXlCd2k4YUJpeVk5SmNvTG1PUktwOFlZcGlQb0dnZ2JoN09heEtL?=
 =?utf-8?B?UG9tNjV5Z1dlMVhzTkVLZGpqczZ6ZE9BaGZDMWNqTElYWnQzRHJqUmJJNWda?=
 =?utf-8?B?bjFRTU1nemF6QjdlTUY5TVFpc1ZOcldxQ25RKzY3ak1wLzNZNktMTXR3YXBY?=
 =?utf-8?B?amgyN005QUlKOGVDd2tPd2haU1JJL0ZXWmsrRVpCSFUyS3lUMERrcFMxcndJ?=
 =?utf-8?B?QlgvYS8vWXVhaFJ6c3AwUU5aVFIvdnlkdVZKQkJiQjhYZDRwejduZVFYalI3?=
 =?utf-8?B?QzNVZktXTWRZb0ZRNEIrcEg0WU93eTBxd1BCMHhXYTNlTlE4ZjRDaFh4c3Ro?=
 =?utf-8?B?UVVyWkhSMjdoZEgwcGUwWDNrZ1AxT3ljSVZUMFJ4OGdZRUU4c2d2THJXRHdP?=
 =?utf-8?B?MEdpTDcvaFFMLzF1RmhSTTRNT3pMdmdUV2lMVm45ZkdWUFlRelUxb2JCbVN5?=
 =?utf-8?B?T2RpME1UM2wvN3pNTGkxWTVpRmlFSElZaFpzRzkvSWx6aFJqckdyQnFvb0Ur?=
 =?utf-8?B?bTNYQlZDYmJzcW92KzFBKzBvNzdERHlzVHc0OFVOOGU5ekVyZGhsclUxNGhD?=
 =?utf-8?B?eDVVc2ZQQkNQTm5Ed1lBdHBRd2U5cnRIVWNOOGdWaFpqWEp2emRjVDkxamZa?=
 =?utf-8?B?MlZ4a0x6enRxcE1TaTF2WTZXVzF0RWF5SDduayt3aXFVa1JJemxqMXo1ckJ1?=
 =?utf-8?B?RkxvMkZJUXJ5bnlvNFZEQ2dzazdtaDhKeUdyNEFRQXR3WGtlU2EvSEJyWFNy?=
 =?utf-8?B?LzlDV3NOWjJQYi9RT2JNakJCS1Bxb1pQdE5ubkRsVFcvUDRhUkt4a3pSd2pP?=
 =?utf-8?B?NWtLVFEwVXRTc1dMQ1E5YjM3bUl2YWFtOTZ2M1l6YWdHM283b0FEMDhZb1py?=
 =?utf-8?B?OHdsdVY0NEFwdE9EUVB5MnFyUzFWczlGbTQ3UWhndUhTUjUxTUdLMTBFS2xV?=
 =?utf-8?B?VUlKL0hMWjNKdWN2NjNIelV4TlF1RUpLMlJqeUZQdVhPTDlhbWlHRWhTUTJt?=
 =?utf-8?B?SXN4bWp4YVRzQkxvaG45UDF4eHNUeElLZ3VBc2ZjcjZvaitkNWRhbGtQMkpn?=
 =?utf-8?B?S2luRFFEeXRkZEV5NldCcVA5dGxrMTNWSGJIc1ZOcjBBeTV0dVRjbXNjekVk?=
 =?utf-8?B?RFlKc2lETTVPcEhWOGFSQmV1VmZ2TU82UTVDcDFZWGFHc3UyMnRNTXdwNXdj?=
 =?utf-8?B?bkdqSnpJM1p2Nk9IbU1EdE93MWQxd3FKeTVZWFFhcGM1SWUvT3RHdGNzR21h?=
 =?utf-8?B?NXNMQmJQY1kzMlpkMkhSU2FxWUY3K1k1V2ZSWFNjYTVXb2pVb1BIZ3NDMThL?=
 =?utf-8?B?cjIyTVRJMkhiWnhUZG9VU1pYTS9YZjRzekJiWFBkTTZxWWQ5WjNsL1kxaWhp?=
 =?utf-8?B?eHNWRXRQdlVDTnIrQ3phYXc4MERhR3dkUFEyRnBGY0JtRzBwa290QmZDckRh?=
 =?utf-8?B?SnJJY2xWWnJVSndZWVNBRXF6OUlvYVZBZGRhYXVxS294clcvTWRpQVRDbEUw?=
 =?utf-8?B?bXFHYWQ2ZU1ScXM4SnV5alRqQmVhUzJOSW03RjZHSjlFeE1SdGNNNm56K3A4?=
 =?utf-8?B?TVNGblRnQ1lrck1iRCtxd0h0QTgybjRrRDFKOEl2MkVlRnp2NGRVMEM3ODNl?=
 =?utf-8?B?TUU5VEZsTGFaUnQ2TE5HN3psY1ppRWhnQ0VDWU4vRmhtd3F5aTBGekQwL1R3?=
 =?utf-8?Q?ye3vKZ7f6S3KF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDY1NUJLVGRXK3JYMURCUGVvdCtNTXkyRmtjSUlrUEdsbmtsUjNuSnNDOGdF?=
 =?utf-8?B?WnBIbCttaEJrUVBCYTBacXEzcGdoV01FcGl0WEl3Y3c3QTYrWnpsMVNOa0hq?=
 =?utf-8?B?R1dYNDlvZ09PREx0TlZFdThYRWRCNTdoWVRqdCszNFRzZlZEenNlTHBKTHdj?=
 =?utf-8?B?SWljK1dYcjNXNi91NllRRHFDRmVaWlJYUWRDalo1b3hYelIrYjF0QmgrZXFi?=
 =?utf-8?B?QkwyNXR2cjFBTWNIbEh1aXVoU0JjQ2VzR0tUVmVLVVBhTjV5TzE3RWhQN2Ix?=
 =?utf-8?B?czVrK1hVZDFhNDR3Z2hYOFlRRkQzenlsa1dYQlRwN2tlc25EOWNUblBNam5C?=
 =?utf-8?B?T1Vrbnh1N0N5UzRmZnA5OHFsN0o5NTdTY2ZEeVFXOUlVTFhoQWpCN2RTcUJv?=
 =?utf-8?B?bVlJZjVBRVF6bDFPaDhHQmxGTExEZU9qWXhlNFZwUGFwN3pGTTEvQnBvbGJK?=
 =?utf-8?B?SWxoQ25peXR6Z0U3aEZMcXZkWmNQejJXczRZd2J4QTU1MFZMemkrY05VbU1H?=
 =?utf-8?B?K0pGSFdYRzF4M2JDMy9KTEd5TXFsU2ROejYwSi9Cb29KT2E2VHhBWXQvM2Mw?=
 =?utf-8?B?dmo4bHJ1L0h4YzFESHV3djB5eEUrY0xmOE5qU2tHQzZSaXRGRi81aVVHMXg3?=
 =?utf-8?B?eFlrKzRxMDFPVnlRSnpScXFKSFRGV09zN2c1VzFNd2NKZ3AvcFhqb29iOTMx?=
 =?utf-8?B?M2NocXNCRjFjcVplVEdBa3VSNitqSlBNL2V2aUtTaEZsaWptbDJzTytIWEhZ?=
 =?utf-8?B?am5UZVgwVkd1TkxHQkJxaDhZMGdONVVidnlmd0sza1hXNXRRbEQ4R3R0cmZa?=
 =?utf-8?B?RWw1akVFS05WSm40NUZQT09PWHdmVndRUnQ5aERhQ2lmdzd3dE5xc2ZaU3lP?=
 =?utf-8?B?LzRsTExQMkUwak9PcWFNbmJ1MGgvT0RQcTREQ1R6NjM2SFkwVWc1bWZkMjdu?=
 =?utf-8?B?WkdMV0xpaFBQU3VQSmd5bTIrREZWVDN2QTRCaE0vblpoUzFMS3B4eElPVjEw?=
 =?utf-8?B?QzdhWjNZcTRNMG9naTdwa25ZQ1Q0SXFheTVxRnczLzY4aGNTbnBlR2RtdHdh?=
 =?utf-8?B?c2Y3ck1HZ3Z3N0xyMzcyRFd6U1JDM05NTnVkZklsN000Uk5lR0QxVEFNS0JF?=
 =?utf-8?B?TTFPeFJlZ1lpdVQ1SmRKeU1xbnRLSVNCM3JQVVNrVHVaQ05EOHdISUJ5SUVh?=
 =?utf-8?B?ZW02L2lwa0RmTWZjTnh6Q09WMkk2ZmJ1NE1oVEc1cW5PejllcGhyeG1RdVNX?=
 =?utf-8?B?UUJYYUN0bXJZVGw0RWx0ajVGOUlDVmRia3NPVTgxMkZYeVo4VldNK1NCTTkv?=
 =?utf-8?B?S0dFeUtGY01BS1FYNGFEYVhRSW0zeW5MRU11WGdHaWRJdFhyTVBhSy9pZENM?=
 =?utf-8?B?VXhBeTgxQlVUZFZJdEpub2R5aDYyK243dHRHVnZhbmFLNGdDdVZrNUpqWi92?=
 =?utf-8?B?Uzg5R2lneFRUTnFVN3RQR1F5clV2MlFLaHRHTXlyN1NxdSs2MEFWWnp3RVJh?=
 =?utf-8?B?dWMrbjZBM3YzQnRLNjFPTHl1K1ZyVEczZms5M3VxWHRkWEJvTzRjaTAzRW9l?=
 =?utf-8?B?S0pWZTBvMXIrWkV2cDUyTVVoTnlTZnpVTFkxK21aOFVRUHRLbHlHNzc0ejJr?=
 =?utf-8?B?NnlrZTFsWjZ5VjdaaWZuYkY4SFZwUEZiT2hRUGRsZ3d2Z1p2T051SEVWNm1h?=
 =?utf-8?B?aDZQU2o5WmtDdjQyN3Ywd01NMVFqN1E2T3MrbGo0YTYzT2JtZnNvSWR1L2tr?=
 =?utf-8?B?bnREZTltaUNGdnBRb2R0ODlubDZ3QkJFMk05SmdoK2JiZXROUVZ0eG5pS1ky?=
 =?utf-8?B?d1RkZWh1UklNbkRQczJ1OUZhTXBzS082WXVyUUZGa1BmRVMzdDJsalVwSUFv?=
 =?utf-8?B?aG5BY1g0ZVlvVlZjaVc5amdXV00xdHBBR0tXbmdueGNNZWgzcC94Tytmd3hD?=
 =?utf-8?B?cFlEdkozVW9nQnAzZUtaS2VKMkV4Z3hQK1BrY1l6TEhtT0lsc2dXcU5Oa1Vt?=
 =?utf-8?B?S0k2Y0R0VXlMdCttK2dlclFpM2UwU0VXUmxaUTFiVW9VU3lJd2EySHhlcUwx?=
 =?utf-8?B?cWI5T002QVIzZk9wK3Nwdzh0UUhpYVlGUW43OXNhY0VtendBbjFxejh5TTNN?=
 =?utf-8?B?RjJDVGVBMU1BKzdieXBPUlZhNmlkZ1BwWC9iRGxWODdDU1BPYUZaZ05WeG1Y?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zUcQh8sYLqBlyAXFnTmc9NYRDRBxT8X5nRbzMhVm0kPKib6DscrMLHdq46wHCYYTJIV4xWNGQzZxni0Oz5C6nLeaBWjWgI4WUJ9qXAvga7UvlfjpaADSqgcUhPT8sSF+dSwxwxgO6mkcU1A79Yo3Rtrt6sYBUmZAaXFxy450CVj9kWpc9Pt7WDDQCE0TdKaujN3D+s4YvPss/EX2m7abdcHBSMZxyL8Zn/7GZtF3WUePLYMuw6NBUpVCDpgrOAJugjJvoV7aR7P/uTnXaDWB2+QgzW636TBUg1zGSSO5Lj/7FszBU33UbKv3YJRiH9r787Fcm73oSkbnevPaPqCvSJEgbRqN+aNBes6wUUy9fDyXe8mAUNrw+VbomAiewOq1wXd4Q4ejdwwGtcKB6AjNbpMbNpQF+PFB/isrp4BbXIT+ZXlmQPEPkA5M8ng0akWF5kLXJ0Eq+jJ08eTYhIOTN5ZjMYb/y6FeaFwamHindKZ9rEF/eVfB1k+HitYOwrmuqayunou618WGPq5knPBlhsOQViGL73hxGh0dVczbbI0dwUSFldnqDB4w3Fx8xuzmLnLeqVF6Ki0vOXZMLKehBk9Qr+cdO6jclHm1hiSCkOU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b32ca9-10c6-43e4-1885-08dd5eea6e63
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2025 09:11:52.6917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4l/Z2udbYVuArc54oX+ojZKRCW1wgZbydHZklUq2wfmgtDoctPCTwVYfZz7PJWZ0Ys6ugk57d8LYK0dUCLEYXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6969
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-09_03,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503090071
X-Proofpoint-ORIG-GUID: FJQ-s1uxM_A4SMpsLFbERn5VrdD-vN3Z
X-Proofpoint-GUID: FJQ-s1uxM_A4SMpsLFbERn5VrdD-vN3Z

On 08/03/2025 16:46, kernel test robot wrote:
>>> fs/xfs/xfs_file.c:746:15: error: too few arguments to function 'xfs_file_write_checks'
>       746 |         ret = xfs_file_write_checks(iocb, from, &iolock);
>           |               ^~~~~~~~~~~~~~~~~~~~~
>     fs/xfs/xfs_file.c:434:1: note: declared here
>       434 | xfs_file_write_checks(
>           | ^~~~~~~~~~~~~~~~~~~~~

Christoph's zoned series added a new arg to xfs_file_write_checks().

I think that we want to add a NULL here as that arg - assuming that we 
won't support atomic writes for zoned devices now.

Carlos, please advise to handle.

Thanks,
John
