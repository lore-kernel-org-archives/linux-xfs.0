Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 857FC7F3F
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 12:54:05 -0500 (CDT)
Message-ID: <51F4093A.6070308@sgi.com>
Date: Sat, 27 Jul 2013 12:54:02 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 20/49] xfs: introduce xfs_sb.c for sharing with libxfs
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-21-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-21-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:24, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> xfs_mount.c is shared with userspace, but the only functions that
> are shared are to do with physical superblock manipulations. This
> means that less than 25% of the xfs_mount.c code is actually shared
> with userspace. Move all the superblock functions to xfs_sb.c and
> share that instead with libxfs.
>
> Note that this will leave all the in-core transaction related
> superblock counter modifications in xfs_mount.c as none of that is
> shared with userspace. With a few more small changes, xfs_mount.h
> won't need to be shared with userspace anymore, either.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

okay, moves the user sharable functions/headers from xfs_mount.c/h to
  xfs_sb.c/h

couple comments:

   a struct xfs_mount got converted to a xfs_mount_t typedef in
   xfs_initialize_perag() def in xfs_mount.h

  brackets were added to a single line if statements in
  xfs_sb_quota_from_disk()

beyond these two comments consider it:

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
