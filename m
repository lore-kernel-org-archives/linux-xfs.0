Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB0AC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 20:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiEJU2R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 16:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiEJU2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 16:28:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F7D216056
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 13:28:13 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AJHui8010355
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=S0RHVSkVrwvebR0xgqQgNiGBhluzMnFmmDi0LVtuYY4=;
 b=rrinVSgCrQPuDVsLre4QMmKyLr7RcdSIyYpgPSsuO9EDjNunRnCRxxH540CtBjs9HYd5
 O4lZAKCqGOSZNZQSHWj5P4KSzhnIxuck2EgHVuMlsiOnbAmqgnEchp7XnKY57TrD7NQF
 7elk1cCo4G2ATnqY7S37viKQKFDqyanA1G7RgLfFXiefx/VvrzJK5I7mY1VOLsn1d25v
 09mWGxyE9G7DXtqaoExThVIP6HsRXBEASDN8lES5RWST4tmMHCQxpg60nzQ9Ajqrey/M
 xHmX7JjEYK2Tfwa1Ivs6CDJy39TGguA1f1xV2XbRPbzBQSI7xSbs8hzfo9Nj/o0IHnLq Sw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwf6c7qj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AKLNOP036202
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf72s0tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThoHJiVMrzIT9yNuJqHSPfdO0tN3fXsgeAgcPDzlkhJqGkctX1BVC68nG3SwHpxduDA4kBddZg88kMJOnr4OQytvE87Cf1dtS84N558IJ/s3kYFho4qtI+yEcgpPDR05qYItwS89eBmMuoUXf9e/Wm1GMtakTt3iwN7wEM4Q39lah/kJ0Th2GaqlhDKOcPemXF6lBYdZLxz1k0ddd1CcSyyPTmDP2o+M9pXVQT3qEk4cfwy2cLvTHeeds+CSJ9tiHEUqSPRR4ny09LmvWarc/fEqGR4JQE725evrm2BFBL6Ac/s8X+FPX90Fcc52GSXd6YUg4EvcW3PPxA72dY/Egw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0RHVSkVrwvebR0xgqQgNiGBhluzMnFmmDi0LVtuYY4=;
 b=eCmgi+07PY5bYent1Ury2BaO86yKZrdIYk+fWYVaBw8v2rK4+iwfPZ0pznFfZLc2H0ib3pv4CbTpcl/TfOxEcSKs1DfWs+FtyL2cVi8apk3y706x5Ac2dLdSznRgR44JagaBdOJg90hcJv6Kn1jK0tr6JZ1BYn+Wb4epPAUgy/JjccdEioDx4ARoXnmgbgZT2znivHDFebTNgwigsbmazVzf+rrfqLOkPFCpK+nhYx9zgQQQzqtoSXFmovp2Qm2QgiWaBYb1NWi//MKQ+ekcFJ36ahmlBQsDR9DpMYrsMIsmdEtxC30c/F5xYDHqRp/UkyuYyuty0lK2/usE2k/umw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0RHVSkVrwvebR0xgqQgNiGBhluzMnFmmDi0LVtuYY4=;
 b=zlwSHtIA42wTS68hj7Z8hiZ9UVPnBijkNvvD38foAI5K2q9hcAaSr9lXcyMEAJzmT6QaEzbUjvziPak4PZUGFqmKDC0NDQRnfMIg+SAft2Yfw0SU4+dKX1uFRXMZrdtNSagc1geCDBbYCInHTy1lQxuHwKuC4ZFeJE7fvhXNgYM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM5PR10MB1626.namprd10.prod.outlook.com (2603:10b6:4:3::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.23; Tue, 10 May 2022 20:28:09 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 20:28:09 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/3] xfs: remove warning counters from struct xfs_dquot_res
