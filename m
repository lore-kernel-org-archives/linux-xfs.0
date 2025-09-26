Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19011068.outbound.protection.outlook.com [52.103.23.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C65D72608
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 09:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.23.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758877458; cv=fail; b=qSeDsaeTpcsblQkHVjkA9u16WB99PqmqQ+lR1YoIP5fG/so6H+2N37tKvXnp/Wj0EYQ04RYxbY753PpUXnQwOW3Vcskk2Kne8N80vcrIxd368/o/Q68KBl96QzfaWT1HPXr0y7pPYsXHX7uloqOlpttNjkjmWb3R7dKQTmPk9Rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758877458; c=relaxed/simple;
	bh=3YsHm/dTT4DtQej+csaNIIXd+w3ZSQv54B0Qqo9mLwo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tM9yHZ27M7wgTOSdLOzr6EF1NYJP78T53/WI1DI7QGR+/6GqeouNBEZ6Tlx7UcVYsg18ExnPi5dbQkh4MJNu8v66Vbi1rg7LAQmZoqF0pySO/CxFqhKBvCGqqzZkOETkqziO/BhKETdiQAEtybL4Sx4p6s7koV9wtfqC2XRXEqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=nWD2gfq2; arc=fail smtp.client-ip=52.103.23.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="nWD2gfq2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VqM7b4Sk2L9U8jlQw7CyqfgSRLFJNMzqZpU79PDubV0DtcFoIlobWat0QCSGMa2bj4gdLD0jgSfTTHZogMDtOvrIqJ1cMb7fkKOzZk5OhsJk14iChoglD5EtMTxRmiM982kQwGmenFOu5FS2L39OoJfw7u0epgFggsrYE+Baq6vnJ/1LUcAQ1K+LswIt7xOURzvEk1S/xF5Y7xJVyUtOJcegv+jZyzphCFWkWty0xEP9IRNUSTKQrslvCTnTVV48sEfnRVOibPGh8VEfSfI9R2yaTkF9Qz5kVtAOmcM3Lk8Fy+L2v7J2b+K3fKqFM59pkPKlJ3ZgFvoeTrTv7opqWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFa+OCQ2TFfoanTrEv08O5ZSiCuepVOC5I/zthbc9qs=;
 b=no9oARmpn71n5yiV8Bjtb4gciF3kQzUvMjR+Pix/QfQxdfA2jM3R3oijk1qySi+TFXLz6mds8dZwHVoHaOJR2sTTD1Dpodx534p3A0syo3ZJCL/Yw7qz1pOtaV95DH6otPn9btsWMzfz5O3PMKeJlyhjmYORycJFNdGCvHVjh/9rWaqV+r3FaQEqK6cASXCrAzk7X9S+8xmaykjLoCQI9s/3BLqmIkV+Hbzh22Xvq996e0R3vHBooAASOWbOF3Nre8sYSw7hNUfNB9UHtpr7oJ0QP+QYv7dk0BW7xXdSVsWl5hQrbuvOdCdA7aOremxlk0AQCk2At3CwxBEkRFHWbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFa+OCQ2TFfoanTrEv08O5ZSiCuepVOC5I/zthbc9qs=;
 b=nWD2gfq2hNCgKKGh4+PKtj60+3tnkBEknTFVY4oRqE9vklDHoeNPkqb/t5oQQsnp/XNEjfXG1pmpLRz0qfYwTA1dY1nEAoNcwHG5ijR6lJQ94xpacBJ2+3Wt7EZq4ftMcVm6Wwl8Og++itkL17o2LaOWY4s5VK5a5KUMz/wxaXmk6CcUMbHx89QAg/Ocob6/wfbpHmsxWWy/g9XsbkxgDq8t3qemEjO9YwVCkv/kL1/qeOyxYBWvltll5oPkEAtjSQgCuj1BhsnehIkfRphE25dgMkSBs43C42Lr6AmSstacvQdEx0vJmzOpOi3nqFp9d+/4pbB3rRPZ97jOOIrzlQ==
Received: from IA0PR05MB9975.namprd05.prod.outlook.com (2603:10b6:208:408::13)
 by SA1PR05MB7983.namprd05.prod.outlook.com (2603:10b6:806:189::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Fri, 26 Sep
 2025 09:04:12 +0000
Received: from IA0PR05MB9975.namprd05.prod.outlook.com
 ([fe80::61ae:deb3:28b6:f1f7]) by IA0PR05MB9975.namprd05.prod.outlook.com
 ([fe80::61ae:deb3:28b6:f1f7%3]) with mapi id 15.20.9137.018; Fri, 26 Sep 2025
 09:04:12 +0000
From: "hubert ." <hubjin657@outlook.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Topic: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Thread-Index:
 AQHb/VadxSWI8qLMGkSlUABnC3FxxLRDxpcAgAoR9+KAGtxzMIAKen+AgANVmD+ALwamzg==
Date: Fri, 26 Sep 2025 09:04:12 +0000
Message-ID:
 <IA0PR05MB99755ED06F9965745B20D9DAFA1EA@IA0PR05MB9975.namprd05.prod.outlook.com>
References:
 <f9Etb2La9b1KOT-5VdCdf6cd10olyT-FsRb8AZh8HNI1D4Czb610tw4BE15cNrEhY5OiXDGS7xR6R1trRyn1LA==@protonmail.internalid>
 <CH3PR05MB10392E816C6A1051847D214A2FA59A@CH3PR05MB10392.namprd05.prod.outlook.com>
 <6tqlc3mcf3ovkbzf4345m7oztoeagevfycpdnxizrtdbhq53p2@mrlmjhs6n7gy>
 <LV3PR05MB104071E0D6E7CAD06C7728DACFA26A@LV3PR05MB10407.namprd05.prod.outlook.com>
 <kZ0Ndjz5Uh9rHFbs-iYYoEFNVWoxMtkvK-3nrx6mrlxpglTxelNWuY_lqxKmfrItAPWl4M4ng-BzenCqcFiOaA==@protonmail.internalid>
 <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <gjogpxo65cozoccj4fps6e4fzeu4ncibeofymhkyzys4hsclzy@vvrl2kndu7k6>
 <IA0PR05MB9975ADAF48C73797473737BEFA38A@IA0PR05MB9975.namprd05.prod.outlook.com>
In-Reply-To:
 <IA0PR05MB9975ADAF48C73797473737BEFA38A@IA0PR05MB9975.namprd05.prod.outlook.com>
Accept-Language: en-US, es-AR
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR05MB9975:EE_|SA1PR05MB7983:EE_
x-ms-office365-filtering-correlation-id: 094f4212-45dd-461d-c401-08ddfcdba90d
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|15080799012|31061999003|12121999013|15030799006|8062599012|8060799015|19110799012|1602099012|40105399003|440099028|3412199025|4302099013|10035399007|102099032|12091999003|26104999006;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?zqLKAGXi45Sut6fYOQMZKeB3I5t/kAiCiJ3XQktNflL3SWvwT5I09h9ujV?=
 =?iso-8859-1?Q?K0X5ddl+nGDbwYR0XYgxTphpEx4OCWYi16xblmdLOZhhMy4wlQEIFlP/c0?=
 =?iso-8859-1?Q?e6/nBPOaSDDn3RK2mYf9SNwNlLGP4vXLvaRWDGqgtb5bDXViUx9rYidae3?=
 =?iso-8859-1?Q?uzKEriZIjaZe9VLeHxjpEXG9MtOF91Rpw0XifHDSNcz8Pi52dMtONSFkbp?=
 =?iso-8859-1?Q?KgFRlf0JQr9EtLJv29ar3HMOYSt4/vmgQozl7FYEiZ8qTv04el0xqGeMyf?=
 =?iso-8859-1?Q?MrWGK4hahdcyiS6hmOq9kBaWyLeqVOFzXi8KgtLZ4XEZMiMv6fDVMMcdlZ?=
 =?iso-8859-1?Q?j5drJHg7bEOoZ2MwDuwxhWhakXjhn+G5fMISDvyJHdcaCxnERsC6NHfMqR?=
 =?iso-8859-1?Q?lWVGP/OS2fH3bPYLqc6X8oQI/3moEgQq8eqZvdrxPKLFdGA/bAkvfH8HGu?=
 =?iso-8859-1?Q?n/kuoqhVSv4nTqQjnI2FIMGWiC21xVxd2+el3DvLE6/i7n8cRjGPjbdgIe?=
 =?iso-8859-1?Q?uL2z7ZAg4fSLJpHCFFz+GMuVuNTVxVZJLZvC/EA9ov3r78r1KcHBeQmn5x?=
 =?iso-8859-1?Q?VpmFCVyCpvBdYxDvp5/IODY+am8m0AShHwRMZrnHMA/DEsDv0JAMLjULel?=
 =?iso-8859-1?Q?9UrATTvr68Fff+1DM6HAdj8YaeWC1d6q9RS2j3YIQXLQRpDpT6cLwi0kid?=
 =?iso-8859-1?Q?4C77Kbbjth5N61H6whON4DKpaBp3qO62dt/JPRV9+NHU6ifYGWyNm1EBvb?=
 =?iso-8859-1?Q?egl2hLjrLCGkn9fuwnjAxM+63Gf6VYBZ7iApvN1y+navpUePPsb29coKWZ?=
 =?iso-8859-1?Q?oQdNWNIHvpoho8zh12cNYnTcpPrWaSLFsK5LsGQYjALt6jwPNOHAJr66O6?=
 =?iso-8859-1?Q?1Mzx6TddEGq0UO9e23wTaNxysjohgVXecy+ZPNTicnRult3pOXZkS7/ZuP?=
 =?iso-8859-1?Q?30QZyfK32f0ztA9+UmqSyBFbERlblVVKZXnGzMEGDo4ynCpdk4gLTVWc/W?=
 =?iso-8859-1?Q?u6Cv2dCW9KFpqMm4bmDFcDL8I1IXoBZ1nkTrs/8peGlUhq2uEfeeUIh2qz?=
 =?iso-8859-1?Q?xBpa8p4x8RkWOFZijrSY5p0K1Qe1LWwzgkTBq4sRG2Y4ivRHD8zJo+LiNE?=
 =?iso-8859-1?Q?6r9wnJTBAXZX7yF9Ef33Ds3FXAVNhqK49fwcIv5AGUJuPdg6/apNy9uB6c?=
 =?iso-8859-1?Q?lc/HrmdtH5wWGAU/WuMseD6rh8Nw2Fqp0uoL2yr6p48SJIDdAs6GW9ZJBx?=
 =?iso-8859-1?Q?P4KcWEG9G/bmNBKjpUSJtcUmcGm6ELPkKAnXtKXpwdnyaELWr9QCoz1SXC?=
 =?iso-8859-1?Q?bO6cHLPlUo9qUHazoDmu5OXKqzfgvOitHfu6hr4P/u7L88m+/IO00+n261?=
 =?iso-8859-1?Q?TFkUtR/MJOMcBBNfBpCR5YIu3BAhrlneBPdapvH29x1PZleq+qK54=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?fMapyNN87iQ/ZD0UAzijshXuRhn1nhFWqXziG2kmPufOlhXPzcFYEMS0iP?=
 =?iso-8859-1?Q?xnkyo2z/QhAlOEtBvi55IILFJiEFvxsBsT4uLCjtprsW6bLiSr3/4VEoPq?=
 =?iso-8859-1?Q?NLOltVq28PuXcjATj7w5dQwE4tfqlTER0oYvKS/nTzXYR2Bl3KJvUTLeRF?=
 =?iso-8859-1?Q?aMy0T6As57EkJqrjhJP/ODXvS1jIS09h7tSJ+/YrmB1xwJf03S3L74E/gu?=
 =?iso-8859-1?Q?C5iN9tz+XceOvN/gOAEcXVmPpKtKZ7x6g5dLNzioS6lnjVqnZb7CEo9t+m?=
 =?iso-8859-1?Q?L+eGuI3aQsyNa6Iw+g8uydYQqmxlHLjJa5ZVAkqDTAxE1hXFXIW2YDyTJu?=
 =?iso-8859-1?Q?YXRHNzUY9Tn8CXCkqvCzLnzKXtJCUfty55//fQWvoWLx54ngcWBnkneffv?=
 =?iso-8859-1?Q?qHIx8JRf03kaos/xkzl+ObZE0rbkotrf9gH/dPQcoJP6f0cpYIvAthHP4P?=
 =?iso-8859-1?Q?0pAnypwVoHJpOwWY/wYFgNIGf0x0S32vD6C00k+2vsj+sTFz+k1jjwhf2V?=
 =?iso-8859-1?Q?ynIJOhDEHz6GhzdbQOEjDARKIfP8HU2mxidXynA/g3cJG+lBIrSfhQ+F6X?=
 =?iso-8859-1?Q?kKi1S1xHodvlznew1i6gYpPxd/G+VPtuwT8ask2oo67tpedlIdknS0hRzk?=
 =?iso-8859-1?Q?hMOdjezkEf0G3sr3dct7KRG5iBptErfpK90rT9z9inMVgn+OW+muqlG65p?=
 =?iso-8859-1?Q?iyJMxW8sG9naBMIsSco11scewzvXFzuSXyaQ2M5azrx4JNiz0WgejIsW/R?=
 =?iso-8859-1?Q?AXQJPaLWVP4TxPqa9oLIEEDp/P5Lg3q5rWArZBtQXobsAt+t1sFFnwL3oV?=
 =?iso-8859-1?Q?q5L+3ZRy0p88tOgUOhcQVoK0Ys8StoUGPR+yNGq/MxCrZeUDNtrJT9vWW8?=
 =?iso-8859-1?Q?l5XDM2lbe3NZeFzA/KrJ5WdsTppnFfA6cA6eya2SwRISVN5giCxtpT4Ppj?=
 =?iso-8859-1?Q?oT21D4BCmspUKOaG5Fugf2RtfPUYyFd+uoLeDZPmw0rBmlcVoGH/56wwLo?=
 =?iso-8859-1?Q?ONYp4LBP1wslImH0YzI4F/92Xfolr2NQFr1ql1iRQ/NT5OPSxOy6t9nG6I?=
 =?iso-8859-1?Q?ABRLQHZs2LhSCNAhtEVVO4vWwOjTQMwsWw1i322WZaqn3faIDWCqO3n3xm?=
 =?iso-8859-1?Q?Y7Plsum6KuKs3MI+GtHA1UHcYCBRil/7eSkRIW6IfKiyRJ+baprWEQmQ1y?=
 =?iso-8859-1?Q?TDJBisqfGDbk1JDKGPUI1JfGlhl75W1zQbeHdyrAVuOU+MGKQiHxZpp5Sw?=
 =?iso-8859-1?Q?HiAV3w1LR1R41HiSZy1TascMgsVjTauGqPA/InDfM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 094f4212-45dd-461d-c401-08ddfcdba90d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 09:04:12.0398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB7983

=0A=
>> Hello Hubert, my apologies for the delay.=0A=
> No problem, Carlos, I'm also juggling several things, thanks for the foll=
ow-up=0A=
>=0A=
>> On Mon, Aug 18, 2025 at 03:56:53PM +0000, hubert . wrote:=0A=
>>> Am 18.08.25 um 17:14 schrieb hubert .:=0A=
>>>> Am 26.07.25 um 00:52 schrieb Carlos Maiolino:=0A=
>>>>> On Fri, Jul 25, 2025 at 11:27:40AM +0000, hubert . wrote:=0A=
>>>>>> Hi,=0A=
>>>>>>=0A=
>>>>>> A few months ago we had a serious crash in our monster RAID60 (~590T=
B) when one of the subvolume's disks failed and then then rebuild process t=
riggered failures in other drives (you guessed it, no backup).=0A=
>>>>>> The hardware issues were plenty to the point where we don't rule out=
 problems in the Areca controller either, compounding to some probably poor=
 decisions on my part.=0A=
>>>>>> The rebuild took weeks to complete and we left it in a degraded stat=
e not to make things worse.=0A=
>>>>>> The first attempt to mount it read-only of course failed. From journ=
alctl:=0A=
>>>>>>=0A=
>>>>>> kernel: XFS (sdb1): Mounting V5 Filesystem=0A=
>>>>>> kernel: XFS (sdb1): Starting recovery (logdev: internal)=0A=
>>>>>> kernel: XFS (sdb1): Metadata CRC error detected at xfs_agf_read_veri=
fy+0x70/0x120 [xfs], xfs_agf block 0xa7fffff59=0A=
>>>>>> kernel: XFS (sdb1): Unmount and run xfs_repair=0A=
>>>>>> kernel: XFS (sdb1): First 64 bytes of corrupted metadata buffer:=0A=
>>>>>> kernel: ffff89b444a94400: 74 4e 5a cc ae eb a0 6d 6c 08 95 5e ed 6b =
a4 ff  tNZ....ml..^.k..=0A=
>>>>>> kernel: ffff89b444a94410: be d2 05 24 09 f2 0a d2 66 f3 be 3a 7b 97 =
9a 84  ...$....f..:{...=0A=
>>>>>> kernel: ffff89b444a94420: a4 95 78 72 58 08 ca ec 10 a7 c3 20 1a a3 =
a6 08  ..xrX...... ....=0A=
>>>>>> kernel: ffff89b444a94430: b0 43 0f d6 80 fd 12 25 70 de 7f 28 78 26 =
3d 94  .C.....%p..(x&=3D.=0A=
>>>>>> kernel: XFS (sdb1): metadata I/O error: block 0xa7fffff59 ("xfs_tran=
s_read_buf_map") error 74 numblks 1=0A=
>>>>>>=0A=
>>>>>> Following the advice in the list, I attempted to run a xfs_metadump =
(xfsprogs 4.5.0), but after after copying 30 out of 590 AGs, it segfaulted:=
=0A=
>>>>>> /usr/sbin/xfs_metadump: line 33:  3139 Segmentation fault      (core=
 dumped) xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1=0A=
>>>>> I'm not sure what you expect from a metadump, this is usually used fo=
r=0A=
>>>>> post-mortem analysis, but you already know what went wrong and why=0A=
>>>> I was hoping to have a restored metadata file I could try things on=0A=
>>>> without risking the copy, since it's not possible to have a second one=
=0A=
>>>> with this inordinate amount of data.=0A=
>>>>=0A=
>>>>>> -journalctl:=0A=
>>>>>> xfs_db[3139]: segfault at 1015390b1 ip 0000000000407906 sp 00007ffca=
ef2c2c0 error 4 in xfs_db[400000+8a000]=0A=
>>>>>>=0A=
>>>>>> Now, the host machine is rather critical and old, running CentOS 7, =
3.10 kernel on a Xeon X5650. Not trusting the hardware, I used ddrescue to =
clone the partition to some other luckily available system.=0A=
>>>>>> The copy went ok(?), but it did encounter reading errors at the end,=
 which confirmed my suspicion that the rebuild process was not as successfu=
l. About 10MB could not be retrieved.=0A=
>>>>>>=0A=
>>>>>> I attempted a metadump on the copy too, now on a machine with AMD EP=
YC 7302, 128GB RAM, a 6.1 kernel and xfsprogs v6.1.0.=0A=
>>>>>>=0A=
>>>>>> # xfs_metadump -aogfw  /storage/image/sdb1.img   /storage/metadump/s=
db1.metadump 2>&1 | tee mddump2.log=0A=
>>>>>>=0A=
>>>>>> It creates again a 280MB dump and at 30 AGs it segfaults:=0A=
>>>>>>=0A=
>>>>>> Jul24 14:47] xfs_db[42584]: segfault at 557051a1d2b0 ip 0000556f19f1=
e090 sp 00007ffe431a7be0 error 4 in xfs_db[556f19f04000+64000] likely on CP=
U 21 (core 9, socket 0)=0A=
>>>>>> [  +0.000025] Code: 00 00 00 83 f8 0a 0f 84 90 07 00 00 c6 44 24 53 =
00 48 63 f1 49 89 ff 48 c1 e6 04 48 8d 54 37 f0 48 bf ff ff ff ff ff ff 3f =
00 <48> 8b 02 48 8b 52 08 48 0f c8 48 c1 e8 09 48 0f ca 81 e2 ff ff 1f=0A=
>>>>>>=0A=
>>>>>> This is the log https://pastebin.com/jsSFeCr6, which looks similar t=
o the first one. The machine does not seem loaded at all and further tries =
result in the same code.=0A=
>>>>>>=0A=
>>>>>> My next step would be trying a later xfsprogs version, or maybe xfs_=
repair -n on a compatible CPU machine as non-destructive options, but I fee=
l I'm kidding myself as to what I can try to recover anything at all from s=
uch humongous disaster.=0A=
>>>>> Yes, that's probably the best approach now. To run the latest xfsprog=
s=0A=
>>>>> available.=0A=
>>>> Ok, so I ran into some unrelated issues, but I could finally install x=
fsprogs 6.15.0:=0A=
>>>>=0A=
>>>> root@serv:~# xfs_metadump -aogfw /storage/image/sdb1.img  /storage/met=
adump/sdb1.metadump=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: data size check failed=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot init perag data (22). Continuing anyway.=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> empty log check failed=0A=
>>>> xlog_is_dirty: cannot find log head/tail (xlog_find_tail=3D-22)=0A=
>>>>=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read superblock for ag 0=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agf block for ag 0=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agi block for ag 0=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agfl block for ag 0=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read superblock for ag 1=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agf block for ag 1=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agi block for ag 1=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agfl block for ag 1=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read superblock for ag 2=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agf block for ag 2=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agi block for ag 2=0A=
>>>> ...=0A=
>>>> ...=0A=
>>>> ...=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agfl block for ag 588=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read superblock for ag 589=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agf block for ag 589=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agi block for ag 589=0A=
>>>> xfs_metadump: read failed: Invalid argument=0A=
>>>> xfs_metadump: cannot read agfl block for ag 589=0A=
>>>> Copying log=0A=
>>>> root@serv:~#=0A=
>>>>=0A=
>>>> It did create a 2.1GB dump which of course restores to an empty file.=
=0A=
>>>>=0A=
>>>> I thought I had messed up with some of the dependency libs, so then I=
=0A=
>>>> tried with xfsprogs 6.13 in Debian testing, same result.=0A=
>>>>=0A=
>>>> I'm not exactly sure why now it fails to read the image; nothing has=
=0A=
>>>> changed about it. I could not find much more info in the documentation=
.=0A=
>>>> What am I missing..?=0A=
>>> I tried a few more things on the img, as I realized it was probably not=
=0A=
>>> the best idea to dd it to a file instead of a device, but I got nowhere=
.=0A=
>>> After some team deliberations, we decided to connect the original block=
=0A=
>>> device to the new machine (Debian 13, 16 AMD cores, 128RAM, new=0A=
>>> controller, plenty of swap, xfsprogs 6.13) and and see if the dump was =
possible then.=0A=
>>>=0A=
>>> It had the same behavior as with with xfsprogs 6.1 and segfauled after=
=0A=
>>> 30 AGs. journalctl and dmesg don't really add any more info, so I tried=
=0A=
>>> to debug a bit, though I'm afraid it's all quite foreign to me:=0A=
>>>=0A=
>>> root@ap:/metadump# gdb xfs_metadump core.12816=0A=
>>> GNU gdb (Debian 16.3-1) 16.3=0A=
>>> Copyright (C) 2024 Free Software Foundation, Inc.=0A=
>>> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl=
.html>=0A=
>>> This is free software: you are free to change and redistribute it.=0A=
>>> There is NO WARRANTY, to the extent permitted by law.=0A=
>>> ...=0A=
>>> Type "apropos word" to search for commands related to "word"...=0A=
>>> "/usr/sbin/xfs_metadump": not in executable format: file format not rec=
ognized=0A=
>>> [New LWP 12816]=0A=
>>> Reading symbols from /usr/sbin/xfs_db...=0A=
>>> (No debugging symbols found in /usr/sbin/xfs_db)=0A=
>>> [Thread debugging using libthread_db enabled]=0A=
>>> Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.=
1".=0A=
>>> Core was generated by `/usr/sbin/xfs_db -i -p xfs_metadump -c metadump =
/dev/sda1'.=0A=
>>> Program terminated with signal SIGSEGV, Segmentation fault.=0A=
>>> #0  0x0000556f127d6857 in ?? ()=0A=
>>> (gdb) bt full=0A=
>>> #0  0x0000556f127d6857 in ?? ()=0A=
>>> No symbol table info available.=0A=
>>> #1  0x0000556f127dbdc4 in ?? ()=0A=
>>> No symbol table info available.=0A=
>>> #2  0x0000556f127d5546 in ?? ()=0A=
>>> No symbol table info available.=0A=
>>> #3  0x0000556f127db350 in ?? ()=0A=
>>> No symbol table info available.=0A=
>>> #4  0x0000556f127d5546 in ?? ()=0A=
>>> No symbol table info available.=0A=
>>> #5  0x0000556f127d99aa in ?? ()=0A=
>>> No symbol table info available.=0A=
>>> #6  0x0000556f127b9764 in ?? ()=0A=
>>> No symbol table info available.=0A=
>>> #7  0x00007eff29058ca8 in ?? () from /lib/x86_64-linux-gnu/libc.so.6=0A=
>>> No symbol table info available.=0A=
>>> #8  0x00007eff29058d65 in __libc_start_main () from /lib/x86_64-linux-g=
nu/libc.so.6=0A=
>>> No symbol table info available.=0A=
>>> #9  0x0000556f127ba8c1 in ?? ()=0A=
>>> No symbol table info available.=0A=
>>>=0A=
>>> And this:=0A=
>>>=0A=
>>> root@ap:/PETA/metadump# coredumpctl info=0A=
>>>             PID: 13103 (xfs_db)=0A=
>>>             UID: 0 (root)=0A=
>>>             GID: 0 (root)=0A=
>>>          Signal: 11 (SEGV)=0A=
>>>       Timestamp: Mon 2025-08-18 19:03:19 CEST (1min 12s ago)=0A=
>>>    Command Line: xfs_db -i -p xfs_metadump -c metadump -a -o -g -w $' /=
metadump/metadata.img' /dev/sda1=0A=
>>>      Executable: /usr/sbin/xfs_db=0A=
>>>   Control Group: /user.slice/user-0.slice/session-8.scope=0A=
>>>            Unit: session-8.scope=0A=
>>>           Slice: user-0.slice=0A=
>>>         Session: 8=0A=
>>>       Owner UID: 0 (root)=0A=
>>>         Boot ID: c090e507272647838c77bcdefd67e79c=0A=
>>>      Machine ID: 83edcebe83994c67ac4f88e2a3c185e3=0A=
>>>        Hostname: ap=0A=
>>>         Storage: /var/lib/systemd/coredump/core.xfs_db.0.c090e507272647=
838c77bcdefd67e79c.13103.1755536599000000.zst (present)=0A=
>>>    Size on Disk: 26.2M=0A=
>>>         Message: Process 13103 (xfs_db) of user 0 dumped core.=0A=
>>>=0A=
>>>                  Module libuuid.so.1 from deb util-linux-2.41-5.amd64=
=0A=
>>>                  Stack trace of thread 13103:=0A=
>>>                  #0  0x000055b961d29857 n/a (/usr/sbin/xfs_db + 0x32857=
)=0A=
>>>                  #1  0x000055b961d2edc4 n/a (/usr/sbin/xfs_db + 0x37dc4=
)=0A=
>>>                  #2  0x000055b961d28546 n/a (/usr/sbin/xfs_db + 0x31546=
)=0A=
>>>                  #3  0x000055b961d2e350 n/a (/usr/sbin/xfs_db + 0x37350=
)=0A=
>>>                  #4  0x000055b961d28546 n/a (/usr/sbin/xfs_db + 0x31546=
)=0A=
>>>                  #5  0x000055b961d2c9aa n/a (/usr/sbin/xfs_db + 0x359aa=
)=0A=
>>>                  #6  0x000055b961d0c764 n/a (/usr/sbin/xfs_db + 0x15764=
)=0A=
>>>                  #7  0x00007fc870455ca8 n/a (libc.so.6 + 0x29ca8)=0A=
>>>                  #8  0x00007fc870455d65 __libc_start_main (libc.so.6 + =
0x29d65)=0A=
>>>                  #9  0x000055b961d0d8c1 n/a (/usr/sbin/xfs_db + 0x168c1=
)=0A=
>>>                  ELF object binary architecture: AMD x86-64=0A=
>> Without the debug symbols it get virtually impossible to know what=0A=
>> was going on =3D/=0A=
>>> I guess my questions are: can the fs be so corrupted that it causes=0A=
>>> xfs_metadump (or xfs_db) to segfault? Are there too many AGs / fs too=
=0A=
>>> large?=0A=
>>> Shall I assume that xfs_repair could fail similarly then?=0A=
>> In a nutshell xfs_metadump shouldn't segfault even if the fs is=0A=
>> corrupted.=0A=
>> About xfs_repair, it depends, there is some code shared between both,=0A=
>> but xfs_repair is much more resilient.=0A=
>>=0A=
>>> I'll appreciate any ideas. Also, if you think the core dump or other lo=
gs=0A=
>>> could be useful, I can upload them somewhere.=0A=
>> I'd start by running xfs_repair in no-modify mode, i.e. `xfs_repair -n`=
=0A=
>> and check what it finds.=0A=
>>=0A=
>> Regarding the xfs_metadump segfault, yes, a core might be useful to=0A=
>> investigate where the segfault is triggered, but you'll need to be=0A=
>> running xfsprogs from the upstream tree (preferentially latest code), so=
=0A=
>> we can actually match the core information the code.=0A=
>=0A=
> I figured it was not all the needed info, thanks for clarifying.=0A=
>=0A=
> Right now we had to put away the original hdds, as we cannot afford=0A=
> another failed drive and time is pressing, and are dd'ing the image to a=
=0A=
> real partition to try xfs_repair on it directly (takes days, of course,=
=0A=
> but we're lucky we got the storage).=0A=
> I will try the metadump and do further debugging if it segfaults again.=
=0A=
=0A=
So I'm back now with a real partition. =0A=
First, I ran "xfs_repair -vn" and it did complete, reporting - as expected =
- a =0A=
bunch of entries to junk, skipping the last phases with "Inode allocation =
=0A=
btrees are too corrupted, skipping phases 6 and 7".=0A=
It created a 270MB log, I can upload it somewhere if it could be of interes=
t.=0A=
=0A=
Since clearly xfs_repair will throw away a lot of stuff, I pulled xfsprogs =
=0A=
from git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git (hope that's the right =
=0A=
one), and tried again xfs_metadump on the partition. =0A=
It segfaulted as last time, but this time I hope to have more useful info:=
=0A=
=0A=
root@ap:/XFS/repair# coredumpctl debug 70665=0A=
           PID: 70665 (xfs_db)=0A=
           UID: 0 (root)=0A=
           GID: 0 (root)=0A=
        Signal: 11 (SEGV)=0A=
     Timestamp: Thu 2025-09-25 19:10:54 CEST (16h ago)=0A=
  Command Line: xfs_db -i -p xfs_metadump -c metadump -a -o -g -w $' /XFS/s=
da1.metadump' /dev/sda1=0A=
    Executable: /usr/sbin/xfs_db=0A=
 Control Group: /user.slice/user-0.slice/session-52.scope=0A=
          Unit: session-52.scope=0A=
         Slice: user-0.slice=0A=
       Session: 52=0A=
     Owner UID: 0 (root)=0A=
       Boot ID: 7b209b8c777947ef9f286a69376f109f=0A=
    Machine ID: 83edcebe83994c67ac4f88e2a3c185e3=0A=
      Hostname: ap=0A=
       Storage: /var/lib/systemd/coredump/core.xfs_db.0.7b209b8c777947ef9f2=
86a69376f109f.70665.1758820254000000.zst (present)=0A=
  Size on Disk: 24.3M=0A=
       Message: Process 70665 (xfs_db) of user 0 dumped core.=0A=
                =0A=
                Module libuuid.so.1 from deb util-linux-2.41-5.amd64=0A=
                Stack trace of thread 70665:=0A=
                #0  0x000055c36404aca3 libxfs_bmbt_disk_get_all (/usr/sbin/=
xfs_db + 0x34ca3)=0A=
                #1  0x000055c36404e042 process_exinode (/usr/sbin/xfs_db + =
0x38042)=0A=
                #2  0x000055c36404a182 scan_btree (/usr/sbin/xfs_db + 0x341=
82)=0A=
                #3  0x000055c36404da9b scanfunc_ino (/usr/sbin/xfs_db + 0x3=
7a9b)=0A=
                #4  0x000055c36404a182 scan_btree (/usr/sbin/xfs_db + 0x341=
82)=0A=
                #5  0x000055c36404d2d8 copy_inodes (/usr/sbin/xfs_db + 0x37=
2d8)=0A=
                #6  0x000055c36402ca64 main (/usr/sbin/xfs_db + 0x16a64)=0A=
                #7  0x00007fe91bce2ca8 n/a (libc.so.6 + 0x29ca8)=0A=
                #8  0x00007fe91bce2d65 __libc_start_main (libc.so.6 + 0x29d=
65)=0A=
                #9  0x000055c36402dba1 _start (/usr/sbin/xfs_db + 0x17ba1)=
=0A=
                ELF object binary architecture: AMD x86-64=0A=
=0A=
GNU gdb (Debian 16.3-1) 16.3=0A=
...=0A=
Find the GDB manual and other documentation resources online at:=0A=
    <http://www.gnu.org/software/gdb/documentation/>.=0A=
=0A=
For help, type "help".=0A=
Type "apropos word" to search for commands related to "word"...=0A=
Reading symbols from /usr/sbin/xfs_db...=0A=
Reading symbols from /usr/lib/debug/.build-id/3d/2cfd2face51733516278556a90=
24e640d64678.debug...=0A=
[New LWP 70665]=0A=
[Thread debugging using libthread_db enabled]=0A=
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".=
=0A=
Core was generated by `/usr/sbin/xfs_db -i -p xfs_metadump -c metadump /dev=
/sda1'.=0A=
Program terminated with signal SIGSEGV, Segmentation fault.=0A=
#0  libxfs_bmbt_disk_get_all (rec=3D0x55c47aec3eb0, irec=3D<synthetic point=
er>) at ../include/libxfs.h:226=0A=
=0A=
warning: 226	../include/libxfs.h: No such file or directory=0A=
(gdb) bt full=0A=
#0  libxfs_bmbt_disk_get_all (rec=3D0x55c47aec3eb0, irec=3D<synthetic point=
er>) at ../include/libxfs.h:226=0A=
        l0 =3D <optimized out>=0A=
        l1 =3D <optimized out>=0A=
        l0 =3D <optimized out>=0A=
        l1 =3D <optimized out>=0A=
#1  convert_extent (rp=3D0x55c47aec3eb0, op=3D<synthetic pointer>, sp=3D<sy=
nthetic pointer>, cp=3D<synthetic pointer>, fp=3D<synthetic pointer>) at /b=
uild/reproducible-path/xfsprogs-6.16.0/db/bmap.c:320=0A=
        irec =3D <optimized out>=0A=
        irec =3D <optimized out>=0A=
#2  process_bmbt_reclist (dip=3Ddip@entry=3D0x55c37aec3e00, whichfork=3Dwhi=
chfork@entry=3D0, rp=3D0x55c37aec3eb0, numrecs=3Dnumrecs@entry=3D268435457)=
 at /build/reproducible-path/xfsprogs-6.16.0/db/metadump.c:2181=0A=
        is_meta =3D false=0A=
        btype =3D <optimized out>=0A=
        i =3D <optimized out>=0A=
        o =3D <optimized out>=0A=
        op =3D <optimized out>=0A=
        s =3D <optimized out>=0A=
        c =3D <optimized out>=0A=
        cp =3D <optimized out>=0A=
        f =3D <optimized out>=0A=
        last =3D <optimized out>=0A=
        agno =3D <optimized out>=0A=
        agbno =3D <optimized out>=0A=
        rval =3D <optimized out>=0A=
