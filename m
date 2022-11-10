Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C864CC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 06:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbiKJGgy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 01:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiKJGgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 01:36:51 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B1D2CC95
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 22:36:49 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA6PsY0020550;
        Thu, 10 Nov 2022 06:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=GkpzlVpXxyo3IGTibvST+T2cCzhDxLfLncGsdmF2zAI=;
 b=LvAzFwt9FPmPRlBByyjf9VUQFuZu/7AX7QCgn5aasbwfbtd+WuQm3tVvdQ/LtoSZE2yy
 vxYgOPl2xGdcFZYO78372z5vKLjSAxUo8bxhyUXNNYzF5NpS+ChizWyhAa9G0vbf900E
 +MjWQAi4LaFQabNr9yWvdkW5ixdVCtEynKK19jaZwfDj53HmrUs5mzOhp7waOi2amHp5
 b6jF3wHp3ozc4YrF3HlN9Lgqv70VoDq6Nausx4JHGKVO1aaal0WCISo/LyNVEy6k+Ly5
 FZU5WTVTLnPHb07XiAC5Zpl4Jv6eO2BmYNts3PcIvSa86GSc7K5Q5pcTp3PXNr9I1NKz rA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krv1100vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA5AxtW036342;
        Thu, 10 Nov 2022 06:36:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcyrck17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShtSSdOGnbToCJvd+CKiPeTYKP5ZXiOKEFEu8YmbHNvmAJWZrMF52paI5kWUBnPwGkkrepZb4tdFyHgpXOeQIvVszBEajEw6Ip7s+fZzdsCbUUYrqbO8j3FBKMwEztAC5DwAcqUkicf+NBexkDGyS48kwKz7gDHMDslDn3Wz3+UeUrYhBvdHyWx4Jsd+qMkzuDWppcAuSZ+r2Hx2CipHHu9iEH64QQO70xD33fucD0jz51bHnJVPLrRn5ub7pY6uz3bCU1goiKGMBaWWb0txPNmZ4OdwO0vdH9JlVLgBVLih0ZOD6f3+ttgYzH60xvRpHZRu+eJ8b1D6Q63F1U0ygA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkpzlVpXxyo3IGTibvST+T2cCzhDxLfLncGsdmF2zAI=;
 b=A98/3SbawHSc88ZutxwpKOScWVXkLXLGSipn2k0a0QDQKPkYrOSm8cSAzfz8p8OIAj0mFGGNw2c018TQqLOyx/HyFKgVUW0UuggBQH2tqzTssFLQQDGjN23qPONO0BmWwgCA6r6ykDgUyEfMY4DOar4v5WEGQZ99Hv2adwGOoYnYCyDK9f8G8KPfGega4kMsWG4ULctoCS9IV9zGkrbyRZNRNd8Zf4hqWYpDiG8WyJ+UQzxic0iz9zShv6siYFix528egiMeA7yIMenVFG32Au/q/hd4I/+zAcxJOKppNkbTeG5MKULwoLE/tThFRPcQyDhZHGPs7ptojScy1HsO5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkpzlVpXxyo3IGTibvST+T2cCzhDxLfLncGsdmF2zAI=;
 b=XuZZeXWq4bxsM/9sccXp0mRgfiL++rSfc+vPO89Oe8aviv3VvgvdDXEZMDG2ui32aKvwFKshZzvPDYErmTLItrMTCE1/o48tbT0+/OrLbbGvJseGIHHk8obEhsmcbE4QWT3Uu7q1VU4baOQOflWvWWkjamLd+T/ib8oPMkRtFa8=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 06:36:37 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%5]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 06:36:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 3/6] xfs: redesign the reflink remap loop to fix blkres depletion crash
Date:   Thu, 10 Nov 2022 12:06:05 +0530
Message-Id: <20221110063608.629732-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221110063608.629732-1-chandan.babu@oracle.com>
References: <20221110063608.629732-1-chandan.babu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0200.apcprd04.prod.outlook.com
 (2603:1096:4:187::15) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|SA2PR10MB4748:EE_
