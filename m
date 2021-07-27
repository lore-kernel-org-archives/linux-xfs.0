Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3A7C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5754661107
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhG0GTr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22848 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234905AbhG0GTq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:46 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HBxX010840
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=q2CMfftpmGPxHuqB+w5BhWqwd2nxZG90uCJoUVTE+5k=;
 b=L29G0FbzrRtT7lWbkjvR/yQxhiaT20wkE1UdTY1XDFwnR+1DzPHZb137186OUVkb4qFa
 0jxexJjvbmRiFQ80Cf1sSaLoJdT+LYGV77KflVJbce8SbzawPElNYc7qb2g1Caf9jpR3
 MsFeQliKbEX4yLelmu+W7IEQderUPMWWuOzQn2FZTDUBjEVowaKfjGn5ttjH13ZasCKt
 MPvjFDmEpyccZmsmnu8WwQXHqy3sZqm99eXK8ILyLxvypYKfzRImBUuNTm9K0FSw3Vqe
 B7tcndTzG9O+qIQUgEVGDPliHyGf2LIw6WddtLo5yc7Zs3UVum9vRtFE6qY9iTRvOXUh pA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=q2CMfftpmGPxHuqB+w5BhWqwd2nxZG90uCJoUVTE+5k=;
 b=b9vNN88IBiiRyOYoS4fR/Oleptxyz+8ZEgvx97UqYhUwsAcQJZh6cpaa0E+zSLNwy5ac
 to6mlad7w21rGbGiGLNZ5aY7YK1ZVRrfTpLUEsaUsCHP0UOrrI7fxVHdTGu1i3NKv9N1
 WFVZg8/altsgalX5d+Oquth9wbtCLsv6xwQ3RZtj7twpJlfKfmyQakL/xXy02hdY4CLY
 5vyPqkR/QPkN/ixsZ1NpOUjPC0T1lQuY5RwZ6dSPaeKmsZrgoF9BQuqx4cM/QfIc2r9d
 pnNYMv8fjE3wyjzMAh3a2IGIfgtyuRLWzvLej08Bvs1+xKJGDCsyKS68fHC/edMrD5FL +Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0v69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6Eia4065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvnq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGAJsdDkAhDXpyt4wJzky+aWOnPAarjVAunOv59xAPDs6IvLDGE/dySgyxEaW0Mpf6IBosm+im8SG1bKVYbR/VI9a/HOlAtf10TCt2Wc27713n87oo8sI1PDxCWIQL9HNKM7u89kR5KQVN87myAYe4PVDFrnWvtgamUsffYQygbl1KO1Yqo0a4RP+LhvrTEsaPHGVc26RbXY4IChO4oGdgt0wgnKUozltkJJFZ7WhUPdcAX6oszV+WhDeytRj1IqZTpHhn0gklUQnNFiaX58RRyaJ/mN9+zjmh+TmSLmBbrnkNjYqG4PiOS8ZbGlYrOXjkqLG0vXS8GS221RHxZk3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2CMfftpmGPxHuqB+w5BhWqwd2nxZG90uCJoUVTE+5k=;
 b=nft8DAmCGRbkbsCeAJWvglOwffERLClXGD9HmqzDMrWKcI8plvR9mWYcGBWnnIEO3W31wBL+Qi0C804C6feSyqISe1ppejzzTSVv6TcmROxg0JX9Ti31bnUQRDjR64DcuIN4LuThm/kNgm/K/9v0efxZ//w7KQpyazqaJJOeGjn41jjlXEC09QosAeaO89fIOUlWhBhcloHupR/jbP/8koXo9wz1qT/lDoRXsUnZd26TT+EK105xxzXwNaXsFkY1/KpqrkaRc96cuILZ4tOwaRywhbl3HbxBTN3MXXlv3/4K0ViBNeHkzKjA230+0XGSAFNLbUJjOgR3HpcACnOLow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2CMfftpmGPxHuqB+w5BhWqwd2nxZG90uCJoUVTE+5k=;
 b=kWZLFVzVhisctsB9F/JkW2rh+YThK5T3bewPVJqkvO3FDqu1nPCj4cGcC5LSSRneAsp23/y4p7oqrLDNHJoAImNc9PjsKsx1iR+Utb0cTlfYK/UtLb6/5uU/SJUhKpGkChUd/54hjLus/kg8Q+KbbdNi+LoYRsQFqyLnmCmpUJU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:39 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 00/27] Delayed Attributes
