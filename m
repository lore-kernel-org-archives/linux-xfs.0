Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 073EA7F83
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 16:43:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96958AC00E
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 14:43:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ffr1yQVj1apVshFr for <xfs@oss.sgi.com>;
	Tue, 01 Jul 2014 14:43:18 -0700 (PDT)
Date: Wed, 2 Jul 2014 07:43:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: corruption of in-memory data detected
Message-ID: <20140701214315.GD9508@dastard>
References: <CALkk6gqiwyC7HD3QvzUgecVgdr55=zW=bEA-0bqHFR4y28koxA@mail.gmail.com>
	<20140701070230.GG4453@dastard> <87vbrh1nyo.fsf@gmail.com>
	<20140701093803.GH4453@dastard> <878uoc25y8.fsf@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <878uoc25y8.fsf@gmail.com>
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
To: Alexandru Cardaniuc <cardaniuc@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 01, 2014 at 01:13:19PM -0700, Alexandru Cardaniuc wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Tue, Jul 01, 2014 at 01:29:35AM -0700, Alexandru Cardaniuc wrote:
> >> Dave Chinner <david@fromorbit.com> writes:
> >> 
> >> > On Mon, Jun 30, 2014 at 11:44:45PM -0700, Alexandru Cardaniuc
> >> > wrote:
> >> >> Hi All,
> >>
> >> >> I am having an issue with an XFS filesystem shutting down under
> >> >> high load with very many small files. Basically, I have around
> >> >> 3.5 - 4 million files on this filesystem. New files are being
> >> >> written to the FS all the time, until I get to 9-11 mln small
> >> >> files (35k on average).
> > ....
> >> > You've probably fragmented free space to the point where inodes
> >> > cannot be allocated anymore, and then it's shutdown because it got
> >> > enospc with a dirty inode allocation transaction.
> >>
> >> > xfs_db -c "freespc -s" <dev>
> >>
> >> > should tell us whether this is the case or not.
> >>  This is what I have
> >> 
> >> # xfs_db -c "freesp -s" /dev/sda5 from to extents blocks pct 1 1 657
> >> 657 0.00 2 3 264 607 0.00 4 7 29 124 0.00 8 15 13 143 0.00 16 31 41
> >> 752 0.00 32 63 8 293 0.00 64 127 12 1032 0.00 128 255 8 1565 0.00
> >> 256 511 10 4044 0.00 512 1023 7 5750 0.00 1024 2047 10 16061 0.01
> >> 2048 4095 5 16948 0.01 4096 8191 7 43312 0.02 8192 16383 9 115578
> >> 0.06 16384 32767 6 159576 0.08 32768 65535 3 104586 0.05 262144
> >> 524287 1 507710 0.25 4194304 7454720 28 200755934 99.51 total free
> >> extents 1118 total free blocks 201734672 average free extent size
> >> 180442
> >
> > So it's not freespace fragmentation, but that was just the most likely
> > cause. Most likely it's a transient condition where an AG is out of
> > space but in determining that condition the AGF was modified. We've
> > fixed several bugs in that area over the past few years....
> 
> I still have the FS available. Any other information I can assemble to
> help you identify the issue?

Not really. Historically the only way to work out the exact problem
causing the transaction failure is to be able to reproduce the
problem on demand in a controlled environment.  Unfortunately, I
don't scale to doing this for everyone who has a problem because it
can take days to build an equivalent environment and reproduce the
problem and refine it to something that can be used to debug the
issue.

However, if you can reproduce the problem on a current upstream
kernel with a metadump image and a script that runs on the image,
then I'll definitely look at it.  i.e. if you can make it 5 minutes
work for me to reproduce the problem on an upstream kernel, then
I should be able find and solve the problem pretty quickly.

> >> >> Using CentOS 5.9 with kernel 2.6.18-348.el5xen
> >> > The "enospc with dirty transaction" shutdown bugs have been fixed
> >> > in more recent kernels than RHEL5.
> >>  These fixes were not backported to RHEL5 kernels?
> 
> > No.
> 
> I assume I wouldn't just be able to take the source for XFS kernel module
> and compile it against the 2.6.18 kernel in CentOS 5.x?

You could try, but you'd only be digging a deeper hole.  Triaging
and solving a bug like this bug is a walk in the park compared to
the issues that typically arise(*) during large scale backports to
older kernels.

Cheers,

Dave.

(*) speaking as a RH engineer who has done multiple large (several
hundred commit) XFS backports for RHEL.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
