Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538CA27A44E;
	Wed, 14 May 2025 13:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747230113; cv=fail; b=fcBoAolFcZ+mfR5IqeFRTfRBpMrYn1CYps098CrEbJ+mAER2+UbmQ0oLEiBvvQycNPEwNIgcv4AhpIyTIQx+93MM0WSxj+CvUomt+i8qg+Mtu6u1b/mZFHjh5HLy83tC07Zjd0uW7GsjOnq3JfQslJ2WAC1BlL7trkZDGN4msUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747230113; c=relaxed/simple;
	bh=bxmgZ3GkL078AfZfQXhUJJJW51XdWo7F8k+kpXYgXIU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qf17f01jHaVKB/fPBijhOBYrr8wetzR0xPtDFsvPLyNFe+0H5T7xjBbku784cBMrLmoZf6AmK+pevDTb7ABtJDmT5TARUNkTtN/Ihmyrf40YmAMe3fmzyKJhjg3LtRzkzUT0B4DXnOYOf4HxKs0Kddsou5eKZ5LQvwpkXZqDfkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BHsomb0d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pa6jtPpA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BHsomb0d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pa6jtPpA"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54ED9MOr024980;
	Wed, 14 May 2025 13:41:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pBosRZGrnTsVF+fzq0wptWIzVuitEIlw73RPXb/cg0o=; b=
	BHsomb0dSQYjan5jkP4C0LPvDUcvd3wyHhEpygYgj0DIssuxwE/vAiVGzryrcxxi
	jKdm6EQdzjFE5uhNLTBrgJ+glyDd3+EFs1LBtjqz70Be2K8idU717pKysKDgZ11v
	jKda1ykjN/mq1bbBUzGP66gWnbWdX3DR0h8ae35DHHF3vgm2R1No4mmSz0poKc+b
	I0P/uHCkFe+Gv1Jnzq2uR0H3cwUSfddbWZWNilSE7tpru47buc96uBGSappDeYhj
	YAFCL+7TZwXwn+WKhpvQcdIMooalncqEyuTgUhj0PqDPC0NWXjw5NJtNV8MmSDCj
	n8hSyyzxBumn0U+0rPzeyA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcm1p1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:41:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDClSO004951;
	Wed, 14 May 2025 13:41:47 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012012.outbound.protection.outlook.com [40.93.14.12])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mrmcrnmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:41:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vIoUt1jcDDjUMchuB37IPBmGeE5nZnf+SHIIqdgOGdu9niH9be1pbVR6hdo+Il4Gbmx5kWr0sg8qepbRSsoxCtd8G3aslyn/90Au1lC3m+7aevjxu0/dHiebv2RcKUKDdPGw7Cj5b6TIbHQ1WPfRzu6oT1pBSsD46eyxxFtrIDUI0iyOc/fMEs8fqOMfue22QC19qJqFD1XXAvrAbi4z8izLkhK/jCal7/jyP+BHRFupuMMZyUnNIEZ7FtB1+5mlb2qAA5W69iMEyxtqoH9B/sGfi1cSScdVFROBPiLaBsQIufg2g92Lgg41U7+817QRtzDz2nLIT2s9dZlQRQMOmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBosRZGrnTsVF+fzq0wptWIzVuitEIlw73RPXb/cg0o=;
 b=bL8Qqab8WBzb4GPFqxqikVDjw/l9YsOG6wz+SRxwwFO8ypV81Fs7773fii8su77Tqj/MTms3jReuBsOAGhRZhA2nVZCmXZCDpF1dJPvOLNEgNVEMtwZQFFj1ZJsFxKi7Smg9JRdDtY0fLr/VlKnzsvEaMhMHOl4gIA2zJZFb4n2QD+uNIIVbFLvdQFvPmJivqrfkI6gCaEvaswjsmt0FAqPth8d0LPD+yaBpWLApiSIP9KobE5JAhm465D5TXrXXb1zHb6FeWZp6T/uCMFwvR96jOV2MSIiqYSO1d9umy+ZlvbNBhn5BzjFR6JREWKlQwtk1UIOONZjf3etjlZcs+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBosRZGrnTsVF+fzq0wptWIzVuitEIlw73RPXb/cg0o=;
 b=pa6jtPpAXokavFyW6Wrr4khzPSANflfY/fnSQrtlm5H4nQARpXDbn3U+h43+rJ4g//LeAgguwfEs+9XeeDrTIGaUBEN+twocD+ltPymwdlOUAsGux1+VrCeqSmhG7SYsCUElVI+j9Da0Ihq1VkbyxJ0yN/WTWbh6dM5MYttVR2I=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6030.namprd10.prod.outlook.com (2603:10b6:8:ce::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.29; Wed, 14 May 2025 13:41:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 13:41:44 +0000
