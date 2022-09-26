Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9B7C6FA82
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Sep 2022 21:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiIZVtV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiIZVtS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2022 17:49:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61F7B07CD
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 14:49:17 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QKr9en012824;
        Mon, 26 Sep 2022 21:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jNnqi3eqLEk4cn14YBEPIr7ldWVz/kZ8m/kplEQ87Lo=;
 b=1KwqGJVp86cwEeyXvbmiclg5LiulQ9PW+/aYR2E4YQvqIAsqWCzfea/i/cBe+9Ie5mWC
 7xz6rb/b/WhX1X7zj6Ns5tEEwfB+sPsVS0ztIZ+4Mt/ZUofi/YieK3qWtNiFskAU0GYZ
 NRjMFRUI7yZudnQPNnNlNXJSgDowspL5j6nc+UL4OJIzqs6yqKznVBfOB47iSjFg/Q82
 Doj5Wcawb6Mdf8k1PWkEvS06fD6dojP4Rno022PwYyBdWfPXofZPoQ++w0Vjm01VsS47
 au/Jo3K8kzhhyR8GyVdNT/g+KEMGIg8t/ouCc4YAJEoHXVamJzIsAfpslDw1tC/qRt9F Rg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssubcy5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:49:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28QJFNbx028154;
        Mon, 26 Sep 2022 21:49:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps4n6cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:49:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKAqHJUiAubqk4le11qh5dtAPFBaJmjUdAyCuyCF6Ga22JzVOHrNJKUBQvVWbAwwJS/uv4HsniHEIfXHgTDWpxMCkGg0iyeHA9GbCtfANSuN/otcg2I1+jOXIudFuFIXjeBW3qW8S7vMazcglgmKngSKK+mmUDt+exEM7zci60n0Ew284xZ3K84ZA/jBsGP3KnS058qgxtpCrnfDD2QMuL88V+eEknH4d0lqvPk4YEh7YbxUdQCEBqGG8Ct0+ISKYidN8ReeJynZSfRY3JgKDUVFI39vTvxeTANNcAnf9rTxV7oN1rgnYaUq6+UIFuN+xKlmYA40HifjikfkGhno0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNnqi3eqLEk4cn14YBEPIr7ldWVz/kZ8m/kplEQ87Lo=;
 b=ARvXxNzoLE8tTH4FD6pIJLLUqSmkAjKHXcZOoFSGtl4Kb8EK5cEpBsviQhyh82jcvCkUPXyx5AhQwSCmO/4OKbK3fl2HlU8gxHb/3zJMPEhrvgGNOv6bkucPJr7ME5Qc1ojboB1QdhBoeN+r77/2kkU+boasVIrzRNZl/SxnNk5xP1NFD6NFexy6CuHhuh6Yrk3le4v+iXeMdd7DGzff7t8ljOceSkE8upD8k8ae/7bbbeBZA2rN/bRn2mcjwUxqQfXxyJAbNNrQ0Dg7zb6dOZopIxAYmtSnpo8giPK4K+G3SYBsbBXsRwgqJ2Em/E7HO/eV+9dasvgq1vMs52tJFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNnqi3eqLEk4cn14YBEPIr7ldWVz/kZ8m/kplEQ87Lo=;
 b=lIr2EBPK8c4cRvPU6SBkMpWeBNHeAiTEQ0pPh+pVl07EnH8VThCOZXxSwMfYESg/8bzeTHFgTm2q3vzyw0vynC63vOcyOqCfwqYXRqT/fGPNIr5ssN0AeJNkWCQL/UoFXqQY3XHu2fb8d8ylnrZPzuonLT2Zv7BINzOFmeNeYyM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4689.namprd10.prod.outlook.com (2603:10b6:303:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 26 Sep
 2022 21:49:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 21:49:10 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 15/26] xfs: add parent attributes to link
Thread-Topic: [PATCH v3 15/26] xfs: add parent attributes to link
Thread-Index: AQHYzkaBourbKUJG0kOWmZ/x4uj5+q3tej4AgATM0wA=
Date:   Mon, 26 Sep 2022 21:49:10 +0000
Message-ID: <f811b8d5ea995f7b86886043cc3dd03666d4fa22.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-16-allison.henderson@oracle.com>
         <Yy4XhkdToBRBnfbR@magnolia>
