Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8220AC00140
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Aug 2022 09:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiHEJx7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Aug 2022 05:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbiHEJx6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Aug 2022 05:53:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA72205EA
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 02:53:56 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2759hvaC017308;
        Fri, 5 Aug 2022 09:53:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=KP5BA8BPvDp0xrteurAxU1VF0VBUADw2gHwJLjY9U5w=;
 b=wbdgrx4mdCo2RgXq1g4moqQW9MA6MwYrf3lDmloufoGjUPOMPx1m1lJY5sfArTtEgx7b
 REC4p8kuGeAD6TAuH8R4dDDuCDX25GueDBDc+KrBqy00oHpDH3kUFfLBIQfRSoTkFM5n
 35+LaXFE3zvza/FygQ5cZMFylGe1kUgOMrBnv+IlPrg+JYZ7e5/OW5b8eP5oJ48lZl5r
 vGutnEF2o/maqIWIwQbSKAFlipBR0KAKM8pVhaL2cKnSNRBocpQbp1QGehEExaL1l94c
 FgRwv+Ogc6rXLQ7g78YPgtojtkTRUrTzbYj6qGL90Zraafvs9xhztqHbnXC0U2ptr1mX 3g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2cf0f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 09:53:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2756T5P1007406;
        Fri, 5 Aug 2022 09:53:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34xhvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 09:53:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIlLT6Vl9H6hfSgBPEhzcA+N6hCy52hTzg2en2gy2LlMZr0bGqlv2XxmHkdsrff8E6cYCSgIN5i6UU+CNOsRTstOc0hlAmNStlhDYqXWih2mbfxgBny/a1R5DTl4VkwKWLJjoNzcXlWA+ON80OFK6TDstPkgyHCrwEnCgKGexC+yha9PVVW265YywaFYY0inlWxPWgOWuWIHoc+lNOVq1hsKDvDRmLr0TIutefu0T7VVFsK0rumCw8edcAOXVKJRGuY7nfV1IiSa/T0LOkeKWryvA7ucidFPDXu0pUPmMONaDAmI8njP1cIYqs20oiCVPaONwKFEtQGDU18kx4uobQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KP5BA8BPvDp0xrteurAxU1VF0VBUADw2gHwJLjY9U5w=;
 b=GmM315YBtGUA4X8fcmkF6rBKC2XqrdLk3Eq6JKVXo2rpKHKqckHl4ZeNl/Nf/peTiSq2HaFyc+0vyR4EpVHSU7oTvReP6leuz9w0RnjMmTe7r2p6/nrXksBD02vZNsL3L8vZOuGeevgldPLpR+aVNx4g0b3pk7F/iLz+lSY3WzGWS0HZIJOsW/7QcskXQzPWrz/B4XJJtwC26OeWExWyc5CNL0/OTA5Z+lKXbjmUky0r5ixWZdcM+0vb43eOZWv1u+UOBKpJvoEQIY7h/SDIwBfr8YBFrK4md2Hb9plTTuP3P85aDLGMX/+HA53QTScM27iIAp4GBKNVMGCaGPYPTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KP5BA8BPvDp0xrteurAxU1VF0VBUADw2gHwJLjY9U5w=;
 b=T9BRkZ08AIHfW3zTzbodBzq/geScKqxx8SREIdztKtG0ryx94m7rsBAhbQAYwts8SdQSs3zvu5Ts0DQTjnDVEROsDayVfCJC6gpHDMB2XJTeE2qc93Iuy4ugsGpRBnBq5T/ji67TxavpX4RK1UfVE4hhTeIpnIYIea2ouNXuYYQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CH2PR10MB3893.namprd10.prod.outlook.com (2603:10b6:610:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 09:53:42 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f84c:c30b:6d3e:d3e4]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f84c:c30b:6d3e:d3e4%4]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 09:53:42 +0000
References: <20220713073057.1098781-1-chandan.babu@oracle.com>
 <20220713104551.1704084-1-chandan.babu@oracle.com>
 <YuwDTcZbq0lrOlUL@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: [PATCH V2] xfs: Fix false ENOSPC when performing direct write
 on a delalloc extent in cow fork
