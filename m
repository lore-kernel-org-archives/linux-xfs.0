Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C8DEB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjGXEjW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGXEjU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:39:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FABE122
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:39:19 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36O2jvwK026582;
        Mon, 24 Jul 2023 04:39:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=xEWaFAbyHH2V/17Sp6MiDF164eKFDN9GqVYTyJdTgyA=;
 b=bYUu3q5CB7z/975IytZDWsm9q45lLkTY4Eic273XAxDBpz6nxoux8WX1Cy8MgRKNaryR
 NqqyuVSBPqRZeR0avn9lN5mqhq+82eFtz/ct5z1ghvuQA/MReIhnhPvIulF4sKSfc9er
 Dy63SCtVWLNUpFqmwjNwESlBIVmuJdc91pu+9sbD0RBDF0nhLfTPgXU3EnKAHfxLvFY1
 ISOtex2IPbj2QhF266lwikIqKnpIRAhQo930R1JDIAgkgsDUzO29HScn+i/b8oOuL2PW
 z/IVAT0ptcFLTzRRg/Y6wn73Gj39SE/PmwNmx6mJY45y+1tXVUvblH1IUr6AuNIuR7Ld /Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05hdsva9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:39:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O10Yqv035396;
        Mon, 24 Jul 2023 04:39:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j2x8y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:39:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JERpOUSctDnsNDPMMnx6RB0IA4ZKa0P8V40eA46R5jUHCq2WyuAWKKJsUe1TF7dYLfzTZwfB+qD4jXIyrTfZl8IaSyBI3t+4jH9i6550isOMuO5JyEfOr+3TB4jloKKsu3sKStSGUtZnDJm7Wg6R4akSN9cHCgehiV1MB9U53j961M6lWi69zMo9zcsSQxZYtXm5sZfjXViM12s2z8dBjF0oqvRPmhohUj6iYES9+DZszIGpBvx0T5gw45x50MxCceVPh+u0LdUTllvkRWa7+4zAPlwVI8WSOvepYcemQQBMiAoaQrC6GPQHIUuKToYbmBT8eVKd51SJnylhvOSYiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEWaFAbyHH2V/17Sp6MiDF164eKFDN9GqVYTyJdTgyA=;
 b=nW/6IezXUZuV7rToRE+oT34/GeBMSq44JoN19OB9sJObUTcNaqp/KUFNnch6UkbwR9GytR9OID6e7H2iHOe0bv2xDrLLX/vAljWJcP8VmsNGdU5mARbjHWEUOEFsoc8Z00ksHq/yMIBE/Ay/QVmxf5uZnCrKU+8TITETyTHdxv2EBr0w5fETTolUZsba50d0lRPqWXlCUo2/2oZA6+Suo/HIOJddXdyEWpBlf2io5S9q3kqKplVOO29QoSxrz/iIO0gs0PljNI925n745ISlj0dx4rc0QUb+GKY480KRmWQHzmJ60+hNP9Ft120Gxk+EP6dnQXjeqYZYEez9fBdWkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEWaFAbyHH2V/17Sp6MiDF164eKFDN9GqVYTyJdTgyA=;
 b=v8pquqOr8fEN+ownejx4mN8az32tpQZg0AnfgyWh/UfUlxfrqOb2U9wSfQJuMwxYl9SnIgXx0jlT0H4lu37tqlASo/y+JCRp26ugR7cSpYfqw19mS0tW/M9tbaaaA8bDbVagZdYxyYKqtTQbRR0haQ5wir4R/t+Fsjf8+ksWdB4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:39:00 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:39:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 22/23] mdrestore: Define mdrestore ops for v2 format
