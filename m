Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FC0C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8139061108
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbhG0GTy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48492 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235518AbhG0GTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:48 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6GunI007326
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Q5cZHIv1JxVLMdOvbPHzJ7N9Uz6X4UGFXPn6qvS4coE=;
 b=NE8UoK5lqxZpdz7VX7BA3ODOaWwKvHuKJyJ6kXS8luLJeIbtPrhXd2/NS21BZId7iy8J
 UJVYGl7+ih4Ig9/6rAykUnFofnJfnAx01QlT5IBaDl8lU1NiNPZ6LcpiFGC6WPeHx/w+
 VhARcA+bj1/lntRcmu1xUyuGCgtu8h2371+kiCvuQ1PxdnycGT9DIxfjA9UKXiJmfL55
 vP3yYlRLQWb7zQql2AgTBoIPhWc98pMngoGoWgQ/YaBmW2MPPtan8czViggG5dQILYNu
 yJI9Dt6s0R/3c1ElmHkYPJD7APibO0tw0k+Ux8FCEVvDM0Nnx2ja7rRGy+diAv4cltpV 9g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Q5cZHIv1JxVLMdOvbPHzJ7N9Uz6X4UGFXPn6qvS4coE=;
 b=ROhO5ftaSd7rKxOGsgQiWbq6JoI5UvsBJblCUgdbqx3OY+FgjKy6h1Sx3T5swa4BF+n8
 2m3jDtOZ1IMnOwDnaggl3Y5giZ2w7A5WhRF02MbGKNV573eBXly7bht87cG5KsgUmDey
 EkXzpxIqNasB82+OaSS5qSHyYlcRNZvYEKk2K9zufFfN8al0oktOWehuAT3ZxvLB04yl
 /0jFV5ful/FgXwOWEFP1wiclqKVXYiUgMo+Y2zE+sHbILP+rW418Tni7JEZkTkLEbW0g
 VdPBH8EBKuyMhMY4UXrwKyKADHWxU4W2QqCvkOTukmn/LTXNNGDNlTU9wqrOsJkJ1oEk Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n0uds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6Eia8065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvntm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeTN36RgsC0LGIP2nHKtug70/pvQ/kBnK2Ubon4A4U4uxIxDOzqnnEm5IlAmHXlBOYPZJPpNGo+3xS0N3/GOuA/DPBdZAY/nx935gUz+sWM+Q8YJ5GBS6/ZDCYYvGdKRXWNjSvoBUDohP8XYYJ0v6eK1IB8Ws0zlozbYE9z1jLoxaXvMNWqlgkOfuZnVWDpMI9RhrxXXvCAIuqT4J6tnJmvYVppFrNsAlhr8vIms/s0rDGy3PMJxz/xv70TABw5xc3006MpT3Ls7iEdebKARM41Nhn00P+ZWIJtQglnIrG8WtfpBEwGhjzy9fx43uGn7NdfpTk+ZxDT1DEi8S1QJmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5cZHIv1JxVLMdOvbPHzJ7N9Uz6X4UGFXPn6qvS4coE=;
 b=FdEoDNFbaIrArdC614PfupuwmnFJK694Kkistrb971p8EBbUxAWSgS/oJjAUz+NJA8XNmTEcyGRyM664EVQG2c3rVCBv+f4nyKRzKYBNYvuapR4EvTwBo2TTiM7yqbZI9U9R+8UOsw8nN3QCCftldBxa+T7FW8JA/GCHSjX4hRUhgwXLkwdQYMIhmdyo7llZZjdRXSCMoPKS126AAJqRzOsgq3Wox2UVuHuwW727za1duTqR9OwajdnIUp2dt1U/iOrKuy7SL1D/kmnIj8zWRLromefRRF6eMT1Vvl+dbsGHelutNuTd3fa38PeGCU2oKRHwRsbMdeIhrGzprV3btw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5cZHIv1JxVLMdOvbPHzJ7N9Uz6X4UGFXPn6qvS4coE=;
 b=mOnRPUlyWnhU5TZBP3RlK84HrGsQtCJBj1e5ltro1QoVoL1SAu8+2ky0ZDwxjQa+BepJN5N4rZvnIAtdYajX+2P6GMi7XC/Dbailkm27O74z+aJmawD600PLbvb4ajaX8Ef0ePhZMvL2E/0I4X3AqP4HwvuTZZHDTd05Wd3dn4U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:40 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 04/27] xfsprogs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
