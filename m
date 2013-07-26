Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29BA829E11
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 10:32:28 -0500 (CDT)
Message-ID: <51F2968B.8030208@sgi.com>
Date: Fri, 26 Jul 2013 10:32:27 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 28/49] xfs: don't special case shared superblock mounts
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-29-git-send-email-david@fromorbit.com>
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
> Neither kernel or userspace support shared read-only mounts, so
> don't beother special casing the support check to be different
> between kernel and userspace. The same check canbe used as neither
> like it...
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

looks good, in any case the check will fail.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
