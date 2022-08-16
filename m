Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5C1C3F6B0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 20:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbiHPUlb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 16:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiHPUla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 16:41:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848E57D784
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 13:41:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GKYa0l008653;
        Tue, 16 Aug 2022 20:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jtc3pqhPpQ0bUkxAxf4sUASMiv+FRkjwEvuGyDmXJ+Y=;
 b=GWXkQOZcB7mTrp5Dc9hgRSJiGVJIazxS1YluwllsPGvCQxhmdrY/mxWKewO2BWpOu7KM
 3EBslqTotJad7LJsDvytTKv/l1/Sr7RFvgeyMyBrCE5f6suGFynkxRxZsWaamKWO/lTk
 /ZtL2zdu+B3IwNSqZwYslT5Be7sW4xq4aDWZTxenfJZK7Vpt0KydhWP4pOhKPzZFgZIc
 2nApQyOSMALc5SqugCGFUpFANdQdxUbbtOvXctYJRNs2ZztSFMJzectu5L30AOYjcF5N
 jzd8fSEUaVZaZTiGdwPGvjbNDjpOW3WX/Y8DpRYM5qBk+JDZnu3CMAtJlrDN3Pp/BJFy cA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hx3ua701m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 20:41:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27GICjK2004670;
        Tue, 16 Aug 2022 20:41:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j0c2acvxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 20:41:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvGUMi7UE3M3l8lh4PG37KIyU30kCfqQurUVmFVx8FhByytz0fP1pH4ADT8pF67sraXqin36qnXdYJJRzJnecAZTxYzzGHghkN6O6/U99IUksY3qK2NfrrfqhhaSExgr+xsU37snyRNkR+e3yepwqGl4HwBiBjsUgjf++0Bq5ufaqXNyfgfTcFrnBfLHIhihe6NVq3KYx64amM4UqF1UeDg2F0VQD/WZuCzKdQtgp77Tj371vdO4BDtQnRRmx0RvILEY1giO96eS++QFpitkUzO5mfCJQq6EqVeVNuN3O7vvvOviBHhY8GUmzySh2efYgEMa1F4wTA+G3k3sEndpEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jtc3pqhPpQ0bUkxAxf4sUASMiv+FRkjwEvuGyDmXJ+Y=;
 b=m+s0VDZkUrmSAbI/+jidnqv2cSpCWzNrKbcS7c5CxrqP2Mtn08ySfVY4SWasTlsoPXaI5kT/3Q1v6LLkdlWPvwCwgba61NMV1Lr2QuurlhjDl/nT9wm+YYUcl9aTeqrea0NStC2J8FBdvLynz2qBtuxg1CgS4OptW2qUzBacxIBnkRG+sbOLSS6eES39L52Qybw72gatY1+4PnFZn8pg4GBOEJzmjz8MaXn7RIFfA48BwkSJESCm0r5dV3s6elt3V37EPR5wEPBR2IoWRLdhOBUaVNz1O7TUcvdCdBP2FvXZ62Wj8O/Al7dmdSpdTonPu0jOBH/ylMtBa4oL3yHZqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtc3pqhPpQ0bUkxAxf4sUASMiv+FRkjwEvuGyDmXJ+Y=;
 b=HYyII+rDHz6xrf8yom9MKjbD/h7J8HQiYdwLbyB3y+1Rzi1g6YPklA5xFiwXcikrAxyQJJr9ljvPNgYU4L02zfSbk21chk/2nfQGfphpOe/W296uyLHSO7hkYk4bnSPDwyo7+D+3dGCZjVNP3YfoBlM7ji/aWvE/DrwIqnsciG4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4530.namprd10.prod.outlook.com (2603:10b6:303:90::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 20:41:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 20:41:20 +0000
Message-ID: <9acef43634b41baba8711dc47aaa7bd0cf46874d.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 16 Aug 2022 13:41:06 -0700
In-Reply-To: <YvsmAgj348tlKfCL@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-2-allison.henderson@oracle.com>
         <YvKQ5+XotiXFDpTA@magnolia> <20220810015809.GK3600936@dread.disaster.area>
         <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
         <20220810061258.GL3600936@dread.disaster.area>
         <f85ae9d8425aaff455301b28af32ba0d813f733b.camel@oracle.com>
         <20220816005438.GT3600936@dread.disaster.area> <YvsmAgj348tlKfCL@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 390a055d-5bc9-4e60-e4cf-08da7fc7ad12
X-MS-TrafficTypeDiagnostic: CO1PR10MB4530:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2oK6mVp/gAujMdaEnN7R2iuRhj2BWY54tHsMZJvRxrNVndHPV5Ih1nf5AtT/2pQu8LGraIgEa0eJw4zJINT4QncLa+oLjwftqi1yTrGvqPGk8Gbka9PCFflhWxEIaWMKDLmozmSh7eP6Uac3Xu5zimmQvufAcWyBlNHx0e1MqtTbVUtE5BVF+2RUwRxTT0ctJVtp/ylJZvispo2AJTQWmhvJpugKCxmeo1ib8XhT8up6OBH1KrXZTWdXZyskYOULMrXeLmU8fA/mpr/vqv12d7hxXX0zS+WLoZNlQJsJs0K8mpul2o/TFQSvQkMG2/vUTjF8tREt0kVpONdvVlL5aPGJntCaVaCxkgHMOjwcwG+wWwcaOKKX5rHjMVYmstZV3OhMDycwZ10OQOxP0TcKZQSOIHm59aVFR3zMhAvI8525h7OkrOHzYEnZq8nC0gBHYALWB4LDixTmB7JceZe+GGyGqRuaP1fIaKIc4mUO1gt3V+KF1iSMGYGZR6/wP+qBPxQPtpLSaAOCkq+In2ubPDMMrmJm4PICLDIGvgaQ4HtYOHUHbVPCKTlv7uYltPt+BnmpXBIa3TbpPx9YEjXsb7o87ZHhRlLMGbuak1XoFQfTCJNoZsPFhTptvYhTLZRZrq2sAKnWZNkC7T9LsxTpxMdc+gRyYCdYBk8l3xFp9SHelpmNFSi4FoVX7Az4hozwfQeTsDcrSFgc4TGwyNzF78QhBxQDEbKJnUNCf3fKJPecXZJj/kfcckVTDb3U8+9rF2cWMOxrBCB7XGlTNefwTrh2G+nFXNrOLjuLVG4gQag=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(346002)(39860400002)(376002)(83380400001)(316002)(66946007)(66476007)(66556008)(41300700001)(2906002)(6666004)(8676002)(36756003)(110136005)(4326008)(2616005)(186003)(38100700002)(6512007)(52116002)(6486002)(8936002)(86362001)(478600001)(38350700002)(5660300002)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFBzWUhqMkJDbmg0blluaGJLOElQd3dQTEpadGNUOVB1YmJTZVo0aXNVM0tR?=
 =?utf-8?B?VHY4Lzh1Vkp1aFU1ZDJWM3NuZ2puckpCNnlZcWhNNjFzVExoK21DWVNkQVlG?=
 =?utf-8?B?b1ZGbW1tRVd2YkxXeTMvb0c5RThIS2I4cXRBWExhVFcybzdKbUVSWUtHN1dl?=
 =?utf-8?B?ZFpONnhwUWh0Yzg2U25MTHpLajhkZWNBbG5YS3ordDBDNkJVeHE5Nnc0OW9n?=
 =?utf-8?B?YldKT2QrZGZJNjVvbWVVSGdkWFhxOWRWSndnZmV5aGpPZmlmU1pQSnMvbHhU?=
 =?utf-8?B?Z2g2c0Q1VG5zSUdzK0JzSG5wRXl6a1M5Q0ZlMmdLbUc4RkVZbFVPQlZCNEVU?=
 =?utf-8?B?Zm5tZXNGcmJlOXlNNHBrTlJ2ZmMxRnI5M0hPdVUyUGpyUnpHQzMzZm51Snpy?=
 =?utf-8?B?SENiSmtxWENSWDF6WHFVYUtXMlhOTnJQN0hadEwxa0FoSDJZS2EwUjc0MmRj?=
 =?utf-8?B?TzdSVGxUaXFPZjRUbDFSTW9xQVZ4QlBoZjZSVmYwdXpNVjZoMGx2YTVFUjNH?=
 =?utf-8?B?MjlXaXJsQk5SUWRlNDFuNHNodEFLQjZtbm15ckdGT1RzdU5RSm5leExrZkhh?=
 =?utf-8?B?aG9RWXcrNEJyRVZPdmNsc09pR1h6bEVqVkVUczZrdVhKYnhpTmloTmNiS2E4?=
 =?utf-8?B?NDk2anlEb0dQcnNxaHQ0aGNiMDZVc2pYSmE4OXBZNjBkb3d4ZmJsUEc5amFu?=
 =?utf-8?B?Kys5VnFnVVdDV092ZE9DTWNqNG9Qdk51TENSS3ZIQVk3U29wTCtpNzZpUk5v?=
 =?utf-8?B?akxxR2lYQjhyRzhqb3JZNUJIQ20ySm90SVBOQ1M5L2V3bVJzRDlyYUwreWQv?=
 =?utf-8?B?SnhoZnc3RzV4RSsrVEV2K1hXQVdxRUtJaGFvQnF2Y3AzUyswLzBCYXpOQWh1?=
 =?utf-8?B?bC8rYXh2K3Q2WXE4MUhnbHUxVzFqOEV0blVFYjVrS1N1LzhyamlWWURidE5j?=
 =?utf-8?B?K1NuaGF2SUt5QkpPUC9rOWFlOGszS2NMeHo3T2FydmRON29XR2dGSC9uZ0dq?=
 =?utf-8?B?eDRiZnVGOG5sNEdETjV1TGZpK1NZcVRJSGFuaTRuS0pLVTUrUWVzSXVFSEFE?=
 =?utf-8?B?TWlaeFJRNlViRWo0UXRselNDUTlZNWNkeEJZNmVyTmtqVnpIVGZiY2xEanJ1?=
 =?utf-8?B?cGhHY2RFcTQyaDJ1MEtLN1NnRkg3NFQ5d3dwT0xOU3N4S09MenZzZnBNeW0r?=
 =?utf-8?B?dDAyN1lMLzc1VG95QjE5KzlFakM4UzBtYlZ1Rlk1bXVuV21FNUR1L0VBdGl4?=
 =?utf-8?B?anFaNWJGNzdqdnpUdXdEQm1CM0lPdzBNVG5CWTBsVElmYXRSOXZZK2ZqS1NP?=
 =?utf-8?B?WkorSU4yazhLREZ2L1dGdDJnaTl1M24rZUlQRjFJRWNwYzd4Mit0NDBxWllh?=
 =?utf-8?B?SGNJdVBSN2g5L2creWo5eXVlc1RXTVlxLzdoNXEveHpaSjkvejg5bXZCSlBu?=
 =?utf-8?B?c0g1UTE1RGVselZnK1IxenZMTG5PNUdPTVgraUNDeEUwY3ZrWC9YMUs1T2lJ?=
 =?utf-8?B?M0FRWUxhcFR2eVo1ZXByaytIK25NMmcyVHhRclpEbncyU2h4TUY4QmlQT2Ji?=
 =?utf-8?B?T3poa3pGanFmZVNobG1zajRNUlp0eXFFcUNyMk5ibEJTb0ZqS1JidVRWMW5z?=
 =?utf-8?B?Sk1CQjBkeERkdTQ1WjU1ZVluUjMxQVdDT2RaQ1RtalJPWVJMd0dsUktxUEc0?=
 =?utf-8?B?TEZ6bVdIMmllcDRNcUIzR1hFTm5ob0M4UUtOa1p1NUZveCtLSGJreVVEN3FP?=
 =?utf-8?B?M3RqWUpHcHlKb2t3d25MaHg5bXVmcVo4UFBvY2lNODE2cUxtcE4ydzFDWlhQ?=
 =?utf-8?B?cVZzSmczWEFMeUlacjhKek5ROCtBUDR4L0Z5clF0ZFdrTURYRWw2Ky8xekNv?=
 =?utf-8?B?ejJFVjZXU2J4cUJnb3ZUUHpxN3NZUHpGK0hMcVBtUjRWQWdaR2Fta0hGcGVI?=
 =?utf-8?B?Qkw5T3RpQ3MvZkJsWlZnMllNTTZaSmNET2pRaHJWbWNVS2F6NSs2L1cvRnVD?=
 =?utf-8?B?TExJOGhLdUphQ1l1d0dNY0NHSXEvdUdtNTVHUXE3NXo3RWo5R0M2cDhZQ1VU?=
 =?utf-8?B?bzBKd2R2cDR2YkxYYlQrbzZ4RUtZeGVmbFkvdDNseHBENVlWY255amIrR3RK?=
 =?utf-8?B?cURLbWQ3QTBMUUMzM3NoVTZnMWpvakpkWGhvVEl6dzZrNUIrTk15RG5mN1Nt?=
 =?utf-8?B?RWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 87jqOZeeWFfr+IvTpHN/2JKtWoYfuRTBlhr3oENvf0t+qhWv6TxR1MZ5SJZ3tNoh4L68RuKNAP2/MTsJ4VYVSclEKqB1Ns2W4L+JizLAdmfavh0EJuKYFn/uBwQFibBOr5Nqkj/21C48753+WHVLAtUvn6eg2k2CMAb1Fiifle4pyrx69kRwCNgN1Ok1Z5g7MJek4H30tGKYONAgLIzC20DtHjNgAeIc5amcyZO+9pkPyZ8hX+g+G9TTpfUloEsy5obDpnBLR7nEn8Ms+2p3yZsgd/Swv6bO3aVQ1yz7GEEN7VftM5YsMxFjkyQ0neiWSjIF6y7YhG0sKdgqvGXlebxB7Fdq99st96akEVcHzoNi+TA5SR938bRB5L9TslmOAvKTK2d+pWcA1fBE8xzY3RA2LLBWJ9bsjGU9H2+RLsK5/93mf9CiJ9pqZ2yLC4nfC1FxF9xaA5RbPdh/BRKJAaWONNPWRJMTprl4M58WXL3W75Dm53jm2pF/vm9qQHwlC+Qp/IQ4Mn4pxXR6PHwCKn+h8kDBqLFd04Z/Agix4uTZ3vZnjbIoMYcRJXpWwA8ug0gQLFfORFG5WbxTZfcqkJy1RFlB5L52U11ve5YF49Ek4o/NzXyR0IzJaKj9vE9oGzwqCYX7ly0LH/SICcx6D3VXX0Y9C1aqy6WpwdESHx3dP6oXxPzQPGthoAncCchjV9CGH/W/mDn3nPl7r9g+QOkTAJy8h7Tf6wmBgnmvGGH58Y/MM+OS67MGast1Uax78Z5k3qWXGLCDSTZMOuQQVJ7C516YPEGPTozx5u3jse8C7EASsb9wbIkMPRaMz5a2
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 390a055d-5bc9-4e60-e4cf-08da7fc7ad12
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 20:41:20.7293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/sRHL+vIZaI4BN7SVd8Znxn6CQ4NUF7RoKaKthRKfhxdqDc74BkxRBEmWMhAcCl5nW7TzFz5m5hXq3KxmIfZXu9BPZss5sibmJA0oPudbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4530
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=711
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208160076
X-Proofpoint-ORIG-GUID: hc4nWtXkOczvQZmG9-9ehpats0svOcqw
X-Proofpoint-GUID: hc4nWtXkOczvQZmG9-9ehpats0svOcqw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2022-08-15 at 22:07 -0700, Darrick J. Wong wrote:
> On Tue, Aug 16, 2022 at 10:54:38AM +1000, Dave Chinner wrote:
> > On Thu, Aug 11, 2022 at 06:55:16PM -0700, Alli wrote:
> > > On Wed, 2022-08-10 at 16:12 +1000, Dave Chinner wrote:
> > > > On Tue, Aug 09, 2022 at 10:01:49PM -0700, Alli wrote:
> > > > > On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> > > > > > On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong
> > > > > > wrote:
> > > > > > > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison
> > > > > > > Henderson
> > > > > > > wrote:
> > > > > > > > Recent parent pointer testing has exposed a bug in the
> > > > > > > > underlying
> > > > > > > > attr replay.  A multi transaction replay currently
> > > > > > > > performs a
> > > > > > > > single step of the replay, then deferrs the rest if
> > > > > > > > there is
> > > > > > > > more
> > > > > > > > to do.
> > > > > > 
> > > > > > Yup.
> > > > > > 
> > > > > > > > This causes race conditions with other attr replays
> > > > > > > > that
> > > > > > > > might be recovered before the remaining deferred work
> > > > > > > > has had
> > > > > > > > a
> > > > > > > > chance to finish.
> > > > > > 
> > > > > > What other attr replays are we racing against?  There can
> > > > > > only be
> > > > > > one incomplete attr item intent/done chain per inode
> > > > > > present in
> > > > > > log
> > > > > > recovery, right?
> > > > > No, a rename queues up a set and remove before committing the
> > > > > transaction.  One for the new parent pointer, and another to
> > > > > remove
> > > > > the
> > > > > old one.
> > > > 
> > > > Ah. That really needs to be described in the commit message -
> > > > changing from "single intent chain per object" to "multiple
> > > > concurrent independent and unserialised intent chains per
> > > > object" is
> > > > a pretty important design rule change...
> > > > 
> > > > The whole point of intents is to allow complex, multi-stage
> > > > operations on a single object to be sequenced in a tightly
> > > > controlled manner. They weren't intended to be run as
> > > > concurrent
> > > > lines of modification on single items; if you need to do two
> > > > modifications on an object, the intent chain ties the two
> > > > modifications together into a single whole.
> > > > 
> > > > One of the reasons I rewrote the attr state machine for LARP
> > > > was to
> > > > enable new multiple attr operation chains to be easily build
> > > > from
> > > > the entry points the state machien provides. Parent attr rename
> > > > needs a new intent chain to be built, not run multiple
> > > > independent
> > > > intent chains for each modification.
> > > > 
> > > > > It cant be an attr replace because technically the names are
> > > > > different.
> > > > 
> > > > I disagree - we have all the pieces we need in the state
> > > > machine
> > > > already, we just need to define separate attr names for the
> > > > remove and insert steps in the attr intent.
> > > > 
> > > > That is, the "replace" operation we execute when an attr set
> > > > overwrites the value is "technically" a "replace value"
> > > > operation,
> > > > but we actually implement it as a "replace entire attribute"
> > > > operation.
> > > > 
> > > > Without LARP, we do that overwrite in independent steps via an
> > > > intermediate INCOMPLETE state to allow two xattrs of the same
> > > > name
> > > > to exist in the attr tree at the same time. IOWs, the attr
> > > > value
> > > > overwrite is effectively a "set-swap-remove" operation on two
> > > > entirely independent xattrs, ensuring that if we crash we
> > > > always
> > > > have either the old or new xattr visible.
> > > > 
> > > > With LARP, we can remove the original attr first, thereby
> > > > avoiding
> > > > the need for two versions of the xattr to exist in the tree in
> > > > the
> > > > first place. However, we have to do these two operations as a
> > > > pair
> > > > of linked independent operations. The intent chain provides the
> > > > linking, and requires us to log the name and the value of the
> > > > attr
> > > > that we are overwriting in the intent. Hence we can always
> > > > recover
> > > > the modification to completion no matter where in the operation
> > > > we
> > > > fail.
> > > > 
> > > > When it comes to a parent attr rename operation, we are
> > > > effectively
> > > > doing two linked operations - remove the old attr, set the new
> > > > attr
> > > > - on different attributes. Implementation wise, it is exactly
> > > > the
> > > > same sequence as a "replace value" operation, except for the
> > > > fact
> > > > that the new attr we add has a different name.
> > > > 
> > > > Hence the only real difference between the existing "attr
> > > > replace"
> > > > and the intent chain we need for "parent attr rename" is that
> > > > we
> > > > have to log two attr names instead of one. 
> > > 
> > > To be clear, this would imply expanding xfs_attri_log_format to
> > > have
> > > another alfi_new_name_len feild and another iovec for the attr
> > > intent
> > > right?  Does that cause issues to change the on disk log layout
> > > after
> > > the original has merged?  Or is that ok for things that are still
> > > experimental? Thanks!
> > 
> > I think we can get away with this quite easily without breaking the
> > existing experimental code.
> > 
> > struct xfs_attri_log_format {
> >         uint16_t        alfi_type;      /* attri log item type */
> >         uint16_t        alfi_size;      /* size of this item */
> >         uint32_t        __pad;          /* pad to 64 bit aligned */
> >         uint64_t        alfi_id;        /* attri identifier */
> >         uint64_t        alfi_ino;       /* the inode for this attr
> > operation */
> >         uint32_t        alfi_op_flags;  /* marks the op as a set or
> > remove */
> >         uint32_t        alfi_name_len;  /* attr name length */
> >         uint32_t        alfi_value_len; /* attr value length */
> >         uint32_t        alfi_attr_filter;/* attr filter flags */
> > };
> > 
> > We have a padding field in there that is currently all zeros. Let's
> > make that a count of the number of {name, value} tuples that are
> > appended to the format. i.e.
> > 
> > struct xfs_attri_log_name {
> >         uint32_t        alfi_op_flags;  /* marks the op as a set or
> > remove */
> >         uint32_t        alfi_name_len;  /* attr name length */
> >         uint32_t        alfi_value_len; /* attr value length */
> >         uint32_t        alfi_attr_filter;/* attr filter flags */
> > };
> > 
> > struct xfs_attri_log_format {
> >         uint16_t        alfi_type;      /* attri log item type */
> >         uint16_t        alfi_size;      /* size of this item */
> > 	uint8_t		alfi_attr_cnt;	/* count of name/val pairs
> > */
> >         uint8_t		__pad1;          /* pad to 64 bit
> > aligned */
> >         uint16_t	__pad2;          /* pad to 64 bit aligned */
> >         uint64_t        alfi_id;        /* attri identifier */
> >         uint64_t        alfi_ino;       /* the inode for this attr
> > operation */
> > 	struct xfs_attri_log_name alfi_attr[]; /* attrs to operate on
> > */
> > };
> > 
> > Basically, the size and shape of the structure has not changed, and
> > if alfi_attr_cnt == 0 we just treat it as if alfi_attr_cnt == 1 as
> > the backwards compat code for the existing code.
> > 
> > And then we just have as many followup regions for name/val pairs
> > as are defined by the alfi_attr_cnt and alfi_attr[] parts of the
> > structure. Each attr can have a different operation performed on
> > them, and they can have different filters applied so they can exist
> > in different namespaces, too.
> > 
> > SO I don't think we need a new on-disk feature bit for this
> > enhancement - it definitely comes under the heading of "this stuff
> > is experimental, this is the sort of early structure revision that
> > EXPERIMENTAL is supposed to cover....
> 
> You might even callit "alfi_extra_names" to avoid the "0 means 1"
> stuff.
> ;)
> 
> --D

Oh, I just noticed these comments this morning when I sent out the new
attri/d patch.  I'll add this changes to v2.  Please let me know if
there's anything else you'd like me to change from the v1.  Thx!

Allison

> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com

