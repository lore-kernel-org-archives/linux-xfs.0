Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E26C43217
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiKGJDn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiKGJDj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5EE95A6
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:39 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A78uatw012294
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=Bu38OFgM8RS/cTObyBKwSZ5GrJgfbQL6o2cmZr+gBZVo/DylRVh+H30LpuzB0SGgHoa9
 aElgN1jODHJ0ohi9bn0EraNAoVZYy7nDjGdCwybIFlZY8BztPBcYaE0H7FRx7r9eVcNO
 m1VrlTTlZCAebtmYrGY52OraO42sRY9SvAG3WM+8a3OfWSlXPN/sUIJ7Z0BeEmSMC7+/
 5nScY+rafWTA0hu/wacn9JxPu+Al4KKgpJGuAhnQoCaRMekEOUvyXN4yr61Y9bkQsnOS
 ojxd0Yw/sYam+kEKJTwBWbvOS2RdTf0gEolbU5+Alb8Mm4Olz9JMBdsqX09c6V1VrNY2 XQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkfu7v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77JXoD025146
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqek6ua-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwAHCvBLrFbouMwo/QJVbXbbl4hfS3kwm92S9IMGyTC8wzWNev780uTUhgeKwF+x0IeF6knPYuT5k54mEhjubcWHmCPsSt9LsfuG/CeAvJwt6B0r+05V20u/1Bj80X7qwIjbJkADQR9RkRqcKIhpYfpbCaoUgoKUXKp83BWfwnvS2XpZtcIg0gdF3gsztkbagxWIXIq9C6K8//ssz4iIdz2Zex1P1AbA653qQfvrZMVz771h+rnDhSJjzTUdwmocffrpcZGGz2sQg+wEz6LWr7cWAyOIcn12V0cwpacpoW4eiWykEY2YSEwSTQTdSNHd6+W79cYaxREyPxanOF4xUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=Go3w9eJH3kmdnS42q6fpx6SRl27K5NhPasC8dummQYujQZyeVn3aBonVURuTvK+Fk2b8jOWqiCVUbZdzqhmJM1ONJ6y30O1fWAh8xXH02SCJjGB4pSqX8nh3BQPsRE9/i3/sEyQbNn8yAycX7fRlaw8EgO+KxQnRF+G4kWPm0EvNZj4gALM5wf4ShugG1ypEUdXy7pLLp1TdlDJKDNjuwWU+0nssX7WbRgmHq8OyGGY+nYMPnZEYExERJSUQpqvn1m0YpyT1bKPP5xzI57HzvEnV68zNCwkPLTOVGp+oAfTP++Bd7hVwIv2XBCSk9iEIcCcz+d7zEakVVYXppf/2KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=YzuzvokvUwM0cgukQcebncUAAy+m7lAO7jIHUxaz1DXWvU9HGRwuqrzVaULoYPh590vCyKNwRzbu0z3y+6Tjn0ekWcOKJjxhTOHlmxWuapbDaN12d3DurV0Se5OiRaXCC9/MTzxU5Q3PFlP5XAZnxRJdXE/tn4yem0sZv24eyGo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW4PR10MB6346.namprd10.prod.outlook.com (2603:10b6:303:1ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 09:03:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:33 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 26/26] xfs: drop compatibility minimum log size computations for reflink
Date:   Mon,  7 Nov 2022 02:01:56 -0700
Message-Id: <20221107090156.299319-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0159.namprd05.prod.outlook.com
 (2603:10b6:a03:339::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|MW4PR10MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: dffd03b3-0b01-4d3b-0dfa-08dac09ef2d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D6hig/JA4hZ668NP04oeG0QFiYCchdECmP5I8YVOzrqexGo9EMLC8JAuP/Bc9CH3E8SL7vOB/xfUB+K6/mpsDraK/URPF9nlZeseCl8sLlL6GMpnx0Nii8GC9Nr038tHCNKqGKUvlkpFi8kvJbOqsTIpLey4WXMLqX2aUwAqcGxm59GUcMAkPP8I3Xio3oxSHy7yY+XoL2KiDo7TiNADPz7SyquzoNOZyjWcINtBo3yuuuRfv/bvCNhTtdXthSqcX+j1jioFbTjPrP+3hWQOs8UaNzwTW19nivdi4vg8hza7ogKyGMmTr/sMUTWf7NV/g+88iC70qGnIQYQDEWXMBYY9x+6OzTdnmIQ3gM2Jw4YhgDMUekYAk4Mx4tM5Z8X/pTYdH4XcaTRU5WfuDOr4OCV7euxa/5TzLr1T+otFFNDkf9KzUXeVOC+Hg5Y4lRIKMF8Yh2VR30sqVWBj9LITmPNZ/cg78FcGvLuWGJZSe1a2NEMbjn6k2CgfEoH+syOnl+gEnvyUPjsPmc4AhDdQHXqvibf1C8to16iN5S4cSQOd9xQPt/Newu9nPuRHH3LskGib1+Kz7iWwwv9wi4kI6Tc4TcFqogR7vYDCGBfDmY4XQp/NHgBtluVCdWzaxKT3jkLH3H21LhLWeZ/0t+iJBs2OrjgpFxsZfUkuk6PpeMyOShXjSu5LNV2IHTAqvWrVw/0tFj4d0RmdyoYLjzPHtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(38100700002)(6506007)(36756003)(478600001)(316002)(66946007)(66556008)(8676002)(41300700001)(6916009)(8936002)(1076003)(5660300002)(6486002)(2906002)(86362001)(66476007)(83380400001)(2616005)(6666004)(9686003)(6512007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8rndOCPlH5cs6eP2DTVkJRNzCnN7WgFFWyLVUufBO00xWWyBdMP29FJrQGbw?=
 =?us-ascii?Q?d9fmSbhcuoIY1MD371tFjfS3MLq12zxAyhHFSKhB60kXdnK8FOvtiLppK1xn?=
 =?us-ascii?Q?ttm2H+UEUknW4RgP3xc2HQm33leiwt+lC6I+XJulAS0e4fwJ+UUehLxTo7+A?=
 =?us-ascii?Q?/qlTT14dlthVR/9lDypkOGS5e024gPI5sOMS4EDfGejSNqPv7YFhehUD6rDZ?=
 =?us-ascii?Q?6gbddRJ+jzwTYMBVjwpFgCk9Sj9sIv/GtvOexFw64TaBF/P2Eaem+RjFQ+3T?=
 =?us-ascii?Q?+rKq2fFtrcJu43MqWLklFC3v6L4XKedrXLhF5jaWFw7swHa8zFKOPMzZ9pI3?=
 =?us-ascii?Q?/UKczTCh2TBtNS10+mSDe4q7Ajrr27kxD1QFe3r2m7o6zGRB2Hw5vB/Xjku9?=
 =?us-ascii?Q?LH20YYvRGIvVAPTE01PbfQo9hFDNC6HTD8c+KfPUs0oPzkk34wmy8gk0eTZY?=
 =?us-ascii?Q?ZKPYbEoGemJImAKr+aXQn89ECoABaTP0IdrLSmMLkzvbUEvB2IYjUBEhyjTY?=
 =?us-ascii?Q?flJhT4l1pvqXP558/xhUlflr4NoBfPutjjiHKVQ+/l75EAhpVP2zIFs2NY5D?=
 =?us-ascii?Q?hEwrYdd0AjRTvXtzOXRUQ6/o6d7NP2+iICCCMnLs3/zylcFzXhXREcVF7tK6?=
 =?us-ascii?Q?JGFs6AsOKLC5TE8rmf/Cfe84dXxUyDV4LXmWWMAo1lbIa+AyE+FumRt8GdHU?=
 =?us-ascii?Q?3pET/krZmj9lmx2ndBE4iji8Nhi6k8x5C76ptZ74NEmP5DCX96DcqtKz3sKJ?=
 =?us-ascii?Q?L+dMtBfV8wToDPTFbxbM4VGq24dM4e5mCbKkzGkE2wJlq1fdw9OE+2TY1x09?=
 =?us-ascii?Q?zqY/QHW7fjcAgl/40N7UCRyo24kUMVBAIwMwPeoak+hmn/ZSO9SEuZrPTxcs?=
 =?us-ascii?Q?+T3fpvjq61aFgkfKz1wqjV9JKe+48oe9PB+G5OpJI7jSHSBzkEt9Q3i5+stI?=
 =?us-ascii?Q?sD3dLuvTarcUrtBGd0HCXuUyL1FMF7UJYzx5mSGqt9k8/uiZx5Lkkz17I2ju?=
 =?us-ascii?Q?+/67qE9NXfacidQy7rVJopuNPC8p4LtHsWQxdx5m4mc2WUbHsOUVEzsDoUZ4?=
 =?us-ascii?Q?fm3hneSEKARJwVRA9ywDFzJYpnMyyZOTZ2N9Hd8/r4nWjjn1L+28v78Q/jvO?=
 =?us-ascii?Q?xchSEpXd0tRHjqwU93Ap1sSKkwCRjB0wXwmqz+TegX0fyjwufK1GoYBgYv20?=
 =?us-ascii?Q?FQzQedEvaKhrXe4AXxCXA2xZeeDN0hijspzVLsDZ1jOfWZNwyWaqNqo4HI5J?=
 =?us-ascii?Q?4SqgEZCbEdgvKgJq0UmE0VgQqrUdQwAzMarTdrCKYXOJL005OWCKb1Igsv9R?=
 =?us-ascii?Q?Rp1I7xjvJp4NctUXwHYT+MdBANjw7KvKV4gydoQo0PloyWvWuv0KbINr9Dt7?=
 =?us-ascii?Q?ha237Q/IE7bwTjPTBGeLCW6qEbZVnMNhVl8tWI7edQwRjlPLd1TuF9VNrAT1?=
 =?us-ascii?Q?BGKx+7BKtRRfaZCyGt69hxeOl2FjCIEwpYOxgsUM9DzrB1uzXmTK30nntV72?=
 =?us-ascii?Q?GW4q05Kn3ENrUWp0CqcF+SmI3EDdqu2NCXP0Aw7AuZ5bRpqfsXinCVA9/Sxx?=
 =?us-ascii?Q?WbDyE0v+l8nk9YwYdbFn1pdgZyevcjoFDol7WJOS5lKTZ4jfvZiHDBf2x/cH?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dffd03b3-0b01-4d3b-0dfa-08dac09ef2d1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:33.7967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbAtuXWIGtWd6gUvfgvvSpKrxGYLsEg5R3BITlrhwarDb+A2M8IczCFl2zqPxZlYdUvqrMskKmzgBcyzvxjsAhtmmcB2bncJEWxXcNvh1nQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070077
X-Proofpoint-ORIG-GUID: BmhvdDVRK8Wcxy9Jk1HePb4TZ8_gFxRI
X-Proofpoint-GUID: BmhvdDVRK8Wcxy9Jk1HePb4TZ8_gFxRI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index e5c606fb7a6a..74821c7fd0cc 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to
-- 
2.25.1

