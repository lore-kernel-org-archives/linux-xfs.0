Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 14:54:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9ELrFYd007855
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 14:53:17 -0700
Received: from mailgw3a.lmco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB8F81B5B036
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 14:54:56 -0700 (PDT)
Received: from mailgw3a.lmco.com (mailgw3a.lmco.com [192.35.35.7]) by cuda.sgi.com with ESMTP id V3Vuj0IrS4dAUJkS for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 14:54:56 -0700 (PDT)
Date: Tue, 14 Oct 2008 17:54:45 -0400
From: "Ngo, Andrew" <andrew.ngo@lmco.com>
Subject: RE: Stale XFS mount for Kernel 2.6.25.14
In-reply-to: <20081014055348.GL10716@disturbed>
Message-id: <8604545CB7815D419F5FF108D3E434BA3BD63B@emss04m05.us.lmco.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-class: urn:content-classes:message
References: <8604545CB7815D419F5FF108D3E434BA3BD626@emss04m05.us.lmco.com> <20081013035939.GB10716@disturbed>
 <8604545CB7815D419F5FF108D3E434BA3BD628@emss04m05.us.lmco.com> <8604545CB7815D419F5FF108D3E434BA3BD62F@emss04m05.us.lmco.com>
 <20081014021534.GI10716@disturbed> <8604545CB7815D419F5FF108D3E434BA3BD631@emss04m05.us.lmco.com>
 <20081014055348.GL10716@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com, "Johnson, Je" <je.johnson@lmco.com>, "Ngo, Andrew" <andrew.ngo@lmco.com>

Dave,

Here is the response to your questions.  Thanks...

> I think your cut-n-paste has dropped characters there - the log cannot
be that small - it 
> must be at least 10MB in size (2560 blocks, IIRC). Can you check this,
please?

[Andrew Ngo]xfs_info /mtpt
meta-data=/dev/sda3 isize=256 agcount=16 agsize=672219 blks
         =          sectsz=512 attr=0
data     =          bsize=4096 blocks=10755504, imaxpct=25
         =          sunit=0 swidth=0 blks, unwritten=1
naming   = version2 bsize=4096
log      = internal bsize=4096 blocks=5251, version=1
         =          sectsz=512  sunit=0 blks
realtime = none     extsz=65536 blocks=0 rtextents=0 

If the log size is too small, please advise on how to configure the log
to a larger size. 

> Ok. So when a software update needs to be done, the filesystem is made
writable, correct? 
> But once the update is done, it then gets made RO again? how much data
gets written when an 
> update is run?
[Andrew Ngo]It depends on the size of the patch.  

> So you try to make a busy, dirty filesystem read only while an
application is still writing 
> to it?

[Andrew Ngo]Actually, we only perform the mount ro after we patch the
softwarfe.  At that time, we have full control of the screen which means
that the system is not busy; but I don't know if the file system is
still busy under the cover.

When the file system is actually busy, the mount command should return
saying the partition is busy.  For us, it is not returning anything.  It
just hangs.

> Is that before or after a remount has already hung?
[Andrew Ngo]The xfs_freeze -f command hangs the system after the remount
has already hung.

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Tuesday, October 14, 2008 1:54 AM
To: Ngo, Andrew
Cc: v9fs-developer@lists.sourceforge.net; xfs@oss.sgi.com; Johnson, Je
Subject: Re: Stale XFS mount for Kernel 2.6.25.14

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

I think your cut-n-paste has dropped characters there - the log cannot
be that small - it must be at least 10MB in size (2560 blocks, IIRC).
Can you check this, please?

> What are you really trying to acheive with the remount command?
> 
> [Andrew Ngo]This server hosts the patch directory for the developers.
> When the developers are not patching software, the file system is ro.
> When the developers needs to patch the software, the file system is 
> changed to rw.

Ok. So when a software update needs to be done, the filesystem is made
writable, correct? But once the update is done, it then gets made RO
again? how much data gets written when an update is run?

> Is the filesystem busy at the time the ro,remount is run?
> (e.g. any large background writes occurring?)
> 
> [Andrew Ngo]Yes.  

So you try to make a busy, dirty filesystem read only while an
application is still writing to it?

