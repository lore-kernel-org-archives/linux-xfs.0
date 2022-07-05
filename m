Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DD0C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 16:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiGEQeW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 12:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiGEQeU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 12:34:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA6E3A9
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 09:34:19 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265F0tEO005248;
        Tue, 5 Jul 2022 16:34:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GHfDvINEfiFLqtqAXIOhviadrqj8R81CUjBFg5A4KH8=;
 b=TfxgkXg9DgCRNAsivoudQQgXIbFuFOPUUFPt7CB6hY0iHbECxHp9YtAZVabH3nnX0Az0
 +tWsh0Z90/vqPteyUwTe3M/1DrivfLxnnoXhtN+YS0ItudHDd3AQvvuieDBWjVLZnife
 kuLCG0jHO3ef1/RbkIankkkZ84nSHRfvThpge+McuedOw8GAVnaAttrqbeCvMgGqbnU8
 zrpfjawizKfw6ttB1Mywm20kuvpbfBkuzZeINzBU7qsYHTxcHVOahysIFFdCrhwhTR8V
 8D+1MiZcRhVtrOaWtJUOajSydmCtIYaHmy14ycQk3B4lYa/PgkXJvXL7UiCv/Ak+9CLO tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h2cecekmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jul 2022 16:34:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 265GQ5No028068;
        Tue, 5 Jul 2022 16:34:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h2cf2gw0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jul 2022 16:34:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfHADaMpAPQ3IWgEQyMfrLFisMsddcEgBYdsD2NbxlM6T6nrmVrBcGVTk6P85eCRBY3lcrEpbYRMQ10i7JbS5/l37Q3e2IrX9k+RUP/WyvG/eawawSdqHsMJlugYSR9iGkFBPn+COomMbi64p/2ZlpTZYGDTHLFgx4XG8TUzSynTV/eIvU4mlxPp9+IoBkhLcarMTPoGJFMsfAe3H4ZnwzqLn3UGuDZ3qCZVH9N62nsDeLwcZaamqZ4UoQIaKxMVu78mp4Iu8Pur2uJY9KfYBfKAJlxYpDUTNWs7aBNBdvZJr24gcIeVf29pDWuSgSjdUN/TyaWcg9MSnL8sOoGIGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GHfDvINEfiFLqtqAXIOhviadrqj8R81CUjBFg5A4KH8=;
 b=FCbN7bbE9YF9EOhRJ5pgK0i/FWs32ACaG/pCB/MHLucmhHefBYmnYPL7urtCW05ZOQNGL5FWg6VjDqMLCxVeNUG49NrURALdWkBLSrSylJ2ZTKJ0hxO3CDYJlgHRy00TSU4hu9JJtsG1fRgUNqrNMLXkN68JCRTF9cduhsTeOOQdYvk7l+gUN0Wu1d1naWYX/+Fl5fdn+LmftBk2BeQXIcUDgBCYXk7HYs9A5Q2bI+xsIlGo9Yrx7mDMQzM5vo5Ozs0g8GoqqHNw27ou5ru+I1g8glTk8ZebedY8Y/H9x3065CY9E6cqSEGrRBnaC4khYqAouRTkmDiZtDlFaoX4Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHfDvINEfiFLqtqAXIOhviadrqj8R81CUjBFg5A4KH8=;
 b=EfN2jTjmOHeGdEeVBXJj6grTMCkYvJJJWsZjRtXmFgYu+sY5Uq5WI5nK9fBuPDHQ2yarJTcd3J60NaMqugwNR/dtT8Z4BzYvGz28M9scz+iPiuyWgJTsY2TTkzxSVq3cmhFDyCD5CPo6hXgAO2/THXm9VMFTUPo5fGQeYc0w9a4=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by PH0PR10MB4424.namprd10.prod.outlook.com (2603:10b6:510:41::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 16:34:06 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::44a5:e947:8149:235f]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::44a5:e947:8149:235f%5]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 16:34:06 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: make src file readable during reflink
