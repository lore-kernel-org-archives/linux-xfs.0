Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43310C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15430613F7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbhD1IKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50600 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237200AbhD1IKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S7xo1X035439
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=o0I0Ch07PaZHTOpMQUWaZgtpF3nlAGAnoK721PtUP2c=;
 b=XyBU+9c9ZsWUyL84ds0ZdWsYJoUOE6OfCMVqbd8Oju6n1e4mZVocHwQWt1n88UDJnsfA
 7hnAvaXTE9LMj0Hp58yrlFnfsV8H9yv/LT0Y2Vw4g/kfKqM+4KNhR5F31O1tuKGInhVG
 lfz+y1Hm3EptXWzESzFblSrSGSCvTJfRRI6XkMBcsfqu/tSovvm6JzPK2s1cPQvG6vLf
 3f9kmKvQx90of7AFjXvGTVCIjX2H/LuVDpr9UadgZvLHZjH86WQhyqHz+CbGCIn8Ec6l
 9SYpknJZ17oYj2msB++sjmF2gDxzFi8hNZvRKXafrasAAvyeV8gKo+3quuenBTHgTKBU 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 385ahbqw9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJi196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:36 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYJnLRwL7e+K/Z/3+5Dp9RLUzHlbL5JvHpJl/ncGj4VMTDE6H1fL5lcXlJ3/HYeypqs+JU9aOtIWMSC8VKQ6SR6goTnptxt7eZ9YT+eMNmTMwoppycsLp6zNDNe2W8MHjhwhO3qZW8s7tMWJCYZ9QECIb86rhfQ+ZOuJq/R8Nl3YdB9k6BKW9RbjictVCfuNgnCjH/0ILGS39lyNWTeasWsIZIwflYPkYP3O+TQX9hU7cxfV0iKWQT6W1YoO+S/O6SuVtAPvjAXJLx7uYEDLNRIU6RIH/IjeNtAvHxo2w+YAa1MDnIdKv4ATExecx5bpJTMVkZ8xe513vV4LWzo5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0I0Ch07PaZHTOpMQUWaZgtpF3nlAGAnoK721PtUP2c=;
 b=A23oFQI0OuhmAAWVtHN0pd77ny8Ee2mS9yoF7TN72eloxhnkbfoEz7FbQjsp5M1kgVS4y5SEbw4r7tjS8a8O0tHRygOrdS9KgxQXnyM1ta+eReX4qFoEVsrf1Nmc+BEXmHw2gJbofL4UtKv85bi/SvWs3JdJMq9u9xbLFFAK1BFv9iQGEx64JIMP6cHASsTc3VDWHcBv1CljMoyBSVCug3OpTJ2PRCNCTzWuZAScbJfbIpwWMH30hom/+iKooLYSolYqOP9j0210KQf1KIbxHk9jen+BMJQDY/vhZczZGLVRNYBM/JkPm/FOm+5uWC0NJ4pzq3XvJuL0U8CN2MWPWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0I0Ch07PaZHTOpMQUWaZgtpF3nlAGAnoK721PtUP2c=;
 b=BDjBYKTzKdI3pkUmXpztWeLfBatbJh3RUDgUduWpY9sRBE+zloH7n/ADv/bmXHT/SSX5IhhxFkfyCi8bRflefy25ETypII9ibLAtuw3VZ2NKlCjXv1ABSRJd9K32xu6X22Miz45s+Q0/eF6HCbnjwQbwrYdjAW7K894qkeSuypo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 05/11] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
