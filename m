Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4EGO4Fq232204 for <xfs@oss.sgi.com>; Thu, 14 May 2009 11:24:05 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C4212878F6
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 09:24:11 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ljWOX15PrRQBTnnv for
	<xfs@oss.sgi.com>; Thu, 14 May 2009 09:24:11 -0700 (PDT)
Message-ID: <4A0C45AA.3040307@sandeen.net>
Date: Thu, 14 May 2009 11:24:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Questions about xfstests regarding porting it to test ext4
	filesystems
References: <E1M4aRo-0000ri-0G@closure.thunk.org>
In-Reply-To: <E1M4aRo-0000ri-0G@closure.thunk.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: xfs@oss.sgi.com

Theodore Ts'o wrote:
> I've been playing around with xfstests (aka xfsqa) and have some
> questions:
> 
> 1)  What is the best mailing list to use for discussions about xfstests? 
> I'm *not* subscribed to xfs@oss.sgi.com, since I'm concerned about
> traffic levels... I'm on too many high-volume mailing lists already.

This one is fine.  it's not that high-volume but as you've found you
don't have to subscribe, anyway.  :)

> 2)  Why is the TESTDIR have to be a persistent xfs volume?   I noticed
> that when testing UDF and NFS, the scratch volume is used (and $testdir
> is set to the point at the scratch directory).   Is there some
> fundamental reason why there must be an XFS volume mounted, even if the
> fundamental intention is to test some other filesystem type, whether
> it's UDF, NFS, or Ext4?

Hm I'll have to dig, not certain.  I thought that TESTDIR would usually
be used for non-destructive testing, general IO etc, while SCRATCHDIR
would usually be used for any test that required lots of repeatability,
and could therefore be more fs-specific.  But that's handwaving.

> 3) How much latitude/interest is there in modifying xfstests to be a bit
> more filesystem independent?  

I talked about just this at LSF last month and there seemed to be a bit
of interest, it was the best plan we had coming out of the talk.

I also talked about a fledgling effort from RH,
http://git.fedoraproject.org/git/?p=tafs.git;a=summary

> I understand the primary purpose of
> xfstests has to be to support XFS development, but looking at the
> scripts, there is a *huge* amount of XFS-specific assumptions all over
> the shell scripts.  As a result I'm still of two minds whether it will
> be less work to start from scratch to develop a test suite for ext4 (and
> from the beginning try to make it filesystem independent) or to try to
> hack xfstests and try to make it more filesystem indpendent.

Yep, agreed.  I think it's worth evaluating whether the xfstests harness
is within reach of the goal, though.  But you may be right about how
much work it is to get there.

Really the value to other filesystems is in the tests (those which are
or could be made generic), more than the harness, I'd say.

> A lot of
> this depends on the time/interest with the xfstests upstream in working
> with me.  (And assuming we get the licensing issues dealt with --- hence
> my interest and time spent in trying to clarify the licensing situation
> with the fsx program.)   

and at least as importantly, the rest of the scripts, but we're making
progress on that.

> If there isn't a whole lot of interest in trying to make xfstests more
> portable, that's fine.  It may be that I'm better off starting from
> scratch.  There does seem to be a lot of work and experience represented
> in the xfstest suite, though, so I would like to try exploring the
> possibility of expanding its scope to also support testing other
> filesystems (such as ext4, btrfs, etc.)

There is interest, it's what we decided at least preliminarily at LSF,
and now it's the "find time and see if it's feasible" part I guess.

-Eric

> (I'm not on the xfs mailing list, so please keep me cc'ed, thanks.)
> 
> 						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
