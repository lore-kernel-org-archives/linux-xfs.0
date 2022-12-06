Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B094C352A1
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Dec 2022 11:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbiLFLs5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 06:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234724AbiLFLsz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 06:48:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DAB27FC5
        for <linux-xfs@vger.kernel.org>; Tue,  6 Dec 2022 03:48:45 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B69xNuf015745;
        Tue, 6 Dec 2022 11:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=WQLWTBD/T/WU8MMl/tRv4l+TZEBjPQmjHz3B+d79n6o=;
 b=Nuz3qe4cQ5M/JACaccGNJnTZ7gRjbvGRha0oGQJJ1euEWqZF+9iQYHYlqq/gyaW2/MRZ
 swqN3AxWGXhstBlCLbMKng+fm7r2aWR/r4Iohr/lcCXpJiZjk8Kv24ykJ5EO8H2yzOaM
 ZqzElLjT6zRCGTPnG2Ur2cXk70Dze13LEcGrFqF/tecVppq5RwcKGbf8S9F4lUO8CmH4
 U44wNBsjDsoM3Tq65sct/U0pKSSIXSbKRhaCjFGLogeHpOq/wUicpObAJaptEk16C1Xq
 XqPXx2ZYkqDZsrRL/CRLyll5PzETuFqfPPJAKZ0VqVIUS/tRupdNl3JcGzlKaOIiyxsF 2A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ycf74yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 11:48:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6Aii4B012691;
        Tue, 6 Dec 2022 11:48:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m8u93ev11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 11:48:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SV0wCWVAroU28I7LjKXRxPCrn7hNmEPZqT5l/x+AD+rsTw5URUZV4MiDEk/UNxTiGQjlFix5yw+JaUtNHHOz6E2TaDSE0AKdiarXnAE5Drxgq+Pj0j8qjlWmLnrOYBDQfPaw9OjXCgzyHDRGHolPDQjtnBVJzflEfP6PQJYmy6RGX5hMfZWna1gRnTLxQ3lxjnB7YeTMvImwyzpJN4Ji5+RTXSFxeR4D+SXLCcIe5phSQyq7U4ZfB/X/xTBlwIddJ8Cj031WS7urXndleiK4L2HaSeXFPMv0COZJcT21bPkFjCkv3dD/rNhUiGVNYtaPhsXG1IwWpWkk6bkDYcGIsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WQLWTBD/T/WU8MMl/tRv4l+TZEBjPQmjHz3B+d79n6o=;
 b=iXWiijJ+EXd/HD8WMRY7F7+oq4VUgZqj5w7E0meeScGBeFT97K9Lsyiix/jp+SH1ItXjQykf4qr1JHWB4Vu0P5XU7nIaO/OYuV4NNVZgtrZUzjw0AXAl7oDOHaGhjx1+yOlmKsuNiPLUx4kwRKxsvyk0IA7sV5wgMUzGJKUmFRUqR7W0YNBOxzFdaGStKWeOIhvY+fLOqqj424meROVTt6QHCP4aAcfK+R+3vhlVH18WVJHYZprI2ostGsSN050cHf0jMB8SdGy1wFYHK1GL7lwLhCBXn5gfkNP8DB5Dj7x6mx/wgE1M0f8dvc7YZyIlVhBG246CX7An1OMu9RPBbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQLWTBD/T/WU8MMl/tRv4l+TZEBjPQmjHz3B+d79n6o=;
 b=WX4qy9Zfv2KEC+aaj3UQ3kzdTF3TR/9iCWuirvAuUtspKa1vKLSmR91PZFskeXXChJWJEIKopiDqyPKidS2zmnp55CR2nVOHFyAxbdmCkbtsyEMFrfA+Fd+bpH16sbfi6lXxU0fjZ47sSq0rjVq37imTRG/pZoltHhgJ5ZkCPcU=
Received: from MWHPR10MB1486.namprd10.prod.outlook.com (2603:10b6:300:24::13)
 by MW5PR10MB5805.namprd10.prod.outlook.com (2603:10b6:303:192::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 11:48:39 +0000
Received: from MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::fe5c:7287:5e2d:4194]) by MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::fe5c:7287:5e2d:4194%10]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 11:48:39 +0000
From:   Srikanth C S <srikanth.c.s@oracle.com>
To:     Carlos Maiolino <cem@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Darrick Wong <darrick.wong@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: RE: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
 replay log before running xfs_repair
