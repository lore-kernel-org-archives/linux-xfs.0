Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FCFC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 21:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbiAaV33 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:29:29 -0500
Received: from sandeen.net ([63.231.237.45]:50558 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230390AbiAaV33 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Jan 2022 16:29:29 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0746C4919;
        Mon, 31 Jan 2022 15:29:11 -0600 (CST)
Message-ID: <8c5ff13a-78a6-30f4-f88a-1a30e952e1b4@sandeen.net>
Date:   Mon, 31 Jan 2022 15:29:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263805814.860211.18062742237091017727.stgit@magnolia>
 <20220128224300.GK13540@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v1.1 39/45] libxfs: remove pointless *XFS_MOUNT* flags
In-Reply-To: <20220128224300.GK13540@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/28/22 4:43 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Get rid of these flags and the m_flags field, since none of them do
> anything anymore.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v1.1: add some clarifying comments, maintain same inode64 behavior
> ---

..


> index e9235a35..18cbc59e 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -490,12 +490,7 @@ rtmount_init(
>   
>   /*
>    * Set parameters for inode allocation heuristics, taking into account
> - * filesystem size and inode32/inode64 mount options; i.e. specifically
> - * whether or not XFS_MOUNT_SMALL_INUMS is set.
> - *
> - * Inode allocation patterns are altered only if inode32 is requested
> - * (XFS_MOUNT_SMALL_INUMS), and the filesystem is sufficiently large.
> - * If altered, XFS_MOUNT_32BITINODES is set as well.
> + * filesystem size.
>    *
>    * An agcount independent of that in the mount structure is provided
>    * because in the growfs case, mp->m_sb.sb_agcount is not yet updated
> @@ -531,22 +526,8 @@ xfs_set_inode_alloc(
>   		max_metadata = agcount;
>   	}
>   
> -	/* Get the last possible inode in the filesystem */
> -	agino =	XFS_AGB_TO_AGINO(mp, sbp->sb_agblocks - 1);
> -	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);

Whoops, removing "agino = " here leads to an uninitialized use later....

So if we're really going to rip this all out, we need to remove all the
logic under the  "xfs_is_inode32(mp)" cases and just set up every AG
as inode-capable, I think, i.e. this on top of yours:

diff --git a/libxfs/init.c b/libxfs/init.c
index 035d2807..cc031d50 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -506,7 +506,6 @@ xfs_set_inode_alloc(
         xfs_agnumber_t  maxagi = 0;
         xfs_sb_t        *sbp = &mp->m_sb;
         xfs_agnumber_t  max_metadata;
-       xfs_agino_t     agino;
         xfs_ino_t       ino;
  
         /*
@@ -531,31 +530,13 @@ xfs_set_inode_alloc(
         for (index = 0; index < agcount; index++) {
                 struct xfs_perag        *pag;
  
-               ino = XFS_AGINO_TO_INO(mp, index, agino);
-
                 pag = xfs_perag_get(mp, index);
-
-               if (xfs_is_inode32(mp)) {
-                       if (ino > XFS_MAXINUMBER_32) {
-                               pag->pagi_inodeok = 0;
-                               pag->pagf_metadata = 0;
-                       } else {
-                               pag->pagi_inodeok = 1;
-                               maxagi++;
-                               if (index < max_metadata)
-                                       pag->pagf_metadata = 1;
-                               else
-                                       pag->pagf_metadata = 0;
-                       }
-               } else {
-                       pag->pagi_inodeok = 1;
-                       pag->pagf_metadata = 0;
-               }
-
+               pag->pagi_inodeok = 1;
+               pag->pagf_metadata = 0;
                 xfs_perag_put(pag);
         }
  
-       return xfs_is_inode32(mp) ? maxagi : agcount;
+       return agcount;
  }

