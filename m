Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p543Fl2s052657 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 22:15:47 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFC19134754B
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 20:15:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	N3moHGbkNGgymGrT for <xfs@oss.sgi.com>;
	Fri, 03 Jun 2011 20:15:39 -0700 (PDT)
Date: Sat, 4 Jun 2011 13:15:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: I/O hang, possibly XFS, possibly general
Message-ID: <20110604031537.GF561@dastard>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<20110603004247.GA28043@infradead.org>
	<20110603013948.GX561@dastard>
	<BANLkTi=FjSzSZJXGofVjtiUe2ZNvki2R-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTi=FjSzSZJXGofVjtiUe2ZNvki2R-Q@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Paul Anderson <pha@umich.edu>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 03, 2011 at 11:59:02AM -0400, Paul Anderson wrote:
> On Thu, Jun 2, 2011 at 9:39 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jun 02, 2011 at 08:42:47PM -0400, Christoph Hellwig wrote:
> >> On Thu, Jun 02, 2011 at 10:42:46AM -0400, Paul Anderson wrote:
> >> > This morning, I had a symptom of a I/O throughput problem in which
> >> > dirty pages appeared to be taking a long time to write to disk.
> >> >
> >> > The system is a large x64 192GiB dell 810 server running 2.6.38.5 fr=
om
> >> > kernel.org - the basic workload was data intensive - concurrent large
> >> > NFS (with high metadata/low filesize), rsync/lftp (with low
> >> > metadata/high file size) all working in a 200TiB XFS volume on a
> >> > software MD raid0 on top of 7 software MD raid6, each w/18 drives. =
=A0I
> >> > had mounted the filesystem with inode64,largeio,logbufs=3D8,noatime.
> >>
> >> A few comments on the setup before trying to analze what's going on in
> >> detail. =A0I'd absolutely recommend an external log device for this se=
tup,
> >> that is buy another two fast but small disks, or take two existing ones
> >> and use a RAID 1 for the external log device. =A0This will speed up
> >> anything log intensive, which both NFS, and resync workloads are lot.
> >>
> >> Second thing if you can split the workloads into multiple volumes if y=
ou
> >> have two such different workloads, so thay they don't interfear with
> >> each other.
> >>
> >> Second a RAID0 on top of RAID6 volumes sounds like a pretty worst case
> >> for almost any type of I/O. =A0You end up doing even relatively small =
I/O
> >> to all of the disks in the worst case. =A0I think you'd be much better
> >> off with a simple linear concatenation of the RAID6 devices, even if y=
ou
> >> can split them into multiple filesystems
> >>
> >> > The specific symptom was that 'sync' hung, a dpkg command hung
> >> > (presumably trying to issue fsync), and experimenting with "killall
> >> > -STOP" or "kill -STOP" of the workload jobs didn't let the system
> >> > drain I/O enough to finish the sync. =A0I probably did not wait long
> >> > enough, however.
> >>
> >> It really sounds like you're simply killloing the MD setup with a
> >> log of log I/O that does to all the devices.
> >
> > And this is one of the reasons why I originally suggested that
> > storage at this scale really should be using hardware RAID with
> > large amounts of BBWC to isolate the backend from such problematic
> > IO patterns.
> =

> > Dave Chinner
> > david@fromorbit.com
> >
> =

> Good HW RAID cards are on order - seems to be backordered at least a
> few weeks now at CDW.  Got the batteries immediately.
> =

> That will give more options for test and deployment.
> =

> Not sure what I can do about the log - man page says xfs_growfs
> doesn't implement log moving.  I can rebuild the filesystems, but for
> the one mentioned in this theread, this will take a long time.

Once you have BBWC, the log IO gets aggregated into stripe width
writes to the back end (because it is always sequential IO), so it's
generally not a significant problem for HW RAID subsystems.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
