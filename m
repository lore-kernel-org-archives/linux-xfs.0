Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CB9FA373D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 07:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiJZHk6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 03:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiJZHkl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 03:40:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA86255AD
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 00:40:35 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nV4I030448;
        Wed, 26 Oct 2022 07:40:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=26+YaqCIthyX/n0gD5zCTLRePaX4tzw2ZZtZYCsSPgA=;
 b=sIpmT167mi7omCgzV12DB1L9B3sNuzpntAPnCyOCWtMynoTOrr+oXjmTelCglKIZp8lu
 y3CaHz9sEczvt6qItv91PMn3VCsrpdrs+6jkqAwq1ao8J/ey6tDR6oFi82D5wGk3AVw9
 QcyQ885YS9FmhPotQAwW8T2pmpOkGt6noOy36Xw+5rTsFMmB+Z7MkwHybodDTrXJUZqE
 +epFwfQB3XiG7ftzsFJhxn35hWM+BCn0c55Hm6bqZAsmvuoS/4v8ioBB7EaqC9Va642d
 /huTp4+EAlb9ejINK0h9sXwWTLufeNY6dWA9pHnWieWiHNUwSlvKCFreW+7bAHQdKZsQ HA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741x6dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 07:40:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q6n0Z7031853;
        Wed, 26 Oct 2022 07:40:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybg9s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 07:40:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MANWyAgQjmHAx75VWXI5LGaHwDbUxIFFjVEjZ/vJf5xoJ3Kc2QHTmjXxLyxUxRPjIlOveYnD/loUIUvjnwwTwPPNKQtMqhAAapfILRSj0Nb220zOAVgaTcRYNPzZtTXdqrmLRUJTeMioS5AqtwYzdU4Y7esbyE3TebDBmKk/mZbTkmm9mmEJHgrB4CRKG0LsjM3Q0YEMR/mE+tPJ5ilaPiWVT0rm9qI3aSozbBue8ZO2cWdYY8A5B7HY+bhySs0naq0IdaBL7M+W0Ud8HDvBKTNhhkQhIpXV8emSD4uz/hHfYEIT+HVPqM31dOfdbX3Xqb1rFhbDYStjram3QZCrFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26+YaqCIthyX/n0gD5zCTLRePaX4tzw2ZZtZYCsSPgA=;
 b=J2wC1mMYxZ+cSVWMR21/bqRnUNKn3Ki/sy5XvmgnvXFCHpMmh0XAFs0qXhldVLak9HBzXvNXElIkOGDe1O3YxzO7RKMINerMxApL4e3/5CHqysmelGgVeMDGDcl4oO1WiLLQxavwgCA3XIiTufxkoDlzRhtnlgzLns7Hi/XllYeKFqN0qfeSkGbZQwqSBZdJqLZOxcM16LvLD1fjGWeyAWnm9izdZFlFTuS+p8ZTCfx8ryXCtzMhgqtl9c1yD/oL1peZrt1zNCcgsaPi3zsUVRqZM0707MV5kVSQ9xFcmIqRVEbbqhbuQjELS79qotIWdDUzGqfDdYutxkw1c4pVwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26+YaqCIthyX/n0gD5zCTLRePaX4tzw2ZZtZYCsSPgA=;
 b=KFfKdjln9uFYZW4IR2/Sb2XWrJ8ssCyprm9FY8zjg+ceHC5Mwm9+NrgQQNA7/lt/gO4OJaCGWCv+Vm1rz+SaA2gQ45+RTElHkTSRaoMIPe4FEnKdB/QPScEja4aZvGe3R8rmiRK5EFMZVxOxFS2We/n4SqcbHm3mdFnRqYP3vsw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB5991.namprd10.prod.outlook.com (2603:10b6:8:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 26 Oct
 2022 07:40:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5746.023; Wed, 26 Oct 2022
 07:40:27 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 13/27] xfs: Increase rename inode reservation
Thread-Topic: [PATCH v4 13/27] xfs: Increase rename inode reservation
Thread-Index: AQHY5ZymgfIUULBTyEqvB37IXhjAaq4fgS+AgADQBAA=
Date:   Wed, 26 Oct 2022 07:40:27 +0000
Message-ID: <16387ef325eada568c66e1c464b797eb3f0c3b80.camel@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
         <20221021222936.934426-14-allison.henderson@oracle.com>
         <Y1g16xthTPijq/D8@magnolia>
