Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3106DC4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C42DB208A9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgLCTQZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:16:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25970 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726829AbgLCTQY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 14:16:24 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JFRcZ018762;
        Thu, 3 Dec 2020 11:15:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6aqfUzXiYVhpq3yN3VxvhZJBrG9RxGbqp6tOy5pnZzY=;
 b=jn6c2Xc7tE2M3aJIctordebwM023z50Xtub2b8lbG2ghkHogquf8DNuBGfOX1Ntlq2yI
 Zwr+qZniLJo1LFukCFGVX8+JbNMiwRB6vDNOKS8A01TG8Gk9Ylkr0GX0176Clw25QhJ3
 IIepsy1LZYqtFuQA5sLm6UAV6Eb4F5sXzx4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355qvk22gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 03 Dec 2020 11:15:42 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 11:15:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8cMwBuMi++qDeFo42zxtCNOrMRGVqvWGGxyiNhiDCPND/D/7LL18g9di/DTK2v6qhsrwa2zLp48bHolu7J7Jtr+YWHBaO8pqxFmgv1sSypaosZEyXYdq3MUp00uI4ampTwPPsmI8XDqEg040w3i6Lajw72mNaaQxMv/ob/xbHHbULSleZWD388Aq1mAhNuvMFfgkJhzEG+Fu8CyhizkYGn3pQvlkZnOREmxl7k/OXFUeD7EvCp8UFYPxWHZ6PmX+e08411Z+m5YGKwuD6iCk+iEv9vwf3PkrdJmzhIu4GqhsYVVEhOeMJGFVU2UCzDbi9tmgB1etlmA1dDvpx6NGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aqfUzXiYVhpq3yN3VxvhZJBrG9RxGbqp6tOy5pnZzY=;
 b=nA5/v3IOH3X7Fg0xl9LJQy6K5wxMuyeNXMpWIEeiyBb625z4EGpb1oCpwkJ7Vpp6OreSEWfNW8/i2FMq0L9110+B4zPSIcx+vHEZeC7TK/ik2Kvzcb6xGvl95PdnvUw/BjD49p41I7WyHuIwpWg6ZwTRUIxSA3rCF64Av5ZGJPjiJfI4GL3hcsTW7dWZp+oILmI/p9LANr/tnmD+37bnwD+4F5E+PLu2iSuMJ79thuSuA16kUTxgBKk7qa1oBcwDuMhKLXqXx1nHe268vb8beWFPiEBn6QyhQif65AFQBIdPf4iJkeJLOrtvP4QWySSu9xg2HOp0VrPc5YSflSYgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aqfUzXiYVhpq3yN3VxvhZJBrG9RxGbqp6tOy5pnZzY=;
 b=Ydbro6L8e5H+HikbdOyercczM5r6nwPMvukygbDYcZ0GcZQ+T2AaPIppkkqQMWy6/oWNN8q1ZN8jsGsvluOBWogdMzOmG7/0jiWhIKpzm4bj1loS6k9HqjnBJpo58lI0R8HiRYrbjfpZkxlJcr6f2WbZRnSVW0GSioSapNB2Q0Q=
