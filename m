Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8362DC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2601B61606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhBRSrm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45870 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbhBRQyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:54:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGng83069662
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=pQjt0tBQ44BuJKL/rbtqzdmAiwqQCNR/9AanLSad+OM=;
 b=W1NNtV5bracu+XV4Z9AUC3vpPe5rnO+DVGslRzYkLMBYvZFnWCAN+wzO5+U7lfQjtJZz
 WS6bAw7EUrA2/whbMeUa3rYVHOvHSmANoEg+L5pPDJ+5utP8Lr5uEsGu89DMUCeKdXm7
 TbblfPogS5ebI3Q92xhXfDPTU/c8Vjav/osjn+5obPEwVHaOVsOsU3QUCKIlye+gkPOB
 NKJxiG5rjx9hbqYRwYljdra2GDA/hmGnlHY28rXzfZ2blJtwwycDFM6ksgRTofFdvzL1
 9o24w1cowG9c42Sz+TnhdANxc2qB34v8yWOVB/AX7Nyiy7NCAU5SCylmwAFiC6gcE/C9 Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ae4pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoG3Q155234
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 36prp1ruuc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gydSnamzn0shyvB82WfAg975DOHzWnSC1uzZuaXh16j2doE9tHd4DtjRI6PMF3Q8y2K0t3zqoN//YIBL5WPVuhfOdfpL15lNw4cg8xssAp4MN7ZLicWYfutfaCbtptE2MG2GcV6ZqX+DWfbdT90kuadRe36vJ4TRIiddRkqbn25VWVre3oPaHY+wn2LnII1eErqsmLmOId2974t+5CSmiaFgLXd4XKzBiamZbuHhCyhK57loRHvUyJ3KdmSzrsIUT8/+Ae2DmV1KenxlxY0QF58idRjyBQNzAYqrMyStIDN0Kuog3W1aqq9Ezorz+VEGeu1cD0I3sk0It2d+zJO7zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQjt0tBQ44BuJKL/rbtqzdmAiwqQCNR/9AanLSad+OM=;
 b=fhQV06ivoWwrNyx8ZFslVcrBF51VE013llBYE2pPSvIwquu6+lw8O9ZAWjRMzOupv7uG6vURqtayxwEtF2gbKAfUuTaGBX/Sxkf/DtIMWXAIqI+XIa6eGJphFTg+/Rbbb86yACTtnz4YJdxzlD7OsYrBcJowk/vy+u7y3byp8X7z+xexq/ULcAbREngaS4GlaAXgjLx5Z9Doswi67ll3T/vbskoJo8xwPOjjR1GEDb+ny+q13O5XAhQLDnefFG4JeiieG4tUwVR4Rg4uIfYVf4QXuubO+hsXNjUnSdaAaExGpe/4qtjr0bJsANNimtAloOa1D8mUsNWiuYuE3T2Y5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQjt0tBQ44BuJKL/rbtqzdmAiwqQCNR/9AanLSad+OM=;
 b=DoD5so/AU4RBz2NtiSyVJt+VoGJX9/OCfnoAEflEqeucbTyNZKcGBgl0JuLbdT3h487lRuQlexnDbzsEAMnJhWxTnZoMnAWSr1vMkM6z5sYnMkNk6emdTvk8hEdubhl9r3+JmvgeR4rboVFZPapRY4tBOIV2PBnKU6+uaLP9pyE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:05 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 06/22] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_work
