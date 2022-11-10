Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C44C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 06:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiKJGgY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 01:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKJGgX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 01:36:23 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5642B271
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 22:36:22 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA6AkEw018042;
        Thu, 10 Nov 2022 06:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=tjuOY8i8gdnMrWGIE8BKqKDh8KvKC61EjAWJLE/IVjM=;
 b=lhuWcqyqwwBgkrprxptkkNDXcOPzd/1x5Vw1j3OKu6VbypApoklBhesCPKIos0u/+2bo
 5eBZNXnlBXZbNM5Qa7EidjwaGLNogbmBgIO8ciVanT6WCBaUgAOUFuM7SjEqH10JREI6
 0LX69KMkUVEAnhbVoJQFzGWs8Jw7SYqVx6/RPGQWizFhApWO3yHIlgUj5qHb4C4tEei+
 pS5d0z6nbjXNci5e/nmGD+pGJaPW4HXQAJQxc/Vw4zkZ2Q0f76djVRQjwyznQdPktiit
 tVOZAmudqsUlaWrbP53Br4jRwHRIgj5i5qjcXX+An6BDjfiVcN2lST20dHmxXJtd7AWH Tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krut203d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA6BEwE004370;
        Thu, 10 Nov 2022 06:36:18 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq4fv7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XV/kGic9JZSxVwXjayMuofSMwwnWkg9KHJ17vrIKo6XZ+ZZUN7If1hC+UxD6FI9K3386dDszYqZNQ4K7Z3ZkN2Jx2t/onmcCbdrO3wpoccZYWPDjq4w5gYFf1t61zdto84CLf4FqU34m+kIf/d3Cm5d1lgmqFzld9I1Joq8aHt6f08+/rQx8H3wiYH9nsPKjSEIgwDn0tB/v+76zkmCyOUai8fHyMc+npE0cm1RsvuWMGFJoqZW7quotmNgwFD8NKEARaNA0xQZQKoXD6+dGyn89faTED3M0TvIRyPzerZSu8GY7kBIJX+v1+wcxUnKxqmY4pIsntJ95z9ifqcNczw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjuOY8i8gdnMrWGIE8BKqKDh8KvKC61EjAWJLE/IVjM=;
 b=PTJ2B3EUdC2ewCEPYgke89pfxm5j+cK0Hkaw9mG5lI0SjdEN29f2hN0LKMn6K2EwoIyVkJS5s8m5BOpzffb19ihlQvMwMR1QDKdeGHxkoq0GgsP0QBOFBgwFlmqSTYN8Xeu7a/kAsVuhPyb0EhqDoy/h2GN/rFdFkFwKjPw1RqQp7Ntvbaip3brb8qdnh4uAkGQ8gbZEW5J9/ZMld/F2rq3+xx7+ZHv/nYY2MpoLPkRDRgJr+TI+PPr0ZX1HrFmP36gZv5H529KNmaqRnR55Gjglos2NTfR4Ko9ZhC2Hx8nIRCHxVRIGdQiTaFKWA2fswx6HmXiDf597umgY3mOpNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjuOY8i8gdnMrWGIE8BKqKDh8KvKC61EjAWJLE/IVjM=;
 b=B6qMIkwYjdwfkWHr0NcbEVlOWP4je1os/2WwEOufbLHT4XZqdfuaYXuybUCVbqwjMR2CyG+kSXowX+br1dVo9Z/kIVcDCqCdFEhYatQo8UtpdazjRxuhooxBgaL8YSoqGJkfrNqCrEWUNISK8zedFhzyhjtbDah9kD++EjCjTQc=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by PH0PR10MB4742.namprd10.prod.outlook.com (2603:10b6:510:3f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 06:36:16 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%5]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 06:36:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 0/6] xfs stable candidate patches for 5.4.y (from v5.9)
