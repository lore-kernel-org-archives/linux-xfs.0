Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71F01DFDE
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2024 16:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146915; cv=fail; b=oQlAaO9wa0/lChVJW2/BgR4TPBQalkI9xH797ns0vGG694KmKj7uLkSuIeP3uoTkv30xKRE+0pWCPKHpvwuPGjv3fX18ePFAJBuXc5QqAVb2cnaPngFW3ytMtT+5Kt3obeHYXxqD0dvsp6gI9K8UhO2ZlDoSkSSmV4ujHMxDhbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146915; c=relaxed/simple;
	bh=JWv12a1YKy+Vloki39TdOks8plbl2ZHU9vudFY/0CME=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZcsvxyI54lpyE6sUYdZ70ILYFE+FxKg0+0hJ+iGKC0OYXd1PC11AVJcD5H8XPM5ys18Zlwhe7tYgYPBdW6K0MimNbfRtZk1uYj+gGMYeLXOwZQ2tD0tk1hkYg2lfxRTWWNn/JEF5DAEGyPZs+xE/3h4CSpk3dNV2pQ4TAB2CTXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xs2aAJ32; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ffd0SWMh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xs2aAJ32";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ffd0SWMh"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46GFMUxP010938;
	Tue, 16 Jul 2024 16:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=JWv12a1YKy+Vloki39TdOks8plbl2ZHU9vudFY/0C
	ME=; b=Xs2aAJ32/6y2KxoiS8YvBTCA6JwlmnQ0gvSAoTAcXnQgv7tjsCjTKJOfn
	UnlBWsS4gsYJeFQOF5Pr63lP+Ix4Ddern6g1V0ibmpas9tfCxpFW4cUG25LhfLY2
	sevDB/zqbL3YgNdXcVbGPPjGV3zHXLauJnfVXhyVoZNvnYpxyf+0aDZDz6VBZArS
	67CvtjBwYZ+bpYBBVi/E4JE5oOf6h+3iHhLeSawIYws/cCCAhjltqsgq60MxS9Wz
	f5XJGw0JlKv9wJ1JUXNpvtPBGAxiRqtjre0iUQ38YtS54Kuk3LdFmcTQRM8H8RPj
	HAM4jv73MHaNkY7fp7gvthcKfjkrA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bh6sx9jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 16:21:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46GFe8DM010783;
	Tue, 16 Jul 2024 16:21:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40bg19svpt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 16:21:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hoJWmUTQpIWSbXuqksLs0UX+kVUaofVYqFKfAYpeI4ubDs+JAq7AGZoEmaxBfygCnQT0Qnx/j4rWugEmI0G+1K48ozouulbxcvdfLfYa189X+EgHdOOMAboLA3E+cnWtPZKWt4FWe/f42fr2O8yGPXq4V+nPDQ0pBhGZX34CRh047mSeZN0gwjOxtE6ZkoH1S13+XUcGOPG+1hOQfufqaAZDmTsym+Vt07tIY7gNd92PpTIn1NDYmUyN5FmC20V+7LNiRBPf/BRHVX6USCA0S/m+xsmfvewg+0NJ6PbXowZhQVSY499e5zWl2dN8OoTTPDJJoL2ISKuDlp0cBavcFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWv12a1YKy+Vloki39TdOks8plbl2ZHU9vudFY/0CME=;
 b=uOQzjTSlORSSOUqbwCMZsEI2olfJ3OQ6lyDy9tW3BZUp2Aekps2KqGShCbaKBFYxOBJ1WyKh3Lhc1F3Ao5TJpblGTqs90YmorPY2JmdU+VIqNGFscCe+385Nog5ULJmmIHGtGFaQ/3lCUHO9AcJbZLDTvWaLRpdAEtIjCeJ9kSYeWyF6xgj18cXyGeuiBsfDGToFwdSV5bRpzpI/KfU4fAPhzh6gXsBKRBCYreZKZHCa4vdvyVtbuz5jyzazMH9O/fUnQrWBqtvXW51FE/8qrDweTUnHGwoXtBoWa9GIrqlzy+CECXD1vP52c6RCTj3sLbCN7Yn5NKAYgSTMM5FEhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWv12a1YKy+Vloki39TdOks8plbl2ZHU9vudFY/0CME=;
 b=Ffd0SWMhIgvLrtbnDyFl/FP1TyMOA7Tl+bSdPJyWp6bGKUv43YINbKlH9ygk42S0RP36xmHoHwnULuYnVOMB222ix9uCW5Bab3dwxJhfxnhrXc0s9qrb1B/5f8y6QqAXp1BZEibmogiSkA9KcI9FUffezRiIwWUGgw/zP+4Zk2o=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by MN6PR10MB7467.namprd10.prod.outlook.com (2603:10b6:208:47f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 16 Jul
 2024 16:21:44 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%3]) with mapi id 15.20.7762.025; Tue, 16 Jul 2024
 16:21:44 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/9] spaceman/defrag: ctrl-c handler
