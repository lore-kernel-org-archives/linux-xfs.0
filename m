Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE77B2BEFEB;
	Thu, 29 Jan 2026 05:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769664431; cv=fail; b=HGdpsgZpYdBiNpxzkCJEX3O3JgJYSet8ugCk8gPyNiZu4o5w/Sd6u7KG/w6XxkZ/b2s4UJzWduSM3CIKQb2c8Sgqx/Y6aASm/0z0ZPUuamHq5p006/mNpE8RzQgmY8xkScezqtHphNL+/EgxsTOWJdv7od3w4/Vx8CTWLoyw9kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769664431; c=relaxed/simple;
	bh=4Q93ctpSGkCATlBgfS5vW/xYe6FHMduBn2uW7xzRGDk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=diZb6T1HWTEuOmMqrjpChS2njA7ICjkiWBPK1ZEt7OmlRJN+SQDS/fCnE1LPuucPZu2tkwZZdph0kRF31kOjLYRcJ9Ge1GRBL5y8/Tt+U48U1rpnruRNJ5PX5DKLD4futiLnUcanKvOvDcbwGSW3DgRXXLavnCBSjojATQYTiF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PSML3Gy9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=hGyMWO0M; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PSML3Gy9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hGyMWO0M"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769664430; x=1801200430;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4Q93ctpSGkCATlBgfS5vW/xYe6FHMduBn2uW7xzRGDk=;
  b=PSML3Gy9p4sJ0KC3OwHCMo3wjYSnrPGCleZTBY8pxB7eU2unFZ3dlo3V
   2jv9JAp0JE3r1CAabmmQTGLUlIAW6JfIFMA44lA1NxEInjQFqwoEgvjHf
   JkrTw1tt2AWJUH49uikDatGl5kimzLRCEcEpf6G4m1HuJI7UlxZz3Ttbf
   MypXc1vTvKP0Yc1jNDFvsuF5nGooTQ6cTJWtvpWmIqyhxMoYNo0YxHYx0
   nnEEZg1fYxPvPOwiGF7v90vIC6xn+6wV3DB8vdHTPPiR2XfUkUnhiPkwD
   BcvJtr0oovDpaijvAtUSfxVYzlmQMBtLYpxcb7IJ5axmpDoZkIRL8ufQr
   A==;
X-CSE-ConnectionGUID: DAIjT4pUQruIt2h7ZzyIxQ==
X-CSE-MsgGUID: pgnQY98oQn+a2NjG9RGiVA==
X-IronPort-AV: E=Sophos;i="6.21,260,1763395200"; 
   d="scan'208";a="140339612"
Received: from mail-northcentralusazon11010035.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.35])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Jan 2026 13:27:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YzontVIwaG8GUbRgG7vnB3XoanuPMCKUQzGTIyD3hSgSMc1c7WiC2p//iumhja1h0oziwdsCP3S2SIDDberjAZZsZ5UHLdMqGOD+g22v3O1Y2jeKQMcd2AdMWJYm4oQgss8tLnx+CjUpLR73HtAX8zeVaq+oGl0Mhgq2Sj1W/bHYqFDqiU+wjeVv4wDoajB/3nx52BPFmfFIMwoGZb721Ns84hYq4gJ61YD3nUCaB7CZaAZ2/u+Meu9MLq7a6LF8msJ5pIwCwmbWYvC6TjyJnaz1Y7+MvDxKSleBRYNriQT+6hpqs7YcJVr/SdnISgVnfjKBR/fP86k2FWRHwbCR/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Q93ctpSGkCATlBgfS5vW/xYe6FHMduBn2uW7xzRGDk=;
 b=uUmYyHKYIpRN6g7oJcVLsE2fPZpBM4VuPhHdJ3qNqWu92oxSoSi7cj4WwyHrJ0+c4ZQ0ITSesPS4ND2UOgrtOHeoIFb/FPUugqcr5ntoXpECPYCi6CwU5yFpDItnutn086VVatjyIv9dsLNsnFTzPjJWsLZZLnD+2d1ejyDDJ3LKys80yz2ABWw/1C0LhfvtVjFGiRuEm+0IVJQnFvZNbnmw6mYvoUU+jcu/Vj3UnOzaL77REu3jUyk2f/lTN9UYtsGv3QaPich2rCAfUgYxp3r7AS3G1YANIXQdVyiclNZuSbRqNKjve/watVvxGb9A1icnBBAZL8HqNYiaSbxMGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Q93ctpSGkCATlBgfS5vW/xYe6FHMduBn2uW7xzRGDk=;
 b=hGyMWO0M4wMLFtYpI/MlPBj8tg6FHMTu3NBWPikk8TzccZ5xNxEuqZpg9cyTZGk/CkP9x8VHyt4PwGCtJwUG0bXusK35+xBzK//sGQqQp8YlNSnvoX6pIiGEv49GPJkYsrWK3T9qTUfYOXZ/wIgrzJsuzm891xeSYB0I+eHG5RY=
