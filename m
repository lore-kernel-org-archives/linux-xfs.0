Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 11CEF7F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 15:41:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87995AC009
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 13:41:35 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id tt0hJHnluEtdoLUY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 13:41:34 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 15 May 2013 16:41:33 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 620756E803F
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:41:27 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r4FKfUoG208502 for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:41:30 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r4FKfTdf031047 for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:41:30 -0400
Subject: Re: Rambling noise #2: Learning to use the v8 pquota/uquota patchset
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <5191FB46.2080300@gmail.com>
References: <5191FB46.2080300@gmail.com>
Date: Wed, 15 May 2013 15:41:29 -0500
Message-ID: <1368650489.10223.5.camel@chandra-dt.ibm.com>
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
> Hi!  I seem to have no luck in getting v8 of the pquota/uquota patchset 
> working and have it pass xfstests with flying colors.  Is v8 of the 
> pquota/gquota patchset sufficient to make the new separate pquota/gquota 
> bits work?  Or is it an incremental patchset?

Hi Michael,

I will post the user level changes that accompanies these changes. 

With those changes you can do a new mkfs and use pquota and gquota
together.

Regards,

Chandra

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
> 
> 2) Nothing has oopsed.
> 
> 3) In testing using the `xfs_quota -x` command, the patches seem to 
> work.  On `mount -t xfs -o gquota` mounts, using the quota command from 
> within the xfs_quota shell, the group quotas show but not the projid 
> quotas.  On `mount -t xfs -o pquota` mounts, the projid quotas show but 
> not the gquota mounts.  This is different than the old behavior, where 
> the gquota numbers might be recycled into projid numbers.
> 
> 4) The results of `xfsquota -c print` are confusing.  Maybe they're 
> showing the XFS view when they show things like 
> 'uqnoenforce,gquota,pquota' for a mount that is gquota only.  They're 
> doubly confusing once /etc/projid and /etc/projects have been set up. 
> The 'gqnoenforce' and 'pqnoenforce' flags show up at times for reasons 
> that are unknown to me.
> 
> 5) `mount -t xfs -o gquota,pquota` is not possible at this time.
> 
> 6) The patches applied cleanly to a git Linux 3.10-rc1 kernel + xfs-oss, 
> with only whitespace errors reported.
> 
> 7) I question whether 'bsoft=' has a visible effect on projid quotas, 
> whether using your patches or not.  Did it ever work?
> 
> 8) I had no feel on whether the filesystem had to be mounted once as 
> gquota, then once as pquota, for the full dual functionality to work.
> 
> 9) It looks like xfs_repair doesn't ruin anything, but the `xfsquota -c 
> print` output looks a little different on the next mount.
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
