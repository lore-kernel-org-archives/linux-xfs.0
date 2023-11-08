Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E74EC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 15:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjKHP4H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 10:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjKHP4G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 10:56:06 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2041.outbound.protection.outlook.com [40.107.249.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49391FD8
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 07:56:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WksYbtVabJMuGGKY3ePrFnO5F791qNG1bX2eDw8wefppEK4U5Uy4tRym8Ur9A1RDDFttW0Z3In5aP7mnhImZeneMcss34kU7RES8iKCkNfaKhCDNfkfQW6uPepX1stYz1kN9lR7RK08BXmSd0vgCCzhpdUDABSUduE+GDo3w/a6w3IDqCp3Pz+NoRTqBCiYT+tZIwwlq0gVxDuVOfn0Nrw5oazfG4lrFONzwURktU8TA6mLmbfJN94FBYdBSQFV4+O+X+4HboY9LYgQJ3p0JZXwvCiHpJRyu1DpacWLncO7pPWEe/P+U/oywl/ewYLJOHP2eFyLU1Yu7C4rcCKsURw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwcln1WTN03IwA8jpgd/KsZ8+oPQBzvXJUq9QN7eP0k=;
 b=FNGdwykUaQyjQECwkwALD3863fD2/77alrCQpcQhMTsSupKCgvInJ8p4uMdDlWpeBOarZUscB/+JgWNC5P0YncnhYif/NnyoKx0IPpPj8mlbeqmbjh+qpfz+9qMm8e1YW7uL6c5HYi7w64XPNw8q6O9ykuiBKt6zLl1tdsx1JCXu2qpv0X3CNHd+CtBsbX/VpdvdTQ8tFd+mxUpnaOB3v72fh/2Zwt1Z5cYsR6/kekBGBqSpEP04RX2XnnMeProTso3sAMaE3NBRIYEGLkT898OrXOGG5MKqpfeeBIa1Xkhf0cZOuHDSlFOWbREC7Y3MnaiCVPpwUM8mh0m7fXy9xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axis.com; dmarc=pass action=none header.from=axis.com;
 dkim=pass header.d=axis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axis.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwcln1WTN03IwA8jpgd/KsZ8+oPQBzvXJUq9QN7eP0k=;
 b=Fr64gR2f6FWiZiGiwGSihbIDYqJi8HYSuyBp26ZS5Iwo9ELB7LMitV3YRWqDv5Vjv5ljd35d8B6MjxTsWx0MgAbM2gatm9XTaYSIcEQnHjFcEJrd4ySW8DWtOJUnD32qClNuiDxmaItIP+/2Wq5/4A3y9hXVpajxgWeneb37PXI=
Received: from DU0PR02MB9824.eurprd02.prod.outlook.com (2603:10a6:10:44b::6)
 by AM0PR02MB5921.eurprd02.prod.outlook.com (2603:10a6:208:185::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Wed, 8 Nov
 2023 15:56:01 +0000
Received: from DU0PR02MB9824.eurprd02.prod.outlook.com
 ([fe80::9ec0:7864:e983:4a80]) by DU0PR02MB9824.eurprd02.prod.outlook.com
 ([fe80::9ec0:7864:e983:4a80%5]) with mapi id 15.20.6977.018; Wed, 8 Nov 2023
 15:56:00 +0000
From:   =?iso-8859-1?Q?Per_F=F6rlin?= <Per.Forlin@axis.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: xfsprogs: repair: Higher memory consumption when disable prefetch
Thread-Topic: xfsprogs: repair: Higher memory consumption when disable
 prefetch
Thread-Index: AQHaElspx/WC/C+M/UmNXlo+3JxQ9g==
Date:   Wed, 8 Nov 2023 15:56:00 +0000
Message-ID: <DU0PR02MB9824633F6B7AA1090D3D02A9EFA8A@DU0PR02MB9824.eurprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axis.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR02MB9824:EE_|AM0PR02MB5921:EE_
x-ms-office365-filtering-correlation-id: 139bf171-566f-4c22-2adb-08dbe0733469
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3eZstQtHlpj/wvKJxuN3/M6RDRH9bfrjnkZ4XLl5E3TluVv/22tFuOa8L2ng5TAGZGQ7vT6Z1s5s5Rein/Du6+qaGvcQfqj8I+O+IGunIDaAhVflt4j9Zb0jb+2Ocs4iFCdnvOaNPPt3z23qVXo509MsvdffzJ6UFnk9SAAvop5JHLaeiO1ytc1sGHuXvllkDDfzijUqCKQEkuGehzbXwfe3PafAJmzvHBZ+eKy5tP6ab5oWT1CqR/V0OsYHrTyEAhAAZ3Z8KON0uXIENa8wlJD9mIg/IRjghuYUDJw2BPj2iTHfPXFf7ASVphNnqrnn5GDSQbBvPsDd2QVfKhjm/VdQD0cNH/a0omkpns0P+dKedGMOvINOjYWD05c+/DBn++P0tYgUk9/V0JRfKSVZRKcEQwMfp7elmq/MOPbtFfyWK4ZrDR8JtNG3wpEWpAiID7dOTCLDSOuaDqzteL+VfJPIVMadoXLSFX0YObgQyhRZoKjFLo1khj3Xu5LXGJGzw4n7UW8R/q7SDfoEoKi5HUrk+sgTlthHxA3S0M/vRHjYxO768D7GXBrsZM+6usqSEcWlV40CwX98KfmTLZMs7wzTpElbnyeR9bIJUUmSESB2RKcJG0OU8zGgomE08H24
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR02MB9824.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(396003)(366004)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(55016003)(478600001)(38070700009)(122000001)(33656002)(86362001)(83380400001)(38100700002)(7696005)(91956017)(6916009)(9686003)(66446008)(66556008)(66476007)(64756008)(76116006)(71200400001)(66946007)(26005)(2906002)(30864003)(316002)(41300700001)(6506007)(5660300002)(52536014)(8936002)(8676002)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gD5oO1n12SZ0WRMeKnkBenUQ4Yl809KP5ABs4Pb88VV7eN4TcOlhQXCji6?=
 =?iso-8859-1?Q?BGK/jhJeN4F/g6tqVTPWDkX6aKpJ2CqTGprDjXf/CNq51iBFGgXrcAlTjw?=
 =?iso-8859-1?Q?SXcCjaV4hbFmNQETRL93yN3uibRs3WgU4uqeNWttJasObuTyvmutiwoZe3?=
 =?iso-8859-1?Q?OtU2hKgKWwMIiDeRJS4HY6quN344HcL3BdMp42d9UUED+Mx0KtCAzp7PMn?=
 =?iso-8859-1?Q?tC3M/gkIKpIsRx0xpvMrhQ4p6+2gAjd0584i9Dby3i6752ySBp+8xcbslL?=
 =?iso-8859-1?Q?HoWrz/W2n05RQTN9BoU19TiMtf0wCs6wwqh3JcFmLaZqj5MCyrlVDD5ByD?=
 =?iso-8859-1?Q?qY429nuyeBXuwaibB7ApdO5NKc34ex/K6OfdgW6oNAHzcS4I8bj088K027?=
 =?iso-8859-1?Q?U3rWlQlGRLRGV60ZwFDKp54bY23bybKqZ5pRrIB46Mwz1N2J47l0SP+xmu?=
 =?iso-8859-1?Q?JESu2dvyOCkdix5MmWEqv/2obC8nytcYgyBfbaMBQsqZjsWWExCNlmAyJE?=
 =?iso-8859-1?Q?d0C703bVOOP6nyVOEw1ViT+pcXHF1b3vivbMEDuyxLmvfl000e8gFbazF3?=
 =?iso-8859-1?Q?WwefsYAk2yzeKU9kr9Elb7ZcSAjT6ADQCY0q8BXIT7AWLXps2Zp73SJ2MD?=
 =?iso-8859-1?Q?vPZq2Eq0xMGhUtmJSFnjsG67reNJu/fLgQxRfFicivmgc5dUJaxLZAWlTW?=
 =?iso-8859-1?Q?jLyeX/PH3oD9oiAGb9Pu+IEOdQu33qBBmWgxkcBI2R3Aua+2L82py9Fv+h?=
 =?iso-8859-1?Q?+A0VDJX/r+nRs+KMx7nZX5U3G752idO5SPzmzF8uuB5uv7XmYfatvA9ihU?=
 =?iso-8859-1?Q?9Uugcy6S6YeU+arBtakFwpsTlH3XnyMGEXaavNIWdDyAjdtXzXt1HqSbHL?=
 =?iso-8859-1?Q?hmJ8wHykBLbqM9U4o7qXUEIhy4VxVcvyiyggNsmrQS92QcX+9XigjCeHOn?=
 =?iso-8859-1?Q?Git+wT0UD8r5vYQVTlMCs+mnoWudWcdmWw7wHXDK1/byBk6CWBoQRdg3X0?=
 =?iso-8859-1?Q?5p74aanNyqgWRSnqkCcmPTSn+xni05yx2fW8fZicmWclWn+9/rRapdgFJD?=
 =?iso-8859-1?Q?LnaAGPe5B/LSB4FIn01Kp2TaJ/Kp0h350D/Ik80rLjpn+U5y2YP9rI7Jrt?=
 =?iso-8859-1?Q?eXzCtAN/MtBtb5BlVL3yaBat0j8k3qmLK7CsgDod7pQjaEmRuXCPCtBIrj?=
 =?iso-8859-1?Q?fzMcO2f+U/GnlWptLkPxAPCxR0gOih41JLKZvtsfZZwRxAorRqIClx26da?=
 =?iso-8859-1?Q?gkg0KTruDNP7tt61Qs5JUnOCGNukf3KlOz9niiNhec7Y899PAnoYL3Nfll?=
 =?iso-8859-1?Q?rZ9uiQK07tWiZN5vHmI9wWwm0sG9aTQhda9hGau1W7giHXIeTYW27E343M?=
 =?iso-8859-1?Q?PYBJ96QDYV1oz8H4PAzSs0ggnKSx3CrG8Z7qZpy/Euv4MWzvcwusoiwraE?=
 =?iso-8859-1?Q?b8NjXcW9myYZZrmjzJqqqqqU9w8PwZGysAP+pS89O9ysB6sDFNSRKDTe+c?=
 =?iso-8859-1?Q?pUoX4SrZGeMP+PfBgPqR2aSE/TAjYzbRviVXgC1LRZmqyqJI61jMcgXg2k?=
 =?iso-8859-1?Q?8slNgvUovyrw4M4d2seVLlMoY1AW5K2ZWPhTm36A4zEZPP4uaTJOnLsVnp?=
 =?iso-8859-1?Q?LuAKHvTPZc2Oo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: axis.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR02MB9824.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 139bf171-566f-4c22-2adb-08dbe0733469
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2023 15:56:00.7725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mELKPb10FFmVftYRZa5ijqZIMU2hK9FpurgAABLNg/WwtlphxJIkJMkn38T3o4ml
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR02MB5921
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linux XFS community,=0A=
=0A=
Please bare with me I'm new to XFS :)=0A=
=0A=
I'm comparing how EXT4 and XFS behaves on systems with a relative=0A=
small RAM vs storage ratio. The current focus is on FS repair memory consum=
ption.=0A=
=0A=
I have been running some tests using the max_mem_specified option.=0A=
The "-m" (max_mem_specified) parameter does not guarantee success but it su=
rely helps=0A=
to reduce the memory load, in comparison to EXT4 this is an improvement.=0A=
=0A=
My question concerns the relation between "-P" (disable prefetch) and "-m" =
(max_mem_specified).=0A=
=0A=
There is a difference in xfs_repair memory consumption between the followin=
g commands=0A=
1. xfs_repair -P -m 500=0A=
2. xfs_repair -m 500=0A=
=0A=
1) Exceeds the max_mem_specified limit=0A=
2) Stays below the max_mem_specified limit=0A=
=0A=
I expected disabled prefetch to reduce the memory load but instead the resu=
lt is the opposite.=0A=
The two commands 1) and 2) are being executed in the same system.=0A=
=0A=
My speculation:=0A=
Does the prefetch facilitate and improve the calculation of the memory=0A=
consumption and make it more accurate?=0A=
=0A=
Here follows output with -P and without -P from the same system.=0A=
I have extracted the part the actually differs.=0A=
The full logs are available the bottom of this email.=0A=
=0A=
# -P -m 500 #=0A=
Phase 3 - for each AG...=0A=
...=0A=
Active entries =3D 12336=0A=
Hash table size =3D 1549=0A=
Hits =3D 1=0A=
Misses =3D 224301=0A=
Hit ratio =3D  0.00=0A=
MRU 0 entries =3D  12335 ( 99%)=0A=
MRU 1 entries =3D      0 (  0%)=0A=
MRU 2 entries =3D      0 (  0%)=0A=
MRU 3 entries =3D      0 (  0%)=0A=
MRU 4 entries =3D      0 (  0%)=0A=
MRU 5 entries =3D      0 (  0%)=0A=
MRU 6 entries =3D      0 (  0%)=0A=
MRU 7 entries =3D      0 (  0%)=0A=
=0A=
# -m 500 #=0A=
Phase 3 - for each AG...=0A=
...=0A=
Active entries =3D 12388=0A=
Hash table size =3D 1549=0A=
Hits =3D 220459=0A=
Misses =3D 235388=0A=
Hit ratio =3D 48.36=0A=
MRU 0 entries =3D      2 (  0%)=0A=
MRU 1 entries =3D      0 (  0%)=0A=
MRU 2 entries =3D   1362 ( 10%)=0A=
MRU 3 entries =3D     68 (  0%)=0A=
MRU 4 entries =3D     10 (  0%)=0A=
MRU 5 entries =3D   6097 ( 49%)=0A=
MRU 6 entries =3D   4752 ( 38%)=0A=
MRU 7 entries =3D     96 (  0%)=0A=
=0A=
=0A=
Tested on version 6.1.1 and 6.5.0, same result.=0A=
=0A=
BR=0A=
Per Forlin=0A=
=0A=
=0A=
-------------------------------------------------------------------------=
=0A=
Here follows full logs for both memory consumption and xfs_repair output.=
=0A=
=0A=
=0A=
## Full log of xfs_repair with "-P" that exceeds max limit and crash the sy=
stem=0A=
=0A=
# xfs_repair -vvv -P -n -m 500 /dev/sda1 =0A=
=0A=
Phase 1 - find and verify superblock...=0A=
bhash_option_used=3D0=0A=
max_mem_specified=3D500=0A=
verbose=3D3=0A=
[main:1166] perfn=0A=
        - max_mem =3D 512000, icount =3D 6445568, imem =3D 25178, dblock =