Date:   Thu, 10 Nov 2022 12:06:02 +0530
Message-Id: <20221110063608.629732-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0175.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::31) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|PH0PR10MB4742:EE_
X-MS-Office365-Filtering-Correlation-Id: cf832642-17cf-4041-8ac8-08dac2e5de5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AsoIYdaJnEYr1Q/7PVpByvVDr4OicvUg7Mn3ElLOtPWrZFDfYd0aNm00i4BxzdMEuZtM+xXEbxh3Y/t1WzL119lFC8GAdiy0OV9Bq3Z3btWa+ncYZFmQquPbUFJlSBIEHLzLe26BU3tODwex0rDiErzjyLZkkqxHozYOzMLzmWNBspiS8v2nbwn2AKj4pQ+uoxA3+1/XNZdfPjHPcdCVxBaEFylnnmut5OZEczWNlMVOT9LGJTWyHzrxDpMsq7c9FGCqor49zIJTu7nFyuQtRKqzPqDGVn61SIKESvSZQ4GNS7QBlN5edusEH//vQelfEG/i+d7zeM/PpznX9KUQjeJUi6P98NS1oK8i24ztfOdOCx3s6JvSVK4OFcDF3ziqrMGfwNIkTothd5UaBxcICA8gjJo1wi28825dy3Y5jA+FzDg4uZnlwNcfzTYcl/+StmBmvU9WQxZl8s41J63iagHGqh3ISYe7nTYq7FczVA1TX5dPwCGX99y6LX0I+iMB2jnMPlR253YcSwpRGaob36yhg1QAZsxoAJg6ru5fjNYJ4yop2+6Pg1aaFdx1TwcKePHd1vrxH6Oce7YzKHgK5cqnZwix1ZHW2mw8sGNMJiVcNQ/LqhFza9GUQThfvmB+vz+/kq21EiVXwb4dOc2bxuxbOdVz2d/vp/sG83VOmj1tKfV0eEp0oUtwQrpvalXl7Df+sSQd6lWssTeuZaqMzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199015)(86362001)(36756003)(5660300002)(2906002)(8936002)(38100700002)(83380400001)(66556008)(186003)(26005)(6512007)(1076003)(6916009)(4326008)(2616005)(41300700001)(66946007)(66476007)(8676002)(316002)(6506007)(6666004)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V01UZjZqMkF6YkdzVC9vVTNGUHFRUzJITVVJME5PQ2Voczhpc2xnTms4N0Q3?=
 =?utf-8?B?eUw2Tnlka0Y2Y0R5RXI1SG05TkVFWnN5dEcwWnRERlNHV21FMDNicGdremJS?=
 =?utf-8?B?a3FZNjZ3VGxoMlM1amJSYmxJM3ZodDFIZmRpbDRVTVdQMzdCb0VMbnBwTXl2?=
 =?utf-8?B?TUhlV1R0MDJEcWFUbUd2dWsrSWtyUjVOcTM0N3hkQm1VY2lTdjJQSEVmc2xn?=
 =?utf-8?B?ZURzM2NpYlRkcmhFYzNhWjk4MW51NWVDaExkRElzbDlURzhjRmhIdnoydDdq?=
 =?utf-8?B?clVWdnZ0WjBQN3JPeXh0amdpQkxCMjBnOGFISTFJZ08wenEyVnJTbHRreWRX?=
 =?utf-8?B?bFpWVnhjcnJYbU5YRlhHYjl4NHN4eW9GejFQSWIwMzRmQkI4Q1lUa1dUVk43?=
 =?utf-8?B?RTNhUlZ2c3pVcmZOYUlDYXpjYlErS1RRNWtnaWRiN0cvRU9lUVhpaFRGZVFl?=
 =?utf-8?B?V3NZeG5TZDgvVDFMK3RwVFJVTVlMOFA1bEE4SkxSZGNaN2VBNG1WVEhCajdN?=
 =?utf-8?B?bXY0OWFlYVp3WGV4MU9lVWZlYjNZR0F2WkVYOFZEdk9JcFRzeUhsOTVENlZj?=
 =?utf-8?B?WmFMV0tBSEc0WFdEZmU0UkM3aWR4QmpZZzFQaVNZMEltMnZvb3NzTzFoc1F3?=
 =?utf-8?B?K3hvZnZtaW0rS3ZJWDV5cG41K3NNMC9NUlR0OXdZSzl6anNwbS9uS0dqVzdz?=
 =?utf-8?B?RmwweWNxM3YxVEVFSW45OE91dVd4OVpzbXZjRDBub204SHZiYXVDSVoyZzU4?=
 =?utf-8?B?R2luVG90YzVibjNwNFdudUlGMzBmcWI1dUFtNy96d2RKZnBpRDZNdFVTWTJl?=
 =?utf-8?B?WDJmeUx1K0xvZjlyMFZUY2QvM3FCNFVoNURKWFB1cWVzWmFiek5rcU5PZEox?=
 =?utf-8?B?TkxpTlBnR3ZURmxTOWtxYlJLaktST01YaHNVaGtDTy9TcTNjbjhUdjBxUzNH?=
 =?utf-8?B?a3lGeWkreWpoZmhYRFZiY1JUSEhFN2JhOVlXRXAzQXdLNkZ6WStuL0tTazlu?=
 =?utf-8?B?ZHR2ZmtVd3dWUTlPcUlnNmpKRUR5enJLLy9pQjgyS3FxR0Q4UCtTWkR4L016?=
 =?utf-8?B?cUVBUnJqRnY1ZDRjRmliVXZmalBRdzhtVk9xbGNUd0RlUFIwSTIxOVpLUGlt?=
 =?utf-8?B?dmtWRlJ4U1p1aENJM2JXeFVudFBkUTJBSlh6elFXV3U5N3VmNndWK21UajRO?=
 =?utf-8?B?b3M5NDR5MHFZaVk1aCtUcElVVTI3T2E3YUxuZVpqcUdqZSs5d0pFZDk0dDVR?=
 =?utf-8?B?Yk9TT2lpdS9iR2tUYmtzallnVmZucWF0dEJ0c1FlZ1ZYMFZJemtsUjZPaG1I?=
 =?utf-8?B?bXIyNmZZSGpxTVBYUEZVandpN0ZpeW9tWm1tamhrOFo1MHRGSXdYZEowM3Ev?=
 =?utf-8?B?WGhRYXBDbW5OVnlKbGtQMnRWZlpWYXk4T2hFSEVlTDJIVnNuRmliV2Yzd05O?=
 =?utf-8?B?d1FMVEpnR3EvL09kQWRkenJhRlJyWjRxakgzRmkybzNaa2tiVy9BdnhiemJz?=
 =?utf-8?B?ZmgyZUVyVk5hVUdNK0FNRVNJNVFDTkFpQWJHckd4OTJJOGN1Mjh6MjZCSzBS?=
 =?utf-8?B?d1pkbHhzc28zOE93eEV2aW1XQlhFOFBZeXVTbURUd2Y3REE1by82dWF0bGlm?=
 =?utf-8?B?Q2gwRFFxUmRtTlQ5NFErR1Q4WGVERk16Wk9SS0tXeS9DZjBPVzBYdXhNUTZp?=
 =?utf-8?B?RzJOUVZTQWtJQkdIWUlxMWVDd0R3UnA5SndKSEprWHhubXRsZkJra1VXQ2xU?=
 =?utf-8?B?aHhxN3FyRWVCSzhDNHhzR2paSFN3WGtzWTNnVkE2VlZ3aXczYUozNDhnY3NI?=
 =?utf-8?B?VEpOTVFDRXYwMEg3T2hyQmtIY2EyaXVvZWFaRVpVVWRRT213MjRwc3dBZVNo?=
 =?utf-8?B?MVFnOUZHQmpURExtR1d5ajByMFgwclFXeFlmRkZ6WDB0ODhQM29jb2o4dWcz?=
 =?utf-8?B?V0NEaHNJZjlheiszbE9qOXBBeGtUcVQ5YU5VY3hhL0lpNzNLVDhBaTZ0WkFD?=
 =?utf-8?B?blJuOEJ4Sk8zTzBBakxtdk8zT2twLzQ2TnRDQlhxNHc2a1Y0d29hdGZtbUN2?=
 =?utf-8?B?RFBaaFlwbFgvUXRTMkl4eVptczJZSjFsSS9VN1NrQWo1QVg3UlNZN0NIWk1U?=
 =?utf-8?Q?c7WwOqfZPt0SF7a7eZXe7wo+Q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf832642-17cf-4041-8ac8-08dac2e5de5b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 06:36:16.3009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I2x+4hq5+gJYmjFk2Hc5aIrRRW1uoPRxs3sRigYnBgUMEFLB2DxgZcFLrciHyjZBw0N4E8qxC/1kFkNbGKjeLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100048
