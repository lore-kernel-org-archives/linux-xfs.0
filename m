Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8937FC04A95
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 20:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbiIWUrb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbiIWUrC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 16:47:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159C515A05
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 13:45:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NJF4ND026868;
        Fri, 23 Sep 2022 20:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Kt78QXyRkUbtlpR+QhHwE3g6Z1BcwbN7V3KiMa+DaIo=;
 b=JZiSckipDPfV6ovxY0fbf4230FdELY6Rtz5gesXSOclC+AgkpEWh9m2+pLROplr7IBxx
 qW4s5WYbVAGEvMQq/+fC9M9Ccz9oVjZ+4Lc4wdmMXZhUexoeGpwV/m9OUgfrr6GtmkRc
 Be26bKph6x0EcFjX1yTZE0qu2QytRXoPM//HnXoXNR0g3XfBfcFkRIfiTHiGcnAnOjex
 g28/VoawalE7EKDkdWqyDQ8xHy4KxZLhlz1zBkki+DSh+FrCP5H6veitsjFTEVAEeLNf
 gVbU46HXa2fTBK0Vl8ZP8B7ztP/2q2AQv7Haz2WMqDJ8XUh7uzVznREFOZNJeRz1sq+T Ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stt7g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 20:45:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28NHcwDK001862;
        Fri, 23 Sep 2022 20:45:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39u7vw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 20:45:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKTWYw5Gj7rqvJFkUWv9eG5ouDCMmV8RuaTzlEiWMEw7hsS2KNfbiBxxQKcGwphzHLFJ5DfzFyoMTyfaP6nMtS0MCXC3SVwxaXyfK2HmRwcwMt463J4KdKJmIAvsoskxlcmKPHmPIUF+32boVIGWzXdEw9cnDB68n0F9TsQMZHDurGcBdOCPR7nCBDkx0+rorD+r0Ng5XjZ4Zf5JU6Aa8zAUR+we9ckvriYGSQrisX9DEJOfmFqw6bda7aG62/heQ9Di3dHhtu50ZMlodZHZyaMS+ynG4mJXXTBQTW/yknv0wdYCXKebPm5iGG2zn00iBqJsHu1SnbX8nw8M8tkPvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kt78QXyRkUbtlpR+QhHwE3g6Z1BcwbN7V3KiMa+DaIo=;
 b=F1VqJHbrRDo3toOsBXyUDg6qVzW+8kii7DK6Nr9of0NqrxNpL7kuUu8c4IMwgEbFpszhx8YT4RgJaoAaZg/PrAtD+zEqmjUqxqA1BjSeAl6Dtb0ywzPYdjPAPgBu4onWBLw9J5bOjXiKV51cjbk13fjvg4B/hh4Acf+qjomq14QvvCQRNfCYbBTRF80zawEq7j/ckauz8c3BqreNpDSGlq76SNySDj1TiQ6SMQ41BWB1WfNgdjuIHMrEXuqfTI3EdGlInXd+i70TiN2m8als2gt/cUX/+sCWNEt/10mpj9dt51S2lIHStKlveJcC+JGKUtIoYv746XylHiV7ZylmCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kt78QXyRkUbtlpR+QhHwE3g6Z1BcwbN7V3KiMa+DaIo=;
 b=qNzgOJImCOoaW/kH8BB4rAKoLqybQN0txb/ID+DPKUrSju7QWKjc1T3b41WQgO3cpH05OTX9+QhNH9Z6fCIVeUY4CFZOHyEp5vKlmAwhFPFqBEq/e4AE7do6Mxchwwrum1Zqht0moAhcQ1ipimw+XnJfYTX99Qlu+JTwHDgL9nI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB5843.namprd10.prod.outlook.com (2603:10b6:806:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 20:45:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 20:45:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 06/26] xfs: Expose init_xattrs in xfs_create_tmpfile
