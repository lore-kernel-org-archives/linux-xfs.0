Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6223B7F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 18:17:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2E6B830407A
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 16:17:07 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id vIAQFPRB9N0sbYKV (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 16:17:05 -0800 (PST)
Date: Wed, 11 Dec 2013 19:16:55 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
Message-ID: <20131212001655.GA31768@thunk.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
	<20131211074615.GE19248@infradead.org>
	<20131211224012.GJ10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211224012.GJ10988@dastard>
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

On Thu, Dec 12, 2013 at 09:40:12AM +1100, Dave Chinner wrote:
> > 
> > All these tests don't make sense if you never unmount the filesystem.
> > Istead they should exit with _notrun for tmpfs.
> 
> IOWs, adding tmpfs changes the definition of a "generic" test.
> 
> i.e. instead of:
> 
> _supported_fs generic
> 
> these tests are now:
> 
> _supported_fs xfs ext2 ext3 ext4 ext4dev btrfs gfs2 nfs udf reiserfs
> 
> and by that definition should be in the tests/shared directory....

At a higher level, I wonder how useful having the distinction between
"generic" and "shared" really is.  Suppose in the future we add some
tests for networked file systems or cluster file systems --- do we end
up migrating even more tests from "generic" to "shared" when we find
tests that don't work for some new file system?

And to the extent that we have things like 

_require_<feature>

which skips certain tests, it's not even true that all generic tests
are run for all file systems.  So what should be the proper
distinction between generic and shared tests?  Whether we use
"_require_*" vs "_supported_fs"?  And if so, it seems rather arbitrary
that we decide whether not running a test based on the file system
type being <foo> is fundamentally different from deciding not to run a
test becuase we are missing the feature <bar>.

Perhaps it would make more sense to move all of the generic test to
shared, and eliminating the distinction?  That way it also becomes
easier becase we don't need to remember whether a test is generic/NNN
vs shared/NNN.  :-)

Just a thought,

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
