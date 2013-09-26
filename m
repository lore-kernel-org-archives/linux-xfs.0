Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9BA5D7F3F
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 17:16:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 88F988F8050
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 15:16:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pVXW8bC4ACxmeDiw for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 15:16:52 -0700 (PDT)
Date: Fri, 27 Sep 2013 08:16:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues and new to the group
Message-ID: <20130926221643.GR26872@dastard>
References: <0e4201cebaae$24873680$6d95a380$@host2max.com>
	<5244234D.1010603@hardwarefreak.com>
	<100f01cebaba$0ae84280$20b8c780$@host2max.com>
	<52444BDD.9060100@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52444BDD.9060100@gmail.com>
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
To: Joe Landman <joe.landman@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 26, 2013 at 10:59:41AM -0400, Joe Landman wrote:
> On 09/26/2013 09:12 AM, Ronnie Tartar wrote:
> >Stan,
> >
> >Thanks for the reply.
> >
> >My fragmentation is:
> >
> >[root@AP-FS1 ~]# xfs_db -c frag -r /dev/xvdb1
> >actual 10470159, ideal 10409782, fragmentation factor 0.58%
> 
> This was never likely the cause ...
> 
> [...]
> 
> >This is running virtualized, definitely not a rust bucket.  It's x5570 cpus
> 
> ... well, this is likely the cause (virtualized)
> 
> >with MD3200 Array with light I/O.
> >
> >Seems like i/o wait is not problem, system% is problem.  Is this the OS
> >trying to find spot for these files?
> 
> From your previous description
> 
> >takes.  The folders are image folders that have anywhere between 5 to
> >10 million images in each folder.
> 
> The combination of very large folders, and virtualization is working
> against you.  Couple that with an old (ancient by Linux standards)
> xfs in the virtual CentOS 5.9 system, and you aren't going to have
> much joy with this without changing a few things.

Virtualisation will have nothing to do with the problem. *All* my
testing of XFS in a virtualised environment - including all the
performance testing I do. And I do it this way because even with SSD
based storage, the virtualisation overhead is less than 2% for IO
rates exceding 100,000 IOPS....

And, well, I can boot a virtualised machine in under 7s, while a
physical machine reboot takes about 5 minutes, so there's a massive
win in terms of compile/boot/test cycle times doing things this way.

> First and foremost:
> 
> Can you change from one single large folder to a heirarchical set of
> folders?  The single large folder means any metadata operation (ls,
> stat, open, close) has a huge set of lists to traverse.  It will
> work, albiet slowly.  As a rule of thumb, we try to make sure our
> users don't go much beyond 10k files/folder.  If they need to,
> building a heirarchy of folders slightly increases management
> complexity, but keeps the lists that are needed to be traversed much
> smaller.

I'll just quote what I told someone yesterday on IRC:

[26/09/13 08:00] <dchinner_> spligak: the only way to scale linux directory operations is to spread them out over multiple directories.
[26/09/13 08:00] <dchinner_> operations on a directory are always single threaded
[26/09/13 08:01] <dchinner_> and the typical limitiation is somewhere between 10-20k modification operations per second per directory
[26/09/13 08:02] <dchinner_> an empty directory will average about 15-20k creates/s out to 100k entries, expect about 7-10k creates/s at 1 million entries, and down to around 2k creates/s at 10M entries
[26/09/13 08:03] <dchinner_> these numbers are variable depending on name lengths, filesystem fragmentation, etc
[26/09/13 08:04] <dchinner_> but, in reality, for a short term file store that has lots of create and removal, you really want to hash your files over multiple directories
[26/09/13 08:05] <dchinner_> A hash that is some multiple of the AG count (e.g. 2-4x, assuming an AG count of 16+ is usually sufficient on XFS...
[26/09/13 08:05] <dchinner_> spligak: the degradation is logarithmic due to the btree-based structure of the directory indexes
.....
[26/09/13 08:11] <dchinner_> spligak: hashing obliviates the need for a dir-per-thread - it spreads the load out by only having threads that end up with hash collisions working on the same dir..

> 
> A strategy for doing this:  If your files are named "aaaa0001"
> "aaaa0002" ... "zzzz9999" or similar, then you can chop off the
> first letter, and make a directory of it, and then put all files
> starting with that letter in that directory.  Then within each of
> those directories, do the same thing with the second letter.  This
> gets you 676 directories and about 15k files per directory.  Much
> faster directory operations. Much smaller lists to traverse.

But that's still not optimal, as directory operations will then
serialise on per AG locks and so modifications will still be a
bottleneck if you only have 4 AGs in your filesystem. i.e. if you
are going to do this, you need to tailor the directory hash to the
concurrency the filesystem structure provide because more, smaller
directories are not necessarily better than fewer larger ones.

Indeed, if you're workload is dominated by random lookups, the
hashing technique is less efficient than just having one large
directory as the internal btree indexes in the XFS directory
structure are far, far more IO efficient than a multi-level
directory hash of smaller directories. The trade-off in this case is
lookup concurrency - enough directories to provide good llokup
concurrency, yet few enough that you still get the IO benefit from
the scalability of the internal directory structure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
