Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3EDA7F51
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 05:47:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C05AD304066
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 03:47:08 -0800 (PST)
Received: from boogeyman.armory.com
	(adsl-76-230-21-225.dsl.pltn13.sbcglobal.net [76.230.21.225])
	by cuda.sgi.com with ESMTP id YWOLxOWPQ7KZaLNK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 03:47:07 -0800 (PST)
Date: Thu, 28 Nov 2013 03:47:05 -0800
From: Phil White <cerise-xfs@l.armory.com>
Subject: Re: Problem with mkfs.xfs on a regular file
Message-ID: <20131128114705.GJ13101@boogeyman>
References: <20131127023119.GB13101@boogeyman> <20131127024713.GE10988@dastard>
	<5296ACFB.4030901@sandeen.net> <20131128051626.GM10988@dastard>
	<5296D5EB.2080008@sandeen.net> <20131128100107.GN10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131128100107.GN10988@dastard>
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
Cc: Phil White <cerise-xfs@l.armory.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Nov 28, 2013 at 09:01:07PM +1100, Dave Chinner wrote:
> On Wed, Nov 27, 2013 at 11:34:35PM -0600, Eric Sandeen wrote:
> > If only we had some way to tell, programatically, whether the mkfs target
> > was a regular file or a block device, eh? ;)
> > 
> > Seriously, I always thought the requirment to specify "-d file" was silly.
> > And now I think it's even more silly, if it actually is required for
> > proper behavior...
> 
> It has always been required if you want mkfs to create the file for
> you. And given that doing stuff like ioctl(BLKDISCARD) on files is
> completely wrong, so I think it really is needed...
> 
> > > What mkfs needs to do is reject devices that are files when "-d
> > > file", "-l file" and "-r file" is not specified, and the problem
> > > will go away because it will catch users who forget to tell mkfs
> > > that it is supposed to be operating on an image file...
> > 
> > Or maybe just stat() it, and DTRT?
> 
> Well, we need to stat it to make sure that it's a file if "-d file"
> is specified, and a block device if it's not. That will prevent this
> problem.  Every other xfsprogs utility has to be told that it is
> being pointed at an image file rather than a block device, so why
> should mkfs be any different?

FWIW, I have a patch to just stat() and discard LIBXFS_DIRECT if the
target is not a block device.  It worked for what I was doing and I
wouldn't mind cleaning it up if need be.

The main thing is that it seems to me that mkfs mandates that the situation
I outlined shouldn't ever fail.  That's probably something worth adding to
xfstests as well.

And writing that test, I suppose, is something I don't mind doing either.

-Phil


-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
