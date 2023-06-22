Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2C1EB64D7
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 01:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjFVBPy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 21:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjFVBPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 21:15:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5741BCD
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 18:15:52 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LK8YMR030147;
        Thu, 22 Jun 2023 01:15:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=MlDihq1TPrWXUbZxm7Po2lgM/Dr0Xg9+9iAOZeJs2gU=;
 b=l6HVk0oL8BNwwGVtqwicaDJDvtEwyhnhFki7bNnJENVKot06XteYnZqbzQ/EZrvAOIok
 3KBNmtHR4djLyPrSsg4N842nvXAlodkPISo2Lbc64d9vj7hUg9xoBcF2lZcnDgJ2dfG4
 87s8mq1c0lxLFOLNciIIuMbFFaKoKBBsw0wzg3vjV3OedDg3JLBRQEdhlte7lT2yGUOT
 43gqHZnbmP+kSxl6mAQgsPSC83AsDK1qRoorca8S0uDf0tk5BAro+fZymvI3TaAIxvag
 Zha/s/wbMRjRJ5FF8AfSnxLgspiylM7UftZp4DJoBK5HqR6hZbW7DLgNxXvKHQyhU11t Mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r93rbrsys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:15:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35M013sE028809;
        Thu, 22 Jun 2023 01:15:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r939ctq4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:15:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHQThnfIOjmncR+3BLR/eJTBmI5vGPyJXRy8yer9u9XznUbLSvAHuZbzqmduxt/OLf6VdwjLXEJfU0Y1S5VMV1BmYhqg3k10crxiGAbFtEeGM+0TzUrrGMAKlce2bGFHQPny7Q1GFDx0VgNKgFchQZsctvRNodocxNODd6eWLhJrnlkreWnDTmO2BvokOlRK//H6pREvJEE3oz6beEp8BBS8bNIOR3fTTDz7FIm1jb1vRaM3VCdQTjHu4cLdBbCjB1jMU+s6MAc9pVY9FA+/YPS5g9zqAiNc56wnb3NegMQ1s+M8MwnqfwbQ+1+jNtxWn+etcmaq0ZbW4z1XR+QFZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MlDihq1TPrWXUbZxm7Po2lgM/Dr0Xg9+9iAOZeJs2gU=;
 b=dTwW8vA2BY8TgpfbCtfpuHyworwyo/BmcLus6rHkkwei4SkYZQf/6QgfxSdjRYa5I9jV7w51LMUreph5z0nd7UrVRAHizlZ6CaDet6vRP1B13T94NrzDPYWpMh+3OmEpUvULtQCQY0K5qrU83txvnjnt7ZBzZYWcuNVaWVkmk2y8TJzov+0UY8+UZ+gJkHix5MKqOskBSrXCGXHQ4E/ZhQCH70CHLDnFFWEakzrMYeK/XRdZnxv856u3XBAxxD38i6M10JelUTO4FCJ4+rOUs8zZsnuwMV3WGrZrfyZyDak7Z2i1Xbv0cb+htB56UA4aWiplH4YwWrOJpC1ES9MXig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlDihq1TPrWXUbZxm7Po2lgM/Dr0Xg9+9iAOZeJs2gU=;
 b=NKo2j5/gG66ve0xwsO8+eKWiIv9y5L+S/fTMTmebqH0S7g4lcQsSFSPBspHk70cSb9n74dxUaDnFv/zDXkP9pxAF18VpYDG+907dYU04Py/7/yZZPDD4YBY2Xu+HS77IiaSXLQK61Qv2LtaH6tKyGqnBJqfM6wpth5/OjusAiNE=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by BL3PR10MB6137.namprd10.prod.outlook.com (2603:10b6:208:3b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Thu, 22 Jun
 2023 01:15:47 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1%7]) with mapi id 15.20.6521.023; Thu, 22 Jun 2023
 01:15:47 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Topic: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Index: AQHZnyqiJVfvBqN/ZEat6GgWNoCKPa+MalAAgAAE8YCAAASYgIAACrOAgAAGmoCAAAT8gIAAB3wAgAAGxICACXdfAA==
Date:   Thu, 22 Jun 2023 01:15:47 +0000
Message-ID: <F58B623E-5754-431D-B8D1-AECC4C12FF9C@oracle.com>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-2-david@fromorbit.com>
 <25F855D8-F944-45D0-9BB2-3E475A301EDB@oracle.com>
 <ZIuNV8UqlOFmUmOY@dread.disaster.area>
 <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
 <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
 <ZIuftY4gKcjygvYv@dread.disaster.area>
 <396ACF78-518E-432A-9016-B2EAFD800B7C@oracle.com>
 <ZIuqKv58eTQL/Iij@dread.disaster.area>
 <903FC127-8564-4F12-86E8-0FF5A5A87E2E@oracle.com>