X-MS-Office365-Filtering-Correlation-Id: c0ffd35a-04e4-4669-7ed5-08dac2e5eb47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fy464aKEoHmDtipMI9lBj7ZTF9/VuLBaqCJL+GyNwT07c+fJ2OMzAuP+13AoHShlTB0pWJt+Lhaah1+ONkcZLFXhguuJ5I91wmH6zmHp5KVOlkcl3Z7ZLR6mMw+V8nCSsykxL7dbe8QeLHbRUBRxBbD/HUzBv+d1THl+gpzBy9Z6fI3iMMBxI2CASYWhbU6lh1jx/aRRLZ1zaXvdgz0mxlEW9Ml8R/yOs2nyozjiRG/ZZG5VDTPKRMqM5j/YIMg83reymsn9qHvrSJT9IrgHAgXyziEXIIQ9B14//tEsN/LDDQzgRMAuTnKLlNzdcmIhV//fNcV4sAG7QslbH0lxFNAasXchR2toqGGtI5X52PbtdSRtYDoA4r+EJs7WDhR3vn1pyh00cq0KuywY0r3yvfnu4w9uwWIuVMHsgEMkDSe7yOAvHQ1e84ob4AVNJljvbetdwOZBKhWJX1i/svAuBzsIbJvH+2+5uWSiJFcRi59rHR0x2Ix8hTSF3KqgqA+O8e39CzdoQGiIyHsBZ2VAJZ++Aa0eImov0pxx+yemmSqnwHIkeCz/+BXFB3rHuQ3+G409Ywck5RebaBaNzJcrA+BflK/gpQDfoAT91aSRm4i2/zxMBrQ3m20gxUxX38jtN0dQ3CRPDrYFC2zkvyRC7fj3OaHWUsNwFVK0fiRN+FsZXPX5VCwFchBsg0SVih/AqHqXs64wk3xvnKJwMoc1yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199015)(38100700002)(86362001)(66556008)(8676002)(4326008)(66476007)(66946007)(41300700001)(2616005)(5660300002)(316002)(6486002)(478600001)(6666004)(6916009)(8936002)(66574015)(1076003)(186003)(83380400001)(2906002)(30864003)(6506007)(6512007)(26005)(36756003)(66899015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1d2TGZHbVg2RU9Nc3BLK0NScXhKUCtZOWFBY0ZxK2l3TUF3RlRyd1I3MEs1?=
 =?utf-8?B?OHkvNUtYcWNSV1RvWXFtenNKMzgrVDYreTh0Q05ldUpMYXpBZC9hVGxHcTZ1?=
 =?utf-8?B?bTl4WU9aZkNQNHk3K2JsaVN2SUtWRTMyZ3pvWmx1WW1nc0ROd3RLMXZFd2d1?=
 =?utf-8?B?L1IvV3lsaG4xTWtwZEtOSFpxM3NQYXlXbnVXbGhzYjFZcHQ3Ti9sRnBwNVBM?=
 =?utf-8?B?cnpuU2pCMHQ5VTNaallFZkZYUzFOd2VTdXVFV01YY29xRTNQM1Jld1dFS2JG?=
 =?utf-8?B?YWpKbXRJSzVhU05mbnpNQXdzS1Ywakc1T3NIbFEyYTRaWW1FZ012MHF5UHBS?=
 =?utf-8?B?UFZMR3NVb08xMi8rbklmMXdIVXgrVndZQ3FWMkJCVjN5L1BQb2pwNWFqSkR4?=
 =?utf-8?B?N1RhSDczT0xtZjY2UEJEbDFhVHovVmhocnNSbjdaOUEvUE1jK0xqc3V6VEFW?=
 =?utf-8?B?VGc4YVdzMHdFSTA5S3ZkdkUvSnVkekRId0NZdEZWU3o3ZGpiYWZRcjIvQkdU?=
 =?utf-8?B?b0U5a1NidmpxaGdHSUpsZGhYbzZOVnFRY1RGOTJqRE0zUzJldWhuNXhLeFJ4?=
 =?utf-8?B?VDhtbmxSUU15WitCNEk3Wml3Rkh5QWg5a0hhLzZGaXo3VkMvRXhwWHdTVnBR?=
 =?utf-8?B?YWdwQlZSTFlDZ29td29DYzFjZlRFSm1tTmhXQmg2N08xdTV0NXJEQ3Z1dkt0?=
 =?utf-8?B?K3QzYlUrZnp3M2U3UUxyTnprdWFEaFNpbHd0ays1L0hhYXA3T2xROUc4ZGRF?=
 =?utf-8?B?elVYT1JGSkYyOHdXSXBWSzJRODVRZy9HS2RMbVYxZUFydWY0ZG4rTG14QWRY?=
 =?utf-8?B?S0FiUDNnNTR0N1JKVzlUWUhGSjl3S3BCK21uVWZPeFdkVkZyZERzaGJBd2lk?=
 =?utf-8?B?TlFwOUlRaWRIY2xQTW1WbEZJQWZQNmExRkVTSHZjUDRveUlOeXkyY3dMaUlF?=
 =?utf-8?B?d092NzFkZWlMb3hvOHFleTZPZ2o5ajdwVXBtdStUd21ZeDd0SDMyRG95bGk5?=
 =?utf-8?B?bDJKUW5QcXpiTEk5enJmODAvTklNV2RrejIxMWJFOFhKblhEUzNhVlg2NkZ2?=
 =?utf-8?B?a0ZBamZBa1dtVEF2U3Q2VCtBdXUwc2tIVmhLTWwvRjBSV0c1cEJvajc2YXFr?=
 =?utf-8?B?a3pKaHNYZEErQndWcHFoTkNDM1pMTWdib0l4dGlYRk5hYW5SaE1DaUVxLzZP?=
 =?utf-8?B?QzhNWEpOSTN6YUFLRG1CY1R2aDE1WmZlNTd6a0JvaWo2Zmx1OGNwanVOT3Nl?=
 =?utf-8?B?TFhZdVk3T0NGemJIQUV3YWJnZkdZLzBsOW5xb1EweVFGOVI4VTBVZ1AycGJM?=
 =?utf-8?B?VWp0NWpRUW1oRXFFQVE3OGViMXdaQmZOYVVOUFdKZFluYWpIL0V0clBYaDdy?=
 =?utf-8?B?cjFtTmltQUJtZjlacXI0VDJwWURUTytwcnJSdDdLbEJ3dnkzZzMraXdTUE9k?=
 =?utf-8?B?ZFhQQ21mcWVoWllxVlhFOWxvR0hOK2RmMGE3RFNyQ2hrMkpJRFlQenp4bFpG?=
 =?utf-8?B?NnRIMk1pWnp1N2M0R0RkYXB5MGNwaUs3Ni9CdUwyN21QcFJxM3YvTzdQNDZO?=
 =?utf-8?B?Y2hyL1JPejZ5MnpLK2pROEVIT3FjNmhkZzBBSmI0K2FpUURTWHVRSW8zeWJa?=
 =?utf-8?B?Skk4bXpvUk5ZRk1mM1lqdy83OGFSNGpxczBPczdhYnJtYVdmZWFGZlE3KytK?=
 =?utf-8?B?SDVmQngwWnhDQlRWMEVlUnRsb1FxaEQxc0xoUVE1ckJhUWdHUDY4RHpxeE5W?=
 =?utf-8?B?NVRNMWZjNFpGdXhzUHNack96V0QwT0dYQ0MrWUFmb2ZHSnZQK3Y0ODJVUlo0?=
 =?utf-8?B?UzZpNVh2OUlQZlJ5MWVKcjlla1VXc2NZcmRFMlJWSy9MTmROWFhEalJNakFa?=
 =?utf-8?B?QkpVQ3JyV042QlMyZTlVME1mb3E4WitMVzRqUVZpc3M5YURWNGlYUC9HejVR?=
 =?utf-8?B?Wk5VTEkyZ28reDRSckJXOHZ6QTNZTXdzN2FIZzMwSW1wSGN2M285TFYzeTVn?=
 =?utf-8?B?Sk91OFJEeXkwYkYzV3Q2V1dLOGh4QzhMUmRTNVhDVFFvVGRobCt2WUFqUytX?=
 =?utf-8?B?N0lOVk90enRoUHZqdm1ENTREcmJROWliNndvTThraE5kRDdONGV3cUxMdUJl?=
 =?utf-8?Q?53JYxfgH4QTG4BFluRZNkej5t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ffd35a-04e4-4669-7ed5-08dac2e5eb47
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 06:36:37.8851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6aI6y8+4llNkaocID1q7cJ4wkTpeZ6SChQOq6uQSZ0bIw2lUMlgNe2IeoF2GO6yqVPD0Lf/yI9rw31n8PQzHrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100048
X-Proofpoint-ORIG-GUID: cBUNQ26AIYveNhfLlBtlJrEAmo-m6wu1
X-Proofpoint-GUID: cBUNQ26AIYveNhfLlBtlJrEAmo-m6wu1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 00fd1d56dd08a8ceaa9e4ee1a41fefd9f6c6bc7d upstream.

