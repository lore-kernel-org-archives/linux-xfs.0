Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAC9C77B78
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 23:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjEBXrY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 19:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjEBXrX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 19:47:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF5B3594
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2023 16:47:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342IONLT031800
        for <linux-xfs@vger.kernel.org>; Tue, 2 May 2023 22:41:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=aIx8G9s/sh6cELRZowYrH/ZnJzZ69+ATtSEXM0GxbH4=;
 b=BW/x4soTtUYVNCT6SjzBsRMfC2rjqfMLqQnGcEUarkq6ItzvTVGvY4Kaetx4jB92XBca
 9TtsDNuwoozgs/6MzOZdvH3QZ3V3EBXlkn26zUomFWO+nxBTJspyuNJsoGubnkonv+/C
 2ZJHLbeUxh3s53hh7wbQWWK4vMww7cXoIYdPHLDdQlul4O+pI8KmWLsH+7wxFvMxQd2m
 SOjRy1GGzuMZBEv79mDdaoaiScOxMB+XUXX3mTjpdpFAFzPWpE8w075Si1Lx87qHSRW7
 6m8YfW5iggi4tsw4tl/QeXlpHNoI9c6oLK1VJu8UUErvc++DP3tloTLk94+NiwUzVPAk fA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8u4anvwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 02 May 2023 22:41:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 342LAbtp040476
        for <linux-xfs@vger.kernel.org>; Tue, 2 May 2023 22:41:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q8sp6cvc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 02 May 2023 22:41:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZluQEv8+SL2UbIvvvBXY8TZiKFzEZ4xVRoMiTj6C33PQa5+aYbcmxVDphZ60dwsRS80DhXRzP3ZdGXhW9NPg/WNIYyyeGQN1Bvq5J/X53sSQteIwpqiwdN4SxQr7++7jKfkzH7+XRYqrduZoOkpznJ73MPSKv3fiYIQqvAoIhjtq/Djumi+CDdtLdfp0vLXvPgUvkFChAtb/51Xn4Yr3FQYGH2eRgWI51okwWA53dbiF8GklmgNMtAa3SxKZsxW3cAT3cyJU5AgAJHhEnaAcCxCj6ba4U/Gcp8MGP5aIi+Vwrxv8zpZI/77qYadb9c/CADCnT+xptKmUfGdehGc4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIx8G9s/sh6cELRZowYrH/ZnJzZ69+ATtSEXM0GxbH4=;
 b=SDMMPViRGm9RuxIlhMm8VdVnQ0C/1bf/2mltzLUQpUhI5j5bOYv+nECm7c9rdjYdiq86yyxRoSy1CF8N6m9XY5oMzs/BqLgsG/JqIT4G0vdTLz4KUWc1aO1Vm2jmxgsbu5Pzfc8CLyt+X84jRrUAFnM4ue8TK/pBSS7D+Ktj5HTTxCh3SUzSs/kXbkQaVN7zYzKe4gMXkrNWaWUpeKl6aE+v1PEMqq6K607t/PTO/SKuvnwHf3LTuh/8UCpn6lOUPLRFU4jEm7dAVLxcdrAL9MRDtMw6JKa7rQyMdvklRfLVwLvevs/rJPo/cIP7Tj75OFe5cRciie3mOKnVWSQdLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIx8G9s/sh6cELRZowYrH/ZnJzZ69+ATtSEXM0GxbH4=;
 b=oldsnFs3znJNXypRdP8ygskuRStwii3PoN4ffEvomffv52EPHdAY1Npg/rGvs4ZHn2lMX0P2Fpiq+ZN4eBOzqOITGmq5G14wQuNwRaSqgcQK7T7enP/9i8omInFMJDpcmZ25lGyFZOC41azk4Nq9s6of66MwcGUCVqC9Th/446c=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by BLAPR10MB5202.namprd10.prod.outlook.com (2603:10b6:208:306::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 22:41:09 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b%7]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 22:41:08 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Thread-Topic: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Thread-Index: AQHZdv9AR28b2kBDxE2gDgdaeEYEXK9HoFQA
