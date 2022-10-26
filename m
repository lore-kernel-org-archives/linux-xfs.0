Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E3FC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 07:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiJZHlG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 03:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiJZHkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 03:40:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851DC3642D
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 00:40:42 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nV4K030448;
        Wed, 26 Oct 2022 07:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=MW/H/GSabE4ObnuVZhACb3v9Y8OB3ZQFHuAAj7jmbR8=;
 b=1dOEDdiUZBqUQ66HRk8J0C1YG3G2i7HV0e0DwQvEeANbfsW+Mx5CSoc0TEPguCc0zr2o
 vNRkNDV8Bn3xp/YcmTlanNssgYUlRDrhTcmJKHJhIYakeBQgkMHYQI5Br826Mxd1nPty
 ig8ZSkhYnMZRYITZ80LBAA1V12Z2ZDxf/YPY3ozv8sUUrAqcM9B/5Ff7CmhsorrCsElE
 P2KsRYvB65vNsT9g4eEhgPCaRH72boe/OVFZfDA4F3L/5iKHL9ffJPj+43mEFiJc/KJe
 QyEsUkGzEaOVXjkqP7k34923fQ6F1NrG9IHqf6oPBKY4iyK/dLHhdhEkx/gglAtl6Fx9 gw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741x6e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 07:40:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q7MKdG038397;
        Wed, 26 Oct 2022 07:40:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y572s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 07:40:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqsibnhDXTWcIeYYZPkP58j9O0DPzykbBV4qQYKC9EQeDqaiji2ix/vNy6hGB9W9+Pul3zuHIweXMBP+E21TMU7E0N3vBQCz5HMbUl4pHzVf+3ajpFMHCiPGd53ISrzfBAW1UM4B9g5Z+GPfJJW0W9Ov9eA8XqJC5rT6VRJl5MaxfcrDe9lA4pkjzqU0Roc1R7rjLbRVZlAmv2nNnHNaPwsqfYUr4fv/YZXJmyr370k3Bim2FFmLcLrOcAW2+GurQofFNI6cHXBZ04EQWezVIXKL9Xk4xj/yyO7yztU0uFuL80IICIfTvQoYvWiH0EtDRLulLubrf9yX1E5qgrLc0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MW/H/GSabE4ObnuVZhACb3v9Y8OB3ZQFHuAAj7jmbR8=;
 b=MCb5hDhbO1F/IeUPLng5fzsvouZW+lmr3rJDoGAJdSpke6v+30yyLY2mEZYwbTcqA/Tb4ZS22CiV1L+45SW6B8OAj8T0xiU0hE7ygcGwhJRTdSdOQvLwYBwKNd4VJKsZnIwj69qzTaizh0oP5DG3ZCDJgj7xBgiTWsaBvd5IQoGvWs42cQbUv3KeHsWnhBgrX1sOQviRw7Rvv/NIBWPGdtqAzfw+Kmoch5D+I8CX6+l5DZM441uiw9tAyU8mzSLPelNZdO6ST5YcB6RL8vtKTh8VpJ2bUgxMFMA3B7jj8K8JfFEGxD5Z/cfLvgzKbx3ow4qvx4FJuG+/p/XhGO6xGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MW/H/GSabE4ObnuVZhACb3v9Y8OB3ZQFHuAAj7jmbR8=;
 b=lCTCJjjKoqsxZ8aVxOBcMxA/wyXxkPrUmHdJ83drgqPOlGK5CFT6chAagIPreTSuWKs6caHwLtmxfq6vvz5n32TVfQ5hoohfOmRv82v79wDVqnMuYpEV1LJb3qkaiSVlR6nt2FuoE+kkEjbePGlvPbLxc4yW4x+cTz1HmzfvC2Y=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB5991.namprd10.prod.outlook.com (2603:10b6:8:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 26 Oct
 2022 07:40:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5746.023; Wed, 26 Oct 2022
 07:40:37 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 19/27] xfs: Add parent pointers to xfs_cross_rename
