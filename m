Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E5EFA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 20:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJYUrx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 16:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJYUrw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 16:47:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9DBEE0A3
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 13:47:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PKhqtU015858;
        Tue, 25 Oct 2022 20:47:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=0bsvLNj34BsCDxNjKcdAd3YC3VpdPFLnuu4Od9xuLT0=;
 b=WpToM3drEPCPHGA/0wAAHiq4Q25qsWR6PHZfDFnL6HPc2OGZBzDfIonx9OlHUeycBq18
 PbMPnrLY1zX3GkaP/VzkFPRtgBrqWN6WbNh0YM5l+ugfu3VuutNn/c5SEpiobu/F4oJ4
 bIQIe6S4xzqJNRau/4fVlSvPA0UFlR8l6U7kjcYNcMJAmu2yfGYgkIRXjKf5s60DhphL
 Sgx8dd2rY2lUU6ur0U2l0M/ErMpBUNf5Kos82xoCmGtQOrzb4H574c67mEP3wNK/hTH9
 Wg/I3mQ2fw/FqJSu6ftFlLOj7wMfNbAmhNm4aD/kp8UUa15rgwXl5RDBXwtW1yrCbwbj /g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xe42u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:47:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJlbqF032133;
        Tue, 25 Oct 2022 20:47:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6yba5b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:47:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liuTwJTUXX0UcgzMeBRPsaVheD31wKosoxXhFArinJNm5Fw9LYAu66qy0KnPYSb4clYMyNFH8Usem8Lj+qEzWGin3MZPKv6ePupcdkx93tQbvfzG0ZickSVozWtON2QSHesiJmfrJ/eazvc8Kuv+E4GQCfsfPhOpLczl52Dit1sQjenbEb+TcZ56UHw3hHF/1ePQ0wEQ4Myr6U9BW5TYJ9+PnCxroP2j/yOE5DCv38Bv/8S8K9eLWhyjaJVywFoz9Rdgq/PM7+QNGNu00MuKLpaeDeeMbz0M5nrXfRDrGLmsOhmHEO0Ay/IPJUsFk6tlJDuJ3CKUNbAotoYqwVLWSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bsvLNj34BsCDxNjKcdAd3YC3VpdPFLnuu4Od9xuLT0=;
 b=nMkiFe07d8hV+j9fjK1PpHRaTFNWjrmBzDoE45UOhGUVhFy7/U2EwFXy3eVhySSV2GgxywwvrMs+iq4vVwHdk7WpW2UKkrSiyNeh1c/Xeaqq2GTCfuAbtEkdULxgNhYVG+fdejlF9FIfBZr2Uatd0V+KZrABkQR6NJ5ZK6e2O3KMo9QpodKkfZJq9Uh6h3x7ZeTpZ5QXHfmk1eWP/daaSATgioRSSkcn+LdeIPM1k6QrzWvyisMiMpM+9K7dcst5/nGQpwO4u2tdOZzw+FDLwuZqGpvfbhb55rZpqPZgTcFwH4dcUKYqZPcSyeypGSW7kGsv+Q9maLv39QyjgJhDPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bsvLNj34BsCDxNjKcdAd3YC3VpdPFLnuu4Od9xuLT0=;
 b=nIV3U91RHFdlihsIMJLTsNf22NRuAUoGCRQlsZAUWZaPsgAewsnEC/6Z5eCTrdD37h+BuA0hd9L/efjGCp6MeHLZ5zc56oIS8F4/mkGRmpbNqgJdzXNC0fF0xuYDIXcdeCcCdOJU8Y9OwjmVXCFYeKhE6FTVzUb8xzf56NX/Bjo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 20:47:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5746.023; Tue, 25 Oct 2022
 20:47:36 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/6] xfs: fix memcpy fortify errors in BUI log format
 copying
Thread-Topic: [PATCH 2/6] xfs: fix memcpy fortify errors in BUI log format
 copying