The existing reflink remapping loop has some structural problems that
need addressing:

The biggest problem is that we create one transaction for each extent in
the source file without accounting for the number of mappings there are
for the same range in the destination file.  In other words, we don't
know the number of remap operations that will be necessary and we
therefore cannot guess the block reservation required.  On highly
fragmented filesystems (e.g. ones with active dedupe) we guess wrong,
run out of block reservation, and fail.

The second problem is that we don't actually use the bmap intents to
their full potential -- instead of calling bunmapi directly and having
to deal with its backwards operation, we could call the deferred ops
xfs_bmap_unmap_extent and xfs_refcount_decrease_extent instead.  This
makes the frontend loop much simpler.

Solve all of these problems by refactoring the remapping loops so that
we only perform one remapping operation per transaction, and each
operation only tries to remap a single extent from source to dest.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reported-by: Edwin Török <edwin@etorok.net>
Tested-by: Edwin Török <edwin@etorok.net>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.h |  13 ++-
 fs/xfs/xfs_reflink.c     | 238 +++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h       |  52 +--------
 3 files changed, 141 insertions(+), 162 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b5363c6c88af..a51c2b13a51a 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -158,6 +158,13 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
 	{ BMAP_ATTRFORK,	"ATTR" }, \
 	{ BMAP_COWFORK,		"COW" }
 
