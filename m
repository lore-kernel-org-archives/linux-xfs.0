Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B021C19F2D
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiHJDJq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiHJDJm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:09:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25FE81B28
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:09:40 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0EvQI001975;
        Wed, 10 Aug 2022 03:09:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=f7yJ9PAZjqMATrBGJM2j2IsOps201sED6VX9aWddPHc=;
 b=jYxdSVbEQZjn/UnwAxAsbvaRWxcFoihKh9emDTSa4tOMM6+B3wjoDtANHYxCbuCi7DNT
 dagQUpxrZGSWLdXKnWULJAagRsp47ILwjzvLGHkG7oKGEwhVTdG2ZgEM7stRzWoSL6x0
 kHsiRwzd4jD696LRhUWoEYnwwJ4Sle/1en4Q29Onj0p24Vz5dI6ni01z4+e92opRVq8n
 bImnQ5QYQZLGWMHDEMVQRSmxvqd4m81G6bmlU+8ftjN5qMwF6wRQxo/jzUW0t2iDhsaw
 PQFUYdLzwVsKLqErkqp8cBElrtGX+nnGwgn0WQDOLuBYncWeEjNK3c2lr5ZS+BSfR7u1 WQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqggntu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279NxqFR038477;
        Wed, 10 Aug 2022 03:09:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqh8gdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eETE/6qf26Zm6p58r5XgChnskAb2pxWElp5X5bqAc+E6JNFsJASvRdrktYPVxqBGofjipA50YVY9nD186cmJoN6wc9q5BtZxdFIvaPyy6WQw0tn3X3vD7wjaUL/5I878Pxv+WjBFGdpMm8YuBZE2UrmcSCBzg6r0y/nMgCQ85DVUAY5ZnDJmhs7nwWNPdcmksRhg2UZvzoWS+0cR3mRvRLwtGtqmVmf7J2Sdo1cF8zux/dTry47yJgZOl+OM4DVq91YR7XxbdvzsCtq2yBTAhI1T0eyyJ5xphZXQfzIGL8gydddQ1qCcbG6MzPb97Vjn/PLAraRGSeoO1ePYKeC6aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7yJ9PAZjqMATrBGJM2j2IsOps201sED6VX9aWddPHc=;
 b=B6j47Hc0qxJalzc87d87Ro5w7rGF3tXV0XG+B9hvtM28P/XyOwfAXqlKPcMjHEVggcQHgx63LCCAuspugX/fCpw2ZqXSxNBJm6py07yPximjJxoU9Gj1GIISb7T5dK5QXEnLQJYYCWpvo8xzNPI/TkzPIAsrFKnUQ8WAtXHbfNXZWqjaL0NPkA36C89z4FaaldLRWuHDPIqrNqaQfinO7ZQCXbI8KFrFqt6g9vG/B1QRkTtGAqxFM5OngJE7RcSGhvp6SPjL4aBMqZM+s2jFNp4A9eTacKNvamYcvZxjNmwAQA3W3pR2qkZHnxt/aFPvNELzj4Xlzxsl02x0rtbIiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7yJ9PAZjqMATrBGJM2j2IsOps201sED6VX9aWddPHc=;
 b=K2a3gvRx/TNFTcfS7lO3QxjqzZGEZ0E+PGCnpxn3G51QsRYCWQFZDRtJz2Y4RG0UdxvkdEO+nyBleePiWZMms3xuctvh/c6p3DmHsUO3K2HLNkA/A7m32KxfEgI1p+CL/CJckk0JwFaTLhNkyy2glSwhfvsHL8/c8rkiBqXKE/c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4545.namprd10.prod.outlook.com (2603:10b6:303:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 03:09:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:09:34 +0000
Message-ID: <2483ba4059c4290d6954a97ff8bfc5df7c6ab792.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 14/18] xfs: remove parent pointers in unlink
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:09:32 -0700
In-Reply-To: <YvKrPl+SHzKtFNaq@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-15-allison.henderson@oracle.com>
         <YvKrPl+SHzKtFNaq@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0272.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6390d62f-e9e4-48af-c123-08da7a7dc048
