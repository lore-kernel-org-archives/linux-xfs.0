Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AE619E97F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602556; cv=fail; b=slupocEiz4FdfEz4c0EL4jsCvvXCPr+7KJksGaS+edq/n24k6iN2yVWGf7Rx3LeryvSO6HqPnG2K+2iqhgehk7jz2pcC29rx29tBAXwXiY/UAQ66RthUxuKkA84fz9x4b55N8BXjtb5lzwTcoPhRkfCO7+QxM8zCSeuRpkkndN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602556; c=relaxed/simple;
	bh=mAmct0Gf8sZpAlvfjzR/HsAJcy1ZAAi8+oEpR/+iJcA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RK8t25tI2nFZExKEmK9iyVbfkwLh762AM4KfeybZAnE9zCLvrXYFIvrfSApIOrKN1Jpv9sTSqOjSZCICdcTvFo64CqRgsnLJnGjRj7jMPzpob8Z2h6R1UerkwYCMP3Oc+pokjlch+jsUga0bIMRFNKpBg3vRo+T9Ge75hJ/Ru/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WJQicgez; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nngrq8LA; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WJQicgez";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nngrq8LA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769602553; x=1801138553;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mAmct0Gf8sZpAlvfjzR/HsAJcy1ZAAi8+oEpR/+iJcA=;
  b=WJQicgezuPaEBBvQI1nQ1lYNL6zroJq0YzZoHuUBlXyFcOTsWdZ08+cV
   D88FC5toLcqSU1MDMmX8lfAibd7ddZkR0UrdNAd8wJxoQoHV/j481WlmL
   yiOnG094xbPyTfndMYNekcYM60IIFc43J4GNEp3YRTT0c4bEG3bxlquTj
   K9CfgGLP8/uQMFbnzjsoCYpO6vHQR2pG536UXU+1K56AJ2AIgA0i7+PVK
   UKSGAdzCjHW9bilhUJGz5fGK5wSEUtYt5g+1j4h/rEygUxHO3rRdQrJvK
   OOyUKhoscCFZEfEyqYXzKG0MTHNTU3hylPgY+KJCkYU9v5OO8d2+ZNJNp
   g==;
X-CSE-ConnectionGUID: jdUfHlXUTO6d8wYW0QjIDg==
X-CSE-MsgGUID: rYtxC9jRSj+PGaygMOcDqg==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="140793391"
Received: from mail-westcentralusazon11010067.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:15:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F13AMMQf0jXohc7WMvXRwvtX6kHkx3Qy8UzP4Tlh25qgbQuAmWRCCwmSEkHe8aPn3objz/gtZvL1KjZ2sx4/PyKTXgpG17PQHptqzwH76eSlzLSh4k7HfXbFHpm87F3WOFEc0jNO7/7oMhaNfy2EI+ch9xK8qWZs5k5AZMDClw0ZRhqtTFZ1vWFpFXMurv2ISaJfBeuB0rSJ+WH78rK/21eN1yVbe02V1AMyoTGd5KLwf+ITm/R3P1dt0+0D0IK4ECD1bd25hagrZst1dlzqPbCGvBiqwUqH10AXvKsATvBkFmpxBNA1RRX+A41PhP4/ZYc3z7NiCDoG8Dv0OV/yDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mAmct0Gf8sZpAlvfjzR/HsAJcy1ZAAi8+oEpR/+iJcA=;
 b=l/BN5SaPZYw0veCE6rtTJUb4GqhLBqzIOQBReVz2GAaAuRxS3HNOhpp22dlp301nI/5CQjBJB2JcaLlqdGhTBF9pUPE0zgOEfHhYIa2gZhWToVjxJrfp6ESx1hy80Hu7IUWhL4zjmjlxAKPSej5YvwGnZTmOBpeHg+Wx5ZPhKlskjq0o3uErUpvxS66e3jAE2eoGgtRGwv6PvnIx2/3a/paGVrxnPpRKN3hU4EmFvxshGAUYklX0yUe1qJ6TFd2Cokqpptdu39QdS5GFIml9v6ztIokuRqlQRPo6w+S/A5J68uTXBWxatiA3Z0yUhDI6Mlq+IyLvVSywxfvQenveSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAmct0Gf8sZpAlvfjzR/HsAJcy1ZAAi8+oEpR/+iJcA=;
 b=nngrq8LAdDf/SxtxUtcewveV0vie8nSnz27/V6jb6j0BvaKT7pP2rZ9Lgi/VmR2s0sSuUj3cD59anRKeRD7IGia2ksPy0VLBTieCHawEGMTmd8hZc0A4HIWk2cv2wTtN/4bhnSP2DeHbDuIG75NakTO7OvLyZHk1OKdhzr1TGME=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH4PR04MB9386.namprd04.prod.outlook.com (2603:10b6:610:23e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.6; Wed, 28 Jan
 2026 12:15:51 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:15:51 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 07/10] xfs: don't mark all discard issued by zoned GC as
 sync
