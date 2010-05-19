Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4J0Gw0B086070 for <xfs@oss.sgi.com>; Tue, 18 May 2010 19:16:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F1729E06DF
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 17:20:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	q254cZOQkjCYAVDT for <xfs@oss.sgi.com>;
	Tue, 18 May 2010 17:20:19 -0700 (PDT)
Date: Wed, 19 May 2010 10:19:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair memory usage and stopping on "Traversing filesystem..."
Message-ID: <20100519001911.GJ2150@dastard>
References: <00FB97ED-C684-4B81-B623-AB7EBD7B7091@blackducksoftware.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <00FB97ED-C684-4B81-B623-AB7EBD7B7091@blackducksoftware.com>
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
To: Colin Wilson <cwilson@blackducksoftware.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, May 18, 2010 at 03:28:20PM -0400, Colin Wilson wrote:
> Hello all, I seem to be having the same problem as Tomasz had in
> this post to the mailing list:
> http://oss.sgi.com/archives/xfs/2009-07/msg00082.html .  Eric
> ultimately suggested running xfs_repair with the '-P' and '-o
> bhash=1024' flags to get past this problem and described what he
> thought the underlieing problem was as such:
> 
> > "This looks like some of the caching that xfs_repair does is
> > mis-sized, and it gets stuck when it's unable to find a slot for
> > a new node to cache.  IMHO that's still a bug that I'd like to
> > work out.  If it gets stuck this way, it'd probably be better to
> > exit, and suggest a larger hash size."
> 
> Currently my file system is ~50 TB in size with ~40TB in use and
> when I do the repair memory usage ends up between 10 and 11 GB
> used for most of the check.  The system currently has 12GB of ram
> not including swap.  Is this expected behavior?

Given you are running v2.9.8, I'd say yes, and one of your problems
is that repair is swapping as the base memory footprint is likely
to be in the order of 40-50GB RAM for xfs_repair.

I just ran xfs_check on an empty 51TB filesystem w/ 821 AGs to get
an idea of how much RAM an older xfs_repair will use (as it have
3.1.2 installed on my test machines). It is allocating about 115GB
of virtual memory space before consuming all the RAM+swap in the
machine before being OOM-killed.

> My concern is
> setting bhash too large and causing xfs_repair to swap for long
> periods of time.  It already takes a few days to get to Phase 6 in
> the repair.

Must be swapping, then...

> I am currently running Debian Lenny(5.0.4) with xfsprogs 2.9.8
> with linux kernel 2.6.26.  I've briefly looked through the change
> logs for newer version of xfsprogs and noticed that there were a
> few updates mentioning better memory performance or management  so
> upgrading to a newer version may be all I need.

Yup, there were major memory usage reductions in xfs-repair in
3.1.0.  Looking at the same empty filesystem as above the base
xfs_repair memory footprint is a few tens of megabytes of RAM. That
will definitely balloon to a few GB as the filesytem metadata is
read in and cached, but i doubt it will get anywhere near what 2.9.8
requires and so should be much faster.

Hence I'd start by upgrading to 3.1.2 and running with the default
options first to see whether it is faster and whether it hangs or
not before going any further.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
