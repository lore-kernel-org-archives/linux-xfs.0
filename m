Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7464CC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 20:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244934AbiA1UBy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 15:01:54 -0500
Received: from sandeen.net ([63.231.237.45]:40552 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbiA1UBy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jan 2022 15:01:54 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C16F678FC;
        Fri, 28 Jan 2022 14:01:40 -0600 (CST)
Message-ID: <21a7d548-6542-4c07-b007-0b4951d16875@sandeen.net>
Date:   Fri, 28 Jan 2022 14:01:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263805814.860211.18062742237091017727.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 39/45] libxfs: remove pointless *XFS_MOUNT* flags
In-Reply-To: <164263805814.860211.18062742237091017727.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:20 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Get rid of these flags and the m_flags field, since none of them do
> anything anymore.

> diff --git a/db/attrset.c b/db/attrset.c
> index 98a08a49..6441809a 100644
> --- a/db/attrset.c
> +++ b/db/attrset.c
> @@ -107,7 +107,6 @@ attr_set_f(
>   			break;
>   
>   		case 'n':
> -			mp->m_flags |= LIBXFS_MOUNT_COMPAT_ATTR;
>   			break;

That leaves an interesting no-op! I think IRC discussion ended at
"haha it was a no-op before, too!" but maybe a comment to note the
weird wart would be reasonable while we work out what to do with
it, since it's so blazingly obvious now.

>   
>   		/* value length */
> @@ -169,7 +168,6 @@ attr_set_f(
>   	set_cur_inode(iocur_top->ino);
>   
>   out:
> -	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
>   	if (args.dp)
>   		libxfs_irele(args.dp);
>   	if (args.value)
> @@ -211,7 +209,6 @@ attr_remove_f(
>   			break;
>   
>   		case 'n':
> -			mp->m_flags |= LIBXFS_MOUNT_COMPAT_ATTR;
>   			break;

here as well

...

> diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
> index 592e4502..d43914b9 100644
> --- a/libxlog/xfs_log_recover.c
> +++ b/libxlog/xfs_log_recover.c
> @@ -827,7 +827,6 @@ xlog_find_tail(
>   			 * superblock counters from the perag headers if we
>   			 * have a filesystem using non-persistent counters.
>   			 */
> -			log->l_mp->m_flags |= XFS_MOUNT_WAS_CLEAN;
>   		}
>   	}

Preceeding comment should go too, then, or maybe we should leave the
equivalent opstate in place there? I'm not sure if the libxlog copies are
supposed to stay as true as possible to kernelspace, or if we expect them
to diverge and remove the pointless bits.  Probably the latter, right?
So probably just nuke the comment.

-Eric