Message-ID: <4120689f-27cd-4114-9052-adba0a7e91d4@oracle.com>
Date: Wed, 14 May 2025 14:41:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] generic: various atomic write tests with scsi_debug
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-7-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250514002915.13794-7-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P192CA0003.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6030:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c88e2b3-79e2-455b-b079-08dd92ed10a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzQ4WkVvdzIrVEk5RmU2K1FSeE1DYTVJTzNFMlAySk80VHFGellKeWJSSysw?=
 =?utf-8?B?eUMrRW5CSENJVS81TXp5dHJwYW5QRk96aFU4eXF2KzM3QUFRMmUwc0VOdTEv?=
 =?utf-8?B?dmljUzdnOHBoeHlsaWRLRmFRT1pjTXdkeUo2Tll6ZkkvQjFRbkxHR1hjREF3?=
 =?utf-8?B?RitibEtoVkEvdUp4MG9wSmxRbDRpU2RCbDhNamxkckd0aE01Q2hXZDdQc1cx?=
 =?utf-8?B?RVgyZTFIeEhVUTA3KzJjWngvcGlteUhUcWhndEtxTEx3cW03bXBIY3p4ZU94?=
 =?utf-8?B?RTY1Q2xOb1ZZczlSSTZYR1RZd05KOERrT1lUdUZRU0xUMTFya2VlUHRXNDRh?=
 =?utf-8?B?TTM0VDhPNVdrQUlhYXkwMWcrY1FrcXVCUFM4YVBIQXBGeDV5YW4xMm1Ddk9G?=
 =?utf-8?B?WHpQWllBb2FzZkV6MjcwdDBacHc0b1NDVXJRdDdkRFZ2SDNZWUdGV1NvQ1FV?=
 =?utf-8?B?UmY4ZTlFWkxhQzBQZXV4czJWV01JWUhrWnBMTEVEUG5vb3pWV1M3ajdiWGhi?=
 =?utf-8?B?bzFNdW95YldXVnpDT1YzUjR6TEdUM29pK1NuVE90Z2VXUGV5ek55K3l4SkJq?=
 =?utf-8?B?VDFtL2R1ODM1eUx1OEN3YWFyalF3cFJUeXZSaEk1ek1tZXV6alFadE10dEZH?=
 =?utf-8?B?K0cxbzVCbjdsMU1wNnBIQ2p1VnNLNEc0ZjBGSDQrbmhuK05mTjBMNjF3a1Zm?=
 =?utf-8?B?RkpBSlRRTGxBU3BaRHZVQlRoMVFnS2tab3A4V1MvakkwYnRKUnJXS0g3RWZY?=
 =?utf-8?B?ZHJnSEZYdFJYUDV3eXBQQng2dUpZZ3JZdXFCTkxZY0VwRitWajZZcFRMd21Z?=
 =?utf-8?B?VTZhQk5nWC8xejA4eWFuaEdDWGhaRXFjRzdVUWRFRnd0R1FyMFNlMW9pbDgw?=
 =?utf-8?B?RkdXcmYzU2lhRXpDc0dNTmZrditKK29RTEMxRzM5bEIrK0Q5NEhQNURrcWI1?=
 =?utf-8?B?TmIwMHdnZkp2SFFxbHJidG9TMmZMdnhraE00TnZnZFpXN2tIRVFBd3VYc2g2?=
 =?utf-8?B?M3ZoSWVXazV6bHpQMjY0OTBZbmVyMlZZOUcvZWFrU2ZiVTFPMmFIeXNsTzBm?=
 =?utf-8?B?MGNkTzViVm9qbiszMEpyM050YjNENXRIVmkwVGpvYUVBNGRaQ1p6Nyt0bnFm?=
 =?utf-8?B?R2FZdnNzZHlKTjR2Nlpwblh2VjVYcHNOcHNLNGtMalpweVdlb0xJSmhSTEYw?=
 =?utf-8?B?QURlUUFQVXRiOTZkUDFubFdGWnUvMmVSd2R2R2NkUHhiQUhNOGl4OUFVVHdV?=
 =?utf-8?B?OUZUVXhhOXIwZ3lTUUlWZDlkL3JuVnNhL3Z6ZFZCRG5FWXVzRHNXckFSd013?=
 =?utf-8?B?R01FSjRFTEhwdDBHYjJTQjdubUJlS2NnKzZXcFZXN3FRZEZKRzZYVFllNFJa?=
 =?utf-8?B?cnJOUFdHV0gwcjJmVGtOTHhETHhZVExuTXk1NVQ0NXEwVUViZ0J2U2JGbjlH?=
 =?utf-8?B?UUJRd1JMeEdNaDJXZCtGZU9IMEFtdDBqbmZWQ2tiVG9FbTJNN2VKeGp6Mjk4?=
 =?utf-8?B?NDdLMDFrRmg4aGp0cE1Xa3J5WHdlOWN1bjVXT0NZQmZUeXFwNFFRQmM0cjJP?=
 =?utf-8?B?TDF2ays2ZU5lMG9Qd3pVcVdGeWZtNmdTOHRmKzBXdklUWms2R2pReGg4Sysv?=
 =?utf-8?B?RUc4T2VsT2ViNXpQOU5ZTHpZV0pFdlQwWm81eGdKOGZZT3lQeVY2VzkzUFR3?=
 =?utf-8?B?VnpQQXkvNnBhdXVxQUlIWUllbjZ3Q1lpOGlxMDR0ZjJJdy9HYjFZV2RTRFlR?=
 =?utf-8?B?U0VreEo1N2NUWmFqak5tc0Nac0o2T09PZ0VTb1ZvbWw0ajFDWFNLZlBiZUlK?=
 =?utf-8?B?V2FJTms1OWtPMTBVTFFQZ2tVbzJ2Vm5HQXBUQU51cWlGQTN2amtjcThIcGFS?=
 =?utf-8?B?cGJVRkJyVGtsa05HYkoreklWREFPMkNKWWJTSjRXOXV3ZDAyZWY5cTE2T2Jw?=
 =?utf-8?Q?rnYQiAe4AYU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHFqUkZzMFFaZzUxZ0hQSzNWSkVjeGlEc3JjK1pwcGlENi9US3JJOTNEVm9Z?=
 =?utf-8?B?U0t3VlpkM0krNU9mNVd3RVFGVnAwR1ZBUllzMkZxaDdRTnVBRDU1NFhtRVla?=
 =?utf-8?B?djBMYVhvSmNwS0syUDZ5S0w5OTFPWmIvRjdjRmpXQXphUDZWbG03Y0FsLzJ0?=
 =?utf-8?B?VW9lSlJ2aXd0cGo4a2t0R1VYaHZiVXd2UWRBT2h0alY5cGZsVzdEOVJFWkZw?=
 =?utf-8?B?dlRnc2tVMmFVMk9oS3R2RjNpZytYbUpSdHNkRzRxLzEwMllGc2FPdGREVVg4?=
 =?utf-8?B?czAzY0puTllTWVpMRXdvTGdCMzk3SWRyeGJuUVBYa1lyUnZFbVNkbEhjclp0?=
 =?utf-8?B?Tnk5YkNPcTFNNzVFT0lraWFhVmt2bGgvUjAxQUpnZVRSMi9tWGhPUy9PRk4y?=
 =?utf-8?B?WlRZSFlJODNlOUJUS0dZK0RQVGtaTWtlTDBsdTJ1WHkyRTlIaGxSYnQzbVZN?=
 =?utf-8?B?cGxQY0FTMWNNYnhwTTMzMTFXYk5RNnNqNUdMOTVPVzdCejF2WURIbzZVbS9W?=
 =?utf-8?B?ZWZvOVgyVXFSMkFHZkhwZzFCaDB5SStjOXltb2dZQkRQZlc4Wk1ZZGZaY1JT?=
 =?utf-8?B?aTZndUtQOVlDTFJBWmh2UWdQQlJrVHBvV1d2MjJqb3Q3cmw1czF4UEl0ZE9r?=
 =?utf-8?B?U1hYS2FLRXUwOXhGMFNEZ2o1VFFLOE5adGFwUEJBdXZTMzFaWHlpL2l6S0lJ?=
 =?utf-8?B?THhWWnBpK0pDYUU2dTdhK2tob2RNSDlRNmRzREdlTGNDblNRMEIyU2Naa2d4?=
 =?utf-8?B?V05lWU9DKzhzSHhNR0VMMnZ0THBscjhLdjYya1dwYmdpcU1WLzdLTlNTbXly?=
 =?utf-8?B?WUlJeUhRams2UWRIa0l6NklXV2o1MWs4MUdaeDFMVkF6ekU1SWhRY3VqWGw1?=
 =?utf-8?B?UTZVN2pNck1YdVZxbnFHSjlBQnoybWhWU1FQN0JlSmplQ1VOUDhWaTV3S0hQ?=
 =?utf-8?B?R3VQTVYrVytmWnBOTjAycU93YnYzQkRHRERPUUhvVGoyeCtGSTdibXRVOXk4?=
 =?utf-8?B?SlNSWFAyTTlGVytZQk5HNHYvdFpmMzhycnB6cmNzTWVkRWxPdjZrWXIxZktq?=
 =?utf-8?B?N1ErRGwwRU1rRGNkZWNkYm5MalpWckVMdWVRaUlmUE84ejJnaFJodjludnd5?=
 =?utf-8?B?NjlQTWVCeDhPbXVJRzhwWjBwelJNWU9Sc3lqSlNxcUVEL1hNUUszb2Z3RitF?=
 =?utf-8?B?R0RvaDdCR0EraVR2U2xseVpuVUxhVkhwMkp1clkrNlE2b2k5QUkzZEM5ell6?=
 =?utf-8?B?eUt3TTFUWlFqeUloMU9ISTJTRmxDMFB0eUZHcEI2WC9HeFFiYXF6YjQ4Qk5V?=
 =?utf-8?B?SDBWNTBwRGhkWEV6Zkh4VUEzaGk3aWkvbUo3dnlIMHJNTEM1UmNaV215T0xm?=
 =?utf-8?B?RWkrckJwSUU1dWljZVF5ZGNic1BhNHA0dlNvRjREYnduckZlYUJiVnhjQlkz?=
 =?utf-8?B?cnNYVS96blZLQzJ4RW14MS9ZK1BEQ2FnZzAzTFhmNVRzMklmOVdpS09UeHJY?=
 =?utf-8?B?VXV2d1pTR1Jnd3ZVM3N0ZEhuMEdsSnpuMFIzUm1VTmpmNVVxSC9Ca09nQ3Mz?=
 =?utf-8?B?dS9xaHRXdzd0ZWJiWkEvczBwWHdpSjU4bFFqSE1GM3VkaVVYcXZQMFEwMEZm?=
 =?utf-8?B?YmYvMVdNaXMrMzIveDl0a0diUlV0d2JPditidC9RSXVLWjlBdVZGMyt0aEsx?=
 =?utf-8?B?ZFF3eUVLNjJmQjhlaVVwN3BmdjZFUzhDNU5vM2hzVkRoT2R0VWliMVRaZ2xI?=
 =?utf-8?B?YUdDRjJKcGlsUjhyc2hGcHFmcjdNOWlsMUxzMUhtVXYyMEp0ZytWMnV5Z2hv?=
 =?utf-8?B?WkdYcmtFekFoRHM5RkprS0hEeW1Eby9wbHl0TmVQL2xVWFo3aGREcTgyYzlq?=
 =?utf-8?B?QWNSQ1BYQ1I4bUpnTkd6TkV6Z2NoQXY2aTU4S1ZaVS9ZMXVPS0hyU1RaK3F6?=
 =?utf-8?B?WUhLck83Y1B5akliN2RpVWVVZG1TWmFpU0xEZzZrTEQ5K0dZUDNCaVRQM00z?=
 =?utf-8?B?TXRmdzJQK0Rsb2RuMUJRZGc5ZjVOVm5ma2tSVUpUQ1d5aCtiU04zWHdyQ2tH?=
 =?utf-8?B?VWNEVVJwWXd1STVFNmhYQVVIRjJTckVFdjFzdFZGK0o1K2hKbTVnTE90KzUy?=
 =?utf-8?B?NnM1N2ovUVRDdmt1ZllENWJVV1R6Z2FLOUN4WjVaWWdGSGRNalBoZHZsZW42?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pJqZZ9ysyjewPt9BjmrKQr/Ph9qw/HHtThc6bnVitpnTctJAipyJ6pLNge0i/vcwTV6O3El6ImLA71YTeXGkv5SuYM/j9qh1p4uVV5Ghg9dX7Pnka0zy+E9zVgm3rDf7dhFLrsqClVNJC8N7Cw5w8Bh+B7yYioGrcqKRsDXSE0ybHSwhHbkuG6v1w0jL4MONRuY6iSDxr6rTaDLqUZFyJPYdkxbHjWwEq/LaUujrSsjQpJfDncl83U/Pykp4d0R9waQt7Wo46AoG0iwlB/tjUOsK1DgYsIinzk4sm5tVDHMVTz/pU4FcqTBkTCmRcAHFaMwLu0f9uOqVAZ2QXRGxs3RRK9kW1bSmD0Pejo572V5402pXGA9CwnHKt8L1DNCOFKFpi3Ppys4VVCxaw4eIL0N2bRbz8qz1MT5jpOHYTyO8EJZwwFrhWyp7+0SGY/xffPldGcvIaBG+uZYtYKMKdZOHFBCCHPr52MRi92yH64s4Zoo0Lw+1UsZ5K2zOhtQmRfi2cQ9aI3tEYsSPAmztpkjzsSePNyoC0S9IP6nHSQIke0rocQi79i/Ie1XNjBejTJzFkrZwshTWq6ATVgH0u2NTVBGjiyq/PuFlQq5R11s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c88e2b3-79e2-455b-b079-08dd92ed10a8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 13:41:44.5243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ER3Nzuf9OARxoWtYz1W1obyV5RSQ49eK/gXagDY9ibmcmGKGyNsRWu2dTkaejHtfYdcT4pX8JAfLjUDFNqR6XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140121
