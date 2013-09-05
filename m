Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAE6B7F50
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 14:20:26 -0500 (CDT)
Message-ID: <5228D979.2030408@sgi.com>
Date: Thu, 05 Sep 2013 14:20:25 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 19/55] xfs: split out inode log item format definition
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-20-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-20-git-send-email-david@fromorbit.com>
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
> The EFI/EFD item format definitions are shared with userspace. Split
> the out of header files that contain kernel only defintions to make
> it simple to shared them.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

This patch has not changed from the past posting.

This patch is the user equivalent of the for Linux 3.12 kernel patch 04/50.

sync the shared user/kernel extent free items to xfs_log_format.h. The 
kernel only extent free items remain in the header file, 
xfs_extfree_item.h, which is removed from xfsprogs.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
