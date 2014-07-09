Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 941657F3F
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 03:59:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4DF0E8F8068
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 01:59:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id miYwPH0fHUaI5Mqr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 Jul 2014 01:59:14 -0700 (PDT)
Date: Wed, 9 Jul 2014 01:59:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] libxfs: clear the buffer error while the buffer is
	locked
Message-ID: <20140709085913.GA24910@infradead.org>
References: <1404862900-3369-1-git-send-email-david@fromorbit.com>
	<1404862900-3369-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1404862900-3369-2-git-send-email-david@fromorbit.com>
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

On Wed, Jul 09, 2014 at 09:41:39AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When releasing a buffer, the error shoul dbe cleared while the lock
> is still held on the buffer to avoid racing with a new user of the
> buffer.
> 
> This was pointed out in review of commit 6af7c1e ("libxfs: reused
> invalidated buffers leak state and data") but the version committed
> didn't have the fix. Thanks to Christoph Hellwig for checking and
> pointing out the oversight.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
