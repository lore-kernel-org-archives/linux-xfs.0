Return-Path: <SRS0=A882=AW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660CFC433E2
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jul 2020 18:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4343620786
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jul 2020 18:13:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jCnFYIRw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ju2A8TDl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgGKSNo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jul 2020 14:13:44 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60803 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728507AbgGKSNo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jul 2020 14:13:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594491223; x=1626027223;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=NYu4WHTUkyp5E5C+fnbSYkzfoBrNrobHsLZk2U+O/KE=;
  b=jCnFYIRwxM0AtfOGAAZpWq9YkDTuirB1lSEaXeOiIRHFoRUrykejmBOH
   lrD998FelqvFauLwxw6ULsJM4XDQajowrYCInSiRb2gH2zmbSwVmfkWiC
   BLxcN+64VATQvtej6wuFmt0cpTXKHRR75n5/8RJPm0v3iXS8WlrFROr72
   pQhNusYNryzCmDsAcmn9cLAVQXizq3wSXTsLHmftgPRFf7hgDvO74Wvxr
   fzWEbo2zkeMHSktX2ql4KGZFFTOcgUb62X2e6vLHELscpN+F17M2tiX3M
   2IEzGaR2jQcJHY2FqvE2H5Ee9N/xTn2e4tuQO7yU6jOCoURXfHuOxMART
   w==;
IronPort-SDR: 8h8ymW87x8/WJEvyY8e/woAvQVkJzqEUQ30LF2leA3ORnI4vzOupRVOuXv2ST2LuriA62L+9k0
 CRz1nZXu29UtrqceKDFgFNyowYoKAeoihwdXGZzmDIAxfN2x5AjKX/C3FV7Sa9sfBbBMs9o1Tz
 2WRH0c6dJRKErowfVoPKpEXEYskQGNhUmzG8+UPRDekBYd4KwOTtxTAK7TtK5KDUeQhHOtxqbN
 7HURFt1i0/vdiXrdW1KoeZ6PCvRLWXM8kRIpGB5QVonfLiOfR37olSBZf3X+3jtw2ORUkpCX3q
 9RQ=
X-IronPort-AV: E=Sophos;i="5.75,340,1589212800"; 
   d="scan'208";a="251453539"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2020 02:13:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5slu7IqdbSd2uXyKYiGL0aOKVo7C91n+Y46Bw7S1TmugAG8hhtPJ4m0WOY721B/9aXguKSRVipkfXu0sI/9TQU8jAZ2ImSbFwdB22ELAFyFN3lpUQT0AczogTEabA6IIMHQbKSfPkH0mcnKwVtoHdjLoGwCMNscDy/WVOXkEu8nEquzrA6ZI+CfYzrqPYEAi3LTRPqthGcxDmw6HLgxPTg7pHHNKnRTcC/TLJOGhynDnCSHNBtaOYCZUdGH36ka3v7E6HIEWQyj398cFXgAmagPVvutycSykfihqcVT6nDpG6T3/5IDaiDJODKfc7m0sx9Y1zqMJ0kyVxPCcwEC5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYu4WHTUkyp5E5C+fnbSYkzfoBrNrobHsLZk2U+O/KE=;
 b=kMFoKdwohO8SzQqdZxarqXA0xSgzlow2WFaESbcQbi0om9+ZggduyKc2u1u1+FUjIupYECtGNryduwh838PeO3Q4jIfPR2JcLGSbOKCBsuRk03ETiaUl3s3O0s+40/TfeJ6EmWDUjLQLFNLc+CH/J+9ui/CcYabUAk7fXbxoqPwjeD/7S8cKytY/KRDIj0yP0KdO8SXVeggfhZOa8GTPBVqLl/ryLeVITx+ABrwX78bEBtptpH3/HjksXAP25JdXjAs0JZGuXOgkpASuLrl4zHGZ7qAhxbgNSbUu2kmoZ5e5hgI4VuvHrV/e+mW4NMxux9ajVV4GDvDNZyKkyzyqsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYu4WHTUkyp5E5C+fnbSYkzfoBrNrobHsLZk2U+O/KE=;
 b=ju2A8TDl62qhk33bi1HYBVwWKfczhvaZ6gMZe5YWJjgPXhW09TC0uIyBqmdaJ4EsaPTEpmakdS+K4qtyMQb4vr5q31LmzfhgDmlXuWwjRuti3NdbFPeh2aZij8Vvk2TJviogtEYuYhwshgUMlv2gV4fmil1ZZy7KK0gMusVMbws=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6279.namprd04.prod.outlook.com (2603:10b6:a03:1f2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Sat, 11 Jul
 2020 18:13:42 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6%7]) with mapi id 15.20.3174.024; Sat, 11 Jul 2020
 18:13:42 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Christoph Hellwig <hch@lst.de>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove SYNC_WAIT and SYNC_TRYLOCK
