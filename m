Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC1939D6F9
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 08:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774944279; cv=fail; b=uL/0ORFh3l60WsjinXy9O/+iNZHIdPLMegqOleaNWp1k6VwVQ36qamrkoNa/6hxC3+xapo64F9QNj1Jqs7sOb5Whjm166iyKW7x2nDX1ZIbygYCiGI/6h39tnwkzt7e6frlLKEkuQd4MDu/+DArFQhcYKzRaPjUvjgRj2o5PnUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774944279; c=relaxed/simple;
	bh=/ne4Jn7c8cqNaa7wQUszVw9Nl8Wz/ZpJ22Ce2W2Emdg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b0CR+quBXjSXhSCkLvO14DxeUNuDsX0zuaMcslUGSHtFLDZcKa8mSk2ULCIj5q8q6hi6SR//PCCW67Ww0ywvuBJMSukeAkSPGa42nHo/iF5d2gS4pO0G+XQ0y2bt4pRJVi1S+Ca8HyHbsEu4eAYaK6ZbqyfoQSt14KgGIar5RqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GDuqBreq; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=gcA4PZL8; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GDuqBreq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gcA4PZL8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774944277; x=1806480277;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/ne4Jn7c8cqNaa7wQUszVw9Nl8Wz/ZpJ22Ce2W2Emdg=;
  b=GDuqBreqF14TV/LV5tghh9bChy+p1vxiPwoAqxRuiBqhi1lCAA6+JAHF
   BrFy/vkqpSmLaYLSe2spQpqDDbXr9zxclJ3fx67ggS2U18Rbq0WGnDm5H
   ++R41xOP4SPGLsWI+TtIPQr48DMnNohdTiH5JRKfrHK65Ctw288qxmrrl
   INWo8gZk4Gmc+QpVz618xOn/wM4XeYm/99rpbp5QzosCvn9lw/xN/I6TY
   rgGCELZMZ4d1e4alCApOr8f2T20oQ0PDBaKyFLVU+1TAZv0IbLdeXYhzC
   IJobSW9F1mPlVU6/AtS9jBa9cDYvjkVw6FuvQr+9DypbWlhO+Rh4XsfW4
   Q==;
X-CSE-ConnectionGUID: Ms6dASsrQZeWqb5V96tfSw==
X-CSE-MsgGUID: HcNre7lMRXSvVvWaGVrx2Q==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="144724185"
Received: from mail-westus3azon11010061.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 16:04:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yNHx4p9puNium3A42zILYV1R2/Gjuof1B8Qv3CdgHdE0AMDcvmQjjC3Mep+8kp5EUa52rOZn3ocXjWq7BlXEwEUJmnpZpd2BL/IywL6qWr9h8NOPdGYkKTLMkernfKqZrYXaK0QzIiCvl20qNHTNYNAvAG6YWGsXnR7MP5wFif5f3ZCSUZZRFbzNTJIOGMV3L12fA8r8YtbbVXG9Q1dIUEmRhyu/R2wUwMyt1Z9zJNYiXj4xcvf4col6xe3keyLYCn7qz8U5Nbgv+GWM7PpMS4eUkZ5gvaoNpmwiYKFWEZnaX2stlscuy4+jQSG437ZIZGrmT2eo6IGwotYbnla2jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ne4Jn7c8cqNaa7wQUszVw9Nl8Wz/ZpJ22Ce2W2Emdg=;
 b=fjumhC47ukaItqU7TSRJuEuLZOGvld79KJk2VrOPBXKZeMSIkwvWeQaTj0x54j4sM+ZIZscJAP+kMQlx5zM27+95prBdOmt9zUCPth/XEhGUbUAbUS+CigbOpNesfVktRoUBUiLzvpyYJpqUK0Tgq6t7M9uiETGUdzwa10OT1wbOfEqQsm3qUuD+oO8XERq2i4wpp7N4/mFZevOSRyy2sGe/TPZPcg/WE3wwc7ccZE2N0pvg4Zs0ktpjufuKW/4oxOedYNOJqdrlrkD6Ej1FEjIwjpg8yWCWz0ljmEo4XgaHnmIbFp4Ub4X15E8/2oF1hBDrvbnbpT2ofI15n2FMzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ne4Jn7c8cqNaa7wQUszVw9Nl8Wz/ZpJ22Ce2W2Emdg=;
 b=gcA4PZL8cN0h6MCl6qA8MWrlJ2j1BO2ZxD73B3XBxm6QpgPYApEuir8J/PFfwk5v9jlWc4UiPqzDvkwdO332oI6cArm1i6RR3xSg3i4TlJTAX6y3C4lq0TUlYmpyFQW/m/oSETnNdztDFPDWvgRw5UClc1Dt4d0iIpX4/T8ZGlQ=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM6PR04MB7129.namprd04.prod.outlook.com (2603:10b6:5:24b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 08:04:35 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 08:04:34 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/7] xfs: put the open zone later xfs_open_zone_put
