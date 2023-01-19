Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D8BC004D4
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 23:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjASXsS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 18:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjASXsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 18:48:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF18917D9
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 15:47:58 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JNEMDa028488;
        Thu, 19 Jan 2023 23:47:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=OaSzwGpIMawnl9xh7R+lqwdxkaL82AejgPaUOF4HqRE=;
 b=IcDUAgYKlGdrJRe678v6DwgiRAV4vrNlQ+eH/NGg4JC8mwsZdQhLvFmKCak6j2d6Txah
 pmxuBaQ9X5rG3av3+SMinN3nNvbcwVbWqzIp/dp/gTCGj5Gw5o/xUXyZ/cEGECm5JSlQ
 E1Wwk+EDAm51roy20gA5KdVTVtlvKjsTW7tTIq2xabandc0KdBqrJrSEimBtXlgVs8z/
 xFrzQAXw94wZGzgxbVfLO9nWgL0UGQERCLIXEsbVXE08UlQH+snmLXujM6CkPxwn0oFy
 sfB8Hp1Mug14uuKoNIvjYeC5HKQpfSQkPWcmleyxPHhWe5ROJgcRO2JOza81LMHb3QDW hg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3kaakhtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 23:47:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30JLNdAN007723;
        Thu, 19 Jan 2023 23:47:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6rgdtjfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 23:47:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCxsnK7w77qQIcb9Efpc6iH0BSwN6mTOd5pg62Ywdha9pe3Tg0uwyKdmMZ0pIy2sFMi0ZNosq6wU5SpoBnkQoiOPkME9hXqf8wPoBBPXvpmwFkS8PHKmQ0dXg2pFVJXaVmEYtz4Y2LG5brF0c54AuxEfD5b69qPRby3eah8uvuPiRunUuKoRatGeqEjKtcQeLXhLVMDLGPz/WrLF7x8aVToX6G+WiSCTqduaWrG90frIwhfExnBBGWd//R6MF+NkbMeS6hGPkEJcEEeJNYK14i6mgQW9QTfc+XOnFY8PU+sqcxEljEe19u7JjP/zfNNSXtEVQCWQY/vE+dKJDdeUpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaSzwGpIMawnl9xh7R+lqwdxkaL82AejgPaUOF4HqRE=;
 b=AAD+MvpnwH9gALaaZOMzbNqjM0a0Mg0tdD9igHusfs70+kE5Jvow4rOEyvCjtVhM8gcxChOL7pQKEmqlPvq1BOk9KMWsbycNz8R3JkYXHC5blgsJTsx9VIDw07JSEtHdHQ7RdXSTdQ4K36LmeCBQkOzh0H+uO7cGW/rbI3GhPYZUl8Kzm0YJbkn8nGfOJKAZUJTjI/PzhlfwesP23YmqA5IUVtGO/qVOdS/dhnGo7PAUGHsMXDyV0/Eg5cbDfayimldXi+dirBvOoCIv6uJh/jpuAe9I1zcMPAm1mzmZAvpMl+l6PmoUY54vzSCClsBOhaSUgorjzKj7NGrp6ZL5RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaSzwGpIMawnl9xh7R+lqwdxkaL82AejgPaUOF4HqRE=;
 b=cTwVt12i9IV+GHPYpPqH/zhkcfDW+MqdUqSviqezglMVuuG2t86PssojzOYjNoDabI4L0L4adl9ISH6DM1HsNnC1R67ljYb1vn73uLasuWmV1YaEtzhlFBzUA02JmYRxo69RQhsPhQCRxn96yYej4rlzgToKC6b4bGF4EGrHkoI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5312.namprd10.prod.outlook.com (2603:10b6:5:3a9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.6; Thu, 19 Jan
 2023 23:47:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%5]) with mapi id 15.20.6002.012; Thu, 19 Jan 2023
 23:47:52 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1] xfs_admin: get/set label of mounted filesystem
