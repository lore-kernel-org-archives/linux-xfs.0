Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACF0EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjGUJqk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjGUJqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:46:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3264F0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:46:38 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMVhh002002;
        Fri, 21 Jul 2023 09:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=gPFiyvYDKJuasOfkr+VvVb83W7GBnnHtVP9oyYOqt60=;
 b=vQoB5r+T5EzRJKV//BjxVsXy5eGuSkzrVPuMXacCYqHQv25dKSSoveZ5B1z7tz0Cux9t
 xZkT0C1WgP5z1lIIBaUvcPNXpzYPDrlj16iEdBeBE85ULCyOp3AC97r5jiLWtnYQTJxY
 F/4XFkA4jd9nuasUmlB3zObVMcwmVJFZo0GlRmOxg0qn0IassWgBdHjMa8PWW2AttSer
 jY+vALH5ejAICgFs8TrbbWxeKm4Quyf9nn1yk58bS7NLE7KLuLM2o5Rz5o3lU0VivOfn
 VZktAfPMT5WpoWUmtYWwy4U8iytm6jAYVnsJxFYJMIJoZGBnskxYlLbJKHbiIc78VxZq wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run773km3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L8ZK1S023806;
        Fri, 21 Jul 2023 09:46:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhwa27t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PF8pCNoihvMBkQQPIts6R2Xi8eSGbeFZLYcvVDFU2jhnGWLsozVdFhbTG1CDJwp4th/usHvQdDmlXrf7QAVse+Zsz+Em2woTzXit7HHQmWBmz02r7XFQYP+qHxMk4FgaLCYfCdE0gDYonrdNZoH2M3V7rO4ci0b6o2yIZanWSS0ctN+caglV/sK0KaWN/LKSxWOPosA0U3cac4lL0E04N52O2g88oQCPu7tlD/I7/tmIjB31Ji2JtAqq44Wqko0EvMHBbPtdroNbQVmjoLAitvOA3UUQy9HPr7szylHZCl2HOyq/2ME9REdixP2X5jpZf92+TYpOzswBM0NiYgLNiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPFiyvYDKJuasOfkr+VvVb83W7GBnnHtVP9oyYOqt60=;
 b=Vdu70mb7rXQEWzWTDNnXyqYxwAZs0jl03E9L2+KSAkWkZ24W1gQTjqWW32Xm4ndNKMEcY+LGJ02LNLCdTjxdL30L1PDijBkqLagLMMOOmbvNK8w+TSYhGbgSOiNyHFPzIFJ/DEioeYA3n/vhC5uKS6KZpbxpfwhFKEsEkIBnjuPltgzYaYcrWYuHF1Cl5O0yLI/WiW8rTIagu5IKabSghZpqln+WaeekUCbDI1vA337ZtMzEs+1E1EPy89YrGx9YaXVqGcrgnIUPCHk6Ez6LCtU1Obwzt8uAEyc9gCkMxgJQxXLvVIPxI8EEn2zTw9c+n9dgHeUXhPOmwnuVzVHgLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPFiyvYDKJuasOfkr+VvVb83W7GBnnHtVP9oyYOqt60=;
 b=cWrrOTOy4sAKVsmH73qHCt8Mh/wzI1+eYW/JLN2domXKKMOVQvZ09I/KZH22ofs5tTtrQ/7V1bgUoxHwZnXMBOPnoZsfKFR8oLVLyBeBDJM5zvBO5/BswsjpIjESjmJKkWHHzAPZwiP9AxVWnVjvzXdOasHRxUpJtFxu6kQ+X+4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 09:46:32 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:46:32 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 07/23] metadump: Introduce struct metadump_ops
