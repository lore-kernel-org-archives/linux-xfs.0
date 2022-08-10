Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21EEC25B0C
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiHJDJd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiHJDJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:09:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5883F7E330
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:09:17 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0DwXu002289;
        Wed, 10 Aug 2022 03:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=5B9uA1t4rVxv3c7tN9RE2J4i/jrUs6YF24gmtvik/Ak=;
 b=rhk5ZFG1TCpblvjBIegzacD1KP6vHLrxBDqu/vULmRMvL4dphYXmfqO2iWPZxsuvp1wY
 eCz/+JVbQqx2DQoaWSQjwBhhdESlwrjEh5Ixe8l2PXLKhNtWXPbkt0BPU9jxexSDTSEH
 Obs/KpQiDHbkuBnHbseD8Gm2GjhxKBO4i9RwUuOCAZ0eSMLPjv48bfLcdx7j0SRoc3sT
 /B8iyyLXL95K1DkF56XGoI8BDRwg8VB0oYYWGtRnFlAsKPnvklagaMxNu4WQ1/WK5Oq7
 EBUjKXXm657G7PQUIvbIHE3zwW52AbphdVV2CWJ8Jf/bKOyoyQzUnAuwf+jwxSYBfoXV VA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqj0nre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A06GX3036503;
        Wed, 10 Aug 2022 03:09:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqfggfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wy9bTeFtBfBwVxKZVC+66BIPbemt4cCSWgr6xu8fXwrdQnl0aqeEsP6nYydSUpUuCzy2WouunHAlzrEXH6WwNokKl6HCk+w4Jy0pUcm1PHHVfJnMXZP1xrWC5wuYTmjtjxkG7Jf9jsAxTFBzSJpjyoEaCT7kYUa2he1rH8Ozkc6nm43fpO6OVi3H2OZ24FE3b6bbY/S+9UB6S34ryfH7PyWwFlMzzPwm8LkrJAiabAGjRDOca9rmnBRTJ2qrgCrvzs2xvTupXbS7ayKbuAcNdKNLwhCQo7dIgZCJfY+RoCt95R+US4XHZ8GE7JdPH2M2Pl8Bl6khXepjeEeLzSlH2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5B9uA1t4rVxv3c7tN9RE2J4i/jrUs6YF24gmtvik/Ak=;
 b=gz1aBchmJqu8cAithtLl0E6F+AzKfL7/5X3hjUCw1f2I/Ept05n/4P+IzIihUISneWj/S6DwjYcEjuGfViarp9BWUvBo2r6jSue1myvtLZ9hFHZnU41ceO4925VQRpzLnDFBfFTzHBDBlBBJGwPFThY4tWZUAm0Dh2zWUIZ5wq7mrLXFq60HMhpgvi2rtq+ebEvYBYkP9S0/E6G1f7Elc9U03A0+rBOLikUPh83x91xIWbm0fsV7KmS5UqVpQZCFYZOrd16g7LaouZYrcB4F9wgoQUq2dJloE6cNpHBmZ5dUUSRSEi0c+mRPO2OLDsCyGY67fEZcEOkNjV6kWui8Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5B9uA1t4rVxv3c7tN9RE2J4i/jrUs6YF24gmtvik/Ak=;
 b=eX1YJ+EC9YOluxv3K/l90h/j6bsftdAZn+I88es9RqWepEjAWyLBuHUoW7xTqY+ERDuR8mHtAbjZIKiV5yPYjOmXx7zvR8PACbXMEmCPJsYM6X6RCE3lrobnp0/5SgWyKghbmQqsYiGJihyaTlZAmg6Edvl0bLGra6QgfUWDE6E=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4545.namprd10.prod.outlook.com (2603:10b6:303:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 03:09:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:09:09 +0000
Message-ID: <b77b2629f92f6898bdf05becb97e97dc5ed99856.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 12/18] xfs: parent pointer attribute creation
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:09:07 -0700
In-Reply-To: <YvKjwtiHtLq0FkCc@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-13-allison.henderson@oracle.com>
         <YvKg3XBOmAmFli0o@magnolia> <YvKjwtiHtLq0FkCc@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80e463cc-8001-46a6-f64d-08da7a7db160
