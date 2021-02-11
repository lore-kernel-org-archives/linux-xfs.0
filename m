Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BDAC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0676164E00
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBKXJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:09:59 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:21091 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhBKXJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 18:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613086155; x=1644622155;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=VU4Kx0Uc5w46TEgx7vLEkIM6lDApVAZ9riNIFmY1Yeg=;
  b=I+fA5Q6PbhhyPRisX6XLYBo3bGA7Xz0/nhSMLS44TUTcSTBbOQmkVxwo
   DhJ0BPnYN5WETAelq60R2GsSptxvUCB2TyuVx5rgpyd3UOHIjbXE0ptOj
   5qvW8oZJ58MdhIAy4lbtyRapl7NkEw+70VQTdwq2/ZWW3fMBMl7EtzuBL
   0mudzSYqGzouLQ4GC1f7nmU/fqCvQNxniXv4ZF73UzzWleGY4FUL/t1NN
   VWqSe4LwChGRiK/dtpQoY4ZUhU8lb0mm9vFPkhv3RNfnzW0HgpRj2PSf/
   rMYAc3J8Srp3jZ79EJA368ODqT7x10z0d1h4Cbmf/MLp+ELD6u1q0ZzRK
   w==;
IronPort-SDR: 1pptPtPVr0Fdih4R5nwpBHaP+OwF5aWQjiFUrrBHA551xaWW7uJ5wrNnPE97ArH7X3j/G21yOr
 nxW5yyjl16YSQ1wSBPewC9z74aQFv/rvSfDoRMhaxFnO05FHZD2jGk+JNFTAD6n5g2vyH8fJYi
 cmiZ2Fm+EzBV09fGw/u3b4wQyoHZvfGtW1Aeluv7HSqPdQbh/GKKbIQaEVhtwhhdhBMmtslKt1
 xM8rHb/cMFSkP6q3Z+QguptE4SAldb7iOoRh1RdCOMDx9ThWqZQRWK37cBikPDZcOFvez8rv+P
 LDA=
X-IronPort-AV: E=Sophos;i="5.81,172,1610380800"; 
   d="scan'208";a="263926265"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 12 Feb 2021 07:27:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQ75At/TOHK8WYmXqgGk4yPchD8hubeqsKV7HA8vabn0w3ws6bgO/IdcxgFmq1le4GMyd+f6n99s/FhtbQ73+QL22VLfIoS0PezYQXbidPree7WyNKQSGV3OBCgNf/04gQuu5X6SrR0jzgsM/9OQRfoHfLWUvyoJpVnHP/NrkeXwnZT9rUnRea055/OYxc1HEP48YRlHYOhTTYiFSK5yA5fQ6vS1OlTlhIPuOjZ62FMQe1kHrCABhLsSP5BkEjv8J/FqiI2TaN83m0c6OUs40MCRQppFKSFXKQenFZxO4DrYDe9kzNyYfrTgGmMZF/NrBQCbVXTaXsnvTaizOkPlLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VU4Kx0Uc5w46TEgx7vLEkIM6lDApVAZ9riNIFmY1Yeg=;
 b=aUdZJtQplMK80VP/dlLBjqfIii/wRp8wnUjFTvq3sBXB09lXmhypNNO41iWq52rsvtNUX0jGHVPl6u2SUSajApphN5uF/CcIrY9q8D0fBBTVxiRfaO0YUg5QediYjIsbTfEP2UHuPlSmgfAi901bysHtPUQlBQB65x1QK905N1zTyeTDmjEK+RFP/saOptQmXAcIEDwUEaks+Tw1DqJcGp125Xteo7jin8GMMJwJuWOP6V6jf6bv6u/x08LZJs4eUr6HapgpPx5XiEUbSq77BEch4c7btxzGTVPqw5lNVaqDxfl6YBTWPPF01iP/8NxqyTv8jmqsrx0uNtW2YOdPLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VU4Kx0Uc5w46TEgx7vLEkIM6lDApVAZ9riNIFmY1Yeg=;
 b=Tzp0ND1LPRQi6bBz6BeI26bmzZ7Y0XoGOcrON6Ts/6avrFaF0QQK0w6iOmHupwpajNDr2jBH3M9eoCng7fKYYFM913VrILDkKVjjghIIcL/rOfFm5XZLtcj8Tn3LUldZB4roLZtRmW40NdAZyj/VVa+0wJafsbupGxTcteVumyo=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6424.namprd04.prod.outlook.com (2603:10b6:a03:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 11 Feb
 2021 23:08:51 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Thu, 11 Feb 2021
 23:08:51 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "sandeen@sandeen.net" <sandeen@sandeen.net>
CC:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 02/11] xfs_admin: support filesystems with realtime
 devices
