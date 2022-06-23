Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A022BC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 16:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiFWQMt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 12:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiFWQMs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 12:12:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004AE457AD
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 09:12:41 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NEgegL004659
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 16:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jMrdlLujNMbgd3OwcyDzYOI9PVt5lfjybNhEUxl5RfA=;
 b=tQr2QthDK4jadsHxKt/UUCuJVXmPUYdqTEPHAVSpTaXyriyoLSMSaeJ3LOFViOFz0AFp
 wvK3qikEQnNGK38+7APevEO+EQKMUlKU6YKaP/VW7pE6P+RjIg9jxMxGE+YPAr3JkuAU
 bqxZurUOT86q5reW8OSTpCoOHYcqRS4flT6ZG16yYjOJnn5LMMBskOgfTR8qqiO9+AVV
 xdHOj1AH7VdEW6ep37UHm4nwlgXjv8EkmIPCZy9fv1W0JavXQ6tO9+vJmRd9y5dUa9R8
 Bxi9VUUUQTEirAkq388AcL69s8HE53cwYJ6wEl0aq5IgTfWGw9CNvPrkDaDjlCf0NpYO jQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs54cug79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 16:12:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25NFugpp024195
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 16:12:39 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gtg3xjbm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 16:12:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEL32Mcihin9ae7jSOOkWhKOFN81tmfQNDC7XRaLzav2wadPhuAkLDisZMZ38YnkKtgukm7QvtLBIK5TMxm0M84jEukt+shHLUTJ5n0MdeO10RFOuSEKxt3La6SG1TuS12cQOzrVTVQnortP43nfJ03DZsaFsf0mpCfuIFnI/Z85srCm0fZpaDzAh9bCoeSaO9KV9IvfQBT2Y2TWocRdpjLh5CM7UyxklpHWU+Nho9wJzHbbfXLBfVXiAwCyrI//bbfd9sZH2krPYd8+nrGRORJ0WPppUlFLYC9ZHjju8nVyKmRPfWBsqEVKUvqS8Btg83IhS2b8yYOkCnP7kvMzCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMrdlLujNMbgd3OwcyDzYOI9PVt5lfjybNhEUxl5RfA=;
 b=fks4sD2dNggUt/Hid7ZLI7MXOSWjdtAOyK0GW51hJ4pBClJkAYL3STn1VQKVBgTOu5+5J08Bti45VUaCEMPnWPSwkGJ0rHwuO3YxShoeeENRSb5tey5TCmFqS9qQRl8yTfQCbeYImmUOvLC7Ycp2bms23RkcQkIM841g6EbpDeiqlGRKmYyMMdn7e1HwAYPQD8nTR8V+osnrSILes4DExqqCJMcW5C4Ra9AKreMjCpkaAOqjM8cLGHat/zYmGveGjaQWaqtMpMa/A1cvakbo4crbqa0L/uAvuKT2opKscUVrraM6scNOpYl2JvZ46O/7njfwdaMauvJ6eEXm2z+qyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMrdlLujNMbgd3OwcyDzYOI9PVt5lfjybNhEUxl5RfA=;
 b=KjE2yq3h61PeAARsvF0R7CkYpKaFHNBqKNtaStfsFbWP3YijvSqwyFuzyQDYRHE5B+iDTS836O5mghBgJ9t8WEoQ5z/J48pde/It/hqn9sMfEDtoaR1PPLKjq2FzhtYY+Y4oRWmQZ1vRylZLpzOWmhKbPPCDPJyYO1/npgtb/D0=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by PH7PR10MB6154.namprd10.prod.outlook.com (2603:10b6:510:1f5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 23 Jun
 2022 16:12:36 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::35b7:8248:fc64:1200]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::35b7:8248:fc64:1200%3]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 16:12:36 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: make src file readable during reflink
