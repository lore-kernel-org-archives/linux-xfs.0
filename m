Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88F8F7F52
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 15:42:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 771F0304075
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 13:42:19 -0700 (PDT)
Received: from tetsuo.zabbo.net (tetsuo.zabbo.net [50.193.208.193]) by
	cuda.sgi.com with ESMTP id HQ1JDekjVVwAo7Xi for
	<xfs@oss.sgi.com>; Wed, 27 Mar 2013 13:42:18 -0700 (PDT)
Date: Wed, 27 Mar 2013 13:42:17 -0700
From: Zach Brown <zab@zabbo.net>
Subject: Re: Announce re-factor all current xfstests patches request
Message-ID: <20130327204217.GC16651@lenny.home.zabbo.net>
References: <5152F2BB.4000709@sgi.com> <20130327134606.GJ5861@thunk.org>
	<5153217B.5070909@sgi.com> <20130327190512.GA22889@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130327190512.GA22889@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Rich Johnston <rjohnston@sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 27, 2013 at 03:05:12PM -0400, Theodore Ts'o wrote:
> What do you think about renaming the existing tests from NNN to
> NNN-descriptive-name?  That way it will be easier for people who are
> trying to track regressions, since they can easily map from the new
> more descriptive name to the old test number for comparison purposes
> (i.e., to see whether a failure is a regression or not, etc.)

It does seem like a good idea to help people map from descriptive names
to their previous numeric file names.

But do we want to bake it in to the file names forevermore?  Would it be
good enough to start the old tests with something like

_was_test_nr 45

that spits out the old test number in the log?

Just thinking out loud over here.

- z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
