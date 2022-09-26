Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E5DC07E9D
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Sep 2022 21:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiIZVsz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiIZVsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2022 17:48:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BBFAF0E2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 14:48:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QKmw6o005424;
        Mon, 26 Sep 2022 21:48:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=zMNfTDZrJOxbynpHnAzwwj/cYbcjnGY83ET0g+reVuE=;
 b=OoMR1jsgKSlnyJNaAK9atFCIdqEGnUjkrBoJGJzbcbRoqW6eKK6QNv/M6lhBinuaYSTm
 8P+stkP2OFC14zlCgPzs0uyxo3ZbLRGHKY1sXKvkjeh/dR+6CrGpbrR6UHPP7y+l+bdN
 nMybgieoEzk/BrxXjZzVp69jUhkk2OuvsSrvt6BoGsUMi6/JbsLvju01toa1PTiRbKSq
 jNaypAHAExu0XulsF7UqzsozdgIZi+J6r77W3IP9CXVS3IS+OCUXtMyQ7jYLNyYeM0nX
 1lrDJCjCemh657FreyOkCjSW8RpKXiRyjU4yWOwojc+6vKsKMK7jwryYgvCwaoDXhQYK 7g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0kmurs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:48:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28QKiQBc019213;
        Mon, 26 Sep 2022 21:48:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpvdnf89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:48:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFGYZqXeHTvxD7IfN+1xrGDH6JR49jSL8yOiPZ5JrNuD2p9cqij/XwGRklbA+NKR1tUYqjVSgbyoUbZrUho2TtRAXwwadhQD+L7zBVWT4t26EQZ6OJsB+9BErWdKbaNKDvwq6qkrG+Y96NttDcid+9BruruSf+r5HeHR3bnAloofSehJTszMbx4RSp1HgSoajglL2B3QePRkAvrQU+J/k/Ri49UZu0TmSCNtAJHqoP4OnhilcHdsjOPge3J2w6VEBduIVWHgRFF9+Ayjhh63yfgOYM/vfLPRjVJ+py8OJ1E7DsQrDHWLOBJ6sF+BA47uYyjyWWbSBVFGBr+JjT1Ltg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMNfTDZrJOxbynpHnAzwwj/cYbcjnGY83ET0g+reVuE=;
 b=eT3UUFv3EQti/l7UPYHhMWS1o1DJVW9PJKV7d0sFCKfb6AZlFsVSiGBAMqyaxjdx9Gj0wvxlAnCoAIB6JLA9WMITEluHCmD6Rf5OjDcFEgb6gz8VSAZ0lMzMNlHo5xQibLmRW2lY+VU4IKH7JM6/hbyxJChnkWIPO610DVnKBPYPxNI3k9TxUJ56Z4pLi9As6HxWltoATZF2TcIWVQq8BPQxbf5LskqLLp0mX7OmAxf2hkdv8awka3kVKaZ0FFOUCFVFZIYhMcvBktQ+6M6e5XQOjYzhYZyiQC+iMBwfzgY3dP7LsTabAr2QK6GxqZE/seAalrZpam/XbRHRr2jB4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMNfTDZrJOxbynpHnAzwwj/cYbcjnGY83ET0g+reVuE=;
 b=gC59hE/jmZJ0HW+iI3k6DHh3K9V/fV5jFtfePPEVnw7VHO4vFlS2FlovdjtKW6SKSrZxpIC+aRYcqgL4jQxEIngc7KHfTWHp2CKH9tJqyP4EK0GiNUYCGU1sunB2cadltv2yyMhE410EPxVjG1nzKROmtkdjkEC2qWJjq6KjEeI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4689.namprd10.prod.outlook.com (2603:10b6:303:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 26 Sep
 2022 21:48:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 21:48:46 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 16/26] xfs: add parent attributes to symlink
