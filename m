Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E564C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbiCAKk7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiCAKk6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:40:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443B98302B
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:18 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2218UkhT018833;
        Tue, 1 Mar 2022 10:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=2e4letPu/8X48bk2LnFYZ85vi0veWBapY+gWpBAvNIU=;
 b=SyhLFDBoD8ZKzSbgbxKYgiBMdxBGt3KMMN9dWseRSxwkSe/LFNev4ULFeBS45TSRrTf9
 Xc2rGize24+edkDip3fDq1H3cln901qMYPlqez1MSXuEMxfv0M3sYkVO1c/TWqADLeXi
 2osWlTvp9JhhqPc+WmkqV0Yrx9KF09z3SZF2ngd3UwANw0e6K9syj5SUl2zk/9khXPi+
 DzIgfVERVblUqqyW1kt+i/gEwDMtIUcGmCS5gxbRHTffbabExfXNbkOzv13RDdlm7x92
 WWXlUc37fwEUXUUY5hsT6TbMJmt4dQTWH/2NbwTMUdBNi4OCU7bxpQfKfPWQ2yfpcpev Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15ajak9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221Aa54g030205;
        Tue, 1 Mar 2022 10:40:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3ef9awyrg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FK6kLPiWwLNGcrw5wj4+kx06dvOkUsAju+m7o4J/YMDaZ0BN+Ye+fiwESjdWZC1YXl0FSmJ7JZMT1WVpf6ozG7LiZRO1tu/96R3/CmNLWD/P8x3ZFnv27GbWU9wAhxGxrdxIOg8HZrbiJWJKTgEhR7qzts3JxiolQ1KdVHGnMfzbm3a/FCXBC1n1QIsmlr0xARg4JCOlV2F5hmO51ewkMLOBLfIIZ3z/e9qg1OSbHEG10zSNG7yDkvoKATPlhq5nezikBSngZ5Bi6t8d+dmubCDPQcYMz+HCYnv/Mpd3AQO+uFDIdk2StPmPbtFk8yGzuPY3+E4RzynMbBNS9Igs8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2e4letPu/8X48bk2LnFYZ85vi0veWBapY+gWpBAvNIU=;
 b=mDeQHh99AkdPfUPG+wKPt/GgoiYbRNFGeGIpNKxXU1QJX/w5Dk89ZY/ZFB2i2hHiOmlaWHE1yC08ZazeVGppd8cheqRxzho8pXqyblzlKAAhEuYIoy1D8o7epdKM0p0bCPLUvG5j+tKLN6SPZ988cRF363eqpHWp7ERdGKA/MUw4Snlrnd7reeW7C1x/VLtMAYF6UX0XsrQSq634r3NcZbh0bcyd45pZpN157klk1pAiVr2kxV0Aj6uO24A1q5Idu7o+J2hMepy7B4h84lt3dTnELvZvQonKT3kbRNzaEXGa+20MwGvrXzshbELiJ4u/H0utFaNqnlzOLMwTAMKrWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2e4letPu/8X48bk2LnFYZ85vi0veWBapY+gWpBAvNIU=;
 b=bgWqNMLQJGOHNhczRiHWN2zSXaqPONTE1maKKZigYWpYxtygEHHJeVewyl8FALt0R+rOGQfWgSXwkiIIwdqFvEHnZ/aA9E+qsSPb/eK/8JFPmC/tcGYj8QHYkxANSktvcErlaHMFLvbopK6U7RwqRGXyrN7WhEdc6jkIhugYyug=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:11 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 05/17] xfs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
