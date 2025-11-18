Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5231A2F25FA
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 06:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763448830; cv=fail; b=KugFjjOdMYK1Lwy+pCOmVgBb71Hu5jVtrD9fH4wEpjsShq5rYUEEWKgrHWAFD/n9/5H3KAIACBSEsmINfYKbAAfCgRcQQ9fG6isMjGw3zhP9CK/nA3eXJ/C5eLMRgz95DDUalHSG42WY9kwNNKoI7G+GE1pr7ZgfZF+h9AAIXAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763448830; c=relaxed/simple;
	bh=QdhbMuxkZ9EgTYbsCz9aosO+SgtcbEsjjCHePWCCJjI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kjt2xkunoRfO1mCFCerObuYOBUe5mmZTii58iGMHICuT2dr8+4jd1hExZFGrVC8b4dep25nmHuVZ8UWscYoeQlZSHphKVfRqnc7+QGFJzqPXYZtrUg0nL+aE8C7YfiVy+SatV2uLxIEA+SRpFH1kjHxKN098Mlo1CN5tYW5YOBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HCjr9SUs; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=S3mdpXwb; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HCjr9SUs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="S3mdpXwb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1763448828; x=1794984828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QdhbMuxkZ9EgTYbsCz9aosO+SgtcbEsjjCHePWCCJjI=;
  b=HCjr9SUsIupeHFb3X0xaFfJev+Z/gdIwnLhyhO2FEB0AWHRAmHq/yNLf
   X/nHGzGSaQJ0PYJcPaI3sLXfHLJ/HK6QPmcZfN5n9GjyK7FxSFCV/haxX
   NfnhHJFWjVKoP5JOoQsKErYg1HnpCA5DQZ1iz9TRxD5Fq/s5hEZyp07t/
   DW6PZkX17qZD2vrniL/S1FRN+cRKhf4JX4wRdMbKpSEh5pOPEf/ThMBjU
   zn0oJwWyjdK3dEjGLMhmgs+8JPpXUZpEwGHtAtyySMq9M+T104W6jYu/6
   B1+kJWCs8yUni7ryWc4LI/b2xCOneoXnrJda0oi9E3wkX4yiw+T7N3od8
   w==;
X-CSE-ConnectionGUID: tfgKGxsCSMauHyuz77TlzA==
X-CSE-MsgGUID: ywq8FjsmQ6Gk0P3SkRMxeQ==
X-IronPort-AV: E=Sophos;i="6.19,314,1754928000"; 
   d="scan'208";a="136257853"
Received: from mail-westus2azon11010029.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2025 14:52:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H38qYGRjJjca4bSudAErMdW6J+nEOsla3AE6fZjI3R5aBVS9jP0UCIYHHSgfBD65SmIeLSjC/14T9oXKexlXrtOBDmG5qcjL+LZCE621vM9OaOugcrVQYRlIAxnKo2QaID02dd7hSAEmqtzbqemGGfna4nt9I/EhgkqhHgHIqTHgCHkAChlCVpW2WXUTRynaAtUjEtVtjcJFmGs3xVKpRPyWz7IxekpVjuWXb5Q1R1DiFkhqu9MhTHdgBu4df7XajRO0cD2+RTF/voD7TknGRaNRveFe9Uzgbhv95mFaob9PF60VSEpnD4l7KvoTqtFmeJWuVsWIdokBnLbzTzeeWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QdhbMuxkZ9EgTYbsCz9aosO+SgtcbEsjjCHePWCCJjI=;
 b=v03/tRS/00FUquJHPigxRbrM+KjJKOxgmkPYYXesmwJaES7wVYuXyKQnD4F6jhIsW0qODzJuuqKM0Zk6iTfNKfkTEAunzueAlzhAQ5+2Ueh3pkKOMrqzcJVvXJQqYksnQz/lgwVVefQohiQrRQRjmsMq9rkdEhRMtiieerKlWxr+0u7prSecq1xUkjDRMGr1zvf7nAcVQtvqYjt4wfNP0oOxpl3vlZHOZlWrZGtaQU24rsUNKhXf8c0o41TF/nXh9bYYKAjkPkkgaTLQWJuRTr6grkm88jAkxNKECBTKo0xlzlGm2EHmbp9CtNFcHW0SM5bmIiHboKQRka3s4TW+Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QdhbMuxkZ9EgTYbsCz9aosO+SgtcbEsjjCHePWCCJjI=;
 b=S3mdpXwbgTD1ug3qeAdcWcIbMG/rO72GhpLyvyy7VnVFHfhbYfsVN3lA4Vtx/4eHqiYHgqI/4W0yqeDs3xEBext+v2f2TXuKSD7jgcWHwD4XMWzpA44AxFAJ2cOcBUIvCM5OLJbPyzuLY6iJ3hCULFdoL+J/20irOHwvkmdCkWM=
