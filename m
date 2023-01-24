Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C777FC54E94
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjAXBgb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjAXBga (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C8011EBD
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:29 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O05r8Z022928
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=qdiEHyayKAdzwKU4Ep0EWO9IW8uubsDd3Ow/JcYLTlatUOpilxqZrbi9LQK8AbBn2Nb0
 aYP0wVIrXxVybnZmbN2ramS8vrjqHlEDPWv4/eXzoPWZ58vEtfLJ6LZ1Dvqpo1AX37Ws
 +Stk7Rt+r2KVCXxiSvn6vdqT6FpiD7d1fOEk+qfZEchqafXtefzSYHi/JYLOL5wdgJR4
 Muf3i8p7dlWlOZ+AkvQ4QRXFcijNuQZQ0ukfvweyrLE3YWhbHiLIYSk66thNSiMdvA/4
 Ka2L5teXKIDDNwavHLMUJmRNADBFIBOT1Wh+oQJZYdVEhub0DzLuuKl+mwuznF2eVRxs 5w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa4a12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O1M9Jr039626
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gb4ase-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTOtIOYrLMF6nNBI8sSYbFPlhorjUQEPZnV+UAEeNylhGCUW9LD4hnO3uXiy4aXZHBWLC06x/Sym0ndKt9+Ml+RXnERVOyoWUoDWqXqvxtjCjLCdp83Gvb9GfmDhbenOYHbbz0ljeJErQX+NqX0oxDl6N0kr3V4wWqrEu+1TWhU+T25Asq7o1ZRcpN8BAk95HeQ1+/xNKtKSGCQC7lt3xabTsv+7RO0aMLhF5LYs91pBMGhNA0tY7azA8pe3agE3bPcXAfD7wc4PwUISwfHL2QpJBCtDkE3ZTT6qDMGNxqlg0drYjOAT7sItKZz6A3ArJSKhkHQVycqlWlGZPA42wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=XUqg9sj8hc+LTr8nPrGOyt6xTXpnEuVr72e+7a3x39EDVDZr8J2DbgaRk/+7zPyb7xTs/ZlZUrRPxyc25dknaA2C3nW4Ug/NL193ObHZYh4zCgb+4iYD7SkjyfbnmFmyFrFC8xpEJGW1Bl58qBn2I8PwvDUHMxUKDV8fySHzksavlMMrbMIH1nIC9e/WGgoYPJZFqFGq991JLtBLdGQyHTIV5JOBeNTesn3J7uDo4VYqZkWG9FGcYYA12U/1yVdSR1oJyARDmJ2IVNGL0YU9krUfUqwJUsNfpUJyUtUKPU42AqI9J7i48GQQBY5hlY6rHcp/tB6MEUVuf0s1JkdcLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=IoNRg3zwOmtgMmJ6nZhBBOv85+SNH/NNX2od2U5CljWM8RPbL55G7rMgAyOlPEE5bJ7/qR+fQwCCi8lwRgfR76UPY6EUR0rM4rJUePwSodim+MVs54RZ/i8CpNkop3s7EnRboRB86GI9CWnx/VKIGxmnpPinP3oPrXUx1ynja3A=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH0PR10MB5052.namprd10.prod.outlook.com (2603:10b6:610:de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.16; Tue, 24 Jan
 2023 01:36:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:25 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 02/27] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Mon, 23 Jan 2023 18:35:55 -0700
Message-Id: <20230124013620.1089319-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0082.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CH0PR10MB5052:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ba92335-dc03-4b5c-222f-08dafdab67db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZQP4o6tMEY6ixrmFwxOJ8k1WHOv6mL8YkTk/wxk7QKNanf0I7rKi2et91Y1FfyZ8BHNlJKHUysuit1UDfVglZr8oIKnox9aADbdT3tw1tA+PTe7viKFIt8Ls/h5WewU0cg/AmUS4jG1XEpXTi61nK2j8bnPDi/PyPuqWBtIcBrFxvFOQ+QEywyu26xTjFJ6pe0rvJ52PClUnuBENoD7L23moDBV3rfmbRwTa2J1drVRxkha2IFhVn9aMIv9kreh2NVue92cKeE3sgV1aH1RS/mYLAZBe4PMYmdJt9Qc5crJFNHfPXjr/Di/H1e+8gxVn12/9eLbcRqfiR5c1W1T7H5wnWySiEgB33p9Ez49Ro/bccuonLQmXQOq72eTN0USxm9cluM/alX/xMdY6fYqs2R1pYaEFieBm1As4DxEtOoJ/54ME5OnHK1vOZ18XuoRAO7AjRlMbImkriRlMrZTZG/QarYF7kxq4msyux7PxaV+23RyKPfIyze2KJBS15InUCRgVQvtvh2t2ykv2VBbxvIFIv8uFUKr6GPEwBqFNimScZordHrgrMh3qDw/fsQllMwFrOIT3F2kIP/OK4iTmnBcEqPNgS0DAN46g1zivD6B8DGQj0S91Y83wNLUrKG3oFKLnqV8zx2HJpIve3ydqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199015)(1076003)(83380400001)(2616005)(86362001)(38100700002)(36756003)(6916009)(8676002)(66476007)(66946007)(66556008)(9686003)(5660300002)(2906002)(41300700001)(8936002)(6666004)(6486002)(478600001)(186003)(6512007)(26005)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vgE2YoCDr+D9bVGeCtNGNedJrSrEAbOlVKq5sQ4RxUsU+PEaNwANCQdMxBLA?=
 =?us-ascii?Q?vqzRfGyt3FStODN5ZsRyhOmIYO0b3eyrFYEiNGAHnxXUwPlx8RWi0rTo5huu?=
 =?us-ascii?Q?0JYF3Bi6ZmnopIxZ1Tr5WZWANqrtFRlaOzvpl4OSzcsivHpBA7wZGXGxrQsZ?=
 =?us-ascii?Q?gTLE8PLPEoRcXXcK9my4iPPTsXbmFPkzlLJR/aV5oEg6H1awfP7W5dBCy74N?=
 =?us-ascii?Q?E+CifSLULzwYVwY6dwJa/ee8GI3RG9YhPpugz5nJM+qcxBQ3TQ3Hd7jfWBOJ?=
 =?us-ascii?Q?SHMTUG4AJ37KLf3krjfA3DIr7JazDR+oJeI6yhprivP7rxgmTkkBM0RdZFO4?=
 =?us-ascii?Q?vreFpYSrcuFwakOzznMT0wqoIuE38wbw+KLuNwMonSNBgTcaMntZduXYZAOl?=
 =?us-ascii?Q?FD+5kDCE51oOdWFNxJPn131zvNJglEDW+QgHBgDxY9Ud761/AhdFOlNILStU?=
 =?us-ascii?Q?WJ5ictjhsq1j0u3brRo3R/SGACgc+OIx39kS7muXkWSiQmdBEY0WRudCwt7h?=
 =?us-ascii?Q?9UQnbFI6EUBd59pyFXa2pBimJMabBXriYRF6rK9PT1I8wVHhT8FWyIeL0QDt?=
 =?us-ascii?Q?1Gktc7TKNNV2xsuNivvq1SC6/+ZrWudnQ6fxOfqVQuA6iPGeWqwMQC7FvzVP?=
 =?us-ascii?Q?AWsX90AagQtTQ0kqFwhewnKezzP6j8QaGv1OwgxQCKHBRuZmSDUEYCalFxbj?=
 =?us-ascii?Q?lXeOJlykUr9JMD76FfgvYLg9Gbt6uxfQMUJgzqzuRKVCas63Eo4RUT9tBVjc?=
 =?us-ascii?Q?Nqdifk3tZHgFCMAID1fqvbyITRnz0quVl/jBTGiJx+P+AuLaOqHOo78HQZZT?=
 =?us-ascii?Q?JH8ADbbm6n5hP320bG3CIn/DkA4n48v9458/+A3PMw40//luTWTWY9+J7MXV?=
 =?us-ascii?Q?SljZ1taeFkO5yf/8Yp59LrxFzzPr5lK6cLvqbgIIILtk3BA/qe561ZdFV7J7?=
 =?us-ascii?Q?KX5xGQRXOtyL9U3PW+OAC4iJ8/QR/pn3JbGAKNj43eRco2ABFiVS70Vj+Qrd?=
 =?us-ascii?Q?9f17x/5hgfux9c6kqu/kwSlOs3r8SKi5eg/yTEL6F8bCdE9NF9b6wcKX82Ln?=
 =?us-ascii?Q?KXhwYi/CDVGLHafKdR+kKPE8sZBvUXsw2kSKmDnNBG4NDB3rrgloFa8hdCZT?=
 =?us-ascii?Q?tE/HEIPaAH20hB6J/CuvESUQVAhZOhlEs7f7ilWraOgYhEN2RTFBzDBiOdS6?=
 =?us-ascii?Q?TaAb497oVisF8CnUJGmWp8F4flXpQD1nWFjle9UQybFQ8OnpUHMbUF5iiBy5?=
 =?us-ascii?Q?gbzx/0fKoOiO0+DJkIwTSgVCnlcfhGeIfktfEBbSgzCv6ilm7ISUWEyEG8xg?=
 =?us-ascii?Q?yZy2uoa+3VIwI5C5L7Ru1EpXmIdtbF9R20DhW1Q0rSDsDgzuFlQD9KTeHSyE?=
 =?us-ascii?Q?bcjRvxMrAKPewAxlNbBzLoqjqHHnJAfoc+edxscajSlEOejnB0UWPSxArNUg?=
 =?us-ascii?Q?2eWJTUeWvGQTsNy+TX3QHEMUJG7s4YloefalKkVHkVLbJFxPE/z+cutOcMg/?=
 =?us-ascii?Q?gCLnQEkjldiQhMtYUNiIpuJeeqdbQ8OtXQVp9EyIgzf0gOko0rh/CLao5+2W?=
 =?us-ascii?Q?OgeKNxi/GW963pSM1lkOHrne5PsrqXQwJqNPEJVSNTaqb11L9UFuABoq+Nbb?=
 =?us-ascii?Q?8A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: je22eDZB+jYtvNZsO7QIJJlQKwDsyBZCPna1+L+8kE/XTDjFSpAeIZQl8ZWPDccXPr5S8cgNkLtWLyig0SN311IXJV4Cg3vPUHBq/oJYZ2mkhcssiI+fbX+KBZrh2KyVJSdgLw8NodK43GM48F+dYHEb0MZLFrsXNGpIXyqdsv1evFD8MZNHosLJlJgx3TXhbHDsGBHoEPb3mxF3BVRrBQ5g3SOw8dAc6bdkurRYgZK1GtYiBc8EL2fvcjSAr2mxQBgk3s79hDVME5gLQED7noipjz7ty4mpnnwiNChdiBJZ2NRDR6GImEmE+DgS+s821zT90kCg5/MVjvrTxpbLGVRDeTuAN6Vp8wVY01OP3lMzG2JZKyrM1dPJbnTIHkFZTPfXcAN7L08gHau6cRU5vUs6O1gCtR/RAyesHzVbnoxvPX8Lf4n56MCdmIflNZHfK0P33TDziuoq/uHYk2eYhkI4UGCf0Mz1whbBbJ8qjUIrSHmg7Lbadnwm+M08wuv60q+aVT5eXhPEU9Xue9OM9I6M9qgr2gVpLwCmNJGy3mRs8TPmnR04mHfdJZYuCqCRxW8DTsM1cXeLSb3tXWcGYwITz9C7Zpbn4EbAjKaVcsrbBFINnBiW92ZaLu+sF6AAAZwLJGzHYc6V3o6gbNcsbhClrnsgTnYmE7fRPJCSHi8crQGff3St0SK8NpIj7N4guc+FnGDked5gXHyFfn/5Wt6uooIK0sOt3e2tRQ4pnx5Mh83wW1mC/7ISdJrOJjurR8b5MfScd11n46ERQ394yw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba92335-dc03-4b5c-222f-08dafdab67db
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:25.2182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXHmli45zaV8DebHCuXwD0Ynb5Bg1tJqe0Gut63xxQD0UrqAbHjZPZPzkEz3JhiyxetS0iC7yDymKdepnT/wOqfKVGtLsQ0PJUDtdX6gYm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240010
X-Proofpoint-GUID: OgWg3ohLaTry1X26AlAID-9TyJM9oOZz
X-Proofpoint-ORIG-GUID: OgWg3ohLaTry1X26AlAID-9TyJM9oOZz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
 fs/xfs/xfs_inode.c        |  2 +-
 fs/xfs/xfs_inode.h        |  1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5a321b783398..c0279b57e51d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -820,13 +820,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..fdf6941f8f4d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..27532053a67b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -447,7 +447,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa780f08dc89..2eaed98af814 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -574,5 +574,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.25.1

