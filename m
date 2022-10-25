Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA2BC38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 20:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiJYUrt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 16:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJYUrr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 16:47:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6703EEE0A3
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 13:47:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PKhmbu013820;
        Tue, 25 Oct 2022 20:47:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SPP40YeZnS6R14Oz4j2axRYo4FoB4M9yuaTY0icCLVQ=;
 b=fNkpoX6sgAGqG+mrKHB60YgwX4S/2Qb9Hm45fwcZqtWSvpjJCwK/+iEmxCojRk8COSAD
 ZmsqklFI4c55XhBhgQ1fCY1oqK3pxQqcghrbDXAcohGi2u9AVWwUaB5AiVMy2jUYgI0Q
 yPRzFs7h+rk2+qeOardPTH6wQVRPC5i0Qrx2vS4gGvpJY4i9A0T/3YzD9+eeDSEiNmjf
 70h3Ks80tdaODu+84xofH59mYTq6HxY0tQiYkJB7K9pK1AYAuLB6VCYjfVoERjsXHc44
 y0g4Ff9wDHuMLIn0LMeKWnZSaxTUEV1OJU5VMErA+bUFQF2rL+r58n0YmlIEGHoM3Gmt Dg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbmhb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:47:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJN5G1012715;
        Tue, 25 Oct 2022 20:47:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y50vxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:47:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBJHUzwrjillo1XfLnHivCgm+A6jjW1wCgmIE2qr3QOmd6kod4I0KMdoiTTLx7AbdpYyWN1GbyN1Kj0zJ+3tX7mdVfea/HV4dHGzJidCEd5pWdQtucyAjmvtCvtWZcQnxjNLJPuGBUTIoVVtAa1cu3bZ+Z1Xwz2tuHfT1qDp0RC7nA+24+6Ghl6l7CmocTO6MUfxtjeFluXzE/+bLYJeyY79qxd0SqfiUtJYAK9/51CxMhy/uPtzu5QKLAYhKT8leKNCiyM3JW4ENCa2vVnyh3YKYBXFrg8+o+LEkg5Im4VePJJlWBy3zeg0V9rVRQgsgOHlGK29X5DXZcAEmUeu/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPP40YeZnS6R14Oz4j2axRYo4FoB4M9yuaTY0icCLVQ=;
 b=ejlyoTp2LnyxM8/MuFY6VMyqSQsrgbfrvY0tUnD+AImWZJBn5VM0sZUq/iKLUFWYbcgAXMdcgjITEiLRP3zIVQ72+5+0/HrxcAvf2hAR1BKc9wLnEE1c4YKoyj5izILM/96s6tdcD0Vk8pKtsvkCNFRi+KNGk1yoeUnzKZvLxJFRFIheK2vNg93Wrk+RgvUY5nULJV8A+mpXdWXJ6snaiYlHcJ1q3+RX1ACKwDHqnWhw1BdFEj55Ae/wRGVAtCgsp91cyDF3TJrDFBsrj0jL2DwgU/hG5lDPQa89h8Co/sS1SVoFN2iTGL0eZ16n+r1ODJ6wgHR0mpLMwIB+bKPh8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPP40YeZnS6R14Oz4j2axRYo4FoB4M9yuaTY0icCLVQ=;
 b=BBpl+uZCaTmLN4uHpVd9bRY1FaPSX4GoVOQ41y31rRZ1zh7QQ9aYb6wbvUbe8NBzTVtr2v0XAxIEe5M/c+gDeZu2i1nc6VgKcfj339SzccPSUkqrEH8Z1DWlO2DEQ0Vi74ny7Yf/VaYl6y4fugVOOR1UdRhbffOaGenU9jt3hRU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 20:47:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5746.023; Tue, 25 Oct 2022
 20:47:39 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/6] xfs: fix memcpy fortify errors in CUI log format
 copying
Thread-Topic: [PATCH 3/6] xfs: fix memcpy fortify errors in CUI log format
 copying
