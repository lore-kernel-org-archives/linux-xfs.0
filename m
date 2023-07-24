Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B20C001DE
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjGXEif (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjGXEid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:38:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964991A3
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:38:32 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NNuM9t005467;
        Mon, 24 Jul 2023 04:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Yl3FzTgUJfjrEq7AZEebnnSonrYepmNRkzX95UwiAys=;
 b=BM6TG0OiIbU6XR9bhsGC47X/Ns8XikfoQ8FPJjQillhNidmhdpHYYwrgDJF9LyQFtgHE
 GYE5Ket2uHIwDuaSBa3WpCdlnsZyEiYr/mk2bHViEulHfNfbY3s9Y+VrTL+olNgPUpS/
 YjTpO0vlqNVPiDGbzWTtuKRZtcD2Vy+DJ8+sJQXGQIe8uL210WWfGH41L6GUl17ynz6F
 CP9dRvam2sx4D2VeTltrgiZGOhJRLiyUuKPcGsLO6JjVREVE/cGKVIpXtqEkIU6x6vUY
 C/ZEiJsn1K27vd4w7+fjoTWumsgwYHCnnRtmiZqx9FYJmxLZ1jEgY5Cxlg7j+qRwtX2P gA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05w3huw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O1qTRI003866;
        Mon, 24 Jul 2023 04:38:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j2x9f9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRx9dFY9o8ziLUWUYBk5NduygIG4+DN24izNOjq83aqelmEe0YyyWaNZCeJ1RA+S2PLp/uKDke754KwkeC8Ltx/dOP9N+uKTamlyvPi+ndyKqe1bNeyjHpptkne/zPGxc7LDwYrNa8ngioUuRLK1EZ+kZB3gK2fsk5JuXwSS636f4x4FcIN7xei04jIZjHOb0nJOBsC0MIhoo1g3UQQ1VLhsuPs+htZEOzdyuDX9oIUWIrSq6QZh+GyduyQ1hnXWsT6mipiWSHFayrunaMvZSmRgCFTWygAU3f+c5nkx/aQ09WZ4yVQApBW2Bit0u3a6TkAprM7fW5KYO6HCBT/DOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yl3FzTgUJfjrEq7AZEebnnSonrYepmNRkzX95UwiAys=;
 b=G7LnN7SCu8YWyqQ93d1UXqPm+94nUf25zLi0ynb2/JbY/KYCvbGA/LFPNzPpPRNUWHvqRAQtMTWBGtJzeUDy9ZWYprytvlAs8zEOI8J39jM/Hvh4v1v9Rh/yj/pHbQfcaCh5Trn+X6qSzNQp/jD3Gp0K29yQtA75KCstNxONf93XY8cbemvKcq69MzuY/0Biey9vsFmUOoDxRI7dAciRtrxly3ex1vxjs7o/mGQPfBKcK0cXitzHpiPLwEeOdSpeLacRESvDyWEJuuYag5hQR6zAK4U28sFy0wm9v0jcLNavBoSrOKNlYSgkC9VGjWZdTalMKfCsnr+xDK0NWJZRIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yl3FzTgUJfjrEq7AZEebnnSonrYepmNRkzX95UwiAys=;
 b=IjSd627wkzI/K8BMfu7A29KAmumFtqd+SqyPduwLd5xtgvlhUqgl8TScIDyvcWf7PfAQQs5+wiNHGX1SQ+Njj4upuWDB9e0KAYox9F5Ro/c+diohhGPrAtJV+rNrca0W3Db4Z8bq58FYqLoU+OfPPrhbBU8LrujDdsxVy+PzxAU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:38:20 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:38:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 17/23] mdrestore: Add open_device(), read_header() and show_info() functions
