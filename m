Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03B9C77B71
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Apr 2023 23:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjDNXQC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Apr 2023 19:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjDNXQB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2023 19:16:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D71D30D8
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 16:16:00 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33EMOF8E028008;
        Fri, 14 Apr 2023 23:15:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DIj8RTgPki4bI59ks0SPT5TVXVXm35VXLLJXtGADGNY=;
 b=2rGP0E4jbneHRazUKeUizCLw6WBQ+Qpp5I7xqcoCaZhjV326MmLlCblOtsZf+bn6YMzp
 6V/iE4gtJ3omaYRYhlvlIHiuhII1rA77gcMLcBuHBxKhpbdqcPE7bn28nSQDzglaWH6e
 uIQFf+lNiHRgKvBfp/6KkhudxR7P8XfZt8pE+sP8L/aGA2T1QkHh9AY9rBtKkFs4Hmrp
 emRAIgCZ91dKz2n2Oe3cLhBUSDdB/qNy4PWax85uw9/DqSsuk0iMJXlr8YPJPgixD6nw
 e4lltZg7Fcoe3znUAFM9w9honb0psWgyqe6hDnr5iunj3sqZaNBWDVvSELYAgPbxSso8 BA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7py95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 23:15:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33EKIeVc040409;
        Fri, 14 Apr 2023 23:15:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw8cexpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 23:15:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJjJeK2iBYZ9zTkd4/GXjQkKEILInWqUYkdacu/klIN2fJOmSxBWsoQURz9alyMmEYPgkEzLcfD6Ys6nIWillu6eDFA2FT/+Tx+W8KXLjvVa1Qeyjz9YIDMeaQVy3/2/plR1jYZ67bVGFm/xlw5kdrakP2JfzrfylzXBNOVr+kw2jcDQc7oWidgE4rN0ZGlThUm4WY4GbrokSkOVfjR3tiuF/UBPlylmDqYChBQeB+x64fi24spL7V/Qf8ZOevgBO/5FMDHjOyO885k0VB/m1DAhIsHrCvpCEMG0PSz4+DRH/SvZIREWTDhRpm2NzfQw5uLApkXzRnATVvtu9epyZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIj8RTgPki4bI59ks0SPT5TVXVXm35VXLLJXtGADGNY=;
 b=gcPUPOFLyRvxsAmd6+bsUu9fVtvOtkTQtd1bR5uAjEdywO/lRxSnCBB9639kYECURVDgquu7/07QOeQfMyXMmrSbzx3MQ4e1x1x0qgA4eyyOOQ4sgENRaqtBU4S4eUtnQjgxNy2LCWiFw/+/Ut3w0mLRAPCFy1O+RBZL9Oq5OCLuolM7VI6N6Gpc64mGH/U1GzsQBS6bjmiibIKLctLpmyZK1pMwqqgfLis+vBb5lS6TmdApgTbVVVeT6vi33CYKx+0ZPLmEbXLfBWpddC7rbxn2f/QXRvcD9nd3nvSXX1lQVdGpUaHsdFYl7dLZVuUR9njSo9bPrzUluTvD6wJwyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIj8RTgPki4bI59ks0SPT5TVXVXm35VXLLJXtGADGNY=;
 b=iPFmn8x0ORvsmIE4kY2pzJiKf8VMKHP5r/T4CDQol9m7XDPoe6tbF7zhZMo/qd1hAa3Vh/vAt/ldlAbew2dRB9cl0+rDw+dTbi8fa2Qa9V1F2DRVCGoUy3jpYy6sX19wRPODJVVDrKi/cMzC3xTmHTBjClsSn3mWXT9beTfBz94=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 23:15:54 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::e8ff:d210:8fab:1b00]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::e8ff:d210:8fab:1b00%7]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 23:15:54 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Chandan Babu <chandan.babu@oracle.com>
