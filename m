Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A22C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jan 2022 21:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343587AbiASViS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:38:18 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10558 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234306AbiASViS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 16:38:18 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JJSHft031217;
        Wed, 19 Jan 2022 21:38:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PEseCiaA5eiNNUDt2Ya1KA3L3AOaBJ0gm/P0y2mJe0s=;
 b=hiNA50kqRb08OW/7FAhKI4R3dSJSNqK9LeiQe27F5714+nqvEW0X61OBp9QF63X08J/j
 lrGz3jn9CP31eaUWP3gx2dDHgP+z+8SMOyCCbz2EHaKCjsH1pc0JVomEULSzCXRLY6b4
 MGGgUaKSD2hT16tQ3EqV620MET68orq4Gql6bxYDdti/oEa5aPIGfUEoog+1KaYRLmjR
 ebLna2eQHvPrLWWAw7K5xw3GSpbuAZS/rvLQH4V7gkNAPXSAnogf5yfGN22ge4tGjwv1
 yslG71onFVtlMdITO9RLovilouD3EJSXoNKwGJQTJi0+MJ3lpDYhqwkM4B8kuTli4Zzv rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4vpg9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 21:38:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20JLauZg147060;
        Wed, 19 Jan 2022 21:38:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3030.oracle.com with ESMTP id 3dkmaeb1b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 21:38:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALlrAH3p4HFvuRq9eXhYgyMCswiHeSDIP7krG8dg3FzB2U9/hGhnqfTEDr8Uo9xQRYN0zyGcv/aELKhhsdRHkKgRPdEG5FrzXHBlyxdgmWcjVoA5on7BVYtY9ra+1MABHYJFM4AtO+MDGumyokGBzVKOabJM/COOg8tfH2bLVY9Kwmri+zaJnzNpbKz83E0F/EvokH7cbAHBwnnWg3oMjB0mgTYG3ILDewlyv1k2z9oyHN6w50qS71OAbKclzAvvRQUqTwXhWvXQyM5Yivf60JmFz8hP+QvEfgAPjJJHTBKHXPC/aXOU30SEE/ztQgRORuU1t0/CGv8tCC3dpOJdSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEseCiaA5eiNNUDt2Ya1KA3L3AOaBJ0gm/P0y2mJe0s=;
 b=Pj3iK0kLExlhWqoOeiqJoUDnWzKXaUep21qrYyUB9TXTVQcLF/MXHxMp8VXBDp4/Qm/IvFtqUCRrkCVBy+DERUSObs0wvcCCa4CqLylO1E0D5ptaBa3G82wL2RJn6wye3Zl+DxLBerRctqojooyvz0oMFx/ZuZZpEPH70XLILk7KWdiLyRp2RZE7wLxDkIuii8T4Ya4SmW9uFW3h8fdt5ytPXlxh92CpoLi1BCU1Tv+67/22X7qvXeKCyLLL/yaNZZgJtaGfLcnLwIOIkF6KUWTUbyr21hlVRxkVtxdcBpqQj2nvTO8m/TR2dj7iz6ql+N6/teD2/aGGKYVPVBe8FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEseCiaA5eiNNUDt2Ya1KA3L3AOaBJ0gm/P0y2mJe0s=;
 b=xbm07Pyc8oJG4zb8DfufUKtQfFcBgWhDDDH5Wa1dqn2m+MSt2IVyp5nbRO97xE/Rv3c8pYsni4K07PxrpQumqg8wMMkujWcm9rgb3od7W47eVtLgEtMZVjo8Bw6ctQ3kk/Z1JQUkaAJP4tBj4W+5ohbERQWOGrjoTJSIdhrjtt8=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 CH0PR10MB5116.namprd10.prod.outlook.com (2603:10b6:610:d9::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.8; Wed, 19 Jan 2022 21:38:12 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%5]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 21:38:12 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/2] xfs: add leaf split error tag
Thread-Topic: [RFC PATCH v2 1/2] xfs: add leaf split error tag
Thread-Index: AQHYDXzcdl7d9uKuNkWEZoZ+h+xWvA==
Date:   Wed, 19 Jan 2022 21:38:12 +0000
Message-ID: <BCDAD185-8E16-4750-A876-D53AC4456B6D@oracle.com>
References: <20220110212454.359752-1-catherine.hoang@oracle.com>
 <20220110212454.359752-2-catherine.hoang@oracle.com>
 <20220119044759.GF13540@magnolia>
