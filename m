Return-Path: <SRS0=0KAm=5A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7616BC10DCE
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 06:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14E0A206BE
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 06:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hYx/oYJo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dFjWz99o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgCOGE6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Mar 2020 02:04:58 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:37103 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgCOGE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Mar 2020 02:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584252304; x=1615788304;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=LgMGwviSK5P9q6hXwiqwd2MEmBTWQK/CxWzTKADQMTg=;
  b=hYx/oYJosxMD3Nbz07hihW/j/aszfFyT/CWzsFv+ZPlD+ZmSvya2s9iF
   1m8ZDkVjmpTtQ89qvQfaq3pr9vXGoqprxU0pk52P/lHmL1nPcTGir+UrB
   GTNgw2FpFXWH5YKeBNKnxyEwYf0UW+p0UVZm9m8g4NcVsE7YhjeHtjCC4
   kQOusrTZpWhIxfntn7Wr9rCOY2ZUin8VEFpzIGgPmXVG5+uqBPYVr6VTD
   kgMIJFkHF0I2UxuRn+9kPXZrZ99EwtzOvgfEGCBdthJmkOilhwTt+J9AS
   CJw9DKkkDjmXSjsHbOLXkW/03M1oSqdJu+ujnrJq63x5T/QDe8y2kv8nM
   g==;
IronPort-SDR: FVXaOnKsjeOTGR77F4pi4RhbcCGxqWqnofb/ICq+2Mj5bq9sPzkH9W7Mu2t7+iSBvkQx8gHTLL
 /SarmbdTarsJ19lv4pF9X8pY7KE8lVfDH2vf5kjpHOHwhr6/p2q7vycyQqrsC/TTdE1ajCkqQi
 Kbs5m1ms/apOFy27KedGnkI1+7LWkCL6Bc1i5mrPwtHQCfBtmuaKNL4dsfZVVsjeSulRlWCQGw
 oy2sef829B9/rr/F9rigBmCA1AzF0lX8bxwFSfQ/2wAUuYNFy2iiQdNUinvz64glMsypIyV5hi
 FyY=
X-IronPort-AV: E=Sophos;i="5.70,555,1574092800"; 
   d="scan'208";a="234600016"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 15 Mar 2020 14:05:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0Ae5jxOUv5XoA4bfAa9pwo7SGIFIZuEvdUcuhUKgKJHU2DLNDPDhFxyHMCEQf/XfzC1Jni7dJMrl8y5HaW0+9uZ8pGUIlRTQXg/EGUUqwnrzO5Aw58Z9txgb1Qx6TtJqicArC5f8viU3BIlk94hkHkjB/8+C3FPr6CQNvIWsReSv+0+OpFPWGS9ggeoI58oogYmAGBO1FUFe6R31hCYkSV3fIOIU6e1YS+LwGv1u6o8GX1z6v+pk8OkaWDa/WcMTlMgVibNW2ACemY7+20DH+4MCNpHznXw8THaHKPQ2XSEXb+iIROufBMA5vClhPvLcapL8Af6sGZYhtmqyKZ/Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8AemTYo+kK2jN0dacPTTgpF7WRRZIZACAEESchtQBU=;
 b=BTOGYMhsZv+UA7H866NddmmFf7PLRGetc47Ex8DrPjJuItCD/f4mSEZPSlP/0b3g1idI9fEoExXduN/riejK+wVnIG+sBTEY8Xhsq36B6m+QMS8E1w7PXXaGvnV4Xnn6imUarqpqgYL5Hv74wepqydq5YPtKlWCXA24GBcyuZv5A9SGMnEiNTE/y4gDayAVGSBl/hbC5OZzMF3arAfVZmDVS0aqt2x0s1bZUKjATMWcwqpc2w7CSMYUjfRWWdXVKmSspNQPEwHxBzt8CIIchdGCSFvFqBi/buojUntMz+DLKNFG98gtqAm05v2hGTVPWieHnKWiKmgDqyfvBhV0Ucg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8AemTYo+kK2jN0dacPTTgpF7WRRZIZACAEESchtQBU=;
 b=dFjWz99oQmuzqTOuN85kejtYFSC2Z/N+coqViEyc8w/vP9Do8O3YrtFjxOuPQENxOqcy0+2pVFfJxrel+8Xq32Mnv2p3klq9Qz/TF6DzZNnQlCC7i2+CUzopKuq6OUaSzZjj2LuHSpt2HHtsdZoz0HJcq1s+RiNJRj8MvPR0EN0=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (2603:10b6:a03:106::21)
 by BYAPR04MB5174.namprd04.prod.outlook.com (2603:10b6:a03:c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.22; Sun, 15 Mar
 2020 06:04:53 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fdf8:bd6f:b33d:c2df]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fdf8:bd6f:b33d:c2df%3]) with mapi id 15.20.2814.021; Sun, 15 Mar 2020
 06:04:53 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
