Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91202C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 06:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 560C92070A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 06:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhA0GD0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 01:03:26 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5326 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbhA0FeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 00:34:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611725641; x=1643261641;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=gBjx1fZMeoJrKyznXHEHVyfXgUGpGfLSOggIeY7uuOA=;
  b=Sq3hxF/238kwoWY5TnEDQUb2K7YG1DVg/c0ijOzybEv7rT2HnMCDgNpZ
   QlaKTNGCc/bAva7SZoRQzwYnywRGvpYiFC8/uLQAkVheVUJvoLEJazgqB
   hONRf/x4+XoPv4nJwrtrNY8GxK818wtXYej08Exm4jAs4Ni3M6B07O03a
   DvAylsI2+LcrSdhzQMwA6nSwtcEiwB9n1CqG8aK0NIo2ri0d6PCQb6Y9G
   Uyu/WkmHvOjFZnFN4Z7NbYf5rBmeMopRv4lw6d98KAnz3OAfulG2idFxs
   nqJ9OqKq7PFCIxxgYCsAYXp/Ki6t1nu2nvnPKyh3OYsORjPCWUjQkUEOY
   g==;
IronPort-SDR: xXDUZFNLfsETJsGVmBhgINWVzP5M6JFHbvKVJZMu010rk0wAhK4H+gPB5aLULspSFuLN4VRIcZ
 lBw9Cmg76uyB3wQYTqnpI57WWlmbMgi0a2xUKoDksEWmNeqoZ9axXGj0QEXwxqYDqr1c/qhWPH
 bhAAJAl9b1wFydnlEl6gqtAMX9VCg8LJKFUh3TTXMYpeSPPtzQCeluAQ0yvkiAr/H2Qo8oMw7U
 hb8c8bTfqjV6PC0QC+tBXumO6ZlMD8CG3Emzohx9oL5oFG6CrZ4GLHqNN3xW06+KAadP7PM7hn
 Xfs=