Date:   Thu, 18 Feb 2021 09:53:32 -0700
Message-Id: <20210218165348.4754-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3f4ace2-4c0d-4efc-2b32-08d8d42dcd3f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3381EA54FEF178C33263C9A895859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxOSazc0y4H+2eLuw/852jIRSsf4FnkqswnmSv+xvYlgIZrJd3O6D2mEhGseFtmcrnE9qYRi3NCenM6XAUjL4ijBL6EEvmkjWrJyVhp3aA1XO82G077xtjPK0ZOji11ttKJoyfHGphvXMTYodVijbNiyYr6/6JsLaEZ+J3tYG07N96ROChpOQkTz7Fnic7LEHB1EGEhc9Qi+uy6wq6rgRogwtH0WSj1XX2VsN1pQt5V+NtvzgvXZBL9n1Y75NncaDdsEaqoEWoWMRfaz7sgUK+rKVjzzNimuW/3JazHQcy9FYKdzAtmzO3KqxBKUWv349p6mcKGBgZkvATdqRAIlNC2cS4yjPQKQl2Is/e8d4+4+e8z57LDVSO0DCFryZfKwmcM8j6k1OWyISevl3sAGx2CQAbh4hwZ8KIjxn641YkQL9Lm5gYf9Mj6DDqZ9TsLYnT0Rbf+/WukeAWqgBdajQl5t6X72xrerJGHEAtT2DvuW8KV95uqdlSN2LxNX0LqCd0E1ANe1nzwyw+kIz68cOau50TaayNkV+NK3Ev9LypQX1DoDXI/16rdDed6Huk0S/qEB9gl2qxF8hTfkszOXIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tjoUOpFvaZjnLRu/Z6h6OMQ1aoBB4x+7f6mkTLHd/Zmo6ecWpXlo3rm6ZIfv?=
 =?us-ascii?Q?nJ454NB/g0gQrjoVfbfs6sdE9zbKQVfbbre1Gggg1Pj8PLQhLihangGbuMyi?=
 =?us-ascii?Q?+vGu+4dKRHLznSnmtUbJqmxFQbk1ShBGepRV7U6uz1DJGXkAfxn0T5gglMgS?=
 =?us-ascii?Q?j4l3y+kgIU5Lwpuzs4L08hBlFkw4XXXoKHuLxylUuFZmCrDeZgazHoWnx4In?=
 =?us-ascii?Q?CGxRNa0sVwbeiYk6k4knRDdn5Qgws2CODXowSqamYgI+5ykYd/eDRZ7+H2ES?=
 =?us-ascii?Q?Ql2aHU/P8b0AOOnRuI7WUC0KkjVcVfN+3EPipudxggPDsKhLfvxVArspwdU0?=
 =?us-ascii?Q?0GpL2DVrq4eQPOMSZLga27v/gIbO96aAL+PTo/SfgazR3hJtv6JrDz+iPob6?=
 =?us-ascii?Q?U7KDQ0JFTblM4hJpiRg6zBPO20FcVxZ9W554axJydIs8RIcSQ6sXQdgS+Yga?=
 =?us-ascii?Q?XLH5TZ7vSYwUsnCDR+zCJWdHsjwsfUA9R53YRyQ1RVh8n8qfJ7JPB+GDKKIW?=
 =?us-ascii?Q?t3n9fJ/xNXfPtPfzcw4dLGORI2YI7Aejmxuf8Wd8cG128uzYXAzG+nG1h3ey?=
 =?us-ascii?Q?ownC+XtM+FgvqKall/sEzmYbPHsCEHPgojs44T03fy33KJ+1y4ZuWBptZ1IG?=
 =?us-ascii?Q?1+EEzpHVTRATN1sq98oPSUaqHw1srFH6HLTZLEelOtbCD1eNmpwmvPtPbaRi?=
 =?us-ascii?Q?Rd4X74n/5EsCOUSEoxaxy/wDt2AABBVrxy4j25FhvkfkYT8bEggCLUebvi+s?=
 =?us-ascii?Q?eiWvSiNIxgItE0OAVVZHhY/lMbJg6Vs55o99TpYLYqtQK66y7bNQ6dHRaBlW?=
 =?us-ascii?Q?GvSU2ZsO5Hxl7BvMQXoFPcI+Rir1cKSZSb/zxyOa2COE40UpxfvVznwrgP5m?=
 =?us-ascii?Q?9kjJmDND3T53sfsX42b8Y2RQirLPRQVUQVNhmCsXFPv2R8WpT145eUSTunKX?=
 =?us-ascii?Q?tOaXqEoxPPmjcnbsO8BlTzVUf4Hab13LW2MfaiDJzl0w24T0qz5AHXBKi851?=
 =?us-ascii?Q?DNb0tAxxdYZTRiSEhiUIDA+LhrM8ONZZt/7gvU9J7J+C3W1ag6VSfYs4xTgL?=
 =?us-ascii?Q?bRjdJIbXmq8ldlJWs3zmiyJMZRENK2IYgaHpDCylPG+uMJaj+dFFT3UV4eFh?=
 =?us-ascii?Q?vWSF71sqUup9jcEgZ0P57+kfJGpqeUfMLiUIFDlDQkpj+WnB9GExTPs11Ddu?=
 =?us-ascii?Q?NUAV31A3CR2B5w766kvzScwq+zBXYAO+ocMeDZTe9ktVUpJMMz1I0tNsii7m?=
 =?us-ascii?Q?1mBysimDeYNsjgYY+HTyu1WQg/hjsxUkkdDQ+O3rF5UHhhYY1YbBqJoZek6K?=
 =?us-ascii?Q?wGuFErHucSWbkNqFdaTLL5jb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f4ace2-4c0d-4efc-2b32-08d8d42dcd3f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:05.6166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x6sXVwXQR2WvS1Sh+MW7mBDDd734Bs/vNa4Oxq6LJYRTcQ2dal3kVSMqsTYls0ZBQH+viPLw7Um8BZN/OixESZVGBut3+lpQhWniMRE64Lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 205ad26..bee8d3fb 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1059,6 +1060,25 @@ xfs_attr_node_addname(
 			return error;
 	}
 
+	error = xfs_attr_node_addname_work(args);
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
+int xfs_attr_node_addname_work(
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

