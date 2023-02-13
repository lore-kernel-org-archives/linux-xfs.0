Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4ECC636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjBMEGJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjBMEGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:06:08 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A08AEC58
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:06:07 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1hv18013414;
        Mon, 13 Feb 2023 04:06:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=FR6tF5TtJM3v+akPzWFacrvBj7M6PZ4HqEdSoRgPAxQ=;
 b=QliQshga9MBnJcyaM5JVUV4YSho36xzi05pkthD3fTjpPnDu6QPADYeD3hGQQUaSkzhY
 g0Zmc+9psBf3l/u/+jiYout3ESxRd6EI1wcKTDlCncAx2AaeSbs75AXpf/gTHODBBjqD
 ibXapm7zk+Mc3yEJI7Hoj2xHOyt+bCIYm6pp+G70bAbJvUucM1W0EwdhwC5M3xjA4fCh
 +rS8GiVfe4XuozhgQO8B3o3lDgzNJTniN8XRrlHPfVL0c5+x9YaY+pZzhhtBDxtQ3lFw
 aDITn72YIeM+XYN8YL+sAZHZdyMRGxnCwrqU4hedJTLCIrjCDgMXP9wQmn1TJXsgx+eP Uw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np32c9ucq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D2iUUr028784;
        Mon, 13 Feb 2023 04:05:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3a9gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNd0WzBba/eb5NQgPjSFUm2Y+WEHvYMHZDHExxuSAgeP04nLfVJ9uNjXYqNqoWEnTysnJdDiHrclLtE4sWkAAmbpr7XM7oSdWOUxqOTPI0BiR+f1H5Nu/LvpyPmaHUJU5zyh8tV+WSc0rNRaaZ1iecIyvqMA0Uu7GLte+k/I0O1J2ZXgdO4oaBfL58f8ZFNwwx0mZxtCnrrw08R4/i26DkW0vXu9ELl7g3s6U3/JeF7lD+zR6Y6xlAmxzz279DNG94KAMGj0gbO/DjB0TSzgKhWzHVq4OpDbUXxr7i2tfkR2KAQz8lp97ntnq+gFCWskrwHHVPHDI4VYHMyTBR7W3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FR6tF5TtJM3v+akPzWFacrvBj7M6PZ4HqEdSoRgPAxQ=;
 b=Fr8q68veaQhveMTEk3bkLxIRhV+F5HEJdZ6sTHtYeM7W6ONepb7ifG7X0CFj0+nEmvJ6zpbW70sEfaMgxiDlf9wHt9BVPfsELETqdV1J+sGza20Wbb8s2EB1S5gRrZvUYjdTlemiBjNT3mRMRZm1hmCd9XyLe5OmlbnmbVq2AzdHhkkgC4ORdTEyyXlDx+TBHIhtcbMsRE05QPuDYi7w9uqRWyrfNfzO2g089XksKdDF9kAcH3I9+WqQU1neHwQ6UmXoVhpGyqKnwlFYLAtA4lUOOG+wo630tPAunkwD9xjpg2cPnITddNMH7K9eOUU2zU3ObhApz36VBZ6v8B4l5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FR6tF5TtJM3v+akPzWFacrvBj7M6PZ4HqEdSoRgPAxQ=;
 b=Xa5nLl7bgbQEoZUoXugQpE55BZdUsP3GX8PfHDKAOuP3zwyqAqKjm+SZUqIxnWhwiK/T/GKA4T7oFJE7+eL0JT1+emm+vXwqKaSNqUtD5ivpQuWlLu857Ud7AzswwyV1EGG87n0F6ZGpzr5uJzZHNy2fmueCrK4jXdHfUu1x0Ro=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:05:57 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:05:57 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 08/25] xfs: refactor xfs_defer_finish_noroll
