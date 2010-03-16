Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2G1JJDd105904 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 20:19:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C19BA24C694
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 18:20:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	hIBPHAuZf2IYCE0h for <xfs@oss.sgi.com>;
	Mon, 15 Mar 2010 18:20:54 -0700 (PDT)
Date: Tue, 16 Mar 2010 12:20:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Delayed logging
Message-ID: <20100316012051.GD12369@dastard>
References: <20100315043000.GK4732@dastard>
	<20100315180841.GA21975@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315180841.GA21975@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Mar 15, 2010 at 02:08:41PM -0400, Christoph Hellwig wrote:
> On Mon, Mar 15, 2010 at 03:30:00PM +1100, Dave Chinner wrote:
> > 	- occasional recovery failure with recovery reading an inode
> > 	  buffer that does not contain inodes. Cause unknown, tends
> > 	  to be reproduced by xfsqa test 121 semi-reliably. Needs
> > 	  further analysis and fixing. May already be fixed with a
> > 	  recent fix to commit record synchronisation.
> 
> I just saw a corrupted inode buffer during log recovery in 087, even
> without the delaylog mount option.  It's however not easily
> reproducible.

Yeah, that's the sort of thing I'm seeing 087, 110 (IIRC) and 121
are the tests that I've been seeing occasional, random failures like
this. I hadn't noticed it without the delaylog option, so I'll see
if I can get that to occur as well...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
