Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 926957F7C
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 04:38:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6EF2E30405F
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 02:38:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Fa5Gf1a6S5qZEbKa for <xfs@oss.sgi.com>;
	Tue, 01 Jul 2014 02:38:39 -0700 (PDT)
Date: Tue, 1 Jul 2014 19:38:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: corruption of in-memory data detected
Message-ID: <20140701093803.GH4453@dastard>
References: <CALkk6gqiwyC7HD3QvzUgecVgdr55=zW=bEA-0bqHFR4y28koxA@mail.gmail.com>
	<20140701070230.GG4453@dastard> <87vbrh1nyo.fsf@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87vbrh1nyo.fsf@gmail.com>
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

On Tue, Jul 01, 2014 at 01:29:35AM -0700, Alexandru Cardaniuc wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Mon, Jun 30, 2014 at 11:44:45PM -0700, Alexandru Cardaniuc wrote:
> >> Hi All,
>  
> >> I am having an issue with an XFS filesystem shutting down under high
> >> load with very many small files. Basically, I have around 3.5 - 4
> >> million files on this filesystem. New files are being written to the
> >> FS all the time, until I get to 9-11 mln small files (35k on
> >> average).
....
> > You've probably fragmented free space to the point where inodes cannot
> > be allocated anymore, and then it's shutdown because it got enospc
> > with a dirty inode allocation transaction.
> 
> > xfs_db -c "freespc -s" <dev>
> 
> > should tell us whether this is the case or not.
> 
> This is what I have
> 
> #  xfs_db -c "freesp -s" /dev/sda5
>    from      to extents  blocks    pct
>       1       1     657     657   0.00
>       2       3     264     607   0.00
>       4       7      29     124   0.00
>       8      15      13     143   0.00
>      16      31      41     752   0.00
>      32      63       8     293   0.00
>      64     127      12    1032   0.00
>     128     255       8    1565   0.00
>     256     511      10    4044   0.00
>     512    1023       7    5750   0.00
>    1024    2047      10   16061   0.01
>    2048    4095       5   16948   0.01
>    4096    8191       7   43312   0.02
>    8192   16383       9  115578   0.06
>   16384   32767       6  159576   0.08
>   32768   65535       3  104586   0.05
>  262144  524287       1  507710   0.25
> 4194304 7454720      28 200755934  99.51
> total free extents 1118
> total free blocks 201734672
> average free extent size 180442

So it's not freespace fragmentation, but that was just the most
likely cause. Most likely it's a transient condition where an AG is
out of space but in determining that condition the AGF was
modified. We've fixed several bugs in that area over the past few
years....

> >> Using CentOS 5.9 with kernel 2.6.18-348.el5xen
> >
> > The "enospc with dirty transaction" shutdown bugs have been fixed in
> > more recent kernels than RHEL5.
> 
> These fixes were not backported to RHEL5 kernels?

No.

> >> The problem is reproducible and I don't think it's hardware related.
> >> The problem was reproduced on multiple servers of the same type. So,
> >> I doubt it's a memory issue or something like that.
> 
> > Nope, it's not hardware, it's buggy software that has been fixed in
> > the years since 2.6.18....
> 
> I would hope these fixes would be backported to RHEL5 (CentOS 5) kernels...

TANSTAAFL.

> > If you've fragmented free space, then your ony options are:
> 
> > 	- dump/mkfs/restore - remove a large number of files from the
> > filesystem so free space defragments.
> 
> That wouldn't be fixed automagically using xfs_repair, wouldn't it?

No.

> > If you simply want to avoid the shutdown, then upgrade to a more
> > recent kernel (3.x of some kind) where all the known issues have been
> > fixed.
> 
> How about 2.6.32? That's the kernel that comes with RHEL 6.x

It might, but I don't know the exact root cause of your problem so I
couldn't say for sure.

> >> I went through the kernel updates for CentOS 5.10 (newer kernel),
> >> but didn't see any xfs related fixes since CentOS 5.9
> 
> > That's something you need to talk to your distro maintainers about....
> 
> I was worried you gonna say that :)

Theres only so much that upstream can do to support heavily patched,
6 year old distro kernels.

> What are my options at this point? Am I correct to assume that the issue
> is related to the load and if I manage to decrease the load, the issue
> is not going to reproduce itself?

It's more likely related to the layout of data and metadata on disk.

> We have been using XFS on RHEL 5
> kernels for years and didn't see this issue. Now, the issue happens
> consistently, but seems to be related to high load...

There are several different potential causes - high load just
iterates the problem space faster.

> We have hundreds of these servers deployed in production right now, so
> some way to address the current situation would be very welcomed.

I'd suggest talking to Red Hat about what they can do to help you,
especially as CentOS is a now RH distro....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
