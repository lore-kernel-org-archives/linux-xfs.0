Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00355C38159
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Jan 2023 03:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjATDfJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 22:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjATDfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 22:35:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFB09431D
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 19:35:06 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JNEMO8028488;
        Fri, 20 Jan 2023 03:34:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CYzEVVCuXMqlaezTMb8EkOn/IpesJD23FTFy4iXJIow=;
 b=ye3YbKLDTUIsPlOLJACD7Y/MuC67dT6RKePs5jAxMraK8D9dLPBU8wyQe00J156dhA2R
 YY6q9I+t7Lud0UoiXY1ktPdslwgs8+i6cvWy9YLTv6Q5tfCXHd+dsnjvlAq7j0IV1WgI
 rJflnOm2Cs2qllE7KrxfU7H6YBYZsaf9kCq4dVudjGJyo1d7ow6NWViL3Xqwj6t7nxxV
 26c6y3Serc6nqvWgRiRrlpBRFdr+Txtp9Ns6C0fllDM4AhX26XMnx5eQfhrL5nSIguC8
 kUWvzx/XsfmhzfbwhOr8YIF4eoX68x6WFd5/jN43ZNa/BaTvVKwKyrS7lTOHvSm5BCyj nQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3kaakrbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 03:34:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30K3TW45027871;
        Fri, 20 Jan 2023 03:34:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6quch139-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 03:34:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B88RykKA546u4Plbyn/AJVgoSK7YnHgtNSmpbyGOHNx9A+D4Iy4nEV4+vbGQgSQG0+BXjU9FTD0L4irX33Zt5tYYTdbVnOXuaF/OkMWA4+a3dlxODvdSiRjXwnVeai9uAq30Qg5yU4GrrZsy4u3unqscIc5HmgfWaZXHzukT9ef3l1rZeBjQBaf74fC/HOQKySKN81SOeroZ74yTO2WAKE2RvvpQ23Ycp0DtZZskC7iK0HeS5+DNap08tRM3rBHJVNQjC0RsEVX7AT/1xvO7H8FNd71l7ullhvhPfWPAeuofKGvut+fKzX4sr8KlE9jTOJ3nRHi2GZlKz1pGXT0wQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYzEVVCuXMqlaezTMb8EkOn/IpesJD23FTFy4iXJIow=;
 b=jCYQFEbEVkbVw5kbZ8axTBTVGbd8sdvgMLLpxKG54DMUugFh6G92UjQPAzWuA2mWH67YdYjkUCJqMToxDdBahQo42RCYYO9KY236+rUh1U/En6LR1ybHy9tTkuGT+zv4bNOuayMGslb4dIjXc8E7b6NRWLVK/fJqEPTzXkj+ANJuBnge/A6P3HU9a5O9RxSmSrjigqTlY+tSx8isE6uE1dnN/P/eIFNsPVZIwLYllNViB0jMog9rySnucCclR+CoJjw4ccCHQNyr7sbX/A6CQnllwUj7hQbkvTMiMEwwj9vHfqjMuQGdfUNcDN/Yx3D3QWUlMZ6wsecz6BcnbXd1SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYzEVVCuXMqlaezTMb8EkOn/IpesJD23FTFy4iXJIow=;
 b=J6kYgao9/Gvl/fA3BRJy6NhiA7Qu8KfGKJQb3MZEsvEpN4Kx6uz07jxwOhzS3GMqLg4qTJhpI8+jTiqqSz5PLlWQi7UpeC0jqjlhe4mLBtB/im/diUasOAe546z3YGTAagMiePYDINzrlGJy1yRdaC/+fMMycNG4SL9XXiehiBY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW5PR10MB5714.namprd10.prod.outlook.com (2603:10b6:303:19b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Fri, 20 Jan
 2023 03:34:52 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5%5]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 03:34:52 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
