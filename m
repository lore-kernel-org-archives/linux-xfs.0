Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C2EC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 686D764DF3
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhBKXJS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:09:18 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20671 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhBKXJS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 18:09:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613086094; x=1644622094;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=IG8x9Dl9lf7SL0P1XCsQueB636PdtFm8Cg6YABlcuR0=;
  b=LXd5lwWAoxCyDlPGXIneVgr+w/vWfTuMa8cV2hd7KCARN3PWhacbbvZC
   XmVVeeFVzquv3c3UiwK204DeXVBHTVMtZR2/XDtdTA7T986/yyfbxPdk/
   oHkAFjHgeJjddrE7HccoAX8IqgSmHTGovPilpMi66l1t6+HRaiKYAbbfm
   VsVrCO1Nzdg4c5qq6KyT4Ft6Rc/QPkYmm/x8sP0RzhLDwOCuZUSBOP/Bi
   P/FYaW0y7Vl4ULbo3IC0EKWyOfvoslHyebwczGX2mtTKyK/S2gRyKvDsA
   vq4NSAxcgf5EnO+B60dpTjMQJB7WWJKfDxd9tLLgCnQHDYtIvTS78Oorm
   Q==;
IronPort-SDR: 7ugc/JWpH/7NZpldU1g25GJn7I7PrUEqw9SxTtk8nJh+cFGm9hj7HYXQtsk2u6lCke9v4dqkGp
 ziLIycXKxEZvFf2esBpYI0ALkWhOpMTq1s1vQdtYHrnA1K2ImIl11JRheZW9YpaBrnWHtPzBLk
 a5qPioZgXjHD6ExDCVpKT+KtgAeo4vqqoCGQebLHW9YZCEmn87W1Mn5ULlsxvCyfT+BEp9vY78
 IiLUkwlF5UmbNxIr5h2Z8Mg/W5DZ9gTzd9BPF9lnDA0BhsNcv/Nj5q8nRjF7+7iiWOefGpMCkK
 Y2I=
X-IronPort-AV: E=Sophos;i="5.81,172,1610380800"; 
   d="scan'208";a="263926219"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 12 Feb 2021 07:26:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXl3+S+hDgvum50nG6hWysd7Hb0VoLJRGCnkU822qhhdSkpV4bitAZPObKWyh1y6LQYjHLnR6f2nVK849i4gTbU3lf4mVK4ghno6KBxAUWM5P2ckIjC9y4ai2uz9+TCaFW4NLtxJAvLSi1gM8yqIMd5B9DV0uyMySSBBi+PMwrT6HIJd4WeCopHfYsFWGOqO7m6eVYjwgO4m3bgJwclbnEY8Y6yfVp6cEajqHd7IDgl5vaofdcF3aDJ2eioxPbP1KrcI7pdD5e2c0AJGs9aGeecgz7DbJuEWLAmqsCVl9vDE/1WrJWiEfcP8Mt3R6NxAOIJGvHDpYpGCsyUoJzy3iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IG8x9Dl9lf7SL0P1XCsQueB636PdtFm8Cg6YABlcuR0=;
 b=NNTDqOQMp4sli1mjkQVxfwEN4u1FOdtHKl2rmXwlMND81LLLtVyZw1MX9EWCvcbYPPQfY10zA+iQinIOF6diCyAUXfSX6yrYbjpFLeEukIj7JLmuYsdCchiLh7upCbyZdQVq7ku9nGokuK/KyzzHNjB6lLe8JSOuQRCy8MTzIgz4OUSFPMcerCkcPdY1DPRRga6ZG+hEX93+Gicxayl00JBgTHP0wUV02xNfw32DKX4cTZVpSF2RFhQ9wJOqwuHz2O3yY2+0tEqmvC6X9dJdcqTPt9REtiUapLs7Eul1ypEFQLfQ/KJZTclv30dwk62NBg5WJTQYI224bJQ3sARm+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IG8x9Dl9lf7SL0P1XCsQueB636PdtFm8Cg6YABlcuR0=;
 b=KETfg+PwUYAszGId7B2qLHrP8MJ1yGxjggHYsby0rZ9sIQytRJfvxBrCfo3OIsfZDzbVyKvoOZXatpzZgN2wqi7eg50yDMfX/oR1F8CyGXvaQGXBwBaEhq24sDd2RnTSnZUdgLjROPLl+f4/b7dI2pqTrYnQhGqSxJ8hKcZrw30=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6424.namprd04.prod.outlook.com (2603:10b6:a03:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 11 Feb
 2021 23:08:08 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Thu, 11 Feb 2021
 23:08:08 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "sandeen@sandeen.net" <sandeen@sandeen.net>
CC:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 01/11] xfs_admin: clean up string quoting
Thread-Topic: [PATCH 01/11] xfs_admin: clean up string quoting
Thread-Index: AQHXAMm5WOFh98NTwEeUFG0N/6usdQ==
Date:   Thu, 11 Feb 2021 23:08:08 +0000
Message-ID: <BYAPR04MB49659E5B59AC4ABFF8BA7807868C9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
 <161308434707.3850286.16561299406740612589.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d7b17474-faa1-4f57-c715-08d8cee1e58a
