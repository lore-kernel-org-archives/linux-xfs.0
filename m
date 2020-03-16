Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEA7C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 384A5205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:00:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=intel.onmicrosoft.com header.i=@intel.onmicrosoft.com header.b="Cp3uBggZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbgCPVAO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:00:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:36662 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732571AbgCPVAO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Mar 2020 17:00:14 -0400
IronPort-SDR: tD6hceAfx+pKsUrNCgzVoKFsM3sXkIzM4uEQgJcapu9MzSmU/ISzb/kw+uTH3v2JOkyl3H7KIb
 9L/3hRiplBLQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 14:00:12 -0700
IronPort-SDR: 4xAez5eO+wM/agbiWjiJKg2ltcEEBjT8iP/l5KoTRwQ8MeubqNvL60y1Xch/KljP+B8r/iwEpL
 e7ilZJCWhLkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,561,1574150400"; 
   d="scan'208";a="323620915"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga001.jf.intel.com with ESMTP; 16 Mar 2020 14:00:12 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Mar 2020 13:59:55 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Mar 2020 13:59:55 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.54) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 16 Mar 2020 13:59:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtWczzHnuNsglrNHAOlyfpbiOi1knjCmiVXKqDC9rx5K+Bw9xvADoHrFCDsPIJqSh6k3mc73drUSfGY0lneJVNvaGTDzWZ3FDBdOT+PseedaupzQaGXb27LjogNDkkfXb9l/GYM8FNRdgstpAFt7/Ta4N/+XJWNM8GwZb+2amg5P1lV5cTja3OVNPuQyXxs9oGGlwVylIDA4xsrsJ0cETRKzgKVJ809euIDRrml1ykYJe0HNxV1RAx9BqInS4v28y0jN88m3jalJ7sMvXcNPN6qRU1QWusTUJxw+1MJq7hcgemtxMccruyeUF0+mCgr+ziW9M89OtWscNb5G40ktvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4ZpXlztXT8qo1+/GMn0Xuq/f+piTP3ObPPSs1UgrQc=;
 b=c45zKYNIb7Zo6gGAhEnvlWap8nSpsOQIGE1Ao7nS18fOKYIH6hO5AyTxOADXvC7u/0pTio1yYLhY4g20BOPnJHd+0ccb+ceMyHA01cHcEcSPaf/LAIPclaLR4ZP7i7YBDIuHk9k5xx1SkdTL4mbTK8HGWNie1bLMBhkXerodKgonTxqCMwzJimcZaNVXG0DjWFeCcBvS6CbWnWPGmEP31k5Rt5Z7jzyX5cl5+uCbanfCswmDXAtEJwsOepVfzORch5t9IBr6E4wJdp5C/99L6OHi14qq1GK4u0vl6rBg5myV1PrULDaw/bYrYzt77t0cx7zcvJSP2yLKPV0o1zHQww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4ZpXlztXT8qo1+/GMn0Xuq/f+piTP3ObPPSs1UgrQc=;
 b=Cp3uBggZ1/wZD9MxY5SNvf8/JtKjY1GHAcL1Yp9/bUUmTgmN9I1ocOWX+3tB4zeOAn7fgw5RzAPaPkVpNtmUKNZCHnDRmFYVlliVJ1I6mnbiazV3PpIQAdYArpCFS9V4Gf/dmSqN2ltZdB122m+ximyKXsgHNTFeSQlf/iUVG1U=
