Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70881C05027
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Jan 2023 10:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbjAZKqs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Jan 2023 05:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbjAZKqr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jan 2023 05:46:47 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2107.outbound.protection.outlook.com [40.107.15.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE4651437
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 02:46:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAQkf8DS9DJ7sMVQenFmoymvOIU47EF8Lp6zseuaAUgzx9H1PjjDqJdr84tIT24u1UZz38LYP2eeJqUStY7JGnov+zW+gJklZgvfx9PDESaiy1wEqvo4vwmWuOTIrLzafyqNmp/31WHWLzDH6/32EbczMHmdqN3gqhNQ9NP4iux2tzwaWI00LM5EaSITfGO2pLDRChCH4BRv4ECa/NKQeLgLc8KNPcM3mq0TEbcOMLwkjLowg9mnnr0s1dqIGxeNKocUN5MwpjohtaywIaNE5Rn2BaBSUCBV1D8YUMujTHKXCkBY6ANx85nZLbMHvfJ6bWP4+I1AkBbgpsBJGGRE/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sW1wDPn6c7yKkbSGulBNue841i+SeqQOdBdoO/sUZwQ=;
 b=QCvGrXuygtNCAW079K3sVbBZVyPOv9qDOjUpVeioIZpPVHknsxUPl71aMB4mVCxy2jyyW2NpUlrdQuSJJSuAl36Y4zc+f3KwXfd7DK9aK4C6MHZtUA7Fk0vQqgjgWmqUWXLA/LHAlEV907wGNfGuCaKZTEUp6PjPCk1rkGoHDm8yN59GyJSzG0k6XD6a0YljIyxxHBFt68BHeWl0GpVdIVE85HvSl+oN/D3KzekcT2gtaa3VaThbX6IUEI1l4L/Ns5viTOkbAlgbN378TZF+hPuOhXvrS3efUL0imcL6hY2TrViCiTNnqECfIvIz57b7tfTl4YGuLUwJw8FNwIFCtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bcom.cz; dmarc=pass action=none header.from=bcom.cz; dkim=pass
 header.d=bcom.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bcom.cz; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sW1wDPn6c7yKkbSGulBNue841i+SeqQOdBdoO/sUZwQ=;
 b=dOtg8yb4sO4KwXl2LVYDo2Tm/ml0bgXcuyV73mybMqA8dB3bbbzUFl6l2ZtNd70CA5WCshAQnqSJH893UbPVJc+fQiSI6yPlTkVO+rX23GvBLFTTbQJhqU12X9fTaVDCdyS/rzaCsY8Ga86Thq97IFaPtJ5m+SwsAZbB3lXjkow=
Received: from PAXPR03MB7856.eurprd03.prod.outlook.com (2603:10a6:102:213::23)
 by PA4PR03MB7454.eurprd03.prod.outlook.com (2603:10a6:102:e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 10:46:40 +0000
Received: from PAXPR03MB7856.eurprd03.prod.outlook.com
 ([fe80::c18b:6bb0:4121:6758]) by PAXPR03MB7856.eurprd03.prod.outlook.com
 ([fe80::c18b:6bb0:4121:6758%8]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 10:46:40 +0000
From:   =?iso-8859-2?Q?Libor_Klep=E1=E8?= <libor.klepac@bcom.cz>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: xfs_repair on filesystem stuck in "rebuild AG headers and trees"?
Thread-Topic: xfs_repair on filesystem stuck in "rebuild AG headers and
 trees"?
Thread-Index: AQHZMXJ4TCclsvSXT0mdskAJxnfhqQ==
Date:   Thu, 26 Jan 2023 10:46:40 +0000
Message-ID: <PAXPR03MB7856BE8E2D589B6A5FA2B84A8ACF9@PAXPR03MB7856.eurprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bcom.cz;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR03MB7856:EE_|PA4PR03MB7454:EE_
x-ms-office365-filtering-correlation-id: a7b1b6c3-ccb7-48d6-5681-08daff8a9b49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LLtAnBLKT9YozgoUmX2+ifCiZE6Rl9YNeb5SYvazma2ZNcTmfKCwnm5LLMy7Mf/YCkMBTCJHDJtDhNIaFZc8ZtRl0Geobn8Im9fZkQ0y8eZJ1a75NmZ4uAXcsYgSIAmsp2fdo8NMaVdPX6u6bJJqpyGjWIuUZQq6QToMThGmsZChgzwxeGmHxY25F0V6YO/MgHhXO2NSVmvVy9GJKRnSjHJGHGFyoOs3ZpHUX2GQGd3g0sMtdXBdsiba7QiF0xqcdh72vYJ2lHAspBZ0m38KjPgUeNdObhSWvQL3+PpJnAPbVGT6BLtMY0BTjvZAnESBEowZrq+Dv9/CB/XTMPk4zDvMLTi35+IlQ6Z9nbJU2aJonTcLz7n/bYrDk/P3xhGtyuDn7focJq2ZyVu9a3P7MxUUORe4sRnWYpHvTWXnnHzvDNll0f873Fieg8s+BOZfhM1mftZBOPca+qBT8t4gCbqcUyuIF6ufnkaCZx4gWte5rjUHhT3jmMg8kUx8/4M9nxJPFKpoxvaup5CADp5nxX/BUaDYmVsx92PRQ3c/YbQ+ykXUSgrzk2kATpnvTesvsI8DR1E8+i4a4cccmhwnT/ja25xxWZ63ea3nnBoRLJ8kPvoKOuj/7PvaifOWrwLKDeBNRI2p2Hu2WgaSS4EYZFVrTBN8UPAEXYiUdyyX7GITgsVsapeznpxQjwxDL2sixkHPcalwxlLt1g006dqpmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR03MB7856.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(396003)(376002)(346002)(39850400004)(451199018)(83380400001)(186003)(9686003)(2906002)(6506007)(38070700005)(71200400001)(5660300002)(4744005)(316002)(86362001)(8676002)(66476007)(8936002)(91956017)(6916009)(76116006)(66946007)(52536014)(66446008)(66556008)(64756008)(33656002)(38100700002)(41300700001)(478600001)(7696005)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?V16j6argr6zWgZaX88m5kM5IK9Z+VrM0txwLKu/9F483k1pwk9a6KScusx?=
 =?iso-8859-2?Q?YSyus9bl1quZpPwVcZg32grTPSdCUTbj2d8wssSeCUnhLx7rtqvsSc4jvw?=
 =?iso-8859-2?Q?OPuJf4IgF4DMtPaV4o/YLP7nGifxskUfFRay+cntkyOyrKWU4NQ8OG4J/R?=
 =?iso-8859-2?Q?GdDxBkFokKlPAlwf2uz6UTvrd+9qryFis4TO5R9tM7XoiFM7wHShsItW4T?=
 =?iso-8859-2?Q?OaPwNyQ2i4a3kRO719NT5U5RxuKm5SdRSjMPtzeWT00ZLwfjHWjzIwIKjN?=
 =?iso-8859-2?Q?j1QZ7WYwdOwFXlK3gvC7lTtPAlD9woqZhjTZPRG4uD/YTu6hWaPw2pw8NW?=
 =?iso-8859-2?Q?z6d81QauxjsTO2yCLklfi69y4qYpJZfHxJJRyC0rWNxRbA3Tx4QLACvdU0?=
 =?iso-8859-2?Q?370T9pNX1pRhoYb12VVmLwW/VeKCHomhEiZkQ3944RQFH4PjbfaqLff90u?=
 =?iso-8859-2?Q?7aKqIiSLk2ErwZQp0VTcCrcFjGAJG2I4UBBmQ7dw9zmqczi7RsL6URzP6u?=
 =?iso-8859-2?Q?lanUYNVDmKY0UOp+BsNSd+wOMz4gZo233+1apBDDIdEJy/CMR7zwcoTNwt?=
 =?iso-8859-2?Q?yE28alErnb8c5YbifXjaU6Z1G3E18r12E9TvjAP7LDJHJT6EAa3FyTsxOE?=
 =?iso-8859-2?Q?tXOkJy+BHNj1GmOWhkZm6skodT7iQLEtPlCoeJVDiy1WXHnzsZzjfRrH7S?=
 =?iso-8859-2?Q?oaU/B8fOYeuknyzvyxc9NrXB2sOrWIwsFkeo0YvxYw2EHOFuFbDnqaUd7y?=
 =?iso-8859-2?Q?l6kXAUvUMtNSKCEVQ9laeE1VSXHWcuv7vGac8ex25yD5IR1ZIRbmMDrtZv?=
 =?iso-8859-2?Q?U1YGzJmv23dFoUYPG5smSFXM6fid8XEOs2ukn3FAANxqgZC7wCTL/Dkfe7?=
 =?iso-8859-2?Q?6kOUtnI4rCQTjsmd8g1IEXuy1TD4y7m6wa6JcWjPgDtYCAK2mXENipFtp9?=
 =?iso-8859-2?Q?sXUF/FcIeFueeTDCoTt6FPW2CB3nrd7vSJapjdDDLW14v2MhxyGm7Y0Agz?=
 =?iso-8859-2?Q?M2NMYRdcZVc3/CdzIcDRR72BQ+nPys1L1JQ37CnmIAJb22Smwevu1eTy4i?=
 =?iso-8859-2?Q?qAmuBBr8GmO95sx+O6H5OxVNF3l/3L2HOUXB+uA95XqfIX++KXxwVM2ot5?=
 =?iso-8859-2?Q?P9DA1A59Lif+YgtnYy6oTWxDAnxI2D84UgSVB1wlLtuNYo6i1sTaH4CAv4?=
 =?iso-8859-2?Q?qmKNfVSqko6MjPYkTVQRN8LMqq/tg3XN0rWs/s+h3oFN+KuQT7qljUaoSh?=
 =?iso-8859-2?Q?+h3wRSdZIkleEcPcGkC8OsumKf4lmtCJ4vPqjFaZxLmUtalO72lNoDWPgC?=
 =?iso-8859-2?Q?qUEqcq1EY2GwJtiK2Bm2uMJNrMCkM3qAjtoJby0OIcGBxhWrgFIBJS9WfH?=
 =?iso-8859-2?Q?iZjns00DTmYNLlKunuJCj3A8HlpE7sMKHvYljZ6AdcoMfzYowuLg71cUXe?=
 =?iso-8859-2?Q?+aP8b6n3e3Y5QYhpzHoeSMrYCehyAgDXWLd7hQ7drovr+cINS3Kq1BvV+O?=
 =?iso-8859-2?Q?M8T6e4pX1YKqusTn9JjvF1cIs9JHaguOBxP3TQ2x1WHUfDPhXocpRcgkOg?=
 =?iso-8859-2?Q?7ukW6oxtgUhbDJNV4P9e4W3wMBsqXICySixvlfTzMtzg+h+0edkmin6vZj?=
 =?iso-8859-2?Q?czcpFC41rhlyx9QWYi8gMEhxHPYrRvuB51EoaUNvILUnTLz64i9ABjKelx?=
 =?iso-8859-2?Q?dUzvUUhqGR7iz6toWQI=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bcom.cz
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR03MB7856.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b1b6c3-ccb7-48d6-5681-08daff8a9b49
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 10:46:40.2034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 86024d20-efe6-4f7c-a3f3-90e802ed8ce7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M1weYgEeJCH1Qw71YLIy/aiAD2tjaicmGrR6caHoxDXX1LmWSAQxPu8ASMStBV/A14yDB9wHzX0I7MhdGqIKng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7454
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,=0A=
we have virtual machine with 8TB data disk with around 5TB of data in few l=
arge files (backup repository of nakivo backup solution - it contains snaps=
hots of vmware machines - one file per snapshot).=0A=
=0A=
We have recently upgraded VM from ubuntu 20.04 to ubuntu 22.04 and after re=
boot, mount of this filesystem took ages.=0A=
=0A=
I started xfs_repair on it and now it spits line=0A=
rebuild AG headers and trees - 16417 of 16417 allocation groups done=0A=
=0A=
in 15 minutes interval for last two days.=0A=
Is it in loop?=0A=
Can i break it? =0A=
Data on disk is just remote copy of backup, so it can be lost, it will just=
 take some time to transfer it again.=0A=
=0A=
Kernel is probably from package 5.15.0-58.64  - sorry i don't know real ver=
sion, cannot get it from ubuntu package.=0A=
xfsprogs should be 5.13.0-1ubuntu2=0A=
=0A=
Thanks for any info,=0A=
=0A=
with regards,=0A=
Libor=
