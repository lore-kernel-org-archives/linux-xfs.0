Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F4ECC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 13:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245273AbiDKNqp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 09:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346655AbiDKNql (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 09:46:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEF311147
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 06:44:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BCL9bC022836;
        Mon, 11 Apr 2022 13:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qFHeGWjtla+ZHK+PXJiYB5iZoSGKL7YYMdotESBH/l0=;
 b=qQKKBZ792Q9QsrFVwADvAvmP6puHDFX/h2iEXcDQmLDL9nkkYoIoQg9YImzVVx0O2a4o
 vjETG4xNFqDEwVc8FeMmH+oxSyvOqv43xSMpQkksgvXufly7ymryZq4XyK3WfMuwkF8w
 Yu4jExOHNS7MoUl8zzq2zV8WrUSkNZB/w0dcRmPbeTXc/8NFbHyyg4tEQd61mavezMOY
 Wq2xuhOYdMwbR1e44yAxFMbXrh2mqYRZOe1PGLL5Iv0YX9fU4uPlW8gaNKw7meoGKhUM
 zMnu93ty9pXwk/q8HCaYbMTk7FSr6mzaVwcCOX74oPo9OyktbFdQLejqmROFjESkb6i9 yw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd3mfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 13:44:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BDfJeS002584;
        Mon, 11 Apr 2022 13:44:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k1qhqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 13:44:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgjjEFcNoW3zcwb4h9gNojGM++xfg+sEhMmfAyRW4Hvau5elzQC5wXUvSGemJ7/ZRqJEoo098QJrQ99TDEOpm6YS89DNtKq+81Pbm+nWtE/6+iNj1jSgQB6HIzNBwcb5BLkP4eg/cNntiEcMhCiSTofuxEgJ2ocaZj7fZh7jSWAoI9vb65qDPdTpjhTnTLURcQPzveNT39GVGatuKWuvPnCNgkNMlMYGGXWp3Qk8oxr6hBh+Hl+FK9Iel8DvJJVeiMgEDFZbBeivIJDJVm1bgAN9kcDB61PcvECUbiBhLyxv0aE9QMfulvs15YpjiK+oCqMn5lxkO8do2ld/JWRNcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFHeGWjtla+ZHK+PXJiYB5iZoSGKL7YYMdotESBH/l0=;
 b=UWPq0A2xoLS66lR3Dk3gmNmfXh8gy08dnvcVa5yG0a+IkU4AIdCULP+x3BFF4ItuHpMmWd6aYFo/QYwgUoy9iEfbQCByhVub+7dI95jHA8W0Utylfn1PUsfLi4YlBvGgZpT1RuR9CclJ2FgqvzF6nT4j4Qpmuba5WmpC/kKrHocY7p6W21VrRZ/3MK5fuzpE+gm8FtKzOGepZlx+I0hyGxkqpnjayI+3Cx70JFlWl/QS/B5mP5PJqRc+yXxbaK0NSi5YrPfD0MUEgnwgJim+jvtBCTEZC+jM+wJpNQkQtoGXIXuV+hatan/3HFuObiqC/GSABjWoBYQ5iKy4Wg1oZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFHeGWjtla+ZHK+PXJiYB5iZoSGKL7YYMdotESBH/l0=;
 b=RTTz7Y13rtIzOP0hGq+4n64wAstaE/x1k8StJZQB18MiiRRwZ3wBX3WCbM2mXlOWI2jCF+DczIW0XT7gUuwBftxyy9x6/ZJe8kEeAwL+SffCgzAO0u43iu6g/24kTrEEJOXe3gCj5hJ6ty7kmEB9rXnBCP/Xk24GOHGZ0jv55q8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BLAPR10MB4979.namprd10.prod.outlook.com (2603:10b6:208:30d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 13:44:21 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 13:44:21 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-6-david@fromorbit.com>
 <87h76zvl10.fsf@debian-BULLSEYE-live-builder-AMD64>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/17] xfs: convert bmapi flags to unsigned.
In-reply-to: <87h76zvl10.fsf@debian-BULLSEYE-live-builder-AMD64>
Message-ID: <87bkx7vioj.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 11 Apr 2022 19:14:12 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0137.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::29) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 170a1fe6-734e-42da-a793-08da1bc16216
X-MS-TrafficTypeDiagnostic: BLAPR10MB4979:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB49798F91A43B37678BCDB3F5F6EA9@BLAPR10MB4979.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +hceDhEvYdXbo7hO1Sk0W/lTZRVyLe41bp8q5wkhFRZeKZuKZIR51ltOnwaO1c+6huUnlZUI9e1+flqUQNK7lignBFJAZfXF95FKYYlNXQSAdv76x9e6f9/vi1FccM3iK9XHxSo7hUAYq0IHgTi+/hjH/AhKy82HJLdytMt6WinEuD+/DygOm9GYKEHRay88ei0e4wRIT+Hn1PSfThBOpsXsOBjvPogrOM93+nAnpct+yovhDj41IaSspnMY2OK/6dR7ImYPE20BAh/qjgnbbJuIwa5544bKYiA1CHryAco4jx9QdVBfBdkCI7Z8YW2ajv3Tlr5+Y9EUpn4ZJGpu6K3YLxP8JZyfIn0Ku62GZFkKBDjlXjE0CE81q7kWi2WNulG4Vv0Ifz7YdBNrbCkUjej/iuyhvwhd+Q1JQ72rTkSeWLcHTc7j7otqXbfTftFWc2wYuNi17MH5inBAq7nIeJzHTEKaKQBuUey2NPmxSjolv+z/Sv7CdiTiRbCsD1eIb9sbQ1uauU4XGp0rS/5Lvy/b5tPoP5vOGMZGGSyNCk3pPKVIF8Iv/397DW3N6CKBaiFzFkKiM77tti+yBGN/7MW4BGMbqHfqDvNHJRj+byXOvWMY6Mc1CUQRlfWF0Ir9hfe8RjM3dd711XMzDmOpMv+VRBI3XO0mwomnf7B7Or/dw+E/ZEqoRXKHZh/fSsdHCXqHB9Fkuf1XrtKM3P1IvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(6506007)(316002)(53546011)(52116002)(508600001)(6666004)(26005)(5660300002)(86362001)(4744005)(6512007)(83380400001)(186003)(8676002)(4326008)(9686003)(38100700002)(38350700002)(66946007)(6486002)(33716001)(66476007)(6916009)(66556008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?einQnsfp7WXr6IlNgEJa+38ndBKxfqo2geBIrkLFPW3MLSJ3+GMrLbKncrEh?=
 =?us-ascii?Q?W6Vr9eN6xVjz1lLfKQsEpFpxE2ydSXzyjVA5BT8F+SkNB9/FCdlFvxQvn/tv?=
 =?us-ascii?Q?mRCJ0MXxhHKfPFwPnch6PHf/B3XxemYHrxAcchgtA6sWRyj5Q2mo7LiXPCKW?=
 =?us-ascii?Q?ERzfIfgrLi9PaQvC8jEocKW4BEOxPBmJVxgQXgduB8j1w2xpcuP8TTeWmAKg?=
 =?us-ascii?Q?7B/ynoXFB7eI86eqW2TTABJVNLTdUteWHudeCHXOynRMpXTk3rTjQIadzbmp?=
 =?us-ascii?Q?FkpTjibRvoSaFn9gu3O6sVb0NVOH4/0kSSwgPoMS2pyhJrXoA1/+ICmLiL7Y?=
 =?us-ascii?Q?Jxuui2c0mKAXwPw4D3I2iPucpeNh4pntpdVpbd0ETTzL5bwpI1tbE+BcDCt2?=
 =?us-ascii?Q?/GJwQuFrJVbzs21m/JM9NHBiCisgMcYc20vctIXbMKhc+lKag7QJTMBSOjF0?=
 =?us-ascii?Q?pFAxIiGSq6/voZncb791OfaYp59ryADt2UI8uIY3VnuE+Wui1x+OF0OCFicA?=
 =?us-ascii?Q?sQieg5hc6dPa60XVkb9ivxujnjDU/tFx+M3f7hjqXVWMdAiplgsVVsa2MnuH?=
 =?us-ascii?Q?7sawvVBmOSdWMW2zp39XgRd1hWnmaEZZO0lUgOwmM4M1ydICK0cHgDsK156t?=
 =?us-ascii?Q?F6rO1rUYd8O4KUPcemV/PudMQ9QUzd/28tTMRiokdyMDhaHyuGUREjnymnHs?=
 =?us-ascii?Q?qn2aapUc2Lc/D8t1zz4/mgdSJ9yd7QyTg4KZFDmms59lPHjC1YKMsSUsyXFk?=
 =?us-ascii?Q?tYgt5fZLQ36Ar9CfZK9wQ6+bgP4mqjjK/O+vMDcAxxasNeD77Nj9lVbSQ6gy?=
 =?us-ascii?Q?wV6aB9cw/oUs7pgphm4AL/eCVf3FSwj7VTEhCqxcv0aojU0niOooqfYwfmPD?=
 =?us-ascii?Q?LNpodLU77XG7Ru0VOxeCr1QF0OBBEjo6OXpyRbLz8bAnp2fetcIZ5AndjVw3?=
 =?us-ascii?Q?M0lMh3ua3qNXx8vSDjssNGsICy4wP7YsoJvNbHUGagSyqXY5tBSGkrFw7MqE?=
 =?us-ascii?Q?inP/GlW2AjtQIJneRSIxABmnDkUDFdLU/oZO2fENQkd4FIOQMSidfJAl6qXQ?=
 =?us-ascii?Q?3tqw7lvwFLtxCHi0CxmfgTHA/cm0aCDHFiSv/lqlhpkA13uJMgLAx68pZe0I?=
 =?us-ascii?Q?r5wLD6OCCFVbt42hZ5rrii1M703Ldeib5CSdBUtRQIWWT9OBoqVtz+sdJX9P?=
 =?us-ascii?Q?23gypIOOEcqc8oeraCHhISA32KWqiOzPetv9NDNOZj99HvTo38iE5Yz/mF/P?=
 =?us-ascii?Q?m0Xc4auW6Lf16ae9R+VVED3MfXIKTQvsx10GP6THLuZtlltKc32XXJ3h80xX?=
 =?us-ascii?Q?NaIo/8Ug+TRpM94I3fW0uWnXhzh4+QmujRGNGw1AiKEi4ltI+dwE2RVre291?=
 =?us-ascii?Q?XLHzgXDogZfRyex7jr/NOlmQNlOFMc5VPSHgkuzzu+bY/xe7a80wUnSQ7T5i?=
 =?us-ascii?Q?QEGL7dnDiAn0fdAzsmoKRc2Dy5dUX2vXHSjPdCxCg9mbsELzzY9/VHGtYLmE?=
 =?us-ascii?Q?U8tb920nn8rUqQNjH8BfgBoDlfp5iipgGvVeVZgEVFZAOWcg/DeEXJd0gBdu?=
 =?us-ascii?Q?1vxeyy6tAaKDS/fb+dV6mJ5+NrYaReVHzilZyjORUnbCV9DKcpLDtUswgIVg?=
 =?us-ascii?Q?jynAdqoXwDE193ki5DPc36CW3W4FySjL5+WtblJGoAib7lukYN5CZvrqbjJF?=
 =?us-ascii?Q?XajHgbHvE2wbwAK3rN3pkCA0iuItiohTc6EnBlMnpHX+BEEkvaTgb3N5PYLk?=
 =?us-ascii?Q?95R+oFU6P0lWKZEIE8p7HLlPHqFtbnA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 170a1fe6-734e-42da-a793-08da1bc16216
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 13:44:21.5729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HXfKBRo7HnNeeQImmSpYwXXViaGysDV2Dyp8CCbswyTpaFyz8p4uBhdaDdUlmGQYcKSDBeD5quMDp4f3rWXX/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4979
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_05:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110075
X-Proofpoint-ORIG-GUID: RtD-UDrbLithGHvjpnZmy8ZMlIXrONUC
X-Proofpoint-GUID: RtD-UDrbLithGHvjpnZmy8ZMlIXrONUC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 18:23, Chandan Babu R wrote:
> On 11 Apr 2022 at 06:01, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
>> fields to be unsigned.
>>
>
> The fourth argument of xfs_itruncate_extents_flags() and the return type of
> xfs_bmapi_aflag() must be unsigned int.
>
> Also, the data type of bmapi_flags variable in xfs_iomap_write_direct() and
> xfs_fs_map_blocks() should be unsigned int.

Please ignore the above two statements. The corresponding code has values
being assigned to a signed int variable rather than an unsigned int variable.

>
> The remaining changes look good to me.
>
> Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>

-- 
chandan