> Note that I make a script that performs the "mount -o rw,remount
<mtpt>"
> and "mount -o ro,remount <mnpt>".  When the system is not being used, 
> I can finish the loop of 100 mount operations; however, when the 
> system is being used, a couple of the above mount commands, even 
> manually, will cause the system to hang.
> 
> Does the problem go away if you do:
> 
> # xfs_freeze -f <mtpt>
> # xfs_freeze -u <mtpt>
> # mount -o ro,remount <mtpt>
> 
> [Andrew Ngo] When the mount command hangs, the above commands continue

> the hang the system.

I meant using that sequence of commands instead of just a single "mount
-o ro,remount <mtpt>" to make the fs RO. They won't magically fix
anything once something is broken.

> Or does the first freeze command trigger the same problem?
> [Andrew Ngo] Yes, the xfs_freeze -f command hang the system, just like

> the stale mount command does.

Is that before or after a remount has already hung?

Next time you hang the system, please attach the output that appears in
your syslog from:

# echo t > /proc/sysrq-trigger

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

ngo@lmco.com>,
	v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com,
	"Johnson, Je" <je.johnson@lmco.com>
Message-ID: <20081014055348.GL10716@disturbed>
Received: from mailgw3b.lmco.com (mg_filter)
	by mailgw3b.lmco.com with mailout; Tue, 14 Oct 2008 01:54:09 %z
Received: from ipmail05.adl2.internode.on.net
	by mailgw3b.lmco.com with ESMTP id m9E5s5Mf015764; Tue, 14 Oct
2008 01:54:05 -0400 (EDT)
Received: from ppp121-44-93-99.lns10.syd6.internode.on.net (HELO
disturbed) ([121.44.93.99])
  by ipmail05.adl2.internode.on.net with ESMTP; 14 Oct 2008 16:23:49
+1030
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1Kpcqq-0000dZ-Lm; Tue, 14 Oct 2008 16:53:48 +1100
References:
<8604545CB7815D419F5FF108D3E434BA3BD626@emss04m05.us.lmco.com>
<20081013035939.GB10716@disturbed>
<8604545CB7815D419F5FF108D3E434BA3BD628@emss04m05.us.lmco.com>
<8604545CB7815D419F5FF108D3E434BA3BD62F@emss04m05.us.lmco.com>
<20081014021534.GI10716@disturbed>
<8604545CB7815D419F5FF108D3E434BA3BD631@emss04m05.us.lmco.com>
Subject: Re: Stale XFS mount for Kernel 2.6.25.14
To: "Ngo, Andrew" <andrew.ngo@lmco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-IronPort-AV: E=Sophos;i="4.33,407,1220193000"; 
   d="scan'208";a="229396226"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOfP80h5LF1j/2dsb2JhbAC9MoFs
X-MessageGate-spam: 116
X-MessageGate-virus: 1

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

I think your cut-n-paste has dropped characters there - the log cannot
be that small - it must be at least 10MB in size (2560 blocks, IIRC).
Can you check this, please?

> What are you really trying to acheive with the remount command?
> 
> [Andrew Ngo]This server hosts the patch directory for the developers.
> When the developers are not patching software, the file system is ro.
> When the developers needs to patch the software, the file system is 
> changed to rw.

Ok. So when a software update needs to be done, the filesystem is made
writable, correct? But once the update is done, it then gets made RO
again? how much data gets written when an update is run?

> Is the filesystem busy at the time the ro,remount is run?
> (e.g. any large background writes occurring?)
> 
> [Andrew Ngo]Yes.  

So you try to make a busy, dirty filesystem read only while an
application is still writing to it?

> Note that I make a script that performs the "mount -o rw,remount
<mtpt>"
> and "mount -o ro,remount <mnpt>".  When the system is not being used, 
> I can finish the loop of 100 mount operations; however, when the 
> system is being used, a couple of the above mount commands, even 
> manually, will cause the system to hang.
> 
> Does the problem go away if you do:
> 
> # xfs_freeze -f <mtpt>
> # xfs_freeze -u <mtpt>
> # mount -o ro,remount <mtpt>
> 
> [Andrew Ngo] When the mount command hangs, the above commands continue

> the hang the system.

I meant using that sequence of commands instead of just a single "mount
-o ro,remount <mtpt>" to make the fs RO. They won't magically fix
anything once something is broken.

> Or does the first freeze command
