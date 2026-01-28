Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FF52E8B98
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602802; cv=fail; b=k4nD9OCPIt3nk+gwOneExH2RCcgoQnrWv67C5TIeT6Y8aVXKhHLbzC+2xNY4sqntvqOqUoSAgI3DFL0YrG8TyxAg5aKIVIjJLMaveeAklKTyqxUMAqLZ5jTtCd587hsSWRTWKP9nS6qDEZyX9HV8pEyeG8xd62EvlK2Zv7yDFLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602802; c=relaxed/simple;
	bh=EfLglJDhrzZdBipjEIkVVrLwjNStW5QOu2AB/Sgt8kY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fWrOK5FMfvSmWofIGaNiP1gftasQwHghm1VLD71Qkxw73lEh8EAc4HYHmrMg1M5YwwHweZUsbxxZENAPF9faETzY3g0GzpVRhOfTJPJ0RmtNKxOYeNa2gUNhAL8r+Mz8DarZd4TxTe4CRBIp+qSAh973CRv6aDfZCjx+MK5REVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ejl2Wgpt; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tunejXWK; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ejl2Wgpt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tunejXWK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769602799; x=1801138799;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EfLglJDhrzZdBipjEIkVVrLwjNStW5QOu2AB/Sgt8kY=;
  b=ejl2WgptHB/Uis9p9eCm1rYe9+J518EHe75vGhukZ27ScFOhYqp9EYxQ
   KOpiAR3gH6iYX4Ht9EvOOTRentNZ3rzg8pl5sw5buI/smsA/FAnOCtO31
   YdO598nE2MqZJVdqlEQbI9KjrHoOGwR3Hw8pL9WRgW1RHTYDz9BcdafaI
   7MVKjk/4kf0LqZX7/2q56jZI2FdxptwUOQYf+Lfr/nl9JpSjcP7bMFjQs
   NxM7m5TGXb5oZkmkxtqDCt7LofJV4ccJcBdyOnz+YQ4Wz6AEQLGq9XEb3
   jUBPyTKsjt8Iu+A8YF5/1dTfV87bPxRgGyv+eS7xBcRtlKNLHOXMZaVKb
   Q==;
X-CSE-ConnectionGUID: Oj+1h5xnQzywPCZYwCLNFg==
X-CSE-MsgGUID: Ob2axEmHQ0OJoNInDkYIsQ==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="140793611"
Received: from mail-northcentralusazon11012045.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:19:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L1S1UW7L0MiHzssHGquF4LvNBsOQN4093XPn0Zqt6TJTAGV+TcP28IUoH5bBwGuSedBFwWAMPzY/mPOWCJyre8uDqjDBuCnkf61MWKXq0hVbnhF54wVTtvraKVYovcZXdFH1jrLQmdx+UY+pufFh1cppjRvOfRz/GqlOmFfo1cQSU0ao7plavxBSR7PtcuC2mq2x+5k24Y65BpIwPcR99UjxefwbnFaU30OSltIVglmTbhwoepkzEJ3jaaaIL9pxCTExydg6acHAdnQLJh9G3fH61vFzE8PbfVkapi+LDMYuLWcP+nUsSCQn1L0tQbgKnHpx+pAv1fBSKHd1zFEclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfLglJDhrzZdBipjEIkVVrLwjNStW5QOu2AB/Sgt8kY=;
 b=qQREM27Ws/PKpRD/xlETxKeZRcSB+hqISfepJPCm/5U6TTnobWAMgt5cKE6Rtg6SE/xeEuBdxvJvKJKY9DmIZpT94DSLx+BuKDHFYNs85qCgmBhkmkdPxc1WOLi8BCDGXFuJPdRQVnmOPZRfSAaC+Fin+9GaLtVdaBTmq1sqsEr+D9MuS8eGj327Pp6Yc97bB4YnJSsRqt9N69QPz0A/PNwbCnBuSzpIxHcqNMF06RKaEBU216iQ49NzNDu0UgqsFSjjBnv7t6NT5eAlim5XRnSxTdYegYqhKCv4PRJrIXzuoRZOtsP3DXrZRGFNJkkw6+lSmLcJo8Tvp9HNm0t9nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfLglJDhrzZdBipjEIkVVrLwjNStW5QOu2AB/Sgt8kY=;
 b=tunejXWKr5LrVvOCBA8Rkl+IjA1A7SmS+RxvQjhPhkpf27HmKtVMiLSe/4QIKIRQaboZYyGVa/53DyAXjexzW+JxYs9RlO8gp+uDa957k5YX8b/P3FlZu0Kr828iOdvrFJuoAwoMKAMTdu45j+HRQtD32Q1AyYBMCi6A11dq2w0=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by PH0PR04MB7384.namprd04.prod.outlook.com (2603:10b6:510:1f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.3; Wed, 28 Jan
 2026 12:19:57 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:19:57 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 09/10] xfs: add zone reset error injection
