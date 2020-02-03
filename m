Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42C2C35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 21:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98DD920CC7
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 21:00:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="evORCvMQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XlCarLxG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgBCVAp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 16:00:45 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:30300 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgBCVAo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 16:00:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580763645; x=1612299645;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=gi30nW2NigyY9yb/crl+wCDNLxVyz79j/TTru9xdEXg=;
  b=evORCvMQmNq3pzrNfVKu+fkCKGDl4KG4JR51AfiH5pJsCmjNXNAJQ+0w
   hWRsiqWkLhjs8B9wXoiwoIG5F3OYqhpLLkPxi3npaWEYORGTLD41/GEPG
   I/qHCpIn1lx7jRzVgXhu3Bjqg1y6hhy/AiRDbqiw43/bftd5ua51y1Azy
   nQBX0hmhLjXLB+PwVNfGWQiC16DV5I9xvaqbYobO/rSyw9XUGoGyAV68m
   EmRpo8U5WczUG71o6RS7XGd95G4IpC9k4FyHehiSXNAWOeiQa6FPR0fQU
   h+BCUHofbULsO0K5OnerWv7eeyIoVdMnNIwP7/CSlDtFYqpels15K6VzM
   Q==;
IronPort-SDR: MUwQlidwukMbMB9yjkWswWx8WA4VQSmI2cs6WssdjODDPO4FGcjTmH6HgXak4xOY7YDi1KvkGR
 q2GjaOdV4ndDEbQg1kPgFzs38jFIktkasHBrJq7Hz7MmFbG7Nhu7bkflbMWVJXAblwFWws0EVN
 fE2ge54OU5GEPnTulQ95w4y/6XyiHCPwYlZhul/T9jraIiInBa5xbZwAnvoRoBdjYH9GNeNcTj
 pjKc7IXJ4FKmmICDPQ+x+ehvVRAbwnh9Pg95zuZ9alH8tHsC4kLdewuN1H9EtZZXIVd0OirY8Q
 Xsk=
X-IronPort-AV: E=Sophos;i="5.70,398,1574092800"; 
   d="scan'208";a="133361526"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2020 05:00:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PN3fJt8HdAFS4wg2UU1zrSt9ZmGOWi2udiEucrh7PC7fhXbC9QHYQwgHmMLp/DenoJa3OAvOUQns7nvR13zPZxbvxeXkwvUHQ0HXnXTNJnCu4eeKwnuJhH9pIS9l9uI+ojK9q7NYwuri/blN31+XYxXc7ajgs8rX7CZj32ej0lT6Jbq7OY/qPSREu8NLCwkN6tRVsoLqvGEx8D3XCuEKy08t36Kj/WRHRaBx2LuL/v5xDDYQD7LMyMCCJxsYrhoStd24xh4nd47AoTIc8MeROfVreEB9F8vrMGJ3Hz7j+zksLxw8f0MVI/Wo3j+/p5KkuZzZ7UK3dGFKdHcJvDaSCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfsAEKyzcYH5GeOyAGwKEkYUlmm5Kb971LcYc8kvPmk=;
 b=OKlcXZJHWZrIdA6sTOwqEB4ntZGperwvx9YWYLiXhHuNWd9HPdQHE+0rxy8VVAvkN941A9iiXvPOP0s8hwFGFdd2MKzRTblyhxzT0cfspuqNji5Wce3BeG6wkWDInF6daL3meTHIYMYwqxJQmOB2c/eOW+AuCRT/lINJG3bR/H2RkKMx29Y7+jdAL8aFoGW11f/bF7F+9OEYbEUjD5FHE8akpx52UliRgIBkdeZwrCchGPSfDhalrySkXUR8ffc4pUSfy+fOSDE86jntNyxOvdQ5CppgZgvg5CEcIbDz3D7S7hR0OP+mVOm13dTeeosccV9tEWAXmbbWe0haZolA1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfsAEKyzcYH5GeOyAGwKEkYUlmm5Kb971LcYc8kvPmk=;
 b=XlCarLxGRkNCw6+W1tZxSOWsHd4v7p2Qv/ZJM+CXFmJ1568R23aQ/r/ya+0BBYstFujVkH5nrk2ak5jG7+WCreR5757EcKhbNOiGNQ0ELF54uA5Y9xnw8XTBRkFmTZxYDIoHWpuerS3J45mIooj+gOm2Q674L1OL5sFz31u8itY=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB4133.namprd04.prod.outlook.com (20.176.250.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.26; Mon, 3 Feb 2020 21:00:43 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f%5]) with mapi id 15.20.2686.028; Mon, 3 Feb 2020
 21:00:43 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Pavel Reichl <preichl@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 1/7] xfs: Add xfs_is_{i,io,mmap}locked functions