x-ms-traffictypediagnostic: BY5PR04MB6424:
x-microsoft-antispam-prvs: <BY5PR04MB642404D4DC431243FFE90B16868C9@BY5PR04MB6424.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m+b1z/s+JYt4nYAie3fRq94vpeeDK5NwVKH5AXg9aKelvRO1LqCrcdoTEmQ8WKCv5t+H5OUWvB9DUW80MClNKlVkk8XKiMNLP2EFFHlLfeAEsloSW6DVcZjKnJ5/co6k4N0PYdghSF9ntbU55+PeZtTYLWmxvvWYCn5HPJpWCaVKZiZgmboveo7jM9k/ttdZ7AgyECUU9n6BzFSXeD1+OD00VjN1Z6Plu1jJf2gG/ur7a5dOL+lFFmeY02YE4wT72GoXXFEtDSUR9401JQyIlCH+PdKf7Y4S5R4rA5VBmpza9VzesADUqkFkddKF//wB1lHfVXTPeCFdfjzB96TKsmnGf3ZWFgP+GBkdrHa6+UDaaCVPXtUcOQ1bHL4oDsRHaVWdhv03TV1Dc9iL74pYQRvO6saCMcNHzQ2HuqyX1CKz6/vH3CBes6+Zl8TXzh1e91476RHaT+IZ+F455+ebmhoTfIrads7gAdvjFvcZZn3y/7qhREg+saNU6osImK9eR+K07Vns8NV0sqMzT0IblA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(5660300002)(7696005)(478600001)(4326008)(86362001)(316002)(54906003)(66556008)(33656002)(66446008)(6506007)(76116006)(71200400001)(64756008)(66476007)(186003)(26005)(9686003)(8676002)(52536014)(66946007)(4744005)(2906002)(110136005)(53546011)(55016002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OuJSIl9gPbam5H58L0ANLb58ZW9bhbBuoYQD2SdUDVU7IxNW9wRruTOk3z+I?=
 =?us-ascii?Q?bBy58NdRiu8S0e4GJuZWZdmC+er1k5qhW9DZHfFkeBIW7zm1Zpl1L8bbw7xr?=
 =?us-ascii?Q?aqA7OmH2uf/QEc9UQ8VdsBu8aRnZi00KRQSL3yekyap5Gi/hpi6RXzpDFGo5?=
 =?us-ascii?Q?KRurAcQAG/d/1uojCWEtn/6KYhY8p799uBgR3gjUDNN4WJLKKcrJ/kri1Ul2?=
 =?us-ascii?Q?I0jXz9Arfyoi1eMLi9ghLXt6Wzj3yxBLRaxIyM2Azdz/i9hZWSWulSQeRIa7?=
 =?us-ascii?Q?ai8Qsq20KmEUNUN30AILTj3WqUDZGqyfxIePSezRdzO6kIuA3aPFgEwGNNkf?=
 =?us-ascii?Q?m2ckExY0G+Hdj7fmCBeg5sVedRtBJ7Rjw8XjV4UIuMrJ0SyF+kpJQMeXcPo7?=
 =?us-ascii?Q?Jf1wMduHF8TStcwyj9SRCEVwAPnPmaYpAufOYzZVApkM+bt4Gdn7FdGgTk71?=
 =?us-ascii?Q?Uvh0xP6Mr/iOhGd+1Y4V9+5hzyp73fVQpPKL8UaG6KMlxOIPxIiRcCESmOCk?=
 =?us-ascii?Q?/HPHwoF++rBW5nNwE8kCUVw1P/cbdQWQslakKvaz7zhyZCWbHtEuN1yQ5/t5?=
 =?us-ascii?Q?n3EJZZsiMpIET+rNJTEtDMAxb1yJIBkRdsSH7azdt7/p6HLVUX7K5FHn7KoL?=
 =?us-ascii?Q?S/BnNcEwPwU3JAL/PIz3bGkxWzeg1RRzmXEyBb+rVdmF5WPvWlgA8VnLnPpY?=
 =?us-ascii?Q?AS4J4g/8GEpMxMJEhaIwoRPaWG8JOY8RPKTc3IYLPTF6WEgGgn0AFGYBZeZc?=
 =?us-ascii?Q?vdHPDVRs39hH0NLfVHiaJm1cxyS9YUGnqi5PvXHSMNpha+lF3HnQ8vxkgvDC?=
 =?us-ascii?Q?k7riuCjBBBGv7iWshN7pWEZYr+D1eGKwg+SJ5ZyMygr1pqBoLrhTEcZWkY0Y?=
 =?us-ascii?Q?5drXvpCPXMZLVE+stw9jAa7glQrPkUqpLhnJiM00KfTcPCaphFaqqU1wiHHV?=
 =?us-ascii?Q?ZRCXqt1fzclj0tkYs4nso4+DDEm56c60ySgYZ9t+/dHoXXYAj/UzgUg0/JVJ?=
 =?us-ascii?Q?02fAGuE7rHdYheGZuNgwqPW4SwfcrBx02D5DyAbo+GWJLha+6HyjTna7fV7U?=
 =?us-ascii?Q?RZYwPDOGCBivR9Uu/kUI2GWiM4I189/77t4pGjAZKlygOzRZnznxOb9Q3xZ0?=
 =?us-ascii?Q?VnW+QAdLVPLj/TrXPeIynGPQPuQ7rmwV0QKFWaYP+EOJeMZCUsQqS6eO0/vh?=
 =?us-ascii?Q?Qe9cVvDiLxgx+98ORODwiFpl8xSBku0H1BVDk6UELPxJlOQH4rm3PjWIetTG?=
 =?us-ascii?Q?dgU4blVICYDAMzSeaEc8ag8/odfkZhNS9fgzBF0w0Q58cDY4Gi697Xp2QHG+?=
 =?us-ascii?Q?DqIsETZCm5BumSuZzzyp3Al/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b17474-faa1-4f57-c715-08d8cee1e58a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 23:08:08.6176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6aacoJVf/iB6scgmaIe7oeqHjkBM6goOPaRIl0qMzlbFExmrXIoLcIhD6YwOHa3N0mXFLxaCMUlCIQRuUk7O84Wo2qXIUmGXvbxqY8wODeg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6424
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/11/21 15:00, Darrick J. Wong wrote:=0A=
> From: Darrick J. Wong <djwong@kernel.org>=0A=
>=0A=
> Clean up the string quoting in this script so that we don't trip over=0A=
> users feeding us arguments like "/dev/sd ha ha ha lol".=0A=
>=0A=
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>=0A=
> Reviewed-by: Brian Foster <bfoster@redhat.com>=0A=
> Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