Thread-Topic: [PATCH] xfs: remove SYNC_WAIT and SYNC_TRYLOCK
Thread-Index: AQHWVn3WudemJT/7pEq7/Ubll7QyRg==
Date:   Sat, 11 Jul 2020 18:13:42 +0000
Message-ID: <BYAPR04MB496509DF5289298AED6D5E9D86620@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200710054652.353008-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b1cdc5dd-d69a-4afa-5704-08d825c624d9
x-ms-traffictypediagnostic: BY5PR04MB6279:
x-microsoft-antispam-prvs: <BY5PR04MB6279300F0EE6E9E9DD1333AE86620@BY5PR04MB6279.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:312;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P27SSLtDsnd//gizHGZah1XWQGqv9u5D86XbqTMUtYP1GYcjaLb31EdxdO++Ps0IBBppRBNB4KqLGQzp8oXL367LqnmEAC4uspWd1HhAfoiNocGEgS/wBvH4ddQZAEu5ggsgePhXVxdAk0yoRi1scFT1MvFdE/z9BUvZjG+YDUxUvCqdSRS6DpECLQM8Hr2DUCOsDMKuf1zCtYVa37PaFo/32O5BO2bjg8lrS0czo1prfUTuogwtcDUwWVo+XEMoBOC4AdvKBHQya7Xa90H3hmphg1U/lfgxA2MigOPCuMhp3hCEU3B65a2XPlNb0imcZf1JOZWa3Pp1Ary1BcrL5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(55016002)(53546011)(9686003)(7696005)(76116006)(71200400001)(52536014)(26005)(186003)(33656002)(558084003)(2906002)(8676002)(5660300002)(64756008)(66476007)(66446008)(316002)(478600001)(66946007)(66556008)(86362001)(8936002)(110136005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EqaWGfo+M9Dxz33sfoTwpsoX7M2KucfeCi2qqnVkug+tpBPT7cdda+vuqTEJj4XxRXICp9iB+O46LsayG3FHzhthg8rJmQB+mACdmX+JNlk43jBwNv9C3Q8fSowlDY3FwwcARByraX+sYxM8uykJjMNyj/jspOgs3EOw/EWbNQDbH1D1XvzZUaVZdvk8jK+gPdb+jjF95qAzcESWAusnS9FHL5qPWAgR4QPoiBIN/egIXlt1MqZocNS8/rSf+IvfxrL0sX2Xh1VScZTAa4yQUY7bDBTYIy/VCuew8+BifpQZE/kgzQAdDpm16xumox4qAP2II/YZEJidw2eRRJij0rsdtb/mTxySSO97gt+Zu2gksG8sfumVvyWzDPNNITtqdAH5EOpOWKuuWtPVgX+rv0EEbin0b76X6Y6zyPFjWTJQiRNrEXIPa8Gb2d/bI6zPO8GvAHAN+Ho7IQz22DhAL0bunLhAVSyP/wnLsvGWf/E=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1cdc5dd-d69a-4afa-5704-08d825c624d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2020 18:13:42.2792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6uMj3rmhyCcUWok98Qm9wwynYBdtsFeaPBl0r2YhkYQ8H+SHJieciDCiaYJL9TDVoqjfzQzTYsSRjv9wrthtMRXoIQpykwQe7N/aKAyqxDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6279
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/9/20 22:49, Christoph Hellwig wrote:=0A=
> These two definitions are unused now.=0A=
> =0A=
> Signed-off-by: Christoph Hellwig<hch@lst.de>=0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
