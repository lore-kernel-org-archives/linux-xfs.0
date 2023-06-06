Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A29BC7EE2C
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbjFFJ2q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237470AbjFFJ2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:28:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A0AE6A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:28:38 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3565YZes017868;
        Tue, 6 Jun 2023 09:28:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=TngIA29w4KnykqU5LYjYKBd1S39EnsBxVDX383DIKjY=;
 b=WpTZSKB89sJZ7WWos7rbJGAQRDuRegV4j+cUouL6IYt8xpWxBikoWHx+U2jIUyp2rChh
 RXFl1A2mOpHEjRHT7d3GLpBzqBqCKt3DwP6O45BwbQ762lr+9hPfZJ0mauIuVWi9fcp1
 5DfcgICtCZtDgeJfREnVkkr1FWPLRJvFbkVFOgaN1j7A92CcEQrDarBwLdXCLIiXGPky
 GGNkIkdzlYCSVKBmviAaMIUaoXGH6r8GCCtw233FPf6aw7p3aLbA1eP1Cd1pqvVK+kMl
 q0gGCUDmJ3qhx1ZCE0lzvNdITgZ7tnZIPRkm/v4svcMGVGRiGZwPYiu/KcM2Pamny/d+ NA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2c511k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:28:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3569DBXN024065;
        Tue, 6 Jun 2023 09:28:33 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tkgvbu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:28:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cX8VFMuOOy510u7rZfb5PS3KM8GR7hmyfangjY5lFG98/1Uj7YLLc+1NG+1J4TyXl5kRBLDCdmVPFk4DyrWXB7evASHsKCZ1xbEy5cRKwf+paDH0zptR2+GBW7dBx4HNKCAsH5pIiATMk64keYJQgzoKZ5FR+beLyQE/xy5ZN0CL6UCz2f7l2o4nCDf6ls/YTYesMYKEx7kBQc4FKxYvv7XR3maTIbYsTgosomF6E8V+XSWCuhCXrsOK0+ZbXmsnlfySDSAKNyQsDZ+EKQmse4mQY3zjMQ0q3tgTUVOWimr14QRyDA0gSDGQdGN/eSl4bclHM6/nAB+eUozCN5ByGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TngIA29w4KnykqU5LYjYKBd1S39EnsBxVDX383DIKjY=;
 b=ah1KQPwUFdwYdlsj5MJdR9DkBSb2MujDXzReXVU4WDz760FCuFWyDwSkCLyYiyp7+0V6ufd9NKzD9lEJFtYyA0Szk2y8v4RfHR+XCO0baz9LBcYXc9hczNIoXV9l9lVVkY1q7dDoKmqXuGODXIK0FzoNqcMASqvLOsVw9UiJy0PjBBjsCmOxAvGKrv6T1Q7MX1wMMGIXMlaS8VCvaccPhWH0C1AnOxxzHVSfrlQH91xe8QfOQy0ZrZfobeYmM7ywpJVcvKNOEfNcyutYDp9wRv0oB8AAZysUrs1lp4zqJzqnH8p1Rdbb1zInzmEMSvaBzjYL8gc5DzNrZiA62KitLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TngIA29w4KnykqU5LYjYKBd1S39EnsBxVDX383DIKjY=;
 b=rVuTGqGIWTGaCIyGyuCEbY0QVygwc6gUjZGom32Md1QDZk7m8Ctub0UALa4jijoLqrtQhpOUfoNDBJTHAifqEX2QIjxlD7fPsAI83xJbuQ1cCTSiMq9h1dx4+/XW6qrKezh4jt/6Nscsvo236RmynbgiCtcl+Xs7Hir08BvBoSY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4781.namprd10.prod.outlook.com (2603:10b6:a03:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:28:21 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:28:21 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 00/23] Metadump v2
