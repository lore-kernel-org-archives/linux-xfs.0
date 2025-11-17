Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D9715855E
	for <linux-xfs@vger.kernel.org>; Mon, 17 Nov 2025 09:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763371682; cv=fail; b=DkM0CprkAh2h0kILK+J91RjmFw3MQW2AoVjnDZoY31HA3dUUMYNa2XtU87D98/sYiqe/xlySLN9zPEwiZE4UCfpLjj0xwi1DTdSIHYygs9sEumYwVf7e0HojzVjWZdsubja1tGLvG0KW2N1i4rHa9C4p5vYTAN7p/K1jQRgBbBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763371682; c=relaxed/simple;
	bh=ysMD+oGPWEhi9BNPcW4EFb6nLuAFcL6LWgmKyJi9lVU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dSR6fUidFKXy0ETlaqGOanK5qd4nIhf9ghOzR0h6CzzR8xH6iQlOt1IZjcTVNbH/xtnfc68DWA8jsy6JGUwCNA/3dwi+pV+a6B1OLQsxVnt59uHpQiaHNOI+n07s8lV9siWRCwhzUj5PiwNFECwmTq2Tzq3MeuCNCAYjT+dP9Vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=IoFIdUbs; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=F5WGhqgK; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IoFIdUbs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="F5WGhqgK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1763371680; x=1794907680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ysMD+oGPWEhi9BNPcW4EFb6nLuAFcL6LWgmKyJi9lVU=;
  b=IoFIdUbsjWFo/VQ/FeZYo4e0De9EesCd4L3yr9xDKi79RiLnLjR60jb0
   pU8ooTwdN0ruAkp75bCXHy9m35fE93dGRm3fHUAAxDAOtEvHl/TUJoTRZ
   Sph3nnZDTcpMJeTOSlEbK3lgnt/C2NQBj5U5lFTK8/fKqKHwNFQtCAfJA
   WCyAhki6MAecYyXnHflXtFN/vwXmg86ECu6plg0po0hkn2LSEABW6mZC6
   8ulDpvUJaj3Rd1yX8ElYx6STh8DIlLMQA5nwsvE68ZLg/PC5t+B8eozWa
   72T500zq2Z1S439eyzU39nnzIDlRhFfq17r+/GClTyXX2VEhkUt5fwHDu
   w==;
X-CSE-ConnectionGUID: oXnBe0g8RfG2zTIxr7zNJw==
X-CSE-MsgGUID: JCX7lie5T56cygVvM1Y1Mg==
X-IronPort-AV: E=Sophos;i="6.19,311,1754928000"; 
   d="scan'208";a="134870630"
Received: from mail-southcentralusazon11012060.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.60])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2025 17:27:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rbH8ysQo2EHya9zhmC1srbTu/ZY0w3vlj6My4pI0CHm5eglnfmCroCawLn3P34yLAatd7QxH7qgmVNkzx1dEzwjQKb7NRPn7z5a8Jp69Me16PkWd3fEsutSxWX6K9fXtDRAcotLJBVhY9J2X9t0X63YdDlvKjXjvkoqQ2vM6zpCDmvmP31HdslI0UvWQACn/lWbluz5AA9hkqjMhoi7OtxZtOl1KUuM7XiZ1sXKxUU5zZRIyeKk+6DO6BL1a9BheC3H0IevJQzljqW0QszrWk09M/+AArM0FoRNYL5fPXtClZsBi0U6go6HS/rff9/MmCr3vuDORTRP8VDpB3hP+ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysMD+oGPWEhi9BNPcW4EFb6nLuAFcL6LWgmKyJi9lVU=;
 b=iz+obtmXE5rNVUbkT7fYl1KKxDyXqOlZja3o7S+5ETptAonRi81mGOoXl4er/SotKiey/64fG/6sdfpCDvNbl2+eGdPcGhE9SF1NNC6A6lUA+zPFWyj1wO2fguiH1ecsD26miF8eP+/iEi+XXA8u/xkp7TsiAgeMXUCFLBi6pSHLOZK8pAaCsUKEiBdNEKxjooZbUel6+yvm3T0jZOs3Jzss1sQLsEp/ydCBgPShPMEsPIDgkp2M/oNUFMb0S65qg//QHpdaAut5f+mFJ1LFM/fYQuJ4nsTU3CMsbAlRzQ8H5XM0SNbxwoG2FwXDUEWXG4lB6IBPlZkpLqcXAJMtHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysMD+oGPWEhi9BNPcW4EFb6nLuAFcL6LWgmKyJi9lVU=;
 b=F5WGhqgKB0e8/Mesv16184JNMcvs8SXMl+f8VDzyaQUQaQZd1R2u1aFPf7OR3GzbGo/6qtmypPWIRqQIRG1OKk478tg11h6r/zUUJcjKasJOPAliFCLpgopItlLK6HCVdBWYbrjmX+JqJ/idQaalcJs8pLt/PkysFhRaqcRDcN0=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 09:27:57 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 09:27:56 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "cem@kernel.org" <cem@kernel.org>, "aalbersh@redhat.com"
	<aalbersh@redhat.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, hch <hch@lst.de>
