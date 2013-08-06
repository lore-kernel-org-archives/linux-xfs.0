Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A8C9529DFB
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 10:52:30 -0500 (CDT)
Message-ID: <52011BBD.7050708@sgi.com>
Date: Tue, 06 Aug 2013 10:52:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 36/49] xfs: kill __KERNEL__ check for debug code in
	allocation code
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-37-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-37-git-send-email-david@fromorbit.com>
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
> Userspace running debug builds is relatively rare, so there's need
> to special case the allocation algorithm code coverage debug switch.
> As it is, userspace defines random numbers to 0, so  invert the
> logic of the switch so it is effectively a no-op in userspace.
> This kills another couple of __KERNEL__ users.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

user equivalent of the for Linux 3.12 kernel patch 29/49.

This patch is same as kernel - there are differences in xfs_alloc.c from 
other patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