Thread-Topic: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
 replay log before running xfs_repair
Thread-Index: AQHY/wVBvROg5/0DFkCHIEtc3i5PT65ML1oAgAAzUxuAAAv1gIADHnuQgAVwVwCAC9VmMA==
Date:   Tue, 6 Dec 2022 11:48:38 +0000
Message-ID: <MWHPR10MB1486C55C14A9D4F8CA32D33DA31B9@MWHPR10MB1486.namprd10.prod.outlook.com>
References: <NdSU2Rq0FpWJ3II4JAnJNk-0HW5bns_UxhQ03sSOaek-nu9QPA-ZMx0HDXFtVx8ahgKhWe0Wcfh13NH0ZSwJjg==@protonmail.internalid>
 <20221123063050.208-1-srikanth.c.s@oracle.com>
 <20221123083636.el5fivqey5qmx6ie@andromeda>
 <c-vuqhpmmrL6JSN0ZRnqX7c1BUcXw5gJ9L2UZ2lG3H8hCJRNIn_uan2rVHLDUPwgY24Nv3WZpiBt2nflhVadtA==@protonmail.internalid>
 <CY4PR10MB1479D19A047EAB8558445EC7A30C9@CY4PR10MB1479.namprd10.prod.outlook.com>
 <20221123122305.oht2bspxqb6ndnlm@andromeda>
 <MWHPR10MB148619277A997E1D8A715257A30E9@MWHPR10MB1486.namprd10.prod.outlook.com>
 <Y4U+dDlv2ylHApxo@magnolia>