Date:   Mon, 24 Jul 2023 10:05:26 +0530
Message-Id: <20230724043527.238600-23-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: cbbe88ac-a0e3-481f-3e81-08db8bffe66d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DCChk27fMkGBFoIh2s+QLolAQzAuQ6F7T/DhqRAxzTlIaj41dN3F9iXxYJbPhbrHMOv99xWI3IoblWjLtfctaBrH6UTgTU06/UgD5FDSTU2cK1pQal5XxerddGc2dFtRrHNt/DqgF+N2b3ScxRaM4PQ9j4rtQlbz+T78SSFiZQLhf225bYhI8A4Xd16UY6pcLBTAnLAlNsHhFJ/PLlxC1AD6L9A+qzjnIeMniM0xnfoi8tdlLb/98MGUe1BxBx9Tq+I6aXvQ0vUCdnmqOG6Kgnuxeqh4kzZJkAArtzAGRtaYeldjqN2wo4Cclw2LpboL/aHjYiDEhxb5Oreq3TWkQIwiPVpl+pXPT97tQgOiLjIvjL/8Yxr7WkbITlSLROkSaJs2GrXYPzvqtyNfFt2TS5pCIxFj4NB9jBdHx8pa+FiuwhSJ5cYPhCYECzk638i2bF532AylZgiUASW1v8ZtwP9grWAW3cWd7lLXC6DD4IVPt2vIXl2yCx4o/4WDA6d4QbYd1PAR973PEW6mMjQ7UREDOSVpNYmPlrLd25bAqQjenkv2hIhFy/I3Jep5p9+y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?km6SKh0vV47Me+etSfj5M/P6EQRFXFcZmHIHZ/cKBc8uH1UEWxkz8wrWQM1B?=
 =?us-ascii?Q?MKkrBYcwe5ua9aH/2rFRca4ol+aOkh1Pmi9Bpj4/fO+eqFvzFjo0fc/ZvJ7Z?=
 =?us-ascii?Q?nW8/PezwdppM/QXggMM7+SeZmXA878X5YvgkyJU5iXbLH1vZkJHisnvTomMt?=
 =?us-ascii?Q?Y60vr/OioawDf/WenDivMRGXtxXXrH6QHCDYwn6EGP38eIBgFDGa8RNwFUJQ?=
 =?us-ascii?Q?KgBLWIaV04DoA77411FLBLqSNA+aPWTQHg8Wipjzi8LnERJGq1Sr5pgStDvm?=
 =?us-ascii?Q?kENGTUMIYoQnz87rpQf7ftIn6tLJvfhswSa+YYn8r24NEckBql6OZctrvURx?=
 =?us-ascii?Q?cD7jv0QYrp8VjHW2xJUJ/Cs58xEdGvK7pWgr94v362QGOaRU5Wnw7b7gkvhr?=
 =?us-ascii?Q?uqHmap4jyzuTrRDE4nzHTQh2JpBNoG0JMNt+0XxXy8qufcXFnRDucziR7pco?=
 =?us-ascii?Q?zcLsoiVdJrfs0vYDacCDDYH0mN2fsyEEn9Y30t+kJ0VGtX4Oy9xtHEb7Ml3e?=
 =?us-ascii?Q?ciWDLtxLWYeaBzbVqD+FmhOQibJcvo4VSkN6e+ScJgufDU0gKujdy0MQbu7E?=
 =?us-ascii?Q?6To+naMk54ZpbcN6nNf1BxifU3sf9Jne2VEW+L6or1WON4Gy7klfDZ7dt8NR?=
 =?us-ascii?Q?PXEXhxXyxYKHkCAW7TAUM0Tfl1KyrYsGJLP40RYnRo/gYqa84lq+zA4jRKaH?=
 =?us-ascii?Q?T0Ymm+WNLCY0zWWDneQmuEiOVLKmjhPhJWro4oX+Q/CusgDV4PS3/xM2bQfh?=
 =?us-ascii?Q?Sa5BVKrymFoyGOPzcJGbHNoKKEdPXLb3WfozSggZPnYiEaeRY7GT3BFNA51f?=
 =?us-ascii?Q?YW8wfEFuY2wOM6fy5qh6nCrRR7Yyf5dnG37cipJ0TvJTG7xsrzHB2WQRSCNX?=
 =?us-ascii?Q?4aAPqc+mTrj1KZBHtW16eY4eZjHWDEOqPBJPUMOCK549wbh3nQhOGr33f8XC?=
 =?us-ascii?Q?fZdRdZn3GWhEEDB0VDf6Z0Jyr2cLvTNLwZRFPpvdzXHWfBVBIbyhDopsVbBA?=
 =?us-ascii?Q?fAct8Y/PbWPUhUehrXdsmjBCRbpP3kqZkOOC+l8V9mFyDd+uWfscsp+ZqInC?=
 =?us-ascii?Q?6LqS4y4YfmLTrTTNfW0eiu+E1NcpWzg/6yY7cL/8uB77sDTPLZdTc0cATnBp?=
 =?us-ascii?Q?9ByCYyfY4rdr4V8nxHOT5fUviBLLpRWS6uMVtSi5QflbwOKscGldqc+tyMQx?=
 =?us-ascii?Q?2alYBH18Dm1JWC6t8Tuq1QEL9C2NkQfD0fBf18/MhS+wtK63tDHxNTa4cT7l?=
 =?us-ascii?Q?CraDtafE6WgOMYDV5+fVW5WUrTWPcHzh2hu6jHhZUqFS6r6q5MD3gU3bHm+9?=
 =?us-ascii?Q?ayKWsTrcWV1c9Dg/xthTqdXGvrisGfNTLMCe7ZsJZVNmk/jisfiYDfi3LMTV?=
 =?us-ascii?Q?gaigoCdW+vzAVDn04CQzMWMcEtYBs7w/1Mvv4EV2PgyDGVOqLUaSYbF939fv?=
 =?us-ascii?Q?bBS5FniMBG6cas/J3lof2V4E7Efc5jeFcIbyGc7onfbyLpyLz8appgnmefUK?=
 =?us-ascii?Q?Ne/QEKyYPelWew9xTLs1EMrs6admuFPqaEVx3EVwtJq7tW3OhxJl1gC8wsZB?=
 =?us-ascii?Q?pb/NduxkRtVzvqclgkZ3L/eBF9iH4zNGxR0YuzMT9JVkJsaTE4jLKAI4qEja?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RuupYuwb9W1FnZCjDSAouHsLN6sWqZ8ZgYxG7aq8DeW1xLIN5MP1iS+z3KhQiIiyJZ06uP2IuvQ5VtmXdWnQwzGrSMeED9dph3CmbV5OSLX00xivzB2TziPqd3Px0jUSiQ8PG9hQpHBp40SirOaOrBSFEUxX6FzJDSP2qbLlYfKMWDTGn3XE3fQq4aqhw8TZ8XYM1IGssqQoPAcR8A0OMwfng+GqeOTXCH6kvygpNUHVhaepcXlofJHM82rO9B2APoM1s59k6nGDa3IHsgvhpbYiO5m6QZDNlbdAWy5k/Pna/IoZ/Hc3CvBHU+VUy1cxV5uqO1ntdBKjTuv4pP0sqY8uJoGDYAH/Wgy8eHanOgm8jXEizQjEoAVXe0Iu9HeRy6ExHN+fkYbC1mcnMjYfbaHIUzEu0iybISn79Mbl+ytFScB+JitodICSjS97MAlziO5gGnBWV7GQj0sA68L/V8t/QDJBOMU+w8MY96Gw+M5d1LnKQEOhV+1uOPZDzk4J121Cbs7O7hGN/iftfdOsTiQwjXRXXmUOAs2gnv2tl70PZXA8RcHw9QRyhXhNDFbxVQ3+sAtSKlSYdI0PY6LxPr7X1MPKObk+pzLMgQ7Rghqo0Wgfnvd86dRunlfo8jXzcYpYo5T3Lu+UflqLify7mWZvM7sxh/wAifB3x/jB+yv/cD7QpHtjvjvi51unOKwOKyFQBBsvKsLClZ04F4dnva7ADwqsgndLUV6nMxv1GZ0vKartSaWIqNASUka1u/rWx/NTtffdmbM9Kmy0+ZfLe5/Poay9/5c4FaA3YTg32JE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbbe88ac-a0e3-481f-3e81-08db8bffe66d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:39:00.4993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjartHdS2JuxH3NrMf4Xf95BOwycLfyPviBzZogQrrphsCaRfXeKK5R+7+xp5Ed0ZzeEYA6idjeTZnDTDGxKbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240042