In-Reply-To: <903FC127-8564-4F12-86E8-0FF5A5A87E2E@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|BL3PR10MB6137:EE_
x-ms-office365-filtering-correlation-id: 1b64c74d-3363-4cb6-75d9-08db72be35bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: scdimry0CLATMrwLJN2Gv7fr60TuUpzPIsc1HSz+SY1hwnWt1Nsg7M2I66Ezi7q5bnBvjAPxdspcr8APlY/QMaX1IxaSXYrQtP3Wql4TQrZMeVAwWW6MC/FzYDlqqXhBrj9oxN+xMsO2oVWBaVo4s8D+DYNkqKy+PJQ0fbdLuJlTGhWEO4PvrsJOKh5t/7tObyb7u3u2GqIQ9se/eFY1Y9PsJvHQ27uTQsAZ2yIWLXWcyzb9ML5n8crmP8Hfrbxp4lYGWUdpfIigo+YXWYt1pDxGN0bhWsQNZmUKzDaGQuvm9Go4PZw3sXRYLjjm46cm+3cHZ0lhee4dJKQqWkxlRFda2KdmtHO/hwUwNL/r/NZjnlGSI+SCRv3WCZOddkaJGPkXIWdckcePCohzryYn/yYeHJwjkGo3F0RaatDX+zwS55kLGxE/d4sWW8slI7t1Zh+mMqvBU6mVW2MGrtnHg7FRZs4DnIfMb3BroUqaTtmP+UBs05YFLZMj+gE1hCl1LaHN79MkyKkfAghtbmbHO31fUXcavP6lUlja6XcceN8wcCZMtrhvs9wjmtapLDzVi3bv1bH4HgvZJCcmF7zCimyCxDFvx8gz5EI6iTe6znzTv/gxIHiN9Tzhqg3Yr0MhzB0LNHImF4GnqrSQB14RVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199021)(71200400001)(6486002)(966005)(478600001)(33656002)(53546011)(186003)(83380400001)(26005)(6512007)(2616005)(38100700002)(38070700005)(36756003)(86362001)(6506007)(122000001)(2906002)(8936002)(8676002)(5660300002)(316002)(4326008)(64756008)(91956017)(6916009)(76116006)(66476007)(66446008)(41300700001)(66556008)(66946007)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnFtSWQza3FpY0RLdDRSRVo3Ym8ycDIrYVV5STErcUNQRWcyZ2J5U0FGcm5U?=
 =?utf-8?B?TExkYkp4aFMwWUYzSWsrSTdHcjJYd2ZYSFhFRnJGSVJPaFdvUHp2Y2h2ZXQz?=
 =?utf-8?B?bVZPYmJFN0kwY1hpL1h3UmlvdVpWVEIzMDNpOHRmTG1rdVJGNDFVNnBELzh5?=
 =?utf-8?B?ZXhxUnRXNTRpUnRnRzFJV3ZONlJodTFUNzRROE1pd2xKK25Ebi91NTZiYUVy?=
 =?utf-8?B?dGp6VjZaYmJsQW05bnl6UzVGaWt3a2ljVnNnM213S3R5NzhsYU14ZDFMVVd5?=
 =?utf-8?B?ek93MjJUK252aGcyd1J3UHVjWmJnajVvRERzSHNYWG1XekFBS1k5QnVrbk9m?=
 =?utf-8?B?VklISzNLZTVpcG9CWGZSU2xNbVlQYUNSTktOcldBeGo2RDNvelZoUzhVMlV3?=
 =?utf-8?B?WjlOTkd0YmYvZmhNMUJrd3NUNHdTK3JFQ2h6V05RZUhXUWpyWEdRSmcxNEpw?=
 =?utf-8?B?dU9yQ1VLY0hsY1M2MmdYLzBsNmk0REYvUHBYbnhISDN1ZUFNeFMwTTJROUZu?=
 =?utf-8?B?cmZJUitIQ3ZMbmxjNVJVV0Q2aE1SNFVFWGtsMDlLVnYvQnQ2elRxWEpONU9B?=
 =?utf-8?B?ZjN1QnlTOXEvR2dmTFpiN1BvcUFiUDA1U2ptM3hOTUxPVlpKMTVhTzhWRUVp?=
 =?utf-8?B?Wko2Sm1lZlorRHhLdjBkelhISEhFRXo4ampXUGloRmNib3ZFeE5qSXdqT0ph?=
 =?utf-8?B?ZGloSXdLYzY3U1hRL2JXcDJQYy9scmpkcG1JcVdXREVNMjdjaVZ3RVhZVjM3?=
 =?utf-8?B?WFpoa2FOeFF0TWFsSGs5TlhhZ1VQTmRTemxHU2FDMm95cGw1bGVQa2owVlN3?=
 =?utf-8?B?N0QvWjVzZ3NTNC9kZHladHpueHdyZDlmNXlFb05EVlFsL3d4cUFBdTQwc0VI?=
 =?utf-8?B?VXlhamd2ZzZaREpkM1lsZ0ZwRFFZOVdwSXZ2dWJTbVN4Z2JJU1lMdXh4Q2c3?=
 =?utf-8?B?RER4OGVTekM4N0RYNERiN2F5MFFaSU1CSjFpRnNRaXg4N0tnb3Aza3hkYVNL?=
 =?utf-8?B?QTFac3BmYThJRFFYUnpvRHg3UEVnaWd1bUpGU1Nxd3dIb1BZQytjRUUzdnJC?=
 =?utf-8?B?MXJHelppMzJqaGpOTTJLbVlBZ25DSWNGcmpUTUwyOXk3SzR0R1R5WW85UWZG?=
 =?utf-8?B?TFJDQXFaRWg0TDJHTHl2azlIWmNuUUY4a09hejJzRU5Ka00wL01xVDloWlhh?=
 =?utf-8?B?NkhQTWJhWUd1cFUrblhJL1RycnVQL05RNnA3SUR6eEZ4L1UxV1pvSEJJTnI0?=
 =?utf-8?B?S2syVFgrQ2tDVHpGcURtN2VHNDdjbjZseVV4NHBCWWF3bUJNOGJsbmd5ckR1?=
 =?utf-8?B?blU4a2hCQ2hrVFhObkRYdC9NVHhxenFWeHlsWkpUK3FvaHlRWEZMWmxhMVJ2?=
 =?utf-8?B?NkdkU2tzY0FHdGxDUkxPaVBBZ0drVVB6ZzUrdHNaZVYrZGlaTUpNRGxtWDAx?=
 =?utf-8?B?bnRJaWNNMmEvNko4YjdLNFlVbmNGd2RnTkhCV0E2bm9vamlWcjN6TlVNdGtt?=
 =?utf-8?B?dWZXcFJDYU1SaVBmT0M4QytjVk1GRndmWmZJWmlBU0k3c29xYVVUMWJPSDIy?=
 =?utf-8?B?YVE4aVJoaEFna29UbjdPVUpubG1tNlBwSXJETERTaVhzV2FkUFVRUU5meTJI?=
 =?utf-8?B?cUNabk1YYi9HU0pFZFNTK05FNHV0Zm5MQXRCbE4zYUV2WExKZ1c2T204T0s3?=
 =?utf-8?B?OFJPVkNoMnYxTkRmTzc4WHFHbTJLc2tpRS9rTEZQdUFMd09DbzVld3dqT3JN?=
 =?utf-8?B?YXJraUMrc05HRld6dnF0UndYVDlYY1Vxdk1FcEVBNHdRRkxQK2JEWitYWXJw?=
 =?utf-8?B?K0t3UDdjei9QR213bW5BRTNHNVFENWFXUjYyUEFIN2dOem1Jd08xNkFvYm1m?=
 =?utf-8?B?RGFPZitVeHhITkorVlZGL3lwdG1ibG5COENzV1orYk41MG5CSlZXK0dkSWsv?=
 =?utf-8?B?RW1DcE5LMEpuSU5YTitoQVlXRUF0Z0ZDSVpKTzJjUDhocXFGMGVpclAybExH?=
 =?utf-8?B?aTFWR0pwWU1pM2JhVS84bHhZZ2RBQVd0WTFTeHc1VG85ZFFWUUloRDZkVFBY?=
 =?utf-8?B?VTgrUWxWVzBhbjdxWVV4VXMrN1F3eXZCWitxdjJacFBIQmhGSEgySmxjcGQx?=
 =?utf-8?B?OXBZa2tkZEU1TC9zK016KzNoa0xjcDhJWmRtZFJvWEthVS94WFlxd2djR0hN?=
 =?utf-8?B?ekE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <13801C58E43BB6488FEA6F0466D58391@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3pBW4+5Xqm5S2kBWEuSBppQWjBaXDcKSHuBFgEDgcCEb1Juhfr8THilMzFH3uW0dcuqojMZuyu3UxRQQPbo5h9/9XEDTTX55Odp1ojF5HI1i1fR7ixBJqhh3w56ioRS1SlRGeEdRngDKtZ9WDPfEh4eRq5E8T7UlTeMh3zouuksL5Aydk3tBzJ9dlxEV72mNbA6tuA8Zu0VdMuUzljJXaEwNM7WH60bsZJ5EaUO56rlm2fKy771r1Myxvnn0gQe/uD3U+yDrpDlrTVLPmY9WRNZNXt18ZE0xQwCGeaXdl5yXKFAcnBf7MTZGbKAhuHZSksp1mmKw8X20t5aIT3TzV8E9y/SPPPCnjJpkTuvLfwPGta3Zl9zMcw6WMZ7h0tbreTjgvF8/UWTjX7nQ+W9UQjSx73dmbbVm256LzNoxhKwjpair3pG+vIeaneLxyaWyTiHbPHTN0eMq49yaqKX+NTH6b11JTwVwpsrFo33c0iUbuFDFiLNv7wHlJLDVz3anSn7Cgx/cdLPjgGfzIGokUJT0raWDwCLhb6czYhfhYhN1wenkZqoovYx59lLRiaf+acLDEGAtcyU4P0u73I6ValA+vNNIFLp5hkJcX9/rQ5yX951qoE365xwYuRhDBi9lwTGUjtqnijPig7VzAdkWJWXuVxx0eMpM4ehrSVfqhFSE4WoqdbHu9Dsek6cpEnEietIJmKNN5ewRXBihylWigkwHIzHUyc52VC6pvaura29RO8IYeiLPd+9H+zIRWkn831sMT4LEDLjQYkq7T9Ks36DZ1e+QenOa8+qeKxTDmPaK3PQOOBffeYPaQj1geMXmL5nM0tw0VRFQSmhTsFYgew==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b64c74d-3363-4cb6-75d9-08db72be35bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2023 01:15:47.3618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3OXOfdx93ocf9pqXZgDsUpoQUaneQE+0LcWYuIa38IPyELu9H+metUwMZzBNhYWiE34TlHQk4p/u8N4pstIAKkoXryaUR3agHRQ79t5Cfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_14,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306220007