Thread-Index: AQHY5/451EiH+HnXfEa/A4J+Y5Heda4flgoA
Date:   Tue, 25 Oct 2022 20:47:36 +0000
Message-ID: <754869a8f39d7b54380c3cc895ce37612c147ec7.camel@oracle.com>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
         <166664716290.2688790.11246233896801948595.stgit@magnolia>
In-Reply-To: <166664716290.2688790.11246233896801948595.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SA2PR10MB4426:EE_
x-ms-office365-filtering-correlation-id: 63b69ebc-3b22-4f76-26d6-08dab6ca2648
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ktrvxhW35jxP6Jb82acbcb3d5LgOiX982ZOC1zCGjggIR98MqIrTjH/UgzFJUJwDqNmvfSdLevUnmsNpFq1HQmxA1yQBt/oxEHm6YcIJxW6cmOhQhKONABLo084s8oIxiy+2qh9FRcbXxDV59vN0FnXrR1py4lX6n3qrJG4YuZTFimDw1tuBYN7ig+aa8k61lbT2WpgpBts5L1qMRIndGU0zqCAxk4RMtU3Q4cLAEdkBwZuuW81CPCK1ORAzmY8Klp8+n6ZO2PVJenUm5qOek6UnDezngGcaTk5bS858/2x5V8io0hxktki8pk27xVhag82c27qropZAuMCk9CZ6Sk0JEeJ+PLyFhEcg2YMYhHpF9+0dRsaES6mbzpxmJGI5K9AaBn+vQLbuM1KyjOwUWG9mkViHnyTLxAzqnRTKJhKot9Ei8LC7zlarP2tD4Fe4x+PV9VyNEyOFVZEnvsmYa/xdMqofIWLxr4sKu6aTks6vjPur0VtGM2RaKm9qzIrK23QuiGIaHBl8eMTGzAOVjASbyxvTM+qCkLnGi1vLaPva6k4zDLNGFBxviSwkel6LDcwmAaJTRszhUvi3r47wUJZaBnfi0sqJPWtg8/Njg7CUVyOEkGDOk2RK8CcTHKIz/qh519eBDD9shVE2D06L/mEL7Davy5b45QCKIdtVZBlAVLSoTp6nsqbGryHRLE9ZeO9HS1OzcubgwsJME1pf2bNLdIDrC5eOlDr9iJQCeYReVn6pr0wG/wp4JAHehchn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(83380400001)(38070700005)(86362001)(66556008)(38100700002)(8936002)(44832011)(122000001)(66946007)(66476007)(5660300002)(76116006)(4326008)(64756008)(41300700001)(8676002)(2906002)(186003)(6506007)(4001150100001)(26005)(2616005)(6512007)(36756003)(54906003)(6916009)(478600001)(66446008)(316002)(71200400001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3dNWTVjakR4UkljbjB2YnhLNGpTUlhnY1ZuRHQzYlUxcEFuMTlMS2FNc25r?=
 =?utf-8?B?VTR1OW5LUGNHemMwblBzZnMzZnFpckZkRFlkU1hBZXhpdEtKaEc1OXU5YmZx?=
 =?utf-8?B?a0pqanVvamlDZ1BYLzkxdWUva3FFN2Ztb3hLVUUySzVuNzNSYWlWZ2laQThP?=
 =?utf-8?B?ODFNZENHVS9aVmpsSWIrNUgvck9mcnhSK0JhOXd5a1VEOUQrSEZVczB3V1hF?=
 =?utf-8?B?M2RJM0Jnb0hkMnZyckt6bmxjdHdnbE92Q1VOeTNoQmd6bGdabFh3dVFlRjJh?=
 =?utf-8?B?d3FMcC9ySW9NbGMrR3ZXek12OUgwR3FWelA3RzJSSkFrOHk4THFSekRwcGJz?=
 =?utf-8?B?a1k0WkVNYm9Vd3AxOG04UDQ3a3puVy9Bd0RZVTVoMG9CcWF2UWxKOXo0R09Q?=
 =?utf-8?B?WDlna3NHZTg4ZjJLaFBQdUtHTHIxUUNydWZXdTVISk9GMDdtMXUvTFlxMFRa?=
 =?utf-8?B?azhBZld0dEZJSHRzYmJ4aUwxSCtEV2Uvb2Y2ck1VamkrUzRYVGMrV1pRb0xr?=
 =?utf-8?B?ODA3d0RzblJwUGdidVUxN0YzdVA2OFZYT0RlazJPUnl2WEFEbmhRYzg1R1Vs?=
 =?utf-8?B?cm5SMnhmbVNpeHdvaTJNdVFTS1QzS0lmT2hLQ1lITk1rM01YOE9sV0VscnQ5?=
 =?utf-8?B?MUQ0dTBPZmFQQ0dySjFEOUI3S3hvZlZhRjNGVXAwaUZBWnNBSDRRc3BoVGNI?=
 =?utf-8?B?NjBIRWtJVXNOSW5ObVcxZCsweHkrLzhpd2Y4bmxldlRzUG9YOXN3aGVOUDdW?=
 =?utf-8?B?Wm54bmc0VTVndnE0a1BkSEI4VzVXa3ZpK1RUeFB3WnZkd1VwdHNNM0lqMS81?=
 =?utf-8?B?bkQrMXJQbzJKTk1aNVNsZWUyMWJsMWVSTU9hMnM1MVhBYm4wODk5S0Rwdlg1?=
 =?utf-8?B?am0ycllWOTgvUmE2b251ZUp5TGFoVXRROHNjelNOYTBFMVdJeUNNL1dJMWhs?=
 =?utf-8?B?eW51QTJGeXF4aXVXdjRVMUJpMTZjaGFVNThoWHo5N01rRE9GeDdnOXkwY2o3?=
 =?utf-8?B?MHhyT1BKTzRDRm5CZk4zSHRsUDBxdHJnMm16UVBESkQwNVZTUk4zTUpaYitX?=
 =?utf-8?B?SExJY3hXenplMmEyNFBTOWduVlZBQkVOZDdZYXVWUVN6U0tEOUhhN2JtZWEw?=
 =?utf-8?B?NFN6NFN6NjhQd0lCeHl4cVM4OWJyOHJib1lqUFFOdFdJSElVWWdPN1dhS3ZK?=
 =?utf-8?B?S29oMEwxNXZSOFA0TzFndkJXc0p5Q29qS0MrK09OMkVKaVcrNlY2SUt1aXZK?=
 =?utf-8?B?QlNmNHVKdXFpclNkSUtjdWs5V2I1N0NSbFdxdHFXUFl0a3JIUTM3Rjh1ZC9u?=
 =?utf-8?B?UVVZazNsVkluS3BqRVBDRHlmMGNFYi9SKzRsTzhIVjhJWjBlUkdOdXdqb1U1?=
 =?utf-8?B?ODUyUEc3TEFoR0lXZCt6bWNTbkIwMDlOYkxMdmo1Y1ZtRWtQWno1U2k4Skdm?=
 =?utf-8?B?RmtQZ2Z4SnF3K3lvUVY0R09oRUVsLzB0N3NsYzhNUjdhbUgyTTRHdlBMUlBF?=
 =?utf-8?B?VWFVekhWNVhpdmNMaThPbDVpUnFGVkx1N0VRbUpJOG5FOGR2a2NtVUpUakFE?=
 =?utf-8?B?NEVXZ3l3YXQrWlVWUVF6MTEwWVlVNXpERzdNemhQbFlsaXlqbnNXVUhqVGVr?=
 =?utf-8?B?VTB4cFRQYVRydzF1eFpKQ1BOU0lBK1kzbUxJOUdxdkV0MlQ2S3NhSWIxSEl0?=
 =?utf-8?B?OGxCUnlUUm52ZUVsRFAvL3BOdkloWHgzUUpKZ0NzRSs3RzQyTEozSlZML1p0?=
 =?utf-8?B?WDNSU1JpQ1d6UXB2eVQ0THdYY3dhMHU5NWYrcjlGMVRZOGpkZDYrVnBId2Va?=
 =?utf-8?B?Ny83cTNFa0FMWkw0WncrbnZXcFhRdVVkYng5MFg1R3VjN0kzcGxuYXVtT0JX?=
 =?utf-8?B?Q3JIZUVMb2Z2YlY3bDNGWmJMNEVFNm1CYmVwVEJTYkEveHFtUlBOb1JtYjNz?=
 =?utf-8?B?a3dCaUFLVS85WjRQdkp2N0NEejdDMGxoM3RkLzh0bXlwVEVGN2pNVWtWT2sz?=
 =?utf-8?B?bEFXUHdpQy9keW5SUHlSajUxNWxRNVJaeE1hd1Z6djZwZ29GWS8zbjJSbU51?=
 =?utf-8?B?K240cU8vWEtQWE56QlFqUisvempZUHNuR2l3Wmpnc3VIRFFkS1VpK2ZJWEJD?=
 =?utf-8?B?em4xZXRMTEFMQUZQM2gxMGxPbEpIOVBZQjcrVnE1MEpic0NIV0ppTnJyYnZC?=
 =?utf-8?B?Tnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C712AEFAAE73A5409D5FB040DAD2A536@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b69ebc-3b22-4f76-26d6-08dab6ca2648
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 20:47:36.7789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fzF6+J9w4VMTRu+aGA7fYUglUVdyMZM/m4EDN7dgs9Ji+3FPJcVQL8/eX9CcfmeUIkF5Jl22SrtTBr3blsuuUubxrXErazYVPZShZD+lsqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250116
X-Proofpoint-GUID: 8mIGhe1GrRTmGES_pR4kWVIJ3wlQiRyj
X-Proofpoint-ORIG-GUID: 8mIGhe1GrRTmGES_pR4kWVIJ3wlQiRyj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTI0IGF0IDE0OjMyIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gRnJvbTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4KPiAKPiBTdGFydGlu
ZyBpbiA2LjEsIENPTkZJR19GT1JUSUZZX1NPVVJDRSBjaGVja3MgdGhlIGxlbmd0aCBwYXJhbWV0
ZXIgb2YKPiBtZW1jcHkuwqAgVW5mb3J0dW5hdGVseSwgaXQgZG9lc24ndCBoYW5kbGUgZmxleCBh
cnJheXMgY29ycmVjdGx5Ogo+IAo+IC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0t
LQo+IG1lbWNweTogZGV0ZWN0ZWQgZmllbGQtc3Bhbm5pbmcgd3JpdGUgKHNpemUgNDgpIG9mIHNp
bmdsZSBmaWVsZAo+ICJkc3RfYnVpX2ZtdCIgYXQgZnMveGZzL3hmc19ibWFwX2l0ZW0uYzo2Mjgg
KHNpemUgMTYpCj4gCj4gRml4IHRoaXMgYnkgcmVmYWN0b3JpbmcgdGhlIHhmc19idWlfY29weV9m
b3JtYXQgZnVuY3Rpb24gdG8gaGFuZGxlCj4gdGhlCj4gY29weWluZyBvZiB0aGUgaGVhZCBhbmQg
dGhlIGZsZXggYXJyYXkgbWVtYmVycyBzZXBhcmF0ZWx5LsKgIFdoaWxlCj4gd2UncmUKPiBhdCBp
dCwgZml4IGEgbWlub3IgdmFsaWRhdGlvbiBkZWZpY2llbmN5IGluIHRoZSByZWNvdmVyeSBmdW5j
dGlvbi4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwu
b3JnPgpPaywgbWFrZXMgc2Vuc2U6ClJldmlld2VkLWJ5OiBBbGxpc29uIEhlbmRlcnNvbiA8YWxs
aXNvbi5oZW5kZXJzb25Ab3JhY2xlLmNvbT4KPiAtLS0KPiDCoGZzL3hmcy94ZnNfYm1hcF9pdGVt
LmMgfMKgwqAgNDYgKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0KPiAtLS0t
LS0tLQo+IMKgZnMveGZzL3hmc19vbmRpc2suaMKgwqDCoCB8wqDCoMKgIDUgKysrKysKPiDCoDIg
ZmlsZXMgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKSwgMjQgZGVsZXRpb25zKC0pCj4gCj4gCj4g
ZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfYm1hcF9pdGVtLmMgYi9mcy94ZnMveGZzX2JtYXBfaXRl
bS5jCj4gaW5kZXggNTFmNjZlOTgyNDg0Li5hMWRhNjIwNTI1MmIgMTAwNjQ0Cj4gLS0tIGEvZnMv
eGZzL3hmc19ibWFwX2l0ZW0uYwo+ICsrKyBiL2ZzL3hmcy94ZnNfYm1hcF9pdGVtLmMKPiBAQCAt
NjA4LDI4ICs2MDgsMTggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB4ZnNfaXRlbV9vcHMKPiB4ZnNf
YnVpX2l0ZW1fb3BzID0gewo+IMKgwqDCoMKgwqDCoMKgwqAuaW9wX3JlbG9nwqDCoMKgwqDCoMKg
PSB4ZnNfYnVpX2l0ZW1fcmVsb2csCj4gwqB9Owo+IMKgCj4gLS8qCj4gLSAqIENvcHkgYW4gQlVJ
IGZvcm1hdCBidWZmZXIgZnJvbSB0aGUgZ2l2ZW4gYnVmLCBhbmQgaW50byB0aGUKPiBkZXN0aW5h
dGlvbgo+IC0gKiBCVUkgZm9ybWF0IHN0cnVjdHVyZS7CoCBUaGUgQlVJL0JVRCBpdGVtcyB3ZXJl
IGRlc2lnbmVkIG5vdCB0bwo+IG5lZWQgYW55Cj4gLSAqIHNwZWNpYWwgYWxpZ25tZW50IGhhbmRs
aW5nLgo+IC0gKi8KPiAtc3RhdGljIGludAo+ICtzdGF0aWMgaW5saW5lIHZvaWQKPiDCoHhmc19i
dWlfY29weV9mb3JtYXQoCj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19sb2dfaW92ZWPCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAqYnVmLAo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfYnVp
X2xvZ19mb3JtYXTCoMKgwqDCoMKgwqDCoCpkc3RfYnVpX2ZtdCkKPiArwqDCoMKgwqDCoMKgwqBz
dHJ1Y3QgeGZzX2J1aV9sb2dfZm9ybWF0wqDCoMKgwqDCoMKgwqAqZHN0LAo+ICvCoMKgwqDCoMKg
wqDCoGNvbnN0IHN0cnVjdCB4ZnNfYnVpX2xvZ19mb3JtYXTCoCpzcmMpCj4gwqB7Cj4gLcKgwqDC
oMKgwqDCoMKgc3RydWN0IHhmc19idWlfbG9nX2Zvcm1hdMKgwqDCoMKgwqDCoMKgKnNyY19idWlf
Zm10Owo+IC3CoMKgwqDCoMKgwqDCoHVpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGxlbjsKPiArwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBp
bnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaTsKPiDCoAo+IC3CoMKg
wqDCoMKgwqDCoHNyY19idWlfZm10ID0gYnVmLT5pX2FkZHI7Cj4gLcKgwqDCoMKgwqDCoMKgbGVu
ID0geGZzX2J1aV9sb2dfZm9ybWF0X3NpemVvZihzcmNfYnVpX2ZtdC0+YnVpX25leHRlbnRzKTsK
PiArwqDCoMKgwqDCoMKgwqBtZW1jcHkoZHN0LCBzcmMsIG9mZnNldG9mKHN0cnVjdCB4ZnNfYnVp
X2xvZ19mb3JtYXQsCj4gYnVpX2V4dGVudHMpKTsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoGlmIChi
dWYtPmlfbGVuID09IGxlbikgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtZW1j
cHkoZHN0X2J1aV9mbXQsIHNyY19idWlfZm10LCBsZW4pOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gMDsKPiAtwqDCoMKgwqDCoMKgwqB9Cj4gLcKgwqDCoMKgwqDCoMKg
WEZTX0VSUk9SX1JFUE9SVChfX2Z1bmNfXywgWEZTX0VSUkxFVkVMX0xPVywgTlVMTCk7Cj4gLcKg
wqDCoMKgwqDCoMKgcmV0dXJuIC1FRlNDT1JSVVBURUQ7Cj4gK8KgwqDCoMKgwqDCoMKgZm9yIChp
ID0gMDsgaSA8IHNyYy0+YnVpX25leHRlbnRzOyBpKyspCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoG1lbWNweSgmZHN0LT5idWlfZXh0ZW50c1tpXSwgJnNyYy0+YnVpX2V4dGVudHNb
aV0sCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgc2l6ZW9mKHN0cnVjdCB4ZnNfbWFwX2V4dGVudCkpOwo+IMKgfQo+IMKgCj4g
wqAvKgo+IEBAIC02NDYsMjMgKzYzNiwzMSBAQCB4bG9nX3JlY292ZXJfYnVpX2NvbW1pdF9wYXNz
MigKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhsb2dfcmVjb3Zlcl9pdGVtwqDCoMKgwqDCoMKg
wqDCoCppdGVtLAo+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfbHNuX3TCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbHNuKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoGlu
dMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBlcnJvcjsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgKm1wID0gbG9nLT5sX21wOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgeGZzX2J1aV9sb2dfaXRlbcKgwqDCoMKgwqDCoMKgwqDCoCpidWlwOwo+IMKgwqDCoMKgwqDC
oMKgwqBzdHJ1Y3QgeGZzX2J1aV9sb2dfZm9ybWF0wqDCoMKgwqDCoMKgwqAqYnVpX2Zvcm1hdHA7
Cj4gK8KgwqDCoMKgwqDCoMKgc2l6ZV90wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGxlbjsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBidWlfZm9ybWF0
cCA9IGl0ZW0tPnJpX2J1ZlswXS5pX2FkZHI7Cj4gwqAKPiArwqDCoMKgwqDCoMKgwqBpZiAoaXRl
bS0+cmlfYnVmWzBdLmlfbGVuIDwgeGZzX2J1aV9sb2dfZm9ybWF0X3NpemVvZigwKSkgewo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBYRlNfRVJST1JfUkVQT1JUKF9fZnVuY19fLCBY
RlNfRVJSTEVWRUxfTE9XLCBsb2ctCj4gPmxfbXApOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gLUVGU0NPUlJVUFRFRDsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gKwo+IMKg
wqDCoMKgwqDCoMKgwqBpZiAoYnVpX2Zvcm1hdHAtPmJ1aV9uZXh0ZW50cyAhPSBYRlNfQlVJX01B
WF9GQVNUX0VYVEVOVFMpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFhGU19F
UlJPUl9SRVBPUlQoX19mdW5jX18sIFhGU19FUlJMRVZFTF9MT1csIGxvZy0KPiA+bF9tcCk7Cj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVGU0NPUlJVUFRFRDsKPiDC
oMKgwqDCoMKgwqDCoMKgfQo+ICsKPiArwqDCoMKgwqDCoMKgwqBsZW4gPSB4ZnNfYnVpX2xvZ19m
b3JtYXRfc2l6ZW9mKGJ1aV9mb3JtYXRwLT5idWlfbmV4dGVudHMpOwo+ICvCoMKgwqDCoMKgwqDC
oGlmIChpdGVtLT5yaV9idWZbMF0uaV9sZW4gIT0gbGVuKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoFhGU19FUlJPUl9SRVBPUlQoX19mdW5jX18sIFhGU19FUlJMRVZFTF9MT1cs
IGxvZy0KPiA+bF9tcCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAt
RUZTQ09SUlVQVEVEOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiArCj4gwqDCoMKgwqDCoMKgwqDCoGJ1
aXAgPSB4ZnNfYnVpX2luaXQobXApOwo+IC3CoMKgwqDCoMKgwqDCoGVycm9yID0geGZzX2J1aV9j
b3B5X2Zvcm1hdCgmaXRlbS0+cmlfYnVmWzBdLCAmYnVpcC0KPiA+YnVpX2Zvcm1hdCk7Cj4gLcKg
wqDCoMKgwqDCoMKgaWYgKGVycm9yKSB7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHhmc19idWlfaXRlbV9mcmVlKGJ1aXApOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gZXJyb3I7Cj4gLcKgwqDCoMKgwqDCoMKgfQo+ICvCoMKgwqDCoMKgwqDCoHhmc19i
dWlfY29weV9mb3JtYXQoJmJ1aXAtPmJ1aV9mb3JtYXQsIGJ1aV9mb3JtYXRwKTsKPiDCoMKgwqDC
oMKgwqDCoMKgYXRvbWljX3NldCgmYnVpcC0+YnVpX25leHRfZXh0ZW50LCBidWlfZm9ybWF0cC0K
PiA+YnVpX25leHRlbnRzKTsKPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiDCoMKgwqDCoMKgwqDCoMKg
ICogSW5zZXJ0IHRoZSBpbnRlbnQgaW50byB0aGUgQUlMIGRpcmVjdGx5IGFuZCBkcm9wIG9uZQo+
IHJlZmVyZW5jZSBzbwo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX29uZGlzay5oIGIvZnMveGZz
L3hmc19vbmRpc2suaAo+IGluZGV4IDc1ODcwMmI5NDk1Zi4uNTY5MTdlMjM2MzcwIDEwMDY0NAo+
IC0tLSBhL2ZzL3hmcy94ZnNfb25kaXNrLmgKPiArKysgYi9mcy94ZnMveGZzX29uZGlzay5oCj4g
QEAgLTEzNCw2ICsxMzQsMTEgQEAgeGZzX2NoZWNrX29uZGlza19zdHJ1Y3RzKHZvaWQpCj4gwqDC
oMKgwqDCoMKgwqDCoFhGU19DSEVDS19TVFJVQ1RfU0laRShzdHJ1Y3QgeGZzX3RyYW5zX2hlYWRl
cizCoMKgwqDCoMKgwqDCoMKgwqDCoDE2KTsKPiDCoMKgwqDCoMKgwqDCoMKgWEZTX0NIRUNLX1NU
UlVDVF9TSVpFKHN0cnVjdCB4ZnNfYXR0cmlfbG9nX2Zvcm1hdCzCoMKgwqDCoMKgwqA0MCk7Cj4g
wqDCoMKgwqDCoMKgwqDCoFhGU19DSEVDS19TVFJVQ1RfU0laRShzdHJ1Y3QgeGZzX2F0dHJkX2xv
Z19mb3JtYXQswqDCoMKgwqDCoMKgMTYpOwo+ICvCoMKgwqDCoMKgwqDCoFhGU19DSEVDS19TVFJV
Q1RfU0laRShzdHJ1Y3QgeGZzX2J1aV9sb2dfZm9ybWF0LMKgwqDCoMKgwqDCoMKgwqAxNik7Cj4g
K8KgwqDCoMKgwqDCoMKgWEZTX0NIRUNLX1NUUlVDVF9TSVpFKHN0cnVjdCB4ZnNfYnVkX2xvZ19m
b3JtYXQswqDCoMKgwqDCoMKgwqDCoDE2KTsKPiArwqDCoMKgwqDCoMKgwqBYRlNfQ0hFQ0tfU1RS
VUNUX1NJWkUoc3RydWN0IHhmc19tYXBfZXh0ZW50LMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDMy
KTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgWEZTX0NIRUNLX09GRlNFVChzdHJ1Y3QgeGZzX2J1aV9s
b2dfZm9ybWF0LAo+IGJ1aV9leHRlbnRzLMKgwqDCoMKgwqDCoMKgwqAxNik7Cj4gwqAKPiDCoMKg
wqDCoMKgwqDCoMKgLyoKPiDCoMKgwqDCoMKgwqDCoMKgICogVGhlIHY1IHN1cGVyYmxvY2sgZm9y
bWF0IGV4dGVuZGVkIHNldmVyYWwgdjQgaGVhZGVyCj4gc3RydWN0dXJlcyB3aXRoCj4gCgo=
