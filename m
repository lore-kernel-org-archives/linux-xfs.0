Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o152UTBx106048 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 20:30:29 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E73491B1906
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 18:31:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	1NclDPbYEYggCNwB for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2010 18:31:37 -0800 (PST)
Date: Fri, 5 Feb 2010 13:31:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs: to -DDEBUG or not to -DDEBUG?
Message-ID: <20100205023134.GA11483@discord.disaster>
References: <4B6AFB83.1070309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B6AFB83.1070309@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Thu, Feb 04, 2010 at 10:53:23AM -0600, Eric Sandeen wrote:
> Fedora, long ago, disabled debug in the xfsprogs specfile:
> 
> http://cvs.fedoraproject.org/viewvc/F-12/xfsprogs/xfsprogs.spec?r1=1.5&r2=1.6
> 
> * Wed Apr 20 2005 Dave Jones <davej@redhat.com>
> - Disable debug. (#151438)
> 
> per this bug:  https://bugzilla.redhat.com/show_bug.cgi?id=151438
> 
> referencing this email thread:
> 
> http://oss.sgi.com/archives/linux-xfs/2005-03/msg00038.html
> which no longer exists (grrrr) but is probably now here:
> 
> http://oss.sgi.com/archives/xfs/2005-03/msg00416.html
> 
> Fedora still builds with -DNDEBUG, but the upstream tarball has
> it on by default.  I have seen several occasions where other
> distros had failing xfs_repairs which were "fixed" by disabling
> debug.  I'd like to make a decision on whether DEBUG should be
> on or off by default for upstream releases.  Any thoughts?

Personally I'd prefer the repair process to stop if it comes across
inconsistencies it can't handle. Ignoring them is as likely to "fix"
the crash as it is to corrupt the filesystem more.

On top of that we get bug reports when those problems are hit so
we can look into what caused the problem. We don't really have a
repair test suite that covers all the possible corruptions that
can occur, so we are kind of reliant on users reporting conditions
we've never had to handle before so we can fix them...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
