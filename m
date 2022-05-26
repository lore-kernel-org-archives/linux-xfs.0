Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0D3C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 13:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbiEZNcT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 09:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiEZNcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 09:32:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23BCD8096
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 06:32:17 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QAnHor012459;
        Thu, 26 May 2022 13:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/JkIVz51+iGsjMr5+cu1XrXsvLJCkTmPfQBB3LmbNEU=;
 b=npcHk2btIp08Uso78+4sOZAEh7QpoLqo7DqJqbm+oea+DKxDfAdSYNonUep61Rc0zQg4
 //47VeIXeQBGY3CBcVJ6RtjMR8e6BHnDQhy897Rd0Y9TEBVgNju5f5E7lMohXksjB90Q
 qgBVbOP2UJTmqcE5oZ9maiHONqcTCC0LgobKxWWbspm4WdfZdHwLBK9A1J6egkSn4SPh
 mcCUuE/mm9Ii2nyk26Ocd0bOiArBHw1rl2UILcCmJhGoeVL5ibWEWIhRurKo5JtXOSuo
 tY+PxFWAiDsRGXDeGRmS4zLwQpgBdpzGqpDE5wZoqAIIEjntR+DDtqc17tZE/OFlh2rG sA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tbvtvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 13:32:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24QDTevB033014;
        Thu, 26 May 2022 13:32:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93x1jdbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 13:32:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFQ9vTFOguhJtsPGDQ9Afu3EEzti07HSR6dUkBVuBRYhlJPqCdGdTJlH88xS12zIfoyWjoJIxgp8w6Dn0MJqrt8NBIJLi/vRQyDeiDUfUUFmYqz/X9pHlcPPZ7U1QjAZGD81DfNMC7brgqDXncUFIdNVYmmzqhZruMNJV2sYYpOAli4kcZwMO3GUxiwktQZ6Exz5ygKlK4FYjIWqepXcOMwWqM1quflgmtgwro2kIflnyKOH7HPcZXXjgs88tvj17RfrX+NAKdusYvjqI4VMUi/2QozCFsU+lDE1oM409gCaBPjrF0VwoGkq1JBquFMOjfvesNefw9RFJ/7YJjKvrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JkIVz51+iGsjMr5+cu1XrXsvLJCkTmPfQBB3LmbNEU=;
 b=oUkcyDVDtjS68n8KZzzGWYbJvCT6Zb9epzYnDl2yCRP4LDzkOjLOL+PFFHesUcDBGYl1T+6inBdBgJtuPTSt7KO1/DfmnEDti9aWaF29vPHNGgLjAj8HydRflt980tEQ48tXTAZNc+zY0V4Ft6ArhsA8w2GukpQkHSq29Njk7hdSbiARQBFjcxk5raAgXLr8EDdOteV9aSSZ3Bi7W+0Ud47RRAwoSyQPxzZeom+8X7N37xdTHzgBd9Z2P/LnOXlcJ8aCULsX/QCnVjrWU//qXFCdHW+5DZo/yE2r/ENOn0l8Txm7qzi6UGmALMHSVfkBqTcNyW3py3TPlL/P3INzdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JkIVz51+iGsjMr5+cu1XrXsvLJCkTmPfQBB3LmbNEU=;
 b=eG/+h6mBgZ5UyurgRuVqnY9LFA3IaGDGtmrf2KoQwUx1ytLti56Du7pTb/QnxhR0dju+uFoON0gU9EDb8wGeMFQhZ7sVAQwkgX2Q0HybHbXXRvQd/t9TeYjHK6ucAhtEZJxFWBPo1d1xvWFD2QxQX89r58CI+kAJUD4qcr1gSUk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CH2PR10MB4119.namprd10.prod.outlook.com (2603:10b6:610:ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 26 May
 2022 13:32:04 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Thu, 26 May 2022
 13:32:04 +0000
References: <20220523043441.394700-1-chandan.babu@oracle.com>
 <20220523083410.1159518-1-chandan.babu@oracle.com>
 <Yovuf/JZiMkJzot6@magnolia> <20220523230813.GV1098723@dread.disaster.area>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH V1.1] xfs_repair: Search for conflicts in
 inode_tree_ptrs[] when processing uncertain inodes
Date:   Thu, 26 May 2022 17:34:41 +0530
In-reply-to: <20220523230813.GV1098723@dread.disaster.area>
Message-ID: <87v8tsmncq.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0005.apcprd02.prod.outlook.com
 (2603:1096:3:17::17) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09fc837b-7300-4be4-6d53-08da3f1c1f26
