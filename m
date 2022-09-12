Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98715ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiILN3w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiILN3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:29:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6846EE08
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:29:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEgVP003066;
        Mon, 12 Sep 2022 13:29:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4TX/I7XSyLRnrM563+ppQWOMAJ+KAOpNR3cpt/EZ3NM=;
 b=fax4OP3xtNLR4BWRcVovDTpT6c66uZtjKpClb4HwVl4UhRzS/tZ51Z21aPnrMePQBhe8
 ZTyFVTDbxUVbwY5mFRRo0afnLiNpa6k7Zw7h3/DEsC0LnNnOIAdq5YWufdhY/q/6gi3f
 TC+llhYQUVqyhgiWV+P1wUO9aSIjUDTEXT5K456u3OA0glBzEPunt7AQwVuV9c14Xl8V
 h/VaKeI8HKAxyZHYEaaJk5G0iwnRTbkvhrw4l4+jnSJBG4VE373tS+IaFGNX8X39Ng4T
 /BJUZ9u+y2k3httVBYKnZU9HpXAWd2zNmIKVQXsmxcxpY4nAK8hCPMBKG9m82MaYGzFb Ug== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgh61khmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgx3014612;
        Mon, 12 Sep 2022 13:29:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgk8n7udk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgutbVWpDQcrV4n8/J8HNd8zOzwoWPKQGAQJf8PKfORyxgTxjnDUmTZfMQqOdHMAIgOwOpGw6aQoqQo6271lhpKOhiDGCA0SIRjrTQ7jL67/vqd8KOZsBfsCNp1wfzXX6IZddV9p0/l9zocwDRVxamuvQkE7o/ICNQyyC8EjZ8HrpxBmo3wJXOYfHQLYqWpI4qdRx6q3QgFXHq/OiCGfz6wbBfkv7YFPWYoPNseJPw21SqjTWXr7bzzmPi+wU0y4IaeIX/5NsVpVgwYJBTFkfzGAfs4pJhPcm8Wuh5CaDkow/0i+peLmrggEm48rEci5I4D8KCdfPtmXBI1JEoHUxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TX/I7XSyLRnrM563+ppQWOMAJ+KAOpNR3cpt/EZ3NM=;
 b=V3GZP6fxXOE1e9dw0bCIfF/3HzfDzqKW55bHHPK4BqT0P/KZb8UwWObGUDSNjhaZBRETjOmS0R7eXCNI1blwR0rC6xXFcAx4hnCJeaOF/QVmxwUAQDw661sNWILTwwzw3Wta6Pi7VuvOA3UpHPzcr/Hq2O9UuM42vUNnRl8yTXXgUUH/vZ5c+7ghQPF/64wJxvJ5HSYnvQ8m+TMU/eJ4KTGCrNqhvLqJLepY6treVmGEN9mT7Si7MFCBtwTL8ifdeixI+oLQKRBQB0o4tNhYMVopWJ9I7KA5+qaJjOK+QpfR47bC6YyCHSRuXasnAH1IzB/VUo+j2JKQ4x6wKdJVZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TX/I7XSyLRnrM563+ppQWOMAJ+KAOpNR3cpt/EZ3NM=;
 b=hs30fyUMsgCqLI6ys3OziFaFXLCM/YVDNMpCma0LHgWp72ICTDzUWgroVLdle7aTxQ7SXvHbnb4dI2JE11p613p3W7QFmNWwruzZK1syds2XNoHJYkuv0BhiBtLMY9aDWDUMMyaRZexS79LtbfdEMDFzCuzUDqSQBvoXNvVaLOU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4318.namprd10.prod.outlook.com (2603:10b6:208:1d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:29:43 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:29:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 16/18] xfs: refactor agfl length computation function
