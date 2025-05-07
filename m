Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2249619D891;
	Wed,  7 May 2025 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746608339; cv=fail; b=Jlkg4y7bplaoKoBL0Y/40Cb+LHSCTnNwRhskqc0WPZ8mSkWAoCf6xdPz++5i910PqWUbCUyIG//mTMg1c9dluUoGoI6McF+MWMDxlwkO50JYWnDROwQWqoQ0QwKRkcnzfsMfdC8ZjwQj6JG+Q+mJmNQAnWL9PbA0jxIfUhzyXLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746608339; c=relaxed/simple;
	bh=/hOhTa4+1+Tx9mQZF4nL0j56LiB9IXKv5oGOC8G81S4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TjhR/ggyJiy7WXv8cULQJsJwOFDrkCDS7yt+S0uLGdH/qwrMzXPXC0Qknjtg+Ej8jPUlkrg4GXSB+WHE5yBQTc3U0lZXCbTsXD61niNdIJ4vEoMgaU+x0DSApc/cyHM7H590yfn+z44GKZ4AlER4pJ864NUc115+NxWdI/gXXEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=foueJc13; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=PmdWkbLS; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="foueJc13";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="PmdWkbLS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746608337; x=1778144337;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/hOhTa4+1+Tx9mQZF4nL0j56LiB9IXKv5oGOC8G81S4=;
  b=foueJc13KOOcDBGTZoKqxTXkR1TfLbEsSjd9ewc7n6Lux9KSfXQmoTUh
   kF0MvOXz97EL2xYqdYGW07m4DJ8MP6dRvJkG3qoAbviRZrlfvnxHVn3nm
   nUGlajjtvfnPfWwbMySFWi+4SscKv09ySy2xwP7/TWnltLCgTneZGvIfD
   dXnvRihY+OKVqceFwqam2s9XHeqNbqPujvlf4lSHnnANi+i5hatE8HzG1
   RLsMtEdjNpnYA6TExaAvIfmnPuzY8w3UbPKZ1CCe69Ki+p/6kjhsZ1f+f
   OxpKNRuobURfAFTf2hBjW5bVezyeGzWNLYa5kMm7dLdN56lz2iqarcIXz
   Q==;
X-CSE-ConnectionGUID: Dg0fT68VS3CJVgwUkVez2w==
X-CSE-MsgGUID: E5JKhQiaRf2JiW3WeqsgIA==
X-IronPort-AV: E=Sophos;i="6.15,268,1739808000"; 
   d="scan'208";a="79045360"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 07 May 2025 16:57:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gKrOeKQNr6+DNVqUT8Lv/kWW5oKLn972ad0SyN5jPi1wtyw74z0uQskOpz3tA2nHkv/cX5DFrjqAiqIMgjdn+N5Rbj/9sVnS+taGENWCng7YuZ+5BKlPKkrLkLIQofc06wXLW/RDvBF/aJ1Esg1RS6/615vtE/zHA5K9klK+S3AVj98rrI2S4CK5Sl2kczJhLQ1d2Fx7p6WGMI3QDqiBlxaFNXVOY0OsiWvZQZNsTpX4cJ9amDg0EAzhr2iiKBrLobjYjNlmS5i+d2WNM8W/r2M7Jdp3vBaGP/y6AOCL696JjMO+Kp0HBqFpfsbA46c/KJ2fR+pLui/QXu3K2esgzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hOhTa4+1+Tx9mQZF4nL0j56LiB9IXKv5oGOC8G81S4=;
 b=Za1MAz1tcdSNRI9P0TWFaRn1rGWQEITxQOuph9i/7Qed547z7XzgJL4EGnSn2wUcR4NMEb7Ej9BhBGVx4pORT3GrINKLglDIMZ8VOlRBUw4WYYiHEW8v46wGWWTgUOtIbjrloujdz3pDTzKaYZHWbKTW8Dw469ac40mm/WUHUnShWWzPHukYMczcJ5dfjNnvIeBRZWrtoGBei47jgQblQGaHaf7a1zJH6d+SFyIoLy38wUTETHyAVbDBHNCcT3Uy68guYdnbB3BuiuLKLnPJORa2U4kB6NqwnUxECFxNOBkA3SVYtwRmFOGteGHzr/mMEeNvl6bo7SBwQo+zgBpF/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hOhTa4+1+Tx9mQZF4nL0j56LiB9IXKv5oGOC8G81S4=;
 b=PmdWkbLSFYmWvsPoldVFBppCdyBT44A071WHe4T6huQfR9NOBrj/g5FbjPxo48B4T3tIHIZA1m3KuErgt+wXBdeYzH1B3WDv0Zf2NGw6KYw+zTnqzAq6QUF6oNARZGp9bCxJ4+BeYU3iRPR95GzPEWXjskjUcU938acRuqvCDZc=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DS1PR04MB9557.namprd04.prod.outlook.com (2603:10b6:8:21d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.25; Wed, 7 May
 2025 08:57:47 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%6]) with mapi id 15.20.8699.033; Wed, 7 May 2025
 08:57:47 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>, hch <hch@lst.de>
