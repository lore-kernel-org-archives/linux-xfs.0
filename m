Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5F7C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Dec 2021 13:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbhLINsh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Dec 2021 08:48:37 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48748 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238054AbhLINsh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Dec 2021 08:48:37 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9DDxKe025550;
        Thu, 9 Dec 2021 13:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+tLqklh31JcKNZPCZYSZhBungwLqQp5rAuYh9k3/dp4=;
 b=aRjkvfvShnI35n+2UAn1KnisOgPjE/Tc+B16TPxmP8Ho1ur7Qzf7WcPVkzq7uotTjah3
 22xoAjqoGJmds9EbNrDlv7y5THp6wUCBPWxGdx3EqeQMG5MeC7tQcWSaaEQsUKvs3xA2
 NclSk8wLSErtkIwprLhNZlub/gOVH3edyuW5wRQLgoOxTcSMpIB92/brqV3bLjoLaTvb
 uZ+3b9L8YMo8LlwqyoL9u6x3GQL7hR+xXmyZukvauLbRhLhXrUmUiXECy18n7HZxiTSp
 HT9dUC4FHBJVgYMbD08lfSH8awY0UlN0u6UHXB0WIJUwcP6LP60tT3vcjnpRxU9by0T9 QA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctup532ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 13:44:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B9DZTCK038428;
        Thu, 9 Dec 2021 13:44:51 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by aserp3030.oracle.com with ESMTP id 3csc4w7ydj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 13:44:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eC00ZVsLzL0jJ4yEoSum6OiKJR/G7KzhP5ioy4QD6wahKDb0DVGpcY50DDbPu0UtVCldv+xAy4VwKLC/lMkilzoHwIAEabSiPXxQgm/J7sRIZ6psdJmIWLDr8gyf0Xkyqr7eAgghi6dEow0E2qJ0PTQ2w890ATRBU4b7w8cqvV/rcW3jTYAkLDNNZ0DVrlut19kvWsoMt0JjuLsL4G/l1XEYCKsQnQeQWKNeh7nIMsLSEG2isS/gLf7tTVdSkN25h7l5CcfkSkPLGLp8x1ZGLSyjQUvFCOgkJc8fJ6NGrccn/anBJyQhylhX3B5rK+KMg8aHslDWjMEV8KqtlV8hZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tLqklh31JcKNZPCZYSZhBungwLqQp5rAuYh9k3/dp4=;
 b=a7kaFTM0E7Z+YMcGjULb8wJR3WEVynVrX42+F/e3EnSLszPnv4l8w9Ur9LStgmyCuv4XE0mkoTtyp/fj0nOl5oyxAJ9PiMkKWhiHtna3FywZysBFN/2xwm8H0epXgxK/Ysy93EDPIWz/I4TdHDQ85sczMuXrQXMIz9oAS5vqdrFQtkTiMPWEdv26+u2Dl9rbCV0AbR4ElFpXeIF9YNuMvUZPXHlH9oYk/GWhH+1DQqcSyiC1SoprMRXULQY33+4JmzHuH+Q3jTyyW9PEs3LzfiWTkcxEB4/uBrgw0fiUZJyPYHQOYmRds1shibaVN+XtlWqIfHZyADinflrgWVZPJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tLqklh31JcKNZPCZYSZhBungwLqQp5rAuYh9k3/dp4=;
 b=OUyScWoWXgDdcTA3tA2Lp1KxlUTPjukWFJ5iIPvST2yogBUrXqW9NjretjW+vnmsXDMn3O985JUQ4u0YkGsIbd/ExUdhAbjNsg5jGzMz9OSrRSU7lfff18W8jCW5K2ccLsoyVGnZv0GhdxSmdzustMFzzhwikaDLS/bBT7a9B30=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4699.namprd10.prod.outlook.com (2603:10b6:806:118::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Thu, 9 Dec
 2021 13:44:50 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 13:44:50 +0000
References: <163900530491.374528.3847809977076817523.stgit@magnolia>
 <163900531080.374528.2313143590834038321.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, wen.gang.wang@oracle.com
Subject: Re: [PATCH 1/2] xfs: remove all COW fork extents when remounting
 readonly
In-reply-to: <163900531080.374528.2313143590834038321.stgit@magnolia>
Message-ID: <8735n1yjsn.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 09 Dec 2021 19:14:40 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0130.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.40) by TYAPR01CA0130.jpnprd01.prod.outlook.com (2603:1096:404:2d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 13:44:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d9566f0-731c-453c-6c95-08d9bb1a1222
X-MS-TrafficTypeDiagnostic: SA2PR10MB4699:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4699524F59FE48B644CF4CE7F6709@SA2PR10MB4699.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OE6oJ3Mzd8bhONqzmOucKmUkZq6OxWuy5Wby8pEnYWSiYTC5toDhaQC44Gd65doeMM0mEogtHS/gME16IFzoQfLHQwpOC3yLRAua92BUw9xE1YnvY71Nip/f0VCnDcq80XDwbTw1k2Z1y1KkjtnU8JW/dHHvU4ccpe56uLewotLfVVMgRHBP1ih8B8dmBTjE69s9FRhGYK2TIcTWn6L7/HaQ5Fqq4A2phm+Ix2yS9AsryhKIpfrF9Y4Lt8ZpCno2cwM1Zz4pZKJkKD/bZhkm3Uo32TZRT8Cy+EWD+MtpWiDQxDn+g+1NryAWGtwWTGhy3KHyJtwSgkhYH2DgDpdqqFZ6yxXO6AdbTW/qEUMVaR48t5lBQlOdLRj1NOQDPHk/RZ+sVzNBpZ475Yy5DYyHaR5d/bwMOrrPUo28I3B2P6shBqKf2DrfGsSfj2oxgP/5M55YnCSDh6lw/rauXysmIL5/gqMoeqnyL5cEc8GFGB7ky5OQ9yuQo9Henr3B9QNkv6qAetKNo9sllQSTMrnR1wqy9+dQWUyTPiOn/fTioElYl9y6Mx474ad0vvv2w5n27sQkoNIv2Ta2XxTXohk2Z+VdlUnrY80lj+NUTaeKVO17FRt8YZbnrYu1zS/qwyuaCEWu91fEiKZeTyYxqS9iBzPjg9JUz73plSHDRQc5vQTn2KO39FIniEKyk1zWo4bI33jhgnaMnqklbh/b6j+1aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8676002)(316002)(508600001)(107886003)(5660300002)(956004)(66556008)(6916009)(52116002)(6666004)(6496006)(9686003)(66476007)(26005)(8936002)(6486002)(38350700002)(38100700002)(66946007)(53546011)(186003)(83380400001)(86362001)(33716001)(2906002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MSYJVeSTKlhuTZeXHsVvzeui9n5FdeK8A77R134YMaZRu4a1ZiV5R5yJfh6O?=
 =?us-ascii?Q?SigSJTmijlV/xAozy+G76Va9fqxHYWWEr1+g9D63w1suX9QWhh69n+3j8X8x?=
 =?us-ascii?Q?UlxhNS6gKrCh5rSffYUH+VCXPUzswZowd0Ykdg1xfRZxXm5KxgXyA0kXpK9q?=
 =?us-ascii?Q?7Q9+/fgZZB5iQQPorLhpQHsSWTdsjOO9ljtxu5iv1nLuQ99Mew2Ewr1GGWCt?=
 =?us-ascii?Q?pOJ0XHD+6FBZVKgOzX6u1Yfumnz8pAzdGZXP8h7/HySPU9tNX2WglKl3JwFS?=
 =?us-ascii?Q?SmX6oAZ8U/UVBkGYSUQN8AkqNXZg0zzdwldIRlXeN4QK/ft9Xr6AeICqY0/d?=
 =?us-ascii?Q?vfStvboKaakA0F3Iw92uH0HsWbWufNhzgUwAv75oimzsGLiyHzNGg6+k536J?=
 =?us-ascii?Q?tQSBM3FAQAMQ7R051jTcDQa9eK/F6HJtROHbaePguat+JokSpjIQUOyVZaje?=
 =?us-ascii?Q?tHy+V5kfmy+OiON/puNlAEidcS5lI+LdbSXWn5HannXd0hbKeu9kqnIv47Hp?=
 =?us-ascii?Q?XhnqoHfXmFSrld9HLTErtJv9uvPSxEThPhmQb6vXXpJImEv32lERmv6pUzE3?=
 =?us-ascii?Q?Qlk3bTVJHAn0j6QtU6Hzi7anxUxN0aRmAFjCtzqKpr77hwVwyANa/jGSTVGq?=
 =?us-ascii?Q?RBNBF6mkrS/5QKNHEGFkRlGS/mD9RuvXqWWciOTbCvBbRIjldqmmCgXZP2cl?=
 =?us-ascii?Q?U+WWTWUhNbiM/QyMS3Heg6RsCZLrOKjHrjstxoYI77IuXfgO2doqqdlb+yVc?=
 =?us-ascii?Q?4fjf+ABCucFsxpdyijRqcugFKvwBZE9ddiWLABPx0+G1SDjPertvV94DmHmj?=
 =?us-ascii?Q?2p13sseMi7CF90AqInel9/vwbADCoL+z2BW949zFObGZwIkZ/iJUtVRmN0+C?=
 =?us-ascii?Q?RusCDG65jRRlnnY5ZEyqCYe56gDYJSZlp55437W1PyCXyLfi0auv4bA0jGHz?=
 =?us-ascii?Q?7IclOEoS+hwUGm/RYbFMmXvjwu3tfh0vky0jooNeg4/0Wpz5lN46cLsiSjvN?=
 =?us-ascii?Q?l0IOE5fxWgwZJNyIoZQxwywqn1usNZZUsJt8EUT+rGgWDJbo5thBAghLEP4r?=
 =?us-ascii?Q?otPSL8z416eUp+Yvuyp1xLtzz5K7TJaVuddRHfi4AEvibE7IUx8rAXt1FH+w?=
 =?us-ascii?Q?bcuHLk2Hyx9TZLWT1gyu8w8fzd5MPQqZ1sY5yuV6vr4UYSvybwZEKKvBLnsC?=
 =?us-ascii?Q?LQTMVTBgnsRKTpRo1oXnLrhicjXcqvNIsU0ohiYJ95SPvN9we8pqaosk46M3?=
 =?us-ascii?Q?+0PiKwg1cgXUXWAfgFYqVukrBcKozZ0F6hO0WozL96/NkVUfTBzhXg0hcPga?=
 =?us-ascii?Q?itRxVieoP6OkwLJhxwk7Da+W1lbFW3riavWyazEpM1tqPHBEmgLVNKNtwToj?=
 =?us-ascii?Q?cuFYyz2QtTD7uLs/MjKhSoohXME1Ft8e/UAfYDzPN1snavZ9V5oLAGaOPizQ?=
 =?us-ascii?Q?V1nt7p6rr6XyecAba3vZYCdYtCCPGM/yOQmCFBjwmYq51Jx5fpDI1vsf9jPh?=
 =?us-ascii?Q?hGnH/PgVgZBpg0hwljJKhB4mUoqjNSnjFeeFo0nTCERkodwDotWJl4HGjB99?=
 =?us-ascii?Q?srpYjmin8X59awoiVB4ErVgVZ7gnUi69F9cITm6VFAlqf0BHrLE11FxZoOMr?=
 =?us-ascii?Q?45TdSQ5KkWaNUWo9t/Y+HnY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d9566f0-731c-453c-6c95-08d9bb1a1222
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 13:44:50.0054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vkm51j65OBaub9X3ND5xYdgtV36DJ87gmq9KLPVWeAYACVymPCspo0/cSyot6Y8CzxajpgGh8XSU0+pzvIB96A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4699
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10192 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090075
X-Proofpoint-GUID: 8Cd1reGCUA7JB7I0TRzhWEvjhrxEiD8a
X-Proofpoint-ORIG-GUID: 8Cd1reGCUA7JB7I0TRzhWEvjhrxEiD8a
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 09 Dec 2021 at 04:45, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> As part of multiple customer escalations due to file data corruption
> after copy on write operations, I wrote some fstests that use fsstress
> to hammer on COW to shake things loose.  Regrettably, I caught some
> filesystem shutdowns due to incorrect rmap operations with the following
> loop:
>
> mount <filesystem>				# (0)
> fsstress <run only readonly ops> &		# (1)
> while true; do
> 	fsstress <run all ops>
> 	mount -o remount,ro			# (2)
> 	fsstress <run only readonly ops>
> 	mount -o remount,rw			# (3)
> done
>
> When (2) happens, notice that (1) is still running.  xfs_remount_ro will
> call xfs_blockgc_stop to walk the inode cache to free all the COW
> extents, but the blockgc mechanism races with (1)'s reader threads to
> take IOLOCKs and loses, which means that it doesn't clean them all out.
> Call such a file (A).
>
> When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
> walks the ondisk refcount btree and frees any COW extent that it finds.
> This function does not check the inode cache, which means that incore
> COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
> one of those former COW extents are allocated and mapped into another
> file (B) and someone triggers a COW to the stale reservation in (A), A's
> dirty data will be written into (B) and once that's done, those blocks
> will be transferred to (A)'s data fork without bumping the refcount.
>
> The results are catastrophic -- file (B) and the refcount btree are now
> corrupt.  Solve this race by forcing the xfs_blockgc_free_space to run
> synchronously, which causes xfs_icwalk to return to inodes that were
> skipped because the blockgc code couldn't take the IOLOCK.  This is safe
> to do here because the VFS has already prohibited new writer threads.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Fixes: 10ddf64e420f ("xfs: remove leftover CoW reservations when remounting ro")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_super.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e21459f9923a..778b57b1f020 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1765,7 +1765,10 @@ static int
>  xfs_remount_ro(
>  	struct xfs_mount	*mp)
>  {
> -	int error;
> +	struct xfs_icwalk	icw = {
> +		.icw_flags	= XFS_ICWALK_FLAG_SYNC,
> +	};
> +	int			error;
>  
>  	/*
>  	 * Cancel background eofb scanning so it cannot race with the final
> @@ -1773,8 +1776,13 @@ xfs_remount_ro(
>  	 */
>  	xfs_blockgc_stop(mp);
>  
> -	/* Get rid of any leftover CoW reservations... */
> -	error = xfs_blockgc_free_space(mp, NULL);
> +	/*
> +	 * Clear out all remaining COW staging extents and speculative post-EOF
> +	 * preallocations so that we don't leave inodes requiring inactivation
> +	 * cleanups during reclaim on a read-only mount.  We must process every
> +	 * cached inode, so this requires a synchronous cache scan.
> +	 */
> +	error = xfs_blockgc_free_space(mp, &icw);
>  	if (error) {
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  		return error;


-- 
chandan