Thread-Topic: [PATCH v4 19/27] xfs: Add parent pointers to xfs_cross_rename
Thread-Index: AQHY5ZyssjD5UYyqKU6q+coOGpW+ca4fp06AgACp8QA=
Date:   Wed, 26 Oct 2022 07:40:36 +0000
Message-ID: <ff0962d6f109c8d61bd875a957d5c86e168fab49.camel@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
         <20221021222936.934426-20-allison.henderson@oracle.com>
         <Y1hV5WzaeYR742RX@magnolia>
In-Reply-To: <Y1hV5WzaeYR742RX@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|DM4PR10MB5991:EE_
x-ms-office365-filtering-correlation-id: e2b419d0-4e8f-403b-72bd-08dab7255f7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ofAZOKpJl0wiDfSVN8Pp7Qp2rC/xNqmwG8xeMOsd2Rqmo6VYpIkftVABIM+02dhEv5VFCt5Yy6SEAiV+8CPh48/LRVnu6aZm/fhCnjXWVVfUX9mTNhhxa1UPRolBir6TJM/7KLlIbSLIf8cMkFRAJU7QnifwGLUuDuRXvJlztngl90E4qxL9cjSETeRGJnRaLKJ6ZUFtPv34luJHcBUKAf9/EL8xrN6fJc0aQeEaY2b0ZmDBc7OvRyPU+DDtBJwqe3pRMDLNCVhBbIUD9w88D2ZhdmAxUkB7ra1Ta1YbHefqKlTOCzVBF1k4036Fh2afHx0teYFEdntH8ZbreZbim9ghpLkw4MMKK3twTlokZafO/Q4Rttseb6W58vb2W3vQzbGNuK12ecRSj7T7QtIjGrQ4ogRHCjEm8FuT7zXJVAF10QLcKp9Gf4x1YiLZnhOtZdU7g/Euv3SWXstDHHZ9qoBnMCtlO/gUZI6KQNFYzqHJTbR389YfRjF9lnxWw5fwoOCZwiH0DKTmZFD6hQHp9/hpRsWU49L96BS1sYyyyFfzXA2bWKDpHlycTstRwyE4bcMt7HceqXMQY7P2exLeln3Bo6FcMMnm3Hkvg7sVxRBHZz2VK/+caiiO6Ci6xuvQv48RIHCXj9Zb2q3qCJ3bjPiA8dqi1TO/21G9DQlo7WsTgv8W/j6Wgw7R/7YxUwqujo33PaaeQQQ1rgF3/LuRUO+Ea2t3zx4nVnsm3nAzwq/JfSWsEvomI1LnpBH20sX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(316002)(66556008)(44832011)(86362001)(66476007)(66446008)(4326008)(6916009)(76116006)(83380400001)(66946007)(2906002)(2616005)(186003)(64756008)(41300700001)(8676002)(8936002)(6512007)(478600001)(26005)(71200400001)(38070700005)(4001150100001)(38100700002)(6506007)(122000001)(36756003)(5660300002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTBjU09QemZ3TzVJdldSS3pqMXZMbVQ5YlJHamJvc3ZBdUlBU1RXTDFEMk9L?=
 =?utf-8?B?dklFRklYSEgyc2hQYkJaRFJDRDdhZGFaeSt0ak9TWm51aURFRU9udUgvM05V?=
 =?utf-8?B?RE9xRFIwMGgxOW9FR0ZMdzJ0K0pnN0h1VS9DeW93amE5MUF0RytJbEF6S1RZ?=
 =?utf-8?B?OENLaTBCZzE5QVlubXgraUFmTC9GYVB3MlQzejE1QVpaYndPT3VGd3JzTGYy?=
 =?utf-8?B?bWVlQ0VyUkF5Qzd0bmkwRzNhY2JxMzh5bFRsSTM4UjdYZWdvMzRoaWEwSEUw?=
 =?utf-8?B?bzN5b3E0Z0lKMnVZZDVaRDFkSkc1RzIvalNPdEhFRVdqYkFrQzJzY3hQMGNL?=
 =?utf-8?B?UVQxTFcvWlE3Z0o0VTFtRTYrZXMva1MrejVDOUJ2dHNDUTJTSlZhMXlQd2gr?=
 =?utf-8?B?M3lmUUtwMHFBa1RoUnhxZWttaE1IZnVrYmlNRkpHS25WeHBjSmhmeVRxNmhz?=
 =?utf-8?B?cXJZTVZpMDVjamlXa0h6UnZNa1BBSXlIbktKMnc5UHZJaUlpMDZtN28xd2Uz?=
 =?utf-8?B?UDUxeEFwZWt1dE56SkFxb1BYUllFNjFBTmIwVGt2TEpxZE1CVlR4L2xONjBo?=
 =?utf-8?B?T0dYdUM3QjhuZlJseGFKazlGRWIySFZmRTlvbXZFdnJqMDErcSs5T3FLNzA4?=
 =?utf-8?B?T09yeVpGTHJoWWJTTjlNRDl0U3JqbFA4WFNHRXZSOGt5Wld4SkcreFh4UFgv?=
 =?utf-8?B?YWV6Z3JhcGV4aCs5TUNGUTBxN1dieFZhaW5lcE5BRWwrSnMyd0VHczdlWStQ?=
 =?utf-8?B?STBvc2o4eFZZRzFiTWtXVzE1cThNQmh3Zkp5VFh3RXIzRHl1UFRHTU4yNEJy?=
 =?utf-8?B?TGZEeENoczdEQVJ4bW4zVDZmeWo4MlZtekgwa1BEM0NHVmkxVzFsa2o1N0Ex?=
 =?utf-8?B?WHpTUGRhWmtnRytXK0JZRjJ4SmV2aHVMQVU3UkdnM1BJdVpvV2JUVnk0cDQy?=
 =?utf-8?B?T0dnZTNLMkkzTS8xT0tRazZwUWZNaTVZVmRyMUhGVVE0K25LVFF4d2dodVl1?=
 =?utf-8?B?NmhGMWIyazVaMS9QTUlXa01PVHI3OHlUL25ZS3hqdzBnV25IRWE1eWhLUjRK?=
 =?utf-8?B?bTUvM2ExVlhvYlNsbExjL095VHhqeExKblNPdGZ4NzRMRkdYMXN6TGU0Y1BS?=
 =?utf-8?B?U2UrV3lkNzNHcWY5eGNnZWllcXNuc0xLRFVoaFQva1gxblFxVXR5NnBicVda?=
 =?utf-8?B?d0tvTlhLV2JzelgwTldta2ZRRDlXY0FsNDlKbFNZTHlUUG5paWU1VUdkV1JN?=
 =?utf-8?B?dEdreUZYeWpOUWVuUlNpb1pyMUZSNW9wL1MzMkUrZ0VSZlhsUzNwbG5LY0ZJ?=
 =?utf-8?B?b1lrdG55R29Pa0RjdWxpMjVJM2tYOTY4RlVLRGo0UGY3OWY2L3RHWVlFRHNO?=
 =?utf-8?B?bU1OWmJsUlZmem5jczJxcldyTXk4WVhhUUZGdlpaeFlLclBuY3g5QTBrL3Bu?=
 =?utf-8?B?UEJXZ3V3OWFXWWpIRk1uN1JIc3JtMGJ0NVRBMTBRYXZqb2hUTGgzMm93VGRO?=
 =?utf-8?B?K015VTR3RGVaaEx6ZHFBOU5vUWljUUhHbTYwa0YxUjhpbitiZGFPR3k1SHRH?=
 =?utf-8?B?TVVGU3hEUkJXS29lRGo3TlFDSy9iSTFvYWRrdjFhMWhNaFQxaldYdFVVclJL?=
 =?utf-8?B?K2ZCeTlxYlZrTkc3aThpU1B0QTFTL1Z4am9mK0MxaFVRNWM1Q210aTVmNmZa?=
 =?utf-8?B?VnBoakZYUC9UOHJLcXA1c1E5Q1JWNmVZa1hKQktxeEU2VUhodlRvbmc1a1J5?=
 =?utf-8?B?cFlBQ1FXNUdFTEhxZjhNa0toUEszTFVnNzd1Sy9Qb1pOd3BJbjdFbHVQeEVU?=
 =?utf-8?B?Nk9rWUlLdVBkMis4ODh0ZHhxUytQNlJ4bjZVZ3JCRGY2eE82MnNPWUx4VHZq?=
 =?utf-8?B?amhvU3VTelcrb0c1Mm5LWm04NVNuQ2FubXlkdFpMVVZlcFJFUEdxTlpNRS9C?=
 =?utf-8?B?MHVqK0taSnJIdElBWi9Ec0pETHJkUXZXVFU0VVoxTXdsOW9pQ3JZK0lLeURu?=
 =?utf-8?B?eGdxeVhMdFIrMVRhZHRlNUx4aUV0RGhnY0R0VmV0SThnOUxnaW1nY2ovUjJM?=
 =?utf-8?B?MXRyTDdaWnR6MlpxdEs2RVpqaVZPKzErMWdRSjhQZnhNM1k5NGlwWi83d3R6?=
 =?utf-8?B?dFdQYUNGMHNtUE5lenNMRVVuSW9xREhVTUp4azJhcUh4U1JqU1FySUpYM3g3?=
 =?utf-8?B?U1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81763B6FC6CE4A4CAC5BF9227EF5BDA8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b419d0-4e8f-403b-72bd-08dab7255f7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 07:40:36.9894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DeS04HLZ04ljkBEkmVpSUi4tGBLyjGy6vP9ae/C7pr5ZAq/bTzh5DDYh5a7DF7/nHOi/gY0lF1nyDUzGMH/8yTxgl1Yg/sy4SSJkao/jxsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_04,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210260042
X-Proofpoint-GUID: Q4-ICtUYj61W3QRM5aeLv2Y_m4-sAKdu
X-Proofpoint-ORIG-GUID: Q4-ICtUYj61W3QRM5aeLv2Y_m4-sAKdu
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVHVlLCAyMDIyLTEwLTI1IGF0IDE0OjMyIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gRnJpLCBPY3QgMjEsIDIwMjIgYXQgMDM6Mjk6MjhQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+ID4gCj4gPiBDcm9zcyByZW5hbWVzIGFyZSBo
YW5kbGVkIHNlcGFyYXRlbHkgZnJvbSBzdGFuZGFyZCByZW5hbWVzLCBhbmQKPiA+IG5lZWQgZGlm
ZmVyZW50IGhhbmRsaW5nIHRvIHVwZGF0ZSB0aGUgcGFyZW50IGF0dHJpYnV0ZXMgY29ycmVjdGx5
Lgo+ID4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGxpc29uIEhlbmRlcnNvbiA8YWxsaXNvbi5oZW5k
ZXJzb25Ab3JhY2xlLmNvbT4KPiA+IC0tLQo+ID4gwqBmcy94ZnMveGZzX2lub2RlLmMgfCA3OSAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0KPiA+IC0tLS0KPiA+IMKg
MSBmaWxlIGNoYW5nZWQsIDYzIGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQo+ID4gCj4g
PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19pbm9kZS5jIGIvZnMveGZzL3hmc19pbm9kZS5jCj4g
PiBpbmRleCA4M2NjNTJjMmJjZjEuLmM3OWQxMDQ3ZDExOCAxMDA2NDQKPiA+IC0tLSBhL2ZzL3hm
cy94ZnNfaW5vZGUuYwo+ID4gKysrIGIvZnMveGZzL3hmc19pbm9kZS5jCj4gPiBAQCAtMjc0Niwy
NyArMjc0Niw0OSBAQCB4ZnNfZmluaXNoX3JlbmFtZSgKPiA+IMKgICovCj4gPiDCoFNUQVRJQyBp
bnQKPiA+IMKgeGZzX2Nyb3NzX3JlbmFtZSgKPiA+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNf
dHJhbnPCoMKgwqDCoMKgwqDCoMKgKnRwLAo+ID4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19p
bm9kZcKgwqDCoMKgwqDCoMKgwqAqZHAxLAo+ID4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19u
YW1lwqDCoMKgwqDCoMKgwqDCoMKgKm5hbWUxLAo+ID4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhm
c19pbm9kZcKgwqDCoMKgwqDCoMKgwqAqaXAxLAo+ID4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhm
c19pbm9kZcKgwqDCoMKgwqDCoMKgwqAqZHAyLAo+ID4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhm
c19uYW1lwqDCoMKgwqDCoMKgwqDCoMKgKm5hbWUyLAo+ID4gLcKgwqDCoMKgwqDCoMKgc3RydWN0
IHhmc19pbm9kZcKgwqDCoMKgwqDCoMKgwqAqaXAyLAo+ID4gLcKgwqDCoMKgwqDCoMKgaW50wqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3BhY2VyZXMpCj4gPiAtewo+
ID4gLcKgwqDCoMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IDA7
Cj4gPiAtwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlwMV9mbGFn
cyA9IDA7Cj4gPiAtwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlw
Ml9mbGFncyA9IDA7Cj4gPiAtwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGRwMl9mbGFncyA9IDA7Cj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3RyYW5zwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqdHAsCj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgeGZzX2lub2RlwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqZHAxLAo+ID4gK8Kg
wqDCoMKgwqDCoMKgc3RydWN0IHhmc19uYW1lwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCpuYW1lMSwKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCppcDEsCj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZz
X2lub2RlwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqZHAyLAo+ID4gK8KgwqDCoMKg
wqDCoMKgc3RydWN0IHhmc19uYW1lwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpu
YW1lMiwKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCppcDIsCj4gPiArwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3BhY2VyZXMpCj4g
PiArewo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgKm1wID0gZHAxLT5pX21vdW50Owo+ID4gK8KgwqDCoMKgwqDCoMKgaW50
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGVycm9yID0gMDsKPiA+ICvCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpcDFfZmxhZ3MgPSAwOwo+ID4gK8Kg
wqDCoMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGlwMl9mbGFncyA9IDA7Cj4gPiArwqDCoMKgwqDCoMKgwqBpbnTCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZHAy
X2ZsYWdzID0gMDsKPiA+ICvCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBuZXdfZGlyb2Zmc2V0LAo+ID4gb2xk
X2Rpcm9mZnNldDsKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfcGFyZW50X2RlZmVywqDC
oMKgwqDCoMKgwqDCoMKgKm9sZF9wYXJlbnRfcHRyID0gTlVMTDsKPiA+ICvCoMKgwqDCoMKgwqDC
oHN0cnVjdCB4ZnNfcGFyZW50X2RlZmVywqDCoMKgwqDCoMKgwqDCoMKgKm5ld19wYXJlbnRfcHRy
ID0gTlVMTDsKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfcGFyZW50X2RlZmVywqDCoMKg
wqDCoMKgwqDCoMKgKm9sZF9wYXJlbnRfcHRyMiA9IE5VTEw7Cj4gPiArwqDCoMKgwqDCoMKgwqBz
dHJ1Y3QgeGZzX3BhcmVudF9kZWZlcsKgwqDCoMKgwqDCoMKgwqDCoCpuZXdfcGFyZW50X3B0cjIg
PSBOVUxMOwo+ID4gKwo+ID4gKwo+IAo+IE5pdDogZXh0cmEgYmxhbmsgbGluZQpPaywgd2lsbCBm
aXgKCj4gCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoeGZzX2hhc19wYXJlbnQobXApKSB7Cj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfcGFyZW50X2luaXQobXAs
ICZvbGRfcGFyZW50X3B0cik7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYg
KGVycm9yKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBnb3RvIG91dF90cmFuc19hYm9ydDsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBlcnJvciA9IHhmc19wYXJlbnRfaW5pdChtcCwgJm5ld19wYXJlbnRfcHRyKTsKPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3RyYW5zX2Fib3J0Owo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVycm9yID0geGZzX3BhcmVudF9pbml0KG1w
LCAmb2xkX3BhcmVudF9wdHIyKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBp
ZiAoZXJyb3IpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGdvdG8gb3V0X3RyYW5zX2Fib3J0Owo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGVycm9yID0geGZzX3BhcmVudF9pbml0KG1wLCAmbmV3X3BhcmVudF9wdHIyKTsKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3RyYW5zX2Fib3J0Owo+
ID4gK8KgwqDCoMKgwqDCoMKgfQo+ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqAvKiBTd2FwIGlu
b2RlIG51bWJlciBmb3IgZGlyZW50IGluIGZpcnN0IHBhcmVudCAqLwo+ID4gLcKgwqDCoMKgwqDC
oMKgZXJyb3IgPSB4ZnNfZGlyX3JlcGxhY2UodHAsIGRwMSwgbmFtZTEsIGlwMi0+aV9pbm8sCj4g
PiBzcGFjZXJlcywgTlVMTCk7Cj4gPiArwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19kaXJfcmVw
bGFjZSh0cCwgZHAxLCBuYW1lMSwgaXAyLT5pX2lubywKPiA+IHNwYWNlcmVzLCAmb2xkX2Rpcm9m
ZnNldCk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycm9yKQo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dF90cmFuc19hYm9ydDsKPiA+IMKgCj4gPiDCoMKgwqDC
oMKgwqDCoMKgLyogU3dhcCBpbm9kZSBudW1iZXIgZm9yIGRpcmVudCBpbiBzZWNvbmQgcGFyZW50
ICovCj4gPiAtwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19kaXJfcmVwbGFjZSh0cCwgZHAyLCBu
YW1lMiwgaXAxLT5pX2lubywKPiA+IHNwYWNlcmVzLCBOVUxMKTsKPiA+ICvCoMKgwqDCoMKgwqDC
oGVycm9yID0geGZzX2Rpcl9yZXBsYWNlKHRwLCBkcDIsIG5hbWUyLCBpcDEtPmlfaW5vLAo+ID4g
c3BhY2VyZXMsICZuZXdfZGlyb2Zmc2V0KTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3Ip
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3RyYW5zX2Fib3J0
Owo+ID4gwqAKPiA+IEBAIC0yODI3LDYgKzI4NDksMjAgQEAgeGZzX2Nyb3NzX3JlbmFtZSgKPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+ID4gwqDCoMKgwqDCoMKgwqDCoH0K
PiA+IMKgCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoeGZzX2hhc19wYXJlbnQobXApKSB7Cj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfcGFyZW50X2RlZmVyX3Jl
cGxhY2UodHAsIGRwMSwKPiAKPiBJc24ndCB4ZnNfcGFyZW50X2RlZmVyX3JlcGxhY2UoKSBhZGRl
ZCBpbiB0aGUgbmV4dCBwYXRjaD8KPiAKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG9sZF9wYXJlbnRfcHRyLCBvbGRfZGly
b2Zmc2V0LAo+ID4gbmFtZTIsIGRwMiwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5ld19wYXJlbnRfcHRyLCBuZXdfZGly
b2Zmc2V0LAo+ID4gaXAxKTsKPiAKPiBUaGUgY2hhbmdlcyB0byB4ZnNfcGFyZW50X2RlZmVyX3Jl
cGxhY2UgdGhhdCBJIG1lbnRpb24gaW4gdGhlIG5leHQKPiBwYXRjaAo+IG5vdHdpdGhzdGFuZGlu
ZywgdGhpcyBsb29rcyBnb29kIG5vdy4KPiAKT2ggSSB0aGluayB5b3VyZSByaWdodC4gIEkgdGhp
bmsgcHJvYmFibHkgSSBjYW4ganVzdCBzd2FwIHRoZXNlIHR3bwpwYXRjaGVzIGFuZCBpdCBzaG91
bGQgYmUgb2suICBUaGFua3MhCgpBbGxpc29uCgo+IC0tRAo+IAo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGlmIChlcnJvcikKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBvdXRfdHJhbnNfYWJvcnQ7Cj4gPiArCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfcGFyZW50X2RlZmVyX3JlcGxh
Y2UodHAsIGRwMiwKPiA+IG5ld19wYXJlbnRfcHRyMiwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5ld19kaXJvZmZzZXQs
IG5hbWUxLCBkcDEsCj4gPiBvbGRfcGFyZW50X3B0cjIsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBvbGRfZGlyb2Zmc2V0
LCBpcDIpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChlcnJvcikKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBvdXRf
dHJhbnNfYWJvcnQ7Cj4gPiArwqDCoMKgwqDCoMKgwqB9Cj4gPiArCj4gPiDCoMKgwqDCoMKgwqDC
oMKgaWYgKGlwMV9mbGFncykgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4
ZnNfdHJhbnNfaWNoZ3RpbWUodHAsIGlwMSwgaXAxX2ZsYWdzKTsKPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgeGZzX3RyYW5zX2xvZ19pbm9kZSh0cCwgaXAxLCBYRlNfSUxPR19D
T1JFKTsKPiA+IEBAIC0yODQxLDEwICsyODc3LDIxIEBAIHhmc19jcm9zc19yZW5hbWUoCj4gPiDC
oMKgwqDCoMKgwqDCoMKgfQo+ID4gwqDCoMKgwqDCoMKgwqDCoHhmc190cmFuc19pY2hndGltZSh0
cCwgZHAxLCBYRlNfSUNIR1RJTUVfTU9EIHwKPiA+IFhGU19JQ0hHVElNRV9DSEcpOwo+ID4gwqDC
oMKgwqDCoMKgwqDCoHhmc190cmFuc19sb2dfaW5vZGUodHAsIGRwMSwgWEZTX0lMT0dfQ09SRSk7
Cj4gPiAtwqDCoMKgwqDCoMKgwqByZXR1cm4geGZzX2ZpbmlzaF9yZW5hbWUodHApOwo+ID4gwqAK
PiA+ICvCoMKgwqDCoMKgwqDCoGVycm9yID0geGZzX2ZpbmlzaF9yZW5hbWUodHApOwo+ID4gK8Kg
wqDCoMKgwqDCoMKgZ290byBvdXQ7Cj4gPiDCoG91dF90cmFuc19hYm9ydDoKPiA+IMKgwqDCoMKg
wqDCoMKgwqB4ZnNfdHJhbnNfY2FuY2VsKHRwKTsKPiA+ICtvdXQ6Cj4gPiArwqDCoMKgwqDCoMKg
wqBpZiAobmV3X3BhcmVudF9wdHIpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
eGZzX3BhcmVudF9jYW5jZWwobXAsIG5ld19wYXJlbnRfcHRyKTsKPiA+ICvCoMKgwqDCoMKgwqDC
oGlmIChvbGRfcGFyZW50X3B0cikKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4
ZnNfcGFyZW50X2NhbmNlbChtcCwgb2xkX3BhcmVudF9wdHIpOwo+ID4gK8KgwqDCoMKgwqDCoMKg
aWYgKG5ld19wYXJlbnRfcHRyMikKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4
ZnNfcGFyZW50X2NhbmNlbChtcCwgbmV3X3BhcmVudF9wdHIyKTsKPiA+ICvCoMKgwqDCoMKgwqDC
oGlmIChvbGRfcGFyZW50X3B0cjIpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
eGZzX3BhcmVudF9jYW5jZWwobXAsIG9sZF9wYXJlbnRfcHRyMik7Cj4gPiArCj4gPiDCoMKgwqDC
oMKgwqDCoMKgcmV0dXJuIGVycm9yOwo+ID4gwqB9Cj4gPiDCoAo+ID4gLS0gCj4gPiAyLjI1LjEK
PiA+IAoK
