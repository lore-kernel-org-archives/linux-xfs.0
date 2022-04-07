Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF15C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 08:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiDGIV0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 04:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbiDGIVZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 04:21:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E93121E51F
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:19:26 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2378GgkT000752;
        Thu, 7 Apr 2022 08:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PYeBYCUVVbMJkNGqaYmykJf604zpAbzgu+Te4AB/KhM=;
 b=Itp7cgodcWNZMof+uErBWt8ebAZsYor56OKKJd3tVx/yeoWE1NEHWLJOXXcIONyN3AU4
 e7YTU/Uov2pNUTRD3XW+o6R/1JKD7eBwacs0wAYvjB6Bg0E80zKe7Ur3j+Dj0C6iYqfC
 ++ImqXBz7EK+smttqnL0ZxCLrzkM/1gQzduJM3NIrGAwersgEC+0f/lJ5P7eVQZOaGfY
 Uusl2ZMlMf8IfLT1dW1Vlshg9AcFbDbxAp7OcOm1qN6mLPHi1qtPPgw3Xn544ofU5Abi
 JguvSGR33kz6idMvU/kNAJMpZcubvStkLv747UG+TZb2kHlplWPELpQ8VowgtYw8WKVJ LQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3su508-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:19:22 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2378AksN025197;
        Thu, 7 Apr 2022 08:19:21 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97y78rm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:19:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1fROCZIrP1IvMUgEHZjVuuYRPLCGoHpu7thLq1QxqgFShueStjuNxB1UBNgukqYuwUZJwcn59uCxkTkpDclCelq6nQY3NM18hREWqmgct8pUKSNPljvDGBKCRvhNwt7dfRLasMj6N6VxZvauLobyWVP2Wml9+Zzu1dlGDqJe/DtiXJ8VBjIA5nxte3v+evvqZLvAmc5UBc0JNHmbUoY9McM1fds1Df/QIvEglAW7LyTlywEmn9/YFofKaPKv+fisE02F6bQtFfwRJextFpa39u0QMsT6b5TZ0ziVRk3ktON7P9DJmE+ynrJ3k6cSNZHAlj7SrTkfgCGrZ3LsLRTGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYeBYCUVVbMJkNGqaYmykJf604zpAbzgu+Te4AB/KhM=;
 b=FlEeU62nlXS6D2OoKhYI2v+96Hr4G2s4Qw57AXnVFT8B1SsbTtdLviAib0OYhwTOMoIXtGdcrnN1hvnSV2aGMA0nMV9ZrHoaXLUEUGoLdOSi/iHBpmIGZ9bO1G1aK03vUffTBPcvWzh7SHQ5os9JmVrO/fB8MP1PxRIUh96X8KaWaD2P6kvYFfBKzGRnydkTIh2rgjb+DzqKVMXrEP/r/k2hOaFmHawfAdsDoT0jqkVHTouZnuIAWXI66H+3Q6qtjOwH3olLzNATI+a4PGcXLn+iQa375vLWaZXbzeVI/ijJXwHrhSJQ0SBq0WgLdpM2LVQojhzGLPnF21eJ5U6dOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYeBYCUVVbMJkNGqaYmykJf604zpAbzgu+Te4AB/KhM=;
 b=Q9kaHfONrJqfstALZrHGZZIhHEVcyD2+fIwQDghYJIKQpSROqH2DmKFICdisj1syLg84cxCfIA8VhJtE7PXCUh1xiqILODRCB83XW5mIgdajUTcYO86313uzaiM9beQk7eGE0dr79rPOPFezqPI99enUcNC/DYpPigVUKuXN99M=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 08:19:19 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Thu, 7 Apr 2022
 08:19:19 +0000
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-16-chandan.babu@oracle.com>
 <20220407011311.GE1544202@dread.disaster.area>
 <20220407014828.GX27690@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V9 15/19] xfs: Directory's data fork extent counter can
 never overflow