#3  0x000055c36404e042 in process_exinode (dip=3D0x55c37aec3e00, whichfork=
=3D0) at /build/reproducible-path/xfsprogs-6.16.0/db/metadump.c:2421=0A=
        max_nex =3D <optimized out>=0A=
        nex =3D 268435457=0A=
        used =3D <optimized out>=0A=
        max_nex =3D <optimized out>=0A=
        nex =3D <optimized out>=0A=
        used =3D <optimized out>=0A=
#4  process_inode_data (dip=3D0x55c37aec3e00) at /build/reproducible-path/x=
fsprogs-6.16.0/db/metadump.c:2589=0A=
No locals.=0A=
#5  process_inode (agno=3D<optimized out>, agino=3D<optimized out>, dip=3D0=
x55c37aec3e00, free_inode=3D<optimized out>) at /build/reproducible-path/xf=
sprogs-6.16.0/db/metadump.c:2678=0A=
        rval =3D 1=0A=
        crc_was_ok =3D <optimized out>=0A=
        need_new_crc =3D false=0A=
        rval =3D <optimized out>=0A=
        crc_was_ok =3D <optimized out>=0A=
        need_new_crc =3D <optimized out>=0A=
        done =3D <optimized out>=0A=
#6  copy_inode_chunk (agno=3D<optimized out>, rp=3D<optimized out>) at /bui=
ld/reproducible-path/xfsprogs-6.16.0/db/metadump.c:2821=0A=
        dip =3D 0x55c37aec3e00=0A=
        agbno =3D <optimized out>=0A=
        rval =3D 0=0A=
        blks_per_buf =3D <optimized out>=0A=
        agino =3D <optimized out>=0A=
        off =3D <optimized out>=0A=
        inodes_per_buf =3D <optimized out>=0A=
        end_agbno =3D <optimized out>=0A=
        i =3D 17=0A=
        ioff =3D <optimized out>=0A=
        igeo =3D <optimized out>=0A=
        agino =3D <optimized out>=0A=
        off =3D <optimized out>=0A=
        agbno =3D <optimized out>=0A=
        end_agbno =3D <optimized out>=0A=
        i =3D <optimized out>=0A=
        rval =3D <optimized out>=0A=
        blks_per_buf =3D <optimized out>=0A=
        inodes_per_buf =3D <optimized out>=0A=
        ioff =3D <optimized out>=0A=
        igeo =3D <optimized out>=0A=
        next_bp =3D <optimized out>=0A=
        pop_out =3D <optimized out>=0A=
        dip =3D <optimized out>=0A=