Date:   Tue,  1 Mar 2022 16:09:26 +0530
Message-Id: <20220301103938.1106808-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a9f8d02-512b-479d-cbe3-08d9fb6fdc97
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB416055F18E9BAC46AB34B38CF6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MYIYo5kZHolmjGjOQMOGu7TLHbnWl5vJrbn5PG+0zRkJAq1yCVb60FLKfQP7zjir9lDnf2QHq44u0ojNUGGuBhfXX+Uh1YQdRl6cPj+2ylFy2MavTzD5awD/2BvQW5CG8Tivzt0hPsZ+JBpERJk9LLR3H2ugvSrtXMXFBQtbLI//fXnX5N4BT8XiL1PNusn2D62HNK9Jmpr2Di0uez6p9zMtwSBEYGKQJwDOz924Zu5ETHtCwUEhJoCngiryJzNafu1eBRnSw793IUKWneh29UgZYk6CkSpVQ8msS4LXRPW39w+F2/QeTlx+q+CuE+xKDXYR+VZrtTPKApwdqTeZsTcPUe39kzGOsaUE1dwhG7a/ud2LKW6VL7IhiISo4SYdzDXjsyDTmh4WSxIpjNjIzdXw6fYzfXIjP4+EVwEmsekIG8YKtM0T2v+V26grQaSMBvp5OGAvc8yy4/Cn4ulshc23njMeWMckt97MWdELG+/9FJBRh8Ij5wdvCb8dp19LJ//5oJWgJ+/TSmaitbpkhC9k/3fiGpjIHSzDkI7pPycN3QEQByx1dCPK4ELzvXbElxl4Jawh8rJQ2mls56JfmWv7eN5U+Q/oQwb/cKOtlPfzT+Jk45pr4gjtocAma+HNWZm+3pibxjKRGIJE9pwvJJbeuvNHqBVTGn8zMiM/kawrdUeuHxGkZRiu73MuoAgOgXKX3sqPT8ui/AW7Q80rsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ROaJ0x2jrUUVd2434gb8KCw9r5BPq/8hG/zXweCQa1kn+ocsIek55DJJaRCF?=
 =?us-ascii?Q?hpTN3kq7HLs8gSlFwD9S679Qfw08OnFpAf/oz2mOe35hYY55R1Cye965ynUb?=
 =?us-ascii?Q?MtXzMaahjlh9uYh3Ey4aRJ1X4GxhzKXhhVX5HgxRV65nQyx5CxD3SwuQSExg?=
 =?us-ascii?Q?paMkEehy0HUNlXG5E+JbPePRhCEYdvmy7/HOls3wgLmrgTt6VPrVG+OUYYH2?=
 =?us-ascii?Q?ZHOKsGnSHqFsnsG6cxOVC8yJDTETvI5n8R0b02Oso7dG5TGe8p97ELTItj5C?=
 =?us-ascii?Q?moAG83nkWIXEx1qk9gZNbN4svR5e1+nA80ye85G4ZMXLNz+bcjeXnEl6IgNV?=
 =?us-ascii?Q?JOyHquu3NO8pRjpVunqnkY5rh5a1wHT+0jUoGWiStw3GEo0DhovRy7quAhzG?=
 =?us-ascii?Q?M25KRRKWrkdPyl4XL1+ncAWJaCovFBTjFwMvP/EYZwURh5hFQruQlPycod/m?=
 =?us-ascii?Q?GilXHeSj4hjibY4OJil83o7SSWQPw+wTYiqrxWH4LyRUPEolZatjURs/BQeL?=
 =?us-ascii?Q?CUQeceGzK/MfdgN+DuB7tlqDpI2+qEcejymwyetKwTvClnGAKnl9P3SxEWRI?=
 =?us-ascii?Q?vRDqNVreymurHW8BqRB6rvQsV6GRoC8z0azv0/nV6dY+r9PNQZhzywglHmM1?=
 =?us-ascii?Q?utQGwrneQgaV7xFBxS4smpwHeKxD8iTp/fOEmeL4UPex0cRrQ73Eh9oGr6Ti?=
 =?us-ascii?Q?mvdJ0RoTxG8GZBIJ3yF8FLQHFrI51SM2imrj4LLd5IvfJN/3nkVFzf37ZpLS?=
 =?us-ascii?Q?3qGu/m3Izvj8izUVdjs+ahvxaJ0SnH0BkH/61KNO960dt6ca3qRXW2W0HenT?=
 =?us-ascii?Q?xK3EFOet86OXh4+jl3B1jLiABbLwKPeZn1mQW2KkIYsNwff0qYNDpZLbBKAg?=
 =?us-ascii?Q?EJuffSpgN3i929ZfMIshJIfFFq1vXVNkNXqnCO95HO6RtzJLyod+4HXzHBKn?=
 =?us-ascii?Q?KfTkHIkO1kikDA+beGBIlK/5tWSJAwYSpG2LsU0TAfh72hB9MCu3hg9IExet?=
 =?us-ascii?Q?edMLvhGBhJq7mkfS7v7Oct1LXvJzpnmFggpN88yvK5wCyB9HcJ8KGLthfWq7?=
 =?us-ascii?Q?l/Ujc0zsJP1lW0wnFrpRowO3PhMGep2tfZtxCQPuUM5/hIZGi3If4Mi3h99d?=
 =?us-ascii?Q?IM8e5a1d5PG8BSEeKwEuhscem39IF3IG1z/qmnZxmccITcaPN4n0fGLmBpCs?=
 =?us-ascii?Q?dJQ2mlbU0/KzUteaa+BCcv68AitJjs0mGzc+prDrTsae48GjuoShfmpdFpHE?=
 =?us-ascii?Q?rcVtPxLaVNK767MR461x8MPajuEEYSsYTAhIYaA6Ebl/qOVSi+7dj8XOvPba?=
 =?us-ascii?Q?I+WyBg7tBsdxDetva5YK+eRcCEVzYy+IggVp5TfA5FxFc9qOu5jJdXDWRthL?=
 =?us-ascii?Q?RK328anzsYYiFWS50V8kdFJYq3Gs3r+47pUwccompAMUClc1v9VyMhZ1zg7N?=
 =?us-ascii?Q?xxxs+WIh6GrKcKFNCm9oJk724ggZW4tHKCEQBhjipNUWHL1GvKlhP+HKyro3?=
 =?us-ascii?Q?mwIRtSOzhfuwsWO+W/3MVHbICucFH23Y9O9ZwzX8y8LcRMqtyRF0QYGNvsiz?=
 =?us-ascii?Q?WTrPhEFHyDceL5zkUp2xddj28r8bKKiTKgPtFsq5kjbT0Eczqhxw+u9nimzs?=
 =?us-ascii?Q?0NLynnGmljYHnmcIJ+QR/lA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9f8d02-512b-479d-cbe3-08d9fb6fdc97
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:11.3637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85z7SlLgN22qYYLxSH322vED5AO44R2G6Jyo/sFqjtB54Wajr2vYr3n6B/kYg3eXKIqjscnYASbo43H6JdSZIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: QJGa05heBITTRXNIk3gttQ3luBKRxE_T
X-Proofpoint-GUID: QJGa05heBITTRXNIk3gttQ3luBKRxE_T
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will increase the width of xfs_extnum_t in order to facilitate
larger per-inode extent counters. Hence this patch now uses basic types to
define xfs_log_dinode->[di_nextents|dianextents].

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b322db523d65..fd66e70248f7 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -396,8 +396,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents;	/* number of extents in data fork */
+	uint16_t	di_anextents;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
-- 
2.30.2