X-MS-TrafficTypeDiagnostic: CH2PR10MB4119:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB41197653685CEC5B46139203F6D99@CH2PR10MB4119.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jL33mxbEAULgdogtIVbfT3ZJFzqDb9UxcFZTV9rZX++2oRIITViH0eYDbt+i5j88E/GFvrQkjm0xemHf4Hbn6Pe2NbeTodTxcctKdKrL+FOFt+RGMbDv9ASKo9lCtuW5UCWxXfS73N5pX3D6TpGBwhQ2woUFCT6kewcshdjRy8ej0mZxnhZlEjz8TFjp4gmEwqpQ1Lumf0Caz++3/+WioZX4KjLmIiC6m6jy5KHsqCMg1j6tsiweJBjhO2sewHWDWltFrnfLSpL4Di1xrGAMLwfAM6WKIVMj+REs9cf/L8j1uEJIlzzZm4wnsDPK56Te0mq9Qj+i3l9LzmEb4f9DDkhJMLP3415u7DpAoA1CjdNCh/UDo8siDgyPPboYsHQT+PfoygqJz/kfeC0DWQWefEFbS63fA82xAPfZndopCB47/FlB2act0s3OcVA2gw3zlWkmTGkMlEgbT9AQ2IRVHCo6dGdfYYA5Fgm8kr+lZBt/G52PFAf/quqKTcQUQWXJCij5F0s86b0JI8C8FzyV6LrLX/El5dzwiaPlkg7Q/tX14ySEnx8s7C2/5CO098v4oVt+NBb110i7mv4g1MAsGt15Nyx+W3KqKP+PoLq0hXnMyTjpl8ctU5sON3+qvkd0NuCitMnpeNQz0pQSGIuKHJof5+WV1pQ+N2ie5ZMQ8lUm4lBjSwd6LkciiRonFS1vfJYR8IlGBOCcRQWtI5GaTVfMXxiyxcaavev/8TMCzSW7SAhiTCGVDiAo+vVM6/PIh1Re4Z5Oxdk8u+Vh1TE1rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(66946007)(2906002)(316002)(66556008)(6916009)(6486002)(53546011)(9686003)(5660300002)(86362001)(8936002)(6512007)(8676002)(26005)(4326008)(66476007)(186003)(83380400001)(38350700002)(38100700002)(52116002)(6506007)(6666004)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Lhz1tUAZ+kwFilABxC9XNT/T1yFQMMxGcob5d57GXBg3iEDy/0BvHdTi6FK?=
 =?us-ascii?Q?2kQQCh640OppggI6XhUuqMNHaGn/N+U3wp8iMLJvIPh0BPbuuwXodSn2v1MZ?=
 =?us-ascii?Q?LidA2mw21AQV9L4CDm+8ZkyBNQiqmqxyKm2KdMsQBq+ksau/1007mCRO7IwL?=
 =?us-ascii?Q?0sPIzzsW3n3YMzE91jgzMQmy+ktBlepFOnKmmT2jH1ha3pH39MrL9SIfBerw?=
 =?us-ascii?Q?vfM5KC2kNlI7C3Lc54jR6zShhSzwpPhbYxqqIvPg+kArSgzoBbYROMKFFeT3?=
 =?us-ascii?Q?D6OYyDeD/a/kXIO5H/Y1/EpHhJZRzV9IknMDEnRZccfh2wrkuCJ6vSvYjliY?=
 =?us-ascii?Q?KF/EPOlFu2momp0FVYjGR7AlHx0mqOXZTlU/S32ZLggrzYMiPIGlZIFubTQ8?=
 =?us-ascii?Q?o7LYdJw92GWed/PiNlP7BGvOrkRW/vqs0qkzKZIVm0JfM6ID28BKqZIk7qp6?=
 =?us-ascii?Q?GFYxIhysmgD3G138HQt8ax3ZUr7WPXQ9zTBVW9ncg4cUVaHUcWk1WKn6vVPH?=
 =?us-ascii?Q?02+rKszI7wEIZiMAHrXONfPFpqOpuMOvaE9F6XFzfw500Eic2PoCgO1sAM0d?=
 =?us-ascii?Q?KGQJ3OHUj+t/PqBL06IHw1Z6GLZagJMSx1yESEJQMJLe/Vkp14LePwOtFvbj?=
 =?us-ascii?Q?IE/HMTQ683e0KC69HiAhRva7ZQ/gd2fjIASqRqBSSyWHBLWkNiKSMxZfaIJd?=
 =?us-ascii?Q?RI3pbQozEYq72em5ajnSCu2PDQMS9nknkSL4E9WNxz0pf6aWQpLaoWMJpLhO?=
 =?us-ascii?Q?wD9f8A1+IiSyDJnGEGFjAWDIrqQWYma1ytsVaiaQ05psqxPNhn0/UixQvriL?=
 =?us-ascii?Q?3Nt/BjFotxQG9LaKVIcADW7wfUlG7IUTIv6jkdBoR27+TjqFEAk7kiRU52UB?=
 =?us-ascii?Q?R0woFX5zG7aTFj7YZZq6HBx1Ee2lhj1VMnYqVFFhhmWB8P9eoyJIu/AAINaN?=
 =?us-ascii?Q?kTSHii+CM/2dbH/Cgxpii2wsHogD+5vTynhZxRMl2DlLV3KqZm1UOuXGeCa3?=
 =?us-ascii?Q?CtAMkNgT+793AizdePouvrhnfziyukGmeLnzXIf30B1FDMwkjcnvqDRmaF1x?=
 =?us-ascii?Q?SP30h1Or4Ts27zeUWJ91EaFemvjvHUzWgmhKOqsNdzhL9cva7mk0pCKb93xe?=
 =?us-ascii?Q?RcXg+/rhhp7PPDAduxTmuTa4KkBjwscq7fDdYus6oX9qG3SUwUwpgAHCS0UC?=
 =?us-ascii?Q?Fva84WQtHvthjalwIE2wLJgLuf2NwCvLLvQqbSBIBNZDFSAok66ic3PoXfAG?=
 =?us-ascii?Q?tn/8gM6tQA0zu9yEf4ahTPfqv4ApXYREGlGQ5ayXeR6pcuDYCybLs6R/BqKQ?=
 =?us-ascii?Q?p2jhVAitzIlBtKwkeq85XmlK1qrtTzZMrkwrEGJKCareZSc3kjOORGVey8gT?=
 =?us-ascii?Q?NAkIhu29hp3z0bAo/YfiXmiBsLPhhgXCvcZmE0pvmT1HMeFeCyNAxUmsHTWH?=
 =?us-ascii?Q?v7EuPFpeRiBB8bIU3iR/IcV/YRbnn+cVXCokSFlwM5EHu7VSW795I7xt5vjT?=
 =?us-ascii?Q?fQnbQSl/2IuJXpM+iJDgSPAD+zlRV3BxoHjzOPJerBkt5eyITfiLWjjc6Vdd?=
 =?us-ascii?Q?pbfrs+DJsjcg91Uhyd8Acvh8FXRCJ1JiMsmQAlTQ1NQtrVZSOzhyjNQzb6Du?=
 =?us-ascii?Q?0/3Yd4uWWFWqjqB/BhpOhz+JUMXIeygVqTQOG6rQobSx74w2RWsXZ1VxPhzS?=
 =?us-ascii?Q?WQPQUlbHhk0wFt6007lJE/8girNm848oVq/5wkibH9/DvlS9aF+FIVoAx1zS?=
 =?us-ascii?Q?xLmWCdsxl0UpQdq0npuEebO98oaGR+g=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09fc837b-7300-4be4-6d53-08da3f1c1f26
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 13:32:04.4810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7rLYgfC9xNokm8mLvfKJ29fIpMQtjqhjPi1KO5H4Aghtdh/+7oudq+7X5DdQVW6YC/HUI4CBcKBcIIzSIbuVAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4119
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-26_05:2022-05-25,2022-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205260066
X-Proofpoint-GUID: Hcq4WpkYenp5-Rh-MW6P_sZ94w7kJKHc
X-Proofpoint-ORIG-GUID: Hcq4WpkYenp5-Rh-MW6P_sZ94w7kJKHc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 09:08:13 AM +1000, Dave Chinner wrote:
> On Mon, May 23, 2022 at 01:28:47PM -0700, Darrick J. Wong wrote:
>> On Mon, May 23, 2022 at 02:04:10PM +0530, Chandan Babu R wrote:
>> > When processing an uncertain inode chunk record, if we lose 2 blocks worth of
>> > inodes or 25% of the chunk, xfs_repair decides to ignore the chunk. Otherwise,
>> > xfs_repair adds a new chunk record to inode_tree_ptrs[agno], marking each
>> > inode as either free or used. However, before adding the new chunk record,
>> > xfs_repair has to check for the existance of a conflicting record.
>> > 
>> > The existing code incorrectly checks for the conflicting record in
>> > inode_uncertain_tree_ptrs[agno]. This check will succeed since the inode chunk
>> > record being processed was originally obtained from
>> > inode_uncertain_tree_ptrs[agno].
>> > 
>> > This commit fixes the bug by changing xfs_repair to search
>> > inode_tree_ptrs[agno] for conflicts.
>> 
>> Just out of curiosity -- how did you come across this bug?  I /think/ it
>> looks reasonable, but want to know more context...
>> 
>> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> > ---
>> > Changelog:
>> > V1 -> V1.1:
>> >    1. Fix commit message.
>> >    
>> >  repair/dino_chunks.c | 3 +--
>> >  1 file changed, 1 insertion(+), 2 deletions(-)
>> > 
>> > diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
>> > index 11b0eb5f..80c52a43 100644
>> > --- a/repair/dino_chunks.c
>> > +++ b/repair/dino_chunks.c
>> > @@ -229,8 +229,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>> >  		/*
>> >  		 * ok, put the record into the tree, if no conflict.
>> >  		 */
>> > -		if (find_uncertain_inode_rec(agno,
>> > -				XFS_AGB_TO_AGINO(mp, start_agbno)))
>> > +		if (find_inode_rec(mp, agno, XFS_AGB_TO_AGINO(mp, start_agbno)))
>> 
>> ...because the big question I have is: why not check both the certain
>> and the uncertain records for confliects?
>
> Yeah, that was my question, too.