X-Proofpoint-ORIG-GUID: OOeDVXJskFbUmPQ5VdWpm664VWex20UH
X-Proofpoint-GUID: OOeDVXJskFbUmPQ5VdWpm664VWex20UH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to restore metadump stored in v2 format.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 234 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 222 insertions(+), 12 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 0fdbfce7..85a61c8b 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -9,15 +9,17 @@
 #include <libfrog/platform.h>
 
 union mdrestore_headers {
-	__be32			magic;
-	struct xfs_metablock	v1;
+	__be32				magic;
+	struct xfs_metablock		v1;
+	struct xfs_metadump_header	v2;
 };
 
 struct mdrestore_ops {
 	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
 	void (*show_info)(union mdrestore_headers *header, const char *md_file);
 	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
-			int ddev_fd, bool is_target_file);
+			int ddev_fd, bool is_data_target_file, int logdev_fd,
+			bool is_log_target_file);
 };
 
 static struct mdrestore {
@@ -25,6 +27,7 @@ static struct mdrestore {
 	bool			show_progress;
 	bool			show_info;
 	bool			progress_since_warning;
+	bool			external_log;
 } mdrestore;
 
 static void
@@ -144,7 +147,9 @@ restore_v1(
 	union mdrestore_headers *h,
 	FILE			*md_fp,
 	int			ddev_fd,
-	bool			is_target_file)
+	bool			is_data_target_file,
+	int			logdev_fd,
+	bool			is_log_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -197,7 +202,7 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
+	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
 			sb.sb_blocksize);
 
 	bytes_read = 0;
