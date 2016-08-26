Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73A187CEC
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 03:59:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 319BB304043
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 01:59:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qq1sThZmwDg8eJ2L (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2016 01:59:30 -0700 (PDT)
Date: Fri, 26 Aug 2016 10:59:28 +0200
From: Artem Savkov <asavkov@redhat.com>
Subject: Re: [PATCH] Make __xfs_xattr_put_listen preperly report errors.
Message-ID: <20160826085928.GA15715@shodan.usersys.redhat.com>
References: <1471967653-2561-1-git-send-email-asavkov@redhat.com>
	<20160824015551.GB19025@dastard>
	<20160824080833.GA11104@shodan.usersys.redhat.com>
	<20160825002408.GC19025@dastard>
	<20160825082109.GB11104@shodan.usersys.redhat.com>
	<20160825224215.GF19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160825224215.GF19025@dastard>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 08:42:15AM +1000, Dave Chinner wrote:
> On Thu, Aug 25, 2016 at 10:21:09AM +0200, Artem Savkov wrote:
> > On Thu, Aug 25, 2016 at 10:24:08AM +1000, Dave Chinner wrote:
> > > On Wed, Aug 24, 2016 at 10:08:33AM +0200, Artem Savkov wrote:
> > > > On Wed, Aug 24, 2016 at 11:55:51AM +1000, Dave Chinner wrote:
> > > > > On Tue, Aug 23, 2016 at 05:54:13PM +0200, Artem Savkov wrote:
> > > > > > Commit "xfs: only return -errno or success from attr ->put_listent" changes the
> > > > > 
> > > > > Please quote commits in --oneline format in changelogs - it makes it
> > > > > much easier to find the change you are refering to if there is both
> > > > > a commit ID and the text string in the commit message. (i.e. text
> > > > > string confirms the commit id is the one you meant to quote).
> > > > 
> > > > Noted, thanks.
> > > > 
> > > > > 
> > > > > commit 2a6fba6 ("xfs: only return -errno or success from attr
> > > > > ->put_listent") is the one you are refering to here, right?
> > > > 
> > > > Yes, that is the one.
> > > > 
> > > > > > returnvalue of __xfs_xattr_put_listen to 0 in case when there is insufficient
> > > > > > space in the buffer assuming that setting context->count to -1 would be enough,
> > > > > > but all of the ->put_listent callers only check seen_enough. This results in
> > > > > > a failed assertion:
> > > > > > XFS: Assertion failed: context->count >= 0, file: fs/xfs/xfs_xattr.c, line: 175
> > > > > > in insufficient buffer size case.
> > > > > 
> > > > > You have a test case? Can you turn it into an xfstest? We really
> > > > > need regression tests that cover issues like this....
> > > > > 
> > > > 
> > > > llistxattr02 test from LTP reliably hits this, I'll see how this can be
> > > > ported to xfstest.
> > > 
> > > So, after battling the obtuse, completely useless ltp install
> > > documentation and having to resort to reverse engineering a working
> > > configuration using strace, I finally got this running, I think, on
> > > an XFS filesystem:
> > > 
> > > /mnt/scratch/ltp$ sudo ./runltp -b /dev/pmem1 -B xfs -z /dev/vdc -Z xfs -q -p -s llistxattr -I 100
> > > ....
> > > Summary:
> > > passed   1
> > > failed   0
> > > skipped  0
> > > warnings 0
> > > tst_test.c:756: INFO: Timeout per run is 0h 05m 00s
> > > llistxattr02.c:76: PASS: llistxattr() failed as expected: ERANGE
> > > llistxattr02.c:76: PASS: llistxattr() failed as expected: ENOENT
> > > llistxattr02.c:76: PASS: llistxattr() failed as expected: EFAULT
> > > ....
> > > 
> > > And it doesn't fail. strace output:
> > > 
> > > 24833 lsetxattr("symlink", "security.ltptest", "test", 4, XATTR_CREATE) = 0
> > > 24833 llistxattr("symlink", 0x7ffe312356b0, 1) = -1 ERANGE (Numerical result out of range)
> > > 24833 llistxattr("", 0x7ffe312356a0, 20) = -1 ENOENT (No such file or directory)
> > > 24833 llistxattr(0xffffffffffffffff, 0x7ffe312356a0, 20) = -1 EFAULT (Bad address)
> > > 
> > > I'm assuming from your description that it is the first one of these
> > > that fails for you as it is the "buffer too small" test case. So,
> > > not as obvious as it first seems - ltp doesn't appear to be a
> > > reliable reproducer of the problem, so we are going to need a custom
> > > test to exercise it....
> > 
> > LTP doesn't check dmesg for warnings on it's own, so it is ok for the test
> > to be marked as "PASSED" since we get ERANGE after all. But you should
> > be able to see the warnings in dmesg.
> 
> Of course. My systems are set up so that any critical message that
> comes through dmesg is wall'd to all active sessions, so it doesn't
> matter that xfstests or ltp doesn't capture the error, I know it's
> happened.
> 
> Besides, I always use CONFIG_XFS_DEBUG=y, which means these things
> BUG() rather than just print a warning, and that tends to be fatal
> in more ways than one...
> 
> > I'm attaching the config I'm using. With this config I can repdroduce the
> > issue with both 4.8-rc3 and next-20160825.
> 
> What I suggest you do is try to recreate the problem manually. I'm
> pretty certain I know what is different between our test
> environments that is resulting in me not seeing the problem
> but, really, we need more people with root cause analysis skills
> around here so I don't have to spend time solving every problem that
> is reported.
> 
> That is, it's all well and good to send a patch to fix a problem,
> but if we don't understand the root cause of the problem being
> fixed, then we have no idea whether we've fixed the problem fully or
> not.  Part of understanding the root cause is finding a reliable
> reproducer of the problem, part of it is reading and understanding
> the code being fixed, and part of it is understanding the
> environment and behaviour that demonstrates the problem.
> 
> So when I look at the fix, and see that it doesn't reproduce on my
> systems, it's clear that it's either not yet fully understood or
> hasn't been fully explained by the person who understands the issue.
> These are some of the questions I've asked myself to understand why
> we are seeing what we've been seeing:
> 
> 	- what condition in the unfixed code leads to the ASSERT
> 	  being tripped?
> 	- how does the patch prevent that from occurring?
> 	- at what threshold does the problem trigger (i.e. n=0, n=1,
> 	  n=2 .... ?)
> 	- how do the environmental initial conditions affect the
> 	  test being run?
> 	- what do security layers automatically store in the inode
> 	  at creation time?
> 	- how can we modify the test to always trigger the assert?
> 
> I know the answer, and it would take much less time to tell everyone
> that it does to write an email like this.  But that means I'll just
> have to do the same thing next time, and the next time, and so on.
> The more people we have that can think through issues like this and
> come to the right conclusion without needing my help, the better off
> we'll all be...

Fair enough.

The problem only shows itself with a minimum of 2 xattrs and only when
the buffer gets depleted before the last one. LTP's llistxattr02 test
only sets one xattr, but on my testsystem "security.selinux" attribute
is automatically added on file creation which allows this bug to be
reproduced. So I would assume that on your systems there are no
automatically created xattrs and thats why you can't reproduce this.

Furthermore if buffersize is such that it is enough to hold the last
xattr's name, but not enough to hold the sum of preceeding xattrs
listxattr won't fail with ERANGE, but will suceed returning that xattr's
name without the first character. The first character end's up
overwriting whatever is stored at (context->alist - 1).

This should also answer Eric's question on whether it only affects the
ASSERT.

-- 
Regards,
  Artem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
