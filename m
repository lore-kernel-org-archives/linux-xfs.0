Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A09A57F58
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 05:01:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 736C0304053
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 03:01:29 -0800 (PST)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id dhWt9L1nn4x2WWhM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 03:01:27 -0800 (PST)
Message-ID: <565D7E03.20008@tlinx.org>
Date: Tue, 01 Dec 2015 03:01:23 -0800
From: "L.A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: I/O 'owner' DoS probs (was Re: Does XFS support cgroup writeback
	limiting?)
References: <5652F311.7000406@5t9.de>
	<20151123202619.GE26718@dastard>	<56538E6A.6030203@5t9.de>
	<20151123232052.GI26718@dastard>	<5655FDDA.9050502@5t9.de>
	<20151125213500.GK26718@dastard>
In-Reply-To: <20151125213500.GK26718@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com



Dave Chinner wrote:
> Metadata IO not throttled - it is owned by the filesystem and hence
> root cgroup. 
----
	Please forgive me if this is "obvious"....

	If it is owned by the file system, then logically, such meta
data wouldn't count against the user's quota limits?   That 'could'
be justified on the basis that the format of the metadata is outside
the control of file owner and depending on what's supported, included
or logged in metadata, the size could vary greatly -- all outside of the
direct control of the user.  However, by adding extended attributes,
the user can, likely, affect the disk space used by the metadata 
regardless of how it implemented and stored on disk -- so in that respect
it is user data.  Similarly, system CPU time is attributed to the user
causing the CPU time to be spent, and so on.  

	To highlight the type of problems this can cause: starting after
Windows XP, MS decided to combine network file I/O requests over 64K to
be dispatched to the 'System' daemon to optimize network I/O from
multiple processes using bigger windows to try to keep the network pipe
as full as possible (competing, of course, with QOS for conforming
apps).  

	This created a problem -- applications that flood the network
sit mostly idle waiting for their rpc call to finish and all their 
BW is attributed to System.   

	FWIW -- you cannot change any of the priorities for System
without it going all blue screen on you telling you that it's crashing
to protect you -- because something changed one of it's priority number
(IO/cpu/memory...etc).  

	Problem is that any intensive prioritizing slows everything down
and the entire computer becomes unresponsive (10Gb link) as network
requests are reduced in size. Usually it is possible to restore
normality by restarting Explorer (assuming you have enough cpu time to
do so).  About 10% of the time, pulling the network cord is required to
stop the storm, and VERY rarely, <.01% of the time power-cycling is
required.

	Attributing user-generated I/O to system processes that are "unaccountable"  *can* and does cause DoS  "opportunities"....

	Is this metadata really I/O that is completely disconnected from
a user that they cannot affect?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
