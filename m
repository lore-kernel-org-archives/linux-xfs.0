Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF30C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 20:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiJYUuA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 16:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJYUt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 16:49:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C79519002
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 13:49:57 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PKhp2Y015850;
        Tue, 25 Oct 2022 20:49:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=1e0u5xUDK9ZcGGTPbMSzw5PIJr+OUwA2QlDgnGufxzA=;
 b=JBtW36apQvb8ITN+QMWslS+8UhatRGJbMYhgGiIzXT2em7jOue469+IrcDBshdPuUw1y
 4/fU7BNkychn+QRq/ezP/ojngyxKfcpa3GYag2ZOw0HULmmOcdPbNrgHpHFulcYdYyAg
 V9fJ2VMzchi7dL4BHVgHs3Iozrs+w+fRIvDGrjfQ8EVGTHZw7iy6gNqXwUr+sq/5D1sZ
 uGqjE2CpbAVr/VYb+C9TG34KnyAcJLq49rwb2y65iVrdL5A8JbP3hg3ajPOEIL+IFV4c
 kF6PDAQyAnnlP7fsanoBtfOJsqrRNykPmoDQD0nmLdBe2CQMZYhWYPoCf7fOHWzoCkd4 kg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xe42y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:49:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29PK0HnE017232;
        Tue, 25 Oct 2022 20:49:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y58prw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:49:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNKnrbLBWF+aqH/L+l5BBTqIwdIvDet8Xn3WQ1qsmcXw9U+3XvyUTXyJt8mFf9wyZ5M8MuXT+ypq/tuRM0XX6fkNnq3/sAiNq/eO7woKEVvHqiVkNJVOndyrrB0JYLWc6lc9HW+8g3joO68rRGSuEfA1lxI6ePcxmlm7cJ/1FB4g6eMFQ9f7wNvZsDYvLNjsivjj/pQVQDrzMqS9hXIjc4Co+y4GfYvrwILBbRAz78JgdPyNnblmMFjgNmpa1C/sGxv0gFsvoZ6PY0X1ZXNFnr/7p97KkSEA1Ih3/iq8F6ihWrCW/Mjw9wTEUmmioPJcvaFKktZhPuYNPWKZc5+z8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1e0u5xUDK9ZcGGTPbMSzw5PIJr+OUwA2QlDgnGufxzA=;
 b=PhAJhvqLUyqjZkFH/1V8ntvLHwUZWI9PrVSEV+HQXwMCbCEN3+TnVs8t7RBJt5g2uCjQe7+ziA4VvVgBG24y7myuIadWktj1VK8lE8Sq/4qR5n32TdjFt1vcXESwYq+Gu1xyeN19K05UTwBpyCvhuqmwPQCwHC9GU7sDBv7wb3BPUqHzi/9AvbFlgQrPoOftridGvi+URDQiJfnXGyhslRdQ71v2UA8nb8vFChXyewMwjI2LudtaqZ+f3yKKfXe8uFPpyHEgNTUw6r8+DhC7pPTtmKpbwEsqq/dQB5pagVc61K6/iTKTBORgyFUT9NRVlYyIW6dWaILja2GKO2EBtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1e0u5xUDK9ZcGGTPbMSzw5PIJr+OUwA2QlDgnGufxzA=;
 b=bPkO3g9tu93kLLNa0w/x+5W5tCGIV7X8Sg5wh1jlkvA7CKNLRjI9fqd0iyv2C4il1Ih/hMYDa3PpJshPMyUHc8gbKbPur/67FstNt6No0UOiJgfaSNGVIl333FV9ZJ4Tj4Y1Rzk77N8aBYxA9Dpb63NmmZW8rW52tOOkIzxtYCs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB5287.namprd10.prod.outlook.com (2603:10b6:408:12f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Tue, 25 Oct
 2022 20:49:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5746.023; Tue, 25 Oct 2022
 20:49:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/6] xfs: fix memcpy fortify errors in RUI log format
 copying
Thread-Topic: [PATCH 4/6] xfs: fix memcpy fortify errors in RUI log format
 copying
Thread-Index: AQHY5/45OPRVwdqoIUyXgdwXEjhiTK4flqiA
Date:   Tue, 25 Oct 2022 20:49:49 +0000
Message-ID: <4acc57b10181f6c3c901033aad8a56b4f91c367e.camel@oracle.com>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
         <166664717418.2688790.4324481950746749054.stgit@magnolia>
