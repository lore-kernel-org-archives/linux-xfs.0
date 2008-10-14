Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 22:52:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E5qNxl026958
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 22:52:23 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 643D4130B7AF
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 22:54:05 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id vYydQak72pEBWfB3 for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 22:54:05 -0700 (PDT)
Date: Tue, 14 Oct 2008 16:53:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Stale XFS mount for Kernel 2.6.25.14
Message-ID: <20081014055348.GL10716@disturbed>
References: <8604545CB7815D419F5FF108D3E434BA3BD626@emss04m05.us.lmco.com> <20081013035939.GB10716@disturbed> <8604545CB7815D419F5FF108D3E434BA3BD628@emss04m05.us.lmco.com> <8604545CB7815D419F5FF108D3E434BA3BD62F@emss04m05.us.lmco.com> <20081014021534.GI10716@disturbed> <8604545CB7815D419F5FF108D3E434BA3BD631@emss04m05.us.lmco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8604545CB7815D419F5FF108D3E434BA3BD631@emss04m05.us.lmco.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Ngo, Andrew" <andrew.ngo@lmco.com>
Cc: v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com, "Johnson, Je" <je.johnson@lmco.com>

On Mon, Oct 13, 2008 at 11:40:17PM -0400, Ngo, Andrew wrote:
> What's the storage structure (DM, MD, iSCSI, etc)?
> 
> Output of 'xfs_info <mtpt>'?
> 
> [Andrew Ngo]xfs_info /mtpt
> meta-data=/dev/sda3 isize=256 agcount=16 agsize=672219 blks
>          =          sectsz=512 attr=0
> data     =          bsize=4096 blocks=10755504, imaxpct=25
>          =          sunit=0; swidth=0 blks, unwritten=1
> naming   = version2 bsize=4096
> log      = internal bsize=4096 blocks=525, version=1
>                     sectsz=512  sunit=0 blocks
> realtime = none     extsz=65536 blocks=0 rtextents=0

I think your cut-n-paste has dropped characters there - the log
cannot be that small - it must be at least 10MB in size
(2560 blocks, IIRC). Can you check this, please?

> What are you really trying to acheive with the remount command?
> 
> [Andrew Ngo]This server hosts the patch directory for the developers.
> When the developers are not patching software, the file system is ro.
> When the developers needs to patch the software, the file system is
> changed to rw.

Ok. So when a software update needs to be done, the filesystem
is made writable, correct? But once the update is done, it
then gets made RO again? how much data gets written when an
update is run?

> Is the filesystem busy at the time the ro,remount is run?
> (e.g. any large background writes occurring?)
> 
> [Andrew Ngo]Yes.  

So you try to make a busy, dirty filesystem read only while an
application is still writing to it?

> Note that I make a script that performs the "mount -o rw,remount <mtpt>"
> and "mount -o ro,remount <mnpt>".  When the system is not being used, I
> can finish the loop of 100 mount operations; however, when the system is
> being used, a couple of the above mount commands, even manually, will
> cause the system to hang.
> 
> Does the problem go away if you do:
> 
> # xfs_freeze -f <mtpt>
> # xfs_freeze -u <mtpt>
> # mount -o ro,remount <mtpt>
> 
> [Andrew Ngo] When the mount command hangs, the above commands continue
> the hang the system.

I meant using that sequence of commands instead of just a single
"mount -o ro,remount <mtpt>" to make the fs RO. They won't magically
fix anything once something is broken.

> Or does the first freeze command trigger the same problem?
> [Andrew Ngo] Yes, the xfs_freeze -f command hang the system, just like
> the stale mount command does.

Is that before or after a remount has already hung?

Next time you hang the system, please attach the output that
appears in your syslog from:

# echo t > /proc/sysrq-trigger

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
