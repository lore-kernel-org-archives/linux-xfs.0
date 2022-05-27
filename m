Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BADC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 06:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244634AbiE0GMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 02:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245362AbiE0GMm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 02:12:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F72B5DA57
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 23:12:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24R5iiBZ011997;
        Fri, 27 May 2022 06:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0sC/jb1WmCbjv4fu4665h8jAly1yYESSfXd8EiRHt0Q=;
 b=m2AuTmB/SRA12CyQiJdG5oZtd4iMeWILEceq+P9ie3BkNc7Puof8s2homA9Q6MjmiD3S
 7cTPNikVMFnLYuXK60ZQzK9grcSvdlmRU9L5yCBPp4mOytyhMFNXuwnu66zQkyn8DC0i
 E2Ga5g5BGTzTShzF2D3pfR0nrWTH5o/7sdBgTYja1e75uqvT0N4DDzuTtyJRs+/76Ji8
 NTq04AzHTgBe+Y0Sstkn653EQ85wti9uCImFCIw0BhvwNxYNNqjlT3byAbj2ApxWAA3Z
 BJYmP52/yJqzSKiEJ++cpdmtlH+QIUq0zbVNN0FNGrSLREPFbJHEv7m7qXN42bvJHbSP sw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tc6gwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 May 2022 06:12:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24R65dbx030965;
        Fri, 27 May 2022 06:12:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93ws5cug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 May 2022 06:12:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXor6F3sx4bXFn+lmy2aJ2XTRbOXKk9X0eHqo8DikBAa+II7ouYm3PFislhus3Tse8oDKv0Cj3InV0XRIC53izogM9hjb0RmaakBPNpi9KEj+GZ7MBEY0+R4Nr37SUMY2oVpk/yRR2m97lflwdr2kF06tthuyBI+uDlR85W4NBiaJCI2npcMes3gOwRgSRLA9dOeNBdno+H+YBQby+vtPGFSlbcOgSAvAV+qN8ZxjeSDqe4WYf92PR9YMaGxBncImr6P58vF+CyghXpNUg7A52X02TumCAxU3NnDWzYcrrIzrd2WRweC0AABfCJnRBaHltKTf1vj1fqWPQbQ4z0MDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0sC/jb1WmCbjv4fu4665h8jAly1yYESSfXd8EiRHt0Q=;
 b=WR9DBDz9OIFClvMrss/JUp3wyZMgUa2Hpf32s8zdssGBqcF+30+M7jjVwNgoEZ2xKRdQKQfA7iqsBDKilABW0xDaURyuyqLP1p8FXyy4it/jpLPAOKTLwb4QJkOgzlGY0My/Xet+SRmaPDYwLq8UTIn/IYG+tKmeNGZ+3s8kmWpr/lyHLumBmo3EOFLW5WJwACPy21wkuVeNJOPQ59crtlOiZLQyRk/2CckWKiRPV6r9mbmdgxyQH0uGOFrHoLsH6T8P9gCkDG5jGiYaB11R1h4eD8boX6XM94xWB+SJUoVH3L/5zIZ56KHkC6dudW79jl2J4Rmn+zb6bRHTqRmSYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sC/jb1WmCbjv4fu4665h8jAly1yYESSfXd8EiRHt0Q=;
 b=bFlreTlFL0XVoB6P7+f2jIauKKGT6oE/KTDb5KiTcbbRVSCo+PaJSjRdHNkk2i4zgeqpufNzpMkiOapEdcIpHte4JsPdUt8j9ZcNVRsrB3j+MqYT7VBn5/g+7cIh9H/UNloGbocpMiZ4YcZoqrra8m/kksLz0yK6xZw3DyPCavU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CY4PR1001MB2054.namprd10.prod.outlook.com (2603:10b6:910:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 27 May
 2022 06:12:24 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5293.015; Fri, 27 May 2022
 06:12:24 +0000
References: <20220523043441.394700-1-chandan.babu@oracle.com>
 <20220523083410.1159518-1-chandan.babu@oracle.com>
 <Yovuf/JZiMkJzot6@magnolia> <20220523230813.GV1098723@dread.disaster.area>
 <87v8tsmncq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Yo+xl0gEWL3Kr+q0@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH V1.1] xfs_repair: Search for conflicts in
 inode_tree_ptrs[] when processing uncertain inodes
