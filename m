Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 09:34:30 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0HHYQPA016435
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 09:34:26 -0800
Received: from mail.purevideo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A55F3C71EFC
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 09:34:41 -0800 (PST)
Received: from mail.purevideo.com (mail.purevideo.com [208.50.29.149]) by cuda.sgi.com with ESMTP id O9pGFzzRYD2mlNwG for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 09:34:41 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Repairing a possibly incomplete xfs_growfs command?
Date: Thu, 17 Jan 2008 09:29:22 -0800
Message-ID: <9CE70E6ED2C2F64FB5537A2973FA4F02535951@pvn-3001.purevideo.local>
In-Reply-To: <20080117030111.GH155259@sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253594C@pvn-3001.purevideo.local> <20080117030111.GH155259@sgi.com>
From: "Mark Magpayo" <mmagpayo@purevideo.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com



> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
Of
> David Chinner
> Sent: Wednesday, January 16, 2008 7:01 PM
> To: Mark Magpayo
> Cc: xfs@oss.sgi.com
> Subject: Re: Repairing a possibly incomplete xfs_growfs command?
> 
> On Wed, Jan 16, 2008 at 03:19:19PM -0800, Mark Magpayo wrote:
> > Hi,
> >
> > So I have run across a strange situation which I hope there are some
> > gurus out there to help.
> >
> > The original setup was a logical volume of 8.9TB.  I extended the
volume
> > to 17.7TB and attempted to run xfs_growfs.  I am not sure whether
the
> > command actually finished, as after I ran the command, the metadata
was
> > displayed, but there was no nothing that stated the the number of
data
> > blocks had changed.  I was just returned to the prompt, so I'm not
sure
> > whether the command completed or not..
> 
> Hmmm - what kernel and what version of xfsprogs are you using?
> (xfs_growfs -V).
> 

xfs_growfs version 2.9.4

> Also, can you post the output of the growfs command if you still
> have it?
> 
> If not, the output of:
> 
> # xfs_db -r -c 'sb 0' -c p <device>

#xfs_db -r -c 'sb 0' -c p /dev/vg0/lv0
magicnum = 0x58465342
blocksize = 4096
dblocks = 11904332800
rblocks = 0
rextents = 0
uuid = 05d4f6ba-1e9c-4564-898b-98088c163fe1
logstart = 2147483652
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 74402080
agcount = 160
rbmblocks = 0
logblocks = 32768
versionnum = 0x3094
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 27
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 1335040
ifree = 55
fdblocks = 9525955616
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0


> # xfs_db -r -c 'sb 1' -c p <device>
> 

#xfs_db -r -c 'sb 1' -c p /dev/vg0/lv0
magicnum = 0x58465342
blocksize = 4096
dblocks = 2380866560
rblocks = 0
rextents = 0
uuid = 05d4f6ba-1e9c-4564-898b-98088c163fe1
logstart = 2147483652
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 74402080
agcount = 32
rbmblocks = 0
logblocks = 32768
versionnum = 0x3094
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 27
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 1334912
ifree = 59
fdblocks = 2809815
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0

> because:
> 
> > I was unable write to the logical volume I had just created.  I
tried to
> > remount it, but I kept getting an error saying the superblock could
not
> > be read.  I tried running an xfs_repair on the filesystem, and get
the
> > following:
> >
> > Phase 1 - find and verify superblock...
> > superblock read failed, offset 19504058859520, size 2048, ag 64,
rval 0
> 
> That's a weird size for a superblock, and I suspect you should only
> have AG's numbered 0-63 in your filesystem. (a 8.9TB filesystem will
> have 32 AGs (0-31) by default, and doubling the size will take it
> up to 64).
> 
> > I am not very experienced with xfs (I was following commands in some
> > documentaion), and I was recommended to post to this mailing list.
If
> > anyone could provide some help, it would be greatly appreciate.
Also,
> > if there is any information I can provide to help, I will gladly
provide
> > it.  Thanks in advance!
> 
> Seeing as the filesystem has not mounted, I think this should be
> recoverable if you don't try to mount or write anything to the
> filesystem until we fix the geometry back up....
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 


Someone else asked for the size of the block devices... here's the
output from /proc/partitions: 

152     0 9523468862 etherd/e1.0
152    16 9523468862 etherd/e0.0


I appreciate everyone's help!

Thanks,

Mark
