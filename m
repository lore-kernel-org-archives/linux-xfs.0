Return-Path: <SRS0=J6xf=ZW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B54C432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Nov 2019 22:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B5F2084D
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Nov 2019 22:01:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ql2hESdc";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="N1Fz8k+x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfK3WBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Nov 2019 17:01:22 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:37371 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfK3WBV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Nov 2019 17:01:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575151281; x=1606687281;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=yOttMPTdnukCRMhzBSNNyYnbQIPBJCYc9MlQ4Ow0JYI=;
  b=Ql2hESdc2dlegvjYtU0oCor5pC5+NVHHECSn8DA77m5upmndxJVi07kt
   u1zOjPWeBxNSNdkladtFUCcsZUxvlFpEz2P/lDhL5F3UQLyu8ZXxTAF/F
   0vC5RMUo9IxKhbV73NWe3C/ZYjZA9Ums7RG9TGgWbwCnRAnggYTxZm8Un
   pItnbNFFXu07yUrL+OzxNiqH/IOAXodd2WEjVYJiPLitqNTFWPQKgThg4
   Y+ILPkkFZ6vPHFa9qmlK0rXrpwUQWb2s0yQb0JCi7KFRdTUdMKDgQVfXQ
   wJX274CYRahFddE+ZIsijA4HxSY79rXsZ8OGeVHBZDT2hz+s31/dNn4i6
   A==;
IronPort-SDR: oM5Eb0oeF+PnRKCk+uQdFfXv3OwF276Yw908IqJXTIJ/tAkYHiCmHqJ8uCglzG5d8J7Rtpmac1
 X3lathKWclqY9CpSTEWp8Zw6sGzKfgCQlXS9tpAtUtcBxlDRZRK9quz3sGA31iBLYbV0tmUQ3U
 bb8PIoxLWfd/Y338wEpNMA9zsv7JbDRPi7wdBrzMiwNn+Xj4WCmJAtRYfOpZxcODgD+MUWexFF
 m0MqwJhu9DVYW+pxhltWv9yO77SPScPxS79XuUR0xcBdRG9sohQDqMbFMNCayG7R/G4e8VbSaI
 Zeo=
X-IronPort-AV: E=Sophos;i="5.69,263,1571673600"; 
   d="scan'208";a="125932119"
Received: from mail-cys01nam02lp2052.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.52])
  by ob1.hgst.iphmx.com with ESMTP; 01 Dec 2019 06:01:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbW2pv9x4zPt2QVOVkcffKuGKCKtWBEhMRygZ3P/qBdDnnLHDD9d82bQFE5PWJDIfbskW6ncpM4dSTG9LPorDopXlo1pfx4r7qs6Dv8EyxIBZfmo3urn9abODsnvqrP7YFtsffgTyWMAWrQccxgqmBQRXerWMZ0Bsf+gngmeZ0u9m24pWdjzdarZlv7bSo76K5beIz636dzQV0XYrxgNvSRr4dihNf8lzBAyOyQ2mB21XcQbJwYQMFin6RGjoNKeNbq+QSaH1dSaeBhMh5S0RLcHcp5fHUoQ8uJHM881ItjaA7IVQ0Vr5Om4JRVn8QNqQ508m3nSgeJ8JNI0LjKNCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOttMPTdnukCRMhzBSNNyYnbQIPBJCYc9MlQ4Ow0JYI=;
 b=kMg9xmjLzq+zXPjZgNaxkKvXxDEohX6/NldWLtrUUY7pHSTSCRMcVbVO5InPHsoYyaT5mKr++P7nxUNG6Pw4cNs9T7PaOZvaM4ey6II4BaEHXUCjkQO9RfJzUvxjWE4ZWexF4MWjVk7B0+zn4e+cAtspxR+bOn3IvGf1MHqOUjxcIEObGOpBHwC1GjyLTFa6WnGb6HEdFmHjmIyNnmM24wNw+x6TG4oE/nB6F+LpY0I31UwaN2RBKUZO/X6nxMDf/ucFx6PolUPQ1BsbFbWgHuuWbyEoO8yxYqbjKSKM/cZMoK7nviu9ZOPkV6gHoI6dCjkRQiN5niGnCJZlAbiebA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOttMPTdnukCRMhzBSNNyYnbQIPBJCYc9MlQ4Ow0JYI=;
 b=N1Fz8k+xDxw2Y/3l3wNO+Uh/cLH4eHA9SLwnymm37GIEFXY/jfXg7G/42X0wr2L5Iq5estsfW7JmFA6ALnWuZF9thhlxzMvWvqosCNoUESR/QSH0rS0NrtmTAcZkFFynEoV14Nbwib6p9urZrZsw0LYTKFj754tl2XiUgIpVEKo=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB6069.namprd04.prod.outlook.com (20.178.234.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.21; Sat, 30 Nov 2019 22:01:18 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::6066:cd5d:206:5e04]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::6066:cd5d:206:5e04%6]) with mapi id 15.20.2495.014; Sat, 30 Nov 2019
 22:01:18 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Pavel Reichl <preichl@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3] mkfs: Break block discard into chunks of 2 GB