CC: "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "zlang@kernel.org"
	<zlang@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, "david@fromorbit.com" <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: add mount test for read only rt devices
Thread-Topic: [PATCH 1/2] xfs: add mount test for read only rt devices
Thread-Index:
 AQHbtcDlQOxnpwBoYku+VcbjviMnX7O0euiAgAYW+wCAAC86gIABcegAgAAfroCACp3+AA==
Date: Wed, 7 May 2025 08:57:47 +0000
Message-ID: <cd061e60-bb7e-46be-8b8c-31956e3ad255@wdc.com>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-2-hans.holmberg@wdc.com>
 <20250425150331.GG25667@frogsfrogsfrogs>
 <7079f6ce-e218-426a-9609-65428bbdfc99@wdc.com>
 <20250429145220.GU25675@frogsfrogsfrogs> <20250430125618.GA834@lst.de>
 <20250430144941.GK25667@frogsfrogsfrogs>
In-Reply-To: <20250430144941.GK25667@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DS1PR04MB9557:EE_
x-ms-office365-filtering-correlation-id: 96b0b25a-ac94-45c4-5278-08dd8d453cf9
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?c3hnWVowR2drUFFqYjJZQjNCLzBuZDVHQzh0b1JPZWpsZFhKTWg0WjRZQTVm?=
 =?utf-8?B?bHBTMlpQNWsvR2R2cWIzY1ptbnpuNWZpZUcrWE5Gdm1wMXh4UjRMWkl2ZWk5?=
 =?utf-8?B?M1dBSDNvbS8xN0NLRXh5Q1dQMm92bGJjUExvVUhJMUNhanhZbk50anczZmFF?=
 =?utf-8?B?RmFqT1dHMCttbWVFYldmcjlSSVMrQ2Z1UVdoUFgzbkNRd01vQUlLMVJEY2Nk?=
 =?utf-8?B?QndDbWtkM3BCREtnMTBSZmh1NitFR1QxNnRLZVdvd1RleUFUNUxzRmVOaTJZ?=
 =?utf-8?B?YVczRUpqRHJqRVorSkV6RHQxdGJOMkRHVngraHBHdE93em1Pd0ZXMmYyQ2Ux?=
 =?utf-8?B?STdMd05PdmUzVlpDaWpDZzdjc25XemUvcXlYUDVpS3E2M2x2NGdKbjNCSU41?=
 =?utf-8?B?L1VRNnM4U0p2QVJVMUNoeGZRRnU3NnJySDk2K3VNRVFFV09jUW9sUGNKcmtF?=
 =?utf-8?B?L0RYeFlicWpKaXg3bHhGY2Y4YWx6NHBWR0E5M2xWZ3lwalFQK2hoOXIvWUQx?=
 =?utf-8?B?TGlZZ1Bnbk5YRDlKVTh2VmlrRVVGYjNqNjFyeGc0MEV5SjV1Y3BTWGlWUmZk?=
 =?utf-8?B?MUhoNklEUnUxVzkxZHJsT1BRcVdveUMwRTlTQXZQM3BwNG8xL0tqSndObXQv?=
 =?utf-8?B?MGp3OTBoVUxsRDdXbDNTbTEwMllhWFZIdkY3NFBCUFdYL2xoZi9NSUU4VlNI?=
 =?utf-8?B?QmtpK0ZmMGlLSEtvTTRIUktqRXN6YVJESitCVEFlOWEyZ0NKZHkzQXdpY3Fj?=
 =?utf-8?B?eWdJb3ZJbkx6cnJOdU1TS3BHYXZHWHp5QlhnVkxCK2x4cUc4WkRjQmNkSldi?=
 =?utf-8?B?OWhJZUlBd0paMHBpbHNNNmJZWG1zVzNRMnFGZnhvMmg0enhHMUtxOWNRRFVY?=
 =?utf-8?B?RElwb2hZYnZmMzcyOTRuUkt3NmJWeEtEUU0rb0paTHM2ODl4ei9oRHR4UENY?=
 =?utf-8?B?MFljUmhQek41N00wNzZXSU94cE05TncrNk5tY2QyNFlUblNsYmZJZ1FYOXg0?=
 =?utf-8?B?dFNuOWFUQUMrTjlBc2phckdCZlFKYzgzRkxqQUtwSTA2eG14NjFHMGxYRGhl?=
 =?utf-8?B?VTR1Nk1iNU5XSHd4OTYvdmVDSnZBOFpsMHdmbGE0RW1raVVCeTVkMkZTK0Y5?=
 =?utf-8?B?SncyTXpOSXd3ZGlLY1craE0rZ0dscEYxa08vU3pqbU1jWWo1K2Y3V1dvaVJ6?=
 =?utf-8?B?ODNvSU5kTklKRTMzUGxiRzd0M0EzK0Y5WXdlSzR1TnlRY0hQeEJPa25wUFZa?=
 =?utf-8?B?QjJIMGE4d1hSWmtSQmNNSXk4QVdRazZrL3BaUkZlZ2QyZ0phRnVlSDVoVzRU?=
 =?utf-8?B?VUZWNkVaK1BLYVhFOWI3TmpXeEtHcE9sejhTUmEzTy9FRjEyTGlNajk0bUNU?=
 =?utf-8?B?MmpwSVZMaDRyd0FPWEg5K1UzeFRhVFd3RW1YODlaektXRTFSMjZ6UVlsT0FF?=
 =?utf-8?B?SUZiMzdlRE53U05OWUt4SG9WNEcwSkpzRjVCOXp3aXJaNDRPTUtsYnY5MitV?=
 =?utf-8?B?Mi9FZmxoRzhpazBsQ1dlVmcwbHZzMVZUTW4zdExIZUNtOEZPU0ZHYThDSElJ?=
 =?utf-8?B?cjF2N1dYUEhOK25EQys5K1lqdXpWTWZYZWNlaXZTV0pUTGo4Tm13RFJDdCt3?=
 =?utf-8?B?Umxpb1VBOEZIN0pzRzFSM0dHWFFtTGpFTFJOM3orNjRja1ZhSjVJZ0ZrRmJj?=
 =?utf-8?B?S3RSRDhXTHdCd3FzaVNIaldOM09FUk5EaTBBdnZ4bFJiQmVoVTZjTHpDZE1K?=
 =?utf-8?B?S3NqVSt2TUpqVDVRZFo0NEJ0d3FNa1BlWnRmZjFjL2c5K3plbHpoeWhpbHRS?=
 =?utf-8?B?aEkyaHlQem0zdmwrWlJ0SXhJdkprbEFaeEpaam5TYytSTTk3RkU4cVV2N3BJ?=
 =?utf-8?B?SXQ5T3hUTzRabDhKSUlFSjNaQWFJNno3NHhWcFRYUDVGT3B3K09EN2g1U3Mz?=
 =?utf-8?B?MnVCaGY3UG5sUW9qRmV0dm9FVVcwUmRtVGg1WHVpeVp2TFQyeFBjM2wzZTZs?=
 =?utf-8?Q?jiN8AV/eu17RlmE78J1Xy+3Uk+xVqU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a0c5WlJrNUc5MWN2K1hXTUhZQzVrTFp5Wlo0UUlhVjUvUVl4aktMNlBndUYy?=
 =?utf-8?B?ZUdZZEFIdVFRRG0xdS9OaVM0enRPMEV3TVhGTlBpNHZjMDZxeVVqTndSUGIw?=
 =?utf-8?B?Y2RBMWo5emtyWUxtd3JEbG5DN3BUcngxaC9jNG41bGJvMkQwQ3lhTlBsOWVz?=
 =?utf-8?B?OFVUSW8vVERvVW8zek9YcVpyMGdySnpSSXV4K092bDlITE5ITitKcXFVd3Qr?=
 =?utf-8?B?SDh6bTFFT3ZiTUNtVklnNmg1Z0gybUptajlHeC9iQ1puZFZnSDlsMnBNUnFr?=
 =?utf-8?B?UWRuR3NQVFJvV0luQm9RNnp5RmkyRnp2YWY3TlU2MnpucmxiVlJubUwzZlFX?=
 =?utf-8?B?MlJWbGkyLzNqVWp0WFFNYkFBMUVWUlJ1ZXJTNTdlU2pNeE1vWE8xQXd4Mi9T?=
 =?utf-8?B?dzNHN05kaU9TeEJmVHpoVmFGSXBFOS9QSW1Yd3c3c0Fxbjd1eTB5RE9Xa1g0?=
 =?utf-8?B?VXcydUt4RUpYa1lBajJTVVl2cnpub1BxWUVqZWl2WUpqZ094L2hWdEdiTVZC?=
 =?utf-8?B?NHNGQ3U0T3ZRNTFOZHpjSzFRU0lMdTkrZjI2b1VZUDdGT3B3ZmMvUmlyQVFz?=
 =?utf-8?B?VDNDSkcvTytxQk1XZFFrd3hVM0xZbkVDeWtYRXM0MTF5bklDdlZzM3lUSWFo?=
 =?utf-8?B?TFd2VTdwUzNMcXpqL1ptK05mR1RqYU1QWjh0SmcxVjFLM2hrNHR4V0VHNWNK?=
 =?utf-8?B?Q09GTVA1UXhTMjMxTUdBWjFLMEhqalNUNDNiYzJJNUlTUWZaaGpRTGpaRmZn?=
 =?utf-8?B?UEZMYk5LRWFOSUJ4eGZrR2xTdWhHUk5PZmc3MEl2VGc0bytwUU5DUXI3Z29S?=
 =?utf-8?B?azlRRWdxNlJCc2RDUlBRQlVPeTdQM0RsTGQyQVdNamlHWXg5ZWlEU2FMTVp2?=
 =?utf-8?B?Y0lTK0hRUVhRZDQ4V3MzVjNqcTdUdTh5S05nU3lQUnBKMHRaenRxZ08rS3F2?=
 =?utf-8?B?dFROSG1pTjBjQVBKK1hodE1uNzFKeWFHZUE3bXZHUndveGlncmc5Y0U5aDVj?=
 =?utf-8?B?K0NlZTdDdkdJeDJZY3JkWDMvWkVGa2MrbENiaXRKL09oaHZKd1l4ckVmVmIw?=
 =?utf-8?B?TlNhM2JMOTBMaG82QTlNM2tFSjJPeVZkd2Jwa0dYRWhJbzFJck5vUGFkSmIr?=
 =?utf-8?B?aitYcjRDNE1MRnl6clBJbnJJNi9QekpoRUdvbUYwT2thYS90SEY4MW5zL3ZB?=
 =?utf-8?B?ekJ5S2tGOVkzT3FkUzJMT0tkSWkzYjZxN1pQTU1GVmpIbEZ4VXg5Rmp6eUMx?=
 =?utf-8?B?R1JtUlIvZ2xwbTQveEVxZGxjdE9yQmRpZmY3VlpMZmpuQThqNFNhYmhsbVhS?=
 =?utf-8?B?OEFKWTZJbENVU09pWDdPNDcvYjNPZ2MvMFdsbHRLTWVkYnFpWkZEOUxPMFhs?=
 =?utf-8?B?R0dGTm56UnU3NHBpNU5FUm1wSGFjQm5sd2FRVzRPb3IxMEpGa0xKUklXaDdL?=
 =?utf-8?B?d0JnbFRqNjlrczZZY0RYazJZODEycVNSeVJqcmRZeFhkbmpLK2RCelpkaDNj?=
 =?utf-8?B?QnU3TzB1T0xyTWwxdnNCWHI3TGUwNVBGMm8rOEJteHFQZjhkNlhMMGRZUDBj?=
 =?utf-8?B?ZFAycTUzQXQxUjBmWTNXKzJDR0ZRZjJaQWFDaURpSTg5bm9SWWpsdUoxbjNz?=
 =?utf-8?B?dUFvWDZwTDZRaEJIc2JLSG9ZQWNidTdTNE1xZnMxaVFZSXlZekIrMFRxMnRj?=
 =?utf-8?B?NFV6RFdFTmIyR2tabWF6Y3dJdkhNMTN2UmdnQWpIQnI0KzA3TllwK2dsWmdx?=
 =?utf-8?B?a2h1Q0RTaStTRy9iU3E3U1NGS1BxZWwvM0FxWEVBbjNZSm5Fc2VPK1BqSkNh?=
 =?utf-8?B?VzhnZVVKQ3NYQ2VkTG1uWm1adEVhaHVQdmY5aHI5Qjg2VzhCTVFnWmZVRHZP?=
 =?utf-8?B?RDZOQkNBaWdKQW5QMVVVblNIR1lUelMvZVI1M2Z2TWFwdVhLNkx1dmlESmxB?=
 =?utf-8?B?OUl1QmtKYzc3RjJjSnpBRElIdDZFN1N4UlF6Q3VBS2gwbkNvL291M2lPQ0Q3?=
 =?utf-8?B?VHZvd3NHa2xPUkpXWVZpU0cvaXM1b1ZnVE1hcDBhLytXQ29GWUNNcnNQTy9G?=
 =?utf-8?B?NDY4MnpZckEvNWV0VHROalNqVWJmV3NYYlJyTXhBSTU4V2tkMko2bzU4ZmhC?=
 =?utf-8?B?YXZsUnI4K3B4M3o3RW15WnMwbUd4UklHTVNPNjQxWHhQd1BLY2VpMTZGYk1H?=
 =?utf-8?B?V2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34AF6469393CA14D9E70F3FC1BB67DA2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZV6t+59nYejEwYSUowCUhHwOuhAgLAqfDGIWLOP2HGsdll/GijttQ7lvm6KsbZPyQlu85ahBu+gCSlKKeV4SXykrR5g3dHro6y3lFxQzTrVrOdWHZXNsRb6bcphDbUFPdjoF9mGNjzuZ+7AE9piFKByU1BTzJ+4cPN2Hw0TVozDu0DKRLAsMir3g9x03hdryXN0GJ2oj8TFjb5wKtGHigoCCBOno93gqJWkFUn+bn/3/WAcalEY59fv5fwBBWKTtvmFW14KK2Ng0r0O/HnAB75boF4L+O4RejuT5PfzBO5AK/skFisT16IuKbrkOR9d48son5EKksRRAa3cb9jX4J32QeOUJryX7jQC1Avdw0IPgMAtQsUwDWvqEipSr7X+p/4VnYDQ/KZD7aX0XwmcWmN9xDUf4QSSl1jdAMTfPON+zf6TWPJHfTrRU4mR8sdJd5/VCXzG+GiZQ/z1ocAWpNK1DW3XKRXSpe1J+iKeN4hZ8M1wcFZHx4fCwbyTdVxYuvvQ3Tjg+dy+fja00fcgsL7SIRQYMlKRAD8VRRs1AO1RNfmL8QfM/1NVABscl0WdSQYYrFcGqpgV3ZBRgq9xyBGG4zvp9edkHwKvtX8V9eHdoNWomXa9XiLSNecQHKX9i
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b0b25a-ac94-45c4-5278-08dd8d453cf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2025 08:57:47.1239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ryZPXkpx4aKXDhYf2KiLomFrHleJB8G416QcWTv8qtL6N/A6/MRANsD0Ei9q4G6KpwF+5YON9QTBK2MomyVRFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9557

