Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 86EE27F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 20:21:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44BD28F8054
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:21:05 -0800 (PST)
Received: from mail-pb0-f48.google.com (mail-pb0-f48.google.com
	[209.85.160.48]) by cuda.sgi.com with ESMTP id DZsgSPaaWVgZtRsX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:21:04 -0800 (PST)
Received: by mail-pb0-f48.google.com with SMTP id md12so11630162pbc.35
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:21:03 -0800 (PST)
Date: Thu, 28 Nov 2013 10:23:53 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] xfstests: add a new test case to test i_size updated
	properly under dio
Message-ID: <20131128022353.GA4019@gmail.com>
References: <1385013394-20379-1-git-send-email-wenqing.lz@taobao.com>
	<20131128003416.GL10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131128003416.GL10988@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Zheng Liu <wenqing.lz@taobao.com>, Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

On Thu, Nov 28, 2013 at 11:34:16AM +1100, Dave Chinner wrote:
> On Thu, Nov 21, 2013 at 01:56:34PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > In this commit a new test case is added to test that i_size is updated
> > properly under dio reads/writes.  We add a program in /src dir, which
> > has a writer to issue some append dio writes.  Meanwhile it has a
> > reader in this test do some dio reads.  As we expect, reader should read
> > nothing or data with 'a'.  But it might read some data with '0'.
> > 
> > This program is used to simulate binary log operations of database
> > application.  In these applications it implements an master/slave
> > synchronziation for database.
> > 
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: Rich Johnston <rjohnston@sgi.com>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  src/Makefile          |    2 +-
> >  src/diotest.c         |  166 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/321     |   56 +++++++++++++++++
> >  tests/generic/321.out |    1 +
> >  tests/generic/group   |    1 +
> >  5 files changed, 225 insertions(+), 1 deletion(-)
> >  create mode 100644 src/diotest.c
> >  create mode 100755 tests/generic/321
> >  create mode 100644 tests/generic/321.out
> > 
> > diff --git a/src/Makefile b/src/Makefile
> > index 84c8297..8c4f592 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -18,7 +18,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> >  	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
> >  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
> >  	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
> > -	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec
> > +	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec diotest
> 
> Fails to compile:
> 
> /tmp/cc54N2JC.o: In function `main':
> /home/dave/src/xfstests-dev/src/diotest.c:120: undefined reference to `pthread_create'
> /home/dave/src/xfstests-dev/src/diotest.c:135: undefined reference to `pthread_join'
> 
> It needs to be linked against libpthread, I think, so that needs to
> be added to the LLDLIBS line, and the appropriate autoconf detection
> macros added. You shoul dbe able to just copy the some
> detection/infrastructure macros across from xfsprogs...

Oops, thanks for the review.  I will fix it later and send a newer one.

                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