X-Proofpoint-ORIG-GUID: hzDAD94H1eqTTt2RBTGHjlluQdi-MRDU
X-Proofpoint-GUID: hzDAD94H1eqTTt2RBTGHjlluQdi-MRDU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gSnVuIDE1LCAyMDIzLCBhdCA1OjQyIFBNLCBXZW5nYW5nIFdhbmcgPHdlbi5nYW5n
LndhbmdAb3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gDQo+PiBPbiBKdW4gMTUsIDIwMjMs
IGF0IDU6MTcgUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+
PiANCj4+IE9uIFRodSwgSnVuIDE1LCAyMDIzIGF0IDExOjUxOjA5UE0gKzAwMDAsIFdlbmdhbmcg
V2FuZyB3cm90ZToNCj4+PiANCj4+PiANCj4+Pj4gT24gSnVuIDE1LCAyMDIzLCBhdCA0OjMzIFBN
LCBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOg0KPj4+PiANCj4+Pj4g
T24gVGh1LCBKdW4gMTUsIDIwMjMgYXQgMTE6MDk6NDFQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdy
b3RlOg0KPj4+Pj4gV2hlbiBtb3VudGluZyB0aGUgcHJvYmxlbWF0aWMgbWV0YWR1bXAgd2l0aCB0
aGUgcGF0Y2hlcywgSSBzZWUgdGhlIGZvbGxvd2luZyByZXBvcnRlZC4NCj4+Pj4+IA0KPj4+Pj4g
Rm9yIG1vcmUgaW5mb3JtYXRpb24gYWJvdXQgdHJvdWJsZXNob290aW5nIHlvdXIgaW5zdGFuY2Ug
dXNpbmcgYSBjb25zb2xlIGNvbm5lY3Rpb24sIHNlZSB0aGUgZG9jdW1lbnRhdGlvbjogaHR0cHM6
Ly9kb2NzLmNsb3VkLm9yYWNsZS5jb20vZW4tdXMvaWFhcy9Db250ZW50L0NvbXB1dGUvUmVmZXJl
bmNlcy9zZXJpYWxjb25zb2xlLmh0bSNmb3VyDQo+Pj4+PiA9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+Pj4+PiBbICAgNjcuMjEyNDk2XSBsb29wOiBt
b2R1bGUgbG9hZGVkDQo+Pj4+PiBbICAgNjcuMjE0NzMyXSBsb29wMDogZGV0ZWN0ZWQgY2FwYWNp
dHkgY2hhbmdlIGZyb20gMCB0byA2MjkxMzc0MDgNCj4+Pj4+IFsgICA2Ny4yNDc1NDJdIFhGUyAo
bG9vcDApOiBEZXByZWNhdGVkIFY0IGZvcm1hdCAoY3JjPTApIHdpbGwgbm90IGJlIHN1cHBvcnRl
ZCBhZnRlciBTZXB0ZW1iZXIgMjAzMC4NCj4+Pj4+IFsgICA2Ny4yNDkyNTddIFhGUyAobG9vcDAp
OiBNb3VudGluZyBWNCBGaWxlc3lzdGVtIGFmNzU1YTk4LTVmNjItNDIxZC1hYTgxLTJkYjdiZmZk
MmM0MA0KPj4+Pj4gWyAgIDcyLjI0MTU0Nl0gWEZTIChsb29wMCk6IFN0YXJ0aW5nIHJlY292ZXJ5
IChsb2dkZXY6IGludGVybmFsKQ0KPj4+Pj4gWyAgIDkyLjIxODI1Nl0gWEZTIChsb29wMCk6IElu
dGVybmFsIGVycm9yIGx0Ym5vICsgbHRsZW4gPiBibm8gYXQgbGluZSAxOTU3IG9mIGZpbGUgZnMv
eGZzL2xpYnhmcy94ZnNfYWxsb2MuYy4gIENhbGxlciB4ZnNfZnJlZV9hZ19leHRlbnQrMHgzZjYv
MHg4NzAgW3hmc10NCj4+Pj4+IFsgICA5Mi4yNDk4MDJdIENQVTogMSBQSUQ6IDQyMDEgQ29tbTog
bW91bnQgTm90IHRhaW50ZWQgNi40LjAtcmM2ICM4DQo+Pj4+IA0KPj4+PiBXaGF0IGlzIHRoZSB0
ZXN0IHlvdSBhcmUgcnVubmluZz8gUGxlYXNlIGRlc2NyaWJlIGhvdyB5b3UgcmVwcm9kdWNlZA0K
Pj4+PiB0aGlzIGZhaWx1cmUgLSBhIHJlcHJvZHVjZXIgc2NyaXB0IHdvdWxkIGJlIHRoZSBiZXN0
IHRoaW5nIGhlcmUuDQo+Pj4gDQo+Pj4gSSB3YXMgbW91bnRpbmcgYSAoY29weSBvZikgVjQgbWV0
YWR1bXAgZnJvbSBjdXN0b21lci4NCj4+IA0KPj4gSXMgdGhlIG1ldGFkdW1wIG9iZnVzY2F0ZWQ/
IENhbiBJIGdldCBhIGNvcHkgb2YgaXQgdmlhIGEgcHJpdmF0ZSwNCj4+IHNlY3VyZSBjaGFubmVs
Pw0KPiANCj4gSSBhbSBPSyB0byBnaXZlIHlvdSBhIGNvcHkgYWZ0ZXIgSSBnZXQgYXBwcm92ZW1l
bnQgZm9yIHRoYXQuDQoNCkRhdmUsIEkgdHJpZWQgYSBsb3Qgb2YgdGltZXMgdG8gcmVwcm9kdWNl
IGhpcyBpc3N1ZSwgYnV0IG9ubHkgcmVwcm9kdWNlZCBpdCBvbmNlLg0KU28gSSBkb27igJl0IGhh
dmUgYSBzY3JpcHQgdG8gcmVwcm9kdWNlIGl0IHN0YWJseS4gQW5kIEkgd29uJ3Qgd29yayBtb3Jl
IG9uDQpyZXByb2R1Y2luZyBpdC4gIEkgc2F2ZWQgdGhlIHNtYWxsICgxR2lCKSBYRlMgdm9sdW1l
IChvbiB3aGljaCBsb2cgcmVjb3ZlciBoYW5nKS4NCkxldCBtZSBrbm93IGlmIHlvdSBzdGlsbCBo
YXZlIHRoZSBpbnRlcmVzdCB0byBnZXQgYSBjb3B5Lg0KDQp0aGFua3MsDQp3ZW5nYW5nDQoNCg==