Thread-Topic: [PATCH 3/7] xfs: put the open zone later xfs_open_zone_put
Thread-Index: AQHcwAiETj2QW3H6bESJ9nBQOZqjJ7XISfQA
Date: Tue, 31 Mar 2026 08:04:34 +0000
Message-ID: <d4e86637-4406-4156-ba5b-58158c5877de@wdc.com>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-4-hch@lst.de>
In-Reply-To: <20260330054533.3856339-4-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM6PR04MB7129:EE_
x-ms-office365-filtering-correlation-id: 1a1400e9-de3c-4798-6d2d-08de8efc2595
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 DThTnH9tKSYQ9qr3V352kncuANZtJORqczMfaYinyPGMoi1+ZYo6or9r1VKh7e93wbbUno0n/83DAzN5uAzdjiNqhmybb0QjbfRCtuVal1YjaDn97uM9i38XiZNsgjVa0X3PVyiboJ2jFd1WM4nDVr+Vq8eF3x9NSN0CjebYa8UiE8lOO/8lxkXb7qQ3Ex3kKoWCVKpKO6dp1OrSCsGji+ZKy8Z44Xdjab620aaCEFDXW+bf3eI3rFz3+Lg5d/TghcPXD4Y93xa/6KkyzO9OFMpZtJUpzRjVJ2bXFZbbtXJvjJILTwT70uUoWBkCWO63zwBQfErbiDkap68bAPEx7Jn4WlhlAJEtpto6XY7G99u7NnH7lY7Jl7Xl+e19HVmG1iYjb4P41D8TJ7TDyInzTfGVYRR2W0OG7KmTer5e6KGJLCn/2bDg5JG6Vigfn7FonWUm5Pm4J1MiQfQhpypt73D5HAP74x9FpFmRZ6YSpUIsxKlu4lhERgBcE7yFEyRjNt3dvbcMshPGzXyqpxTZyB/PGon+9F6DdT7rNb8iIZPexCl37yvtnCp7yaiNP1ujK28iI08r3kyEnPy6sQm8nigvivbtLtFmozP27FKZ70F9p1Jmq2f/nTF+6Ahk90LgwmesKWrhyaMmvJmzL7sblV/PiCLLBMgtQR3xN3l66G2Xadj5xJKych4g0HfJ3xdAxBl66Jh9hOSsqZvUmBOGWI8A6StD/zGwGbM94Xw60pGlwLe3ARYF3+nmJg8tTwCvtASjCGNSTRee0agbd+jS+GkVvG5DDe+3xOENVrya6sE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d1NIMHpCK1ZGam5zcmx6OVNOczNUcjdCTWdWL3BVaitoTHBoM3l3YzdnTnV4?=
 =?utf-8?B?Mm9COUlMMnlHYmpJVFZZWGVpMmNpZ1ExemgrUzRCQ0hGdysxY2pMTWhWbnAz?=
 =?utf-8?B?SFE5NTY1OWJuRU9NV215VU9tbmJSSjgwcmR1Rmc2TjBKT1pVOGpXa1o0dm85?=
 =?utf-8?B?VW1IQUtET2dKQm5OcEwvdDM5QXA2aE4zRlR3dllheHRXYjZQRUhaUmd6QVFL?=
 =?utf-8?B?Tktyd1VFRFF0YUZ2K0xBekYwcTIzamJZYnQvZndsVUdFNlQxdzFWdFZtMmx3?=
 =?utf-8?B?eFpYR2hMYmxzRnVXVXN1UXI2dEhRTE8vbVJwa2VyS2FIMmVydjNSWURZWTRD?=
 =?utf-8?B?dEtDcDg3bVNPTmplcUhQbWJXQ1J1RkFrdWlSdDRYVmJoTjB3a0F1cXF3bDl6?=
 =?utf-8?B?eTY3ckxnRVM1bDRlOXB1WFdiaHFmUkoveDZVa2pUOFozcmcydW5maGVrRWJa?=
 =?utf-8?B?ZC9UbHZaKzNYL2I3TU1ndTZINTRzc2E2ckUzZ1gwK0NCTEpNd29zMGp5a2p1?=
 =?utf-8?B?VXlnc1BLdHgvWjU2WitoVmFLMUM2N0traHBXeXNQaEgxa0s4QVN1NmZiMTNh?=
 =?utf-8?B?WGFZdk9GNDBDNmwvRjNQTVQzczJWb0o2WnlUeFZWMGtnc0k3RlNiT05PYk1u?=
 =?utf-8?B?NS8xVHNxcE9zdHdheEdEb0hNTkpjWnUzRFBCai9Md1JTdXYwOURxcCsxQlNr?=
 =?utf-8?B?U1lBQStMbnJPM2dtamZiN1ZjZnFVVzNtQUFrOEpsWGZrSzdiWGtYc2YvaWZ1?=
 =?utf-8?B?L1Uvd1FnM1FSR3N0TlZ6Rk43TjFJZzh0S0NhWUlaQlpKajRPK0IyYmtBZjBL?=
 =?utf-8?B?Vk1jNTlBOWVzbGlKK1ozczUvU2gzc2hwcGpkZWl3dEdrUk1UaEtxcGcxUllK?=
 =?utf-8?B?aVNMTFF3UTVXTUNwVlplOTdNeHBWWjh2Y293VXF3ZG9HcjYxcUozR2dpRVFv?=
 =?utf-8?B?OGI4SUZKOStCWGV0U2YvT3hpa1ZuMDl2TFBkWUFwb1BDUnFXNmZYNUVOKy9Q?=
 =?utf-8?B?MmFlK3Q5MThvekF3Tm1TQVlyQUdXQ2xUUUdUR2ozNFZZVmJ1RVh6bkY2OTY1?=
 =?utf-8?B?OHlxcHpCSnozNVBnU1RyRmhZNkhmQitmTzlEdlhMLzVkd3Y5N2VrUmMrN1dB?=
 =?utf-8?B?M3RKT1RpOXVYN2FFbHVES0dvMUdLd3hPZmtiazY2Z1YwWEFLN0lIVWFkSHJC?=
 =?utf-8?B?SERHVjNNeGhuVmNORjRMMk5adU5mUlk2aGk2b3dlMmtQSlcybXNoRFBIbXNU?=
 =?utf-8?B?K3ZBVTkvNzVRbXQ2cmROcE5kYWFIb2lqV2V2dnFUdFV0a2gzWWNVVUltVjZq?=
 =?utf-8?B?RnJrcDhvY0xrWU4yMzFFTVNqTlFSNG9jZjNsMVFYYllsRWpiMTU5V1VJOUZy?=
 =?utf-8?B?RytOMmo4VDU4Zy9yTTlvRWNvckdUQWNYZkd5TG9TMkRKNHFZTWhGYVMrYzRU?=
 =?utf-8?B?ZGw5N2ttZm1ZSVN5dEpnYUhOYzNIYjY0c2YrWGJxWFFYOWh4ZjBabDRuOGUr?=
 =?utf-8?B?dW9nOFl5Q0I5RzVYR0U1a1JyZFAzejkwdjYrWUJIUFZxN1RNZFRiclo2NkRj?=
 =?utf-8?B?TFBoNmxPMnJpZDRrUEdWL054c2dralhOc2hNTDd0QzBOYXJPMmVkR1V0WDZB?=
 =?utf-8?B?YjdqSGpGem45RCtwS29tWnRYeW4zdm1NWHN2RXNaVG9aRnlNbTlRYzFDbktI?=
 =?utf-8?B?eDhRdHMrNXozYmFTM1BPTVBEcjZ3aHJFZzVrZlljeG5lalplS1hIamc2aW5S?=
 =?utf-8?B?NGVkdy9FSUptcXMydVlkNXRkTHV2cHVIU3hrck9heFplcmpXV2NNMHA3TzZV?=
 =?utf-8?B?dFZISHJWeVBXNUxhRE81RDE2MVNabVpOSFFYWVBBbDQ1bXdkaXdpcE1IeWdF?=
 =?utf-8?B?SmVCZ3c5c2tTa0FVVGZ5RmpMSlhhTm93empmcGJOVTdnNHlrcVROenhnOFRa?=
 =?utf-8?B?QjlreDZIbWc2enBaelRxMnhKSzZCSHJUMW4vdlNEbFNFdWNHZGR4L3g0dzFK?=
 =?utf-8?B?VEE3YTgwTTAzbnFwT3Jvak00VmNQakhYaC9YNnoySmFmbDN6Qm9IZ0dZbXh4?=
 =?utf-8?B?ZEQzSWdOcWwycmViUzhRN3FlaTRBQXBUWHp1UkxVZjM4aWVHZFF0N2N4RWFI?=
 =?utf-8?B?Y1I5L1RWWERUTmVycVBXVnRRZjd3K2hSOE1kL2RBTzNOeUpwVGxPTjRteVZz?=
 =?utf-8?B?WFJxS1ZRN2hoRS9ZR25IaGFxeGRWU3VpdzZCZXB5d3RpUUJ2RFpOdXJXSDRn?=
 =?utf-8?B?N1pEZmNzU2dsUnBrajh3eE50MjhrUWFWRzhJeHFnOWN3akJmTUdXemFrVEJD?=
 =?utf-8?B?aU1uMWx4WHNacHhoMmV5dTFCalREamIycFVuQ2l5NHl1SlgwL1BDdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E30701E9BEBC543999C6345302A823E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	vDJQzH7RNbPkxcCwmuVa1EjE/9LFDNn7cslhaQgkAvLSJz86OtjXsRVcrhMxljS7QOTaPaqoT5tcLPm8z8HFPrxhcymOWdaowmRCOYvI2jD6gh8hTkbNz3iVCD5LhBsgkwJrQCqA2lE0hhPOG8Rmyn7IdpT+eFwpre4ZGNcVmDxpPcguVAduoMnxV3Pq67M75arPx5YxQ5j7m2RDHIFGwkqy8bH7yWztgkjGBlyoxI1J4TTNmGRLu+tVah3zXOg/JsuVeL1hSTswqzmWXNJhCx5UMpYuy3TvW2iSMC1P5t2ogwqbHDBOZzJI8jW6O1DQIRke5a0Mrjk1A6mEU5yKCw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+cBgq5kcbakPwujJPEAl9as9yiHON9M/Zv/KT0VRdNCLL8/3uf0WtOyeAxSarxv/a1DkYZs9o+Kr2YygnguFpUbRC4J9cRfwYmUSVQGRdELBQhLIobJs90imqU7QJdTDWPpk/i5LRSeHBNJysCmSJdtpq2k3oeMCfHeM8OXLiX7nMUa1Go7DJIAviNteKo1oe9nuAb3tQcGeBEqBXhp0ZkJbeTpJdF1ba5EBE8gR8glh+BnX+SpEyQ+sfKqw/SEMi4Okp/PWEm7P2XU3SAWRn2YKwiC0+91Tc6MNu8hCp52GcGc8OTjrB2JfXmGHEEz0a40ObAQkUHCIAI7FSmGKbyNN04RZ9Msx3mmfSUzongAhVzyILz552HkdZXmcZk+wKnHgwyoI2O0U7Hpfe16WPIVUw85XqDE/QdhI6aodGmqqBRihwh4dNz3JmsvZzRqZy9IH0V2qTRIdEd0CanExiBx6wur8YdSodEkNA804S2tIXV0s9KcWJmwLeD5DhevFIuo1z/t7j1N/rojT8GLmcS/vjDlmcocrmJOP8cdWKpNjdKE/eYhJw2RRepUwAADsdTte9OCYgdFJ8gxBxkC3n58kkI+6cLLWx3Aj/Dep1l3v5bm4X47rGZdy5IAgN8bS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a1400e9-de3c-4798-6d2d-08de8efc2595
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 08:04:34.6361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JvJqKvLWpL3lzgFXhF8jSbddUNUJ4gMZpIKNdsJR/zvvxgmIQReSLqHCLY2/1jczMGDtckX6EWCmDPCLrpSQlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7129

