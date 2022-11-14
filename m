Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC245C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Nov 2022 22:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbiKNWzN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 17:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237763AbiKNWzG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 17:55:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FB51AF10
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 14:55:05 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AELEqCA002751;
        Mon, 14 Nov 2022 22:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=6yE1kp4FFruYdce38uC9h4Cj0iolgpAXZN2z23FkxFM=;
 b=Ni27tpGY2U1v3Du7uTVEI5JbA32cfsocsPVQ/q0nPU/5xtMCx1Z5h6GK1cXyw89cTZWZ
 ogiYDqdr05GiQet8Qwoxzt59MW8FqpIo9gNDktlt6+eH9gkTlH3kUA0jcky+QAYbNL/S
 ostc1Pck9YEYWaeyI3sWOJ4xB1rvD3QaAPdbEaRD5uxUW2rXPY/5ia0bwblQ4gfF2zM4
 ps/T5lWdJFp/vrHIq4AJXzqPoqm10zD90v2tlaUIy4vYcP3Lc+6l8xVMOXfRL/sE4ypS
 EmPlWyfjIVStiVfNjxcL7AsldKd3ebstQ/BX7nBysk2H8rA+7y/nO/u8H48VsOqP678j 5w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kut2d902w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 22:55:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AEMM8wQ031937;
        Mon, 14 Nov 2022 22:55:03 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xaw3wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 22:55:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUFfmq4+lyRu4jm8FiISLM1yNxBZ5Kn8Rz7WCbzh9mVrhleVGcPx1OnniMgIjEksdxnAtStxQCXoIh0bU3b5uGqgUDtfhcs9kHb9GBRNP+tWwoaa8E55/vKe5BRfRaeVvNWz1vKLCq/lkzUoliebz0B0RPdKC19Itf/wMnCVgOn8wkul6bPIWYsnElAhRExrVnCZLpA9tLICF4up5B+NlmttEtFa1qu5iMQsdZFHRM/EKZmfgAzTbR7/oxg+Nx2CpuENpPRUNol1kvRtsB40C1XgGfbJrvn+w1yad/9nI+IRQpQvqzxnhCpHd9bvVbf7n3KDfKwANnzOTIuZm+4TiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yE1kp4FFruYdce38uC9h4Cj0iolgpAXZN2z23FkxFM=;
 b=lfyyCWGR/CqL9Z+vvYszIC01kJe1Tes2QnN8h8hedhXM47BobcSsKH1Jab1a3COz4MR/jHwgdCbHE8/qwQ7mfzshy9j5FmBoBpIHnvsr8j/LrWfl2OAgLJV/HFSCaX+KNCXiUGORQOMJ56RdCuwnYZXM/ccMKd10Utujxs1znQPsyOS8a+4SASTP4OlGAj+QnCJW8d7fKg7Ku6hrAw6dxlVPaUYP05Jq9rw/8GMtSsZj9Qil7IsLCqN4gDs9Vu3isQCGlL67fOy/Sh2IJhWXTEh3/cgTu9B82wNYQlNxDij+e5de22w5nvd2yDKypWPeUTHd2a5GgMXqK0LKFKBCaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yE1kp4FFruYdce38uC9h4Cj0iolgpAXZN2z23FkxFM=;
 b=S7Hutcb5fLYqebfgpNKvEyd21VAuyfQ/djBN2MYZCDpFqZaIvyrx2p3+QFVOldglCjdFHpSgQvMgKpFp7qoqKOZa/9dgyQ3X1uoJYlzw9mYOj1rfMpLl6+riGKdAZIIJJfl4MHiyJNbSANE/+0dBG9/FYwWXVv0KPgD4J+z8vfI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5619.namprd10.prod.outlook.com (2603:10b6:303:14a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 22:55:01 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137%4]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 22:55:01 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1] xfs_spaceman: add fsuuid command
Thread-Topic: [PATCH v1] xfs_spaceman: add fsuuid command
Thread-Index: AQHY+HwgWC8Y9PxlnEGUOOWaXoMWvA==
Date:   Mon, 14 Nov 2022 22:55:00 +0000
Message-ID: <FEFB8B00-8F29-4286-B2F6-340806DFE9B2@oracle.com>
References: <20221109222335.84920-1-catherine.hoang@oracle.com>
 <20221111210532.GP3600936@dread.disaster.area>
