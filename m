Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925FAC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 08:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiEWIed (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 04:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbiEWIea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 04:34:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F0F11C2A
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 01:34:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24N4Fnfp026088;
        Mon, 23 May 2022 08:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=VjNKsTFT5gGrPpaxayInv+3j/Y4S9FJ0V/6a7Q1tptI=;
 b=YjWf52s9GJ7mnTyNaeGAlnHwI0TwsxJ7tn7VelMWwMKA+6ryJqLD+AbEjRqgVAXa7M8D
 kf1qJ/AGVxp2bVexotiK7RzZDqstmG8CPJmSSb0pQAxr/wq9MpbsBnOco+Hv5W2chhUw
 bDR4Fx2FgSm/leFLGqsKymkMWR5NMeH898pGJ3aXR0LXnY7We37IWZx71HW/NV+YceXS
 H2eC7/Abn1C27FKufCrL5sbKjEWnF2BHsRxFHKykGSgHUQcWHmySo2HCSvmhCfmSti4E
 djsgV9Gi/ZHCEUZQnMYP9DMWXqVzpO/6g9XrNxVJChEUCt9pgHbXEmWk+8WcDTAVYPJ8 7w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6qya2k56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 08:34:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24N8UUdk002715;
        Mon, 23 May 2022 08:34:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph1c9bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 08:34:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNWCy1sNXOQR+IjrBATnbcQbvuw73NOIhhZGzK0H2ejmhVfhiVIJXkeMihl9h0KlKpTc6ZXVywKeo2B60MYJBTLoupt1JocZt6yB+dDC28sm5VkLa2GS6nvBdv1teSnB8JLWbacSVH0N4GBDP7yEDvBW4JKgb1xYguy8SwDZbDPSdcMiz/oSBUL1t9iSHSihKl+6CxRQLGcX3ZMrqhf9S5wL2BeIy6cGsFO6d7lBonnxmCNazqMe7cfvuCTdhIs6v4Sdu7togDc/eEh7tyJrLZoHNrZ3DHziNi+AFf3exc98R1vW6EGVnVkVFLK/ZVX3VHBe4sDL111sj1subGmQkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VjNKsTFT5gGrPpaxayInv+3j/Y4S9FJ0V/6a7Q1tptI=;
 b=Vy0PWB93YceWCuanWN3IOoo6sDW9SnZlKMaSpZ+nefO9Hv3XMf+MtAni3T7uc8Cprs7suP6oXTEUkgnKdyswRddEeaAcyNn6dk+K4pfvGQ3rtna9Cj9Ml2xSQHH/inf8cs1Nch4/DBr6e6sXMN1YwbeBZgj+sTaBV9RmJ9U178q5TdwUk6d2AqGve5afGhEMnLrzecrscAl7/0hwZFB+WyAn0CqKhCt1PYHX1j7ETFBtWVEEwjKEslm46HMbe8fpJDZKaIyNSdxaXMw8APwqRnX7uqEXSndVvjBzj3R50i6L4fvd0O84sb56rvJ4bSasaIZZwamAiHTd4/JenlBduw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VjNKsTFT5gGrPpaxayInv+3j/Y4S9FJ0V/6a7Q1tptI=;
 b=lUUXwMBhRYFnd33MUuvZ1V54duJHmOv4QcaUGjlMEvH55ViQEyeIdgj4tlkevcZ7aFOW4VzME+miGpdodPMqbeBwosRmflVFHICtcWVC8p7SzOQzjWJIzvB9BOCos8DL798U1miD6jD8edCJB2qugVOsZeSKh164lZyupGszezU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CH2PR10MB4166.namprd10.prod.outlook.com (2603:10b6:610:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Mon, 23 May
 2022 08:34:24 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 08:34:24 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, sandeen@sandeen.net
Subject: [PATCH V1.1] xfs_repair: Search for conflicts in inode_tree_ptrs[] when processing uncertain inodes
Date:   Mon, 23 May 2022 14:04:10 +0530
Message-Id: <20220523083410.1159518-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220523043441.394700-1-chandan.babu@oracle.com>
References: <20220523043441.394700-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::35)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72f4ee45-4b35-468f-028d-08da3c970aaa
X-MS-TrafficTypeDiagnostic: CH2PR10MB4166:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB41667B2DE87961E8E13819BCF6D49@CH2PR10MB4166.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vVn5Mb2v6AG19MfLPGBKcNkzIZhWm+DeLXOGsFV5ffOBTYbN5B3/TWepWwzuMdYcF73oef3HmXogkClTyFAdedgl7WSnpPf0IM/UgOSaSt0WtzzWt/dBoG0eMtBwPdv7NhjgnYY17qH8non6zCe8M2CerXe8g4Ry55zrKJxHzd9+7JHzaUst1voyI1Tk0o3hgA0Ww2a0oWIDgV2nZGf8RNaAi3xCdVHDpD1JPbQpDk1n8I+xks9vXuFHD9KpJlNohl33AKUv7TVnZkSsAsi28hPybzF5761FlY118Swj/lUiaJtrQWZW4XaZM/h86jhp6Ed15QZLwUxUhc1r5RZDTy0WptnEn8ErPcqUO+ifQMimJ0cCI6KoRq8YBNKTyJHMA2UBGwsGugxsqBtATRRtVJ9mmE2M+yXjseriSYzoEpEK0NYQGck65CVBcMNF6EjKA3vYlaI+6TuuWRr7bIueSZNAvvcVAiPkEYwGxMJGk6pq6AvfefRbhiqHnzrcpaHt7TlpbLSqevkkbLgHOfHqP/WDwJMSlzE3ahaC0nD4gXbQuLCb2K/iV38m9XRGRHnNhVDaf1aqFXxQR8XZXtRc+5921FdFOg9JdR3nvhNawsz9+ogFAbwEoQl4pRZdVU+vvaws/tsn70o33F7n0qQT4h+Q+0J32NTXqz1oYemSSodDZOX4C4lTZ79XnlkyH188vXOm+5o0nEnDb9foYw5nWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(83380400001)(38350700002)(38100700002)(1076003)(186003)(2616005)(86362001)(6512007)(36756003)(2906002)(316002)(6916009)(8936002)(66476007)(66556008)(66946007)(5660300002)(8676002)(4326008)(508600001)(6506007)(52116002)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZChzOPKxoyoJQVOon4A9ClLZOFg9TLtgUbtOTIpOlpKtzXxSYuIjyUswh2rB?=
 =?us-ascii?Q?0gedW/OFmMJB3gUQ0nf7IgkgL6qEG2PZzaJCvwgnpaIoNlP7GyhAJ/B8KJbs?=
 =?us-ascii?Q?yqigpElI95R99v4ozosMMghs+ar5GVrZ+95JIerrlKvvZST5T6DT1qBtqoL/?=
 =?us-ascii?Q?JBC7pef4xOKIl3GzWT2TEGeO4UO2gN2PIWy2UAUIrCRGy88f397TI5HgWOSW?=
 =?us-ascii?Q?YvRj0KoXwn6tnpUBMXC8rNV7rIQDF0V6iqMFM/sCeV+wn8fkLVlRhPvOdGTN?=
 =?us-ascii?Q?jXAwC8ckbEsY4zWDyBlzTApvUY5j8tXyba5c7tioRlskvXgdMo1SRREdDEWZ?=
 =?us-ascii?Q?d+ecj+eB2dmDPwnyzWZfo+LjfjsYz6Fd5jEdNufWHRxzc2F3kzZuFLwUC4N+?=
 =?us-ascii?Q?GVLEE5JqY/FQW84PEra+6NidVIkudU3XyxF/5ci34MH8zY4I7GOq9w+55JYx?=
 =?us-ascii?Q?oItjhNY3al/H8xsfoUHGujqA3slK0f1HjpQtDCkGQVSDSb+zQGeCFGiZM0Mf?=
 =?us-ascii?Q?hRGSE06y0biOfENwzj76hxINNtAJPlfFnxOk3ze59Md6+kgrhqRRCjiSCWpQ?=
 =?us-ascii?Q?ZV7PgWJCoeat2FJokRrTKahq0jy95EuSwBzTy25mG2OJFSn+vnLAW8axDKQa?=
 =?us-ascii?Q?5IfLhkf0y3gb4w7z7extrG6QNYUVImEdjNUwoTTC/c1Ol6oYxa/9yxT9DJxD?=
 =?us-ascii?Q?hw1YmpdYQg9/kpc2b7W645F5nrXRD4ZEgVWqt40uG+r2KTi/7amoRrqOc9UC?=
 =?us-ascii?Q?4DtrJNMnosgEohKq8Crp3MlHrfUjD89y9BXHWfiM3gJgljprlkfJhlBylHIJ?=
 =?us-ascii?Q?WQr0q+9E6LgOi9QQnk1BBnIDfl0AtDSzNHj8fYbwpTlJuws04qoSRo23aZEZ?=
 =?us-ascii?Q?yo29fQk/wGAJmL5y2T2EGIpk6df4rzzC/KMuWstk1u7Wc/JJgv18zvR7oXRm?=
 =?us-ascii?Q?Pq7OADjrvxTG1PeigP24bXuoKqF+zPcnrirPUgAaf+Z92UjGncedrAPIWHmi?=
 =?us-ascii?Q?DDgsyrK/+uRwzGatiMW3Q5hliUDMjp3EXQRSSjRy+4IoeahTo0kjtd3sA8Pb?=
 =?us-ascii?Q?7XumMR/PYNujiHTP6waB7Ztz2UwKrhZZXCFU3L9bJZLGIbVAulwNDJKgeouG?=
 =?us-ascii?Q?VnSAVTQ05aVwCFdiB2m9ZbhSKpxgwDN8350pSIZIGo3g3M/D+iwXQZYksCRE?=
 =?us-ascii?Q?k36phAMv1gdnsQl8tekrmv2hFr2Wpv620x4jeGqHsdoEYHNlKLFefOP+zv6d?=
 =?us-ascii?Q?NjdslmtbilRaTa+7zlNnRe2++1fh53DSEMj08hSCy/dQzFO7FnFxdlr10u8C?=
 =?us-ascii?Q?/UfLyjudrZxrQXbDJ6vCDRPl2t4h/DOoeLMe5/raxFACZyuNXChxihxIU/Ul?=
 =?us-ascii?Q?kehMYtCSAtC5N9fwSKeZivyMwGQc7WCcJMAqHywvIHlh1L+XhlrZ+Epc+uL+?=
 =?us-ascii?Q?nmM1TGglNkOfkvv9NNG0mro1ithPhKZPP+/wRHfg8g27rrtyw61WH4qF+JmB?=
 =?us-ascii?Q?iIHBJXiCNQlgDB1uWcxgq+pHmsXldEyRA9qyQ3ozgpa9t8jWdIII8Jroat/X?=
 =?us-ascii?Q?+dsfka68glYCsQX2WfGf7O8xbw9iD9UmrSnkXis0mgCrNdA6X9IbXtkzENuK?=
 =?us-ascii?Q?iPgFvKraBT07DiUbv7qdrY9tuGp3muh3QZbk6BSCzT4D4Z691BDRr5eymbVX?=
 =?us-ascii?Q?wCCCqxb7vo5i2BoqzhynUViLOZgd6IkJS1JaEgsWu0Vkry49NKZmCkyATbHg?=
 =?us-ascii?Q?rqLeJJaQMg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f4ee45-4b35-468f-028d-08da3c970aaa
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 08:34:24.5956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CmUYEu/f4CeGtybSZF2yaMlYAFYqUaPimz9bkBCo6f61UgzUoOzZUNWrnjSFouZ/NnMVEZLVAHnCYsC7wZge7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4166
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-23_03:2022-05-20,2022-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230045
X-Proofpoint-GUID: YxUwl5SU471wv-7YEq0kYxcETJpjlyFD
X-Proofpoint-ORIG-GUID: YxUwl5SU471wv-7YEq0kYxcETJpjlyFD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When processing an uncertain inode chunk record, if we lose 2 blocks worth of
inodes or 25% of the chunk, xfs_repair decides to ignore the chunk. Otherwise,
xfs_repair adds a new chunk record to inode_tree_ptrs[agno], marking each
inode as either free or used. However, before adding the new chunk record,
xfs_repair has to check for the existance of a conflicting record.

The existing code incorrectly checks for the conflicting record in
inode_uncertain_tree_ptrs[agno]. This check will succeed since the inode chunk
record being processed was originally obtained from
inode_uncertain_tree_ptrs[agno].

This commit fixes the bug by changing xfs_repair to search
inode_tree_ptrs[agno] for conflicts.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
Changelog:
V1 -> V1.1:
   1. Fix commit message.
   
 repair/dino_chunks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 11b0eb5f..80c52a43 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -229,8 +229,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		/*
 		 * ok, put the record into the tree, if no conflict.
 		 */
-		if (find_uncertain_inode_rec(agno,
-				XFS_AGB_TO_AGINO(mp, start_agbno)))
+		if (find_inode_rec(mp, agno, XFS_AGB_TO_AGINO(mp, start_agbno)))
 			return(0);
 
 		start_agino = XFS_AGB_TO_AGINO(mp, start_agbno);
-- 
2.35.1

