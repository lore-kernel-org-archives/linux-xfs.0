Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A27C74A5B
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 04:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjCNEVY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 00:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCNEVX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 00:21:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D651060416
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 21:21:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32E3UXe7003295
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=eB9cnhhN363tAwxBa9fS7hPvQVwZr9a3BzblLfrptB8=;
 b=HWRgWgx73Phxt+i9BD5sBfdXszfb3oXpwwtJnUzKhxqC+9aOS5ScISCR56+tE5YSbVPm
 9BQpEhx4Un25uqvINFF9Tm6iBOfuj3H4supCVyoYf0QkbVPN47uaapdvEwGyvQ4tEmze
 /BPfKsrRpT91zLaWt/KhRIs8/oYksBxYh1/E5IHIEJdzlhwWnrwEdgSas3+GBiA2YIy0
 71+g7Xw1xkHU3Dgv+rih7+p/QVtda2NdnLl6jxfZXZ9FG1Ls/fUZVSXBPF93LadCA9g9
 aIoXecG0B97STHEWbngnxn8b2ow0++mowEVjtcAE64ywhvzqL39x2NI+YL02pdKpKPrQ cw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8g2dna8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32E43iIL008039
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g35hs49-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+peGyrfngaMfKsXVxZqioSNohufXiXToUv/oHHqZq6Z0Q9oU95ulC/BEXGAetlZBU4VFhbAsUPUP0KWDT9ixZZgXIvCwCPixlYqfd7ZnXLpGcqt5+rjcaclqHGgDMoGfE//KNiDUK2Aw+7O86fI0/SJKgTCGGMDZBJ84b2Ly4boHuhXUCY1h0uyLPRt3Ka6bSlNMFzODZDrbZJb1QklTYlsFFTI20Aj/ZCc6GkW3JSwzq716qeBe7b/oktnPDlhWvwZNK2q8jqL8iw8UvYdYba7aYHXqR9Ix7RJ4QIAT1dnwzlMhRaAd52IlO4egaLq5Qm4XBFDQdSIWQUHpgyp+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eB9cnhhN363tAwxBa9fS7hPvQVwZr9a3BzblLfrptB8=;
 b=jCfdZyC6oZC1eTvQZ/RMg821EuiJNSvsQfsIwi2QVBu0EJOSMbY6CzNllmHr35/zVusMFmqYxmWIMYmQpl8zZRco8RftAnsvOe9g7ybrbgiWVVsFpNToLja5HNt/UspUZG0G8W8pRGDXIsUFKop+f5L8mR1Ylr0Z5J5a2gQwh93LD2bGzOgVFm5EC2STPx9kc8OmDmOD0dEGRkmwTyAVEpHfHexT6EQSRX6hjqTVaYN7nw79y9Zk7Rc9WelE+469G5p3Lh/dYLL5FlWApsNjz4cqylwO7WnaFLQrpd/q/oqUoonhjzPBZPiUqH2SCCHRxmkR16fWCbbIIb78McFNFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eB9cnhhN363tAwxBa9fS7hPvQVwZr9a3BzblLfrptB8=;
 b=mzXdEqYoPovmXOlcd7404T0T+gvLNSPxyGnpcHlk836Cr/ta5vWUzcOlobF0oakl5u1qK5Lzib/ZJ9G7h7iygZ07t9xaPmglKS6D4oD+8oJVkyY9XPJ+/oe2S1HMdUUfb59t4hPJVBrxO+tau65uzeJ+Ueai+XrUUPq7jEBL0MI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4371.namprd10.prod.outlook.com (2603:10b6:a03:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 04:21:18 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c%4]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 04:21:18 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 1/4] xfs: refactor xfs_uuid_mount and xfs_uuid_unmount