X-MS-TrafficTypeDiagnostic: CO1PR10MB4545:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 23GkFfugk0KoJBgQPpbA7QWi1P32A0+YDko4xI+fvACU4Hd9yEQ3egW27XdgcKsZQqfYyZ06xMj2zk23wrRhKzQDfnWtAmVW69g2PPgfHYZFDdnvtPiHNTEaY+uYP33LZt6kA0/ispQ2DaoBKwpVqHb/x4h4EfGsXmk1WR3uPgvvAwuiojGMbLymiFQK0UaJnLUVxCVYv2hods6qOr2Oj6YjFcr0EpHTmvmmESTa8OnDy5kcxTWe1Kb2zusvWP8oKWXA8ReVkCoyVp8PfkTGcLMAGWPbXfF/yJX34PuHnMZlxyx91vVGhWXiKOw4lPe9/kdOf+Kl9xPMghIHgY53xL6bfrL6p7avXNRv2txO6jrCPu/HUvy8v73iplQvgTGIEDHFtXUgZCRRNgYTlUTnsQmZxCl/Scygqn3+DzgqOqOG9EcVuUMMpC4dV04oEZZUwFCrSnp38xEHfs6dAi/BxVQClXbhAFDTm+7AVAQJMn/t65seUF4Du47q+fuXGG0ijcgA5cMpGNSIrsm+X/Fyvh8iPwKIxNfGB8KbbMwZPtGRCFFZB24l2D3tD1BwQWH4pzSgoiepikCthTtmXSZ+hb1VF5VTGymmlZUHY4NIVaQtwnE1MnSfXRssNoMqqmFpS7miCQanzcTWjcYkH4gQrygru04vxKRx9dS/oz1raD+DnJ3XSP70K1UeYJhY5AL8LxbQ6ZWwbVKZglA17Oj2W/jaZyv2LN5X7PW0kvsfBmXmsOv3S8gjN+rm65CD3M9Qmw1gPuKrgCbUtzU7XDp/BehkEQNGqteynhK/kGy8APQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(396003)(366004)(38350700002)(38100700002)(26005)(66946007)(8676002)(4326008)(6512007)(66476007)(66556008)(36756003)(6916009)(316002)(478600001)(2616005)(86362001)(6486002)(5660300002)(2906002)(8936002)(30864003)(186003)(41300700001)(6506007)(83380400001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2tSYlVXZ0VjTDYrNURNTnVDTVR5L0dxaklyMFRzbDhGNERFNVlxdS94eG02?=
 =?utf-8?B?U2lVY3QyUVQxWUVsUnZhMktTTXJ4b0xDazlHaSsrdU10ZDJVMTJBb3FQYUM5?=
 =?utf-8?B?ZUIwMVpBVnI4ZmJEZHlJLzFib3oxMnpNaGxMK2kzZCtEbFBwQmJ1R1ViWnpw?=
 =?utf-8?B?RDJmTU5GTmdjVFk5NjJ2dlFuYWl5NWpnVkFWWFpPV2c1ZXN0YWRPRmphRjdz?=
 =?utf-8?B?ckVCcHRqVHVDRFRReHI2Yk55WENjNGFyTEc5cW56RXVMMUJmZDNacnZ4TFVm?=
 =?utf-8?B?UVlEYlBiVGhiSytqWVZjVjRJV2w4YkJFazdIWjZvTHFQZUlEWGFIeXVHdENr?=
 =?utf-8?B?RVgxenhWb0dTRitvUjdHWk5pT1JZdGYrbzRiNWFTMFc1dHBLVkVIVzVXWURI?=
 =?utf-8?B?MG4zRVhHWnNwMjR2VzJ0ZVRXL3JWcTlZSXBMWkNCR1NmeGN2Tk9WajRPK1hs?=
 =?utf-8?B?VVJ6eG90VWNSTDExaStsRFM5UnVib0E2RTdjM1p6SUd6SmIyNzFvWTQwZXU4?=
 =?utf-8?B?S2puWmkxdmtaZXk5amF1MEpUeHRjN0M0ZlFvTFlYZTVUVzZuNGZ4NjhhbWNt?=
 =?utf-8?B?THVnNW1pT1lsZm93WVhvSDFuaVNLbE9EM0NNNmRsVnFEVmtFVVpRUG5OQm1K?=
 =?utf-8?B?WlJxREgrRVErN2JwKytZSE5zdzlRZjEyTXV1djZWOTE2WG5rTnVOMG16Q09x?=
 =?utf-8?B?bDh1L0oyWUJvWHQxSStoTVV2YXB5dzREQUg2T0Y0RHM5NGlEa0FrTWJnbDRS?=
 =?utf-8?B?dDZOOGRkbklnZjI0K2pRQlc4MG44YzZTbmZHVnE1Z2xGSG9SQ1B2NWR4RUly?=
 =?utf-8?B?cVBOOEFlbWlXRkZqNmtYQ1h6QUxBeXZUNzBjSlVUeDNHT1dxMmlyUXk1STRw?=
 =?utf-8?B?U1I3TUI3M0NGSkVIZWFoejErTDdRYXI3UnU0TnQ5M3NFdjhlb0RnWWNLamhh?=
 =?utf-8?B?eGZPUVdEd21WRzZNdFpZNXhOU1FuMlhEK2tueTVXVkszQkx6OXRsVzdhSVFI?=
 =?utf-8?B?WW9YQUFBRnlwbk9saDlZbDN3WVN1SGE3KzFVOWxyNVpVcU5ZbXVTVEFoTkxM?=
 =?utf-8?B?cTVoQ2Nob214aHVDaXU2dlR3UWFTc0VmYlVQMXN6aTJLaGFYbWlTVWtVdWE5?=
 =?utf-8?B?YUdMa1V1YU4zNkdINFhaVmV3RlNXOFVleERLR0U2VGZkaktaV2hNcStDcE1O?=
 =?utf-8?B?aWl0TkZMK2huRGxDd21QMG9vWHBOaDNtd1g4UVlzUCtnWGRENXUvNzN1dkdi?=
 =?utf-8?B?SlBTTkV6ZDVQTnM2bHQyMmwwNmJvamJJdHFKeWZmSHdVZEVXNTFxR0dPbnFT?=
 =?utf-8?B?dXE5V04rTHZDVjBUN3FNNWxKZTh1SjVIOGlseFhYZkJKeVpaTUJ4QjVKcytz?=
 =?utf-8?B?WlloVjJrbCtzYTRiV1BtSzg1UUVlMzlZdE1CcmVPNG9Zbm81K3R2TnhuQ01m?=
 =?utf-8?B?WWQ3YXJNUEhOSDZEQVp0NCtZVFkzc0p3M21aY2tVMWVkazU4eEh1cVM3alZw?=
 =?utf-8?B?Ris1dkhOcStJclE4TzZDdU5UMFJkV1JlaUFRdkpaWVpTemZpUGFqSTdvNjFv?=
 =?utf-8?B?QlNpWTJlT2gvSXMrcWdQMmxSZWlhNUxacnRGajMxc29KSy8zTUljbU1UbllW?=
 =?utf-8?B?QmdVbVlaUW5OcnUrMWdCdDR0YnRVYWRaMEpFYnNDby9FaktUS1MvZmVQRExD?=
 =?utf-8?B?cjNSZ3FpK3ViNEIxN2U2N0c0R2hvR3pBcitjSWM5L25sZWJ3K0pWWE1EcFc2?=
 =?utf-8?B?UUMvaUZWOXdCbEhWMTlXTFhhR3lTV3UrbWREUk82dG5rV3YveVFkV29zMHoy?=
 =?utf-8?B?UlprQThtQ2F1T2Z6THM0SlhJUndCY1hDZ2NERnF5MEg4U01qMzZ5ZzhIWmpq?=
 =?utf-8?B?UzRqek4yRG5NTEJrOHdMbnJYeXYwZ2htNGZGOFgwYkhKaDhyNE1jZUtVZkpM?=
 =?utf-8?B?aE10OU54NGNzczduOGUzMGd1Z1QyOTN6Vng5UEVOOWtjdjMrNnNNYlZLTWx0?=
 =?utf-8?B?Mk9zaVpQS3hRQjAzcllTdllUTHo2Vm14RVZDNmVKYjJwaUdrVytrdmNWd1kv?=
 =?utf-8?B?R3ZpaktHWlpNenpWdHZrQW9iTnBBWmh0ZXBQaG9yQzd6VTRIQjk1UnJSOVRl?=
 =?utf-8?B?NGFZMEU3VG8wQXMxenNqWDNQZFkvYWJmdkNwbmpra1ZQaVFDN1orY0ZDa3JE?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tBgaFHasMySuf/Ax+SlHa9WcUxd3mEfKLHrC+6fHg+Md7EugM23gImvqkpeaG9zBVX7NZO4g5JTzqUi9/IX5QHtPWzg29AcM75GmbqvBRjVJ2B4Pfp7eZG8FcZS9vOqgF3MjPQMPn9+7/rqI+zP1QtEGjFDiltRHZRudRr/UcOL9FIuUWnQNUknyMjHWQsfyCMJ8B2X7TKSXRX9g9+aDqstEokXomgFD8oOEFKEhRMMyJYdkc9mnlV+3Jq+Yk8Rr75z7heVJeWWQUhI1ihIxTYAsH7VyFq0FI+nGQxS8EE536iWP7zDFj7C6sZmkby1qyE1QN+Zianjt84BAsI8AX0LZU0/smqtN7Q44JpLxxG8uLjFp3Pbugpbs6NqEWYC+8aNsQ9EaQ01476XwX1xf12s0xShVURCbFB0OapX09nqyklK1jmm9us49YAJHA6yAW72YbUk/fkY7HYEWuv9Rv60Ka3zSqIKa/IaaFiwb6QDnpagpAos7Yj6Wt5rMBbx7tnrTOLKxXYT7pN+TSraA6QQSCb8giVnZkuzxFmOe7GqHx30NfApwoC1yWssJf2ifBtFwh3dJ30sUXrXpGtXi/JzMV6JdyUAtdi6xPIDOhSA4tz+4ibNyudYMdVNrqcexj2hAxuPeStp/3uhvQt/x+POvAAd9segO9YYfduiNaH3rpHiPxuXP0AzpEBEXeZwa9u12Uv1k4BI6mzMdV5ocfjdh+UilCmsUpVrDDp2eK/xoa6fN0ILbpvIqH/MbgZTUtpHzViQWNFnqvtMqHeOQgw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e463cc-8001-46a6-f64d-08da7a7db160
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:09:09.2862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymasnaec2lyPpnwy/LzGnaChNxUvXhsAGKH9LUT0AWu04J0Py2WEjEkt/Q/eGdexTsLF5kU8P8gRgJzQ1ycXJpEb3q/oUZr63caTuse4uAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208100008
X-Proofpoint-ORIG-GUID: b2huk4XjGU19dfpDZdZaSZiRP8ITYN64
X-Proofpoint-GUID: b2huk4XjGU19dfpDZdZaSZiRP8ITYN64
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 11:13 -0700, Darrick J. Wong wrote:
> On Tue, Aug 09, 2022 at 11:01:01AM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 04, 2022 at 12:40:07PM -0700, Allison Henderson wrote:
> > > Add parent pointer attribute during xfs_create, and subroutines
> > > to
> > > initialize attributes
> > > 
> > > [bfoster: rebase, use VFS inode generation]
> > > [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
> > 
> > Nit: uint32_t, not unint32_t.
> > 
> > >            fixed some null pointer bugs,
> > >            merged error handling patch,
> > >            remove unnecessary ENOSPC handling in
> > > xfs_attr_set_first_parent]
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/Makefile            |   1 +
> > >  fs/xfs/libxfs/xfs_attr.c   |   4 +-
> > >  fs/xfs/libxfs/xfs_attr.h   |   4 +-
> > >  fs/xfs/libxfs/xfs_parent.c | 134
> > > +++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_parent.h |  34 ++++++++++
> > >  fs/xfs/xfs_inode.c         |  37 ++++++++--
> > >  fs/xfs/xfs_xattr.c         |   2 +-
> > >  fs/xfs/xfs_xattr.h         |   1 +
> > >  8 files changed, 208 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > > index 1131dd01e4fe..caeea8d968ba 100644
> > > --- a/fs/xfs/Makefile
> > > +++ b/fs/xfs/Makefile
> > > @@ -40,6 +40,7 @@ xfs-y				+= $(addprefix
> > > libxfs/, \
> > >  				   xfs_inode_fork.o \
> > >  				   xfs_inode_buf.o \
> > >  				   xfs_log_rlimit.o \
> > > +				   xfs_parent.o \
> > >  				   xfs_ag_resv.o \
> > >  				   xfs_rmap.o \
> > >  				   xfs_rmap_btree.o \
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 2ef3262f21e8..0a458ea7051f 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -880,7 +880,7 @@ xfs_attr_lookup(
> > >  	return error;
> > >  }
> > >  
> > > -static int
> > > +int
> > >  xfs_attr_intent_init(
> > >  	struct xfs_da_args	*args,
> > >  	unsigned int		op_flags,	/* op flag (set or
> > > remove) */
> > > @@ -898,7 +898,7 @@ xfs_attr_intent_init(
> > >  }
> > >  
> > >  /* Sets an attribute for an inode as a deferred operation */
> > > -static int
> > > +int
> > >  xfs_attr_defer_add(
> > >  	struct xfs_da_args	*args)
> > >  {
> > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > index af92cc57e7d8..b47417b5172f 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > @@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
> > >  bool xfs_attr_is_leaf(struct xfs_inode *ip);
> > >  int xfs_attr_get_ilocked(struct xfs_da_args *args);
> > >  int xfs_attr_get(struct xfs_da_args *args);
> > > +int xfs_attr_defer_add(struct xfs_da_args *args);
> > >  int xfs_attr_set(struct xfs_da_args *args);
> > >  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
> > >  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> > > @@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp,
> > > const void *name, size_t length,
> > >  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> > >  void xfs_init_attr_trans(struct xfs_da_args *args, struct
> > > xfs_trans_res *tres,
> > >  			 unsigned int *total);
> > > -
> > > +int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int
> > > op_flags,
> > > +			 struct xfs_attr_intent  **attr);
> > >  /*
> > >   * Check to see if the attr should be upgraded from non-existent 
> > > or shortform to
> > >   * single-leaf-block attribute list.
> > > diff --git a/fs/xfs/libxfs/xfs_parent.c
> > > b/fs/xfs/libxfs/xfs_parent.c
> > > new file mode 100644
> > > index 000000000000..4ab531c77d7d
> > > --- /dev/null
> > > +++ b/fs/xfs/libxfs/xfs_parent.c
> > > @@ -0,0 +1,134 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (c) 2022 Oracle, Inc.
> > > + * All rights reserved.
> > > + */
> > > +#include "xfs.h"
> > > +#include "xfs_fs.h"
> > > +#include "xfs_format.h"
> > > +#include "xfs_da_format.h"
> > > +#include "xfs_log_format.h"
> > > +#include "xfs_shared.h"
> > > +#include "xfs_trans_resv.h"
> > > +#include "xfs_mount.h"
> > > +#include "xfs_bmap_btree.h"
> > > +#include "xfs_inode.h"
> > > +#include "xfs_error.h"
> > > +#include "xfs_trace.h"
> > > +#include "xfs_trans.h"
> > > +#include "xfs_da_btree.h"
> > > +#include "xfs_attr.h"
> > > +#include "xfs_da_btree.h"
> > > +#include "xfs_attr_sf.h"
> > > +#include "xfs_bmap.h"
> > > +#include "xfs_defer.h"
> > > +#include "xfs_log.h"
> > > +#include "xfs_xattr.h"
> > > +#include "xfs_parent.h"
> > > +
> > > +/*
> > > + * Parent pointer attribute handling.
> > > + *
> > > + * Because the attribute value is a filename component, it will
> > > never be longer
> > > + * than 255 bytes. This means the attribute will always be a
> > > local format
> > > + * attribute as it is xfs_attr_leaf_entsize_local_max() for v5
> > > filesystems will
> > > + * always be larger than this (max is 75% of block size).
> > > + *
> > > + * Creating a new parent attribute will always create a new
> > > attribute - there
> > > + * should never, ever be an existing attribute in the tree for a
> > > new inode.
> > > + * ENOSPC behavior is problematic - creating the inode without
> > > the parent
> > > + * pointer is effectively a corruption, so we allow parent
> > > attribute creation
> > > + * to dip into the reserve block pool to avoid unexpected ENOSPC
> > > errors from
> > > + * occurring.
> > 
> > Shouldn't we increase XFS_LINK_SPACE_RES to avoid this?  The
> > reserve
> > pool isn't terribly large (8192 blocks) and was really only
> > supposed to
> > save us from an ENOSPC shutdown if an unwritten extent conversion
> > in the
> > writeback endio handler needs a few more blocks.
> > 
> > IOWs, we really ought to ENOSPC at transaction reservation time
> > instead
> > of draining the reserve pool.
> > 
> > > + */
> > > +
> > > +
> > > +/* Initializes a xfs_parent_name_rec to be stored as an
> > > attribute name */
> > > +void
> > > +xfs_init_parent_name_rec(
> > > +	struct xfs_parent_name_rec	*rec,
> > > +	struct xfs_inode		*ip,
> > > +	uint32_t			p_diroffset)
> > > +{
> > > +	xfs_ino_t			p_ino = ip->i_ino;
> > > +	uint32_t			p_gen = VFS_I(ip)->i_generation;
> > > +
> > > +	rec->p_ino = cpu_to_be64(p_ino);
> > > +	rec->p_gen = cpu_to_be32(p_gen);
> > > +	rec->p_diroffset = cpu_to_be32(p_diroffset);
> > > +}
> > > +
> > > +/* Initializes a xfs_parent_name_irec from an
> > > xfs_parent_name_rec */
> > > +void
> > > +xfs_init_parent_name_irec(
> > > +	struct xfs_parent_name_irec	*irec,
> > > +	struct xfs_parent_name_rec	*rec)
> > > +{
> > > +	irec->p_ino = be64_to_cpu(rec->p_ino);
> > > +	irec->p_gen = be32_to_cpu(rec->p_gen);
> > > +	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
> > > +}
> > > +
> > > +int
> > > +xfs_parent_init(
> > > +	xfs_mount_t                     *mp,
> > > +	xfs_inode_t			*ip,
> 
> More nits: Please don't use struct typedefs here.
Sure, will fix

> 
> > > +	struct xfs_name			*target_name,
> > > +	struct xfs_parent_defer		**parentp)
> > > +{
> > > +	struct xfs_parent_defer		*parent;
> > > +	int				error;
> > > +
> > > +	if (!xfs_has_parent(mp))
> > > +		return 0;
> > > +
> > > +	error = xfs_attr_grab_log_assist(mp);
> > 
> > At some point we might want to consider boosting performance by
> > setting
> > XFS_SB_FEAT_INCOMPAT_LOG_XATTRS permanently when parent pointers
> > are
> > turned on, since adding the feature requires a synchronous bwrite
> > of the
> > primary superblock.
> > 
> > I /think/ this could be accomplished by setting the feature bit in
> > mkfs
> > and teaching xlog_clear_incompat to exit if xfs_has_parent()==true.
> > Then we can skip the xfs_attr_grab_log_assist calls.
> > 
> > But, let's focus on getting this patchset into good enough shape
> > that
> > we can be confident that we don't need any ondisk format changes,
> > and
> > worry about speed later.
> > 
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> > 
> > These objects are going to be created and freed fairly frequently;
> > could
> > you please convert these to a kmem cache?  (That can be a cleanup
> > at the
> > end.)
> > 
> > > +	if (!parent)
> > > +		return -ENOMEM;
> > > +
> > > +	/* init parent da_args */
> > > +	parent->args.dp = ip;
> > > +	parent->args.geo = mp->m_attr_geo;
> > > +	parent->args.whichfork = XFS_ATTR_FORK;
> > > +	parent->args.attr_filter = XFS_ATTR_PARENT;
> > > +	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
> > > +	parent->args.name = (const uint8_t *)&parent->rec;
> > > +	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
> > > +
> > > +	if (target_name) {
> > > +		parent->args.value = (void *)target_name->name;
> > > +		parent->args.valuelen = target_name->len;
> > > +	}
> > > +
> > > +	*parentp = parent;
> > > +	return 0;
> > > +}
> > > +
> > > +int
> > > +xfs_parent_defer_add(
> > > +	struct xfs_trans	*tp,
> > > +	struct xfs_inode	*ip,
> > > +	struct xfs_parent_defer	*parent,
> > > +	xfs_dir2_dataptr_t	diroffset)
> > > +{
> > > +	struct xfs_da_args	*args = &parent->args;
> > > +
> > > +	xfs_init_parent_name_rec(&parent->rec, ip, diroffset);
> > > +	args->trans = tp;
> > > +	args->hashval = xfs_da_hashname(args->name, args->namelen);
> > > +	return xfs_attr_defer_add(args);
> > > +}
> > > +
> > > +void
> > > +xfs_parent_cancel(
> > > +	xfs_mount_t		*mp,
> > > +	struct xfs_parent_defer *parent)
> > > +{
> > > +	xlog_drop_incompat_feat(mp->m_log);
> > > +	kfree(parent);
> > > +}
> > > +
> > > diff --git a/fs/xfs/libxfs/xfs_parent.h
> > > b/fs/xfs/libxfs/xfs_parent.h
> > > new file mode 100644
> > > index 000000000000..21a350b97ed5
> > > --- /dev/null
> > > +++ b/fs/xfs/libxfs/xfs_parent.h
> > > @@ -0,0 +1,34 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (c) 2022 Oracle, Inc.
> > > + * All Rights Reserved.
> > > + */
> > > +#ifndef	__XFS_PARENT_H__
> > > +#define	__XFS_PARENT_H__
> > > +
> > > +/*
> > > + * Dynamically allocd structure used to wrap the needed data to
> > > pass around
> > > + * the defer ops machinery
> > > + */
> > > +struct xfs_parent_defer {
> > > +	struct xfs_parent_name_rec	rec;
> > > +	struct xfs_da_args		args;
> > > +};
> > > +
> > > +/*
> > > + * Parent pointer attribute prototypes
> > > + */
> > > +void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
> > > +			      struct xfs_inode *ip,
> > > +			      uint32_t p_diroffset);
> > > +void xfs_init_parent_name_irec(struct xfs_parent_name_irec
> > > *irec,
> > > +			       struct xfs_parent_name_rec *rec);
> > > +int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
> > > +		    struct xfs_name *target_name,
> > > +		    struct xfs_parent_defer **parentp);
> > > +int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_inode
> > > *ip,
> > > +			 struct xfs_parent_defer *parent,
> > > +			 xfs_dir2_dataptr_t diroffset);
> > > +void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer
> > > *parent);
> > > +
> > > +#endif	/* __XFS_PARENT_H__ */
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 09876ba10a42..ef993c3a8963 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -37,6 +37,8 @@
> > >  #include "xfs_reflink.h"
> > >  #include "xfs_ag.h"
> > >  #include "xfs_log_priv.h"
> > > +#include "xfs_parent.h"
> > > +#include "xfs_xattr.h"
> > >  
> > >  struct kmem_cache *xfs_inode_cache;
> > >  
> > > @@ -950,7 +952,7 @@ xfs_bumplink(
> > >  int
> > >  xfs_create(
> > >  	struct user_namespace	*mnt_userns,
> > > -	xfs_inode_t		*dp,
> > > +	struct xfs_inode	*dp,
> > >  	struct xfs_name		*name,
> > >  	umode_t			mode,
> > >  	dev_t			rdev,
> > > @@ -962,7 +964,7 @@ xfs_create(
> > >  	struct xfs_inode	*ip = NULL;
> > >  	struct xfs_trans	*tp = NULL;
> > >  	int			error;
> > > -	bool                    unlock_dp_on_error = false;
> > > +	bool			unlock_dp_on_error = false;
> > >  	prid_t			prid;
> > >  	struct xfs_dquot	*udqp = NULL;
> > >  	struct xfs_dquot	*gdqp = NULL;
> > > @@ -970,6 +972,8 @@ xfs_create(
> > >  	struct xfs_trans_res	*tres;
> > >  	uint			resblks;
> > >  	xfs_ino_t		ino;
> > > +	xfs_dir2_dataptr_t	diroffset;
> > > +	struct xfs_parent_defer	*parent = NULL;
> > >  
> > >  	trace_xfs_create(dp, name);
> > >  
> > > @@ -996,6 +1000,12 @@ xfs_create(
> > >  		tres = &M_RES(mp)->tr_create;
> > >  	}
> > >  
> > > +	if (xfs_has_parent(mp)) {
> > > +		error = xfs_parent_init(mp, dp, name, &parent);
> > > +		if (error)
> > > +			goto out_release_dquots;
> > > +	}
> > > +
> > >  	/*
> > >  	 * Initially assume that the file does not exist and
> > >  	 * reserve the resources for that case.  If that is not
> > > @@ -1011,7 +1021,7 @@ xfs_create(
> > >  				resblks, &tp);
> > >  	}
> > >  	if (error)
> > > -		goto out_release_dquots;
> > > +		goto drop_incompat;
> > >  
> > >  	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> > >  	unlock_dp_on_error = true;
> > > @@ -1021,6 +1031,7 @@ xfs_create(
> > >  	 * entry pointing to them, but a directory also the "." entry
> > >  	 * pointing to itself.
> > >  	 */
> > > +	init_xattrs |= xfs_has_parent(mp);
> > >  	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
> > >  	if (!error)
> > >  		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
> > > mode,
> > > @@ -1035,11 +1046,12 @@ xfs_create(
> > >  	 * the transaction cancel unlocking dp so don't do it
> > > explicitly in the
> > >  	 * error path.
> > >  	 */
> > > -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> > > +	xfs_trans_ijoin(tp, dp, 0);
> > >  	unlock_dp_on_error = false;
> > >  
> > >  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
> > > -				   resblks - XFS_IALLOC_SPACE_RES(mp),
> > > NULL);
> > > +				   resblks - XFS_IALLOC_SPACE_RES(mp),
> > > +				   &diroffset);
> > >  	if (error) {
> > >  		ASSERT(error != -ENOSPC);
> > >  		goto out_trans_cancel;
> > > @@ -1055,6 +1067,17 @@ xfs_create(
> > >  		xfs_bumplink(tp, dp);
> > >  	}
> > >  
> > > +	/*
> > > +	 * If we have parent pointers, we need to add the attribute
> > > containing
> > > +	 * the parent information now.
> > > +	 */
> > > +	if (parent) {
> > > +		parent->args.dp	= ip;
> 
> ...and on second thought, it seems a little odd that you pass @dp to
> xfs_parent_init only to override parent->args.dp here.  Given that
> this
> doesn't do anything with @parent until here, why not pass NULL to the
> init function above?
Sure, the init helpers are helpful, but do create some out of order
initializing since sometimes the required parameters are not all
available at the same time.  Will update.

Thanks!
Allison

> 
> --D
> 
> > > +		error = xfs_parent_defer_add(tp, dp, parent,
> > > diroffset);
> > > +		if (error)
> > > +			goto out_trans_cancel;
> > > +	}
> > > +
> > >  	/*
> > >  	 * If this is a synchronous mount, make sure that the
> > >  	 * create transaction goes to disk before returning to
> > > @@ -1080,6 +1103,7 @@ xfs_create(
> > >  
> > >  	*ipp = ip;
> > >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > +	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> > 
> > I don't think we need the ILOCK class annotations for unlocks.
> > 
> > Other than the two things I asked about, this is looking good.
> > 
> > --D
> > 
> > >  	return 0;
> > >  
> > >   out_trans_cancel:
> > > @@ -1094,6 +1118,9 @@ xfs_create(
> > >  		xfs_finish_inode_setup(ip);
> > >  		xfs_irele(ip);
> > >  	}
> > > + drop_incompat:
> > > +	if (parent)
> > > +		xfs_parent_cancel(mp, parent);
> > >   out_release_dquots:
> > >  	xfs_qm_dqrele(udqp);
> > >  	xfs_qm_dqrele(gdqp);
> > > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > > index c325a28b89a8..d9067c5f6bd6 100644
> > > --- a/fs/xfs/xfs_xattr.c
> > > +++ b/fs/xfs/xfs_xattr.c
> > > @@ -27,7 +27,7 @@
> > >   * they must release the permission by calling
> > > xlog_drop_incompat_feat
> > >   * when they're done.
> > >   */
> > > -static inline int
> > > +int
> > >  xfs_attr_grab_log_assist(
> > >  	struct xfs_mount	*mp)
> > >  {
> > > diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
> > > index 2b09133b1b9b..3fd6520a4d69 100644
> > > --- a/fs/xfs/xfs_xattr.h
> > > +++ b/fs/xfs/xfs_xattr.h
> > > @@ -7,6 +7,7 @@
> > >  #define __XFS_XATTR_H__
> > >  
> > >  int xfs_attr_change(struct xfs_da_args *args);
> > > +int xfs_attr_grab_log_assist(struct xfs_mount *mp);
> > >  
> > >  extern const struct xattr_handler *xfs_xattr_handlers[];
> > >  
> > > -- 
> > > 2.25.1
> > > 

