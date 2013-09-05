Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C1D817F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 10:25:37 -0500 (CDT)
Message-ID: <5228A26E.1040202@sgi.com>
Date: Thu, 05 Sep 2013 10:25:34 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/55] xfsprogs: port inode create transaction changes
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-3-git-send-email-david@fromorbit.com>
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
> Bring across the relevant parts of the new inode create transaction
> sufficient to keep kernel/user code in sync and implement the
> infrastructure needed to make it work in xfsprogs.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Same as previous posting. I said in the last patch posting that this had 
"parts of kernel commits 28c8e41a, ddf6ad01, b8402b47?, and b8402b47".

I did not thoroughly review the previous posting of this patch, so I am 
looking at it closer now.

There arguement difference in xfs_ialloc_get_rec() from Linux 3.11, but 
that is needed for patch 11.

Still looks good to me.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