X-Authority-Analysis: v=2.4 cv=DZAXqutW c=1 sm=1 tr=0 ts=68249d9b cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=lJOC4ev_jzAAzLsIVGEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDEyMSBTYWx0ZWRfX9V61Xw6AEtOv A6SOlh3LMt70XXG9QMvWFPepq5qpFUm+pVpb0zp/zYxZY9SyKgJnVb4zLqoo3GbjWocPSkOcWSH IzOQox+4WFuvrmnbiU2H2hiWhKv204BZCIAikI77DbbFIGo9XG39e6yKdZiFb9Fd09j6A5DJtGw
 Mua/KdDKruF25V1z2kMyG1zxl6X5S+9RAcyLTjo7U9+5SJdqV9AQ7+oUJlvSGm34BEUx/JFb3GV ju6J7t+9ISzTGxdeRaDrRAMT+mPW7URx8RZXVA2eXCXWdLQtXVWZvuelqX76vkwCdqRtjMea4ui WBR0b1Fg02eI5KkhBeCrEQiTv1bvG5lhCnmVk6kIxLCWSBF/7VQfe5m18GfqmnUsWDdDLLAd1ZN
 H4WtQ26hMhxJExpy2Zs9htdySxaWmud97i7uMaOvJj28qmDzV7q/qXiTimL/YjwRMFsbrwxV
