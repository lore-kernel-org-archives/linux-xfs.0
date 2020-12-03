Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49560C4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C86BE221F4
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgLCUGL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:06:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16924 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726004AbgLCUGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:06:10 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JwxsQ009959;
        Thu, 3 Dec 2020 12:05:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=V2EBnvmGtUYY7icOg9EMdylmT9BsDhvuGi8OWTMtMOQ=;
 b=D2dz8h7ObT9VwtBKnrPdAuy/sAsCLTw4wvWhsZuJrrxqedMKNYBWAhAmTQo7u8Qx6ir7
 Hp4RD6VksSPE4HQhLokLRe8iRXY1y9E733gunrtVxZIrd0IIcLRi5Uvp1G6lalh9J0LB
 YCHarDMGLLpDxwMgtRcoFNS4Xec5q59CCUg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35615fpg19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 03 Dec 2020 12:05:26 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 12:05:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzFk0L0UUhQIIQbsmyRVbJZ83QwGTpYo/wcg06ucacxKWKxeJ9sHn1kEajcAtnQ8/Uem2kkeQwBUd6qWw2BcW4T74uFOgKk+oiA+LK0KTyP7whWkm1NQL05CVvMUofcR8OR6oS/O9f1/q6Goucj1NaOt8s5KVJpjjrevAN3LtMfBGwkDiPbyPCMDKrtVSqvbq5fywYa7QpH5/jAQ34e2GT3vUXxgmpCDPaPsc+xhmZfQiUuBqMgKwPZ30Tpkfuk43t0PiBj8Z6HSuHM2kiYmGTnmyDD6foMUe6F2uAO+4sYqvIj2nfbnST9riMjsvC0aFj8h0ICHUpZHe0Sj2guDJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2EBnvmGtUYY7icOg9EMdylmT9BsDhvuGi8OWTMtMOQ=;
 b=Bd7RBkMsc81dxQVZX0BE2DdHfJkyWu7RX3jq3wODrwwXyGUxdoNREBg5kiCeL7W1CmtXJu6AhmH8GzZUXWJ9OZ14982j90Eb8ygLUBU504XSaeCBIDWQNqbDIfGMgKiXD+DhjXJam+iXw5sFbmy7M89SwuArGrVf7oiYZ5n8pD9O2inGCKzac8XZEJRASRSW2iIPi/jZQDUAset+8OX0/xA8ORuuatk6K1GOh7BLBomiAPD2rMAWeExYmKuw/xatYEoNr5Fbtt+9dojTZPhi5SaivL+RNM8HcugmaSXVj7GYygHSaPd60Rgl5dNi8x1dAD4T4P0veVOrKkXqxSr7bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2EBnvmGtUYY7icOg9EMdylmT9BsDhvuGi8OWTMtMOQ=;
 b=DMWaZ1XJfgs4ulZTMjg1fWfGilFRLvw2cKLE39OXjzLLqH7whvXEdt6J5KjAEcNGm7jsT3D9y8w6mraD10iLSQqNfA42CkqQL7ZMAA8HG9vweAFGTR9qBWU0RoIFJQmU3dQsdeN11V1WCTWWJoFXOW596ZAnR1l2KA7pjo58gIw=
