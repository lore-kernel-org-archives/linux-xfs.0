Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF0B21D3E8;
	Fri, 28 Aug 2026 06:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787897491; cv=fail; b=jawM5JEDWJJbwr7cYDewNtqGgw/lOVHuwxC1t1NB+FQdJ2yiQbg8AS1gBOBNTXNj7iBSKAFDLkPlBycLO6iAgIWDQxkj3W5TKUUFkLMNtqmWv0tDU7suKDRKi+99lgUrNP8cnPDHn9OLwd9RK2v4Uen1JllSenZuP1r8A5FU+F8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787897491; c=relaxed/simple;
	bh=+K45DBNv/eo187TiMC3regELrTlqMzr5xypiVRh5ppA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hc9ZGs2d3s2Ozah5O6/INUIOhPW0ZpJMV3FX/kSZOg63yfsBjdhO9z82joalFti+rG7EmX/+xf3Azz0sfkALpX7jLZ+Z1MzgO7qaBeBZvRrld+gseZ/rJndJgxY507YEB/eoVZyuLCDVC8Uqhp9pXIO0jJ+UTS7Db8chlgtoD4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MeRtZUTu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=qjzPgB1p; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MeRtZUTu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qjzPgB1p"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787897489; x=1819433489;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+K45DBNv/eo187TiMC3regELrTlqMzr5xypiVRh5ppA=;
  b=MeRtZUTucLSQaqOjDUMAOyRNrkJyJLACy1OrJXN/wgR5aWGNu/Wh+N7x
   +jevjhDzZlUwAm3abfiVC/DtihCsYYdMGY5VNwx3EDKue8o+cl5/zc3J8
   tJ5p1CVX5nFUst5pQ5B3N21Yz7Ygr1fqu6JU8glpPrpeHgWB/u6bjLF1L
   Jsh7Hi9olv9THZQyiusgQggxQOHZoALjoQJttFM4/sC1k/FFILhe4YpPj
   e39CO+YHqVNMYI5Hwtjb6Q3y/n69UuthKZcZpNjcmD+l0COGaENa3S81E
   FftF86UbEHw+Wm35Rp4pSG2gwLSQg06fJUjoXmwNrPL9GGVdXtWVzp3Ve
   w==;
X-CSE-ConnectionGUID: bW6szbtISaWi9Sx4Cxopbg==
X-CSE-MsgGUID: Wma/M4dDRuGmKM5QwpgVPQ==
X-IronPort-AV: E=Sophos;i="6.25,248,1779120000"; 
   d="scan'208";a="153483625"