Date:   Mon, 26 Jul 2021 23:18:37 -0700
Message-Id: <20210727061904.11084-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9152dc9-d72f-4ce3-8c86-08d950c68371
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3669D024032F2F02D09A453095E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eFglhBjyYIkCv3/M80kktlw3JZ8nK1/Is8Gi+3838jBl/1F7eng5GdVZcZPvcHl4R3Z15xBFlt9uaotzOLmz/1cu26SvENG7lY/FH9HBMH39kti5bs9DlDSiFzukKSo64TZaOhMM4HzTWN2FrXrK1xsQliy2E6vaqMS+j5EEGjcuoPJxlS+Y7hfYOKiPNoD6gl209JBXsgXXsmns0XNHDfRRxq+PlDW4SrmT2ROoVZA9inmtBaLs6+XWHcebWze8EJTtHVPgrk73pZ4ohF9PmqxWAAu6q5CQkLTm3MSPiFdPiDilBR/1KJC0pTFDk5hFhoJUEsldRWfKtmMK6RrOABcga+cuGPJ6yW1JK2hPCxMeeXosMRCPEiMbkvToHLLPyt0K569DcViwHMbVjwoWdlLEy/Xnsn+jaqoeZUP5Dp84UEDLCo56v7mzwy3ZzwvgHT1LzPMYHcSxjxJvvrRw1iV3zLnH47Cll7dI+qhREdHUx2YDOdMyXF+28yAwJA9ZSwuC972HFX0994O+jrHYF+3vHSZ1bba/C6PwMh27/oGOOUQG2oqzA0iWXeCsVmEF1/jlY+10f72fAp5Adq/+cIfVhbUdoUSuPuZhhcZ7lU6IOc+Z+s5mVAvt4ZSQ5L++N4pAHDMbhZA7bUBvfqJeweo6lXPjzajsNVTftg17RSsivU92pSAMdlloeWbTazo7VXaQ1CZJclxkFk13R8JGBkQYoXG7ZkqxbFFvYo1G3yvEPQuvXH6urQ2rn3jGFDr3EOuLP0SpAcuIEHgl5YqSNPnYNyP7ohpcUCpxHPVXlabM+YY76/0xk4cPmp+ir4uO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(966005)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D7oD4k5g/24alEiT+dBWulyJmM4mDv4dF9QRzqypthj7G/p+icmYpr3+D677?=
 =?us-ascii?Q?TAZY61dsEk1kD38lGgTX8MxX9L6u4yzRLmkHPRg2qPcwLAA+IAebAsv3E1Z0?=
 =?us-ascii?Q?EBEhCmy3ApABjLsvv71OzWqfFo7ekH9Znd+313auKanyL6aLqKA7zaFH8S0U?=
 =?us-ascii?Q?XuASAI4hUaKUxBsV/RHTzhGbYtp5/Kw+3KDTUqnwfRkbFZr0PgH909T+oREt?=
 =?us-ascii?Q?jEluqqyPW2vxg9VSHRpO3vZuTNQUdmXRM/GUOtn/ArZ+LNshAEMoUzcDY7N0?=
 =?us-ascii?Q?oDCfFc5fWgEQuGcDjjuooBB+zJ17Pm6jqRB6vTBNTx2LU0d9EEXp/klc0LFo?=
 =?us-ascii?Q?Crwx+1mp7Qm0Z7nwkzVEdewZ6H0cbCPqNBuP+52is/mqDZ27V24PZbq3kIwr?=
 =?us-ascii?Q?3bdFxCs2NCMLoalYVimlJ83opxNnuNjNTA5cuLv5aP03oFIXygVF/vkTwv80?=
 =?us-ascii?Q?VVq/PrlDPdjwg7AsMKD5vbFUrXzF1VArqZcyPdCZGGb1zt6fp6JJpL6ffMW4?=
 =?us-ascii?Q?LxkdSw/T222KPAuuvrB96scQoKRegVqNa0RmZlKtGcKUxnNBLpSBZztUJXSF?=
 =?us-ascii?Q?AvbuyvVdab0MRMDEUwMIJTgSMWODRW18vHKKUllcxUkkiaAHhLO+sm6JFRMM?=
 =?us-ascii?Q?X9vPW1P39rfHgkASZkwpKTf5nQKK2Tvi9qQRlfUzXEBshilSa2OgBCkFhioc?=
 =?us-ascii?Q?RDylyUN3Hb9dhAY6xo4zaxeB3N/W97IraH8xGlVzaOEPolmyEbDcZf2+wJbE?=
 =?us-ascii?Q?PIjZwmE/i/SwWHH8vc1m/ykUfQea4Q7YvVUeRPoxfHThHJlY9RpEERTnRPLm?=
 =?us-ascii?Q?zEidnvXfO5MR2eSVb+oMS8BqSHbMrco/SysB0Xb0UBGF5ptdhXv2GmpB5UOT?=
 =?us-ascii?Q?mdlZzrlt92AietJ9jQBcaPDGgfBGKqbSvZXZaDY33b85UsuMEgYfU5LdSqPN?=
 =?us-ascii?Q?gF8b9UbQVOf6PU17jTCHq479+jlGz9ehiLd4LDzcIKcFjw2/Ow4+ijOzYOkb?=
 =?us-ascii?Q?jWCLqJAeAg15ljpnuM9bfOT9+Kudd7i1cN98pwvc7rVO9OWmLvWjAYclA09c?=
 =?us-ascii?Q?EcES3IQ+Exg/enSLGs6uCNZg0zn77Oa69P6XA9dNKbYsUWgmOVO06QDa5t9Z?=
 =?us-ascii?Q?tQwvCXnP8RtichhJetosYNYPEaiEUMR36VSFfxmCKFQScrJ0H6SEqkq4xjJZ?=
 =?us-ascii?Q?LPd0N8hZh+m8/aJ6ZzYZZFZtpOFI3rhiD/OfXF4J9YjuMzs6dIJU0pUBCb3x?=
 =?us-ascii?Q?wZ/K123uWm1Nk0R3txTuMUZ17g1fPvAJeJ7rKYrdDmFG1cbUGOvNBtRVLfOZ?=
 =?us-ascii?Q?xEK4pEXnjRpdN9tq6cnyla6n?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9152dc9-d72f-4ce3-8c86-08d950c68371
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:39.1058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Vp4hnzgsUDRoRiJbNMVHNA4crgwDT42truY7oVtS1FFcY0j01TeIUVMg6Au+be01FpJiwqL2G31zKBjA575U8NyLHHacay14I8pPDmBqX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: YZBWfMLYz1J5JzIMmvh3tJLKCy6BS1ZN
X-Proofpoint-GUID: YZBWfMLYz1J5JzIMmvh3tJLKCy6BS1ZN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set applies the corresponding changes for delayed attributes to
xfsprogs. I will pick up the reviews from the kernel side series and mirror
them here.  This set also includes some patches from the kernel side that have
not yet been ported. This set also includes patches needed for the user space
cli and log printing routines.

