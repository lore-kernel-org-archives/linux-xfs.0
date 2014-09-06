Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9BDED7F3F
	for <xfs@oss.sgi.com>; Sat,  6 Sep 2014 17:54:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B4C7AC001
	for <xfs@oss.sgi.com>; Sat,  6 Sep 2014 15:54:33 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	b6JycGB2LCecyDBh for <xfs@oss.sgi.com>;
	Sat, 06 Sep 2014 15:54:28 -0700 (PDT)
Date: Sun, 7 Sep 2014 08:54:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Is XFS suitable for 350 million files on 20TB storage?
Message-ID: <20140906225424.GA9955@dastard>
References: <540986B1.4080306@profihost.ag>
	<20140905123058.GA29710@bfoster.bfoster>
	<5409AF40.10801@profihost.ag> <20140905230528.GO20473@dastard>
	<20140906145105.GA23506@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140906145105.GA23506@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Sat, Sep 06, 2014 at 10:51:05AM -0400, Brian Foster wrote:
> On Sat, Sep 06, 2014 at 09:05:28AM +1000, Dave Chinner wrote:
> > On Fri, Sep 05, 2014 at 02:40:32PM +0200, Stefan Priebe - Profihost AG wrote:
> > > 
> > > Am 05.09.2014 um 14:30 schrieb Brian Foster:
> > > > On Fri, Sep 05, 2014 at 11:47:29AM +0200, Stefan Priebe - Profihost AG wrote:
> > > >> Hi,
> > > >>
> > > >> i have a backup system running 20TB of storage having 350 million files.
> > > >> This was working fine for month.
> > > >>
> > > >> But now the free space is so heavily fragmented that i only see the
> > > >> kworker with 4x 100% CPU and write speed beeing very slow. 15TB of the
> > > >> 20TB are in use.
> > 
> > What does perf tell you about the CPU being burnt? (i.e run perf top
> > for 10-20s while that CPU burn is happening and paste the top 10 CPU
> > consuming functions).
> > 
> > > >>
> > > >> Overall files are 350 Million - all in different directories. Max 5000
> > > >> per dir.
> > > >>
> > > >> Kernel is 3.10.53 and mount options are:
> > > >> noatime,nodiratime,attr2,inode64,logbufs=8,logbsize=256k,noquota
> > > >>
> > > >> # xfs_db -r -c freesp /dev/sda1
> > > >>    from      to extents  blocks    pct
> > > >>       1       1 29484138 29484138   2,16
> > > >>       2       3 16930134 39834672   2,92
> > > >>       4       7 16169985 87877159   6,45
> > > >>       8      15 78202543 999838327  73,41
> > 
> > With an inode size of 256 bytes, this is going to be your real
> > problem soon - most of the free space is smaller than an inode
> > chunk so soon you won't be able to allocate new inodes, even though
> > there is free space on disk.
> > 
> 
> The extent list here is in fsb units, right? 256b inodes means 16k inode
> chunks, in which case it seems like there's still plenty of room for
> inode chunks (e.g., 8-15 blocks -> 32k-64k).

PEBKAC. My bad.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
