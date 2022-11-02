Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66BFAC43217
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 23:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiKBXCY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 19:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKBXCX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 19:02:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D871D105;
        Wed,  2 Nov 2022 16:02:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2Mta9U016155;
        Wed, 2 Nov 2022 23:02:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=sip8xlmfX3JfdxCUO6ZCPmmuAF2t/IswMnuObqvqMCY=;
 b=ayHXaZQLURP+dba25UPBckTX482LB2yDvcUNtCgs9yJgSthjoGmaoALpq2/61y1B1nv/
 x7zOlzgTWJtR5zAu/yt0uN+ytpMt3vbBPBdSbJmwf7EaV570VQlc5amRRkJ6VGp20i0P
 kIBKjfqwcfXa+QvDJ//mF7osOvJDjysjeYo8V7L2RWLVrnc1hASShvFq6v1J82ew+lDA
 ER/xDynJNbf15uazYAErcoMvWYYWmHc1Yq423sIIqIv1QLbmen90CZH0upPlnwch7b9P
 EXYDW/BI2L5wz8sOLQWWs+x+1Bp3qlFq1/F1szD9xaGo7FUcvjE9mFDgeHcrKIVCHx88 5g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgtkdar0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Nov 2022 23:02:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2L1xE3009747;
        Wed, 2 Nov 2022 23:02:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtmc3vf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Nov 2022 23:02:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5RB9nDAyIjD/5CsmiINRLqieMQs3HqrTAxVwAMimEo6WluFUWevQMsCSztR17pn5CVaw8hmK/3f+g8lojQWtbEC7PzcEgBJoqVw+g0gvMbcIOfzXh/W0QLVsLD6cQemCrQ3Eg9r3+SQ/4g9Hh2fFn1CxMstOc0rMe6XnVTefPSbm/9tIiBi3H9v97o5BlnMWo4eP2I1O/vfIU1RgWehIhzCuGWC6ZYBWNU3+/8hMzftapJWJBYUv/2qiPRW6yX4wwinvEasHqP5P0SNlpHYZFBUlmywU85zjo7F9qxLzebkmQRsTIniS/aIoRD0Kf7QL1X4Y/unXd4LxSRad9959Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sip8xlmfX3JfdxCUO6ZCPmmuAF2t/IswMnuObqvqMCY=;
 b=fQv84aNRfkOL9BLiWVk+J3ceImy+WU2+sZih766RF3fWkUDoY0RMs1eAso5yzr1fK1N4DzTSJjAYxffUY/GsAi4lHGrmu/8rex0SYkkmZlyaUlBJsPFRgiQYHlcsfjKbd6LuxYfTrX30jxp2grAd9HcwnktOf+jH6RGxNKVfZpUSnHZB0rW1qMIkghbwx+yFIfajGhLatZSFA361hHCZR6+6hO6ECG2APc4lr7sDbcSZLrrDFjpZ38ZmbrZ3/0V/Pbv6ZOPGeWACnkRxW7zGyTDn5LKmcST46jkaMeLZpPL5RtGnIGFXReSRoHp+LbR7Fdq73wV2DhZxcP3x5orQYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sip8xlmfX3JfdxCUO6ZCPmmuAF2t/IswMnuObqvqMCY=;
 b=bZpxmzHedwIlQEpQTT0M0IKe/8ym285cgxUA3xqLc21/LsTfT4Tli3fDkjESSQlVbgAF9Eel8ZvLkP2Qw//hYEUBUsqb2KmDJ3pRiEQUfQQDXW1FWqzynfx7lXd4jPmc3mwrTky+mq/6ZCDNCYqwAoqUKf9dFTiwTzX3k3ppl94=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW5PR10MB5849.namprd10.prod.outlook.com (2603:10b6:303:191::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Wed, 2 Nov
 2022 23:02:15 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5769.021; Wed, 2 Nov 2022
 23:02:15 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] common: add helpers for parent pointer tests
Thread-Topic: [PATCH v3 1/4] common: add helpers for parent pointer tests
Thread-Index: AQHY7w8m8JP1HMnxBU2WGjOYS/te5A==
Date:   Wed, 2 Nov 2022 23:02:15 +0000
Message-ID: <C84C3372-843A-4363-AC25-AFBD45A69F18@oracle.com>
References: <20221028215605.17973-1-catherine.hoang@oracle.com>
 <20221028215605.17973-2-catherine.hoang@oracle.com>
 <20221101061811.l3v7dko5kg5x4jbk@zlang-mailbox>
