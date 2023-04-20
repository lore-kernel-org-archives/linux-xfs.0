Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC49C77B72
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Apr 2023 17:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjDTRbV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 13:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjDTRbU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 13:31:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D0BE57
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 10:31:19 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KDu3qm013986;
        Thu, 20 Apr 2023 17:31:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=x7rO5aAALlhQfH3nHAIL9nmcCzGsdwtlnTy9fUH3XbQ=;
 b=B3VeixmKIKm6taF7hJ90eg12U3mLeofM5fVZWqNwDn0GkSiReRofwy72fpC08zYF5Lnj
 JPaVfPaA0rNmQW/D26iJSgPvR55dodDskfM2TMxdmS9nysSgUTYxQzxIEFY820MHayvZ
 BH357IncO1sKPa/ZC49SpEwM8EJ34WJ5m2Egn9h9YAQyG2Jnw6ds+sd4boUz4DTq1oGk
 T8JJUMIdLKnmDrw71RE+ozW7ZjIZt8l/bMjeVbWfh7S0VjAJwHZsvXniSFYufqt9qa4u
 Zy4xfhWpDC7qz7k3H0Hiz2lGi8T89iBIfTnbbZnk5G/USDrQL2jh3ypO00esxnfBYvhN HA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjucbkt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 17:31:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33KHQXZF036887;
        Thu, 20 Apr 2023 17:31:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcekw53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 17:31:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmCj2JtZbJNiwdcDe1ATi6n6iJCv2CJrR8gTmQFiyfgWubDI0QA6kV9Iu7xZEHVnGucW3S/bTnFhFp98AjgcuLxpV7xEjaIsAODroH8taZnRCauVQs2eKbSeCWmymp8fj1kYhJLriRHu3M5X69dNN06lcJVL0JfuX+pOYWYwO5N4WCcxCM7XXtTFJ0oVcCVwokBKimhpct7UOSOIigpd6Hmtf7WTyqXRbVqxzkcKRJYM+HmRC/6eAIRgM7UlTiLrsdupwuExOpj7pdAlG01m0qfEhDqD10HuMDeT1jKjtNFY5Yj1JLvGHKfy3Jg9YlpK4h7cAQG5ZMy3GB57hPNbdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7rO5aAALlhQfH3nHAIL9nmcCzGsdwtlnTy9fUH3XbQ=;
 b=DOv51afvv5tEb3PrplsBrJqtP+lYsafpSZ0TmgO5lHhiLEM65SP8yUzlEyC55whSylwGATNrGLTPqcHDw5xqnJBGGsGNB6QuAGyNgs9ooDOMkx66L/AXu/vUzNyJiyHW6FW85l9THJR8g5TWYxQ8B/e+Un3D81+02nmPMZXRB6VkhU7YpK0SGKsjZ+99phievyqeBuEfHy1Yp9ArhjJZwNwSz6ZdYpIAOdj70vuyS87i6BFfJGpK2i/Fg1LVAKnFVFMvmLbvji/KDCtn9iNGyMDihlKHjq3ZKQnm5Gtv+YlpFQTQ4FTSGkE6KT6bwKA1YzaH28Kqxym2AbmibNLtKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7rO5aAALlhQfH3nHAIL9nmcCzGsdwtlnTy9fUH3XbQ=;
 b=0VYohQWceRXPsZAYJjyqLI1MNQziO2eBfQj41qn82vUaR9aM5qHM1e1yC0BrjXhN/yDqLLRZsk8RoyZi9tKM4YzPCBEMCjkTLnDa4708jnUyrNmlNIKXMcBeOuSJGihlo2mU1/R81Q3aiUHzCB8lODddSLnuMgZ/x9Kv7pvyAqE=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by PH0PR10MB5627.namprd10.prod.outlook.com (2603:10b6:510:fa::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 17:31:14 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b%6]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 17:31:14 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: IO time one extent per EFI