Thread-Topic: [PATCH 07/10] xfs: don't mark all discard issued by zoned GC as
 sync
Thread-Index: AQHcj6b7/A0Yx4am8kK4vnQwGBHtYrVngGAA
Date: Wed, 28 Jan 2026 12:15:51 +0000
Message-ID: <e96cb52d-2198-4d18-a16b-7246e3306c44@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-8-hch@lst.de>
In-Reply-To: <20260127160619.330250-8-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH4PR04MB9386:EE_
x-ms-office365-filtering-correlation-id: 6300f7c3-c978-4a17-e243-08de5e66fa4a
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cVVXY3RxNjBaNi9PRmwwaUs1S3RsZ1F3K3czUU9UTm1XR0FyNTVDb3N6b3NW?=
 =?utf-8?B?enZLdEhtdWx6YkNmS2xWb085V3huTVNia2dmNmR0ZnR3MU11Nm80N2hKak1J?=
 =?utf-8?B?WitJd3VIeEtxNE9Ba253SHJNeVZubjU4T1lSTkNBYUNXYlUzb2dIZkRFczE2?=
 =?utf-8?B?aXVuVFA3TlpEVUpZYTdUeGtSOEpMYTlQWks0dkpKWUZzREFVMStQakkwRlRq?=
 =?utf-8?B?dGx4SVhXVjdacXg1eVNDcGpicldGeElSV1lNaGRZK2h3OGFieDZQNXo2cUNk?=
 =?utf-8?B?ZTFET2xvZWRuRjFCbFMrL3JRamROeGNpTlZmYjU5ek1FRkF4ZXhsNEFIYy9B?=
 =?utf-8?B?eFU2RDd5WTFIWXNwRmltS3hsaG95b2dSSjZSbFk5YmZYcS9wYjhFOG9zZ1lk?=
 =?utf-8?B?ZVovdmhINHNSa2t3Q1RkSms2VmxSS3RxdVlFM3dPRnc4dXZ3L1pUQUhuTnhP?=
 =?utf-8?B?UVI5aEJMS0t1d3M4U1h6R05HUzhRR0lFQlZEbzFtZUJTWXJsSmhvc2dCREov?=
 =?utf-8?B?RVZpZW9FL25tanA5WmNYTE54bHJiVDRrRjVZZXQvZVo5SHhXN2h5T1U2MDB5?=
 =?utf-8?B?SjJYN3RYc2NCbnJ6d2xMem5GSDlLSTVEOW1CNnZwTzNRWklUWVlkTXhqTm8z?=
 =?utf-8?B?UHVpL09ZWjE5ZUUzeGt1NXI4bFlHc1hBVmN6T2pFVCtXdG1HckFBUEVJR3lG?=
 =?utf-8?B?blBBdUVKbDVnVXd6SjF3QkZtdmRTOEJta0Z6N0hFck5RamFqbkZrbEIwZ2p1?=
 =?utf-8?B?V0Y4VmxoZ3pIMHVvN29IbE83OFBDV1RGN3hiT2pFZHZJdUdwdGg3MUNZSC9m?=
 =?utf-8?B?TmxvQjFBVkRxTTgvME10OElzYU5CSE0vQmh5YjRRM2VNM2xWUWpBRTdsb0J2?=
 =?utf-8?B?UWlpSlBrTEhOVk1Tdng2c2VrK1EyRGlicURMZkdRL1RVSHRnOW8xVjZFbzk2?=
 =?utf-8?B?a2hkOTl2TFNZSHNYRTZTK3M4MC82aHJBa3JCbWk2OW1jaUdORmVUMGdaRm1W?=
 =?utf-8?B?ZGJ1MG9jbmp4d0NDdzRXM3ptandTWGFTTTFaWjBNUHovOC9tWFh0Y0o5UFJ1?=
 =?utf-8?B?TkhHYUY1Uks4Q2cyT0p2M0dMUENMLyt6ZWZrRDBnc2hJbHNNayt3RExyQnhv?=
 =?utf-8?B?d3k3WmREd1grQkVDL2tCUGcwa1gvZkF6Ti9vQ3V1LzluS1A0UHpMY2ExMlFz?=
 =?utf-8?B?akUxWkIwY2ZtZ25CWnlRb3E5dnVkVGdVMUgxV3lNT3VpY0E1ai8vTHJCbk1Z?=
 =?utf-8?B?Tk5sZjgvRlFJcTBuRUlBajgzQkNBajlZdXAyNDZ1SVFrUEN4cHhURmFPVWRC?=
 =?utf-8?B?M2NRQ0lRdlhJRm1jT05qNks3K0hxYnY3WEZQUkM4VGVoTEM4aVJxeGk1SnhO?=
 =?utf-8?B?UitOdWxydTdPK1BsczFzZUI2Y0F1czJ1NHhQQUV1TVNPMkFhOHZXZCtuc2ZK?=
 =?utf-8?B?U2duUVFza1FReHRUcStwblptT0hPZHJ0bm8zMXJZang0QjBGN0JTbExNV0oz?=
 =?utf-8?B?QmpSVTFBVS8wa2NidXR3SEcvOUZVbnZIZ20razl1RitHZnlNcE1GMUJVQUpV?=
 =?utf-8?B?ZkdEb1d5N1RxN1dxeVJJMXdRaWpwRHNDcW5qekg1Q2syalFOSlZBSjRyRHNB?=
 =?utf-8?B?YTc4ZGJ4a2dBN2Q0cGp6em1KbEZUVkltV1YvYzYzTnlLSmFsMkt6QWpVWSts?=
 =?utf-8?B?dktmMHdDRDdVeFVjVkFRUjU4OHRDbTdSVlFaSStWNmNaeXJPREZLTStTME5F?=
 =?utf-8?B?WFRFTFgrNmw4NkNWcDl1bEFvU3paL004TFRyWDh5SXRVTjVEcmF0T3JDVTEy?=
 =?utf-8?B?clJPTklySHcwQm9NSVd0ZkhzcG9SM0tMc1luWVRrSGRQRVp3VHhnVU56U3R2?=
 =?utf-8?B?WjUyd0JvTUgzaTdWajAxT2s5RU1hcjFkcy9nc21nM1hYOHpDR0xvOGU1SzZw?=
 =?utf-8?B?eUhMZ0wxbEtDOUFpeWFLczNWSGp6cDVRaVBPNVQzTVN3N0drcTI2aStjdkM5?=
 =?utf-8?B?Y0N0cjArb0JWNnpNdmtFaVp3bHF6RjNQbXBYZEd4YmJEeXY0V0hYeU0zNytp?=
 =?utf-8?B?VWJLeDZnQkZJYlJ3MmRRUVpwS1cyTnh5bDhNaTZ2SGpIOWdBN0dTUitpbml2?=
 =?utf-8?B?dnhpUlBLSlNtaG56MmNRV282ZU5mVE9ERnVGek9zTy9HKzZBa2hPMW1wblNh?=
 =?utf-8?Q?rSytzpsybhvO8YDOSu4KAMc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MllEMy92Rkcyd3pwak9vTzRxS0R1WWMzVy9uUEVzRXFETmNMR0YyMXlIMDZB?=
 =?utf-8?B?UU05MDhlaVBYUDJ3eGNuOStIOXhwZXZZVzl2YlpDeXVsSDV0K0JIaEVqQlNE?=
 =?utf-8?B?dDNxZVBpc1IwUUpia3Fmd2hDUzlXK2NET1RyRkYzbWxmMFNiM1gvVDZ0K0Nw?=
 =?utf-8?B?eVUwUTQvYjIrRnFoVVErZ0g5czZnMnpPV2hLbkdIZDRtS09seEM4OTNidnAv?=
 =?utf-8?B?MVhVK0hDU0grRmZ4cm1zYTZlWXBNUlJ4Rkpta2MwMWxTYUQvcXZzS3l5SFFE?=
 =?utf-8?B?NWpjYklZMktQMjgvR3JjUG9JNTBHVnJxSEMzS1kxWHd2akEwTWJTTndqL2VF?=
 =?utf-8?B?VC84SGp5S2pOV0JTY1QxNllOdTNFOUJIU2ZzbWtsaGpuL1grN3Y3TmRBd1Fy?=
 =?utf-8?B?c3BFZUp5WXJjVHllQmV1eVBURU1GT29zandmMWQyaEtLVGxmYURxaDhqZGgw?=
 =?utf-8?B?NzVxMGZPcm9qTWJWTno1L2xVK1FSY2oxcVVqcTFPNUhGVm1FUmhhYkxleFNN?=
 =?utf-8?B?NVpnditNVkZkcmYxYTJ1cjVidUpkd3k0clY0MW9zTGRPdmxvRnYrM00xaFMr?=
 =?utf-8?B?RHBqT1E2RXk4aU5SN1VtUG4wbEdDNFVhcndnelhYU2cyYjFpV2hyaTlFakRS?=
 =?utf-8?B?ckJma3dNSzVxZWtzcFQvZENKa09jSi9HM09XbGZrc2wxdmlOR05URlBzMDBQ?=
 =?utf-8?B?MVFWSGxZMENtbUtRMjErd05WOUgvTW1RVy85eXpDeFJ0SXdKM05UTjlwWHZJ?=
 =?utf-8?B?QUxWV0pqUjNLWXh2REFzeGE2cHpmTE5hQy9GUnBXWVZDc3Nwb1doK2FHeW52?=
 =?utf-8?B?WnJXM0hIKytpWE9ZclZBVDNtMDVyRHJJOEoxN2FPSHVxYy93MmFqTURub01C?=
 =?utf-8?B?YjFqTGVEVldFQUxncHg4bUcwN1ZPbGN4OThDUTYvMWt0Y0lPeU9mdDl3Mmpj?=
 =?utf-8?B?azlXWEc0MzY5QzZYelZFalF3ejhUeThmdWZXWE52a0dwZGFyUUNGbStyWTlB?=
 =?utf-8?B?dVdxOFF2Yms2dG1va3hNdWw2c2dwNG1hbXBUTEJBN0QvVUhuaitlQmRnMWpt?=
 =?utf-8?B?dUNVZENVME5wS3JZaHZ0SmJiTmFHR294RU1OS2FBRXZqUTNKcFlCcVJxa2ta?=
 =?utf-8?B?aHhKZFhzNnNjcG9MNzBQb0RGbEpidHRCVktqSTRacG9EQTlvMk5OWWdya2hX?=
 =?utf-8?B?dXVWcUlHbU9tMnJmVE5IZkdFT3ZlcHJSWk9hcE9SdlFqTDlhUy9QejJWYmRJ?=
 =?utf-8?B?REtuUHJ4dG9qUjBvWGgvSFZUZXZxcEtibDVDclNMOFFGYldNS1RQRXN0LzVq?=
 =?utf-8?B?SW5yQ1NFaER5dDJUcWk5MUpSUTFTd0VFaHNMVWRIaHZzNzQrKy9OTDl5ak95?=
 =?utf-8?B?bEo0ZXJLczRLUEdlWWdMY2hVNFNJbUNCN0VCcEQyVFFRaUQ4Q3BiYXpRWU5i?=
 =?utf-8?B?TmhtbnJxUkowUnV5Y3JtVXR1aFhDbGF6NWRONkFUU2NXMm5MRzlodHcvZGM2?=
 =?utf-8?B?RWhCZFQ5OXMvRTBzajd6MlowQ0dWbWpLbHZleExYNjc5SndpaEovSHNGMW8y?=
 =?utf-8?B?eDRFTHd4cHN0ZTY2dHpjZlZ4L21Xd2NIaHBXaWVMVmdvTTlpMEpwNzZMWFZx?=
 =?utf-8?B?T3VxZVNFM3BTODYyNzhHUzZaT1NRK1Q3Zkpad1dFU1FvcWdJdU5tQXI1Z0Fa?=
 =?utf-8?B?eDR5cGdxY3N3NGdjMDZKb2pBT1Q2RTAzNGRjamZJaVhReExzQ3Ryakd5bEhH?=
 =?utf-8?B?ZENueXl3WGdOZFJHT3pBSlYyai9JOGROcFFUMEVMbTdVa3ArdUVpOG44Z2VE?=
 =?utf-8?B?a2F5TThtNFJQVGxUa0FwTnBDcjM4SEdzUG9TNEVCRUpWUk51TVphQmZwbjRs?=
 =?utf-8?B?Si9rdFJUYkI3WjBUc3hGVjlOSTZQUkFCdzRoSXJ0WUF5V3dMMGpUc3krRG4v?=
 =?utf-8?B?ZEhFWU9Ka01FMG9kR1ZVdGFSRUFFVnhBWDN3VG9JcDhyRjZiTDMzQlFkRzdY?=
 =?utf-8?B?akVBWEE4b3FESkE5Yis5VUhnZjIzQVpISmI2bUZUWGV6N3VFbmJTNEhpNXFF?=
 =?utf-8?B?SW4yZkx0UUVZSitoVytIcVNQRDI2Qk9aZFBxNGJCYzFoaE9ESGR5QVh3Rm5J?=
 =?utf-8?B?UGcrTEpXbm5MNjZvTnNobHA0cDNDdnhCM0xYcEFqdTdyeGxmRTl5WXB0T0hT?=
 =?utf-8?B?cC91cEYzbFpVcTgyTkNVNFdkTTVZaHNPT21uNjhUeTJ2VHdFVWUwSkRMYXFG?=
 =?utf-8?B?cXEvejd4ekhJMWVHYzQ0enhyc3pWNTFjY2NmaFZGUVNpdWdEaUpLb2NpcEU0?=
 =?utf-8?B?dEsvVHZqQzdkUEJ1YkpibnNlZTMvK0crVkNURXFXTWttUXZsUFIwcmd3cVow?=
 =?utf-8?Q?s4IUGY9CyrnnFp9Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <54EFC0C265122E4B8F066D7074BE39C3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UCuQGKEVi5PDzoPGR4k+c3PmuKQWrN57D6KyYnp6pfx06BOI9oiqmESULSsP4fZVS5lAsOInvzNWI0GtaXA9PmX8yzDjFkLl7QIQLx5aEYjJ/SblHiqEqU/FHbYFDfQcwJTpS0++CWRkmkm0Rc5HQmWJrm9iwleykNaQBUn5HVl0x0lHZLNe1I2xJaPV0Y8Z6tqC973qegWzuFHTh1JKvoClIrpmDzjweZ7Vd9oO1fsCTlXMYjCzwbGXrHquOpXO9WgBlQO7FxlJUOse85CJ0Oq/AWSk73LDIcKaqEyyY557fNpPeTPGJTvXHSp57bXfMd81Ux0Xm6bKKANbrcb0Hc/Vd/O+eIi+yy4T9ItZugueLy9ZchcYs96dvuD5OLQOMkxCiZryUjtRYi/Ux2RivYnFVtI/FOXpuOGQzYgi73M3Mfkcg+4vtCO+AiAtG6ebLpty8aSlqKsCQg6rAfDI9GkpC7izmVZh1bW14xzN/lul+ZIJcrEc/7vYN4Ke8yY4FPPraPzTq9Bwb3NCIJKFvMVpLi2GErd5PDfc6LkJHWAR0+Rsvi71cOFnYEVzUabrJl53WpnmEWTN0YOI/hB37Vzb5vvlVyrVKMYT80MQWUmE7RwBCxo24dXUfv+r7R9h
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6300f7c3-c978-4a17-e243-08de5e66fa4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:15:51.1475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +K6Cfys8ibpRTi1BMQcR3wgdCJxnPdpCwhyTRZ9nK7gsNj+Brmp/23DfF855oq/CTa6ln6rFXe5M2eiy8jM08A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9386