In-Reply-To: <20221101061811.l3v7dko5kg5x4jbk@zlang-mailbox>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|MW5PR10MB5849:EE_
x-ms-office365-filtering-correlation-id: afc80c34-7509-459b-c9ee-08dabd2648ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N1cgcWjWcQzGna0MyolU2dloQgHBezrn/9YaSvELL+V6TlAE7YVwvPs6wwiBc4j9OkJ9a117w+d3h6UgqhwcDm2FD3HZAzV4bxhDM1qq1+eZ7yvN/OT5TVsakJEcH1Kn1I9DaoFlZvthEM0sIm53NdMLUTt2NntAbfKZjwuC7Bt9ae/AKfFI5qDP05Tz6d2xfPscGf4sA5FTMUmB1EtoFKdj4u5BsOaHTRV2ERk/XuVVKlqsOgU/FyNYG6nGlbtHygO+kgp6pTVvAEduUNf09UbSUgkUmwHn+QCvNuCEbtfWFDovrja4yq34vm8Hgs/A/2n0UojD9TJJG82FVGYfTc3HmAe4F/hHtMRDyvE8P2wcRJ89NwAhYFfTAzRMvFeXP69m6OJgBjOh4LGhtyyeiGWefTvT7Eo7w2d17NhEbem8HiYAFsFdJ9PaUhkcj/7mZfDNtpQjdI24rx1VN/kQ9wjCFCK1Kud7Y5GPM8DClkBG69UlrxLaugz9HfzZMqVgaVRK5TLZQDQmG/6JkquexdComDhrmzB59PNN8DfNtMdVUAgfiHPMxNLcj+C0dc/9aLH3/ZmNK8UvzlpN/5hLbH9ydq0bWpH8N2Jy5a7Jf6P80UVY0XBI4MIrYjkDYXr3yEwreYnG2BMpWBG5TiJSxpzJ8rGYNyA5Qk1fEZ0+sj7p52dAxYs5h27UxVi3OZAjoK5tPn2za+c0wrBz/Sqw1dkdx/h7jZl8G9Hs3DZgaFkP22YJKs73/d67EaMsTOzGmjGXfhSkE9467fkBHIoDLlkw1Q5FlWG4w6TqjmnpGOkHnfed2GFnxMDl5+cM4GkS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199015)(86362001)(36756003)(33656002)(122000001)(38100700002)(38070700005)(83380400001)(44832011)(2906002)(66946007)(6512007)(186003)(6506007)(2616005)(53546011)(478600001)(54906003)(41300700001)(66476007)(6916009)(64756008)(71200400001)(4326008)(8676002)(316002)(91956017)(5660300002)(66556008)(66446008)(76116006)(8936002)(6486002)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk5aMzI0bGhNbWo2V0dITXpUTTd2QWFPYXUreHhObjZFNmlDdlVvZEI2aXBn?=
 =?utf-8?B?cDRlWVB0bGlGbVE2QVhxUG9PeURBbGpxV2JEelJvMFVGYkVnTDlUVVVZbU45?=
 =?utf-8?B?VGY5WHJCU1o5OFJ6OEh6YS8yTDhtT3l4a0pkM2Jsdi9rNEJ4VHZ1bGJ6ZXFN?=
 =?utf-8?B?TzB4MlBJUmRvUVMwUTdPN0pNKzljWHVmZ1lpYVlRTlZTTVdPY1dncU5OY0pv?=
 =?utf-8?B?Q3ZOY3IrbWhkeWx3ZkxVeVVrTE9aMDVNRU10NXZOenZOQXk4R0xsWmZEZHA3?=
 =?utf-8?B?eUsrcVNGdWtrSlEzZHRIN292dURRWGpCVVRVbDltaS9DVy85MmhGUzMvZkJl?=
 =?utf-8?B?RnRncWIyYmhsdVF3OXE2UDRMVG9icGtUZVh0OGZ5aGVucENxMkV6NEhJNXho?=
 =?utf-8?B?U0RPSDBTZ3VtemRKUUIvU1V1ejJ5LyswMEJLSlQ2bXJTZG52d2VTcnpyRE1X?=
 =?utf-8?B?b2lPT2RyVE15SFE0TG5HdUR6ZUI4QWlrMCtvQ21nb1JQM0VvdmZ5ckNwMDky?=
 =?utf-8?B?b2pwdGg4YkYzUXljcy93eGxGZisxUEtHOTJFdXIyVGRpNktmNmtHQ005VkNQ?=
 =?utf-8?B?cTgwNDNDRlMxYU5LSnpYWHNRSlFIb0lQckdDWkY2MWNYa3o5VEtlMnVXTFpW?=
 =?utf-8?B?encrOGljeG84QjdISFRJSnZKOFhHcWxFUFdCbXZESnZRUE4vdFA0cS8vK2hx?=
 =?utf-8?B?TjdNQlNsMmd2M1pSSVNweGtycmgxNGJQWWR4aHNEdzZ1NUM2K1dpZXNiYS9p?=
 =?utf-8?B?TzNwV2l2cTgzVWZxc0l5SXlZUGdLT2ZHY1dod2FwZXNCV2JIRk8yck1sWXlK?=
 =?utf-8?B?a3hYU0o3L20wMVM0NkZSbys3QWZ5Wlg2azIwYjhTVEVJM0FWN1gzMWplS1p1?=
 =?utf-8?B?c3IrQ2VxcS9UVldpcXg5dXh0NU93d3g3dHBnc2xnbnZOQmVGSVBMMHpiSUFF?=
 =?utf-8?B?WmRyWGEzMTgvWXlkaXg5bE1XQzI0cHNVWWVHdXNqMVR2em1hNjE4b2hrTE1H?=
 =?utf-8?B?dFFVS2NjNlhIdldhNkVvbkFLazFBeFlmZm9kSWlGZU1BRDFEWTZiTWQxN1Fv?=
 =?utf-8?B?emNjcU15TXljN3RVbUx6QUU2V2NMTnpkMTRDV0J2Tm9HUDRlVEE1b09SNlVM?=
 =?utf-8?B?bDBKcnNtOHgzY054VTFBMGJvNmo4SU54OFlocWkyVjg5LzE5VjJha1ZrK0dX?=
 =?utf-8?B?QndrbE9nUGZnZU9Gdm9MQ0NiS2lpNERTUGVmTXNzdjR1enJnd3pyNzNFUFZz?=
 =?utf-8?B?WWNubXhFWjJIV0d1NWs5bGRDeXlvNnMrK2I0YVBkWWc4MUtnNjhGZHROZzJJ?=
 =?utf-8?B?cmJWNFBnek1HN3lUUGU5empjNUtkVGlWZVBkY2t1QXZoR1lKZ3Z0eFgrMVpl?=
 =?utf-8?B?RGRGR0hEZDZrU1hHQ0VTdXNDVThpaEhoWk51RGtiMm9LU1RNdmtvcXFqaUlX?=
 =?utf-8?B?VUNXVmo0bDkvKzUxRjFWZWw3c0RYcjYvSWc1MGhOVmNuamhDRjQvd1NPRkNO?=
 =?utf-8?B?Ty8wVkRyTXlmV012bWRBeDdJZmpIWm1KWXIyVDMzR1Q5Rkd2NFdBaUhTUmND?=
 =?utf-8?B?R2pnYURQR1RmdXEraTh1ZjRRUXpFL2JqUUM1TFlNVnNWSDN6eWlXQTZWNnhj?=
 =?utf-8?B?RkxjRU96aGxBa3VWUU51bFI1cS9PK3ovcEVhZU9UTWttMkRBakc5ckN0MXhI?=
 =?utf-8?B?eDkrSWxVK1RISk5FZElDZTBaM1VtTzM2SUJvMmZsTCtvcEp6RFQyeDArMXFx?=
 =?utf-8?B?Ym00QXQwTjB1R2tKWXc4TW5LMGtmNlpMWHZXc2VUL1lEc0s5aGIzQmpBWSts?=
 =?utf-8?B?N1RLNlZlTWt5WTVpd3lVdm1UMzhZbHNBanhHK0xYUTdQK1NHZDU1ZzZoVEFK?=
 =?utf-8?B?c2J1NGdWbEhST0VXRnRra1B0ODgwYTdsaEc2K2lPTjhZUjczRzU5SmIyMFBj?=
 =?utf-8?B?QUlXeE9STmpnMGhRczkvaCtaQzlINld4K3RCV3VYT0V0UVNaVmh5U09xeWw2?=
 =?utf-8?B?alR4eWJmM016UXhzVmhDMU05Q3h3cmpxcFY2c3VVVUJaZW9ycGJvSGhjd2xn?=
 =?utf-8?B?eXlMUGd0SFFBcHIrV1AwRkMwbmEvSkxWZSswcEJFNE40bXJ0R2tzMG84NFlx?=
 =?utf-8?B?d2Flc1lFRTZUKytCZWlYNFBVODZxcVpYWVlOOCsxc0RVZXhSRExIK2ZURjNp?=
 =?utf-8?B?dzlQVUp3ZTI3QmxEb2dPTmUydFFPRUp3VTZ5aDF5UGM4eHc3amxxOVBBUEJs?=
 =?utf-8?B?Y3JwRU5UVFhPdVRaWXowNGRFd0xBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6052F0E8DADEF49AFE9D86519E2735A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc80c34-7509-459b-c9ee-08dabd2648ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 23:02:15.5606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PFR7hFQqka/AwcnmzgfpUKqadIJHVqvUwP4zEEFaDMn3KdTvwR8kpDeb+xxw1P0esxEAEAfhZv/DLX/DA0LysLmyxqJ6jeTRN0W42YkOwfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211020153
