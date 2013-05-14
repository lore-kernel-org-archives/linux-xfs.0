Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F8EB7F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 08:52:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C10F2AC001
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 06:52:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id VG8s9CQPoy216nch (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 May 2013 06:52:41 -0700 (PDT)
Message-ID: <519241A1.9050704@oracle.com>
Date: Tue, 14 May 2013 21:52:33 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Rambling noise #2: Learning to use the v8 pquota/uquota patchset
References: <5191FB46.2080300@gmail.com>
In-Reply-To: <5191FB46.2080300@gmail.com>
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

Hi Michael,

Have you tried this patch set with the v2 user space changes?

Looks this is the latest update from Chandra that I can searched from
the mailing list:
http://oss.sgi.com/archives/xfs/2012-07/msg00293.html

Thanks,
-Jeff
On 05/14/2013 04:52 PM, Michael L. Semon wrote:
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