Date:   Tue, 2 May 2023 22:41:08 +0000
Message-ID: <0CBA52BA-BBA3-4E52-A40B-E739347C66FD@oracle.com>
References: <20230424225102.23402-1-wen.gang.wang@oracle.com>
In-Reply-To: <20230424225102.23402-1-wen.gang.wang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|BLAPR10MB5202:EE_
x-ms-office365-filtering-correlation-id: d2f05e99-c758-4524-b948-08db4b5e52a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9trjd+ihr2fnnDtridJQEtyxKas/qdqc/LHQgFEO5X9ifmasykwhi/yBXF7qywskkX7dmPuUkBpFCdyqM/d2lq7T5oOpAnMEqX3J6Vh8UCBhAaiysq4vu5BR2lRhGbrHr1kgyV/Fu9Qh6evB/JZAg8pbya/7RsrSqLZZ2QZvXDdXv8pyTusrAEv99VRfsnRPrbiTeZxMf7CDtSHcdOsOTOHVjYtHDA5ZcB1ocwIlCHY4clnwHB35wMOCHCHto1NYAd+8I0jpFD2kzH97+O3VNqLF/x2Vk2ajGsuSDGUTq69rX7X13yZZlKSZt77ypGHpJg83vCw4p09I1yrG6lDWCVXoKiK9ykXDLJ65Zh/y+l9tP5jE/b9YUbWbLPxb8unanCOaOc78AX2LwJOGWIClOxobgGmgoBm36oCDv3AwG2yQct5UAQUS6+fpzzGq2Vn+Xs1Ch+AxAUQr1H9Bnyv/lodNKH32tUZ5L9mbJgvTM9J+Kk3FLfq45X3w8bdcopBHVSGD1ip18aHu0bANHCdRvdfiAzJNDHU020C2Ij7QMTF9eRq8QMRMiS9rUQDktsWoA9Mq9rEs2BgVAqpHWFPUWfRxdFF1j1lWrdEKT9HIyLyOyUI9rL25QENdtq1EQ7DIp6BptuTiLsibwefVZgpedg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199021)(38100700002)(30864003)(76116006)(8676002)(8936002)(316002)(66946007)(41300700001)(86362001)(91956017)(33656002)(38070700005)(2906002)(122000001)(478600001)(66476007)(64756008)(6916009)(66446008)(66556008)(5660300002)(6486002)(71200400001)(36756003)(2616005)(83380400001)(6512007)(53546011)(6506007)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j5EsI7zBVjNN70JiHg7p3PmDo4UwKoEcUhxa63qY42YaF1u3UabKXkQIJobC?=
 =?us-ascii?Q?3n3vYYis1AhLzkEevDtucNHtKVQLMnND9lq4rdX5x2E92yjcS8KJpwS/R1CL?=
 =?us-ascii?Q?+3Ww6YWR7KdJZEtq8uOnEAUQGYTk8CDEduYX+lC1900Y+OVsbnugutpNOGWP?=
 =?us-ascii?Q?HG8qwyY/0AUfuouFVm4jZ5laGrocgqQfkZV8O3YW3FSu5hzB0nWbCiv79+QX?=
 =?us-ascii?Q?DU657VryUsXA4cs+d3PHzftt03iMz6WYxyXASCTPCAJzvzv2yzTXcj2spWEs?=
 =?us-ascii?Q?qsz1ejPOFcnH+MSQlijPVAXWfkgTa2voSLL9e+dhdHCGQ0m/LqE2m1sAIkcz?=
 =?us-ascii?Q?USTZ3dL6y2ojgbuNGmp/BXdGS7x9TAG/yCtXYa/gaL+qs+tyqraOtzzb6cOJ?=
 =?us-ascii?Q?IMKBvxVYGWz6w1v4rZHvbg+UXeSXUubuTxkZWdRiD9UVPOQQTGNP3h2BH1JJ?=
 =?us-ascii?Q?4zzY42RpIEBMtqeSetrO46YOiB+MeHf5K2Vso2+xFt5hiEgT60Q4H/7aicM2?=
 =?us-ascii?Q?yYN7gDqeiYUm5QyPZHHRypbpZxTwCNlyPSKxqUm+QsVY2ZiNYLgx57aw8DhP?=
 =?us-ascii?Q?qJEoEvaFy5bm4PISUY5asvAqnByStIOwQ3H0YU/Nc4g3Pz4+EyWR46DrEJQR?=
 =?us-ascii?Q?9zaHWiF3bGcghWuOCU3QvuOdwCcjs/r52Ig7dFIqSJ64Hmr7Of0ptN1GOpIk?=
 =?us-ascii?Q?UFAXRwdTLiYx/E6JaawzSSxxAqi5/PSxSkD/9p6+BfIjUuJZ6zZOgD8JTYnF?=
 =?us-ascii?Q?2GcT53pk/iA85SRUvj2GOwWIaPx55XRnRIpZwfO6pbxrru2XagRHpeVXdLol?=
 =?us-ascii?Q?yg0oQ6p9BYLXPk1jFgIJIKOPfFbEQ1sGNwGTyNOc5f0RM7Ur8rhW7hiKZFOv?=
 =?us-ascii?Q?qDnp8qW2iGMSh9Ln5bA9/ezbfop9g3fcFdF1gKSV6Yv96lvhlcbX2oaTs1DS?=
 =?us-ascii?Q?GD127tuwyNVf4b/LncBAkclC2j28mfyPAnLKlqxDb/kUlpI34E33zK5tp55s?=
 =?us-ascii?Q?zADTWS/wqHAw+4TP+dqkQoRsib2EjABBt/WXtogjgJsdHtkZmTgzzM+Dud3I?=
 =?us-ascii?Q?CSMTXVw9lz7fF84QGxEp2MwUfet3k1U9wN8tC3+IuchswVg7ih5hEkx57mn8?=
 =?us-ascii?Q?7BZk3sghF36WPpsD6Rm0H+jBnTPbJwMMOUZVaCnf01ryQ7FVbFjKBGm7wD0d?=
 =?us-ascii?Q?j1pKOf2LMglSrixKY/bRA6c+xn0BOT8NP1ddC0i2b36B/PhkdBoRb1YBXOn1?=
 =?us-ascii?Q?c6iqQHENTuMFaAfl8VA86uz9dEDa8XqwIPr16Je7HK4+THtodi33h7e+1gDh?=
 =?us-ascii?Q?TsajT0xoOinxmjFQ8OwnRAukQOETl5EqetosJcGgTMRv2bjv+dVBWAqRW3tj?=
 =?us-ascii?Q?6OeirXZlgqA4V1Dc/m73lp/fp7i6WsWFXRRSL6TjqlSVDcAKY1EhiDO0SUW7?=
 =?us-ascii?Q?FKA0nVBq3JvhlVcnfdXsTubuRHEh+/8DUMBnpmoXpTjStrnCN5o5CzQwOUP0?=
 =?us-ascii?Q?SD97x7KP3RlEoReqBgz5EVfKGdKTfEAMndiy98EbCUHIWI1ay1FTW4prYZ2Z?=
 =?us-ascii?Q?jeSewWR1P9g9RvDRPlb1B+JP1+hYPxgxa5LCfpkbV5tJ/ib+VCtbl+EiWlQ7?=
 =?us-ascii?Q?g2jCn8vm1IZ6L6GnlXMQ8m/exOvFPUpVhyDtwB4c982Un4Ws8JVoNhWkWxvQ?=
 =?us-ascii?Q?7FsKrg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3D34E477CB7574B9DD9A37E87406428@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Hj75Q26tI7RE0bEPAyPOa6G7wZ11rwcRbE6h5rGWGWBuCuEbXOSI/b7mEFMQRi8d8EM9EHYrPPHwhBDRAJTXZZg0G7Tzjb1qRMkEe7qMLqi3gmq/DBSeOQ1Hfu+Dlr2PQ5OThs9H9jyi09BOwDxqIGpRFmbyFH8kflTg3zXfCV/7Y5hWuSl3un5Nt+dLd/TjZd+9qEo5qhLj+JPc4V3l+sDl7fcH5OZvrF5G2nEuYK+n6nubdjWMyLBASnrF/5R5KgkwlN+awG01crabNL9RcfVL6vP8ouQMWs4gkATTeojmzWC4Y+VSnWMHBG9mgi2JMZpoQdvWwbnyMOthR2u5GqcIzv6dC+e/hz+3hrL/VxQ6Lyh02WQxVYENwlW7kdjx+88LhFJIAogX6dzCLSJG+4vMMxu1FZApObdWBKwv72A+4l5A+oOKFifcQXNZhVrFWOrwgHxsGYSM41NJrPLVJahsqxPc8Yf+3Hs7FJKPSRaURNNHVknEH3opDZo/a7aVao3I20bxqyTDCNfwdMBYBZ22FRX2p6D/6eIJFH2Ae5JRFDpLim6H5kqqx49bHHFlUmszen6jvkYg9sZCagicb7v6w1RvMEkZVzwd8XOcZ+2uzJ5PZEZPnz4ios7Hb+OeSaSUXwEBTh6rOmFgCYos6eTHmmg5C2ger4USZAUwUfy0mWCe64dlK2T4N46wqS2mH4z8Ppqm5Prz7gLyNx1YrWS6izHG4Xf0F9nGeC6MU/1YDX9OpdmFn+Q6DWTusWi5wYHMFiCS76wiRPPGjzYTzw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f05e99-c758-4524-b948-08db4b5e52a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2023 22:41:08.8370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wkog9WNwg85T27nPYL/kXlemQml1jQ3IkHgec9pdnggQgi3J1tGfexRahA0xYZyV4GOAQMmY2+zPNPFQ/9RgbL0Rh1yR7FO5xTkmtUVVt6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5202
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_12,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020194
X-Proofpoint-GUID: 7aHNNyglletxrwfzJYquwSwguZQyzWfq
X-Proofpoint-ORIG-GUID: 7aHNNyglletxrwfzJYquwSwguZQyzWfq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave, did you get a chance to look at this?

