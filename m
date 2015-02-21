Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A6FA7F62
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 01:57:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8826E304066
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 23:57:31 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 5GeTgleK6k7KEe4m (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 23:57:29 -0800 (PST)
Date: Fri, 20 Feb 2015 22:20:00 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150221032000.GC7922@thunk.org>
References: <201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<201502201936.HBH34799.SOLFFFQtHOMOJV@I-love.SAKURA.ne.jp>
	<20150220231511.GH12722@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150220231511.GH12722@dastard>
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
Cc: hannes@cmpxchg.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, torvalds@linux-foundation.org

+akpm

So I'm arriving late to this discussion since I've been in conference
mode for the past week, and I'm only now catching up on this thread.

I'll note that this whole question of whether or not file systems
should use GFP_NOFAIL is one where the mm developers are not of one
mind.

In fact, search for the subject line "fs/reiserfs/journal.c: Remove
obsolete __GFP_NOFAIL" where we recapitulated many of these arguments,
Andrew Morton said that it was better to use GFP_NOFAIL over the
alternatives of (a) panic'ing the kernel because the file system has
no way to move forward other than leaving the file system corrupted,
or (b) looping in the file system to retry the memory allocation to
avoid the unfortunate effects of (a).

So based on akpm's sage advise and wisdom, I added back GFP_NOFAIL to
ext4/jbd2.

It sounds like 9879de7373fc is causing massive file system
errors, and it seems **really** unfortunate it was added so late in
the day (between -rc6 and rc7).

So at this point, it seems we have two choices.  We can either revert
9879de7373fc, or I can add a whole lot more GFP_FAIL flags to ext4's
memory allocations and submit them as stable bug fixes.

Linux MM developers, this is your call.  I will liberally be adding
GFP_NOFAIL to ext4 if you won't revert the commit, because that's the
only way I can fix things with minimal risk of adding additional,
potentially more serious regressions.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
