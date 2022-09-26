Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC73C07E9D
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Sep 2022 21:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiIZVuV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiIZVuT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2022 17:50:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8A53340D
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 14:50:17 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QKdKga025423;
        Mon, 26 Sep 2022 21:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=KO6NIm+SjgengiOLvYm3IGfBACmGTzN6QWdlbk9CDfs=;
 b=W0ijDuUDDJnR7rrf1x52T8freeDwMixyw79G/NzH245E+8oxN792inkfXc8mTpxoFNeB
 cX2vLWpDITdcDL2Sf7e69PdrjWW/3GVGdGJ/1FzFP6wV+a/LnepfOlgNmA04RO/pSuqO
 ypWs4E1Qk8TwVIBgaH6qiqVj/iyyCwbzMacR1qqClcQE4Qenm/FxLP4cc69zL0Vexrlf
 FwIeMiqYKfVZIKIelSiebfdEyFiuYWxKpDPv5xj8DlxAZ8cy03tXfDNwsUdMDo/bmZnE
 rWk0aNihDwhvS6fLZzckeSvp79n6paxiFzQ0xDYX9CAW7R0iQN6BaNQikCk9eld4V8js Ew== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstesw1g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:50:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28QKP5x9028880;
        Mon, 26 Sep 2022 21:50:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps4n73w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:50:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjGIxu9HKTiEFOoUPlBFD3YKEFqzgYnzSKtYj2vQP1Ig39Lc29ikEeueUKtLB2KfwiPQCrYI35UJof9aytlsWIQ4lD2PBHu19mumlPoBNtzvNYKMJ0Wn7ieUQRzzXl2p2weNlWISPJ8+pfeUlZDjz+IBbG1VUbbnUGTUHrnPNeKhQqbE/SaVYh2oiw/Hcu/wyRihUsXh0k+RTsKb9fvKai61mHcDIZSvliONzGHqzJeVNDsS1vdXzaBhZVkxDzPxKyfX/6DYEtE9E9EnakKBARarHxbQvtQsBz10oq8TiuZYqUKH+O7Z0+iif+NFKFqKFSjSfKxHFzESf9KBiCnS3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KO6NIm+SjgengiOLvYm3IGfBACmGTzN6QWdlbk9CDfs=;
 b=e8SVr5tN/G7eaqCO06OjmDEf7iQAmDEw7gGyjz9aoLG/sICuvAZTF9chSGtTrjHDKbGls8e2gitd5w4LeaGqYJjOkr8GqiaLA98H2y9oO2FydtL8XzVqMIid6/X5N4ibiDRgKL5YED+A9J8Z/PBeSujwVaA9Yu0kJ2b8aAmS/Qo16UKiWMTEGmsN+iFBtTMRhUQTZiBpMJj7UX9lQz4A7CL7ioWJqoPf6rZPmAAKNLsKZHh2xPcMZDzQoABF1T7BUkFH7pMQRG6fXqsd3ioXV/+O1VZj+fct8xI3BeVdjscNvqfHTiq2PfPnAkB+wwS35OxUBrKAJYvbMdzSovcxVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KO6NIm+SjgengiOLvYm3IGfBACmGTzN6QWdlbk9CDfs=;
 b=JVNcML9lAG7YOs/5VH71UCTTNXZ4hWHBho0exgFMkS5er87dtr9Xy80zG9BQ66HGYiPi7D7RTlfiHErAWl84dgzZSGUuQ9B9UDJMLsGF1z+5pHde1qVMYqLqOtR/HE9hQK1seSmspFAxe1xreQunGEKzG80ByJISfwbwAJRmKSg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA2PR10MB4699.namprd10.prod.outlook.com (2603:10b6:806:118::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 26 Sep
 2022 21:50:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 21:50:09 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 25/26] xfs: fix unit conversion error in
 xfs_log_calc_max_attrsetm_res
Thread-Topic: [PATCH v3 25/26] xfs: fix unit conversion error in
 xfs_log_calc_max_attrsetm_res
