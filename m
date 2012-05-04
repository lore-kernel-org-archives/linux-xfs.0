Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44CgU9M030072 for <xfs@oss.sgi.com>; Fri, 4 May 2012 07:42:30 -0500
Message-ID: <4FA3CEB3.9080607@sgi.com>
Date: Fri, 04 May 2012 07:42:27 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 10/10] xfs: factor buffer reading from
	xfs_dir2_leaf_getdents
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
	<1335249220-22274-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1335249220-22274-11-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/24/12 01:33, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The buffer reading code in xfs_dir2_leaf_getdents is complex and difficult to
> follow due to the readahead and all the context is carries. it is also badly
> indented and so difficult to read. Factor it out into a separate function to
> make it easier to understand and optimise in future patches.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
