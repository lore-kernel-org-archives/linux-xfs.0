Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCECC07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 20:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiIWUra (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiIWUq4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 16:46:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF67B1DC
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 13:45:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NJElKS023736;
        Fri, 23 Sep 2022 20:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=eB+lI9uJYpoxDMG0snQNE3PHGvB5gsifG1+DCTyiyNI=;
 b=fN8lOe+YEOSfY/r/4G0JPXnP0vhS6jXW8KS/15h0DCFg9x8LPSJq2hmhNrfD0fHsHvjx
 Di5OHVaT+HwpVs2ndlOEV84+wBzDV6ErHiR4fcLYsWgCV+Hmgz73g2H34QcAvGWPUKFk
 PiOg1GjZk9qPxU8UDOEfcrmFpYjM35JZm0IMPYg95akPJrF/7NiGYyCU/zpEz944XbI1
 bSIvEhzmqOA66pORlxRTuzb8BgPdtTvWy65h4kklRM0P+bIS25uXYjmxIIvYKIjvYR+q
 vLLTmknwKSEWWR5hvVbuL1uUg8LzejYODruftClDAxzgflYMVhR5HYr8RZ1EKwZAS6eO tA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68rsj1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 20:45:18 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28NK579P005630;
        Fri, 23 Sep 2022 20:45:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cs3c1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 20:45:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQN1OZIPKKeZdV9ARrrDjqIy6RMWGqSzmNNgK+6aK9dvHCHlC8cehBOsn1Yyj7NhtoGeBZ2Vhu7Dbusz9btpOBrkqMZao4d1nQJuNi7k5COQ0yK6nFFeobPb5gTPdzGraSoTFpXaqNsdMTgNqZNNkmvDEV5AAkIqHMBUMyz8afp2LY3iy+jUBR807bqPjGkrWUrenBX0Hm+27umkjDu292IXbh1P+uyNK9+0vlJIR2AtaX/QYuTN4mcVOM+sQiHsKKIQadgplvhyAxWGsr/DE+G9/ViXtYVqdUpIFi2s0cI9sdK3u1/6RJARwB/hC9a2HZNTY1wv3hu/ouzI0B1jPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eB+lI9uJYpoxDMG0snQNE3PHGvB5gsifG1+DCTyiyNI=;
 b=m/FC3WfMfu4JlkjYHzLO6BD9eilBU1/HoRtb8MxC5dkwqXTYTNuTWXjlbIHro2O6KiGCOyQ7xwH2NsVGIEZTFvIDgS/BI3DDVynWBaHoCZJlg81B5w7uSekQPQUvg3v/7JWM6uVUSVMBbexnWmM35uitT4UeErSF8kFncUZxwQ1gXLAiGc1ou8k8USDlxXEaC5k7/Cud+ylL3xdnh4CIPMDWPbZmV6pAeOfBcW5j/5KVEEEKjOAGb9FppPHVvwIGZ/PVMK4bAKNA3cyMSFaOlSqj1pskoW+FYiF/iBq1/1YX+ACHTDFng1deS7MgfhkP4l8Zut4esHOrAp1idKUc6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eB+lI9uJYpoxDMG0snQNE3PHGvB5gsifG1+DCTyiyNI=;
 b=AKKSPSAhzJ/ElTW80L2XgygkwLodPFIQ3wIC4eZlvKWCRH6AgvSYiw6XlETI5gQtTxkWFy4O1s8WHexeyV76xvc0AhxFOa+UxPyapfhc/GGRX0oC7bO/HWtkprmadOfauwxirdeRjoxfU/AfPhcSosVt2k4fS7mbkT1dEgkHHQ4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB5843.namprd10.prod.outlook.com (2603:10b6:806:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 20:45:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 20:45:14 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 02/26] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Thread-Topic: [PATCH v3 02/26] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Thread-Index: AQHYzkZ2RtAdzRiFuU6Dz5JNuDSyC63tYV4AgAAc1oA=
Date:   Fri, 23 Sep 2022 20:45:14 +0000
Message-ID: <3c3bebb131501e844658066c84c4d6e1c9dce5e6.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-3-allison.henderson@oracle.com>
         <Yy4CqNJxPitsHvf+@magnolia>
In-Reply-To: <Yy4CqNJxPitsHvf+@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SA1PR10MB5843:EE_
x-ms-office365-filtering-correlation-id: eb95911b-0439-4d1b-bf83-08da9da4842c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zXXliZwf+tPucDTtLYQ43FXGgakiVqmt7eD2JL0a1AQDMEElRYxCTqDd/KH3dpYpmAPLs6tqDDEuWfsx3wC+9Sgx38fOiPhQVy91kBvduASwrArELfa5NLrkrf9x/SvocuSVeY3yyBVQewI66SKEAort1FH4xffRQpD/YsFn+qTRn/+/tnsCOE0f3nG5fpyWwMkUm0gCaZERIygPw2c8nM8O55odShbtiCKoCZsVRLp/aAkxikM1wEl4FOrRTteOscBzbCVRO/4QBoTm085aAL56IjnAqTFxtH7rMuT5H/yAfSYg4HAbymjriTXLVY/+IQoG83FPNNN/KNz3+jsEhytfmiqOY253v9q9oDIBLdjerzBxslqI4gO7Gu6YwPbm2jpj1z1wjv+tFtYvCSo4YBK5iAm1oGMQWX8iUAIZShwiM0MPpaQKwnx1gzUz0xX6YvRUVONT8z3JNZEVTYNfqGVwuKDCAAbM+VBuD7Kz1kAgHkqsn1YWjUinNYEhAgEyoBd5m6TIeKyfkO4u21xKVQV8t6w9bk2VZzmFfgSR/VyaNxpu7c8ZmlDQ/BZ4dAck9p8IHJNYwiH5nQgpw9Ji3Fn4dcYZxEsndbgV75Y+uSnVn06CQVhE63qD0cODN3K99+reyzmzV1A9nr08y8rXbn3HRkx+zyombZaP1ydB0fH8rnMLZLkOlBcof211t1kgKxaqutqmOHu3WRRR23QdBVyZmGUxYHGGYHFNbY12gmK7ZAzLEE+aZIsVRWlymhrpwYl19l9oqCBJU0OU4fv1vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(6506007)(8676002)(66476007)(66446008)(86362001)(66946007)(66556008)(41300700001)(4326008)(38070700005)(64756008)(76116006)(26005)(8936002)(6512007)(71200400001)(6486002)(316002)(36756003)(6916009)(478600001)(2906002)(186003)(2616005)(38100700002)(83380400001)(44832011)(122000001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWtEbzBnWC9vWlU1UDVKcjdEZVZwaTdkM2hkUDg2WHhLMHdtaUc5elRDeUQz?=
 =?utf-8?B?azNrRm9HQ1hGREQ2QTEzSzJGQWtJNXB6dXRlTFdyNHQ4elI2L2d4aDNXSjhu?=
 =?utf-8?B?Tnk3ak1iWklHMG52NjVSMHNJNnpZSDQwbHVrVGk1Z0w2RWhjeXUveER1VmZI?=
 =?utf-8?B?NFY1bW53dE9tWk04RFpHN2pFRWVWc25EdG5oTTdqOG5YY3FQV0pvV0Zjazlp?=
 =?utf-8?B?R0gzbXZST1RuTWdzc0piMlFrMjMxTkNyR0dsZ1d4N3N1MVNyckszeUVUL0VT?=
 =?utf-8?B?NDJuT0diWVo0TjZieXJwVS9oU01rbFd6SGhNTjFzZUQwcEQ4V0gwdlZVWGlO?=
 =?utf-8?B?RCt6b3Y2VWdaUWN3a1I5TkRPYmtCbUswdlpVenJPVVQyZS9IeDQvMmpjMjBY?=
 =?utf-8?B?U20rMlREVXY4ZlNwdytoV0hTTzE1Rk1hc3V6aXpRT3R5MFBoTEhVRHJlN0Ju?=
 =?utf-8?B?T2FtV09ENUVGbFM4SnpRM3ZPQjVaT0VWYW0yK2ZJdDVFMHF2TmNvUnhVYmFP?=
 =?utf-8?B?b1dSMWp2UDJpMVZBSG1xamxwWUprblNFTUp3bVlsdTBJZjlnekw0bU5tVW5Q?=
 =?utf-8?B?eHNDTURHalZBRVBKWVA1cENGRUpIRWc2bUJFbFY1ZVlreFlwY3luTElmMUpI?=
 =?utf-8?B?THU4ajhFNGxyUzZzdlFZeUpvWFh5UlMra1Z0WVlCdVlTeUphWVhSVkR3NHR4?=
 =?utf-8?B?VHNhYXFLdE1kUkoycTNHeW5UQ0pvb0RadDNlL1FGbWhUNUZ5R1dnK1FXTnlp?=
 =?utf-8?B?azFnZk9jK21FQmdvSWhPSHBaRjQxMFN0c2VVUDdIS0laS0R2RnZ3bXNBQVFx?=
 =?utf-8?B?UlNiOUNWcHZnT3BCNTJ2L0pQdi9JZzVYNkp2NFI0WThxQ0ZpK2JESUdQWkVV?=
 =?utf-8?B?dE9hZk1KUC9vSHU5RGh1RXdib2J1NDdjcC9vb1Q1a3J5SjJCT2picjl6OC8y?=
 =?utf-8?B?ZnR5Y3VsN0Jla1F3ODBHMUc0MzNNZTZzTjBGMjMxRjFWSE9EV0cwSW1Wa0pC?=
 =?utf-8?B?NkpYR2VzRmZjTEtNTDVPUWx4NWV5SmVjMTlOellyMFBUSmVUQ0NWYjRCenMx?=
 =?utf-8?B?UHQ2bDRKL0Q0Vjd6bEt2R1M4djFzcUt6N3BNem12QUF2Sy9zTHB3Y2FvZ0xm?=
 =?utf-8?B?Q0lZNm14dkFyOVUzazJ1VjRsZjhMb2xZSE1jaFFXWXlTSE15K2ZHdmM1VDdK?=
 =?utf-8?B?L2VnSjB0SGRqb2lIdE1lQVAwazhhQzh1akRDMlRLYzBnZ2NCZG5Ia0s4Q2x5?=
 =?utf-8?B?Si9pUUpReDBUVjI3UE5wQ0tMY0JvTHZSKzF5bmdscU9YYlEwblA4YlJKVVJl?=
 =?utf-8?B?WFEvbFZROVRDVFEwN3V4eTc2Q09ITlFQSlI3SHc5WmJRelExSGtxeDVHVVph?=
 =?utf-8?B?REl5YXlydDVBNXA1OU5iMlN1eFNqcjlOVjBhZzUwKzRmTE9uR0FhYjZXeTRh?=
 =?utf-8?B?NVJIbGJCV2RSN3QxaTg4OGx0RTR1dlFsSzBNbkVsMjZwSzRRZWhwWTBGekxV?=
 =?utf-8?B?MjR6cWt1clZrNGNiWDlTcU9pSzU1bVN6ZlQ4MmpSNjhlQTRWK1ZSR3FJMWk4?=
 =?utf-8?B?Y0FWcXN2N25VbTNkcUcwc0IrTkN5RFdWeTBDWnJ5YXlKbUtqUC8rTEVkU3Yv?=
 =?utf-8?B?SVhVelhBVDRwdUlWdmlKWlVCWFVWV2gxZk1uSDVSME1EM3R1emx6VDN0dFVx?=
 =?utf-8?B?eEdyaGkzN256OURNVEpXeFkxV3duN0ZuUGFFay9kc2Y5bWw3Wm9VSkRydnVT?=
 =?utf-8?B?OXZzck83cWtROVhaTDAyeXVDUEIzU0QwQlRtUmV5TFY5dXZiVlhoVUFPM2Ex?=
 =?utf-8?B?NU5JcmtOWGFNaUpDV1AyanIvNk91YXFyV25OcERQc3FYay9Nd2lOWVdUU1Z3?=
 =?utf-8?B?U2hQM2hWdCtSYVVaZUZkdTBheUdRd0xoQXVURnpFbWRqN2EwMEIwMisyNHF0?=
 =?utf-8?B?ZjBSRnVSRmR5S0IvSzJmSnJ6RlZEd0NLaEhxWUZ3VUN6N3lRMEtNdFRjZVc1?=
 =?utf-8?B?ZEF3Kzd6QTVGbFZNblBKODFRdDhMeFRZWVloZ0YzM1pvaW1lLzJlTGFLZXJv?=
 =?utf-8?B?ZTJuVHl1ckk2RFFhM1QwdFRKVFY4NkNuZW1xTWszNEZjUzFJS1dxbXA3Uy9n?=
 =?utf-8?B?OGp1Y1drYlNJNVNWZmxjblpyMDFDNFZLT1k1VitHMENpNDdWaGwxZm95eGZF?=
 =?utf-8?B?emc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F7DE8CC732714449725E904188ED0A1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb95911b-0439-4d1b-bf83-08da9da4842c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 20:45:14.3600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8xiPSQma842V58ml4rw2u+xrVVq3mDUVHjm2rs3DVhWqmNEGfwcYXwcwmRWYj/XaTQiTEDi5BTcqmzsJIWtHAiCZZKieSKfWADGB04sYNfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_09,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209230134
X-Proofpoint-GUID: oNbwE17BD3OujSJKP2GZ0l2jiIAdR9rJ
X-Proofpoint-ORIG-GUID: oNbwE17BD3OujSJKP2GZ0l2jiIAdR9rJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDEyOjAyIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMTA6NDQ6MzRQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+ID4gCj4gPiBSZW5hbWVzIHRoYXQgZ2VuZXJh
dGUgcGFyZW50IHBvaW50ZXIgdXBkYXRlcyBjYW4gam9pbiB1cCB0byA1Cj4gPiBpbm9kZXMgbG9j
a2VkIGluIHNvcnRlZCBvcmRlci7CoCBTbyB3ZSBuZWVkIHRvIGluY3JlYXNlIHRoZQo+ID4gbnVt
YmVyIG9mIGRlZmVyIG9wcyBpbm9kZXMgYW5kIHJlbG9jayB0aGVtIGluIHRoZSBzYW1lIHdheS4K
PiA+IAo+ID4gU2lnbmVkLW9mZi1ieTogQWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVy
c29uQG9yYWNsZS5jb20+Cj4gPiAtLS0KPiA+IMKgZnMveGZzL2xpYnhmcy94ZnNfZGVmZXIuYyB8
IDI4ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0KPiA+IMKgZnMveGZzL2xpYnhmcy94ZnNf
ZGVmZXIuaCB8wqAgOCArKysrKysrLQo+ID4gwqBmcy94ZnMveGZzX2lub2RlLmPCoMKgwqDCoMKg
wqDCoCB8wqAgMiArLQo+ID4gwqBmcy94ZnMveGZzX2lub2RlLmjCoMKgwqDCoMKgwqDCoCB8wqAg
MSArCj4gPiDCoDQgZmlsZXMgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMo
LSkKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy9saWJ4ZnMveGZzX2RlZmVyLmMgYi9mcy94
ZnMvbGlieGZzL3hmc19kZWZlci5jCj4gPiBpbmRleCA1YTMyMWI3ODMzOTguLmMwMjc5YjU3ZTUx
ZCAxMDA2NDQKPiA+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX2RlZmVyLmMKPiA+ICsrKyBiL2Zz
L3hmcy9saWJ4ZnMveGZzX2RlZmVyLmMKPiA+IEBAIC04MjAsMTMgKzgyMCwzNyBAQCB4ZnNfZGVm
ZXJfb3BzX2NvbnRpbnVlKAo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfdHJhbnPCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCp0cCwKPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgeGZzX2RlZmVyX3Jlc291cmNlc8KgwqDCoMKgwqDCoCpkcmVzKQo+ID4gwqB7Cj4gPiAtwqDC
oMKgwqDCoMKgwqB1bnNpZ25lZCBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgaTsKPiA+ICvCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpLCBqOwo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0Cj4g
PiB4ZnNfaW5vZGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpzaXBzW1hGU19ERUZF
Ul9PUFNfTlJfSU5PREVTXTsKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCp0ZW1wOwo+ID4gwqAKPiA+IMKgwqDCoMKgwqDC
oMKgwqBBU1NFUlQodHAtPnRfZmxhZ3MgJiBYRlNfVFJBTlNfUEVSTV9MT0dfUkVTKTsKPiA+IMKg
wqDCoMKgwqDCoMKgwqBBU1NFUlQoISh0cC0+dF9mbGFncyAmIFhGU19UUkFOU19ESVJUWSkpOwo+
ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqAvKiBMb2NrIHRoZSBjYXB0dXJlZCByZXNvdXJjZXMg
dG8gdGhlIG5ldyB0cmFuc2FjdGlvbi4gKi8KPiA+IC3CoMKgwqDCoMKgwqDCoGlmIChkZmMtPmRm
Y19oZWxkLmRyX2lub3MgPT0gMikKPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChkZmMtPmRmY19oZWxk
LmRyX2lub3MgPiAyKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyoKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBSZW5hbWVzIHdpdGggcGFyZW50IHBv
aW50ZXIgdXBkYXRlcyBjYW4gbG9jayB1cAo+ID4gdG8gNSBpbm9kZXMsCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICogc29ydGVkIGJ5IHRoZWlyIGlub2RlIG51bWJlci7CoCBT
byB3ZSBuZWVkIHRvCj4gPiBtYWtlIHN1cmUgdGhleQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAqIGFyZSByZWxvY2tlZCBpbiB0aGUgc2FtZSB3YXkuCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgbWVtc2V0KHNpcHMsIDAsIHNpemVvZihzaXBzKSk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZm9yIChpID0gMDsgaSA8IGRmYy0+ZGZjX2hlbGQuZHJfaW5vczsgaSsrKQo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzaXBzW2ld
ID0gZGZjLT5kZmNfaGVsZC5kcl9pcFtpXTsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAvKiBCdWJibGUgc29ydCBvZiBhdCBtb3N0IDUgaW5vZGVzICovCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZm9yIChpID0gMDsgaSA8IGRmYy0+ZGZjX2hlbGQu
ZHJfaW5vczsgaSsrKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGZvciAoaiA9IDE7IGogPCBkZmMtPmRmY19oZWxkLmRyX2lub3M7IGorKykKPiA+
IHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGlmIChzaXBzW2pdLT5pX2lubyA8IHNpcHNbai0xXS0KPiA+ID5pX2lubykg
ewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHRlbXAgPSBzaXBzW2pdOwo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHNpcHNbal0gPSBzaXBzW2otMV07Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgc2lwc1tqLTFdID0gdGVtcDsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoH0KPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfbG9j
a19pbm9kZXMoc2lwcywgZGZjLT5kZmNfaGVsZC5kcl9pbm9zLAo+ID4gWEZTX0lMT0NLX0VYQ0wp
Owo+ID4gK8KgwqDCoMKgwqDCoMKgfSBlbHNlIGlmIChkZmMtPmRmY19oZWxkLmRyX2lub3MgPT0g
MikKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGZzX2xvY2tfdHdvX2lub2Rl
cyhkZmMtPmRmY19oZWxkLmRyX2lwWzBdLAo+ID4gWEZTX0lMT0NLX0VYQ0wsCj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGRmYy0+ZGZjX2hlbGQuZHJfaXBbMV0sCj4gPiBYRlNfSUxPQ0tfRVhDTCk7Cj4gPiDC
oMKgwqDCoMKgwqDCoMKgZWxzZSBpZiAoZGZjLT5kZmNfaGVsZC5kcl9pbm9zID09IDEpCj4gPiBk
aWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhmcy94ZnNfZGVmZXIuaCBiL2ZzL3hmcy9saWJ4ZnMveGZz
X2RlZmVyLmgKPiA+IGluZGV4IDExNGEzYTQ5MzBhMy4uM2U0MDI5ZDJjZTQxIDEwMDY0NAo+ID4g
LS0tIGEvZnMveGZzL2xpYnhmcy94ZnNfZGVmZXIuaAo+ID4gKysrIGIvZnMveGZzL2xpYnhmcy94
ZnNfZGVmZXIuaAo+ID4gQEAgLTcwLDcgKzcwLDEzIEBAIGV4dGVybiBjb25zdCBzdHJ1Y3QgeGZz
X2RlZmVyX29wX3R5cGUKPiA+IHhmc19hdHRyX2RlZmVyX3R5cGU7Cj4gPiDCoC8qCj4gPiDCoCAq
IERlZmVycmVkIG9wZXJhdGlvbiBpdGVtIHJlbG9nZ2luZyBsaW1pdHMuCj4gPiDCoCAqLwo+ID4g
LSNkZWZpbmUgWEZTX0RFRkVSX09QU19OUl9JTk9ERVPCoMKgwqDCoMKgwqDCoMKgMsKgwqDCoMKg
wqDCoMKgLyogam9pbiB1cCB0byB0d28KPiA+IGlub2RlcyAqLwo+ID4gKwo+ID4gKy8qCj4gPiAr
ICogUmVuYW1lIHcvIHBhcmVudCBwb2ludGVycyBjYW4gcmVxdWlyZSB1cCB0byA1IGlub2RlcyB3
aXRoCj4gPiBkZWZlcmVkIG9wcyB0bwo+IAo+IHMvZGVmZXJlZC9kZWZlcnJlZC8KPiAKPiA+ICsg
KiBiZSBqb2luZWQgdG8gdGhlIHRyYW5zYWN0aW9uOiBzcmNfZHAsIHRhcmdldF9kcCwgc3JjX2lw
LAo+ID4gdGFyZ2V0X2lwLCBhbmQgd2lwLgo+ID4gKyAqIFRoZXNlIGlub2RlcyBhcmUgbG9ja2Vk
IGluIHNvcnRlZCBvcmRlciBieSB0aGVpciBpbm9kZSBudW1iZXJzCj4gPiArICovCj4gCj4gV2hl
biB3b3VsZCB3ZSBiZSBwcm9jZXNzaW5nICpmaXZlKiBkaWZmZXJlbnQgaW5vZGVzPwo+IAo+IERv
ZXMgdGhpcyBoYXBwZW4gd2hlbiBzcmNfaXAgaXMgYSBjaGlsZCBvZiBzcmNfZHAsIHRhcmdldF9p
cCBpcyBhCj4gY2hpbGQKPiBvZiB0YXJnZXRfZHAsIGFsbCBmb3VyIGlub2RlcyBhcmUgZGlzdGlu
Y3QsIGFuZCB0aGUgVkZTIGFza3MgdXMgdG8KPiBtb3ZlCj4gc3JjX2lwIGZyb20gc3JjX2RwIHRv
IHRhcmdldF9kcCwgdW5saW5rIHRhcmdldF9pcCBmcm9tIHRhcmdldF9kcCwKPiAqYW5kKgo+IGlu
c3RhbGwgYSB3aGl0ZW91dCBpbiB0aGUgZGlyZW50IGluIHNyY19kcD/CoCBJbiB3aGljaCBjYXNl
IHNyY19pcCwKPiB0YXJnZXRfaXAsIGFuZCB3aXAgYWxsIG5lZWQgcGFyZW50IHBvaW50ZXIgYWRq
dXN0bWVudHM/ClJpZ2h0LCB0aGUgc3JjX2lwIGlzIG92ZXJ3cml0aW5nIHRoZSB0YXJnZXRfaXAg
aW4gYW5vdGhlciBkaXJlY3RvcnkuCgo+IAo+IFNvIHRoYXQncyB0aHJlZSBpbm9kZXMgdGhhdCBu
ZWVkIHRvIHN0YXkgbG9ja2VkIGZvciBkZWZlcnJlZAo+IG9wZXJhdGlvbnM7Cj4gd2hhdCBhYm91
dCBzcmNfZHAgYW5kIHRhcmdldF9kcD/CoMKgCldlbGwgdGhleSBuZWVkIHRoZWlyIGRpcmVjdG9y
eSBlbnRyaWVzIHVwZGF0ZWQsIGFsc28gd2UgbmVlZCB0aGUKcGFyZW50cyB0byByZWNvbnN0cnVj
dCB3aGF0IHRoZSBvbGQgcGFyZW50IHBvaW50ZXIgZm9yIHRoZWlyIGNoaWxkcmVuCndlcmUgc28g
dGhhdCB3ZSBjYW4gcmVtb3ZlIHRoZSBjb3JyZWN0IG9uZSBmcm9tIHRoZSBjaGlsZCBpcHMuCgoK
PiBJIGRvbid0IHRoaW5rIHRoZXkgbmVlZCB0byBzdGF5Cj4gbG9ja2VkLCBidXQgT1RPSCBpdCdz
IHByb2JhYmx5IGVhc2llciAoZm9yIG5vdykgdG8gbG9jayBldmVyeXRoaW5nCj4gdW50aWwKPiB0
aGUgZW5kIG9mIHRoZSBlbnRpcmUgcmVuYW1lIG9wZXJhdGlvbiBpbnN0ZWFkIG9mIG1ha2luZyBl
dmVyeW9uZQo+IHJlYXNvbiBhYm91dCB3aGVuIHRoZXkgZmFsbCBvZmYgdGhlIHRyYW5zYWN0aW9u
IGNoYWluLCByaWdodD8KPiAKPiBJZiB0aGUgYW5zd2VyIHRvIGFsbCB0aGF0IGlzIHllcyBhbmQg
dGhlIHR5cG8gZ2V0cyBmaXhlZCwgdGhlbgoKSXQgbWFrZXMgc2Vuc2UgdG8gbWUgdGhhdCB0aGV5
IHNob3VsZCBzdGF5IGxvY2tlZC4gIFdpbGwgdXBkYXRlIHRoZQp0eXBvLgoKVGhhbmtzIGZvciB0
aGUgcmV2aWV3cyEKQWxsaXNvbgoKPiBSZXZpZXdlZC1ieTogRGFycmljayBKLiBXb25nIDxkandv
bmdAa2VybmVsLm9yZz4KPiAKPiAtLUQKPiAKPiA+ICsjZGVmaW5lIFhGU19ERUZFUl9PUFNfTlJf
SU5PREVTwqDCoMKgwqDCoMKgwqDCoDUKPiA+IMKgI2RlZmluZSBYRlNfREVGRVJfT1BTX05SX0JV
RlPCoMKgMsKgwqDCoMKgwqDCoMKgLyogam9pbiB1cCB0byB0d28gYnVmZmVycwo+ID4gKi8KPiA+
IMKgCj4gPiDCoC8qIFJlc291cmNlcyB0aGF0IG11c3QgYmUgaGVsZCBhY3Jvc3MgYSB0cmFuc2Fj
dGlvbiByb2xsLiAqLwo+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfaW5vZGUuYyBiL2ZzL3hm
cy94ZnNfaW5vZGUuYwo+ID4gaW5kZXggYzAwMGI3NGRkMjAzLi41ZWJiZmNlYjFhZGEgMTAwNjQ0
Cj4gPiAtLS0gYS9mcy94ZnMveGZzX2lub2RlLmMKPiA+ICsrKyBiL2ZzL3hmcy94ZnNfaW5vZGUu
Ywo+ID4gQEAgLTQ0Nyw3ICs0NDcsNyBAQCB4ZnNfbG9ja19pbnVtb3JkZXIoCj4gPiDCoCAqIGxv
Y2sgbW9yZSB0aGFuIG9uZSBhdCBhIHRpbWUsIGxvY2tkZXAgd2lsbCByZXBvcnQgZmFsc2UKPiA+
IHBvc2l0aXZlcyBzYXlpbmcgd2UKPiA+IMKgICogaGF2ZSB2aW9sYXRlZCBsb2NraW5nIG9yZGVy
cy4KPiA+IMKgICovCj4gPiAtc3RhdGljIHZvaWQKPiA+ICt2b2lkCj4gPiDCoHhmc19sb2NrX2lu
b2RlcygKPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2RlwqDCoMKgwqDCoMKgwqDC
oCoqaXBzLAo+ID4gwqDCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGlub2RlcywKPiA+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2lub2Rl
LmggYi9mcy94ZnMveGZzX2lub2RlLmgKPiA+IGluZGV4IGZhNzgwZjA4ZGM4OS4uMmVhZWQ5OGFm
ODE0IDEwMDY0NAo+ID4gLS0tIGEvZnMveGZzL3hmc19pbm9kZS5oCj4gPiArKysgYi9mcy94ZnMv
eGZzX2lub2RlLmgKPiA+IEBAIC01NzQsNSArNTc0LDYgQEAgdm9pZCB4ZnNfZW5kX2lvKHN0cnVj
dCB3b3JrX3N0cnVjdCAqd29yayk7Cj4gPiDCoAo+ID4gwqBpbnQgeGZzX2lsb2NrMl9pb19tbWFw
KHN0cnVjdCB4ZnNfaW5vZGUgKmlwMSwgc3RydWN0IHhmc19pbm9kZQo+ID4gKmlwMik7Cj4gPiDC
oHZvaWQgeGZzX2l1bmxvY2syX2lvX21tYXAoc3RydWN0IHhmc19pbm9kZSAqaXAxLCBzdHJ1Y3Qg
eGZzX2lub2RlCj4gPiAqaXAyKTsKPiA+ICt2b2lkIHhmc19sb2NrX2lub2RlcyhzdHJ1Y3QgeGZz
X2lub2RlICoqaXBzLCBpbnQgaW5vZGVzLCB1aW50Cj4gPiBsb2NrX21vZGUpOwo+ID4gwqAKPiA+
IMKgI2VuZGlmwqAvKiBfX1hGU19JTk9ERV9IX18gKi8KPiA+IC0tIAo+ID4gMi4yNS4xCj4gPiAK
Cg==
