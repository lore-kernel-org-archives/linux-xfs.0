Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6084DC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjKFNMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjKFNL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:11:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EF7A9
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:11:55 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1x4U006671;
        Mon, 6 Nov 2023 13:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=I0zjj2CL6DlbFMncP2dw5WzEyx+XqTByG5FVAskQdFE=;
 b=ZNLNTlXh5jrHqVARtWjz+tOU4L1pFYKo1SKoHVEGlpqoCubowlHH7j3S0HVZD7pcM0yH
 M96j6/B8ayLyD8RoNmdS43sr4/UvrtgDTgnZ1BzfNrBAehvXqzbmebVHuVcjdvMrLus9
 uSrBHKfUWmllqQDhjGI8JSzJtVakBTFzefSxhafDAvg6c8Loxs4eK0oeRs9e+ciBXfSX
 KDpFIfDM7D3bpNPn+IFI9b1u54PvkJcT98UAVDj2LadT8m23b8qAKtcSBuAlV6zIcXL8
 LIaN5Dtns9+oT0UJcjDwe/wjwMgcehsHGMcptJ0O22dFL/NlEtHPXVRcWe2jIWN9qW4q 6A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cvcayyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6BvWic024757;
        Mon, 6 Nov 2023 13:11:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdba4rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6SoxqFwl8j6/b3Osy9byQjHbPiQf9aU0koteLb4f5rybVAUqYNehh6CwekH1Zc8/efFWxeW8rHkSB1zll0XKOC4XJCWWWJ+2H4X/KglXXYyvfm4UT+u+Ex/gWYuNisByMkCT3/qhfnZIhuyNFVvEnCAdRhXuBbjRZYm2OWEs6u1JaGgz7GCtv/EAYKc8SHegqCKthkJL3OhKS2WCpUzr4Q3Utea6JZJLCZJXuZp6jmucBhQJiC91nxTC8Rbbs2cSLmThCfmlrzLrR8lSKSj8Cxa2Qnm5Yd7UeebrJw8aDHBSPKqLEHAr9MbogEiIyBonX0cddWXb2318YSoFMDN6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0zjj2CL6DlbFMncP2dw5WzEyx+XqTByG5FVAskQdFE=;
 b=ZMMVWc4lzKBJ/ZDpMRRiRlJbH3Zb3XAX21lvjGBpWzDF9egSXRaCxXetDl/j4sY+8WIZnaifohXxteY8g2aX8eTn2jWY4ei4NyJgAR/2ufb5SjrxB5lcF4BLeLa/s3nIr0rll56HBvYqPMem+XIydXBU8djsVP8gQh28wO8aBLFoYt76wpFjzlJj7Kgjs7qCLV52TyaceObARecJcgzNt4/MeyFb++6luTpBAsioQalNx2iuXGkw5kLSnqt4BWvan8BiYrsCwGPW+Ih887QMc50vn2clOA5Ot0laydlh4ecWn0GlgvPJqfuRsAiyF7eLX2IxeW/vOxQTtujJSGgLow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0zjj2CL6DlbFMncP2dw5WzEyx+XqTByG5FVAskQdFE=;
 b=mTRXZHtJHu9CIjdjJcgK1c8g1flOY4p5k8+tqqU0Wpzn/tk6lieUFciohI1o6Pfs/ybklFBgGzNY+Z1EPsJk882o6gW6nr4HWnoLsAJEzT/VIwrGNoJ9+fwXJltjJuPjuBt8u4yP3OjesWK+Lpkhju5HDl9bXTvsyUd/bCIW5J8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:11:50 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:11:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 07/21] metadump: Introduce struct metadump_ops
