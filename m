Received: from CY4PR02CU008.outbound.protection.outlook.com (mail-westcentralusazolkn19011026.outbound.protection.outlook.com [52.103.7.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846362E371F
	for <linux-xfs@vger.kernel.org>; Fri,  1 Aug 2025 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.7.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754056269; cv=fail; b=sDA0Q59ftf5+TY5ue2IJBJgUdvsrOYtBh7nbbuG1Y+u5PG+A2yifqbb8eDe84yc/OF6Zg+CAqOtgCyT9HMzlYYd37dKWVld/jccJ61anpEel/H+ICMhV9CEiAWdqMbUzJC8OcXh1Yud8+NxlWOARkcXDWAWAlZFpt5L4Ove5rnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754056269; c=relaxed/simple;
	bh=p1GwvdtLbblrOFeW5artg8yrcdmXqCV9x4uRFYy2n8w=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qfE5NlZWB0vuTXezv291QsN8aOhPBMhBpVNNm9eKGwB1JCqHIugKBDO0Ye0+EkPEDoigpxZFIX8k8DPxT9lVK3l7kBA24GUyJTDCvNx40eIIx7+URP/h2RULFVadXnByTFtU95+rnQ2vVmAMknkbHum9skUzV6VPDLVUKEsI28E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=No6ahDro; arc=fail smtp.client-ip=52.103.7.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="No6ahDro"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uAKrb0qO2B/7orrDH4x70ilyqw/taCcDNVR0Ywjmd3LUVC8gM+ON6OsoAc5/BmjLCEwxsIQT1MR+xNB0MT/Uqjs434/gx7Xig30Y9VJC+Qv7LmK0ksEesotPrvsy3Ph1xDp3kDFCVm9aoDvU6xC8+VK0t8rVidgUKQ3twBRT0i9AGzI1uy2j2ucSDoODfGM1hva8Jfn/5BiW2N8DLQL4C9sg8rRF0LlNVfoZ0Hx4KWVdBJZ4YQrwbBoxWRbUemEqwAjRnjmUTWm4WyF7gIqfJ5voYQffEGv3PDs7yinqwsA+J9TtDkq26RhH3pduVFsJYqYGtLP08sUgRAdCZu+46Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1GwvdtLbblrOFeW5artg8yrcdmXqCV9x4uRFYy2n8w=;
 b=d+EppP+HfSYmT2p7uoAT+xJxzkQjdcqD7UsJ7hlLYt9ZsiSS3MQmo4heZ7U7GvcaTGnT2M1E8yP+Ng62VRQpfBI/cVN8jEw3LQIgvyRTLLzFtbJTwjbL/l4HGWBRlHmZn2L8utGMVHVBis6n+wQAuEsj+nwXXQPpMHsJgAkb7ybksZpXtqHGsN9b3+OL27BqQXhTV26ZrPfQNSuAe4FkPbRwWvZCpIAME/HH4RdRwZH5MGdI/y6Qr/jxDY8l+cN/40JksvF0Sp3FqrFrd9t8SAPFwbVt+yqWn8gcbh4N7van+iCE5eLKvaupWawzEwsa+hjJDsr3hZ7AmzgPm+gmlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1GwvdtLbblrOFeW5artg8yrcdmXqCV9x4uRFYy2n8w=;
 b=No6ahDro1RvbFQqj8oOZL6wca2p0ZCmlp3t48OCWV5pLaiEwoJNGC/Wk0njTMHbZOLWHqGe68u62SeAmO85ZZfPSpggTzazKZi5wMi5NVKJ9t2v/DeSyM317nh2qXVvvxLfg+lJT3pOyT7CpC+ev9Pw5JPKFdggKTbXX2BmlXhdF/830kBrAvow0teqUXw052h8PTfernOPDrtvv8fm6bbR2leXZm0QNrxTtp4asxR1Y5vtpwgJ5TFkU+De+LSoV05g4JTH5DvC5fNFAAFdpUan7Hz1/JIWNnupMQIB9mVUvFk06QBsEiRWQHZzCoVJKrawScmy/FdKiZWFL1MXarA==
Received: from LV3PR05MB10407.namprd05.prod.outlook.com
 (2603:10b6:408:194::10) by BY3PR05MB8068.namprd05.prod.outlook.com
 (2603:10b6:a03:36b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Fri, 1 Aug
 2025 13:51:04 +0000
Received: from LV3PR05MB10407.namprd05.prod.outlook.com
 ([fe80::adf2:d53:82d5:97f]) by LV3PR05MB10407.namprd05.prod.outlook.com
 ([fe80::adf2:d53:82d5:97f%4]) with mapi id 15.20.8989.013; Fri, 1 Aug 2025
 13:51:04 +0000
From: "hubert ." <hubjin657@outlook.com>
To: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Topic: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Index: AQHb/VadxSWI8qLMGkSlUABnC3FxxLRDxpcAgAoR9+I=
Date: Fri, 1 Aug 2025 13:51:04 +0000
Message-ID:
 <LV3PR05MB104071E0D6E7CAD06C7728DACFA26A@LV3PR05MB10407.namprd05.prod.outlook.com>
References:
 <f9Etb2La9b1KOT-5VdCdf6cd10olyT-FsRb8AZh8HNI1D4Czb610tw4BE15cNrEhY5OiXDGS7xR6R1trRyn1LA==@protonmail.internalid>
 <CH3PR05MB10392E816C6A1051847D214A2FA59A@CH3PR05MB10392.namprd05.prod.outlook.com>
 <6tqlc3mcf3ovkbzf4345m7oztoeagevfycpdnxizrtdbhq53p2@mrlmjhs6n7gy>
In-Reply-To: <6tqlc3mcf3ovkbzf4345m7oztoeagevfycpdnxizrtdbhq53p2@mrlmjhs6n7gy>
Accept-Language: en-US, es-AR
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR05MB10407:EE_|BY3PR05MB8068:EE_
x-ms-office365-filtering-correlation-id: 6a4e198a-a8ee-4f25-ddf6-08ddd1027546
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|15030799006|31061999003|8062599012|8060799015|19110799012|461199028|40105399003|3412199025|440099028|10035399007|102099032|3430499032|26104999006;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?fk662h8GtT9lI9H5hIL0EfneAMOZyCEA1lIg2GVLzCEvAxl1TI1MAeTnbd?=
 =?iso-8859-1?Q?/0vwNRqvuUr9Iw8zXuOFyWIoqJsx7DExei1orCRe7H343w04e8PsORoC37?=
 =?iso-8859-1?Q?+molZYZB1rB/SCyT5ODu6ImfKmRNoFKxz6QvHGMZJQPusbngG7rWwrVwNC?=
 =?iso-8859-1?Q?ay+uGDyI4nsYFLrmMF/pWSafWeho0lIjodgcDGwIfqY5PUer24q7niRGUa?=
 =?iso-8859-1?Q?nxEr8vjDI9fQEIi/VoQEd74N2iTiQwWgWLqQ22l2IP9Q6QPqHUjutfu0d2?=
 =?iso-8859-1?Q?fDmVB1+snODjM6YG29ql3pKgaOosS35Yfm3lV6M16pLIZFm4hZItetjgm6?=
 =?iso-8859-1?Q?bFNi9ixZq+g6h8GmOQu4fCZn7TW/w0EHo7Cc0FkNcPIG67ssiYWNLdKWhx?=
 =?iso-8859-1?Q?oOfar7Hka2up5ftFxWbGyhB/6++y6jvc2B4YNWQcxUz3yogzFem0M+KHOr?=
 =?iso-8859-1?Q?VkdxXwVp1jru3D2fvGyTFLwuiJiTgCvO7pBahJy41uAVFOBbwBT6GRT325?=
 =?iso-8859-1?Q?mXxbgJGkQ8AHRLLxMPS2Ya7X4PT+hwKp505C9rW8R5i8fYfXfXxnfIccWO?=
 =?iso-8859-1?Q?docAIOZVO4Jdn2PPDGH3L9Sb7n4rhFkOmNRDNXkEn21MWSY4iz8EpVNf3X?=
 =?iso-8859-1?Q?dBuzrXtI56joWyt+ufe1IDsQDh/BI6SXHmBDfBsNAXV602/12LTEu6lnZ4?=
 =?iso-8859-1?Q?hcVnGg4VWksGI1F6JQOQfc7OIFfZ/xK+zT3vW0SYolh4QqdNgaAHoYLmYy?=
 =?iso-8859-1?Q?m5CEgEm0iqWaSb+OIe2rerucKygcW5T9riyoNFmPjKGvCWmvzsQ9s5gfW5?=
 =?iso-8859-1?Q?peQj/y7FgDFQWPouFaOaiwCpnMqk+/rMX2r6shE1oBZ1gR0r8NbkC+rvui?=
 =?iso-8859-1?Q?bFhkHV4FhJCOCHB5D5G8FIWbCUqqOXPFOQ6vZIGu0xBGrcTC9MgLeAQvon?=
 =?iso-8859-1?Q?DJzqaSQrrMdnHbTqXpBJRXqB3DafTRiznSLbsK0EfxcCwGxgLZZta/GHGY?=
 =?iso-8859-1?Q?5+DnwH2+iFJcb/UvzbO7hw7U8tr/24YkgIIAdnklkjynNYOFBPeVDrk5Mm?=
 =?iso-8859-1?Q?H8ipZu/j7l07rJoKJ6cEnACweh3zr3kEStRDiSttC4HD0up/OkaRXmu+Ts?=
 =?iso-8859-1?Q?LuO9u1ZnRvLJeBWVyNY4C/Ja0GFLE3Rt4B0z8qHORErXhIBjsLPCVdmEu3?=
 =?iso-8859-1?Q?4tQSzmyzj0hVOaG6CImPuQRxnhn2S/mAcswz3x219uTeSsGMNNiJXOCwMd?=
 =?iso-8859-1?Q?+wFPmeXfzh9IXpHg6uke+VZtq/dfAUkVVJVa0kUUg=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?EYRd3ri2fNrW03uVamO9B7cffTj9gzBCjXXUy43wcHYR9dRqdDBWqZGh+R?=
 =?iso-8859-1?Q?a7qAwN3ZzULFJPWV33KMRvsDQTHTkH6TWqaDV9jRFJSRnWKMF5qKm+ava6?=
 =?iso-8859-1?Q?UjVFkpl8ZQLdELz6QUIIxfbuY5AGKF+f0eqCxmWTI+NA4ydZ5SvLDLB4Lj?=
 =?iso-8859-1?Q?WyXok7219P38+0X5kgRjc11ezwdl7swdSWbimk1A1BjQShQKcr53AV9VaH?=
 =?iso-8859-1?Q?80cZIdcY5IUrSAzAfDLH8fLAJLUeTICSRZnM4kVhK55IFGbXVpSuVxYRO3?=
 =?iso-8859-1?Q?QLOLMkHHmHYpytGZv0X2OeUa/265qhttjBkuwdMgdlZ3K5fhXTFU6PVPl9?=
 =?iso-8859-1?Q?FqH8uY53nhaMy+UZ9kbrA02nKKLTyDx/4QNMHdDq7c/2Cb2xe2W3PutKeF?=
 =?iso-8859-1?Q?1tWk759u3y99kr24E8bGN6VVpUgJZtleVM6RzAci/7DCwKglQ88PBkRN0L?=
 =?iso-8859-1?Q?deGsRdHtQVt7rDweqXZSCselzVFDcUR8NLy0ftdCKuuoR4PDykbfhY8O/8?=
 =?iso-8859-1?Q?DjDLzv6xVDqqp8em5NhUHc9AfZA/uZOFLC4fuh9Px7ZxdSvTbN0L33B6lR?=
 =?iso-8859-1?Q?uRKOL33y2r53Y7lvjTjQFTKgV5ITXINymmK8vZYSzK0dVc3y4Q6/HDBBQD?=
 =?iso-8859-1?Q?9XxY1FGxEvYte8bc+an6Yk9cwiaaBXY+pBeC7aV2m1o0jrR2PXvaQbNy8s?=
 =?iso-8859-1?Q?ZwvKXPjmpC2PajqM1zpdC8uSL1HahIlaKsfUIpX/9zjA0GEc4sw7mqff1i?=
 =?iso-8859-1?Q?eWMBb+5FuCeriVqXwr2/pkx7IVkPuvI8ll1uHDiBYFkAyXD/+mqyDhawT/?=
 =?iso-8859-1?Q?nwOcoF/sp8gdDb0oTRoGFY3dndGzevmd276gq4W/g824E8Q/yYUn/Krp+/?=
 =?iso-8859-1?Q?Dc9tmHnGAB8QwEu0gZbqGVXJ4/edyIrPUErETVT9f4V5i3Ry7s0vaPzTTC?=
 =?iso-8859-1?Q?R+GmT05WBI76+yGI4W+66I4EBZms0+NWEzE7PytJTv77mbr1VknP8Wfib6?=
 =?iso-8859-1?Q?wx0tKaMfCBaRqYKHOCktZK++COmOqQ+QsPhhUjvsADF+aTJAPkH91JlndD?=
 =?iso-8859-1?Q?H1f9CjW9kxTZCCWjc5tjFRCGT+bXwhcZX8EjLH0hnLP4XpqZw4kCXjVHRC?=
 =?iso-8859-1?Q?UjMumy3nWfxVhHGCiGguo3PXD/g2YvVfpqqeGHjtpkrTTIFoJzX3kwVfZh?=
 =?iso-8859-1?Q?efzMW+IQPdUfche7BtFXGq8DeucVpiXrh/ycDpO+FnjOoQp8jKik5v2UDH?=
 =?iso-8859-1?Q?8mXHMBSJz/wKFAq5JzkyDTNHAq8eZQPZNcskexUXU=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: LV3PR05MB10407.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a4e198a-a8ee-4f25-ddf6-08ddd1027546
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2025 13:51:04.4082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR05MB8068

Am 26.07.25 um 00:52 schrieb Carlos Maiolino:=0A=
> =A0=0A=
> On Fri, Jul 25, 2025 at 11:27:40AM +0000, hubert . wrote:=0A=
> > Hi,=0A=
> >=0A=
> > A few months ago we had a serious crash in our monster RAID60 (~590TB) =
when one of the subvolume's disks failed and then then rebuild process trig=
gered failures in other drives (you guessed it, no backup).=0A=
> > The hardware issues were plenty to the point where we don't rule out pr=
oblems in the Areca controller either, compounding to some probably poor de=
cisions on my part.=0A=
> > The rebuild took weeks to complete and we left it in a degraded state n=
ot to make things worse.=0A=
> > The first attempt to mount it read-only of course failed. From journalc=
tl:=0A=
> >=0A=
> > kernel: XFS (sdb1): Mounting V5 Filesystem=0A=
> > kernel: XFS (sdb1): Starting recovery (logdev: internal)=0A=
> > kernel: XFS (sdb1): Metadata CRC error detected at xfs_agf_read_verify+=
0x70/0x120 [xfs], xfs_agf block 0xa7fffff59=0A=
> > kernel: XFS (sdb1): Unmount and run xfs_repair=0A=
> > kernel: XFS (sdb1): First 64 bytes of corrupted metadata buffer:=0A=
> > kernel: ffff89b444a94400: 74 4e 5a cc ae eb a0 6d 6c 08 95 5e ed 6b a4 =
ff =A0tNZ....ml..^.k..=0A=
> > kernel: ffff89b444a94410: be d2 05 24 09 f2 0a d2 66 f3 be 3a 7b 97 9a =
84 =A0...$....f..:{...=0A=
> > kernel: ffff89b444a94420: a4 95 78 72 58 08 ca ec 10 a7 c3 20 1a a3 a6 =
08 =A0..xrX...... ....=0A=
> > kernel: ffff89b444a94430: b0 43 0f d6 80 fd 12 25 70 de 7f 28 78 26 3d =
94 =A0.C.....%p..(x&=3D.=0A=
> > kernel: XFS (sdb1): metadata I/O error: block 0xa7fffff59 ("xfs_trans_r=
ead_buf_map") error 74 numblks 1=0A=
> >=0A=
> > Following the advice in the list, I attempted to run a xfs_metadump (xf=
sprogs 4.5.0), but after after copying 30 out of 590 AGs, it segfaulted:=0A=
> > /usr/sbin/xfs_metadump: line 33: =A03139 Segmentation fault =A0 =A0 =A0=
(core dumped) xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1=0A=
>=0A=
> I'm not sure what you expect from a metadump, this is usually used for=0A=
> post-mortem analysis, but you already know what went wrong and why=0A=
=0A=
I was hoping to have a restored metadata file I could try things on=0A=
without risking the copy, since it's not possible to have a second one=0A=
with this inordinate amount of data.=0A=
=0A=
> >=0A=
> > -journalctl:=0A=
> > xfs_db[3139]: segfault at 1015390b1 ip 0000000000407906 sp 00007ffcaef2=
c2c0 error 4 in xfs_db[400000+8a000]=0A=
> >=0A=
> > Now, the host machine is rather critical and old, running CentOS 7, 3.1=
0 kernel on a Xeon X5650. Not trusting the hardware, I used ddrescue to clo=
ne the partition to some other luckily available system.=0A=
> > The copy went ok(?), but it did encounter reading errors at the end, wh=
ich confirmed my suspicion that the rebuild process was not as successful. =
About 10MB could not be retrieved.=0A=
> >=0A=
> > I attempted a metadump on the copy too, now on a machine with AMD EPYC =
7302, 128GB RAM, a 6.1 kernel and xfsprogs v6.1.0.=0A=
> >=0A=
> > # xfs_metadump -aogfw =A0/storage/image/sdb1.img =A0 /storage/metadump/=
sdb1.metadump 2>&1 | tee mddump2.log=0A=
> >=0A=
> > It creates again a 280MB dump and at 30 AGs it segfaults:=0A=
> >=0A=
> > Jul24 14:47] xfs_db[42584]: segfault at 557051a1d2b0 ip 0000556f19f1e09=
0 sp 00007ffe431a7be0 error 4 in xfs_db[556f19f04000+64000] likely on CPU 2=
1 (core 9, socket 0)=0A=
> > [ =A0+0.000025] Code: 00 00 00 83 f8 0a 0f 84 90 07 00 00 c6 44 24 53 0=
0 48 63 f1 49 89 ff 48 c1 e6 04 48 8d 54 37 f0 48 bf ff ff ff ff ff ff 3f 0=
0 <48> 8b 02 48 8b 52 08 48 0f c8 48 c1 e8 09 48 0f ca 81 e2 ff ff 1f=0A=
> >=0A=
> > This is the log https://pastebin.com/jsSFeCr6, which looks similar to t=
he first one. The machine does not seem loaded at all and further tries res=
ult in the same code.=0A=
> >=0A=
> > My next step would be trying a later xfsprogs version, or maybe xfs_rep=
air -n on a compatible CPU machine as non-destructive options, but I feel I=
'm kidding myself as to what I can try to recover anything at all from such=
 humongous disaster.=0A=
>=0A=
> Yes, that's probably the best approach now. To run the latest xfsprogs=0A=
> available.=0A=
=0A=
Ok, so I ran into some unrelated issues, but I could finally install xfspro=
gs 6.15.0:=0A=
=0A=
root@serv:~# xfs_metadump -aogfw /storage/image/sdb1.img =A0/storage/metadu=
mp/sdb1.metadump=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: data size check failed=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot init perag data (22). Continuing anyway.=0A=
xfs_metadump: read failed: Invalid argument=0A=
empty log check failed=0A=
xlog_is_dirty: cannot find log head/tail (xlog_find_tail=3D-22)=0A=
=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read superblock for ag 0=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agf block for ag 0=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agi block for ag 0=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agfl block for ag 0=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read superblock for ag 1=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agf block for ag 1=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agi block for ag 1=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agfl block for ag 1=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read superblock for ag 2=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agf block for ag 2=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agi block for ag 2=0A=
...=0A=
...=0A=
...=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agfl block for ag 588=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read superblock for ag 589=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agf block for ag 589=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agi block for ag 589=0A=
xfs_metadump: read failed: Invalid argument=0A=
xfs_metadump: cannot read agfl block for ag 589=0A=
Copying log =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=0A=
root@serv:~#=0A=
=0A=
It did create a 2.1GB dump which of course restores to an empty file.=0A=
=0A=
I thought I had messed up with some of the dependency libs, so then I =0A=
tried with xfsprogs 6.13 in Debian testing, same result.=0A=
=0A=
I'm not exactly sure why now it fails to read the image; nothing has=0A=
changed about it. I could not find much more info in the documentation.=0A=
What am I missing..?=0A=
=0A=
Thanks=0A=
>=0A=
> Also, xfs_repair does not need to be executed on the same architecture=0A=
> as the FS was running. Despite log replay (which is done by the Linux=0A=
> kernel), xfs_repair is capable of converting the filesystem data=0A=
> structures back and forth to the current machine endianness=0A=
>=0A=
>=0A=
> >=0A=
> > Thanks in advance for any input=0A=
> > Hub=0A=
