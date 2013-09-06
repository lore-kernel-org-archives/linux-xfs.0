Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 528877F3F
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 10:13:42 -0500 (CDT)
Message-ID: <5229F122.3030206@sgi.com>
Date: Fri, 06 Sep 2013 10:13:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 30/55] xfs: split out the remote symlink handling
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-31-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-31-git-send-email-david@fromorbit.com>
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

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The remote symlink format definition and manipulation needs to be
> shared with userspace, but the in-kernel interfaces do not. Split
> the remote symlink format handling out into xfs_symlink_remote.[ch]
> fo it can easily be shared with userspace.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

No change in repost.
user equivalent of the for Linux 3.12 kernel patch 19/50.

moves the shared symlink information from xfs_symlink.c/h to
xfs_format.h and xfs_symlink_remote.c/h.

xfs_symlink.c/h is kernel-only and these files are removed from xfsprogs.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