Thread-Topic: [PATCH 1/2] xfs: IO time one extent per EFI
Thread-Index: AQHZbySmyU5pA5JJVkmM3pjz5JBv5q8zVrCAgAEmyYA=
Date:   Thu, 20 Apr 2023 17:31:14 +0000
Message-ID: <71E9310C-06A6-41B9-AFE6-C8EE37CF5058@oracle.com>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
 <20230414225836.8952-2-wen.gang.wang@oracle.com>
 <20230419235559.GW3223426@dread.disaster.area>
In-Reply-To: <20230419235559.GW3223426@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|PH0PR10MB5627:EE_
x-ms-office365-filtering-correlation-id: b0b4290b-2ecb-4580-9a72-08db41c50a89
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dwDE8po/bpVdozNTDLD7AW+qD/MyHSWnVpSph4WE9IkoFePA1Wy9/ZpoYYGdifHCHzjLBfC5sSIxBx4upt7b1/LNnIu8mCeICELrwknryUJJiBhTuUxAAor1pQ4JbagOipjVSk6MiQ6Fo6vagk3/25Ac+2RqXgbMsm04VEKh6uWEccDK/fgz2fKKf7X61P+epRrtEWbvwIkBT0kdz7AXpf7crC0u1cdiRcLa329SGO1BA+3biVUOPALPyTzLjr3sWCJcNCj0jKzzfl2UwSaJ995zWQAkPpKqNbYUkdztzJH1WxQPKMZt4jvMmyyF+1YaI10zV351vhHrArWPw63uXBwtl3FBQ2ApWi5dtLJ016Q8smvPd9gtfSmwWc/Ae6B6JLb1go558hR2i70cKTeGuQ3McP6bK8kabxD2O2xyPt4ZvDjG0uNJOvKG3DV1vaeYLhMhTJI09FYPDMu05M4hZQaAYTEcpw0SBmzIQKa+3pnwh0I01KldPK1pJzWWpENr7wZCKMntqr5DSZxLQTXl6ufXVB8N4hSVZbKFoFLR3jcExtBCzyssRJL1SjF6QcavIVmqvbjZQlo49wEzLS2FNkedVUONhHyvuuJLz1zkKLLcjTZchapVNlImc/DL3LTt2GIylGTvKd8k40cIFsHhXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199021)(83380400001)(478600001)(2616005)(86362001)(6486002)(6506007)(6512007)(53546011)(71200400001)(4326008)(316002)(76116006)(64756008)(66946007)(66556008)(66446008)(66476007)(91956017)(6916009)(186003)(8676002)(8936002)(2906002)(122000001)(41300700001)(38100700002)(5660300002)(38070700005)(33656002)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekJYRmk3WWZPSFhhSlBiT1pQK0pmSEtEYXJRZy96Q1FsdXlWM0daUDFweldS?=
 =?utf-8?B?bmdPK3g0TXYzN0tuWkxXbExoenVXRE5md3lFVE4xNDV5NWpYaWQ4eThjVVVZ?=
 =?utf-8?B?d1RxSmhoU3NVUXpBUmdyWXQ4YmZFRUJ1ek5Qa3Y0VmQwNDc1WUgzMm83Y0Nl?=
 =?utf-8?B?Z3dGNjB4MXJFOW5JbzVkWGRTNlVKZU8wUTdFUUFFMmlnK253alA0K2xlTmhF?=
 =?utf-8?B?Z3FheFVXS3didm1qTUl2TktyREticFRRS0JnOHVWdWFHblRRM2NNSEw4U2VZ?=
 =?utf-8?B?UDhSaDNxQjVJU0g4ZkN4TTgvSThBWG1ZcnhJRHYyVnNMa1A5ZjJhcXNWSldl?=
 =?utf-8?B?cmIxTnM1SE1PL1ZPRFNIdWpuUkZhZ3lZVG9uRzIvczdhMk1yVS9RWXlXR0lx?=
 =?utf-8?B?ODMzWkFPc3lwQW5SSjdMYWc4dHlYSlRkUXI0WUUrS3lPc2I4cFFCUGROQ1Na?=
 =?utf-8?B?UkZ1ZFFzOWlETzg3N0pTMngwaWV3c1kwbE9JNGVpL3NHNUVOM2ViV3FQQm1H?=
 =?utf-8?B?dHdRc21uZGhXbmRZeHBFdmowaHVQYWg5aFpLWnlDNHRXNVhvQzVyYnRLejdX?=
 =?utf-8?B?WjFIYkM5ck1wUTA0aitrRGdNT3JPYjk3MjBhK3NzYitwNWlac3BETThVZnRz?=
 =?utf-8?B?RXdlMlZ3dFJQTndYZktxNUg4cURWY1hxTTlhQlhkaTljcWkva1VOTmliVkFT?=
 =?utf-8?B?QjVqR3NoL3c4Qkx1T1o0aHBQTk84YjhpZHlhTmxaTkV6L1g4V1ltU041a1hP?=
 =?utf-8?B?YjVBbmNGc1VLbytWa0l2Q2hBVUhyNDZBU3h0cmc0bDhSNG1qQXRDYWpacm45?=
 =?utf-8?B?Q0tDVXB1M3R5TEpiaEUxZnhLVDU4NjB3Rkh2UDZma3V2Tm5OTDNBamJKWmJv?=
 =?utf-8?B?aXhsSHBzOTMyMDIyeU05RmVYekRIekxQcmlmMC83UmxlQTRlK3NqK0JaQWhZ?=
 =?utf-8?B?eFNSSUgxaWhVaktETFFqSTU1OTJFWXg3cUFVMGorZllGak5waVBSWGNWL20w?=
 =?utf-8?B?UUFxY1JGbTRrUnR5Ky9ITDJ5a1ZoV1dmRDNLb2h3dkFxakVmVyt2UHRyZTZX?=
 =?utf-8?B?cUwxL1A0d1hORlhDUEYydVVadFRFTlBzTHVYYzM0MFJPb3hmVEtabFhaYm9r?=
 =?utf-8?B?RjBaMzdWOVk5SElrM0s2NEZyVHljVFFPbG1KRWdlNHZFbVc1L1NnVzRNYkdx?=
 =?utf-8?B?S3RIMTZhZE42dUVnQ3FrN09Da2pla1hDS1dBRWZaaWlMV2ljL3VkdGk5ZXZ3?=
 =?utf-8?B?WjMrYmlxSW9CK3RtaEVlclRuMXdLU0dJdUpUdENZUjNSRVR3Qmp1TEFiRk1P?=
 =?utf-8?B?RzRhdld2YXVmSDU4MS9Dd3RoMUpZYlVPWlVMdUw4dE1UcGs0STBabTE4anZD?=
 =?utf-8?B?anJKbUFQY09uKzBpOHZjdjFwbm1MY2VFUnFLd3QrSDhuU0w3SEdzVGY3VUhS?=
 =?utf-8?B?cXdWVkdvV1RETXlka1RtV3FhdDRrd2tDNlVSbU9NdXMwUEtmVnJwZjdCZ3Yy?=
 =?utf-8?B?bFpPSmw4WUlPRDJ6S1lKRXc1KzJZckFNKzRZWDBCRzdJSWtkcTNrWjhwd0RD?=
 =?utf-8?B?bVRkY3c2M21rS2Z6T0VKQnlydlk3OXVtVXEvYlRxVU11ZWhDRjc5emR2V2Rt?=
 =?utf-8?B?cmJMaTVMTWhsNUpLV0JNL3pjNXJYZlIzL25SRjVnRjdVNGxnVHJTbFFmUjFK?=
 =?utf-8?B?TC8yV1Q5bnozTUpqak1ZUEU2Wnc4SHBZNzhZMytZUk81ZzF3K3BVaGk3UGdO?=
 =?utf-8?B?ZzVQemh5eHRHdTQ4YzJzYlhQRzFFNXVuanI5em9zMVVrbit5eUpjVGdhSW9i?=
 =?utf-8?B?aDM2d1ZScUF2d0tha0lJZ1BwM0hXVzc2SUJRQy9jM1U0emNjdXdhanlhTkJt?=
 =?utf-8?B?MUEvdkpoZ2xML1FnZ3FZSk45WkhMVE81QkR6LzA4QURYMHR1NDRCVERBSHpp?=
 =?utf-8?B?eDRzRmI4akQzcXBiUlcyajdQc09JSktZVjZ6eEZuRVFMMHpYdmhGeTRpTEN5?=
 =?utf-8?B?bFRIdnJEbmh6M2diaUFQdjZ4Y0RWMlZnY2QvN1pRaVJOcnJHL2NKRXlBVFZU?=
 =?utf-8?B?eVlKOHNIWWZWUG1ZNXQrZE5PalNpSkNZdHhRa2tIUDY2YjFCdGlUTWFRcGxE?=
 =?utf-8?B?MFJhTGRDQkQ5S1UwSk9DVUcwa2EvV0JWMU5DTmdFekZIZ1NrRkxBQnU0Z2xD?=
 =?utf-8?Q?o1aALEYlRnbq1LkW4Ek3CgFVqlTy31NtuJBB2LF9Kak2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <82DBE8F7DFBB504AA07C8BA501028134@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xdIffqF0PIH71vv1qApo5m0UIiCj9bhyRM7pQJRSR0K+5PJguYf6FJDIpE+fxsYBSSaTlBlhgORjt6JRI24k23J9NomfcbjmoETOsFAeQhElQJmIH4RAylmZ03qJuJe1vakFeeej6qGeNx/pqAc7se+n2eAWV7BjSRRjwZ3+dsxzvJw5IiWmMuF1ZRjl6MrkzUR7ZQwVOwCn0bwchorHOCYZOo3XO8hiwEStk2DqhJoc6IVJO5wnnBNZw+gYi7x3y1of4poIBRu2tSgUob9SyuKs68pXnOgrq/ZdaRKTzolFpfzMnq9MrA6SIwP/05AF6oPc5WAIrPFZavQYzwoKG0mP9t8YnKJXBk8eQVhSueFCnRUs272BOGqffnr9irvg0+aj9Fg8DeuQlb983vdhuclLvDukaU7IvzEfzCOz+k4cYN3rhVRtMA0nMQ2oDkU+ZzUkGP70AtPedhAKlpAobXvENxXAsAbcCzGQkYZqyb7KRXNPVhfc5vpYN4nArh0MnF3+2uNHFMZKM+5uUwpP8xPoqOOvtUUqfKWCbGR3pQ6NMQl1YK6zbX5kFifEbBVAJi7OMYBIf7VYsqbWPfSOhorJPxE1YahNFUtfu0pHR5RtddnXbvGIyP81pzxHgIEt5HxJsI0fip0REaOY96hReeQzqMoXDv4OIDqPb9IuuiecRxKe28cHampWnHeK6AfkvsYmmXAuHWo7Xf8JdxLrnPJNUQ9VXWqa6UzvN32OT0JxqX06FfV0bE6/qljZr6J7+rCSHwohTdxqDRgSAOPHBiDh3/tuxZ8ohJO5a2AyGh8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b4290b-2ecb-4580-9a72-08db41c50a89
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 17:31:14.3802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p5NcUr8x5SX8TsgRjYkC/j+Jw4gX62KHPgYqQl0lGbynckiDeGwpW57q0VCsewUEZB8QXEyNfauFmFv0+4G5hOIghIHYDm1+ZT+fxezuVCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_13,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304200146
X-Proofpoint-GUID: E73Ou9vEvFLDTS-Y51D_TVrucCbs9_0U
X-Proofpoint-ORIG-GUID: E73Ou9vEvFLDTS-Y51D_TVrucCbs9_0U
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gQXByIDE5LCAyMDIzLCBhdCA0OjU1IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gRnJpLCBBcHIgMTQsIDIwMjMgYXQgMDM6NTg6
MzVQTSAtMDcwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gQXQgSU8gdGltZSwgbWFrZSBzdXJl
IGFuIEVGSSBjb250YWlucyBvbmx5IG9uZSBleHRlbnQuIFRyYW5zYWN0aW9uIHJvbGxpbmcgaW4N
Cj4+IHhmc19kZWZlcl9maW5pc2goKSB3b3VsZCBjb21taXQgdGhlIGJ1c3kgYmxvY2tzIGZvciBw
cmV2aW91cyBFRklzLiBCeSB0aGF0IHdlDQo+PiBhdm9pZCBob2xkaW5nIGJ1c3kgZXh0ZW50cyAo
Zm9yIHByZXZpb3VzbHkgZXh0ZW50cyBpbiB0aGUgc2FtZSBFRkkpIGluIGN1cnJlbnQNCj4+IHRy
YW5zYWN0aW9uIHdoZW4gYWxsb2NhdGluZyBibG9ja3MgZm9yIEFHRkwgd2hlcmUgd2UgY291bGQg
YmUgb3RoZXJ3aXNlIHN0dWNrDQo+PiB3YWl0aW5nIHRoZSBidXN5IGV4dGVudHMgaGVsZCBieSBj
dXJyZW50IHRyYW5zYWN0aW9uIHRvIGJlIGZsdXNoZWQgKHRodXMgYQ0KPj4gZGVhZGxvY2spLg0K
Pj4gDQo+PiBUaGUgbG9nIGNoYW5nZXMNCj4+IDEpIGJlZm9yZSBjaGFuZ2U6DQo+PiANCj4+ICAg
IDM1OCByYmJuIDEzIHJlY19sc246IDEsMTIgT3BlciA1OiB0aWQ6IGVlMzI3ZmQyICBsZW46IDQ4
IGZsYWdzOiBOb25lDQo+PiAgICAzNTkgRUZJICBuZXh0ZW50czoyIGlkOmZmZmY5ZmVmNzA4YmE5
NDANCj4+ICAgIDM2MCBFRkkgaWQ9ZmZmZjlmZWY3MDhiYTk0MCAoMHgyMSwgNykNCj4+ICAgIDM2
MSBFRkkgaWQ9ZmZmZjlmZWY3MDhiYTk0MCAoMHgxOCwgOCkNCj4+ICAgIDM2MiAtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
Pj4gICAgMzYzIHJiYm4gMTMgcmVjX2xzbjogMSwxMiBPcGVyIDY6IHRpZDogZWUzMjdmZDIgIGxl
bjogNDggZmxhZ3M6IE5vbmUNCj4+ICAgIDM2NCBFRkQgIG5leHRlbnRzOjIgaWQ6ZmZmZjlmZWY3
MDhiYTk0MA0KPj4gICAgMzY1IEVGRCBpZD1mZmZmOWZlZjcwOGJhOTQwICgweDIxLCA3KQ0KPj4g
ICAgMzY2IEVGRCBpZD1mZmZmOWZlZjcwOGJhOTQwICgweDE4LCA4KQ0KPj4gDQo+PiAyKSBhZnRl
ciBjaGFuZ2U6DQo+PiANCj4+ICAgIDgzMCByYmJuIDMxIHJlY19sc246IDEsMzAgT3BlciA1OiB0
aWQ6IDMxOWYwMTVmICBsZW46IDMyIGZsYWdzOiBOb25lDQo+PiAgICA4MzEgRUZJICBuZXh0ZW50
czoxIGlkOmZmZmY5ZmVmNzA4YjliODANCj4+ICAgIDgzMiBFRkkgaWQ9ZmZmZjlmZWY3MDhiOWI4
MCAoMHgyMSwgNykNCj4+ICAgIDgzMyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4gICAgODM0IHJiYm4gMzEgcmVjX2xz
bjogMSwzMCBPcGVyIDY6IHRpZDogMzE5ZjAxNWYgIGxlbjogMzIgZmxhZ3M6IE5vbmUNCj4+ICAg
IDgzNSBFRkkgIG5leHRlbnRzOjEgaWQ6ZmZmZjlmZWY3MDhiOWQzOA0KPj4gICAgODM2IEVGSSBp
ZD1mZmZmOWZlZjcwOGI5ZDM4ICgweDE4LCA4KQ0KPj4gICAgODM3IC0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+PiAgICA4
MzggcmJibiAzMSByZWNfbHNuOiAxLDMwIE9wZXIgNzogdGlkOiAzMTlmMDE1ZiAgbGVuOiAzMiBm
bGFnczogTm9uZQ0KPj4gICAgODM5IEVGRCAgbmV4dGVudHM6MSBpZDpmZmZmOWZlZjcwOGI5Yjgw
DQo+PiAgICA4NDAgRUZEIGlkPWZmZmY5ZmVmNzA4YjliODAgKDB4MjEsIDcpDQo+PiAgICA4NDEg
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0NCj4+ICAgIDg0MiByYmJuIDMxIHJlY19sc246IDEsMzAgT3BlciA4OiB0aWQ6IDMx
OWYwMTVmICBsZW46IDMyIGZsYWdzOiBOb25lDQo+PiAgICA4NDMgRUZEICBuZXh0ZW50czoxIGlk
OmZmZmY5ZmVmNzA4YjlkMzgNCj4+ICAgIDg0NCBFRkQgaWQ9ZmZmZjlmZWY3MDhiOWQzOCAoMHgx
OCwgOCkNCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogV2VuZ2FuZyBXYW5nIDx3ZW4uZ2FuZy53YW5n
QG9yYWNsZS5jb20+DQo+PiAtLS0NCj4+IGZzL3hmcy94ZnNfZXh0ZnJlZV9pdGVtLmggfCA5ICsr
KysrKysrLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19leHRmcmVlX2l0ZW0uaCBiL2ZzL3hm
cy94ZnNfZXh0ZnJlZV9pdGVtLmgNCj4+IGluZGV4IGRhNmE1YWZhNjA3Yy4uYWU4NGQ3N2VhZjMw
IDEwMDY0NA0KPj4gLS0tIGEvZnMveGZzL3hmc19leHRmcmVlX2l0ZW0uaA0KPj4gKysrIGIvZnMv
eGZzL3hmc19leHRmcmVlX2l0ZW0uaA0KPj4gQEAgLTEzLDggKzEzLDE1IEBAIHN0cnVjdCBrbWVt
X2NhY2hlOw0KPj4gDQo+PiAvKg0KPj4gICogTWF4IG51bWJlciBvZiBleHRlbnRzIGluIGZhc3Qg
YWxsb2NhdGlvbiBwYXRoLg0KPj4gKyAqDQo+PiArICogQXQgSU8gdGltZSwgbWFrZSBzdXJlIGFu
IEVGSSBjb250YWlucyBvbmx5IG9uZSBleHRlbnQuIFRyYW5zYWN0aW9uIHJvbGxpbmcNCj4+ICsg
KiBpbiB4ZnNfZGVmZXJfZmluaXNoKCkgd291bGQgY29tbWl0IHRoZSBidXN5IGJsb2NrcyBmb3Ig
cHJldmlvdXMgRUZJcy4gQnkNCj4+ICsgKiB0aGF0IHdlIGF2b2lkIGhvbGRpbmcgYnVzeSBleHRl
bnRzIChmb3IgcHJldmlvdXNseSBleHRlbnRzIGluIHRoZSBzYW1lIEVGSSkNCj4+ICsgKiBpbiBj
dXJyZW50IHRyYW5zYWN0aW9uIHdoZW4gYWxsb2NhdGluZyBibG9ja3MgZm9yIEFHRkwgd2hlcmUg
d2UgY291bGQgYmUNCj4+ICsgKiBvdGhlcndpc2Ugc3R1Y2sgd2FpdGluZyB0aGUgYnVzeSBleHRl
bnRzIGhlbGQgYnkgY3VycmVudCB0cmFuc2FjdGlvbiB0byBiZQ0KPj4gKyAqIGZsdXNoZWQgKHRo
dXMgYSBkZWFkbG9jaykuDQo+PiAgKi8NCj4+IC0jZGVmaW5lIFhGU19FRklfTUFYX0ZBU1RfRVhU
RU5UUyAxNg0KPj4gKyNkZWZpbmUgWEZTX0VGSV9NQVhfRkFTVF9FWFRFTlRTIDENCj4gDQo+IElJ
UkMsIHRoaXMgZG9lc24ndCBoYXZlIGFueXRoaW5nIHRvIGRvIHdpdGggdGhlIG51bWJlciBvZiBl
eHRlbnRzIGFuDQo+IEVGSSBjYW4gaG9sZC4gQWxsIGl0IGRvZXMgaXMgY29udHJvbCBob3cgdGhl
IG1lbW9yeSBmb3IgdGhlIEVGSQ0KPiBhbGxvY2F0ZWQuDQo+IA0KDQpZZXMsIGl0IGVuc3VyZXMg
dGhhdCBvbmUgRUZJIGNvbnRhaW5zIGF0IG1vc3Qgb25lIGV4dGVudC4gQW5kIGJlY2F1c2UgZWFj
aA0KZGVmZXJyZWQgaW50ZW50IGdvZXMgd2l0aCBvbmUgdHJhbnNhY3Rpb24gcm9sbCwgaXQgd291
bGQgc29sdmUgdGhlIEFHRkwgYWxsb2NhdGlvbg0KZGVhZGxvY2sgKGJlY2F1c2Ugbm8gYnVzeSBl
eHRlbnRzIGhlbGQgYnkgdGhlIHByb2Nlc3Mgd2hlbiBpdCBpcyBkb2luZyB0aGUNCkFHRkwgYWxs
b2NhdGlvbikuDQpBbmQgeWVzLCB0aGlzIHdvdWxkIHJlcXVpcmVzIG1vcmUgbG9nIHNwYWNlIGlm
IHRoZSBFRkkvRUZEIHBhaXIgZG9lc27igJl0IGFwcGVhcg0KaW4gc2FtZSBjaGVja3BvaW50Lg0K
DQoNCj4gT2gsIGF0IHNvbWUgcG9pbnQgaXQgZ290IG92ZXJsb2FkZWQgY29kZSB0byBkZWZpbmUg
dGhlIG1heCBpdGVtcyBpbg0KPiBhIGRlZmVyIG9wcyB3b3JrIGl0ZW0uIE9rLCBJIG5vdyBzZWUg
d2h5IHlvdSBjaGFuZ2VkIHRoaXMsIGJ1dCBJDQo+IGRvbid0IHRoaW5rIHRoaXMgaXMgcmlnaHQg
d2F5IHRvIHNvbHZlIHRoZSBwcm9ibGVtLiBXZSBjYW4gaGFuZGxlDQo+IHByb2Nlc3NpbmcgbXVs
dGlwbGUgZXh0ZW50cyBwZXIgRUZJIGp1c3QgZmluZSwgd2UganVzdCBuZWVkIHRvDQo+IHVwZGF0
ZSB0aGUgRUZEIGFuZCByb2xsIHRoZSB0cmFuc2FjdGlvbiBvbiBlYWNoIGV4dGVudCB3ZSBwcm9j
ZXNzLA0KPiB5ZXM/DQo+IA0KDQpJIGFtIG5vdCBxdWl0ZSBzdXJlIHdoYXQgZG9lcyDigJx1cGRh
dGUgdGhlIEVGROKAnSBtZWFuLg0KTXkgb3JpZ2luYWwgY29uY2VybiBpcyB0aGF0ICh3aXRob3V0
IHlvdXIgdXBkYXRlZCBFRkQpLCB0aGUgZXh0ZW50cyBpbiBvcmlnaW5hbCBFRkkgY2FuIGJlIHBh
cnRpYWxseSBkb25lIGJlZm9yZSBhIGNydXNoLiBBbmQgZHVyaW5nIHRoZSByZWNvdmVyeSwgdGhl
IGFscmVhZHkgZG9uZSBleHRlbnRzIHdvdWxkIGFsc28gYmUgcmVwbGF5ZWQgYW5kIGhpdCBlcnJv
ciAoYmVjYXVzZSB0aGUgaW4tcGxhY2UgbWV0YWRhdGEgY291bGQgYmUgZmx1c2hlZCBzaW5jZSB0
aGUgdHJhbnNhY3Rpb24gaXMgcm9sbGVkLikuDQoNCk5vdyBjb25zaWRlciB5b3VyIOKAnHVwZGF0
ZSB0aGUgRUZE4oCdLCB5b3UgbWVhbnQgdGhlIGZvbGxvd2luZz8NCg0KRUZJOiAgSUQ6ICBUSElT
SVNJRDEgICBleHRlbnQxIGV4dGVudDINCmZyZWUgZXh0ZW50IGV4dGVudDENCkVGRDogSUQ6IFRI
SVNJU0lEMSAgZXh0ZW50MQ0KZnJlZSBleHRlbnQgZXh0ZW50Mg0KYW5vdGhlciBFRkQ6IElEOiBU
SElTSVNJRDEgKHNhbWUgSUQgYXMgYWJvdmUpICBleHRlbnQyDQoNCkRvIHdlIGN1cnJlbnRseSBz
dXBwb3J0IHRoYXQ/ICggSSBhbSB0aGlua2luZyBOTykuDQoNCnRoYW5rcywNCndlbmdhbmcNCg0K
PiBJbiBoaW5kc2lnaHQsIHRoZSB1c2Ugb2YgWEZTX0VGSV9NQVhfRkFTVF9FWFRFTlRTIHRvIGxp
bWl0IGludGVudA0KPiBzaXplIGlzIHByZXR0eSBhd2Z1bC4gSSBhbHNvIHNlZSB0aGUgc2FtZSBw
YXR0ZXJuIGNvcGllZCBpbiBldmVyeQ0KPiBvdGhlciBpbnRlbnQuDQo+IA0KPiBEYXJyaWNrLCBp
ZiB0aGUgZGVmZXJvcHMgY29kZSBoYXMgYmVlbiBsaW1pdGluZyB0aGUgbnVtYmVyIG9mDQo+IGV4
dGVudHMgaW4gYSB3b3JrIGl0ZW0gdG8gdGhpcyB2YWx1ZSwgd2hlbiB3aWxsIHdlIGV2ZXIgc2Vl
IGFuDQo+IGludGVudCB3aXRoIG1vcmUgZXh0ZW50cyB0aGF0IC5tYXhfaXRlbXMgaW4gaXQ/IEFu
ZCBpZiB0aGF0IGlzIHRoZQ0KPiBjYXNlLCB0aGVuIHdoeSB3b3VsZG4ndCB3ZSBjb25zaWRlciBh
biBpbnRlbnQgd2l0aCBtb3JlIGV4dGVudHMgdGhhbg0KPiB3ZSBzdXBwb3J0IGluIGxvZyByZWNv
dmVyeSBhIGNvcnJ1cHRpb24gZXZlbnQ/DQo+IA0KPiBDaGVlcnMsDQo+IA0KPiBEYXZlLg0KPiAt
LSANCj4gRGF2ZSBDaGlubmVyDQo+IGRhdmlkQGZyb21vcmJpdC5jb20NCg0KDQo=
