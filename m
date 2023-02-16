Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFD6C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBPUiE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjBPUiD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:38:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B959B2CFEA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:38:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54ED360AB9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3861C433D2;
        Thu, 16 Feb 2023 20:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579880;
        bh=A3w4I7I/gv9fTyVIVgrKNvYrkb+sVgPe445yedyQh1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VBtB8lprOLusMvlrYK3adBRizhVCQm8AVWY4B9ycaLGQHruPe5ktVGFk36bJagrcJ
         1TOHLnfmxrT9t2vi7keDBlyXTpa49sSeE0BQ2qEusK4IW8g9TS9wbnLAV8Weo2ZaaU
         7/vIKbsXeVMElX4JlhxULMBRPPosW7N8KuJ0KZFlM+TBSbAdxlQlfZb6zgfmov7tPZ
         BJeukm6FYqMQ1gyFahVlkRUzhA0uwGRPTRuvYOuK0hMurNUaLX5o5D+aukp/A+JDrj
         M3xrN68KA8vE8khcx034BEVx7QVVGsbxZ4r/6aRulmOouQV0lM+RVXwPRPy/uHJELD
         MRUYRnb6YW66Q==
Date:   Thu, 16 Feb 2023 12:38:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 00/28] Parent Pointers
Message-ID: <Y+6UKAbnyOqSMh7R@magnolia>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 09, 2023 at 01:01:18AM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Hi all,
> 
> This is the latest parent pointer attributes for xfs.
> The goal of this patch set is to add a parent pointer attribute to each inode.
> The attribute name containing the parent inode, generation, and directory
> offset, while the  attribute value contains the file name.  This feature will
> enable future optimizations for online scrub, shrink, nfs handles, verity, or
> any other feature that could make use of quickly deriving an inodes path from
> the mount point.  

For the entire series,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

NOTE: This doesn't mean I'm merging this; it merely means that I've now
read through and worked enough of the parent pointers code that I feel
sufficiently comfortable with the changes to post my own additions and
alterations.

https://lore.kernel.org/linux-xfs/Y+6MxEgswrJMUNOI@magnolia/T/#t

--D

