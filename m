Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AEBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Dec 2022 21:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiLIVWX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Dec 2022 16:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIVWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2022 16:22:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D896B4E0C
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 13:22:20 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9Iwjs1021971;
        Fri, 9 Dec 2022 21:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=K67ba7NHvibBxbvj6GedGZJSV5ozsDmcXceZYgV0Smg=;
 b=nwQ0uvrxnXVscqBa81XWhX7HwoiBvvlDGMptwkVv5pAEC9wyveHfm/ShnvaqNLPeJ5A+
 kyCmibCvFzEstAkEFhBUL8qSnUg6lJUzmCxPwx75JUZB7/Dh8CAEuJcPgaviWeIZX6F1
 vYGgm/qV9ISs0mFHsr6Vj/r8gMi11SZBmM9dgsF89BIvaB1hZ2N2qbHEwJHsU70t4oqP
 JCZL34ZXlqAV+KJ0GcexBqr1l0BBa4gN/Tfvz3xV0by3VWxfgmA6I96OCT1Mkdfm3R+G
 2kXaTY0Knh/ynTKBSFfpt9NRSJa/+zPKMniclr9ogbaAQlvCAerSHMet4XeEr5A46UPW qg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maujknxy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 21:22:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9Jo6tp032061;
        Fri, 9 Dec 2022 21:22:14 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7gpjs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 21:22:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqly7qmjYGhSGZnhCrB7NCrUNoWiIQoYIbOrvZ56cJPr38WZhEIuMa6pH2jYi0RZQRrWQ2hq0dCxbtoSrZ48oiub5REYDXTnd/2wUggSTNy2icvfVDPSEc3BxNrrbq1fARKCcUbvTkemB1+QRfhhbiE7wfBwIIm3W/tcVzsihCf6SdwYnIuVHHyp992jGWhbL0C8aGfDV2svh4fhdyV6h13/44lioDPj55T8HTfoXo1GoqXv/KxOWV9PeS5jTF27fyjhbRBde70qf40+nbiR9A7n16kB0K7FZLuBfzWkGGJeOUi+DrZt9EIAufstWgV8jvdRf9AI/fZf71Kz+nPUNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K67ba7NHvibBxbvj6GedGZJSV5ozsDmcXceZYgV0Smg=;
 b=fzL3T8N4x07axWRAnYiQO/hoReNyOuwp+7TJU0ieH9fpn3XOAaqaDg7d1jLX3GiiNx4EcLJimqs3jrmijsQn1NtIsME2ES/CKfegXhIsWDoKlN2YPIhHm/mCRVnUokwqkckivawbEGoyFZSnnHBYpifdgDr1HfapT4J2G/H+WmR9ZwIridLYXcna2OWFhjr8BlfqaXpf/lL+s/xNlwPcsKukj+z5d4HsE/8UlbzP884tIGmfb4VkhDdMp9a/Seb2bwawh6Xi6DjwWQyOeIvviLt1KZ2P4Ml7VLkO6qBCey04zmqQNGyf/LbhEUTpuuHENHfqN7sqpyd/VWUGK6f3eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K67ba7NHvibBxbvj6GedGZJSV5ozsDmcXceZYgV0Smg=;
 b=mFe2X4NCx/kYXMweOZOYixhWhpnCaoD2pYelnG1dEQ0eNsLoQ2WJxTjTZfDdw1XbxL3NdNKiCFgWm8YMQbq5KwTjymL67x0a/Qrp9Jp3QYWbJQ/fJX+9LB+gA0Lnw8OQpifRG/I9zHMGmPxm2h12IAxXye+eA8RCZGH7FeJIk5c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ1PR10MB5929.namprd10.prod.outlook.com (2603:10b6:a03:48c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 21:22:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%5]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 21:22:11 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "cmaiolino@redhat.com" <cmaiolino@redhat.com>,
        "djwong@kernel.org" <djwong@kernel.org>,
        Catherine Hoang <catherine.hoang@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] xfs_admin: get UUID of mounted filesystem
