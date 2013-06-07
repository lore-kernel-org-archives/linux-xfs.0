Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DFA257F54
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 01:11:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CEE97304082
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 23:11:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MQjVt5KoL4uZbj4h for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 23:11:01 -0700 (PDT)
Date: Fri, 7 Jun 2013 16:10:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Adding Quotas - Skip Quota check on first mount/boot
Message-ID: <20130607061023.GL29338@dastard>
References: <CAO9TOLffaO62ZtvchpKnnORuNd0GJMsqKDeAhmdSQ1mnFn1EpA@mail.gmail.com>
	<20130607035046.GJ29338@dastard>
	<CAO9TOLeJHvWXqwp8eATUuqV3Y_b_kH85CmCmxH5amJ0E_6+3+A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAO9TOLeJHvWXqwp8eATUuqV3Y_b_kH85CmCmxH5amJ0E_6+3+A@mail.gmail.com>
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
To: Adam Brenner <aebrenne@uci.edu>
Cc: xfs@oss.sgi.com

On Thu, Jun 06, 2013 at 10:25:53PM -0700, Adam Brenner wrote:
> >> We run a 14TB XFS fileserver on our cluster and want to add quota
> >> support. This is running 3.9.2-1.el6.elrepo.x86_64 kernel under CentOS
> >> 6.3 (Final).
> >
> > How many files in the filesystem?
> 
> 8,339,620 files. 11TB used / 14TB total. 8MB Used / 11GB inodes.
> 
> (on a different server below)
> 8,878,507 files. 2.1TB used / 5.5TB total. 9.3MB Used / 1.1GB inodes.
> 
> Not that many compared to our larger file systems (already have quotas
> enabled). But still a lot of files.

Not excessive, but lets have a quick think about. Say there's some
sparseness, so 25 allocated inodes to cluster, 200 IOs a second give
5,000 inodes a second, 300,000 inodes a minute, or roughly half an
hour to scan the whole lot.

I've got a filesystem with 50m inodes sitting on it right now, and
quotacheck is running at about 1200 IOPS which is giving 27,000
inodes/s (on SSDs). That's about 1.5m inodes/min, so it should
complete in 15-20min. It'd be faster, but there's another 3 VMs
banging on the same SSDs running xfstests....

So you shouldn't be CPU bound at all, and speed will be determined
by the IOPS that can be sustained by your hardware.

> > You can't. quotacheck relies on exclusive access to the filesystem,
> > and so the mount cannot process until it completes. Quotas need to
> > be consistent before you can start using the filesystem....
> >
> > Now, there's the possibility that we could parallelise quotacheck
> > because it uses bulkstat for iteration, but somebody would have to
> > find the time to do that and it won't solve your immediate problem.
> >
> > Hence I suggest just waiting for it to complete - if you have
> > millions of inodes it could hours to complete, so just let it go
> > overnight...
> 
> Okay. Thanks for the information Dave! The servers we have are
> critical in that having downtime causes a lot of unhappy users. Since
> the XFS mount point is not accessible, everything that depends on it
> needs to be taken offline -- for example users's home directories.
> 
> I was trying to research a way to avoid such a thing, but doesn't seem
> like I can. I would be interested to know, and maybe others on the
> listsrv can chime in, on what sort of time period I can expect for the
> quota check to run with 8 million files. Performing some martian math
> I get something like 4 hours? Maybe I should switch planets :-)

See my previous email about bstat.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
