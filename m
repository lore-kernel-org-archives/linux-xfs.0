Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57360 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbeJ0FFi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 27 Oct 2018 01:05:38 -0400
Subject: Re: [PATCH 0/5] v4 Try to squash metadump data leaks
References: <20181026201943.24131-1-stefanrin@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3e653734-6470-3160-58e8-5bdf866dbd87@sandeen.net>
Date: Fri, 26 Oct 2018 15:27:10 -0500
MIME-Version: 1.0
In-Reply-To: <20181026201943.24131-1-stefanrin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org



On 10/26/18 3:19 PM, Stefan Ring wrote:
> I reorganized the patches as suggested and fixed the btree case.
> 
> Stefan Ring (5):
>   xfs_metadump: Extend data zapping to XFS_DIR{2,3}_LEAFN_MAGIC blocks
>   xfs_metadump: Zap multi fsb blocks
>   xfs_metadump: Zap freeindex blocks in directory inodes
>   xfs_metadump: Zap unused space in inode btrees
>   xfs_metadump: Zap dev inodes
> 
>  db/metadump.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 105 insertions(+), 14 deletions(-)
> 


Cool, thanks for splitting these up, will review & test in earnest.

These also need your:

Signed-off-by: Stefan Ring <stefanrin@gmail.com>

But there may be a v5 yet, so stash that away for now :)

-Eric
