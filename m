Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazolkn19010021.outbound.protection.outlook.com [52.103.13.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83903294A10
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 23:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.13.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784072090; cv=fail; b=XEg9+/DAJJP2GuDPo/+q6gixm6EITIBo8SWynNN9DKFRJzroG42G/SEg8j5u7ZqHtEqPn7hRtIweVu425VcBzEwTMQpWHke7ZGQx67IIpm0TpEKxQxQcwNELqgKfH9VMpA7SKMP/Gffcpy5a7kvkqUN1H9cpbKpJiiOybKi2kPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784072090; c=relaxed/simple;
	bh=PiUzU2bJbQfOuPTwwnP07cFK2cIr64/c23w6T7eRi5g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ot9EhfkWFMUWeSVtMgvwkL/GSvcANkuLa30e+741KKc4pajD+DoQcgUM5pkTyUcjzJcT7KnF825rhl1N+wGPq2TgsYBjmzxoWMzfTZc3DW21mPf9KEBo3lAMJ7Xo7WyYtXfEVS6wiWGQUBBSc2vD16t5KuQkIY04mdV6/WXwznI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=MVYC0GV0; arc=fail smtp.client-ip=52.103.13.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="MVYC0GV0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ue1QKOcBAQUONWa9UscVRtA90Tq7nMZeEptAHFHRS9gNfP5vTdUF0T6qMjb5xx6nWykECdQONwrroHU0ofWN2I1w8OoF7kEjgVRVmWPD97/lygUHHZONItfQaE3e15LpK5lN39kSHhVp13nT08tm/kDgkM7anDh3S2kLK9jlsMienFA4CWdb4bMYuqY6XKCwx0PL73QZW2LjGsvRlHQTupIGakgACZhiLOaZcuIc7a9ydf2/cawctNYkHNsTW9SYugP1r16S/1rtGF6qg1R+H2kQ4D8sp2hm2nGkjBX591E5VxKcS8jZUCfEWmiXeIhYVZdKqfyx2G/XcfI1JjVkpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PiUzU2bJbQfOuPTwwnP07cFK2cIr64/c23w6T7eRi5g=;
 b=L51u7yHG49WcxKoKeb5lRFfoY4q+yuahVWdLHQCcY4PISPrhOebOyKF/USKD0ps9bKpfUGHsTZ14sONfolqVzmNm6KwqKAc7wH9T7f4n80Obx6HmK5t7mjM1DR+YVZLDlAaoAUNVMpDSCHB14DSVoj4IdFxLf8fHvqvw7D0rF6pk6lye0g05ekB2Vg9ZxJiN+V0wC+VNlAI1t8wWsJwf4tVepj/YedJWvuwn9idLn2F2zys4FYXA26VBsZ68KvxSM4tmc+vE93D2decJKaRPCPthtJuV7bQrPXbembaG5E8Zb5GhQIpnM/j7FhuguCtJUwH4Yer/V6CSzB7f1nIGLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiUzU2bJbQfOuPTwwnP07cFK2cIr64/c23w6T7eRi5g=;
 b=MVYC0GV0i5dxGRDTOkRFKSNbiPmX16iGlVrgD1CoUQsAIcyjWRXXbsbOJlgoGaXiJEhpsMKXbh0qR90UbVr3txUqMVCjIdobQO+WGQP7fJ8zVf5tPtFkWokWfEEFXDoeFZ54DhhcnYQ8/9OW9/zxtDvLxeg8fzWahRnqVR7KcpWT8PtbwIzJPWj3Ew+tyY/m5F9I3ewgm4fXu32BVYmR31xtOQKknCpnOLDENKpYTmw59ymkYEzpoIp1j1g510XtmfC+kyeqzcnW8KaU37uTbsCq0WVWTPJ0Odxblzp4X631t7iB5y6omElpoOacMOkkGE2mH9VcbxikzV1/L2MQRw==
Received: from LV3PR10MB7820.namprd10.prod.outlook.com (2603:10b6:408:1b4::15)
 by IA0PR10MB6915.namprd10.prod.outlook.com (2603:10b6:208:431::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Tue, 14 Jul
 2026 23:34:46 +0000
Received: from LV3PR10MB7820.namprd10.prod.outlook.com
 ([fe80::ac73:a7f1:7727:145f]) by LV3PR10MB7820.namprd10.prod.outlook.com
 ([fe80::ac73:a7f1:7727:145f%4]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 23:34:46 +0000
From: Allen Hewes <rallenh@hotmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: healer: install targets one at a time
Thread-Topic: [PATCH] xfsprogs: healer: install targets one at a time
Thread-Index: AQHdE+dwb4bz67KUtkescNQM8kIjA7ZtqbGAgAABNIA=
Date: Tue, 14 Jul 2026 23:34:46 +0000
Message-ID: <636d61649e316a2a8978bd13282a6dc33f82e5c4.camel@hotmail.com>
References: <3681cff200496f792a9f0dfdc117c268fc5803d5.camel@hotmail.com>
	 <20260714233027.GL7380@frogsfrogsfrogs>
In-Reply-To: <20260714233027.GL7380@frogsfrogsfrogs>
Reply-To: Allen Hewes <rallenh@hotmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR10MB7820:EE_|IA0PR10MB6915:EE_
x-ms-office365-filtering-correlation-id: d3f4d21b-6fcf-459f-258b-08dee2007d57
x-ms-exchange-slblob-mailprops:
 02NmSoc12Dcj/mAxI/NGvzdUkjNASRo/MtmI/NsRwdQ43btMV5zM/EtRABuVQcoi2q0oABO2Llke78C1GYSF0Ylj/QbEk/IiYyVaNcV/z7ULeSzVxB9D/tLK0QCuD5hJtco8SOJdGTnZ1SE5dO0McivjZG5kBFcvw0rtx8BpU305cgD+m6SexzD5+a8AcI+HKgvSJFwYYKmLhYIgU46+kE6yVGV29Wpr/pkxRJCmhQZTB+Wkp/L9HhaGv7CLtlydKvmIxKeJgmY/sjg9u96aRPix1OCp95EsMLAa70BfWk85lyjtq85Pi0cGZv1Y4IO7PGmkQEqwOxaPULLE03zXzsOgjCUJ+MRdryUZxumb3/yBBJ5MTC9IWmK4E6c6r7Y4vNxYFk4PgHG/4VX8AjtEp1df0r2p7Brzpyp1+03RKqJLPKP4kGonSSWbCO78p77Mq70SwREFCpfIw1vKi/8bv7yHwR+G+DHL5r7FalOOAZyvXdvGkBM1D2KWIl1Q/dFWCbrvIdByL/S0UXMc+FSmroJqm5F7O42BhGk0wPva3JWEfaV51Ha3vYTJjylMtaKGTDqGQ/cK1XibVfbkULLyKQKNBw8ZtEP2rGjYTyVZzewnJC8xyKqMpA+csOFiuxE8NQStLXk96bsLzLVSU6rsi924uNd/m1EdWmFgpT/5Hi9pFRF6PEh2XrNiwHL9WEeLV8/reXytuy0WWI2eYpY+4ODVXM6wi9FzLKIOKiIJyGPTCwRb9tMRTk+SuDN27ba+
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|8060799015|8062599012|19110799012|15080799012|51005399006|24021099003|37011999003|25010399006|38102599003|12121999013|40105399003|102099032|440099028|3412199025;
x-microsoft-antispam-message-info:
 =?utf-8?B?dzdiZTNsQnZJaTJUME5aNFBkeC9sWC9kQm9xbWJRanJuZXdqbWQ4U0ZKK3l2?=
 =?utf-8?B?VXNhVk5YdkxzdDRJVEE4VXcySm9iRkxwSXNQeU1tZlMySkx2dFY3UXZKNWJI?=
 =?utf-8?B?SGl1WkQvMFh3QVFOL2xzUDVaai9YQ3B5ejNLRnlPcmZJaVBXMEl1SnVudzR6?=
 =?utf-8?B?Snp2WlV5Q1d0NmVrQTZ4NmMyLzM1N3ZrcmhzNFRkbHpBSlJRc1h0SzQ5MjZo?=
 =?utf-8?B?b29IWjBOWkhyVjBRY1Y3K2h1RzZ5L0xycDBsVytaTGdqUldkWGtidnhOR0RQ?=
 =?utf-8?B?Ti9lZHMveGtJNU9XYS9Na1djdzMxTU1sVTdjV2tTN3hjWktKbE0wQ1ozZ1Mx?=
 =?utf-8?B?Nkpzamt6a3crZ1VzQ2FCcE9MY2I3N3ZPTi9WaU4rN0hobEZBR3VhSlJiWC9Z?=
 =?utf-8?B?RFpoMjhZd1ArUFhxUFpEQURSd1Y4U3ZDNk1uendtVXRXSnl6T3E1dmtkekpt?=
 =?utf-8?B?bFVGYmNzeXVGVm55ZXJRUDh4eG1qSkhnbkhFWFZjWDNtNEVUeXNESGdzclZV?=
 =?utf-8?B?VHJPVERNeGcwRkFNWWViZDRrWDFSaHJleW9oT1p4V3NqWDFBYzN0VEszVmNB?=
 =?utf-8?B?d203Ty9rWFJOYjlhcTdKV3BKYUhZdFRNWUljTkhiTGdLWnpFMXNmZ2Y3Mkg0?=
 =?utf-8?B?VkoyTk51V2U0QlJGc29XdGswZHAxVlQybmdVa0dHYjBXTjBySW1rc1VuM011?=
 =?utf-8?B?b2JKTFZEZFRnQVNTV2pMRVFLREpORjUxMEl0dXVnbHlkeGZFUEczUlMyZHdh?=
 =?utf-8?B?cHYwcXNGOTBIUlZUMFBtWTc0Q2ZVSldhVnNiN2FJWEEzY1UreWMycUtQNnQ5?=
 =?utf-8?B?Si8xdk5lU29oTFVBdm81cUkrajNBMGRjcTY0bkVpeDhmTzVwcE1JM1hQeHdE?=
 =?utf-8?B?VHFxb3pzdEJqNEZIVVVrbEorSVFkekNOdGkvcVloQUZnZi9JN25HRjBZNjl3?=
 =?utf-8?B?ZGdPSk50bHpIWlIzWXJoNDJIUDdYQmVPbElMS1o0MXBHYnd4TnJ0QkRNRlFZ?=
 =?utf-8?B?VFVzUnNWczZJbWgxUGdmcUlzQm8yZGIwalJXNWJOTGF0MDFQOHFHY3F5Mmdm?=
 =?utf-8?B?TWdMR3ZiTzFNYVpqazd4MWNSWlpvcGdWT3AyczFBS1pPTUpVeGtYb3IyZ1Q5?=
 =?utf-8?B?dUMra2duZEdEd3hvT25MaWc5ZFc4RlNqOWowREtvUFhUTkoybWdaVjdTVlRH?=
 =?utf-8?B?K1lDKzVra20rT0JRS0doQUdMTC9WeCszaUtRQ1V3aFQyM00wYzArM0tQM2FU?=
 =?utf-8?B?TXU5VUpxY1J6T1NpLzNNcjlZZTlKNzE1bzV3SzlQdkN1MXhySyszUEphM0NV?=
 =?utf-8?B?R1IyYTI1QlJ6NkUxUDJWc1U4cTJIdDlDKy9ObEVORG51enkvQjNBRU1kZC9F?=
 =?utf-8?Q?zhDR1kf5PF1iZJJt0PUuF4ZxHJI31Z9Q=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U2RyMjlBNXNUbUFQZzJYNGtaQkZPUW9tNHJTL1kwaWxsZXhscTRJZDJoU3hj?=
 =?utf-8?B?cDdBUklGVVFscWtQRjI1S3g3Zno5WW0yUkM3d1NkRklJR0lxYWZmbDd2Titu?=
 =?utf-8?B?dzRiZzlFWnc5bGN1c0VsVnVObDhLUDJ4S3F6MDlaTlEyaXAvOVZ4UGRPa21i?=
 =?utf-8?B?aVMzYmpxaDMzKytlcGwrcWE3UmQ5YWQ4TWZSMk1mOVZyQndQUjNhck1QeU92?=
 =?utf-8?B?UDNxVlQxcDI5V3NaNldrWmwvdHdxUzBLOHZwcEoxUUZDWFd3UTZQV3ZZRXpR?=
 =?utf-8?B?MmhRWGJuK3BnWENFWTJPVzhHZ0dTSUlsanEyOTVBUEs1MUR6SDZLalBZQVR4?=
 =?utf-8?B?dy9PUjRKN2RFbTljVTBkVXNsWjJEQTM5ZDB1Vm8yVGRvSU5NOUNGaitoQ3J2?=
 =?utf-8?B?UEZIS3hzeFdKK3BSQ2QvLzkycDdmQnRuOVVTVjJWN1lEcS9NTFJLYmY5RW5E?=
 =?utf-8?B?ZStiYUR3cXNLQURZN3FINVZpRXRBS1ZPaW5ySTJPNzliQVlrSmRDcFdTUGx6?=
 =?utf-8?B?eXI5TE1FQU1OWHFmT0NORnh6am9zWkNmTTM2MnRGajVxYUs1S1dGeUpyVktq?=
 =?utf-8?B?MWVTWFNhVlZoaVgxOGZaSk9aMWU5MWlsNjg0Qjh0K0lBOWdnRHV0aG5PUzd2?=
 =?utf-8?B?MTZnV09kVHJkeEdieVB5TlBSTUlZalU3T3d5bFZQcW1VZERhbmtaeGlNWVBs?=
 =?utf-8?B?SEdHRGI3WDVFdTB6d2U4VldnV0ZjWXVCM29wc0RqMmcxTTdOMjN1am0wZ2s2?=
 =?utf-8?B?RWQ1anVvUVNWa2lCT1VPZjg1Tk41Z0xtQXFoTGw0OU5rNVBiWVFjbW9EbDlx?=
 =?utf-8?B?VXpONmpmeGNwQnZXKzZWYUFnL0svNDJIUktPREtaajUyemtMLy9jYnYzNXZC?=
 =?utf-8?B?a1hSc1B0TEI5a1l3Z1FYVnVKdXUrWEVFNFpoVVY5U0JMcEZCVks2MGVueExX?=
 =?utf-8?B?MGVQUDdCQWFObmtCbzhlSW05bVZhU0FSVE9QQ3V6czlUamc5UWl6STVaZnUw?=
 =?utf-8?B?bE1jazB6RnZML3VWalVLbjhtdmtaS29KaU9Rd2FiZGFDK3pFZGRHanJtQnRx?=
 =?utf-8?B?UFZIYnZRcmd6cHhrSmVxMmV6UDZNYWl3UWN3dXZlWFpsZnoxMmdIb2JRckha?=
 =?utf-8?B?MTJZTFJvZjVLSUIwelgwVXFUMmh3RG14b0tCNUlyempGd3lTWUZtYTY0MzJV?=
 =?utf-8?B?NFRlN1FUcmw1Z3lBTXUyNmZJY1lZaGxNbHRpNTM2cjJ6L1dSR3g5Q01lOTlP?=
 =?utf-8?B?a21ER3h6NjZLOXpCSExKalcxd0JOYmQvR2tUSTNHd05sTUpEYng2VXN1RW1G?=
 =?utf-8?B?djN6ZldiUmxGR1lpK3hRMHhnekVIZjV0WUxTRXlvWjA5d3ZJSGV5YURmNkpL?=
 =?utf-8?B?RTVSRldKT0MzZVpWNmFHbkdjYW4wUlljdWxqcHBWckx2YUNyVXJRNWxReXpx?=
 =?utf-8?B?TERUWXNOR3FOV3NZdDBPL3F4bmJseTVMWmVPV015VGM2c2NIYnhCZVVkc0l3?=
 =?utf-8?B?eWt3UVJuMGtQVW1UUEhDb1Uxb0lCbW9uYXdVWU9wbHZsUUlaN09Rdnp6T0FI?=
 =?utf-8?B?S1NDWGJLeUJVYWhiMHRTZ2c0eXhWdWpma25rVHhrRUFKWjM4ZXhWVkJsU1Rt?=
 =?utf-8?B?ajM4UGFubHZ0cXdhMGZTSGVOZlBpS3VmR2EwTzYzK0hHRjF0ak12NVpDM1pn?=
 =?utf-8?B?bFhjazBhMVBib21rQlRtT2J5UmRzanJQTmtybHhKNml1N2pEbFNTQTN3L2Vk?=
 =?utf-8?B?RVlGeEVUT202UU1LMnYrU2MwUlpFWHcwVmZSTG9HUGFZNDcxWjBEeWJkcW41?=
 =?utf-8?Q?t25PTCFJ/DV+/DSSWNyo2bIE+vvujEI1eYeEw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75D4E0816AB66145A8A17DCCE42E8322@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-664b6.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR10MB7820.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f4d21b-6fcf-459f-258b-08dee2007d57
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 23:34:46.3173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6915

T24gVHVlLCAyMDI2LTA3LTE0IGF0IDE2OjMwIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gVHVlLCBKdWwgMTQsIDIwMjYgYXQgMTE6MjE6MDNQTSArMDAwMCwgQWxsZW4gSGV3ZXMg
d3JvdGU6Cj4gPiBsaWJ0b29sJ3MgLS1tb2RlPWluc3RhbGwgcmVxdWlyZXMgdGhlIGRlc3RpbmF0
aW9uIHRvIGFscmVhZHkgZXhpc3QKPiA+IGFzIGEgcmVhbCBkaXJlY3Rvcnkgd2hlbmV2ZXIgbW9y
ZSB0aGFuIG9uZSBzb3VyY2UgZmlsZSBpcyBnaXZlbgo+ID4gKGl0IGVtdWxhdGVzIGNwL2luc3Rh
bGwgc2VtYW50aWNzLCB3aGljaCBoYXZlIHRoZSBzYW1lCj4gPiByZXF1aXJlbWVudCkuCj4gPiBJ
bnN0YWxsaW5nIHhmc19oZWFsZXIgYW5kIHhmc19oZWFsZXJfc3RhcnQgaW4gYSBzaW5nbGUgTFRJ
TlNUQUxMCj4gPiBjYWxsIHRyaXBzIHRoaXMgY2hlY2sgb24gYW55IGJ1aWxkIHdoZXJlCj4gPiBI
QVZFX0hFQUxFUl9TVEFSVF9ERVBTPXllcywKPiA+IHNpbmNlIFBLR19MSUJFWEVDX0RJUiBpc24n
dCBndWFyYW50ZWVkIHRvIGV4aXN0IHVuZGVyIHRoZSByYXcsCj4gPiB1bi1ERVNURElSJ2QgcGF0
aCBsaWJ0b29sIGNoZWNrcy4gSW5zdGFsbCBlYWNoIHRhcmdldCBzZXBhcmF0ZWx5Cj4gPiB0byBh
dm9pZCB0aGUgbXVsdGktZmlsZSBkaXJlY3RvcnkgY2hlY2sgZW50aXJlbHkuCj4gCj4gQWhhLCBz
byB0aGF0J3MgdGhlIGJ1ZyB0aGVuIC0tIGRpc3RybyBidWlsZCBzY3JpcHRzIHNldCBERVNURElS
PS94eHgKPiBhbmQKPiBydW4gdGhlIGJ1aWxkLsKgIGluY2x1ZGUvYnVpbGRlZnMgc2V0cwo+IFBL
R19MSUJFWEVDX0RJUj0vdXNyL2xpYmV4ZWMveGZzcHJvZ3MgYW5kIHBhc3NlcyB0aGF0IHRvIGxp
YnRvb2wuCj4gbGlidG9vbCBzZWVzIHRoYXQgL3Vzci9saWJleGVjL3hmc3Byb2dzIGRvZXNuJ3Qg
ZXhpc3QgYW5kIGZhaWxzLgo+IAo+IE9yLCBpZiB0aGF0IHBhdGggaGFwcGVucyB0byBleGlzdCBh
bHJlYWR5LCB0aGVuIGl0IHN0YXJ0cyBvdXIgY3VzdG9tCj4gLi4vaW5zdGFsbC1zaCBzY3JpcHQg
d2hpY2ggY29waWVzIHRoZSBmaWxlIHRvCj4gJERFU1RESVIvJFBLR19MSUJFWEVDX0RJUgo+IHdo
aWNoIGlzIE5PVCB0aGUgc2FtZSBwYXRoIHRoYXQgbGlidG9vbCBkaWVzIG9uLgo+IAo+ID4gQXNz
aXN0ZWQtYnk6IENsYXVkZTpjbGF1ZGUtc29ubmV0LTUKPiA+IFNpZ25lZC1vZmYtYnk6IEFsbGVu
IEhld2VzIDxyYWxsZW5oQGhvdG1haWwuY29tPgo+ID4gLS0tCj4gPiDCoGhlYWxlci9NYWtlZmls
ZSB8IDQgKysrLQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pCj4gPiAKPiA+IGRpZmYgLS1naXQgYS9oZWFsZXIvTWFrZWZpbGUgYi9oZWFsZXIvTWFr
ZWZpbGUKPiA+IGluZGV4IGUzYzQxZTY2Li40YWE1ODc1NyAxMDA2NDQKPiA+IC0tLSBhL2hlYWxl
ci9NYWtlZmlsZQo+ID4gKysrIGIvaGVhbGVyL01ha2VmaWxlCj4gPiBAQCAtNjksNyArNjksOSBA
QCBpbnN0YWxsOiAkKElOU1RBTExfSEVBTEVSKQo+ID4gwqAKPiA+IMKgaW5zdGFsbC1oZWFsZXI6
IGRlZmF1bHQKPiA+IMKgCSQoSU5TVEFMTCkgLW0gNzU1IC1kICQoUEtHX0xJQkVYRUNfRElSKQo+
ID4gLQkkKExUSU5TVEFMTCkgLW0gNzU1ICQoQlVJTERfVEFSR0VUUykgJChQS0dfTElCRVhFQ19E
SVIpCj4gPiArCWZvciBmIGluICQoQlVJTERfVEFSR0VUUyk7IGRvIFwKPiA+ICsJCSQoTFRJTlNU
QUxMKSAtbSA3NTUgJCRmICQoUEtHX0xJQkVYRUNfRElSKTsgXAo+IAo+IExldCdzIGhvcGUgbm9i
b2R5IGV2ZXIgd2FudHMgdG8gYnVpbGQgYSBiaW5hcnkgd2l0aCBhIHNwYWNlIGluIGl0Lgo+IFRo
YW5rcyBmb3IgZGlnZ2luZyBpbnRvIHRoaXMuCj4gUmV2aWV3ZWQtYnk6ICJEYXJyaWNrIEouIFdv
bmciIDxkandvbmdAa2VybmVsLm9yZz4KPiAKPiAtLUQKPiAKClF1b3Rlcz8gSSBjYW4gYWRkIHRo
ZW0gaWYgeW91IHRoaW5rIHRoYXQncyBiZXR0ZXIgZGVmZW5zZS4KClRoYW5rcyBmb3IgaGVscGlu
ZywKCi9hbGxlbgo+ID4gKwlkb25lCj4gPiDCoAo+ID4gwqBpbnN0YWxsLXN5c3RlbWQ6IGRlZmF1
bHQKPiA+IMKgCSQoSU5TVEFMTCkgLW0gNzU1IC1kICQoU1lTVEVNRF9TWVNURU1fVU5JVF9ESVIp
Cj4gPiAtLSAKPiA+IDIuNTUuMAo+ID4gCg==