Thread-Topic: [PATCH v3] mkfs: Break block discard into chunks of 2 GB
Thread-Index: AQHVpbQiL/xnqrmVOkaLk2aZuZA4sg==
Date:   Sat, 30 Nov 2019 22:01:17 +0000
Message-ID: <BYAPR04MB5749DD0BFA3B6928A87E54B086410@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20191128062139.93218-1-preichl@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3c03faf4-40e9-4aa5-de91-08d775e0d3b7
x-ms-traffictypediagnostic: BYAPR04MB6069:
x-microsoft-antispam-prvs: <BYAPR04MB6069B8747BC4F2DE47F64EF186410@BYAPR04MB6069.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02379661A3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(189003)(199004)(66066001)(71190400001)(25786009)(6306002)(3846002)(110136005)(7696005)(6116002)(8936002)(86362001)(81166006)(81156014)(8676002)(14454004)(55016002)(2501003)(2906002)(6436002)(26005)(6246003)(186003)(256004)(9686003)(4744005)(102836004)(6506007)(53546011)(76176011)(66446008)(64756008)(66556008)(66476007)(76116006)(305945005)(99286004)(66946007)(446003)(5660300002)(7736002)(478600001)(966005)(229853002)(74316002)(52536014)(71200400001)(33656002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB6069;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x2BpzK9gOOBpRW7uDIJP50k5YHG6TNDK0ehG15zOi0on2eebZRio15KhqwwRUNXYW+/iYE5Vp1IMQWiJB+mfInZmdzBT39g+syj9Uw+zadp88BVz2KnMrf2nQrB4Mnvg5Jwj8dN2eF96T73f5ofmjkh3bSY5zwAwiW9h1mWneoTW0+lo8X5+JiDrkxro77rKd3HNK/6iXtsZknvGNcHhKfL2icYXhc77RpRwJLgwfo7ENAb9KsxZB1uA2dFocCzZve+VUKTakCkcARD5FRg/7mwBSygrlXTNUFqJcFXwXcs+rKnjflscxYLNnZwVj7YEOx7L/vtBUV6syrEMHbGui0+9L8bvSOu6Acdg9rTTKjm0Ixve9C8H+Nx0AA+KXL0iSOQrZ7vZQWdC6Qlyxl9Ll/mJWJmFOuiEVK6J/2DfLnqFs3p95hQZ2cB5Nqf2PmdFEtw/AnyqyGE2fzxCKemMv8q1BWIFWQDDxN0I+uQubXU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c03faf4-40e9-4aa5-de91-08d775e0d3b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2019 22:01:17.8392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SvuURsB31olabrtjEeM6BPjzNQsVGSXDlAkQvCLbG8eZJyatr9/loRqMydWGjC6tB0o+PHp8PqPc+c7X+1+fI/V67XiB1sq1ifkOX/qvVK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB6069
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Not an XFS expert, but patch to handle ^C is been discussed on the=0A=
block layer mailing list which includes discard operations. [1]=0A=
=0A=
This solution seems specific to one file system, which will lead to=0A=
code repetition for all the file systems which are in question.=0A=
=0A=
How about we come up with the generic solution in the block-layer so=0A=
it can be reused for all the file systems ?=0A=
=0A=
(fyi, I'm not aware of any drawbacks of handling ^C it in the block=0A=
layer and would like to learn if any).=0A=
=0A=
[1] https://patchwork.kernel.org/patch/11234607/=0A=
=0A=
-Chaitanya=0A=
=0A=
On 11/27/2019 10:21 PM, Pavel Reichl wrote:=0A=
> Some users are not happy about the BLKDISCARD taking too long and at the =
same=0A=
> time not being informed about that - so they think that the command actua=
lly=0A=
> hung.=0A=
>=0A=
> This commit changes code so that progress reporting is possible and also =
typing=0A=
> the ^C will cancel the ongoing BLKDISCARD.=0A=
>=0A=
> Signed-off-by: Pavel Reichl<preichl@redhat.com>=0A=
> ---=0A=
=0A=
