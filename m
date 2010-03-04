Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o247uSft150280 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 01:56:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3E5713F31C3
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 23:57:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AG7jhyevt8v2i7xh for
	<xfs@oss.sgi.com>; Wed, 03 Mar 2010 23:57:56 -0800 (PST)
Date: Thu, 4 Mar 2010 02:57:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfsqa: add delayed allocation @ ENOSPC exerciser
Message-ID: <20100304075753.GA16740@infradead.org>
References: <1267597162-12092-1-git-send-email-david@fromorbit.com>
	<1267597162-12092-2-git-send-email-david@fromorbit.com>
	<20100303125619.GA26672@infradead.org>
	<20100303223122.GA14317@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100303223122.GA14317@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Mar 04, 2010 at 09:31:22AM +1100, Dave Chinner wrote:
> On Wed, Mar 03, 2010 at 07:56:19AM -0500, Christoph Hellwig wrote:
> > On Wed, Mar 03, 2010 at 05:19:20PM +1100, Dave Chinner wrote:
> > > +	killall -9 dd > /dev/null 2>&1
> > 
> > This seems a bit dangerous.  I have at least one old system that
> > uses dd to continously read the kernel message buffer in the
> > background, and there's tons of other potential dd uses.
> 
> I only put it there to make sure they all died when I ^C'd out of a
> test run while testing the test. I forgot to remove it - I'll drop
> it from the patch.

Ok with that change.  Although beeing able to Ctrl+C testcase is a nice
gimmick to have.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