Received: from mail-northcentralusazon11012019.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.19])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Aug 2026 14:11:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CX5cqgdDT1ZjhuvaMUb6XY+IDza5omBwf6ef/aufmBVaSgNHCXOXTMiJUjgA0YpQjOp9mFSgxs9S4HOiMOePjRmfZRW7RaHd10U5LLA7sbLRlvZiIK4Nir+yGsLiORhigt8J5Abs/taWrfUFD0ABOWcuTvYJQbEQJ+I0TKOzW+49SB77BMNG9QxgjGsgsnbHuzD5Yt4375EVhdG9V1G6z8WhG0G8IgQ5auz/3IB5I+30hK5dBJM10hK/vy31fxcoCJUkcdu9KvWvT7h5UGHvO4UtnnU9LiIkGPeGaxh2sMsbpcrD/008lM4E01bRNRuqI5GbuY+Bx7gC1mZwcg5c5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+K45DBNv/eo187TiMC3regELrTlqMzr5xypiVRh5ppA=;
 b=J0+QWa1CzPnE17mpyimCVOPMWEglXM6B64c2/G8uXxAkEm0ajtyuwVDPIo8rl9OdQ6W39ttmMsvmHUhjNWgrnPMgEPz5xc1zxfqeEo5cvuATSaj8gSLjdiR3Jmy9D8WIM6kcFWxH/HkpvTkPjyqUBaCKZsUgDZWOP/PF3zQng5G4GrPNhB2IjwQNpxXD7GsuAX2x3MNG969SQMjJM+0UeEgg3egJmh/RefWmliCHAnAThUaboOkJk9cVM//yQZWBulmLG7+dyL1Y/KKuQfHsrrY5XwbslQZD699Lp+V8m9IYgGbMzyY+0aRJeRPceGwQBD4eACZ88UqWwaNZMbhs2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+K45DBNv/eo187TiMC3regELrTlqMzr5xypiVRh5ppA=;
 b=qjzPgB1pJfa4J3EXvL8XSrqvTq/KDgy3ZISH69XiLMrEHA1p8g9XfF08pU9+Op5uGvDGijj6aFFU88Af9KHFiSiXUuGpJ/5+3jc1i5EhCYYi/6crFkFHBtPKtMcxK/n7FAhb3LyGc1wN3qWZzGfDvGBTEjzWddvSs4CSR3Vb1Oc=
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by PH0PR04MB8337.namprd04.prod.outlook.com (2603:10b6:510:4b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Fri, 28 Aug
 2026 06:11:25 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 06:11:25 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Zorro Lang <zlang@kernel.org>
CC: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/837: set rtinherit on the root directory
 programmatically
Thread-Topic: [PATCH] xfs/837: set rtinherit on the root directory
 programmatically
Thread-Index: AQHdNYjsFFzwPHFYeUOFwaKZtwUgP7ay/QiA
Date: Fri, 28 Aug 2026 06:11:25 +0000
Message-ID: <990686ff-6eb8-4898-bb22-492630d2cdce@wdc.com>
References: <20260826183001.GV839663@frogsfrogsfrogs>
In-Reply-To: <20260826183001.GV839663@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR04MB9269:EE_|PH0PR04MB8337:EE_
x-ms-office365-filtering-correlation-id: 2c9ef644-e0c2-4496-02ef-08df04cb30f0
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|1800799024|366016|23010399003|38070700021|10067099003|6133799003|56012099006|11063799006|22082099003|18002099003|3023799007;
x-microsoft-antispam-message-info:
 GwLkMzkk9/JNYry6mCj3EN2Ddq5zmQgd3OARM7rp24NzqW0i9/sjZmfIalgRW1D7ZokYtsUS4ce2asgKo29ycBT+uEfNJPT9mg4jV1Kx5soNsqYRTNMil9uGmn9+5Xil1zZv8fkO+GC2qKS2EKbTNhmzzN3G1hrdCv+G1usSsPxMtbgAOb51wj0nVw7W7AQy+u3cvf0UFFYIhck1WfVdieEmEF8R/aU70+Vopw1vVv4vMHpPAjbUXmcxFFow5AnyT/gzme+gaTZ4Fh+dAZvsZjohKgjoRzzuZVstj3bRrwsL1QOjC9189sEEEd96jN0rGWSlAjMMVJJ2zD5Ztz6D2KVk7nuHGchMIy4hmzex4L3Zj2tkoc0mXOIRK0EeJoia0rIpQpeNLzoQbJ47MFv3/MV+kQaR5q5al0O5t6lKexwWx58qCdIyFiWSiu7BSSZTuRk5+0CWpY+luXFYiTmYFxvzXpSFo1Yy4tEm73nVm7nUrlB8vzjpwzpb8XenT78o9mnXnpj3EOO1Cr6xybnMt9lGA/JfGfG2uNkyhbUL33b0PLLKZ5xl8LUPznZYAaQGg1bpb9r7C605vZpN151GcV6qtWJpItQXfwDL9DeNT8bzIwkyCDIIXyK6wC4d5HQB+A6oBr8bqTwNrOAYW5nQ8AIR4/VUVoltNOYnfRhfFsFJsogIqAoJnc9Z4aEX4NEbw23+OEDb+hbBtPKIdjA3YZDkCOLowRyBsY8ETusHjzg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(1800799024)(366016)(23010399003)(38070700021)(10067099003)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T1JnQ2loRDdGcFYySEZlRkJWNnFNYnFKZ3RtNmJ0eGpjMDhXVmlhcnlucGx4?=
 =?utf-8?B?WVpBb2hpQTg4WUdKMnp1LzhaZHUxbWhQc01CZlIrK3IyZ1hmdmRPZ1A1OXMx?=
 =?utf-8?B?Ymd2TVN6UG1lQ2xHdThuNll2SXBacWhXQjNDWW9ielNQcGxiaGVEdFAvOHZM?=
 =?utf-8?B?aGhQZTh0bnV5M2NzQTM4UXZrNXQwdS9WS3Rud0lubVhxejhuYmZkSXlXaHFn?=
 =?utf-8?B?bHhOb3daNklrMCtwemRXZE4rbkdOdmt3R2VMSUYrbE0zM0FlSElja2dKeVJw?=
 =?utf-8?B?UnV2Q1hTTm5ZMHNSNzIzVGFaZWtTUy94N05vVWV3TkJaU3h0QmtSdjBuRWFq?=
 =?utf-8?B?VnJjNjZJcDhvcXVNWXdaOTA5UUNJOE56TDVKV0dvSXFtWmxxbjBXWlZHWGVZ?=
 =?utf-8?B?R0F4aURrMDkrL01aaUQ3WDhxaTBsVkpJem0rZGd1V1NWVWtVdmxiakh1WGN0?=
 =?utf-8?B?SVpwbEk3ay9XY3BOUGVZdXEzYVdyd2RhVFZId1kyMXNoUHcwMkxiZEdlODlE?=
 =?utf-8?B?SFQ2OGFrM04wMFdHM1ZGbGpPQzJ6UnpRS1daT1pTUHZ6c2hiVEg0elRWSDR1?=
 =?utf-8?B?WWxEcDgxLzJVZHR6dlk5b1c1c3cxUkcyaEYzUFhhd0lzY1FNQ2lGN21ZTkNv?=
 =?utf-8?B?ekwzdmhDc25yZnpHbzgzeWxqWTF4T1VoanJJMXBvV003amRiZ29YKzBWQUVQ?=
 =?utf-8?B?YW9oQmZtbjN6R29ObXRhaUU3TDdrcVJHMWZqWU16b1MxaDNRVzFvK0dwL25i?=
 =?utf-8?B?Z1JmQTNJblZMeHRoQlF5d0NCakpCc3dIemU0MExWMWM4Vm5ONzUzWUxHZkZP?=
 =?utf-8?B?R1NHblVCUzNZTVNNWXVIYWhSRmU1RUYxUEhJVGJSaUxFOXdjS3prd25jY2Zm?=
 =?utf-8?B?NllwN0F3UkV0aGlpMEo4YmgvU29XQWxaZjRwV2ZqMjZlTGkzbnNEKzREOUVY?=
 =?utf-8?B?M0w0ejlHU0lVTHh2dGhEZGpqcTBIYXZPeDJ6VEppdERxa0pQaFFmdUNJcXBY?=
 =?utf-8?B?MDVhMk5NTmJJYWtwVUQ2a1JNa2hyVGhxbDFtazF3VnVudXlaeXh1U1hodmE2?=
 =?utf-8?B?VWcxK0I5WEpUL3VNRVlZNEtGNHFZcGczYmczNG1pRDJvQkg1b291Z29OejZY?=
 =?utf-8?B?SzhoaW5xWHdGL3RpZElQL1FnTlBKSlNJNmpKVUgyNlRyYVRpWFdYVlNpVC82?=
 =?utf-8?B?WnVVSmVPL08yTU5hVVBjbWZ3bW5LSkJ5NUNhY09tU2R3eHAyNlFSVVphN2xW?=
 =?utf-8?B?QmhiZVRXMXhsRG8xWmpwam9UU3NBRVNKV2haSnRNSlZBamZsTDN2NlVFNnQ4?=
 =?utf-8?B?a0dlWEk0bk82cmU2VStUOVB6WmQrRTNzYmJ5WDM0bEx4aUVucmxOcDdkSU9i?=
 =?utf-8?B?b2greVJ4RDZ6dGIxZTBnSzNyL2pqSGdFbmJFLzRSYXRJRko4SnUycEg1TnF5?=
 =?utf-8?B?SVpMdWhDMmxaaTA2SFFPS2RnU1VKaEVsb0l2d1RINVRjci96T1U5T1IvQ2Fs?=
 =?utf-8?B?VzErREdmNEV2Wml1Q0FHRU5QNnRQSEw2RnlHaUJwMlZoUlVEMGFoOVh3RDl6?=
 =?utf-8?B?Y3c2azgvdkVUSURsbFJuMVZ6eFM0emRWNGJoSmpqQ3NsUmxIMUJkc3M0Y0p6?=
 =?utf-8?B?OG9JbCtoMGdCajZwT2IxRlpEY212SEo2V1Rzc1RlVU5IZ2o3VFdLQWVFbzFx?=
 =?utf-8?B?VWNOdWhqSXRRWCtCci9xQ3dwdmluakMzSFJKVGlvMWFvMGJ2OUdlWWRQcEdL?=
 =?utf-8?B?bkFRN2pMQkdCeWlnbDB2NGlMSkFMQml3TnQvVW9XQkYvYys0b2cvWjJyTkkr?=
 =?utf-8?B?eEJGamdFSWNjQ2YrMVp5cmtIWmFwNmVQWTBYSWI0Q3VmbjdhN1VUMHBpamFY?=
 =?utf-8?B?Zm5samdyOTZpVHFscWViWGVUamtVbVNzTWtWYmNMalRnb0E1aHhMNnFWTVpr?=
 =?utf-8?B?cURocFpjeTNLYlpKb2g4a2RkbmJyeEo1aG9xY1gyMThJeHlGbjQxVjRZS0Yz?=
 =?utf-8?B?aHB5WU1NeW1rZE12ZUxOYStvRmw3a0gzUDhKZDUyWjZxdllHcVZybFBybHdh?=
 =?utf-8?B?bVNTNmhKQ2VMQnZQU2dNYU9qVjBWa2plbzF2bXpHclFKVVhveEVOVk55aWsw?=
 =?utf-8?B?YXVsckkxVUFUd1o2SzBtc0MzZ2dHQXhTM2lhdHM3djIvbVppK1B6M1BmaTdP?=
 =?utf-8?B?NDQ0VjVkWnJ0b04rd3ZvRlljUVp4U3c0QjRVUFZ0NGpBY1dKM3dkTXJadGxN?=
 =?utf-8?B?bkNvTUVyblBqZCtaVnBWOUpHQkROc0cvSW1jSWF5WURVT20rbGxhZWZXWnVv?=
 =?utf-8?B?UWt4dkNHNHRyWDRxSU96bTRnR3NsbDBNeUFUVEpkK1ZMMW5CY3lqdU9lM01G?=
 =?utf-8?Q?Pz0ImeuWqxPh7vhQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <723758783706B64C867A69FDCA986041@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	zYBgctP4VS02eheSIwkX2lqVpBBkygSW3qlgKpZBnDCOuj9m/lVyU5aGn+t8SqCZ2vdKQyIhixZwQJUo4PdvSzDnDFrkHX7b0IwRIRjahyvJOgOMsOJkMcIkbsKgUwgvhIGFXCFWhiPZ55KzmnuskERv6/kGb5ApEjMSlTbDUJ5WMq9Rzxk3cbEd0PltaaCjyobVN/59WVYMhxvosJrVVukcRdR63SKEKd72Q9HF+uV4Lvf5k8lbiD/xcIRRsvbiBuCRowZzaUevsHQLVkXm4nVbZIezWtN+wEZzliYF1hSgcaUW6v63L+ijnNTzy3et2wnmC0fhVDIw8W4hOM6d2w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IWj/czXT2PTV/atlG3tat9gokA1Nv8S48DGc2iLEHz1Vv5qJGXZFPl5Ae2ddJ+uTP19K+9/r4Mx+Ewrl2062snwXd0TaQTIzsmVWpsK86mAaE0wqYDRRMUD7TwWm7CWJeBPFcL3WC9gVffeQN447bQQHGnWYKIy18fWEjWqZvCs7NNJFOUw6zi4nqGpSfcaGd6MO3MAzTly6AOrw9VuMs0/Rv2O/4wGjsESeFvDNuVg9AGTVPzSaw4PvcvlG6wlqM83mL7FFS8xnQ6OTN8bfARCD+AsVauSSJMPZlM7ecCu7794TstBWcxWiCUJx4aLqqh1TM7P/rp2WbRGFPjvh7wQU0Yie+s3DiL9nQGcRIPWv+yjVaq39adC0AgqU42ZxH/IlJ+fbRe+4Qk/iofBHWKRvlXq7nm8eJQzp3VcSOiYkv7gMG7gbWI9l9IT0aIq1MPmgWpl8ykNvq5M0DhxNaFUjTVSD6RWQKvam9FtnUGmNXHYMSpVquJSpC9He7CujUs/QDPU704I9Qf3+xiOoxAg0kpb6DAJD8R4l10RjUZM5Qocjtlp/vbi711SBEonXHsZPzztBLpeHlzWT+7kyRX6m1hlD6Ihxzfzw3ugvmbNbtkEQsGjUo5YiiCcz+uof
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c9ef644-e0c2-4496-02ef-08df04cb30f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2026 06:11:25.4732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S2H1wMDnA94q7/NGSun9XgLIlEy16KUXYLZKqSTzPl8wSASKCY6/7vJdD0cDnPeGvtViweKo7btSr6UvINakuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8337

T24gMjYvMDgvMjAyNiAyMDozMCwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBGcm9tOiBEYXJy
aWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3JnPg0KPiANCj4gSSBwYXRjaGVkIG1rZnMgdG8g
ZW5hYmxlIG1ldGFkaXIgYnkgZGVmYXVsdCwgYnV0IHRoZW4gdGhpcyB0ZXN0DQo+IHJlZ3Jlc3Nl
ZCBvbiB0aGUgIi1tIG1ldGFkaXI9MCAtZCBydGluaGVyaXQ9MS4uLiIgY29uZmlndXJhdGlvbi4g
IFVwb24NCj4gZGlnZ2luZyBpbnRvIHRoZSB0ZXN0IHJlc3VsdHMsIEkgb2JzZXJ2ZWQgdGhhdCB0
aGUgc2NyYXRjaCBmaWxlc3lzdGVtDQo+IGFjdHVhbGx5IGhhZCBtZXRhZGlyIGVuYWJsZWQgZGVz
cGl0ZSB0aGUgaW50ZW5kZWQgY29uZmlndXJhdGlvbi4gIFRoYXQNCj4gaW4gdHVybiByZXZlYWxl
ZCB0aGF0IF9zY3JhdGNoX21rZnMgd2FzIGZhaWxpbmcgYmVjYXVzZSAtZCBydGluaGVyaXQgd2Fz
DQo+IGJlaW5nIHJlc3BlY2lmaWVkLCBzbyBpdCBkaWQgdGhhdCBvYm5veGlvdXMgdGhpbmcgaXQg
ZG9lcyBhbmQgcmVmb3JtYXRzDQo+IHdpdGggb25seSB0aGUgY2FsbGVyJ3MgbWtmcyBvcHRpb25z
Lg0KPiANCj4gQXMgYSByZXN1bHQsIHRoZSBzY3JhdGNoIGZpbGVzeXN0ZW0gaXMgY29uZmlndXJl
ZCBpbmNvcnJlY3RseSAtLSBtZXRhZGlyDQo+IGlzIGVuYWJsZWQgd2hlbiB3ZSBkb24ndCB3YW50
IGl0IHRvIGJlLCBzbyB3ZSBwaWNrIHRoZSB3cm9uZyBvdXRwdXQgZmlsZQ0KPiBhbmQgZmFpbC4N
Cj4gDQo+IEluc3RlYWQgb2YgcGFzc2luZyAtZHJ0aW5oZXJpdCBhbmQgcG90ZW50aWFsbHkgY29u
ZmxpY3Rpbmcgd2l0aCB0aGUgdGVzdA0KPiBjb25maWd1cmF0aW9uIG9wdGlvbnMsIGxldCdzIHVz
ZSBfeGZzX2ZvcmNlX2JkZXYgdG8gc2V0IHJ0aW5oZXJpdA0KPiBwcm9ncmFtbWF0aWNhbGx5Lg0K
PiANCj4gQ2M6IDxIYW5zLkhvbG1iZXJnQHdkYy5jb20+DQo+IENjOiA8ZnN0ZXN0c0B2Z2VyLmtl
cm5lbC5vcmc+ICMgdjIwMjUuMDYuMjINCj4gRml4ZXM6IGUyMjU3NzIzNTNlMjEyICgieGZzOiBh
ZGQgbW91bnQgdGVzdCBmb3IgcmVhZCBvbmx5IHJ0IGRldmljZXMiKQ0KPiBTaWduZWQtb2ZmLWJ5
OiAiRGFycmljayBKLiBXb25nIiA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgdGVzdHMv
eGZzLzgzNyB8ICAgIDYgKysrKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGVzdHMveGZzLzgzNyBiL3Rlc3Rz
L3hmcy84MzcNCj4gaW5kZXggMmZlMTk1YTAwOWYxMGYuLjMzZWMzN2FlM2RiZGUzIDEwMDc1NQ0K
PiAtLS0gYS90ZXN0cy94ZnMvODM3DQo+ICsrKyBiL3Rlc3RzL3hmcy84MzcNCj4gQEAgLTM1LDcg
KzM1LDExIEBAIGZpDQo+ICANCj4gIF9yZWdpc3Rlcl9jbGVhbnVwICJfY2xlYW51cF9zZXRydyIN
Cj4gIA0KPiAtX3NjcmF0Y2hfbWtmcyAiLWQgcnRpbmhlcml0IiA+IC9kZXYvbnVsbCAyPiYxDQo+
ICtfc2NyYXRjaF9ta2ZzID4gL2Rldi9udWxsIDI+JjENCj4gKw0KPiArX3NjcmF0Y2hfbW91bnQN
Cj4gK194ZnNfZm9yY2VfYmRldiByZWFsdGltZSAkU0NSQVRDSF9NTlQNCj4gK19zY3JhdGNoX3Vu
bW91bnQNCj4gIA0KPiAgIyBTZWxlY3QgYXBwcm9wcmlhdGUgb3V0cHV0IGZpbGUNCj4gIGZlYXR1
cmVzPSIiDQo+IA0KDQpMb29rcyBnb29kIHRvIG1lIQ0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xt
YmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KDQo=