In-Reply-To: <166664717418.2688790.4324481950746749054.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|BN0PR10MB5287:EE_
x-ms-office365-filtering-correlation-id: cf91b172-ff26-4e19-b575-08dab6ca758c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ne8rQeqdipq/SAqdUYXQ06rK3cwJxypNKyVPz9rmSMKaDAMjR1h6s9NpGZwZeHt1k2UL7WuzWVBMX2sgUJ7E/HrxnZFkwmS7RiXLs+oMvljWkU2xcRhO/soajsLhZZMCaBoN22zQDlnxfxkV7Tu3VXkjHIqjsMOTselaFF1VEN6dJmBVC2V+BDKRlkXbvXuXrEZ0iafm8MJdvtmSCdyYka4snRCI363KpptkSsrvxeg5zBEoUKdIQ/lwcC7lr/g2JXfX/5b0KhScvQQ1JxPmECfD6yLlxCcgy4H6BeVVv5OkHdFAejO4RxdMvx5kuSevyjNkTGxpmBCLDatCVJGl5KsVVdwB7KrCFrgmYJlDtZRU9hwXMJPtOZ6QnJvrICfcj0yrocEnBtKvsqkgAQwRZBj0udoF25EZVCyqQCoEhdAgloYju2CDBd9XsSqNhk4VpcwFj4bMxNtJOk9qF2RbuKWbLFrCnCDKUounymeHJYhcEz9f6CxEDFM0Lt5y2Y2nkPi1MFqLOjtjkfmKtErG8s6F7K4FSBWHvZ9/bx/ep0jddpxCNmKwQbqrX+4FqQG4t13moEwFhlVg4MgKHs/feToSx7duMAaezhvdnYInOYtEAmK0vj69V788tvucnnfC0xStY/8A+F3LLYZ5GZ071fGIjY71aTn8fU5qdb5VLoFQWt4b8gK17dLpFICcHzV22Srr8qItxEFvglq3NDE03iaVNN16MIyVIHDatZIFBXpBpdVICznCXj3EFV58WZ17yX4Umek7x4kPK5xz/blbPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199015)(66446008)(44832011)(38070700005)(64756008)(4326008)(86362001)(5660300002)(6486002)(8676002)(186003)(122000001)(83380400001)(6512007)(478600001)(71200400001)(26005)(38100700002)(4001150100001)(2906002)(36756003)(2616005)(6506007)(66476007)(41300700001)(54906003)(316002)(8936002)(66556008)(76116006)(6916009)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2Jma29waktwZFR6b200eUkxM2NOMzR6dmJuNm52ZEZtOXNMclp5aXEwb05i?=
 =?utf-8?B?Tjd6THJmK0g2cFRySTRZSjBNNEFCTlUwOUJjUTYzUlMyZlJNR1VrTWx1VkdK?=
 =?utf-8?B?TWRQUHdoT0tjNm8vZlBBZ1lKeXpMTk16aU5LOER2Wnc0Yk1vVTlKTjBuUmJJ?=
 =?utf-8?B?VUtPNmVQeE91bTlkYjB3VERDa0NPbzg3eThOZUdvOWNiY2R0TUVWM0FSYzNF?=
 =?utf-8?B?blNnWkFXRnBSeUFtbmlCM3RTdkRwUWRhcnNpUkk2ZjVNM3pkWG8waU1pQzln?=
 =?utf-8?B?SEk5RWJreHFaWUJYR1FSczJmd1h0dkdTTzcrU3l4MnhoYmVFZk1GSk5Fendq?=
 =?utf-8?B?ZTZyeXdLSHhwRUY2bk5UQ2lFbVk5a2RhNy9yYjhvNWhzejJMNkJZSDNnenhH?=
 =?utf-8?B?VTFEZmtsdlIxNVRuYy8zaXVYOGFWakhmN3FwRjk2MnJWVkZTMklMM3E2UWFn?=
 =?utf-8?B?ZXVmWjJGWk5GdjBUa0prMVo1NGRrVDZMd3I3Y2EwVXlRRWVESTFwbzJPdlBZ?=
 =?utf-8?B?ZWVUS255UW5rWmNDbG1aUkdReEptM25LVkRUKzZIeWlwQnZsTEdrNjRYUDBo?=
 =?utf-8?B?TkxjaHJLRFdiZlN4cUQ2RFlicUxHMjh4Q0owZmQ1dTBPdjJtSVdQZ3lUQisr?=
 =?utf-8?B?VjVHcFpIa3g2UjBXWUlOZG9VU0JGaFRYOVVweWxUUU11U3IwdGxEL2NtUUxi?=
 =?utf-8?B?cEdZSGlhYzRVWURLYS9LWmlwcHVxYy9PdzFDYUFLNXFmWkJnK3JHbUVGVE50?=
 =?utf-8?B?STJhRXhhdlQzTGRJd0JXRGxqLzdYNitJN2svZEN6TTgvNlpQOWtvNkozVElx?=
 =?utf-8?B?SUtPNWowdXA4Yks2NFYrSWE4ZmZ4S1lQZCthSS9XbEV6SkVFVlJNenczVkRH?=
 =?utf-8?B?aHNHbklGeCtLZzRRUXgxa3FINkNqeWdrVE9QSVkzMm9aYWxJNFc0bjJtQ2FZ?=
 =?utf-8?B?VEZEYitLR1JzNzlNcGhuVk9OUWI2bkNDVHJkb3NXRVlybkN2TVRKdnRRVXlZ?=
 =?utf-8?B?eUpMTm16RHJZVUpIalEreTFDQzMrSldXODhMeWJRZTB4MzZqWVJ2VDEwVndO?=
 =?utf-8?B?ZDF0MnNwQTVtam5CQkVETGplK0I5UHAzOGRTcHZiWjVSYjFaVGRRZlVSWG9F?=
 =?utf-8?B?QUx1RWVvcVRnNC83ZXgwUXZEY0tCVUp6ZXBFWDhxbjVOWWZvMXB5MUVXU0NP?=
 =?utf-8?B?MDhIZThqbi9FN2FvOTF5bkhsbXJTT2E5QXhzVUxWQzhOdzl5OXB2MlVNSUxX?=
 =?utf-8?B?em82TkpJUFdYdjk0UUtGaUE5eUh6Skh6UTRoY3dGN0hyRzgvbzI0SVFTVEtO?=
 =?utf-8?B?QzdMZnlSSHBIL0dIVDlYenFSTk5DNjIrRktpcTA3Y0paZ1ZmZE1DQUxJeWlu?=
 =?utf-8?B?WkpLYUkybnFiWTErTWsyY0xXWEFZTmNjTW8xbi82SXQwQWw4NjlVbnQ3TjhS?=
 =?utf-8?B?Q1pnaDhBY1VJWDEzOU5aaitBbyt6a1kvOEx1ZVpnWEV4SXY5YUJ0Q2ZqekhP?=
 =?utf-8?B?SmhiKzFvU053NkVHbFFVM2l4S1FKVlpWMU1GNUUxU0R2RW10QWVWTWdEbExF?=
 =?utf-8?B?dFhSZDlxOXIrQmNNeDRyaDJCSmtOcm1zRWt6cWcxSFFQMUgvQ0lId0J1eHY3?=
 =?utf-8?B?MUhWM1lndnQ5ZG5lQWtuaU9EUTJJbE1mbTQwT25DZEtIRUZ1TUZtUXBrVmM4?=
 =?utf-8?B?S09WR2QrZVIyMDZRa0tHZnArL2hkTXcxN0llUkwvbWMxZFVPLzZPUlNJN3Vs?=
 =?utf-8?B?bzBzRGd1S2MxNkRmRW16TThlR2lKcGUyTTd5N3dwUG5zeG02WWRXVXdqeWoz?=
 =?utf-8?B?OWt5amdlRThJOW5wWFRBYTE1V1hPTEFsMmg2V0RTa1FjeWJxR2tVUnJRREFr?=
 =?utf-8?B?bWJieVYwclNqUGlRQWNwYXdwVmdXNEhZQThDRUZGTVliOGNVb1BVaHRiVXFh?=
 =?utf-8?B?K1FqZ1RJNyt4SXdMT1dGUnYwLzl4dXRxWmlRS0xvQlpkQWpvTHovYU03MGlX?=
 =?utf-8?B?WTdjVko3L1U5MlBqYklIdTNublQwVVdtM2FOZ1JCZFJnSDdvUXpBT3RnZm1C?=
 =?utf-8?B?WTBtb044RFExdkFLQlI0dUo1WHQ4N3NIeTB6ZHlNZzRnYzZ1OE96ZzVtZGpr?=
 =?utf-8?B?cWliN3pURnRvWjBvZ1ZicjArSHQ2ZU5relRtbFdxZmYxQy9qYmEzcmFia016?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D5F201D0A805A45A88E519676FA0E8F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf91b172-ff26-4e19-b575-08dab6ca758c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 20:49:49.7995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FY1LZBupEZGTv7jMxrCbNM78UTkSnsEGR/xIRvO179pmHOStSbGqRxAtH/QnFlhdGUwz682KtF3c5OrabU+DjCB+rZM3Dua5w9h6BQkSjdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210250116
