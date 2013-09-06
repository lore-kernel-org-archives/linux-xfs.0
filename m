Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B9B107F3F
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 10:48:00 -0500 (CDT)
Message-ID: <5229F930.7050502@sgi.com>
Date: Fri, 06 Sep 2013 10:48:00 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 34/55] xfs: don't special case shared superblock mounts
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-35-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-35-git-send-email-david@fromorbit.com>
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
> Neither kernel or userspace support shared read-only mounts, so
> don't beother special casing the support check to be different
> between kernel and userspace. The same check canbe used as neither
> like it...
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

matches kernel patch 28/50. No change from previous post.
Only difference in xfs_sb.h was introduced in user patch 31/55.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
