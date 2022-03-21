Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F8FC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344380AbiCUFUG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344376AbiCUFUE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ACA33E3C
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:38 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KHh0MT000630;
        Mon, 21 Mar 2022 05:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=NEgwpDbYHwP042muSjauZUSY48vWBtV4slfQ2mBNbjg=;
 b=TKJSljTM6V2aHP42/CuSxDcRT5alu9a+rIn3S4mcM2JKZkVhb0vbLm8q9oqg/1E3wLD6
 UvTx+6+W34dfSxzOO6qhizWQoxZS5WL+qJf+NeoZtHthrcdNiYIkrzWp8JvFDkx4vjAb
 vdZht2S76eC4Gal31BLr66rA53UFpSBesnQbRcU0eAc7qR0Ox9Lo1d1IJgInZP29u2XS
 +jnBs3oI2pyC5uZls8NeO5XU+7paDv4VCMX8aFCso/9Nrm1UO81Wu6Tj0F+x8sjzX2xk
 CnsKv5A8SWPQ+Qp3pZtLPMb5ICUr1Ck4Slp9S+XghYchCF+tg+9VUmRY5WSjQx9+MPPP bQ== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72aa3j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5IWUv121665;
        Mon, 21 Mar 2022 05:18:32 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3030.oracle.com with ESMTP id 3ew578rnt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUxUxTPgPaKipPIGnbxHXDCQ5elDZQv+W3NUQmH2nfann1BDJuCgZzFY6yMpxmzBIb3NQ32Xz2wXROP3EUBjncHOMAKavn3gwa0WxzV3GdUmSRDy2h/CdxYOmkbjnvdYEmg/pvj4vktrp3Nfv4aGBKPkd949P1TbSdyMRIOg11BeJIC+OCjPbTXOR8Ewx87AxEu4IrPhsdYj74p3PNDBxT1m3EY3Ow5lfS4DZantkqGH7yZEcITH1U50p9xkxPD6g+9kVw2tAyBs5WTNWaRXMBjXTPa0DfU0ZTCo2QxnsFZgFMPTLhR1sOvxelU8avf+r1V0CmNoSXXlc6Cjg/hEZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEgwpDbYHwP042muSjauZUSY48vWBtV4slfQ2mBNbjg=;
 b=nijqRKPnflv6Bt2l+FwF/i6pZpauxbW9UMXJzi91U0ZqLTsdAZNkBLlN7C/jW3YK1xCdFZqeHIuRfaZmza3LziTPYl2F9H9sPLzfSTqL7Hvo1IcqEE+VRRdzX2rWp/XbI9y4fXjYeD3do5lKMn1abv0miXJa5qvRzqKm324NHp7B/cKYukugy+m0rMN2hwBTzRxmze9g51OhApty+s2VVdaA8jfDzWP+02P3bXThWkXq5oAjcJ9MSamXtx62vn5swtRv1eHILBuL1qi1yeCD/opAd6RKfphBCdUq6vqScqXwCBDgD/drdCId1+LlXdCzOWpOMyHnPpzXT/qNCyCtMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEgwpDbYHwP042muSjauZUSY48vWBtV4slfQ2mBNbjg=;
 b=iAPNWVSLoo/zSiCheX8HTibSOCEUa2SosdczJvVVO8lj1+xHSNXA3jj1w383piLDASx8cl8N55HslSPalUbWvJrG/kbPjnLb8dBRs2J18WZgTSyG+2A1Egiblv4MioLMDYLPTsrBuuKP+KfV3FBh5IkqH55JWFhbPISk4oWNyMs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:31 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:31 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V8 09/19] xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Date:   Mon, 21 Mar 2022 10:47:40 +0530
