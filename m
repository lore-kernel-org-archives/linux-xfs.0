Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A9EC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 908302220F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgLCUju (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:39:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34270 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727450AbgLCUjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:39:49 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KcwGm014183;
        Thu, 3 Dec 2020 12:39:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=n0CLHfHLcSv35Yg/14FTxcbO3CRqKvhdIZE+u8RXFPI=;
 b=EGs+9vPP9wdH16OiWQrK5aKSRzzDsouqjXzWxNgms1uUhaLSEV2U/r4gCH9uuAlkC2Ri
 QGeYV+xYJpbwjEgBIdsw3qCDcdL5niiW26X0qYlbvE/adDCrKV2Aw09Q2uSh+mnh7Npc
 ld5M9owdV5eWqOa56Q4CDwB0vFV041cEFSE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35615fpq1n-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 03 Dec 2020 12:39:04 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 12:38:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWZLI4XYBmpKybWhkFkPqHahqNhOgUyAIX9XWzt6ClGTT81Y0NvT8sv1oE8qPp4oAduRIW9FTbbTq48Kd1PXnEt91mEPGwtcPdKtCnezC0P/7q7YWeXolRhsZIYIPd3FyGWPQdIv7vRGw1GFH9McrnWoFkHGDhv+xEM1tXkvCOnKjCzS08YYDsYHthwkgjHax++oWa78G2S0tpDfqNdrzPo2DK0UgEbRtqoasU8WmfedM5VvHL7vmenj2k/OGHTkQ0R4+rRy0OLIMW/ToOpeq8nPzM+UMIocENFbvnq4GqvxzPRlTMyyEJZg+KqY4eWS3p8pxdO+LMZ7uT/PSr5NPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0CLHfHLcSv35Yg/14FTxcbO3CRqKvhdIZE+u8RXFPI=;
 b=GRhz6OxCz4KpwMhewwi+AbcOE3XORl0QOKzYsCGJDS0esrKuJ264I8mU7/PsDKfiaqw5ITwmWR4WCtz1l01fDTN7u9yAY3WKQ1Ak7CDSXZSqqR6HFfiM+OGjf9J8PNao/d3KYIhYCburgupFCFTyIW8cHduArSvlhI4SQhvvl0mie3TtbcP350eaOxs2Z3gD8gr6+Sp0j1c8fnSNCZ2aSTtmjdnsNJRHYK3CNF9W84k9+U/z+rkWFueMdIkp0qK3v7kSB2s+qpApybhST6Am2M54M2LJQEdONUTjjYZLvHbI8R4wfF9TYTalfjBU4itA8atOyDc29YSSH+U/PPJKAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0CLHfHLcSv35Yg/14FTxcbO3CRqKvhdIZE+u8RXFPI=;
 b=PnU99nl7IUJB4DejheJjrxhooY6JI6UklRTPitg4RmPbVA9IueEHkHB0wyxp1RWYdYVR1UsVpIuDIIgDK+rb9uvbQvGDa3jY5f9NrV+gaz36I1Pw8rIhkindmpZnSnZNp5P6rtZlIjHsNHkjNcCMBUgsFSoqyK3g2FUvyZZr9bA=
Received: from DM6PR15MB2379.namprd15.prod.outlook.com (2603:10b6:5:8a::16) by
 DM5PR15MB1577.namprd15.prod.outlook.com (2603:10b6:3:ca::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.19; Thu, 3 Dec 2020 20:38:48 +0000
Received: from DM6PR15MB2379.namprd15.prod.outlook.com
 ([fe80::b9ed:d237:de1a:adc0]) by DM6PR15MB2379.namprd15.prod.outlook.com
 ([fe80::b9ed:d237:de1a:adc0%6]) with mapi id 15.20.3611.034; Thu, 3 Dec 2020
 20:38:48 +0000
From:   Dan Melnic <dmm@fb.com>
To:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: xfsprogs and libintl
Thread-Topic: xfsprogs and libintl
Thread-Index: AQHWyaivninDN22oEUSicmiRI3rvB6nlw32A//+CWYCAAIoxgP//fySA
Date:   Thu, 3 Dec 2020 20:38:48 +0000
Message-ID: <BE25930B-B515-42AA-A2B3-3EAF2E873D79@fb.com>
References: <B8D4A2D8-01A0-40D6-AB89-887BD0B1F4B4@fb.com>
 <20201203193507.GI106272@magnolia>
 <864CA3B9-B24E-4DB6-B87D-763E25DFF2FF@fb.com>
 <d3abd8ca-735d-d7d7-6229-e7540325cd84@sandeen.net>
In-Reply-To: <d3abd8ca-735d-d7d7-6229-e7540325cd84@sandeen.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: sandeen.net; dkim=none (message not signed)
 header.d=none;sandeen.net; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:43f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54b17920-af70-45c7-a5ff-08d897cb6ff3
x-ms-traffictypediagnostic: DM5PR15MB1577:
x-microsoft-antispam-prvs: <DM5PR15MB1577B9249F2F1B9BDCBB19AED5F20@DM5PR15MB1577.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w1LN3dRFSeDJ6d5Oen0s+mCgVajOeurs/6T5Ek+XIxjRIKmtxMlDHYJ4uIVWawmsDhMdtz8iTDVmmC9+0qKslgSd3yu/HSF25Yq1+eWbecCEAjLdnDdKPyay4iMJiOePcnQ5VpcxCZ7ehvlhcV3lOtyrtBcOxF4eQAOxfTJRD1RKiUSDk48IBC2PCNVCcTRunG781VWWHbTVoA2Dx4TWlqHBpEJu5GrFsn+nX7hJ8fxZo+ZLg+KXxYQSznQgefE9kAU/fWpUeXSSMt1PS1AiJ6q5+txvkcpijHxpbcUuYTEyVD/pu8oLKP/BwAEeSpYZL1WILso5X+1Qm0N9XzBY8y2dHnI8bOV9RzHkRZszbDtrN3dKENnq9xL+/GySjSub
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2379.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(366004)(346002)(396003)(7116003)(3480700007)(2906002)(64756008)(66556008)(86362001)(5660300002)(66476007)(66446008)(66946007)(4744005)(33656002)(54906003)(316002)(110136005)(36756003)(6506007)(53546011)(8936002)(71200400001)(6486002)(8676002)(4326008)(83380400001)(91956017)(6512007)(186003)(478600001)(2616005)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?am15SnpkcHlmODFwc2xsNW5qelRPV1lyWExCcFpWNERYVmwyQTlTblV2T2Yy?=
 =?utf-8?B?dWxIVkdXbGg0L2xaenNuSkdFbm4vbDMxZU5nVm9HaU56YlNkVzBRbjNLTVNj?=
 =?utf-8?B?bnRLeDJSYy9EQStGL1VRNW4wZ0JGTTJna3B1dGhnZldGVVBFdmcrbUpkcFo1?=
 =?utf-8?B?K3QwN0QrWWdVQjRnZjN1OHZkY0FGbEVYbFVQaDR1Z1RBSUJLeVU0VVRzSVJJ?=
 =?utf-8?B?dGIwcFBzbWtWMFJ0VU1JVnJOQ2hpT21QUEs5eUloRHNYL0VaNEM0MS9Xb0xx?=
 =?utf-8?B?NVhiemQ4K01LTnp5L0hRNXE0NHRwWnpmb0tqMGJUWncrZTViN1FXVlhGcnlD?=
 =?utf-8?B?d08xTVlPOXB4L0FSeFpCSXNTN2ZIaUVhZitqeFVqR3J5M3RCQTdFVnlBZ0Fl?=
 =?utf-8?B?MVB4MUJYWjZPZThkZk8yQ0NmaWlIeU1vVVlUOEpqYUNVakJqWGVUZ0U5ZDVV?=
 =?utf-8?B?WXhNNTJJRGVpRXdicFllUjE2Yis2UmVqYi9zQW1YMTYxUFZjWjlqczdsSXRp?=
 =?utf-8?B?TDFKWVlOQ3FQRVgzWVRDUTZjVjZZN1pISWlka2pyTDRFVHA3WjlySjdNa3ha?=
 =?utf-8?B?anhHYWhFVDI2dWNPRjJreE1jZmZrWElUN3V1UVU4a0JkcGlyZEJUY3AzY203?=
 =?utf-8?B?Rjl0d3p1alJQVlhXWkhQam5EemgvbWZrYzVOcnBVOUwrUEVvMkU2cWo2L0pO?=
 =?utf-8?B?R3Rwc0FCbkwzL0dhMm1vR1lEeUQ2QU9OSHlYR2ZHYjl5TXcySzlobkpEdE9M?=
 =?utf-8?B?NUc0YTlYQlVvb0R3bG12UmRWbHJKSmgxaktpNjI4N1U2VUQrMndEVDAwSTNI?=
 =?utf-8?B?bGw4NlJZQWZ4TE9DcWNsSzdydnlxNXUwKytNbzRyWEVaVlAzRDV4Ynp3WGQy?=
 =?utf-8?B?d0hCZ254dno5T2VJZ05pa25zd1YyRHViZG5udVFWMEJaUmZhN0xLR1FUZnJJ?=
 =?utf-8?B?bHN2T1JteGlWS3dkTXpQcmpWT20yYWw1OGNLWEtzMUpRS253bmFBRkxTWFdS?=
 =?utf-8?B?Y3V4dlIybG80UzNpWm9DRFRwWDJzUERsUkgweGxXZmxFWm5ybUNqZi9WSVQ0?=
 =?utf-8?B?U1VUY3B3NjN3S1VFYm1oT1MycHd2RElaNTdRaHFHQTVqUFVoZlZtRWF3amlm?=
 =?utf-8?B?UXozdkpDRmxSRTZMZHMzQngwdWMrZ1c1MCtyd0hJSEN0NDkvTVJUek9scUNQ?=
 =?utf-8?B?Z3dvTGRLc3N2SlZlWmd3Zk50RUs2M28ySnpkV0VaQzdrbkhydEpnSWpRZjRS?=
 =?utf-8?B?VmYwM25ZMnhaYlAvbE5PTkg2U0ZQWjZ3VHhVUkJ0QzNYSWZGZG5na3dGazNz?=
 =?utf-8?B?K1FOejd6Q0FMLzNKZnJ1b3A5amR0MGkwcWdOWFArYnQyY2NGa0ZQOVpQZlZY?=
 =?utf-8?B?MTk4czc1NCtyaUE9PQ==?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5514812D59691847972A590DD40BB9FB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2379.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b17920-af70-45c7-a5ff-08d897cb6ff3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 20:38:48.3830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0N7FacKfSJfDRgc0+sYt+UNBVewH6gqdpI90ga+15rUOx4QryxO97T12kDnuQG2b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1577
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_12:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012030121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

VGhhbmtzLA0KDQpEYW4NCg0K77u/T24gMTIvMy8yMCwgMTI6MjAgUE0sICJFcmljIFNhbmRlZW4i
IDxzYW5kZWVuQHNhbmRlZW4ubmV0PiB3cm90ZToNCg0KICAgIE9uIDEyLzMvMjAgMjowNSBQTSwg
RGFuIE1lbG5pYyB3cm90ZToNCiAgICA+IEkgZ3Vlc3MgdGhpcyBpcyBhbiBvbGRlciB2ZXJzaW9u
IC0gMy4xLjQ6DQoNCiAgICBUaGF0J3MgLi4uIDEwIHllYXJzIG9sZCENCg0KICAgIHBsYXRmb3Jt
X2RlZnMuaCBoYXMgbm90IGJlZW4gaW5zdGFsbGVkIG9uIHRoZSBzeXN0ZW0gc2luY2UNCiAgICAy
MDE1IG9yIHNvOg0KDQogICAgLGNvbW1pdCBkY2FiZDRlN2U5NTUyMzFhNmJiOTJjZTEwMzhlNjJl
NWE5YjkwYzVkDQogICAgQXV0aG9yOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCiAg
ICBEYXRlOiAgIE1vbiBBdWcgMyAwOTo1ODozMyAyMDE1ICsxMDAwDQoNCiAgICAgICAgeGZzcHJv
Z3M6IGRvbid0IGluc3RhbGwgcGxhdGZvcm1fZGVmcy5oDQoNCiAgICA+IHhmcy5oIGluY2x1ZGVz
IHBsYXRmb3JtX2RlZnMuaDoNCiAgICA+ICNpZm5kZWYgX19YRlNfSF9fDQogICAgPiAjZGVmaW5l
IF9fWEZTX0hfXw0KICAgID4gDQogICAgPiAjaW5jbHVkZSA8eGZzL3BsYXRmb3JtX2RlZnMuaD4N
CiAgICA+ICNpbmNsdWRlIDx4ZnMveGZzX2ZzLmg+DQogICAgPiANCiAgICA+ICNlbmRpZiAgLyog
X19YRlNfSF9fICovDQogICAgPiANCiAgICA+IFdoaWNoOg0KICAgID4gDQogICAgPiAvKiBEZWZp
bmUgaWYgeW91IHdhbnQgZ2V0dGV4dCAoSTE4Tikgc3VwcG9ydCAqLw0KICAgID4gLyogI3VuZGVm
IEVOQUJMRV9HRVRURVhUICovDQogICAgPiAjaWZkZWYgRU5BQkxFX0dFVFRFWFQNCiAgICA+ICMg
aW5jbHVkZSA8bGliaW50bC5oPg0KICAgID4gIyBkZWZpbmUgXyh4KSAgICAgICAgICAgICAgICAg
ICBnZXR0ZXh0KHgpDQogICAgPiAjIGRlZmluZSBOXyh4KSAgICAgICAgICAgICAgICAgICB4DQog
ICAgPiAjZWxzZQ0KICAgID4gIyBkZWZpbmUgXyh4KSAgICAgICAgICAgICAgICAgICAoeCkNCiAg
ICA+ICMgZGVmaW5lIE5fKHgpICAgICAgICAgICAgICAgICAgIHgNCiAgICA+ICMgZGVmaW5lIHRl
eHRkb21haW4oZCkgICAgICAgICAgZG8geyB9IHdoaWxlICgwKQ0KICAgID4gIyBkZWZpbmUgYmlu
ZHRleHRkb21haW4oZCxkaXIpICBkbyB7IH0gd2hpbGUgKDApDQogICAgPiAjZW5kaWYNCiAgICA+
ICNpbmNsdWRlIDxsb2NhbGUuaD4NCiAgICA+IA0KICAgID4gSSdsbCB0cnkgdG8gdXBncmFkZSB0
byBhIG5ld2VyIHZlcnNpb24gdGhlbi4NCg0KICAgIEkgdGhpbmsgdGhhdCBpcyB3aXNlIDopDQoN
CiAgICAtRXJpYw0KDQogICAgPiBEYW4NCg0KDQoNCg==
