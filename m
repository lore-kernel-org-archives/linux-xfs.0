Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBEAC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 12:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiLMMcx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 07:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiLMMcw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 07:32:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAB8E000
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 04:32:48 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDBwxBo002866;
        Tue, 13 Dec 2022 12:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=uKr9w63ZYFqsXDhuGG0wMYkhdMgz/HYexizYGyGVJIQ=;
 b=caHmhm912dPIGkWCEAoYym6goVrPmiUuuGy//p3FbNubJUKyf0yKJHFRsEZAfAyN7ecC
 I4NONWsCXk56i1HTbpPCd9/DcYuonOdN64mvQO+r9jC+1skyk3xT5k0BFuujd28fjZEB
 F7uUCLDN7jIOCY1uLD4BvJUwUFFfbKbEmb1WUjImwutnc99S0B5p1lvVJtfuaHnPd8EK
 MJJTzdHaZsdGBT0lWhcjHEqYnLrJosurun2nGW7NyLClzh5c7HIc5Y86ImYdbS1Rin0a
 Mpozt4I5ZUxLBUf5iaqjx28Q0IJ0D5cu1f/uVF16/fUrtq7GJQIkdw+KlSmu6NvaLwFG eA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mchqsw78j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 12:32:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDBYTaQ009275;
        Tue, 13 Dec 2022 12:32:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj5kjr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 12:32:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9fekBSPzzH+cH+G5XDm+h/fZZIHVu4uEoQ6A8DUv66781UpteYAWvQ9VR1HfKa8ig1pm0KRYdAIqHs4amgPWWz8XFO/ukeSsV+2fo+vQExMG4DAraJtYWoumUoEFwzlzAyGFGM2JcUm85pPi3lqa3cZErh7RbsUBKCtgIGEV6D74wfBQuNsoHElmeb0dF8pDstQMTxjNCtjSgCfWUhcO27LZKHyrBOHLQP+rBXEr9StL0LEeT0IfINSD2fQ0691jjdjVvoaO5rTNz66FZ/4PvnzK26i642IPnYFv2kV+Lq58PwPTYB0jrL5cvxdfe+Mk4uM2C8m5dmZh7Wdi9OOeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKr9w63ZYFqsXDhuGG0wMYkhdMgz/HYexizYGyGVJIQ=;
 b=jBIDej0luGPUUaK2t4ya2V8a+YKzmlfDAZ3Xxm2Bt1zEpSJCmp4YmyAGe+2cOvX0JbRJnBQvIQbHsUjc3z7Jg0eRV7RNi/km27vUhe54ZSK5pYCIzI0NpzXGn2HNPfWn7/XGRYfZ4V3YJzHOIRq2aoeKr1OzHmYMtrwO8Gwzni0cppxMSVAnJ5D7BRQapaWCoGH3kkhHR7MuC28jFbY2AWRHO6tJjqpI1JWePzANELmt2EM6pyCBuIN5LV1pFm6gZT86R/SpX/SFPBvVui07k10yp6hOxZqoXl1Dbc3sIM8yf4vhVbMb9HEJJvbj60qGihFtvJfB4iugF7752PId2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKr9w63ZYFqsXDhuGG0wMYkhdMgz/HYexizYGyGVJIQ=;
 b=y1FxbKXjn7WyPI+CvSU/CuiRMHcFmD4/CJSD9+4cE7fSV9pkb4pGGyAm2Px6rceS7Tg/VNzrg1Lx6vqFFjczDCoPyhpzS65PcWgQx8qwSRUuMLGBzObVNEX9hU2TgwNU4uA+gcVyN1K3PL/+h2aBsuvxdZfSE0Bf+6+ecR3t22k=
Received: from MWHPR10MB1486.namprd10.prod.outlook.com (2603:10b6:300:24::13)
 by PH0PR10MB5730.namprd10.prod.outlook.com (2603:10b6:510:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 12:32:41 +0000
Received: from MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::fe5c:7287:5e2d:4194]) by MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::fe5c:7287:5e2d:4194%10]) with mapi id 15.20.5880.019; Tue, 13 Dec
 2022 12:32:41 +0000
From:   Srikanth C S <srikanth.c.s@oracle.com>
To:     Carlos Maiolino <cem@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Darrick Wong <darrick.wong@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>
Subject: RE: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
 replay log before running xfs_repair
Thread-Topic: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
 replay log before running xfs_repair
