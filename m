Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FE03C2F
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 07:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749108269; cv=fail; b=YBkP73fxsv5ZLAhyM8arBvfxw6mFVRvmt7mdQFyIR/wo9QmcbkH6VvyF/uIxFOtX9XV/7Dvn6V66oJcuwD7lSFrL/9yc9AIUP1AlATyAu4EsSVCCj6XmW6lFvZZtWxsLBdj1RfygqNAmFEra8cpu5DPCuCQOJWOYSDIjuzwAWYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749108269; c=relaxed/simple;
	bh=8EpYG2uLQqrlYW1yRWlmwn0Dt4Gwb8f43GbHgcg+kaA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bB8S1eLHqeoX7sZrPBmXoJK64Ak2qJ0vKAfUqifPen8Nbd68AXNtpJi8/pwiTr8Eh1NrdJsjEKRSQIwRhU3VnA5mWHv3a5vTdkxx4LRknB8W0zeUTzhE0sW++NrGOm1k361ggN/+5wqxyzetu5dsIxB3bWXtqyGCa0p77l7Xy+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ITpr5Tdx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YBeQtdvn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ITpr5Tdx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YBeQtdvn"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5554vbQ1030960;
	Thu, 5 Jun 2025 07:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=//GR4v8a1Ut8NuJTY9NJsqDhiK8zG25jaJoBM5okANQ=; b=
	ITpr5Tdx0UiOJEQdjJW4E0nPfkZ4xtIcM/3yx7VTcqfufEXFh72Rl9Aze1yUG4q/
	et48UYH6Fz+lidN5+dawx98fjES6CNEM5Qic31DIrREnnpkLDz77EmotGs2iONsa
	uTLluCz1OmxGG2DsSaU+E2qbEL8apS/cwi+2EK1IjQL67vDEwm3AOp7/VIbsOor5
	BIaX+dWMxf3Nbsh2cIiluIGrsOnyR82isujkiNKGlfRznWews9zppY5xLogpU/yP
	VON8ZN8D35r1CfvMfETke5A0bAUR8gjVSPwr7eRX6pWKATJ63ZB6ibcHfpJ7mUvI
	Y8E13M+0AV3/YAajj0Q92g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8cwkec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 07:24:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55561alA016186;
	Thu, 5 Jun 2025 07:24:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7br16f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 07:24:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J7+5J8RhDROyCspMzaBd+hX5by3wbs+m/Wf+N0H//xhlA64n9fK8E9EErhQRU3a76fG+JVgktsINSYQF2NtjjT9bJaEJ1hPzNTgWeGizIj1BgHyo8fgKM5kGZQEyMJqVWg3t3OR84LBAH1cqeCT1jgDjBOZeBRRszD/EEQ1YgOhxirOD/cPNIjZazl0hIHSI6K3vOxmPzIeH8ba3w9V3pFNn2y5vMNpOtVsrhZ5oCKQUOd2s6VVUAFJ5kiJjd6aZPDc2vw679TZfwy7pFZ3xseCxtIEatZSGF479C2HaH/LfuYY3gVYuUmXSxRCEOSeu9YynSYFq7u4X6I+ee2yZXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//GR4v8a1Ut8NuJTY9NJsqDhiK8zG25jaJoBM5okANQ=;
 b=XQPKoQbHvb56wmL3rzLX7eOaZH6cCW6HQv20ZG/NCL2uMd5ELmudUmSmYIpDNRBzgRrinQsasZTEPiYrJ5XW22HxgMnTJ+GNJBPOdySO3Z95xdN2L2Uk+xv9X37brqbpbMtj+71iQ1ul4H7zWnljge6u9bfdX2qmtL1+CcuoOu25DNzVh6oZ1CrWLkWK5HCdGY4w9bkFW8Dvj0uGD0VLI6GKDTKz73JpaCB9KAzkWh1Ye+nP1R93WdiFie+kin2ZV8/g8sC/7Lz1GVAd51JNTTEhHhd83CER/BDGep7Cmvsh2jmx6+RRTxbYnoQBZu4mBm1s20SNofyNe9yfzidmVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//GR4v8a1Ut8NuJTY9NJsqDhiK8zG25jaJoBM5okANQ=;
 b=YBeQtdvn1/w7+6yle0yPJg1jFYxqoaV+bIn7uFyypXE3Dlvckc8202hqydkkkiQY9Qdc4Zlo6rvIPiqQlbbd7qA2QifC46Fl6ZaD2HIjozPnvpp2hANBF1k5KhpTZVES+EpZc15fEYMiSw7SxTaWxYJEYsABIaLTiMds/VLHNr8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS4PPF3689F8B17.namprd10.prod.outlook.com (2603:10b6:f:fc00::d12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.40; Thu, 5 Jun
 2025 07:24:17 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Thu, 5 Jun 2025
 07:24:17 +0000
Message-ID: <c6336414-7281-4b97-bbb0-a9fe5e25bf51@oracle.com>
Date: Thu, 5 Jun 2025 08:24:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] xfs: use xfs_readonly_buftarg in xfs_remount_rw
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, Hans Holmberg <Hans.Holmberg@wdc.com>
References: <20250605061638.993152-1-hch@lst.de>
 <20250605061638.993152-4-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250605061638.993152-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0256.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS4PPF3689F8B17:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cabf06e-f4ac-4d3f-d5ae-08dda401fb13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VFZQOFlPeEsreTZidUhrMnpsWUdxdXVSbEpjQ25VakNGdnRqdUxpQTY2Wm1P?=
 =?utf-8?B?VDV4dmVocGpocHZ5VFFqL2hMcGg1VDFYR0FHU2gwTlZZTUY4QUZaak11SXJP?=
 =?utf-8?B?YmhWbFZ3cmZDMU9PcEVNMUEyK2dNSnBPS2ZuYXlVdHNxLzUybEhFOG53WlJq?=
 =?utf-8?B?WGFpalRIYVh2TGROZjlNcnlUTzJ5b0JnM2dXZk1YczFCU2FXbTZlZ1lIOFVF?=
 =?utf-8?B?MEx5YXcydTYwOTc4dTdBNTNrRkJVMHJTVWtPdVc5eG5DNFdwNGQ5Mk41WXNm?=
 =?utf-8?B?ZGZqTVFWdFk4ajFJUk9TaVpybjIxcVBVaTBYSTNGWm1QV2s0eGRzdmpNd0h5?=
 =?utf-8?B?Zkd6QlI2aEdNNlBwT09La3dlaGxiRDVyQ3lwL2xTc05tYW10SkJpNlpKM3ZF?=
 =?utf-8?B?ZXpNeUxXS0lTMHV6bFh3UG1XNnJiK1dMdFZNU2hVbnpld0hTajZnVTB2UzZs?=
 =?utf-8?B?ZTVmTWJqSFZBYXNJMTdwVzdHS2sxcnRBbEZiQTJCVE9aN01udzEzeU1PV1Zk?=
 =?utf-8?B?ZUY1ai9QNzcreUxNWGZtV3p6UnpidzRzS2lZejN0WTZyRGoyU2lXcTRzLzlG?=
 =?utf-8?B?WE5uYXUzeSs3RFlrZ3R5MVUrenRETUNWVDhXRGgxdHhtdE9KOWFReHR0eHhq?=
 =?utf-8?B?NGJoZkcyclNVaFI5WEJ0UmtjQWN2dXRSdUtONVo3SzY4c0x0eGpNMVdDZCsx?=
 =?utf-8?B?NGI1KzEyNmhaOHZyS2FDT2VMZ2pjTE52eXpKNjJKeVZ5enhlOEJDNUF1UjA2?=
 =?utf-8?B?czdUdWs1QkE0ZHlndDRqZGZIdnRxRHhTTVFxZjdNbWhQZ3ZaWVdkSUlPMEMy?=
 =?utf-8?B?bVoreGUxbS9GVXJGR2VGR09NWnhGNWNCT3RpdFY2TE1nWjNZSlNFRkVFWWVo?=
 =?utf-8?B?dlUzK092ZGgvWEFxNFpwWkJtSUtVczJPcnc0QXY0UERyOEFLRkYwc2QrQ2pk?=
 =?utf-8?B?SU5WNVdzZUYxaEV2WGluK0dhSWRGVmI2ZHRsaThnNTZmWUNJaEVvZU5VSTVj?=
 =?utf-8?B?TDJqNWJ3L1hlRTY3RnM2anA0L3BVQWo2OTNjand3Z0dNaDJwZXFYTEdZL3Q3?=
 =?utf-8?B?RkF6bDVieWFRc05YdVlCMjRROWxKM1pvK3VUK0U0cTZKUDZPNTduckh3WWt3?=
 =?utf-8?B?UkwveUdXak0ydlZ0bkVXVFNWMnRNR1dyNUM5YlhCT01LdUNsOE5sSzZMcTcy?=
 =?utf-8?B?aHUySWhpc1lIRjh6eUprMVdmWnNSV1pvekZRSVE0c3MzN1NBU0g3THZpVk5B?=
 =?utf-8?B?OExkQ2NOZUVJSEQ3T3p0bDh2VU54ZHFOL1lPS2N0UDBXRzVaemJGZDFxQXJ0?=
 =?utf-8?B?YTVSeUpDU3U2WExUWWNrUDNYbnVsL1ZxTFlBWUN5c24xeDVaY2dsaWNQNTJP?=
 =?utf-8?B?alpRMUZVTUlNVWdZdmswa21FWk1xS0NrOEV3Y1phaHR3d1ZaMjZiU0diTHFV?=
 =?utf-8?B?anV0S2RWdVJSaEZXUFJkL0xaOWIrMUNvdHEvc0RGUlA3RWNwY3UvUENkRk1B?=
 =?utf-8?B?dDhKVHFZTEdySm1CbXM3bHU5MjJLWCt6QVdWWWo3ZXRlZnduRngyTXlORVF1?=
 =?utf-8?B?QWFxUkp1Z1UraktSS1M3dUNaK2plUFVyMFl1NE1aNmFiZmJ4a2VuYVkzb285?=
 =?utf-8?B?UEhWYjV0V2ZyNk05TWhCd1duUi91S0ZxQ2VLMWVPbk5SWmVFZDhXR292TFYw?=
 =?utf-8?B?blFqVm9HYVY3VFpuUHZ4d056TjVGZjJHcDIzdFJtRldPNVJEMGpxa2pmL1VJ?=
 =?utf-8?B?a3o3S1AyYnJ4cHRCRE5DMlRuNG03Y1hJU2lJRFZiN3V6Zk40VGdwRzRhTUE2?=
 =?utf-8?B?UlliM2NnMjVPUjFCdkhLUXgyREJsaVRXUS9KaGlLWEpVWnRJemRjRkFLQ2V5?=
 =?utf-8?B?SnhuQzJoZldWcjB3bFVvazZhZG9kY1lNSy9HbStUNDBzRk5wZ3ZHTmlwRFRs?=
 =?utf-8?Q?FpiEE4ltg7o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qkg0MGVOeXZCTWgwaUtoQXVDZHVOM0MvcVE1ektZV3FOZkc1SFQzcVhTZHlC?=
 =?utf-8?B?SE1xa1QweWFHTXI3QWc5elJmV3NmMEM2dFZuWUhYcEZVZldIMjZxNkNZZXNM?=
 =?utf-8?B?cFBKTFh5RFViZG1rT0QvZEFWdzBNQ0hwaTRZUjA2QXdVWFlyWkJvNWtDL0Np?=
 =?utf-8?B?RitlOWZwMkpkclBXblJmNUd4NWhpdlBmbkVRZklGMS9CZUhMbG90Sk5xZG44?=
 =?utf-8?B?OWpZdFVTcDI5OGx6SGJDL1BNUEhVM2JhWWNKWFFPRjNPNkdoMk1mRkdtczc3?=
 =?utf-8?B?TnFIbG8xVjVhVUszZFZ5WWpwUkVlMXpTV3I1aktGNElIZ1NoNG1hVGNQWlBR?=
 =?utf-8?B?M3pTd2RqVGNKRmZBYjAyTXliSStiVWdqaXUyeUpHdXhmMmMxSHora2lIanVt?=
 =?utf-8?B?TWpoOVhYVUtwRXAyM2dGNDY2aFhaRjN6VjRYdkdObktDWXNHK1kvSzlSMENj?=
 =?utf-8?B?bzNCR0dIUVJ2bUZpMzVrYkkycTByaU9CWDR6bDRrTDgyMkVVMndRcEw2S0VJ?=
 =?utf-8?B?ME92cVorOU9zc0ZzdFNaa3ZtRVBzRWlESTg3aC92YWtsTGhQak0xRHYwSkxk?=
 =?utf-8?B?QXZtNjJDWEsxQ0poTG1nU29abzYreEsxckFSQkV0dFd2SkpnaE5ndmdrN2ov?=
 =?utf-8?B?OVNobGFKaWNlSkYrS1JiTVF0dkJEaGZJcDJjRVY2SkFjOVFlSjJOc2FUSXlD?=
 =?utf-8?B?a2FNUmt2OHFBN21BQ3lBTWVaT2FHUTR4ZWZaUzk2WFJqb0V1REJPeFdBWSty?=
 =?utf-8?B?OTZYemcyZVBvWlV2aGpEMjJ4eU9WQUpsMVYvQUNQV2YxM2Y4elY2SHY5SkFj?=
 =?utf-8?B?WmhqdTNFR1dDVDhqWmF5TW9UTTQ3UEtTRlZuWkN6bng3bFJiR1E5aHVIUVFK?=
 =?utf-8?B?Y3lJeml5TnluTFBvcU53RnA0Yk9NK2dRSGNFTGZ3TUVrUjdGUHlXR3c5dk5y?=
 =?utf-8?B?Q0hVakg1SHhIUUsxL1VmalBFTlkvMTNWdHkxMVdHRnc5a1ZuN01mZzFiNkpL?=
 =?utf-8?B?bU5FVDhUT3B0aGNENVozazc0SmlDbzJDVFVMTXZNM2JKT0RyNm1KWWh0dEhF?=
 =?utf-8?B?YWlpRms0TVVBWmU3MWhiRzY4eVIxc2wxV3RRRG5jamdZUTFOYWNlNXVUL3lC?=
 =?utf-8?B?bWlONU13ako4Zm1HS08rTFduOVFaTlZXOTlrWlczNkFLdEMyQTJYb1NLYkZm?=
 =?utf-8?B?NDhSSEUxYUJOMDBkdm9ROURQcXpLdFNzMUtoL2FMMEJiVU85LzZsbi9lNkxE?=
 =?utf-8?B?ZUhNSXB6WE9vS2VaZDM5SjRacWJTbFhaMWErak4vWGZCM0Y0TkhGcmtCMWUr?=
 =?utf-8?B?TzZtTWRvR2RzOWlHYWM3SGI1cW5EanA1bGR0dktVYkVSTWVHT0h6VVFkOS9Y?=
 =?utf-8?B?MC9TSUV1R29mNVJIcTBXclQwVkxMZjBFeHN3Rno4U3dDalJCQjFqY1YzMlB4?=
 =?utf-8?B?cE9Td0dBdHhFNDEwRUtQaGc3ZDJrSERhaFhxZU5lWnZhSVFZb1lYZXkrVmVG?=
 =?utf-8?B?cUJkQlFFc1Z2T1RjT1BPWnNFL29GVHlmNHR2OG55YjJpTUh6SjVqbTF6NnVl?=
 =?utf-8?B?ZzFOM1VMMTFVWnJuYldnV3BWV3lmVXplNXllR2NpNzJ0Rnc0M0ZhVWtQcHRU?=
 =?utf-8?B?U2gxS3VGTDRpVVlBNnRTakRhTkZjOWlIMUNXYzJSMjg4THhLb2czN21TMW55?=
 =?utf-8?B?VTBESS9CSEpqc1VnNVk3dEszdysydlFIRGV0TUJhVHdWa2k4eGxuQy9QUStY?=
 =?utf-8?B?SjhtZzc0SENTRG1Hd2tkSTVrV0w2S2R0em10RmQ2UWJXYkc3V0tldDlVRU5M?=
 =?utf-8?B?c3pFUUgxcnRQcjRHeG5ZTytKOEJ2SGFGTFVZMUhTU1ZiamFvU3dCNGRxN1d4?=
 =?utf-8?B?N1NYeUN1bkN6VXNJc0oxR3l0alNZazN2c1YrQklzSmx6UDY2UzJGQ0QrQXJ1?=
 =?utf-8?B?ZktFOXB3RGZrMVFPYm8vbmlSUVc0QTBvMzVyWUlRRExSOHhYQlZsalZVY3Ny?=
 =?utf-8?B?cUFVSG5CMWNDTFExY2I4VUlXMlFrbCtPTGY4Tmx3VkhETzIxMjZMZFlFZWVn?=
 =?utf-8?B?YldFNCtuK1BWdlVWOTZHSmR1Mm5naDgwVllNbDQ0enR2UFc3UStNM21mWEFw?=
 =?utf-8?B?N21YUWRkQTVPaWxGZmZmSFI4OVl3Y2JkK0plTEhsT1JJdTg4UmpTRU4waXpL?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JzzrGNmgDKr7P0FZBbvHsJObuqCBgvbFZCqUkbeqs/+8IJ9hGPSMpDmSTfSH2KnwNlu7lv7AQjCHlEU+oxBpcPW4gSedKJrfNtDgI4Dz161z9acbTHub4Dmm1PQ3tYIjqDhB9kJVO+oPIbcA+wozI3ACci6O4jsqPXcLJF8KgL7oeV8ORlVPDZMMJFEbI3h/B8GRh7OoiubunyNRbFPC47wPJubQjUfZVvWtU5WGgpZfLqJFB3E62jRPbWSJl9WPucOytdjQW6qVT6vXAv/6agsnb03trtLmsb0X8//wnz7yECs8zgutbOn7AiPUFU7oRmGHPJD3JZ64oTJcrtyRXxNZ0QECNF8RnYBuAy43hckUTAAheAj7xnf4wKiroGvv1rRh+CnrvklpIAEDTIE1zJkq0VJ6tDTf1kMlIVPDQLUD2V0u6kTZkeaTacIle7yr/EDLVerbNLpKxbAz4A6EKwXSnq+GN0pGI5jNGEf9QY5TZHEr4hlGLX0OlUA/geY9Wc7HWeyFyyS1sLLjfHZVGNyukbss6DP63Vr9b8CrXEI8/by16I8Ox/zpdafFKk2CwYqA54Gsccc1wHey+roJBkD5BsBx0rpXHGaxYMdcyp0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cabf06e-f4ac-4d3f-d5ae-08dda401fb13
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 07:24:17.6400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ipLOYh6WRIYs/29j05OtO2gIj/R1LbTVXvRDnBaJ33wE07JSgjVmiSsu9KE3I4NMsYizQiOJbaWsrAj8V2gAww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF3689F8B17
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_02,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050064
X-Proofpoint-GUID: _O-ylNW6Ew8QrghP6CLrcnAVDQkO9dyF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDA2NCBTYWx0ZWRfX8p6+kQ2zNRUl wQp4pnL1NDvbCNoFVhnHLFM715hvAySKpMCT7zFDuNY1Yzc8VCsX2tSFaDSDwJU37wBdmHmWdXt 97ul8yIv64gzuWm30W5mq+kV4jHweNN8ksj86SULN8B8KcxTy7M2c/YjLlDKFDgiQjt5Zh4sRAK
 vmWRRoJKmH37noKc9NKe5JMKGSsmfm5D61WfMn7uO6FzweP9KPIQZLIkRPPIGKh88voSZm0GQYh ftBHxDjHn9RBBbEBz8V1uEYEvoNLFEi7Jh5DJt4pCvyrANd4FP2Ibi8P9zdq3Ic1QK7CUyuyuvz 8X0GTUWCq3+sL+z/6jEpn7HuGQcbYrVHuPRqvZNOzeOGwATfA7K8MqZufHVVHkVdUjh4LmWcFbj
 NTnCL2h+7a4FmZa4xzj/oF7vZhb11Bd5hFXyKJ1buMqwdiltqUxoQnZTpivVwebQfaWxObjm
X-Authority-Analysis: v=2.4 cv=KaTSsRYD c=1 sm=1 tr=0 ts=68414625 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=qkkKjFw5gJbqY1XEd9gA:9 a=QEXdDO2ut3YA:10 a=UxLD5KG5Eu0A:10 a=oOt8LVSLndi7zlzjSLJE:22
X-Proofpoint-ORIG-GUID: _O-ylNW6Ew8QrghP6CLrcnAVDQkO9dyF

On 05/06/2025 07:16, Christoph Hellwig wrote:
> Use xfs_readonly_buftarg instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>
