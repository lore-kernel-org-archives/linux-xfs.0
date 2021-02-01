Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4A4C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B105A64E13
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhBACZt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:25:49 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51595 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhBACZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jan 2021 21:25:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612146344; x=1643682344;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=hapkR6wWeZvbJBhHfcVpMv8r2Wt3W2e/uulCIxoPqRY=;
  b=qM1S2dPQDAFYC1t/gOd28stJgG6DjqSlX7k+XbW/hRVcnyNl7Wk8cOeQ
   mICZC6Lrbc0kphRpw3xwxs52SIgCadGpQe2+Iy/kP6wpjw3W+L9z77Uif
   eLlS4X6n/hgTtEVpmp1jF1aA/84b+OkOa+O68GG2Y1CLm6CkjSySWuAqm
   FRzX6caStXcEB5Fh+4ZnV/BHE0T/R0sg09xnQxcSjo3L0PPClYYUal+e/
   Y4pIFsb8Rg30FPwEEVQa8tH5L1QfjZtdJl8efTroaccGDgPX7FbCYc6EI
   2m4U2EDKRe3f85u6N36Wf7lBjsPa4pJ8JFJ/0f7xUkQB+L7uw3PDtgDjt
   A==;
IronPort-SDR: BP3PgwKif1ao3czZZfEos/5ieLQRgnWZXEpyKu3SYZviREujPcWLEPTzp6nAguerU8l76+mCER
 Ew9zWfx2Kj67X9mZqE/6+xGoVeihiWF0CYtRYV2XEyuIOjTgvq8IE0/LAGRbWPQFTzQDPdIaL8
 K+sdNe/TWm0AcCBN39akJQVQcoB/3JBWTYe0dXfb9DRloBqSbLRT/ylI3AZq+KVkiwe7PFvret
 nuBJYJuQZ0w/9sq2C3YdE+hcTGI90YlBj7mkMJBJlTvsluVsTYtBltsOlAtNbDoR+gtxW1EBto
 2Mo=
