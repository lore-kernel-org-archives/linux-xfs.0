Return-Path: <SRS0=hCPB=2A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EE8C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 07:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52E97206D5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 07:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fxRTQCu8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bOTA0xAK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfLJHdH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 02:33:07 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11082 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfLJHdG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Dec 2019 02:33:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575963186; x=1607499186;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=1Zw8kNiYv28gzEpInFGbK13wdzGgmL3p14aiW+byfuk=;
  b=fxRTQCu8zyHybMLjmv+I1bDep4sF5MKe5ZTdsJMAFYo/wrSXiJlvtSPc
   a+iyfCU/VKliPF3Sy3OkrIJreFjtuR4FDTUCJ4nbaAd9cNdw3eZ1ygBnU
   kZ4D+mQ13JRps0fjQfGpaqYrOGBpe6f96cVq/koyEALrmP5X4qcKZtjwi
   qivhORGKbKpF+0218uRYj/+8EskQH+U98CXsz7ic9FOpOp+toae+jVN22
   /x07dmTu+tuckJVeFkyFwyEB7yWebZMph5uR6JBVHiGZ3mcbMmoabty6S
   1Su48YTeOFR+piDajiRVrhViTR/8llQRfW36DGCn9pEwUzZilZAzzU7Ld
   Q==;
IronPort-SDR: DuGSyNRckgse5OjLXANhgioLI7i8hIT1ng0NLoj6yZt4qoeJufCEujG57o+EUh4DIARuzZKfwD
 vRicGDU7JezH52Q1WPFeKrtmH/q1kxUkWpXCgH0AfL900jTWiJRNU1B9cUYQvprQFEBfFHUgTX
 EjVH2pydkESq2ZiPLsw2Ev5+dBVz71Ryu6AI+5VCy9VIX4vfT06hPIQCrLbGXmASkK0Ml5Hsw9
 N4bTV6xFXImq66WIQ4kXRzegfBiJWPFrM9zkTUNoYYU45R/1epChjSX+H/jst0zK62SRkP8xZ+
 qF8=
X-IronPort-AV: E=Sophos;i="5.69,298,1571673600"; 
   d="scan'208";a="232515191"
Received: from mail-bn3nam04lp2050.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.50])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2019 15:33:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwuH5OnmK3OcMTLH1Dvc718taqA0FvzOujtquuPrVQI1p/kX5N+wlzLjUK2NIo0FAStd32StYjZGG7rrLT5UpFEW8hyFSl0iEFmrQtRmkJlkD0bBFrp3aJTmkyDdCtw+SHLIvRr9I1gZLVECd2sUrhQvMsQHeoybgoZagnWVkRs/NwegT8Yxalec1zb1f1GxdTmMyCiTpOLwUjZ3yGI/JCS1MJ3VSzDJV6oHRX00qlMI41PjAuLJC6OzaobRyPOA1etYEKC07eSCljs+YIooVdi4a1EDhyVLHHZG2CbGwZz35d5m8CsXLKgGz/lwoeCwmWDzp+1MfIlGYp9lR5YlfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivDZP7qevbkqQZF945qQ+MTQ1NOYmTpWDFP/O9cPywg=;
 b=K6zkjKluiKnNVRneQY1r9t+VDkpvrQnJO9uKjZIuJCsjswxdw9dpj2Ajg9E3qrdy1zFh2dCcDEWuXjFg1xXG0uvel7DzZdtye3oHzp2npBDgC/wpN9MeHkopY2LJfGluzmJzlZOWKZ/12gm/jMUS94Ymtjbkz8xeasBsUXi3sjENxTMI9L4pa13nui6aDgpVOWGXd4R05rUV6nvpya6CxOSH8xlxlSndRNdQhHJISgpkZyx2LnoQPE0F89gRYafPY5/TWOb7bIFcD36jvffH0i0QL/w8NSrIc9lNro1kP3CkTRkcQpoI7VAEoTUPG3BJZ3NE8jZNFyDpuSliuJqHkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivDZP7qevbkqQZF945qQ+MTQ1NOYmTpWDFP/O9cPywg=;
 b=bOTA0xAKlWjxAgqNKZk7idcPov2lOSv+605moieCpZnbUCUOoh43LbPmVUDXoCVG9ZRvLI1bO5jXH4UFFsdyUYAczjAGpm2jtLwaeKpD2OwInDf+YS23u7+eepAlCdxgLINL4WS2A0VS12CplrbFD6B4ngiH0KBITAFROUtiusE=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB5671.namprd04.prod.outlook.com (20.179.58.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 07:33:04 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::c3e:e0b4:872:e851]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::c3e:e0b4:872:e851%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 07:33:04 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     Eric Sandeen <sandeen@sandeen.net>,
        Pavel Reichl <preichl@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3] mkfs: Break block discard into chunks of 2 GB
