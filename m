Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F5EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 18:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiGESNE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 14:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiGESNE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 14:13:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456BF140FF
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 11:13:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265HEW4O003074;
        Tue, 5 Jul 2022 18:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6dw1Z5i8N9JKqvhMnpnJsa9cxgQaV9zdK7ZeggjNluQ=;
 b=PKnGxipqGTm0zYf0e72QW6pOBMi2nj5A01mmKbNLxZe+Xs7K/ugqXMnrFPx1F0Qw0q2D
 uPeF7kP32BnE/vs0QVzi0YfTssVwe3jLVtCKQrtNMMfzLzgWBHJ03+AuYGPnVZi+U6WE
 IJ/sTqGryUOEYR57SbXwWVWL3WJkdXKGLpVs6zmtlZ8Q4qX9bGFZ7QBenPFW/oZMMh75
 0+oibo0fuovglOYci6LZNNVaCf5w8BCx5yqJruDwjSbSIbORgswgpbL2YzrcPpQMccf3
 0q3HhEApKI9rRTxj+dc5ytxPbD85xFVnd+PSMjHBWaEUNdmRXz3GMH6l3FBAxYEHn0Ga xA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h2eju6xyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jul 2022 18:12:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 265IBQIe005051;
        Tue, 5 Jul 2022 18:12:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h2cf2keyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jul 2022 18:12:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCzKTFKF/Z8+Idz+5aJVPqQCdb2Tkd4lOU9kQT6foYguB2Evhs1RLGpYarM6b1YwtZ892dKl2I6EJ0H/JcETOEBxngSw+LFSzVWEAaV1W2QxVuSGTDqncTTU14teIQIlW6Z1oLRaYJcdi1XuAnmz5be3HgM2YKdJEjMtU49ckn4KKpqXkoq/LPlXxRNZhoyGo7u5fmmu9e1q/YimG/VTsGyG3XKN0y5WK9LMVjo4sWIBlR2N6ZIC7cEJm6cMQjFhoMws3v8ZZe4gYNj+5rHFSYvW5n3utEsnk7uLC6zPxaOKrev0DhvmlJU1SO11fZuoiL6XdvdIqMgu/oPvECfY9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6dw1Z5i8N9JKqvhMnpnJsa9cxgQaV9zdK7ZeggjNluQ=;
 b=NlpIjYJAcJ8yMNZ3AakyLwg/f1CrHa9+Si7/f/p838e7njGDgEasBGipEKqs7nOEbCxPePmJVZyhAPbFGrfpxcyCMRKAzf3dowSY1sSmLrar2D0j1sNmnEu+jPiB82+Ae6K9ChZor9pKMH+vU7dM9JKYU5rEZr8tosfDi8R8vLdmAWa4PaDAKJGQHPrIT5MrSUzsFTra9SrYzCGvvBOvLKbtdv219t+scgO6wNXtCDuQjr9pNS1E/h2yiZrrrE8fpnCrqHaGYio5kWdhJuoSmuhd5nqIaddElkDWhOHcBfYVMf3e3YChTM4/g24F70BPxHeeZOE5cob8kxy8aBYiog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dw1Z5i8N9JKqvhMnpnJsa9cxgQaV9zdK7ZeggjNluQ=;
 b=JC5CT/gmQgGjS/qA1jcK3Aay9OtevLzLabAR13MtZBxzBhluE6qSWBiH34ZDEoamaLCwRYKMO5vywkjHXJ18bFiBHlxugsyStW44jYj2u8KTwYOTYnrQCl+A8F1NwoxylTZX8f7O9xn7iLuyoxfhgAW601mBBzm+FgHB2Ck5v24=
