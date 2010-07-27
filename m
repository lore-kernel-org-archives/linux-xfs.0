Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RGD4tl196100 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 11:13:04 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF091304082
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 09:16:06 -0700 (PDT)
Subject: XFS Master Branch Rebase
From: Alex Elder <aelder@sgi.com>
Date: Tue, 27 Jul 2010 11:16:06 -0500
Message-ID: <1280247366.2002.111.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

Some recent commits have resulted in changes to
the XFS master branch that result in non-trivial
merges, which are not something we want to have in
our git history.  (I didn't realize this when I
pushed my last set of updates out, unfortunately.)

To remedy this, I'm have re-based the XFS master
branch on oss.sgi.com against v2.6.35-rc6.

This is important to you if you currently have
a git tree tracking this branch in the XFS
repository, because doing a typical "git pull"
won't produce in the desired result.

Instead, you should issue a command like one
of the following to update your private branch.

If your branch "xfs-master" tracks branch "master"
at git://oss.sgi.com/xfs/xfs.git, and you now
have "xfs-master" checked out, you can do this:
    git pull --rebase -f

If you have a different branch checked out, you
can do this instead to force the re-based commits
to land in your "xfs-master" branch:
    git pull git://oss.sgi.com/xfs/xfs.git +master:xfs-master

Another way to get a current branch to line up with
the newly re-based XFS master branch is  to reset
it to an earlier commit (such as v2.6.35-rc5) and
follow that with a "git pull" command:
    git reset --hard v2.6.35-rc5
    git pull git://oss.sgi.com/xfs/xfs.git master

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