Date:   Fri, 27 May 2022 11:21:00 +0530
In-reply-to: <Yo+xl0gEWL3Kr+q0@magnolia>
Message-ID: <87leunijwh.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:404:15::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0925699e-e6a6-4dcf-7ae8-08da3fa7dda8
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2054:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB205487D769F4610ADC1D4795F6D89@CY4PR1001MB2054.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gpgh8n6PJsyVWpTJ94Vl2vXcAl1ah2I/lccIwKcT5V5MMbvyPJv/VP9I32N5bJb+Fi+T/rYyKDkTGUWO5pOADQv11AsDQRP0+sqn6FuKLWFNtzKbgtJK0K8i61byDoZ/sI+ROb2+A2m8wuoi+fvBt4BN8eASDaJM3/EDvU/m6Nic1KI+uw2xhdFAOG8x2GURMwQzfXYiWnbOtbMQx1UlgvJ+uU9ZBjkvpRrN078pwpp90Ukoi02jNpv64SzrUAJwTbv9HsgOIADuEVH5HmGT8pLhJq9MQHnDryUajWwD85jOjbnaBC4o9hiZWftJi7hxNrTuEbPakV31oyv9tDZb3WvjgLcO4t+59mFLY5tIhWgFLP+5slCNvFtXrjEmm25w5JrpF9aueE7PIKMsdJpU8Kq9H2qzQ68ptkyVJLW8rPtqacW7cMIgBCQ/UQ1BrrEyH6rjyKgJanZakLiQnYZGgO5AWXEvDL99xGXRZPFj/a3kleFEFT6Fcv2/RkVInmy+uEXu/RhlYfzYhUp+AdyRG/x8kRur20nQQ7go2IL6YF87W5WFWzvCYtICrVlGZlL1lbujgmYcBsupKxhu+vHaTR5YKUbXAWkWjUrSQcQTJ/dSTqq/Qm0YrZ0gQ2NtxEOtvO6N3bFN4hPBr5PH7Z0hXOOW0wVSv13pQVQaCMFGr3EPZqe0yiTybFPgv3EWUqQVr7zxXZeUtazO+FF1co751w1ToQ5BtSS0ikmOSg4CZpX7m6fgSHVDp4qLRxE2YugoI+8gZXVtI7mryz4HKPIj4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(66556008)(6916009)(4326008)(186003)(66946007)(86362001)(6486002)(2906002)(8676002)(5660300002)(38350700002)(38100700002)(66476007)(8936002)(33716001)(26005)(53546011)(83380400001)(52116002)(6506007)(6666004)(508600001)(9686003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pLP2m1+wPivKc+nEBWud35JvDPDF4nA5kMx2+Y3hm16v4+LDxXrvcNmVD3MP?=
 =?us-ascii?Q?df0VzsjTQ3vVdCGN8NydeKY2dURQFhe0naB2ojMbsmzxnYTjePRe36A2/Zdu?=
 =?us-ascii?Q?RA1lbeXkf0Pi1lus0sRFwoIe087lcvAAAR9EmaHQCH8zQzphthjgw9d8tioo?=
 =?us-ascii?Q?i4aFXQS2DI+AVTKGCExgjiLuJQ4fjuXKvB56iOKr2eP/woB0ZYt7duf6gyOV?=
 =?us-ascii?Q?ftIGODF0ZuCKA+HqIhxv7GQSVB4nxKAALtAe3BabQFZiyqI3md4UbrAZptCE?=
 =?us-ascii?Q?oQqNvcMeKW4qMqaojhSHuRs3xSfFfDeEYGhNEz8KjAp29sCGociJ41qq25Oc?=
 =?us-ascii?Q?UqAnFb1kOhnks5IPNbpxg1hsMZIjFsRGKiipBZK/iBsUsDmFkBgw3mbXQLPo?=
 =?us-ascii?Q?H3kFX7c8cMnNiaom+T7nxjeYQgITMtCK1EUvENIb4p16nCm44FW+Do7j5Ixc?=
 =?us-ascii?Q?qlTErXaR/LpVV6DzSSEvnc45o8oVplL0OxRktuhLfkJoQkB0aemPbvFf/MSD?=
 =?us-ascii?Q?CD6wW3VtGivA6Mqu/ddcgOjNn5L6fMXdeIgQFJj+ZVXMe8a5KG85XGt+I6Qt?=
 =?us-ascii?Q?/VAK4OjK1lLb3DdYBA05wpVz5/qIzM/C2LGPjJDClFzsmWo+bGR1CkXf56vb?=
 =?us-ascii?Q?jF+WwCLVZNFq2RApXK4AYXwmNud6nECa4F7KB5d8uwE3ckDEtmaMjQKBrxO7?=
 =?us-ascii?Q?EkdbLM+qx2OQg/jSQEEWGsPFKeC4BT1nSDkYc5zr9t5BIMpGq+7Mwu+21Jwa?=
 =?us-ascii?Q?Dpc/C4HCUaUppz/X3t2BxAZt52sfDdNMN76XRp1mo4+PNPbqZoy58TDbdfRS?=
 =?us-ascii?Q?n1zHKNPSgRCADHnz2U/de7H69MZDHOOQSxv8JKShYbmGtCK9jTnz645x04WX?=
 =?us-ascii?Q?g71XOg3YHVdTkuGWAH1pR6Dk77sHEopg4yOQ1LyR0wqnz3o6sVAIOjbvvTrW?=
 =?us-ascii?Q?5p9Z8+ZGexcXBxxE4SFl2Z5nRCqwXRghSAIlS00PqKYkIMeOuCEL8jXyV28W?=
 =?us-ascii?Q?K89t55emSBZoF83qZAM21WK10Cs2BKQYEaSZlXaBnijcJCvj4EX0qN3hAR7a?=
 =?us-ascii?Q?zXiA3t1wdm/39QwAWsW+GPx9zrys9jnMDx6rRhKP1qJmZzLlpLbIe7UoZEKf?=
 =?us-ascii?Q?zde6Lf1SPMS1v5aWShPAnmE/MYcnZbqGI/Rlwosop1cMgsnuXF6rh+xHUJwo?=
 =?us-ascii?Q?EYrDc4cCAGJwgyPKZf1Etnk1OOU3wMfMf7pbvVRCKR8eqaFNpEFDzBqYvnET?=
 =?us-ascii?Q?Qrpbu7DXIlxVZKh4V1B2lHOpLXE1Nm7Uf18NH1EW3WU1E7yYs9dqmBXtWmyn?=
 =?us-ascii?Q?eWutw9bQQYkbsdUQpXJWlG+WDH0IK1JQhkQnkHfd7MVToOsi8bkhJg/XJTdz?=
 =?us-ascii?Q?GKEtfRdu5NKb1HOXQ0F8yEByzhz9dKnIR/STHZNnyzvJ31FWig3irBonE0+a?=
 =?us-ascii?Q?q+GzMHcmjN+0Ie44fC0pSZ7shvRV/Kp09Fbfzftc3dw5DaWTR6LDPTIfvnN7?=
 =?us-ascii?Q?LHE9nNDoiDZTyVg5Tjvc94AWxr9dD7JuClb9Vi5GxsbUr3Uv+i92N/8FVSb8?=
 =?us-ascii?Q?hbP00dqE3GaUC1u4vSMIHRECEvQiRoGRkpA7LmgC41yo2sdKgqeLtUfCuLqR?=
 =?us-ascii?Q?GZF0ZUnSIes8HS7wyRCKgEX4KbX+BxLbRCztCUoa+FfaiJp9rzzGFY/0arsX?=
 =?us-ascii?Q?oYkgB/Qzv9Fb2nQ8NzD89sFGMjAPHMcGEiroYXSfo0DwTfomY+WV1qsVgJoe?=
 =?us-ascii?Q?uleH2BCQRA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0925699e-e6a6-4dcf-7ae8-08da3fa7dda8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2022 06:12:24.0053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: htJ9sjqMqG0/NmwsDOHMQup6AFlmUR4LUK4EVXddjiZ+ftFs9mXHqK9P+Q2zO1+geKXV9dBDcq/EdJ3PSnRVOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2054
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-27_02:2022-05-25,2022-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205270030
X-Proofpoint-ORIG-GUID: FGr0a6dAtGQYFSHRglcMe08NnGp-UNUA
X-Proofpoint-GUID: FGr0a6dAtGQYFSHRglcMe08NnGp-UNUA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 09:57:59 AM -0700, Darrick J. Wong wrote:
> On Thu, May 26, 2022 at 05:34:41PM +0530, Chandan Babu R wrote:
>> On Tue, May 24, 2022 at 09:08:13 AM +1000, Dave Chinner wrote:
>> > On Mon, May 23, 2022 at 01:28:47PM -0700, Darrick J. Wong wrote:
>> >> On Mon, May 23, 2022 at 02:04:10PM +0530, Chandan Babu R wrote:
>> >> > When processing an uncertain inode chunk record, if we lose 2 blocks worth of
>> >> > inodes or 25% of the chunk, xfs_repair decides to ignore the chunk. Otherwise,
>> >> > xfs_repair adds a new chunk record to inode_tree_ptrs[agno], marking each
>> >> > inode as either free or used. However, before adding the new chunk record,
>> >> > xfs_repair has to check for the existance of a conflicting record.
>> >> > 
>> >> > The existing code incorrectly checks for the conflicting record in
>> >> > inode_uncertain_tree_ptrs[agno]. This check will succeed since the inode chunk
>> >> > record being processed was originally obtained from
>> >> > inode_uncertain_tree_ptrs[agno].
>> >> > 
>> >> > This commit fixes the bug by changing xfs_repair to search
>> >> > inode_tree_ptrs[agno] for conflicts.
>> >> 
>> >> Just out of curiosity -- how did you come across this bug?  I /think/ it
>> >> looks reasonable, but want to know more context...
>> >> 
>> >> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> >> > ---
>> >> > Changelog:
>> >> > V1 -> V1.1:
>> >> >    1. Fix commit message.
>> >> >    
>> >> >  repair/dino_chunks.c | 3 +--
>> >> >  1 file changed, 1 insertion(+), 2 deletions(-)
>> >> > 
>> >> > diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
>> >> > index 11b0eb5f..80c52a43 100644
>> >> > --- a/repair/dino_chunks.c
>> >> > +++ b/repair/dino_chunks.c
>> >> > @@ -229,8 +229,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>> >> >  		/*
>> >> >  		 * ok, put the record into the tree, if no conflict.
>> >> >  		 */
>> >> > -		if (find_uncertain_inode_rec(agno,
>> >> > -				XFS_AGB_TO_AGINO(mp, start_agbno)))
>> >> > +		if (find_inode_rec(mp, agno, XFS_AGB_TO_AGINO(mp, start_agbno)))
>> >> 
>> >> ...because the big question I have is: why not check both the certain
>> >> and the uncertain records for confliects?
>> >
>> > Yeah, that was my question, too.
>> 
>> I came across this issue while reading code in order to better understand
>> xfs_repair.
>> 
>> The following steps illustrate how the code flows from phase 2 and 3 of
>> xfs_repair.
>> 
>> During phase 2,
>> 1. Scan inobt records.
>> 2. For valid records, add corresponding entries to certain inode tree
>>    (i.e. inode_tree_ptrs[agno]).
>> 3. For suspect records (e.g. Inobt leaf blocks which have a CRC mismatch), add
>>    entries to uncertain inode tree (i.e. inode_uncertain_tree_ptrs[agno]).
>> 
>> Uncertain inode chunk records are processed at the beginning of Phase 3
>> (please refer to check_uncertain_aginodes()). We pick one inode chunk at a
>> time from the uncertain inode tree and verify each inode's ondisk contents. If
>> most of the chunk's inodes turn out to be valid, we would want to treat the
>> chunk's inodes as certain i.e. move them over to the certain inode tree.
>> 
>> Existing code would check for the presence of the inode chunk in the uncertain
>> inode tree and when such an entry is found, we skip further processing of the
>> inode chunk. Since the inode chunk was obtained from the uncertain inode tree
>> in the first place, this check succeeds and the code ended up ignoring
>> uncertain inodes which were actually valid inodes.
>> 
>> I think checking uncertain inode tree for conflicts is a programming error. We
>> should actually be checking only the certain inode tree for conflicts before
>> moving the inode chunk to certain inode tree.
>
> Oh, ok, so repair is walking the uncertain inode chunks to see if they
> really correspond to inodes.  Having decided that the chunk is good, the
> last little piece is to check that the uncertain chunk doesn't overlap
> with any of the known-good chunks, and if /that/ passes, repair moves
> the uncertain chunk to inode_tree_ptrs[]?  And therefore it makes no
> sense at all to compare one uncertain chunk against the rest of the
> uncertain chunks, because (a) that's where it just came from and

Here are the exact steps involved in processing inode chunks obtained from
uncertain inode chunk tree:
1. For each inode chunk in the uncertain inode chunk tree
   1.1. Verify inodes in the chunk.
   1.2. If most of the inodes in the chunk are found to be valid,
        1.2.1. If there are no overlapping inode chunks in the uncertain inode
               chunk tree.
               1.2.1.1. Add inode chunk to certain inode tree.
   1.3. Remove inode chunk from uncertain inode chunk tree.

The check in 1.2.1 is bound to fail since the inode chunk being processed was
obtained from the uncertain inode chunk tree and it continues to be there
until step 1.3 is executed.

This patch changes 1.2.1 to check for overlapping inode chunks in the certain
inode chunk tree.

> (b) we could discard any of the remaining uncertain chunks?
>
> If the answers are yes and yes, then:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>
> Though you might want to augment the commit message to include that last
> sentence about why it doesn't make sense to check the uncertain ichunk
> list, since that's where I tripped up. :/
>

I think I should will add the sequence of steps described above and the cause
of failure as part of the commit message.

>> I wrote the script
>> (https://gist.github.com/chandanr/5ad2da06a7863c2918ad793636537536) to
>> illustrate the problem. This script create an inobt with two fully populated
>> leaves. It then changes 2nd leaf's lsn value to cause a CRC check
>> failure. This causes phase 2 of xfs_repair to add inodes in the 2nd leaf to
>> uncertain inode tree.
>
> Looks like a reasonably good candidate for an fstest :)
>

Ok. I will create an fstest script and post it on fstests mailing list soon.

>> Without the fix provided by the patch, phase 3 will skip converting inodes
>> from the 2nd leaf into certain inodes and hence xfs_repair ends up trashing
>> these inodes.
>
> <nod>
>

-- 
chandan
