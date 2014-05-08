Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BA0D27F5D
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B53A7304059
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 01:19:56 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AUdsw9CPvVj7q2BM for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 01:19:54 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WiJYV-0001is-4B
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WiJYV-0006vy-3C
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 00/18] xfs: directory/attribute geometry abstraction
Date: Thu,  8 May 2014 18:19:30 +1000
Message-Id: <1399537188-26509-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

As I mentioned in the in-kernel libxfs reowrk thread, there's a
problem with the libxfs code being dependent on the struct
xfs_mount, which is defined externally to libxfs.

The series stemmed from that as a way of working out the issues with
untangling the circular dependency mess. Essentially all the da code
is dependent on the struct xfs-mount for directory and attribute
tree configuration - block sizes, merge thresholds, etc. These all
need to be defined and managed by the libxfs code itself, and the
external code should just manage it.

So, this patchset removes one of the dependencies from the da code
by adding a geometry structure to the xfs_da_args that contains all
the necessary information from the struct xfs_mount. In doing this
abstraction, I realised that this is exactly the abstraction needed
to do per-inode directory block size configuration rather than have
it be fixed for the entire filesystem by the superblock. So the
patch set also sets the ground work for that.

It also opens some other interesting avenues - the directory
geometry is really just a specialised data fork allocation policy
structure. I'll leave the reader to follow that to it's logical
conclusion....

Now, this patchset is currently only compile tested - if you try to
run it, it will eat all your Precious' and then ask "Please, Sir,
can I have some more?". There are things that I've noticed in later
patches that need fixing in earlier patches and I've just left them
with an XXX in place, so there's no need to tell me that work needs
to be done to fix this ;)

I am posting it, however, to demonstrate the process which I think
we need to take to properly abstract the core XFS code from both the
kernel glue layer and the userspace layer. I'm looking for early
feedback for this in the context of the libxfs-in-kernel branch I
posted a couple of days ago. I don't want to get 90% into a
restructure and then have people say "No, this is wrong!".

Eventually, I'd like to have the libxfs code be completely
indepenent of the struct xfs_mount, and the external struct
xfs_mount just hold a bunch of structures it passes to the libxfs
code. It'll take quite a bit of work to get there, but if I'm going
to be using libxfs as the core infrastructure of a smart block
device, I don't want to carry an xfs_mount around at all....

So, flames, comments, deep thoughts, ponderings, straight jackets,
and so on are all welcome! just don't try to run the code ;)

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
