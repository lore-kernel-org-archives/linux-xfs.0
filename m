Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2466C43217
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiB1TxH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiB1Twn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022E41052A1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:52:01 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJHtT010133
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=swziiAgR6/RdlGZSdzXIDHijT2IA7nWmXPVttaQg+RZKP4dOcU/5csBFLwQfLPpTMtDo
 gQdGezDrO94dvNcby4OYcdikm5XJ9SzM/jF30VqmIcv0bHqgA6qULyLAN8b/oZ6mDFZi
 KvisvWSU4abFmXn369kbll/L6SLLjhYhCpGtpmh04fa4Kk5cNA9FtiYCB8u/0OhOHNe6
 y/6koFO1/ggUJqpJtUnAuiKp8xBxEoaJLXPbpGfPHTb/440K3wDdnYWnZebDEY42bpR/
 awDuK5MzzXcRG921MmfVVKi0nsfEY23I/DwTk4OjKYNhojjVzI7bDRwpg38G/7ZsBQjP IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k40pqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJkltq076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2XaXW83rGTtLE/WHF4BY44YPgJM2Xn8CKdDIdeGC+twyNanHCrdLbiRXTLn6eFccq4BgFSaIl38X7k2/yEZ4pzh4co5YS/8lxSR/ZzUT7vf2zdglNOfsWJB++DFxcOaXs1IfkJUAVPjM6ybotvUI631ZWBJ2GV9Kkznty48nmRTUaTgmjfLUuCOtmuTZA1NyZjB9OOcjYWYpYkbKnrxQkijNafhs3ChXo/pqYAIxz/zADMtel67QaOANtRyzmJUjVt7AwbQcQlroJWObYiJqOsEjBDl8W9pG5p1OpKgxyjbhoJMg2L9NT5+POGswgTSuqOuZdFp18QCOjzOzSzBZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=NcAuMy26CyGwM1+gl8guJVm2PI0iE9R76l3nsU1dL5LS53PnxOefmUw5dQcEkUbeoEHwfUUAZmRbo5g6k9QB3isg6rCEcES7vLocC29JEFxk3JRV3z6eijOuzX/kcqp8hBkQLqny2DvUdum5xVzg1q1EN0RqXtcXuseQKP/tPJnBIZ0WHjX4tqVEd94Pzb2BZPlTD+uITUl8V/5UFJUuv1Ph8MskOdp1MaZdZNFtujOFHtrcSgfAx4I5L7A5aTg5Rn/riHAGw7HrjDxDJUKwHbpnHiui0g6iIE721Lsx+NCj5NVjTUPSHwtD8YBk76MWmVG1GaNlOrohhP636FFIBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=Y6mblRJkzfQGTGwkCpYaIa99jvKpErpJzZ9RCIsq48P468lEoD86c31ybKNm+aDJf309qblYnj1f0tHAsWFB5YlxnTtVBFeBIA34csWC4u3tj4o8JyLZUD8dBjLrZoNcEx+9US8MJ9T3Yyf5jTszHRgyS7N+nOfcqsea5iPzXaQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:51:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:57 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 10/15] xfs: Add larp debug option