+/* Return true if the extent is an allocated extent, written or not. */
+static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
+{
+	return irec->br_startblock != HOLESTARTBLOCK &&
+		irec->br_startblock != DELAYSTARTBLOCK &&
+		!isnullstartblock(irec->br_startblock);
+}
 
 /*
  * Return true if the extent is a real, allocated extent, or false if it is  a
@@ -165,10 +172,8 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
  */
 static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 {
-	return irec->br_state != XFS_EXT_UNWRITTEN &&
-		irec->br_startblock != HOLESTARTBLOCK &&
-		irec->br_startblock != DELAYSTARTBLOCK &&
-		!isnullstartblock(irec->br_startblock);
+	return xfs_bmap_is_real_extent(irec) &&
+	       irec->br_state != XFS_EXT_UNWRITTEN;
 }
 
 /*
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 77b7ace04ffd..01191ff46647 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -986,41 +986,28 @@ xfs_reflink_ag_has_free_space(
 }
 
 /*
- * Unmap a range of blocks from a file, then map other blocks into the hole.
- * The range to unmap is (destoff : destoff + srcioff + irec->br_blockcount).
- * The extent irec is mapped into dest at irec->br_startoff.
+ * Remap the given extent into the file.  The dmap blockcount will be set to
+ * the number of blocks that were actually remapped.
  */
 STATIC int
 xfs_reflink_remap_extent(
 	struct xfs_inode	*ip,
-	struct xfs_bmbt_irec	*irec,
-	xfs_fileoff_t		destoff,
+	struct xfs_bmbt_irec	*dmap,
 	xfs_off_t		new_isize)
 {
+	struct xfs_bmbt_irec	smap;
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			real_extent = xfs_bmap_is_written_extent(irec);
 	struct xfs_trans	*tp;
-	unsigned int		resblks;
-	struct xfs_bmbt_irec	uirec;
-	xfs_filblks_t		rlen;
-	xfs_filblks_t		unmap_len;
 	xfs_off_t		newlen;
-	int64_t			qres;
+	int64_t			qres, qdelta;
+	unsigned int		resblks;
+	bool			smap_real;
+	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
+	int			nimaps;
 	int			error;
 
-	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
-	trace_xfs_reflink_punch_range(ip, destoff, unmap_len);
-
-	/* No reflinking if we're low on space */
-	if (real_extent) {
-		error = xfs_reflink_ag_has_free_space(mp,
-				XFS_FSB_TO_AGNO(mp, irec->br_startblock));
-		if (error)
-			goto out;
-	}
-
 	/* Start a rolling transaction to switch the mappings */
-	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
+	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
 		goto out;
@@ -1029,92 +1016,121 @@ xfs_reflink_remap_extent(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
-	 * Reserve quota for this operation.  We don't know if the first unmap
-	 * in the dest file will cause a bmap btree split, so we always reserve
-	 * at least enough blocks for that split.  If the extent being mapped
-	 * in is written, we need to reserve quota for that too.
+	 * Read what's currently mapped in the destination file into smap.
+	 * If smap isn't a hole, we will have to remove it before we can add
+	 * dmap to the destination file.
 	 */
-	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	if (real_extent)
-		qres += irec->br_blockcount;
-	error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
-			XFS_QMOPT_RES_REGBLKS);
+	nimaps = 1;
+	error = xfs_bmapi_read(ip, dmap->br_startoff, dmap->br_blockcount,
+			&smap, &nimaps, 0);
 	if (error)
 		goto out_cancel;
+	ASSERT(nimaps == 1 && smap.br_startoff == dmap->br_startoff);
+	smap_real = xfs_bmap_is_real_extent(&smap);
 
-	trace_xfs_reflink_remap(ip, irec->br_startoff,
-				irec->br_blockcount, irec->br_startblock);
+	/*
+	 * We can only remap as many blocks as the smaller of the two extent
+	 * maps, because we can only remap one extent at a time.
+	 */
+	dmap->br_blockcount = min(dmap->br_blockcount, smap.br_blockcount);
+	ASSERT(dmap->br_blockcount == smap.br_blockcount);
 
-	/* Unmap the old blocks in the data fork. */
-	rlen = unmap_len;
-	while (rlen) {
-		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1);
+	trace_xfs_reflink_remap_extent_dest(ip, &smap);
+
+	/* No reflinking if the AG of the dest mapping is low on space. */
+	if (dmap_written) {
+		error = xfs_reflink_ag_has_free_space(mp,
+				XFS_FSB_TO_AGNO(mp, dmap->br_startblock));
 		if (error)
 			goto out_cancel;
+	}
 
+	/*
+	 * Compute quota reservation if we think the quota block counter for
+	 * this file could increase.
+	 *
+	 * We start by reserving enough blocks to handle a bmbt split.
+	 *
+	 * If we are mapping a written extent into the file, we need to have
+	 * enough quota block count reservation to handle the blocks in that
+	 * extent.
+	 *
+	 * Note that if we're replacing a delalloc reservation with a written
+	 * extent, we have to take the full quota reservation because removing
+	 * the delalloc reservation gives the block count back to the quota
+	 * count.  This is suboptimal, but the VFS flushed the dest range
+	 * before we started.  That should have removed all the delalloc
+	 * reservations, but we code defensively.
+	 */
+	qdelta = 0;
+	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	if (dmap_written)
+		qres += dmap->br_blockcount;
+	error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
+			XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto out_cancel;
+
+	if (smap_real) {
 		/*
-		 * Trim the extent to whatever got unmapped.
-		 * Remember, bunmapi works backwards.
+		 * If the extent we're unmapping is backed by storage (written
+		 * or not), unmap the extent and drop its refcount.
 		 */
-		uirec.br_startblock = irec->br_startblock + rlen;
-		uirec.br_startoff = irec->br_startoff + rlen;
-		uirec.br_blockcount = unmap_len - rlen;
-		uirec.br_state = irec->br_state;
-		unmap_len = rlen;
-
-		/* If this isn't a real mapping, we're done. */
-		if (!real_extent || uirec.br_blockcount == 0)
-			goto next_extent;
-
-		trace_xfs_reflink_remap(ip, uirec.br_startoff,
-				uirec.br_blockcount, uirec.br_startblock);
+		xfs_bmap_unmap_extent(tp, ip, &smap);
+		xfs_refcount_decrease_extent(tp, &smap);
+		qdelta -= smap.br_blockcount;
+	} else if (smap.br_startblock == DELAYSTARTBLOCK) {
+		xfs_filblks_t	len = smap.br_blockcount;
 
-		/* Update the refcount tree */
-		xfs_refcount_increase_extent(tp, &uirec);
-
-		/* Map the new blocks into the data fork. */
-		xfs_bmap_map_extent(tp, ip, &uirec);
+		/*
+		 * If the extent we're unmapping is a delalloc reservation,
+		 * we can use the regular bunmapi function to release the
+		 * incore state.  Dropping the delalloc reservation takes care
+		 * of the quota reservation for us.
+		 */
+		error = __xfs_bunmapi(NULL, ip, smap.br_startoff, &len, 0, 1);
+		if (error)
+			goto out_cancel;
+		ASSERT(len == 0);
+	}
 
-		/* Update quota accounting. */
-		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
-				uirec.br_blockcount);
+	/*
+	 * If the extent we're sharing is backed by written storage, increase
+	 * its refcount and map it into the file.
+	 */
+	if (dmap_written) {
+		xfs_refcount_increase_extent(tp, dmap);
+		xfs_bmap_map_extent(tp, ip, dmap);
+		qdelta += dmap->br_blockcount;
+	}
 
