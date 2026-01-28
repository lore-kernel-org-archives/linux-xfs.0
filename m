Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2E570814
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602531; cv=fail; b=hOGv5lSz4KE9WZCy9zlCJHvyN0Idf2Kc+XKq2CMixtEfppDffqI69Ooufsoq2ITeT509VdYBmobIng+2FGO8voMb6yV+wtuC6o33dw28QSfY91W6AfEqMQ96NW38ZMj66ZDpoZnn1bLt4Gl24h6RFmvaz4Vb9p6LjzsoPB6ay9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602531; c=relaxed/simple;
	bh=pdOIM5KQwsAc/0ioo8AvhIb6cleUJaq+6mITyxAbtmM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aL23iLe+KLYxv/RI46d4emK9GOstFYI76EAI5fhTU7UIqamee9BJyUTfIb8rNhfleqgQrn1PobDlr8LlFDHfuDqcfdb9Q0m1vxi5G13DEau1t3HiTtR9IIZr8oloTN40+7c4xQqNB8llT9+Hr4cQ57driHmWfzhdzOhnYx4HLB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=h8cYzKj1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Vx1pK6tT; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="h8cYzKj1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Vx1pK6tT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769602528; x=1801138528;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pdOIM5KQwsAc/0ioo8AvhIb6cleUJaq+6mITyxAbtmM=;
  b=h8cYzKj18BO3pLjqSoS9ZeBSpriQHPJXQ2Awi6l+fWH8wWgoI5t2K7Z7
   rmeTOe7QlMGDSpFzAvFJOnnnFIXkBjT7YyCqp6fVw2GE8y0wxPlObnQQm
   +JF6iCUs4xnvYdlssvt2/ITM5AVyqS4h+Ox7e9l9K5SkPTXimNT2UssQt
   v3CmjNKbVQOtsreraQXe/a1FLROYyLWj/qTicyJ917gpOcHqs3zui1d0A
   rkgvJu3RFr7AC84tF2UoTo8eIoUzWHcaWB5xzErqeGJP2r2vI8s01AI3F
   OgSmamna3+OsWwH09dTf+PFME/x0g+Jx6TRq7dUj9TdaAkyskI7lgU451
   w==;
X-CSE-ConnectionGUID: 7AWyWYjnS6yWrA+HPM7b8g==
X-CSE-MsgGUID: l9JyhLcQSKikWqGVXPa91g==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="140793377"
Received: from mail-westcentralusazon11010052.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.52])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:15:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q998/oB+hQcNxUBPliVXIjbRZWh9T7oa7w6DlFB35qr9U0gYi9AyuR7fYDo3j6ryotwbnY+a1uTPlmBVV83d/0B/KQEV8DzCQKgU7O6DUT0IciUVTh4ob1JCGj5udAjHmksCZaMMtKrHzMl4fvjXPHoKk9Lh1gNLkZZoT65iINBOmKuH68FUdEcUv23zZUTSlN4JloVP+yDmBVzo/oBncQUHYamv9DQ13b9xI3DCWSyVdcfixN23CligJalZbJYjKX9l/ZdCarulGvzKYFWV5qW53RUBX3tplPh3rcYGE/LKbpDP6ElXBoZTRr9ZvlRsup2T8spC/sRo1TPpfNMTxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdOIM5KQwsAc/0ioo8AvhIb6cleUJaq+6mITyxAbtmM=;
 b=q9JGMdbUd9Hw5Bso9tQsRENtkYoSniw3O97vQkfzN5cpaAJKd5qXXrPekbOqcqoPCLoqQct8odlIjuev9PeMLsjl+1RsPIIVw7SzLCyHuIlel35sQAmFZZ1xdB4udF+IAJjIYUpGTeXg3+LWiQOokdg6xV4xgcxzhnrrA2VLZRQQjqvn+GzMP8JAKo39HXld8MZHQt9ks4FU/3FhGsxGxMADh1T1pJ0GsKF7D/SQIpGEUejEGfGMoWaOwS0RnAqxAHVmLaKUHpv9tArL0M8v6L8Y5Oq1rjP+V0uyV/dTaaDCctTnJiyHBy+ThnQWdLoNMoGXJD8KGy5TRhIEHXFUcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdOIM5KQwsAc/0ioo8AvhIb6cleUJaq+6mITyxAbtmM=;
 b=Vx1pK6tTBuFG5BydMOmEyvniJUjsjqT5o2unTMz9cjbYZ4cL8UIRFKY5I4t9Cv8WKYrXDxUphR8Xvz4Z5wI1qcvARu6p9tL3/R5/5iJV5uDrp/uiyrtDf2BxLYTs6GZnfuYtMnvTHVnODcejlP9GcsSYFvuztIomXs5uwjxuDyk=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH4PR04MB9386.namprd04.prod.outlook.com (2603:10b6:610:23e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.6; Wed, 28 Jan
 2026 12:15:26 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:15:26 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 06/10] xfs: allow setting errortags at mount time
