Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46446C61D97
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Jan 2023 18:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjA3Sd4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Jan 2023 13:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236974AbjA3Sdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2023 13:33:52 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2092.outbound.protection.outlook.com [40.107.20.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8694EC65E
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jan 2023 10:33:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlLHPgkoNwj7B5l7ka2mfmu9jW1hfTuPlxKBWXwJ2xYm346LDhcbTnsRfgT9cinU8cSw6nrud2VgHEXncL61du+zVMLNE64s5/1Hsd1zJnqxuZesN5TIuUCWgrCbi9oGDhrO8jrHMP8uPfEpMXkHQoZrwRGyb4NnUgDz1Zw6ovsvXqO/VKA14XFAHEiGziYSD7KMTD+qtbTf28yqRo0ys8n3HAzhy9M6xD3XUE+U4kMmWF+rRhIjpGLcRW4312nq77r/vkalST3S/nVuKQjCR/6DBO/jeAPxVJrvZhA1db6yXpR/heJP+/yDXDt/+3LdJXBXd4S+6kIs4OswZ+guDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3h0s0WobG18baN4dgGY6jYGLi2ZEGNgNPzY6w78Tq3M=;
 b=oWXaorZ6sTaIxlG4ByAuHTAiNppe3MAOsXVaV4AyT68ayCcGcllypaiiQVfTHLceIcNBUcDx56IrZtn80NWXeNyL292rkDskD9d6DiAO4aLLeFFQzIs0G/BwOuiQkkTKkEpg7vQ46HtgVnZUHZDjFtZbjnSOqBa4d2R/5GousUlGrtYqVnQCYpmq90dQQDiH61f8N1348NFQF7T2sojRoE4Dq3U4FUoaP0c+Iz/N5/vXTg1at9XUdfXN/fImPrZgJomg9cIrIfoMJh7ukZqqPevDd9u89tjkMr1x7NaiJFdkJrjVq1qKLksYW+VqVqMKJu31HBJAiXzVB2UMs8SLzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bcom.cz; dmarc=pass action=none header.from=bcom.cz; dkim=pass
 header.d=bcom.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bcom.cz; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3h0s0WobG18baN4dgGY6jYGLi2ZEGNgNPzY6w78Tq3M=;
 b=KFrvMmKh1LJaeWwl8+3etM7CP/lI5u1tqEX3YJLkd8YqXct9lgQeQUreL/AqZw29P8DJYOkQ+p7ZLzEWups6GcO8GuT55+p/DHIB6NEsz7U7J9O5jAu3HPfvIheHlzWkQmxJxd4t7Unz3iaGR77eNhKlZOMmlKi4k/KXf0Cz250=
Received: from PAXPR03MB7856.eurprd03.prod.outlook.com (2603:10a6:102:213::23)
 by DU0PR03MB8647.eurprd03.prod.outlook.com (2603:10a6:10:3ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 18:33:23 +0000
Received: from PAXPR03MB7856.eurprd03.prod.outlook.com
 ([fe80::c18b:6bb0:4121:6758]) by PAXPR03MB7856.eurprd03.prod.outlook.com
 ([fe80::c18b:6bb0:4121:6758%8]) with mapi id 15.20.6043.022; Mon, 30 Jan 2023
 18:33:23 +0000
From:   =?iso-8859-2?Q?Libor_Klep=E1=E8?= <libor.klepac@bcom.cz>
To:     Eric Sandeen <sandeen@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_repair on filesystem stuck in "rebuild AG headers and trees"?
Thread-Topic: xfs_repair on filesystem stuck in "rebuild AG headers and
 trees"?
Thread-Index: AQHZMXJ4TCclsvSXT0mdskAJxnfhqa62z5DTgABJLYCAABHQIA==
Date:   Mon, 30 Jan 2023 18:33:23 +0000
Message-ID: <PAXPR03MB7856F304E5FF2CBAF8B137DE8AD39@PAXPR03MB7856.eurprd03.prod.outlook.com>
References: <PAXPR03MB7856BE8E2D589B6A5FA2B84A8ACF9@PAXPR03MB7856.eurprd03.prod.outlook.com>
 <PAXPR03MB7856BFBFC10B60C0C92372878AD39@PAXPR03MB7856.eurprd03.prod.outlook.com>
 <a7c0ab82-7f6b-678f-387f-cdfbbd278471@redhat.com>
In-Reply-To: <a7c0ab82-7f6b-678f-387f-cdfbbd278471@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bcom.cz;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR03MB7856:EE_|DU0PR03MB8647:EE_
x-ms-office365-filtering-correlation-id: e54f2247-3c53-4bfd-1b84-08db02f07836
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SYLwlSYZ8UTzFGzORXKX9SWbWpt5x/fXD8KArR4YmXFKupXkf+dyq1LCw59BHUeBcejcVOGTmRHAod/YXEtTHq/J3g5bUVFXlqV4DYu1ZdpPru5hW5qsDCkiIPQFKnlo7RXiigYREfABtlGIkiyP5zJKWYYBI0VwVCxm5suIZ6nCVYdAnhIFlE8NfTfYTOtmHYBjBOS6CbVpxh6rId2OpuWaRMhtdf5vVQYrX3MfqjRIW+97pIMG3EuESJkro418usWiS6JBLwzmCxcj9Dv+RvIeQ9GsAG/sgToDQordDpjEFEPM4q7Fm9f3CqRW12qorYCrXpnBpNjRo70c4dbgJ/sJOZDqWDP+7r0Texcjf8pzxfgSM4qnZxCba97cm5vcdckNutXSMRe9V0pc5JtrAbnG5zvIQTYQgY9gSfgjf4CL8nWyxhS+vv203sKC9Ev2dpSiXC3uX+ISEbVMIXT8jUzDG9ok+bWq7DjgNkp0e+O+vS7wI3g8yKMWVGoz8TwKy/3NPsQimXHNb+6b4ozR71krO/schU6TFGahkYpctB6jqLYMud/H9pP5SW3uwQ796DpsodU+sqB/j/0j6GOaMJ1SJQW3T+M4bNo1E1GjrWl/38whNqQpIZujD3GRLmEWGiJ8xR3aMILZI+t2cW8Tq6JuOrTOvR7+m8HDhDTBN6xNVfOcNF+M27uxZhBEcC2GmlCpfoaO1KnAVnuJxoiCY4Jt3iw5jzjQ1fVYxfyvxIg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR03MB7856.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39850400004)(396003)(376002)(366004)(451199018)(7696005)(41300700001)(2906002)(966005)(478600001)(110136005)(38100700002)(38070700005)(86362001)(33656002)(53546011)(6506007)(66574015)(76116006)(66946007)(122000001)(91956017)(316002)(66476007)(66556008)(8936002)(186003)(64756008)(71200400001)(52536014)(55016003)(5660300002)(66446008)(8676002)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?+JynozrhvIEZyptc/LvTo3I/dvcBlZmiX4Dm+X/Na2lJw/yyN57nU0o3vH?=
 =?iso-8859-2?Q?77dVNDg0cY2Fw7tzO2UB/xnIjCrqR5SfrYQyrm/nj3w8BuJZRtksNKKzfN?=
 =?iso-8859-2?Q?zdm/Jl+9m2GwC1ZS+zo3wL+18ipACrVkvBR/DRvd44ORwtyWX4BlxVFaY5?=
 =?iso-8859-2?Q?5mvsiZOt78tRQQJuPrELye6mlnYVpiAXVrc5JMqyN2/qXHp5qpmX96KEMe?=
 =?iso-8859-2?Q?j5Dv58Xp8SyMHuiKW4StlGu6ddNv1P/rG6m8F3FFsHwgOxh3wVQRs2C+sk?=
 =?iso-8859-2?Q?T5wrpNEFejhX7j+upkL6FPJs+ZKp9Q0s8fniLv7MYWX14XcLEMrmKQD4iV?=
 =?iso-8859-2?Q?KBMV1xyUjo7hxPyDbzUtNGXSWVToj7Db+ZzqwvVu5JRBpM4cTrNI/54y8E?=
 =?iso-8859-2?Q?OYHrki4nEcYz3nUdXXWezPuOPWoMGIsr0dO2F5otofJqxBd67DoGS+vjRo?=
 =?iso-8859-2?Q?a8POz1VBUngwmuZ75Bhv1gR9FFdxb47AWlqYiPb3/dRYb7htVGJkivkgCu?=
 =?iso-8859-2?Q?a+WmPyAJENroWhmPUMIPvBKHv5j/suSMRxv5cIbsjshlvznFmjCXzoHcW/?=
 =?iso-8859-2?Q?HnBAimkZe1Gbbud/i9RS5Co3QPCuTFPY4ambxHgk5j+mUuWdiWSdWPSd1K?=
 =?iso-8859-2?Q?Xuq3RavJPZMw8tSTip9POVvxQirEjwscuBGE4FTn8Vq6t6nUdIPZsPUuZS?=
 =?iso-8859-2?Q?xOoHDTa4H7YtSS/fGuJtsT2bv6TCkZw9jh8ySgovlo0mZQzC8KANDMDiHU?=
 =?iso-8859-2?Q?Ijs8UQcjIW8rLjs2hVUTgKNtOQZaq//wzEpeHtOXYGolvFl+Ab+Fc8dxqV?=
 =?iso-8859-2?Q?CnD/ghCBsX5HT8qf1z5myemYSSKKO4L8B8JJXPg39qJ8icUX9QQjcRrDdn?=
 =?iso-8859-2?Q?bRuD4EhvdIBZOJyDOuWdHdyPT2XWyF0LjLaXIUSHAfc9IFLAtvUymmyxEo?=
 =?iso-8859-2?Q?gpbCqhKkGxVKLqYdP05nIBniPHzLsCNbXFeJTiUmChvXZ01e9IfJqQ+D43?=
 =?iso-8859-2?Q?dzpReHoYj75djJXYbX4nPoK3aOemaQFdD9/NuxTMfsiv7++Sfa2PUDyR20?=
 =?iso-8859-2?Q?Zz0wWxbCP13OwV5LaeKqVB38y0Lv7dSDnC3jD4nftCKVYt9QrY0NJDysYH?=
 =?iso-8859-2?Q?0omJlIERAadBW7zTth6EAKNAmXaRYvVYPCBlVwGov6xI58/r0nsDS187RI?=
 =?iso-8859-2?Q?aPM+Zs85XD0P5B7ihNn0KLkLiIP8SPgcNiHDlzvOcE1R7H2JBMUqjmODit?=
 =?iso-8859-2?Q?sXC/9PMIpI2JBaHyODIJKrhkWDI31/LYAfQPgrEOUeXkhkd9mZALxJy/3n?=
 =?iso-8859-2?Q?PaPcsAthUypEIugia1KLCgHzWmMrf+LhD4f+S4rHcZdXVxhWdaBJ1dsO4u?=
 =?iso-8859-2?Q?znsDm1cPOjSWD1w56yr/i0+fQmsl9idokKH+3KkC6PqwOd/NrU4O54YmTC?=
 =?iso-8859-2?Q?QMYHkka2scPh2KsKRzWmxPdtYP8+XkeR0MtbmOQGwYARG1NsjJZWOLUPI4?=
 =?iso-8859-2?Q?QfoeTtGbVJDtOX7/kIHnbgCwm+Q7htwN84NVCg3Q7fF2cQW1uXlJ/YB5LB?=
 =?iso-8859-2?Q?Mp9Lb7eVwnWzIe0bCAGCOIASub2z7oN/r5VYlKu5cs+/QcvKonlT9Nwvtx?=
 =?iso-8859-2?Q?quqeCwZvGfDBgCQKw9lbGHYDD4t92lkXYoF4mktIJSwnchVbRbbeM87f1t?=
 =?iso-8859-2?Q?1lCfJygPyR/6bSIsrlk=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bcom.cz
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR03MB7856.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e54f2247-3c53-4bfd-1b84-08db02f07836
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 18:33:23.5119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 86024d20-efe6-4f7c-a3f3-90e802ed8ce7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gm55qZVVV9hVEK4R+x765miS2S6YXJzjxQzoUn5myU8pibU5XtV8MFx0SRm/Pl2xWmOtUfzyILh/UDshq8NHVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8647
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,=0A=
thanks for the tip.=0A=
I tried xfsprogs version  6.0.0 from newer ubuntu and it seems it fixed the=
 filesystem (or at least did not spiral into loop :)=0A=
Meantime, i have created new filesystem, so i will keep this one until data=
 do replicate to new filesystem=0A=
=0A=
Thanks,=0A=
Libor=0A=
=0A=
=0A=
From: Eric Sandeen <sandeen@redhat.com>=0A=
Sent: Monday, January 30, 2023 16:16=0A=
To: Libor Klep=E1=E8 <libor.klepac@bcom.cz>; linux-xfs@vger.kernel.org <lin=
ux-xfs@vger.kernel.org>=0A=
Subject: Re: xfs_repair on filesystem stuck in "rebuild AG headers and tree=
s"? =0A=
=A0=0A=
Both your kernel and xfsprogs are older versions from your distro.=0A=
=0A=
I would report this bug to your distro, or try upstream versions to see if=
=0A=
the problem has been resolved.=0A=
=0A=
-Eric=0A=
=0A=
On 1/30/23 4:57 AM, Libor Klep=E1=E8 wrote:=0A=
> Hi,=0A=
> i breaked xfs_repair and lauched it again.=0A=
> On beginning of phase 6 i have=0A=
> failed to create prefetch thread: Resource temporarily unavailable=0A=
> https://download.bcom.cz/xfs/Screenshot_20230130_114707.jpeg=0A=
> =0A=
> Also, there is dmesg, when it was trying to mount it and it was stuck=0A=
> https://download.bcom.cz/xfs/dmesg.txt=0A=
> =0A=
> Libor=0A=
> =0A=
> =0A=
> From: Libor Klep=E1=E8 <libor.klepac@bcom.cz>=0A=
> Sent: Thursday, January 26, 2023 11:46=0A=
> To: linux-xfs@vger.kernel.org <linux-xfs@vger.kernel.org>=0A=
> Subject: xfs_repair on filesystem stuck in "rebuild AG headers and trees"=
? =0A=
> =A0=0A=
> Hi,=0A=
> we have virtual machine with 8TB data disk with around 5TB of data in few=
 large files (backup repository of nakivo backup solution - it contains sna=
pshots of vmware machines - one file per snapshot).=0A=
> =0A=
> We have recently upgraded VM from ubuntu 20.04 to ubuntu 22.04 and after =
reboot, mount of this filesystem took ages.=0A=
> =0A=
> I started xfs_repair on it and now it spits line=0A=
> rebuild AG headers and trees - 16417 of 16417 allocation groups done=0A=
> =0A=
> in 15 minutes interval for last two days.=0A=
> Is it in loop?=0A=
> Can i break it? =0A=
> Data on disk is just remote copy of backup, so it can be lost, it will ju=
st take some time to transfer it again.=0A=
> =0A=
> Kernel is probably from package 5.15.0-58.64=A0 - sorry i don't know real=
 version, cannot get it from ubuntu package.=0A=
> xfsprogs should be 5.13.0-1ubuntu2=0A=
> =0A=
> Thanks for any info,=0A=
> =0A=
> with regards,=0A=
> Libor=0A=
> =0A=
> =0A=