In-Reply-To: <20220119044759.GF13540@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1830a6f-7182-4ed4-1521-08d9db93fe8c
x-ms-traffictypediagnostic: CH0PR10MB5116:EE_
x-microsoft-antispam-prvs: <CH0PR10MB5116383D2D8B060BA56C10D689599@CH0PR10MB5116.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 57uR/0+ZFllc2CMXtnOV9UUN8FSJpEz14yEIQCdr9kSVpMLkreYsVN/OGh5n15uKA01VJWKCRyiLeB0IBY23/liS2E5VJyltCgE041iIIQB5iCWZefSwgjSBYaCFwaRV913QC5mhpMNB79EUaPUGj8ojWkD+BqDr0l3zHvtubDtBTPIwVM3txkL2OzuGh9O+hAGxsnuvA/sMuEFsoWtmDzXE7lmGTmW0W68d/YRKLK+Kw4aMsoE1W+ptSirK2EONDpNyI5nFHikQUbMs3CFsA+7z3Ehw8zcb2hs+tntoLSwLLLp/0ByoQT9JvkoC9Hn8isMEW9MMhbCHHIhTvFD0pw3Y772wNnDqeFanv7kJsALdKNc/uYy7ftG0ZXuAIc1bq7kMgsz2zP90SJ8oLVBuEXFFMm8kZ++anQuX1OyrtaPKxhLXcZybP5RFbq9efYCOhhtPTP6FvXWa96o8JzAflO0j+/ImUL19ZUY98QpjY1iVWYm3Z8sTkh1qp8SF/MIxEENwW82PgHHgNvMKqJ0SozmoAdOuncnIAp3vn65AowZApWyiYLIe9fKoxZUfIlHIvYz8laodQmqq78JTMpbX6O5YSnmo+97M8JJxp63OYG167eJufKwJj9cd0s1xmQArNLi4+W+Xfneo2Ew4smrdQYCKnVC89Ya8HtAXfbljvbw+tOCHnQrkqWiQrLIFUGTKklPTVm32K/sNsGXoNV3rE1PnRMftFGYM5tqMbgaaYORr3WM7qufy4JiXuf5Vr7CN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(38070700005)(2616005)(508600001)(66946007)(44832011)(8676002)(36756003)(91956017)(83380400001)(66556008)(66476007)(76116006)(64756008)(66446008)(71200400001)(8936002)(33656002)(6506007)(6916009)(53546011)(6486002)(5660300002)(38100700002)(122000001)(6512007)(316002)(186003)(4326008)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWtRbGVKendqRnZBV1NaQ0c0d1g2R1RRd3EyR2g3a3dLd1JVWGtRQnVLbjZT?=
 =?utf-8?B?Y040a2d1a1ZBVWZHdklVRmRpTFNlUXJEQU5jYXF2aWdNSlRVbHJVSXhSSGlx?=
 =?utf-8?B?ejVGenpHMHN6TmpqbndCSWlrMUFCSXEveC80QnV5L0FJMDRsTzJXYjNkcHJM?=
 =?utf-8?B?K2JwME9wdTNpdUJYMXlKejVWSXNOTGtVWVBhcmNNcU96YkJLSHRsRFo0MS9m?=
 =?utf-8?B?a0xCcS9OcFoxZWpFV2NCZjlsbjJUT1dtQkhUOG42U3RyTVk5dzNKc2VZa1Zi?=
 =?utf-8?B?RDZNRWNmTWo1V0ZJSHBURGF4dG15a1dOdlgyTmhHdCtwRU85ampFYnp4RWZw?=
 =?utf-8?B?a3RKQnl0dGxkOW9vd2JvS2NLcklYT3dUNUNKeGlWcGlqeDNEVDVWKzB6M1c3?=
 =?utf-8?B?T3M2TXNhUXovZ08wNDYxZkNFVGVFTGYrNDhrS1VxajAvc3R0WG53VFpVTE9q?=
 =?utf-8?B?MGgxUExYZ3lIQ21vbWp4UWRLR3h3QTk2blFYc0tFMkkveG84OUxzSXduWVNu?=
 =?utf-8?B?djRrdm1wQnk4Yi9ubjRMWTNZVXpmaXczU1F3M05mNXRPZkZpNzRnNHhBNUI1?=
 =?utf-8?B?QmJvZVAvQUpWVzJlay9mNTR0M0xWZUw1K3lyT010RlRlVU1NN04waFZldTZ3?=
 =?utf-8?B?MUkzWVpaK3ZmNkFqTW84ZE5xc1BEWGNDZzdnUnYyS2dIenI2UzNQR0xIVno4?=
 =?utf-8?B?SVQyRkhlWXZRTzkvWVM1bTNVcEdUNVJ6eUtsd2Q0bzUvQXNrU3BIOXdDV0VW?=
 =?utf-8?B?NXduR3hxdjRhUDM2ME1UaHFHbGtWeUxFU3VtMmVVRDJoTXRqZnNOVHUyQXc4?=
 =?utf-8?B?Rm1Pdlcwc3Q5dk5hV1QxTlRIeXo1MnkrZ0d2NDg1T1JNMXg1WFFaTTl1T3cr?=
 =?utf-8?B?NUNlQU80NUdWbVZSYStEYkFrMmZDVlNRdmNDVThiQXMzM3M4U2Y4RjE0UkNV?=
 =?utf-8?B?a3FtRk9PRDRPL09ic3UrUmRONy9sRlJRdlNIZWxMd3FYZW9PWWcrMUZRYkVJ?=
 =?utf-8?B?VzVjZjh6eldOdWRTU2crMGV0cE9GWDBlbklUUm5wamhmVEY4eGs3VkRnbWxv?=
 =?utf-8?B?TVdLcExtTkFOTjU5WVJKdGJLQ3VwM1UwQ2xWUU9LTVpHV2l5RmkwOUIzZW9o?=
 =?utf-8?B?OWYzdmt4WGxtVnhnUHpsUmtxRjk4M0c0VWo3a1hwbUcrNS9CMVhCUHQzUVJL?=
 =?utf-8?B?bTlCdzRyTW9EdUNxRU03elZHT1hDWHd2R1FLeU1vSVdPNHNjYlVQRm1JYXlE?=
 =?utf-8?B?UDc5RDE2amdrb1pSTnBxMExveks1MHpRaGVNNS9qSUVzL2JtRlk4b0NQck9N?=
 =?utf-8?B?RlR1eDd6Z0lpWHovSlJ0VTQweXFOSWhJTW5vWm4yUFRLTFhIQnVKODQrU3Zt?=
 =?utf-8?B?RFVaL21zR0VIZFVCdmIxcFJZUGFlblR2cVY1ZU9tenM5d0VFYjhJcHh6akJE?=
 =?utf-8?B?NnovbHN6aWRWR1M2MU5GUVBnYVRlRnNYVkJFK0hwZi9MVGcvQ1FRbk5oZmJp?=
 =?utf-8?B?SlFGMWVCWFJSRFBhWGRBa2JwRGlQbHNGR1ErejVzemxZKzhFR3BPUStXb2pL?=
 =?utf-8?B?SkpyN3JvYldoQzJCVzg2MCtzNjRFbGhhVW5qR1FBemd4NkpEWVRCdXg0SEdT?=
 =?utf-8?B?dk5zakNrZE80Y24ydk9iNVFjSjJ2NmJNQVVlYk5CckJudjhZa2JFMGlqVDBi?=
 =?utf-8?B?OHhGWWRQTmpvQzErdzN5TVVuTFhvZjZybEprZW9USC9YKzZPc1p5OG8zM1pS?=
 =?utf-8?B?SkJvOEFVZ3c2N1p0eWVpV1c0czJaT204bk9VbExXaEN6LzlNZExScWVnOVRx?=
 =?utf-8?B?dld4UXVCL21qdEo1QUZiejBaZTVZM1JnZXF0MHVoWmJ1NDMyU3NNZWFEQUFl?=
 =?utf-8?B?Y29ZRHE3N1dJTzhWQnVvb09jREhVZExqejlnd2FNTDVNYmwxYVRwTmdkT093?=
 =?utf-8?B?SXhGNmFtNTFrVVFESTBtZ1BQMURZMEt3amZweGJBdG8zSEJnSnRYazhtdUMw?=
 =?utf-8?B?NlBib0l6Yjc2UUhieEErTmFUVE5oZ2ZNU3FOSmd1MFZlc0ozVkRPMURGWXhR?=
 =?utf-8?B?d1pEeGhOTUNzWWZZbnUyZDFkVDZDbGw2Q1VyVXZoWDZJSVArUWN6OVluZUZl?=
 =?utf-8?B?Z0FTakZwUExKTmNrL0xVenVCNVNsQzR3NmJvemxrYmhuNENpU2ZINmpiQXo4?=
 =?utf-8?B?eXBreXhuZWRHL2k0REpmNk8vZmlXTlNZVUxITFRBTlRlRVV5OHIzamgwQ3kw?=
 =?utf-8?B?UUhlRjMwZEQwL1oxWnJ4UGNydmlKOGFDWk56SnlNMU9rNmdSUFdwekdJQXB5?=
 =?utf-8?B?bkZoL29jTGQyTVhlVFdSWUF3d0NTYVBpY0ZLNHF0cFkxUHJFMGV4NUZ6RWw1?=
 =?utf-8?Q?Rd/Z7NWvOOo+j2Bw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19F45DB95C0C05498321DB2B4318F0EC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1830a6f-7182-4ed4-1521-08d9db93fe8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 21:38:12.5905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FXucTKccDHAOkoUuVqatpkSlnOPcqiNl2swmOuDvCwCkG4f0BCWaEYSA5Em2yNbKikEzXMyv9WLxRfDnIPUO4hjjg+MVf/r9Nx3GBnxnnSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5116
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201190117
X-Proofpoint-GUID: JOnmxlnhdGVYqKyyxI3r70ANd-Ca1EAR
X-Proofpoint-ORIG-GUID: JOnmxlnhdGVYqKyyxI3r70ANd-Ca1EAR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBKYW4gMTgsIDIwMjIsIGF0IDg6NDcgUE0sIERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtl
cm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gTW9uLCBKYW4gMTAsIDIwMjIgYXQgMDk6MjQ6NTNQ
TSArMDAwMCwgQ2F0aGVyaW5lIEhvYW5nIHdyb3RlOg0KPj4gQWRkIGFuIGVycm9yIHRhZyBvbiB4
ZnNfZGEzX3NwbGl0IHRvIHRlc3QgbG9nIGF0dHJpYnV0ZSByZWNvdmVyeQ0KPj4gYW5kIHJlcGxh
eS4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogQ2F0aGVyaW5lIEhvYW5nIDxjYXRoZXJpbmUuaG9h
bmdAb3JhY2xlLmNvbT4NCj4+IFJldmlld2VkLWJ5OiBBbGxpc29uIEhlbmRlcnNvbiA8YWxsaXNv
bi5oZW5kZXJzb25Ab3JhY2xlLmNvbT4NCj4+IC0tLQ0KPj4gZnMveGZzL2xpYnhmcy94ZnNfZGFf
YnRyZWUuYyB8IDUgKysrKysNCj4+IGZzL3hmcy9saWJ4ZnMveGZzX2Vycm9ydGFnLmggfCA0ICsr
Ky0NCj4+IGZzL3hmcy94ZnNfZXJyb3IuYyAgICAgICAgICAgfCAzICsrKw0KPj4gMyBmaWxlcyBj
aGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+PiANCj4+IGRpZmYgLS1n
aXQgYS9mcy94ZnMvbGlieGZzL3hmc19kYV9idHJlZS5jIGIvZnMveGZzL2xpYnhmcy94ZnNfZGFf
YnRyZWUuYw0KPj4gaW5kZXggZGQ3YTJkYmNlMWQxLi4yNThhNWZlZjY0YjIgMTAwNjQ0DQo+PiAt
LS0gYS9mcy94ZnMvbGlieGZzL3hmc19kYV9idHJlZS5jDQo+PiArKysgYi9mcy94ZnMvbGlieGZz
L3hmc19kYV9idHJlZS5jDQo+PiBAQCAtMjIsNiArMjIsNyBAQA0KPj4gI2luY2x1ZGUgInhmc190
cmFjZS5oIg0KPj4gI2luY2x1ZGUgInhmc19idWZfaXRlbS5oIg0KPj4gI2luY2x1ZGUgInhmc19s
b2cuaCINCj4+ICsjaW5jbHVkZSAieGZzX2Vycm9ydGFnLmgiDQo+PiANCj4+IC8qDQo+PiAgKiB4
ZnNfZGFfYnRyZWUuYw0KPj4gQEAgLTQ4Miw2ICs0ODMsMTAgQEAgeGZzX2RhM19zcGxpdCgNCj4+
IA0KPj4gCXRyYWNlX3hmc19kYV9zcGxpdChzdGF0ZS0+YXJncyk7DQo+PiANCj4+ICsJaWYgKFhG
U19URVNUX0VSUk9SKGZhbHNlLCBzdGF0ZS0+bXAsIFhGU19FUlJUQUdfTEFSUF9MRUFGX1NQTElU
KSkgew0KPiANCj4gVGhpcyBlcnJvciBpbmplY3Rpb24ga25vYiBpcyBpbiB0aGUgbWlkZGxlIG9m
IHRoZSBkYWJ0cmVlIGNvZGUsIHNvIGl0DQo+IHJlYWxseSBvdWdodCB0byBiZSBuYW1lc3BhY2Vk
IF9EQV8gYW5kIG5vdCBfTEFSUF86DQo+IA0KPiBYRlNfRVJSVEFHX0RBX0xFQUZfU1BMSVQNCg0K
T2ssIHRoaXMgbWFrZXMgc2Vuc2UuIFdpbGwgZml4LCB0aGFua3MgZm9yIHRoZSBleHBsYW5hdGlv
biENCj4gDQo+IEEgYml0IG9mIGJhY2tncm91bmQ6IGluIFhGUywgZGlyZWN0b3JpZXMgYW5kIGV4
dGVuZGVkIGZpbGUgYXR0cmlidXRlcw0KPiBib3RoIHN0YXJ0IHRoZWlyIGxpdmVzIGFzIGFycmF5
cyBvZiB2YXJpYWJsZSBsZW5ndGggcmVjb3JkcyB0aGF0IG1hcCBhDQo+IG5hbWUgdG8gc29tZSBz
b3J0IG9mIGJpbmFyeSBkYXRhLiAgRGlyZWN0b3J5IGVudHJpZXMgbWFwIGEgaHVtYW4tDQo+IHJl
YWRhYmxlIGJ5dGVzdHJpbmcgdG8gYW4gaW5vZGUgbnVtYmVyLCBhbmQgeGF0dHJzIG1hcCBhIG5h
bWVzcGFjZWQNCj4gaHVtYW4tcmVhZGFibGUgYnl0ZXN0cmluZyB0byBhIGJsb2Igb2YgYmluYXJ5
IGRhdGEuDQo+IA0KPiBUbyBzcGVlZCB1cCBsb29rdXBzIGJ5IG5hbWUsIGJvdGggc3RydWN0dXJl
cyBzdXBwb3J0IGFkZGluZyBhIGJ0cmVlDQo+IGluZGV4IHRoYXQgbWFwcyB0aGUgaHVtYW4tcmVh
ZGFibGUgbmFtZSB0byBhIGhhc2ggdmFsdWUsIHRoZW4gbWFwcyB0aGUNCj4gaGFzaCB2YWx1ZShz
KSB0byBwb3NpdGlvbnMgd2l0aGluIHRoZSBhcnJheS4gIFdpdGhpbiB0aGUgeGZzIGNvZGViYXNl
LA0KPiB0aGF0IGJ0cmVlIGlzIGNhbGxlZCB0aGUgImRhYnRyZWUiIHRvIGRpc3Rpbmd1aXNoIGl0
IGZyb20geGZzX2J0cmVlLA0KPiB3aGljaCBpcyBhIHRvdGFsbHkgZGlmZmVyZW50IGFuaW1hbC4N
Cj4gDQo+IEhlbmNlLCBhbnkgZXJyb3IgaW5qZWN0aW9uIGtub2JzIHRvdWNoaW5nIHhmc19kYSog
ZnVuY3Rpb25zIHJlYWxseQ0KPiBzaG91bGQgYmUgbmFtZXNwYWNlZCBfREFfIHRvIG1hdGNoLg0K
PiANCj4gKEFuZCBmb3IgZXZlcnlvbmUgZWxzZSBmb2xsb3dpbmcgYWxvbmcgYXQgaG9tZSwgIkxB
UlAiIHJlZmVycyB0byBMb2dnaW5nDQo+IGV4dGVuZGVkIEF0dHJpYnV0ZXMgdGhhdCBhcmUgUmVw
bGF5YWJsZSBvbiBQdXJwb3NlIG9yIHNvbWV0aGluZyBsaWtlDQo+IHRoYXQuKQ0KPiANCj4+ICsJ
CXJldHVybiAtRUlPOw0KPj4gKwl9DQo+IA0KPiBOaXQ6IGRvbid0IG5lZWQgYnJhY2VzIGZvciBh
IHNpbmdsZS1saW5lIGlmIGJvZHkuDQo+IA0KPiBPdGhlciB0aGFuIHRob3NlIHR3byB0aGluZ3Ms
IHRoaXMgbG9va3MgZ29vZCB0byBtZS4NCj4gDQo+IC0tRA0KDQpTdXJlLCBJ4oCZbGwgcmVtb3Zl
IHRoZSBicmFjZXMgaGVyZS4NCj4gDQo+PiArDQo+PiAJLyoNCj4+IAkgKiBXYWxrIGJhY2sgdXAg
dGhlIHRyZWUgc3BsaXR0aW5nL2luc2VydGluZy9hZGp1c3RpbmcgYXMgbmVjZXNzYXJ5Lg0KPj4g
CSAqIElmIHdlIG5lZWQgdG8gaW5zZXJ0IGFuZCB0aGVyZSBpc24ndCByb29tLCBzcGxpdCB0aGUg
bm9kZSwgdGhlbg0KPj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy9saWJ4ZnMveGZzX2Vycm9ydGFnLmgg
Yi9mcy94ZnMvbGlieGZzL3hmc19lcnJvcnRhZy5oDQo+PiBpbmRleCBjMTVkMjM0MDIyMGMuLjk3
MGYzYTNmMzc1MCAxMDA2NDQNCj4+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX2Vycm9ydGFnLmgN
Cj4+ICsrKyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2Vycm9ydGFnLmgNCj4+IEBAIC02MCw3ICs2MCw4
IEBADQo+PiAjZGVmaW5lIFhGU19FUlJUQUdfQk1BUF9BTExPQ19NSU5MRU5fRVhURU5UCQkzNw0K
Pj4gI2RlZmluZSBYRlNfRVJSVEFHX0FHX1JFU1ZfRkFJTAkJCQkzOA0KPj4gI2RlZmluZSBYRlNf
RVJSVEFHX0xBUlAJCQkJCTM5DQo+PiAtI2RlZmluZSBYRlNfRVJSVEFHX01BWAkJCQkJNDANCj4+
ICsjZGVmaW5lIFhGU19FUlJUQUdfTEFSUF9MRUFGX1NQTElUCQkJNDANCj4+ICsjZGVmaW5lIFhG
U19FUlJUQUdfTUFYCQkJCQk0MQ0KPj4gDQo+PiAvKg0KPj4gICogUmFuZG9tIGZhY3RvcnMgZm9y
IGFib3ZlIHRhZ3MsIDEgbWVhbnMgYWx3YXlzLCAyIG1lYW5zIDEvMiB0aW1lLCBldGMuDQo+PiBA
QCAtMTA1LDUgKzEwNiw2IEBADQo+PiAjZGVmaW5lIFhGU19SQU5ET01fQk1BUF9BTExPQ19NSU5M
RU5fRVhURU5UCQkxDQo+PiAjZGVmaW5lIFhGU19SQU5ET01fQUdfUkVTVl9GQUlMCQkJCTENCj4+
ICNkZWZpbmUgWEZTX1JBTkRPTV9MQVJQCQkJCQkxDQo+PiArI2RlZmluZSBYRlNfUkFORE9NX0xB
UlBfTEVBRl9TUExJVAkJCTENCj4+IA0KPj4gI2VuZGlmIC8qIF9fWEZTX0VSUk9SVEFHX0hfICov
DQo+PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19lcnJvci5jIGIvZnMveGZzL3hmc19lcnJvci5j
DQo+PiBpbmRleCBkNGIyMjU2YmEwMGIuLjljYjY3NDNhNWFlMyAxMDA2NDQNCj4+IC0tLSBhL2Zz
L3hmcy94ZnNfZXJyb3IuYw0KPj4gKysrIGIvZnMveGZzL3hmc19lcnJvci5jDQo+PiBAQCAtNTgs
NiArNTgsNyBAQCBzdGF0aWMgdW5zaWduZWQgaW50IHhmc19lcnJvcnRhZ19yYW5kb21fZGVmYXVs
dFtdID0gew0KPj4gCVhGU19SQU5ET01fQk1BUF9BTExPQ19NSU5MRU5fRVhURU5ULA0KPj4gCVhG
U19SQU5ET01fQUdfUkVTVl9GQUlMLA0KPj4gCVhGU19SQU5ET01fTEFSUCwNCj4+ICsJWEZTX1JB
TkRPTV9MQVJQX0xFQUZfU1BMSVQsDQo+PiB9Ow0KPj4gDQo+PiBzdHJ1Y3QgeGZzX2Vycm9ydGFn
X2F0dHIgew0KPj4gQEAgLTE3Miw2ICsxNzMsNyBAQCBYRlNfRVJST1JUQUdfQVRUUl9SVyhyZWR1
Y2VfbWF4X2lleHRlbnRzLAlYRlNfRVJSVEFHX1JFRFVDRV9NQVhfSUVYVEVOVFMpOw0KPj4gWEZT
X0VSUk9SVEFHX0FUVFJfUlcoYm1hcF9hbGxvY19taW5sZW5fZXh0ZW50LAlYRlNfRVJSVEFHX0JN
QVBfQUxMT0NfTUlOTEVOX0VYVEVOVCk7DQo+PiBYRlNfRVJST1JUQUdfQVRUUl9SVyhhZ19yZXN2
X2ZhaWwsIFhGU19FUlJUQUdfQUdfUkVTVl9GQUlMKTsNCj4+IFhGU19FUlJPUlRBR19BVFRSX1JX
KGxhcnAsCQlYRlNfRVJSVEFHX0xBUlApOw0KPj4gK1hGU19FUlJPUlRBR19BVFRSX1JXKGxhcnBf
bGVhZl9zcGxpdCwJWEZTX0VSUlRBR19MQVJQX0xFQUZfU1BMSVQpOw0KPj4gDQo+PiBzdGF0aWMg
c3RydWN0IGF0dHJpYnV0ZSAqeGZzX2Vycm9ydGFnX2F0dHJzW10gPSB7DQo+PiAJWEZTX0VSUk9S
VEFHX0FUVFJfTElTVChub2Vycm9yKSwNCj4+IEBAIC0yMTQsNiArMjE2LDcgQEAgc3RhdGljIHN0
cnVjdCBhdHRyaWJ1dGUgKnhmc19lcnJvcnRhZ19hdHRyc1tdID0gew0KPj4gCVhGU19FUlJPUlRB
R19BVFRSX0xJU1QoYm1hcF9hbGxvY19taW5sZW5fZXh0ZW50KSwNCj4+IAlYRlNfRVJST1JUQUdf
QVRUUl9MSVNUKGFnX3Jlc3ZfZmFpbCksDQo+PiAJWEZTX0VSUk9SVEFHX0FUVFJfTElTVChsYXJw
KSwNCj4+ICsJWEZTX0VSUk9SVEFHX0FUVFJfTElTVChsYXJwX2xlYWZfc3BsaXQpLA0KPj4gCU5V
TEwsDQo+PiB9Ow0KPj4gDQo+PiAtLSANCj4+IDIuMjUuMQ0KPj4gDQoNCg==
