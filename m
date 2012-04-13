Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DBwGcs036107 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 06:58:16 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AQEsUVCO3iFoI0fC for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 04:58:14 -0700 (PDT)
Date: Fri, 13 Apr 2012 21:58:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfstests: sync before umount to avoid device busy
	problems
Message-ID: <20120413115812.GP6734@dastard>
References: <1334310586-2281-1-git-send-email-tmarek@redhat.com>
	<1334310586-2281-4-git-send-email-tmarek@redhat.com>
	<4F87FF3D.7030803@giantdisaster.de>
	<alpine.LFD.2.00.1204131249390.14961@dhcp-27-109.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1204131249390.14961@dhcp-27-109.brq.redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>, xfs@oss.sgi.com

On Fri, Apr 13, 2012 at 12:57:20PM +0200, Lukas Czerner wrote:
> On Fri, 13 Apr 2012, Stefan Behrens wrote:
> > On 4/13/2012 11:49 AM, tmarek@redhat.com wrote:
> > > From: Tom Marek <tmarek@redhat.com>
> > > 
> > > Some tests might fail because of 'device or resource busy' when unmounting
> > > either the SCRATCH or the TEST device. The reason this happenes is that
> > > some processes might not have time to finish properly, or they are still
> > > waiting for IO. The sync command was added before unmount into
> > > _scratch_unmount() and umount_or_remount_ro which should help processes to
> > > finish before unmounting takes place and thus it solves the problem.
> > > This fixes for example tests 226 and 247.
> > > 
> > > Test 226 uses plain umount command which suffers from exactly the same problem
> > > as described above. Use fixed _scratch_unmount() instead of plain umount fixes
> > > this problem.
....
> > 
> > If a xfstest process is still running when _scratch_umount() is called,
> > that xfstest is wrong and needs to be fixed IMO.
> 
> I agree, however some tests does not explicitly wait for all processes
> to finish. It is kind of hard to see why 226 has this problem, since
> there are no processes running on background, but sync certainly seems
> to help. It seems to be just a matter of timing though.

Which indicates a problem that needs to be understood, not hidden.

> > If a system or filesystem thread is still running and umount fails to
> > handle it, the system or filesystem needs to be fixed IMO.
> > 
> > xfstests shall uncover issues, not hide them.
> 
> I do not think this is fs issue at all.

There are no background threads in 226, so if the unmount is failing
then there is something wrong with the unmount process.  Indeed, 226
is doing direct Io writes prior to unmount, so the only dirty
objects should be the inode and free space indexing metadata. If
unmount is failing to handle this, we need to know why....

So I definitely agree with Stefan on this one - adding a sync before
unmount looks like hiding a problem rather than solving it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
