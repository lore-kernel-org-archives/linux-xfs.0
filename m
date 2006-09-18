Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 13:45:46 -0700 (PDT)
Received: from limpet.umeoce.maine.edu (limpet.umeoce.maine.edu [130.111.192.115])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8IKjbZd006847
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 13:45:38 -0700
Date: Mon, 18 Sep 2006 16:44:59 -0400 (EDT)
From: Steve Cousins <cousins@limpet.umeoce.maine.edu>
Reply-To: cousins@umit.maine.edu
Subject: Re: swidth with mdadm and RAID6
In-Reply-To: <fc.004c4d192b2c45a93b9aca00fc3f0f38.2b2c4b4d@umit.maine.edu>
Message-ID: <Pine.LNX.4.10.10609181639000.1732-100000@limpet.umeoce.maine.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: "\"xfs@oss.sgi.com\" <xfs@oss.sgi.com>" <xfs@oss.sgi.com>


Hi again,

Still no luck with 2.8.11:

[root@juno xfsprogs-2.8.11]# cd mkfs

[root@juno mkfs]# ./mkfs.xfs -f /dev/md0
meta-data=/dev/md0               isize=256    agcount=32, agsize=30524160
blks
         =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=976772992, imaxpct=25
         =                       sunit=16     swidth=144 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks
realtime =none                   extsz=589824 blocks=0, rtextents=0

Since I have a spare in there do you think it is starting with md.nr_disks
= 11 and then subtracting two?

Thanks,

Steve
______________________________________________________________________
 Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
 Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
 Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302

On Mon, 18 Sep 2006, Shailendra Tripathi wrote:

