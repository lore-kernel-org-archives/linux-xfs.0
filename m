Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EF1C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 09:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD583207ED
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 09:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hdfn9LG9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Gh7SEbvL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgETJnp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 05:43:45 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:16402 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETJno (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 05:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589967824; x=1621503824;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=6Zr6LHn/2Bgj8euW2+/JxcYGukwQMwTuF2aGmVz2fm0=;
  b=hdfn9LG9jME4e08M3a+OxlYwAEjpfFcT18iUCn3Nghtp6f/uoO07VIp8
   HcFM6xP/EIAD8Z6reRQfRC3RGuEQ1pNL6935OE3p4Z3UErRt1tDC6DS/t
   FcJNEq1z916Xw26JK6zYgjGrfuvzNB9kTlfnZLC+8sMz3oxjBp1nVEyro
   EXnGIiQ7qfub04Kj6Lgjdqdo9IR4x23fnIboChK/yq+JGETMDUsPaKrmI
   tAD5aJR2T/ppcH15ng7/RMV/zLhS//789QEPx459X7EAxmYKCvjVyho/S
   u8cfBerSWpH6KXXpn7ZDE7ZnywhYXvZ27lPokr4dhsZj84xvILwwDDRF3
   g==;
IronPort-SDR: L0uVF+wBgD9LS1oNoHXgg6lIOlOcoEEzmxRW49E9I8tnZJw+yeJ/LoAcrm1hdFCCQBiweOBLOT
 kUEY/ce9U544zj1+74v2wl6bgVnZOZZAz9nZvA4dnHiBM2qcP6CXBgWdfp2N1hpGF1UTs78wJO
 LTZZegltzuhJiEzqQO09XdmMdZrpw9zmcgDJMXaf6++WQttyHYeoQJXpcsYelFXMpapaWrQElm
 lMVUtszb8tAlzqSA1a7eMc1u+erMyNMa8/21I2RhvYTWanvCCASrSWv5+oMdQYQUj1TVs0OrUR
 5CA=
X-IronPort-AV: E=Sophos;i="5.73,413,1583164800"; 
   d="scan'208";a="142451120"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 20 May 2020 17:43:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdHObCrip/8GbcEkGidbJgb//1wq2nG3dq67jPfA+qHxuWI1QEAR8nclPZs/7L0eHodxNLHkv84a8CJgzTga3KnGRMFqYZpb5LAYS3d938f2+7RkB8TiBQM8r1kkQmvL3yS03utp5tPxiV6gK6UDIgxm8E3EgvkTviS+ltQiV7VrVf6qZtu759ekeBtl08Ra4kCi25Qi6dxfyx1esR3yS6WAegQxd+UgyeIChfGQKGlS1zoarjmHT8Fgt37O90o9r8YGsEkV1EC10tuJmKFgQZq4/EcjTY8LrThStrsG5j+HG5EB7CQn+QpRc/ejumwIOkn6cldSr+Zl5/k+Env+zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSyiLBTHiJVp1cZ02tJM0cBPrNKv5tA9tQY9Pgwumqc=;
 b=dyCnd56jik5999C63pTqOJ8pwvxnJOksYmFw6kM6KT4L5D3bOAYTegbBsRwr+Vb9Yj0Ocyxh6AuTdxFscUm7/96mKqdwLQLpeeFPFR3WDhYKOiA81BnTaKUundkIwCVo/TEO2A0k/oYqYT4215AWcvENBo4OzGSjlU3FKG30FgwdJyqpcJdLXD1N7BJlxaFa1kOLSZzKJJqN9YGpnCzjO1I8NMgmJF/MfAXZL6zcxHIlOijTXIGk75njvqMq/ob+0aCJoo5H9qVUbOXZOcLayEV23h7FEvmzy7BuzAaenmC/IL9OkdUD7L6xkZWLj70Go6RxpXyY+UrSmDDwofWVVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSyiLBTHiJVp1cZ02tJM0cBPrNKv5tA9tQY9Pgwumqc=;
 b=Gh7SEbvLtWoBLJ2P2oMiVV8sn9xHBGSGN3C9HMjxTzryv9XbK+CTEvyixoLe85F/nSdIG9hBhP4NBFp0MSyhHgwzbbqxFL4V6Je7QAeo8zenCCurQ+nupdPpVL112NuxGSh4QQ6urUHvYItaErYjxVsDt/5T1EzFnhHBYHZ6N/Q=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5639.namprd04.prod.outlook.com (2603:10b6:a03:107::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 20 May
 2020 09:43:42 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6%7]) with mapi id 15.20.3021.020; Wed, 20 May 2020
 09:43:42 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: separate read-only variables in struct xfs_mount
