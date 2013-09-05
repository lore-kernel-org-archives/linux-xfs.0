Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DCB3C7CBF
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 16:29:47 -0500 (CDT)
Message-ID: <5228F7CB.20607@sgi.com>
Date: Thu, 05 Sep 2013 16:29:47 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 24/55] xfs: introduce xfs_quota_defs.h
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-25-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-25-git-send-email-david@fromorbit.com>
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
> There are a lot of quota flag definitions that are shared by user
> and kernel space. Move them all to xfs_quota_defs.h so we can
> unshare xfs_quota.h and remove the __KERNEL__ regions from it.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


This patch compares different from the previous series because of the 
new quota header entry. I compares cleanly.


xfsprogs equivalent of the for 3.12 kernel patch 09/50.

move remaining quota shared entries from xfs_quota.h to xfs_quota_defs.h 
- as mentioned in patch 20, xfs_quota.h is now kernel-only and removed.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
