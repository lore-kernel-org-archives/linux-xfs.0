Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazolkn19011058.outbound.protection.outlook.com [52.103.14.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48332EEB3
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 09:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.14.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762161794; cv=fail; b=lel/oxsoPadp0A6YPghvE+gBvJaixv0ubrhU6CcigRAddQNgXVgK4wDl7E30u61c72VvqzBp5gNOGN5Vr3fPVcVDAle55hNivqJ4oeASoaW64HRC1yjVyjeLghio0+uEFchcTE4COkD9SD8fCl3t69ZITboWNz43JVmzUAKjtlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762161794; c=relaxed/simple;
	bh=XFuvTmA0QRDysuaXCExrG+vEuk3YxyOKg5BCxNmh95o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LUevoPdIVJv/uY6W/fDOaUZgxEbibg5j2U1O65tA+2zm8goI2SRtJa5lKrMXYQ3KFRekO+hPfuxzf9Eq67/U1kqdBPvtcShQW6yfxGiL9eVXgf0B+ctUbCZ4VXowe+2dMRA/1nuISylPwp9RJ3xbXYdzLurVNuaYCFQsWFQyzEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=j/j9NRaS; arc=fail smtp.client-ip=52.103.14.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="j/j9NRaS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RlpT5tW8Hjs5e2jlvhEgKWC0xAoeX+HRo/u7ZyCTD+6WPC2gDw4pBKimevzWFLZ8URa+1Dpir4iWm9HqGq3cUgHm5fJTggxrg5lOFE0ncDJlD3ugBS8thmdmdIPnE/wpXzAX2r0tEQdXGjyjN90jgYtFI6hDi3rZuD4uxGHWw55vGapu8Msfqj81OhLU61GJvZCleFFc8zl0SmXyqj39OjXWYRrPRBILL+qeGPwpLeEnbcf7Kbjo2uPJaRFimcp9EYn4m2eM+Pj6A87a+IZKeeWvraKjN3DWLgdtFihZSzQlLBLKZihMoV46pg4x0F5ajlsitbLmEnXO0dxi1ZRoMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kyZ6/1npV67/jW5oEgU2zNa5B3QXk48HSksEKMj2Tao=;
 b=xe2quHbmatAfCzW6+s14ljJnY9yOjsplC4wGRvMq5yzFIl6qGlz3XuAPQkvnJRbTOi1tyIf/IQPHbuumVcPvaNp3IuKkWXvxapsqempIV+CaskJTyuodunW4d1an/kKwoRRJw5moP4GVsCk/K7zODivC33LZnDaQzyZLki5xiduTBpF4L4gN/mg2xfvfslVqwuFpQ9PA+Jqj3m1lbbGpl1lJmaoVIJcT3fJBwT9ie90M6JrzmwdevOwqfJpS/1wjrHNFMEbXK01dFe7uRW7rrddgX6TOQp6Zv9XamqmWYC/7u5wEcL6TxFF0FAw9UWC73FL6F+9/kZZ9a6bmWK/Kjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyZ6/1npV67/jW5oEgU2zNa5B3QXk48HSksEKMj2Tao=;
 b=j/j9NRaShqGQeBmLszyuGBreGBnErU95Ck2Em04bi4its1b1wE5DKa3DdLlHH/sy10fDkNEiG5VkKqXxCYm4sMb8NrgzIty+BvyC6pnErk9sP6B0We/xMXKIWUxDNaLGweDzWQdlnsUUa3FrpfDVDvy0oPm4BgHCJP2krFwgUKvP1ezmY+48TO4Gi3bDXz9p3qncZGJzjclwNYBQ1GRwnVGAtWYK5e+DukA7kNAylZhWHb9xUp70HrlJ3C9NNtLYxIle67diINzG7iuCKsgwHjAdBZReKzqiBS8wNN7mxw2BGjv5LF/VYv1lUlCxu65sGmIHL/6CqKyiaF2Y4GujCw==
Received: from IA0PR05MB9975.namprd05.prod.outlook.com (2603:10b6:208:408::13)
 by IA1PR05MB9051.namprd05.prod.outlook.com (2603:10b6:208:389::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 09:23:09 +0000
Received: from IA0PR05MB9975.namprd05.prod.outlook.com
 ([fe80::61ae:deb3:28b6:f1f7]) by IA0PR05MB9975.namprd05.prod.outlook.com
 ([fe80::61ae:deb3:28b6:f1f7%3]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 09:23:09 +0000
From: "hubert ." <hubjin657@outlook.com>
To: Dave Chinner <david@fromorbit.com>, Carlos Maiolino <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Topic: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Index:
 AQHb/VadxSWI8qLMGkSlUABnC3FxxLRDxpcAgAoR9+KAGtxzMIAKen+AgANVmD+ALwamzoAADHAAgABEuoCAAjO7gIAAcgiAgANaCYCANW7Krw==
Date: Mon, 3 Nov 2025 09:23:08 +0000
Message-ID:
 <IA0PR05MB997593D825A2E104BF85DB5AFAC7A@IA0PR05MB9975.namprd05.prod.outlook.com>
References:
 <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <gjogpxo65cozoccj4fps6e4fzeu4ncibeofymhkyzys4hsclzy@vvrl2kndu7k6>
 <IA0PR05MB9975ADAF48C73797473737BEFA38A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <IA0PR05MB99755ED06F9965745B20D9DAFA1EA@IA0PR05MB9975.namprd05.prod.outlook.com>
 <7qd0IjCTUj1UpKLm2g6sPrhFI8HEoYrqIQ23o_ANTShTu58S7x7bgoMYTvXfR_fpqPdB85XxZoz16xrnllDcvA==@protonmail.internalid>
 <aNZfRuIVgIOiP6Qp@dread.disaster.area>
 <ip6g2acleif3cyslm65uzdxd47dgzfum57xxgpmk73r4223poy@shhld7q7ls7i>
 <k2WmSRFVtx7nB1UFDzxjDchWiWXHpB7iqgQdpjse19hi7nXOWfn6A5nKlf9stmEopKn16IAsArviy0SpjDfJ8Q==@protonmail.internalid>
 <aNhx0SD3zOasGhpp@dread.disaster.area>
 <bwfvyxyntorkrcg3fyjey7mbjqgrt4xx772xgkkdj64xifkbbo@ny54t3meeloo>
 <aNuhP-zyhfy34AT9@dread.disaster.area>
In-Reply-To: <aNuhP-zyhfy34AT9@dread.disaster.area>
Accept-Language: en-US, es-AR
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR05MB9975:EE_|IA1PR05MB9051:EE_
x-ms-office365-filtering-correlation-id: ade66b72-f11b-45b2-22cf-08de1aba9a4e
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|12121999013|41001999006|15080799012|15030799006|19110799012|8062599012|8060799015|461199028|40105399003|3412199025|440099028|102099032|26104999006;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?ZjcD/uEuLrb49dutLEfQKMrtvWjFjiFxDPFFxAc7O/x7mQ4Ln8HzAILI8w?=
 =?iso-8859-1?Q?bmHGqpXdPCslxBLvHgrC4XuUEd9Lvc4ch6UQsugZ04XQNglkO+aJlog/PU?=
 =?iso-8859-1?Q?oTAD0jBnj6JHuI3G284hxTRsLaT/gZ06OTR/9AB9YHlWMicnKqfdGqsXFc?=
 =?iso-8859-1?Q?DNRoP5DGImAJ1ofuVy+TGNwqIxzYLmYZho+7TyVQ9mchZmuoVBUGFhjgKA?=
 =?iso-8859-1?Q?LbnI5jUY9GBxHb1lARfi0tqyjus942i4wyqlfXp2UdgkIqdemB3cUNoMCg?=
 =?iso-8859-1?Q?GQsTUteUzR7aGKMJ9CpDUlyeZ+2JC/w60CZCrynD0HxFdDEEZOt9P3H3aL?=
 =?iso-8859-1?Q?MlvBKoK91Z0VP8v+CyThIDGEPX44ZjzTt4sR3bpKlMavpurDREjHcnlZ6x?=
 =?iso-8859-1?Q?5sBLu0upeSoKi+WJhA/Nr+5ib56qMLLKO2XOMfnHVCkwv0Mvty3UUFmc1T?=
 =?iso-8859-1?Q?qYd4TkOPNQeQiXF9L4m21BtRK79WeRolBeVOrW5adDaXhsd+80xiacY2Zv?=
 =?iso-8859-1?Q?SSRWcs7frBtW1BtU7b6kznDDjvCtytqx4o3qYhcBHt7Wa/2Mnh9SxW4qTT?=
 =?iso-8859-1?Q?/hz08uqbZIDm1ojeRiREgBtsrzud7B/PFLHtUUohwTkMTQ4bz1RnZ2WNX8?=
 =?iso-8859-1?Q?DyjcZAr1f7fl0T9cDUQfnSBlS9XKkI9Rej9OlGy01W8Tv8c8EP/ehu9ykl?=
 =?iso-8859-1?Q?/QcgNUFIBdL+x1NewlOP111CIYMyhw6O8BZ7csuOnYKq4RdCjcB7F/vVaN?=
 =?iso-8859-1?Q?UQHOOEbrI899JUBbSAgdmRREzNP2YQDmlLJo8GDudikWjvhrbN+i7oeayZ?=
 =?iso-8859-1?Q?Fiq7P193/0b0aif28zyBAjqBR61rBT0K/qRxHx0ZEAxlSVJPunKDfTzWfa?=
 =?iso-8859-1?Q?y78pXbV8PusIvIP4+dEEbY0Th/m6CcBmrQZUkeWRUFo8ep72o9BtDv7xaH?=
 =?iso-8859-1?Q?3WmbmVKGq0Fd6+wdH8nJ7jgiGCyrklu18285yyoPEaLYb0UanjQA8FRKVp?=
 =?iso-8859-1?Q?x1RIrQOCt658brQFiIWX7SRGJqtXFrUjBn8DdvP21h0FhyCy8vv1khZQYr?=
 =?iso-8859-1?Q?TkPh33zFwfoJTTyG3HLcax7nhjJbk1I6ekv6tboCvYUvmvrA8cy83DsYXD?=
 =?iso-8859-1?Q?71MQk2K5EuXjQlBcaDfR8sQR0hkCCbrcOGHGw3ACOe0gNJTrDi/t+f3W97?=
 =?iso-8859-1?Q?F+jW13pS1rUCIlF3W+yIHPQSc/d8Es57DPaZEGofT3l+qUdv+TH1hDyaqW?=
 =?iso-8859-1?Q?JSIRhmV4hWFtSJQbYHKYW0Jhus/l8AelwwFBO1xDVkPxNoCRuh4vUlbheJ?=
 =?iso-8859-1?Q?OhiobNm5iQQ/x0ZXh9qE7uUNMQ=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?3HGgqFgSpfruosEr+PIQWTxe5zpXbHPVWTtuCWU1d2bnVxmYEoF1Je09w0?=
 =?iso-8859-1?Q?Iw2yk0E85OM0+4gO/3KFpNcowEbX4o5Zs/BXahIbrkBVTelT29tpUMKbpU?=
 =?iso-8859-1?Q?G6d0wCeRcojvrhYtuOveMPFJlRSRq04yEW7TPxeYDZHx+hMo/iS8rYMeBp?=
 =?iso-8859-1?Q?y3g7ixkxbxpycaxj5+3G0Vq7HEIRYXrC9mHGN/mipwilvjN2p6x7MHBQY7?=
 =?iso-8859-1?Q?Fcvl07gOAxzCYIrWvx/iUolA1CmtyF44N5KuwfsNHUExvLJA7he5f9s3RY?=
 =?iso-8859-1?Q?rQk/GVwneY9g8xXy0loTdUhNSQd0z/BpX2Odsl8IbGlIw88f1KOlW7ZlEl?=
 =?iso-8859-1?Q?7edGmvqlkanCNJw8c/7uArTnioyLfyAFdP9t8NrYSPzmfSFh0+YpcK+MrL?=
 =?iso-8859-1?Q?CoKOdCu8R8cEH4DR3ZPEim8hWsH+sC0F4urRW1fWVf7rnkdkOYGqsMrByq?=
 =?iso-8859-1?Q?ukpBHU7MSfGphKbUfCa+1pTIvv7tFULhJwc6ZDftXLH7dFB1TjSTh2hlLj?=
 =?iso-8859-1?Q?1IA+NjPVOVvomqaBpsvS31RXsljX4XdDnJHus8ZlJzdGfjeVlN0kImb0tM?=
 =?iso-8859-1?Q?QGl8P35DLo4HRnoIM3eZFtklHZq8zkXCC/rRjSCmeftF8S4U62ppsTkdMZ?=
 =?iso-8859-1?Q?wECkp5On7JtH8qkiinKnieb1oEAhRSWZzIPs3w2HHF0jNKSsZ6lB4pWDQ1?=
 =?iso-8859-1?Q?PJyiUicDlDW9hn/Tb2ppPs7jB28FZdVEK5ZG9J6SdkezPdP6gJv8RivAOF?=
 =?iso-8859-1?Q?8LvVg2xHtImW2gNxh8wE3Cks350JQ+OsRoGq2xxTGihhHcYgCG6C8Vd+Mn?=
 =?iso-8859-1?Q?F2y2b7PmbyxWoWwaTB+p8QxTgatl2lZQ7EQvzD4uOrCyncoihhxNPopYcf?=
 =?iso-8859-1?Q?TglKXIhrY3clNw7RgmB5xGm77glmX6wYXM9fDh1dinAfimrdmc8lF/Ng/c?=
 =?iso-8859-1?Q?fmi7ePkvbCPaDdkmj4Y4Or3bRExc3T49l3RmHG4HOy42vIjnGD8ZoUYrLV?=
 =?iso-8859-1?Q?vvDvV310ITm/3Erq9NYsBHKcQEAp3OCvzl/3bg0S/oZE5ptR4HA6j2bX15?=
 =?iso-8859-1?Q?mM7jL/T+vsxVOHAsxlbFGiVKTj6GG79F0E7ALcAWUqaX5gXfcWD4Apbroj?=
 =?iso-8859-1?Q?amiXwU5Sh18+kNGC+hDmWKHjzoznpxi/uArEQZKi2jcUbRoY2wGkPI9Atp?=
 =?iso-8859-1?Q?CI2yJ+4H3MKlOfYqq26MrpPcfeTCjaMkwA3cJpM/Zvsyk36SESUQkWrgF+?=
 =?iso-8859-1?Q?NxfbjtzWqgDDlOCARq0JAlL4XEWFaUOJoHDjI9w68=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ade66b72-f11b-45b2-22cf-08de1aba9a4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2025 09:23:08.7747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR05MB9051

>>>> On Fri, Sep 26, 2025 at 07:39:18PM +1000, Dave Chinner wrote:=0A=
>>>>> So there must be a bounds checking bug in process_exinode():=0A=
>>>>>=0A=
>>>>> static int=0A=
>>>>> process_exinode(=0A=
>>>>>         struct xfs_dinode       *dip,=0A=
>>>>>         int                     whichfork)=0A=
>>>>> {=0A=
>>>>>         xfs_extnum_t            max_nex =3D xfs_iext_max_nextents(=0A=
>>>>>                         xfs_dinode_has_large_extent_counts(dip), whic=
hfork);=0A=
>>>>>         xfs_extnum_t            nex =3D xfs_dfork_nextents(dip, which=
fork);=0A=
>>>>>         int                     used =3D nex * sizeof(struct xfs_bmbt=
_rec);=0A=
>>>>>=0A=
>>>>>         if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork=
)) {=0A=
>>>>>                 if (metadump.show_warnings)=0A=
>>>>>                         print_warning("bad number of extents %llu in =
inode %lld",=0A=
>>>>>                                 (unsigned long long)nex,=0A=
>>>>>                                 (long long)metadump.cur_ino);=0A=
>>>>>                 return 1;=0A=
>>>>>         }=0A=
>>>>>=0A=
>>>>> Can you spot it?=0A=
>>>>>=0A=
>>>>> Hint: ((2^28 + 1) * 2^4) - 1 as an int is?=0A=
>>>>=0A=
>>>> Perhaps the patch below will suffice?=0A=
>>>>=0A=
>>>> diff --git a/db/metadump.c b/db/metadump.c=0A=
>>>> index 34f2d61700fe..1dd38ab84ade 100644=0A=
>>>> --- a/db/metadump.c=0A=
>>>> +++ b/db/metadump.c=0A=
>>>> @@ -2395,7 +2395,7 @@ process_btinode(=0A=
>>>>=0A=
>>>>  static int=0A=
>>>>  process_exinode(=0A=
>>>> - struct xfs_dinode       *dip,=0A=
>>>> + struct xfs_dinode       *dip,=0A=
>>>>   int                     whichfork)=0A=
>>>>  {=0A=
>>>>   xfs_extnum_t            max_nex =3D xfs_iext_max_nextents(=0A=
>>>> @@ -2403,7 +2403,13 @@ process_exinode(=0A=
>>>>   xfs_extnum_t            nex =3D xfs_dfork_nextents(dip, whichfork);=
=0A=
>>>>   int                     used =3D nex * sizeof(struct xfs_bmbt_rec);=
=0A=
>>>>=0A=
>>>> - if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {=0A=
>>>> + /*=0A=
>>>> +  * We need to check for overflow of used counter.=0A=
>>>> +  * If the inode extent count is corrupted, we risk having a=0A=
>>>> +  * big enough number of extents to overflow it.=0A=
>>>> +  */=0A=
>>>> + if (used < nex || nex > max_nex ||=0A=
>>>> +     used > XFS_DFORK_SIZE(dip, mp, whichfork)) {=0A=
>>>>           if (metadump.show_warnings)=0A=
>>>>                   print_warning("bad number of extents %llu in inode %=
lld",=0A=
>>>>                           (unsigned long long)nex,=0A=
>>>>=0A=
>>>=0A=
>>> That fixes this specific problem, but now it will reject valid=0A=
>>> inodes with valid but large extent counts.=0A=
>>>=0A=
>>> What type does XFS_SB_FEAT_INCOMPAT_NREXT64 require for extent=0A=
>>> count calculations?  i.e. what's the size of xfs_extnum_t?=0A=
>>=0A=
>> I thought about extending it to 64bit, but honestly thought it was not=
=0A=
>> necessary here as I thought the number of extents in an inode before it=
=0A=
>> was converted to btree format wouldn't exceed a 32-bit counter.=0A=
>=0A=
> The filesystem is corrupt so the normal rules of sanity don't apply.=0A=
> The extent count could be anything, and we can't assume that it fits=0A=
> in a 32 bit value, nor that any unchecked calculation based on the=0A=
> value fits in 32 bits.=0A=
>=0A=
> Mixing integer types like this always leads to bugs. It's bad=0A=
> practice because everyone who looks at the code has to think about=0A=
> type conversion rules (which no-one ever remembers or gets right) to=0A=
> determine if the code is correct or not. Nobody catches stuff=0A=
> like this during review and the compiler is no help, either.=0A=
>=0A=
>> That's a=0A=
>> trivial change for the patch, but still I think the overflow check=0A=
>> should still be there as even for a 64bit counter we could have enough=
=0A=
>> garbage to overflow it. Does it make sense to you?=0A=
>=0A=
> Yes, we need to check for overflow, but IMO, the best way to do=0A=
> these checks is to use the same type (and hence unsigned 64 bit=0A=
> math) throughout. This requires much less metnal gymnastics to=0A=
> determine that it is obviously correct:=0A=
>=0A=
> ....=0A=
>         xfs_extnum_t            used =3D nex * sizeof(struct xfs_bmbt_rec=
);=0A=
>=0A=
>         // number of extents clearly bad=0A=
>         if (nex > max_nex)=0A=
>                 goto warn;=0A=
>=0A=
>         // catch extent array size overflow=0A=
>         if (used < nex)=0A=
>                 goto warn;=0A=
>=0A=
>         // extent array should fit in the inode fork=0A=
>         if (used > XFS_DFORK_SIZE(dip, mp, whichfork))=0A=
>                 goto warn;=0A=
=0A=
Dear Carlos, dear Dave,=0A=
=0A=
Sorry for the late reply and thank you so much for looking into this.=0A=
Not sure if there is something else you would change here, but the patch=0A=
Carlos proposed worked for me and the metadump completed with no=0A=
issues.=0A=
Things got really busy since my last message, but I still wanted to=0A=
belatedly thank you both for your time and expert help.=0A=
=0A=
Best,=0A=
Hub=0A=
>=0A=
>=0A=
> -Dave.=0A=
> --=0A=
> Dave Chinner=0A=
> david@fromorbit.com=0A=