Date:   Fri, 05 Aug 2022 14:09:37 +0530
In-reply-to: <YuwDTcZbq0lrOlUL@magnolia>
Message-ID: <87tu6rf23m.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0057.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::21) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c369187-c5b0-4723-c2f6-08da76c860d4
X-MS-TrafficTypeDiagnostic: CH2PR10MB3893:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ihDmq56WEckF5xhP30cE57Gr+7+J7S/t021cd1+PhSrvMkblCA3cD2O7HYIuB5QsxTTYHTX4PvJ5R0XnUZx06ERU+uk8EWRyid1gxR8ZhxaUkU0kM+b8vmsSJ6Ushuawul5esxI8rHxahOq9e4Ay/DIaBFgl/5ke1x0ilHFfSBy0qhA6u/81VNRYDQTl3ENvdDPlintjoccQz82DijeYGsUwXTHs4/Hf9qSX2nKV1CuI5xg/IgBq8J+Xy/+nKnliD1OjprMCR28adIZpIyDEw4p/7XKdoe8DA8JRmFfCzeCswnKZ2LMgxtkCJdYxxvPnS+NI3PTpbNSRhuE4rO845YJQlc2Ya16O87EOeC3MQFM2Dtp5vdxxKl9fGQEFoEnQfMJ2uV2XfM49aCrSoANtezGEUn2b0K+g4so2mEBvm7COMt1ckGxX+eghAHozUedSW7UJeENY4kJyoSjDjLC6HYs7CCJQrh3F0R9P9gGGYN+xTudOE0/UbIW2/qOG+NW3pbRWBRAQ9kZh2CFDQoNN0fkQWD3bIBdqQs9NP/8DHX5luOIv/qLkUIH9h+8pm4L5NpwMrl6M2dkhZzdgLEFIjftYs168vl3FVs+1Z8NOGiTnMqJ0Vjt7haDaqqJ6g+ViPuuY5q8w/TUqBhmtkHZEXog522XV2qBeu1l1IsEsIHQTZr9B82y57UFcSVMK6IiHVsyzRrO+NFUywP4PkCDbAELVaHEYhzj2GiNJzY04nU7moHmiq0jYTfuUUEUahaf7R8bZgInL6oDh13engWggyCFez8GD0oXUcIEBNPmowO0ny9Nm2lL+wwtGhBknWYplUxJr5sP0SRWDrETUe1DGNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(346002)(39860400002)(396003)(376002)(136003)(9686003)(107886003)(6916009)(186003)(8676002)(316002)(6512007)(4326008)(66946007)(66476007)(30864003)(86362001)(26005)(33716001)(41300700001)(478600001)(6666004)(52116002)(6506007)(8936002)(66556008)(5660300002)(38100700002)(2906002)(53546011)(83380400001)(6486002)(38350700002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AMKK0YU2qwwQbz1v7Z7lPVtleKCImxmthL++QmBlghaRD+a36YcBzvIgh4Pe?=
 =?us-ascii?Q?WXWfHdm8p/XWl2gh6TnqeFHDLM5nqnIQzzHyNaz9LB+tlfG90AEEQyb1x2M4?=
 =?us-ascii?Q?ty4hHOM5GuJPE6k+Nwg3HO7KtDle7nv+DOXgoTpqE8kHF9x3EbKcG7k/EQh+?=
 =?us-ascii?Q?PjrWtA4Ukgvd4ldVbKi2jX1CuW/mImKLRM5tSNMP9zdlGq7os4r3E98THSEp?=
 =?us-ascii?Q?Kh9+BXYpWM3jkeHIHTH4s/Z0tOFbhJm2g3U5hGhboTFUdGctsqaCY1JHYFGx?=
 =?us-ascii?Q?U3IhqMRwibKRJoUwGye5S9FovhYpkAYj4TeUWMwey8o8CuFo/qdmQBswbSq8?=
 =?us-ascii?Q?n2BtYz51tpdoMoD5GzP5uhOP6oWYMbm7nxkyLW/IvAdzl1GC0pcscasBisrS?=
 =?us-ascii?Q?Ltlm0K92F0WF/ug3tLgMRjsAtNZbf1Lfo/nfSck8a0abkOKMfpyE8p/b0dLa?=
 =?us-ascii?Q?NV0YgrEKdILhq7PMK92LA49QOuHigTlNgJo7MzTrBoIpgr1XjHQim6HBnl7t?=
 =?us-ascii?Q?YoSKxIJm3ZPJFupweg8RCrfkVpH0pfgDoecZaD1fHCZ1EGquDpWiYQ+S68So?=
 =?us-ascii?Q?yrEVIkpK/R/NyQL3H6QpTv+ibstlqrTo0kHWZDZs1DHbc8ej/rbtG0QjwYWq?=
 =?us-ascii?Q?mzP+Xxwhik+A16gbZ1rlREYGiyawXjLA6XV/2YrSXJfRqYZT9B6ixhTLl8cM?=
 =?us-ascii?Q?4TC8oW+GzP2mhidHkrh3j9oO5vBTo1pGe857wwrEhHiq4/H0hH5udawk1PT7?=
 =?us-ascii?Q?ZeA211DXsxz2s4kNwh29wIalA0dIlB46ODSAj7bJ1Z818B8eJbRUoe4ZJUQL?=
 =?us-ascii?Q?PDLxFGb0bxEBB6y+iAdt6yNlqKoVy+HJS6wPyQtP9sEm4/zsFOIeUGsBmiTF?=
 =?us-ascii?Q?4nHpON8/z8Bc8LsHDAnLNYYsxoQDwbHwwMM6uL1O5vCS0uUxbyK6Y1qdD8P2?=
 =?us-ascii?Q?K/ddbW4VyozM/W6SINY1G8UObU3pIoP3Ucfo2T2C6qVr10WT2EuSp2fjC62X?=
 =?us-ascii?Q?rEph2y0iJEjEakyQ7fTykkrTDHqW/n9eJySC5XzHYeb8TXLew7a4CZmhRr0M?=
 =?us-ascii?Q?9pNyXo/luc5fbxKt4EXzg9kK+SR+tax2fNNXG9CA+65DEMkwMs6vIEmwZkji?=
 =?us-ascii?Q?wUOdyM6zBqcd8IqI5hXKyv5tOAr6uoYibf944MxUMaYSSjGZAelhY/GBn9LU?=
 =?us-ascii?Q?pqztFKosVMuMBlVjSXahtpHtHMYQa+iNDvoHwYxGduRMVNCtsOl25Doi3bnN?=
 =?us-ascii?Q?H3ogUW/b6cwdZ47yKXv3pTdRwDejBI0wGlFrgqhxRBEiwlttKw8k80awt4q2?=
 =?us-ascii?Q?+KxopeO3l3bJ6sgggmAcHChLDQ9dNgFkM3MkUOquHFZn8w3vN3ri0xb2Nix8?=
 =?us-ascii?Q?+k3ggJR9z1MvGV8shbC2MUTwLT6FAwoGb45dlbLuU+qy0qkWRBKyvvN8UBCo?=
 =?us-ascii?Q?er8fAhwM2uZ1+PdkK8QiideT55O9IUk9LuQZvuFSFdfw95eoshb952TVVqKv?=
 =?us-ascii?Q?m5HK+ILOGIAhQn4oUFjsvxw0Pip3hGfjzquoLuTOZnRwsotG6VWB/kDjQM7B?=
 =?us-ascii?Q?qCTPXtJjNv5x3eeHoSPN08lxoWt5CN4073AFhbvQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c369187-c5b0-4723-c2f6-08da76c860d4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 09:53:42.3313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+X5L14dWae6Myw5aGSDUpkOJ2gmZtwPODSjNkUPZCyNunodRJDJX/02Rl1Sjx5YJFMiy1fSFPxutuNFQi5bIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3893
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208050048
X-Proofpoint-GUID: u6XgzZEIq6x5keoW1hwOjgKNHe_jBuJv
X-Proofpoint-ORIG-GUID: u6XgzZEIq6x5keoW1hwOjgKNHe_jBuJv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 10:35:09 AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 13, 2022 at 04:15:51PM +0530, Chandan Babu R wrote:
>> On a higly fragmented filesystem a Direct IO write can fail with -ENOSPC error
>> even though the filesystem has sufficient number of free blocks.
>
> Oops, I totally didn't notice this patch.  Sorry about that. :(
>
>> This occurs if the file offset range on which the write operation is being
>> performed has a delalloc extent in the cow fork and this delalloc extent
>> begins much before the Direct IO range.
>> 
>> In such a scenario, xfs_reflink_allocate_cow() invokes xfs_bmapi_write() to
>> allocate the blocks mapped by the delalloc extent. The extent thus allocated
>> may not cover the beginning of file offset range on which the Direct IO write
>> was issued. Hence xfs_reflink_allocate_cow() ends up returning -ENOSPC.
>> 
>> The following script reliably recreates the bug described above.
>> 
>>   #!/usr/bin/bash
>> 
>>   device=/dev/loop0
>>   shortdev=$(basename $device)
>> 
>>   mntpnt=/mnt/
>>   file1=${mntpnt}/file1
>>   file2=${mntpnt}/file2
>>   fragmentedfile=${mntpnt}/fragmentedfile
>>   punchprog=/root/repos/xfstests-dev/src/punch-alternating
>> 
>>   errortag=/sys/fs/xfs/${shortdev}/errortag/bmap_alloc_minlen_extent
>> 
>>   umount $device > /dev/null 2>&1
>> 
>>   echo "Create FS"
>>   mkfs.xfs -f -m reflink=1 $device > /dev/null 2>&1
>>   if [[ $? != 0 ]]; then
>>   	echo "mkfs failed."
>>   	exit 1
>>   fi
>> 
>>   echo "Mount FS"
>>   mount $device $mntpnt > /dev/null 2>&1
>>   if [[ $? != 0 ]]; then
>>   	echo "mount failed."
>>   	exit 1
>>   fi
>> 
>>   echo "Create source file"
>>   xfs_io -f -c "pwrite 0 32M" $file1 > /dev/null 2>&1
>> 
>>   sync
>> 
>>   echo "Create Reflinked file"
>>   xfs_io -f -c "reflink $file1" $file2 &>/dev/null
>> 
>>   echo "Set cowextsize"
>>   xfs_io -c "cowextsize 16M" $file1 > /dev/null 2>&1
>> 
>>   echo "Fragment FS"
>>   xfs_io -f -c "pwrite 0 64M" $fragmentedfile > /dev/null 2>&1
>>   sync
>>   $punchprog $fragmentedfile
>> 
>>   echo "Allocate block sized extent from now onwards"
>>   echo -n 1 > $errortag
>> 
>>   echo "Create 16MiB delalloc extent in CoW fork"
>>   xfs_io -c "pwrite 0 4k" $file1 > /dev/null 2>&1
>> 
>>   sync
>> 
>>   echo "Direct I/O write at offset 12k"
>>   xfs_io -d -c "pwrite 12k 8k" $file1
>> 
>> This commit fixes the bug by invoking xfs_bmapi_write() in a loop until disk
>> blocks are allocated for atleast the starting file offset of the Direct IO
>> write range.
>> 
>> Fixes: 3c68d44a2b49 ("xfs: allocate direct I/O COW blocks in iomap_begin")
>> Reported-and-Root-caused-by: Wengang Wang <wen.gang.wang@oracle.com>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>> Changelog:
>>     V1 -> V2:
>>     1. Add Fixes tag.
>>     
>>  fs/xfs/xfs_reflink.c | 225 +++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 187 insertions(+), 38 deletions(-)
>> 
>> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
>> index e7a7c00d93be..ab7a39244920 100644
>> --- a/fs/xfs/xfs_reflink.c
>> +++ b/fs/xfs/xfs_reflink.c
>> @@ -340,9 +340,41 @@ xfs_find_trim_cow_extent(
>>  	return 0;
>>  }
>>  
>> -/* Allocate all CoW reservations covering a range of blocks in a file. */
>> -int
>> -xfs_reflink_allocate_cow(
>> +static int
>> +xfs_reflink_convert_unwritten(
>> +	struct xfs_inode	*ip,
>> +	struct xfs_bmbt_irec	*imap,
>> +	struct xfs_bmbt_irec	*cmap,
>> +	bool			convert_now)
>> +{
>> +	xfs_fileoff_t		offset_fsb = imap->br_startoff;
>> +	xfs_filblks_t		count_fsb = imap->br_blockcount;
>> +	int			error;
>> +
>> +	/*
>> +	 * cmap might larger than imap due to cowextsize hint.
>> +	 */
>> +	xfs_trim_extent(cmap, offset_fsb, count_fsb);
>> +
>> +	/*
>> +	 * COW fork extents are supposed to remain unwritten until we're ready
>> +	 * to initiate a disk write.  For direct I/O we are going to write the
>> +	 * data and need the conversion, but for buffered writes we're done.
>> +	 */
>> +	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
>> +		return 0;
>> +
>> +	trace_xfs_reflink_convert_cow(ip, cmap);
>> +
>> +	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
>> +	if (!error)
>> +		cmap->br_state = XFS_EXT_NORM;
>> +
>> +	return error;
>> +}
>> +
>> +static int
>> +xfs_reflink_alloc_cow_unwritten(
>
> Hmm.  If @convert_now is set, then upon successful return, cmap is a
> written extent, right?  I think a better name for this function is
> xfs_reflink_fill_cow_hole, since that's what it's doing.
>

I agree. I will rename the function.

>>  	struct xfs_inode	*ip,
>>  	struct xfs_bmbt_irec	*imap,
>>  	struct xfs_bmbt_irec	*cmap,
>> @@ -351,33 +383,17 @@ xfs_reflink_allocate_cow(
>>  	bool			convert_now)
>>  {
>>  	struct xfs_mount	*mp = ip->i_mount;
>> -	xfs_fileoff_t		offset_fsb = imap->br_startoff;
>> -	xfs_filblks_t		count_fsb = imap->br_blockcount;
>>  	struct xfs_trans	*tp;
>> -	int			nimaps, error = 0;
>> -	bool			found;
>>  	xfs_filblks_t		resaligned;
>> -	xfs_extlen_t		resblks = 0;
>> -
>> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>> -	if (!ip->i_cowfp) {
>> -		ASSERT(!xfs_is_reflink_inode(ip));
>> -		xfs_ifork_init_cow(ip);
>> -	}
>> -
>> -	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
>> -	if (error || !*shared)
>> -		return error;
>> -	if (found)
>> -		goto convert;
>> +	xfs_extlen_t		resblks;
>> +	int			nimaps;
>> +	int			error;
>> +	bool			found;
>>  
>>  	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
>>  		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
>>  	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
>>  
>> -	xfs_iunlock(ip, *lockmode);
>> -	*lockmode = 0;
>
> Hmmm.  This piece effectively moves to this function's caller, which
> means that the parent unlocks the inode and the child maybe relocks it.
> The ILOCK handling in this whole call chain is already confusing enough
> as we pass *lockmode around to avoid relocking ILOCK for an
> xfs_trans_alloc* error return; could we try to contain lock state
> cycling to single functions, please?
>
> IOWs, leave this hunk here and don't add it to xfs_reflink_allocate_cow.
> I'll have more to say about this in the delalloc conversion function
> below.
>

Yes, this makes the code much easier to read.

>> -
>>  	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
>>  			false, &tp);
>>  	if (error)
>> @@ -385,17 +401,17 @@ xfs_reflink_allocate_cow(
>>  
>>  	*lockmode = XFS_ILOCK_EXCL;
>>  
>> -	/*
>> -	 * Check for an overlapping extent again now that we dropped the ilock.
>> -	 */
>>  	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
>>  	if (error || !*shared)
>>  		goto out_trans_cancel;
>> +
>>  	if (found) {
>>  		xfs_trans_cancel(tp);
>>  		goto convert;
>>  	}
>>  
>> +	ASSERT(cmap->br_startoff > imap->br_startoff);
>> +
>>  	/* Allocate the entire reservation as unwritten blocks. */
>>  	nimaps = 1;
>>  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
>> @@ -415,19 +431,9 @@ xfs_reflink_allocate_cow(
>>  	 */
>>  	if (nimaps == 0)
>>  		return -ENOSPC;
>> +
>>  convert:
>> -	xfs_trim_extent(cmap, offset_fsb, count_fsb);
>> -	/*
>> -	 * COW fork extents are supposed to remain unwritten until we're ready
>> -	 * to initiate a disk write.  For direct I/O we are going to write the
>> -	 * data and need the conversion, but for buffered writes we're done.
>> -	 */
>> -	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
>> -		return 0;
>> -	trace_xfs_reflink_convert_cow(ip, cmap);
>> -	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
>> -	if (!error)
>> -		cmap->br_state = XFS_EXT_NORM;
>> +	error = xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
>>  	return error;
>
> Nit: "return xfs_reflink_convert_unwritten(...);"
>

Ok.

>>  
>>  out_trans_cancel:
>> @@ -435,6 +441,149 @@ xfs_reflink_allocate_cow(
>>  	return error;
>>  }
>>  
>> +static int
>> +xfs_replace_delalloc_cow_extent(
>
> This is a rather long name, which would get even longer if it were
> namespaced "xfs_reflink_*" like the rest of the functions in this file.
>
> How about xfs_reflink_fill_delalloc?
>

Yes, this is indeed better given that xfs_reflink_ has to prefixed to the
function name.


>> +	struct xfs_inode	*ip,
>> +	struct xfs_bmbt_irec	*imap,
>> +	struct xfs_bmbt_irec	*cmap,
>> +	bool			*shared,
>> +	uint			*lockmode,
>> +	bool			convert_now)
>> +{
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	struct xfs_trans	*tp;
>> +	int			nimaps;
>> +	int			error;
>> +	bool			found;
>> +
>> +	while (1) {
>> +		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, 0, 0,
>> +				false, &tp);
>> +		if (error)
>> +			return error;
>> +
>> +		*lockmode = XFS_ILOCK_EXCL;
>> +
>> +		error = xfs_find_trim_cow_extent(ip, imap, cmap, shared,
>> +						&found);
>> +		if (error || !*shared)
>> +			goto out_trans_cancel;
>> +
>> +		if (found) {
>> +			xfs_trans_cancel(tp);
>> +			goto convert;
>
> Question: If @found is true here, do we need to check that cmap covers
> at least one block of imap?  I /think/ the answer is "no", because @cmap
> will be set to whatever's in the cow fork at imap->br_startoff, and if
> it's a real extent (written or not) then there's no delalloc reservation
> to fill and we can move on to the next step.

Yes. You are right.

>
> Also: "break" instead of a goto?
>

Ok. I will replace goto statement with break.

>> +		}
>> +
>> +		ASSERT(isnullstartblock(cmap->br_startblock) ||
>> +			cmap->br_startblock == DELAYSTARTBLOCK);
>> +
>> +		/*
>> +		 * Replace delalloc reservation with an unwritten extent.
>> +		 */
>> +		nimaps = 1;
>> +		error = xfs_bmapi_write(tp, ip, cmap->br_startoff,
>> +			cmap->br_blockcount,
>> +			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, cmap,
>> +			&nimaps);
>
> Indenting here ^^^^ (two spaces for a continuation, please.)
>

Sorry about that.

>> +		if (error)
>> +			goto out_trans_cancel;
>> +
>> +		xfs_inode_set_cowblocks_tag(ip);
>> +		error = xfs_trans_commit(tp);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * Allocation succeeded but the requested range was not even partially
>> +		 * satisfied?  Bail out!
>> +		 */
>> +		if (nimaps == 0)
>> +			return -ENOSPC;
>> +
>> +		if (cmap->br_startoff + cmap->br_blockcount > imap->br_startoff)
>> +			break;
>> +
>> +		xfs_iunlock(ip, *lockmode);
>> +		*lockmode = 0;
>> +	}
>
> If the iunlock in xfs_reflink_allocate_cow were eliminated, then this
> whole loop could turn into:
>
> 	do {
> 		xfs_iunlock(...);
> 		xfs_trans_alloc_inode(...);
> 		/* stuff */
> 	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);
>
>> +
>> +convert:
>> +	error = xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
>> +	return error;
>
> return xfs_reflink_convert_unwritten(...);
>
>> +
>> +out_trans_cancel:
>> +	xfs_trans_cancel(tp);
>> +	return error;
>> +}
>> +
>> +
>> +/* Allocate all CoW reservations covering a range of blocks in a file. */
>> +int
>> +xfs_reflink_allocate_cow(
>> +	struct xfs_inode	*ip,
>> +	struct xfs_bmbt_irec	*imap,
>> +	struct xfs_bmbt_irec	*cmap,
>> +	bool			*shared,
>> +	uint			*lockmode,
>> +	bool			convert_now)
>> +{
>> +	int			error;
>> +	bool			found;
>> +
>> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>> +	if (!ip->i_cowfp) {
>> +		ASSERT(!xfs_is_reflink_inode(ip));
>> +		xfs_ifork_init_cow(ip);
>> +	}
>> +
>> +	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
>> +	if (error || !*shared)
>> +		return error;
>> +
>> +	/*
>> +	 * We have to deal with one of the following 2 cases,
>> +	 * 1. No extent in CoW fork and shared extent in Data fork.
>> +	 * 2. CoW fork has one of the following:
>> +	 *    - Unwritten/written extent in CoW fork.
>> +	 *    - Delalloc extent in CoW fork; An extent may or may not be present
>> +	 *      in the Data fork.
>> +	 */
>
> I think this comment is a bit redundant with the hunks below it.
>

I wanted the reader to get an overview about what is to expected from here
onwards. But I guess, you are right since each of the individual cases have a
comment explaining what is being performed.

>> +
>> +	if (found) {
>> +		/*
>> +		 * CoW fork has a real extent; Convert it to written if is an
>> +		 * unwritten extent.
>> +		 */
>> +		error = xfs_reflink_convert_unwritten(ip, imap, cmap,
>> +				convert_now);
>> +		return error;
>> +	}
>> +
>> +	xfs_iunlock(ip, *lockmode);
>> +	*lockmode = 0;
>
> Move this to xfs_reflink_alloc_cow_unwritten and
> xfs_replace_delalloc_cow_extent so that we're not unlocking in one
> function and relocking in another.
>

Ok.

>> +	if (cmap->br_startoff > imap->br_startoff) {
>> +		/*
>> +		 * CoW fork does not have an extent. Hence, allocate a real
>> +		 * extent in the CoW fork.
>> +		 */
>> +		error = xfs_reflink_alloc_cow_unwritten(ip, imap, cmap, shared,
>> +				lockmode, convert_now);
>> +	} else if (isnullstartblock(cmap->br_startblock) ||
>> +		cmap->br_startblock == DELAYSTARTBLOCK) {
>> +		/*
>> +		 * CoW fork has a delalloc extent. Replace it with a real
>> +		 * extent.
>> +		 */
>> +		error = xfs_replace_delalloc_cow_extent(ip, imap, cmap, shared,
>> +				lockmode, convert_now);
>
> Also, this would be a bit easier to read if each if case was its own:
>
> 	if (foo) {
> 		return XXX;
> 	}
> 	if (bar) {
> 		return YYY;
> 	}
>

I agree.

>> +	} else {
>> +		ASSERT(0);
>> +	}
>> +
>> +	return error;
>> +}
>> +
>>  /*
>>   * Cancel CoW reservations for some block range of an inode.
>>   *
>> -- 
>> 2.35.1
>> 
>
> How about this for a v2 patch?
>
> --D
>
> From: Chandan Babu R <chandan.babu@oracle.com>
> Subject: [PATCH] xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork
>
> On a higly fragmented filesystem a Direct IO write can fail with -ENOSPC error
> even though the filesystem has sufficient number of free blocks.
>
> This occurs if the file offset range on which the write operation is being
> performed has a delalloc extent in the cow fork and this delalloc extent
> begins much before the Direct IO range.
>
> In such a scenario, xfs_reflink_allocate_cow() invokes xfs_bmapi_write() to
> allocate the blocks mapped by the delalloc extent. The extent thus allocated
> may not cover the beginning of file offset range on which the Direct IO write
> was issued. Hence xfs_reflink_allocate_cow() ends up returning -ENOSPC.
>
> The following script reliably recreates the bug described above.
>
>   #!/usr/bin/bash
>
>   device=/dev/loop0
>   shortdev=$(basename $device)
>
>   mntpnt=/mnt/
>   file1=${mntpnt}/file1
>   file2=${mntpnt}/file2
>   fragmentedfile=${mntpnt}/fragmentedfile
>   punchprog=/root/repos/xfstests-dev/src/punch-alternating
>
>   errortag=/sys/fs/xfs/${shortdev}/errortag/bmap_alloc_minlen_extent
>
>   umount $device > /dev/null 2>&1
>
>   echo "Create FS"
>   mkfs.xfs -f -m reflink=1 $device > /dev/null 2>&1
>   if [[ $? != 0 ]]; then
>   	echo "mkfs failed."
>   	exit 1
>   fi
>
>   echo "Mount FS"
>   mount $device $mntpnt > /dev/null 2>&1
>   if [[ $? != 0 ]]; then
>   	echo "mount failed."
>   	exit 1
>   fi
>
>   echo "Create source file"
>   xfs_io -f -c "pwrite 0 32M" $file1 > /dev/null 2>&1
>
>   sync
>
>   echo "Create Reflinked file"
>   xfs_io -f -c "reflink $file1" $file2 &>/dev/null
>
>   echo "Set cowextsize"
>   xfs_io -c "cowextsize 16M" $file1 > /dev/null 2>&1
>
>   echo "Fragment FS"
>   xfs_io -f -c "pwrite 0 64M" $fragmentedfile > /dev/null 2>&1
>   sync
>   $punchprog $fragmentedfile
>
>   echo "Allocate block sized extent from now onwards"
>   echo -n 1 > $errortag
>
>   echo "Create 16MiB delalloc extent in CoW fork"
>   xfs_io -c "pwrite 0 4k" $file1 > /dev/null 2>&1
>
>   sync
>
>   echo "Direct I/O write at offset 12k"
>   xfs_io -d -c "pwrite 12k 8k" $file1
>
> This commit fixes the bug by invoking xfs_bmapi_write() in a loop until disk
> blocks are allocated for atleast the starting file offset of the Direct IO
> write range.
>
> Fixes: 3c68d44a2b49 ("xfs: allocate direct I/O COW blocks in iomap_begin")
> Reported-and-Root-caused-by: Wengang Wang <wen.gang.wang@oracle.com>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |  201 +++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 166 insertions(+), 35 deletions(-)
>
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 724806c7ce3e..b310cbaebe76 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -341,9 +341,41 @@ xfs_find_trim_cow_extent(
>  	return 0;
>  }
>  
> -/* Allocate all CoW reservations covering a range of blocks in a file. */
> -int
> -xfs_reflink_allocate_cow(
> +static int
> +xfs_reflink_convert_unwritten(
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*imap,
> +	struct xfs_bmbt_irec	*cmap,
> +	bool			convert_now)
> +{
> +	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> +	xfs_filblks_t		count_fsb = imap->br_blockcount;
> +	int			error;
> +
> +	/*
> +	 * cmap might larger than imap due to cowextsize hint.
> +	 */
> +	xfs_trim_extent(cmap, offset_fsb, count_fsb);
> +
> +	/*
> +	 * COW fork extents are supposed to remain unwritten until we're ready
> +	 * to initiate a disk write.  For direct I/O we are going to write the
> +	 * data and need the conversion, but for buffered writes we're done.
> +	 */
> +	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
> +		return 0;
> +
> +	trace_xfs_reflink_convert_cow(ip, cmap);
> +
> +	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
> +	if (!error)
> +		cmap->br_state = XFS_EXT_NORM;
> +
> +	return error;
> +}
> +
> +static int
> +xfs_reflink_fill_cow_hole(
>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*imap,
>  	struct xfs_bmbt_irec	*cmap,
> @@ -352,25 +384,12 @@ xfs_reflink_allocate_cow(
>  	bool			convert_now)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> -	xfs_filblks_t		count_fsb = imap->br_blockcount;
>  	struct xfs_trans	*tp;
> -	int			nimaps, error = 0;
> -	bool			found;
>  	xfs_filblks_t		resaligned;
> -	xfs_extlen_t		resblks = 0;
> -
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	if (!ip->i_cowfp) {
> -		ASSERT(!xfs_is_reflink_inode(ip));
> -		xfs_ifork_init_cow(ip);
> -	}
> -
> -	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
> -	if (error || !*shared)
> -		return error;
> -	if (found)
> -		goto convert;
> +	xfs_extlen_t		resblks;
> +	int			nimaps;
> +	int			error;
> +	bool			found;
>  
>  	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
>  		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
> @@ -386,17 +405,17 @@ xfs_reflink_allocate_cow(
>  
>  	*lockmode = XFS_ILOCK_EXCL;
>  
> -	/*
> -	 * Check for an overlapping extent again now that we dropped the ilock.
> -	 */
>  	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
>  	if (error || !*shared)
>  		goto out_trans_cancel;
> +
>  	if (found) {
>  		xfs_trans_cancel(tp);
>  		goto convert;
>  	}
>  
> +	ASSERT(cmap->br_startoff > imap->br_startoff);
> +
>  	/* Allocate the entire reservation as unwritten blocks. */
>  	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
> @@ -416,26 +435,138 @@ xfs_reflink_allocate_cow(
>  	 */
>  	if (nimaps == 0)
>  		return -ENOSPC;
> +
>  convert:
> -	xfs_trim_extent(cmap, offset_fsb, count_fsb);
> -	/*
> -	 * COW fork extents are supposed to remain unwritten until we're ready
> -	 * to initiate a disk write.  For direct I/O we are going to write the
> -	 * data and need the conversion, but for buffered writes we're done.
> -	 */
> -	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
> -		return 0;
> -	trace_xfs_reflink_convert_cow(ip, cmap);
> -	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
> -	if (!error)
> -		cmap->br_state = XFS_EXT_NORM;
> +	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
> +
> +out_trans_cancel:
> +	xfs_trans_cancel(tp);
>  	return error;
> +}
> +
> +static int
> +xfs_reflink_fill_delalloc(
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*imap,
> +	struct xfs_bmbt_irec	*cmap,
> +	bool			*shared,
> +	uint			*lockmode,
> +	bool			convert_now)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			nimaps;
> +	int			error;
> +	bool			found;
> +
> +	do {
> +		xfs_iunlock(ip, *lockmode);
> +		*lockmode = 0;
> +
> +		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, 0, 0,
> +				false, &tp);
> +		if (error)
> +			return error;
> +
> +		*lockmode = XFS_ILOCK_EXCL;
> +
> +		error = xfs_find_trim_cow_extent(ip, imap, cmap, shared,
> +				&found);
> +		if (error || !*shared)
> +			goto out_trans_cancel;
> +
> +		if (found) {
> +			xfs_trans_cancel(tp);
> +			break;
> +		}
> +
> +		ASSERT(isnullstartblock(cmap->br_startblock) ||
> +		       cmap->br_startblock == DELAYSTARTBLOCK);
> +
> +		/*
> +		 * Replace delalloc reservation with an unwritten extent.
> +		 */
> +		nimaps = 1;
> +		error = xfs_bmapi_write(tp, ip, cmap->br_startoff,
> +				cmap->br_blockcount,
> +				XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0,
> +				cmap, &nimaps);
> +		if (error)
> +			goto out_trans_cancel;
> +
> +		xfs_inode_set_cowblocks_tag(ip);
> +		error = xfs_trans_commit(tp);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Allocation succeeded but the requested range was not even
> +		 * partially satisfied?  Bail out!
> +		 */
> +		if (nimaps == 0)
> +			return -ENOSPC;
> +	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);
> +
> +	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
>  
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
>  
> +/* Allocate all CoW reservations covering a range of blocks in a file. */
> +int
> +xfs_reflink_allocate_cow(
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*imap,
> +	struct xfs_bmbt_irec	*cmap,
> +	bool			*shared,
> +	uint			*lockmode,
> +	bool			convert_now)
> +{
> +	int			error;
> +	bool			found;
> +
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	if (!ip->i_cowfp) {
> +		ASSERT(!xfs_is_reflink_inode(ip));
> +		xfs_ifork_init_cow(ip);
> +	}
> +
> +	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
> +	if (error || !*shared)
> +		return error;
> +
> +	if (found) {
> +		/* CoW fork has a real extent */
> +		return xfs_reflink_convert_unwritten(ip, imap, cmap,
> +				convert_now);
> +	}
> +
> +	if (cmap->br_startoff > imap->br_startoff) {
> +		/*
> +		 * CoW fork does not have an extent and data extent is shared.
> +		 * Hence, allocate a real extent in the CoW fork.
> +		 */
> +		return xfs_reflink_fill_cow_hole(ip, imap, cmap, shared,
> +				lockmode, convert_now);
> +	}
> +
> +	if (isnullstartblock(cmap->br_startblock) ||
> +	    cmap->br_startblock == DELAYSTARTBLOCK) {
> +		/*
> +		 * CoW fork has a delalloc reservation. Replace it with a real
> +		 * extent.  There may or may not be a data fork mapping.
> +		 */
> +		return xfs_reflink_fill_delalloc(ip, imap, cmap, shared,
> +				lockmode, convert_now);
> +	}
> +
> +	/* Shouldn't get here. */
> +	ASSERT(0);
> +	return -EFSCORRUPTED;
> +}
> +
>  /*
>   * Cancel CoW reservations for some block range of an inode.
>   *

Looks perfect!

Thanks for making the patch better.

-- 
chandan
