Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753EFC25B4E
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Jan 2023 07:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjAVHDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Jan 2023 02:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVHDb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Jan 2023 02:03:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4749921A1A
        for <linux-xfs@vger.kernel.org>; Sat, 21 Jan 2023 23:03:30 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30M6udLJ017252;
        Sun, 22 Jan 2023 07:03:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=5d53wTaAvNB3sAgjIFYm3UL1o/yFIbxWX9Alkk/ZYts=;
 b=fiSvYgFbJkB4u++lwhxYzor9zZTjQu3/LKZfFtmPft6buuz3OTbr1eTsCSS7364/QCA3
 ZbjqxjFjYLVKFdPo36ZDfEO6pSC0uCE9NAVBNevcTvZfyIKVIPPSkxd78ObT/1BL65a8
 rgIMpgqljNfKWKozou9G4emrQNYT2BAjJ9tHgdwlvrXMmpf392Kyv7cnmOz4niha7VtK
 7WKawpiB8O2oxhFCvPyx/+bEdWW9t4rxgbPqa8rZOvCyBXGFK1j3ULFNingP0cNtXLmA
 NXZt93HVJ1LsrYJ3+/vfR5tggrOtm2zEYyr2EPZ3/u8ckdNIqNJe/Ou+t/15kd7KNAjs 1Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa11yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Jan 2023 07:03:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30M3pEKj004620;
        Sun, 22 Jan 2023 07:03:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g94mr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Jan 2023 07:03:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKY6rC/g87iXJK72IFo7fzB+lqB+Xm2Rd+AD9Lsk7u2PsbGOhqh+dpmm2D5FOE9vjOL4+ofvgX8AdkHdMm/0aVFQD5SaHZDcR0Ooja5t5wExmLesXAgXJ9flk9tqsf40iPdeWhA+sjbcatVJ7A36WPEzyLw2K6rqHhxU9m699de4iRxJPJtfkq8dfNBXw6C/4vign/GpKP2doUyf5TMrT/KJi74HPyhW+E19uVXgdKoDx22D1a32MhDi0N0vVbviBDvZXxgVW9c3tFGJoTk8X0jQgIrke0p3Lt1qTpy6GI3X/yypi/1jX0e03WW+9Xsgzr4diiPVeXKqG8x/Kpggrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5d53wTaAvNB3sAgjIFYm3UL1o/yFIbxWX9Alkk/ZYts=;
 b=PZ8oO5T+2eir2ssuwOXZzWfAGJMdqydg/ASQJSmUmBlcA/uyaxEXDpxKByIZs/N2INshP/fs9ZocMtiUOTqCWTmpcTSlKXf361/X2aRA/j0zGpElMym41xnKbl+0I5eZF5T7NgwjgpSj/8QtzKhU+CTF+eBjbG04wEF5lNq8zyTJwbiu5DSzjg0ntoAlSLwM9LjdXFxyOF3RF4hZwBU2X3a9qY4IsBQHD1c89LIJKCDR/vC2z/s52DCzkB8M04HZqZh8zwkPunl9F6eMhKya7hER/2Q2ckB4Fd/6KMvBOVpuJ742wQxUSql2waRBYLVuCsI1cz3udPkuqLxG6DWViw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5d53wTaAvNB3sAgjIFYm3UL1o/yFIbxWX9Alkk/ZYts=;
 b=PpRPujlIebyhHLHc5AFYYaGmeyiURrzAnzkYdoBUssuuRm60FxcZkDr6Yzot9RI97orzYPo15gb8tupiQ1L5gwOo6u0uvMRjrx5I3GIvOezLk0P0vwONM+7h7AehxvHDVEaLgXLmISMYcP15ceg1N9XO/XPYg9ROKNyr5GSgHj8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB5888.namprd10.prod.outlook.com (2603:10b6:806:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.7; Sun, 22 Jan
 2023 07:03:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%5]) with mapi id 15.20.6043.012; Sun, 22 Jan 2023
 07:03:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 12/42] xfs: convert xfs_ialloc_next_ag() to an atomic