-		/* Update dest isize if needed. */
-		newlen = XFS_FSB_TO_B(mp,
-				uirec.br_startoff + uirec.br_blockcount);
-		newlen = min_t(xfs_off_t, newlen, new_isize);
-		if (newlen > i_size_read(VFS_I(ip))) {
-			trace_xfs_reflink_update_inode_size(ip, newlen);
-			i_size_write(VFS_I(ip), newlen);
-			ip->i_d.di_size = newlen;
-			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		}
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, qdelta);
 
-next_extent:
-		/* Process all the deferred stuff. */
-		error = xfs_defer_finish(&tp);
-		if (error)
-			goto out_cancel;
+	/* Update dest isize if needed. */
+	newlen = XFS_FSB_TO_B(mp, dmap->br_startoff + dmap->br_blockcount);
+	newlen = min_t(xfs_off_t, newlen, new_isize);
+	if (newlen > i_size_read(VFS_I(ip))) {
+		trace_xfs_reflink_update_inode_size(ip, newlen);
+		i_size_write(VFS_I(ip), newlen);
+		ip->i_d.di_size = newlen;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	}
 
+	/* Commit everything and unlock. */
 	error = xfs_trans_commit(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	if (error)
-		goto out;
-	return 0;
+	goto out_unlock;
 
 out_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
-	trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
+	if (error)
+		trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
 	return error;
 }
 
