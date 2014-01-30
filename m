Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 382237F7C
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 14:28:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2478B8F8064
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 12:28:25 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	V05hbEgvXtP7QIZr for <xfs@oss.sgi.com>;
	Thu, 30 Jan 2014 12:28:23 -0800 (PST)
Date: Fri, 31 Jan 2014 07:28:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
Message-ID: <20140130202819.GO2212@dastard>
References: <1391005406-sup-1881@al.wesleyan.edu>
	<52E91923.4070706@sandeen.net>
	<1391022066-sup-5863@al.wesleyan.edu>
	<52E99504.4030902@hardwarefreak.com>
	<1391090527-sup-4664@al.wesleyan.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391090527-sup-4664@al.wesleyan.edu>
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
To: "C. Morgan Hamill" <chamill@wesleyan.edu>
Cc: stan <stan@hardwarefreak.com>, xfs <xfs@oss.sgi.com>

On Thu, Jan 30, 2014 at 09:28:45AM -0500, C. Morgan Hamill wrote:
> First, thanks very much for your help.  We're weening ourselves off
> unnecessarily expensive storage and as such I unfortunately haven't had
> as much experience with physical filesystems as I'd like.  I am also
> unfamiliar with XFS.  I appreciate the help immensely.
> 
> Excerpts from Stan Hoeppner's message of 2014-01-29 18:55:48 -0500:
> > This is not correct.  You must align to either the outer stripe or the
> > inner stripe when using a nested array.  In this case it appears your
> > inner stripe is RAID6 su 128KB * sw 12 = 1536KB.  You did not state your
> > outer RAID0 stripe geometry.  Which one you align to depends entirely on
> > your workload.
> 
> Ahh this makes sense; it had occurred to me that something like this
> might be the case.  I'm not exactly sure what you mean by inner and
> outer; I can imagine it going both ways.
> 
> Just to clarify, it looks like this:
> 
>      XFS     |      XFS    |     XFS      |      XFS
> ---------------------------------------------------------
>                     LVM volume group
> ---------------------------------------------------------
>                          RAID 0
> ---------------------------------------------------------
> RAID 6 (14 disks) | RAID 6 (14 disks) | RAID 6 (14 disks)
> ---------------------------------------------------------
>                     42 4TB SAS disks

So optimised for sequential IO. The time-honoured method of setting
up XFS for this if the workload is large files is to use a stripe
unit that is equal to the width of the underlying RAID6 volumes with
a stripe width of 3. That way XFS tries to align files to the start
of each RAID6 volume, and allocate in full RAID6 stripe chunks. This
mostly avoids RMW cycles for large files and sequential IO. i.e. su
= 1536k, sw = 3.

> ...more or less.
> 
> I agree that it's quite weird, but I'll describe the workload and the
> constraints.

[snip]

summary: concurrent (initially slow) sequential writes of ~4GB files.

> Now, here's the constraints, which is why I was planning on setting
> things up as above:
> 
>   - This is a budget job, so sane things like RAID 10 are our.  RAID
>     6 or 60 are (as far as I can tell, correct me if I'm wrong) our only
>     real options here, as anything else either sacrifices too much
>     storage or is too susceptible failure from UREs.

RAID6 is fine for this.

>   - I need to expose, in the end, three-ish (two or four would be OK)
>     filesystems to the backup software, which should come fairly close
>     to minimizing the effects of the archive maintenance jobs (integrity
>     checks, mostly).  CrashPlan will spawn 2 jobs per store point, so
>     a max of 8 at any given time should be a nice balance between
>     under-utilizing and saturating the IO.

So concurrency is up to 8 files being written at a time. That's
pretty much on the money for striped RAID. Much more than this and
you end up with performance being limited by seeking on the slowest
disk in the RAID sets.

> So I had thought LVM over RAID 60 would make sense because it would give
> me the option of leaving a bit of disk unallocated and being able to
> tweak filesystem sizes a bit as time goes on.

*nod*

And it allows you, in future, to add more disks and grow across them
via linear concatentation of more RAID60 luns of the same layout...

> Now that I think of it though, perhaps something like 2 or 3 RAID6
> volumes would make more sense, with XFS directly on top of them.  In
> that case I have to balance number of volumes against the loss of
> 2 parity disks, however.

Probably not worth the complexity.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
