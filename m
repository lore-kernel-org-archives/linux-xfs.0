Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AB1C19F29
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 02:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbiHDCuj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 22:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiHDCuj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 22:50:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C290A186FB
        for <linux-xfs@vger.kernel.org>; Wed,  3 Aug 2022 19:50:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741i3JW019744;
        Thu, 4 Aug 2022 02:50:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=68kv+pWub25wrhhxMajGKrKD43QfIz39VGwmexQWSXU=;
 b=fmcoSNT2xgCV2Uqu8qsuhNu+Q03w/tbsbToDR7NbiqZKVMyuPlNyLEIbfBHFyUvN+6FB
 Is/gBRu9zGIxj4gOaeWi7wU4ms0SroyQu/86+iX31DSujMNybnKhCTbHcb/DSFokWYs7
 f9yeQk5l2LSE8uYDOYa5RSibCLGgngk6UPBxzPSDqOTqyizWW4flrncRI3awMDeZk8ba
 o6xUTitokhBR/4neV7OJUjMJAZahlbJtgys1Ow/0aJ+G09Z5K8sssi1ndU7iR/LqnTWn
 M/5qWRKRjlK/LgW4AYo9y4wJ7mSm7KPsDErrWp6NPC1EpTT0hXwNROyWMcM7id+motAi 1w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2usc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 02:50:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 273Na5w6014163;
        Thu, 4 Aug 2022 02:50:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33w9eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 02:50:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdntZjYJfIdhL5+gHV1wiQ7/7HS6/UgeNUqcUntDZ0fS44cw79pLsFIeitGGDP0T6XPcNby9wj4FziPrs2/CNfRRbTFwIfqCcI3ujNV73BlqZ6y5QshV2QdwdmIsvNgtk/fiWIyFHg1ElrIZ886czGwPGjdQ7kR6dRx4cRlsyA5bYDA7GBO/4D1aTF79hFF5s7ENREGP1Ur9Dl+mDsg2SyVOVq8UG+5koGiodsSZ7qcNMIoQhnQ7BBPC7h+QmMzwrHSqHjyHsXr79/GneN6WfugqCJ1DiwVHJHhMuAPBWrnJdthecYcW8YY/wrSr1qAZIBFoG3DaZIweIIsOXUWJ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68kv+pWub25wrhhxMajGKrKD43QfIz39VGwmexQWSXU=;
 b=AcVHDGKF/0IeXfxpwFRyBX/LuNGzqGeCZbcDDj+gm1weOhK+BVxa6xqRnirg/kGg3jvrAM4RfVVaSGzLLA6SyBHfZh219XOhrGZ0SKwKjWUNaPHj9/6drkk896tYLuyVz3iO8JlaRinzRp0G8E5mf8hxMoH+317I+c3ch7tYe9hURwVdrx1cXdSmujfwTDwiL8B+1++O2zOoTcmomWwOca1VVtRTC5dMaT0eOahWk4gbD2moA/BZE9iR0NLwnnwL8qlA1onR6nbUbZCrA6CcBbjkOxaCAlLV190ykvmhvMgETc51le8wRjfDZEcfBFn+UNCCyWS5Q9LVu1CtQi7gfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68kv+pWub25wrhhxMajGKrKD43QfIz39VGwmexQWSXU=;
 b=cc94ojU+jzD3h0aS2QrM1xlvYYSAW0jelECn3JPlLTFol5dcn2ILvQUgQ35qH+5TvfIb5IIhopRGpfecQ2EAniOfA+NqATg0MD9T3YxL94Jn+EdEfMUOEN9QTYkkpN5zZhvZZZTbCnTbdiN9MaH511KwJq25bLBVkOUWBXjCK3M=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by SJ0PR10MB4446.namprd10.prod.outlook.com (2603:10b6:a03:2d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 02:50:29 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::316c:1ad6:788b:85dd]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::316c:1ad6:788b:85dd%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 02:50:28 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] xfs: make src file readable during reflink
Thread-Topic: [PATCH V2] xfs: make src file readable during reflink
Thread-Index: AQHYi36UiSv9Ji9PPU6AjLpgBuDp2K1wJbAAgAB0sICALaiJgA==
Date:   Thu, 4 Aug 2022 02:50:28 +0000
Message-ID: <A902EF7A-2B4E-4C09-BB2E-826438060530@oracle.com>
References: <20220629060755.25537-1-wen.gang.wang@oracle.com>
 <YsSFAmc70npnoCbM@magnolia> <20220706013533.GK227878@dread.disaster.area>
