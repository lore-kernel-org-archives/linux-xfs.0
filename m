Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4433C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjBIICd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBIICc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39ACF2D17B
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:31 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PjUb011362
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=hjKom0jYenTDKGaVxb9xSuclU1m1nWbc8z4FAPcPXj0=;
 b=rlrYEw3Ko+RrpOw0mrwZqCgOSdJ5BJ9qkWHlZlScQTH0IDKse6dputCcVDAXtdC99tJY
 fbzqiskL1+G0FOo5jGtsS64NRWwuub5GkHuCPWXhRZQn0Qlt3Pp2zoEswcP6t5NWP0+E
 HZf2bNckwZHUtw6BvkML2NA/xVZOfEL1aOwY8DaVVOytskr4++nL5q3M6wTvXCojFCnc
 Zs/0K9zLEPuAIwxHE4sUXVud4N5rwhnp7YRkmQ/IWff3MbSszW7B3SDc6kgxZZ0eeOUt
 EoJLWeZNGUNqwNY366KMs1d3Lb3KEbQzlP+X/fY2N9ngy5Cd1RUDWYFNVSKt/+/6eYFi Qg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1a76n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196KLvj021320
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dvja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgnTdPDA74Cnx64RwTPjCRXe0cfCJ429oZW8nBvJpjBK5Jq5qTFNg5Q5TZ8o5zAW2UqO+lVg9dpeLgJ/4mhJ0hJ4rpR5P8C74d4Fhy0tDUbPpBAmOKIjS9bMbmQcU4H0d4C7zJDdlYwD3Nx3Y8ktYKrIQfZC233Y6owlls3V5EepAOjr+oVZXMfSAdjCGQpae1g+1UdeuHJY5S55eG0M7cFTQybw0t8dpHlWGmRV6cF6dDvcz9gFFT1ROErQKiXjXbhiYwcn/402FVUDO0I1lhDyYQ4Y/UjRlyQgsg8Q7LkvWzJ6C+1IJpjVQCfqZlSuo+eaHmWNnN7c7f+eiEwtOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjKom0jYenTDKGaVxb9xSuclU1m1nWbc8z4FAPcPXj0=;
 b=Sda5E8+2hp3+Jn7szCgJqBKhvKMfaIPnfpKeGBs57+A6wWwA9nHJZeWzB+1JN+X0mvSvxtaW/mN+kwSUUtTkIlcXVp4DGeq4HXba24iWZRMflq9xx42zRpd0C7ldc4prLPbH12jTMJdpfuTz4OPFFmX37G+JEOMTHe6IWuS/xa6VptGuyz7Q+A6popKMFGmRzaevw9ojPd1WY6NfaxaW3BrFyrXJVcDDIvNvRb/J/UzexBPbbs+Qu+WsA72PM4yZbKrT8pcXy3m8WNLjskh4cb0RKPhlHTpjjsv1QnDIFKE09DeOVnFN+h1TXEpYj4G2avjR05bkpHcfKlkFxVXYvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjKom0jYenTDKGaVxb9xSuclU1m1nWbc8z4FAPcPXj0=;
 b=GnjmhZtm16e5m0TSfyKSZ37tdBeqJAM+ex35X1DwAsfS84hiuxbvZG15Dvb7sSTeVgZpwtUUMLXm3isULyVhW7q7NPvONofLuMhEH+GyT3lqTgkQKfL+lfrXaGGCTnQs+Ty9utoupESs/iYo9itI2x5FTiXEVIIyBC1WNy0GN7g=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:22 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 18/28] xfs: remove parent pointers in unlink