T24gMjcvMDEvMjAyNiAxNzowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IERpc2NhcmQg
YXJlIG5vdCB1c3VhbGx5IHN5bmMgd2hlbiBpc3N1ZWQgZnJvbSB6b25lZCBnYXJiYWdlIGNvbGxl
Y3Rpb24sDQo+IHNvIGRyb3AgdGhlIFJFUV9TWU5DIGZsYWcuDQo+IA0KPiBGaXhlczogMDgwZDAx
YzQxZDQ0ICgieGZzOiBpbXBsZW1lbnQgem9uZWQgZ2FyYmFnZSBjb2xsZWN0aW9uIikNCj4gU2ln
bmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KPiAgZnMv
eGZzL3hmc196b25lX2djLmMgfCAzICsrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfem9uZV9n
Yy5jIGIvZnMveGZzL3hmc196b25lX2djLmMNCj4gaW5kZXggN2JkYzUwNDNjYzFhLi42MDk2NGM5
MjZmOWYgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+ICsrKyBiL2ZzL3hm
cy94ZnNfem9uZV9nYy5jDQo+IEBAIC05MDUsNyArOTA1LDggQEAgeGZzX3pvbmVfZ2NfcHJlcGFy
ZV9yZXNldCgNCj4gIAlpZiAoIWJkZXZfem9uZV9pc19zZXEoYmlvLT5iaV9iZGV2LCBiaW8tPmJp
X2l0ZXIuYmlfc2VjdG9yKSkgew0KPiAgCQlpZiAoIWJkZXZfbWF4X2Rpc2NhcmRfc2VjdG9ycyhi
aW8tPmJpX2JkZXYpKQ0KPiAgCQkJcmV0dXJuIGZhbHNlOw0KPiAtCQliaW8tPmJpX29wZiA9IFJF
UV9PUF9ESVNDQVJEIHwgUkVRX1NZTkM7DQo+ICsJCWJpby0+Ymlfb3BmICY9IH5SRVFfT1BfWk9O
RV9SRVNFVDsNCj4gKwkJYmlvLT5iaV9vcGYgfD0gUkVRX09QX0RJU0NBUkQ7DQo+ICAJCWJpby0+
YmlfaXRlci5iaV9zaXplID0NCj4gIAkJCVhGU19GU0JfVE9fQihydGdfbW91bnQocnRnKSwgcnRn
X2Jsb2NrcyhydGcpKTsNCj4gIAl9DQoNCg0KTG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEhh
bnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg0K
