Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E00C3F6B0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Aug 2022 05:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiHHFc5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Aug 2022 01:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbiHHFc4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Aug 2022 01:32:56 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5510EB1E1;
        Sun,  7 Aug 2022 22:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659936774; x=1691472774;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tP/rvZaECXr8GWakpDPlEQI8ailN+CeUoyf6Wrxgnck=;
  b=X++tcFp/WU6Ge8UaXNmdAFQP370O/XRY4rPozpIkOUQGzrEXPRCaCZ6/
   E2HA0iBQqFJh1qOw/11WPt6q4cjTwYYdUle4slAdctDx1re5UZtcLzuOM
   X058QFHLXaZXqIfwbgsOwQToMVaULQTbpCSNBg0/p/qsVqz3MfboORPDe
   08PKi6uV8BGYtsmQclD31nH4DkhpA6YjPy6f6U5fXflqZYZNkj6uxvfbw
   RToFPTfcYQX8up6sJPYEH8cwxNZ/+8cFEPAny6yDYYddt7jnMscXZFuoi
   ny9wTsWgtmIwEGkSX6Y3BkagBBgvzs/+u+KxU5OqJ745PqpoWVuipZ2y3
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="213099847"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 13:32:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHgv62sNrnUgayN0bOBgrPtacmoDQFEKlrywonjYFSMBHy7ZgXPmoNIysMgiyJbbAIPWVI0mcNwzkBwt/jGLz81F9+RD6rzegMtd3iwSm7MvqUZRwh/gadOeyByFQoBYaD+/meXmMJv2LFxPlwbew8T8UjzjRHMLY5XOzP6AFx597h8cX7iRcYr6iwLPTw8xlCyNCbtN1t/GiVQ2/1G7bUgI9OXJWz2BbbE3TLWqTYMuZn2DKCRxZNjZZE+VuVrjlMWfOdPG10XZ0Y1Bbatnv61HQA9SVDfkCNhlpTaq+okLlNmMprxpEIfmRWzrY9arDoeuUHXgxgkBCFxC/wH6lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WefShYaqPV9/BLl9tU5ONJPJd/tE2kb/h6oToIShP10=;
 b=mGyh/KKF5pgdedlCSmEwUrExf5U+r++ZEcCVxi2S2X10N28hiekwUb7KLQtjWxNU83Hcb10Qqdrx88fLvKmKrkI/yrpsoQP9K7s8f8BJU7jpyAX/YzKhIFsWtxy8uWz9tmHzNuMYhK82c3BsNZoRie4XeW2TsXlLtUErdpP1ZldsvbvQ+QtfJrU1k8ZxJPFdoErpW5YfPFI6tdj89tgG2eyihPL2JA7r2kgAyD9MVDEtt/lnez19opOkmJgY46RtYrOq0v+nYUSplMiyc+7JGlFQYKBMwSDtdK9r6gKbjb7Tgxk+vhLhBWxzo/3BY5ielUHMnoNbrckftIExQWuZaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WefShYaqPV9/BLl9tU5ONJPJd/tE2kb/h6oToIShP10=;
 b=eUqcd5HiQFQCBHFy1moTVF7l63H/jhOkxKKM17Ttr6xJvJP1tZ9gntTsxGXKp/7DvwBe2ijGns+SW5iOqCs9yGsGZ9LU/uS56/lNCuLh+Zmc4bPRVWrsUya0aX4aiP3HxSM+DdbQIEEXZ592UCXOSnFTVsL5dvXK/0AWlkCJXlU=
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com (2603:10b6:a03:300::11)
 by MN2PR04MB6477.namprd04.prod.outlook.com (2603:10b6:208:1aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Mon, 8 Aug
 2022 05:32:52 +0000
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com
 ([fe80::9865:ab44:68b:5d5e]) by SJ0PR04MB7776.namprd04.prod.outlook.com
 ([fe80::9865:ab44:68b:5d5e%6]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 05:32:52 +0000
From:   Naohiro Aota <Naohiro.Aota@wdc.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "zlang@redhat.com" <zlang@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>, "tytso@mit.edu" <tytso@mit.edu>,
        "leah.rumancik@gmail.com" <leah.rumancik@gmail.com>
Subject: Re: [PATCH 1/2] common/rc: wait for udev before creating dm targets
Thread-Topic: [PATCH 1/2] common/rc: wait for udev before creating dm targets
Thread-Index: AQHYoSjCDIR96LCV/EaJzSEjStsNSq2kjkcA
Date:   Mon, 8 Aug 2022 05:32:51 +0000
Message-ID: <20220808053250.3wl2ka4gtvc5j2np@naota-xeon>
References: <165886491119.1585061.14285332087646848837.stgit@magnolia>
 <165886491692.1585061.2529733779998396096.stgit@magnolia>
In-Reply-To: <165886491692.1585061.2529733779998396096.stgit@magnolia>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6ef2d93-bc28-4472-71da-08da78ff7031
x-ms-traffictypediagnostic: MN2PR04MB6477:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PTLloFJk+HNiKy9QY0h6pDWcZKIrTFUUramzgr4ZS3PJVimVsaw4Nimzqw1BjqCgtgGfAnvjBGuMeQ8Sbnqdh7up7Tfncl1mwYJfZFDdAKiOjbiVN9b5PrR6KXA61jk/pDwkOlNwUvAoBmnn1a4rrZPFlbOhW5vm9OYGX1CRsfZdMatiHZxkNcM8hDPBMhqRJY37za8T+G6UgV42RBLj5Hlg6+W0Jg7HsKsLDZ2TBIPysc4evJHDa1mXWxKSAzsvHSLMJvuYBPsTDIV+3nCdxXaS2IHCH8QXMoJ/rCgD+ZddcT+nLwLUA5CEYNvxMuqyFrObpAr2CK46wHJXmqXsoAWrOuufxVutbhfGz3ZGDXeKOT7XyfbrU0U2+vm8VWHVR1gLF5SCvgoHnAQNFvJBTq0uN4+UctKWQ3uGYjg9rGwFrVEnbHffzi55knTZZZRKPS0DuslAz1ySjJTZv8f5yUsh7JgMIoCcYgMAm2xkEI5EfKehclfskFCziWOROP9O0v0YjbyTX5PEfDnop1RzpnxhZ31wjo+MYMkNfDhm6Yzc79PWZrAKxGxpwyHKOQrA0hWxIzsrkxYZwcWoTd6KkDvGxIDa7dTJj4HCaqlaez1YcSajMGvAF+LpMrgiSbVbOBU6wsAw7gtOiMZC1/EauOjjbFOgKNo5SEyU9USENk0mxn1qaKjm+3sN3E8DN4noaBgfXu3ggR3AJHjTv/TGhU0D5e+3ElKnzHGSEimxX5/UNvHAmY/d9v4PjAX0oPq4z7igSrQHH6mpg6SBbS3WEvi+gwRW7lhTwWuRf3qXgN2V/KvWVEutUHGgSjT+zQf0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7776.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(26005)(6506007)(82960400001)(6916009)(54906003)(1076003)(64756008)(186003)(122000001)(9686003)(6512007)(8676002)(4326008)(8936002)(38100700002)(86362001)(66446008)(66476007)(91956017)(66556008)(83380400001)(76116006)(38070700005)(2906002)(41300700001)(6486002)(478600001)(33716001)(5660300002)(71200400001)(66946007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c3RkSw0PHriR4ipfJiig/6eebjJq881Q2LHoWvxGH8zUscURE0jUwn/N7sxP?=
 =?us-ascii?Q?LCrjTMC5UzDVvTEvZyNKZf1HPD0b3heSq2O051D3+Wso9phDGkpxHdgUbXLL?=
 =?us-ascii?Q?mUyeuwytKLuv694y07j4Mry0hluJ7HPlMfIFjNVP32EsDf1EA0DmTO355fJE?=
 =?us-ascii?Q?xg4zCaIW5odOOjkPVqP7da5oRukQTApLF4Lh9pIOJL0c7ByE0AwiABsfjy/C?=
 =?us-ascii?Q?ieCCj7y2gF6NrhfWg5c9zZP6UswPkn1Etv5sOT+6Na1DBRK9PAnhy6odrYD7?=
 =?us-ascii?Q?p5bgMo6/cm5Lc6nhZ/d5eli9RRCyDtrSHQ7ram4+GcgDs6ZijFg9XpuWt8NK?=
 =?us-ascii?Q?s8EbPW+I+CPRXjxyAXvF2G1GhBAs34J4R+JDTtAHe4WMsv0HEBvyhDFImiEk?=
 =?us-ascii?Q?IUpPyzTd1i6yNgdpK0T+s2guH3vOQZuO07j2/MriEdpHVBTzIvILhObU0Ht9?=
 =?us-ascii?Q?eQkhycUxrbkHZclRCZ/2fDRxsR/E+V+wZfvaCj8NzLO93OFsUG5rBrt3EY3z?=
 =?us-ascii?Q?wXnMkYodtz+1xoomGULVkgBAVsu+i0gngOfzPm9dHzne7su831JHfUCix6eP?=
 =?us-ascii?Q?l5GKjzj76gHMYXoBcDPjEmUhnteFsU5vBpiMD2N+4meWKa6/pZlSSGvI3QXA?=
 =?us-ascii?Q?lJhUcaD92YmlWeeVlEgjOl7mx2lnD/sscTZyyzu5ilYwKbEQ+eA7Qx5ccIr5?=
 =?us-ascii?Q?hJ+QnB0rk2fUD4XtAGhpKai1wFapWi5TKirpTMCtQe9ngLTeH3rLDGonOuNr?=
 =?us-ascii?Q?74uxJGcxbrGTL+HoI1Lg0EqBYeJDccj4fCbP+b2RzacYtQcablvTWkKyqLom?=
 =?us-ascii?Q?b3rxUcTmcOduEk6uCe0Go0XtkNRlrPu8Tp8SDgBta25MU7px1jdzssNJ6IkV?=
 =?us-ascii?Q?Fuu8IHTfdY39PZaVriVsCvs+gVXlSSCcKQp6FuIi2QZmEfAT4dcA65UaEhsv?=
 =?us-ascii?Q?PWGQdTdvORhz1glrnp0ja5cC1preEi6NXibJ9aGIrTAcsd7lgsrukGG905WL?=
 =?us-ascii?Q?9s/IV6A4fXUlJZ0qRqltIsYmnu8zhADJN5JNH+m/qa/ktPdX5xidA/Z78eM5?=
 =?us-ascii?Q?63EiTcv/yNE+u5BeJrhUlWqzUqQelF7964z3nSqaupMA4KRxtKNkVqGFLbAs?=
 =?us-ascii?Q?ZoiFPCcf1QHFn2oj6FG+1dBxjXwHfCCczIW9B36ic0WMBOVCCoqec3vhYEhx?=
 =?us-ascii?Q?BhDrFgkqkPaaIR7E4BFW2LvP4JPnif9fwDx9a8sIOMrUojybPPg1WMuiNFB4?=
 =?us-ascii?Q?td1tYNpiejaJ0cP0bFCjZco1+97GBx3No7G3fv1+/0eWYSZab8NvsyKHrWjr?=
 =?us-ascii?Q?A0v1m58A7gYxLvgR1zEd/ZalFGSnMoioGlmbuE0cVJPfB6+4X7p868z0g2n9?=
 =?us-ascii?Q?SsG1XH8yQDRDSMr1gMV/VeAwhW21gSQ8ODQPym757BmKs5Tdvv2hCuZusKsD?=
 =?us-ascii?Q?OhCYUUSEzvXhdzECoqU7wMUrCX8WgITmtN+iHLYCvEeWXnPW76Yyv/o59yNj?=
 =?us-ascii?Q?izewmzQtbLh5K6rUwL+81d41iOpC3T+biUdWJ650L4BHvyIPV+ni4nLFinXc?=
 =?us-ascii?Q?8j+bRXhtS3cufxoc1HZl14b4dDiR+0DokqvOoE05R34RfWxlL0JEDBNpKssy?=
 =?us-ascii?Q?Cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6620D72CC4B45A4B9F95593AEA0AA91F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7776.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ef2d93-bc28-4472-71da-08da78ff7031
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 05:32:52.0316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OA2+jq7aqoJlF2oDYUk1IAyDdV0nS7n9PZnJt917Z1u7GvJCWMiD9ZubdQu5fzDKL2p8blodVGCEUzC6jptxgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6477
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 26, 2022 at 12:48:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>=20
> Every now and then I see a failure when running generic/322 on btrfs:
>=20
> QA output created by 322
> failed to create flakey device
>=20
> Looking in the 322.full file, I see:
>=20
> device-mapper: reload ioctl on flakey-test (253:0) failed: Device or reso=
urce busy
> Command failed.
>=20
> And looking in dmesg, I see:
>=20
> device-mapper: table: 8:3: linear: Device lookup failed (-16)
> device-mapper: ioctl: error adding target to table
>=20
> /dev/block/8:3 corresponds to the SCRATCH_DEV on this system.  Given the
> failures in 322.out, I think this is caused by generic/322 calling
> _init_flakey -> _dmsetup_create -> $DMSETUP_PROG create being unable to
> open SCRATCH_DEV exclusively.  Add a call to $UDEV_SETTLE_PROG prior to
> the creation of the target to try to calm the system down sufficiently
> that the test can proceed.
>=20
> Note that I don't have any hard evidence that it's udev at fault here --
> the few times I've caught this thing, udev *has* been active spraying
> error messages for nonexistent sysfs paths to journald and adding a
> 'udevadm settle' seems to fix it... but that's still only
> circumstantial.  Regardless, it seems to have fixed the test failure.

FYI, I often had a similar issue while I'm testing btrfs on zoned devices.

I used the following bpftrace to confirm udev is competing with dmsetup
when it failed.

$ sudo bpftrace -e 'kfunc:bd_prepare_to_claim { printf("%s %x %x\n", comm, =
args->bdev->bd_dev, args->holder)}'
...
mkfs.btrfs fd00000 b103b640
systemd-udevd fd00000 b103b640
systemd-udevd fd00000 b103b640
dmsetup fd00000 b06fb655 =20

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/rc |    5 +++++
>  1 file changed, 5 insertions(+)
>=20
>=20
> diff --git a/common/rc b/common/rc
> index f4469464..60a9bacd 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4815,6 +4815,11 @@ _dmsetup_remove()
> =20
>  _dmsetup_create()
>  {
> +	# Wait for udev to settle so that the dm creation doesn't fail because
> +	# some udev subprogram opened one of the block devices mentioned in the
> +	# table string w/ O_EXCL.  Do it again at the end so that an immediate
> +	# device open won't also fail.
> +	$UDEV_SETTLE_PROG >/dev/null 2>&1
>  	$DMSETUP_PROG create "$@" >>$seqres.full 2>&1 || return 1
>  	$DMSETUP_PROG mknodes >/dev/null 2>&1
>  	$UDEV_SETTLE_PROG >/dev/null 2>&1
> =