X-Proofpoint-GUID: 8k31eCJ_Q1VhcdMkBih_VIVaUrnwMjSF
X-Proofpoint-ORIG-GUID: 8k31eCJ_Q1VhcdMkBih_VIVaUrnwMjSF


> +++ b/tests/generic/1222
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1222
> +#
> +# Validate multi-fsblock atomic write support with simulated hardware support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/scsi_debug
> +. ./common/atomicwrites
> +
> +_cleanup()
> +{
> +	_scratch_unmount &>/dev/null
> +	_put_scsi_debug_dev &>/dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_require_scsi_debug
> +_require_scratch_nocheck
> +# Format something so that ./check doesn't freak out
> +_scratch_mkfs >> $seqres.full
> +
> +# 512b logical/physical sectors, 512M size, atomic writes enabled
> +dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
> +test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
> +
> +export SCRATCH_DEV=$dev
> +unset USE_EXTERNAL
> +
> +_require_scratch_write_atomic
> +_require_atomic_write_test_commands
> +
> +echo "scsi_debug atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_DEV)
> +min_awu=$(_get_atomic_write_unit_min $testfile)
> +max_awu=$(_get_atomic_write_unit_max $testfile)
> +
> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +
> +# try outside the advertised sizes
> +echo "two EINVAL for unsupported sizes"
> +min_i=$((min_awu / 2))
> +_simple_atomic_write $min_i $min_i $testfile -d
> +max_i=$((max_awu * 2))
> +_simple_atomic_write $max_i $max_i $testfile -d
> +
> +# try all of the advertised sizes
> +echo "all should work"
> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +	_test_atomic_file_writes $i $testfile
> +	_simple_atomic_write $i $i $testfile -d
> +done
> +
> +# does not support buffered io
> +echo "one EOPNOTSUPP for buffered atomic"
> +_simple_atomic_write 0 $min_awu $testfile
> +
> +# does not support unaligned directio
> +echo "one EINVAL for unaligned directio"
> +_simple_atomic_write $sector_size $min_awu $testfile -d

I figure that $sector_size is default at 512, which would never be equal 
to fsblocksize (so the test looks ok)

> +
> +_scratch_unmount
> +_put_scsi_debug_dev
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/1222.out b/tests/generic/1222.out
> new file mode 100644
> index 00000000..158b52fa
> --- /dev/null
> +++ b/tests/generic/1222.out
> @@ -0,0 +1,10 @@
> +QA output created by 1222
> +two EINVAL for unsupported sizes
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +all should work
> +one EOPNOTSUPP for buffered atomic
> +pwrite: Operation not supported
> +one EINVAL for unaligned directio
> +pwrite: Invalid argument
> +Silence is golden
> diff --git a/tests/generic/1223 b/tests/generic/1223
> new file mode 100755
> index 00000000..8a77386e
> --- /dev/null
> +++ b/tests/generic/1223
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1223
> +#
> +# Validate multi-fsblock atomic write support with or without hw support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +
> +echo "scratch device atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_DEV)
> +min_awu=$(_get_atomic_write_unit_min $testfile)
> +max_awu=$(_get_atomic_write_unit_max $testfile)
> +
> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +

It seems many sub-tests are same as 1222

It is difficult to factor them out?

> +# try outside the advertised sizes
> +echo "two EINVAL for unsupported sizes"
> +min_i=$((min_awu / 2))
> +_simple_atomic_write $min_i $min_i $testfile -d
> +max_i=$((max_awu * 2))
> +_simple_atomic_write $max_i $max_i $testfile -d
> +
> +# try all of the advertised sizes
> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +	_test_atomic_file_writes $i $testfile
> +	_simple_atomic_write $i $i $testfile -d
> +done
> +
> +# does not support buffered io
> +echo "one EOPNOTSUPP for buffered atomic"
> +_simple_atomic_write 0 $min_awu $testfile
> +
> +# does not support unaligned directio
> +echo "one EINVAL for unaligned directio"
> +if [ $sector_size -lt $min_awu ]; then
> +	_simple_atomic_write $sector_size $min_awu $testfile -d
> +else
> +	# not supported, so fake the output
> +	echo "pwrite: Invalid argument"
> +fi
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/1223.out b/tests/generic/1223.out
> new file mode 100644
> index 00000000..edf5bd71
> --- /dev/null
> +++ b/tests/generic/1223.out
> @@ -0,0 +1,9 @@
> +QA output created by 1223
> +two EINVAL for unsupported sizes
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +one EOPNOTSUPP for buffered atomic
> +pwrite: Operation not supported
> +one EINVAL for unaligned directio
> +pwrite: Invalid argument
> +Silence is golden
> diff --git a/tests/generic/1224 b/tests/generic/1224
> new file mode 100644
> index 00000000..fb178be4
> --- /dev/null
> +++ b/tests/generic/1224
> @@ -0,0 +1,140 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1224
> +#
> +# test large atomic writes with mixed mappings
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +. ./common/filter
> +. ./common/reflink
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_xfs_io_command pwrite -A
> +_require_cp_reflink
> +
> +_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +file1=$SCRATCH_MNT/file1
> +file2=$SCRATCH_MNT/file2
> +file3=$SCRATCH_MNT/file3
> +
> +touch $file1
> +
> +max_awu=$(_get_atomic_write_unit_max $file1)
> +test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
> +
> +min_awu=$(_get_atomic_write_unit_min $file1)
> +test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +test $max_awu -gt $((bsize * 2)) || \
> +	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
> +
> +# reflink tests (files with shared extents)
> +
> +# atomic write shared data and unshared+shared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic write shared data and shared+unshared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic overwrite unshared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic write shared+unshared+shared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic write interweaved hole+unwritten+written+reflinked
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +blksz=4096
> +nr=32
> +_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# non-reflink tests
> +
> +# atomic write hole+mapped+hole
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write adjacent mapped+hole and hole+mapped
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write mapped+hole+mapped
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write at EOF
> +dd if=/dev/zero of=$file1 bs=128K count=3 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 262144 262144" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write preallocated region
> +fallocate -l 10M $file1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write max size
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +aw_max=$(_get_atomic_write_unit_max $file1)
> +cp $file1 $file1.chk
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
> +cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
> +#md5sum $file1 | _filter_scratch
> +
> +# atomic write max size on fragmented fs
> +avail=`_get_available_space $SCRATCH_MNT`
> +filesizemb=$((avail / 1024 / 1024 - 1))
> +fragmentedfile=$SCRATCH_MNT/fragmentedfile
> +$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
> +$here/src/punch-alternating $fragmentedfile
> +touch $file3
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
> +md5sum $file3 | _filter_scratch

nice :)

