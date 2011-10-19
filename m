Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9J8w3jV172095 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:58:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE6301D9693
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 01:57:59 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	5h6WeWyH2JDvir7f for <xfs@oss.sgi.com>;
	Wed, 19 Oct 2011 01:57:59 -0700 (PDT)
Date: Wed, 19 Oct 2011 04:57:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: make i_flags and unsigned long
Message-ID: <20111019085757.GA6708@infradead.org>
References: <20111018201304.279051318@bombadil.infradead.org>
	<20111018201405.168458311@bombadil.infradead.org>
	<20111019003047.GA21338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111019003047.GA21338@dastard>
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

On Wed, Oct 19, 2011 at 11:30:47AM +1100, Dave Chinner wrote:
> On Tue, Oct 18, 2011 at 04:13:05PM -0400, Christoph Hellwig wrote:
> > To be used for bit wakeup i_flags needs to be an unsigned long or we'll
> > run into trouble on big endian systems.  Beause of the 1-byte i_update
> > field right after it this actually causes a fairly large size increase
> > on it's own (4 or 7 bytes), but that increase will be more than offset
> > by the next two patches.
> 
> You could always make the i_update_core boolean a flag bit, and that
> growth will also go away. Regardless:

I could.  Then again I plan to kill it for 3.3, so re-arranging the
deck charis now might not be all that useful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
