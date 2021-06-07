Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 512DAC4743C
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 05:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34FB46120F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 05:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhFGF3y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 01:29:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhFGF3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 01:29:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1575S3Qi007863
        for <linux-xfs@vger.kernel.org>; Mon, 7 Jun 2021 05:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8BPR/yxCjs+1PKh344Vx5oDlK834YRRWJZf0nvi2DY0=;
 b=TsxNLjNkSWtHmFbGVOwhfKLwPtbjryEu3s24+cQXq4HNcaNBODVEfTOk4/hWyH2j5xTK
 8yNxibe0H/gR1j7ytT3MOtAfncfUYVyhEedwd9uncmO+SyeC6q8jy3dKzZOdpVtOM+oK
 lMJAayUSotXIm2kfIX97uKsVTBLRf+ClYaReLlKTCrh0e6P5W2D1GO61F5whurKBG3jW
 9BI1+HU7VdEIRaBg1EQJ6vCJtpuVfo8PM1cM/aNfryo5YX7y/5KZkbdEfB+GpZIBOz8b
 m/36qVAdp1jFI/AJ8hMleXC8OEbNxayxEtRR4BlIJGo/ygqc+39xvRcXFa3QbBQF2ECH IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3914qugaq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 05:28:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1575PmCl178624
        for <linux-xfs@vger.kernel.org>; Mon, 7 Jun 2021 05:28:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 3906snnq3j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 05:28:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4NL+hrQy8HmY/WxdrDWf7VJK9h2MRSlqgEf1PhrJgtm8/CaF4KejG6cH3K1mZ7M1h9GMzpqARiCZuQweR93gAVpvNSmi3JY1aDoxiNT7HDOdI7q4P4kupu9KoT5x7nLhrE0crGytgrEzGIAiwHdA30pimFOENVvWL/57Xvgrzx7Y4R2bpeHZX20CkEdIs1gadDiXKDxFyNd1t9UvH4DdFztQyfypV3PbfLVvE8Z0Xbk/nmTbafUlpgtK83OrCQFYvkk+5lWnCdTCH0b/iHnbJp/hdMvKpcWdb5gx0lD59q7sP7uKV/VKHGdOqDGhMWQPDHMAyw+Hdv+dUcy9ekGlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BPR/yxCjs+1PKh344Vx5oDlK834YRRWJZf0nvi2DY0=;
 b=ll2vHl1ECCEAx0nsef9ZgP9a+iIpg/fUIZsF3KE1yIbJk+do2lcrxd+X1bSN2IK/zRohHhZzqViAmdD3oaRNbocTKm2Pao62ZlyVoKt8OdVzgZNeyIadj8Mli1wr+/9HAZXYzoJawy8dUZGoErh6+KrcN/jl1joVkXgwMJbG1A/jgilCYEyHhSs50LlV/vDHnYu5tszZzT/68SOWc6igl1BYrL9ztl0wuIXSnqP65PwY6jA4Eo/lUh7xeIhnv4JNBTAbwG+tx2gUfey23q0/ym7cTASzNJmvUoz9p15/hkCbj0zC0fwrePxfigT8574ChaDlE92PZEgBr0osb5G0MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BPR/yxCjs+1PKh344Vx5oDlK834YRRWJZf0nvi2DY0=;
 b=uxMdCALLtxRm4MQ/cXTOb8JI4dVF/OEZesYScDY4WnLNBsyLtHQeh9sH2G9+aZcMBuLm4KiRy54s/mD04lmZhmbZMWI2L9R6UJnIzlncGU1UDNfLyIpldPNXqJgCZlGIhctiKy+ADtvse6HeMRzCuZ5LNr516K+Ao16+wD/tVsE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4687.namprd10.prod.outlook.com (2603:10b6:a03:2d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 05:28:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 05:28:00 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 13/14] xfs: Fix default ASSERT in xfs_attr_set_iter
