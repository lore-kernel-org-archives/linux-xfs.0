Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E6357CA0
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 19:24:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3F997304048
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 17:24:24 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	siQLr992hwNX6nvx for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2016 17:24:21 -0700 (PDT)
Date: Thu, 25 Aug 2016 10:24:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Make __xfs_xattr_put_listen preperly report errors.
Message-ID: <20160825002408.GC19025@dastard>
References: <1471967653-2561-1-git-send-email-asavkov@redhat.com>
	<20160824015551.GB19025@dastard>
	<20160824080833.GA11104@shodan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160824080833.GA11104@shodan.usersys.redhat.com>
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
To: Artem Savkov <asavkov@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 24, 2016 at 10:08:33AM +0200, Artem Savkov wrote:
> On Wed, Aug 24, 2016 at 11:55:51AM +1000, Dave Chinner wrote:
> > On Tue, Aug 23, 2016 at 05:54:13PM +0200, Artem Savkov wrote:
> > > Commit "xfs: only return -errno or success from attr ->put_listent" changes the
> > 
> > Please quote commits in --oneline format in changelogs - it makes it
> > much easier to find the change you are refering to if there is both
> > a commit ID and the text string in the commit message. (i.e. text
> > string confirms the commit id is the one you meant to quote).
> 
> Noted, thanks.
> 
> > 
> > commit 2a6fba6 ("xfs: only return -errno or success from attr
> > ->put_listent") is the one you are refering to here, right?
> 
> Yes, that is the one.
> 
> > > returnvalue of __xfs_xattr_put_listen to 0 in case when there is insufficient
> > > space in the buffer assuming that setting context->count to -1 would be enough,
> > > but all of the ->put_listent callers only check seen_enough. This results in
> > > a failed assertion:
> > > XFS: Assertion failed: context->count >= 0, file: fs/xfs/xfs_xattr.c, line: 175
> > > in insufficient buffer size case.
> > 
> > You have a test case? Can you turn it into an xfstest? We really
> > need regression tests that cover issues like this....
> > 
> 
> llistxattr02 test from LTP reliably hits this, I'll see how this can be
> ported to xfstest.

So, after battling the obtuse, completely useless ltp install
documentation and having to resort to reverse engineering a working
configuration using strace, I finally got this running, I think, on
an XFS filesystem:

/mnt/scratch/ltp$ sudo ./runltp -b /dev/pmem1 -B xfs -z /dev/vdc -Z xfs -q -p -s llistxattr -I 100
....
Summary:
passed   1
failed   0
skipped  0
warnings 0
tst_test.c:756: INFO: Timeout per run is 0h 05m 00s
llistxattr02.c:76: PASS: llistxattr() failed as expected: ERANGE
llistxattr02.c:76: PASS: llistxattr() failed as expected: ENOENT
llistxattr02.c:76: PASS: llistxattr() failed as expected: EFAULT
....

And it doesn't fail. strace output:

24833 lsetxattr("symlink", "security.ltptest", "test", 4, XATTR_CREATE) = 0
24833 llistxattr("symlink", 0x7ffe312356b0, 1) = -1 ERANGE (Numerical result out of range)
24833 llistxattr("", 0x7ffe312356a0, 20) = -1 ENOENT (No such file or directory)
24833 llistxattr(0xffffffffffffffff, 0x7ffe312356a0, 20) = -1 EFAULT (Bad address)

I'm assuming from your description that it is the first one of these
that fails for you as it is the "buffer too small" test case. So,
not as obvious as it first seems - ltp doesn't appear to be a
reliable reproducer of the problem, so we are going to need a custom
test to exercise it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