Date:   Mon, 24 Jul 2023 10:05:21 +0530
Message-Id: <20230724043527.238600-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0116.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: d454c8f9-ea5f-41a9-5a02-08db8bffcecb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OZzbwlbzbRxkgrNJCRTQHo6XFlRgtRI6tbTwjiaBK1RRjHjOj13JnWaqR9b1bldqGuaCFmlmUtte7QIHi60LXo2KJXrCrU46tS37mdr7bc5qCOg1NS1sdx8Gu41AU4yj/0NIXG05d8DrhnFBjuJWnFEPUsFKCk1a37kxJT20DZpuPSli4gE/p/bvYwbozprQEqwBakOtNuoXyzZNVcRn8sJ9KFRpGo5OwDrQKdmW14onLStl+sWJUfmXLQ0fgL6q28KcCk1uNOnO7zRWoAqXTaUjextgA0Mtt8EQnUqzCJF4b6C6j7OZS/hylwBbW7DKYptd2T7Rf1qxyqWm4owI9qUiiom1JHDr/DxZEReZntSQENdbu+aqT6qw+etHr/BUxX+Z+HicHiIJ+FitL0lHe40wqjMa9uHVc9ald8vAWrMGuI+D9EFOJtXwrnmRl9r3W20PThK92+/fsOM0MPXrR5SZG0w17Bkj339HJ0PHRYfPwPBkqMSBciQ9v7mh1XhB5AdJ1VlHL3aataPyhtge5RRin5up1HJ7t8vMe3y2gUqZAPM1aK+6cgFtCokwe2OQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8R3EGO9Gta/nc2GIZ1znlx1AjHtvDDg6OiRle/y4ZtrATuYNU4pDOgg0Qe4l?=
 =?us-ascii?Q?kmTvYUoF9wWaKeFIV28XpLYPApsVl4s8Q4fmbclt7O46qUcCpCqrfdboITOw?=
 =?us-ascii?Q?OiHap3YwWeQ3IHo2/WogE1jrZFF0Ky20pybeFRpBqbx7WulKIHiGzpVVI40v?=
 =?us-ascii?Q?AZxgg8Vz7fifu0ecuQkM9p85F+1w8rRc2uaXKhz5pvlwykPKclrYmq6qIgXa?=
 =?us-ascii?Q?Es5mSGoY7Bi11NcM+KGop4QwHWWn5OHxaahJVi8TDYvk7mX248MA0PVCz89q?=
 =?us-ascii?Q?NONU4ylmhqP172e307Vt67UbFMYl4RNqhnu8Ft+bvNAXAtsqubcB6eCbFYbO?=
 =?us-ascii?Q?0i4O43lpBM0XmkK1pdKmAjf11ZfN5P5bE7yjzmUX2hgYyYudvQLmDZzHYsUU?=
 =?us-ascii?Q?Z7RiaIwoO1RSYZvFWDlcZ3DOzGixgchBKvqXSG+MJmPkPO1LSqzC6M2+Ck/o?=
 =?us-ascii?Q?DIszQGQoRWUc7VjyEIUSMNRlKIypE7TyCbbRRzIpAxpAkeDnrHydmAm2zZ05?=
 =?us-ascii?Q?102KrOcWW/Xllye6uJcyyoy7pXF6ptf44WJem8rRBV6UmYTnsU7/YjvPAYO2?=
 =?us-ascii?Q?AmgWQQJED5dKcvQGhkJUoYCt1wmQc+SkbZa3W76xZzSS42/4crikoI5RWx4Y?=
 =?us-ascii?Q?ZY5yRYa8NZOv7/ydVY5sDazYS1NvkHG8/8+ot6MyXJCjyPaHRsUyETl04K+k?=
 =?us-ascii?Q?BX7KvO9GWzVElXu0mbJzf4F3PnMe4tj38H60IHaH1luqFMI5pyoQe9ZbEFa/?=
 =?us-ascii?Q?A+upxEmZO+J8/J0OgrfGF1om8t1/emy2kJj3DbrGwseqeX8OtknlaQm0bku1?=
 =?us-ascii?Q?sbWGxtr9o6rouZyN226kxHSdRTF41bmU/DuPYUNyOXvoGegLQE6I6z0if8dt?=
 =?us-ascii?Q?fkfLihZY405h8qQnEKQbF60+dk78adZFDSydyXfmaYT9lIqMtWnbI95YJrqK?=
 =?us-ascii?Q?k7mKpYS5AHqdn+DmWmNp02I3kbFQIsTxYilLJPNgtACIjYmhFgV6Lfmlzfvw?=
 =?us-ascii?Q?xVm/plegq2YkppOatFlMnCucHxFLrOX7IYKIJ7x6o1gJnaSRjSjEnlpiaEG6?=
 =?us-ascii?Q?R/C+3e+ZdiPOa3y9ddABFxA84VGBrWySihi/wxvVtpRA9FqjQO1sh8137JJY?=
 =?us-ascii?Q?fwent89zx6YHjZBmuJjS4iv7a7H1o7MraZZQoFT/SnYo2uQuCKb4Y66EGXZ5?=
 =?us-ascii?Q?2SEwfxPp4cEzXV1Uawoj10CvypcUzzFQeV40+1d0u6rCvmEAuhem03zMmBVX?=
 =?us-ascii?Q?mMcZATKnn01hWk4VHG4TdDS2kaG33LYE+3ozD5tkiuk4cBM8FSrtMeQJjqty?=
 =?us-ascii?Q?2XaHsqR6iiauHoO1UJUSi+Ir0xVCFqRNM/YRKYwrPoucQixrxUw0tGHq0/kz?=
 =?us-ascii?Q?qsubBTLxsaIkaCHAHpSmWjizrtCwDKaC3obqepCPj38o78v2YP6KygsOV/sb?=
 =?us-ascii?Q?jLlC92goj/jNRUH3WKixECP0pRL4b3ruKtuVZQBHfEZ1jw42gO+QktOQ110e?=
 =?us-ascii?Q?MgiwuKzba3j7nhT6A+5Mxs6jPz4Iz4dB56nci26/w0ZvN6Vl6CQ3GRb/rZfo?=
 =?us-ascii?Q?cx3RD8qk1jIo5AvghX4Hdwa4oToD+AIcsfnYsU8E7SYa1QlDLGgjwpiuO7NL?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OCu2Vpy9teluMRVgJCfj25gE/B1w2zrrun1GC766ZxW7se6wOZEY8Si6+7x0U6r/noBZggYY35KrIlAXhvDV6B24JUvdWYnnY0eb4QS5R1ebVGB14CZMFiw3J5u4aIVVu5wT3jOf9FGWa/n1/uagxov5FonSScWotmyNSFjsG5XGzsnVAXowl7lHt8cPJoWJOdE+0/Ax7snWMAWbPgGYV7O3RpOQpSh7H8+J3TJJeZvGx+F5iY/nZC5QhcOpqmw8oKUQJKEYqickKkOKw7BsBTFrd2atIVMzMiTNRbC2Qx4P+bkrj5E+WpcIy2AzOIeyH0VAFW8AZ4uJfXR+E7YzXAkJ5X6mZ9Z+yz8mG3dnqB0shVRRlyH/qsu20Meiga3OMoZJIWLOpzQSWu5rG3x+LYpiODzBUicuQUGjlMg5Xx1cmo4v74b8qGO6jEMIy3td6O2lC4aeUEQw9oqMhQ+RMS9B8/29QumxlJXqJsW/N5YIDUM6kdQZSQ2d0kOKc0kNJe6ahkjUJxevbYMYziqp0DNcazfmIpnPAlCxlXrjgQ7cmqfnNUINuHRlUu3rbmOo2zyku+1VKb+ltOlbDPKfL6v+qTA1mQ1drlHyHyYLugw2S9RmB98WHoTSGsiynBnI72bzoy3cppK7oNF5LKwG/r+3ijJ0mvIqhCSIVZ4V4GB8q0xuyYWeLcVLdwex1LSdPlQFNLerH/1rdaPAy1Zgj4/KEY7mdjEmYoqWHIaO/B5Pk21HYOfpxGkG6cNpRjXDebeDZeEJZT74SB7dez7PEghZmg9TnrlgM7dPxJ3VDmY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d454c8f9-ea5f-41a9-5a02-08db8bffcecb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:38:20.8481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AN8rSNnOFBfuB/+ZBZc4auXI39lihtaOUaY5kDYCs6yPb+tkJ0liiq8Ylorf98Mq+OPAzYytR/OJvYkOgrwYsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240042
X-Proofpoint-GUID: N6ZsO67FMq2PtCFMITIQ9TTO4VhPCo4H
X-Proofpoint-ORIG-GUID: N6ZsO67FMq2PtCFMITIQ9TTO4VhPCo4H
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves functionality associated with opening the target device,
reading metadump header information and printing information about the
metadump into their respective functions. There are no functional changes made
by this commit.

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