Thread-Index: AQHY5/45unrkrmMRgESuby7pCwjeAa4flgwA
Date:   Tue, 25 Oct 2022 20:47:39 +0000
Message-ID: <d8ec5200f1031101ebaf4983b7673538231d9891.camel@oracle.com>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
         <166664716856.2688790.1609211323933786255.stgit@magnolia>
In-Reply-To: <166664716856.2688790.1609211323933786255.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SA2PR10MB4426:EE_
x-ms-office365-filtering-correlation-id: 92940837-4c4f-47ad-b35d-08dab6ca27d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D4WGJIoWRg8BP91NO1SKMjcTAMXiBDEXGWJOc1KVZY3i/LQOVn30bqSL7cLrZRQbKsFnY4FrSCHcUPEKhXYPUitiooAxqJw0gnaoEFjzHy/rbcJvBmcZEO088jSnurZsIlg3U6//vL6o4wQ5ZyiPmvzaequ9zreLpE0n+eNykzX7AdtiwlW+v2YC7T8oeMKse86cvQeyoYZlRw+JV3fqCwTtXBgAdUvzclgBmtsOtZk2NlYZhN2l2PSH0IUEPVDuB2Omv/e5rEQloCNxi0ZcXHzCh75cLDlXDkxJBCZfzCWo0W6knUciKX8gltwUZloMVvX5vhKfIB8WKqZzVdTMuxs7V4Lk3GfUmbnD/BBfyMGa8z4HpPNsCXuim8AoAs6ee/kA1VuOQF/EeiiAG7GgrUtOMU/qtAWO7BzONvpH6C9rOxSF6Fzvb55Chd8dswzvA1demWwzdw48INR4yP78zxPUMWRAX1J/19Y/mpPfrneizWXyWkEL/50GH31RyKI92USn0fU51NpuMqtiTd+qchvGGWciIKJvo7/zjRVjifq4EOMbrH0/CQ9czovuA4a+4f/jOgtrKqeCkw3ptF3yaI2FDDvVEha7erMxznVz3qVm5GsAw/jbgpnDt7N97o3fB7x6RatljZxYTZNpkLjZGzRYD+ZDtwUfUxp0SLLC+jnP84Z7JkFQqQaVJ0Iq3hC/AkH4G9viqhEoTLj73P/v2yoONES4EUF/XsMLGquKg8jCxxGAaXHUEyl1QvmbEjVllUASQjCc7+Sam1O9rCEkyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(83380400001)(38070700005)(86362001)(66556008)(38100700002)(8936002)(44832011)(122000001)(66946007)(66476007)(5660300002)(76116006)(4326008)(64756008)(41300700001)(8676002)(2906002)(186003)(6506007)(4001150100001)(26005)(2616005)(6512007)(36756003)(54906003)(6916009)(478600001)(66446008)(316002)(71200400001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0FabVZzSUwxdHlld2ZzWkU4U3Jzc25DZVRNR3FQTWVPQ0hVM3hQMzBsTWZB?=
 =?utf-8?B?bTlpeno1L3dtZC9SaWozMEhCK0RIUk5VYis5NTM0QmQwbUVNcy9sdzUxLy9M?=
 =?utf-8?B?LzBlVGQyK3dvakI5b2QzWGVaeXBVNk1HaFVCb3d3VzJmVFRiQkhrZjFnTDVL?=
 =?utf-8?B?aUY2dFBvVzRIR2NDY3VKamRrLytaRXRBRDJ1dDZ5UEljNHdsYWN6VStsNEJ1?=
 =?utf-8?B?NHQxRElKUHE4bGNZRFNqbHdzU3NjQkRRdDB4ekdyVy9pbjlQWXpaODF2UXMy?=
 =?utf-8?B?RGdURG5hUVF4SlBOcStPUVJSNDIwWDJFaXBHYzFUdU43QWJHUkpwb3dqc294?=
 =?utf-8?B?SlllNU1jRXZrenVEalZXQllkL25yK2swRkVGdGhBVXZkenB0NkFnbTZOQU5t?=
 =?utf-8?B?N3dNc3VYN2Vqcmw2UEpwQ3BoMGU1bW9rd2l3K25MS01oLzh1SHRwYjU5cVhy?=
 =?utf-8?B?UjlvYWdMV2Q5TUJVMWY3Mm5IclU2Ymlrb3hOTENRd0RZNTZwZlNIUnhjYUUr?=
 =?utf-8?B?Q2tnZG5Ca3crUDFhd044SmxHWGFMekFwWjExdEpjMStVRGtoWUVRREd6L1JJ?=
 =?utf-8?B?ODEzYzFTNGRmQXlCWnFCSW9mTnFhVnZrbXZrK0QzUXFsUmZOazIyZFBFajNG?=
 =?utf-8?B?TDUxU24rRXFvNWFmcDlTSzM2K2pDOXRCWkVibEI3bXJheEVpdU9HL3RsTGg3?=
 =?utf-8?B?SFl4dHpiYisrbFZKdy9sUTZENy9jODlBb1J3S3FxY2c1YVRaMlhsY0p1SDVO?=
 =?utf-8?B?K3ErT1FSbm85QkhyRGRVVGlHUEx3T1J6bUhMWndiV0NBSm5zZXg0WnAyWnhO?=
 =?utf-8?B?RXZxbEhpUVFNV2tvajZ0azBNQ0RzNXJDMzgvMzAyZGVyUWxDcHVSa3NLSzdQ?=
 =?utf-8?B?NjJCdHpsYWtpeElzWW1PL0lOdy8wZ0JkVjFySFhoYURDVTBmNTFBbDF3Q2lR?=
 =?utf-8?B?eFphd1dGOUdiQVdvYVowUDJkN3EvSG55RGRnT1B1MWFNQmJGbFBZK1l3OXhS?=
 =?utf-8?B?WTlNU00yeHdjRlBYbnpaOVdMZ3loT0FKc29rSkIyS3ltZmlZc2R2Q1lRMzIy?=
 =?utf-8?B?TkNtTHRyMUtIa0s0d044dWx1MGU5UGgxVktBOXB3WHN6QWhXbkxvRjNma2lY?=
 =?utf-8?B?TzR5WHJmOFk3T0xWb0VjNjd0bnJnckVaYS9weDZuOFJvQStTM2lpWUxyMXh0?=
 =?utf-8?B?bkdjTFRmdlpJL2J1YUFCa2NjbGVqcHl0S1BPK2xFbFJCREJwZkovVlJJdmZV?=
 =?utf-8?B?OWorWVAvM3lZUTFUR202Q2d0WEZkbEl3bFNBdFgvbWE3ZkZ6RFJ1YXJkU2pn?=
 =?utf-8?B?aFBBV3IrbC80QlZkNVI5L25DWlNjRDUxbnlmbDVmRFFkOGdsMC91bGg0Y2RH?=
 =?utf-8?B?NStNcU0rSDhjMzNZNVZSRjVKMUJpQXludGJ5am82RmxwSUVVWE9pVTkvdzky?=
 =?utf-8?B?ZnJBbS8rZ0hHajdXVDh3Qkl3Szd2L296aUpoWjh1V0sxTjE3M2NDclRuUDN5?=
 =?utf-8?B?UllMRys5emtZeDRtTk96WTJ0djdoK0p0QmxDSzM5Z0gxamVSVXFKeWozbjRo?=
 =?utf-8?B?S1c3TkJIYlpGN0lVSzBpZ2dwTldWVktTc2NZeHBQZVIyZXVIMy9YL1hOUWJ5?=
 =?utf-8?B?cHdhdTdCUmpBTDliUVhmS1Q1MFdsdkNCc3BPM3ZsUWN6c20yVjBKOC8vaFI4?=
 =?utf-8?B?RENsYzRVMnRxTjFPOHJBQ0JWNnRXSEFRS2N1M2lXSUs2bGhoWDh3WlA5dEZJ?=
 =?utf-8?B?YzY4OGV0YVBmOG5SMllhajduT0J5Mmw1amlTckcvZ0daNDJqd29EWElaVHBF?=
 =?utf-8?B?ajc4Uk95OUQ4VDkxMHhiSy9tWUwxN3FXanpTc2plZ1lKVGdDOFN6ekRWc0JP?=
 =?utf-8?B?MXF5NDdRNEUwU0JqZEhUeit1VnlkbFdTT0tBVHNnTHlrMTFtQW5FWElweHU2?=
 =?utf-8?B?MEpXRGhYelFvbFhIbXdVTDVTTGxKSkFuOFlOcnFsdGhXTUFRaHVaYndOVHQ2?=
 =?utf-8?B?R0VldnVLb3dQbWszQjRlMmhBVitjYmJrR3dTRlZlTE5tbnJrY3BEM3IveXlU?=
 =?utf-8?B?MjNRaG53MmRHODNhQnIzUTg2amFsRzhmWFcveGZsTkxrQ2ZtK1ZOWlkvWm9V?=
 =?utf-8?B?aGdzcHVYQi9kRGpnaFhuRU1pWG5Uay9iNEI1ZWIrd2FWOTFId1d5dmQwWDFu?=
 =?utf-8?B?L0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <814A221F98B4A2488B916DAADDD8D966@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92940837-4c4f-47ad-b35d-08dab6ca27d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 20:47:39.3883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yJFfI+r+mVlgYHOA0ODX4KgCkLVV6/UJX9+Q9Co0V5r0wlEURV9RAI1YNZKPI9p/GOP41wAfEF6Q7E4Hs1GK7sxwT/npsFho/G0c7vWAtb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250116