Received: from SJ2PR04MB8536.namprd04.prod.outlook.com (2603:10b6:a03:4f9::11)
 by CH2PR04MB6872.namprd04.prod.outlook.com (2603:10b6:610:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 05:27:05 +0000
Received: from SJ2PR04MB8536.namprd04.prod.outlook.com
 ([fe80::8820:e830:536b:b29a]) by SJ2PR04MB8536.namprd04.prod.outlook.com
 ([fe80::8820:e830:536b:b29a%3]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 05:27:05 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
CC: Kunwu Chan <kunwu.chan@hotmail.com>, "rcu@vger.kernel.org"
	<rcu@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, hch <hch@lst.de>
Subject: Re: rcu stalls during fstests runs for xfs
Thread-Topic: rcu stalls during fstests runs for xfs
Thread-Index: AQHcjrclowh1moKuUEq8Mwy02Ri3kbVnWueAgABxzACAANWrgA==
Date: Thu, 29 Jan 2026 05:27:04 +0000
Message-ID: <aXrl46PxeHQSpYbX@shinmob>
References: <aXdO52wh2rqTUi1E@shinmob>
 <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
 <fc611e8e-0da9-4b88-83ef-092d300307e3@paulmck-laptop>
In-Reply-To: <fc611e8e-0da9-4b88-83ef-092d300307e3@paulmck-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR04MB8536:EE_|CH2PR04MB6872:EE_
x-ms-office365-filtering-correlation-id: 1e55b99a-7ab6-4388-4625-08de5ef70a0d
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y2QzNk1hQXlMVkw4SmZVSEViK0ZSbTUwb1dWQXJvWEttSUxaL0J3c3VRYkJp?=
 =?utf-8?B?dFFUNDV3OStTY2h0ZnVvKytKcW9ocDRmejBHQWsvODI3MVpZSUEvNTJQWkFa?=
 =?utf-8?B?NlFkeUNRWVFsMC9vdGl5UDBVRFFaZE8vNmcyNnRHdm1QdnB6bGRFc2ZtbmhN?=
 =?utf-8?B?ZmhJL1YzcTl6c2FCYmw0Q2J4cndEcVZ2am9xRFl0WU9BcGwrd04weVdKM0Rr?=
 =?utf-8?B?QVl3UDN2M2lDcEdDR2owdFIxQVh4aTZBL3htUWUvdUM2Y0J3a0ZueGNIODdC?=
 =?utf-8?B?MnE3UkVSWmlsWHVvYzRxZzdBbjFQQmI1WFdCcjdpVVZlSG5Nbm1yMzlwWHlL?=
 =?utf-8?B?bWdzK1NxTjdod2pCNGUxUCswalFGbk5jWHlKQ2RhTjZsWGFhZnN0RzNTSlQz?=
 =?utf-8?B?UXBNWVJPSjV2Z1ptcnRwRFJINzBNNDNid2xMKzZkMTlFZTUvOU1lNjVpNndq?=
 =?utf-8?B?MTBpQzByUjdNMUp5dVZCOVdIdldETkpIV0NyZnJLZWFURzNoUU1RNkMyck9u?=
 =?utf-8?B?bEp3R0xSTGs3cE16eW9HYmF2UWlsN296OFdaclZFRWtjbFd2Rms0b1Uyaldo?=
 =?utf-8?B?azBBRUQ0bklkNDkvL09PSU9ZWk8yRjZLU3lvNUY0RndpN3lRZTUvV3lXaWRl?=
 =?utf-8?B?WGt6c09vTGxqWmpEUmtNL2lyZTlvVXBHalBkTndzbnJ4Q0xickpFNE5BWXBr?=
 =?utf-8?B?M3VXVGh0QVB5WmxxRkg1YUtuUnlFTElpWG1CN0lDa0lXZ0tTWkw4L1hERTVE?=
 =?utf-8?B?MDVMeHByV1IwRFRZWkV2WjlGSXZQam9wTGFSMTNqcFF3MkhPOEVXcmEvWDN0?=
 =?utf-8?B?OVFzbjJMZnFyTERrdFhoQmZYeTQ5M1JhVC84U2pvUHFBMWVpYUNlSklwVlRK?=
 =?utf-8?B?R1hDL01zNmVsZk1mK05UQUhPQ3k4eDB4VytZaE9WcGZKVkxXNk9mWUYyZE5K?=
 =?utf-8?B?Y0t3N3lJR1RTRTRvL1Q4ZnNmelI2T0dWWTFESS9TMWt0ZW5NdkNVSGlJNGJv?=
 =?utf-8?B?Ly9nNlV5eVRDWERoaFd3alRFcWZ0NklSb0dPeUovL2JHNVhsR3VsdEE2emJP?=
 =?utf-8?B?a3dLS3gzNk44MHBacFVVeGtPekJtd3k1eWVId29tQlk1SUVxSHdZRi8zR2dP?=
 =?utf-8?B?ZDdYMFM2akczdFVMSU92SmVTTHRSZ1J1Wm9zZC9QRDhMV044TThDU1ZDSXhm?=
 =?utf-8?B?ZzFQVGZ4d0xsVUluVG9YVnQ2eWs5SjN1V3JidnJpRCtxM2l2ZEFibWp6VG9r?=
 =?utf-8?B?eFZFUmNObGd3bXNlRE9PMEY3MzNYM0J0bmYreFpOOUx3QmRXbUtoNnNJTWVF?=
 =?utf-8?B?WnNBT1I5clpwUWpuWVRyVDhLNFlXNEg1SHlGWEp4dnlEUEg1RHhwTS9JcHpU?=
 =?utf-8?B?d0EvSWFaOWpsU2xGVm9yalgzd1MyWlIzYUNLUlljNExRWExVWkR5L3hsakxK?=
 =?utf-8?B?bWRJQmJXZ2ovUEVQVWFidElsejlVT2hMdjk2MEFNajV2T1Nic2JwSnAzS1p5?=
 =?utf-8?B?TTVVaFVHOGRHR2VEdm9Rdnk4aEJtdnZjQkdmTjB2d0k3bU84c2Q2eitZL2RU?=
 =?utf-8?B?SEZ5OTI0akgyQS9hMmFhd2lOZXYyeTdzdVUxVm5OZEN6dE5kQUl5UHdCQ0Vu?=
 =?utf-8?B?ZWVVM3J6ekxyeFhJcG03dzYxVC9oM05PTTJkM2NBdFV5U1l4SXJhOGlkN2pj?=
 =?utf-8?B?YWpOSzJETU5nbXhaTzE2blE4a2hZdlBPb1g0Rk5uVmt2UVFkRXpSaU1aZUg2?=
 =?utf-8?B?elBrR0pKaWRFVVdlMWxuZlVkUnh3YUVSeld2VHY5SlBuRkhHL0RhVVlFYllu?=
 =?utf-8?B?eUdtL0xGYy9hcVZKUzB0U1hRL2dxeVJ3MGNwL3N6Rlo3Q3c4RDdTZW1Fb2U4?=
 =?utf-8?B?cXNUQWJyRVFGeWxNK0pINjlOcFNRaHdJSk0ycVVlOVp2S0hGdnVrRThUVkl3?=
 =?utf-8?B?MmNGVUtHTTIxSDFLTUgyK2gwRUQxU0pJUUUrcFVFVlpiRi9FZ1U0eDJxNC9K?=
 =?utf-8?B?Q2VucHVPcC91VEVOcjRtQURwKzVtaDJwRWozMWRPU3hiNEhGZ2ZDSDZEUmhh?=
 =?utf-8?B?NDYyTkJaekd5TEMvSGQxYzdxTW5RSUVNQmVVaUFENFhVanpDTnlFSXR5WE1F?=
 =?utf-8?B?NVl4L0JQS2tFOUh5TmY3cUhJLzNHT2d0YkloeVNHbDJWUGdIcnc4aVEzL0Nw?=
 =?utf-8?Q?8ssYC8Lbz281EWugffiX9TVioEcAyyZvpZx6rd9x3xMI?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR04MB8536.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SzBrRFM1TElTaUM1OGRJS2pIbmN1YTY4dlhVSWUydkRsT01oM2gvV3k5MnFM?=
 =?utf-8?B?R0VvN0xyVi8vb3BHbkdzMkFweHRVME1LT1RaaExmT0JtbUtYT3NBYkhxZGV6?=
 =?utf-8?B?Y0FGcE1wRXBxaUt3ZW1KU0ZpNXZMZytiS0JoZVJ1R3NBalNTUTNjTFgyaFly?=
 =?utf-8?B?ZWVWT1hiNkpZaXlGRWRDanNyTXkzamkyNHpLUDFPM28xZm9NQjJSa1k4bWtQ?=
 =?utf-8?B?NmJqSmhGQkJDamFZZXVLM0VCSUR3VSt3UUR0azR3cmNyRWo0KzFhRjlYU0JY?=
 =?utf-8?B?ckpnazNENFVmVlE0ZVdWK256K1lrQUVINkFLaGxDZmNCVFFaY2RmeCtUN1g1?=
 =?utf-8?B?eXErU3NRd1lRNDBjNmdaOVlvaXZzb2FkWXNRay9tSk8vbFo5ek04N29XTEJk?=
 =?utf-8?B?dVF0bXcxN0xMRTA2Tmw2VjZoZHRNMmtYVVF4UkJwZDNnWTd2UmJ4SzJTd2hK?=
 =?utf-8?B?MXhyWlBLY2ZWUHFMUVhxS1RRYnNFeUpIWFFRMHJ1N3NlM2hiYkg2c245SC9F?=
 =?utf-8?B?VU02WlRMY29KTDNIMU5TdVZ6WTdQQjFFOWFBVjg3THBiVGdueVlYNk94VzBB?=
 =?utf-8?B?N0JENlVkOHQ5dk1UWXFWdlB1ZkVYQTdJMkhLNitEckp1S1o4UFB5ZHhTaUl5?=
 =?utf-8?B?SnZXWVh4YW9oaWg1eWZyQlRFMnFndTBkdmlZUzIyd2VhdUNObTF3R2pNK0Nk?=
 =?utf-8?B?bzhTRUxjK2ZSWEVlZXJEaDN6Yk1WaHdqbWhuYlBVdDlaa3FhNzZwc2N0Yisz?=
 =?utf-8?B?dGFtZEVOdWdkMDRNcWhiZmxvMjlSaFpuOHlDc0F0T2E1eithUUU5Um92WHZl?=
 =?utf-8?B?eFlmenNKWlVraGtnQmoyU0FFNzlmdnZ1QzJyRTJoM25XSFMyVm50dEVzRW5K?=
 =?utf-8?B?N3hIVExyWWlXbW1YbHA5VENMODNBVG5wWERNYmhnNzdNek90QTU3cDArUGVm?=
 =?utf-8?B?dTliSUhJQldoUWZtMlRPeGlWVkJNT3dHcTVrL2hRRGFkZkdKSGxLM09JR0ZS?=
 =?utf-8?B?Vm1mTkp5ZE5jc2RaSE1ZbjJEZ3pZU3BUc2Z4T3g4aFNaRU1kbW5wQzRXdmRk?=
 =?utf-8?B?cmZqczJCNHp1WXZJdm1KSTUwTWpkT0FRUGd2cWdOV25wUS9ucFBLSXhIdTFS?=
 =?utf-8?B?ejJSNk55dkUzdFM4U3RIQVZPRzNHTUR3LzJ1QThLSWlBWEE3SGpKL1JlWE1Z?=
 =?utf-8?B?SEFSSkFvT3pMT0VlQmFmbGhtb1QvbE9uTU80MWJmQzV5QXpSLzFCbU9iVER0?=
 =?utf-8?B?eUZCZ082QXZOQmdzckJ4UGpMTFBCZXJpS3BKRTk1QnJuQkNZR3Z0ZmpBaG5J?=
 =?utf-8?B?U2JQeVAyZVlxb29wTzd2NG1MQ1g4NWkvS3hqTTJhakM3dU80c1hjcFVVc0xT?=
 =?utf-8?B?N1RCcy9aalQ3U0xVZ0VpY2ZQSmRSeFFDY0ZBYVJlR0J2UWtxTExpK3Jha29G?=
 =?utf-8?B?NGtTbWE5a2h2K1N1ZHB5YXJMTCsvNzc1MDdFSlNlRm9lNWJuOU40WU02dFho?=
 =?utf-8?B?aGw1UFd3NkZYU3FsLzZxckozaU9uV3dmd0JWZGlXU1pIbHVwNStMcE14Yndh?=
 =?utf-8?B?NWN0eWNKTnE3S0lydlNzVjJyTmpXUzhDeTVyUkViend3UVVRdVNYM0xwWTRB?=
 =?utf-8?B?bTlrdEtHc0N3RDJGTkJXekVYTkh0VFZaMkNFRG4rc3ZBK211OS9CQjkxOGw3?=
 =?utf-8?B?SzNqQUtIalc0M1pkUXhYQjFTM0xPRTBkMFpiL0pUZUdIUURMNC8rUmljRkhU?=
 =?utf-8?B?QmQ5Y1lGa1RxUC9acU96MmphQ1NvZXY1RlcyRjkzMHRIWnBzcG55SE50YjFp?=
 =?utf-8?B?Y1NYbjJCSmpxbDRRV3VkbTdUQy90OGxEOU1BckQrQ05pYUhzWi9mR01Yc3Bp?=
 =?utf-8?B?SjdFb0hBSDNJUnYrWERsQUxrK08veXh6QkxkNWd3WE5DRmRsQU1YR0lNRGZU?=
 =?utf-8?B?OWZ3a0VxLy85ZjQ1QVVoaUp0QlFPY2pPY2cyaGFiVzRncUVXVzhvZDhqQmpw?=
 =?utf-8?B?MzFVL0tEZTNmVVdTSGptOEtKWm5zQTlEUXVMUWtHbmNEZkF3d3NEeC9ENHZa?=
 =?utf-8?B?YU5XTEM1Ull1c1Zkd0VjR2tRbTVmTlNhWXdvQ2szTmdzK2gvcFhyTGhLY3Np?=
 =?utf-8?B?cFhMdnZKYlN5VFptWTR1YVBWMHRVeUpBWEoxd0tTa3UwODlaSnpUSDRyeW1X?=
 =?utf-8?B?a0l6cDg3d3BRdVFpQVpaY25LTCtiMmp2NmJ6VmpLZVZHVFlBS3A4ck9UUWxH?=
 =?utf-8?B?d1YvV05XTWVleFlCQ0Z4VVE2VGpIelNBci9jb0tlbUZ6aXhLcitZaE5BYTM4?=
 =?utf-8?B?VVVDV3p0U1VWZ3FKb2dwUk5UM0xuWmtOZHU0YytsTnRuR2F3TzhyZkQrQmpB?=
 =?utf-8?Q?Vdgk2EqOlfglbbbQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <898CA8DA9FEC8342B83C746B54E0A1A4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/1Mm2Aze+9gz35i6l3EJjBJoKADTD6OEIRy7PMmUQIdgAt7W1Wu1aAR1GCWws5b2T0y2leEIOtuz1EMslEFnT7YfpbsIuk2/5pm6A2qcwhKFZOoBrReiJCbIbNeeuhmLSpxjrEV3GJbvB5Pg6SiBDzunaB5kBnSapVGlv6/PbbORjFrHMKxCwlg2aTbM4Jb+BEhQlc3p5SG4fOgdKKNV4BPSE+fLdncnftWqU+tK4+HinqtgaANoNDE/apxfCf5+hAuDzWX/KUhH0a+uk4VNFV346dMougWHO2VXFZiiha9aIrZB+8u2Dzb0onaX12r8KXIhxMr0Ed9fCQLMwRKKwDNZdvzw2zy2XO9WTiiB+nkUJU0OaPZbTm6+vnvv29lx7DTeQ8iUqigU/zF6ijySyF8wmqzK1s77ftsZnGoEwe0Rvywr1EjsJuZnKmFrVXrdqOpZaXljM5rdVdnip3kVrFnPApRURWoxupDPR2AkyE0fLSmgGY/B3qFJSJKfgBrTDduJtKRFA0cInUS67zNoJh1tAV+TYi67XWaSW0K46Dy2xp0PPw5KRLW4c8ZGllJbw22w6boqq3AYO0B5FEJo1BdrJorbtTi+FBU4XHwrWKRon04ZEvjwRXzLqnZnJg7w
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR04MB8536.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e55b99a-7ab6-4388-4625-08de5ef70a0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2026 05:27:05.1707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w6yxl1jUeJFCFRG0EYMMizbMgrEquUTV/4d3nEv4qQo5QLbvipDjvMaDofHWwgtcERR9vSL99N8plE8tPz/Y+OS5uF1AJsq27ZiIhHyAk/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6872

T24gSmFuIDI4LCAyMDI2IC8gMDg6NDIsIFBhdWwgRS4gTWNLZW5uZXkgd3JvdGU6DQo+IE9uIFdl
ZCwgSmFuIDI4LCAyMDI2IGF0IDA1OjU1OjAxUE0gKzA4MDAsIEt1bnd1IENoYW4gd3JvdGU6DQo+
ID4gT24gMS8yNi8yNiAxOTozMCwgU2hpbmljaGlybyBLYXdhc2FraSB3cm90ZToNCj4gPiA+ICBr
ZXJuZWw6IHhmcy9mb3ItbmV4dCwgNTFhYmE0Y2EzOTksIHY2LjE5LXJjNSsNCj4gPiA+ICAgICAg
YmxvY2sgZGV2aWNlOiBkbS1saW5lYXIgb24gSEREIChub24tem9uZWQpDQo+ID4gPiAgICAgIHhm
czogem9uZWQNCj4gPiANCj4gPiBJIGhhZCBhIHF1aWNrIGxvb2sgYXQgdGhlIGF0dGFjaGVkIGxv
Z3MuIEFjcm9zcyB0aGUgZGlmZmVyZW50IHJ1bnMsIHRoZQ0KPiA+IHN0YWxsIHRyYWNlcyBjb25z
aXN0ZW50bHkgc2hvdyBDUFVzIHNwZW5kaW5nIGV4dGVuZGVkIHRpbWUgaW4NCj4gPiB8bW1fZ2V0
X2NpZCgpfGFsb25nIHRoZSBtbS9zY2hlZCBjb250ZXh0IHN3aXRjaCBwYXRoLg0KPiA+IA0KPiA+
IFRoaXMgZG9lc27igJl0IHNlZW0gdG8gaW5kaWNhdGUgYW4gaW1tZWRpYXRlIFJDVSBpc3N1ZSBi
eSBpdHNlbGYsIGJ1dCBpdA0KPiA+IHJhaXNlcyB0aGUgcXVlc3Rpb24gb2Ygd2hldGhlciBjb250
ZXh0IHN3aXRjaCBjb21wbGV0aW9uIGNhbiBiZSBkZWxheWVkDQo+ID4gZm9yIHVudXN1YWxseSBs
b25nIHBlcmlvZHMgdW5kZXIgdGhlc2UgdGVzdCBjb25maWd1cmF0aW9ucy4NCj4gDQo+IFRoYW5r
IHlvdSBhbGwhDQo+IA0KPiBVcyBSQ1UgZ3V5cyBsb29rZWQgYXQgdGhpcyBhbmQgaXQgYWxzbyBs
b29rcyB0byB1cyB0aGF0IGF0IGxlYXN0IG9uZQ0KPiBwYXJ0IG9mIHRoaXMgaXNzdWUgaXMgdGhh
dCBtbV9nZXRfY2lkKCkgaXMgc3Bpbm5pbmcuICBUaGlzIGlzIGJlaW5nDQo+IGludmVzdGlnYXRl
ZCBvdmVyIGhlcmU6DQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvODc3YnQyOWNn
di5mZnNAdGdseC8NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2JkZmVhODI4LTQ1ODUt
NDBlOC04ODM1LTI0N2M2YThhNzZiMEBsaW51eC5pYm0uY29tLw0KPiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9hbGwvODd5MGxoOTZ4by5mZnNAdGdseC8NCg0KS251d3UsIFBhdWwgYW5kIFJDVSBl
eHBlcnRzLCB0aGFuayB5b3UgdmVyeSBtdWNoLiBJdCdzIGdvb2QgdG8ga25vdyB0aGF0IHRoZQ0K
c2ltaWxhciBpc3N1ZSBpcyBhbHJlYWR5IHVuZGVyIGludmVzdGlnYXRpb24uIEkgaG9wZSB0aGF0
IGEgZml4IGdldHMgYXZhaWxhYmxlDQppbiB0aW1lbHkgbWFubmVyLg0KDQo+IEkgaGF2ZSBzZWVu
IHRoZSBzdGF0aWMta2V5IHBhdHRlcm4gY2FsbGVkIG91dCBieSBEYXZlIENoaW5uZXIgd2hlbiBy
dW5uaW5nDQo+IEtBU0FOIG9uIGxhcmdlIHN5c3RlbXMuICBXZSB3b3JrZWQgYXJvdW5kIHRoaXMg
YnkgZGlzYWJsaW5nIEtBU0FOJ3MgdXNlDQo+IG9mIHN0YXRpYyBrZXlzLiAgSW4gY2FzZSB5b3Ug
d2VyZSBydW5uaW5nIEtBU0FOIGluIHRoZXNlIHRlc3RzLg0KDQpBcyB0byBLQVNBTiwgeWVzLCBJ
IGVuYWJsZSBpdCBpbiBteSB0ZXN0IHJ1bnMuIEkgZmluZCB0aHJlZSBzdGF0aWMta2V5cyB1bmRl
cg0KbW0va2FzYW4vKi4gSSB3aWxsIHRoaW5rIGlmIHRoZXkgY2FuIGJlIGRpc2FibGVkIGluIG15
IHRlc3QgcnVucy4gVGhhbmtzLg==
