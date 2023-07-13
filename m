Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3FFEB64DA
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 01:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbjGMBkH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 21:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjGMBkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 21:40:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABCD1FC9
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 18:40:05 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CLA1gx030851;
        Thu, 13 Jul 2023 01:39:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Q0Rb945RZEWb4UrMsGSH42htmkHMIJHEIKUSSh6Mxj0=;
 b=06TcZuWbftINlp2iK8W+RGtE67p+HcyOSFam0DdmyOq5nmZPOR0024y4fRLyauD04DZB
 vbRDhEZAK/ih55+BMl0nkpGGSqpTbXtq2jGSVp09VJ24sSs0QFMHb++PtnWNGwu9ypAU
 krfC2cOaWrA75iTfpldRhOL3zgbtJ5NRSM5TApZLY43rXlRPt5eP1tl84kTIbQy19Mqi
 KEKd42sIxLIYOHQId0Na9pXqGttfhr0aZg5Z+GJN6jeq1Pj1zI4L3ySGCCwOkcT/pOEq
 NkUwEETa/p2EbpXyIsY5FLgwrxJyah4tW6DvO8dxDtX8EUCSGH9fa1M443nSYYVpV153 9A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrgn7xa95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 01:39:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36D1WixT027060;
        Thu, 13 Jul 2023 01:39:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx87hn3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 01:39:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6DutkTeTiCaSfSvOjdc7acL6GsDt9PKKYb3k6ldSjn55xW3OjXvSDf+DA8KWLotfDGZtz0DZF121ro7H5FkuxZqG1ifNdS3A3upF2sAWgAe1ub/gQatpGkobVMK3qWvhjTO6UsqVgQUpgXYCbWFhLQJhIOOovnr87RebRTvbZLw8IVuFRy7Uu6h2GqlCTDSVnVCl4BAmDVKAvVW/7g/+YXYqj/nDiWFN2p93gNTTmvLOFSqo1mqGhTcJ3yf6x/oGKfg7ylEMRouyWpbkbDRUz/w6PDeBW3vDoQhg1oUFxU61qmrTJOpiobBmqFmN2fBcJmwJp6PqOpT4mt/5+GmXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0Rb945RZEWb4UrMsGSH42htmkHMIJHEIKUSSh6Mxj0=;
 b=Po9cSrMz+VugC+KCfEOhcryyKtTRkpt1cEvUp4LDK9D0QGIT1C5AoIJpYdnZSSSECBI8d6PUTuHCQK+zDObfJlMmojjFGJJudtf54px5nyx4UvCMV5WVlkoyrMXNeH/nlXuMSM2MvV2LEfta9EDAldqehZnmT39nG530q7MHmTur/b4LienRKx7JlsdY0d/I1YJgLqJoA04rptejf9IWrI8itMQgAMOoZGTn+EaYrYuqbDE1jxLh0vYnOnZBnc/Nf53Wb7f7ObEIhZtMx1tMs+JJthJLmnGr8Xz5ZKNVjRXIhCe1KuDagJ8P/a3+xULMSTwugF4A4RTzgzg/vF18MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0Rb945RZEWb4UrMsGSH42htmkHMIJHEIKUSSh6Mxj0=;
 b=Pehzug0h1a8UX3FCTY1k23A1M/rK0UgSMa7di0wqQW5FtS87YY7bComkA6jfC+fqqscsh/Sw57VDxviRSr9zjdbA1YWKgGv3vnvurlAUHHyC5FcqyBbSw4oEkGxrDvN0ki7T8BIbmmtYOq6v+u5v+AJLlEMM01M2qNNIEL7x1hw=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by CY8PR10MB6516.namprd10.prod.outlook.com (2603:10b6:930:5c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Thu, 13 Jul
 2023 01:39:55 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::bf45:a0e2:8ca9:7521]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::bf45:a0e2:8ca9:7521%2]) with mapi id 15.20.6588.024; Thu, 13 Jul 2023
 01:39:55 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: xfs_trans->t_flags overflow
