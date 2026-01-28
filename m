Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F30334C83C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602465; cv=fail; b=Gz9jBxj6Lm11GTcAC/j/oloj0Z8VWlHE4j2Zf4gJZBmig0bMivU1/rJ1psAXvwI6da8n/2dWGo4X4OyjJZOo4qxLpNhMPZimMYbRBMRxFLNGbua2O4AdcCqXeTJQw0VOHJtucRXIQvyYpzgY30ReVqdoQyq64kf6ycT5weyYbYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602465; c=relaxed/simple;
	bh=fVfiMzfRAlu7uJgM7oOhAvKh9nLiZDO7PVoXqJ9bfWM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gSciWkxHnmPqLf7Xx0nmHaCxDvwkwY/2zDUh3U4Wo/seDjjVElm4KDKpMyqOXAuTHkrqnx9u+OcYTSsiyLz/Vt+LYJZZhxWgcbIyKdEi+titmXfXQ7FlgqbdXNEtOf5NR5gk0WWd88dtImcFczfp2ijEqD6iWJGFwFG/C9IRzIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=P7McZYAJ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wIN8e7g2; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P7McZYAJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wIN8e7g2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769602463; x=1801138463;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fVfiMzfRAlu7uJgM7oOhAvKh9nLiZDO7PVoXqJ9bfWM=;
  b=P7McZYAJPRZxtPZlsHl10+uRLpI6Q1U7S4EbyWsD8aATMc3Ko9LU6L11
   rib4v4WodRpQ3Sk8YwIr3G6BL0ydG7CeTyoqgcSK2WrBolEtAh+J2irap
   0zpk2LtoIqoW8kTA7yrjgU8SDVEwL603AOUbNjtfwiXcFn9Geu81Jq4Ki
   z93uxj/syl5Q2V9s/zxK4qtkA0Mu51EOK5STrzmTNlejSU2INHoH3zA+x
   aFMPkVXR/2POU+sNU50iZdthSBpgkpN5D9qeCtWLLaGv2g5Vppaxi7wA/
   uRHIMTeDa0VzCVZXYkSluam3tjhb26NK8DW70Eg5sWcE6QX393uy9BxT+
   A==;
X-CSE-ConnectionGUID: Kmb8QJ5fRzCQ0ZN62ZdJRQ==
X-CSE-MsgGUID: tStfAlyXTSasMQavJOGU1w==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="139631550"
Received: from mail-westusazon11010026.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.26])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:14:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xc5diEQdHGHKC1O+YOtDkw8nQgoRXXv84CFgvPr+aBPvQhRnB3Om1YR3U5enXlgB0iOHcKYlGPhDgC/QHcHp46ghQGQa0FkWa5xHkGs8zOVPSJxhRZ33Wvx9OFSrPW0r0rsop1m//LvT3+Xavo7XTcR8yHolfrv4Fx0jsazD5DJ24CPbTrhoPkf3kVIV9MbVOpYO1P8ZAsUq83DJDqBQjbBnSbY71dwp8vISGnzi8z+8knFXN8fbzUxfpsKn1MeCG0kTjRPYLaMSlplIs7HO4ozY4ok6LjYxTzZ41wJ9tuGPz+Ex0rvGRpvKDpqRgaXqFUd0OioEbJ/U1lNZ+nld+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVfiMzfRAlu7uJgM7oOhAvKh9nLiZDO7PVoXqJ9bfWM=;
 b=PCcEhPvdYMmN7vefpd5RY6Q72AwESV9LMvDZlt0+jKuxNuiObGB533tS+zhwpggODYDrMlWXjRaMAGcKkzv9QE1deGol/AYZ/kMLdJjf2D9oZ0/n6uAQA9SHtuW8H6njqC7r9vtwQArDeQ7fGyLrEXVbrNaePo2sKdqsas7Z+0dqFYNrLkwHoIEeHer1VC/Wj2c1WSrYyTdrj6L/CMKAnHgoc02T38QHKLJ5R2yOphh+ZADxCwCm2tudWqBtcn8UTRP+pZ9pjFb1W1lbb2OA3DiVrkkwNj2MQeoq4bf9rYrCpP7RBKFA2cspuV+OMxGM3eu3syQcmRBbuTqjjmftsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVfiMzfRAlu7uJgM7oOhAvKh9nLiZDO7PVoXqJ9bfWM=;
 b=wIN8e7g2344O+CZHGBAw5m5cXueamWP3MnJE07EG4ajkoes3K83f63XyItWce9p/K7Qm21RKmWmVNQ1tYZz4mOIOpnNSL1vatO8E/PPU7d/SKxRFbc032WxsCVh65np2BnWD8rs6715EJ4TzJ3mRtPs4Pnfnxi8ecFdGGYTKf38=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN6PR04MB9381.namprd04.prod.outlook.com (2603:10b6:208:4f7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 12:14:11 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:14:11 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 03/10] xfs: don't validate error tags in the I/O path
