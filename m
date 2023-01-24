Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B5AC05027
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjAXBgr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbjAXBgq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4811ABD9
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:45 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04VW5021126
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=qrjaC6on7P1f1IIFAufUalKhEDkqTKv80LdtMA/ewIGCdAr1zjuoMkeRIRybJQwTp74h
 uKXWDnb1FKJOGRt4RmujCyt2KWx4X+vmg+y69MgtWADLiQf9ltFQxIrjfhT9ADhDXZMk
 3e9tZpVK8ep/UTI4NFohCvA+bZWYsJbe5VbezHfTBOrj63yt7NS+ITfQTwxnj12g7Ahp
 DBG5902Qg+IpThRuHOOYyGBild1J007845DaACljk6EB4GjjFWWm7Ri5NgsEZv9iowCz
 ZYWVZWA3j3C1hYaF59Sv1Zzq5gnWtMTdf0/zQxaQOv7LT5m80GxQhmtXuUvlVBpQQ7Gu 8A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa4a1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O1XqUg040224
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:44 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4a82q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmrI2kMrZ5DMlBFhZ1X8S52H+MFgZb6Fd+MRqpNzTk46NSS+6wgJrJbkIFCGXajY6FF32i0Z7Oh3KidcfCM9Ul7Sqa71XFAlP77uYnJTnt0QkARSacNdqRFPjpa5ubusLMKzy159kuZ7tdYEIYE+hOPnYjZSMzA1XtQMsuIawJEmY+Dpyz95cxGRjPKf+m1PiMpT3u/Hicw+ubJ3/irVN2zGKSZ6kE+w3qIZT7uyYBWQjhGXt0ikQXJKdKogW84vBJor4jUR4/JgIZtoQQP3ah2c7A3uyYy3qrmurUVnmC8GPVl+N/aVyCA4BwZkNjEe2xX8FMJnXhxGFzgAdjw4uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=JcSBPz5U08Q2oKhLaqTl4S0NZg8Ya1HspHhuStjol1F3usmSm3h6fvezvVr3berfj2vQjYMLwWLA51RUK1TIHmlO1JEkVhdnwhpugNwCph54nmdFHd2ia6WFevcfW3g9z4cw80sYRa2VVo6903C/zaCKCrQTU+PrroCghpSdvsBaoOBTcQZ2gRhCmVprlcdDk8YXrejUoDZCFpiWbfCddCN2VIG/44SBKepBYrSw4mpnesWpYmfGViciaoRWXFMm4uwV1jcVeZBJ0TlJZ0ImFILyJw+Igl7Te9ZQl6+cP/VFGRPNf90qn0X5Awo5khg3Y7fmt0ugwnqz7ZN8zcD6fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=BWkF25LDnv48zCsnYJpOOfnSMG19DkefbbQgH+0kvFI4SvbGH8GvxIic+4TxrisST7EZfJCHUiwsNCJnRIYopbIuOqWHuP9rH8Ypex3oReFzvboQ1o7z5cUnwIRgOle3k6Q1/mF3r1UgfSLHNPw5yDpYRuHokeTTYHpEg/+SJe8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:43 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 12/27] xfs: define parent pointer xattr format
Date:   Mon, 23 Jan 2023 18:36:05 -0700
Message-Id: <20230124013620.1089319-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:40::39) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: ce6b838b-fb75-4c2f-8f83-08dafdab726f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WwxD1m2DiJUvYv+hW2bFOUnS6hRCfoucsCm46TB3nvBegmv3kaboIolj9q91BEOjldkWfDOFwUUR3ZXFFVq23k2xNS+NEypPDlRpwghNYDeP+crQrqX0JvGo2UxRfzC6vYSGFLfzASwto2DbAZymVzQSBPg5VDrbYpL8dy38nSqA63aOcjIIzQXtdl13kyz+R/bRj+iRh5sD13lRkgHjOLk8zS+xAMVv9LVB1YqqPjYFrNkleTboZNAkmk2xwnC4MnY1hDHnJ6aNt/JHCGBf9jj1sLUCEbMAVLWOATdT8oTkyynYeCqYtPN11J9T1OMv5S9Ce+ZzVFwdxhv1vklnwW36nF5sfanbexqWeRMbZ2IYmRsS7Mg8ZZuQz/bXl5v20WimYT4X9NNncVSEVaVx9D1wIEyp5GjWsjNqLp4bhT/gOWnrrkfOzlashSLZ12uOS5i2op0hzvkB4rfWARK87GhpkhxUahe/ZyF7XIYMFz0bxP0CHUMuPTcXy//yA/a3xuhLfmEa1pj+hCM9aWb13Pklbz9D6hokeAnjO6TLRJAiS+vgBlVGnFVU0o3zJsnmGi2v0rlhXe04ZY1m3iWGWLRRC8Cd+qBaKO3iYoiTJROW1YSZexw4Feva+KOJCSPhklLG8ZHBo4/PnTuVeCXdOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vCeF4N9WttlICtsE0WOxplCg6UNX0wsImlFv4VDFqP7IrkA3aCciPmutOB/w?=
 =?us-ascii?Q?6z77epYEZOMWlj+N8tXpK3u+SWp+LOZq4KCYYDAB1cFaRGCdvogfrToLRk/l?=
 =?us-ascii?Q?CPBvPZXWND+woSfN6030xK+LYtgE1Df6czl97iLWAWwvdgWIdYuLSClHf01h?=
 =?us-ascii?Q?L1bYUrX7I98sjaCfOLbXfa12LiRsu1j6oj/NMw84tblczbvbRJmZKzTUyspQ?=
 =?us-ascii?Q?yeIGnGMqS/ASOdNCyZrwBwAc1rPVjazWcNbg6Q+6vKHsErkTDuykHdzAsulX?=
 =?us-ascii?Q?3r1NttcKMF5CpOG23giNhj2iFxNEtwjoL+nwS5wM9TvCOdt34RddcGIJcsRR?=
 =?us-ascii?Q?47ztyeDoZ7a3WHB6zr94VyPdEmEEA1XDWcf2eKQIXYVxJUU87t/ZMtAHp5vF?=
 =?us-ascii?Q?79JRvi1/B8P5te6RI9iDOY329p8GMkjbjnfYqhKxMZ6Lo65g81DqgpmScFlH?=
 =?us-ascii?Q?1x3Lan5pmTegkDGhdPNFncMrFbCLw4uxF2KE55wzPoB6gQXsg8uAxxTa8dpV?=
 =?us-ascii?Q?x2KwWIM1yM6k7RKP9ZGquFMjWq9SB5EaAQS91qVUnJLWzbuUxtxrfIjKDAhm?=
 =?us-ascii?Q?LxfOSdPOGLdGijy6siHUynIzULpiOzZMZcfbtrfiW+3l71dwg0UFrQVBuyT3?=
 =?us-ascii?Q?4/63+HeVEptSBxewBbxyRFBqQzuu2dW4eQ5omB/gqL01UdGN14oe0IHIP546?=
 =?us-ascii?Q?09/EWBmVj3obGNEVZeIokDh6W8uYz11Dy94UD3Dx5bvtQeRIHr7bLJ6K8rdw?=
 =?us-ascii?Q?xW4fqzO0oZAV8ceEf5fcCwDee5675vaf8ADa2xUxbpAmogTuwlXtIhnMiXVD?=
 =?us-ascii?Q?VJ27caAN+hI1B65yie5Xb6CAe+N6Sz/GOET7YHPsoAz/MBUMpVX2C7oQPwBH?=
 =?us-ascii?Q?vIvM7N9HGIOJBa4WhfenwrQX7JFRuC5xGzzfircgSY6w0wmqtKJ+5vgmcB8/?=
 =?us-ascii?Q?MVj+bfUAZnxN1MZH8oyJFFkz8vOZG39XLTiVpuWU7gBt6dKsyaQN1MU4ww73?=
 =?us-ascii?Q?nEwyp8eys5cpWCjTrwT0YU+VZuO/mH1HmJJjQP62Cx27dptfla7H8iSSVThj?=
 =?us-ascii?Q?jxyeWono8wcCZYaJ5X1tavVMvMcKQ1SNw7VI/f75DdiHU7NpOLVglI+RVuf6?=
 =?us-ascii?Q?+w1ezek38y3zEjtBPDY5g8v924C6pQNYr74SXl5ytVqgysDk+hAos/+jyYa1?=
 =?us-ascii?Q?LBFHrh4dGPta4fFWaLlOOS3/0Wu7Bl4Pcp15XSDqXFY4qhYg165FDnEG4Zc2?=
 =?us-ascii?Q?Y+cey5WYuw5Yf1L9noGWRtSpc+HYD9nyUYCpP48reIieJDfgHW5uBE6dDsGi?=
 =?us-ascii?Q?pK82mnE9/40n4ZtbLW8qceqI3BRxywFQ8akKW5yaAwrldQ1m9+acLPXNzYO0?=
 =?us-ascii?Q?W4qrrfKEMq3MkJgRR0hn8rBa4uouKEBTE6P7g6JW6JpLiAZHeyPJeRIDYiKt?=
 =?us-ascii?Q?EgUz+UDZw4MQlqTHmYs6jn7An0f224SUjYxtSxrzSoBk17jX/LZdRxibNuow?=
 =?us-ascii?Q?s3MYeIgY8gKJEgW9rWnBmc/9RCov3U/5vmh9OnIz3jbMilOFjW6pk2UcolrM?=
 =?us-ascii?Q?zDyMYe4RkPIbOUnmtQ5iSua7OBPYSsSv0egqFvn4JOvppkdQAvmWjZfyyONh?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +DIQRLYlxXdv9KFgNZbhK04UKWlQyxQLlTVkNLfH6k1TB4B6V0URWCwci8ClnY1A6FRDEKp1gypIasc3qD6caD7i7NfOJqlhkPmasp6q22sGiTl0bcm/F0yssCd72YkwKDabQuj8N57XyKN/HLsx2+F8yqnMqL8h24B0/wP1unshW+4qIT3CZCEa1xCLQ4dBnOvdxb1tlSwF+ccrU2usD8Rf2yVJLfbbEKQWoJeD/Z9ZQBg04g9PKyWQNXODL640yq16ptFthEWb4s/jGXf9LX9doZE+egPi4PZT1TJnnbT18CFHQYZu3jMIVf9ZhBtMfKFvXdwOHc3KoGIV6JI+LZudwaMGoNkOupKxVyBC7WBE82zlvhTSpInNGMRWiNwwK0sXkkjqupxqM9K2JW2zYZ1Xl8SzxflcBmS2XnRYRYGBD/Tm4/R4s+qsDlrNgYjy/lKAaIY7MIMT0IYyW1J5l1ZAcY0zVKdtoRfLOc+0bR9EBp2efAvCBUL4cC14hTht/BBiUhasNUf3dZG/IuiRxqST4qc+jZYqqaXk0mK2nSCoz/hAkQJkB3195lJvb4Na5wzpRjlu7+Bz0CvNonf8UQlhMMjh2ux1QRjdn1Oc7so2ijtT+TjKkPD6IVz91rQfRZ6BLk9WAmX6tmI7DysNbIQLi2tCp1Hn0FHjHMyuwQ9/1lqAORIq0hzibdvhYc0jVRSUKKvh1ZqtEV1AUrUkjPCaa7bAR0p6CD9k22EDChhYfBtOF0/MDSQ21g4IqBrC8uARad/0T6RdJ1nDXs1ojA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6b838b-fb75-4c2f-8f83-08dafdab726f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:42.8901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efXQMPTZxnDWRY2Zjb41cY5T8fyNudx0Mp7+NyHbnKvrSQsPkRlBLKb8dQMbWyo1fxkqnYBCPmAp7GHRmj8DupVrR4gWrPq/tKi4BAIouns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: QrqvlUsJluCO2zPXvGutVoKxW3cVmdAO
X-Proofpoint-ORIG-GUID: QrqvlUsJluCO2zPXvGutVoKxW3cVmdAO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={parent inode #, parent inode generation, dirent offset}
        value={dirent filename}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the dirent offset in the EA name, we have a method of knowing
the exact parent pointer EA we need to modify/remove in rename/unlink
without an unbound EA name search.

By keeping the dirent name in the value, we have enough information to
be able to validate and reconstruct damaged directory trees. While the
diroffset of a filename alone is not unique enough to identify the
child, the {diroffset,filename,child_inode} tuple is sufficient. That
is, if the diroffset gets reused and points to a different filename, we
can detect that from the contents of EA. If a link of the same name is
created, then we can check whether it points at the same inode as the
parent EA we current have.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 3dc03968bba6..b02b67f1999e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -805,4 +805,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64  p_ino;
+	__be32  p_gen;
+	__be32  p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_DA_FORMAT_H__ */
-- 
2.25.1