Received: from DM6PR15MB2379.namprd15.prod.outlook.com (2603:10b6:5:8a::16) by
 DM5PR15MB1225.namprd15.prod.outlook.com (2603:10b6:3:bc::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.18; Thu, 3 Dec 2020 20:05:24 +0000
Received: from DM6PR15MB2379.namprd15.prod.outlook.com
 ([fe80::b9ed:d237:de1a:adc0]) by DM6PR15MB2379.namprd15.prod.outlook.com
 ([fe80::b9ed:d237:de1a:adc0%6]) with mapi id 15.20.3611.034; Thu, 3 Dec 2020
 20:05:24 +0000
From:   Dan Melnic <dmm@fb.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: xfsprogs and libintl
Thread-Topic: xfsprogs and libintl
Thread-Index: AQHWyaivninDN22oEUSicmiRI3rvB6nlw32A//+CWYA=
Date:   Thu, 3 Dec 2020 20:05:23 +0000
Message-ID: <864CA3B9-B24E-4DB6-B87D-763E25DFF2FF@fb.com>
References: <B8D4A2D8-01A0-40D6-AB89-887BD0B1F4B4@fb.com>
 <20201203193507.GI106272@magnolia>
In-Reply-To: <20201203193507.GI106272@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:43f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1ee9c2c-75ff-48d2-ec28-08d897c6c528
x-ms-traffictypediagnostic: DM5PR15MB1225:
x-microsoft-antispam-prvs: <DM5PR15MB12254533BE48DE5A948CF8D6D5F20@DM5PR15MB1225.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g9E9Q4dSYNGSsAUO9vUupXUSvCxfO3HllRvdZN3WGnzb3zV9IJZ320uaGMh40SWBds1EKU0NKK6Y3a4H7KM2LutVH8cfnm02iUT6odPeMMj39TaLAByhdHh2ExCmacMvdlGgMFUUY6EwRrGO/5IL4P3DEhTssJrKy4GKH4iETw07MbFgrifcqFJbDS0zi+dhy/kogvi74o4MG6eVoXKx9/nW9NSu7LseqhuoUVUfHXIt5sqcArY0IRhhyk5BIFwMHxVM6bBxoLSO4W/y0gDyFjh7ddyAFdiwjFKTWCUi/T5iJbMwbuPQpu1x9adWQoBKzBEV+qHWmfZztVx4snzA9sOeCSzhty5q/PXBnhbFoe9Q7oteRDmaPEc9VuD7NmCtUeHLTM7CC85Tp2MTywf0rUz3CgBcJ9ssIq+FZQddo2RZWLTHzZwRwMtO27vBT+WgcPZVlMeq3vFhF0FxQcmtxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2379.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(376002)(366004)(396003)(66476007)(4326008)(3480700007)(6512007)(478600001)(186003)(76116006)(91956017)(8676002)(2906002)(6506007)(86362001)(6916009)(8936002)(36756003)(66556008)(66446008)(66946007)(966005)(64756008)(71200400001)(33656002)(83380400001)(316002)(6486002)(5660300002)(54906003)(2616005)(7116003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZEpGZ3FXS1B3ZGwyQVBrWTA1S1BTbVVKemNvQmdidGFmald4dUdYTG9ETVox?=
 =?utf-8?B?ZUwrN2VxWlhmdjB5ejg1Zy82Y0JPZWY4UXY4S3lBSERNSEhPMHBxU0g0aTZx?=
 =?utf-8?B?SG4xWDU3ekpNRmY0MENwN3RabDdnTmxqRnNlL25vNzNFS0xhREhwRmxHV3RS?=
 =?utf-8?B?bWhLYTdSOXYwd3FYR0NCUVZzVkI1VDV3cFU3MnVyZGhJMnk0NEVKUlR5UnJo?=
 =?utf-8?B?ZWFNS2lnUGUwcXZ0eUVydmhZS3VhdnBDNVJwbUtRMDVudEJTeHRxelJ1ZWRp?=
 =?utf-8?B?ZnhOY3Q1aTN2bkp2TE9mWGd6bmZham81c1oySCtsSEVuVTBpdW1vdUN6cld1?=
 =?utf-8?B?bmYxSlRBRVF3VFkwendrTlNGV1VhYVNiOGJ2dWNLUVYxeGR5YWwzZlpuWkNQ?=
 =?utf-8?B?VVZyWXVsY2s4NEtRUnpvM3M2aGlnZm1UNFFSZG5NeGZQYWp3VnlLQUdzRkVL?=
 =?utf-8?B?WmM5VUE4RnlkTEd2c2lsZVFGcTNodDZUeDhsNXZlQ0k0MzJFZldJU3ZwbVg4?=
 =?utf-8?B?NFFScC91MWNvdlJFckNCT0RWcU9BaFhsQXRSMmxBMXg3Z0Y2MlVqVmV3TEJH?=
 =?utf-8?B?aFRoNm1Rc3dONGJRTjN2emZSbXJpQWYyS2J2T3NUYXhyK2k5Zlg1SkNxNW5I?=
 =?utf-8?B?c0J3c1FFL1Bzc2QyYjZiWlRnSmlDSGRYbUdPTG10SUIyUG5Cd1VCRXR5MWFx?=
 =?utf-8?B?cmpoY0tFcmJSTkdVUnFiSkRKdHUvOW5rVE9kcmt3aTZyMm9mU21GajVMQmww?=
 =?utf-8?B?U3ZpR1dwblBXYjdKaHpZbWdxTklIZjgwbTRvNTNIWWdPcU1UeVVLY3lrT0RN?=
 =?utf-8?B?QzFvZ0s3dHM3Vysyb1lLUTdzQmxOWEN1ZVExU0dWV2NFK3pHQTFDaHQ4MjdE?=
 =?utf-8?B?YVo1alZjVXhZenFCZ0FxYnlOQUF3VUpKV2dVVzlkSThKRlh5ekpLU1k0U1lU?=
 =?utf-8?B?SFNSZ0pyNGkyYnBZQnVPSWhIZGdsUGdrTXNSbEpubXJWR3RHSmxwVm5waENy?=
 =?utf-8?B?UDlDMzh5VzBzZldMS0hGZWFwQkwrbWczTHo3ZEVKNW1TTnRiMUJMYnhHVWJo?=
 =?utf-8?B?VUhuK01XMzMwb3c0TWM3TlpDTnpGRTAzdXA3aUZtR0RtK0lhdzZCQzRLek9I?=
 =?utf-8?B?U1MyUEdnOS9abGV4MnNhVVNzMXI1WUh0TGcwanpFVHdLSHc1VTdxUzRaOTN6?=
 =?utf-8?B?a1dhL2REckJWYmFJYng0L1F4ZHFrQzFERVQ5Y24vRzlHamdYQXFjQlpwb3pE?=
 =?utf-8?B?blBjTTErV0JCVlpaTkxiL0haK1VQOHY3ZXQ5dVdZMXl1VnA1K2lqU3g0bGpV?=
 =?utf-8?B?ODROVGdINmlWWTFpby9SdXJ1RGNXT2NhSmtJUUhNSXJtNkloM1BTTURTNlA0?=
 =?utf-8?B?d3BzVlJHSFV1YlE9PQ==?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7500535813C634189F022FF5985982E@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2379.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ee9c2c-75ff-48d2-ec28-08d897c6c528
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 20:05:23.9197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ng/n5Tg54GblTRBlsvSutFsxsNIdciIrDTBUMLjovbQSucWPdBV1SEqc2Gk5GEVm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1225
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_11:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012030116
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SSBndWVzcyB0aGlzIGlzIGFuIG9sZGVyIHZlcnNpb24gLSAzLjEuNDoNCg0KeGZzLmggaW5jbHVk
ZXMgcGxhdGZvcm1fZGVmcy5oOg0KI2lmbmRlZiBfX1hGU19IX18NCiNkZWZpbmUgX19YRlNfSF9f
DQoNCiNpbmNsdWRlIDx4ZnMvcGxhdGZvcm1fZGVmcy5oPg0KI2luY2x1ZGUgPHhmcy94ZnNfZnMu
aD4NCg0KI2VuZGlmICAvKiBfX1hGU19IX18gKi8NCg0KV2hpY2g6DQoNCi8qIERlZmluZSBpZiB5
b3Ugd2FudCBnZXR0ZXh0IChJMThOKSBzdXBwb3J0ICovDQovKiAjdW5kZWYgRU5BQkxFX0dFVFRF
WFQgKi8NCiNpZmRlZiBFTkFCTEVfR0VUVEVYVA0KIyBpbmNsdWRlIDxsaWJpbnRsLmg+DQojIGRl
ZmluZSBfKHgpICAgICAgICAgICAgICAgICAgIGdldHRleHQoeCkNCiMgZGVmaW5lIE5fKHgpICAg
ICAgICAgICAgICAgICAgIHgNCiNlbHNlDQojIGRlZmluZSBfKHgpICAgICAgICAgICAgICAgICAg
ICh4KQ0KIyBkZWZpbmUgTl8oeCkgICAgICAgICAgICAgICAgICAgeA0KIyBkZWZpbmUgdGV4dGRv
bWFpbihkKSAgICAgICAgICBkbyB7IH0gd2hpbGUgKDApDQojIGRlZmluZSBiaW5kdGV4dGRvbWFp
bihkLGRpcikgIGRvIHsgfSB3aGlsZSAoMCkNCiNlbmRpZg0KI2luY2x1ZGUgPGxvY2FsZS5oPg0K
DQpJJ2xsIHRyeSB0byB1cGdyYWRlIHRvIGEgbmV3ZXIgdmVyc2lvbiB0aGVuLg0KDQpEYW4NCg0K
77u/T24gMTIvMy8yMCwgMTE6MzUgQU0sICJEYXJyaWNrIEouIFdvbmciIDxkYXJyaWNrLndvbmdA
b3JhY2xlLmNvbT4gd3JvdGU6DQoNCiAgICBPbiBUaHUsIERlYyAwMywgMjAyMCBhdCAwNzoxNToz
OVBNICswMDAwLCBEYW4gTWVsbmljIHdyb3RlOg0KICAgID4gSGksDQogICAgPiANCiAgICA+IElm
IHdlIGNvbXBpbGUgc29tZSBjb2RlIGJvdGggd2l0aCBsaWJpbnRsLmggYW5kIGxpYnhmcy94ZnNw
cm9ncywgd2UgY2FuIGVuZCB1cCwgYmFzZWQgb24gdGhlIGluY2x1ZGUgb3JkZXIsIHdpdGggdGhl
IA0KICAgID4gIyBkZWZpbmUgdGV4dGRvbWFpbihkKSBkbyB7IH0gd2hpbGUgKDApIA0KICAgID4g
YmVmb3JlOiANCiAgICA+IGV4dGVybiBjaGFyICp0ZXh0ZG9tYWluIChjb25zdCBjaGFyICpfX2Rv
bWFpbm5hbWUpIF9fVEhST1c7DQogICAgPiANCiAgICA+IFRoaXMgd2lsbCBjYXVzZSBhIGNvbXBp
bGUgZXJyb3IuDQogICAgPiBJIHRoaW5rIHRoZSBFTkFCTEVfR0VUVEVYVCBjaGVjayBzaG91bGQg
bm90IGxlYWsgaW50byBhbnkgcHVibGljIGhlYWRlcnMuDQoNCiAgICBXaGF0IHB1YmxpYyBoZWFk
ZXIgZmlsZT8NCg0KICAgICQgZ3JlcCB0ZXh0ZG9tYWluIC91c3IvaW5jbHVkZS94ZnMvDQogICAg
JCBncmVwIEVOQUJMRV9HRVRURVhUIC91c3IvaW5jbHVkZS94ZnMvDQogICAgJA0KDQogICAgPiAv
KiBEZWZpbmUgaWYgeW91IHdhbnQgZ2V0dGV4dCAoSTE4Tikgc3VwcG9ydCAqLw0KICAgID4gI3Vu
ZGVmIEVOQUJMRV9HRVRURVhUDQogICAgPiAjaWZkZWYgRU5BQkxFX0dFVFRFWFQNCiAgICA+ICMg
aW5jbHVkZSA8bGliaW50bC5oPg0KICAgID4gIyBkZWZpbmUgXyh4KSAgICAgICAgICAgICAgICAg
ICBnZXR0ZXh0KHgpDQogICAgPiAjIGRlZmluZSBOXyh4KSAgeA0KICAgID4gI2Vsc2UNCiAgICA+
ICMgZGVmaW5lIF8oeCkgICAgICAgICAgICAgICAgICAgKHgpDQogICAgPiAjIGRlZmluZSBOXyh4
KSAgeA0KICAgID4gIyBkZWZpbmUgdGV4dGRvbWFpbihkKSAgICAgICAgICBkbyB7IH0gd2hpbGUg
KDApDQogICAgPiAjIGRlZmluZSBiaW5kdGV4dGRvbWFpbihkLGRpcikgIGRvIHsgfSB3aGlsZSAo
MCkNCiAgICA+ICNlbmRpZg0KICAgID4gDQogICAgPiBodHRwczovL2dpdGh1Yi5jb20vb3NhbmRv
di94ZnNwcm9ncy9ibG9iL21hc3Rlci9pbmNsdWRlL3BsYXRmb3JtX2RlZnMuaC5pbiNMNDgNCg0K
ICAgIHBsYXRmb3JtX2RlZnMuaCBpcyBwcml2YXRlIHRvIHRoZSB4ZnNwcm9ncyBjb2RlIGJhc2U7
IHdoYXQgYXJlIHlvdQ0KICAgIGRvaW5nPw0KDQogICAgQ29uZnVzZWQsDQoNCiAgICAtLUQNCg0K
ICAgID4gDQogICAgPiBUaGFua3MsDQogICAgPiANCiAgICA+IERhbg0KICAgID4gDQogICAgPiAN
Cg0K