Thread-Topic: [PATCH] xfs: make src file readable during reflink
Thread-Index: AQHYgrENjr0ZKTnuG0C4NqEotzKHSq1dMrSA
Date:   Thu, 23 Jun 2022 16:12:36 +0000
Message-ID: <44420D34-8DF7-428B-8881-0825A28232B2@oracle.com>
References: <20220618011631.61826-1-wen.gang.wang@oracle.com>
In-Reply-To: <20220618011631.61826-1-wen.gang.wang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ff8d9a7-5806-4582-7ce2-08da55332ff9
x-ms-traffictypediagnostic: PH7PR10MB6154:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ScBOmRr3Mwv7fSXGph0HpTxG6xsMcI8NwjMlFiRzDn4xxRQLSBlSyYQ6l+Vl/YSoJmKJfWPtwGB9QypeUfiQ4gcyQuHUl0f0Nh/MICnzJ4eejORUQ6wqiRTdIw01aNgtkqewqICjshr03ww6MHuqZR6mIQtkbKWI83sJNQNFb3eCcEzoULfFyFUgDvA5+n0jgbMGQl/ZqXJGK3POU8Aislrtwa+TO15T2EN0JcminI0dF3v78hZHTCyfxOQyT0GNFsA/sHCOzM7JOWhA8bwz497ozgrII1rOftjiNa2kkRI4ub/KaCYbZW23NlZdQj2v1rZ9LEAA1WOVpDgFdc5C7lxs6ZPztLSevTrMMH6hWmj2yosJBjNUpuBQ7I2PIUeyk7qNEppnE8y23y50jxh+cwNOEvpZ8abVe7qpabtBhqprleu1RlEjXmmy08PWo/jZaQh47j563RDjzk1MxEqHLwbN1PzKtbii4bm9r77iP8k6dvLPtnODF+iWU2pnqSWj13KbJyq25tGFlsvVTvIk+Uj5ikGIQfoQh4HPJpnAHVe324iGZo5zY/U1j21w3z+Xjt68col4OpKhgRn71VyTMnsYjwuro4IiwNT7sPVVaCLBXZn+e26fuLdhHp7tgMgorZ7HFb2EIwhj2K+pSozv5IPw6T9ja8OQEdkGhAjXJ8MjZICVK09o78AA2iVbB+ItylNIC2kYrYiY5Pch6NN9NCJ59v5XwFIlZWeyFabbyTUp247LPRn6zJtdStXgmVhARrBN4bfITz1y1ZKUauD/Im+HW/irxZfAQzJeHoE6b1lf9anZLxAH7oQlu+cpf5fg0g0vHKiBqYeYf/w4M4v5Vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(366004)(376002)(39860400002)(36756003)(2906002)(6916009)(66946007)(8676002)(76116006)(66476007)(64756008)(91956017)(122000001)(33656002)(6512007)(71200400001)(41300700001)(478600001)(66446008)(6486002)(53546011)(316002)(8936002)(66556008)(5660300002)(6506007)(83380400001)(38100700002)(2616005)(186003)(86362001)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JzC8PhbKlMzU+/zno6kRVgjPRCcW1/o7oUA/Z0QAMYd5mZgbKRPhgcq0vH3o?=
 =?us-ascii?Q?bqvhxel70jvYhp3zzTUrmVIE9BVNuuSnuIVWsBE4dMaAsZIHoW3WT8CFx7vA?=
 =?us-ascii?Q?3JnWTk1lVn3mYPoz9DtZz7yFcz+qvyln6RzJ3jOXrNmKx8Kl2XZFfwGd2NPl?=
 =?us-ascii?Q?Xecwd0mBbqtPqaF0zQHx8lza45Y5OqgGe24Nml9gWbBG8w4tT/LCUTrKQaHu?=
 =?us-ascii?Q?NtKpzp8vkQRQplssKEoOEqQxfHyvKvHmgB3F3+dIZDyDnz1jYfhDCc5ocmZs?=
 =?us-ascii?Q?KjUjU+5l6Cpo2s8SoxrFyKxD8jvzkfrNt11jU1+NnnAglPt2p7nu9sKQy9Fx?=
 =?us-ascii?Q?4RAOo9+QmA/pSMSFZtJYhlTr2ff+SNjvQD4WMAngXg0VpsxQoZ8hMno0tSo/?=
 =?us-ascii?Q?bvqvt5caV2SLCG1MWT9R9USwyyzOrCq2yv2oTk9Y6Z1cdrZWkeMWCLchwjsB?=
 =?us-ascii?Q?AaKEY7ARRB2/DPHeGbH8uQr2xDzg/FQJJekzMo8ZOGbuwC9LUAMF+JnYAHqm?=
 =?us-ascii?Q?gD20LK3H2odOimggi5Bw3oRsbmfNlKJ3f0Nmcv3qzp8611FlE1L4O5X0u+wH?=
 =?us-ascii?Q?A/ONdlMFNeGeL0ykXeMM3lTMxTtqH4Uws7DZjlPzzYVw3TFezFKFA88Yz6+q?=
 =?us-ascii?Q?CuCTRvQ4FhPA3ByD3cp56hDkjhT74MwmzD/lhmM+YFMFQrPtBj6rHNXyJ3tk?=
 =?us-ascii?Q?pqON2wpmTMkLKCy5O3sPiJ30MJXc5CbwMw32fUsuWeZcVopTWA6MpWx94g3Y?=
 =?us-ascii?Q?zxiB9uVBdN0NrKoSxcKY3TeC2kzUa6Fp1sd2sEleCm8L1or+wOGEbrFVCuus?=
 =?us-ascii?Q?A16i6MI8J7DjjTVt71kqWy4NJ3mQ6/pREaDaeMx5P9eNKaqe4KSCkcobyEDp?=
 =?us-ascii?Q?qwVzP056N9u2m3IaL7mT7mtxOUOSU9U7g6fmp5lmfwQwVuhwAPH1AzlH6y7f?=
 =?us-ascii?Q?JiJwPzvJOskC0UNfziKFn9WsP4Yao+mFZNFZHJZKwLtzG4UNxhqo4e+tKhQT?=
 =?us-ascii?Q?mNWMQvSR83V1BYJRfk/GdcnSnTUDZhI7yUCtxqsDuH8Bje5GofebsnhNdZlg?=
 =?us-ascii?Q?j/GM1FyuX/sCQW4EcTqVJb1d6JNMa3IvVqPi6XJNpGfbrrlY8y+v6Z7P3QqR?=
 =?us-ascii?Q?ETDKOM13az9AoQxKLaoNYLvrxKtnc955XEc9/tXL9C8Z82du+yCySRGzohWd?=
 =?us-ascii?Q?8OK/RuL2ogmWzGjgELYgo93TvlHACSHeq7yXvDorThqsvAFTCO1Kfdljluem?=
 =?us-ascii?Q?xFUXokx+mAdJQVkeUuU4l91oq4aTtXRBUrhguT9fpAmMjFp4z/qZqI3nLOwu?=
 =?us-ascii?Q?6weXDYANRsAz8ebXX9Tb3b3o6AF1znCeEDURqGmp5WATFbTXLB/atrE+vxGh?=
 =?us-ascii?Q?ZFh3V4b6t+N/sGwAWD3a+CtSpkcIWDasbDkM2t4RokYX8Y2QIgT4RpIAtVSe?=
 =?us-ascii?Q?t/Gi8y4C53pIrZhuPQ5C9E1A0mtFgMndRbJgMgskbV5q7z2vIKInnzFNfQVs?=
 =?us-ascii?Q?PqwTT95b6ciU9X+pWlu0wf5mfl64ldoC4RbYHV2OCZwVYj5wNrHR/GmUYt+R?=
 =?us-ascii?Q?GdcqKZB6U8zD7J0LilX3XakeVuiqwRlIlaq3JDtUBGDxCYPbYQ13hGbJegeM?=
 =?us-ascii?Q?RWnq+moZigF7RnWkxBa7l+DfqNfL36Gjgbsybs055Aqi?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3C13719F96B71F43A4840ED591AEA5C1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff8d9a7-5806-4582-7ce2-08da55332ff9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 16:12:36.2450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6vqpPf4uzuiOoD2KC71vKk9cKw7ctMMYzGsJxMAAamEYLiIiIAwf8z7HYBP176dx/puNUjUWMzUNTuh+64d/vDtBeTTtC9UlTXLfaMxqX0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6154
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-23_06:2022-06-23,2022-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230063
X-Proofpoint-GUID: yThW8lGKaEnFDUSv39EL5xGhdUaZy6Bc
X-Proofpoint-ORIG-GUID: yThW8lGKaEnFDUSv39EL5xGhdUaZy6Bc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,
Could anyone please review this patch?

