Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 14:55:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0EMth5e030814
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 14:55:50 -0800
Date: Tue, 15 Jan 2008 09:55:52 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Optimal mkfs settings for md RAID0 over 2x3ware RAIDS
Message-ID: <20080114225552.GU155259@sgi.com>
References: <8CA24C7D24953CD-93C-29C2@WEBMAIL-DG08.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8CA24C7D24953CD-93C-29C2@WEBMAIL-DG08.sysops.aol.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: andrewl733@aol.com
Cc: xfs@oss.sgi.com

On Mon, Jan 14, 2008 at 08:23:44AM -0500, andrewl733@aol.com wrote:
> Hello XFS list,
> 
> I am trying to figure out the optimal mkfs settings for a large
> array (i.e., 18 TB) consisting of 2 or 4 PHYSICAL 3ware RAID-5
> arrays striped together with Linux software RAID-0. As far as I
> can tell, this question about combining physical and software RAID
> has not been asked or answered on the list. 
> As I understand it, for a SINGLE 12-drive 3ware PHYSICAL Hardware
> RAID-5 created with a 3-ware-defined "stripe size" of 64K, the
> optimal mkfs setting should be: .
> 
> mkfs.xfs -d su=64k,sw=11 /dev/sdX
> 
> The question is, what is optimal if I stripe together TWO of these
> Physical Hardware RAID-5 arrays as a SOFTWARE RAID-0. Casual
> testing shows striping together two PHYSICAL RAIDS as sucn can
> yield a gain in performance of approximately 60 percent versus
> 12-drives. But in order to optimize the RAID-0 device, would the
> correct mkfs be: 
> 
> mkfs.xfs -d su=64k,sw=22 /dev/mdX
> 
> There are now 24 drives minus two for parity. Is the logic correct here? 

Depends on your workload and file mix. For lots of small files,
the above will work fine. For maximum bandwidth, it will suck.

For maximum bandwidth you want XFS to align to the start of a RAID5
lun and do full RAID5 stripe width allocations so that large
allocations do not partially overlap RAID5 luns.

i.e. with what you suggested, an allocation of 22x64k (full
filesystem stripe width) will only be aligned to the underlying
hardware in 2 of the possible 22 places it could be allocated with a
64k alignment. in the other 20 cases, you'll get one full RAID5
write to one lun, and two sets of partial RMW cycles to the other
lun because they are not full RAID5 stripe writes.  That will be
slow.

With su=11*64k,sw=2, a 22x64k allocation will always be aligned to
the underlying geometry (until you start to run out of space) and
hence both luns will do a full RAID5 stripe write and it will be
fast.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