Date:   Mon, 26 Jul 2021 23:18:41 -0700
Message-Id: <20210727061904.11084-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abc5c6de-05d4-4b87-27e6-08d950c6846b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB36690E187DCE57C7F2EFAC0D95E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: trNgo7sYz6E+Y8lQ1++a7xncxOc/W92oFh+8Wf1cqA7SK5nRA/zfF0oEQMgY9gYjzvL7yMXwGlYrCK1ZXmHusk+qGEeKja0l7q5xkrIfX5tjRj5XloYzeIWv8lY72HFEZpAvV3bKVo3I8Oizo+Ot+CzasyDc3V5Y1vQEL55z76U3BW2WL9B3asKPIiGkq9QD7Tc/CsRN1UEcg3srckOptSz5x+SemOP2NIbgfCAWml/IBb/tSBgZyC1LopprviUqLyF7U8KxMFb6MD9LD2n9vImysGfBISuyjOAy+HdhLz4wCh4YyEgzRoebTOD8W7Hy0OXcl/69d7ZMpfS2F4/+KSfIEuF5wHF6eKxAF2fkyemDflEb4bFo7X2V260o8hetVYTu4zGm7RdEOH10P/ytv4iflXp0gStenjY+qOz9jdavxNOP8BynebIzSIyEY/LnKsBESR9iPNCAH1dEgfITUhTprOeps05ipVF8gDdnEwuNTWsh6LIlN9UzK8Tl4E3mrt4a9HVuKHvTC7bd3WWPbGDTOfGY9YmL7PukUXN8eBemJ9fEIZCQk1FYVY1XYMSj6AQ5RtqShnIyO5sjc/A3OtvLBzY4goG/U/BMD7dmmYn827w82t98TEyteivC8Qmc/0nUPFQvBcyhsA4DftIjGJ5hAqzAU7lPpxgU2q32SglEh+hAZ0QPRU8sFAcEdzjZs0XE/GvC3JO2hNty1WsV8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aC13if0lZcWqGS/IKz/96XWqehDIkrfuWKi7SA5G10ZQI9aPuT8dtnPJeW6D?=
 =?us-ascii?Q?14KpbHiipTK1USNuLOHrvDNBhkiu0jDup6SBwdz+N4OlEt3KDfFp9qLJzb5k?=
 =?us-ascii?Q?yKZWSS1oYV1aucMC7VP93OVU9ZMpwPoferZ5jhCmcGoW1zESuxiBYJj18tqF?=
 =?us-ascii?Q?LO6uH+b5SroP9SQpL+zRd0Ta6xmHyEJhqsHPT/d6VdCb5UT7YLeQhACh2FkI?=
 =?us-ascii?Q?UHsf0LUDlLDSnglupSz7Myvyn6GM+mZVd0hA+SWvI9Yhz+eMYX8uoTFJVQGu?=
 =?us-ascii?Q?QwVU6C0gpoRPxrN13UER9MBSrMH8DhhEmG0bfaM0Sepo4fz2pptjLsyVXETE?=
 =?us-ascii?Q?po3qebvY6WLEPelzW8oCh6j8vJ50S4Zsg/3hcFZci7ouYlzmHX0W12qWhDgF?=
 =?us-ascii?Q?cf6OWYUCAMMmOmWGDdL8ddMeO9P6EvRsoqDIBoyU2AYdwu62g52xQAx3f0Qj?=
 =?us-ascii?Q?5o9TV8qo5xPYJbFc4BvHUGQ8ykaHo8+PgS/5opx2lGhwQrJ3ie7nfMnDbSjC?=
 =?us-ascii?Q?1d8JFefxi1rsjST3W+nYWL9mAc6JWDLa2N4TSBuY2A7w/WO79HBFapXWt3yE?=
 =?us-ascii?Q?RiTGVdfWvb/u8lepIlQ/nzRZiMo+GkGDaaC6UMKq0XJ6fv5VGDhb0HiENuEi?=
 =?us-ascii?Q?G+qIua7OFqbWVxF4rjqMicsQkFswHJSjt0YXJGzyzsDGsFSZCFUanKTvnHBg?=
 =?us-ascii?Q?R2vuRi+zbT05NHQj9h9r4+meht1ZYg/+Rd8YBP4zrpwMlHJAV9cTntKgtuXJ?=
 =?us-ascii?Q?qPrkmG6eMLHpcQ7hMWXe0aWt+9xIjg4enI1mWrKp8cIYFvH5CRnNMcoYKBTE?=
 =?us-ascii?Q?sj08t+dwjscvNAtT3SrhSX9kUu6BFl1qzGIs6HRk5wWnSwznvGcaVa3pHs4o?=
 =?us-ascii?Q?a/YPErRD2UoY05lZoDCH1vM0Us9rx9veMLYyXJaOBGsZC0VriTlvA4ut1oUG?=
 =?us-ascii?Q?d0fkM2hDHJjdUWbmqZq047kJxA4YOuOCxKB9Wf57M2kfl+A9L39balVuPPzq?=
 =?us-ascii?Q?bBw3dqkdtrZry4d1egISwVWMpJkfMYjCZOh1HfIVogZldRVPQMvUQNYzq4Lx?=
 =?us-ascii?Q?CcZayVplF9LMScTn6UxKhTC4FaTUV+rz6ifEXVyVeYwwAJGJF5l/Wi/8H/jL?=
 =?us-ascii?Q?/X9DoNc/WGhx9eITd0rDtPrtWWY2Ftbf3mClmKrT+k1QKyxN0gDbCjjf6jP3?=
 =?us-ascii?Q?enS7yc+7V/Ciph6uMYdgAvCkVspM0bnK2Lgobx21Q1PRSnXJGPolNnHHzRut?=
 =?us-ascii?Q?pdnIoBeK+a2dOKgmGo+Ok15vv6LflRAh/oLn/rUsnJoTGibHm0W/AWyO7p/1?=
 =?us-ascii?Q?tj8a7OTPiJp+CXgkeGbqRCUm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc5c6de-05d4-4b87-27e6-08d950c6846b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:40.6670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9vP4g6knOSKbSCCml29LNmWHGIfjmIJDnzkkDvEvpTrEDYDWSnCzp3KYXVp9Z8uncd+9CCcsEqkmEVk6fe8eUKmktP4YoXeJWA4G6fuNjIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: s0WSPMxibgnAQV_9AeQSD4hxSSLUl21C
X-Proofpoint-GUID: s0WSPMxibgnAQV_9AeQSD4hxSSLUl21C
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 392a7ea8080e3753aa179d4daaa2ad413d0ff441

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b181777..158149a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1073,6 +1074,28 @@ restart:
 			return error;
 	}
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+	if (error)
+		goto out;
+	retval = 0;
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
+}
+
+
+STATIC int
+xfs_attr_node_addname_clear_incomplete(
+	struct xfs_da_args		*args)
+{
+	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state_blk		*blk;
+	int				retval = 0;
+	int				error = 0;
+
 	/*
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
-- 
2.7.4