=3D 488378385, dmem =3D 238466=0A=
        - block cache size set to 12392 entries=0A=
Phase 2 - using internal log=0A=
        - zero log...=0A=
zero_log: head block 1068680 tail block 1068680=0A=
        - scan filesystem freespace and inode maps...=0A=
        - found root inode chunk=0A=
libxfs_bcache: 0x5597cf9220=0A=
Max supported entries =3D 12392=0A=
Max utilized entries =3D 582=0A=
Active entries =3D 582=0A=
Hash table size =3D 1549=0A=
Hits =3D 1=0A=
Misses =3D 582=0A=
Hit ratio =3D  0.17=0A=
MRU 0 entries =3D    581 ( 99%)=0A=
MRU 1 entries =3D      0 (  0%)=0A=
MRU 2 entries =3D      0 (  0%)=0A=
MRU 3 entries =3D      0 (  0%)=0A=
MRU 4 entries =3D      0 (  0%)=0A=
MRU 5 entries =3D      0 (  0%)=0A=
MRU 6 entries =3D      0 (  0%)=0A=
MRU 7 entries =3D      0 (  0%)=0A=
MRU 8 entries =3D      0 (  0%)=0A=
MRU 9 entries =3D      0 (  0%)=0A=
MRU 10 entries =3D      0 (  0%)=0A=
MRU 11 entries =3D      0 (  0%)=0A=
MRU 12 entries =3D      0 (  0%)=0A=
MRU 13 entries =3D      0 (  0%)=0A=
MRU 14 entries =3D      0 (  0%)=0A=
MRU 15 entries =3D      0 (  0%)=0A=
Dirty MRU 16 entries =3D      0 (  0%)=0A=
Hash buckets with   0 entries   1078 (  0%)=0A=
Hash buckets with   1 entries    375 ( 64%)=0A=
Hash buckets with   2 entries     84 ( 28%)=0A=
Hash buckets with   3 entries      9 (  4%)=0A=
Hash buckets with   4 entries      3 (  2%)=0A=
Phase 3 - for each AG...=0A=
        - scan (but don't clear) agi unlinked lists...=0A=
        - process known inodes and perform inode discovery...=0A=
        - agno =3D 0=0A=
        - agno =3D 1=0A=
        - agno =3D 2=0A=
        - agno =3D 3=0A=
        - process newly discovered inodes...=0A=
libxfs_bcache: 0x5597cf9220=0A=
Max supported entries =3D 12392=0A=
Max utilized entries =3D 12392=0A=
Active entries =3D 12336=0A=
Hash table size =3D 1549=0A=
Hits =3D 1=0A=
Misses =3D 224301=0A=
Hit ratio =3D  0.00=0A=
MRU 0 entries =3D  12335 ( 99%)=0A=
MRU 1 entries =3D      0 (  0%)=0A=
MRU 2 entries =3D      0 (  0%)=0A=
MRU 3 entries =3D      0 (  0%)=0A=
MRU 4 entries =3D      0 (  0%)=0A=
MRU 5 entries =3D      0 (  0%)=0A=
MRU 6 entries =3D      0 (  0%)=0A=
MRU 7 entries =3D      0 (  0%)=0A=
MRU 8 entries =3D      0 (  0%)=0A=
MRU 9 entries =3D      0 (  0%)=0A=
MRU 10 entries =3D      0 (  0%)=0A=
MRU 11 entries =3D      0 (  0%)=0A=
MRU 12 entries =3D      0 (  0%)=0A=
MRU 13 entries =3D      0 (  0%)=0A=
MRU 14 entries =3D      0 (  0%)=0A=
MRU 15 entries =3D      0 (  0%)=0A=
Dirty MRU 16 entries =3D      0 (  0%)=0A=
Hash buckets with   1 entries      2 (  0%)=0A=
Hash buckets with   2 entries     17 (  0%)=0A=
Hash buckets with   3 entries     42 (  1%)=0A=
Hash buckets with   4 entries     87 (  2%)=0A=
Hash buckets with   5 entries    153 (  6%)=0A=
Hash buckets with   6 entries    198 (  9%)=0A=
Hash buckets with   7 entries    225 ( 12%)=0A=
Hash buckets with   8 entries    208 ( 13%)=0A=
Hash buckets with   9 entries    184 ( 13%)=0A=
Hash buckets with  10 entries    162 ( 13%)=0A=
Hash buckets with  11 entries     99 (  8%)=0A=
Hash buckets with  12 entries     79 (  7%)=0A=
Hash buckets with  13 entries     38 (  4%)=0A=
Hash buckets with  14 entries     25 (  2%)=0A=
Hash buckets with  15 entries     15 (  1%)=0A=
Hash buckets with  16 entries      9 (  1%)=0A=
Hash buckets with  17 entries      2 (  0%)=0A=
Hash buckets with  18 entries      2 (  0%)=0A=
Hash buckets with  19 entries      2 (  0%)=0A=
Phase 4 - check for duplicate blocks...=0A=
        - setting up duplicate extent list...=0A=
        - check for inodes claiming duplicate blocks...=0A=
        - agno =3D 0=0A=
!! OOM system crash !!=0A=
=0A=
# Memory log:=0A=
# while  :; do grep Private_D /proc/$(pidof xfs_repair)/smaps_rollup ; grep=
 MemAvail /proc/meminfo ; sleep 10; done=0A=
Private_Dirty:     11772 kB=0A=
MemAvailable:     625436 kB=0A=
Private_Dirty:    135020 kB=0A=
MemAvailable:     501736 kB=0A=
Private_Dirty:    239860 kB=0A=
MemAvailable:     396432 kB=0A=
Private_Dirty:    269312 kB=0A=
MemAvailable:     366948 kB=0A=
Private_Dirty:    290976 kB=0A=
MemAvailable:     344756 kB=0A=
Private_Dirty:    304520 kB=0A=
MemAvailable:     330392 kB=0A=
Private_Dirty:    331152 kB=0A=
MemAvailable:     304184 kB=0A=
Private_Dirty:    361924 kB=0A=
MemAvailable:     272400 kB=0A=
Private_Dirty:    382204 kB=0A=
MemAvailable:     252476 kB=0A=
Private_Dirty:    407184 kB=0A=
MemAvailable:     227008 kB=0A=
Private_Dirty:    422432 kB=0A=
MemAvailable:     211160 kB=0A=
Private_Dirty:    437428 kB=0A=
MemAvailable:     197144 kB=0A=
Private_Dirty:    460960 kB=0A=
MemAvailable:     175692 kB=0A=
Private_Dirty:    467128 kB=0A=
MemAvailable:     168156 kB=0A=
Private_Dirty:    483184 kB=0A=
MemAvailable:     153280 kB=0A=
Private_Dirty:    507128 kB=0A=
MemAvailable:     131140 kB=0A=
Private_Dirty:    540896 kB=0A=
MemAvailable:      97488 kB=0A=
Private_Dirty:    575480 kB=0A=
MemAvailable:      67268 kB=0A=
Private_Dirty:    604580 kB=0A=
MemAvailable:      36484 kB=0A=
Private_Dirty:    614316 kB=0A=
MemAvailable:      31668 kB=0A=
Private_Dirty:    645888 kB=0A=
MemAvailable:      24232 kB=0A=
Private_Dirty:    659140 kB=0A=
MemAvailable:      21444 kB=0A=
!! Runs out of memory at this point !!=0A=
=0A=
=0A=
## Full log of xfs_repair with "-P" run that stays within max limit and fin=
ish successfully=0A=
=0A=
root@ax-b8a44f27a3b4:~# xfs_repair -vvv -n -m 500 /dev/sda1 =0A=
Phase 1 - find and verify superblock...=0A=
bhash_option_used=3D0=0A=
max_mem_specified=3D500=0A=
verbose=3D3=0A=
[main:1166] perfn=0A=
        - max_mem =3D 512000, icount =3D 6445568, imem =3D 25178, dblock =
=3D 488378385, dmem =3D 238466=0A=
        - block cache size set to 12392 entries=0A=
Phase 2 - using internal log=0A=
        - zero log...=0A=
zero_log: head block 1068680 tail block 1068680=0A=
        - scan filesystem freespace and inode maps...=0A=
        - found root inode chunk=0A=
libxfs_bcache: 0x55aa821220=0A=
Max supported entries =3D 12392=0A=
Max utilized entries =3D 582=0A=
Active entries =3D 582=0A=
Hash table size =3D 1549=0A=
Hits =3D 1=0A=
Misses =3D 582=0A=
Hit ratio =3D  0.17=0A=
MRU 0 entries =3D    581 ( 99%)=0A=
MRU 1 entries =3D      0 (  0%)=0A=
MRU 2 entries =3D      0 (  0%)=0A=
MRU 3 entries =3D      0 (  0%)=0A=
MRU 4 entries =3D      0 (  0%)=0A=
MRU 5 entries =3D      0 (  0%)=0A=
MRU 6 entries =3D      0 (  0%)=0A=
MRU 7 entries =3D      0 (  0%)=0A=
MRU 8 entries =3D      0 (  0%)=0A=
MRU 9 entries =3D      0 (  0%)=0A=
MRU 10 entries =3D      0 (  0%)=0A=
MRU 11 entries =3D      0 (  0%)=0A=
MRU 12 entries =3D      0 (  0%)=0A=
MRU 13 entries =3D      0 (  0%)=0A=
MRU 14 entries =3D      0 (  0%)=0A=
MRU 15 entries =3D      0 (  0%)=0A=
Dirty MRU 16 entries =3D      0 (  0%)=0A=
Hash buckets with   0 entries   1078 (  0%)=0A=
Hash buckets with   1 entries    375 ( 64%)=0A=
Hash buckets with   2 entries     84 ( 28%)=0A=
Hash buckets with   3 entries      9 (  4%)=0A=
Hash buckets with   4 entries      3 (  2%)=0A=
Phase 3 - for each AG...=0A=
        - scan (but don't clear) agi unlinked lists...=0A=
        - process known inodes and perform inode discovery...=0A=
        - agno =3D 0=0A=
        - agno =3D 1=0A=
        - agno =3D 2=0A=
        - agno =3D 3=0A=
        - process newly discovered inodes...=0A=
libxfs_bcache: 0x55aa821220=0A=
Max supported entries =3D 12392=0A=
Max utilized entries =3D 12392=0A=
Active entries =3D 12388=0A=
Hash table size =3D 1549=0A=
Hits =3D 220459=0A=
Misses =3D 235388=0A=
Hit ratio =3D 48.36=0A=
MRU 0 entries =3D      2 (  0%)=0A=
MRU 1 entries =3D      0 (  0%)=0A=
MRU 2 entries =3D   1362 ( 10%)=0A=
MRU 3 entries =3D     68 (  0%)=0A=
MRU 4 entries =3D     10 (  0%)=0A=
MRU 5 entries =3D   6097 ( 49%)=0A=
MRU 6 entries =3D   4752 ( 38%)=0A=
MRU 7 entries =3D     96 (  0%)=0A=
MRU 8 entries =3D      0 (  0%)=0A=
MRU 9 entries =3D      0 (  0%)=0A=
MRU 10 entries =3D      0 (  0%)=0A=
MRU 11 entries =3D      0 (  0%)=0A=
MRU 12 entries =3D      0 (  0%)=0A=
MRU 13 entries =3D      0 (  0%)=0A=
MRU 14 entries =3D      0 (  0%)=0A=
MRU 15 entries =3D      0 (  0%)=0A=
Dirty MRU 16 entries =3D      0 (  0%)=0A=
Hash buckets with   1 entries      2 (  0%)=0A=
Hash buckets with   2 entries      8 (  0%)=0A=
Hash buckets with   3 entries     35 (  0%)=0A=
Hash buckets with   4 entries     88 (  2%)=0A=
Hash buckets with   5 entries    123 (  4%)=0A=
Hash buckets with   6 entries    180 (  8%)=0A=
Hash buckets with   7 entries    243 ( 13%)=0A=
Hash buckets with   8 entries    249 ( 16%)=0A=
Hash buckets with   9 entries    224 ( 16%)=0A=
Hash buckets with  10 entries    151 ( 12%)=0A=
Hash buckets with  11 entries    109 (  9%)=0A=
Hash buckets with  12 entries     50 (  4%)=0A=
Hash buckets with  13 entries     51 (  5%)=0A=
Hash buckets with  14 entries     17 (  1%)=0A=
Hash buckets with  15 entries      8 (  0%)=0A=
Hash buckets with  16 entries      9 (  1%)=0A=
Hash buckets with  17 entries      1 (  0%)=0A=
Hash buckets with  18 entries      1 (  0%)=0A=
Phase 4 - check for duplicate blocks...=0A=
        - setting up duplicate extent list...=0A=
        - check for inodes claiming duplicate blocks...=0A=
        - agno =3D 0=0A=
        - agno =3D 1=0A=
        - agno =3D 2=0A=
        - agno =3D 3=0A=
libxfs_bcache: 0x55aa821220=0A=
Max supported entries =3D 12392=0A=
Max utilized entries =3D 12392=0A=
Active entries =3D 12369=0A=
Hash table size =3D 1549=0A=
Hits =3D 445862=0A=
Misses =3D 484224=0A=
Hit ratio =3D 47.94=0A=
MRU 0 entries =3D      5 (  0%)=0A=
MRU 1 entries =3D      0 (  0%)=0A=
MRU 2 entries =3D   1498 ( 12%)=0A=
MRU 3 entries =3D     73 (  0%)=0A=
MRU 4 entries =3D     17 (  0%)=0A=
MRU 5 entries =3D   6401 ( 51%)=0A=
MRU 6 entries =3D   4374 ( 35%)=0A=
MRU 7 entries =3D      0 (  0%)=0A=
MRU 8 entries =3D      0 (  0%)=0A=
MRU 9 entries =3D      0 (  0%)=0A=
MRU 10 entries =3D      0 (  0%)=0A=
MRU 11 entries =3D      0 (  0%)=0A=
MRU 12 entries =3D      0 (  0%)=0A=
MRU 13 entries =3D      0 (  0%)=0A=
MRU 14 entries =3D      0 (  0%)=0A=
MRU 15 entries =3D      0 (  0%)=0A=
Dirty MRU 16 entries =3D      0 (  0%)=0A=
Hash buckets with   1 entries      1 (  0%)=0A=
Hash buckets with   2 entries     13 (  0%)=0A=
Hash buckets with   3 entries     35 (  0%)=0A=
Hash buckets with   4 entries     93 (  3%)=0A=
Hash buckets with   5 entries    126 (  5%)=0A=
Hash buckets with   6 entries    184 (  8%)=0A=
Hash buckets with   7 entries    235 ( 13%)=0A=
Hash buckets with   8 entries    239 ( 15%)=0A=
Hash buckets with   9 entries    214 ( 15%)=0A=
Hash buckets with  10 entries    155 ( 12%)=0A=
Hash buckets with  11 entries    115 ( 10%)=0A=
Hash buckets with  12 entries     63 (  6%)=0A=
Hash buckets with  13 entries     30 (  3%)=0A=
Hash buckets with  14 entries     22 (  2%)=0A=
Hash buckets with  15 entries     12 (  1%)=0A=
Hash buckets with  16 entries      7 (  0%)=0A=
Hash buckets with  17 entries      3 (  0%)=0A=
Hash buckets with  18 entries      2 (  0%)=0A=
No modify flag set, skipping phase 5=0A=
libxfs_bcache: 0x55aa821220=0A=
Max supported entries =3D 12392=0A=
Max utilized entries =3D 12392=0A=
Active entries =3D 12369=0A=
Hash table size =3D 1549=0A=
Hits =3D 445862=0A=
Misses =3D 484224=0A=
Hit ratio =3D 47.94=0A=
MRU 0 entries =3D      5 (  0%)=0A=
MRU 1 entries =3D      0 (  0%)=0A=
MRU 2 entries =3D   1498 ( 12%)=0A=
MRU 3 entries =3D     73 (  0%)=0A=
MRU 4 entries =3D     17 (  0%)=0A=
MRU 5 entries =3D   6401 ( 51%)=0A=
MRU 6 entries =3D   4374 ( 35%)=0A=
MRU 7 entries =3D      0 (  0%)=0A=
MRU 8 entries =3D      0 (  0%)=0A=
MRU 9 entries =3D      0 (  0%)=0A=
MRU 10 entries =3D      0 (  0%)=0A=
MRU 11 entries =3D      0 (  0%)=0A=
MRU 12 entries =3D      0 (  0%)=0A=
MRU 13 entries =3D      0 (  0%)=0A=
MRU 14 entries =3D      0 (  0%)=0A=
MRU 15 entries =3D      0 (  0%)=0A=
Dirty MRU 16 entries =3D      0 (  0%)=0A=
Hash buckets with   1 entries      1 (  0%)=0A=
Hash buckets with   2 entries     13 (  0%)=0A=
Hash buckets with   3 entries     35 (  0%)=0A=
Hash buckets with   4 entries     93 (  3%)=0A=
Hash buckets with   5 entries    126 (  5%)=0A=
Hash buckets with   6 entries    184 (  8%)=0A=
Hash buckets with   7 entries    235 ( 13%)=0A=
Hash buckets with   8 entries    239 ( 15%)=0A=
Hash buckets with   9 entries    214 ( 15%)=0A=
Hash buckets with  10 entries    155 ( 12%)=0A=
Hash buckets with  11 entries    115 ( 10%)=0A=
Hash buckets with  12 entries     63 (  6%)=0A=
Hash buckets with  13 entries     30 (  3%)=0A=
Hash buckets with  14 entries     22 (  2%)=0A=
Hash buckets with  15 entries     12 (  1%)=0A=
Hash buckets with  16 entries      7 (  0%)=0A=
Hash buckets with  17 entries      3 (  0%)=0A=
Hash buckets with  18 entries      2 (  0%)=0A=
Phase 6 - check inode connectivity...=0A=
        - traversing filesystem ...=0A=
        - agno =3D 0=0A=
        - agno =3D 1=0A=
        - agno =3D 2=0A=
        - agno =3D 3=0A=
        - traversal finished ...=0A=
        - moving disconnected inodes to lost+found ...=0A=
libxfs_bcache: 0x55aa821220=0A=
Max supported entries =3D 12392=0A=
Max utilized entries =3D 12392=0A=
Active entries =3D 12357=0A=
Hash table size =3D 1549=0A=
Hits =3D 3043575=0A=
Misses =3D 717152=0A=
Hit ratio =3D 80.93=0A=
MRU 0 entries =3D   1505 ( 12%)=0A=
MRU 1 entries =3D      0 (  0%)=0A=
MRU 2 entries =3D      3 (  0%)=0A=
MRU 3 entries =3D     58 (  0%)=0A=
MRU 4 entries =3D      9 (  0%)=0A=
MRU 5 entries =3D   5981 ( 48%)=0A=
MRU 6 entries =3D   4696 ( 38%)=0A=
MRU 7 entries =3D     96 (  0%)=0A=
MRU 8 entries =3D      0 (  0%)=0A=
MRU 9 entries =3D      0 (  0%)=0A=
MRU 10 entries =3D      8 (  0%)=0A=
MRU 11 entries =3D      0 (  0%)=0A=
MRU 12 entries =3D      0 (  0%)=0A=
MRU 13 entries =3D      0 (  0%)=0A=
MRU 14 entries =3D      0 (  0%)=0A=
MRU 15 entries =3D      0 (  0%)=0A=
Dirty MRU 16 entries =3D      0 (  0%)=0A=
Hash buckets with   1 entries      3 (  0%)=0A=
Hash buckets with   2 entries     10 (  0%)=0A=
Hash buckets with   3 entries     39 (  0%)=0A=
Hash buckets with   4 entries     79 (  2%)=0A=
Hash buckets with   5 entries    131 (  5%)=0A=
Hash buckets with   6 entries    182 (  8%)=0A=
Hash buckets with   7 entries    240 ( 13%)=0A=
Hash buckets with   8 entries    256 ( 16%)=0A=
Hash buckets with   9 entries    209 ( 15%)=0A=
Hash buckets with  10 entries    151 ( 12%)=0A=
Hash buckets with  11 entries    115 ( 10%)=0A=
Hash buckets with  12 entries     54 (  5%)=0A=
Hash buckets with  13 entries     38 (  3%)=0A=
Hash buckets with  14 entries     21 (  2%)=0A=
Hash buckets with  15 entries      8 (  0%)=0A=
Hash buckets with  16 entries      7 (  0%)=0A=
Hash buckets with  17 entries      6 (  0%)=0A=
Phase 7 - verify link counts...=0A=
libxfs_bcache: 0x55aa821220=0A=
Max supported entries =3D 12392=0A=
Max utilized entries =3D 12392=0A=
Active entries =3D 12357=0A=
Hash table size =3D 1549=0A=
Hits =3D 3043575=0A=
Misses =3D 717152=0A=
Hit ratio =3D 80.93=0A=
MRU 0 entries =3D   1505 ( 12%)=0A=
MRU 1 entries =3D      0 (  0%)=0A=
MRU 2 entries =3D      3 (  0%)=0A=
MRU 3 entries =3D     58 (  0%)=0A=
MRU 4 entries =3D      9 (  0%)=0A=
MRU 5 entries =3D   5981 ( 48%)=0A=
MRU 6 entries =3D   4696 ( 38%)=0A=
MRU 7 entries =3D     96 (  0%)=0A=
MRU 8 entries =3D      0 (  0%)=0A=
MRU 9 entries =3D      0 (  0%)=0A=
MRU 10 entries =3D      8 (  0%)=0A=
MRU 11 entries =3D      0 (  0%)=0A=
MRU 12 entries =3D      0 (  0%)=0A=
MRU 13 entries =3D      0 (  0%)=0A=
MRU 14 entries =3D      0 (  0%)=0A=
MRU 15 entries =3D      0 (  0%)=0A=
Dirty MRU 16 entries =3D      0 (  0%)=0A=
Hash buckets with   1 entries      3 (  0%)=0A=
Hash buckets with   2 entries     10 (  0%)=0A=
Hash buckets with   3 entries     39 (  0%)=0A=
Hash buckets with   4 entries     79 (  2%)=0A=
Hash buckets with   5 entries    131 (  5%)=0A=
Hash buckets with   6 entries    182 (  8%)=0A=
Hash buckets with   7 entries    240 ( 13%)=0A=
Hash buckets with   8 entries    256 ( 16%)=0A=
Hash buckets with   9 entries    209 ( 15%)=0A=
Hash buckets with  10 entries    151 ( 12%)=0A=
Hash buckets with  11 entries    115 ( 10%)=0A=
Hash buckets with  12 entries     54 (  5%)=0A=
Hash buckets with  13 entries     38 (  3%)=0A=
Hash buckets with  14 entries     21 (  2%)=0A=
Hash buckets with  15 entries      8 (  0%)=0A=
Hash buckets with  16 entries      7 (  0%)=0A=
Hash buckets with  17 entries      6 (  0%)=0A=
No modify flag set, skipping filesystem flush and exiting.=0A=
=0A=
        XFS_REPAIR Summary    Wed Nov  8 13:05:25 2023=0A=
=0A=
Phase		Start		End		Duration=0A=
Phase 1:	11/08 12:59:25	11/08 12:59:25	=0A=
Phase 2:	11/08 12:59:25	11/08 12:59:33	8 seconds=0A=
Phase 3:	11/08 12:59:33	11/08 13:01:29	1 minute, 56 seconds=0A=
Phase 4:	11/08 13:01:29	11/08 13:03:22	1 minute, 53 seconds=0A=
Phase 5:	Skipped=0A=
Phase 6:	11/08 13:03:22	11/08 13:05:25	2 minutes, 3 seconds=0A=
Phase 7:	11/08 13:05:25	11/08 13:05:25	=0A=
=0A=
Total run time: 6 minutes=0A=
=0A=
=0A=
# Memory log:=0A=
# while  :; do grep Private_D /proc/$(pidof xfs_repair)/smaps_rollup ; grep=
 MemAvail /proc/meminfo ; sleep 10; done=0A=
Private_Dirty:     26172 kB=0A=
MemAvailable:     613712 kB=0A=
Private_Dirty:    235704 kB=0A=
MemAvailable:     403512 kB=0A=
Private_Dirty:    247580 kB=0A=
MemAvailable:     393164 kB=0A=
Private_Dirty:    258268 kB=0A=
MemAvailable:     381100 kB=0A=
Private_Dirty:    265832 kB=0A=
MemAvailable:     374548 kB=0A=
Private_Dirty:    272652 kB=0A=
MemAvailable:     366484 kB=0A=
Private_Dirty:    282496 kB=0A=
MemAvailable:     356484 kB=0A=
Private_Dirty:    286664 kB=0A=
MemAvailable:     354624 kB=0A=
Private_Dirty:    291684 kB=0A=
MemAvailable:     349820 kB=0A=
Private_Dirty:    308204 kB=0A=
MemAvailable:     332716 kB=0A=
Private_Dirty:    310520 kB=0A=
MemAvailable:     330180 kB=0A=
Private_Dirty:    312348 kB=0A=
MemAvailable:     327424 kB=0A=
Private_Dirty:    315280 kB=0A=
MemAvailable:     324828 kB=0A=
Private_Dirty:    332864 kB=0A=
MemAvailable:     307064 kB=0A=
Private_Dirty:    348504 kB=0A=
MemAvailable:     292304 kB=0A=
Private_Dirty:    362752 kB=0A=
MemAvailable:     276240 kB=0A=
Private_Dirty:    380060 kB=0A=
MemAvailable:     260568 kB=0A=
Private_Dirty:    396068 kB=0A=
MemAvailable:     244392 kB=0A=
Private_Dirty:    406540 kB=0A=
MemAvailable:     232548 kB=0A=
Private_Dirty:    417648 kB=0A=
MemAvailable:     221476 kB=0A=
Private_Dirty:    434708 kB=0A=
MemAvailable:     205192 kB=0A=
Private_Dirty:    443988 kB=0A=
MemAvailable:     194844 kB=0A=
Private_Dirty:    452880 kB=0A=
MemAvailable:     185504 kB=0A=
Private_Dirty:    462060 kB=0A=
MemAvailable:     178244 kB=0A=
Private_Dirty:    414464 kB=0A=
MemAvailable:     228676 kB=0A=
Private_Dirty:    420344 kB=0A=
MemAvailable:     223304 kB=0A=
Private_Dirty:    422584 kB=0A=
MemAvailable:     220700 kB=0A=
Private_Dirty:    423904 kB=0A=
MemAvailable:     218104 kB=0A=
Private_Dirty:    424172 kB=0A=
MemAvailable:     218120 kB=0A=
Private_Dirty:    424548 kB=0A=
MemAvailable:     216860 kB=0A=
Private_Dirty:    425080 kB=0A=
MemAvailable:     217236 kB=0A=
Private_Dirty:    425184 kB=0A=
MemAvailable:     217032 kB=0A=
Private_Dirty:    425464 kB=0A=
MemAvailable:     216512 kB=0A=
Private_Dirty:    427392 kB=0A=
MemAvailable:     214480 kB=0A=
Private_Dirty:    427768 kB=0A=
MemAvailable:     214732 kB=0A=
Private_Dirty:    428592 kB=0A=
MemAvailable:     215032 kB=0A=
Private_Dirty:    428580 kB=0A=
MemAvailable:     214204 kB=0A=
Finished successfully!=0A=
grep: /proc//smaps_rollup: No such file or directory=0A=
MemAvailable:     643000 kB=0A=
Type / to insert files and more=