Received: from CY4PR10MB1479.namprd10.prod.outlook.com (2603:10b6:903:27::17)
 by BN6PR1001MB2163.namprd10.prod.outlook.com (2603:10b6:405:2e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 18:12:56 +0000
Received: from CY4PR10MB1479.namprd10.prod.outlook.com
 ([fe80::dc1b:7b1:9995:79c8]) by CY4PR10MB1479.namprd10.prod.outlook.com
 ([fe80::dc1b:7b1:9995:79c8%4]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 18:12:56 +0000
From:   Srikanth C S <srikanth.c.s@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>
Subject: RE: [PATCH] mkfs: custom agcount that renders AG size <
 XFS_AG_MIN_BYTES gives "Assertion failed. Aborted"
Thread-Topic: [PATCH] mkfs: custom agcount that renders AG size <
 XFS_AG_MIN_BYTES gives "Assertion failed. Aborted"
Thread-Index: AQHYkB4qKyq4byR96USf2dHkA+db5a1vJe0AgADZl4CAABQKwA==
Date:   Tue, 5 Jul 2022 18:12:56 +0000
Message-ID: <CY4PR10MB1479FDB883A03A8E5870FDD8A3819@CY4PR10MB1479.namprd10.prod.outlook.com>
References: <20220705031958.407-1-srikanth.c.s@oracle.com>
 <20220705035536.GE227878@dread.disaster.area> <YsRsv/KrtkDWoFVO@magnolia>
In-Reply-To: <YsRsv/KrtkDWoFVO@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48f87128-c6ac-4486-0ec3-08da5eb1fc7a
x-ms-traffictypediagnostic: BN6PR1001MB2163:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9K9unewxzdWlGXxzU1rJjMVpEFEoD3dFUrTENYNDqzn13+kJAFQEibX+oCo17tfuQGE+rSks9IyjYqlVahDknEoRKaHLBVvNfRWJ66zf52LEjJumTQx9XWkZoWmyXo0odjYILlJBVEoONM56LK4FbAxMWkJ21Fkmmit8SIuQNCkHeoWKZY0QLFbhDpGdMrjNbS+LyCbY3IQTrOAE7FcBUNDI71SHPr9nzu4ZGRHmFUmjc0BLhkiEhid2KSyU6+R/WN4USd8vkib3MSffv1MJsDHXt2tMUmlViLQRpGuyV0bik0Sug7KlJVRr3ZEquAg49s797NdnMpjStNel9PxEijjNepRCOxmOT4P/1vvoKCqG+ilS9+Hmmd8nuoAThyNueASE+lNlgMtx+Tr0182DIXYpV3d8r7XMWkYlRG8m7pWAdfVh0/2opIouiGk7xfzZethZws2mfikNjAM3+lJxKQFOIFVw3O5CK1HhaQUze/NqR29BLv0Z0FLfJZPQREofAdUfJBufWa17/G3WpcirDxe4jeoLZVHkTarmVanFg9fr9iEuAm1ubzSURssPp/5DqiF+0jYTzJmLiaCVMhQfUQXnifWlu4tVCZ38AkNetZRNmVwen9thnszDcCEwXzvzNlzF0I3iASf1h+fChDUBP5RnjPJsBtFWHWEQWJdD3WS1HtegHly4NP1fBnGnHgqUKrYaQ1G1G761LtWQpyyribXLe2ljPcDpW+eaUB0pMKLcNE2ETb5dVJ6tzlVuzmeblIeCiQT+t6VPxiqlcKA4yjwv9hlXzuUWZKsDIeoTt9tq859IJVoKTqe07u3i3ZC7AGpOrnMIbhscqClr8lokUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1479.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(376002)(136003)(346002)(110136005)(316002)(8676002)(5660300002)(54906003)(478600001)(4326008)(71200400001)(76116006)(66446008)(52536014)(64756008)(66556008)(66946007)(66476007)(41300700001)(107886003)(9686003)(2906002)(26005)(38100700002)(38070700005)(7696005)(33656002)(55016003)(122000001)(83380400001)(6506007)(186003)(8936002)(86362001)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Bh7MtfNQtYIfMNWJrYjb8VDG6gbVt6yf6neQZwgJEOD1NxAgZdqFHNes6fpl?=
 =?us-ascii?Q?3ocOjKv3FfRx9j7WfLrVkJtPHJG5VUoIXeHVcSnsGhVwIq/93qw0ZqJMUQtR?=
 =?us-ascii?Q?co8WLw2iPGWsRtjqtDXbY8kNc/iwHzzbdvMQhXpQ5y6hnvT2qaduvUDMwJ6X?=
 =?us-ascii?Q?hHodUvW5ZZJZREMzBDJiCkYAVKU5HEoig+gXLo+DrdZCdPghGvx2VTDbA4js?=
 =?us-ascii?Q?YX3sBwvhI6fQyxHahwcvqRAmg6gQp2UC4WpK268NPr5s1RApmnfnca3Z+CrA?=
 =?us-ascii?Q?PVWu8l65edPyIa8RLQY/RVXEIY2wwUxEOSWILEivlUGuYT/C5unfH9DOUIaI?=
 =?us-ascii?Q?+W1kLXDwxUFwWNYWhEXLSPfpUFfjXyTzu6TAsLVwIFMxLAS0n3Fibjq4EucN?=
 =?us-ascii?Q?56ElMgjEDSSpRdr3uMIqC1FRzBPd/mxJQoJZSy37UhdU9HUJGKr23y/fcv4w?=
 =?us-ascii?Q?aAuKvVZXg7LC+bhY4M0OcnhWH6OSe9muWhJCgDkcqxVpxYGZA0Kg62wch2Vt?=
 =?us-ascii?Q?vEx3G/nk7JmgrGBWbZBzHrPgw9eHkdiHiB0r/YKi2fEje1YvZCedvpYyt8gQ?=
 =?us-ascii?Q?KX39swFveoWYwZeD08v1VQqqemMz8riWEl/9iCv7IE01m6+J3fYDf0+D11wH?=
 =?us-ascii?Q?U516BtWI0l0Dy2kgoHujxBRb0jtywg9OHwlEePiHj/Lj2/40gk7+YfUiO/+s?=
 =?us-ascii?Q?UpBk3p1y9UUrD5YyL2SeE6q1wKiuKO6Q36xTM8qGZo7xBSzgs6cQUBvm/8JL?=
 =?us-ascii?Q?zO5hVUGSqMxDLV7Kkci2bQxK3Nznoj1lBvL3nEYkwrYhS/pGV8quEXV3hhEA?=
 =?us-ascii?Q?v1RSydG88IiTYsL99POF20Ov4OrhIIoyZuiDp30m/N3QO3OSOCHp933q1Ptk?=
 =?us-ascii?Q?bIPsmvvog72ksfw1b6bZyiy7j/x3vc5t0IB025r4ydmXFvRMNUAAcL/ibv7/?=
 =?us-ascii?Q?XoeSYoyJWQ8Hx943/OQCZZNVm0rp9vPY1MjVV1TWxPgMUzAxRgF7j0UnPwfb?=
 =?us-ascii?Q?Pe0eQy6H+U3pXO6YZVKo123v9qt94u+9HjwGkcup8NuKOZjZ8PVqKwZ0Qucw?=
 =?us-ascii?Q?vkCzk8uzWFQ9Wio077YX6H7jJviJ486gDQDZdbiIGY3oC9YvLQSyF8AqggO9?=
 =?us-ascii?Q?/0LaypAFRzuTRsPd5aIF3Aesh0uMiSSwHc0aCYUSLN0dqf2G6/MkWGxo7+JC?=
 =?us-ascii?Q?ywdztSqzGJOcbZWopzGpM7+/HjWanOP2mcAWH+9aMc+T9so2+rV/7XheDVcL?=
 =?us-ascii?Q?PKOzGCNkesM8eUiG6500iuYBpHHh+9z3WjcvzjTVDIPN9H/5ezBRJWy4C4jM?=
 =?us-ascii?Q?AZEA1nrDZ8UX1s0mB6jxUT6CiR4WEhby6PtMShJN8aOpOtnWPiY9bTAoyxgj?=
 =?us-ascii?Q?ynUi0uzs0EJhnoq+bzKO01gVcg+EIVwZifjmyaO2m5R6/s2I1QMQY6qf5v/d?=
 =?us-ascii?Q?tRYNVIuzQaoVP22XknmqhBJOcBbU5sdtADFCU2B7aDfHsGLQwADIM6YiM+tL?=
 =?us-ascii?Q?qSbqWOcXayM5jXAdCAYWJTNHeibz5ZOImGBTnGKk3tJV5lU4QSNA4L+kOb0r?=
 =?us-ascii?Q?QtiDq3X8o8kC9hp3m0AXO7mu9Gf7qT+mmLf8nX4E?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1479.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f87128-c6ac-4486-0ec3-08da5eb1fc7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 18:12:56.3886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ox4mPfsqwXHOnPvivdKM0MXKWqOxB1q2+EiIatrGFBzEM71SK/D+Xheii7M2TX0tllatVGG/lQFGPqrYO3AvTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2163
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-05_15:2022-06-28,2022-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2207050079
X-Proofpoint-GUID: g2fGUS8ShEtrGoovYvTzbF9U_kz12gmo
X-Proofpoint-ORIG-GUID: g2fGUS8ShEtrGoovYvTzbF9U_kz12gmo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Tue, Jul 05, 2022 at 01:55:36PM +1000, Dave Chinner wrote:
> > On Tue, Jul 05, 2022 at 08:49:58AM +0530, Srikanth C S wrote:
> > > For a 2GB FS we have
> > > $ mkfs.xfs -f -d agcount=3D129 test.img
> > > mkfs.xfs: xfs_mkfs.c:3021: align_ag_geometry: Assertion
> `!cli_opt_set(&dopts, D_AGCOUNT)' failed.
> > > Aborted
> >
> > Ok, that's because the size of the last AG is too small when trying to
> > align the AG size to stripe geometry. It fails an assert that says "we
> > should not get here if the agcount was specified on the CLI".
> >
> > >
> > > With this change we have
> > > $ mkfs.xfs -f -d agcount=3D129 test.img Invalid value 129 for -d
> > > agcount option. Value is too large.
>=20
> What version of mkfs is this?
>=20
> $ truncate -s 2g /tmp/a
> $ mkfs.xfs -V
> mkfs.xfs version 5.18.0
> $ mkfs.xfs -f -d agcount=3D129 /tmp/a
> agsize (4065 blocks) too small, need at least 4096 blocks
>=20

For the same version I get Assertion failed
$ truncate -s 2g /tmp/a
$ mkfs.xfs -V
mkfs.xfs version 5.18.0
$ mkfs.xfs -f -d agcount=3D129 /tmp/a
mkfs.xfs: xfs_mkfs.c:3033: align_ag_geometry: Assertion `!cli_opt_set(&dopt=
s, D_AGCOUNT)' failed.
Aborted (core dumped)

> > OK, but....
> >
> > >
> > > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > > ---
> > >  mkfs/xfs_mkfs.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c index
> > > 057b3b09..32dcbfff 100644
> > > --- a/mkfs/xfs_mkfs.c
> > > +++ b/mkfs/xfs_mkfs.c
> > > @@ -2897,6 +2897,13 @@ _("agsize (%s) not a multiple of fs blk size
> (%d)\n"),
> > >  		cfg->agcount =3D cli->agcount;
> > >  		cfg->agsize =3D cfg->dblocks / cfg->agcount +
> > >  				(cfg->dblocks % cfg->agcount !=3D 0);
> > > +		if (cfg->agsize < XFS_AG_MIN_BYTES >> cfg->blocklog)
> > > +		{
> > > +			fprintf(stderr,
> > > +_("Invalid value %lld for -d agcount option. Value is too large.\n")=
,
> > > +				(long long)cli->agcount);
> > > +			usage();
> > > +		}
> >
> > .... that's not where we validate the calculated ag size. That happens
> > via align_ag_geometry() -> validate_ag_geometry(). i.e. we can't
> > reject an AG specification until after we've applied all the necessary
> > modifiers to it first (such as stripe alignment requirements).
> >
> > IOWs, we do actually check for valid AG sizes, it's just that this
> > specific case hit an ASSERT() check before we got to validating the AG
> > size. I'm pretty sure just removing the ASSERT - which assumes that
> > "-d agcount=3Dxxx" is not so large that it produces undersized AGs -
> > will fix the problem and result in the correct error message being
> > returned.
>=20
> (Agreed.)
>=20
> --D
>=20
> > Cheers,
> >
> > Dave.
> >
> > --
> > Dave Chinner
> > david@fromorbit.com
