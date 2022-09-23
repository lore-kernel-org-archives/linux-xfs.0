Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931B9C04A95
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 20:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiIWUrT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiIWUqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 16:46:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1A0E1716
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 13:44:24 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NJEEVj031906;
        Fri, 23 Sep 2022 20:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=QY9xAg9033tvprcC5ACUrd+vggB6nOtZY4Z5e1JLlpk=;
 b=aCMyWFxg7OzDF/qNEYHhc0i1P2MkTA6EC09Uxz+0wKkxEzxnBPQYzhRNua/fq95/l7Wv
 jNW9FqfeKgzTriMvuhCVj+ELYBe+woEzUqfm1gu3zCR+4qUAk0LLEKiJJDoVuUdf4Ho+
 Zo/ql5CPLfdvMTvoA+25IRTmlJa8umQi+QePr2V5j/EVhLN+SCAGLOt57IhGx+fRHlzX
 4KEa9ye3DvWklUejN9UgTL+OkTOUZKxEtJfGRWN5LqTVOCdIZxmgUVKF7E3chuNjEnyL
 Bhujk4FGBzMDI3B+zMkyb6D73JNV0vInkHZYru9g75eaHr0VDdZoZaoDzoVM0TSTQKLu gQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688rx68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 20:44:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28NH0RhU010185;
        Fri, 23 Sep 2022 20:44:19 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3ccq5d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 20:44:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTtsGX300zpEkBtkZCtpW4dtEXZA4/nkU7iCwcOBamgNxg5XS+EtjLYZIgxmLVY9VIBLXj0gWHBoess2c86MxumCMDkFq3qW7lFKJ8PATwCmHecBx5e2cMZd/yPY3SVoBdYtwlsk5sqyeAx33d03hegwwFX/bhScQSCjHaVQL/M27LzIeOwfzBf+s5X/DCpgcGL+AW0nrSBZMXMkQbskzUilHToy3cxSl1e+s1O446R/RmqHfkx+bx3zrs5V0F9mjEgjtcz4G6d5m6P9kx++EAtvFgEYNrxjjUIWQkQQtNxpvE49x94eSZwfmAfKMWB2Ku1zMXa3kIbbqtw55Q6uNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QY9xAg9033tvprcC5ACUrd+vggB6nOtZY4Z5e1JLlpk=;
 b=YJHSWRHnZVQwvYEXweP3pvHl8BNNlOLZlR+E5VL8Nabds+9zyjXiO7r4rHj8Xqrwpl8To1/IBEbrmhGeB4GlGhWyqH7WVk7sTF/xMgL2mdXsYAErqlDSn8/EWXgb7Q+va2wMWM/YrO7TlL5cbFDd062if9KyybalXkI6uaqCXPNRGYM/3ooo28Nmbo5mjLzyxeILXbXxDr8adpOxE4wOl3164ixHtQxBME7cfx1zD25K3yoOS8cFuYficP69RQN9hIA0p3DNaL47gu+1sbMco1V3uVrQk6LqvbkxIFzPqqbDWCFx3wsJsW9+vxTbRCkT9aR9l6RL/eE4HQLMWDqwiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QY9xAg9033tvprcC5ACUrd+vggB6nOtZY4Z5e1JLlpk=;
 b=Q6pVdLzPFAROYsuP4jE6keOgJ27TompIkhueQLreSLc8wvaeR9Cse6klOFlddM/OSy/ZZEXSAHL1k14QoG/DokbDDNFajnSVeCrQEAsOQBGkzqO7CCNK8vo7k4e3bqxqRUV2hp+N0H3Cz2/6Te8/4APA2WrHURLSEUS6OcYHSVU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY8PR10MB6804.namprd10.prod.outlook.com (2603:10b6:930:9b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 20:44:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 20:44:17 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 05/26] xfs: Hold inode locks in xfs_rename
Thread-Topic: [PATCH v3 05/26] xfs: Hold inode locks in xfs_rename
Thread-Index: AQHYzkZ5qYZIjrqGiEqNkhFdO0JZq63tZtSAgAAXHAA=
Date:   Fri, 23 Sep 2022 20:44:17 +0000
Message-ID: <805201ef85d2b281e148b1c0c83640378e579a03.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-6-allison.henderson@oracle.com>
         <Yy4HPUJR7Wathz+A@magnolia>
