Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C9FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 05:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A57364E4B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 05:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBWFa7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 00:30:59 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:13992 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhBWFa4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 00:30:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614058869; x=1645594869;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Tt4U6/y7A2NfPlvEsmc8WXGAR1xvyVTApb0SP3Qn3O0=;
  b=jDsZbSrBmulxHhO4Dy+3DZFGRlWREglGK/pcH6JFmg0HHtbeETEkpA74
   sh59AQk1RTGKIgWDw6fDgPXLFlaBQbJLoZR+wnANz3mnW77ntwm4F5jB3
   SurDVtpO3AEk2fYx2QHEQ1TAuHZaCkRaxitjIXBxtULDsI3jEpvz5QuE6
   jblYwQNn4aIU/11rQIZBfWH5AgyKLoFEqWGh6tFTzcWnW1cTeMS9HGrib
   2Xo9wbdAAyQXQcWbklIiQu8LNqNx0AIPkp5HQCqNAxo+CwBjoI4Ji7T4M
   iRELh37mN4TBqivGSBqLkDMI6GXFTopFjY+30rq0ovw7BZZRxLBzNo1X2
   Q==;
IronPort-SDR: UZxP7z4lJRxnvGMZXroj+rlgHw3BIoCVHULnRJ+t9W60WM0KOQfT8myV53IiADf84On5QFWUx2
 vI5mR8DHIzhGR9xn/wLRqrUI7fWvgjYGbMwnse6AdmxFACE6FGNGy7dxZFrQznJ5FiagSIXVln
 z0bDtSHYqBmVWesv7eUa+5rMQqrvJ7Aw+rjEml1UEdUjgiN3X3k5RC00wLx6ALJHzxj9mV4bvV
 lOWWjnS4dRbzkz5SmNWiSBZ5nLFDd02osd1f2xJtTmLmt08w8wkTzm1aM8JvEEEimxRgQpInC2
 cb8=
X-IronPort-AV: E=Sophos;i="5.81,199,1610380800"; 
   d="scan'208";a="264758633"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 13:39:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTeAu3oUDjGxm68ELu+QhhXxfV8jcCRLlRXf2Di1JC2IYbuz5ZSrRQ46sBV2j5v2Xi8nvgMBoxA0EjfF+NHLeDSpTawQmQKtVwMwEbg7Ft5MDquK6xvil23UVIccds0qyIN6GjOxAL0xphDzYBZnki1bmbn1fIGTjPJjTzJEXYEYqMb0ZXzaM6cF+JQfjzrXnX5ktB/BatB1ys5HIhHA/tlNw/wm+umvj4uFP/oQMH+IT+lniy2UKPmC/tht9oDj3OHlc2DMn4k7q4sWAcROR7lbhO+Os4nqwqB1Qawh4TxSLFz3KdWInZPN8J8OGf+Ofp2E8licV99PHK3tNmsW6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blo/juMvKrsikfnevWl5Zp13SVuO26qJV5/cXkVGgA8=;
 b=NPfqmw+n/bckRE8DrIyOEdFBWKBH7Bd+muYkdXSlFQ9hNk75yXI5nvCDmk6SA+5PDHGBgg+3BVGRaIzE6Qptz72CevBRn2p+c3xWY0QjtuNb1BSlNb+KCw7Ls+QMgo5ZGWauFbEaC+9FheeZ3ODZb4r88njDvY5ZymFYZqTNyWPnTuNC562/BdWAR+b72rpHviYgR5xFl4crNjvn1ZifFVqFXfI88b5gV8+b36LLYdaRGcgUVsOA3qpqj64OTvxHReP4nLddjdSVFfuvuiJAIRiYilDZl8wLbPp+2JSNRvbdwnKOrKoNw7rpoQJMwwt+2o05hzUEdYrrCkbgoMS8qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blo/juMvKrsikfnevWl5Zp13SVuO26qJV5/cXkVGgA8=;
 b=i2rNqnux40BdgYA1NdFI4v4/tmH4JdnWPhAsHzWh3tBxX/La6eMofgJE77B/UYlA5BLC4f6XfXCdRD6t0uvLrBGKivMsnjIEBOJZ34pAyG/iohqQroHUXnc5reYHtDZsrv03bdRjNVDe+FdFsqpbyk0ORGQQXZpqlOU26lybSKs=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4037.namprd04.prod.outlook.com (2603:10b6:a02:aa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Tue, 23 Feb
 2021 05:29:44 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 05:29:44 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/8] xfs: async blkdev cache flush
Thread-Topic: [PATCH 4/8] xfs: async blkdev cache flush
Thread-Index: AQHXCZTvCoPfG2Y1WES3csDXcBG2kg==
Date:   Tue, 23 Feb 2021 05:29:44 +0000
Message-ID: <BYAPR04MB4965B9EA51C34F9EF205DE6B86809@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-5-david@fromorbit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fromorbit.com; dkim=none (message not signed)
 header.d=none;fromorbit.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a8e3f0bb-74d6-45b8-8eb3-08d8d7bc0717