But we also test RWF_NOWAIT at some stage?

RWF_NOWAIT should fail always for filesystem-based atomic write

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1224.out b/tests/generic/1224.out
> new file mode 100644
> index 00000000..1c788420
> --- /dev/null
> +++ b/tests/generic/1224.out
> @@ -0,0 +1,17 @@
> +QA output created by 1224
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
> +93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +75572c4929fde8faf131e84df4c6a764  SCRATCH_MNT/file1
> +27a248351cd540bc9ac2c2dc841abca2  SCRATCH_MNT/file1
> +27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
> diff --git a/tests/generic/1225 b/tests/generic/1225
> new file mode 100644
> index 00000000..600ada56
> --- /dev/null
> +++ b/tests/generic/1225

I think that we should now omit this test. We don't guarantee 
serialization of atomic writes, so no point in testing it.

I should have confirmed this earlier, sorry

> @@ -0,0 +1,51 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1215
> +#
> +# fio test for large atomic writes
> +#
> +. ./common/preamble
> +_begin_fstest aio rw stress atomicwrites
> +
> +. ./common/atomicwrites
> +
> +fio_config=$tmp.fio
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_aio
> +_require_odirect
> +
> +cat >$fio_config <<EOF
> +[iops-test]
> +directory=${SCRATCH_MNT}
> +filesize=1M
> +filename=testfile
> +rw=write
> +bs=16k
> +ioengine=libaio
> +loops=1000
> +numjobs=10
> +iodepth=1024
> +group_reporting=1
> +direct=1
> +verify=crc64
> +verify_write_sequence=0
> +exitall_on_error=1
> +atomic=1
> +EOF
> +
> +_require_fio $fio_config
> +
> +_scratch_mkfs  >> $seqres.full 2>&1
> +_scratch_mount
> +
> +echo "Run fio with large atomic writes"
> +cat $fio_config >>  $seqres.full
> +run_check $FIO_PROG $fio_config
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1225.out b/tests/generic/1225.out
> new file mode 100644
> index 00000000..81e4ee0c
> --- /dev/null
> +++ b/tests/generic/1225.out
> @@ -0,0 +1 @@
> +QA output created by 1225
> diff --git a/tests/xfs/1216 b/tests/xfs/1216
> new file mode 100755
> index 00000000..d9a10ed9
> --- /dev/null
> +++ b/tests/xfs/1216
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1216
> +#
> +# Validate multi-fsblock realtime file atomic write support with or without hw
> +# support

