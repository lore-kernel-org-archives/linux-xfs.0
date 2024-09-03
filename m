Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090E841C65
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 20:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725395361; cv=fail; b=NjI0HAYI2Zi9GPxokr0REEsW7b7tpYYBimjMhuviDTFh6dadyEzuOuDzN/sUF3qz2dtFDQDaW7joZyiUy1yZX++fpiXsSwD8CeQrEFmo5jVADUMn3oOctlUwK0OcrzAZep2mTkVTUGCbJ48N6Sxd4Cr+9G9tx242VRtipCjTuVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725395361; c=relaxed/simple;
	bh=yObZ5yvI+O3LakJuSKTyYPbbdM66OYvsq94qWtLV0lY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TisDjixCID6O8WOBK0nlgtZ3X2nDKbySZnvgsMLUca8teU6eHc5xQ4YWaEKOqpNy80/NPsEon112TNkhYqnZ1SgYBiwOZsEEVlBtHyCvL2MMl7ToBFmNcrhMcgC51G7UZ0AThbNxgr51B5qmHvBwQEFVkHcbZvpNp6Dg3x4IejQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SOpot93V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I5OCYmjc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SOpot93V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I5OCYmjc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 483K4LBU011803;
	Tue, 3 Sep 2024 20:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=94Ncv72p5D21s2g/tjJtT/Qm0K4NU59qZYtmkduRIOU=; b=
	SOpot93VacoRv45+bWYG1y+7nd1PyiC2jLncq2nxPL4LVVJ4vwmKv7a6at1Oaedl
	CJVebTF1fiuWU8nslS+wjTk/zRLkU9X3i+5LDRSoBRQft4WeNdrluY+oj2hJRRGF
	9FeCy4Yyfg+iPgJijdoN0NRe/+iQ33ksjy5soQLilbVx0RK0H/4LlyBTOh/hFRd+
	fHzwD3U9fCiOmKKItjgi4s9MxBjF/xDlQSI0ARjSKYeAdMHgWz5vEmROayKNVC8q
	CZ85bEc8lzapBZAVsqZBM7Ia2/LR44i31un2vrtZ/jOop2tUvKH/DMBqs8H038Bz
	CNf3JhhIVdsPOdfSdj9ssQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41dw51sv13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 20:29:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 483JYAm4023553;
	Tue, 3 Sep 2024 20:29:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41bsm8puqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 20:29:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mIiCjC+F//OfccJ2bJUFLpufp1W2sC2rKczfXdPdtjjIEaqPwwu7+iMNAVEQzEFpzcly8z63YqA5Ns6OfkY6aLTkGlzzTKhd5vr9BUauN7qsDPQVVMdSr0tHWvinj5paiJN0b5Mn3pWmuKsLOAKBMN/yO41qmj3h87pscDNeQBbPhL7u7c5iv/iXckKHYPcqLHaV0xda9SR4MZFeasBpVE93VSQbxBr+gcV+nnRgrDwKd85T7xb9HmEkGMGABBPDlfVNC6ZHDm7PAA/A+/qsvxNe+5qFYR5buXOxPzMbJzRjrqFl7xy4cqbAoIH6Z/PEvrK4KT/9hQ6Zx6vyJqC1JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94Ncv72p5D21s2g/tjJtT/Qm0K4NU59qZYtmkduRIOU=;
 b=zRD9abMGr/KdEVtoOTjUWjOv+4A/lpmnU7fjr28QcPTgaET4nbD7khS8nHnVbMqfYqFbh4/RvOQvg1ckmHnE1o0ivh6bPvu3bjZxhT6Wptd8312GxVvvieeU9uik0q9YQS/nGzQceDslTkzCqgNI5mp78R8hrkX5PN9QWoibB3sQOES/s0XU2Muf8ZCFvyZqqaSG9/DsqNc/b7UYO242VI4mXzvUw8fydJNSM+3uoCfFfv96L5yeCcnaTAN3dxXYL89ibyY7sX0t/9usDX8ph9+3gZd1xxvwXlcqdbaVre58qNHJeIryHFEseq/XRTrunwv4+UgVAN/faI5abAXexA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94Ncv72p5D21s2g/tjJtT/Qm0K4NU59qZYtmkduRIOU=;
 b=I5OCYmjciDaam7O9kg/gvmjNUTwygBTZQTdvzfomltDEo3y1MJ/rXl38lXSo9JG388B07q2Ckzc+1nPIy95+txasYdLqlJvMZ67o6JUq5hMRqlvRyYnh8AGssi1z0hBDvuq28/Jik891sW3R0Bky8juCrhXmzjkiOG3SKunVA2E=
