Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87221C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 00:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiKKA7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 19:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiKKA7V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 19:59:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA446177E
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 16:59:20 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB0sxIn020890;
        Fri, 11 Nov 2022 00:59:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Um2zi1SV29IMye0B7UoyGiqG0jQH+iOblPn1NAWElq8=;
 b=l5w2WxEq27KZa3mfVdQ+4dednfWAoRmiYkpBwK6c6J1BMo+chh6AUwOHvkQ2+Kw+2BCq
 g2DJGB2wld1F9NPlePmcmwtTRwhn1njXeY6eXHTkXwxE2UL/IdG7Wuz8UR5arQJkYmN4
 fjSMXrHuKeb7gvNimzkg2o3339wLi6DGxGIBa8SXzR3hzccZGCtDIexC26gu11fSVqHA
 +h1KLkHt24eAGaHwzg4d8MJ5op3jRDTtWPoZZGvrHHbKd7J9Zlx6bUufEzuEMukOm526
 BH4U/avNNrH4scl8wOR4slYWBD1FqmrBlEIaqkWPAgNP9/3IHS5ilT2lzdzAGnsli8KF hQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksc8y804n-92
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 00:59:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB04rMj019819;
        Fri, 11 Nov 2022 00:44:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqkusvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 00:44:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJ/eXf2gRWtTfdfkq6Fh5JeQXKTFZkREpOpLE3HDrDSIP6hP0NTRSo9v74WeYisXe9vNKC3WSNikzjnGH8BmRkQyI45RcJkf/NZmsZi3LOZArvtkG00nP+Hnvm6G6HSexMeWSnG7bm3sJMiyCTI6FXZpumPqGC4atSULqoQlUoIK98p5N142iSnUQXs2v01s9uqRSx/JxcXkWC1AdOd09gTh8Njhp4YvLF/Js2Lfll7XhnfM4Uy6oxYHLKFg2u8XSkJ39poSIpM4mYkLiftleU2wuxe2NRD4NuVK5ir0sXa/5lIJXXW20D2nMwqbiAwPVQHXzVdiXlghW0IWRCEgPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Um2zi1SV29IMye0B7UoyGiqG0jQH+iOblPn1NAWElq8=;
 b=Qa3gYW3VYCe7x6mNIt5QQbDduATswuIMsyaKkHjWw44RYpcPt+hqfqkd/Xg3Y8/9wtCck0j6zPm+uao3f8MEQ/Z59TjgAc+RycaLTG/UhFtY+3iCMRG8q/K0Kps3qK/1joi9uviEBXQe+9Nq4QbTowjV2/ySR3GBT29hYGyBYWy5j6V1zC3XQJgn7APjCso/t08LvPz+u2Lz/udbN3FKMZE3bWyAJD+mumBuzDXJym7Fk1LOhFlk0avmHZS44/qPCaO70tdqhUxPCNaOrZ1dQ1WbdQPT7ozWDcbr2OUDbVPAorAV1oOUIoiaGsh9Qj4YhZhJ0c7slb23Rcsm/WkuxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Um2zi1SV29IMye0B7UoyGiqG0jQH+iOblPn1NAWElq8=;
 b=lP0DwOQppsK7+5aLUY3oNsY2+mudgM72OF/ZzM+Ap5vtbkjEOm1l/DNVzZ8rXKfHi9MHkwEWLk+vxAUOgwYKLZzz2tCrD3Btc0qDIgyhkkPYsK+oU+Z4d6/Evp6xm2hDCxexrbcMYOqCrlkxkQ+vUzRAH5I6gzL45wyewi7IzKY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW5PR10MB5738.namprd10.prod.outlook.com (2603:10b6:303:19b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Fri, 11 Nov
 2022 00:44:22 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137%4]) with mapi id 15.20.5813.012; Fri, 11 Nov 2022
 00:44:21 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>