#7  scanfunc_ino (block=3D<optimized out>, agno=3D<optimized out>, agbno=3D=
<optimized out>, level=3D<optimized out>, btype=3D<optimized out>, arg=3D<o=
ptimized out>) at /build/reproducible-path/xfsprogs-6.16.0/db/metadump.c:28=
82=0A=
        rp =3D <optimized out>=0A=
        pp =3D <optimized out>=0A=
        i =3D 0=0A=
        numrecs =3D <optimized out>=0A=
--Type <RET> for more, q to quit, c to continue without paging--=0A=
        finobt =3D <optimized out>=0A=
        igeo =3D <optimized out>=0A=
#8  0x000055c36404a182 in scan_btree (agno=3Dagno@entry=3D30, agbno=3D3, le=
vel=3Dlevel@entry=3D1, btype=3Dbtype@entry=3DTYP_INOBT, arg=3Darg@entry=3D0=
x7ffece539510, func=3Dfunc@entry=3D0x55c36404d830 <scanfunc_ino>) at /build=
/reproducible-path/xfsprogs-6.16.0/db/metadump.c:395=0A=
        rval =3D 0=0A=
#9  0x000055c36404da9b in scanfunc_ino (block=3D<optimized out>, agno=3D30,=
 agbno=3D22371408, level=3D1, btype=3D<optimized out>, arg=3D0x7ffece539510=
) at /build/reproducible-path/xfsprogs-6.16.0/db/metadump.c:2905=0A=
        rp =3D <optimized out>=0A=
        pp =3D <optimized out>=0A=
        i =3D <optimized out>=0A=
        numrecs =3D <optimized out>=0A=
        finobt =3D <optimized out>=0A=
        igeo =3D <optimized out>=0A=
