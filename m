Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D988C54EBD
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Jan 2023 04:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjAME5I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Jan 2023 23:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjAME5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2023 23:57:04 -0500
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 Jan 2023 20:57:02 PST
Received: from esa4.fujitsucc.c3s2.iphmx.com (esa4.fujitsucc.c3s2.iphmx.com [68.232.151.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BC15B141
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2023 20:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1673585823; x=1705121823;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=giInVJBvTM8BYcl5zJG42SAcJoD8xAS6zSmeL5A39oI=;
  b=yFVtaJJyXE4GX4FiRfe9nMZS6OLBomIo7uFjDNRFGnOX43B5nnCHL5u1
   bUkk8TIOrzpwBSZezLcV/RLKOOj67Xda9W0j9ArPuYRi2MLp+irnCp29H
   oRMmywLM+KtvL9ihFRKjzPCCzArPBodH5DDCWlQ7PC8yL+ah/X1S243Hn
   hDRtedZjKbIuZn4BZpEjVd+DyEAY8Tvr91sLXk9CdFtXBndsHsKWhhJeV
   M0AbbSi1yxjDyMZnyjHbNwzKQYtdFdYabYD2SHRBIkKIf3kJFT+fr7VVg
   NulVH0o2sR5y0K6YN5mINiTjOOw3pPJtXDJofS6p0lJ/y/llMZv+AQ+Ij
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="82235716"
X-IronPort-AV: E=Sophos;i="5.97,213,1669042800"; 
   d="scan'208";a="82235716"
Received: from mail-tycjpn01lp2169.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.169])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 13:55:55 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyTiXapjU+by6B86zLI72TFUfib2QSMNiuJjkqJe+Oqsj8Fw/aJnKFBIvMoqcJ14dNaWExNX/yC3ECs+vWw0f14pTLY4jv0VT7wOkqaF2/SZkZdHUnHFQzFLmaPoaf3NTz04h2+f9ayqR4OW1rxa5KuMWIm2A+p7QL9Fqo9/UfbDql5jbCsPC2i5dEJ3gPJoB9pO9N2frOJyjhwZk5GOAhgni3yyshdVQOGAoBmpfd4IXGha+KbI7GFgNznWsbBZyHtwsg7jmzZhF9j6IE1YBR4HzF85XwiyAps7PVTx00rR2YE0UIVWtKW7nYL5xpe4RLqBJl4SmZsQwZWT6cX74A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giInVJBvTM8BYcl5zJG42SAcJoD8xAS6zSmeL5A39oI=;
 b=YlPlDfxiIuipSdzxsuihJwRF/5QBhsr8O2ToenJj9g/JUOIafgXXzagBcQ8qB2fyPph4mzZtogBVJXxLPB2WOyaBiKroZoNUIsqD9x5UhyUl+gBdydm6lzjDHnqePm4jaaUswionsSfED33z6Yb1riF/IzHMnIDFVWZRsetcozc1LEht2WR5ayu5PJD4IsVxhyLRucbkQJwA4VGtdYlfxLZ8Dli0fxe+1UKhRIwSjVAKgbF62mItoSPycl3YO5D3/xkdkEI36kMTy1qiwXj1E70jSHkQLo9FftqGjKS9MxxLeZu7uMmqxtGMgBOs1CT+xJSVaZ68lKvHvpZgdHvapw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS3PR01MB9499.jpnprd01.prod.outlook.com (2603:1096:604:1c8::5)
 by TYCPR01MB11225.jpnprd01.prod.outlook.com (2603:1096:400:3c1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Fri, 13 Jan
 2023 04:55:52 +0000
Received: from OS3PR01MB9499.jpnprd01.prod.outlook.com
 ([fe80::b8f9:ad58:e707:a6e7]) by OS3PR01MB9499.jpnprd01.prod.outlook.com
 ([fe80::b8f9:ad58:e707:a6e7%4]) with mapi id 15.20.6002.012; Fri, 13 Jan 2023
 04:55:52 +0000
From:   "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>
To:     "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
        Stefan Roesch <shr@meta.com>, "shr@fb.com" <shr@fb.com>,
        "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Subject: RE: [PATCH] xfs: Call kiocb_modified() for buffered write
Thread-Topic: [PATCH] xfs: Call kiocb_modified() for buffered write
Thread-Index: AQHY+cm8Yalgbur0/E2s/CuBz0fAva5B59SAgAB9G4CAWb3VgA==
Date:   Fri, 13 Jan 2023 04:55:51 +0000
Message-ID: <OS3PR01MB9499B1C48D863B2A62E9EA0983C29@OS3PR01MB9499.jpnprd01.prod.outlook.com>
References: <1668609741-14-1-git-send-email-yangx.jy@fujitsu.com>
 <15e09968-8395-c8e4-aa6e-aa11b29fa175@meta.com>
 <8987307e-14b7-44a0-fab0-ab141921f858@fujitsu.com>
In-Reply-To: <8987307e-14b7-44a0-fab0-ab141921f858@fujitsu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: =?utf-8?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2Uw?=
 =?utf-8?B?NTBfQWN0aW9uSWQ9Y2E1ZjljNmYtNzYzMy00ZGVlLTllMWMtNjMyZDI1YWZk?=
 =?utf-8?B?ZWYxO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRm?=
 =?utf-8?B?ZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5?=
 =?utf-8?B?LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX01ldGhv?=
 =?utf-8?B?ZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1hYjRk?=
 =?utf-8?B?LTNiMGY0ZmVjZTA1MF9OYW1lPUZVSklUU1UtUkVTVFJJQ1RFRO+/ou++gA==?=
 =?utf-8?B?776LO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRm?=
 =?utf-8?B?ZWNlMDUwX1NldERhdGU9MjAyMy0wMS0xM1QwNDo1NDo1Mlo7TVNJUF9MYWJl?=
 =?utf-8?B?bF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfU2l0ZUlk?=
 =?utf-8?Q?=3Da19f121d-81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB9499:EE_|TYCPR01MB11225:EE_
x-ms-office365-filtering-correlation-id: 52e5133c-ceaf-4111-fc6d-08daf522723a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VvNAVSCzwTyHEKgMu3PfPp1QgXP1rlM5HKHIXh7hCXFshGVJJAE9qSBiLHmFcosGDUfaRDXFKu7IkBxRQHCTOIRfw3A1BO+jNE6qZT/X5c9kA1Qh9oZQEZyP2kxJt1JFUmAJqVVPUX7bCkoq4l5QawTGJ9nUBpBCuKSw8S4yWlcBoxo166WGUMGvr3IB9gYIiHnKyDdphVJRpJIUhCDGeEDnUDa8XadONWhltClzK5RxzObybyAiBfGlzrN3i+htfejg2gkqT6biCId2ELt/WEIggcpygWyzW5dKLgH9Qs9uWzfV+NsVQ18F5V8si4Vi4rQqJSkpiAts0jjxd++ezuklbEdcBx1/eUn/3/xF90XJyXI1jX7Zn9V6aW4j8Pdv/ZRObIr0poOLjebglBFfaVoYVUBSzoHSvA0demsvbD5wtvY0NOunjiV/Xe/k3BNd7GWjnV4pEd0yTAfPSLRex2veOs232gUyyjFxGD7VyMN7yyQHObQaPEAN1yBNyB4tSK3chrQMLtpugo76UIq9cw8Lf3UaoDJpwgEKyun3/7f7uG1iuLqdOIBIClRaQ2q0HV8KcI+ppNb5zibPj2TvLqRZXZDdCUevDStc8Wt0ELKRZ5U7GvCONSu4bEeoIUI4JrFSvI80I/lJMjmVzG5BdlfMu3wHaKbofnm/+a2sn6nhhnuaY2uBk4Jx8h8N2uGq0zejngvPVWVR5zcsMQNoA6QIzgIi8a9ETUS0jZ7a0IubrtlIQE6p14aQqe4DTTqF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB9499.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(1590799012)(451199015)(53546011)(2906002)(6506007)(107886003)(83380400001)(1580799009)(86362001)(41300700001)(9686003)(85182001)(26005)(33656002)(5660300002)(52536014)(478600001)(186003)(8936002)(76116006)(66946007)(66556008)(66476007)(64756008)(66446008)(55016003)(7696005)(54906003)(82960400001)(38100700002)(316002)(4326008)(110136005)(8676002)(71200400001)(38070700005)(122000001)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFdKMHJPSXZ3RHZ6WjlrbjZsWktqaXRyYm5JcmlUazFuZmYvRng5a2ZFNDRr?=
 =?utf-8?B?UVUxVjRHa0duY25xVSt3MGVPdWZTd2QwRk1CY0JZN2t3bUFrOTcyditFR2hC?=
 =?utf-8?B?ZXN3NEdQbC9lckFLcE8zRTVFUWRTbHl3ektXSDc0eU01OFlFZ1QxMHBGWjY4?=
 =?utf-8?B?VnpSamJYd3M4am1wOHQxK1VkS0xRUzlETGhuYzZoa0kwVVZ4dUQxd2NCT2xM?=
 =?utf-8?B?bUNZUi82aTVxZ0dTQWNTUnlRbmltOCsyWWVwVDR0R01WN20vRk1ZS3Fna1VE?=
 =?utf-8?B?VlArNklKVENDaEFyWnorclhxaUs4UmNXRlphSXU2UkVISldDeHNJNlhBTDZo?=
 =?utf-8?B?TGtOUEhxRU9OTlRCNDRDTFJ0SmFyL2JIK0tWVmRsSXlOcEs3cjlSZ2lxS3RD?=
 =?utf-8?B?TjBvRDFaVjNna0lBY1F6NTV2bWJqOXFEV0tWN3JwT0UwYU5aT0NhYmpFOXIr?=
 =?utf-8?B?M3AycDlzTng3T1VCY28rVjM1ZEUyMVJ4V3JSK1VVOW1USkZBSmZWVUFoMTBG?=
 =?utf-8?B?Q2pxT0haQ2w0bW5SSk9UL2R1U0pBSVVSMnRPbUNpUTh6UzNLd0Q2OFNIU3hj?=
 =?utf-8?B?OVhRNTR6RUszbmgvS2ZiakV4cm5lMTM1czVxVUF5T1d6VCtVVTVjQVRmY2Yz?=
 =?utf-8?B?cmVjTEtnL2MrWmdlSWd2dmZ2aDFiYVE3WWxEb3BjREEyWW12V2ZQS1QyOGxW?=
 =?utf-8?B?b2daQWtsNUIrNGdNZ2FVRVVXL2F5VStDMFlqVDNSclVxdHoxZWFmS3NEZWlN?=
 =?utf-8?B?MWFKN3pPdVB2TzFHSmRhZDUzVk5GZU1RNU42RERlYi9yeWtDTFZNaXFaQU90?=
 =?utf-8?B?RCtyNXlHYTdlNmxWajB1enUwMXVZZVlyaklVTXh0WFdKZHpZZVZtNlhGbGlF?=
 =?utf-8?B?WFhPTzUwTUg0R2IxdVJnTTFRZTFqTW9XMDh0ZnFXU01WMk9aL1Awam5EUGdG?=
 =?utf-8?B?YnZzVkRleXpaOWkrK25jWWg2bjR5Y1NiS25xZzI0c1I3ampuNGM0a0VxU0xG?=
 =?utf-8?B?cGd5Y0VPNDZiNGhhaEdzV3FyU0tTU05LWWVGOG53bTBNYnNNY3lLV1JqV2lp?=
 =?utf-8?B?K3oweFVrMlloMTY3d0FpcHRTMHRoZnR1cFN1bHo1WjdaSUpyR3NISDVQYUFw?=
 =?utf-8?B?ckpyUzRCeHVXY2hUdEdNZk1wMzdBTVBtZ1Z1NEhkUlcvVnYzaUFHNDdZZXZN?=
 =?utf-8?B?bFlCT3pwZ3UwODZkbno4TnhsdGZ2N0g2RzQxVEF0YWpGbFVUR1N0eXovMDl3?=
 =?utf-8?B?UENOaXA3ZjVXVXUxSnFncHp3T0Y0VkF4T1F1T0ZmN0RwU3F3dGx5aVFsQy9m?=
 =?utf-8?B?VGhZLzNxZDBGa20vYi8xSUdpL3BVb3k1WmNObzlzZmtWWDhwcFpNNUZYdFA1?=
 =?utf-8?B?K1BTNWdoSkFtQTNiSXR2OWZmdENYOW5zclV4Wmk3TGl3V3U0c0RCTXhqOW1k?=
 =?utf-8?B?M04zQkhnWmtvNkJ0UzFmV2JmUzVwRHV2WVRTVWJJMVNIMG81WC9WNGlhZVls?=
 =?utf-8?B?aTRvbFkxMFhzYlI1T0EyY1JhRmhGZG5hckNtQmpkRC9HZlRUekJjOVphamcw?=
 =?utf-8?B?THVPWktVUVpjVzhTTGx3dEQ5dWpydDh4NE0vNVAreDZTS2t1WjdlZ2tsNVI5?=
 =?utf-8?B?ZHJrK281TGFxMG4wMTlUZGYrenQ1cmJGQU9NQURiZXNqd0JzS2F5ZXVPNk1x?=
 =?utf-8?B?ZnExNGYyamN5L296TkpJM0g4NTBodzFFYkJZVDFDL1lLUk9wOU5wS1hPd292?=
 =?utf-8?B?cWJib0pCNy9HeUc4RURmZlhNWm9sbEJZUUZscERaSFRscm9oZkVadEsyZ0Ru?=
 =?utf-8?B?YzJORmhKSlVMU2RGbWJLLzE5Y1ltL2pWMVhSOHZGVVFOMUJiTzVQWktObTdQ?=
 =?utf-8?B?b1dkMFRza0JNQ1hEUUlJVzNValZ4d0dwQnIzRklucXdXVUEzMHFlK0c4UWNi?=
 =?utf-8?B?MHZaNHA5ME9XNWJ6NDg1SXpIanlOMjhnZTcwWGNLQjJNRGY1RUdPUE0rM1p3?=
 =?utf-8?B?RGpENWpjWkY5ZG9kQ3BUZlF3ZzZmbFRoSGt1MHZ6a2VJMWUzdmZQQlhCMC9q?=
 =?utf-8?B?VEZQbWxSdTZzMHlDT2h1Y01LbHJGdU5KaGI2dVJObzM4eG9qWXd1Q1ZtUXZG?=
 =?utf-8?Q?G7Uy92Cme9iUOjs1wvL6dUZ4n?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: oj13A3gwqjVQ2VKUe5hi6bsLI2U+nJ648ZyDLYKPL9sIkbF2s6bX1C03Uuc+PPOANSheUEoFWWF1Aevnj3t31ScTXeaklagma1wYGPVuKmtfZqNBqP5sIonT+uFiFVH2JowsNK/P0qq7rZc1wGWUcWGPXqDui62v92AILX0iysBg1W053OO6JLwWR8OSC3OzT9TgVKZmgmsXG6puWogIoCf3UReQYq/uq50EUBvzEl6mr14LOUh/XxaAYFj/juM5h9fjfFCMsURteOeVZTJPPmOxVDd6prUT3sEU98N5CHb2mKeWAGZwq0+SuZEcq9/TAQnvvJMdaiqPqt7p6wLUM7dq7sNx2fppQHwx4BYvH5dBHqJa5y/LZkrDPXX9Njh0hqv3w09svovFvGX1bO1fsWMJZlQoSjI1nOkXNeRkGn6zExbzhUK/OKtBPDS0vttP9fIiGibRw7qjxtKRw6Evk8wZRdUvZbWQ/NUgdUO3/JFdBifIAHQjeLZ4uY2uTE3bY5s+l61O/QgoB0JUuHz4M+P6cfFqxD3slKmkE5Lgeuyd9EC97KrdEwdM2898yzVfLCOweRE2H7nuIltMlScQQROn7WeBuz4OaiJJmEbqL0WYfVMi+pMfyy2vMGeXedhtFtxPrWhC0QzyNBDF6UFQvhiLCi7sAlizQvtmkpyl03pR1/Q0lSfj3fAK75OWDecvH3L+yPIsBeKQ6KHe/i80ogYcNzmf0GV7AjN+4V55YsStrqGg7dpvpS6E0b6huasjn/3H2gcvmZMuLEsMsySbfvC8WVlUdQBuTejU89BH9ipA8p2C8jkYJtKtTwbmyeVyYYhZLdWdUd/E6kuodH4a/w==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB9499.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e5133c-ceaf-4111-fc6d-08daf522723a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 04:55:51.9883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yv64obH+PRcbeVGnzI/59j61H41Q2hwRJokQ9aP+AsF6wMTWMzbDWIrPjHJHevcWB26fjVTKzjONN2CNxiYbsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB11225
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SGkNCg0KS2luZGx5IHBpbmcuIF5fXg0KDQpCZXN0IFJlZ2FyZHMsDQpYaWFvIFlhbmcNCg0KLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFlhbmcsIFhpYW8v5p2oIOaZkyA8eWFuZ3gu
anlAZnVqaXRzdS5jb20+IA0KU2VudDogMjAyMuW5tDEx5pyIMTfml6UgMTA6MjgNClRvOiBTdGVm
YW4gUm9lc2NoIDxzaHJAbWV0YS5jb20+OyBzaHJAZmIuY29tOyBkandvbmdAa2VybmVsLm9yZw0K
Q2M6IGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc7IFJ1YW4sIFNoaXlhbmcv6ZiuIOS4lumYsyA8
cnVhbnN5LmZuc3RAZnVqaXRzdS5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENIXSB4ZnM6IENhbGwg
a2lvY2JfbW9kaWZpZWQoKSBmb3IgYnVmZmVyZWQgd3JpdGUNCg0KT24gMjAyMi8xMS8xNyAzOjAw
LCBTdGVmYW4gUm9lc2NoIHdyaXRlOg0KPiANCj4gT24gMTEvMTYvMjIgNjo0MiBBTSwgWGlhbyBZ
YW5nIHdyb3RlOg0KPj4ga2lvY2JfbW9kaWZpZWQoKSBzaG91bGQgYmUgdXNlZCBmb3Igc3luYy9h
c3luYyBidWZmZXJlZCB3cml0ZSBiZWNhdXNlIA0KPj4gaXQgd2lsbCByZXR1cm4gLUVBR0FJTiB3
aGVuIElPQ0JfTk9XQUlUIGlzIHNldC4gVW5mb3J0dW5hdGVseSwNCj4+IGtpb2NiX21vZGlmaWVk
KCkgaXMgdXNlZCBieSB0aGUgY29tbW9uIHhmc19maWxlX3dyaXRlX2NoZWNrcygpIHdoaWNoIA0K
Pj4gaXMgY2FsbGVkIGJ5IGFsbCB0eXBlcyBvZiB3cml0ZShpLmUuIGJ1ZmZlcmVkL2RpcmVjdC9k
YXggd3JpdGUpLg0KPj4gVGhpcyBpc3N1ZSBtYWtlcyBnZW5lcmljLzQ3MSB3aXRoIHhmcyBhbHdh
eXMgZ2V0IHRoZSBmb2xsb3dpbmcgZXJyb3I6DQo+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4gUUEgb3V0cHV0IGNyZWF0ZWQgYnkg
NDcxDQo+PiBwd3JpdGU6IFJlc291cmNlIHRlbXBvcmFyaWx5IHVuYXZhaWxhYmxlIHdyb3RlIDgz
ODg2MDgvODM4ODYwOCBieXRlcyANCj4+IGF0IG9mZnNldCAwIFhYWCBCeXRlcywgWCBvcHM7IFhY
OlhYOlhYLlggKFhYWCBZWVkvc2VjIGFuZCBYWFggDQo+PiBvcHMvc2VjKQ0KPj4gcHdyaXRlOiBS
ZXNvdXJjZSB0ZW1wb3JhcmlseSB1bmF2YWlsYWJsZSAuLi4NCj4+IC0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+Pg0KPiBUaGVyZSBoYXZl
IGJlZW4gZWFybGllciBkaXNjdXNzaW9ucyBhYm91dCB0aGlzLiBTbmlwcGV0IGZyb20gdGhlIA0K
PiBlYXJsaWVyIGRpc2N1c3Npb246DQo+IA0KPiAiZ2VuZXJpYy80NzEgY29tcGxhaW5zIGJlY2F1
c2UgaXQgZXhwZWN0cyBhbnkgd3JpdGUgZG9uZSB3aXRoIA0KPiBSV0ZfTk9XQUlUIHRvIHN1Y2Nl
ZWQgYXMgbG9uZyBhcyB0aGUgYmxvY2tzIGZvciB0aGUgd3JpdGUgYXJlIGFscmVhZHkgaW5zdGFu
dGlhdGVkLg0KPiBUaGlzIGlzbid0IG5lY2Vzc2FyaWx5IGEgY29ycmVjdCBhc3N1bXB0aW9uLCBh
cyB0aGVyZSBhcmUgb3RoZXIgDQo+IGNvbmRpdGlvbnMgdGhhdCBjYW4gY2F1c2UgYW4gUldGX05P
V0FJVCB3cml0ZSB0byBmYWlsIHdpdGggLUVBR0FJTiANCj4gZXZlbiBpZiB0aGUgcmFuZ2UgaXMg
YWxyZWFkeSB0aGVyZS4iDQoNCkhpIFN0ZWZhbiwNCg0KVGhhbmtzIGZvciB5b3VyIHJlcGx5Lg0K
Q291bGQgeW91IGdpdmUgbWUgdGhlIFVSTCBhYm91dCB0aGUgZWFybGllciBkaXNjdXNzaW9ucz8N
Cg0Ka2lvY2JfbW9kaWZpZWQoKSBtYWtlcyBhbGwgdHlwZXMgb2Ygd3JpdGUgYWx3YXlzIGdldCAt
RUFHQUlOIHdoZW4gUldGX05PV0FJVCBpcyBzZXQuICBJIGRvbid0IHRoaW5rIHRoaXMgcGF0Y2hb
MV0gaXMgY29ycmVjdCBiZWNhdXNlIGl0IGNoYW5nZWQgdGhlIG9yaWdpbmFsIGxvZ2ljLiBUaGUg
b3JpZ2luYWwgbG9naWMgb25seSBtYWtlcyBidWZmZXJlZCB3cml0ZSBnZXQgLUVPUE5PVFNVUFAg
d2hlbiBSV0ZfTk9XQUlUIGlzIHNldC4NCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQ0Kc3RhdGljIGludCBmaWxlX21vZGlmaWVkX2ZsYWdzKHN0cnVjdCBmaWxl
ICpmaWxlLCBpbnQgZmxhZ3MpIHsgLi4uDQogICAgICAgICBpZiAoZmxhZ3MgJiBJT0NCX05PV0FJ
VCkNCiAgICAgICAgICAgICAgICAgcmV0dXJuIC1FQUdBSU47DQouLi4NCn0NCmludCBraW9jYl9t
b2RpZmllZChzdHJ1Y3Qga2lvY2IgKmlvY2IpDQp7DQogICAgICAgICByZXR1cm4gZmlsZV9tb2Rp
ZmllZF9mbGFncyhpb2NiLT5raV9maWxwLCBpb2NiLT5raV9mbGFncyk7IH0NCi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KUFM6IGtpb2NiX21vZGlmaWVkKCkg
aXMgdXNlZCBieSB0aGUgY29tbW9uIHhmc19maWxlX3dyaXRlX2NoZWNrcygpIHdoaWNoIGlzIGNh
bGxlZCBieSBhbGwgdHlwZXMgb2Ygd3JpdGUoaS5lLiBidWZmZXJlZC9kaXJlY3QvZGF4IHdyaXRl
KS4NCg0KPiANCj4gU28gdGhlIHRlc3QgaXRzZWxmIHByb2JhYmx5IG5lZWRzIGZpeGluZy4NCg0K
SW4gbXkgb3BpbmlvbiwgYm90aCBrZXJuZWwgYW5kIHRoZSB0ZXN0IHByb2JhYmx5IG5lZWQgdG8g
YmUgZml4ZWQuDQoNClsxXSAxYWE5MWQ5Yzk5MzMgKCJ4ZnM6IEFkZCBhc3luYyBidWZmZXJlZCB3
cml0ZSBzdXBwb3J0IikNCg0KQmVzdCBSZWdhcmRzLA0KWGlhbyBZYW5nDQo=
