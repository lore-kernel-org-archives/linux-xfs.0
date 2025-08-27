Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazolkn19011029.outbound.protection.outlook.com [52.103.14.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AEE29A33E
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 10:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.14.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756291922; cv=fail; b=hKG9Cp/l1j8bX4iQYZ6Ec/lBiJ1Srt5Q/AkcnsUI/J7JWppyAimC0GbHAX7ovs/0RYGDFkdPqH/B+V6ch7TfWnzA2mWNxEinAIVJkGDVsmnh1bm9i9OUv/Am/beuUVX5pS/+eJkFcAwUFZl3pn5xT4752xxGbAi+Se8SpfHbJP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756291922; c=relaxed/simple;
	bh=hncGkS6UjwOu9HGWsiuDmCmqzZEwEDwpLN9cUl3KhE8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OT6AdqlyzkxDBDsI4Msj9BobXXe+JfTBVzTKdYaSrPvOn9N1JFyL9hkwZyOoEIt4b/Yv07rkWLihBkeKYJgS4otEEiAieSlF9Y4O3eHxC1sdCAwIhY4LmL/f81Cfiot6xVSYBHaDB0JDhxCQa/BI8JH0NyGPqLTKu8aogBj6VJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=CC3p1jBy; arc=fail smtp.client-ip=52.103.14.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="CC3p1jBy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=peUwtZYASSQ4rddeFpPcvs1SpnZ+lSCQ2WSaRejcQWLlGmVPr9LRu1oLIbG8qkXsJwv2/NECKVub9FhgfK5McSHMjJbE9OZMyEJvRG+W1bZWrKEIZaQiYwOVfpdHCqVAAVtt/JapIiPh1nJKd0CT8kx/QP56lV6ff2RBiUGnhyvd9OjUnUIOtXLqUS9iRAKuQVbSaRe6VJpacolEXBblYeTXi9WAIew+LEt/zGFL5Fn8Whusd/B9Z8BSWTb63WzUs2xzvW1DfX8NQ0UEONtCOlE6FXPCG4EnGssfv1/wBZ37JWBDkOslzK+l2wKDNargphuJ3T3Ca+bw5eU0cFNyEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQULX5UvgewkF3jn0Z4V1DuIkUFxE3JmCt3PIAwZc70=;
 b=jE3x8hBqJEXpymRpRF3OTq8oGMOQZqsmdKT1isgcdvT0fGCZnReheM8RLexDmgFSYppioJFvv8BvD74IWpkU4Exsxr+uOqiUhPb1f1/mSkjdr3/JiSlemGrLHox0+sv6VeKLfL2irTPhe1inwjT9t4MomyNjFlAc7zSE7su5etKEesUPEA4EsRjLQ4p7/kCeZPf6JhjaWXMh+s3j6D8D+03Ti52n09Srb08Cy13Uo9T4H2Ar89SWqzv7H2Up+TqMd3OIAFAqollq92hbctw5I7Qq89MaCFAA1YSWjMu+IpRimx6DJf2q2C7w4M0b/EBpFJ3SV7/VYk4Mubun3jLBVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQULX5UvgewkF3jn0Z4V1DuIkUFxE3JmCt3PIAwZc70=;
 b=CC3p1jByJ30J/g9BvwEQpmEf9yPNO3JRb4WEdaQu3I/MIWHo47QHiMc6Kku7OYhGoZii6vEAMPMANbHxVTZW1EfOU+5gBaPuQamG50VXlvvElPVmc6LJoA8TGDG4cJMhk1fTsKxhKC4gYrzF1yBCV9Qd86ISiwUN+7KXwjovp5grfywN0ETy9YO9skNh8cd+wNKiDA45ymA/MJ23L6salXAgYm5akMpVA8ZVnttDigOm+0Gjjim9k0PqGI5lATtq1v1gh69JlZm1afebQEtVg1JN+M0I46fSciTWAnSMFpTJVCFXKMiIUz9POG9TqCV1rKpnLJViVZY83Q7Tci9oGg==
Received: from IA0PR05MB9975.namprd05.prod.outlook.com (2603:10b6:208:408::13)
 by BY3PR05MB8561.namprd05.prod.outlook.com (2603:10b6:a03:3cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 10:51:57 +0000
Received: from IA0PR05MB9975.namprd05.prod.outlook.com
 ([fe80::61ae:deb3:28b6:f1f7]) by IA0PR05MB9975.namprd05.prod.outlook.com
 ([fe80::61ae:deb3:28b6:f1f7%3]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 10:51:56 +0000
From: "hubert ." <hubjin657@outlook.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Topic: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Index: AQHb/VadxSWI8qLMGkSlUABnC3FxxLRDxpcAgAoR9+KAGtxzMIAKen+AgANVmD8=
Date: Wed, 27 Aug 2025 10:51:56 +0000
Message-ID:
 <IA0PR05MB9975ADAF48C73797473737BEFA38A@IA0PR05MB9975.namprd05.prod.outlook.com>
References:
 <f9Etb2La9b1KOT-5VdCdf6cd10olyT-FsRb8AZh8HNI1D4Czb610tw4BE15cNrEhY5OiXDGS7xR6R1trRyn1LA==@protonmail.internalid>
 <CH3PR05MB10392E816C6A1051847D214A2FA59A@CH3PR05MB10392.namprd05.prod.outlook.com>
 <6tqlc3mcf3ovkbzf4345m7oztoeagevfycpdnxizrtdbhq53p2@mrlmjhs6n7gy>
 <LV3PR05MB104071E0D6E7CAD06C7728DACFA26A@LV3PR05MB10407.namprd05.prod.outlook.com>
 <kZ0Ndjz5Uh9rHFbs-iYYoEFNVWoxMtkvK-3nrx6mrlxpglTxelNWuY_lqxKmfrItAPWl4M4ng-BzenCqcFiOaA==@protonmail.internalid>
 <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <gjogpxo65cozoccj4fps6e4fzeu4ncibeofymhkyzys4hsclzy@vvrl2kndu7k6>
In-Reply-To: <gjogpxo65cozoccj4fps6e4fzeu4ncibeofymhkyzys4hsclzy@vvrl2kndu7k6>
Accept-Language: en-US, es-AR
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR05MB9975:EE_|BY3PR05MB8561:EE_
x-ms-office365-filtering-correlation-id: a92cdc53-4b2c-4ab4-c0c0-08dde557bdd0
x-ms-exchange-slblob-mailprops:
 BP6inkMtVg6LAHfS30ER1y2rwKfH1k7lf8lHxjNC8ccWuciwhupuEST1HlNSLN5Yq00rxokEe5KorhVs/TUhu5oR3cB+pZvTuTBpmiP4lVhourthe2vaYxbOEgo4lCvP8kuKmABGph1l7TgHMP96n2nK4DVwA2GEwmIEbZ1wAcU7S0F13ZbUXuHstC+S7JGqW+3h1ebjSr7mDFUnf8CMsCAhVF5cOOLt+C9qYrjMQoVhk9Rn0LV8/WyZpuGirFLOUxWsY6sKzshpwv188wwBV5izhSMl8tjFgeEfi2NgWmdtpi+SpyyTj0X65IrslYRUsF/66iRWuybmHpuGvHqwr9ci1TS+hb3Oc9xLUnGxpNuLIZZFrAeGNzwV//ksQs4llhy3/rCm4OyeEz/kXLG4lBlP0mYpyS/S7brzhoZnnL/hFDmqd8UTTSNbOYR+T8H1GE2C9sMMGhB+TCgJTPXVKL+hwT//SCmmAWxBGRkKgcFMR589ej4FWQ26F/edjNLXUt7acMgyM9mvdz3Bz2PBL4fdsBneShujqZy5bu9VeEieVZz/r97tn4niUl3lh3YNZfBAYyZqnkxuMlcZyyltvhcgyGh1C+HMpRRswRfPlekkq8JdRPuamnObbGzg3xkkaxlhTG7JT2b9SzbVL/Xkt1vrLJKs4l2J2B5Iz3XBOteFSl5HVmUJ/kejW1zd+aCR7KQQ/T3juXPVMAgnNmeLKSCo9I2FfMus+6YVGKHWkpA/Y7/iojCuguFxm7ndbvsC2zL9hPEXqTre6AW2Yf3olNM9tzcIlyQbfpT6bO1IVFAzA59utbeCbZi1/1n/BREj8KcsxmUaoIzp1T9nTbUgB+KKwtqAGA6VCldD7ZVf6NE=
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|15030799006|15080799012|461199028|8060799015|8062599012|19110799012|10035399007|440099028|40105399003|3412199025|102099032|12091999003|26104999006;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?4apCuR4yB39WyMeMon51sayHWtmaN3ghIoTk5PmPhyQeB3n/YEN3yWmnfG?=
 =?iso-8859-1?Q?ueyDwTzLEXvr8ajTytvozeqmck4zskzEmUs5uaIYWsiPQSJRARzBcfmaZ0?=
 =?iso-8859-1?Q?0ay9h1uoQ5BOZnrKBdIrys4k7xOhsUyajiI55s2wtiblzycnjb8ponDYol?=
 =?iso-8859-1?Q?DE0UYY9qBqCz/dsoPL4whFH16ejJcQ+TJLlKhSaMBMsnpKSu9JCSiN8iXH?=
 =?iso-8859-1?Q?A+IPcsW1qKwMWhEeeD0hBrvp5NEF9hHQMYRTynnd2JLcjhykaQY9dwMmOn?=
 =?iso-8859-1?Q?jzrqGm4Yy4bQ4YtjB+WXaU4wV7pPdUPywutOZPsKBuDUYj83onq6aCaMjU?=
 =?iso-8859-1?Q?/Tk+6cbp7VZzuQeBm6kFeLEaLQ1tFMkkxrU0xBf1bs/hm8ZFIPy1s6uTP2?=
 =?iso-8859-1?Q?+8btTtnjaAWufQD1LVQ9Oy4Xm4a86AMJ4yZvPFxl6Bm8vENrmIGYBvMuwA?=
 =?iso-8859-1?Q?DTaa7JDz7/v0hSuPKC96bNwcK5CB2LeicBh5a0erH8gH5I2xUrNeOsUuH8?=
 =?iso-8859-1?Q?SpsOutEv4d5KlO0PlnqDDAQZXJ+tMNvJeNgA9XGESNRgGbcigy7rUFNnN0?=
 =?iso-8859-1?Q?IAsYrplV3j1tGJuKw+OXhXQddAZ7fp++zFHsq+lWRUpEha9D6/QDsMDnnL?=
 =?iso-8859-1?Q?js1L9cvk353jXUAqDMMSLVxQo8x109O5WKb4PhKRKIwVMnDY6zxZc5uYVX?=
 =?iso-8859-1?Q?p8JphK+lM3nCEjtH2CmIfVSx2LsB39aFIy/AdO0mDtSDM6Q5kxvdiHw63Z?=
 =?iso-8859-1?Q?tTI8BChXvdMyfwMH5Ps0R6PDW22S5imx6nYIV0Fv6SKlZx/asHCnbKwRRQ?=
 =?iso-8859-1?Q?YgmZYtoOAdsY1H9DJPlTYHAF0ZpdLT0nkSSTsIn6PD0SqKhPjUJ/tciDns?=
 =?iso-8859-1?Q?fH24mEw7sPz4a6kgrnzlHYPqJMUFfiLyR8LM8jF4NdL7jfNPaALWjl24Rq?=
 =?iso-8859-1?Q?wzrA0YFRN+hhrRcDzJHf/+jCrn+6asq++41F1Er3RMZ+EtnnjLurIIN0qR?=
 =?iso-8859-1?Q?hUgb2ODphCQ8hCvCZ1zYc8UoeiC7oP07rIX4PzKUr3WSwKivzRu6SDMaJB?=
 =?iso-8859-1?Q?Hb/URoCRkEJEbSv/fzZjDUlK5EKZ4jao6L2+DkHCLT9lHr1sGQSJJaGrtW?=
 =?iso-8859-1?Q?W4A1cdD7hGOCshYUY8immufIXD3M1pyHKN4NJTJi0N/cuk9LDU4wVGSHa0?=
 =?iso-8859-1?Q?1v48sj3ogUSf4lWfY+CV+JDzWzoSDnD1WNM2CHR+AE2q+ss3+iLMN33rOs?=
 =?iso-8859-1?Q?7V1wG9C6b6IuJhtbJNNQJuHznpYK4BZLfmpb6wzrVpnGfjwHVma/5KiIqg?=
 =?iso-8859-1?Q?QMlQ8WAGiDPYV3TuQoLRKo0VXAiNLlnd8fbTKB9FzeSZT/eU17uKAHfeOu?=
 =?iso-8859-1?Q?0mrzMRYLty?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?OxZzVYYZa9qOqSlAqNfNLCh941ueJeB9dSudOaR+SPqcb2EPV7UsxVgTst?=
 =?iso-8859-1?Q?pECyPbOBuY3mRvFnsRl+6Jqkw49cg/dYLIx7hcNvG332IYGf2+1LsV2rpy?=
 =?iso-8859-1?Q?bU7xwcNyUf/UGaTUgYd8oY66DWdxjpdSVe48HoJmLsdK4yFcI32uvjAtYr?=
 =?iso-8859-1?Q?CFDjAJYZ/EzSe3fgoV5o86T5JWRb6mFJ8Nr2j2Povs0M9AEvOElqTahFHe?=
 =?iso-8859-1?Q?0kXz5TjEWrDwFyxn375wx9aoCUWaehNieokyhJdSmyVWMuLfUjvyn5dlpP?=
 =?iso-8859-1?Q?o4IEICJREfzBWZaVO48FsMgfv09hB/KFR0KCEQ11OLycKPmEoFtrUWj2hC?=
 =?iso-8859-1?Q?Wyzipsg25SO6iG+7rCe1BPi41jWhTLW3P0OgGXOxtzjVy9T8hwAeW26EU+?=
 =?iso-8859-1?Q?6TJj+WNKF00CvCkMpQ47b8NhNg8HmTFH1JdTaHqQmQ10vMrOpIVxD5r7i7?=
 =?iso-8859-1?Q?HW+fxHzDltbi/OwtEVk5+8gxvLrprRYZMb0MENJy82ERgz1M6MCAoZZIpM?=
 =?iso-8859-1?Q?rxjIpABCXurOnBcNBmTD9hayj9FEl6Ne5LD3uoC/H6qh3AxXSX2I1/P8r1?=
 =?iso-8859-1?Q?uDZALTSlSTorARtS9B1bjdie04KF2rkKMjMKruA8ULzVGYyfNAhxbIfvDP?=
 =?iso-8859-1?Q?SvAzuEz7bYAzskd3eTNstR8jJcSl5bRJPiILN6LUdvKWcRroKi6TDiP7hN?=
 =?iso-8859-1?Q?ergjQWyMdWwsA+0iYApQGxgEzkw0B3mfdHxZYyOt3t+veR/nG2IXlNy/D1?=
 =?iso-8859-1?Q?FWFRbybkglmJWucBCAzKvHTFoNWYXAm3qnGjS1SJxNMVbI0ioKvcv9SvHo?=
 =?iso-8859-1?Q?fWORYX7eZTwFBMN2cZEltP7GnqFfYE6eY3/roQTNiDnqsVsLrToVbga5kt?=
 =?iso-8859-1?Q?DlGSSES/XZp9/MovF1tvJP+j8kTWLDQajiPLYmt9hfTwVKuUPLYJtEMu8m?=
 =?iso-8859-1?Q?ISVBcdKdkjY9CHnT9+arrxg/X4LDqzK2zG2qgjOB2HOgbf7v5jVrGGMfQd?=
 =?iso-8859-1?Q?f4VS16gviOF5zDOZxwV9gq2acxvs4S5kn59AcIU+SEgH2KI35lBXh07S9b?=
 =?iso-8859-1?Q?ohp+38OmDwCoGaspFePa0CKv1dSxfDGJujABg7/lgndgaOQMgLe3HI1vm1?=
 =?iso-8859-1?Q?XkNPkfa4bKBKC1dySMXraRnUKoUP/oz4N4ju0jBjyVnjgPtjN29J/Y5vTB?=
 =?iso-8859-1?Q?uacKiYqgdzqcu0tgJ7UZgW9k7cAHgf+l3KaWzYCHftOp+jS8SjsgvW7KS/?=
 =?iso-8859-1?Q?DrTnRsFjjnUDct6Gc87lSEAe1WD3OSwIHdNw9Uvkc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR05MB9975.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a92cdc53-4b2c-4ab4-c0c0-08dde557bdd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2025 10:51:56.5633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR05MB8561

 ________________________________________=0A=
> From: Carlos Maiolino <cem@kernel.org>=0A=
> Sent: Monday, August 25, 2025 09:51=0A=
> To: hubert .=0A=
> Cc: linux-xfs@vger.kernel.org=0A=
> Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1=
=0A=
>=0A=
> Hello Hubert, my apologies for the delay.=0A=
No problem, Carlos, I'm also juggling several things, thanks for the follow=
-up=0A=
=0A=
> On Mon, Aug 18, 2025 at 03:56:53PM +0000, hubert . wrote:=0A=
>> Am 18.08.25 um 17:14 schrieb hubert .:=0A=
>>> Am 26.07.25 um 00:52 schrieb Carlos Maiolino:=0A=
>>>> On Fri, Jul 25, 2025 at 11:27:40AM +0000, hubert . wrote:=0A=
>>>>> Hi,=0A=
>>>>>=0A=
>>>>> A few months ago we had a serious crash in our monster RAID60 (~590TB=
) when one of the subvolume's disks failed and then then rebuild process tr=
iggered failures in other drives (you guessed it, no backup).=0A=
>>>>> The hardware issues were plenty to the point where we don't rule out =
problems in the Areca controller either, compounding to some probably poor =
decisions on my part.=0A=
>>>>> The rebuild took weeks to complete and we left it in a degraded state=
 not to make things worse.=0A=
>>>>> The first attempt to mount it read-only of course failed. From journa=
lctl:=0A=
>>>>>=0A=
>>>>> kernel: XFS (sdb1): Mounting V5 Filesystem=0A=
>>>>> kernel: XFS (sdb1): Starting recovery (logdev: internal)=0A=
>>>>> kernel: XFS (sdb1): Metadata CRC error detected at xfs_agf_read_verif=
y+0x70/0x120 [xfs], xfs_agf block 0xa7fffff59=0A=
>>>>> kernel: XFS (sdb1): Unmount and run xfs_repair=0A=
>>>>> kernel: XFS (sdb1): First 64 bytes of corrupted metadata buffer:=0A=
>>>>> kernel: ffff89b444a94400: 74 4e 5a cc ae eb a0 6d 6c 08 95 5e ed 6b a=
4 ff  tNZ....ml..^.k..=0A=
>>>>> kernel: ffff89b444a94410: be d2 05 24 09 f2 0a d2 66 f3 be 3a 7b 97 9=
a 84  ...$....f..:{...=0A=
>>>>> kernel: ffff89b444a94420: a4 95 78 72 58 08 ca ec 10 a7 c3 20 1a a3 a=
6 08  ..xrX...... ....=0A=
>>>>> kernel: ffff89b444a94430: b0 43 0f d6 80 fd 12 25 70 de 7f 28 78 26 3=
d 94  .C.....%p..(x&=3D.=0A=
>>>>> kernel: XFS (sdb1): metadata I/O error: block 0xa7fffff59 ("xfs_trans=
_read_buf_map") error 74 numblks 1=0A=
>>>>>=0A=
>>>>> Following the advice in the list, I attempted to run a xfs_metadump (=
xfsprogs 4.5.0), but after after copying 30 out of 590 AGs, it segfaulted:=
=0A=
>>>>> /usr/sbin/xfs_metadump: line 33:  3139 Segmentation fault      (core =
dumped) xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1=0A=
>>>> I'm not sure what you expect from a metadump, this is usually used for=
=0A=
>>>> post-mortem analysis, but you already know what went wrong and why=0A=
>>> I was hoping to have a restored metadata file I could try things on=0A=
>>> without risking the copy, since it's not possible to have a second one=
=0A=
>>> with this inordinate amount of data.=0A=
>>>=0A=
>>>>> -journalctl:=0A=
>>>>> xfs_db[3139]: segfault at 1015390b1 ip 0000000000407906 sp 00007ffcae=
f2c2c0 error 4 in xfs_db[400000+8a000]=0A=
>>>>>=0A=
>>>>> Now, the host machine is rather critical and old, running CentOS 7, 3=
.10 kernel on a Xeon X5650. Not trusting the hardware, I used ddrescue to c=
lone the partition to some other luckily available system.=0A=
>>>>> The copy went ok(?), but it did encounter reading errors at the end, =
which confirmed my suspicion that the rebuild process was not as successful=
. About 10MB could not be retrieved.=0A=
>>>>>=0A=
>>>>> I attempted a metadump on the copy too, now on a machine with AMD EPY=
C 7302, 128GB RAM, a 6.1 kernel and xfsprogs v6.1.0.=0A=
>>>>>=0A=
>>>>> # xfs_metadump -aogfw  /storage/image/sdb1.img   /storage/metadump/sd=
b1.metadump 2>&1 | tee mddump2.log=0A=
>>>>>=0A=
>>>>> It creates again a 280MB dump and at 30 AGs it segfaults:=0A=
>>>>>=0A=
>>>>> Jul24 14:47] xfs_db[42584]: segfault at 557051a1d2b0 ip 0000556f19f1e=
090 sp 00007ffe431a7be0 error 4 in xfs_db[556f19f04000+64000] likely on CPU=
 21 (core 9, socket 0)=0A=
>>>>> [  +0.000025] Code: 00 00 00 83 f8 0a 0f 84 90 07 00 00 c6 44 24 53 0=
0 48 63 f1 49 89 ff 48 c1 e6 04 48 8d 54 37 f0 48 bf ff ff ff ff ff ff 3f 0=
0 <48> 8b 02 48 8b 52 08 48 0f c8 48 c1 e8 09 48 0f ca 81 e2 ff ff 1f=0A=
>>>>>=0A=
>>>>> This is the log https://pastebin.com/jsSFeCr6, which looks similar to=
 the first one. The machine does not seem loaded at all and further tries r=
esult in the same code.=0A=
>>>>>=0A=
>>>>> My next step would be trying a later xfsprogs version, or maybe xfs_r=
epair -n on a compatible CPU machine as non-destructive options, but I feel=
 I'm kidding myself as to what I can try to recover anything at all from su=
ch humongous disaster.=0A=
>>>> Yes, that's probably the best approach now. To run the latest xfsprogs=
=0A=
>>>> available.=0A=
>>> Ok, so I ran into some unrelated issues, but I could finally install xf=
sprogs 6.15.0:=0A=
>>>=0A=
>>> root@serv:~# xfs_metadump -aogfw /storage/image/sdb1.img  /storage/meta=
dump/sdb1.metadump=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: data size check failed=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot init perag data (22). Continuing anyway.=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> empty log check failed=0A=
>>> xlog_is_dirty: cannot find log head/tail (xlog_find_tail=3D-22)=0A=
>>>=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read superblock for ag 0=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agf block for ag 0=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agi block for ag 0=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agfl block for ag 0=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read superblock for ag 1=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agf block for ag 1=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agi block for ag 1=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agfl block for ag 1=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read superblock for ag 2=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agf block for ag 2=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agi block for ag 2=0A=
>>> ...=0A=
>>> ...=0A=
>>> ...=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agfl block for ag 588=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read superblock for ag 589=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agf block for ag 589=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agi block for ag 589=0A=
>>> xfs_metadump: read failed: Invalid argument=0A=
>>> xfs_metadump: cannot read agfl block for ag 589=0A=
>>> Copying log=0A=
>>> root@serv:~#=0A=
>>>=0A=
>>> It did create a 2.1GB dump which of course restores to an empty file.=
=0A=
>>>=0A=
>>> I thought I had messed up with some of the dependency libs, so then I=
=0A=
>>> tried with xfsprogs 6.13 in Debian testing, same result.=0A=
>>>=0A=
>>> I'm not exactly sure why now it fails to read the image; nothing has=0A=
>>> changed about it. I could not find much more info in the documentation.=
=0A=
>>> What am I missing..?=0A=
>> I tried a few more things on the img, as I realized it was probably not=
=0A=
>> the best idea to dd it to a file instead of a device, but I got nowhere.=
=0A=
>> After some team deliberations, we decided to connect the original block=
=0A=
>> device to the new machine (Debian 13, 16 AMD cores, 128RAM, new=0A=
>> controller, plenty of swap, xfsprogs 6.13) and and see if the dump was p=
ossible then.=0A=
>>=0A=
>> It had the same behavior as with with xfsprogs 6.1 and segfauled after=
=0A=
>> 30 AGs. journalctl and dmesg don't really add any more info, so I tried=
=0A=
>> to debug a bit, though I'm afraid it's all quite foreign to me:=0A=
>>=0A=
>> root@ap:/metadump# gdb xfs_metadump core.12816=0A=
>> GNU gdb (Debian 16.3-1) 16.3=0A=
>> Copyright (C) 2024 Free Software Foundation, Inc.=0A=
>> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.=
html>=0A=
>> This is free software: you are free to change and redistribute it.=0A=
>> There is NO WARRANTY, to the extent permitted by law.=0A=
>> ...=0A=
>> Type "apropos word" to search for commands related to "word"...=0A=
>> "/usr/sbin/xfs_metadump": not in executable format: file format not reco=
gnized=0A=
>> [New LWP 12816]=0A=
>> Reading symbols from /usr/sbin/xfs_db...=0A=
>> (No debugging symbols found in /usr/sbin/xfs_db)=0A=
>> [Thread debugging using libthread_db enabled]=0A=
>> Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1=
".=0A=
>> Core was generated by `/usr/sbin/xfs_db -i -p xfs_metadump -c metadump /=
dev/sda1'.=0A=
>> Program terminated with signal SIGSEGV, Segmentation fault.=0A=
>> #0  0x0000556f127d6857 in ?? ()=0A=
>> (gdb) bt full=0A=
>> #0  0x0000556f127d6857 in ?? ()=0A=
>> No symbol table info available.=0A=
>> #1  0x0000556f127dbdc4 in ?? ()=0A=
>> No symbol table info available.=0A=
>> #2  0x0000556f127d5546 in ?? ()=0A=
>> No symbol table info available.=0A=
>> #3  0x0000556f127db350 in ?? ()=0A=
>> No symbol table info available.=0A=
>> #4  0x0000556f127d5546 in ?? ()=0A=
>> No symbol table info available.=0A=
>> #5  0x0000556f127d99aa in ?? ()=0A=
>> No symbol table info available.=0A=
>> #6  0x0000556f127b9764 in ?? ()=0A=
>> No symbol table info available.=0A=
>> #7  0x00007eff29058ca8 in ?? () from /lib/x86_64-linux-gnu/libc.so.6=0A=
>> No symbol table info available.=0A=
>> #8  0x00007eff29058d65 in __libc_start_main () from /lib/x86_64-linux-gn=
u/libc.so.6=0A=
>> No symbol table info available.=0A=
>> #9  0x0000556f127ba8c1 in ?? ()=0A=
>> No symbol table info available.=0A=
>>=0A=
>> And this:=0A=
>>=0A=
>> root@ap:/PETA/metadump# coredumpctl info=0A=
>>             PID: 13103 (xfs_db)=0A=
>>             UID: 0 (root)=0A=
>>             GID: 0 (root)=0A=
>>          Signal: 11 (SEGV)=0A=
>>       Timestamp: Mon 2025-08-18 19:03:19 CEST (1min 12s ago)=0A=
>>    Command Line: xfs_db -i -p xfs_metadump -c metadump -a -o -g -w $' /m=
etadump/metadata.img' /dev/sda1=0A=
>>      Executable: /usr/sbin/xfs_db=0A=
>>   Control Group: /user.slice/user-0.slice/session-8.scope=0A=
>>            Unit: session-8.scope=0A=
>>           Slice: user-0.slice=0A=
>>         Session: 8=0A=
>>       Owner UID: 0 (root)=0A=
>>         Boot ID: c090e507272647838c77bcdefd67e79c=0A=
>>      Machine ID: 83edcebe83994c67ac4f88e2a3c185e3=0A=
>>        Hostname: ap=0A=
>>         Storage: /var/lib/systemd/coredump/core.xfs_db.0.c090e5072726478=
38c77bcdefd67e79c.13103.1755536599000000.zst (present)=0A=
>>    Size on Disk: 26.2M=0A=
>>         Message: Process 13103 (xfs_db) of user 0 dumped core.=0A=
>>=0A=
>>                  Module libuuid.so.1 from deb util-linux-2.41-5.amd64=0A=
>>                  Stack trace of thread 13103:=0A=
>>                  #0  0x000055b961d29857 n/a (/usr/sbin/xfs_db + 0x32857)=
=0A=
>>                  #1  0x000055b961d2edc4 n/a (/usr/sbin/xfs_db + 0x37dc4)=
=0A=
>>                  #2  0x000055b961d28546 n/a (/usr/sbin/xfs_db + 0x31546)=
=0A=
>>                  #3  0x000055b961d2e350 n/a (/usr/sbin/xfs_db + 0x37350)=
=0A=
>>                  #4  0x000055b961d28546 n/a (/usr/sbin/xfs_db + 0x31546)=
=0A=
>>                  #5  0x000055b961d2c9aa n/a (/usr/sbin/xfs_db + 0x359aa)=
=0A=
>>                  #6  0x000055b961d0c764 n/a (/usr/sbin/xfs_db + 0x15764)=
=0A=
>>                  #7  0x00007fc870455ca8 n/a (libc.so.6 + 0x29ca8)=0A=
>>                  #8  0x00007fc870455d65 __libc_start_main (libc.so.6 + 0=
x29d65)=0A=
>>                  #9  0x000055b961d0d8c1 n/a (/usr/sbin/xfs_db + 0x168c1)=
=0A=
>>                  ELF object binary architecture: AMD x86-64=0A=
> Without the debug symbols it get virtually impossible to know what=0A=
> was going on =3D/=0A=
>> I guess my questions are: can the fs be so corrupted that it causes=0A=
>> xfs_metadump (or xfs_db) to segfault? Are there too many AGs / fs too=0A=
>> large?=0A=
>> Shall I assume that xfs_repair could fail similarly then?=0A=
> In a nutshell xfs_metadump shouldn't segfault even if the fs is=0A=
> corrupted.=0A=
> About xfs_repair, it depends, there is some code shared between both,=0A=
> but xfs_repair is much more resilient.=0A=
>=0A=
>> I'll appreciate any ideas. Also, if you think the core dump or other log=
s=0A=
>> could be useful, I can upload them somewhere.=0A=
> I'd start by running xfs_repair in no-modify mode, i.e. `xfs_repair -n`=
=0A=
> and check what it finds.=0A=
>=0A=
> Regarding the xfs_metadump segfault, yes, a core might be useful to=0A=
> investigate where the segfault is triggered, but you'll need to be=0A=
> running xfsprogs from the upstream tree (preferentially latest code), so=
=0A=
> we can actually match the core information the code.=0A=
=0A=
I figured it was not all the needed info, thanks for clarifying.=0A=
=0A=
Right now we had to put away the original hdds, as we cannot afford=0A=
another failed drive and time is pressing, and are dd'ing the image to a=0A=
real partition to try xfs_repair on it directly (takes days, of course,=0A=
but we're lucky we got the storage).=0A=
I will try the metadump and do further debugging if it segfaults again.=0A=
=0A=
Regarding the "invalid argument" when attempting the metadump with the=0A=
image... could it be related to a mismatch with the block/sector size of=0A=
the host fs?=0A=
I thought about attaching the img to a loop device, but I wasn't sure if=0A=
xfs_metadump tries that already. Also at this point I don't trust myself=0A=
to try anything without a 2nd copy.=0A=
=0A=
I'll let you know how that goes, thanks a lot again.=0A=
H.=0A=
=0A=
> Cheers,=0A=
> Carlos.=0A=
>=0A=
>> Thanks again=0A=
>>=0A=
>>>=0A=
>>> Thanks=0A=
>>>> Also, xfs_repair does not need to be executed on the same architecture=
=0A=
>>>> as the FS was running. Despite log replay (which is done by the Linux=
=0A=
>>>> kernel), xfs_repair is capable of converting the filesystem data=0A=
>>>> structures back and forth to the current machine endianness=0A=
>>>>=0A=
>>>>=0A=
>>>>> Thanks in advance for any input=0A=
>>>>> Hub=
