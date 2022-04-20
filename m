Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72BEC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 16:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355484AbiDTQGw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 12:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355569AbiDTQGv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 12:06:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD79DDFFE;
        Wed, 20 Apr 2022 09:04:04 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KDuwfH019298;
        Wed, 20 Apr 2022 16:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HLpo2/NitaRHkSe+eyAhlGK7RYYAgfEdfB6NNoDyQqA=;
 b=NX9wJtCUJTYrtwGsN7lbY3QhQlXK1O5ZC1CUi30r00nhR6MqTGSsLRMzXokcsWhAM+wt
 CDNXiqH95lPVA9TOXCFE16RUffJsNwQNHO+2K9hCSuTtZ+AmyLiV55EtpMuSSIi2AAxh
 wZsxvcF/3f4NnbJB8bYLoQMKpPldGvFiCis7yWYv4sLJ3pi9iKa9ZPIR/UtW2nlHjfYV
 9+HjyOsVob9DQMhRe+wECSj5cDZeAhJhJjZS98V2G3wKMCYj7kDqBLC9lzEoEmwCSuGs
 om2EqtgRtZKPn+XsMDGyXqfUCgL5QLkMntknN7hb8suj2bUIGxaFn+SCZP4pFuHfWbGB ng== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7cscjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 16:03:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23KFudtv025688;
        Wed, 20 Apr 2022 16:03:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm87cw1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 16:03:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsdRw7tFqQsOdXogNPrAgSbV6UehSlpME6wODysYMf6RCGNTz1NTl4VbMORjUkys7GNWISiFmcJzeCylHa4khMWxsy40YN5QjMSKMLDzdXA0IL2gsqEO88SL4iqc7WWdS5cJ60IV1O6mfI8U+5A/llTVhUc3g7cZ4ZTI1EdmNKVc/rLJorw0X7AfJ5Mb9r1hAOs5LWYZ2Lr2pTEjpDHa1b6zfTGc4LqMBU9zFYzZjQUFpQA+5fIeuk/6PLb6RW4HLu6qNFvclhAfxhtcMbN5Wzt5sKK3hU5glXXd5pPyil0XBbqwMIk7p30H245034aX9btpW7sPCx1ozkgcGmcmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLpo2/NitaRHkSe+eyAhlGK7RYYAgfEdfB6NNoDyQqA=;
 b=g7tyFaE1aNs2+CWYBp5CMCC0NOFLn/NJ2r2gs3bjfeV5XIoVSA3uxUpEtmMXqs9EcJCGR8EpHTXKCYFnmlII/lDoy7fAhndbyWB8jJTrDZ8zTr0tqwIgQNOJ7alP++paaIlc/iF4KtTPRcvj8gUG013YQg+sIJTNiX7uM3q91FEf4zKDIvaw1u5TPDFQo2UORSyaib38ZXmjG3/ZGNf5sPycbCGaNZAp//S8hSNBLjZJTOzG6tSfHMCF3YYFoG+h/Xv12kuqmSt34/H1mcNCtb4/H9JVzQS6IMXR8n1zNfqHr/1F6MOB7fNK18lr1RGqGOiYB2qnEiiRifZXX573jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLpo2/NitaRHkSe+eyAhlGK7RYYAgfEdfB6NNoDyQqA=;
 b=EmW33IEiAez+ZqxCEwhZPIphnit8co4Wyim0lgZt9djMvawU5vojpZWlBRPLVz+hYL3427R5xRA/VPNS0kksufZINvlBS2nzoMOvf9icpA4Xp/uHCZi6CUnDOxo1Qk3+39QPuiQuRv5kftufKYH40yJ26064U4tr4N04URQqIgQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SN6PR10MB2879.namprd10.prod.outlook.com (2603:10b6:805:d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 16:03:47 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5164.025; Wed, 20 Apr 2022
 16:03:47 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "zlang@redhat.com" <zlang@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>
Subject: Re: [PATCH 1/2] xfs/019: fix golden output for files created in
 setgid dir
Thread-Topic: [PATCH 1/2] xfs/019: fix golden output for files created in
 setgid dir
Thread-Index: AQHYVNA3BE/4I+433EOx2L+HL9CStQ==
Date:   Wed, 20 Apr 2022 16:03:47 +0000
Message-ID: <08863DE0-4BC9-494A-BAD0-F2A0A2901E05@oracle.com>
References: <165038951495.1677615.10687913612774985228.stgit@magnolia>
 <165038952072.1677615.13209407698123810165.stgit@magnolia>
In-Reply-To: <165038952072.1677615.13209407698123810165.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd40c2b2-320e-43ea-c6ef-08da22e75a22
x-ms-traffictypediagnostic: SN6PR10MB2879:EE_
x-microsoft-antispam-prvs: <SN6PR10MB287955C71C7952BCA30F2B0589F59@SN6PR10MB2879.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hcalghKnr3SVp9XxbQDXbTvOQlKOlqs490dbOQG0bFrAx+cjCfdehkt4TPHW1Ck2nRBlNUFYjG8eIhnKH1++r7mfnEHB+RXEVQQCBNy+oT4NOTK7hmcU26Ea3cUF2X3l5ibk9ASuizotH4fbFv7hz+Uc2OBCDSQD6ntzs4/iYcpHomt++/S4uAUxt/Z988axIfXSR5LDF+3gqc5LcJtiFRQOZKNTcI6tJXaztDzWgstsl7sjDZ+47a8TtcrkjSWxWfvSzoFuQ5JvfsthWnAgg4Bm5GSB0Oc5NOBU6iGedOKV9MyoKGd7kVQaa3Z8+QAjqQKFijXTkwwRCYtyKaQDR/DbXU87xK74XMV+fDStNttbO0k7Hpv7w2GQDcCeE4qSPTct/SyY4ftHXySm3gq+n98qXVES3PxGM8JWqwcp1rVVfks/HdXapyG8j11GdYAp5qlZ3wQ6II0DreCFjmYLG3klvm1HXtMA0eUDBl9kFkpZR0yHK9nXbvZoe93g+cS/Ftd3D8cMjS8z5hiILK5R46/gwGtpjKxZW8nuu+XMIwuXVJMpJb1CLr9+RERGXKE9xNfZNvsl7W8B+crMueRUQe2AS53PLoGC5incGhmnqelJXAu2wZSnKNaEbEQhN2dUxwRMtav6jF/pbEmPbWIfGwGvOEJxJcDRRXNo1m2V68iym3GpvGJtXtm9jGx+tuU8AwvNG3G8yaqLHSiGVss9GGe8s19xTx9tBu6c5pn8OBo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(36756003)(6916009)(38070700005)(2906002)(53546011)(54906003)(44832011)(316002)(122000001)(6512007)(186003)(6486002)(71200400001)(8936002)(86362001)(5660300002)(91956017)(66556008)(66476007)(76116006)(66946007)(33656002)(4326008)(83380400001)(64756008)(38100700002)(2616005)(8676002)(508600001)(66446008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BRrIO6ZyjCp0PycJydi1rBl5nko8H2RlETnN/cDtmMG7dtm3dBk6bBaCnnKT?=
 =?us-ascii?Q?C/E6ir4li+6RxBYrNBMBZUjq3F1GDdQaU28Ta+iXl/x8c9jX2AXLS9WFEtrh?=
 =?us-ascii?Q?8t3MTdS7DkuHFm0Wakcq9db++rxJO5auXz17yb0O1AyJGeP7tFf9da8Dz+wq?=
 =?us-ascii?Q?dmprspkIbhW6XG0TNrv3vMssJ+Ph1MBqw/oTb9UQ0DYsIz1KE1DWc9/xnpBV?=
 =?us-ascii?Q?Lhu41T8PHSjbrtqrIUKFVzqJgPolZZ+J/7VyyAfXtHwyPyQ4BvjzO4H1OTSl?=
 =?us-ascii?Q?Vc1wcpgJcb4Irpkk4vpIpQuozx40YZL11GS6bzM7uTsMiMhBCAPvZi6mgjHD?=
 =?us-ascii?Q?mY2IqQLCXx+/kA0FrbhKLBTRZbp4cb0SWbjBQA6bvnXJ2Z9DbNcWRaaPyLfx?=
 =?us-ascii?Q?Av8K4iFbOqXOjPCV9/qAImw12kM9RXvKCcVI6wcf2ghi5SOwUgTS7yEOtoQr?=
 =?us-ascii?Q?oTRn393+GOxamJvPWpGNTrWIAqezqB6sPteMuu80OJXAkzTRoSgil0hs6eUm?=
 =?us-ascii?Q?B67uagLz7JO3GpmZFDLokIbw9oLAq24dxr+81AMmsC3Up+csLd8OaAIcE1vE?=
 =?us-ascii?Q?5SNC0m2tZFupZliDKEEGCYiqKF3WewLwP0PxnmfNej/evjKUN1UrUv+W8t9S?=
 =?us-ascii?Q?1G+iN30d4rvqU/d1FU5TeyVWqFctGo0GgWrZ/i3K749bbkYThh6G5ZZX+r1H?=
 =?us-ascii?Q?R3yAdiw1HgE6MYTuS2S/B7c8xKAO8BJSqvgHHEzO4XBgYu1AeqtbuDTjKAoK?=
 =?us-ascii?Q?Im2TCEnb6Ts6k4PhAolqMIPRLR2BZRRaWWwAKjD+nz5cDyc4vGtUSKQXYVEF?=
 =?us-ascii?Q?rrzIsS8wpg+oLMKIY4H/94DxL/gVIRgLzieFvm8FJB2TTzXITIAafJ3HtEgU?=
 =?us-ascii?Q?DN79kiPg3sn3Df1TlximvW6PGyUMQIi/v3paZ1q7vtSqRcClfWwJQJmCir+u?=
 =?us-ascii?Q?628UXiA9Vf6UAuwr8rZBjpFrts18TtQu8IzsD+s6ifAPFSU8qFpSooVKNsSm?=
 =?us-ascii?Q?mvUGqXZ566zu+/Gb4IhbwHYZaQmVY8h3yU0dXLQAJQ5R6UVKL3Xe00/q26yL?=
 =?us-ascii?Q?dXY5z04CEkCfq1emR0KmOi7pZW7j1hvrjA/QSSzL7AfTgu4ittbbkhVYxX/N?=
 =?us-ascii?Q?XmSSDvDlsI+c3YTunt/VkGlxuA2yKOo+Sii7Zhw2nupO2So8eyVfnkLKQafC?=
 =?us-ascii?Q?WwZVrJPTreyS+IohP92DHrizjz615n6DU00N/69ID+jRoZhAsUSoxpkISSH0?=
 =?us-ascii?Q?TAqvSxXZNHnBPvmUoQcwPwlhKvaavRhEvFR3YqrmN/NTfXgPM8egdzcPkhxK?=
 =?us-ascii?Q?zgvZj3ke/uGFRkRK8fTkCJrwYfqBwjO987ZY14IgAOMa0QcXGm4k/AFDIcGK?=
 =?us-ascii?Q?ZzB+kLQxRKGP+lK2H23z8AhbP+krMHUkAsAtmZU+TCAz9fMzVxXP7T1/bBND?=
 =?us-ascii?Q?q0ChzL6KVXI3L350eDkeYI1vsTPMPhp2GA3OA5MKtZbjl6lKgsNi+4yF8fv9?=
 =?us-ascii?Q?S1MlKKTjie2o03GXyWr/ZlQHVSKTia22noN0yj77LtgYq9xi28w82VHcnc1u?=
 =?us-ascii?Q?C0KnZ7e8DpNE2s5N8AU/IM/oVdKELkFU0V2WDn17RmCsTuA0lqljoO1tYyrq?=
 =?us-ascii?Q?DtAack/Thk3T4kXT99CbpqwBScWkLnel5cN8wnQORqmBiaqPd9a1S0yfBghR?=
 =?us-ascii?Q?Ybn8fruHM0+R2aWuHDFDgvwcwB61MUbewYvBv9rkYAouWBdZO/RPrNcZSwRi?=
 =?us-ascii?Q?dc0B67tvXrpdb7ChFB4oANDDiB0vIU+0HegtxEdc77jkNTkC5bqvBI994ZN0?=
x-ms-exchange-antispam-messagedata-1: Kk6VdJQOQm+LxlWC3TfFJFEAZj7o5gBGYtybUimv0ShZsHLtB5wgvO3X
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA0EDE9A9751A9429FAFAB47F066EE80@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd40c2b2-320e-43ea-c6ef-08da22e75a22
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 16:03:47.0427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yV2NQpWvAikTAOlTSaEwJd/81eXEo8k437kY4MlcAKp8a1ojBwSzOnru/gTWvJiyao0aTr0+VjBDj9yVkfZUM0jiXj8BNnG3VT2ip0kuojs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2879
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_04:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200095
X-Proofpoint-GUID: 18xxOf1AD5gehZPTY9KK1LGavZoCqPEb
X-Proofpoint-ORIG-GUID: 18xxOf1AD5gehZPTY9KK1LGavZoCqPEb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Apr 19, 2022, at 10:32 AM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> From: Darrick J. Wong <djwong@kernel.org>
>=20
> A recent change to xfs/019 exposed a long-standing bug in mkfs where
> it would always set the gid of a new child created in a setgid directory
> to match the gid parent directory instead of what's in the protofile.
>=20
> Ignoring the user's directions is not the correct behavior, so update
> this test to reflect that.  Also don't erase the $seqres.full file,
> because that makes forensic analysis pointlessly difficult.

Looks good
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
>=20
> Cc: Catherine Hoang <catherine.hoang@oracle.com>
> Fixes: 7834a740 ("xfs/019: extend protofile test")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> tests/xfs/019     |    3 +--
> tests/xfs/019.out |    2 +-
> 2 files changed, 2 insertions(+), 3 deletions(-)
>=20
>=20
> diff --git a/tests/xfs/019 b/tests/xfs/019
> index 535b7af1..790a6821 100755
> --- a/tests/xfs/019
> +++ b/tests/xfs/019
> @@ -10,6 +10,7 @@
> _begin_fstest mkfs auto quick
>=20
> seqfull=3D"$seqres.full"
> +rm -f $seqfull
> # Import common functions.
> . ./common/filter
>=20
> @@ -97,7 +98,6 @@ _verify_fs()
> 	echo "*** create FS version $1"
> 	VERSION=3D"-n version=3D$1"
>=20
> -	rm -f $seqfull
> 	_scratch_unmount >/dev/null 2>&1
>=20
> 	_full "mkfs"
> @@ -131,6 +131,5 @@ _verify_fs()
> _verify_fs 2
>=20
> echo "*** done"
> -rm $seqfull
> status=3D0
> exit
> diff --git a/tests/xfs/019.out b/tests/xfs/019.out
> index 8584f593..9db157f9 100644
> --- a/tests/xfs/019.out
> +++ b/tests/xfs/019.out
> @@ -61,7 +61,7 @@ Device: <DEVICE> Inode: <INODE> Links: 2
>=20
>  File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xx_5"
>  Size: 5 Filetype: Regular File
> - Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> Device: <DEVICE> Inode: <INODE> Links: 1=20
>=20
>  File: "./pipe"
>=20

