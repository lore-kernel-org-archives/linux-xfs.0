Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED78C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhLNIuW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:22 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7568 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:21 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7snMr004121;
        Tue, 14 Dec 2021 08:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=SPp1SmNH1r+7Nc0WrLWzqcBFLpsvAKqC14XtvYO8QYg=;
 b=W9axuSljoHkyikRV6AZHp1SiHv+MoHO1ALPFc561bqQDHKlIu8NAXq1ugjKsfIurJLAH
 /tEI8OBAwsj+OBMpZ7LNhdn0HOD3tBvKeJKIVKHXnH8mMEKAWO7hi/ilG7RGvnngDp0Q
 pBKGXdkpHLIx60EkpdGjxaQ/E5pDVSbGJLr88/JmVcdXi9Jcyr5hH1aBpkblFRdm9imv
 bShFD2UYAquQk4K7Cjh/OY3G5S+wGwg39PPcJbEv8U7SudyaNvTZPOjspOSawhvYH/9e
 LpNcT5pWdxLVQOsylsThMzqqaDuGP8ETATSDjmeKi25m6blqVmRaolh0kypQK4rJxBJD 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3py33ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fnYr104430;
        Tue, 14 Dec 2021 08:50:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3030.oracle.com with ESMTP id 3cvj1djtj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMiFwMUn2D6B0HgO618zGBN6EfBNR5Dmqzz8kctmrRMPeBLEBctZBWwT0L+Ert5njsLW2FUXVWmMy1RQhtUlRIGKrS7mADVrH9f7JDmuOg3gla6oLQ/Z+pUyueRZ9kGu8wCfgjnC6pjGDheRl8oH5Kaf+9nYWqKoD2LxK+EZlXblgVNKvgUH6h58YOhhSzNu4q/2rGRSJebIs4WTBcPRrPnIq6DFuwqwkIdqkQsMwgonBgsdKWcOrHgVh3PTqyUSybeif+A9OOOKJYcnL4arMBICSbvjp+8zqN3SqvgCnekh3yVsP9ggelj+z4Q3otEF8FM2500jagCECHG84cnd5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPp1SmNH1r+7Nc0WrLWzqcBFLpsvAKqC14XtvYO8QYg=;
 b=ah9ZrY1Bkth4OVBE2ZG7ILRYtUIGxwIvMjdfI4SbBWHaxjhXxtZNI+Opv5AspnNSY2Rc2bdCCM0OeSj9QQWzMTrqlFKvlGb+bFqp3eT3ddnxRmgXo83AOARttIwV3+Oc4E6HJM8NFjYLqo/s3KZSzRnZIjZwJwDvuuxCM6DYlwlKJFCznuj2iv1yUnP1h5Q47vJVWXtwFGderArPZLE22TAvLoZAkrvf7IEbQafmjqUVerSnafX1Ge+uVQuzaRbVyidETdINg5BguGIvM0ZaTneDvkfCDy7q13N1NGIPeUWLfEeykqoKEU7+7RMSZZAeXjIQmVa0jjd/Da9VFjlV9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPp1SmNH1r+7Nc0WrLWzqcBFLpsvAKqC14XtvYO8QYg=;
 b=0QbepCciNhlOmcz1q6lHNJjJ/GMPVvy0PyU/ciFNhrmK66QP2UPh4CjixpgZUJ+waprKBAcmfaUdEDykL+xXB1xjVST0mCIff3iuS66MGqge+LOzCp01L4qGpIRRDFWiGyGYDvQrrmIGPH2W3FVABzRCaSfkw3HomEaEWbqlDRk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4555.namprd10.prod.outlook.com (2603:10b6:806:115::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:50:16 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:50:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 18/20] xfsprogs: Add mkfs option to create filesystem with large extent counters