#10 0x000055c36404a182 in scan_btree (agno=3Dagno@entry=3D30, agbno=3D22371=
408, level=3D2, btype=3Dbtype@entry=3DTYP_INOBT, arg=3Darg@entry=3D0x7ffece=
539510, func=3Dfunc@entry=3D0x55c36404d830 <scanfunc_ino>) at /build/reprod=
ucible-path/xfsprogs-6.16.0/db/metadump.c:395=0A=
        rval =3D 0=0A=
#11 0x000055c36404d2d8 in copy_inodes (agno=3D30, agi=3D0x55c37a93cc00) at =
/build/reproducible-path/xfsprogs-6.16.0/db/metadump.c:2938=0A=
        root =3D <optimized out>=0A=
        levels =3D <optimized out>=0A=
        finobt =3D 0=0A=
        root =3D <optimized out>=0A=
        levels =3D <optimized out>=0A=
        finobt =3D <optimized out>=0A=
#12 scan_ag (agno=3D30) at /build/reproducible-path/xfsprogs-6.16.0/db/meta=
dump.c:3077=0A=
        agi =3D 0x55c37a93cc00=0A=
        agf =3D <optimized out>=0A=
        stack_count =3D 4=0A=
        rval =3D 0=0A=
        agf =3D <optimized out>=0A=
        agi =3D <optimized out>=0A=
        stack_count =3D <optimized out>=0A=
        rval =3D <optimized out>=0A=
        pop_out =3D <optimized out>=0A=
        sb =3D <optimized out>=0A=
        i =3D <optimized out>=0A=
        agfl_bno =3D <optimized out>=0A=