Subject: Re: [PATCH V2] mkfs: fix zone capacity check for sequential zones
Thread-Topic: [PATCH V2] mkfs: fix zone capacity check for sequential zones
Thread-Index: AQHcVKeK8RkU5iEZiUGeT6A3GITJqrT2n5mA
Date: Mon, 17 Nov 2025 09:27:56 +0000
Message-ID: <00dc1669-cce1-443d-ad0b-f04ab4941ba6@wdc.com>
References: <20251113134632.754351-1-cem@kernel.org>
In-Reply-To: <20251113134632.754351-1-cem@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BL0PR04MB6564:EE_
x-ms-office365-filtering-correlation-id: 679306a4-8d11-4e47-f716-08de25bb9760
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?aXJwMW0zdThZVE5JOFo2SzVaeGFiMnZCNkhZZW9Zc3JVSTg1Nk1LcGV6M3lj?=
 =?utf-8?B?blRHWklzWlRJVWZCMUxJZXNhT3VsZERMSEhmZkJxcGJlM0VIdW1vNS9aNGtx?=
 =?utf-8?B?MjVNZjdKdXVTUkFTblNpcTF2NFY4UDJTMUl6WnFZcmFnRUtmejl4RGplQnkr?=
 =?utf-8?B?MkVPMEdYek5pTDNFblA1VmkwWXJPa1BtTDEzM2NiamY1S3VWRXd6dkRDNWdW?=
 =?utf-8?B?V0R4eHdkcEJEdEZUdnNIaENwaHNKRTJFZHlnODQwdXJTWTcvUjFhVEVhTlNN?=
 =?utf-8?B?WVI3SUdJZC84bjlaZXIrTlZkMTlLd245OXo1RkFXeGZHNXQ1RDBwYkpudExJ?=
 =?utf-8?B?eUhDUjQ3aVh0eVRaeUdmVXdzVldSODhncWJUMVJlSnpDUlhoeGNuY25hZ2tZ?=
 =?utf-8?B?bUtONkZHMGQvQlZBRFVreDVLcFdZa08rb2hxR2M3YWRrUEVZUzM3Rmh3REhS?=
 =?utf-8?B?WGxLeDlWek9qNnVlZjVCbGFma2s1TU5tWjhpZndodlE5LzIwTDJQSS9DaUJo?=
 =?utf-8?B?elk2QU0wcTdVcDdFbU9LWHo5ODF0bW1TYkxMQUpXTFVBa1JrdmRFaW9FakRy?=
 =?utf-8?B?bzhDZEFlMUVMcEdPV2RFVmZ5amdERTV0aW5lWnJnclJCaXhudkhaNEZRNzJS?=
 =?utf-8?B?VS9FRFZZVzV2Uks5OU5uczBFUWxCRVY5VENvVkNodzRNb29YU1NQUGFieVEy?=
 =?utf-8?B?RjNFU1dRemp5N2FnVGZ1UzBiSXF2MWhLV2dQZW12YU8vNWxmQTV2ZVVrTXI3?=
 =?utf-8?B?bENNLzF3Z005RDN3RDdYQSt6MW9lRm5ydXgzNVUwNjVLZlcycGVPMW5xeUsr?=
 =?utf-8?B?czB4cmxRU3pmbUpGTUJ0blFxQjNhYTNyZzI2Y1UxZTh6c3A3VGlKSFI1QmM1?=
 =?utf-8?B?ZUQzdVI3ODNXMEwwZEZOV2t0L0ZqNG1lbS9IK25zL1Z6eDExc1djdGUyTm5K?=
 =?utf-8?B?T1JzYTdGV1RZM0cxRXI1UENOeTlXQWo0ZzhBN2FzMHBhMUllOXNoQ3ViczYz?=
 =?utf-8?B?aDR4ek5kWGYvL1VZVTFBb1JrcU9QOGQwREwycW1rSW5IcUhoWWt5U2I1VXNH?=
 =?utf-8?B?UFJ0UGRBcEtlcmtSTjB0b0ZqY3hjOHlsVG13U3FxZW5BSHc1U1VWRFg5N1c0?=
 =?utf-8?B?U0V0aXhtZDZ0RzNFSkpuQzNtbW0yV0dyS05WUUNlN2RsSzgvdEFreDc4MW4x?=
 =?utf-8?B?OXk2c3hPSGltampZcW1IQ3V4V2RFb3lrL3RtM3RQZGdKYjFqL2U0OCtwMVFs?=
 =?utf-8?B?dS9CcnQ2MWljZlhaVVdvdGNrVlhpeG5Pa0dFUU1jbDVTNmdMY3FKckRyY05I?=
 =?utf-8?B?RG9BZ25uQ1VWQjhYbXlwcHN3Qm1pc0F2cFU4SE9GNzlZVm5OV3U2a0V5anlJ?=
 =?utf-8?B?bEpmNWNlTVJUSWZIMGpuZXlMVnlHLy8xLzROUHd4eTlRUkRWSWQvd1NWWGlQ?=
 =?utf-8?B?cWpWbW95MzhXWlVSckpSZUloVkY3VXliZlkvYmZ2OWVqOXJMSlFkd1NXLzkz?=
 =?utf-8?B?UE1hTGd6TTB6RkMvRk9sV0VhYkw0c0hCM2ZtMUNYWDA0UUQ3YXNFSS96SXhs?=
 =?utf-8?B?WDNneXR3SG9xZ0czNkRIUXBEa2ptQzBva0I4NnBtalA5VDdTakdSYTRuTnBR?=
 =?utf-8?B?TTVuWlU5ZzI4eE5FRDJRa0k4SGhwR25iY3J2dDBscEE1SDF3MFBzQ1BNdDU3?=
 =?utf-8?B?V0xWbXdrQ2dqVFNDc3E1QXFEdHB6MFR1WVFwdm9TVkYxK1pkNUVrN3ZHYmI2?=
 =?utf-8?B?RVJUM3ZqcmxjWmhoMXRRaWVDUU16TEZrKzZ4cmFHZW5kRDJkaFZJZFBrNitp?=
 =?utf-8?B?TVFJOGg4cW9EaWFVWmNqbC94K1Uxb0lGb3lHODVDWkV0ZzF2Wm4yZzRkOW1U?=
 =?utf-8?B?ZU1YQ0VwYUo1MDhQa0k5dDBobVdwK0VkdnlMeFlaUHhuNndmc0dseUFvYllJ?=
 =?utf-8?B?LzhVVWxuMHUwS1RCSnlqZGNacGs0bEFUVktCZnVQNXR0NmdHM3ZWbmRkZUZK?=
 =?utf-8?B?VUNCamU1a2tBSTlhZ0V4RTFJNXI2dnlnS2pwMVpsUW8yQnBqQmtZd0NYRkF2?=
 =?utf-8?Q?DQfBz8?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZlBVVS9GVHE1ZFNTWnd6Tk81UlZKbzhPRFR6dFRnbVQ5cWVKcGhXS0lBQzFH?=
 =?utf-8?B?dW9uUTlTcUdCcFZqek5KRmJHdlRCQUZOV0Z5VlFQdXNNdHQxdzBiNUNiTmdj?=
 =?utf-8?B?ald6R2JsTHhWWFVSSVhGOVdkdGhOR2JoSTBjYWptdTFvekJTQW9GclQzQlpx?=
 =?utf-8?B?SHQwV29mdDlGTTUzalhHT0crSTZjbmh4c3hvTGdHd3ZVR1FqMTRsQTJzVGlt?=
 =?utf-8?B?L1ZXeHBGTnJuVDlieXM0OGpZSnBHd0dKYnQyNDJtSEZJb0ZVeUdTQzUzU1dy?=
 =?utf-8?B?bHZER3QrY1Y5bm1qU3Z4YUFyY0VIMjRtUytHZWIxT014VVlXZ1YvLzIrVWQx?=
 =?utf-8?B?eUxiSUNLelM2OEt3dnZNa0dqNXdoM3h5ZzRMZEpXTC83U1Q0SVBFV08ycjdJ?=
 =?utf-8?B?eDZ2U2RHcW5pU1QyQUx5bmwxN2RibGY3RSt0VnRIcmpEQTN0c0xUc25PS0Fv?=
 =?utf-8?B?bmNLOFRxRkJ2KyttUmhXM3JseU5PN0Vsdzd6dklzWW85eThTQm9EajNjdEdO?=
 =?utf-8?B?dFhrWGhBV3hzYS9wTHdScWw0aFIxMUNJMnNlcGxobVRnSTRKdmgzWVFpU1c1?=
 =?utf-8?B?MzdQMUJ0d3piYVVsYVE0clMzdTZ1eWN0Y1JUaVB3Z0hheVFrT3VVbTVSOFFx?=
 =?utf-8?B?TmhNdVM0c1NRSXRiR215dmJjNlovMGFEMmo5eGh1VG1mN09DTUIzOElaUmNv?=
 =?utf-8?B?YVhZVWx2ajRTaHBMeEZhM2M2UGZXZUYza2JkUjI3bEppTlFkakhGYzYrSy9H?=
 =?utf-8?B?Slhvb1dwdUhxNzdxZFpHbWphSXQ0ZHRydGxmcXQwV1VGaXF3TWVETGZLSTIw?=
 =?utf-8?B?RWJ2WUxLNGpDSTBKeEJqV3M4SDhpanl6SDkvdWMrMEp3Sy9TV2huSEZ5Szl6?=
 =?utf-8?B?N3N4dmNCcHRQbE1CN1FzZnc1TTd6aVFyUDY4Q01vWHFzNURydEY0TGpIU1Jk?=
 =?utf-8?B?MVRxVFVOc1hMcHdQYm1vVG05VEJMRTdnVHR1NGVqaHF6Sjc1OXVDVnVWRStP?=
 =?utf-8?B?UHQvVzJoVmZIOE1qMWlhL3IyMkQrSjRCcWJERVVpZm1scURlbnFJait3MURt?=
 =?utf-8?B?ZjI2M3ZNMjBvMENRb25icms3TFB5WEE4dFM0TmJGWVRlTTBhNU1TNHdxSHFZ?=
 =?utf-8?B?Z01teHJlK0pBSG9BTWFVYnFadUVaUkFCUlBQN0VuOTVyQ2ZpV2FEeVRHZlNR?=
 =?utf-8?B?aVZyRTZaSlU3cDRkV2w4bzVySGUvbGNsZW5KaVBTUXV3d25uL05nMTBFMC9X?=
 =?utf-8?B?QjRxT2tLMnJQekFlcFBNV1NLYkZ0RHJQRC9YRktsVHZzcWxZbnV2MXhyYzc0?=
 =?utf-8?B?T25QWHlhaXR4d3lPTGlmUTUvRkZXb2ZoQVlYRThQNVE4a3RBOXhQOVZJTVBy?=
 =?utf-8?B?c0YzMGdtUFFZNHFHK3Y4aHNmUGIrdHI4Mmt3b1hTVUpoQ3VwSHFsWVFmeFM3?=
 =?utf-8?B?M0hLMXBlNVRrZ2EycVFIa01FNXZZYlNabWhoWEdGK3NuK2xsVlVQc0RhRmNz?=
 =?utf-8?B?UXhvUzdaMWVBdVBkcnprb1BPNFc3bWlUZDVHZWlJOUY2RGxweU5sV09KOExR?=
 =?utf-8?B?U1Nic0dSYTdIcmp6c3A3a2I0TjI4dGloRm5UcVo4QmpVenRMUFBQZnhMbkY5?=
 =?utf-8?B?cFNSbElkTHhuaExKYjRXMnFUQkRYQWFDd0VyTXRvakhCbUtFSW9acTg1dFJV?=
 =?utf-8?B?cVNsNEVjZ3dMdVczdlZqYXN1U1MydmRUY1RmaU1NaW4rNEFjS3JleC9uQnF0?=
 =?utf-8?B?Tjh6Y2JtVXRNVmRJUXRnR3M3SjRoc3VSbnlOaXgxUlF2ZU9yRVJqeGRiR1pi?=
 =?utf-8?B?NkVPcmp5eWRFZXpaMkZqdWNnTU9yRDFhNytYOXRENHY4YlZzVEtmZU5kaTVP?=
 =?utf-8?B?R2lRcnhEdDc0clV1U29ERndtcENsZ3BlaGdaOVlkQi9UQXRBYjRPaFFQT0x0?=
 =?utf-8?B?UWpjeDYzN1pMWDJqK0dEQlZTa2ZzcmtzMkxiWDR2WDQvbVpqcWNBWWJTMzNs?=
 =?utf-8?B?VVB4UlBsTmRKQ3VkOWhxREpldy90U0ZPYXpObHBDcHAwWGtWZkZRTE8vRE40?=
 =?utf-8?B?YkJGT29SdWFlUVhEcUZJaTZIU09NTVZzM3dKVlgzY0YwWTZZbTNzOWFtU1g1?=
 =?utf-8?Q?OJWXSFJIUQiAbguqXFABcgiG1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB86E3CBCBBB974E8D3558A67BC653C0@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rWQOfbh+giXJ1YlyltRdZQh25emZYq5LnPrnpZPH8PzAhy+YeFMgJYMC2X7LFt4/Z9n83Wb7eQ+089udIo9IYmDTu+TOVG1t7EANOStS1kc6KEs6csG+QcHI1JPGwau6+kmP8G/pRALdGQ1ZzEeY9BvpCDCl+3iuLEup2ikNoPYTFYvr7McifWRhhHjF7IcwPwJ0hf+B1nmSnk7/di+ifVY1iIDPUqh7PQady7lmTb/Q3ZnX7QToFLDnB1gWAyCkeB/QYQ9FtzSRWZ1AIkAjZIMuEK2FZDylQZKQcvBPQJxIS3ICI98XeLRCLTf6bjTQxNofLievoa1G79Dr5VqGDsTp6mhkjZ6rrzcTTTfvg9Wxj4swRGkl/IxofxSDYMmPevmFUjDfy9FdJUxj5pnlm8ARyIrYtR/R5VvxgCkNQn1+uWQuXHndJCLMFspJlDihc9SXqonp7zGQ717oAE1Gg4c0k3+/Zmu9sU//gbxxONtnbUWroSfkw01nLSpSkpJjHnXthjFLQk0txfEaO+KQJAzUT5FrlXpETu25vgCzAQw/NWIKHN7+zdxqc7nOAQIpLfDXbCrx8c+G49WpmsEZ+7bUCE7lpoUuuV0FpcMFbn+hBcBH70CyV3bCyPQAV4vB
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 679306a4-8d11-4e47-f716-08de25bb9760
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 09:27:56.1418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h4PYcwS+ucg60FtHmMRf8ac5GnkiaSvxwT4clDBeJR6Jf+Hz670n35M1jhK4aybccqjjI5C+aDSfWflAPv+P3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6564