Thread-Index: AQHY/wVBvROg5/0DFkCHIEtc3i5PT65rr5oAgAAuw4A=
Date:   Tue, 13 Dec 2022 12:32:41 +0000
Message-ID: <MWHPR10MB14869C35BE8213C7BFA3AC3DA3E39@MWHPR10MB1486.namprd10.prod.outlook.com>
References: <NdSU2Rq0FpWJ3II4JAnJNk-0HW5bns_UxhQ03sSOaek-nu9QPA-ZMx0HDXFtVx8ahgKhWe0Wcfh13NH0ZSwJjg==@protonmail.internalid>
 <20221123063050.208-1-srikanth.c.s@oracle.com>
 <20221213093940.2ibze6idpozpthrd@andromeda>
In-Reply-To: <20221213093940.2ibze6idpozpthrd@andromeda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR10MB1486:EE_|PH0PR10MB5730:EE_
x-ms-office365-filtering-correlation-id: a0d2c198-1824-42e1-2bc9-08dadd062084
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bXWjleUCKvk7+l/4ujHnwMxrSKF0F+YbfNQnTBwbQ1PXQ7hORrLfhFyntzvytyPa1+npVVb/h+Xu1a6fVb9KtCC0xTv32FkIOIJsVBkl3oaSBP8Vrq/kPGsPYuLmY9frdixpxFV6w0SXgjf8jSDALJLrErzPiy27JbLboeYav6H7zY6lDYDvQymW8FTtAXFaloWFHRmTUu7DxQLe+qZ7l4ywlHzZ08m3AggCYnbne6ty3xMoBZrI/WGbG0bTq4WFs8bfmnH/iLg2SRJpgTX00FWxBxVBUPJJPsukIQ+wsIRq6NWwyiQlkaHCuJQO/Mvd+/d0JwaVWo/pt1TJaW2THMEaKLhRtSGWP2yxmThdv01+75HgI6PLWfOR2WRf2yglcMkCn/+WWsx3Zo3BFu97pUUXAdaAUpI8BmLl2K6mX/T4RXx5dr6ujEJ49GFdBS1BaM0Nl3l0oZjwQQRRXIX3AgJm0/PGSt9oHL2XKmNKsvGM5dDShZh0Kn/g0TkLatQvntttATILtDRIKBkv3WINXp2cgN1eewnhLfYZLAc2378uBHe5zChbNMazwYq0zMijWrDC17LZ8NPTr68+EuJ72ZHEqfFb+fEYDwG96gMsU1t+XTxK3Wli9ITA62+qkLJwiP+3RaGmP6tcijkWvKNuTC5/3AifZ+SODaqIg1lHYiZWaMTyD93k3Z5Dz/QJOsER0p59DkeZD2eGeu3vFqoKLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1486.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(55016003)(66946007)(86362001)(6506007)(6916009)(26005)(33656002)(9686003)(7696005)(54906003)(186003)(478600001)(41300700001)(83380400001)(2906002)(8936002)(52536014)(5660300002)(66556008)(38100700002)(4326008)(66446008)(66476007)(71200400001)(76116006)(64756008)(316002)(38070700005)(8676002)(122000001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fSN4EBHAgEnzd9R2VtPbIRtPOMP+nwBet4XFB3ocSFy7ArqglkwcjYLG2LL8?=
 =?us-ascii?Q?QOCEfRCWvYlUP+3Yuwnhc42SDdk+kNfUWtYd17cInjdwTCec7ZsdapQpQr+4?=
 =?us-ascii?Q?Ct7izri97/3tnfZLOp5syVLS7DcfnXX4g14a55nfXRi5G5y6UqvHy94u3as9?=
 =?us-ascii?Q?bq7c8tsjDA9PZ/V6rQdz4NrlL6fB2zH8sX7j1QOXU84fnVbZ8EiabFHqZ6e+?=
 =?us-ascii?Q?eoMJfxC4ygFnTsN9sBz4+ziRSJgRbxzKY713G5/KZ0uOPa0toze2BruSW6od?=
 =?us-ascii?Q?NO7fYa2R3nvBZJkXP8Sw6zNoXu/JDcJIyzexEBFLQdAwVtyLzdcOfI82hdhQ?=
 =?us-ascii?Q?zWRKzWyjJw6PEC9NSHmRD560J7QmnsjdRZaRNw7ZK4hAuTWI1dcLkAeAPNkt?=
 =?us-ascii?Q?HrIK/lQZCuagv/LvSlo3irQ6XvJsinhgrYG9ABHuEf8BeBS0k+AWnkUK4kAA?=
 =?us-ascii?Q?Q8ywEISHfMY/fDlaNrQwNwu6826yy0JcL7QtHH3UUjgcnkpWkT/msi4a29ZC?=
 =?us-ascii?Q?wL4kWBFrX3ogKFQ7Glm2cRHo/xZrOVjzxH+ajxVCek0tXqe91zvLiiMOIKho?=
 =?us-ascii?Q?27Xg2QkXKQHLQp7vRFHFdTnrCm1nz0rtUqCxsQKNBHPLYGD+ZmMOPoBit844?=
 =?us-ascii?Q?BRYKUSzsg2xN7ztrneKztzH0j4gQYd2kLCmG8V0gIVNASG8P+/wvqYVW8xzp?=
 =?us-ascii?Q?vfsxWiKyEFpIdvm2bNiFneaFXKlIbna8N49RmXjoOtyzN2pVGvJr/Dbw0Ex9?=
 =?us-ascii?Q?LaTQ5me+M0hZ/NYQjszyCnpqnt+k38Sps4Es31EJ9DRO8FHkL5YKMdExyTo6?=
 =?us-ascii?Q?IaBWc/AElYhJ+imR1OOtlS32jDQ6KwaPzCy6mK+5C3vj4I3ahIyBny6XPaBO?=
 =?us-ascii?Q?FE1GbJSR/+aYyxb81gFd53IAQgZLrhz0xkRvPhwUMEy43AZ5lpKsgCrSRoid?=
 =?us-ascii?Q?QupzihmMsFSl6xoAVztlRbyeLyFXXYsvQrJu67x2VK4qiaU7/houDmGO52s+?=
 =?us-ascii?Q?nAyzkpwT1N+CNKIEx36cq//3m/PuEHI2L7WIvuyFS24IV2U6DVlDWTsWB0Qn?=
 =?us-ascii?Q?5pLtoduquVk3ooGwJ5XdI/SXw0eEw9HMQbMeRWEh792349BV0VRZuBu/pJr8?=
 =?us-ascii?Q?rjcW6TwcMezTFPiWW+6Z64bwL7B7EBEvKl5atRFuM2L0rFS8PMixf/2uRsSE?=
 =?us-ascii?Q?BWuqwz4aKLV3Jj61SWinJrsfAq1E25Agk8axeMDLMKnrjmH2a2c/vm7ZgQzE?=
 =?us-ascii?Q?BnFnxsVnBAKsq0nhz1t+hPSYip+qwTmEU7XmrfE223wWopplT/FwCowFvqhi?=
 =?us-ascii?Q?MF1ywXDPz9ZBVmGTP4XrSLapyj66WJI4rACAA0eTiYzedhgIApeJHQFeaAw9?=
 =?us-ascii?Q?ZcG5sWlocFm+vDVcia4gC9xHEP32zEn+mHnYeRmdDsEZ/5s1dvah1x2uh1HS?=
 =?us-ascii?Q?ehoN5JgLBzY5GWvBQNxzHO5Au1AYOtiCCVwcnPgAcdCVY010Js+YWloMscpD?=
 =?us-ascii?Q?mzmiM3f190xgWXwD0fr4eOaeZOJacvTscyq+aGPBK3fVnWxwWBh12kPVPA+Q?=
 =?us-ascii?Q?ySlyzCocoEvmjM8fBlQt9I/iUfKF4CAwAxUpLcVz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1486.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d2c198-1824-42e1-2bc9-08dadd062084
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 12:32:41.0796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Pl1CLZJVwqI/UmPCkKgQgM5/tVQOAiFhbcD/S7LARBgnBgXvnQJt++oqFH2oY/SbThdkGw2nobTpyj9QHyoqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130110
X-Proofpoint-ORIG-GUID: XmSw_IE9fqnEWXo61HH8xBguQQ_C1053
X-Proofpoint-GUID: XmSw_IE9fqnEWXo61HH8xBguQQ_C1053
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> -----Original Message-----
> From: Carlos Maiolino <cem@kernel.org>
> Sent: 13 December 2022 03:10 PM
> To: Srikanth C S <srikanth.c.s@oracle.com>
> Cc: linux-xfs@vger.kernel.org; Darrick Wong <darrick.wong@oracle.com>;
> Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>;
> Junxiao Bi <junxiao.bi@oracle.com>; david@fromorbit.com
> Subject: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to rep=
lay
> log before running xfs_repair
>=20
> Hi Srikanth.
>=20
> On Wed, Nov 23, 2022 at 12:00:50PM +0530, Srikanth C S wrote:
> > After a recent data center crash, we had to recover root filesystems
> > on several thousands of VMs via a boot time fsck. Since these machines
> > are remotely manageable, support can inject the kernel command line
> > with 'fsck.mode=3Dforce fsck.repair=3Dyes' to kick off xfs_repair if th=
e
> > machine won't come up or if they suspect there might be deeper issues
> > with latent errors in the fs metadata, which is what they did to try
> > to get everyone running ASAP while anticipating any future problems.
> > But, fsck.xfs does not address the journal replay in case of a crash.
> >
> > fsck.xfs does xfs_repair -e if fsck.mode=3Dforce is set. It is possible
> > that when the machine crashes, the fs is in inconsistent state with
> > the journal log not yet replayed. This can drop the machine into the
> > rescue shell because xfs_fsck.sh does not know how to clean the log.
> > Since the administrator told us to force repairs, address the
> > deficiency by cleaning the log and rerunning xfs_repair.
> >
> > Run xfs_repair -e when fsck.mode=3Dforce and repair=3Dauto or yes.
> > Replay the logs only if fsck.mode=3Dforce and fsck.repair=3Dyes. For ot=
her
> > option -fa and -f drop to the rescue shell if repair detects any
> > corruptions.
> >
> > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > ---
> >  fsck/xfs_fsck.sh | 31 +++++++++++++++++++++++++++++--
> >  1 file changed, 29 insertions(+), 2 deletions(-)
>=20
> Did you by any chance wrote this patch on top of something else you have =
in
> your tree?
>=20
> It doesn't apply to the tree without tweaking it, and the last changes we=
've in
> the fsck/xfs_fsck.sh file are from 2018, so I assume you have something
> before this patch in your tree.
>=20
Sorry for the inconvenience, will verify this.

> Could you please rebase this patch against xfsprogs for-next and resend i=
t?
> Feel free to keep my RwB as long as you don't change the code semantics.
>=20
Let me rebase the patch and resend it. Thanks for the Reviewed by.

> Cheers.
>=20
> >
> > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh index
> > 6af0f22..62a1e0b 100755
> > --- a/fsck/xfs_fsck.sh
> > +++ b/fsck/xfs_fsck.sh
> > @@ -31,10 +31,12 @@ repair2fsck_code() {
> >
> >  AUTO=3Dfalse
> >  FORCE=3Dfalse
> > +REPAIR=3Dfalse
> >  while getopts ":aApyf" c
> >  do
> >         case $c in
> > -       a|A|p|y)        AUTO=3Dtrue;;
> > +       a|A|p)          AUTO=3Dtrue;;
> > +       y)              REPAIR=3Dtrue;;
> >         f)              FORCE=3Dtrue;;
> >         esac
> >  done
> > @@ -64,7 +66,32 @@ fi
> >
> >  if $FORCE; then
> >         xfs_repair -e $DEV
> > -       repair2fsck_code $?
> > +       error=3D$?
> > +       if [ $error -eq 2 ] && [ $REPAIR =3D true ]; then
> > +               echo "Replaying log for $DEV"
> > +               mkdir -p /tmp/repair_mnt || exit 1
> > +               for x in $(cat /proc/cmdline); do
> > +                       case $x in
> > +                               root=3D*)
> > +                                       ROOT=3D"${x#root=3D}"
> > +                               ;;
> > +                               rootflags=3D*)
> > +                                       ROOTFLAGS=3D"-o ${x#rootflags=
=3D}"
> > +                               ;;
> > +                       esac
> > +               done
> > +               test -b "$ROOT" || ROOT=3D$(blkid -t "$ROOT" -o device)
> > +               if [ $(basename $DEV) =3D $(basename $ROOT) ]; then
> > +                       mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1
> > +               else
> > +                       mount $DEV /tmp/repair_mnt || exit 1
> > +               fi
> > +               umount /tmp/repair_mnt
> > +               xfs_repair -e $DEV
> > +               error=3D$?
> > +               rm -d /tmp/repair_mnt
> > +       fi
> > +       repair2fsck_code $error
> >         exit $?
> >  fi
> >
> > --
> > 1.8.3.1
>=20
> --
> Carlos Maiolino

Thanks,
Srikanth