Thread-Topic: [PATCH v2 1/7] xfs: Add xfs_is_{i,io,mmap}locked functions
Thread-Index: AQHV2ruiL0GX1NqNVkKQXrQsE6Ni8g==
Date:   Mon, 3 Feb 2020 21:00:42 +0000
Message-ID: <BYAPR04MB57493D3E8FDA91570ACE73D686000@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20200203175850.171689-1-preichl@redhat.com>
 <20200203175850.171689-2-preichl@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: efadae78-b447-4cd4-d922-08d7a8ec21f6
x-ms-traffictypediagnostic: BYAPR04MB4133:
x-microsoft-antispam-prvs: <BYAPR04MB413367BE1A5F79CA8406AA1786000@BYAPR04MB4133.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(189003)(199004)(2906002)(64756008)(66946007)(66446008)(4326008)(110136005)(316002)(55016002)(9686003)(66476007)(66556008)(76116006)(86362001)(52536014)(81156014)(81166006)(186003)(5660300002)(8936002)(8676002)(478600001)(71200400001)(33656002)(26005)(7696005)(6506007)(53546011)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4133;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Di5akiufw2nlpFmwi/F9uUUFP00oQvLm06uZph0iGF4IP7BHlulEVr/6TCXvw6Li13G5r4ZwxJevqaBCoJmsN0OHo/o2ARjbzl0s1adIG0+QGPEzkTPuepfnFy//NuqqODPbuF7+m0lMgfn/218RrFSWXTsAbzkGarxtSuk2QmDK8Cx4IwM+PSeWsOfwvFGeQ+ocn6ZuxNVehyS46hm6h6RAwIcQREzcVhnPXpo+1CtpP8tePw4ZAxFk70vUIL0xivf6SCtneYJp7pz3R98azKNf3L8zOZs9eFOu+JCIzz2XTsRer8XGDXYGlxAcfIwkAMwtDP50u4RjM2I+whvr331xgCO0TpePaTcb0xezkJkDO97/y5urXMdf2pK6w2pOdv3blUKMSJwSMwyRO3AKOeIUn69xnw15961mAZjPPsVrb8ocjYk2Lsv7agrAomGHNNZFhLqNwrICyeP7MJZpkzCku8iFT9k3p2yj/jdrKz/0riflbJdxlvOkAZtcjui
x-ms-exchange-antispam-messagedata: bVdeF5ucH1isCiH375qjCfW/vDTAdCv141ixWyxh1DAnaZojipoQoEVi1MhH4n/Wm0XGz15y0Mc2aR/b3G96xS876LFe8Fy8fQ+V2LXSRL/lsvAxud5K7pSrXnTd5eEj3klCLrZuX1bf8ZK9FXqG6w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efadae78-b447-4cd4-d922-08d7a8ec21f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2020 21:00:43.0249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uF8jbduGOEnx7cLp86GXsBcB5seuTLnmjU7df58PcHEpj+k3LmuubPqV2rLwSMJjMyNZLUpdQ2Em8G8QWjTWeEkk5j3L9HiaRYH+jOVelzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Pavel,=0A=
=0A=
Thanks for the patch. Please see inline-comment.=0A=
On 02/03/2020 09:59 AM, Pavel Reichl wrote:=0A=
> Add xfs_is_ilocked(), xfs_is_iolocked() and xfs_is_mmaplocked()=0A=
>=0A=
> Signed-off-by: Pavel Reichl <preichl@redhat.com>=0A=
> Suggested-by: Dave Chinner <dchinner@redhat.com>=0A=
> ---=0A=
>   fs/xfs/xfs_inode.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++=
=0A=
>   fs/xfs/xfs_inode.h |  3 +++=0A=
>   2 files changed, 56 insertions(+)=0A=
>=0A=
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c=0A=
> index c5077e6326c7..80874c80df6d 100644=0A=
> --- a/fs/xfs/xfs_inode.c=0A=
> +++ b/fs/xfs/xfs_inode.c=0A=
> @@ -372,6 +372,59 @@ xfs_isilocked(=0A=
>   	ASSERT(0);=0A=
>   	return 0;=0A=
>   }=0A=
> +=0A=
> +static inline bool=0A=
> +__xfs_is_ilocked(=0A=
> +	struct rw_semaphore	*rwsem,=0A=
> +	bool			shared,=0A=
> +	bool			excl)=0A=
> +{=0A=
> +	bool locked =3D false;=0A=
> +=0A=
> +	if (!rwsem_is_locked(rwsem))=0A=
> +		return false;=0A=
> +=0A=
> +	if (!debug_locks)=0A=
> +		return true;=0A=
> +=0A=
> +	if (shared)=0A=
> +		locked =3D lockdep_is_held_type(rwsem, 0);=0A=
> +=0A=
> +	if (excl)=0A=
> +		locked |=3D lockdep_is_held_type(rwsem, 1);=0A=
> +=0A=
> +	return locked;=0A=
> +}=0A=
> +=0A=
> +bool=0A=
> +xfs_is_ilocked(=0A=
> +	struct xfs_inode	*ip,=0A=
> +	int			lock_flags)=0A=
nit:- isn't above lock_flag variable should be uint ?=0A=
Is there a particular reason that it has int type ?=0A=
> +{=0A=
> +	return __xfs_is_ilocked(&ip->i_lock.mr_lock,=0A=
> +			(lock_flags & XFS_ILOCK_SHARED),=0A=
> +			(lock_flags & XFS_ILOCK_EXCL));=0A=
> +}=0A=
> +=0A=
> +bool=0A=
> +xfs_is_mmaplocked(=0A=
> +	struct xfs_inode	*ip,=0A=
> +	int			lock_flags)=0A=
Same here.=0A=
> +{=0A=
> +	return __xfs_is_ilocked(&ip->i_mmaplock.mr_lock,=0A=
> +			(lock_flags & XFS_MMAPLOCK_SHARED),=0A=
> +			(lock_flags & XFS_MMAPLOCK_EXCL));=0A=
> +}=0A=
> +=0A=
> +bool=0A=
> +xfs_is_iolocked(=0A=
> +	struct xfs_inode	*ip,=0A=
> +	int			lock_flags)=0A=
Same here.=0A=
> +{=0A=
> +	return __xfs_is_ilocked(&VFS_I(ip)->i_rwsem,=0A=
> +			(lock_flags & XFS_IOLOCK_SHARED),=0A=
> +			(lock_flags & XFS_IOLOCK_EXCL));=0A=
> +}=0A=
>   #endif=0A=
>=0A=
>   /*=0A=
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h=0A=
> index 492e53992fa9..6ba575f35c1f 100644=0A=
> --- a/fs/xfs/xfs_inode.h=0A=
> +++ b/fs/xfs/xfs_inode.h=0A=
> @@ -417,6 +417,9 @@ int		xfs_ilock_nowait(xfs_inode_t *, uint);=0A=
>   void		xfs_iunlock(xfs_inode_t *, uint);=0A=
>   void		xfs_ilock_demote(xfs_inode_t *, uint);=0A=
>   int		xfs_isilocked(xfs_inode_t *, uint);=0A=
> +bool		xfs_is_ilocked(struct xfs_inode *, int);=0A=
> +bool		xfs_is_mmaplocked(struct xfs_inode *, int);=0A=
> +bool		xfs_is_iolocked(struct xfs_inode *, int);=0A=
>   uint		xfs_ilock_data_map_shared(struct xfs_inode *);=0A=
>   uint		xfs_ilock_attr_map_shared(struct xfs_inode *);=0A=
>=0A=
>=0A=
=0A=
