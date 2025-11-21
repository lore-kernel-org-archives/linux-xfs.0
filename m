Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD503346BE;
	Fri, 21 Nov 2025 06:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763707904; cv=fail; b=s3gesFhkK6xOv8XE0CP9kdN7+n3M4R+j6sQyqlqKJMEon34uSpwriC1QP/MiQcgt6LUk3rg0b64+lV4JfD1kV9xlXFQh21rFnhs/Q9AAQK5L4W/2f5Yu5NNXK5C+EDSCRMG9GPVuEv1ITDkCRznZswjxVCTW0oVaqsL2+GQcz2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763707904; c=relaxed/simple;
	bh=U927nlvJjAW2Smklc3n/lZZFaBKDGNigwSAAuxsSJvg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IIa6fFgBSPft3WrNzvEnbPiZ/cPKNpz8RfsG8zjyoLR1GMxsb0gNuS6N/652tRsvCDegh98WC2Oc5ZsnUjB06hdOr9gOj5eSpJfpRRUOCJYJHDlh/ciu5tnP4cbLUuMQC8EOM2yJQyYklArVkebvrjTNf8lxq3HEJvTGEc7wmkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jqzpkORU; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=DBolFvWP; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jqzpkORU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DBolFvWP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1763707901; x=1795243901;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U927nlvJjAW2Smklc3n/lZZFaBKDGNigwSAAuxsSJvg=;
  b=jqzpkORUZiEs9/Mi60mr+UZ6bdIi6Zh398aPSzLfBJlKzBbjhnt8S9uj
   6aZOBFhdAK/4UAbigJAxwsIHOnuSHS3xWp7+0MJ21pNpxt+q2q5Q1hNb+
   4Buuqw3cMII2gFz1MN4o7O5xDInmC8z09UNxKKfIV6IMLtUtjpvz0VvfD
   xgb5O8pTF5PZ9JHO7al7EuCfP9G/ulw+1NXb+5dWLAxAxE3DxN7K7OFKS
   76eOAPzXvhRGy+/wFeRku5G0nD++CTKlaSZcHsOpzjUrs2+UtqyliQzv6
   VJDesuJMuF6T3HkV2XZS9oZ2lD4swR6YtcFZanSsVGUbjQx1Ft5dbx9RI
   g==;
X-CSE-ConnectionGUID: hSi4rmYKTVKpBmTEt2JCEA==
X-CSE-MsgGUID: 84VW9Z/LTc2jnqg83Emsww==
X-IronPort-AV: E=Sophos;i="6.20,215,1758556800"; 
   d="scan'208";a="135524644"
Received: from mail-southcentralusazon11011016.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2025 14:51:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gpIFD3F0RwEl/JCub87A2LmmBvF1W9w4CXADFrcjIqm3HzHlURjTGNFMGIEy1K4J8H2z+fWqJiY5YopkSwwu8ufXl+5J0camMw57qgy1gHfHSqSrlAN4XgiiNPYpKfcb87qC320BRVJ7JxW1sqhD5QtekWR7H3aWIRK9dJhSvvvEIl+wlXBjJKIja0Kn0UqfK4PyNMOUGZVGzyD+PXUBJ7aGpzJeH0u4n7lnvIzOTDCTIk1swtD4Wkr3D6EYix5J+qCfyCnYd8Ic1sOjRQwYU4ucybRqVZI9MjFY9mQhyS77rCswqyks1x/FJJCSL6/f2u0zwXM1XRaJmr46NyiELQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U927nlvJjAW2Smklc3n/lZZFaBKDGNigwSAAuxsSJvg=;
 b=uxKa9WafuDfNkjdtwv+mRzMHxfGopbx2HJK7B58OVKm7irZJFlc1iaU/qHkhWfSBr3+gRBFmkuXhpdENIJNK6SX7JkWURCga81cGZ6yOpW3CDi44MEul50X8y70MXvmUgk9VRecOeAkogUcwsXVi1c/n/lmFwXq88b7gNlM7SNUskzdJDhZaPaOelUl0IL8lADKlD00O9T/P3Jkm2syXmgFTMNuk29ISMTN5uT9jv0aqG4DihLnbsxJM9tIWsxllzOU+TYIwcBFwkXgv8+4xxd7gglet47mrxGl6F90RC9ro8qsM/qdVHbXxNfzY1ktPzFwVZKCzhgHhNx9riufcWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U927nlvJjAW2Smklc3n/lZZFaBKDGNigwSAAuxsSJvg=;
 b=DBolFvWPoOZOQ5bq73Px2PsnDtgFGG2DYFaqmQzMcyfFvG9rJlGGRy5wWpE1g/Zuo7skicaPMheqxEOd4cpXFQP8Cn/8sOCBkAaLFm50u+Y2zulvgyk4mMr8ipsqzPISFjDTb7Qi3Fa/QuRsqoqwsUNlATo/w5xLMClAFTZQQnA=