X-MS-TrafficTypeDiagnostic: CO1PR10MB4545:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uWkyUGG2PONGt+citUQhMNXTPzPtYyyf0HFEIJsqSfQIgFWwJiEMwTgjz8Yryioyp1t29oW21xpNW8Vh6VS2lGuc9MNebNwyuzR0TFfRpixandazoPADNzGY+abHqPUelYTUM3vzOXpQkiC9ietMpp34GjCLIdzLzYDz0ObWpSLvQQ/+GzzMF1nkNwWRNDEmqSPy+PBjGlSeOTpCSDASMuzB5lQSaYm3AJdyBgyQdmFrfkYdJcYzmlgGQkU5fKiNh4P3/uF2nDILhL6X09nHCan6QDueShhDbn4MYMyt5fCg3sbzbkjDymq5XXU3ucJGWkuJtptPzojSbG/rXirNYegdihmpfnig0Pl2Sn3NgzmkZlloCbtXdpXg03icBwXls4RWfpJEQWCXLYk4owkp4EXZ8pDmsgB2CiXJbmUP+4K//hJhP9OPMlKS3PAIAfERB9/i1BIZHbiJ+Cj4JDdrs74ZzL1xLZYWRjW64OO9vnA5h91diMGz84Slj1pKpSFyRRF1KHPexn3Q2mB7ZaIjeA8DVlKub0CMcckxRIq+iskFuW4LNJmWhw+BalwrLAELXJLUJKMjt24ThctiuQMfse2uk6DrFzkYhiuhBd34iGRKt2rNpITSFHzmemqNjzn+wjeBDqGT4qB9dQOlBoETY5SLQyO/aBKAzv9q+JsQZeb//NWJ3kUs0AsrojpC0hYpaOiCkt5dyhmSJO5bRqJ+M7lbowEI1anrGt47gQQKp1uYmyVJ02JEpHHzIcfsGr5j8QeV9DkqW6if1mK8GGaIVj9Ab+NTSAgEV4bHMaDKkmc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(396003)(366004)(38350700002)(38100700002)(26005)(66946007)(8676002)(4326008)(6512007)(66476007)(66556008)(36756003)(6916009)(316002)(478600001)(2616005)(86362001)(6486002)(5660300002)(2906002)(8936002)(186003)(41300700001)(6506007)(83380400001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDJPMWk2QmsyT1Jvd096MjRNUEFBRU1SekVxOFY1ZVJFY01iZ21VRmtQZEhH?=
 =?utf-8?B?UXB5SXRidmZPY1hiRzJXb2JYTFNTbE9MUVIvYUtMS21HMG1JRnoxZm9zczFK?=
 =?utf-8?B?dENnUU02V3hMTHFJdU5JZmVicysyOHo5by81YzJhZnRSeTZzN2hjZjByaHNy?=
 =?utf-8?B?VTdZaGQvOWxLSjZwQWc2V1ZPQXBSblZEKzJyelBXWVJPbGVMQW94UHVoMXRM?=
 =?utf-8?B?YlY5cEE2YzAwQlZsdWRPOVZPMk1sK0VvdTlmWTVaMktNaWZtM2J4cVpSYmJh?=
 =?utf-8?B?bFZuWHY1WVpUR1oxNUc5UjBaa2JvTStCb2N4ZzY5KzdSVmNkazhlZG5OSjht?=
 =?utf-8?B?UE1JazhlVER6cG9CbU1TMys0TTdaUHNkVEJKUElVem5Jays1aGU0M2R5VUwy?=
 =?utf-8?B?akxseCtEeGdXaXZLbHpLaXFOSjZ5d0ZoZ1dZZjR4cmlMQXBYeFlXcWVSOU5p?=
 =?utf-8?B?YmNBVHlSNnFwTUlLVnJab3ludTJpM1BHM0pvTld1QjFGKzk2cmlQcktoQkI3?=
 =?utf-8?B?S0w4VVROTC8rc0NyOTQrQzRYU2U0RkdjOFZ1c21KbW9YdWVUWXNoUnhlYVVJ?=
 =?utf-8?B?VWVRYmprbXB6QTFpOVRBNFZJRTNOdXZzbXlqK1RrSjgxU3A0RmVzSDV3STl6?=
 =?utf-8?B?V29RQXFCLzdqMEk1SldVVWEyNUxSNDBCakRDdkdjNEI1dFVxdEVINVRFTG9n?=
 =?utf-8?B?SVVPemM4RFhXU0ZrbGt5Uk9ZOStFNTk2WmxWM2piQkV3dVMxUXVGTWNjamRt?=
 =?utf-8?B?ZnhMYjFJNnpUZHpVTTQ2dlNDYUVHMElPNE5FL09GTDgyTjlXY09YZFRGZnZH?=
 =?utf-8?B?VGRETCtodnZydzNuSStrOVFjQ2YxZG1SdGRjanFrUkZLNFU2VkZyOHJ1WlYy?=
 =?utf-8?B?MGo3MlJybS9WWUxwU3FraXJQOXQ4MkVRYlNUSjFjdHlTMVYxbklENEtha1FX?=
 =?utf-8?B?NE40UElPSVN3R0YxYmZZeXVITXFzSEVQZ0tFWWE4SFBwZ2R0TmhDdmlSUXF2?=
 =?utf-8?B?TGpiRWhHOXk5ZjczUFl6dC9IdVBlNVVoUEtUak9sR2RVaHhCY2xFTmhTNENw?=
 =?utf-8?B?SjhlaDErbzNQZjkvVFJabFNkYWFFVmpwUUNvZVZmUUEydjRoSmdhK0U4blla?=
 =?utf-8?B?YVFJVTZsWkFqS2ZkZnRLT25GWXJ5TUNqemtnUkg3MEhjd3R2cHhxUFdWekwv?=
 =?utf-8?B?T3VEKzgySU9icnUrV3ZBWGwvc01tK0dQSlQxcEJscE5Hb3VCZE5GdmxUNEtD?=
 =?utf-8?B?RWRlMUx0MHk4WVA1MjR6WFlyZEJXaklNbVBoYk1BZ3YwSTBlbE5FOURMZms1?=
 =?utf-8?B?ZFJ5RnM0UjVJY1JSbHVIRWY3MjhVTnlSRDExNm9aK3R0aGxEcW9FdDNCTzFS?=
 =?utf-8?B?OXFQTVBEbktmOVRkNWx3ZURJOTdZdUFTQW1kcVdkWlFMU09WU2VNZGtUTjZt?=
 =?utf-8?B?aUtoQVZvcGt0aWNMVEJyNnpBMUgzQ2JqZmRPTEVKOXhUUnVJczlhdDhnazFD?=
 =?utf-8?B?NGNxUlpVamxPTzVuN0ltQTNjOEZnSFNBZURKNUNyTXRqa3lsUkNIYXZNc0xE?=
 =?utf-8?B?V2NHTkR1TXRVaU5mOXVJKzc3alkrNUppTCtUWTZaQTV4aEJOSWJqVEFXRzZm?=
 =?utf-8?B?dDhObTRBUW9JWGtKa2hxcGlvQ2ZONHVtUHNQaEFvVTVHMVBDQkQ3aUtDTVpz?=
 =?utf-8?B?SUw1Tmh3MG5ZNkx1UngxdnMvaHZVcm1FdWl2bmk3QXRJd1pCMWF5eE9FdDBw?=
 =?utf-8?B?cVgySDNaK3N0Y1RkUzFrdlExWHdaOFIwdzZJbjIzVUhFektNYm9ocW8rVUc3?=
 =?utf-8?B?cFZBTUoyaWMvNzJVNTlCR01DOHJJUi9vNzcwbnorRjljNExSNkZXazByZ2Za?=
 =?utf-8?B?R3lnYmlnRktwZzBHczhKZGo5OUxHb0pkb1hBRTduREMvOU80VndvTzZzQ1hT?=
 =?utf-8?B?ZjlUdXNCQ3pYMzNVczlrdzE0d1dBaHM1WmZyaDBIdHZOcm5PcGZrcEVHRDVz?=
 =?utf-8?B?QTA4YlJtRDRSeXhEMTNBNjdLM2thOXNPcW14dVViWW9ISU9UT3MxM051Tmdr?=
 =?utf-8?B?ZlU4cDdJeFV3Q1grL3pSSmQ3MjVtRnZCNGtJbjJlelN1eWgrRmxadS8zMi9V?=
 =?utf-8?B?Zkh2N0hKN2t4aWQ3NjZ3RTdnU1dsUkxZZ1p0VXRvQ1NVNkRiNnZFclVSREl1?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: syjWMKN+xQy5wuRnqQ6mFX5wBWDYjiZxkRt8IzhKZcLpsdsYr1l4oiyA49237O4J3oDBBmjvVnIJZwy/ckZzTZsXiAzjs2nXOBMwJU51AmEYimUR2XQGOv8CfQiy+tIXHl2u50E7j9yLGIB/RYIKQ8DNtxAmKzkOC0MH/QQ8GLpm/aXoYdPAaRjmdHJPUYOKZw9QnepgesEW34JrUEUbFPrDWM7IH0NqA2Y9Th1JmyAOiUal7w1t/KHC0eetEPY7qOxzcMgLROyMcEMN0DLqbs3TVQEiIr3BTiRKLUEtjQ+T9UcCd0f+GLUebthLLKPe2ILJCC0TLtdJZKzmfiY68TaDQFnsI6sH5hTNIWHc3+O7cw2o6005nLqvw6dWPokBJbSOekY4zE2zc2PQb5HTzBQeUbLjl4RHuZJHOELrcWiVLeq3tzC2mw0YpVd6oYtx/jz6LgV92KNnKSSAtafgHRqGf0UESyoP43AgFf1qoT5VxJzESa8HW3MY84Shh41n3fW9Zos8R0usM/OK3ekupc5+nqYn80urpHkl+MzqbhGVL763ZZ5rOE4UqKO0kmrqQZsqaAM717DbfsuBZPMalPDd2TB2X/CIZG8Iql4Jz1dKP4wmSLaqQsEwkbsXPKUZqNtjTqnVuEHvvV6REMgRSQVTrSxDPxxJz+QiBcSQtQxOcJ+CrnH/MD2C/PB1fkpen6NtPnaWJ+fX6OesS3ST1rVO2VejMOdh44zQg9EeIvdLC9E+FgJMXTdhr+ygvvPpI48bcRMuF6WwqI38SPXNLQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6390d62f-e9e4-48af-c123-08da7a7dc048
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:09:34.2778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2p1TvXNMOn/cTaqkjdI85yn7vCh9wLjSVdcavzJrQor6Vi5ytL/rgpPIADw55hSD0+3UFgmm1y1DohPoJtmSkPiFl4Gt+EK8abrcPYUwigg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100008
X-Proofpoint-GUID: aqC8iHNOeJTomouxntxfsG0Bc346zDrx
X-Proofpoint-ORIG-GUID: aqC8iHNOeJTomouxntxfsG0Bc346zDrx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 11:45 -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:40:09PM -0700, Allison Henderson wrote:
> > This patch removes the parent pointer attribute during unlink
> > 
> > [bfoster: rebase, use VFS inode generation]
> > [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
> >            implemented xfs_attr_remove_parent]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c   |  2 +-
> >  fs/xfs/libxfs/xfs_attr.h   |  1 +
> >  fs/xfs/libxfs/xfs_parent.c | 15 +++++++++++++++
> >  fs/xfs/libxfs/xfs_parent.h |  3 +++
> >  fs/xfs/xfs_inode.c         | 29 +++++++++++++++++++++++------
> >  5 files changed, 43 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 0a458ea7051f..77513ff7e1ec 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -936,7 +936,7 @@ xfs_attr_defer_replace(
> >  }
> >  
> >  /* Removes an attribute for an inode as a deferred operation */
> > -static int
> > +int
> >  xfs_attr_defer_remove(
> >  	struct xfs_da_args	*args)
> >  {
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index b47417b5172f..2e11e5e83941 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -545,6 +545,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
> >  int xfs_attr_get_ilocked(struct xfs_da_args *args);
> >  int xfs_attr_get(struct xfs_da_args *args);
> >  int xfs_attr_defer_add(struct xfs_da_args *args);
> > +int xfs_attr_defer_remove(struct xfs_da_args *args);
> >  int xfs_attr_set(struct xfs_da_args *args);
> >  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
> >  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> > diff --git a/fs/xfs/libxfs/xfs_parent.c
> > b/fs/xfs/libxfs/xfs_parent.c
> > index 4ab531c77d7d..03f03f731d02 100644
> > --- a/fs/xfs/libxfs/xfs_parent.c
> > +++ b/fs/xfs/libxfs/xfs_parent.c
> > @@ -123,6 +123,21 @@ xfs_parent_defer_add(
> >  	return xfs_attr_defer_add(args);
> >  }
> >  
> > +int
> > +xfs_parent_defer_remove(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip,
> > +	struct xfs_parent_defer	*parent,
> > +	xfs_dir2_dataptr_t	diroffset)
> 
> Same suggestion about setting args->dp here instead of in
> xfs_parent_init.
Sure, that should be fine.

> 
> > +{
> > +	struct xfs_da_args	*args = &parent->args;
> > +
> > +	xfs_init_parent_name_rec(&parent->rec, ip, diroffset);
> > +	args->trans = tp;
> > +	args->hashval = xfs_da_hashname(args->name, args->namelen);
> > +	return xfs_attr_defer_remove(args);
> > +}
> > +
> >  void
> >  xfs_parent_cancel(
> >  	xfs_mount_t		*mp,
> > diff --git a/fs/xfs/libxfs/xfs_parent.h
> > b/fs/xfs/libxfs/xfs_parent.h
> > index 21a350b97ed5..67948f4b3834 100644
> > --- a/fs/xfs/libxfs/xfs_parent.h
> > +++ b/fs/xfs/libxfs/xfs_parent.h
> > @@ -29,6 +29,9 @@ int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t
> > *ip,
> >  int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_inode
> > *ip,
> >  			 struct xfs_parent_defer *parent,
> >  			 xfs_dir2_dataptr_t diroffset);
> > +int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode
> > *ip,
> > +			    struct xfs_parent_defer *parent,
> > +			    xfs_dir2_dataptr_t diroffset);
> >  void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer
> > *parent);
> >  
> >  #endif	/* __XFS_PARENT_H__ */
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 6e5deb0d42c4..69bb67f2a252 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2464,16 +2464,18 @@ xfs_iunpin_wait(
> >   */
> >  int
> >  xfs_remove(
> > -	xfs_inode_t             *dp,
> > +	struct xfs_inode	*dp,
> >  	struct xfs_name		*name,
> > -	xfs_inode_t		*ip)
> > +	struct xfs_inode	*ip)
> >  {
> > -	xfs_mount_t		*mp = dp->i_mount;
> > -	xfs_trans_t             *tp = NULL;
> > +	struct xfs_mount	*mp = dp->i_mount;
> > +	struct xfs_trans	*tp = NULL;
> >  	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
> >  	int			dontcare;
> >  	int                     error = 0;
> >  	uint			resblks;
> > +	xfs_dir2_dataptr_t	dir_offset;
> > +	struct xfs_parent_defer	*parent = NULL;
> >  
> >  	trace_xfs_remove(dp, name);
> >  
> > @@ -2488,6 +2490,12 @@ xfs_remove(
> >  	if (error)
> >  		goto std_return;
> >  
> > +	if (xfs_has_parent(mp)) {
> > +		error = xfs_parent_init(mp, ip, NULL, &parent);
> > +		if (error)
> > +			goto std_return;
> > +	}
> > +
> >  	/*
> >  	 * We try to get the real space reservation first, allowing for
> >  	 * directory btree deletion(s) implying possible bmap
> > insert(s).  If we
> > @@ -2504,7 +2512,7 @@ xfs_remove(
> >  			&tp, &dontcare);
> >  	if (error) {
> >  		ASSERT(error != -ENOSPC);
> > -		goto std_return;
> > +		goto drop_incompat;
> >  	}
> >  
> >  	/*
> > @@ -2558,12 +2566,18 @@ xfs_remove(
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > -	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks,
> > NULL);
> > +	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks,
> > &dir_offset);
> >  	if (error) {
> >  		ASSERT(error != -ENOENT);
> >  		goto out_trans_cancel;
> >  	}
> >  
> > +	if (xfs_has_parent(mp)) {
> > +		error = xfs_parent_defer_remove(tp, dp, parent,
> > dir_offset);
> 
> If it's safe to gate xfs_parent_cancel on "if (parent)" then can we
> avoid the atomic bit access by doing that here too?
Oh, sure, I likely just forgot to update that conditional.

> 
> Otherwise looks good here.
Thank you!

Allison

> 
> --D
> 
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> > +
> >  	/*
> >  	 * If this is a synchronous mount, make sure that the
> >  	 * remove transaction goes to disk before returning to
> > @@ -2588,6 +2602,9 @@ xfs_remove(
> >   out_unlock:
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> > + drop_incompat:
> > +	if (parent)
> > +		xfs_parent_cancel(mp, parent);
> >   std_return:
> >  	return error;
> >  }
> > -- 
> > 2.25.1
> > 