Thread-Topic: [PATCH 06/10] xfs: allow setting errortags at mount time
Thread-Index: AQHcj6b6owrKhS8OUEWdDBQe6Ffpc7VngEMA
Date: Wed, 28 Jan 2026 12:15:26 +0000
Message-ID: <490ee062-3c66-4a68-a381-40d938513542@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-7-hch@lst.de>
In-Reply-To: <20260127160619.330250-7-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH4PR04MB9386:EE_
x-ms-office365-filtering-correlation-id: 895439dc-b36d-48ee-5fc1-08de5e66eba1
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?KzlmWDZkVnJsTnJNTEZldVdzZzJtZmRpZEtkNGxKNnlHVWR3TnJmQmVrVUY2?=
 =?utf-8?B?MWpFa2dkRmdISStabzdOcG4wdG9SN0o1VUE3RGZmV3N4bWIyaDFQVU1HOUZF?=
 =?utf-8?B?bDdzR3BwUUIvTERSTjE4THJtVlo1V2FSSVA2U3c0eG9JVjZ3azRmVDN4bSty?=
 =?utf-8?B?em1acGdndndwbDd1V3NwYkg5QWRtT1VrNlhkRmZ1UEwxbm9oem9HS1hWNWRP?=
 =?utf-8?B?SG10anBMZjYyU2Q3eTRNeCszM2dlT2xsdlVmVHNoYXZmTzU2bitBaFp0MkFZ?=
 =?utf-8?B?eTQ4K1Ywa0l2TGMzeDhSQlg5L0JyZTl2WmU3T29ia2RxeFRYZ1JqNHlDT3lQ?=
 =?utf-8?B?UlhVdXJ2anZJeDVQbVd4NjN0bU5nSlQ1NTkzTW1UTWhzOXlsa0tIMVZBaXVR?=
 =?utf-8?B?Z29zdmNwdXRLT3ZSdU9FNEdMNEQ1K3RvUkFtdUkrTDNPYit4L3V0OXBKMFJP?=
 =?utf-8?B?RlJtbzVqdG5XVUlIN3BIN1pmakhrSGpleGtxaGo3NWlnWnluOVlRV1RxTTRk?=
 =?utf-8?B?c0YzMDNDY05KeWNya29FRE1mY0pqY3hrN3o3MHJ6OXVWbHFYbXp4dzdiRUtz?=
 =?utf-8?B?Tzh6OEt6YXFHdkMrUW02cHd5UWhjeUg1cjJLZ2hyQ2puUXlGRVVsMlovNVIy?=
 =?utf-8?B?dUplMEFSTWFpcE10ZFVpRHFpZHNoRG5qTW1OeExGclNXVEJZNy9YbTM3Vldu?=
 =?utf-8?B?N3hyYlhOcDZkcTNKeW5NLytaZEl1dmJoYmNSMFM3ZFp3MVJpcUJGOHN5VVVP?=
 =?utf-8?B?TmxsR3F0RVVDd2xxOVYrbjcwV2h4b0VhZUJGdEZabWMzQ2k4R1J0MFpPYXlw?=
 =?utf-8?B?SDE4U3lsdEV3VmZObG1DengxU1RsUEJVaU5Da0JRU1VZKzdnU215NlBFVDlH?=
 =?utf-8?B?U1hIWmZWTUU5OTVVT2tvMkVrSHlvaWdQSDk2S2tWcWFvM2dvekVQaGNvNVdk?=
 =?utf-8?B?L21HV0lvRVdSdnM2dmVDcHBHaHlCTkYvQ25QamhwVUVTNVpBWk5BRlU2NENy?=
 =?utf-8?B?U0lzOHNlM3NMUkloRjhHbnNRampCQklwY3FKSlJyc3pLWGRTMTJiMTZQTnhQ?=
 =?utf-8?B?UmVHODMyVmcvSVZLR01aWnp1MmIrTXJCakI3STVSd2FMcDlrQjN1TmJZUnF0?=
 =?utf-8?B?bmVKb3RiZGdkRkQ5YW9EbE9jQmI0ZUpvSnZ5cmlyVUlIZWV0SThJdUVST2lm?=
 =?utf-8?B?UTlkbC9qWUgxWmlpSU9rUG1ydXFTTEtlNjN6RFpuU3BRODU2Q3kzU1hiR294?=
 =?utf-8?B?L1J4QlFIenJtZ1pwaDBSSnJ4bldOMDU2TmNTVWhhRGROSXJUSm14aGh2M2NX?=
 =?utf-8?B?RSsxUnNEc0NrdWVpVklGRGxZUzZBM3QxbjNDTlh3cUlYTHdhSUdaaDRpWEll?=
 =?utf-8?B?b3lOQVR2N2V0MjVWZ0haY1hJUzhETTErbDJMRVpEVGZCNFBkeEZBc1oyTFZl?=
 =?utf-8?B?eHFmK2NLZ29QakZ1UXB1aDdrb09XQ3I3RFZxZlZSQ1ZNMTJaSmhnRW43WlRs?=
 =?utf-8?B?L2tpaTBLVW15ZTJyQ3ZQaGs5MUJwaFA5Zng4UkRRLzN2S1N5Rm1JVXNDTkxx?=
 =?utf-8?B?NGh1MGp0bjJEazR4ekZaRkJnaXVGY3JxM25laE9IdlJBVjd2RGVGN09JbnNB?=
 =?utf-8?B?bkRsZDRYK0dZayttanBDaGZsTGJVQUcrdDJOWEUvODZ5QTU4TUUyWXYwS2ph?=
 =?utf-8?B?cHhuQ3EvRXdmL0VaK1Zqa0J1L1E0UjRuQjc1RkZmQnlLSkkwUDk0QzFtY09h?=
 =?utf-8?B?dENLOUZWTGlOWHBSaDFPcXA3Z2wwUnNuSnhMbisrRFBHaFdqQ0wrTVV3aS9t?=
 =?utf-8?B?RmxDRFBxSjRrTVNYSU16VytZRzB1Sk5jL3JOcjlOcHhtSVU2eEp4L0VGZzdX?=
 =?utf-8?B?bTd3V1JPdmJxSVZDS1h1NXpMd0k2VmNybG9Pa3k1SzBDUXNmTDcvK3ZQbmZq?=
 =?utf-8?B?R1EvYjNoTEtlbEkwdEo4alQ3ZXlOOVB3NzRsbk1TWlhtZ0FHK29MTFFReFJJ?=
 =?utf-8?B?Y1hYTE0vTnhqaHFRZ003ODRON2oyczRITU0wTE5yRElzTmdYWG5VM2RiYmpG?=
 =?utf-8?B?eW5TaC9hd3BuNTBCWEhvZEd5MW00TU93cVJKSExBQTlTUEFhb0M0SUU3bVNp?=
 =?utf-8?B?cndLL3dSbXJQbWZ1TU9yQ3VjS2ZhTmRhbGhNSXpEekxHMHUyU2o3VDJXeElv?=
 =?utf-8?Q?REtYlkUfI9LMOAYVCDi+gV8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZWI5UGpHYnQ4R25QR3NUZzB5eGFZeU1wT0grRXdsMk04TjBNaXRLa2xQbmtj?=
 =?utf-8?B?c0tBRUNKVWtUbUhQVjg2ME1zQndKOU03NVZEZWhxbVhxeFoxNjJNcTBzMmJz?=
 =?utf-8?B?YkwzZGVUUUYwVU1qRzJlajlqZnFnamNGOHlhK21XblVpT0xjbDZrTVE1WHVh?=
 =?utf-8?B?LzJReC8xUlg1a1N5dWtPOVFrVFVPcTlLQjJrY2k0enpMMjdqTEh1Q3h2eHpY?=
 =?utf-8?B?TkpnbWRZbUVYS1huSHQ1eWV6STZMT1Y4U24vSkJXYklrTm40WTJPbUphbGJa?=
 =?utf-8?B?Qi9RQWFjZ20vRkFhZDgyWEJJNlpSYnY3STg0ZDhtOFhWYUdlcDk0dVZHMTY4?=
 =?utf-8?B?OWFkODdHSXJ3Ulk1M0wvVXJBb1JaMGtEVWI2RGVONzNZYVFqOEpQejRzNGxv?=
 =?utf-8?B?OHZTQkVYaTM0elk4ek1JZSt4RlNwOE03b1oxY3lyajA4b29QQ0pwbWlSK2s2?=
 =?utf-8?B?M0c1Z3VHMDZLdFZxZmFYV0ZjZ21FRWxpOGtUNFVFM0NBZ3pOQ2EwZ3E0emp6?=
 =?utf-8?B?cW5wWUVMWG0reUE3dVBUL0pjSnk5YXJXNzFua2RFVHh5MlJoRDFGVWREYUZN?=
 =?utf-8?B?bjUwVy8wMXNtdVpCa25VOUptTWRrVGM4ZUtxTzhaN1lLaFZuSkhCZS9BenBq?=
 =?utf-8?B?djBBditFb2tKSlJwa1VaZFJQenRmOU9aTmFIOUFERkgxZWJlZEwxc2FrRy8y?=
 =?utf-8?B?OUpBTkVPd2RrNDQ3V2Fxb2Y0UGdWc2diaFRaenNpeERaaVQ0MFE0NTM0eEEy?=
 =?utf-8?B?Y3BQZXhFYk1nZ0EySUxnK1R6OVM3UThXRXVHTnVEZjk1VFVqKzhtYjRWaWJM?=
 =?utf-8?B?aEg3Z1ZyY1haN3R4elhzNWFNcEh4ZUNKZGZETHJ1MXZrSzlXV0UzRlBTQ3hn?=
 =?utf-8?B?NFZKdUdyckpnaGRXYjlzaTBWU2JYVXczSGw2cVlib245bjZ5TTlWbDNGT0k3?=
 =?utf-8?B?emV5cXRRY21vbXk3aEtVdmVCcmZzVk1CSTNJUkFXTjNKQlZPb3I3T3FMb0tp?=
 =?utf-8?B?UXE3S211ZVg2ZU9vUlhxTXdoQzBVMEE1TW02d0Q5SmluM05KOFBIcWZCRlJp?=
 =?utf-8?B?ek5HV3ZsRWQwRzkyV0FYdTdJc3dHbFJLWEQ0ckRYZnY5b1NqOHBHbDYwVU03?=
 =?utf-8?B?UnI4Q2NMckh0dFkyRHNiUER4bHEySktVd0d6Mk9NUVB4UU1Fa01lNnJoVWs2?=
 =?utf-8?B?eVR1WnB1NWI5eVNyS0lSU01yQTM1L3hoaWhZRHVLK240eEZxem5oZEpTU2ps?=
 =?utf-8?B?WTlkcWszYjJhT0FQR3B6Zm5IeWRLbFdGdHdCTlRBTzFsMHd0YkFITFRHRzFW?=
 =?utf-8?B?dDdaWklodlM4UVRvZkFmYmI2RjZaTmlzQnZieWlPY2Q4b1BXS2EzMTArRHl4?=
 =?utf-8?B?VW1aUjdUdXVKWnZrN3pTbEtoK3JnOVcybmhlTjFmV0F6dDRIaVUxR3pHZkV0?=
 =?utf-8?B?QW95VXNQc2tMaGl4NXI5ZmhYRlJyc0NyWjhCZmJ2UmFpekdtY3lZa1V5T21G?=
 =?utf-8?B?ZGRsSFZoeER3dmtpODBEaDFNS3lENUQybDRJcW41bmhON29JZFcyRjhnZ2Va?=
 =?utf-8?B?elpnQUVTcktjcWFHQW1jZkcrQlczcnZ0RXZGNzFzcVQyT0VKSlFsSUVDYlhv?=
 =?utf-8?B?RkRxNFZyNXF0TFRqS25vRU5TelhuaUZhK0xYYWlQQVBkQTROUXd1QTRPUGdJ?=
 =?utf-8?B?WFN5cHhVeXZTVzR6elhRK0ZTR1lIQ2xEa0RtdGVUSnpId0g1dnJpUnhrM2Mw?=
 =?utf-8?B?NE1mN3VIc0tRMVdvcmhUUkEvM0t2bk8vZGlEUzlDUUE3QS9XcVFOT2dmWUVo?=
 =?utf-8?B?eXo3bjBWbHREQ0dBczhGN3lJRUZlVDNMSmlpZXR6a2Z1a0txVXN3Z1ZjK3o1?=
 =?utf-8?B?VnE1b1RaTHMrWnFHMUtyN2s4VUtodEo1NVRlK05qMDNaU09UZllCUWRqb0Rr?=
 =?utf-8?B?b3ZJZEFQTDluTGttNnl0SHE5a2dPTzlwN3pNOTZmWThwUUVGaXBTS3QyTlB5?=
 =?utf-8?B?d1FYczZVZGtHS1hucFloclROVWxzUXVXVURaV216UlZycG8welpVZVRQYm9y?=
 =?utf-8?B?RXpwNnlFd0VReVFjcUlaMVRYcTNGTEY4VGpUZXBnTmJCNFY3L0pHeUdSb2lx?=
 =?utf-8?B?VnlDL3lkSDR1ZnBodWgrZVp4cy9tUkxvLzRiVDlQVHJHTVpyWTFDbjU5cWFs?=
 =?utf-8?B?QzVwak9uVDN6ZjFPOU10ZVdkSm1XRWlOYkxTY2YyMzZIN205N1RhN2tJTEVM?=
 =?utf-8?B?RWlkZzByN2ppd3NWK2N1L0prOHEvbUQ2VU84ckZRQ09YVjhKUzhGOEp0TjJx?=
 =?utf-8?B?NXZMdTN6eGlwaDhadU4wbDJMdTRlek1ZNEpnMWpnc3lDVUlja202TTJmUjl4?=
 =?utf-8?Q?B+DSW1ox62bvP5PY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76250570E776274AAA343AA9DB81B9D1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fIC7ZEfZR3W2VTuBCtsBG7i1pfut3DizecxmuHG74MgNqI1JLJ9f3MIwWDrcecXrkpHD0U9ipBCm5eXw2yHPQmiszeB6/zTff/0tdsiBkwqLAv/+JCq3rcaa+gGnJllSIYiQjeovACzzmHP9QN0CcoAUfZPzAyAn1q2aUc+OrE69jZ5FmRas8mlAfgxud2rkzFITgAv7ZOd0C9JGuhY+6AIdCkyl3Bzucj184O5EEaytGO10XzFXmnK2aZLPxatbptEV1YLEF827xTuda4PTm2wLQ0povS72VQIy94XurAKkpwjMXuGFkA1GTlEu3JccEaxXOFdnz+5c4n4rdTb3MgJMFweMkdQQ38+Fa1GYMQ17zn0bmv4rxbQEgPUzI0lc9BrfX+Yy7z36IRMdaUF4npyxs3mybk9iLMCjRECIwRlP1EEuCAAIb7s+I/nyE1GBePb7CnmHH83lBVO24GQ9SqMOdcjxULqKjE0vNuQ6QVNiveXk+ovhaDsOEsr4L2x16+csQ1z+Gww+UlvZBTiW8su2+bTIUVCx6mqd1W6XmiuBftWc2kiQbgp8rPdo0pnbxgez4ooaBtooQsgZ5Z3BMayB+FkYomNllCY3iJNmQfD4WvqGwozZBy3JrkRtKFaa
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895439dc-b36d-48ee-5fc1-08de5e66eba1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:15:26.5525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PomDRU5Y9R0IjWiGMKIPiYqLhLqXOE38M9AlF7BMUU8NAW1vZDP7jrp6g8+YF+zEqsJQ0fXCmbIT3XuhS1IQaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9386

