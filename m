Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3A8C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 23:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiESXLV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 19:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiESXLU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 19:11:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F52858E45
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 16:11:18 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JJxEY7029203;
        Thu, 19 May 2022 23:11:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vYlsEGoLYaYYiAuKiO5aIp/DEPHKO8y8QZYCvt/2xYc=;
 b=rPzsMVhj5rbhMtZN/t3T2/Zl4SbsYlFJQShuaTgcntoKm03mOhNkKZ3Z8U68scsgH5/z
 M1Xgs3nrallGdJDVylP+xLh6C7Kt/XbrzE93P9K0031Zj77UUzJU3DTSs4n/c9OSP0nc
 UwbmsQhdiKrsqG81ZrrzQLkbF9WDyvBv5KlNqvO43ir+H6JVohD6Tlf2cvHw+b8ABJGt
 mg7nmtf6Ad1pNQ2haEpFPjpSSVtu/18dBfYO4/tBncIv4MCkC1RlRJpjptx/cwZdtNOY
 wVbGiTyOxcpyaIh+kIR8RNUl92xAPQs7blPjaMy8UnjdOX2nl+p93rDMrOJxTNQ+qrv8 Ag== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aanafb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 23:11:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24JMxrCx025666;
        Thu, 19 May 2022 23:11:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v5wdq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 23:11:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/ZmwekSN92hCZAbBSDz168bC6ZH8BBRn5jBzvp5ZzshNjqbCwqrDvEEHRFRHhaq05ExjMbuD6nLkfIkstUvDW5BdO1nxQ/uRlj7LLMRMijfQJ9eacFPm7uBv8t6VSN1nnMS5u09OkP7WzNKfZ/ybg7m1Q7CP6ZF+LXilZwURznL/wD9pqfZVobSQsEbNwlq4l1dXbKQ+gaBkkzV8wSJcuJh3Jiw18rxTW8qPPX5fHIfE4vxsyQRjnEeHb1fkV9H8PpeAif/4g1oXnBTJlAhsYYffU8bkZSmBGKPk1t+IV29oLtl41K2aZdlZo3DVIHClX8AaAz1LnvdZT4jENTQsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYlsEGoLYaYYiAuKiO5aIp/DEPHKO8y8QZYCvt/2xYc=;
 b=J0sZM3iUcTohjtEcPatuYmtekkN3WBhI+1a/ngDQnx8GDsis8tytzHjdHn9sjOhIlV6KCz6uKIr5ZU2s4T3FLbNmORZv2gSkVM0h5ZsnZo480J72KTKKeKYZAZX4M9FyItGETgIFrMKGoTLlNV7N4zyZizUv5KbTihyoaR93BkkiM+HLJjhFRAEMlEXineNrKhz7DsHSo90Zg5lQlFXY4NJSKIgM3ARV37d/twmS58ZisQMNqLhheaqrIqBZwuV0SoVn954lIg79VmVayGNsMt38DIPKrLYyvVVjARavxuu61GVEECyKVmqi9i4b6Ffv4FDPW8Xt6CWOJ4Vq+IAr9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYlsEGoLYaYYiAuKiO5aIp/DEPHKO8y8QZYCvt/2xYc=;
 b=dvW56R+07Sb5jMXuoXKRcafn11JKKoFstpui0DV8PeFeDCt+zaR659hpvvY93BY6h49EcU7VHQvHBHYb6hUyj0DBi11JRzuhk8jsbHx2I1SB/FVGDxHWTTVFAZUJoTbVA3djSP/xibllzhU+Qp3CRGB+Y79Pkdw7uHKjDvlUc5M=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR1001MB2088.namprd10.prod.outlook.com (2603:10b6:910:40::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 23:11:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 23:11:12 +0000
Message-ID: <9eaa2a04d6138bd992ac2a79768a46b8474e4f2e.camel@oracle.com>
Subject: Re: [PATCH 08/18] xfsprogs: Implement attr logging and replay
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 19 May 2022 16:11:10 -0700
In-Reply-To: <YoUmQuOAd+9mBzZH@magnolia>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
         <20220518001227.1779324-9-allison.henderson@oracle.com>
         <YoQ+RkkbPDDj0Get@magnolia>
         <8074f64681d94f506c5967869225714eeb5d9a0f.camel@oracle.com>
         <YoUmQuOAd+9mBzZH@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0099.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::40) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea11da47-cee3-43d1-65ad-08da39ecdd6b
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2088:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB2088704C46EE91A15F2EC1BE95D09@CY4PR1001MB2088.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yb1EimMsqeechgA9O/NvFQI7noDmiCXtSUwMwkVQIdFi9fIHms70Hbkxomq/lNuSHlDaf3k3dMqmtjOOXUVdAz7bz6gvTxsa0V1kMBdT9TxRLr7mtFgsuSUFzv8LMNOmYIIzzMXtm/kpJe82UxCbOb6k/2JWYOd0xzpP+6AzwOpTvR1Ttekjs6DEqZ3Zo83l1nNA4pcVnEc4xzRsiVqnPJHnIGcgPCT7NM3fIOWX+SU5gbhsEJwGnkn2yV9pTUOwQwzvVYFrdiazRret/bHNJkFDN7B+StpgvuTmMDBWe6vAnhtpdBk5XMnU659er63nU001p5tzleHfeX6zWMWdAWU2DWyt2HXfiQXEN8MECttAdgoKzkJeLj6dDR+75p8/kfq/ZYO+oUnILNtHvmuhfcOyRzA/op0dLD84zi2v5979eFmI6d/v/RotNctuHO5zRB9A7RFo6PGkil96ef3VXRFO9t5W/W1ItIHVsmc8u/Kwt013ye+Ol1qEDWXRqKV0srVhRaZgbwd2mkL+vyT+sPtXxaanFAy3AT98pHzdsTqEGufZurE+wrvFkT12SLYlNo/QDuxDO9rH9KrniWVb0s96VYZRRe2MNtcexBlqfXKUqV/DgpzmdfDMMgciiL7CGp25KpQ0sytjNFYffhqAyXNnmUZocDSSl2btQ56deXvNosr1RwLF4qzD5LGyVfQPF520r/+c0rZ6s+OPF9iB3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(2906002)(83380400001)(186003)(6512007)(26005)(6506007)(38100700002)(38350700002)(2616005)(66476007)(66556008)(66946007)(36756003)(86362001)(8676002)(6916009)(4326008)(316002)(8936002)(508600001)(6486002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGhVSzgvOUZiUnFsYkpXSzZBQmJYTFErTm1aZ3JrUFZvcTNrUENrcVllK0Iv?=
 =?utf-8?B?NTNkSFhQOTJDSXBoY0o1bWtZQnd6S1A5ZjFzeWdmRTVpMVNqeVMrT0tOQmZ2?=
 =?utf-8?B?T1BlRGlUbUNkNUh5cjVwS1REZDBneEgwWDloL2ZrSUtzOHVCVFlkK0JSVkhY?=
 =?utf-8?B?Zy8xUVU1TjBRcDVjdlJybThiU2RjR1RhL1ZodDh0ZlJ4SlJSQmNHekFORzh2?=
 =?utf-8?B?RkdsY2ZDSm11NnhpYnltVmZ4WmJPNUJRZGxZMlA1T25DNWVvUG05ZkdyNHZ6?=
 =?utf-8?B?NlBIL3UwbWpPUGU5NnJoSVlaM3dGTXdGVVNqdzN4bkFMUTJuUU9CWTZhdmc1?=
 =?utf-8?B?S3owQ0t1NDVINkZFeWN1dEhQRUZtOU9BQ2EyOEtlVExGSFdSNGJZWG1sNUND?=
 =?utf-8?B?NExsQy9EbnhGWHc5L2pCTHl2TlhmTXNYbTVFWFJhYldLK3lnK3A1Tm5rTkdo?=
 =?utf-8?B?aGZIN01GeDdOOWwwejB1aHNpaThjTE80aTdXcSs3dlkrYmd3b3F5SWw2eWw3?=
 =?utf-8?B?bjBSU2FOdjJyMWNzNXRCVjJBNERmZURvWnFjOGMwd3ZPWEhOR3FpbU1DSE1v?=
 =?utf-8?B?OE9oV0FJdXJhRjJwUlFlR214U3gzYUxIWlVPTnQ1S2Zna3pvV1JOamlFZVBX?=
 =?utf-8?B?VTlteE42Y0FxbkFadjJ3a2JTOU5KaDBhREV4SURwMnpGbW9mS1Yrd2kzempr?=
 =?utf-8?B?MVB0cmxRL1hCaVdDV3NuK0VrY1RLdXl5UnZlZXU3TlQycDdUazlBUWpDeTNI?=
 =?utf-8?B?VDZzR0ZEV3JYZi9IWC8vWTBWZEJQRjFKaUR3YlNuMHhFc0RVZm1zYWlyUVVR?=
 =?utf-8?B?bm9IQ0piakdBREpmaFFsVTBQVC9WeFpGUzA0VU9pMktBaDZFc1lYaVFJVEJ4?=
 =?utf-8?B?c3BoSFpxdFBnUXJTY3hSckNWZ0FtY0x5M2Y1L1BJR1FyM2ZDaEFvVmFOcnJT?=
 =?utf-8?B?ZkNLWWZubzBlckRJMGZaM2VlSWVaSmRHUDRiZG1VVVk0VEZQRVhXSllCQ1pG?=
 =?utf-8?B?bWRTOUMyWnEzT0N6dE54VUhOZkEyUXZhVzlsNDBMZGlLa1FZRjZwbkRlUDYz?=
 =?utf-8?B?TzVjdXJydVVTYXVkWmdxRXpMWTNkMDFiL2Q4dXNhcnhtNzRBQldWaG9yRXNV?=
 =?utf-8?B?WmJIa2JWd3BSMmlMUS8zZkhzb05JWHpOQW9RdFAyVjVzcVRIYi90bnNGcTVo?=
 =?utf-8?B?b2Fuc2RKakxqOTVGZllXRGl1VnpzWG1BYUVLUTZ0MUxncEcrZVZIU2VmMHk1?=
 =?utf-8?B?THNCS1NDTERrOEFoUEsrYitoWDJ6NzlPYUlZN1dTUENYWTdkVFJuRU1ZQzZy?=
 =?utf-8?B?a3NlRWFnandBNjRnNDhMMU95YWdkS3d1WEh2aXNCc3lKZnAxVm9tLzhnZzR6?=
 =?utf-8?B?NjM4TnZGSjNXTlQ4dWZidzdaQ3lmY1I0RzJ5Z1p2K1lZajhKRXY4TWVJblZi?=
 =?utf-8?B?eTJHdGZ4VFJXemJjU21mV08yWktUdXpTNXNnY2dDcVMvOHdEZjRLZEpNWHRK?=
 =?utf-8?B?QjN1UWFjZ21ZYlgzaVA0UU5mN3daVUJnUjJrdmd2UXErU3hWRnc0ZW5ySDIw?=
 =?utf-8?B?cU4xNDVmZmZuSW9RdzFkSS93aElqYWt4L3VlM3IzcFhpZlY4QndlTFplUjhh?=
 =?utf-8?B?ZXhMaXZ1NUI5aHJ2Si9EbE9FVE5IRk9CQ3F6cHhrcXo0ZWgrS1d1QWREQy8x?=
 =?utf-8?B?Y3lEV3FUem5IVHBXOUNSNEs0NlFPZTNCeVl3UFltczI2Y3N1aUd1c1FJMkJu?=
 =?utf-8?B?TU1MdGNzZzlITzJDc1kxbW05d2VQUHN1bWYwVmRDZXdoenJIS1VhOS9IaGFk?=
 =?utf-8?B?Rnk5RmhXN3d5OVM4L1dhck5IWHFxWEFieVFYUUhDb1JUOWpwaEpiRFRCamNW?=
 =?utf-8?B?MmNDNDFydnpUdVJRVWlpRlV1KzZVSjVHQzR6TFY4RWNWR1IweURJZFZWOGxa?=
 =?utf-8?B?a3VoOXJHM3g0SURvSmxpdE9rYnFIZXFhT0pEQ05GZGYrd0w4S3ZXeEs0eWZS?=
 =?utf-8?B?blkycExJVkovVSswWmlTbHNwQzBwclpTTTJMSE4reGlvN0crMnp4ZnBXbXBR?=
 =?utf-8?B?OGc2VUN6TmhGbkRHUFBSZE1NU3pHOUpvbzFiODhaWTVsaWF5RHNhb2JRNHZu?=
 =?utf-8?B?S0U1eFhIVmZZdEpmTDBKdVlQbTFib1J2a1pCNWcyZHZUNVZXRk9rb0RYT0ZB?=
 =?utf-8?B?RXRkMEFiZEMwYXlUSGh0aTdmYkxaaWpoczJpZ0xWekYycm00dlJWY0ttaWpO?=
 =?utf-8?B?bm84cWxjTlR6SHJXOEVoQXB0YStqR3ZJajBZQlAwNkJ4bDZsb0h3cFM5MFox?=
 =?utf-8?B?MUN6Tm4ya0dMWlFmcS92Y29EU242YlJIN2ozSkVWN3o3RGFXZ1NGMzZGeHlT?=
 =?utf-8?Q?LQlEDYaKmdkkS9fY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea11da47-cee3-43d1-65ad-08da39ecdd6b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 23:11:12.0745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lj413mEzHo/wbn7Ad3JFAqah5Dlf9IClGP1vv/2t7RiXlXcm8n7EsRHmBBGlGxDzLK6bdK+lrtPSzPG+DwNtZcLDuvQBhQjvKSxhWj6+Q80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2088
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_06:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190124
X-Proofpoint-ORIG-GUID: zdtOTIdjEgwXUmnX7bEJmPqVm7V5wp7v
X-Proofpoint-GUID: zdtOTIdjEgwXUmnX7bEJmPqVm7V5wp7v
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-18 at 10:00 -0700, Darrick J. Wong wrote:
> On Wed, May 18, 2022 at 09:38:09AM -0700, Alli wrote:
> > On Tue, 2022-05-17 at 17:31 -0700, Darrick J. Wong wrote:
> > > On Tue, May 17, 2022 at 05:12:17PM -0700, Allison Henderson
> > > wrote:
> > > > Source kernel commit: 1d08e11d04d293cb7006d1c8641be1fdd8a8e397
> > > > 
> > > > This patch adds the needed routines to create, log and recover
> > > > logged
> > > > extended attribute intents.
> > > > 
> > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > ---
> > > >  libxfs/defer_item.c | 119
> > > > ++++++++++++++++++++++++++++++++++++++++++++
> > > >  libxfs/xfs_defer.c  |   1 +
> > > >  libxfs/xfs_defer.h  |   1 +
> > > >  libxfs/xfs_format.h |   9 +++-
> > > >  4 files changed, 129 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
> > > > index 1337fa5fa457..d2d12b50cce4 100644
> > > > --- a/libxfs/defer_item.c
> > > > +++ b/libxfs/defer_item.c
> > > > @@ -120,6 +120,125 @@ const struct xfs_defer_op_type
> > > > xfs_extent_free_defer_type = {
> > > >  	.cancel_item	= xfs_extent_free_cancel_item,
> > > >  };
> > > >  
> > > > +/*
> > > > + * Performs one step of an attribute update intent and marks
> > > > the
> > > > attrd item
> > > > + * dirty..  An attr operation may be a set or a remove.  Note
> > > > that
> > > > the
> > > > + * transaction is marked dirty regardless of whether the
> > > > operation
> > > > succeeds or
> > > > + * fails to support the ATTRI/ATTRD lifecycle rules.
> > > > + */
> > > > +STATIC int
> > > > +xfs_trans_attr_finish_update(
> > > 
> > > This ought to have a name indicating that it's an xattr
> > > operation,
> > > since
> > > defer_item.c contains stubs for what in the kernel are real
> > > logged
> > > operations.
> > Sure, maybe just xfs_trans_xattr_finish_update?   Or
> > xfs_xattr_finish_update?
> 
> That could work.  Or...
> 
> > > --D
> > > 
> > > > +	struct xfs_delattr_context	*dac,
> > > > +	struct xfs_buf			**leaf_bp,
> > > > +	uint32_t			op_flags)
> > > > +{
> > > > +	struct xfs_da_args		*args = dac->da_args;
> > > > +	unsigned int			op = op_flags &
> > > > +					     XFS_ATTR_OP_FLAGS_
> > > > TYPE_MAS
> > > > K;
> > > > +	int				error;
> > > > +
> > > > +	switch (op) {
> > > > +	case XFS_ATTR_OP_FLAGS_SET:
> > > > +		error = xfs_attr_set_iter(dac, leaf_bp);
> > > > +		break;
> > > > +	case XFS_ATTR_OP_FLAGS_REMOVE:
> > > > +		ASSERT(XFS_IFORK_Q(args->dp));
> > > > +		error = xfs_attr_remove_iter(dac);
> > > > +		break;
> > > > +	default:
> > > > +		error = -EFSCORRUPTED;
> > > > +		break;
> > > > +	}
> 
> ...since xfsprogs doesn't have the overhead of actually doing log
> item
> operations, you could just put this chunk into the _finish_item
> function
> directly.
> 
> > > > +
> > > > +	/*
> > > > +	 * Mark the transaction dirty, even on error. This
> > > > ensures the
> > > > +	 * transaction is aborted, which:
> > > > +	 *
> > > > +	 * 1.) releases the ATTRI and frees the ATTRD
> > > > +	 * 2.) shuts down the filesystem
> > > > +	 */
> > > > +	args->trans->t_flags |= XFS_TRANS_DIRTY |
> > > > XFS_TRANS_HAS_INTENT_DONE;
> 
> Also, I don't think it's necessary to mark the transaction dirty,
> since
> the buffers logged by xfs_attr_*_iter will do that for you.
> 
> I'm not sure about whether or not userspace needs to set
> _INTENT_DONE; I
> haven't seen the userspace port of those patches.

Ok, well it seems to run ok with out it? I dont see the other items
setting the flags, so I suppose we are fine with out it.  Also, I am
fine with hoisting finish_update here as long as everyone else is. 

It's not clear to me if Eric uses these, or if he has his own method
for doing these ports. But I mostly just wanted to build up enough of
the infrastructure to get the new log printing working and reviewed
since we'll need them for test cases.  Thanks!

Allison  
> 
> --D
> 
> > > > +
> > > > +	return error;
> > > > +}
> > > > +
> > > > +/* Get an ATTRI. */
> > > > +static struct xfs_log_item *
> > > > +xfs_attr_create_intent(
> > > > +	struct xfs_trans		*tp,
> > > > +	struct list_head		*items,
> > > > +	unsigned int			count,
> > > > +	bool				sort)
> > > > +{
> > > > +	return NULL;
> > > > +}
> > > > +
> > > > +/* Abort all pending ATTRs. */
> > > > +STATIC void
> > > > +xfs_attr_abort_intent(
> > > > +	struct xfs_log_item		*intent)
> > > > +{
> > > > +}
> > > > +
> > > > +/* Get an ATTRD so we can process all the attrs. */
> > > > +static struct xfs_log_item *
> > > > +xfs_attr_create_done(
> > > > +	struct xfs_trans		*tp,
> > > > +	struct xfs_log_item		*intent,
> > > > +	unsigned int			count)
> > > > +{
> > > > +	return NULL;
> > > > +}
> > > > +
> > > > +/* Process an attr. */
> > > > +STATIC int
> > > > +xfs_attr_finish_item(
> > > > +	struct xfs_trans		*tp,
> > > > +	struct xfs_log_item		*done,
> > > > +	struct list_head		*item,
> > > > +	struct xfs_btree_cur		**state)
> > > > +{
> > > > +	struct xfs_attr_item		*attr;
> > > > +	int				error;
> > > > +	struct xfs_delattr_context	*dac;
> > > > +
> > > > +	attr = container_of(item, struct xfs_attr_item,
> > > > xattri_list);
> > > > +	dac = &attr->xattri_dac;
> > > > +
> > > > +	/*
> > > > +	 * Always reset trans after EAGAIN cycle
> > > > +	 * since the transaction is new
> > > > +	 */
> > > > +	dac->da_args->trans = tp;
> > > > +
> > > > +	error = xfs_trans_attr_finish_update(dac, &dac-
> > > > >leaf_bp,
> > > > +					     attr-
> > > > >xattri_op_flags);
> > > > +	if (error != -EAGAIN)
> > > > +		kmem_free(attr);
> > > > +
> > > > +	return error;
> > > > +}
> > > > +
> > > > +/* Cancel an attr */
> > > > +STATIC void
> > > > +xfs_attr_cancel_item(
> > > > +	struct list_head		*item)
> > > > +{
> > > > +	struct xfs_attr_item		*attr;
> > > > +
> > > > +	attr = container_of(item, struct xfs_attr_item,
> > > > xattri_list);
> > > > +	kmem_free(attr);
> > > > +}
> > > > +
> > > > +const struct xfs_defer_op_type xfs_attr_defer_type = {
> > > > +	.max_items	= 1,
> > > > +	.create_intent	= xfs_attr_create_intent,
> > > > +	.abort_intent	= xfs_attr_abort_intent,
> > > > +	.create_done	= xfs_attr_create_done,
> > > > +	.finish_item	= xfs_attr_finish_item,
> > > > +	.cancel_item	= xfs_attr_cancel_item,
> > > > +};
> > > > +
> > > >  /*
> > > >   * AGFL blocks are accounted differently in the reserve pools
> > > > and
> > > > are not
> > > >   * inserted into the busy extent list.
> > > > diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
> > > > index 3a2576c14ee9..259ae39f90b5 100644
> > > > --- a/libxfs/xfs_defer.c
> > > > +++ b/libxfs/xfs_defer.c
> > > > @@ -180,6 +180,7 @@ static const struct xfs_defer_op_type
> > > > *defer_op_types[] = {
> > > >  	[XFS_DEFER_OPS_TYPE_RMAP]	=
> > > > &xfs_rmap_update_defer_type,
> > > >  	[XFS_DEFER_OPS_TYPE_FREE]	=
> > > > &xfs_extent_free_defer_type,
> > > >  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	=
> > > > &xfs_agfl_free_defer_type,
> > > > +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
> > > >  };
> > > >  
> > > >  static bool
> > > > diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
> > > > index c3a540345fae..f18494c0d791 100644
> > > > --- a/libxfs/xfs_defer.h
> > > > +++ b/libxfs/xfs_defer.h
> > > > @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
> > > >  	XFS_DEFER_OPS_TYPE_RMAP,
> > > >  	XFS_DEFER_OPS_TYPE_FREE,
> > > >  	XFS_DEFER_OPS_TYPE_AGFL_FREE,
> > > > +	XFS_DEFER_OPS_TYPE_ATTR,
> > > >  	XFS_DEFER_OPS_TYPE_MAX,
> > > >  };
> > > >  
> > > > diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> > > > index d665c04e69dd..302b50bc5830 100644
> > > > --- a/libxfs/xfs_format.h
> > > > +++ b/libxfs/xfs_format.h
> > > > @@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
> > > >  	return (sbp->sb_features_incompat & feature) != 0;
> > > >  }
> > > >  
> > > > -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
> > > > +#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/*
> > > > Delayed
> > > > Attributes */
> > > > +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
> > > > +	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
> > > >  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_IN
> > > > COMPAT_L
> > > > OG_ALL
> > > >  static inline bool
> > > >  xfs_sb_has_incompat_log_feature(
> > > > @@ -413,6 +415,11 @@ xfs_sb_add_incompat_log_features(
> > > >  	sbp->sb_features_log_incompat |= features;
> > > >  }
> > > >  
> > > > +static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb
> > > > *sbp)
> > > > +{
> > > > +	return xfs_sb_is_v5(sbp) && (sbp-
> > > > >sb_features_log_incompat &
> > > > +		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
> > > > +}
> > > >  
> > > >  static inline bool
> > > >  xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
> > > > -- 
> > > > 2.25.1
> > > > 