I came across this issue while reading code in order to better understand
xfs_repair.

The following steps illustrate how the code flows from phase 2 and 3 of
xfs_repair.

During phase 2,
1. Scan inobt records.
2. For valid records, add corresponding entries to certain inode tree
   (i.e. inode_tree_ptrs[agno]).
3. For suspect records (e.g. Inobt leaf blocks which have a CRC mismatch), add
   entries to uncertain inode tree (i.e. inode_uncertain_tree_ptrs[agno]).

Uncertain inode chunk records are processed at the beginning of Phase 3
(please refer to check_uncertain_aginodes()). We pick one inode chunk at a
time from the uncertain inode tree and verify each inode's ondisk contents. If
most of the chunk's inodes turn out to be valid, we would want to treat the
chunk's inodes as certain i.e. move them over to the certain inode tree.

Existing code would check for the presence of the inode chunk in the uncertain
inode tree and when such an entry is found, we skip further processing of the
inode chunk. Since the inode chunk was obtained from the uncertain inode tree
in the first place, this check succeeds and the code ended up ignoring
uncertain inodes which were actually valid inodes.

I think checking uncertain inode tree for conflicts is a programming error. We
should actually be checking only the certain inode tree for conflicts before
moving the inode chunk to certain inode tree.

I wrote the script
(https://gist.github.com/chandanr/5ad2da06a7863c2918ad793636537536) to
illustrate the problem. This script create an inobt with two fully populated
leaves. It then changes 2nd leaf's lsn value to cause a CRC check
failure. This causes phase 2 of xfs_repair to add inodes in the 2nd leaf to
uncertain inode tree.

Without the fix provided by the patch, phase 3 will skip converting inodes
from the 2nd leaf into certain inodes and hence xfs_repair ends up trashing
these inodes.

>
> WHile I'm here, Chandan, a small patch admin note: tools like b4
> don't handle patch versions like "V1.1" properly.
>
> If you are replying in line with a new patch, just call it "V2" or
> "V3" - the version of the entire patchset (in the [PATCH 0/N V2]
> header) doesn't matter in this case, what matters is that it the
> second version of the patch in this thread. Us humans are smart
> enough to tell the difference between "series version" and "patch
> within series version", and it turns out if you use the right
> version formats the tools are smart enough, too. :)
>
> As such, b4 will automatically pick up the V2 patch as a newer
> version of the patch in the current series rather than miss it
> entirely because it doesn't understand the V1.1 version numbering
> you've used...

Sure, I will use integers for patch version numbers from now onwards.

-- 
chandan