In-Reply-To: <20220706013533.GK227878@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a37546e5-4182-4688-893d-08da75c41713
x-ms-traffictypediagnostic: SJ0PR10MB4446:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JG3yX7S5RKPYE0xaNiLWw0eTbXgA7JMycuH2Tfahih5g1Fy343souBUASzP9efyKL1qOG5fDvZhBYn64ZLcfRkCDZFNZ+3YDUHVvCNZXUH1Q/w3b81dEphCR2mJd5QVpD1c8S6uJ3sGSPfdvLIsDUFa4O6aQZkl0u/S48FvccMGiHzE8XthzeVNPKj2Bo9uzmnOkUNqFK8BQ/U8I8ebZ0FuSejxvJuby1jsBtG166goNbSAFGWMYisGKGnfzkKZV45OcN6JHKgm8amrYvcNs84BDXuJJF65OkSEo8q6tZoiy1hDTDv/2fBBQtlocThjN1bStu/M1jzj32cN1jeO2VeW51cdYH6H8VfiZKWO7xOTyVs/DatusX6w0XyKYqhlG3qlHuuuBcsrGC/cjIVZC2dcRhVL4kU1U4QCaPNGu/WMPXdcNZbLyhHe6JuszbPz4W6Xi7MPcRaY0AqGfE/0kaVyqX5DFl6RyMwbBlRgzAst+ZZlxR4QHRN5Uthr1f5J7Fq2FGEOd6w1RIwNASbEFYAic+MpIvIvrID/nl7h5I0Go0ek47UK/uZlDf7E4NIMac0mleeEj6ojcRhdRvMvttstcD4jA2c6Isq64B4uGNawL/bPYvCvIYZeqPcvxvM5Ybw7Gg7SYurrrWKl+j/KG48ABm2pVvcmYKxZMoTqMIaEpE6r7pggo8voLo1jvDbNnrNHIJa7uULBgMBjHAINGc9dFFAM1tp/UqfCyMzVO0wqiq7A1UhMf0tEmhot0sbVt3r4KDOStVYpfwBeaz2Dc0mHabdxgakksc2KPeXs8p2Sn4xso3WwYf/ArqpAxMHIYIkuWDOsVv40rVywjxgrylw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39860400002)(136003)(376002)(53546011)(6506007)(2906002)(41300700001)(38100700002)(122000001)(2616005)(83380400001)(6512007)(33656002)(186003)(66476007)(91956017)(36756003)(66946007)(86362001)(76116006)(66556008)(64756008)(8676002)(71200400001)(66446008)(4326008)(316002)(6916009)(54906003)(6486002)(5660300002)(8936002)(478600001)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+DLbgv8auKMdq1Su2yxPXXKR3bn28N73i50PuYngviBliPzxBis3fxW1OFoY?=
 =?us-ascii?Q?yZ6OgvEV71HNvD0Rgt0HV5lciISUJ+Ig9mhyRwlWeenLRrcKs1Axb0rujw19?=
 =?us-ascii?Q?IMHaEii2DfhkWxAoY77nLYBUb6rcOGqyx7R3wr3vI84BhisGWghy2vjvsdFs?=
 =?us-ascii?Q?dXuUzORRh+9H2x9HnsvVIUIl14HyJe91T4yxAcVmi0xRTAM+VmJ6VQOy09F1?=
 =?us-ascii?Q?CXOPUMwrt8IeDqw2HFitsRFjpxz5sh5FFgRlJSztKZBwdk5WQ+kvc9WZZAPJ?=
 =?us-ascii?Q?b7K4V9ZtYt1nc+4WObqEo/ywCLsxdkJnbP0Z+MVcMOVOrKBP+rxD8OCuyQKz?=
 =?us-ascii?Q?YUJABtXB+ceRgOHuCrLpMpCWoWMamYewBAE77PgCdUV2Tr1E5v7ej7Y10lzF?=
 =?us-ascii?Q?PCct9OG8eLAPzYQuHCQWLa1HWC7cRVITtKMIUZF6USWifgwwYKe3JADqXUJa?=
 =?us-ascii?Q?smFaLtJ96ucalhhs4OOlpbAmGMwLc6WqS21MlCKL3rX62X4wl7rBPswccDDK?=
 =?us-ascii?Q?+cXB/J3rJvWAarOsptTJMssxGRxLwGfjKuX3HNSmz9GtdaZm4NeqbvTy6di6?=
 =?us-ascii?Q?As/HiTnpv/B1C0TZzfaB3l2DA8Dx0ANjgtqo3B+3Qou8okIDyc9HIVve5NUR?=
 =?us-ascii?Q?ygP6T4PTn/71LpJ+IZiVP8AJonEMvRhTKKIsEQ+wZV0wC83hBdHK3bavRtop?=
 =?us-ascii?Q?Zo8z3jRRX2YnRYxEbQ/NAW6XrxBFobrCZCSYqUN5tVuqAwXFe1KSUa0fuZ9s?=
 =?us-ascii?Q?IXw+v7skpUxp7G3qLHXEbH3SjFzt9gBANlFQm3mK05H/cyYh1KSKfF85pGNs?=
 =?us-ascii?Q?tmS+Ez82tjiZd5V7IlDnDIlc2G7g5PIxU4Akws1OJ3aMLgUbeBn+DodX575j?=
 =?us-ascii?Q?kvLTbiqaKPIBOZ8lK8ujIXFrgFw0w58TC0zx9gnbnxw6DorLwzgmyWrNVCJY?=
 =?us-ascii?Q?2h4nQrdRKdw16uCCAOB+c/ND9oNpLp1uqNQGte9YhxOr0ndFMQCHpNrBeUYQ?=
 =?us-ascii?Q?3tNy62VOUhm1TOj8Gt5uzg7+36J/GOkJ9Ad6ZdFlfm+4C8kIhF89PxKqjIx5?=
 =?us-ascii?Q?x89x/EwEdaX096GyoGFQvFD03F9ePVjsMG6NdbF1ZxjAkOsJvR5hj/J6xsSx?=
 =?us-ascii?Q?tYse1SqxyuridF05kYmWhnFEa19pECMkjECtcyUZZd5UnbM2a5lzr9ULBApn?=
 =?us-ascii?Q?II3fJHteMiALXuOpTIsi1lvJ5ns3wbGnkodDT32+VH8f/X1jEJ/EePfHeyPg?=
 =?us-ascii?Q?JcXHtyZWxxtTuhjjkPIhgGgrDTk5FcsxOAQfcj0WiUsdDzqUckchuWZrRvcM?=
 =?us-ascii?Q?MUdUqsiZiWjattwfdCDseJG6DM9UnoApFh+knAoCLeZkksmK734Tj9vw9S8R?=
 =?us-ascii?Q?JDyeXlgaSdR2hIzuDFenX9h/0DQKcxTEGwcvPw8NJt/3HY7tPWvJ27SDmCN2?=
 =?us-ascii?Q?vNS9HBGj2ffYEYJS0AjduYGHSScL172QzkO77GyBVjEvAjhChrCBl4SNi3Rm?=
 =?us-ascii?Q?QWq8uf2h0e+zYKdGE4d+fpZuG97WdJurw4mtdiKDLlMpl1cp/hL13Jl5Oc2n?=
 =?us-ascii?Q?sjDGNFln/9kdSy7QSZTnKQZgzh42Dy4cW0jHrCd028AAxyrNDjdbV2GCtsx1?=
 =?us-ascii?Q?Hx3TnR6Xriw5SZGC27dfc4PlnF3X1KzFjdfLJCQ4oCT+?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC0865D3E93FA9428A7229E7F7C35623@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a37546e5-4182-4688-893d-08da75c41713
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 02:50:28.6917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8buzFhiC/YVbhkV3+kfpD6pPJR7WI/hwcOI5sts85rElxFeXGr/kX9bUiaxXIWscu71Sbo50hgP5wJbHxMaL4UkigltsRRp2eoG96eMMmig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4446
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=873 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040012
X-Proofpoint-ORIG-GUID: Wue4bDlJ7wszu8lYWhWcclEZw4CfahR_
X-Proofpoint-GUID: Wue4bDlJ7wszu8lYWhWcclEZw4CfahR_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you Dave and Darrick, I will think more on this.