Date:   Tue, 10 May 2022 13:27:59 -0700
Message-Id: <20220510202800.40339-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220510202800.40339-1-catherine.hoang@oracle.com>
References: <20220510202800.40339-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ad48dd9-9b1b-4c34-f617-08da32c3988a
X-MS-TrafficTypeDiagnostic: DM5PR10MB1626:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1626AE1F80B10719E20F389089C99@DM5PR10MB1626.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OEOvr7s0OLY8l0STOV/TuWq/Vp7WqHduWCXMHK9p4bhUrwVNZBvShN8qBhlWVkVh6IvmbJlICTbiyCs4jCmXKLTHAqJc93UxuDA7lbdqymI0db0t+k9OE/VQIYYBPzpQAwgVLFdQ/JLBJL12+PGJQpv6bp6c/p4fxYMmzEbJ80HGoMRJ8hzSdyU4AWPtlu8qJEz4oFpYqwfQWvREo2svBHJqj9msM64JB6XDnavii/2PwX7Mky0aTizdfVv597VvGDbbmhWoiJGMW3n+BM2hecXdpUvEtD2DL2hRkguomQ1L+qOF1+rzZfHhrApKCDJdy5MpDXimBRrEjHoLp3SCG8C+osGTYO8BS18UISZ4g7qbDM6S6QdBvhQqD9aeEhQwEE9RlxuOvmXGRhU3w5CTHypwe+hk+YvxrcdqaOMUPkjLbQtIBrRHjMAZVw+BTiAlmKig9OYbYrVOokW10A0oNWzTRqRD6qATMSxjUmqMWGRA7R+lWyq4yeum+1GklGWNDdF4AN0D0CueeZzMNkkMy4Y++ghLYhSmCdDUXBq9bhXVJdK0fgWiH/lm+FNkculJtDTBgHqhc1PwUXvpqiegpipS8DG5nyy5vM/6qCLLNtn6Cqtohil8BaKq05ZycpmfrPsyDFTVxyN0QfECa9DzkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6486002)(508600001)(6666004)(86362001)(38100700002)(83380400001)(186003)(2616005)(1076003)(8936002)(6512007)(36756003)(5660300002)(2906002)(6916009)(316002)(66556008)(66946007)(8676002)(44832011)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oEuHuluDvx1Lu67YDrq0eSJJS8JCOVj39i8RatIpYPK7qsp9nXVrUR4XbgWM?=
 =?us-ascii?Q?pIBnljg7rbIwJOA9yo+km0D3pLbzKpLrRnY9zeMB8lq4a/vnjdAAq3N4a3yW?=
 =?us-ascii?Q?cHFOPoGtv4gQofSVpPpNuDFgbad+lo+TnnVmAhWy6WThejfBZ07Gm0Zz++PD?=
 =?us-ascii?Q?vCJ2r45/mBlqAr8cXzlT73HCrXiSWtUxtEy8fUSZQsSEz2BvbHLqf6X9OlYr?=
 =?us-ascii?Q?pN0ww1LqSPCcskLtSA3gOz9uM76glzs9WgWPhCfaW698lsS0cPH4zVvmtTHc?=
 =?us-ascii?Q?MSiJMpg/vTuxII9qzBBDfDJnrhuSHrOO2sDi7hjqdb5fUYu8lXy7ojh3aaEh?=
 =?us-ascii?Q?FAUw40edZwCiUUIODDRdZbRtMfdUy+hxOWHrq0xTCXSTOejcTivTUxvnA9se?=
 =?us-ascii?Q?mn5H8VReOJ1lo6T2gAn+nrkkOh6jnL6vcAtXsUGLYdG+z5vB5jaIG8o6D2of?=
 =?us-ascii?Q?KF0Booani7+5gbFIrq/NIzW5UIKXs7/ysc9Jj8WJZQffZZdOrg5ZTUTFeKzM?=
 =?us-ascii?Q?GiRsdfJBLFuSL9HuoGqRiPBOo4LfikYDhBmQbfP3X76tarfYhTsXDLcAWpCm?=
 =?us-ascii?Q?jwPZDQ9wknm3d04DYB+ccarZKyz6QsXOH7E7bd5xZDdITf11acaSFQ86Kyol?=
 =?us-ascii?Q?58QLmoLoAGJEBVN/r3XBSr8xjD/uhb/VM+ArygZDG1JztHhyvVsVzySoL9ut?=
 =?us-ascii?Q?bOXFrRU2HWSnrfN7cOJoT9rHYA9dNT+lFE4X8KJ+U/TppADNQz/LAP9XE7+t?=
 =?us-ascii?Q?iSwzKqK5qzO7mXl8rHZACBXSIUhzYHCQjR5mGL3vWRDG57LCg39MCe/7Xo4T?=
 =?us-ascii?Q?NwuYLfH90sJ0/CJX9Q1DzdpaofTLLWZ6xWZiU8HFAlNXOEoexUWb302jOERx?=
 =?us-ascii?Q?F33qE4UzU81djCZuKggSUjUzJKfkDniBzVobmpYjb3GWREpJU4XbiFVIFcZ9?=
 =?us-ascii?Q?Z0r7phiUklNptxnps6sfyR0tJoDQwr+cxuIpYG08mYjDhRxbNHjtq9PXvSVx?=
 =?us-ascii?Q?tpjU0jGo55idCFLaD6TM1bw+BQk55Ihsj4geIwcFKiPuV8yLQORYWGHQjRvG?=
 =?us-ascii?Q?Kq+k5uRGNstTj9Jiz+C98FXIwv/Vjv37TotvzeUD3L0KJ+bnJV4wDq+jyXI/?=
 =?us-ascii?Q?OkIpfy7V3UKBcGI2LyAtiYs23c+bdSjyEFoTM3jpGmJzOcHx1VPx86kTk6VF?=
 =?us-ascii?Q?fvXgR6KCnU+szuoHaSF8wrCKTtrOFb+QtIhX15RSBxHIiEijmsiUrqEfSD8r?=
 =?us-ascii?Q?kENgAumaO8UGSQRq5S3PsMX6psMSPYWnebkWBMTEvACkcXinxgcOP3zKaVMJ?=
 =?us-ascii?Q?1EQ01XlhNWr5trt3jz3Tl7IFzBAsZHZVLdZ0e482ha1zPmLaxQiqdIg9Yf3E?=
 =?us-ascii?Q?7V/8X5qoUoi2UASK2eB9rT0PRvNQ8OGtMLPbZ7JSxSBI6AZR5uO3p+ehQF6A?=
 =?us-ascii?Q?BNbkJqUfqYhQ40tQZC8yQTDDkL1U5BO9neJ6JUg614MqZkUeCANj/TNiWvOM?=
 =?us-ascii?Q?d5PKr/vZRWofwAzVQainjn0O4fLx9RXuheEc69ELWD7gAQK75/LHQKxMMC5T?=
 =?us-ascii?Q?zpHHmbwf0lF3cwldUpe3BR5QZWmOEP//tGgvJ4qjkYK+FQ2zqCLmdNFT82Wa?=
 =?us-ascii?Q?sep2++FuWbpoSudKeg611cotzB9223+T/VoweWDTXF4WJB6ZRDErPLBwMi1A?=
 =?us-ascii?Q?BxuhrPvS1kJ17fH9/kEr598mi3J8xQcqk+Jt54PT9Qw1OoFbzaCrArVGtR5H?=
 =?us-ascii?Q?6VjcnkJz+QpgvMxG5SW8lWL/PTsSPU9o+4v1QAFht3L4FBTDOjI29v4xeO2q?=
