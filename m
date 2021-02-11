Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44262C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18E8564E3D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhBKXNV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:13:21 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22519 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhBKXNS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 18:13:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613085198; x=1644621198;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=NZX9lgd9B09igwW+HXFqhXxqGfVa69LOnxUGlYmWXh4=;
  b=g5lzwrxGITHjaasXx9iecvnGWBManA7Al3VVQYNMKol0COzkacv8Q+SC
   h3bNut6Q2dIW4Xis5lfV1OIxgDncEHT3wTEumE0YhdwxPctFWnWz3L14A
   X3faxD1FGXzxArbL9ip+NNN/UGKiK0kdnO384rr9x/b/kZ4MjNsBjPLIp
   jzUkb+oWwgGTXrxGI9GJgIa5W6jvF0WHf+jlxnlk6ffbuK7Eth0eX3c6Q
   bJhXs0jGZ1ZF3M706S9WSCqvdwvM2ghAP0ifo58Al8eBpf2+LSKNoq49d
   GV9BKjHNYYJ4HIeItKX6MNC2JpQJ/ONgqyGOqWJOYfpPMA9KG5L7PKuEf
   g==;
IronPort-SDR: 2YaytU7uQzj/rrdTG6cR1gvJNX4dDqZJee9RsuEsS96meQle/ujdPQOCto5O8BKD5fN+7JsCHg
 GrqIPt7u4O4rjxgxeI3/v5lAflBbdHLeMvEWc4fSy+tZSpJn4/dkCMqzMcKqtmJTQ5FLxjr/5n
 3cIO3cpN4H4aGdrA01XSUMW0mh7vWa20H8uwfFJKNiBO0tXUGisBupRuwhChfoH6IviYaFxyO3
 0iYLSa4YCyKZDzNkvILX7aTAHnd5oK2XFK0XU1I2ZQN3OVclSHI+F+pMo+DZ6gTIWHy/ChyBzh
 mTQ=
X-IronPort-AV: E=Sophos;i="5.81,172,1610380800"; 
   d="scan'208";a="159809899"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 12 Feb 2021 07:12:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NX7MvF6zV1J2d2I662ZHoPTXK7pdIdvhybQvY+vSgvCBk/Krd8NnrU94nxzXbGGForhTFebG+C5v7PQL7dgKKcSkjs2z8I7J+BDXQqUzkqFQc8e9BJA4anfZ081ObTXY3b5Wq0c7F4i0KBPzR5hT3anBF54ppaj6/deD9dOgupI+ESrRdkMexgFc//gTuW5QC7u8Tw0Fm9Mz8zU7iEGaLFH4OzEdSWnTdLw9qLCbyRHnD5j+hkDATNxGowm9+S+VY0NmL/W8w7AM77n0OrSODqc2DhS5don1yl1Nog1JfuKHFQuS3qtKGmi19W+QkrNclGO5YpohETi0AhHSOL2r9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZX9lgd9B09igwW+HXFqhXxqGfVa69LOnxUGlYmWXh4=;
 b=aypIANOk+fSBYih8wZQM/MAyAhfOA9eqBkYOtM2NExmy9Bc0JJ95M0WR7qJ0gWyhzK6qjYQ6M0dHD0nWBuvsfIXxUPZz58LKiVd+ZEaEt7XC3CcuiGW4mUQ/pIB7byKJYOB7JbEXCGTXa4pBnFFOXpHf3YU9tAid0osMIPNKz2eGXeTIev9HPTuqfshG6yd7DVIeGG0OboOIc9C/BdQrVIM4spaE8ffehAXSJkGbN1qpP9jF53jxjbV4ZATyTKrjD1ededcU4Crtvap0t/zDfESwmN4No72CPoA45oyuDW4fOuyEJ1P4/NoVxwxv1nyQL8Owf6SYw+n+1sBKcieJ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZX9lgd9B09igwW+HXFqhXxqGfVa69LOnxUGlYmWXh4=;
 b=bvyQ5fqY09tSZ7jU6bPd3US0lFsRPjIaloK2HjDaiA89cfo9K5TRzzA4HS0TCmxS8o5D4DfeRY3GyyZguJErBrR//QHi8lytaw6KJsGh9aZIbFWzKd8ogm1xD+GpSgXxge37xgmFIU40m2gTwJF0GTGhkpBhP8TG6uTOSfLXUsw=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7261.namprd04.prod.outlook.com (2603:10b6:a03:294::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.29; Thu, 11 Feb
 2021 23:12:10 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Thu, 11 Feb 2021
 23:12:10 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "sandeen@sandeen.net" <sandeen@sandeen.net>
