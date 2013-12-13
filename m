Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A3AA37F4E
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 22:56:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9333A8F8052
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 20:56:37 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id wZx1tuQj2V16aYtq (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 20:56:11 -0800 (PST)
Date: Thu, 12 Dec 2013 23:56:03 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
Message-ID: <20131213045603.GG23888@thunk.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
	<20131211074615.GE19248@infradead.org>
	<20131211224012.GJ10988@dastard>
	<20131212180130.GA19422@infradead.org>
	<20131212225657.GK10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212225657.GK10988@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Junho Ryu <jayr@google.com>, hughd@google.com, branto@redhat.com, xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 09:56:57AM +1100, Dave Chinner wrote:
> This case with tmpfs is different - it doesn't support *being
> unmounted* during a test because it is volatile. That's a
> fundamental change to the assumptions xfstests makes about
> filesystems being tested....
> 
> I don't know what the solution here is - everything I think of is
> either messy, ugly or unmaintainable. All I'm trying to do is find a
> way to handle tmpfs filesystems in a way that is maintainable and
> doesn't require every developer to be aware of the quirks of tmpfs
> when writing and reviewing new generic tests....

There should be a relatively small number of reasons why a generic
test would need to umount and remount a file system; the most common
case is so it can run fsck on the file system.

What's actually strange is that is that generic/053 is explicitly
umounting and remounting the file system:

_do 'unmount $SCRATCH_DEV' 'umount $SCRATCH_DEV'
_do 'repair filesystem' '_check_scratch_fs'
_do 'mount filesytem' '_scratch_mount'

In fact, that's not necessary, because _check_test_fs and
_check_scratch_fs will take care of umounting and remounting the file
system.  So if this is the only problem case which Junho has found,
why not just patch generic/053 so it doesn't explicitly umount and
remount the file system, since we've already taught _check_*_fs to be
a no-op for tmpfs.

As for dm_flakey, tests, we can just have _require_dm_flaky be false
for tmpfs file system.

So we're still playing whack-a-mole, yes, but on classes of test
requirements instead of individual tests.  If we address the
umount/remount for fsck and dm_flakey, are there other significant
classes of tests that would still be problematic for tmpfs?

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
