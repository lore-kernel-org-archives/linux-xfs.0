Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27EEC07E9D
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Sep 2022 21:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiIZVtk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiIZVti (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2022 17:49:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E70310FF
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 14:49:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QKdHr9025446;
        Mon, 26 Sep 2022 21:49:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RrbNXOMt/xcX/qm5zFwXU2irqAWL5Dq4/EE3eXTu+0w=;
 b=IKbXGH2LY9o+H19DZ4+5ZeFRM9EmbzCATLbtmmfC2YyUGE992tizV4mMnstuAXIXuwRn
 MFlESTLo2TzNHd+0kHoighGRFr7sAPB5rH+OBU0kqK8EORChOPLmkpSf9bppSz0oQPcr
 1WSG/Fm7l8CS05tFc5KFd3feHuuc9LHNsilgFl266y0yLQ8e3NiKcDVpLABEob4r3yCY
 YwxdPsaDgnDWD7aVZBMe2dtp0hvc2q6SK3LsTJBESDpTha1k8SUFdAAnyqGTPha01tfq
 BHGJTkUzir9Px6Tw7RXHUW31vCnb5fyDcOz3BrK+kSM73UEEiPDWS2l15G2GTbIzUmZV zA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstesw1e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:49:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28QJvPN5019595;
        Mon, 26 Sep 2022 21:49:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpu95aev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:49:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fyj2lCmFdwJUlggIo6Smma2F7ayi3Gnr7sO1eXfPlWDuLqCcU0es29DxjqTGvOB/JNXcSLzVuVL2eEH/N0aMKgNCvK4Wvt5IAdghVH9ImejtOh+xNRWpsNiu+Tj8+WDOSCWjEt7jPs3D7jp1ja2SFyKEhGbj67dQ687+znaqtPHwUYdbPDm/YUfxjKzH8b3HgOIi7epq0JrVyMyKLP6//wbCOuIoZqM+q80yFu751FqpjrGZFjjaz1er8BEQJA8R/O5mKa35/wZz81uBpyKn0hQIvEnGObojv7kBNPHC08QY0oZ1P4jjt1YCqMqP3J2z0OgHv/4/aLeYJ2G13Iiv4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrbNXOMt/xcX/qm5zFwXU2irqAWL5Dq4/EE3eXTu+0w=;
 b=mDkxWilkJEY9kVlenn7/KEGomVxAjLeS3brHxCPI37PUPVziXBsa8mMcxfEtITuslBNX4NfSTcbSgxREskP0Cd32VmwyPGDim6IomwxHukxHbisthZO4sZsWdbhuxj3io4Fz9SaRtxp9qzhcjyBvTD5UqksnfvJJOGKS6rJHXJrSOqcLUMqZ4PR9oW4bTSkbqSn2LpwKW4ehlTPIcy1YcP3zy8upTUqY7c2+pvu/vHwCqh9Wuw7/GF1LF83MkdoB1B9/TA3UQIG5/UX0mgs9VgHUQRRoPsnHudkMo0k6/ewE4PD9P5yEqWaGjYY6PZaohVyNFPTCRjuKESPxcoueMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrbNXOMt/xcX/qm5zFwXU2irqAWL5Dq4/EE3eXTu+0w=;
 b=n2IqltqZdhS/xsBy+rKpGQ9tOkDl3tlLpdi/V7eUzGkBwoC6qiRoj9AWRDVq9rGCpGBviI2QNk/OvbzlfZQLiursio05KqYOoXBzaXkV3fc5XfY7zXJh9L7snQB22uxRcCBX0Ssng6A9cRWp47O0sWc1UcXeBgQF1T/xa1RViKo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4689.namprd10.prod.outlook.com (2603:10b6:303:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 26 Sep
 2022 21:49:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 21:49:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 19/26] xfs: Indent xfs_rename
Thread-Topic: [PATCH v3 19/26] xfs: Indent xfs_rename
Thread-Index: AQHYzkaEy1bi5/OIu0m28Kvs/sTy/K3tiMGAgAS+YwA=
Date:   Mon, 26 Sep 2022 21:49:26 +0000
Message-ID: <b207c42a72b19a0fb332399e55ca98d0317a7124.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-20-allison.henderson@oracle.com>
         <Yy4js4SKxNyec41j@magnolia>
In-Reply-To: <Yy4js4SKxNyec41j@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CO1PR10MB4689:EE_
x-ms-office365-filtering-correlation-id: 7ad5920f-c627-482a-ee70-08daa008fb8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LlbJZyK3jpqXmp6nQk4DXvEdumZZznj+zeyJitdwycwpzBhJBkoM94se9u3AB++pZuSxQlHG7iLA4N5KZ3b0EZt3Em90vBWd7nO38LZNNRb3hNQ+FhDloAqMD/iZ9R+I1uzz5LDj+V8c256VIvQsmFBctrmrNGKFXbrnxCVijGtEn65MMaeongoGtyEDsv6d9RTzCpRC8e5xRtntfj/bBQ+iYDlqp1HJ7jmftkuKjIvvRq+sg2rcPdq8uPmkDAW1MOxwEwDc5D+l45Mf90UAEYWp4p1syqZjLmpGRSz1/g5/7r5vCt6C88cuFc7hq7PIDZdUmiol5EahL+rXouEAO9WgkQgVRQasTsi0prR8mWIElZAplhDWKAn8M39ho8XzIAs1iygHbJUDRAs+PwYA+k1sei7FMklogk/ZnMbahI4p/AXG9/HEq2AuAsJdtYGgLGMRmZC2pi7d7yxoPynhkOFaaGFqezxwbneaCuk3tNBM4rBC0ZNgBCTmsoka0al8Oe6onNy+eSwiEUQFj8bNXQBApS2bEV287La0slRc268aqzesUVq2P3cWWDV8IiCyVhOCyR2OsOGebOoZ92IOcUHOTBOlsWTjP8BSdHz4F/Sw1IG+yB0d2+84vi+Myv37tqYGkpuWDpbhqNDW1TB9zS6LOanLNsvap4c6HckpbSUCz5fQbc6W0cnL3eFmB4olhD0pwAsYtDhh0Y4lO7JZ1Uge8XCAd4W0lamNVvJjDHzMllHrSuHCi34nOqN0Bwy+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199015)(122000001)(2616005)(36756003)(2906002)(186003)(86362001)(44832011)(8936002)(38070700005)(6512007)(64756008)(66446008)(66476007)(66556008)(41300700001)(26005)(4326008)(8676002)(66946007)(76116006)(5660300002)(83380400001)(316002)(6506007)(6916009)(478600001)(6486002)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFM4NmpEOWlCT2ppbGl5dlBUcXJSdXM5SUhsNjRwRFFtWmN3R0dIbUFlK1JU?=
 =?utf-8?B?V29IZGU4THhFUmFNa2xrQTNjRDFKTkpOY21CM0dReG1JS1ZFdFp1R283VGpY?=
 =?utf-8?B?bEpzelRCWjlLZ3Y4aG9YdjFtS1dKRE9EdXJqWVlhZ25KcGRIcXZCUHlLTlFu?=
 =?utf-8?B?RHowMW9hNFl6c0h3dlFQbTExZWkzNnN2VUhtZUxHS0l6d0FNdGFVR014Zkxa?=
 =?utf-8?B?RjVGcVN0QVg5bUlhZ3dpby9veTRrWGhaVUdwazY3VTd4eUJVMzdNK0R3Tjdz?=
 =?utf-8?B?UHFseUQ3N3lIbU9kRTVaU3R0c1VQMjMyZGxtZlhBbVJNOXZ0UmZwWFo2ai9i?=
 =?utf-8?B?Q2dUZCtNMlFRUTdLTDh3WmovSCtSV0xwVWlReGdoYW1UVVlVaWxpLzBDSlRl?=
 =?utf-8?B?Z1hZK2lxQXhaK0JoK0Q1VFF0NllnTk1PSjMwQ1BLQzhmTXpvaHJaR3BySXpl?=
 =?utf-8?B?ZzFUWC9uaGtxdWp1S1NJaGFIZ3E2UkpHQjcrZ3dIRTMzcTNobDZFUVhKRnlY?=
 =?utf-8?B?Nlk2eTFrZ09yd1l5QmpTckhyNW1IMUtZZ1ZTQVJ4d3Q4bzM4dERpeDN6eXZV?=
 =?utf-8?B?YTRWMmxLU0pzWE5NTE9JSDV2Tm8xa0pNSWh4bFVwbWNveEpidVdHLzJpQW1K?=
 =?utf-8?B?ajlTZU9CNHJXWkdwcDJtZVV4bDRxYXRWR2YrM2oyWW5EOUJKeDl1Y1J3dHVH?=
 =?utf-8?B?L0xHSk5ISS93N203MVdEcng4bldJSmQ2eWpSaGJSMmhYNHA1V1NvdjBtQzh6?=
 =?utf-8?B?ODNpRkdyVU5LVFRnNjZtQVp2dGg1NmR0OFhqMXEzQ0wrSDRrN3AzUHJsL1VP?=
 =?utf-8?B?MU01L0RidWN0dzZkbkRVbXNqZUhCZmNqYVlUWmVoSmM0YzN4QWc5UUh1cTdQ?=
 =?utf-8?B?a0l5WUZna0ZVMGhrWW91ZWhTK1pOV2N6Um5QczNVMVZkbjMzSGV6Sm1OMWhH?=
 =?utf-8?B?b0VydTZUaDlPZjR3djg3Z0lWdXFpRHVBbUJyNDk4a3RRVFdtRHhkaVFKK1FB?=
 =?utf-8?B?S3loQ0dXRG5OSVczMDkzTG81Y3Y4MHRKZzI0VXNrWTlzUmxZa3RpMmtPbWZy?=
 =?utf-8?B?bCtkcjhrSkNPL2hBR1pyMVFCMmNiS0xENURNU3FEQ0hXQXN6bTg4RU1IQUhC?=
 =?utf-8?B?NHgzemNkTlhMeTAwaXpLQUgrOFg2Q0ZvUzRxeXgvQ3c2ZnllUEdhTjVKVm0y?=
 =?utf-8?B?SUdzeXZqcE9tdFdhbWpET2p0bXdLSEV4SDJITU1yWVZDY0VNYXhWdlRQaFli?=
 =?utf-8?B?Qlp1dEs1V2pocjlkbWhnR0N6VWd2QWhISUdUVjBHME0rVmZwZit2MHFXN0Vm?=
 =?utf-8?B?L3l2QXdEd0hhRlB5clJUNWZZSlpWcWZXdjI5UDFJVXBwbmk1aE1KNStidi91?=
 =?utf-8?B?VkRzUW9uNitOSHgwTllKOURTTDZEc0RNUmNZSDFRektJczV1NUM2TjgyVkxK?=
 =?utf-8?B?K1lQcDNjcFlTL3hEbm1KU3NYbWM0Uk4ydmRCbEpaNVdlVzZuVzhZTWNlU0Fp?=
 =?utf-8?B?OFRSNTBnRi9iQjB3dW0vUkdCNTJrVTdPb0JSK0s0SytMSmhtbXpvNUUwclZU?=
 =?utf-8?B?SFZIR2pSSnZxSnR2TDAzMnVyakVndDZybnJBSldlcVBCVTZXMlFFQXNNNGp3?=
 =?utf-8?B?UTQyckVPRzFzeFRNalhQcE5VbG5rZ21aWHU1UUhWQjd6L0VnQTBqRTZOY0Z2?=
 =?utf-8?B?RkdIa1ZObk95WmFXcDhPWjVRWGJLRWc5ZDZLUnp3UzJwdThVTEJva3hXL3J6?=
 =?utf-8?B?UVRncFZSaW5vekwwQ2JSRmtJdlhCNjdsNDNIK04zUWNjQzhOVGMrSTd1WEsz?=
 =?utf-8?B?TkJNT2NUR3ZmSjY2QlY5aFpxMlc5MkFOaEZmK1JBaEtScGhCQjJiZlBqZG5Q?=
 =?utf-8?B?dDdCb0tHZFRBZ0RLS3NGMUNwaHloQUF1UDFtRHpoeHhVWDVNdXpGanM5VVdP?=
 =?utf-8?B?dEJoS29VRWtkaWFEQldHSWhleURUTTJkN3dTcFJ4b1c1QXRtTDdlL1l1UUZD?=
 =?utf-8?B?NGwyeVY5WXl5ZTJqRkxyRUhuV3pjaUw1SS9DQzAwNkJlZTcrcUpadkdNelVF?=
 =?utf-8?B?bUd0cjRzRExnSERZTG5UTjR5QW5OeHIvUTduSXEza3JxUmxGekdqbXhycy9G?=
 =?utf-8?B?MHpVZDF0YlVvTitNQkU1dnllY0lKL1NHNWV4dUtES3RGMi9HQTZTQ3NYekw4?=
 =?utf-8?B?Y2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4CF7D9EFFA5DB46AAE93712F7BC1341@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad5920f-c627-482a-ee70-08daa008fb8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 21:49:26.6559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5wHvJQ/Yr/RfWBReCQJgcyrHpig5YOIu0dshG5DGZW0jKzhoFi8K77IofUCt6jqFWvMnOSVjj/gmcyMv8bl7kKeofud7+VkqnvDzKilXhHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_10,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260134