Message-Id: <20220321051750.400056-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb6bbb4e-c4d1-4a01-c776-08da0afa3d1e
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB553740A7CF852D59A1C27C95F6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1dVDrLVc+B05Js7dy4pnysmi9uftAngLio/aPcLfHHkZy2RhlWqsLXo7aY9D0XG0PrPQxuEdbf4LgczQTPZHlkA+F3x4i2tkJnDJgCnwtf2e5IvAwEAVdKc42Zn8RcBgEMUOzsYKd7XqKNtK0RcNkgjjMI8GLI3GgYhVj3XjiG/ti5+9GkYaXvv+32Y5c1XI5ohshceasmxUtTZJ/R6JNTd6t+Dh/BKN1oTr5IFTyo/BviSvuFSr2iIA4Ty+2C5nDoyl6JB1ddNp+XZHHobiZbVlG9mbAhbBmxzty/aEhxXPEaAHA8URcPcye1frx5V4UJQ6biilTXYHcoRNIdqEbRgZ1liXUkhxT+XsT21G3jYUa1GMpmj9GAc4WA5eVm8p/4BHIEc3mlbNxnVrzIViVmP+MWI4HnUAyl9kscgXCi1tE7t6PrSFlw76YQW5eZ1gOls2U8ExMlPe4W5bgHSldKdU1cFUpz14WxK1mu8T5fPiStAdVpviQaSPG1blvntnE3ptLCVv8k6FGK2JXjmncEkpRFV8R7O4ESvVo2NIhz+RqBHzQ7sjHAXpeWmq7HdHxS7jWl5M4/3gjasOqHXGwfIlgathxEPcQUjjHmacPVl+Q/2HUcOC9EHb5Acoz7kCYhYYmgVJuTNTa/IWO1gD2PMlmjWe++0xGnT6eMvJR7POYGD4qhtY+az1i/ywqXuN7kDlIsR7Qb71fN//CQ8z2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(54906003)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9lDsS2ZS3MKXFIdsUjA+gpXqkAIlOGTfq3A+Fiaf2Wz5rSe3AXXo3tp+7UTE?=
 =?us-ascii?Q?I5B71UccplK8D8AyB0f7k3aC/pe0QWDtvI7xAk+JcfdIDRhsTLr5BUmlOkPM?=
 =?us-ascii?Q?i58Na3YqZ19xd4ugKWN0bT+8m1qRt7Ekj5/ctFyrZ24SDjX7WStPzPOCNLc+?=
 =?us-ascii?Q?aZQxkjGDz+JwJUQpbBbcxOe/gpMHc8jScAepDBSlbI0n9pBTYgfXt6f/eV9Y?=
 =?us-ascii?Q?85Elva4g8ttktKv5oKWN3z/zBT4hqIADoaK6CFBSnNrhPT11spv8jfpmtfxx?=
 =?us-ascii?Q?nI0kTxx2bfxNyt8aP2avdG/Nbb7nt7OejfYDILG1ru6PvyUfmmTWxbpqEHEG?=
 =?us-ascii?Q?ycw3q/qKr7u6pRuli3zSjLP660eaTgFzBliTxXRreVsxmgeiHPmmBDca1ber?=
 =?us-ascii?Q?tLICsD7wxn0sAuVK1w3JMijD3lae1rR4+ulcxyaSo1Fd/lTzgzEq7EjdEIaO?=
 =?us-ascii?Q?aPIJ9VSlp026w7CPfv2RShZwjV4rPp1bfq4e1RoCXkEnMKUFUHXCynWM0Vlr?=
 =?us-ascii?Q?N+4AS2RRTWNVJGk0eTuZUx+HB7I+y8ngGtx7VSdhlF0x3t9hGIfze6zDNmOe?=
 =?us-ascii?Q?tnpmg592bbYdVsYAUWxDHppopu9FbsMZBYoAeIICIk9j3tgFsYwyQC326OIN?=
 =?us-ascii?Q?OmETAAaqQyz1WRXlJJZcrEGB/s4XBCs9EmY4fKRUqqzRyKj3YzqqfeJGdl1H?=
 =?us-ascii?Q?HRhUh1XHTdYmmUA9gMshPJzdUS7P6gwFkOJAEE3MmtSJ4AjvU/Eabq5IrJzl?=
 =?us-ascii?Q?p9QXkuqFQnIc6H2uIigyJ81zRhbHWuyCD44Qtx2gmz4lNonZm9jg8SIDm3uV?=
 =?us-ascii?Q?t8tKYZ7VEDNmHoSaJ8Jgp81LoBGKouRyqMFekP7Z/FLtzeaVtHGpQ01RCwuF?=
 =?us-ascii?Q?i7iYDO5ximO1koBZ0val/zDfWd9XePe/hGlV+Pbd+eg6vOeKO8VPt77Il0PF?=
 =?us-ascii?Q?ARrDjOByaIIEyxf/yeMPFqTlYPERPKtNRk+0namjbtOzCROrZRRE01U4kNe4?=
 =?us-ascii?Q?afVxLvP55cr2kYKwqIGd0MB8/rxNSY+3KUMmOXpJXG1LbwOH3PlplQsF8Gri?=
 =?us-ascii?Q?7nSsBjFRLIAEVHZTjIYO3ISFj4ob1GteMfKrMUfie6R1qi1fsh2UKzDSMxwH?=
 =?us-ascii?Q?HFMDfq9I42KONxUYKmZ/+UjgIvnMCBO1UdHIyb3+CxpOfNddhintxRDIYeOR?=
 =?us-ascii?Q?Bh8Z/jwHbsTBTbTdJ9J5gElpS2ZpJ+VLLg83L75rpfGJ0y7ycrXpxi5za+UH?=
 =?us-ascii?Q?dOwAsmaaVkgomO3KYzGrNX768apDfvMpDsBlbV8NlbqVZVoXXjrWJYGuP1d+?=
 =?us-ascii?Q?MbpWDfIXaBFkeHtdwmHvE5+mI16L7L8+3JMP12RXA2chT0EKNZ2Dj0JqTJOT?=
 =?us-ascii?Q?CHV6Ypa3dNFilZIv8iTnzEJbVJnorxp5aDo44OlDhew+i2H96kSa5uB/RSmZ?=
 =?us-ascii?Q?Xlh5YdXKxpJyRSCI/LA2NntTXBkuOwO8WT1FWe3G/i8cs3Bzz/RD6g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb6bbb4e-c4d1-4a01-c776-08da0afa3d1e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:31.1750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NrNYuPolePfWC5Dhf3yySvvekn78pFmBJMd05t7mR2QnValab2wx8NpSN27w1npTl7r75GhiouQyHgvvU9WmEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: r7wgo50V0WDw3b48eHJ_2eT3vqP51K4h
X-Proofpoint-ORIG-GUID: r7wgo50V0WDw3b48eHJ_2eT3vqP51K4h
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
supports 64-bit per-inode extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 505533c43a92..1f7238db35cc 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -236,6 +236,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
+#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index bd632389ae92..e292a1914a5b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1138,6 +1138,8 @@ xfs_fs_geometry(
 	} else {
 		geo->logsectsize = BBSIZE;
 	}
+	if (xfs_has_large_extent_counts(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.30.2