Received: from SA1PR10MB7586.namprd10.prod.outlook.com (2603:10b6:806:379::6)
 by LV8PR10MB7965.namprd10.prod.outlook.com (2603:10b6:408:204::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.12; Tue, 3 Sep
 2024 20:29:09 +0000
Received: from SA1PR10MB7586.namprd10.prod.outlook.com
 ([fe80::808a:1720:2702:e26d]) by SA1PR10MB7586.namprd10.prod.outlook.com
 ([fe80::808a:1720:2702:e26d%4]) with mapi id 15.20.7918.020; Tue, 3 Sep 2024
 20:29:09 +0000
Message-ID: <ba7a3e5d-643f-4e8a-ba9d-5d25fb4f2d47@oracle.com>
Date: Tue, 3 Sep 2024 15:29:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH] xfsdump: Remove dead code from
 restore_extent().
To: Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org, djwong@kernel.org, sandeen@sandeen.net
References: <20240903174140.268614-2-bodonnel@redhat.com>
Content-Language: en-US
From: mark.tinguely@oracle.com
In-Reply-To: <20240903174140.268614-2-bodonnel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0463.namprd03.prod.outlook.com
 (2603:10b6:408:139::18) To SA1PR10MB7586.namprd10.prod.outlook.com
 (2603:10b6:806:379::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB7586:EE_|LV8PR10MB7965:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b13e72-4c92-416b-19f3-08dccc5710c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2JBb2dlMHVLNEh2SkErWjIzSUJNbFNwUkZ2SFJDdTIwMWtmaXVOM2gwdlFR?=
 =?utf-8?B?bVNxQlRkVXRmNVhFUVl4MW00NUFqUFRTRk5Zdms0TmFtYWUyUFNIY016cmZ4?=
 =?utf-8?B?MWp0M0FhdVk2VlR3blJkcDZMR2xJakZPUS8venRIMitIOXUxWkMvVkZBQTZn?=
 =?utf-8?B?dnFxdnFabEhaaTlpWFF3U2FvN3FlT0FjVHZBbkxHVjJySlNCNjJPMTFZR21M?=
 =?utf-8?B?andZMzBkaFVpUVVuVEM0alhQd1p6cFR4YWRGM1lpRFY4SlpWcmRhY1NWU0Ez?=
 =?utf-8?B?UlFCNVI5MXkwUGdIU05neFFKS2NqSXNDQmlyYllUaEZBYWtuNExGRG9ycUNZ?=
 =?utf-8?B?YmlRbzlqRWg4V25laXQ0T3lrWFZGZURaVXRHSzdKWFFaRXBRanZzYzdQanl2?=
 =?utf-8?B?ME94dVV2QXU4cE50RG93a2xSQjVVakZpVFF3KzB5SFRVY1RrNWpTRnF0Vitx?=
 =?utf-8?B?NW85NFdwM1pidzA5NVV3ZlJBcVFwUlNydmtoQmVxemtkckdBY2lpMWUzR1d5?=
 =?utf-8?B?V0IrNWl1ZERqWjdKSmhCZnF0KzJwKzJvNTdMVzgvSFdiTGdxbFpaU0M5dXV2?=
 =?utf-8?B?eVhyQW8wNi9STFBMWk9XNDZPUFpQZG5CeWU4dVpLZ1NTR0NZQkZvN1lJY1lU?=
 =?utf-8?B?ckFsdVVSMFFwdnZNd2lJcjVGejVZTHl0bkNITFBXZEpOQTRRby92aGpxRWc2?=
 =?utf-8?B?aHRGS1hhbmF2aTMzWDFOcUZnaE1sc2w5eXMwTFkzZ2kxSlA1bzcrd1ZxTUhE?=
 =?utf-8?B?OFB5RWo2RE54YmJCZlN0TjVTWG5zc0Q4a3ZMV1B0cmdnZXk5UE0vTEtNR0o1?=
 =?utf-8?B?RXN0RUJ6bk1ZN3dJd1U3L29wU0ExQU9kcG1mQ1hQT2JVZ3JYK0J1MDl3VUVy?=
 =?utf-8?B?TnZRTUptVHVhSkV1S0tTNlIxNnQzUzVKRm5zcmhXQjJ5WWtoMmtlVEl1TS9W?=
 =?utf-8?B?aW1uT0Vwbi9zMCtndy8yTzY1enMvNmZQTzhtaFZKWEp5THkvSEIxNUp6cWI1?=
 =?utf-8?B?U2QydWR1YzhQNG5uMDdjZ2lFTzc1ZGpUK0VDUEhRRW1FUTNkaUQ1RGNGdU9q?=
 =?utf-8?B?cHRsVWRvZTdYQXNOckVLRmxTdDBsTGZmYXVOUVpNM0N1V01tQU1jNDRHTm1C?=
 =?utf-8?B?clhxZ2JWS0l4L0xqbXA0bkxSeU43N2xNdE9wNzNmOXhpYkszQ0FvY3J4SXZC?=
 =?utf-8?B?RTg0andJZkdPOXNhSXVSc1hIcDQxM3B0Tkk0My9pL1BLRW96YktDZXQ4ckly?=
 =?utf-8?B?TjBYdUFkVW1ia2JLOWJiQVp4eFBqMzlCVHp6d0YxTUtDcXNHeGUvQXA3TXBn?=
 =?utf-8?B?bWloN01HU1U5TkxjOU5tenROaEJJc3QvVzNsT2EwbXgwcWZGaHBIRFBjWWky?=
 =?utf-8?B?blR3eVkyQnA2dDVyelpjKzVzOC9qR0dUalM4VXpuK1BENnptaTQrYTYybzBk?=
 =?utf-8?B?bFVtS3lsRXFudyswd2hWejAyMWFmK0lCL2QyelNxejAzdDhmNURWQk44bW1D?=
 =?utf-8?B?cm9RRGE0V2dOOHVSOHVUcnJEOExjaDBHMklXdVZRUXVyOFFLZE0zMFdFdnpE?=
 =?utf-8?B?QkxRV2ZQOG53TXl1OFNWQTNDNVBQT1owK09XWWxtNkxVUTdoQSs3bkFFUmU3?=
 =?utf-8?B?MHEzUG1WMDROVGtaZFJQV1VITm9seWlmamRNdmdvQjlrU3ZEc0tkRDlzU3Z3?=
 =?utf-8?B?NEh0QWsvc3Eyc1krMTBRU2YwMVE0cXZJNjczd1ZZKzBNN1k5MHJMbytlcUtt?=
 =?utf-8?B?eEJWSThtUFA1Qk9yUHJDRWMwM3k2a012NlV5dzJCc05rZ1liZEdIRlNPMThR?=
 =?utf-8?B?M0Z3MlZ2S2oxZzdYWVhoQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB7586.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUU3cFdGdTlaWkNOL2Q1cUpxRTZGWTJYbWhGWlV6dVViWlZKSnB6SDJzWjdI?=
 =?utf-8?B?Q1FXcVdiR1phNUZxbDAyTkpieUNLcGM2OG9GaHVZbjdUSjB4ZUJjV2NTeDR5?=
 =?utf-8?B?d0RpNzM3SGRwVzdtVkNKelVMZjI1dE1WMnlsdjMxN1ZCVzhDSitGNlhrdVdq?=
 =?utf-8?B?ZUFzclFvWVNicGJaajR5eXd1dmlDOC83UlNCSDlwdWFNaW80a09XYzMrdVAx?=
 =?utf-8?B?TGtkSnlSUFRJc2xZUGFnVWdGcEYraWQzMFRzNlFJRC90azllMGx3RTRGTWRO?=
 =?utf-8?B?R0NjV2VTRVNXcGdQRTcxR09UcGhYMGNtODZHQW02Wm5yZXhKcnJ1WEZXR1VG?=
 =?utf-8?B?VEwvSWlGOGE5RGc3VkhudmJYMU4zMFpDZU10cVdLQkwzMHJPUXZTTXdHZGNJ?=
 =?utf-8?B?K2ZCeXh3QlM5RzdLWDByTlJoeUNQSHpYQ2dIMWFqcVBKYnZ1TTM4MisyelFL?=
 =?utf-8?B?cWdUOUFhRkpqQnlnUmRDRVkwaFo3NnpraEhzbnFVNnJCQlJlQVQyeC9Xa0NS?=
 =?utf-8?B?VExEOTJmNE05T3FUYnpSN0lDeEx2cDZhb0pNLzVTWHk1NUIxSk5yeFVMR1Rl?=
 =?utf-8?B?M1RxUXduclFOZXFHb21VblpSeFJlYUhocEZ0cmlmekVoRmNOWjdHREFXMndZ?=
 =?utf-8?B?SW9vd3NvQTdqem94TUcwU1RjTHZYS2hFQWpaMTZndXcyKzdKVlA4UVp2RkZj?=
 =?utf-8?B?Y3FPRW0rU1lZTENLbkhWM1l6bkRYZmRJRUNpdVo1bFJaTTBXLzZ5bEprUUln?=
 =?utf-8?B?WFRkVDFPazVqVmlqOWJDeHRUZmNXUlgxdnd0QVl1akxBYXltK3hEQXdVMGc4?=
 =?utf-8?B?MytjdUtMWG9zYkNEWnRZN0h1SmxQTjZKYm9CYldUdkpHbkI2VEI1ZVorUm55?=
 =?utf-8?B?dUMrREkreTFJMXVpeitDOFdDRlJYb0F6Tm1zeXJEZTVWWjBoLzM5YlRFTGdX?=
 =?utf-8?B?NVpWVHd4c3VHYmtZT21BWmVXaFE5Tjh5UUxaeThlYzROOXV0enRhdnNHbHNx?=
 =?utf-8?B?LzdGWTV5Umh2aEE1eHAvUjVUbC9qZElaM0Jqdkx0VnNVYTlnMkkyM1N5eGNl?=
 =?utf-8?B?RXlTOUpBVzVWZ3ZWa3Z2WVdRZHN4RGlrVmd3QkNtZUFVcVZuT0tDRnhhVmVK?=
 =?utf-8?B?WVhvRWNnYXBrU2h3TkpMM2ZTQzZWa3pOTFo4bHYxVDZCeXVSMkZyckF0Szh6?=
 =?utf-8?B?V0o2VlBUei9wVG4rdmFVa2RvMUN0Q3dYeXh2RmJ0ZVBLU2VwUmVlVk8zaVBi?=
 =?utf-8?B?U3RaYzROZ2l2TjRycncybmgzMzB2R0NqaDFBWUNDR0ZRNWNEdEc5SkdDZW04?=
 =?utf-8?B?SVNhdzhtV2s0Um5qYk44a1htbFoveHd0bmN2dzVIdkdaVnBBaEtDWVpUaEpV?=
 =?utf-8?B?U08ycEFURGNSWWZiWDg3K2RDWFJEeTBVREl1dE1OeHRxdnVhZTZxc2xBeVBv?=
 =?utf-8?B?UmVGcWJINFgxMmJTYXVvT092VU4rRTc2Vm9uS1QzWFFQT1k5MjZHRzl4WEpn?=
 =?utf-8?B?VFM0OW1WYTkxYkxkSXBFa2dIT1FpRE0vNXpZcVJpSlBLaXFWbTJMc0VaWEJG?=
 =?utf-8?B?Q2VyUDJpcFNHc0R4Zk1kbjEyelF0SXNISHNadGFVUEVLb0tQaUNKbk9uMHJC?=
 =?utf-8?B?MmFSMXVQcXgrS2hBSnp2eVhwSjdZUVRHVlRocEYvNEUyNzhSOFlCVE9MYTZr?=
 =?utf-8?B?dkZaY1pSU3lDQTdkMmRNUUZJL0FaT0tVQnREd3hjUUlNaldSRlBOVkFUekUr?=
 =?utf-8?B?T3hMSmtqNWN1SWZ1akNZK0lZYm1Ha1RaSmJwSEFGSVhJRHVzd3FHcXhTY0Jh?=
 =?utf-8?B?cFBZTXFGdHlSTEZqTmdGWUJBT3JKeFAvMkpYTjN5RjcrTXg0QlA1ZkVpaDRQ?=
 =?utf-8?B?bmxvZWNBZXpvdUFSVjZQTnNtSHNuZ051L1hBbVhNUzFRNnBrR2k1QjlFOVc0?=
 =?utf-8?B?RVJkN0RyZHVjand1WXVOTUdod2JNKy9sWUlHbHhrc0NydGxJRFYvWlczdVR2?=
 =?utf-8?B?OG1kZTd0Wkk1SlRGMEZoazR6bXlkMVpQM3pEL1BTR0kwVGhkRm1EQldPendH?=
 =?utf-8?B?UjlkZ1c5S3NmdldtRSs1MW1xMVFSTEJHSDNVTWsyMk1uZnBYOXBlbWRKcitF?=
 =?utf-8?B?RVJTS3dsRjBhTytQUDFvSTBwSVZtQS82TU1vT285dTBHMzFCVWZBc2NUQ0lj?=
 =?utf-8?B?Tnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	50m/e+WvhISzwsC0EhBQhmAyz0f9Vj6A8kRpi+TntJ/3LdGmY199DHKI717XUjIQUVwDKk+cXg8Vrgcgd8wj46HLVWIu4CQFJqe+3Xsplp+5wBUcxY1VCAdduJzofQAVqCTdBL7s704d/gPMwwngkuUENmBRLPQEhSjBxOD4+p5nBkfN+hEuA9QTxZN3B9Nh2h1EIFFo6INqV50oqZSCGGjoQEVv3AMEJE2BiMbILip8VNbxV3ZUDBUM/B+X2m/aM6ieZt1yQd3t6rO35TkBfIcBqB9MTli3JNgeOHmHguW0FcBhShGoms4He7rIexie56Y0zu3F0ocgWk8Y6ks8+HrjcqVXqNBJmTHuYxPcP+hwaK/T5d819Zf4wIl/HThuO//Fj0LgfJsZBD7Rma47Mw+e1uITb1SwC8LmnWrmibicR+2st1FVF+TMfRBd5bokjg8Shn+HWnEdoapXWdaV4ZH0iglx5xzOjH2e9h6uSTLxRHKncOBQq3DayBH/5scwaXME9T57rb7BEeaRTr078bXHL4ItU5Iq23HrtWFAU1XUut1Rh8CtprWSUs+RJn/nyypKSlmPVJ/jV/QBgzpH6LKl3vH+ZDkVDANgdS7ZwPM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b13e72-4c92-416b-19f3-08dccc5710c1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB7586.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 20:29:09.7245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHd82CJw486L+XnlMxr6srR8INGopTPGezX9UShIfxkYSa1+5FKzS1rqgNKAqMKtiGE02xV3nzf0Vk+2W9Glv5/UqN03EcFRKb43XXe5Szs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7965
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-03_08,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2409030164
X-Proofpoint-ORIG-GUID: cnhuE9xDqxrQMkRG9SXa3zri19Oh7Z_Y
X-Proofpoint-GUID: cnhuE9xDqxrQMkRG9SXa3zri19Oh7Z_Y

On 9/3/24 12:41 PM, Bill O'Donnell wrote:
> Remove dead code and from restore_extent() in content.c.
> Variable rttrunc is constantly 0.
>
> Coverity CID 1618877
>
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
>   restore/content.c | 7 -------
>   1 file changed, 7 deletions(-)
>
Looks like dead code.

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>