Thread-Topic: [PATCH v3 16/26] xfs: add parent attributes to symlink
Thread-Index: AQHYzkaCEfj7nhDe5kWMfEH2roaaIq3thtKAgATAIYA=
Date:   Mon, 26 Sep 2022 21:48:46 +0000
Message-ID: <20d666edf57d4168ce915c2737d248f7bdabbcec.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-17-allison.henderson@oracle.com>
         <Yy4iE7B4cGo2wwPH@magnolia>
In-Reply-To: <Yy4iE7B4cGo2wwPH@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CO1PR10MB4689:EE_
x-ms-office365-filtering-correlation-id: cf831965-bf52-4650-a185-08daa008e37f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NBEiyJd8O/gKn0xt6VlORY2r9+rRjv7Y+V3QOj0d6vXw96gOLG/J5n5VY9FXaxq3ycZpj7nFuTsA2063nD4uov3Y40LqfIW9ZMjzjsyAjkVDrbWdNIseY9uJkksEuBbBlrT73HmOAdFeArjgei8TSSKkq6pmb9NqixrzwCCm25aKt1/QKAvPE7JFHdYRmEELvUdFiJFkzSEe44rGJP9vqHh4KAFj5f4+DgbJtkYsDXg0d/afG75wt+pofdWjvtKuFeeHD7z/b5HFQFbKn+HIsOyEDaNazmpcL00fPIZKRX3hh+5wnzc912QEHVeVMABKb/4hj5kaPtsf/S38GsCI34Tqqj7fLlBqyYhIRMxJmB2cmOWVWdI7C9BivRS6jfedPW9cWkTy8YWWqmeI0eQBD6zX8QP7ND0Kf0Odyg6h7yCPYmFWhFm3Kn3gHGPKqpgZqJmoVCpcEdILg3ZC/gpaNBuMFQceGrUXIuhqRUNPFPcJdSM6FM5tH1/+MVjv16OUTe6UNG8qSjSbQf59qnw1Qx/7u4M+WgtPQZEezCzxQxCVXmf92YuBNzbaHH9mNhPsBDacPKY26CXo/x8srh8jQlDSEqXdAOYbYU+ymszH/HizGuy3gVRdBzjJX21uO0h4llA/SeED8SZjcVgPYFQcOYJRlSXDmRTbzc9AyZc3If5OiWRqjB70HSRTpIoxJhPayScVOnoSM8Ox/iGfAWXaLACVlz5yHLuoh4b2pAUBQ3i390kGD9mKfbMeShwWSYel7d308duf2Bu2AcR5pm0Nyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199015)(122000001)(2616005)(36756003)(2906002)(186003)(86362001)(44832011)(8936002)(38070700005)(6512007)(64756008)(66446008)(66476007)(66556008)(41300700001)(26005)(4326008)(8676002)(66946007)(76116006)(5660300002)(83380400001)(316002)(6506007)(6916009)(478600001)(6486002)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmlHeW5QV2lPT2NXSlc2a0VxdUt3dFo4MVZTYTJQa0Zlb2hqZVZoc0d4ODZY?=
 =?utf-8?B?RHpRMVJ1ZmUxUXJrZDdiUEtkaHFZR0FPNVRJQ21qWHZaZlI3TGdRYmQ3ZTJV?=
 =?utf-8?B?OWxnaWZQbFdYTk5kV1ZEaGhaRHhEbTFqL1Jsa0owMjdqazBQQkhPc0ZwZU5n?=
 =?utf-8?B?RGNwelNIV05Id2loeUdEZ0w0Nm91eWIxaVRoTlJCcm0zTHFGZlRVNHVlVWJG?=
 =?utf-8?B?cUtIaHZFZUZFZ0h6UnBpcCtmUTJJaVpFRCtyUmcyNjJDUWRKc1Bpa2w5Nlpt?=
 =?utf-8?B?VUNOUUFPcG85ZFRwRUw4VVJDUDQzS05ZQlJEVFlIYk5pSS9xR2cwZ3VxTWRj?=
 =?utf-8?B?K2VJSG9MWFFMTWFUTjVpTWtUMjY2QVZqZjZSSHVxNVlLMkNYWVFiM0REYVly?=
 =?utf-8?B?NTFpMDZMZ0p4NzBBRFdtd3doakpaMDV4ZlprVlFZNy82ME5sZkRIY29EZDRR?=
 =?utf-8?B?N3dXbi92aEtoU05helBTT1VYTVFnSjB6QmRXb2duK3ZDSXpMb1lVMDlrS0M4?=
 =?utf-8?B?OG83dE5CU1d4K0JCeExYS3ZXODRaa1R1L2llWjZ4N21aV1FNT1M4T0c0aEVk?=
 =?utf-8?B?KzNSbnV4d0dQdHRSRzZLVUwxNklZeFZ5THZobGZ2QzFVS2hQV01VV05FT0h4?=
 =?utf-8?B?Rmg1MWd4QWRoVnlodFFITU5Dd2RKQ0JKRW92NkFPdXl3UUFHNUFnOE04a1hU?=
 =?utf-8?B?Z0ZabFo0ZVg5ZTZ3eTdRaU9QRk1UOU14ZE5nNVJyb1lPREMrRyszbmJTaG54?=
 =?utf-8?B?emdRamVuTDRMT0cyZkNnaEkwRkkveHlqKzEvT2wxN3FuL2p1ellqVDF3RDB3?=
 =?utf-8?B?NGdVZUlOam1mcmQzQzN5cGUvWXY2TXBGY0x6T244eVZXOWloSlFsYTc1eGJh?=
 =?utf-8?B?OThPMVB4clRnRGVidFJkQnJ0VTViNHl0OHNsQldIOUFvY1lGK0dIYUxPTDVi?=
 =?utf-8?B?QmViYW5SUWpzSWRRMWVrYVNnRm1KNmRJK0dHbkNpWWYyb3RheURiTnFDMGdv?=
 =?utf-8?B?YXR6L0Jsei9Pdk5McGR6ZXVRaW92dThZV29MRFY5ZVRBdU5lQlBYUXpsTzZw?=
 =?utf-8?B?Vk1MTUhZS0sxUFNnNEpBRjU3NlM1aUdMMHhkbVBTVk9rSWxUUFdSM3JqZlcr?=
 =?utf-8?B?aUxrenluOEZGRnIvZEE2Ky9teHJRWmFzWFRzNkNNRjF3NjgwMERrTlFiNXcz?=
 =?utf-8?B?M21ocWQzTnNIUEwwRFV3U09YYlNyWE5Vc2NUbGRqallTVWIrd1ViQjdjeVZp?=
 =?utf-8?B?YUpXcGNhM1M0aHBnUnBnaEEvSm9INUUyRnlJWU4zUDY3cjVjbFVRNTEwaVBz?=
 =?utf-8?B?RklaRzVxeG9XY1BNN2d2Vy9OMlVBejAxeUhOMXFkRDh2a3U1aElHejNkMnNy?=
 =?utf-8?B?K1JCeVZpeGoxOFFXaiticlcyMFF5VmM1TWNXRmE3NU9mejdSZ0FlcUlUWXpM?=
 =?utf-8?B?enA3L3BWcy9rZktFNEdpalIvRXN5WnNCRC9DbUFIcEp6ZzhxT2pNQ3V6U3pP?=
 =?utf-8?B?YzRsMHlXRlZ6M1N5MUZhVzloeitpaXFhYnAwNnRxZjFoeXVEUnBBRzk5R3po?=
 =?utf-8?B?bjU2VHhDUVMraW5EVVMxTnM0ZjJhdjFpcEkzRS9uVjVTcUhoVm5tTHpFeGRV?=
 =?utf-8?B?S21lcmw4Zy9GQjVMSUlCajN1cUZHbDVURjRYU0MrZG54WThYeCtHT1BiZmRn?=
 =?utf-8?B?WW5lc0pNenloWnFEUGVPNjM2OFAvVnorTkl1ejUzd05sMUs1RWhtcVRtamN4?=
 =?utf-8?B?dlpQUDNyN0N3SjdaL0UrMnYzUHBoankvOGZGUzloblZKb0kwNFBCTnVJQWF3?=
 =?utf-8?B?bUF1QkVJMk9SWE9KTXRhNmIwYWVvdTZZNDJ5Yll4UitPSVF5SGJYdG5XZCtZ?=
 =?utf-8?B?R25QU1p5MHoxcGdhampOZVRxNTEzNm1XWFpPM3JiRGVVakZ4NVVJUUlEVjVz?=
 =?utf-8?B?Z1J0bENoTVJOZWc3bUxwR2UzRDVUTjlxb3VUZ05kb3p0U3B2dFpXTEhNbURJ?=
 =?utf-8?B?VzZuWnhaVEtqaW84cG5VSEp3YWZoS3c4ZkpDVlFETE9ZY1BacGo1WmhxVGRh?=
 =?utf-8?B?L25RSjFBZ3VPWStGN1U2RE1XeTA4RDRLai9CSTYvTkozcTNTUmNvaithOWsw?=
 =?utf-8?B?elp2YmZOaEVYdUxqYWZPNzQvYWMyNEdycUVucVgxUEwzTzFSQzllSlY5Tkd4?=
 =?utf-8?B?S3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6112C921BD2E4041995F97F5F221657E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf831965-bf52-4650-a185-08daa008e37f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 21:48:46.3165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lZPSvVxJno0/hcvB/+BdXoboSMmzLZztx9RbgFU+hFfeT6E5hub/o+p5PWFlH8NQlgDxKXCNls+BNYyUU/Mw5uS5z1bogSgYAHgJr3AHXYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_10,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260134