In-Reply-To: <Yy4HPUJR7Wathz+A@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CY8PR10MB6804:EE_
x-ms-office365-filtering-correlation-id: 2a36c24e-555b-4d0e-9b3b-08da9da4621d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zs9FlymYLjggP/vVrRhBRhsgmie35kMRQWhZVOLi+kZva47RSDh0bjuYKPZW7YVOinZmcAh2J2LLfD8QkRSxSuBx6gAMBj6Hy4EHFYjAX6cAiczKbRMg50TFzic4+JrzNsKwKZiDfRvk/oBPVVm3KYBM3K/gdXCdEh3mSOBOI5y2gr386JKg4Sx8Q270VYZTq1//+yNl7DmlRlCXMWMoS/xHiP705CK031LUrlABtaa+tpkrPSuQL0U2BkaMLWmFh1iH7BgEtyFclxxjtbGjqNYH440URwsK4pQ5JJ6xOhMcHVEQTvs4AfMXQhTsSi0w9BDjOeNlUduRjWkHAohLtDVZ+7Mufcx9vfBXe49cwLKIebIis75IIZZnmb/elQc+1qHrJ1sQo/BgY9WQ1liWqhHULRaRC26Lvoetgs9DyLreNXKqY3hlL2Re1tT4M0BBn6JmJBNp9AlZqi1ZaWsV/LvC8o5fOGKc+A5/eTkBZcz9U1r1Mq5QvLMZO39cTkih/X6iENKjb8TPF9tlkvLO51812LxhpbLctoU2VLN9fs9DLiwUuF8nY/TfVebiE8f3pmuSCFCb48cQ2/Pa3eZLGZPkV+fu3fvB9nmnrRyMOJG3K8SNiarOz0GSTTp2CNybh3S7Tj+i9bdTm9PktP7xnLF4lKGsx5QLiczhMDHPVcW09Ue8EhJkxLfjUqekpQy8qp2gH/FgnOnMxHURcdb4UdPjRUzYWIcSX75B7+uBDwhWUwL7MLQleF/Hl5Df46RN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(38100700002)(44832011)(71200400001)(478600001)(38070700005)(6486002)(66446008)(2616005)(64756008)(66476007)(83380400001)(66946007)(186003)(86362001)(66556008)(4326008)(26005)(6916009)(6512007)(2906002)(6506007)(76116006)(36756003)(5660300002)(8936002)(8676002)(122000001)(316002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RW1NekNCYXU2ODJXVlFRT1JhZ29CRTNwRE9jVHd6UjQrS0ZRTUFsWGwramkr?=
 =?utf-8?B?YWZRWGE1M2RySmkxVWMzTFhJdUI0SHFXUVMzS1NXN1JISkxYN3pTUHNTREFZ?=
 =?utf-8?B?c3IrSUxLWUpEcG95N2d6MXdxQW9xMjFnOWtFdnBXYjE3UUdpSjllZjd3U0pE?=
 =?utf-8?B?YnI4RHBTK1FDandranBwM3NrZmlrcFZBZ2JTOWZ4M2Y5UzhuK3o4NmgxVHhW?=
 =?utf-8?B?WkZqMW1FZFovc0VQL3lFQkpoUmdibytWUE0xczhzSm1ldUh4elp6MWhnTkIx?=
 =?utf-8?B?T2lPVGRuZUY0WWVtbHBId0gvYU14cVlPWlV6QmhoSXpYdE83aXpBeXE0d3pk?=
 =?utf-8?B?Ky9xbHJrVzNWR0xINzczOFZEVTJPZDhOSFRsWkdQUVR5VXdVczF6SEJtRVF5?=
 =?utf-8?B?c1p4a3A5cGdMYWppUnRuUlpGVFpJVU9rYmFQRXNKejdqQUpNdmlNWGxmL1VB?=
 =?utf-8?B?b25aMXQrS01uNUpIRHlHQUlTNDZEUkFNdjQwcWNnSWpNTGswcXd5M2o1VUxZ?=
 =?utf-8?B?bmlPZVduZndrWlVqUURMeG9Udnlqb1d6NmtKWXM5Y0YwTHlWRGVsN3RyeU5j?=
 =?utf-8?B?NW9OK3NpTVVZZ2FMbCtTNmpLN1FieDM1UVU2a21OSUNrb0c0QU1UMWhwYks0?=
 =?utf-8?B?WFZhMGs4NmtoM2d5dFkxdGJSeTc1bGtEc2xQR1FjY2ozSXRYUkVLdkRRbHJk?=
 =?utf-8?B?MkFUMlpqNjBKMVNTZHNxdGs1Z0FSVk1HWW52RlBUOEdSYk1YM25HdHNuRjdE?=
 =?utf-8?B?eDVubnBuc29Tc3dGSmxLUWloeDh5NHJhOXFlQUpDN2JOUXpaejJYYVNBcWFk?=
 =?utf-8?B?TFQwTkl0TEpQMEVSdXdtYURFWS8rWTlOTm13Ym0xdFZ4em5IT1dCV3lpTVlH?=
 =?utf-8?B?cTB5TU9ZUU9Mc0pDbWVLaU5NdzVMV1l5clNmUlJZa3YrUmlIZzkvWWVzbXdx?=
 =?utf-8?B?a1BQNCtXZU0vSS9QaE5SMjhqOGUrbTA5Ulp0ZVFsc0VIakxxb2JYeFZhVTNG?=
 =?utf-8?B?TEJHUXc1cG9PQ21JY1FPd0VJQnRKUkZkaGowcDEvNGU3VFdUbjJ0N091ejhu?=
 =?utf-8?B?VnJJUDN0cnVpM0h1L3pINmZHZC9YNHBMS3RTOG00TCtnQ2ZZSnRXNFNBY3Er?=
 =?utf-8?B?SHJHVnZOcHhLQUhqVGxVY1BWTEh4YmtUWTlxZTBOaENFU3g2V1FiZFNzcmhP?=
 =?utf-8?B?UVg5Y0d3a1RBbTF1SEZjcE5sbWhKVks2djR5NGwxZlpQUUVwZXI2OGV2VjUr?=
 =?utf-8?B?cklCQ2RjZC95ZHdDaDNlNG9VVTdXUXc4Qlg4N0VIVDBWRVJIRVk4OXFiZUda?=
 =?utf-8?B?cWJvRmtZSDduYjVtUHg2M1NScmltK1I2U0U0TytFRExtTDczMFN5aldJWk15?=
 =?utf-8?B?USsrcTZnV05PdXVBY0U2RHY0NWNSaGlYWTVoY0ZadzJ3a3ROb0Q2SlNXaWJU?=
 =?utf-8?B?aE5rdmZsQmh6YlozekRUdCtNNE9xZFltdTMzcm5ueUtIS21YandGdnVNL3Fo?=
 =?utf-8?B?c2tCMmljV1d6Z3RhSmhmc3F5QVdhZUs5c1JwN0NXdnRYa1U3ZlVYeE1ZRDEz?=
 =?utf-8?B?RThsVTZMMVBYQmViUEhrZEJYUENKSFJJL2xwMzR2VGhSd3pOc3V3b2ZFNXRH?=
 =?utf-8?B?bC9FdEtLS3QveEVmN09mbnBQZWxrRXo0d0Q4Rlg0amR2akxia3pZNkhWN2l2?=
 =?utf-8?B?c0pINW1IYjJFR1N3dGNja254N2RsbWoxeHVpem5VSDZsMlhJbzlJaUZiRmxK?=
 =?utf-8?B?N3RnQ0pzcVErbUxLVWVFRXdsRERKdjhBazN2QUprSysyM1VOZXVCZkVVU2tP?=
 =?utf-8?B?a09lT1dqZ1EwRGlMYzUyejRuL0d4MFcxTkhkc3RiMXV5dlNiSU9Va1JYdGRN?=
 =?utf-8?B?VDBuT3NNT1JNamNiS1owTlQ0Q0JPaWxHK0RRRHRVT3p4R0IxME9TVHE5T3pB?=
 =?utf-8?B?eGJOSk9hQkVjK2FWeUh1bTdXYWNVWjNuVWg3dnZLZ3JEOVBBM0Q0V0p0K1E0?=
 =?utf-8?B?UlQxWldkNWY0THpncUpJSE0vNkxxY2c4VWRJc2JoQ1VmVEpiVkZWYnZkaXdU?=
 =?utf-8?B?UjkvNVRmN0VpSUxpSUNObnBab3l0M1ZaaEdRM1o3VE00eHM5SU0xRitHK0ZC?=
 =?utf-8?B?RFN6c1MzRmZ1MnJOcnBqajc4aGw4dTk3cnMxMDJZVjhlVjlFRGlObnVsVkY3?=
 =?utf-8?B?S1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47E5AABF3320984684823E26ADE060D0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a36c24e-555b-4d0e-9b3b-08da9da4621d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 20:44:17.2204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lDbYH2OFgEAKFYoy0OkcFKSCQvcISGsMO9EeXY93OaY8kkvUcnPhx0y3KtzR18MLr8rFunDszK5bzvw1cioYVBHn+ePILQemnjDb/mHgN5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6804
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_09,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209230134
X-Proofpoint-GUID: LGgnqDkWgUBr-ujonKtcYqhW0FJDRy_V
X-Proofpoint-ORIG-GUID: LGgnqDkWgUBr-ujonKtcYqhW0FJDRy_V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDEyOjIxIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMTA6NDQ6MzdQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+ID4gCj4gPiBNb2RpZnkgeGZzX3JlbmFtZSB0
byBob2xkIGFsbCBpbm9kZSBsb2NrcyBhY3Jvc3MgYSByZW5hbWUgb3BlcmF0aW9uCj4gPiBXZSB3
aWxsIG5lZWQgdGhpcyBsYXRlciB3aGVuIHdlIGFkZCBwYXJlbnQgcG9pbnRlcnMKPiA+IAo+ID4g
U2lnbmVkLW9mZi1ieTogQWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNs
ZS5jb20+Cj4gPiAtLS0KPiA+IMKgZnMveGZzL3hmc19pbm9kZS5jIHwgMzUgKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0tLS0tLS0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDIyIGluc2VydGlv
bnMoKyksIDEzIGRlbGV0aW9ucygtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19p
bm9kZS5jIGIvZnMveGZzL3hmc19pbm9kZS5jCj4gPiBpbmRleCA5YTMxNzRhOGY4OTUuLjRiZmE0
YTE1NzlmMCAxMDA2NDQKPiA+IC0tLSBhL2ZzL3hmcy94ZnNfaW5vZGUuYwo+ID4gKysrIGIvZnMv
eGZzL3hmc19pbm9kZS5jCj4gPiBAQCAtMjgzNywxOCArMjgzNywxNiBAQCB4ZnNfcmVuYW1lKAo+
ID4gwqDCoMKgwqDCoMKgwqDCoHhmc19sb2NrX2lub2Rlcyhpbm9kZXMsIG51bV9pbm9kZXMsIFhG
U19JTE9DS19FWENMKTsKPiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiA+IC3CoMKgwqDC
oMKgwqDCoCAqIEpvaW4gYWxsIHRoZSBpbm9kZXMgdG8gdGhlIHRyYW5zYWN0aW9uLiBGcm9tIHRo
aXMgcG9pbnQKPiA+IG9uLAo+ID4gLcKgwqDCoMKgwqDCoMKgICogd2UgY2FuIHJlbHkgb24gZWl0
aGVyIHRyYW5zX2NvbW1pdCBvciB0cmFuc19jYW5jZWwgdG8KPiA+IHVubG9jawo+ID4gLcKgwqDC
oMKgwqDCoMKgICogdGhlbS4KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIEpvaW4gYWxsIHRoZSBpbm9k
ZXMgdG8gdGhlIHRyYW5zYWN0aW9uLgo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqLwo+ID4gLcKgwqDC
oMKgwqDCoMKgeGZzX3RyYW5zX2lqb2luKHRwLCBzcmNfZHAsIFhGU19JTE9DS19FWENMKTsKPiA+
ICvCoMKgwqDCoMKgwqDCoHhmc190cmFuc19pam9pbih0cCwgc3JjX2RwLCAwKTsKPiA+IMKgwqDC
oMKgwqDCoMKgwqBpZiAobmV3X3BhcmVudCkKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqB4ZnNfdHJhbnNfaWpvaW4odHAsIHRhcmdldF9kcCwgWEZTX0lMT0NLX0VYQ0wpOwo+ID4g
LcKgwqDCoMKgwqDCoMKgeGZzX3RyYW5zX2lqb2luKHRwLCBzcmNfaXAsIFhGU19JTE9DS19FWENM
KTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfdHJhbnNfaWpvaW4odHAs
IHRhcmdldF9kcCwgMCk7Cj4gPiArwqDCoMKgwqDCoMKgwqB4ZnNfdHJhbnNfaWpvaW4odHAsIHNy
Y19pcCwgMCk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHRhcmdldF9pcCkKPiA+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfdHJhbnNfaWpvaW4odHAsIHRhcmdldF9pcCwgWEZT
X0lMT0NLX0VYQ0wpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhmc190cmFu
c19pam9pbih0cCwgdGFyZ2V0X2lwLCAwKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAod2lwKQo+
ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhmc190cmFuc19pam9pbih0cCwgd2lw
LCBYRlNfSUxPQ0tfRVhDTCk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGZz
X3RyYW5zX2lqb2luKHRwLCB3aXAsIDApOwo+ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqAvKgo+
ID4gwqDCoMKgwqDCoMKgwqDCoCAqIElmIHdlIGFyZSB1c2luZyBwcm9qZWN0IGluaGVyaXRhbmNl
LCB3ZSBvbmx5IGFsbG93Cj4gPiByZW5hbWVzCj4gPiBAQCAtMjg2MiwxMCArMjg2MCwxMiBAQCB4
ZnNfcmVuYW1lKAo+ID4gwqDCoMKgwqDCoMKgwqDCoH0KPiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDC
oMKgLyogUkVOQU1FX0VYQ0hBTkdFIGlzIHVuaXF1ZSBmcm9tIGhlcmUgb24uICovCj4gPiAtwqDC
oMKgwqDCoMKgwqBpZiAoZmxhZ3MgJiBSRU5BTUVfRVhDSEFOR0UpCj4gPiAtwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHhmc19jcm9zc19yZW5hbWUodHAsIHNyY19kcCwgc3Jj
X25hbWUsCj4gPiBzcmNfaXAsCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoZmxhZ3MgJiBSRU5BTUVf
RVhDSEFOR0UpIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhm
c19jcm9zc19yZW5hbWUodHAsIHNyY19kcCwgc3JjX25hbWUsCj4gPiBzcmNfaXAsCj4gPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHRhcmdldF9kcCwgdGFyZ2V0X25hbWUsCj4gPiB0YXJnZXRfaXAs
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNwYWNlcmVzKTsKPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dF91bmxvY2s7Cj4gPiArwqDCoMKgwqDCoMKgwqB9Cj4g
PiDCoAo+ID4gwqDCoMKgwqDCoMKgwqDCoC8qCj4gPiDCoMKgwqDCoMKgwqDCoMKgICogVHJ5IHRv
IHJlc2VydmUgcXVvdGEgdG8gaGFuZGxlIGFuIGV4cGFuc2lvbiBvZiB0aGUKPiA+IHRhcmdldCBk
aXJlY3RvcnkuCj4gPiBAQCAtMzA5MCwxMiArMzA5MCwyMSBAQCB4ZnNfcmVuYW1lKAo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfdHJhbnNfbG9nX2lub2RlKHRwLCB0YXJn
ZXRfZHAsIFhGU19JTE9HX0NPUkUpOwo+ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9
IHhmc19maW5pc2hfcmVuYW1lKHRwKTsKPiA+IC3CoMKgwqDCoMKgwqDCoGlmICh3aXApCj4gPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGZzX2lyZWxlKHdpcCk7Cj4gPiAtwqDCoMKg
wqDCoMKgwqByZXR1cm4gZXJyb3I7Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKgwqBnb3RvIG91dF91
bmxvY2s7Cj4gPiDCoAo+ID4gwqBvdXRfdHJhbnNfY2FuY2VsOgo+ID4gwqDCoMKgwqDCoMKgwqDC
oHhmc190cmFuc19jYW5jZWwodHApOwo+ID4gK291dF91bmxvY2s6Cj4gPiArwqDCoMKgwqDCoMKg
wqAvKiBVbmxvY2sgaW5vZGVzIGluIHJldmVyc2Ugb3JkZXIgKi8KPiA+ICvCoMKgwqDCoMKgwqDC
oGZvciAoaSA9IG51bV9pbm9kZXMgLSAxOyBpID49IDA7IGktLSkgewo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGlmIChpbm9kZXNbaV0pCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhmc19pdW5sb2NrKGlub2Rlc1tpXSwgWEZTX0lM
T0NLX0VYQ0wpOwo+ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIFNr
aXAgZHVwbGljYXRlIGlub2RlcyBpZiBzcmMgYW5kIHRhcmdldCBkcHMgYXJlCj4gPiB0aGUgc2Ft
ZSAqLwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChpICYmIChpbm9kZXNb
aV0gPT0gaW5vZGVzW2kgLSAxXSkpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGktLTsKPiA+ICvCoMKgwqDCoMKgwqDCoH0KPiAKPiBDb3VsZCB5b3Ug
aG9pc3QgdGhpcyB0byBhIHN0YXRpYyBpbmxpbmUgeGZzX2l1bmxvY2tfYWZ0ZXJfcmVuYW1lCj4g
ZnVuY3Rpb24gdGhhdCBpcyBhZGphY2VudCB0byB4ZnNfc29ydF9mb3JfcmVuYW1lLCBwbGVhc2U/
wqAgSXQncwo+IGVhc2llcgo+IHRvIHZlcmlmeSB0aGF0IGl0IGRvZXMgdGhlIHJpZ2h0IHRoaW5n
IHcuci50LiBtdWx0aXBsZSBhcnJheQo+IHJlZmVyZW5jZXMKPiBwb2ludGluZyB0byB0aGUgc2Ft
ZSBpbmNvcmUgaW5vZGUgd2hlbiB0aGUgdHdvIGFycmF5IG1hbmFnZW1lbnQKPiBmdW5jdGlvbnMg
YXJlIHJpZ2h0IG5leHQgdG8gZWFjaCBvdGhlci4KPiAKPiBzdGF0aWMgaW5saW5lIHZvaWQKPiB4
ZnNfaXVubG9ja19hZnRlcl9yZW5hbWUoCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5v
ZGXCoMKgwqDCoMKgwqDCoMKgKippX3RhYiwKPiDCoMKgwqDCoMKgwqDCoMKgaW50wqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbnVtX2lub2RlcykKPiB7Cj4gwqDCoMKg
wqDCoMKgwqDCoGZvciAoaSA9IG51bV9pbm9kZXMgLSAxOyBpID49IDA7IGktLSkgewo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogU2tpcCBkdXBsaWNhdGUgaW5vZGVzIGlmIHNy
YyBhbmQgdGFyZ2V0IGRwcyBhcmUKPiB0aGUgc2FtZSAqLwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgaWYgKCFpX3RhYltpXSB8fCAoaSA+IDAgJiYgaV90YWJbaV0gPT0gaV90YWJb
aSAtIDFdKSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBjb250aW51ZTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhmc19pdW5sb2Nr
KGlfdGFiW2ldLCBYRlNfSUxPQ0tfRVhDTCk7Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiB9Cj4gClN1
cmUsIHRoYXQgbG9va3MgZmluZS4gIFdpbGwgZG8uICBUaGFua3MhCkFsbGlzb24KCj4gV2l0aCB0
aGF0IGNsZWFuZWQgdXAsCj4gUmV2aWV3ZWQtYnk6IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtl
cm5lbC5vcmc+Cj4gCj4gLS1ECj4gCj4gPiDCoG91dF9yZWxlYXNlX3dpcDoKPiA+IMKgwqDCoMKg
wqDCoMKgwqBpZiAod2lwKQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNf
aXJlbGUod2lwKTsKPiA+IC0tIAo+ID4gMi4yNS4xCj4gPiAKCg==