> 
> This set can be viewed on github here
> https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv9_r2
> 
> And the corresponding xfsprogs code is here
> https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v9_r2
> 
> This set has been tested with the below parent pointers tests
> https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t
> 
> Updates since v8:
> 
> xfs: parent pointer attribute creation
>    Fix xfs_parent_init to release log assist on alloc fail
>    Add slab cache for xfs_parent_defer
>    Fix xfs_create to release after unlock
>    Add xfs_parent_start and xfs_parent_finish wrappers
>    removed unused xfs_parent_name_irec and xfs_init_parent_name_irec
> 
> xfs: add parent attributes to link
>    Start/finish wrapper updates
>    Fix xfs_link to disallow reservationless quotas
>    
> xfs: add parent attributes to symlink
>    Fix xfs_symlink to release after unlock
>    Start/finish wrapper updates
>    
> xfs: remove parent pointers in unlink
>    Start/finish wrapper updates
>    Add missing parent free
> 
> xfs: Add parent pointers to rename
>    Start/finish wrapper updates
>    Fix rename to only grab logged xattr once
>    Fix xfs_rename to disallow reservationless quotas
>    Fix double unlock on dqattach fail
>    Move parent frees to out_release_wip
>    
> xfs: Add parent pointers to xfs_cross_rename
>    Hoist parent pointers into rename
> 
> Questions comments and feedback appreciated!
> 
> Thanks all!
> Allison
> 
> Allison Henderson (28):
>   xfs: Add new name to attri/d
>   xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
>   xfs: Increase XFS_QM_TRANS_MAXDQS to 5
>   xfs: Hold inode locks in xfs_ialloc
>   xfs: Hold inode locks in xfs_trans_alloc_dir
>   xfs: Hold inode locks in xfs_rename
>   xfs: Expose init_xattrs in xfs_create_tmpfile
>   xfs: get directory offset when adding directory name
>   xfs: get directory offset when removing directory name
>   xfs: get directory offset when replacing a directory name
>   xfs: add parent pointer support to attribute code
>   xfs: define parent pointer xattr format
>   xfs: Add xfs_verify_pptr
>   xfs: extend transaction reservations for parent attributes
>   xfs: parent pointer attribute creation
>   xfs: add parent attributes to link
>   xfs: add parent attributes to symlink
>   xfs: remove parent pointers in unlink
>   xfs: Indent xfs_rename
>   xfs: Add parent pointers to rename
>   xfs: Add parent pointers to xfs_cross_rename
>   xfs: Add the parent pointer support to the  superblock version 5.
>   xfs: Add helper function xfs_attr_list_context_init
>   xfs: Filter XFS_ATTR_PARENT for getfattr
>   xfs: Add parent pointer ioctl
>   xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
>   xfs: drop compatibility minimum log size computations for reflink
>   xfs: add xfs_trans_mod_sb tracing
> 
>  fs/xfs/Makefile                 |   2 +
>  fs/xfs/libxfs/xfs_attr.c        |  71 ++++-
>  fs/xfs/libxfs/xfs_attr.h        |  13 +-
>  fs/xfs/libxfs/xfs_da_btree.h    |   3 +
>  fs/xfs/libxfs/xfs_da_format.h   |  26 +-
>  fs/xfs/libxfs/xfs_defer.c       |  28 +-
>  fs/xfs/libxfs/xfs_defer.h       |   8 +-
>  fs/xfs/libxfs/xfs_dir2.c        |  21 +-
>  fs/xfs/libxfs/xfs_dir2.h        |   7 +-
>  fs/xfs/libxfs/xfs_dir2_block.c  |   9 +-
>  fs/xfs/libxfs/xfs_dir2_leaf.c   |   8 +-
>  fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c     |   6 +
>  fs/xfs/libxfs/xfs_format.h      |   4 +-
>  fs/xfs/libxfs/xfs_fs.h          |  75 ++++++
>  fs/xfs/libxfs/xfs_log_format.h  |   7 +-
>  fs/xfs/libxfs/xfs_log_rlimit.c  |  53 ++++
>  fs/xfs/libxfs/xfs_parent.c      | 203 +++++++++++++++
>  fs/xfs/libxfs/xfs_parent.h      |  84 ++++++
>  fs/xfs/libxfs/xfs_sb.c          |   4 +
>  fs/xfs/libxfs/xfs_trans_resv.c  | 324 +++++++++++++++++++----
>  fs/xfs/libxfs/xfs_trans_space.h |   8 -
>  fs/xfs/scrub/attr.c             |   4 +-
>  fs/xfs/xfs_attr_item.c          | 142 ++++++++--
>  fs/xfs/xfs_attr_item.h          |   1 +
>  fs/xfs/xfs_attr_list.c          |  17 +-
>  fs/xfs/xfs_dquot.c              |  38 +++
>  fs/xfs/xfs_dquot.h              |   1 +
>  fs/xfs/xfs_file.c               |   1 +
>  fs/xfs/xfs_inode.c              | 447 +++++++++++++++++++++++++-------
>  fs/xfs/xfs_inode.h              |   3 +-
>  fs/xfs/xfs_ioctl.c              | 148 +++++++++--
>  fs/xfs/xfs_ioctl.h              |   2 +
>  fs/xfs/xfs_iops.c               |   3 +-
>  fs/xfs/xfs_ondisk.h             |   4 +
>  fs/xfs/xfs_parent_utils.c       | 126 +++++++++
>  fs/xfs/xfs_parent_utils.h       |  11 +
>  fs/xfs/xfs_qm.c                 |   4 +-
>  fs/xfs/xfs_qm.h                 |   2 +-
>  fs/xfs/xfs_super.c              |  14 +
>  fs/xfs/xfs_symlink.c            |  58 ++++-
>  fs/xfs/xfs_trans.c              |  13 +-
>  fs/xfs/xfs_trans_dquot.c        |  15 +-
>  fs/xfs/xfs_xattr.c              |   7 +-
>  fs/xfs/xfs_xattr.h              |   2 +
>  45 files changed, 1782 insertions(+), 253 deletions(-)
>  create mode 100644 fs/xfs/libxfs/xfs_parent.c
>  create mode 100644 fs/xfs/libxfs/xfs_parent.h
>  create mode 100644 fs/xfs/xfs_parent_utils.c
>  create mode 100644 fs/xfs/xfs_parent_utils.h
> 
> -- 
> 2.25.1
> 
