Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2EAC7618E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 00:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjDUAY5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 20:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjDUAY4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 20:24:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866B83A8D
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 17:24:53 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KNE9Cw028846;
        Fri, 21 Apr 2023 00:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=wOjkDDITRGI4MMmWs6JgZIH3Ihq8v77+aioxIc5Nrhg=;
 b=Xs31D0IBv5oqJAUo4A39GNkpbZNeiEGclxsCn/FB/Xk6GMW7ZTRw+/vvNDp0DSD9eVs1
 Ax6hmF7ip3FTv0Y/vUVKsgcnJMhCyw9OkIc5TerMTynvNBn3wxHnwknIIRoI2XgGb5R+
 ag7qZC3GVh7IZkislZQJ8qu3n/eQJvZlZQe7hN2LRlKZeueEHv1HbKZZf0qq5qd+p8ND
 Eb5EXkNwa20eO5DCutBlt48YmaWBjEllxPF9pJsPxkFSd8EQ+UxdyjBLUh492E+QX53f
 +Nh+3WXF0FGncHbXpx0SCACR0uGD9wRvp0tabDSKFIY3YXX2/9mLHltOn/d57tvIreFZ 5A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pykhu477e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 00:24:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33KLukHg015650;
        Fri, 21 Apr 2023 00:24:51 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcf0g54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 00:24:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5HeSCN8rQ1Cshin1/wc5kym2bboWxpF0zZRgHUd+C2lhEzX9kF/cFmcJpQrXHDHCOt6fbIRPpK14+Hk/oBs1sjkiQak2aR5LohdNUhnxBmAy4RvbZd4Wcr9ECA837UQdgKeIZ7YMlNH09TSXOlKO2fVQnod6Fq3N8DpJFOetaZw8rw3fMRS9ip+IS/XzuYyL1b959su8z9Xt6KDpsT+sWF+A4YgC/jUg8zJpu5RDRgdB52MmJCBwmPX0H29EM9U9jxEvGlOi4VZR2e8mTxGusdqyOimnC4f2tyhUk59JRg3Za4Koa23WJMTFqyWsogCch6YUMwglJlhiH/hOjQTZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOjkDDITRGI4MMmWs6JgZIH3Ihq8v77+aioxIc5Nrhg=;
 b=hbDPk3a89Ifhl6OdtGwJE/SYhv6vxm5vLvfokN2bsB5wm8oKH1gZTusBbtRgD4sZoHBCtf1+dkyeg0ETowl/DSQDcbZuwZqGJCBuW7VUu/vI+vrili1U8VByUzLwE1mBiTbTpbTU2NUi6OT61aSWnMacZILsy+3/cY518JQNU+Z+omXBWRFNkYt3cq4GukK6w4P4aFI4t2PiX9u7wRcTWj7L1Rv8ox8I5hRxi0FwoZBX6r7eMS+l3IHEpZO7BaOKMWbRkJ/+bhwVI6285G/hZwraLu3d3qvosCjiH63On+cWVWvAvIo5XPklDycnT85uJ3/cyqPiMu0XRgHQ7tvvWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOjkDDITRGI4MMmWs6JgZIH3Ihq8v77+aioxIc5Nrhg=;
 b=ViO4H8DhexDimm5OI9/Gnb+ai25IiQzfKbPj4Y5DhX1WgWaKhkA754XjcvFFXI5KyKROrqeH/P5+9sJaD/cAYzsNhJnY0GpdOLYJOFjQvccuqTNkDJ6xE+tT3w7DqZz96N9zJ9bnja3rwDpw8S8EgG3DzxEi9YCGfRqyLEPuBrU=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by SA2PR10MB4668.namprd10.prod.outlook.com (2603:10b6:806:117::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 00:24:49 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b%6]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 00:24:49 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: IO time one extent per EFI
Thread-Topic: [PATCH 1/2] xfs: IO time one extent per EFI
Thread-Index: AQHZbySmyU5pA5JJVkmM3pjz5JBv5q8zVrCAgAEmyYCAAGIVAIAAEXkA
Date:   Fri, 21 Apr 2023 00:24:49 +0000
Message-ID: <451AEBDF-7BBC-4C6E-BB0F-AFE18C51607C@oracle.com>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
 <20230414225836.8952-2-wen.gang.wang@oracle.com>
 <20230419235559.GW3223426@dread.disaster.area>
 <71E9310C-06A6-41B9-AFE6-C8EE37CF5058@oracle.com>
 <20230420232206.GZ3223426@dread.disaster.area>
