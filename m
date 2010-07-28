Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6S8f7sS240724 for <xfs@oss.sgi.com>; Wed, 28 Jul 2010 03:41:10 -0500
Date: Wed, 28 Jul 2010 04:44:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS Master Branch Rebase
Message-ID: <20100728084400.GA9516@infradead.org>
References: <1280247366.2002.111.camel@doink> <20100727232719.GR7362@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100727232719.GR7362@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Wed, Jul 28, 2010 at 09:27:19AM +1000, Dave Chinner wrote:
> Alex, this is a bit annoying. Rebases are a real pain for anyone
> downstream that is using git in non-trivial ways.

FYI: I asked Alex to do it, so I'll happily take all the blaim here.

The real problem is that we had quite a merge mess before, which Linus
absolutely doesn't like.  And if I traced it back correctly most of
it actually came from the xfsdev tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