Date:   Tue,  6 Jun 2023 14:57:43 +0530
Message-Id: <20230606092806.1604491-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0012.apcprd06.prod.outlook.com
 (2603:1096:4:186::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4781:EE_
X-MS-Office365-Filtering-Correlation-Id: efdf575a-e812-41b5-a9cf-08db66705eac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q3GvBCWztwAv/GC7YpV46/2nM+1ngGVIqcS2oNKjtHyGFPSOUrlVFRLc+aFa1PE0H1Z6GSFVm46cWcP/bHIpvEancPRZAYqlYxhlWThRDc3AIRIh5JCBJ/fD7UuRZNm+CKOIMPQ5gVm8H4ckoKXRr2Ris/a0GEvZrNZlwPFrYfJAeU6yK6Q1znUJysuVUB5RmC187lVodyiIjqvZ8U50G381o2DBvBpre2U98UNz0e10DN+4PCkm9ew8LxVlSYfCRTa+AqAOrTeaI47jMTb2hFieG3zn1zm3KKJxZjmhyqlA9OtfB8ZlzERrWeyhDcMLlOV5t2z+TlBhEs1nH8eoHM9U7XD/BFg50pFeKYTpPA0p14EUZBGIdp5TWIJbNlAh+CvxyrtQPGJ2nEUJmqZ8yzvm6Mqj3tC6oyhj8SdnBJOOrFfbMFCxxM28flpSyJCC80UJj42bGOPBVVDxDzzEn2VSPktOgABvvgHVEsHxZqD1WNLa9ia3dMTiS1olY3WXKfHbS0Hqg/QgPE3IMdvf5anWI4T6UhUIx9E+GmmWuFlccoyAqpo5COhRZwMrIH0UMUADNeU2yn9MoH2CNgh+ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199021)(5660300002)(8676002)(8936002)(66556008)(66476007)(66946007)(4326008)(6916009)(316002)(41300700001)(2906002)(478600001)(38100700002)(6506007)(1076003)(26005)(6512007)(86362001)(36756003)(6486002)(966005)(2616005)(186003)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a/u++97O50fkOb8kgYxeo1j52oxU16CE2TbEH6yhbp8JS/5RYH7+46sFB7ON?=
 =?us-ascii?Q?ceYd9jbAlY99zl5omM3TOOZYJ0z6itroD9/FvqugdpcmPC+bIDiM0T2mYFEL?=
 =?us-ascii?Q?0I9XUh8DSmhrA4EwZ+DQESWJJMN2TqkBt5+XNl739pvWgOqeerkRxLZPKpPR?=
 =?us-ascii?Q?bN0C7PjyvOzt9H8rNKnlDPfknfJPTLKSxylBQ+VHLNpLTjmP0Famz/0yi4MH?=
 =?us-ascii?Q?Ma61Sj/L66Rm3nnWMzByqoVIKgD+vNh4OkSBQwEzs1X/HGTlMUq8iDiQKgdC?=
 =?us-ascii?Q?KVMY1MCyTXqVYj/ZM+25PU6RdIohD7Kmxms3lCmpHQwnG6tuYKdFiVcebYx7?=
 =?us-ascii?Q?Bk/8+iknE+erbSRBHluwRx9pks/Sk5E4E2Sn/DAkd5GzAL3sKfwrGvFsCOdM?=
 =?us-ascii?Q?TXKESdtergfLXkPtuv6kJ27+DcPKJskIOWGHWmeTGFoPdN+U7BNLrosGThcq?=
 =?us-ascii?Q?O5bIZxgCcfR2v2uUXBlQDHQRO428K2RKECTG/1u6kKDxbbj2GkvlNMLK/3xJ?=
 =?us-ascii?Q?/f2HRaBVsGpWcCeHaJV2OtGQAlMO6SF7cJs7DvJ1Scwlxd99Pqd/uGHvcTUc?=
 =?us-ascii?Q?MVIeO9VRdU0wujWNBN/JDNixY6XAUC+uJ8Kfmrfq49PzIn2Q/AmlS7LA86uY?=
 =?us-ascii?Q?QBtPcylByV8ztbUgYnh2IotjTxmeWyiHuIC0N0ALzPvhtKI7UDwjMhdfgFZE?=
 =?us-ascii?Q?2QS25D+KKiFocmQa2sMCZWJfUI/Tcx2cWaO8Km0gG1PGW7JBP1aeNawbwW3Q?=
 =?us-ascii?Q?vsUVSP8P2javSF1zZqm3zadkIDeWOPZXLTlyErbdwpXS9gg9lXZd8wkOY0Yy?=
 =?us-ascii?Q?sVdbu+26VBPb6ttbTAshqxRx/3+7i1/jNvC4OS5gRFrU6u4644qFKIESqx2U?=
 =?us-ascii?Q?dpVsj9qhwSCSWCzJ/bX96G5C4a/zQHNscD1yGtzl7tsJTQAJXvHAvTaAIosP?=
 =?us-ascii?Q?DwsHlnQh+o5FxzDT/SZzgSxE17BbXAfkBlPs+XAKZHe8vMG1s3AKVNSEFLyk?=
 =?us-ascii?Q?sLcz+5eMjG1+EZelSYuDN7qdNo7DAGKfByGGYuDir8gNwmFyCd68oDoz3yWU?=
 =?us-ascii?Q?cDi9MjkzJmbJ98CbsgKmYMWorhnejRHePW6qItQ3nh4X9x0XxGezgLr7caWM?=
 =?us-ascii?Q?yB1whXyq4GaHV6W585ZnghUevp0KdnpkWVswEMfbJTVZl84nJlkhrAuuOThD?=
 =?us-ascii?Q?xW12AvmXFSPbM2IM5aDkZ2hAYeJHNcrChg8347lg/nzrJ1eEh5csJ8emsrGX?=
 =?us-ascii?Q?+ww1v6ymh+8xBm45OKGRu4NDFEA4dTzLQdmxgfGehZ4YtTTEBwy6leALjvvJ?=
 =?us-ascii?Q?Yhy86RsJeDpbO9oe+ECBpj64qNbFS/WV9K8AgF8oKipk4w74N1DLO7OqXoyx?=
 =?us-ascii?Q?uYCwltiDNf8Ta/oX3Ts7kSnzJPhvy3KV1PiLD/jKRd5PEiVPlguY7HX1RlQK?=
 =?us-ascii?Q?TR4L3jDmP7HlhBGNeHyGt+CQt3F7v3jh5DHR7N9mwAi7R3HNW690dF+bliJF?=
 =?us-ascii?Q?OhZJaPhRWFIOLolXJxIiw6BxeQFSnxW0Vd1miIa8q43ZN/tzDvGQ5gIEZieb?=
 =?us-ascii?Q?2kyjd1xr+TQdc4rV1BvlGvHoQQJe9f7nSvcs08RF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VTClQcNW+sJ5ZguvxfTehqJVLUA2i/98l/DiZBRPuKcwgsN100mcf0f7i9+Q7VLX3+ucFoWqQJaKqnVJPcKLRIspU7YwXxbWOuBliWqM+MhZ43/W6GcXID53+0CoT9UUlCYPEmX5fVbNbGHBoMWD7HsWkO5c9+suXlN1xrGjJ2JtGb/wS7uJ8uG1YnMggqQvJcRwj6tx8ed/p0R1esG4qLs9PPm2qq++2/9GIQI3udNQBnhoQb523xU1J0BZaBsOCFIndLWT0QqbItRjEjmFKhFwVZW4MPx7Nk5C1mtvitSIdkPNbGmz28+L1ENfdNELVDx62K8+H/WcU5AYgOD67NUb0V/c7qy8YI6LUFQxtTmYH1qazsEmsqCvvlqkLrYXFZ5oSyCtW/E4dZv8rq2PDKVI0lxci2YdL1Z1bSfxL4+li1hEeQ0icBiNPzQNZ8wDnIJQ9wwyX7KwJtdXj0L3Fufx/NPqZLwy/R4ivQqNtOx7suXvKzbIOimZgfXFF7HGMOK1YT3hrIH8iFc+o6H8BnbXUoB75g0ZKkoK4vbyvcgWZ811xAsCl5iLOsIXBkhR37ccgXTx93HAdPV3l/sUfz2BIyXaH2hUZH7XyxoxoTPrBfsDFrrHhT4BF2A3GFjwPWbpIVyaJ6i8QuXoPZBoW7PUgp/2GWNvbaAA9wGIKhVxCGk1/arVqmDEaKBDw7cfQMCoi6E/idpWUWqQtlZAQbTCwxgT+AaQ7hU0QpZwElc7NWn5/OPKllgXjyg2Jontfv5jPqOXxkSaCvStc85iOPdRnwBk3r5e5welPgHFrmA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efdf575a-e812-41b5-a9cf-08db66705eac
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:28:21.4727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/HVPhZ4SGBzh11zhOiwCoR34GC7P+NUOR/28xAvQSf2YFufuPXfSJrG394bTbCVkBYTpfkXduQ+tOLVlLZ9+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: 1J5TV6a8E-ION-WFh7jljMKJPK9pRSKL
X-Proofpoint-GUID: 1J5TV6a8E-ION-WFh7jljMKJPK9pRSKL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series extends metadump/mdrestore tools to be able to dump
and restore contents of an external log device. It also adds the
ability to copy larger blocks (e.g. 4096 bytes instead of 512 bytes)
into the metadump file. These objectives are accomplished by
introducing a new metadump file format.