X-Proofpoint-ORIG-GUID: Av2xvgdclirvAzsD7-m2qaJwS94hSVwB
X-Proofpoint-GUID: Av2xvgdclirvAzsD7-m2qaJwS94hSVwB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This 5.4.y backport series contains fixes from v5.9 release.

This patchset has been tested by executing fstests (via kdevops) using
the following XFS configurations,

1. No CRC (with 512 and 4k block size).
2. Reflink/Rmapbt (1k and 4k block size).
3. Reflink without Rmapbt.
4. External log device.

The following lists patches which required other dependency patches to
be included,
1. 00fd1d56dd08a
   xfs: redesign the reflink remap loop to fix blkres depletion crash
   - 877f58f53684
     xfs: rename xfs_bmap_is_real_extent to is_written_extent

Brian Foster (2):
  xfs: preserve rmapbt swapext block reservation from freed blocks
  xfs: drain the buf delwri queue before xfsaild idles

Darrick J. Wong (2):
  xfs: rename xfs_bmap_is_real_extent to is_written_extent
  xfs: redesign the reflink remap loop to fix blkres depletion crash

Dave Chinner (1):
  xfs: use MMAPLOCK around filemap_map_pages()

Eric Sandeen (1):
  xfs: preserve inode versioning across remounts

 fs/xfs/libxfs/xfs_bmap.h     |  15 ++-
 fs/xfs/libxfs/xfs_rtbitmap.c |   2 +-
 fs/xfs/libxfs/xfs_shared.h   |   1 +
 fs/xfs/xfs_bmap_util.c       |  18 +--
 fs/xfs/xfs_file.c            |  15 ++-
 fs/xfs/xfs_reflink.c         | 244 +++++++++++++++++++----------------
 fs/xfs/xfs_super.c           |   4 +
 fs/xfs/xfs_trace.h           |  52 +-------
 fs/xfs/xfs_trans.c           |  19 ++-
 fs/xfs/xfs_trans_ail.c       |  16 +--
 10 files changed, 198 insertions(+), 188 deletions(-)

-- 
2.35.1