In-reply-to: <20220407014828.GX27690@magnolia>
Message-ID: <87fsmpxq4f.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 07 Apr 2022 13:49:12 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:4:197::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb6f761e-78e6-4ceb-6703-08da186f5035
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5613064A6B76E7061061F1E6F6E69@SJ0PR10MB5613.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: exsENgFzKNzSNe3C1buUxGedJtOSSEmNxHGnO+N3PDFbyUqD+U0FGbqXWiGRnF836Ue6ttFQ4TNXzC/xKZCOs8gpnjqOgdBNx3dTyqyeqzDCiCgN+2TB6Q0EkIBxWvovJVWqPbaQuIvyzpwB9oAE/rupx55JoWtLIDOilSiVnErv/2+JkO7TP4hysYuJlgsFuB9ki8N0T5u1zYPLoDXQoGjqXV+A5xyi4vxq2TN0zbDRHhxDPYPOuE0JwOcxijNrJUGOumdVZp49tOgiCK36EUOPpPApRB71PQzQgBCAI9Mddo7G81f3OThgXO6dAZRTxUaTBHQ+Z02+oReJxxwe7O940lfzgd0SO4+ROuDDlRk+jxht2aQXmJR95Dcy8nFdae9Z0O0/xRGRkZI6eFfkbHh8tiD7u2N1EfhdLWogii9BBOwaxBgeJPYIn4u1jrOPCBP7306FZyU2/HI96/y8hDLk0N4XbY4PdDs7XqQ4GAxyojmkIPVmJK4qJCmDYDNn5/Q29IGQ7aV91ZOCecqwfZTcbVNx7Dpx7MFNKiD5fJZuU+Fc65UjsdFr859aDPftv3APNbqSx2UOPM/bw4S+Zk/WqciMKhIQl31mKKw1ZAt9hnudKtkP/ytNHk5uFZM9OXjOMfTNDK6dXbJpeX8Is/7d9uLK8r4RWbm7roiCVRwjFgD22haDW9nt9aYbJffT7V4GVOfmcgM1+NGEVxfV+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(6486002)(38350700002)(33716001)(508600001)(38100700002)(8936002)(5660300002)(2906002)(66556008)(4326008)(316002)(86362001)(9686003)(53546011)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6916009)(8676002)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xMnJzN73Mnmg3gE50jhobmNgaUyadGgmLXAYJS95nf7a5GhdyNQg5l1idktD?=
 =?us-ascii?Q?c3PxtsYJ5ZEyMVrkGSHbNkrtVnMbCqlQ3JxpO7P4jKrBRAU6ygh7qf+TwN9T?=
 =?us-ascii?Q?o8GUJ8unCVMIClSrB3L7bgz1AnMdLkRPgYPdgwZSE8GlxzERNncCD9qvC66d?=
 =?us-ascii?Q?mGoFCXkrF0heRFYhOIPeSjUyYFkKSYkzfYuZeubZ7LH9NdB9NU455oCZHqNr?=
 =?us-ascii?Q?I0/BxdXlCxs3jgOJxEpADT4m+qRxUQ+oKzwBZgh23iUhmwusIju+ENnrBfz8?=
 =?us-ascii?Q?fnJGonwN9E9uH/TSmuDuerjwX+1/VKs+gltIK3cnPuX6s88L/9MVd3YKz2xR?=
 =?us-ascii?Q?+n8IfvkA7Jpt42OSqehUTtHp9BdH59VjEiXkpQ7iTo/FqnMu5eroNt4s7xZN?=
 =?us-ascii?Q?mwomi51f6kez1xbLkL//l5DP+oGLizkKNif61gs8oH9Fbcg0oHn2jRB7nQiZ?=
 =?us-ascii?Q?31bJTi9dpshIU3/w2+QswUwk8taeCAm5LEb/YArULLMdr6vWk8DkZt5Fstjj?=
 =?us-ascii?Q?YaFB0coffUDNt0tRvlaCbQEpfDpnlgc/GN07zmXyN4atCd7taifazkZ3t/g3?=
 =?us-ascii?Q?ZGK/ccH5pNxFJ3+8opEC5kXaFCeMWN9eHZPPFwNFBxBGcuEBqBNFv5I+AkTs?=
 =?us-ascii?Q?V6FRBbU/xlP032zJ4AIfzPeYkHAsRkHGK7lvqAt97Ju5IkDmBXwoM5imQe+0?=
 =?us-ascii?Q?cp6TDtDEdPHjYMGnKuX6zOgNRAU9Io5xqWVKHDOT/lR2MxLzZVyw79xOOIcx?=
 =?us-ascii?Q?rC5d5Wm5ptjP4fgdPvhn0j5CWHiMNpzA70VoHOX5L6ibBJFQ0q7LZuQIv86l?=
 =?us-ascii?Q?UPu7Usx4tUezasXT7kzF/x2pQDxsLmPJrcewXmYH7zVPJOmiBfpQz5+Gnb0S?=
 =?us-ascii?Q?8jCLaRDdKpn0cRNCXtCCcvPtw9yYCCVfMBoW6WpC2r2MTldya8YkoWXTpwlK?=
 =?us-ascii?Q?lcPmwRl9VY5w2qCxAMzedSQWjkUFFC4OmrQIaB2cPTddwNBhhwQHOc1GAErv?=
 =?us-ascii?Q?qLfqjm4x5srYe3NeW9c454bESqJDxipurXBZLxftxSHc6n1BCfTWyeNhgXuI?=
 =?us-ascii?Q?oeFhHHqEvp+U3YPX4jBcELvol605ak9rkixRiwJTqiwdYV4AiQ/EUjpPbROn?=
 =?us-ascii?Q?INSP+hP0Ex4ru4ncP4gjGCm3wbTkeSxm7gbjv+yUa4tdSXI/jHlvXWJdkfw/?=
 =?us-ascii?Q?u8Io34IdgPXpz2vZHPy5OiHYukm3WwUGz9I3a8Kqis4Bu4Rv2y411jWssW2o?=
 =?us-ascii?Q?2dz/gNGHyWL3z/pgTf5xQd4xsfn1BF+M/o2QwuiDxvwWYt/z5LR6OJn7xC60?=
 =?us-ascii?Q?Rt4rN7ek17R7d45nonwC74VOTwWXFhT4d0FkqvzjHKJ89T4O5bGayotYhfSe?=
 =?us-ascii?Q?0Ayyw6yLdaix0eKT6UhL7Gi42ww48aJTqevPnnDx6oZZehKQDV77VJB8No7l?=
 =?us-ascii?Q?5Jm94rBmvHvDsd3B6sb3YF6PYGDpRwJV74ePxwpUSyE2o5QvaOKv75IZTTSy?=
 =?us-ascii?Q?Fi1zHtvsmI+xU8m1r3amRr9B3LfP7/bA4lYRZYCtkFTLf1Dg8LsLFDfXYMQy?=
 =?us-ascii?Q?qTOaOLbqWIOLbs46VkA0ARH4pCb91EzZLrJY1IU2nkdJGzLcFlH8WtAQlWUj?=
 =?us-ascii?Q?prClR0Tqwvul6ia4b9YAkBFu5FodCuE86pnylpyGd27JQ6Jf65ehiKCB3+3c?=
 =?us-ascii?Q?tkrQjZzdYhc9qGlO/Jx4dor5iKuGt5+I7M8t+WH+9mdqmcf0zGZ3qpO6WUEV?=
 =?us-ascii?Q?SV2I+S+bjoriqINuPvoYZUG/6Jxw8iw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb6f761e-78e6-4ceb-6703-08da186f5035
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:19:19.5271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkBTjvHJFvK+W1zLch0qW1y77d1FhWyfSNSxbJMHKzlvLzgLAXqWQpV3tKE4YcUA2BZPgAMHjhSY4Rxfxo6yjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070042
X-Proofpoint-ORIG-GUID: PsxtFeaQe9bXeO8V_5ChF3A-Au4Vey-p
X-Proofpoint-GUID: PsxtFeaQe9bXeO8V_5ChF3A-Au4Vey-p
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Apr 2022 at 07:18, Darrick J. Wong wrote:
> On Thu, Apr 07, 2022 at 11:13:11AM +1000, Dave Chinner wrote:
>> On Wed, Apr 06, 2022 at 11:48:59AM +0530, Chandan Babu R wrote:
>> > The maximum file size that can be represented by the data fork extent counter
>> > in the worst case occurs when all extents are 1 block in length and each block
>> > is 1KB in size.
>> > 
>> > With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
>> > 1KB sized blocks, a file can reach upto,
>> > (2^31) * 1KB = 2TB
>> > 
>> > This is much larger than the theoretical maximum size of a directory
>> > i.e. XFS_DIR2_SPACE_SIZE * 3 = ~96GB.
>> > 
>> > Since a directory's inode can never overflow its data fork extent counter,
>> > this commit removes all the overflow checks associated with
>> > it. xfs_dinode_verify() now performs a rough check to verify if a diretory's
>> > data fork is larger than 96GB.
>> > 
>> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> 
>> Mostly OK, just a simple cleanup needed.
>> 
>> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> > index ee8d4eb7d048..54b106ae77e1 100644
>> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> > @@ -491,6 +491,15 @@ xfs_dinode_verify(
>> >  	if (mode && nextents + naextents > nblocks)
>> >  		return __this_address;
>> >  
>> > +	if (S_ISDIR(mode)) {
>> > +		uint64_t	max_dfork_nexts;
>> > +
>> > +		max_dfork_nexts = (XFS_DIR2_MAX_SPACES * XFS_DIR2_SPACE_SIZE) >>
>> > +					mp->m_sb.sb_blocklog;
>> > +		if (nextents > max_dfork_nexts)
>> > +			return __this_address;
>> > +	}
>> 
>> max_dfork_nexts for a directory is a constant that should be
>> calculated at mount time via xfs_da_mount() and stored in the
>> mp->m_dir_geo structure. Then this code simple becomes:
>> 
>> 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
>> 		return __this_address;
>
> I have the same comment as Dave, FWIW. :)
>

Ok. I will apply the above suggestion.

-- 
chandan