Thread-Topic: [PATCH V2] xfs: make src file readable during reflink
Thread-Index: AQHYi36UiSv9Ji9PPU6AjLpgBuDp2K1wAxkA
Date:   Tue, 5 Jul 2022 16:34:06 +0000
Message-ID: <573A659E-AB87-4C62-9238-F0711A3D0FC6@oracle.com>
References: <20220629060755.25537-1-wen.gang.wang@oracle.com>
In-Reply-To: <20220629060755.25537-1-wen.gang.wang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30efbf39-c8e3-4b91-460a-08da5ea42e0c
x-ms-traffictypediagnostic: PH0PR10MB4424:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UnzkjdLLRkAzTdLCl2l3+s/cG5ABVoER1RyTw6AKeWMOT8VdHzkvF69CBpjiBxFvaRziWIkIJZl94orMznpU7D2t+168cTj3PRn0r6gomzK5Xnuotc2hxY5RRbAbgugwb5d/1AqlRlyxJ/pS8+JhzW7FxBhCV17Hz3pTQFJBuOuakawtUfLLRH2vnjV+UidDoDzRZvqHFvopkgkzwNgjSnWUk+F15zPGhsoU637AL5Hk7Vg8pWXetTZ7/oKuNpfAkjCyT/G6JMrKbN0Bl3sM+FQuAxyQDK5HQ8M4/2oDUMTo45eg/L0kLmM/0yqxi748uz6m/5qjMSXpHfQTbCGqNK9XC/5ZQuNS3F/NOyWZ1bWQPoL+C7Nw05Tcv27saHah7O9CzNYjHkMn89J1mSvQ5XJOVQxBXNGY2b/DW2nWIDnhA5aP1nLOyytJdGa+FomfM41a2tAp31oSC8DteYPkwWNEMvx3Fx+GAB3AYtCnRTwWFTrYvek+SLsANwwpKb6thL8xq5crdzFG5n4RBXl/vswOI2mx0iNc6BFSqV9sl300SV6rZTJavAGZljvYdZLSHSv8ByRYHiaTkK+EE6MFx+DtEM39LCufsbDtn0zuIBX/9o0/pIBONpRLp4XAOf7cIJIwStIslpbx0D5zh4XXa0DzzU/CjBzJ7fN9tczHm7Kd0Gg3oDsWaFh1rgFaO3JoUhsE1Yi1F6k1NqxFOOS4pFucMWNvnfkR4OuzfzTSx96vYDd1qdF9RMFosF5mcd3w74FT38QSwT1sA2p6UsNLMOxCOOPsQBrwTcJRc/2lZtYjb6wlnBi7zp18oUDLBkUU3dh1xb5mX8hrPifvAOnpKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(366004)(39860400002)(136003)(66946007)(91956017)(8676002)(66556008)(64756008)(6506007)(66476007)(316002)(66446008)(76116006)(6486002)(478600001)(110136005)(71200400001)(2906002)(5660300002)(53546011)(38100700002)(8936002)(36756003)(86362001)(33656002)(122000001)(38070700005)(6512007)(186003)(83380400001)(41300700001)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5h2/iPBaxZnu/w519LIHWevQv8n18AO2WOSjgQsGk540RKSRfdINpIjvL4A9?=
 =?us-ascii?Q?XhcVXkmaCNOgIInwz6Hw8URRxMSVLQa1HpZApS0elHov1UUIsiRNBhVXXiz4?=
 =?us-ascii?Q?7ZrLSC2kFYHdLv4fI+4GXRWqOiymsktXZ6GTz6XoR0CEn1qZlrnx3K7/fnIb?=
 =?us-ascii?Q?6jsZs2gRLMdWnkbVUetAFrx1Sbovkv+k73XFO9sM9bOGA6pz2IaiU0rPu5mn?=
 =?us-ascii?Q?0UkVwU9nFqq1mK6ZYhBpBhBHp46nDaoeHSfptI8/4xzidMoSmtPQgYTOeUCT?=
 =?us-ascii?Q?c0ReQ3JGsALemP9RO1iXzoNuCetcxPZZr0pUOMcWJ7XYnOKpgn/itKzEpK2p?=
 =?us-ascii?Q?EMcslBAjJQI7KY8I1Mo0/ITLmRZNwgkucqDY1kOP8AiYGxxgj7DSe953tvzr?=
 =?us-ascii?Q?IEgf3F7h9PSuO9E9FeLRdnweFdCOj23G8IqRac86McVUFMikcH5N0zMEkrPr?=
 =?us-ascii?Q?V2/0VsXkdRQUf58f/eMDPj+xqbp0vV05IqVgoZxrrq76wcqhpWw1bBXpEdxq?=
 =?us-ascii?Q?Gki03tRXANb4Iq2/gKD4Gqll402rTP/yYgJIDlYSzyldGBfDuQYGrjTfEm9B?=
 =?us-ascii?Q?KI5adk4sjMJaQWacOyJ0Y1PddzgAqc44dJBv811H9013sOwgURu/riCOPJWh?=
 =?us-ascii?Q?VDRlTaBdU1tY4aquPK+mDbMaBe2Uo19Z/mhEexLKRwVulUKkGl3//6J2XNFZ?=
 =?us-ascii?Q?C4kHUTfot8b7UWvlIip3IMIgEYJMIb6ahbr6oIpHrdVtuEZohmLCdvtuj/YD?=
 =?us-ascii?Q?ipiJujys2QjnZGrHuW7psNzwdcdmzwPsu+6vcCgDmjWXHzE+AjHhKI8ofPzZ?=
 =?us-ascii?Q?Zpdxoeum2Am0zC2SxRZgEi7Us+zdjW0/5TDay516vCdsH1quoR8R4qbkxxje?=
 =?us-ascii?Q?ME+3XxMplcyPXvb0gEJPTigpas33V7QFBsyRbbJxVFl4gK+fZajjgU0FEB82?=
 =?us-ascii?Q?rhKhffeasBrA042abslici6rKxP/uIbsT9HthD2QvQMlbZg/FFrdCF+JFi1f?=
 =?us-ascii?Q?8wVRH6kAfJAFf6ojmNk1wiNqvDgZD1SlEa63/8XLlXihHDb0qzg2FkUhpa/+?=
 =?us-ascii?Q?3ahtouDNtppwgQeQl2LIEs15GYqC/GDGfDjAd4DRp9d/v0sKNIKaxtRL2KDe?=
 =?us-ascii?Q?su6c0Y6Lw0Jf1Gj/4ZhkmdTOKd/XI6LjmycniTuNFThUpAyETg7C1qLVS/c/?=
 =?us-ascii?Q?Fy3HFceAu9633LwdHoFM1Ft5KTLtfnE/1mrYG5YCr5HLPDI/07/IXb3PCNiX?=
 =?us-ascii?Q?ND0g7z4S4k+eV0Cold04WEdpXFoP7+P5Q5n3LoEEJ/7K4AqH8f6imZYaDzHZ?=
 =?us-ascii?Q?P3Z2ZqbxnO2vlh16Cdds2x2A4YbvOAXcz38sEZx2rf7vAyOc590TS3iQR+OV?=
 =?us-ascii?Q?C0FzWH/upQ5wLzYC4ExNlhaxAjMdZGT2JjMR6j0cHXpreCkhlJmZktu4D61m?=
 =?us-ascii?Q?n2h3oHIK0w2Gl+LlPz4i5/c/vn2zPqpZEIU4/oy45HhrjW+2F1cgQm/IDSXI?=
 =?us-ascii?Q?33UHCBi3DX+VtrLVjXEEFq26HyuVLCtIAxsGwLi1TL+V+eP1cFmneREyrdeE?=
 =?us-ascii?Q?NNwSlf4H61Tl72Rwi065KKgDC/2VVWBgXhp67vbzxhaMi8jnTiOZ7WibeZda?=
 =?us-ascii?Q?RcJ07LO/EZjhJCaxSrybstQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D34600F64330A4BB84643D64A2B6F30@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30efbf39-c8e3-4b91-460a-08da5ea42e0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 16:34:06.6237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gf93ROKL6hiqmRZ4OEeF4S9hD78o68tQOXafjnL6LQYOox+Tt7bDlLUeuedy+alOiBK+tYNjYNWlaMZDccLGoCPH88rsKYgxJHLHg9tcXXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4424
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-05_14:2022-06-28,2022-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2207050071
X-Proofpoint-GUID: 5cHfOY-UG1vWEb5g5XlZ2c0_Vj5dG3dh
X-Proofpoint-ORIG-GUID: 5cHfOY-UG1vWEb5g5XlZ2c0_Vj5dG3dh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Any thought on this?