Date:   Thu,  9 Feb 2023 01:01:36 -0700
Message-Id: <20230209080146.378973-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0199.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 3966acc0-873f-4f81-1e58-08db0a73f983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vb11JETZRDaaKIvVzwYPZYkD86fEdtLQQYLh2RpbRPUZT2WoSyLtG1z17WZnFyQ+sDO16/ZsopFTUPChoJ0P16xjx+Qdpkw4ECoCsN8oMUXynVKiRKR+TZSXvboeZEWlCr+RlItv+d7jIQmLQQU805PsZuAVKQwbSUPVN4lItfcddlm56ttnr20OfIcApuX1mP8Jk0FE6djIW4lve+LVvXlrc7mRr8bmJ0KSTK9SbiJYdllK6ZwVlXp70c6jsGoGiH2a8A7yAnbWelvf5i4MeHQdSXDau8ODdA91OWCI5hpwJ/8K9q8M6ccvuCuxE76JRInm0fRfbqfqaUhlPqKydwTGI7dlY5sddVMWYmIoyAuCprIdJpJW6vSwAbKwx4OFQNyg7xnYfgLY4x6fWsx2aevfRAdJdwUvabqAyy6X66eDOtLlgpSB82yLZH7F5/0ouKyeuK1ms3AS1luGFbYswptYgq6b0VJaSPYeuUjhUU2HKj7ITDC/GNlDwidYLQ24sblJkN1npD/eHnXcbKBviwcLtyQM10IfNPpXMfALRHv3InU1wqXm/e6RdfeVrjjn/2COj74byazLtnXeAyFU6TaprLk0BsUU0B5/aCBTDXPZ8N+7Y86bEymahxx+izo1oL0KbTIKSEviqoQ5zQALwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xeLkZnMzmA7IHrlXmovB5fNXDtIPdtfW/LFX2hxS6SqGpg3FCYfl73khgJ20?=
 =?us-ascii?Q?RESu5ToBSjFq0zmiRbc76Nu0y0Np9jgicMxJU0xDjZsEWg4HmqW3xljxvxlv?=
 =?us-ascii?Q?HeTfSCwCpi5jwbcqzJozLrI9ZFoJiOdtB5OGt/YPUibR74bpOuQqQMCR9kja?=
 =?us-ascii?Q?Dkivp5KXi1JgOE2N6uCHGOaLI7wqUU54yAT5ff3pl3uTFY0RaqVjwEY+oORs?=
 =?us-ascii?Q?CIwGAaAXExQXTm617THVRxeUGoGhYD9vverS3XUcaUVfrY/hV2QNqNa7JMdG?=
 =?us-ascii?Q?sfFmYlHT3cV+0lqrEIz9ilTtyaW8GLIUkkIkhsVuEdVmohuxH+7bn31KD804?=
 =?us-ascii?Q?qscH0Rg7o8kWLd7boTsx1ZJzCD18jbeHdGQ/MsK9Lk7w1kZGPqchFAcpgsxp?=
 =?us-ascii?Q?UbLDITitCzaa0omyUJwMqwmueMeZhRiEiVI0xb8UEmn60fIYadQ565X48IIk?=
 =?us-ascii?Q?e/66FKlRxlvrpnwWLZfxsiBx8SskJFzpdYoFiMQJsfpbs72uUZmgU6Yu2BwZ?=
 =?us-ascii?Q?wPNPKwVuZSMtWYGFX0wXvN7I/4mieyWMXy1Te7oy+WV1dwYiYsaRWQewnM2A?=
 =?us-ascii?Q?wopxLTxjyZCQ8lJwgYkY+jW7g9ajuyZor03qJpV55KLSa80Gnq7SOlAnTTSs?=
 =?us-ascii?Q?xZDAXo17D7AYbFb8dfqZJ09nqsnmXUSQuAooV2nVBCUKVEnfwChsbfLzPw6r?=
 =?us-ascii?Q?A9zUIrdHaHw80X/GGKPYm3YKy9ixYo+1HyK+DQYZuklQkcyurnTeaKzR5cHj?=
 =?us-ascii?Q?f/gJrvQNJAKAaYfrfuybRGbKOKK6kdrNLmB2iJ8Zux2eHlcOcTnDD58ncfAS?=
 =?us-ascii?Q?V/OBGAdvMUkdmuok3uJKwRtxi0QbvduGi9nEzq73nSpeTeYFB0aDsX5FTAy7?=
 =?us-ascii?Q?D2DT4Qrn7ZOb38u58Hf90VC2YaFltsOF1dUbOUMyeeXYYiO+jmgUNzayo7QI?=
 =?us-ascii?Q?lHL/24LTUsZAgBKx6FzDUfzj95UBIYygS1RB/yt9Qa99t9QK8P0VoaGpbfpv?=
 =?us-ascii?Q?7qFmkSqEu9GE0pk+XvXyAjT6ne3pcRiEgAd+14JXhbwSiLUjlK1rtZurZxhW?=
 =?us-ascii?Q?h3XzOBSWO9MIdFz4qXZyT04+S3msnLrr9oviHd4CJwC+RF3fGwRg9J/7jVJc?=
 =?us-ascii?Q?JX+eAjbhmwwoybAsifUhdV5uMhoaqZRFYV+QDilooKVU8Grrqk11NzCS0g4B?=
 =?us-ascii?Q?B7Ne/LPtf6YzjPDCiXQKBnW9mOzrBT9/De0vsqSlFx8j8VbV0LbEEiAvzZ3F?=
 =?us-ascii?Q?8p/vYNNerbhpWXDAYM7sriXiZakF4DlXityuTsBZddOJWa6lFh4sgd+8Evwk?=
 =?us-ascii?Q?/nTVEWKN9W5o18UjyCTXCw3/2vvih+aTYlLVvAFY5xX081Nm0JAc4WvNocZB?=
 =?us-ascii?Q?M7QP6VLFDPXFbu6Tqp5h2bxPloR69rEHU8KFXn8Rroi5yZAiB5WXzIhW1iEL?=
 =?us-ascii?Q?k6CBQn4pHuvtlxQwHdqW39LRBuCoxrzoRtvRaV6sQlGkWKg3nSEqotwqwrBX?=
 =?us-ascii?Q?ARmdH3H7zIXXfsW7ijXbuOj/s2HAAV3oBsAxuFj3oHytmHEV3IbQQ2VeXoAa?=
 =?us-ascii?Q?TH1N/NXWJwFEOfF8ImPJUkZT7IdiigI9ZkLUHBA1AAaQhYNMK+YHvCGoW4d8?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JuRHis20SKVnncgrd4tnqobzntW7OMsdDe9OmqVyMvs6QuBxg6Huyo/+JxXZxu80DbrdcIoNTymQNCII5yZOrqJYORAP4XN/3loirqZ8CHvCyU2PJC0NFAkSMh+260FsDbX1Ab1XWk2MWSo0ed4Y8ZrEyF0Hod8UnL9DxAiZ9/bdnSP+LgmSTCG0MA7yEmZz+wv9Fbrfuop9S4zUVipcClJPnMs/WgVeD2MlsmYPkNmXiSc8OMfzonI0RihGOb5O7Wbdu38ojS4bGP2riXCKiB8GEv4nM8oBs0k4JQtMyKZqaZ7e4CKillN4HxVe+b9jQv7J66lS6zyDbbCS6EK/XiEETYx/KVUMG2aIUY8fKsLd0QwM9L+UzkC+cteY14wt/wIaAjq9lNKpkcbVLwaW6Mrt2WNehaAVkMdw064fcRdSz8LfV4SyI5PpNMSWe8slrUn+dIic+XPa9gHMa9Q4561wk6GtJJ9VJ4ZLwBjgrsTgSWI+I9A6MbpBAGO/1SDCRas1KnjoLZ1czUXVmC4GOZUHVzXL640sKXGhssTPJSiwhsdXFeo8f61vFCaoJXDl2cgvoEp5SrWkkxga14QqENmXICtdm0X4XQqPlFfc2sPmDtMIbZ/oGwy9h0OG5MpcW2KDMiNaXyGDBw1gcl4s9MzaO8MZm2w1Hbh6/kOVqmOsh5ZUedyrFzf2mS9g4dOhTX5NS/+l+KEVXBVYXdK5AZ+r6PhrKalM4dLXIrybr7G/3ENs3vltwg7s+3Pxy+zL
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3966acc0-873f-4f81-1e58-08db0a73f983
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:22.8580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VaYtuIGdZwok6QBDSeXQjolLiaAw82j0dqlDqRzlWGS1UtfaYs8sXs3ZrmKGt12v5lTk/NgP43ph9hFx7aTaDD3C7bQTU+UWeXKeemlM3N4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: 3UP4inmGMPHlqWE8-XK3qR5CxVzlpCX1
X-Proofpoint-ORIG-GUID: 3UP4inmGMPHlqWE8-XK3qR5CxVzlpCX1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        |  2 +-
 fs/xfs/libxfs/xfs_attr.h        |  1 +
 fs/xfs/libxfs/xfs_parent.c      | 17 +++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  5 ++++
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_inode.c              | 42 +++++++++++++++++++++++++++------
 6 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f68d41f0f998..a8db44728b11 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -946,7 +946,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0cf23f5117ad..033005542b9e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -545,6 +545,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