Thread-Topic: [PATCH v3 06/26] xfs: Expose init_xattrs in xfs_create_tmpfile
Thread-Index: AQHYzkZ6EtOJIvlkpke5ZwJqyFmO863tZ9WAgAAWaYA=
Date:   Fri, 23 Sep 2022 20:45:22 +0000
Message-ID: <4859b4a707017188da640bc34abea1eac8793f19.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-7-allison.henderson@oracle.com>
         <Yy4IFZXqpgJbupD2@magnolia>
In-Reply-To: <Yy4IFZXqpgJbupD2@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SA1PR10MB5843:EE_
x-ms-office365-filtering-correlation-id: 24d0f651-9eac-41f1-7a1d-08da9da488e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Biet/Giya48ay8SNrCP+7LX64H5YLQdSSkQ87a/Y0XBHTz4tnjaUgH/eGkmMFexO1kWesg3NIHSs2+HAB7bxvaJ1vkQYSsxzzwnyiw4OH1E2y/9ENu2hF/16pMOH85inVLcHLNaIZe+gW78sgpONYXc4rPgs96O2EC4hk8tvblkE8BUHwVO+lV52wm0TDr1Dc4U8LJdF5RIetpN9dZRg5x9AE42qP42vbC5ZEgARXaeTM9tsR6973Z/RtupWaWTWBuybtOgtnHIP2ET42d0tOPlcTcpjlT0Yjb0MsBYMMguj7BGOo4TR4vhMIBUHESq6VH0S7WXxT/Oy8ogabbMVIc++iMmPdnQM0rH+SPn6nd/e1V0WN+kH9ANWytrwJuMC7KXo6cV5KHxmRGsk5bGG3vsMv/xuAge8C2+4CV7YTUNKFENl2cIhQ/PU+jpeZ1QGpYC5lmWzEZ6k2G7f6rRB5W/llJofAzFAX/n9NqRZAQJV50SRomQ/9cAIw3d6PtJlnnGYnPIeS1she1mfvcj50WxnAAIO02kW8bsQ4U+fXxBj3IMjnHBlZqIDcKX4Ut5fAUGw4ABR/qznss+TFgd6KV6LcJwZ2pNMCg4EKoPz9MwDDz5xIUc1L5SjUIGC4Z1m6a1rj3Yjxgf50E2PWEIWTHU1p2uJSQ6d5nB2mltUrW0X5guagyppLi/b0XN0m5lja8MfTKIFyzbV8BMA6dTPeElLIQRo/ilfJ9fHNX07ukVVNuuBRlsMxULRJ9KYBzDlQcYjUQC8QpwgENU/qoY1Kg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(6506007)(8676002)(66476007)(66446008)(86362001)(66946007)(66556008)(41300700001)(4326008)(38070700005)(64756008)(76116006)(26005)(8936002)(6512007)(71200400001)(6486002)(316002)(36756003)(6916009)(478600001)(2906002)(186003)(2616005)(38100700002)(83380400001)(44832011)(122000001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1JQQWtDSWVJOG1XckN1NnRjQTh1UGNxUFRFVW9UanVDSXpJZDdXQjNvT0h1?=
 =?utf-8?B?T3luQVNSYnRRVXYvVlVHN1l0clBuU2pjanpOU2w1UWk0QVYrWC9teGhCQ0do?=
 =?utf-8?B?dWtWK1NJenphT3JsSGRibGhpZnJKU0Vkc0dGNzNDKzhqOERiVDAzd3JtcTBt?=
 =?utf-8?B?NEQzcnFRWjVGSFdRWTJsa05jVGVsbDRod3U2K2FrU09jNGl4RG9RYm1RTW1I?=
 =?utf-8?B?MjkvY0VEV05aclVkVHF3UTlBOUZyNXJaL2xQRkh0TVAxMUFxNzBiM3pZRzNr?=
 =?utf-8?B?eDgwR3RweWdxTVpsRmVHOXlIY2NsSW94cVVOd2tCdHB0RXcwcjJMZTNwVlpZ?=
 =?utf-8?B?anJpa0wzZWh2V2ZkOFFSWFYyOXdsTnByKzhMTVFWQWpHWkVTVUtveW1kbStl?=
 =?utf-8?B?NzVobmxIZXZqbGtFNXhlcURXVXg1bE9rRytEeTR0TEx4V1g1UW1FOTVVNElV?=
 =?utf-8?B?Nlk3RTdFYU9GRTVHMWI0WFl4UUlhUitUdm9KWmVnWHBSajRoZUQrUHF3QUFn?=
 =?utf-8?B?dnpJd1NqTDkrdHpWMGNsTkpNQS9JeW5hcUpBQzhVSnNXZkNJN3R5ZHkzRnBD?=
 =?utf-8?B?akRBNE1LOHM5OENFYXEwZXVFWGkvWTBiaE8ydUtpYVVkSFNRR0kzTW43OXZG?=
 =?utf-8?B?S09BY1BmcGRralRNcXZKQ0V0ZHB4OHpYU09LTHB1MDRhMmZydlYzS0QxZDF3?=
 =?utf-8?B?OTAySzlqN1BuMnRmMHNCa1VxTzBHcTloeVp3Y3VBRXJJQ0I1QmFGaDVqZjhJ?=
 =?utf-8?B?SnNvZHZQdFU4bENsZHJDUWFLUzEyb29Hd1pmdGp5c1hkTDBDT1M3TDV0UzF5?=
 =?utf-8?B?MWhwVnpiNFY5V1hZUFgxbmdyY2RNeHlBSFQ1dzRzVUtBTlZEYnU1UmtSQzh6?=
 =?utf-8?B?QXRsTUtYdjdDdzgyVE1QVEVCNjBBelZhZjc4cWlSZGZMQ1phTlZ2OFozL0kv?=
 =?utf-8?B?cVlEVkMvNWh0QTBRbXFya0RLREZaeDVpREliRW5IQmZvNCtBa1hrY3IwUzBH?=
 =?utf-8?B?NEhVZWVmZzhDZlhLTnIxdDN3eGR2MEdDdUYwYjIxRFJOcFpQZ0J5cHZ3aWRl?=
 =?utf-8?B?RDlaZm5naEcyVTd4OVNsK2ovOHcwaUwyUysxaHFTL0VXelRlV1pxaTkyZWZ1?=
 =?utf-8?B?SE8wTlVwazFqLytsbCtMbDR2RDVSRU1Oc0YvUnVUekpEYXg5RXE3V2xsWVpH?=
 =?utf-8?B?a2R5Q252aXQ4SVlNRStqMmpnSTA2cVFhS2lJd01ibzBVd1Z3azhlaG5yTmFu?=
 =?utf-8?B?UTVXR3d0ajVPN3I0d3crb3VtSmFXSzcvdjBDazNpMG81MEVXTGpLVWxvZmc2?=
 =?utf-8?B?R3FjQUNWNDNXdHBOQjNJbG9Nb1JybGNXYUNFZEtjYUJZVmJUbzdyMGF4MlEv?=
 =?utf-8?B?dSttTFNYUEpzWEI0bjB0UWNpekRLTHJRVU4wUlNEVVRzNXY3SDRKQWRRM3l4?=
 =?utf-8?B?TW5vdmxSSEN2NGRGdkpIMVBManZ0K2tEU1FuSjFZYXRpSmJJOVZ2bjgxUS9y?=
 =?utf-8?B?V1VhcWhCMjh2SjZnU2ZjZGsvNHk2U2JLcTNma2RSazh6R01JdEpnbTdMSW9V?=
 =?utf-8?B?enJNN3daZHdjekhBZ0RHdGo0dkpaZ2xPaHhrdXJ1d3k1ODg5eXhlVXRBWldt?=
 =?utf-8?B?VnF1QklOVWZzMTRNUFVNZXNVYjYxbTVudVoyT0c4QTcxNmd6ZWhvcExwVjd2?=
 =?utf-8?B?VmtvNVhMbnROYmNLbFZ6TGx4RU16WTZRRCtoRDBEdjBGd2JBdGxiS1ZZNXdo?=
 =?utf-8?B?NW5ZbVBvSHhyaTkyQWN1VWtYR0UrSUwxUHlNMWpJMTJYSTFIL1BNejNhSmgx?=
 =?utf-8?B?RXo5SEhXNEdxeitwVDBQTUpZQkhGZDB1eDlldFVGdkxVU0dOalhCdGhZMjJ1?=
 =?utf-8?B?ZUFmZzZmOS9YWUtlL2J4QVlhem1pWE9USDlQZXkrSEZ3elA3UytaWUk0V1dl?=
 =?utf-8?B?c0paVTVBT054U0w2L1Z3V3d1R0ptMUdnaGpRb3oxaVVxK3lXQ3VYck5ZdHlo?=
 =?utf-8?B?ekl2dSt5ZXllbUptQjB3RDJSRHQyNUdJWUttUldxOHVQK0d0VnhWZXEyL05O?=
 =?utf-8?B?cXJxQjNrWHV5UGMwamR5bDA1Y1pBbHhYb3UyYm1aTzM5K2F6VzJ4QjMrSFVs?=
 =?utf-8?B?RE9nNE1QbWwwdXV2NTF0OUFsM3owcm5mUXphd0JJdTdndkZ6QTMrUTAvVFhD?=
 =?utf-8?B?eUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B0254DB4739EF449FA6C2236BB98B42@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d0f651-9eac-41f1-7a1d-08da9da488e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 20:45:22.2855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yAW53VKntB1QejSyF4I3anvACiXTLAjBOExX6zwuhEYNAZweZ/ormFRK+PSZmCVjIPNtMl3LTUu5jJzym2Lb2vHO10oEkH5v9GiUFf71AM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_09,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209230134
X-Proofpoint-GUID: 2A-GflmwGj1C9U0srnDvB31_NCuZ6w2d
X-Proofpoint-ORIG-GUID: 2A-GflmwGj1C9U0srnDvB31_NCuZ6w2d
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDEyOjI1IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMTA6NDQ6MzhQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+ID4gCj4gPiBUbXAgZmlsZXMgYXJlIHVzZWQg
YXMgcGFydCBvZiByZW5hbWUgb3BlcmF0aW9ucyBhbmQgd2lsbCBuZWVkIGF0dHIKPiA+IGZvcmtz
Cj4gPiBpbml0aWFsaXplZCBmb3IgcGFyZW50IHBvaW50ZXJzLsKgIEV4cG9zZSB0aGUgaW5pdF94
YXR0cnMgcGFyYW1ldGVyCj4gPiB0bwo+ID4gdGhlIGNhbGxpbmcgZnVuY3Rpb24gdG8gaW5pdGlh
bGl6ZSB0aGUgZm9yay4KPiA+IAo+ID4gU2lnbmVkLW9mZi1ieTogQWxsaXNvbiBIZW5kZXJzb24g
PGFsbGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb20+Cj4gPiAtLS0KPiA+IMKgZnMveGZzL3hmc19p
bm9kZS5jIHwgOCArKysrKy0tLQo+ID4gwqBmcy94ZnMveGZzX2lub2RlLmggfCAyICstCj4gPiDC
oGZzL3hmcy94ZnNfaW9wcy5jwqAgfCAzICsrLQo+ID4gwqAzIGZpbGVzIGNoYW5nZWQsIDggaW5z
ZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94
ZnNfaW5vZGUuYyBiL2ZzL3hmcy94ZnNfaW5vZGUuYwo+ID4gaW5kZXggNGJmYTRhMTU3OWYwLi5m
ZjY4MGRlNTYwZDIgMTAwNjQ0Cj4gPiAtLS0gYS9mcy94ZnMveGZzX2lub2RlLmMKPiA+ICsrKyBi
L2ZzL3hmcy94ZnNfaW5vZGUuYwo+ID4gQEAgLTExMDgsNiArMTEwOCw3IEBAIHhmc19jcmVhdGVf
dG1wZmlsZSgKPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdXNlcl9uYW1lc3BhY2XCoMKgwqAq
bW50X3VzZXJucywKPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2RlwqDCoMKgwqDC
oMKgwqDCoCpkcCwKPiA+IMKgwqDCoMKgwqDCoMKgwqB1bW9kZV90wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoG1vZGUsCj4gPiArwqDCoMKgwqDCoMKgwqBib29swqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGluaXRfeGF0dHJzLAo+ID4gwqDCoMKgwqDCoMKg
wqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKgwqDCoMKgKippcHApCj4gPiDCoHsKPiA+IMKg
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX21vdW50wqDCoMKgwqDCoMKgwqDCoCptcCA9IGRwLT5p
X21vdW50Owo+ID4gQEAgLTExNDgsNyArMTE0OSw3IEBAIHhmc19jcmVhdGVfdG1wZmlsZSgKPiA+
IMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19kaWFsbG9jKCZ0cCwgZHAtPmlfaW5vLCBtb2Rl
LCAmaW5vKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIWVycm9yKQo+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19pbml0X25ld19pbm9kZShtbnRfdXNlcm5z
LCB0cCwgZHAsIGlubywKPiA+IG1vZGUsCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAwLCAwLCBwcmlkLCBmYWxzZSwgJmlw
KTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoDAsIDAsIHByaWQsIGluaXRfeGF0dHJzLCAmaXApOwo+ID4gwqDCoMKgwqDC
oMKgwqDCoGlmIChlcnJvcikKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290
byBvdXRfdHJhbnNfY2FuY2VsOwo+ID4gwqAKPiA+IEBAIC0yNzI2LDYgKzI3MjcsNyBAQCB4ZnNf
cmVuYW1lX2FsbG9jX3doaXRlb3V0KAo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB1c2VyX25h
bWVzcGFjZcKgwqDCoCptbnRfdXNlcm5zLAo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNf
bmFtZcKgwqDCoMKgwqDCoMKgwqDCoCpzcmNfbmFtZSwKPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgeGZzX2lub2RlwqDCoMKgwqDCoMKgwqDCoCpkcCwKPiA+ICvCoMKgwqDCoMKgwqDCoGJvb2zC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW5pdF94YXR0cnMsCj4gPiDC
oMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19pbm9kZcKgwqDCoMKgwqDCoMKgwqAqKndpcCkKPiA+
IMKgewo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKgwqDCoMKg
KnRtcGZpbGU7Cj4gPiBAQCAtMjczMyw3ICsyNzM1LDcgQEAgeGZzX3JlbmFtZV9hbGxvY193aGl0
ZW91dCgKPiA+IMKgwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBlcnJvcjsKPiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4
ZnNfY3JlYXRlX3RtcGZpbGUobW50X3VzZXJucywgZHAsIFNfSUZDSFIgfAo+ID4gV0hJVEVPVVRf
TU9ERSwKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgJnRtcGZpbGUpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpbml0X3hhdHRy
cywgJnRtcGZpbGUpOwo+IAo+IFdoaXRlb3V0cyBhcmUgY3JlYXRlZCBwcmlvciB0byBiZWluZyBh
ZGRlZCB0byBhIGRpcmVjdG9yeSwgcmlnaHQ/Cj4gSWYgc28sIHNob3VsZG4ndCB0aGlzIGJlIHMv
aW5pdF94YXR0cnMvdHJ1ZS9nIHRvIHNhdmUgdGltZT8Kd2VsbCwgcmVwbGFjZWQgd2l0aCB4ZnNf
aGFzX3BhcmVudChtcCkgaWYgd2Ugd2FudCB0byByZXRhaW4gdGhlIG5vbgpwYXJlbnQgY29kZSBm
dW5jdGlvbmFsaXR5LiAgSSBkb250IGtub3cgdGhhdCBpdCByZWFsbHkgc2F2ZXMgdGhhdCBtdWNo
CnRpbWUsIGJ1dCB3ZSBjYW4gaW1wbGVtZW50IGl0IHRoYXQgd2F5IG9mIGZvbGtzIHByZWZlci4K
Cj4gCj4gRXZlcnl0aGluZyBlbHNlIGluIGhlcmUgbG9va3MgZ29vZCB0aG91Z2ghClRoYW5rcyEK
QWxsaXNvbgoKPiAKPiAtLUQKPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBlcnJvcjsKPiA+IMKgCj4gPiBA
QCAtMjc5Nyw3ICsyNzk5LDcgQEAgeGZzX3JlbmFtZSgKPiA+IMKgwqDCoMKgwqDCoMKgwqAgKi8K
PiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZmxhZ3MgJiBSRU5BTUVfV0hJVEVPVVQpIHsKPiA+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfcmVuYW1lX2FsbG9jX3do
aXRlb3V0KG1udF91c2VybnMsCj4gPiBzcmNfbmFtZSwKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgdGFyZ2V0X2RwLCAmd2lwKTsKPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGFyZ2V0X2RwLCBmYWxzZSwKPiA+ICZ3aXApOwo+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gZXJyb3I7Cj4g
PiDCoAo+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfaW5vZGUuaCBiL2ZzL3hmcy94ZnNfaW5v
ZGUuaAo+ID4gaW5kZXggMmVhZWQ5OGFmODE0Li41NzM1ZGUzMmJlZWIgMTAwNjQ0Cj4gPiAtLS0g
YS9mcy94ZnMveGZzX2lub2RlLmgKPiA+ICsrKyBiL2ZzL3hmcy94ZnNfaW5vZGUuaAo+ID4gQEAg
LTQ3OCw3ICs0NzgsNyBAQCBpbnTCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfY3JlYXRlKHN0cnVjdCB1
c2VyX25hbWVzcGFjZQo+ID4gKm1udF91c2VybnMsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVtb2RlX3QgbW9kZSwgZGV2X3QgcmRldiwg
Ym9vbAo+ID4gbmVlZF94YXR0ciwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHhmc19pbm9kZSAqKmlwcCk7Cj4gPiDCoGludMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhmc19jcmVhdGVfdG1wZmlsZShzdHJ1Y3QgdXNlcl9uYW1l
c3BhY2UKPiA+ICptbnRfdXNlcm5zLAo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCB4ZnNfaW5vZGUgKmRwLCB1bW9kZV90IG1vZGUs
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
c3RydWN0IHhmc19pbm9kZSAqZHAsIHVtb2RlX3QgbW9kZSwgYm9vbAo+ID4gaW5pdF94YXR0cnMs
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHN0cnVjdCB4ZnNfaW5vZGUgKippcHApOwo+ID4gwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqB4ZnNfcmVtb3ZlKHN0cnVjdCB4ZnNfaW5vZGUgKmRwLCBzdHJ1Y3QgeGZzX25hbWUKPiA+ICpu
YW1lLAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBzdHJ1Y3QgeGZzX2lub2RlICppcCk7Cj4gPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19p
b3BzLmMgYi9mcy94ZnMveGZzX2lvcHMuYwo+ID4gaW5kZXggNWQ2NzBjODVkY2MyLi4wN2EyNmY0
ZjYzNDggMTAwNjQ0Cj4gPiAtLS0gYS9mcy94ZnMveGZzX2lvcHMuYwo+ID4gKysrIGIvZnMveGZz
L3hmc19pb3BzLmMKPiA+IEBAIC0yMDAsNyArMjAwLDggQEAgeGZzX2dlbmVyaWNfY3JlYXRlKAo+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHhmc19jcmVhdGVfbmVlZF94YXR0cihkaXIsCj4gPiBkZWZhdWx0X2FjbCwgYWNs
KSwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAmaXApOwo+ID4gwqDCoMKgwqDCoMKgwqDCoH0gZWxzZSB7Cj4gPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfY3JlYXRlX3RtcGZpbGUobW50
X3VzZXJucywgWEZTX0koZGlyKSwKPiA+IG1vZGUsICZpcCk7Cj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfY3JlYXRlX3RtcGZpbGUobW50X3VzZXJucywgWEZT
X0koZGlyKSwKPiA+IG1vZGUsIGZhbHNlLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
JmlwKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHVubGlr
ZWx5KGVycm9yKSkKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBvdXRf
ZnJlZV9hY2w7Cj4gPiAtLSAKPiA+IDIuMjUuMQo+ID4gCgo=
