Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3086C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 02:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7781214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 02:11:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lBbbQt4j";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="eafodGQs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgBECL0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 21:11:26 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:57698 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbgBECL0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 21:11:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580868687; x=1612404687;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=VBmthnXH8h8eNvLd1ofOBZi3kHi2GmKlemH7O9rvl1A=;
  b=lBbbQt4jvfly33CuoSz19fn5IfauHc1/I/XQQhjf8IOqqnLPjRmiBiKV
   0f7cqeaojExg7oLTE4Xhs+sJdZBCKeE+rWYxu0P/nfqsaJEQ3QPqCh3yu
   JAKtLd8dRuRsLRCJhu7uKQFhYExAYv2/S55NSjNJUFB5aVgt9ufXZyhC0
   SvAcrq6II19WbkpLsga3dU386/ZKdOaMIkTVJ+EyzAZQ6rjYhtXYmuvqx
   hppRrgLA2o6jBJh/QIvCYDky92Whbb+YPcIOx6d6Xpkiz/BxXt2txZ6P7
   UTfZlMdF0k/qyrHQ73exKdh/29qFeHZDf3jYnAIapeOLNAioR6Z/E90x7
   w==;
IronPort-SDR: rHalgtPGisPho/XVpmL7EhAt3HnFmzZq1QcdRkV0QSInOTooip6UP/4vjYQ10LzPa+qJN5Zf43
 ourdSnwklC77by7rtwgN1w7Ie9Ox/haEwDkeU3fFPQGux9woInMi7tSft7RyuPecw0OCcmAKmC
 dtZ/GxhAdphuAImtfzPOWqkCcmuVhNgGY7ewUdxUfifvzw/y/5BUwTEmgQbP66FE/GqenRN++X
 kZFTopuPLsxTVLHg9U6OcyiszpXkLyQ02yDTsCIKW6MGh8F1O8Iv0tg/OvQCJK8fYNUKX2f8qE
 JfY=
X-IronPort-AV: E=Sophos;i="5.70,404,1574092800"; 
   d="scan'208";a="133468286"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2020 10:11:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3atqxyx/38HXf9iklD0ogS6ODD5gCJmoiPNZAz9aJ1MYbdCUPzpCpl6vTWWZN5cOiG5axMmbq058VF8cPNWyN+OJT6/+wG3XbRpPwIzYafn1GFcO8s3NgpuhxoX6gV9T6dVMXKxo+tymCRQSk6n4wY609NZ2Sr/H/Pa2W64SmGt+oTpNJgzQjI8cJBxhsPwzIXYwHMhUeIPhdNPTYn2n9z05lGppcgji9m0212xPFFAl+xo0yjFG7uc9xe4ym5sI7rMA0uYpidix08mdmAC/T9lDZFgc0Qbd32wjIDhcmKjs9+e245vo/DXSYyyNlPXOGTw/6rXGLfiMMh0WY7xTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBmthnXH8h8eNvLd1ofOBZi3kHi2GmKlemH7O9rvl1A=;
 b=BzNLnuwacP16llusEKapgomQm/ibivjFPQ1eaBBI+J4Mrmsehoqb5+c/iiHxD4LykLtGClaLKcgQ61cAzmgkzxgfNAzDaxDQC3iYHMCi2u0vr2rIC9medCndJL7bLQuG1d/kxZ9huS3Fdc8/kl5GA5n6M0cRrKlQl6YrHPFaZmigUXsn+6Z+/t3Mo2MYzD7xYP/59t2GsL1M1pm/DlUCuAznQLDreNEBu5NHC3z3LG9VoGu4hk67W48WOR2ov3fqIntbPd6w3ZVywrLZ6qOHPYFXBnjFPHET2GCXOkHLpUTpgyoVaKdEFk4s8ih6UYihsFsTtGkyaonRqr/QrNr2Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBmthnXH8h8eNvLd1ofOBZi3kHi2GmKlemH7O9rvl1A=;
 b=eafodGQsq+lL92snH88Lv8dsOw2MlOWLQ5QpqdzXvIYO+WKkln8WiONuHqd9OypWBYI+xV+0FRYfEQhE0l2ykuIE8Q6EGB9lxNcBRbg0/k7nKTJbv87MDtlMBZRUFboWUs23a7QEKlM8AqBmp/xHHbk5cVqh90woAz+QsGuw6T4=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB4551.namprd04.prod.outlook.com (52.135.240.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 5 Feb 2020 02:11:23 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f%5]) with mapi id 15.20.2707.020; Wed, 5 Feb 2020
 02:11:23 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        "sandeen@sandeen.net" <sandeen@sandeen.net>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] libxfs: re-sort libxfs_api_defs.h defines