CC:     "djwong@kernel.org" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1] xfs_admin: get/set label of mounted filesystem
Thread-Topic: [PATCH v1] xfs_admin: get/set label of mounted filesystem
Thread-Index: AQHZKsRRTYfqr/4hiECcRe8Y78HYMq6ji40AgAF4YwCAAWdqAIAAP20A
Date:   Fri, 20 Jan 2023 03:34:52 +0000
Message-ID: <E4C2A3D7-7CA4-44A8-81AB-D8EFE7DC1E61@oracle.com>
References: <20230117223743.71899-1-catherine.hoang@oracle.com>
 <Y8dtbCouIPhNT1Zw@magnolia> <AAC756EC-BC4E-40B6-AD8F-40B2C275DC39@oracle.com>
 <531286bfd56cbd6ea26050b0a6b5e5610b463d32.camel@oracle.com>
In-Reply-To: <531286bfd56cbd6ea26050b0a6b5e5610b463d32.camel@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|MW5PR10MB5714:EE_
x-ms-office365-filtering-correlation-id: 4792d463-6cdf-4e60-5d8e-08dafa974aa6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LHwlPHL/GbRZbA6hUGP6pCvpnaMK5CyDHhJtl1Glh5ntM2Ky+rE86o3cpeNwYB//Zn0UZff0QnJ7gJBWcRbKanI7ozNzM7J6Zp525Z5Pcq9Yh1KAnn4irC4sOagEICJOMX8ZGanhA2EQdKmzUl6ecMM1HOFGIJLMOKqTFHGvdYoTEQZmiLL82jJIQsZkgcr9lsUNvY05NYXz42S3Ii2X5dkXZtDuD1emdiYJp9cDS5mjFxFne3xJon2l0ybOdBrvT/YFnKl9x5nPuLZKUcduuUCUgVlUzfm7nQB5r8DFS1s13wOpgFUaFh0/IplkRiYTH905fO9eYQWAnF+H2PbOl8sbYi1XNwWlihvR5q/KV23qsF/JGR2mJsTBrRH3rL4eWQXhNX2QHsA/UjPIvpYINSgG9ve4P0lSfDskmQsFh1hFwj3DJzKwH+jLBUOjVN8K8opK/T0adqtYQnpgXO9chjWbQvHPrOfDIylm7aO0JJyHdNpnkFMF2sNC0fSqHN5gwXuGpYhNq4YqcxYkxZyrX+I+2bVMKjaYibzbZv9kqOT510OIophjS0Y1f0ftXgmSU2Mxb093tdhNv2vlIsk5BaP3OVhgziC7UR6KE9wm8Yp2KVLWzK0IMserDww9sXdv5zFSRUZNLNA4cvvYOUQwTeW+mtd+3tLTtHBWgfk7wOzXTc4S42WSTQaqIO4k4G98d4yJGRO3B8v1rNp3Tog/OHhfIQRI7PU53ES0b55QiBc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199015)(122000001)(41300700001)(44832011)(66446008)(36756003)(37006003)(66946007)(8676002)(66556008)(64756008)(76116006)(66476007)(316002)(4326008)(2906002)(54906003)(91956017)(6636002)(2616005)(86362001)(83380400001)(5660300002)(6506007)(6862004)(53546011)(8936002)(38070700005)(38100700002)(71200400001)(478600001)(33656002)(6486002)(186003)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEpkd2tIMkVtREpUc1JOTEpWUGg4bmhuU2o2RkYxbXFTVStXcVNUWXIyaERK?=
 =?utf-8?B?bk9QU3V1eFpQTy9uWGtGMEdudDFOQmYvckhHZEJORy9MMUdaMWdzNlhSYXNG?=
 =?utf-8?B?aUQwT3RCTWhCWkQwajNvMHUwSEcvQ3NjbERsZUlzb1JKVlY4Zi9VVmJSbFVY?=
 =?utf-8?B?cnhVekxKR3NDQnpLRE82THhPUVBkSHVwdGpzMUhpdGRSRUppcjQyTFZqVjRU?=
 =?utf-8?B?S2MySnlHdXlCSE5RaVJROGdJdldraTQweDZubXAwVzZ4Zm1SWENPSFBqQUdn?=
 =?utf-8?B?VVFYTHQ3dUJpdTM2K3JPZnpWL2ZtR0tQb1hYQ2JoMHlrcmV4cG5vSjBQTHpu?=
 =?utf-8?B?ZU1QQVV4c0dyK2syUXpPUHVOTDNLaWplR29xc01XS2FLc2h3dVNXVHpDK2pn?=
 =?utf-8?B?YVB5YmdvM2FpQXpDN2x0N1pBTEV6aFdKejJGKzc2WnJtN1RHRmFvV3QxYUty?=
 =?utf-8?B?ZUl4djg4M093NnhUVXB1aDMrRk1PY0RkbXBwOVNEVTdHTHREdE9nSjFDLzRn?=
 =?utf-8?B?N0p4RklTSGpGK1FFNkxVaUd5L1R2MlJuV2xOMC85Rm0rY0phL0RlUGVhQ1BH?=
 =?utf-8?B?MnNMdXNEVFVqRzdFOC9ROUNqTGJseVAxR0VwQlpwcXJCc3VuVUk0VThvL3pP?=
 =?utf-8?B?cE8wV3M2SGdUZGxrSityanB3YjEva281UGpDNTdDWmZmVjJKbGRRYXF1VjJM?=
 =?utf-8?B?czZVTWJFbC83Y2h6ZDE2aGJiSUJ6b3lzUjVmMkxwQTVkQUhSVVp6enp2SVBs?=
 =?utf-8?B?UVdYQVVMdHVFMDZuTGNLcy9QU1hmVUJra0d0dmJlUGpUczhsbGZkSTJWY3RS?=
 =?utf-8?B?cVJFTm50d29heVh6MWVncUh6SEI5MDR0UWtYeVovT1FFUFNMb0t4YUl3RG9q?=
 =?utf-8?B?OU0wRzBKU3pNNk96L1J6WUYwZzdEWm5qTHBua1FPR2xobUoxRENaUjlYMnB2?=
 =?utf-8?B?WUNWT2ZNTnlwZHgxRWdVWTdZSVVMbWFMcUQ0WGE3cnpoMDgxTWoyT0Z2Szk1?=
 =?utf-8?B?SThKTWQzSmRHd0NFUnJhSjR2dUZXeXJjYUFBNVhZcEl1bWN6d3hvdkdicEpm?=
 =?utf-8?B?TVBOaFFraWJMbWlqNHdvRWlVY2xmVzY5dFlPZ2JXWjBaWHFjMEkxVXc2NGI1?=
 =?utf-8?B?Vnp4SG9XcGsrRUtKb3NIcVZteVpTUm1jMlBNRDVjKzVkWmdoRStMSWdjZFQ2?=
 =?utf-8?B?L1JUcEVWZDRhN0lBRzMwU243L0xWUHROakZERjFNbFJ0VU5naHNUaDJ5bmJ6?=
 =?utf-8?B?dHlKRUF5NDlLaFVtNW5MdEZYTzZCMFJ2MkZNS0duM1JBU0g5c3VQczFzYjZ0?=
 =?utf-8?B?d2ExQVlYWlVxQXhCcXVGdXN2SC9sTWNaWTZzM0RTbkFSYXNSNXp2YTJxU2la?=
 =?utf-8?B?S2hvQjArRUZxYmJtN2Myc1lWOXdoQWx0M1lKYldTN2x1YytLd2ExWlhWTTB3?=
 =?utf-8?B?K2JWWm1zSm84ckt5ZDdWcVBIall6MGFyWTlNUGlyWHZSSTRLUWE2NXBiUWQ5?=
 =?utf-8?B?NDVlOGppNVFkblhUaExsK1FMNGRGZ2hnYWlrYVhmaGJRWkt1NDhZNW5OUko4?=
 =?utf-8?B?RzEzRzFvZStmOHZEWHdqbkFOT3lKL2l3Vmc5Qyt2dEN0aFFjUmhLRWU0UEtQ?=
 =?utf-8?B?b2h3Nmg1M1JWRjM3OVd6dkUraDE1TVFibmljZWtqdG1hcGsrMGxpNUFHVVpV?=
 =?utf-8?B?ZFI5V0JPdVcrRGRvVzlJM1hwWGViQ1BhMVNsb3BnOFovTm9kN2VTVzZmUjJJ?=
 =?utf-8?B?TW5RMHgyT2JORjBJNEx5TWZ4dUFmcFVKRW5JaWxNZWFKa1VGZC9jenpTM1RZ?=
 =?utf-8?B?VDVHR3VNZjd1ZUUxWVFQZUxpNGxMOHU2eFBLakIrcmJ2TndoQkoxRTU2S3Zo?=
 =?utf-8?B?cGp6RTZnNk15UWhMZ1ZPY1BkdHkvMmYvN2lkUklLYko5aG1JZkw3TjRpU1Qx?=
 =?utf-8?B?VGdKNU5DWitrR3N4R0Ficmd2anBkakFVTUZRaDY2b0ttTWhSK1F3c3dDeFRu?=
 =?utf-8?B?MjNDM1B0Rjc0ZFhqOWw0MUZIb3lxM294MHRjRGVqYjVleHJTTGRtNUhaWmY1?=
 =?utf-8?B?a01kc2FFYytsSTI0bEQ4dDZWNFdZTnRIcHNMTll6c3R5WWVCWUdRZi9CeEU1?=
 =?utf-8?B?NUZ1RzdNSmMvMmw3RnBOVVVsL2pGU09Fd012STVCVXlxV3I3YzJKT053bU5M?=
 =?utf-8?B?R3d3NWxaMkZhVUcrWXpJY3M1UlVzT1lvNEM5WXZYNjJzS3B1WWNGZmNPRm1y?=
 =?utf-8?B?NXhBSXZmaVh2ZHJRMmU0aTZMbk5RPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE3C62DC383B6448917BF7A6931AB783@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FUgOUiAxvwPJJV32J3trLCV8NKLBd8QiLgGi8w5fXQOmeLINncqF7NJJD7JZ3zUNasFzPwbRt3EnnT/t1eNpudTgupJTRARXiIO+qopSUjpD+WZAR151Q4xQwwk/sFubND4CDdEKGcrZaRcWO49qU5sIHF8tPW8Wbj8K2g9Lm8LOmZ2Y6ZjoauQizp0bGj+KjdSW0Aw8H7IV8AuPDu/Q8UZ1zGifidJLL8M2PCRFZCbl5gQ4AhICsWrO0KT/wjDQR5ClAt6fpymND1ms73fjPrtBp7JRn9UmpP9u1k6gsveAjgkDN7b1/Ti+qoxF64DtLwKLt/f8DsgCwqtht7H1sNi8A4EMWC0hexkqJssU/hfLcDD/9TMXfBBcKqyY2jcdsstb5qPIA671Bp0OiS7uE5EeE9kFTZ3KE6gGDziWc/bGwQf6PJKNkmxKPPw+JLdiWt91VZxHeYL38aLIUNqy8fKVx9RxXYUNJwqbXYI0nRZFxoBGtfXckRn2NkQOH+AyPmCA4H9pHPZU1tedqfksuGZ9p509t4zEKR83cxuUmmlxEFMU+SQnhjURt6PYD9dOT8NMCzalJbbAatyUzMiRauARJAo3ExktIKL5tF0GcCSYLGXMO5jT+J6uLg+FTj1p9gGnZhEn+30UyesYSxT9eCtHiPRvBkpfFeBJBnnJxlYMgsnwwh1bn3T7fqm+MRcReQbMRw24Urlb5AyYRhY4EUpKaPz/lj2kEVITuMS6Sxd1xbz4xFRSkjLlxR/LaL6oP4arWjChaBtUBdDw7lx4AjmtksmVJ2dNKou33qKQnFU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4792d463-6cdf-4e60-5d8e-08dafa974aa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 03:34:52.5144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BR3r4IeSaofnZW4M1OxA9n97Otgtz4tkmUdP4FfGyXWUTnjTdiaKCaXScRW7xT1lKc52SHG96ovdKeyK9Ct0tOXiJt4Iuxc5uubWfG/6EpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5714
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_16,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301200030
X-Proofpoint-GUID: ipkJ_6QPglHH_yI_ossF7lEF5tfHuQ8X
X-Proofpoint-ORIG-GUID: ipkJ_6QPglHH_yI_ossF7lEF5tfHuQ8X
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBKYW4gMTksIDIwMjMsIGF0IDM6NDcgUE0sIEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29u
LmhlbmRlcnNvbkBvcmFjbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgMjAyMy0wMS0xOSBh
dCAwMjoyMSArMDAwMCwgQ2F0aGVyaW5lIEhvYW5nIHdyb3RlOg0KPj4+IE9uIEphbiAxNywgMjAy
MywgYXQgNzo1NCBQTSwgRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4NCj4+PiB3
cm90ZToNCj4+PiANCj4+PiBPbiBUdWUsIEphbiAxNywgMjAyMyBhdCAwMjozNzo0M1BNIC0wODAw
LCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6DQo+Pj4+IEFkYXB0IHRoaXMgdG9vbCB0byBjYWxsIHhm
c19pbyB0byBnZXQvc2V0IHRoZSBsYWJlbCBvZiBhIG1vdW50ZWQNCj4+Pj4gZmlsZXN5c3RlbS4N
Cj4+Pj4gDQo+Pj4+IFNpZ25lZC1vZmYtYnk6IENhdGhlcmluZSBIb2FuZyA8Y2F0aGVyaW5lLmhv
YW5nQG9yYWNsZS5jb20+DQo+Pj4+IC0tLQ0KPj4+PiBkYi94ZnNfYWRtaW4uc2ggfCA5ICsrKysr
Ky0tLQ0KPj4+PiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQ0KPj4+PiANCj4+Pj4gZGlmZiAtLWdpdCBhL2RiL3hmc19hZG1pbi5zaCBiL2RiL3hmc19hZG1p
bi5zaA0KPj4+PiBpbmRleCBiNzNmYjNhZC4uY2M2NTBjNDIgMTAwNzU1DQo+Pj4+IC0tLSBhL2Ri
L3hmc19hZG1pbi5zaA0KPj4+PiArKysgYi9kYi94ZnNfYWRtaW4uc2gNCj4+Pj4gQEAgLTI5LDkg
KzI5LDExIEBAIGRvDQo+Pj4+ICAgICAgICAgaikgICAgICBEQl9PUFRTPSREQl9PUFRTIiAtYyAn
dmVyc2lvbiBsb2cyJyINCj4+Pj4gICAgICAgICAgICAgICAgIHJlcXVpcmVfb2ZmbGluZT0xDQo+
Pj4+ICAgICAgICAgICAgICAgICA7Ow0KPj4+PiAtICAgICAgIGwpICAgICAgREJfT1BUUz0kREJf
T1BUUyIgLXIgLWMgbGFiZWwiOzsNCj4+Pj4gKyAgICAgICBsKSAgICAgIERCX09QVFM9JERCX09Q
VFMiIC1yIC1jIGxhYmVsIg0KPj4+PiArICAgICAgICAgICAgICAgSU9fT1BUUz0kSU9fT1BUUyIg
LXIgLWMgbGFiZWwiDQo+Pj4+ICsgICAgICAgICAgICAgICA7Ow0KPj4+PiAgICAgICAgIEwpICAg
ICAgREJfT1BUUz0kREJfT1BUUyIgLWMgJ2xhYmVsICIkT1BUQVJHIiciDQo+Pj4+IC0gICAgICAg
ICAgICAgICByZXF1aXJlX29mZmxpbmU9MQ0KPj4+PiArICAgICAgICAgICAgICAgSU9fT1BUUz0k
SU9fT1BUUyIgLWMgJ2xhYmVsIC1zICIkT1BUQVJHIiciDQo+Pj4+ICAgICAgICAgICAgICAgICA7
Ow0KPj4+PiAgICAgICAgIE8pICAgICAgUkVQQUlSX09QVFM9JFJFUEFJUl9PUFRTIiAtYyAkT1BU
QVJHIg0KPj4+PiAgICAgICAgICAgICAgICAgcmVxdWlyZV9vZmZsaW5lPTENCj4+Pj4gQEAgLTY5
LDcgKzcxLDggQEAgY2FzZSAkIyBpbg0KPj4+PiAgICAgICAgICAgICAgICAgICAgICAgICBmaQ0K
Pj4+PiANCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgaWYgWyAtbiAiJElPX09QVFMiIF07
IHRoZW4NCj4+Pj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBleGVjIHhmc19pbyAt
cCB4ZnNfYWRtaW4gJElPX09QVFMNCj4+Pj4gIiRtbnRwdCINCj4+Pj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBldmFsIHhmc19pbyAtcCB4ZnNfYWRtaW4gJElPX09QVFMNCj4+Pj4g
IiRtbnRwdCINCj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBleGl0ICQ/DQo+
Pj4gDQo+Pj4gSSdtIGN1cmlvdXMsIHdoeSBkaWQgdGhpcyBjaGFuZ2UgZnJvbSBleGVjIHRvIGV2
YWwrZXhpdD8NCj4+IA0KPj4gRm9yIHNvbWUgcmVhc29uIGV4ZWMgZG9lc27igJl0IGNvcnJlY3Rs
eSBwYXJzZSB0aGUgJElPX09QVFMgYXJndW1lbnRzLg0KPj4gSSBnZXQgdGhpcyBlcnJvciB3aGVu
IHVzaW5nIGV4ZWM6DQo+IERpZCBzb21lIHBva2luZyBhcm91bmQgd2l0aCB0aGlzLiAgSSB0aGlu
ayB5b3UgbmVlZCAiJElPX09QVFMiIHRvIGJlIGluDQo+IHF1b3RhdGlvbnMgbGlrZSAiJG1udHB0
IiBpcy4gIE90aGVyd2lzZSB0aGUgcGFyYW1ldGVycyBvZiAibGFiZWwgLXMNCj4gdGVzdCIgZ2V0
IHNlcGFyYXRlZCBhbmQgcGFzc2VkIHRvIHhmc19pbyBpbnN0ZWFkIG9mIHhmc19hZG1pbi4gIEl0
DQo+IGRvZXNudCBjb21wbGFpbiBhYm91dCAtcywgd2hpY2ggaXQgaW50ZXJwcmV0cyBhcyBzeW5j
LCBhbmQgInRlc3QiDQo+IGJlY29tZXMgdGhlIG1vdW50IHBvaW50LCB3aGljaCBvZiBjb3Vyc2Ug
ZG9lcyBub3QgZXhpc3QuDQo+IA0KPiBJdCBkb2VzbnQgbG9vayBsaWtlIHlvdXIgVVVJRCBzZXQg
aGFzIG1lcmdlZCwgd2hpY2ggaXMgd2hlcmUgdGhlIGFib3ZlDQo+IGxpbmUgb2YgY29kZSBmaXJz
dCBhcHBlYXJzLiBBbmQgaXQgbG9va3MgbGlrZSB0aGlzIHBhdGNoIGNhbm5vdCBhcHBseQ0KPiBj
bGVhbmx5IHdpdGhvdXQgaXQuICBTbyBJIHRoaW5rIHRoZSBjbGVhbmVzdCBzb2x1dGlvbiBtaWdo
dCBiZSB0byBmaXgNCj4gdGhlIHF1b3RhdGlvbnMgaW4gInhmc19pbzogYWRkIGZzdXVpZCBjb21t
YW5kIiwgYW5kIHRoZW4gYWRkIHRoaXMgcGF0Y2gNCj4gdG8gdGhhdCBzZXQuICBNYXliZSBqdXN0
IGFkYXB0IHRoZSBzZXJpZXMgdGl0bGUgdG8gInhmc3Byb2dzOiBnZXQgVVVJRA0KPiBhbmQgbGFi
ZWwgb2YgbW91bnRlZCBmaWxlc3lzdGVtcyIuDQoNCkFoIHRoYXQgbWFrZXMgc2Vuc2UsIHRoYW5r
IHlvdSEgSeKAmWxsIHNlbmQgb3V0IGEgbmV3IHBhdGNoc2V0IHdpdGggdGhlIGNoYW5nZXMuDQo+
IA0KPiBPdGhlcndpc2UgdGhlIHNldCBpcyBsb29raW5nIHJlYWxseSBnb29kIDotKQ0KPiBBbGxp
c29uDQo+IA0KPj4gDQo+PiAjIHhmc19hZG1pbiAtTCB0ZXN0IC9kZXYvc2RhMg0KPj4gdGVzdCc6
IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkNCj4+PiANCj4+PiBPdGhlcndpc2UsIHRoaXMgbG9v
a3MgZ29vZCB0byBtZS4NCj4+PiANCj4+PiAtLUQNCj4+PiANCj4+Pj4gICAgICAgICAgICAgICAg
ICAgICAgICAgZmkNCj4+Pj4gICAgICAgICAgICAgICAgIGZpDQo+Pj4+IA0KPj4+PiAtLSANCj4+
Pj4gMi4yNS4xDQoNCg==
