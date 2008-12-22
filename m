Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMKTCwU024964 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 14:29:12 -0600
Received: from a.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 961DB408AE
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 12:29:08 -0800 (PST)
Received: from a.mx.filmlight.ltd.uk (alto.filmlight.ltd.uk [217.40.27.25]) by
	cuda.sgi.com with SMTP id ZLRHTy8opTEmNBwN for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 12:29:08 -0800 (PST)
Message-ID: <C73606AC84514BE3B733F818ACCD281B@BODDINGTON>
From: "Roger Willcocks" <roger@filmlight.ltd.uk>
References: <20081222165848.GA17075@infradead.org>
Subject: Re: xfstests testcase 111: Infinite xfs_bulkstat bad-inode loop
	casefrom Roger Willcocks
Date: Mon, 22 Dec 2008 20:28:59 -0000
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

> Hi Roger,
>
> I believe the xfstests case 111 is based on a report by you.  Do you
> remember what was going on there?  From a look at the testcase it
> overwrites an inode cluster and then tries to bulkstat them.  This works
> fine with a non-debug kernel, but due to debug kernels panicing it fails
> there.
>
> Do you remember what the testcase was looking for?  I suspect we should
> just not run it for debug kernels, but I'd like to know more about it
> so we can add comments describing it.
>
> Cheers,
> Christoph
>

Hi Christoph,

here are the relevant extracts from our in-house bugzilla (bug 3675). Since 
the problem only occurs when the disk is corrupted, I don't see any problem 
with skipping the test on debug kernels.

** 2006-02-01

xfs_fsr can get into a state where one processor spends 100% of its time
looping in the kernel. The application can't be killed. 'top' shows it using
50% CPU (i.e. all of one of the two processors).

oprofile reveals that one processor spends about 2/3 of its time in xfs.ko. 
It
looks like the offending syscall is xfs_bulkstat.

** 2006-02-03

Looks like xfs_itobp (map inode number to disk buffer) detects a corrupted
inode (bad magic number). That causes a break out of a loop in xfs_bulkstat,
skipping setting the teminating condition of a containing loop.

I'll file a bug report with SGI.

** 2006-02-03

SGI say 'Ayup, I think you're right'-

http://marc.theaimsgroup.com/?t=113889680200006

** 2006-02-07

A bad inode magic number can cause the xfs_bulkstat syscall to get stuck
looping in the kernel.

To reproduce: (don't try this at home folks!) -

mkfs.xfs /dev/sda
mount filesystem and create 1000 or so files (I copied a handy 313-byte 
file).
run this program:

---------
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>

char buffer[32768];

void nuke()
{
        int i;
        for (i = 2048; i < 32768-1; i++)
                if (buffer[i] == 'I' && buffer[i+1] == 'N')
                        buffer[i] = buffer[i+1] = 'X';
}


                                      int main(int argc, char* argv[])
{
        int f = open("/dev/sda", O_RDWR);
        if (lseek(f, 32768, SEEK_SET) < 0) perror("lseek");
        if (read(f, buffer, 32768) != 32768) perror("read");
        nuke();
        if (lseek(f, 32768, SEEK_SET) < 0) perror("lseek");
        if (write(f, buffer, 32768) != 32768) perror("write");
        close(f);
}
---------

mount the disk and run xfs_fsr. It immediately gets stuck in a kernel loop.

** 2006-02-08

SGI have added a corresponding regression test to the xfs_cmds package

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/111?rev=1.1

--
Roger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
