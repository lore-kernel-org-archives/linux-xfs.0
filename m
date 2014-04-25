Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5DA3B29DF8
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 01:01:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38C8F8F8039
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 23:01:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id jmerhn9Ns7rXKwAa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 23:01:20 -0700 (PDT)
Date: Thu, 24 Apr 2014 23:01:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] repair: handle remote symlink CRC errors
Message-ID: <20140425060119.GE30118@infradead.org>
References: <1398315722-20870-1-git-send-email-david@fromorbit.com>
	<1398315722-20870-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398315722-20870-9-git-send-email-david@fromorbit.com>
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

On Thu, Apr 24, 2014 at 03:02:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We can't really repair broken symlink buffer contents, but we can at
> least warn about it and correct the CRC error so the symlink is
> again readable.

> +			do_warn(
> +_("Bad symlink buffer CRC, block %" PRIu64 ", inode %" PRIu64 ".\n"
> +  "Correcting CRC, but symlink may be bad.\n"), fsbno, lino);
> +			dirty = 1;

Can you use the badcrc variable name here like in a few other places?

> +		if (dirty)
> +			libxfs_writebuf(bp, 0);
> +		else
> +			libxfs_putbuf(bp);

This needs a no_modify check.

Hmm, given how often we have this pattern and how easy it is do get
wrong, maybe libxfs_writebuf should do the no_modify check for us can we
can get rid of all this code?  Or maybe at least in a repair_writebuf
wrapper?  Not saying it should go into this series of course.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
