Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p14Eo5x3021331
	for <linux-xfs@oss.sgi.com>; Fri, 4 Feb 2011 08:50:05 -0600
Received: from complete.lackof.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 876BB2B0A27
	for <linux-xfs@oss.sgi.com>; Fri,  4 Feb 2011 06:52:33 -0800 (PST)
Received: from complete.lackof.org (complete.lackof.org [198.49.126.79]) by
	cuda.sgi.com with ESMTP id KyrvHN9EDEW6u59F for
	<linux-xfs@oss.sgi.com>; Fri, 04 Feb 2011 06:52:33 -0800 (PST)
Date: Fri, 4 Feb 2011 07:52:30 -0700
From: dann frazier <dannf@dannf.org>
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug
	get into	Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
Message-ID: <20110204145230.GA2329@dannf.org>
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110203045836.GV11040@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com, mlueck@lueckdatasystems.com

On Thu, Feb 03, 2011 at 03:58:36PM +1100, Dave Chinner wrote:
> On Wed, Feb 02, 2011 at 12:32:59PM -0600, Bill Kendall wrote:
> > On 02/02/2011 07:30 AM, Michael Lueck wrote:
> > >Greetings,
> > >
> > >Somehow a reported IRIX bug with XFS got into Ubuntu 10.04 (Lucid) starting with kernel 2.6.32-27.
> > >
> > >I am cross posting to this list in order to receive details as to what bug got in Ubuntu which has
> > >been solved in IRIX, hoping with more details Ubuntu might make the same fix.
> > 
> > Aside from the fact that the errno is the same, there's nothing to suggest
> > that the Ubuntu problem is the the same bug. The IRIX bug is quite old.
> > 
> > >
> > >Ubuntu has since updated their kernel to 2.6.32-28 and someone already verified at the bug report
> > >that the problem persists with that kernel version.
> > >
> > >"Regression between 2.6.32-27 and 2.6.32-26 xfsdump SGI_FS_BULKSTAT errno = 22"
> > >https://bugs.launchpad.net/bugs/692848
> > 
> > Between 2.6.32-26 and 2.6.32-27, Ubuntu backported 4 XFS commits from
> > 2.6.35/2.6.36. All are part of a bulkstat security fix.
> > 
> > % git log Ubuntu-2.6.32-26.48..Ubuntu-2.6.32-27.49 -- fs/xfs | grep commit
> > commit 52d2a4cfbc852da8c3d3b9fa0cac2a07b12f5cfd
> >     (cherry picked from commit 4536f2ad8b330453d7ebec0746c4374eadd649b1)
> > commit eb5ab28c8a5e4bb3f1ce05eba166c12175f6c701
> >     (backported from commit 7b6259e7a83647948fa33a736cc832310c8d85aa)
> > commit 5f8e8c6ab416bbd58d4f5df512c119a888ff923c
> >     (cherry picked from commit 1920779e67cbf5ea8afef317777c5bf2b8096188)
> > commit 52e0d703745f7110f1ecbe83c02cf06a83da82e8
> >     (backported from commit 7124fe0a5b619d65b739477b3b55a20bf805b06d)
> > 
> > I'm not aware of a similar problem upstream, so it would appear
> > to be a problem with Ubuntu's backport of these commits.
> 
> <sigh>
> 
> That'll be the untrusted inode lookup fixes.
> 
> > 
> > Bill
> > 
> > >
> > >On our Ubuntu 10.04 LTS server running x86 code, this evening a kernel
> > >update was ready for installation. I updated the kernel, rebooted
> > >(IPL'ed), and proceeded with the backup which utilized xfsdump as we use
> > >the xfs filesystem. Four of the xfsdump received a never before seen
> > >error: SGI_FS_BULKSTAT errno = 22
> > >
> > >Output as follows:
> > >using file dump (drive_simple) strategy
> > >version 3.0.4 (dump format 3.0) - Running single-threaded
> > >level 0 dump of ldslnx01:/srv
> > >dump date: Mon Dec 20 21:59:33 2010
> > >session id: f98f8cc0-963f-41a6-9a19-a89192502bf0
> > >session label: "data"
> > >ino map phase 1: constructing initial dump list
> > >ino map phase 2: skipping (no pruning necessary)
> > >ino map phase 3: skipping (only one dump stream)
> > >ino map construction complete
> > >estimated dump size: 100739707392 bytes
> > >WARNING: no media label specified
> > >creating dump session media file 0 (media 0, file 0)
> > >dumping ino map
> > >dumping directories
> > >SGI_FS_BULKSTAT failed: Invalid argument (22)
> > >dump size (non-dir files) : 0 bytes
> > >NOTE: dump interrupted: 79 seconds elapsed: may resume later using -R option
> > >Dump Status: INTERRUPT
> 
> So bulkstat got EINVAL returned for and inode that it was looking
> up. That implies that it was racing with an unlink, which is
> what the above commits catch and prevent. Can you run xfsdump with
> full debug output (-v 5) so we can see what inode is being operated
> on when this failure occurs?
> 
> Dann, I'm not sure whether this means there was a bug in your
> backport or whether it's just xfsdump not handling a failure
> gracefully....

Yeah, I'm not sure either. I've attempted to reproduce it, but have so
far not been successful. I'll try to get a 32-bit test system setup in
case that makes a difference.

> > >This backup file did have some size to it. The other three, backing up
> > >smaller amounts of data, were all zero (0) length dump files.
> > >
> > >I rebooted to the prior kernel: $ uname -a
> > >Linux ldslnx01 2.6.32-26-generic-pae #48-Ubuntu SMP Wed Nov 24 10:31:20 UTC 2010 i686 GNU/Linux
> > >
> > >And the same backup gets to 100% success.
> > >
> > >Reboot to the new kernel, same failure.
> > >
> > >I think that fairly well illustrates that the problem exists only with
> > >the kernel update installed this evening.
> > >
> > ><><><><>
> > >
> > >I did come across a reference to this problem on the SGI website:
> > >
> > >http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?coll=0650&db=relnotes&fname=/usr/relnotes/eoe
> > >1.6.17 Bugs fixed in IRIX 6.5.13
> > >+ 816457: xfsdump SGI_FS_BULKSTAT errno = 22 cxfs
> > >
> > >So evidently it is something that has been seen and corrected in IRIX.
> 
> Oh, the curse of Google.
> 
> Irix 6.5.13 was released in 2001, so I don't think this is at all
> relevant for a regression reported for the latest and greatest Ubuntu
> kernel....
> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