#13 metadump_f (argc=3D<optimized out>, argv=3D<optimized out>) at /build/r=
eproducible-path/xfsprogs-6.16.0/db/metadump.c:3574=0A=
        agno =3D 30=0A=
        c =3D <optimized out>=0A=
        start_iocur_sp =3D <optimized out>=0A=
        outfd =3D <optimized out>=0A=
        ret =3D <optimized out>=0A=
        p =3D 0x0=0A=
        version_opt_set =3D <optimized out>=0A=
        out =3D <optimized out>=0A=
#14 0x000055c36402ca64 in main (argc=3D<optimized out>, argv=3D<optimized o=
ut>) at /build/reproducible-path/xfsprogs-6.16.0/db/init.c:189=0A=
        c =3D 6=0A=
        i =3D <optimized out>=0A=
        done =3D 0=0A=
        input =3D <optimized out>=0A=
        v =3D 0x55c37a939340=0A=
        start_iocur_sp =3D 0=0A=
        close_devices =3D <optimized out>=0A=
(gdb) =0A=
=0A=
That was when using "-a". Running without it leads to an earlier segfault (=
agno=3D20).=0A=
dmesg and journalctl don't add any other info.=0A=
Let me know if there is any further debugging that I should try.=0A=
=0A=
Thanks=0A=
=0A=
>=0A=
> Regarding the "invalid argument" when attempting the metadump with the=0A=
> image... could it be related to a mismatch with the block/sector size of=
=0A=
> the host fs?=0A=
> I thought about attaching the img to a loop device, but I wasn't sure if=
=0A=
> xfs_metadump tries that already. Also at this point I don't trust myself=
=0A=
> to try anything without a 2nd copy.=0A=
>=0A=
> I'll let you know how that goes, thanks a lot again.=0A=
> H.=0A=
>=0A=
>> Cheers,=0A=
>> Carlos.=0A=
>>=0A=
>>> Thanks again=0A=
>>>=0A=
>>>>=0A=
>>>> Thanks=0A=
>>>>> Also, xfs_repair does not need to be executed on the same architectur=
e=0A=
>>>>> as the FS was running. Despite log replay (which is done by the Linux=
=0A=
>>>>> kernel), xfs_repair is capable of converting the filesystem data=0A=
>>>>> structures back and forth to the current machine endianness=0A=
>>>>>=0A=
>>>>>=0A=
>>>>>> Thanks in advance for any input=0A=
>>>>>> Hub=