In-Reply-To: <20230420232206.GZ3223426@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|SA2PR10MB4668:EE_
x-ms-office365-filtering-correlation-id: 7c789d2b-a73d-4028-6fd4-08db41fed147
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uPQjcpEd7ZlBRI3XOb8PKb3OGaSM/XogdOoCJRuBG0L7sr+IgN1qLaVBguZvsZA4fhX3Hy7vGpW4T2colTT3oU6eVrT7Wg9NHO28f708g4rm08QCmKj/0pwwrgxQwmIHe62YsIG+u09YhYtu0Zw+MUfVsks1/ZhOIMtX8W2G8cMckKBPJQB0P6jMwMaFE9T/V6tz7d2GXJIUtI27+UDDVo8Bz0v3Epqz7W2zA57mu6BdFwZqvaD9nVRwzWp3oWH0Y/alZ3QETnQK0i1L48ULO46duymMC8qXFegXUf3a5dAdVg/KfwPjCG75fmeDd3ebs9pVC4Q+y44GRmjOWuNkWB+S4BvfwYSnC8h/MgPVW/CDfEzqkPC4UuCG1geuKy5gKd/cxtTOVJKvfgKaFX741yPzXAHuwfChaH5hXDrAIp68O3+2hR50e3MA86ftWzTzyG/mV6JDUxzOb1osUCXZ8sy94K3uKUvzNqAiKB5LzT0VjYMWXzU3d/SqqvZkx/YkCiwMcmL5YiLZzSAe6feb5uiegb8Kfcf+3SJHwBMQovhJolgJHiHjvucEHx90oAjtFCXnY2x/FAtJUE6HF3SM8CSv4VktnI1d5Yw3B7tyhfpEK8cUcBXYOkVI2Xnxz7P1Kca/tVijA+1PCj0nVVWN3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199021)(5660300002)(41300700001)(8936002)(186003)(38100700002)(53546011)(122000001)(2616005)(6506007)(6512007)(33656002)(83380400001)(4326008)(86362001)(6916009)(38070700005)(316002)(64756008)(71200400001)(6486002)(8676002)(66476007)(66446008)(478600001)(36756003)(91956017)(66556008)(76116006)(66946007)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mkx3NEN0U3puQXNFM0hYNXJCOWN1NXhJZm5KZW5tS0RqTllOK0N0MWxZczRu?=
 =?utf-8?B?eEpUdE91KzhtUUlSMDl5b2l6UHNjSmFsOFAvVlAxTTdKNG4yRnJNZmtqZ0cr?=
 =?utf-8?B?ajFyUnZLNTRYNm9zTy9mQ3BHRmk5b2trSHdiMC9zYi9uSlJSVVg2WWhPaDVr?=
 =?utf-8?B?eHlnTHNvUU56NHQxMmMzeGZGdlYvWXV4TFlDUEFjUG95anhvMzEvK0s4dkRk?=
 =?utf-8?B?bk1QazBqNzRrdFJUaFhuM1dpM2wraExab0F2YnQyV2RCN3lxQndzbEtHWEJG?=
 =?utf-8?B?YzFwbEs2V2E2ODNySjV2SE05T01yT1dldU5ZelpWQzhUajdVekpUUG9DeVFv?=
 =?utf-8?B?ZmxnYTFadjgxaHpobVJxbWFFZkpINGlkdEpXZjc0V2RVWGc3M29NcklOeVVV?=
 =?utf-8?B?ZHNmd3kvYU9uV3RXUndKbW55ZnBrZXJvaTBpaVNPQ3FSRSt0c2pibGdWRXdk?=
 =?utf-8?B?Z2M3b2k2SkEwTVltVzkzWkh2SzZyTktJTExrVzBWTE82NEw1b0ZDWCtibGxS?=
 =?utf-8?B?eFd4Ty9KWUE2QlpMcjRIaHhOTm9LZVI4dVhRNmdqQ3hoNWRFNytBdVBtQUhW?=
 =?utf-8?B?RUROcUJPWEtJNlE5VU9LYzl1SVNYMk4vczNmMnhMUU9OMjlDbTlOU3ZBUnFC?=
 =?utf-8?B?SkY0RlB4NTVJbFdWZlJpM282TThQcmZ2QlBubFpLblk3dVhSdis0bzZuV1dI?=
 =?utf-8?B?WVQwelVNdG55OUc1UVZDQ244d21DaUViWThZTm96dTBHRE9aVVNBbzFQNWZP?=
 =?utf-8?B?Y3FialdscTZUZE9rbU96N2MwSUNLUGJQckZDR1l6YmZwMTlFV2VTbUJQSGJ4?=
 =?utf-8?B?empKSU9DdFdPRFBHdXVSU2M1MVNVZ21KdjE0cTNieEhRMVo5TFB5R0VJRjZJ?=
 =?utf-8?B?N2tJRnFkRjRmazZZZjBzZEhNalZhLzJIK2xFNGtSc2lzQ2JKSlk1aUs0Wm9O?=
 =?utf-8?B?WEc5bkZrODB5S1Z0S0d5eFMvdjBXZXZZRGRSdnMwK1RnSGFjUE9XSnhzSGJw?=
 =?utf-8?B?MitkQ1paczU1V25yMDVVUCt0QkJMYnNwcStvV2ZmTDN3Nk1BKzgwVmg0NW1N?=
 =?utf-8?B?bUZ0MTZYNytuQlFsUFNyS1B1eW1GU09IUS92TkhKakhUeEpJVE1TSHBXcXpk?=
 =?utf-8?B?Ly9iYmN3ZGp3MExjRFUwQUJQcDBJM29MYWZPQWlZa25qWFdlTmNQdHpMZi9o?=
 =?utf-8?B?Nm41SW9VazBud2dLYTVMNGVvb2k2WWVGR1JUMHdNcjgvRnZjdi8rVm5rZ1Jx?=
 =?utf-8?B?VlIyNHVUc0ZYeGFTdTFnZTJCWGRBcE5wRlUvZUFNOXhXdmZSc3hxTDVRRHlm?=
 =?utf-8?B?QUE0UUFxU0ljNm9pL3piYlBsdDNwQ25VSTJBK0sweWpRYjhOckZaaVdjSHVF?=
 =?utf-8?B?SXZJZFNnSVRrV2Z5VWh5ekYxa0hxOGZOU3lZQ3FaT280clg3ZWYvUUtuWE9n?=
 =?utf-8?B?U2FpMXRVN3l1aVd6dlBEQzNZNnJQaWQ0SFcwYzhkWVBJYlN4eUlrMVYxWlFG?=
 =?utf-8?B?eVpnM0NhZE1IbjBvRDdTSXo5b0pPVXdEOXVXdWhGTCtkdzcxOUFLWlRSTE5F?=
 =?utf-8?B?YWI4V2ZoZXhQbzVHT2dwVXRiMlBxZW96THZtaTNiaTc1ODhmQk5mOW5leEpK?=
 =?utf-8?B?Umx4WkVjUEFweEJHL05IdWdCRHVlczBkaEVLU2VtUVVsNEUvSjM0c2c3Y1dt?=
 =?utf-8?B?UlFPWXZEMkJsQTd2cFBmaExGTnpRZ0o4a0tDZCt3Zy9SRGZqTDNsbmd5clph?=
 =?utf-8?B?ajMxM3ZqOThMcGVLVjZQVzB4b1RuYy9Qcis2bmh1d0w5L2NBa1pxQWU0Unlk?=
 =?utf-8?B?d1VDT0I0YjhDSVZ5ZjZwRHgwS2lERkVkaVptald4Qkh4YzhkbC9FZmtxa2c2?=
 =?utf-8?B?N0lVNkJvQUpINzFqNVhuaVFuak5QKy8wZHZkMWhVaW80bWZpL2FuWEZ4V3FN?=
 =?utf-8?B?dThuQ1pwTElMTE93dm9rTTlWRmp3R3pzdDIrUGNQUldPM2VhcGV2ZW9YaDUv?=
 =?utf-8?B?bkNWdFJoZmN2aHVXNW9STXVFMDYzSGhBcVYxT28xT252YlpQVmZneUIvcDNN?=
 =?utf-8?B?K3B6U3BJbXlCZ2xBWTJPeWlMMWpkeXFaVlJKTWJnTHIwVTdEZGt1NStScE1T?=
 =?utf-8?B?c2pUWnRiVCswWlBqUy9ERzV1MUdLcHVVRHdzL2o2aEU4ZmJKNW83WGdFNWt2?=
 =?utf-8?Q?25eCuoJNjLLAiCXJiU9k84eCg2oy1se7cHHYyWHxKYXm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1FF9DB676569A418CD8549A87C56537@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gf+GZwpudPu1MYlie+EP48XvBZ6lFJWdOTDLoVO9aHGQOy4VKNOFBbkBXFPlMjkZY1Z1J7fprj95d07Ibk4IfPLjqNRI1XvgwHj89s+vq2zmc4XV3n0fVp3g2GHgWd5FP+trau4hlyYzSsCjNrMTkvGvTg5570Tsj8D0HGMl7e3wYLjBs5M8Qcn35MBtXCcS1ym6KvR7ub9nQI1dxJ0Ue+bCms/fCzurNbqd7H6yKmX2BkmUHayBoiYLes4d96D+3NAEdde6KkFDgd2yAWn+X7XPEA6Gf7QcUqArQkdQwhLugUhfBhrWfyyoEFjv/lbsKLQeVh1hbpNnibr/iuVIuLP01KKCxedO/VDvddJj/dYmPHG/RwLV9ZNHg17vCWRFcgIgv/ZqunXvQ5uqYQzys3Ba+p/SSbtBIQbnrV2XgsPpG9bvc7Tqr7RqGR00ThQAPvEuSfWot3cqxvT+rkGD3Kx3nj9iXreMxCEj3Clk/1BTAhUZg8fHQOHSq7FZtIa4GmjtAs9X+I3kYBcGDxwU1HFhpeqWpJn1ABNY6wl9QTdpyjLk9j9eYNfHYoHbNNjlx68fS6oMIME1JMUrhfFLDLyzQs4sfsC6YSjeRQXOsfW2WLnK/90vfViaVWugUWDFvABJmVfjQoR0JdOKuwBHQyWvV41tOOAV1mHO40ko1N51enodZWGSPlpTk9KfDEUafS8mC02cZs5fP6salkKbUn3FQ6K8PCZ48FyMGen4iNPcI18NXS3eTVH0iYjsnqbuagNoBJI9Rm5U/s/57raxP3px4ttTgOtEd/qlS12zBDY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c789d2b-a73d-4028-6fd4-08db41fed147
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 00:24:49.1620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S/HTmxVHpVTPc0K5sxA9plkgR20/X1bEpDozyRd/kDb290sAKI6xY8AswEm5DuRU298toULkcUhhVez0l4aiv8gGEsnFbMDzjHJd9Y0p2SM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4668
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_16,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210001
X-Proofpoint-GUID: KUWVb_xhKBH47dvJ_nDppU2lXbQvftRg
X-Proofpoint-ORIG-GUID: KUWVb_xhKBH47dvJ_nDppU2lXbQvftRg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gQXByIDIwLCAyMDIzLCBhdCA0OjIyIFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBBcHIgMjAsIDIwMjMgYXQgMDU6MzE6
MTRQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBBcHIgMTks
IDIwMjMsIGF0IDQ6NTUgUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3Jv
dGU6DQo+Pj4gDQo+Pj4gT24gRnJpLCBBcHIgMTQsIDIwMjMgYXQgMDM6NTg6MzVQTSAtMDcwMCwg
V2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+PiBBdCBJTyB0aW1lLCBtYWtlIHN1cmUgYW4gRUZJIGNv
bnRhaW5zIG9ubHkgb25lIGV4dGVudC4gVHJhbnNhY3Rpb24gcm9sbGluZyBpbg0KPj4+PiB4ZnNf
ZGVmZXJfZmluaXNoKCkgd291bGQgY29tbWl0IHRoZSBidXN5IGJsb2NrcyBmb3IgcHJldmlvdXMg
RUZJcy4gQnkgdGhhdCB3ZQ0KPj4+PiBhdm9pZCBob2xkaW5nIGJ1c3kgZXh0ZW50cyAoZm9yIHBy
ZXZpb3VzbHkgZXh0ZW50cyBpbiB0aGUgc2FtZSBFRkkpIGluIGN1cnJlbnQNCj4+Pj4gdHJhbnNh
Y3Rpb24gd2hlbiBhbGxvY2F0aW5nIGJsb2NrcyBmb3IgQUdGTCB3aGVyZSB3ZSBjb3VsZCBiZSBv
dGhlcndpc2Ugc3R1Y2sNCj4+Pj4gd2FpdGluZyB0aGUgYnVzeSBleHRlbnRzIGhlbGQgYnkgY3Vy
cmVudCB0cmFuc2FjdGlvbiB0byBiZSBmbHVzaGVkICh0aHVzIGENCj4+Pj4gZGVhZGxvY2spLg0K
Pj4+PiANCj4+Pj4gVGhlIGxvZyBjaGFuZ2VzDQo+Pj4+IDEpIGJlZm9yZSBjaGFuZ2U6DQo+Pj4+
IA0KPj4+PiAgIDM1OCByYmJuIDEzIHJlY19sc246IDEsMTIgT3BlciA1OiB0aWQ6IGVlMzI3ZmQy
ICBsZW46IDQ4IGZsYWdzOiBOb25lDQo+Pj4+ICAgMzU5IEVGSSAgbmV4dGVudHM6MiBpZDpmZmZm
OWZlZjcwOGJhOTQwDQo+Pj4+ICAgMzYwIEVGSSBpZD1mZmZmOWZlZjcwOGJhOTQwICgweDIxLCA3
KQ0KPj4+PiAgIDM2MSBFRkkgaWQ9ZmZmZjlmZWY3MDhiYTk0MCAoMHgxOCwgOCkNCj4+Pj4gICAz
NjIgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4+Pj4gICAzNjMgcmJibiAxMyByZWNfbHNuOiAxLDEyIE9wZXIgNjogdGlk
OiBlZTMyN2ZkMiAgbGVuOiA0OCBmbGFnczogTm9uZQ0KPj4+PiAgIDM2NCBFRkQgIG5leHRlbnRz
OjIgaWQ6ZmZmZjlmZWY3MDhiYTk0MA0KPj4+PiAgIDM2NSBFRkQgaWQ9ZmZmZjlmZWY3MDhiYTk0
MCAoMHgyMSwgNykNCj4+Pj4gICAzNjYgRUZEIGlkPWZmZmY5ZmVmNzA4YmE5NDAgKDB4MTgsIDgp
DQo+Pj4+IA0KPj4+PiAyKSBhZnRlciBjaGFuZ2U6DQo+Pj4+IA0KPj4+PiAgIDgzMCByYmJuIDMx
IHJlY19sc246IDEsMzAgT3BlciA1OiB0aWQ6IDMxOWYwMTVmICBsZW46IDMyIGZsYWdzOiBOb25l
DQo+Pj4+ICAgODMxIEVGSSAgbmV4dGVudHM6MSBpZDpmZmZmOWZlZjcwOGI5YjgwDQo+Pj4+ICAg
ODMyIEVGSSBpZD1mZmZmOWZlZjcwOGI5YjgwICgweDIxLCA3KQ0KPj4+PiAgIDgzMyAtLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQ0KPj4+PiAgIDgzNCByYmJuIDMxIHJlY19sc246IDEsMzAgT3BlciA2OiB0aWQ6IDMxOWYwMTVm
ICBsZW46IDMyIGZsYWdzOiBOb25lDQo+Pj4+ICAgODM1IEVGSSAgbmV4dGVudHM6MSBpZDpmZmZm
OWZlZjcwOGI5ZDM4DQo+Pj4+ICAgODM2IEVGSSBpZD1mZmZmOWZlZjcwOGI5ZDM4ICgweDE4LCA4
KQ0KPj4+PiAgIDgzNyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4+PiAgIDgzOCByYmJuIDMxIHJlY19sc246IDEsMzAg
T3BlciA3OiB0aWQ6IDMxOWYwMTVmICBsZW46IDMyIGZsYWdzOiBOb25lDQo+Pj4+ICAgODM5IEVG
RCAgbmV4dGVudHM6MSBpZDpmZmZmOWZlZjcwOGI5YjgwDQo+Pj4+ICAgODQwIEVGRCBpZD1mZmZm
OWZlZjcwOGI5YjgwICgweDIxLCA3KQ0KPj4+PiAgIDg0MSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4+PiAgIDg0MiBy
YmJuIDMxIHJlY19sc246IDEsMzAgT3BlciA4OiB0aWQ6IDMxOWYwMTVmICBsZW46IDMyIGZsYWdz
OiBOb25lDQo+Pj4+ICAgODQzIEVGRCAgbmV4dGVudHM6MSBpZDpmZmZmOWZlZjcwOGI5ZDM4DQo+
Pj4+ICAgODQ0IEVGRCBpZD1mZmZmOWZlZjcwOGI5ZDM4ICgweDE4LCA4KQ0KPj4+PiANCj4+Pj4g
U2lnbmVkLW9mZi1ieTogV2VuZ2FuZyBXYW5nIDx3ZW4uZ2FuZy53YW5nQG9yYWNsZS5jb20+DQo+
Pj4+IC0tLQ0KPj4+PiBmcy94ZnMveGZzX2V4dGZyZWVfaXRlbS5oIHwgOSArKysrKysrKy0NCj4+
Pj4gMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4+PiAN
Cj4+Pj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfZXh0ZnJlZV9pdGVtLmggYi9mcy94ZnMveGZz
X2V4dGZyZWVfaXRlbS5oDQo+Pj4+IGluZGV4IGRhNmE1YWZhNjA3Yy4uYWU4NGQ3N2VhZjMwIDEw
MDY0NA0KPj4+PiAtLS0gYS9mcy94ZnMveGZzX2V4dGZyZWVfaXRlbS5oDQo+Pj4+ICsrKyBiL2Zz
L3hmcy94ZnNfZXh0ZnJlZV9pdGVtLmgNCj4+Pj4gQEAgLTEzLDggKzEzLDE1IEBAIHN0cnVjdCBr
bWVtX2NhY2hlOw0KPj4+PiANCj4+Pj4gLyoNCj4+Pj4gKiBNYXggbnVtYmVyIG9mIGV4dGVudHMg
aW4gZmFzdCBhbGxvY2F0aW9uIHBhdGguDQo+Pj4+ICsgKg0KPj4+PiArICogQXQgSU8gdGltZSwg
bWFrZSBzdXJlIGFuIEVGSSBjb250YWlucyBvbmx5IG9uZSBleHRlbnQuIFRyYW5zYWN0aW9uIHJv
bGxpbmcNCj4+Pj4gKyAqIGluIHhmc19kZWZlcl9maW5pc2goKSB3b3VsZCBjb21taXQgdGhlIGJ1
c3kgYmxvY2tzIGZvciBwcmV2aW91cyBFRklzLiBCeQ0KPj4+PiArICogdGhhdCB3ZSBhdm9pZCBo
b2xkaW5nIGJ1c3kgZXh0ZW50cyAoZm9yIHByZXZpb3VzbHkgZXh0ZW50cyBpbiB0aGUgc2FtZSBF
RkkpDQo+Pj4+ICsgKiBpbiBjdXJyZW50IHRyYW5zYWN0aW9uIHdoZW4gYWxsb2NhdGluZyBibG9j
a3MgZm9yIEFHRkwgd2hlcmUgd2UgY291bGQgYmUNCj4+Pj4gKyAqIG90aGVyd2lzZSBzdHVjayB3
YWl0aW5nIHRoZSBidXN5IGV4dGVudHMgaGVsZCBieSBjdXJyZW50IHRyYW5zYWN0aW9uIHRvIGJl
DQo+Pj4+ICsgKiBmbHVzaGVkICh0aHVzIGEgZGVhZGxvY2spLg0KPj4+PiAqLw0KPj4+PiAtI2Rl
ZmluZSBYRlNfRUZJX01BWF9GQVNUX0VYVEVOVFMgMTYNCj4+Pj4gKyNkZWZpbmUgWEZTX0VGSV9N
QVhfRkFTVF9FWFRFTlRTIDENCj4+PiANCj4+PiBJSVJDLCB0aGlzIGRvZXNuJ3QgaGF2ZSBhbnl0
aGluZyB0byBkbyB3aXRoIHRoZSBudW1iZXIgb2YgZXh0ZW50cyBhbg0KPj4+IEVGSSBjYW4gaG9s
ZC4gQWxsIGl0IGRvZXMgaXMgY29udHJvbCBob3cgdGhlIG1lbW9yeSBmb3IgdGhlIEVGSQ0KPj4+
IGFsbG9jYXRlZC4NCj4+IA0KPj4gWWVzLCBpdCBlbnN1cmVzIHRoYXQgb25lIEVGSSBjb250YWlu
cyBhdCBtb3N0IG9uZSBleHRlbnQuIEFuZCBiZWNhdXNlIGVhY2gNCj4+IGRlZmVycmVkIGludGVu
dCBnb2VzIHdpdGggb25lIHRyYW5zYWN0aW9uIHJvbGwsIGl0IHdvdWxkIHNvbHZlIHRoZSBBR0ZM
IGFsbG9jYXRpb24NCj4+IGRlYWRsb2NrIChiZWNhdXNlIG5vIGJ1c3kgZXh0ZW50cyBoZWxkIGJ5
IHRoZSBwcm9jZXNzIHdoZW4gaXQgaXMgZG9pbmcgdGhlDQo+PiBBR0ZMIGFsbG9jYXRpb24pLg0K
Pj4gDQo+Pj4gT2gsIGF0IHNvbWUgcG9pbnQgaXQgZ290IG92ZXJsb2FkZWQgY29kZSB0byBkZWZp
bmUgdGhlIG1heCBpdGVtcyBpbg0KPj4+IGEgZGVmZXIgb3BzIHdvcmsgaXRlbS4gT2ssIEkgbm93
IHNlZSB3aHkgeW91IGNoYW5nZWQgdGhpcywgYnV0IEkNCj4+PiBkb24ndCB0aGluayB0aGlzIGlz
IHJpZ2h0IHdheSB0byBzb2x2ZSB0aGUgcHJvYmxlbS4gV2UgY2FuIGhhbmRsZQ0KPj4+IHByb2Nl
c3NpbmcgbXVsdGlwbGUgZXh0ZW50cyBwZXIgRUZJIGp1c3QgZmluZSwgd2UganVzdCBuZWVkIHRv
DQo+Pj4gdXBkYXRlIHRoZSBFRkQgYW5kIHJvbGwgdGhlIHRyYW5zYWN0aW9uIG9uIGVhY2ggZXh0
ZW50IHdlIHByb2Nlc3MsDQo+Pj4geWVzPw0KPj4+IA0KPj4gDQo+PiBJIGFtIG5vdCBxdWl0ZSBz
dXJlIHdoYXQgZG9lcyDigJx1cGRhdGUgdGhlIEVGROKAnSBtZWFuLg0KPiANCj4gSGlzdG9yaWNh
bCB0ZXJtaW5vbG9neSwgc2VlIGJlbG93Lg0KPiANCj4+IE15IG9yaWdpbmFsIGNvbmNlcm4gaXMg
dGhhdCAod2l0aG91dCB5b3VyIHVwZGF0ZWQgRUZEKSwgdGhlIGV4dGVudHMgaW4gb3JpZ2luYWwg
RUZJIGNhbiBiZSBwYXJ0aWFsbHkgZG9uZSBiZWZvcmUgYSBjcnVzaC4gQW5kIGR1cmluZyB0aGUg
cmVjb3ZlcnksIHRoZSBhbHJlYWR5IGRvbmUgZXh0ZW50cyB3b3VsZCBhbHNvIGJlIHJlcGxheWVk
IGFuZCBoaXQgZXJyb3IgKGJlY2F1c2UgdGhlIGluLXBsYWNlIG1ldGFkYXRhIGNvdWxkIGJlIGZs
dXNoZWQgc2luY2UgdGhlIHRyYW5zYWN0aW9uIGlzIHJvbGxlZC4pLg0KPj4gDQo+PiBOb3cgY29u
c2lkZXIgeW91ciDigJx1cGRhdGUgdGhlIEVGROKAnSwgeW91IG1lYW50IHRoZSBmb2xsb3dpbmc/
DQo+PiANCj4+IEVGSTogIElEOiAgVEhJU0lTSUQxICAgZXh0ZW50MSBleHRlbnQyDQo+PiBmcmVl
IGV4dGVudCBleHRlbnQxDQo+PiBFRkQ6IElEOiBUSElTSVNJRDEgIGV4dGVudDENCj4+IGZyZWUg
ZXh0ZW50IGV4dGVudDINCj4+IGFub3RoZXIgRUZEOiBJRDogVEhJU0lTSUQxIChzYW1lIElEIGFz
IGFib3ZlKSAgZXh0ZW50Mg0KPiANCj4gWWVzLCB0aGF0J3MgcHJldHR5IG11Y2ggaG93IG11bHRp
LWV4dGVudCBFRklzIHVzZWQgdG8gd29yaywgZXhjZXB0DQo+IHRoZSBzZWNvbmQgYW5kIHN1YnNl
cXVlbnQgRUZEcyByZWNvcmRlZCBhbGwgdGhlIGV4dGVudHMgdGhhdCBoYWQNCj4gYmVlbiBmcmVl
ZC4gIFRoYXQgd2F5IHJlY292ZXJ5IGNvdWxkIHNpbXBseSBmaW5kIHRoZSBFRkQgd2l0aCB0aGUN
Cj4gaGlnaGVzdCBMU04gaW4gdGhlIGxvZyB0byBkZXRlcm1pbmUgd2hhdCBwYXJ0IG9mIHRoZSBF
RkkgaGFkIG5vdA0KPiBiZWVuIHJlcGxheWVkLg0KDQpHb29kIHRvIGtub3cgaXQuDQoNCj4gDQo+
IFdlIGRvbid0IGRvIHRoYXQgYW55bW9yZSBmb3IgcGFydGlhbGx5IHByb2Nlc3NlZCBtdWx0aS1l
eHRlbnQNCj4gaW50ZW50cyBhbnltb3JlLiBJbnN0ZWFkLCB3ZSB1c2UgZGVmZXJyZWQgb3BzIHRv
IGNoYWluIHVwZGF0ZXMuIGkuZS4NCj4gd2UgbG9nIGEgY29tcGxldGUgaW50ZW50IGRvbmUgaXRl
bXMgYWxvbmdzaWRlIGEgbmV3IGludGVudA0KPiBjb250YWluaW5nIHRoZSByZW1haW5pbmcgd29y
ayB0byBiZSBkb25lIGluIHRoZSBzYW1lIHRyYW5zYWN0aW9uLg0KPiBUaGlzIGNhbmNlbHMgdGhl
IG9yaWdpbmFsIGludGVudCBhbmQgYXRvbWljYWxseSByZXBsYWNlcyBpdCB3aXRoIGENCj4gbmV3
IGludGVudCBjb250YWluaW5nIHRoZSByZW1haW5pbmcgd29yayB0byBiZSBkb25lLg0KPiANCj4g
U28gd2hlbiBJIHNheSAidXBkYXRlIHRoZSBFRkQiIEknbSB1c2luZyBoaXN0b3JpYyB0ZXJtaW5v
bG9neSBmb3INCj4gcHJvY2Vzc2luZyBhbmQgcmVjb3ZlcmluZyBtdWx0aS1leHRlbnQgaW50ZW50
cy4gSW4gbW9kZXJuIHRlcm1zLA0KPiB3aGF0IEkgbWVhbiBpcyAidXBkYXRlIHRoZSBkZWZlcnJl
ZCB3b3JrIGludGVudCBjaGFpbiB0byByZWZsZWN0IHRoZQ0KPiB3b3JrIHJlbWFpbmluZyB0byBi
ZSBkb25lIi4NCg0KT0suIHNvIGxldOKAmXMgc2VlIHRoZSBkaWZmZXJlbmNlIGJldHdlZW4geW91
ciBpbXBsZW1lbnRhdGlvbiBmcm9tIG1pbmUuDQpTYXksIHRoZXJlIGFyZSB0aHJlZSBleHRlbnRz
IHRvIGZyZWUuDQoNCk15IHBhdGNoIHdvdWxkIHJlc3VsdCBpbjoNCg0KRUZJIDEgIHdpdGggZXh0
ZW50MQ0KZnJlZSBleHRlbnQxDQpFRkQgMSB3aXRoIGV4dGVudDENCnRyYW5zYWN0aW9uIHJvbGwN
CkVGSSAyIHdpdGggZXh0ZW50Mg0KZnJlZSBleHRlbnQyDQpFRkQgMiB3aXRoIGV4dGVudDINCnRy
YW5zYWN0aW9uIHJvbGwNCkVGSSAzIHdpdGggZXh0ZW50Mw0KZnJlZSBleHRlbnQzDQpFRkQzIHdp
dGggZXh0ZW50Mw0KdHJhbnNhY3Rpb24gY29tbWl0DQoNClRoZSBFRkkvRUZEIGxvZyBpdGVtIHBh
aXJzIHNob3VsZCBub3QgYmUgd3JpdHRlbiB0byBsb2cgYXMgdGhleSBhcHBlYXIgaW4gc2FtZSBj
aGVja3BvaW50Lg0KDQpZb3VyIGlkZWEgeWllbGRzIHRoaXM6DQoNCkVGSSAxIHdpdGggZXh0ZW50
MSBleHRlbnQyIGV4dGVudDMNCmZyZWUgZXh0ZW50MQ0KRUZJIDIgd2l0aCBleHRlbnQyIGV4dGVu
dDMNCkVGRCAxIHdpdGggZXh0ZW50MSBleHRlbnQyIGV4dGVudDMNCnRyYW5zYWN0aW9uIGNvbW1p
dA0KY3JlYXRlIHRyYW5zYWN0aW9uDQpmcmVlIGV4dGVudDINCkVGSSAzIHdpdGggZXh0ZW50Mw0K
RUZEIDIgd2l0aCBleHRlbnQgZXh0ZW50MiBleHRlbnQzDQp0cmFuc2FjdGlvbiBjb21taXQNCmNy
ZWF0ZSB0cmFuc2FjdGlvbg0KZnJlZSBleHRlbnQzDQpFRkQgMyB3aXRoIGV4dGVudDMNCnRyYW5z
YWN0aW9uIGNvbW1pdC4NCg0KDQpZb3VyIGltcGxlbWVudGF0aW9uIGFsc28gaW5jbHVkZXMgdGhy
ZWUgRUZJL0VGRCBwYWlycywgdGhhdOKAmXMgdGhlIHNhbWUgYXMgbWluZS4NClNvIGFjdHVhbGx5
IGl04oCZcyBzdGlsbCBvbmUgZXh0ZW50IHBlciBFRkkgcGVyIHRyYW5zYWN0aW9uLiBUaG91Z2gg
eW91IGFyZSBub3QgY2hhbmdpbmcNClhGU19FRklfTUFYX0ZBU1RfRVhURU5UUy4NCg0KQW5kIHlv
dXIgaW1wbGVtZW50YXRpb24gbWF5IHVzZSBtb3JlIGxvZyBzcGFjZSB0aGFuIG1pbmUgaW4gY2Fz
ZSB0aGUgRUZJDQooYW5kIEVGRCBwYWlyKSBjYW7igJl0IGJlIGNhbmNlbGxlZC4gIDpEDQoNClRo
ZSBvbmx5IGRpZmZlcmVuY2UgaWYgdGhhdCB5b3UgdXNlIHRyYW5zYWN0aW9uIGNvbW1pdCBhbmQg
SSBhbSB1c2luZyB0cmFuc2FjdGlvbiByb2xsDQp3aGljaCBpcyBub3Qgc2FmZSBhcyB5b3Ugc2Fp
ZC4gDQoNCklzIG15IHVuZGVyc3RhbmRpbmcgY29ycmVjdD8NCg0KT25lIHF1ZXN0aW9uIGlzIHRo
YXQgaWYgb25seSBvbmUgRUZJIGlzIHNhZmUgcGVyIHRyYW5zYWN0aW9uLCBob3cgd2UgZW5zdXJl
IHRoYXQgdGhlcmUNCmlzIG9ubHkgb25lIEVGSSBwZXIgdHJhbnNhY3Rpb24gaW4gY2FzZSB0aGVy
ZSBhcmUgbW9yZSB0aGFuIDE2DQooY3VycmVudCBYRlNfRUZJX01BWF9GQVNUX0VYVEVOVFMpIGV4
dGVudHMgdG8gZnJlZSBpbiBjdXJyZW50IGNvZGU/DQoNCg0KdGhhbmtzLA0Kd2VuZ2FuZw==