X-Proofpoint-GUID: qRQH1u936hu5la1NYsD01CHMnlN_heAy
X-Proofpoint-ORIG-GUID: qRQH1u936hu5la1NYsD01CHMnlN_heAy
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDE0OjIyIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMTA6NDQ6NTFQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+ID4gCj4gPiBJbmRlbnQgdmFyaWFibGVzIGFu
ZCBwYXJhbWV0ZXJzIGluIHhmc19yZW5hbWUgaW4gcHJlcGFyYXRpb24gZm9yCj4gPiBwYXJlbnQg
cG9pbnRlciBtb2RpZmljYXRpb25zLsKgIFdoaXRlIHNwYWNlIG9ubHksIG5vIGZ1bmN0aW9uYWwK
PiA+IGNoYW5nZXMuwqAgVGhpcyB3aWxsIG1ha2UgcmV2aWV3aW5nIG5ldyBjb2RlIGVhc2llciBv
biByZXZpZXdlcnMuCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+IAo+IEVhc3kgZW5vdWdoIDopCj4gUmV2aWV3
ZWQtYnk6IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+ClRoYW5rIHlvdSEKQWxs
aXNvbgoKPiAKPiAtLUQKPiAKPiA+IC0tLQo+ID4gwqBmcy94ZnMveGZzX2lub2RlLmMgfCAzOSAr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0KPiA+IMKgMSBmaWxlIGNoYW5n
ZWQsIDIwIGluc2VydGlvbnMoKyksIDE5IGRlbGV0aW9ucygtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0
IGEvZnMveGZzL3hmc19pbm9kZS5jIGIvZnMveGZzL3hmc19pbm9kZS5jCj4gPiBpbmRleCA1MTcy
NGFmMjJiZjkuLjRhODM5OWQzNWIxNyAxMDA2NDQKPiA+IC0tLSBhL2ZzL3hmcy94ZnNfaW5vZGUu
Ywo+ID4gKysrIGIvZnMveGZzL3hmc19pbm9kZS5jCj4gPiBAQCAtMjg5MSwyNiArMjg5MSwyNyBA
QCB4ZnNfcmVuYW1lX2FsbG9jX3doaXRlb3V0KAo+ID4gwqAgKi8KPiA+IMKgaW50Cj4gPiDCoHhm
c19yZW5hbWUoCj4gPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdXNlcl9uYW1lc3BhY2XCoMKgwqAq
bW50X3VzZXJucywKPiA+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKg
wqDCoMKgKnNyY19kcCwKPiA+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfbmFtZcKgwqDCoMKg
wqDCoMKgwqDCoCpzcmNfbmFtZSwKPiA+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXC
oMKgwqDCoMKgwqDCoMKgKnNyY19pcCwKPiA+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5v
ZGXCoMKgwqDCoMKgwqDCoMKgKnRhcmdldF9kcCwKPiA+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4
ZnNfbmFtZcKgwqDCoMKgwqDCoMKgwqDCoCp0YXJnZXRfbmFtZSwKPiA+IC3CoMKgwqDCoMKgwqDC
oHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKgwqDCoMKgKnRhcmdldF9pcCwKPiA+IC3CoMKgwqDC
oMKgwqDCoHVuc2lnbmVkIGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZsYWdzKQo+ID4gK8Kg
wqDCoMKgwqDCoMKgc3RydWN0IHVzZXJfbmFtZXNwYWNlwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpt
bnRfdXNlcm5zLAo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19pbm9kZcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgKnNyY19kcCwKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4
ZnNfbmFtZcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqc3JjX25hbWUsCj4gPiAr
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2RlwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAqc3JjX2lwLAo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19pbm9kZcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKnRhcmdldF9kcCwKPiA+ICvCoMKgwqDCoMKgwqDCoHN0
cnVjdCB4ZnNfbmFtZcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqdGFyZ2V0X25h
bWUsCj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2RlwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAqdGFyZ2V0X2lwLAo+ID4gK8KgwqDCoMKgwqDCoMKgdW5zaWduZWQgaW50
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZsYWdzKQo+ID4gwqB7Cj4g
PiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX21vdW50wqDCoMKgwqDCoMKgwqDCoCptcCA9IHNy
Y19kcC0+aV9tb3VudDsKPiA+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfdHJhbnPCoMKgwqDC
oMKgwqDCoMKgKnRwOwo+ID4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19pbm9kZcKgwqDCoMKg
wqDCoMKgwqAqd2lwID0gTlVMTDvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiB3aGl0ZW91dAo+
ID4gaW5vZGUgKi8KPiA+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKg
wqDCoMKgKmlub2Rlc1tfX1hGU19TT1JUX0lOT0RFU107Cj4gPiAtwqDCoMKgwqDCoMKgwqBpbnTC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpOwo+ID4gLcKgwqDCoMKg
wqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbnVtX2lu
b2RlcyA9IF9fWEZTX1NPUlRfSU5PREVTOwo+ID4gLcKgwqDCoMKgwqDCoMKgYm9vbMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBuZXdfcGFyZW50ID0gKHNyY19kcCAhPSB0
YXJnZXRfZHApOwo+ID4gLcKgwqDCoMKgwqDCoMKgYm9vbMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBzcmNfaXNfZGlyZWN0b3J5ID0KPiA+IFNfSVNESVIoVkZTX0koc3Jj
X2lwKS0+aV9tb2RlKTsKPiA+IC3CoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNwYWNlcmVzOwo+ID4gLcKgwqDCoMKgwqDCoMKgYm9vbMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXRyaWVkID0gZmFsc2U7Cj4g
PiAtwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBlcnJvciwgbm9zcGFjZV9lcnJvciA9IDA7Cj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qg
eGZzX21vdW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqbXAgPSBzcmNfZHAtPmlf
bW91bnQ7Cj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3RyYW5zwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAqdHA7Cj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2Rl
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqd2lwID0gTlVMTDvCoMKgwqDCoC8qIHdo
aXRlb3V0Cj4gPiBpbm9kZSAqLwo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19pbm9kZcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKmlub2Rlc1tfX1hGU19TT1JUX0lOT0RFU107
Cj4gPiArwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaTsKPiA+ICvCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBudW1faW5v
ZGVzID0KPiA+IF9fWEZTX1NPUlRfSU5PREVTOwo+ID4gK8KgwqDCoMKgwqDCoMKgYm9vbMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbmV3X3Bh
cmVudCA9IChzcmNfZHAgIT0KPiA+IHRhcmdldF9kcCk7Cj4gPiArwqDCoMKgwqDCoMKgwqBib29s
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBz
cmNfaXNfZGlyZWN0b3J5ID0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgU19JU0RJUihWRlNfSShzcmNfaQo+ID4gcCktPmlfbW9kZSk7Cj4gPiArwqDCoMKgwqDCoMKg
wqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgc3BhY2VyZXM7Cj4gPiArwqDCoMKgwqDCoMKgwqBib29swqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXRyaWVkID0gZmFsc2U7Cj4g
PiArwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IsIG5vc3BhY2VfZXJyb3IgPSAwOwo+ID4gwqAKPiA+
IMKgwqDCoMKgwqDCoMKgwqB0cmFjZV94ZnNfcmVuYW1lKHNyY19kcCwgdGFyZ2V0X2RwLCBzcmNf
bmFtZSwgdGFyZ2V0X25hbWUpOwo+ID4gwqAKPiA+IC0tIAo+ID4gMi4yNS4xCj4gPiAKCg==