X-Proofpoint-ORIG-GUID: VZ4gl_U4U5x4ix3F0k3HubYyCgxCPkG9
X-Proofpoint-GUID: VZ4gl_U4U5x4ix3F0k3HubYyCgxCPkG9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBPY3QgMzEsIDIwMjIsIGF0IDExOjE4IFBNLCBab3JybyBMYW5nIDx6bGFuZ0ByZWRoYXQu
Y29tPiB3cm90ZToNCj4gDQo+IE9uIEZyaSwgT2N0IDI4LCAyMDIyIGF0IDAyOjU2OjAyUE0gLTA3
MDAsIENhdGhlcmluZSBIb2FuZyB3cm90ZToNCj4+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPg0KPj4gDQo+PiBBZGQgaGVscGVyIGZ1bmN0aW9u
cyBpbiBjb21tb24vcGFyZW50IHRvIHBhcnNlIGFuZCB2ZXJpZnkgcGFyZW50DQo+PiBwb2ludGVy
cy4gQWxzbyBhZGQgZnVuY3Rpb25zIHRvIGNoZWNrIHRoYXQgbWtmcywga2VybmVsLCBhbmQgeGZz
X2lvDQo+PiBzdXBwb3J0IHBhcmVudCBwb2ludGVycy4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTog
QWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb20+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBDYXRoZXJpbmUgSG9hbmcgPGNhdGhlcmluZS5ob2FuZ0BvcmFjbGUuY29tPg0K
Pj4gLS0tDQo+IA0KPiBMb29rcyBnb29kIHRvIG1lLCBqdXN0IGEgZmV3IHR5cG8gcHJvYmxlbSBh
cyBiZWxvdyAuLi4NCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3cyEgSeKAmWxsIGZpeCB0aGUgdHlw
b3MgaW4gdGhlIG5leHQgdmVyc2lvbg0KPiANCj4+IGNvbW1vbi9wYXJlbnQgfCAxOTggKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+IGNvbW1vbi9y
YyAgICAgfCAgIDMgKw0KPj4gY29tbW9uL3hmcyAgICB8ICAxMiArKysNCj4+IDMgZmlsZXMgY2hh
bmdlZCwgMjEzIGluc2VydGlvbnMoKykNCj4+IGNyZWF0ZSBtb2RlIDEwMDY0NCBjb21tb24vcGFy
ZW50DQo+PiANCj4+IGRpZmYgLS1naXQgYS9jb21tb24vcGFyZW50IGIvY29tbW9uL3BhcmVudA0K
Pj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+IGluZGV4IDAwMDAwMDAwLi5hMGJhN2Q5Mg0KPj4g
LS0tIC9kZXYvbnVsbA0KPj4gKysrIGIvY29tbW9uL3BhcmVudA0KPj4gQEAgLTAsMCArMSwxOTgg
QEANCj4+ICsjDQo+PiArIyBQYXJlbnQgcG9pbnRlciBjb21tb24gZnVuY3Rpb25zDQo+PiArIw0K
Pj4gKw0KPj4gKyMNCj4+ICsjIHBhcnNlX3BhcmVudF9wb2ludGVyIHBhcmVudHMgcGFyZW50X2lu
b2RlIHBhcmVudF9wb2ludGVyX25hbWUNCj4+ICsjDQo+PiArIyBHaXZlbiBhIGxpc3Qgb2YgcGFy
ZW50IHBvaW50ZXJzLCBmaW5kIHRoZSByZWNvcmQgdGhhdCBtYXRjaGVzDQo+PiArIyB0aGUgZ2l2
ZW4gaW5vZGUgYW5kIGZpbGVuYW1lDQo+PiArIw0KPj4gKyMgaW5wdXRzOg0KPj4gKyMgcGFyZW50
cwk6IEEgbGlzdCBvZiBwYXJlbnQgcG9pbnRlcnMgaW4gdGhlIGZvcm1hdCBvZjoNCj4+ICsjCQkg
IGlub2RlL2dlbmVyYXRpb24vbmFtZV9sZW5ndGgvbmFtZQ0KPj4gKyMgcGFyZW50X2lub2RlCTog
VGhlIHBhcmVudCBpbm9kZSB0byBzZWFyY2ggZm9yDQo+PiArIyBwYXJlbnRfbmFtZQk6IFRoZSBw
YXJlbnQgbmFtZSB0byBzZWFyY2ggZm9yDQo+PiArIw0KPj4gKyMgb3V0cHV0czoNCj4+ICsjIFBQ
SU5PICAgICAgICAgOiBQYXJlbnQgcG9pbnRlciBpbm9kZQ0KPj4gKyMgUFBHRU4gICAgICAgICA6
IFBhcmVudCBwb2ludGVyIGdlbmVyYXRpb24NCj4+ICsjIFBQTkFNRSAgICAgICAgOiBQYXJlbnQg
cG9pbnRlciBuYW1lDQo+PiArIyBQUE5BTUVfTEVOICAgIDogUGFyZW50IHBvaW50ZXIgbmFtZSBs
ZW5ndGgNCj4+ICsjDQo+PiArX3BhcnNlX3BhcmVudF9wb2ludGVyKCkNCj4+ICt7DQo+PiArCWxv
Y2FsIHBhcmVudHM9JDENCj4+ICsJbG9jYWwgcGlubz0kMg0KPj4gKwlsb2NhbCBwYXJlbnRfcG9p
bnRlcl9uYW1lPSQzDQo+PiArDQo+PiArCWxvY2FsIGZvdW5kPTANCj4+ICsNCj4+ICsJIyBGaW5k
IHRoZSBlbnRyeSB0aGF0IGhhcyB0aGUgc2FtZSBpbm9kZSBhcyB0aGUgcGFyZW50DQo+PiArCSMg
YW5kIHBhcnNlIG91dCB0aGUgZW50cnkgaW5mbw0KPj4gKwl3aGlsZSBJRlM9XC8gcmVhZCBQUElO
TyBQUEdFTiBQUE5BTUVfTEVOIFBQTkFNRTsgZG8NCj4+ICsJCWlmIFsgIiRQUElOTyIgIT0gIiRw
aW5vIiBdOyB0aGVuDQo+PiArCQkJY29udGludWUNCj4+ICsJCWZpDQo+PiArDQo+PiArCQlpZiBb
ICIkUFBOQU1FIiAhPSAiJHBhcmVudF9wb2ludGVyX25hbWUiIF07IHRoZW4NCj4+ICsJCQljb250
aW51ZQ0KPj4gKwkJZmkNCj4+ICsNCj4+ICsJCWZvdW5kPTENCj4+ICsJCWJyZWFrDQo+PiArCWRv
bmUgPDw8ICQoZWNobyAiJHBhcmVudHMiKQ0KPj4gKw0KPj4gKwkjIENoZWNrIHRvIHNlZSBpZiB3
ZSBmb3VuZCBhbnl0aGluZw0KPj4gKwkjIFdlIGRvIG5vdCBmYWlsIHRoZSB0ZXN0IGJlY2F1c2Ug
d2UgYWxzbyB1c2UgdGhpcw0KPj4gKwkjIHJvdXRpbmUgdG8gdmVyaWZ5IHdoZW4gcGFyZW50IHBv
aW50ZXJzIHNob3VsZA0KPj4gKwkjIGJlIHJlbW92ZWQgb3IgdXBkYXRlZCAgKGllIGEgcmVuYW1l
IG9yIGEgbW92ZQ0KPj4gKwkjIG9wZXJhdGlvbiBjaGFuZ2VzIHlvdXIgcGFyZW50IHBvaW50ZXIp
DQo+PiArCWlmIFsgJGZvdW5kIC1lcSAiMCIgXTsgdGhlbg0KPj4gKwkJcmV0dXJuIDENCj4+ICsJ
ZmkNCj4+ICsNCj4+ICsJIyBWZXJpZnkgdGhlIHBhcmVudCBwb2ludGVyIG5hbWUgbGVuZ3RoIGlz
IGNvcnJlY3QNCj4+ICsJaWYgWyAiJFBQTkFNRV9MRU4iIC1uZSAiJHsjcGFyZW50X3BvaW50ZXJf
bmFtZX0iIF0NCj4+ICsJdGhlbg0KPj4gKwkJZWNobyAiKioqIEJhZCBwYXJlbnQgcG9pbnRlcjoi
XA0KPj4gKwkJCSJuYW1lOiRQUE5BTUUsIG5hbWVsZW46JFBQTkFNRV9MRU4iDQo+PiArCWZpDQo+
PiArDQo+PiArCSNyZXR1cm4gc3VjZXNzDQo+PiArCXJldHVybiAwDQo+PiArfQ0KPj4gKw0KPj4g
KyMNCj4+ICsjIF92ZXJpZnlfcGFyZW50IHBhcmVudF9wYXRoIHBhcmVudF9wb2ludGVyX25hbWUg
Y2hpbGRfcGF0aA0KPj4gKyMNCj4+ICsjIFZlcmlmeSB0aGF0IHRoZSBnaXZlbiBjaGlsZCBwYXRo
IGxpc3RzIHRoZSBnaXZlbiBwYXJlbnQgYXMgYSBwYXJlbnQgcG9pbnRlcg0KPj4gKyMgYW5kIHRo
YXQgdGhlIHBhcmVudCBwb2ludGVyIG5hbWUgbWF0Y2hlcyB0aGUgZ2l2ZW4gbmFtZQ0KPj4gKyMN
Cj4+ICsjIEV4YW1wbGVzOg0KPj4gKyMNCj4+ICsjICNzaW1wbGUgZXhhbXBsZQ0KPj4gKyMgbWtk
aXIgdGVzdGZvbGRlcjENCj4+ICsjIHRvdWNoIHRlc3Rmb2xkZXIxL2ZpbGUxDQo+PiArIyB2ZXJp
ZnlfcGFyZW50IHRlc3Rmb2xkZXIxIGZpbGUxIHRlc3Rmb2xkZXIxL2ZpbGUxDQo+IA0KPiBfdmVy
aWZ5X3BhcmVudA0KPiANCj4+ICsjDQo+PiArIyAjIEluIHRoaXMgYWJvdmUgZXhhbXBsZSwgd2Ug
d2FudCB0byB2ZXJpZnkgdGhhdCAidGVzdGZvbGRlcjEiDQo+PiArIyAjIGFwcGVhcnMgYXMgYSBw
YXJlbnQgcG9pbnRlciBvZiAidGVzdGZvbGRlcjEvZmlsZTEiLiAgQWRkaXRpb25hbGx5DQo+PiAr
IyAjIHdlIHZlcmlmeSB0aGF0IHRoZSBuYW1lIHJlY29yZCBvZiB0aGUgcGFyZW50IHBvaW50ZXIg
aXMgImZpbGUxIg0KPj4gKyMNCj4+ICsjDQo+PiArIyAjaGFyZGxpbmsgZXhhbXBsZQ0KPj4gKyMg
bWtkaXIgdGVzdGZvbGRlcjENCj4+ICsjIG1rZGlyIHRlc3Rmb2xkZXIyDQo+PiArIyB0b3VjaCB0
ZXN0Zm9sZGVyMS9maWxlMQ0KPj4gKyMgbG4gdGVzdGZvbGRlcjEvZmlsZTEgdGVzdGZvbGRlcjIv
ZmlsZTFfbG4NCj4+ICsjIHZlcmlmeV9wYXJlbnQgdGVzdGZvbGRlcjIgZmlsZTFfbG4gdGVzdGZv
bGRlcjEvZmlsZTENCj4gDQo+IF92ZXJpZnlfcGFyZW50DQo+IA0KPj4gKyMNCj4+ICsjICMgSW4g
dGhpcyBhYm92ZSBleGFtcGxlLCB3ZSB3YW50IHRvIHZlcmlmeSB0aGF0ICJ0ZXN0Zm9sZGVyMiIN
Cj4+ICsjICMgYXBwZWFycyBhcyBhIHBhcmVudCBwb2ludGVyIG9mICJ0ZXN0Zm9sZGVyMS9maWxl
MSIuICBBZGRpdGlvbmFsbHkNCj4+ICsjICMgd2UgdmVyaWZ5IHRoYXQgdGhlIG5hbWUgcmVjb3Jk
IG9mIHRoZSBwYXJlbnQgcG9pbnRlciBpcyAiZmlsZTFfbG4iDQo+PiArIw0KPj4gK192ZXJpZnlf
cGFyZW50KCkNCj4+ICt7DQo+PiArCWxvY2FsIHBhcmVudF9wYXRoPSQxDQo+PiArCWxvY2FsIHBh
cmVudF9wb2ludGVyX25hbWU9JDINCj4+ICsJbG9jYWwgY2hpbGRfcGF0aD0kMw0KPj4gKw0KPj4g
Kwlsb2NhbCBwYXJlbnRfcHBhdGg9IiRwYXJlbnRfcGF0aC8kcGFyZW50X3BvaW50ZXJfbmFtZSIN
Cj4+ICsNCj4+ICsJIyBWZXJpZnkgcGFyZW50IGV4aXN0cw0KPj4gKwlpZiBbICEgLWQgJFNDUkFU
Q0hfTU5ULyRwYXJlbnRfcGF0aCBdOyB0aGVuDQo+PiArCQlfZmFpbCAiJFNDUkFUQ0hfTU5ULyRw
YXJlbnRfcGF0aCBub3QgZm91bmQiDQo+PiArCWVsc2UNCj4+ICsJCWVjaG8gIioqKiAkcGFyZW50
X3BhdGggT0siDQo+PiArCWZpDQo+PiArDQo+PiArCSMgVmVyaWZ5IGNoaWxkIGV4aXN0cw0KPj4g
KwlpZiBbICEgLWYgJFNDUkFUQ0hfTU5ULyRjaGlsZF9wYXRoIF07IHRoZW4NCj4+ICsJCV9mYWls
ICIkU0NSQVRDSF9NTlQvJGNoaWxkX3BhdGggbm90IGZvdW5kIg0KPj4gKwllbHNlDQo+PiArCQll
Y2hvICIqKiogJGNoaWxkX3BhdGggT0siDQo+PiArCWZpDQo+PiArDQo+PiArCSMgVmVyaWZ5IHRo
ZSBwYXJlbnQgcG9pbnRlciBuYW1lIGV4aXN0cyBhcyBhIGNoaWxkIG9mIHRoZSBwYXJlbnQNCj4+
ICsJaWYgWyAhIC1mICRTQ1JBVENIX01OVC8kcGFyZW50X3BwYXRoIF07IHRoZW4NCj4+ICsJCV9m
YWlsICIkU0NSQVRDSF9NTlQvJHBhcmVudF9wcGF0aCBub3QgZm91bmQiDQo+PiArCWVsc2UNCj4+
ICsJCWVjaG8gIioqKiAkcGFyZW50X3BwYXRoIE9LIg0KPj4gKwlmaQ0KPj4gKw0KPj4gKwkjIEdl
dCB0aGUgaW5vZGVzIG9mIGJvdGggcGFyZW50IGFuZCBjaGlsZA0KPj4gKwlwaW5vPSIkKHN0YXQg
LWMgJyVpJyAkU0NSQVRDSF9NTlQvJHBhcmVudF9wYXRoKSINCj4+ICsJY2lubz0iJChzdGF0IC1j
ICclaScgJFNDUkFUQ0hfTU5ULyRjaGlsZF9wYXRoKSINCj4+ICsNCj4+ICsJIyBHZXQgYWxsIHRo
ZSBwYXJlbnQgcG9pbnRlcnMgb2YgdGhlIGNoaWxkDQo+PiArCXBhcmVudHM9KCQoJFhGU19JT19Q
Uk9HIC14IC1jIFwNCj4+ICsJICJwYXJlbnQgLWYgLWkgJHBpbm8gLW4gJHBhcmVudF9wb2ludGVy
X25hbWUiICRTQ1JBVENIX01OVC8kY2hpbGRfcGF0aCkpDQo+PiArCWlmIFtbICQ/ICE9IDAgXV07
IHRoZW4NCj4+ICsJCSBfZmFpbCAiTm8gcGFyZW50IHBvaW50ZXJzIGZvdW5kIGZvciAkY2hpbGRf
cGF0aCINCj4+ICsJZmkNCj4+ICsNCj4+ICsJIyBQYXJzZSBwYXJlbnQgcG9pbnRlciBvdXRwdXQu
DQo+PiArCSMgVGhpcyBzZXRzIFBQSU5PIFBQR0VOIFBQTkFNRSBQUE5BTUVfTEVODQo+PiArCV9w
YXJzZV9wYXJlbnRfcG9pbnRlciAkcGFyZW50cyAkcGlubyAkcGFyZW50X3BvaW50ZXJfbmFtZQ0K
Pj4gKw0KPj4gKwkjIElmIHdlIGRpZG50IGZpbmQgb25lLCBiYWlsIG91dA0KPj4gKwlpZiBbICQ/
IC1uZSAwIF07IHRoZW4NCj4+ICsJCV9mYWlsICJObyBwYXJlbnQgcG9pbnRlciByZWNvcmQgZm91
bmQgZm9yICRwYXJlbnRfcGF0aCJcDQo+PiArCQkJImluICRjaGlsZF9wYXRoIg0KPj4gKwlmaQ0K
Pj4gKw0KPj4gKwkjIFZlcmlmeSB0aGUgaW5vZGUgZ2VuZXJhdGVkIGJ5IHRoZSBwYXJlbnQgcG9p
bnRlciBuYW1lIGlzDQo+PiArCSMgdGhlIHNhbWUgYXMgdGhlIGNoaWxkIGlub2RlDQo+PiArCXBw
cGlubz0iJChzdGF0IC1jICclaScgJFNDUkFUQ0hfTU5ULyRwYXJlbnRfcHBhdGgpIg0KPj4gKwlp
ZiBbICRjaW5vIC1uZSAkcHBwaW5vIF0NCj4+ICsJdGhlbg0KPj4gKwkJX2ZhaWwgIkJhZCBwYXJl
bnQgcG9pbnRlciBuYW1lIHZhbHVlIGZvciAkY2hpbGRfcGF0aC4iXA0KPj4gKwkJCSIkU0NSQVRD
SF9NTlQvJHBhcmVudF9wcGF0aCBiZWxvbmdzIHRvIGlub2RlICRQUFBJTk8sIlwNCj4+ICsJCQki
YnV0IHNob3VsZCBiZSAkY2lubyINCj4+ICsJZmkNCj4+ICsNCj4+ICsJZWNobyAiKioqIFZlcmlm
aWVkIHBhcmVudCBwb2ludGVyOiJcDQo+PiArCQkJIm5hbWU6JFBQTkFNRSwgbmFtZWxlbjokUFBO
QU1FX0xFTiINCj4+ICsJZWNobyAiKioqIFBhcmVudCBwb2ludGVyIE9LIGZvciBjaGlsZCAkY2hp
bGRfcGF0aCINCj4+ICt9DQo+PiArDQo+PiArIw0KPj4gKyMgX3ZlcmlmeV9wYXJlbnQgcGFyZW50
X3BvaW50ZXJfbmFtZSBwaW5vIGNoaWxkX3BhdGgNCj4gDQo+IF92ZXJpZnlfbm9fcGFyZW50DQo+
IA0KPj4gKyMNCj4+ICsjIFZlcmlmeSB0aGF0IHRoZSBnaXZlbiBjaGlsZCBwYXRoIGNvbnRhaW5z
IG5vIHBhcmVudCBwb2ludGVyIGVudHJ5DQo+PiArIyBmb3IgdGhlIGdpdmVuIGlub2RlIGFuZCBm
aWxlIG5hbWUNCj4+ICsjDQo+PiArX3ZlcmlmeV9ub19wYXJlbnQoKQ0KPj4gK3sNCj4+ICsJbG9j
YWwgcGFyZW50X3BuYW1lPSQxDQo+PiArCWxvY2FsIHBpbm89JDINCj4+ICsJbG9jYWwgY2hpbGRf
cGF0aD0kMw0KPj4gKw0KPj4gKwkjIFZlcmlmeSBjaGlsZCBleGlzdHMNCj4+ICsJaWYgWyAhIC1m
ICRTQ1JBVENIX01OVC8kY2hpbGRfcGF0aCBdOyB0aGVuDQo+PiArCQlfZmFpbCAiJFNDUkFUQ0hf
TU5ULyRjaGlsZF9wYXRoIG5vdCBmb3VuZCINCj4+ICsJZWxzZQ0KPj4gKwkJZWNobyAiKioqICRj
aGlsZF9wYXRoIE9LIg0KPj4gKwlmaQ0KPj4gKw0KPj4gKwkjIEdldCBhbGwgdGhlIHBhcmVudCBw
b2ludGVycyBvZiB0aGUgY2hpbGQNCj4+ICsJbG9jYWwgcGFyZW50cz0oJCgkWEZTX0lPX1BST0cg
LXggLWMgXA0KPj4gKwkgInBhcmVudCAtZiAtaSAkcGlubyAtbiAkcGFyZW50X3BuYW1lIiAkU0NS
QVRDSF9NTlQvJGNoaWxkX3BhdGgpKQ0KPj4gKwlpZiBbWyAkPyAhPSAwIF1dOyB0aGVuDQo+PiAr
CQlyZXR1cm4gMA0KPj4gKwlmaQ0KPj4gKw0KPj4gKwkjIFBhcnNlIHBhcmVudCBwb2ludGVyIG91
dHB1dC4NCj4+ICsJIyBUaGlzIHNldHMgUFBJTk8gUFBHRU4gUFBOQU1FIFBQTkFNRV9MRU4NCj4+
ICsJX3BhcnNlX3BhcmVudF9wb2ludGVyICRwYXJlbnRzICRwaW5vICRwYXJlbnRfcG5hbWUNCj4+
ICsNCj4+ICsJIyBJZiB3ZSBkaWRudCBmaW5kIG9uZSwgcmV0dXJuIHN1Y2Vzcw0KPj4gKwlpZiBb
ICQ/IC1uZSAwIF07IHRoZW4NCj4+ICsJCXJldHVybiAwDQo+PiArCWZpDQo+PiArDQo+PiArCV9m
YWlsICJQYXJlbnQgcG9pbnRlciBlbnRyeSBmb3VuZCB3aGVyZSBub25lIHNob3VsZDoiXA0KPj4g
KwkJCSJpbm9kZTokUFBJTk8sIGdlbjokUFBHRU4sIg0KPj4gKwkJCSJuYW1lOiRQUE5BTUUsIG5h
bWVsZW46JFBQTkFNRV9MRU4iDQo+PiArfQ0KPj4gZGlmZiAtLWdpdCBhL2NvbW1vbi9yYyBiL2Nv
bW1vbi9yYw0KPj4gaW5kZXggZDFmM2Q1NmIuLjlmYzBhNzg1IDEwMDY0NA0KPj4gLS0tIGEvY29t
bW9uL3JjDQo+PiArKysgYi9jb21tb24vcmMNCj4+IEBAIC0yNTM5LDYgKzI1MzksOSBAQCBfcmVx
dWlyZV94ZnNfaW9fY29tbWFuZCgpDQo+PiAJCWVjaG8gJHRlc3RpbyB8IGdyZXAgLXEgImludmFs
aWQgb3B0aW9uIiAmJiBcDQo+PiAJCQlfbm90cnVuICJ4ZnNfaW8gJGNvbW1hbmQgc3VwcG9ydCBp
cyBtaXNzaW5nIg0KPj4gCQk7Ow0KPj4gKwkicGFyZW50IikNCj4+ICsJCXRlc3Rpbz1gJFhGU19J
T19QUk9HIC14IC1jICJwYXJlbnQiICRURVNUX0RJUiAyPiYxYA0KPj4gKwkJOzsNCj4+IAkicHdy
aXRlIikNCj4+IAkJIyAtTiAoUldGX05PV0FJVCkgb25seSB3b3JrcyB3aXRoIGRpcmVjdCB2ZWN0
b3JlZCBJL08gd3JpdGVzDQo+PiAJCWxvY2FsIHB3cml0ZV9vcHRzPSIgIg0KPj4gZGlmZiAtLWdp
dCBhL2NvbW1vbi94ZnMgYi9jb21tb24veGZzDQo+PiBpbmRleCAxNzBkZDYyMS4uNzIzM2EyZGIg
MTAwNjQ0DQo+PiAtLS0gYS9jb21tb24veGZzDQo+PiArKysgYi9jb21tb24veGZzDQo+PiBAQCAt
MTM5OSwzICsxMzk5LDE1IEBAIF94ZnNfZmlsdGVyX21rZnMoKQ0KPj4gCQlwcmludCBTVERPVVQg
InJlYWx0aW1lID1SREVWIGV4dHN6PVhYWCBibG9ja3M9WFhYLCBydGV4dGVudHM9WFhYXG4iOw0K
Pj4gCX0nDQo+PiB9DQo+PiArDQo+PiArIyB0aGlzIHRlc3QgcmVxdWlyZXMgdGhlIHhmcyBwYXJl
bnQgcG9pbnRlcnMgZmVhdHVyZQ0KPj4gKyMNCj4+ICtfcmVxdWlyZV94ZnNfcGFyZW50KCkNCj4+
ICt7DQo+PiArCV9zY3JhdGNoX21rZnNfeGZzX3N1cHBvcnRlZCAtbiBwYXJlbnQgPiAvZGV2L251
bGwgMj4mMSBcDQo+PiArCQl8fCBfbm90cnVuICJta2ZzLnhmcyBkb2VzIG5vdCBzdXBwb3J0IHBh
cmVudCBwb2ludGVycyINCj4+ICsJX3NjcmF0Y2hfbWtmc194ZnMgLW4gcGFyZW50ID4gL2Rldi9u
dWxsIDI+JjENCj4+ICsJX3RyeV9zY3JhdGNoX21vdW50ID4vZGV2L251bGwgMj4mMSBcDQo+PiAr
CQl8fCBfbm90cnVuICJrZXJuZWwgZG9lcyBub3Qgc3VwcG9ydCBwYXJlbnQgcG9pbnRlcnMiDQo+
PiArCV9zY3JhdGNoX3VubW91bnQNCj4+ICt9DQo+PiAtLSANCj4+IDIuMjUuMQ0KPj4gDQo+IA0K
DQo=