Thread-Topic: [PATCH 4/9] spaceman/defrag: ctrl-c handler
Thread-Index: AQHa0jOtCDSXY2lnIkeRvGgwFfxoT7Hu4+AAgANDO4CABkjfgIABJBEA
Date: Tue, 16 Jul 2024 16:21:44 +0000
Message-ID: <1677B1D8-3978-4281-AEDD-5496FE874522@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-5-wen.gang.wang@oracle.com>
 <20240709210826.GX612460@frogsfrogsfrogs>
 <5A606248-86EB-406B-B9D8-68B7F06453B2@oracle.com>
 <20240715225613.GZ612460@frogsfrogsfrogs>
In-Reply-To: <20240715225613.GZ612460@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|MN6PR10MB7467:EE_
x-ms-office365-filtering-correlation-id: 9e22b810-0b69-4a77-af9b-08dca5b3626e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?V1pkNWhuWm92NG9WbE0wOFFhVnhsZTBaVXpZSzNKQW1KNXlveWZnbGJHY2I5?=
 =?utf-8?B?TkgrWmEwMmlPb2hmeEFkTVRLSnJHcFd4Qzk1VDBkUHV2WkZXY0EwKzkyNzNJ?=
 =?utf-8?B?Z09MMkorOXNYMVZUejJZQkNyRFpNTFoyelp0NG5lejZBWWEyK1l2N2h2YUlN?=
 =?utf-8?B?bGRHeTFZUnBiMUo2TW9ubTZlMEJWL1puSHJGRWpRMFZRYXR3bjc1M0YwbXJF?=
 =?utf-8?B?dFlyK2NFSjlramZETld1MjVWd1hWekFSYkg5ZW5TSU52dkVHMFFrS2g2dWM4?=
 =?utf-8?B?Ykxaditad1lmYi8wQS83Rno4b2hRQVd5R1dzeXpxRGx0RU9GcFdXampyV09K?=
 =?utf-8?B?bUlmSjloOWpDclpMRnVnMVpGcncvcnZuT2x4RGx3bDJRNDZ6aXVYUzBZbkJM?=
 =?utf-8?B?bHhGbk94UG42Ry8wLzZUNVI1MTZDQi9FbnNtRUE4OVV3cVc5UCtvR3kwNC9P?=
 =?utf-8?B?cVpDbzlWMmlsKytpOU81eVFmcHAvODN2WTZ6Y2hLNERkSjI4Nm9tcElhc2JU?=
 =?utf-8?B?NWtTSktLcjZ5anRZQlFGZXJibFNYaEZrcFVVL2FlRXRodWtjYkRDaE40R01C?=
 =?utf-8?B?OGlpdDVHaUZHbzgwd3dkZm5TVFpNSmF5OXAxblNIMERDN0NNREUrU3BnUmo4?=
 =?utf-8?B?Q0dibGREVVhhUW1KMjNZblFMcVAzVHoxQVhOTFlzMFd3aFg0eGtjME84bG1T?=
 =?utf-8?B?N08rc0Z4NEp0S0xhSjhXTFB3RnAzTWtmQ0VjdUszVHRuMzdkaXUzNXJYNlBR?=
 =?utf-8?B?ekQ2NlhWYzl3bmJWcmRETmduZ25oejVlL05ZNUxOOEFVMlYxNTZQVHhyQkRP?=
 =?utf-8?B?VCtPemlvYjQyemEwbTJEZDllblFqbXNnNElLTkJNSkVtMWVvTGdWRVpoM2lK?=
 =?utf-8?B?aWNQS2M3M0h0K0VDeHViL0hRMnpPWVE2YmpKR00zVjh2eHEreUE1Ni95NWN0?=
 =?utf-8?B?L01CVnRYV2R3NlEzb2ljdWhYdCtiWGRZSkJYdmpVanh0clNGK2JPRnkxM0dC?=
 =?utf-8?B?NS9nb1Bpcnc2WEFCdEs0VjZiaTdlRkUwamk2Ni84TWpPMkdncFFWdm5ITC9E?=
 =?utf-8?B?d2sza3EzbmhEMitzampwd1FRRURuQ3RkN29ybGJlNmRtVU9tVWs0akNlRmhB?=
 =?utf-8?B?blNoanRnRE1QMjliaXZqZmNNNExNTWlBQ0VkVVNDTFA5SVlFR21TRit5QnBH?=
 =?utf-8?B?aURJMU5IQ1Y5aVFmK0drbndUc3MwNmlEUkdxQ3hkSnp3eFVDZ2MvNEljM3dH?=
 =?utf-8?B?UDhqU0pSaEV2N1RQcXd4eUxra2pza3d3Nk9MUjRJYTh0RVZkVmVzZ3hlSTl6?=
 =?utf-8?B?UnBSTnRMY3hWZ3QybHRFUHJqVEpOa0VyM055aVlrdWRXVTdMU20rczZYNWp6?=
 =?utf-8?B?d0kxWkZvcjJocUF6aG1XTzJTNjRqQm5tM0NNbUlTVjBNVkgzNFJtcXR5Z3hv?=
 =?utf-8?B?YWN6VFp6R3hTTzRQK2xlQjlTTEs2MU5PRW5BSUY4a3BWWEVJRUZrbVhjbjJ5?=
 =?utf-8?B?d0t0WnZWUGM1b0J2QkFDV1BoYmh4NktBK0c5S0JnSmJIRXpJSmZxM0pQaVlG?=
 =?utf-8?B?bmMyNXlSSGk5Qnh5QXBCOWJQaFJaR2E5NUwyUkdwNmh3bGpGaXZDZXJiZmhN?=
 =?utf-8?B?S3hMaHBVY245ekFVMDZNa0V6a1FCOU9nK1hLanJ1WDJhVzdpRnRIY0VYQzdE?=
 =?utf-8?B?Wnlqd2hBbWdEUnRic0kvN29rQnhYQWtoZE5BbnZkSEZRUFpYVHFsR2xjODBy?=
 =?utf-8?B?M0pBVXVoc0ZZLzFhSjVFYUx2TmR4MmRENnhvTGUrYjFnaHVqZnJsUE9QUlky?=
 =?utf-8?B?TVFUanFhaE1UR0tCSFhIbUF5RFBOeW1WMTNmcmxKSGRCQ2c2WHd3UUpZM0Vv?=
 =?utf-8?B?ZW1mMjdkcjNrK2tUQkpBMWdSaTFaOVNCTkVGcjU1OXM0T3c9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?L3dSYXppMGpuSitiTG9LaGUwM3pBU0dDTU81ZFN1aGt6VU4wakM4dllOZytj?=
 =?utf-8?B?ZW0xQXZnZDhVem56V1dQV09XRnpRWDZDZUxlZVlKeXJFU0JNb2h2aHZZeXBa?=
 =?utf-8?B?TjRORlhmdzQ5c2VlZHRnckVZM0R2cjBISGwzK2Fxb0hmUU1xelR4c1lpL1Zo?=
 =?utf-8?B?T1dISzVGYjJVMnZubnU5MENMckk1R2d3aGNCaEJYTXlOazFVUjl1bUtNaVlU?=
 =?utf-8?B?TmY1MWIva0pPTjU3RkZ0YTgvQ1FJeWw4VnArYVRIMVBSSXJKV0ZHZWl5d0k4?=
 =?utf-8?B?RDF6aFQ4VUZMZ0hFR0tvUGNkenc4MHRCZjBSQzZGR29LWWpmV1J4ZFNOVmpF?=
 =?utf-8?B?WlkxRWw4WTV6TVVBN25jTy9ZUW04Z2RhcnAyUE9MRXUrRVQ1NWdQY2hES1pk?=
 =?utf-8?B?dmNWaStZY1E2TXNXaUpEODFtNklWeEpxTDdiOGdFd0owTHpNVlhnNGxjTXgr?=
 =?utf-8?B?a2VOZHVCTkJLNjU0RHY0QTc1UW9hdzhpWjNjNVkrTDlHZTg5MlZyMkRxc3BO?=
 =?utf-8?B?ZGF4aDJGaVR1clFIWG8wMng4VDZNRVlmSHpmV2x1S0w4WDQ5MlgxMENQdW1O?=
 =?utf-8?B?OEJzL0F4WHRTeWRYdlRVdHBRTzlGZGJwN0tqMVBISzJYNFV6ZlIvVHk0cFph?=
 =?utf-8?B?MjE5Nmk1djU0YU9SYitDQmtBbDdLcWEwNlVnelY4S1dVSnlwQVZCRVZCY085?=
 =?utf-8?B?Q05TQ2h5NFBQVEdtdXFaa2FRUGxVQkxkUnJUa0hxNERQUXh1NDN1VHFKVGM4?=
 =?utf-8?B?b1RJNkd3NTdTOE5hNHk4WTRmQVhjOGRZWnZZd08vVWtnVElSSVdOdHRzWWI3?=
 =?utf-8?B?cThYYldMckR4V25uQmhZQ1ZSMEdBS2g4MGlnRllmd0tWUk5yTFNSUWF1THhi?=
 =?utf-8?B?VlN3S050Ym9UOWc2UnNOcFhScmlPT1ZkQUM0RXYzYjlJUUZsOFMzVEdhcEQx?=
 =?utf-8?B?anVsNVNVRmdQcXdSdW1WeE8wWFRYYkUwZzh0QTBYTlZaazlaZUhsa3pjWWRY?=
 =?utf-8?B?cXBhRDJZY0dScmR2aUVNOVVxRllVNWxsSnVlV3JDZDJXNmthWnRXSHIrRGs4?=
 =?utf-8?B?ZlU4LzUrbFltMVVBL1lPNGpwZ0hzZHZ5MnJnT0laWW9MdTlYd1liRHhWOW03?=
 =?utf-8?B?ZGIrK0IrTzlXejZHR1JSQ2JTZkk4N2NTSnNLcDgrMjlMOXBGOXNLbHpsbmp0?=
 =?utf-8?B?ZlNkTlFaWlE5ZlNEV3diVkRFVTJ2bW5RT0dtK0VFeFdOV3FtaG9vdllMcENQ?=
 =?utf-8?B?ZmsxRHFEV1kxRzdHbHgrMStWVEhpbE5BMi9tajdpRUdERDBXTkYvaGpQbnFE?=
 =?utf-8?B?Z3NocVBaeXFvcXkxdlFCUHM0aWE0ZVBMOUlhbnltMEdQdUd2UUszMHI1RGdU?=
 =?utf-8?B?cXYycHVyb2ZyVjBTakRLTkZFaitzUFZ1SUtYQm96VWJtazJmUGlZNGM2bEt2?=
 =?utf-8?B?bDRoNHNnWmtBZVNRYlhuZmZ3M3BVR3cwUUlzZkwvaEZMUkVhMzl0cXFFZ3BS?=
 =?utf-8?B?ZU1pUm5CZXhSWlJIQjBjclN2RVNxK3lsVTBKQmhEbVpETjlPUElxenk4ZmxS?=
 =?utf-8?B?alptMjNzTVhXWTJZRVNabWgxSnZoM211ZTZ5ZjBLK2N6NjRDYTlpLzhYSmNq?=
 =?utf-8?B?ampTUUJmL3BNSjd0VUZHdDk3Z1paYjRvalpLTjN1Zmh3NmMzeCt4NzNGT0VX?=
 =?utf-8?B?Rk9GVDNLUU9mdURnNmJuNFFpQ0NSdTI3dENUeUtlNzFvTjRXOVdQU3FNMmdo?=
 =?utf-8?B?ZytlTEZCNCtCMGxpRFVacy9idzZ4VVVQb1pvVEJ2bUxteUJkd0JTczBEaHJU?=
 =?utf-8?B?d3lPTTU0UkE1QjdNNENFeXlhWjk2NHFpaGdVbkh5VHFpa05Kang2UUcyV0dN?=
 =?utf-8?B?dFJaa0VmVXZuSTgrVkNBeENPSFR1R094YXFpNlErY2tVQzNzRlMzVmIvVHo5?=
 =?utf-8?B?aHN3eFlPR1JVU3NHOHFGR2p4YldRUzNSUVY0WkVHV0NaMDRrSzBPTmpvRjlE?=
 =?utf-8?B?Z2p3R2c5YWFPK2pnazZWWVk4ZDVoTTJJSEl6U0tCaUZsbDlTNERJYWdlaHAr?=
 =?utf-8?B?N2J3cE0vNE1WeGpMaUFJejArZGdsNmF2SVN2czFJUGUrNHFRL0dQUlZDUFVE?=
 =?utf-8?B?WjRXZFRMcy9qNjJ6YWQrNklRNHJPVU1waXdrNEJUOVlvTnJteE93TFY1WmVW?=
 =?utf-8?Q?xsCmy6ap6TWAA2Gthbshi1k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B407543A8C9C19498CEE8CFAB4B891FD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	VekMjK0NFDlMlG1uNV5Fjng2jiDEkzsukISG1E+mPBaz2B/JAbZC7UX9v0NBpcJED5VTbXGEnJb1w7npxphgo+C3eZNHNIuo9vuaONoyBKl73KdEE3CLElQjuMwkiHreIANIKm8Wp8j+ShQ30aZb+x+qhgeuuZIkSm4pUSJwVvUGB9bL7hIP/AB5yhuhBIywwleaMkmR+lCS4rUqpLpkOIXbBSk4Nga+wa1LDxvgxUS/ySlsa5IKuXntT/ttd3T8PWukOn/Er8Bh2agp0OKTdEEbI6vP8ErWTiRYR7O+oORenUOoDJFsA76RJl+0grnlsKg9GGtKiwJkn2aIwqdSH3jwbrrdgTxNLUHgh6FuPFW9VZD3L4HA5p+lakld7EGb0lVmsP1fhTXKntnC8Xar0mYb7GQkkOdidzRYSlt+3MrgZlaazzXGzrYoB8SxVdfAxaNQFGXIvdmZW6dNIEeXlNa1AAv+FCCGJnCTs91I3UTk73+8acdr6PLg+JIoMR0oUDDi7SXKbOX54lRu1nnQq6tX6Daz9SD+FAouYd8MjXJZH9L9scitIOwaCOS/qdoPeoJuhKLntenkfyxm/JbpjRDucFhARKvuEMsoAeuVrzM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e22b810-0b69-4a77-af9b-08dca5b3626e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2024 16:21:44.8722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v01VroMnk2YvkXQ4SUP5jYeC4c9JuBSrNtln85GZAqbO/0j2wxoNEtI6ZrcVEnvftqQ0BfQmDnLRkTaZ+Uoktx8OPvjP3pzdTQ+2ntFOrDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7467
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-16_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407160120
X-Proofpoint-GUID: KrBV4d14vli0OeeVePJsHTc_3SqobJtX
X-Proofpoint-ORIG-GUID: KrBV4d14vli0OeeVePJsHTc_3SqobJtX

