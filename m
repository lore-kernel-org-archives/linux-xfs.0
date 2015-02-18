Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A710B7FAB
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 17:52:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 866F78F8039
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 15:52:25 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XqR6pXsKnHPQRiUY for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 15:52:23 -0800 (PST)
Date: Thu, 19 Feb 2015 10:52:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Introduce permanent async buffer write IO failures
Message-ID: <20150218235220.GQ4251@dastard>
References: <1424298740-25821-1-git-send-email-david@fromorbit.com>
	<54E51CC7.8040709@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54E51CC7.8040709@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Feb 18, 2015 at 05:14:15PM -0600, Eric Sandeen wrote:
> On 2/18/15 4:32 PM, Dave Chinner wrote:
> >  	/*
> > -	 * If the write of the buffer was synchronous, we want to make
> > -	 * sure to return the error to the caller of xfs_bwrite().
> > +	 * Repeated failure on an async write.
> > +	 *
> > +	 * Now we need to classify the error and determine the correct action to
> > +	 * take. Different types of errors will require different processing,
> > +	 * but make the default classification "transient" so that we keep
> > +	 * retrying in these cases.  If this is the wrog thing to do, then we'll
> > +	 * get reports that the filesystem hung in the presence of that type of
> > +	 * error and we can take appropriate action to remedy the issue for that
> > +	 * type of error.
> >  	 */
> 
> So, I think this is the tricky part.
> 
> No errno has a universal meaning, and we don't know what kind of block device
> we're talking to.  One device's ENOSPC may be another's EIO, and either may or
> may not be permanent, maybe ENODEV *isn't* permanent.  (...is it always permanent?)

When a device is unplugged and then plugged back in it comes back as
a different device. So, AFAICT, if the device goes away then we'll
never be able to recover because the underlying block device never
comes back...

> My first feeble hack at this was counting consecutive errors, and
> hard failing after a set number.  Thinking about that later, it
> seems like something time-based might be better than
> io-count-based.

Possibly. IOs usually timeout after 30s, so EIO is going to have to
be delayed at least for long enough for things like FC transport
reconnect periods (worse case is 240s, IIRC) regardless of the
number of IOs...

> Can we really simply switch on an error?  If nothing else, this might have
> to be configurable somehow, so that an admin can choose which errors for
> which device are desired to be "permanent."

Well, the switch is simple characterisation. What we do with that
error type can be much more complex, and that's why I haven't tried
to address those issues here. When we've sorted out what we need
and how we are going to configure the error handling, then we can
add it.

e.g. if we need configurable error handling, it needs to be
configurable for different error types, and it needs to be
configurable on a per-mount basis. And it needs to be configurable
at runtime, not just at mount time. That kind of leads to using
sysfs for this. e.g. for each error type we ned to handle different
behaviour for:

$ cat /sys/fs/xfs/vda/meta_write_errors/enospc/type
[transient] permanent
$ cat /sys/fs/xfs/vda/meta_write_errors/enospc/perm_timeout_seconds
300
$ cat /sys/fs/xfs/vda/meta_write_errors/enospc/perm_max_retry_attempts
50
$ cat /sys/fs/xfs/vda/meta_write_errors/enospc/transient_fail_at_umount
1

And then have generic infrastructure to set it up and handle the
buffer errors according to the config?

> (I think that's accurately summing up irc-and-side-channel discussions) ;)

Pretty much.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