Date:   Mon, 28 Feb 2022 12:51:42 -0700
Message-Id: <20220228195147.1913281-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228195147.1913281-1-allison.henderson@oracle.com>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bfbc535-fba3-4427-da92-08d9faf3c72f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB56124595DDC246D628C2484C95019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uHKOIq5pmc4xmFvLDX8Gbuf9QvvCgNcx+l3fwrtDsTN9fhcErc33O2HuZrihCK2vlazsl63IY78QOVlGogywMUJX9v/iyJCr8tJo+0cn9m03Fo5V8J5gdWjD7RyQnFumcpyEZsnFjPFtgvCoRUSoD7KrlfM8c5MoaJqwTBALoonHfFY6PVdhQ4tDFlF+coJzSjB00MJeNJWnSRtNrIisKkiz0jQoQeYuWtYMMm3JgH7spVscje6bOMt0RCrbr7aXC0pxq4jbk+Y2QvepXph616DqEMiC9LSYJ46NKYa0glwj3//SMWfGOeRFt5REn67r8GFhT3G2fROrx/kz5dJDs6DPyw77j+q+9P3O4InNHlFxWSEDfp/Zo/fN0qoY/bp5RVkigj6YB/V5b1/7fpz3FFBuC9MHxSJ60JMeIjXVdOX0R6cwFlMvJv2ytg/ZBnIkWqeD3wO4OhSnmGQFRKjBsR332hZQS4fQOFAkEtcLwv9LrVMVz61MLGwF5XA0eQr9DbFmSw9DpuWfF5vIRC/7bSEv8MfJwthQlx47WpYda72Oi2mMFd3CmUbUmyUNWrz0j3rcxgcLDmVtIC8WLvY51nAVJpbGRJqGhS0G0O1a/NY4gr7e1snzr5qPtiLIEKETjFiLVw3x/s+MpBIC8U9M2dg/z4MCZ/Z26B5Fll2jKcRtSztgFNQQhMIhv+hGratl0KO0DP4GmbhrH6s8pDUJBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(6666004)(6512007)(52116002)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hFPagX+85FlhS+LeSjOMKunhS/BXcsaJ5+gRulv0SinlLvEr7EJ+dpquiiGt?=
 =?us-ascii?Q?HIGGm4RbjI6xP+ZHo1YDZ6KGtsEp7gzsBpSgA9TPAuHohdWgu2QMhNFyM4SZ?=
 =?us-ascii?Q?zRRIdhSlxO8GEBilxWJAAIoMuyH9OWsUmjvE8NrFFFRpARtJM0BRqNFvWB6O?=
 =?us-ascii?Q?r+oPxLKvGA5bZnIclnEOezWeVeQQuAodBfEXrqIR2N5+qWzGvcz/XIeS+nc3?=
 =?us-ascii?Q?VICvdRPv8wibJNUWJkN7i8Sj6yV3JA6vvFz4U8ZApZ8BBq11VC819RfwnyOg?=
 =?us-ascii?Q?KXK8nfuK6ZRSuYq0j9iWF2M6JahHJUAA6r/94ln19eT7N2K8VkZdEFc6pZ1X?=
 =?us-ascii?Q?cE3aEEWqVg8KI94+euAVZZxzJyt21b91Qrzyercq/MTlO8DLB5YO9LOppdN7?=
 =?us-ascii?Q?dVOKL13hOkj53SvUa222CFmObt1M9G4GebaMBDyB5qXVqxq4A0bd5OUPB6uS?=
 =?us-ascii?Q?A53yL7w1saAElK5JS1gngktyBtOONRe15fD+bYoN9mtPmW68CgkGzmJWOdtU?=
 =?us-ascii?Q?1JJKCvrWF7IYw9rqErFQHYuYg/wpS9b+TeJhA47GYxQQCPW0E+9csZsuldFK?=
 =?us-ascii?Q?c+VVjM6eb9AHtkarYWJ3ZyAOZ/jdPmfRirKO5M2EIFJO49BqYVvE8TR93Isp?=
 =?us-ascii?Q?/3Zeg+AWOckI/Boya/XADRohX/YH0g4yQSG3m3AFk0ngqOsOu4oJDLIUkeCW?=
 =?us-ascii?Q?KUG92QFZ8C9VdU20zy2P+ctAX29wZToWJovp5DSbUF8mEnltpqVUC3As26g1?=
 =?us-ascii?Q?knLCkkIpKsaVM88+eVl6QRjZJnovcrlIkdpY0JcAna3okPKV8uly7VECqp/D?=
 =?us-ascii?Q?s5+eRQCww0/ILRMH6zYYD7M9pWEbuUTnxTRtXvHu9MYSBdg3IHifsAjOEw0d?=
 =?us-ascii?Q?67idtrhZWIQmMbRTX5h2bew1SUCIsaJ7njU2wBqLsmM/cU6nAhpvzaB96Ju3?=
 =?us-ascii?Q?EMBmF1lUffXtpNqrQ7LwqXcgaro69jf4oA8cux13SL0GfhsamA0mNfzIxOiP?=
 =?us-ascii?Q?wR6pxsxO+JGnZFA3NqDed5ejUi8oImUiX5ZW02VTQrAt8J0+NzlcyxT4vbdz?=
 =?us-ascii?Q?Nx0Q6wLFTPd5BzudgRYvWkCOeIHo4Z7dZt2AqpUjmzKEyriSs2T8hz1U0WcN?=
 =?us-ascii?Q?Did61Pj87rfCPFdr7KjKClAZf0vjHXQasRT89Ggf3MQ0lB2CV/q3cH9raRNu?=
 =?us-ascii?Q?rDzaBRicnG25uhqypn7vWsSjj2pFVF7eBI9I8Gf/4GkynkAqh0kXWpZWYQ62?=
 =?us-ascii?Q?amwZBUQ5wm2not4WVpODWMF8OG6niPHQfKOufHZuMq+Mn+Cj+h7SzklX1CHK?=
 =?us-ascii?Q?sC+4Cp3VutGy05x06u5StYOkgqItGJzKLEUVMdtZUk4hg5ZdM/R5K0RwCvcs?=
 =?us-ascii?Q?uIRGrCK2Did4lO1KZBFdKrtwm0md5JWlUbxccCYttHsAGnn8apziZSHN8ST7?=
 =?us-ascii?Q?EcgbPfDTdrZD8nSbvBp/utzlY8PygX6c1kNIYEThgDoyXg+5dMATWIV6AD3w?=
 =?us-ascii?Q?HZTBoGoMfVfbv2obI7rKPLO5p9drFFyWwCInQZ86V9X+c/2I4NZMPCXivRCn?=
 =?us-ascii?Q?kDrYxXyIjvHMWJXfEmUkckKmt3jwCFhIDTjQGGTVjxtV9d2FLXqCc1Qa91mH?=
 =?us-ascii?Q?bDj3UctCmdivtjUmY3EQADuc26jfCH+AV10Gul9awQ84Ls6loQA0siHw4pqc?=
 =?us-ascii?Q?J0/tDw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bfbc535-fba3-4427-da92-08d9faf3c72f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:57.6840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZGnlBaHXg3tLxLjiLZ93U0Jb++BUWtQNuOYCzXhl7FlG9ewP+0gHb6Ba9tNcts9/AQNryDJDl4HDPe+ku07iRMMxFX38ALG9Yq34fQOeaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: wVv9SwjyFGkBpcbWeVC6PCzyd39mrbKj