In-Reply-To: <Yy4XhkdToBRBnfbR@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CO1PR10MB4689:EE_
x-ms-office365-filtering-correlation-id: 8e41b056-592c-4603-a145-08daa008f1f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WXEXWuhyaPgmICYBX+wPinsZ3l/Ed5QQjNUx9e/c4zZAsJN3ViL59A3OrazWPkDoU1Oml7cDQ3XIDR6iGvu7PpCkZ93hLmLS3YFu+pKc/jEtNtzPqZ+hsqtT4Ni77S3welHUnrC8dECHc2VQUKVo4Z5NicB+TcWD7ZzybtvrGHd0QwbyEJb+MfqNaM2fAA2Wh+QXgoya+RuEKUlLAYTqAXKzlgIsq/l4i7n82Vu4rkDzIuSYFNnlZwZuoKeH1cjybWQH9r4SFQeIqiouyg9Iqyd2eCQG/Z2qKuZlD8Rpmoz9EauR0X8PCEe/VO/koZRoTcO57QMHjApfgqiKTohuvqnClemvQTEOkae9W0bnIVQ1TDJ5N4Bl86+zuiEEx6dI7u1KOk/eLLXcSg8YveQEA2gOxJITQwrsgs2TySu1H0YcgUD0fj+pwE8GVcysiswJ9yqGxiF3tNUZUqaYirWDohiUeC4ckvxfX4GsNLsgLkXUI6O43FakfsZ6f3TKvCgU3fUdSpHIHY5T5GjbEKPl0GD1Kitxw1b2fi5jFHCCY9268dC+IoYIgnw0qKOT5+UNRtvswHIn4eyt7qkZcLTFtuLdt/iRJxQvVK/c9d36hZ4UqXgjCGMbV9h62B24z+m+ZDHlM/ROkt4A/c0qbRxJ3y+7pR5xmHLf9eOCp9//ad1UGwEvjmTp0m4s5+rLYMymJuZ6FwC3YAzMrS1YjxaOX+EbWvPi2kFVrKrGedLSKGJvGgcTeOGIofuH5SyPVQtjJedEqs1BwiKNJaopiFLksQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199015)(122000001)(2616005)(36756003)(2906002)(186003)(86362001)(44832011)(8936002)(38070700005)(6512007)(64756008)(66446008)(66476007)(66556008)(41300700001)(26005)(4326008)(8676002)(66946007)(76116006)(5660300002)(83380400001)(316002)(6506007)(6916009)(478600001)(6486002)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjZ1VXlyNzJHQklwYUpUZitqL0UyQkFZNGRTdmZ4ZGFKMnkvMmtwR2lGaENX?=
 =?utf-8?B?eHB0cEtPTEJQY291THF0Y21sK0ZKai9QOUwzeFFkbWJXZ012aUJzWm9jdUNr?=
 =?utf-8?B?UnhaYTBWQlI3RnNEQXA0M21TSTZ5S1BxSEMwbThHVnAzNTFKUVBpZ1RxY05s?=
 =?utf-8?B?ejFGYmt2R2xRbXNkTjF3Zm9yUlQ1SGlRMGZYMWxCN05RbzF4OGllWVU4R1Br?=
 =?utf-8?B?UWtjdi9tbjV6dWtmMC9UL0ZXaTNpSzVwWXpoUzVMajRsdlBXWHA1Y1Zrdzdw?=
 =?utf-8?B?SUtGck52Vytzb2MzY0FrMW9XU0J6VlMrVU44YktjUWpSakdiOGxlaFJkdmE2?=
 =?utf-8?B?WGFKcGlDUXk3T1N2ajB3VjhSdFAzbkFnUXQzNUhOSHNIYU1QL0tMMkxOVXBt?=
 =?utf-8?B?elVmVEN3N2x5OVlMOVpJOEFqMlYvNzk5dmJURU1tVThiZ2g2eDBnc0hEclpY?=
 =?utf-8?B?ZGowUjhjK29GSzE0VjJQNWJxVkFuSUVGZlJDR0swWUZVL2diNzFnMG5qRXBL?=
 =?utf-8?B?bnpidDlyYlVsRTRtclNpazZOT1R2SC81MngySFdoNjFVbHByc3lBTysrZ3dW?=
 =?utf-8?B?VExOaEhnUlNWRFF1ZDBuajhyTHNzSzZyR3cvbXRKWjk2YU5KVXpxcERlakdW?=
 =?utf-8?B?VGxlUnU5TlN0NlBDWWpxMnJRZG9PODR3Q1pDTUx4YXE5MnloTmcwajFvV3Ni?=
 =?utf-8?B?aG9adWgxT2VKZnBWdXVnNVlMUENhNC9CcC9nbmtkN0dpengzblJPMEJHNTRH?=
 =?utf-8?B?Um1JOWtVbkcvWlJXQmNtVDBUalJiVTJDRjBPM1J1S1hXbSs4WFhSVmJ6dmdq?=
 =?utf-8?B?Sk9VMms4N2RkYnBtcGRUNWpHTXNYV1hBOFRXRHVqVEdvdTlvNmFqQzRBNFRD?=
 =?utf-8?B?MGZNMnEzQm5HNTltMFZ5SlVtYlZxK1BvS05iZXFUNTFPRm9nc3UwMjFBQTJs?=
 =?utf-8?B?Tm5FZVRiRDVSU2lVNVdOaFNoMTJEaTk5cm90L0FUNS9TUm1USis0N2QxVWJP?=
 =?utf-8?B?ZTg2eC9ZRU1UaElaUXB4SlZZQ240QlltT09CaHErWTJsbU4vemU4TFU0YWNm?=
 =?utf-8?B?dVZMNlZtTnNyYlBtRS9DQnRZSDdybW5FcHZtR1RZSzYva1lwd2MzOVZiRkZw?=
 =?utf-8?B?S0dZeElBUS9pWjI2aWVPWlVnZ3ZuR1Z6UXpLSWtTbU1RcDNjVlFvSmE2WXp4?=
 =?utf-8?B?aXVPY1l5UWlRQVZzSWswRnAza0d3UzFSaGNTbzd1eUdLVFkvODVoR2xIYndE?=
 =?utf-8?B?b3dmdXFMMjh4b1lrTFUrc2l4NDcvVlNrTUJscU9XWEJteVVHUkpvb0YvN1Vu?=
 =?utf-8?B?R0FsK096K2hwTDVkTzAzVmpib2ZjcnJZOGQ5NVhzT0tacjNvZzVlYjFEYzAr?=
 =?utf-8?B?ZWN2eEdBNnlkblkxN2k2a3BiajliUjB6NnF1UWtxeTZQWFgreVRiVVBRVFRm?=
 =?utf-8?B?TERIbW53V2k2QXZVNnV5dGhERC9NRk45Z2szMkJUUlNmcGZkQW02aHJEQlkz?=
 =?utf-8?B?M2svazhkd1ZxdXp5cVFwOFlubUx3OUw0bGhibGVPN3NKUDAzSzkrM2s2clRP?=
 =?utf-8?B?cnVKTUtUSUxFNnVhdXZDQ1JzVXl4T0NtMmFLcWRKa0E4T2NFOTZwQVF5SnpT?=
 =?utf-8?B?SCtkN1MrNUlDaXMxb3Mxd0xyem9jcUVDVUlTOFA5RGRkSGxteW8zQms1a0Rj?=
 =?utf-8?B?OTVNbFJkUkgwU2FnRXVKcXBkOXN1NlZlSG9QNFVvYzY3Q2RXU1lGMHJxcVJt?=
 =?utf-8?B?OGExd1ZrOFA4NWFrK1dKbTdydm1xam9YU0I3Mmc5N2hFbFhyOTc4ek40ZjRU?=
 =?utf-8?B?ZWNuVFVmQ3Q3Q21HZjhZN1FOT3NhUlV5YWVxaFBZb0FYNFNIQzhhak55L1p6?=
 =?utf-8?B?b2JOTkVYNlBRenhqQnFmWWxPb3dBZEJwNGRzYkNpbFM0ajVyYm5FMlUzcFRj?=
 =?utf-8?B?aW1lcnA0YytmcXRzZDRUSjN1eTF3MVpzZ3EzL3V5RFpWZjhzd1VWMWE1dHBB?=
 =?utf-8?B?T0RWT1F4UjVWOEsvcnRUV25sV1lpRGxMalFnOWs5RmMvSDk5ZkQzT1ZSM2lL?=
 =?utf-8?B?TDVtMHZCSzlCL0tUNFJHUlFMeFZGTUF5N0ZwbHhsak5iK0VHcmdMWFFRZFFi?=
 =?utf-8?B?dVdTemdVZXhDUmNwNEQ4RUJCNGF4ZlZmZjJYWDFMdndieHFHVU9qODNGNDM2?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C70E10B8BF2B13498D55F7270AAF5363@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e41b056-592c-4603-a145-08daa008f1f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 21:49:10.5582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NVbAfGOaY3vL8EsoR6s1/i2qaxTBLz/nhHudELSU/iZ/yS9fKatGtJNvOn2kJiVs8owx08H9cw3j8fWAsXA36NJ5X+YsBUysKfhW96/0jSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_10,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209260134
