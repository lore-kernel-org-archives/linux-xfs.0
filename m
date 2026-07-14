Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazolkn19012074.outbound.protection.outlook.com [52.103.11.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4F1367B9C
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 23:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.11.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784071937; cv=fail; b=jGRo2OU61lHAEmrb7lFm0XAQaHnfr1bQEcZAorlAgiLsoqaxPXsJL0MEZr0ROWcv8U8dZkrUZs124mxqpVhO/ztxS1/XCS/gGf4YkPxxoR+0IWCw3nvg90aqFiuFa1eOkC+m+0hwUkAvjXTIh0PeWsfl2aBz7qWqd/LCbUlsTbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784071937; c=relaxed/simple;
	bh=EYkXU/hDl6Jn7s5TaYoVyf9o/jFqLgbE6zrLVbYq8s0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JoXCayBbODg8++Chv6+0b+E5tMedq+p7J+VzkHztU/4ys5Nn+dS+W+qO7GMvt+flYG+MsEil1TXU/krNhYH7F//aGRQ0HyqzR+PEP87Igf/6vyys+bYkF6wpSossypFPqWnf948CgoNzsc2EhasHUI41Xcgd61QGCuSdh2GkGyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=LqBH3bVR; arc=fail smtp.client-ip=52.103.11.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="LqBH3bVR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NqYmftb8fgMO1UJwe1OPG4Kevk5TPECwhd/1ykRczZJ5AgT/Ct1M2QxBVaMlJ5IJr/mKHPDgkcYBiY/2PbUhkVb6AljX8Bj/aU7T9OPAjUt1i9vxbMsggviDfO78gYnNaPLW+GeEViA6PAvHTL4PZpul8bLV+N+sFj8ILQUKWhsdFjDQEpU4Xxbyh4EGOpQG5KWiOY6I/bDBc6rHGLWK7zqNlR5ICDg+fdqqWUOJfm/5zE3tz7ppvUUnF0gHISUm9GFldD94sA1zY6GWaMD/nlPwFNj64P3t7i8fiy1Ca+aSRZsX5dNBT4UkiNscdzsPz7jBD2cX2oVvCZRtKIRjHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYkXU/hDl6Jn7s5TaYoVyf9o/jFqLgbE6zrLVbYq8s0=;
 b=gMNCvu8hjFVEhEUCZy7WmK/xMdsFC0VoHcXATHCW4lDvDpsRvZhvc+JK0Gj8mTcisVCjfpNzTfFte6HQK7so78l9Myjs1lwK/88yY4+qjfw77UAlvB1Z6HyM1Rq8yAqq2vfFs8kk+rNuU9pT3YmcKXMxkm1dhzS6YFCYvZiBWh4ywZ2C+ESYSbEi9MZDneLQOU6M7Q2QM6GsL4S5cgjNCjbjvaWhFRYWeVrF9Q6apM0UTzJWh0x5HS9ra3lq51pXl2Exa7dObEPTNfGJzkqf4pkbq0j8kGeVNtXn4+8RO9QcPgWlqxlapDaQRKN3PeawdPP9LEMt4rhPvPMIomLgIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYkXU/hDl6Jn7s5TaYoVyf9o/jFqLgbE6zrLVbYq8s0=;
 b=LqBH3bVRI0v9P9su4Q1EIrTJuASK++6cVMz1yZgn4+foneNaItj5l/Dmi0/gFJplODb3Nhp4f/tAH7u5NSf6bZGUOAo4ruhLZuoS4WSn1cIbj6KXAmlMyQtpUEwvpQFBZzEbP0ak4zxtHY9iFz/m36x/sKl75tCPDK7fvy7OOyQ0K4z2TpR6h7Nfw7vPVo0onSlGezSHSLTJoJtTc+ukOsDanGYpLeZ0Yq4QoSGfJRPZ1BrN2XKIGaaYhnhiET2gCUWym5WAd1rvppV0hPkNaoPxg2Hu56A3wcZcwY32sB6SLflbe3ZCJpqy1BaSOVCA50LRT3Lkh9F/H3W4SuOd4w==
Received: from LV3PR10MB7820.namprd10.prod.outlook.com (2603:10b6:408:1b4::15)
 by PH8PR10MB6289.namprd10.prod.outlook.com (2603:10b6:510:1bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.20; Tue, 14 Jul
 2026 23:32:12 +0000
Received: from LV3PR10MB7820.namprd10.prod.outlook.com
 ([fe80::ac73:a7f1:7727:145f]) by LV3PR10MB7820.namprd10.prod.outlook.com
 ([fe80::ac73:a7f1:7727:145f%4]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 23:32:12 +0000
From: Allen Hewes <rallenh@hotmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfsprogs 7.1.0 LTINSTALL fix
Thread-Topic: xfsprogs 7.1.0 LTINSTALL fix
Thread-Index: AQHdE7TPTejUzzPjlkCML9LCeL5+IrZtfB0AgAAudYA=
Date: Tue, 14 Jul 2026 23:32:12 +0000
Message-ID: <7685a0ccf2bc08ec8abe2c89161d666c7c35c6b5.camel@hotmail.com>
References: <465ea336301aafed0e392d668a23e34cca2e4324.camel@hotmail.com>
	 <20260714204554.GK7380@frogsfrogsfrogs>
In-Reply-To: <20260714204554.GK7380@frogsfrogsfrogs>
Reply-To: Allen Hewes <rallenh@hotmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR10MB7820:EE_|PH8PR10MB6289:EE_
x-ms-office365-filtering-correlation-id: 0acae891-5d90-4eab-0635-08dee20021b7
x-microsoft-antispam:
 BCL:0;ARA:14566002|37011999003|51005399006|38102599003|15080799012|31061999003|25010399006|12121999013|24021099003|19110799012|8060799015|8062599012|3412199025|4302099013|440099028|102099032|10035399007|40105399003|1602099012;
x-microsoft-antispam-message-info:
 =?utf-8?B?NmtBZitIRVY3UmxzOFVGcGJNV25TKzM2V2VTTUVEUjU1b3Rncno0WDdDQ3hi?=
 =?utf-8?B?eFYrSGg4eU4zWnpUcHN1R05vaUdUeXNQTG01YUljN3o2dFAvaS9xbUU1a3Jo?=
 =?utf-8?B?RW0zNnBuQ3drK2NkSFdYcGQyMG05UWQ3Z1ZCY2NLSXFwY0ttWDJ1UE9xUTJp?=
 =?utf-8?B?K0lEeGhhY3V2NEliU0w5dVFkQXlHWUQ2cDFsTVBrNE5WOG5DWFhKOTJPWXda?=
 =?utf-8?B?YW5mTzNITDNhRVN6T2JLV0xRUGlqNG5VTFAvbGdpRUxjYllvWkozMlJyNytE?=
 =?utf-8?B?QWhNeTkrK0szc2VsOHhoa3NkandMeVNqUU9td0lRT1IzSVVqK3dLZEwwQWFs?=
 =?utf-8?B?bG5tVXZuM1Z5dC9KdnBZV0dIM1dFN2NnZjM2NEc5d1RPVHNCMmpUTEQ4bjBz?=
 =?utf-8?B?M0YxVHJxMC9vQk5DSUtQOUVFQTg5RHZhRmFueXYwS3dYTUxzN24zNFdNTDJH?=
 =?utf-8?B?UjY2S3N2SnM1WTA1ODVGdFBqVVBZdWl0KzROd2lGYkZ1elQxMjZ6NEZkUGZE?=
 =?utf-8?B?cjhtNmhxZVNJMmpaNDBqNXVQQ3B4MGRuYURTbW5XbEZJSERZb25TYTVaUzNy?=
 =?utf-8?B?MEx5RldpVzkwTmxJanc3VXUwSWovWXNHYU9PbXFTTzJVb3JLb2xtTVE0TmNQ?=
 =?utf-8?B?am40WXFRRmZUS2dHY2lkeUlHTTRZQk1nbVVYelNBZ3V2TFhjL1Y3QktiU05B?=
 =?utf-8?B?U0hUQkFBL3g1Wk8wRGZKZEsrWGJCSnBaT1Ywd1BjSTF5enludEVlYmRZL1N0?=
 =?utf-8?B?YTU4M3UrUW9xR1J1SENyY2pqbXNOeVJ3d1NvWDVyVGNidWNrcmlaMlU3M1lU?=
 =?utf-8?B?c0tvMHU0QW96NVdoVFk1V1JjR3FLWjMzWThYcnZ1MTA3MUYyZTlQUFFpVERr?=
 =?utf-8?B?SnhsSm5KZHBlenpRdnN6VG1ESUxuYkx6eUpuU05vYnYxTFVFcys3TkkxUm9T?=
 =?utf-8?B?WUNOVGtwZVJoNWhremJQbnBBZVpTb255M3FacVJKVnJodVdEdEU5bUh4S2ph?=
 =?utf-8?B?elpaWnRmSGxMbDBoVFplU0R0TWhJVkhjOGdMVnRDdGh2SzhmVTRLVlpLWHpv?=
 =?utf-8?B?dFFiMDNpY0YwUkRyT0pINEJUTnBsQmtqeXQwY3FIK1RsNWhaOHJ1emlrVWNk?=
 =?utf-8?B?RXhkNkhkVlBYYzdHZGdzSVk0S3lXcEM0bEwxazZ6VUNyNE9WWDRNL2ZyUWQ4?=
 =?utf-8?B?M0VMSXlBQTkrT051a2xYRXNEV29zR2tmSmFJTWRRTVZWaWZkbmJwTU5oa2k2?=
 =?utf-8?B?YW9uZkpIVUtSbndqRENxQmozKzRYVHFPSVJMRXVIdThMQW10dDVYU04xQzRN?=
 =?utf-8?B?MS9RbTZTSzAwSk5wWnVIOGdEcVYyZFZtRmlTN1FEN1VSMENHRERNL0llbmNK?=
 =?utf-8?B?Q25GeW9CRVBiVitWYzNGWGtSSEp6ZXUzQjFGeUdFNm1OblZ6WDE0SHVBb2Ir?=
 =?utf-8?B?SVJHSHdNYkVLRFR0dEQ4ZUhuR0o1UDBSV1RUTnVhV3RaeC9tVmxJU3hyL0Vi?=
 =?utf-8?Q?Yxw6BvFsy3ovqwrVftevp7ryolF?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SDJ0ZE1PaWFHWG1Wd05FTllHYnRoQjJhbElvVGhOSDVXc0F1QXl3KzZhdVZi?=
 =?utf-8?B?Mno4VVFXanM1eGFVL1lUY3lwY1grT2VGcUtnMDBWMHdvWmxYSzROUm1CYUdh?=
 =?utf-8?B?TDJEd2h3bnlNSXRrYzd1V1lDcmhTK1ZYKzRuS2hiSExTZFBVYTFjOFhNcjZ6?=
 =?utf-8?B?MC9laDlWOGJweWRTYmJWMCtVY0UxK3c4ZEtjOTM3K2VGWkhiZEZNVklNc1pE?=
 =?utf-8?B?NE1TWllLRXNrcGE0UDN5aFVHRjNoRzZFTUhvY01HNy9xUzRjb01VQ2FPb2w3?=
 =?utf-8?B?L0JwM1NFWTFQYjBQOERlYmo3clNqemJvMW5YWVJ2SUJEV2FLNEZkYjYvSkl1?=
 =?utf-8?B?SGE3aFhxS0p2WUZLWGVoSG01NFhpb1JPWEJvNDJYWFNoc1BEL09XbXdzMWlI?=
 =?utf-8?B?UExhd3o2c3kxOGpPbU11WkcwTnUxdVFMMDZFcVRVeEFEWkNrZWhsTDE2MjZN?=
 =?utf-8?B?SXlXa1dYc0lSK1VWcEJKcXZvYVFubkpDekkzbDUrVTZ2aTFPYmNUZnNrdk1V?=
 =?utf-8?B?blBUTEdSQ3ZjeUg0SDNUVmwvRjlNZW1Jck44b2VzWUdrcC9iZzcvRmhGdDNN?=
 =?utf-8?B?eXY4YWlId0VtQ3NEUkkwTkRVblNqK29Sazcvck52Z1BsNGZzVU5lUklXSWFT?=
 =?utf-8?B?d1J3a3U0MW94em96ZWY2WUl6UzhSRjVidi9pVWhITG42Q3BGMHFWa3FlYUtl?=
 =?utf-8?B?UVJKNGs0QmJ0RGpLeGI4UjBYUEdoTUN0a2FvbXJtNU10dE5IZExzZjFmUTY1?=
 =?utf-8?B?T2NhUHVQOGdMVVRXZlZ6VDcxYXgwWDFuZjFETmFHcmJnSUE3WFpCMXlkQWZo?=
 =?utf-8?B?OHpiSUgzOFpUVUIwdUtFbUpXbk44TTRzdUgzNEMyakZZNW03di9RaWlqU2Jp?=
 =?utf-8?B?RWtpTld1RStpbTVxYW83RGJ5MEJZZ29VZjJFKy9iWE1FdldNK1ptMDBHRnhN?=
 =?utf-8?B?QlVhQThKZGw1QlpVWkU2RjlTWmxMTm50dVh2WFBFUHdyWlBLUWsxS3lnYTdw?=
 =?utf-8?B?bUlEZFJicjVUZjRCU3dadjNUaWdDaDdhSFR5T0MxaGhWeVRiN1hDbXQwVlpH?=
 =?utf-8?B?ejJuQTlYKzVEM2xDTjd1MVJaUGwxejVjdFFKNEQxNjlBQW9Fay9LN3ZxQjVw?=
 =?utf-8?B?U0pQY0VIT09GWUJoanF0NnNTbG44dTFhT2I0Y1d2ZlVXT0RhQ2dNVmZHcmUz?=
 =?utf-8?B?M2JLY3M4UnBxQUVHK08zVVk5UVM1cW81Y01iU0pkOHFCblhoRUtGd0hYYXJK?=
 =?utf-8?B?aGNXMHB3UEtmSzlBNmJmR0FJUGl4RmQvbkpRc1B4VldCNll4TFFWVVpZUWpF?=
 =?utf-8?B?cnNMWnNvTkxuSWtRRjF1cHpjZ1JLNVJVOTIxSDEwcTQvLzIxQlhhYVlEY3hl?=
 =?utf-8?B?cmRTNjAzbmszb2wwRS90M2VIT281ME02cFZzZ3ozbmxFWU5TMHJmQ2YvVHQ2?=
 =?utf-8?B?bzE2R2dzT0RWYnlqN2Q2U1RsWS9vN1FNU05CMHpvbDFXYlZNbkNmc2VXSDNw?=
 =?utf-8?B?NUxud2x4clFBVlppMmpabUZybCswc3hxWEliUkFhTGk5ZzZWYmxYaDdkVzlt?=
 =?utf-8?B?Z1VSWFlEZXkzblpLZmVJcUpRSEJrYUNyK0tvbWNHbU5CbnVhOUhHVFFSSU82?=
 =?utf-8?B?MFFtSy9oLzlWL1pWR0JHRXV5TzRyWTN5Yy9vN0k5NG43RzQvdGJTMUNPaUVx?=
 =?utf-8?B?bWdBbDlPWTlNZU1pZWJCellTdXREVlVPakN2ODJVM2NEcmxNWmlhamV5c2VC?=
 =?utf-8?B?SS9qeTJkYUlIZDY0OTdaMCsvalIybS8yUWFIWjVjOGsxWk9zd2pTTTl0K29B?=
 =?utf-8?Q?g1niRUoX0OJRQFVA7tSNvjlOy15ynrX0VvjVQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCA3549FFD77DA4DBC33DFB1BC14BE4E@namprd10.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acae891-5d90-4eab-0635-08dee20021b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 23:32:12.6647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6289

T24gVHVlLCAyMDI2LTA3LTE0IGF0IDEzOjQ1IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
DQo+IE9uIFR1ZSwgSnVsIDE0LCAyMDI2IGF0IDA1OjE4OjM3UE0gKzAwMDAsIEFsbGVuIEhld2Vz
IHdyb3RlOg0KPiA+IEhpIQ0KPiA+DQo+ID4gSSBhbSBub3QgYSBtZW1iZXIgb2YgdGhlIGxpc3Qu
DQo+ID4NCj4gPiBJIGdvdCBsb2NhbCBtb2NrIGJ1aWxkIGVycm9yIHdpdGggeGZzcHJvZ3MgNy4x
LjA6DQo+ID4gSW5zdGFsbGluZyBoZWFsZXItaW5zdGFsbA0KPiA+IC4uL2luc3RhbGwtc2ggLW8g
cm9vdCAtZyBtb2NrIC1tIDc1NSAtZCAvdXNyL2xpYmV4ZWMveGZzcHJvZ3MNCj4gPiAvYmluL3No
IC4uL2xpYnRvb2wgLS1xdWlldCAtLW1vZGU9aW5zdGFsbCAuLi9pbnN0YWxsLXNoIC1vIHJvb3Qg
LWcNCj4gPiBtb2NrDQo+ID4gLW0gNzU1IHhmc19oZWFsZXIgeGZzX2hlYWxlcl9zdGFydCAvdXNy
L2xpYmV4ZWMveGZzcHJvZ3MNCj4gPiBVc2FnZTogL2J1aWxkZGlyL2J1aWxkL0JVSUxEL3hmc3By
b2dzLTcuMS4wLWJ1aWxkL3hmc3Byb2dzLQ0KPiA+IDcuMS4wL2xpYnRvb2wgW09QVElPTl0uLi4g
W01PREUtQVJHXS4uLg0KPiA+IFRyeSAnbGlidG9vbCAtLWhlbHAnIGZvciBtb3JlIGluZm9ybWF0
aW9uLg0KPiA+IGxpYnRvb2w6ICAgZXJyb3I6ICcvdXNyL2xpYmV4ZWMveGZzcHJvZ3MnIGlzIG5v
dCBhIGRpcmVjdG9yeQ0KPiA+IGdtYWtlWzFdOiAqKiogW01ha2VmaWxlOjcyOiBpbnN0YWxsLWhl
YWxlcl0gRXJyb3IgMQ0KPiA+IG1ha2U6ICoqKiBbTWFrZWZpbGU6MTM1OiBoZWFsZXItaW5zdGFs
bF0gRXJyb3IgMg0KPiA+IGVycm9yOiBCYWQgZXhpdCBzdGF0dXMgZnJvbSAvdmFyL3RtcC9ycG0t
dG1wLllNd0FhaiAoJWluc3RhbGwpDQo+ID4gICAgIEJhZCBleGl0IHN0YXR1cyBmcm9tIC92YXIv
dG1wL3JwbS10bXAuWU13QWFqICglaW5zdGFsbCkNCj4gPg0KPiA+IFJQTSBidWlsZCBlcnJvcnM6
DQo+ID4NCj4gPiBJIHRyYWNrZWQgdGhpcyBkb3duIHRvIGEgcmVjZW50IGNoYW5nZQ0KPiA+IGh0
dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9mcy94ZnMveGZzcHJvZ3MtZGV2LmdpdC9jb21t
aXQvP2lkPTc5NTUxMzYyMTQxYTA1MWZhZjljM2Q1MDRmZTE4ZWUzNGNhODAwZjgNCj4gPiBhbmQg
dGhlbiB3b3JrZWQgZnJvbSB0aGVyZS4NCj4gPg0KPiA+IEl0IGFwcGVhcnMgdGhhdCBMVElOU1RB
TEwgbmVlZCBhIHNpbmdsZSB0YXJnZXQgYW5kIG5vdCBtdWx0aXBsZQ0KPiA+IHRhcmdldHMuIEhl
cmUncyBhIHBhdGNoIHRoYXQgbGV0IG1lIG1vY2sgYnVpbGQgeGZzcHJvZ3MgNy4xLjA6DQo+DQo+
IEkgZ3Vlc3MgdGhhdCBtZWFucyBsaWJ0b29sIG5vIGxvbmdlciBqdXN0IGNhbGxzIC4uL2luc3Rh
bGwtc2ggd2l0aA0KPiB3aGF0ZXZlciBwYXJhbWV0ZXJzIGl0J3MgZ2l2ZW4/ICBPciBwZXJoYXBz
IGp1c3QgeW91cnM/ICBPbiBteQ0KPiBzeXN0ZW06DQo+DQo+ICQgbGlidG9vbCAtLXZlcnNpb24N
Cj4gbGlidG9vbCAoR05VIGxpYnRvb2wpIDIuNS40IERlYmlhbi0yLjUuNC00DQo+DQo+IEl0IHdv
dWxkIGJlIGdvb2QgdG8ga25vdyBpZiB0aGlzIGlzIHRoZSByZXN1bHQgb2YgZ251IGxpYnRvb2wN
Cj4gY2hhbmdpbmcNCj4gdGhlaXIgQ0xJIGluIGEgbmV3ZXIgdmVyc2lvbjsgb3Igc29tZSBvdGhl
ciBsaWJ0b29sIGNsb25lIGlzIGluIHVzZTsNCj4gb3INCj4gc29tZXRoaW5nIGVsc2UuDQo+DQoN
CkkgYW0gdXNpbmcgdGhlIEZlZG9yYSBmYW1pbHkuIFRoZSBzcGVjaWZpYyBtb2NrIGxvY2sgd2Fz
IGZyb20gZmVkb3JhLQ0KNDMteDg2XzY0IG9uIGEgRmVkb3JhIDQzIFdvcmtzdGF0aW9uIGluc3Rh
bGwuDQoNCkkgZGlkIGNoZWNrIGN1cnJlbnQgRmVkb3JhcyAoNDMvNDQvcmF3aGlkZSkgdGhleSBh
cmUgdXNpbmcgdGhlIHNhbWUNCmxpYnRvb2wgdmVyc2lvbjoNCj4gbGlidG9vbCAoR05VIGxpYnRv
b2wpIDIuNS40DQoNClRoZXJlIGFyZSBkaWZmZXJlbnQgYnVpbGQgYnVtcHMgZm9yIEZlZG9yYSA0
NCBhbmQgUmF3aGlkZSwgYnV0IHRoZXkgYXJlDQp0aGUgc2FtZSBsaWJ0b29sIDIuNS40IHZlcnNp
b24uDQoNCkluIG15IGNhc2UsIEkgdGhpbmsgdGhlIEJVSUxEX1RBUkdFVFMgZ290IGFwcGVuZGVk
IGJlY2F1c2UgY29uZmlndXJlDQpmb3VuZCBIQVZFX0hFQUxFUl9TVEFSVF9ERVBTID0geWVzIHRv
IGNhdXNlIHRoZSBhZGRpdGlvbiBvZg0KeGZzX2hlYWxlcl9zdGFydA0KKGh0dHBzOi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9mcy94ZnMveGZzcHJvZ3MtZGV2LmdpdC90cmVlL2hlYWxlci9NYWtl
ZmlsZSNuNDQpDQoNCklmIEhBVkVfSEVBTEVSX1NUQVJUX0RFUFMgPSBubywgdGhlbiBCVUlMRF9U
QVJHRVRTIHdvdWxkIGNvbnRhaW4gYQ0Kc2luZ2xlIHRhcmdldCwgeGZzX2hlYWxlcj8gUmlnaHQ/
DQoNCj4gPg0KPiA+IGRpZmYgLU51YXJwIHhmc3Byb2dzLTcuMS4wLmEvaGVhbGVyL01ha2VmaWxl
IHhmc3Byb2dzLQ0KPiA+IDcuMS4wLmIvaGVhbGVyL01ha2VmaWxlDQo+ID4gLS0tIHhmc3Byb2dz
LTcuMS4wLmEvaGVhbGVyL01ha2VmaWxlICAgIDIwMjYtMDctMTANCj4gPiAwNzowNjoyOC4wMDAw
MDAwMDAgLQ0KPiA+IDA0MDANCj4gPiArKysgeGZzcHJvZ3MtNy4xLjAuYi9oZWFsZXIvTWFrZWZp
bGUgICAgMjAyNi0wNy0xNA0KPiA+IDEzOjA4OjE4LjEwNjIxNzczNiAtDQo+ID4gMDQwMA0KPiA+
IEBAIC02OSw3ICs2OSw5IEBAIGluc3RhbGw6ICQoSU5TVEFMTF9IRUFMRVIpDQo+ID4NCj4gPiAg
aW5zdGFsbC1oZWFsZXI6IGRlZmF1bHQNCj4gPiAgICAgICAgICQoSU5TVEFMTCkgLW0gNzU1IC1k
ICQoUEtHX0xJQkVYRUNfRElSKQ0KPiA+IC0gICAgICAgJChMVElOU1RBTEwpIC1tIDc1NSAkKEJV
SUxEX1RBUkdFVFMpICQoUEtHX0xJQkVYRUNfRElSKQ0KPiA+ICsgICAgICAgZm9yIGYgaW4gJChC
VUlMRF9UQVJHRVRTKTsgZG8gXA0KPiA+ICsgICAgICAgICAgICAgICAkKExUSU5TVEFMTCkgLW0g
NzU1ICQkZiAkKFBLR19MSUJFWEVDX0RJUik7IFwNCj4gPiArICAgICAgIGRvbmUNCj4gPg0KPiA+
ICBpbnN0YWxsLXN5c3RlbWQ6IGRlZmF1bHQNCj4gPiAgICAgICAgICQoSU5TVEFMTCkgLW0gNzU1
IC1kICQoU1lTVEVNRF9TWVNURU1fVU5JVF9ESVIpDQo+ID4NCj4gPiBJIHdpbGwgc2VuZCBhcyBh
biBhdHRhY2htZW50Lg0KPiA+DQo+ID4gVGhhbmtzIQ0KPg0KPiBUaGFuayB5b3UgZm9yIHNlbmRp
bmcgYSBwYXRjaCwgYnV0IGl0IG5lZWRzIGEgcHJvcGVyIFNpZ25lZC1vZmYtYnk6DQo+IHRhZw0K
PiBiZWZvcmUgYW55b25lIGNhbiBsb29rIGF0IGl0Lg0KPg0KPiBodHRwczovL2RvY3Mua2VybmVs
Lm9yZy9wcm9jZXNzL3N1Ym1pdHRpbmctcGF0Y2hlcy5odG1sI2RldmVsb3Blci1zLWNlcnRpZmlj
YXRlLW9mLW9yaWdpbi0xLTENCj4NCj4gLS1EDQoNClRoYW5rcyBmb3IgdGhlIHRpcC4gSSBzZW50
IGEgbmV3IHBhdGNoIGluIHcvc3ViamVjdDogW1BBVENIXSB4ZnNwcm9nczoNCmhlYWxlcjogaW5z
dGFsbCB0YXJnZXRzIG9uZSBhdCBhIHRpbWUNCg0KL2FsbGVuDQo=