Thread-Topic: [PATCH 09/10] xfs: add zone reset error injection
Thread-Index: AQHcj6cBqmFqgdor2EiokvIpHExyx7VngYUA
Date: Wed, 28 Jan 2026 12:19:57 +0000
Message-ID: <6a1d62fb-3547-4e45-a88b-0e4ea2940614@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-10-hch@lst.de>
In-Reply-To: <20260127160619.330250-10-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|PH0PR04MB7384:EE_
x-ms-office365-filtering-correlation-id: 5c92ddd9-a95d-41b4-8bac-08de5e678d4c
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MUFDM1JhSCtETW1PVDh0OWpWeVdLTDAyUjA3aGNsRkpKdXlac3JPUHR0OFEx?=
 =?utf-8?B?cDUyU3JrajdmUjd3L052cmxpdkxZMWtzNlBBeGF1bjc3T1VSU21hN09MSXdQ?=
 =?utf-8?B?MWVvWWxVOUZlVm0yajVmYUx6dyt5T2xUSit1R0hlUU91VDlPaHNmS3lnWThu?=
 =?utf-8?B?SUJ6N2tFaUwwSlVwb2swSWtDM1NCS1c0N0t1Yk56bDlYK1JCL05YbXIwZ0Zu?=
 =?utf-8?B?c1FETEJ1bTY1RmRVSWhqdG90dE5Idk91RDBUa0NTRG91ajgvK05aSThCS0Ji?=
 =?utf-8?B?NlNWVmJkMUxQVWZvYXVBYzRYR3pBSjFRNTNtMzJkUnEzdTRqbHNJdkZJaDEz?=
 =?utf-8?B?RTdXOXI3VHNzdGtkOVhsa1lVRHJHdS94aENUdnZpdzUwQVJTQ3lwVDRqeU1z?=
 =?utf-8?B?VmdhM2ZoYmFYTU83VkZZN0xHZUx2RzEwV1BPdGtoREJvcXhwUk5EUnB2b1RY?=
 =?utf-8?B?WFBzdmt4aUptL0ZlSEpJU1BSeitWeVRyMGlBUWlyWlZlUzZVSCtQVkZZSWZU?=
 =?utf-8?B?eDIvbzliRFRKYUcwSENncTJPeGtPOGorUFp1UXNWbGdBMG1QOUJIQUVoajlM?=
 =?utf-8?B?YmxNR1R6OFI5eUNaMzFVVHczZ2ZVZ0Vod3RyWFZrZ1o0RGl3VXJHTmY4TnF6?=
 =?utf-8?B?ZnQ2U2RCVmJGQnlOeU9hQXIzL3E5bi8xcjlQQTRBT3JxS2NJYzhvaVJmWHhT?=
 =?utf-8?B?MldnT2ZDdTFsUEIwa0lXSlR6azYwWWc0QUpZYmpJNm9mWG5mU1FFRFlRc2dH?=
 =?utf-8?B?MHJGd0JHdXlYRUlueWpEQ3owOHd2eVVKS3RlblYzbHNzcjdTQlVMaitkQ0w1?=
 =?utf-8?B?VjE5ZEk1Q3NLdDdnT1YxSXQvby9WRzIybks3OVdUczBzbFRZT044Tmo3V0dD?=
 =?utf-8?B?anN2VE51ZVRlQmJQWFZZZjVZQ04yY0J4aUZMNFZ4RlhNdkFJeTFRdGRJVDlJ?=
 =?utf-8?B?dDdxV2Z3dHAyZU95S21SYnZrMUx5WkQ0MGtib2pZRmdHa0hYSzl4WTIwTFpU?=
 =?utf-8?B?bG8yTytZS0tnWVlaWkZVVXBlU0Rsbm50UjhGa29KbjNtS1M2Vmt5Yk9MNkZs?=
 =?utf-8?B?dllkUTZQM05KTEI5S0JWTW9GU0tOQVNIMEN3NjZpQm9kVVllOCs4SmkrblRF?=
 =?utf-8?B?bCt0UlVUS0F2K2tGd3NNK0Z2WlZ1VzZUVVBaUTdJaEdFSDNYbUFLYlV5WFgz?=
 =?utf-8?B?b29yOHVSMmdWR3Fzb2lvQlNLcnE1Wk1pTy9pczhPdWJsVDFFUmdjOUFtV2o4?=
 =?utf-8?B?aTgwSzhmcFp3cmVTU1NqQU1jUW9HZlFxWlE5OTBhNitocTZXMEgvaWwxWlVK?=
 =?utf-8?B?TVFkcVNSemliRHAyNkF2SkdXTmxObm50Ky9ibldwWnlheUtUSlJKV3Zsb1pU?=
 =?utf-8?B?QWt3dGlSTmRKaHZKSjhMTUt4MVdsTnVmNHhSZjdVWEFCYzJjZlJoTFdnb3c3?=
 =?utf-8?B?bVlCT241THlCZ3Q5cmRzTkxOYjFvY1ZIY1B2SUdTSGVya3NCQTA5YkdZU2xW?=
 =?utf-8?B?QjNyclkzdFNuQkZKbXg0L2JiMWhUVmRuR0hxVWNEbEp3cFFQK2lKWnhGSG56?=
 =?utf-8?B?cWpHY3JuQmRRS3hxREt4L1E0eXY5T1BLa1E2ZjNaWEZOMnNlemNjRTFKMHhM?=
 =?utf-8?B?N0VQNWl5R0FwWEZzZ3RJbVZRM0o3UVZnMGg4U0hyT1lTSFpuV2hlUkd4dlNQ?=
 =?utf-8?B?T2hIY25ZWFpMaFBOVWJpQ3RDRTV4bytVQlFGN1hWd2xQRXFNaUp2M1p3d3Iy?=
 =?utf-8?B?elM5ME44NEVHWXhwTkw5c0ptRkZDWVpWRkc4Ti95TnVWeFNVb2wzeW56Rmdj?=
 =?utf-8?B?L1kyZ0h6NkxLSndBS21mUC9Ddng2bi9IVXlpNUhlQVRkOTZnMm0vMnVRdnVB?=
 =?utf-8?B?MVZRMUVubkZFZXBUdzBwRXhWYzQxbTJBSVJVQlUvNUVXdnA4NnFzSHFSRTBk?=
 =?utf-8?B?U1hyWFMrQnFQZlhicXB0MUlaQW9vYVdZNlcrdjBhbzVmYzlPWjhWQ3N6Mm8x?=
 =?utf-8?B?ejFYT1lqRndQUTJNeEtXUzAxZ3FFQVZodmM5ZXRUL1d6amFiRXdNUkpUM0Z4?=
 =?utf-8?B?RjA5MmI2UWwrUzk5a0FGQTVOcUcwa3RhODJnMFMzd1d5ZElJNGEycUUxME40?=
 =?utf-8?B?emtXSE1BdWNDSGh4VVpweU1jQWZndkEwaDhrK0V6YUkxanhMekFqcnBzcG5L?=
 =?utf-8?Q?lMLDpizmFgpAjR/IJngnG2I=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Ly9aaDE0KzlwMitwUE4zdS9IbERvQW9sbS8rWjZlSVJ6ZElQbnRCMk1GUVJr?=
 =?utf-8?B?bENWZXQ1TU9KTzJzMUFmM0x1dmtmcE9ONVVVOXBFNGxaQUY5ZkZGcTdqdCsy?=
 =?utf-8?B?aURaYzg4cmFwbDh2SFlQOUlqSnVjVTNES0lIK2xsb1Mzc0dLaThzNkVRdHBh?=
 =?utf-8?B?TVFjZ2tka1dFVDdZRkdQTDEwYTNIMUZ4Y0NYeHRHdmF6NHloakk2endNbW0w?=
 =?utf-8?B?ZEoyVS9LeUNOTEJZQjBhc2ZxelFkVXpDQUkyekQ0aFhFcVRLYzR2dGNRU0NO?=
 =?utf-8?B?b0ZaK3JvNzdVT0phWGFUdUpmT2xQQjJqalNxVjFKS2xVVVVxWXBLYllmZVJu?=
 =?utf-8?B?d3E1NHBOZTRKc0ViRVdVaVorbjhUT3VFQktyS3F5MHFNaGZmWWJ1U004QVQw?=
 =?utf-8?B?aXQwYWFrK3VlSUhMbjVoVjZMTHY3ckZXUWwxVjU2c2ZHOU1sSFdhVStJcHR6?=
 =?utf-8?B?QmZMWEM3ZXRhclM2Y3hpemdjU21tcjlFMHhGaUhPNmJoQUUxeGlWY1BMSXdx?=
 =?utf-8?B?YzNBNFUwUHJmSmhzbG0vUFVia1F3dnducWVVeUxRMGtaWUFXaVpsWTVtL0dC?=
 =?utf-8?B?bURnbEdmMmZpdFRPUElUeDVUbGJLMnFHOWg2RmtyTVJaOENUK3V5dkIxMzlS?=
 =?utf-8?B?VVVrZ0RlQzhYckhqc3ZtOXAvK2pLZm9qQWcvTjJYUG1MVmcrOTFHWC8wVzNM?=
 =?utf-8?B?YkJkazZSWU9vVjhSSllOcG44ckwyM1ZpNEpLaEVKVFowaHFWbDcyY2pldDl3?=
 =?utf-8?B?UEtYOXE3MmxzeHNiVjY4RFh6WFJvaEtRWTVGOUZQSTdjNEw3WGN3ekt6WHlQ?=
 =?utf-8?B?a0FISGVnNUc3UStFakRqUVJjd241ZGpka1NFWSthb28vQ0FZNXNTcis5dm5K?=
 =?utf-8?B?UXhTbUJsRldVaVpKZCt2Z2lOT3A1d29HZHZ0WWRKb1o5RGJMV2tDQWN1YUhT?=
 =?utf-8?B?aHB5Yk5ya3FFY2NNQzBZTTczZ2ZSRVN0eFkrZFJBME5CK2VWVlRBMUYvYmJ6?=
 =?utf-8?B?OVpSUTd0QW5iWTB2T1JDT0lBY0hVOUpwd01ZVUZkdGpkUklIaUVxYStpRUFO?=
 =?utf-8?B?Y2p0d29vMWp4OFFHZnBid24rNGlxMTNSMndkOWx6VU9jMkdya2Z5VjExRGRz?=
 =?utf-8?B?Qm80dVUxOGlkcVFXSng4ZjhOUkZsUWhnRlloK3NsUlplNFNLRlFQRmpQT2lU?=
 =?utf-8?B?M2RQSlcxcTRwZE1MWFJoT0gxRHdSOFZLZHc5ZFBRUFcxc3oxazBEbDhBaVhO?=
 =?utf-8?B?aU0wSDhha25HVGFIUnFvVGRJSXcyRmZHZHcyRkl1U2pKdmNPUU8xTTdWOHJP?=
 =?utf-8?B?cnRoNnVkN2FIMTJjOE54a1hUMEcvK1ppMkxYQncwUXo5dkdwM1dOa1ZCOWJB?=
 =?utf-8?B?V0NpT2s1TCs0REEyOURmalp1NjVxbXlGYUJhZjd4a1YyYVQ4SnpySVF0TDJm?=
 =?utf-8?B?a1gzbmVvd1BaczNZbFhSK1dpSnpXZ1E0QUtLa0g2RE1hVDBUNW1lVGQ5bWc0?=
 =?utf-8?B?L0s4bkorN2VxQXRYNUsxUUZ5eXlwWGRUS0cxSjJySzZRQ1E4V3VYMXM2bCt0?=
 =?utf-8?B?b3M4dzV0bGxNQnhVOUhlb0hZdlkrUU1LQ1RSTDJvbzhTTUhvZGozVnpQNUsy?=
 =?utf-8?B?ejdaYmVwVEFKYTV1S0swRDhEWnB4d3ZrMldiNHBvSCtiWTJIckpOYTFjMFBt?=
 =?utf-8?B?ZFlTLzNXQW42UUU4bXlicWFhNjZSamJVRzBJRU9HOGM2cGI1SW93dm9mMHdC?=
 =?utf-8?B?NVF6UEZ0cWhBeStETFM0UHBHWXd5Y3BKMDM4b3BETmM0d2FkVm5hUmdNdXNF?=
 =?utf-8?B?Tnpncld4OTZnZCtWYzVMQXJSM1AxL2cxSGU3cnZGRFRSL21BS1ZZcno2ZlNZ?=
 =?utf-8?B?WmpFWUVvTVByU0VIZ2lkY3BJVFFkdHBVTXVsb2RVQUdabGxaenowU2l3OEMx?=
 =?utf-8?B?ZXNzSFM4aWZla2c5RWxISC9yQlQ4SUtQaGdVdGxCZ2hGcGlLZkF1NjN4bUQr?=
 =?utf-8?B?NEhwREI2WHF1MkF1WGNrQ2w2ZFNYalV3cDQvdmtiZGNMRTlxaXFWVlR6YXc1?=
 =?utf-8?B?Ymx5WGRVYWZWQ0Uva2N4TWo4bjVDUnR6azRTeERSSEEwc2hHZkVwNlNnWnFP?=
 =?utf-8?B?UzBXQXovVTBMTmlFekt2c1dHWkdVZGZ4bTlVcTlCeEE2Y2tpTjExaG1Zelc3?=
 =?utf-8?B?eDZPUmJzdjk1eXFmRDJha0o4akNneTdQK2F5OWxhZ244YldwMVhEU1pqRk5i?=
 =?utf-8?B?ZEdjNDJUVUh1V2FEa1JLUW5tZWRlZVRzajBabmVYaExqZEZHWVF2eFdQQ3Vl?=
 =?utf-8?B?Z0dtMC9BYkJRdzFjaGJzaDM2UGtwdWw2MHB5dVJzZHIweURFRnBvbUpUcGs5?=
 =?utf-8?Q?jIwoxlwZIjx4faTU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58FF21220AB6A54D877CDF5FE19C9D33@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dLwNYnedFuLe+WBbdEBgLrbatJt0yrXfeP+MQatRMDlZ7sc08bHJy8tXpXxHh1owKa0uTAkYBo/cdpG2YHnf9/3gZ4oMX5D5Vl0svqozZ17ZsCq4LPsWHSVdN5cpHtwEZK2a+p6wO6NZUDWDkjKgpDjTCHK7Pl/dADr8xN6gutuadhvrO1IBP00mj664DBz6SvLrAPgG3bJLXwlTSmnUxHDbaK7dsvPY5+92YFmEwR4rUg4naSAqHS1XrVsUW8w3da3FzjzeQNyddscQxoPRLGL2J77CsfSDufZX+TkvpTxudFa0iYc4Ri0Kydac4hswGTd6kh0C/PL+w0SmJ+T6ZL4BoJUu3BSqFINuZHTq7m7VyQdb8FAcgC910xdbMkScRGWRd6P0FzlFIH623DqffsEqGF8sKaYpjRSJrbbVOjjBbcahFi9ioQGOF++FgB4/za/ZFTkY0WDS0G6mjo3qNVUlXPBCzwdSPlo4f/MuYEut7YHCZUe8r1GVaoXSSZjOZ12AmjN8sdm0DLxJrlCS86mvtMnQu0vcxlQ1SlhYsfgftZWH6cKZVj5pQ5VypGtM00iesnOzWNZF+ZDrt/PpqPiFxz8p9I3S4R6bYK0DmBi7lTSv1ZAtPz88g5Em3zE+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c92ddd9-a95d-41b4-8bac-08de5e678d4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:19:57.7449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g4kuP29XQ1KjTXHLBri6jTPVg4g5pkdl43sO2GmmLLJksXzRhr9M2SL3JVF1W2p+JIKF/DD1Hh5DkZIDkV365A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7384

