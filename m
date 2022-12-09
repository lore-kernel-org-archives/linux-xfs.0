Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E127C4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Dec 2022 21:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiLIVWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Dec 2022 16:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIVWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2022 16:22:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F61B3DBD
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 13:22:13 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9Iwx2G010110
        for <linux-xfs@vger.kernel.org>; Fri, 9 Dec 2022 21:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=FEKGI5KUD/+FBJfC8uI9JFj2RHNgUppMLlapZi2S4qo=;
 b=T7Ht+u4dbDWFcCnDV4KSjr+AZzJWagJbJkX1tXd1jBEk6m988Qi7sJQ7QtGkk14+Gt61
 tF3Yhme/Y5HKPpEYIQBlI7X8R8CLYRNs8TuW18pVh0l9kmHllyQdvoQXmF3fAFd8sumk
 ACShmnbjEWGd5M1IIkUdceGl9n18pbDfsLEL7ljeNlbQXu+KSZXbLRnHu+FuWv22AyWA
 O+wkGRtqaP+M4/15J7Yrq5u3umnS7o49PFdgXVWlgxRNa6P2aEbGlR3V/4pBwfxF2EOU
 oFJvkvMTWdGX/p+YaFoE3K1zLngFYg0r3dJ4zzmP5GPkdN0YyQbgE92URz94cXRm1TWC XQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mawj6w6j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Dec 2022 21:22:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9LD5PE031980
        for <linux-xfs@vger.kernel.org>; Fri, 9 Dec 2022 21:22:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7gpjq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Dec 2022 21:22:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exDzNdDDnkmVnVZpsWFoUWUrpCTG14PiPYOLF+qLBITVDs8XAY0frjQpJW+tai8QUXrm9Ylwb9UpS+am9aSPMhOPupdUD58Mvd4ejxBpff7vR+msijGyUtZBmzTre1iDcSZZJsPprH5iYNlRX4qArfNl0Q4UgRIJBjihmNryATn3Mxn9RFSWbKnHURYQPKQvARuO8sf/F3xwUGpmuJQBA4iaCEDw+HCdNdbNxwX5nIEHEvNM6qBwAkXOXD8GdfhK3CS7F7K7kpXLOZA8eur26v4JT7JLhMLSGq+IaJD8eqp7+NkkxJz3Sc3Wucleba6XMoujfx4Eydmoah6SjcgOiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FEKGI5KUD/+FBJfC8uI9JFj2RHNgUppMLlapZi2S4qo=;
 b=ZL9f7Lw+tOkDvziezHCFgoxcSq+09kam/xqu4XMHXHf23BUSv1SHM//db5nMbZm26qaRzUe1Zzm/QdiO4Eq8gRtK+gqwWEckKG2Z3se0BiJbUxEByJLrNJJBzke6gw+BLYpetCSomIPYCbQ14NwUNhkWBpLZi78miBJRKoDsNIhr/aUN/uuUu7WRq33T+U2i69fIMMRHaD1/jpgOMZcHg8o9A6jM4a7gGuZuWaUOXWqHFiU5Nv6CzBrae8HhBt8P3lvwj/XSN5G/75rtpWFL13CvMyNJxQbowGsuwG28L+5xqIDZWgkH4KIxRcg1pvCjBsdaMW1sWxz8PaPkY4e1Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEKGI5KUD/+FBJfC8uI9JFj2RHNgUppMLlapZi2S4qo=;
 b=yjJzpykOufbYfP20OhlRgmf2haCVk9bL7P0hdHjP8a1Vhe8PTlozmc03spWW3n+pUTwM/1STtCPE4DULFYfQqtUQuc4dGPSIcmSczFuMPkHaYqPurvJNHyz0kCQsGsJWID/gbnjlgUXRrULXVwiq/aCqMAOmm4pwZTc7uSkDAVc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ1PR10MB5929.namprd10.prod.outlook.com (2603:10b6:a03:48c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 21:22:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%5]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 21:22:09 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] xfs_io: add fsuuid command
