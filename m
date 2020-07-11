Return-Path: <SRS0=A882=AW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9580BC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jul 2020 18:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 520FD20748
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jul 2020 18:11:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S4B3pqX/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="D08EjYOU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgGKSLF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jul 2020 14:11:05 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:5795 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728507AbgGKSLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jul 2020 14:11:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594491064; x=1626027064;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=v5hGe7fLNIPvvq8U2iUsm700cGVbCNP8ZJma0aH+LOo=;
  b=S4B3pqX/EuVxntIQC2o0MwNmziRWR/ql70R+NpXHMgHaBVbpy8PXuTHj
   My0hdy7TUPctmlQ4YV0gRLxQ+ENwWp8Vu69H40eUuzhkXoVIcAoH41CRT
   vHuUnRnIc3+XL3rkgjEcB1VQdni/5QGhYwzA5KZ8N7IrCDuFLopjkaFK2
   gpfv22NpwVdePVAMBaAFTHdEjyqDkGj3Lq9s9iqp27JoCJyL0NDg7fihO
   KFL5WbQpawT9XfmAoj1V5myiDgA1EQubq/lobbE9dTKbmPNn1XYx3668d
   IXjPZI9rojZRn+LJIZ+UkYKtnDUAIxAaqCiLzPGlxJOXac/6ZuAlckYXb
   Q==;
IronPort-SDR: J7ikzSny+kB6yziQgf8O6ZzT7M4h6svzppCU/QiajOSyPT+Juamjec8l3UG1OSEPkurAc3rz1i
 ysP3dvdT00b8EYFnE5RRDELpnzDczWEO5G+ZYC894KeaubRJ+nkmHnMox3JaAKLBJLRCGP5m7/
 i//XAK84wZShwRnDr29QsHTn/5//+7L2ya/6LMX9C1ZXtL3MGxBvWI54XOloLoPk4okkwGZySu
 Zya5pMbg5XiC39aGDgZ9gvoW5X5rfjmEkC4STA/UtVX0eEhPkSYkNtG7Jv+WdZAN9N/f7o7pW5
 LPo=
X-IronPort-AV: E=Sophos;i="5.75,340,1589212800"; 
   d="scan'208";a="251453479"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2020 02:11:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUn4neEiEk5XoJm95oGVCKdSiBZlgziaWc9SNWat0DuawHdnSDa+kn7zkUD8tMBk89ceBGyrBExDbEqm4fwRZ94o8qysd0dS0KTXOAZEOJw97Y3T7LNESctpfOSeGqkc27o2BIcqqkRXPVMrTCA1ErHeFVwrzp+Q5V8a+BdDJs5Liy+qVl2yCkJeZBr+P+wt+1xkLnQpOEmFFlssbWgsOAhTSbu1448UKNAA8x7J+I5H9wUygnGCqxJbOgepnqWYrVD2pqDv3NBR3Gs4pSpJIxA0+6K6GwaXz548pCK5zkqeKEA+zbfAaIL3pXG6kV1GSdmVeap2tl8E/HyqaleAzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5hGe7fLNIPvvq8U2iUsm700cGVbCNP8ZJma0aH+LOo=;
 b=NkY214CIzkfJjKd4gZlqaPBs0vOOseQf0Gjkb29PYCHikD9ZZR4uJgAQDHs4SCP05ausQ5Wvv1V3G5VTHuK5e1pokr4aklhxET3AvLdxjvv+ne9+yXF5Hv1lTO7QRul09Uogi08WqHRlEUXyAzNcHqrRdJ2pzMZMsJiaAKAnI7HLDuKgDkRmPviIBZt72qXOadRdb3hjvF950H4ivagTCRGHGhpl5frwRkVwkUxvaA3JC6S6Yi1G2/VoCoh3HGQeshy1Sk4Cg8npMvp3eTULFUrol/VaU9Lo1gWVjkzWecEIQ2N5Yf2TYVlzE7udd6w1LQUT2QuJeJeYwVFawSgDdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5hGe7fLNIPvvq8U2iUsm700cGVbCNP8ZJma0aH+LOo=;
 b=D08EjYOUfUL4Ir13Wo+rogfOybgAsY0hSu6WuD5+SA3t6lmhgddzeEnK+cfDXq7INRFFYul0nN4TgQM9GjBLRH+ckWJ+XMoPENF9w4OoXCoKCR87wjYWkb3M9DnJYSEl/PTk9RiUcgr6YKnQHlknQmRmvFBfB0DhOQs1ao63CHo=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6279.namprd04.prod.outlook.com (2603:10b6:a03:1f2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Sat, 11 Jul
 2020 18:11:01 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6%7]) with mapi id 15.20.3174.024; Sat, 11 Jul 2020
 18:11:00 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH -next] xfs: remove duplicated include from xfs_buf_item.c
