Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AABF2EAB93
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 08:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760948362; cv=fail; b=TGZADrlBY4wRcKESIwpjDYU2hQwTGTQlPqJoFPbkLCaNHCBHElXJT7kzI/cNCZmSEXKKDmN/Eu7GL75/UDshp0ePU9xIt+v38bSDF7C2de/2dCEiwlBlomX2OQ+5fSIEY0eZvbAtPnfLUDfTF6Naygkn684plUEF8rYoKzsuehs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760948362; c=relaxed/simple;
	bh=NmHlC+tLPmt8nluBJtbWukeGoGm1WVRQ89J5YlLIobI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KUHkv0Kda3TKk9dNVJTWOyov/C6p25gJwM4oUkKSgBWqCc9ehSayxuQDZguXsUdyZku22MH9/7oXCEIphuzYH1ictElUuFv9r66j94638/0q6YGdmBsaDh2jyTD6WeM52sWQxo1BsyN4ERCnPppyiqx7qYUvaRgp+Fxe5vamKOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FaEsPsyA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=lir6/A6z; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FaEsPsyA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lir6/A6z"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1760948361; x=1792484361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NmHlC+tLPmt8nluBJtbWukeGoGm1WVRQ89J5YlLIobI=;
  b=FaEsPsyAlE9TnJEFWilFDn1UW1wabCTx+DYtuwxEjZxAOK8BA91D9AKt
   p5bXW4hFJ74TBB4K7pWQZoWCOxQcj29y9XoPLWOifOs2LvZVzSF8WrGAd
   6bqmIAnSL+HtNZHynzBYKxa57NWBP3rIKiN582ku/AZVw4+3+FRI9zE4P
   0+NNcBawb1QwUHKv17CFAgp+OFSMq65SuHqUDsuPYv1a1V1Ez0djQmkDw
   zPRFASgoQSz4oduxz6WUzY9Nm8AzTk2vd1aybEV1pWdLGYph93tXK0d74
   bER0f8NWFr3Mmyw45j0+85aOzGwUwxUNxgzd03yr1LwEIr+qs0PFwyMV+
   Q==;
X-CSE-ConnectionGUID: HgKZuDVqTfqhxBnjXMh+xQ==
X-CSE-MsgGUID: gPUiPOPvQR+/RkxVy22UjQ==
X-IronPort-AV: E=Sophos;i="6.19,242,1754928000"; 
   d="scan'208";a="134506291"
Received: from mail-northcentralusazon11012065.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.65])
  by ob1.hgst.iphmx.com with ESMTP; 20 Oct 2025 16:19:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tp8szoiMqgd5Ge1hUvol4jUMIPrB1+mKLB1ECQtGJx38FK1qMoZA2sUXml+c4tk4Q+kQ6zMeQqocMUPCDHjr5TVagqZcPN3Ia0oFhOVNy7FtgT90H1tBWCJoWzPQx9ZC2+UaaU+8QL3sAnF6q9e8tH9MgX4MvZx51ZHOpZf9uhAPlLPfkpHr/s4sLCrgHryEgt7+4HZsJn59aYAQHb1fkG+n3pgJV1xtZzKe1QhRMoOzF66CqhmWY8LK/Y/Byz8rcAynQShJ5Gi6JXBhyDqhrNduDEPt1/8fb6C/f7jh+AU172dwD6iDfVq2Upx+QcWBd3OuaYJCztRnf5IK8gr2Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmHlC+tLPmt8nluBJtbWukeGoGm1WVRQ89J5YlLIobI=;
 b=pR4yKwlAsOPMPER0OkD/LTiViP2TFHXxXvgRVkmw1NNDFDEtF3XYQkud3SyFgMFmC6X7SAqLScI8mc0dsuaXpsaNlFGdUTbInFdaPJ9yfsVkeZG38FLGSlemTraYwQT5SwblneCip6FLW6icVRIywuIaGDjqBU9KSy5lN8dgfgOOQBJU2iKpB6yBgxV4LybFpAnRZp9mNPtZTkpcY0/hep85+gUetgKttcgN1qgXN2PNV3ftBqZHtaoVp0smRQ9Q4Hn/Z0qlyzQ94ALV73rr3xCqrfhkUVCca8CRs4ZPWWkeiuqunPmh3ARmX16JpSXPVn0UFQzXiEulMTnsnC3mVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmHlC+tLPmt8nluBJtbWukeGoGm1WVRQ89J5YlLIobI=;
 b=lir6/A6zkELB2u4ycJDqUFaJ7t/t90Tz2+F1uHHt+y/dQ0M/yB1lMWjzBOA8LClyDS7RrKAfx656YJ14L6nZcqseYyZANzMEiR11O0p4nOO5ghXRHthM9VnmdBqimntsYE/9Xhswk0cZJjjIodEL9OW7yYgzawIWUQoZUWVQhZw=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY5PR04MB6600.namprd04.prod.outlook.com (2603:10b6:a03:1da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 08:19:17 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%4]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 08:19:17 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: document another racy GC case in
 xfs_zoned_map_extent
