Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DC5C05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjBIICA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBIIB7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:01:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB4D1351B
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:01:54 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PfLU011325
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=m2r8fEeGXzlcIrhZZYoESkqjIZGbaWOYbZx38y0IwsuaEGeqFR0ljLZXkBbUI9tv7/Kl
 QBByHf8U2OVyy9L2Giz/SfIcVghQytkka+MfZC4CetNLxBbI0gxdxvTSI6gOfnyHkgK/
 qMVVlevXbxeBjAyGVCot3bCCiin4Vs723Lxw5RxH/BihUsZEtpp14xwQijJVTpt2GR8W
 K3WNd0+R1XeFqIAsgJX0IU4/XGYn/Kzwit6Mxvphx8EfWMiLZkRMfehoArQMfWCdmvQ6
 t/TxncQCfta6UKpG3DndGMztvpV6ixohQlWmew8BrHC+NpX2INKn75IH3GG+bsQBUXXP KA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1a75f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196U9Io036257
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtfg3gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcGhb5wKjMzL/4OqiVdV0xszJZ1K9KncSzDFsXwPqnRPRPZJLFQyih1A2ToSN6zWLRra687nPybDFHCsPhYCiLg+UWLpkhG7hKAWBFVRVhqWLIe3BTxkmQKZAGVCa3Pg8puHTF7DaQSMrS9oZAIY4LxUzSBC2L1CmH5AgOF8TIMHU9u2rk7ZKyHa/N8RR90x6KjI/UiH1U35SSoTcruFtiR3snz8tJeDF2VftzbqbhMf2xmk9Z2lBNNFuskKr3Ih3cH73stH22wvgIiGc14ieFh1Zr0yoWRh7GRAm7NCrqESypAgrMHV4UycoT1+TU5gFkPYIpSixIqU8+jUsYUVjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=m71fydUGpIhIa0FwsS5Zyj++MiCmuGtYNbu3WT0hKk/tDFoFyWXHR+30pMiv/aMMQzafrUCCNEd+DdF/xMY1s2SpBOx6xnrxdZj8O/rwWHZJGmuwzWoH1mWsSDujiOHpBZyXGnQSSGwgGKDEhAD6Q0sjsOt46vD78NIE2nZrKN1jqqW4BRWbxAfO6e0Gxl+/PBlL+VYV7hFIoiOMB3xlFpprl0++GE7YoxhXdrfCA7DcNtTRfUbWX+KUTckhZLEP8MzGkVs6pD2WEmsOZxSHa7BC0V3jEq1EhEMfLtxX6omPyOcTvEsILmeL7T9xMZLWu5QV+3PSnZNvNghSV3VUGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=sSEI3BqQZMe3/bZDmomfegx2t2NTMo7nvu9+toX95Grl7Mkfwj2Po6Kb6UbSWx5PEruYeczSBTRJh4wDJ9JFOpVs/W5og0RAed/O8n9G+06ABOCw8hBERVNSi6upk6rgywZjJUJ05rzowlyw1m7S8kXVHtVaJqu/14N2MNYgThc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5787.namprd10.prod.outlook.com (2603:10b6:a03:3dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 08:01:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:01:50 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 01/28] xfs: Add new name to attri/d
Date:   Thu,  9 Feb 2023 01:01:19 -0700
Message-Id: <20230209080146.378973-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0063.prod.exchangelabs.com (2603:10b6:a03:94::40)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SJ0PR10MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: ba181d6e-caeb-4990-1cc1-08db0a73e5fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TeRKkJ57HbeZWiy47bYQXWhDFVEMmVBTzwp5zCiY8vtW/dT2Vk4K77UqSf97PfdhrYKq+4M8d+nwPDdzlAfxp3XoDRKlLHeH4gPbStPDrPXgKZVkc77O9aDZSzyrdN2w9GEP43+6PDnzfh5nwL41+4kmgYY+mQlUWSLK85cLpCeYjjIdk87DBeeIrqkflqPHWlg0P0QuD7iPLzJ4pY0BRmsmAcAnVXjnglrbFZnwkoqvyWO+5aKW7OquGAbdEMDPhArPz5ZX9p9yYWIGcmzcA82bwZOva2dhR359yJSSd7pnOaNZEM1ZkUezAnsltniOVrstOtiD2u7Mup+WfZ/3l6THvtand6sVp0tA2wJThxF5z/x5GgALed7m42OJ/mES4M2ENoRW92w1JWVF0o/TPaNzRXd2FsTjejFm0n3xK84qKwW8uugnEhYvDuag77TUdYsVhcIxCPi/4SY0tvTJGiPOepW/ZUhMbZotougvyFGUdpGqxvEqf/nTgvLgJqQi2l9sX+SYPzIajdYKyuZ+X0usv6D7AjLShE3Y/TjHIUWwQC3d7gJpomfi5eT2And2bLbECtERjo6j45CFaGCe7jmzSdBH3yvz7mJzt5kS6YcUjQD1/uqhHviOzTfpHORWhR4JJ8J7m//wZjqkgYi31Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199018)(478600001)(186003)(6512007)(26005)(6666004)(30864003)(9686003)(6486002)(316002)(83380400001)(2616005)(1076003)(6506007)(66556008)(66946007)(6916009)(41300700001)(5660300002)(38100700002)(8936002)(66476007)(8676002)(86362001)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LjaLvpiV1xYk/HzNQSHE4XQ88BZVoDKOvK0oWWgP2gkfO8mgv8+EM5MzXigN?=
 =?us-ascii?Q?wGSuO7fE/kW8a6BN6Y/RJle1IBaiHmv3lydrW+UC6VXs35XBaPIFApw3LuHb?=
 =?us-ascii?Q?vu1fDF+IE5+8orYSQ+hJzhsDXLJHV9DhKVv3iOOzUbtAR3ATjn8En2KJnWyN?=
 =?us-ascii?Q?7YigmghSpF3FJd7i41mL8PHQiI+zsyKjlYR0VFNWOf/cWvPqhPI1DIwd7TEC?=
 =?us-ascii?Q?oTv71JB4FX3hLcPWQGMGjNTH1py493mtIOmkh5w5Sn/7tZ+EY9BVZhe89Pwj?=
 =?us-ascii?Q?sgJA22dXf/mTq7eLye+penDa/o6FWRIuYyC5/d4AZU7zmscXbBNcMznU2usf?=
 =?us-ascii?Q?8Y6Am5P0ohe5KMuigIy5azHqq/sQqjSe0Bva0qrbhApwJ4QASaRGjk+7pylg?=
 =?us-ascii?Q?7/2ioW/h4hZp1l92PRgbV727oOcP6ToLUmqbH0WpXCQTcSBin1GU/EFJa6BU?=
 =?us-ascii?Q?UmsZyNM517Nvz0cyOd+bXe2nlYQ7zKm89g6QyJYOO1lT6cDFvgmLA8twqzji?=
 =?us-ascii?Q?aGYWtDRB99I8Ox3QXyB8vMavA4ZmSYp7Tc5wZNGf5B9TZxeFg/rcbFhM04W0?=
 =?us-ascii?Q?kd9FOOjqUbQHhtgeugvBpMJgStRb2zSlAE9PxcZyRFM0RlyPRa8eHPUoWqYy?=
 =?us-ascii?Q?WJSz2WuK/UU20+IJOy+7QtjsWSbl6S8FEa4fr9eUepUc8ASmIwJ6aIrFNrMK?=
 =?us-ascii?Q?k8ofDWpEOXEcL68XEx3yDnNIK4WYo2exIzik4YMPzRVc7a8Hg30ce/LiM94k?=
 =?us-ascii?Q?rwJ0sBmSAMsibOi2Eh5C2iVr8qiIBTAv4KFK5pLfPj07fZmgSEXgLAJvgzWD?=
 =?us-ascii?Q?12sTrEHrCjvOgr0PIy8FEnPbfiY2PPu30Jt0uWUh2/aGTtIDdllbHCR+pLmO?=
 =?us-ascii?Q?4yqEDYXHXtxRQXSAcDOf+D6gbZsBvk2cgE9bbGYQFgTBTbv3qpw1Ut8BvI29?=
 =?us-ascii?Q?tnKFg/Bf1btOWIUNEZj88aCI+XcVPGLy6KZQBbuhoK95KpxC2od79Gg0NUPB?=
 =?us-ascii?Q?/Zk6uPdkBy5WssoOUUsXZRzScjZVn1T/DrDCx+YNPSL4QlH3cGieu96NQuQU?=
 =?us-ascii?Q?eN8PrvXlRZzh2On6N3tceEekfKcnJJIBOfWMrk7W5UO3ivBiSzEMG+WbLhWt?=
 =?us-ascii?Q?BwFFTJKTq9KErexF0NHZM+o27K3qm6UgzIC6S2zb9uSvqkVPuOYofR2KyAXm?=
 =?us-ascii?Q?0JwM5LXEuDuhLMMvUYw4H8nu/ybyxfLzUYLM/EVOz6bmcfUQR3vpZYxJJpGt?=
 =?us-ascii?Q?TNsFaTmGCPQXJz1j7H5wAyY30pjMx10e/shx8sn8VGiJfWuXMi2F3mT9qdZN?=
 =?us-ascii?Q?V1I/goTPgFO+ITLdIfbv3RmW8SRDtkiQIp1FJSw8dVZ4doLYuvnq8bNVSZhN?=
 =?us-ascii?Q?AregASG+QcWDfO7Tche6lzD6CUMCpGynH3bZ2a114+sJwzFcmRiFj+B/2s9N?=
 =?us-ascii?Q?x/z69taMbsvrbehBMrwuioaHgu0KJBe0ADVSgXczuC1Mn+ZlROTU59nHdeZh?=
 =?us-ascii?Q?gH3xbfJsTod51E0CmQhJOttz1ru6ErCKQqLBN6f6nYEmgxXuRAFhkicYRnf+?=
 =?us-ascii?Q?tZtp2dTZMBMPVFI7yzEUJpiueERFcKx4WMqU4pFybrgdN8kljpOsrBmEJnZc?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5P8aRtcSR9alJNiq9tM1sPVAxAaDTFK7wjVYO0hZOp1pwXZn0SUw0P/17dae38jUC1zwf9bMz/Y9rvytiOg2hoWOhIYAKnShdk2pk+Kpg/gPAt5sh5cUgkUFDfd4gVTnCsYfJvsQB8MD23EtAXEzZyhgDVJVcod8Noa6Icd4xLe0N3N4sLNPlLnqr6ffSZ5CR7H6OYAwjxgD8SP5c/t83dlU/4TM1auM/O6BddaegplPUUnMfoSoltCcViZMw4cjsO+fMlKMO/fZywW8nFJZAkgQp4tplJnGkzuDqcEKBux8z+it52fdSURmwco6xjMwhy9lJndWkhxd5SBWJgBLtJWE+9sBVReZEAm2l8NHzR10JPe2W+B+V5OyZaMAec/E3D5pP9ahoDCp4YjNJ7QHX3vU0SjL5N44oXg7D73Yb+CPOEkf0Ecdq78TRtkrZ7VnAGdfXNmiIoRI3M90LwBOJHBe6jo8dEUogFHqSespluIRTjOFFRrYMwhggKk6tduxSuIrcw+KROhLT64eQ+1bXlC3RYVBR1QcwWUl7ZtzY6Av2e6wGJtAMt8GG6Sev5hCGDC0iWbF0LmsXtdGMwLNhYieJHQGMN+OPcgnd23GwaGF/R/IdnNlFwRN1McZKwkvNTFvif8j6OYFHvu0HyLYnY3RzckeFwQ0lu9TyBJEUlNnTe6KIun/jo6Ow5xpMBDlFAylaCTDEaNfC5ZZ72epOb1dDQhAHej+z7BBSSpMK3XhHC0f5O/BgY4U1I5ld1zL
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba181d6e-caeb-4990-1cc1-08db0a73e5fd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:01:50.0706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3REx53Mc1bQmdRlzFlaDTIh2s/XziKO1+hjCQsjhxos7nI/eAJMH3+mohvAck43CPlngfB6ldwolCzKv0XbfGW+heeCl57IlljFjXBcD0RQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5787
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: PjhIO_VDM9FM8RGDEGTBG_m6mO775tmV
X-Proofpoint-ORIG-GUID: PjhIO_VDM9FM8RGDEGTBG_m6mO775tmV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  12 ++-
 fs/xfs/libxfs/xfs_attr.h       |   4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   2 +
 fs/xfs/libxfs/xfs_log_format.h |   6 +-
 fs/xfs/xfs_attr_item.c         | 135 +++++++++++++++++++++++++++------
 fs/xfs/xfs_attr_item.h         |   1 +
 6 files changed, 133 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..b1dbed7655e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -423,6 +423,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		if (args->new_namelen > 0) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		}
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
@@ -922,9 +928,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
+		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..3e81f3f48560 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..a4b29827603f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index f13e0809dc63..ae9c99762a24 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
+#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_MAX		31
 
 
 /*
@@ -957,6 +958,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -974,7 +976,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2788a6f2edcd..95e9ecbb4a67 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -75,6 +75,8 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
+	const void			*nname,
+	unsigned int			nname_len,
 	const void			*value,
 	unsigned int			value_len)
 {
@@ -85,15 +87,25 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + nname_len + value_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
+	if (nname_len) {
+		nv->nname.i_addr = nv->name.i_addr + name_len;
+		nv->nname.i_len = nname_len;
+		memcpy(nv->nname.i_addr, nname, nname_len);
+	} else {
+		nv->nname.i_addr = NULL;
+		nv->nname.i_len = 0;
+	}
+	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
+
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + name_len;
+		nv->value.i_addr = nv->name.i_addr + nname_len + name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -147,11 +159,15 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (!nv->value.i_len)
-		return;
+	if (nv->nname.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
+	}
 
-	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	if (nv->value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	}
 }
 
 /*
@@ -181,6 +197,9 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->nname.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
@@ -188,6 +207,10 @@ xfs_attri_item_format(
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
+
+	if (nv->nname.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
+
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
 }
@@ -374,6 +397,7 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -415,7 +439,8 @@ xfs_attr_create_intent(
 		 * deferred work state structure.
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+				args->namelen, args->new_name,
+				args->new_namelen, args->value, args->valuelen);
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
@@ -503,7 +528,8 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (attrp->__pad != 0)
+	if (attrp->alfi_op_flags != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
+	    attrp->alfi_nname_len != 0)
 		return false;
 
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
@@ -517,6 +543,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		break;
 	default:
 		return false;
@@ -526,9 +553,14 @@ xfs_attri_validate(
 		return false;
 
 	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
 	    (attrp->alfi_name_len == 0))
 		return false;
 
+	if (op == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    attrp->alfi_value_len != 0)
+		return false;
+
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
@@ -589,6 +621,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->nname.i_addr;
+	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -599,6 +633,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -688,6 +723,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -710,48 +746,102 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	const void			*attr_nname = NULL;
+	int				op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (item->ri_total != 4) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	i++;
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	i++;
+	if (attri_formatp->alfi_nname_len) {
+		/* Validate the attr nname */
+		if (item->ri_buf[i].i_len !=
+		    xlog_calc_iovec_len(attri_formatp->alfi_nname_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+
+		attr_nname = item->ri_buf[i].i_addr;
+		if (!xfs_attr_namecheck(attr_nname,
+				attri_formatp->alfi_nname_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+		i++;
+	}
+
+
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					item->ri_buf[0].i_addr,
-					item->ri_buf[0].i_len);
+					attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
 	}
 
 	/*
@@ -760,7 +850,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_name_len, attr_nname,
+			attri_formatp->alfi_nname_len, attr_value,
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 3280a7930287..24d4968dd6cc 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,6 +13,7 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	nname;
 	struct xfs_log_iovec	value;
 	refcount_t		refcount;
 
-- 
2.25.1

