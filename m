Received: from esa17.fujitsucc.c3s2.iphmx.com (esa17.fujitsucc.c3s2.iphmx.com [216.71.158.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D93182BD;
	Wed, 31 Jul 2024 03:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.158.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722394809; cv=fail; b=DYZMaI/q6GrujXPgPeR33vt2rgs2SoNDJmKI2tbmukmdYl/IxO3+k8k1gOBn6uAgZVLZkG4pHJEKD+Bgv0Odq1cFKICjsIuVHAjvGMdGoLMoyZk0eJ2vc2Spz+Xxx7qShBg79+HgPcfAz+igBhyRPlUHKXknBvZD8/jNINMhWWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722394809; c=relaxed/simple;
	bh=XgdnNRW88gj8LSG1OpP6QADB78H5/boKop+JLinfsNU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VyhORP8pxygahmdak9WxCkRIFbh18GlxVZpD7u/8H02Kzq8ukiNZoWy3+ROBf+bD0dwNhfYQZzBa3em1FSy7XFSzTajLwK0kxfsKvDSdXK5Fnrj85iSqPu+OtGVGQN9Dl0/JMT8niV1ItBA4kJG7ekwTQe1IEw/dBp3OL13FOR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=hd0f/4Up; arc=fail smtp.client-ip=216.71.158.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="hd0f/4Up"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1722394806; x=1753930806;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XgdnNRW88gj8LSG1OpP6QADB78H5/boKop+JLinfsNU=;
  b=hd0f/4UpQe8dptQpmyXF/iloTkLnmx/x/qx3ipSSqZ/l1OYoM5W2tfXP
   oqnn4x9uqboPnxb3CcOkD8J0vb3xutSABqpvoRhEORgFRJXP8c4HnLmdO
   SZJS08Be185sbVhVq8slziACCmTDkbv2OVnprUVyws+uMEHSWne6TGKgv
   uhPnBherNaRqgET1q6LCBAsK47Atn5uL4WI+y6pkE5wKfjxdXCO/Mt7QN
   QO/WolNd4MgEUuSqwyYDRjWuDJhzfSF+VRG28nK57viyRrW5O/jTbxSkm
   hZMoW1R0oifHGEQAmGaZptTwoTlyYuLJkkTUVnJmPCnELn20bvlyR/3QF
   A==;
X-IronPort-AV: E=McAfee;i="6700,10204,11149"; a="126681483"
X-IronPort-AV: E=Sophos;i="6.09,250,1716217200"; 
   d="scan'208";a="126681483"
Received: from mail-japaneastazlp17011026.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.26])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2024 11:58:52 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZAKNWZUyCuYZ3EVDqSdHATZLLcMdD33ZT4WfMfm5Ul7JM4XJ3jFgCFQX5YhzZDMjJ5jAN72uJXQDw0BivUSseDTp6Qolx9QfEFl1/VMmL+M423h2UvzgdXOr4FOK0MDKq47NwNeaJxo8YSK/FP/7b7oWExL6yhD3CSxTEbhdpn++CK4zdNJT78Nhlni20tlun6zwRL3Tni/5kowbz3b3uZ0GiM1mFodvYfuyZjXia4Jg4XvstsPNugAoKUVF4Io4P0sUTKWklfQjGusaxtMHZswm0GBAG+sK6LfbFRt+ymCr8Pr0j96wDbquCH1dJ0XOKAprGeZXIzBkm/ZjUa94g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgdnNRW88gj8LSG1OpP6QADB78H5/boKop+JLinfsNU=;
 b=voRXQx52bfbxFpIADiDujtr9nWPdMuBtbvLl8Zv992udknhotATFUwHo+c0q3W1HRQnrm1OWE0Bg3IAv5JUBAxaH2K6hUe5qlRrrRb7eL/xnrSejnTKFqy9lDso4CELVRfPtRStKYRHTeZux+OYXwdIfVT8l9kYVDQzvpWV9BIdqsciHCbvDX0WrChv9R3Za+CfBhmSK5dBP21HkLvZf5uOfabdAbBmL9S/4ZT77Fg8kPn2Ht3XbPq7AeSiqKDPbs5qxpEXFdx2S0srSEDsrcQIv6ooelCiB1sf7AtT3atEzIBEWWADhIiiOEzbGgPk8gFPI9iUYaB9K7nBn/LdVDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB12079.jpnprd01.prod.outlook.com (2603:1096:400:43a::6)
 by TYCPR01MB8802.jpnprd01.prod.outlook.com (2603:1096:400:10f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 31 Jul
 2024 02:58:49 +0000
Received: from TYCPR01MB12079.jpnprd01.prod.outlook.com
 ([fe80::9b43:f7ef:c299:bb74]) by TYCPR01MB12079.jpnprd01.prod.outlook.com
 ([fe80::9b43:f7ef:c299:bb74%5]) with mapi id 15.20.7828.016; Wed, 31 Jul 2024
 02:58:48 +0000
From: "Xinjian Ma (Fujitsu)" <maxj.fnst@fujitsu.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "zlang@redhat.com" <zlang@redhat.com>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: RE: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Thread-Topic: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Thread-Index: AQHa4lW9OsfX98L4XkSKvoN54kZuobIPWjuAgADLuvA=
Date: Wed, 31 Jul 2024 02:58:48 +0000
Message-ID:
 <TYCPR01MB12079E445BE5416DDD72AA5D0E8B12@TYCPR01MB12079.jpnprd01.prod.outlook.com>
References: <20240730075653.3473323-1-maxj.fnst@fujitsu.com>
 <20240730144751.GB6337@frogsfrogsfrogs>
In-Reply-To: <20240730144751.GB6337@frogsfrogsfrogs>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9NzJkMzc3OGEtMzljZC00NTQ0LWI1NDMtNjMwNTdhMzI3?=
 =?utf-8?B?NDc0O01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI0LTA3LTMxVDAyOjU3OjUwWjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?Q?81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB12079:EE_|TYCPR01MB8802:EE_
x-ms-office365-filtering-correlation-id: 927d04cb-bafa-4eaa-d0b5-08dcb10cb364
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?eTR0TmxISmhaR2Rycm93L2dBa0Rha3ZjN09jdTZIUVFuMkxiUWNBTFREOVVw?=
 =?utf-8?B?a1BDeG5uVXphVTZOckt2bzI5TGZveGNDL0pUdXg5Y1VKWXBNMUxPNG1yK2Y5?=
 =?utf-8?B?ekM5Z1ptdjk5anJNZlBvQ3pBd1RrNlBuYW1HNWhHbUR4ODArRmVOSXVrWVRX?=
 =?utf-8?B?U1lRTVNwRlEzS25wWW40c1ZuWThhbW9saDk0TWNiTXk0cmViQnJUc2F4R0di?=
 =?utf-8?B?NnNUby9GTEM4a2FORGlhejZ1MGVWU1hYd1k4a3VoRkh0QzBLb2F3SmxFdFc4?=
 =?utf-8?B?RnBOQmQwZXVkVkJoZlcxWS8ySmJRV09QZTBzbkJqZjc2RlFldHZjVk4waDF3?=
 =?utf-8?B?d1FpUitFSXJZaFpVbGJkVDQyRVNheVladFhiaHhZVE9YLzJDZnU2SXBZaEln?=
 =?utf-8?B?UVduYVl6NmhzekJPLzZpU2cxdWZWcFZxeXZMbDUwNXlwNHhYcjlHV1RZZG9l?=
 =?utf-8?B?ME5rMmN2RWdBaytiR3BTQStnUmZvR3I3YXZ3eVBnQkVMSlZSNDkrVzZucVJz?=
 =?utf-8?B?Rk53M1pUb0RFTkFDM1d6NmpwNHJwd3Q1Mm9VSGEyNUNRRlFuRnVZbjFTTEt1?=
 =?utf-8?B?NUJaMnhZRUh5RzRrdEtOci9zRFZORGtzMzdyQ2podFFtS05MNHA0QnRKcExZ?=
 =?utf-8?B?M0kxaUsvTDhZMjhldUxFWXNmUmtRb2ppcWNDZVlCdEQ5d1RMTTVuNEQzS1Q3?=
 =?utf-8?B?K2hnc3YrVWsxRS9FaEtkYnZtVmxPMSt0T2xjbTMxbEZMWjRxcy9ZVU1Fa2pQ?=
 =?utf-8?B?ZHE2NEhicll4YncvTHJVdHBnZG9kZmEzZy9wY09ibHlhZEJaRys1dmtYT2wy?=
 =?utf-8?B?SysxaUlyaXRCcVlITVIvTUtIWWhwRHBQM0pTbm1zRk83V0h3YSt6QmhjcDh4?=
 =?utf-8?B?K1JyUEVDdUhCejBXYUJjYzhhSVhYREpTTTZqcGY2QjYwSWNMeVZBVEJ6QzJj?=
 =?utf-8?B?RVBBUWthbTdWNmNzU3lTME5NempJb3k5dWhTaXhzdGlKTklvcmpVdWlLejl5?=
 =?utf-8?B?RmVaM0JZS00yeHlvN0ZBVFRkbDA2TlJueVJkdzE1b3RYN0k3MkExb0Y2TXB4?=
 =?utf-8?B?di9PZ0FnL0xROFB2WDBxc0d0bTc2UGV5RE1iS2J2K1hFN3BPZHV1eGRlTC9q?=
 =?utf-8?B?ZW1teVlFYTV2ZUdRck1MdTJJazB4VUJpY0poSXdXaHRaSDExckFzdDdlUW1k?=
 =?utf-8?B?bFpEUDVJK04yR3o4UVErMDJ1Nm5RWUo4OGJFMEdzZ1E4czlDbTlFTzA4MDJm?=
 =?utf-8?B?WE1JRUI1Qlo5U2JMRzNGWmZNSitaSzByenRhWDk2UE1VVEdwcVRyM1Z5UW5r?=
 =?utf-8?B?Zk9FRUo3NlpUU0hRRFlIOWJ3VC8rZktVQlVkM1RLZlZmK21ReTlFZkN5MmJX?=
 =?utf-8?B?RVprdGZXVENUTUZZYXlaVjF2MWVDazZURWhTeDlZT084WUdBZEV1WWF1aStL?=
 =?utf-8?B?ZVlrSlZLM1JJNkpneUUwNjMzSHlDZ1R4T1g1dGhjSmNVL2ZzbmpSWGxkOXZW?=
 =?utf-8?B?S0FHN3JrNEprbXh5NDFDUGpHZjBTS1NyeWt3MTNHYVhScGVFRjF6R3dkRHIv?=
 =?utf-8?B?N085eklZVlVtc2JpN2hmc244SWpYNXZzb3ZsQStwZGZsRktWeERKdENkYjg2?=
 =?utf-8?B?c1IxWEprQTFHcUc2cHVsU2hyT3BuNDNzblhoRXcyMGVJNlpmYXpFZTBRWUwz?=
 =?utf-8?B?Z0toWjh6WXpXV3N0RnVBWi9QbVRBcG5nTWU5ZVo3ZHZaK3pLUjVIb0g5b1hH?=
 =?utf-8?B?MXFmbVltOTZVVVc4VFEzaVh4a0JiUDNTVXgvcGZPZGl6bEV1Q0tHVlorR0dZ?=
 =?utf-8?B?Wm9sL0JHckVOZnVHRlI4U0R5dDNSTmR3OUdVdzZ4L3gwTkpWTHVRWGNOZHVP?=
 =?utf-8?B?eU5hdnkvaWd1QUVrbGZ4UWpSOFVDMmFWL2JmNnlMU1pQaEpDdlU1MXJOOHAx?=
 =?utf-8?Q?pMGvQjC1Bys=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB12079.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aDZLUUd6ZjNxZnBJbDkrdFpwdGJTcnlpOXlmSWdpRXRLTzlZbDJhT2w3WHJq?=
 =?utf-8?B?K3BrS2llTW1RN1kwTko5MDlvYlFFL1orVktMVmwzUWNnN3BKZzBEYmRLU1lz?=
 =?utf-8?B?am1nVWh5RlZIZm52azU3S2drdkV3RWlFakNKL0lxN1NjZ1VjK09MR3NPWXVO?=
 =?utf-8?B?MHBZUGpQMEgrcEFMS2s0S0VBWmdOUS9POG9GTUZpSytXbWtrNjlhbUtsb1hi?=
 =?utf-8?B?d0hNUDZOdEJzcnBlM3dXQWUxUXl2WXplVFhETVRRNG00Um91YmVKc1RWRllh?=
 =?utf-8?B?YXlwakZLcDViSG9TdTJndkxLNjl6b1NxS2FtSDJsdzBkRGt4U2tTckwrWkxW?=
 =?utf-8?B?dUxDbGJlQys4Q0cyUisvSWV3TUZlNGx1cU5NMVVCempaSDlLSDBUTzBWQWp1?=
 =?utf-8?B?cTZoV0ZCbXp0VEVkTnU5bzVlTTEvL2lXcDhsN3RaQm9OVWxaVnlrNEJKSUIv?=
 =?utf-8?B?eUs5cDFSSHlPZzZkVW00YnlIckNXMTZVVWU5ek9ibk9BdEdUUnhJbWo1UnBV?=
 =?utf-8?B?ay82ZjdrS2dqeWhUaEFQWnAzVlJJbGtyYUlUSzBsVVhFS3RtZnIxYk9wUWZV?=
 =?utf-8?B?UG80Z0xEdVpyVWV4ejRGTkFSNGNpZ21LNG0yekp2cGNxUndDbU9rMzlJMkZq?=
 =?utf-8?B?UnpzRFNTMGc1cTIvc2Q3S0RRQUFtQzQxWXVDb1FLanZpMFYraXVCVitTb3Zm?=
 =?utf-8?B?Wk9lSFEwVVU3SEd1Tlc4TysrRXFCaFhscGVMOGlocnFTbzJhdElsaHRyVXFL?=
 =?utf-8?B?eEJDNDEySHNUbWRWK0g1ODQ4cGROUlk1c2JteGVxUmdMY01scUx2WDk5MkpZ?=
 =?utf-8?B?SjJJT0Jtd2dzYnV3aW9tajBXNFZ5SWV1R2tOK0ViTE9GcEx1R1dqTjhhMlJF?=
 =?utf-8?B?ektnME1QRkNYOU1MT21PMkt2emFvaWN2SktsV2dzWTJtQnNzVXRCMjVJZWFJ?=
 =?utf-8?B?amkzaytQT1R2VFBrSmlRTGZEc2c5SUd2UFRkWG1ZYU4xTkFWeFlFNjVuMGFn?=
 =?utf-8?B?UDlaaTJMaXdkV3R2N1pSYVBpays3Q1E3dVJwYndUWC9tRDRKb0RQWUZ1Yi9Q?=
 =?utf-8?B?R2RNdjRobm1EWnM0cUpYM0RBQmRJbmYybzJNWHRjb1VqVmYvYStRWWlmdGZ0?=
 =?utf-8?B?bzVaVjM2MFRxQ09FYW04TUdKZGNDOTRLeWNxMm5Xalc4UG1UV2xSK3ZIb3ZI?=
 =?utf-8?B?QWxBeis3bVdYdFNKWENQdnR4NGx6Rno4SEhBWXZKOUF5WTY2MmxIRFZqT3RP?=
 =?utf-8?B?TytOSk5FOGk4VDh1aE9NZ2NlQ29rQ3phOVNVNEkzZVJMSnp3YXp6WjBNaStV?=
 =?utf-8?B?R1JLYkxOWGtXL0luZ0hLS3piY3Fsdk5CUENnRVFlY0lLR3Z2Z2dOSGRyNkFu?=
 =?utf-8?B?c1QvWHF3MFQvTXVrQU81bmd2ZkVLdXlRUkpHUVRWL3Jad3pXUUZ0c1Q2V05k?=
 =?utf-8?B?WHQzMGd3OGowa0p0cFNEL0pmQ1crNStkcHVEdW1wM1h6OWVoSkxQdFVnUGJy?=
 =?utf-8?B?Z2YybTVxOVdrQ2pYMFJROFF0aWNwbUFoQmNJOFBnOVJTVGs4Z0o1cVFLYXR1?=
 =?utf-8?B?UEJnNmFDTU80TE05RHdnNHhGTVhNTER5SG9kTEFJdm5LOWtqaEtXRVlTWDhT?=
 =?utf-8?B?Y0JLb2xQUW52L1RwR3NQSERmeXgwSkVxck0vaWFLQzRseHd1T1RUeHFzRWQv?=
 =?utf-8?B?SFVXOUdnYjQ4UFZTVFZBWTVjMDFDZUtFUXRmbEhscFdRM2ovTjZCNlRWSjls?=
 =?utf-8?B?REJNZU1jNkp4QjdnYmhSUVNoTWxhdU5Da05XSHZDSlM5cWJZVnZQV3phZ0Fy?=
 =?utf-8?B?Q1Faa0ZmdWxQVkV6MXVtSUZlUnpiQk1tTm1ndmRiTTRvVFE4a2tHbFphVjBI?=
 =?utf-8?B?aG1laHJ4bVAwRzJIdUtOaDZwTzlSaGcxWHBUS3hhTXE1M1pUOTlXZjN4TmVw?=
 =?utf-8?B?ak16MzBCMEkralQxcExUTlZlSFJtWGgwK0lGK3J6c2JDY2lXeUlPRGNlTE02?=
 =?utf-8?B?c1pXcjRPaVdSYTdMZUxlSm9XT3d5RThpbmQxQXB2MXhva0pOQVRuQ0wxSTdu?=
 =?utf-8?B?NjFHbGtpYThtOXZET05veFBHNzdXdTJxdnpQZHVsRjh0Y2c1bEd1UHJWRFB3?=
 =?utf-8?Q?0Klyh+xNeHQiU/BDL7ZIG2Hv7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lgEuomt/3dJz/kNQeHpZUBNW09qvFZxQw63cUERIvlYQtCBgj0cknoGA8et1PzlhNGwFBVKSzm9OUvHDMU69OmqD14fxZK638zydWipORuv4NulyEsOBaIEao4X5dbIycS3BwIUe4jg4XGRATYhZGaI8YJh4RCQo29OGwQsajH0FC607nvBOPdkkNfPVI9bVNjvevtkZN4sf0sH42BZzQZ2uDjhF0TA01yC0KqvGgHGYZtssXpnx3MiNZ3QuU7vsMB+076JcH87qWt8kotS+eNLV0mWIbDhcii/nSQgLbI+IYdJ924NsFjzWix1nH7jupXNpLw2zs8UYJlpxkiUKzqHV9iIpxEZeI1eAopZh8D8ZmbWydR0p+CLun4HdYIc69QsyxohC7mG9Kgi5UxalWlqhgl9ITCSsjxkMk36/GZDvb10puRLJRwplUKPZwxfyehoNZIIVBEF+dsYlwMD1L1yxdVOrFs2N51U7uakeMzsGwPnZKhpgQr3KekPhnu0G8Yg1l/OpEtuMtGRk4fRoOdusNamo2ytoDba4X5rlXOtEn80FDZRSuS05G0JM5hwbHt3h6It/mZyQ735rVYXOlxl8N5lq14MO3g2A51vgbIOjfjmjXkHDLaEXws7gwk/g
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB12079.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 927d04cb-bafa-4eaa-d0b5-08dcb10cb364
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2024 02:58:48.7152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hT5H8hHL2Zm8ZHOCuMNIXcU8/kpzN0lGP4BgyjuRD2fVVtvHSGFSVRnyHU/pPorGqPmgJJJh0p9KwJRoZAJ1UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB8802

PiBPbiBUdWUsIEp1bCAzMCwgMjAyNCBhdCAwMzo1Njo1M1BNICswODAwLCBNYSBYaW5qaWFuIHdy
b3RlOg0KPiA+IFRoaXMgdGVzdCByZXF1aXJlcyBhIGtlcm5lbCBwYXRjaCBzaW5jZSAzYmY5NjNh
NmM2ICgieGZzLzM0ODoNCj4gPiBwYXJ0aWFsbHkgcmV2ZXJ0IGRiY2M1NDkzMTciKSwgc28gbm90
ZSB0aGF0IGluIHRoZSB0ZXN0Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTWEgWGluamlhbiA8
bWF4ai5mbnN0QGZ1aml0c3UuY29tPg0KPiA+IC0tLQ0KPiA+ICB0ZXN0cy94ZnMvMzQ4IHwgMyAr
KysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAt
LWdpdCBhL3Rlc3RzL3hmcy8zNDggYi90ZXN0cy94ZnMvMzQ4IGluZGV4IDM1MDI2MDVjLi5lNGJj
MTMyOA0KPiA+IDEwMDc1NQ0KPiA+IC0tLSBhL3Rlc3RzL3hmcy8zNDgNCj4gPiArKysgYi90ZXN0
cy94ZnMvMzQ4DQo+ID4gQEAgLTEyLDYgKzEyLDkgQEANCj4gPiAgLiAuL2NvbW1vbi9wcmVhbWJs
ZQ0KPiA+ICBfYmVnaW5fZnN0ZXN0IGF1dG8gcXVpY2sgZnV6emVycyByZXBhaXINCj4gPg0KPiA+
ICtfZml4ZWRfYnlfZ2l0X2NvbW1pdCBrZXJuZWwgMzhkZTU2NzkwNmQ5NSBcDQo+ID4gKwkieGZz
OiBhbGxvdyBzeW1saW5rcyB3aXRoIHNob3J0IHJlbW90ZSB0YXJnZXRzIg0KPiANCj4gQ29uc2lk
ZXJpbmcgdGhhdCAzOGRlNTY3OTA2ZDk1IGlzIGl0c2VsZiBhIGZpeCBmb3IgMWViNzBmNTRjNDQ1
ZiwgZG8gd2Ugd2FudCBhDQo+IF9icm9rZW5fYnlfZ2l0X2NvbW1pdCB0byB3YXJuIHBlb3BsZSBu
b3QgdG8gYXBwbHkgMWViNzAgd2l0aG91dCBhbHNvDQo+IGFwcGx5aW5nIDM4ZGU1Pw0KDQpTb21l
IHJlbGVhc2VkIExpbnV4IE9TIHNob3VsZCBoYXZlIGFwcGxpZWQgMWViNzAsIHNvIGZvciB0aGUg
dGVzdCBvbiB0aGVzZSBPUywgdGhlIGVycm9yIGlzIGluZGVlZCBjYXVzZWQgYnkgdGhlIGxhY2sg
b2YgMzhkZTUuDQpJTU8sIGl0IHNob3VsZCBiZSByYXJlIHRvIGFwcGx5IDM4ZGU1IHdpdGhvdXQg
YXBwbHlpbmcgMWViNzAuIFNvLCBJdCB3aWxsIGJlIE9LIHRvIHVzZSBfZml4ZWRfYnlfZ2l0X2Nv
bW1pdC4NCldoYXQgZG8geW91IHRoaW5rPw0KDQo+IA0KPiAtLUQNCj4gDQo+ID4gKw0KPiA+ICAj
IEltcG9ydCBjb21tb24gZnVuY3Rpb25zLg0KPiA+ICAuIC4vY29tbW9uL2ZpbHRlcg0KPiA+ICAu
IC4vY29tbW9uL3JlcGFpcg0KPiA+IC0tDQo+ID4gMi40Mi4wDQo+ID4NCj4gPg0K
