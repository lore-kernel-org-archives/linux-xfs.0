Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JNPGAk162911 for <xfs@oss.sgi.com>; Wed, 19 May 2010 18:25:16 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 298D61411EAD
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 16:27:34 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	XuRBrEf4l3B6C1Rb for <xfs@oss.sgi.com>;
	Wed, 19 May 2010 16:27:34 -0700 (PDT)
Date: Thu, 20 May 2010 09:27:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS on 2.6.26: reading the first 4K of a large file takes ages
Message-ID: <20100519232731.GR8120@dastard>
References: <8239xojfco.fsf@mid.bfk.de> <20100519114826.GA18224@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100519114826.GA18224@infradead.org>
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
Cc: xfs@oss.sgi.com, Florian Weimer <fweimer@bfk.de>

On Wed, May 19, 2010 at 07:48:26AM -0400, Christoph Hellwig wrote:
> On Wed, May 19, 2010 at 11:33:27AM +0000, Florian Weimer wrote:
> > We've got a couple of rather large files, and with a cold cache,
> > reading the first 4K bytes of the file (e.g., just running
> > "head --bytes 4096" on it) takes ages, up to several minutes,
> > sometimes triggering the hang check timer.
> > 
> > I wonder if XFS reads the whole extent information into RAM when the
> > file is opened.  Is this the case, at least on 2.6.26?  Has this
> > changed in later versions, perhaps?
> 
> Yes, XFS always reads in the extent map, and no this hasn't changed
> recently.

And demand paging the in-memory information is hard. It's on a to-do
list somewhere 'round here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
