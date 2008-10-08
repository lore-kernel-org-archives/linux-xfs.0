Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 17:11:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m980B9x2026194
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 17:11:09 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E9044C9BC8
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 17:12:48 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id VFzRR65EJOVKwBU5 for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 17:12:48 -0700 (PDT)
Date: Wed, 8 Oct 2008 11:12:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs file system corruption
Message-ID: <20081008001245.GC7342@disturbed>
References: <E8DED08235A93F4D8A2AB6CD0ABAB32A0A937FC8EC@NA-EXMSG-C121.redmond.corp.microsoft.com> <20081007233418.GB7342@disturbed> <E8DED08235A93F4D8A2AB6CD0ABAB32A0A937FC922@NA-EXMSG-C121.redmond.corp.microsoft.com> <E8DED08235A93F4D8A2AB6CD0ABAB32A0A937FC938@NA-EXMSG-C121.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E8DED08235A93F4D8A2AB6CD0ABAB32A0A937FC938@NA-EXMSG-C121.redmond.corp.microsoft.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Allan Haywood <Allan.Haywood@microsoft.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Oct 07, 2008 at 04:58:24PM -0700, Allan Haywood wrote:
> > I could see this as an issue, if there are pending metadata writes
> > to a filesystem, that filesystem through failure is mounted on
> > another server and used as normal, then unmounted normally, then
> > when the ports are re-activated on the server that has pending
> > metadata, is it possible this does get flushed to the disk, but
> > since the disk has been in use on another server the metadata no
> > longer matches the filesystem properly and potentially writes over
> > or changes the filesystem in a way that causes corruption.
> 
> Right.
> 
> Once you've fenced the server, you really, really need to make
> sure that it has no further pending writes that could be issued
> when the fence is removed. I'd suggest that if you failed to
> unmount the filesystem before fencing, you need to reboot that
> server to remove any possibility of it issuing stale I/O
> once it is unfenced. i.e. step 3b = STONITH.
> 
> > Would reloading the xfs module work also, to clear any pending
> > writes (if I could get it to a point where modprobe -r xfs
> > would work)? Although I am doubting that if there are pending
> > writes that it would be easy to get xfs to unload.

Correct. While a filesystem is mounted, you can't unload the XFS
module.

> > Another possibility, is there a command that will tell xfs
> > To clear any pending writes?

You can force-shutdown the filesystem then unmount it. That
is:

# xfs_io -x -c "shutdown" <mtpt>
# umount <mtpt>

See the man page for xfs_io - you want to shut down the filesystem
without forcing the log (can't do I/O).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