X-MS-Exchange-AntiSpam-MessageData-1: DAAA+xI45Q8KiUSE1xLxEsD8oPJ8huEfr7w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad48dd9-9b1b-4c34-f617-08da32c3988a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 20:28:08.9663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXYdN68QrAZs93dmRvGBqtIz53JGaC7K4Rq4xV4RbxVSHZWfeD8jx6cX/UQp9OosmMZZXsSckxTYVLijZzsjjm7g6Sqp8WB9Ce+r3lOqN8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1626
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_06:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100084
X-Proofpoint-ORIG-GUID: ezL6LCC-RPV84LSFhpuwECplakeLZk-n
X-Proofpoint-GUID: ezL6LCC-RPV84LSFhpuwECplakeLZk-n
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Warning counts are not used anywhere in the kernel. In addition, there
are no use cases, test coverage, or documentation for this functionality.
Remove the 'warnings' field from struct xfs_dquot_res and any other
related code.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |  1 -
 fs/xfs/xfs_dquot.c             | 15 ++++-----------
 fs/xfs/xfs_dquot.h             |  8 --------
 fs/xfs/xfs_qm_syscalls.c       | 12 +++---------
 4 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index a02c5062f9b2..c1e96abefed2 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -16,7 +16,6 @@
  * and quota-limits. This is a waste in the common case, but hey ...
  */
 typedef uint64_t	xfs_qcnt_t;
