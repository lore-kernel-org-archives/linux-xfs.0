Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazolkn19012040.outbound.protection.outlook.com [52.103.7.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2322ECD3E
	for <linux-xfs@vger.kernel.org>; Fri, 25 Jul 2025 11:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.7.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753442865; cv=fail; b=lUQm0NRkJO83GrEUmQSIav7CqCKqxyKqQ6FGtOT9naSkW002mNeyaHxMATRh4IPYOjBw1KDPysf9XChAxjMArft+bXaPLDfuYKXdlCmp/2C27ErCITY9TUZOul7i9KAFP24TdbhJR7B4LpGX7EJiRlB9+YNgZSzPAmMPHTrByuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753442865; c=relaxed/simple;
	bh=sAmoqcKPhHfDE3YfmlH/33vq3teuuhqk6ItMguPoZjo=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=muDsBa8aoVUOL9tKdT6RbpFFN4g1DJFei05mDz941F0x3flBBPE6WEQF+QzDOZaFjYH6+N7JF9D5da+KH1O46wOH0BsaFBEH/d8/QXv0Ab1tv4kZAajmI2J0RYfWVH1YH/oW5tlAmdPZLdCNWnjfa+1VaQ7noSlotXkFADZ7MdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=f2+TWSi9; arc=fail smtp.client-ip=52.103.7.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="f2+TWSi9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mtsgRxWwHRf888aLwMezuyrgu5VOUlrfOOVJLpc9Rgnuz2OtnDfy9Zla40zoN8BA53kzJCvrJST3SqQRoi1fkmmYOIkxGJ+McoLU3Jz3uJGjCNRxoNQR3xvSdHXbBnML707LHHTTeYIq3OmmsjT2/tY4UXF7HyMnwLkoQ0eVnJt6j80cbmcntGZ7dYDsNp+FYtket59cuAxpDFF3khxC6UHWFbsQamAvS2zSrApIluc1qgzGRIhPRi9R5sXSwjm7/sYAOAZllh6aZMCAbFe9A2umO8UOi8r6+VSFO0g6Yy63tkwFaTWFU2TJaeVN6OBntwyEXhC0cWc5EhPeaGuGkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6a4aaNdjFkSaa/w+Xx+IDOCntbQZWDkmlffLex2L+g=;
 b=NowXJIlJXv82JAVFoubWwzsqkPYa24k+56vEkGBkfnGERR0FtcVx+2CYkZyeRVY0L58cZ7pjFHS+tuDMU5k9DWPP+H4AeoUuA9pJ1x/hm8rNmAy3tZ5AuNDMrb01+4tfQP5lx2aqUK7TUSn0IUFoYjGe7I/PYsYosiFG5gzb2aGMSMYdUtsnRuzw6wdiBg52idgNVLuspKrcyDfJMS2we/bDLcWIOjI5eMiEqMXXRshTykwSgAkPfyQ9r+0/VhTJLvuMpNiprnz52fHTp7NxAg9hz0dBhpRn1FaHEd6LSKvuklyVpRjz3sabBo7OeIwxxOgOhn+Cp+1tN/hP/vghhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6a4aaNdjFkSaa/w+Xx+IDOCntbQZWDkmlffLex2L+g=;
 b=f2+TWSi9Xphlte1IVo7E0joQsI/whQ6kBl0dWPDGo6zwcCnWO4/tBPBAIkRm7vQsigb493FMgOPOxW7q+g4kqGbBpiTfuhVYyrsNy4JSm+KGRVmFVCL7pWLYQA8TvJM2Y3LBmz+BFjlQG4SNKhfq9gu1jpiYOORNQTuUbeDwKGL2WMfHCUZmyJIMPlEqRghcq8eLgAi+gmanHnmbzQn7CGGMOVqYbBR6Aea+9VAxBYl2udytu5/aMoJgjoqVAXHXznWELfPK+0LKCXSuUi4+/74w49SpsejViz3RWv+4VulohbJcRZSg9cZXHtBJz71khekF7ETmfccV+wUcfZoZyg==
Received: from CH3PR05MB10392.namprd05.prod.outlook.com
 (2603:10b6:610:198::20) by SA1PR05MB8439.namprd05.prod.outlook.com
 (2603:10b6:806:1d6::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Fri, 25 Jul
 2025 11:27:41 +0000
Received: from CH3PR05MB10392.namprd05.prod.outlook.com
 ([fe80::f5aa:9033:7824:c6c7]) by CH3PR05MB10392.namprd05.prod.outlook.com
 ([fe80::f5aa:9033:7824:c6c7%4]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 11:27:41 +0000
From: "hubert ." <hubjin657@outlook.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Topic: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Index: AQHb/VadxSWI8qLMGkSlUABnC3FxxA==
Date: Fri, 25 Jul 2025 11:27:40 +0000
Message-ID:
 <CH3PR05MB10392E816C6A1051847D214A2FA59A@CH3PR05MB10392.namprd05.prod.outlook.com>
Accept-Language: es-AR, en-US
Content-Language: es-AR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR05MB10392:EE_|SA1PR05MB8439:EE_
x-ms-office365-filtering-correlation-id: f5b70b72-873a-42b6-2d43-08ddcb6e445c
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|15080799012|15030799006|8062599012|8060799015|19110799012|440099028|40105399003|3412199025|26104999006|10035399007|3430499032|102099032;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?2AS11gATCedebM/0G1dn0Dcb4BtTfb2rLH6yDOZprfBmn/sPZZ34RSB1Rz?=
 =?iso-8859-1?Q?Gnq54wQEc44O0nUgxaIK1k2hmuYczR3sLMX2Ef2ZrYy9FyLwjjrhdx1zpv?=
 =?iso-8859-1?Q?o0AlNbBTUVhSQA7HkZd3IWLE1oYaf5ZGh513XpKE2gIgAhzJ/fdSxDZGaG?=
 =?iso-8859-1?Q?mlRGVH2CpUJfBCcMN6dDCbJdnYFIHWpnsPGf6yv6bZd7UEbxQskytE7xdc?=
 =?iso-8859-1?Q?m907FcbfLQvabCxDq4oMNd4pF5IfMhVnBINrw8DeJSlAY05pWaaRLtoojZ?=
 =?iso-8859-1?Q?2L27wXbhcY8fqEDgP/w/SVURM8gkwhQxurlWEPdNu8tJjJXMPF1oKLGX6i?=
 =?iso-8859-1?Q?vO0ZuNGJk5LcQj9x25iYRa//eE01MYvY7cLI6o3hGIPKSmWsNfjaV575ib?=
 =?iso-8859-1?Q?Uv/XyLdAJFmdVUPiS1cISVwO8m3jcRfYPhBJkuc04oSNI1lE5l23B45KkV?=
 =?iso-8859-1?Q?cMuS/UGvhqShmSUcwe/QJEXvquECwiO2tu1KvBS3bRTkfIr2rW0fw2v2/V?=
 =?iso-8859-1?Q?rr1yrw28YM/iXyYdPqQTngEtLqY9ICwcczCgF5FbBm4ArovdBWrC1iWjFc?=
 =?iso-8859-1?Q?BZD3owGhUfXnK6TIJxOvFV1MTxbxiumX2wC2EwlXPImSAYhF6cr/IsvpI4?=
 =?iso-8859-1?Q?4jLEqHec7ACTxTBLygSaTYcqOblOeJ4i5J9XwsoaRJSTILAousRwMumlbc?=
 =?iso-8859-1?Q?IY7rbMBIy7EA15kEmgXBI2l8OgZ2vSpr/Gxq87ij8MCwYRRMXWCeEuk6Vc?=
 =?iso-8859-1?Q?sFxmaJRg3URMh318ii4GxM8oIqVgXiwQgEXgjMRYAkWhIxyJVUtWaTZMSZ?=
 =?iso-8859-1?Q?L1wFUzfmszd/7SkCwi5cX77YWlkxBdY+K8zVgvb0ne87FTFGdvDqy9h1Cn?=
 =?iso-8859-1?Q?AxbJtwvRkPtcme79qQHv4qIiwmsp2+f9zHVz9WqtSCEdtAUEjb2QCpwWw5?=
 =?iso-8859-1?Q?FbQnIqgxumDGoHa7AXfOlnjE/RAlei424SoSAHOnwhVHoJXWQHC7Z7yW+A?=
 =?iso-8859-1?Q?EJz1GRsDEo7yd8vdAIA0CVs3IZJp+8omd9t8+wBTbyQT1tMlR3rIl66IO7?=
 =?iso-8859-1?Q?hwBIeoPH4kunbqMr5PLBQU020/QwEMHdXN5UAGaI8YSic2gW5oB0KQRx1M?=
 =?iso-8859-1?Q?h7aDoqzRg03H9SsxM5gNv2aMh3tcCQoJq4mtQL402Pcj4xDVnEs9mOA7at?=
 =?iso-8859-1?Q?dveSLqTpjdQ/3NxBTIRMJlF1N+DPwtSGYTDNWGB4K6ikNCf9pU7fLNQc?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Pi3pT7d0aXYdVKU+pOb5uzfLv4VStAxUVUOqoQKOszVgRRq4IsrbBFOB6D?=
 =?iso-8859-1?Q?MRm/25Fatt+YEdaZsb8sWG2Y+klkeYaRQDEFd+QwKjaqyxdttmFB/iguRK?=
 =?iso-8859-1?Q?pSUzTcZ/WJNNjBc97A9Zte9uwGfn2CoiLuwYNVSRTYZF63aj8EwyPVOv+V?=
 =?iso-8859-1?Q?cMovDyWRDgAHdSR5dmc4OjPP/iaO0JJstsKK5UcR1tfVnb60Bw9JfQuAA0?=
 =?iso-8859-1?Q?Bsgl7qDquP7oOAzKpCDmH65W87Ddm6E66gE0OqDa3ClYgGwlthpR+XXqC8?=
 =?iso-8859-1?Q?DyFWZD7+UYtH3hDDpRpfvtvKDHz9jpOEdda02V7NQSnNufknLoK4nj/r7v?=
 =?iso-8859-1?Q?zRMYrotzCWuY45zYKdjqiX7XoqsfUmveKurrIV6qHG973wSSqVxFHQwM/3?=
 =?iso-8859-1?Q?YTlR1LVUfLEdP9Se7KvJi02PC3vczfjQICpwajDUQ1py+yYPS/IwmzQkUe?=
 =?iso-8859-1?Q?GsWoha4uTDun14W20VioQtgYzG+VfuGKiNy5wkVD7pTcsqYbgg7mTEwrgM?=
 =?iso-8859-1?Q?/qvS5m2QmPWv7yiZ/pjJqbQANi2eP27zkP/DHNmEgHg7M6RbDOyr5ojJlW?=
 =?iso-8859-1?Q?t93DLayLEQ6bPd+vuOt3jGan4s4vLfZg19at6QoLcllnkdEbO4iPbp0sUW?=
 =?iso-8859-1?Q?9m9980uZGmHTOQ32+NWyfbj6OU0HAHXYfVJQuhochHPbmhgsgsZ+i9VrdF?=
 =?iso-8859-1?Q?dl0nFzgKYMXptwdAkyLdEcOlA/tEk7FK3m2ZBfi0+dBmGzNBbO7+1+5itM?=
 =?iso-8859-1?Q?pNhN+CEc/Dug1sOAn/6PH5K/zKIb02u/H2pn3X0h6CCwgm5LkvFsDNdmdv?=
 =?iso-8859-1?Q?jS07mnu5f7ca/uWxuZYYnnuc2UNgmz5O3teJzDitCKrRW/+gcQlBwpaXal?=
 =?iso-8859-1?Q?fXUixIC8eOeuMUbSL4TBLAcavZbsFDQXevvrVf5azLCY+RktueLLAh3rbZ?=
 =?iso-8859-1?Q?pyMNumoIHm1vWsXTdYssEs+oSRwOyYEPG+DDMzn1B4MW6EkyNQpA/ulbzS?=
 =?iso-8859-1?Q?QiqjAD4dsD2XY/FioOuucvuFeMaYU711EXjIoKNZzqZ246gC03pPGQAlCw?=
 =?iso-8859-1?Q?6kIcWk1if/mCvtJXAamhScpKlXV3PcB3np4HPZ/S9ovhkiu+AUqka/60Rl?=
 =?iso-8859-1?Q?HZPvZxjVO3zuhbBhZcwmYJiEJa6WqMxkU4ccOP5ix9KEqN0v6TIwItVQx6?=
 =?iso-8859-1?Q?iOusWnK2VmI5BS/+3r29xVfmunhETCEXRKr4wleanoE+QmMKbSwkyun49Q?=
 =?iso-8859-1?Q?x6d073dXZpMURm1j5PfMAiH3JW40TknjWyt8MPbUo=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: CH3PR05MB10392.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b70b72-873a-42b6-2d43-08ddcb6e445c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2025 11:27:40.9834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8439

Hi,=0A=
=0A=
A few months ago we had a serious crash in our monster RAID60 (~590TB) when=
 one of the subvolume's disks failed and then then rebuild process triggere=
d failures in other drives (you guessed it, no backup).=0A=
The hardware issues were plenty to the point where we don't rule out proble=
ms in the Areca controller either, compounding to some probably poor decisi=
ons on my part.=0A=
The rebuild took weeks to complete and we left it in a degraded state not t=
o make things worse.=0A=
The first attempt to mount it read-only of course failed. From journalctl:=
=0A=
=0A=
kernel: XFS (sdb1): Mounting V5 Filesystem=0A=
kernel: XFS (sdb1): Starting recovery (logdev: internal)=0A=
kernel: XFS (sdb1): Metadata CRC error detected at xfs_agf_read_verify+0x70=
/0x120 [xfs], xfs_agf block 0xa7fffff59=0A=
kernel: XFS (sdb1): Unmount and run xfs_repair=0A=
kernel: XFS (sdb1): First 64 bytes of corrupted metadata buffer:=0A=
kernel: ffff89b444a94400: 74 4e 5a cc ae eb a0 6d 6c 08 95 5e ed 6b a4 ff  =
tNZ....ml..^.k..=0A=
kernel: ffff89b444a94410: be d2 05 24 09 f2 0a d2 66 f3 be 3a 7b 97 9a 84  =
...$....f..:{...=0A=
kernel: ffff89b444a94420: a4 95 78 72 58 08 ca ec 10 a7 c3 20 1a a3 a6 08  =
..xrX...... ....=0A=
kernel: ffff89b444a94430: b0 43 0f d6 80 fd 12 25 70 de 7f 28 78 26 3d 94  =
.C.....%p..(x&=3D.=0A=
kernel: XFS (sdb1): metadata I/O error: block 0xa7fffff59 ("xfs_trans_read_=
buf_map") error 74 numblks 1=0A=
=0A=
Following the advice in the list, I attempted to run a xfs_metadump (xfspro=
gs 4.5.0), but after after copying 30 out of 590 AGs, it segfaulted:=0A=
/usr/sbin/xfs_metadump: line 33:  3139 Segmentation fault      (core dumped=
) xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1=0A=
=0A=
-journalctl:=0A=
xfs_db[3139]: segfault at 1015390b1 ip 0000000000407906 sp 00007ffcaef2c2c0=
 error 4 in xfs_db[400000+8a000]=0A=
=0A=
Now, the host machine is rather critical and old, running CentOS 7, 3.10 ke=
rnel on a Xeon X5650. Not trusting the hardware, I used ddrescue to clone t=
he partition to some other luckily available system.=0A=
The copy went ok(?), but it did encounter reading errors at the end, which =
confirmed my suspicion that the rebuild process was not as successful. Abou=
t 10MB could not be retrieved.=0A=
=0A=
I attempted a metadump on the copy too, now on a machine with AMD EPYC 7302=
, 128GB RAM, a 6.1 kernel and xfsprogs v6.1.0.=0A=
=0A=
# xfs_metadump -aogfw  /storage/image/sdb1.img   /storage/metadump/sdb1.met=
adump 2>&1 | tee mddump2.log=0A=
=0A=
It creates again a 280MB dump and at 30 AGs it segfaults:=0A=
=0A=
Jul24 14:47] xfs_db[42584]: segfault at 557051a1d2b0 ip 0000556f19f1e090 sp=
 00007ffe431a7be0 error 4 in xfs_db[556f19f04000+64000] likely on CPU 21 (c=
ore 9, socket 0)=0A=
[  +0.000025] Code: 00 00 00 83 f8 0a 0f 84 90 07 00 00 c6 44 24 53 00 48 6=
3 f1 49 89 ff 48 c1 e6 04 48 8d 54 37 f0 48 bf ff ff ff ff ff ff 3f 00 <48>=
 8b 02 48 8b 52 08 48 0f c8 48 c1 e8 09 48 0f ca 81 e2 ff ff 1f=0A=
=0A=
This is the log https://pastebin.com/jsSFeCr6, which looks similar to the f=
irst one. The machine does not seem loaded at all and further tries result =
in the same code. =0A=
=0A=
My next step would be trying a later xfsprogs version, or maybe xfs_repair =
-n on a compatible CPU machine as non-destructive options, but I feel I'm k=
idding myself as to what I can try to recover anything at all from such hum=
ongous disaster.=0A=
=0A=
Thanks in advance for any input=0A=
Hub=