Received: from CH0SPR01MB0001.namprd04.prod.outlook.com (2603:10b6:610:d8::5)
 by DS1PR04MB9276.namprd04.prod.outlook.com (2603:10b6:8:1ed::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 06:51:31 +0000
Received: from CH0SPR01MB0001.namprd04.prod.outlook.com
 ([fe80::1425:795e:ebac:cf71]) by CH0SPR01MB0001.namprd04.prod.outlook.com
 ([fe80::1425:795e:ebac:cf71%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 06:51:31 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: "cem@kernel.org" <cem@kernel.org>, "zlang@kernel.org" <zlang@kernel.org>
CC: hch <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Thread-Topic: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Thread-Index: AQHcWjgQoqh4EHp59kCIrlcKzfAjxrT8shiA
Date: Fri, 21 Nov 2025 06:51:31 +0000
Message-ID: <9f6b4f20-9d71-49a5-a313-f860b3e8a4e3@wdc.com>
References: <20251120160901.63810-1-cem@kernel.org>
 <20251120160901.63810-3-cem@kernel.org>
In-Reply-To: <20251120160901.63810-3-cem@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0SPR01MB0001:EE_|DS1PR04MB9276:EE_
x-ms-office365-filtering-correlation-id: a58c4acc-6181-4911-8853-08de28ca6732
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|19092799006|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?UDlKbGxXQVlZMUpNUkp6d2VBOWV5WWN3MGg5OERwZXdDZ01jNlFVanpRdDBa?=
 =?utf-8?B?d0ZzQ0YxVHk3NFVGZ1FBanJhZE5FTzBxZU1uYjZkTDJlMUVxQ3ZKMVhSTTYz?=
 =?utf-8?B?dTQ1c2J2WHo3QXdTZlFLZzdwTEVjTDJ6T2dXU0RWSzBvMGVSY1ZodHZiM3J2?=
 =?utf-8?B?ck0zQmdtOGZBS2dMd3l5UW95enZLWUhrUTRBa1dKOXQzOFNQMWRGWUNXc2hN?=
 =?utf-8?B?KzJnQmJwc095STUrVzZmQnlLUzNob0QyazkwUVN5ZUpzMGVHUlZkV2Jyb2Mv?=
 =?utf-8?B?VU9JL2JqNHRNblNhd2cwbExURVRiZTF3MHVGWXh6YWNxcW5nM05RSG51UURj?=
 =?utf-8?B?VitXQTFzbFExREdrZmx6S2NSRk5DL1M4QWJNVWRQZEIrYXQ2Q2l6MlNhVzR2?=
 =?utf-8?B?c1JWS2d6dU8rTlNyMXNrS0lBN1NFYlFLSHYwaEI1Y2U0QlpYdGwvcXE1bUMr?=
 =?utf-8?B?WGRWU1NUVnhabUIrbnJrRmFrOVFjTmE3Ync5NHF5aEYxQnA5cy81WHdYZ0tP?=
 =?utf-8?B?MnZiZVNIZDZkT001QTBKZ3hZQ0RSTU8zU3VvOFBEVDU4bXhTL3UzcVQ4c3Mr?=
 =?utf-8?B?RXdiaVYvVkk0N0M0bjVSUzRVMUpJTEpZdTJYZDBGL04ydFduWFkyckJlcldI?=
 =?utf-8?B?Z3Q2MFpONU5HMHVRSFh0NW50K3h5dEZ1cU4zS1ZIWGZHazhiQVIyNEJYQUg2?=
 =?utf-8?B?WXBWMWFLRENDVDdUdUpKcGF6VUY5QUZBRUhpd0VPQTFqMnBaYkVaTHZIQzZw?=
 =?utf-8?B?NUljVFNQWGNkWUNOOG56bTFiakVSQU8wYmkwbFVadGxCb1VMOUtGL2NqdExh?=
 =?utf-8?B?emsxUnZxMkQyR0trcUdheTZuQWMrVHFaS1pma014dCtEVmhiVnhYOXNTcFNM?=
 =?utf-8?B?WHBXT1FLcVgxWWhoQTcxeU0rc0F3d2dTdUpEWm42alRCbVNGalR3enZmUjA1?=
 =?utf-8?B?WWs1MmIycXV4WjhQcEQ5T2JIWUx4UFBkN3BNK1lNL0ZWYjU1NWlmZ0ZYYnlH?=
 =?utf-8?B?SVdHSWVOeCtzbnhrdCtZVU5JVUdabnBTM2RSamM3NmI0dEFvcDQ1UWVKdXZF?=
 =?utf-8?B?T0ZrRzRwR0NDdXhoUmlJREIyYW9zREZXaVhMOFA4UVB3RXppV2tGTGRQMjFR?=
 =?utf-8?B?aWFkL2dpckxFNzFLaEh3SVdKQmx1dXdjZmNPSS84T3FIaE9Yb3BDb1dxaVh2?=
 =?utf-8?B?dzhpYW41cklHU3p1VDJzNmo5RkNISjBIMitRYlRrNytYWURUSURrTVZHRm9n?=
 =?utf-8?B?SzlIUTNHcmc1WHdrZEh4cWxTeVNsek5udWFIZm5GNVk5RnRrVVExeXp3bDBH?=
 =?utf-8?B?WnFVTzNQUzQ4V0ZaSTh3RVJHeWtuOEU1cEhoTXM0Wm9OclIyTzZsZ0t3QVJp?=
 =?utf-8?B?SDF1cVpjdXRjZytveTlBRGc5RG82TFp0Z1pSZkxqVnQyaENYYk02eFkvbVAr?=
 =?utf-8?B?WVh1YlFwWlNncDExZ3o0QkFVMmcxdFZRL2VDdm1SenFSMmo1MTMrUmxyczVi?=
 =?utf-8?B?cHZOT295WUVVM1VOTTNSOXFtdjBqSE9aNUlBbG5CZFNqaXZ5eVptQUZFL0Vr?=
 =?utf-8?B?bENUMTl6TkNXaXloYlhGWUhhT1Uyb1U0QmM2cUdpQktIQlBwRkNaUTZMTEdq?=
 =?utf-8?B?Y2FMQ2g0TnloNUVhVHE5S1FjR0ZOU2lmRmZQandXWXA2TEw5eldJREptSVYz?=
 =?utf-8?B?dEhZRVZtV3QvRGtZS0dERVZ2V0RlTjFQSDBxaFY2Z01ESmdrMFpNdUV5Uk1n?=
 =?utf-8?B?aDZKV3Z5bmsyYmJsanhUb1lSek9HaDRRcU9nbkROMU90S3Z5WFZFcEU4b2VN?=
 =?utf-8?B?VXRlM3pGN0lkKzBGeFJyT2p1dGdMa1hzcnJpampxOHExSTFOSVhqejUyQ3dx?=
 =?utf-8?B?NjlSdGhOdmlab1hJL0Yxdmh6RjB4ZkRJQTJiOXpXOEhwV2JTdW5iMHBmanNI?=
 =?utf-8?B?dXAzYm4rM3FZNVJEY0VHZXY3Z3hMNXFSbGhzcXBSM3p6RU0yMWxRMFV2U3NW?=
 =?utf-8?B?R1dFeGJWSjRlbUpBTk9UckFIU0ZwdDhRTlhXRVhOOFJhb0VwK3lDdHJTOUJ6?=
 =?utf-8?Q?6QBIha?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0SPR01MB0001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(19092799006)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y0NQbkJKVzRZSFlnSU0yQUhuSng4b3Z4THZTODJxVEMyUzFoNlBqanNVdDBi?=
 =?utf-8?B?MVh3WnBnZUxYbm9KMVJZRXIzWG01Vno4S2t4emo4OVdIUHFrQzVCaEdHZEtO?=
 =?utf-8?B?U1IvS2dwVk05aDU5WThxZzdWcVluR2poUlpxNVh2NXFDampCdUlYNnRzYVpO?=
 =?utf-8?B?SkNmTUc2amQ4aFFlL1pwV0Q2ZEt2K2x6NXhPUHVaLzJxcitIRWpIZ3pkQWdv?=
 =?utf-8?B?dDNrZTJieENHTURpZGYzTzhDN2phS2lDdTgzTmlBazRDamFRNE5CSS9JRFF5?=
 =?utf-8?B?MlVySzA3UUx4eUtaamUvaUhxVVlEWEtRYWFIcG1LYjFyQXczM1EzTXB3SFRP?=
 =?utf-8?B?Qm1aZURhdy9XYTV5T3BpNkZ3cm45OFl0M1lpSmpja1RXQkJjZ2hFV0laY0pO?=
 =?utf-8?B?K1Z3c1JpTDNJQmtHUVE2RTI4SFJ2Y3dSRXBNbXhGK0thNWlvdTgzaE94YnJX?=
 =?utf-8?B?YmpIdVgvdE9oUU5BOWd6YjYweHNhQk5uQXQrYk1EcFhVeXA3N1Y1QkhFaFpC?=
 =?utf-8?B?U2ptblF1NlhEY0dsWmZZU0ZaUzBINGxDK3h6a2NmL3h5V1VwUTc2bFFyNEVp?=
 =?utf-8?B?dWxBU1I1b0lENDZxQlZqYjFHWHR1TUtwWklEK3gyZXdoT1JnNGZERm55cWZQ?=
 =?utf-8?B?VzczTHc0UXdKREtNeVp5bnhadXBpT2dsMHIzVk1pZUV2SlNpaVNqQStxcUV4?=
 =?utf-8?B?M3FERkJKTE9XWFluUXVrcHNvVnh0a1dzclFCdkVjQU91WkltTSsxNHNqQkdl?=
 =?utf-8?B?cDJKd0JGbnd6QWVNSENMOTg4SjNXazltY3JZU0dDOU9ZN2E4TnV6bXRVRXRQ?=
 =?utf-8?B?Qm9QM3RXdUV3Y2p4K1Rmd0hYalpoOThtNU1TYllRdmZMMG43alpwSXJtOXBY?=
 =?utf-8?B?UkUwd1RXdWY2YnBuMk1LZjJMbDBMNjRaSFlJM0JoVDBRUFU0dXE1K1pjNmZm?=
 =?utf-8?B?KzZoem9LY01nNXdHVlEyaVBlekFMVnZlVXF0TEdWZUtBVHV5Q3hpcWZyRUxC?=
 =?utf-8?B?Q1pzWDRRbzhJUlJ2NFB4YW9JQ2hnVUR3Uk12cmNNQXFsQklWMyt5bHoxcFo2?=
 =?utf-8?B?UjRwMXhWNEswLzZYUnVMdHI2TDNrZGMvTDA2eUFkWEMyK3JHcEU0N1ZUMVpB?=
 =?utf-8?B?bzhJK1pMMDViM2VXaFZwckhtMUFOZTlhbFlRNVBNQnJHZllZZU80NUdacGJP?=
 =?utf-8?B?T0pOMmlvbUpmYVpBdFh6ZUpGQ3pGdHBOK3dybnFsVnVySzdESlFEMEw2WU00?=
 =?utf-8?B?SWRhcHQ3OFpldmJocHFhSnhQN1FDMHg2Ykg4aHk3MUR4Z3dkdXNTNDZtaDBw?=
 =?utf-8?B?eEVFLzRjSmFTa1E0RG0zV09vUEVseng0eER2dVBBczBIdTh2Ym1PZnF0eHJH?=
 =?utf-8?B?UkZnSTREcGROalZ0TnlhU001Qy8vVWkvRWlZOS9aSWFkbElRd2piblJNbHI2?=
 =?utf-8?B?M3JZVTVGSzJiV1VtVFI0bk8wYnF2Q0I2aVFXVTFxRUphU2ZUeXgwbmlWUkpW?=
 =?utf-8?B?M253UmZxQkp6ODMxV09rMEZEUldHR1NsWXZ6R1JvQVJhdWRzaXRacjhKNmFp?=
 =?utf-8?B?TjFuUFhWNU1KRkVZd1RvcGNZUElzdG50M1lTdDY4SUtvaHJreTd5SXJhZjFS?=
 =?utf-8?B?NzZleEREVmdZb3FETm90VExYTUZ4T01rOWpkcEt3ZFduSVlzQjhNaWRzTXl4?=
 =?utf-8?B?WDUvOUROUktmSXI4RWh0T0FoUS9LL1Z5QWJpSVIrdlpjVXp1elhJa01RbTVx?=
 =?utf-8?B?TnhMYTBhc0ZZcDZ1R3UydmtrQ3hhc3Z3RFRkQ0VJWmNteW9iRGw0SXY1R1VD?=
 =?utf-8?B?NlpMOWJqS0VUTEtoSlZyN2FVWlhPU3hGRUp6STNDQ0JFSXcvZm9QVTFnVmVv?=
 =?utf-8?B?UW1vVmJnc3RDRWNLV0s0WW16L1VHWkRGQkRDMDRkYytSc29yUllIemdwR2hP?=
 =?utf-8?B?b0ZVcThCNy9jaVVkYnc0QXoxdDVNYnFURjdDMXBkZ2lGZVkvd2FwOTE4cFIr?=
 =?utf-8?B?bUFqeThhYjJ4RVV1Q0hZdUZDTVhDUG9FVXV0dzZOSFBnSWJqelRsdUVFZW1y?=
 =?utf-8?B?NGV0UXJFV3VXdnpQZDZyRnlXK29laHFhUnNRaFcwWDR6eDNReHVPMXIzUGtz?=
 =?utf-8?B?TDNwR1QzWTdRRmdtSEx5TTNDVjBpUFhxSzZqU1p5RlJubkE4QVg1NlFyRWlC?=
 =?utf-8?B?OXFmcE5wU3VSVUFGRUFRU0JxVDFETGZ1cCtGUUJkSmYxZWpITTdpUFNnYkRt?=
 =?utf-8?B?SmI1dWkrOXl0RDl4VFFHWnZmeXFnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E8D8C0BF057244087DA30FEE7BBA579@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HxReO7Uk8EY6zra422hOg3YJZ6B1lk5i6Notto5ckBi34XKDTP5RLHWsHEiJZpQK7Ly8ydxjUPClg+Taa83G1aIE41A1lzyOeSJhLj4QuMKRYuAJzSEe9HKh6db+/5lE+vPOjjNdx07WvwUthwBxJxnRLzo/6Z42950zPNLAo2vxZH6/Y+tSnA4KrZudGV6OL7bkLr5lmEqiAu7Pwh6DQUf9dyow/VHQHKp0pb3CJ1mCNcVlGX98UwYkxn3NR+/41bxOFO2vVm5F7+KYetO/euMxcsozIujNmxA/RD6XcGSxdhjyLIqmt2uFjX2k3HoB6pDteI5DW6sv5MJT++ayiS0TCTwe/aL2KacmlSlkPCyZ9yRNfpHu4EnHb84mHXOh3D1GZ/KKI5zKnNhpwTBsRQep5FPt3eRMaJb5qIH2GKdRL/duzADjoN/bE+A92HO6dNpGC9VVWSKTeX9/Rab69iHRio0CTC9nR69OQXQPrNZWamYkGdGV0vHgOXIpz3GC1WtCtvmRmsKpU5bKwBBcaATscfuq/6+w6vaLUjqIWpT/AFxSydAVWkmUWp0u8eP8x/9AD0eGcHhKb4yIdXicMZte3XITwhuJ5e9Kc0V9/sGivhUi5RyPuUbn6GCe7rYZ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0SPR01MB0001.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a58c4acc-6181-4911-8853-08de28ca6732
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 06:51:31.2804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eo88GP8HkqvjG/R7BfQR3hanPx9XsW2a+s8PNrvoTedKyeSM8xWwKFJrvDL49Agys+H2eqP+cAXisxGQkBov88xjWrs1m4fyF7NfMKBbNfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9276

T24gMTEvMjAvMjUgNTowOSBQTSwgY2VtQGtlcm5lbC5vcmcgd3JvdGU6DQo+IEZyb206IENhcmxv
cyBNYWlvbGlubyA8Y2VtQGtlcm5lbC5vcmc+DQo+DQo+IEFkZCBhIHJlZ3Jlc3Npb24gdGVzdCBm
b3IgaW5pdGlhbGl6aW5nIHpvbmVkIGJsb2NrIGRldmljZXMgd2l0aA0KPiBzZXF1ZW50aWFsIHpv
bmVzIHdpdGggYSBjYXBhY2l0eSBzbWFsbGVyIHRoYW4gdGhlIGNvbnZlbnRpb25hbA0KPiB6b25l
cyBjYXBhY2l0eS4NCg0KDQpIaSBDYXJsb3MsDQoNClR3byBxdWljayBxdWVzdGlvbnM6DQoNCjEp
IElzIHRoZXJlIGEgc3BlY2lmaWMgcmVhc29uIHRoaXMgaXMgYSB4ZnMgb25seSB0ZXN0PyBJIHRo
aW5rIGNoZWNraW5nIA0KdGhpcyBvbiBidHJmcyBhbmQgZjJmcyB3b3VsZCBtYWtlIHNlbnNlIGFz
IHdlbGwsIGxpa2Ugd2l0aCBnZW5lcmljLzc4MS4NCg0KMinCoCBJIHdvdWxkIGFsc28gbW91bnQg
dGhlIEZTIGFuZCBwZXJmb3JtIHNvbWUgSU8gb24gaXQuDQoNCg0KDQo+IFNpZ25lZC1vZmYtYnk6
IENhcmxvcyBNYWlvbGlubyA8Y21haW9saW5vQHJlZGhhdC5jb20+DQo+IC0tLQ0KPiAgIHRlc3Rz
L3hmcy8zMzMgICAgIHwgMzcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0K
PiAgIHRlc3RzL3hmcy8zMzMub3V0IHwgIDIgKysNCj4gICAyIGZpbGVzIGNoYW5nZWQsIDM5IGlu
c2VydGlvbnMoKykNCj4gICBjcmVhdGUgbW9kZSAxMDA3NTUgdGVzdHMveGZzLzMzMw0KPiAgIGNy
ZWF0ZSBtb2RlIDEwMDY0NCB0ZXN0cy94ZnMvMzMzLm91dA0KPg0KPiBkaWZmIC0tZ2l0IGEvdGVz
dHMveGZzLzMzMyBiL3Rlc3RzL3hmcy8zMzMNCj4gbmV3IGZpbGUgbW9kZSAxMDA3NTUNCj4gaW5k
ZXggMDAwMDAwMDAwMDAwLi5mMDQ1YjEzYzczZWUNCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi90
ZXN0cy94ZnMvMzMzDQo+IEBAIC0wLDAgKzEsMzcgQEANCj4gKyMhIC9iaW4vYmFzaA0KPiArIyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArIyBDb3B5cmlnaHQgKGMpIDIwMjUg
UmVkIEhhdCwgSW5jLiAgQWxsIFJpZ2h0cyBSZXNlcnZlZC4NCj4gKyMNCj4gKyMgRlMgUUEgVGVz
dCAzMzMNCj4gKyMNCj4gKyMgVGVzdCB0aGF0IG1rZnMgY2FuIHByb3Blcmx5IGluaXRpYWxpemUg
em9uZWQgZGV2aWNlcw0KPiArIyB3aXRoIGEgc2VxdWVudGlhbCB6b25lIGNhcGFjaXR5IHNtYWxs
ZXIgdGhhbiB0aGUgY29udmVudGlvbmFsIHpvbmUuDQo+ICsjDQo+ICsuIC4vY29tbW9uL3ByZWFt
YmxlDQo+ICsuIC4vY29tbW9uL3pvbmVkDQo+ICsNCj4gK19iZWdpbl9mc3Rlc3QgYXV0byB6b25l
IG1rZnMgcXVpY2sNCj4gK19jbGVhbnVwKCkNCj4gK3sNCj4gKwlfZGVzdHJveV96bG9vcCAkemxv
b3ANCj4gK30NCj4gKw0KPiArX3JlcXVpcmVfc2NyYXRjaA0KPiArX3JlcXVpcmVfemxvb3ANCj4g
Kw0KPiArX3NjcmF0Y2hfbWtmcyA+IC9kZXYvbnVsbCAyPiYxDQo+ICtfc2NyYXRjaF9tb3VudCA+
PiAkc2VxcmVzLmZ1bGwNCj4gKw0KPiAremxvb3BkaXI9IiRTQ1JBVENIX01OVC96bG9vcCINCj4g
K3pvbmVfc2l6ZT02NA0KPiArY29udl96b25lcz0yDQo+ICt6b25lX2NhcGFjaXR5PTYzDQo+ICsN
Cj4gK3psb29wPSQoX2NyZWF0ZV96bG9vcCAkemxvb3BkaXIgJHpvbmVfc2l6ZSAkY29udl96b25l
cyAkem9uZV9jYXBhY2l0eSkNCj4gKw0KPiArX3RyeV9ta2ZzX2RldiAkemxvb3AgPj4gJHNlcXJl
cy5mdWxsIDI+JjEgfHwgXA0KPiArCV9mYWlsICJDYW5ub3QgbWtmcyB6b25lZCBmaWxlc3lzdGVt
Ig0KPiArDQo+ICtlY2hvIFNpbGVuY2UgaXMgZ29sZGVuDQo+ICsjIHN1Y2Nlc3MsIGFsbCBkb25l
DQo+ICtfZXhpdCAwDQo+IGRpZmYgLS1naXQgYS90ZXN0cy94ZnMvMzMzLm91dCBiL3Rlc3RzL3hm
cy8zMzMub3V0DQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMC4u
NjBhMTU4OTg3YTIyDQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdGVzdHMveGZzLzMzMy5vdXQN
Cj4gQEAgLTAsMCArMSwyIEBADQo+ICtRQSBvdXRwdXQgY3JlYXRlZCBieSAzMzMNCj4gK1NpbGVu
Y2UgaXMgZ29sZGVuDQoNCg0K
