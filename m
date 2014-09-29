Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14B8529DFF
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 05:43:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E8F738F8035
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 03:43:19 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id fTljjRUdGbJPTCNu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Sep 2014 03:43:18 -0700 (PDT)
Date: Mon, 29 Sep 2014 03:43:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: compat_xfs_bstat does not have forkoff
Message-ID: <20140929104318.GA10847@infradead.org>
References: <1411954886-12200-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411954886-12200-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 29, 2014 at 11:41:26AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> struct compat_xfs_bstat is missing the di_forkoff field and so does
> not fully translate the structure correctly. Fix it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ioctl32.c | 2 ++
>  fs/xfs/xfs_ioctl32.h | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Any chance to get an xfstests test that verifies the forkoff value?
Even if it would only reproduce this bug when running 32-bit userspace
on a 64-bit kernel it would be useful I think.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
