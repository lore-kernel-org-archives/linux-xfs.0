Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF623C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 23:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7764611C9
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 23:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbhI0XsT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 19:48:19 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:39027 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238236AbhI0XsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 19:48:19 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id BC620860093;
        Tue, 28 Sep 2021 09:46:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mV0KT-00HUXw-EJ; Tue, 28 Sep 2021 09:46:37 +1000
Date:   Tue, 28 Sep 2021 09:46:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields based
 on their width
Message-ID: <20210927234637.GM1756565@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-8-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916100647.176018-8-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=4T9XfmIfzXTh88SRqEMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 03:36:42PM +0530, Chandan Babu R wrote:
> This commit renames extent counter fields in "struct xfs_dinode" and "struct
> xfs_log_dinode" based on the width of the fields. As of this commit, the
> 32-bit field will be used to count data fork extents and the 16-bit field will
> be used to count attr fork extents.
> 
> This change is done to enable a future commit to introduce a new 64-bit extent
> counter field.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h      |  8 ++++----
>  fs/xfs/libxfs/xfs_inode_buf.c   |  4 ++--
>  fs/xfs/libxfs/xfs_log_format.h  |  4 ++--
>  fs/xfs/scrub/inode_repair.c     |  4 ++--
>  fs/xfs/scrub/trace.h            | 14 +++++++-------
>  fs/xfs/xfs_inode_item.c         |  4 ++--
>  fs/xfs/xfs_inode_item_recover.c |  8 ++++----
>  7 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index dba868f2c3e3..87c927d912f6 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -802,8 +802,8 @@ typedef struct xfs_dinode {
>  	__be64		di_size;	/* number of bytes in file */
>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>  	__be32		di_extsize;	/* basic/minimum extent size for file */
> -	__be32		di_nextents;	/* number of extents in data fork */
> -	__be16		di_anextents;	/* number of extents in attribute fork*/
> +	__be32		di_nextents32;	/* number of extents in data fork */
> +	__be16		di_nextents16;	/* number of extents in attribute fork*/


Hmmm. Having the same field in the inode hold the extent count
for different inode forks based on a bit in the superblock means the
on-disk inode format is not self describing. i.e. we can't decode
the on-disk contents of an inode correctly without knowing whether a
specific feature bit is set in the superblock or not.

Right now we don't have use external configs to decode the inode.
Feature level conditional fields are determined by inode version,
not superblock bits. Optional feature fields easy to deal with -
zero if the feature is not in use, otherwise we assume it is in use
and can validity check it appropriately. IOWs, we don't need
to look at sb feature bits to decode and validate inode fields.

This change means that we can't determine if the extent counts are
correct just by looking at the on-disk inode. If we just have
di_nextents32 set to a non-zero value, does that mean we should have
data fork extents or attribute fork extents present?

Just looking at whether the attr fork is initialised is not
sufficient - it can be initialised with zero attr fork extents
present.  We can't look at the literal area contents, either,
because we don't zero that when we shrink it. We can't look at
di_nblocks, because that counts both attr and data for blocks. We
can't look at di_size, because we can have data extents beyond EOF
and hence a size of zero doesn't mean the data fork is empty.

So if both forks are in extent format, they could be either both
empty, both contain extents or only one fork contains extents but we
can't tell which state is the correct one. Hence
if di_nextents64 if zero, we don't know if di_nextents32 is a count
of attribute extents or data extents without first looking at the
superblock feature bit to determine if di_nextents64 is in use or
not. The inode format is not self describing anymore.

When XFS introduced 32 bit link counts, the inode version was bumped
from v1 to v2 because it redefined fields in the inode structure
similar to this proposal[1]. The verison number was then used to
determine if the inode was in old or new format - it was a self
describing format change. Hence If we are going to redefine
di_nextents to be able to hold either data fork extent count (old
format) or attr fork extent count (new format) we really need to
bump the inode version so that we can discriminate between the two
inode formats just by looking at the inode itself.

If we don't want to bump the version, then we need to do something
like:

-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	__be32		di_nextents_old;/* old number of extents in data fork */
+	__be16		di_anextents_old;/* old number of extents in attribute fork*/
.....
-	__u8            di_pad2[12];
+	__be64		di_nextents;	/* number of extents in data fork */
+	__be32		di_anextents;	/* number of extents in attribute fork*/
+	__u8            di_pad2[4];

So that there is no ambiguity in the on-disk format between the two
formats - if one set is non-zero, the other set must be zero in this
sort of setup.

However, I think that redefining the fields and bumping the inode
version is the better long term strategy, as it allows future reuse
of the di_anextents_old field, and it uses less of the small amount
of unused padding we have remaining in the on-disk inode core.

At which point, the feature bit in the superblock becomes "has v4
inodes", not "has big extent counts". We then use v4 inode format in
memory for everything (i.e. 64 bit extent counts) and convert
to/from the ondisk format at IO time like we do with v1/v2 inodes.

Thoughts?

-Dave.

[1] The change to v2 inodes back in 1995 removed the filesystem UUID
from the inode and was replaced with a 32 bit link counter, a project ID
value and padding:

@@ -36,10 +38,12 @@ typedef struct xfs_dinode_core
        __uint16_t      di_mode;        /* mode and type of file */
        __int8_t        di_version;     /* inode version */
        __int8_t        di_format;      /* format of di_c data */
-       __uint16_t      di_nlink;       /* number of links to file */
+       __uint16_t      di_onlink;      /* old number of links to file */
        __uint32_t      di_uid;         /* owner's user id */
        __uint32_t      di_gid;         /* owner's group id */
-       uuid_t          di_uuid;        /* file unique id */
+       __uint32_t      di_nlink;       /* number of links to file */
+       __uint16_t      di_projid;      /* owner's project id */
+       __uint8_t       di_pad[10];     /* unused, zeroed space */
        xfs_timestamp_t di_atime;       /* time last accessed */
        xfs_timestamp_t di_mtime;       /* time last modified */
        xfs_timestamp_t di_ctime;       /* time created/inode modified */
@@ -81,7 +85,13 @@ typedef struct xfs_dinode

it was the redefinition of the di_uuid variable space that required
the bumping of the inode version...
-- 
Dave Chinner
david@fromorbit.com
