Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBN7qgqw210462 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 01:52:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2460912E968C
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 23:53:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SDgUnJCkWzxZqe3R for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2009 23:53:25 -0800 (PST)
Date: Wed, 23 Dec 2009 02:53:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: utimensat fails to update ctime
Message-ID: <20091223075302.GA27744@infradead.org>
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
	<20091222123436.GC9611@discord.disaster> <4B30BEC9.5030706@byu.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B30BEC9.5030706@byu.net>
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
To: Eric Blake <ebb9@byu.net>
Cc: Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, xfs@oss.sgi.com

On Tue, Dec 22, 2009 at 05:42:49AM -0700, Eric Blake wrote:
> According to Dave Chinner on 12/22/2009 5:34 AM:
> > Yeah, it looks like the change to utimesat() back in 2.6.26 for
> > posix conformance made ATTR_CTIME appear outside inode truncation
> > and XFS wasn't updated for this change in behaviour at the VFS level.
> > Looks simple to fix, but I'm worried about introducing other
> > unintended ctime modifications - is there a test suite that checks
> > posix compliant atime/mtime/ctime behaviour around anywhere?
> 
> Yes - the gnulib unit test, consisting of:
> 
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/nap.h
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-utimens-common.h
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-utimens.h
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-lutimens.h
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-futimens.h
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-futimens.c
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-utimensat.c
> 
> Taken together, these files produce the executables test-futimens and
> test-utimensat which can demonstrate compliance with POSIX.  They are also
> bundled as part of GNU coreutils (the version bundled with coreutils 8.2
> didn't test for ctime compliance, and coreutils 8.3 hasn't been released
> yet) if you use 'make -C gnulib-tests check'.

Ok, I'll see if I can add the last GPLv2 licensed version into xfstests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
