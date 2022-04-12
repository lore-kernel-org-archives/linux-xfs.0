Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D820C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 09:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbiDLKAn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376326AbiDLHn5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 03:43:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512DF45AC2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 00:27:16 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C7N3C9029074;
        Tue, 12 Apr 2022 07:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ZXC62a+h3VNBt0vsJ0znXBSHspGsAdfrz4LNtnFU6xM=;
 b=aH9ecTqiP0J7GHFIHz2VN5OyQEp6Bv1n32e+VUgOcYgX9jInkUTI9we3E4rwnY1VK+ng
 wOsVwNJ2UZrqxsxDm6uyW1IWWY6Nn/lKx7+rjnlHON83uL8jGZ2bQ5rwG9mC2wGMwEeE
 neGdQHrE085JU6BGgWJMssNPn+uKz1vE8GOel6GRF5fYOzkzkKz/2q+OKKLr1fNwLWTm
 INJ8cooSMVqPv8K1YyhEUmThaPDen7tUr75PrlK9zbXzBcbML4B2ZtgDuJmx5S4JBDv8
 AeLOynwZ1fCeK9m4r8cqJ9hJdZn9dcLKc6MWoWnGTBfrlJ+XndkZ2coYRpHz3MIUg0bv GA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rs5wue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:27:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C7RD6q014116;
        Tue, 12 Apr 2022 07:27:14 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k26nhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:27:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vu3Ifdx3WJjlksJdTcPosS7br4rmP1uYzkKt/PCGbRDdndwYPdNzqLb6fIhdaibF5wIhWoN6zXqtCsMH9PP1e81TWzcprvhtmZUUbsjHBm5pgAV0zfzLT87MPSIDZBwhmGod69KQe/X3BLdgpkPI49cXvbaQ4AydAIItL5/BY2AMEquceba0wI+p4sw6Gw5ilkaLavsteUW/fuLs+aqPGkIvYc5jRBonQ5V6XGzQuJRVYk0JmYjK/y+i8dES5/ahy3idBn8WClukJRhjBBWeTpT5aSUgk74moakZD2CanwxxNzxW09LHtKa/f++VQocihOb2xRcfF+vAIn/dnkSf3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXC62a+h3VNBt0vsJ0znXBSHspGsAdfrz4LNtnFU6xM=;
 b=UJ4tH3btjWk1FIQiMaaLKWdzT0n02QGqLn5XGo6r5d1U+CIPIodMEP/qNxjyh8lyy0ogiaYhH7Iyc+hYhAeGJZFho9G1qZFeb2yrWJDM+v8iUfTw1Anu8tHtEwC/lDbQysjz8498YNNDDzA61Vg+QD6vzbCtUe8nWS3Wrz7wIPyA4ZsB1GFgiz19q+dMiCy3ODrqPj2GHzQyV4zU3bWpPcrSB+VonIKLV8N3jBaBMNgGH7RrvrkYbEL+3lLk+XyOhleHEiRkcVTd9VXSBUEavuN5w/em/hG12kXBbDX0ej5Fw4NLtc3pywlnmqUOwQMEMQbmhov3e8MOJ5THuPfY2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXC62a+h3VNBt0vsJ0znXBSHspGsAdfrz4LNtnFU6xM=;
 b=zUbYmsxl3t0Qdy8u2VNCsIQ4XZ3xHdzaIq/w/xlYagGUWTRgo0NOvwk718DkZjAzES7P5YmAI25m1Enls5hBKjXiq0rQh1o/ymP3R2Vzzi8a3opWG2sNMjbPJtNvcA/1ANQS3khkpl4SCI90PW6fsxvOCmzPNLsAf+9b3IjOLQo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB3464.namprd10.prod.outlook.com (2603:10b6:a03:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:27:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 07:27:11 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-17-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/17] xfs: convert shutdown reasons to unsigned.
