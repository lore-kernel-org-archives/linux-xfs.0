Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FB2C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 15:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347547AbiF1P6P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348273AbiF1P5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 11:57:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8C23615A
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 08:57:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SFJO2V020157;
        Tue, 28 Jun 2022 15:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Nt9jipoGU2vZcMzFSR75cu/sYaqckvVx5Cxj0rT7YmE=;
 b=r5Lk3TlfqKNWGTYWgAchyp+i662YG8l4x2cNJIyFbAKP5Qtk0hXpArPAjNpJCH6cIFWY
 09ErCzQjOx0ID+drCPCIWHLQhzO7bmUbILEdqIlIe9x9I0p0/KeVAFKknT4Y72UvaZBC
 VT+EfTFrUe1sbsrIsRxIrw59LNiBa2708m7mpLUw7A1gg5A64dRfH39PJqtq2MdZy9WT
 /w3ID9lwVreWFPfhbr6h7TztiCGgxzV6iP/qRW7RwCXrOmfk8FJDRzjLFIiKzd5qjLTo
 BVBMTp4np+5FhMsIgMYlDY97KDk2WZ1oWZz6Skb/yHK5FxxQLGikbloIxBbOLhPfVU1d Kg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwry0em4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 15:57:18 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25SFoKSi010695;
        Tue, 28 Jun 2022 15:57:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt2b62f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 15:57:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZwSpPesGHCYmYjUjv5loYWBEUCd7DwtAv4fLJqTMyZzrFl/EzecHshQeCyCGcg/7xvH4I3wmzY/MBixj1QvnrjEgG/gVIONCVpO9g/84sBnQlEIua0i2VbjyBIPJ4lWOQr+Vuph+4OPp/QSujPOLL1WBBU4WdesdkaNKaQLertxrLp7JNNzgmiANKwpQizR1GCkEou6kXy+NC+/8v25mn/gdPsOp3ISmVqYY+f7ST/1a6mqBcI/vnicLhJXWSCGlgHmPLh8GD7FCwx6kO0FWhZ98vGy8KOhtN7NJdtpDi/8A4ksnth5MsoGV/N7cAJwyMcUfwTzWOG9H2JqVTh6+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nt9jipoGU2vZcMzFSR75cu/sYaqckvVx5Cxj0rT7YmE=;
 b=c1PF5a6qo3jnuzc77frGSr98+aIduBse5afOLLAVr2UT4T8gMrIxpdkAQm5YKqbF9XY+f7+ojRYdXWofJLHRgbpO/neRhFt5E5WI/LGXFpmxHSjZYfKgxUL/Y/VKm1cLguZaUS01SEtiAaCjhnQPDmOmqaUkSiCs2esdy59PUBbzexNhOQ5yasGl2kg/r+794Hdy4T1oRouN5DVI2X9yd2IdsHUh2YXVEw3mTiEweCB+jBIAF8r7kgoE2bm2gIaygEKAKi0wGeZPUCEtQ3K/xQxU87V8KiFyN513wQwmpvxl4y+lQmEAIUU9JQ/sk7TUerBpk4Rnqps3jYOm38EnFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nt9jipoGU2vZcMzFSR75cu/sYaqckvVx5Cxj0rT7YmE=;
 b=Gbcfg+BVnlZhfJSeSdmWFUre8FKb7USHXamZk7g588K6i7Fcn8umta2TycRW3AfUUWSDwwsEwa5REt0eJw438IYk6gJz80U9feFYCGXs0NZqFWjc4Muah2HgOvRdWG320D76MsbSgWFjDAXSDkLH2fwXu7M9qC10jkjACC/+0Y4=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by BN6PR10MB1699.namprd10.prod.outlook.com (2603:10b6:405:a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 15:57:14 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::44a5:e947:8149:235f]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::44a5:e947:8149:235f%5]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 15:57:14 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH V2] xfs: make src file readable during reflink