T24gMzAvMDQvMjAyNSAxNjo0OSwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBXZWQsIEFw
ciAzMCwgMjAyNSBhdCAwMjo1NjoxOFBNICswMjAwLCBoY2ggd3JvdGU6DQo+PiBPbiBUdWUsIEFw
ciAyOSwgMjAyNSBhdCAwNzo1MjoyMUFNIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6DQo+
Pj4gQW5kIGNvbWUgdG8gdGhpbmsgb2YgaXQsIHdlcmVuJ3QgdGhlcmUgc3VwcG9zZWQgdG8gYmUg
cG1lbSBmaWxlc3lzdGVtcw0KPj4+IHdoaWNoIHdvdWxkIHJ1biBlbnRpcmVseSBvZmYgYSBwbWVt
IGNoYXJhY3RlciBkZXZpY2UgYW5kIG5vdCBoYXZlIGENCj4+PiBibG9jayBpbnRlcmZhY2UgYXZh
aWxhYmxlIGF0IGFsbD8NCj4+DQo+PiBUaGF0IHN1cHBvcnQgbmV2ZXIgbWF0ZXJpYWxpemVkLCBh
bmQgaWYgaXQgYXQgc29tZSBkb2VzIGl0IHdpbGwgbmVlZCBhDQo+PiBmZXcgY2hhbmdlcyBhbGwg
b3ZlciB4ZnN0ZXRzLCBzbyBubyBuZWVkIHRvIHdvcnJ5IG5vdy4NCj4gDQo+IEhlaCwgb2suICBJ
IHRoaW5rIEknbSBvayB3aXRoIHRoaXMgdGVzdCAod2hpY2ggc3BlY2lmaWNhbGx5IHBva2VzIGF0
IHJ0DQo+IGRldmljZXMpIG5vdywgc28NCj4gDQo+IFJldmlld2VkLWJ5OiAiRGFycmljayBKLiBX
b25nIiA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+IA0KPiAtLUQNCj4gDQo+IA0KDQpJIGp1c3QgcmVh
bGl6ZWQgdGhhdCB3ZSBuZWVkIHRvIF9ub3RydW4gdGhpcyB0ZXN0IHdoZW4gd2UgaGF2ZSBpbnRl
cm5hbA0KcnQgZGV2aWNlcywgc28gaSdsbCBzZW5kIGEgdjIgc2VwYXJhdGVseS4NCg==
