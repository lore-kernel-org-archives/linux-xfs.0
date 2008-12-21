Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLM93IH024583 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 16:09:03 -0600
Received: from mail-bw0-f10.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFE323C6FB
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 14:09:00 -0800 (PST)
Received: from mail-bw0-f10.google.com (mail-bw0-f10.google.com
	[209.85.218.10]) by cuda.sgi.com with ESMTP id reU2oalMIcWFizSC
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 14:09:00 -0800 (PST)
Received: by bwz3 with SMTP id 3so3743729bwz.20
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 14:08:59 -0800 (PST)
Message-ID: <7bcfcfff0812211408u6e08bf81r1c19ab5ba938b0e2@mail.gmail.com>
Date: Sun, 21 Dec 2008 17:08:58 -0500
From: "David Bernick" <dbernick@gmail.com>
Subject: Re: xfs_repair problem.
In-Reply-To: <494E766B.5080102@sandeen.net>
MIME-Version: 1.0
References: <7bcfcfff0812210703r4bd889cave8e2d60c56587e3e@mail.gmail.com>
	<494E66D9.5030704@sandeen.net>
	<7bcfcfff0812210852v6c1cd522i334de914e1e9a112@mail.gmail.com>
	<494E766B.5080102@sandeen.net>
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

So I ran an xfs_repair -v on my filesystem. While the FS was originally 12T
and 95% full. I ran xfs_repair and it throw many "out of space errors" when
it was running. That makes some sense.

I expanded it with a new device with xfs_grow. It seems to work, because the
disk is now bigger when I mount it.

When I ran xfs_repair on that (latest version), it reverts back to the
original size. Is there anything I need to do to make the xfs_growfs
permanent?

If I can make the XFS partition bigger, I can likely make it work because
then it won't run out of space! But the partition, despite saying its
"bigger" here, doesn't seem to "take" after the xfs_repair. Any ideas?

Below is the xfs_db and some other useful things.
   8    17 12695312483 sdb1
   8    33 8803844062 sdc1
   8    34 4280452000 sdc2

 --- Logical volume ---
  LV Name                /dev/docs/v5Docs
  VG Name                docs
  LV UUID                G85Zi9-s63C-yWrU-yyf0-STP6-YOhJ-6Ne3pS
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                24.01 TB
  Current LE             6293848
  Segments               3
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:5
xfs_db> sb 0
xfs_db> print
magicnum = 0x58465342
blocksize = 4096
dblocks = 6444900352
rblocks = 0
rextents = 0
uuid = f086bb71-d67b-4cc1-b622-1f10349e6a49
logstart = 1073741828
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 67108864
agcount = 97
rbmblocks = 0
logblocks = 32768
versionnum = 0x3084
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 26
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 149545792
ifree = 274
fdblocks = 4275133930
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


On Sun, Dec 21, 2008 at 12:01 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> David Bernick wrote:
> > Thanks for the help so far:
> >
> > It my output was from "sb 0". Thanks for reminding me to be explicit.
> >
> > The system is a 64-bit system with 32-GB of RAM. It's going through the
> > FS right now with XFS repair.
> > Output of xfs_repair says, "arno=3" and about 81.6% of RAM is used by
> > the process. Think 32 G will be enough to handle this task?
> > I actually don't KNOW the original error, unfortunately, when growing. I
> > came into this late.
> >
> > We're using repair 2.9.4. Worth getting a more recent version?
>
> 2.9.8 had some memory usage improvements (reductions) for repair IIRC
>
> > Kernel is - 2.6.18-92.1.1.el5
>
> heh; RHEL5 does not support xfs ;)
>
> You probably hit:
>
> TAKE 959978 - growing an XFS filesystem by more than 2TB is broken
> http://oss.sgi.com/archives/xfs/2007-01/msg00053.html
>
> I'd see if you can get centos to backport that fix (I assume you're
> using centos or at least their kernel module; if not you can backport it
> yourself...)
>
> > I "backed off" by vgsplit-ing the new physical device from the original
> > vgroup, so I was left with my original partition. I am hoping to mount
> > the original device since the "expanded" fs didn't work. I am hoping
> > xfs_repair helps that.
>
> well, you don't want to take out part of the device if the fs thinks it
> owns it now, but from the db output I think you still have the smaller
> size.
>
> I'd read through:
>
> http://oss.sgi.com/archives/xfs/2008-01/msg00085.html
>
> and see if it helps you recover.
>
> -Eric
>


[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
