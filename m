Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p63Jh1pe062956 for <xfs@oss.sgi.com>; Sun, 3 Jul 2011 14:43:02 -0500
Received: from a.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 404961EE6B15
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2011 12:42:59 -0700 (PDT)
Received: from a.mail.sonic.net (a.mail.sonic.net [64.142.16.245]) by
	cuda.sgi.com with ESMTP id eIFmFHD9eE2IbiQG for
	<xfs@oss.sgi.com>; Sun, 03 Jul 2011 12:42:59 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <62289.1309722179@sonic.net>
Date: Sun, 03 Jul 2011 12:42:59 -0700
Subject: Re: xfs_growfs doesn't resize
From: kkeller@sonic.net
Reply-To: kkeller@sonic.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

On Sun, Jul 03, 2011 at 10:59:03AM -0500, Eric Sandeen wrote:
> On 6/30/11 4:42 PM, kkeller@sonic.net wrote:
> > # uname -a
> > Linux sahara.xxx 2.6.18-128.1.6.el5 #1 SMP Wed Apr 1 09:10:25 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux
> > 
> > Yes, it's not a completely current kernel. This box is running CentOS 5
> > with some yum updates.
> 
> try
> 
> # rpm -qa | grep xfs
> 
> If you see anything with "kmod" you're running an exceptionally old xfs codebase.


Yes, I do have a kmod-xfs package, so clearly a kernel update is in
order. So my goals are twofold: 1) verify the current filesystem's
state--is it healthy, or does it need xfs_db voodoo? 2) once it's
determined healthy, again attempt to grow the filesystem. Here is
my current plan for reaching these goals:

0) get a nearer-term backup, just in case :) The filesystem still seems
perfectly normal, but without knowing what my first xfs_growfs did I
don't know if or how long this state will last.

1) umount the fs to run xfs_db

2) attempt a remount--is this safe, or is there risk of damaging the filesystem?

3) If a remount succeeds, then update the kernel and xfsprogs. If a remount
doesn't work, then revert to the near-term backup I took in 0) and attempt
to fix the issue (with the help of the list, I hope).

4) In either case, post my xfs_db output to the list and get your
opinions on the health of the fs.

5) If the fs seems correct, attempt xfs_growfs again.

Do all these steps seem reasonable? I am most concerned about step 2--
I really do want to be able to remount as quickly as possible, but I
do not know how to tell whether it's okay from xfs_db's output. So if a
remount attempt is reasonably nondestructive (i.e., it won't make worse
an already unhealthy XFS fs) then I can try it and hope for the best.
(From the other threads I've seen it seems like it's not a good idea to
run xfs_repair.)

Would it make more sense to update the kernel and xfsprogs before
attempting a remount? If a remount fails under the original kernel,
what do people think the odds are that a new kernel would be able to
mount the original fs, or is that really unwise?

Again, many thanks for all your help.

--keith

-- 
kkeller@sonic.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
