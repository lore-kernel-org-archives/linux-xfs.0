Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 16:39:13 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m75Nd7BF025032
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 16:39:07 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EE87198FBC4
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 16:40:20 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id PxQ9WBXbMtzV6jda for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 16:40:20 -0700 (PDT)
Date: Wed, 6 Aug 2008 09:39:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
Message-ID: <20080805233956.GI21635@disturbed>
References: <1217553598.3860.16.camel@luna.unix.geek.nz> <20080801073033.GF6201@disturbed> <20080801193133.GA838@lst.de> <20080805110357.GL21873@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080805110357.GL21873@nb.net.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Karel Zak <kzak@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jasper Bryant-Greene <jasper@amiton.co.nz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, util-linux-ng@vger.kernel.org

On Tue, Aug 05, 2008 at 01:03:57PM +0200, Karel Zak wrote:
> On Fri, Aug 01, 2008 at 09:31:33PM +0200, Christoph Hellwig wrote:
> > I'ts most likely a fallout, but I wonder why.  To get this behaviour
> > moutn would have to add all the options it finds in /proc/self/mounts
> > to the command line.
> 
>  mount(8) does not read and use /proc/self/mounts at all.
> 
>     Karel
> 
> 
>  Man mount:
> 
>  remount
> 
>      Attempt  to remount an already-mounted file system.  This is commonly used
>      to change the mount flags for a file system, especially to make a readonly
>      file system writeable. It does not change device or mount point.
> 
>      The  remount  functionality follows the standard way how the mount command
>      works with options from fstab. It means the  mount  command  doesn’t  read
>      fstab (or mtab) only when a device and dir are fully specified.
> 
>      mount -o remount,rw /dev/foo /dir
> 
>      After  this  call  all  old mount options are replaced and arbitrary stuff
>      from fstab is ignored, except the loop= option which is internally  gener-
>      ated and maintained by the mount command.
> 
>      mount -o remount,rw  /dir
> 
>      After  this call mount reads fstab (or mtab) and merges these options with
>      options from command line ( -o ).

So, given the command at issue was:

luna ~ # mount -o remount,rw /usr

We're seeing the second case where mount is merging all the options in
/etc/fstab into the options passed into the remount command. How is
the filesystem expected to behave in these difference cases? The
first simply changes the ro/rw status, the second potentially
asks for the filesystem to change a bunch of other mount options
as well, which it may not be able to do.

So what is the correct behaviour? Should the filesystem *silently
ignore* unchangable options in the remount command, or should it
fail the remount and warn the user that certain options are not
allowed in remount?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