DQoNCj4gT24gSnVsIDE1LCAyMDI0LCBhdCAzOjU24oCvUE0sIERhcnJpY2sgSi4gV29uZyA8ZGp3
b25nQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBKdWwgMTEsIDIwMjQgYXQgMTA6
NTg6MDJQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBKdWwg
OSwgMjAyNCwgYXQgMjowOOKAr1BNLCBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3Jn
PiB3cm90ZToNCj4+PiANCj4+PiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjoxMDoyM1BNIC0w
NzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+Pj4+IEFkZCB0aGlzIGhhbmRsZXIgdG8gYnJlYWsg
dGhlIGRlZnJhZyBiZXR0ZXIsIHNvIGl0IGhhcw0KPj4+PiAxLiB0aGUgc3RhdHMgcmVwb3J0aW5n
DQo+Pj4+IDIuIHJlbW92ZSB0aGUgdGVtcG9yYXJ5IGZpbGUNCj4+Pj4gDQo+Pj4+IFNpZ25lZC1v
ZmYtYnk6IFdlbmdhbmcgV2FuZyA8d2VuLmdhbmcud2FuZ0BvcmFjbGUuY29tPg0KPj4+PiAtLS0N
Cj4+Pj4gc3BhY2VtYW4vZGVmcmFnLmMgfCAxMSArKysrKysrKysrLQ0KPj4+PiAxIGZpbGUgY2hh
bmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4+PiANCj4+Pj4gZGlmZiAt
LWdpdCBhL3NwYWNlbWFuL2RlZnJhZy5jIGIvc3BhY2VtYW4vZGVmcmFnLmMNCj4+Pj4gaW5kZXgg
OWYxMWUzNmIuLjYxZTQ3YTQzIDEwMDY0NA0KPj4+PiAtLS0gYS9zcGFjZW1hbi9kZWZyYWcuYw0K
Pj4+PiArKysgYi9zcGFjZW1hbi9kZWZyYWcuYw0KPj4+PiBAQCAtMjk3LDYgKzI5NywxMyBAQCBn
ZXRfdGltZV9kZWx0YV91cyhzdHJ1Y3QgdGltZXZhbCAqcHJlX3RpbWUsIHN0cnVjdCB0aW1ldmFs
ICpjdXJfdGltZSkNCj4+Pj4gcmV0dXJuIHVzOw0KPj4+PiB9DQo+Pj4+IA0KPj4+PiArc3RhdGlj
IHZvbGF0aWxlIGJvb2wgdXNlZEtpbGxlZCA9IGZhbHNlOw0KPj4+PiArdm9pZCBkZWZyYWdfc2ln
aW50X2hhbmRsZXIoaW50IGR1bW15KQ0KPj4+PiArew0KPj4+PiArIHVzZWRLaWxsZWQgPSB0cnVl
Ow0KPj4+IA0KPj4+IE5vdCBzdXJlIHdoeSBzb21lIG9mIHRoZXNlIHZhcmlhYmxlcyBhcmUgY2Ft
ZWxDYXNlIGFuZCBvdGhlcnMgbm90Lg0KPj4+IE9yIHdoeSB0aGlzIGdsb2JhbCB2YXJpYWJsZSBk
b2Vzbid0IGhhdmUgYSBnXyBwcmVmaXggbGlrZSB0aGUgb3RoZXJzPw0KPj4+IA0KPj4gDQo+PiBZ
ZXAsIHdpbGwgY2hhbmdlIGl0IHRvIGdfdXNlcl9raWxsZWQuDQo+PiANCj4+Pj4gKyBwcmludGYo
IlBsZWFzZSB3YWl0IHVudGlsIGN1cnJlbnQgc2VnbWVudCBpcyBkZWZyYWdtZW50ZWRcbiIpOw0K
Pj4+IA0KPj4+IElzIGl0IGFjdHVhbGx5IHNhZmUgdG8gY2FsbCBwcmludGYgZnJvbSBhIHNpZ25h
bCBoYW5kbGVyPyAgSGFuZGxlcnMgbXVzdA0KPj4+IGJlIHZlcnkgY2FyZWZ1bCBhYm91dCB3aGF0
IHRoZXkgY2FsbCAtLSByZWdyZVNTSGlvbiB3YXMgYSByZXN1bHQgb2YNCj4+PiBvcGVuc3NoIG5v
dCBnZXR0aW5nIHRoaXMgcmlnaHQuDQo+Pj4gDQo+Pj4gKEdyYW50ZWQgc3BhY2VtYW4gaXNuJ3Qg
YXMgY3JpdGljYWwuLi4pDQo+Pj4gDQo+PiANCj4+IEFzIHRoZSBpb2N0bCBvZiBVTlNIQVJFIHRh
a2VzIHRpbWUsIHNvIHRoZSBwcm9jZXNzIHdvdWxkIHJlYWxseSBzdG9wIGEgd2hpbGUNCj4+IEFm
dGVyIHVzZXLigJlzIGtpbC4gVGhlIG1lc3NhZ2UgaXMgdXNlZCBhcyBhIHF1aWNrIHJlc3BvbnNl
IHRvIHVzZXIuIEl04oCZcyBub3QgYWN0dWFsbHkNCj4+IEhhcyBhbnkgZnVuY3Rpb25hbGl0eS4g
SWYgaXTigJlzIG5vdCBzYWZlLCB3ZSBjYW4gcmVtb3ZlIHRoZSBtZXNzYWdlLg0KPiANCj4gJCBt
YW4gc2lnbmFsLXNhZmV0eQ0KDQpZZXAsIHdpbGwgcmVtb3ZlIHRoZSBwcmludC4NCg0KVGhhbmtz
LA0KV2VuZ2FuZw0KDQo=