Date:   Mon, 12 Sep 2022 18:57:40 +0530
Message-Id: <20220912132742.1793276-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0009.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4318:EE_
X-MS-Office365-Filtering-Correlation-Id: c76a47d8-d80c-43f6-7729-08da94c2da38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1N+zUcbm8N96iLw1zbrF+ddimylfNGAajrWJod3QaBtVDJbcRYuFT413UFhzI63RsByMOCs1Vsas/VfHJX6pzZqtvDqdEHu8E5+xWTPGy6aip562sqMXZp1frgc3jm1QJ0u3YQ4wwSn1j/V3WOOFxgySOFjHBbzLqeehVrKU7hhPjJ6g9fKZNyRztZVUk92uZ7VxIfTcxSVJqXJfaH6mfWfIe6RcTxO/jdTqB/EiuvcmPXtDdrjgkd4SZWb79bNTXwDETczMU9GoD7kAGT26lr928EK2FabReJsU2+i1qtrrKjZRL6qTAlfZl1QWoNmOXXM8MjZZpEowWtqMsi1o1fug9lhEqQMmrUrEwuFAiK2DTV8V2GUsF0eoRppSpwYwRFxHTSKMwLxB5KLH7MySZs2uuDSZnJkjNesalOGWtSMsjRTf/x5Dhfsr8yFAOz7+w35s0shOQwqKH8xdoA/QhkQEsauynYeAQyNnAHBqjohYTGFOzQxUpQm5h1JGkmziXeVEUyggWuxcn68nbUUxFi4CeVUIwMJSJg8TQ9SftkwGQhoVNyPNMUgfPiOgsOFXoKTbllJ/XkZ0FMnSxGQipd9M3wwj6hhtad9RcZY+VoWUuH1EUhA8kA9QtA7czE3Q6q1fvNNHndvCd2X2dRsslAg1Qv0tgboEyIVT0Yd24nSR6/SXUONj7kF0cIOojH6S/WSinib1MhxtLAiP8HiD5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(396003)(39860400002)(366004)(1076003)(6506007)(26005)(478600001)(6486002)(6512007)(186003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(6916009)(316002)(41300700001)(36756003)(66556008)(66946007)(66476007)(38100700002)(8676002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G5BMC998gmCOsGgQdVu9yEAhzlokF2kwopnZ7AUkVw04f5N3zE202z64296b?=
 =?us-ascii?Q?S0cYI3I3+nmuHOxPxRFNSyU8Vl674mEC0YRdUEo+lU/9L/ww+u9opOHJMIpN?=
 =?us-ascii?Q?VMWSb2GjXNpQ/I4dnqdfM89HRgip151c49FLDvEBqoySvGCyuJG/3J0IsSzn?=
 =?us-ascii?Q?vDLFYjTQRUUuyZGe+biYlnUk+a3deWVr4ostYFkU6oj2KW4coXjU+24eEoQ3?=
 =?us-ascii?Q?VsBrWb9GBEHUbZauHdUUfl8h4MEthsUvlkIxY4rMSp8qlbD/LS0ZilFVBwkq?=
 =?us-ascii?Q?EzcUjqabhCxFxvmDyDnczBb85hVCB+3SuCUIEz+xzdGWN0SRbDZIL3F1PbTT?=
 =?us-ascii?Q?eNCAjD3Ul1PxRzxUcW92fQLZfoHmF1poBAlzyMQDCShZI7eeSCpNvPaCtl+g?=
 =?us-ascii?Q?6B6PqNmeNnpTIJ+ojnG3d713ZOPMs+n0XCjfqaUfLg1rFYlJvADhfbpB8rK+?=
 =?us-ascii?Q?JYJR4XuUHNK6PdUNlc4U+ua7O/db+L53iyzVG9mWInRCBd9dQmSuehzGjjHV?=
 =?us-ascii?Q?xSxh7dB1StOPMh8UQpEo5temNHzAjU1XP92ZuxswQSJcp3prNqAHTpBlOJDx?=
 =?us-ascii?Q?93aW7WrLKXJKewzaDBeUFvHOTzKQInqGz3zERhiF6lBE7G8AUFLl8RUg5fH4?=
 =?us-ascii?Q?bqXlJKc7qViJ6ur5uNBu3nz45vAu8DLtUsbH2hbZkcqprwmW0lI7i2v4Mb/9?=
 =?us-ascii?Q?Mas5G7vPz6qwRA1CVTakp99y0dmSitfSL0Q66BFfGKmUsVvE4i1f5FSrjf/F?=
 =?us-ascii?Q?TssPBfwfDRDByG7sw+EmkxfBiFynz46Cz1+nB0stZcC6xtCiWdO7EKZLyIDB?=
 =?us-ascii?Q?sTCFZBBu8eWdIptapRq6ddan+C2GX/063qXqLxggwdp+PR6K8Vj/pX7YJ8X5?=
 =?us-ascii?Q?uMSy1DvQPTbfKjdUcnl4WZ1kUMAsxt9DJNBS1gaIJkDa6nyjjtSlqCIBqgU0?=
 =?us-ascii?Q?qbw/4JLy/QjEARoVptVKifXbgTbjF+Uw4B/5NTumzi1s1rXShXa1vQ8o49iH?=
 =?us-ascii?Q?R+OWirkyyLYoH2HmjZTSSPzSTYpEOd7hJx2wuRJrMJufR04LNZkQWkPnG44D?=
 =?us-ascii?Q?StaaNQN1xkoVz7DvdIOLmwWxjQt8ZoqL7nKmWZl0YUZ+WjUd7UZUVYXmF6L9?=
 =?us-ascii?Q?L9BSksRBpKW1b/IpmvDWed6x9C/DYeqpVBZZjPfrmTVbBdpE76AoBmznY1XP?=
 =?us-ascii?Q?5dgn6cwus1pyBWdPITbV/nqziwqE2eCH3LsWC8u46B15IjJcZfHxkXQyRgTK?=
 =?us-ascii?Q?5iPWGtGY0f1lINJngE7Ge3rzvcSuO6GiQOBCIVvDutC65TnIerlUsoUShZNB?=
 =?us-ascii?Q?vNSSmwAc4gvHUd/fPs9xWOp+P7j7GOUyx6QzGDYVsvCMYdTIY8GzxzkIU7Z3?=
 =?us-ascii?Q?BGJbJAi9y0xlZdyXcfXz+ucWO9uZl9Cj5Juym/Rwbptk80wdudXcSi0HieSp?=
 =?us-ascii?Q?gJ1ek7fWBU1BPqAhmFtWFi0WPCxT3lyPi3/XfQvPINCl6dlJ8KbFNL4SA0xA?=
 =?us-ascii?Q?hNsMjmFZ8jp4phsTq8RKuWlnorjmkL+gcTfz3xt49DTfs7Bj0G/hFQd5LpUW?=
 =?us-ascii?Q?k6LxuG9b+lP8pezUFfS+lgjlSJaFrC6SiafW8a4tx1lLSWQmPBOfR5ditywO?=
 =?us-ascii?Q?gQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c76a47d8-d80c-43f6-7729-08da94c2da38
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:29:43.4545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzN5WWgV6VJnF7HPzav6NjPTF6+JnJRErvDh2kKELJpTDCzDmRQX8YfHi3k/6iWnPM6B5r1x1tVc7+kKQGh2tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_08,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-ORIG-GUID: a9ByjCCQJ0-fNd2XRtvOSsny_bszozC_
X-Proofpoint-GUID: a9ByjCCQJ0-fNd2XRtvOSsny_bszozC_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1cac233cfe71f21e069705a4930c18e48d897be6 upstream.

Refactor xfs_alloc_min_freelist to accept a NULL @pag argument, in which
case it returns the largest possible minimum length.  This will be used
in an upcoming patch to compute the length of the AGFL at mkfs time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f1cdf5fbaa71..084d39d8856b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1998,24 +1998,32 @@ xfs_alloc_longest_free_extent(
 	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
 }
 
+/*
+ * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
+ * return the largest possible minimum length.
+ */
 unsigned int
 xfs_alloc_min_freelist(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag)
 {
+	/* AG btrees have at least 1 level. */
+	static const uint8_t	fake_levels[XFS_BTNUM_AGF] = {1, 1, 1};
+	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
 	unsigned int		min_free;
 
+	ASSERT(mp->m_ag_maxlevels > 0);
+
 	/* space needed by-bno freespace btree */
-	min_free = min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_BNOi] + 1,
+	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed by-size freespace btree */
-	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
+	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed reverse mapping used space btree */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		min_free += min_t(unsigned int,
-				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
-				  mp->m_rmap_maxlevels);
+		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
+						mp->m_rmap_maxlevels);
 
 	return min_free;
 }
-- 
2.35.1