X-IronPort-AV: E=Sophos;i="5.79,391,1602518400"; 
   d="scan'208";a="159955977"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2021 10:24:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+AhR7HozEEQTABRI0efKCEGSfEjgYZ/IMyHmIuedDQtMMNV/OCgjyVrafgkmPSLE0UqUvLYjNCSNCmLEReu5V8KsUX/e/urMZK8bxw+0W235/dZraUBODOxAQYda6gd9LCbXqAX0kbPImaek/27xZh9SyOVMBlyeJwoCdNS6QV978Odg6qRBa8Le7XuPf8n1DwM2YQGHyY4PhPbNxyWEbubOIQFwIaOXEG053gh4yzfOGHuQEsm6C01IWYFSCPxAlSYu84JjZEuoYLMlJVSDIorsQGvC83IijDIwmYANawhLGtcxJIJHdxFbBQj44r6vPIAWBrrLpRUcwTMMMLZVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hapkR6wWeZvbJBhHfcVpMv8r2Wt3W2e/uulCIxoPqRY=;
 b=CypskR6ycR4iP3lCNpz4Z8wJh2TvLnkKuLFRiDZcQx890gk68Awjq8nP9I2+QyXhluleXjsU9PNDAEhTTp+8/lN6OJMgtNtNxSRuTqZaHQdPWsZoYCzKtsOTcacnv0QYIdNuU18CUPnDKi7dVq8Epx4rpXQOzKC3uR6Bq3ZUrreeN/YHvHfupne7uUp+U0mf1Y9AdG3CEGqtFjatra/KQ1VEy9qj/ySpjcy5/NokJi/3wB3HdNAtHntPsvUulvofLPgyUxBDl+01Na3KT+GTqefKsZIs4GmjJXu5ZjnluOk0DYQPv26Qe4dU3/F0/uCVXNlszHg24enubOCdXA1RQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hapkR6wWeZvbJBhHfcVpMv8r2Wt3W2e/uulCIxoPqRY=;
 b=jBJfZqN04vXXYNQAzhxd2jszlpSf/iKS3g7kDhZtrrbXJ3/NgcK4A36Or0i6rp9Kb47O/9NDe7hob4pJStJJe8u5wsxg2F+WtVwwYmamc3Pck71kxBCVx4qSji/8sfPbv1KQeMmizary/zW6YTz5nmuEXJKYKCbmY0p78QG1XHY=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB3958.namprd04.prod.outlook.com (2603:10b6:a02:ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 02:24:33 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3805.024; Mon, 1 Feb 2021
 02:24:33 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "bfoster@redhat.com" <bfoster@redhat.com>
Subject: Re: [PATCH 15/17] xfs: rename code to error in xfs_ioctl_setattr
Thread-Topic: [PATCH 15/17] xfs: rename code to error in xfs_ioctl_setattr
Thread-Index: AQHW+D7JJqmLr+M//Uqy/tqeeuqJ0g==
Date:   Mon, 1 Feb 2021 02:24:33 +0000
Message-ID: <BYAPR04MB4965BA6BEC476B183869E86886B69@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214511286.139387.10118392312750611346.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3cbf58f6-0bf1-4119-c7a6-08d8c6588364
x-ms-traffictypediagnostic: BYAPR04MB3958:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <BYAPR04MB3958F3CA8690AD351A9B841E86B69@BYAPR04MB3958.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QPnJf1evEa3pWFvNf0VytnIXIjzC6iJng3SKInODanq8Qi8AYInLwa6GV/kRL6m9HIz9HRPTVEypum8GgrZ2dcvK96rNkFs93kdPCOBiPbf8upRAux8Vp9qT9YJqSuaSgRPgSBj/uQTy8zo1Lfow96y/1FCq54O8ti2UN84fe7C5Hz0rE5gc48GltXOb13h04IuorNaUk/PsMQbivlYu7A+SRjeOgpxlW1rXIJ3CI2rXl8Q66wvEmORPe4+qOMbtnhq9P6xPUKDHkuhFHwP12X2K7oUS3fNUEpkKcBO4P4yOXhq1tYIe3rxIyNFuLW0QlmjHj/gmEFecgFtUyuPN4gRWYALDQ4rHuJaceWJWmQMU6gtb5zomKtT7TkDLanpO8ECBs+FOAAWrP60oI9Scq6tzs4fMcnqVlmT1v77E8CLfydD2M0ciDr5vwzBD9u6QLJmGYkbjHN3bl/s0u+ieE1j2+dL7AB/Z6pkqvpM9C1e2SCQJf3ri6TqcNS3K5Gh81Yh53F05qffElgPbeLqbjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(316002)(71200400001)(55016002)(9686003)(54906003)(33656002)(7696005)(5660300002)(6506007)(8936002)(26005)(8676002)(478600001)(6916009)(86362001)(2906002)(4326008)(558084003)(186003)(52536014)(53546011)(64756008)(66476007)(76116006)(66446008)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?x6rWSwSQop5fOEKMHF45d9GmMBoE7pxeaUbc3vNIGsABR3j0C/7XrLlv/2+b?=
 =?us-ascii?Q?iAuthsVsE5h9Wwk756zcgqTpiETFwVk8ChDHtLB2UBrQsa0NDCh/jRcBVY2f?=
 =?us-ascii?Q?3YHKlxl/AUoeaxpmrMoeuz3ClAeIn2or4MS+v8f5K4tGCNB5mbxtebDPIZsn?=
 =?us-ascii?Q?9NhuTbWD6Je3/tHQXYwE1In8+c3jklX4I50iRhXcRjaFtZiIhLGn9hwilgGT?=
 =?us-ascii?Q?g5GO4eyk/5cAiE6qDGqeEpUdgqGfonYWaSSpVMf8BS8e5YOBcPjImr7VpxOZ?=
 =?us-ascii?Q?WK3NWoHjAgar9z9dD9PP9fznuQGDYcflMdm0EHr5KQcpKGUiujuRMkB/DlgF?=
 =?us-ascii?Q?s2yzyZw0DUxdCjDLf+ehhmDXb6YY3gGM4RWYGlxhE1wHkFPJux5+Ef2c7fzD?=
 =?us-ascii?Q?B8exNXCIMb674FuW3udhQTuzWoZx0jIjeCVjYJZGbExUpbP0WalNzP/CHUqo?=
 =?us-ascii?Q?gofjnttDRovNBYncZvGpilQjQLypyqyF8N22G3iyMNXpcrjdd31vRv9Gorod?=
 =?us-ascii?Q?dMYI8QlDVhUdO9353DiVGxER+cHTnyx5RNCeG3cr00KQb2MLoyGdxkX92dj/?=
 =?us-ascii?Q?QR60uZA/AikBHxhlV68ipchsNcSkZ7PCVWOvlK/CtblreehUQsNkRi+/jb08?=
 =?us-ascii?Q?kV2bBtiVBlh6WSMITo4xkVSlZLSVweOSZxteRZbVdinuXk5Zg6zr78hB3RUO?=
 =?us-ascii?Q?PUTseDAPWleQIdNAAJqdo6oozGd8jLXe/ZczZtbUA/R1SOq7oPaJ0Px/KW0S?=
 =?us-ascii?Q?hjwI4+4nmqRY2t0CQRb5+z4VEuJsLDy8SCC16tcELLZdkzND/CNalanhZo9z?=
 =?us-ascii?Q?PWsxtcr49rkzvx+oiF6XLK0oFxoS+wQpn9Giu2PlbDK8vR2AKZU+pLKNllEq?=
 =?us-ascii?Q?NslvX5c+qr2yOjjuVUylnOqMmpHxqFcSRS3tWsf9YEksATomgw4UefrR4Z6/?=
 =?us-ascii?Q?sN0q9n1Oy8RY/c3UnIMnDT13gbwp8tuhkCDlRo/3Ovn0N9Wzhp8WEEYcTRB5?=
 =?us-ascii?Q?pBNGR7TbHe5IY6MOUrsqAX8LniBqr/C90Ek+MfWFOIyTHPMjqBo/CIQ94fOz?=
 =?us-ascii?Q?uHujidq9WbNFFgzjVl/Z9T1M1f5Stg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cbf58f6-0bf1-4119-c7a6-08d8c6588364
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 02:24:33.5687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TJrbkCwRXxgDAO68X9T0m55dXMSpCbozwXuLB4DL70tgxILIt/9uBGK1exXdq9NjYRSbSf5Wtyd2n88XT+niSFKKISWNcPuGRLuI8dFWzPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3958
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/31/21 18:06, Darrick J. Wong wrote:=0A=
> From: Darrick J. Wong <djwong@kernel.org>=0A=
>=0A=
> Rename the 'code' variable to 'error' to follow the naming convention of=
=0A=
> most other functions in xfs.=0A=
>=0A=
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