thanks,
wengang

> On Jun 17, 2022, at 6:16 PM, Wengang Wang <wen.gang.wang@oracle.com> wrot=
e:
>=20
> inode io lock and mmap lock are exclusively locked durning reflink copy,
> read operations are blocked during that time. In case the reflink copy
> needs a long time to finish, read operations could be blocked for that lo=
ng
> too.
>=20
> The real case is that reflinks take serveral minutes or even longer with
> huge source files. Those source files are hundreds of GB long and badly
> fragmented, so the reflink copy needs to process more than one million
> extents.
>=20
> As the source of copy, besides some neccessary modification happens (say
> dirty page flushing), it plays readonly role. Locking source file
> exclusively through out the reflink copy is unnecessary.
>=20
> This patch downgrade exclusive locks on source file to shared modes after
> page cache flushing and before cloing the extents.
>=20
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
> fs/xfs/xfs_file.c  |  8 +++++++-
> fs/xfs/xfs_inode.c | 36 ++++++++++++++++++++++++++++++++++++
> fs/xfs/xfs_inode.h |  4 ++++
> 3 files changed, 47 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5a171c0b244b..99bbb188deb4 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1125,6 +1125,12 @@ xfs_file_remap_range(
> 	if (ret || len =3D=3D 0)
> 		return ret;
>=20
> +	/*
> +	 * From now on, we read only from src, so downgrade locks on src
> +	 * to allow read operations in parallel.
> +	 */
> +	xfs_ilock_io_mmap_downgrade_src(src, dest);
> +
> 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
>=20
> 	ret =3D xfs_reflink_remap_blocks(src, pos_in, dest, pos_out, len,
> @@ -1152,7 +1158,7 @@ xfs_file_remap_range(
> 	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
> 		xfs_log_force_inode(dest);
> out_unlock:
> -	xfs_iunlock2_io_mmap(src, dest);
> +	xfs_iunlock2_io_mmap_src_shared(src, dest);
> 	if (ret)
> 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
> 	return remapped > 0 ? remapped : ret;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 52d6f2c7d58b..721abefbb1fa 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3786,6 +3786,22 @@ xfs_ilock2_io_mmap(
> 	return 0;
> }
>=20
> +/*
> + * Downgrade the locks on src file if src and dest are not the same one.
> + */
> +void
> +xfs_ilock_io_mmap_downgrade_src(
> +	struct xfs_inode	*src,
> +	struct xfs_inode	*dest)
> +{
> +	if (src !=3D dest) {
> +		struct inode *inode =3D VFS_I(src);
> +
> +		downgrade_write(&inode->i_mapping->invalidate_lock);
> +		downgrade_write(&inode->i_rwsem);
> +	}
> +}
> +
> /* Unlock both inodes to allow IO and mmap activity. */
> void
> xfs_iunlock2_io_mmap(
> @@ -3798,3 +3814,23 @@ xfs_iunlock2_io_mmap(
> 	if (ip1 !=3D ip2)
> 		inode_unlock(VFS_I(ip1));
> }
> +
> +/* Unlock the exclusive locks on dest file.
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
> +	up_write(&dest_inode->i_mapping->invalidate_lock);
> +	if (src =3D=3D dest)
> +		return;
> +
> +	inode_unlock_shared(src_inode);
> +	up_read(&src_inode->i_mapping->invalidate_lock);
> +}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 7be6f8e705ab..02b44e1a7e4e 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -512,5 +512,9 @@ void xfs_end_io(struct work_struct *work);
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

