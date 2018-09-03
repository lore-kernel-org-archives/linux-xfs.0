Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58120 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725762AbeICFhz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Sep 2018 01:37:55 -0400
Date: Mon, 3 Sep 2018 11:20:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 00/28] Parent Pointers v8
Message-ID: <20180903012006.GM5631@dastard>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 28, 2018 at 12:22:13PM -0700, Allison Henderson wrote:
> Hi all,
> 
> This is the 8th version of parent pointer attributes for xfs. The goal of
> this patch set is to add a parent pointer attribute to each inode.  The
> attribute name containing the parent inode, generation, and directory offset,
> while the  attribute value contains the file name.  This feature will enable
> future optimizations for online scrub, or any other feature that could make
> use of quickly deriving an inodes path from  the mount point.  This set also
> introduces deferred attribute operations, though it is currently only used by
>  the new parent pointer code.

Hi Allison,

FYI, A couple of minor things I noticed on import of the patch set
to 4.19-rc1:

......
Applying: xfs: parent pointer attribute creation
.git/rebase-apply/patch:131: trailing whitespace.
	error = xfs_attr_set(child, (const unsigned char *)&rec, sizeof(rec), 
.git/rebase-apply/patch:136: new blank line at EOF.
+
.git/rebase-apply/patch:296: new blank line at EOF.
+
warning: 3 lines add whitespace errors.
Applying: xfs: add parent attributes to link
Applying: xfs: remove parent pointers in unlink
.git/rebase-apply/patch:97: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
Applying: xfs: Add parent pointers to rename
Applying: xfs: Add the parent pointer support to the superblock version 5.
Applying: xfs: Add helper function xfs_attr_list_context_init
Applying: xfs: Increase XFS_DEFER_OPS_NR_INODES to 4
Applying: xfs: Add parent pointer ioctl
.git/rebase-apply/patch:340: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
Applying: xfs: Add delayed attributes error tag
......

Also, I get a couple of compiler warnings:

fs/xfs/libxfs/xfs_attr.c: In function ¿xfs_attr_set¿:
fs/xfs/libxfs/xfs_attr.c:446:48: warning: passing argument 3 of ¿xfs_attr_set_deferred¿ discards ¿const¿ qualifier from pointer target type [-Wdiscarded-qualifiers]
  error = xfs_attr_set_deferred(dp, args.trans, name, namelen,
                                                ^~~~
In file included from fs/xfs/libxfs/xfs_attr.c:25:0:
fs/xfs/libxfs/xfs_attr.h:197:5: note: expected ¿void *¿ but argument is of type ¿const unsigned char *¿
 int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
     ^~~~~~~~~~~~~~~~~~~~~
fs/xfs/libxfs/xfs_attr.c: In function ¿xfs_attr_remove¿:
fs/xfs/libxfs/xfs_attr.c:584:4: warning: passing argument 3 of ¿xfs_attr_remove_deferred¿ discards ¿const¿ qualifier from pointer target type [-Wdiscarded-qualifiers]
    name, namelen, flags);
    ^~~~
In file included from fs/xfs/libxfs/xfs_attr.c:25:0:
fs/xfs/libxfs/xfs_attr.h:200:5: note: expected ¿void *¿ but argument is of type ¿const unsigned char *¿
 int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
     ^~~~~~~~~~~~~~~~~~~~~~~~

I haven't looked to find what patch causes them,  but I thought I'd
let you know straight away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
