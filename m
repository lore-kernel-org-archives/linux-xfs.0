Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB84C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 04:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBBC320784
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 04:43:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HWKVGvve";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rDMai2Bk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgDBEnA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 00:43:00 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:61254 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgDBEnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 00:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585802645; x=1617338645;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=lIpyJzrsrp8/IaexaoGCD4kNMHmTYHj5/hnzNhEosY8=;
  b=HWKVGvveqKH/RaVr7zuRU7C068xzaxLFPO2vwHL1uamkL28wIGc78tNi
   b98ZTBl5jIwA6y3RteaU0JGMI3KOE7T9bECzBX7gpnCAgigUqj8HdCWeq
   DyryCpYz+YQrTzuMtbSCELiw7Qz3QR32rIOyU3RmiL295MNhgkmtjJpu6
   GC+S69nREUSDfEoqmYKjqoTayouRl5rlSw8acvVWv9QhWI3oDYDRAnPqC
   T1eEg6FddSXI7H0+bKh+WbQiQ84rYDK7Ptv6Bh9mfXi+fhBFKf/9FkFQ7
   qWzXpMDkHhuO5pbt9TydT4E2x22HPUWu2xZwIiKiLtiPo0cLZDGbdG5dL
   Q==;
IronPort-SDR: IxYukiKsIP0eXUNoJZl5gHsB2UN1Bq0Yl1mJLF74MOzacthzOSPDRimalDiozwYwrezrvVquG6
 MOoh/AxDqhClFuiHnKFvdv9UnD4cMMcVNUJROW6aWNqj48c/0wV2cpG9MctunvBODM5aM9SpId
 OJjm+m0iGCZPlLFc9PA8Mvjlenh7EJyEK7L0lH4aj0Ndg9x1UZzkmJ8VUjqpIIEyY0Bcuj+jtq
 E1IbK1JbscqnQMjWsCGkoS/xOMYAWwwpexNwMzAqEuBkKqT+iv47+bBeGS/nXzkpjkHK7BIanq
 /qo=
X-IronPort-AV: E=Sophos;i="5.72,334,1580745600"; 
   d="scan'208";a="236660312"
