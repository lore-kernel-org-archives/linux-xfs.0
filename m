Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5ADFB29DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 23:08:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 388F730407A
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 21:08:17 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7RcOLGr5M5eCkgKC for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 21:08:11 -0800 (PST)
Date: Tue, 3 Dec 2013 16:08:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: tree updated to 0a7f216b
Message-ID: <20131203050807.GZ8803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi folks,

I've just committed some outstanding patches to the xfstests
repository. The commits are listed below for your information,
with the current head being:

0a7f216b7962fd15e0fd749110776ca69b718932 generic: add a rename fsync test

Some book-keeping stuff follows.

Firstly, I'm going to look into adding commit hooks into the
xfstests repository to get it send automated commit message emails
when the repo is updated like is done for the main xfs kernel
repository. That will save having to walk through every patch
replying to say "applied".

I'd like to start by getting those emails sent to the XFS, btrfs and
ext4 mailing lists, but I'm open to having them sent elsewhere, too.
I'm open to ideas about whether this is too many lists or
whether there are other lists we should send such email to.

Secondly, you might note that I rewrote the subject lines of the
commits below. The main reason for doing this is to make the git log
readable and to give an idea of what was changed in the commit. So,
some new conventions I'd like to see people try to use for their
xfstests patch descriptions.

	1. the first word describes the tests/ subdirectory the
	   change belongs to. e.g. xfs, btrfs, generic, shared, etc

	2. if it's an infrastructure change or touches multiple
	   different sets of tests, then use "xfstests" as the keyword

	3. Don't use test numbers in commit messages or subject
	   lines for new tests. We typically have to renumber tests
	   as part of the commit process, so if we forget to modify
	   the commit message then it looks rather strange....

	4. when fixing a specific test, always refer to it as
	   "<subdir>/<name>", such as generic/273 or btrfs/022.
	   This is needed because we can have duplicate test names
	   in different sub directories.

Hence a typical set of subjects might be:

xfs: fix fubaroo in xfs/299
generic: use correct frobnozzle on generic/230
xfstests: prevent bozo errors when compiling ltp/iogen.c

This makes life easier when browsing the commit history. I'll be
modifying subject lines as I process them to follow these
conventions, so if people adopt them it makes it better for
everyone.

Lastly, I'm going to try to keep the commit latency of reviewed
xfstests patches to around 24-48 hours after the patch has been
reviewed. I don't want reviewed patches to sit around for weeks
before they are committed, so please ping the patch if it's been
reviewed and not committed after a couple of days.

Thanks all,

Dave.

----

Anand Jain (1):
      * [ed14876] btrfs: test if raids are actually created

Brian Foster (1):
      * [0746f7b] generic: use correct size value in generic/273

Christoph Hellwig (1):
      * [c041421] xfstests: stop special casing nfs and udf

Jie Liu (1):
      * [5bcbff9] xfs: verify xfs_quota commands against invalid mount path

Josef Bacik (3):
      * [cb5dd61] btrfs: add basic qgroup testing
      * [640d1e1] generic: add new test for fsync() on directories
      * [0a7f216] generic: add a rename fsync test

Miao Xie (1):
      * [bd50b75] btrfs: add wrong compression type regression test

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