Thread-Topic: [PATCH 1/2] xfs: separate read-only variables in struct
 xfs_mount
Thread-Index: AQHWLiwfbYYCB69ljUCs0Gc+u3WXFw==
Date:   Wed, 20 May 2020 09:43:42 +0000
Message-ID: <BYAPR04MB49650763C4CD6339647F838986B60@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200519222310.2576434-1-david@fromorbit.com>
 <20200519222310.2576434-2-david@fromorbit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fromorbit.com; dkim=none (message not signed)
 header.d=none;fromorbit.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 55f67acf-355f-455b-01b6-08d7fca24829
x-ms-traffictypediagnostic: BYAPR04MB5639:
x-microsoft-antispam-prvs: <BYAPR04MB56399822D8E799543AD924BB86B60@BYAPR04MB5639.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 04097B7F7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r4gX4m4a3PBIeO62CksDbfFW5mQLUAb5JVujwNmprJPC6IFkoKAbbHYD84xT9oOunSQmAqMjT8lGktbZ+ycYQ25JDtf/wXFGj462zX6dF2+bQ+SosU2DJ1Sy+mv4yBcRGyl/g6Q+GbQ5c4JAJetf+6I+f0Q3Y/q1zzan7vaCz4dT+XZSlDtiJiuznnPVe3O/ccENNkHbKsjwqgP+pc8KXDew+z8bBOBYJ5GQDLBFORu0YyN2xFHSpK/UZ2ymr1O2MiSMs3EQ5pRw4tQc+4Y/tNRuJbqcIKb+rr3Kl4WWKBAH3VInXNLPpk3LCp3ZgmjPjnc1uGrhPfSb8QWSygH9Vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(26005)(8936002)(71200400001)(5660300002)(8676002)(86362001)(110136005)(478600001)(64756008)(66446008)(76116006)(66476007)(66556008)(66946007)(33656002)(316002)(52536014)(7696005)(53546011)(2906002)(9686003)(186003)(6506007)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: IURR0JXTaHbldAzmhXciiPHBvting/FvLCqhPEkJt3doD6zNdKK8YDthxA7gY3Qi4/dxLG/R3QDZV+/szwSAPH/R8P/rMxRnGrVIKvEvAJXJxl3D9S76r5KzMvdoymUPdGxqhFa8uaAZhvEyYwKywWcPEHQKhsYCf8w69EwwLWOSbSuml5V3ZJqQ73fVccpkuaPt+3lXsFGqiM79OJpv0Nk+PX3G4JNVYCWWzBbk46PXzdUYqxZGzzkexYF9MsATN6BlrQsr8HIQ68eAF95dFJffKfhhVZKA0P+lRp/kIvGbECPQnId5nNKm2fdl3jbr3aRyW5gWwtR1BrAmU3rvb5c1h9+6GkEAmzGQjJ+WmoYMgS0RP4kCs2ZELoLcF/U1Y0ITW6xdT/U7bSDONCs6b3IgRt8RIiWEmpLBP91c+JucYxstMP70gT0CfKpnrwMf4IZ8rIpBvh8nnrliQ5kvvM/bauGIUGtPROv1umk7i3F4pfJRVCs9SVmTiyDQZ4uH
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f67acf-355f-455b-01b6-08d7fca24829
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2020 09:43:42.0613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pcTUBLGKf1PcGxL1Q93EESj9ntIo4FE4KLGawNA6OnprQ1QY6vXg7z2RR0BTkSYwOwCbTsWbv+tLwvsmBuBGi+ES9tN+sJWcrSC1v7/GGvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5639
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/19/20 3:23 PM, Dave Chinner wrote:=0A=
> From: Dave Chinner<dchinner@redhat.com>=0A=
> =0A=
> Seeing massive cpu usage from xfs_agino_range() on one machine;=0A=
> instruction level profiles look similar to another machine running=0A=
> the same workload, only one machien is consuming 10x as much CPU as=0A=
's/machien/machine/', can be done at the time of applying patch.=0A=
> the other and going much slower. The only real difference between=0A=
> the two machines is core count per socket. Both are running=0A=
> identical 16p/16GB virtual machine configurations=0A=
> =0A=
> Machine A:=0A=
> =0A=
>    25.83%  [k] xfs_agino_range=0A=
>    12.68%  [k] __xfs_dir3_data_check=0A=
>     6.95%  [k] xfs_verify_ino=0A=
>     6.78%  [k] xfs_dir2_data_entry_tag_p=0A=
>     3.56%  [k] xfs_buf_find=0A=
>     2.31%  [k] xfs_verify_dir_ino=0A=
>     2.02%  [k] xfs_dabuf_map.constprop.0=0A=
>     1.65%  [k] xfs_ag_block_count=0A=
> =0A=
> And takes around 13 minutes to remove 50 million inodes.=0A=
> =0A=
> Machine B:=0A=
> =0A=
>    13.90%  [k] __pv_queued_spin_lock_slowpath=0A=
>     3.76%  [k] do_raw_spin_lock=0A=
>     2.83%  [k] xfs_dir3_leaf_check_int=0A=
>     2.75%  [k] xfs_agino_range=0A=
>     2.51%  [k] __raw_callee_save___pv_queued_spin_unlock=0A=
>     2.18%  [k] __xfs_dir3_data_check=0A=
>     2.02%  [k] xfs_log_commit_cil=0A=
> =0A=
> And takes around 5m30s to remove 50 million inodes.=0A=
> =0A=
> Suspect is cacheline contention on m_sectbb_log which is used in one=0A=
> of the macros in xfs_agino_range. This is a read-only variable but=0A=
> shares a cacheline with m_active_trans which is a global atomic that=0A=
> gets bounced all around the machine.=0A=
> =0A=
> The workload is trying to run hundreds of thousands of transactions=0A=
> per second and hence cacheline contention will be occuring on this=0A=
's/occuring/occurring/', can be done at the time of applying patch.=0A=
> atomic counter. Hence xfs_agino_range() is likely just be an=0A=
> innocent bystander as the cache coherency protocol fights over the=0A=
> cacheline between CPU cores and sockets.=0A=
> =0A=
> On machine A, this rearrangement of the struct xfs_mount=0A=
> results in the profile changing to:=0A=
> =0A=
>     9.77%  [kernel]  [k] xfs_agino_range=0A=
>     6.27%  [kernel]  [k] __xfs_dir3_data_check=0A=
>     5.31%  [kernel]  [k] __pv_queued_spin_lock_slowpath=0A=
>     4.54%  [kernel]  [k] xfs_buf_find=0A=
>     3.79%  [kernel]  [k] do_raw_spin_lock=0A=
>     3.39%  [kernel]  [k] xfs_verify_ino=0A=
>     2.73%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock=0A=
> =0A=
> Vastly less CPU usage in xfs_agino_range(), but still 3x the amount=0A=
> of machine B and still runs substantially slower than it should.=0A=
> =0A=
> Current rm -rf of 50 million files:=0A=
> =0A=
> 		vanilla		patched=0A=
> machine A	13m20s		6m42s=0A=
> machine B	5m30s		5m02s=0A=
> =0A=
> It's an improvement, hence indicating that separation and further=0A=
> optimisation of read-only global filesystem data is worthwhile, but=0A=
> it clearly isn't the underlying issue causing this specific=0A=
> performance degradation.=0A=
> =0A=
> Signed-off-by: Dave Chinner<dchinner@redhat.com>=0A=
> ---=0A=
=0A=
