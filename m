Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544AAC07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 20:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiIWUrV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIWUqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 16:46:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1675BE21E2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 13:44:22 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NJF4OY026865;
        Fri, 23 Sep 2022 20:44:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=fnAbwKWXlA+jv89sgOKi8Iwaqrw/Wi+LptGVD2eABsc=;
 b=3C3vhJ6miRdBbl7kkbZQR0j+6ff6upsmEQUdliTwUscT2RqtiPup9s9NRnxiASI83xyP
 VyxlGL+GqWyvLpchBSPdLm0HEN/7Y8z9fqQUAcZEzvlAnGIXWdlrTuBMoh4Oa+aUGCnz
 YV/BBZsUmc4iqUWIDMtrw9RuvQXe2G/yZ0NQLv4wpXjW+uNHegM1gL7VB3JpRmM5f6zg
 E5R2N61qAdaO7Kp/1Mk4mT8hkHYSi1x9VcLnSA7V/BNT9m4xxDQQN1dRXiR1nLdmrrjp
 R8IE3AClJcXuQ25XCTMu5v6Fy5PuPoIY+RpRy/8kh/1YL54okrQqW0qXeEo9n5zfwDz9 tQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stt7e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 20:44:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28NJuZDO005677;
        Fri, 23 Sep 2022 20:44:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cs3bbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 20:44:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pqk4f/yhwOZOsCFW1lJDaiMkMcy/TGO1nLr3ejBTYOS1fHrmvExqrF3/Dc/x0cvqoHd+HHDCuBOtMTBZM7SxLuCr0cfjRi4pBOrt29UOMRtMnaKAvuY0RDrRH+TnSlM3UXlpAC4pFatEyRMCQRr0/xaeo4SuU5KszA40FenM7m5pgsAzV9RmRig42yLqJGtrO8ryYMkRQuV5zaGSxH337UIDeYiLkXmK2fAOJmXar9WihAzuJPiZXvAhTB76n42Jky8lY2QfQzdfOhSXhskAln+VohQXn7/k/QJNUfwi7XwUZqTkgMlwgmqud2+o8iMulsu9LGt+sJeVGvgN/Yf1sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fnAbwKWXlA+jv89sgOKi8Iwaqrw/Wi+LptGVD2eABsc=;
 b=fwFAlSDb9Pbh7Yab+3r0JRxxak2Kai8Tp4zltMBXyO3xcqUGlVaSbNb3hZObrBcVcrHme8oh0M+5fikB4L79wi7MVNRN3NU/jVeFbmSPOHhtjsuTSjcVKwg5OwqTaqLXv7KRrJhR1GSgQdzuT1qJqpyc7SNui3VlfgJ/t1pxe5gr8110B4Skv+/z62cnRi0HlkHvMoVI4ytXJkGRlKlOHG8u8emxKVbOatVWG9omAZt0owsgFrjEp/S36SvX9b4UT+3K31anANoU8NeuzoX1I/eB7nClN45HkG+T/lxJPvA5RlMOFDy+x07iIluG2IAHpttnHIRvPkKVaqCgn8wzpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnAbwKWXlA+jv89sgOKi8Iwaqrw/Wi+LptGVD2eABsc=;
 b=M7cxv26/AeE3ALps3MlGmd+sBJwHiSxsDem3cairnhc/JbcBP43Pm2HM6ldfRkS/bOFFf7hjwcyjhGii3UrkEfkkAnyUaUXx7/4GQw5/kBFv3WvelzXtVEGjfcqciXf9j821Ehg+LBJfiBmTTk/j5FjUj6/PXvmjsSIjKG2msbw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY8PR10MB6804.namprd10.prod.outlook.com (2603:10b6:930:9b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 20:44:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 20:44:06 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 04/26] xfs: Hold inode locks in xfs_trans_alloc_dir
Thread-Topic: [PATCH v3 04/26] xfs: Hold inode locks in xfs_trans_alloc_dir
Thread-Index: AQHYzkZ4TUq0mAF0vUmsLyDvHcWlcq3tYhmAgAAbyoA=
Date:   Fri, 23 Sep 2022 20:44:06 +0000
Message-ID: <30635d0fdc31146c43d6b1b071ba13efd86ff312.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-5-allison.henderson@oracle.com>
         <Yy4DRQ8MDJBmuntO@magnolia>
