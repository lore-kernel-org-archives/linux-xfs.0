Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 56FE27F50
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 04:15:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD7A4AC001
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 02:15:01 -0700 (PDT)
Received: from mail-pd0-f179.google.com (mail-pd0-f179.google.com
	[209.85.192.179]) by cuda.sgi.com with ESMTP id
	LfAPvXNxW1WQDrNk (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 02:15:00 -0700 (PDT)
Received: by mail-pd0-f179.google.com with SMTP id q10so4235706pdj.24
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 02:15:00 -0700 (PDT)
Date: Mon, 13 May 2013 17:32:45 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v4] xfstests: add a new test case for ext4 indirect-based
	file
Message-ID: <20130513093245.GA8570@gmail.com>
References: <1368358464-11173-1-git-send-email-wenqing.lz@taobao.com>
	<20130513004439.GJ32675@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130513004439.GJ32675@dastard>
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
Cc: Rich Johnston <rjohnston@sgi.com>, Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, May 13, 2013 at 10:44:39AM +1000, Dave Chinner wrote:
> On Sun, May 12, 2013 at 07:34:24PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > After applied this commit (864688d3), xfstests #255 will not test a
> > file system that cannot support fallocate(2), such as a indirect-based
> > file in ext4.  So we need to add a new generic test case to test it.
> > 
> > The difference between #255 and this test case is only to use pwrite to
> > allocate blocks.  Other filesystems should survive in this test case.
> > In the mean time, a new argument '-u' is added into _test_generic_punch
> > not to run unwritten tests.
> > 
> > Meanwhile this commit fixes a minor problem in #255 that testfile should
> > use $seq.$$ as testfile.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Cc: Eric Sandeen <sandeen@sandeen.net>
> > Cc: Dave Chinner <david@fromorbit.com>
> > Cc: Rich Johnston <rjohnston@sgi.com>
> 
> This will need to be rebased on top of Eric's patch that removes the
> need to pass -F to xfs_io for non-xfs filesystems....

Hi Dave,

Thanks for review.  I guess that you metioned this patch, right?
  [PATCH] xfstests: automatically add -F to xfs_io on non-xfs

But I couldn't find it in xfstests tree.  Has it been applied into the
tree?  Or maybe I use a wrong tree to generate my patch.  I clone the
tree from here:
  git://oss.sgi.com/xfs/cmds/xfstests

Is that right?  Or maybe I need to apply Eric's patch manually and
rebase my patch?

> 
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -114,3 +114,4 @@
> >  309 auto quick
> >  310 auto
> >  311 auto metadata log
> > +314 auto quick prealloc
> 
> Why would you add it to the prealloc group? The whole point of the
> test is that it doesn't use prealloc, right?

Good catch!  Fix it soon.

Thanks,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
