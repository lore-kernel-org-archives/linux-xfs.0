Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 16:34:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8KNYEgf007644
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 16:34:18 -0700
Date: Fri, 21 Sep 2007 09:34:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs and Linux Linux 2.6.22 and Memory
Message-ID: <20070920233405.GA995458@sgi.com>
References: <435577.15025.qm@web35711.mail.mud.yahoo.com> <46F2E001.4040107@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F2E001.4040107@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Mariella Petrini <mariellapetrini@yahoo.com>, xfs@oss.sgi.com

On Thu, Sep 20, 2007 at 04:02:57PM -0500, Eric Sandeen wrote:
> Mariella Petrini wrote:
> 
> > QUESTION:
> > 
> > Is there any way to release that amount of memory
> > without unmounting the file systems ?
> > Is that caused to some caching mechanism ?
> > Or could that be caused by something else ?
> 
> It's most likely the linux VFS caching the dentries & inodes, and
> therefore caching the xfs inodes as well.

Not just inodes, but file data in the page cache as well.

If you want to blow it all away without unmountin filesystems, then
you should read up on /proc/sys/vm sysctls (i.e.
/proc/sys/vm/drop_caches)....

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