Thread-Topic: [PATCH 02/11] xfs_admin: support filesystems with realtime
 devices
Thread-Index: AQHXAMm56beBgR0dQk6wz5UeLmeCrw==
Date:   Thu, 11 Feb 2021 23:08:51 +0000
Message-ID: <BYAPR04MB496529AB4DA86203C7D1CC02868C9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
 <161308435277.3850286.13874179572153084568.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3ebe3641-a096-4156-6b06-08d8cee1fee9
x-ms-traffictypediagnostic: BY5PR04MB6424:
x-microsoft-antispam-prvs: <BY5PR04MB6424F46D8579166AE3EFE936868C9@BY5PR04MB6424.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zcVWb6VKNvOKcPHIOeIZBZDanJJWIKALsUUISMlmMTRBS6kX7wwUEvlEMAG6leG+ZmQTwW5SnXYPFpY8DxvNTfpk9hxMezQcMAUXGOBYTZZCMVtWnABZ1Wlybn/97aGIu2AfB5HBEdE9r9JuJCZnZAjOFuWMLrr85BbRpclWdoZW1fN2b+N5WXLvQsQKmVt8cxgK37+XnVUUmNqaIp3ReOidwb3t1nvEGhxKR9CEknTH7Q0FjaiWFDidZWhkqo46pU98w9+urrG+/ZDdjmzyL9jqAz+VJmPAqSHD4AXiOfE0T2qLCaAse+gCwL42EuFJcHN8MjeV3XL0FrsoIrmHKZHVKdI4HyGMtI4VRYa59nURR3fjdyCrunKe46AdMrLZjSAGTybhnRtvYz05MvJnpiSkzdf2+EsdONcrpxgE5ZUN2xaQ4HkUtkSnUPjlQNEt1kvoYdYQsbYHCVIf+C/bm3VqywtLG0WPMRM9t0ybr6KB3d6eKPoAXyXf1KjxNvakDfAohzPw11nihGTDmac49g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(5660300002)(7696005)(478600001)(4326008)(86362001)(316002)(54906003)(66556008)(33656002)(66446008)(6506007)(76116006)(71200400001)(64756008)(66476007)(186003)(26005)(9686003)(8676002)(52536014)(66946007)(4744005)(2906002)(110136005)(53546011)(83380400001)(55016002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lxe0kSnAZyQ4V+/QNDDOq2Tulo4NKn0SkPfCbUV9VR8610hUgctvtlLUobdH?=
 =?us-ascii?Q?LafJrCgo38K89TrHT4TZzBBpXPT73T+reimlkUfyAFOea7cohDtEYHcHwnnm?=
 =?us-ascii?Q?BeXeRETH1pxgIqtxvRZ15yz2Wvfs5S5+sXE2+OJhZDL/A95cWJH+9+u0OuWS?=
 =?us-ascii?Q?S7o30NvApa6nz3/+7W32uJvJeYblfv0fz7c1Bi3ZStLloysIh+BT96ssYDFa?=
 =?us-ascii?Q?OPOXMF+Myl8ehSvQ8zqWTmRshnEbq3+rzi/E0v7R7JvYJLmoNBMJhd7yDs44?=
 =?us-ascii?Q?ijUsgYio7UaMLJagm8fxZ9yR+/l1JVvrd6TJdPuSwC/+FadQeaKldoKhYHU8?=
 =?us-ascii?Q?a+ZUUh/P91ciEMCg2IMgYi2JHd7qx8JOOxZ9uSEPCCa5WXf2SF/LUbvs42ir?=
 =?us-ascii?Q?aM1NU0aQOwzNkdyUZcPvp/4M71gpXn0jpaFTloezRkJRn8OSIomx4YI0Hypd?=
 =?us-ascii?Q?+6MRAb1WoNWioj1NZWyJQoof4GVlcGZvpt/RMePQTJigsadIkFl6d8f4Ps9y?=
 =?us-ascii?Q?wzNKR0xIaK67SkPQMJrGayIJkJCr+k/gdjODmv9D5BrAMG3xaf5/JfdxTuTC?=
 =?us-ascii?Q?B3teTAo9hES4qcVQUTkBHJlrTvYeFL6QwMFB1tY55WU7mmgzDW9wnWsvpDCk?=
 =?us-ascii?Q?8q60w3jXvAfY037uX00oKchU6QNhVK2+XbEHPwaO0zlQlVty014YD5Hpn5ik?=
 =?us-ascii?Q?kgXpvEGsyoXTgdvMqb4WSmZJXqM8Z54zSjHyi68yxyFpac3qrWUJOWXYmNal?=
 =?us-ascii?Q?EcY8B0vbrWNbbQqmAuKV/DjGn0RmbSvjTyVFmaoVcqvm68U4KQoyc4XrU21o?=
 =?us-ascii?Q?Uq4UITU9QpckLymVEbuM9x0aN9GZFflRlnt7oshFeZ4yQqRddAcPrGw8MDfP?=
 =?us-ascii?Q?HT9g/0B2SPcU3gBEnqMLgyJ/hSopmqC7OzMAzJa2LQH4BJv72fv/XVJ6zbBs?=
 =?us-ascii?Q?kjnprphmrGi/5GBguyR5sFqExBP3uKonPcw1qjsnXTUXYS0abY51EUaXvpXA?=
 =?us-ascii?Q?HXKbSnVCn43+VCUJ7PaOR0SMBUpXbwr2SkCvQdfuXScYsQd0U3hDJr8mzNTv?=
 =?us-ascii?Q?B5o3Kg1sxMeCHbiu3hyszmrOkYdilrBzh2UbvBc50dzt2AGJpv5xNrL+DTeF?=
 =?us-ascii?Q?uoGEB5/NDZX/8JiV6419CvSzCToIERkj4n+ZfmPzzCUpgMdxTZso64Vg8sbU?=
 =?us-ascii?Q?mxuB360yzF5b7eE/i66aFyKHAW11zh4c3ZhLQLRe3l7PRsWVArEjcf4Nnf80?=
 =?us-ascii?Q?kSz3I7gUbouIPlhNhxHX5cRmOOqzZDkDj++6MuZWm4dAILktKLWwxgQ3JrVd?=
 =?us-ascii?Q?XG6rQSDneJpeqKROz/PEW95E?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ebe3641-a096-4156-6b06-08d8cee1fee9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 23:08:51.1749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q+Ex8mmCSyAtTeT/wTA4EKn5p8ZnXOHH/f7yLejkC5hTADfmrG9hUbO+GJsktrP4RhMLqYI4KkoicI+bbxVX+nnKV3+C8RAkyC7nhlQpL1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6424
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/11/21 15:00, Darrick J. Wong wrote:=0A=
> From: Darrick J. Wong <djwong@kernel.org>=0A=
>=0A=
> Add a -r option to xfs_admin so that we can pass the name of the=0A=
> realtime device to xfs_repair.=0A=
>=0A=
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>=0A=
> Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
> Reviewed-by: Brian Foster <bfoster@redhat.com>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