Thread-Topic: [PATCH -next] xfs: remove duplicated include from xfs_buf_item.c
Thread-Index: AQHWV1U6LD1N5WyC9keVw5NIgFpb6A==
Date:   Sat, 11 Jul 2020 18:11:00 +0000
Message-ID: <BYAPR04MB4965C065946111404C726BE386620@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200711073458.27029-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9544e8a1-0bd7-4f1d-3d37-08d825c5c48d
x-ms-traffictypediagnostic: BY5PR04MB6279:
x-microsoft-antispam-prvs: <BY5PR04MB6279DF96FF2F6D773C43BF4986620@BY5PR04MB6279.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:418;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yEnA8nO56K49MboAcYv7ljUDQ3v4DoHijpIBUhDQttZYcrDu5BwWIUgNHoAQ+uIVnRDXqVrWC+KzfZXGiqgY3PYRSBffVj2g2Mr5V7NEa8AikjFKv7LCF/taNJOHeCN39+mtbFJoEXy0oKc24PMaUCiAvMyv4vqmiTWGYnI5O7wGHCoIcM0tOXVrp6IXfIpO6y0LPOssq/b83noPa/CFfTEuZ1ju7t8DoYZyKvcw/o0L5f6e/WuLp36TpheE62YlYJ59lzRut60oZEhXO1Hr57UJZxTR9CFljVMm3YfzWUDHXe8rlbo39KgboRYwNhb8QrVuYESQ7HKWSneIruk5Fw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(55016002)(53546011)(9686003)(7696005)(76116006)(71200400001)(52536014)(4326008)(26005)(186003)(33656002)(558084003)(2906002)(8676002)(5660300002)(54906003)(64756008)(66476007)(66446008)(316002)(478600001)(66946007)(66556008)(86362001)(8936002)(110136005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NDw7LP8V7LDeIGpSONjwahVHuJI6aDX0Ng5aTsMJF2kShs7j1bOhAM/HKI0ljF8bdSfRBmf+rFGkIn/Fg9Fva0Hg3UzOggyUuQJiYr3rsa6mzZljjSzXLWbgFXMtoTNEEV0GTpq8XTehlx0Xzx63OmKtjSJn5OR0co+s7SixKkc4EWiL2Pl07L7DjJ4ObCSQm5XDJQj9HMmkcyuC+phhVrUfT7et8bItoN0MsLptsmP5exGbECvkFMBiJVOr22GuR3o+4D5chgAag4v2XELiVdRv7SeHvKw0jtZQtGbDklxQHX2bzT0rSO5baXJ/qIyoyxjFj4v8DQl3uiNbYgVRv1ofxt4HKAN03mu7hv3KkFmCXb6A0Ma+VjDfAuDmP9SGbDQFkLC5cvxiArFox/+2ovYlEXGkffJ+bAfgo9Ec8Ew72BVqVHxcs20hDToG6dTrkBwSwa8CX4Y4mdROH1bU9nkZcsjQUSRKyyhWn6UupY0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9544e8a1-0bd7-4f1d-3d37-08d825c5c48d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2020 18:11:00.5443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XKpXwxCgqubZztT5fQbmIexPHMfbqZFubjSLtvIvE2/Z1RQyXb7lLYL1BwkfhfUAo9HoeOQMhRhtWIA3iZ3OxjiKHR7r6WqQkFx3YbkUvug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6279
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/11/20 00:31, YueHaibing wrote:=0A=
> Remove duplicated include.=0A=
> =0A=
> Signed-off-by: YueHaibing<yuehaibing@huawei.com>=0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