Thread-Topic: [PATCH 2/2] xfs: document another racy GC case in
 xfs_zoned_map_extent
Thread-Index: AQHcPyxXslosY0zgzUC6g8kzxs7SaLTKthoA
Date: Mon, 20 Oct 2025 08:19:17 +0000
Message-ID: <259fe51c-ecc9-463c-a1b4-528a01c1f71e@wdc.com>
References: <20251017060710.696868-1-hch@lst.de>
 <20251017060710.696868-3-hch@lst.de>
In-Reply-To: <20251017060710.696868-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY5PR04MB6600:EE_
x-ms-office365-filtering-correlation-id: a60675d3-a139-409d-290f-08de0fb15cd0
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZWFxdFpxMlZKaG1Hc1o2OUY4SmlnYThvNExwbVN0cVN5OVlvK2xzeTJXcG4z?=
 =?utf-8?B?N1FIZnkxcXYvcENNRDhSR1lvbEs5cHVOazZ5ZHZiTm9LNkp3bkZrb2JQbktr?=
 =?utf-8?B?UzQzQXhDd0VraVQ4UGxob3NYaE0wSGx1NHJoK1JRY0RNTW1NZTM1QUdRSS91?=
 =?utf-8?B?UlN3OXM2NmowdVo5SldVSDNTOWdBYWExcDBJL1dGakFjQ1ByNFFoRHBYMUE5?=
 =?utf-8?B?UlE5VGwxcGRvMHlqV0czSTh5aEtZYzlqWm9ZNHQveDB6U00zclBISjNiSHE1?=
 =?utf-8?B?VkczcUV4cHprYXUxKzYvWEFQVzBNeElKcVI2RXA0QUZadDFqd29HU245dHRs?=
 =?utf-8?B?WTBJNVBZZ29MK25iS1UrWjhZR3pUQXdMemZJWnZ0U01ZNlZYUElTNDQ1RWY0?=
 =?utf-8?B?dm0vZUhQNXJqRGRDNFc5VmRXSnh2Y09PZUFTSWM0M3QvOHl2L3dLdCtvYXNY?=
 =?utf-8?B?RERxVVdoS0Z1RWl6REJXWHMvbmJIR01sRUFpRUJFK2x1STRCZE1LT1BGc3kx?=
 =?utf-8?B?aEdqSlIrZ1F1MWl2OXkxNmNuUzd0VDdCMWlXbG83K1V0VTlsZ1ZxcW9RZHkz?=
 =?utf-8?B?TWluOVV2SkxDajBxNXZKUFhISFNZYUNaQVJ1YzE2Snp2VGZXTlFHMjZmSkV6?=
 =?utf-8?B?RGFUaTl3OFlEVUs3MVFCc3FvaGh3NWkwWU4yRUgxMkR6TDNteStGWERRc2hX?=
 =?utf-8?B?enNSd2VsZHNqS29QREZWRG9NOXVTKzFDYnpIWXU5YVBxeDA2eGkxSlJFQStD?=
 =?utf-8?B?eW5pd0xzZnlQUlVLK29JblBwajZUUnY4cVVBaGVvY2kzRUhiNVNod1ZNNVVs?=
 =?utf-8?B?UzQxRHlDdm9rbjVoay93UDgrUVBMS2xZYk9IRHRkazA3TVV0ZW9IZDlkdnI4?=
 =?utf-8?B?TWZWbU51TmZCTGdXVG9UZlF6dDl3WE50czl6a3dxY2JCeTNET3kvd2lVVzE5?=
 =?utf-8?B?NHllYXJtZHNJK0xxNVBsc3FqVWxWNlB4YVBUTVZTVDlvZkN1c3R1V3BSNFZC?=
 =?utf-8?B?L3lyQnJGbEZ0QlNFT3krQnBBbFVIZE5UVVNDdnhXcms5eGhLM1dkWk84Z2F0?=
 =?utf-8?B?RG92V01BME5CajJmbytWcVZQTSszWkV1SjgvY0hlSkJyeWxGS3Y3dy9YRExU?=
 =?utf-8?B?QnpjV3grMVlERVBINXlWeU83WWxvczlrbmEwbDhsMnR4RkVacnJaMkk2eUpH?=
 =?utf-8?B?ZUh6eDc0K2hIQitjeFQ3S0lRbkZxRFd0VjJaOWtDMEpMVmdVKy9iaTd4RS91?=
 =?utf-8?B?UnRKcmloODIvY3Ivd0FjREdSQmYwcHhjZHN3S1N5amFTNG9NcC9tYjdkMSsz?=
 =?utf-8?B?dktrWktUYVIrN3pLcGhOQVZpVTBVUStYVzVmaTl6dnBWdFFGUzR0RXFLZ2ly?=
 =?utf-8?B?YkNvZlJSa1FrUTdXeXBzaTJETmJQYlhhakZLd3BHZWp6dHNnbE53NG9JdHdv?=
 =?utf-8?B?NTU5aUt0b0NLdllEY3JwZ0p0Y0pGeDgyYWhndXNXUnJhRlVhRG5BZWRPYmVJ?=
 =?utf-8?B?Njk5STQ3UWs4VmtVSjZrTXBIREFWaWlKMHAwRzNqR3JmQUpIUmtQM2dkNGhp?=
 =?utf-8?B?enVuc0lqMThtblVLbkw0OXVwMGtrSk12WExoMjJHb2RRLzh0SkdaOW9qRmtX?=
 =?utf-8?B?NEZTNTg0MiszVHduaE5JTmp6SVBOd3JOZ0k5Y2oxV0dwUzhhTERqNDVhbERJ?=
 =?utf-8?B?Yi9TbFBaRzFxSm5yMkJ1MTFmR21VMTFnZlREOHVUaVI0T0dCNjVLTzBvcHVa?=
 =?utf-8?B?SFArajg4T2pKY1NwOEpYYk1SVzhHQzNlZUN3UktjVm42TmtwM2NqUW5pR3d5?=
 =?utf-8?B?QlVveVBneFBVV2prSjFjTjFDaDZxS0Z2QjVCNWkvSTVHK0NTWGJ6OGlHWVAx?=
 =?utf-8?B?MEZaREJ0QjNOaUxhU0lrSzJXdkxZQ25IdlJTcmQ3SGVuWGhPYWN1WllVQWg5?=
 =?utf-8?B?cTV2dTc0SHdGSk15cVpicmw0UGZCM0RSUzErM3BoLzlyT2JFdTBocXphTVpO?=
 =?utf-8?B?eG1JK3I0aFlNdzdEMjM0MkN2NFRiY3RSUVZUREF5SW8yNUNKeWFXNW5hQ2RJ?=
 =?utf-8?Q?hmznP8?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S3pJMFNaRVI1SWJyakdDM08vUHdpU0wraE44b3Z1amhWZnkwRHFKd1B6SUY4?=
 =?utf-8?B?SWhrN1BSY1g1V0dMZHRjV1I1V3V5eWpnUkJUMjBNaGdLak8xSmxLTDdRUXRN?=
 =?utf-8?B?U21zWVd1eUo5R2oybkNvbm54UHNYWVc2SXI3YjZMemVoN0NYa29aU05oa3Zi?=
 =?utf-8?B?OUV3VzVNZEE5aFhBeW43ZmswMm8wQVFTcFFTM1lBZEhud2ZMMEZNNVRGZ2t6?=
 =?utf-8?B?Q3JBTlZ0MHJRY0EzV2Fxa3VJdGoxQVo4OEprcmlWK0JSSS9xQXM5dXg2RzZL?=
 =?utf-8?B?Q2dhZTgrNjhRMTBYVExvSkZMeFUyUE1GSDlNK0M1SSt5bE9MUkQzYUFFOGVO?=
 =?utf-8?B?QXlEVTRLcXJ4Y1NDdU9MdnRXUVo4SnJkRm0razQ2NEtwcUZ0Z1VFenpXV25L?=
 =?utf-8?B?dFNzWCtJVXVCRVJWUUc4bnl2M3l5VHI0UjdmTkI3c2d0ZmhSdnlQZUQ4cGpU?=
 =?utf-8?B?WEVGVkplVDlzUnJ3R1ZNQnBqQ2RXKzZEQmRPRHBvOWpocHEyUC9wZEhBRUgy?=
 =?utf-8?B?WnNlZk52SUgxY3dhaWdrbEtQeGZiNkFuY3pZNys5aFQ3M0xsUEhYMGYyWjdF?=
 =?utf-8?B?LzB6eXAxUEhkV0tTUDhGeVpOaFQ5QTJUVVdWb2lUMGVUVldrZm1RV2JBdWlN?=
 =?utf-8?B?Q3dLREZlNDErRXRmSTdyYVV2eG9GVFMyREVCY1hTNGNEYllzdzArMTVvaXUz?=
 =?utf-8?B?Q0NSdzJMT1orS3lBSjZmNFovMWpkWEhla2Y5S1NCR1UveStjVmFibkUreXpQ?=
 =?utf-8?B?SEFYRTRWWWRvNUxJc0FCdTNJSUlnSFVDbjJTZURFQTRkMDVCelN1Qy9xRmRj?=
 =?utf-8?B?WnpYZEVyeUcyc1hURm5pTFdIYVd0OHRVNHhveWlERzRNWGxLRVhQYnVxQjhE?=
 =?utf-8?B?WGlQWGtaS3BpbzJjRDNEaWZNblhDekxzR2N1THNTK1hDZTJGbFc5V0pzZ0p2?=
 =?utf-8?B?b05iN2JGTXZhNkRPU0NXUlNzYy9RQlgvZnhMcG41YU12VWhkakFBYnJjMGU1?=
 =?utf-8?B?RVYzME55a2hlQkk5OUR4QjVHTFRKRkwxUUJwc0hOc2pyQ3haUVR6ekZVcmx1?=
 =?utf-8?B?Nlo1Mkk0ZGlsZ1dGQnY5aU5KOEc5cmllT2xiMXpoN3M2MTZ0dElXVGVPMmo4?=
 =?utf-8?B?L3pUUlpzeDRrMHRsUVF1TGNmZHVRRC9Dd2ROcytqcG9ialJLK01RUVlMZjdi?=
 =?utf-8?B?dm1jYmRHOVptOUZ6c3haZVFlZkJIWkVqN3FrN2wrNVlRd1pTWnZIMzVHNlZF?=
 =?utf-8?B?NUd2bEVuUG1DbWh2WXlQUGVLQVBhOHBxOE5pVzFvT2ltd0tXaVdLSTdTZnQr?=
 =?utf-8?B?QmdxSGdaK1haWDBZVisrU293N3pBWDAwdzBBM0FoVHZQenZxRzhMeTJ3UFpa?=
 =?utf-8?B?THBBK1pkZW1pOGZMWkNPQ09jUGswRGJtd0dkN2tmbFduWENXU09HSk5VUytV?=
 =?utf-8?B?bUpSQ2pFQlIxdmFGUkpNSi9iSGFGWFNMQ2s0d1BPWUhqOW9zM2hucFozOGI1?=
 =?utf-8?B?TUJETllwUStucmNoNjExSjNPcEFFZWVLV2pvd1FFWDRCWi9tN2x3OVhFaE1h?=
 =?utf-8?B?ZUxKWDltdU9Yb3hkbVhxRU9HT0FNUXdNTjBScTJlK2hubjBMWEZWdnVLMi9r?=
 =?utf-8?B?d3V3OVlCTVZyWmwrWVo3STNhYkpkeGg1bmF0SGpWK1MzRlJ2NGZrV1ltRVpx?=
 =?utf-8?B?UXVycmdzdmN0M1hHcjJ4SEVVczBmL2w2cTVXbzhPdkJZVm9YL1F0SEdBN3l5?=
 =?utf-8?B?Mm9TYTB6Tmo2KzVyRDVSTk5SRWsvNkVhdFkvRFZxOXp2SVNIZVNaYnFoTFQ4?=
 =?utf-8?B?UDJZbkRaU0h0K0U5REpnR0pKR0NJazZLRmJ6eElEeTUvQ1IvZWZCaitINnNK?=
 =?utf-8?B?SEZrQVZIaWhoVkViQllMUnVhM1Q5aTVsZmx4STlUUERMUHovck05b205Vklh?=
 =?utf-8?B?djdlcHBpSFpjMk91eXU5VloxN2pTbFE2T2t1SXZ4K3RubkxTWklDcGZQVEtu?=
 =?utf-8?B?YXNPY0tHWGdERHFwSmQ2MUVrdnRpSVUxTllWR3V5RXJ0ZitOR3JLMTVlRitR?=
 =?utf-8?B?ZnUyQW9va2xZcERPOUF3cytOWEEwMndpT1pOcW8vaE4yVjFITmQ0aUlYS2Ir?=
 =?utf-8?B?cmtBWTU3eGFscW9UeHlqV1dmVyt2WjhFWVJzNlZRZmxLK2t5eVRpNDM5eW5p?=
 =?utf-8?B?Z1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C269C1E3CAB03A4C85A635654566DC8B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A4IDQMCYs+AzIGGd6JrwIk3Trn9SfB8bGANxxKqdfhr40UXiokYFAr/ANjagthTa0ebFo5No1AKdeVA8epDpqBHw6GLqg9QHhN15alK5zJuKy05HNK8rnpAY3bG3Y6fzEBISG1UBNlQ2E8p1wAZRzvTB+0VhPiIjOM2OgrhGcqCrzTWnw7WMxphUNiSDUQG/4RzUFSxSnvKbmg+sAEFxMtGruZtjR/tL4yRpCMhiYxP1PpC2MNuG0+cTJCmeF7HmYlNM6ekEtCq74ibICnvWsOy9d9+RrEwW1hdSRCH8C9hvI0bvbBPXJGmDoT6VxvzG2sa+fqjZ9AupQ1wlcmnmcdHUTvMCmUpS8zdYgWuBgiexqm0xwCWMUfgcZawCjyw59PvnybZZTnocSlrW+mK69dMEPPsifpqSJyrgrjZ3JwopbKa1xMMH+3iOF5fWQV9auTdTQpJCCbopqYDkq3qxOwlr2xc5hoXEP0IeOluZzOjIAEHb/dQ7C+5exiM2/hWblVt3sOKNLCJqGTHsl7nv3eSq197Y/om5vTBSoXoFKIdn2NQ5av0MLGsClDcFF4PlhCpjTJjxACa6T1i7LK5BwM6fBFXsQgf+9Wg94QZA2im7lqoyCsiAMUpsGzOlBbUi
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a60675d3-a139-409d-290f-08de0fb15cd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2025 08:19:17.3405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kqP2CesaGpcf1E8EnOXwQcHZjN80MhocUevXdhgbnPs+xJ8r+B86nCKCM5YjdDJYYet3zY6MWr6uii69idMd3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6600

T24gMTcvMTAvMjAyNSAwODowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEJlc2lkZXMg
YmxvY2tzIGJlaW5nIGludmFsaWRhdGVkLCB0aGVyZSBpcyBhbm90aGVyIGNhc2Ugd2hlbiB0aGUg
b3JpZ2luYWwNCj4gbWFwcGluZyBjb3VsZCBoYXZlIGNoYW5nZWQgYmV0d2VlbiBxdWVyeWluZyB0
aGUgcm1hcCBmb3IgR0MgYW5kIGNhbGxpbmcNCj4geGZzX3pvbmVkX21hcF9leHRlbnQuICBEb2N1
bWVudCBpdCB0aGVyZSBhcyBpdCB0b29rIHVzIHF1aXRlIHNvbWUgdGltZQ0KPiB0byBmaWd1cmUg
b3V0IHdoYXQgaXMgZ29pbmcgb24gd2hpbGUgZGV2ZWxvcGluZyB0aGUgbXVsdGlwbGUtR0MNCj4g
cHJvdGVjdGlvbiBmaXguDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX3pvbmVfYWxsb2MuYyB8IDggKysrKysr
KysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQg
YS9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYyBiL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+IGlu
ZGV4IGU3ZTQzOTkxOGY2ZC4uMjc5MDAwMWVlMGYxIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZz
X3pvbmVfYWxsb2MuYw0KPiArKysgYi9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYw0KPiBAQCAtMjQ2
LDYgKzI0NiwxNCBAQCB4ZnNfem9uZWRfbWFwX2V4dGVudCgNCj4gIAkgKiBJZiBhIGRhdGEgd3Jp
dGUgcmFjZWQgd2l0aCB0aGlzIEdDIHdyaXRlLCBrZWVwIHRoZSBleGlzdGluZyBkYXRhIGluDQo+
ICAJICogdGhlIGRhdGEgZm9yaywgbWFyayBvdXIgbmV3bHkgd3JpdHRlbiBHQyBleHRlbnQgYXMg
cmVjbGFpbWFibGUsIHRoZW4NCj4gIAkgKiBtb3ZlIG9uIHRvIHRoZSBuZXh0IGV4dGVudC4NCj4g
KwkgKg0KPiArCSAqIE5vdGUgdGhhdCB0aGlzIGNhbiBhbHNvIGhhcHBlbiB3aGVuIHJhY2luZyB3
aXRoIG9wZXJhdGlvbnMgdGhhdCBkbw0KPiArCSAqIG5vdCBhY3R1YWxseSBpbnZhbGlkYXRlIHRo
ZSBkYXRhLCBidXQganVzdCBtb3ZlIGl0IHRvIGEgZGlmZmVyZW50DQo+ICsJICogaW5vZGUgKFhG
U19JT0NfRVhDSEFOR0VfUkFOR0UpLCBvciB0byBhIGRpZmZlcmVudCBvZmZzZXQgaW5zaWRlIHRo
ZQ0KPiArCSAqIGlub2RlIChGQUxMT0NfRkxfQ09MTEFQU0VfUkFOR0UgLyBGQUxMT0NfRkxfSU5T
RVJUX1JBTkdFKS4gIElmIHRoZQ0KPiArCSAqIGRhdGEgd2FzIGp1c3QgbW92ZWQgYXJvdW5kLCBH
QyBmYWlscyB0byBmcmVlIHRoZSB6b25lLCBidXQgdGhlIHpvbmUNCj4gKwkgKiBiZWNvbWVzIGEg
R0MgY2FuZGlkYXRlIGFnYWluIGFzIHNvb24gYXMgYWxsIHByZXZpb3VzIEdDIEkvTyBoYXMNCj4g
KwkgKiBmaW5pc2hlZCBhbmQgdGhlc2UgYmxvY2tzIHdpbGwgYmUgbW92ZWQgb3V0IGV2ZW50dWFs
bHkuDQo+ICAJICovDQo+ICAJaWYgKG9sZF9zdGFydGJsb2NrICE9IE5VTExGU0JMT0NLICYmDQo+
ICAJICAgIG9sZF9zdGFydGJsb2NrICE9IGRhdGEuYnJfc3RhcnRibG9jaykNCg0KUmV2aWV3ZWQt
Ynk6IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