Date:   Fri, 21 Jul 2023 15:15:17 +0530
Message-Id: <20230721094533.1351868-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0193.apcprd04.prod.outlook.com
 (2603:1096:4:14::31) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 40987638-0e5b-4f30-eb07-08db89cf5dae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OjeNpBvVXW8T6dvv9ZnXdIAVarU5/jmOC1oQXGkz5kSMQYuuf8dY8r+FWyG9BuAl6GpKq621h6/F0meafpaP8sk444RaY1lZttgBARB8GW+td1tShBfSH+vn266U4ySDDa8Xn9dlYFRELz9cgmE/E/o097l4DfowvMOkFKdX/pLApVL6DXSrY8RgKUyRwDF43dVQ1xe201aBs0so+QTtIYEfko4F6r2AkrtFIQIyH30d02YcPn9/3hdNjf5jvyhSoFSmRfcf7iG8ZWW3JaXsruCRPMK6bGxfMhylI7pABq7aCGE0gMs9rwWipoYfXEw7+GvwFkEQCvbSXoccfa1oP7LT8RoU1HqiesnZ+4ZKEGHCb0nCxEtxMyOmQwJuZt8HdOafqD3x0vEVgP+9vN//cCKv8+OTHV0q2KbLyfO/0mUu+wiWWFaw6XPlVNKaltT3BON3Lk957iRzKXWWRPO6LuCZDnzAQ2GzrLOGmjvodcc2KAiUdGubXd1by53YZBJ7QdWs8ro0hiC8hDMtF7I+fzCZqioIKjbkGnZZYG0YP8gJUxbNyo5cQfP18wmcoQ+a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(6486002)(6666004)(6512007)(83380400001)(36756003)(2616005)(86362001)(38100700002)(6506007)(186003)(26005)(1076003)(2906002)(8676002)(8936002)(316002)(66946007)(66476007)(66556008)(4326008)(6916009)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sSlDaSKGX5FgphM6v3irKc7YcL8C+B+wfCRdPOMaR+0urCk/POovcmsJYZNH?=
 =?us-ascii?Q?jRxJ6dQqmUfuSMX90gIahSJ3L6e4RjIuktZ3sSw0BBoHaxZHxY2XzoJqKidA?=
 =?us-ascii?Q?+KsM3wwkeLPREGyEWUhIVJbYWSX6zRQ2+rzW93ync9t/0rAn9emKiA7E4YgU?=
 =?us-ascii?Q?qRZyzlu7DXJTnehgyCxRk2ybMaBIjLGITOrARYY3VtxtK26Nl3wnk/Pmm7UH?=
 =?us-ascii?Q?3XGvy1N64Gw75EGvO7GGFfxgMERe0e/paq+GCwGxoTtE743Y+FoJRr3gkPwp?=
 =?us-ascii?Q?M3rgrtrGtnds1T0DmyIqIBcFV6Bq4HuRqBaBC0JOqP0LXpmcLTTXK88bCTIY?=
 =?us-ascii?Q?834w73oV1a9akXXm2GjDeqA3Iq2M0nP65akiPkZfRPwDjnwHw5YZyu1HA7tz?=
 =?us-ascii?Q?oBNpxthJco5SW/Ku1mJvkD/ErFod+a37ePN8a/nKKj7iyqILwa6ZkwA17tjh?=
 =?us-ascii?Q?kgokj6U7lLi/AaD92xiUbPYXex2XcerM0yG44+CdDyEmcui2OVSkk8hKk+WP?=
 =?us-ascii?Q?2APtaOgT3qRrHhkoSiUAx45BzqkgOciAHm4RQgf/i6EXz0Audy8ZzWyO0JnP?=
 =?us-ascii?Q?Eg5RIlm5R2oHutvKVbJe+jlfTvOG+FfLECyw+svyjTnLQ2nj3DFX5S39arfC?=
 =?us-ascii?Q?Nc3DnO7U4cmHKYEVwb+c23kdvIEk+y0NC+1H8Uk9TYIaRH1mwtksqLfwvR9J?=
 =?us-ascii?Q?ukBb73Uq8oAGNOWSaZSngbStuOmvhs7l8LLvOft5L5ySYE1xcYzKtVzd/3XX?=
 =?us-ascii?Q?IpFn613cegJuQtVpbXy89Q8qMSb/wk4LeEJ8HzuNBedEHSVNoo3DeDCZPA5o?=
 =?us-ascii?Q?K0k6dhGX1nil1+aN6yeXXPB1Ct0PIhdsp9ds/PtvDxlM2c7iLQKhgA1hpUYR?=
 =?us-ascii?Q?oQuGmgVZ+AK/Yk/IVJiGfw/R4aFgVOEwJhoPrjNhMDBeIYmkRFhKzNNCpLw9?=
 =?us-ascii?Q?Yy41BMpAoYX3+XFEjuZydn1X3EHPMwWNVkS3oYCwYXXv0ds+S9FI2pNhjj33?=
 =?us-ascii?Q?uBG0W9HjxD211xBSwwYjmsVIXUA2ZWT6Hxk9t1dPFLNfIfESEY3EoefBESQP?=
 =?us-ascii?Q?E0FBiex/omRQ6dk5j2HybEj51/38wbxz+tJ/eN1NU/Mk3u+WSu78mQ5aMW0M?=
 =?us-ascii?Q?UBfx9kWNgGUJ8/8yng3hI+vIczmfrakIu33SP1lpT7P/xDQ243rELJIQtKLQ?=
 =?us-ascii?Q?+5mAFxz5lEGJzTwgN5kKS/+JSJJ33V2iZS8tST/uvEVi/ihZY3gw6C1peVEh?=
 =?us-ascii?Q?x7GoYo/jll3reXULgeAAeZtDGdS2wb6nJ6TxXW68b7awXhrIbaRcnh8k5I3S?=
 =?us-ascii?Q?3/JPSXRrPRnw49OY+1kD4jk8gUHddDtfttw2iCbHnS5rvkEC9/u0VzOkdANW?=
 =?us-ascii?Q?RhkznpbBLTqRVy98L8jylGgFbwJqyXCFlhFeFHiT/Vue7SVFARxiusVfo72F?=
 =?us-ascii?Q?Byqgbss/oeFd0Aj2X1qBSJ3aGtkJdNiN2vOS0jmo2RzNkZV7VcK60MTLdeSr?=
 =?us-ascii?Q?hAU3eWRD697VN5CMoMDCh0D+dxtjWS8smSbbhdlnwiDi6xUciMX+obc457dd?=
 =?us-ascii?Q?q3BVzBVpHkOpI2YxR7WXG3fUJflM7M4KTe5MKbceKnFLMBjivGvqseMh8f4Q?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5uDq1Wthr3LGfLlJ6/lLDjX1WGxovU1v6LZbcwOGXtRBBFgiJ56Wn5KcBNypuX/wZ8CcGL0hTdR7KjsF4EAbTIXQ/ICuwCtfThe9IqVnJ6yjt754Dz/gEJnxNnnPB2IZAexrUQBqVvQDxIKhx1O5JMHQM4dhpKMzE48NGMCX6q5Bkt8nSmczPxhwvZAY5X3NgpzvuVWxQUOO/kU1V711Kzyo3TDoeSa0yXxgN6DMpPr9jD24cZTzT1bPS7MoyBxmYcfShfZcexKAdNZqbgClEp6tdcuuMvbNtK5avSsJQ5rP6AVMrFQTZ7pQNcjUU+QUCz2+kMi8jjj72x+etEEE8F1Kohdb0p68ry4SVNvAES05jS7HQz7hUeZBO9v5yX2dqz0uSJeiEdGvUxell3gsimhqkSmSMAe8p4utqFo4m5bltx7w8GLCATNMoT9UOMpc2aXh30EA07V7T4wBkN492NT8v4s0LXdB1CpxP+MhugW7wtb97a1KdOeFgPRtCUomZwl0/LZUd0I3akdRp9oJQcuIEf55eDh0sTi0xlK7KNZm3qDYvDWeazPPUdv4RVw4jj54wQ7g9cwAbZLhZaCwS3umpUIrGsbhfSJ7V8zqTtaID2MqZzau/qCB3kkIZquUmVLzf46aykVMzp97REKcPRc5x30ZoJy0hhvK5L7zU+cB+Yx8wYHrE4gOg0F45NmEtoUmLZTV//z5ft02O0LhT81rVz+nYz3gxZkEqHzA2m42o+edaGBwWdxIQ2d1as5gIqlbqBnkq6LgatcrXVAqdPX20yvBMVaCSSsZUSLo+oU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40987638-0e5b-4f30-eb07-08db89cf5dae
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:46:32.8695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iaqzlmZ2SXVRwVg5zyQHWLAmsxVRQNr9WrbDl9GrwpRnds5BTLkMsECxXg8T1xf5sfKdFUygnM5w+s0PmsNxzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307210087
X-Proofpoint-GUID: 6wyYr1LqP35YiLgMnMEsG9quG6EzBZuV
X-Proofpoint-ORIG-GUID: 6wyYr1LqP35YiLgMnMEsG9quG6EzBZuV
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
index aa30483b..a138453f 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -40,6 +40,30 @@ static const cmdinfo_t	metadump_cmd =
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
@@ -54,6 +78,7 @@ static struct metadump {
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
 	FILE			*outf;
+	struct metadump_ops	*mdops;
 	/* header + index + buffers */
 	struct xfs_metablock	*metablock;
 	__be64			*block_index;
-- 
2.39.1