Received: from mail-co1nam04lp2059.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.59])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2020 12:43:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nbg1BZy6rS7nsA70VIXuNZyg3ksnm99VlAn7xcdgtP4urLF+suEp3bim48cBieg1QVCpQBtqqX+yOb6CAA7z7Az6hSCaUeo0F4XApOMQerKZccDvQ3zvAR+3dRI1JWncVlerk4XprMQdUVz+1gXZ8ANsVmyfadpeSF3/NAlDBXy3ZzI3c3brhge3V7WhwgWdyONf3UTMfZMTUfsgxfdkcaTzd+W6ws5luN7Rs2ZcG7lsOAy1JpEF3cW7zLD00rkeDK6zgS/lmjbaaTrhKBsPTqfJd+SOHwmeULD+IZVW5Ro+3Vtm8cgw8Q56GyzGJLs3nugsW/WwqDVbCVQRdHGk/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9jVLXX5x4qm4xiaJaqlVNc2cGDJnWYsf4Tqp0dOqmQ=;
 b=gR54Ixk884ihLUUe8jm5f4s02BgeJMDvfFnSai9kOBz5U74hafbEXih4KwdlhJ0vFZbbAsq3V4hL8uxNTedkZzH3boa0gFpj54rUM+vJlCR+9NXcPEEvAhVCrwtb/neX286ziSpLyMFGrnZ7n0+2rvj1gMx8vSl2X0fJIBPmE9PfF+/j1CmwxkHAyCTwWxFAPrHamSHXhpriNlARLTV9yOxA8en1ZFYDeTq7B6QhcBDuIk3o65JvAj0q75DPXKssM+0yxJedMF1I6h6qmCOVST1HQ7ciwqvzZ3VlHz1LZ9UFmKNymwmVHhl5YP6AXkvUu746IVrPf0oVL6Q0g7qjNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9jVLXX5x4qm4xiaJaqlVNc2cGDJnWYsf4Tqp0dOqmQ=;
 b=rDMai2Bk1U4eemhkfz8j6GLGls5Sb6HXyP67pJzTUihytMB2xcy7gInjyqUGujH38iVSJFzjx73kQyzsNIdGW6eBm8R0B1q6nNvM1PVxVlJTit+NEY5ZjaZT5uEA4nLqHnxQ/fxCTLDR7AcZeZ/RgVibCHvvZgDCHY/QKK6PCuA=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4038.namprd04.prod.outlook.com (2603:10b6:a02:af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Thu, 2 Apr
 2020 04:42:51 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 04:42:51 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "xiakaixu1987@gmail.com" <xiakaixu1987@gmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: combine two if statements with same condition
Thread-Topic: [PATCH] xfs: combine two if statements with same condition
Thread-Index: AQHWCJYtN/QAgtV1/UWoH3Ona7gTKw==
Date:   Thu, 2 Apr 2020 04:42:50 +0000
Message-ID: <BYAPR04MB49656568C1EA4D2BBDB5FB9F86C60@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <1585794394-31041-1-git-send-email-kaixuxia@tencent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ddec31b-65ab-4b74-a059-08d7d6c04cff
x-ms-traffictypediagnostic: BYAPR04MB4038:
x-microsoft-antispam-prvs: <BYAPR04MB403869A20761FDDA4D0E4F4B86C60@BYAPR04MB4038.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(52536014)(66946007)(26005)(5660300002)(55016002)(33656002)(9686003)(186003)(7696005)(81156014)(81166006)(86362001)(8676002)(2906002)(4326008)(64756008)(478600001)(54906003)(316002)(53546011)(66446008)(66476007)(8936002)(6506007)(110136005)(4744005)(71200400001)(76116006)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5pItrRfBosqb/rPr2qxDLeZxTqalDxRiHFpx1ZbX0uxl5+5gbMkpMDl6szIu4nIWeuNJFZhqXWvenaCtQ8eh2M89/9KrHlEydfScwF02IO12DL0FOGIu/X26xVyg34ArxecKmQ4i8VVZkDHZ96Dib3hjz+CgaYR55lSVxo407nS6KOaDfwFBR8riYCsG6XJqQqx5ksjLyNHf7E3aYBsYZt/UuBaxGPGqdgh5TN1XwMkIxFmOKE+StSZeIiCsFFHsdMOCX2fQpWu7MmfwxXO0/ZjEGtEer6GCvIcOU3D+Pdkhnqm7FnG5BnCplgzjrkS78y9q/S2mkgFUGh9lOiQGVHJegwpLW5kg3J9Qa1fwCH3bRemgrFSbXQuuctXS9h29GUcQTpl/2rrI7/UWpoV1q4GCg3HBl5iZdVBXBPvwmwBHCdB0G5SAUGIR9zTKiGuc
x-ms-exchange-antispam-messagedata: v1X7gMksvtEg5YOadfogi0ZizMBm9mFriL4VNYdCU6RSRIKsNYPtnavI22g6T93T4FdDyJwhiiXNihmebVJXNJnHOcA3muKbl6E2RkhGwPJLMl/nA0+7nQFItMxJEh5vem+4K/6RzTHRWmyTen2MTQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ddec31b-65ab-4b74-a059-08d7d6c04cff
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 04:42:50.8901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZHgOdnFWfhUbMOw7INiwBPwLCXfPWbcZw5E0Q8UnZ4nUS0nJpcsYKIJvjqvWjP0IvQRwG3ZTeCDx29vUcddaKg0xGmrL4YVPARallrx7oxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4038
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/1/20 7:26 PM, xiakaixu1987@gmail.com wrote:=0A=
> From: Kaixu Xia <kaixuxia@tencent.com>=0A=
>=0A=
> The two if statements have same condition, and the mask value=0A=
> does not change in xfs_setattr_nonsize(), so combine them.=0A=
>=0A=
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>=0A=
=0A=
Prior to the commit c4ed4243c40f ("xfs: split xfs_setattr")=0A=
xfs_setattr() had truncate=0A=
=0A=
handling in between two identical changing file ownership ifs.  Since=0A=
then truncate code is moved=0A=
=0A=
out of xfs_setattr() and mask value stays the same in the first if, it=0A=
make sense to combine these=0A=
=0A=
two ifs. Looks good to me.=0A=
=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
=0A=