In-Reply-To: <Y1g16xthTPijq/D8@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|DM4PR10MB5991:EE_
x-ms-office365-filtering-correlation-id: a0ba748e-fb43-4386-06bd-08dab72559cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o87rdaRmzOyQinW8m8rc1x+iwWwA0eE4UZ1DVu9Al/X7eap0mnqQEefG7uZCJWCN6T4rLBW5pXkpsLy2ju+aphwJ0S9LRy+qviGv6XNbr1XdtTayDmaLUg0h4AMmf8gBcvsXM8stAbdApxEVVE4F6r+bH15rKGcedJqyhcRBn663XuwXQTnReTh1jWbWt8nzLtWcMjhXLgammYJS++sj/PinjxyH3WEIyxVL+tntFyCtWkxYENt3vWoLlilad8t5UyqeWjyO1wp2acbb02Rre2tY4Emc/4CQmhXd71+MRwr4D8NJLqjwNgxzy3IqTD+BR55hYuIxoLSDqyGuQgSrOc9b0I3z3QODJWpqt99owY23hv7TmzeHC9146P5WjUd5lnZt1rhqQi2ueU/RJAmZGBR9Gvp+lB6ZF1ozaXK2hDIw9wfNU26SJmadhiU96ds+wcaQ6PAcu7B3VFVT7+xVMWse/qaDDIClNmxgaNyv7mBxELgBCZkoKQxnBwzorPDp9tYKwLOXjiJr8YFhaT6U4U1MRoxYfdR+Q1GjWeSuNAovg43STJxfZ7cLvkb65cbZmO+VO0AIopy0DCy4hCHDTjy3ebVZe7aJmr3b7p5RMT9rCqytQi5W0XQlmBtVeHYcbtm+AnsBW5bqwHErISXFS65m70vACpOPTwyta8PvcxcGQwbjKhKugpzWuWjupTDSKthkHt4kM8NgF9hSwTavfpT6Ghl/6solhRdqf3RDOkCvlykmu32FZGDMDsB4cPaY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(316002)(66556008)(44832011)(86362001)(66476007)(66446008)(4326008)(6916009)(76116006)(83380400001)(66946007)(2906002)(2616005)(186003)(64756008)(41300700001)(8676002)(8936002)(6512007)(478600001)(26005)(71200400001)(38070700005)(4001150100001)(38100700002)(6506007)(122000001)(36756003)(5660300002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0t3UlJxVC9CSkZWdmRMNENNaTkyZ0RZK1hoei9Yb0RDZXFVU252bG15V1JS?=
 =?utf-8?B?enpJb05rTXdVNDlNRjhUODhJZWZqKzdWYUNWY2ZmdFpPV2RHcWtrVjc0SWhk?=
 =?utf-8?B?YkhBZTNZbEJ0U25MamJGZWdhck1QaUNPbit4YVlQc0FvWldwTHdtMDN4cCtS?=
 =?utf-8?B?TDFjSHZrNzYzb1FUeWU2eHp6NVVvenN1RE91a2R3dndjeEZUNGdqMVp2QU1K?=
 =?utf-8?B?TDNLU1hCanRNMGRud3kyQTZ3K2Fzdy9LQWFmZ1R1bUVuaXFENDZIeU1jaGcv?=
 =?utf-8?B?bW5LaFVnWEkwa3dVUmNpbDZyR2hxc0FXTkcxb0FVbkxVcElLUld4U3gwRk5y?=
 =?utf-8?B?cDFGRHlvMWw5ZkFkanNVZkE1K0hvc29nNHI0a1Zudk9BdFh5cWQwM0p1dEJB?=
 =?utf-8?B?a2RjV08yRjNMclVSV3VYdHdoWWtBMDdzTk1vMHVoeTJxd3g2VjhTZXRKUENE?=
 =?utf-8?B?YjJaYXE4Mm5nNkJtakRQcm5TRU1Xdko1aElBQVM0c2w2SFJrRnhEeXh3TnFw?=
 =?utf-8?B?SWtkRE54YTIzdE1KUDlqWDVFRGxBeS9hQ1l0MGgvQ0o1c0pOOXFiN2ZPanRn?=
 =?utf-8?B?R2lDTjlBN05OQ09WaXV1V3NuRFN5MEQ5b0hlWVR0VklVZXVZa01CVDljNXNY?=
 =?utf-8?B?RnVSRklocjg1ZzVOYngzc2xGYWt2R1c2ZWZFNm1qK3V5T1pqTTF1R2JZUHd1?=
 =?utf-8?B?bVVuVDF0STN5V05PbFpUb1FxL1YyMHUwVXVUWFFRa2dOY3JxK1dVL3lmaG4y?=
 =?utf-8?B?QVBpZHY4eEd4LzNuMGpzUU1TUzN3a1F0dFdvTk9xYmFiY1pjVy9NN09waUxE?=
 =?utf-8?B?aVNUb0E2dTNFNUEza3RXWUE1Z2QvMklyeW9NcGs5clhxbk1rME5oUmVrTkdI?=
 =?utf-8?B?VDkxVGI3dEsxc3JYNlpZaXF2SHNiT2dYQ3RqNmtiNmp1NU1OdzhUd2hWZFBn?=
 =?utf-8?B?WURtTnluS3NZTlh1ZEhJeDgxUjgvRzBWMDFBSC9KczhoTi9JcU42RlUxTVB2?=
 =?utf-8?B?a3hrNXhWbzVFU3hVQ05RQVVVdldWOHhuMGtBMEhaMmd2cGdQcTNFdk5pREpn?=
 =?utf-8?B?NXA4amp4eHVoMVNvdEoyMTNZOUR1MWN1RTYzTmRSZHQydnVQdFVHdStPUVQr?=
 =?utf-8?B?bHUrNEwvbUJoU0VjRlVzYzdZVFRlTktnMi9maTNUVjhHeCtzMVhoeVpsdDB2?=
 =?utf-8?B?TmN4emJQWTRBZVFtTUZCeDNOdklqd3dhRmRJTWJHalVnLzU5TnVZdWNhK2Z1?=
 =?utf-8?B?Ujk5Smo0MHMyK2tNUk5HMTJWYVVSajZFaDdsczFLUGpTWkZDY2JvRXY4dVNH?=
 =?utf-8?B?OFAwaFNLSkU3QkhZNDRYOGFhL3BQRmZLVmVzcGV6WXppMWRla3JIazBScFR4?=
 =?utf-8?B?OTdnZjhsWmRYOTBJUGN0YjJyK3AyLzdwNGtwRmdNa1hSMS8wL0ZtdFdsZko0?=
 =?utf-8?B?Skh2S2t2a2Y0UnhpSG14MGJMcXRnYk40aFFGQWhEamlOandja2t2MDJlVlhW?=
 =?utf-8?B?ZVlDV3F4NjU2NDVtNE5mYy9acDJaQ3Q2ejA5VWR3a29iTVhiT3ptc2Rlc0h6?=
 =?utf-8?B?WnRJMkwycnpnU0RVTzd0NUFhNUZlaUJDamhFWjNYamxhMHNNQzh5MFE0UEFs?=
 =?utf-8?B?YnZRaXIybUIrQ2VoME5JbzQ2bjBoeFhxbHNuS3dpbFpPTDMxcFlvQThpQkxM?=
 =?utf-8?B?YTNNYmhrQTQ1aTY5UTE1ekdWMGNIbnJVRmdrZ0IyWGhEZHVGQTlGc09Ka3lS?=
 =?utf-8?B?OTBTb3M2ZmZSV3NVem5hR0hoKzhITUZLWEx2aXRsNmJRcmZZaVVhanF4bmR1?=
 =?utf-8?B?eHFrd1Z5RTY3aEVxLzdQRkcyamZwUmVzQVkxTHZGVkVJbWw0VTZKMENMc3Zv?=
 =?utf-8?B?Q2p5eVpJbFJsUFlTNmtXY1RCVlF6NEhMZWE4bWlZUmhYMTZESHVOWHRoMGda?=
 =?utf-8?B?YVEwSjhVOXBlWnVuRkdUL1JEejNVWVVHdW5YYjhsaXQydHBEYVN6Uk5TOCtO?=
 =?utf-8?B?YlBCZ2lWenM5bi9SNEZ4cEVOUXdSaE1VNzZob2w0SXppQjFpWlRKRzBTd0Ni?=
 =?utf-8?B?RFFRamJXMi9kbThjNm5aME1VVGhQaC9zbnF0WGdZT0pSQ3ZRMS9HQ1B6RlMx?=
 =?utf-8?B?bjRkckdnK0hsUmdobTVIZmV5OHVCeWxhTUZwbTl6NnkyN2ovUlNOSThHRlN2?=
 =?utf-8?B?U3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FF4901047792B4F9B97470AFB7021FF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0ba748e-fb43-4386-06bd-08dab72559cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 07:40:27.4406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LlF4H6pN5HDqMgteDXr+DMqCR6tjeRTeiH7w3Lx+k1xANG6ECGHSMXBsGUN5ouW4H9ScOB4l408jPgsgRKguM2Q4bvguZ9YuN9ur/MhUc54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_04,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260042
X-Proofpoint-GUID: ye1BZmrszESiIBU_jOrKtXeRIoddk3k6
X-Proofpoint-ORIG-GUID: ye1BZmrszESiIBU_jOrKtXeRIoddk3k6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVHVlLCAyMDIyLTEwLTI1IGF0IDEyOjE1IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
DQo+IE9uIEZyaSwgT2N0IDIxLCAyMDIyIGF0IDAzOjI5OjIyUE0gLTA3MDAsDQo+IGFsbGlzb24u
aGVuZGVyc29uQG9yYWNsZS5jb23CoHdyb3RlOg0KPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29u
IDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPg0KPiA+IA0KPiA+IHhmc19yZW5hbWUgY2Fu
IGxvY2sgdXAgdG8gNSBpbm9kZXM6IHNyY19kcCwgdGFyZ2V0X2RwLCBzcmNfaXAsDQo+ID4gdGFy
Z2V0X2lwDQo+ID4gYW5kIHdpcC7CoCBTbyB3ZSBuZWVkIHRvIGluY3JlYXNlIHRoZSBpbm9kZSBy
ZXNlcnZhdGlvbiB0byBtYXRjaC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGxpc29uIEhl
bmRlcnNvbiA8YWxsaXNvbi5oZW5kZXJzb25Ab3JhY2xlLmNvbT4NCj4gDQo+IExvb2tzIGdvb2Qs
IEknbGwgYWRkIHRoaXMgdG8gdGhlIDYuMSBmaXhlcy4NCj4gUmV2aWV3ZWQtYnk6IERhcnJpY2sg
Si4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQpHcmVhdCwgdGhhbmtzIQ0KQWxsaXNvbg0KPiAN
Cj4gLS1EDQo+IA0KPiA+IC0tLQ0KPiA+IMKgZnMveGZzL2xpYnhmcy94ZnNfdHJhbnNfcmVzdi5j
IHwgNCArKy0tDQo+ID4gwqBmcy94ZnMveGZzX2lub2RlLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfCAyICstDQo+ID4gwqAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhmcy94ZnNfdHJhbnNf
cmVzdi5jDQo+ID4gYi9mcy94ZnMvbGlieGZzL3hmc190cmFuc19yZXN2LmMNCj4gPiBpbmRleCAy
YzRhZDZlNGJiMTQuLjViMmYyN2NiZGI4MCAxMDA2NDQNCj4gPiAtLS0gYS9mcy94ZnMvbGlieGZz
L3hmc190cmFuc19yZXN2LmMNCj4gPiArKysgYi9mcy94ZnMvbGlieGZzL3hmc190cmFuc19yZXN2
LmMNCj4gPiBAQCAtNDIyLDcgKzQyMiw3IEBAIHhmc19jYWxjX2l0cnVuY2F0ZV9yZXNlcnZhdGlv
bl9taW5sb2dzaXplKA0KPiA+IMKgDQo+ID4gwqAvKg0KPiA+IMKgICogSW4gcmVuYW1pbmcgYSBm
aWxlcyB3ZSBjYW4gbW9kaWZ5Og0KPiA+IC0gKsKgwqDCoCB0aGUgZm91ciBpbm9kZXMgaW52b2x2
ZWQ6IDQgKiBpbm9kZSBzaXplDQo+ID4gKyAqwqDCoMKgIHRoZSBmaXZlIGlub2RlcyBpbnZvbHZl
ZDogNSAqIGlub2RlIHNpemUNCj4gPiDCoCAqwqDCoMKgIHRoZSB0d28gZGlyZWN0b3J5IGJ0cmVl
czogMiAqIChtYXggZGVwdGggKyB2MikgKiBkaXIgYmxvY2sNCj4gPiBzaXplDQo+ID4gwqAgKsKg
wqDCoCB0aGUgdHdvIGRpcmVjdG9yeSBibWFwIGJ0cmVlczogMiAqIG1heCBkZXB0aCAqIGJsb2Nr
IHNpemUNCj4gPiDCoCAqIEFuZCB0aGUgYm1hcF9maW5pc2ggdHJhbnNhY3Rpb24gY2FuIGZyZWUg
ZGlyIGFuZCBibWFwIGJsb2Nrcw0KPiA+ICh0d28gc2V0cw0KPiA+IEBAIC00MzcsNyArNDM3LDcg
QEAgeGZzX2NhbGNfcmVuYW1lX3Jlc2VydmF0aW9uKA0KPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgeGZzX21vdW50wqDCoMKgwqDCoMKgwqDCoCptcCkNCj4gPiDCoHsNCj4gPiDCoMKgwqDCoMKg
wqDCoMKgcmV0dXJuIFhGU19EUVVPVF9MT0dSRVMobXApICsNCj4gPiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgbWF4KCh4ZnNfY2FsY19pbm9kZV9yZXMobXAsIDQpICsNCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWF4KCh4ZnNfY2FsY19pbm9kZV9yZXMobXAsIDUp
ICsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHhmc19jYWxj
X2J1Zl9yZXMoMiAqIFhGU19ESVJPUF9MT0dfQ09VTlQobXApLA0KPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIFhGU19GU0JfVE9fQihtcCwgMSkpKSwNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAoeGZzX2NhbGNfYnVmX3Jlcyg3LCBtcC0+bV9zYi5zYl9zZWN0c2l6ZSkg
Kw0KPiA+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2lub2RlLmMgYi9mcy94ZnMveGZzX2lub2Rl
LmMNCj4gPiBpbmRleCA3MWQ2MDg4NTAwMGUuLmVhN2FlYWI4MzljMiAxMDA2NDQNCj4gPiAtLS0g
YS9mcy94ZnMveGZzX2lub2RlLmMNCj4gPiArKysgYi9mcy94ZnMveGZzX2lub2RlLmMNCj4gPiBA
QCAtMjg0OCw3ICsyODQ4LDcgQEAgeGZzX3JlbmFtZSgNCj4gPiDCoMKgwqDCoMKgwqDCoMKgICog
TG9jayBhbGwgdGhlIHBhcnRpY2lwYXRpbmcgaW5vZGVzLiBEZXBlbmRpbmcgdXBvbg0KPiA+IHdo
ZXRoZXINCj4gPiDCoMKgwqDCoMKgwqDCoMKgICogdGhlIHRhcmdldF9uYW1lIGV4aXN0cyBpbiB0
aGUgdGFyZ2V0IGRpcmVjdG9yeSwgYW5kDQo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqIHdoZXRoZXIg
dGhlIHRhcmdldCBkaXJlY3RvcnkgaXMgdGhlIHNhbWUgYXMgdGhlIHNvdXJjZQ0KPiA+IC3CoMKg
wqDCoMKgwqDCoCAqIGRpcmVjdG9yeSwgd2UgY2FuIGxvY2sgZnJvbSAyIHRvIDQgaW5vZGVzLg0K
PiA+ICvCoMKgwqDCoMKgwqDCoCAqIGRpcmVjdG9yeSwgd2UgY2FuIGxvY2sgZnJvbSAyIHRvIDUg
aW5vZGVzLg0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgKi8NCj4gPiDCoMKgwqDCoMKgwqDCoMKgeGZz
X2xvY2tfaW5vZGVzKGlub2RlcywgbnVtX2lub2RlcywgWEZTX0lMT0NLX0VYQ0wpOw0KPiA+IMKg
DQo+ID4gLS0gDQo+ID4gMi4yNS4xDQo+ID4gDQoNCg==