T24gMzAvMDMvMjAyNiAwNzo0NiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFRoZSBvcGVu
IHpvbmUgaXMgd2hhdCBob2xkcyB0aGUgcnRnIHJlZmVyZW5jZSBmb3IgdXMuICBUaGlzIGRvZXNu
J3QNCj4gbWF0dGVyIHVudGlsIHdlIHN1cHBvcnQgc2hyaW5raW5nLCBhbmQgZXZlbiB0aGVuIGlz
IHJhdGhlciB0aGVvcmV0aWNhbA0KPiBiZWNhdXNlIHdlIGNhbid0IHNocmluayBhd2F5IGEganVz
dCBmaWxsZWQgem9uZSBpbiBhIHRpbnkgcmFjZSB3aW5kb3csDQo+IGJ1dCBsZXQncyBwbGF5IHNh
ZmUgaGVyZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0
LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfem9uZV9hbGxvYy5jIHwgMiArLQ0KPiAgMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZnMveGZzL3hmc196b25lX2FsbG9jLmMgYi9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYw0KPiBp
bmRleCBiMGE2YmM3NzdjMzYuLjI5N2E5MThiZjI4ZSAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL3hm
c196b25lX2FsbG9jLmMNCj4gKysrIGIvZnMveGZzL3hmc196b25lX2FsbG9jLmMNCj4gQEAgLTE4
MiwxMSArMTgyLDExIEBAIHhmc19vcGVuX3pvbmVfbWFya19mdWxsKA0KPiAgCQlsaXN0X2RlbF9p
bml0KCZvei0+b3pfZW50cnkpOw0KPiAgCX0NCj4gIAlzcGluX3VubG9jaygmemktPnppX29wZW5f
em9uZXNfbG9jayk7DQo+IC0JeGZzX29wZW5fem9uZV9wdXQob3opOw0KPiAgDQo+ICAJd2FrZV91
cF9hbGwoJnppLT56aV96b25lX3dhaXQpOw0KPiAgCWlmICh1c2VkIDwgcnRnX2Jsb2NrcyhydGcp
KQ0KPiAgCQl4ZnNfem9uZV9hY2NvdW50X3JlY2xhaW1hYmxlKHJ0ZywgcnRnX2Jsb2NrcyhydGcp
IC0gdXNlZCk7DQo+ICsJeGZzX29wZW5fem9uZV9wdXQob3opOw0KPiAgfQ0KPiAgDQo+ICBzdGF0
aWMgaW5saW5lIHZvaWQNCg0KDQpMb29rcyBnb29kLA0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xt
YmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KDQo=
