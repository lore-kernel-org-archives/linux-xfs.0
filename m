Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9J1faWK058625 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 20:41:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E0971002F9
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 18:42:47 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	eAGXuMfsVE1zDywK for <xfs@oss.sgi.com>;
	Mon, 18 Oct 2010 18:42:47 -0700 (PDT)
Date: Tue, 19 Oct 2010 12:42:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Performance degeneration issues
Message-ID: <20101019014245.GN29677@dastard>
References: <2a05-4cbc6280-f8f-3364a400@207442557>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2a05-4cbc6280-f8f-3364a400@207442557>
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
To: Markus Roth <Markus.Roth@uni-konstanz.de>
Cc: xfs@oss.sgi.com

On Mon, Oct 18, 2010 at 05:07:33PM +0200, Markus Roth wrote:
> Hello,
> 
> I'm running a Centos 5.4 x64 Server with Raid0 HDDs and XFS.

What's the layout of you storage? how many disks, size, etc.
How much RAM, number of CPUs in your server?

Also, what's the output of of 'xfs_info <mntpt>'?

> I did some performance tweaking according to [1] as performance
> was not good enough with std. options.

Using information from a 7 year old web page about how someone
optimised their filesystem for a specific bonnie++ workload
is not really a good place to start when it comes to real-world
optimisation.

> Extracting a tar archive with 6.1 million files (avg. Size just
> below 2KiB) is blazingly fast after the fs has been generated. But
> after some time while doing deletes/moves (need to sort those
> files by their contents) the fs performance degenerates quite
> badly (from 8k file writes/sec to about 200).

You need understand why the performance falls through the floor
first, then work out what needs optimising. It may be that your sort
algorithm has exponential complexity, or you are running out of RAM,
or something else. It may not have anything at all to do with the
filesystem.

The symptoms you describe sound like the difference between
operation in cache vs out of cache (i.e. RAM speed vs disk speed),
and if so then no amount of filesystem tweaking will fix it.
However, if you describe you system and the algorithms you are using
in more detail, we might be able to help identify the cause...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