I have tested the patchset by extending metadump/mdrestore tests in
fstests to cover the newly introduced metadump v2 format. The tests
can be found at
https://github.com/chandanr/xfstests/commits/metadump-v2.

The patch series can also be obtained from
https://github.com/chandanr/xfsprogs-dev/commits/metadump-v2.

Changelog:
V1 -> V2:
  1. Introduce the new incompat flag XFS_MD2_INCOMPAT_EXTERNALLOG to
     indicate that the metadump file contains data obtained from an
     external log.
  2. Interpret bits 54 and 55 of xfs_meta_extent.xme_addr as a counter
     such that 00 maps to the data device and 01 maps to the log
     device.
  3. Define the new function set_log_cur() to read from
     internal/external log device. This allows us to continue using
     TYP_LOG to read from both internal and external log.
  4. In order to support reading metadump from a pipe, mdrestore now
     reads the first four bytes of the header to determine the
     metadump version rather than reading the entire header in a
     single call to fread().
  5. Add an ASCII diagram to describe metadump v2's ondisk layout in
     xfs_metadump.h.
  6. Update metadump's man page to indicate that metadump in v2 format
     is generated by default if the filesystem has an external log and
     the metadump version to use is not explicitly mentioned on the
     command line.
  7. Remove '_metadump' suffix from function pointer names in "struct
     metadump_ops".
  8. Use xfs_daddr_t type for declaring variables containing disk
     offset value.
  9. Use bool type rather than int for variables holding a boolean
     value.
  11. Remove unnecessary whitespace.




