Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04F4FA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 20:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiJYUmY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 16:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiJYUmX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 16:42:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F01D15A36
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 13:42:22 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PKYiZm029642;
        Tue, 25 Oct 2022 20:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=uQj0bu4qLgzXCiy4eZIL+LsRWTsH8kRcPCFUeBxuubQ=;
 b=WtoHAVokRiR3C+tmIpzLp3LMasgh/c7MQNSoSplBrvqCK40jCNJH+j/VKy5IYN1aZiL+
 xzqqhtPSG+l0xmIS5PpbT4nIsUuXakhjDpGkJTMzpOAS9cmVFznFfno/NlLxVIO7Y1cI
 fyrhdObN8T2tJyEZFwhojLdZINHO4Nb86ArgixD6bmZUC41IBJrso6tRC+rNJ8jqxjoR
 zMEj3WfdNuQJ4eFYnpuPfDX+Heqjtn89YXlTxrGhdJxeTb1X6yXWXFPNDmzs0vBUku3m
 MbZuuXw/1D6ABDOSyypa/Y193XTyC8H7CRIW/WjJd/ewZ/mvtjAARWTIpRbRAVtdph6I qw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbmgxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:42:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJqLFd012788;
        Tue, 25 Oct 2022 20:42:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y50rwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:42:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3CqWUGV8OutP56KA+uWO53pk+YGGO91h+gHZvXoJYgm19/geRDhUEiwC7pqEr8vMHEw51OD4Fhrs6Xso+R+YlM2JreRYcEOzcF4kliCEVm0+vtPCDB3OI83QcFUOkv/tOmgvLLSGZSKPVP1EOhRWm8en6VS1IpWRG5O4XdfSUwrghUj/k8eyqtfV+l3VcJOxGG18lp7SEZj5paa/AiiMJ79m38DXsxxoLKv8GqNLJrkUi6ZlJZtexNQzK10Y0P7Hl/l4A2cu8JI1ybnPikd5OepdFR5gi0RxX7+NIpUsugZJETa16QZhGwiBOCbUfl2eTzsxuU3knop7pceVgHMqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQj0bu4qLgzXCiy4eZIL+LsRWTsH8kRcPCFUeBxuubQ=;
 b=obRr2bQcBF/LcikqI5Vn9uceQp5jldIQaIdIXITA/K9NAU4PDXWejs75C4sZfeRDAT+CkSVd/77UN4yuxYz/L4pDtVU0LV6hq8FQyp8/3CmJr/bkWd3jonWKyja6Kc8330vSQotTDr3M6hGGBMiGf7ahwIXxAI98HgFiVF6Wj46bTWXLxH0ipe0qZPDwJaPv6JNpskmscisRLbdPISZjE8A+L5fx2k1F5jbD6rdOAqVZIhQq3u8d1RTaqfWjRggcu2wgX+pB2A9PZEanibvm3mmmHELZU5xdX3tBmqLMlqXij+5RIS0o1C9sbyJFUOL7/W2YnMqnm2wmA3kRIQJuoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQj0bu4qLgzXCiy4eZIL+LsRWTsH8kRcPCFUeBxuubQ=;
 b=u1GCnFSfpeiQL6ZEg6n15Yt+A85va2r9KDzDWay7AmU9KnkOwp8w4wXqmAaxQe9TiXjf6XSBYYQFDE7ROuNg7CYEtpKVpm+EY4/wVvwDU/zp0tlrC0T6u99GwOwvE+o5ITrb6Mm2HjnrP5u2e1kT3ilwQh1LcoD8Sz6joKiRLx4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY5PR10MB6192.namprd10.prod.outlook.com (2603:10b6:930:30::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 25 Oct
 2022 20:42:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5746.023; Tue, 25 Oct 2022
 20:42:13 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/6] xfs: fix validation in attr log item recovery
Thread-Topic: [PATCH 1/6] xfs: fix validation in attr log item recovery
Thread-Index: AQHY5/4x1oOx1W5EQU2H7C4PZNOTHq4flImA
Date:   Tue, 25 Oct 2022 20:42:13 +0000
Message-ID: <0d3ade01fc9de2b450644e69ede283901e4a8b45.camel@oracle.com>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
         <166664715731.2688790.9836328662603103847.stgit@magnolia>