nice to see rtvol being tested.

> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +
> +_require_realtime
> +_require_scratch
> +_require_atomic_write_test_commands
> +
> +echo "scratch device atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +test "$FSTYP" = "xfs" && _xfs_force_bdev realtime $SCRATCH_MNT
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_RTDEV)
> +min_awu=$(_get_atomic_write_unit_min $testfile)
> +max_awu=$(_get_atomic_write_unit_max $testfile)
> +
> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +
> +# try outside the advertised sizes
> +echo "two EINVAL for unsupported sizes"
> +min_i=$((min_awu / 2))
> +_simple_atomic_write $min_i $min_i $testfile -d
> +max_i=$((max_awu * 2))
> +_simple_atomic_write $max_i $max_i $testfile -d
> +
> +# try all of the advertised sizes
> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +	_test_atomic_file_writes $i $testfile
> +	_simple_atomic_write $i $i $testfile -d
> +done
> +
> +# does not support buffered io
> +echo "one EOPNOTSUPP for buffered atomic"
> +_simple_atomic_write 0 $min_awu $testfile
> +
> +# does not support unaligned directio
> +echo "one EINVAL for unaligned directio"
> +if [ $sector_size -lt $min_awu ]; then
> +	_simple_atomic_write $sector_size $min_awu $testfile -d
> +else
> +	# not supported, so fake the output
> +	echo "pwrite: Invalid argument"
> +fi
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/1216.out b/tests/xfs/1216.out
> new file mode 100644
> index 00000000..51546082
> --- /dev/null
> +++ b/tests/xfs/1216.out
> @@ -0,0 +1,9 @@
> +QA output created by 1216
> +two EINVAL for unsupported sizes
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +one EOPNOTSUPP for buffered atomic
> +pwrite: Operation not supported
> +one EINVAL for unaligned directio
> +pwrite: Invalid argument
> +Silence is golden
> diff --git a/tests/xfs/1217 b/tests/xfs/1217
> new file mode 100755
> index 00000000..012a1f46
> --- /dev/null
> +++ b/tests/xfs/1217
> @@ -0,0 +1,70 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1217
> +#
> +# Check that software atomic writes can complete an operation after a crash.
> +#

Could we prove that we get a torn write for a regular non-atomic write also?

> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +

Thanks,
John
