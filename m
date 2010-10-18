Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9ILvJSM027183 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 16:57:19 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D0608F8065
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 14:58:29 -0700 (PDT)
Subject: XFS Master Branch Re-based
From: Alex Elder <aelder@sgi.com>
Date: Mon, 18 Oct 2010 16:56:57 -0500
Message-ID: <1287439017.2382.100.camel@doink>
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

In order to resolve a merge issue, and in preparation
for the imminent 2.6.36 release, I have re-based the
XFS master branch (it now appears to be a series of
commits based on 2.6.36-rc8).

Because of this, if you have local branch that tracks
the XFS master branch you will need to use care in
updating it in order to get the right outcome.  (At
the moment, a simple pull request will most likely
report conflicts.)  You must forcibly update your
local branch to match the newly re-based XFS master
branch.  To do this, you can supply a special refspec
to "git pull".

For example, if your local branch  "xfs-master" is
tracking the XFS "master" branch on oss.sgi.com, you
would force the update like this:
 
   git pull git://oss.sgi.com/xfs/xfs.git +master:xfs-master

This produces a few warning messages.  When I did this with
xfs-master as my current branch I got:
    From git://oss.sgi.com/xfs/xfs
     + 06e6f08...a731cd1 master     -> xfs-master  (forced update)
    Warning: fetch updated the current branch head.
    Warning: fast-forwarding your working tree from
    Warning: commit 06e6f08768cf3e070a557ba812d7a65231e19dd6.
    Already up-to-date.

You can use "git fetch" also, provided "xfs-master" is not
your current branch:

   git fetch git://oss.sgi.com/xfs/xfs.git +master:xfs-master

Here I got:
    From git://oss.sgi.com/xfs/xfs
     + 06e6f08...a731cd1 master     -> xfs-master  (forced update)


One other (unrelated) note, I pushed the 2.6.36-rc8 tag out
and it resulted in a message to the list.  (I've suppressed
these messages in the past and thought I should mention it
since this time one went out.)

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
