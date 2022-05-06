Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70E6C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 17:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243429AbiEFSC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 14:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239417AbiEFSC1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 14:02:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E656D3AB;
        Fri,  6 May 2022 10:58:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246FBn0J026258;
        Fri, 6 May 2022 17:58:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=EilxPQ71oKNdAsnmge81WH8rgXPsYVPCQz+AoBm2+FE=;
 b=IFW5xRZRumOEi8v9Al8HLoWFIYcMngqywIYQS90on4dyiowgfQiCIeq68nr60GU3ZOgL
 A85Hwvx/f1LTSx9WJ/6gWdkG68jWNl6cPRt65UD0zJY1einPrbEl+CKYZYZfX5NYBUi9
 bxA3KyIq2avL/uxGjxm9DdMH0QLzaC+a3cqt+TKMt7kSUeqjs0K5kJeyB7w/ZKvFjOYL
 1yuYDKiVtQXIufSJwlkpM4LM/3/0LyiJCVmAOJNv2r6rUBaEaMuSEmQvWEwVz3mTZs8n
 NqqcnPxDxhsK3mGUajqlFaj6NohQaT0ETM3czX9pa0jT/+EY3Yn089gXMJYY4UNo4qmQ mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruhcef5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 17:58:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 246HtRCR026527;
        Fri, 6 May 2022 17:58:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a8k8t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 17:58:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hw4SsBYoo26c8M1gaX2rtMRBYqmoZddb8v4zxCcLqCWm26+Wm/xKkywyEBzCY2R38Ws9+78Fq0RzGFnZvfEEWetHb1caep2AvGfnN4qR2uuHxCFzumay2LpMTCloMZGGmpbWwJ3TjXRzmddzR9fV1wPmORVZCkrRFejZfEqHmD65XKN8mASFgJ6J3AtN70IreLMfqSaX3EJ9vG7Ry3hLjXm62+HRQyDZYS4I/cu9TiUCUicC3NV5cF37r7j+VekumWFHyOoYhW8DhD5CaWqNQtNdt+Mu/FOMCfDWgKZ4+O3hsqmUNn709IWwKUROuEPqDGM37eLbEjcGyz23kz7uTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EilxPQ71oKNdAsnmge81WH8rgXPsYVPCQz+AoBm2+FE=;
 b=Sr34nTr4Ks426lDemg8BbkMKQtUoqeGM28n11q98DDkBH5UGjtsv48SdrEcdwd2RTMZ/3vAmDD5wQUiUYZvtcvSGLbFxQYQwm60j2YRwZz7lc7gbj2Au4Z6GRoZKpyZuml5xU+tqKNiI3BBlHfeulZ4HoNi2NTvL8xA0yjBXQefYLKyWFmEVc3cFsURQ5yGCM2VOaKruejrHzVJ9Ue/9Y1eELvkuk3sjBOuJ02sKDhPaxwABry563mqBFVuQwAkve40kjttsy4wXu+0ve6YWdASFNlvgxhrdtFv52ewgxaDTVzUnWJm93yCpRtwvXTLH+5/XiBhJ9LsNuFtzxXCgAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EilxPQ71oKNdAsnmge81WH8rgXPsYVPCQz+AoBm2+FE=;
 b=QML+lhov2sghWgUR0e8hCbq+uIj3Po6JH6nvsSAzAZT9bi7bCSg9dmHbXiEI8eT+zIFkIpXmdBEDUk+BcKcR8ZsoZAKHA3ZSjnSv/wBpl79pVXiG1/vdlPcEsic4JbfxODHsP2fO0FQIRp3wgEOGf2/QigldzbxkWhO1mgxSRwg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BN0PR10MB5253.namprd10.prod.outlook.com (2603:10b6:408:12f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Fri, 6 May
 2022 17:58:38 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 17:58:38 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: [PATCH] xfs/larp: Make test failures debuggable
Thread-Topic: [PATCH] xfs/larp: Make test failures debuggable
Thread-Index: AQHYYXLpBZcRI2GCG0y7rV6nnDnuww==
Date:   Fri, 6 May 2022 17:58:38 +0000
Message-ID: <E8E6E57C-583D-46FE-A9AA-71CF028D317A@oracle.com>
References: <20220223033751.97913-1-catherine.hoang@oracle.com>
 <20220223033751.97913-2-catherine.hoang@oracle.com>
 <20220506075141.GH1949718@dread.disaster.area>
In-Reply-To: <20220506075141.GH1949718@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06a004e2-4af4-4357-e445-08da2f8a0c3b
x-ms-traffictypediagnostic: BN0PR10MB5253:EE_
x-microsoft-antispam-prvs: <BN0PR10MB52533ADFA509A629BCF8946189C59@BN0PR10MB5253.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9j9e1d5YUzQvYyqj1pdsg4dDJ7BCgIzRInnbhlBWK/Nt+aUsg8k6thDYisAUrZVldai5i/hVzKPMhmufH98Rmd9Tcl8c+iu9e65cnj5C2lwMK+SST7ZbZr0OGXgBDMxv6EAVC7kPJxtDNtvnYilk1c4zyhU9fcuKj68tCTiWDi7uU13JR8mqIyXWXLZP5Op/t2dvw5Ny/bvpOWRBnXJpLN2Sqkdm+MwLRGRf7G68hsfXueQAIfOG2KmX77ZO2IMPRGwKudOHHzDYHW6qIz/bUAT2cAVdpv4JtZZW3yiFnY4p5kCYkY8gf/DmUf1smShiu8X5zuTitMG8kXrFi0n997PW1xo8pHajxx+GBa6E4Nz0iZ/wc+bsBX7c1vI/RqNwpT2EPIcs52F5uPcucxCcNPEZBPZvMOsAFNsfdWTlwzZboOEpqnJOAN10Kss1UxQcb0h33BW5vf47GZlXNRWJFXMv6mtl1R7rUC8+l7UUCA9KSdH4A8NYDRWrc4rdHhAWFPDDmA/Uc6YI6vBKegH/CU/gEhVVxjubY4tpH01P3pP8laLPEsfjIFliDz5q3muNGIAQ9aEMeQ9B5UeuiEhRio1g8JZBpGp+UTeEujXFzxUIpIsUTVKtAk7JXCfDRfLwKJf7jgs3hRBwuMTfGGAxuA7WQWD++rkfSHlafC/t40523BrhTHO2BKdAjHIr+YY34goIwubprXLU8Ut55r5e9R3a6sYoA8u8geCwG+YXXZnlu3DndaAO9bH4WHn+HlUayCTAqO7iQltqKMaOP99aIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(186003)(6512007)(2616005)(2906002)(53546011)(6506007)(33656002)(36756003)(6486002)(38100700002)(86362001)(44832011)(508600001)(64756008)(71200400001)(76116006)(66946007)(4326008)(66476007)(66556008)(8676002)(66446008)(91956017)(8936002)(6916009)(54906003)(122000001)(5660300002)(316002)(30864003)(38070700005)(45980500001)(357404004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Y4tpXI8NT0nou1x79JbRJqveexG3mKTRHKeofIISSpIa1aFu0lz8Tca0hOr?=
 =?us-ascii?Q?v6narsMZ18iD6Zlx47jmAkr7+2QdE+emhkUg1RtCWRMoT98TUFBu0pKytWID?=
 =?us-ascii?Q?MvBMitYypWjfrnTu5Z/C29G251o+za4pNELSMXU32p4XxopLJn0dwtaZSI3E?=
 =?us-ascii?Q?4QBmH4McJh71kGxVw3WflY1j/jDGm1WBgCex/LdpveFoA6uUx/OI/yCHR+pQ?=
 =?us-ascii?Q?vR6YoQknHMY+6sxbUBpKWqzUm15bdRUol+K/XAAQMQX/KxSMts8vCE3jW84o?=
 =?us-ascii?Q?QXlq9RGTTKiisezk8G7bdW6m641iQkieGVJiLBvvOGGZA9TTAo/uRkp1VD93?=
 =?us-ascii?Q?zvfWIJ4bbhg78s3zBrwP9PPOpTKgrDnO8CwZ+7PXX0HbY1RAfE0lvG/C+yqc?=
 =?us-ascii?Q?0SPowSvs7n8jRaJ7hNzIKK5RUgHEPRc4Yom41/XWLK/XADq+iKXTB/UxYgmE?=
 =?us-ascii?Q?VTgciLcdzjQSPqxxDSoulEcq2KVQHaGFQKEvf0F0qN0crzILE2ZtGEaVfdiy?=
 =?us-ascii?Q?mPTCV2EI0YHiS+nF6Bn9xY9aEXEPrky+z1wfoQoeX80ByV+Tkg7mkkTJ3OcN?=
 =?us-ascii?Q?hPSnGIxqtMS/aOt5o5UiRmBY5zxgwfdeEy8Mv1wik5vLebqznoP/X+/j1lQU?=
 =?us-ascii?Q?bFmkeK2/610EpgJSTM7NHZ3f0Ka8MvVEKNcUf2Avfs/ycGAvpUT9lscf97NT?=
 =?us-ascii?Q?Ld+dwx/SU/cn6pEJw3lVPG/TF0FHss3jMVg6ZeIzn/kcSsujIwzI0rxw88Dc?=
 =?us-ascii?Q?VyTKhQtAKuhmYceS5gPYz9QZOAV5VDtC6Pc4F1D84t3XA55ATd1CtcLqdmJI?=
 =?us-ascii?Q?XGwqXqWaO8T0T7R/898Qa3rTlrYY3ij4GwZ/h7Pne+pcBuNIdV8E7UWL2x3r?=
 =?us-ascii?Q?vEWhbmqkZA7kZMOn/qMovp25eBwBE8BrfWuidPrt/ZAYr3QZETB6riCKAPs9?=
 =?us-ascii?Q?y4cJXaBuCaOVi4CK2vRCOZeVAO5Pme1qLD8US1a3VrxamfegyHtwX8jVrYrS?=
 =?us-ascii?Q?EUl1serl+2GE2z8I/1Pw2CiZ+UbqyI2xP61hHvkwIP5CrMxsYXxcYAmvof9O?=
 =?us-ascii?Q?rKUZtoZv+3j0YKh7zbLcSKJrFJk1FuW7xTQeA9/KlPRGSeNO5AzeJkMhRki6?=
 =?us-ascii?Q?knN1w4f8VqAUesjkvWcK7zYcDWN9yCcevkbpXBj09Thy7r70uNVOPp6sBqv4?=
 =?us-ascii?Q?Cx2DubutYCebllov76GOOiL+8EYqCTyMjbh3vwqjuQHFT4DLMKrPHJm/lpFz?=
 =?us-ascii?Q?OCNM/xBMBNt63tixeb8lUcJkNSnR7ZiOWiLkNamKdrDrYVQllm+aaeAeq7zt?=
 =?us-ascii?Q?70fz1ppAfjamFzFmgzNR+oq7eE/I0pZHGmKnQOoOWalFXd+GK6Sx6oDEpiZa?=
 =?us-ascii?Q?Y6mkE+56yU5UWvqnFKQYi0OnDxz+DgFGE5YCMF//5BD+AOSAMbARsunXHYSM?=
 =?us-ascii?Q?E4W2WGu/FRicP9zLSUY3XYUayzLZRy4YPUcBnSn0AhvG5tQ/IgJ/p24HVMTz?=
 =?us-ascii?Q?NcGA5MegAT9205OmsTnX6NOWVqTjETcmB3IanRggcs4YcfDwnDbjBOBhm/yC?=
 =?us-ascii?Q?HN2Wy140Wz7vVoFCJOBulCPIJHJ1BKJSDhK2RyVr9w935w4ksiSg56ZVbOn6?=
 =?us-ascii?Q?gpQgw8XibEv5N+fZD9jmcNHOeoj4HU5OmpwgGqv1xTJPCr8GgSwNORa2drVz?=
 =?us-ascii?Q?VHYHsqY+toBhNyAa5bjS6nD9Kn96IEDQjASGlUMF73gSdeuzxdYRSyRcUDVO?=
 =?us-ascii?Q?DJrc3MQ+WGeMZR4yD/hSlTWNnSsPT2RiqktzDg4p1W5+5/SddOoJ8ioCgDKm?=
x-ms-exchange-antispam-messagedata-1: O3V7ZKAqlZcOF2sxlbHhgzqVjT0zlDzckTI3QosoQMDPkae+SFkF9K1r
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BFBE1C50288C1B4893D9566606F4B8C4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06a004e2-4af4-4357-e445-08da2f8a0c3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 17:58:38.3434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +eZDpTqiFSlBZqU1N+9lPWWWcx+YLwEkZ3FG8vCeB1JdyM/yLTzCzvuh9J0lns8Lv39xwLQPrQGk7HrbfhjFlg2lW6Z0u1S7WB8F4Spxf4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5253
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_07:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060091
X-Proofpoint-GUID: oJ8U7Xn2YZGbchsILQIQL-nx2Q21HMTu
X-Proofpoint-ORIG-GUID: oJ8U7Xn2YZGbchsILQIQL-nx2Q21HMTu
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On May 6, 2022, at 12:51 AM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> From: Dave Chinner <dchinner@redhat.com>
>=20
> Md5sum output for attributes created combined program output and
> attribute values. This adds variable path names to the md5sum, so
> there's no way to tell if the md5sum is actually correct for the
> given attribute value that is returned as it's not constant from
> test to test. Hence we can't actually say that the output is correct
> because we can't reproduce exactly what we are hashing easily.
>=20
> Indeed, the last attr test in series (node w/ replace) had an
> invalid md5sum. The attr value being produced after recovery was
> correct, but the md5sum output match was failing. Golden output
> appears to be wrong.
>=20
> Fix this issue by seperately dumping all the attributes on the inode
> via a list operation to indicate their size, then dump the value of
> the test attribute directly to md5sum. This means the md5sum for
> the attributes using the same fixed values are all identical, so
> it's easy to tell if the md5sum for a given test is correct. We also
> check that all attributes that should be present after recovery are
> still there (e.g. checks recovery didn't trash innocent bystanders).
>=20
> Further, the attribute replace tests replace an attribute with an
> identical value, hence there is no way to tell if recovery has
> resulted in the original being left behind or the new attribute
> being fully recovered because both have the same name and value.
> When replacing the attribute value, use a different sized value so
> it is trivial to determine that we've recovered the new attribute
> value correctly.
>=20
> Also, the test runs on the scratch device - there is no need to
> remove the testdir in _cleanup. Doing so prevents post-mortem
> failure analysis because it burns the dead, broken corpse to ash and
> leaves no way of to determine cause of death.
>=20
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>=20
> Hi Catherine,
>=20
> These are all the mods I needed to make to be able to understand the
> test failures I was getting as I debugged the new LARP recovery
> algorithm I've written.  You'll need to massage the test number in
> this patch to apply it on top of your patch.
>=20
> I haven't added any new test cases yet, nor have I done anything to
> manage the larp sysfs knob, but we'll need to do those in the near
> future.
>=20
> Zorro, can you consider merging this test in the near future?  We're
> right at the point of merging the upstream kernel code and so really
> need to start growing the test coverage of this feature, and this
> test should simply not-run on kernels that don't have the feature
> enabled....
>=20
> Cheers,
>=20
> Dave.

Looks good, thanks for the fixes
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>

> ---
>=20
> tests/xfs/600     |  20 +++++-----
> tests/xfs/600.out | 109 ++++++++++++++++++++++++++++++++++++-------------=
-----
> 2 files changed, 85 insertions(+), 44 deletions(-)
>=20
> diff --git a/tests/xfs/600 b/tests/xfs/600
> index 252cdf27..84704646 100755
> --- a/tests/xfs/600
> +++ b/tests/xfs/600
> @@ -16,7 +16,7 @@ _begin_fstest auto quick attr
>=20
> _cleanup()
> {
> -	rm -rf $tmp.* $testdir
> +	rm -rf $tmp.*
> 	test -w /sys/fs/xfs/debug/larp && \
> 		echo 0 > /sys/fs/xfs/debug/larp
> }
> @@ -46,7 +46,9 @@ test_attr_replay()
> 	touch $testfile
>=20
> 	# Verify attr recovery
> -	{ $ATTR_PROG -g $attr_name $testfile | md5sum; } 2>&1 | _filter_scratch
> +	$ATTR_PROG -l $testfile | _filter_scratch
> +	echo -n "$attr_name: "
> +	$ATTR_PROG -q -g $attr_name $testfile | md5sum;
>=20
> 	echo ""
> }
> @@ -157,19 +159,19 @@ create_test_file remote_file2 1 $attr64k
> test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
> test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
>=20
> -# replace shortform
> +# replace shortform with different value
> create_test_file sf_file 2 $attr64
> -test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"
> +test_attr_replay sf_file "attr_name2" $attr16 "s" "larp"
>=20
> -# replace leaf
> -create_test_file leaf_file 2 $attr1k
> -test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"
> +# replace leaf with different value
> +create_test_file leaf_file 3 $attr1k
> +test_attr_replay leaf_file "attr_name2" $attr256 "s" "larp"
>=20
> -# replace node
> +# replace node with a different value
> create_test_file node_file 1 $attr64k
> $ATTR_PROG -s "attr_name2" -V $attr1k $testdir/node_file \
> 		>> $seqres.full
> -test_attr_replay node_file "attr_name2" $attr1k "s" "larp"
> +test_attr_replay node_file "attr_name2" $attr256 "s" "larp"
>=20
> echo "*** done"
> status=3D0
> diff --git a/tests/xfs/600.out b/tests/xfs/600.out
> index 96b1d7d9..fe25ea3e 100644
> --- a/tests/xfs/600.out
> +++ b/tests/xfs/600.out
> @@ -4,146 +4,185 @@ QA output created by 600
> attr_set: Input/output error
> Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
> touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
> -21d850f99c43cc13abbe34838a8a3c8a  -
> +Attribute "attr_name" has a 65 byte value for SCRATCH_MNT/testdir/empty_=
file1
> +attr_name: cfbe2a33be4601d2b655d099a18378fc  -
>=20
> attr_remove: Input/output error
> Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file1
> touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
> -attr_get: No data available
> -Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file1
> +attr_name: attr_get: No data available
> +Could not get "attr_name" for /mnt/scratch/testdir/empty_file1
> d41d8cd98f00b204e9800998ecf8427e  -
>=20
> attr_set: Input/output error
> Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
> touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
> -2ff89c2935debc431745ec791be5421a  -
> +Attribute "attr_name" has a 1025 byte value for SCRATCH_MNT/testdir/empt=
y_file2
> +attr_name: 9fd415c49d67afc4b78fad4055a3a376  -
>=20
> attr_remove: Input/output error
> Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file2
> touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
> -attr_get: No data available
> -Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file2
> +attr_name: attr_get: No data available
> +Could not get "attr_name" for /mnt/scratch/testdir/empty_file2
> d41d8cd98f00b204e9800998ecf8427e  -
>=20
> attr_set: Input/output error
> Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file3
> touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
> -5d24b314242c52176c98ac4bd685da8b  -
> +Attribute "attr_name" has a 65536 byte value for SCRATCH_MNT/testdir/emp=
ty_file3
> +attr_name: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>=20
> attr_remove: Input/output error
> Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file3
> touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
> -attr_get: No data available
> -Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file3
> +attr_name: attr_get: No data available
> +Could not get "attr_name" for /mnt/scratch/testdir/empty_file3
> d41d8cd98f00b204e9800998ecf8427e  -
>=20
> attr_set: Input/output error
> Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output erro=
r
> -5a7b559a70d8e92b4f3c6f7158eead08  -
> +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inlin=
e_file1
> +Attribute "attr_name2" has a 65 byte value for SCRATCH_MNT/testdir/inlin=
e_file1
> +attr_name2: cfbe2a33be4601d2b655d099a18378fc  -
>=20
> attr_remove: Input/output error
> Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output erro=
r
> -attr_get: No data available
> -Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inlin=
e_file1
> +attr_name2: attr_get: No data available
> +Could not get "attr_name2" for /mnt/scratch/testdir/inline_file1
> d41d8cd98f00b204e9800998ecf8427e  -
>=20
> attr_set: Input/output error
> Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output erro=
r
> -5717d5e66c70be6bdb00ecbaca0b7749  -
> +Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/inl=
ine_file2
> +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inlin=
e_file2
> +attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>=20
> attr_remove: Input/output error
> Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output erro=
r
> -attr_get: No data available
> -Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inlin=
e_file2
> +attr_name2: attr_get: No data available
> +Could not get "attr_name2" for /mnt/scratch/testdir/inline_file2
> d41d8cd98f00b204e9800998ecf8427e  -
>=20
> attr_set: Input/output error
> Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output erro=
r
> -5c929964efd1b243aa8cceb6524f4810  -
> +Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/in=
line_file3
> +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inlin=
e_file3
> +attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>=20
> attr_remove: Input/output error
> Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file3
> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output erro=
r
> -attr_get: No data available
> -Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file3
> +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inlin=
e_file3
> +attr_name2: attr_get: No data available
> +Could not get "attr_name2" for /mnt/scratch/testdir/inline_file3
> d41d8cd98f00b204e9800998ecf8427e  -
>=20
> attr_set: Input/output error
> Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output erro=
r
> -51ccb5cdfc9082060f0f94a8a108fea0  -
> +Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/ext=
ent_file1
> +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ext=
ent_file1
> +attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>=20
> attr_remove: Input/output error
> Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file1
> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output erro=
r
> -attr_get: No data available
> -Could not get "attr_name2" for SCRATCH_MNT/testdir/extent_file1
> +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ext=
ent_file1
> +attr_name2: attr_get: No data available
> +Could not get "attr_name2" for /mnt/scratch/testdir/extent_file1
> d41d8cd98f00b204e9800998ecf8427e  -
>=20
> attr_set: Input/output error
> Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output erro=
r
> -8d530bbe852d8bca83b131d5b3e497f5  -
> +Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/ext=
ent_file2
> +Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/ext=
ent_file2
> +Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/ext=
ent_file2
> +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ext=
ent_file2
> +attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
>=20
> attr_set: Input/output error
> Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output erro=
r
> -5d77c4d3831a35bcbbd6e7677119ce9a  -
> +Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/ext=
ent_file3
> +Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/ext=
ent_file3
> +Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/ext=
ent_file3
> +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ext=
ent_file3
> +attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
>=20
> attr_set: Input/output error
> Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output erro=
r
> -6707ec2431e4dbea20e17da0816520bb  -
> +Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/ex=
tent_file4
> +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ext=
ent_file4
> +attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>=20
> attr_remove: Input/output error
> Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output erro=
r
> -attr_get: No data available
> -Could not get "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ext=
ent_file4
> +attr_name2: attr_get: No data available
> +Could not get "attr_name2" for /mnt/scratch/testdir/extent_file4
> d41d8cd98f00b204e9800998ecf8427e  -
>=20
> attr_set: Input/output error
> Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
> touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output erro=
r
> -767ebca3e4a6d24170857364f2bf2a3c  -
> +Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/rem=
ote_file1
> +Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/re=
mote_file1
> +attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>=20
> attr_remove: Input/output error
> Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file1
> touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output erro=
r
> -attr_get: No data available
> -Could not get "attr_name2" for SCRATCH_MNT/testdir/remote_file1
> +Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/re=
mote_file1
> +attr_name2: attr_get: No data available
> +Could not get "attr_name2" for /mnt/scratch/testdir/remote_file1
> d41d8cd98f00b204e9800998ecf8427e  -
>=20
> attr_set: Input/output error
> Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file2
> touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output erro=
r
> -fd84ddec89237e6d34a1703639efaebf  -
> +Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/re=
mote_file2
> +Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/re=
mote_file2
> +attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>=20
> attr_remove: Input/output error
> Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
> touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output erro=
r
> -attr_get: No data available
> -Could not get "attr_name2" for SCRATCH_MNT/testdir/remote_file2
> +Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/re=
mote_file2
> +attr_name2: attr_get: No data available
> +Could not get "attr_name2" for /mnt/scratch/testdir/remote_file2
> d41d8cd98f00b204e9800998ecf8427e  -
>=20
> attr_set: Input/output error
> Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
> touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
> -34aaa49662bafb46c76e377454685071  -
> +Attribute "attr_name1" has a 64 byte value for SCRATCH_MNT/testdir/sf_fi=
le
> +Attribute "attr_name2" has a 17 byte value for SCRATCH_MNT/testdir/sf_fi=
le
> +attr_name2: 9a6eb1bc9da3c66a9b495dfe2fe8a756  -
>=20
> attr_set: Input/output error
> Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
> touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error
> -664e95ec28830ffb367c0950026e0d21  -
> +Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/leaf=
_file
> +Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/lea=
f_file
> +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/lea=
f_file
> +attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>=20
> attr_set: Input/output error
> Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
> touch: cannot touch 'SCRATCH_MNT/testdir/node_file': Input/output error
> -bb37a78ce26472eeb711e3559933db42  -
> +Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/node=
_file
> +Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/no=
de_file
> +attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>=20
> *** done
> --=20
> Dave Chinner
> david@fromorbit.com