Thread-Topic: [PATCH 1/4] libxfs: re-sort libxfs_api_defs.h defines
Thread-Index: AQHV2728FVWhEOfUnUa6kGGuhN5WNA==
Date:   Wed, 5 Feb 2020 02:11:23 +0000
Message-ID: <BYAPR04MB5749277488F85356CB9F99E386020@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086357391.2079557.7271114884346251108.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2b86a013-4e9d-46bb-8f12-08d7a9e0b30d
x-ms-traffictypediagnostic: BYAPR04MB4551:
x-microsoft-antispam-prvs: <BYAPR04MB4551197165D99B3DCDEBAEC186020@BYAPR04MB4551.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(396003)(39860400002)(366004)(376002)(189003)(199004)(110136005)(478600001)(316002)(26005)(6506007)(53546011)(186003)(7696005)(5660300002)(2906002)(52536014)(66476007)(66556008)(66446008)(64756008)(33656002)(76116006)(71200400001)(66946007)(8676002)(4326008)(9686003)(55016002)(86362001)(558084003)(8936002)(81156014)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4551;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zUkJ9cOeD5064GPW3VkRE4t9gdmd3sRiJdt2FAafNq85sA/X8PIh5+8lWQPl81bfKYmd0pBxf+EHOqCovzKXfeFR0qWvEHYwLIMYIvvIMjj7JSv6tT7l5aaqmQ1lBgzNOrFHA4YjOhkgE3sNvjdqS4Wx+bB66AECBVWFaw8exuszuOFwukkG+E6HnJV2Nu3f2WsO/rkDkbqLl7tU+q8HToIek/3D6W13Snj+jmv0nelrC8+YJs3A/ILCuUb7Ey0GmXBjVaa6YLBHVrYxih31hR/yCCSol3LX3xaTZbL8IPIh5osseewc7nm/sd3A5c8G7tTiMOT5L9MZrhH0dwih0qaVr7jitDOQ/HqeWRIs84ipL85bW+6GRTxAt2TTcOWRw//xEcFkUE7VrEpJ7lZdEjoESs3B6afjLg+XrPB8BNcirtilf2WS0F656zh2RYkr
x-ms-exchange-antispam-messagedata: BeesGXzYRh39KlUQk0ihzMVf1cFEYnMd2xn+bk4Y1yjn1ZwzwguVRA8l85Ue7jmRsCRAZrglwgCEx+FQyBF9SV7pc2ClEfDAZtihilz6KReP5YWstV849mnER//tV/5aRvipBSc9Zn839cLeTw6U6w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b86a013-4e9d-46bb-8f12-08d7a9e0b30d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 02:11:23.6174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qgJkWYr0Da/tyIXVZ9gerH6LdC1wdsM7D4nkB7o/rx1wQXBYQ7ec1H0Mbkx4Zl6HbGbkJ5gP0Jbu1IXvG2XNDCcMUeKLgE1zgI7fkXxu4sU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4551
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
On 02/04/2020 04:46 PM, Darrick J. Wong wrote:=0A=
> From: Darrick J. Wong<darrick.wong@oracle.com>=0A=
>=0A=
> Re-fix the sorting in this file.=0A=
>=0A=
> Signed-off-by: Darrick J. Wong<darrick.wong@oracle.com>=0A=
=0A=
