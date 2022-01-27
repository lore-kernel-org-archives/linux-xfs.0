Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBBBC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 23:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiA0XDY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 18:03:24 -0500
Received: from sandeen.net ([63.231.237.45]:49720 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235130AbiA0XDY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jan 2022 18:03:24 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B58B34CE9E2;
        Thu, 27 Jan 2022 17:03:11 -0600 (CST)
Message-ID: <bfeb58f9-b55a-c208-b7b3-4986f1f8971a@sandeen.net>
Date:   Thu, 27 Jan 2022 17:03:22 -0600
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
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

...

> diff --git a/libxfs/init.c b/libxfs/init.c
> index e9235a35..093ce878 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -540,13 +540,10 @@ xfs_set_inode_alloc(
>   	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
>   	 * the allocator to accommodate the request.
>   	 */
> -	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32) {
> +	if (ino > XFS_MAXINUMBER_32)
>   		xfs_set_inode32(mp);
> -		mp->m_flags |= XFS_MOUNT_32BITINODES;
> -	} else {
> +	else
>   		xfs_clear_inode32(mp);
> -		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> -	}

Hm, so this just removes the "XFS_MOUNT_SMALL_INUMS" test. In the last
release, nothing ever set this flag in userspace, so the first part of
the conditional was always false, so we always cleared the 32bitinode
setting.

So I think this is a change in behavior, and if we get a request for a
large inode, we'll enable inode32, at least for this session?

But maybe that's ok, since there is no "inode32 mount option" in
userspace, and maybe we *shouldn't* be allocating 64-bit inodes in
userspace?  <thinking>

<thinking some more>

I'll get back to this :)

-Eric


