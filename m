Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 323DE7F86
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 10:54:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 147DA304070
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 08:54:16 -0800 (PST)
Received: from torroja.dmt.upm.es (torroja.dmt.upm.es [138.4.116.3]) by
	cuda.sgi.com with ESMTP id LA20j1bn28ewJiPj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 08:54:15 -0800 (PST)
Message-ID: <1391014448.2573.95.camel@islero.dmt.upm.es>
Subject: Re: Not being able to recover a RAID 5 20 Tb partition, help needed
From: "Juan A. Sillero" <sillero@torroja.dmt.upm.es>
Date: Wed, 29 Jan 2014 17:54:08 +0100
In-Reply-To: <1391009068.4294.83.camel@montana.filmlight.ltd.uk>
References: <1391002795.2573.79.camel@islero.dmt.upm.es>
	<1391009068.4294.83.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
Reply-To: sillero@torroja.dmt.upm.es
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
To: Roger Willcocks <roger@filmlight.ltd.uk>, guillem <guillem@torroja.dmt.upm.es>
Cc: xfs@oss.sgi.com

Thanks for your comments and ideas.

I'd like to add some more information about our crash to improve the
discussion.

XFS is not to blame, it's a hardware problem. The RAID controller thinks
that it has recovered the volume, but it has not.

We used gdisk to scan if there were partitions at all, and it said that
MBR was blank, and that GPT was corrupt. gdisk detected something that
was exactly what we have in the other volumes in the same storage array
(we have other 8 almost identical volumes in the same storage array).
gdisk re-flashed MBR and GPT, and we had a partition back again, but no
XFS identifier at all. We backed up the original state of the disk
before gdisk applied the changes.

We later used TestDisk, that reports 11 different partitions at sectors
that don't make any sense to us. It also says that the volume is smaller
than what it should.

We are now dd'ing the complete volume to a larger place in case we need
to get more serious with data recovery.

Our conclusions at this point is that (probably) the RAID5 is all messed
up because the controller didn't recover the volume at all. Of course,
this has destroyed the file system.

We'd like to know your opinion about what to do next. The data is still
probably on the disks, but the RAID topology is gone.  We'd also like to
know if someone has experienced a similar hardware problem that could
give us some advice.

Thanks.

PS: Please, keep guillem in copy.

On Wed, 2014-01-29 at 15:24 +0000, Roger Willcocks wrote:
> On Wed, 2014-01-29 at 14:39 +0100, Juan A. Sillero wrote:
> > Hello,
> > 
> > We are a pioneering group in turbulence at the Polytechnic University of
> > Madrid (torroja.dmt.upm.es), running simulations in supercomputing
> > centers all around the world and hosting massive data in our data center
> > that are publicly accessible.
> > 
> > Apparently we have lost one of our partitions of 20 Tb because of a
> > under-voltage error of a power source plus a disk failure and we are
> > trying to fix it, but it does not look good so far.
> > 
> > The system is setup as follow:
> >         XFS 6.1
> >         Raid 5 (12 x 2 disks of 2 Tb each)
> >         Double disk controller managed by devmapper.
> > 
> > What we know at this point is the next:
> > 
> > 1) The topology of the disk is lost: the main-boot-record and the GPT
> > are corrupted. 
> 
> 
> Are you sure the array had a main-boot-record and GPT ? What makes you
> think they are corrupted ?
> 
> > 2) After running the testdisk utility we find 9 partitions instead of 1.
> 
> There is a good chance that the discovered partitions are backup XFS
> superblocks; their location and content may allow you to figure out the
> array topology.
> 
> 
> > 3) With gdisk we have tried to create a new main-boot-record and GPT,
> > but it has not worked. 
> 
> This was a bad idea. Do you have a copy of the original data for these
> sectors ?
> 
> > 4) We know that the blocksize is 4096 bytes, and the current capacity of
> > the raid is under 20 Tb, so we suspect that even if the disk-manager
> > says that the RAID is ok, it has not reconstructed the RAID after the
> > disk failing.
> > 
> > We are stuck right now at this point, and help would be really
> > appreciated in order to bring up the partition. We will be pleased to
> > acknowledge the group in the upcoming publications.
> > 
> > Thanks again, Juan A. Sillero 
> 
> > 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
