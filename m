Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013075.outbound.protection.outlook.com [52.103.20.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AA2322762
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755532618; cv=fail; b=Pz/70wjpR7JefU5tOZn1fwwwocOJLRsdgLYlxBvIqimF++9q86TaOz70St3M5cHu1KhfwM+ECbNaVD6Aq1A3mq8GUnK0vq/4Gab1bxxfM9D0/JgAVlRuhALtMpt2yjXIs6ck9H9sgNeJgPPpTWYqBO3loACJ151Ks/LraHNUKgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755532618; c=relaxed/simple;
	bh=IHvrX/5BjRwR5jJSMAA4C4iGL9SyM/WO7J3R5syS9S4=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WGEgonGjK8qGW3CXP9aekBo+b/6piv4h4qY6qCipTrs1fMcMeuOyAzDOo82damBH/fPNA9IZfZ+qlXZW3mVzlW/e7RkwZvrMrVADmMuGG49/Jv2NmgG6NHJSRh/od7oGstWx+r0t4Ig/GVLVVN4mb6iuVxK/4G6myTWD+qs1Fco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=fnnlgBWF; arc=fail smtp.client-ip=52.103.20.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="fnnlgBWF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u6KsVy1L35Pugi17oi2fTQdd7npQeTztCfD+ARKWVWH4OkfIvlYHccU8L1dTfXLao90X6HhxyV0YS2IcxiPgELGmWgo4kk4AcYe1aOfoOuA0bl0hyRCCcGIjraRMAhctLLbXbUfuPVnjWLi6jhqYdhuSeNhvJi4n9bV+NElhchZv5hjCjSoJWrRudiOOpg59DwOHiWgIsriL8cwso6p4zDdXTSnLeFIuz4l+W9WqD/Ahml5C6OW0QEWJVTDX3/DkIucyFnaEVb6EOotHMNXG1dQJpQJzo0pgTLvTy7zVU3/CzWSd9kiF0nw7MRZWC6VuDXcSyr6i0UOSWcnEJoKBZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51myYzjDgUVPtysBL3wS8+wKd7bKWX1TsDKqOaSIUTY=;
 b=YbDibdmF7Mk+Zkc7rKFoyIXACk04M5VF5Q+C8kiGKGWiQI6ympvEPCB7WwNaqcCIqkR+dMkNscz0yNp3Ik+Uw02pzhBYZNRfwt6Na/93c59vl2p1FZOuUfreIqyq5+/GnQQrcf5MinKkOew0DJ0SEP2j8ipDWnoIDt/Kbb+aA95MvR6HDuZI7Py5ozNhOnH4lyDbjOsOR4dIYHk8QXmF7+2MX2Jfkr7mTjR4/Q8IBHF+BK3cBydQoJ21LmfqBegHMU2n4dqVZ1WU+Ve08cQl/pjInJnhJ9ZUAd/fZP2CRa5lnudusil/rQ8x+X5ttlXfYfHALrENAASZAtmq6EMETg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51myYzjDgUVPtysBL3wS8+wKd7bKWX1TsDKqOaSIUTY=;
 b=fnnlgBWFBpIbKM8tqrtfd2/5SPgD9upAKxJp3tmVLVv+37k39uoyOm0odsQAV2f7JREmQ00Ox9+D8xwHAabUpi8Kc3xsu0l8Xk2s1YoEvCsIwrZabeDCRMdTG6wUSgiFYCcaqeo9ovyLb/W4iG1z5AaSi3690OJd8lFZZbD40BhNPaBHvT7PIBsTGwek8Kkl17lf3uldDNczX88ngFinxZYtWX5pM/IZ+qvDk4tvRRmVUOZy5W0JU/LBnyBtWWbKIUR5YxQ5OH/Q0uGwbNVd8hsFY7A/Lb72kYDokaTFJzljXy6xUOVy/WtZynWxCewNDODW+ApYMPzngf+W1Xtf9w==
Received: from IA0PR05MB9975.namprd05.prod.outlook.com (2603:10b6:208:408::13)
 by LV3PR05MB10383.namprd05.prod.outlook.com (2603:10b6:408:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 15:56:54 +0000
Received: from IA0PR05MB9975.namprd05.prod.outlook.com
 ([fe80::61ae:deb3:28b6:f1f7]) by IA0PR05MB9975.namprd05.prod.outlook.com
 ([fe80::61ae:deb3:28b6:f1f7%4]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 15:56:54 +0000
From: "hubert ." <hubjin657@outlook.com>
To: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Topic: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Index: AQHb/VadxSWI8qLMGkSlUABnC3FxxLRDxpcAgAoR9+KAGtxzMA==
Date: Mon, 18 Aug 2025 15:56:53 +0000
Message-ID:
 <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>
References:
 <f9Etb2La9b1KOT-5VdCdf6cd10olyT-FsRb8AZh8HNI1D4Czb610tw4BE15cNrEhY5OiXDGS7xR6R1trRyn1LA==@protonmail.internalid>
 <CH3PR05MB10392E816C6A1051847D214A2FA59A@CH3PR05MB10392.namprd05.prod.outlook.com>
 <6tqlc3mcf3ovkbzf4345m7oztoeagevfycpdnxizrtdbhq53p2@mrlmjhs6n7gy>
 <LV3PR05MB104071E0D6E7CAD06C7728DACFA26A@LV3PR05MB10407.namprd05.prod.outlook.com>
In-Reply-To:
 <LV3PR05MB104071E0D6E7CAD06C7728DACFA26A@LV3PR05MB10407.namprd05.prod.outlook.com>
Accept-Language: en-US, es-AR
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR05MB9975:EE_|LV3PR05MB10383:EE_
x-ms-office365-filtering-correlation-id: 00fd1a16-12b6-4099-22f0-08ddde6fda1e
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|15080799012|15030799006|8060799015|8062599012|19110799012|31061999003|440099028|3412199025|40105399003|12091999003|102099032|3430499032|10035399007|26104999006;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?IMDZSpQlr78cqQATM83D34gtKXAwhtaQ0YxXkpE2p1agN0zMzf+D79tDwP?=
 =?iso-8859-1?Q?DtmA7oKONImSaDuENYgVM/3tOMTSu39sm2Drow7OzuOYbUviQ9BFzLTnx+?=
 =?iso-8859-1?Q?UE6A0gvYKJpgrgZRy4H+FlfpfmPozDFS2a6pBstu4uYUDwIUjWV/leZ7oh?=
 =?iso-8859-1?Q?0l6Bff0gXk/7Zrv9UG0KcWBaCW3Av6yF/av2mlERJSW9nqDVMhFh9Ml2QD?=
 =?iso-8859-1?Q?2yUqOwgYHCkex77vukO+2MtV9kHbJw4hdG7CR3GF3OVkqZpkD/M8lhqtvX?=
 =?iso-8859-1?Q?sDiHEl8hWMFWZxrh268j8BZ6RCF7JjdK8i7yYHKomeWfM8zqZNRCvIwGro?=
 =?iso-8859-1?Q?Ah2NG9m9YWku75zJ875I3/jV1rUfLnLigZJTAf6G65p+7SQwRhN2UXm9tj?=
 =?iso-8859-1?Q?i9g34IfhGNz6IDSojwZNNhwYdh3YteeoRIJcJH4lN5hYxK6weSn2mPtodo?=
 =?iso-8859-1?Q?WOt6Gsc2sNFqeGRDVtjHAlLhuWzaknlnSScBbcpqt/gMm/Y8zfwZuRW19r?=
 =?iso-8859-1?Q?cKqc41v5jKfcQbMyWu4XyOz85jZz0kMyTyKDAWNIePM3Kuf0B0h9Ewmsp/?=
 =?iso-8859-1?Q?rz2PqvmSI8w+nvUgqLkjwxFVr4hCcgn3A3l/v5as8ZC5KhAEFLoZ1QR/mk?=
 =?iso-8859-1?Q?fN79VlOcL6vQ7cugjbnPTaW0XHa+hDMOis09q8mMQotkzGDM9uYjvu25rc?=
 =?iso-8859-1?Q?M2XJ+0wWM73OFuzSLG9SqXEPwzY0PpdnaWri1Z2UOU1o1s9LdeWieKo+Md?=
 =?iso-8859-1?Q?G4YAd+dq08QUn2a2o0r5JLjD0p3y0OATI3Vj9z6D0oz5fWR04EMIdNX4A2?=
 =?iso-8859-1?Q?rjVub+iu1JVWRBjisimufIMtldhyu8ADQkHkPGZ92V/E+geDjm+HGCflQs?=
 =?iso-8859-1?Q?ihSdGeIyndEtG0WyW68z6i5AaRccHsA8gQ35eXoeYuVqP2H4IM+0uhcZpO?=
 =?iso-8859-1?Q?kfwFmPzpdKyKfm6F7TWbQP3a22kDLmi4rQFvauCZ2JUqkAPxP7w89MM5c/?=
 =?iso-8859-1?Q?NdSorXR1EijvQwy0uPjwcUPzzS/GMm/+ckvocoJAjFXcbXCkrl2X7Dbc/e?=
 =?iso-8859-1?Q?Z2D1vuZeiEDbZl79l7Qh7boV/IL/BW0EI4b2B4MRhHF8TAeWvkKR64K56R?=
 =?iso-8859-1?Q?pgvBT6aMR6IMGdBRe4+lyQneOUSA0Pton7aA4DxZA9kb1gV9TVIzv9icfY?=
 =?iso-8859-1?Q?QeB+dRK+F4c0iXHTSmra8X52Fgz2dh6tNz0JvS+YmR6Gbt0bF+y7qMneRZ?=
 =?iso-8859-1?Q?2P6BOty2kmU20a70TVsgn3REFWcq35vlInrefuR0zW50G+Fec1gXIIkXte?=
 =?iso-8859-1?Q?ryLZRJq6B4RuYuvdg0ZcOaA02Q=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?9QBBqjQ/umybhQBbAjSXpn3mm5HUqIr8N5xvig/iO6rgLGzAMGhT2WlwDk?=
 =?iso-8859-1?Q?DPNV60Qc0Log9b1mzRnOcOLs5eay4bT49uZFkVGtEXYOkoAvPgVsDlGT3y?=
 =?iso-8859-1?Q?otUNFHpzDLDEwZVL7tcRFAdKSwp7HOB+nZrgiURiNcbyx6KJRuULhclD4b?=
 =?iso-8859-1?Q?jLPVB4RZKuGWA+2baDsMVDmY4c6BDBzVOjelWSWZPYT6RVrZc7xx0ZcORO?=
 =?iso-8859-1?Q?Q6GEqpHfVypPgxO1vbVNQD20f607I/jAk0xWHA6YfOhVjL0neZBE2GkyiU?=
 =?iso-8859-1?Q?I0d+iY4y65vE/+SPL/s6jhMhztkY+ej1AyBz90AFrkbtwBUdIuwdMtgMb3?=
 =?iso-8859-1?Q?mkvKT9vh3xjzdJvylU2Bill1UPV34itC9ys0s7ssXgF+6+vhLS/Y+fQ50r?=
 =?iso-8859-1?Q?AEG+gLlQyf7IU6PFXO8godhJWTSWgSNp46RdO7R0kS8XGB7hMqv3OvxAIt?=
 =?iso-8859-1?Q?YWXh+EAooKFaDqY5c2aoURc9qcJehZUU7HRBS+Q+HNx+HGZrvPb1xNCeP4?=
 =?iso-8859-1?Q?8I2F4D44TGmK8dn86FtjIKd+WbYDc+CrQqhRpOm+1u79ueLUkNqNyoVUXy?=
 =?iso-8859-1?Q?PRq9ejTcVEDJBNM7Xyksro7VEa936I2g6TzfAGzhNc2a7Ux+WacJUkNtxI?=
 =?iso-8859-1?Q?n2/EKMUwydRCjPAimPAUpw8RBlFgy6bhleE73/qDilBdq/YiX9RRkK5UqH?=
 =?iso-8859-1?Q?mxGLFNqD5B3Oj1EHdvi25ZN/OAl5LOptCT4vw573fbw/f9tgy9XCb2pp91?=
 =?iso-8859-1?Q?E3KKH/X/RYoR9h0fv5YG944E6GRIOn483nI0xf42rbnzxzbHY2Tspy8tMD?=
 =?iso-8859-1?Q?vuhG9+76gC7XUxZQOTuIRyBghGyArK42RVVlRAuwQmygQeinzuBWzLoiu+?=
 =?iso-8859-1?Q?ugfgo6oF22xcH875UHBsygFZg6rFA/xOsz0IvirUK9UAiHZNUKnkt8rqog?=
 =?iso-8859-1?Q?GdCJ1BBfjw48FAc8vmIJye38ABSbRT1PNA5DnI8TsSU9O64e82M5dxjHoo?=
 =?iso-8859-1?Q?TSUqJ1qUoCIGzzMQED4X/CVVne936fGZB+QrTs6EbTpP171JO3TJd5jciU?=
 =?iso-8859-1?Q?9bw9/tkTkc1BCXr89to6wHwPmmA1MQ9MIp0MxV4vM6+F4uGOY34at08ADD?=
 =?iso-8859-1?Q?pK3lbU5YKRHmb1HQL0cZRPsHaioH4ceMsEN3GREpzMqes4XrzgsJtYZ379?=
 =?iso-8859-1?Q?+JOtTHoMneE9h362QU6kScxrr8ICL76k1fcUdwfKE738a0dYFdTtlbuqvS?=
 =?iso-8859-1?Q?3HeT9J4YAR83nxFarc1OzXJFJJDM5If40lSBs7cAs=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 00fd1a16-12b6-4099-22f0-08ddde6fda1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 15:56:53.8587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR05MB10383

Am 18.08.25 um 17:14 schrieb hubert .:=0A=
>=0A=
> Am 26.07.25 um 00:52 schrieb Carlos Maiolino:=0A=
>>=0A=
>> On Fri, Jul 25, 2025 at 11:27:40AM +0000, hubert . wrote:=0A=
>>> Hi,=0A=
>>>=0A=
>>> A few months ago we had a serious crash in our monster RAID60 (~590TB) =
when one of the subvolume's disks failed and then then rebuild process trig=
gered failures in other drives (you guessed it, no backup).=0A=
>>> The hardware issues were plenty to the point where we don't rule out pr=
oblems in the Areca controller either, compounding to some probably poor de=
cisions on my part.=0A=
>>> The rebuild took weeks to complete and we left it in a degraded state n=
ot to make things worse.=0A=
>>> The first attempt to mount it read-only of course failed. From journalc=
tl:=0A=
>>>=0A=
>>> kernel: XFS (sdb1): Mounting V5 Filesystem=0A=
>>> kernel: XFS (sdb1): Starting recovery (logdev: internal)=0A=
>>> kernel: XFS (sdb1): Metadata CRC error detected at xfs_agf_read_verify+=
0x70/0x120 [xfs], xfs_agf block 0xa7fffff59=0A=
>>> kernel: XFS (sdb1): Unmount and run xfs_repair=0A=
>>> kernel: XFS (sdb1): First 64 bytes of corrupted metadata buffer:=0A=
>>> kernel: ffff89b444a94400: 74 4e 5a cc ae eb a0 6d 6c 08 95 5e ed 6b a4 =
ff  tNZ....ml..^.k..=0A=
>>> kernel: ffff89b444a94410: be d2 05 24 09 f2 0a d2 66 f3 be 3a 7b 97 9a =
84  ...$....f..:{...=0A=
>>> kernel: ffff89b444a94420: a4 95 78 72 58 08 ca ec 10 a7 c3 20 1a a3 a6 =
08  ..xrX...... ....=0A=
>>> kernel: ffff89b444a94430: b0 43 0f d6 80 fd 12 25 70 de 7f 28 78 26 3d =
94  .C.....%p..(x&=3D.=0A=
>>> kernel: XFS (sdb1): metadata I/O error: block 0xa7fffff59 ("xfs_trans_r=
ead_buf_map") error 74 numblks 1=0A=
>>>=0A=
>>> Following the advice in the list, I attempted to run a xfs_metadump (xf=
sprogs 4.5.0), but after after copying 30 out of 590 AGs, it segfaulted:=0A=
>>> /usr/sbin/xfs_metadump: line 33:  3139 Segmentation fault      (core du=
mped) xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1=0A=
>>=0A=
>> I'm not sure what you expect from a metadump, this is usually used for=
=0A=
>> post-mortem analysis, but you already know what went wrong and why=0A=
>=0A=
> I was hoping to have a restored metadata file I could try things on=0A=
> without risking the copy, since it's not possible to have a second one=0A=
> with this inordinate amount of data.=0A=
>=0A=
>>>=0A=
>>> -journalctl:=0A=
>>> xfs_db[3139]: segfault at 1015390b1 ip 0000000000407906 sp 00007ffcaef2=
c2c0 error 4 in xfs_db[400000+8a000]=0A=
>>>=0A=
>>> Now, the host machine is rather critical and old, running CentOS 7, 3.1=
0 kernel on a Xeon X5650. Not trusting the hardware, I used ddrescue to clo=
ne the partition to some other luckily available system.=0A=
>>> The copy went ok(?), but it did encounter reading errors at the end, wh=
ich confirmed my suspicion that the rebuild process was not as successful. =
About 10MB could not be retrieved.=0A=
>>>=0A=
>>> I attempted a metadump on the copy too, now on a machine with AMD EPYC =
7302, 128GB RAM, a 6.1 kernel and xfsprogs v6.1.0.=0A=
>>>=0A=
>>> # xfs_metadump -aogfw  /storage/image/sdb1.img   /storage/metadump/sdb1=
.metadump 2>&1 | tee mddump2.log=0A=
>>>=0A=
>>> It creates again a 280MB dump and at 30 AGs it segfaults:=0A=
>>>=0A=
>>> Jul24 14:47] xfs_db[42584]: segfault at 557051a1d2b0 ip 0000556f19f1e09=
0 sp 00007ffe431a7be0 error 4 in xfs_db[556f19f04000+64000] likely on CPU 2=
1 (core 9, socket 0)=0A=
>>> [  +0.000025] Code: 00 00 00 83 f8 0a 0f 84 90 07 00 00 c6 44 24 53 00 =
48 63 f1 49 89 ff 48 c1 e6 04 48 8d 54 37 f0 48 bf ff ff ff ff ff ff 3f 00 =
<48> 8b 02 48 8b 52 08 48 0f c8 48 c1 e8 09 48 0f ca 81 e2 ff ff 1f=0A=
>>>=0A=
>>> This is the log https://pastebin.com/jsSFeCr6, which looks similar to t=
he first one. The machine does not seem loaded at all and further tries res=
ult in the same code.=0A=
>>>=0A=
>>> My next step would be trying a later xfsprogs version, or maybe xfs_rep=
air -n on a compatible CPU machine as non-destructive options, but I feel I=
'm kidding myself as to what I can try to recover anything at all from such=
 humongous disaster.=0A=
>>=0A=
>> Yes, that's probably the best approach now. To run the latest xfsprogs=
=0A=
>> available.=0A=
>=0A=
> Ok, so I ran into some unrelated issues, but I could finally install xfsp=
rogs 6.15.0:=0A=
>=0A=
> root@serv:~# xfs_metadump -aogfw /storage/image/sdb1.img  /storage/metadu=
mp/sdb1.metadump=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: data size check failed=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot init perag data (22). Continuing anyway.=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> empty log check failed=0A=
> xlog_is_dirty: cannot find log head/tail (xlog_find_tail=3D-22)=0A=
>=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read superblock for ag 0=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agf block for ag 0=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agi block for ag 0=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agfl block for ag 0=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read superblock for ag 1=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agf block for ag 1=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agi block for ag 1=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agfl block for ag 1=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read superblock for ag 2=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agf block for ag 2=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agi block for ag 2=0A=
> ...=0A=
> ...=0A=
> ...=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agfl block for ag 588=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read superblock for ag 589=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agf block for ag 589=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agi block for ag 589=0A=
> xfs_metadump: read failed: Invalid argument=0A=
> xfs_metadump: cannot read agfl block for ag 589=0A=
> Copying log=0A=
> root@serv:~#=0A=
>=0A=
> It did create a 2.1GB dump which of course restores to an empty file.=0A=
>=0A=
> I thought I had messed up with some of the dependency libs, so then I=0A=
> tried with xfsprogs 6.13 in Debian testing, same result.=0A=
>=0A=
> I'm not exactly sure why now it fails to read the image; nothing has=0A=
> changed about it. I could not find much more info in the documentation.=
=0A=
> What am I missing..?=0A=
=0A=
I tried a few more things on the img, as I realized it was probably not =0A=
the best idea to dd it to a file instead of a device, but I got nowhere.=0A=
After some team deliberations, we decided to connect the original block =0A=
device to the new machine (Debian 13, 16 AMD cores, 128RAM, new =0A=
controller, plenty of swap, xfsprogs 6.13) and and see if the dump was poss=
ible then.=0A=
=0A=
It had the same behavior as with with xfsprogs 6.1 and segfauled after =0A=
30 AGs. journalctl and dmesg don't really add any more info, so I tried =0A=
to debug a bit, though I'm afraid it's all quite foreign to me:=0A=
=0A=
root@ap:/metadump# gdb xfs_metadump core.12816 =0A=
GNU gdb (Debian 16.3-1) 16.3=0A=
Copyright (C) 2024 Free Software Foundation, Inc.=0A=
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.htm=
l>=0A=
This is free software: you are free to change and redistribute it.=0A=
There is NO WARRANTY, to the extent permitted by law.=0A=
...=0A=
Type "apropos word" to search for commands related to "word"...=0A=
"/usr/sbin/xfs_metadump": not in executable format: file format not recogni=
zed=0A=
[New LWP 12816]=0A=
Reading symbols from /usr/sbin/xfs_db...=0A=
(No debugging symbols found in /usr/sbin/xfs_db)=0A=
[Thread debugging using libthread_db enabled]=0A=
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".=
=0A=
Core was generated by `/usr/sbin/xfs_db -i -p xfs_metadump -c metadump /dev=
/sda1'.=0A=
Program terminated with signal SIGSEGV, Segmentation fault.=0A=
#0  0x0000556f127d6857 in ?? ()=0A=
(gdb) bt full=0A=
#0  0x0000556f127d6857 in ?? ()=0A=
No symbol table info available.=0A=
#1  0x0000556f127dbdc4 in ?? ()=0A=
No symbol table info available.=0A=
#2  0x0000556f127d5546 in ?? ()=0A=
No symbol table info available.=0A=
#3  0x0000556f127db350 in ?? ()=0A=
No symbol table info available.=0A=
#4  0x0000556f127d5546 in ?? ()=0A=
No symbol table info available.=0A=
#5  0x0000556f127d99aa in ?? ()=0A=
No symbol table info available.=0A=
#6  0x0000556f127b9764 in ?? ()=0A=
No symbol table info available.=0A=
#7  0x00007eff29058ca8 in ?? () from /lib/x86_64-linux-gnu/libc.so.6=0A=
No symbol table info available.=0A=
#8  0x00007eff29058d65 in __libc_start_main () from /lib/x86_64-linux-gnu/l=
ibc.so.6=0A=
No symbol table info available.=0A=
#9  0x0000556f127ba8c1 in ?? ()=0A=
No symbol table info available.=0A=
=0A=
And this:=0A=
=0A=
root@ap:/PETA/metadump# coredumpctl info=0A=
           PID: 13103 (xfs_db)=0A=
           UID: 0 (root)=0A=
           GID: 0 (root)=0A=
        Signal: 11 (SEGV)=0A=
     Timestamp: Mon 2025-08-18 19:03:19 CEST (1min 12s ago)=0A=
  Command Line: xfs_db -i -p xfs_metadump -c metadump -a -o -g -w $' /metad=
ump/metadata.img' /dev/sda1=0A=
    Executable: /usr/sbin/xfs_db=0A=
 Control Group: /user.slice/user-0.slice/session-8.scope=0A=
          Unit: session-8.scope=0A=
         Slice: user-0.slice=0A=
       Session: 8=0A=
     Owner UID: 0 (root)=0A=
       Boot ID: c090e507272647838c77bcdefd67e79c=0A=
    Machine ID: 83edcebe83994c67ac4f88e2a3c185e3=0A=
      Hostname: ap=0A=
       Storage: /var/lib/systemd/coredump/core.xfs_db.0.c090e507272647838c7=
7bcdefd67e79c.13103.1755536599000000.zst (present)=0A=
  Size on Disk: 26.2M=0A=
       Message: Process 13103 (xfs_db) of user 0 dumped core.=0A=
                =0A=
                Module libuuid.so.1 from deb util-linux-2.41-5.amd64=0A=
                Stack trace of thread 13103:=0A=
                #0  0x000055b961d29857 n/a (/usr/sbin/xfs_db + 0x32857)=0A=
                #1  0x000055b961d2edc4 n/a (/usr/sbin/xfs_db + 0x37dc4)=0A=
                #2  0x000055b961d28546 n/a (/usr/sbin/xfs_db + 0x31546)=0A=
                #3  0x000055b961d2e350 n/a (/usr/sbin/xfs_db + 0x37350)=0A=
                #4  0x000055b961d28546 n/a (/usr/sbin/xfs_db + 0x31546)=0A=
                #5  0x000055b961d2c9aa n/a (/usr/sbin/xfs_db + 0x359aa)=0A=
                #6  0x000055b961d0c764 n/a (/usr/sbin/xfs_db + 0x15764)=0A=
                #7  0x00007fc870455ca8 n/a (libc.so.6 + 0x29ca8)=0A=
                #8  0x00007fc870455d65 __libc_start_main (libc.so.6 + 0x29d=
65)=0A=
                #9  0x000055b961d0d8c1 n/a (/usr/sbin/xfs_db + 0x168c1)=0A=
                ELF object binary architecture: AMD x86-64=0A=
=0A=
I guess my questions are: can the fs be so corrupted that it causes =0A=
xfs_metadump (or xfs_db) to segfault? Are there too many AGs / fs too =0A=
large?=0A=
Shall I assume that xfs_repair could fail similarly then?=0A=
=0A=
I'll appreciate any ideas. Also, if you think the core dump or other logs =
=0A=
could be useful, I can upload them somewhere.=0A=
=0A=
Thanks again=0A=
=0A=
>=0A=
>=0A=
> Thanks=0A=
>>=0A=
>> Also, xfs_repair does not need to be executed on the same architecture=
=0A=
>> as the FS was running. Despite log replay (which is done by the Linux=0A=
>> kernel), xfs_repair is capable of converting the filesystem data=0A=
>> structures back and forth to the current machine endianness=0A=
>>=0A=
>>=0A=
>>>=0A=
>>> Thanks in advance for any input=0A=
>>> Hub=0A=
>=0A=