Received: from DM6PR15MB2379.namprd15.prod.outlook.com (2603:10b6:5:8a::16) by
 DM6PR15MB4072.namprd15.prod.outlook.com (2603:10b6:5:2bf::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Thu, 3 Dec 2020 19:15:39 +0000
Received: from DM6PR15MB2379.namprd15.prod.outlook.com
 ([fe80::b9ed:d237:de1a:adc0]) by DM6PR15MB2379.namprd15.prod.outlook.com
 ([fe80::b9ed:d237:de1a:adc0%6]) with mapi id 15.20.3611.034; Thu, 3 Dec 2020
 19:15:39 +0000
From:   Dan Melnic <dmm@fb.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     Omar Sandoval <osandov@osandov.com>
Subject: xfsprogs and libintl
Thread-Topic: xfsprogs and libintl
Thread-Index: AQHWyaivninDN22oEUSicmiRI3rvBw==
Date:   Thu, 3 Dec 2020 19:15:39 +0000
Message-ID: <B8D4A2D8-01A0-40D6-AB89-887BD0B1F4B4@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:43f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cfd493d9-4ef2-4e3b-4d39-08d897bfd25c
x-ms-traffictypediagnostic: DM6PR15MB4072:
x-microsoft-antispam-prvs: <DM6PR15MB407296BEEC89E3807BB59D57D5F20@DM6PR15MB4072.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +ZRhHVSiLfWhEvkPLWETm/tRME9ZwpCCFczSjklKGZ78rkWMkNgnx+qcX4HI5CscET1XkE+XdOo4AxwYHftUDNUAFw9E6Vfckw/oLCzqPCV7yJ+as0FsPd6zPPuHdIZpbMSLvWW6TNpz5P72ZAOE2xjq4JUPZYVkmVpNtzWm6V+IOaBiJHX7wvwQ1nTZl4ZW2h2Tfe85oKpt3E0kSML/ROFObeKkZRnonv1DPhSaY41YqsoANT5TeItkEXZZ6wcyrcIr8c3vJCJvdOabK7iCFW7mSonp0DaxVoxGAaHVAyGt3R6efL5XVlXCCetCk5bW+jOIwjRjjrLLdRz4uw5X70cLmMMO7vX0vxjYkUvS9uaReId2jcFPuk5/U4/D8AhVzzE1HBuzyGI90JD1+RP3MyGus+JalCTcP4+07zWWB/hfGqLzTnXt5ycovt5Mq7aNbpcV9L+BQabBEidUQFaf0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2379.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(396003)(136003)(376002)(33656002)(8676002)(966005)(478600001)(83380400001)(3480700007)(66446008)(4744005)(91956017)(66946007)(7116003)(5660300002)(2906002)(66556008)(66476007)(76116006)(64756008)(6486002)(2616005)(71200400001)(6916009)(36756003)(316002)(4326008)(6506007)(6512007)(8936002)(86362001)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?blFzVTVGNFhlUmp4aWFSd1NEcU5HZzNKN2g5MmxOWDJQNWZCMnZQZ3VublNN?=
 =?utf-8?B?VnFVOHVCYWlMM2NvK1VmMEkwbUtTeFdhQ29SVWlnQi9LWmV0VkhOdDk4cHpy?=
 =?utf-8?B?M2VSMzFhMS9CQkpnem0vcDdacGpKOW1RUUdWSEIvKzRqTWx0MXFxQUlPcWdG?=
 =?utf-8?B?MkRkZVFoZmhTcGpIQ2Jsc2pVeGM3NE84QWcwdGVVdlJxZ2EyRDlTcjFnU2Jj?=
 =?utf-8?B?dDd6OU9qQ2lvQnU4U3B5c3JjNE1hVi9XcDc0WU5lZVVpaHA3bWxWd3V2ZWgx?=
 =?utf-8?B?VVg3OGRWSlhWaEdydjVyb09rYVlFcmhvV1V2cGs4ZFJpZFZzNDNCUnBPOWUr?=
 =?utf-8?B?UTByZXFNQncrQWtoZ3U0OCtBRDV4QVI0VEc2ZGtFMkJTZUNmL3kxeFk5L2hK?=
 =?utf-8?B?R212YnZtR1dITWd0RHZpUyttbis0TEtNbGVyVEJxQ1dGN0R2K0RVSVE5U083?=
 =?utf-8?B?M2Z4SWZVaVZpeC8vSmRrekR5N0FFcWJCRVZBSFllQzViOTFSZEVwTmI4cS93?=
 =?utf-8?B?VGV2c1BHYzJlUzRLenl5Mk55bWpRWkZwUzhoTzcxS1A2dGpNeVI4Y2c3RmFN?=
 =?utf-8?B?cnhsTU9SRUZZNXdTYTF1eXdmYkVNcUdnZUFUNFFjQ3VQcGtGWlRwQkVxZS8v?=
 =?utf-8?B?TDd1cnk2VDhDODJDSEoxdjZpMmZPclJ2MVRWM1kzUURkcVNwbzZkbXp2OERL?=
 =?utf-8?B?QVIrYndMamRnQ3FETU9EUDlpQ3czaXNnTDhvNnUrN3llLzVRRUxuOVRBb1cr?=
 =?utf-8?B?Ry9tcXBJSWdZR0UvQW1XSnp0dmxVeE9BQVc3ZDhrVUlVaWNGTEJYampybUJz?=
 =?utf-8?B?MjhVNFQ5ZXp5Rk16UHo1aWIzd1NtTC9IUTJGeHJwemhZS3pHZW93eWJSb0o1?=
 =?utf-8?B?SjVjUkRsK01WakJNaUpOeSs4cngrYjY2am4zUmcvbEhYcUFPMzFTaGRsTW5v?=
 =?utf-8?B?TWhkMWVoaFc0Z2t0clQxNUs4QWVYUmw0bktiUWNBZHJIejNsWkJKZ2xqbisx?=
 =?utf-8?B?VXZjRlZLcWR5MGVSL3R3eXNKd3FtWHVHaEhEa2FhRG1TRTFtY3ZPN3BkWjZ4?=
 =?utf-8?B?bjBuM3YxY1BZWlVIb1l1M2d5U0hLTG9nd2MxN282NXZ5U1N3L2FiWm9EcTZn?=
 =?utf-8?B?cFc1SDg0QjdHTTB0Q3VSdjNXT1VvQXVRVTRUdnZkUS9PbXdkN0JkYysySElX?=
 =?utf-8?B?d0drVG1sSWRDVXpZelFOQ0VJK3haWnEwQStxbytmck1DblR5VWwvaTZadTQz?=
 =?utf-8?B?YVFQTCtSbjNqNVQ4aTRKOVR4ak9lQjNuOXNYY1Yra3JjcDdlZVk3T3FGdnRE?=
 =?utf-8?B?bEs3N2s5aE1BbDhKSnBBU2tLZ3lQb1QvaENaQjZNVk5oSTQwdFRVUVNjOVJn?=
 =?utf-8?B?WFl1SldUcFBsRVE9PQ==?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1ED375A832A3DF40B3EB16C3CFB3D05C@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2379.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd493d9-4ef2-4e3b-4d39-08d897bfd25c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 19:15:39.5078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z2iqBhlOSdnvpvI6eo3DI50EhyQLsPWS+fia425EKvtI30CfCeOxV+05UluExr0l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4072
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_11:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0
 spamscore=0 mlxlogscore=667 priorityscore=1501 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SGksDQoNCklmIHdlIGNvbXBpbGUgc29tZSBjb2RlIGJvdGggd2l0aCBsaWJpbnRsLmggYW5kIGxp
Ynhmcy94ZnNwcm9ncywgd2UgY2FuIGVuZCB1cCwgYmFzZWQgb24gdGhlIGluY2x1ZGUgb3JkZXIs
IHdpdGggdGhlIA0KIyBkZWZpbmUgdGV4dGRvbWFpbihkKSBkbyB7IH0gd2hpbGUgKDApIA0KYmVm
b3JlOiANCmV4dGVybiBjaGFyICp0ZXh0ZG9tYWluIChjb25zdCBjaGFyICpfX2RvbWFpbm5hbWUp
IF9fVEhST1c7DQoNClRoaXMgd2lsbCBjYXVzZSBhIGNvbXBpbGUgZXJyb3IuDQpJIHRoaW5rIHRo
ZSBFTkFCTEVfR0VUVEVYVCBjaGVjayBzaG91bGQgbm90IGxlYWsgaW50byBhbnkgcHVibGljIGhl
YWRlcnMuDQovKiBEZWZpbmUgaWYgeW91IHdhbnQgZ2V0dGV4dCAoSTE4Tikgc3VwcG9ydCAqLw0K
I3VuZGVmIEVOQUJMRV9HRVRURVhUDQojaWZkZWYgRU5BQkxFX0dFVFRFWFQNCiMgaW5jbHVkZSA8
bGliaW50bC5oPg0KIyBkZWZpbmUgXyh4KSAgICAgICAgICAgICAgICAgICBnZXR0ZXh0KHgpDQoj
IGRlZmluZSBOXyh4KSAgeA0KI2Vsc2UNCiMgZGVmaW5lIF8oeCkgICAgICAgICAgICAgICAgICAg
KHgpDQojIGRlZmluZSBOXyh4KSAgeA0KIyBkZWZpbmUgdGV4dGRvbWFpbihkKSAgICAgICAgICBk
byB7IH0gd2hpbGUgKDApDQojIGRlZmluZSBiaW5kdGV4dGRvbWFpbihkLGRpcikgIGRvIHsgfSB3
aGlsZSAoMCkNCiNlbmRpZg0KDQpodHRwczovL2dpdGh1Yi5jb20vb3NhbmRvdi94ZnNwcm9ncy9i
bG9iL21hc3Rlci9pbmNsdWRlL3BsYXRmb3JtX2RlZnMuaC5pbiNMNDgNCg0KVGhhbmtzLA0KDQpE
YW4NCg0KDQo=
