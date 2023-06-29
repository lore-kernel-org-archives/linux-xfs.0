Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D723CEB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 12:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjF2M1N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 08:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjF2M05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 08:26:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F223588
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 05:26:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35TAogx2005011;
        Thu, 29 Jun 2023 12:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=X/AM+8dg+GC0IIvp4oZu4ghv+HcQlhFCzrN4SoNImdk=;
 b=Ru4GgAjfWusiuL+sbmqVRxbWVBddWQH5QHs9EknuqRDX52Wq2L+DJPiGUkmSwvnY2iXl
 nmRMhBNovDwalkdIxVd6V5Sx5cAFQb33WQ9wJnxjRuj2hYvaSoD2Rhs7i72gUPzGobur
 1rA/Uxt+yopWWUUkAMQ7Ow6YVp0ebOS7fixAI/FQl4Cg5Y92CNznvXmAGhtd89CKoYBg
 y2s+T+cbcwrjvtrRxHiFLJoKm1ugJXV92VCzkxEm4XSe2AyLvqApWbf1HSI0Q491XSlA
 tdw7f5/4mDsoqEbFwi1CFBhuQUvzbr4fIRNiezLI/EzJni7H3O/cnHhbbcBuHPUnj8Hk FA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rdrcabmvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 12:26:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35TCNPbR038207;
        Thu, 29 Jun 2023 12:26:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rdpxdug36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 12:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0q9H7g7CtEN04NhF0353SQSnmrk8CxVWt5XAPhuBFIhGke7GKzP8OCp1+1uRjPgNQkFN8BIxI5MEYAHZ1D/vsM2Wms16hlQWSsFKWZ76STAgu1FBQraMILhZvI40/iv5wVnnvYvtYp/IlbZGVSKHTRGCsd3goPzoAv9kMilLQuudte8hta83M5zk85uy9iIZ8aYJw6h1uR+jpI836FOdjfrAp7+Js4Eo5MlCOHfWdlLzlAcRmTce1/tc7DzxPAJvLmAG2e+IV2wods9qv5QesFZypi+5LUsX964Gr8vD06QuY6h7OJRuVYTIbHPgZGnZzW1H6w4P4BKSPiqcCzBOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/AM+8dg+GC0IIvp4oZu4ghv+HcQlhFCzrN4SoNImdk=;
 b=Xs7r1ORl4IE2vZlqAdt5hf5PHkRlgx97FDaWcJQVzBsT6O6hotNT5S4Ej9iUy8UpOK5rpZHIUyMsU/d3FhmuU7rZ1OWw/4a9Zs4RxM6JZiRgwjo3xxBCSjvoVbGQC0nS1YpNrra9bPnKaalJuGdDDPP4W/kt6hB3aro4PDoV9fHT0cahSz2Akn/QsGdm+aF+ACYheI2RZDvvZdmNoO0lACsNBxlV3sDAapV0VGysL0m4i/E9Zl7Zs2jKT9g3HA9FdwX8GOi4l+mLZ7+pva6ZVRtkb7X3xypKNEMKNSfeklhuJ7B+NZfZPgg9o+FIHIfKL52yVC83/WNc9G1kAxMoXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/AM+8dg+GC0IIvp4oZu4ghv+HcQlhFCzrN4SoNImdk=;
 b=Feu8d+wrIeOBfrzH2i2DIZBfH1tkfhRTFmKqcZP8xkg6g5AXe/2kwySIailUm+lks6tEQpyjXnTMXROAiiW5TNvuS1BYwW9P1dOkx3Bi8N6IiaCnXnYi92G03kqRqYq3H6BZczkCH6sk240Mqzgpex3HJT5R32QSXRLfZjS859A=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB7717.namprd10.prod.outlook.com (2603:10b6:510:308::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 12:26:10 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17%6]) with mapi id 15.20.6521.024; Thu, 29 Jun 2023
 12:26:10 +0000
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-4-david@fromorbit.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Date:   Thu, 29 Jun 2023 15:14:00 +0530
In-reply-to: <20230627224412.2242198-4-david@fromorbit.com>
Message-ID: <875y761mli.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0098.apcprd03.prod.outlook.com
 (2603:1096:4:7c::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: c770f8ff-a5e8-43f7-77ea-08db789c0500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: omAILBZz/zikB734/Sh1PGtUTR5Vlx0fj4c11XSkMXie4arUAYoShEqfubtyVKzUOrLbdMYNp9FXxwbCy0fIkJK50uCPuGQS/9oI8b+ZiN8cVEkY1OtzrTxgBIKSuqfvIjOl0FwAHFrj50W9Swbr8EM9zBu0OlHXZXsEi+QgwBQT378n+ZYc+w/4uoFSCgZrfy002TcN9zhnVd1baDsTwKqaD7gLnVFMQKf8U/rfapLZJWYfg1bgG17TxhFTI2q9tAqruM50D3oZRC/cQWKGw2SApbOulutwmZbQ1nnc+rw7HPwTWIV+AbmQSbeRDVItNP84N99Lj7Drou+fbNKoSnRLfCwaJGIJMwxqOkIIERQpWJUV3k2OICLQ3o/hmIAYA0K/hz4iyGrR3d4SVYd2bkLeuVoMYEiR0LmMXwAF5S6P++vPsKvOerPPA4QyuCrI0wrlQ6ejWuKoU3+CNFQtWjWZP0DvYRbFtdJi7gaSzMPDbE6s8QGjbdtCGQNdUwTt8NHoz9BcAI+KlaUSY5CiUyTl5nZCMiJ+Z5wLx3K4KpjppqC3FTYqWS1cXDgrjkwe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199021)(9686003)(26005)(186003)(6512007)(53546011)(6506007)(83380400001)(6486002)(33716001)(5660300002)(8676002)(6666004)(38100700002)(8936002)(86362001)(478600001)(30864003)(2906002)(316002)(41300700001)(66946007)(4326008)(6916009)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ToIZbuPLJfG59GXSth0askyXCG9pegYrC59xRc3J3LmTX9WODgjHVYOiP0S?=
 =?us-ascii?Q?WPFIZSl1gnICNpPol8g2oVs+Q/lTGsfWopJpr6sAv5CrYaXt9JMFQdV2v5mM?=
 =?us-ascii?Q?RlX+7mjbUefMeIdDfnLTmSDme36YGT7m0MJdBi9rWzYMFbViLV1snx1kOL7B?=
 =?us-ascii?Q?A/ES6BeB25uohP2SYP9oKK7B8YbJ3JEVEXTCG7XQpEkj2u6b4I/ErdeN007X?=
 =?us-ascii?Q?gJpgkC9LvAhfg9KwsEuS+IuTk1EyZ9tl6l5uOwJVr8v9lIQo0AkEzxVA1kI0?=
 =?us-ascii?Q?z6vr8oo9RWyP/osWyo9fWNjv4wQxX7tbusN56/ekMEjyTCuisuRrf9SdPunV?=
 =?us-ascii?Q?C9Q7pp9qEb72dvYwVnjN1/0qevPbd5d8svbfkYKgSNKlova3+qagYpVDjWDL?=
 =?us-ascii?Q?0TWN+vCFMhjSMv3om9hwpp2j8dYGvzWBuqzQyARAZ6OQPf+bMYX/rqb6itrq?=
 =?us-ascii?Q?kU8jls3CFKgLrdG5K7Eb4acRzYFZB8bTT7CbvT7qZv/Z3eGY9CjjoS/vlrVM?=
 =?us-ascii?Q?JoROteCDdp7u3uMyUU1EiaQ2RKmbzls/a70gp16I5uJ1HB0KA012JFTlLUH/?=
 =?us-ascii?Q?yKb3s7hRdvCGxJ2YFq0ruePg1E0SgdqBUZy1SQ+nHPD4UMtM5yeBG3IdptDn?=
 =?us-ascii?Q?L5rpwpjKq5vEzUA9B+NXT+Ilb0/avI+LBYahBTeILTZz8KO3GmaftnGcqVT2?=
 =?us-ascii?Q?2vVimjFPJTsHFcxk3bp+Nwuevz8kT1xxzEdDqu/dyykUaYMbaT+QsNN8dvKZ?=
 =?us-ascii?Q?Unb8LeVVjvH+taYZjhl43VS3GvQJX7O9YY+gD2DD2oUTflPxO6FYDaPZ2mjX?=
 =?us-ascii?Q?EJyYkeRDTvMIob1beeAFuwdCuXntIieDDI+qwbLHnc/T5Y1R69rZwnmnLid3?=
 =?us-ascii?Q?fQzyfGCkaO0Dtk9A1XtuBDbsNRSSESIU56IYhfoqCn2StGAKNPBCNRa41MXn?=
 =?us-ascii?Q?4fVzljO4soKZhMaDEZJoN/HqANK+yOqN69o25R7eeBs7fBLHDALzuCiT81Di?=
 =?us-ascii?Q?h9p9jkRjU2l4nAJi1/BhnlJOwUK3fGg3yT425K1YpBTAsIEGmPAnBnOxpEUU?=
 =?us-ascii?Q?t07p7dwG7HN4SV01kMu5YKJCIE+xbU5/kANKle33/YrIiY6ySl4TmHOKhcZe?=
 =?us-ascii?Q?ZCPsIBQXbhBKH0LmWKzllxeJvz8jmlrdeI9KJYhwzmKLpk5zKhzEXyH/WftT?=
 =?us-ascii?Q?Fhba5Yha53K+nYNGVHNMgQiwzx0BAx0OTYGlQeE0eIp5McF16Lm6f6umgDX8?=
 =?us-ascii?Q?bxUGZ3DUuYIj+kMlIHF8qQpdUHbbMLi/rvv1HT4VyG7pLUW2vBDHT8979gLZ?=
 =?us-ascii?Q?xtystNKvZYyCNeHaICwcRwvZbayoJtZL3vkmS9XmzgW54MWN+lCvRpwD3PA2?=
 =?us-ascii?Q?RVfiLUnLcCGUtCHOO5j26CkZ3t7EeCtpxF1spLQgHJ0wd86WZJMc1T6LqmV0?=
 =?us-ascii?Q?Prh3DMePvLx+CBI+TvAdCI892Kks4VYgRReUZEKNLVOBb84RYpYhMneWH9C/?=
 =?us-ascii?Q?zFiD93Q4gJTVDu7Wug2X0ta+4Zg7trqanGwPE1A3LDhC9sFUSjcwvzMXPBEm?=
 =?us-ascii?Q?LiQ9i2bTX3895Dh2Do1wGOV1OG5rt6BBCBRtd9w9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MkW/cahqeIhdKgk4GZfwrsGYj2ERaVUsjg6ZD/mY/8lOzQNaylFeOH9AYLk3zHyiawF+dSxWZ75Ks/O56G7aBPLkXUXewIwzEKvN5z3r75Fx+cf4hiXFagPvgcS/VCenz/MjlpAWWnncHFOliJyMdGnigMUu6QvIzsVNdcLEXI5nD9NlofvEoyx/Rkd3YfPIKZ7rEGsOGnXwE/z8N/OpvvU6DCjhPy0o8nCiBL9ycoN3W+lrWaeo1MUGHTxyRoq8mzLDC5DR7jGT0Hx/toiITxDKvirLD2kq7vG8OgKQPq+6JrolnIUfad2zDecrgoEs2GS5m+vPjim+2rVNelMXtoFjqlFQjjCDzPxGpXqmYjNwO1bkt83VPlOs15MPjPZ5bIwlFCbKScrGSftnrMaN1BmA00wshtHir7VWmZLRk69S718o/aT+iOPr597eOZobILnkugHsD1ycYKHW7coZCnwoeTeQ6+oh9E/NfWnjyFaYs6kW4WUGMmHYS6Ff/HL7GM0D/lB1PjH7XVbNzXrKXk2PqcF+ZrvsMBYTQoq3nhS5KmXuf8x+7+tWMWwq69k3wnfH1EOKv3yTW6WZ+g4Or6KOaiC2160Q6fj/D/m3hXAXiKNRbXoLvF0fM89B+T8jla6EhAYbOuW/enizqhk7QgBOkEGhxDUc7eJfGsZonOVCmNioOl1Fh5xArAZmAWFK0tYf9/Rjkq6wQdpBnaxoW9s8RdduojVoMye+0xh/tDloLdbCYhhjLNDPysWodne3Gf6mg+E+h7OcO7Buhlzu+4tSWUjgealENZJ+IvehWVs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c770f8ff-a5e8-43f7-77ea-08db789c0500
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 12:26:09.9988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jz4/c5gl2duDVr37l4IO0lDrLa/WTGMWkejYQLmKEZFvITRD3R+U5oF50D09wHy5+fV6E51APG2I26arj2Tltg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-29_03,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306290111
X-Proofpoint-ORIG-GUID: hD65_3cE_vHYHXfALAWFutMsdPeU1_oQ
X-Proofpoint-GUID: hD65_3cE_vHYHXfALAWFutMsdPeU1_oQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:44:07 AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> To avoid blocking in xfs_extent_busy_flush() when freeing extents
> and the only busy extents are held by the current transaction, we
> need to pass the XFS_ALLOC_FLAG_FREEING flag context all the way
> into xfs_extent_busy_flush().
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 96 +++++++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_alloc.h |  2 +-
>  fs/xfs/xfs_extent_busy.c  |  3 +-
>  fs/xfs/xfs_extent_busy.h  |  2 +-
>  4 files changed, 56 insertions(+), 47 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index cc3f7b905ea1..ba929f6b5c9b 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1536,7 +1536,8 @@ xfs_alloc_ag_vextent_lastblock(
>   */
>  STATIC int
>  xfs_alloc_ag_vextent_near(
> -	struct xfs_alloc_arg	*args)
> +	struct xfs_alloc_arg	*args,
> +	uint32_t		alloc_flags)
>  {
>  	struct xfs_alloc_cur	acur = {};
>  	int			error;		/* error code */
> @@ -1612,7 +1613,7 @@ xfs_alloc_ag_vextent_near(
>  		if (acur.busy) {
>  			trace_xfs_alloc_near_busy(args);
>  			xfs_extent_busy_flush(args->mp, args->pag,
> -					      acur.busy_gen);
> +					      acur.busy_gen, alloc_flags);
>  			goto restart;
>  		}
>  		trace_xfs_alloc_size_neither(args);
> @@ -1635,21 +1636,22 @@ xfs_alloc_ag_vextent_near(
>   * and of the form k * prod + mod unless there's nothing that large.
>   * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
>   */
> -STATIC int				/* error */
> +static int
>  xfs_alloc_ag_vextent_size(
> -	xfs_alloc_arg_t	*args)		/* allocation argument structure */
> +	struct xfs_alloc_arg	*args,
> +	uint32_t		alloc_flags)
>  {
> -	struct xfs_agf	*agf = args->agbp->b_addr;
> -	struct xfs_btree_cur *bno_cur;	/* cursor for bno btree */
> -	struct xfs_btree_cur *cnt_cur;	/* cursor for cnt btree */
> -	int		error;		/* error result */
> -	xfs_agblock_t	fbno;		/* start of found freespace */
> -	xfs_extlen_t	flen;		/* length of found freespace */
> -	int		i;		/* temp status variable */
> -	xfs_agblock_t	rbno;		/* returned block number */
> -	xfs_extlen_t	rlen;		/* length of returned extent */
> -	bool		busy;
> -	unsigned	busy_gen;
> +	struct xfs_agf		*agf = args->agbp->b_addr;
> +	struct xfs_btree_cur	*bno_cur;
> +	struct xfs_btree_cur	*cnt_cur;
> +	xfs_agblock_t		fbno;		/* start of found freespace */
> +	xfs_extlen_t		flen;		/* length of found freespace */
> +	xfs_agblock_t		rbno;		/* returned block number */
> +	xfs_extlen_t		rlen;		/* length of returned extent */
> +	bool			busy;
> +	unsigned		busy_gen;
> +	int			error;
> +	int			i;
>  
>  restart:
>  	/*
> @@ -1717,8 +1719,8 @@ xfs_alloc_ag_vextent_size(
>  				xfs_btree_del_cursor(cnt_cur,
>  						     XFS_BTREE_NOERROR);
>  				trace_xfs_alloc_size_busy(args);
> -				xfs_extent_busy_flush(args->mp,
> -							args->pag, busy_gen);
> +				xfs_extent_busy_flush(args->mp, args->pag,
> +						busy_gen, alloc_flags);
>  				goto restart;
>  			}
>  		}
> @@ -1802,7 +1804,8 @@ xfs_alloc_ag_vextent_size(
>  		if (busy) {
>  			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>  			trace_xfs_alloc_size_busy(args);
> -			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> +			xfs_extent_busy_flush(args->mp, args->pag, busy_gen,
> +					alloc_flags);
>  			goto restart;
>  		}
>  		goto out_nominleft;
> @@ -2572,7 +2575,7 @@ xfs_exact_minlen_extent_available(
>  int			/* error */
>  xfs_alloc_fix_freelist(
>  	struct xfs_alloc_arg	*args,	/* allocation argument structure */
> -	int			flags)	/* XFS_ALLOC_FLAG_... */
> +	uint32_t		alloc_flags)
>  {
>  	struct xfs_mount	*mp = args->mp;
>  	struct xfs_perag	*pag = args->pag;
> @@ -2588,7 +2591,7 @@ xfs_alloc_fix_freelist(
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  
>  	if (!xfs_perag_initialised_agf(pag)) {
> -		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
> +		error = xfs_alloc_read_agf(pag, tp, alloc_flags, &agbp);
>  		if (error) {
>  			/* Couldn't lock the AGF so skip this AG. */
>  			if (error == -EAGAIN)
> @@ -2604,13 +2607,13 @@ xfs_alloc_fix_freelist(
>  	 */
>  	if (xfs_perag_prefers_metadata(pag) &&
>  	    (args->datatype & XFS_ALLOC_USERDATA) &&
> -	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
> -		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> +	    (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK)) {
> +		ASSERT(!(alloc_flags & XFS_ALLOC_FLAG_FREEING));
>  		goto out_agbp_relse;
>  	}
>  
>  	need = xfs_alloc_min_freelist(mp, pag);
> -	if (!xfs_alloc_space_available(args, need, flags |
> +	if (!xfs_alloc_space_available(args, need, alloc_flags |
>  			XFS_ALLOC_FLAG_CHECK))
>  		goto out_agbp_relse;
>  
> @@ -2619,7 +2622,7 @@ xfs_alloc_fix_freelist(
>  	 * Can fail if we're not blocking on locks, and it's held.
>  	 */
>  	if (!agbp) {
> -		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
> +		error = xfs_alloc_read_agf(pag, tp, alloc_flags, &agbp);
>  		if (error) {
>  			/* Couldn't lock the AGF so skip this AG. */
>  			if (error == -EAGAIN)
> @@ -2634,7 +2637,7 @@ xfs_alloc_fix_freelist(
>  
>  	/* If there isn't enough total space or single-extent, reject it. */
>  	need = xfs_alloc_min_freelist(mp, pag);
> -	if (!xfs_alloc_space_available(args, need, flags))
> +	if (!xfs_alloc_space_available(args, need, alloc_flags))
>  		goto out_agbp_relse;
>  
>  #ifdef DEBUG
> @@ -2672,11 +2675,12 @@ xfs_alloc_fix_freelist(
>  	 */
>  	memset(&targs, 0, sizeof(targs));
>  	/* struct copy below */
> -	if (flags & XFS_ALLOC_FLAG_NORMAP)
> +	if (alloc_flags & XFS_ALLOC_FLAG_NORMAP)
>  		targs.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
>  	else
>  		targs.oinfo = XFS_RMAP_OINFO_AG;
> -	while (!(flags & XFS_ALLOC_FLAG_NOSHRINK) && pag->pagf_flcount > need) {
> +	while (!(alloc_flags & XFS_ALLOC_FLAG_NOSHRINK) &&
> +			pag->pagf_flcount > need) {
>  		error = xfs_alloc_get_freelist(pag, tp, agbp, &bno, 0);
>  		if (error)
>  			goto out_agbp_relse;
> @@ -2704,7 +2708,7 @@ xfs_alloc_fix_freelist(
>  		targs.resv = XFS_AG_RESV_AGFL;
>  
>  		/* Allocate as many blocks as possible at once. */
> -		error = xfs_alloc_ag_vextent_size(&targs);
> +		error = xfs_alloc_ag_vextent_size(&targs, alloc_flags);
>  		if (error)
>  			goto out_agflbp_relse;
>  
> @@ -2714,7 +2718,7 @@ xfs_alloc_fix_freelist(
>  		 * on a completely full ag.
>  		 */
>  		if (targs.agbno == NULLAGBLOCK) {
> -			if (flags & XFS_ALLOC_FLAG_FREEING)
> +			if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
>  				break;
>  			goto out_agflbp_relse;
>  		}
> @@ -3230,7 +3234,7 @@ xfs_alloc_vextent_check_args(
>  static int
>  xfs_alloc_vextent_prepare_ag(
>  	struct xfs_alloc_arg	*args,
> -	uint32_t		flags)
> +	uint32_t		alloc_flags)
>  {
>  	bool			need_pag = !args->pag;
>  	int			error;
> @@ -3239,7 +3243,7 @@ xfs_alloc_vextent_prepare_ag(
>  		args->pag = xfs_perag_get(args->mp, args->agno);
>  
>  	args->agbp = NULL;
> -	error = xfs_alloc_fix_freelist(args, flags);
> +	error = xfs_alloc_fix_freelist(args, alloc_flags);
>  	if (error) {
>  		trace_xfs_alloc_vextent_nofix(args);
>  		if (need_pag)
> @@ -3361,6 +3365,7 @@ xfs_alloc_vextent_this_ag(
>  {
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_agnumber_t		minimum_agno;
> +	uint32_t		alloc_flags = 0;
>  	int			error;
>  
>  	ASSERT(args->pag != NULL);
> @@ -3379,9 +3384,9 @@ xfs_alloc_vextent_this_ag(
>  		return error;
>  	}
>  
> -	error = xfs_alloc_vextent_prepare_ag(args, 0);
> +	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
>  	if (!error && args->agbp)
> -		error = xfs_alloc_ag_vextent_size(args);
> +		error = xfs_alloc_ag_vextent_size(args, alloc_flags);
>  
>  	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
>  }
> @@ -3410,20 +3415,20 @@ xfs_alloc_vextent_iterate_ags(
>  	xfs_agnumber_t		minimum_agno,
>  	xfs_agnumber_t		start_agno,
>  	xfs_agblock_t		target_agbno,
> -	uint32_t		flags)
> +	uint32_t		alloc_flags)
>  {
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_agnumber_t		restart_agno = minimum_agno;
>  	xfs_agnumber_t		agno;
>  	int			error = 0;
>  
> -	if (flags & XFS_ALLOC_FLAG_TRYLOCK)
> +	if (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK)
>  		restart_agno = 0;
>  restart:
>  	for_each_perag_wrap_range(mp, start_agno, restart_agno,
>  			mp->m_sb.sb_agcount, agno, args->pag) {
>  		args->agno = agno;
> -		error = xfs_alloc_vextent_prepare_ag(args, flags);
> +		error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
>  		if (error)
>  			break;
>  		if (!args->agbp) {
> @@ -3437,10 +3442,10 @@ xfs_alloc_vextent_iterate_ags(
>  		 */
>  		if (args->agno == start_agno && target_agbno) {
>  			args->agbno = target_agbno;
> -			error = xfs_alloc_ag_vextent_near(args);
> +			error = xfs_alloc_ag_vextent_near(args, alloc_flags);
>  		} else {
>  			args->agbno = 0;
> -			error = xfs_alloc_ag_vextent_size(args);
> +			error = xfs_alloc_ag_vextent_size(args, alloc_flags);
>  		}
>  		break;
>  	}
> @@ -3457,8 +3462,8 @@ xfs_alloc_vextent_iterate_ags(
>  	 * constraining flags by the caller, drop them and retry the allocation
>  	 * without any constraints being set.
>  	 */
> -	if (flags) {
> -		flags = 0;
> +	if (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK) {
> +		alloc_flags &= ~XFS_ALLOC_FLAG_TRYLOCK;
>  		restart_agno = minimum_agno;
>  		goto restart;
>  	}
> @@ -3486,6 +3491,7 @@ xfs_alloc_vextent_start_ag(
>  	xfs_agnumber_t		start_agno;
>  	xfs_agnumber_t		rotorstep = xfs_rotorstep;
>  	bool			bump_rotor = false;
> +	uint32_t		alloc_flags = XFS_ALLOC_FLAG_TRYLOCK;
>  	int			error;
>  
>  	ASSERT(args->pag == NULL);
> @@ -3512,7 +3518,7 @@ xfs_alloc_vextent_start_ag(
>  
>  	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
>  	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
> -			XFS_FSB_TO_AGBNO(mp, target), XFS_ALLOC_FLAG_TRYLOCK);
> +			XFS_FSB_TO_AGBNO(mp, target), alloc_flags);
>  
>  	if (bump_rotor) {
>  		if (args->agno == start_agno)
> @@ -3539,6 +3545,7 @@ xfs_alloc_vextent_first_ag(
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_agnumber_t		minimum_agno;
>  	xfs_agnumber_t		start_agno;
> +	uint32_t		alloc_flags = XFS_ALLOC_FLAG_TRYLOCK;
>  	int			error;
>  
>  	ASSERT(args->pag == NULL);
> @@ -3557,7 +3564,7 @@ xfs_alloc_vextent_first_ag(
>  
>  	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
>  	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
> -			XFS_FSB_TO_AGBNO(mp, target), 0);
> +			XFS_FSB_TO_AGBNO(mp, target), alloc_flags);
>  	return xfs_alloc_vextent_finish(args, minimum_agno, error, true);
>  }
>  
> @@ -3610,6 +3617,7 @@ xfs_alloc_vextent_near_bno(
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_agnumber_t		minimum_agno;
>  	bool			needs_perag = args->pag == NULL;
> +	uint32_t		alloc_flags = 0;
>  	int			error;
>  
>  	if (!needs_perag)
> @@ -3630,9 +3638,9 @@ xfs_alloc_vextent_near_bno(
>  	if (needs_perag)
>  		args->pag = xfs_perag_grab(mp, args->agno);
>  
> -	error = xfs_alloc_vextent_prepare_ag(args, 0);
> +	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
>  	if (!error && args->agbp)
> -		error = xfs_alloc_ag_vextent_near(args);
> +		error = xfs_alloc_ag_vextent_near(args, alloc_flags);
>  
>  	return xfs_alloc_vextent_finish(args, minimum_agno, error, needs_perag);
>  }
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 121faf1e11ad..50119ebaede9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -195,7 +195,7 @@ int xfs_alloc_read_agfl(struct xfs_perag *pag, struct xfs_trans *tp,
>  		struct xfs_buf **bpp);
>  int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
>  			struct xfs_buf *, struct xfs_owner_info *);
> -int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
> +int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, uint32_t alloc_flags);
>  int xfs_free_extent_fix_freelist(struct xfs_trans *tp, struct xfs_perag *pag,
>  		struct xfs_buf **agbp);
>  
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index f3d328e4a440..5f44936eae1c 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -571,7 +571,8 @@ void
>  xfs_extent_busy_flush(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
> -	unsigned		busy_gen)
> +	unsigned		busy_gen,
> +	uint32_t		alloc_flags)
>  {
>  	DEFINE_WAIT		(wait);
>  	int			error;
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index 4a118131059f..7a82c689bfa4 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -53,7 +53,7 @@ xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
>  
>  void
>  xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
> -	unsigned busy_gen);
> +	unsigned busy_gen, uint32_t alloc_flags);
>  
>  void
>  xfs_extent_busy_wait_all(struct xfs_mount *mp);


-- 
chandan
