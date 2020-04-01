Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2AEC43331
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 05:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 962532077D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 05:16:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iEffmn4A";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SXVfDrOy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbgDAFQB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 01:16:01 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:52528 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbgDAFQB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 01:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585718161; x=1617254161;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=OO3c2kXB2ruE2a/fWBYZ9mfzO+qVYdH7f9jg2qOPvVM=;
  b=iEffmn4A5t4Oe+ZSqeyAs25ebGOeKZ/2nohGI+AYUpEWHBrVrEwMZR30
   m2e4vjJRVFEXFzsjcbbQMx/zun1SCPoMo8T1NeFREXRp4BN2QsrqOP/oH
   KUIEFgYjz/0EOamSPNLW2LPyhhkOBXnbRYgXPhGv9epjpx9PMOvnVEbEk
   YrJSregf4I0vHcC4t81KxPWQoyVxRoV9C/BfCg0zqoe+csoPkq7Dn+kFx
   +Hlw2+szt7WdHqOQZs+YUwAElACuyAZtabLBXqBeIU0WanCi1cU3U5vAQ
   LQs/p83CHyriuDz/jT0LGIOFgYHUblVbOD8MuKOfdtW5nlWAhzg5qvOxx
   A==;
IronPort-SDR: gqQdd/dDHFjEJORdH2V3EMf1U4jajC2BoYLgQxiHB+3qLRkVV441QCPBVOuLIX7e1B9lIizZ3d
 Hqud666O05HT5ZK8HkzVzFd9JiqvxVDNeZl9Te7maZ1pBrwryY8a4FpALh+Ev5CGdUSicRxlJz
 gHDiXdZL1rSblU30SzKurrTSHltzCWle7zyJCaL2Nc0uS7F8XiREapTuEpBBGZz8LvhWD9MnPv
 BAaeUWMbaFSmjBHvabnc653fRryn6WSjumfOx0kEyMZqRCM8Smt8dU8fpCzCp6V5IFRw6mvWrW
 NZU=
X-IronPort-AV: E=Sophos;i="5.72,330,1580745600"; 
   d="scan'208";a="135663927"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2020 13:15:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQMT7eQu8x9D7tq6qBByAnQ2KGwntSBenJohOvuNmlLKlba8sYj8G3Tuoz8CYyfWckmyE0ehJqxdXT35EtbqXmPd9UguUFU78xzh3zFW6zHmTJRLdIxrl0PjFvih352sETi/NIJpWmo42sePa4FpncrQYic10v2kdu4Ieo67JaIOUPgf/sDQ4olJKQ7OZRwtDlYajyIWyT45ZkfuNzF0OUlGLPKQ78e6GIIQrT85wJsKeBEydviQj9A5wzNRuyDPtFKSwTWYXr6WQ0Gu4OKvu0I4kzl6RVTMqJ9S1xTB/cxmw15H0YWN+auecUvXKbLACbh9wERvF0934P8X6SCtBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaAzFEcMqZxZOdoN+/YLUH6kFKwgE8hClQsLjMNmUmQ=;
 b=loNfa9Hyzm/1dcdo3sOKCsAfo2qeV3VeSTdYFOedVntgfn3LHBviUGzvKBjT7J0GGnPKmOZBtnLCQvI45kTaUKGszxF+i88pGw8xqErIf9kBAh1OkvCvIEwxtW7tooczoGV5NeOAmlUWg4SO6C+jkZVPtNzSVq4pJjvn3fQ5rTwsbisPBGvOpkgsuE1giRrJPegvDe9R8A7T2zlNU4afaZpjitcGL1AFoOpgNURH3pjshJTRdfVQntE7aq3P7I2YgEZNyBtYYTQ/9rt3AwV9HlE18mkA8r4C10b8lnoA29DSoR5KMekZpCMLOy5OhSFCYsGdz07lqpxFFXTXpeTLeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaAzFEcMqZxZOdoN+/YLUH6kFKwgE8hClQsLjMNmUmQ=;
 b=SXVfDrOy8WCLVRKWhrvv68EkvH+wye34NHwmcUGJMhG57CrNA+rYaAnXEx6qORQmXZ3UZ3YXTujJBYVx0wqlGrpbN+ANZMVPmpc+WRzl/WijXAxzGZTMQRUlHKOVqG85PZntW8CeG8/1a5erNDppTOufqaAZaPs5NRGGtkIzcgE=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5862.namprd04.prod.outlook.com (2603:10b6:a03:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 05:15:57 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 05:15:57 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "xiakaixu1987@gmail.com" <xiakaixu1987@gmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2] xfs: trace quota allocations for all quota types