In-Reply-To: <20221111210532.GP3600936@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|CO6PR10MB5619:EE_
x-ms-office365-filtering-correlation-id: c51ad392-7e88-4f4d-4223-08dac69342cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oDH6ApLv0Y8oQA5BUcfWasURILSckpTMLsJPpdafxVMiPPIGLsglwXL2grJWbmbFLdO2N6zQzGc2l+yS1kwUpK0GkEeeoqKcdbTduTzZ3OJqMvsqw0T2NamPZZdBowI1Nw6S3Lzf3Jl2umF8xgnzAhAZw4vtDZmGhryzz4AAzc3a32draCD5BBxH4Qff8qc+5NQnwnFXG3ojHegWtM/v5nu1BE/uCsvnSowy67jBkVjTbJ10gq/rWUNW3TXd7Vcg4ogKh4kNYJ/ACx6tDD14L6om6sksm5ohsyLomhT/d2pUNuVEw8NgYhe4CIqQqPHPzJ7YArYhnu1sAvSCAuYozveBbmehcNWHB1gXOqunKJM5emOYOlAEzUFlV5pj++vXyL+7HnsQ0m5T5/CTRnMvzVaDenqh/4zP874dniPCxfZvFKydq/m3f6ECjRtlftjbuyQrdCVkiXi12jmbg8x8CTFtz25aPmkeyN63jUzzlnIoswJF6SeYsHD9lUzKSaLj8F3n8Y86CG+TDGWT/JvOWKqsYa2rRYDvmTT0z5GW+24FX1BvaSm8dnVXD4A7RSS8Vb6D6bOwWponjLRBXthJliHTSxHBHEDouJL638d1WPDso20QZ67soSLWqKnl94LMYymBt83jmDFuCROPbfMQB9FZyL2IzAm6ifIkcLMHf551yGHvrSrkmohGbfrSRnscE0YuWc2idcBp8HwR0PEjGSA835BaM/cxXXYniYyIcyPbAaXw9L6NQcgOaMyTNpR3RzceQ51fOlmMel2hvf5uvxaiQmitu39i4IO7VvhDE6E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199015)(8676002)(186003)(91956017)(66946007)(316002)(66556008)(6512007)(4326008)(66446008)(64756008)(76116006)(66476007)(41300700001)(44832011)(2616005)(5660300002)(53546011)(36756003)(8936002)(122000001)(38100700002)(86362001)(83380400001)(2906002)(33656002)(71200400001)(6486002)(478600001)(38070700005)(6916009)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1REN3RxWEM4YkQ4Vjl4dTBaZ00wVU1KMzlxVkROR2FWMHhFQ21hZU5JaE5r?=
 =?utf-8?B?ek1BM2ZuQjlhV3lGbythSUVwTjdGMGlhV0l6MWpqcS9oYWQzMzRHYk9lekhl?=
 =?utf-8?B?bWVtanhWZHB3TmQxV29mNkdWYnlpTXFEazFRbU5HTjIxN0JNaC9lZ1pkSlpa?=
 =?utf-8?B?N3Ixay96QmxLNm1WNzBlYTJmK2h2cW5XM0RQbWxEMjBxTnNkRTFIRXFHb2Y2?=
 =?utf-8?B?bWU0WWtSd3QzbmFZc3RnUmRNcXk0U0hwaUhDeUVNTENLc1lDbjlCemtQV1Z2?=
 =?utf-8?B?azBwWkp1V0J2NVlldHBUZHJBRGJWNTU3TVNlRFZhODFsaUxxOGtjOEZWUXFt?=
 =?utf-8?B?TFJja2FTNVhTd1Z6N1pHR1NCWnY4RHFPdExwRmpPZmh3bWlsUGJzclk0ZlNn?=
 =?utf-8?B?K203dmlVc0JMUW80TXQzRDZJMG5HVUdOamRDVnZIV1doOXVmSVlIYXd6VzQw?=
 =?utf-8?B?d2FLckNkOXAwZ3JRWlJPWStrQXI1RnNNVE1FQTBWVEM1L2QxK0M1Wlh6UXFl?=
 =?utf-8?B?MVhhNUd1NWJ1dUpUbVZyRU44Q05INVBaQ09Nc1Z5SVJHaDBkWGdNcUdzWlZM?=
 =?utf-8?B?QW05bVJ6b1hwKzVzamZTTXMzcWVSTXVhRjU3U09oZGptWkw3NGEvbkVvZTc3?=
 =?utf-8?B?NS8zL2pIRHRzdU9jSkVuQ2hlNDhCNE1saWZRVlpzRUdPZjNJNGk4aENpK1JG?=
 =?utf-8?B?dGZkQXdGSUFyNkVkV0drMmxVS3RjS2lLSzlaZTQ5dE1ydERDckgyWjYxZHov?=
 =?utf-8?B?d1VzZXdSTUxQQVhPZFlTK3hlNk9tYnNNQVo3ZzZORG9MSnBtWjgyYzlwSjlB?=
 =?utf-8?B?L1JkZ0VCZ2NPR09BS2JDS05KMWxKS0pFRThESWVid0tldWRuWEZvSktFSGtY?=
 =?utf-8?B?Q2dQeE53cDRQOW1uRThjazRhcTQ1MnduckhVRWNtTDhBYXdRQVd4a0hlNXlw?=
 =?utf-8?B?OEY3ZjBhNzlQY3RpdFk0c2xpeHBtQyt6VFNncUZwdFF3Q1hpVVJLMWZLQ29a?=
 =?utf-8?B?L0V0T25VWGUrNHprZFZVRHpmWk5OdXNGOFBFMEdZUHVQSWY1OWJTSXNrZEQw?=
 =?utf-8?B?RTJHYWVhSDIyR2I0THBwcEdVRy82VTk3eEZqdm1RSk5pcTZmS1pIL2RSaVZG?=
 =?utf-8?B?aEpOcDBGTjZvOWZwbGJkbHhINWZhTXFBbFVPYi81OEpkdEhaMXRMNzM4S2JS?=
 =?utf-8?B?ZUszQ2s2RFU2dllLcERvMmZFelFWVHVzWERhYmVYRFZENGhzanR4a0VHTnJl?=
 =?utf-8?B?TnV6VVVHTStZL3E4MHVzTDlkL2VnL1NvcldmTnVNTkxQRk91bzI0ZzM5WWVz?=
 =?utf-8?B?bzNtaXMwMzdjcXBabVBhSGtxZktYZ3RYR3NtTXRXU3BjbGpDU0pnSzZlU0pG?=
 =?utf-8?B?eTNPV2N1QzlCSklpT2Q5OG1ZdE1sdWY4eGp0VUhnYUlrMWR6STJ4SHNZeStj?=
 =?utf-8?B?NmdxOUVUM1VieCtQTGF4QUthdWVUTmdpU3dIL3l6aG9Cb1pYYmxaaEdVcW9l?=
 =?utf-8?B?MmVpYnpNUWZzc2pLWjBPSmFZVjhWdGlsWWlyOFRsOXhpemlremhkYVF2bStC?=
 =?utf-8?B?M29ZVFVjVXJTZ3JnbW5nNEMwYWRIWHQwS0h6QTJPTHNkdGlGWEpDZzlDYjJ1?=
 =?utf-8?B?aUxFeEhpSVdseERWNEpqWHZlRUpMNEVoejZFdmFHMktnWmVSNmJtSklFZFZF?=
 =?utf-8?B?RFM3MThDQ3JYN0lpeWVuYnljMTFRR055NExXa082TGo1WWMxaVhWNGI3TENM?=
 =?utf-8?B?NDY5YkZVLzhidkRjV0djbVF3WDU2OUxVcXJKMzB1SWgwUWRHTWRpY1ozTU9r?=
 =?utf-8?B?L0VEWWxmYXhjMUlVY0k0c2VUY2FtNVRjb3J1NHdhVStNZDhqRm5XZjN4bmx2?=
 =?utf-8?B?bDlmZXB0U3VqeXJpbWppT1ExUXY1SmNEKzNEY1NMcm55dkp6MGxyR2ZMajVp?=
 =?utf-8?B?bkx4VG1uK2hwQXFVU1JlaktETDk2WTBNSE0zNzZIZUsyRS9JaUtnMXdHNjdt?=
 =?utf-8?B?d2E5QlBsUFlyYzJSOHQ4c1hNT0lIS2tLbDFsTytRdEx1N01NeTVPbUd5Zytq?=
 =?utf-8?B?MVgxaUxHVXpKZnVZTk5nQnNhdUYwdkpGTFVNbHUwcmxNbzBQYWo4Qm1Ed24x?=
 =?utf-8?B?Mk1hdXYyRkZDcXc5M3lXY01qVnNIZDVnZTNHUDVnQWdQYnY2ZFhQcmNjK3FW?=
 =?utf-8?B?OWNoTmM1YzQ2WGQwdy9QWkVGSjVweTU5c1pGdzk0bWhwSkhOTnpZUCsrSk9H?=
 =?utf-8?B?VENMeHZ6RkxHNXBSM0pvaTl0anhnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7B162E57E687A45AC69325FA932AC2F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yJw4h7THjogayfQqB/2lU6PUqjY96YUck9S1hNHgwuwp3eoTTnDnyI9UjNhvCwntC8spzmgvqweVKJHJQOjlx6L6JwLXO5U/QbQYNB45ZqT0pOnkMJqIOcNyeFtxfpVnRyWSldobPFKPRVvaB7DpjykULQSjlWeCqD0WEUXidxXm558FsQhzMmemF3l2kM8R4EfwueC8hcxK/IoXzSoD+bfYeUkXWl6jAnR+GUusz5Pk7VvLNcDI/T+LQPeWlSee+zEC1v33nNWZKppaAojVxu3jT1f0UuPZmNzLivUxrI2gRO+OhLECjfrXnbq0Ko2RKB59ofxReePLIDp3LC50bjdFn4zWeWoaVjsAETmVztNrgDCLF3XzRNZshPY1x4bFNftsn75xRFvqWHX2v3zp98UdU5rbKArJufLkSRe4aTb7Cv866IdbjssSjGrN1dsb8Pifkqgsn0Pjjtzs1Yr7DmAMb5uzy6dbQPKAvBrQNaQPQGz5kJybDXyohTsq6uW1ETZ2BOiArbJr5puhRL3K0p+i21N4wkXLP1EWAYRHQ0kf1ys1ZNu+lMUhdSg/5ChFhDeI7ZhFesnoer4lqQbNjaA6XR88XjN4m3a70y3NpwJdYzq0HjlMZRZPEJpcyYc8wXLMHU/JC96aHK/Bp4o2Zg5OVKUzVjyc5CG2KvwO5TkfxuJ9nFtC3rShKe8hjynCHPDXqTlB4128zH3q7e2f6vuQnNmeAu7VtpWm6BGsuD/mx2irtxDcusqqpkRgqlHXADsobCPPCGh8Wd+6NdGWIWBtA0TbPxvAgdEogdEIlWxAtRD3maM+ZclDtFac0uwK
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c51ad392-7e88-4f4d-4223-08dac69342cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 22:55:00.9249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AHxWZAh/qXGpnRGZBuNGOtdSRY19RMK0+U1non93agA6vlzhk/98vUhxd7s7CaFAYSWRaLiwGZGF6GgB1QZjKAkXSSjgH/R/H/raZzQiqHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5619
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_15,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211140161
X-Proofpoint-GUID: J-5kxK-EgRTC-_F5qMMbw6KjwvFdtSzN
X-Proofpoint-ORIG-GUID: J-5kxK-EgRTC-_F5qMMbw6KjwvFdtSzN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBOb3YgMTEsIDIwMjIsIGF0IDE6MDUgUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9y
Yml0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIE5vdiAwOSwgMjAyMiBhdCAwMjoyMzozNVBN
IC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6DQo+PiBBZGQgc3VwcG9ydCBmb3IgdGhlIGZz
dXVpZCBjb21tYW5kIHRvIHJldHJpZXZlIHRoZSBVVUlEIG9mIGEgbW91bnRlZA0KPj4gZmlsZXN5
c3RlbS4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogQ2F0aGVyaW5lIEhvYW5nIDxjYXRoZXJpbmUu
aG9hbmdAb3JhY2xlLmNvbT4NCj4gDQo+IE5vdCBsb29raW5nIGF0IHRoZSBjb2RlLCBqdXN0IHRo
ZSBoaWdoIGxldmVsIENMSSBpbnRlcmZhY2UgaXNzdWVzLg0KPiANCj4gVGhhdCBpcywgeGZzX2Fk
bWluIGFscmVhZHkgaGFzIHVzZXIgaW50ZXJmYWNlcyB0byBnZXQvc2V0IHRoZQ0KPiBmaWxlc3lz
dGVtIFVVSUQgb24gWEZTIGZpbGVzeXN0ZW1zLiBGdXJ0aGVyLCB4ZnNfc3BhY2VtYW4gaXMgZm9y
IFhGUw0KPiBmaWxlc3lzdGVtIFNQQUNFIE1BTmFnZW1lbnQsIG5vdCBmaWxlc3lzdGVtIGlkZW50
aWZpY2F0aW9uDQo+IG9wZXJhdGlvbnMuDQo+IA0KPiB4ZnNfYWRtaW4gaXMgQ0xJIGludGVyZmFj
ZSB0aGF0IGFnZ3JlZ2F0ZXMgdmFyaW91cyBhZG1pbiB1dGlsaXRpZXMNCj4gc3VjaCBhcyBpZGVu
dGlmaWNhdGlvbiAoVVVJRCBhbmQgbGFiZWwpIG1hbmFnZW1lbnQuICBJZiB3ZSBuZWVkIHRvDQo+
IGltcGxlbWVudCBhIGdlbmVyaWMgVkZTIGlvY3RsIGZvciBvbmxpbmUgVVVJRCByZXRyZWl2YWws
IHhmc19pbyBpcw0KPiBnZW5lcmFsbHkgdGhlIHBsYWNlIHRvIHB1dCBpdCBiZWNhdXNlIHRoZW4g
aXQgY2FuIGJlIHVzZWQgYnkgZnN0ZXN0cw0KPiB0byBydW4gb24gb3RoZXIgZmlsZXN5dGVtcy4N
Cg0KT2ssIHRoYXQgbWFrZXMgc2Vuc2UuIEkgY2FuIG1vdmUgdGhpcyB0byB4ZnNfaW8NCj4gDQo+
IFdlIGNhbiB0aGVuIHdyYXAgeGZzX2FkbWluIGFyb3VuZCB0aGUgeGZzX2lvIGNvbW1hbmQgYXMg
bmVlZGVkLiBpLmUuDQo+IHVzZSAneGZzX2lvIC1jIGZzdXVpZCAvbW50L3B0JyBpZiB0aGUgZmls
ZXN5c3RlbSBpcyBtb3VudGVkLCAneGZzX2RiDQo+IC1jIHV1aWQgL3BhdGgvdG8vZGV2aWNlJyBp
ZiB0aGUgZmlsZXN5c3RlbSBpcyBub3QgbW91bnRlZCwgYW5kIHdlDQo+IGNhbiBtYWtlIHN1cmUg
dGhhdCBib3RoIHRoZSB4ZnNfZGIgYW5kIHhmc19pbyBjb21tYW5kcyBoYXZlIHRoZSBzYW1lDQo+
IG91dHB1dC4uLi4NCg0KWWVzLCB0aGF0IGlzIHRoZSBldmVudHVhbCBnb2FsIGZvciBhbGwgb2Yg
dGhpcy4gSnVzdCBmaWd1cmVkIEnigJlkIHNlbmQgb3V0DQp0aGlzIGZzdXVpZCBjb21tYW5kIGZp
cnN0IHRvIGdldCBzb21lIGZlZWRiYWNrIGJlZm9yZSBtYWtpbmcgYW55IG1vcmUNCmNoYW5nZXMu
IFRoYW5rcyENCj4gDQo+IENoZWVycywNCj4gDQo+IERhdmUuDQo+IC0tIA0KPiBEYXZlIENoaW5u
ZXINCj4gZGF2aWRAZnJvbW9yYml0LmNvbQ0KDQo=
