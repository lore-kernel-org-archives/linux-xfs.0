Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 862C87CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 23:41:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28A54AC002
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 21:41:53 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ndVbgoQB3cGta47c for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 21:41:47 -0800 (PST)
Date: Fri, 5 Feb 2016 16:40:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs_quota: allow operation on foreign filesystem types
Message-ID: <20160205054036.GK459@dastard>
References: <1454627718-19583-1-git-send-email-david@fromorbit.com>
	<1454627718-19583-2-git-send-email-david@fromorbit.com>
	<56B3E6F3.802@sandeen.net> <56B432CB.5080709@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56B432CB.5080709@sandeen.net>
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

On Thu, Feb 04, 2016 at 11:27:39PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/4/16 6:04 PM, Eric Sandeen wrote:
> > Looks ok, but now with the new option:
> > 
> > 1) needs a manpage update
> > 2) usage() should be updated to include -f
> 
> So, I haven't quite worked out what this *is* doing, but on further reflection,
> it seems like "-f" should definitely relate to behavior which iterates over
> all filesystems.  i.e. without -f, non-xfs filesystems are skipped; with -f,
> "foreign" filesystems are included.  That was my main concern.
> 
> But if an xfs_quota command is pointed directly at a non-xfs filesystem,
> I'm not sure what's best.  Assume the user intended it, and operate on
> that fs w/o needing -f?  Or require "-f" for consistency?  What do you think?
> 
> And, we can specify multiple mount points to operate on, i.e.
> 
> xfs_quota -c "foo" /mnt/ext4 /mnt/xfs
> 
> so ... I guess I don't know if that should require -f or not.  principle of
> least surprise?  Keep old behavior of ignoring the non-xfs mount?

I think we start with requiring "-f", and if people then complain
that it's too cumbersome, we remove it and just autodetect.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
