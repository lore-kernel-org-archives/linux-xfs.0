Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4QNGNjY099247 for <xfs@oss.sgi.com>; Wed, 26 May 2010 18:16:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 911643799AB
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 16:18:45 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	LeOJMuxpNetZgDwQ for <xfs@oss.sgi.com>;
	Wed, 26 May 2010 16:18:45 -0700 (PDT)
Date: Thu, 27 May 2010 09:18:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: noatime,nodiratime?
Message-ID: <20100526231842.GC1395@dastard>
References: <4BF3F212.5030600@hardwarefreak.com>
	<20100519182336.GA6264@infradead.org>
	<4BF43B3C.6030403@hardwarefreak.com> <4BF44105.4040902@sandeen.net>
	<4BF47859.6020808@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BF47859.6020808@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Wed, May 19, 2010 at 06:46:33PM -0500, Stan Hoeppner wrote:
> Eric Sandeen put forth on 5/19/2010 2:50 PM:
> 
> > xfs_info actually calls xfs_growfs -n, and it's only reporting on-disk
> > geometry.  I kind of doubt that'll change.  If you want to see mount
> > options, /proc/mounts is the place ... but then we don't show the
> > defaults ;)  I wonder if we should change that and be explicit about
> > every option in /proc/mounts *shrug*
> 
> IMHO the option values should be listed, whether they are the defaults or
> user defined.  XFS may be breaking convention by doing so, as it appears
> EXT2 (and probably 3/4, and other filesystems) behave the same as XFS
> currently does--no display of default settings, except rw.
> 
> > It's so hard to keep google up to date ;)
> 
> Add the information to the FAQ and it'll show up in Google indexes in short
> order, assuming you allow robots to crawl xfs.org, which IIRC, you do.
> 
> > /proc/mounts shows all mount options which were set differently from
> > defaults.
> 
> Yes.  It would be nice to see the settings regardless of default or user
> defined.  In the absence of, or in addition to this, could we get a
> consistent (default) for each setting in XFS man mount?  For example,
> barrier is listed but we're not told if it's the default.  nobarrier isn't
> even in the man page, but it's on the wiki FAQ.  The wiki FAQ tells us that
> barrier is the default.  I'm referring to the man page that comes with
> Debian 5.0.  The current man page may be updated to reflect some of these
> things, though I've not read it yet.
>
> Sorry if I seem nit-picky.  I've spent many hours trying to hunt down some
> of this information and it's been a frustrating process.  XFS rocks.
> Currently, from here, the docs don't rock yet. :(

Patches to fix up the docs will be gratefully accepted. :)
Patches to change the output of /proc/mounts might take a little
more discussion....

Note that the man pages for mount are in the util-linux package, not
anything XFS...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