Thread-Topic: [PATCH] xfs: xfs_trans->t_flags overflow
Thread-Index: AQHZtSd4yIZ6Bvj8AUGvaVr7D4khv6+25p4AgAAE4IA=
Date:   Thu, 13 Jul 2023 01:39:55 +0000
Message-ID: <4CFC395B-832E-4354-BDA0-34BBC671CCA8@oracle.com>
References: <20230713011508.18071-1-wen.gang.wang@oracle.com>
 <20230713012218.GZ108251@frogsfrogsfrogs>
In-Reply-To: <20230713012218.GZ108251@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|CY8PR10MB6516:EE_
x-ms-office365-filtering-correlation-id: 62be72c4-70e4-483d-84ac-08db83420faf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AXUbiHAGs/qtSnUw+kIIBbIMPE8S2yyoabklkbSo7Brfl6K2sjSUPtbe5pm8ZVIS25XP8S4xLwsE9B6EYXsnuZiJhOh5gNUoLSvU0VK1pSXBcHRXgTrRv6smn/+Ezt/yYJgOgJvK4qRmTf83r5pxihEcEoOKtWD+Wcz3rxia3rFLVgG1juehAqucK+pfeVGe6N+nHCK9pyt5wZi9/IM1HfWIoLrjKaNsrL2ceL/3dcI4p996hZromr/0EQ1+q67cU6yj9m1pu/37Fp5YV+fiSaNFmoAYGhogfXclPBTj2MfxDk+t7teIElrvIS7zMb8ZubhqNnhEpcMPmKdWUPK/Y+gGnSpUTVQligbYfSEuHzTHOhqRQq3fLbTiM2y6j6t/vQe9NEEI9gfFRNhH7JtE6GkuFqPZfFb8f/fIdCit6/38jiypnixG6ltm6agoHh1Xk585l45KSa/3xPNg+e6UvwchS/LrMsc3RdrJvqUgUF2WsCav55w1N7D58wP/1ZFJP6j3MDBVsr5+/E9a9sd9oiQqLP6mRjBQxA3jK4etLsiA3XfpViHHlE4kNqBO04iyqPfsFVakyMuq/PAVwm8pjjR0XCaQc4kRjwr6Rh71gw9MgYSfvBtQnT4LZrxc5JC2Zn3eWcN3BfzWUhSpQ2nI4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199021)(2616005)(2906002)(83380400001)(36756003)(33656002)(38070700005)(86362001)(38100700002)(122000001)(41300700001)(6486002)(6916009)(6512007)(4326008)(316002)(5660300002)(8676002)(8936002)(478600001)(71200400001)(76116006)(64756008)(66446008)(66476007)(66556008)(91956017)(66946007)(186003)(53546011)(6506007)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5WIObLZlFSnalZk1/C1SGpsffuh+JeFPnnO54IRkihU2HZfyJFNPvbF4CLpB?=
 =?us-ascii?Q?7PVd6ogqSzU+tQl6qyEtD04ioO1xOfqpP8uIwNM2apREjoKB6OhSObsKYo8H?=
 =?us-ascii?Q?Zobm8ZnEYqAgR6FetV/POlpSonRziASDCgfr3pnCrriAGk6da5QjU3DJwgcT?=
 =?us-ascii?Q?865AU821DVFpNqgJ/N2jedJXg8eQaFWnDli8+96LfG1OLFHA1iGaU9j8RdJq?=
 =?us-ascii?Q?nQwjFtOkztumOfIQT0i6v0AD4lYcKSBULMpiCKdKYHb+/BtchfHjVHMi8T6d?=
 =?us-ascii?Q?7cYFJ8PKmlhkEBIQFHjNylfRBfd63boXaZrppqyvpz5AX3Bbeatgm33S7p6f?=
 =?us-ascii?Q?p5oF3sKQCwNTYxy1kE8pyvQIaNR0z/Fb4kb9lK1J9eA6FTUutrdX2ysMxBJG?=
 =?us-ascii?Q?7BoC5KIceyEgJfo9llUZ9fyKcT0Fz0cYH1gaT4cZEaBtrCRX5iEiz4YDf0Kt?=
 =?us-ascii?Q?pU5EZKYcZJ5jlHgmZn0m4DxYGZEpGH7l3MnWmrto4i4H6vnlbh5oOZZilndq?=
 =?us-ascii?Q?R2fRNdaY1SYfU39J2rjysMVIajBce/d5P12g5vH6tuHReUNfBWpRNcI8ZczW?=
 =?us-ascii?Q?VxyANrFIpFr64CMhw+b8ApG6DAyS5YaNAZhYpbcVGBkjxz0j5MC74JkJkmw7?=
 =?us-ascii?Q?+lc7H6jKF9RiPkph3m+sk0sK/Bh4V9jLgXeRZNfHx8hpK6RAzu9nKfM4g0Pk?=
 =?us-ascii?Q?+rEPDdE4N4mF+rfQhJJcqre3Is3zUysZAZZpe1ZYZL2J9naCCsY/zYn3W5I5?=
 =?us-ascii?Q?9OXXDJwRDUe8wg5yGLiUsqqGPY22mF+mr8+GfJdgFK1P91kru4TOd+F53vZO?=
 =?us-ascii?Q?P5AxboUkoYxg/9F0ZovYmq0rL6InikCHT5FOX6inSqaMpOT2kM/OHX1UII0d?=
 =?us-ascii?Q?Sw//h8QmZa75dyNBxMHKEgHrSNvvrUgpudJHAbxG4aXQfrhNm5R0ESu2bj4p?=
 =?us-ascii?Q?wAW+z97ZFpcyajWnb2EP1KvIubOy2AKlbO9NBmxZPO4NetO0H5jPlaby+D/E?=
 =?us-ascii?Q?dCEAT8jVzohv9/C2wHbUqKxvm7uCt9eE1J4oO+jWJNU+YTvt/NqNzSwBCkf0?=
 =?us-ascii?Q?t+63mbBtcGVhJuNnBF4JmGOM/GxwQDbm/rHd6zAGulyWMdCOF5eLA9oUBy7N?=
 =?us-ascii?Q?DgMWTxMJvdm8fJqmLsWLAdDg5Xc0dAol7kliZ7vuMzToJvYLvmrCpj9i3oy3?=
 =?us-ascii?Q?ertQNXBxc0Olgo0dmmQIFEz5psBKU6qYzKylyz3UiYYgjY5oHG6p0JMLv7mO?=
 =?us-ascii?Q?NlBIUzO+ujbdwL06lBXGVbUh/K3BJgfROPr52qMyiiotN1aLe/5xZKnDspHY?=
 =?us-ascii?Q?aVlaGTSRxGUxuu7imbUDLuXTqk/TOqoSXDs644gH5PUEpU72qfZBZrpxQ93f?=
 =?us-ascii?Q?e6XFV3ysklmYC9Zu6PUfjWeMRx5kQtgwjyNPA7W1jegkytshEfGSozWrzb+1?=
 =?us-ascii?Q?dU8KWnI6jvUG822md14fkJ0i3/IYi8Vm+H5hwt3h+vjDsGmInAwQVOfUsUkX?=
 =?us-ascii?Q?EmEeu9Hs9hpK512PEErgDr5PNlA57zOo1GxAPh++P51i+ut/RZd8ouwqr/qm?=
 =?us-ascii?Q?cg0NE8Z6xSiQS71nmZNGbWJq4H8qY8NKucAaOH0hYhvF9nkZwm1/imF6mx02?=
 =?us-ascii?Q?YQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CC6CDEF5EE71A34AB7BE7B0E5FC26961@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YVE6xEgI8F/WsI0Nm4hyLPz3dlT6AFrjVxomnea8Tg+G5MIwETiordwn9lr5wEYSfi8nPsAVYyjqYP+PNT0JHxOYdNPT/tbVJ9JN26ENQa3xE3UJmgNcHg0I3n6QhlC+wFZhEMlSeEFZHEFSQX9DXi/HYLioLdMScW2WW3quU451226BX1DkNKlnbI51vKVQa1bJUZc/p+WsEd5A4Bot2cToCUKdxJtr18Tg4tOy5Z0fcgvkVuHH+ESIbDrV6BiAZZyZQ4PM9Vdqh5Yq9IE3DqVYycbnt4gC7ms/z+I9eExogxIqyYmOstxDwxtTgfEhW2qNLbs4k8Yo8cJvVdXkK1/Bb1Y3Uuslowo7L4jpLihbd+/qrZ4SVgM8zMmrotuZj3kJiu0Ae3hlcWGgVvYk2MJBr4k/AqDllZhW7iFiezTICxIURt33QmuImeBm48C7auzytK5A0rJ1vyT8DDpZIlfTQqf/MXFH7aIbCge1dO3Q/55cj7slET8F8AY5dacWtpNtAUKxVGc6xeFXYGY57kMf6hNhC9ileEfxd2UOdtquyRFkSZscRhZE/WGy1FthvF16wpyQdiguXlJqVm8UGgiACDAYCe51LmPyZYI1ZqDoHP+b9Yd+PE38+qkWLEA3ec6Sm5VLRwDDQ2M4BDc7hifVHXy1HIPTJ4pv7myoaEV7NZEAmlhEi09QKrE0cPm8KZNAGwVYRj3Gf30kYEK/Wu2sfWjQDxjq1ULyLqIDuQ8NT/Z1OkQkVzZrxHlykhptTlJxfTI24hj41UmofAl/heEynYgRaLQJPbgmMYVSLrw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62be72c4-70e4-483d-84ac-08db83420faf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 01:39:55.6885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zns9QSNLuoXwO6U77zDITa+T2e1BWOT80Q0HjPUNBrOr669CBriFZUZBe3rEedoW2rixhg6tDV7LJaASfqFjuPSzLswHAG6NB82FYxASE3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6516
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_17,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307130013
X-Proofpoint-ORIG-GUID: jIOmdsn70uGPRQN2mB7JDLEtEzgplupa
X-Proofpoint-GUID: jIOmdsn70uGPRQN2mB7JDLEtEzgplupa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Jul 12, 2023, at 6:22 PM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Wed, Jul 12, 2023 at 06:15:08PM -0700, Wengang Wang wrote:
>> Current xfs_trans->t_flags is of type uint8_t (8 bits long). We are stor=
ing
>> XFS_TRANS_LOWMODE, which is 0x100, to t_flags. The highest set bit of
>> XFS_TRANS_LOWMODE overflows.
>>=20
>> Fix:
>> Change the type from uint8_t to uint16_t.
>>=20
>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>> ---
>> fs/xfs/libxfs/xfs_shared.h | 2 +-
>> fs/xfs/xfs_log_priv.h      | 2 +-
>> 2 files changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
>> index c4381388c0c1..5532d6480d53 100644
>> --- a/fs/xfs/libxfs/xfs_shared.h
>> +++ b/fs/xfs/libxfs/xfs_shared.h
>> @@ -82,7 +82,7 @@ void xfs_log_get_max_trans_res(struct xfs_mount *mp,
>>  * for free space from AG 0. If the correct transaction reservations hav=
e been
>>  * made then this algorithm will eventually find all the space it needs.
>>  */
>> -#define XFS_TRANS_LOWMODE 0x100 /* allocate in low space mode */
>> +#define XFS_TRANS_LOWMODE (1u << 8) /* allocate in low space mode */
>>=20
>> /*
>>  * Field values for xfs_trans_mod_sb.
>> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
>> index 1bd2963e8fbd..e4b03edbc87b 100644
>> --- a/fs/xfs/xfs_log_priv.h
>> +++ b/fs/xfs/xfs_log_priv.h
>> @@ -151,7 +151,7 @@ typedef struct xlog_ticket {
>=20
> Huh?  xlog_ticket !=3D xfs_trans.
>=20
> typedef struct xfs_trans {
> unsigned int t_magic; /* magic number */
> ...
> unsigned int t_flags; /* misc flags */
> ...
> };
>=20
> This declaration looks wide enough to me.  The only place I see
> xlog_ticket.t_flags used is to set, clear, and test XLOG_TIC_PERM_RESERV.
>=20

Oh, yes, I misread it. Sorry, pls ignore.

thanks,
wengang

> --D
>=20
>> int t_unit_res; /* unit reservation */
>> char t_ocnt; /* original unit count */
>> char t_cnt; /* current unit count */
>> - uint8_t t_flags; /* properties of reservation */
>> + uint16_t t_flags; /* properties of reservation */
>> int t_iclog_hdrs; /* iclog hdrs in t_curr_res */
>> } xlog_ticket_t;
>>=20
>> --=20
>> 2.21.0 (Apple Git-122.2)
>>=20