thanks,
wengang

> On Jun 28, 2022, at 11:07 PM, Wengang Wang <wen.gang.wang@oracle.com> wro=
te:
>=20
> During a reflink operation, the IOLOCK and MMAPLOCK of the source file
> are held in exclusive mode for the duration. This prevents reads on the
> source file, which could be a very long time if the source file has
> millions of extents.
>=20
> As the source of copy, besides some necessary modification (say dirty pag=
e
> flushing), it plays readonly role. Locking source file exclusively throug=
h
> out the full reflink copy is unreasonable.
>=20
> This patch downgrades exclusive locks on source file to shared modes afte=
r
> page cache flushing and before cloning the extents. To avoid source file
> change after lock downgradation, direct write paths take IOLOCK_EXCL on
> seeing reflink copy happening to the files.
>=20
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
> V2 changes:
> Commit message
> Make direct write paths take IOLOCK_EXCL when reflink copy is happening
> Tiny changes
> ---
> fs/xfs/xfs_file.c  | 33 ++++++++++++++++++++++++++++++---
> fs/xfs/xfs_inode.c | 31 +++++++++++++++++++++++++++++++
> fs/xfs/xfs_inode.h | 11 +++++++++++
> 3 files changed, 72 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5a171c0b244b..6ca7118ee274 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -514,8 +514,10 @@ xfs_file_dio_write_aligned(
> 	struct iov_iter		*from)
> {
> 	unsigned int		iolock =3D XFS_IOLOCK_SHARED;
> +	int			remapping;
> 	ssize_t			ret;
>=20
> +relock:
> 	ret =3D xfs_ilock_iocb(iocb, iolock);
> 	if (ret)
> 		return ret;
> @@ -523,14 +525,25 @@ xfs_file_dio_write_aligned(
> 	if (ret)
> 		goto out_unlock;
>=20
> +	remapping =3D xfs_iflags_test(ip, XFS_IREMAPPING);
> +
> 	/*
> 	 * We don't need to hold the IOLOCK exclusively across the IO, so demote
> 	 * the iolock back to shared if we had to take the exclusive lock in
> 	 * xfs_file_write_checks() for other reasons.
> +	 * But take IOLOCK_EXCL when reflink copy is going on
> 	 */
> 	if (iolock =3D=3D XFS_IOLOCK_EXCL) {
> -		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> -		iolock =3D XFS_IOLOCK_SHARED;
> +		if (!remapping) {
> +			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> +			iolock =3D XFS_IOLOCK_SHARED;
> +		}
> +	} else { /* iolock =3D=3D XFS_ILOCK_SHARED */
> +		if (remapping) {
> +			xfs_iunlock(ip, iolock);
> +			iolock =3D XFS_IOLOCK_EXCL;
> +			goto relock;
> +		}
> 	}
> 	trace_xfs_file_direct_write(iocb, from);
> 	ret =3D iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
> @@ -1125,6 +1138,19 @@ xfs_file_remap_range(
> 	if (ret || len =3D=3D 0)
> 		return ret;
>=20
> +	/*
> +	 * Set XFS_IREMAPPING flag to source file before we downgrade
> +	 * the locks, so that all direct writes know they have to take
> +	 * IOLOCK_EXCL.
> +	 */
> +	xfs_iflags_set(src, XFS_IREMAPPING);
> +
> +	/*
> +	 * From now on, we read only from src, so downgrade locks to allow
> +	 * read operations go.
> +	 */
> +	xfs_ilock_io_mmap_downgrade_src(src, dest);
> +
> 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
>=20
> 	ret =3D xfs_reflink_remap_blocks(src, pos_in, dest, pos_out, len,
> @@ -1152,7 +1178,8 @@ xfs_file_remap_range(
> 	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
> 		xfs_log_force_inode(dest);
> out_unlock:
> -	xfs_iunlock2_io_mmap(src, dest);
> +	xfs_iflags_clear(src, XFS_IREMAPPING);
> +	xfs_iunlock2_io_mmap_src_shared(src, dest);
> 	if (ret)
> 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
> 	return remapped > 0 ? remapped : ret;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 52d6f2c7d58b..1cbd4a594f28 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3786,6 +3786,16 @@ xfs_ilock2_io_mmap(
> 	return 0;
> }
>=20
> +/* Downgrade the locks on src file if src and dest are not the same one.=
 */
> +void
> +xfs_ilock_io_mmap_downgrade_src(
> +	struct xfs_inode	*src,
> +	struct xfs_inode	*dest)
> +{
> +	if (src !=3D dest)
> +		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
> +}
> +
> /* Unlock both inodes to allow IO and mmap activity. */
> void
> xfs_iunlock2_io_mmap(
> @@ -3798,3 +3808,24 @@ xfs_iunlock2_io_mmap(
> 	if (ip1 !=3D ip2)
> 		inode_unlock(VFS_I(ip1));
> }
> +
> +/*
> + * Unlock the exclusive locks on dest file.
> + * Also unlock the shared locks on src if src and dest are not the same =
one
> + */
> +void
> +xfs_iunlock2_io_mmap_src_shared(
> +	struct xfs_inode	*src,
> +	struct xfs_inode	*dest)
> +{
> +	struct inode	*src_inode =3D VFS_I(src);
> +	struct inode	*dest_inode =3D VFS_I(dest);
> +
> +	inode_unlock(dest_inode);
> +	filemap_invalidate_unlock(dest_inode->i_mapping);
> +	if (src =3D=3D dest)
> +		return;
> +
> +	inode_unlock_shared(src_inode);
> +	filemap_invalidate_unlock_shared(src_inode->i_mapping);
> +}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 7be6f8e705ab..c07d4b42cf9d 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -262,6 +262,13 @@ static inline bool xfs_inode_has_large_extent_counts=
(struct xfs_inode *ip)
>  */
> #define XFS_INACTIVATING	(1 << 13)
>=20
> +/*
> + * A flag indicating reflink copy / remapping is happening to the file a=
s
> + * source. When set, all direct IOs should take IOLOCK_EXCL to avoid
> + * interphering the remapping.
> + */
> +#define XFS_IREMAPPING		(1 << 14)
> +
> /* All inode state flags related to inode reclaim. */
> #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
> 				 XFS_IRECLAIM | \
> @@ -512,5 +519,9 @@ void xfs_end_io(struct work_struct *work);
>=20
> int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +void xfs_ilock_io_mmap_downgrade_src(struct xfs_inode *src,
> +					struct xfs_inode *dest);
> +void xfs_iunlock2_io_mmap_src_shared(struct xfs_inode *src,
> +					struct xfs_inode *dest);
>=20
> #endif	/* __XFS_INODE_H__ */
> --=20
> 2.21.0 (Apple Git-122.2)
>=20