T24gMTMvMTEvMjAyNSAxNToxMiwgY2VtQGtlcm5lbC5vcmcgd3JvdGU6DQo+IEZyb206IENhcmxv
cyBNYWlvbGlubyA8Y2VtQGtlcm5lbC5vcmc+DQo+IA0KPiBTZXF1ZW50aWFsIHpvbmVzIGNhbiBo
YXZlIGEgZGlmZmVyZW50LCBzbWFsbGVyIGNhcGFjaXR5IHRoYW4NCj4gY29udmVudGlvbmFsIHpv
bmVzLg0KPiANCj4gQ3VycmVudGx5IG1rZnMgYXNzdW1lcyBib3RoIHNlcXVlbnRpYWwgYW5kIGNv
bnZlbnRpb25hbCB6b25lcyB3aWxsIGhhdmUNCj4gdGhlIHNhbWUgY2FwYWNpdHkgYW5kIGFuZCBz
ZXQgdGhlIHpvbmVfaW5mbyB0byB0aGUgY2FwYWNpdHkgb2YgdGhlIGZpcnN0DQo+IGZvdW5kIHpv
bmUgYW5kIHVzZSB0aGF0IHZhbHVlIHRvIHZhbGlkYXRlIGFsbCB0aGUgcmVtYWluaW5nIHpvbmVz
J3MNCj4gY2FwYWNpdHkuDQo+IA0KPiBCZWNhdXNlIGNvbnZlbnRpb25hbCB6b25lcyBjYW4ndCBo
YXZlIGEgZGlmZmVyZW50IGNhcGFjaXR5IHRoYW4gaXRzDQo+IHNpemUsIHRoZSBmaXJzdCB6b25l
IGFsd2F5cyBoYXZlIHRoZSBsYXJnZXN0IHBvc3NpYmxlIGNhcGFjaXR5LCBzbywgbWtmcw0KPiB3
aWxsIGZhaWwgdG8gdmFsaWRhdGUgYW55IGNvbnNlY3V0aXZlIHNlcXVlbnRpYWwgem9uZSBpZiBp
dHMgY2FwYWNpdHkgaXMNCj4gc21hbGxlciB0aGFuIHRoZSBjb252ZW50aW9uYWwgem9uZXMuDQo+
IA0KPiBXaGF0IHdlIHNob3VsZCBkbyBpbnN0ZWFkLCBpcyBzZXQgdGhlIHpvbmUgaW5mbyBjYXBh
Y2l0eSBhY2NvcmRpbmdseSB0bw0KPiB0aGUgc2V0dGluZ3Mgb2YgZmlyc3Qgem9uZSBmb3VuZCBv
ZiB0aGUgcmVzcGVjdGl2ZSB0eXBlIGFuZCB2YWxpZGF0ZQ0KPiB0aGUgY2FwYWNpdHkgYmFzZWQg
b24gdGhhdCBpbnN0ZWFkIG9mIGFzc3VtaW5nIGFsbCB6b25lcyB3aWxsIGhhdmUgdGhlDQo+IHNh
bWUgY2FwYWNpdHkuDQo+IA0KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+DQo+IFNpZ25lZC1vZmYtYnk6IENhcmxvcyBNYWlvbGlubyA8Y21haW9saW5vQHJlZGhh
dC5jb20+DQo+IC0tLQ0KPiANCj4gQ2hhbmdlbG9nOg0KPiAJdjI6DQo+IAkgLSByZW1vdmUgdW5u
ZWNlc3NhcnkgYnJhY2VzDQo+IAkgLSBhZGQgaGNoJ3MgUndCDQo+IA0KPiAgbWtmcy94ZnNfbWtm
cy5jIHwgNTAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0t
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL21rZnMveGZzX21rZnMuYyBiL21rZnMveGZzX21rZnMuYw0KPiBp
bmRleCBjZDRmM2JhNGE1NDkuLjhmNWE2ZmE1Njc2NCAxMDA2NDQNCj4gLS0tIGEvbWtmcy94ZnNf
bWtmcy5jDQo+ICsrKyBiL21rZnMveGZzX21rZnMuYw0KPiBAQCAtMjU0NSw2ICsyNTQ1LDI4IEBA
IHN0cnVjdCB6b25lX3RvcG9sb2d5IHsNCj4gIC8qIHJhbmRvbSBzaXplIHRoYXQgYWxsb3dzIGVm
ZmljaWVudCBwcm9jZXNzaW5nICovDQo+ICAjZGVmaW5lIFpPTkVTX1BFUl9JT0NUTAkJCTE2Mzg0
DQo+ICANCj4gK3N0YXRpYyB2b2lkDQo+ICt6b25lX3ZhbGlkYXRlX2NhcGFjaXR5KA0KPiArCXN0
cnVjdCB6b25lX2luZm8JKnppLA0KPiArCV9fdTY0CQkJY2FwYWNpdHksDQo+ICsJYm9vbAkJCWNv
bnZlbnRpb25hbCkNCj4gK3sNCj4gKwlpZiAoY29udmVudGlvbmFsICYmIHppLT56b25lX2NhcGFj
aXR5ICE9IHppLT56b25lX3NpemUpIHsNCj4gKwkJZnByaW50ZihzdGRlcnIsIF8oIlpvbmUgY2Fw
YWNpdHkgZXF1YWwgdG8gWm9uZSBzaXplIHJlcXVpcmVkIGZvciBjb252ZW50aW9uYWwgem9uZXMu
XG4iKSk7DQo+ICsJCWV4aXQoMSk7DQo+ICsJfQ0KPiArDQo+ICsJaWYgKHppLT56b25lX2NhcGFj
aXR5ID4gemktPnpvbmVfc2l6ZSkgew0KPiArCQlmcHJpbnRmKHN0ZGVyciwgXygiWm9uZSBjYXBh
Y2l0eSBsYXJnZXIgdGhhbiB6b25lIHNpemUhXG4iKSk7DQo+ICsJCWV4aXQoMSk7DQo+ICsJfQ0K
PiArDQo+ICsJaWYgKHppLT56b25lX2NhcGFjaXR5ICE9IGNhcGFjaXR5KSB7DQo+ICsJCWZwcmlu
dGYoc3RkZXJyLCBfKCJJbmNvbnNpc3RlbnQgem9uZSBjYXBhY2l0eSFcbiIpKTsNCj4gKwkJZXhp
dCgxKTsNCj4gKwl9DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyB2b2lkDQo+ICByZXBvcnRfem9uZXMo
DQo+ICAJY29uc3QgY2hhcgkJKm5hbWUsDQo+IEBAIC0yNjIxLDYgKzI2NDMsMTEgQEAgXygiSW5j
b25zaXN0ZW50IHpvbmUgc2l6ZSFcbiIpKTsNCj4gIA0KPiAgCQkJc3dpdGNoICh6b25lc1tpXS50
eXBlKSB7DQo+ICAJCQljYXNlIEJMS19aT05FX1RZUEVfQ09OVkVOVElPTkFMOg0KPiArCQkJCWlm
ICghemktPnpvbmVfY2FwYWNpdHkpDQo+ICsJCQkJCXppLT56b25lX2NhcGFjaXR5ID0gem9uZXNb
aV0uY2FwYWNpdHk7DQo+ICsJCQkJem9uZV92YWxpZGF0ZV9jYXBhY2l0eSh6aSwgem9uZXNbaV0u
Y2FwYWNpdHksDQo+ICsJCQkJCQkgICAgICAgdHJ1ZSk7DQo+ICsNCj4gIAkJCQkvKg0KPiAgCQkJ
CSAqIFdlIGNhbiBvbmx5IHVzZSB0aGUgY29udmVudGlvbmFsIHNwYWNlIGF0IHRoZQ0KPiAgCQkJ
CSAqIHN0YXJ0IG9mIHRoZSBkZXZpY2UgZm9yIG1ldGFkYXRhLCBzbyBkb24ndA0KPiBAQCAtMjYz
Miw2ICsyNjU5LDExIEBAIF8oIkluY29uc2lzdGVudCB6b25lIHNpemUhXG4iKSk7DQo+ICAJCQkJ
CXppLT5ucl9jb252X3pvbmVzKys7DQo+ICAJCQkJYnJlYWs7DQo+ICAJCQljYXNlIEJMS19aT05F
X1RZUEVfU0VRV1JJVEVfUkVROg0KPiArCQkJCWlmICghZm91bmRfc2VxKQ0KPiArCQkJCQl6aS0+
em9uZV9jYXBhY2l0eSA9IHpvbmVzW2ldLmNhcGFjaXR5Ow0KPiArCQkJCXpvbmVfdmFsaWRhdGVf
Y2FwYWNpdHkoemksIHpvbmVzW2ldLmNhcGFjaXR5LA0KPiArCQkJCQkJICAgICAgIGZhbHNlKTsN
Cj4gKw0KPiAgCQkJCWZvdW5kX3NlcSA9IHRydWU7DQo+ICAJCQkJYnJlYWs7DQo+ICAJCQljYXNl
IEJMS19aT05FX1RZUEVfU0VRV1JJVEVfUFJFRjoNCj4gQEAgLTI2NDQsMTkgKzI2NzYsNiBAQCBf
KCJVbmtub3duIHpvbmUgdHlwZSAoMHgleCkgZm91bmQuXG4iKSwgem9uZXNbaV0udHlwZSk7DQo+
ICAJCQkJZXhpdCgxKTsNCj4gIAkJCX0NCj4gIA0KPiAtCQkJaWYgKCFuKSB7DQo+IC0JCQkJemkt
PnpvbmVfY2FwYWNpdHkgPSB6b25lc1tpXS5jYXBhY2l0eTsNCj4gLQkJCQlpZiAoemktPnpvbmVf
Y2FwYWNpdHkgPiB6aS0+em9uZV9zaXplKSB7DQo+IC0JCQkJCWZwcmludGYoc3RkZXJyLA0KPiAt
XygiWm9uZSBjYXBhY2l0eSBsYXJnZXIgdGhhbiB6b25lIHNpemUhXG4iKSk7DQo+IC0JCQkJCWV4
aXQoMSk7DQo+IC0JCQkJfQ0KPiAtCQkJfSBlbHNlIGlmICh6b25lc1tpXS5jYXBhY2l0eSAhPSB6
aS0+em9uZV9jYXBhY2l0eSkgew0KPiAtCQkJCWZwcmludGYoc3RkZXJyLA0KPiAtXygiSW5jb25z
aXN0ZW50IHpvbmUgY2FwYWNpdHkhXG4iKSk7DQo+IC0JCQkJZXhpdCgxKTsNCj4gLQkJCX0NCj4g
LQ0KPiAgCQkJbisrOw0KPiAgCQl9DQo+ICAJCXNlY3RvciA9IHpvbmVzW3JlcC0+bnJfem9uZXMg
LSAxXS5zdGFydCArDQo+IEBAIC0yNjgzLDExICsyNzAyLDYgQEAgdmFsaWRhdGVfem9uZWQoDQo+
ICBfKCJEYXRhIGRldmljZXMgcmVxdWlyZXMgY29udmVudGlvbmFsIHpvbmVzLlxuIikpOw0KPiAg
CQkJCXVzYWdlKCk7DQo+ICAJCQl9DQo+IC0JCQlpZiAoenQtPmRhdGEuem9uZV9jYXBhY2l0eSAh
PSB6dC0+ZGF0YS56b25lX3NpemUpIHsNCj4gLQkJCQlmcHJpbnRmKHN0ZGVyciwNCj4gLV8oIlpv
bmUgY2FwYWNpdHkgZXF1YWwgdG8gWm9uZSBzaXplIHJlcXVpcmVkIGZvciBjb252ZW50aW9uYWwg
em9uZXMuXG4iKSk7DQo+IC0JCQkJdXNhZ2UoKTsNCj4gLQkJCX0NCj4gIA0KPiAgCQkJY2xpLT5z
Yl9mZWF0LnpvbmVkID0gdHJ1ZTsNCj4gIAkJCWNmZy0+cnRzdGFydCA9DQoNCg0KTG9va3MgZ29v
ZCwNCg0KUmV2aWV3ZWQtYnk6IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4N
Cg0K
