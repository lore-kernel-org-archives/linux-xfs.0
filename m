Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930F0EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 22:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjFPWxy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 18:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjFPWxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2023 18:53:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2839735AE
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 15:53:51 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35GLSdT1004411;
        Fri, 16 Jun 2023 22:53:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=BHdwaHjjx+6M35Mxd5ivXV0X0eZb1fqmdyHdz+8YfZE=;
 b=0OJXggdZ9FiKSLN+9GiuSr/e+pWl0/Sbh5DCtx6pWyara14g55PjMbRvSGamUD44j8ib
 JM3ZjZ9gCEJ7doCzBYzKBvdA9FJ5bUSylleO8Ucdr4YgTg0kkXOYUkEFN/oFpol9DRBy
 AwvrrVoDm1POm7eiv9yu7fPUpSQZhsA0ARBwVQWSy62cxlpQL8gCiEJJtqodqIKrsifW
 BNv+l4E8ZYIyxBIowDN1ZZKOF2MXEkZ1TeYlHHrjaCi4FVB75OKh/Jt62OKosKUB0M0o
 OBH3pZsQywJsIpCsWa6alT46/NxME8B7rqJ6znR7zckX8uvk6Ui2fR1ZoPzIGF05vHp5 IA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fs257qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 22:53:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35GK8f9O012588;
        Fri, 16 Jun 2023 22:53:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmf1uqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 22:53:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wy08nciAGeTl2BkFaKEYciIzHp6+KYV3Ce1DFtasH07idrgi+4XAsrho342FrOLBJ/65ii1J6jF2XbrmPVkIR5ChC0z3vvFcd2r4w5jnS17lrJu0OWEdGBS5ml1d7tp+7js4+fAuIU2JLuXEmWiscvCuB/29Qaxi7wI36GBBiWvrvSjYNVC86dpFknpZ0rB7kcb5lW3k5QkMXBwaJxFIIvS9xFp8RluJzTXqNwtME9CKYNFXqAqnDTG2DFdlP7cfFnz45arkWig5tWoixQOhOe9lSaaHStfFDGhXig8/kRc77EZ2c74R+anuHyQbil8ZUQcM6NAmKhecsNceaHmWjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BHdwaHjjx+6M35Mxd5ivXV0X0eZb1fqmdyHdz+8YfZE=;
 b=LZaBvcnylR0EMB2u9XmHrfv+xWpyGSTqKN9+UorNVo12M3T+BN+6s8F2bcCD8x7BdTPRYvDyhopnpuwscUlT/U1QBX+0S0yBqIIFJWrHFy27WJrV4kC61M2+morLWXOZLCmrB1gnrChLTJD4iVP6HhTe/U1P8iEzo7vutbyJH0xyzDgbs97yzydI7S6Zq1TwZ9soBoXf0yjcZaC6WyCManxCQV606d2UOFMfOcNCwHmUXzNF5kuY4WlnLy/Igefd/cLPDHtyF0c899fseRi31aodfOKMsG0TrayaJXa0BnnMvQQaE3Z0PeFCJ5vGp8xIWuvQe33GJvUYa9rh0ru6Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHdwaHjjx+6M35Mxd5ivXV0X0eZb1fqmdyHdz+8YfZE=;
 b=pQAuJ1pL74TSkK2sX9MX5HpWcc+wnOqW6T/1rdeo5QO7M/OVymeHkROCwjGCqctZuV92G3HwXHcY25HQQE9z1TvGoCnf4e23zr4FnCBIQYl6cMBzpX7W3L4FuHce2c+V0OurkSfffGs8bY2Ie9CD0AmKmEvVkCt3VfmvBZ8Nx4E=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by PH0PR10MB5732.namprd10.prod.outlook.com (2603:10b6:510:14e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 22:53:45 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1%7]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 22:53:45 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Topic: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Index: AQHZnyqiJVfvBqN/ZEat6GgWNoCKPa+MalAAgAAE8YCAAASYgIAACrOAgAAGmoCAAAT8gIAAB3wAgAAGxICAAD73gIAANOaAgACpiwCAAE/wAIAABrIA
Date:   Fri, 16 Jun 2023 22:53:45 +0000
Message-ID: <B8A59418-0745-4168-984F-5F9B38701C1E@oracle.com>
References: <ZIuNV8UqlOFmUmOY@dread.disaster.area>
 <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
 <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
 <ZIuftY4gKcjygvYv@dread.disaster.area>
 <396ACF78-518E-432A-9016-B2EAFD800B7C@oracle.com>
 <ZIuqKv58eTQL/Iij@dread.disaster.area>
 <903FC127-8564-4F12-86E8-0FF5A5A87E2E@oracle.com>
 <46BB02A0-DCEA-4FD6-9E30-A55480F16355@oracle.com>
 <ZIwRCczAhdwlt795@dread.disaster.area>
 <B7796875-650A-4EC5-8977-2016C24C5824@oracle.com>
 <ZIziUAhl71xz305l@dread.disaster.area>
