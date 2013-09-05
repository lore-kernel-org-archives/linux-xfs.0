Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0AF697F51
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 14:01:33 -0500 (CDT)
Message-ID: <5228D509.7040200@sgi.com>
Date: Thu, 05 Sep 2013 14:01:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 16/55] xfs: separate out log format definitions
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-17-git-send-email-david@fromorbit.com>
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
> The on-disk format definitions for the log are spread randoms
> through a couple of header files. Consolidate it all in a single
> file that can be shared easily with userspace. This means that
> xfs_log.h and xfs_log_priv.h no longer need to be shared with
> userspace.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

This reposted patch has not changed

sync the new user/kernel xfs_log_priv.h to patch 01/50 of the for Linux 
3.12 kernel patch series which also means remove kernel-only headers 
(xfs_log.h, xfs_log_priv.h) from xfsprogs.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
