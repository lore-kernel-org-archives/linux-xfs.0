Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 511B77F60
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 08:28:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E4E98F8087
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 06:28:50 -0800 (PST)
Received: from internal-smtp3.wesleyan.edu (internal-smtp3.wesleyan.edu
	[129.133.6.182]) by cuda.sgi.com with ESMTP id LDjA3eO9sleCcYfH
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Jan 2014 06:28:48 -0800 (PST)
From: "C. Morgan Hamill" <chamill@wesleyan.edu>
In-reply-to: <52E99504.4030902@hardwarefreak.com>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <1391005406-sup-1881@al.wesleyan.edu>
	<52E91923.4070706@sandeen.net>
	<1391022066-sup-5863@al.wesleyan.edu>
	<52E99504.4030902@hardwarefreak.com>
Date: Thu, 30 Jan 2014 09:28:45 -0500
Message-Id: <1391090527-sup-4664@al.wesleyan.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan <stan@hardwarefreak.com>
Cc: xfs <xfs@oss.sgi.com>

First, thanks very much for your help.  We're weening ourselves off
unnecessarily expensive storage and as such I unfortunately haven't had
as much experience with physical filesystems as I'd like.  I am also
unfamiliar with XFS.  I appreciate the help immensely.

Excerpts from Stan Hoeppner's message of 2014-01-29 18:55:48 -0500:
> This is not correct.  You must align to either the outer stripe or the
> inner stripe when using a nested array.  In this case it appears your
> inner stripe is RAID6 su 128KB * sw 12 = 1536KB.  You did not state your
> outer RAID0 stripe geometry.  Which one you align to depends entirely on
> your workload.

Ahh this makes sense; it had occurred to me that something like this
might be the case.  I'm not exactly sure what you mean by inner and
outer; I can imagine it going both ways.

Just to clarify, it looks like this:

     XFS     |      XFS    |     XFS      |      XFS
---------------------------------------------------------
                    LVM volume group
---------------------------------------------------------
                         RAID 0
---------------------------------------------------------
RAID 6 (14 disks) | RAID 6 (14 disks) | RAID 6 (14 disks)
---------------------------------------------------------
                    42 4TB SAS disks

...more or less.

I agree that it's quite weird, but I'll describe the workload and the
constraints.

We're using commercial backup software to provide backup needs for the
University I work at (CrashPlan Pro enterprisey whathaveyou server).
We've got perhaps 1200 or so user desktops and 1 few hundred servers on
top of that, all of which currently adds up to just under 100TB on our
old backup system which we're moving from (IBM Tivoli).

So this archive will be our primary store for on-site backups.
CrashPlan is more or less continually transferring some amount of data
from clients to itself, which it does all at once in a bundle after
determining what's changed. It ends up storing archives on disk as files
which look to max out at 4GB each before it opens up the next one.

Writes are probably more important than reads, as restores are
relatively infrequent, so I'd like to optimize for writes.  I expect the
bottleneck to be IO as the campus is predominantly 1Gbps throughout
and will become 10Gbps is the not-that-distant future, most likely.
I can virtually guarantee CPU will not be the bottleneck.

Now, here's the constraints, which is why I was planning on setting
things up as above:

  - This is a budget job, so sane things like RAID 10 are our.  RAID
    6 or 60 are (as far as I can tell, correct me if I'm wrong) our only
    real options here, as anything else either sacrifices too much
    storage or is too susceptible failure from UREs.

  - I need to expose, in the end, three-ish (two or four would be OK)
    filesystems to the backup software, which should come fairly close
    to minimizing the effects of the archive maintenance jobs (integrity
    checks, mostly).  CrashPlan will spawn 2 jobs per store point, so
    a max of 8 at any given time should be a nice balance between
    under-utilizing and saturating the IO.

So I had thought LVM over RAID 60 would make sense because it would give
me the option of leaving a bit of disk unallocated and being able to
tweak filesystem sizes a bit as time goes on.

Now that I think of it though, perhaps something like 2 or 3 RAID6
volumes would make more sense, with XFS directly on top of them.  In
that case I have to balance number of volumes against the loss of
2 parity disks, however.

I'm not sure how best to proceed; any advice would be invaluable.
--
Morgan Hamill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