CC:     Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: xfs_dabuf_map should return ENOMEM when map
 allocation fails
Thread-Topic: [PATCH] xfs: xfs_dabuf_map should return ENOMEM when map
 allocation fails
Thread-Index: AQHV+mtJI1RdQOIjT0uMUo4utssoog==
Date:   Sun, 15 Mar 2020 06:04:53 +0000
Message-ID: <BYAPR04MB5749D0E1EE185B190F85763186F80@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20200314172913.GA6756@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5def9e2e-28a5-455b-8602-08d7c8a6c78d
x-ms-traffictypediagnostic: BYAPR04MB5174:
x-microsoft-antispam-prvs: <BYAPR04MB517493EBB1DFA7B5287CA43986F80@BYAPR04MB5174.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 0343AC1D30
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(199004)(86362001)(76116006)(66946007)(4326008)(66476007)(66446008)(64756008)(81166006)(81156014)(4744005)(8936002)(8676002)(5660300002)(66556008)(52536014)(478600001)(7696005)(53546011)(6506007)(33656002)(316002)(9686003)(110136005)(55016002)(2906002)(26005)(186003)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5174;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kXBZsYFr5CtYZ11JZWeHOA9FB8i/qzGfiROeeF26hISbVHra2Q4nMLtL3nShWa54ZxQfHAaZJslg828q19VjimNXmXeUFjznILHmXH1CjTbBS+1m+XoXC7Ufm9imrVLTK0y4baKL7Q3RuPCLHkx+PTEApXtoWhdoA55Yzc7J6RukT8d+Vg4lImbb70CnQmc8m7+zRhbHzX+HG9z2EFbrsWDH6qdu69ajO7iLU5PBrTrpgmOTOmKQSTXZ4CG0gLw6Eah/AfJs+ukpOa+219Xl3suDA5vF1yuGLDrLcWxwCw3a8r2GqaVxA2iJV8NFbHh+obmoQCfytHXqhhpZuAhqdUkYybtXaUrQ8VDUb6P1zUrvfmnluL+2CpQcMp37Wvq0UNGryHonac8KHCBMr2uRmhYYxKH+CLe2KmQXxlAKNTzI5KXzio8026gtLiwKs8kc
x-ms-exchange-antispam-messagedata: YIne4kp/6aQo+hdv8X1WxqaYBLYeNFTB6qi4UmIksUe2gY5ZUD7JIrIuTuIvYXFl8shK4pVDVYjY9gB71ZcGYaC3sDTa3kosU05GUWeXUHfn+19pVu7MfvrYrmJGICKGPWTR+ldEH+IprK3BBDbGaQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5def9e2e-28a5-455b-8602-08d7c8a6c78d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2020 06:04:53.3102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mdFV844A08I/y+A3s09VbnrUOWXNss9SG/S8zwkH3AQSOPUAZpRn93A5fRRpCEazIdJZeKsGWhtOjrRrv4I0kl2JLOt73iaNb3MtiwWlYzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I've verified the commit "45feef8f50b94d56d6a433ad5baf5cdf58e3db98",=0A=
which was adds goto statement and it make sense to set error to=0A=
-ENOMEM when kmem_zalloc() fails.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
On 03/14/2020 06:44 PM, Darrick J. Wong wrote:=0A=
> From: Darrick J. Wong<darrick.wong@oracle.com>=0A=
>=0A=
> If the xfs_buf_map array allocation in xfs_dabuf_map fails for whatever=
=0A=
> reason, we bail out with error code zero.  This will confuse callers, so=
=0A=
> make sure that we return ENOMEM.  Allocation failure should never happen=
=0A=
> with the small size of the array, but code defensively anyway.=0A=
>=0A=
> Fixes: 45feef8f50b94d ("xfs: refactor xfs_dabuf_map")=0A=
> Signed-off-by: Darrick J. Wong<darrick.wong@oracle.com>=0A=
> ---=0A=
=0A=