X-Proofpoint-GUID: wVv9SwjyFGkBpcbWeVC6PCzyd39mrbKj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a debug option to enable log attribute replay. Eventually
this can be removed when delayed attrs becomes permanent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.h |  4 ++++
 fs/xfs/xfs_globals.c     |  1 +
 fs/xfs/xfs_sysctl.h      |  1 +
 fs/xfs/xfs_sysfs.c       | 24 ++++++++++++++++++++++++
 4 files changed, 30 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 5331551d5939..78884e826ca4 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -30,7 +30,11 @@ struct xfs_attr_list_context;
 
 static inline bool xfs_has_larp(struct xfs_mount *mp)
 {
+#ifdef DEBUG
+	return xfs_globals.larp;
+#else
 	return false;
+#endif
 }
 
 /*
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index f62fa652c2fd..4d0a98f920ca 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -41,5 +41,6 @@ struct xfs_globals xfs_globals = {
 #endif
 #ifdef DEBUG
 	.pwork_threads		=	-1,	/* automatic thread detection */
+	.larp			=	false,	/* log attribute replay */
 #endif
 };
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 7692e76ead33..f78ad6b10ea5 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -83,6 +83,7 @@ extern xfs_param_t	xfs_params;
 struct xfs_globals {
 #ifdef DEBUG
 	int	pwork_threads;		/* parallel workqueue threads */
+	bool	larp;			/* log attribute replay */
 #endif
 	int	log_recovery_delay;	/* log recovery delay (secs) */
 	int	mount_delay;		/* mount setup delay (secs) */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 574b80c29fe1..f7faf6e70d7f 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -228,6 +228,29 @@ pwork_threads_show(
 	return sysfs_emit(buf, "%d\n", xfs_globals.pwork_threads);
 }
 XFS_SYSFS_ATTR_RW(pwork_threads);
+
+static ssize_t
+larp_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	ssize_t		ret;
+
+	ret = kstrtobool(buf, &xfs_globals.larp);
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+STATIC ssize_t
+larp_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);
+}
+XFS_SYSFS_ATTR_RW(larp);
 #endif /* DEBUG */
 
 static struct attribute *xfs_dbg_attrs[] = {
@@ -237,6 +260,7 @@ static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(always_cow),
 #ifdef DEBUG
 	ATTR_LIST(pwork_threads),
+	ATTR_LIST(larp),
 #endif
 	NULL,
 };
-- 
2.25.1

