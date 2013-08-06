Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E3DDE29DFB
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 11:28:37 -0500 (CDT)
Message-ID: <52012435.5090403@sgi.com>
Date: Tue, 06 Aug 2013 11:28:37 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 40/49] xfs: make struct xfs_perag kernel only
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-41-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-41-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:45, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The struct xfs_perag has many kernel-only definitions in it,
> requiring a __KERNEL__ guard so userspace can use it to. Move it to
> xfs_mount.h so that it it kernel-only, and let userspace redefine
> it's own version of the structure containing only what it needs.
> This gets rid of another __KERNEL__ check in the XFS header files.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

user equivalent of the for Linux 3.12 kernel patch 34/49

looks okay.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