-/*
- * Iteratively remap one file's extents (and holes) to another's.
- */
+/* Remap a range of one file to the other. */
 int
 xfs_reflink_remap_blocks(
 	struct xfs_inode	*src,
@@ -1125,25 +1141,22 @@ xfs_reflink_remap_blocks(
 	loff_t			*remapped)
 {
 	struct xfs_bmbt_irec	imap;
-	xfs_fileoff_t		srcoff;
-	xfs_fileoff_t		destoff;
+	struct xfs_mount	*mp = src->i_mount;
+	xfs_fileoff_t		srcoff = XFS_B_TO_FSBT(mp, pos_in);
+	xfs_fileoff_t		destoff = XFS_B_TO_FSBT(mp, pos_out);
 	xfs_filblks_t		len;
-	xfs_filblks_t		range_len;
 	xfs_filblks_t		remapped_len = 0;
 	xfs_off_t		new_isize = pos_out + remap_len;
 	int			nimaps;
 	int			error = 0;
 
-	destoff = XFS_B_TO_FSBT(src->i_mount, pos_out);
-	srcoff = XFS_B_TO_FSBT(src->i_mount, pos_in);
-	len = XFS_B_TO_FSB(src->i_mount, remap_len);
+	len = min_t(xfs_filblks_t, XFS_B_TO_FSB(mp, remap_len),
+			XFS_MAX_FILEOFF);
 
-	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
-	while (len) {
-		uint		lock_mode;
+	trace_xfs_reflink_remap_blocks(src, srcoff, len, dest, destoff);
 
-		trace_xfs_reflink_remap_blocks_loop(src, srcoff, len,
-				dest, destoff);
+	while (len > 0) {
+		unsigned int	lock_mode;
 
 		/* Read extent from the source file */
 		nimaps = 1;
@@ -1152,18 +1165,25 @@ xfs_reflink_remap_blocks(
 		xfs_iunlock(src, lock_mode);
 		if (error)
 			break;
-		ASSERT(nimaps == 1);
-
-		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_DATA_FORK,
-				&imap);
+		/*
+		 * The caller supposedly flushed all dirty pages in the source
+		 * file range, which means that writeback should have allocated
+		 * or deleted all delalloc reservations in that range.  If we
+		 * find one, that's a good sign that something is seriously
+		 * wrong here.
+		 */
+		ASSERT(nimaps == 1 && imap.br_startoff == srcoff);
+		if (imap.br_startblock == DELAYSTARTBLOCK) {
+			ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
+			error = -EFSCORRUPTED;
+			break;
+		}
 
-		/* Translate imap into the destination file. */
-		range_len = imap.br_startoff + imap.br_blockcount - srcoff;
-		imap.br_startoff += destoff - srcoff;
+		trace_xfs_reflink_remap_extent_src(src, &imap);
 
-		/* Clear dest from destoff to the end of imap and map it in. */
-		error = xfs_reflink_remap_extent(dest, &imap, destoff,
-				new_isize);
+		/* Remap into the destination file at the given offset. */
+		imap.br_startoff = destoff;
+		error = xfs_reflink_remap_extent(dest, &imap, new_isize);
 		if (error)
 			break;
 
@@ -1173,10 +1193,10 @@ xfs_reflink_remap_blocks(
 		}
 
 		/* Advance drange/srange */
-		srcoff += range_len;
-		destoff += range_len;
-		len -= range_len;
-		remapped_len += range_len;
+		srcoff += imap.br_blockcount;
+		destoff += imap.br_blockcount;
+		len -= imap.br_blockcount;
+		remapped_len += imap.br_blockcount;
 	}
 
 	if (error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b5d4ca60145a..f94908125e8f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3078,8 +3078,7 @@ DEFINE_EVENT(xfs_inode_irec_class, name, \
 DEFINE_INODE_EVENT(xfs_reflink_set_inode_flag);
 DEFINE_INODE_EVENT(xfs_reflink_unset_inode_flag);
 DEFINE_ITRUNC_EVENT(xfs_reflink_update_inode_size);
-DEFINE_IMAP_EVENT(xfs_reflink_remap_imap);
-TRACE_EVENT(xfs_reflink_remap_blocks_loop,
+TRACE_EVENT(xfs_reflink_remap_blocks,
 	TP_PROTO(struct xfs_inode *src, xfs_fileoff_t soffset,
 		 xfs_filblks_t len, struct xfs_inode *dest,
 		 xfs_fileoff_t doffset),
@@ -3110,59 +3109,14 @@ TRACE_EVENT(xfs_reflink_remap_blocks_loop,
 		  __entry->dest_ino,
 		  __entry->dest_lblk)
 );
-TRACE_EVENT(xfs_reflink_punch_range,
-	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
-		 xfs_extlen_t len),
-	TP_ARGS(ip, lblk, len),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fileoff_t, lblk)
-		__field(xfs_extlen_t, len)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->lblk = lblk;
-		__entry->len = len;
-	),
-	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->lblk,
-		  __entry->len)
-);
-TRACE_EVENT(xfs_reflink_remap,
-	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
-		 xfs_extlen_t len, xfs_fsblock_t new_pblk),
-	TP_ARGS(ip, lblk, len, new_pblk),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fileoff_t, lblk)
-		__field(xfs_extlen_t, len)
-		__field(xfs_fsblock_t, new_pblk)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->lblk = lblk;
-		__entry->len = len;
-		__entry->new_pblk = new_pblk;
-	),
-	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x new_pblk %llu",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->lblk,
-		  __entry->len,
-		  __entry->new_pblk)
-);
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_range);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_blocks_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_src);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_dest);
 
 /* dedupe tracepoints */
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
-- 
2.35.1