X-Proofpoint-GUID: eZhhGqI9J_k4O-2oAdUKALhbwNcQyCUs
X-Proofpoint-ORIG-GUID: eZhhGqI9J_k4O-2oAdUKALhbwNcQyCUs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTI0IGF0IDE0OjMyIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gRnJvbTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4KPiAKPiBTdGFydGlu
ZyBpbiA2LjEsIENPTkZJR19GT1JUSUZZX1NPVVJDRSBjaGVja3MgdGhlIGxlbmd0aCBwYXJhbWV0
ZXIgb2YKPiBtZW1jcHkuwqAgU2luY2Ugd2UncmUgYWxyZWFkeSBmaXhpbmcgcHJvYmxlbXMgd2l0
aCBCVUkgaXRlbSBjb3B5aW5nLAo+IHdlCj4gc2hvdWxkIGZpeCBpdCBldmVyeXRoaW5nIGVsc2Uu
Cj4gCj4gUmVmYWN0b3IgdGhlIHhmc19ydWlfY29weV9mb3JtYXQgZnVuY3Rpb24gdG8gaGFuZGxl
IHRoZSBjb3B5aW5nIG9mCj4gdGhlCj4gaGVhZCBhbmQgdGhlIGZsZXggYXJyYXkgbWVtYmVycyBz
ZXBhcmF0ZWx5LsKgIFdoaWxlIHdlJ3JlIGF0IGl0LCBmaXggYQo+IG1pbm9yIHZhbGlkYXRpb24g
ZGVmaWNpZW5jeSBpbiB0aGUgcmVjb3ZlcnkgZnVuY3Rpb24uCj4gCj4gU2lnbmVkLW9mZi1ieTog
RGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4KTG9va3MgZ29vZCB0byBtZQpSZXZp
ZXdlZC1ieTogQWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb20+
Cj4gLS0tCj4gwqBmcy94ZnMveGZzX29uZGlzay5owqDCoMKgIHzCoMKgwqAgMyArKwo+IMKgZnMv
eGZzL3hmc19ybWFwX2l0ZW0uYyB8wqDCoCA1OCArKysrKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLQo+IC0tLS0tLS0tLS0KPiDCoDIgZmlsZXMgY2hhbmdlZCwgMzAgaW5zZXJ0aW9u
cygrKSwgMzEgZGVsZXRpb25zKC0pCj4gCj4gCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfb25k
aXNrLmggYi9mcy94ZnMveGZzX29uZGlzay5oCj4gaW5kZXggZTIwZDI4NDRiMGM1Li4xOWMxZGYw
MGI0OGUgMTAwNjQ0Cj4gLS0tIGEvZnMveGZzL3hmc19vbmRpc2suaAo+ICsrKyBiL2ZzL3hmcy94
ZnNfb25kaXNrLmgKPiBAQCAtMTM4LDExICsxMzgsMTQgQEAgeGZzX2NoZWNrX29uZGlza19zdHJ1
Y3RzKHZvaWQpCj4gwqDCoMKgwqDCoMKgwqDCoFhGU19DSEVDS19TVFJVQ1RfU0laRShzdHJ1Y3Qg
eGZzX2J1ZF9sb2dfZm9ybWF0LMKgwqDCoMKgwqDCoMKgwqAxNik7Cj4gwqDCoMKgwqDCoMKgwqDC
oFhGU19DSEVDS19TVFJVQ1RfU0laRShzdHJ1Y3QgeGZzX2N1aV9sb2dfZm9ybWF0LMKgwqDCoMKg
wqDCoMKgwqAxNik7Cj4gwqDCoMKgwqDCoMKgwqDCoFhGU19DSEVDS19TVFJVQ1RfU0laRShzdHJ1
Y3QgeGZzX2N1ZF9sb2dfZm9ybWF0LMKgwqDCoMKgwqDCoMKgwqAxNik7Cj4gK8KgwqDCoMKgwqDC
oMKgWEZTX0NIRUNLX1NUUlVDVF9TSVpFKHN0cnVjdCB4ZnNfcnVpX2xvZ19mb3JtYXQswqDCoMKg
wqDCoMKgwqDCoDE2KTsKPiArwqDCoMKgwqDCoMKgwqBYRlNfQ0hFQ0tfU1RSVUNUX1NJWkUoc3Ry
dWN0IHhmc19ydWRfbG9nX2Zvcm1hdCzCoMKgwqDCoMKgwqDCoMKgMTYpOwo+IMKgwqDCoMKgwqDC
oMKgwqBYRlNfQ0hFQ0tfU1RSVUNUX1NJWkUoc3RydWN0IHhmc19tYXBfZXh0ZW50LMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoDMyKTsKPiDCoMKgwqDCoMKgwqDCoMKgWEZTX0NIRUNLX1NUUlVDVF9T
SVpFKHN0cnVjdCB4ZnNfcGh5c19leHRlbnQswqDCoMKgwqDCoMKgwqDCoMKgwqDCoDE2KTsKPiDC
oAo+IMKgwqDCoMKgwqDCoMKgwqBYRlNfQ0hFQ0tfT0ZGU0VUKHN0cnVjdCB4ZnNfYnVpX2xvZ19m
b3JtYXQsCj4gYnVpX2V4dGVudHMswqDCoMKgwqDCoMKgwqDCoDE2KTsKPiDCoMKgwqDCoMKgwqDC
oMKgWEZTX0NIRUNLX09GRlNFVChzdHJ1Y3QgeGZzX2N1aV9sb2dfZm9ybWF0LAo+IGN1aV9leHRl
bnRzLMKgwqDCoMKgwqDCoMKgwqAxNik7Cj4gK8KgwqDCoMKgwqDCoMKgWEZTX0NIRUNLX09GRlNF
VChzdHJ1Y3QgeGZzX3J1aV9sb2dfZm9ybWF0LAo+IHJ1aV9leHRlbnRzLMKgwqDCoMKgwqDCoMKg
wqAxNik7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiDCoMKgwqDCoMKgwqDCoMKgICogVGhl
IHY1IHN1cGVyYmxvY2sgZm9ybWF0IGV4dGVuZGVkIHNldmVyYWwgdjQgaGVhZGVyCj4gc3RydWN0
dXJlcyB3aXRoCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfcm1hcF9pdGVtLmMgYi9mcy94ZnMv
eGZzX3JtYXBfaXRlbS5jCj4gaW5kZXggZmVmOTJlMDJmM2JiLi4yNzA0N2U3M2Y1ODIgMTAwNjQ0
Cj4gLS0tIGEvZnMveGZzL3hmc19ybWFwX2l0ZW0uYwo+ICsrKyBiL2ZzL3hmcy94ZnNfcm1hcF9p
dGVtLmMKPiBAQCAtMTU1LDMxICsxNTUsNiBAQCB4ZnNfcnVpX2luaXQoCj4gwqDCoMKgwqDCoMKg
wqDCoHJldHVybiBydWlwOwo+IMKgfQo+IMKgCj4gLS8qCj4gLSAqIENvcHkgYW4gUlVJIGZvcm1h
dCBidWZmZXIgZnJvbSB0aGUgZ2l2ZW4gYnVmLCBhbmQgaW50byB0aGUKPiBkZXN0aW5hdGlvbgo+
IC0gKiBSVUkgZm9ybWF0IHN0cnVjdHVyZS7CoCBUaGUgUlVJL1JVRCBpdGVtcyB3ZXJlIGRlc2ln
bmVkIG5vdCB0bwo+IG5lZWQgYW55Cj4gLSAqIHNwZWNpYWwgYWxpZ25tZW50IGhhbmRsaW5nLgo+
IC0gKi8KPiAtU1RBVElDIGludAo+IC14ZnNfcnVpX2NvcHlfZm9ybWF0KAo+IC3CoMKgwqDCoMKg
wqDCoHN0cnVjdCB4ZnNfbG9nX2lvdmVjwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKmJ1ZiwKPiAt
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3J1aV9sb2dfZm9ybWF0wqDCoMKgwqDCoMKgwqAqZHN0
X3J1aV9mbXQpCj4gLXsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3J1aV9sb2dfZm9ybWF0
wqDCoMKgwqDCoMKgwqAqc3JjX3J1aV9mbXQ7Cj4gLcKgwqDCoMKgwqDCoMKgdWludMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbGVuOwo+IC0K
PiAtwqDCoMKgwqDCoMKgwqBzcmNfcnVpX2ZtdCA9IGJ1Zi0+aV9hZGRyOwo+IC3CoMKgwqDCoMKg
wqDCoGxlbiA9IHhmc19ydWlfbG9nX2Zvcm1hdF9zaXplb2Yoc3JjX3J1aV9mbXQtPnJ1aV9uZXh0
ZW50cyk7Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoGlmIChidWYtPmlfbGVuICE9IGxlbikgewo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBYRlNfRVJST1JfUkVQT1JUKF9fZnVuY19fLCBY
RlNfRVJSTEVWRUxfTE9XLCBOVUxMKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cmV0dXJuIC1FRlNDT1JSVVBURUQ7Cj4gLcKgwqDCoMKgwqDCoMKgfQo+IC0KPiAtwqDCoMKgwqDC
oMKgwqBtZW1jcHkoZHN0X3J1aV9mbXQsIHNyY19ydWlfZm10LCBsZW4pOwo+IC3CoMKgwqDCoMKg
wqDCoHJldHVybiAwOwo+IC19Cj4gLQo+IMKgc3RhdGljIGlubGluZSBzdHJ1Y3QgeGZzX3J1ZF9s
b2dfaXRlbSAqUlVEX0lURU0oc3RydWN0IHhmc19sb2dfaXRlbQo+ICpsaXApCj4gwqB7Cj4gwqDC
oMKgwqDCoMKgwqDCoHJldHVybiBjb250YWluZXJfb2YobGlwLCBzdHJ1Y3QgeGZzX3J1ZF9sb2df
aXRlbSwgcnVkX2l0ZW0pOwo+IEBAIC02NTIsNiArNjI3LDIwIEBAIHN0YXRpYyBjb25zdCBzdHJ1
Y3QgeGZzX2l0ZW1fb3BzCj4geGZzX3J1aV9pdGVtX29wcyA9IHsKPiDCoMKgwqDCoMKgwqDCoMKg
LmlvcF9yZWxvZ8KgwqDCoMKgwqDCoD0geGZzX3J1aV9pdGVtX3JlbG9nLAo+IMKgfTsKPiDCoAo+
ICtzdGF0aWMgaW5saW5lIHZvaWQKPiAreGZzX3J1aV9jb3B5X2Zvcm1hdCgKPiArwqDCoMKgwqDC
oMKgwqBzdHJ1Y3QgeGZzX3J1aV9sb2dfZm9ybWF0wqDCoMKgwqDCoMKgwqAqZHN0LAo+ICvCoMKg
wqDCoMKgwqDCoGNvbnN0IHN0cnVjdCB4ZnNfcnVpX2xvZ19mb3JtYXTCoCpzcmMpCj4gK3sKPiAr
wqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgaTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgbWVtY3B5KGRzdCwgc3JjLCBvZmZzZXRv
ZihzdHJ1Y3QgeGZzX3J1aV9sb2dfZm9ybWF0LAo+IHJ1aV9leHRlbnRzKSk7Cj4gKwo+ICvCoMKg
wqDCoMKgwqDCoGZvciAoaSA9IDA7IGkgPCBzcmMtPnJ1aV9uZXh0ZW50czsgaSsrKQo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtZW1jcHkoJmRzdC0+cnVpX2V4dGVudHNbaV0sICZz
cmMtPnJ1aV9leHRlbnRzW2ldLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNpemVvZihzdHJ1Y3QgeGZzX21hcF9leHRlbnQp
KTsKPiArfQo+ICsKPiDCoC8qCj4gwqAgKiBUaGlzIHJvdXRpbmUgaXMgY2FsbGVkIHRvIGNyZWF0
ZSBhbiBpbi1jb3JlIGV4dGVudCBybWFwIHVwZGF0ZQo+IMKgICogaXRlbSBmcm9tIHRoZSBydWkg
Zm9ybWF0IHN0cnVjdHVyZSB3aGljaCB3YXMgbG9nZ2VkIG9uIGRpc2suCj4gQEAgLTY2NiwxOSAr
NjU1LDI2IEBAIHhsb2dfcmVjb3Zlcl9ydWlfY29tbWl0X3Bhc3MyKAo+IMKgwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QgeGxvZ19yZWNvdmVyX2l0ZW3CoMKgwqDCoMKgwqDCoMKgKml0ZW0sCj4gwqDCoMKg
wqDCoMKgwqDCoHhmc19sc25fdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBsc24pCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVycm9yOwo+IMKgwqDCoMKg
wqDCoMKgwqBzdHJ1Y3QgeGZzX21vdW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAq
bXAgPSBsb2ctPmxfbXA7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfcnVpX2xvZ19pdGVt
wqDCoMKgwqDCoMKgwqDCoMKgKnJ1aXA7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfcnVp
X2xvZ19mb3JtYXTCoMKgwqDCoMKgwqDCoCpydWlfZm9ybWF0cDsKPiArwqDCoMKgwqDCoMKgwqBz
aXplX3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
bGVuOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHJ1aV9mb3JtYXRwID0gaXRlbS0+cmlfYnVmWzBd
LmlfYWRkcjsKPiDCoAo+ICvCoMKgwqDCoMKgwqDCoGlmIChpdGVtLT5yaV9idWZbMF0uaV9sZW4g
PCB4ZnNfcnVpX2xvZ19mb3JtYXRfc2l6ZW9mKDApKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoFhGU19FUlJPUl9SRVBPUlQoX19mdW5jX18sIFhGU19FUlJMRVZFTF9MT1csIGxv
Zy0KPiA+bF9tcCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUZT
Q09SUlVQVEVEOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiArCj4gK8KgwqDCoMKgwqDCoMKgbGVuID0g
eGZzX3J1aV9sb2dfZm9ybWF0X3NpemVvZihydWlfZm9ybWF0cC0+cnVpX25leHRlbnRzKTsKPiAr
wqDCoMKgwqDCoMKgwqBpZiAoaXRlbS0+cmlfYnVmWzBdLmlfbGVuICE9IGxlbikgewo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBYRlNfRVJST1JfUkVQT1JUKF9fZnVuY19fLCBYRlNf
RVJSTEVWRUxfTE9XLCBsb2ctCj4gPmxfbXApOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gLUVGU0NPUlJVUFRFRDsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gKwo+IMKgwqDC
oMKgwqDCoMKgwqBydWlwID0geGZzX3J1aV9pbml0KG1wLCBydWlfZm9ybWF0cC0+cnVpX25leHRl
bnRzKTsKPiAtwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19ydWlfY29weV9mb3JtYXQoJml0ZW0t
PnJpX2J1ZlswXSwgJnJ1aXAtCj4gPnJ1aV9mb3JtYXQpOwo+IC3CoMKgwqDCoMKgwqDCoGlmIChl
cnJvcikgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfcnVpX2l0ZW1fZnJl
ZShydWlwKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGVycm9yOwo+
IC3CoMKgwqDCoMKgwqDCoH0KPiArwqDCoMKgwqDCoMKgwqB4ZnNfcnVpX2NvcHlfZm9ybWF0KCZy
dWlwLT5ydWlfZm9ybWF0LCBydWlfZm9ybWF0cCk7Cj4gwqDCoMKgwqDCoMKgwqDCoGF0b21pY19z
ZXQoJnJ1aXAtPnJ1aV9uZXh0X2V4dGVudCwgcnVpX2Zvcm1hdHAtCj4gPnJ1aV9uZXh0ZW50cyk7
Cj4gwqDCoMKgwqDCoMKgwqDCoC8qCj4gwqDCoMKgwqDCoMKgwqDCoCAqIEluc2VydCB0aGUgaW50
ZW50IGludG8gdGhlIEFJTCBkaXJlY3RseSBhbmQgZHJvcCBvbmUKPiByZWZlcmVuY2Ugc28KPiAK
Cg==
