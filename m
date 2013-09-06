Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6AE157F50
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 12:20:32 -0500 (CDT)
Message-ID: <522A0EDF.30102@sgi.com>
Date: Fri, 06 Sep 2013 12:20:31 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 36/55] xfs: kill __KERNEL__ check for debug code in
	allocation code
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-37-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-37-git-send-email-david@fromorbit.com>
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
> Userspace running debug builds is relatively rare, so there's need
> to special case the allocation algorithm code coverage debug switch.
> As it is, userspace defines random numbers to 0, so  invert the
> logic of the switch so it is effectively a no-op in userspace.
> This kills another couple of __KERNEL__ users.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


user equivalent of the for Linux 3.12 kernel patch 29/50.
Did not change from last post. Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
