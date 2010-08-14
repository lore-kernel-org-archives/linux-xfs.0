Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7EKlgwe161207 for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 15:47:43 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABEF5CB053B
	for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 13:57:05 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id r5cA2ftH5v02iFdL for
	<xfs@oss.sgi.com>; Sat, 14 Aug 2010 13:57:05 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7EKm11k023216 for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 13:48:03 -0700
Message-ID: <4C670101.8050901@tlinx.org>
Date: Sat, 14 Aug 2010 13:48:01 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfs.fsck change that is unhelpful
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>


Some time ago, when I upgraded a system, I ran into problems when
it hit a file system that was offline.  It wasn't a critical partition, 
so it normally wouldn't have been an issue, but somewhere along the line
someone mangled fsck.xfs. 

Instead of doing the useful thing with an xfs file system and being a
link to ->/bin/true, someone thought it would be neat to return failure if
it couldn't find the file system that it was supposed to check 
(mount-by-name, name not yet present, => system refuse to boot).  

I asked suse why they put this check in and they said it had been done upstream.

This was a bit back, but it keeps biting me with new revisions until I 
replace it with a link to /bin/true.

Note: if it actually did a check that was supposed to be done prior to 
mounting each file system, like ext2 or such, I wouldn't be doing such 
and probably wouldn't be using the file system if there was an 
alternative.  I'd rather have the system come up to the best of its 
ability rather than failing for no good reason.


So, I'm here - asking, if this was done here, why?  It serves a _less_ 
_than__useful_ _purpose_ --in that it hinders what is usually a perfectly functional system from coming up where after _REMOTELY_ logging in, 
the problem could be noted, debugged, and perhaps even fixed remotely.
In the case of a /dev/Space/Test, file system, it might not be
necessary to do anything immediately.

I see absolutely no useful purpose served by this.  If it's a key
file system (which in my case, it never has been -- it's the 
"peripheral file systems" that have occasionally been absent upon 
boot, the core file systems being located in the machine).

In my systems design, I'm in the camp that subscribe to having redundancy
present to automatically work around problems and continue working as
best as possible in the presence of any problem.  I'm not in the camp of
designing a 'human', who has a cut finger to immediately go unconscious
due to a 'fault' in their skin integrity.  Ideally you want the brain to
come up so it can assess and deal with damage -- at least from my point
of view.  So I don't understand this 'change'.

Would it be unreasonable to request that this behavior be reverted?  In 
my case, at least, it seems only to cause more harm than good.  And 
while I can imagine scenarios in which you don't want the computer 
to come up at all, I think they would be in the minority compared
to those systems where the admin would prefer the system come up so
it can be reached 'normally' ("normal" interactive login).

If not can you describe how the new functionality results in greater 
system reliability/availability than before, "cuz", I just don't see it.

thanks,
Linda Walsh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