-typedef uint16_t	xfs_qwarncnt_t;
 
 typedef uint8_t		xfs_dqtype_t;
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5afedcbc78c7..7484302b68b6 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -136,10 +136,7 @@ xfs_qm_adjust_res_timer(
 			res->timer = xfs_dquot_set_timeout(mp,
 					ktime_get_real_seconds() + qlim->time);
 	} else {
-		if (res->timer == 0)
-			res->warnings = 0;
-		else
-			res->timer = 0;
+		res->timer = 0;
 	}
 }
 
@@ -589,10 +586,6 @@ xfs_dquot_from_disk(
 	dqp->q_ino.count = be64_to_cpu(ddqp->d_icount);
 	dqp->q_rtb.count = be64_to_cpu(ddqp->d_rtbcount);
 
-	dqp->q_blk.warnings = be16_to_cpu(ddqp->d_bwarns);
-	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
-	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
-
 	dqp->q_blk.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_btimer);
 	dqp->q_ino.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_itimer);
 	dqp->q_rtb.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_rtbtimer);
@@ -634,9 +627,9 @@ xfs_dquot_to_disk(
 	ddqp->d_icount = cpu_to_be64(dqp->q_ino.count);
 	ddqp->d_rtbcount = cpu_to_be64(dqp->q_rtb.count);
 
-	ddqp->d_bwarns = cpu_to_be16(dqp->q_blk.warnings);
-	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
-	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
+	ddqp->d_bwarns = 0;
+	ddqp->d_iwarns = 0;
+	ddqp->d_rtbwarns = 0;
 
 	ddqp->d_btimer = xfs_dquot_to_disk_ts(dqp, dqp->q_blk.timer);
 	ddqp->d_itimer = xfs_dquot_to_disk_ts(dqp, dqp->q_ino.timer);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 6b5e3cf40c8b..80c8f851a2f3 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -44,14 +44,6 @@ struct xfs_dquot_res {
 	 * in seconds since the Unix epoch.
 	 */
 	time64_t		timer;
-
-	/*
-	 * For root dquots, this is the maximum number of warnings that will
-	 * be issued for this quota type.  Otherwise, this is the number of
-	 * warnings issued against this quota.  Note that none of this is
-	 * implemented.
-	 */
-	xfs_qwarncnt_t		warnings;
 };
 
 static inline bool
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index e7f3ac60ebd9..2149c203b1d0 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -343,8 +343,6 @@ xfs_qm_scall_setqlim(
 
 	if (xfs_setqlim_limits(mp, res, qlim, hard, soft, "blk"))
 		xfs_dquot_set_prealloc_limits(dqp);
-	if (newlim->d_fieldmask & QC_SPC_WARNS)
-		res->warnings = newlim->d_spc_warns;
 	if (newlim->d_fieldmask & QC_SPC_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
 
@@ -359,8 +357,6 @@ xfs_qm_scall_setqlim(
 	qlim = id == 0 ? &defq->rtb : NULL;
 
 	xfs_setqlim_limits(mp, res, qlim, hard, soft, "rtb");
-	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-		res->warnings = newlim->d_rt_spc_warns;
 	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_rt_spc_timer);
 
@@ -375,8 +371,6 @@ xfs_qm_scall_setqlim(
 	qlim = id == 0 ? &defq->ino : NULL;
 
 	xfs_setqlim_limits(mp, res, qlim, hard, soft, "ino");
-	if (newlim->d_fieldmask & QC_INO_WARNS)
-		res->warnings = newlim->d_ino_warns;
 	if (newlim->d_fieldmask & QC_INO_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
 
@@ -417,13 +411,13 @@ xfs_qm_scall_getquota_fill_qc(
 	dst->d_ino_count = dqp->q_ino.reserved;
 	dst->d_spc_timer = dqp->q_blk.timer;
 	dst->d_ino_timer = dqp->q_ino.timer;
-	dst->d_ino_warns = dqp->q_ino.warnings;
-	dst->d_spc_warns = dqp->q_blk.warnings;
+	dst->d_ino_warns = 0;
+	dst->d_spc_warns = 0;
 	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.hardlimit);
 	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.softlimit);
 	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
 	dst->d_rt_spc_timer = dqp->q_rtb.timer;
-	dst->d_rt_spc_warns = dqp->q_rtb.warnings;
+	dst->d_rt_spc_warns = 0;
 
 	/*
 	 * Internally, we don't reset all the timers when quota enforcement
-- 
2.27.0

