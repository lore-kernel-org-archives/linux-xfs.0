Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6FFC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348139AbiAUFWL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:22:11 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32180 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245363AbiAUFVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:22 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L043P4017784;
        Fri, 21 Jan 2022 05:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=brLYlywMMMOyz4uvfVABc1jXyU+lhPjj4ttrhqkfKng=;
 b=uD6/wNwgoIY8Q6V9jBsmILpBjzzYbiCMe8uAViWAe2ouBNoEdcxf0Z9YmUtgfoSkrTRY
 MEIzGCWF04dWboxU7YB0lfZCVjnr8oHin3k5C1Aa10gIiW54EzR0xX2wlLXsw1v63623
 OokLDren0n9We1XFhMTf98zG7iRtl31F5x0uNpJ1iOckhum8Vjhhh08vh4UDHsigCzSZ
 e5EO0/8VN447ok9K+tUR8oX0A0ZhRAjSJVZVRBcKTmmWiFTDlL7i6MIqw41AWxvzLEP3
 KwUQ1uMdxSbMISO8eGKvra8o4X3uBgQWrKNbceuUJBORPavt0HHhQetXMSNW1ctpaLi1 cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhyc0d4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KAG4170203;
        Fri, 21 Jan 2022 05:21:19 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
        by userp3020.oracle.com with ESMTP id 3dqj0max66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXQMpV/pnYVH78odKmwkausfEy9Is/SOw7XmlwHpMV2mxtn8fQE2+BKIv8+c8WtaDb1pT3EfWBKpOI6HzmiVuQHbHMIC4P/waLuFqwlZ7dIoEtNjHlBgGpARxo/RaUd6gvZfjNZWJ85h3ZUiNZ3TGxKVc3UWn8H2wTHjjCl9zsosx21ig6h9XtXVAFp9v+wNsGKn4mWonSPaomzjZKUVgHOj4oP2nQJZOo2brvIzJ/7ctAqa63cziXuvNYfrYe8cQIlxP7f2nz3XKTpob1WxQUPl4FjLsMkWX5BG1s8EOBixK1uX5Pzydpul8PAGkQisAg3Fxe+dqo5NKGOQeOC0PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brLYlywMMMOyz4uvfVABc1jXyU+lhPjj4ttrhqkfKng=;
 b=RM4Uzp1AeHm1tNlaXeEUT3FmRGrxfkfxmTzGNEnT0LialxDo9qk1nJpxRkEpMECyP9RNy7MK1PR7dwes+D7ePAniQqFJtJMrllI40U3PCZ6vE/e2BM5MmucjMQXlIf1nyZMjKuUxzgCrW8Xv3NepF4t6zbC33SYr/9EDt+jaKO1Hg72DUXVtIXBEuS8RfT/UkBoP0ZyHjhbVlbY+HWHRENG2835l1XD1FeUuX47fFqSbBEjkJvH6uI8nsJOidV0QZa4Oof+nPCGJwgTX9F/zfft2eVpG8v1aFm7woFuiuw4mFYDLemw/ZdofsjBlTHWRgh+Wsi41ylS7xOhcoOyjWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brLYlywMMMOyz4uvfVABc1jXyU+lhPjj4ttrhqkfKng=;
 b=cqapg9QQz2BDu2DbEVfcvR32fRwFfQ5NhED3fU7SFznxeZB4QiqGRpS1XGBBn+axuC+1h6usiOCNAYv7VMuO4QLs8N2SzId9hlkRuhk7v4wZ3nB2LjQG1R60jJQAbbJisTWjZwnPjoY2GZIXKGaTLbD/Z8qQPz1ShpsISeL3UBc=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:21:17 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 17/20] xfsprogs: xfs_info: Report NREXT64 feature status