X-Proofpoint-ORIG-GUID: g-RFwv3I8mx-CUfgnfvGjwjJRzT_TyxL
X-Proofpoint-GUID: g-RFwv3I8mx-CUfgnfvGjwjJRzT_TyxL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTI0IGF0IDE0OjMyIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gRnJvbTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4KPiAKPiBTdGFydGlu
ZyBpbiA2LjEsIENPTkZJR19GT1JUSUZZX1NPVVJDRSBjaGVja3MgdGhlIGxlbmd0aCBwYXJhbWV0
ZXIgb2YKPiBtZW1jcHkuwqAgU2luY2Ugd2UncmUgYWxyZWFkeSBmaXhpbmcgcHJvYmxlbXMgd2l0
aCBCVUkgaXRlbSBjb3B5aW5nLAo+IHdlCj4gc2hvdWxkIGZpeCBpdCBldmVyeXRoaW5nIGVsc2Uu
Cj4gCj4gUmVmYWN0b3IgdGhlIHhmc19jdWlfY29weV9mb3JtYXQgZnVuY3Rpb24gdG8gaGFuZGxl
IHRoZSBjb3B5aW5nIG9mCj4gdGhlCj4gaGVhZCBhbmQgdGhlIGZsZXggYXJyYXkgbWVtYmVycyBz
ZXBhcmF0ZWx5LsKgIFdoaWxlIHdlJ3JlIGF0IGl0LCBmaXggYQo+IG1pbm9yIHZhbGlkYXRpb24g
ZGVmaWNpZW5jeSBpbiB0aGUgcmVjb3ZlcnkgZnVuY3Rpb24uCj4gCj4gU2lnbmVkLW9mZi1ieTog
RGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4KQWxyaWdodHksIGxvb2tzIGdvb2QK
UmV2aWV3ZWQtYnk6IEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUu
Y29tPgo+IC0tLQo+IMKgZnMveGZzL3hmc19vbmRpc2suaMKgwqDCoMKgwqDCoMKgIHzCoMKgwqAg
NCArKysrCj4gwqBmcy94ZnMveGZzX3JlZmNvdW50X2l0ZW0uYyB8wqDCoCA0NSArKysrKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tCj4gLS0tLS0tLS0tLQo+IMKgMiBmaWxlcyBjaGFuZ2Vk
LCAyNSBpbnNlcnRpb25zKCspLCAyNCBkZWxldGlvbnMoLSkKPiAKPiAKPiBkaWZmIC0tZ2l0IGEv
ZnMveGZzL3hmc19vbmRpc2suaCBiL2ZzL3hmcy94ZnNfb25kaXNrLmgKPiBpbmRleCA1NjkxN2Uy
MzYzNzAuLmUyMGQyODQ0YjBjNSAxMDA2NDQKPiAtLS0gYS9mcy94ZnMveGZzX29uZGlzay5oCj4g
KysrIGIvZnMveGZzL3hmc19vbmRpc2suaAo+IEBAIC0xMzYsOSArMTM2LDEzIEBAIHhmc19jaGVj
a19vbmRpc2tfc3RydWN0cyh2b2lkKQo+IMKgwqDCoMKgwqDCoMKgwqBYRlNfQ0hFQ0tfU1RSVUNU
X1NJWkUoc3RydWN0IHhmc19hdHRyZF9sb2dfZm9ybWF0LMKgwqDCoMKgwqDCoDE2KTsKPiDCoMKg
wqDCoMKgwqDCoMKgWEZTX0NIRUNLX1NUUlVDVF9TSVpFKHN0cnVjdCB4ZnNfYnVpX2xvZ19mb3Jt
YXQswqDCoMKgwqDCoMKgwqDCoDE2KTsKPiDCoMKgwqDCoMKgwqDCoMKgWEZTX0NIRUNLX1NUUlVD
VF9TSVpFKHN0cnVjdCB4ZnNfYnVkX2xvZ19mb3JtYXQswqDCoMKgwqDCoMKgwqDCoDE2KTsKPiAr
wqDCoMKgwqDCoMKgwqBYRlNfQ0hFQ0tfU1RSVUNUX1NJWkUoc3RydWN0IHhmc19jdWlfbG9nX2Zv
cm1hdCzCoMKgwqDCoMKgwqDCoMKgMTYpOwo+ICvCoMKgwqDCoMKgwqDCoFhGU19DSEVDS19TVFJV
Q1RfU0laRShzdHJ1Y3QgeGZzX2N1ZF9sb2dfZm9ybWF0LMKgwqDCoMKgwqDCoMKgwqAxNik7Cj4g
wqDCoMKgwqDCoMKgwqDCoFhGU19DSEVDS19TVFJVQ1RfU0laRShzdHJ1Y3QgeGZzX21hcF9leHRl
bnQswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMzIpOwo+ICvCoMKgwqDCoMKgwqDCoFhGU19DSEVD
S19TVFJVQ1RfU0laRShzdHJ1Y3QgeGZzX3BoeXNfZXh0ZW50LMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAxNik7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgWEZTX0NIRUNLX09GRlNFVChzdHJ1Y3QgeGZz
X2J1aV9sb2dfZm9ybWF0LAo+IGJ1aV9leHRlbnRzLMKgwqDCoMKgwqDCoMKgwqAxNik7Cj4gK8Kg
wqDCoMKgwqDCoMKgWEZTX0NIRUNLX09GRlNFVChzdHJ1Y3QgeGZzX2N1aV9sb2dfZm9ybWF0LAo+
IGN1aV9leHRlbnRzLMKgwqDCoMKgwqDCoMKgwqAxNik7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKg
LyoKPiDCoMKgwqDCoMKgwqDCoMKgICogVGhlIHY1IHN1cGVyYmxvY2sgZm9ybWF0IGV4dGVuZGVk
IHNldmVyYWwgdjQgaGVhZGVyCj4gc3RydWN0dXJlcyB3aXRoCj4gZGlmZiAtLWdpdCBhL2ZzL3hm
cy94ZnNfcmVmY291bnRfaXRlbS5jIGIvZnMveGZzL3hmc19yZWZjb3VudF9pdGVtLmMKPiBpbmRl
eCA3ZTk3YmYxOTc5M2QuLjI0Y2Y0YzY0ZWJhYSAxMDA2NDQKPiAtLS0gYS9mcy94ZnMveGZzX3Jl
ZmNvdW50X2l0ZW0uYwo+ICsrKyBiL2ZzL3hmcy94ZnNfcmVmY291bnRfaXRlbS5jCj4gQEAgLTYy
MiwyOCArNjIyLDE4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgeGZzX2l0ZW1fb3BzCj4geGZzX2N1
aV9pdGVtX29wcyA9IHsKPiDCoMKgwqDCoMKgwqDCoMKgLmlvcF9yZWxvZ8KgwqDCoMKgwqDCoD0g
eGZzX2N1aV9pdGVtX3JlbG9nLAo+IMKgfTsKPiDCoAo+IC0vKgo+IC0gKiBDb3B5IGFuIENVSSBm
b3JtYXQgYnVmZmVyIGZyb20gdGhlIGdpdmVuIGJ1ZiwgYW5kIGludG8gdGhlCj4gZGVzdGluYXRp
b24KPiAtICogQ1VJIGZvcm1hdCBzdHJ1Y3R1cmUuwqAgVGhlIENVSS9DVUQgaXRlbXMgd2VyZSBk
ZXNpZ25lZCBub3QgdG8KPiBuZWVkIGFueQo+IC0gKiBzcGVjaWFsIGFsaWdubWVudCBoYW5kbGlu
Zy4KPiAtICovCj4gLXN0YXRpYyBpbnQKPiArc3RhdGljIGlubGluZSB2b2lkCj4gwqB4ZnNfY3Vp
X2NvcHlfZm9ybWF0KAo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfbG9nX2lvdmVjwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgKmJ1ZiwKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2N1aV9s
b2dfZm9ybWF0wqDCoMKgwqDCoMKgwqAqZHN0X2N1aV9mbXQpCj4gK8KgwqDCoMKgwqDCoMKgc3Ry
dWN0IHhmc19jdWlfbG9nX2Zvcm1hdMKgwqDCoMKgwqDCoMKgKmRzdCwKPiArwqDCoMKgwqDCoMKg
wqBjb25zdCBzdHJ1Y3QgeGZzX2N1aV9sb2dfZm9ybWF0wqAqc3JjKQo+IMKgewo+IC3CoMKgwqDC
oMKgwqDCoHN0cnVjdCB4ZnNfY3VpX2xvZ19mb3JtYXTCoMKgwqDCoMKgwqDCoCpzcmNfY3VpX2Zt
dDsKPiAtwqDCoMKgwqDCoMKgwqB1aW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBsZW47Cj4gK8KgwqDCoMKgwqDCoMKgdW5zaWduZWQgaW50
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGk7Cj4gwqAKPiAtwqDCoMKg
wqDCoMKgwqBzcmNfY3VpX2ZtdCA9IGJ1Zi0+aV9hZGRyOwo+IC3CoMKgwqDCoMKgwqDCoGxlbiA9
IHhmc19jdWlfbG9nX2Zvcm1hdF9zaXplb2Yoc3JjX2N1aV9mbXQtPmN1aV9uZXh0ZW50cyk7Cj4g
K8KgwqDCoMKgwqDCoMKgbWVtY3B5KGRzdCwgc3JjLCBvZmZzZXRvZihzdHJ1Y3QgeGZzX2N1aV9s
b2dfZm9ybWF0LAo+IGN1aV9leHRlbnRzKSk7Cj4gwqAKPiAtwqDCoMKgwqDCoMKgwqBpZiAoYnVm
LT5pX2xlbiA9PSBsZW4pIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWVtY3B5
KGRzdF9jdWlfZm10LCBzcmNfY3VpX2ZtdCwgbGVuKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcmV0dXJuIDA7Cj4gLcKgwqDCoMKgwqDCoMKgfQo+IC3CoMKgwqDCoMKgwqDCoFhG
U19FUlJPUl9SRVBPUlQoX19mdW5jX18sIFhGU19FUlJMRVZFTF9MT1csIE5VTEwpOwo+IC3CoMKg
wqDCoMKgwqDCoHJldHVybiAtRUZTQ09SUlVQVEVEOwo+ICvCoMKgwqDCoMKgwqDCoGZvciAoaSA9
IDA7IGkgPCBzcmMtPmN1aV9uZXh0ZW50czsgaSsrKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBtZW1jcHkoJmRzdC0+Y3VpX2V4dGVudHNbaV0sICZzcmMtPmN1aV9leHRlbnRzW2ld
LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHNpemVvZihzdHJ1Y3QgeGZzX3BoeXNfZXh0ZW50KSk7Cj4gwqB9Cj4gwqAKPiDC
oC8qCj4gQEAgLTY2MCwxOSArNjUwLDI2IEBAIHhsb2dfcmVjb3Zlcl9jdWlfY29tbWl0X3Bhc3My
KAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGxvZ19yZWNvdmVyX2l0ZW3CoMKgwqDCoMKgwqDC
oMKgKml0ZW0sCj4gwqDCoMKgwqDCoMKgwqDCoHhmc19sc25fdMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBsc24pCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgaW50
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGVycm9yOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX21vdW50wqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAqbXAgPSBsb2ctPmxfbXA7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVj
dCB4ZnNfY3VpX2xvZ19pdGVtwqDCoMKgwqDCoMKgwqDCoMKgKmN1aXA7Cj4gwqDCoMKgwqDCoMKg
wqDCoHN0cnVjdCB4ZnNfY3VpX2xvZ19mb3JtYXTCoMKgwqDCoMKgwqDCoCpjdWlfZm9ybWF0cDsK
PiArwqDCoMKgwqDCoMKgwqBzaXplX3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgbGVuOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGN1aV9mb3JtYXRw
ID0gaXRlbS0+cmlfYnVmWzBdLmlfYWRkcjsKPiDCoAo+ICvCoMKgwqDCoMKgwqDCoGlmIChpdGVt
LT5yaV9idWZbMF0uaV9sZW4gPCB4ZnNfY3VpX2xvZ19mb3JtYXRfc2l6ZW9mKDApKSB7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFhGU19FUlJPUl9SRVBPUlQoX19mdW5jX18sIFhG
U19FUlJMRVZFTF9MT1csIGxvZy0KPiA+bF9tcCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJldHVybiAtRUZTQ09SUlVQVEVEOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiArCj4gK8Kg
wqDCoMKgwqDCoMKgbGVuID0geGZzX2N1aV9sb2dfZm9ybWF0X3NpemVvZihjdWlfZm9ybWF0cC0+
Y3VpX25leHRlbnRzKTsKPiArwqDCoMKgwqDCoMKgwqBpZiAoaXRlbS0+cmlfYnVmWzBdLmlfbGVu
ICE9IGxlbikgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBYRlNfRVJST1JfUkVQ
T1JUKF9fZnVuY19fLCBYRlNfRVJSTEVWRUxfTE9XLCBsb2ctCj4gPmxfbXApOwo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVGU0NPUlJVUFRFRDsKPiArwqDCoMKgwqDC
oMKgwqB9Cj4gKwo+IMKgwqDCoMKgwqDCoMKgwqBjdWlwID0geGZzX2N1aV9pbml0KG1wLCBjdWlf
Zm9ybWF0cC0+Y3VpX25leHRlbnRzKTsKPiAtwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19jdWlf
Y29weV9mb3JtYXQoJml0ZW0tPnJpX2J1ZlswXSwgJmN1aXAtCj4gPmN1aV9mb3JtYXQpOwo+IC3C
oMKgwqDCoMKgwqDCoGlmIChlcnJvcikgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqB4ZnNfY3VpX2l0ZW1fZnJlZShjdWlwKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIGVycm9yOwo+IC3CoMKgwqDCoMKgwqDCoH0KPiArwqDCoMKgwqDCoMKgwqB4ZnNf
Y3VpX2NvcHlfZm9ybWF0KCZjdWlwLT5jdWlfZm9ybWF0LCBjdWlfZm9ybWF0cCk7Cj4gwqDCoMKg
wqDCoMKgwqDCoGF0b21pY19zZXQoJmN1aXAtPmN1aV9uZXh0X2V4dGVudCwgY3VpX2Zvcm1hdHAt
Cj4gPmN1aV9uZXh0ZW50cyk7Cj4gwqDCoMKgwqDCoMKgwqDCoC8qCj4gwqDCoMKgwqDCoMKgwqDC
oCAqIEluc2VydCB0aGUgaW50ZW50IGludG8gdGhlIEFJTCBkaXJlY3RseSBhbmQgZHJvcCBvbmUK
PiByZWZlcmVuY2Ugc28KPiAKCg==