Thread-Topic: [PATCH v1] xfs_admin: get/set label of mounted filesystem
Thread-Index: AQHZKsdRpGZ8FhgzfUWVbolCjpmoea6ji4cAgAF4ZICAAWdogA==
Date:   Thu, 19 Jan 2023 23:47:52 +0000
Message-ID: <531286bfd56cbd6ea26050b0a6b5e5610b463d32.camel@oracle.com>
References: <20230117223743.71899-1-catherine.hoang@oracle.com>
         <Y8dtbCouIPhNT1Zw@magnolia>
         <AAC756EC-BC4E-40B6-AD8F-40B2C275DC39@oracle.com>
In-Reply-To: <AAC756EC-BC4E-40B6-AD8F-40B2C275DC39@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|DS7PR10MB5312:EE_
x-ms-office365-filtering-correlation-id: 44f11d12-7ebc-46b6-35be-08dafa779468
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wWBbUy0XOxaiu3LeA3575r4UHYfIgNCctroVodsuXFy2RTdmSbfC3y4PFPn9HUsP/ILE0KyzVhDSgr5DMQ/8MnycO5i7kHlL8/ElIPuIVrbyl30xpTIDqQwOur19SPxopVA/3xiFGclaxeqJ8/t5qM5YYJGkSAGinglUN9ji9MqLWiCKjpYok0twPfkkeL7RHbIl2Um8/d0yhb4/PUZbuN94SjVcsA/Z5P1SEdp+HEifci9XV53MzbSts+ZTSQgSii6horm9Dd/+fqt+SsteqE8p19WhAoR4P5SkPrHcym3dm6aydKegXDJahqh4/65ow9a8tAUcRO5lfAOyUyUnbQ23jol59E5muq/fTrnegxXyh+9uSbp3sz5YwHifvwbXEqixIQSOs9dk0d+/mrEN7yrZUZi8REnVfsFZ9GVVlrr+kKPEqSj97S5S9+uUjJfbh0jW0CUuseXVmEQbc3mvwj2FGrZZ6s3rn24FWGT8YO0WfFQ1hgBcYNoT/6I6HHrP1kjt/VL0BydnFCQOeobj8RuTZY674N74W4gXv5ZZid5FGz6mD1QS/FP2hLVlZDX2xYcIvIMO3scyw2y3GKuG40j4AT/Dd74VDLXEi7FBgmw2w7LrzZJmJPh+eRSuKUVVHKPxlhMdQCbQXZIIt0mo5MNmt3hH+x15o1/aqir/1rJ/jx3lFH9X8Y9MKI2DeLjqgQUuZkE7NGF/aUXmWolO2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(186003)(6486002)(6512007)(478600001)(83380400001)(76116006)(316002)(44832011)(2906002)(122000001)(5660300002)(2616005)(66476007)(53546011)(6506007)(66446008)(66946007)(66556008)(36756003)(41300700001)(71200400001)(64756008)(86362001)(38100700002)(8676002)(4326008)(26005)(110136005)(8936002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUc5Z3h1Skt0S1FpQ3oyTmZKOWZkR2dxaUlVWHNMaHJjN2ZBTlprMi9MclNm?=
 =?utf-8?B?Yk5YNEZGdzVrWlozdm1lblBZRVlRTyt2dG5XMlRGYy93cTRxblRKZjNSbUVz?=
 =?utf-8?B?ZVc2eWdTRXBlTFRRRTA0czlLV3ZpTGhJOVl3YXpYTjR0aXRtdlNiclFLV0Ro?=
 =?utf-8?B?Y0QzdU1nQ29wZ3J2NHJXcFBiTmZWVWgyNk9uMnhiQ2JNSDR3RFBTUTBnL0JX?=
 =?utf-8?B?YkVvUy8vWmN1dGQvNTVVRitEOGxYNkdyNjVFNFpPc1pMYVZWSzZmMFRzM1pi?=
 =?utf-8?B?TGFFL0tyMmM5Z3RWczM2K0tmeVVWK3BkNkF1Ull6UDVZTlJ3VUNsU09JcXFa?=
 =?utf-8?B?ZTJyVVdCMXVJYWM2cGZyZEFCdFF2a0NJYnFUS2c3UE5nOWd4REVxU3docGFT?=
 =?utf-8?B?WDNDdGlXRmRTY0FJT0JUUHVWdGxabkYyNGgxbUlHWVpQU0hLMk4zWWV3R1V1?=
 =?utf-8?B?QkdVMFhQdXNLNlk3cmRGcGZNVExzclpMaFZFRkhSOVhEZTZ5MWdSbVplUE1E?=
 =?utf-8?B?U3Yxam51TGJnVjJCaFRadytIeUNpZXREK0V5QlJiVVd6d29LbFhyUHBqejRE?=
 =?utf-8?B?S2RNVFZjdnBoaFVvS0lia2llaWxVV3ZHNjJSZnlCUUNlamZaalFGRkZ3UlVN?=
 =?utf-8?B?TUptQys0QmlXNEh5ejlEUVBUS1AzWFQxdVNxaHVCRGpaaTRoUW16NzRtVGE4?=
 =?utf-8?B?bGxoWnhOQy90aFpXenIrcFhXdzhRYTdPcXV5ZWNOSjNxempoNm9NdE1EZEZ2?=
 =?utf-8?B?bDQvMlFOY1RLeXRYREdhZUZsT0UyZHNxUmdHdkVodjZVK3lkUE9ld1ZJaiti?=
 =?utf-8?B?eFlwOGJBYk9YOEpOOXdkaCt5Ym1hQUQybEl5SGxwdlBHQmhZN2lpOXNoTXEx?=
 =?utf-8?B?VXhCNU1MOTJZMTdtcng4dXJUeGVIMkxPV2tJWStDZElZOEJNcEE3YmJETm82?=
 =?utf-8?B?b012VC9oY1VWdzVRMnpUNW5aNHJWZDV5bzN3eDJnVGZXNFp1Ym5yT0tWdzRz?=
 =?utf-8?B?Tjd5OUlzUGR2bm11Q1hpejh2UUpucnlWK0c1Nmo0N1NkQ3Q2cCtNMERKRVBi?=
 =?utf-8?B?M1NQRk5qZG9MbXhXZ2dRZ0daVDhOeStDUmppS3loNTZva3VKYTZsT1NiTktE?=
 =?utf-8?B?L2JMdVh1SExLRnRmdUhCUXFXMXZ3RjVyVHg3bnVkMjRFNW1SeFl4UjdtL3ND?=
 =?utf-8?B?dXNVZy9CcU9oS1NNZkpOUDJVdFVMTFFHdTA3NHVUdExWKzNVOGFkdlJsa3dI?=
 =?utf-8?B?d1prRVc1S3hzYkJqUjNIbmo0ZjVtU1ZFTzRjSGdTTGtPeE9pUEFPdEQxZkw1?=
 =?utf-8?B?WnNuUDkyTXFyRUg0dHhXOEJJUkNhMjRjWEMwVEZsY3R6VlVCeWl4dnlyMUVt?=
 =?utf-8?B?aW0xeGRwY201MFpTMDE5M3A5V01WK3ZVaWJFRmlLUDZ4bGFYTlZOMmNEMGQ0?=
 =?utf-8?B?dE5Ob25kbEl5a3BqTDV2UCtaeWJOQ2pQVjJ4ZDhQM2l4NCtTTVkwcXd4cmFC?=
 =?utf-8?B?NEJKM3M0UndOckZIaXFLVzQ5Q1RJWmRBbXZPY0tXeEJBWHg2bm1adWMyVkti?=
 =?utf-8?B?RXptSlhmUi9iSVNTOW5aN20rZU1MWnJPWlZLYkhya1FYek9EbUhrL1czMzRK?=
 =?utf-8?B?UGhDUEFUek9DQXRYOXdscVJaMjNoOTl3ZHo4WnZXUWh5ZzRzdE9QeTF5VTZ1?=
 =?utf-8?B?UFB2eFB0eGlFeG9aZ0Y1WTFjMmlXWVg3cmVKTkhsUUNVUXRSM0VVSkdWdXdP?=
 =?utf-8?B?c2dCWjRBVThkdDlydXRCbVdEb1hqdFhnL2ZFaE05NHdJS1ZIMGVqRW5RS2p2?=
 =?utf-8?B?OGRRU3F0V3Fkd3Y0MC92bzhGYkVVeEdXbTh5RE90UDI0aE9MaDNrS1U0Tnp2?=
 =?utf-8?B?K0lVZUUwNnJsRmZ5ditReDYwQkpqNUR3dDQzcmg1cEJhTHZDcklaMUErK0hG?=
 =?utf-8?B?Rlc3RnpvRlhldGUvRndlRTc4K1lNUEFiL1phOGdoZFpCSE9QT2hudmxWK3JE?=
 =?utf-8?B?ams0NXI2dzhqeFJQNjJjY3A5ZXY1WXBrbU1HbTdGNGlFaEFZd24wemQ1WFFY?=
 =?utf-8?B?MHBBQ0szSFRBb0lkYnp3Y042b0tRMkN4MGptUUx4V1NQVnhwaUs1WmlUSHBL?=
 =?utf-8?B?QThndDZTbldSY3Z6cUludFlLZHovaWxrT0lqSWN5cWdWKyttTjlTYy9GV292?=
 =?utf-8?Q?xUx9ApWfp0/LPJ++h7sk57g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23242B56362AC44FBD43743FC6ACDBFF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wnADhEbbZZ8l50Se4bWYzzpHlgs+WULQBnTEqw7SHm1exexswBcotmPGk+Pp9H/wSj40f9x1R6UvHUEa3PJAZhGuuZHFKG6SUEEySCTv4jNTMqA1MUpCDksMsb9jq2dK/bCmwWP5AiEWMzDMQeed78CZGiuKx6kklikh7Exs+KHFyi6KOKPyY614M8bxSvHnTFNVc1ChD/f7e5YzQ9y6CnPUBfHqhbHrCzL0j5Qd84q3GUaZKiw2PrAluBO/ZLFDGHM5QpEWY8ys03D6DAr35ajRRCQBFwwADuSx5/cdsdDslZn+0+JKCuZJB+kGHBaysk3Y3LNbFVvOFvHVTRnKIbKSCVJccyxxnZX34M5AFAQ+AvWJ7icX3GkolWDh3XiYB1Mab08DXT9dLrNJLxVYqixOgbw5SYzIaB875ru/9Snf5PS2U43FBAZVeKfyoyumEscL9qR9elhngviyaEoeoLu6reZt3J3gwDSNTKu2qaafhS0TmYY/ODLqXztdOAeUAzYU3nYE/CVCt67+RsNiKueBI+Yy1Ga1Y3+018u8Ej4vsQLOQn+d8ay5fJh3970Iy8lr6B7pV2UpDZcAYy2lpDc7Gr/+1wcJRwflsL20gOlJyQ8sBkU4YANKaw0afDjYcWZzStwojUcwJfA616TOnqF713S1Te3aEPc57NDx777+Je3FSo8HfL2ZrpSQeJPgbJf4yajohMsMkpFXgJdWrUzSijSe6HRNacfsju3w9iUjRIvRkwXN7HvHIqgCib3/ODMtEmrRxhtvyS9g0hbH6kb5oP2NTpmclZ24rLDXJps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f11d12-7ebc-46b6-35be-08dafa779468
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 23:47:52.4099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MKDJBjoxyPqWsFqldL2VdtYkf2v4nOlQMtrSR4mW2F13Z5k2H+54IBjbF+/HiunXzjeCXInTLAe1d1ffGOzx0Q5KwMGUWfMuNdKcLdY6Ssg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5312
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_15,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190202
X-Proofpoint-GUID: j1tUaT3jUDgtDhMS8I9XPPmj7rOHaebe
X-Proofpoint-ORIG-GUID: j1tUaT3jUDgtDhMS8I9XPPmj7rOHaebe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDAyOjIxICswMDAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6
Cj4gPiBPbiBKYW4gMTcsIDIwMjMsIGF0IDc6NTQgUE0sIERhcnJpY2sgSi4gV29uZyA8ZGp3b25n
QGtlcm5lbC5vcmc+Cj4gPiB3cm90ZToKPiA+IAo+ID4gT24gVHVlLCBKYW4gMTcsIDIwMjMgYXQg
MDI6Mzc6NDNQTSAtMDgwMCwgQ2F0aGVyaW5lIEhvYW5nIHdyb3RlOgo+ID4gPiBBZGFwdCB0aGlz
IHRvb2wgdG8gY2FsbCB4ZnNfaW8gdG8gZ2V0L3NldCB0aGUgbGFiZWwgb2YgYSBtb3VudGVkCj4g
PiA+IGZpbGVzeXN0ZW0uCj4gPiA+IAo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBDYXRoZXJpbmUgSG9h
bmcgPGNhdGhlcmluZS5ob2FuZ0BvcmFjbGUuY29tPgo+ID4gPiAtLS0KPiA+ID4gZGIveGZzX2Fk
bWluLnNoIHwgOSArKysrKystLS0KPiA+ID4gMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkKPiA+ID4gCj4gPiA+IGRpZmYgLS1naXQgYS9kYi94ZnNfYWRtaW4u
c2ggYi9kYi94ZnNfYWRtaW4uc2gKPiA+ID4gaW5kZXggYjczZmIzYWQuLmNjNjUwYzQyIDEwMDc1
NQo+ID4gPiAtLS0gYS9kYi94ZnNfYWRtaW4uc2gKPiA+ID4gKysrIGIvZGIveGZzX2FkbWluLnNo
Cj4gPiA+IEBAIC0yOSw5ICsyOSwxMSBAQCBkbwo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgainCoMKg
wqDCoMKgwqBEQl9PUFRTPSREQl9PUFRTIiAtYyAndmVyc2lvbiBsb2cyJyIKPiA+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXF1aXJlX29mZmxpbmU9MQo+ID4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDs7Cj4gPiA+IC3CoMKgwqDCoMKgwqDCoGwpwqDCoMKg
wqDCoMKgREJfT1BUUz0kREJfT1BUUyIgLXIgLWMgbGFiZWwiOzsKPiA+ID4gK8KgwqDCoMKgwqDC
oMKgbCnCoMKgwqDCoMKgwqBEQl9PUFRTPSREQl9PUFRTIiAtciAtYyBsYWJlbCIKPiA+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoElPX09QVFM9JElPX09QVFMiIC1yIC1jIGxhYmVs
Igo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgOzsKPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoEwpwqDCoMKgwqDCoMKgREJfT1BUUz0kREJfT1BUUyIgLWMgJ2xhYmVsICIkT1BUQVJH
IiciCj4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXF1aXJlX29mZmxpbmU9
MQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgSU9fT1BUUz0kSU9fT1BUUyIg
LWMgJ2xhYmVsIC1zICIkT1BUQVJHIiciCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgOzsKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoE8pwqDCoMKgwqDCoMKgUkVQQUlSX09QVFM9
JFJFUEFJUl9PUFRTIiAtYyAkT1BUQVJHIgo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJlcXVpcmVfb2ZmbGluZT0xCj4gPiA+IEBAIC02OSw3ICs3MSw4IEBAIGNhc2UgJCMg
aW4KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ZmkKPiA+ID4gCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGlmIFsgLW4gIiRJT19PUFRTIiBdOyB0aGVuCj4gPiA+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGV4ZWMgeGZzX2lv
IC1wIHhmc19hZG1pbiAkSU9fT1BUUwo+ID4gPiAiJG1udHB0Igo+ID4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBldmFsIHhm
c19pbyAtcCB4ZnNfYWRtaW4gJElPX09QVFMKPiA+ID4gIiRtbnRwdCIKPiA+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXhp
dCAkPwo+ID4gCj4gPiBJJ20gY3VyaW91cywgd2h5IGRpZCB0aGlzIGNoYW5nZSBmcm9tIGV4ZWMg
dG8gZXZhbCtleGl0Pwo+IAo+IEZvciBzb21lIHJlYXNvbiBleGVjIGRvZXNu4oCZdCBjb3JyZWN0
bHkgcGFyc2UgdGhlICRJT19PUFRTIGFyZ3VtZW50cy4KPiBJIGdldCB0aGlzIGVycm9yIHdoZW4g
dXNpbmcgZXhlYzoKRGlkIHNvbWUgcG9raW5nIGFyb3VuZCB3aXRoIHRoaXMuICBJIHRoaW5rIHlv
dSBuZWVkICIkSU9fT1BUUyIgdG8gYmUgaW4KcXVvdGF0aW9ucyBsaWtlICIkbW50cHQiIGlzLiAg
T3RoZXJ3aXNlIHRoZSBwYXJhbWV0ZXJzIG9mICJsYWJlbCAtcwp0ZXN0IiBnZXQgc2VwYXJhdGVk
IGFuZCBwYXNzZWQgdG8geGZzX2lvIGluc3RlYWQgb2YgeGZzX2FkbWluLiAgSXQKZG9lc250IGNv
bXBsYWluIGFib3V0IC1zLCB3aGljaCBpdCBpbnRlcnByZXRzIGFzIHN5bmMsIGFuZCAidGVzdCIK
YmVjb21lcyB0aGUgbW91bnQgcG9pbnQsIHdoaWNoIG9mIGNvdXJzZSBkb2VzIG5vdCBleGlzdC4K
Ckl0IGRvZXNudCBsb29rIGxpa2UgeW91ciBVVUlEIHNldCBoYXMgbWVyZ2VkLMKgd2hpY2ggaXMg
d2hlcmUgdGhlIGFib3ZlCmxpbmUgb2YgY29kZSBmaXJzdCBhcHBlYXJzLiBBbmQgaXQgbG9va3Mg
bGlrZSB0aGlzIHBhdGNoIGNhbm5vdCBhcHBseQpjbGVhbmx5IHdpdGhvdXQgaXQuICBTbyBJIHRo
aW5rIHRoZSBjbGVhbmVzdCBzb2x1dGlvbiBtaWdodCBiZSB0byBmaXgKdGhlIHF1b3RhdGlvbnMg
aW4gInhmc19pbzogYWRkIGZzdXVpZCBjb21tYW5kIiwgYW5kIHRoZW4gYWRkIHRoaXMgcGF0Y2gK
dG8gdGhhdCBzZXQuICBNYXliZSBqdXN0IGFkYXB0IHRoZSBzZXJpZXMgdGl0bGUgdG8gInhmc3By
b2dzOiBnZXQgVVVJRAphbmQgbGFiZWwgb2YgbW91bnRlZCBmaWxlc3lzdGVtcyIuCgpPdGhlcndp
c2UgdGhlIHNldCBpcyBsb29raW5nIHJlYWxseSBnb29kIDotKQpBbGxpc29uCgo+IAo+ICMgeGZz
X2FkbWluIC1MIHRlc3QgL2Rldi9zZGEyCj4gdGVzdCc6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3Rv
cnkKPiA+IAo+ID4gT3RoZXJ3aXNlLCB0aGlzIGxvb2tzIGdvb2QgdG8gbWUuCj4gPiAKPiA+IC0t
RAo+ID4gCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGZpCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZmkKPiA+ID4gCj4g
PiA+IC0tIAo+ID4gPiAyLjI1LjEKPiA+ID4gCj4gCgo=
