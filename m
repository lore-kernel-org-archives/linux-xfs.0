Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53C2C4167D
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbjKFNNk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbjKFNNi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:13:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406DCBF
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:13:35 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1sJE009902;
        Mon, 6 Nov 2023 13:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=l0pNoZ59fm0VaFkivCF4gquo1FAAkx+AV4XSeRzAT64=;
 b=Zr8LAYp4u2PVYKTBVluCnnL/C7+fINCtxlX8ru9NIFnFxgyAayRVaYfDTPWTgPxY3DBi
 jwbkQnYED0Nd6OrsfG7GcFoM/BN61ik4FfTUWHc1IfkY4M8Ww6Rywj3OBquaNkKSGDkL
 X7xKvsR4AJQ00cLc9FGh3MW86QOd47m9rsb+kOFjTaKbE1Hfy1Nil7A4N+pCxNy1GVh8
 58Onk2eihaZTMAx6TXYTrMJuTMMIx7RVcGg5u9Sh76kdUa5guNpM0Jaha2Xgl0nPMRmJ
 m61imqM0nfFCQq3OrKnLZEk6HGmZX49QffCTxOPImNVI3YVTnvjXpFwy0XwSiJycDasX dQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5egvax2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:33 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D8Rjs023535;
        Mon, 6 Nov 2023 13:13:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4tcfa-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOGHX99tiYBo3btI36fH8KgGzpHXEDppxVZujitIUf96jPfLXDGRF8eRmWnH4FEQiDBXz2PV9TRBCekTR9pAv/lN6EjsbmSY6j6BICSgHHV5RUfo/plWwV8nLk9piB1Okhh3YL1YCptvVEBDsGCix+sFUlfMPV15X8VM6PmVc06yGilCRoOpZuYmfImgJaSo6owzbqQtOIilW/h75Zvn4T/p7LKExPSOD+gXF624EpF3nErcWmMG+LwzDOU3/NW+40fnNomcI5+f7ZuKuMKsFv1WCpJIbSvwPKpY63WiYjzCcMIbcTbiDmCfuq9VIV9ulnxAVhxkumQu7JZXHhVZQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0pNoZ59fm0VaFkivCF4gquo1FAAkx+AV4XSeRzAT64=;
 b=kutp2UB3CuvdI0+of+orOlZJgfNHe6wtk5T0Vr7LT0vGqn5hWM3OmG7dVJmE8J5ztncz1jDfzxb+0EbdL7ur0o65r0l7loGsDPls40777+2WTzLZ2HObjwFKC/SxajwzSgpWudmyQgRLXhGwZKC6yYR2wNFeL1BpsOZY8zTcztq5s1B9pu9tTpkHzXUssk32qLT+M0UuqpwB1DhDvUBDm7L0h5UXcEcFOErNmmCBH5nxjFCIeouIWAzhbixxJstD4szWpdYh1EmJ33BcJpGfmPXELpkGub/fYyXAT/NSJfiHNnkFT5h+6dmx37Vmqp5RLB///jYAN7CBV33pn5bPPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0pNoZ59fm0VaFkivCF4gquo1FAAkx+AV4XSeRzAT64=;
 b=Z9bOTrbJDZeP0pY/45CUhOE11F5sKd6fRFp05g7IPGIsJdaLiSXwUNV90Aqk7lgBxhcJ9+YIHfCzxikGptIjJ5EhkY7euwRd4w6u1iGZ69E9Z37PAhgI1uMCHfgn2slGYfMpZdffR/YGsMY4B/5v2fnwARMeRCGddYfw3XJWn58=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4513.namprd10.prod.outlook.com (2603:10b6:303:93::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:40 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:40 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 16/21] mdrestore: Add open_device(), read_header() and show_info() functions