Subject: Re: [PATCH v1 1/2] fs: hoist get/set UUID ioctls
Thread-Topic: [PATCH v1 1/2] fs: hoist get/set UUID ioctls
Thread-Index: AQHY9Wa9Ml7I2LAK+kus0tJEBLJHRw==
Date:   Fri, 11 Nov 2022 00:44:21 +0000
Message-ID: <D1C1CDD6-C84E-40E0-905D-EC789D74448B@oracle.com>
References: <20221109221959.84748-1-catherine.hoang@oracle.com>
 <20221109221959.84748-2-catherine.hoang@oracle.com>
 <Y21Zzi4MnI1DTNLo@magnolia>
In-Reply-To: <Y21Zzi4MnI1DTNLo@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|MW5PR10MB5738:EE_
x-ms-office365-filtering-correlation-id: 041c5979-8e7f-4a31-245e-08dac37ddfae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gKIGaZrHCovtpc35LHQ94Q3JkpTUbR8Rwz/hpzMnpSpIE3nHbRNckNXbE5A0V+mVpsTeYcjS/k2sXpIYSTGFo43R/gQcZceaSHhXkC7Y1UtGtQyicZtq8Y1E3W38LtwTPraIeqVvYmt5DX858V5w0ECRsCajxnX5LzRJK5knfFI+Y5Mki1+cf8ke4fNcy9Avqd0gUURqoqpBw59poRUEi4zdAC68mhH9VFbvihCuVJl6aUIPDjSbRfxxdu3b+3+IqJgUXXCmgA6l87yl8y53XzFAcjCN6BuwEEFdz/+ta/KhpqEusM/MqtsKj5MI5a0DavNW2pJXGaecU2+r2qzX7J0XCm00ygPuxKyLj2HZ5RYY6qO9WzfW/+oiTeMnmb9nNGNLyZ8/BZk96kf39iSMzIogmRGHZrlaUXa4vO0BstV5qfUZ+PYWxcxMvVlYRMC9V9JASiCAr4vqs9U2xfjtxId/VvFjKb2rllNmC4Jwtr+WyvSjAeeHY9gAgj3xWzM2URFn6EeAtfnCtHez31dTbjeUBMPtJ2fkNqSd2RFUH26vvnjiMUdUkkJTXLZtHTM3rwwuG3adRrG50shD55iQycfGec95YP6OADhVbrqcxyTkQA5Yzqat77NFJZ1k/2NMYHm0TJMzeJUdcm4ze9crDdtqBxKoBC6LtRx8ta6+DOVMJFv1FI6m4Oex9eTeADCB9bcgnZeNsY3q4cp2ZD4uD2ZdIGxFLOv3fWWzVPEax5tm0RxoHQ92eYeSQTUynpwMrnbNxrZQqqvfM1Yt09/7T2uCyTTsjZvG8eWnSDDe8XA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199015)(6486002)(478600001)(71200400001)(6916009)(38070700005)(54906003)(6506007)(316002)(66946007)(66476007)(2906002)(66556008)(8676002)(53546011)(76116006)(91956017)(64756008)(38100700002)(66446008)(4326008)(86362001)(5660300002)(41300700001)(36756003)(122000001)(2616005)(8936002)(186003)(6512007)(83380400001)(44832011)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0M1NStlNTQvWjhWZmY2VnBzNjBqRXVNbWtzcXdjQUExWTBPSXZ1dFdLZHdV?=
 =?utf-8?B?MENiWXU0ZVcwTE9teWNqdThmTDZkQmF5MG9QK3VXbVlrdzBzZ1R6Z2piNG5s?=
 =?utf-8?B?YTAzUFVENHRZeUhodG5HV3I1SWNOMHp6eXRIc1RxL0g5cDRTcUduQUYzQ212?=
 =?utf-8?B?T2RWdklRVjdwZDY4d2VqZFBmK0xlYlJIanNKc3VCUzlWYmliWDNCUXJJalVP?=
 =?utf-8?B?c1h5aitUQm4zSVd3NWp1ZVdHS1A0MGhDTElqN2srZURaQVo1MWFlTlRzSUU1?=
 =?utf-8?B?RXhqZ1kxZHRFZ0xubWJUczFoQnZKeGt2OHRLMEY0MFordWVkYUsxSjE1VlA1?=
 =?utf-8?B?Nkt4VkJ5cW1OUGh5MXY2RzV5MUloelBrZFdSa0h3b0QrNUtqTjhjMXhpeHVV?=
 =?utf-8?B?Sm5uTUxKanI3NjhBNnlmMCtTQ2ZtWVl6TGtqOVNSOW16dGIxblh0bUhKY3E5?=
 =?utf-8?B?R3V1NTAxUkJSaXVtTHBlbGhjVUJUM2FWY1R4L2U3Uk5COE9IV1FyVVMxOUc5?=
 =?utf-8?B?ZGRhQ0FkMHREZnR2Wk15aGNEekJDcFhOZ2sxcnJJVHE1QUJiYjdEbVRKUlpp?=
 =?utf-8?B?aitOcklSeEhoMURKbGt6MU5lWEpXMlIrUy9DU1lFUGF2RjZnemw0RVpTSGs0?=
 =?utf-8?B?Q2dXYkRDczYxd2lsWHZHUDZOajdwcGhaLzFRQ1RuVFg3ejh2QW9uS3F4Q3pk?=
 =?utf-8?B?OEsvYmlDWndNR2pvdkxWTWc4ME1YREUxRk1aSlRvWGpZVmEyeGFCdTlQK1lo?=
 =?utf-8?B?TFNoMnY2bVIrbjg1VTRxQU1ab0NIVlNyNDgrdkcybHlpN1VjVmdQOVhuV1Nz?=
 =?utf-8?B?alBWdy9mSm5CbERkeU1nZGxaL3pWc1ErNU5wMUJUY1pBMmluT1Zza3dSU005?=
 =?utf-8?B?N282eFVmMzAzZFFhK0JkaEV1QVlLdDB4SlVOSWlJRGFYMzdLc3VYRnMxR2ts?=
 =?utf-8?B?bEg3WHp3ZTFSb3dTbGNDRjM2LzRMN0NHNXlLZTV6a0dwMnltUjR5N1c0Q2lS?=
 =?utf-8?B?LzJNWjMyODYvdndxSytUWEh0RTZKdjExMHlJQUF3WUMrYUlFeVg4Umw0VnZ0?=
 =?utf-8?B?NjZod1JvcWVLemRZV3diL3VxR3RuRlFEUlFObkkxYmh3UE42SjRQSEYyWnMz?=
 =?utf-8?B?bUZMWmxDaVR3WjNZM2JkbTNVeHFwejlNQ3B1WUJlbTJKakg2M0t3OGdLMXVx?=
 =?utf-8?B?V3h5MHJaQjE4ZVl4OVVPaFYzcEhIY2FVSUxDN0N6VnFNOUFZemd0SEdsWTVj?=
 =?utf-8?B?SlR5REE0Z1o3aVM5cC82ZDdOQUlGRVZiekhvWFlhK1duanZ0ZE80MHJIL3Nm?=
 =?utf-8?B?bm56aHE5bzVyV21ubVR1V001bWFLbmd5ajVpdzVZVXdEcjljTlpuaFY5Y2lI?=
 =?utf-8?B?M0JLSm5rV1dUbmN6MGNlamxrdHUzVWRSQXV1M0w5ejNEK0V1WTY5QnVoQk83?=
 =?utf-8?B?ZjBWL1NqdmtiOFJ0SzhNUm9CQThuRWthaHkwbmExdVZ6WmFQK0hNUXJQTzB0?=
 =?utf-8?B?bklMV1NaZy9xNGd0V1RnajZaWjRoMld6aWhjeWtTMlZVRnlSYmc1bWp6U2Rh?=
 =?utf-8?B?L3dQUm5OV2oranVNYkxOTzZGM1JSUmIxVHhnai96dng5QlpEd1hBc0NoV1pz?=
 =?utf-8?B?L3IyMTdkNUFPMndXYUhsZVJrMUVSOWYwbjNlVlNjcmZsbDF5TGF3elp4MHcz?=
 =?utf-8?B?VUhXeGg2bzNEQi9aczRKdVhMdklEUEFCRGRyZzVxR09lSFZsNTJ3eVgrK2lF?=
 =?utf-8?B?Y2I4aUpJMzJFMThlVy9FcG0yd1JndkV4cXZpWGlWbWlDOU9zcXUxUGZ2S0Jr?=
 =?utf-8?B?cXRBMGFqRnNyZTVMRHBVRDgzQkRYZUR5K3VER1dOZXYyV3VkTm9rWFVReW9U?=
 =?utf-8?B?K1E4anhZVCttZ1pmNEZEeklabVJuU1ljM1JaakxMdU1UVXlsR0M4d3k5aDFx?=
 =?utf-8?B?a3p2NFNGblo5V2RPYm9QRVV6M1pUTVp6SlUwc2tMUnlWTk90YjBjaDNHTFZW?=
 =?utf-8?B?OFJTZkw5U1Z6WU9lZ0h5b09zRGQ0bDVNYnl2NDVhTkJLdXdhNlE2VHo3aTVE?=
 =?utf-8?B?RkVkeGdqRmxLc0lFVDRKMTFPNEYxOVhxKzlMVGl2ZGhSOWJQVk9PQWlFNTdh?=
 =?utf-8?B?ampTTFRXNUlrZktYWXoveUN0S25lekJEc2gyRm5nMDZJaGErcmRxUVdHMlRM?=
 =?utf-8?B?U014SFFyRDBLdHd6QlNObTFRQlJLVUZqN1dUU1RGd1JRUXk2bnowdGtMUTJH?=
 =?utf-8?Q?4QdqD4AR0Uc1K5vNu8rM/kXuBf1+2Cn3RGVX4lYS2I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DD7431D68E50B4BA3737639C2F47C26@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 041c5979-8e7f-4a31-245e-08dac37ddfae
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 00:44:21.6781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J59Wr1go9e59af93I/vFhl7zrdrSstKL/Fej2kwPcMMw22itNKmni2fmF+eTpBDjEbooDLZ2nBnTsVr4rhX8FSPmIusYhhTGoBhhtfiQwwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5738
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_14,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110003
X-Proofpoint-GUID: ohmiQ7WaVJHEkZJrBQxXK1IXll2Mvh4Y
X-Proofpoint-ORIG-GUID: ohmiQ7WaVJHEkZJrBQxXK1IXll2Mvh4Y
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBOb3YgMTAsIDIwMjIsIGF0IDEyOjA2IFBNLCBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0Br
ZXJuZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgTm92IDA5LCAyMDIyIGF0IDAyOjE5OjU4
UE0gLTA4MDAsIENhdGhlcmluZSBIb2FuZyB3cm90ZToNCj4+IEhvaXN0IHRoZSBFWFQ0X0lPQ19b
R1NdRVRGU1VVSUQgaW9jdGxzIHNvIHRoYXQgdGhleSBjYW4gYmUgdXNlZCBieSBhbGwNCj4+IGZp
bGVzeXN0ZW1zLiBUaGlzIGFsbG93cyB1cyB0byBoYXZlIGEgY29tbW9uIGludGVyZmFjZSBmb3Ig
dG9vbHMgc3VjaCBhcw0KPj4gY29yZXV0aWxzLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBDYXRo
ZXJpbmUgSG9hbmcgPGNhdGhlcmluZS5ob2FuZ0BvcmFjbGUuY29tPg0KPiANCj4gTG9va3MgZ29v
ZCwNCj4gUmV2aWV3ZWQtYnk6IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+
IA0KPiBBbHNvLCBmb3IgdGhlIGluZXZpdGFibGUgdjIgcGF0Y2hzZXQgYWZ0ZXIgd2Ugc29ydCBv
dXQgc29tZSB3ZWlyZCBidWdzDQo+IGluIHRoZSBleHQ0IGltcGxlbWVudGF0aW9uIG9mIHRoaXMs
IGNhbiB5b3UgcGxlYXNlIGNjDQo+IGxpbnV4LWV4dDRAdmdlci5rZXJuZWwub3JnPw0KDQpUaGFu
a3MgZm9yIHJldmlld2luZyEgQW5kIHN1cmUsIEnigJlsbCBjYyB0aGVtIGluIHRoZSBuZXh0IHZl
cnNpb24NCj4gDQo+IC0tRA0KPiANCj4+IC0tLQ0KPj4gZnMvZXh0NC9leHQ0LmggICAgICAgICAg
fCAxMyArKy0tLS0tLS0tLS0tDQo+PiBpbmNsdWRlL3VhcGkvbGludXgvZnMuaCB8IDExICsrKysr
KysrKysrDQo+PiAyIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9u
cygtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvZnMvZXh0NC9leHQ0LmggYi9mcy9leHQ0L2V4dDQu
aA0KPj4gaW5kZXggOGQ1NDUzODUyZjk4Li5iMjAwMzAyYTM3MzIgMTAwNjQ0DQo+PiAtLS0gYS9m
cy9leHQ0L2V4dDQuaA0KPj4gKysrIGIvZnMvZXh0NC9leHQ0LmgNCj4+IEBAIC03MjIsOCArNzIy
LDggQEAgZW51bSB7DQo+PiAjZGVmaW5lIEVYVDRfSU9DX0dFVFNUQVRFCQlfSU9XKCdmJywgNDEs
IF9fdTMyKQ0KPj4gI2RlZmluZSBFWFQ0X0lPQ19HRVRfRVNfQ0FDSEUJCV9JT1dSKCdmJywgNDIs
IHN0cnVjdCBmaWVtYXApDQo+PiAjZGVmaW5lIEVYVDRfSU9DX0NIRUNLUE9JTlQJCV9JT1coJ2Yn
LCA0MywgX191MzIpDQo+PiAtI2RlZmluZSBFWFQ0X0lPQ19HRVRGU1VVSUQJCV9JT1IoJ2YnLCA0
NCwgc3RydWN0IGZzdXVpZCkNCj4+IC0jZGVmaW5lIEVYVDRfSU9DX1NFVEZTVVVJRAkJX0lPVygn
ZicsIDQ0LCBzdHJ1Y3QgZnN1dWlkKQ0KPj4gKyNkZWZpbmUgRVhUNF9JT0NfR0VURlNVVUlECQlG
U19JT0NfR0VURlNVVUlEDQo+PiArI2RlZmluZSBFWFQ0X0lPQ19TRVRGU1VVSUQJCUZTX0lPQ19T
RVRGU1VVSUQNCj4+IA0KPj4gI2RlZmluZSBFWFQ0X0lPQ19TSFVURE9XTiBfSU9SICgnWCcsIDEy
NSwgX191MzIpDQo+PiANCj4+IEBAIC03NTMsMTUgKzc1Myw2IEBAIGVudW0gew0KPj4gCQkJCQkJ
RVhUNF9JT0NfQ0hFQ0tQT0lOVF9GTEFHX1pFUk9PVVQgfCBcDQo+PiAJCQkJCQlFWFQ0X0lPQ19D
SEVDS1BPSU5UX0ZMQUdfRFJZX1JVTikNCj4+IA0KPj4gLS8qDQo+PiAtICogU3RydWN0dXJlIGZv
ciBFWFQ0X0lPQ19HRVRGU1VVSUQvRVhUNF9JT0NfU0VURlNVVUlEDQo+PiAtICovDQo+PiAtc3Ry
dWN0IGZzdXVpZCB7DQo+PiAtCV9fdTMyICAgICAgIGZzdV9sZW47DQo+PiAtCV9fdTMyICAgICAg
IGZzdV9mbGFnczsNCj4+IC0JX191OCAgICAgICAgZnN1X3V1aWRbXTsNCj4+IC19Ow0KPj4gLQ0K
Pj4gI2lmIGRlZmluZWQoX19LRVJORUxfXykgJiYgZGVmaW5lZChDT05GSUdfQ09NUEFUKQ0KPj4g
LyoNCj4+ICAqIGlvY3RsIGNvbW1hbmRzIGluIDMyIGJpdCBlbXVsYXRpb24NCj4+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL3VhcGkvbGludXgvZnMuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9mcy5oDQo+
PiBpbmRleCBiN2I1Njg3MTAyOWMuLjYzYjkyNTQ0NDU5MiAxMDA2NDQNCj4+IC0tLSBhL2luY2x1
ZGUvdWFwaS9saW51eC9mcy5oDQo+PiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvZnMuaA0KPj4g
QEAgLTEyMSw2ICsxMjEsMTUgQEAgc3RydWN0IGZzeGF0dHIgew0KPj4gCXVuc2lnbmVkIGNoYXIJ
ZnN4X3BhZFs4XTsNCj4+IH07DQo+PiANCj4+ICsvKg0KPj4gKyAqIFN0cnVjdHVyZSBmb3IgRlNf
SU9DX0dFVEZTVVVJRC9GU19JT0NfU0VURlNVVUlEDQo+PiArICovDQo+PiArc3RydWN0IGZzdXVp
ZCB7DQo+PiArCV9fdTMyICAgICAgIGZzdV9sZW47DQo+PiArCV9fdTMyICAgICAgIGZzdV9mbGFn
czsNCj4+ICsJX191OCAgICAgICAgZnN1X3V1aWRbXTsNCj4+ICt9Ow0KPj4gKw0KPj4gLyoNCj4+
ICAqIEZsYWdzIGZvciB0aGUgZnN4X3hmbGFncyBmaWVsZA0KPj4gICovDQo+PiBAQCAtMjE1LDYg
KzIyNCw4IEBAIHN0cnVjdCBmc3hhdHRyIHsNCj4+ICNkZWZpbmUgRlNfSU9DX0ZTU0VUWEFUVFIJ
CV9JT1coJ1gnLCAzMiwgc3RydWN0IGZzeGF0dHIpDQo+PiAjZGVmaW5lIEZTX0lPQ19HRVRGU0xB
QkVMCQlfSU9SKDB4OTQsIDQ5LCBjaGFyW0ZTTEFCRUxfTUFYXSkNCj4+ICNkZWZpbmUgRlNfSU9D
X1NFVEZTTEFCRUwJCV9JT1coMHg5NCwgNTAsIGNoYXJbRlNMQUJFTF9NQVhdKQ0KPj4gKyNkZWZp
bmUgRlNfSU9DX0dFVEZTVVVJRAkJX0lPUignZicsIDQ0LCBzdHJ1Y3QgZnN1dWlkKQ0KPj4gKyNk
ZWZpbmUgRlNfSU9DX1NFVEZTVVVJRAkJX0lPVygnZicsIDQ0LCBzdHJ1Y3QgZnN1dWlkKQ0KPj4g
DQo+PiAvKg0KPj4gICogSW5vZGUgZmxhZ3MgKEZTX0lPQ19HRVRGTEFHUyAvIEZTX0lPQ19TRVRG
TEFHUykNCj4+IC0tIA0KPj4gMi4yNS4xDQo+PiANCg0K
