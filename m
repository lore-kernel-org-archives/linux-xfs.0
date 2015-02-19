Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 497A27F56
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 15:19:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CD0F9AC003
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:19:11 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iWqg0ggGGbEGJosX for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 13:19:05 -0800 (PST)
Date: Fri, 20 Feb 2015 08:18:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Introduce permanent async buffer write IO failures
Message-ID: <20150219211852.GT12722@dastard>
References: <1424298740-25821-1-git-send-email-david@fromorbit.com>
	<54E51CC7.8040709@sandeen.net> <20150218235220.GQ4251@dastard>
	<20150219190419.GA8862@hades.maiolino.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150219190419.GA8862@hades.maiolino.org>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Feb 19, 2015 at 05:04:19PM -0200, Carlos Maiolino wrote:
> > 
> > Well, the switch is simple characterisation. What we do with that
> > error type can be much more complex, and that's why I haven't tried
> > to address those issues here. When we've sorted out what we need
> > and how we are going to configure the error handling, then we can
> > add it.
> > 
> > e.g. if we need configurable error handling, it needs to be
> > configurable for different error types, and it needs to be
> > configurable on a per-mount basis. And it needs to be configurable
> > at runtime, not just at mount time. That kind of leads to using
> > sysfs for this. e.g. for each error type we ned to handle different
> > behaviour for:
> > 
> > $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/type
> > [transient] permanent
> > $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/perm_timeout_seconds
> > 300
> > $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/perm_max_retry_attempts
> > 50
> > $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/transient_fail_at_umount
> > 1
> > 
> > And then have generic infrastructure to set it up and handle the
> > buffer errors according to the config?
> > 
> > > (I think that's accurately summing up irc-and-side-channel discussions) ;)
> > 
> > Pretty much.
> > 
> 
> talking about possible configurable error handlers, what about leave this choice
> of failure to the sysadmin? Instead a time or type based configuration what
> about something that the administrator could just say "next IO to device X
> should fail permanently"?

How is this different to just shutting down the filesystem
immediately via 'xfs_io -x -c shutdown /path/to/mnt/pt' ?

Regardless of this, leave failures as transient, then when an
error condition occurs (say thinp device ENOSPC), this will error
out on the next IO that is retried:

# echo permanent > /sys/fs/xfs/vda/meta_write_errors/enospc/type
# echo 0 > /sys/fs/xfs/vda/meta_write_errors/enospc/perm_max_retry_attempts

Will make the next device ENOSPC IO error shut the filesystem down.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
