Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2280CEB64DC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 01:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjGSBqh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 21:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjGSBqg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 21:46:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2A91BCF
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 18:46:35 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ILee4N018382;
        Wed, 19 Jul 2023 01:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=b/KFe8GwIKIZldFzy954Atr3oW6FzGbKWUtSfFCEBDI=;
 b=2jJTJ5dalDqTua8voMlOJKSSVvfLXh4LleRBpOSfq4oBiVuElOtNnait8yNHEGs1dBbn
 PzjoyK3E0bgsZNXZBhlIMnuq2VJ29EBdMm2vexXH9YAcmcCQRHjVeU0ViOkIWugWKjmE
 vKfKhxH14i9J+1AH+mkWKEapSIxGsbFYfw7FNmT6iG9xmQ85D9Vc4YLxq4UJ/wx3eN0f
 5Hc+iGElhUcQDLAfDUTebldoEjYTZJwEahXDiol7XMJRr/VMbCMsEM2x9syBz4u0lBTB
 6PZ3kyt4jg/PNhjvb7zltgVS9l2WtuJgKYMI0+XOn1aPNAzPoocgWTKym8r+ZOLZfegl kw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run76xfsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 01:46:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36J0rfSv019203;
        Wed, 19 Jul 2023 01:46:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw6gmya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 01:46:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWehwwElf67t68EmVShVwBjF8uF94IE3XT7AzeW0dUFKV64fLhLzLRE5HX279diKnaYK8MHBRDDbSNFIOe0780tHJHMek15e27GVwbMQVS1emKJcEQDYubAXvSe6sJV3TjYQkZfa7yggaI0ko5ObRcfsk1PRh/LBmbmTjE0c0tI+WliBpJ4xr8ecg2+sth9BmQQyAohjhF64X2Wla3Mb2BdvXAY9l+BtRNafVDfBVKJ+hM7B0/EOVzwly6WDMetbVfwNGHO+GwL5gmvyyYvnRJT/5zJycMGmYONlnabOWYvo0e6yGkeeEtPnU717CVW3rsJtr32YjbO98ILylSQfKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/KFe8GwIKIZldFzy954Atr3oW6FzGbKWUtSfFCEBDI=;
 b=iHLfCOlt5ZDG/Z2TfXB4T9Vow3QXqPX8r1jckeDNQ69GgTAUKYslXfB/hVazpgeu2pqZhNacMtpBL1XMZV+W4PC8gFIk4dUTlJ5eEQI4DXjMJ4lyI2Cg3stRhjPtR+1G0m9WfILhkHgTh25KKnGVyn+WNij4Ig9gzYTHEN3qzYg3pdB+7ualHAqhBccMRXf6nNFLXCVo6HtlSWOdJLd//nnklirMuYPgJHsPUdh6FWXDwrEHcvVPf6da8cRt4n5i4NPYIqhnomYoFgVX4pegr7WZCTYAE8jQijuEZxH8LKHFOADNuGu71azgpiiUBPdI3Q2O268soMFqI2rwd2EVJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/KFe8GwIKIZldFzy954Atr3oW6FzGbKWUtSfFCEBDI=;
 b=La3eLC8+3vENfInfrMPpb4Ani4K3IEqZv+fbYn9AgLbFU13gKYTz9QN1Vx9W0AfAoB958C0QwtiIhonasP5CV1ruONccDrufZaxlDP/Qlc3qAQmcUeMRA8nXs51+l+PbYZAzCJ4XIadyO99J9QlthOVLwiJn+ZGjZlLXid0g7Zk=