X-IronPort-AV: E=Sophos;i="5.79,378,1602518400"; 
   d="scan'208";a="158418770"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 13:32:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQGTUe6NHHs8bap/eVH1PDw+BW1yWnyWrHHVSthPvPQNVKLRW07LyjKaC1vjiVMf3tOgsJIQAo86bJ9i4OyIzjzRoXfSkWhCcIFrzDh07WiLx75P0L91UFwVZl3U0heXSfyrl+MRIUHqtg9icjsrKoDHUw6nJH1JOwdODL+xYqZVSh+mlBAYw6A5WYtPRG2lyTbV1FLOC6D/IaODCFsUWXQlQf5srQEprVcDq12jpM7+WPp+9NBlWhxSjg5L8IzvgSTdpvk9CoUpzzMj4XTQxXRe74KDW8qxiI1ahU5A0ENsVF18FmIdWzLJ73HpMeywE3m2E3YktmK/gb58j4Mr/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyaF5a0GuTv4dpjo19OqVD+QjdXDp8vi4EsWLr16aRg=;
 b=BgcyQ756JnttnJto9qsTohoyG1H4wjNBPMgRX0vTTwUa4Grp/y2IPDx7UTk7kIxhQPwkpRJl2kIxmcszR2Om/tlJ7amfijaVmXAZ99bUSzC9NFov6/wjCJQCkpj4D04kPwRQJN81klTV7lg3gGyRdakcr7+dFyeeo8vZr8Y6BT3BD9q0ghN+zda81os76IkXm+V7PBXPXkC53nqse2FiDxxOHGgDskIf1ketZfnI8dhT7iG54eBlJaN7Uf8Q4xsHFrkUps65aGMOnpJ3rdX5ATYuvN3snRRn7Z6Z2t3ONjI7EboVJBA3hvsIM3OUDgE3NC3mfmtZlSvkxMH/7fWc/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyaF5a0GuTv4dpjo19OqVD+QjdXDp8vi4EsWLr16aRg=;
 b=PuUBkQZFdjLMRsp1t+6kKcnfWnhwz2I9mhpO53IdV7DzfpnD2SmK7iKqr/icw3SaeGgp0KlH/kcLakT7G79yxz7BKFqPhcvhHoFyP3H0thg5UDsAIXaaCXnTn44PSqjP2nfEOEee6EnGoG6gSOAu338yxkBf3ooHJ5FHE5nATgU=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6927.namprd04.prod.outlook.com (2603:10b6:208:1e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 05:32:43 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017; Wed, 27 Jan 2021
 05:32:43 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: test message
Thread-Topic: test message
Thread-Index: AQHW9GpGO3iI5wMlykK4D5mgQ40tCA==
Date:   Wed, 27 Jan 2021 05:32:43 +0000
Message-ID: <BL0PR04MB65148E3719A20DC4E4918F40E7BB9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210127033444.GG7698@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6a88347c-9f3b-4917-4ef9-08d8c284f871
x-ms-traffictypediagnostic: MN2PR04MB6927:
x-microsoft-antispam-prvs: <MN2PR04MB6927A2442C323C3B2213288DE7BB9@MN2PR04MB6927.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: otnNEKWqZjtREn7myFji7dVSyhT2BdCQ/QDu+RAdbeBXnfrPEP0NP7yS1SaqAktLl5PwxtERdIHJfDbPaVu3KALMSzUk7wyGi4etq33IhERj0Fx565KlddDcSz4iJpqw218LQqYfrE8LVzUBDlZGIe6XxTGxwr6Q1VyIOzxSQKUWqHzkYagX8SUGQxu0RZBQLSc5lacZYoqxUOyuuG1Ayso6rjnCCRPCMEAKOrsXkO9YAA9rPLzYGEL+nhMr8CecNLopj71dg7I0Hki/SJbIx6V/y+bh0V6ApuPZhDb+uY29EBgggLuW7kk3TPG384dcuMsxDFc8cKiGqSZsoOHiaPzOEGbIVxGDp0N3ngzint+Q126p2ndcwdiLvs+V5ze3frqduU66XqeiYb4fE5W5C5SEfTvXpHwHSIocJ6O9n44dE5oBzDRvvXrMVviC1ZE7/fGkNM3/UiJaG6AbD0poaYQ2CBoXBeyhF8ITRBSOgvZPB42Ns/vi28SvW9xvguDL8gOn74/bVlQjq3nMPMpMFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(186003)(53546011)(71200400001)(33656002)(55016002)(5660300002)(3480700007)(91956017)(6506007)(316002)(8676002)(8936002)(52536014)(86362001)(76116006)(4744005)(66446008)(2906002)(7696005)(478600001)(7116003)(66946007)(66476007)(15650500001)(83380400001)(110136005)(64756008)(66556008)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4fByu/R0Xe0W+LGAroFH2zMRudcFbwttS8RrAsghLz6Uc6+GUsYU9Qrpauh2?=
 =?us-ascii?Q?l0TNvohnEZSnqbZzOfazCh4NI4t50SVd9q11JN4Fj+dp8ryZvjKy1zfmhJeB?=
 =?us-ascii?Q?Mju0/vePyhlZiwNWLEVZAIn3P7Z5YhmYxYltQ7HRpU7K8b5vWjQYe79Byp3c?=
 =?us-ascii?Q?kWro233XH5WyJQ2yXeKQJjVhBEU7dz3y/PfFIsdcvDccHY+uU+oKDd2Qpy5g?=
 =?us-ascii?Q?He0LJ3l7EBPuJX78pNtuj+MjhO9coI/CMT9sfLq+ybEcytxnShBybjRAU6hL?=
 =?us-ascii?Q?wCKMzOBbw6Ca6AHTDuSEjKAjCeUd/TOu3fFK6ziQo1ycdKEgiwh8e4FBlgb4?=
 =?us-ascii?Q?YR5trhLQFXKvbYy/f0YEbwbGrC4ohhNyPTq43NlK+dnZ96iF/CwhKAb59rah?=
 =?us-ascii?Q?QpXPSylL4o+H0B1RvVVdpIb+DQn9nHVQ3JGMu7ZBMrn1u1KpjpfWTzMn12Vb?=
 =?us-ascii?Q?M2xPq4n0EvYjFMMsgCAMmCVD93y/wv20Ss1pQnWGCKySUxfP2ze9Og4gVe5v?=
 =?us-ascii?Q?dPU8GVs9Fw5Y8ahSvubbrSpKvwZT64gnm9+mWMCDB8vPmDvopGNoJ+23L6tW?=
 =?us-ascii?Q?6p0bfbjgS+65Cvg3qDuXO0E4xkRPeIUPktIs9+PFzfNSUj+MR+3TDPc2YiiG?=
 =?us-ascii?Q?9wdJ8p1/O+mAb0wYPRtoXBNwBck9G3j41M0x//D0fbOncHzwlWfZ46vG+y5H?=
 =?us-ascii?Q?HsAyIOziH6EF09PgdHev45RWtFCH6Q3D8xjEoZwaObiDYJLPKb6KqcV7R3KF?=
 =?us-ascii?Q?p0txQUsdLuJD1OKgywdbzqRDxfI5+D9vncXLHxswBgUzuOHQlOmn+ANduEkS?=
 =?us-ascii?Q?OxD0Sh1zE+sUb+iSkdVKkTeWR5hEUkpXHmvr6PbWHHAxxuOmm6Wf+JimmQiV?=
 =?us-ascii?Q?bnkBZqSJgWrJEBdjQIYhLwSzZ2Aq5J/OvbofG8RcnyX0Ko6c/hzg0EFbyImF?=
 =?us-ascii?Q?ubaCH+grffo2zyWKQRlU+Rr2diRdgVzM8jZjwnXXHHvg5xeD003hXGOD3P7v?=
 =?us-ascii?Q?kSS/Whc+NFEGgwcN74REhmmJTyaGSl88cZncona6dRHVjAgp8eUtEt3l2nFL?=
 =?us-ascii?Q?T/rLMVtEJdQkamxTguCMlut3ZK0kPvDVBLUv5vmfO4WuZPDtKaZtOzxmZHLz?=
 =?us-ascii?Q?M8ZzvTrhUqQkAY8AlRHyULwU9N8Irl+RRQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a88347c-9f3b-4917-4ef9-08d8c284f871
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 05:32:43.2119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9I0wZD+vtadxHUUF/EOkwgZ8HdvGkKc/ip856efkSL/TN1J0IxEEmZ5xCO5TdVLZGgoY1WL48Bvr02EkzaI0HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6927
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2021/01/27 14:07, Darrick J. Wong wrote:=0A=
> Hm.  I'm missing a substantial amount of list traffic, and I can't tell=
=0A=
> if vger is still slow or if it's mail.kernel.org forwarding that's=0A=
> busted.=0A=
> =0A=
> Hmm, a message I just sent to my oracle address works fine, so I guess=0A=
> it's vger that's broken?  Maybe?  I guess we'll see when this shows=0A=
> up; the vger queue doesn't seem to have anything for xfs right now.=0A=
> =0A=
> <grumble>=0A=
=0A=
Yep, something is definitely slow. Naohiro's btrfs series yesterday had 5=
=0A=
patches missing that showed up only this morning at 4:30. And what I posted=
 so=0A=
far this morning took a while to hit the list.=0A=
=0A=
> =0A=
> --D=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
