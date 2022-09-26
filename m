Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28892C6FA82
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Sep 2022 21:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiIZVub (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiIZVuY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2022 17:50:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C28EAA3E2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 14:50:22 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QKeaxx025428;
        Mon, 26 Sep 2022 21:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Ws7dhZUeZ4vTtyI0LWgPK4sm68GEx2aGyYDKM+FQ9Q8=;
 b=0kNIy72Fh3JSS1qTdjjL4Tpb3LNyZFV0W97Ie3WLdeja8jrlywzuW6N2THXKfa4uLm8c
 5V+Hl1rNFWOXPkmMdxUdy3tXjOH1hKKFWuqW7k/mcsGNmMLiU+X3dUm/qA8pjUcV1y9N
 bLzoFaMhSVxbrCYtDtGMEwR0Of/5oV21gcfAopaXL0WlVAh/B0dB4qrwJVE7BoptPoXi
 bvd7JLxkwvxWSTYB+1fSVOrcpfDH1hkVEFNYUHEeqQZdYsJTzbEJ0ITBTDzWcNptxfV+
 9u3Z+8RoC+RCFcvvI3SNHYLpKalmkTqgEU0cc9dXt5DzAzU3cQUM6Fm7fyNqPS8+7YaC 8w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstesw1g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:50:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28QJiqQ3002671;
        Mon, 26 Sep 2022 21:50:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprtn19f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:50:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1/Z4GcLdC9f04piHd6QQ4EMxaPKBrS6ndGormE3ZWFrfYPgDgvUOr1NHBvn8gpaO843E0Is+4GFEqBBswhU/Ai9T3FKuoCcWR9QJV1hMgkrJeF2sJxh+ns3tR2CE5x8B8GV2KBg4NRHs0ZPanqLGDIy1fe0mUrR+W0WPrs0wJU4lDlIZZoVCtsdwLDQRyYHhgk2jDlBJ1tfzNazyN/fdn/0+yJ8kP786R5mpFQwkIouVn/P7aRUDRHzKCPdEzD/pYXHhOszYUBTXMypMBSV/ho7ZOzQgasReRY9Pjgmr35Qduis66gIdD8YKmClEgp36QRp8VuTG6MsqNCaa45axw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ws7dhZUeZ4vTtyI0LWgPK4sm68GEx2aGyYDKM+FQ9Q8=;
 b=CNm8vl1PxzWYG7a6asF26jhTawQYj/9t/3vobyt+P7qoiZmU7YCntiulRDlcauXXrs9SOwM2wwE4jrzzspX0lYeYwZMBCpxsfr0aROxudrMP/8TVu+OqXkBlrw+3L24Fdqu7JCRPZ03HDgkwLJjqtjbXsgkiw8uR+P4oq1DOFqgyxXWRaaou06eIv4Q4eTyU7lMk4FQsEY5O41ZUCNs2fnhArQxh0JS1SOOvmW6MUFDLJE1WpmPtzHMPaspKbwaFn/JjqtOk6KdyiLswiOrY/0uRjrc7FcAfXqi8KOakOrgvEvT+phlOLiJ6XMn4j3wDd3i7aaB+tmyJD7zmUvcL0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ws7dhZUeZ4vTtyI0LWgPK4sm68GEx2aGyYDKM+FQ9Q8=;
 b=v6VXwjwOHkiWUnMYVvJp6B3FAd5y7SnaGpBH/bYDKJeRjNakOTGA4Y+dQLa8jUyaiQMU7SZNQOlSX6WicXW5X5AUFs+xjVPRS6p7A6p+a5nvx1n8sLcqjr80w4KLSrXASDrW3W4HCpEM5881cZcnL2uEL7ON6ah5QK2MWoAvQhA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4689.namprd10.prod.outlook.com (2603:10b6:303:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 26 Sep
 2022 21:50:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 21:50:17 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 26/26] xfs: drop compatibility minimum log size
 computations for reflink
Thread-Topic: [PATCH v3 26/26] xfs: drop compatibility minimum log size
 computations for reflink
Thread-Index: AQHYzkaKFaqfW9D/i02+ZvtZBwFZMa3tj/mAgAS3ZgA=
Date:   Mon, 26 Sep 2022 21:50:17 +0000
Message-ID: <317c63bb5d82a6633021bd6eff43b73b8531d8ca.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-27-allison.henderson@oracle.com>
         <Yy4pwbVagkxMXvCf@magnolia>
In-Reply-To: <Yy4pwbVagkxMXvCf@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CO1PR10MB4689:EE_
x-ms-office365-filtering-correlation-id: af49687d-34eb-47b1-8556-08daa00919ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fEz8L+spi7oChYjI8NA3P0cqR+0sOFvenGCH5JZxLFOPNHdlj5+udCavFfP3IvQvl0ZEN/8LE5/ViUTpibsjxkN2HsmqDULPbkLULojpDuUaj3rla1Ot+I2wXIK7cqSWnbJWXIlPqXJprS+zgktf91E2sjB/4i7KC97ZHnA4CuFTndkk4qMXhuer0NQxOLF7HAiS/gpb3q5R8P9unAO7tNeFEAM3xVbpzLppdNQ/WZqncVKrpo12uhppapNg3djh3S518zzH16LjD3ujTOHvb5V97R7gqRlvKwTPVSEOAXlWWUI1qJYbIy2Jv9UaSiv23atFzwb+wrIzN/HF+aMzUignBZBcsJN8stj/k1q7dSVNwWvpUq9dX3jjHnZ+w3USvjB+t5Seow9U9jP801YdmCNn+VIcuxMqxJuA/5VzTsxAxDaqBh/WXX7RToS3jum+udCkiqMWXMn7SBPTj8xvaBiowjNw87se5+gLwdr+YukB3hBlzCN4RW1vK47IdjasTTge74k/ozZCRf/h+UZVuOTUiVMYhUEz8tYeKhnXh5Dh2NE/VDJUj9Kbt2Q+VLb14ptYUDWS4JyMoj3RKGLOwMEwUbNGKh7HwcDiQFe/UvjDq5LZm+o5b2yv3yN9lXJ7hzA8//vfxQW0Rn4qsTtbbU/5Urzcpa6PyVFF2325AWw1u8B/DAIj5vl3xZYgGfI634N6LMeiwFjcLfK74zgyq2JCwMGvKawU5aYKKA8QeAUWomNjUtVobA2i418w5GuINXSiy+sAiOaFuothaNXANA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199015)(122000001)(2616005)(36756003)(2906002)(186003)(86362001)(44832011)(8936002)(38070700005)(6512007)(64756008)(66446008)(66476007)(66556008)(41300700001)(26005)(4326008)(8676002)(66946007)(76116006)(5660300002)(83380400001)(316002)(6506007)(6916009)(478600001)(6486002)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MCsxS3BmdFc2Q1ZKZ3lSbTNHN2dhM0hXNHJSSTV4S2NjaWtxdmNHTFh6MXZn?=
 =?utf-8?B?UzREUloyVEpIQTJUVGEwMmE2UHpFdWF2dk9iT25ieDA3ZXM3a1l3cEZSU0hx?=
 =?utf-8?B?V0tpeUNscGxpcXR0ME0xUXFzUGc1OVJ2ZHNUZXB4OUM5ODlEK09CR2pBdVhT?=
 =?utf-8?B?QnI5UlMvd0lsNVA0NDljR0JOMGs4VFdOdWM0OXlaN2wyTStOWkM0TUo5aVpu?=
 =?utf-8?B?RU5LUEtWUlU2VDZVbXBvSGcyaHc0VEVGT1o1RXcrWFo2SWVQQjN5NjVxM0VK?=
 =?utf-8?B?c3ZXVmlLblBRWVc2M1cweEVJOEVRVUpqTzZwZG50RlcxYnR4cUpYaWxRZjV4?=
 =?utf-8?B?dFF0SFdPNkR3Rk00VWltMTNNTXNCRzJMSURKaGliZlg1bGhWZlRTMERkNzZX?=
 =?utf-8?B?YWEyV2dmWEExdFdDenNkdUdaZmN6QlorQWlIeTNRcjQ5RzQrU20xTUZtMXVR?=
 =?utf-8?B?QUx2ejNUM0lKbXg3OVBCVVNyNFVIc2pOZnRVd3BMNXlmZkNNV0UyY0xiS1RD?=
 =?utf-8?B?WVJYdTgwY1ZBQVdoK2FBVmJJenZ0b2EvaU90bHdlV3VkaENEd2JTY0oybEZV?=
 =?utf-8?B?bU9Bcy9kaDFRQ2ozSnRxU0tteFlHRHRabGEzejR1Q1lBWjJhRUtxNzJ5R0x2?=
 =?utf-8?B?Zm5XTjJkcmxJclprWEZDQS9lZVNSazIzNXRBcHZyVFNDeDExb0phdzlNYkJG?=
 =?utf-8?B?TnpyVlYrZ1hlcURvbTk5YmhVUHpvWXRWK3hQVzlLdTBJYklaaFJuYklxOFlr?=
 =?utf-8?B?eE8wVU1jdmtGOHpSVU9BN1RIMVJXYitsNitFbW4xSU5KSDdhMDlhTWxJK2da?=
 =?utf-8?B?OWZkL2ZkalZtL3JaUGl6dWg0NDVhQzQ4ckhJYVlFNlE3UlNYQkltQ3hJMmRr?=
 =?utf-8?B?cXhZTStwSS9sd3V1OUxGMEtyQUQxUE9JWG5YU2VDeFdza3JEdTRBV3NvNFRB?=
 =?utf-8?B?ZlNDbFQ1b0s2Q2EwNjVHQVllbWN1OGpvZkpwU3JQVlo5VDQzd1RZTTA2V21D?=
 =?utf-8?B?VmtXZGhoM1VGN25KZDFTYzlVU1Y3bmpNMzZGcVduYVA0TEc2VlVjWCtZeVBu?=
 =?utf-8?B?U1pxNGlaeUpydVdkRGUzQ0g1NXFQYisrZkhrS1JaME1HQTZrSjAzaXE2aVlZ?=
 =?utf-8?B?WDgwcTJtS0lqeXlvKzNJdVppZWtvZVdTeWpnc2RYdm0xZkxkK2JtaFJRa2xO?=
 =?utf-8?B?aDVJRjRxL2FsRjIwNEhkOGxZTFJqeXN5djR6QWEzenlzRGpJSk9VZCtLbndT?=
 =?utf-8?B?UVIwYmpaWDdQaHR4VHkrbnc2Tis0bE82dy85a0VmMXRYMVpmYjlYUUMzWWlR?=
 =?utf-8?B?TGZEdTA2SDNDbUhPbGhibE03WGlvcGFKU1pSRzZBdXk1cmNkRjFFR3pBZGFS?=
 =?utf-8?B?emNJenZlMHkwNG9BZ2h3QVMvWDR5QXNkc2xXa3VqV1VhWk4wbGNaYVlGaDRI?=
 =?utf-8?B?YUE4MmtSL0dnY3dJRHlQYWpqUm05M1Q4ZnhKek1EY1ZubGE3OEZCeDhQQUhk?=
 =?utf-8?B?QzZ1dHpZVVhrK1BmQS9oUGd4RjBoSXJsN1c1cUlPcUQzZ0dPaE5VMUlDZGFD?=
 =?utf-8?B?UENLSU5IaU9yM3RjcHc5K1ZzcGJNRGovL2M0RWVIYW0rblNIeUpLV3F0Vkpx?=
 =?utf-8?B?OHRkTGRlSHJha2p1V0RFczB3ejB2eCs4Rkg1SmtONkxWUVp6Z01FZ2JHd3JL?=
 =?utf-8?B?QzNURU41bzUvTHIvL0Z1b21qYXFQMGtBa3p1c09aYnBsMG5UeklCZWVLbmF5?=
 =?utf-8?B?OUt4ek4wV293YzVMMEVQZFFUbURPT2NJNFNWeW9YZnQvYXpZN0hidG9IbXpI?=
 =?utf-8?B?RlNqWGppL2FueW9jTGI2OEMzcktTNWRGYmtOYXZybTNmZjdVcE4xNjQ5bUR3?=
 =?utf-8?B?LzJGd3BHbjZySCt1bmp2bUhXNUpLZVNyOG0wdXh6SUphN3FkZDJ6YlY1V2hu?=
 =?utf-8?B?YkdlVXpiakUyNlN3SGFOVnppVkVmSkUzZTREZXRQcGdpLy9icUZXc1IxcC81?=
 =?utf-8?B?VHhnUWtUdDQ2UEpaTnFyVGhVN3V4dU9ZMzNYQkN0elMrcldUbU9RbVorZndB?=
 =?utf-8?B?a3VWSlR3STE3RXo0dXhKMm96czRJVFU2UU9vVlhvbG9ZM2pBemRVQUlIb3My?=
 =?utf-8?B?Z2JHaU9IY2pUR1Y0d1VldzkyNzRZRmtOWHJjcGFXNmNkbEdUMVFVMlFVYzNV?=
 =?utf-8?B?cHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <612132EC8FE629499A2E8F07E83264D9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af49687d-34eb-47b1-8556-08daa00919ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 21:50:17.2011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lzIyQEVV8pBI8iKz123L8vhyCVAFZSQ6slnjXf1/l1414PqigRDvvrNfglFin/5qZOa+5f+jW4o3qeSnESzit+lz+81e02hlg7Isbxp1KKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_10,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260134
X-Proofpoint-GUID: GqxzWJHQq5qjPbfv_y4qOFGa0p7Q1ZhN
X-Proofpoint-ORIG-GUID: GqxzWJHQq5qjPbfv_y4qOFGa0p7Q1ZhN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDE0OjQ4IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
DQo+IE9uIFdlZCwgU2VwIDIxLCAyMDIyIGF0IDEwOjQ0OjU4UE0gLTA3MDAsDQo+IGFsbGlzb24u
aGVuZGVyc29uQG9yYWNsZS5jb23CoHdyb3RlOg0KPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29u
IDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPg0KPiANCj4gVGhpcyBvbmUgaXMgdG90YWxs
eSB1bmNoYW5nZWQgZnJvbSB3aGVuIEkgc2VudCBpdC7CoCBTbzoNCj4gDQo+IEZyb206IERhcnJp
Y2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+IA0KPiA+IEhhdmluZyBlc3RhYmxpc2hl
ZCB0aGF0IHdlIGNhbiByZWR1Y2UgdGhlIG1pbmltdW0gbG9nIHNpemUNCj4gPiBjb21wdXRhdGlv
bg0KPiA+IGZvciBmaWxlc3lzdGVtcyB3aXRoIHBhcmVudCBwb2ludGVycyBvciBhbnkgbmV3ZXIg
ZmVhdHVyZSwgd2UNCj4gPiBzaG91bGQNCj4gPiBhbHNvIGRyb3AgdGhlIGNvbXBhdCBtaW5sb2dz
aXplIGNvZGUgdGhhdCB3ZSBhZGRlZCB3aGVuIHdlIHJlZHVjZWQNCj4gPiB0aGUNCj4gPiB0cmFu
c2FjdGlvbiByZXNlcnZhdGlvbiBzaXplIGZvciBybWFwIGFuZCByZWZsaW5rLg0KPiA+IA0KPiA+
IFNpZ25lZC1vZmYtYnk6IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+ID4g
U2lnbmVkLW9mZi1ieTogQWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNs
ZS5jb20+DQo+IA0KPiBDaGFuZ2UgdGhpcyB0bw0KPiANCj4gUmV2aWV3ZWQtYnk6IEFsbGlzb24g
SGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPg0KU3VyZSwgYXMgbG9uZyBh
cyBmb2xrcyBhcmUgb2sgd2l0aCB0aGF0IDotKQ0KDQpBbGxpc29uDQoNCj4gDQo+IGFuZCB0aGlz
IHBhdGNoIGlzIGFsc28gZG9uZS4NCj4gDQo+IC0tRA0KPiANCj4gPiAtLS0NCj4gPiDCoGZzL3hm
cy9saWJ4ZnMveGZzX2xvZ19ybGltaXQuYyB8IDEwICsrKysrKysrKysNCj4gPiDCoDEgZmlsZSBj
aGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy9s
aWJ4ZnMveGZzX2xvZ19ybGltaXQuYw0KPiA+IGIvZnMveGZzL2xpYnhmcy94ZnNfbG9nX3JsaW1p
dC5jDQo+ID4gaW5kZXggZTVjNjA2ZmI3YTZhLi43NDgyMWM3ZmQwY2MgMTAwNjQ0DQo+ID4gLS0t
IGEvZnMveGZzL2xpYnhmcy94ZnNfbG9nX3JsaW1pdC5jDQo+ID4gKysrIGIvZnMveGZzL2xpYnhm
cy94ZnNfbG9nX3JsaW1pdC5jDQo+ID4gQEAgLTkxLDYgKzkxLDE2IEBAIHhmc19sb2dfY2FsY190
cmFuc19yZXN2X2Zvcl9taW5sb2dibG9ja3MoDQo+ID4gwqB7DQo+ID4gwqDCoMKgwqDCoMKgwqDC
oHVuc2lnbmVkIGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJtYXBfbWF4bGV2ZWxzID0gbXAt
DQo+ID4gPm1fcm1hcF9tYXhsZXZlbHM7DQo+ID4gwqANCj4gPiArwqDCoMKgwqDCoMKgwqAvKg0K
PiA+ICvCoMKgwqDCoMKgwqDCoCAqIFN0YXJ0aW5nIHdpdGggdGhlIHBhcmVudCBwb2ludGVyIGZl
YXR1cmUsIGV2ZXJ5IG5ldyBmcw0KPiA+IGZlYXR1cmUNCj4gPiArwqDCoMKgwqDCoMKgwqAgKiBk
cm9wcyB0aGUgb3ZlcnNpemVkIG1pbmltdW0gbG9nIHNpemUgY29tcHV0YXRpb24NCj4gPiBpbnRy
b2R1Y2VkIGJ5IHRoZQ0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIG9yaWdpbmFsIHJlZmxpbmsgY29k
ZS4NCj4gPiArwqDCoMKgwqDCoMKgwqAgKi8NCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoeGZzX2hh
c19wYXJlbnRfb3JfbmV3ZXJfZmVhdHVyZShtcCkpIHsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgeGZzX3RyYW5zX3Jlc3ZfY2FsYyhtcCwgcmVzdik7DQo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybjsNCj4gPiArwqDCoMKgwqDCoMKgwqB9DQo+ID4g
Kw0KPiA+IMKgwqDCoMKgwqDCoMKgwqAvKg0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgKiBJbiB0aGUg
ZWFybHkgZGF5cyBvZiBybWFwK3JlZmxpbmssIHdlIGFsd2F5cyBzZXQgdGhlDQo+ID4gcm1hcCBt
YXhsZXZlbHMNCj4gPiDCoMKgwqDCoMKgwqDCoMKgICogdG8gOSBldmVuIGlmIHRoZSBBRyB3YXMg
c21hbGwgZW5vdWdoIHRoYXQgaXQgd291bGQgbmV2ZXINCj4gPiBncm93IHRvDQo+ID4gLS0gDQo+
ID4gMi4yNS4xDQo+ID4gDQoNCg==
