Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 527467F78
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 00:23:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4C52AC006
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 22:23:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FXizr3gR03iks0cK for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 22:23:25 -0700 (PDT)
Date: Wed, 10 Sep 2014 15:23:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corrupted files
Message-ID: <20140910052303.GB27048@dastard>
References: <540F1B01.3020700@mygrande.net> <20140909220645.GH20518@dastard>
	<540FA586.9090308@mygrande.net> <20140910015331.GJ20518@dastard>
	<540FC135.8010601@mygrande.net> <20140910033331.GA27048@dastard>
	<540FD8DE.7090306@mygrande.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540FD8DE.7090306@mygrande.net>
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
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: xfs@oss.sgi.com

On Tue, Sep 09, 2014 at 11:51:42PM -0500, Leslie Rhorer wrote:
> On 9/9/2014 10:33 PM, Dave Chinner wrote:
> >On Tue, Sep 09, 2014 at 10:10:45PM -0500, Leslie Rhorer wrote:
> >>On 9/9/2014 8:53 PM, Dave Chinner wrote:
> >>>On Tue, Sep 09, 2014 at 08:12:38PM -0500, Leslie Rhorer wrote:
> >>>>On 9/9/2014 5:06 PM, Dave Chinner wrote:
> >>	I've never used git on a package maintained in my distro.  Will I
> >>have issues when I upgrade to Debian Jessie in a few months, since
> >>this is not being managed by apt / dpkg?  It looks like Jessie has
> >>3.2.1 of xfs-progs.
> >
> >If you're using debian you can build debian packages directly from
> >the git tree via "make deb" (I use it all the time for pushing
> >new builds to my test machines) and so when you upgrade to Jessie it
> >should just replace your custom built package correctly...
> 
> 	Thanks a ton, Dave (and everyone else who helped).  That seems to
> have worked just fine.  The three grunged entries are gone and the
> system is happily copying over the backups.  Now I'll run another
> rsync with checksum to make sure everything is good before putting
> the backup into production.  I'm also going to upgrade the
> controller BIOS just in case.

Good to hear. Hopefully everything will check out. Just yell if you
need more help. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