In-Reply-To: <166664715731.2688790.9836328662603103847.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CY5PR10MB6192:EE_
x-ms-office365-filtering-correlation-id: ad1ae9aa-dbf8-4274-4fbb-08dab6c965b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WOCXWq0FiGUaZ7886WG3oHPeKPb2LVa1Q8h72j0JHfZFBnknbyl+Q3JFhpjJ+VmRoVHjeL1j8cEIUNNIzmXaOYxrZEsiUpBt4dIAU8vjVIE7jK4vYSPLatbLia9PkgTNf2SBHxJadliM6mkfTN9PcIlLnyDkIlYSO9lkw6IqkE5EMmf/30DOVLVPnKhcYLjLJQ2eljLg3ObAf3UhTT8wI3I7xBrI3OwvdBr8Bway0/EjKM4QfX9qRXdczNNLBGs8Z+RKX8AmJmBgz/AJUKQGg7M7Sh9yXQNFgUi2NQGd/ZYWO5AbPvHE1JE6MI0BfEFvsxXPYLanpnBbdLj50gHz8AIxVdGVN8iQCvm7wJneNxp+lhDnkaLgUvUrC8mAajLsWK2Sc4IfOt0YOvZw1qOY7NU3aC/r212StHoa5yoWcvMHZhZn7YfGR64CWhDOW/4evfwKSdO53lcnDpKgIIKgREUoM5BvgpoP9yU0Ccl7lWNAl4lZ/WKfaejZeiKW6cNwrZAs12ss8E7StmzDpWQ6uX5KP5MHT/mp3i3FngKX/70AIBiNEQeQOPFiL9A2zYwwz/h8cIntMwL59SrswyFZA9MSjkB8/KcmKq1WEPNlfufm4RhpGSA7BQ5cky99FwRwP6mSfg8Q5w0UYAvVO6ZiOOODlhCRrPW2betfK9YDr/kCg4PTzUmEbp1sZvWzAZHyECCc5e223/fPAMFcOBpJJ5fJURkJF5cIJe/XseEYtaB4Zcd1mmbCtU51rzEekRt9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199015)(41300700001)(26005)(2906002)(478600001)(38070700005)(86362001)(186003)(4001150100001)(36756003)(2616005)(4326008)(8936002)(6512007)(44832011)(54906003)(6916009)(71200400001)(316002)(122000001)(6486002)(8676002)(6506007)(83380400001)(64756008)(66446008)(38100700002)(5660300002)(76116006)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2orM0l4U0NkK2pvK250Wm9SejQ4UmRNVG1YeUpDYUxEM0taazFmK3RNTkhp?=
 =?utf-8?B?YzMxNkEzQS93RkVyQVlnWDdIeEFKMmNMeHVMOEtQNzNhUWZOMVR5WTdiOXF2?=
 =?utf-8?B?QkJWcDcrdnBDWE9HcWc5UFIyV1ljQmMrMXNUZUxOc3hnVGFabk1PM3J6bWNn?=
 =?utf-8?B?anR4Vk4rUkV3M3AyYUNQcmpCSlR5dzBSMjI0VURuU3l1ejlaYWlrZ3F1YmVU?=
 =?utf-8?B?RXMwRjlQNGFLbTc3QStxZ0lCZGhpZDdQUVNwRnFQcmxSaUJwdThyYThtVnJw?=
 =?utf-8?B?YXcwYmZ6UFJyQmlPbkFmM2poZ2x5R1lHYmJIR1pibndlV3U3L2tDbWV4RytY?=
 =?utf-8?B?RCs3VVYva3laeDdXRzE5V2pzdXFBZG9qSk1ielpUTy9pZzkvSWRvOUxZN1pz?=
 =?utf-8?B?ODd3U3JJcG5OWUk4eHk4UXFraERENWFWZ0Zhc2tjWHJOV25aa3VSa01UNzBs?=
 =?utf-8?B?ZkpxZFBmamFxbFBHb2pNT0tLeFQyV21lR1NIWDBnK0h1ZllsQjIzWXI4cFpz?=
 =?utf-8?B?NWZoV0JYQWdoaFN2d2pyZW9kaGlDMXRJWWlOWHgxZUxqZHZoNTcxWkYzZFV0?=
 =?utf-8?B?dDhkN2J3VkxqNEdiUnBsbHAyaHY5OTlZaVB2OWxZK3pSM2Y1N0wyaHVReG11?=
 =?utf-8?B?ZHZTNko1bkFWUGI4bU1icWloR00zR1VGLzZqR1BVSnQ5MEwxQjRJSFRubVdE?=
 =?utf-8?B?cjdnUG91Vk9LQlF4aE9ObzNaUGxMOVkxYnZ6R2ZxQnVNT2lqdnVKVGtSdjFS?=
 =?utf-8?B?Y0ZiUW5BdXNrMVR5SzBMclkyUlRWZU94c0Y1eFJ5SkUydDlIcG1UcFRBVHQz?=
 =?utf-8?B?NllwN0l4VlJIMENUZ1hnUDFkU1V4eS9DMTNpSzR5bkhlRE5tNmFqMG85azFu?=
 =?utf-8?B?SnE0NzNLTDlGdlFua2lVWThoQWtHV3l1MnNsdlBnMEpWZURjNGU5V2trRWhN?=
 =?utf-8?B?V1gzZkU3ZGg0a0hrYnJ0Z2dVOWVKTUI1VlNPZ2ZEUy9xb2Z0ZWVEYU9jWERS?=
 =?utf-8?B?aTVVbS84eFc4aXVXTlFYU2RhdDNIRlJsMURHZHZMTW96WWxaU01UcHhHK2h4?=
 =?utf-8?B?Ulo4VE1hV2ZtL1ptMi9GdEJBMEdWclFsaWhCdHpucjNKcVcrK2tmdjFjN25X?=
 =?utf-8?B?aHB6SUNRZlNsSllFM1FjK0crWC8zY2hOQVg4RHRiWS9wbE12TkpRMjBaZjVI?=
 =?utf-8?B?WGRPZGFtbzJiZ2NNTzRHZzJsQ3BFcVQ2bzdPRkVpNUt6VFZMekZLRWtEZm9E?=
 =?utf-8?B?cDc5QnBzNExtbzZ3aEo5TGcwZjdRYWozTVlsYWx3cm12RTF0VThqelFCYXpI?=
 =?utf-8?B?am41MTBWbnlVRHcxa084aTJFaTUxRlZtUmxVUy80dE9MZWNDemZhZWNZNUUx?=
 =?utf-8?B?Z2gweENodW9oQkgrK2FJRXNBVGlxYnc2R1VVbDNFcHJjdmROMzY4MnVmR0VV?=
 =?utf-8?B?SHBIVUVVenZ6ZjEwOTJvWU9nbnZ4V2lNNmkzMkJjTlpVL0VVYzBxTExsSGJY?=
 =?utf-8?B?R0F4ODhSNmhjQkRENkRIQUhWQnJHQlRNb1Y4enpVL3l5TzNDOUpaL014dkxt?=
 =?utf-8?B?Y3RKYzh4bFlMVjdlTmhQS2R2SjJGaHhLQ1Z4dzNSR1paeTlZc3ZLK3FxWEFJ?=
 =?utf-8?B?dHpkRHJ3N0E0MkU2RmtXNTI4WHZZRzVMaWVBVm9OalREZXMwdW5lZy9CRzdF?=
 =?utf-8?B?V2NtVmRYTlNyTkk5VHVVTytPYTZ4bGkwaHVFbWl1Ynhsb2k2WTlkVmliakll?=
 =?utf-8?B?VnZ6VzRzYnJsUEJhemI0ZFdBNVVDVHlFT0N2bjlQQ0JlaFNJSzVXOWRCdzV0?=
 =?utf-8?B?aVlyWWwrM3lUSEpjamw2c2JaNTZGYzB5YXE3akdhZE9tNUgzdk81TExQbThv?=
 =?utf-8?B?YW9qdUpaQU9Vc2tOTFNnK3ZNcEV6TlAvTko4dVUwZ1lLNXcxa3plTU9hZFFS?=
 =?utf-8?B?NmdxdWZUVTFoUG50ZkV1dE1WelorWk80dzRDS2VERVNLWmlEeU5tWncveTNT?=
 =?utf-8?B?UVMxaG84Sk9uS1JYVVRhQlV5RGk2NDBJMFpQdWNWSnN5eTNxbGVvRFlTZytM?=
 =?utf-8?B?elZQT2FmZnNFMFF5QWFpNDRUbE5SalFvdWF4QVU5c1JkOFZRWW9HVnpyem1J?=
 =?utf-8?B?NVJpYUkrSUlIenZIZ0luSmFOTUR6OGlOQ0ZRcTY3Ti9zcnpYVDJMbE1na0Nk?=
 =?utf-8?B?SGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A7163E230772549ACF3828A0826BA1C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1ae9aa-dbf8-4274-4fbb-08dab6c965b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 20:42:13.7359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V5iLa215QjBolGPQ+pCxPuyMnGEBJ4/t/0Wbouc4G7yzTjrV76qYXK2SefdNLtjcUtzxpWRuKFKpOwMAc6xQ1HTf0qzoojPBozlWwH2gWf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6192
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250115
X-Proofpoint-ORIG-GUID: GmJRr1LNNWyKaIBd3Izlufu3F8lEXSkF
X-Proofpoint-GUID: GmJRr1LNNWyKaIBd3Izlufu3F8lEXSkF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTI0IGF0IDE0OjMyIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gRnJvbTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4KPiAKPiBCZWZvcmUg
d2Ugc3RhcnQgZml4aW5nIGFsbCB0aGUgY29tcGxhaW50cyBhYm91dCBtZW1jcHknaW5nIGxvZyBp
dGVtcwo+IGFyb3VuZCwgbGV0J3MgZml4IHNvbWUgaW5hZGVxdWF0ZSB2YWxpZGF0aW9uIGluIHRo
ZSB4YXR0ciBsb2cgaXRlbQo+IHJlY292ZXJ5IGNvZGUgYW5kIGdldCByaWQgb2YgdGhlIChub3cg
dHJpdmlhbCkgY29weV9mb3JtYXQgZnVuY3Rpb24uCj4gCj4gU2lnbmVkLW9mZi1ieTogRGFycmlj
ayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz5cCk9rLCBsb29rcyBnb29kIHRvIG1lClJldmll
d2VkLWJ5OiBBbGxpc29uIEhlbmRlcnNvbiA8YWxsaXNvbi5oZW5kZXJzb25Ab3JhY2xlLmNvbT4K
Cj4gLS0tCj4gwqBmcy94ZnMveGZzX2F0dHJfaXRlbS5jIHzCoMKgIDU0ICsrKysrKysrKysrKysr
KysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCj4gLS0tLS0tLS0tLQo+IMKgMSBmaWxlIGNoYW5nZWQs
IDIzIGluc2VydGlvbnMoKyksIDMxIGRlbGV0aW9ucygtKQo+IAo+IAo+IGRpZmYgLS1naXQgYS9m
cy94ZnMveGZzX2F0dHJfaXRlbS5jIGIvZnMveGZzL3hmc19hdHRyX2l0ZW0uYwo+IGluZGV4IGNm
NWNlNjA3ZGMwNS4uZWU4ZjY3OGExMGExIDEwMDY0NAo+IC0tLSBhL2ZzL3hmcy94ZnNfYXR0cl9p
dGVtLmMKPiArKysgYi9mcy94ZnMveGZzX2F0dHJfaXRlbS5jCj4gQEAgLTI0NSwyOCArMjQ1LDYg
QEAgeGZzX2F0dHJpX2luaXQoCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiBhdHRyaXA7Cj4gwqB9
Cj4gwqAKPiAtLyoKPiAtICogQ29weSBhbiBhdHRyIGZvcm1hdCBidWZmZXIgZnJvbSB0aGUgZ2l2
ZW4gYnVmLCBhbmQgaW50byB0aGUKPiBkZXN0aW5hdGlvbiBhdHRyCj4gLSAqIGZvcm1hdCBzdHJ1
Y3R1cmUuCj4gLSAqLwo+IC1TVEFUSUMgaW50Cj4gLXhmc19hdHRyaV9jb3B5X2Zvcm1hdCgKPiAt
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2xvZ19pb3ZlY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCpidWYsCj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19hdHRyaV9sb2dfZm9ybWF0wqDCoMKg
wqDCoCpkc3RfYXR0cl9mbXQpCj4gLXsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2F0dHJp
X2xvZ19mb3JtYXTCoMKgwqDCoMKgKnNyY19hdHRyX2ZtdCA9IGJ1Zi0+aV9hZGRyOwo+IC3CoMKg
wqDCoMKgwqDCoHNpemVfdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBsZW47Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoGxlbiA9IHNpemVvZihzdHJ1Y3Qg
eGZzX2F0dHJpX2xvZ19mb3JtYXQpOwo+IC3CoMKgwqDCoMKgwqDCoGlmIChidWYtPmlfbGVuICE9
IGxlbikgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBYRlNfRVJST1JfUkVQT1JU
KF9fZnVuY19fLCBYRlNfRVJSTEVWRUxfTE9XLCBOVUxMKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuIC1FRlNDT1JSVVBURUQ7Cj4gLcKgwqDCoMKgwqDCoMKgfQo+IC0K
PiAtwqDCoMKgwqDCoMKgwqBtZW1jcHkoKGNoYXIgKilkc3RfYXR0cl9mbXQsIChjaGFyICopc3Jj
X2F0dHJfZm10LCBsZW4pOwo+IC3CoMKgwqDCoMKgwqDCoHJldHVybiAwOwo+IC19Cj4gLQo+IMKg
c3RhdGljIGlubGluZSBzdHJ1Y3QgeGZzX2F0dHJkX2xvZ19pdGVtICpBVFRSRF9JVEVNKHN0cnVj
dAo+IHhmc19sb2dfaXRlbSAqbGlwKQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gY29u
dGFpbmVyX29mKGxpcCwgc3RydWN0IHhmc19hdHRyZF9sb2dfaXRlbSwKPiBhdHRyZF9pdGVtKTsK
PiBAQCAtNzMxLDI0ICs3MDksNDQgQEAgeGxvZ19yZWNvdmVyX2F0dHJpX2NvbW1pdF9wYXNzMigK
PiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19hdHRyaV9sb2dfbmFtZXZhbMKgwqDCoMKgKm52
Owo+IMKgwqDCoMKgwqDCoMKgwqBjb25zdCB2b2lkwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAqYXR0cl92YWx1ZSA9IE5VTEw7Cj4gwqDCoMKgwqDCoMKgwqDCoGNv
bnN0IHZvaWTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCphdHRy
X25hbWU7Cj4gLcKgwqDCoMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZXJyb3I7Cj4gK8KgwqDCoMKgwqDCoMKgc2l6ZV90
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGxlbjsK
PiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBhdHRyaV9mb3JtYXRwID0gaXRlbS0+cmlfYnVmWzBdLmlf
YWRkcjsKPiDCoMKgwqDCoMKgwqDCoMKgYXR0cl9uYW1lID0gaXRlbS0+cmlfYnVmWzFdLmlfYWRk
cjsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqAvKiBWYWxpZGF0ZSB4ZnNfYXR0cmlfbG9nX2Zvcm1h
dCBiZWZvcmUgdGhlIGxhcmdlIG1lbW9yeQo+IGFsbG9jYXRpb24gKi8KPiArwqDCoMKgwqDCoMKg
wqBsZW4gPSBzaXplb2Yoc3RydWN0IHhmc19hdHRyaV9sb2dfZm9ybWF0KTsKPiArwqDCoMKgwqDC
oMKgwqBpZiAoaXRlbS0+cmlfYnVmWzBdLmlfbGVuICE9IGxlbikgewo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBYRlNfRVJST1JfUkVQT1JUKF9fZnVuY19fLCBYRlNfRVJSTEVWRUxf
TE9XLCBtcCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUZTQ09S
UlVQVEVEOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiArCj4gwqDCoMKgwqDCoMKgwqDCoGlmICgheGZz
X2F0dHJpX3ZhbGlkYXRlKG1wLCBhdHRyaV9mb3JtYXRwKSkgewo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgWEZTX0VSUk9SX1JFUE9SVChfX2Z1bmNfXywgWEZTX0VSUkxFVkVMX0xP
VywgbXApOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FRlNDT1JS
VVBURUQ7Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+ICvCoMKgwqDCoMKgwqDCoC8qIFZhbGlk
YXRlIHRoZSBhdHRyIG5hbWUgKi8KPiArwqDCoMKgwqDCoMKgwqBpZiAoaXRlbS0+cmlfYnVmWzFd
LmlfbGVuICE9Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqB4bG9nX2NhbGNfaW92ZWNfbGVuKGF0dHJpX2Zvcm1hdHAtCj4gPmFsZmlfbmFtZV9sZW4pKSB7
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFhGU19FUlJPUl9SRVBPUlQoX19mdW5j
X18sIFhGU19FUlJMRVZFTF9MT1csIG1wKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIC1FRlNDT1JSVVBURUQ7Cj4gK8KgwqDCoMKgwqDCoMKgfQo+ICsKPiDCoMKgwqDC
oMKgwqDCoMKgaWYgKCF4ZnNfYXR0cl9uYW1lY2hlY2soYXR0cl9uYW1lLCBhdHRyaV9mb3JtYXRw
LQo+ID5hbGZpX25hbWVfbGVuKSkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
WEZTX0VSUk9SX1JFUE9SVChfX2Z1bmNfXywgWEZTX0VSUkxFVkVMX0xPVywgbXApOwo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FRlNDT1JSVVBURUQ7Cj4gwqDCoMKg
wqDCoMKgwqDCoH0KPiDCoAo+IC3CoMKgwqDCoMKgwqDCoGlmIChhdHRyaV9mb3JtYXRwLT5hbGZp
X3ZhbHVlX2xlbikKPiArwqDCoMKgwqDCoMKgwqAvKiBWYWxpZGF0ZSB0aGUgYXR0ciB2YWx1ZSwg
aWYgcHJlc2VudCAqLwo+ICvCoMKgwqDCoMKgwqDCoGlmIChhdHRyaV9mb3JtYXRwLT5hbGZpX3Zh
bHVlX2xlbiAhPSAwKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChpdGVt
LT5yaV9idWZbMl0uaV9sZW4gIT0KPiB4bG9nX2NhbGNfaW92ZWNfbGVuKGF0dHJpX2Zvcm1hdHAt
PmFsZmlfdmFsdWVfbGVuKSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgWEZTX0VSUk9SX1JFUE9SVChfX2Z1bmNfXywgWEZTX0VSUkxFVkVMX0xPVywK
PiBtcCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBy
ZXR1cm4gLUVGU0NPUlJVUFRFRDsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+
ICsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGF0dHJfdmFsdWUgPSBpdGVtLT5y
aV9idWZbMl0uaV9hZGRyOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IMKgwqDCoMKgwqDCoMKg
wqAvKgo+IMKgwqDCoMKgwqDCoMKgwqAgKiBNZW1vcnkgYWxsb2MgZmFpbHVyZSB3aWxsIGNhdXNl
IHJlcGxheSB0byBhYm9ydC7CoCBXZQo+IGF0dGFjaCB0aGUKPiBAQCAtNzYwLDkgKzc1OCw3IEBA
IHhsb2dfcmVjb3Zlcl9hdHRyaV9jb21taXRfcGFzczIoCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYXR0cmlfZm9ybWF0cC0+YWxmaV92YWx1ZV9sZW4p
Owo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGF0dHJpcCA9IHhmc19hdHRyaV9pbml0KG1wLCBudik7
Cj4gLcKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfYXR0cmlfY29weV9mb3JtYXQoJml0ZW0tPnJp
X2J1ZlswXSwgJmF0dHJpcC0KPiA+YXR0cmlfZm9ybWF0KTsKPiAtwqDCoMKgwqDCoMKgwqBpZiAo
ZXJyb3IpCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0Owo+ICvCoMKg
wqDCoMKgwqDCoG1lbWNweSgmYXR0cmlwLT5hdHRyaV9mb3JtYXQsIGF0dHJpX2Zvcm1hdHAsIGxl
bik7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiDCoMKgwqDCoMKgwqDCoMKgICogVGhlIEFU
VFJJIGhhcyB0d28gcmVmZXJlbmNlcy4gT25lIGZvciB0aGUgQVRUUkQgYW5kIG9uZQo+IGZvciBB
VFRSSSB0bwo+IEBAIC03NzQsMTAgKzc3MCw2IEBAIHhsb2dfcmVjb3Zlcl9hdHRyaV9jb21taXRf
cGFzczIoCj4gwqDCoMKgwqDCoMKgwqDCoHhmc19hdHRyaV9yZWxlYXNlKGF0dHJpcCk7Cj4gwqDC
oMKgwqDCoMKgwqDCoHhmc19hdHRyaV9sb2dfbmFtZXZhbF9wdXQobnYpOwo+IMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gMDsKPiAtb3V0Ogo+IC3CoMKgwqDCoMKgwqDCoHhmc19hdHRyaV9pdGVtX2Zy
ZWUoYXR0cmlwKTsKPiAtwqDCoMKgwqDCoMKgwqB4ZnNfYXR0cmlfbG9nX25hbWV2YWxfcHV0KG52
KTsKPiAtwqDCoMKgwqDCoMKgwqByZXR1cm4gZXJyb3I7Cj4gwqB9Cj4gwqAKPiDCoC8qCj4gCgo=