> Hi Steve,
>                Both of us are using old xfsprogs. It is handled in new 
> xfsprogs. 
> 
>  */
> 		switch (md.level) {
> 		case 6:
> 			md.nr_disks--;
> 			/* fallthrough */
> 		case 5:
> 		case 4:
> 			md.nr_disks--;
> 			/* fallthrough */
> 		case 1:
> 		case 0:
> 		case 10:
> 			break;
> 		default:
> 			return 0;
> 
> 
> Regards,
> 
> Shailendra Tripathi wrote:
> 
> >> Hi Steve,
> >>            I checked the code and it appears that XFS is not *aware* 
> >> of RAID6. Basically, for all md devices, it gets the volume info by 
> >> making a an ioctl call. I can see that XFS only take care of level 4 
> >> and level 5. It does not account for level 6.
> >> Only extra line need to be added here as below:
> >>
> >> if (md.level == 6)
> >>     md.nr_disks -= 2; /* RAID 6 has  2  parity disks */
> >> You can try with this change if you can. Do let mew know if it solves 
> >> your problem.
> >>
> >> This code is in function: md_get_subvol_stripe in <xf_progs>/libdisk/md.c
> >>
> >>
> >>               /* Deduct a disk from stripe width on RAID4/5 */
> >>                if (md.level == 4 || md.level == 5)
> >>                        md.nr_disks--;
> >>
> >>                /* Update sizes */
> >>                *sunit = md.chunk_size >> 9;
> >>                *swidth = *sunit * md.nr_disks;
> >>
> >>                return 1;
> >>        }
> >>
> >> Regards,
> >> Shailendra
> >> Steve Cousins wrote:
> >>
> >>> Hi Shailendra,
> >>>
> >>> Here is the info:
> >>>
> >>> 1. [root@juno ~]# cat /proc/mdstat Personalities : [raid6] md0 : 
> >>> active raid6 sdb[0] sdl[10](S) sdk[9] sdj[8] sdi[7] sdh[6] sdg[5]
> >>> sdf[4] sde[3] sdd[2] sdc[1]
> >>>      3907091968 blocks level 6, 64k chunk, algorithm 2 [10/10]
> >>> [UUUUUUUUUU]
> >>>      unused devices: <none>
> >>>
> >>> 2. mdadm --create /dev/md0 --chunk=64 --level=6 --raid-devices=10
> >>> --spare-devices=1 /dev/sd[bcdefghijkl]
> >>>
> >>> 3.  [root@juno ~]# xfs_db -r /dev/md*
> >>> xfs_db> sb
> >>> xfs_db> p
> >>> magicnum = 0x58465342
> >>> blocksize = 4096
> >>> dblocks = 976772992
> >>> rblocks = 0
> >>> rextents = 0
> >>> uuid = 04b32cce-ed38-496f-811f-2ccd51450bf4
> >>> logstart = 536870919
> >>> rootino = 256
> >>> rbmino = 257
> >>> rsumino = 258
> >>> rextsize = 144
> >>> agblocks = 30524160
> >>> agcount = 32
> >>> rbmblocks = 0
> >>> logblocks = 32768
> >>> versionnum = 0x3d84
> >>> sectsize = 4096
> >>> inodesize = 256
> >>> inopblock = 16
> >>> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> >>> blocklog = 12
> >>> sectlog = 12
> >>> inodelog = 8
> >>> inopblog = 4
> >>> agblklog = 25
> >>> rextslog = 0
> >>> inprogress = 0
> >>> imax_pct = 25
> >>> icount = 36864
> >>> ifree = 362
> >>> fdblocks = 669630878
> >>> frextents = 0
> >>> uquotino = 0
> >>> gquotino = 0
> >>> qflags = 0
> >>> flags = 0
> >>> shared_vn = 0
> >>> inoalignmt = 2
> >>> unit = 16
> >>> width = 144
> >>> dirblklog = 0
> >>> logsectlog = 12
> >>> logsectsize = 4096
> >>> logsunit = 4096
> >>> features2 = 0
> >>> xfs_db>
> >>>
> >>> Thanks for the help.
> >>>
> >>> Steve
> >>>
> >>> ______________________________________________________________________
> >>> Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
> >>> Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
> >>> Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302
> >>>
> >>> On Mon, 18 Sep 2006, Shailendra Tripathi wrote:
> >>>
> >>>  
> >>>
> >>>> Can you list the output of
> >>>> 1. cat /proc/mdstat
> >>>> 2. the command to create 8+2 RAID6 with one spare ?
> >>>> 3. and output of following:
> >>>>    xfs_db -r /dev/md*
> >>>>    xfs_db> sb
> >>>>    xfs_db> p
> >>>>
> >>>> -shailendra
> >>>>
> >>>> Steve Cousins wrote:
> >>>>   
> >>>>
> >>>>>> I have a RAID6 array of 11 500 GB drives using mdadm.  There is one
> >>>>>> hot-spare so the number of data drives is 8.  I used mkfs.xfs with
> >>>>>> defaults to create the file system and it seemed to pick up the 
> >>>>>> chunk size
> >>>>>> I used correctly (64K) but I think it got the swidth wrong.  Here 
> >>>>>> is what
> >>>>>> xfs_info says:
> >>>>>>
> >>>>>> =========================================================================== 
> >>>>>>
> >>>>>> meta-data=/dev/md0               isize=256    agcount=32, 
> >>>>>> agsize=30524160
> >>>>>> blks
> >>>>>>         =                       sectsz=4096  attr=0
> >>>>>> data     =                       bsize=4096   blocks=976772992, 
> >>>>>> imaxpct=25
> >>>>>>         =                       sunit=16     swidth=144 blks, 
> >>>>>> unwritten=1
> >>>>>> naming   =version 2              bsize=4096
> >>>>>> log      =internal               bsize=4096   blocks=32768, version=2
> >>>>>>         =                       sectsz=4096  sunit=1 blks
> >>>>>> realtime =none                   extsz=589824 blocks=0, rtextents=0
> >>>>>> =========================================================================== 
> >>>>>>
> >>>>>>
> >>>>>> So, sunit*bsize=64K, but swidth=144 and swidth/sunit=9 so it looks 
> >>>>>> like it
> >>>>>> thought there were 9 data drives instead of 8. 
> >>>>>> Am I diagnosing this correctly?  Should I recreate the array and
> >>>>>> explicitly set sunit=16 and swidth=128?
> >>>>>>
> >>>>>> Thanks for your help.
> >>>>>>
> >>>>>> Steve
> >>>>>> ______________________________________________________________________ 
> >>>>>>
> >>>>>> Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
> >>>>>> Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
> >>>>>> Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302
> >>>>>>
> >>>>>>
> >>>>>>       
> >>>>>
> >>>
> >>>  
> >>>
> >>
> >>
> >
> >
> 
