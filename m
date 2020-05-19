Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218D6C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 08:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5C13204EA
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 08:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F9pUkTxb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iRVyUljc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgESIib (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 04:38:31 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:1539 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgESIia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 04:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589877510; x=1621413510;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=s2HG/TVioXJP0qT3UTgrnAPFa8ZDdYT2WmcNFJOFCcc=;
  b=F9pUkTxbMVXuV29fgeQ2KpmKkFyc/ipNKm0B4JEnuDYRvPFJlWAH44Bt
   +M/CLajFwEBYfDb4tkJbMwSPzZ6dCqgUo6eSCFFFveeygyeqmAnoLRA7e
   M1aKJj1DRKjLblacQ6ktBla3JVLMP+loPkpdtfGr1MNvzgkkQKKCkPTFY
   rr2LFM3NERqE+R6EbiETeqSf1DmBeK4iheCAn8DC2xKGq5eLaTGE3scU8
   RYmCX11LkBZlZv7oSizIm9AtA3CyxLGfkeWJnijVM/zAS5hnQqDGaKoCl
   RD1qRphYFI7McGQjK5FnRaYJb2IzvrVd4Qm9tBOja4EKYB54A8aWJlMmg
   w==;
IronPort-SDR: Bw0OAUXt2Gh0SG2BSr/h4Fv3iGubvHpEznS+4xZwOUKwAvYUmvnctzHg7cxRCa+HzdSe9bvdpM
 8sfFgGMhWvbEAt9QlTWAnh2I/XG2dsU38FGAdZGiMAFztNjiTZhk9QALJiaII6bvMpEYRW1jPi
 taR9alhlMZEr9brt0m5GOG4lolaStSSQ1S4QzjzVgmOiy5ThBcuxAlsTgTFBGgosWigXQSLGlx
 oRf6FDL8atYR18OTcNVKq3lPH5Pla/X1DJffjZS+tcqjlLwdVYYnjaAHO5W7F5QH3JairV8T2q
 E3Q=
X-IronPort-AV: E=Sophos;i="5.73,409,1583164800"; 
   d="scan'208";a="138022483"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2020 16:38:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmWRgpbguAwYka+/e5BW4+HtnmEAUGf/XBQQG8CEta/nFnNn+WzF/aXWPawrTEID5OScSJVzQMg1Gb7NzdfWqrZruYDDnKVgnURc1AeGGfMyatlkF6LoWlCcTQoyEVHjfpmlBLQWbHBLOy3oG5lIvGKLnCbgHqVUn+PiXTl/8S+6L8YmmskFKAPsQOFkic5IFJKZEqIAe9Tv6uo/KXaQNJAlyrfXJm513xO3IsU3HYEtMZVrZeUeUZlVwpttASKuazjTV65NJNw2m9Lv12233YcxN1xChvoWmGJr0dcL8UEwq6tmpL/3AYsu9SuJBQV5sb1mRcFZlVAcGW/Hwgy2/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENrQyDJ/qS4T3TbVVYd4vrbqQ0Msflis8037vfT7Ffg=;
 b=U6Baw+WMeeDfk7PhzkhFUgW+U9M3P2FJ6k1MnV1mcN4+7pCRpx1C+Cc8RAVjsEJnrWw0QeeWRxpAvVDkr+XdwWPfU7zmkVBMQYkzQNCFM+5XSRj953oPrxMNLBnvxbddBjt3nPpdhzXxZy6v2HbKePVwZkvjSeGJj1a5hQcnB3ZTk/azPiNGKJHlKsmykwFVnNIhHttMaWpFnGFuejXLQe0X/BLytngbggaIuxJF259HpQVDVT+0OLReLj97wbJZ/AEX7Vn7IMZIHNaOuYdYdpq3dO8RkcX2w48rXdOmJpflQiPpl8jiUWImGD3nFhwmX+mO47pM99erJWL45SWWrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENrQyDJ/qS4T3TbVVYd4vrbqQ0Msflis8037vfT7Ffg=;
 b=iRVyUljcYSXANOM0y+96qXBRdVvWhLxDlrdkzo6XFDX6kAr+ShYK1bMNbuwSSr/hgdR6m/vfLwyBw3s+sWkZQlfIvnrvcBUs6ygzF9C2NNyrqdDoiKa5gntBhtPTO2mLJGrv760u5lc8WqANnvOD1P+tdqujAUUrDdrmENVKCYg=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4214.namprd04.prod.outlook.com (2603:10b6:a02:f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.31; Tue, 19 May
 2020 08:38:29 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6%7]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 08:38:29 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "xiakaixu1987@gmail.com" <xiakaixu1987@gmail.com>,
        "sandeen@sandeen.net" <sandeen@sandeen.net>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] mkfs: simplify the configured sector sizes setting in
 validate_sectorsize