T24gMjcvMDEvMjAyNiAxNzowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhbiBl
cnJvcnRhZyBtb3VudCBvcHRpb24gdGhhdCBlbmFibGVzIGFuIGVycm9ydGFnIHdpdGggdGhlIGRl
ZmF1bHQNCj4gaW5qZWN0aW9uIGZyZXF1ZW5jeS4gIFRoaXMgYWxsb3dzIGluamVjdGluZyBlcnJv
cnMgaW50byB0aGUgbW91bnQNCj4gcHJvY2VzcyBpbnN0ZWFkIG9mIGp1c3Qgb24gbGl2ZSBmaWxl
IHN5c3RlbXMsIGFuZCB0aHVzIHRlc3QgbW91bnQNCj4gZXJyb3IgaGFuZGxpbmcuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBE
b2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL3hmcy5yc3QgfCAgNiArKysrKysNCj4gIGZzL3hmcy94
ZnNfZXJyb3IuYyAgICAgICAgICAgICAgICB8IDM2ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCj4gIGZzL3hmcy94ZnNfZXJyb3IuaCAgICAgICAgICAgICAgICB8ICA0ICsrKysNCj4g
IGZzL3hmcy94ZnNfc3VwZXIuYyAgICAgICAgICAgICAgICB8ICA4ICsrKysrKy0NCj4gIDQgZmls
ZXMgY2hhbmdlZCwgNTMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUveGZzLnJzdCBiL0RvY3VtZW50YXRpb24v
YWRtaW4tZ3VpZGUveGZzLnJzdA0KPiBpbmRleCBjODVjZDMyN2FmMjguLmNiOGNkMTI2NjBkNyAx
MDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS94ZnMucnN0DQo+ICsrKyBi
L0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUveGZzLnJzdA0KPiBAQCAtMjE1LDYgKzIxNSwxMiBA
QCBXaGVuIG1vdW50aW5nIGFuIFhGUyBmaWxlc3lzdGVtLCB0aGUgZm9sbG93aW5nIG9wdGlvbnMg
YXJlIGFjY2VwdGVkLg0KPiAgCWluY29uc2lzdGVudCBuYW1lc3BhY2UgcHJlc2VudGF0aW9uIGR1
cmluZyBvciBhZnRlciBhDQo+ICAJZmFpbG92ZXIgZXZlbnQuDQo+ICANCj4gKyAgZXJyb3J0YWc9
dGFnbmFtZQ0KPiArCVdoZW4gc3BlY2lmaWVkLCBlbmFibGVzIHRoZSBlcnJvciBpbmplY3QgdGFn
IG5hbWVkICJ0YWduYW1lIiB3aXRoIHRoZQ0KPiArCWRlZmF1bHQgZnJlcXVlbmN5LiAgQ2FuIGJl
IHNwZWNpZmllZCBtdWx0aXBsZSB0aW1lcyB0byBlbmFibGUgbXVsdGlwbGUNCj4gKwllcnJvcnRh
Z3MuICBTcGVjaWZ5aW5nIHRoaXMgb3B0aW9uIG9uIHJlbW91bnQgd2lsbCByZXNldCB0aGUgZXJy
b3IgdGFnDQo+ICsJdG8gdGhlIGRlZmF1bHQgdmFsdWUgaWYgaXQgd2FzIHNldCB0byBhbnkgb3Ro
ZXIgdmFsdWUgYmVmb3JlLg0KPiArDQo+ICBEZXByZWNhdGlvbiBvZiBWNCBGb3JtYXQNCj4gID09
PT09PT09PT09PT09PT09PT09PT09PQ0KPiAgDQo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2Vy
cm9yLmMgYi9mcy94ZnMveGZzX2Vycm9yLmMNCj4gaW5kZXggNTM3MDRmMWVkNzkxLi5kNjUyMjQw
YTFkY2EgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfZXJyb3IuYw0KPiArKysgYi9mcy94ZnMv
eGZzX2Vycm9yLmMNCj4gQEAgLTIyLDYgKzIyLDEyIEBADQo+ICBzdGF0aWMgY29uc3QgdW5zaWdu
ZWQgaW50IHhmc19lcnJvcnRhZ19yYW5kb21fZGVmYXVsdFtdID0geyBYRlNfRVJSVEFHUyB9Ow0K
PiAgI3VuZGVmIFhGU19FUlJUQUcNCj4gIA0KPiArI2RlZmluZSBYRlNfRVJSVEFHKF90YWcsIF9u
YW1lLCBfZGVmYXVsdCkgXA0KPiArICAgICAgICBbWEZTX0VSUlRBR18jI190YWddCT0gIF9fc3Ry
aW5naWZ5KF9uYW1lKSwNCj4gKyNpbmNsdWRlICJ4ZnNfZXJyb3J0YWcuaCINCj4gK3N0YXRpYyBj
b25zdCBjaGFyICp4ZnNfZXJyb3J0YWdfbmFtZXNbXSA9IHsgWEZTX0VSUlRBR1MgfTsNCj4gKyN1
bmRlZiBYRlNfRVJSVEFHDQo+ICsNCj4gIHN0cnVjdCB4ZnNfZXJyb3J0YWdfYXR0ciB7DQo+ICAJ
c3RydWN0IGF0dHJpYnV0ZQlhdHRyOw0KPiAgCXVuc2lnbmVkIGludAkJdGFnOw0KPiBAQCAtMTg5
LDYgKzE5NSwzNiBAQCB4ZnNfZXJyb3J0YWdfYWRkKA0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAg
DQo+ICtpbnQNCj4gK3hmc19lcnJvcnRhZ19hZGRfbmFtZSgNCj4gKwlzdHJ1Y3QgeGZzX21vdW50
CSptcCwNCj4gKwljb25zdCBjaGFyCQkqdGFnX25hbWUpDQo+ICt7DQo+ICsJdW5zaWduZWQgaW50
CQlpOw0KPiArDQo+ICsJZm9yIChpID0gMDsgaSA8IFhGU19FUlJUQUdfTUFYOyBpKyspIHsNCj4g
KwkJaWYgKHhmc19lcnJvcnRhZ19uYW1lc1tpXSAmJg0KPiArCQkgICAgIXN0cmNtcCh4ZnNfZXJy
b3J0YWdfbmFtZXNbaV0sIHRhZ19uYW1lKSkNCj4gKwkJCXJldHVybiB4ZnNfZXJyb3J0YWdfYWRk
KG1wLCBpKTsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gLUVJTlZBTDsNCj4gK30NCj4gKw0KPiAr
dm9pZA0KPiAreGZzX2Vycm9ydGFnX2NvcHkoDQo+ICsJc3RydWN0IHhmc19tb3VudAkqZHN0X21w
LA0KPiArCXN0cnVjdCB4ZnNfbW91bnQJKnNyY19tcCkNCj4gK3sNCj4gKwl1bnNpZ25lZCBpbnQJ
CXZhbCwgaTsNCj4gKw0KPiArCWZvciAoaSA9IDA7IGkgPCBYRlNfRVJSVEFHX01BWDsgaSsrKSB7
DQo+ICsJCXZhbCA9IFJFQURfT05DRShzcmNfbXAtPm1fZXJyb3J0YWdbaV0pOw0KPiArCQlpZiAo
dmFsKQ0KPiArCQkJV1JJVEVfT05DRShkc3RfbXAtPm1fZXJyb3J0YWdbaV0sIHZhbCk7DQo+ICsJ
fQ0KPiArfQ0KPiArDQo+ICBpbnQNCj4gIHhmc19lcnJvcnRhZ19jbGVhcmFsbCgNCj4gIAlzdHJ1
Y3QgeGZzX21vdW50CSptcCkNCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfZXJyb3IuaCBiL2Zz
L3hmcy94ZnNfZXJyb3IuaA0KPiBpbmRleCBiNDBlN2M2NzFkMmEuLjA1ZmMxZDFjZjUyMSAxMDA2
NDQNCj4gLS0tIGEvZnMveGZzL3hmc19lcnJvci5oDQo+ICsrKyBiL2ZzL3hmcy94ZnNfZXJyb3Iu
aA0KPiBAQCAtNDUsNiArNDUsOCBAQCB2b2lkIHhmc19lcnJvcnRhZ19kZWxheShzdHJ1Y3QgeGZz
X21vdW50ICptcCwgY29uc3QgY2hhciAqZmlsZSwgaW50IGxpbmUsDQo+ICAjZGVmaW5lIFhGU19F
UlJPUlRBR19ERUxBWShtcCwgdGFnKQkJXA0KPiAgCXhmc19lcnJvcnRhZ19kZWxheSgobXApLCBf
X0ZJTEVfXywgX19MSU5FX18sICh0YWcpKQ0KPiAgaW50IHhmc19lcnJvcnRhZ19hZGQoc3RydWN0
IHhmc19tb3VudCAqbXAsIHVuc2lnbmVkIGludCBlcnJvcl90YWcpOw0KPiAraW50IHhmc19lcnJv
cnRhZ19hZGRfbmFtZShzdHJ1Y3QgeGZzX21vdW50ICptcCwgY29uc3QgY2hhciAqdGFnX25hbWUp
Ow0KPiArdm9pZCB4ZnNfZXJyb3J0YWdfY29weShzdHJ1Y3QgeGZzX21vdW50ICpkc3RfbXAsIHN0
cnVjdCB4ZnNfbW91bnQgKnNyY19tcCk7DQo+ICBpbnQgeGZzX2Vycm9ydGFnX2NsZWFyYWxsKHN0
cnVjdCB4ZnNfbW91bnQgKm1wKTsNCj4gICNlbHNlDQo+ICAjZGVmaW5lIHhmc19lcnJvcnRhZ19p
bml0KG1wKQkJCSgwKQ0KPiBAQCAtNTIsNiArNTQsOCBAQCBpbnQgeGZzX2Vycm9ydGFnX2NsZWFy
YWxsKHN0cnVjdCB4ZnNfbW91bnQgKm1wKTsNCj4gICNkZWZpbmUgWEZTX1RFU1RfRVJST1IobXAs
IHRhZykJCQkoZmFsc2UpDQo+ICAjZGVmaW5lIFhGU19FUlJPUlRBR19ERUxBWShtcCwgdGFnKQkJ
KCh2b2lkKTApDQo+ICAjZGVmaW5lIHhmc19lcnJvcnRhZ19hZGQobXAsIHRhZykJCSgtRU5PU1lT
KQ0KPiArI2RlZmluZSB4ZnNfZXJyb3J0YWdfY29weShkc3RfbXAsIHNyY19tcCkJKCh2b2lkKTAp
DQo+ICsjZGVmaW5lIHhmc19lcnJvcnRhZ19hZGRfbmFtZShtcCwgdGFnX25hbWUpCSgtRU5PU1lT
KQ0KPiAgI2RlZmluZSB4ZnNfZXJyb3J0YWdfY2xlYXJhbGwobXApCQkoLUVOT1NZUykNCj4gICNl
bmRpZiAvKiBERUJVRyAqLw0KPiAgDQo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX3N1cGVyLmMg
Yi9mcy94ZnMveGZzX3N1cGVyLmMNCj4gaW5kZXggZWUzMzVkYmU1ODExLi5kNWFlYzA3YzNhNWIg
MTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfc3VwZXIuYw0KPiArKysgYi9mcy94ZnMveGZzX3N1
cGVyLmMNCj4gQEAgLTQwLDYgKzQwLDcgQEANCj4gICNpbmNsdWRlICJ4ZnNfZGVmZXIuaCINCj4g
ICNpbmNsdWRlICJ4ZnNfYXR0cl9pdGVtLmgiDQo+ICAjaW5jbHVkZSAieGZzX3hhdHRyLmgiDQo+
ICsjaW5jbHVkZSAieGZzX2Vycm9yLmgiDQo+ICAjaW5jbHVkZSAieGZzX2Vycm9ydGFnLmgiDQo+
ICAjaW5jbHVkZSAieGZzX2l1bmxpbmtfaXRlbS5oIg0KPiAgI2luY2x1ZGUgInhmc19kYWhhc2hf
dGVzdC5oIg0KPiBAQCAtMTEyLDcgKzExMyw3IEBAIGVudW0gew0KPiAgCU9wdF9wcmpxdW90YSwg
T3B0X3VxdW90YSwgT3B0X2dxdW90YSwgT3B0X3BxdW90YSwNCj4gIAlPcHRfdXFub2VuZm9yY2Us
IE9wdF9ncW5vZW5mb3JjZSwgT3B0X3Bxbm9lbmZvcmNlLCBPcHRfcW5vZW5mb3JjZSwNCj4gIAlP
cHRfZGlzY2FyZCwgT3B0X25vZGlzY2FyZCwgT3B0X2RheCwgT3B0X2RheF9lbnVtLCBPcHRfbWF4
X29wZW5fem9uZXMsDQo+IC0JT3B0X2xpZmV0aW1lLCBPcHRfbm9saWZldGltZSwgT3B0X21heF9h
dG9taWNfd3JpdGUsDQo+ICsJT3B0X2xpZmV0aW1lLCBPcHRfbm9saWZldGltZSwgT3B0X21heF9h
dG9taWNfd3JpdGUsIE9wdF9lcnJvcnRhZywNCj4gIH07DQo+ICANCj4gICNkZWZpbmUgZnNwYXJh
bV9kZWFkKE5BTUUpIFwNCj4gQEAgLTE3MSw2ICsxNzIsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0
IGZzX3BhcmFtZXRlcl9zcGVjIHhmc19mc19wYXJhbWV0ZXJzW10gPSB7DQo+ICAJZnNwYXJhbV9m
bGFnKCJsaWZldGltZSIsCU9wdF9saWZldGltZSksDQo+ICAJZnNwYXJhbV9mbGFnKCJub2xpZmV0
aW1lIiwJT3B0X25vbGlmZXRpbWUpLA0KPiAgCWZzcGFyYW1fc3RyaW5nKCJtYXhfYXRvbWljX3dy
aXRlIiwJT3B0X21heF9hdG9taWNfd3JpdGUpLA0KPiArCWZzcGFyYW1fc3RyaW5nKCJlcnJvcnRh
ZyIsCU9wdF9lcnJvcnRhZyksDQo+ICAJe30NCj4gIH07DQo+ICANCj4gQEAgLTE1ODEsNiArMTU4
Myw4IEBAIHhmc19mc19wYXJzZV9wYXJhbSgNCj4gIAkJCXJldHVybiAtRUlOVkFMOw0KPiAgCQl9
DQo+ICAJCXJldHVybiAwOw0KPiArCWNhc2UgT3B0X2Vycm9ydGFnOg0KPiArCQlyZXR1cm4geGZz
X2Vycm9ydGFnX2FkZF9uYW1lKHBhcnNpbmdfbXAsIHBhcmFtLT5zdHJpbmcpOw0KPiAgCWRlZmF1
bHQ6DQo+ICAJCXhmc193YXJuKHBhcnNpbmdfbXAsICJ1bmtub3duIG1vdW50IG9wdGlvbiBbJXNd
LiIsIHBhcmFtLT5rZXkpOw0KPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gQEAgLTIxNzIsNiArMjE3
Niw4IEBAIHhmc19mc19yZWNvbmZpZ3VyZSgNCj4gIAlpZiAoZXJyb3IpDQo+ICAJCXJldHVybiBl
cnJvcjsNCj4gIA0KPiArCXhmc19lcnJvcnRhZ19jb3B5KG1wLCBuZXdfbXApOw0KPiArDQo+ICAJ
LyogVmFsaWRhdGUgbmV3IG1heF9hdG9taWNfd3JpdGUgb3B0aW9uIGJlZm9yZSBtYWtpbmcgb3Ro
ZXIgY2hhbmdlcyAqLw0KPiAgCWlmIChtcC0+bV9hd3VfbWF4X2J5dGVzICE9IG5ld19tcC0+bV9h
d3VfbWF4X2J5dGVzKSB7DQo+ICAJCWVycm9yID0geGZzX3NldF9tYXhfYXRvbWljX3dyaXRlX29w
dChtcCwNCg0KDQpMb29rcyBnb29kLA0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8aGFu
cy5ob2xtYmVyZ0B3ZGMuY29tPg0KDQo=
