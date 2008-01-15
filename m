Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 19:02:16 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0F328Hw017814
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 19:02:11 -0800
Received: from imo-m12.mail.aol.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D3EC51C767
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 19:02:25 -0800 (PST)
Received: from imo-m12.mail.aol.com (imo-m12.mx.aol.com [64.12.143.100]) by cuda.sgi.com with ESMTP id k7YRS6ZvtCxmE1va for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 19:02:25 -0800 (PST)
References: <8CA24C7D24953CD-93C-29C2@WEBMAIL-DG08.sysops.aol.com> <20080114225552.GU155259@sgi.com>
Subject: ***** SUSPECTED SPAM *****  Re: Optimal mkfs settings for md RAID0 over 2x3ware RAIDS
Date: Mon, 14 Jan 2008 22:02:16 -0500
In-Reply-To: <20080114225552.GU155259@sgi.com>
MIME-Version: 1.0
From: andrewl733@aol.com
Message-Id: <8CA253A2B251FC3-F4C-1FFE@WEBMAIL-MC03.sysops.aol.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: dgc@sgi.com
Cc: xfs@oss.sgi.com

Thanks for your speedy reply. Please see a follow up question below. 



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


In fact, I am testing a 64-drive SAS array today -- 4 x 16-drive RAID-5
arrays striped together with Linux RAID-0.? By your instructions, I
should do mkfs as follows: 



mkfs.xfs -d su=960k,sw=4? /dev/mdX?? where su=15*64k



However, I get back the following message: 



mkfs.xfs:? Specified data stripe unit 1920 is not the same as the volume stripe unit 512

mkfs.xfs:? Specified data stripe width 7680 is not the same as the volume stripe width 2048



The filesystem gets created. What's wrong here? In this case I have
chosen to use a Linux md RAID-0 "chunk size" of 256k.? I get a similar
message (with different numbers, of course) if I use a "chunk size" of
64k.? 



Is there an optimal ratio of 3ware "stripe size" to Linux md "chunk size" that also must come into play here? 



Thanks again in advance. 



Andrew





Cheers,

Dave.


 


________________________________________________________________________
More new features than ever.  Check out the new AOL Mail ! - http://webmail.aol.com


[[HTML alternate version deleted]]