+int xfs_attr_defer_remove(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 6b6d415319e6..245855a5f969 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -115,6 +115,23 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+int
+xfs_parent_defer_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->trans = tp;
+	args->dp = child;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_remove(args);
+}
+
 void
 __xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index d5a8c8e52cb5..0f39d033d84e 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -40,6 +40,11 @@ xfs_parent_start(
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+			    struct xfs_parent_defer *parent,
+			    xfs_dir2_dataptr_t diroffset,
+			    struct xfs_inode *child);
+
 void __xfs_parent_cancel(struct xfs_mount *mp, struct xfs_parent_defer *parent);
 
 static inline void
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 25a55650baf4..b5ab6701e7fb 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_REMOVE_SPACE_RES(mp)	\
-	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b4318df03b5c..7b34ca2de569 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2477,6 +2477,19 @@ xfs_iunpin_wait(
 		__xfs_iunpin_wait(ip);
 }
 
+static unsigned int
+xfs_remove_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret = XFS_DIRREMOVE_SPACE_RES(mp);
+
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 /*
  * Removing an inode from the namespace involves removing the directory entry
  * and dropping the link count on the inode. Removing the directory entry can
@@ -2506,16 +2519,18 @@ xfs_iunpin_wait(
  */
 int
 xfs_remove(
-	xfs_inode_t             *dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
-	xfs_inode_t		*ip)
+	struct xfs_inode	*ip)
 {
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t             *tp = NULL;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans	*tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
+	xfs_dir2_dataptr_t	dir_offset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_remove(dp, name);
 
@@ -2530,6 +2545,10 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto std_return;
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2541,12 +2560,12 @@ xfs_remove(
 	 * the directory code can handle a reservationless update and we don't
 	 * want to prevent a user from trying to free space by deleting things.
 	 */
-	resblks = XFS_REMOVE_SPACE_RES(mp);
+	resblks = xfs_remove_space_res(mp, name->len);
 	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
 			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto std_return;
+		goto out_parent;
 	}
 
 	/*
@@ -2600,12 +2619,18 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
 	}
 
+	if (parent) {
+		error = xfs_parent_defer_remove(tp, dp, parent, dir_offset, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2623,6 +2648,7 @@ xfs_remove(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return 0;
 
  out_trans_cancel:
@@ -2630,6 +2656,8 @@ xfs_remove(
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ out_parent:
+	xfs_parent_finish(mp, parent);
  std_return:
 	return error;
 }
-- 
2.25.1