Thanks,
Wengang

> On Jul 5, 2022, at 6:35 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Tue, Jul 05, 2022 at 11:37:54AM -0700, Darrick J. Wong wrote:
>> On Tue, Jun 28, 2022 at 11:07:55PM -0700, Wengang Wang wrote:
>>> During a reflink operation, the IOLOCK and MMAPLOCK of the source file
>>> are held in exclusive mode for the duration. This prevents reads on the
>>> source file, which could be a very long time if the source file has
>>> millions of extents.
>>>=20
>>> As the source of copy, besides some necessary modification (say dirty p=
age
>>> flushing), it plays readonly role. Locking source file exclusively thro=
ugh
>>> out the full reflink copy is unreasonable.
>>>=20
>>> This patch downgrades exclusive locks on source file to shared modes af=
ter
>>> page cache flushing and before cloning the extents. To avoid source fil=
e
>>> change after lock downgradation, direct write paths take IOLOCK_EXCL on
>>> seeing reflink copy happening to the files.
> .....
>=20
>> I /do/ wonder if range locking would be a better solution here, since we
>> can safely unlock file ranges that we've already remapped?
>=20
> Depends. The prototype I did allowed concurrent remaps to run on
> different ranges of the file. The extent manipulations were still
> internally serialised by the ILOCK so the concurrent modifications
> were still serialised. Hence things like block mapping lookups for
> read IO still serialised. (And hence my interest in lockless btrees
> for the extent list so read IO wouldn't need to take the ILOCK at
> all.)
>=20
> However, if you want to remap the entire file, we've still got to
> start with locking the entire file range and draining IO and writing
> back all dirty data. So cloning a file is still a complete
> serialisation event with range locking, but we can optimise away
> some of the tail latencies by unlocking ranges remapped range by
> remapped range...
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

