Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013088.outbound.protection.outlook.com [52.103.20.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035183CF212
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784049522; cv=fail; b=cEtHnzN9WOe2966wLBZnBW9D9kwbn7G0RmOvShPmcDXgsOTNzCgd+fLQPcnQWuZe0bXW8tcfnx6Z1PJN8W9GbXfVIZkmbtNqbOZAeUiA2ngY6Ihf/q8ieOzq6LcwTAKPBkkge3zWEMRn215eK3VJbAtwBvGmavSgKcZpSeqmujY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784049522; c=relaxed/simple;
	bh=lfhhS6m+XE88g3gnnGxKp7ZIuYlOc9ucV3FGnx8CUzg=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=FJAlbjSPJJynSv2Fl3RhGn2aYgEBk4hCKXFjCmGDd5+m2EOSHHl5ggcQtQ0FvqhyLI7rRkVPbEwS19QE2UO5QBd4pxf3vxHS+ymlNLT+4sy4tY2Ys4hhCFE5RWpf2f1Ukjl1YCuJw/srUtqBhBL1frwTtQT1pNOHD/rp2zIHzRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=gDTtwgt8; arc=fail smtp.client-ip=52.103.20.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="gDTtwgt8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l73tW2KLbzLBc47ojcUJi2dttwkJaoM1M40xBEo207Z7xruH5KJAhERoi04xpKjQcv97OVCxYSBSSlaUFRMkVzqXlkN7udUOlozkjcwsZsPuEK8LMu1Kx1F8ezvFzhgGh+Pc3bv+Od+gNO7kXYl1kCXbPOqHwJkxx1w406hLKj90DE9s9ht8y2N99kUYVnoL90YIBFOk2M7VjXdEmSddR+q6gR5a+6WRWJ3c2WeF96pgPV6grnBZBrKT/pgEdrrci5vUX9awWz5NwwzkR+dpjrhDuXJIVUTyUZdW7G/DgzVIy/yI0XDZ4eaQluPPlgaSxnVinEfoyraQlDNANhUygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTsEI8yEc961WShv2Majg1uCHsSDR44HIwJvxkPxBgs=;
 b=NKWGO2NPoSxwXOF3GiJACqYDNs1B3lmnDC21i2RkRfoLBtPz1eg7RRFYjL2u+AlnKGDVkyZiRX55nMMAgE3SF8J5Jak/19OCGpUR3z4GSgLDYgcWi3adRFdeQmssgypfAtx85cinS2rZ/6yIKHRHxn5JfCFh2bHxFS8GF21df9zlVHe8BrQ7k/sjh4Rl6qSjWpxegC9PcYbAIVu4IqqyclrVPLh2jWaqM9pMjNrPyVm629uIzun29NNt+wCtyhf45qjsnCTWpXzBnX2tqfllQu8jj/rroo2WpgG3LvEPeiv2C5Q7QwykaPICyrAlTxBxipp82D0wIXRprrYVJS+ZQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VTsEI8yEc961WShv2Majg1uCHsSDR44HIwJvxkPxBgs=;
 b=gDTtwgt8c7V/KGGxX4Pjm0OH5lckceCP8DKQoHI1alylYNe480NT6crAg/16K9mQRiimgkgxbQJZX+A3Xx4GKS+9EmDr9tH0VhLC//TBCaibYBm3uJXZc64gqToSM5Wg4rtJxLuwTh1iORatbnJsb0HVS9gBhQyFrXMtS9b86ctXrrX73c58aSD5HWvr0BFAJcupFis1iPUv8MNjMfFuruvmXQmtaVAaF+kOwMyEWz8m2HPKkxVPoSPGPgJZezx0GZD5Dci1QhoT4l8yNiHnpRKsxAmo1qitiB0uyI+BaRLtHHNsJDmNwUNkohV35Gk/jxmuW0zvJvRiMdWXLaOlJQ==
Received: from LV3PR10MB7820.namprd10.prod.outlook.com (2603:10b6:408:1b4::15)
 by BN0PR10MB5079.namprd10.prod.outlook.com (2603:10b6:408:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 17:18:38 +0000
Received: from LV3PR10MB7820.namprd10.prod.outlook.com
 ([fe80::ac73:a7f1:7727:145f]) by LV3PR10MB7820.namprd10.prod.outlook.com
 ([fe80::ac73:a7f1:7727:145f%4]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 17:18:38 +0000
From: Allen Hewes <rallenh@hotmail.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: xfsprogs 7.1.0 LTINSTALL fix
Thread-Topic: xfsprogs 7.1.0 LTINSTALL fix
Thread-Index: AQHdE7TPTejUzzPjlkCML9LCeL5+Ig==
Date: Tue, 14 Jul 2026 17:18:37 +0000
Message-ID: <465ea336301aafed0e392d668a23e34cca2e4324.camel@hotmail.com>
Reply-To: Allen Hewes <rallenh@hotmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR10MB7820:EE_|BN0PR10MB5079:EE_
x-ms-office365-filtering-correlation-id: d7bbdff6-e036-4761-c9ce-08dee1cbf19d
x-microsoft-antispam:
 BCL:0;ARA:14566002|37011999003|39105399006|6092099016|15080799012|38102599003|20031999006|25010399006|4140399003|24021099003|19110799012|8060799015|8062599012|31061999003|20055399003|4302099013|3412199025|440099028|102099032|40105399003|23121099006|1602099012;
x-microsoft-antispam-message-info:
 =?utf-8?B?TzgrZVVxd0FhWFVDUThKcSt1Qml0bjcrT09saGsxc1NsZExDLzc0anVYV0U1?=
 =?utf-8?B?VmpEcGtOL3RGS1FJeXVyNXVoN0VDWWUzekg0dDErdUxmNGVwY1Fsem5mdjJE?=
 =?utf-8?B?SU5qd29kTTMwVW42RkpvSDExa3VISnNkTnJ1RW5SaDhEMXpaSG96aGtlWEUv?=
 =?utf-8?B?cDNuaDNvdHoxZnZ3VVJIZW9GaktIb1laQ0hQRGh5enBsMnJ0VDJoWUNLUDhp?=
 =?utf-8?B?b0FpZFprVE1tRWxKUzNFR0N4elBHZWdXY3ZIaDhOZjlYUFl1NnpQS2hZOVFn?=
 =?utf-8?B?TjFEY01taVptNy9PTnduWGpsU08wdWl1eXJDUExZNytRMzh0dkM4MEtkcXAy?=
 =?utf-8?B?VGZQcEg5dlJNVGJHbmtLMjhNRmcwc1k5ZWxybmVZMHNiM2p3WDNKOVgxMW40?=
 =?utf-8?B?QllvdGo5OWVHaWNNVHNKTWlhZGlya2psMVBja013L0k3d2c4WGQ4cWdGZm8v?=
 =?utf-8?B?V0xvMm5FNElDU0hQMGlyNFBYVnk3bUlpbEZranZqOWFFS0wxeVN4QXlIdURT?=
 =?utf-8?B?SFVUKzlNQmxHdGN0Nng1cm5ZWkFHUFRNWUtMV0VpQW81aW52WHIvUjlwN3Bl?=
 =?utf-8?B?MkFCUlNqbEdRcXArQVpqeUdkRzltWm1nOGxxYjgrZ1FPY0xqSkp1NUNmb0or?=
 =?utf-8?B?dG5mK2gvcEZWd0dueW1DUHpBam1XNmV4RzYwZW1MQnRHdmw2ZGx1cmhRQkM0?=
 =?utf-8?B?dXgrQS90OXN4SjMxSjc1bHNBbHR5cXFJK2IzRHBONUpUak04ZEhvNE9MUEtt?=
 =?utf-8?B?aHlhTmlNNmJGZ2JsS2luZGNlMEJ6QUR4MDlzK3BHYnBEbUpHSkhNVkNEWVlN?=
 =?utf-8?B?d2puNHlCcnd4ZUYyWHY2K09nUE5VTC9OdHByRmNVN0xsZXFubDRCWUJMNzN6?=
 =?utf-8?B?cEVRV3VEZmQxOWtsUXJwbVBLSDkyYjlDTFJ3UHd4RGI3QXdHd1FzTENEVE1V?=
 =?utf-8?B?bFlEVWRzSWtWSjc1b0Yxa2tTbmd0R2NQQVR0RGxqRnJXM2NOWit0THJISndU?=
 =?utf-8?B?a0pOZXZoSDRrWWw4WkR5N0xXYXd1OWZrd202TS9NMlFvQS9oL2tqWVNWSVV0?=
 =?utf-8?B?dG4yNkg3aXVmbEVid3FJRTFFNE1MZDRRWGhGaWlLaXM5RTdIRS9hVnIwWFQ2?=
 =?utf-8?B?aHJyMUJxbUVIbjhBaFFMYnptbU5OWU9GTmpyeTR0YWVpQ1Fjbmt6MkRtU3B0?=
 =?utf-8?B?d0JmeVpCaTFmSjlwM0V3aHVWNktLcjNJdXM1SHNGTThpU1BIY3ViRUt1SmQz?=
 =?utf-8?B?akU0WWEwOXlPS1kwRHBWV2NJRGtvK3VISTFvR2kvOGFaNnFSclhzVG4xWlNa?=
 =?utf-8?B?b1ZWaEhuTEpINWtyOFF5WWVjM0cyVS9SLzl3VzVJVmFaNWtGZVFsc2VxQnY1?=
 =?utf-8?B?UnVGNlRSdCtxWWpZUjN1QmVlMkFvWUdBQUZNZ2hIR0JjNjhFOTdEZUlzVXpk?=
 =?utf-8?B?dVY5WUpSM1ZkL1Nyeml3ZC84eUh6N2lOS2NpdWgwYUtUMFY4eG1zWHNOQ0h3?=
 =?utf-8?B?VnVVc1oxZFRwRHRublJvZmo4WHFFWEIvZ0hMUG83TUVHeGM4YWxrZzNKd3pM?=
 =?utf-8?Q?I33ydVcD1Vklxw/f38CUQ8mzfr/Y9dG+pkWjQo6WgUD7eT?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cENNRSsxVFJuZEZweUIza2FYaTg1d2g5cTJLakFETGsrbmFPQlFGckhXdEVI?=
 =?utf-8?B?dW92L2lEQlhCMXFad0d1YU94VnJ0OFFGRGRETjdyU2Y0UUJCdkdXNVNYNTVO?=
 =?utf-8?B?UFYxWFZQTXd1S2VnSEtIWWtCNGgzT21LTTVqK3M3QVhqYXJCY0JMcjMvZlIy?=
 =?utf-8?B?WlJzRXZhVGttTjIyeDQ2STRNUHlnMVp6bFBOam8rU2ZDcTJtMnZLVTV3Ulhi?=
 =?utf-8?B?bllhRHc0M1RUaUtzdXFMVGZVdmwyYnAvN3h5RG9GU1cwT0I5QjhNUVdqQXky?=
 =?utf-8?B?ZDYzcTY3RHV0WE4zRzVMcVhWQjFRNjh4aTUxTlBNTjcreGRMMHNzVUV2YmQ0?=
 =?utf-8?B?MzFFc0xaZEFmUUQ0RGN1WWhXNEQ0a25hazZRSTMvSDB1OCs4TFBWNUFpbVgr?=
 =?utf-8?B?cEFSNVJvZDQ2RGFxbUsxakQ2UisyRlFScUtKSVdERzB0cmxwWFVrRjdJemZy?=
 =?utf-8?B?R1ZEQVVFbXFaK1VBTWh4czZxYkRSQ1hPY0kwS2FSOHNKcUtMdi9nc2szOXhw?=
 =?utf-8?B?U0tPUWlxc3ZqRVk3Y052dGJSQXNsYnA4N3pxYUJ6Vkg0NmxKUFNXSkhFN25s?=
 =?utf-8?B?aDQzVWxmaWhZV3ovTkZWSmRpeHZ2YlJlS2tsdWdsV0ZWM2lRd0NlN3dVQnVC?=
 =?utf-8?B?UEF3Vm9ZMmlBL1lrR0w2VzNlM1ZTbUlRMlJocDZHQ085bTJrSzFXMXhoMVBo?=
 =?utf-8?B?RE9yRGNRMXRoUk9BNmY0QWxtTlV6SUVIY3hWVmI1SzhrSTMrNlFrNktXcjFu?=
 =?utf-8?B?dk51N2FPU3BRR2ZSMUJ5dUxlYnAzcms4ZjBjaXJycE9YUncxRjBrd2F3TVVp?=
 =?utf-8?B?alVDU3l0enNaSlRzR3lQZ2NtUnF4cDZCR3phSzBnUUlZblZxcTVXYWJzb0FG?=
 =?utf-8?B?bDZUOVptYTRBZDJraDEzT2p5WFBoWk9OOVFDYlduQTJCM3ZidC9jQUVDVS9Z?=
 =?utf-8?B?TGw2UXltbUI1Z082RDJBTCtzWldoRGU3c2VEdkx1cXEvUUpsRTkzUDFuc0cr?=
 =?utf-8?B?NW1aM0ppZzJmRVNHZFR0Vi8rc2I4dDMrR1BNM1pPRlBkNno3L2doNzI5VXpq?=
 =?utf-8?B?RERqSU9oTXlPOHFWOUNtQzFKRjdLYWZ1UFZzTDVXSllRekN3VWtvYmV6YVYy?=
 =?utf-8?B?U0sybmh1M3BOblRoejM0WTdvSytHd3AvbEtONUd5S29ld3hqK2xrYWZqZS93?=
 =?utf-8?B?Y01jUlcrMmIzQWxTRjJ3SFNYRko4V0VRRlUxUHk1ZHBYRGtlNDNYVnZsdFlk?=
 =?utf-8?B?UVNCUmlteEFOWXViZXdDNW1mZ1ZTVHBqcEtLOVRRdHJqKzNOQVkvVTE0S3BS?=
 =?utf-8?B?N2c0SVhaVEQ3Nm9iSmx2WjVjQ3NmSlc3WXNCdS9XOGlqbnlOb3ZpN2lnVkRp?=
 =?utf-8?B?L05FVkp5RjRDS0QyTlVabFZVS1l0NzBNZmoxM3MvZjdIQUlyQTYxbmo1OHlE?=
 =?utf-8?B?NVpwUktOMlduaFFadmlpV0s0c3JxVE51azRLbkFlVGRsWXpzeGo2ZGhqMDlL?=
 =?utf-8?B?K251dllnRzl5d2dUUFRBd0VXU2hxb1NoWHljbWgvV0twb2tmTG1maDRaQ3hC?=
 =?utf-8?B?bjJ5Y21FSnFQQmJFOHhwMmhnR0tMTGNOMXpmR0ZnQzVkK0JrUXhWV3lJeHFB?=
 =?utf-8?B?ei81SXdxNFNES25UU1cxQkxKc0l5VEdxNFIyUi9mbDBRV1VhalRpa1NjQVdv?=
 =?utf-8?B?YVlneFlIZXdFUEVkZUtseEtaZkYrWnBYQ08rM0plQVBFcHdZeHM1UTI4ZnBa?=
 =?utf-8?B?S3I5azcwWHZHSmdXa3NYbjljQUhhemNjQldLR0M0SGp4M0Yrd2wyMmxWRE1D?=
 =?utf-8?Q?VGyErRHDDJVXFo3APbm7zCoBkOez4HRjdIMmg=3D?=
Content-Type: multipart/mixed;
	boundary="_002_465ea336301aafed0e392d668a23e34cca2e4324camelhotmailcom_"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d7bbdff6-e036-4761-c9ce-08dee1cbf19d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 17:18:37.9481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5079

--_002_465ea336301aafed0e392d668a23e34cca2e4324camelhotmailcom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C8D787106C5EC4D8D542C7C9693B1CB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64

SGkhCgpJIGFtIG5vdCBhIG1lbWJlciBvZiB0aGUgbGlzdC4KCkkgZ290IGxvY2FsIG1vY2sgYnVp
bGQgZXJyb3Igd2l0aCB4ZnNwcm9ncyA3LjEuMDoKSW5zdGFsbGluZyBoZWFsZXItaW5zdGFsbAou
Li9pbnN0YWxsLXNoIC1vIHJvb3QgLWcgbW9jayAtbSA3NTUgLWQgL3Vzci9saWJleGVjL3hmc3By
b2dzCi9iaW4vc2ggLi4vbGlidG9vbCAtLXF1aWV0IC0tbW9kZT1pbnN0YWxsIC4uL2luc3RhbGwt
c2ggLW8gcm9vdCAtZyBtb2NrCi1tIDc1NSB4ZnNfaGVhbGVyIHhmc19oZWFsZXJfc3RhcnQgL3Vz
ci9saWJleGVjL3hmc3Byb2dzClVzYWdlOiAvYnVpbGRkaXIvYnVpbGQvQlVJTEQveGZzcHJvZ3Mt
Ny4xLjAtYnVpbGQveGZzcHJvZ3MtCjcuMS4wL2xpYnRvb2wgW09QVElPTl0uLi4gW01PREUtQVJH
XS4uLgpUcnkgJ2xpYnRvb2wgLS1oZWxwJyBmb3IgbW9yZSBpbmZvcm1hdGlvbi4KbGlidG9vbDog
ICBlcnJvcjogJy91c3IvbGliZXhlYy94ZnNwcm9ncycgaXMgbm90IGEgZGlyZWN0b3J5CmdtYWtl
WzFdOiAqKiogW01ha2VmaWxlOjcyOiBpbnN0YWxsLWhlYWxlcl0gRXJyb3IgMQptYWtlOiAqKiog
W01ha2VmaWxlOjEzNTogaGVhbGVyLWluc3RhbGxdIEVycm9yIDIKZXJyb3I6IEJhZCBleGl0IHN0
YXR1cyBmcm9tIC92YXIvdG1wL3JwbS10bXAuWU13QWFqICglaW5zdGFsbCkKICAgIEJhZCBleGl0
IHN0YXR1cyBmcm9tIC92YXIvdG1wL3JwbS10bXAuWU13QWFqICglaW5zdGFsbCkKClJQTSBidWls
ZCBlcnJvcnM6CgpJIHRyYWNrZWQgdGhpcyBkb3duIHRvIGEgcmVjZW50IGNoYW5nZQpodHRwczov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vZnMveGZzL3hmc3Byb2dzLWRldi5naXQvY29tbWl0Lz9p
ZD03OTU1MTM2MjE0MWEwNTFmYWY5YzNkNTA0ZmUxOGVlMzRjYTgwMGY4CmFuZCB0aGVuIHdvcmtl
ZCBmcm9tIHRoZXJlLgoKSXQgYXBwZWFycyB0aGF0IExUSU5TVEFMTCBuZWVkIGEgc2luZ2xlIHRh
cmdldCBhbmQgbm90IG11bHRpcGxlCnRhcmdldHMuIEhlcmUncyBhIHBhdGNoIHRoYXQgbGV0IG1l
IG1vY2sgYnVpbGQgeGZzcHJvZ3MgNy4xLjA6CgpkaWZmIC1OdWFycCB4ZnNwcm9ncy03LjEuMC5h
L2hlYWxlci9NYWtlZmlsZSB4ZnNwcm9ncy0KNy4xLjAuYi9oZWFsZXIvTWFrZWZpbGUKLS0tIHhm
c3Byb2dzLTcuMS4wLmEvaGVhbGVyL01ha2VmaWxlICAgIDIwMjYtMDctMTAgMDc6MDY6MjguMDAw
MDAwMDAwIC0KMDQwMAorKysgeGZzcHJvZ3MtNy4xLjAuYi9oZWFsZXIvTWFrZWZpbGUgICAgMjAy
Ni0wNy0xNCAxMzowODoxOC4xMDYyMTc3MzYgLQowNDAwCkBAIC02OSw3ICs2OSw5IEBAIGluc3Rh
bGw6ICQoSU5TVEFMTF9IRUFMRVIpCiAKIGluc3RhbGwtaGVhbGVyOiBkZWZhdWx0CiAgICAgICAg
JChJTlNUQUxMKSAtbSA3NTUgLWQgJChQS0dfTElCRVhFQ19ESVIpCi0gICAgICAgJChMVElOU1RB
TEwpIC1tIDc1NSAkKEJVSUxEX1RBUkdFVFMpICQoUEtHX0xJQkVYRUNfRElSKQorICAgICAgIGZv
ciBmIGluICQoQlVJTERfVEFSR0VUUyk7IGRvIFwKKyAgICAgICAgICAgICAgICQoTFRJTlNUQUxM
KSAtbSA3NTUgJCRmICQoUEtHX0xJQkVYRUNfRElSKTsgXAorICAgICAgIGRvbmUKIAogaW5zdGFs
bC1zeXN0ZW1kOiBkZWZhdWx0CiAgICAgICAgJChJTlNUQUxMKSAtbSA3NTUgLWQgJChTWVNURU1E
X1NZU1RFTV9VTklUX0RJUikKCkkgd2lsbCBzZW5kIGFzIGFuIGF0dGFjaG1lbnQuCgpUaGFua3Mh
CgovYWxsZW4K

--_002_465ea336301aafed0e392d668a23e34cca2e4324camelhotmailcom_
Content-Type: text/x-patch; name="xfsprogs-7.1.0-ltinstall-fix.patch"
Content-Description: xfsprogs-7.1.0-ltinstall-fix.patch
Content-Disposition: attachment;
	filename="xfsprogs-7.1.0-ltinstall-fix.patch"; size=564;
	creation-date="Tue, 14 Jul 2026 17:18:37 GMT";
	modification-date="Tue, 14 Jul 2026 17:18:37 GMT"
Content-ID: <880592F3910AE743A6508C8D14279687@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64

ZGlmZiAtTnVhcnAgeGZzcHJvZ3MtNy4xLjAuYS9oZWFsZXIvTWFrZWZpbGUgeGZzcHJvZ3MtNy4x
LjAuYi9oZWFsZXIvTWFrZWZpbGUKLS0tIHhmc3Byb2dzLTcuMS4wLmEvaGVhbGVyL01ha2VmaWxl
CTIwMjYtMDctMTAgMDc6MDY6MjguMDAwMDAwMDAwIC0wNDAwCisrKyB4ZnNwcm9ncy03LjEuMC5i
L2hlYWxlci9NYWtlZmlsZQkyMDI2LTA3LTE0IDEzOjA4OjE4LjEwNjIxNzczNiAtMDQwMApAQCAt
NjksNyArNjksOSBAQCBpbnN0YWxsOiAkKElOU1RBTExfSEVBTEVSKQogCiBpbnN0YWxsLWhlYWxl
cjogZGVmYXVsdAogCSQoSU5TVEFMTCkgLW0gNzU1IC1kICQoUEtHX0xJQkVYRUNfRElSKQotCSQo
TFRJTlNUQUxMKSAtbSA3NTUgJChCVUlMRF9UQVJHRVRTKSAkKFBLR19MSUJFWEVDX0RJUikKKwlm
b3IgZiBpbiAkKEJVSUxEX1RBUkdFVFMpOyBkbyBcCisJCSQoTFRJTlNUQUxMKSAtbSA3NTUgJCRm
ICQoUEtHX0xJQkVYRUNfRElSKTsgXAorCWRvbmUKIAogaW5zdGFsbC1zeXN0ZW1kOiBkZWZhdWx0
CiAJJChJTlNUQUxMKSAtbSA3NTUgLWQgJChTWVNURU1EX1NZU1RFTV9VTklUX0RJUikK

--_002_465ea336301aafed0e392d668a23e34cca2e4324camelhotmailcom_--