Thread-Topic: [PATCH 12/42] xfs: convert xfs_ialloc_next_ag() to an atomic
Thread-Index: AQHZK46T/A1Z3CGCiUuF5H+DfTvxGK6qCB8A
Date:   Sun, 22 Jan 2023 07:03:24 +0000
Message-ID: <fed1783a6e8c49d1302b5fe0974717d6b0a336a3.camel@oracle.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
         <20230118224505.1964941-13-david@fromorbit.com>
In-Reply-To: <20230118224505.1964941-13-david@fromorbit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SA1PR10MB5888:EE_
x-ms-office365-filtering-correlation-id: 320a3474-7b81-4480-c7cb-08dafc46c141
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4FEgl/oLv60U+jTBmHJ5Ng5bvdTFLQe0WHrWZH8NYXnr6ooDScjrSpE2tBlEN/yDMfbvuhuC4ZI6z4cf5nR13c84jFpHGTfvZ4TZ5rR6+aZstLR2LyJLr/k22tKjNVbLDJVoFQ3YD8qUlq9hDAVMe9dInLvN1f5Vws+siHypIpzDn+S0o6n/HbAyl/WdGxHbrul3+V2UorKuvYGwGMYJ6orjD16ME6qoW4b+xRXU945wB6ZbBMyKuffrZAbViRvAoual5T8cjLm8/mVDKTsW5D2OKsTlfUmFg+Q7aFBmy+LWIdhEbEFfMS0epbzoI2uC9yjm2NRaJ/+ZMip3Q2/o2NF6xW4wKOxoeFFIsnhK4TbOSh3Ac0qQ+Ahao3dbFpalvMDBznKcNTN09n6FvRyqrwIsTjJJhIWGOdhLOgY0A5RdXWnb6GUYoodUwXX5Bg7jzpoF9ZC5O2PWcmbCt3jY3RmVMK05SyZUKASy8VFeTKanjIxUdWvOEAjWvUMZzqppaDmuQMFCBRK2Y85LYVxP9zm+LOcj98kaXsg0BuoLjHBZucLmUB2VFWMjbltqhFQbh62UZ+h2nH9UXYdwOYivDxv4Rbvlf/+3LF5WpvrNM1QHF9ePEQamqkJITmFrd8Fk7L217kRrmXPQwUE5HGRargKAUkW15RBS5v5yFobD+ytjHda63rkg0+ut5TfF9VM1bMJ6zaSCbAKY/okRnWkrnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199015)(2616005)(5660300002)(122000001)(36756003)(8936002)(64756008)(478600001)(38070700005)(2906002)(6486002)(110136005)(66446008)(8676002)(6512007)(66476007)(66556008)(76116006)(86362001)(186003)(26005)(66946007)(38100700002)(6506007)(316002)(41300700001)(83380400001)(71200400001)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjBTdjJ0WERwOWFiWjhqWCtrdEZOSEdCQ2RpZUh6dG1mS0tQZ1NVdk1aQksz?=
 =?utf-8?B?WlVNdVNSZ215bEpmMi81T3hMU2dnd2MrTTFJNVg0K29GUWxpZUxkSzd2STNL?=
 =?utf-8?B?c1NKQWhYMkFSSEc1TzRrcy80UHFzRkVpWWUwdlczZEFsN3pwMElBVDRkRUhD?=
 =?utf-8?B?bmI3UHVna1hNdU10eWxEWExRNEdJNWw2WVk2QUkwLzJOc2pqOGpabEF2Umtj?=
 =?utf-8?B?dmZBSkd2L0pVN0FaRFdOejhCa2VjOE1mT04xTzZFc3ZROFZkb0xPSUlVbkJP?=
 =?utf-8?B?ZHd3RFF4R29UN3Y3RWlxSGJRM2ZFdEhqa0M5aHg1MWt5SEdOYnhVVkFOMkN4?=
 =?utf-8?B?MGdyaTZRL2NUc2c0VkMvYm1RNEZraGZDY2RRMjhmQTVHUERKZ1pSV3VYR0Uy?=
 =?utf-8?B?Ukl4K0R2SVU2cXNNYVIxaGkrZU5FYk1BS2gweWdJMk1nZ21wU1MrZXVzUHVl?=
 =?utf-8?B?QkRndEJVVlNIY2dabG9UeU5qT2kwY2dHanFqZlFRclMrZlUzS3dxN29zcHcw?=
 =?utf-8?B?dUNYTEV0RHA3NGpuTXpPdllRbTJsb0hpM0l5dHJldE5JRGdocHFFN2dlQnhk?=
 =?utf-8?B?WmxWZ2hvY0ZSYlQxMmxlQ1h0azVTbW9YOVpCOGVZbDN2OTI0R3B4Qk9pZ2dZ?=
 =?utf-8?B?bXcxNWd6YzZVRHFVTzlhc1p2amFKNi9PejhjOW95VXpVZnlVdjl1N0ZvWGd2?=
 =?utf-8?B?TG9leThGeDF5NlpjNUZGOXdsZ2ZvLytFYlJ1NkMzZFVXVm9iVzNUeG1uODh3?=
 =?utf-8?B?VFpiRHhqVC9ZMmdTTjJpUU95bVNnRm5YOWVqWDdOTFJnNFlOQ21mV1NpU0tx?=
 =?utf-8?B?V1pyeHJ3RE13U2hjRTNvemRpRk9NMGx5Mlh5ZVA4enlUaUFZMXhGcEROVEpo?=
 =?utf-8?B?UlRlRUlmUWlQeXpEem1yZWY0bnlRUEJtT0IranFRdmpwTGZLd1ZzbVArT0Fk?=
 =?utf-8?B?TG1ITFBYeGtDVkN3S0dZRlluWHJmSDBSTUxYK0NJdEpVdE1zc1hVc3V0aCt1?=
 =?utf-8?B?S0E5N0tOTE02dUZKbjdVUTlJQjVieE1QMHBPTGMrUzlHSmFHUlFZcEJWL3k5?=
 =?utf-8?B?SnJOZStwYUtNbDdYVldNL3ZnN3FpMlR6VVROZW9sOUhZcW1McktpTHZjVlZ6?=
 =?utf-8?B?QnpmSXNKWHhPWXFyVzI4MThUQTUxSzB5dFFTeDhnMEluZVg5NmJIN25Ob3pJ?=
 =?utf-8?B?Tm5lWTZIRFRyQW0xMXc5bnMzMlU0TlNpNDhiRUMvdG1td1ZLWGwxTW1lRnZM?=
 =?utf-8?B?aVpOQ1BFWFhTdlAxZnd6NS8vdGpFMENKV3RocXRPMysvR2hINlEyTHUweTZp?=
 =?utf-8?B?L240eUh0S2xPaVJNSGRYUFpUbFpGRGViZnhTeVhqbE0wcXRhd0pzc1VCbUJu?=
 =?utf-8?B?aFVERTZWQVpFK3JmdUJSV2tycVd3Um8xYTFRbHV3K09LYjBSeHJ1Y1VIQ25G?=
 =?utf-8?B?dStNUGdGenlDL01rc3ViSThFeEtsVjl0NGp3ZzYvM3VIQmV6aG5qNVk5UlFR?=
 =?utf-8?B?dzdKL3pCN1RSL2FFNXZNc2QrY29GMmRkUUNvZC8xckkyZ3Y4bHhteXI2bEpT?=
 =?utf-8?B?RWR5b0RJdzBSemdWY3BBNjB4Y3l4QktkS011d1oxemZhZkdDck4waThTVDFi?=
 =?utf-8?B?WjVCb2x3Rm42YlVVODdmL1Zkb3Q1WHdXaG80NHY0RWhxbmFzYUFPRkt6Q2hE?=
 =?utf-8?B?SlBHRkdhZ3J5MzNhSTJISGxRL09ST0JZUjVwNHpxeFZkSXdBdGx2VFZTR09r?=
 =?utf-8?B?emFDYVNkU2hLUktQaG5LYWxlMjBoVU5ZRzFKUCtObVFZVmlndmkwK1pBSUNi?=
 =?utf-8?B?VkFyQWxDcExsbjM2T1dGRkJad2FuUDd3QVpuRUpuQjB4Sm5SaDFxeTg3ZWNR?=
 =?utf-8?B?YU8vclF3N1JZd3pKSERNc2hVRTh5U3dHcXlHZW01eE5mYzBQMDJubVZKTkNE?=
 =?utf-8?B?ZXBVODFkM3J5aGhBZEFoZXNQb2ZUN2xveG8zZTVwT0xVSG9qbGhHZE1Ea0lQ?=
 =?utf-8?B?SVp1cEo5VW9raVI2NWV4d2pWakZGeHhHd05uWUx0Uk9UUENuNWZUaUdSTjFE?=
 =?utf-8?B?MlIzQjUzSFFNS28zRE9HSWU2S0w0Z1hkNHN2WThFd2JZZkZNK2o1c0FrdTJy?=
 =?utf-8?B?WkhtK05tRDlMMUU4Nk40U2RXaGdQZndHNEtPTUFSVVN0K3REUjlidS90T1lG?=
 =?utf-8?Q?i4d7lzNlplHLy7MjIAj31CI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86C48F6106323C4E972A7A68243464C2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: v5qY2ldAVITcxvP3sMCf9J/I4hcD9G1lk9TX9SLCq9mK9vgFf0alNrHrWT6NNog4/fnd1JGoeMvHlp7h64P9Es4wMWW5KWJFkG1U+98/iSu3Dez8pbh0zYo4e5GB+pkfOqlb9vTe4qRoLUey4MNAzoqaS3TMMA71v57UEcZtECM+yfLqDFlUslp16Bm2BwxbqhZOP7lACSJNXZuwfBasPqX+aAcSvmPN3uN6plfvnVx8Ml3C9R+eEXpA29tIesuVYS5BP3FuALToOszKK9NT2t/KtuhP9t02/36ML3drKg9AtG6dQRI4ArseeFdOuikBSaxVGKRKFn2sTh7/Pejm75HMBin2vLs30X83OksdsFk5LNBxRMiWO3tg5r9eKcFfXdbZY5P1eLDIEw9GNi0d3+NZvASR2g7Sks+1b3W/CTIgFhMyO2MlrkQ/tu7NFKNqoP0WpBzTrdSbngEnYv9xZbYJg3OEzhmR2KvSroXqGf/GO8WxdxAgSi3k3RDKf4+LF3oPlE62hjqGn+x8aODbTC1QmuMyktQ/gt9jGfDBKcFeDAQafFCWK5XwJZbAfR8Jg76s9LDR4djphDove9epFMRzgTE3JmIodyKpC79e1jWZuuC0KcYbkqgWN0hMNHm4ucyRLUH1wG4Y0rrY/H9w7gD9OKlK5/h7R+8OBaooIXUTHfdxYm+9kBMyou7mLQDP2cQSwKWNHqtj0r/p9WNjTxghdjI8kTcdH2PpvAPYRqdWm5BkCbYRaEAno+ScpuzCjNtyZtLlEzUYJCjfahhwczirXNME9IoKLAzuaXBN+i0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 320a3474-7b81-4480-c7cb-08dafc46c141
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2023 07:03:24.6414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OlyBPO7UyCfo4yqTALyD0QUKq7KkkQ86X1JqODAtuBld9xoNs14Nf0AVK102T8cIYkUXxvDSbjfx1kR8Z81W89dwqcmQB1bDwZCdACmaE3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-22_03,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301220067
X-Proofpoint-GUID: UlfEzL7vNVK6IvDEP5e1_5DZo2wF59-i
X-Proofpoint-ORIG-GUID: UlfEzL7vNVK6IvDEP5e1_5DZo2wF59-i
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDA5OjQ0ICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IAo+IFRoaXMgaXMgY3Vy
cmVudGx5IGEgc3BpbmxvY2sgbG9jayBwcm90ZWN0ZWQgcm90b3Igd2hpY2ggY2FuIGJlCj4gaW1w
bGVtZW50ZWQgd2l0aCBhIHNpbmdsZSBhdG9taWMgb3BlcmF0aW9uLiBDaGFuZ2UgaXQgdG8gYmUg
bW9yZQo+IGVmZmljaWVudCBhbmQgZ2V0IHJpZCBvZiB0aGUgbV9hZ2lyb3Rvcl9sb2NrLiBOb3Rp
Y2VkIHdoaWxlCj4gY29udmVydGluZyB0aGUgaW5vZGUgYWxsb2NhdGlvbiBBRyBzZWxlY3Rpb24g
bG9vcCB0byBhY3RpdmUgcGVyYWcKPiByZWZlcmVuY2VzLgo+IAo+IFNpZ25lZC1vZmYtYnk6IERh
dmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KT2ssIG1ha2VzIHNlbnNlClJldmlld2Vk
LWJ5OiBBbGxpc29uIEhlbmRlcnNvbiA8YWxsaXNvbi5oZW5kZXJzb25Ab3JhY2xlLmNvbT4KPiAt
LS0KPiDCoGZzL3hmcy9saWJ4ZnMveGZzX2lhbGxvYy5jIHwgMTcgKy0tLS0tLS0tLS0tLS0tLS0K
PiDCoGZzL3hmcy9saWJ4ZnMveGZzX3NiLmPCoMKgwqDCoCB8wqAgMyArKy0KPiDCoGZzL3hmcy94
ZnNfbW91bnQuaMKgwqDCoMKgwqDCoMKgwqAgfMKgIDMgKy0tCj4gwqBmcy94ZnMveGZzX3N1cGVy
LmPCoMKgwqDCoMKgwqDCoMKgIHzCoCAxIC0KPiDCoDQgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRp
b25zKCspLCAyMCBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhmcy94
ZnNfaWFsbG9jLmMgYi9mcy94ZnMvbGlieGZzL3hmc19pYWxsb2MuYwo+IGluZGV4IDViODQwMTAz
OGJhYi4uYzhkODM3ZDg4NzZmIDEwMDY0NAo+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX2lhbGxv
Yy5jCj4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNfaWFsbG9jLmMKPiBAQCAtMTU3NiwyMSArMTU3
Niw2IEBAIHhmc19kaWFsbG9jX3JvbGwoCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiBlcnJvcjsK
PiDCoH0KPiDCoAo+IC1zdGF0aWMgeGZzX2FnbnVtYmVyX3QKPiAteGZzX2lhbGxvY19uZXh0X2Fn
KAo+IC3CoMKgwqDCoMKgwqDCoHhmc19tb3VudF90wqDCoMKgwqDCoCptcCkKPiAtewo+IC3CoMKg
wqDCoMKgwqDCoHhmc19hZ251bWJlcl90wqDCoGFnbm87Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoHNw
aW5fbG9jaygmbXAtPm1fYWdpcm90b3JfbG9jayk7Cj4gLcKgwqDCoMKgwqDCoMKgYWdubyA9IG1w
LT5tX2FnaXJvdG9yOwo+IC3CoMKgwqDCoMKgwqDCoGlmICgrK21wLT5tX2FnaXJvdG9yID49IG1w
LT5tX21heGFnaSkKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbXAtPm1fYWdpcm90
b3IgPSAwOwo+IC3CoMKgwqDCoMKgwqDCoHNwaW5fdW5sb2NrKCZtcC0+bV9hZ2lyb3Rvcl9sb2Nr
KTsKPiAtCj4gLcKgwqDCoMKgwqDCoMKgcmV0dXJuIGFnbm87Cj4gLX0KPiAtCj4gwqBzdGF0aWMg
Ym9vbAo+IMKgeGZzX2RpYWxsb2NfZ29vZF9hZygKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhm
c19wZXJhZ8KgwqDCoMKgwqDCoMKgwqAqcGFnLAo+IEBAIC0xNzQ4LDcgKzE3MzMsNyBAQCB4ZnNf
ZGlhbGxvYygKPiDCoMKgwqDCoMKgwqDCoMKgICogYW4gQUcgaGFzIGVub3VnaCBzcGFjZSBmb3Ig
ZmlsZSBjcmVhdGlvbi4KPiDCoMKgwqDCoMKgwqDCoMKgICovCj4gwqDCoMKgwqDCoMKgwqDCoGlm
IChTX0lTRElSKG1vZGUpKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdGFydF9h
Z25vID0geGZzX2lhbGxvY19uZXh0X2FnKG1wKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgc3RhcnRfYWdubyA9IGF0b21pY19pbmNfcmV0dXJuKCZtcC0+bV9hZ2lyb3RvcikgJSBt
cC0KPiA+bV9tYXhhZ2k7Cj4gwqDCoMKgwqDCoMKgwqDCoGVsc2Ugewo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgc3RhcnRfYWdubyA9IFhGU19JTk9fVE9fQUdOTyhtcCwgcGFyZW50
KTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChzdGFydF9hZ25vID49IG1w
LT5tX21heGFnaSkKPiBkaWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhmcy94ZnNfc2IuYyBiL2ZzL3hm
cy9saWJ4ZnMveGZzX3NiLmMKPiBpbmRleCAxZWVlY2YyZWIyYTcuLjk5Y2MwM2EyOThlMiAxMDA2
NDQKPiAtLS0gYS9mcy94ZnMvbGlieGZzL3hmc19zYi5jCj4gKysrIGIvZnMveGZzL2xpYnhmcy94
ZnNfc2IuYwo+IEBAIC05MDksNyArOTA5LDggQEAgeGZzX3NiX21vdW50X2NvbW1vbigKPiDCoMKg
wqDCoMKgwqDCoMKgc3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDCoMKgwqAqbXAsCj4gwqDCoMKg
wqDCoMKgwqDCoHN0cnVjdCB4ZnNfc2LCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKnNicCkKPiDCoHsK
PiAtwqDCoMKgwqDCoMKgwqBtcC0+bV9hZ2Zyb3RvciA9IG1wLT5tX2FnaXJvdG9yID0gMDsKPiAr
wqDCoMKgwqDCoMKgwqBtcC0+bV9hZ2Zyb3RvciA9IDA7Cj4gK8KgwqDCoMKgwqDCoMKgYXRvbWlj
X3NldCgmbXAtPm1fYWdpcm90b3IsIDApOwo+IMKgwqDCoMKgwqDCoMKgwqBtcC0+bV9tYXhhZ2kg
PSBtcC0+bV9zYi5zYl9hZ2NvdW50Owo+IMKgwqDCoMKgwqDCoMKgwqBtcC0+bV9ibGtiaXRfbG9n
ID0gc2JwLT5zYl9ibG9ja2xvZyArIFhGU19OQkJZTE9HOwo+IMKgwqDCoMKgwqDCoMKgwqBtcC0+
bV9ibGtiYl9sb2cgPSBzYnAtPnNiX2Jsb2NrbG9nIC0gQkJTSElGVDsKPiBkaWZmIC0tZ2l0IGEv
ZnMveGZzL3hmc19tb3VudC5oIGIvZnMveGZzL3hmc19tb3VudC5oCj4gaW5kZXggOGFjYTJjYzE3
M2FjLi5mMzI2OWMwNjI2ZjAgMTAwNjQ0Cj4gLS0tIGEvZnMveGZzL3hmc19tb3VudC5oCj4gKysr
IGIvZnMveGZzL3hmc19tb3VudC5oCj4gQEAgLTIxMCw4ICsyMTAsNyBAQCB0eXBlZGVmIHN0cnVj
dCB4ZnNfbW91bnQgewo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QKPiB4ZnNfZXJyb3JfY2ZnwqDC
oMKgwqBtX2Vycm9yX2NmZ1tYRlNfRVJSX0NMQVNTX01BWF1bWEZTX0VSUl9FUlJOT19NQVhdOwo+
IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeHN0YXRzwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG1fc3Rh
dHM7wqDCoMKgwqDCoMKgwqDCoC8qIHBlci1mcyBzdGF0cyAqLwo+IMKgwqDCoMKgwqDCoMKgwqB4
ZnNfYWdudW1iZXJfdMKgwqDCoMKgwqDCoMKgwqDCoMKgbV9hZ2Zyb3RvcjvCoMKgwqDCoMKgLyog
bGFzdCBhZyB3aGVyZQo+IHNwYWNlIGZvdW5kICovCj4gLcKgwqDCoMKgwqDCoMKgeGZzX2FnbnVt
YmVyX3TCoMKgwqDCoMKgwqDCoMKgwqDCoG1fYWdpcm90b3I7wqDCoMKgwqDCoC8qIGxhc3QgYWcg
ZGlyIGlub2RlCj4gYWxsb2NlZCAqLwo+IC3CoMKgwqDCoMKgwqDCoHNwaW5sb2NrX3TCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgbV9hZ2lyb3Rvcl9sb2NrOy8qIC4uIGFuZCBsb2NrCj4gcHJv
dGVjdGluZyBpdCAqLwo+ICvCoMKgwqDCoMKgwqDCoGF0b21pY190wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBtX2FnaXJvdG9yO8KgwqDCoMKgwqAvKiBsYXN0IGFnIGRpciBpbm9kZQo+
IGFsbG9jZWQgKi8KPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqAvKiBNZW1vcnkgc2hyaW5rZXIgdG8g
dGhyb3R0bGUgYW5kIHJlcHJpb3JpdGl6ZSBpbm9kZWdjICovCj4gwqDCoMKgwqDCoMKgwqDCoHN0
cnVjdCBzaHJpbmtlcsKgwqDCoMKgwqDCoMKgwqDCoG1faW5vZGVnY19zaHJpbmtlcjsKPiBkaWZm
IC0tZ2l0IGEvZnMveGZzL3hmc19zdXBlci5jIGIvZnMveGZzL3hmc19zdXBlci5jCj4gaW5kZXgg
MGM0YjczZTliMjlkLi45NjM3NWI1NjIyZmQgMTAwNjQ0Cj4gLS0tIGEvZnMveGZzL3hmc19zdXBl
ci5jCj4gKysrIGIvZnMveGZzL3hmc19zdXBlci5jCj4gQEAgLTE5MjIsNyArMTkyMiw2IEBAIHN0
YXRpYyBpbnQgeGZzX2luaXRfZnNfY29udGV4dCgKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJldHVybiAtRU5PTUVNOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHNwaW5fbG9ja19p
bml0KCZtcC0+bV9zYl9sb2NrKTsKPiAtwqDCoMKgwqDCoMKgwqBzcGluX2xvY2tfaW5pdCgmbXAt
Pm1fYWdpcm90b3JfbG9jayk7Cj4gwqDCoMKgwqDCoMKgwqDCoElOSVRfUkFESVhfVFJFRSgmbXAt
Pm1fcGVyYWdfdHJlZSwgR0ZQX0FUT01JQyk7Cj4gwqDCoMKgwqDCoMKgwqDCoHNwaW5fbG9ja19p
bml0KCZtcC0+bV9wZXJhZ19sb2NrKTsKPiDCoMKgwqDCoMKgwqDCoMKgbXV0ZXhfaW5pdCgmbXAt
Pm1fZ3Jvd2xvY2spOwoK
