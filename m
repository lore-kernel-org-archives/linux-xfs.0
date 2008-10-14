Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 20:39:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E3d2YF020644
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 20:39:04 -0700
Received: from mailgw3a.lmco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C69E54F03AE
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 20:40:44 -0700 (PDT)
Received: from mailgw3a.lmco.com (mailgw3a.lmco.com [192.35.35.7]) by cuda.sgi.com with ESMTP id QEYKc0kLAGGQM15X for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 20:40:44 -0700 (PDT)
Date: Mon, 13 Oct 2008 23:40:17 -0400
From: "Ngo, Andrew" <andrew.ngo@lmco.com>
Subject: RE: Stale XFS mount for Kernel 2.6.25.14
In-reply-to: <20081014021534.GI10716@disturbed>
Message-id: <8604545CB7815D419F5FF108D3E434BA3BD631@emss04m05.us.lmco.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-class: urn:content-classes:message
References: <8604545CB7815D419F5FF108D3E434BA3BD626@emss04m05.us.lmco.com> <20081013035939.GB10716@disturbed>
 <8604545CB7815D419F5FF108D3E434BA3BD628@emss04m05.us.lmco.com> <8604545CB7815D419F5FF108D3E434BA3BD62F@emss04m05.us.lmco.com>
 <20081014021534.GI10716@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com, "Johnson, Je" <je.johnson@lmco.com>, "Ngo, Andrew" <andrew.ngo@lmco.com>

 
What hardware do you have (including storage)?

[Andrew Ngo]Mother board: H8DA3-2
            Processor: Quad Core Opteron
            Storage: Quad SAS drives

What's the storage structure (DM, MD, iSCSI, etc)?

Output of 'xfs_info <mtpt>'?

[Andrew Ngo]xfs_info /mtpt
meta-data=/dev/sda3 isize=256 agcount=16 agsize=672219 blks
         =          sectsz=512 attr=0
data     =          bsize=4096 blocks=10755504, imaxpct=25
         =          sunit=0; swidth=0 blks, unwritten=1
naming   = version2 bsize=4096
log      = internal bsize=4096 blocks=525, version=1
                    sectsz=512  sunit=0 blocks
realtime = none     extsz=65536 blocks=0 rtextents=0

What are you really trying to acheive with the remount command?

[Andrew Ngo]This server hosts the patch directory for the developers.
When the developers are not patching software, the file system is ro.
When the developers needs to patch the software, the file system is
changed to rw.

Is the filesystem busy at the time the ro,remount is run?
(e.g. any large background writes occurring?)

[Andrew Ngo]Yes.  
Note that I make a script that performs the "mount -o rw,remount <mtpt>"
and "mount -o ro,remount <mnpt>".  When the system is not being used, I
can finish the loop of 100 mount operations; however, when the system is
being used, a couple of the above mount commands, even manually, will
cause the system to hang.

Does the problem go away if you do:

# xfs_freeze -f <mtpt>
# xfs_freeze -u <mtpt>
# mount -o ro,remount <mtpt>

[Andrew Ngo] When the mount command hangs, the above commands continue
the hang the system.

Or does the first freeze command trigger the same problem?
[Andrew Ngo] Yes, the xfs_freeze -f command hang the system, just like
the stale mount command does.

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Monday, October 13, 2008 10:16 PM
To: Ngo, Andrew
Cc: v9fs-developer@lists.sourceforge.net; xfs@oss.sgi.com; Johnson, Je
Subject: Re: Stale XFS mount for Kernel 2.6.25.14

[Andrew, Please don't top post replies - it makes it completely
impossible to folow the thread. ]

> -----Original Message-----
On Mon, Oct 13, 2008 at 10:04:27PM -0400, Ngo, Andrew wrote:
On Mon, Oct 13, 2008 at 10:04:27PM -0400, Ngo, Andrew wrote:
> 
> Dave,
> 
> Do you know of a solution to this problem?  Currently this is a major 
> impact for my system.  Thanks in advance.

I don't know what the problem is, so I certainly don't have a solution
for you. You'll need to provide a whole lot more detail about your
system and problem for us to make any sense of it.
Such as:

What hardware do you have (including storage)?

What's the storage structure (DM, MD, iSCSI, etc)?

Output of 'xfs_info <mtpt>'?

What are you really trying to acheive with the remount command?

Is the filesystem busy at the time the ro,remount is run?
(e.g. any large background writes occurring?)

Does the problem go away if you do:

# xfs_freeze -f <mtpt>
# xfs_freeze -u <mtpt>
# mount -o ro,remount <mtpt>

Or does the first freeze command trigger the same problem?

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com
