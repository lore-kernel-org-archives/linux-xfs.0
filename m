Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48709C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D83DB64D9D
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhA1G5m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:57:42 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:36335 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhA1G5l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 01:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611817060; x=1643353060;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=jxw3XcqfHEsfnNHxpaGpfaz3/8OJJnMpObO7siL5sR0=;
  b=Mjf77OS5sqKmDv2pe9ZPlJVhUeORsSRuEfH/fQKAyEgWYo8Tn+5h6Mjt
   yktGOAgK09Z9pBhNeKu6X4CesZ5y57HQLngd68mBOry93ZUs4ylN/enGF
   aAevlf+kP1sAvzqauE2xrVrITvaGWc74Hy9hH88ekdNo7euPZZzbYusZP
   DNXRz3cJoBifMoZ5JJbMRKbGy0B5VB4nhAmGnjLJQcHLlAQCIsCoan/j2
   Aev7jmGrBCDo8b6wwWwpcQvbRepGKKyl8WvO0FvGrMEKovn8RG1taeq6u
   Yn/Qi9BlTDkMib2bITo6t0GLD1y3pBN/0k30AzG472iodgvMTDIquzc7u
   A==;
IronPort-SDR: VgU4vY35iJZI/xKxF/thEkLdxnej+9gXNh4QiJ+ohAtRc0kI2sMd5Dm/5yGsU0E+eeiIXvMza7
 Zqwa/a+Z9ywv7myudMjZ6adrnax2DEsvF4ryYxq7wYBv3rd/fgUxw9EkpjBsq2BFWX8fbZzd3W
 btBu+wI8bZfqo3fwpyRNtFVefo76Ke9qEfr7m77XC2H8SleSr4KKWdy6+3JuZuGIAV60KIAPQp
 HLcopj+OtZ1C+n64p6516K0PxCHIsDsAxFfSF4pvyliVdJpH5UqVvgHSvGKKNipUEOBVkdwHQq
 qeI=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="162961994"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 14:56:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6HFgvFiZQYPY/yagewtYx462iYp2l/z7nxZyzfaNusUv2AWFIPgHHGVkKwweocvisDkCJBkqg7QjXkATSVQxa/a9BB4sgIsotOvfCbj1933HmLMbByCF6XMQWW75W04xLBZiuEHsIo2isw5dOwS2oLLqR72/KoN972kVG5kIY0YQ6i46jTRU7upZU047Ay1sCI4S6IKvKfjylIhwIc+nkSZWPK3uGl633gvEl66UKk3ZioZocBsn80d9Jo/KmXSE6RaWn7jBAe7wbOo7Fxj5E2q/B5KI6lpumaO41Q5I5ufNdf1fLn73tZKws0Kran/vJvTG2WRNTskPVKnkO170g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxw3XcqfHEsfnNHxpaGpfaz3/8OJJnMpObO7siL5sR0=;
 b=RFzku4eU3NTE9CwR2obQ+O7y8XfdxY0VXO6XD/X0Uj2JA9WbsNUDrHCuOFfP31+61fKV11QImlWmsHwKomAAALulpuZ4GxBGc4wUnmiGOItg0cyQBj9IJns8br+A0KUZXoJ6Ytulpx1wn6a3XCfxzOcXDfV1OWw36NeHtIl5DrcE9Kawl50G3BFcCDNk5mYlrkAxhi8LLKkdwzjPSJjwq7Gu7/wYuGF+OXtsonH3iuGW/Qcztp+uuMxFlHuFM+EEwrUh383m1il7s1BJhirnUKpX94lIWo+bwpeL0Rxw0ia9bmYKGbEKOQ4FXMFIc8Dgi6sUlR6mjRaNL3/nb/Pvyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxw3XcqfHEsfnNHxpaGpfaz3/8OJJnMpObO7siL5sR0=;
 b=qzkIdN0KopYUPALMz0BXKNQyDwH/Yksih+mVxBlSp9qauPIe8L2eENAjtiEn0pT99Cn0acsukMylbfK+GunP5qZEuLWsT1mPeLqo8JEHJmlCxcsvdsp1sF6EZPWpCgMfub3YboJz/q2EL9jprklXDI+cJvuDXT+nbla7vgbvXvI=
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
 DM6PR04MB6730.namprd04.prod.outlook.com (2603:10b6:5:229::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Thu, 28 Jan 2021 06:56:34 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
 ([fe80::9a1:f2ba:2679:8188]) by DM6PR04MB4972.namprd04.prod.outlook.com
 ([fe80::9a1:f2ba:2679:8188%7]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 06:56:34 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "sandeen@sandeen.net" <sandeen@sandeen.net>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH V2] xfsprogs: xfs_fsr: Verify bulkstat version information
 in qsort's cmp()
Thread-Topic: [PATCH V2] xfsprogs: xfs_fsr: Verify bulkstat version
 information in qsort's cmp()
Thread-Index: AQHW9TW34VKBr0Zkpk6ClA1FXo0MlQ==
Date:   Thu, 28 Jan 2021 06:56:34 +0000
Message-ID: <DM6PR04MB4972E9523F3EE5F72CE397B786BA9@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210128052058.30328-1-chandanrlinux@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2600:8802:270c:4b00:19c6:a569:8749:44eb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3cff2c73-8726-4972-8762-08d8c359d98d
x-ms-traffictypediagnostic: DM6PR04MB6730:
x-microsoft-antispam-prvs: <DM6PR04MB6730D665505B6E79CEFB7CC686BA9@DM6PR04MB6730.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:60;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rcalHjos9mGM/fg82R9TPmVZHftfSSk0nuNNAcNs4TxKaJJitCj/RAnnzOROs44gcEXeDelZgl8EJWFg/417U7zNEFfzONmBmeB2j+f4bPMZDphzHFr25niSLU0Ei5cOLVBWJobhHAM+H//hUfXQt1FtMo5VPEUFPOkxq4oiIjx9od5YfPs0169SDtto5e1N/rFbneiD5WBRGINPzWKUTforfWSKWiRHZqfhLfh5jMrMz/dNF+KNwN2NYufCTEQoKTufT/yvH0qLHM30Llq1h11bsbkZt1+anRbRPDjvGlr1Zl9tv/Ew3YatJF8l4v26y7xuC8PGGCJPhRUtbz7dJjyPrJ8UjGw3EaNYL+phn7hIRGILRgElOORT39AjauxME9xNofx4mySNCR65HoEyKLlfHLCxvyXdtW/2oS6FrsppXqfEIL86d/TwiSoXrfZjH7gViyghYYuphA9K1MNpmYNIpEbJvEKHMJws1JWZd4GEaJKCfXmfEFm+3vQMz75ebwUdrcmsfxd3sIhBgkVssA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4972.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(316002)(110136005)(52536014)(54906003)(8936002)(186003)(8676002)(86362001)(55016002)(478600001)(66946007)(7696005)(33656002)(9686003)(5660300002)(66446008)(2906002)(64756008)(53546011)(91956017)(66476007)(76116006)(83380400001)(558084003)(4326008)(66556008)(15650500001)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?AA4n+VQxi/T0bMBpM8sS9c6dV1X0wzxMtVAc9seFFbEQ5SmIAkZN5s9Mzpbd?=
 =?us-ascii?Q?PK0+/bHyE1zIXaeq2Y9E4nHv2gnn25qmCFCRauQQwRe4z/BIWbThEzooqXdq?=
 =?us-ascii?Q?dLrNrOSjw6kHMU0lsn/IRkslUtDTLqw0T+gTLjWjRwIaz9fRxgwQNtlEDQPp?=
 =?us-ascii?Q?11wQTA9qIbcOM/YWrexr7gsXVOgH7pDb7KE6kB7isQMqOBo2jV5a/SZwqWsu?=
 =?us-ascii?Q?VlXEfpyYIOPQk8e+4tfQ9BjewfgS4dbh1ojBfEMFzdwebOIfTJXgZTVlfO4y?=
 =?us-ascii?Q?a7JSdeVmv+j0tVgP7pzH0JkoJDA2gvfVokFRjf8y7J955sel/rb9MZh2CFEl?=
 =?us-ascii?Q?6FBPUbymLEDYpVLVZwJC+F6n34BzdINzFcTLuo2fe+xLYqyulYyZjXGyr1Gi?=
 =?us-ascii?Q?PUDTkQgZCdI9dH++faRDCdOmmyP46muqXaq6zptgfjmOyfcXBiLenKlI1eW5?=
 =?us-ascii?Q?vq0H3sV9kVrr5bxfc8ZaVuYgFt8Pf16ewwsiAd7q9CfuNUG+eQwA+nspqlMu?=
 =?us-ascii?Q?ZWTkuq8fkT6xnDytLQdI9j9cqUrqhYSDQhTp5KLQ4SS0lMosBcl0emv5ZmtM?=
 =?us-ascii?Q?QSNHA9IEK1tmJsSdxZR85crklINvY+H1x/zJhlW+Nrkf6kNwUahzYkT4eJiZ?=
 =?us-ascii?Q?DKFR4bfqxYl64HjcEgP2tSjUXGYiSID0TBItxYqvhjIn8dhybuihvxRiisE5?=
 =?us-ascii?Q?i3A7xLxkh+imno1Lbvgl/OYIwZo50EBqXPXjQSPLfN5h2DcEixgQkmjOlVGC?=
 =?us-ascii?Q?svSopqkF3Hw/zTNUb8WsAInNXXAQAIEoDTwiZp+nyCazBy9f/rB6DkAjokiL?=
 =?us-ascii?Q?dKPe9qCbn4UaXESr6IcQBArClsGiv7DnCMwwxxK+daMrUddinzx8hog76yMy?=
 =?us-ascii?Q?qY4t+J9wRlK4uNe5kZW2ZeAVDARtsM1ilMAa9ejy6u7UVltGTb45J92IPnkF?=
 =?us-ascii?Q?OYN6FGM0rLsRb6TUnD29N3ZN+nvJDREMMq8GoEh+tqVUoXqcjw3rdFcTkyfu?=
 =?us-ascii?Q?NIuN9C7dzEC//VFbLaaXweCXq0vliPkxPYdgD5whlJbnufFXUdhBbJ+3mJXI?=
 =?us-ascii?Q?q3v5PIepXZKrvwU2oDwTSVpb8zxx4aF2TRnWZJiVe0mCPoe9oQI/OAh+VC6T?=
 =?us-ascii?Q?kxm3bGhbU4Y51DfOTF1FqNF+nHEC6bwoRg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cff2c73-8726-4972-8762-08d8c359d98d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 06:56:34.1538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kwfOLxYXxbcbpPXGVw46mvLeTUcO18WCTsNwa7rWM9wWsGHc1dMbvNVHrij+dADdoEEZl1bVnckNrUW1sFKPm9OFJRTcuGTEOm1KZgWupPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6730
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/27/21 9:23 PM, Chandan Babu R wrote:=0A=
> This commit introduces a check to verify that correct bulkstat structures=
 are=0A=
> being processed by qsort's cmp() function.=0A=
>=0A=
> Suggested-by: Darrick J. Wong <djwong@kernel.org>=0A=
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
