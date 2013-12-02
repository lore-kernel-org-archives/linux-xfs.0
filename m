Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 33E5629DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:22:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF74CAC009
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 15:22:41 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NHd2Ci9Oqzrwl9OC for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 15:22:39 -0800 (PST)
Date: Tue, 3 Dec 2013 10:21:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/15] mkfs: don't treat files as though they are block
	devices
Message-ID: <20131202232143.GF10988@dastard>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-16-git-send-email-david@fromorbit.com>
	<20131202172441.GF28630@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131202172441.GF28630@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Dec 02, 2013 at 09:24:41AM -0800, Christoph Hellwig wrote:
> >  void
> >  platform_flush_device(int fd, dev_t device)
> >  {
> > -	if (major(device) != RAMDISK_MAJOR)
> > +	struct stat64	st;
> > +	if (major(device) == RAMDISK_MAJOR)
> > +		return;
> > +
> > +	if (fstat64(fd, &st) < 0)
> > +		return;
> > +
> > +	if (S_ISREG(st.st_mode))
> > +		fsync(fd);
> > +	else
> >  		ioctl(fd, BLKFLSBUF, 0);
> >  }
> 
> Given that fsync does the right thing for device on Linux aswell
> I'd suggest we make this function call it all the time and get rid
> of all the ramdisk magic.
> 
> Should probabbly be a a separate patch.

Yeah, I just shovelled all the fixes to problems I found into this
patch, so it needs to be split up a bit more....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
