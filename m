Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3793B7F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:01:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BC2B7AC009
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 14:01:46 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id jbmvK0PDRnD0BGim (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 14:01:45 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 15 May 2013 17:01:44 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 069F038C8051
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 17:01:42 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r4FL1gWJ309324 for <xfs@oss.sgi.com>; Wed, 15 May 2013 17:01:42 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r4FL1fNq008807 for <xfs@oss.sgi.com>; Wed, 15 May 2013 17:01:42 -0400
Subject: Re: Rambling noise #2: Learning to use the v8 pquota/uquota patchset
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <5191FB46.2080300@gmail.com>
References: <5191FB46.2080300@gmail.com>
Date: Wed, 15 May 2013 16:01:40 -0500
Message-ID: <1368651700.10223.21.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, 2013-05-14 at 04:52 -0400, Michael L. Semon wrote:
Hi Michael,

Thanks for testing the code and providing feedback.

> Hi!  I seem to have no luck in getting v8 of the pquota/uquota patchset 
> working and have it pass xfstests with flying colors.  Is v8 of the 
> pquota/gquota patchset sufficient to make the new separate pquota/gquota 
> bits work?  Or is it an incremental patchset?
> 
> The basic functionality works, in my opinion, and I hope nobody wastes 
> time with a nice, educated reply.  It would be mostly wasted on me and 
> is better saved for somebody else.  A reply of "do this...and 
> this...btw, how did this test come out?" would be welcomed, though ;-)
> 
> Anyway, some vague observations as I grasp for straws...
> 
> 1) The xfstests quota group tests seem to fail in different ways than 
> the way they did before applying the patches.

I ran the xfstests before and after these changes with the old tool
chain and did not see any differences. Can you please tell me which
tests failed.
 
> 
> 2) Nothing has oopsed.
> 
> 3) In testing using the `xfs_quota -x` command, the patches seem to 
> work.  On `mount -t xfs -o gquota` mounts, using the quota command from 
> within the xfs_quota shell, the group quotas show but not the projid 
> quotas.  On `mount -t xfs -o pquota` mounts, the projid quotas show but 
> not the gquota mounts.  This is different than the old behavior, where 
> the gquota numbers might be recycled into projid numbers.

Since we use different fields in superblock now, this should be
expected.

> 
> 4) The results of `xfsquota -c print` are confusing.  Maybe they're 
> showing the XFS view when they show things like 
> 'uqnoenforce,gquota,pquota' for a mount that is gquota only.  They're 
> doubly confusing once /etc/projid and /etc/projects have been set up. 
> The 'gqnoenforce' and 'pqnoenforce' flags show up at times for reasons 
> that are unknown to me.

Can you please send me the exact commands you used. It will be good for
me to test and add it to xfstests.

> 
> 5) `mount -t xfs -o gquota,pquota` is not possible at this time.

yes. you need new xfstools to make it work.

> 
> 6) The patches applied cleanly to a git Linux 3.10-rc1 kernel + xfs-oss, 
> with only whitespace errors reported.
> 
> 7) I question whether 'bsoft=' has a visible effect on projid quotas, 
> whether using your patches or not.  Did it ever work?

There are some xfstests that do test bsoft. Let me know if you think
they are incorrect, we can revisit them.
> 
> 8) I had no feel on whether the filesystem had to be mounted once as 
> gquota, then once as pquota, for the full dual functionality to work.

No, you will be mounting filesystem as you did in (5) and it is supposed
to work (wait for the new tools).

> 
> 9) It looks like xfs_repair doesn't ruin anything, but the `xfsquota -c 
> print` output looks a little different on the next mount.

Lets retest with tool changes.

> 
> That's about all that could be put together in a coherent manner.  Sleep 
> awaits.
> 
> The PC is a 32-bit Pentium 4.  In addition to the kernel mentioned in 
> (6), there are a few J. Liu and Dave Chinner patches applied as well.
> 
> Best of luck!
> 
> Michael
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