Date:   Tue, 14 Dec 2021 14:18:09 +0530
Message-Id: <20211214084811.764481-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d3663f8-0e6a-4b10-5b46-08d9bedebfda
X-MS-TrafficTypeDiagnostic: SA2PR10MB4555:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4555062ADEF2012A0BEEE54CF6759@SA2PR10MB4555.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NiY5DUAW7Rkoaj6JfWy0zTgdCl1DxkS4pqk/IVg5NxHOZ6oV0DDZ89yfVoNOVd75SlnYrxk/FDKa2N49VEMdV0LWewhh9tDgqECgsA/YGAU1DSg0Izd4oyLtP9idxAfSoLDCUxPYuMcJhNIfk/niW7ut/AI7O6Xj/KG1cqPmRUjjqsYBofdT/PeWHGE8rQGErhI2QAs3/Ghyj5up0NqeFBPwTUS7L+c2RHpWxavNaa5q6kgQnSsLlX+NvimY5u1TN3khKyGnKIgRXWE9l62VJR3THBMBAAguE0YIWRTk8voB7kVZOhROzAk5fkjlmVU7VFZBGA3K5Ej0XPZquMfadqiVVafpJFxxzUzBdz6EdCcLnGoHOfLHqIxeTowvDmiVvlbu+zt7y+orOHmoY6UmrfPO9BOFCLFhJ0T8bTslPPdr9t2yqDnCPM2sZdMmNPt/WzULyY3MtW6CB1bgIMgazzGKieTL3M1vo5U6wd9OYDFS+5QwW4I3CTtXORnohjZZK138t7qzmcuiQz6qKbjqZ0YVD43iaNyqZplR3U7DdlW5COCos8Cz2AjprNpmdr2Sgp/jPZZyzWeAfEog2FUde3Qfc21/2WOBArzoiV5cMZwhwdNL7hB+4HV14TfpxDL9WOpy1EkbEzQZeWeBHXF5A1gAVaLY9SkFkZWVIgAe/zHs+0TbFG1CmuVeV+YCk1fdWT5lxgJUofnLO+SGbh4eIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(52116002)(38350700002)(8676002)(38100700002)(26005)(508600001)(316002)(2616005)(8936002)(36756003)(66476007)(66946007)(1076003)(6506007)(2906002)(6486002)(6916009)(86362001)(6666004)(83380400001)(186003)(4326008)(6512007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dV5pm6hs6FsSehgOpzd+1wAJ08UibC4F7hyr97OXRWs2USM+pm1fxBbMjp4O?=
 =?us-ascii?Q?EwZWTinr1BOOS9o6EzLv8+wgXzLqMghoiesW9ZUVz+kVnmMUfQ+0yB8Nyzxr?=
 =?us-ascii?Q?kkDWcCGZqspPDehIGtD1qWcIYJO7cBA8x1ouUxUWp9OUuQPIKAZxt1UXLk2M?=
 =?us-ascii?Q?rb0+kJSovHQEelQnWop3Pl9BbvL5ZypBQHkxSModopu49Cv3Or9FBKLDEynv?=
 =?us-ascii?Q?s5YwmcVxby443njUwWdyQ14MloLVR11Fx4oJpqJoXiZZtIHkGXUkS2EY+VaN?=
 =?us-ascii?Q?I2Fv0RcMSWdShhVOFOdgwsNbhfkj+CQErQI++h1yEWvdHkYdtPcKDmt6nOhx?=
 =?us-ascii?Q?8vLdiB0LNXhfJY6NPHFekWG3eh0PZUuY9qGTiEC0Lu8vjKQD0bN1pUDJLy5W?=
 =?us-ascii?Q?/3GIxhuHtgk6osF5cTxtlOn4Gw4A2me+8ELktVYTii3xGl47cmvuIoCqomOU?=
 =?us-ascii?Q?AsTO2XEkrLU9mvHaoYzNKYRzGzJsyFwmlMA/ofzsc8/JVURMHTjSBChzCvjD?=
 =?us-ascii?Q?IsNMgAKAndQdD/zS9yoYPLHge9gh/5on2ry842fjQBrzZkQLIq9DBI8JqJLw?=
 =?us-ascii?Q?zCWlGlHLBkl6dluMbsaarhAOTfXZKw6wUIZzX8FJ7rOPMV8m+htTc2vq0FW5?=
 =?us-ascii?Q?O2ATF2qsx3RkrHW8xuKGjgrPRzzG4StFoSrOodwlBshFbnksjBXCCC2KFoP9?=
 =?us-ascii?Q?C7Ka/ygOltE31LNuP9KTWIJqDCaPQ53QPOjd1WS6tsdnp8K5ctbcjC9QRh53?=
 =?us-ascii?Q?g3bYtutyNd1zUTsZYTaA301TlUrYLjFUSu+37Z+tUQKvwj+vYK9ccVPTf7/D?=
 =?us-ascii?Q?mImQcosrOFmoQXojLv7eynU5XD6lkTYM3FZWDNrC8Eij5yDY8YUZ6+hPDmyP?=
 =?us-ascii?Q?BPiHIWIRfQj50ZXZp8YS8Cax+mQfJt5LaK7gBoNvFEEL7CxtNEdC9FDXgaZj?=
 =?us-ascii?Q?OY3iovznumbaBobJoxHSd7ppc90zjo+XPopde12YQWmUV0MdN6XBH/SZ0Tx7?=
 =?us-ascii?Q?gB7sjQ8CaSMPvDPOWLsKUKmjn8a9qafeZaxzCX7y1ohw3ASfNTmg93KtuZzf?=
 =?us-ascii?Q?st4rH4gvobfkAknA9AhZ/vOb8kMY74WHRGA8l6II4o5n7fneU/IV1AfvPiFe?=
 =?us-ascii?Q?NtpnCZmgvOU6BauvJKZ700RAW9Y3WYAmh2YcPUMjuKToTbTUHW8672mVQaDP?=
 =?us-ascii?Q?AtMFzojN5x+fCqSQNknpql//Q4i/xN6q6CPqXK4qiP5CmN3Cv8HRR415ss5d?=
 =?us-ascii?Q?L2Gk/bcP2ANM6MhdFbwehjYq5VOT0ZrkL0C5dDQk4F8tPhAOp3bMSK3yvc6q?=
 =?us-ascii?Q?nG4b6vKyWTvdXZNz6NL9OsoRqW/BpV1ITxUIngdUagKNzBfGj7cb1RPQWIJr?=
 =?us-ascii?Q?Jylr/v3LU255UK1fwkCvd3fC9NV3hQP9F2VuWXuQklvw5cxRCO5wjZa3ASyY?=
 =?us-ascii?Q?sdxZa7WoMGOIcExXQOAiimRMxVvydKtg/OT/R6TfQXq5Xa6yG0pPo/ccqI5+?=
 =?us-ascii?Q?B7HTewQVOh7If9C5OXG9gY8+5MxbkJwQAlzkbZb+oCQnvVxk7f5TNdNbopRT?=
 =?us-ascii?Q?qqL5mMx3nayCOUvQmCaIcjpno8GXHCz+3lPeq9tX/5pkN1awP+2R3KcR0uKK?=
 =?us-ascii?Q?bvyqR4uFzDMz1kyL3ULVe90=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d3663f8-0e6a-4b10-5b46-08d9bedebfda
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:50:16.1924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Rw63efaWBoCC9et8LILL0PgaNG3qmyLjyHcytw7V4oxuleq7MIRMXec5Lw/iKluLscy0RQ2+n3ANZC8FtZ8rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4555
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: vhL--AQ4NLVH3EzJIni66paua7BpJ-lR
X-Proofpoint-GUID: vhL--AQ4NLVH3EzJIni66paua7BpJ-lR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Enabling nrext64 option on mkfs.xfs command line extends the maximum values of
inode data and attr fork extent counters to 2^48 - 1 and 2^32 - 1
respectively.  This also sets the XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag
on the superblock preventing older kernels from mounting such a filesystem.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/mkfs.xfs.8 |  7 +++++++
 mkfs/xfs_mkfs.c     | 23 +++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index a7f70285..923940e3 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -639,6 +639,13 @@ space over time such that no free extents are large enough to
 accommodate a chunk of 64 inodes. Without this feature enabled, inode
 allocations can fail with out of space errors under severe fragmented
 free space conditions.
+.TP
+.BI nrext64[= value]
+Extend maximum values of inode data and attr fork extent counters from 2^31 -
+1 and 2^15 - 1 to 2^48 - 1 and 2^32 - 1 respectively. If the value is
+omitted, 1 is assumed. This feature is disabled by default. This feature is
+only available for filesystems formatted with -m crc=1.
+.TP
 .RE
 .PP
 .PD 0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 53904677..6609776f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -78,6 +78,7 @@ enum {
 	I_ATTR,
 	I_PROJID32BIT,
 	I_SPINODES,
+	I_NREXT64,
 	I_MAX_OPTS,
 };
 
@@ -432,6 +433,7 @@ static struct opt_params iopts = {
 		[I_ATTR] = "attr",
 		[I_PROJID32BIT] = "projid32bit",
 		[I_SPINODES] = "sparse",
+		[I_NREXT64] = "nrext64",
 	},
 	.subopt_params = {
 		{ .index = I_ALIGN,
@@ -480,6 +482,12 @@ static struct opt_params iopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = I_NREXT64,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		}
 	},
 };
 
@@ -804,6 +812,7 @@ struct sb_feat_args {
 	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
 	bool	nodalign;
 	bool	nortalign;
+	bool	nrext64;
 };
 
 struct cli_params {
@@ -1585,6 +1594,9 @@ inode_opts_parser(
 	case I_SPINODES:
 		cli->sb_feat.spinodes = getnum(value, opts, subopt);
 		break;
+	case I_NREXT64:
+		cli->sb_feat.nrext64 = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2153,6 +2165,14 @@ _("timestamps later than 2038 not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.bigtime = false;
+
+		if (cli->sb_feat.nrext64 &&
+			cli_opt_set(&iopts, I_NREXT64)) {
+			fprintf(stderr,
+_("64 bit extent count not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.nrext64 = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -3145,6 +3165,8 @@ sb_set_features(
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
 	}
 
+	if (fp->nrext64)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
 }
 
 /*
@@ -3854,6 +3876,7 @@ main(
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = false,
+			.nrext64 = false,
 		},
 	};
 
-- 
2.30.2