In-Reply-To: <Y4U+dDlv2ylHApxo@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR10MB1486:EE_|MW5PR10MB5805:EE_
x-ms-office365-filtering-correlation-id: 6334a2c5-26ed-489d-ca28-08dad77fd0d3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6eOcnymzl8ouB3vSOhNuQxN6fj0PS6WBtX2Rjsbn8/BDIiDGFr+GSjDfTRdxt308Xkax5bX9IAIHelGrx1rTbI6PsnCfhlcj8wNWNhqPGPbaOF6H7LVLZSzNYTMiMbh/nLZqe/OQKBIUNCkyLHxiTmYVNu/zo4jb1mld91bdD5TKIVDYtMjiKe863i76giqPdX3AVBmcFmx8JEMLvD3LGHW5DoABUOSzKKuE0oOk3CBX6cWg7OI2LWg4vFPP0mGng4Z1jLtrEgofewwi1WCDmVcu5y7CD6R/UJtgwf+TUtoF6xsSUrn3roSEX+Gr7kPrAzExucFlw+fvdGnpNHPVqaH87OP2y6iXq1Zz9qahKFw6b0ET3+AwXpL4uNVvv4UyjHe5YyckQDua5lA/CsSmXdSZcvdTc1jbUV3Pe2m5EL1IiGTyYdjpCh44vIKLSiHL6jBgIALgdXANHg0Dkz5gwdL/tPs6rNICGKhkKX7JH83Au+sp0YJhgdoG0DRuOyWr6C2R72aN1rLJtn7wyMpEl4/gIaBDRKk8YbHka1/Z4PClp2QaLv0wOZCZBClZsgJP0T3xkiCRUs0qQMUjmLhTxbjVGtOmX0C9Ivx0kjxkEfOzM6N5lglbuYXRFx9zx/O08g/E1x8hcHnPulJOLJxAYbQS88zLo4EXwpkCCtfGzUlEMcR+9hWBER46yiqgDInFcsV+xdwhMIe3NXMm12EAkJWve33aMjyRn0tz9WfT3oE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1486.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(38100700002)(86362001)(8936002)(41300700001)(2906002)(4326008)(5660300002)(38070700005)(83380400001)(122000001)(71200400001)(33656002)(478600001)(316002)(66556008)(66446008)(66946007)(66476007)(966005)(6916009)(54906003)(76116006)(55016003)(52536014)(8676002)(53546011)(186003)(26005)(9686003)(7696005)(64756008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YJetYZlADzQVuY47DPy6ya2t01o8tbdEov97aUIU7KIHhw2X0ppB8Fpww+K0?=
 =?us-ascii?Q?+A7WR75W8zVBVMV+4LDMeTWobAX7sDL58q6kEM1leb0gX6uzNS51tOQGNQAl?=
 =?us-ascii?Q?Zu9xvo1keOD/Tl75F9pMl5Tn5nXJPYbhguZnPrWiRO2jF6aPbu0mq30jVnXp?=
 =?us-ascii?Q?D3u8xK99IqJndbNl3NbaFAZTcUivm1vwWX0Vl3amLMGA7CLNamy7ojeywQFO?=
 =?us-ascii?Q?A36vMO6oTJw1clTyrEjektOF5vjAexNXNdiwaBuu/pYR79bHrWTFeSIXBQI+?=
 =?us-ascii?Q?xRyCWDb2TCJKKv7tZec3nRjviaPNJDAQZYF7x1hRMLmENGd3iNSUkVklk8Bq?=
 =?us-ascii?Q?cE2Mjc28xIxXOjCcj2Erhs6Ji7MzAcXA//HRTGwp/m5CVkb1KPqTLb/Y76fo?=
 =?us-ascii?Q?P3vt9F5kegvDAnejunglQzH/dylbR+yidY8mmFfLVMHF/e3NrTF6gzJWR/Jw?=
 =?us-ascii?Q?DzaC/MW1y33KF5l1UVvyyI1br8KkFGsd7qPwY07oC1TBeIPUeFz00j19xOsB?=
 =?us-ascii?Q?3REttO0IjOUoAB4xqpdRaUPmTqSpzX241SReXRtiiEFpKkPRTPgKywvRjlNY?=
 =?us-ascii?Q?z4wpKirMr/k1EBrfCSdm3w5yUHjJIlviRtqpjHyGhEcBrKvYwF5ns3P71gzZ?=
 =?us-ascii?Q?ekgPupApBL2o15Uqmi17uU5m5cAlMr9ls9UCil9MuvRsiE3an1IJuYDpZMxn?=
 =?us-ascii?Q?4J1UewOtrCc2+2e0gnPHEGWn9ARIIwJmdGHNkY5KMHyOKnIbA0xO+CFV11iU?=
 =?us-ascii?Q?afW9mexVwd+dVEXcL/9O5IIonx7VI2qJnAOlI4/C5wHoryg/Zs/6pJTeC0BL?=
 =?us-ascii?Q?s3Tp/l4Z1J27Tw7KZs9MTrK9mCyIzcTHyIgj5dvf2peDn+EhA5XsLj8oSD6D?=
 =?us-ascii?Q?GuswcfOnex0cKkvGHtS186JIADrLefVThfpDwuEOXo9w+LOcD+mRO+7Q4xGA?=
 =?us-ascii?Q?5lwn9AKzq+GosaB3L9oAVuzxrYYvyM7d5F2jtA/loiTDyvI5QBCGRc+q6KLb?=
 =?us-ascii?Q?hf4ioMOfklL9HCffxFYqGY+guMWbSMbPeSI8G7D/hAtlnCs3fFjJT6vh+xw7?=
 =?us-ascii?Q?19BoTu8rOLAD7d9axESVmvcfBGxNMf0OSAG1bC2qb5jS0Qno0raXAf1O5Upz?=
 =?us-ascii?Q?FENAh2dJA6lNCoAB8XKNbc0u5W6R5c8iqxbVVA8NaB0c4Iu015g8mBp0GM2R?=
 =?us-ascii?Q?9qAF3pc8/uvITxRiZXKJVqmdbeWcmSF/0NVwjS31TiFnfvt/lLFdEczWCL9r?=
 =?us-ascii?Q?9hV8ZjNhj3VAiOMzEmmsoZgpRlqsWe5tII+Lt/NxKl1mTsgWEjbYsUz3dX/M?=
 =?us-ascii?Q?UPTTsCCN2n+2bk0JVY2rvOkS2q4pYvF08Hi5BEiw4Qh9b/VenDfS9sKKl4Zn?=
 =?us-ascii?Q?Z1aJU1sYZevsdjdo7bBPYVG5A6pvhruXn/aHmYiX2vv9QW4HmhZ1RizCGAAH?=
 =?us-ascii?Q?3sFxSrdAqgzkN/md1NccQ2dnV5BthIgngxizc1OiG2vPRgPjtzNHDl4Nq8g8?=
 =?us-ascii?Q?6HC3X/0aLfUYwR3lNLBv38BQVvyQdMYArvGrkZ6t6ELGlaHumIRipozzZWxg?=
 =?us-ascii?Q?Y3rF5YarroOobOgMoJH+1uKIkBdeN1DjSVvpK26t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UqhYvGrTjhSJFCNHLI9sahLUDNk6ONo7wTzg+hSzI0L0M3Vpjxv8BiCCpOM7hDMAsPxFNm1cesx/nTytwDoKyWuVgdZCD3eJ51FHe/FnxWZ5M0CfRvJoyQzPA+lqbC+BaxT+h+jSiDZOWRCpxqjglIAo5GM/Ml3VhAOnETBBljMXQO1F8joxZO4Eew3kJpZvLsKBg7ax/ImKCeiYyHfYgnVcoeuMbHu+cEaqZ/2vYUV0/5QdJeOMPNPhybBVyzUJFOymWNYJEN8GcOwmXsxEQU96irWws1BUrv98sids1RX0tEInqSCn4ToN5bFINpth3F2aNNsPlCN6nMcQt2pN1ovYCqU/rMjl2WEynNe1/tG363gbaRmq+KuZ0Ar0lXzU9ZLWGzUn0lHrOKYO3Duqxx77jDzxuMhHAF+MQ98XEFqnpH8RBAwbGOX+6lZNoGCiuNBgzirF03yOUv4h/rFNQKGU2HhvJlO+x9uaVLmovMdChzb0X8nVlChR/oWqYBan24KGCfx+Tilh/JSGvn2LyE3w0hMeC4NyC9TlWrRGm+wa08DKu5d5N0d536anOKYByrlyGnuOQ8fgvUsOWTbeBGe/B4JIDmwpyvJOcCwpMz2Hhy9f7Ed0wt8F/YU2gAnz6Gfsex7gbNYZWyAxK/PzJ1cIRCRWCKh6vgJKraGj38TOJcDx5igJa7K4mBZlsga3tl31o9RqWoU512Y8w4iYSeJnBIs6mmb8ZpwgAGRHCyXFyjKJ/1H5PYwv1SOkfQXtspRn5K5dvvvHJq0dqF3Cwmxix+3pzkpDb2fLWY6HPe0Go+Be4ao8E+Bv3F014yJtKokbbXa1eTPUMpX4hR5MwB7kVx+9JaM5c2nHTFCKFog=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1486.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6334a2c5-26ed-489d-ca28-08dad77fd0d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 11:48:39.0080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KCMTdGvq47maNTCUjbZtA9jgPWNRbpY9+wIF2N9MgqORTdtqfMAXyS+VjCdUfCRV8rxUnfymAjpNbMdCRReVhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5805
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_07,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212060099
X-Proofpoint-ORIG-GUID: mFBpC4fs0enjkvVsh8hr6yfztBOvXmV2
X-Proofpoint-GUID: mFBpC4fs0enjkvVsh8hr6yfztBOvXmV2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> -----Original Message-----
> From: Darrick J. Wong <djwong@kernel.org>
> Sent: 29 November 2022 04:34 AM
> To: Srikanth C S <srikanth.c.s@oracle.com>
> Cc: Carlos Maiolino <cem@kernel.org>; linux-xfs@vger.kernel.org; Darrick
> Wong <darrick.wong@oracle.com>; Rajesh Sivaramasubramaniom
> <rajesh.sivaramasubramaniom@oracle.com>; Junxiao Bi
> <junxiao.bi@oracle.com>; david@fromorbit.com
> Subject: Re: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
> replay log before running xfs_repair
>=20
> On Fri, Nov 25, 2022 at 12:09:39PM +0000, Srikanth C S wrote:
> >
> >
> > > -----Original Message-----
> > > From: Carlos Maiolino <cem@kernel.org>
> > > Sent: 23 November 2022 05:53 PM
> > > To: Srikanth C S <srikanth.c.s@oracle.com>
> > > Cc: linux-xfs@vger.kernel.org; Darrick Wong
> > > <darrick.wong@oracle.com>; Rajesh Sivaramasubramaniom
> > > <rajesh.sivaramasubramaniom@oracle.com>;
> > > Junxiao Bi <junxiao.bi@oracle.com>; david@fromorbit.com
> > > Subject: Re: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs
> > > fs to replay log before running xfs_repair
> > >
> > > On Wed, Nov 23, 2022 at 11:40:53AM +0000, Srikanth C S wrote:
> > > >    Hi
> > > >
> > > >    I resent the same patch as I did not see any review comments.
> > >
> > > Unless I'm looking at the wrong patch, there were comments on your
> > > previous
> > > submission:
> > >
> > > https://urldefense.com/v3/__https://lore.kernel.org/linux-
> > > xfs/Y2ie54fcHDx5bcG4@B-P7TQMD6M-
> > > 0146.local/T/*t__;Iw!!ACWV5N9M2RV99hQ!J2Z-
> > >
> 2NThyyDm__z9ivhioF9QoHsaHh4Tk733jtNbVMPGeA2vbmbw3h4ZGxOywQF
> > > v_lA1Zs_jsUgr$
> > >
> > > Am I missing something?
>=20
> Err.... whose comments, Joseph's or Gao's?
>=20
> > All the previous comments addressing this patch were about having
> > journal replay code in the userspace. But Darricks comments indicate
> > that this requires making the log endian safe because of kernel's
> > inability to recover a log from a platform with a different
> > endianness.
> >
> > So I am still wondering on how to proceed with this patch. Any
> > comments would be helpful.
>=20
@Carlos Maiolino, Any comments or thoughts on this patch?

-Srikanth
> Same here, though the long holiday weekend probably didn't help.
>=20
> --D
>=20
> > > Also, if you are sending the same patch, you can 'flag' it as a
> > > resend, so, it's easier to identify you are simply resending the
> > > same patch. You can do it by appending/prepending 'RESEND', to the
> patch tag:
> > >
> > > [RESEND PATCH] <subject>
> > Thanks for the info. Didn't know this.
> > >
> > > Cheers.
> > >
> > > >
> > > >    -Srikanth
> > > >
> > > >
> > >
> __________________________________________________________
> > > ________
> > > >
> > > >    From: Carlos Maiolino <cem@kernel.org>
> > > >    Sent: Wednesday, November 23, 2022 2:06 PM
> > > >    To: Srikanth C S <srikanth.c.s@oracle.com>
> > > >    Cc: linux-xfs@vger.kernel.org <linux-xfs@vger.kernel.org>; Darri=
ck
> Wong
> > > >    <darrick.wong@oracle.com>; Rajesh Sivaramasubramaniom
> > > >    <rajesh.sivaramasubramaniom@oracle.com>; Junxiao Bi
> > > >    <junxiao.bi@oracle.com>; david@fromorbit.com
> > > <david@fromorbit.com>
> > > >    Subject: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs =
fs to
> > > >    replay log before running xfs_repair
> > > >
> > > >    Hi.
> > > >    Did you plan to resend V3 again, or is this supposed to be V4?
> > > >    On Wed, Nov 23, 2022 at 12:00:50PM +0530, Srikanth C S wrote:
> > > >    > After a recent data center crash, we had to recover root files=
ystems
> > > >    > on several thousands of VMs via a boot time fsck. Since these
> > > >    > machines are remotely manageable, support can inject the kerne=
l
> > > >    > command line with 'fsck.mode=3Dforce fsck.repair=3Dyes' to kic=
k off
> > > >    > xfs_repair if the machine won't come up or if they suspect the=
re
> > > >    > might be deeper issues with latent errors in the fs metadata, =
which
> > > >    > is what they did to try to get everyone running ASAP while
> > > >    > anticipating any future problems. But, fsck.xfs does not addre=
ss the
> > > >    > journal replay in case of a crash.
> > > >    >
> > > >    > fsck.xfs does xfs_repair -e if fsck.mode=3Dforce is set. It is
> > > >    > possible that when the machine crashes, the fs is in inconsist=
ent
> > > >    > state with the journal log not yet replayed. This can drop the
> > > >    machine
> > > >    > into the rescue shell because xfs_fsck.sh does not know how to
> clean
> > > >    the
> > > >    > log. Since the administrator told us to force repairs, address=
 the
> > > >    > deficiency by cleaning the log and rerunning xfs_repair.
> > > >    >
> > > >    > Run xfs_repair -e when fsck.mode=3Dforce and repair=3Dauto or =
yes.
> > > >    > Replay the logs only if fsck.mode=3Dforce and fsck.repair=3Dye=
s. For
> > > >    > other option -fa and -f drop to the rescue shell if repair det=
ects
> > > >    > any corruptions.
> > > >    >
> > > >    > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > > >    > ---
> > > >    >  fsck/xfs_fsck.sh | 31 +++++++++++++++++++++++++++++--
> > > >    >  1 file changed, 29 insertions(+), 2 deletions(-)
> > > >    >
> > > >    > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> > > >    > index 6af0f22..62a1e0b 100755
> > > >    > --- a/fsck/xfs_fsck.sh
> > > >    > +++ b/fsck/xfs_fsck.sh
> > > >    > @@ -31,10 +31,12 @@ repair2fsck_code() {
> > > >    >
> > > >    >  AUTO=3Dfalse
> > > >    >  FORCE=3Dfalse
> > > >    > +REPAIR=3Dfalse
> > > >    >  while getopts ":aApyf" c
> > > >    >  do
> > > >    >         case $c in
> > > >    > -       a|A|p|y)        AUTO=3Dtrue;;
> > > >    > +       a|A|p)          AUTO=3Dtrue;;
> > > >    > +       y)              REPAIR=3Dtrue;;
> > > >    >         f)              FORCE=3Dtrue;;
> > > >    >         esac
> > > >    >  done
> > > >    > @@ -64,7 +66,32 @@ fi
> > > >    >
> > > >    >  if $FORCE; then
> > > >    >         xfs_repair -e $DEV
> > > >    > -       repair2fsck_code $?
> > > >    > +       error=3D$?
> > > >    > +       if [ $error -eq 2 ] && [ $REPAIR =3D true ]; then
> > > >    > +               echo "Replaying log for $DEV"
> > > >    > +               mkdir -p /tmp/repair_mnt || exit 1
> > > >    > +               for x in $(cat /proc/cmdline); do
> > > >    > +                       case $x in
> > > >    > +                               root=3D*)
> > > >    > +                                       ROOT=3D"${x#root=3D}"
> > > >    > +                               ;;
> > > >    > +                               rootflags=3D*)
> > > >    > +                                       ROOTFLAGS=3D"-o
> > > >    ${x#rootflags=3D}"
> > > >    > +                               ;;
> > > >    > +                       esac
> > > >    > +               done
> > > >    > +               test -b "$ROOT" || ROOT=3D$(blkid -t "$ROOT" -=
o device)
> > > >    > +               if [ $(basename $DEV) =3D $(basename $ROOT) ];=
 then
> > > >    > +                       mount $DEV /tmp/repair_mnt $ROOTFLAGS =
|| exit
> > > >    1
> > > >    > +               else
> > > >    > +                       mount $DEV /tmp/repair_mnt || exit 1
> > > >    > +               fi
> > > >    > +               umount /tmp/repair_mnt
> > > >    > +               xfs_repair -e $DEV
> > > >    > +               error=3D$?
> > > >    > +               rm -d /tmp/repair_mnt
> > > >    > +       fi
> > > >    > +       repair2fsck_code $error
> > > >    >         exit $?
> > > >    >  fi
> > > >    >
> > > >    > --
> > > >    > 1.8.3.1
> > > >    --
> > > >    Carlos Maiolino
> > >
> > > --
> > > Carlos Maiolino
> >
> > Regards,
> > Srikanth