Date:   Mon,  6 Nov 2023 18:40:49 +0530
Message-Id: <20231106131054.143419-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4513:EE_
X-MS-Office365-Filtering-Correlation-Id: 039842c7-31ae-4a14-3f70-08dbdeca0de6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ARr2eU+82RnPlB2TWH1w2138xxs2Fubs0kkxJ3COoSdvIqwQL1TYjtt3LUVQXhnAJmfeDRp+NMhziwKh8Hmoj23AqZS+zyWWS3jjtzONjsMOXsjsnuiCtIZE3ls4MdcAdNjzsrtx3zV9Y0R3NsrbV3cSFUxzI9GVC2oNRHYs+Gdc5WNCKOoo2APHwNuaAxBB8KhHQ2/FZXesFi5+KgpwIuw4FRd2AgnAZXxALNV6ymS8MzWXJV5AWUKXwjpl9lErLO0dp+5L+TSceBWy07/VjO4/wiVFL3E+K3/HhISA4OgHuifa1FMBUCijwKNiakBI438pG8t+cdol7osvhjzA+nhzLCmZe8DPMLLnYA5KkCFw3zPictrAl4AjqArj9BZRWAc9H/DbXTqqP1d/hj0iW7nnzPfj9udBaN6qvGphDg9/Q+QIR9hdNjakbXvfqi66rqeDTq2o3wwTR+D5x/9K86QRLG7Vsx7AAeqVlf4igRX7ZackCyWO2caktZhDWFkAGznHvBjLcHgyPo0sDmYQKgH2ZFXyESrUYAdmC07egDxiVGsyUO6jR/R+W0DDNFIb1fiWFh5Q37zv0sMjUehUIz+K0Y8fis9bwPyYLKCt9C5oO4J0SrDuTn1bj187KKs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(186009)(1800799009)(64100799003)(451199024)(6512007)(41300700001)(6486002)(66476007)(66946007)(66556008)(478600001)(5660300002)(6506007)(1076003)(4326008)(8676002)(6916009)(8936002)(316002)(2616005)(26005)(2906002)(83380400001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?STMoi5sObPATiyEY49/Qnlvna8aJz3NHlmi0akeqy7y137S6AVJX4GhYNe7R?=
 =?us-ascii?Q?LkY9VCx6MMeIoJUzqAAxE5K0JgYWMHXXzUdcfk8CNfDlVMsTeh5gQcW8GLaJ?=
 =?us-ascii?Q?D2B1h/SZdbRCscj/KeS8ShyUfc8EsNWCe+TY8VlswOehzmI02eGVkboDNlQG?=
 =?us-ascii?Q?42JnQlXY+u7rcWJgpLwhk5Cim4RzW93Ay4FTK0ouENAHzgWXChqwJxR3JAXs?=
 =?us-ascii?Q?rOpdiNii7AjM6EsQXod+K5DGxiJt2fsQDLhxQfNvqPsNQ6NPWuW4E9WyyabF?=
 =?us-ascii?Q?1BgX2KznDgl65wnvDJiyMaDJDzgWeyD3opLYFek/qP8wQq2+ou/9sqTsQdKN?=
 =?us-ascii?Q?wrR1HiPbzM1ZheYhLVjqg5xToOcj/GBBGHNc4J2uM1qCdrBj8bhhGZRDzIhq?=
 =?us-ascii?Q?b7tA7E4/nutHYLQwoN1GlOl2Odz91n9oisQvlnxzmGq9SKm4bOzXNO23uv5b?=
 =?us-ascii?Q?BQNdj+2qUZ430IOuClFFBndtUYkK8S2HT9qAx9qWYs64petKJxQS5CXz90DC?=
 =?us-ascii?Q?nECYVYB1iEEp7Rbq5F5ONfoZI6DIQ2lnhozKzzsAnxTF43d/rxc5voXEenoB?=
 =?us-ascii?Q?J38MaEw8I8PDL+c1jkaNSmE4mz96xeJJo+dQjDyRMS8Fr0MZOYJ7G3W4u1Q7?=
 =?us-ascii?Q?/Ut9H+OlVRG+BABYXbS8ngj5StaPYd4ehfX9ijvAxyWFNd2ouF+OXC9A3tkr?=
 =?us-ascii?Q?Mspx2VV7Ni6n9Mm59IbIGBrNetcrkP7Ip32pA8edftwAj9LHUFrM4wFK/JMU?=
 =?us-ascii?Q?9lOpDRgX9+DRb+tnPfZ+s2KpjWSfDk8XXRKxCzqx/eqPyL+6At9Bu9XtdT4O?=
 =?us-ascii?Q?ZfphZNdrby7LyJE1bdOWmCJw8y1IpZOX1qoNEYaSfvv7E1+H6/Zq2yQXf5sC?=
 =?us-ascii?Q?/zkBkjmvibnQXDAMKkNOe6ZNyQekoyK82U469xfAvh4XKast3wmjz0nGfJlE?=
 =?us-ascii?Q?f8uuOuaDBVeiUaVD1cyb+wIDtVTNTp35EunvF3Frp6rSdCr/uRhXklwTPan8?=
 =?us-ascii?Q?KZm+i5ksRCRCtAMloZ4FuZyuR63ut3bEyCt2z0DUCMvDUafTquVfKIZ5IKxv?=
 =?us-ascii?Q?ofssXTBGTFVExLKypK0ha0JHVzCHSBKvs1SyV8BArMdTXGbBo9WasasAzRLF?=
 =?us-ascii?Q?UBN8wJO1ir6b8eNDgSiIMkAV6CEqpCRFIVlpz5p6RS6QJesDY754zz7AOb6I?=
 =?us-ascii?Q?bY448xvlYUank8XcJV6CG75rAxx1sYH8LnY0P2eXtcHTszB3sxr2pr5L6AqD?=
 =?us-ascii?Q?aE2kCNmhHqlQCvtJikPHpO4j56gSAZiC1TiJ3KJ9Jm2KfSIbnn9lqeyDNRdL?=
 =?us-ascii?Q?fP0qRD+ERZ4paE524Am7f1/sp2qcF/W4KC/H2NvP0PK0hr137rfePV8XSR9m?=
 =?us-ascii?Q?Auj1Ec9sCZ9Tv2FJrW/7cbnjtPHNdDMrpJ3HYuOv2u6R1OyCugKsZTDPjP15?=
 =?us-ascii?Q?synT9A5uRER57yj1vhw6GTDkJw30Aj1QaLeVAfXhHxq7UVJ4yIMiFfPpV53x?=
 =?us-ascii?Q?fq8Bob18ujVIyqW+ouzl6ub2aK7xqSaY5Zm0FgZh7BW2e8gSfAUVQb6qaw1p?=
 =?us-ascii?Q?l3gtjKMP7717mGFj0A3A6b5g+BcQK1MHmsjVhTWd2Mh75mpN1gylPR4t2r2I?=
 =?us-ascii?Q?Aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +nEgoZ9SNLWm61Qs9g9ZQiP2T6AsqVNmHp9ZIVCvKRnTlWhZ9d5EbBjv4j5H+Sg+cUKe7cIY3EuQhwfYUMmljsInVAMXI4eXDwRJs89sc562ct4B40eeFSLY9aJ4GA7vZKEfq3LnBjFvZGCT4/E7UXomQF+6fNSZ5STklaG3NXnIsI4sD9uyKy/798zVyjNL53zQu2LsvnyZ979cMy9KUT37N44j+AWvGuUl9madzkHCEhM0pHl9VLfx7y2PzSAo4w3YQ21nnsR131HqZdIESYhVMsKoxlTatI7BUc58HGhStphlhqgUNuf/Uc0UEgO0TURk949VeJzKrDPCyRJKDffcrzMnX5XwDmyWeB4C4w22wdQ79SI1V/W5TtH3zuBsioA4c6JEDh/ws7RVjKvSkRAQoJdGgNX/l5lz7QOnqEplK8qqo7dFiMA0Ysze5tXEYrMNU8ftya9kTX3BWjdIW9+Y1IzxHOIPLR/y94mZbRX1DVtuOr3UB/WhbkAPfi5s8K9ju8TwvArZXWnuiR38PsNaKRk0dKnaFjnvtt4//FNN2EPdsAIVEhu090VQN/mJ0Zz21w6Tkqt2Icmcz48drqIoloOimaVX0QYvn0Zf8/kt6Kvog9MLOc45rwmN7lflGgG3d2nGbeQU3pYby1jhOYEOoGe+obbARF/MdDWcaY37li7P1Q/+A2xpmIDPBIibLgJU5uo3cTOeleJiKKIsmrwM1iH+kSjPfWPjxpC8yDTFVr+gntVzd7DKYCkHq8khNz09uO6c3ZVgmOiFPCQQujn7R3zU0QhiUODjmILd4bc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039842c7-31ae-4a14-3f70-08dbdeca0de6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:40.3976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hB5nR7U5JXGP9Ps/kFuz/b0PJFYqiD4QJR4PywouiV7iexfxHzFNpvMmbaBfbSWT3iE7xlduMTpcnMGXjcjfBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060107
X-Proofpoint-GUID: j084U_1NgrbBdS4aJRNc8uWvPINvIzJc
X-Proofpoint-ORIG-GUID: j084U_1NgrbBdS4aJRNc8uWvPINvIzJc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves functionality associated with opening the target device,
reading metadump header information and printing information about the
metadump into their respective functions. There are no functional changes made
by this commit.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 141 +++++++++++++++++++++++---------------
 1 file changed, 84 insertions(+), 57 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index ffa8274f..d67a0629 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -6,6 +6,7 @@
 
 #include "libxfs.h"
 #include "xfs_metadump.h"
+#include <libfrog/platform.h>
 
 static struct mdrestore {
 	bool	show_progress;
@@ -40,8 +41,71 @@ print_progress(const char *fmt, ...)
 	mdrestore.progress_since_warning = true;
 }
 
+static int
+open_device(
+	char		*path,
+	bool		*is_file)
+{
+	struct stat	statbuf;
+	int		open_flags;
+	int		fd;
+
+	open_flags = O_RDWR;
+	*is_file = false;
+
+	if (stat(path, &statbuf) < 0)  {
+		/* ok, assume it's a file and create it */
+		open_flags |= O_CREAT;
+		*is_file = true;
+	} else if (S_ISREG(statbuf.st_mode))  {
+		open_flags |= O_TRUNC;
+		*is_file = true;
+	} else if (platform_check_ismounted(path, NULL, &statbuf, 0)) {
+		/*
+		 * check to make sure a filesystem isn't mounted on the device
+		 */
+		fatal("a filesystem is mounted on target device \"%s\","
+				" cannot restore to a mounted filesystem.\n",
+				path);
+	}
+
+	fd = open(path, open_flags, 0644);
+	if (fd < 0)
+		fatal("couldn't open \"%s\"\n", path);
+
+	return fd;
+}
+
+static void
+read_header(
+	struct xfs_metablock	*mb,
+	FILE			*md_fp)
+{
+	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
+
+	if (fread((uint8_t *)mb + sizeof(mb->mb_magic),
+			sizeof(*mb) - sizeof(mb->mb_magic), 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+}
+
+static void
+show_info(
+	struct xfs_metablock	*mb,
+	const char		*md_file)
+{
+	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
+		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
+			md_file,
+			mb->mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
+			mb->mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
+			mb->mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
+	} else {
+		printf("%s: no informational flags present\n", md_file);
+	}
+}
+
 /*
- * perform_restore() -- do the actual work to restore the metadump
+ * restore() -- do the actual work to restore the metadump
  *
  * @src_f: A FILE pointer to the source metadump
  * @dst_fd: the file descriptor for the target file
@@ -51,9 +115,9 @@ print_progress(const char *fmt, ...)
  * src_f should be positioned just past a read the previously validated metablock
  */
 static void
-perform_restore(
-	FILE			*src_f,
-	int			dst_fd,
+restore(
+	FILE			*md_fp,
+	int			ddev_fd,
 	int			is_target_file,
 	const struct xfs_metablock	*mbp)
 {
@@ -81,14 +145,15 @@ perform_restore(
 	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
 	block_buffer = (char *)metablock + block_size;
 
-	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1, src_f) != 1)
+	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
+			md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
 	if (block_index[0] != 0)
 		fatal("first block is not the primary superblock\n");
 
 
-	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, src_f) != 1)
+	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
 	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
@@ -111,7 +176,7 @@ perform_restore(
 	if (is_target_file)  {
 		/* ensure regular files are correctly sized */
 
-		if (ftruncate(dst_fd, sb.sb_dblocks * sb.sb_blocksize))
+		if (ftruncate(ddev_fd, sb.sb_dblocks * sb.sb_blocksize))
 			fatal("cannot set filesystem image size: %s\n",
 				strerror(errno));
 	} else  {
@@ -121,7 +186,7 @@ perform_restore(
 		off64_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
+		if (pwrite(ddev_fd, lb, sizeof(lb), off) < 0)
 			fatal("failed to write last block, is target too "
 				"small? (error: %s)\n", strerror(errno));
 	}
@@ -134,7 +199,7 @@ perform_restore(
 			print_progress("%lld MB read", bytes_read >> 20);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
-			if (pwrite(dst_fd, &block_buffer[cur_index <<
+			if (pwrite(ddev_fd, &block_buffer[cur_index <<
 					mbp->mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
@@ -145,7 +210,7 @@ perform_restore(
 		if (mb_count < max_indices)
 			break;
 
-		if (fread(metablock, block_size, 1, src_f) != 1)
+		if (fread(metablock, block_size, 1, md_fp) != 1)
 			fatal("error reading from metadump file\n");
 
 		mb_count = be16_to_cpu(metablock->mb_count);
@@ -155,7 +220,7 @@ perform_restore(
 			fatal("bad block count: %u\n", mb_count);
 
 		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
-								1, src_f) != 1)
+				1, md_fp) != 1)
 			fatal("error reading from metadump file\n");
 
 		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
@@ -172,7 +237,7 @@ perform_restore(
 				 offsetof(struct xfs_sb, sb_crc));
 	}
 
-	if (pwrite(dst_fd, block_buffer, sb.sb_sectsize, 0) < 0)
+	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
 		fatal("error writing primary superblock: %s\n", strerror(errno));
 
 	free(metablock);
@@ -185,8 +250,6 @@ usage(void)
 	exit(1);
 }
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
-
 int
 main(
 	int 		argc,
@@ -195,9 +258,7 @@ main(
 	FILE		*src_f;
 	int		dst_fd;
 	int		c;
-	int		open_flags;
-	struct stat	statbuf;
-	int		is_target_file;
+	bool		is_target_file;
 	uint32_t	magic;
 	struct xfs_metablock	mb;
 
@@ -231,8 +292,8 @@ main(
 		usage();
 
 	/*
-	 * open source and test if this really is a dump. The first metadump block
-	 * will be passed to perform_restore() which will continue to read the
+	 * open source and test if this really is a dump. The first metadump
+	 * block will be passed to restore() which will continue to read the
 	 * file from this point. This avoids rewind the stream, which causes
 	 * restore to fail when source was being read from stdin.
  	 */
@@ -251,11 +312,7 @@ main(
 
 	switch (be32_to_cpu(magic)) {
 	case XFS_MD_MAGIC_V1:
-		mb.mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
-		if (fread((uint8_t *)&mb + sizeof(mb.mb_magic),
-				sizeof(mb) - sizeof(mb.mb_magic), 1,
-				src_f) != 1)
-			fatal("error reading from metadump file\n");
+		read_header(&mb, src_f);
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
@@ -263,16 +320,7 @@ main(
 	}
 
 	if (mdrestore.show_info) {
-		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
-			printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
-			argv[optind],
-			mb.mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
-			mb.mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
-			mb.mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
-		} else {
-			printf("%s: no informational flags present\n",
-				argv[optind]);
-		}
+		show_info(&mb, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -281,30 +329,9 @@ main(
 	optind++;
 
 	/* check and open target */
-	open_flags = O_RDWR;
-	is_target_file = 0;
-	if (stat(argv[optind], &statbuf) < 0)  {
-		/* ok, assume it's a file and create it */
-		open_flags |= O_CREAT;
-		is_target_file = 1;
-	} else if (S_ISREG(statbuf.st_mode))  {
-		open_flags |= O_TRUNC;
-		is_target_file = 1;
-	} else  {
-		/*
-		 * check to make sure a filesystem isn't mounted on the device
-		 */
-		if (platform_check_ismounted(argv[optind], NULL, &statbuf, 0))
-			fatal("a filesystem is mounted on target device \"%s\","
-				" cannot restore to a mounted filesystem.\n",
-				argv[optind]);
-	}
-
-	dst_fd = open(argv[optind], open_flags, 0644);
-	if (dst_fd < 0)
-		fatal("couldn't open target \"%s\"\n", argv[optind]);
+	dst_fd = open_device(argv[optind], &is_target_file);
 
-	perform_restore(src_f, dst_fd, is_target_file, &mb);
+	restore(src_f, dst_fd, is_target_file, &mb);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