Received: from BN7PR10MB2690.namprd10.prod.outlook.com (2603:10b6:406:c0::11)
 by IA0PR10MB6843.namprd10.prod.outlook.com (2603:10b6:208:435::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Wed, 19 Jul
 2023 01:46:31 +0000
Received: from BN7PR10MB2690.namprd10.prod.outlook.com
 ([fe80::b45c:cf43:ecc4:4cdf]) by BN7PR10MB2690.namprd10.prod.outlook.com
 ([fe80::b45c:cf43:ecc4:4cdf%2]) with mapi id 15.20.6588.031; Wed, 19 Jul 2023
 01:46:31 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Thread-Topic: Question: reserve log space at IO time for recover
Thread-Index: AQHZuctArDqu+2gh/UuDZaYn7kAqiq/AN2uAgAAanwA=
Date:   Wed, 19 Jul 2023 01:46:31 +0000
Message-ID: <094DE5D0-B145-4945-8A4D-370C96493028@oracle.com>
References: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
 <ZLcqF2/7ZBI44C65@dread.disaster.area>
In-Reply-To: <ZLcqF2/7ZBI44C65@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR10MB2690:EE_|IA0PR10MB6843:EE_
x-ms-office365-filtering-correlation-id: 50a36d6c-03f3-4f7a-c439-08db87f9f9cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QjxL4kCNF/81gInK/++6FNq0YnrTXwvmxLOa9QuuvZQ5KevyTt/AAqI78xCXPmh9QowtK2yrgbtvc7Hh+p+9UuczY3wJYrdJlos4JJFn/xWDxDH6oVURcgiyef0VRn5+EdklP2PmlW7cDU8XUyrtUEgcETYlWPCYXrMYfdr4rdEZWE4fIkVlEDOwQfRJJXlkETCwzDtSNfen1vJAgwH+1REBoy1UKVxdC/Pmqo3xSynkbUM7G7i6GbJx5z1HkXXxR3kbTI+GX1m1SQ1u2q+53gLLkwOp3o0BfQw00IHAfQcKgQ3GrZ/j5BPjznv0AVif/IhgnG0nwC1cliB9hYuBB+uhjWL1ddSmEUvGhJrJttXr5RPoOYczpWZafG2voW3Gcw/IDZD0m9/DIZkm2GmF18B6+ULb+QckZNbSCow7PWiyEN0ghDZtiFksHKu3y/e7KeefkwshXqXPKCVEE3p53y6mRX5vjI/i8/E8o3O9rzg5k9aPFEZ/YZtMqymd1VlUB+NJ7/iUVXXJW95XYDmk2bGm9Q9u3NwibGDduHAvszm9jNhDnFcC1h+pRkzF3Vu7iUpK6HEWEWOBYmE/1O4QhnBMeeA+cwxkj3RobNZyPsLsjgPh/DHnAGSA5/YwEgXG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR10MB2690.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199021)(41300700001)(86362001)(91956017)(54906003)(478600001)(8936002)(8676002)(71200400001)(2906002)(316002)(6916009)(66476007)(66446008)(66946007)(76116006)(64756008)(5660300002)(66556008)(4326008)(966005)(6512007)(6486002)(107886003)(38070700005)(6506007)(53546011)(38100700002)(186003)(83380400001)(33656002)(36756003)(122000001)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVA2NjhxelgwOTFEOFJVbWhaQVo3Qzh3Q3BmQm1uSGg0REtkRkVyWXQ0dGhm?=
 =?utf-8?B?QVRkTXBRVTZhRjVxQlpaRnc1NWw0V1FMNHcveEJFc1B0a3c4SExMaFFsOVRr?=
 =?utf-8?B?WVo2TjdlS1ZFQUswV09nblVBZDM4QTZ1SVRkMTdRSHdsTU1DK2Rna1dxNlNS?=
 =?utf-8?B?ZVJKYS9mUHVqNWFXMGF4NTZ2K2k5STg4S1REdzBVRzNIbEh6R09Gd29aOEZW?=
 =?utf-8?B?VEtTQTBmOGNaNnRKSWE3OUsrTElNc3hlamYrM1Bya2NsWkEwMzliYllXSmxt?=
 =?utf-8?B?b05qenJ5YjdZSllvRnRpSC9Uc1h3WUlXdFN4OWY4eFJNMm1kYS9MdjZocG9u?=
 =?utf-8?B?STI3QWRXQU5PWkZ4RDlpL3ZSbzRUUC9QSUVRc0Nrd1lmdkcrNDZ4ZWs3R1lo?=
 =?utf-8?B?NDk3d01scW1uSHByUkgxME1rODZ5K2hWdm90bmUrSHN4dmNYUjg0SFJjbFlh?=
 =?utf-8?B?a2FXZUVxdUw5V3E4a0FUWDQxZVM0MWZuZm00U3d1TUQyZ1dNZEMyRTh5WERn?=
 =?utf-8?B?bjg3K011K1NtSEswME9oT0xVT01TbU50N2RrM3JTUCtjWm4wUTdCdCsrVEpv?=
 =?utf-8?B?djM0MHZjOFV5V2FYK3IyQTdIQnJ2dUoyaUovSFEyLzNFN1VIWForYXZKUlY3?=
 =?utf-8?B?THAyeWE0NEtqME5MMHl0cTFaZHlEdWU1SC9yYUVObG11ZUxvTWNRVS9oNFpv?=
 =?utf-8?B?Mk4yV3hnekR2YzB2ZldxVUx5ZHhkbm10ZGlJNUFvREdEQnpSa1Y4WFJuYllU?=
 =?utf-8?B?YU5xZjFVZERDbXd5MEJnUDgwVUJ5dnIrWkswVVNrRHFRRDUyVWhmelRlVFFB?=
 =?utf-8?B?ZjJYWkJFYlUyTVdUZTVaamphQXcyWm1NS2hDT1BLZVlUQjhaUkVFcDhyTHk2?=
 =?utf-8?B?YzZmcnRCeXFSeU5xemM1UjFJZmNPVDBvOHVkZHhkdHo3VUJqdmNwZHlwOEpr?=
 =?utf-8?B?enFWWGFlQWVjbkI0b2Jrdk1hRGxwcVNESU5odldOVHNudjRzMUZmT0JqblQ0?=
 =?utf-8?B?TXhzdm0vRDQzOVBMckZmc1BXZHpMbnBTc29DVkJZdVc2RVVFUFVreXllckJW?=
 =?utf-8?B?Vkl2YlF0YmxqcnJQSi9WOU5sY2tJeEMzMmFRVWRWQncwWFRXVExXdW15bmI2?=
 =?utf-8?B?WEFRZElhNmVXZjhXNzlGTnhmQmE3SThsNWRWS05PaW8vRng0VWllNk1UaFBj?=
 =?utf-8?B?d3hDcERnelZvWUZIclFmQnp4LzBBY1VEUlo5TENMNTRERlBOWEgvVWpUM0Q0?=
 =?utf-8?B?TU9yaWNseDNpN1E4ckcvTVZMVEJYVUdBckd1ejRIeGdPRi9vNFdHOVAxT3Nv?=
 =?utf-8?B?NkhVRFpOVEhZbWx4dW8vZzZWWTJWQzg4cGk4RzRpYjBhMGcwa01MQWpxMmRM?=
 =?utf-8?B?WnNGYWdQeTlPa0I4QWRhODRtazJTa2hUQTA4aDE4ZU9EZzc0MVZybnppNGh0?=
 =?utf-8?B?bHlvTUZrSmUwU2ExbmZRNGhjYnNNZXZWa0JaQUFoVngvb2ViL1ozKzl3Mi9O?=
 =?utf-8?B?UC8waGJwTnNqQnE3SDRRSXE2M2I5eEVzRUNiS09vNFJwOHVTRmNqVkVua0xL?=
 =?utf-8?B?cU1ITDRMdU1UVk1QcWl2SEQ4em1DOEI0SWRiazRPbUl3cVZjL3pvOVZocXdv?=
 =?utf-8?B?SkJRVW5GQXl3ckxqSjhWSnIvMWFQUU1mSnF6OGNYMisvMmpjaWg0cEs5TlZa?=
 =?utf-8?B?SktpUWhYdjN5UFdWS1NjNDNXZFBoVno0dVhFOEt2RmR2a25EcG43emF2bEhT?=
 =?utf-8?B?Y0JqYXpZc2ZPc2JMK1dJYlM3cXhaZ2VEa2ZPcGhSdW1GQ2hCOEVVYStPdVY3?=
 =?utf-8?B?T1Q5c0wxWHlUY2RuMTg2VndYNjVocC9tb1VrYkZQdFAzazFmc0t1RWFaVTV3?=
 =?utf-8?B?WU9tRlFMdjRRTzZlZncvYkFEMUJpamN0M1Y5eHJONVlYanJvRmJ3Z1VSZjVZ?=
 =?utf-8?B?RHNLTC9GV0RiZGNyNldDb2NxWTVLa1MxZ2pEWFIvejVaZ1d1a014V0VsY05T?=
 =?utf-8?B?ZGlrMXNQWEdrQ0FZcERKZXltQXovY0JpdUtqN0J5QUswenphZ3hDR21qV21s?=
 =?utf-8?B?STZUZUI4RjJVaXVXUWh5bTA1MHdBaWYvcUVVS0RGM1hMa3RteHhPUmN0TVhx?=
 =?utf-8?B?L3c2bkhyK0FZMUFNaE9BRld5YVhic0tlYlJMTlZjdDJhY0FxTk12bFdiWHpw?=
 =?utf-8?B?S3ZvSUd4d1lsOWFxZmk4TkxRMWhRMEdiWU9INTdGWHJsSWJQdVNjcXlNaExZ?=
 =?utf-8?B?WTd4VE9jVXhnaU1tYkNkZkg3Z0J3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21EB1315150A154EAA9B39DA72AB3EDB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wyqSVbkGT9Q6PZNQGAWo7flIAw+QHpkhdCV2AOXTK5fHxDwzI5i73Ym8IbUbdO/oIZ/wlXNUl/3NX0a5lgCqmSg3cVY90+UcQje4lDHYEBou/o1ohojBfUIZSnT0q5Y5qXYxv0HlHzhBpjCrKOs4rwAh2sChm7otOAxfO1JrXqrXw2niYraj2nWve8LfjQRED57Zl8tr+z954RYoZjf18lagEhNrt6excBCtA7QYT3lU+YPVidN9w9JYkqjVznOG71lNkfiAYeVrtPJuHTZL7Q3anboPUaOhiOCWALwl7YxUp/YZYKLGvQYjDr/3L/ptKuIOD0wZDpMNm0o61q2uvD9Qg2T56BrrrMjhRGdgWUOHpKRvqU8uQ0oM6Shs0v6UFYnZMN3l8ueH8lhRIWiSWcds1tejBy5GRM1571xzckpGdw5Xv/bWZmpYkUQjHi4txO6w0xvvI3GJ/NOloV+fOLar2yaBG/QO6hWauiTIVj9tdqo/JTmWz0+1y7yTSMhDMXMg9lBNcXLtyqZDaD4avHxYc0JOuxtNvwRnnfar4oKikgmGse9u8+h6hCmjhC7ZyKR5xjqO7lTwOH1+ge1JoZ1giVNV1y0+6b2IzidM4wfGM7fc437ZaC+kLu8IsrsioM2JLy6cfz3vkx0WZbYkDV36NS/LjXjo029JLWNr/d7afENx79xv8xcTe+v/enVUTKpcQ0D/HRsoxMNuXRGfTOFEfjLMb0RBnq2TG80ZFDHNH31Rs8990F31YYdoKezTgTdmivTd0sPZHnkkz0nsdGjrP39+XbiMyhIThK6ZEzI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR10MB2690.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a36d6c-03f3-4f7a-c439-08db87f9f9cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2023 01:46:31.0339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZn1vqTgRUDmXLkvuJYmxUBZbRIh2hHTrtObdrwOA9omM8/mm/r4AGebjImyTmnJBxiF4BjahnDxl3XMHJkyJ6IEqR2xIr337NL2tMyeaNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_19,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307190015
