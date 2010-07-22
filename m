Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6MMQ3T8164173 for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 17:26:03 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 656611E327A6
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 15:29:03 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	5gD5n2fgvMwtxNvU for <xfs@oss.sgi.com>;
	Thu, 22 Jul 2010 15:29:03 -0700 (PDT)
Date: Fri, 23 Jul 2010 08:29:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs: CFLAGS not passed in
Message-ID: <20100722222900.GB32635@dastard>
References: <201007220821.44314@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007220821.44314@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Thu, Jul 22, 2010 at 08:21:39AM +0200, Michael Monnerie wrote:
> I saw Christian Kujau's report yesterday with a quick fix, so maybe my 
> reports of a similar problem have been missed in the thread "rsync and 
> corrupt inodes (was xfs_dump problem)" and this is a repost:
> 
> I tried to compile xfsprogs with the "CFLAGS":
> CFLAGS="-march=athlon64-sse3 -g -Os" ./configure --prefix=/usr
> 
> No matter what I use for CFLAGS, the resulting binary repair/xfs_repair 
> is always the same. So it seems to be ignored during compile anyway. 
> Smells like a bug? Because config.status gets the CFLAGS set, it's just 
> not used during compile. Comparing a "config.status" with CFLAGS set and 
> without:

Yup, include/builddefs.in needs a line at the top something like:

CFLAGS = @CFLAGS@

To initialise CFLAGS to whatever configure decided it should be.
However, the way the flags are build in builddefs means that more
work than this is needed to allow the CFLAGS env variable to
override all the compile options that get added together....

e.g:

$ CFLAGS="-Os" ./configure
....
$ make Q=
....
gcc -MM -Os -I. -g -O2 -DNDEBUG -DVERSION=\"3.1.2\" -DLOCALEDIR=.....
....

The OPTIMIZER compile options are still included here, so there's
potential conflict just by dumbly initialising CFLAGS....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