Date:   Mon, 13 Feb 2023 09:34:28 +0530
Message-Id: <20230213040445.192946-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::36)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c5d1ff8-ba66-446f-7b36-08db0d779bed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m5yiWkcLJmaDcMS3Chu7PDLCaOncD1KggxQ7C0h4hgLCGh1TdWa3emEWo5h7fkZlscIzt9O3NGR1Xk7eMFRIH8UoZKW1Xj4S8f/d7bSJTtOJnJyAGDE8CZF5OELmm6Fi3L2+A2Zeq+dH+AhiYLQJrGAULsBxeY/+OpZWWB4ZTBay7WyE6PIFaFT9PRGdTNfYq0QFuwuSzDMUVzw0KHRwldEqocbRq65P9tQu84aHH15UAvcK9u6wLx35eYegFaRxc+5gvynN/3+0TBMANj159fq8DGajeS7UZeoxtLuAPyvKG681lTZYzyXN6IO3ZZDCq0/AShtI5KkiRs188XPNS4E+6odLZ/w98RV5AB97ePy6L8Xg1TkQaNtBeFOTnv5wWNAUzp+tl/dG82cvVl419W+QpV8/YeMrdC05jl36RpPfciPSYh3XbpP7aTUN+0jP79cJyN5LuqMIY3FEBH24cMB3te44S/F2jOWNyBber+/kBodi6FwZsHQwrgQ6kE8i2T4TBHTep1O0Vld4VBI5Rwt6JNhZRR3phJ9AccgjNzP7ByFpj16+9S7TtEX4qm8VsZbufl30J+8b2KCjwZ8n/drazPCkWCV8Z1fRqLo0DSf7mTahlwvkJYqlNJjpLFYRn2c7eiNLkMRcS1IYV7omCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ntec+VT12FfwBxfbLc7vHSHuJn0pXFdjxpdciE4e3eSeO3xpRAdT8ybSZt7B?=
 =?us-ascii?Q?2yLWZU3ZeMij/Vjpce1t8jto7uSenx0SNYbhf+v1qAFGJ9Y437rrLDyqnXAL?=
 =?us-ascii?Q?5+h21mpNvPxaVDk7JPMSdCFz8VaBvxq38vsLa6TS+3O7ybcFsnZIKXbwWL5G?=
 =?us-ascii?Q?NwUOw1q5yqc8RjHoVHE9z8PAFsiEIo07cEeAx+NgAo8JNt3Q+xWf3rFltuhu?=
 =?us-ascii?Q?V/hL/NPGjqtGclfoQWm6opqeGLAIJTSeEIFVXGURlT6sO8ycnDPdoMFVy4qT?=
 =?us-ascii?Q?dX/me6gtL5/a4P7SWqKjITeF3nv6E2XZ5bukNty2OtVguh8SOTU/BrYinB0s?=
 =?us-ascii?Q?2HAgGlpgWd8xkGlvg8fDYYZHt5K0G0FOUJEFSAw5cJ3LddLMf7m1p6Ctsqhf?=
 =?us-ascii?Q?Wwif/TW0uQIWa2QpqP5OQ1xqhxExiigYQA24wA9HCyf0tsxje23Ziua6JyCS?=
 =?us-ascii?Q?FzIE+B5a2zaKqv5/P0AQ0acoIe7u7XLJsXyAE+Lil2T5rwUFHtDKejlgh819?=
 =?us-ascii?Q?RvpaC7SvPdAXWKUdRuuv5/+OEBJVaUk0jgH+l7PZpTPtolB/3DomJwKA1cWh?=
 =?us-ascii?Q?FpD7D+3YF51WyJIJATAE7Fri5qIyM7jZJgvNFFDsLmM5yMnCSGd13xRcUrc3?=
 =?us-ascii?Q?LTOkO1AzmyCPkZ8WBGqWUmbJFsk7PKzmSsNtm45hBPTmMFoAdHdpOXg24lbS?=
 =?us-ascii?Q?IFOS5Yl4/OqCgzz+S6GdUTO+Xi+59eRpYjXWq3TlOLAti0Z/yEYa5hgbKlOx?=
 =?us-ascii?Q?B4bsy13EOMOT+vMHvTCY7iAbtn4zOvpJh1cSo8YoLbghU0mbPAPGmIwQCiXN?=
 =?us-ascii?Q?Y9J3DhNOU3gefD5E6dXrVnwLO9OEBBF87TSxSX8AANyXXCn4fBDuaAWPxvmn?=
 =?us-ascii?Q?MiD3Jv4KRQ2shqY4vqxs25wRea7m7qT0jWkrHBHY8oAODSSxaK4HMeEXoBpW?=
 =?us-ascii?Q?x6m7r3t9gFijtsIWzbnsxD/krwt6L4I9K2VekPdKJXRUaoGBDQRImngQyxTg?=
 =?us-ascii?Q?04PIkEmMv1h0SN/gFYPaXZNusMBy/3/Uunac41uEa+hcsgrsaiA5baOfSnLd?=
 =?us-ascii?Q?cogL1y+NrktU3d/jDUzJz1d8G7Mwm7/9nwetq5pZDmDlEU0CcjSHGkIgs8er?=
 =?us-ascii?Q?BLEQptDYySFF1MTIksqHwU4TfZngEYESWvaak01UQGkFjraEYCwCeOYTIge5?=
 =?us-ascii?Q?vRxw62mSwnVx4YeZ7vuQZMWnaLdbaRhOuQHAjSBc1U1qgLWM7u9YisnjiysH?=
 =?us-ascii?Q?CciVvYQ/Juh58p257I0PLuXYNIzuSXetP1zQ/NU+Lfzxnzqvw6+pmuqyw4xK?=
 =?us-ascii?Q?UBW6Cz+wf7VY/xxoSw0D5HJVT2xNikGgZVScpA6qaR86Kbn29yEBzNo3FngD?=
 =?us-ascii?Q?IdWorU1s9tUf9n7OkTDLor+FDJtK1uIUvK6/qJzJssPtFRV7X5k8UTKusdSN?=
 =?us-ascii?Q?gptsVqXiwqf4DYqcGl1VpTHFEU/4/DfWehAVpJngBmsWYrI2dP6lSrQYnU1g?=
 =?us-ascii?Q?rIqB62ud684KbquXG2OW4JBDdeNUCajQnfJ2LqOZV7TkFgAT615uQIRC/ykM?=
 =?us-ascii?Q?mdidM5I2fmCkkbCaa3hqF3mPVAM7IzAHw9oe/00josiqKU/n7rPkh2rdXC4l?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yQsxghEN75Dp+rM7KuxOVOhslxi8ZBF41n/+4UmAOceXO7YGj1KcQ/IL0UFJaxkrfgxhkAncBwtD8CprQ77Pg5v1OjaUT/nSBLAwCPs8ngLaRiq0qRuBGwdjAR1QJmsHRhkes6M+HsbFw0UnoM/O5TLpZoW4cy8P+zp4653Q38Ipi/zGqJAeELGWtFsAkWswJnbaPcDKGe9w9MR7DoB8OufUt53CAdcbZzBZZ+81rbGVgLSNLI/qcdFcriQxR7qbCfyhF4uXL6O50sBjRUeM1Qv2PgzKT77gtQLjeag25xa4bDWga3PQ1I/wygra7eGisYz6lGcCCeQUgEj6uQ3HaRC7kQhyPm9oFQkzP+X5OXXxEXKa5s6jZqJQm5kMY/kCDfa4NOgD7QPk2aV1hBVBm6OfgYbG0z6kPWoT9AO31q2HG/bh/ZBghR4SArXxHn9kz7QLy+ojpCqG199W+ObhX9VVupCmQhItZ2kSuA98f0tdl8clpeYmzqICYnNVYtlcRVlt1WMnpT0ZiOClfjscueL3GxbDkgNrwieZQoH6OL19GDk4eUXiwaA734AzYv+ZnXM0UxkJtAseACFlpmjYY7VGV+uw4LnB6vxZpZ644ht3mjcKSprBW6AWxIctg02qJD3HE1Izjg5KYICcDkxQ+YbMXVPPDUFnRofZN9dtS7lS+7Q/EaF4tJu0rtT1k3Uz9EpRXvQH9NcnV4iQFI+sBGJbwromeHq1yAUFJFaUa+/Y8HyagDxE8bKY8R2uaY0YsH8ogRveKu7UNX/vdBnhV70eE4nY4wsAXvO7e0hd3EOmN0T4IvSifoz6GtWzaXEI
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c5d1ff8-ba66-446f-7b36-08db0d779bed
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:05:57.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bgl9E5AtFWcat1ghw3ZoTp+ytzK2SyUab8FZrT3xeJwQg33P4wFK2tXgxY8HH1CIjOecIYaO/3scrH6T5ftwOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130036
X-Proofpoint-GUID: NxtXVCJu2VfxkacfsVDJoA6MHSovjxKY
X-Proofpoint-ORIG-GUID: NxtXVCJu2VfxkacfsVDJoA6MHSovjxKY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit bb47d79750f1a68a75d4c7defc2da934ba31de14 upstream.