CC:     Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix AGFL allocation dead lock
Thread-Topic: [PATCH] xfs: fix AGFL allocation dead lock
Thread-Index: AQHZY0iqHX19AiUQVEawS0PTWbztO68lbd0AgAH71ICAAQVPgIAArH8AgAC+o4CAALoDgIAA81uA
Date:   Fri, 14 Apr 2023 23:15:54 +0000
Message-ID: <39964944-A1BF-4E86-9ABC-27A2B1B66751@oracle.com>
References: <20230330204610.23546-1-wen.gang.wang@oracle.com>
 <20230411020624.GY3223426@dread.disaster.area>
 <87mt3djwj9.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230412235915.GN3223426@dread.disaster.area>
 <87sfd4jcyn.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230413213857.GP3223426@dread.disaster.area>
 <87y1mun6y6.fsf@debian-BULLSEYE-live-builder-AMD64>
In-Reply-To: <87y1mun6y6.fsf@debian-BULLSEYE-live-builder-AMD64>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|BLAPR10MB4835:EE_
x-ms-office365-filtering-correlation-id: 6d0908d4-30c9-4d8b-9bcd-08db3d3e323d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xMi5CtpHdUw53NrYa5uTDfrDR0Y03qdu+O9yj85tGw1OFDvTZhiyzs+BqwW0/pfDafAKZv3S0D0WF8Lw2/PAhKyR7OxN03I4kyBf5pLXnm5S7WTEy74VVlDjfhJtAEDp1fOysXw17sT2k0NOApvr3GvxmjYI+u3g5LVzw1/J+N80ybin5+nOZ5wemnH/p37v1shDJy92cd6rsY1sIN6LUVcRiz6J8K5dpq8giHnYpqOBUmFfjhQp+vGZE8gTr/ONiaz2kNql1sfxhfrJjckgYs0tqgZZxbYni3h6FyU5LiBshzTGWpQ5SKDieWbG03nLEjj44zGX9QhLaBNAj7rjnPxNjmYV4i5Yi20uFBWmjPEJg8wml38ScKIeS7pkYT95/7OU8IYh6rI2IufFMLRMNOT21NRHVp7QB/+Z9T1CNr0GeCse9mhoxo+r8dAT91OP8trR+GIDSel2GtbfdQTPEHaUxpO6X1EATEttx0zcQHudteu8rGUglt15KvTiiAiywG9MYRVhPTHV2nWzh/mynN8cW0pxmmGgC16ESkM+7rJIN0X0p2xPzDQ+OEeecx/IIfHF0TwmAskPtjOGV7XO3jHEaGCL+O+cutu29Z+2RyDI3skB//9U56JiUGMJsv41xCNL+N562FjvO2uyfV2qRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199021)(38070700005)(558084003)(66476007)(64756008)(66556008)(76116006)(66446008)(36756003)(6512007)(6506007)(2906002)(71200400001)(6486002)(2616005)(186003)(66946007)(4326008)(6636002)(54906003)(86362001)(37006003)(5660300002)(38100700002)(8676002)(8936002)(122000001)(6862004)(316002)(478600001)(33656002)(41300700001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGc4UGRnUGtaVzlubmhPeFlDZXZOeHZZdEZhOC9QTm4rbklxWGFHeEhKbHQw?=
 =?utf-8?B?ci9DUkpsdWNrczJDVTluTVNOSGNmRlRrZnhIcXlkaXd1UDFIU3RCNU8rTTlN?=
 =?utf-8?B?UHhmc29MZG9mdkJoejUvVkt2a1pWa2ZwZEJrZ2psTGZybk1TYXBJVzJWbWJt?=
 =?utf-8?B?c3lZbVozWHRwbGVEWUZ4b1lHWDZzaGs4ZjlERElOenRHd2hrK0RmKzdjdU1K?=
 =?utf-8?B?OWN5cHBIMVJBYndhak1qRGYyVU01MzBtSzZQdGdLazRWd2xMVU9tVGg3akQr?=
 =?utf-8?B?OFFBWXArSENmQnlEaUtoeEYxM1dRMUJ2V3ZyeDUyU0ttZTRKdktUaForcUlU?=
 =?utf-8?B?ZjFid3BIWWZ0cktINUFLWDZPSTlmN1NneFlvYnc1d0Rra1E5Q2NRV3lKakpE?=
 =?utf-8?B?alltM2hzZ2VpZStWUGZ2Q1NvVmFtdU0rbmw2K3JHOW5pSnMrc3h6bm56dll6?=
 =?utf-8?B?U2I0WlN3NUJLdFEzUXY1OWR3MXBaeUFGajU1Mk5VNndVU1JNckhtS1NHLzFC?=
 =?utf-8?B?ZWhtYmVUWlprQU5FZm41Y1JmSXFLMVdOektzWEJNK1piYXFXS2gwTVZXbFFY?=
 =?utf-8?B?bG5ha2JzbFg3TWl3Qm9hZmora2U3RFQ3N0x4b3hBUTdqWmVwVTJONkJnV1py?=
 =?utf-8?B?eldqTTludTBtSVZaNTRzNTFDaUpuUkxnTytBcGhuQ1Uya25FZk8xMnBWQ1NZ?=
 =?utf-8?B?cks2TkJWNFhXSGxNTVRUcUNqclVicUtwRjhKS0c0alhuT3o3VExBRStRbXZi?=
 =?utf-8?B?N2RyM3VDRzROOVpNN3lkOUNWblJraGNIeFhvMlh4Z0lLbUxXRWRDYmN5SUp6?=
 =?utf-8?B?bDVZVUF6N21LaGwwaldoZEk0UTdtU3RBYlhSaERCSmdwWkxOdnhWcE9jcmF5?=
 =?utf-8?B?WmVnSC9PZUVqYnZvbjN4ZkdpbURzWmc5TTlLZjM5bDRwRjJxQmFzNitjOHNs?=
 =?utf-8?B?VS8wOXZvbkkwcndwTzZackUrc0xXRG0zRTZPbnFiQWtISnBEUVUvcElSVkhi?=
 =?utf-8?B?eGpyY0RqY2xZTlJ2QjhTN1JXKzBOYXZ3M1dsNW50cGY1RUhLRG9lTlhoSVVQ?=
 =?utf-8?B?RmEzYUt1eVVVYlJ5c3Fzaml2VFFMTnhVR0RXMFpnbmxRd1BBYVMyZ3dKZTU1?=
 =?utf-8?B?RjZhNXcwdFhTOEtzQW9DVlFkcFhXZHg4bER3N1dleUlxQzdXV0VOaFVBT01J?=
 =?utf-8?B?aW1jek9JTE9sRk1jWmowSkZpeVgzRWxIczJpTE5SWStEZ1A3YW1BV2IrQVZi?=
 =?utf-8?B?L085Vlg2aVdnZU9IbnplSE1zNVJreFNqS3F0QktSQjVsVDJEOWM0ODBpbXRY?=
 =?utf-8?B?VnEweTdDN0N3eXVWb1hpVGFZKzczV05YQWRrK3IwUzNmNDZGeG5laENRMkhT?=
 =?utf-8?B?dms1amhuSDY3alBnaENqY3VZbmljTk81RlYzUE9DR0lKdlNQc21PYTZEWGQ3?=
 =?utf-8?B?NzRCWGtjMG13bCs2UHBRWDNRQjlETm1zbjI2TG5VYTFaUjhja2xjcmc0Z0pC?=
 =?utf-8?B?d1FlL3NBUkZWTE0vM0s4MzlZSThlNEl2RURsTURFZzFNUDZZWCttRmQrQkVa?=
 =?utf-8?B?RHcxcUMzR0VUVU1ZWWZwb3FnbWZWMEVUZUJuWU54TkMxYk0vbmpRRW11KzBu?=
 =?utf-8?B?WkFtbjJCbmYwZXBUUkRBdkNGWVpqTVp5VkhJaXhycU9hZ1hoaWM4NmJWemdH?=
 =?utf-8?B?UnR6OVU1SDgyc0ZTeUVpZktYOTB6U3BuTUZ2Sjc2TWxGMFJnWTVxL1VqRFBN?=
 =?utf-8?B?NVNpQ2VQdHJBZ3dPRi81VHBvVi82VngySlVnNDMzMkVYR21obCttUDA1cVpn?=
 =?utf-8?B?ZUVuU2RrWmdjTlA4YkZ0RzZBeUJtTU1rbExJQmRCbUZsSmcrOHZmL0V3NlNF?=
 =?utf-8?B?WHYydHRVMXlmT2NLeW1reU9MTTZmNUtsZGdWNUdEUjlmUndlbXYxREEvTUx1?=
 =?utf-8?B?MzZSZmcrYjh5WWxEREVaZHY0SXFJT2dWZTY2TUxETlpHcmFpVml0ZTFvMi9H?=
 =?utf-8?B?N1JwZXAxazVrZkJLTWpwdlZlU2xrK0lUejNoTEQxdlNGL09pSlNqbVNjdDlR?=
 =?utf-8?B?OGNCaHdOUEpHOFZ4VFFmUVJiMStqNnFqL1ZGM3RjTEo0a1lrbkVTYjFVbFZi?=
 =?utf-8?B?dzRhVGdvellNdW1BN0JlWDlNTlhLRkZjNE1XS0NxOVMxdEgxN0F1ck9hL0tE?=
 =?utf-8?Q?h1KSTO2K4opKnK7IN7FvqtSfhAQz77+Jpn4PSZ4rb0Oa?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28A32EC38F29A94596A487A42D4A41F5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GwHfaa/LgotxcvgCn0jZon08pEcQQ6pb2bM9Gv9QZKelSYemKQskT69datcmNXNKr4zeLrCk2ntF4Pi9vPaMtuGA90GbTQMbieEE6Bv11ue29ZGDbmmz77grunnsF5GMDqG+blAom/msNmI9YF7vU4ZOSFrNAJ4/8SEJo6onlU4YDh0eh4Ax7OkhiDmuuUbknMmLH7k/YLL7gm/XqRtHphjwLmGpMDbknSqsPjUa6KbrAQgUtAswbVZQZCkAnIVeOeQRZI0jAUufIyiFedqBuVsCL9aYcYTmwNWiKOwO6yCIyYjpcXkxhY4SrDUA88K3+Otxb6ZhDMgzUTKMPlKR8egAjC03BUjMx7eMYk74CwlEUHEnE5+8jQgzBUGTAsgMD3pmS2ZNr5luMpQeCbUG4RAr9F6eU20FKovfG9XuKiuRMyw/kAfDf1cfQLqXmEimeh+z84cTNwsC0tZXa7tKuhwyioWy+WczxJNmJPv9y96okk2EMQWsFDWC7qLKZw8C9n12lftCEhh/rvwKQtHFOp95F5+V8ZQoiMwYpwWa8Dm1fSPFznoe/kw8zSTYjQVxYqMMYDLVEUMlr92+Z4WuhSwx9vKigahMz+T01VcRpRH/ND10jkAymwGDrJB9ppgwEDz/TYTEGvGN6W7Iotx2eLAWA2P8xv1Ce13nX71qMJjTiXzcZjlecRejHmwsArC92GIISHKA+8jUteWpfmuGHFmzL20/U2M3Y8cgK67XghnZlEmq//GLbogg627oPSi2BDiGrPt64mbLf8tIduPmQFuqoH2w2A8NooOpsga53eM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d0908d4-30c9-4d8b-9bcd-08db3d3e323d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 23:15:54.2808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SJMiLqr4puBHqIiVyzBnFjcv8X+9rZe5uR8D0la2mZ+6CKFLqN7MrmLBmP/aKay4JFjfSt3WO2+95N1gaSv83r8YiZTwv9uMZVPxTtx7cxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4835
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_15,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140204
X-Proofpoint-ORIG-GUID: VNb70a84UV-dEOFn2d5RiiJ3_9I528nF
X-Proofpoint-GUID: VNb70a84UV-dEOFn2d5RiiJ3_9I528nF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

TWF5YmUgZHVwbGljYXRlZCByZXBseSAoSSB3YXMgdG9sZCB0aGF0IGVtYWlsIGluY2x1ZGVkIEhU
TVAgcGFydCBhbmQgcmVqZWN0ZWQpLg0KDQpJIGp1c3Qgc2VudCBhIHR3by1wYXRjaCBzZXQgbWFr
aW5nIG9uZSBleHRlbnQgcGVyIEVGSSB0byBzb2x2ZSB0aGlzIHByb2JsZW0sIGNhbiB5b3UgcGxl
YXNlIHNlZSBpZiB0aGF04oCZcyBnb29kPw0KDQp0aGFua3MsDQp3ZW5nYW5nDQoNCg==