In-Reply-To: <ZIziUAhl71xz305l@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|PH0PR10MB5732:EE_
x-ms-office365-filtering-correlation-id: 34ca153e-d4c0-4bff-48b9-08db6ebc8a46
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XHXQBj8Jcd8E/Tn4/nYCEt0xDlNU/W/82YSeaQUd6NKTxYaOJ8IzHf0KiB34YmKR0VZFmKdOhQaoMm4zFBMsO3RsOLzLmwFLHs+pN+pmNg9VfKd2IdwDVejVOxs5O9Rc9Fi+eWsBw9SZSAJNXan6oWBz1/XPWH8DD7MCY5fzMEpdlamzmdlbQEIIUAVJcnRlUOwNXrQBMYB9BGBzdIx9jBkhHCtyXn4kiAEnSfJutrkxZE0ZvdWGlvpIR3Aith4TNnKnBDn+vMh9Vnroeo5k94O4gZFc4yySFTXevQpnaNo7T1SRw4HNP/TK4m6yHwdyLKvya1w8iPuh4+fwpS/WbS30ZYgW4p1VHMj0z5gc7Ozy/4pzmk6prhnLo0t0qFF95S77r0Uf68AJRMRxkY9Zl3uirSm2gVPCZ8EwboJUf9j3smC+gWQ2/YSjgKu40RHPb6dWy7dN43cjzU7k0PlGlZSkf1lJwAcbsAvN6FyC/83Wjkm5V/fk4qpAYvEsutNf0CAZ3O9Dj4MtNrJHt0U2z38fEGUmcFch88TNLzIL0BU9QdR9tRxQ7OISi24KiSdTuDheA3RjbfCWNO9q09HCRMMKDz0hZp4MCmumxJxfdC38dOAC8ZJuL0ZAu7TOcH91hYpzQs95vxT+Rf0g9w94Ig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199021)(26005)(83380400001)(5660300002)(2616005)(122000001)(53546011)(186003)(6506007)(2906002)(38100700002)(6512007)(478600001)(38070700005)(66446008)(71200400001)(66946007)(6486002)(66556008)(66476007)(316002)(33656002)(6916009)(8936002)(8676002)(41300700001)(64756008)(86362001)(76116006)(36756003)(4326008)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L29yZFRpcG95ZHg3QjhOUVMvVm92eDlhbFV6MzJid3EvQlo4bk9FUVE2amFj?=
 =?utf-8?B?dTlyam1OWWdGRHhEWDBIK3hWQTBSY1RETmpNY0JQWGMwS3A1QnhXNEUybnUr?=
 =?utf-8?B?Nkw1N1d2cFRBdWozV0pOZ3l2R2dma0dhZGJVcGx2b2FYeFNLR3FDZlJaOVpV?=
 =?utf-8?B?aTNuN2lHQ2FEWS9LLzBERWR3SFlsYjFxUC9pN0pHalpFcXlZYVlCeW5UekR2?=
 =?utf-8?B?ZGNBOHBYaU5FekFUKytWaVNCSGhEWHRrKzBmZG1ORkJ4ZXNTWVNPcmlTbmE2?=
 =?utf-8?B?SXlEVk9DVE1pdy96SkxDQzdUZHZCRWRwdGxzK0huMHlvYnI4M3ZYWEJUQ1FU?=
 =?utf-8?B?VzAwc3FjOE9kdi9IQXZoSEdiMzhmeUxPSTR4dlgyelJjdWhsSkNQejIxOUlu?=
 =?utf-8?B?dlRITXRmTXBqRzJqby90MFM3Uk1IVkM0d3BVS3hYY1VHWDdTYzZrU2lPUHd2?=
 =?utf-8?B?dWNJaGZ5bjlaTTBEcHNiTytwMy9pWitSd2YwRmRoMTFiVjZKSm9nNmx4eTZz?=
 =?utf-8?B?eVBlOVRudXY5NFZhT00rd3E5VEUzU0F0SjR5RXduS2hVY1BoZWd5UmNhS2hJ?=
 =?utf-8?B?YUdhZnhhQ3RmU1dwYUtSZzF5dEdnUzdIZ3RwdHFyVVRuNVpWSFlzNkh0Y2Vk?=
 =?utf-8?B?aTA1cTV0YTdNc0lXSEtwRXp2WFRRNWxqOS9hbytDTFZUWUZLRTdiRmNTcm5V?=
 =?utf-8?B?NU9aNC9GaUxPUWVUVHZRZTJpSmFCbmp4SHpSdEpSUFlqZ0x0UlRqSjF5SzNT?=
 =?utf-8?B?L3JibDM2Z09BbTRhTk9yMWY5akdWV0hyZlljakNmMVlYSHZuOUsvMEk2T2dT?=
 =?utf-8?B?Vk5qMGlhVml6V2hjVVQ1TlpGVHc3aFppSHgxalRpdnMyMmJWR1dWRW1nbllQ?=
 =?utf-8?B?SzR3QWtEYk9HWXp4ZzJBdXR1V0NFQWZMZHNpblNVZ1lwNHlSL2xmSHhiQW9y?=
 =?utf-8?B?M3FoRVZrSFBWUWg5WS9GQ0VxOWhFL01ubW16RUs5NXplU2d3OGJRNjFTRWYw?=
 =?utf-8?B?QVU2elRpUUYyVTZhSzJuK0luK0dkeXpRRThFN2FYNThKblhNZTFuUzU2aGZr?=
 =?utf-8?B?WG9DdkgrWXBRY0VnQU51ZXRMSGlQQ0pJbCtlRjFocWJCTFpkN013eU1xdFVw?=
 =?utf-8?B?TW5tcmxFR0xxS2VxbWN4b3VYRkVvQTBYc0VNWWprejFQYTU0R211QVQybjhB?=
 =?utf-8?B?R2VOdzhYUERFQmdvSFhQYTU1WU5qWlNzdnFYbVl3RzFVTlNwUjBMRzFqNXZJ?=
 =?utf-8?B?R1E3VU44MVU4SDdWc1ByWERORUZ5U3EwbWIyejhlaEY3Zjg5eDR6M3dzQm42?=
 =?utf-8?B?ZjJkb2xIbHhzWGV2NDBZdjNsejBpU01TL3hhdkZLU21qQXdKS1MxdGEwR3ln?=
 =?utf-8?B?YzU2UmpQTnRIS2oybUQyYXhoOHJac1NkY0RKQXFvTEZvMG51VXd1RENXazZx?=
 =?utf-8?B?RFFjM1owUjBhcmxieHVOVG94b2ljN1dIdSt4ZUFYazE3MHZnU2RJR1B4SHpl?=
 =?utf-8?B?RzN3Lzl3bS93Z0V1cHJwRVM5aWd4WGY5YmhULzc2a3F4dzIyUFdmUTV5Y3ZS?=
 =?utf-8?B?Y0xpaFdTMFlKZXR3aWllN2RjUkZ2UDdvOUdSdktKS2JDT25GSzdrQUxWcG1R?=
 =?utf-8?B?UklOaGdPbStzUzVrODMyZW5BQjViV2o5UDhpQWUwUE1pMUFtNjVaTWJUSksz?=
 =?utf-8?B?cGJsU1FlZjVjdmZQVlFhalZtbnhIZUtNM0VCcjN3Y1hwY29xTy9xUkUxVENv?=
 =?utf-8?B?UFcvVjdqSUZZM2xNQy9vdnRMNERMZ2lHQUpxK2o0MVpNN3ZmR0JSaVI1b210?=
 =?utf-8?B?ekFKbm5iMFJ3bCtSMGh6TEZvZVpmZ09VQnJZTzFZNlVwSVBRL2RpSnFBMzh2?=
 =?utf-8?B?Mnoza1gybHUzcG80Z1FwM2dwNUdiWEdwUWo2anpna2dZenZVM3lPd2VybVdz?=
 =?utf-8?B?ekl3SjUwcDNhSGl0OXU3M1lXSHRJMEw3b3dBT1ljRmE3eDhUYmhzQVhKMmpH?=
 =?utf-8?B?c2Q0RUlGRWtIQVZkZFdMbE9CUUduaWx5dEV0MjI0NDRLbzViRm44akRJNisv?=
 =?utf-8?B?NDg2Sk5DZElVb1I0RUtSbzU1d0N3REVpbXIrOWFMeTkrMGcwTkwxek1PcWov?=
 =?utf-8?B?ZDF2bm5uYlo2eld4SVV4dThRZXdlRUFSenlvakVCN1U1RFc5amdjTG85dnRD?=
 =?utf-8?B?MXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <160304F18ED7C14CA1B17076E85AD03C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UrR9+Gseo2schNytowdlV+vwnNiRtCAfCBtOHN8zKoJCH1RkX+9bo0+5H01vaM3ehNj4wz1RZmRbbOp1XWD4ge0ROIvKZagv+OMqocSxQ0mGPPPuXmCEQ2JmfYeFd9/+96hhj93jQDengPj+cUuVgVdr/sUmUKPSg8+dIxjAYWeicFG9lNQXUI72h588tgji37yC5THfYGJLJLqBhAPTJiIKhHL43rpKaVcJjL18BX7lAnz+ZYCLFkTg2yWUA5NQfdVVkkdPA+Y4y8tj391NsRr38fhh35p1YBc3G0d6ARYrzR5gIlcl+cvbt/dSlaQu5Cgzf9ork7FTziUucbNGozQhMgYp4GQzv5Xmh25ZqC9vnsC6HQrT6hZREv5KTQPJWW1m7ApkuJO+LFfcO8MAPxG2yFQe5emhwYLamX23hW5GW9s7K3aDHTC1MWm+rawPPfvssXa9QGuAeMwixbxfm0LRjgfGZY9jPg3/+pIwp8bJ8R2aIgnQjdd47GWT4kfYOi3kVvzLJqhkRtq63HrUKS55+bSgFyq7YYNSD8OxeUFLmjnwlVSAkCFkuEdhaE5S4cSaqVfqVViYPpw20kUg5vGulIMwJLHilbOgS7nRpYCt1+GXd4WrEuqscEhaXAFUfDEJzBzta5XHJTfH9N5BwRYrol/pP/LBfy7zvrEEwTSSr6ld6SeNqkWhf8b00tEg8sxuZB3KzF1pmhoLjY47Hv9w6qiO80uunNxTepNG3M0MCyqzo4Z++JJbCP5dEXcgfWgaPn1khU98cC3pIkDy00geDStMnTscjwChDf8drlWIMja5XaAsCMrWjt2ugJ9NM5EyocPpAgJd8MnY0Yx3hQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34ca153e-d4c0-4bff-48b9-08db6ebc8a46
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 22:53:45.5554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L1pA4ecN5IVXfh2lUsJlFz3JNh+EaHioOIyrO0nB5f7KA7MLC5xb47wZ5UlKlp2fV1487tMheadHe8rj5/3KbbYbeMCfqm4WwrYcSKGg7UM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-16_14,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306160208
X-Proofpoint-GUID: aL16W0E8fVXQbhwUYYvgToej6zy9cYM7
X-Proofpoint-ORIG-GUID: aL16W0E8fVXQbhwUYYvgToej6zy9cYM7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gSnVuIDE2LCAyMDIzLCBhdCAzOjI5IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gRnJpLCBKdW4gMTYsIDIwMjMgYXQgMDU6NDM6
NDJQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+IE9uIEp1biAxNiwgMjAyMywgYXQg
MTI6MzYgQU0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+Pj4g
T24gRnJpLCBKdW4gMTYsIDIwMjMgYXQgMDQ6Mjc6MzJBTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdy
b3RlOg0KPj4+Pj4gT24gSnVuIDE1LCAyMDIzLCBhdCA1OjQyIFBNLCBXZW5nYW5nIFdhbmcgPHdl
bi5nYW5nLndhbmdAb3JhY2xlLmNvbT4gd3JvdGU6DQo+Pj4+Pj4gT24gSnVuIDE1LCAyMDIzLCBh
dCA1OjE3IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOg0KPj4+
Pj4+IENhbiB5b3UgcGxlYXNlIHBvc3QgdGhhdCBkZWJ1ZyBhbmQgYW5hbHlzaXMsIHJhdGhlciB0
aGFuIGp1c3QgYQ0KPj4+Pj4+IHN0YWNrIHRyYWNlIHRoYXQgaXMgY29tcGxldGVseSBsYWNraW5n
IGluIGNvbnRleHQ/IE5vdGhpbmcgY2FuIGJlDQo+Pj4+Pj4gaW5mZXJyZWQgZnJvbSBhIHN0YWNr
IHRyYWNlLCBhbmQgd2hhdCB5b3UgYXJlIHNheWluZyBpcyBvY2N1cnJpbmcNCj4+Pj4+PiBkb2Vz
IG5vdCBtYXRjaCB3aGF0IHRoZSBjb2RlIHNob3VsZCBhY3R1YWxseSBiZSBkb2luZy4gU28gSSBu
ZWVkIHRvDQo+Pj4+Pj4gYWN0dWFsbHkgbG9vayBhdCB3aGF0IGlzIGhhcHBlbmluZyBpbiBkZXRh
aWwgdG8gd29yayBvdXQgd2hlcmUgdGhpcw0KPj4+Pj4+IG1pc21hdGNoIGlzIGNvbWluZyBmcm9t
Li4uLg0KPj4+Pj4gDQo+Pj4+PiBUaGUgZGVidWcgcGF0Y2ggd2FzIGJhc2VkIG9uIG15IHByZXZp
b3VzIHBhdGNoLCBJIHdpbGwgcmV3b3JrIHRoZSBkZWJ1ZyBwYXRjaA0KPj4+Pj4gYmFzaW5nIG9u
IHlvdXJzLiBJIHdpbGwgc2hhcmUgeW91IHRoZSBkZWJ1ZyBwYXRjaCwgb3V0cHV0IGFuZCBteSBh
bmFseXNpcyBsYXRlci4gDQo+Pj4+PiANCj4+Pj4gDQo+Pj4+IE15IGFuYWx5c2lzOg0KPj4+PiBJ
dOKAmXMgcHJvYmxlbSBvZiBkb3VibGUgZnJlZS4gVGhlIGZpcnN0IGZyZWUgaXMgZnJvbSB4ZnNf
ZWZpX2l0ZW1fcmVjb3ZlcigpLCB0aGUNCj4+Pj4gc2Vjb25kIGZyZWUgaXMgZnJvbSB4ZnNfZXh0
ZW50X2ZyZWVfZmluaXNoX2l0ZW0oKS4NCj4+Pj4gRGF2ZeKAmXMgcGF0Y2ggbWFrZXMgaXQgcG9z
c2libGUgdGhhdCB4ZnNfdHJhbnNfZnJlZV9leHRlbnQoKSByZXR1cm5zIC1FQUdBSU4uDQo+Pj4+
IFRoZSBkb3VibGUgZnJlZSBwcm9ibGVtIGJlZ2lucyB3aGVuIHRoZSAtRUFHQUlOIGlzIHJldHVy
bmVkLg0KPj4+PiANCj4+Pj4gMS4gLUVBR0FJTiByZXR1cm5lZCBieSB4ZnNfdHJhbnNfZnJlZV9l
eHRlbnQoKSwgIHNlZSBsaW5lIDUgaW4gdGhlIGRlYnVnIG91dHB1dC4NCj4+Pj4gMi4gYWNjb3Jk
aW5nIHRvIC1FQUdBSU4sIHhmc19mcmVlX2V4dGVudF9sYXRlcigpIGlzIGNhbGxlZCB0byBjcmVh
dGUgYSBkZWZlcnJlZA0KPj4+PiAgb3BlcmF0aW9uIG9mIHR5cGUgWEZTX0RFRkVSX09QU19UWVBF
X0FHRkxfRlJFRSAgdG8gY3VycmVudCB0cmFuc2FjdGlvbi4NCj4+Pj4gIHNlZSBsaW5lIDYuDQo+
Pj4+IDMuIE5ldyBFRkkgKHhmc19lZmlfbG9nX2l0ZW0pIGlzIGNyZWF0ZWQgYW5kIGF0dGFjaGVk
IHRvIGN1cnJlbnQgdHJhbnNhY3Rpb24uDQo+Pj4+ICBBbmQgdGhlIGRlZmVycmVkIG9wdGlvbnMg
aXMgbW92ZWQgdG8gY2FwdHVyZV9saXN0LiBzZWUgbGluZSA5LiBUaGUgY2FsbCBwYXRoIGlzOg0K
Pj4+PiAgeGZzX2VmaV9pdGVtX3JlY292ZXIoKQ0KPj4+PiAgICB4ZnNfZGVmZXJfb3BzX2NhcHR1
cmVfYW5kX2NvbW1pdCh0cCwgY2FwdHVyZV9saXN0KQ0KPj4+PiAgICAgIHhmc19kZWZlcl9vcHNf
Y2FwdHVyZSgpDQo+Pj4+ICAgICAgICB4ZnNfZGVmZXJfY3JlYXRlX2ludGVudHMoKQ0KPj4+PiAg
ICAgICAgICB4ZnNfZGVmZXJfY3JlYXRlX2ludGVudCgpDQo+Pj4+ICAgICAgICAgICAgb3BzLT5j
cmVhdGVfaW50ZW50KCkg4oCUPiAgIHhmc19leHRlbnRfZnJlZV9jcmVhdGVfaW50ZW50KCkNCj4+
Pj4gNC4gVGhlIG5ldyBFRkkgaXMgY29tbWl0dGVkIHdpdGggY3VycmVudCB0cmFuc2FjdGlvbi4g
c2VlIGxpbmUgMTAuDQo+Pj4+IDUuIFRoZSBtb3VudCBwcm9jZXNzIChsb2cgcmVjb3ZlcikgY29u
dGludWUgdG8gd29yayB3aXRoIG90aGVyIGludGVudHMuIGxpbmUgMTEgYW5kIGxpbmUgMTIuDQo+
Pj4+IDYuIFRoZSBjb21taXR0ZWQgbmV3IEVGSSB3YXMgYWRkZWQgdG8gQUlMIGFmdGVyIGxvZyBm
bHVzaCBieSBhIHBhcmFsbGVsIHRocmVhZC4gbGluZSAyMC4NCj4+Pj4gNy4gVGhlIG1vdW50IHBy
b2Nlc3MgKGxvZyByZWNvdmVyKSBjb250aW51ZSB3b3JrIHdpdGggb3RoZXIgaW50ZW50cy4gbGlu
ZSAyMSB0byBsaW5lIDM1Lg0KPj4+PiA4LiBUaGUgbW91bnQgcHJvY2VzcyAobG9nIHJlY292ZXIp
IGNvbWUgdG8gcHJvY2VzcyB0aGUgbmV3IEVGSSB0aGF0IHdhcyBhZGRlZCB0byBBSUwNCj4+Pj4g
IGF0IHN0ZXAgNi4gSSBndWVzcyB0aGUgcHJldmlvdXMgbG9nIGl0ZW1zLCB3aGljaCB3ZXJlIGFk
ZGVkIHRvIEFJTCB0b2dldGhlciB3aXRoIHRoZQ0KPj4+PiAgRUZJLCB3ZXJlIHJlbW92ZWQgYnkg
eGZzYWlsZCAoSSBkaWRu4oCZdCBsb2cgdGhhdCkgc28gdGhleSBkaWRu4oCZdCBhcHBlYXIgaW4g
dGhlIEFJTCBpbnRlbnRzDQo+Pj4+ICBpdGVyYXRpb24gaW4geGxvZ19yZWNvdmVyX3Byb2Nlc3Nf
aW50ZW50cygpLiAgc2VlIGxpbmUgMzYuDQo+Pj4+IDkuIFRoZSBuZXcgRUZJIHJlY29yZCAoMHgy
NTQ0MWNhLCAweDMwKSBpcyBmcmVlZCBieSB4ZnNfZWZpX2l0ZW1fcmVjb3ZlcigpLiBcDQo+Pj4+
ICBUaGF04oCZcyB0aGUgZmlyc3QgZnJlZS4gc2VlIGxpbmUgMzcuDQo+Pj4+IDEwLiBUaGUgQUlM
IGludGVudHMgaXRlcmF0aW9uIGlzIGRvbmUuIEl0IGJlZ2lucyB0byBwcm9jZXNzIHRoZSBjYXB0
dXJlX2xpc3QuDQo+Pj4+IDExLiBpdCBjb21lcyB0byB0aGUgWEZTX0RFRkVSX09QU19UWVBFX0FH
RkxfRlJFRSBkZWZlcnJlZCBvcGVyYXRpb24gd2hpY2ggaXMNCj4+Pj4gICBhZGRlZCBpbiBzdGVw
IDMuIHhmc19leHRlbnRfZnJlZV9maW5pc2hfaXRlbSgpIGlzIGNhbGxlZCB0byBmcmVlICgybmQg
ZnJlZSkgKDB4MjU0NDFjYSwgMHgzMCkNCj4+Pj4gICBhbmQgaXQgZmFpbGVkIGJlY2F1c2UgKDB4
MjU0NDFjYSwgMHgzMCkgd2FzIGFscmVhZHkgZnJlZWQgYXQgc3RlcCA5LiBzZWUgbGluZSA0My4N
Cj4+Pj4gICBTbywgaXTigJlzIGEgZG91YmxlIGZyZWUgaXNzdWUuDQo+Pj4gDQo+Pj4gWWVzLCB0
aGlzIG11Y2ggSSB1bmRlcnN0YW5kLg0KPj4+IA0KPj4+IEFzIEkndmUgYmVlbiBzYXlpbmcgYWxs
IGFsb25nLCB0aGVyZSdzIHNvbWV0aGluZyBlbHNlIHdyb25nIGhlcmUsDQo+Pj4gYmVjYXVzZSB3
ZSBzaG91bGQgbmV2ZXIgZW5jb3VudGVyIHRoYXQgbmV3IEVGSSBpbiB0aGUgcmVjb3ZlcnkgbG9v
cC4NCj4+PiBUaGUgcmVjb3ZlcnkgbG9vcCBzaG91bGQgc2VlIHNvbWUgb3RoZXIgdHlwZSBvZiBp
dGVtIGFuZCBhYm9ydA0KPj4+IGJlZm9yZSBpdCBzZWVzIHRoYXQgRUZJLg0KPj4gDQo+PiBNYXli
ZSB5b3UgYXJlIHJpZ2h0LiBCdXQgaGVyZSBpcyBteSBjb25jZXJuLCBpdHMgcG9zc2libGUgdGhh
dDoNCj4+IEV2ZW4gdGhlIHdlcmUgb3RoZXIgdHlwZXMgb2YgaXRlbXMgcGxhY2VkIGluIEFJTCBi
ZWZvcmUgdGhhdCBuZXcgRUZJDQo+PiAoYWZ0ZXIgeW91ciBjaGFuZ2UgbGlzdF9hZGQoKSAtPiBs
aXN0X2FkZF90YWlsKCkpLCBzdXBwb3NlIHRoaXMgc2NlbmFyaW86DQo+PiANCj4+ICMgc3VwcG9z
ZSB0aGVyZSB3ZXJlIG1hbnkgbG9nIGludGVudHMgYWZ0ZXIgdGhlIE9yaWdpbmFsIEVGSSAod2hp
Y2ggbmVlZHMgcmV0cnkpDQo+PiAgIHRvIHByb2Nlc3MuIA0KPj4gMS4gIE5vbiBFRkkgdHlwZSBs
b2cgaXRlbXMgKHNheSBJdGVtIEEgdG8gSXRlbSBDKSB3ZXJlIGFkZGVkIHRvIEFJTC4NCj4+IDIu
ICBUaGF0IG5ldyBFRkkgbG9nIGl0ZW0sIEl0ZW0gRCB3YXMgYWRkZWQgdG8gQUlMLg0KPj4gMy4g
IE5vdyB0aGUgcmVjb3ZlcnkgcHJvY2VzcyB0aGUgcmVtYWluaW5nIGxvZyBpbnRlbnRzLiBpdCB0
YWtlcyBsb25nIGVub3VnaA0KPj4gICAgIHRvIGxldCBzdGVwIDQgaGFwcGVuLiANCj4+IDQuICBE
dXJpbmcgdGhlIHRpbWUgdGhhdCB0aGUgbW91bnQgKGxvZyByZWNvdmVyKSBwcm9jZXNzIHdhcyBw
cm9jZXNzaW5nIHRoZQ0KPj4gICAgIHJlbWFpbmluZyBpbnRlbnRzIChzdXBwb3NlIHRoYXQgbmVl
ZHMgbG9uZyBlbm91Z2ggdGltZSksIEl0ZW0gQSwgSXRlbSBCDQo+PiAgICAgYW5kIEl0ZW0gQyAo
b24gQUlMKSB3ZXJlIHByb2Nlc3NlZCBieSB4ZnNfYWlsZCAoaW9wX3B1c2goKSkgYW5kIHRoZW0g
d2FzDQo+PiAgICAgcmVtb3ZlZCBmcm9tIEFJTCBsYXRlci4gIFBvc3NpYmxlPw0KPj4gNS4gIElu
IHRoZSByZWNvdmVyeSBpbnRlbnRzIGxvb3AsIGl0IGNvbWVzIHRvIHRoZSBmaXJzdCBuZXcgbG9n
IGl0ZW0sIHRoYXQgaXMgSXRlbSBELA0KPj4gICAgIHRoZSBuZXcgRUZJLiAgKEl0ZW0gQSB0byBJ
dGVtIEMgZGlkbuKAmXQgY29tZSBiZWZvcmUgSXRlbSBEIGJlY2F1c2UgdGhleSB3ZXJlDQo+PiAg
ICAgcmVtb3ZlZCBpbiBzdGVwIDQpLg0KPj4gNi4gIHRoZSByZWNvcmRzIGluIHRoZSBuZXcgRUZJ
IHdhcyBmcmVlZCBieSB4ZnNfZWZpX2l0ZW1fcmVjb3ZlcigpDQo+PiA3LiAgdGhlIHNhbWUgcmVj
b3JkcyBpbiB0aGUgc2FtZSBuZXcgRUZJIHdhcyBmcmVlZCBieSB4ZnNfZXh0ZW50X2ZyZWVfZmlu
aXNoX2l0ZW0oKQ0KPj4gICAgIGFnYWluLg0KPj4gDQo+PiBJZiBhYm92ZSBpcyBwb3NzaWJsZSwg
dGhlIHByb2JsZW0gc3RpbGwgZXhpc3RzIGV2ZW4geW91IG1ha2Ugc3VyZSB0aGUgbmV3IGxvZw0K
Pj4gaXRlbXMgaW4gb3JpZ2luYWwgb3JkZXIgd2hlbiB0aGV5IGFyZSBwbGFjZWQgdG8gQUlMLg0K
PiANCj4gWWVzLCBJICprbm93IHRoaXMgY2FuIGhhcHBlbiouDQo+IA0KPiBXaGF0IEkndmUgYmVl
biB0cnlpbmcgdG8gdW5kZXJzdGFuZCBpcyAqaG93IHRoZSBidWcgb2NjdXJyZWQgaW4gdGhlDQo+
IGZpcnN0IHBsYWNlKi4gDQo+IA0KPiBSb290IGNhdXNlIGFuYWx5c2lzIGNvbWVzIGZpcnN0LiBT
ZWNvbmQgaXMgY29uZmlybWluZyB0aGUgYW5hbHlzaXMNCj4gaXMgY29ycmVjdC4gT25seSB0aGVu
IGRvIHdlIHJlYWxseSBzdGFydCB0aGlua2luZyBhYm91dCBob3cgdG8gZml4DQo+IGl0IHByb3Bl
cmx5Lg0KPiANCj4gV2UgYXJlIGF0IHRoZSBzZWNvbmQgc3RlcDogSSBuZWVkICplbXBpcmljYWwg
Y29uZmlybWF0aW9uKiB0aGF0IHRoaXMNCj4gb3JkZXJpbmcgcHJvYmxlbSBpcyB0aGUgcm9vdCBj
YXVzZSBvZiB0aGUgYmVoYXZpb3VyIHRoYXQgd2FzDQo+IG9ic2VydmVkLg0KPiANCj4gU3RvcCB0
cnlpbmcgdG8gZml4IHRoZSBwcm9ibGVtIGJlZm9yZSB3ZSB1bmRlcnN0YW5kIGhvdyBpdCBoYXBw
ZW5lZCENCj4gDQo+Pj4gR28gYmFjayB0byB5b3VyIHRyYWNlLWNtZCBzaGVsbCBhbmQgY3RybC1j
IGl0LiBXYWl0IGZvciBpdCB0byBkdW1wDQo+Pj4gYWxsIHRoZSB0cmFjZSBldmVudHMgdG8gdGhl
IHRyYWNlLmRhdCBmaWxlLiBUaGVuIHJ1bjoNCj4+PiANCj4+PiAjIHRyYWNlLWNtZCByZXBvcnQg
PiB0cmFjZS50eHQNCj4+PiANCj4+PiB0aGUgdHJhY2UudHh0IGZpbGUgc2hvdWxkIGhhdmUgdGhl
IGVudGlyZSBtb3VudCB0cmFjZSBpbiBpdCwgYWxsIHRoZQ0KPj4+IHhmcyBldmVudHMsIHRoZSB0
cmFjZS1wcmludGsgb3V0cHV0IGFuZCB0aGUgY29uc29sZSBvdXRwdXQuIG5vdyB5b3UNCj4+PiBj
YW4gZmlsdGVyIGV2ZXJ5dGhpbmcgd2l0aCBncmVwLCBzZWQsIGF3aywgcHl0aG9uLCBwZXJsLCBh
bnkgd2F5IHlvdQ0KPj4+IGxpa2UuDQo+Pj4gDQo+PiANCj4+IEdvb2QgdG8ga25vdy4gV2VsbCwg
c2VlbXMgaXQgY2Fu4oCZdCB0ZWxsIHVzIHRoZSAtRUFHQUlOIHRoaW5nPyBXZSBkb27igJl0DQo+
PiBoYXZlIHRyYWNlIGV2ZW4gaW4gZXZlcnkgZnVuY3Rpb24gZm9yIGV2ZXJ5IGNhc2UuDQo+IA0K
PiBXZSBkb24ndCBuZWVkIGFuIGV4cGxpY2l0IHRyYWNlIGZvciB0aGF0LiBJZiB3ZSBoaXQgdGhh
dCBjb2RlIHBhdGgNCj4gaW4gcmVjb3ZlcnksIHdlIHdpbGwgc2VlIGEgeGZzX2JtYXBfZnJlZV9k
ZWZlcnJlZCB0cmFjZSBmb3IgYW4NCj4gZXh0ZW50IGZyb20gcmVjb3ZlcnksIGZvbGxvd2VkIGJ5
IGEgeGZzX2FsbG9jX3NpemVfYnVzeS94ZnNfYWxsb2NfbmVhcl9idXN5DQo+IGV2ZW50IGZvbGxv
d2VkIGltbWVkaWF0ZWx5IGJ5IGEgeGZzX2JtYXBfZnJlZV9kZWZlciBldmVudCBmb3IgdGhlDQo+
IGV4dGVudCB3ZSB3ZXJlIHRyeWluZyB0byBmcmVlLg0KPiANCj4gVGhhdCB0ZWxscyB1cyBhbiBF
QUdBSU4gd2FzIHJlY2VpdmVkIGFuZCB0aGUgZXh0ZW50IGZyZWUgd2FzDQo+IGRlZmVycmVkLg0K
PiANCj4gQWxsIHRoZSB0cmFjZXBvaW50cyB3ZSBuZWVkIHRvIHRlbGwgdXMgd2hhdCBpcyBoYXBw
ZW5pbmcgaW4gdGhpcw0KPiBwYXRoLCBvbmUganVzdCBuZWVkcyB0byBjb25uZWN0IHRoZSBkb3Rz
IGNvcnJlY3RseS4NCj4gDQo+Pj4gVGhlIHRyYWNlIG1ha2VzIGl0IHByZXR0eSBvYnZpb3VzIHdo
YXQgaXMgaGFwcGVuaW5nOiB0aGVyZSdzIGFuDQo+Pj4gb3JkZXJpbmcgcHJvYmxlbSBpbiBidWxr
IEFJTCBpbnNlcnRpb24uDQo+Pj4gDQo+Pj4gQ2FuIHlvdSB0ZXN0IHRoZSBwYXRjaCBiZWxvdyBv
biB0b3Agb2YgdGhlIHRocmVlIGluIHRoaXMgcGF0Y2hzZXQ/DQo+PiANCj4+IFRoaXMgbWF5YmUg
d29yayBmb3IgdGhpcyBzcGVjaWZpYyBtb3VudGluZywgYnV0IGl0IGxvb2tzIGEgYml0IHRyaWNr
eSB0byBtZS4NCj4+IFBsZWFzZSBzZWUgbXkgY29tbWVudCBhYm92ZS4gSSBtZWFudCB0aGUgYmVs
b3cgcGF0Y2ggbWF5YmUgY2FuIOKAmGZpeOKAmSB0aGUgaXNzdWUNCj4+IG9jY3VycmVkIHRvIHRo
aXMgc3BlY2lmaWMgeGZzIHZvbHVtZShtZXRhZHVtcCksIGJ1dCB3aWxsIGlzIGl0IHN1cmUgdG8g
Zml4IGFsbCBjYXNlcz8NCj4gDQo+IEkgZG9uJ3QgY2FyZSBhYm91dCAib3RoZXIgY2FzZXMiIHJp
Z2h0IG5vdy4gQWxsIEknbSB0cnlpbmcgdG8gZG8gaXMNCj4gY29uZmlybSB0aGF0IHRoaXMgaXMg
dGhlICpyb290IGNhdXNlKiBvZiAqdGhpcyBwcm9ibGVtKi4NCj4gDQo+IEkgYW0gYXdhcmUgdGhh
dCB0aGlzIGlzIGEgdGVzdCBwYXRjaCwgYW5kIHRoYXQgSSB3cm90ZSBpdCBwdXJlbHkgdG8NCj4g
Y29uZmlybSBteSBoeXBvdGhlc2lzLiBJIGFtIGF3YXJlIHRoYXQgaXQgZG9lc24ndCBmaXggZXZl
cnl0aGluZyBhbmQNCj4gSSBhbSBhd2FyZSB0aGF0IEkgYW0gbm90ICp0cnlpbmcgdG8gZml4IGV2
ZXJ5dGhpbmcqIHdpdGggaXQuIEkgbmVlZA0KPiBjb25maXJtYXRpb24gdGhhdCBteSByb290IGNh
dXNlIGFuYWx5c2lzIGlzIGNvcnJlY3QgYmVmb3JlIEkgc3BlbmQNCj4gYW55IHRpbWUgb24gd29y
a2luZyBvdXQgaG93IHRvIGZpeCB0aGUgcHJvYmxlbSBjb21wbGV0ZWx5Lg0KPiANCj4gU28sIGNh
biB5b3UgcGxlYXNlIGp1c3QgdGVzdCB0aGUgcGF0Y2ggYW5kIHNlZSBpZiB0aGUgcHJvYmxlbSBp
cw0KPiBmaXhlZD8NCg0KVGhlbiBPSywgSSB3aWxsIHRlc3QgaXQgYW5kIHJlcG9ydCBiYWNrLg0K
DQp0aGFua3MsDQp3ZW5nYW5nDQoNCg0K