In-Reply-To: <Yy4DRQ8MDJBmuntO@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CY8PR10MB6804:EE_
x-ms-office365-filtering-correlation-id: 26071b7f-a798-4371-2768-08da9da45b75
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GO7jwThf7ClqYV0xag7SQ8KSUG+E6kEOcvefDTuqAandRkmuYeEqYGepERKAwkzm2HmvQ1KWq5VvTiyMCTArlFfSntSAqkC+XMu5T9z/5SyQ9xysOgjRM9swWAshh3Shm80BZ6pvCOBbOasL/vIqEz5fJlZaM5pUAHji2oMSphGHoFplPLQ1iSt8UYf/j7LZRRdKhsLqR8+NFnR1Wn93mfMHvCKcM6JUL6xiD0LNCiVdwNYQmYZ1Ig/9X0wbh5h0NRbBliJeVpdfAGjo9gjK4yHN7K4gJfony5bHCswcey+ykNHrccH9byvXsic2Oy9eV0jy0bWiksFiK3wrFSf+3INySmC79cbudERQ1MeQE5rhglwy4yLqMn6UXnDVK33i32CL6trT//Yr/sabi6zUi0HqKl9+ZIY5FC3BIrXU57Hxol2xCzB7i59a849z5hmBkHYT48Q1yIRjMYkYuKsJLcsP7b5VLA0idJ9omlVX5uZ8vUsiln0XIip11tcnEaDXkrxNZe5LWhmAGWE2cGrONhSIYRpTEqHESoER2wsIaHeEpU83gj0rfWWHrj6FxtdStz5vFFe3Yi/lf0QJyg+8EnqmXKc2IPajAaQA+TUJNGUoJ5TWk6vpO5jajpYrYZ5Jo7LM3lNStPKXXRfWlIcSVFcnY+D5vPMu4AU9MMeALQ9wdtYR263LCBct9ZgkusaYwx8WQdXu9nprYZVW5c6BKik7JgH/U5IT7KJUFV2pTZrzHO1vhb5PBMngrHMaxMtTkQK1HyShfO3gNC5GMxuEvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(38100700002)(44832011)(71200400001)(478600001)(38070700005)(6486002)(66446008)(2616005)(64756008)(66476007)(83380400001)(66946007)(186003)(86362001)(66556008)(4326008)(26005)(6916009)(6512007)(2906002)(6506007)(76116006)(36756003)(5660300002)(8936002)(8676002)(122000001)(316002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEJJdzBVQ29lTVUyVURyMFJmczQzU1JoMWZxMk9aaWdJMU1yZWJ0eUo5Q0hm?=
 =?utf-8?B?bTFaaE05NHQ1ZGIwOXFIYnc2VmpJWnloeHhvY3l0SzhGZlpMdVU5amVENmwr?=
 =?utf-8?B?ZzFaa3FkYXdZaExXd2VxbVZTa1VqR3A1blBvQUJzV0t2M1M1Mnlxc0ZLK0NG?=
 =?utf-8?B?bDRpMTlGekx0SnBsMkJKS3R5bHRQOWlRZ2I0VlFNbWVNakNLOXkvVTEwb3J5?=
 =?utf-8?B?aW9LRWM2akpCdnVEMVkvclVjTzRvNGlQTkJ3NmtOSnJiU25KUXBuNWtCRGNl?=
 =?utf-8?B?SUUvTWtPbGp6SkxUVVJ1QlNBSXZDN0JmelR1ekZDZ0FmeE5DbmhoNlNBTk44?=
 =?utf-8?B?aVBLZjkwVHU2K1NDWlZROUY0V3ZxeCs0eWZvYUkyYXJpUnhwK0VmelpvMlJq?=
 =?utf-8?B?M2k2b1VUdVNQRlFVNERFYkxkTk9RT3JpWDdNUWNxT2FzdVh4RktXaEt3alZI?=
 =?utf-8?B?MGl3Tkxla2RjcUJxdTNFYUFFLytGYyt3RmJITnVpOUdqT2NzWEowNW5tUTN0?=
 =?utf-8?B?WTBsalh5ZjhnRVZrWEpTVmZkSW5hTDR0eW1UM2poUTkwVk1WZXFhOEo1Nmti?=
 =?utf-8?B?TXNvSnd6UFZTWS9VeitjYXNuTEQ5YWpUUDJmSEtPRUxOa29WY29DK1JOMFA1?=
 =?utf-8?B?eGQvak1Gbi9GL2VsNGpOU2JIeXdyRTJKc2dRQ3VuL0w3MGRhUmZYNEw5alNp?=
 =?utf-8?B?Z2tjSDMwVnI3QnVIQ3dvWEFrbFhWaFp3NHQ1RTllakdoeEZRZ2JrRldqcVdX?=
 =?utf-8?B?MVdscDZrM1lQbVp0WXlvN25idm03VFRoMjFqb1ZtOVF0anhLdHhjZ2RqSDRh?=
 =?utf-8?B?SWRrekZVK0RjeVVxMXo5RE1sUmNwdU5XeGYwQ0ZGUUs1M3k1WmtTemorWWRX?=
 =?utf-8?B?andkOWU3TzV5UGRvVGprZU4wM0o1VjJzZzdkUFNicko0cEtYa3lVS01Hcnpn?=
 =?utf-8?B?ZTY0M25sb0FocUFkNjFUdXJ2Wk1VbG5HRnIxRk5DSExMOE1LTWMzbXBMR2xX?=
 =?utf-8?B?a2YyNnVQdm80bUVqbEFRWDRGVDNPT1d2TUJ6R1FvQlMwK1FzVFhzbFYxcHhE?=
 =?utf-8?B?YllERm9hUEhOM3pFa0NjL2RUNFdYSThYSGMxbmg2eHRReS9oU3lNQ091U3hT?=
 =?utf-8?B?dnNhU1loNk5qVnFPa2RTVk1Gbm9rMDRxdVI5RVpRT3RqK2lCdDBSZnlrbFlP?=
 =?utf-8?B?WGZncHhGTFhZazVnSU8vS3FBWXVmQWlBV1ljcklodFZIckRwc0dFTnlKN1RU?=
 =?utf-8?B?UXhpa0o3S0tyOGNWM2h6VzNjOWtBZ2hqV1hocVdEdTZTTEEyRlNZWXcxeXpZ?=
 =?utf-8?B?U2ltWVJoY1I2M2FDNm9TMU0yQ1h4Sm00ckNQNitOZE50WmRJbTFLZWNVOHgy?=
 =?utf-8?B?SzljSnZ2VDhsTVpldlZuTUh3TkpmVEFhZzF2V1VLOWY2bmtBREFRUFVyYkcv?=
 =?utf-8?B?VjBSS3VNUjd2YmcyZTRoVzVNZWhpZVhEdTh2N3VWSCtQelpOMHJwRGU0bHJk?=
 =?utf-8?B?bmd2a0lVOXBjVmdpVDI3Q3UxanFtblBKdkVKeG9QcDNzaHovU3dwbG9yQlVH?=
 =?utf-8?B?RmVqeno0WlBMVnIxbFFWNTZNVWUxUnRFZldoVnBCclFCZjZoQUxKeVJEL01I?=
 =?utf-8?B?MkswcDNaQnBRREhzK0EzenBzbUVXeUZzeURCYWIrMEhwT2FhZUZacXRHMU5W?=
 =?utf-8?B?M0hRR21CUFYxOHVaYkhWaVNMYTk3NlhYUlA4WGNWZVNMdDRrZGhHWGU3NzUx?=
 =?utf-8?B?OGt1djlZenFua1IxZFJlRlZsR014QjJ1c1hVRVJMN0NnQitwSzNMYkkxclJv?=
 =?utf-8?B?V2p0bng4akl6MkUxWTZ0VTVHU3lGYU1UTGU2ejZMWGN3SnRhOGMzbklmRFNu?=
 =?utf-8?B?SzhyTm5VSE9PcFlnbG9zZlp5QTFzWTFpME04bTZPMUxvK2lhZzN3MGo1T0RZ?=
 =?utf-8?B?YjBDMHk5NVR4OUhBZDdNTFFzU2JuSlZDZmpjSVhTTlF6dXdvWWRYQ1NaelVs?=
 =?utf-8?B?SnYvR3ZkazdsRU9TVHoxc2FJUTlqalBGSEpNZktQQjFvRGtKU0NhMldBOFB3?=
 =?utf-8?B?TXhKZHF2MmNtYmxGL2VHUnNyM2lrS2xOejRxVE9LdncxZkZLQlIzU3FhYThw?=
 =?utf-8?B?Sk9maWRuOGgwcUtRblg5VXpIS0gwbkFLcGk3Ri9KclFZWkVzZU1UQ3FJQkRr?=
 =?utf-8?B?Y3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F2738E2056F95418DFF3B070D11B1A1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26071b7f-a798-4371-2768-08da9da45b75
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 20:44:06.0636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FCO3kIag+zaiDRqgSsD5rGAOqmMeRBEIQTqcOrC4opWm27xDctg2e2/lz7qOeAvRBs2YRINXj/cpLj2PObVOzlNuq134Kc++dMGQ5G5ut3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6804
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_09,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209230134
X-Proofpoint-GUID: 0_2TgyMUliuOgDSjQ9UkRDnGBDBbNGqS
X-Proofpoint-ORIG-GUID: 0_2TgyMUliuOgDSjQ9UkRDnGBDBbNGqS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDEyOjA0IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMTA6NDQ6MzZQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+ID4gCj4gPiBNb2RpZnkgeGZzX3RyYW5zX2Fs
bG9jX2RpciB0byBob2xkIGxvY2tzIGFmdGVyIHJldHVybi7CoCBDYWxsZXIgd2lsbAo+ID4gYmUK
PiA+IHJlc3BvbnNpYmxlIGZvciBtYW51YWwgdW5sb2NrLsKgIFdlIHdpbGwgbmVlZCB0aGlzIGxh
dGVyIHRvIGhvbGQKPiA+IGxvY2tzCj4gPiBhY3Jvc3MgcGFyZW50IHBvaW50ZXIgb3BlcmF0aW9u
cwo+ID4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGxpc29uIEhlbmRlcnNvbiA8YWxsaXNvbi5oZW5k
ZXJzb25Ab3JhY2xlLmNvbT4KPiAKPiBMb29rcyBvaywKPiBSZXZpZXdlZC1ieTogRGFycmljayBK
LiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4KR3JlYXQsIHRoYW5rcyEKQWxsaXNvbgo+IAo+IC0t
RAo+IAo+ID4gLS0tCj4gPiDCoGZzL3hmcy94ZnNfaW5vZGUuYyB8IDE0ICsrKysrKysrKysrKy0t
Cj4gPiDCoGZzL3hmcy94ZnNfdHJhbnMuYyB8wqAgNiArKysrLS0KPiA+IMKgMiBmaWxlcyBjaGFu
Z2VkLCAxNiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0
IGEvZnMveGZzL3hmc19pbm9kZS5jIGIvZnMveGZzL3hmc19pbm9kZS5jCj4gPiBpbmRleCBmMjFm
NjI1YjQyOGUuLjlhMzE3NGE4Zjg5NSAxMDA2NDQKPiA+IC0tLSBhL2ZzL3hmcy94ZnNfaW5vZGUu
Ywo+ID4gKysrIGIvZnMveGZzL3hmc19pbm9kZS5jCj4gPiBAQCAtMTI3NywxMCArMTI3NywxNSBA
QCB4ZnNfbGluaygKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoeGZzX2hhc193c3luYyhtcCkgfHwg
eGZzX2hhc19kaXJzeW5jKG1wKSkKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
eGZzX3RyYW5zX3NldF9zeW5jKHRwKTsKPiA+IMKgCj4gPiAtwqDCoMKgwqDCoMKgwqByZXR1cm4g
eGZzX3RyYW5zX2NvbW1pdCh0cCk7Cj4gPiArwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc190cmFu
c19jb21taXQodHApOwo+ID4gK8KgwqDCoMKgwqDCoMKgeGZzX2l1bmxvY2sodGRwLCBYRlNfSUxP
Q0tfRVhDTCk7Cj4gPiArwqDCoMKgwqDCoMKgwqB4ZnNfaXVubG9jayhzaXAsIFhGU19JTE9DS19F
WENMKTsKPiA+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBlcnJvcjsKPiA+IMKgCj4gPiDCoCBlcnJv
cl9yZXR1cm46Cj4gPiDCoMKgwqDCoMKgwqDCoMKgeGZzX3RyYW5zX2NhbmNlbCh0cCk7Cj4gPiAr
wqDCoMKgwqDCoMKgwqB4ZnNfaXVubG9jayh0ZHAsIFhGU19JTE9DS19FWENMKTsKPiA+ICvCoMKg
wqDCoMKgwqDCoHhmc19pdW5sb2NrKHNpcCwgWEZTX0lMT0NLX0VYQ0wpOwo+ID4gwqAgc3RkX3Jl
dHVybjoKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IgPT0gLUVOT1NQQyAmJiBub3NwYWNl
X2Vycm9yKQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IG5vc3Bh
Y2VfZXJyb3I7Cj4gPiBAQCAtMjUxNiwxNSArMjUyMSwyMCBAQCB4ZnNfcmVtb3ZlKAo+ID4gwqAK
PiA+IMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc190cmFuc19jb21taXQodHApOwo+ID4gwqDC
oMKgwqDCoMKgwqDCoGlmIChlcnJvcikKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBnb3RvIHN0ZF9yZXR1cm47Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290
byBvdXRfdW5sb2NrOwo+ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoaXNfZGlyICYmIHhm
c19pbm9kZV9pc19maWxlc3RyZWFtKGlwKSkKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgeGZzX2ZpbGVzdHJlYW1fZGVhc3NvY2lhdGUoaXApOwo+ID4gwqAKPiA+ICvCoMKgwqDC
oMKgwqDCoHhmc19pdW5sb2NrKGlwLCBYRlNfSUxPQ0tfRVhDTCk7Cj4gPiArwqDCoMKgwqDCoMKg
wqB4ZnNfaXVubG9jayhkcCwgWEZTX0lMT0NLX0VYQ0wpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiAwOwo+ID4gwqAKPiA+IMKgIG91dF90cmFuc19jYW5jZWw6Cj4gPiDCoMKgwqDCoMKgwqDC
oMKgeGZzX3RyYW5zX2NhbmNlbCh0cCk7Cj4gPiArIG91dF91bmxvY2s6Cj4gPiArwqDCoMKgwqDC
oMKgwqB4ZnNfaXVubG9jayhpcCwgWEZTX0lMT0NLX0VYQ0wpOwo+ID4gK8KgwqDCoMKgwqDCoMKg
eGZzX2l1bmxvY2soZHAsIFhGU19JTE9DS19FWENMKTsKPiA+IMKgIHN0ZF9yZXR1cm46Cj4gPiDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuIGVycm9yOwo+ID4gwqB9Cj4gPiBkaWZmIC0tZ2l0IGEvZnMv
eGZzL3hmc190cmFucy5jIGIvZnMveGZzL3hmc190cmFucy5jCj4gPiBpbmRleCA3YmQxNmZiZmY1
MzQuLmFjOThmZjQxNmU1NCAxMDA2NDQKPiA+IC0tLSBhL2ZzL3hmcy94ZnNfdHJhbnMuYwo+ID4g
KysrIGIvZnMveGZzL3hmc190cmFucy5jCj4gPiBAQCAtMTM1Niw2ICsxMzU2LDggQEAgeGZzX3Ry
YW5zX2FsbG9jX2ljaGFuZ2UoCj4gPiDCoCAqIFRoZSBjYWxsZXIgbXVzdCBlbnN1cmUgdGhhdCB0
aGUgb24tZGlzayBkcXVvdHMgYXR0YWNoZWQgdG8gdGhpcwo+ID4gaW5vZGUgaGF2ZQo+ID4gwqAg
KiBhbHJlYWR5IGJlZW4gYWxsb2NhdGVkIGFuZCBpbml0aWFsaXplZC7CoCBUaGUgSUxPQ0tzIHdp
bGwgYmUKPiA+IGRyb3BwZWQgd2hlbiB0aGUKPiA+IMKgICogdHJhbnNhY3Rpb24gaXMgY29tbWl0
dGVkIG9yIGNhbmNlbGxlZC4KPiA+ICsgKgo+ID4gKyAqIENhbGxlciBpcyByZXNwb25zaWJsZSBm
b3IgdW5sb2NraW5nIHRoZSBpbm9kZXMgbWFudWFsbHkgdXBvbgo+ID4gcmV0dXJuCj4gPiDCoCAq
Lwo+ID4gwqBpbnQKPiA+IMKgeGZzX3RyYW5zX2FsbG9jX2RpcigKPiA+IEBAIC0xMzg2LDggKzEz
ODgsOCBAQCB4ZnNfdHJhbnNfYWxsb2NfZGlyKAo+ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqB4
ZnNfbG9ja190d29faW5vZGVzKGRwLCBYRlNfSUxPQ0tfRVhDTCwgaXAsCj4gPiBYRlNfSUxPQ0tf
RVhDTCk7Cj4gPiDCoAo+ID4gLcKgwqDCoMKgwqDCoMKgeGZzX3RyYW5zX2lqb2luKHRwLCBkcCwg
WEZTX0lMT0NLX0VYQ0wpOwo+ID4gLcKgwqDCoMKgwqDCoMKgeGZzX3RyYW5zX2lqb2luKHRwLCBp
cCwgWEZTX0lMT0NLX0VYQ0wpOwo+ID4gK8KgwqDCoMKgwqDCoMKgeGZzX3RyYW5zX2lqb2luKHRw
LCBkcCwgMCk7Cj4gPiArwqDCoMKgwqDCoMKgwqB4ZnNfdHJhbnNfaWpvaW4odHAsIGlwLCAwKTsK
PiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfcW1fZHFhdHRhY2hfbG9ja2Vk
KGRwLCBmYWxzZSk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycm9yKSB7Cj4gPiAtLSAKPiA+
IDIuMjUuMQo+ID4gCg==