Date:   Fri, 21 Jan 2022 10:50:16 +0530
Message-Id: <20220121052019.224605-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1409bd4-0d68-4435-909e-08d9dc9dd986
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB532268D9A86AC008154B43BAF65B9@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4gL2zqiETESYIUjFto9RwA9hfxfHHPw9a69ZuLlFbfI9/BZtywQlWxPTXaXrrJLwVp+/oTLAaK8zZLSs+4UN31A818i4dxjNRtLurN2MCma5szZj8jDoN1e970B1y0BBs+Cb4BU5blfB99WDD3l4qrc7FBDd0UZjlWPm94FdAQu3kvO7TV9IuCe3Go9HarsgCfT9vEda7EWNjnfHXLvaOZozTL2WLPHXzKYwG0L0G5plNnlDj/55/JLKTITrhIqiajIYoX7wGk98ZltSIKuPNDQj3TH0JtrtnQ5p2Lo1dl84Dr7QjQ8QGbiwY6/GitEoHgyxJ3W7XxnNxcdolIP34yPj8Gvt3/psAxHBMXlzX+RG4yuJ4NorAAdrH2SznGk74zJE5qWbufNXBHt1K0tQ23DiOtS06G+8r/jDHKdgdtuFLIae1mGRyDHoHgO06ypMHqlyh3L0UaWSkkjt9MHDQwYiijFc6yiF2a6opfrPWmRawzV2prYxIczLyl1eVyJdeteCYMtW7X6jXfWCYCrOmDC4RgegunpWum1FPbxpaM9mHP5l1bO96ylA+h8gB7JnMYIN7zkZkcPKklTSq8NM1feE+uWJldyBBMSntpEZvSZ+nEod43YPgIQVPp8jHTEkWyYsrOqgpWrSkqheMRhBi4Bc7E6+W2yOClD0IR/XhHNClG/wv2yy/gOYx2Qmk6ORvlrKkUUaybiUBS0h6ILwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(316002)(8936002)(36756003)(38350700002)(38100700002)(6916009)(1076003)(2906002)(508600001)(6506007)(66946007)(66556008)(66476007)(83380400001)(5660300002)(6512007)(8676002)(6486002)(86362001)(52116002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IcOCRxpvpT1Z6/1AvHs8t1t5hZD9f3j2iPQvL+EzRyrWFv1btZ2xS3qu8a7p?=
 =?us-ascii?Q?VyQAP6I5eT4HG9FsIIIx/IJTjBD8q/jXzHRQPLiS56LXYTl1tZVkBbF0Ukt0?=
 =?us-ascii?Q?iQi2Ma4Yfmcq/5tSAOp5GelPKnp9q28LwOInrxI592OjCKs0ZaSzEwfx2v9v?=
 =?us-ascii?Q?lypfKDcwM+UFBhnY+nYUKj7TyfwGHGHTRhEU4fSNhf3tc5HtWj46qi+TKY9T?=
 =?us-ascii?Q?nU+D3K7dZ+ybC89a1kCgXXU2R9lXKbrCyq/EV3UKfJvqI1vm8hHC2JeAOXUb?=
 =?us-ascii?Q?SJUvtATE5dr6a8akAJ/uslOSi9ropDLUOsuKP/rXOl4JlFzCY/iygZY44eXb?=
 =?us-ascii?Q?9sSsUIKPr6KQ7xHSQDt7kt2GOknu6YoVVB0OucM58o7khkbW89vzFEnnORSk?=
 =?us-ascii?Q?d8D6EB8upKXqgNFSbIUWYKrM/+uW4rhNQgiRK805dhg/ifUMQySoo6+/jP18?=
 =?us-ascii?Q?amo5wivuiEhxy+VbrtLuxH88kRiVlQo9x0jMSYV3Kwi/IqeOuhVm0FVRXTVK?=
 =?us-ascii?Q?/35ZgYOYfvE4BMoFKEnrscB6DveBxXY08zu2Zbao8rUgAWL3xR7nqArpzuB2?=
 =?us-ascii?Q?C3330thjnGFVKpSl3R91UmRJapEPMYYYjWLGAyoO5nQopQPSTpR1cFxs7quQ?=
 =?us-ascii?Q?FyEvTtJg6dTIifrkXqaPo3pLoO/jMGHbAvPdLo1lpu91Nvg4ETDXQTpbLzdf?=
 =?us-ascii?Q?fAdumRuUKWLOLmMqBXC/uVrmQQ+nV00FbTdNazi28G703yPkYVyY15czeZL+?=
 =?us-ascii?Q?C2SxkM0N7TbaRtgvGY4/0AibSdLK+ICQqcf/UAbOsXet43QoMdeK4dNTk4+N?=
 =?us-ascii?Q?ujnWUp/cA8DkuCyGUVI5WKCJk1VraFX3yt6z8mV9DuDhjkh/eM4dWN7VnVa9?=
 =?us-ascii?Q?3Z9KBHcCK+YufqZ01JFgA0ywINK8GBYwOP0gWdcVVY4JKRHm4wvMSxlHyFRD?=
 =?us-ascii?Q?sCIyPR08/bUty5p/2A5MqCn05tAppgzH9/P5+2/y4Wr+P/4fjWU2w2Rh3BJv?=
 =?us-ascii?Q?4umvg8CsuU1gH0Byju8GA+k7Qv7aF3BvfBway8NUT4+53Wiw1QFunXk8vq39?=
 =?us-ascii?Q?CVH77naRgpTgP05TN6d+qzZpNqFK4+GeecuRKuvPpsXQ3YAasSs2/wC/xTm2?=
 =?us-ascii?Q?70InonopZMp4wsqjQjDv9AZ3w7MAfXtvPvnSTEMUge+p5rbJ86W53nFW/Zii?=
 =?us-ascii?Q?hFPFYvSbcrU1c+sXXoDL14jXPse2a7W7T6z0xAOw2Yehs9XBlduZ45yokifb?=
 =?us-ascii?Q?+AI/akgrJxJINdpiwnqmlUecyM0tLFfyvK9FJ67wLaU4WIfyKIRLcLmIIDWh?=
 =?us-ascii?Q?wD/qKD1HzkTmuIiLapn0KO/0kIFafy/j6YrHrspvpsKIiy4lqaFRhNS+6LNQ?=
 =?us-ascii?Q?cafva1h7FgTwUe/jNKNMKwfJX12HrPfr+J9v7KuYWcqSOJRU0lCIvdxYHlJJ?=
 =?us-ascii?Q?o9+56w8eMozyzhBx2gkPfDthCFKZ6AT+LZbrXNaYfGS+IXf717W69maL7wza?=
 =?us-ascii?Q?7q/gNiNTRZiU4/N2cLeESQa5KvPaLlQtLbYjqnrhpd0DGtUI4umOqnS97a2q?=
 =?us-ascii?Q?WB2YnIYUVZjyhfy+r+JbV2M9SKO2DcnuFh1h/iCovX7a7RozFGSwQXir+SLi?=
 =?us-ascii?Q?xYLNGVCnwPJryNNEGjTxIHY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1409bd4-0d68-4435-909e-08d9dc9dd986
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:16.9898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9JM55UxoQn5edo+KFrkBoOi/69NlW7hIQa6rVkpVg/Wti8KlVuoR4zLYfw0psM30GPOC5irZOTp6zuagph5qJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: SvzCmV4Z9OZx3iUuwxTMoOdtihifAzSW
X-Proofpoint-GUID: SvzCmV4Z9OZx3iUuwxTMoOdtihifAzSW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to obtain information about the
availability of NREXT64 feature in the underlying filesystem.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libfrog/fsgeom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 4f1a1842..3e7f0797 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -30,6 +30,7 @@ xfs_report_geom(
 	int			reflink_enabled;
 	int			bigtime_enabled;
 	int			inobtcount;
+	int			nrext64;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -47,12 +48,13 @@ xfs_report_geom(
 	reflink_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
+	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
-"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u\n"
+"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -62,7 +64,7 @@ xfs_report_geom(
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
-		"", reflink_enabled, bigtime_enabled, inobtcount,
+		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,
-- 
2.30.2