Thread-Index: AQHYzkaJyPP4Gpo26UOQgoiWLMjHua3tj4yAgAS3ygA=
Date:   Mon, 26 Sep 2022 21:50:09 +0000
Message-ID: <a0dcc3ad4144641a0cf8674501ae41145a22e392.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-26-allison.henderson@oracle.com>
         <Yy4pZcjowhK+WWNS@magnolia>
In-Reply-To: <Yy4pZcjowhK+WWNS@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SA2PR10MB4699:EE_
x-ms-office365-filtering-correlation-id: 6aa51e7a-12d2-4cd9-98b7-08daa00914e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TkSvO3HzsHafh4Af2GvPboCMfzj6ssQtYgWsUMKskiEMnZATpSjaFxAArfDV0WGhlZzsdTg4sJKRG+v7gMOPa64IBAG09y7IxTpty0djCUJbXIb3YCcleN3uonv/XYO6SDG5NoEfd/0rcsAjknAczBUQ2YjROhqz1ZywhUAo7sB/2v04JBY5vwTMqs8y1PxcmzB79QXlwwAy3TGr0CrvNsdrv98Im5szgW4ugpFQErCSVsz2uyLS8RUmnLRo7El2fGmC/8gr0QcRx9rfwN1G/ibUBUzmloe07UgvyOhOFRFwLUnEPCLHo1CT7TPTyj4fSyzphCESNuKLfyrzRB8pzBDcMVwb0rvLCcgRH7vIbRVvmyIySjGjWHiBJBgOK33q3OtWZoJ6pcbXJ+c3pzIvdwbHnh/i7oaT6vUeHptFGx68tDwW+70+tPmo2hRicVEg6QgqOWxcs4oIFvo4zH4UgU+g5M5KJncJuT76Qon+b0sS8+9GDyMiBDqDljajEPNZ9XqCuZ+7cfEUOTBq7VD/PuwJ7j45i31+zSWB+ZINgtL4QSbsPcn/Z9kTKlAh42pBSXUw1imJQ7zmqFOEo1lkUWGkPYiG+uEpYjqKVawUt52dwyMwQL9ND9u/Bc6uB6fU/jhQ0Ds/0RvOWtS/bIAObOIk2ErPZ5dg41W3YiUM8Wgb6mWyrw0oos3EjqlELxrHFk0pocJI1Ev0rusjiSh0BK7tRafJo/Fv7vWkPiG+whEC4SAijvWxSCY6QgI+cGQJ0cIVfaY6O6tOqDHv/CU4xQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199015)(26005)(2616005)(6506007)(6512007)(2906002)(122000001)(38100700002)(86362001)(6486002)(71200400001)(44832011)(5660300002)(478600001)(36756003)(38070700005)(186003)(83380400001)(41300700001)(76116006)(8676002)(64756008)(66446008)(4326008)(66476007)(66556008)(66946007)(8936002)(6916009)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MndZQWZrZjUxNDgrUVlPc0w5NmxYb0lmZzBrZTdFQ0FOVVc5K0RFRGI4TVI0?=
 =?utf-8?B?QUQ4K012Qy9Md1JYM0RaNW9Bb1l3OTlFWjNhZVpjdElleUJDSFcrL2s1NjRm?=
 =?utf-8?B?ZlNpT1hxZEVCalN4cHZrZlZKWVAvMjNZeFNQcTRoSzU1Tk54eWFyanBjNjdq?=
 =?utf-8?B?di94S2FxOXZCSHpJTGZNcXFBY00rRU5FZ1gvc0VEVlZQTXdDRTZUM1lhYy8y?=
 =?utf-8?B?eUNjQ0lMN0NTaDlZRHFzdmcvK0FtN3hVWklCdTVjQ0tLZEplcmVnVHVsUTFo?=
 =?utf-8?B?VmF2S0c2UGV2TVhFMmwvTFRHbXM0YXJpY1VhU0NNRWZSZmovbFc5a0RKSXdr?=
 =?utf-8?B?dnc1TE1WUXd2Z0NkVkl5ZFhCMU5QZ1BsLzRZTGJnWnVXeERlQU5uNFBVUkN3?=
 =?utf-8?B?R1BsMGRpUnV4UURCM21LbXh3Ylp6ZGs2aTVsTEhOY2JrREhnK2NBQjdSZ0RO?=
 =?utf-8?B?K2dqcEVDWjRaSVdYdERscW1JTkQ4VnZjYzNYMCs1cjFFdTJSL1N4YWVBOWNP?=
 =?utf-8?B?U0sxNjFpSUZzU1NQT2RkbzNUSEt0Z3U4dkRwSVZhMXJEMkZOanhud21NbVdZ?=
 =?utf-8?B?RmN4REU3anp2NG0yQW5zVjBhaDcwQ3I4Wmh6RnJnRU9NaERRQXFkcWltZjR4?=
 =?utf-8?B?Qk5aZmVsaml5WjVLRlUzZ1RlaS9qYmRvbjFtT0xhZG1rL2ZOdU1haUVpN2dn?=
 =?utf-8?B?NHVudHdTZlZqREcreTQ0UjhHcE9YUHFPMGsvdHR3ajlodG1KSmw2dnpDVDhW?=
 =?utf-8?B?S0lKNkU0L3IyRUtTNzdyejJORXp1Wm0zZkpOZ3J5a1pDWFkrVWlmN25DYzRK?=
 =?utf-8?B?TzdqS1VHQWdFUDY3bHJobEVlUFNEdGk1S0F6SEpyMWVNVUU0U0EyR05RZmE1?=
 =?utf-8?B?UGlxVE9Xc0kzTmEyU2FWcDNNcFpsQTFGK3lkN1ZnMzRWdkhsWVZTSTJLeVRj?=
 =?utf-8?B?WnRKMjhuVnpHZndIeW9CVzJiK2JWWWMyVVF5akw1YXhJeWFjSy9IcXZwcEVE?=
 =?utf-8?B?T3NjeHR2K1pKMElxdTNDQWc3b2ZxYVIrM3dMWStKTGJXUFcxUVpHdW1UMlgr?=
 =?utf-8?B?VndSMFdEc3YzUHpzZVhCRW4rSFhBb2E0akRlSFE0MDVBL2tjd1pvYkFlWFFD?=
 =?utf-8?B?cTRXZllhZVhkNUl2Y0U5ZE5hV3hvSU9UaklBOGkrNHdSTytPZDk1dy96Nmdk?=
 =?utf-8?B?RWNyZnJXNDRYYmxHd0JUSzgxZlBoMzdsa3B2ZU5tWWdHQXV5NzZoQmZwYlM1?=
 =?utf-8?B?MUtDUG83WkluaVYrVUxOR3o3U0lLNjN5UVZ6QzNuQXRmazJlczNRQjB3L0s2?=
 =?utf-8?B?cjhpRE55MjBndlNSSXZEeWlyMS96MktTcExBWW16MFI0TDVxOEVROTFFNUJ0?=
 =?utf-8?B?OUhuVzN1a2RlYkhpZURrNHVoSDNLcUxlVE5PdU40c1ZLT1FmK1lYR1ZQVnBB?=
 =?utf-8?B?SEJBbzMwWURvUUM0R3dNcG9tdnNvK0p0VHc3VExrSGQ0MEltSVRFVUVNUUI1?=
 =?utf-8?B?cStuaDArMnQzbklCYWh0VFZWaUdhOTJhSUQ2ditFRUt3dFNoQ0ErU203OC80?=
 =?utf-8?B?ZGlpcG1mSkhSaW94RGdMOVBYeFlRTmFWeWk4cTdZeDBQQjdBcXFrSnZvY0E4?=
 =?utf-8?B?Mk9WdFp0a2pQQmdEUlZ0S3YwYS9EYXF6cTBldzRYa21xRTNHdC9Qb2pZWW1o?=
 =?utf-8?B?clBLRURpUFdhNXFNUzBQVnFHRDRNeG5tL0l1czNxOFk0S2Y3SVRzMXBuS0dU?=
 =?utf-8?B?ZUNvOEM3bXFMczNEZXBROWNyNDBVMUpTTVRYOUJaaWVhdFM5aHE4NGNWQVR3?=
 =?utf-8?B?VXBnSWN5NENPYTZad0ZpcHBBMEczcjdpdlc4WnhxOEpkTk9vZ1RnTnVNVWJD?=
 =?utf-8?B?N2xzZmtQRHo4czhhMi9QbHdjQTdpZjlJRUFBdXdENFhJVXNydVhwSWFrUndm?=
 =?utf-8?B?OHRpcmVrR2VRbXFuWGZEeE03cmg2aERkOGZDbWRHelA1Y21xWE03em83ekpi?=
 =?utf-8?B?UkRBc1pmRmhKNktENlNqS0VJV281dFdic01HcVI0LzJPcUIxZ29WeUg1Nmw5?=
 =?utf-8?B?VFhFQmVUZ0l3VXErOEluK2M0OVBMZlVISngrYVlWdG9xdWNFU0xmSjNuWEw0?=
 =?utf-8?B?Z0wyZGcrelYvNHRxUUVlNWRFcVJWbTR6aXFsMjhRMGxhMXBuMVphaDlkR0dY?=
 =?utf-8?B?YkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1246505743AE7549B52517B5B59AD699@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aa51e7a-12d2-4cd9-98b7-08daa00914e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 21:50:09.1528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FvE+VGJwDeaQ4F5p3X7NswNmIa2gPP1dzW0DxDjuH+p25RcWxBHjVBIKNM6x6mXR5fg6A5bYjnv37oHmmWtzKMPM6DWEU8pQPbNI1WFimrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4699
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_10,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209260134
X-Proofpoint-GUID: BXHjCZFZRWB15MQfoKuYuasxqSCUoPQ-
X-Proofpoint-ORIG-GUID: BXHjCZFZRWB15MQfoKuYuasxqSCUoPQ-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDE0OjQ3IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMTA6NDQ6NTdQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+IAo+IEVyLCBkaWQgeW91IGNoYW5nZSB0aGlz
IHBhdGNoIG11Y2g/Cj4gCj4gSSB3YXMgcmVhbGx5IGhvcGluZyB5b3UnZCAqUlZCKiB0YWcgaXQg
YW5kIHNlbmQgaXQgYmFjayBvdXQuIDopCk9oLCBJIGRpZG50IGNoYW5nZSBhbnl0aGluZywgYnV0
IEkgYXNzdW1lZCBpZiBpdCdzIHVubWVyZ2VkIGl0J3MKc3VwcG9zZWQgdG8gaGF2ZSB0aGUgc3Vi
bWl0dGVycyBTT0I/ICBUaGUgc29iIGlzIGEgc29ydCBvZiBsZWdhbApzaWduYXR1cmUgdGhhdCB5
b3UgY2VydGlmeSB0aGF0IHRoZSBjb250ZW50cyBhcmUgY2xlYXIgdG8gYmUgb3BlbiBzcmMKcmln
aHQ/IAoKVEJILCBtb3N0IG9mIHRoZSBwYXRjaGVzIG9yaWdpbmFsbHkgY2FtZSBmcm9tIERhdmUg
b3IgTWFyaywgYnV0IGhhdmUKc29ydCBvZiBldm9sdmVkIG92ZXIgdGhlIHJldmlld3MgYW5kIHJl
YmFzZXMuICBJdCdzIG5vdCByZWFsbHkgY2xlYXIKd2hvIGF1dGhvcmVkIHdoYXQgYW55bW9yZSwg
YnV0IHRoZSBwb2ludCBpcyB0aGF0IGluIHN1Ym1pdHRpbmcgaXQsIHlvdQpjZXJ0aWZ5IHRoYXQg
bm8gb25lcyB1bi1zb2JlZCBjb2RlIGhhcyB3YW5kZXJlZCBpbi4KCkF0IGxlYXN0IHRoYXQgd2Fz
IG15IHVuZGVyc3RhbmRpbmc/CgoKCgo+IAo+IC0tRAo+IAo+ID4gCj4gPiBEYXZlIGFuZCBJIHdl
cmUgZGlzY3Vzc2luZyBzb21lIHJlY2VudCB0ZXN0IHJlZ3Jlc3Npb25zIGFzIGEgcmVzdWx0Cj4g
PiBvZgo+ID4gbWUgdHVybmluZyBvbiBucmV4dDY0PTEgb24gcmVhbHRpbWUgZmlsZXN5c3RlbXMs
IHdoZW4gd2Ugbm90aWNlZAo+ID4gdGhhdAo+ID4gdGhlIG1pbmltdW0gbG9nIHNpemUgb2YgYSAz
Mk0gZmlsZXN5c3RlbSBqdW1wZWQgZnJvbSA5NTQgYmxvY2tzIHRvCj4gPiA0Mjg3Cj4gPiBibG9j
a3MuCj4gPiAKPiA+IERpZ2dpbmcgdGhyb3VnaCB4ZnNfbG9nX2NhbGNfbWF4X2F0dHJzZXRtX3Jl
cywgRGF2ZSBub3RpY2VkIHRoYXQKPiA+IEBzaXplCj4gPiBjb250YWlucyB0aGUgbWF4aW11bSBl
c3RpbWF0ZWQgYW1vdW50IG9mIHNwYWNlIG5lZWRlZCBmb3IgYSBsb2NhbAo+ID4gZm9ybWF0Cj4g
PiB4YXR0ciwgaW4gYnl0ZXMsIGJ1dCB3ZSBmZWVkIHRoaXMgcXVhbnRpdHkgdG8KPiA+IFhGU19O
RVhURU5UQUREX1NQQUNFX1JFUywKPiA+IHdoaWNoIHJlcXVpcmVzIHVuaXRzIG9mIGJsb2Nrcy7C
oCBUaGlzIGhhcyByZXN1bHRlZCBpbiBhbgo+ID4gb3ZlcmVzdGltYXRpb24KPiA+IG9mIHRoZSBt
aW5pbXVtIGxvZyBzaXplIG92ZXIgdGhlIHllYXJzLgo+ID4gCj4gPiBXZSBzaG91bGQgbm9taW5h
bGx5IGNvcnJlY3QgdGhpcywgYnV0IHRoZXJlJ3MgYSBiYWNrd2FyZHMKPiA+IGNvbXBhdGliaWxp
dHkKPiA+IHByb2JsZW0gLS0gaWYgd2UgZW5hYmxlIGl0IG5vdywgdGhlIG1pbmltdW0gbG9nIHNp
emUgd2lsbAo+ID4gZGVjcmVhc2UuwqAgSWYKPiA+IGEgY29ycmVjdGVkIG1rZnMgZm9ybWF0cyBh
IGZpbGVzeXN0ZW0gd2l0aCB0aGlzIG5ldyBzbWFsbGVyIGxvZwo+ID4gc2l6ZSwgYQo+ID4gdXNl
ciB3aWxsIGVuY291bnRlciBtb3VudCBmYWlsdXJlcyBvbiBhbiB1bmNvcnJlY3RlZCBrZXJuZWwg
ZHVlIHRvCj4gPiB0aGUKPiA+IGxhcmdlciBtaW5pbXVtIGxvZyBzaXplIGNvbXB1dGF0aW9ucyB0
aGVyZS4KPiA+IAo+ID4gSG93ZXZlciwgdGhlIGxhcmdlIGV4dGVudCBjb3VudGVycyBmZWF0dXJl
IGlzIHN0aWxsIEVYUEVSSU1FTlRBTCwKPiA+IHNvIHdlCj4gPiBjYW4gZ2F0ZSB0aGUgY29ycmVj
dGlvbiBvbiB0aGF0IGZlYXR1cmUgKG9yIGFueSBmZWF0dXJlcyB0aGF0IGdldAo+ID4gYWRkZWQK
PiA+IGFmdGVyIHRoYXQpIGJlaW5nIGVuYWJsZWQuwqAgQW55IGZpbGVzeXN0ZW0gd2l0aCBucmV4
dDY0IG9yIGFueSBvZgo+ID4gdGhlCj4gPiBhcy15ZXQtdW5kZWZpbmVkIGZlYXR1cmUgYml0cyB0
dXJuZWQgb24gd2lsbCBiZSByZWplY3RlZCBieSBvbGQKPiA+IHVuY29ycmVjdGVkIGtlcm5lbHMs
IHNvIHRoaXMgc2hvdWxkIGJlIHNhZmUgZXZlbiBpbiB0aGUgdXBncmFkZQo+ID4gY2FzZS4KPiA+
IAo+ID4gU2lnbmVkLW9mZi1ieTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4K
PiA+IFNpZ25lZC1vZmYtYnk6IEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBv
cmFjbGUuY29tPgo+ID4gLS0tCj4gPiDCoGZzL3hmcy9saWJ4ZnMveGZzX2xvZ19ybGltaXQuYyB8
IDQzCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gPiDCoDEgZmlsZSBj
aGFuZ2VkLCA0MyBpbnNlcnRpb25zKCspCj4gPiAKPiA+IGRpZmYgLS1naXQgYS9mcy94ZnMvbGli
eGZzL3hmc19sb2dfcmxpbWl0LmMKPiA+IGIvZnMveGZzL2xpYnhmcy94ZnNfbG9nX3JsaW1pdC5j
Cj4gPiBpbmRleCA5OTc1YjkzYTc0MTIuLmU1YzYwNmZiN2E2YSAxMDA2NDQKPiA+IC0tLSBhL2Zz
L3hmcy9saWJ4ZnMveGZzX2xvZ19ybGltaXQuYwo+ID4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNf
bG9nX3JsaW1pdC5jCj4gPiBAQCAtMTYsNiArMTYsMzkgQEAKPiA+IMKgI2luY2x1ZGUgInhmc19i
bWFwX2J0cmVlLmgiCj4gPiDCoCNpbmNsdWRlICJ4ZnNfdHJhY2UuaCIKPiA+IMKgCj4gPiArLyoK
PiA+ICsgKiBEZWNpZGUgaWYgdGhlIGZpbGVzeXN0ZW0gaGFzIHRoZSBwYXJlbnQgcG9pbnRlciBm
ZWF0dXJlIG9yIGFueQo+ID4gZmVhdHVyZQo+ID4gKyAqIGFkZGVkIGFmdGVyIHRoYXQuCj4gPiAr
ICovCj4gPiArc3RhdGljIGlubGluZSBib29sCj4gPiAreGZzX2hhc19wYXJlbnRfb3JfbmV3ZXJf
ZmVhdHVyZSgKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfbW91bnTCoMKgwqDCoMKgwqDC
oMKgKm1wKQo+ID4gK3sKPiA+ICvCoMKgwqDCoMKgwqDCoGlmICgheGZzX3NiX2lzX3Y1KCZtcC0+
bV9zYikpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGZhbHNlOwo+
ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKHhmc19zYl9oYXNfY29tcGF0X2ZlYXR1cmUoJm1w
LT5tX3NiLCB+MCkpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHRy
dWU7Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoeGZzX3NiX2hhc19yb19jb21wYXRfZmVh
dHVyZSgmbXAtPm1fc2IsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB+KFhGU19TQl9GRUFUX1JPX0NPTVBBVF9GSU5PQlQg
fAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIFhGU19TQl9GRUFUX1JPX0NPTVBBVF9STUFQQlQgfAo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFhG
U19TQl9GRUFUX1JPX0NPTVBBVF9SRUZMSU5LIHwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBYRlNfU0JfRkVBVF9ST19D
T01QQVRfSU5PQlRDTlQpKSkKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gdHJ1ZTsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoGlmICh4ZnNfc2JfaGFzX2luY29tcGF0
X2ZlYXR1cmUoJm1wLT5tX3NiLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfihYRlNfU0JfRkVBVF9JTkNPTVBBVF9GVFlQ
RSB8Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgWEZTX1NCX0ZFQVRfSU5DT01QQVRfU1BJTk9ERVMgfAo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IFhGU19TQl9GRUFUX0lOQ09NUEFUX01FVEFfVVVJRCB8Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgWEZTX1NCX0ZFQVRf
SU5DT01QQVRfQklHVElNRSB8Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgWEZTX1NCX0ZFQVRfSU5DT01QQVRfTkVFRFNS
RVBBSVIgfAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIFhGU19TQl9GRUFUX0lOQ09NUEFUX05SRVhUNjQpKSkKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gdHJ1ZTsKPiA+ICsKPiA+ICvCoMKg
wqDCoMKgwqDCoHJldHVybiBmYWxzZTsKPiA+ICt9Cj4gPiArCj4gPiDCoC8qCj4gPiDCoCAqIENh
bGN1bGF0ZSB0aGUgbWF4aW11bSBsZW5ndGggaW4gYnl0ZXMgdGhhdCB3b3VsZCBiZSByZXF1aXJl
ZAo+ID4gZm9yIGEgbG9jYWwKPiA+IMKgICogYXR0cmlidXRlIHZhbHVlIGFzIGxhcmdlIGF0dHJp
YnV0ZXMgb3V0IG9mIGxpbmUgYXJlIG5vdCBsb2dnZWQuCj4gPiBAQCAtMzEsNiArNjQsMTYgQEAg
eGZzX2xvZ19jYWxjX21heF9hdHRyc2V0bV9yZXMoCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIE1BWE5BTUVMRU4gLSAxOwo+ID4gwqDCoMKgwqDCoMKgwqDCoG5ibGtzID0gWEZTX0RB
RU5URVJfU1BBQ0VfUkVTKG1wLCBYRlNfQVRUUl9GT1JLKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBu
YmxrcyArPSBYRlNfQl9UT19GU0IobXAsIHNpemUpOwo+ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKg
LyoKPiA+ICvCoMKgwqDCoMKgwqDCoCAqIFN0YXJ0aW5nIHdpdGggdGhlIHBhcmVudCBwb2ludGVy
IGZlYXR1cmUsIGV2ZXJ5IG5ldyBmcwo+ID4gZmVhdHVyZQo+ID4gK8KgwqDCoMKgwqDCoMKgICog
Y29ycmVjdHMgYSB1bml0IGNvbnZlcnNpb24gZXJyb3IgaW4gdGhlIHhhdHRyCj4gPiB0cmFuc2Fj
dGlvbgo+ID4gK8KgwqDCoMKgwqDCoMKgICogcmVzZXJ2YXRpb24gY29kZSB0aGF0IHJlc3VsdGVk
IGluIG92ZXJzaXplZCBtaW5pbXVtIGxvZwo+ID4gc2l6ZQo+ID4gK8KgwqDCoMKgwqDCoMKgICog
Y29tcHV0YXRpb25zLgo+ID4gK8KgwqDCoMKgwqDCoMKgICovCj4gPiArwqDCoMKgwqDCoMKgwqBp
ZiAoeGZzX2hhc19wYXJlbnRfb3JfbmV3ZXJfZmVhdHVyZShtcCkpCj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgc2l6ZSA9IFhGU19CX1RPX0ZTQihtcCwgc2l6ZSk7Cj4gPiArCj4g
PiDCoMKgwqDCoMKgwqDCoMKgbmJsa3MgKz0gWEZTX05FWFRFTlRBRERfU1BBQ0VfUkVTKG1wLCBz
aXplLCBYRlNfQVRUUl9GT1JLKTsKPiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuwqAg
TV9SRVMobXApLT50cl9hdHRyc2V0bS50cl9sb2dyZXMgKwo+ID4gLS0gCj4gPiAyLjI1LjEKPiA+
IAoK