Thread-Topic: [PATCH] mkfs: simplify the configured sector sizes setting in
 validate_sectorsize
Thread-Index: AQHWLag5fSlQcAoVQkaDUBM1XX1lbA==
Date:   Tue, 19 May 2020 08:38:28 +0000
Message-ID: <BYAPR04MB49656AE414B13D704CCC6A6B86B90@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <1589870320-29475-1-git-send-email-kaixuxia@tencent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a819fdce-5ddd-4e5d-186a-08d7fbd00157
x-ms-traffictypediagnostic: BYAPR04MB4214:
x-microsoft-antispam-prvs: <BYAPR04MB4214A63919443AEE229A5B7186B90@BYAPR04MB4214.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 040866B734
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Epla6gYmlZaRbPUw5iS6R009fBd22LVChWRd444neEDt52MOgqDZ7k48dXwUs5gUXB2aPORiZxl8zyJBypEmPFQUYSChdD6gV4BlIZRNtUNc+nQ7JYGlBOjVKvssVYSjsTg7Md0qZ0qJ3AVRdFQTDU5n53gTxk9DFef9q/zUMCuCUh6JJe6vVBLk1PX40EK6DsvQ2a+Fk8bzEnYfAAtB1qo+GGG1hrORYN1FpZwGNcXfQbodNv/7X1ooU1xYw4VpdGFeXoHDhHXsL7LwHbsuusKXkq10vfuhcvUm6IPbLbu9EwDW6zDlq2CTv1lc6JM4xMO1frxOjVSlyi/pVu2HIZz0DTm6X4emOHz2NhCLWG9s0gKInXR6rtBoh3vDGce6sa7RITEM0cT5sGIMvadCoJjXfesLuyLqsx/eaBIsMb+WfwSGzsw6jbl8a1OJp/4unnh+1msMBX1Kbu9tcrPXCo4dvePcyLkpdBzfU3GoEcnk9ElNi2bJD5wvrnQv3epg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(66556008)(64756008)(66446008)(76116006)(5660300002)(66946007)(86362001)(7696005)(478600001)(2906002)(4326008)(8676002)(8936002)(53546011)(6506007)(15650500001)(55016002)(71200400001)(9686003)(66476007)(26005)(186003)(52536014)(54906003)(316002)(110136005)(33656002)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wwzHv00nG89zJ3aNk4ONuQIxt2p8Ct09ol1CHJHDZ6llK/7RXmF++8cuOE0Erh5qbWf2onVDuEiRiNeFqAH+/EyZB5c45mMs0QXiF7koQzMG9ve4h1zSK249gNFhsd0hO9BDOATRm6Acwz/3o6PGQxbVkwU70yDVUiYUOVWPudVySPOlxbO3n6dXvwQaBxHN87BWw3mi2rznxuDzMePA+UUPRQ3TycLXvgH2I8q2dOobD74eN4iTvpBvh5W6vopUmlw0twokTW5rMrGyNM27QwlD4tpGLRYphVvKg9L1/wBc1I26rft+V8kLNVN23inI3mUdLdeC3asR3oq5lp1WgD/EvKOgfl8MGmdAFMxmJZUHtXftkzmqdAY6I782QVLadCwniOxu/JlVcTP5Un9zsZ/fG015qLwpAWbboxGLL9NKXvi99g72vEKWI9X/fnEdmaVnbAfNN+TbCSJXH4h5z/OTg2kR3o0QaChG/OaizzI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a819fdce-5ddd-4e5d-186a-08d7fbd00157
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2020 08:38:28.6751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MuVu2Wk0hdqGUCphMKbZuLgASwdelOcDYO1JBpIXN27EabRvst50ls+l934NmaT+T2o5YTiGB8VLADtC7v/h7HX65GgagE+mTwa9uxkINkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4214
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/18/20 11:39 PM, xiakaixu1987@gmail.com wrote:=0A=
> From: Kaixu Xia <kaixuxia@tencent.com>=0A=
> =0A=
> There are two places that set the configured sector sizes in validate_sec=
torsize,=0A=
> actually we can simplify them and combine into one if statement.=0A=
>Is it me or patch description seems to be longer than what is in the=0A=
tree ?=0A=
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>=0A=
> ---=0A=
>   mkfs/xfs_mkfs.c | 14 ++++----------=0A=
>   1 file changed, 4 insertions(+), 10 deletions(-)=0A=
> =0A=
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c=0A=
> index 039b1dcc..e1904d57 100644=0A=
> --- a/mkfs/xfs_mkfs.c=0A=
> +++ b/mkfs/xfs_mkfs.c=0A=
> @@ -1696,14 +1696,6 @@ validate_sectorsize(=0A=
>   	int			dry_run,=0A=
>   	int			force_overwrite)=0A=
>   {=0A=
> -	/* set configured sector sizes in preparation for checks */=0A=
> -	if (!cli->sectorsize) {=0A=
> -		cfg->sectorsize =3D dft->sectorsize;=0A=
> -	} else {=0A=
> -		cfg->sectorsize =3D cli->sectorsize;=0A=
> -	}=0A=
> -	cfg->sectorlog =3D libxfs_highbit32(cfg->sectorsize);=0A=
> -=0A=
=0A=
If above logic is correct which I've not looked into it, then dft is=0A=
not used in validate_sectorsize(), how about something like this on=0A=
the top of this this patch (totally untested):-=0A=
=0A=
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c=0A=
index 3ed7d844..6cbd5d9d 100644=0A=
--- a/mkfs/xfs_mkfs.c=0A=
+++ b/mkfs/xfs_mkfs.c=0A=
@@ -1690,7 +1690,6 @@ static void=0A=
  validate_sectorsize(=0A=
         struct mkfs_params      *cfg,=0A=
         struct cli_params       *cli,=0A=
-       struct mkfs_default_params *dft,=0A=
         struct fs_topology      *ft,=0A=
         char                    *dfile,=0A=
         int                     dry_run,=0A=
@@ -3696,8 +3695,7 @@ main(=0A=
          * before opening the libxfs devices.=0A=
          */=0A=
         validate_blocksize(&cfg, &cli, &dft);=0A=
-       validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run,=0A=
-                           force_overwrite);=0A=
+       validate_sectorsize(&cfg, &cli, &ft, dfile, dry_run, =0A=
force_overwrite);=0A=
=0A=
         /*=0A=
          * XXX: we still need to set block size and sector size global =0A=
variables=0A=
=0A=
>   	/*=0A=
>   	 * Before anything else, verify that we are correctly operating on=0A=
>   	 * files or block devices and set the control parameters correctly.=0A=
> @@ -1730,6 +1722,7 @@ validate_sectorsize(=0A=
>   	memset(ft, 0, sizeof(*ft));=0A=
>   	get_topology(cli->xi, ft, force_overwrite);=0A=
>   =0A=
> +	/* set configured sector sizes in preparation for checks */=0A=
>   	if (!cli->sectorsize) {=0A=
>   		/*=0A=
>   		 * Unless specified manually on the command line use the=0A=
> @@ -1759,9 +1752,10 @@ _("specified blocksize %d is less than device phys=
ical sector size %d\n"=0A=
>   				ft->lsectorsize);=0A=
>   			cfg->sectorsize =3D ft->lsectorsize;=0A=
>   		}=0A=
> +	} else=0A=
> +		cfg->sectorsize =3D cli->sectorsize;=0A=
>   =0A=
> -		cfg->sectorlog =3D libxfs_highbit32(cfg->sectorsize);=0A=
> -	}=0A=
> +	cfg->sectorlog =3D libxfs_highbit32(cfg->sectorsize);=0A=
>   =0A=
>   	/* validate specified/probed sector size */=0A=
>   	if (cfg->sectorsize < XFS_MIN_SECTORSIZE ||=0A=
> =0A=
=0A=