Thread-Topic: [PATCH V2] xfs: make src file readable during reflink
Thread-Index: AQHYh/4czOFUTYnGz0aJDj0eJ0+HSa1k/3qA
Date:   Tue, 28 Jun 2022 15:57:14 +0000
Message-ID: <5ED436A4-6BBF-4868-BF42-3CAC7B90BCCA@oracle.com>
References: <20220624191037.23683-1-wen.gang.wang@oracle.com>
In-Reply-To: <20220624191037.23683-1-wen.gang.wang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b98d9def-f1de-465b-2a13-08da591ede99
x-ms-traffictypediagnostic: BN6PR10MB1699:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +KUgJQWljr7KCweSIUUDkWFpKtLFKDnwev6uYn7vL17i+M+zaW7A2ey/KGL7zO54tK6y0YjL95meSQvtzQRrcxNy31mrNpmcRHogMP9p8ED+1eWObTFRnng4XJIpCHzekLQS67VV3Q9XNUdwaa5S0cAPE1ndUDqFJ6Yji2Z4iwN1PK5RiBCpZR6AseHImj5iWQUGhqTJJfZ5eKedbLwtb1xiV34Un7+JbWJm6TwBnBZSHbIRzS08hSUUrsLm7ytf23jVAtyvjC1Uax0x27w+HTxiZpDvMxpNcm1ceBr6X2QAkj4/qeAg4BqxM9KHXiQuBdCfDJEhT0pJis4q69cMfzjV3Vi5M3tNuO64v6giPqAHaaypJcftya+ZBveAeJ8CKAXZUQc0DFlRWMw9n6Sz+dwHm6LiRSVkDk/QCRIJ+wEXtx3SZK5RYPziXVnxECGSYnjrjdI17FY1zwfcLRmDmesoWuUk+RvVyGrTPAgjWtwxeJG5VOccErJGAUzfhdCiZYiCOtF0AKiuWMNeGlKvbiaJ4rwP2feqptTPhQPIigCknDN+M3XPn4IojQ7z6DphmtmR7tJLBOo5O7rmXPhnPBXv1A6mmAQZT5r2c92is5pL7q9mKtkLIP3u/QHqbvw+0IpWSreUMWs6orT61rze7uEO9OQqoseICJiWaPv3iYbHZTgpYqeLE8ejVH05ismJL63uLrEceD6MlKLEMOtrl4EuWZqE5E66aAMMi4AFZhlhepHEpOc0+UBaG6Y+FIR1Y5fCn2nyxBO7n3Cm9uuocmgSDyuqi+JGv0Yvr1hgUPjWKgj5sIA7B0Rc1hp86Td3fzzx4dvFQAVrR31S0P0hMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(366004)(136003)(39860400002)(36756003)(6512007)(41300700001)(91956017)(86362001)(26005)(478600001)(6506007)(5660300002)(6486002)(8676002)(53546011)(2906002)(186003)(83380400001)(66476007)(33656002)(66556008)(64756008)(66946007)(66446008)(38070700005)(110136005)(76116006)(2616005)(122000001)(316002)(38100700002)(8936002)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8p39a3wtLqQEH5m88pYV95hpaUMCtt0SrXwYf/Ty8SAx7NRBDooB430ZlT3T?=
 =?us-ascii?Q?2O2rNm2MgbBRd0oSEgEC95XiX9bJy8ABSKremXUNVYxzkQUE3dO3YdjBrYKy?=
 =?us-ascii?Q?ibq+uqAF3pZ1arBQ8zuOsPqoiWKg0/rNly6X6GPus2QzdDo1hxD0VR+wVoEM?=
 =?us-ascii?Q?Yp1wbQtXEKDhGeSY8k4MsNXblpMsUEIa645+tuJsK52WF21eGEy9zmxDXzBg?=
 =?us-ascii?Q?AnT8D2e70raIoILD2hzG+NpoRlZqJ4w4X70EmDRaqZF0pvhHVHUIoVSPpeK8?=
 =?us-ascii?Q?YTjxey+JS7t3wC7NeFA3bOWRswQIc2aYJ5zmB5zSxz9o1LdwKz30doEXdqHH?=
 =?us-ascii?Q?4fy8oLcq5ZI8C1kr4uGyxFngHIWzuHgc0gB4VZblIqHl8/9DR2QjdfhKKZev?=
 =?us-ascii?Q?uAP2vknfcY2+D5LqMBtA3C7AONjkYg0WMN/EduRunwEpdzkfZuu9hj2LJ/80?=
 =?us-ascii?Q?36eoECBaJ6C0I4ySDMMOYYyg1KI6Uu0qV6cq6NVqwgWRNUH2R/btm29EyQx5?=
 =?us-ascii?Q?X0gflQq0qrOQUzuVSJ1Gir9XhiSSWVH7+D6z4grXcJ1zlcSmOrsQ7VnCIhzP?=
 =?us-ascii?Q?Ma8YDm2vQQd1P43Lsil/nhGO8Q5B9Mmn5fm77qqNLvv2cKMsS6DcTF9tX8YU?=
 =?us-ascii?Q?XaCIigeRQesbuyn50z9sF+yjZM25Nyi8OwTjIvL8Q4HYaTVhVowAcUaEKhM/?=
 =?us-ascii?Q?B6ByLFMyh9BabYwu1E9PPRh8NZ+nW7sna2nH1wdz0LH7BTwo7bNRDAcJ3x2F?=
 =?us-ascii?Q?jPFMnwzuk+Ko9rD1kUm//Uf25Otz+edtJvYmBTrzYxc/ShyX7Piw8+YcgTk8?=
 =?us-ascii?Q?byl5IRLuQuBvNiq0xtGEtGnLxVXxDxj9/BnlVqST6FMk1rj3W5ICNSSc39V7?=
 =?us-ascii?Q?DN23pGxUXlJxekLo/ms5WtoD5mIbXxjhtgiKzdUtP0Oehq4XsN61G/TxdvB6?=
 =?us-ascii?Q?fj4+tlk8yPRnDXH2kVlHG7GMk2wIy9DPag900qwZOnvvwfXV7IElQGcuLmyq?=
 =?us-ascii?Q?3g/bbmi8oEYbVTvGig6k26mdVpS7yl3ru93i9RPptZ/G/Y24WWrcfF6wTXNt?=
 =?us-ascii?Q?UdjOq0b6kGn/m9yaAuxHgi5jijZonDu7FGyrbcAlomsfsp3e/+Ji/r0v0QT7?=
 =?us-ascii?Q?8oFFUrLO1D7VLix8YxdjGw1iZFcrW6IxMTajZ0RSBQ++Ir03cmdDOyQMhs71?=
 =?us-ascii?Q?VVRKQyISglOMiGvM8I9e59mt9xOYnAbcTb6TI/j4TwTSsOTyHcL5C2QLzQjf?=
 =?us-ascii?Q?ayjhBshpWyuf48+3O/1BGaUuLSCsPmIhX1t8SpNC+FSZF9OFXLUelwa/o0ic?=
 =?us-ascii?Q?7/LzQj/oUI83jjFRa4iAH8bzSD9RkY58PLNFPRlSAJ8v0D1f4wV6yDFGQf27?=
 =?us-ascii?Q?lISWtzEyQo4JhFoGCbNdL7xurL7EjIyFfsb87gH46+WDGyWbOlF1zjWpAd+S?=
 =?us-ascii?Q?LlL9tQpfQsNmXTSAF+RL2czttC8K0PAU5qtZGNRmhgwWsQTH/D8YLHt8bqDu?=
 =?us-ascii?Q?NqDHU0KaHimOk9/4RGNxrEOhy3rzQ9i8PkNeg21IPrV06eJdjiCii5Q7QK7f?=
 =?us-ascii?Q?QRmmk57jaiw+BUudfI9Pm/KN6AJ6fMpPU3la+cN5qx+B4nPKL3FSATgHwIi8?=
 =?us-ascii?Q?cQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D1F6DB58D1CB83419C3613047466E395@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b98d9def-f1de-465b-2a13-08da591ede99
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 15:57:14.4192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WDP+7iR1+vSMc14Bh/uIFLx8lny07bcaj4/0azrkuhxvHlZAWSoDqTcC0+JO0G9t4DaEpibn08fOHDCdN7Uq1BQ+92us3q89zfS0lPcSAYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1699
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_09:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280064
X-Proofpoint-GUID: vyFUzDKtDOyd2jSpG6n0zg3FnWtPsk4o
X-Proofpoint-ORIG-GUID: vyFUzDKtDOyd2jSpG6n0zg3FnWtPsk4o
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

How about the V2?

thanks,
wengang

> On Jun 24, 2022, at 12:10 PM, Wengang Wang <wen.gang.wang@oracle.com> wro=
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