Thread-Topic: [PATCH v1 2/2] xfs_admin: get UUID of mounted filesystem
Thread-Index: AQHZCeMAc++UR3lbZ0uh1VWM/OMgFq5jFiKAgAL+sYA=
Date:   Fri, 9 Dec 2022 21:22:11 +0000
Message-ID: <e3470873750d5a034a72238ad9895d63170b81fc.camel@oracle.com>
References: <20221207022346.56671-1-catherine.hoang@oracle.com>
         <20221207022346.56671-3-catherine.hoang@oracle.com>
         <Y5Ej3Q9DWtpQ4+Cq@magnolia>
In-Reply-To: <Y5Ej3Q9DWtpQ4+Cq@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SJ1PR10MB5929:EE_
x-ms-office365-filtering-correlation-id: b1a11099-a92d-417e-08c7-08dada2b6f96
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W8yHWCe25vxY1ML+UcMXzyD4W0QYdhIOwnwPFstfh9sGe465bHXXkK5SpAR00i5nbnHOvO28DB2CRQxpZi6Xq4ak6PjA0evXKUpicbzQ8VdFQ8BkQ+igoqUBdQ3JsRawB/mBzFdTMgJDF3xJJ1aBPFpgW9e2gjYXBEbUUgZVWaQ5KpuLtJAadFLK/csZPv0pssRZj5hRqKoXqTQP/fCmGjTWQgjeiQYAK6gbvUoiyjoZCaWLX4Z17bqRJAZcWIDREGoPVfNSNUU41g7PXHz9+FkGDTjlIiwuNuEXk6D7bofPb8fgFYYHGhcsgDD9MJfpulubRevn3QBuNfm3bu93E3ZImbKNJ84KeLaxxDmEV89SbEDQjgVBX1gOXR3/zHNBEiGAZzw85U+FzlvIQVKS5p+iKPeeCYWiNgDJNwiQBppBcBbjQLBlaHq5VII2GTzqJDTdPe3hi2HhDEuxWzsCNrOc3hL44t4uCYo+TojpCuC0ot/I8Fm3984gH2LgLGL2MF6HttZpOsSQzkX/IEPGWVMpTtGRDr6RB5i18Q0zzoKu9VTIxSzCPSmKK65/HklMzzggNPFaLgsCj8cuDG2IEcxnEAxMKFzrEf+FSP9uzqZ0gbn3+33IPcQR9fBjKKspESeEUL+zdek5py3HchmCGDd6TqXgWwVmQcdcpWTD05HY61u/doFNL6huadPlXSXDNfLVi71aaucj+aasoRlRTNv3//Ud9hTcgEzSrZogAqM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199015)(110136005)(6636002)(316002)(86362001)(6506007)(26005)(186003)(71200400001)(6512007)(6486002)(36756003)(38070700005)(38100700002)(122000001)(2616005)(83380400001)(966005)(44832011)(66476007)(91956017)(4326008)(76116006)(66946007)(64756008)(8676002)(66556008)(2906002)(5660300002)(66446008)(41300700001)(8936002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2laaytDVFlpQ2U3VTNLYVhLbXBFZU01QWh3cnVSWEdldkFIUGhqK2ppMDgy?=
 =?utf-8?B?Tnl3am1ZdnEybVFQNEpqWTFuaU16VklNa0duN1gyTUtKUGFkMEJCekFQUjJq?=
 =?utf-8?B?cU85Nk9zYzFHdk9BN0VyRThyWnk3T0dXcE5WaUNudHcwVGFQVnk1SEZkd2Ur?=
 =?utf-8?B?TEtVWVJreCtsWmFWME5xRlREZVk3WXVuQ1d6OUN1MmxUdEdGVFFjZUlxTmEv?=
 =?utf-8?B?VnFydjFXaUtudHhRamVESkxoWHpWZzVMdHJEamp6aEk1SGxkdFd4bWo5a2VX?=
 =?utf-8?B?Ti8xNkZWQmFNaGZ0NmFUREkzOFN6SWJ4U3BmcWExdExPemV2NUFxQklsTTNh?=
 =?utf-8?B?ZFE4bmV1bVV5aFZ4bVdRb2tIWkxzdmxEY1VZR2c4elZrdnFPTUIzRXlDUmFR?=
 =?utf-8?B?SjgrVGNpYnEwU3RtT1cvcnA4SlNjVmg3MEFyWHhKVmZYOXpkc05pKzYzd1M0?=
 =?utf-8?B?clVhWHhjRE5ydnl6U2ZjUStOMnpwK21rWERQQVB0WHp3a04wTGxPNWFwZWFZ?=
 =?utf-8?B?ZFU3bU0xcjZOZmhpRk1EWHFrWnlhbDFqOXFqd0x1WVRwSmdpRlVrRWh5Tnpj?=
 =?utf-8?B?OTYvQmFIcWozOURYcGJ4VUgrRmcwVXl1Z3ZzZzAvRmRhSzFkQWNNTFdoaWMy?=
 =?utf-8?B?TGNBQWF1RTdCYkY1Q3JXS2h0VlAraXA1d25XSjZFZEZGak1sd0NvSFQ5aXBp?=
 =?utf-8?B?ZFNhZjdraW5WRVNBRnhGMnVlTWtrNHhITFNQeFFJSWtCS2NETk5ENnp5TVJl?=
 =?utf-8?B?Q2F1NjdTbk93Yi9veUZxM2NuVjZtcjMwa3ZQem9QdERHZW9YM2lOd3JyVDBt?=
 =?utf-8?B?aHFHTXJVK1QyV0VTNVU5UldvTmpsL3RTdHpJc2FZZjBEZUFkV1diOHIrR2l4?=
 =?utf-8?B?MDQvSSsvUVpGRUhKakt1TS92RGxTb2lGYmlTUnAxRUlRWE0vUUdESjhObUVr?=
 =?utf-8?B?ZmVvQTJGRy9RTWYweDBaNjFpV3g5Zlp4RmFWZEVRcjJCd3AzT1ZoNm5Td1Fp?=
 =?utf-8?B?TC9JRmVOaG5pRy9DTDErS2JMYXZDT2FKd2g4WFBtMmZqZFMwMG1XSks1S1M1?=
 =?utf-8?B?U2MyaDFUdXRCd1p0QzdyUkt2aVRjUGs2eHVaMG41L05VWmczV1g3M09PWFpW?=
 =?utf-8?B?ZWN1L043N1VTejN6Vjh1ZFZtY3F1NzM2aThNbTVhREtPRE1XUWMyOGtQdjBX?=
 =?utf-8?B?QUpyQm1wMVhBM0NaSlh6Yi9uaDFJdFhqQlNaNDJId2pWYTFEK3l2a3BjYlk2?=
 =?utf-8?B?U1VjbU0xWWQ4c0tUWG1ub2hRVGNPV3RPaUVDdW5CSnEyTm02bUZFOVR1SDNj?=
 =?utf-8?B?bExZY0lERnlzYU1HaHVMWUwvVUxGeE9LdWNjZFIwNmc2SXgvUzR4bjQxazl3?=
 =?utf-8?B?VzVpK0oySjI0WUlJZEhYeHlhRkJhSk5OQmlMa0hvUml0d1BySjJxaDRHWTBI?=
 =?utf-8?B?SDlrNGUxRDkyRGdjWGUxSUVIYk9vdVcyNVdTS2toRHNoTDRLRUpTSk54R2pC?=
 =?utf-8?B?blNLQTArVTdGUUNvKzF5d1JLUllJM2xEcStyZzhQOHB0QkxaRVlXSWFub0xF?=
 =?utf-8?B?cFhMc3pvcUdUMTI2M08wd0crUUNqN3hBRnhxUml3UlNEZWN3V1RlTDJoQ0R4?=
 =?utf-8?B?aW9IUkxpdS9lRTY2ck5VeENTNld2ZE1TTnI2QW5ZeTliNGRkVGtYOHZuUi8x?=
 =?utf-8?B?Y25LQ3loR0pXemRrVktIYXo1cHdtVHArbUFIRDUwYkdXMDFKcDVGSlBvZ3dr?=
 =?utf-8?B?ODY5MmlodStJbmFtWU91K1JhY25VcktiWXlNQkV1QUhtZVhhMkU5dTJyNTBR?=
 =?utf-8?B?bk41a1d3UTVZSjJZZU9jb0J6Rlo2TzBmeThNT1Q5d1JPUjRUTFRlZ0hGMXZH?=
 =?utf-8?B?RTNvUnUwZUpNckVNUUMvRDI4bkFsMUJrV2RjYXZhKzZ0dTBIRHBidkRFWnMw?=
 =?utf-8?B?dDdrQ0NXYWhPUHVIVndFWUxkR1VvYUJPSmxNaVRrdVFqeldVWm5yQVNneTg1?=
 =?utf-8?B?U1dCV3hQR1RuRG1WZmZTREw2Wi93WlZxL2dZQVAvM2lidWkvNGVucFJMcklq?=
 =?utf-8?B?V05xTW1VNG1FMDl1aFJ2QnlCbEJVM1Q0VlIzaUZONDNRVWhKcTQ5a2gvMzFR?=
 =?utf-8?B?Mjk0bWFhQkFZK1hMaVdydGRaMnZITE9zTG9EK0ZFWE1nTWJyZjdNcDJtQmE2?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5467A646533250468DDB168BACC129EB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a11099-a92d-417e-08c7-08dada2b6f96
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 21:22:11.6586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0bdoTORvbVIVLDU2u5qW4W7yoxY+btVkj4NuX5/TUYabYSoGCMT4cOjjeQHxK0fmEpGM6n3d2w/B8IgzGuYXmv9R3ismfaS6NQWihUmSA48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5929
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_12,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090176
X-Proofpoint-ORIG-GUID: mEjfLHojf9A1Lo1Ps5jo3YP-UXsMtNB6
X-Proofpoint-GUID: mEjfLHojf9A1Lo1Ps5jo3YP-UXsMtNB6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDIyLTEyLTA3IGF0IDE1OjM4IC0wODAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gVHVlLCBEZWMgMDYsIDIwMjIgYXQgMDY6MjM6NDZQTSAtMDgwMCwgQ2F0aGVyaW5lIEhv
YW5nIHdyb3RlOgo+ID4gQWRhcHQgdGhpcyB0b29sIHRvIGNhbGwgeGZzX2lvIHRvIHJldHJpZXZl
IHRoZSBVVUlEIG9mIGEgbW91bnRlZAo+ID4gZmlsZXN5c3RlbS4KPiA+IFRoaXMgaXMgYSBwcmVj
dXJzb3IgdG8gZW5hYmxpbmcgeGZzX2FkbWluIHRvIHNldCB0aGUgVVVJRCBvZiBhCj4gPiBtb3Vu
dGVkCj4gPiBmaWxlc3lzdGVtLgo+ID4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBDYXRoZXJpbmUgSG9h
bmcgPGNhdGhlcmluZS5ob2FuZ0BvcmFjbGUuY29tPgo+ID4gLS0tCj4gPiDCoGRiL3hmc19hZG1p
bi5zaCB8IDIxICsrKysrKysrKysrKysrKysrKy0tLQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMTgg
aW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL2RiL3hm
c19hZG1pbi5zaCBiL2RiL3hmc19hZG1pbi5zaAo+ID4gaW5kZXggNDA5OTc1YjIuLjBkY2I5OTQw
IDEwMDc1NQo+ID4gLS0tIGEvZGIveGZzX2FkbWluLnNoCj4gPiArKysgYi9kYi94ZnNfYWRtaW4u
c2gKPiA+IEBAIC02LDYgKzYsOCBAQAo+ID4gwqAKPiA+IMKgc3RhdHVzPTAKPiA+IMKgREJfT1BU
Uz0iIgo+ID4gK0RCX0VYVFJBX09QVFM9IiIKPiA+ICtJT19PUFRTPSIiCj4gCj4gVGhpcyBzZWVt
ZWQgb2RkbHkgZmFtaWxpYXIgdW50aWwgSSByZW1lbWJlcmVkIHRoYXQgd2UndmUgYmVlbiBoZXJl
Cj4gYmVmb3JlOgo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXhmcy9hYzczNjgyMS04
M2RlLTRiZGUtYTFhMS1kMGQyNzExOTMyZDdAc2FuZGVlbi5uZXQvCj4gCj4gQW5kIG5vdyB0aGF0
IEkndmUgcmVyZWFkIHRoYXQgdGhyZWFkLCBJJ3ZlIG5vdyByZWFsaXplZCAvd2h5LyBJIGdhdmUK
PiB1cAo+IG9uIGFkZGluZyB0aGluZ3MgdG8gdGhpcyBzY3JpcHQgLS0gdGhlcmUgd2VyZSB0b28g
bWFueSBxdWVzdGlvbnMgZnJvbQo+IHRoZSBtYWludGFpbmVyIGZvciB3aGljaCBJIGNvdWxkbid0
IGNvbWUgdXAgd2l0aCBhbnkgc2F0aXNmeWluZwo+IGFuc3dlci4KPiBUaGVuIEkgYnVybmVkIG91
dCBhbmQgZ2F2ZSB1cC4KPiAKPiBPZmMgbm93IHdlIGhhdmUgYSBuZXcgbWFpbnRhaW5lciwgc28g
SSdsbCBwdXQgdGhlIHF1ZXN0aW9ucyB0byB0aGUKPiBuZXcKPiBvbmUuwqAgVG8gc3VtbWFyaXpl
Ogo+IAo+IFdoYXQgaGFwcGVucyBpZiB0aGVyZSBhcmUgbXVsdGlwbGUgc291cmNlcyBvZiB0cnV0
aCBiZWNhdXNlIHRoZSBmcyBpcwo+IG1vdW50ZWQ/wqAgRG8gd2Ugc3RvcCBhZnRlciBwcm9jZXNz
aW5nIHRoZSBvbmxpbmUgb3B0aW9ucyBhbmQgaWdub3JlCj4gdGhlCj4gb2ZmbGluZSBvbmVzP8Kg
IERvIHdlIGtlZXAgZ29pbmcsIGV2ZW4gdGhvdWdoIC1mIGlzIGFsbW9zdCBjZXJ0YWlubHkKPiBy
ZXF1aXJlZD8KPiAKPiBJZiB0aGUgdXNlciBzcGVjaWZpZXMgbXVsdGlwbGUgb3B0aW9ucywgaXMg
aXQgb2sgdG8gY2hhbmdlIHRoZSBvcmRlcgo+IGluCj4gd2hpY2ggd2UgcnVuIHRoZW0gc28gdGhh
dCB3ZSBjYW4gcnVuIHhmc19pbyBhbmQgdGhlbiB4ZnNfZGI/Cj4gCj4gSWYgaXQncyBub3Qgb2sg
dG8gY2hhbmdlIHRoZSBvcmRlciwgaG93IGRvIHdlIG1ha2UgdGhlIHR3byB0b29scyBydW4KPiBp
bgo+IGxvY2tzdGVwIHNvIHdlIG9ubHkgaGF2ZSB0byBvcGVuIHRoZSBmaWxlc3lzdGVtIG9uY2U/
Cj4gCj4gSWYgaXQncyBub3Qgb2sgdG8gY2hhbmdlIHRoZSBvcmRlciBhbmQgd2UgY2Fubm90IGRv
IGxvY2tzdGVwLCBpcyBpdAo+IG9rCj4gdG8gaW52b2tlIGlvL2RiIG9uY2UgZm9yIGVhY2ggc3Vi
Y29tbWFuZCBpbnN0ZWFkIG9mIGFzc2VtYmxpbmcgYQo+IGdpYW50Cj4gY2xpIG9wdGlvbiBhcnJh
eSBsaWtlIHdlIG5vdyBmb3IgZGI/Cj4gCj4gSWYgd2UgaGF2ZSB0byBpbnZva2UgaW8vZGIgbXVs
dGlwbGUgdGltZXMsIHdoYXQgZG8gd2UgZG8gaWYgdGhlIHN0YXRlCj4gY2hhbmdlcyBiZXR3ZWVu
IGludm9jYXRpb25zIChlLmcuIHNvbWVvbmUgZWxzZSBtb3VudHMgdGhlIGJsb2NrIGRldgo+IG9y
Cj4gdW5tb3VudHMgdGhlIGZzKT/CoCBXaGF0IGhhcHBlbnMgaWYgdGhpcyBhbGwgcmVzdWx0cyBp
biBtdWx0aXBsZQo+IHhmc19yZXBhaXIgaW52b2NhdGlvbnM/Cj4gCj4gQ2FuIHdlIHByb2hpYml0
IHBlb3BsZSBmcm9tIHJ1bm5pbmcgbXVsdGlwbGUgc3ViY29tbWFuZHM/wqAgRXZlbiBpZgo+IHRo
YXQncyBhIGJyZWFraW5nIGNoYW5nZSBmb3Igc29tZW9uZSB3aG8gbWlnaHQgYmUgcmVseWluZyBv
biB0aGUKPiBleGFjdAo+IGJlaGF2aW9ycyBvZiB0aGlzIHNoZWxsIHNjcmlwdD8KPiAKPiBXaGF0
IGlmLCBpbnN0ZWFkIG9mIHRyeWluZyB0byBmaW5kIGFuc3dlcnMgdG8gYWxsIHRoZXNlIGFubm95
aW5nCj4gcXVlc3Rpb25zLCB3ZSBpbnN0ZWFkIGRlY2lkZSB0aGF0IGVpdGhlciBhbGwgdGhlIHN1
YmNvbW1hbmRzIGhhdmUgdG8KPiB0YXJnZXQgYSBtb3VudHBvaW50IG9yIHRoZXkgYWxsIGhhdmUg
dG8gdGFyZ2V0IGEgYmxvY2tkZXYsIG9yCj4geGZzX2FkbWluCj4gd2lsbCBleGl0IHdpdGggYW4g
ZXJyb3IgY29kZT8KPiAKPiAtLUQKU28gSSBhcHBsaWVkIENhdGhlcmluZXMgcGF0Y2hlcywgYnV0
IGl0IGRvZXNudCBleGFjdGx5IGhhdmUgdGhlIHNhbWUKYmVoYXZpb3JzIEVyaWMgY29tbWVudGVk
IG9uIHNpbmNlIHRoaXMgc2V0IGRvZXNudCBoYXZlIHRoZSBleHRyYSBsYWJlbApjaGFuZ2VzLiAg
VW5sZXNzIEkgbWlzc2VkIHNvbWUgb3RoZXIgYmVoYXZpb3JhbCBpc3N1ZXMgd2l0aCBvdGhlciBm
bGFncwp0aGF0IHlvdSBhcmUgbWVhbmluZyB0byByZWZlciB0bz8gIE90aGVyd2lzZSBJIGRvbid0
IHNlZSB0aGF0IHRoaXMKaW50cm9kdWNpbmcgYW55IG9kZCBiZWhhdmlvcnMuICBJdCdzIGNlcnRh
aW5seSBub3QgdGhhdCB0aGUgYWJvdmUKcXVlc3Rpb25zIGFyZSBub3QgdmFsaWQsIGJ1dCBJIHRo
aW5rIGl0J3MgcmVhc29uYWJsZSBmb3IgdGhlbSB0byBiZQphZGRyZXNzZWQgYXMgYSBzZXBhcmF0
ZSBmaXguCgpBcyBmYXIgYXMgdGhlIHNjb3BlIG9mIHRoaXMgc2V0IGlzIGNvbmNlcm5lZCB0aG8s
IEkgdGhpbmsgd2hhdApDYXRoZXJpbmUgaGFzIGhlcmUgaXMgcmVhc29uYWJsZS4KUmV2aWV3ZWQt
Ynk6IEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgoKCj4g
Cj4gPiDCoFJFUEFJUl9PUFRTPSIiCj4gPiDCoFJFUEFJUl9ERVZfT1BUUz0iIgo+ID4gwqBMT0df
T1BUUz0iIgo+ID4gQEAgLTIzLDcgKzI1LDggQEAgZG8KPiA+IMKgwqDCoMKgwqDCoMKgwqBPKcKg
wqDCoMKgwqDCoFJFUEFJUl9PUFRTPSRSRVBBSVJfT1BUUyIgLWMgJE9QVEFSRyI7Owo+ID4gwqDC
oMKgwqDCoMKgwqDCoHApwqDCoMKgwqDCoMKgREJfT1BUUz0kREJfT1BUUyIgLWMgJ3ZlcnNpb24g
cHJvamlkMzJiaXQnIjs7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgcinCoMKgwqDCoMKgwqBSRVBBSVJf
REVWX09QVFM9IiAtciAnJE9QVEFSRyciOzsKPiA+IC3CoMKgwqDCoMKgwqDCoHUpwqDCoMKgwqDC
oMKgREJfT1BUUz0kREJfT1BUUyIgLXIgLWMgdXVpZCI7Owo+ID4gK8KgwqDCoMKgwqDCoMKgdSnC
oMKgwqDCoMKgwqBEQl9FWFRSQV9PUFRTPSREQl9FWFRSQV9PUFRTIiAtciAtYyB1dWlkIjsKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBJT19PUFRTPSRJT19PUFRTIiAtciAtYyBm
c3V1aWQiOzsKPiA+IMKgwqDCoMKgwqDCoMKgwqBVKcKgwqDCoMKgwqDCoERCX09QVFM9JERCX09Q
VFMiIC1jICd1dWlkICIkT1BUQVJHIiciOzsKPiA+IMKgwqDCoMKgwqDCoMKgwqBWKcKgwqDCoMKg
wqDCoHhmc19kYiAtcCB4ZnNfYWRtaW4gLVYKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgc3RhdHVzPSQ/Cj4gPiBAQCAtMzgsMTQgKzQxLDI2IEBAIHNldCAtLSBleHRyYSAkQAo+
ID4gwqBzaGlmdCAkT1BUSU5ECj4gPiDCoGNhc2UgJCMgaW4KPiA+IMKgwqDCoMKgwqDCoMKgwqAx
fDIpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIyBVc2UgeGZzX2lvIGlmIG1v
dW50ZWQgYW5kIHhmc19kYiBpZiBub3QgbW91bnRlZAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGlmIFsgLW4gIiQoZmluZG1udCAtdCB4ZnMgLVQgJDEpIiBdOyB0aGVuCj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoERCX0VYVFJBX09Q
VFM9IiIKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlbHNlCj4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoElPX09QVFM9IiIKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmaQo+ID4gKwo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAjIFBpY2sgdXAgdGhlIGxvZyBkZXZpY2UsIGlmIHByZXNlbnQKPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgWyAtbiAiJDIiIF07IHRoZW4KPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoExPR19PUFRT
PSIgLWwgJyQyJyIKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZmkKPiA+IMKg
Cj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgWyAtbiAiJERCX09QVFMiIF0K
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiBbIC1uICIkREJfT1BUUyIgXSB8
fCBbIC1uICIkREJfRVhUUkFfT1BUUyIgXQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHRoZW4KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZXZhbCB4ZnNfZGIgLXggLXAgeGZzX2FkbWluICRMT0dfT1BUUwo+ID4gJERCX09QVFMgJERC
X0VYVFJBX09QVFMgIiQxIgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBzdGF0dXM9JD8KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBm
aQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIFsgLW4gIiRJT19PUFRTIiBd
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHRoZW4KPiA+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXZhbCB4ZnNfZGIgLXggLXAgeGZz
X2FkbWluICRMT0dfT1BUUwo+ID4gJERCX09QVFMgIiQxIgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBldmFsIHhmc19pbyAteCAtcCB4ZnNfYWRtaW4g
JElPX09QVFMgIiQxIgo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgc3RhdHVzPSQ/Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZp
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIFsgLW4gIiRSRVBBSVJfT1BU
UyIgXQo+ID4gLS0gCj4gPiAyLjI1LjEKPiA+IAoK
