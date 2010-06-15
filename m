Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F7MH2Q077563 for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 02:22:18 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A81FAE9D77
	for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 00:28:25 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id Ow6BoKxkswLw39mi for
	<xfs@oss.sgi.com>; Tue, 15 Jun 2010 00:28:25 -0700 (PDT)
Date: Tue, 15 Jun 2010 09:24:52 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] XFS: Fix gcc 4.6 set but not read and unused statement
	warnings v2
Message-ID: <20100615072452.GE6727@basil.fritz.box>
References: <20100614081356.GA27499@basil.fritz.box>
	<20100614083021.GA29354@lst.de> <4C15EF75.5080909@linux.intel.com>
	<20100614124804.GA8547@lst.de>
	<20100614133958.GH17092@basil.fritz.box>
	<20100614163122.GB369@basil.fritz.box>
	<20100615005442.GL6590@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100615005442.GL6590@dastard>
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
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@lst.de>, dgc@fromorbit.com, xfs@oss.sgi.com

> I'm still not happy with it.

With the BUG_ON? 

> 
> We'll commit a modified version of one of your patches into the XFS
> tree as you seem unable to accept that changes might be necessary to
> get your code to pass review.

Sure modify however you like as long as you fix the warnings.

Also it was good to have review on the cases it warned about,
luckily there were no real bugs found.

[BTW I should add there were some more mostly from array
overflows. I have not investigated in detail, but I suspect
they were harmless]

My goal was also mostly to get my build reasonably warning free,
but if I can't get this patch in I can also just disable the warning
for fs/xfs. 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