T24gMjcvMDEvMjAyNiAxNzowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhIG5l
dyBlcnJvcnRhZyB0byB0ZXN0IHRoYXQgem9uZSByZXNldCBlcnJvcnMgYXJlIGhhbmRsZWQgY29y
cmVjdGx5Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3Qu
ZGU+DQo+IC0tLQ0KPiAgZnMveGZzL2xpYnhmcy94ZnNfZXJyb3J0YWcuaCB8ICA2ICsrKystLQ0K
PiAgZnMveGZzL3hmc196b25lX2djLmMgICAgICAgICB8IDEzICsrKysrKysrKysrLS0NCj4gIDIg
ZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9mcy94ZnMvbGlieGZzL3hmc19lcnJvcnRhZy5oIGIvZnMveGZzL2xpYnhmcy94
ZnNfZXJyb3J0YWcuaA0KPiBpbmRleCBiN2Q5ODQ3MTY4NGIuLjZkZTIwN2ZlZDJkOCAxMDA2NDQN
Cj4gLS0tIGEvZnMveGZzL2xpYnhmcy94ZnNfZXJyb3J0YWcuaA0KPiArKysgYi9mcy94ZnMvbGli
eGZzL3hmc19lcnJvcnRhZy5oDQo+IEBAIC03NCw3ICs3NCw4IEBADQo+ICAjZGVmaW5lIFhGU19F
UlJUQUdfRVhDSE1BUFNfRklOSVNIX09ORQkJCTQ0DQo+ICAjZGVmaW5lIFhGU19FUlJUQUdfTUVU
QUZJTEVfUkVTVl9DUklUSUNBTAkJNDUNCj4gICNkZWZpbmUgWEZTX0VSUlRBR19GT1JDRV9aRVJP
X1JBTkdFCQkJNDYNCj4gLSNkZWZpbmUgWEZTX0VSUlRBR19NQVgJCQkJCTQ3DQo+ICsjZGVmaW5l
IFhGU19FUlJUQUdfWk9ORV9SRVNFVAkJCQk0Nw0KPiArI2RlZmluZSBYRlNfRVJSVEFHX01BWAkJ
CQkJNDgNCj4gIA0KPiAgLyoNCj4gICAqIFJhbmRvbSBmYWN0b3JzIGZvciBhYm92ZSB0YWdzLCAx
IG1lYW5zIGFsd2F5cywgMiBtZWFucyAxLzIgdGltZSwgZXRjLg0KPiBAQCAtMTM1LDcgKzEzNiw4
IEBAIFhGU19FUlJUQUcoV0JfREVMQVlfTVMsCQl3Yl9kZWxheV9tcywJCTMwMDApIFwNCj4gIFhG
U19FUlJUQUcoV1JJVEVfREVMQVlfTVMsCXdyaXRlX2RlbGF5X21zLAkJMzAwMCkgXA0KPiAgWEZT
X0VSUlRBRyhFWENITUFQU19GSU5JU0hfT05FLAlleGNobWFwc19maW5pc2hfb25lLAkxKSBcDQo+
ICBYRlNfRVJSVEFHKE1FVEFGSUxFX1JFU1ZfQ1JJVElDQUwsIG1ldGFmaWxlX3Jlc3ZfY3JpdCwJ
NCkgXA0KPiAtWEZTX0VSUlRBRyhGT1JDRV9aRVJPX1JBTkdFLAlmb3JjZV96ZXJvX3JhbmdlLAk0
KQ0KPiArWEZTX0VSUlRBRyhGT1JDRV9aRVJPX1JBTkdFLAlmb3JjZV96ZXJvX3JhbmdlLAk0KSBc
DQo+ICtYRlNfRVJSVEFHKFpPTkVfUkVTRVQsCQl6b25lX3Jlc2V0LAkJMSkNCj4gICNlbmRpZiAv
KiBYRlNfRVJSVEFHICovDQo+ICANCj4gICNlbmRpZiAvKiBfX1hGU19FUlJPUlRBR19IXyAqLw0K
PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2djLmMgYi9mcy94ZnMveGZzX3pvbmVfZ2Mu
Yw0KPiBpbmRleCA0MDIzNDQ4ZTg1ZDEuLjU3MDEwMjE4NDkwNCAxMDA2NDQNCj4gLS0tIGEvZnMv
eGZzL3hmc196b25lX2djLmMNCj4gKysrIGIvZnMveGZzL3hmc196b25lX2djLmMNCj4gQEAgLTE2
LDYgKzE2LDggQEANCj4gICNpbmNsdWRlICJ4ZnNfcm1hcC5oIg0KPiAgI2luY2x1ZGUgInhmc19y
dGJpdG1hcC5oIg0KPiAgI2luY2x1ZGUgInhmc19ydHJtYXBfYnRyZWUuaCINCj4gKyNpbmNsdWRl
ICJ4ZnNfZXJyb3J0YWcuaCINCj4gKyNpbmNsdWRlICJ4ZnNfZXJyb3IuaCINCj4gICNpbmNsdWRl
ICJ4ZnNfem9uZV9hbGxvYy5oIg0KPiAgI2luY2x1ZGUgInhmc196b25lX3ByaXYuaCINCj4gICNp
bmNsdWRlICJ4ZnNfem9uZXMuaCINCj4gQEAgLTg5OCw5ICs5MDAsMTcgQEAgeGZzX3N1Ym1pdF96
b25lX3Jlc2V0X2JpbygNCj4gIAlzdHJ1Y3QgeGZzX3J0Z3JvdXAJKnJ0ZywNCj4gIAlzdHJ1Y3Qg
YmlvCQkqYmlvKQ0KPiAgew0KPiArCXN0cnVjdCB4ZnNfbW91bnQJKm1wID0gcnRnX21vdW50KHJ0
Zyk7DQo+ICsNCj4gIAl0cmFjZV94ZnNfem9uZV9yZXNldChydGcpOw0KPiAgDQo+ICAJQVNTRVJU
KHJ0Z19ybWFwKHJ0ZyktPmlfdXNlZF9ibG9ja3MgPT0gMCk7DQo+ICsNCj4gKwlpZiAoWEZTX1RF
U1RfRVJST1IobXAsIFhGU19FUlJUQUdfWk9ORV9SRVNFVCkpIHsNCj4gKwkJYmlvX2lvX2Vycm9y
KGJpbyk7DQo+ICsJCXJldHVybjsNCj4gKwl9DQo+ICsNCj4gIAliaW8tPmJpX2l0ZXIuYmlfc2Vj
dG9yID0geGZzX2dibm9fdG9fZGFkZHIoJnJ0Zy0+cnRnX2dyb3VwLCAwKTsNCj4gIAlpZiAoIWJk
ZXZfem9uZV9pc19zZXEoYmlvLT5iaV9iZGV2LCBiaW8tPmJpX2l0ZXIuYmlfc2VjdG9yKSkgew0K
PiAgCQkvKg0KPiBAQCAtOTEzLDggKzkyMyw3IEBAIHhmc19zdWJtaXRfem9uZV9yZXNldF9iaW8o
DQo+ICAJCX0NCj4gIAkJYmlvLT5iaV9vcGYgJj0gflJFUV9PUF9aT05FX1JFU0VUOw0KPiAgCQli
aW8tPmJpX29wZiB8PSBSRVFfT1BfRElTQ0FSRDsNCj4gLQkJYmlvLT5iaV9pdGVyLmJpX3NpemUg
PQ0KPiAtCQkJWEZTX0ZTQl9UT19CKHJ0Z19tb3VudChydGcpLCBydGdfYmxvY2tzKHJ0ZykpOw0K
PiArCQliaW8tPmJpX2l0ZXIuYmlfc2l6ZSA9IFhGU19GU0JfVE9fQihtcCwgcnRnX2Jsb2Nrcyhy
dGcpKTsNCj4gIAl9DQo+ICANCj4gIAlzdWJtaXRfYmlvKGJpbyk7DQoNCkxvb2tzIGdvb2QsDQoN
ClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQoNCg==
