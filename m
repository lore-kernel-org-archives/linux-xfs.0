Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 809157CBF
	for <xfs@oss.sgi.com>; Wed,  5 Jun 2013 09:43:34 -0500 (CDT)
Message-ID: <51AF4E94.4020200@sgi.com>
Date: Wed, 05 Jun 2013 09:43:32 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] xfs: inode unlinked list needs to recalculate the
	inode CRC
References: <1370398150-12084-1-git-send-email-david@fromorbit.com>
	<1370398150-12084-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1370398150-12084-3-git-send-email-david@fromorbit.com>
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

On 06/04/13 21:09, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The inode unlinked list manipulations operate directly on the inode
> buffer, and so bypass the inode CRC calculation mechanisms. Hence an
> inode on the unlinked list has an invalid CRC. Fix this by
> recalculating the CRC whenever we modify an unlinked list pointer in
> an inode, ncluding during log recovery. This is trivial to do and
> results in  unlinked list operations always leaving a consistent
> inode in the buffer.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