Date:   Mon, 13 Mar 2023 21:21:06 -0700
Message-Id: <20230314042109.82161-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20230314042109.82161-1-catherine.hoang@oracle.com>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0174.namprd03.prod.outlook.com
 (2603:10b6:a03:338::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4371:EE_
X-MS-Office365-Filtering-Correlation-Id: db15cc83-54d5-42fc-d87a-08db24438ee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vQ9/OBQnInS8L8ZQLp3FxnTMt+P1wwCWXseM5WWPBD7mztJxL+eYm0j9JNDxRFTwS7q5yRbIQ6G+FN4BKTiPV89jXvZZzM4DAmTnbLSE3pkw268NlVFIEfcVOoVYMz5u+CJd/Z0mf9NV/x0z/3mOhWCUlsJUu68ouPdcOwTy4DSHHR5s5GCVZcPLVAS5DGGdfI09DC7IwUhRvk7CUHHNYcpJN7TdQE2MPNBzxL2tf5tAZkhULGG8Min5EjgcGJO+7+xLrRbs6Gx6cFXUr+lUPX3QETBZ0/AmGLAEqIixRbEu5SDfoFIZIOiSp302V/NYjDUE/CilojxZjVvdnqfg96S6SL1qS2bUJr81X/6enUmqJ16lA4uzRWknOG20D56sWzisYR91r3A8b6rqYhXIhoST8Zzxu0XipdPTv3WQU81jkQKpPvLQ1m5ouSgId4uFIvdoL0Dg4ZrFzreYrdWyB2MQlOAzhC29CXfvVUuF+2sNvgm1enJjiAJjhLyGcIrnTvqruC5zNc2pUisFgdQgnMc99tzCiFiq1cSTXDIbaq8SExZUb5LbUjb14KU6Fk1Y7eQmSbDhcU9k0XO4mHUFIbjtdejzmuDBLDvRH9KYgS62tPz2np4eT+FatFp5n0KS655Zf9kvbfYfD16kukuCeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(36756003)(86362001)(6916009)(41300700001)(6512007)(6506007)(1076003)(186003)(5660300002)(2616005)(8936002)(316002)(478600001)(6486002)(8676002)(66556008)(66476007)(66946007)(38100700002)(6666004)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dvsudZ8NQayJBVztgre+yRuTZT85m3KF53tDjt7yfGRFWh5mm+5veRuL5/Mc?=
 =?us-ascii?Q?RuLbfNEgHxL4aEEiTqyUPFgAFAI7wqlsaBWiDGT3THu4q1M5405/AXQx8K+g?=
 =?us-ascii?Q?EVZq/IYe/nIIvZRfLwGd9RJ0gmxXicSqC0uD0Omw9TO5JDbiqVElISg4xu/v?=
 =?us-ascii?Q?9i1ioDh2OOMRZ4ao9IyItpHKpGj6BASBUjOQXrLuWFY7wvr1OKAYgQjqcq5H?=
 =?us-ascii?Q?EN1l1bUDpgN1AUQ+kWWCEnn2H4kByfVn7hNwAkbsTxxZQQxCh/X3n9y6tMPN?=
 =?us-ascii?Q?efcCA4T+PHYE0toOXn0WyfN+52iIp3fII+fDwUz+QS7Qsh9NKfjxONecHx4Z?=
 =?us-ascii?Q?geNyhLLl9CmBOri0QClRqBiR9rIA7rEF++o+j4xoqaJ5G5OKTtGtkXNCzur2?=
 =?us-ascii?Q?3qozR4eAk59La7rRhaLPduzG1xg2jKn/eqtKDcTUZYzlJSqc2kG/emWFKvH2?=
 =?us-ascii?Q?TsfwZCEymi9ytechjMEPqr1VrZedlHWyo428W7NF6b1kQECR4GiYDS/VS355?=
 =?us-ascii?Q?2ZHbgvRKHsUtiiZpt+2/7/CQoMOpS0IdNCiDpeXEpJtXqH0KuhTx5MwWlct5?=
 =?us-ascii?Q?80t67EYEO+W1TtWkPsw5VEJLKocj1XN5DsO+D00pxdrL6WNg7stcBollEaLk?=
 =?us-ascii?Q?iVjqV6tVu3vuCgBgZpU5hLplB/Fk7Aj/TRi1KjyJnuPFIF1dUpS1NZucNiWZ?=
 =?us-ascii?Q?YDw1gP9OhpLC9jRxuzpSx6h/kn0UKcSU8EMcPNXTMCOs8cpc3ypfHnAVDcrm?=
 =?us-ascii?Q?5fUN9EYLW4qUdhcwIBXs9PwrNDdhLl79edKOvVu883HIonciReA415QyI6Ej?=
 =?us-ascii?Q?NkEpHVc3zKAFUzGglieGhqJrcACGBUzXwE4IiWWhcnA6g1l+9h+Dahrpokya?=
 =?us-ascii?Q?1+ait7ktDrOvTlf1ahuylkgW0yWYV/21qRsdPYkAJHeew5OzxXv6oq6DF7wi?=
 =?us-ascii?Q?+D3pwK0VzDLndewYA/kKHaOPA4lCyRLpbPJsjtODQ0cdGySQHQEeXLNyPuhP?=
 =?us-ascii?Q?fGzFwa7jxHhKETAImgsQiz8A3r6jSfMqeHlEwrOa94k8Y5n19bI5n7t2PDag?=
 =?us-ascii?Q?sXyicKaxxdSmBSNKB2PCkdz9zSk+kLpCE6+hjgWpREAM+AmOTnrggluVSO4s?=
 =?us-ascii?Q?N2BIzwGolSGiduXXNwfK9Ge69p2YhYmo42YOehLQFq32co2X3X14Dy5VXGK/?=
 =?us-ascii?Q?3Cz1k4ZnSlsYx7hUxPL75iT/zDj8dV892g4uR7ol4nMpBj9oh8tbUxpGzV0G?=
 =?us-ascii?Q?4aRFbX9c+QwTaEKGiUxiADSiQgXt8CI0WFBUe/pY139vEFkqtfGautGWdaHM?=
 =?us-ascii?Q?DhVauMLr6/igpSEehe+7fA55VB/Qu+mOxiqFFsFHd0r7aaoavdZBW2pSFMMB?=
 =?us-ascii?Q?jKhZ+BjmJHU2/u8c8RR7HqqDiD6h/6Ukym1PvZoCywkJOEAdA0LYmSVR6vbm?=
 =?us-ascii?Q?O7XPRZAPPqppPEbbrS6n/p1Eu/ux004Iz+Kf3SmCPu8pscIsmRkwLPKnTmBX?=
 =?us-ascii?Q?YfXtxy0NJit8CYkg/8jWdegV+BzkU/znw0OptOjlywOCZepDsN3ea3C3xQQA?=
 =?us-ascii?Q?Qee/VBlDz0h0J417lustwQcKnCt2S+AfkyzmciPOQ00J1+2SKCkXHTvQrG4s?=
 =?us-ascii?Q?BHXsD71xJ1hItOuRCzeaP7J6nA/JNbHNUSZZ+ZZquXD7q4JV8Ku/fJUJN4cw?=
 =?us-ascii?Q?ZcPuyg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 84CMrKgU+6FVRka1aAiBZro4qFLFdRdrD8fL1E0QZqBS3fbckwoA78Ut5aflBqGI9LOkz564PV1FKMACuB5RbJUZnCVt+qVAHonLcXkXbK0zBidcmiW/WIKvGIq8uvMUCSLQOgzqlEBlv7CkbsKKM/2yVJlxnSpolBfVaZ3ej5LfeakEgBWIvAXAtlkZ3it5TTH9C7IYx62Gt8IAOjg4pcipO2CNLgDSK1WMtkw7jX9rlRHd+LmSP7fwViP3dj+Iz98KVj3pio/6HGgQJ50Nz4KFRLOu3L1BTHlK8m2K4UTcH+1IN7snooEDHUz4Ae9Y2QjvL2yLwjKKvM0xJIhPR2JprgVi3naXSLZA9nBEg2iy5PxR6qKF0hCy+opEGAJfK1UsWET3/Z0ed/YudALDlarJzTq1Q3Wcgsm9rp3QS70CVV9PPAuj6Lr1eE/MDXPoC5+U/e3bsGAqYVMiu2T9cViMf3Y80Cf4oiFIxp0TGp029VxAE/F9D7XXQ3EsbCMzjNPDi89+MHGXa/m8JHwXSEyErvSlrjXYi9KXv0YQ5fGoJkDbawZ1RRGBkY/mkvC+oN1OSY8LN+n64vyYA7933T7oF/h001+F1AbOd2OrIVy3gZGysJvmCebCbi0Dxv8fChDftu6y8zxIJL9NWrWb+Y8KoH+CzuJewUrCQGnXGI3HI+W0woL88OkKAN7kIoZoCRP8O/j6QZg4Q/Z6kSwsXTiPAutFwrvHWdxLhBsUZzKQjTS5acKKI913CMvZuwOByKGpyB7o5lEgCfS/W4m9iA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db15cc83-54d5-42fc-d87a-08db24438ee0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 04:21:18.3753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8YkCjbaCciSTz1H/B0vmNMoSKT4BVazk8Oi34yNOJRsn3tGvq8Vneea7GuD2MFtFOYsuSaAuOqprCog2c83eKNBnYGwcFA8q0gk6X1v5Gew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_13,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140037
X-Proofpoint-GUID: 13Bk5PhKbzW2Y21_Dxfw8eK38_H8o0vA
X-Proofpoint-ORIG-GUID: 13Bk5PhKbzW2Y21_Dxfw8eK38_H8o0vA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Separate out the code that adds and removes a uuid from the uuid table. The
next patch uses these helpers to set the uuid of a mounted filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_mount.c | 30 +++++++++++++++++++++++++-----
 fs/xfs/xfs_mount.h |  2 ++
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fb87ffb48f7f..434a67235fc9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -58,7 +58,7 @@ xfs_uuid_mount(
 	struct xfs_mount	*mp)
 {
 	uuid_t			*uuid = &mp->m_sb.sb_uuid;
-	int			hole, i;
+	int			error;
 
 	/* Publish UUID in struct super_block */
 	uuid_copy(&mp->m_super->s_uuid, uuid);
@@ -71,6 +71,21 @@ xfs_uuid_mount(
 		return -EINVAL;
 	}
 
+	error = xfs_uuid_remember(uuid);
+	if (error) {
+		xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
+		return error;
+	}
+
+	return 0;
+}
+
+int
+xfs_uuid_remember(
+	const uuid_t		*uuid)
+{
+	int			hole, i;
+
 	mutex_lock(&xfs_uuid_table_mutex);
 	for (i = 0, hole = -1; i < xfs_uuid_table_size; i++) {
 		if (uuid_is_null(&xfs_uuid_table[i])) {
@@ -94,7 +109,6 @@ xfs_uuid_mount(
 
  out_duplicate:
 	mutex_unlock(&xfs_uuid_table_mutex);
-	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
 	return -EINVAL;
 }
 
@@ -102,12 +116,18 @@ STATIC void
 xfs_uuid_unmount(
 	struct xfs_mount	*mp)
 {
-	uuid_t			*uuid = &mp->m_sb.sb_uuid;
-	int			i;
-
 	if (xfs_has_nouuid(mp))
 		return;
 
+	xfs_uuid_forget(&mp->m_sb.sb_uuid);
+}
+
+void
+xfs_uuid_forget(
+	const uuid_t		*uuid)
+{
+	int			i;
+
 	mutex_lock(&xfs_uuid_table_mutex);
 	for (i = 0; i < xfs_uuid_table_size; i++) {
 		if (uuid_is_null(&xfs_uuid_table[i]))
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f3269c0626f0..ee08aeaf5430 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -484,6 +484,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 int xfs_buf_hash_init(struct xfs_perag *pag);
 void xfs_buf_hash_destroy(struct xfs_perag *pag);
 
+int xfs_uuid_remember(const uuid_t *uuid);
+void xfs_uuid_forget(const uuid_t *uuid);
 extern void	xfs_uuid_table_free(void);
 extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);
-- 
2.34.1