Date:   Wed, 28 Apr 2021 01:09:13 -0700
Message-Id: <20210428080919.20331-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428080919.20331-1-allison.henderson@oracle.com>
References: <20210428080919.20331-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70a82a2c-7a02-4863-2b1d-08d90a1cf49a
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB4086066884C7BC518D09B7CC95409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dxc98d1nLvzdRznuyX04plXLw+RhmzI8Q1lMCG0PUqgwxGRa3Akr+zWViFgq80pjY8L4mwkUfFi3touhxl41/0EA6kV/SuuA9AkdDE86wMntLAv1HkMA8kUDUBqE/nGuQIulbKp/xstAtAEwUDBAqVUNYXtdI8jvDlR4HH8WA+5d0e2Y+37HdGGsI2BMMmHY3kpwKHIM/qrC8bE6aLIbs07prDCRMqhOdvoRnCeSBHmNO697AeOHGDlBDsMQBlDTZRZOOBJsfPOii8aq8tIrYfoxxapXeuz415/SvjyI17TkJFJa2t8tHQfmV+iVamX5KFHXxUimFIEloYv9pKw+583q1Ecg131tuxrpASIuSZk/Bq38OenKmw9IG+qSpnOKtpVvjrhsEnRsAc3u5comKUwlS27zo6THc76PsMKe6Qs6GVwpfohy1N1GEGxXSPt07ew5DEtNyCr3RUEvgzg9eWGL3MNrZW6alIje5aENFaZc8eXL1P1hfGXBVJPQ1ax+rhEXTQL2kfH0OoRChDyNsMM/JaNU6vp6wcJDl+Lsj6Cb3OZe+c5a707/kL+nKytQorGqIL2MXwnf/pvgg/KOvQAuGsfY3itO/Agq3L9AfYV2iSviNwnAzpwXSepRoa0E0NvUQotwxOncfFmuYEe9Z1jpBm8HuZ8QWxxZG5f0uLWDGEvLOMj88f2Oy6CkA8G4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(478600001)(2906002)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ll6lXF6FGNkovEeAi9N7uRK0kEADLnFfmXLrqk6PVHft7xOJjZfB6yq67LuO?=
 =?us-ascii?Q?bvYmFCXZzHU9WJYTs6WvJAuedMBWzRCBPxNTAm51G2tQjRSwyCZajeE2Pmp+?=
 =?us-ascii?Q?kCUh7/r52k7v+NJWXFcwtMmHBNUtV7vIOg/atVaUYe3HN5vY17BQWRD5X8j+?=
 =?us-ascii?Q?fdx+2TpTJvPicwl91EnwkAXhZQ7tO+4vEnHa1mLgI1Y7bntNTxuBSnzvtM5D?=
 =?us-ascii?Q?tNwD7Xf9k3j5idWRmakAXU6Cft1nX1tNDTNKmjjau40wuQgzQLyFQlAbSOY3?=
 =?us-ascii?Q?/+IhyALOejorP3L4avjg5FOTTaUfM2RJpb5ln3isXicGKfvMrMWCOgTvbTEw?=
 =?us-ascii?Q?qv+kdehgQhReK+4G7G3dvUNXvWR+nQAfbi/5fPG1eegWI7P8mV8EGPn5mRf5?=
 =?us-ascii?Q?PIW8nZyA8iknQ9lwP+2lsFCayZjtkOuTzkJWnificDIHeqjBsU/xcvukuvQD?=
 =?us-ascii?Q?kgEyczmIZ9q7clnhWE8zXVd+zEqajrCPWAw6lIPHmQnAtkB0M/wxceqz2Ra5?=
 =?us-ascii?Q?tan4jkuVSxL4fQkd1hIZBEVpzhlGvO7QYIGTzDVrKW+dVReoCyeo6cErPLco?=
 =?us-ascii?Q?x7i4uff5UR4RbkF2ZBNHBth83/cHbHbnTQtUqBNKf1R02e5jHAkWno69bB4o?=
 =?us-ascii?Q?xlSTGTZE6PGkX9aEqjrxQx3EblhL7qQgOqnhpfGcNhiJgClIGqGQQkLwxy5h?=
 =?us-ascii?Q?f+FC0OykhgsDdqlMeO58wd4oRX+rYojaCZBx/SN94Z04RmP3Y5958ZpQWO6L?=
 =?us-ascii?Q?JDsuGAKnmxwKBJ5v3rchwZ43+xJ38eXaMK7EvfNARVm2d2iGBhNjdYkZ8YQd?=
 =?us-ascii?Q?sDlageQMxus5JU9dQGbsMZvhYdlqaj0uY/nq5SwpXknwmyumKnJ3PMi7KF8G?=
 =?us-ascii?Q?w9ZNtJKFkOanlq02X+8kWKUExkkaczvVn6jM+eqAQLI/qDQNqfNXCeq5HoLb?=
 =?us-ascii?Q?H2CkAdNletvGPfauxpQ25R6S0pjCv13qNxZI39XDak9VAXoDA82o8bt/RmnJ?=
 =?us-ascii?Q?EdY2TIuX35c7zRLk8tSX4PUE6yFAXZWq0cLfw4p89GDABz+d6YrLrTJm5vUn?=
 =?us-ascii?Q?jOMux7mnJkqyBrMZmiuw+vZRF0z10DIRQpUPgox+7cSuyYG5Z/iacXsAKj17?=
 =?us-ascii?Q?khRqUdkoCHDsIlfcHfxdkGgoCvZZfou/qOlz809esjMqubn5lJAy+defuDTW?=
 =?us-ascii?Q?m/32EHnJfz0d9tSDyl6IgeHHgP6hS575aehrzLTmutvKGaUM0vqBkG26aHg5?=
 =?us-ascii?Q?mAiCbZdOggj4hfuTbO/9hpkN8jZl4hAfheEk9CBVl5O2Bx8w0g7D45PljRgK?=
 =?us-ascii?Q?Akbom4RRWCv33FaOe+4l+ymS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a82a2c-7a02-4863-2b1d-08d90a1cf49a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:33.0524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m7Uyjp1W0RL8mMKTw9mbPbaaIfXGxEnVWiyJt6u9H8DjRV+QqHEj1Po3j9wWh3MvUR1RIKiIJcgvhx+pEJZntn+Q+N3bSZ5GNJ7CIlAipNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-GUID: RUB8gilli65UZxDX8hje0-XboJAGLeNl
X-Proofpoint-ORIG-GUID: RUB8gilli65UZxDX8hje0-XboJAGLeNl
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1a618a2..5cf2e71 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1073,6 +1074,28 @@ xfs_attr_node_addname(
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
+STATIC
+int xfs_attr_node_addname_clear_incomplete(
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

