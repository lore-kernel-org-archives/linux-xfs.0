Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9AD227F3F
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 20:32:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 77DF78F8033
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 18:32:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aEQooGPghYVngTOM for <xfs@oss.sgi.com>;
	Sat, 18 May 2013 18:32:11 -0700 (PDT)
Date: Sun, 19 May 2013 11:32:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: test data integrity under disk failure
Message-ID: <20130519013209.GG6495@dastard>
References: <1368706052-24391-1-git-send-email-dmonakhov@openvz.org>
	<20130516233153.GI24635@dastard> <878v3cv63e.fsf@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <878v3cv63e.fsf@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Sat, May 18, 2013 at 04:13:25PM +0400, Dmitry Monakhov wrote:
> On Fri, 17 May 2013 09:31:53 +1000, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, May 16, 2013 at 04:07:32PM +0400, Dmitry Monakhov wrote:
> > > Parallels team have old good tool called hwflush-check which is server/client
> > > application for testing data integrity under system/disk failure conditions.
> > > Usually we run hwflush-check on two different hosts and use PMU to trigger real
> > > power failure of the client as a whole unit. This tests may be used for
> > > SSD checking (some of them are known to have probelms with hwflush).
> > > I hope it will be good to share it with community.
> > > 
> > > This tests simulate just one disk failure while client system should
> > > survive this failure. This test extend idea of shared/305.
> > > 1) Run hwflush-check server and client on same host as usual
> > > 2) Simulare disk failure via blkdev failt injection API aka 'make-it-fail'
> > > 3) Umount failed device
> > > 4) Makes disk operatable again
> > > 5) Mount filesystem
> > > 3) Check data integrity
> > 
> > So, for local disk failure, why do we need a client/server network
> > architecture? That just complicates the code, and AFAICT
> > 
> > all the client does is send report report packets to server which
> > contain an id number that is kept in memory. If on restart of the
> > client after failure the ID in the report packet doesn't match what
> > the server wants, then it fails the test.
> > 
> > So, why is the server needed here? Just dump the IDs the client
> > writes to the file on a device not being tested, and either diff
> > them against a golden image or run a check to see all the IDs are
> > monotonically increasing. That removes all the networking code from
> > the test, the need for a client/server architecture, etc, and makes
> > the test far easier to review
> In fact the reason is quite simple. Initially the this tool was designed
> for real disk cache testing under power failure conditions. And want to
> share it with community. Off course it is possible to simplify things 
> for 'one hose' case but it is not too big. Let's review it one and keep
> it simple but useful not just for local but also for real power failure
> tests.

It's more that you can't actually use for real power fail testing in
xfstests. Keeping stuff in xfstests that the harness won't or can't
ever use is just an added maintenance burden that we don't need.
xfstests is not a dumping ground for random test source code that
*might* be useful outside xfstests.

Regression tests need to be as simple as possible so their
functioning is obvious and easy to understand. There is nothing
worse than a test failing and having to spend time determining if
the test itself is failing or whether it's uncovered a real bug or
not. And anytime I see a test with 500 lines of test infrasrtucture
that can be replaced with a printf() call and some redirection in
the test harness I see a test that is going to be trouble....

> Fairly to say that initial idea was to add persistent state to FIO.
> But logic starts to getting too complex so we write hwflush-check.

Sure, and now you want to put it in xfstests and the hwflush-check
infrastructure is just too complex....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