Thread-Topic: [PATCH v2] xfs: trace quota allocations for all quota types
Thread-Index: AQHWB9ZK8fwSk1sS6EK/NFlSPXNyaw==
Date:   Wed, 1 Apr 2020 05:15:57 +0000
Message-ID: <BYAPR04MB4965E5D045578A08EF64E5EC86C90@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <1585711991-26411-1-git-send-email-kaixuxia@tencent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [2605:e000:3e40:3000:2c9f:112f:76b7:3770]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 986f64ae-7caf-4ec7-706c-08d7d5fbc2b3
x-ms-traffictypediagnostic: BYAPR04MB5862:
x-microsoft-antispam-prvs: <BYAPR04MB5862FC5CBF44C0D37AA8E9DD86C90@BYAPR04MB5862.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(186003)(81166006)(4326008)(8676002)(81156014)(86362001)(55016002)(5660300002)(110136005)(66446008)(316002)(64756008)(66476007)(76116006)(66946007)(9686003)(66556008)(6506007)(53546011)(8936002)(54906003)(7696005)(52536014)(2906002)(33656002)(478600001)(71200400001)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nFqkRkTPSm+rJiV3J5ZaNRlWcQADqD+JhB2g/7gEKZ3F7KaiM9CO+0Fdpm157LBIEyb0uFeYHbyqNYFEADDX74+FmSXjnK4uYjxtFKbTUK9EEpkjKQ2u3hT5+29IfddNXLahjcrCQygd7+CTrKMH3lRwvfplrBxM1Wso2FAaR4BHwYlfDNUHsUfndmidQm0flrpyrHoNy/pizXpAzOpjomEdgYUxO0GHGDzSg1WDpm8dgKz0QKqGs102eFCXOQgvq1lusvpCcHv0NjlaP1nLriX321Y56PGbyQhwWtomgZNlfeTd25D8S/py01yMp8uUnDwoYSbq4r7bwg7X6qC6msNp95HoOBfYdgwF5OmxH/lesHu1EsL92YkfJyRwIU2/8vLUTcKzWadAA3fExmu1yJvAPRHGvvuOg39j/zKx8IhuaNaTWwCzIJ1B4ZCr0L8/
x-ms-exchange-antispam-messagedata: GOZ+cDMwiMq2JHwFt0KN4YhLA0sqoQxuJZIV9zto4IfD0BF8XV/mtZYG+2g4nWuFEfz9Kxhm+0/LJ6YF+1tslkOZtntmutJuCtrES1FCWkyb1W/kSrgK1J8XBTwHh6FFirJVADtqZhbuaROF0ki21VEHd5YXyoPw7mGFNgVK0rbeBjstMfgsMMoxhbEHFTet46eAa4O5CAfoDd6DSy72wg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 986f64ae-7caf-4ec7-706c-08d7d5fbc2b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 05:15:57.3983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AZxeatzpkMxhQj08tG3930sWpYP3WId7jzNeVVVnvReCXuN0/yYuWVMT1OODIQluRH47iZmRZV0ccTT/4KbUPirA3t9xzy4eSBT6XwD8Fg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5862
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/31/20 8:33 PM, xiakaixu1987@gmail.com wrote:=0A=
> From: Kaixu Xia <kaixuxia@tencent.com>=0A=
>=0A=
> The trace event xfs_dquot_dqalloc does not depend on the=0A=
> value uq, so remove the condition, and trace quota allocations=0A=
> for all quota types.=0A=
>=0A=
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>=0A=
> ---=0A=
> v2:=0A=
>  - don't move the tracepoint higher in the function.=0A=
>=0A=
>  fs/xfs/xfs_qm.c | 3 +--=0A=
>  1 file changed, 1 insertion(+), 2 deletions(-)=0A=
>=0A=
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c=0A=
> index 0b09096..43df596 100644=0A=
> --- a/fs/xfs/xfs_qm.c=0A=
> +++ b/fs/xfs/xfs_qm.c=0A=
> @@ -1714,8 +1714,7 @@ struct xfs_qm_isolate {=0A=
>  			pq =3D xfs_qm_dqhold(ip->i_pdquot);=0A=
>  		}=0A=
>  	}=0A=
> -	if (uq)=0A=
> -		trace_xfs_dquot_dqalloc(ip);=0A=
> +	trace_xfs_dquot_dqalloc(ip);=0A=
>  =0A=
>  	xfs_iunlock(ip, lockflags);=0A=
>  	if (O_udqpp)=0A=
=0A=
I'm not sure, but do we need something like following description in the=0A=
commit log ?=0A=
=0A=
"Prior to commit 0b1b213fcf3a8 ("xfs: event tracing support") xfs=0A=
tracing had=0A=
=0A=
xfs_dqtrace_entry_ino() which was dependent on the user quota "uq" , the ne=
w=0A=
=0A=
API introduced by the above mentioned commit is not dependent on the uq,=0A=
=0A=
hence remove the check for uq."=0A=
=0A=
=0A=
Irrespective of that this looks good to me :-=0A=
=0A=
Reviewed-by : Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
=0A=
=0A=
