Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IGeUuR217614 for <xfs@oss.sgi.com>; Fri, 18 May 2012 11:40:30 -0500
Date: Fri, 18 May 2012 11:45:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Badness in xfs_write at fs/xfs/linux-2.6/xfs_lrw.c:838
Message-ID: <20120518164510.GP16099@sgi.com>
References: <23d352591001210116s73926b58g97173d8a1b1e82c3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <23d352591001210116s73926b58g97173d8a1b1e82c3@mail.gmail.com>
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
To: andutt <andreas.utterberg@gmail.com>
Cc: xfs@oss.sgi.com

Andutt,

On Thu, Jan 21, 2010 at 10:16:45AM +0100, andutt wrote:
> I have some problem with an XFS filesystem, im running Suse SLES 10
> SP2, with 2.6.16.60-0.42.7-smp kernel untop of a veritas 1Tb volume, a
> couple of times per day i get following in my kernel log.
> 
> Badness in xfs_write at fs/xfs/linux-2.6/xfs_lrw.c:838

(I am picking up this old thread for the benefit of the mail archive, whose
results I found to be inadequate.  Hopefully what follows is sufficient
explanation of this warning for the next poor fool.  It may even be correct.)

I was able to reproduce this (once) by running the following overnight:

while true; do dd if=/dev/zero of=file conv=notrunc bs=4k count=1000 oflag=direct; done
while true; do dd if=file of=/dev/null bs=1k count=10000 iflag=direct; done
while true; do dd if=file of=/dev/null bs=4k count=10000; done
while true; do dd if=file of=/dev/null bs=4k count=10000; done
while true ; do dd if=file of=/dev/null bs=1k count=1000; done
while true; do dd if=file of=/dev/null bs=4k count=10000; done
while true ; do dd if=file of=/dev/null bs=1k count=1000; done          * 'ish
while true ; do dd if=file of=/dev/null bs=1k count=1000; done          * 'ish

* ish... maybe this is what I ran.  It's not in scrollback.

I believe what we are seeing is a thin race between the direct write and the
buffered readers adding cached pages to the file.  It looks to me that the
direct write and the readers all take the iolock shared.  So there is no
exclusion between them when the direct write checks for cached pages in the
file to determine whether to take the iolock exclusive to flush them out, and
when the actual flushing and WARN_ON occur.  The buffered readers can read data
from disk into the cache during this window and this causes the WARN_ON to
fire.

The standard advice given here is:  "Don't do direct and buffered io
concurrently on the same file."

It seems to me that having pages cached during the direct write isn't
necessarily a problem.  These pages might be at offsets that do not overlap
with the direct write, and this would be a perfectly valid usage of concurrent
direct and buffered io.  I believe the required semantics of an overlapping
buffered/direct situation are undefined (I could be horribly wrong).  And XFS
leaves it up to the application to use adequate locking to prevent overlapping
concurrent buffered and direct io.  It looks like running flushinval with
iolock shared is not a problem here, and there cannot be any dirty pages
because the direct write has the iolock shared and buffered writes take it
exclusive.

I suggest you 1) be certain that your application is doing the Right Thing, and
then 2) ignore the warning.

It really is up to the application to do the right thing in this area.  And the
warning doesn't (necessarily) indicate that the application did something
wrong, just that it could have.

This warning has been removed from xfs in v3.1 (see c58cb165). 

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