x-ms-traffictypediagnostic: BYAPR04MB4037:
x-microsoft-antispam-prvs: <BYAPR04MB4037DD24F702F1760BBB8A3986809@BYAPR04MB4037.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Net/bgArj3eSm3bMd40RSi8rcy51aXEuZMT+dE+/VYkm1r5orVtYLUjtgHwyTsn9judqys3605Dhh7XgXHP8VYSBTPaPdlN5U66InEfLh6oHOhGYUDF/F+6/ZZEhEYKWzTmogJaLdHZ36zEeAW2urmgZjyILbGXigyek/iWNWHKNoxcAC3ltVdslItwlnFQI9PWC5KDn2zNgWFm5ZP6hWq5QEepWFuNMeQwv/ziKvmBEa2SxmV+wqyNKjhIdTuhXEGuCRGz3WJcf72PoG7Vpj/EyIKdtaasrRZFElbgGUJ/4EQTJLqw/gxeKbHVmxk76WXSLP8vfTROXneGMJxKZeuFuqv3dO5JUUEvQ0kjRfhNqu6PGEg6lBUT/5KH4UWxxsaENr+wxLJvXpUJe2/QtFP0dai0+daB+FXzBtSBqABmiX/x/UbFtZCpfJ0kpcqJI/44tLAasf24EnbUZAFUxhEpgO8vfZqb7ZDy4FHA0b3rtY+zfiFHnf8l5quzKJGU15Kiwp13DyV+B722WsZPjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(66446008)(110136005)(53546011)(64756008)(66946007)(8936002)(316002)(478600001)(186003)(26005)(66476007)(2906002)(76116006)(55016002)(5660300002)(9686003)(66556008)(7696005)(33656002)(8676002)(52536014)(6506007)(83380400001)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YlZjxmb4AHsRjb9DSH4djF1a7h+zlnjOY4fmr3ZkDdwfMdb+xPRoL5bk7CbU?=
 =?us-ascii?Q?X4/BXzwH33bvm5eGnkhfMXXsXTZ2q3HeAQWu1X7Id2qDxYaKWmWm81sUkUmZ?=
 =?us-ascii?Q?4F6psxhbrTSPwXZYsnAOj6rgNBgKdimXrtDfDOi8XTE9m88dAlBcvIOsws2p?=
 =?us-ascii?Q?kbq5FPljPbVjt6tOnOIfA58obev2wYRcIHjio60ZumYTx4ZPQAmg74qUl43F?=
 =?us-ascii?Q?LlucpjUC8snTxzmkph3XA796X3xdf4mZLYifR016dYD0En/dzYp6Svc/G9S+?=
 =?us-ascii?Q?KVWxjlsOYavSOkyGskl7051uf/Ns1C9Rp+RXk9itGI86MJkLHfeFbszG0ftp?=
 =?us-ascii?Q?tw5+mB9OH2BzGIXoI7qm7ZbybLHa+E8YyCtqwWs1C6rkHCYnpdt6NwPq86Ka?=
 =?us-ascii?Q?y8qUW/sRvYuz5Jlnhmtqts8L516cMtj5tjHXtvSWapMxbOHz5sIQLWWEuXIu?=
 =?us-ascii?Q?rSXqyGb6z7k17rAakesipnF6+Ie+2ebOjF+o9pOZCOVn7kjgattzbfbToJT5?=
 =?us-ascii?Q?URlx6l3HhWikRcOImLDCtJIeSHTifTj7xufwwDFuXVD4j59ANkeYZ1479bB0?=
 =?us-ascii?Q?QVkhKxI/uIc3g10uVunlKKcwrwKlttOLz2mpLDU0ohQoQuOJlxyHenJPIDuC?=
 =?us-ascii?Q?0dtGMvRQNwFGzxAAd1MjyW0eJKGTLf/SlAktlCJiLzB4rGh4lJED22Npc7bF?=
 =?us-ascii?Q?PTrmHuI5jWnA6dAx2zzXNNvfiX3/Jh/aoFGq+XD4N1u6ifM9k6YpV15eHbz9?=
 =?us-ascii?Q?0a7CfaQtfw8L+TUwWD7cX0QyOoeJuBPFMrf9jghWkoMn6Y91II7oNZMvaWPk?=
 =?us-ascii?Q?tstbidpviNPfQHXGdgKSOrgK27GH9QWTVGR8d6sLn2VqDzMuuxIdRi+bjysv?=
 =?us-ascii?Q?rFYY6tNrCnfnPAgjGM8OHJOViGkkjEI+jwoBoqnqr59NkQ7kQterkrJNpuMS?=
 =?us-ascii?Q?/thFWlXUocGxVYNSYpcuWMeM44/04AHMFQs8tJzNdBCcB0knBc81fNMCNi93?=
 =?us-ascii?Q?+xPSy0r4z8RtAZmsaQThX9MYpx727ZGK827ooZTLpAUA70t+qGOjDmPiqG6C?=
 =?us-ascii?Q?VSycQwftsTY7LmSbsRqhBdfw0c10F4HB/qAQufcwoNosaAE/FPtis6c3x8rB?=
 =?us-ascii?Q?+aoVSHKgIL+26h502pjNoryRrxWJJa12L0Fs/KkBAw0eCu3dPMnv16/rdWJw?=
 =?us-ascii?Q?hF98voUTu9kLe9KOd8oIaT1N9dXi3F5+7gGs2RttOlFIu2nNKaSio2PwjybN?=
 =?us-ascii?Q?rEAo3t1Sh+NgFWdDULDKBQOrwiEx//Ql/yWZ0Lfxbf6M3SkYI9Ljx2+faEf9?=
 =?us-ascii?Q?t1RKb/CztYK5tTmoZ+ibkkJC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e3f0bb-74d6-45b8-8eb3-08d8d7bc0717
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 05:29:44.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7cjLX78vCtNY7ljfDiP2xXV6sqogf4cQOPV4JvD8doH6IBzR8S/O1oMevFhSiOXWdmgRvi/wu/Y4cHjhAULkRis+jZZN5CsQCJrQYksckMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4037
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/22/21 19:35, Dave Chinner wrote:=0A=
> From: Dave Chinner <dchinner@redhat.com>=0A=
>=0A=
> The new checkpoint caceh flush mechanism requires us to issue an=0A=
> unconditional cache flush before we start a new checkpoint. We don't=0A=
> want to block for this if we can help it, and we have a fair chunk=0A=
> of CPU work to do between starting the checkpoint and issuing the=0A=
> first journal IO.=0A=
>=0A=
> Hence it makes sense to amortise the latency cost of the cache flush=0A=
> by issuing it asynchronously and then waiting for it only when we=0A=
> need to issue the first IO in the transaction.=0A=
>=0A=
> TO do this, we need async cache flush primitives to submit the cache=0A=
> flush bio and to wait on it. THe block layer has no such primitives=0A=
> for filesystems, so roll our own for the moment.=0A=
>=0A=
> Signed-off-by: Dave Chinner <dchinner@redhat.com>=0A=
> ---=0A=
>  fs/xfs/xfs_bio_io.c | 30 ++++++++++++++++++++++++++++++=0A=
>  fs/xfs/xfs_linux.h  |  1 +=0A=
>  2 files changed, 31 insertions(+)=0A=
>=0A=
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c=0A=
> index 5abf653a45d4..d55420bc72b5 100644=0A=
> --- a/fs/xfs/xfs_bio_io.c=0A=
> +++ b/fs/xfs/xfs_bio_io.c=0A=
> @@ -67,3 +67,33 @@ xfs_flush_bdev(=0A=
>  	blkdev_issue_flush(bdev, GFP_NOFS);=0A=
>  }=0A=
>  =0A=
> +void=0A=
> +xfs_flush_bdev_async_endio(=0A=
> +	struct bio	*bio)=0A=
> +{=0A=
> +	if (bio->bi_private)=0A=
> +		complete(bio->bi_private);=0A=
> +	bio_put(bio);=0A=
> +}=0A=
> +=0A=
> +/*=0A=
> + * Submit a request for an async cache flush to run. If the caller needs=
 to wait=0A=
> + * for the flush completion at a later point in time, they must supply a=
=0A=
> + * valid completion. This will be signalled when the flush completes.=0A=
> + * The caller never sees the bio that is issued here.=0A=
> + */=0A=
> +void=0A=
> +xfs_flush_bdev_async(=0A=
> +	struct block_device	*bdev,=0A=
> +	struct completion	*done)=0A=
> +{=0A=
> +	struct bio *bio;=0A=
> +=0A=
> +	bio =3D bio_alloc(GFP_NOFS, 0);=0A=
> +	bio_set_dev(bio, bdev);=0A=
> +	bio->bi_opf =3D REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;=0A=
> +	bio->bi_private =3D done;=0A=
> +        bio->bi_end_io =3D xfs_flush_bdev_async_endio;=0A=
> +=0A=
nit: need to align above line with the rest of the code ? can be done at=0A=
the time of applying the patch.=0A=
> +	submit_bio(bio);=0A=
> +}=0A=
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h=0A=
> index e94a2aeefee8..293ff2355e80 100644=0A=
> --- a/fs/xfs/xfs_linux.h=0A=
> +++ b/fs/xfs/xfs_linux.h=0A=
> @@ -197,6 +197,7 @@ static inline uint64_t howmany_64(uint64_t x, uint32_=
t y)=0A=
>  int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int=
 count,=0A=
>  		char *data, unsigned int op);=0A=
>  void xfs_flush_bdev(struct block_device *bdev);=0A=
> +void xfs_flush_bdev_async(struct block_device *bdev, struct completion *=
done);=0A=
>  =0A=
>  #define ASSERT_ALWAYS(expr)	\=0A=
>  	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