Date:   Sun,  6 Jun 2021 22:27:46 -0700
Message-Id: <20210607052747.31422-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210607052747.31422-1-allison.henderson@oracle.com>
References: <20210607052747.31422-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:a03:100::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR08CA0019.namprd08.prod.outlook.com (2603:10b6:a03:100::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Mon, 7 Jun 2021 05:27:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77e67f92-5a04-46f5-67fd-08d9297503a6
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4687:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46873D53CCF621BC80FA556F95389@SJ0PR10MB4687.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tn5FlftWtrk9q37NC5B+DWKk0PO2XshwM+n+9G8Lc9wGVvXahoslOKwtdk6i/zzpIzRjlqQXy6ELo/l6gPBX0Ac/M8OXqzq3imuZhQOIbdOhJLs+2FX2Asl0JDD8r0ptcQOfUx1KqWEFDkJLQCoOgWyI4PCs++foPIwD1BKRnBswRNB6rjFlSsI6sIW3Fy8xcJHrw+CWg2OLJB4hu2tRCsu6xBAXRSEtBaJJaPZyEBXO9SJgxjVYZylVR+BAvFQOd1JbRiO6Q7ateW1dsxLkk/qzFodzwuKkSwgiz1WmznfkQTfdlHjjh/Sk2zhTNR8FijcT55nd/WOFgSXOyApDfAjB3Q28o+1WRxTXicQr+Tfe0dQxsL1BCwDc2YWH0m+iCUHQpl+9YcgOUDAG20KUFwCl4bfMNdt4H/J6/lTVTf8ZKFz6JNo0DJJVCL9TZc4opASo90t5l6/dC0IKHibJjfdSNizj8Sv1/dNyR5Ebovvx2/Wwsq/rl02PogS6GVA/G0ARTHcrHzgr2zDVjDNsK408yxtv//343bZRa5Ai8a/ELKSao8FteVCZhoNZmzIV9MwSNEZsFckNCIn24UF8NRFsmWq8rBsSt1WrQv9z5+e64UMt7MeD76PXWptgNHVuMtBPjt5EJXIq2/BoDc8e/Sg0HPolC5Sgy6y3d0eQiIRf14hW8A5qDPdwIbkFazR6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(136003)(396003)(366004)(186003)(16526019)(4744005)(1076003)(316002)(6512007)(6666004)(8676002)(8936002)(38350700002)(6486002)(26005)(83380400001)(44832011)(66476007)(66556008)(66946007)(36756003)(86362001)(5660300002)(956004)(52116002)(478600001)(38100700002)(6916009)(2616005)(2906002)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k9KFZIP98kWedozE0S/o+wkCRp3UIRBb7wxcxqX3u5M6dEx1VBgYN334/CvL?=
 =?us-ascii?Q?w0WcwmKBSvFwW2sTqL2cGniTC251VL+3RmEttZ/NiBu9XzbUOYjowUtHZsaK?=
 =?us-ascii?Q?NHEv0+NC+kyXd4vvosgpx85JyLhpEHgO0C7uBU/qteqbZos1oPTjsW3xYrdc?=
 =?us-ascii?Q?oYqEHWnyEr/fhspN4FWB7F8X4DDQ5psZsjwGFMurYYvlxbnHdpjXOQLMsmIC?=
 =?us-ascii?Q?HhJHr5rRD8ZBW2f/0WSK8liFTUdIQZdz1ivFvn4z26dIR0mgOuVzgtvk6wML?=
 =?us-ascii?Q?2nm3RIMOxzipWsJMevzJkQg9aIYIzBFJfG41/0X8OPVszId5AwTmq/dFVR0Z?=
 =?us-ascii?Q?Gy7Xp7CdvR42oxGReY7PJar/mGnNowVEZpa1EPEJWwvsAxoZdaldgQ2gCOwk?=
 =?us-ascii?Q?j3Ene9rVcaX5JwtRYtNnnZ2Ybuwvj+M5NKcQeBW64WOszWg/M1jYTdS7UGXD?=
 =?us-ascii?Q?Ul8c1uuooOwEpb/jS9at4ypws4nO+AAGQ+pe4tG9PggYZHCUGvBCdB6DORWA?=
 =?us-ascii?Q?NEzOoIJ4PzbKx1iYSLPqwVxZ3a2YB9wDzWe9+QgiLrclcz7Hyyg5b4TgHWAK?=
 =?us-ascii?Q?8VT52hYBxQnG+DcbW/AbbmCFA9kwrfQ3qyQSEH34BAcWB8iVdFGsjJncmOWD?=
 =?us-ascii?Q?vQ8HwROjc0a7EITbWy5P8Re8Dxb1CnqIx50S93+X7sY2fXUKyyk9qdU2atGr?=
 =?us-ascii?Q?/FBRTN+q1PFBzEPVq5ijcxkKRSVwJwl4J4k1ZuamjpO1wpAvr+s+7fvKg769?=
 =?us-ascii?Q?j3Qshugs4QDPhtm/iZO4f/GjjNHu556NTrdSfgenziVe0wHz30Scnhq88KXW?=
 =?us-ascii?Q?pjiKmgrBpOL18vak4HSWTFX5SAGbEmFzYslKoaOqUF49gBEjPH+t8uxE2vGR?=
 =?us-ascii?Q?G8TSgeIqigbe7pipysKkMxixwPrT73JCSM3V94IPooOjROgWrNcd5q+dWfUC?=
 =?us-ascii?Q?clYfyJ3SViCh3ugilhP0sarpM15OZ7wVtXrcoDk0vq+QiM286TFCIn/xnfzh?=
 =?us-ascii?Q?3PoafVdemzntZ1pKpbKIqF2CNv/7PQVxjotCCyWplM5TW8gbYtqxU1ds8GyB?=
 =?us-ascii?Q?DWO4R91tCaKtBykzXsb5a252Dv38mWEqBx8oo9FLIAQXDP4P8B4/0RmTozrF?=
 =?us-ascii?Q?+9Ye6PJEPZ0+Q2XkQ44hv0CETcR8w40IYcei2/hpEBgh4x05jBKAFnx+YUs4?=
 =?us-ascii?Q?K0fdW8DGvUU8dfai/X0BxAYzQv6P6a/dyT2Ty4k/YghTRLiUehV1DyGIcQMX?=
 =?us-ascii?Q?VhhMxfu5+xy6KDaM3poh1dlKPN6xijVQeX0+LVx7Uql+5LFfEvofWSbAVpZF?=
 =?us-ascii?Q?NE78oH4pqqZWx9px7/mgFyxt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e67f92-5a04-46f5-67fd-08d9297503a6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 05:28:00.0129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWeOEJqED9RdGn3ZmgSfMexLRTcS3CY+C4FMx5kiwkZTqyK6J9T5U4Yt58x7LQAHPTwI40cXim3d3r4Uacwonu7QpW2JeSRmwWzEA4jtr5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4687
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10007 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070041
X-Proofpoint-ORIG-GUID: _gdIjo0M9OFefhajPuSkXwrR-M4ZlSro
X-Proofpoint-GUID: _gdIjo0M9OFefhajPuSkXwrR-M4ZlSro
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10007 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070041
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This ASSERT checks for the state value of RM_SHRINK in the set path
which should never happen.  Change to ASSERT(0);

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2387a41..a0edebc 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -612,7 +612,7 @@ xfs_attr_set_iter(
 		error = xfs_attr_node_addname_clear_incomplete(dac);
 		break;
 	default:
-		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
+		ASSERT(0);
 		break;
 	}
 out:
-- 
2.7.4