thanks,
wengang

> On Apr 24, 2023, at 3:51 PM, Wengang Wang <wen.gang.wang@oracle.com> wrot=
e:
>=20
> To avoid possible deadlock when allocating AGFL blocks, change the behavi=
our.
> The orignal hehaviour for freeing extents in an EFI is that the extents i=
n
> the EFI were processed one by one in the same transaction. When the secon=
d
> and subsequent extents are being processed, we have produced busy extents=
 for
> previous extents. If the second and subsequent extents are from the same =
AG
> as the busy extents are, we have the risk of deadlock when allocating AGF=
L
> blocks. A typical calltrace for the deadlock is like this:
>=20
> #0 context_switch() kernel/sched/core.c:3881
> #1 __schedule() kernel/sched/core.c:5111
> #2 schedule() kernel/sched/core.c:5186
> #3 xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
> #4 xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
> #5 xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
> #6 xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
> #7 xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
> #8 __xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
> #9 xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
> #10 xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
> #11 xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
> #12 xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
> #13 xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
> #14 xfs_log_mount_finish() fs/xfs/xfs_log.c:764
> #15 xfs_mountfs() fs/xfs/xfs_mount.c:978
> #16 xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
> #17 mount_bdev() fs/super.c:1417
> #18 xfs_fs_mount() fs/xfs/xfs_super.c:1985
> #19 legacy_get_tree() fs/fs_context.c:647
> #20 vfs_get_tree() fs/super.c:1547
> #21 do_new_mount() fs/namespace.c:2843
> #22 do_mount() fs/namespace.c:3163
> #23 ksys_mount() fs/namespace.c:3372
> #24 __do_sys_mount() fs/namespace.c:3386
> #25 __se_sys_mount() fs/namespace.c:3383
> #26 __x64_sys_mount() fs/namespace.c:3383
> #27 do_syscall_64() arch/x86/entry/common.c:296
> #28 entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
>=20
> The deadlock could happen at both IO time and log recover time.
>=20
> To avoid above deadlock, this patch changes the extent free procedure.
> 1) it always let the first extent from the EFI go (no change).
> 2) increase the (new) AG counter when it let a extent go.
> 3) for the 2nd+ extents, if the owning AGs ready have pending extents
>   don't let the extent go with current transaction. Instead, move the
>   extent in question and subsequent extents to a new EFI and try the new
>   EFI again with new transaction (by rolling current transaction).
> 4) for the EFD to orginal EFI, fill it with all the extents from the orig=
inal
>   EFI.
> 5) though the new EFI is placed after original EFD, it's safe as they are=
 in