The last patch in this series is unique to the userspace code, and handles
printing the new log items.  This will be needed when the kernel side code goes
upstream since older versions will not recognise the new items.

This series can also be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v22

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v22_extended

Allison Collins (1):
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred

Allison Henderson (25):
  xfsprogs: Reverse apply 72b97ea40d
  xfsprogs: Add xfs_attr_node_remove_name
  xfsprogs: Refactor xfs_attr_set_shortform
  xfsprogs: Separate xfs_attr_node_addname and
    xfs_attr_node_addname_clear_incomplete
  xfsprogs: Add helper xfs_attr_node_addname_find_attr
  xfsprogs: Hoist xfs_attr_node_addname
  xfsprogs: Hoist xfs_attr_leaf_addname
  xfsprogs: Hoist node transaction handling
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines
  xfsprogs: Remove xfs_attr_rmtval_set
  xfsprogs: Clean up xfs_attr_node_addname_clear_incomplete
  xfsprogs: Fix default ASSERT in xfs_attr_set_iter
  xfsprogs: Make attr name schemes consistent
  xfsprogs: Return from xfs_attr_set_iter if there are no more rmtblks
    to process
  xfsprogs: Add state machine tracepoints
  xfsprogs: Rename __xfs_attr_rmtval_remove
  xfsprogs: Set up infrastructure for deferred attribute operations
  xfsprogs: Implement attr logging and replay
  RFC xfsprogs: Skip flip flags for delayed attrs
  xfsprogs: Remove unused xfs_attr_*_args
  xfsprogs: Add delayed attributes error tag
  xfsprogs: Merge xfs_delattr_context into xfs_attr_item
  xfsprogs: Add helper function xfs_attr_leaf_addname
  xfsprogs: Add log item printing for ATTRI and ATTRD

Darrick J. Wong (1):
  xfs: allow setting and clearing of log incompat feature flags

 include/libxfs.h         |   1 +
 include/xfs_trace.h      |   9 +-
 io/inject.c              |   1 +
 libxfs/defer_item.c      | 141 +++++++
 libxfs/libxfs_priv.h     |   5 +
 libxfs/xfs_attr.c        | 966 +++++++++++++++++++++++++++++------------------
 libxfs/xfs_attr.h        | 430 ++++++++++++++++++++-
 libxfs/xfs_attr_leaf.c   |   7 +-
 libxfs/xfs_attr_leaf.h   |   2 +-
 libxfs/xfs_attr_remote.c | 171 ++++-----
 libxfs/xfs_attr_remote.h |   8 +-
 libxfs/xfs_defer.c       |   1 +
 libxfs/xfs_defer.h       |   2 +
 libxfs/xfs_errortag.h    |   4 +-
 libxfs/xfs_format.h      |  25 +-
 libxfs/xfs_log_format.h  |  43 ++-
 logprint/log_misc.c      |  48 ++-
 logprint/log_print_all.c |  12 +
 logprint/log_redo.c      | 197 ++++++++++
 logprint/logprint.h      |  12 +
 20 files changed, 1596 insertions(+), 489 deletions(-)

-- 
2.7.4