X-Proofpoint-GUID: Pn7e8wCVlMxko2Sv1rBMoL91jSyqGsf7
X-Proofpoint-ORIG-GUID: Pn7e8wCVlMxko2Sv1rBMoL91jSyqGsf7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gSnVsIDE4LCAyMDIzLCBhdCA1OjExIFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVHVlLCBKdWwgMTgsIDIwMjMgYXQgMTA6NTc6
MzhQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gSGksDQo+PiANCj4+IEkgaGF2ZSBh
IFhGUyBtZXRhZHVtcCAod2FzIHJ1bm5pbmcgd2l0aCA0LjE0LjM1IHBsdXNzaW5nIHNvbWUgYmFj
ayBwb3J0ZWQgcGF0Y2hlcyksDQo+PiBtb3VudGluZyBpdCAobG9nIHJlY292ZXIpIGhhbmcgYXQg
bG9nIHNwYWNlIHJlc2VydmF0aW9uLiBUaGVyZSBpcyAxODE3NjAgYnl0ZXMgb24tZGlzaw0KPj4g
ZnJlZSBqb3VybmFsIHNwYWNlLCB3aGlsZSB0aGUgdHJhbnNhY3Rpb24gbmVlZHMgdG8gcmVzZXJ2
ZSAzNjA0MTYgYnl0ZXMgdG8gc3RhcnQgdGhlIHJlY292ZXJ5Lg0KPj4gVGh1cyB0aGUgbW91bnQg
aGFuZ3MgZm9yIGV2ZXIuDQo+IA0KPiBNb3N0IGxpa2VseSBzb21ldGhpbmcgd2VudCB3cm9uZyBh
dCBydW50aW1lIG9uIHRoZSA0LjE0LjM1IGtlcm5lbA0KPiBwcmlvciB0byB0aGUgY3Jhc2gsIGxl
YXZpbmcgdGhlIG9uLWRpc2sgc3RhdGUgaW4gYW4gaW1wb3NzaWJsZSB0bw0KPiByZWNvdmVyIHN0
YXRlLiBMaWtlbHkgYW4gYWNjb3VudGluZyBsZWFrIGluIGEgdHJhbnNhY3Rpb24NCj4gcmVzZXJ2
YXRpb24gc29tZXdoZXJlLCBsaWtlbHkgaW4gcGFzc2luZyB0aGUgc3BhY2UgdXNlZCBmcm9tIHRo
ZQ0KPiB0cmFuc2FjdGlvbiB0byB0aGUgQ0lMLiBXZSd2ZSBoYWQgYnVncyBpbiB0aGlzIGFyZWEg
YmVmb3JlLCB0aGV5DQo+IGV2ZW50dWFsbHkgbWFuaWZlc3QgaW4gbG9nIGhhbmdzIGxpa2UgdGhp
cyBlaXRoZXIgYXQgcnVudGltZSBvcg0KPiBkdXJpbmcgcmVjb3ZlcnkuLi4NCj4gDQo+PiBUaGF0
IGhhcHBlbnMgd2l0aCA0LjE0LjM1IGtlcm5lbCBhbmQgYWxzbyB1cHN0cmVhbQ0KPj4ga2VybmVs
ICg2LjQuMCkuDQo+IA0KPiBVcGdyYWRpbmcgdGhlIGtlcm5lbCB3b24ndCBmaXggcmVjb3Zlcnkg
LSBpdCBpcyBsaWtlbHkgdGhhdCB0aGUNCj4gam91cm5hbCBzdGF0ZSBvbiBkaXNrIGlzIGludmFs
aWQgYW5kIHNvIHRoZSBtb3VudCBjYW5ub3QgY29tcGxldGUgDQo+IA0KPj4gVGhlIGlzIHRoZSBy
ZWxhdGVkIHN0YWNrIGR1bXBpbmcgKDYuNC4wIGtlcm5lbCk6DQo+PiANCj4+IFs8MD5dIHhsb2df
Z3JhbnRfaGVhZF93YWl0KzB4YmQvMHgyMDAgW3hmc10NCj4+IFs8MD5dIHhsb2dfZ3JhbnRfaGVh
ZF9jaGVjaysweGQ5LzB4MTAwIFt4ZnNdDQo+PiBbPDA+XSB4ZnNfbG9nX3Jlc2VydmUrMHhiYy8w
eDFlMCBbeGZzXQ0KPj4gWzwwPl0geGZzX3RyYW5zX3Jlc2VydmUrMHgxMzgvMHgxNzAgW3hmc10N
Cj4+IFs8MD5dIHhmc190cmFuc19hbGxvYysweGU4LzB4MjIwIFt4ZnNdDQo+PiBbPDA+XSB4ZnNf
ZWZpX2l0ZW1fcmVjb3ZlcisweDExMC8weDI1MCBbeGZzXQ0KPj4gWzwwPl0geGxvZ19yZWNvdmVy
X3Byb2Nlc3NfaW50ZW50cy5pc3JhLjI4KzB4YmEvMHgyZDAgW3hmc10NCj4+IFs8MD5dIHhsb2df
cmVjb3Zlcl9maW5pc2grMHgzMy8weDMxMCBbeGZzXQ0KPj4gWzwwPl0geGZzX2xvZ19tb3VudF9m
aW5pc2grMHhkYi8weDE2MCBbeGZzXQ0KPj4gWzwwPl0geGZzX21vdW50ZnMrMHg1MWMvMHg5MDAg
W3hmc10NCj4+IFs8MD5dIHhmc19mc19maWxsX3N1cGVyKzB4NGI4LzB4OTQwIFt4ZnNdDQo+PiBb
PDA+XSBnZXRfdHJlZV9iZGV2KzB4MTkzLzB4MjgwDQo+PiBbPDA+XSB2ZnNfZ2V0X3RyZWUrMHgy
Ni8weGQwDQo+PiBbPDA+XSBwYXRoX21vdW50KzB4NjlkLzB4OWIwDQo+PiBbPDA+XSBkb19tb3Vu
dCsweDdkLzB4YTANCj4+IFs8MD5dIF9feDY0X3N5c19tb3VudCsweGRjLzB4MTAwDQo+PiBbPDA+
XSBkb19zeXNjYWxsXzY0KzB4M2IvMHg5MA0KPj4gWzwwPl0gZW50cnlfU1lTQ0FMTF82NF9hZnRl
cl9od2ZyYW1lKzB4NmUvMHhkOA0KPj4gDQo+PiBUaHVzIHdlIGNhbiBzYXkgNC4xNC4zNSBrZXJu
ZWwgZGlkbuKAmXQgcmVzZXJ2ZSBsb2cgc3BhY2UgYXQgSU8gdGltZSB0byBtYWtlIGxvZyByZWNv
dmVyDQo+PiBzYWZlLiBVcHN0cmVhbSBrZXJuZWwgZG9lc27igJl0IGRvIHRoYXQgZWl0aGVyIGlm
IEkgcmVhZCB0aGUgc291cmNlIGNvZGUgcmlnaHQgKEkgbWlnaHQgYmUgd3JvbmcpLg0KPiANCj4g
U3VyZSB0aGV5IGRvLg0KPiANCj4gTG9nIHNwYWNlIHVzYWdlIGlzIHdoYXQgdGhlIGdyYW50IGhl
YWRzIHRyYWNrOyB0cmFuc2FjdGlvbnMgYXJlIG5vdA0KPiBhbGxvd2VkIHRvIHN0YXJ0IGlmIHRo
ZXJlIGlzbid0IGJvdGggcmVzZXJ2ZSBhbmQgd3JpdGUgZ3JhbnQgaGVhZA0KPiBzcGFjZSBhdmFp
bGFibGUgZm9yIHRoZW0sIGFuZCB0cmFuc2FjdGlvbiByb2xscyBnZXQgaGVsZCB1bnRpbCB0aGVy
ZQ0KPiBpcyB3cml0ZSBncmFudCBzcGFjZSBhdmFpbGFibGUgZm9yIHRoZW0gKGkuZS4gdGhleSBj
YW4gYmxvY2sgaW4NCj4geGZzX3RyYW5zX3JvbGwoKSAtPiB4ZnNfdHJhbnNfcmVzZXJ2ZSgpIHdh
aXRpbmcgZm9yIHdyaXRlIGdyYW50IGhlYWQNCj4gc3BhY2UpLg0KPiANCj4gVGhlcmUgaGF2ZSBi
ZWVuIGJ1Z3MgaW4gdGhlIGdyYW50IGhlYWQgYWNjb3VudGluZyBtZWNoYW5pc21zIGluIHRoZQ0K
PiBwYXN0LCB0aGVyZSBtYXkgd2VsbCBzdGlsbCBiZSBidWdzIGluIGl0LiBCdXQgaXQgaXMgdGhl
IGdyYW50IGhlYWQNCj4gbWVjaGFuaXNtcyB0aGF0IGlzIHN1cHBvc2VkIHRvIGd1YXJhbnRlZSB0
aGVyZSBpcyBhbHdheXMgc3BhY2UgaW4NCj4gdGhlIGpvdXJuYWwgZm9yIGEgdHJhbnNhY3Rpb24g
dG8gY29tbWl0LCBhbmQgYnkgZXh0ZW5zaW9uLCBlbnN1cmUNCj4gdGhhdCB3ZSBhbHdheXMgaGF2
ZSBzcGFjZSBpbiB0aGUgam91cm5hbCBmb3IgYSB0cmFuc2FjdGlvbiB0byBiZQ0KPiBmdWxseSBy
ZWNvdmVyZWQuDQo+IA0KPj4gU28gc2hhbGwgd2UgcmVzZXJ2ZSBwcm9wZXIgYW1vdW50IG9mIGxv
ZyBzcGFjZSBhdCBJTyB0aW1lLCBjYWxsIGl0IFVuZmx1c2gtUmVzZXJ2ZSwgdG8NCj4+IGVuc3Vy
ZSBsb2cgcmVjb3Zlcnkgc2FmZT8gIFRoZSBudW1iZXIgb2YgVVIgaXMgZGV0ZXJtaW5lZCBieSBj
dXJyZW50IHVuIGZsdXNoZWQgbG9nIGl0ZW1zLg0KPj4gSXQgZ2V0cyBpbmNyZWFzZWQganVzdCBh
ZnRlciB0cmFuc2FjdGlvbiBpcyBjb21taXR0ZWQgYW5kIGdldHMgZGVjcmVhc2VkIHdoZW4gbG9n
IGl0ZW1zIGFyZQ0KPj4gZmx1c2hlZC4gV2l0aCB0aGUgVVIsIHdlIGFyZSBzYWZlIHRvIGhhdmUg
ZW5vdWdoIGxvZyBzcGFjZSBmb3IgdGhlIHRyYW5zYWN0aW9ucyB1c2VkIGJ5IGxvZw0KPj4gcmVj
b3ZlcnkuDQo+IA0KPiBUaGUgZ3JhbnQgaGVhZHMgYWxyZWFkeSB0cmFjayBsb2cgc3BhY2UgdXNh
Z2UgYW5kIHJlc2VydmF0aW9ucyBsaWtlDQo+IHRoaXMuIElmIHlvdSB3YW50IHRvIGxlYXJuIG1v
cmUgYWJvdXQgdGhlIG5pdHR5IGdyaXR0eSBkZXRhaWxzLCBsb29rDQo+IGF0IHRoaXMgcGF0Y2gg
c2V0IHRoYXQgaXMgYWltZWQgYXQgY2hhbmdpbmcgaG93IHRoZSBncmFudCBoZWFkcw0KPiB0cmFj
ayB0aGUgdXNlZC9yZXNlcnZlZCBsb2cgc3BhY2UgdG8gaW1wcm92ZSBwZXJmb3JtYW5jZToNCj4g
DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXhmcy8yMDIyMTIyMDIzMjMwOC4zNDgy
OTYwLTEtZGF2aWRAZnJvbW9yYml0LmNvbS8NCg0KVGhhbmtzIERhdmUgYSBsb3QhDQpJIHdpbGwg
bG9vayBtb3JlIGludG8gdGhlIHdyaXRlIGhlYWQgYW5kIGFib3ZlIHBhdGNoIHNldC4NCg0KSGF2
ZSBhIGdvb2QgZGF5LA0KV2VuZ2FuZw0KDQoNCg==
