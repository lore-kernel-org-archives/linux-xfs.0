Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5DAC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 04:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243980AbiDZE3K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 00:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244009AbiDZE3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 00:29:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E9E4EF5D
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 21:26:03 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q1c2Uf008853;
        Tue, 26 Apr 2022 04:25:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fQU1eX3UERwHp0ofaY0wArS1kCq7AIhhG87ptImC2DM=;
 b=yiC+qkYd7xLKvogk+A7zMfoVNkaCZfNeuhTXEOfwUd0jH30v33SG6/zD6WD8lrxUIHEa
 OC8tXuGlMdWJOKtm1peW+/1LgttNteCupf5BQudrTTaNKuyqJUEhY9cL6UCWJ+OiMQ5j
 6MjzOhWECTw5qzIm7mRiCC2IUWb0TPuO3X8KYbfjuqIL3GwB9+pRIoS4934vfo/3+RMX
 yT21cKcoB11KWm6L+D5k5+Ra7ZQnYwcYZ8PH2ZtKw5A1gRjO+yMZOnhGdIPjObz/weeX
 nvdF69tvHwbd1G9/oZzhv4NyrclmeMY359llPFQyg990Fl6Y0X6NNCdR6UUf8RiD4eZi QQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb0yvs1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 04:25:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23Q4KtQD003494;
        Tue, 26 Apr 2022 04:25:56 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fm7w2w4sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 04:25:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oObPGPqMfDxfOMvyJoW26LuSX9g71OSrr6OYW76xbdkoBYrAWzNE8fgkvn9hJgSkIVEB98v3jIU1A4nWHOZri2/83+62WWwARPFTx2pNJrS93JTOE9JOHpneXIgxjUcl8405gB7S32GmG7XOneJ6Mv5s5YkI/1+DztXGB68e4nmYLLhf9+eaPtl59SnPGJyb8+S3UgVaWsapjyk+fCtmk1HEiYqX98wxS2OfBswNwR3m+uUFVmlOM2ZFZXsi6whcgsUzctF0Xf7c7s4OSeD5++qLK5xeh67xjYB5hFFUarCAswThUDETlAnM45sJ/s0Q5XGG90z7uYhWUurLSeQWVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQU1eX3UERwHp0ofaY0wArS1kCq7AIhhG87ptImC2DM=;
 b=g0hJJ/nH/nvSueAH+U//oShzuDzPdHg3X9Z5/Ze72AknqSuxuorDRjFGm49/FfDpDOBFGmEo5SFNladpodkyn3qeh1N9uincu/8afMXvVOfyDI/97emlfuS86muHlS1F4QYBqI1djxgY6/NsqspVLCUOJYR1Ce4SZXZxfkfzQTDxS281ivR4QJawu2k+xGjMgioIUkDYFm7fQydT2NFPVAeNKYqAA6wxsIZVmY/+uGeVy23v3B+EYGj754a7Jc+/KmviGELfwYIPSBvzrBMaHB3+i7roZBv0q1Kj3nQKu/gK11OmS+5KX2G/MOXBFrcfP8a85TPbZL4lujPCVQl5Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQU1eX3UERwHp0ofaY0wArS1kCq7AIhhG87ptImC2DM=;
 b=jKTUeQeTvGa5uwaM8DHe4Bt+z/nKWiz0Q2srdWEbFN+BVlOlVh+fxWpXke3eysM1oTnEThb2J2FohSZZYDyHREzIEMF/O5t8eX9Nap67GDJ/xnLzLCsVUcVKxD8Na5dJegqxZJG2+dyvUwErhn49SYyoGjkGidb33JuXCoEl3ko=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BN0PR10MB5237.namprd10.prod.outlook.com (2603:10b6:408:120::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 26 Apr
 2022 04:25:55 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 04:25:55 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>
Subject: Re: [PATCH] xfs: revert "xfs: actually bump warning counts when we
 send warnings"
Thread-Topic: [PATCH] xfs: revert "xfs: actually bump warning counts when we
 send warnings"
Thread-Index: AQHYWSW4NU1ywCcam02DHt60qpAgtw==
Date:   Tue, 26 Apr 2022 04:25:54 +0000
Message-ID: <F4048726-FCF6-4E66-8233-4F9C0D20E15D@oracle.com>
References: <1650936818-20973-1-git-send-email-sandeen@redhat.com>
In-Reply-To: <1650936818-20973-1-git-send-email-sandeen@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc54ea1a-7289-4a39-dd38-08da273cdadc
x-ms-traffictypediagnostic: BN0PR10MB5237:EE_
x-microsoft-antispam-prvs: <BN0PR10MB5237A5050FF4B493C9A1C8A989FB9@BN0PR10MB5237.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zk5msL95wAhDfSzA9gFGcLVFKog2uaEEkZb0tXgIvJzbmA/HgdBnYYfrH9dujSzjGKe44L7e15aOhX7EJiO4REkN84LUFn5q93EWeoRCkTsYw0L05qh3QZHL+pPlFp+GN1mG8rCuAtD9ttCIUNYxTTMKXNxOmPmMREibD5JW+R69tYp2mP3bfGVnCrrVJGUifge2MWVlgDmRz+Ey/+wakSMGQ5kWOKhweHtDrqV4Ww7RZXcRZRjje1LLhozCCNuE87qlYuoo81eI7nwbWf+oHvLz+MY08SchqBpMVPcFopxVsdBK2KZWZyYwaO9/MDq+pRzv5HUfcScMdzdFrJrNCZVJqCflAJVe0qqdmb/RouEpmZLjSTZbwddKCBWxNlAPSUCMojEWAhkYp9TEtRUehWKdpa+HbGF4lo3nAdYlLSAQSRV7vUujtTTjW0Bl0PdlRiFic8YT+oIHD0MU/+S87P/nwshA/ydIODOy2vzpGSm0zzHqVtAlOIOJZxflkgxkDqfr+lctIwqLWkvsCeSPiAt04Rrr+xXl1KI3w8QX0FDKa9diSB1fekGoLHGGwU5t3W2R+QUqR2iYtrAKGrsQzovvJx96HTLYLkFoeBfkED61EhBS+rygtCWo1d0BBd1D2yrvzPDsjvQFuzAv6ICRrvTXQJR98Ruxxtzxp+i54fn71Ywpw5lVgSamZuX7ADGpB4o3yQbO4L+cAVP4mB5DYf+enbozkoNIraHY0AuoJe8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(2616005)(38100700002)(38070700005)(508600001)(6506007)(6512007)(6916009)(86362001)(186003)(53546011)(36756003)(44832011)(8936002)(4326008)(33656002)(2906002)(5660300002)(76116006)(66476007)(66556008)(66946007)(66446008)(64756008)(316002)(71200400001)(91956017)(54906003)(6486002)(83380400001)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TytWQnpkODhodnUwblZJY1dCMUZacFVwSGdqaktGQzNPUzI4TVdJbkg4Tzdt?=
 =?utf-8?B?RjJSWHhFQUIxeGp6QldyMFFrNmg1anpJZ1JOMEpuUkJpUlNXWWJPVXk3YnVK?=
 =?utf-8?B?WURWQitCZWFiVjJ1TE4venlEQm14V1gvUUtBc2trOWZRc0Q0c3ZjYUEwZ2hv?=
 =?utf-8?B?TWdmTVlXSER1dm0yZytNYUhxVjFNQmNrQTk3UzlVelpQN1p5SUJ6T2lTYXRY?=
 =?utf-8?B?b2Jtd0ZOUUZkK2hXc0t3aUd1QkNCR2c0REkweGMvd3l4bGJHZVZNNFB4OCtJ?=
 =?utf-8?B?OFhJbEN0Q2ZZVUE1cFpHeGg0MFRDNnhqOCtybEJ6ckZkSzlTcjZFZmNJbHAx?=
 =?utf-8?B?MGVFOU0rK2hUUEVnamtMVlFnc3lLTmFobStmTlJpcTZORSt4U1ZzZVlXMGty?=
 =?utf-8?B?Szh6Q3V3TGhWZHdaaTFJUlIyb0UyQVJJdDFyUUlJczg1ZEJjK0ZLNkhPTkV3?=
 =?utf-8?B?R3J2Mk40RnBzcGtMYnB3SGhreGtpVG1QQThqOHZTa2oySjlIUGtWWVVrM2Ft?=
 =?utf-8?B?bmNSdUh3N1QzbE91Nm5IZGNsQmJVaWxzR0pqbXAvbFNtbHpiUlVlellGa21w?=
 =?utf-8?B?dmkwVXk4RnFoNkt6TS95N2pDeldFRGhDU0ZBbnlGZFdOZlNmOVljQWp1MWs4?=
 =?utf-8?B?WXM1OHdRTmZlV01jd0lPbWVkbGJiTXNCNWVHeEI3cmE4RW9VZVhLaHV3eERH?=
 =?utf-8?B?MEthWGRpSGdlTUlOZGV2eWduZmNPMGVGOVNsd0RkMWV5WTdseHgwSlh5bnJW?=
 =?utf-8?B?Zld3WmtDazlQdFdWR1RmdUtUOE1ZbXhvcE1VV1V3WHJtNkVXS2pxRzFEc3ox?=
 =?utf-8?B?ZTIzenEwQm5iR2QvK0QyWUhaZHBjUWJlK2J1TGRHeFhYQVdDbHU1VHdpc2VF?=
 =?utf-8?B?dkVoenYxZ1ovY2IycWpWT2RVbGUrQlZZVCt1NGxnMEczdDVoK3k0dXBaQXhh?=
 =?utf-8?B?Tm9LZXJNSHlma2o0ZVFNRlZmRGNYRzEvUkw1azVnaW9hb0x1aFU2Y2ZNTUxl?=
 =?utf-8?B?dmV4cmtDMHN4M3llZUlQTHR1SEloYnRUWkNJUVBUS3NzNDBYaFhQWGkzZTVs?=
 =?utf-8?B?RWxVeXVIZGNsdVlxeUJJZjZCcy9rZGg1SVJ0TlpPR0w5bG1xMXpRbzE2L21F?=
 =?utf-8?B?UFVWUVRtVElhVC9jc25xc3M2dEFLTlY1REF4ZGl3cnU5QXQ4ekRoZXZNSGMw?=
 =?utf-8?B?VGMyWFdnZFYzdEQyQ2lha3pBMktIZEl2eTdBTll3VjZGSG5Fd3dvaElUckFs?=
 =?utf-8?B?VlRxbGVWeUN2Z2liZGJoWU1xMjJIamxsOGxXSFd2SUVsV1pFajYyRmZIR2wv?=
 =?utf-8?B?N1YxU3dqUkxxTzdYNkdlaCs4b0w2VTQ5czVna0ZYMVQzb2lsNHRJaHZXNC90?=
 =?utf-8?B?Q3hta21IaWVCWGNidlAwVWd2bDFCS1BxZWdiaHJ1U3NtcVZMdUFhd1AvcXZv?=
 =?utf-8?B?WWtYaHRwL2ZzZ0p2b2FPS2JKRnBGdnM4bzNoN0lnK3RBM3pYcTFaQ1l2YlQ1?=
 =?utf-8?B?YllDQ0NxM3Q4TmFCQXJvNVB5ZUJGWTFDcWdrSUZiVGhqOFZBVytxK05peFps?=
 =?utf-8?B?d2R4SFNrOGRDRW1EWXpRS0c4OHpLMHF1M3FDNUNkdy95YVBlYUxvazlzbUhr?=
 =?utf-8?B?ZEowNFdZZzloWlZleVhtRVVTR1BQR3BRRzgyZ1VMUDVFdStaMmw4Y0pudGlz?=
 =?utf-8?B?c251cGJMRjd3eFozeFZkaUFMRkljZGRJem1FU1pMbUkxd0Y5Zy95dHBDVVht?=
 =?utf-8?B?bHFpOEIxK2x5N1hYZkU2MFhHck5rdkd3cWNUa1RjSjY1SjRqdHNHSkg5emsx?=
 =?utf-8?B?aDFOM0JHREZIUGkxWE85akdVNkVoT1MwYzFlemVJOEdxOVdHa01WQmkyV2NB?=
 =?utf-8?B?TkZCTEI4UE9scnZoSmxPeng3eGNFckdydXVuRWozZlBiMVlOUkFnVlVFbGRw?=
 =?utf-8?B?Vk0wb28yanA3TGZNSTJqVVd4QUxReU1UNXBMZmRQbVhNNmw0N25PUFBKYVUy?=
 =?utf-8?B?RGtiTHhKRytaSC9qKzY2cWxsVTdwWjJ2SWZLR09BSjYvdE5qT2RxQ1hVeGlp?=
 =?utf-8?B?c2h2RlZQVExsWTJQT0lPT0RkUnY5WmIzYlRBeitNTThLYnVJVE8vYTg5MEt1?=
 =?utf-8?B?RHp2M0xEMk80NnhXTlJqT1dieUxVc3VzUllNM1AzdnJBeUFoc3p6Y2hZbCs2?=
 =?utf-8?B?RVNJWHRHZy91dzJwNi9RcUpLUmcrSVdzVXZFbForaUdYcXhxam4xeU9JK09o?=
 =?utf-8?B?b1NVL1YyM0ovU2U4ZkxwV1RQbjQydU5Vd0ZzK0U0TWN6K1BjUkcwS0ZKSzVp?=
 =?utf-8?B?MjZ2Y09yR045c256dExjZUhZZm11ZlNLd0xJSVZGOTIyNlpKUm5lSE5JOWNC?=
 =?utf-8?Q?FwwRtnjuUxkUhOVI4fRTPasdorFW0RaBnXDbMCR1s2+pH?=
x-ms-exchange-antispam-messagedata-1: Q6P5xymkf83Wv8W3wElCDdsynBEwqdFBrMlxYKdwDN/qczlogW4XnRf4
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F6CD8CA4CB89642AF4262C9087D2628@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc54ea1a-7289-4a39-dd38-08da273cdadc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 04:25:54.9462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MYPIqDqzBT/SGHpuaPxlLb1ROEf23gNUbxEt6H8KGM71UlGZRKbD4S8r88+UWtRFSdBmaDEQPqI8gdzBHw3HKZqAslWha24ttXbkCPEhTF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5237
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_01:2022-04-25,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260026
X-Proofpoint-ORIG-GUID: Nil4G5EAaAZ4yhy0hQIQ_mNf_rABnVZz
X-Proofpoint-GUID: Nil4G5EAaAZ4yhy0hQIQ_mNf_rABnVZz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBBcHIgMjUsIDIwMjIsIGF0IDY6MzMgUE0sIEVyaWMgU2FuZGVlbiA8c2FuZGVlbkByZWRo
YXQuY29tPiB3cm90ZToNCj4gDQo+IFRoaXMgcmV2ZXJ0cyBjb21taXQgNGI4NjI4ZDU3YjcyNWIz
MjYxNjk2NWU2Njk3NWZjZGViZTAwOGZlNy4NCj4gDQo+IFhGUyBxdW90YSBoYXMgaGFkIHRoZSBj
b25jZXB0IG9mIGEgInF1b3RhIHdhcm5pbmcgbGltaXQiIHNpbmNlDQo+IHRoZSBlYXJsaWVzdCBJ
cml4IGltcGxlbWVudGF0aW9uLCBidXQgYSBtZWNoYW5pc20gZm9yIGluY3JlbWVudGluZw0KPiB0
aGUgd2FybmluZyBjb3VudGVyIHdhcyBuZXZlciBpbXBsZW1lbnRlZCwgYXMgZG9jdW1lbnRlZCBp
biB0aGUNCj4geGZzX3F1b3RhKDgpIG1hbiBwYWdlLiBXZSBkbyBrbm93IGZyb20gdGhlIGhpc3Rv
cmljYWwgYXJjaGl2ZSB0aGF0DQo+IGl0IHdhcyBuZXZlciBpbmNyZW1lbnRlZCBhdCBydW50aW1l
IGR1cmluZyBxdW90YSByZXNlcnZhdGlvbg0KPiBvcGVyYXRpb25zLg0KPiANCj4gV2l0aCB0aGlz
IGNvbW1pdCwgdGhlIHdhcm5pbmcgY291bnRlciBxdWlja2x5IGluY3JlbWVudHMgZm9yIGV2ZXJ5
DQo+IGFsbG9jYXRpb24gYXR0ZW1wdCBhZnRlciB0aGUgdXNlciBoYXMgY3Jvc3NlZCBhIHF1b3Rl
IHNvZnQNCj4gbGltaXQgdGhyZXNob2xkLCBhbmQgdGhpcyBpbiB0dXJuIHRyYW5zaXRpb25zIHRo
ZSB1c2VyIHRvIGhhcmQNCj4gcXVvdGEgZmFpbHVyZXMsIHJlbmRlcmluZyBzb2Z0IHF1b3RhIHRo
cmVzaG9sZHMgYW5kIHRpbWVycyB1c2VsZXNzLg0KPiBUaGlzIHdhcyByZXBvcnRlZCBhcyBhIHJl
Z3Jlc3Npb24gYnkgdXNlcnMuDQo+IA0KPiBCZWNhdXNlIHRoZSBpbnRlbmRlZCBiZWhhdmlvciBv
ZiB0aGlzIHdhcm5pbmcgY291bnRlciBoYXMgbmV2ZXIgYmVlbg0KPiB1bmRlcnN0b29kIG9yIGRv
Y3VtZW50ZWQsIGFuZCB0aGUgcmVzdWx0IG9mIHRoaXMgY2hhbmdlIGlzIGEgcmVncmVzc2lvbg0K
PiBpbiBzb2Z0IHF1b3RhIGZ1bmN0aW9uYWxpdHksIHJldmVydCB0aGlzIGNvbW1pdCB0byBtYWtl
IHNvZnQgcXVvdGENCj4gbGltaXRzIGFuZCB0aW1lcnMgb3BlcmFibGUgYWdhaW4uDQo+IA0KPiBG
aXhlczogNGI4NjI4ZDU3YjcyICgieGZzOiBhY3R1YWxseSBidW1wIHdhcm5pbmcgY291bnRzIHdo
ZW4gd2Ugc2VuZCB3YXJuaW5ncykNCj4gU2lnbmVkLW9mZi1ieTogRXJpYyBTYW5kZWVuIDxzYW5k
ZWVuQHJlZGhhdC5jb20+DQoNClRoaXMgbG9va3MgZmluZSB0byBtZS4gSeKAmW0gYWxzbyBoYXBw
eSB0byB3b3JrIG9uIHJlbW92aW5nIHRoZSByZXN0IG9mIHRoZQ0KcXVvdGEgd2FybmluZyBpbmZy
YXN0cnVjdHVyZS4NCg0KUmV2aWV3ZWQtYnk6IENhdGhlcmluZSBIb2FuZyA8Y2F0aGVyaW5lLmhv
YW5nQG9yYWNsZS5jb20+DQo+IC0tLQ0KPiBmcy94ZnMveGZzX3RyYW5zX2RxdW90LmMgfCAxIC0N
Cj4gMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94
ZnMveGZzX3RyYW5zX2RxdW90LmMgYi9mcy94ZnMveGZzX3RyYW5zX2RxdW90LmMNCj4gaW5kZXgg
OWJhN2U2Yi4uZWJlMmMyMiAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL3hmc190cmFuc19kcXVvdC5j
DQo+ICsrKyBiL2ZzL3hmcy94ZnNfdHJhbnNfZHF1b3QuYw0KPiBAQCAtNjAzLDcgKzYwMyw2IEBA
DQo+IAkJCXJldHVybiBRVU9UQV9OTF9JU09GVExPTkdXQVJOOw0KPiAJCX0NCj4gDQo+IC0JCXJl
cy0+d2FybmluZ3MrKzsNCj4gCQlyZXR1cm4gUVVPVEFfTkxfSVNPRlRXQVJOOw0KPiAJfQ0KPiAN
Cj4gLS0gDQo+IDEuOC4zLjENCj4gDQoNCg==