CC:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 05/11] xfs_repair: fix unmount error message to have a
 newline
Thread-Topic: [PATCH 05/11] xfs_repair: fix unmount error message to have a
 newline
Thread-Index: AQHXAMnBd5XgeUpsykyeymrzdZ4F5g==
Date:   Thu, 11 Feb 2021 23:12:10 +0000
Message-ID: <BYAPR04MB4965715CA8A2D25A3C6CB0FA868C9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
 <161308436971.3850286.1647270104945019584.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 37dc5fc1-4f97-463d-39d2-08d8cee2757e
x-ms-traffictypediagnostic: SJ0PR04MB7261:
x-microsoft-antispam-prvs: <SJ0PR04MB726182FA0C345E3BDA68E056868C9@SJ0PR04MB7261.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zM/8sC7H/kVfv6Uwo3aVqfocOXwSO+a414TcOT1aJTQxDtLW6GI/9//9sLN7Fi2Rzhk4fLQA7uuBnLFlcvdjUs76GQxxJSViiVKBBUJ+ZQv7WozubmZWU6r7hI1TlFtKzDTIqKVdQAeDPZUjO6gVisrBxT0jmruRD6ZSGu7rcT1StFaSt3Oh/kWyj/TfBN/KcizeyZLcKD8R4qDpheZWUepCXIlT/HQRy4sX179dNaZIfoyg0OB59bghhl0lig9a2PWfd95rB8fGVtDWpOimeZ+qzZOCS9Gi/a/34Rn+quzLXBWl7y3KtPOI+Akx5o15YL3SLIcAHdfEQ710RiX0pFs+IABTsui2NIl21VXTqdEzQh0kcr5HmDwq2A7bPeJeWV5vuUCXOxcO9TSg/994IJghHDTJcw3ffCADeXMixabIW+8ndBn7gtMs7YcVMwNr2VJvg3yUQfGH6dg9NSeA+XDP2d4GYvN3htgJ4S4Yn0HliAh+95sUaQG8W7Ejnnlt2OykHWKKKmmnjbdCtMZqsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(53546011)(6506007)(83380400001)(71200400001)(33656002)(8936002)(9686003)(4326008)(186003)(8676002)(76116006)(52536014)(66476007)(66446008)(15650500001)(558084003)(26005)(64756008)(54906003)(316002)(66946007)(110136005)(478600001)(86362001)(55016002)(66556008)(5660300002)(7696005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DitO7m7l8Xls0agVTpLTTL+fht+xdjTmGjTOFnD7WPzvmGbiYAdBKmyhrkan?=
 =?us-ascii?Q?lDUzWF/QHxZgM8437nQPPt0JfLGn8JUjia+75eF8qUtg+QUkddpsxp6jiSH6?=
 =?us-ascii?Q?gklWtjG9CwWGyGdPoMDcwjSPQZ5L8UWzQdYzV9fdevEVv/HUg649oE20wBsl?=
 =?us-ascii?Q?mSurX0p4e/zZVS3sjNTRYVZgZBu5zPVZJ/MfB4e+mtlQc9H26PderOL4AaGT?=
 =?us-ascii?Q?ru7I5UCaLI0u498c6lyeAletPNgYC7khga89R2ghnNRW9sWbfN8L2ocGY6Bh?=
 =?us-ascii?Q?H6qANnTulxVNu3C+3i7kq1t0ehUJLPcZRDf8QE3+ipAPjj8DGWOg1YBMs+og?=
 =?us-ascii?Q?QCTR3c0co7BGBVS50xnS4/1/7Pe8duaI8SnP6HFozzg0Oi6zvA5JuiTTZc8e?=
 =?us-ascii?Q?M+JNDX67vahCuxd3vUpBcLaNDx3+40U72av2+Aj8PP9AKhLSmyr6TMtVcO9G?=
 =?us-ascii?Q?DXvD2PkyhrNHo7nvY0JnLhCwwBEV6DHpocvuVa0TQH63GK94uYh1P8Cl79Ac?=
 =?us-ascii?Q?B56/lf8+IIk6GLKzFFktdNHV3PF4rpayip8ik9+e8ewxvqDWkSPXCTFMK0uC?=
 =?us-ascii?Q?HwHWfleTnSR6pQuOpzgcNBuVg31Sc1Knr6WLFUoV1uF6O58Yi31gkYcZyUmU?=
 =?us-ascii?Q?m0+KBv83FUnfEcWpNqk3QcHd4pcdsJDFbXaaNKH7IAXlTHHVRY2zgvj/lvFl?=
 =?us-ascii?Q?BYL81/5U1AGtgkja0sjsOnWno6xMZqjWDYcQKUXKs2iutkloA72kbpfMzOd6?=
 =?us-ascii?Q?aRVlRs1FzdXcl9DtOiwMucose6C1PX+PEwaD+SfuY5iXMkzuo1wh4/2iwarf?=
 =?us-ascii?Q?bTkota9WNfXH9GqOCG37zQkUWd41TNxhhF3bFVfZORr/2Ys1M1w4XYqzxjNI?=
 =?us-ascii?Q?T5DVc4YNMGwTtStOAuk3lUdhV458xFpg8Og8YHNTrJg19c4cHrEiYqa1LMCq?=
 =?us-ascii?Q?iYVP1Xk9xd6RDyzXpSQEPzsWSbyZcinCJaPvnO3xkcwhXubZQZ8OSASEyyGn?=
 =?us-ascii?Q?BlecvXJU6DJ6PzieH37seP+Q4wZio+ZhUGiMjZKlZ5YNglyV0f+T5i18Ch7+?=
 =?us-ascii?Q?6b7bwkcARIalovIenu/8FU0GgFNQWZ1kO13m4f/HumsENe00wg+uz3Ca8Xhx?=
 =?us-ascii?Q?fcp5TczzWEvRt0boqDTGVEtcnnk4Sq4/aI/d8g+0alSKrhHQVjnAhekXj9Va?=
 =?us-ascii?Q?a+dv0Y8DddWWvtRv6ZsOzS6ANM9s/tXG60Ffi6+8cPt4Fi4AgeIxiMLwB+z1?=
 =?us-ascii?Q?c7x7L7fAXvU//qGkjvgxUUp59d18DNn0o7+hNFKOLQ2XF96WwKzqKQwRUTTx?=
 =?us-ascii?Q?CD3N+E+Nhriu0k2aLqofruGh?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37dc5fc1-4f97-463d-39d2-08d8cee2757e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 23:12:10.0763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MO9QGOb5NnoyuQqf/+UvEOQH7RKeB1WYVxjxrdEfmHzgESTgx7r+0GyZvTAHA6lxW6zpwQT+VHfVTHHoCCM2pOPw4sSYRLI6//k84bGAy7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7261
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/11/21 15:00, Darrick J. Wong wrote:=0A=
> From: Darrick J. Wong <djwong@kernel.org>=0A=
>=0A=
> Add a newline so that this is consistent with the other error messages.=
=0A=
>=0A=
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>=0A=
> Reviewed-by: Brian Foster <bfoster@redhat.com>=0A=
> Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