Received: from SA0PR04MB7418.namprd04.prod.outlook.com (2603:10b6:806:e7::18)
 by DM6PR04MB6347.namprd04.prod.outlook.com (2603:10b6:5:1e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.20; Tue, 18 Nov
 2025 06:52:36 +0000
Received: from SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::17f4:5aba:f655:afe9]) by SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::17f4:5aba:f655:afe9%3]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 06:52:35 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: hch <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: use zi more in xfs_zone_gc_mount
Thread-Topic: [PATCH] xfs: use zi more in xfs_zone_gc_mount
Thread-Index: AQHcWFeTv6+g3iyYAEuIljbRkXizrbT3/yeA
Date: Tue, 18 Nov 2025 06:52:35 +0000
Message-ID: <65571801-dbe8-4e5e-8764-2a70f521261b@wdc.com>
References: <20251118064942.2365324-1-hch@lst.de>
In-Reply-To: <20251118064942.2365324-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR04MB7418:EE_|DM6PR04MB6347:EE_
x-ms-office365-filtering-correlation-id: 943ade5f-8d47-4d0a-866b-08de266f0e6f
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YmhaMnAxSEdhbjQ2OExCbTNYQm9FdTJoZkZHcEpVMmYzbHJsa1YrRUw0SFBM?=
 =?utf-8?B?RFBFMnkyRGh3TnVtbUNaUUFtQU5GY1Q1OEhCZitEblFKWTU5Ykx5bHI5SjBw?=
 =?utf-8?B?b25jcGZXMWk1MXV1MkJWSVVXdGVHZ0ZTOHo5OFhXK1hQWVk1ZHJTb3ZqaTl3?=
 =?utf-8?B?d0RWZWo2U0hLWjFuSmtjck9UUmtmQkErS3RXb3p0ekNscVJqMnFHdVd2ejBP?=
 =?utf-8?B?YSs3OXRpY3JuYkNMS0FGSDVadXcwV1ZCekFubUtXV3pSZWRTL2EwMmNUVEt2?=
 =?utf-8?B?TWpQQWNBUWRpZGdZNlhXQmxwcE9TT3lUOUdEa3NISVU4Y09wb2JLQVF2cU1y?=
 =?utf-8?B?TFZObEF6UkV0N1JNdExLNThCeVRiS3VrVkxtcUIrWnRVMGhVOWEwd2Fqemwv?=
 =?utf-8?B?bFl1YmZKZVNid0lxaDF1allXMFFRWTFiOTRCaURZZ1ZGRGlaelhDS01nblE2?=
 =?utf-8?B?YW5hb1ArWkRza1Z4dmQwUDlJSE5UYnNGSlVPdnozUDl4WXRvbzNFNFY2c09T?=
 =?utf-8?B?TURrSitqMUljWnFrSjBNb3JTMGpmY0EzQ2RKVzV0NS9HUkp0YmMvVG1keXVm?=
 =?utf-8?B?Sm56eURMQmgwTHRra0dLYUlkNGxFOGlNYkJTSFlaMWdkcWJ2L0dVWGJMSnZB?=
 =?utf-8?B?azNDZVpHTS95YUJ3andyV0xqdVJGRTk4U0g4NEFEVGVRa0VTNHhsSUNJUHA5?=
 =?utf-8?B?Um5Sc1FrNHd2ZjBXVWg5c2xuYWdXRkFUOE9WM01jTC8xQ1MwUVJpYytTV01i?=
 =?utf-8?B?aDhEaGNTbTJPY3ZBUWc2YlBzZXdWVlRuekwvS2NSRkp2ZzVaSlU2UituU0ZK?=
 =?utf-8?B?emU3TER5QnpyU0paaVhoaVRhZWd1YjRzNndiaUNYVE85a21yTmhzRlVPTlF0?=
 =?utf-8?B?Y0lLcUdtKzVKZFB0djdpZzhzRmNZSnB4bHNWbFpVbDhFbTVZdFRlZXBrbWtu?=
 =?utf-8?B?N1ZwN3dPbm9uYnQwTEdDSnp0cXY2WXlBNVdPVDJvSGhaTFJ3bCtzQzRkeXdC?=
 =?utf-8?B?RFQxY0x3UXFxVGhCdDNUT3kyalNWUmRkOW9PREdISkkvL3FaRk9kL3FxM29r?=
 =?utf-8?B?R3RoejVpeUtkR1FGbngxZ0NnejNBcHhMRmJ5OUpnOHN2VWVncDAxRE5IelNY?=
 =?utf-8?B?NTBUTmROU0p3TjNtOEQvMk1YMk1hVjdJZDgranpVT2w1dWRBN1NhcnY1RlNo?=
 =?utf-8?B?dGRNNGtwbEsxc3Z1TEZ5ckp5YkorVlBsNFRrUktMekV3MlNySHQyV2FqdFFr?=
 =?utf-8?B?UjlxdFBMUytpTHRDcmp3dit3V1VJanBtRm9SU2lsN0xqREhwTmxnVlJpNk1m?=
 =?utf-8?B?eWRnWlVUTFp1TG9WWGU4SVlZZEtrNHowRGZxTVh3VUx6N2dpUFBMVUlibVB1?=
 =?utf-8?B?ZDk4dHQybE9rOWFWVndBdVlxV0g2SmVhR0lURGdxTEh4UXMyamMwWXltYzNN?=
 =?utf-8?B?MW5KcytRUXdBY0JjTHJVcGNIK2JIRXE3RVVrQmtUc3pGemNkNlFMYmxnaXd1?=
 =?utf-8?B?WGozREc1ZHlPbFZkSWNkcmtyVXo0VzJ1eEZvWWFzUElsN25XTlQvdnIvcFBk?=
 =?utf-8?B?dURENHQyVkI0V1lZN216M013dkZFaWFSMEg2TU1vRHlPOHRaTGFJSjd5SE9W?=
 =?utf-8?B?RXBYYitIN0xlU013TERZN1NHeUxzK0VRdWpMalgzM2dVZ3N1VGtDS2hSVDVo?=
 =?utf-8?B?NGRMekp2djRpRXB5WS85dTc2OVRCaUt4dUJlNmxoVkErVi9CRi8xNzc3cnA4?=
 =?utf-8?B?ODlFVkdBQ2FWYXNuSERmRWNKazg0cG5NclFyeFROZ1pNLzN6Z0d4dWVEOU4y?=
 =?utf-8?B?TzlrTmU4SUNDczgvQkNYZXJkY1dDUWd3RTJGRFR5c0VqTVRhTHkySml3RGlU?=
 =?utf-8?B?bVF0MUZodDNZMGpvNVY1R1NkQ0QvSEdNdWVHaENUNnJ6THRPN3NkdWNuR0Qv?=
 =?utf-8?B?U0tIMzZZL3dpd0JWdFFScjVJc2w1a1BGVGpXRE9aSTlDVTFvTXV0M2F4UWpn?=
 =?utf-8?B?eGVLR0NSNGxSazJ2OC9xQjdOeWpOS2ExbDU1VEZWemI0RGp5eXg1WVYyeE11?=
 =?utf-8?Q?O+lZdR?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7418.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UG1kemcyMTl1NmlBQ2JCMVlyM0RTT3JwbFBja21uWXNQc2NIOFFNQm43MFc1?=
 =?utf-8?B?VzBqR2dmaTlLenN5WThkemVOOXdBVUp2YzZPcnF0bENwblpaUFNqbW9EdUM3?=
 =?utf-8?B?bDJJZ0V5bTFsMldiUzBmZGVRaFdqUzVrLzFsR040UzhVK3loM0R5alY2ekV4?=
 =?utf-8?B?akpnTUlZZVpzam9hU1Zsak5NbVk3RzhCNVUzeDYxdk91M3dNNTRkK1NOSmpM?=
 =?utf-8?B?TzJBb1lVeno2MlpJYjBUZjA3NWgzK0xCeVg4RHYvWjFaZkpvY044Q1ZUU3Ba?=
 =?utf-8?B?Z3Y4QWhiVm9keFJmeFZyMnVPT3ZIRGVQbnNUZGUvWFdXcXZQQ2czbnd6Y29p?=
 =?utf-8?B?YlRjOW1hN3kvL09kN1hYbGF4S0poNlg3d0xqMlEyTzduQnNhSGI4TWo0eE1s?=
 =?utf-8?B?VkxhL3VWMDg5WWRwMlNnenp0ODNRUEMwbE5CS3pJVXh4TWc3RmZ4Vk5ZZjl5?=
 =?utf-8?B?bThEOThwMXNUMmkxK3JrNkY3eEp1TDNGUVRNSjY2cEV2VW5EN3JiVXNsR2hI?=
 =?utf-8?B?UHlFY1dXdjRDV29wR1ZmSEJreUoxbUptTWxRNHNFcE5qaGxxVDVDZTFoVnNo?=
 =?utf-8?B?bnNiSEtwMlpERlVjVTBNS2M5R1dwYWFhT0JVSHFhTXBwaGx1N1dYUDQvQzFO?=
 =?utf-8?B?NUw4ZFQ2Q3RUYTBiRVhxaDFQNjdGekFFTzRrWHAyYURObnl6YUROakdwOXZH?=
 =?utf-8?B?NkVObjFjODljT1J2anhlOXFEM1JBWFBZVGpKUC92N3dOZDRGOHJwL09JVExB?=
 =?utf-8?B?MlkzVGFHZFNsVlk3dldMMUpSUEdhbkxQaUIzRXl2R2pFOFVucXd6WVY2Q1lJ?=
 =?utf-8?B?TEJsRXZzejFqaVcwaXcvMHpXNzF5SEVQM3FZL0VEeDN1TXdLWEtSa0hyVVpP?=
 =?utf-8?B?TVREbjVWM1VwVUg2MTdITkRKSEdGMEJFdU9WZmhxdUJDS0laL2R5TmdSQmtB?=
 =?utf-8?B?RTN5aW81MnlCeC9XbE81ZGFoaTJQR1JmUjFqTHNpbHlHWCtubzMwcUJWa2FN?=
 =?utf-8?B?UlQvd054STZlQ0duck9tU0VlemtoVGJlaloxVU5iTjY5NElkUlUvTVJ4UjF1?=
 =?utf-8?B?K3lMNDd0dlV1TndYODExdFN4azR3RGFYMWlWZFFrVlpsUWdrd3BvYkhOZ1Vh?=
 =?utf-8?B?eHY4TzVOblEvTFZ4c2g1bUZvY1N4ZzlkV0pZNytUdXdSRk1reDVtUlRvNC9I?=
 =?utf-8?B?cE43MStaN3BxVmVaNFFnZUhnSFI1Z0wxcXFXdmJIemFicWtOVkl0TzRKR29Q?=
 =?utf-8?B?SlhGRzNTM2xpM2Q5TXNlcFFNZTRXTzZqOVAzTUpCZFkwOFN5OFJ6ZDAwbjg5?=
 =?utf-8?B?RWFJMDI3RUZ3bExzQU5BenlHYzF0RUhmSHVvazNsSXY1amRoT21lTlJMKzdr?=
 =?utf-8?B?N0V6UEU0blJDakh6TUxwbXUraDhSK3VJajFqVmErM1RGSnF5OG5EZk9Mbm1H?=
 =?utf-8?B?Q25xMzRqU2NZQmk1VlR2dVVBc0N3a2pZYVZKbFI4d0hlbS9xSjV6UlBiTmVt?=
 =?utf-8?B?eHFGR3dlS3YwQm5weEE4MzhBaFI1SHNTUjlGV3lsQ2d3RUFkc2hpRDU4SWNk?=
 =?utf-8?B?SXhyYlRSTG5KY2JGWkg4eTUvNWV2TXB6WGVGTFJWMzRDL05NNDBvdzdqdUp6?=
 =?utf-8?B?NElwNTRLVXVvaHExVm42ZXAvWTlhVjNoZE8yZUNQNEFqQTFCeDhBekZRaEhC?=
 =?utf-8?B?TkRtNHNtTVI2WUxlY1dHRk53RHpWL3JMSW11OVp3QlhOYXkwcFJRM29yUDN0?=
 =?utf-8?B?UnRaVHplUXZ6SUNIUVFIL2ZCRjBZYlQzNWZ4V3kzaUR1czBtZEdkM1RGNmJX?=
 =?utf-8?B?TWRudTNFTy9ydCtMSjI0aUgzK0Vudm1mejhTNnNoSnRrTkpYdVROd3IzUEY3?=
 =?utf-8?B?OHJwa29ZM2Y2THBwTlhpQ0hXa0tKWHM3Sk5KTnN2OFJPUGlYZFNRckM5T2Rv?=
 =?utf-8?B?eVRJREpkZWpyeTNDa1R5SEJlR3FocTgrZ3huNStqNTRPazg5QjVrdmZvbTdj?=
 =?utf-8?B?VG9TaEM3QzgzK0N4TUNPTC9WV1NPaE91YWxNa3Q5bU43aWJhVXl6NjdqWCtW?=
 =?utf-8?B?eXZJQlVnN2sxNWhZalFWdmJBeVpPS1lTMStaQmx5MHBadnlnU1dmZUw1NlRQ?=
 =?utf-8?B?aGs2N01kYjN4U0tCWGt4TTFrMTdjR1ZwejVJTmdkQnRLTXYxRzVSQVZnc05U?=
 =?utf-8?B?WXBhUmVIZlVXMmZ6R0RIVjllWEdSeGNjQ1pGSHNIdHRYZDVWSUpsNUJGdS9j?=
 =?utf-8?B?Tnl3OEN0KzZRSGlFc1RsQ2tmMjFnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88792474BCDD944EAA023629F97B8B83@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/8RupCJBcgFCxrhuOozGjWu/o92IrNUvdgzEXzfrrTA36srVNGSYk7g73gk/fbpgWcDTgZEBkcDQOl+7F4aebsTmB6eMN0nWBx8bBgUfImHv60f2MMW0YfHGAyhx3XjQpwSxchGCzbXDNFsH9i9NHm67B9UuAWWap9kncgVh9Ku/H9PAcliVxcmoZDzcOAEYME/Ilfwpgqr82mWm4J2HTggGuon2rYJ1CE/FVMX5k3wp/T9ZFafKOsIzKgQcA8h/nO9+T+cGTbgD5YZerDCM4NGdPFHyV+dX/p90LcWYblCL/baOJikWKKiFFym7OJMLy5r6iZKzHglubfA+s2/jJcTs3Lqh+/8hUWZIiyaFv0emtzF7XayQni49jtsxqKk62DAdWEzzSAzuDiBLTK1iRBRHAm/0uFAq8OHyIGWZPwHRQ8W56Chi5dpuf4yXeEDJ/S0Sf7gt7E8Ipm3PDw1wUHlW4UFHzugEAHL7GEiZ0+Mtp/fKiVvwYaP7JPY7cLZMqrCqc8a4s6XKwH0VJxwJisCQIRU5T0++94ASGblA1lWGKmGGjwK7LQFiD+aUSzHN2IgQ7lcDqivODrbV5/Ic1uzCF4d3Di4/3tv2xdlDcs+Puug+0A3pbXL2bXuzCFqU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7418.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943ade5f-8d47-4d0a-866b-08de266f0e6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 06:52:35.8338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZVZZ36KaxhC5jtv3WC4qFf4/WFcaZkA7yhloTb6KgCLzGQ9Q50J+n+7jLM6GR1GwQBi2ywA6GwQiMOBdSmvBRiKBHizEEXNUx+AWHyiV/+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6347

RmFpciBlbm91Z2gsDQoNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVz
LnRodW1zaGlybkB3ZGMuY29tPg0KDQo=