In-reply-to: <20220411003147.2104423-17-david@fromorbit.com>
Message-ID: <87mtgqzrqv.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 12 Apr 2022 12:57:04 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:194::15) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caffd598-848a-4495-ac78-08da1c55dc2e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3464:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB346416044D121EFF1B4BB23EF6ED9@BYAPR10MB3464.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJ71Q385CUVJAfmLdHv9C57hD5tJccTnA8jYlPYCvCF5QlM8PQs+AYAyx0trOCmJFOYI7azOm/cVk8BTIO+5w480MV92i8nY4UaqJNv4TjCU+uD6wuwAyvCiUWF2SMG0er4lYLaniGs3rPNy6FJLSgQZ/HydgefIab8nbQBoDGwm71Eg1CtCLLWE+9K8CSYG8GHPvIAw23HX4d0gx4DT3TVJ92pKdM97ShxnZNmVkavL2hsRRQ8PfXcXaAWDD/wIjnhupJUwk8hgk/tGRXUdMF4UBJqiv8XzsWrp9aU/+3NhMqAnRpGXJUUmPCWkp6N9UrJPdHd4xlAU6DsR63rw/Lc6ALqZZrXI1ciqENKC66hJcNh+wxPhMFGqWloQ2hsiD+9LRGQOQn9J8H2kiDBbRNfM2yiL0ueZl4znYJarv1jHSWk7zw1kcx9vB1hJ6at1q1UTReFf0Vr/ngg4b8/Y7ho9blLXCkVEHODrHXDFJjnROlvUfQ2jEWF43sOLUegrM4RFE+gJAuvDex9I0s3i8c6Ts4Ls4OWMtPvaEiw0NgQdbpKi698Fncn8K8SL61OJoshjU9nLiyuL21g0FHcXxTiwgZGU7YBDW8b7XAXYy2BzNdcpu5btaQXhx4IRkwkx0IYBsaS2bIPr65j08YK8+3wG7o1pEk5a0l/S/nAcpW6PizOdxxb+TU6d7r8f5iTXZaXlUaA0VekRupUBBqnwVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(53546011)(4326008)(5660300002)(2906002)(86362001)(33716001)(8936002)(38350700002)(38100700002)(6666004)(66556008)(6506007)(6512007)(26005)(186003)(83380400001)(8676002)(52116002)(9686003)(316002)(66476007)(6916009)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tMPU9q74HcTJBU2U0FiemvPEvZisz35m87jFkyLeV9Du57ZHj0duUzPJqTK4?=
 =?us-ascii?Q?5IH37rn96RFc171002PGiP2irEOwa/Y+besykEPyh6TLmRrVi6o5DyQDiABX?=
 =?us-ascii?Q?6aWRo+Ou/vC0pOPWMPzRSl/lT57uupVD0iA2MB4bsk51FcMLCD5fx5VxNvby?=
 =?us-ascii?Q?JDYq4NkdljPSoU0wmTt0VznsK9K7GG8I+ELQpH/E4QElkznY0YNnwcR6onUr?=
 =?us-ascii?Q?/+QxGmvM/oJbSDqMbfAf03C3mD9V6ecOL9tC3ZS1tegtn1Bjgh2c2tgu8LRn?=
 =?us-ascii?Q?FAnYT1fzjCVOZ99uewBWV7Rl9oi0EImQ9xu+jpxabal5VLVD6Fz1i7EP0Siy?=
 =?us-ascii?Q?Rc2nLG1Jr+B19gg4DdDGIRfM8s4S2V9hUz1IyPJcblQrbl89B0YZSs4blvEc?=
 =?us-ascii?Q?ryeqExwviosNnO7Kua93YAd3bnsyDukpjeD6wjjuKrIxnezux3wXNifRDKmr?=
 =?us-ascii?Q?CvdvSw7QoWYuVFZbvuaE/AlvuOCcKxWzcyOfzG37Yj6NtssShhTKIUm7v6xK?=
 =?us-ascii?Q?Lmva7ita3LkBbWcZB1z31DzHZyHJzERflpg5FMBO7i6BVseeAzf4FTnH5nGR?=
 =?us-ascii?Q?wtk8LFeT66d5JceoI3nzMd1DsLnKtSO0XDTKHolC8o8Qjbh23SMI7s+cd9dJ?=
 =?us-ascii?Q?Wrtd8j6er+LrQ8pr3UyghxS9fYNNhV3fLEiJt7yc7059Zq5T3InMajRDPB+Q?=
 =?us-ascii?Q?Z0nTAMLUdIEfnlItT4MryUq8tLOyMd3tg/xul8hbYQ6colei0SVAKRO4lvFX?=
 =?us-ascii?Q?2yRW1H+Edd5LLd3hatLHSeXcWJNvbEawd7GELELkcJSkwCtevpe3wvteEEYQ?=
 =?us-ascii?Q?4nnF7lYYrrxem/9M9dcR8qA9oGug/NwnqMl1pR/SJAgy0fpki8qWQL0sWgpM?=
 =?us-ascii?Q?Cmwn58bYj0oiLrNGI1UinJBPW1J74OcFH5UwNHpHzZE4nqmxxRL0rDlnnEbs?=
 =?us-ascii?Q?beZ6pz6vYmNSxtSpyG5LcdTI7N5HqjXZSKf0Zj82UZk6RU8RT3dthxtrX9R+?=
 =?us-ascii?Q?mkJGkJU5WB3mi6IYLx+Zz+s1UpCZRAzuayRshJ2YTCPLrK4cU9JQs95s8HMq?=
 =?us-ascii?Q?/U3Q/FbvZyus1lDKn986mJcbAUL2sRR4I0XqX4E/4mccykIfVXV778SyGMJD?=
 =?us-ascii?Q?6ZyTncATuac0O2B9bZ3CDr18XAT6jtZsQYQ2QtP88ouSYH7Mie73solLUR9z?=
 =?us-ascii?Q?DhBkJdKWhccbW1qUzkDVeCW6vMyEtNFH7XJdjoT09347jrroKy/qNkdYAaTo?=
 =?us-ascii?Q?SirxyGHp/ZkqBSrfwD4SBwPGFo3GnrUIwgyIfDm4reciopd7ZJIFJs51Uk+v?=
 =?us-ascii?Q?9QXJu/8WmINGqLusc249uVJFzQb1nGfnqxvcs6E0dkYpqiWmNTYm2J7QWBdP?=
 =?us-ascii?Q?rlbe9D/30mB/Cp8N10DM1An43B8f+g6Ghr1sXLy8qnZVm0mrA3x4CGrCV0Ct?=
 =?us-ascii?Q?DdS+Jjvm0Cnwlatr3rAkJWoifzmzSC2oWpLwEFSaOS7EOZ3/sHY1udxiexV/?=
 =?us-ascii?Q?Bn75eZ9a8Z1hsYysVXrrZrg+0kn8SdqJt6xVrvwZRmA5dwZbL/Tf1bFhbMDx?=
 =?us-ascii?Q?VKmOBpeg7lvkp2g3NCoBlugjihdwJ84azsQS2LB+cJSaw3G+OVx/Bju46NwM?=
 =?us-ascii?Q?ArDihKYXIxUkBQk06R6rtBmoQBOYLTjY4jJ9/0QdxhkDhPykzvGc+WyqJvl6?=
 =?us-ascii?Q?MISDK3cqfwWLUYiJFg96mJfGxFsJKZumqxWVxEW11pvxU6FBrYcnBOod6NoO?=
 =?us-ascii?Q?Zwjz76whDkV8aSU4ERppYHGh3J4LxF0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caffd598-848a-4495-ac78-08da1c55dc2e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 07:27:11.9139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FD3Nv6/WgUYWxE4eIulL0IIbj97W2KRg7UKa8wor5x7OBu6vdpQT89wIZFKAYzCOW0dZGrOqHRhviJtP2IMMKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3464
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_02:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120035
X-Proofpoint-ORIG-GUID: jNoIOwOYluWr_DvCoDShE6zfdAKHS4nT
X-Proofpoint-GUID: jNoIOwOYluWr_DvCoDShE6zfdAKHS4nT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c |  2 +-
>  fs/xfs/xfs_log.c   |  2 +-
>  fs/xfs/xfs_log.h   |  2 +-
>  fs/xfs/xfs_mount.h | 11 +++++------
>  4 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 68f74549fa22..e4cc6b7cae0f 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -512,7 +512,7 @@ xfs_fs_goingdown(
>  void
>  xfs_do_force_shutdown(
>  	struct xfs_mount *mp,
> -	int		flags,
> +	uint32_t	flags,
>  	char		*fname,
>  	int		lnnum)
>  {
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 499e15b24215..3c216140a1c4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3829,7 +3829,7 @@ xlog_verify_iclog(
>  bool
>  xlog_force_shutdown(
>  	struct xlog	*log,
> -	int		shutdown_flags)
> +	uint32_t	shutdown_flags)
>  {
>  	bool		log_error = (shutdown_flags & SHUTDOWN_LOG_IO_ERROR);
>  
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index dc1b77b92fc1..3ecf891f34c4 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -140,7 +140,7 @@ void	xfs_log_clean(struct xfs_mount *mp);
>  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
>  
>  xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
> -bool	  xlog_force_shutdown(struct xlog *log, int shutdown_flags);
> +bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
>  
>  void xlog_use_incompat_feat(struct xlog *log);
>  void xlog_drop_incompat_feat(struct xlog *log);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index f6dc19de8322..e5629e7c5aaf 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -425,16 +425,15 @@ __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
>  #define XFS_MAX_IO_LOG		30	/* 1G */
>  #define XFS_MIN_IO_LOG		PAGE_SHIFT
>  
> -#define xfs_is_shutdown(mp)		xfs_is_shutdown(mp)
> -void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
> +void xfs_do_force_shutdown(struct xfs_mount *mp, uint32_t flags, char *fname,
>  		int lnnum);
>  #define xfs_force_shutdown(m,f)	\
>  	xfs_do_force_shutdown(m, f, __FILE__, __LINE__)
>  
> -#define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
> -#define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
> -#define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
> -#define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
> +#define SHUTDOWN_META_IO_ERROR	(1u << 0) /* write attempt to metadata failed */
> +#define SHUTDOWN_LOG_IO_ERROR	(1u << 1) /* write attempt to the log failed */
> +#define SHUTDOWN_FORCE_UMOUNT	(1u << 2) /* shutdown from a forced unmount */
> +#define SHUTDOWN_CORRUPT_INCORE	(1u << 3) /* corrupt in-memory structures */
>  
>  #define XFS_SHUTDOWN_STRINGS \
>  	{ SHUTDOWN_META_IO_ERROR,	"metadata_io" }, \


-- 
chandan