X-Proofpoint-GUID: gcCVhYYmn6GK61G_Az6ebEldM9dWfkxA
X-Proofpoint-ORIG-GUID: gcCVhYYmn6GK61G_Az6ebEldM9dWfkxA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDEzOjMxIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMTA6NDQ6NDdQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+ID4gCj4gPiBUaGlzIHBhdGNoIG1vZGlmaWVz
IHhmc19saW5rIHRvIGFkZCBhIHBhcmVudCBwb2ludGVyIHRvIHRoZSBpbm9kZS4KPiA+IAo+ID4g
U2lnbmVkLW9mZi1ieTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+ID4gU2ln
bmVkLW9mZi1ieTogQWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNsZS5j
b20+Cj4gPiAtLS0KPiA+IMKgZnMveGZzL3hmc19pbm9kZS5jIHwgNDQgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tCj4gPiAtLQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwg
MzUgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL2Zz
L3hmcy94ZnNfaW5vZGUuYyBiL2ZzL3hmcy94ZnNfaW5vZGUuYwo+ID4gaW5kZXggMTgxZDY0MTc0
MTJlLi5hZjNmNWVkYjczMTkgMTAwNjQ0Cj4gPiAtLS0gYS9mcy94ZnMveGZzX2lub2RlLmMKPiA+
ICsrKyBiL2ZzL3hmcy94ZnNfaW5vZGUuYwo+ID4gQEAgLTEyMjgsMTQgKzEyMjgsMTYgQEAgeGZz
X2NyZWF0ZV90bXBmaWxlKAo+ID4gwqAKPiA+IMKgaW50Cj4gPiDCoHhmc19saW5rKAo+ID4gLcKg
wqDCoMKgwqDCoMKgeGZzX2lub2RlX3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCp0ZHAsCj4g
PiAtwqDCoMKgwqDCoMKgwqB4ZnNfaW5vZGVfdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKnNp
cCwKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKgwqDCoMKgKnRk
cCwKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKgwqDCoMKgKnNp
cCwKPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX25hbWXCoMKgwqDCoMKgwqDCoMKgwqAq
dGFyZ2V0X25hbWUpCj4gPiDCoHsKPiA+IC3CoMKgwqDCoMKgwqDCoHhmc19tb3VudF90wqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAqbXAgPSB0ZHAtPmlfbW91bnQ7Cj4gPiAtwqDCoMKgwqDCoMKg
wqB4ZnNfdHJhbnNfdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKnRwOwo+ID4gK8KgwqDCoMKg
wqDCoMKgc3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDCoMKgwqAqbXAgPSB0ZHAtPmlfbW91bnQ7
Cj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3RyYW5zwqDCoMKgwqDCoMKgwqDCoCp0cDsK
PiA+IMKgwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBlcnJvciwgbm9zcGFjZV9lcnJvciA9IDA7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaW50
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVzYmxrczsKPiA+ICvC
oMKgwqDCoMKgwqDCoHhmc19kaXIyX2RhdGFwdHJfdMKgwqDCoMKgwqDCoGRpcm9mZnNldDsKPiA+
ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfcGFyZW50X2RlZmVywqAqcGFyZW50ID0gTlVMTDsK
PiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgdHJhY2VfeGZzX2xpbmsodGRwLCB0YXJnZXRfbmFt
ZSk7Cj4gPiDCoAo+ID4gQEAgLTEyNTIsMTEgKzEyNTQsMTcgQEAgeGZzX2xpbmsoCj4gPiDCoMKg
wqDCoMKgwqDCoMKgaWYgKGVycm9yKQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBnb3RvIHN0ZF9yZXR1cm47Cj4gPiDCoAo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKHhmc19oYXNf
cGFyZW50KG1wKSkgewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVycm9yID0g
eGZzX3BhcmVudF9pbml0KG1wLCAmcGFyZW50KTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBpZiAoZXJyb3IpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGdvdG8gc3RkX3JldHVybjsKPiA+ICvCoMKgwqDCoMKgwqDCoH0KPiA+ICsK
PiA+IMKgwqDCoMKgwqDCoMKgwqByZXNibGtzID0gWEZTX0xJTktfU1BBQ0VfUkVTKG1wLCB0YXJn
ZXRfbmFtZS0+bGVuKTsKPiAKPiBGb3J3YXJkaW5nIG9uIGZyb20gdGhlIHYyIHNlcmllcyAtLQo+
IAo+IFRoaXMgcGF0Y2ggb3VnaHQgdG8gYmUgbW9kaWZ5aW5nIFhGU19MSU5LX1NQQUNFX1JFUyBz
byB0aGF0IGVhY2gKPiBsaW5rKCkKPiB1cGRhdGUgcmVzZXJ2ZXMgZW5vdWdoIHNwYWNlIHRvIGhh
bmRsZSBhbiBleHBhbnNpb24gaW4gdGhlIHRkcAo+IGRpcmVjdG9yeQo+IChhcyBpdCBkb2VzIG5v
dykgKmFuZCogYW4gZXhwYW5zaW9uIGluIHRoZSB4YXR0ciBzdHJ1Y3R1cmUgb2YgdGhlIHNpcAo+
IGNoaWxkIGZpbGUuwqAgVGhpcyBpcyBob3cgd2UgYXZvaWQgZGlwcGluZyBpbnRvIHRoZSBmcmVl
IHNwYWNlIHJlc2VydmUKPiBwb29sIG1pZHdheSB0aHJvdWdoIGEgdHJhbnNhY3Rpb24sIGFuZCBh
dm9pZCBzaHV0ZG93bnMgd2hlbiBzcGFjZSBpcwo+IHRpZ2h0Lgo+IAo+IHRyX3JlcyA9PSBzcGFj
ZSB3ZSByZXNlcnZlIGluIHRoZSAqbG9nKiB0byByZWNvcmQgdXBkYXRlcy4KPiAKPiBYRlNfTElO
S19TUEFDRV9SRVMgPT0gYmxvY2sgd2UgcmVzZXJ2ZSBmcm9tIHRoZSBmaWxlc3lzdGVtIGZyZWUg
c3BhY2UKPiB0bwo+IGhhbmRsZSBleHBhbnNpb25zIG9mIG1ldGFkYXRhIHN0cnVjdHVyZXMuCj4g
Cj4gQXQgdGhpcyBwb2ludCBpbiB0aGlzIHZlcnNpb24gb2YgdGhlIHBhdGNoc2V0LCB5b3UndmUg
aW5jcmVhc2VkIHRoZQo+IGxvZwo+IHNwYWNlIHJlc2VydmF0aW9ucyBpbiBhbnRpY2lwYXRpb24g
b2YgbG9nZ2luZyBtb3JlIGluZm9ybWF0aW9uIHBlcgo+IHRyYW5zYWN0aW9uLsKgIEhvd2V2ZXIs
IHlvdSd2ZSBub3QgaW5jcmVhc2VkIHRoZSBmcmVlIHNwYWNlCj4gcmVzZXJ2YXRpb25zCj4gdG8g
aGFuZGxlIHBvdGVudGlhbCBub2RlIHNwbGl0dGluZyBpbiB0aGUgb25kaXNrIHhhdHRyIGJ0cmVl
Lgo+IAo+IChUaGUgcmVzdCBvZiB0aGUgcGF0Y2hzZXQgbG9va3Mgb2suKQoKT2ssIGxvb2tpbmcg
YXQgdGhlIGxhdGVyIHJldmlld3MsIEknbGwgYWRkIGEgc2ltaWxhciBoZWxwZXIgZnVuY3Rpb24K
aGVyZSB0byB1c2UgaW4gcGxhY2Ugb2YgWEZTX0xJTktfU1BBQ0VfUkVTOgoKdW5zaWduZWQgaW50
Cnhmc19saW5rX3NwYWNlX3JlcygKICAgICAgICAgc3RydWN0IHhmc19tb3VudCAgICAgICAgKm1w
LAogICAgICAgICB1bnNpZ25lZCBpbnQgICAgICAgICAgICBuYW1lbGVuKQogewogICAgICAgICB1
bnNpZ25lZCBpbnQgICAgICAgICAgICByZXQ7CiAKICAgICAgICAgcmV0ID0gWEZTX0RJUkVOVEVS
X1NQQUNFX1JFUyhtcCwgbmFtZWxlbik7CiAgICAgICAgIGlmICh4ZnNfaGFzX3BhcmVudChtcCkp
CiAgICAgICAgICAgICAgICAgcmV0ICs9IHhmc19wcHRyX2NhbGNfc3BhY2VfcmVzKG1wLCBuYW1l
bGVuKTsKIAogICAgICAgICByZXR1cm4gcmV0OwogfQoKVGhhbmtzIQpBbGxpc29uCj4gCj4gLS1E
Cj4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfdHJhbnNfYWxsb2NfZGlyKHRkcCwg
Jk1fUkVTKG1wKS0+dHJfbGluaywgc2lwLAo+ID4gJnJlc2Jsa3MsCj4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAmdHAsICZub3NwYWNlX2Vycm9yKTsK
PiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgZ290byBzdGRfcmV0dXJuOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGdvdG8gZHJvcF9pbmNvbXBhdDsKPiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiA+
IMKgwqDCoMKgwqDCoMKgwqAgKiBJZiB3ZSBhcmUgdXNpbmcgcHJvamVjdCBpbmhlcml0YW5jZSwg
d2Ugb25seSBhbGxvdyBoYXJkCj4gPiBsaW5rCj4gPiBAQCAtMTI4OSwxNCArMTI5NywyNyBAQCB4
ZnNfbGluaygKPiA+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gPiDCoAo+ID4gwqDCoMKgwqDCoMKgwqDC
oGVycm9yID0geGZzX2Rpcl9jcmVhdGVuYW1lKHRwLCB0ZHAsIHRhcmdldF9uYW1lLCBzaXAtCj4g
PiA+aV9pbm8sCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlc2Jsa3MsIE5VTEwpOwo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXNibGtzLCAmZGlyb2Zmc2V0KTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBlcnJvcl9yZXR1cm47Cj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBvdXRfZGVmZXJfY2FuY2VsOwo+ID4gwqDC
oMKgwqDCoMKgwqDCoHhmc190cmFuc19pY2hndGltZSh0cCwgdGRwLCBYRlNfSUNIR1RJTUVfTU9E
IHwKPiA+IFhGU19JQ0hHVElNRV9DSEcpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoHhmc190cmFuc19s
b2dfaW5vZGUodHAsIHRkcCwgWEZTX0lMT0dfQ09SRSk7Cj4gPiDCoAo+ID4gwqDCoMKgwqDCoMKg
wqDCoHhmc19idW1wbGluayh0cCwgc2lwKTsKPiA+IMKgCj4gPiArwqDCoMKgwqDCoMKgwqAvKgo+
ID4gK8KgwqDCoMKgwqDCoMKgICogSWYgd2UgaGF2ZSBwYXJlbnQgcG9pbnRlcnMsIHdlIG5vdyBu
ZWVkIHRvIGFkZCB0aGUKPiA+IHBhcmVudCByZWNvcmQgdG8KPiA+ICvCoMKgwqDCoMKgwqDCoCAq
IHRoZSBhdHRyaWJ1dGUgZm9yayBvZiB0aGUgaW5vZGUuIElmIHRoaXMgaXMgdGhlIGluaXRpYWwK
PiA+IHBhcmVudAo+ID4gK8KgwqDCoMKgwqDCoMKgICogYXR0cmlidXRlLCB3ZSBuZWVkIHRvIGNy
ZWF0ZSBpdCBjb3JyZWN0bHksIG90aGVyd2lzZSB3ZQo+ID4gY2FuIGp1c3QgYWRkCj4gPiArwqDC
oMKgwqDCoMKgwqAgKiB0aGUgcGFyZW50IHRvIHRoZSBpbm9kZS4KPiA+ICvCoMKgwqDCoMKgwqDC
oCAqLwo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKHBhcmVudCkgewo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGVycm9yID0geGZzX3BhcmVudF9kZWZlcl9hZGQodHAsIHBhcmVudCwg
dGRwLAo+ID4gdGFyZ2V0X25hbWUsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
ZGlyb2Zmc2V0LCBzaXApOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChl
cnJvcikKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
Z290byBvdXRfZGVmZXJfY2FuY2VsOwo+ID4gK8KgwqDCoMKgwqDCoMKgfQo+ID4gKwo+ID4gwqDC
oMKgwqDCoMKgwqDCoC8qCj4gPiDCoMKgwqDCoMKgwqDCoMKgICogSWYgdGhpcyBpcyBhIHN5bmNo
cm9ub3VzIG1vdW50LCBtYWtlIHN1cmUgdGhhdCB0aGUKPiA+IMKgwqDCoMKgwqDCoMKgwqAgKiBs
aW5rIHRyYW5zYWN0aW9uIGdvZXMgdG8gZGlzayBiZWZvcmUgcmV0dXJuaW5nIHRvCj4gPiBAQCAt
MTMxMCwxMSArMTMzMSwxNiBAQCB4ZnNfbGluaygKPiA+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfaXVu
bG9jayhzaXAsIFhGU19JTE9DS19FWENMKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gZXJy
b3I7Cj4gPiDCoAo+ID4gLSBlcnJvcl9yZXR1cm46Cj4gPiArb3V0X2RlZmVyX2NhbmNlbDoKPiA+
ICvCoMKgwqDCoMKgwqDCoHhmc19kZWZlcl9jYW5jZWwodHApOwo+ID4gK2Vycm9yX3JldHVybjoK
PiA+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfdHJhbnNfY2FuY2VsKHRwKTsKPiA+IMKgwqDCoMKgwqDC
oMKgwqB4ZnNfaXVubG9jayh0ZHAsIFhGU19JTE9DS19FWENMKTsKPiA+IMKgwqDCoMKgwqDCoMKg
wqB4ZnNfaXVubG9jayhzaXAsIFhGU19JTE9DS19FWENMKTsKPiA+IC0gc3RkX3JldHVybjoKPiA+
ICtkcm9wX2luY29tcGF0Ogo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKHBhcmVudCkKPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfcGFyZW50X2NhbmNlbChtcCwgcGFyZW50KTsK
PiA+ICtzdGRfcmV0dXJuOgo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChlcnJvciA9PSAtRU5PU1BD
ICYmIG5vc3BhY2VfZXJyb3IpCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVy
cm9yID0gbm9zcGFjZV9lcnJvcjsKPiA+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gZXJyb3I7Cj4g
PiAtLSAKPiA+IDIuMjUuMQo+ID4gCgo=