Thread-Topic: [PATCH v1 1/2] xfs_io: add fsuuid command
Thread-Index: AQHZCeL3BlEznJS3skW4Kzj6244Yb65mFM6A
Date:   Fri, 9 Dec 2022 21:22:09 +0000
Message-ID: <2630029187aac440d18def6923cfcb805ce412a3.camel@oracle.com>
References: <20221207022346.56671-1-catherine.hoang@oracle.com>
         <20221207022346.56671-2-catherine.hoang@oracle.com>
In-Reply-To: <20221207022346.56671-2-catherine.hoang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SJ1PR10MB5929:EE_
x-ms-office365-filtering-correlation-id: deea28c1-f7f1-45a9-be5b-08dada2b6e3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nw3ecQ65IpvI67LRc29bLWpxA6vCbz2Dbm1x8nKFYDD/r+trK9vxDDJnk0xpRrNcuD4uJinpeHO+htpbfiv5JscGhC2ZQ/o85IeY9bRk1pWcCibIQPpXJ9cu1kTLakXXffR3iRetXsWjdccb1n0P/FBV5i+c96rvE/rcfripA7K3UP8ktstLxUzcY+VtNriAcaVgY6DClIb9hP+B2KHOboAm08f923cT7kDM9F8HLNzQbv0L1VqHEk0Ok0xyLersrpWeCVuKMbF5so+J8CHpQeN0VoKbXz4StLocOc+MiVYwQ6fRDIfHi+ONXYehAcpPA1ZxfGdDokf8GtwK/25UqlSDUr5kQlZJH7hqBWsl7T9Sfsd41b7nDvXWKqE+jNocxi4rjWZ+yzAxMBmz4xwK5k+tqrwZBCHraToe5rJ+TbhoiX2rp0ZxiDx1ngdbeCK/b3DHb/n9sCE5hc8gPXW8alYHLuLA91Fd6U2c2PozXljvf7eZrUkI8JwEALcyOyeFtMESIr9WJq2ezPHRfsdsfB4e7zyyTuIIrlqKA8dqv61033Yg/TxOR5zQho4BosUIN2uFLm4U5xUdeo33f1TPWvWUTJ1jnOq+J7cI/aWGt/tMtCpu/8zx8E6I6IyT+IWTpEHZdpju5J+tf1VElL4MN/Pw7XUecHLViwYYsBzvGFD4LXTu7sMPyF5/nAkyx564insaOo6WD/TYYm4w9Wvw+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199015)(110136005)(316002)(86362001)(6506007)(26005)(186003)(71200400001)(6512007)(6486002)(36756003)(38070700005)(38100700002)(122000001)(2616005)(83380400001)(44832011)(66476007)(91956017)(76116006)(66946007)(64756008)(8676002)(66556008)(2906002)(5660300002)(66446008)(41300700001)(8936002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1dzUFpMakx3OU10S0kyY3JsSVE4ZkRVVjVOZ0Y4c0xscFZURjQraFFKOXhO?=
 =?utf-8?B?dDY1V2FtTkFUa01yeTh5Vm16L2REdWlmTGlUMFFZTStHTlJaZnQ4Q1NXVFJP?=
 =?utf-8?B?UEZEU0ZpUVJMZXZoZXYxZG9XcC9TejIwNDdFa2tUWExkeGhrM1VLSVpqQ1N0?=
 =?utf-8?B?dStTN0Nja0QyVXB6eGs5ZXdyYklLbERQUFhZZnJZZURZRFhrUkphd2RZNHI3?=
 =?utf-8?B?UFI5aVBHNHZxT3c4U3pIblhPOGpkYlVFNVpKZm5jcTV0QzF0cCtGa1I3b0NP?=
 =?utf-8?B?UWFxMmJQcHJPbFMyeXpXRmt2U1BWOE8weWdsa1c3eVVPU1d6Y0V3NDVRbTNR?=
 =?utf-8?B?TVFNUHkwb0RON2czTXJGSGpGTEhTaDZSaC9pb0JIZWFqTmdhUVNBL0hNZDdl?=
 =?utf-8?B?a2cxT01UUEhuRkQ0dXB6Y0szT0RSbDhDa2JvOHpIcXViWkFqdndwdlgxM0s1?=
 =?utf-8?B?S0lWajRGOWVCZEJrd0NUZnV0aUVWQldyWGljcURyeWIrYWtCM25OUWhVdWRq?=
 =?utf-8?B?Z093QkxQcFFPaTJqcVBzSTdiYUw1bStvdlBuam5RNlhFcU1SMXpMRExNay94?=
 =?utf-8?B?ZnNDVnBaUTB2S1o4bTJyUHdJQzFRU2JYOEdDcGs5Y2dQWFpoT2o3QXpQM2NW?=
 =?utf-8?B?WGoyTnVGK0M0S3RTb01ITThNTEJRZnZIWFp2bk5QR0NUVSsvbjVCM09aakx1?=
 =?utf-8?B?YmVSZUNoVVlwbzVLTjZwQlU2L1YwV1BEN2hKTkRrMjBUVWxEZmlEUVd2NW9X?=
 =?utf-8?B?MS9sY1pUM1pjU0RrRDFkRHFERy9pZllYZGs5T0VCUWppYVZGVnQzcElSN3pn?=
 =?utf-8?B?Y3lyZVc1QWEvbCt6K2FKVnhibFZrbmFxMmNBRE9xaytpUytieE1vejJYeDNo?=
 =?utf-8?B?S1QwRzFHVzlYUFNSdnVFSXpqbXVhdUJmME5ic1N2UEZHdTZmTXdDYjY1Vkt4?=
 =?utf-8?B?MThNb2JmU3BiYWl1eUFzZDMwRXV4d0hwb2w2SE9SWjN1ZGtsRTRneERQRmRn?=
 =?utf-8?B?L3VXU3JyNEtKczJpYWZ3M2xVdytsYndkNjZxZDM2ODBJMXRHNDBGMGtGdHMz?=
 =?utf-8?B?K3FWc0dnNDkwWkJpcDNUUVRoSzhDdUVTQU5PSmNqajlxWjBzVHRrWUNnY1Vs?=
 =?utf-8?B?V2JRYUNWNmVId0MwZDUzbUdHRUFwUTlONHYvcWdiUktIbUlmL2FzSlh3Tlo5?=
 =?utf-8?B?NTlUN0xPYXF1bVBIZzBLZmNRUERLMDlzMWpZNjZ2ZHFnbU55U0dKRnpKSjQv?=
 =?utf-8?B?YnpYTVhxUkxUR2NubDhsM0MwS0ZjVDVkMUxBQU5KTVkzbmlnYW9lelZwSG5n?=
 =?utf-8?B?THZ3aVl1SCtvLzRwZmJDUTQ0ek5tN2VpdTdxLy8yVU9lUndNeHZ4dXpnR3g0?=
 =?utf-8?B?aDgxRVQ0MWJrems1YzE0K094cDlhUFlET0p5ODdLaXd0NDlKNzR4YWtWWncr?=
 =?utf-8?B?VnV3dTV5NFo4UytRMDJudTZsZEttL09sQk5Pbm5CalFMQXU1bGR2V0xHVXFX?=
 =?utf-8?B?ZlRvb1RwWHlzMzFoUTYvTkdHUjF5WTc3NnhHS3VwVUJXK3EvVUlnOGVDQUFa?=
 =?utf-8?B?L2doUjBjZ1J5RDE2d2ZwdTUwRGx6NFNYSU9IYXN2WkNjbWVCc1pQMW1CbElt?=
 =?utf-8?B?OWFrV2NaVDhPSURGa1dhNDNMaFI0LzRpL3pYbW1lb01CVjdkWmtycll1UVBu?=
 =?utf-8?B?UFNIRy95NzBZWUVVOGUvUXo5eThQdzJzK1pPOTBxNkVOSEFmTVdMbXRsT3d5?=
 =?utf-8?B?OW1hQ1BrQi93aEtCYXdNbFo0cmxobjNDcDNXM2hNUDBGTThJMWNud0drTkJv?=
 =?utf-8?B?WVFuSkJNVWtya2s2RWNINFBiZytCL1YyWUc3TGFoSlJsNnBmVmNyNFBXU21O?=
 =?utf-8?B?b1pHVDdORDBPQlFtVWdSbnpoVnYveTFyZXk0c3NEQ0hpUmVWS0NCYXdoTEsx?=
 =?utf-8?B?NFZaNGxPcjhUQXdiR043OWtqZFMwUllhcFFWYlFvbmw1MzZZZFV6UFZJelFR?=
 =?utf-8?B?UWlZbkhnSlN2eEoxY2ZJSWhwVEE5YWF3SE52UHhhVEwvRE4zckNaclU3Q2ZF?=
 =?utf-8?B?NEwzcUQvTE9vbGM3bUYxdTBTNDFYMWF5a2N6WmFvT2pnNHFsajZMdWM3ZEZt?=
 =?utf-8?B?RlZHNjRnYm5tSEtRV2srblcyVGl6bVlxbWpGZW5OTVhFMFBab3VnR1Ntalpj?=
 =?utf-8?B?eUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0696A55F842B4446B384C879B9B15144@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deea28c1-f7f1-45a9-be5b-08dada2b6e3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 21:22:09.3774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R7olgf732NeIokK8JoOSkqm/ZNKNOYdp8HMy2ValnZF8pRR6fUaPcfcljbF1JbxlNfRhqHu4Igg3WCZgwlRTXhEL0dBSxxmrAbyaHZMHUNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5929
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_12,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090176
X-Proofpoint-GUID: LElk65xJvpo1R27pSKRyxLXHfXv6X83h
X-Proofpoint-ORIG-GUID: LElk65xJvpo1R27pSKRyxLXHfXv6X83h
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVHVlLCAyMDIyLTEyLTA2IGF0IDE4OjIzIC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6
Cj4gQWRkIHN1cHBvcnQgZm9yIHRoZSBmc3V1aWQgY29tbWFuZCB0byByZXRyaWV2ZSB0aGUgVVVJ
RCBvZiBhIG1vdW50ZWQKPiBmaWxlc3lzdGVtLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENhdGhlcmlu
ZSBIb2FuZyA8Y2F0aGVyaW5lLmhvYW5nQG9yYWNsZS5jb20+Ck5pdHMgYXNpZGUsIEkgdGhpbmsg
dGhpcyBpcyBmaW5lClJldmlld2VkLWJ5OiBBbGxpc29uIEhlbmRlcnNvbiA8YWxsaXNvbi5oZW5k
ZXJzb25Ab3JhY2xlLmNvbT4KCj4gLS0tCj4gwqBpby9NYWtlZmlsZSB8wqAgNiArKystLS0KPiDC
oGlvL2ZzdXVpZC5jIHwgNDkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKwo+IMKgaW8vaW5pdC5jwqDCoCB8wqAgMSArCj4gwqBpby9pby5owqDCoMKgwqAg
fMKgIDEgKwo+IMKgNCBmaWxlcyBjaGFuZ2VkLCA1NCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKQo+IMKgY3JlYXRlIG1vZGUgMTAwNjQ0IGlvL2ZzdXVpZC5jCj4gCj4gZGlmZiAtLWdpdCBh
L2lvL01ha2VmaWxlIGIvaW8vTWFrZWZpbGUKPiBpbmRleCA0OTgxNzRjZi4uNTNmZWYwOWUgMTAw
NjQ0Cj4gLS0tIGEvaW8vTWFrZWZpbGUKPiArKysgYi9pby9NYWtlZmlsZQo+IEBAIC0xMCwxMiAr
MTAsMTIgQEAgTFNSQ0ZJTEVTID0geGZzX2JtYXAuc2ggeGZzX2ZyZWV6ZS5zaAo+IHhmc19ta2Zp
bGUuc2gKPiDCoEhGSUxFUyA9IGluaXQuaCBpby5oCj4gwqBDRklMRVMgPSBpbml0LmMgXAo+IMKg
wqDCoMKgwqDCoMKgwqBhdHRyLmMgYm1hcC5jIGJ1bGtzdGF0LmMgY3JjMzJjc2VsZnRlc3QuYyBj
b3dleHRzaXplLmMKPiBlbmNyeXB0LmMgXAo+IC3CoMKgwqDCoMKgwqDCoGZpbGUuYyBmcmVlemUu
YyBmc3luYy5jIGdldHJ1c2FnZS5jIGltYXAuYyBpbmplY3QuYyBsYWJlbC5jCj4gbGluay5jIFwK
PiAtwqDCoMKgwqDCoMKgwqBtbWFwLmMgb3Blbi5jIHBhcmVudC5jIHByZWFkLmMgcHJlYWxsb2Mu
YyBwd3JpdGUuYyByZWZsaW5rLmMKPiBcCj4gK8KgwqDCoMKgwqDCoMKgZmlsZS5jIGZyZWV6ZS5j
IGZzdXVpZC5jIGZzeW5jLmMgZ2V0cnVzYWdlLmMgaW1hcC5jIGluamVjdC5jCj4gbGFiZWwuYyBc
Cj4gK8KgwqDCoMKgwqDCoMKgbGluay5jIG1tYXAuYyBvcGVuLmMgcGFyZW50LmMgcHJlYWQuYyBw
cmVhbGxvYy5jIHB3cml0ZS5jCj4gcmVmbGluay5jIFwKPiDCoMKgwqDCoMKgwqDCoMKgcmVzYmxr
cy5jIHNjcnViLmMgc2Vlay5jIHNodXRkb3duLmMgc3RhdC5jIHN3YXBleHQuYyBzeW5jLmMgXAo+
IMKgwqDCoMKgwqDCoMKgwqB0cnVuY2F0ZS5jIHV0aW1lcy5jCj4gwqAKPiAtTExETElCUyA9ICQo
TElCWENNRCkgJChMSUJIQU5ETEUpICQoTElCRlJPRykgJChMSUJQVEhSRUFEKQo+ICtMTERMSUJT
ID0gJChMSUJYQ01EKSAkKExJQkhBTkRMRSkgJChMSUJGUk9HKSAkKExJQlBUSFJFQUQpCj4gJChM
SUJVVUlEKQo+IMKgTFRERVBFTkRFTkNJRVMgPSAkKExJQlhDTUQpICQoTElCSEFORExFKSAkKExJ
QkZST0cpCj4gwqBMTERGTEFHUyA9IC1zdGF0aWMtbGlidG9vbC1saWJzCj4gwqAKPiBkaWZmIC0t
Z2l0IGEvaW8vZnN1dWlkLmMgYi9pby9mc3V1aWQuYwo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0Cj4g
aW5kZXggMDAwMDAwMDAuLjdlMTRhOTVkCj4gLS0tIC9kZXYvbnVsbAo+ICsrKyBiL2lvL2ZzdXVp
ZC5jCj4gQEAgLTAsMCArMSw0OSBAQAo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BM
LTIuMAo+ICsvKgo+ICsgKiBDb3B5cmlnaHQgKGMpIDIwMjIgT3JhY2xlLgo+ICsgKiBBbGwgUmln
aHRzIFJlc2VydmVkLgo+ICsgKi8KPiArCj4gKyNpbmNsdWRlICJsaWJ4ZnMuaCIKPiArI2luY2x1
ZGUgImNvbW1hbmQuaCIKPiArI2luY2x1ZGUgImluaXQuaCIKPiArI2luY2x1ZGUgImlvLmgiCj4g
KyNpbmNsdWRlICJsaWJmcm9nL2ZzZ2VvbS5oIgo+ICsjaW5jbHVkZSAibGliZnJvZy9sb2dnaW5n
LmgiCj4gKwo+ICtzdGF0aWMgY21kaW5mb190IGZzdXVpZF9jbWQ7Cj4gKwo+ICtzdGF0aWMgaW50
Cj4gK2ZzdXVpZF9mKAo+ICvCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGFyZ2MsCj4gK8KgwqDCoMKgwqDCoMKgY2hhcsKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqKmFyZ3YpCj4gK3sKPiArwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QgeGZzX2Zzb3BfZ2VvbcKgwqDCoMKgZnNnZW87Cj4gK8KgwqDCoMKgwqDCoMKgaW50
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0Owo+ICvCoMKgwqDC
oMKgwqDCoGNoYXLCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYnBbNDBd
Owo+ICsKPiArwqDCoMKgwqDCoMKgwqByZXQgPSAteGZyb2dfZ2VvbWV0cnkoZmlsZS0+ZmQsICZm
c2dlbyk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGlmIChyZXQpIHsKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgeGZyb2dfcGVycm9yKHJldCwgIlhGU19JT0NfRlNHRU9NRVRSWSIpOwo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBleGl0Y29kZSA9IDE7Cj4gK8KgwqDCoMKg
wqDCoMKgfSBlbHNlIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcGxhdGZvcm1f
dXVpZF91bnBhcnNlKCh1dWlkX3QgKilmc2dlby51dWlkLCBicCk7Cj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHByaW50ZigiVVVJRCA9ICVzXG4iLCBicCk7Cj4gK8KgwqDCoMKgwqDC
oMKgfQo+ICsKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsKPiArfQo+ICsKPiArdm9pZAo+ICtm
c3V1aWRfaW5pdCh2b2lkKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgZnN1dWlkX2NtZC5uYW1lID0g
ImZzdXVpZCI7Cj4gK8KgwqDCoMKgwqDCoMKgZnN1dWlkX2NtZC5jZnVuYyA9IGZzdXVpZF9mOwo+
ICvCoMKgwqDCoMKgwqDCoGZzdXVpZF9jbWQuYXJnbWluID0gMDsKPiArwqDCoMKgwqDCoMKgwqBm
c3V1aWRfY21kLmFyZ21heCA9IDA7Cj4gK8KgwqDCoMKgwqDCoMKgZnN1dWlkX2NtZC5mbGFncyA9
IENNRF9GTEFHX09ORVNIT1QgfCBDTURfTk9NQVBfT0s7Cj4gK8KgwqDCoMKgwqDCoMKgZnN1dWlk
X2NtZC5vbmVsaW5lID0gXygiZ2V0IG1vdW50ZWQgZmlsZXN5c3RlbSBVVUlEIik7Cj4gKwo+ICvC
oMKgwqDCoMKgwqDCoGFkZF9jb21tYW5kKCZmc3V1aWRfY21kKTsKPiArfQo+IGRpZmYgLS1naXQg
YS9pby9pbml0LmMgYi9pby9pbml0LmMKPiBpbmRleCAwMzNlZDY3ZC4uMTA0Y2QyYzEgMTAwNjQ0
Cj4gLS0tIGEvaW8vaW5pdC5jCj4gKysrIGIvaW8vaW5pdC5jCj4gQEAgLTU2LDYgKzU2LDcgQEAg
aW5pdF9jb21tYW5kcyh2b2lkKQo+IMKgwqDCoMKgwqDCoMKgwqBmbGlua19pbml0KCk7Cj4gwqDC
oMKgwqDCoMKgwqDCoGZyZWV6ZV9pbml0KCk7Cj4gwqDCoMKgwqDCoMKgwqDCoGZzbWFwX2luaXQo
KTsKPiArwqDCoMKgwqDCoMKgwqBmc3V1aWRfaW5pdCgpOwo+IMKgwqDCoMKgwqDCoMKgwqBmc3lu
Y19pbml0KCk7Cj4gwqDCoMKgwqDCoMKgwqDCoGdldHJ1c2FnZV9pbml0KCk7Cj4gwqDCoMKgwqDC
oMKgwqDCoGhlbHBfaW5pdCgpOwo+IGRpZmYgLS1naXQgYS9pby9pby5oIGIvaW8vaW8uaAo+IGlu
ZGV4IDY0YjdhNjYzLi5mZTQ3NGZhZiAxMDA2NDQKPiAtLS0gYS9pby9pby5oCj4gKysrIGIvaW8v
aW8uaAo+IEBAIC05NCw2ICs5NCw3IEBAIGV4dGVybiB2b2lkwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGVuY3J5cHRfaW5pdCh2b2lkKTsKPiDCoGV4dGVybiB2b2lkwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZmlsZV9pbml0KHZvaWQpOwo+IMKgZXh0ZXJuIHZvaWTCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBmbGlua19pbml0KHZvaWQpOwo+IMKgZXh0ZXJuIHZvaWTCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBmcmVlemVfaW5pdCh2b2lkKTsKPiArZXh0ZXJuIHZvaWTCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBmc3V1aWRfaW5pdCh2b2lkKTsKPiDCoGV4dGVybiB2b2lkwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZnN5bmNfaW5pdCh2b2lkKTsKPiDCoGV4dGVybiB2b2lkwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZ2V0cnVzYWdlX2luaXQodm9pZCk7Cj4gwqBleHRlcm4gdm9pZMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGhlbHBfaW5pdCh2b2lkKTsKCg==