Thread-Topic: [PATCH 03/10] xfs: don't validate error tags in the I/O path
Thread-Index: AQHcj6byHu8AEZXgS0GSEHDqY3tn1LVnf+kA
Date: Wed, 28 Jan 2026 12:14:10 +0000
Message-ID: <72c258a0-3d41-4550-909b-609366848c1d@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-4-hch@lst.de>
In-Reply-To: <20260127160619.330250-4-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN6PR04MB9381:EE_
x-ms-office365-filtering-correlation-id: f8288b61-f41e-41be-cbc6-08de5e66be94
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZlJtVlluL1hMbENmOC9Ib29QNFRBMlFIb3F6VS9PczQxaFJLNkhJTkN1UHRq?=
 =?utf-8?B?ajE4dFVGNjBDVmlOaHhwaHJIUEtVRGJ6aXhRM3dRcUVUOEpRSStvZW85TDgw?=
 =?utf-8?B?T0dHWGdma0pxY05SaHZncFQ2NVFKK0ZOdEU1WXMwWWtqOVcyNXo1RmlBYnZ5?=
 =?utf-8?B?by9aRXdwdjJrbG8vSXNRWGZXdENXNkRRUnRZOG5nVG5mOWZ2djh3U2lGVkQ1?=
 =?utf-8?B?Nm1BeGJDRWlaMVV2QkgrQkR0azZKemhYVExPVVNtSzJ6WWI2b1hPNW1QdmRL?=
 =?utf-8?B?S0E1eUhabWJMdTZ1TWxjZDBDRFFURUpmUzY1R2VlczhTRHZUZEQ4MEtKSnlR?=
 =?utf-8?B?VWNua2RBSnl4L3FzSlJiTFRPdkZJZ1JMZzRmYzJwbUJXcjAwNFpLdzZVcFVp?=
 =?utf-8?B?K1BRS2NzKzBlTm5ITWx6VmgyMy9xZjk3RzZIZU4rc0NDQXNURmk4WEdsUjdK?=
 =?utf-8?B?VzBXNGdJakI3Z2pydCs5cUlTN3FURGk5VndsSERQQkY1SUFUbnJ0UFNqekVw?=
 =?utf-8?B?aTRzaVdDRmgxUy9VT1pyOVFvQzRDb09RYUpVMVFvdTc5ZHRERHB2Qm5LOTQy?=
 =?utf-8?B?Z2w2Ym04Sm9JblZ1VHFKYVpKWEt0U3dxMkh2QXduVkVUUUFyZnBobUZ5MlIr?=
 =?utf-8?B?MzV1KzBWM0dMMWJ0MkNFb3A0bFhleTQzTVNtS1duVFVLZEVTOGY1STFmVklt?=
 =?utf-8?B?Qi95L0lJOFZoVURtYklOWWh3a01hYlBUUDhNMVRYT1VXdWhKSStzdDJvT1pp?=
 =?utf-8?B?Q3FGTHhTMmVNMGw3SXVvMS82NGhiU1E1NkVsRnVqaDVLZWpmL0IySENUQllp?=
 =?utf-8?B?SnVrL0ZBYUFhdTZ5RW9uOGZQQXFUY1YzSmpDUE1MeStqRFVQR2tYM1hQMVB6?=
 =?utf-8?B?cTJlQWJwZ3pRbldWS2JlcTBocG9DSnpTcUo5cUlaWXdhUFJsV0tqWlZTdEk0?=
 =?utf-8?B?bU9XdXNUcytHVlVFRXE0ejVGV1MrZ1FzV0pjRHlqUGZLZnNna1ZTYk45bGRp?=
 =?utf-8?B?SDNDa0R2ODFmOVp2bjNGZzFoTnBDamFnRFhtTmNrN2FoQ09GT3I1MEhFNm1Q?=
 =?utf-8?B?eTdiSlhHOTNiMndoVHNCVnRCeDdtTlo4V05qRW9Gako1bFJVZzBoMHNoeEZF?=
 =?utf-8?B?cnJnQThGbGUyV0dNRzNGTEZpeVdENEJYSS9lZDlxdmZRbSs5Unl6bWk3MGlm?=
 =?utf-8?B?TkF5bUJVMVlJdFJlYVJKSEZEK1dQSFg0bDFXUG9aanN0ZkNRbU02aWdOenpP?=
 =?utf-8?B?SzI3bGx3QzlHU05TWGFwR2xhOUNvUms2c0puQWJERzBLdXRDcmlha1YzeHFV?=
 =?utf-8?B?RVFHVnV0ZVF2L3diQ2sxU3JZbkVPSHRtQVpkKzRQSEhEMzRuc3NZdml4enJM?=
 =?utf-8?B?L1FhdGxEZDIzT3d0am9FMEZYY3N6dDh3S25WNldUMlNUUHprNmwrZUZhTi9V?=
 =?utf-8?B?MjhpU2pCTEpCV1NJTmZLMVg5aENXQWpXeG9CMFBiWmN6YUIrMEZKd2hjRENO?=
 =?utf-8?B?MHNkanIwdXpyWW9hOXJMang2ME1pKzBIVG9aYWNVMFhzM1YyNXlRQ0Y1TXkz?=
 =?utf-8?B?YjdnZ28vazNLTGlkRzJ5RjJGOS9QQ3pLUVVLbzhzdC9qVWUrbE5zU29NVlpT?=
 =?utf-8?B?cjRxVGdoTDJ3Q29DTVBvMndLVHZVdE1IUS9kdlZZOGFBck9mbDRPUWhKdUI2?=
 =?utf-8?B?T0tEQ3QzZFNQUVVRb0lvQVBoK1lOVm1USDFsNE14UURzMWsyRkozYUtsa1NF?=
 =?utf-8?B?RURTdDFxQThpMVR4K2IrMGRVc0RVdHVjQ3FTTkZiM3hzZzhaT3YyZkhYYjdq?=
 =?utf-8?B?aDQrV204eVR1emwzeWJxR05lNTJHakQra3pKbncwVVdJaXZvcGRrU3IwNWRh?=
 =?utf-8?B?ckU3a3k5dnRQMmlSUEYyRlcxRUsvZ3NHOVpUTlJudzJ4T3RUdmJzQ0lOcWFT?=
 =?utf-8?B?bU92MkRzaDBWSkR3WUg5T2RieHc0N3F6aHRKMzl3MnMzT1NxdEVnZHRlV3FZ?=
 =?utf-8?B?VEFzMkpXbzJPT0IxQmhjYTFwczF1NUhCUlBjOGZMWG10ZUJkREdFUk5yYzBC?=
 =?utf-8?B?YXUwSU9DaCtFVTF1M3RmT1phbXFoTXhJZDM5Qko4dGVWUmYyNUppL0lqTGdW?=
 =?utf-8?B?SXQ4Y0phWFBGUi9oZ0VPd2o2L2puWmZXY0E4Q25NRlRUR0N3dVdkMUxYY3RE?=
 =?utf-8?Q?XKhPtaB9DdR9crgKIwSQ7Oc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S0JXVU40dmtabndGUnByN3J0V0tyeWZJSnI5cHZNL1NSQTlzRzFMT005SHBC?=
 =?utf-8?B?M01md2JqdHpKYksvLzBWWDZvWnluWjJLODlVcTc3TEFQOVpJWThvN1dMM01M?=
 =?utf-8?B?MFZoNEU1eDhWOGFKY21aR0s5QnVIZG4yNm4wVk9MbElzSnhoenZmOWtDSUVF?=
 =?utf-8?B?MzJJVHBiT0cyOHc2ZU1mUXB0YTZHNVJaSDg2QVNIeVFteUVWY00rUnVSNUN0?=
 =?utf-8?B?bnZMZXNUYjJUL0dwRkZnUkZYUFY2cEw0NkJnM3ExYnExdDYzazJMZFRzSzc0?=
 =?utf-8?B?enhiTVlxNEtKOWVWNEdZSXpQMnBqYmVtOUw5VHErVUUycUlOWjhZdXdMOXV2?=
 =?utf-8?B?VEc2YWZaK0VzMExWWHZiMGxLdWFIVVdpRFRGTnZPQWFlM253WjBYK2g1T1RQ?=
 =?utf-8?B?aDI2QXk1K0l6SCtXbW9jQzJDNzB0R2ZtSTM2VERXcjNQaFZKWENoeEdxMnZ6?=
 =?utf-8?B?NGRQOEZhSlorVHVtQjBncjJ6akd2dUFRVVlJL2dMbmZTQU00WUpKT2tnd1hj?=
 =?utf-8?B?RHVVL3FPUTJWUE16YklOeUt2MTRNOEF6WTRpejJ4Nk01RVFuU1ZDU0tKcnVs?=
 =?utf-8?B?dUREWklCL1JIZTVLTTJKSXgwVW82aWdyZ1NTUm1wK2ZjSUdSd1dOL25KSjVw?=
 =?utf-8?B?Q21ONnBZMzVYQnFxdDJpQk4yNG5wdFJOM0dWMlZhUldWT0FLR1l4TjVtZFZF?=
 =?utf-8?B?T2N0Q29QZnA1UExxb1RWbG9TVkxnWUd2QmFxb0VnMjB2Y3E1SDZKVkxvQXg2?=
 =?utf-8?B?US9pNHNRQnJDUDQzM3BBZHJSWTVhVmZZRHBrc1QzRmNVYVJTc3JKdThMSmov?=
 =?utf-8?B?cmhZdnpRSkk5dWRicjVQcmFzclJlTGZrVzNtMVJqOG9HK1VmUVRGQ3J6MUw5?=
 =?utf-8?B?d0ZQTitwaDArSURhalE1dHBjOEcza1oxSDh6dk1odVowdDhRQkxmWTJzSG5V?=
 =?utf-8?B?Q3Z2MElCL1N2U2RPRWFFc0ZiL1ZWSU9Cc2JQU0ljMmxHMjdyL2IySHBnS2Jj?=
 =?utf-8?B?NHNndEJPZlNrRmN0VGtKeVJQUk1SSzRod0lYbDF0dllveHR0R3dEZktHa216?=
 =?utf-8?B?UWZETzg4TnZ5RnpKcDlMZjFUandUMFZoWDdrSDRIb29VK2dxZWIrSExzOExC?=
 =?utf-8?B?MXpJUWlDTnVIK0hxbE9HSzExV3hMYTIyV1BHc0E5dWQ2TEtTaGpzNDhaVjBY?=
 =?utf-8?B?SFc1VUpTV3FWYXIxSnNrcEE1THhPNnRLcmhCMVJNaUlJQ1ZyTTd6Y0FqcGxa?=
 =?utf-8?B?SEcxaGZQNUM5V2FiR2lnTlRsUU80SzRFQmpPTjhNVkRiUi91ZEllcUU4REsw?=
 =?utf-8?B?Q0J3bkExcitEVHJKSGt4YUwzTWpVV1ZIeWk4NHBvZ1l2UFNNd0dtZ09BRmN0?=
 =?utf-8?B?RFR1UUtRQnZUZmx5b0d4cFk1ajJRZ0JZdTJ0R3VlM2V4R2hXV3Q4ZW83cDd5?=
 =?utf-8?B?NUtMYTFKS3c3N0s0OFhST2ZxRHBuTnc2V1ladkpRRUlTdjR1S1ZsZkp6SGZE?=
 =?utf-8?B?d3dST05VS0d1N3pvT1lDbzYyalozQm1ud1l6YVBvNWtHYVJqbkNMWEwxdERV?=
 =?utf-8?B?ZnhTUXNpU1ozcGlLbXh2cEVvM21SSFZVSDRxTkxabXJxS2Y2dDBadGNDdmI2?=
 =?utf-8?B?MlRYT0VDRnVJT2p2Rk1ua0VCSTh2dWVDUEdNcWVEeWxidVN3bnNqOGw1ZDVs?=
 =?utf-8?B?SGw2QllBekJKMHpPTllnUjgrelVxdHdsb0o0czdQaG5Sc0U5SFlKWDM0dSsy?=
 =?utf-8?B?a3M4bTE2NDl1OTF2aEJTaDZ5a2c1SkVyT3RzWGErUzZrRGdkZUpQTGg4UWlN?=
 =?utf-8?B?eXNaaDdzdzJIYzB6bW5EbWZmVlFHMEdkSGFMWFRDaUx0MVNid2IzR3lnL041?=
 =?utf-8?B?akJnVkMyeEtyM1FINGFLM293MG5NTnVXM0U5S2VpL2JpcWFrdHdZaFBDK2V3?=
 =?utf-8?B?c09ia01hRDZSNWlhYWZFMnM0RVZxeXRuVXUyaWtIN2NnRDkxaElxVkJ6aXZP?=
 =?utf-8?B?dFdFbTZYZTh0b01Lc1V1dWlSTFhRaWpHSGRCK2pSSFJYUFNQSW8rS0p1cDFl?=
 =?utf-8?B?S1pWdS9CajdEclV4WENMUkhrU3pybU1hMDJTUUtBSW92clNRcDZaZ0ZJa0dI?=
 =?utf-8?B?ellYd2M5M1VOU0swbFRZTTYyVTJFL0s1c2t2cmkrTmoyZEtFdlp3UW5iQVlP?=
 =?utf-8?B?THFIbm9UUmRna1hNZWZldmlKOUZZUVp0Y3BFYW9PY1poK2QxdGNkM3JJcE41?=
 =?utf-8?B?RVRtRFRGMzlsaEdLNmxlWDZPc3hERndubTZmVy9WWk1PR3BpdHFMMFN2TlZx?=
 =?utf-8?B?bUdxRndUMUFpQmh0WVJMSTdySjE0ZHBhMTgxQVRHWXV4Wm0rNUNncmo5T1Vr?=
 =?utf-8?Q?/kZdhKK103V7IJ6E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DBBB85F8072F74F894A71A4D8E4627D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U6usIRi5xpzW9UFItb738I56X7qxfC/50f+glAYgXh9enB5w4cwyBomDECFGyZ7ONsQc157vvzWoafIvCdDCWA0z1L9979WhxucecxtjMX8wsU3vgGNp/9Mjestnzhpvscxh+2PPXfz3dnF5zxy54R0vmN7dsG76KM7ofxdgYUWPFyq0dHKVD0TlvztdeMhbfxq87QCmJ7gS9xtkETCsizzM9IM+PQcRZPr5IFfuOmr51GM6SNPTxSOLuvdFKcJvsRicUjaLtnqPqMHixyAyqooouEGcSwYil5nDPR7ByqbXIjltwfWRpMJzDanHMuSraSvTWZSKcuXWxipC5JQUXOUu7Lp//zvrICbwdan86F1ZMlSGfVAoVoYvYzTES2HYhcm5u3EnYWtrrhKLj2bYIW2I2Blv8p1og2KxLT1C4Dm0LACA07vOMtdARgRJ/v8bbAKmwO9/FBIuPu0sLVtpaO0tKREHc7QGwXGRexTypR1CeRzE2iIF7tLFMWszb95n118QEZyceNzSRdK1lXgkGH1Sp8So7p5osIFRbz6ueSJlz/xNDJxDzS0d7bH7+85tNxn2j7xnOdRCvLn67G2oJeNHTUlrtXK8gvg0y0IV1wo/QJijd0L5lBYa1AiNxAGg
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8288b61-f41e-41be-cbc6-08de5e66be94
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:14:10.9834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VIj2uTOpPo9dDaLSOdcHmG0jQ6cD/r1+J/9feXna5KHSnrGZmlynu9VX8tqmsM83w+5einALPTA3CN9zRpKpXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9381