Split out a helper that operates on a single xfs_defer_pending structure
to untangle the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 128 ++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 69 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index f5a3c5262933..ad7ed5f39d04 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -359,6 +359,53 @@ xfs_defer_cancel_list(
 	}
 }
 
+/*
+ * Log an intent-done item for the first pending intent, and finish the work
+ * items.
+ */
+static int
+xfs_defer_finish_one(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	void				*state = NULL;
+	struct list_head		*li, *n;
+	int				error;
+
+	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
+
+	dfp->dfp_done = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
+	list_for_each_safe(li, n, &dfp->dfp_work) {
+		list_del(li);
+		dfp->dfp_count--;
+		error = ops->finish_item(tp, li, dfp->dfp_done, &state);
+		if (error == -EAGAIN) {
+			/*
+			 * Caller wants a fresh transaction; put the work item
+			 * back on the list and log a new log intent item to
+			 * replace the old one.  See "Requesting a Fresh
+			 * Transaction while Finishing Deferred Work" above.
+			 */
+			list_add(li, &dfp->dfp_work);
+			dfp->dfp_count++;
+			dfp->dfp_done = NULL;
+			xfs_defer_create_intent(tp, dfp, false);
+		}
+
+		if (error)
+			goto out;
+	}
+
+	/* Done with the dfp, free it. */
+	list_del(&dfp->dfp_list);
+	kmem_free(dfp);
+out:
+	if (ops->finish_cleanup)
+		ops->finish_cleanup(tp, state, error);
+	return error;
+}
+
 /*
  * Finish all the pending work.  This involves logging intent items for
  * any work items that wandered in since the last transaction roll (if
@@ -372,11 +419,7 @@ xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_pending	*dfp;
-	struct list_head		*li;
-	struct list_head		*n;
-	void				*state;
 	int				error = 0;
-	const struct xfs_defer_op_type	*ops;
 	LIST_HEAD(dop_pending);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -385,83 +428,30 @@ xfs_defer_finish_noroll(
 
 	/* Until we run out of pending work to finish... */
 	while (!list_empty(&dop_pending) || !list_empty(&(*tp)->t_dfops)) {
-		/* log intents and pull in intake items */
 		xfs_defer_create_intents(*tp);
 		list_splice_tail_init(&(*tp)->t_dfops, &dop_pending);
 
-		/*
-		 * Roll the transaction.
-		 */
 		error = xfs_defer_trans_roll(tp);
 		if (error)
-			goto out;
+			goto out_shutdown;
 
-		/* Log an intent-done item for the first pending item. */
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
-		dfp->dfp_done = ops->create_done(*tp, dfp->dfp_intent,
-				dfp->dfp_count);
-
-		/* Finish the work items. */
-		state = NULL;
-		list_for_each_safe(li, n, &dfp->dfp_work) {
-			list_del(li);
-			dfp->dfp_count--;
-			error = ops->finish_item(*tp, li, dfp->dfp_done,
-					&state);
-			if (error == -EAGAIN) {
-				/*
-				 * Caller wants a fresh transaction;
-				 * put the work item back on the list
-				 * and jump out.
-				 */
-				list_add(li, &dfp->dfp_work);
-				dfp->dfp_count++;
-				break;
-			} else if (error) {
-				/*
-				 * Clean up after ourselves and jump out.
-				 * xfs_defer_cancel will take care of freeing
-				 * all these lists and stuff.
-				 */
-				if (ops->finish_cleanup)
-					ops->finish_cleanup(*tp, state, error);
-				goto out;
-			}
-		}
-		if (error == -EAGAIN) {
-			/*
-			 * Caller wants a fresh transaction, so log a new log
-			 * intent item to replace the old one and roll the
-			 * transaction.  See "Requesting a Fresh Transaction
-			 * while Finishing Deferred Work" above.
-			 */
-			dfp->dfp_done = NULL;
-			xfs_defer_create_intent(*tp, dfp, false);
-		} else {
-			/* Done with the dfp, free it. */
-			list_del(&dfp->dfp_list);
-			kmem_free(dfp);
-		}
-
-		if (ops->finish_cleanup)
-			ops->finish_cleanup(*tp, state, error);
-	}
-
-out:
-	if (error) {
-		xfs_defer_trans_abort(*tp, &dop_pending);
-		xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
-		trace_xfs_defer_finish_error(*tp, error);
-		xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
-		xfs_defer_cancel(*tp);
-		return error;
+		error = xfs_defer_finish_one(*tp, dfp);
+		if (error && error != -EAGAIN)
+			goto out_shutdown;
 	}
 
 	trace_xfs_defer_finish_done(*tp, _RET_IP_);
 	return 0;
+
+out_shutdown:
+	xfs_defer_trans_abort(*tp, &dop_pending);
+	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
+	trace_xfs_defer_finish_error(*tp, error);
+	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
+	xfs_defer_cancel(*tp);
+	return error;
 }
 
 int
-- 
2.35.1

