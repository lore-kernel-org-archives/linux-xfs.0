Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:30:37 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JUV42023276
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:30:34 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F44419693FD
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:31:43 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id jHIXvIJMLnwE85BA for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:31:43 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:31:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
Message-ID: <20080801193133.GA838@lst.de>
References: <1217553598.3860.16.camel@luna.unix.geek.nz> <20080801073033.GF6201@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801073033.GF6201@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jasper Bryant-Greene <jasper@amiton.co.nz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, util-linux-ng@vger.kernel.org

On Fri, Aug 01, 2008 at 05:30:33PM +1000, Dave Chinner wrote:
> On Fri, Aug 01, 2008 at 01:19:58PM +1200, Jasper Bryant-Greene wrote:
> > I mount a bunch of XFS filesystems with "noikeep,attr2,noatime", and a
> > couple also with "ro".
> > 
> > Sometimes I want to remount one of the "ro" ones "rw", to make changes.
> > This doesn't work anymore in 2.6.27-rc1-next-20080730. The last kernel I
> > tried which it worked in was 2.6.26 release.
> > 
> > luna ~ # mount -o remount,rw /usr
> > mount: /usr not mounted already, or bad option
> > 
> > luna ~ # dmesg | tail -n 1
> > [18702.291344] XFS: mount option "noikeep" not supported for remount
> > 
> > Is this intended behaviour?
> 
> Side effect of this commit:
> 
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=0327f9d799ebb96f67c80dd732b1fdb09527365e
> 
> Christoph?

I'ts most likely a fallout, but I wonder why.  To get this behaviour
moutn would have to add all the options it finds in /proc/self/mounts
to the command line.

Added the util-linux-ng list to shed some light on this, but I suspect
I'll have to change xfs_fs_remount to check if the option passed in
is identical to the one we already have and only reject it when it
changes due to this mount(1) dumbness.