Received: from MW3PR11MB4697.namprd11.prod.outlook.com (2603:10b6:303:2c::15)
 by MW3PR11MB4556.namprd11.prod.outlook.com (2603:10b6:303:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Mon, 16 Mar
 2020 20:59:54 +0000
Received: from MW3PR11MB4697.namprd11.prod.outlook.com
 ([fe80::d94:9a48:b973:5871]) by MW3PR11MB4697.namprd11.prod.outlook.com
 ([fe80::d94:9a48:b973:5871%6]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 20:59:54 +0000
From:   "Ober, Frank" <frank.ober@intel.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: write atomicity with xfs ... current status?
Thread-Topic: write atomicity with xfs ... current status?
Thread-Index: AdX71Vq//eR+Sn2pQqqqxpz9L7kkRA==
Date:   Mon, 16 Mar 2020 20:59:54 +0000
Message-ID: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=frank.ober@intel.com; 
x-originating-ip: [192.55.52.202]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a744d32-40e1-4ded-de52-08d7c9ecfa60
x-ms-traffictypediagnostic: MW3PR11MB4556:
x-microsoft-antispam-prvs: <MW3PR11MB45562983C0FA2A425110417D8BF90@MW3PR11MB4556.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(366004)(376002)(136003)(199004)(186003)(5660300002)(86362001)(52536014)(76116006)(316002)(66946007)(64756008)(66556008)(66446008)(66476007)(71200400001)(478600001)(966005)(33656002)(8676002)(81166006)(8936002)(81156014)(9686003)(55016002)(7696005)(6916009)(6506007)(2906002)(26005)(163963001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR11MB4556;H:MW3PR11MB4697.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G0xaSjRQyBJq30zGyI+wQpUCq8xuNcKbmv9KLDORW5EXKMWpyae8OGylqTXlXPVIz9CJs8uYerwBEw2dJP7U3GRATUdmsS6M/JmKgdYIzTumcl41ZllAtUjUnQpIaFu2q/V0o6Tb+IQmEC1yjS7roDHmeRGx3RSN83ZvetO8gBop7oVciiC1YYu8w+Jt49/0UaWXdu7Hpo6fVau3c6AgbCe5N5JQdM+4TAk6VS3NLNOD3YbiLYhW0lgDty5vMbjcGNj1tYzSN6puwC3hu44vTGbZC+OUsU06Tllog1RDjpLlLI2NeX1o1c3wfLora//O/3EWh8H3gSxfSld1nfw0GQzpxeM9lY2if9x7ks29W70oqEpX5mgUZhclNa9VwxZPhOYdA/g3Mm7xRB1W+6DqJO8QgbkY/r3gBabS1GSCaOr4Fj1Qgc/BHlys9ZiIwBV1W11qqjh5T//R9Iu1jnLPZTGoOd9b/i8+VolqKJ1w0/MYFkp1YEG/YJvFUwG5PynHaoX9DMvV0jjdHLulI2RFizaV/nj2wD1bj4S6S8uTbk/DQeg9EMdommFi+0vBtCzu
x-ms-exchange-antispam-messagedata: Mn2ZqwxAfAvSGU9UQdPWaKSkbpLZYH2hgu4KcuU18dDuchj9k8XHSe6rqpD4FK5XSM67lBfJOJJ1VP1H+7Fw6o/4Xl7yUOxp0HV4pd1S0YqEacjVqfnZDxCDMiSiv1iOr0btxf4gwhvynHejEFlLaA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a744d32-40e1-4ded-de52-08d7c9ecfa60
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2020 20:59:54.5644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WEvLyA6EEo7qRq8p1svIMsie5tv/foR/W6tJfZv/2XnhhPJul2Iwc1evCeWSbmq+1cwG79HuanaM84TW/U/8cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4556
X-OriginatorOrg: intel.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, Intel is looking into does it make sense to take an existing, popular f=
ilesystem and patch it for write atomicity at the sector count level. Meani=
ng we would protect a configured number of sectors using parameters that ea=
ch layer in the kernel would synchronize on. =A0We could use a parameter(s)=
 for this that comes from the NVMe specification such as awun or awunpf tha=
t set across the (affected) layers to a user space program such as innodb/M=
ySQL which would benefit as would other software. The MySQL target is a str=
ong use case, as its InnoDB has a double write buffer that could be removed=
 if write atomicity was protected at 16KiB for the file opens and with fsyn=
c().=20

My question is why hasn't xfs write atomicity advanced further, as it seems=
 in 3.x kernel time a few years ago this was tried but nothing committed. a=
s documented here:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 http://git.infradead.org/users/h=
ch/vfs.git/shortlog/refs/heads/O_ATOMIC

Is xfs write atomicity still being pursued , and with what design objective=
. There is a long thread here, https://lwn.net/Articles/789600/ on write at=
omicity, but with no progress, lots of ideas in there but not any progress,=
 but I am unclear.

Is my design idea above simply too simplistic, to try and protect a configu=
red block size (sector count) through the filesystem and block layers, and =
what really is not making it attainable?

Thanks for the feedback
Frank Ober
