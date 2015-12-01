Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 546077F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 14:45:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 446B38F8040
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 12:45:51 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	712UOjox6ncMVHx5 for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 12:45:49 -0800 (PST)
Date: Wed, 2 Dec 2015 07:45:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151201204535.GX19199@dastard>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<CAD-J=zY=A8MQLzykox276cHiH7ddXHFVp0w0B4XRBskv6YK_WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAD-J=zY=A8MQLzykox276cHiH7ddXHFVp0w0B4XRBskv6YK_WQ@mail.gmail.com>
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
To: Glauber Costa <glauber@scylladb.com>
Cc: Avi Kivity <avi@scylladb.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Dec 01, 2015 at 09:01:13AM -0500, Glauber Costa wrote:
> On Tue, Dec 1, 2015 at 8:58 AM, Avi Kivity <avi@scylladb.com> wrote:
> > On 12/01/2015 03:11 PM, Brian Foster wrote:
> >> It sounds to me that first and foremost you want to make sure you don't
> >> have however many parallel operations you typically have running
> >> contending on the same inodes or AGs. Hint: creating files under
> >> separate subdirectories is a quick and easy way to allocate inodes under
> >> separate AGs (the agno is encoded into the upper bits of the inode
> >> number).
> >
> >
> > Unfortunately our directory layout cannot be changed.  And doesn't this
> > require having agcount == O(number of active files)?  That is easily in the
> > thousands.
> 
> Actually, wouldn't agcount == O(nr_cpus) be good enough?

Not quite. What you need is agcount ~= O(nr_active_allocations).

The difference is an allocation can block waiting on IO, and the
CPU can then go off and run another process, which then tries to do
an allocation. So you might only have 4 CPUs, but a workload that
can have a hundred active allocations at once (not uncommon in
file server workloads).

On worklaods that are roughly 1 process per CPU, it's typical that
agcount = 2 * N cpus gives pretty good results on large filesystems.
If you've got 400GB filesystems or you are using spinning disks,
then you probably don't want to go above 16 AGs, because then you
have problems with maintaining continugous free space and you'll
seek the spinning disks to death....

> >> 'mount -o ikeep,'
> >
> >
> > Interesting.  Our files are large so we could try this.

Keep in mind that ikeep means that inode allocation permanently
fragments free space, which can affect how large files are allocated
once you truncate/rm the original files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