Chandan Babu R (23):
  metadump: Use boolean values true/false instead of 1/0
  mdrestore: Fix logic used to check if target device is large enough
  metadump: Declare boolean variables with bool type
  metadump: Define and use struct metadump
  metadump: Add initialization and release functions
  metadump: Postpone invocation of init_metadump()
  metadump: Introduce struct metadump_ops
  metadump: Introduce metadump v1 operations
  metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
  metadump: Define metadump v2 ondisk format structures and macros
  metadump: Define metadump ops for v2 format
  xfs_db: Add support to read from external log device
  metadump: Add support for passing version option
  mdrestore: Declare boolean variables with bool type
  mdrestore: Define and use struct mdrestore
  mdrestore: Detect metadump v1 magic before reading the header
  mdrestore: Add open_device(), read_header() and show_info() functions
  mdrestore: Introduce struct mdrestore_ops
  mdrestore: Replace metadump header pointer argument with generic
    pointer type
  mdrestore: Introduce mdrestore v1 operations
  mdrestore: Extract target device size verification into a function
  mdrestore: Define mdrestore ops for v2 format
  mdrestore: Add support for passing log device as an argument

 db/io.c                   |  57 ++-
 db/io.h                   |   2 +
 db/metadump.c             | 749 +++++++++++++++++++++++---------------
 db/xfs_metadump.sh        |   3 +-
 include/xfs_metadump.h    |  60 ++-
 man/man8/xfs_mdrestore.8  |   8 +
 man/man8/xfs_metadump.8   |  14 +
 mdrestore/xfs_mdrestore.c | 497 +++++++++++++++++++------
 8 files changed, 985 insertions(+), 405 deletions(-)

-- 
2.39.1

