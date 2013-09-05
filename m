Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 28B377F50
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 14:14:12 -0500 (CDT)
Message-ID: <5228D803.9040500@sgi.com>
Date: Thu, 05 Sep 2013 14:14:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 17/55] xfs: split out inode log item format definition
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-18-git-send-email-david@fromorbit.com>
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
> Th elog item format definitions are shared with userspace. split the
> out of header files that contain kernel only defintions to make it
> simple to shared them.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

This patch has not been changed in the repost.

sync the new user/kernel xfs_inode.h and xfs_log_format.h to patch 02/49 
of the for Linux 3.12 kernel patch series which also means remove 
kernel-only headers.
         ---
The quota entries will be removed from xfsprogs version of xfs_inode, so 
my earlier review point of a missing "i_pdquot" from kernel commit 
92f8ff73 no longer matters.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