@@ -258,6 +263,193 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
 	.restore	= restore_v1,
 };
 
+static void
+read_header_v2(
+	union mdrestore_headers		*h,
+	FILE				*md_fp)
+{
+	bool				want_external_log;
+
+	if (fread((uint8_t *)&(h->v2) + sizeof(h->v2.xmh_magic),
+			sizeof(h->v2) - sizeof(h->v2.xmh_magic), 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
+			XFS_MD2_INCOMPAT_EXTERNALLOG);
+
+	if (want_external_log && !mdrestore.external_log)
+		fatal("External Log device is required\n");
+}
+
+static void
+show_info_v2(
+	union mdrestore_headers		*h,
+	const char			*md_file)
+{
+	uint32_t			incompat_flags;
+
+	incompat_flags = be32_to_cpu(h->v2.xmh_incompat_flags);
+
+	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, %s metadata blocks,\n",
+		md_file,
+		incompat_flags & XFS_MD2_INCOMPAT_OBFUSCATED ? "":"not ",
+		incompat_flags & XFS_MD2_INCOMPAT_DIRTYLOG ? "dirty":"clean",
+		incompat_flags & XFS_MD2_INCOMPAT_EXTERNALLOG ? "":"not ",
+		incompat_flags & XFS_MD2_INCOMPAT_FULLBLOCKS ? "full":"zeroed");
+}
+
+#define MDR_IO_BUF_SIZE (8 * 1024 * 1024)
+
+static void
+restore_meta_extent(
+	FILE		*md_fp,
+	int		dev_fd,
+	char		*device,
+	void		*buf,
+	uint64_t	offset,
+	int		len)
+{
+	int		io_size;
+
+	io_size = min(len, MDR_IO_BUF_SIZE);
+
+	do {
+		if (fread(buf, io_size, 1, md_fp) != 1)
+			fatal("error reading from metadump file\n");
+		if (pwrite(dev_fd, buf, io_size, offset) < 0)
+			fatal("error writing to %s device at offset %llu: %s\n",
+				device, offset, strerror(errno));
+		len -= io_size;
+		offset += io_size;
+
+		io_size = min(len, io_size);
+	} while (len);
+}
+
+static void
+restore_v2(
+	union mdrestore_headers	*h,
+	FILE			*md_fp,
+	int			ddev_fd,
+	bool			is_data_target_file,
+	int			logdev_fd,
+	bool			is_log_target_file)
+{
+	struct xfs_sb		sb;
+	struct xfs_meta_extent	xme;
+	char			*block_buffer;
+	int64_t			bytes_read;
+	uint64_t		offset;
+	int			len;
+
+	block_buffer = malloc(MDR_IO_BUF_SIZE);
+	if (block_buffer == NULL)
+		fatal("Unable to allocate input buffer memory\n");
+
+	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
+	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
+			XME_ADDR_DATA_DEVICE)
+		fatal("Invalid superblock disk address/length\n");
+
+	len = BBTOB(be32_to_cpu(xme.xme_len));
+
+	if (fread(block_buffer, len, 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
+
+	if (sb.sb_magicnum != XFS_SB_MAGIC)
+		fatal("bad magic number for primary superblock\n");
+
+	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
+
+	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
+			sb.sb_blocksize);
+
+	if (sb.sb_logstart == 0) {
+		ASSERT(mdrestore.external_log == true);
+		verify_device_size(logdev_fd, is_log_target_file, sb.sb_logblocks,
+				sb.sb_blocksize);
+	}
+
+	if (pwrite(ddev_fd, block_buffer, len, 0) < 0)
+		fatal("error writing primary superblock: %s\n",
+			strerror(errno));
+
+	bytes_read = len;
+
+	do {
+		char *device;
+		int fd;
+
+		if (fread(&xme, sizeof(xme), 1, md_fp) != 1) {
+			if (feof(md_fp))
+				break;
+			fatal("error reading from metadump file\n");
+		}
+
+		offset = BBTOB(be64_to_cpu(xme.xme_addr) & XME_ADDR_DADDR_MASK);
+		switch (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) {
+		case XME_ADDR_DATA_DEVICE:
+			device = "data";
+			fd = ddev_fd;
+			break;
+		case XME_ADDR_LOG_DEVICE:
+			device = "log";
+			fd = logdev_fd;
+			break;
+		default:
+			fatal("Invalid device found in metadump\n");
+			break;
+		}
+
+		len = BBTOB(be32_to_cpu(xme.xme_len));
+
+		restore_meta_extent(md_fp, fd, device, block_buffer, offset,
+				len);
+
+		bytes_read += len;
+
+		if (mdrestore.show_progress) {
+			static int64_t mb_read;
+			int64_t mb_now = bytes_read >> 20;
+
+			if (mb_now != mb_read) {
+				print_progress("%lld MB read", mb_now);
+				mb_read = mb_now;
+			}
+		}
+	} while (1);
+
+	if (mdrestore.progress_since_warning)
+		putchar('\n');
+
+	memset(block_buffer, 0, sb.sb_sectsize);
+	sb.sb_inprogress = 0;
+	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
+	if (xfs_sb_version_hascrc(&sb)) {
+		xfs_update_cksum(block_buffer, sb.sb_sectsize,
+				offsetof(struct xfs_sb, sb_crc));
+	}
+
+	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
+		fatal("error writing primary superblock: %s\n",
+			strerror(errno));
+
+	free(block_buffer);
+
+	return;
+}
+
+static struct mdrestore_ops mdrestore_ops_v2 = {
+	.read_header	= read_header_v2,
+	.show_info	= show_info_v2,
+	.restore	= restore_v2,
+};
+
 static void
 usage(void)
 {
@@ -270,15 +462,19 @@ main(
 	int			argc,
 	char			**argv)
 {
-	union mdrestore_headers headers;
+	union mdrestore_headers	headers;
 	FILE			*src_f;
-	int			dst_fd;
+	char			*logdev = NULL;
+	int			data_dev_fd;
+	int			log_dev_fd;
 	int			c;
-	bool			is_target_file;
+	bool			is_data_dev_file;
+	bool			is_log_dev_file;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
 	mdrestore.progress_since_warning = false;
+	mdrestore.external_log = false;
 
 	progname = basename(argv[0]);
 
@@ -328,6 +524,11 @@ main(
 	case XFS_MD_MAGIC_V1:
 		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
+
+	case XFS_MD_MAGIC_V2:
+		mdrestore.mdrops = &mdrestore_ops_v2;
+		break;
+
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
@@ -344,12 +545,21 @@ main(
 
 	optind++;
 
-	/* check and open target */
-	dst_fd = open_device(argv[optind], &is_target_file);
+	/* check and open data device */
+	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
+
+	log_dev_fd = -1;
+	if (mdrestore.external_log)
+		/* check and open log device */
+		log_dev_fd = open_device(logdev, &is_log_dev_file);
+
+	mdrestore.mdrops->restore(&headers, src_f, data_dev_fd,
+			is_data_dev_file, log_dev_fd, is_log_dev_file);
 
-	mdrestore.mdrops->restore(&headers, src_f, dst_fd, is_target_file);
+	close(data_dev_fd);
+	if (mdrestore.external_log)
+		close(log_dev_fd);
 
-	close(dst_fd);
 	if (src_f != stdin)
 		fclose(src_f);
 
-- 
2.39.1