Date:   Mon,  6 Nov 2023 18:40:40 +0530
Message-Id: <20231106131054.143419-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0038.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::7)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 7417422d-3ea0-455a-a9ed-08dbdec9f011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79X1FRkLpfoZVdLke8t4OliF4QTjsK1HtYleibsx1A+Z+KFU7dM2ZdVGY8v2kIN9pwRptyIpB9Y7vCj1UYGzSjU3aUBo15gbuh5wHPeF8kaD7y2t2qDTIej4Dd5quc/mh8WXnvutMAWgnqLeXD72o1Kncx8htd4/p9TvLEce2ne5ACu6lORyHAfQkB5mIX2tvWSCzEgS/qE5ZD54gaS7d3i+m7zA6sIHIUn9byGBk7nOhzscgQYrKVXyYKnWFIMdJpD9s/CpdV1a51/vvi1mzkKF0GIOQymQuGSIVpD94on4mgcuoF0wGsE83VooWb06Qo65Qz4howNqm2M9UtWsQkylvYW2c2/1hBOsPWEpIlTIE3FzQenkoDc2R5B2HgnpXLCMBKO0pn4C0Il+pEnfRyuiVnV3Xc1J2aAS1StzI+fFOYIVcKUHECBgw3yeX4uw4QCknfYV+cA3tkWOHQVnvPxIgc+iESWztYFLTaSM78LrOYX28RiukjQfEqMBh+VUcVH6y4nElDVVlX6w/wUnltcdUHHNo/nCJffNjl32121ZHKLIeHSYRnUHd5UbrhD3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KFFQ4fLdo0DHnbk5+t6UckRJ9WPuOzrtiDXCHnHRQK8cc5YgoIcaA5HlfAC0?=
 =?us-ascii?Q?01I0lkhjX6KDBQBVEfnkFjuI+rLV6QoAAlbwkPLsVGwO3H1Nzhuup0x0TYIU?=
 =?us-ascii?Q?MNps1MMexW2Ma21SmtJ2DVgSm8j2cLEGtPwjn01F/LnnUSf0qPajPhUp5YYv?=
 =?us-ascii?Q?nInOxxkEFnPf6SEhrHzgODw7Jc3WinLueP0sR3fuzXSn3zUOr0i4d5U/Kgpi?=
 =?us-ascii?Q?1HrGPV504trv6huDijMXKxelZno9rAzVtq5oucGV6ubT4Ua+VKjvHCQ7f4eS?=
 =?us-ascii?Q?fgFwC+rkBWJoi3OuXgyV7w3K/ecdTDzqkeFL5jZ95P6XvebTWlHlIjzg2UdV?=
 =?us-ascii?Q?1b21+hHE9u7advr/TzQnI2ktDXkS/ni/+D58iJ40UTtZikL/hxBRPpXPLfDs?=
 =?us-ascii?Q?b5S3j2SaCp8i5CtFYzqG2BiWDxkKAFGrcNchUylRTY4+VZxyRvg2Gn3+Sryb?=
 =?us-ascii?Q?bw7zP2IQRlzsuyZWv6a0adAoUe4DUarsb39iw2UGSjhiSGgNqn1+ybzYE1eo?=
 =?us-ascii?Q?jj1FH+1L/A/rOjesii7PYjGgPdjLd3QWiI6FHueCEmuPdI2KgtO6IXkorjPn?=
 =?us-ascii?Q?WuZYWrIsYIsc/rpgDtDMhgzU5050RN5mTaEtVi/R46NVkM/TYEiooyaUOo92?=
 =?us-ascii?Q?v0fzaUNSI670t4cOt/EkcBv4DyeFNqJ6XGJGWC59BvOu7JTvZH3LybeR1C/Y?=
 =?us-ascii?Q?pbHddddo/qGDVShUg4yO64SiStmMNkpbLMNua1l4Yzhi7k09SgoWjR7d/pye?=
 =?us-ascii?Q?NMC8hdk/Y1Rs5oyytuLrXr5L2m1yMaeD3Q3D4OxvTcPhoUvfojgjslMsANFL?=
 =?us-ascii?Q?5F6qHcdbwBF0JZi84cWcnXJIeyMub9F+gOXTxn0ExMp/oWEWLde344ZegWW4?=
 =?us-ascii?Q?2zhUfKwceVU1yGagJdrJ5VzPtzDSwkvs+rlFMj807CWjNbGpRMsWUHNjNwLW?=
 =?us-ascii?Q?DLKeFHQ9IVEN8jGVdqPvOz/P5OgW49GyZkCsBZMODTVLKSq9En6lETFfU7wf?=
 =?us-ascii?Q?HKis/0hzQiDSnLOvQnQHRyhnSszaL6c3adB6JhK2EUhNszsu4GtZLwy3uLHN?=
 =?us-ascii?Q?Veyz+k5gzRrfF0TCWMlKHl1wtq7DizN3XiIqT8mrT7bexYP5AffpBaW4cM5b?=
 =?us-ascii?Q?SbivBnaJgpX8mJVJk+fpxIMXSzRDTnkJQtmfFHJTcw6isbONU0UnXYa5DFGd?=
 =?us-ascii?Q?bL6VoTjpOToG2sfuJ6f7yUfBukBHNH4jKv5f460ztuzH2KLzbp6bg2RoZ1ET?=
 =?us-ascii?Q?npMDwvUFplz6SknLgvhqztpGcbYOnKKjiPpM4Bk9ryV85T+WVoln5MuR/Z9f?=
 =?us-ascii?Q?Rsn2d2hHP4nZtSr4/+b7M3RUAhmNxUqKCH+XGJP6mjjiyFKsC+2yjcH3aJPb?=
 =?us-ascii?Q?oeQsJtru9ZaXjT059Wek+0KFeSbCa+XLoxmxbVVMuDth/bu73ZvkCNZaM691?=
 =?us-ascii?Q?19sXsMYv5yk7yYaBS3/M7GjCxYg2auW3qWXYwnGYj2kHBP6WTawlpYT8rDqc?=
 =?us-ascii?Q?K4HAu2Ityos7dQS8r79423v9JiSPMzQ0EZyu/XChsyuqApkpc8DYjemF72lT?=
 =?us-ascii?Q?eBh1OsmWGYnycJQWmR9FwYtoxuFdgEdJquNCYzL0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3SYlSyl0QiBMjHwnlongZWlvWp3FOxq1navtIizF+cP9HFLS+PoJigmQLP5udyu7/e2KRUY79VVv2V6h4oWGimUfCdUx8A74i8hII32WBTNKEslkkMEssoYhg4tiWNabm2ckoZzYZU74IOXGnaM6n5s9nYHNyJWidCkFX1eS94TE3nNJ7xUB/e/V7cRoriMAeEVvy1MJlBI1PiHPgGoxVxWTuTuQgOFMBxTYFsj6/W/rDn6ii4AFqLrnf/irIgthbgHv5lP6CmdNWX63xS9hLB4K/uj0LGxIOuC8d75WoJg7rRDyfGX4alncKbyGXVIB2jTE4Fe9dCnGKfbmW3d6h4d8S30T4ybJPNfp2BQuca/WQarQQxqPZwhiHqQTkl2MPltdYiU1o1/mYc41vUZNVM5TRFhSAM6wggyxjhrJHT1LGDSVHI9Rsb6hv09mDMkbupWZIktXg9BEst+2KqnBqlJD934NRWS6mD0oZ+FQhwAc08Nq8TIuRq4uG2kWx4P1d/ws0to+V28JicAxQnGfC7ZA09cvUUGBrLSlnarKEi3XBSB/4o8/WtPeEG7n96YbSO9vCfgckVSjZZHyLOGXF+iU9aabDHKnwSh8G6a70DHLKbjP+slqRdAtJUclCF/Bic5J3BqGgyH1lD/F5qLbfnmX+jyMFM6ABwFgkWEecrk3USTw2NQr4Lw2pvyEWukE0Iro0tuHql1owecww1XZvqAU3p6c2W1LNcJhcg3XfQPsHOf5MURJb8FWSZhHbmsqi459vpJrznBs9u9TBhfA9GCdNdl89j/ZmfRR5to8hGM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7417422d-3ea0-455a-a9ed-08dbdec9f011
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:11:50.3395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6NVxT9ZQgLBN+XcZ5WcM4nTL6aDS1nqCTPLXXX/Qhh8+gpPjhZbVV5s7pl9BSHcB4+Sv7R94k6vUfeuAHx885A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060106
X-Proofpoint-GUID: GlTQITOm3ZWS-IIqWI11YbGB5OcVC0zC
X-Proofpoint-ORIG-GUID: GlTQITOm3ZWS-IIqWI11YbGB5OcVC0zC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We will need two sets of functions to implement two versions of metadump. This
commit adds the definition for 'struct metadump_ops' to hold pointers to
version specific metadump functions.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/db/metadump.c b/db/metadump.c
index 24f0b41f..a2ec6ab5 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -41,6 +41,30 @@ static const cmdinfo_t	metadump_cmd =
 		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
 		N_("dump metadata to a file"), metadump_help };
 
+struct metadump_ops {
+	/*
+	 * Initialize Metadump. This may perform actions such as
+	 * 1. Allocating memory for structures required for dumping the
+	 *    metadata.
+	 * 2. Writing a header to the beginning of the metadump file.
+	 */
+	int (*init)(void);
+	/*
+	 * Write metadata to the metadump file along with the required ancillary
+	 * data. @off and @len are in units of 512 byte blocks.
+	 */
+	int (*write)(enum typnm type, const char *data, xfs_daddr_t off,
+			int len);
+	/*
+	 * Flush any in-memory remanents of metadata to the metadump file.
+	 */
+	int (*finish_dump)(void);
+	/*
+	 * Free resources allocated during metadump process.
+	 */
+	void (*release)(void);
+};
+
 static struct metadump {
 	int			version;
 	bool			show_progress;
@@ -55,6 +79,7 @@ static struct metadump {
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
 	FILE			*outf;
+	struct metadump_ops	*mdops;
 	/* header + index + buffers */
 	struct xfs_metablock	*metablock;
 	__be64			*block_index;
-- 
2.39.1