X-Proofpoint-GUID: ASI7X-4XXsrmD2kcW1qRSixCkO6dLuqD
X-Proofpoint-ORIG-GUID: ASI7X-4XXsrmD2kcW1qRSixCkO6dLuqD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDE0OjE2IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMTA6NDQ6NDhQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+ID4gCj4gPiBUaGlzIHBhdGNoIG1vZGlmaWVz
IHhmc19zeW1saW5rIHRvIGFkZCBhIHBhcmVudCBwb2ludGVyIHRvIHRoZQo+ID4gaW5vZGUuCj4g
PiAKPiA+IFNpZ25lZC1vZmYtYnk6IEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNv
bkBvcmFjbGUuY29tPgo+IAo+IE9vaCwgYSBuZXcgcGF0Y2guCj4gCj4gPiAtLS0KPiA+IMKgZnMv
eGZzL3hmc19zeW1saW5rLmMgfCAzMSArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tCj4g
PiDCoDEgZmlsZSBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQo+ID4g
Cj4gPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19zeW1saW5rLmMgYi9mcy94ZnMveGZzX3N5bWxp
bmsuYwo+ID4gaW5kZXggMjdhN2Q3YzU3MDE1Li4xNDA3OTM2NzMzNWIgMTAwNjQ0Cj4gPiAtLS0g
YS9mcy94ZnMveGZzX3N5bWxpbmsuYwo+ID4gKysrIGIvZnMveGZzL3hmc19zeW1saW5rLmMKPiA+
IEBAIC0yMyw2ICsyMyw4IEBACj4gPiDCoCNpbmNsdWRlICJ4ZnNfdHJhbnMuaCIKPiA+IMKgI2lu
Y2x1ZGUgInhmc19pYWxsb2MuaCIKPiA+IMKgI2luY2x1ZGUgInhmc19lcnJvci5oIgo+ID4gKyNp
bmNsdWRlICJ4ZnNfcGFyZW50LmgiCj4gPiArI2luY2x1ZGUgInhmc19kZWZlci5oIgo+ID4gwqAK
PiA+IMKgLyogLS0tLS0gS2VybmVsIG9ubHkgZnVuY3Rpb25zIGJlbG93IC0tLS0tICovCj4gPiDC
oGludAo+ID4gQEAgLTE3Miw2ICsxNzQsOCBAQCB4ZnNfc3ltbGluaygKPiA+IMKgwqDCoMKgwqDC
oMKgwqBzdHJ1Y3QgeGZzX2RxdW90wqDCoMKgwqDCoMKgwqDCoCpwZHFwID0gTlVMTDsKPiA+IMKg
wqDCoMKgwqDCoMKgwqB1aW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHJlc2Jsa3M7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgeGZzX2lub190wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgaW5vOwo+ID4gK8KgwqDCoMKgwqDCoMKgeGZzX2RpcjJfZGF0YXB0cl90wqDC
oMKgwqDCoCBkaXJvZmZzZXQ7Cj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3BhcmVudF9k
ZWZlciAqcGFyZW50ID0gTlVMTDsKPiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgKmlwcCA9IE5V
TEw7Cj4gPiDCoAo+ID4gQEAgLTE3OSwxMCArMTgzLDEwIEBAIHhmc19zeW1saW5rKAo+ID4gwqAK
PiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoeGZzX2lzX3NodXRkb3duKG1wKSkKPiA+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FSU87Cj4gPiAtCj4gPiDCoMKgwqDCoMKg
wqDCoMKgLyoKPiA+IMKgwqDCoMKgwqDCoMKgwqAgKiBDaGVjayBjb21wb25lbnQgbGVuZ3RocyBv
ZiB0aGUgdGFyZ2V0IHBhdGggbmFtZS4KPiA+IMKgwqDCoMKgwqDCoMKgwqAgKi8KPiA+ICsKPiA+
IMKgwqDCoMKgwqDCoMKgwqBwYXRobGVuID0gc3RybGVuKHRhcmdldF9wYXRoKTsKPiA+IMKgwqDC
oMKgwqDCoMKgwqBpZiAocGF0aGxlbiA+PSBYRlNfU1lNTElOS19NQVhMRU4pwqDCoMKgwqDCoCAv
KiB0b3RhbCBzdHJpbmcgdG9vCj4gPiBsb25nICovCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiAtRU5BTUVUT09MT05HOwo+ID4gQEAgLTIwNCwxMiArMjA4LDE4IEBA
IHhmc19zeW1saW5rKAo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqIFRoZSBzeW1saW5rIHdpbGwgZml0
IGludG8gdGhlIGlub2RlIGRhdGEgZm9yaz8KPiA+IMKgwqDCoMKgwqDCoMKgwqAgKiBUaGVyZSBj
YW4ndCBiZSBhbnkgYXR0cmlidXRlcyBzbyB3ZSBnZXQgdGhlIHdob2xlCj4gPiB2YXJpYWJsZSBw
YXJ0Lgo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqLwo+ID4gLcKgwqDCoMKgwqDCoMKgaWYgKHBhdGhs
ZW4gPD0gWEZTX0xJVElOTyhtcCkpCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAocGF0aGxlbiA8PSBY
RlNfTElUSU5PKG1wKSAmJiAheGZzX2hhc19wYXJlbnQobXApKQo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBmc19ibG9ja3MgPSAwOwo+ID4gwqDCoMKgwqDCoMKgwqDCoGVsc2UK
PiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZnNfYmxvY2tzID0geGZzX3N5bWxp
bmtfYmxvY2tzKG1wLCBwYXRobGVuKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqByZXNibGtzID0gWEZT
X1NZTUxJTktfU1BBQ0VfUkVTKG1wLCBsaW5rX25hbWUtPmxlbiwKPiA+IGZzX2Jsb2Nrcyk7Cj4g
Cj4gU2FtZSBjb21tZW50IGFzIHRoZSBsYXN0IHR3byBwYXRjaGVzOiBQbGVhc2UgdXBkYXRlCj4g
eGZzX3N5bWxpbmtfc3BhY2VfcmVzIHRvIGhhbmRsZSB0aGUgZnJlZSBzcGFjZSB0aGF0IG1pZ2h0
IGJlIG5lZWRlZAo+IHRvCj4gZXhwYW5kIHRoZSB4YXR0ciBzdHJ1Y3R1cmUgb25kaXNrOgo+IAo+
IHVuc2lnbmVkIGludAo+IHhmc19zeW1saW5rX3NwYWNlX3JlcygKPiDCoMKgwqDCoMKgwqDCoMKg
c3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDCoMKgwqAqbXAsCj4gwqDCoMKgwqDCoMKgwqDCoHVu
c2lnbmVkIGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5hbWVsZW4sCj4gwqDCoMKgwqDCoMKg
wqDCoHVuc2lnbmVkIGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZzYmxvY2tzKQo+IHsKPiDC
oMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0Owo+
IAo+IMKgwqDCoMKgwqDCoMKgwqByZXQgPSBYRlNfSUFMTE9DX1NQQUNFX1JFUyhtcCkgKwo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFhGU19ESVJFTlRFUl9TUEFDRV9SRVMobXAsIG5hbWVs
ZW4pICsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmc2Jsb2NrczsKPiAKPiDCoMKgwqDC
oMKgwqDCoMKgaWYgKHhmc19oYXNfcGFyZW50KG1wKSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldCArPSB4ZnNfcHB0cl9jYWxjX3NwYWNlX3JlcyhtcCwgbmFtZWxlbik7Cj4g
Cj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiByZXQ7Cj4gfQo+IAo+IEV2ZXJ5dGhpbmcgZWxzZSBp
biBoZXJlIG90aGVyd2lzZSBsb29rcyBnb29kIHRvIG1lLgpBbHJpZ2h0eSwgd2lsbCBhZGQuICBU
aGFua3MhCgo+IAo+IC0tRAo+IAo+ID4gwqAKPiA+ICvCoMKgwqDCoMKgwqDCoGlmICh4ZnNfaGFz
X3BhcmVudChtcCkpIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9
IHhmc19wYXJlbnRfaW5pdChtcCwgJnBhcmVudCk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgaWYgKGVycm9yKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gZXJyb3I7Cj4gPiArwqDCoMKgwqDCoMKgwqB9Cj4gPiArCj4g
PiDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfdHJhbnNfYWxsb2NfaWNyZWF0ZShtcCwgJk1f
UkVTKG1wKS0+dHJfc3ltbGluaywKPiA+IHVkcXAsIGdkcXAsCj4gPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwZHFwLCByZXNibGtzLCAmdHApOwo+ID4g
wqDCoMKgwqDCoMKgwqDCoGlmIChlcnJvcikKPiA+IEBAIC0yMzMsNyArMjQzLDcgQEAgeGZzX3N5
bWxpbmsoCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFlcnJvcikKPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfaW5pdF9uZXdfaW5vZGUobW50X3VzZXJucywg
dHAsIGRwLCBpbm8sCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgU19JRkxOSyB8IChtb2RlICYgflNfSUZNVCksIDEsIDAs
Cj4gPiBwcmlkLAo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgZmFsc2UsICZpcCk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfaGFzX3BhcmVu
dChtcCksICZpcCk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycm9yKQo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dF90cmFuc19jYW5jZWw7Cj4gPiDCoAo+ID4g
QEAgLTMxNSwxMiArMzI1LDIwIEBAIHhmc19zeW1saW5rKAo+ID4gwqDCoMKgwqDCoMKgwqDCoCAq
IENyZWF0ZSB0aGUgZGlyZWN0b3J5IGVudHJ5IGZvciB0aGUgc3ltbGluay4KPiA+IMKgwqDCoMKg
wqDCoMKgwqAgKi8KPiA+IMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19kaXJfY3JlYXRlbmFt
ZSh0cCwgZHAsIGxpbmtfbmFtZSwKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgaXAtPmlfaW5vLCByZXNibGtzLCBOVUxMKTsKPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaXAtPmlfaW5vLCByZXNibGtzLCAm
ZGlyb2Zmc2V0KTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3RyYW5zX2NhbmNlbDsKPiA+IMKgwqDCoMKg
wqDCoMKgwqB4ZnNfdHJhbnNfaWNoZ3RpbWUodHAsIGRwLCBYRlNfSUNIR1RJTUVfTU9EIHwKPiA+
IFhGU19JQ0hHVElNRV9DSEcpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoHhmc190cmFuc19sb2dfaW5v
ZGUodHAsIGRwLCBYRlNfSUxPR19DT1JFKTsKPiA+IMKgCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAo
cGFyZW50KSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNf
cGFyZW50X2RlZmVyX2FkZCh0cCwgcGFyZW50LCBkcCwKPiA+IGxpbmtfbmFtZSwKPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkaXJvZmZzZXQsIGlwKTsKPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3RyYW5zX2NhbmNlbDsKPiA+ICvCoMKg
wqDCoMKgwqDCoH0KPiA+ICsKPiA+ICsKPiA+IMKgwqDCoMKgwqDCoMKgwqAvKgo+ID4gwqDCoMKg
wqDCoMKgwqDCoCAqIElmIHRoaXMgaXMgYSBzeW5jaHJvbm91cyBtb3VudCwgbWFrZSBzdXJlIHRo
YXQgdGhlCj4gPiDCoMKgwqDCoMKgwqDCoMKgICogc3ltbGluayB0cmFuc2FjdGlvbiBnb2VzIHRv
IGRpc2sgYmVmb3JlIHJldHVybmluZyB0bwo+ID4gQEAgLTM0NCw2ICszNjIsOCBAQCB4ZnNfc3lt
bGluaygKPiA+IMKgb3V0X3RyYW5zX2NhbmNlbDoKPiA+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfdHJh
bnNfY2FuY2VsKHRwKTsKPiA+IMKgb3V0X3JlbGVhc2VfaW5vZGU6Cj4gPiArwqDCoMKgwqDCoMKg
wqB4ZnNfZGVmZXJfY2FuY2VsKHRwKTsKPiA+ICsKPiA+IMKgwqDCoMKgwqDCoMKgwqAvKgo+ID4g
wqDCoMKgwqDCoMKgwqDCoCAqIFdhaXQgdW50aWwgYWZ0ZXIgdGhlIGN1cnJlbnQgdHJhbnNhY3Rp
b24gaXMgYWJvcnRlZCB0bwo+ID4gZmluaXNoIHRoZQo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqIHNl
dHVwIG9mIHRoZSBpbm9kZSBhbmQgcmVsZWFzZSB0aGUgaW5vZGUuwqAgVGhpcyBwcmV2ZW50cwo+
ID4gcmVjdXJzaXZlCj4gPiBAQCAtMzYyLDYgKzM4Miw5IEBAIHhmc19zeW1saW5rKAo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfaXVubG9jayhkcCwgWEZTX0lMT0NLX0VY
Q0wpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChpcCkKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgeGZzX2l1bmxvY2soaXAsIFhGU19JTE9DS19FWENMKTsKPiA+ICvCoMKgwqDC
oMKgwqDCoGlmIChwYXJlbnQpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGZz
X3BhcmVudF9jYW5jZWwobXAsIHBhcmVudCk7Cj4gPiArCj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0
dXJuIGVycm9yOwo+ID4gwqB9Cj4gPiDCoAo+ID4gLS0gCj4gPiAyLjI1LjEKPiA+IAoK