>   same in-memory transaction.
> 6) The new AG counter for pending extent freeings is decremented after th=
e
>   log items in in-memory transaction is committed to CIL.
>=20
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
> fs/xfs/libxfs/xfs_ag.c    |   1 +
> fs/xfs/libxfs/xfs_ag.h    |   5 ++
> fs/xfs/xfs_extfree_item.c | 111 +++++++++++++++++++++++++++++++++++++-
> fs/xfs/xfs_log_cil.c      |  24 ++++++++-
> 4 files changed, 138 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 86696a1c6891..61ef61e05668 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -378,6 +378,7 @@ xfs_initialize_perag(
> pag->pagb_tree =3D RB_ROOT;
> #endif /* __KERNEL__ */
>=20
> + atomic_set(&pag->pag_nr_pending_extents, 0);
> error =3D xfs_buf_hash_init(pag);
> if (error)
> goto out_remove_pag;
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 5e18536dfdce..5950bc36a32c 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -82,6 +82,11 @@ struct xfs_perag {
> uint16_t pag_sick;
> spinlock_t pag_state_lock;
>=20
> + /*
> + * Number of concurrent extent freeings (not committed to CIL yet)
> + * on this AG.
> + */
> + atomic_t pag_nr_pending_extents;
> spinlock_t pagb_lock; /* lock for pagb_tree */
> struct rb_root pagb_tree; /* ordered tree of busy extents */
> unsigned int pagb_gen; /* generation count for pagb_tree */
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 011b50469301..1dbf36d9c1c9 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -336,6 +336,75 @@ xfs_trans_get_efd(
> return efdp;
> }
>=20
> +/*
> + * Fill the EFD with all extents from the EFI and set the counter.
> + * Note: the EFD should comtain at least one extents already.
> + */
> +static void xfs_fill_efd_with_efi(struct xfs_efd_log_item *efdp)
> +{
> + struct xfs_efi_log_item *efip =3D efdp->efd_efip;
> + uint i;
> +
> + i =3D efdp->efd_next_extent;
> + ASSERT(i > 0);
> + for (; i < efip->efi_format.efi_nextents; i++) {
> + efdp->efd_format.efd_extents[i] =3D
> + efip->efi_format.efi_extents[i];
> + }
> + efdp->efd_next_extent =3D i;
> +}
> +
> +/*
> + * Check if xefi is the first in the efip.
> + * Returns true if so, ad false otherwise
> + */
> +static bool xfs_is_first_extent_in_efi(struct xfs_efi_log_item *efip,
> +  struct xfs_extent_free_item *xefi)
> +{
> + return efip->efi_format.efi_extents[0].ext_start =3D=3D
> + xefi->xefi_startblock;
> +}
> +
> +/*
> + * Check if the xefi needs to be in a new transaction.
> + * efip is the containing EFI of xefi.
> + * Return true if so, false otherwise.
> + */
> +static bool xfs_extent_free_need_new_trans(struct xfs_mount *mp,
> +    struct xfs_efi_log_item *efip,
> +    struct xfs_extent_free_item *xefi)
> +{
> + bool ret =3D true;
> + int nr_pre;
> + xfs_agnumber_t agno;
> + struct xfs_perag *pag;
> +
> + agno =3D XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
> + pag =3D xfs_perag_get(mp, agno);
> + /* The first extent in EFI is always OK to go */
> + if (xfs_is_first_extent_in_efi(efip, xefi)) {
> + atomic_inc(&pag->pag_nr_pending_extents);
> + ret =3D false;
> + goto out_put;
> + }
> +
> + /*
> + * Now the extent is the 2nd or subsequent in the efip. We need
> + * new transaction if the AG already has busy extents pending.
> + */
> + nr_pre =3D atomic_inc_return(&pag->pag_nr_pending_extents) - 1;
> + /* No prevoius pending extent freeing to this AG */
> + if (nr_pre =3D=3D 0) {
> + ret =3D false;
> + goto out_put;
> + }
> +
> + atomic_dec(&pag->pag_nr_pending_extents);
> +out_put:
> + xfs_perag_put(pag);
> + return ret;
> +}
> +
> /*
>  * Free an extent and log it to the EFD. Note that the transaction is mar=
ked
>  * dirty regardless of whether the extent free succeeds or fails to suppo=
rt the
> @@ -356,6 +425,28 @@ xfs_trans_free_extent(
> xfs_agblock_t agbno =3D XFS_FSB_TO_AGBNO(mp,
> xefi->xefi_startblock);
> int error;
> + struct xfs_efi_log_item *efip =3D efdp->efd_efip;
> +
> + if (xfs_extent_free_need_new_trans(mp, efip, xefi)) {
> + /*
> + * This should be the 2nd+ extent, we don't have to mark the
> + * transaction and efd dirty, those are already done with the
> + * first extent.
> + */
> + ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
> + ASSERT(tp->t_flags & XFS_TRANS_HAS_INTENT_DONE);
> + ASSERT(test_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags));
> +
> + xfs_fill_efd_with_efi(efdp);
> +
> + /*
> + * A preious extent in same AG is processed with the current
> + * transaction. To avoid possible AGFL allocation deadlock,
> + * we roll the transaction and then restart with this extent
> + * with new transaction.
> + */
> + return -EAGAIN;
> + }
>=20
> oinfo.oi_owner =3D xefi->xefi_owner;
> if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
> @@ -369,6 +460,13 @@ xfs_trans_free_extent(
> error =3D __xfs_free_extent(tp, xefi->xefi_startblock,
> xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
> xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
> + if (error) {
> + struct xfs_perag *pag;
> +
> + pag =3D xfs_perag_get(mp, agno);
> + atomic_dec(&pag->pag_nr_pending_extents);
> + xfs_perag_put(pag);
> + }
> /*
> * Mark the transaction dirty, even on error. This ensures the
> * transaction is aborted, which:
> @@ -476,7 +574,8 @@ xfs_extent_free_finish_item(
> xefi =3D container_of(item, struct xfs_extent_free_item, xefi_list);
>=20
> error =3D xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
> - kmem_cache_free(xfs_extfree_item_cache, xefi);
> + if (error !=3D -EAGAIN)
> + kmem_cache_free(xfs_extfree_item_cache, xefi);
> return error;
> }
>=20
> @@ -632,7 +731,15 @@ xfs_efi_item_recover(
> fake.xefi_startblock =3D extp->ext_start;
> fake.xefi_blockcount =3D extp->ext_len;
>=20
> - error =3D xfs_trans_free_extent(tp, efdp, &fake);
> + if (error =3D=3D 0)
> + error =3D xfs_trans_free_extent(tp, efdp, &fake);
> +
> + if (error =3D=3D -EAGAIN) {
> + ASSERT(i > 0);
> + xfs_free_extent_later(tp, fake.xefi_startblock,
> + fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);
> + continue;
> + }
> if (error =3D=3D -EFSCORRUPTED)
> XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> extp, sizeof(*extp));
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index eccbfb99e894..97eda4487db0 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -16,6 +16,7 @@
> #include "xfs_log.h"
> #include "xfs_log_priv.h"
> #include "xfs_trace.h"
> +#include "xfs_ag.h"
>=20
> struct workqueue_struct *xfs_discard_wq;
>=20
> @@ -643,8 +644,29 @@ xlog_cil_insert_items(
> cilpcp->space_used +=3D len;
> }
> /* attach the transaction to the CIL if it has any busy extents */
> - if (!list_empty(&tp->t_busy))
> + if (!list_empty(&tp->t_busy)) {
> + struct xfs_perag *last_pag =3D NULL;
> + xfs_agnumber_t last_agno =3D -1;
> + struct xfs_extent_busy *ebp;
> +
> + /*
> + * Pending extent freeings are committed to CIL, now it's
> + * to let other extent freeing on same AG go.
> + */
> + list_for_each_entry(ebp, &tp->t_busy, list) {
> + if (ebp->agno !=3D last_agno) {
> + last_agno =3D ebp->agno;
> + if (last_pag)
> + xfs_perag_put(last_pag);
> + last_pag =3D xfs_perag_get(tp->t_mountp, last_agno);
> + }
> + atomic_dec(&last_pag->pag_nr_pending_extents);
> + }
> + if (last_pag)
> + xfs_perag_put(last_pag);
> +
> list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
> + }
>=20
> /*
> * Now update the order of everything modified in the transaction
> --=20
> 2.21.0 (Apple Git-122.2)
>=20

