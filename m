Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A791C00140
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 05:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiHJFCH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Aug 2022 01:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiHJFCG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Aug 2022 01:02:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34D813DD1
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 22:02:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0F2AR009278;
        Wed, 10 Aug 2022 05:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=JLo02Lil+eT9ymC8JIGb3HWcYR7vrMO6mfuocxC2tM8=;
 b=pKu2Wg/y8e4NscWM9tlqVXLTeC8hOtzGVYS0xmWg3QYtQrKjdxBF+sx9WMc3QhAfaEfS
 XvUJZHCxIE3GFdKP7iowbN0dkf6qVB3cymAY4GM7Ec/UqGR9GzpDsulM5s6gx/NcZzG6
 VjYnV1rQfEgK4kzZ3a0yNV4Xab7LoGr8Kz3UAkR9wKcrWPHQY/aTv2oyt2msaNHOcICX
 Tv8ALmLByuavivkyeSXs/iWmHFYCtX4/5GGAx03fpRlMG3ndHyivoYsIP8IyLVervej7
 sDD0uUpnXyEo7NgWgJnkLr75GptSt3IBsdLuAg3jQ6f2Qv3FGwbab68OUFFcHlM3XGUg Jw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqdrtfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 05:01:56 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A4cOP3005261;
        Wed, 10 Aug 2022 05:01:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqha6vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 05:01:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCIXm6Gx/Qv05xQpMQNcuIFXXE/b4t2h0a3uB1EvUWmqiO8lVxAUBgx1gipB0Mk4PhcmcJZnzUVkdg9JchXgx6kCvd5MaZPM/wLyXuZb/0gVv8MldvcALxPQHbACkpkF14q9/m/5BltfTbFK3NEgz3ohwlPY7Le3CIwCpNOaly4+SvvEtbt68pQKNmrTp6ShoUIwzo9OFoEIA6bRWOEERyOlrA8U/VxjAWZK+76+fITXCgrt1K55rQBwsYEFt9qO6QnZ/pMhe6hw62XQeo0eaZTLN/d8Razg0AC3/CXI6Lzg0FP/1FjFshN1OzJLhuu86ujqPG50/94F4EcGnG5ECw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLo02Lil+eT9ymC8JIGb3HWcYR7vrMO6mfuocxC2tM8=;
 b=P5lNSEsbI1G/xaEapfMGZ8Ij9DU/dePb3yyMPI/kY7g5vqzYtpUTxacfdU6F03DTFXPJKeu8SsmfV7xGOByV5whXIeVeESrNcijonKQoOh3NfKp7D5PSofH1cGRUj/SMgUPzox6dUOYA0tBwZNM9CXrcHbDW6jlrB58YM/rzo5Uqk3CATPFXyo6Hd91s5NCvQjQ8IjZb94n+PFxvvvSZ3YCsq5L8ZSFD7J9v1+6VmaY8bkiRR+scQrPbOaJO4KMphKyK/R5859qQPdYDptVeyjABZ4mrdUgPJ2C5J2m7kodwIZT3LRPIrGC7mdxXO7VFX+ONtjAOFXDqDJ1d7CzOIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLo02Lil+eT9ymC8JIGb3HWcYR7vrMO6mfuocxC2tM8=;
 b=YrXlQvujjv5Es61KyBCAgmNs9bj9gn8Ad9ZtTSd3lQ8IuRdQRPdpQRBzpSWkW7AFtjxyrcyoMUWkFXKOhil8XbvT7rNJgK07ulh84YleWASrJRoUtNLDBbfbjSqBq+04CAiBA0xFqhNQsBZEOiBKrOaJyHIaZe4T4I5127E0S9Q=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3157.namprd10.prod.outlook.com (2603:10b6:a03:14f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 05:01:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 05:01:51 +0000
Message-ID: <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 22:01:49 -0700
In-Reply-To: <20220810015809.GK3600936@dread.disaster.area>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-2-allison.henderson@oracle.com>
         <YvKQ5+XotiXFDpTA@magnolia> <20220810015809.GK3600936@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42a4499a-3541-4f3e-9d15-08da7a8d700b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3157:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GjN5hR8jgxA1xeSUd4hJqIsiaCxRYXgsVh73RPmc6phgSTZQOuX4yuWoh3QP7M3MXw5SxPt1Nj6zZgWZXct3vc6ec1lJGhYZBsLl7pGQukOY8DyqUhIt4tyBRcDzzSXwFiuqKyKULvfkYR5/6HSpn7nu5mvNLegD+pDpCtmTjXB37L2efyUacGCXx/fpnaDVUI7SKsjOGrIaussoNECWwel30zQPGSysflxqYGyIEUd15ueIXGREmMgO+s5uufxVLMjmtCoQaqMrR8BQCG2D5T6Sz+22VcP/AF1kNiwl5hhRt4U1WqcrEFMfAJv6Gduz6o+Rq0W3vdZqKakzWvsKiNgLvLabAb8nJcPhmdYxaLTUPe9y7JFobiOxapTXZ9tI7qLwHQWeZxeqNnrFvTkJEQek2TnFHkLBUYK8j7rJOHtGMvz2yIq/O/PS7W5LXSROfscei4Y4Hg1AtX3J83TFhFj1+IzpWUTQRXxmwNUopfTcrAk52GGI+BJvtSCVOjgoj/D1cdH7sAQldxdLIUSthX43Vgq8l1OUfZRBL/M1gRSgiefjmPy09jneNByF0Rxv/m6ax9jPJWnvULjRNJNlGLSIITzV2g4Cms/1CvOHY0Xs4fMATTkbtCDIFtLNKjz5EM3JqXj4TJ8RuwwN9twaerX9E++0Z474a2j66HXhUAvJ62UfXf+az1tX/dnij/LwnfFEBmi6sjr/uO5TpCWWY059RhjvaGuLmimjyKRaJO4rbxlJbT6uy8lgCVpHU7h3ABFUvlcm0EyL0cTnRixPIAiMOjpKyP16gnbWZ+XEvXmxfqudCrlxl9cERJIcX4lFlU36tJvN2+AOi94f7w1c5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(136003)(346002)(39860400002)(26005)(6512007)(36756003)(52116002)(316002)(6506007)(966005)(38100700002)(38350700002)(6486002)(8676002)(4326008)(41300700001)(2906002)(478600001)(8936002)(5660300002)(2616005)(66556008)(66476007)(66946007)(110136005)(186003)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmM4bXZHM3NNMW5SbmNyeFlJclUvdml5Nmp0N3lLS2Jaek5yUm9TRm5aSlpS?=
 =?utf-8?B?NmVjRHUzNzlXZkprZ0gyMWUyNnpSYXB4Sks3TFRqZGt6MzV4STdCcWRmQXdl?=
 =?utf-8?B?NDlmMWNYLzNLQnNLR0hHdzd6RU1TWWxxQTJ3dUI0VjJibDl4ZEQ3UXBSTk81?=
 =?utf-8?B?UE1BRit4cCtrUWZISm1OZ2dpd0NZbVdmYlFBZEF6elhoMVVYcyt0OFN2dG11?=
 =?utf-8?B?ZHhNTzNkOUI4ZTNWZ2VxWldUSmg2YU9XWERKY1ZiMitEa0dTdHhCWmVuZVRz?=
 =?utf-8?B?OUtVNGtIdEpDQTlUZGVGMEd1WUhxcDIzbXhzbWNzeHQybjZ2bTAvMmFZWk9a?=
 =?utf-8?B?Y205d0FpbmxjS2ZEZVlwejVzT0pPRTA2Yld4N3BicjFVRlNaWXZkMXBSVi9q?=
 =?utf-8?B?OWVGc0hTSk0wT1FlR3RwWC9EcTZDRlMvaSt2dUtoN0lrSXB1QlpjSm5kSVJM?=
 =?utf-8?B?RC8zWC85dzlJbm9kUTYyaXQzM2k4QlJicDQxOFZHN0VlTU8xbU93eE1nOHlM?=
 =?utf-8?B?UC9Dd0dyVXFWL0s0YlJZOVpWMTErVDg5UWtJSTR1TlBUZklOWFdEb3dPaVFj?=
 =?utf-8?B?S3ZiVU1oODFSWDc0cjVRVjhYbk00RXhnbTNVS1RXV3JPalN1V2NOcGFFMVpp?=
 =?utf-8?B?TEZ0eFZVVkZpdk9icG1xS3ozN1pnRzR5RTVmUFFvUnoyVGNzM2FpREc4dWlP?=
 =?utf-8?B?ODYwV3JkS0YxZVlESjZoRVAvTE9NUndJUUdLV1FlYkpRUG54a29TWms2YTNE?=
 =?utf-8?B?TmxmK2Q5S2lGblZDcTR6OEVseUVUTDB0aFp2dFhXMU5ubVpWeFcrQnk1UHJj?=
 =?utf-8?B?U2hvTGN6c0NGYUN2cjNpdit3U1RtQnlUU1FvYjdLYm1WWW8yQ3VGL0EwL1dq?=
 =?utf-8?B?Y2VDeXFhb0VBM3dkeERia2dZQUdkbFd5cEprdmdndTV1UmdmL1IwYWg4UUd0?=
 =?utf-8?B?WlhZMUtLUGJncDFiME5laW9OVldaU2NzL1lRTy9DOU5wdzVmdWh3VFpjd2V1?=
 =?utf-8?B?NFMvZHNlOUQ2ZzNNTC9Wc2ZxMUhyMXA2cVo0YUFZWE1RNy9OWnR1YWJHZ3Za?=
 =?utf-8?B?T0pESnFoQ0JUb0EvVHl4UDBhZG50cUN4UnpaRUJRYTVRWm5TSXJsUm83VVp5?=
 =?utf-8?B?SGk3ZjZJY0pnc3RNRENJUDZUcU9OSDZURk5KR2Z6T3h6cmwrM25Ga0I2Nk5h?=
 =?utf-8?B?Sm9rVXZwbE4weUlMV05tUU55VytYb1BtamhKQmpRTXhmcHVzY3FUa20zd09r?=
 =?utf-8?B?VXVqZ2FqekNwSkpLcFdRU0c1bUMrMWFnUFMyNG1EVGt4UFJyT2FXRlNkQjRn?=
 =?utf-8?B?R29IL0F2MzVtMHB1ZTd5eWVKUUltSXdZbXBPaDJTbERkMEJFZkw0ZE5KUys2?=
 =?utf-8?B?LzhmcXpMVUVNbDVGcjRHVEZveHFrOERCaU4wMkJqS1VvZkdZUXpyYVJXZDhx?=
 =?utf-8?B?ZFRPcjN3MW5FbXBwcVhIdnJhVkp6T3BlOUcxeUd4YWU0ZXJJQUY1ZldoQVpr?=
 =?utf-8?B?bVF6czJxdDF0QldkeGhHT3RmQ1pQbG05TlEzK2hOZ1hyVVlSWTdFcFVNaFd3?=
 =?utf-8?B?TVc0SmJ4QldkZ0lDZnJsR2paN1NiMkVOaE5SWDg5eGg3TGN0ODZCK3M2TWEv?=
 =?utf-8?B?K3VKY2k1Ky9welZyaVg5Vlg5UU54dGJIaFMza1Erbjg1bnMwUThLUUhtcHdp?=
 =?utf-8?B?bUpCcDhRSnE0YkMvU1MxN3hLL1pjdlYvdnBTSWVGaVRLODBDK2JYMFF4c2kv?=
 =?utf-8?B?bEg5aFN0UzEwRlpDS25uU2MwczVadGh3R2h6MnZYd1IzT2t5Q3R4ajk4WHNt?=
 =?utf-8?B?YUdjUDFXM1N2UWg1aXozMWRxVklrc3RRemFpU3dSaUJNT0gyRTdaVGFjeTdp?=
 =?utf-8?B?YWJNMnQxZitYaHI5MjRJT2o0NXFJTS9xZnlpalFTNnlCdkxYbVBCK21LclhG?=
 =?utf-8?B?dmU5c0xTRm5WejNsSE04S090aFNwWkZEQThKNlV5eUtFVXZva1E4d2ptMXhJ?=
 =?utf-8?B?UnJHU2hyZTF2RDF1RnZxM0JZMnhkbHdraWJnNXdCVm5paExMK2g1TnJWOTdl?=
 =?utf-8?B?TW82eUMyRndSWGN2UzFTZ2lQRU1VL284cXRZUlZHd2hhZjNnTFdTWlFvTXkv?=
 =?utf-8?B?aVV3NU9obEpCOWJ4Tm1XdHdrRlYvSnU4UkVWQmNyQXc2VnpYYmp5MkFsUXQ1?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AJDamIbNIwF7Sfj1V5AkCZAkg6tG+N0CZbDyZ1cwj46OzmW3T9vnZshZWO4YImA9aJ7sPFz74J4OBRQNet4Ijc/SEaHlCQK87vY7OCv3Bx5O+6BRk/rXFOMox2Swfot2IwGVOJd8m8F+yMt8qcSYZ2+fvOndAKyeeyNWRAU72LCnusP39fsFj/h7f3DUnoTJpGYEihVNymACdl/luVxRxJpbiBga1l5BPdSDfdFaU4VXbYt6+18OHKhps+8a95VpIWAGu1vNNyec3hINa+jjUN5RNNaISLvu4E00Oja2EwB5e1WDZaqADoavzP9LwJRn6stTP4+FVnlQxCvkM2YEv2WSMHf1C6Pn0TbSeDTBkZI41iA4Q69OPusZIESrmMQGLufaB1NLgNFM4oRUCjVUTRFAoSryq92Wyu06zwcjylv1Zex+A5Kjo9Y9VI3L/EVOVDlVFu1tIuqNiX2KVaU9jFiZhca49gzGlgseqhjO9ZX9ZcIyzUwGqQuXZ/+5I/hbG0Fv8AyKLFWXXHJTFQmOSY79z5jeVVBfWeX4IkayRf4DcbTqK1t38SoUQoxoA8nM748ycOagFE23V9d5h8k896tv2sdXFVgv6VZ4HK9KlWUNbU/bzl4psDXARSY8OIM0ZJxwLESMcGNaajK+sQduysCzWagG1l4gU2SUApbJB4vzRIBmZ/7oTyZ9SyjpZhsXVc6zDhj+blgDiuO1W7ZqjuU+MJeJUT3quc37gTQYy9+lAXrUh/m5hrrfL6xNl72hO2cD5PQwbOyYPefr9Z40VE5d0tWLgpCUVRySQP1xuqcvOD3rCd4VN/vysXdx3zUR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a4499a-3541-4f3e-9d15-08da7a8d700b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 05:01:51.8257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rnjRzXUY92ra0nMqLZc65H0i9f5Lf4RjuiykJleu/qGBs0omVa7NDuoZvPQJI7pfSvzj/gvnEnuxRMCRT0Wrq8vlLGl3Oa27koU9UcGuC9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3157
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100015
X-Proofpoint-GUID: eJZjN2Dk5LawWOf-aX7Gcr_dCMIJAmaO
X-Proofpoint-ORIG-GUID: eJZjN2Dk5LawWOf-aX7Gcr_dCMIJAmaO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison Henderson wrote:
> > > Recent parent pointer testing has exposed a bug in the underlying
> > > attr replay.  A multi transaction replay currently performs a
> > > single step of the replay, then deferrs the rest if there is more
> > > to do.
> 
> Yup.
> 
> > > This causes race conditions with other attr replays that
> > > might be recovered before the remaining deferred work has had a
> > > chance to finish.
> 
> What other attr replays are we racing against?  There can only be
> one incomplete attr item intent/done chain per inode present in log
> recovery, right?
No, a rename queues up a set and remove before committing the
transaction.  One for the new parent pointer, and another to remove the
old one.  It cant be an attr replace because technically the names are
different.

So the recovered set grows the leaf, and returns the egain, then rest
gets capture committed.  Next up is the recovered remove which pulls
out the fork, which causes problems when the rest of the set operation
resumes as a deferred operation.  Here is the link to the original
discussion, it was quite a while ago:

https://lore.kernel.org/all/Yrzw9F5aGsaldrmR@magnolia/

I hope that helps?
Allison

> 
> > > This can lead to interleaved set and remove
> > > operations that may clobber the attribute fork.  Fix this by
> > > deferring all work for any attribute operation.
> 
> Which means this should be an impossible situation.
> 
> That is, if we crash before the final attrd DONE intent is written
> to the log, it means that new attr intents for modifications made
> *after* the current attr modification was completed will not be
> present in the log. We have strict ordering of committed operations
> in the journal, hence an operation on an inode has an incomplete
> intent *must* be the last operation and the *only* incomplete intent
> that is found in the journal for that inode.
> 
> Hence from an operational ordering persepective, this explanation
> for issue being seen doesn't make any sense to me.  If there are
> multiple incomplete attri intents then we've either got a runtime
> journalling problem (a white-out issue? failing to relog the inode
> in each new intent?) or a log recovery problem (failing to match
> intent-done pairs correctly?), not a recovery deferral issue.
> 
> Hence I think we're still looking for the root cause of this
> problem...
> 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/xfs_attr_item.c | 35 ++++++++---------------------------
> > >  1 file changed, 8 insertions(+), 27 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > > index 5077a7ad5646..c13d724a3e13 100644
> > > --- a/fs/xfs/xfs_attr_item.c
> > > +++ b/fs/xfs/xfs_attr_item.c
> > > @@ -635,52 +635,33 @@ xfs_attri_item_recover(
> > >  		break;
> > >  	case XFS_ATTRI_OP_FLAGS_REMOVE:
> > >  		if (!xfs_inode_hasattr(args->dp))
> > > -			goto out;
> > > +			return 0;
> > >  		attr->xattri_dela_state =
> > > xfs_attr_init_remove_state(args);
> > >  		break;
> > >  	default:
> > >  		ASSERT(0);
> > > -		error = -EFSCORRUPTED;
> > > -		goto out;
> > > +		return -EFSCORRUPTED;
> > >  	}
> > >  
> > >  	xfs_init_attr_trans(args, &tres, &total);
> > >  	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE,
> > > &tp);
> > >  	if (error)
> > > -		goto out;
> > > +		return error;
> > >  
> > >  	args->trans = tp;
> > >  	done_item = xfs_trans_get_attrd(tp, attrip);
> > > +	args->trans->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
> > > +	set_bit(XFS_LI_DIRTY, &done_item->attrd_item.li_flags);
> > >  
> > >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > >  	xfs_trans_ijoin(tp, ip, 0);
> > >  
> > > -	error = xfs_xattri_finish_update(attr, done_item);
> > > -	if (error == -EAGAIN) {
> > > -		/*
> > > -		 * There's more work to do, so add the intent item to
> > > this
> > > -		 * transaction so that we can continue it later.
> > > -		 */
> > > -		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr-
> > > >xattri_list);
> > > -		error = xfs_defer_ops_capture_and_commit(tp,
> > > capture_list);
> > > -		if (error)
> > > -			goto out_unlock;
> > > -
> > > -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > -		xfs_irele(ip);
> > > -		return 0;
> > > -	}
> > > -	if (error) {
> > > -		xfs_trans_cancel(tp);
> > > -		goto out_unlock;
> > > -	}
> > > -
> > > +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
> > 
> > This seems a little convoluted to me.  Maybe?  Maybe not?
> > 
> > 1. Log recovery recreates an incore xfs_attri_log_item from what it
> > finds in the log.
> > 
> > 2. This function then logs an xattrd for the recovered xattri item.
> > 
> > 3. Then it creates a new xfs_attr_intent to complete the operation.
> > 
> > 4. Finally, it calls xfs_defer_ops_capture_and_commit, which logs a
> > new
> > xattri for the intent created in step 3 and also commits the xattrd
> > for
> > the first xattri.
> > 
> > IOWs, the only difference between before and after is that we're
> > not
> > advancing one more step through the state machine as part of log
> > recovery.  From the perspective of the log, the recovery function
> > merely
> > replaces the recovered xattri log item with a new one.
> > 
> > Why can't we just attach the recovered xattri to the
> > xfs_defer_pending
> > that is created to point to the xfs_attr_intent that's created in
> > step
> > 3, and skip the xattrd?
> 
> Remember that attribute intents are different to all other intent
> types that we have. The existing extent based intents define a
> single indepedent operation that needs to be performed, and each
> step of the intent chain is completely independent of the previous
> step in the chain.  e.g. removing the extent from the rmap btree is
> completely independent of removing it from the inode bmap btree -
> all that matters is that the removal from the bmbt happens first.
> The rmapbt removal can happen at any time after than, and is
> completely independent of any other bmbt or rmapbt operation.
> Similarly, the EFI can processed independently of all bmapbt and
> rmapbt modifications, it just has to happen after those
> modifications are done.
> 
> Hence if we crash during recovery, we can just restart from
> where-ever we got to in the middle of the intent chains and not have
> to care at all.  IOWs, eventual consistency works with these chains
> because there is no dependencies between each step of the intent
> chain and each step is completely independent of the other steps.
> 
> Attribute intent chains are completely different. They link steps in
> a state machine together in a non-trivial, highly dependent chain.
> We can't just restart the chain in the middle like we can for the
> BUI->RUI->CUI->EFI chain because the on-disk attribute is in an
> unknown state and recovering that exact state is .... complex.
> 
> Hence the the first step of recovery is to return the attribute we
> are trying to modify back to a known state. That means we have to
> perform a removal of any existing attribute under that name first.
> Hence this first step should be replacing the existing attr intent
> with the intent that defines the recovery operation we are going to
> perform.
> 
> That means we need to translate set to replace so that cleanup is
> run first, replace needs to clean up the attr under that name
> regardless of whether it has the incomplete bit set on it or not.
> Remove is the only operation that runs the same as at runtime, as
> cleanup for remove is just repeating the remove operation from
> scratch.
> 
> > I /think/ the answer to that question is that we might need to move
> > the
> > log tail forward to free enough log space to finish the intent
> > items, so
> > creating the extra xattrd/xattri (a) avoid the complexity of
> > submitting
> > an incore intent item *and* a log intent item to the defer ops
> > machinery; and (b) avoid livelocks in log recovery.  Therefore, we
> > actually need to do it this way.
> 
> We really need the initial operation to rewrite the intent to match
> the recovery operation we are going to perform. Everything else is
> secondary.
> 
> Cheers,
> 
> Dave.