Thread-Topic: [PATCH v3] mkfs: Break block discard into chunks of 2 GB
Thread-Index: AQHVpbQiL/xnqrmVOkaLk2aZuZA4sg==
Date:   Tue, 10 Dec 2019 07:33:03 +0000
Message-ID: <BYAPR04MB5749AF1A90B082FBD8662284865B0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20191128062139.93218-1-preichl@redhat.com>
 <BYAPR04MB5749DD0BFA3B6928A87E54B086410@BYAPR04MB5749.namprd04.prod.outlook.com>
 <1051488a-7f91-5506-9959-ff2812edc9e1@sandeen.net>
 <20191204172652.GA27507@infradead.org> <20191204174216.GS7335@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 159006d4-ee55-4ef0-c176-08d77d433161
x-ms-traffictypediagnostic: BYAPR04MB5671:
x-microsoft-antispam-prvs: <BYAPR04MB56714568F7C761426ACDC4B7865B0@BYAPR04MB5671.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(478600001)(6506007)(33656002)(71200400001)(305945005)(55016002)(26005)(9686003)(7696005)(71190400001)(4326008)(2906002)(110136005)(86362001)(53546011)(76116006)(54906003)(66946007)(81166006)(81156014)(316002)(186003)(5660300002)(64756008)(66446008)(8676002)(8936002)(229853002)(66556008)(52536014)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5671;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D+2G1ntRSTVlaIJc8/pc1ygOwRru5rXAYDYATcd8erJxMiTVhNY8H9NiJLrKrTaOcbqfU37Qi3MbH7UWxiVhbnqxHqaBZWX438P8shaabwSOEskvwX8XW43lemW5V4O/n6WxYYM/WZyPFk/dhRRYO9Bjf1zAma2Ko1x5hnDdKry5y4HgNBK6kPzHOREVv7PKfiiKInuc8STSIJZ/Me+u4EZNGEQwPHGtXlZdilOrpqrxJjc97NXEx8vJMDgfh2nUE7+SZaGPTyi9mnNN+IoQTrrBv2KbE2FAGCKUOTJoejUG42BmvmepTOYeSG1iYav0mrPAfFE6JPxH4GiL5LDEbUojDX5ETpAMsPDHmGVMm9LGeOSgmZFa+F+4jhrmM+EXqp2oPkTXi5lGQlbGn03jfR7i/FGkPJ1ccOfhfZmEPkmWnePjIIk8vJbNFrAs1g+g
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 159006d4-ee55-4ef0-c176-08d77d433161
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 07:33:03.8476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UixVHtE2gppvAPx+acSmaJQscagVIjkbrc6gIqWooNSoSNcWaC1yW1L0r2WBXO8FdYh1tEr84jME3SWL/9xWhfEkX+8wt1UGBWCVjmdxmgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5671
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/04/2019 09:42 AM, Darrick J. Wong wrote:=0A=
> On Wed, Dec 04, 2019 at 09:26:52AM -0800, Christoph Hellwig wrote:=0A=
>> On Wed, Dec 04, 2019 at 10:24:32AM -0600, Eric Sandeen wrote:=0A=
>>> It'd be great to fix this universally in the kernel but it seems like=
=0A=
>>> that patch is in discussion for now, and TBH I don't see any real=0A=
>>> drawbacks to looping in mkfs - it would also solve the problem on any=
=0A=
>>> old kernel w/o the block layer change.=0A=
>>=0A=
>> The problem is that we throw out efficiency for no good reason.=0A=
>=0A=
> True...=0A=
>=0A=
>>> I'd propose that we go ahead w/ the mkfs change, and if/when the kernel=
=0A=
>>> handles this better, and it's reasonable to expect that we're running=
=0A=
>=0A=
> How do we detect that the kernel will handle it better?=0A=
=0A=
>=0A=
>>> on a kernel where it can be interrupted, we could remove the mkfs loop=
=0A=
>>> at a later date if we wanted to.=0A=
>>=0A=
>> I'd rather not touch mkfs if a trivial kernel patch handles the issue.=
=0A=
>=0A=
> Did some version of Tetsuo's patch even make it for 5.5?  It seemed to=0A=
> call submit_bio_wait from within a blk_plug region, which seems way=0A=
> worse.=0A=
>=0A=
=0A=
It did not yet, I can ping on the series with reference to this discussion.=
=0A=
=0A=
> --D=0A=
>=0A=
=0A=