T24gMjcvMDEvMjAyNiAxNzowNiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFdlIGNhbiB0
cnVzdCBYRlMgZGV2ZWxvcGVycyBlbm91Z2ggdG8gbm90IHBhc3MgcmFuZG9tIHN0dWZmIHRvDQo+
IFhGU19FUlJPUl9URVNUL0RFTEFZLiAgT3BlbiBjb2RlIHRoZSB2YWxpZGl0eSBjaGVjayBpbiB4
ZnNfZXJyb3J0YWdfYWRkLA0KPiB3aGljaCBpcyB0aGUgb25seSBwbGFjZSB0aGF0IHJlY2VpdmVz
IHVudmFsaWRhdGVkIGVycm9yIHRhZyB2YWx1ZXMgZnJvbQ0KPiB1c2VyIHNwYWNlLCBhbmQgZHJv
cCB0aGUgbm93IHBvaW50bGVzcyB4ZnNfZXJyb3J0YWdfZW5hYmxlZCBoZWxwZXIuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBm
cy94ZnMvbGlieGZzL3hmc19lcnJvcnRhZy5oIHwgIDIgKy0NCj4gIGZzL3hmcy94ZnNfZXJyb3Iu
YyAgICAgICAgICAgfCAzOCArKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4g
IGZzL3hmcy94ZnNfZXJyb3IuaCAgICAgICAgICAgfCAgMiArLQ0KPiAgMyBmaWxlcyBjaGFuZ2Vk
LCAxMiBpbnNlcnRpb25zKCspLCAzMCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9m
cy94ZnMvbGlieGZzL3hmc19lcnJvcnRhZy5oIGIvZnMveGZzL2xpYnhmcy94ZnNfZXJyb3J0YWcu
aA0KPiBpbmRleCA1N2U0NzA3N2M3NWEuLmI3ZDk4NDcxNjg0YiAxMDA2NDQNCj4gLS0tIGEvZnMv
eGZzL2xpYnhmcy94ZnNfZXJyb3J0YWcuaA0KPiArKysgYi9mcy94ZnMvbGlieGZzL3hmc19lcnJv
cnRhZy5oDQo+IEBAIC01Myw3ICs1Myw3IEBADQo+ICAgKiBEcm9wLXdyaXRlcyBzdXBwb3J0IHJl
bW92ZWQgYmVjYXVzZSB3cml0ZSBlcnJvciBoYW5kbGluZyBjYW5ub3QgdHJhc2gNCj4gICAqIHBy
ZS1leGlzdGluZyBkZWxhbGxvYyBleHRlbnRzIGluIGFueSB1c2VmdWwgd2F5IGFueW1vcmUuIFdl
IHJldGFpbiB0aGUNCj4gICAqIGRlZmluaXRpb24gc28gdGhhdCB3ZSBjYW4gcmVqZWN0IGl0IGFz
IGFuIGludmFsaWQgdmFsdWUgaW4NCj4gLSAqIHhmc19lcnJvcnRhZ192YWxpZCgpLg0KPiArICog
eGZzX2Vycm9ydGFnX2FkZCgpLg0KPiAgICovDQo+ICAjZGVmaW5lIFhGU19FUlJUQUdfRFJPUF9X
UklURVMJCQkJMjgNCj4gICNkZWZpbmUgWEZTX0VSUlRBR19MT0dfQkFEX0NSQwkJCQkyOQ0KPiBk
aWZmIC0tZ2l0IGEvZnMveGZzL3hmc19lcnJvci5jIGIvZnMveGZzL3hmc19lcnJvci5jDQo+IGlu
ZGV4IGRmYTRhYmY5ZmQxYS4uNTJhMWQ1MTEyNmUzIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZz
X2Vycm9yLmMNCj4gKysrIGIvZnMveGZzL3hmc19lcnJvci5jDQo+IEBAIC0xMjUsMzAgKzEyNSw2
IEBAIHhmc19lcnJvcnRhZ19kZWwoDQo+ICAJeGZzX3N5c2ZzX2RlbCgmbXAtPm1fZXJyb3J0YWdf
a29iaik7DQo+ICB9DQo+ICANCj4gLXN0YXRpYyBib29sDQo+IC14ZnNfZXJyb3J0YWdfdmFsaWQo
DQo+IC0JdW5zaWduZWQgaW50CQllcnJvcl90YWcpDQo+IC17DQo+IC0JaWYgKGVycm9yX3RhZyA+
PSBYRlNfRVJSVEFHX01BWCkNCj4gLQkJcmV0dXJuIGZhbHNlOw0KPiAtDQo+IC0JLyogRXJyb3Ig
b3V0IHJlbW92ZWQgaW5qZWN0aW9uIHR5cGVzICovDQo+IC0JaWYgKGVycm9yX3RhZyA9PSBYRlNf
RVJSVEFHX0RST1BfV1JJVEVTKQ0KPiAtCQlyZXR1cm4gZmFsc2U7DQo+IC0JcmV0dXJuIHRydWU7
DQo+IC19DQo+IC0NCj4gLWJvb2wNCj4gLXhmc19lcnJvcnRhZ19lbmFibGVkKA0KPiAtCXN0cnVj
dCB4ZnNfbW91bnQJKm1wLA0KPiAtCXVuc2lnbmVkIGludAkJdGFnKQ0KPiAtew0KPiAtCWlmICgh
eGZzX2Vycm9ydGFnX3ZhbGlkKHRhZykpDQo+IC0JCXJldHVybiBmYWxzZTsNCj4gLQ0KPiAtCXJl
dHVybiBtcC0+bV9lcnJvcnRhZ1t0YWddICE9IDA7DQo+IC19DQo+IC0NCj4gIGJvb2wNCj4gIHhm
c19lcnJvcnRhZ190ZXN0KA0KPiAgCXN0cnVjdCB4ZnNfbW91bnQJKm1wLA0KPiBAQCAtMTU4LDkg
KzEzNCw2IEBAIHhmc19lcnJvcnRhZ190ZXN0KA0KPiAgew0KPiAgCXVuc2lnbmVkIGludAkJcmFu
ZGZhY3RvcjsNCj4gIA0KPiAtCWlmICgheGZzX2Vycm9ydGFnX3ZhbGlkKGVycm9yX3RhZykpDQo+
IC0JCXJldHVybiBmYWxzZTsNCj4gLQ0KPiAgCXJhbmRmYWN0b3IgPSBtcC0+bV9lcnJvcnRhZ1tl
cnJvcl90YWddOw0KPiAgCWlmICghcmFuZGZhY3RvciB8fCBnZXRfcmFuZG9tX3UzMl9iZWxvdyhy
YW5kZmFjdG9yKSkNCj4gIAkJcmV0dXJuIGZhbHNlOw0KPiBAQCAtMTc4LDggKzE1MSwxNyBAQCB4
ZnNfZXJyb3J0YWdfYWRkKA0KPiAgew0KPiAgCUJVSUxEX0JVR19PTihBUlJBWV9TSVpFKHhmc19l
cnJvcnRhZ19yYW5kb21fZGVmYXVsdCkgIT0gWEZTX0VSUlRBR19NQVgpOw0KPiAgDQo+IC0JaWYg
KCF4ZnNfZXJyb3J0YWdfdmFsaWQoZXJyb3JfdGFnKSkNCj4gKwlpZiAoZXJyb3JfdGFnID49IFhG
U19FUlJUQUdfTUFYKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiArCS8qIEVycm9yIG91
dCByZW1vdmVkIGluamVjdGlvbiB0eXBlcyAqLw0KPiArCXN3aXRjaCAoZXJyb3JfdGFnKSB7DQo+
ICsJY2FzZSBYRlNfRVJSVEFHX0RST1BfV1JJVEVTOg0KPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4g
KwlkZWZhdWx0Og0KPiArCQlicmVhazsNCj4gKwl9DQo+ICsNCj4gIAltcC0+bV9lcnJvcnRhZ1tl
cnJvcl90YWddID0geGZzX2Vycm9ydGFnX3JhbmRvbV9kZWZhdWx0W2Vycm9yX3RhZ107DQo+ICAJ
cmV0dXJuIDA7DQo+ICB9DQo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2Vycm9yLmggYi9mcy94
ZnMveGZzX2Vycm9yLmgNCj4gaW5kZXggM2E3OGM4ZGZhZWM4Li5lYzIyNTQ2YThjYTggMTAwNjQ0
DQo+IC0tLSBhL2ZzL3hmcy94ZnNfZXJyb3IuaA0KPiArKysgYi9mcy94ZnMveGZzX2Vycm9yLmgN
Cj4gQEAgLTQ0LDcgKzQ0LDcgQEAgYm9vbCB4ZnNfZXJyb3J0YWdfZW5hYmxlZChzdHJ1Y3QgeGZz
X21vdW50ICptcCwgdW5zaWduZWQgaW50IHRhZyk7DQo+ICAjZGVmaW5lIFhGU19FUlJPUlRBR19E
RUxBWShtcCwgdGFnKQkJXA0KPiAgCWRvIHsgXA0KPiAgCQltaWdodF9zbGVlcCgpOyBcDQo+IC0J
CWlmICgheGZzX2Vycm9ydGFnX2VuYWJsZWQoKG1wKSwgKHRhZykpKSBcDQo+ICsJCWlmICghbXAt
Pm1fZXJyb3J0YWdbdGFnXSkgXA0KPiAgCQkJYnJlYWs7IFwNCj4gIAkJeGZzX3dhcm5fcmF0ZWxp
bWl0ZWQoKG1wKSwgXA0KPiAgIkluamVjdGluZyAldW1zIGRlbGF5IGF0IGZpbGUgJXMsIGxpbmUg
JWQsIG9uIGZpbGVzeXN0ZW0gXCIlc1wiIiwgXA0KDQpMb29rcyBnb29kLA0KDQpSZXZpZXdlZC1i
eTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KDQo=
